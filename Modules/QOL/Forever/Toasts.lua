-- =====================================================================
-- Modules/QOL/Forever/Toasts.lua -- notifications and level-up celebration
--
-- Notifications: small bronze banners stacked under an anchor at the top
-- of the screen. Each kind can be switched off:
--   * quest turned in (XP and money it gave)
--   * quest ready: every objective of a quest of your log is done
--   * loot of a chosen quality or better (rare by default)
--   * new standing with a faction (not every reputation gain)
--   * new area discovered
--   * spells learned (a "Train all" at the trainer gives one banner)
-- The messages are read from the game's own strings (LOOT_ITEM_SELF,
-- FACTION_STANDING_CHANGED, ERR_ZONE_EXPLORED, ERR_LEARN_SPELL_S...)
-- turned into patterns, so every client language works.
--
-- Level up: a ring opens in the middle of the screen, "Level N" pops,
-- embers fly out and, at even levels (when Forever trainers teach), a line
-- says how many spells wait at the class trainer (TrainerReminder data).
-- When it is on, the XP bar (EdgeXP.lua) keeps its sweep and leaves the
-- big title to this module.
--
-- Everything follows the global animation level (TomoMod_Utils.AnimLevel):
-- full = slides, rings and embers; reduced = fades only; none = appears
-- and disappears at once. Not secure frames: safe in combat.
-- =====================================================================

TomoMod_Toasts = TomoMod_Toasts or {}
local TS = TomoMod_Toasts

local FONT      = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local FONT_BOLD = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-SemiBold.ttf"
local FONT_BLACK = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Bold.ttf"
local SOLID     = "Interface\\Buttons\\WHITE8X8"
local TEX       = "Interface\\AddOns\\TomoModForever\\Assets\\Textures\\"
local RING      = TEX .. "Cursor\\Ring.tga"
local RING_DASH = TEX .. "Animation\\RingDash.tga"
local GLOW      = TEX .. "Animation\\Glow.tga"
local EMBER     = TEX .. "Animation\\Ember.tga"

local ICON_QUEST     = "Interface\\GossipFrame\\ActiveQuestIcon"
local ICON_READY     = "Interface\\RaidFrame\\ReadyCheck-Ready"
local ICON_REP       = "Interface\\Icons\\Achievement_Reputation_01"
local ICON_DISCOVERY = "Interface\\Icons\\INV_Misc_Map_01"
local ICON_SPELL     = "Interface\\Icons\\INV_Misc_Book_09"

-- WoW: Forever palette
local BRONZE = { 0.545, 0.420, 0.247 }
local GOLD   = { 0.788, 0.635, 0.322 }
local YELLOW = { 1.000, 0.820, 0.000 }
local TEXT   = { 0.949, 0.922, 0.859 }
local GREEN  = { 0.450, 0.850, 0.400 }
local BLUE   = { 0.400, 0.700, 1.000 }

local TOAST_W, TOAST_H, GAP = 290, 50, 6
local FADE_OUT = 0.45

local IS_FR = GetLocale() == "frFR"
local function T(fr, en)
    if TomoMod_GUIT then return TomoMod_GUIT(fr, en) end
    return IS_FR and fr or en
end

local function DB() return TomoModForeverDB and TomoModForeverDB.toasts end
local function LDB() return TomoModForeverDB and TomoModForeverDB.levelUp end

local function AnimAny()
    local U = TomoMod_Utils
    return not (U and U.AnimAny) or U.AnimAny()
end
local function AnimFull()
    local U = TomoMod_Utils
    return not (U and U.AnimFull) or U.AnimFull()
end

local function Plain(v)
    if issecretvalue and issecretvalue(v) then return nil end
    return v
end

local function Coins(copper)
    if not copper or copper <= 0 then return nil end
    if C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString then
        return C_CurrencyInfo.GetCoinTextureString(copper)
    elseif GetCoinTextureString then
        return GetCoinTextureString(copper)
    end
    return tostring(copper)
end

local function Num(n)
    if BreakUpLargeNumbers then return BreakUpLargeNumbers(n) end
    return tostring(n)
end

-- ---------------------------------------------------------------------
-- Game strings -> patterns
-- ---------------------------------------------------------------------
-- "You are now %s with %s." -> "^You are now (.-) with (.-)%.$", plus the
-- order of the captures when the string uses "%2$s" placeholders.
local function FormatToPattern(fmt)
    if type(fmt) ~= "string" or fmt == "" then return nil end
    local order, n = {}, 0
    -- Placeholders first ("%s", "%d", "%2$s"), as markers...
    local p = fmt:gsub("%%%%", "\002")      -- a literal "%" in the message
    p = p:gsub("%%(%d?)%$?([sd])", function(pos, kind)
        n = n + 1
        order[n] = tonumber(pos) or n
        return "\001" .. kind
    end)
    -- ...then every magic character left, "%" included...
    p = p:gsub("([%%%(%)%.%[%]%*%+%-%?%^%$])", "%%%1")
    -- ...then the markers become captures.
    p = p:gsub("\001s", "(.-)"):gsub("\001d", "(%%d+)"):gsub("\002", "%%%%")
    return "^" .. p .. "$", order
end

local function Matcher(...)
    local list = {}
    for i = 1, select("#", ...) do
        local fmt = select(i, ...)
        local pat, order = FormatToPattern(fmt)
        if pat then list[#list + 1] = { pat = pat, order = order } end
    end
    return function(msg)
        for _, m in ipairs(list) do
            local caps = { msg:match(m.pat) }
            if caps[1] then
                local out = {}
                for i, v in ipairs(caps) do out[m.order[i] or i] = v end
                return out
            end
        end
    end
end

local matchLoot, matchLootMulti, matchStanding, matchDiscovery, matchSpell

local function BuildMatchers()
    local G = _G
    matchLootMulti = Matcher(G.LOOT_ITEM_SELF_MULTIPLE, G.LOOT_ITEM_PUSHED_SELF_MULTIPLE,
        G.LOOT_ITEM_CREATED_SELF_MULTIPLE)
    matchLoot = Matcher(G.LOOT_ITEM_SELF, G.LOOT_ITEM_PUSHED_SELF, G.LOOT_ITEM_CREATED_SELF,
        G.LOOT_ITEM_BONUS_ROLL_SELF)
    matchStanding = Matcher(G.FACTION_STANDING_CHANGED)
    matchDiscovery = Matcher(G.ERR_ZONE_EXPLORED_XP, G.ERR_ZONE_EXPLORED)
    matchSpell = Matcher(G.ERR_LEARN_SPELL_S, G.ERR_LEARN_ABILITY_S, G.ERR_LEARN_PASSIVE_S)
end
TS._FormatToPattern = FormatToPattern

-- ---------------------------------------------------------------------
-- Toast frames
-- ---------------------------------------------------------------------
local anchor
local pool, active, queue = {}, {}, {}
local preview = false

local function Frame4(parent, layer, size)
    local e = {}
    for i = 1, 4 do
        e[i] = parent:CreateTexture(nil, layer or "BORDER")
        e[i]:SetTexture(SOLID)
    end
    e[1]:SetPoint("TOPLEFT"); e[1]:SetPoint("TOPRIGHT"); e[1]:SetHeight(size)
    e[2]:SetPoint("BOTTOMLEFT"); e[2]:SetPoint("BOTTOMRIGHT"); e[2]:SetHeight(size)
    e[3]:SetPoint("TOPLEFT"); e[3]:SetPoint("BOTTOMLEFT"); e[3]:SetWidth(size)
    e[4]:SetPoint("TOPRIGHT"); e[4]:SetPoint("BOTTOMRIGHT"); e[4]:SetWidth(size)
    function e:SetColor(c, a) for i = 1, 4 do self[i]:SetVertexColor(c[1], c[2], c[3], a or 1) end end
    return e
end

local Reflow, Release -- forward

local function CreateToast()
    local t = CreateFrame("Button", nil, anchor)
    t:SetSize(TOAST_W, TOAST_H)
    t:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    local bg = t:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(SOLID)
    bg:SetVertexColor(0.06, 0.05, 0.04, 0.92)
    Frame4(t, "BORDER", 1):SetColor(BRONZE)

    t.accent = t:CreateTexture(nil, "ARTWORK")
    t.accent:SetTexture(SOLID)
    t.accent:SetPoint("TOPLEFT", 1, -1)
    t.accent:SetPoint("BOTTOMLEFT", 1, 1)
    t.accent:SetWidth(3)

    local holder = CreateFrame("Frame", nil, t)
    holder:SetSize(34, 34)
    holder:SetPoint("LEFT", 10, 0)
    t.iconEdge = Frame4(holder, "BORDER", 1)
    t.icon = holder:CreateTexture(nil, "ARTWORK")
    t.icon:SetPoint("TOPLEFT", 1, -1)
    t.icon:SetPoint("BOTTOMRIGHT", -1, 1)

    t.kind = t:CreateFontString(nil, "OVERLAY")
    t.kind:SetFont(FONT_BOLD, 9, "OUTLINE")
    t.kind:SetPoint("TOPLEFT", holder, "TOPRIGHT", 9, 0)
    t.kind:SetPoint("RIGHT", t, "RIGHT", -10, 0)
    t.kind:SetJustifyH("LEFT")
    t.kind:SetWordWrap(false)

    t.text = t:CreateFontString(nil, "OVERLAY")
    t.text:SetFont(FONT_BOLD, 12, "OUTLINE")
    t.text:SetPoint("TOPLEFT", t.kind, "BOTTOMLEFT", 0, -2)
    t.text:SetPoint("RIGHT", t, "RIGHT", -10, 0)
    t.text:SetJustifyH("LEFT")
    t.text:SetWordWrap(false)

    t.sub = t:CreateFontString(nil, "OVERLAY")
    t.sub:SetFont(FONT, 10, "OUTLINE")
    t.sub:SetPoint("TOPLEFT", t.text, "BOTTOMLEFT", 0, -2)
    t.sub:SetPoint("RIGHT", t, "RIGHT", -10, 0)
    t.sub:SetJustifyH("LEFT")
    t.sub:SetWordWrap(false)
    t.sub:SetTextColor(TEXT[1], TEXT[2], TEXT[3])

    -- In: fade (reduced) or fade + small pop (full).
    local fade = t:CreateAnimationGroup()
    local fa = fade:CreateAnimation("Alpha"); fa:SetFromAlpha(0); fa:SetToAlpha(1); fa:SetDuration(0.25)
    fade:SetToFinalAlpha(true)
    t.inFade = fade
    local pop = t:CreateAnimationGroup()
    local pa = pop:CreateAnimation("Alpha"); pa:SetFromAlpha(0); pa:SetToAlpha(1); pa:SetDuration(0.25)
    local ps = pop:CreateAnimation("Scale")
    if ps.SetScaleFrom then ps:SetScaleFrom(0.9, 0.9); ps:SetScaleTo(1, 1)
    else ps:SetFromScale(0.9, 0.9); ps:SetToScale(1, 1) end
    ps:SetDuration(0.25); ps:SetSmoothing("OUT")
    pop:SetToFinalAlpha(true)
    t.inPop = pop
    -- Accent shine on arrival.
    local shine = t.accent:CreateAnimationGroup()
    for i, a in ipairs({ { 0.4, 1, 0.2 }, { 1, 0.6, 0.6 } }) do
        local s = shine:CreateAnimation("Alpha")
        s:SetFromAlpha(a[1]); s:SetToAlpha(a[2]); s:SetDuration(a[3]); s:SetOrder(i)
    end
    t.shine = shine

    local out = t:CreateAnimationGroup()
    local oa = out:CreateAnimation("Alpha"); oa:SetFromAlpha(1); oa:SetToAlpha(0); oa:SetDuration(FADE_OUT)
    out:SetToFinalAlpha(true)
    out:SetScript("OnFinished", function() Release(t) end)
    t.out = out

    t:SetScript("OnClick", function(self, button)
        if button == "LeftButton" and self.onClick then pcall(self.onClick) end
        self.left = 0
    end)
    t:SetScript("OnEnter", function(self)
        if self.link then
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -4)
            GameTooltip:SetHyperlink(self.link)
            GameTooltip:Show()
        elseif self.spellID and GameTooltip.SetSpellByID then
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -4)
            GameTooltip:SetSpellByID(self.spellID)
            GameTooltip:Show()
        end
    end)
    t:SetScript("OnLeave", function() GameTooltip:Hide() end)
    t:Hide()
    return t
end

local function Acquire()
    for _, t in ipairs(pool) do
        if not t.inUse then t.inUse = true return t end
    end
    local t = CreateToast()
    pool[#pool + 1] = t
    t.inUse = true
    return t
end

local function Dismiss(t)
    if t.leaving then return end
    t.leaving = true
    if AnimAny() then t.out:Play() else Release(t) end
end

local function OnUpdate(_, elapsed)
    if #active == 0 then anchor:SetScript("OnUpdate", nil) return end
    for i = #active, 1, -1 do
        local t = active[i]
        if not t.leaving and not preview and not t:IsMouseOver() then
            t.left = t.left - elapsed
            if t.left <= 0 then Dismiss(t) end
        end
        -- Notifications waiting: the oldest gives its place after 1.5 s.
        if #queue > 0 and i == #active and not t.leaving and GetTime() - (t.shownAt or 0) >= 1.5 then
            Dismiss(t)
        end
    end
end

local Present -- forward

Release = function(t)
    t:Hide()
    t:SetAlpha(1)
    t.inUse, t.leaving, t.link, t.spellID, t.onClick = nil, nil, nil, nil, nil
    for i, x in ipairs(active) do
        if x == t then table.remove(active, i) break end
    end
    Reflow()
    if #queue > 0 then Present(table.remove(queue, 1)) end
end

-- Newest on top, the others below it.
Reflow = function()
    for i, t in ipairs(active) do
        t:ClearAllPoints()
        t:SetPoint("TOP", anchor, "TOP", 0, -(i - 1) * (TOAST_H + GAP))
    end
end

Present = function(data)
    local db = DB()
    local t = Acquire()
    local c = data.color or GOLD
    t.accent:SetVertexColor(c[1], c[2], c[3], 1)
    t.iconEdge:SetColor(c)
    t.icon:SetTexture(data.icon or ICON_QUEST)
    t.icon:SetTexCoord(data.square and 0 or 0.08, data.square and 1 or 0.92,
        data.square and 0 or 0.08, data.square and 1 or 0.92)
    t.kind:SetText(data.kind or "")
    t.kind:SetTextColor(c[1], c[2], c[3])
    t.text:SetText(data.text or "")
    local tc = data.textColor or TEXT
    t.text:SetTextColor(tc[1], tc[2], tc[3])
    t.sub:SetText(data.sub or "")
    t.sub:SetShown(data.sub ~= nil and data.sub ~= "")
    t.link, t.spellID, t.onClick = data.link, data.spellID, data.onClick
    t.left = (db and db.duration) or 4
    t.leaving = nil
    t.shownAt = GetTime()

    table.insert(active, 1, t)
    Reflow()
    t:SetAlpha(1)
    t:Show()
    t.out:Stop()
    if AnimFull() then
        t.inPop:Play()
        t.shine:Play()
    elseif AnimAny() then
        t.inFade:Play()
    end
    anchor:SetScript("OnUpdate", OnUpdate)
end

local function Push(data)
    local db = DB()
    if not (db and db.enabled) or not anchor then return end
    local max = db.maxShown or 4
    if #active >= max then
        -- Too many at once: queue it. The oldest makes room early, but only
        -- after it has been read for a moment; otherwise the queue waits.
        queue[#queue + 1] = data
        if #queue > 10 then table.remove(queue, 1) end
        local oldest = active[#active]
        if GetTime() - (oldest.shownAt or 0) >= 1.5 then Dismiss(oldest) end
        return
    end
    Present(data)
end
TS.Push = Push

-- ---------------------------------------------------------------------
-- Sources
-- ---------------------------------------------------------------------
local function OpenQuestLog()
    if ToggleQuestLog then ToggleQuestLog() end
end

local function QuestTitle(questID)
    if C_QuestLog and C_QuestLog.GetTitleForQuestID then
        local t = Plain(C_QuestLog.GetTitleForQuestID(questID))
        if type(t) == "string" and t ~= "" then return t end
    end
    return TS._titles and TS._titles[questID]
end

-- Quest ready: known quests going from unfinished to finished. The first
-- scan only learns the log (no banner at login), and a quest that is
-- already complete when accepted ("talk to...") is learned silently too.
local known, titles, scanned = {}, {}, false
TS._titles = titles

local function ScanQuests()
    local db = DB()
    if not (C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo) then return end
    local seen = {}
    local n = C_QuestLog.GetNumQuestLogEntries() or 0
    for i = 1, n do
        local info = C_QuestLog.GetInfo(i)
        local id = info and not info.isHeader and info.questID
        if id and id > 0 then
            seen[id] = true
            local title = Plain(info.title)
            if type(title) == "string" then titles[id] = title end
            local complete = C_QuestLog.IsComplete and C_QuestLog.IsComplete(id) or false
            local objs = C_QuestLog.GetQuestObjectives and C_QuestLog.GetQuestObjectives(id)
            local hasObjectives = type(objs) == "table" and #objs > 0
            if scanned and known[id] == false and complete and hasObjectives
               and db and db.enabled and db.questReady then
                Push({
                    kind = T("QUÊTE TERMINÉE", "QUEST COMPLETE"),
                    text = titles[id] or ("#" .. id),
                    sub = T("Prête à rendre", "Ready to turn in"),
                    icon = ICON_READY, square = true, color = GREEN,
                    onClick = OpenQuestLog,
                })
            end
            known[id] = complete and true or false
        end
    end
    if n > 0 then
        for id in pairs(known) do if not seen[id] then known[id] = nil end end
        scanned = true
    end
end

local scanQueued = false
local function QueueScan()
    if scanQueued then return end
    scanQueued = true
    C_Timer.After(0.3, function() scanQueued = false; ScanQuests() end)
end

local function OnQuestTurnedIn(questID, xp, money)
    local db = DB()
    if not (db and db.enabled and db.questDone) then return end
    local parts = {}
    xp, money = Plain(xp), Plain(money)
    if type(xp) == "number" and xp > 0 then parts[#parts + 1] = Num(xp) .. " " .. T("XP", "XP") end
    local coins = type(money) == "number" and Coins(money)
    if coins then parts[#parts + 1] = coins end
    Push({
        kind = T("QUÊTE RENDUE", "QUEST TURNED IN"),
        text = QuestTitle(questID) or ("#" .. tostring(questID)),
        sub = #parts > 0 and table.concat(parts, "   ") or nil,
        icon = ICON_QUEST, square = true, color = YELLOW,
    })
end

local function ItemQuality(link)
    local q
    if C_Item and C_Item.GetItemQualityByID then
        local ok, v = pcall(C_Item.GetItemQualityByID, link)
        if ok then q = Plain(v) end
    end
    if not q and GetItemInfo then q = Plain(select(3, GetItemInfo(link))) end
    if not q and ITEM_QUALITY_COLORS then
        local hex = link:match("|c(%x%x%x%x%x%x%x%x)")
        if hex then
            hex = hex:lower()
            for i = 0, 8 do
                local c = ITEM_QUALITY_COLORS[i]
                if c and c.hex and c.hex:lower():find(hex, 1, true) then q = i break end
            end
        end
    end
    return q
end

local function ItemIcon(link)
    if C_Item and C_Item.GetItemIconByID then
        local ok, v = pcall(C_Item.GetItemIconByID, link)
        if ok and v then return v end
    end
    return GetItemIcon and GetItemIcon(link) or nil
end

local QUALITY_LABEL = {
    [2] = { "INHABITUEL", "UNCOMMON" }, [3] = { "RARE", "RARE" },
    [4] = { "ÉPIQUE", "EPIC" }, [5] = { "LÉGENDAIRE", "LEGENDARY" },
}

local function OnLoot(msg)
    local db = DB()
    if not (db and db.enabled and db.loot and matchLoot) then return end
    msg = Plain(msg)
    if type(msg) ~= "string" then return end
    local caps = matchLootMulti(msg)
    local count = 1
    if caps then
        count = tonumber(caps[2]) or 1
    else
        caps = matchLoot(msg)
    end
    if not caps then return end
    local link = msg:match("|c%x+|Hitem:.-|h.-|h|r")
    if not link then return end
    local q = ItemQuality(link)
    if not q or q < (db.lootQuality or 3) then return end
    local c = (ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[q]) or GOLD
    local color = { c.r or c[1] or 1, c.g or c[2] or 1, c.b or c[3] or 1 }
    local label = QUALITY_LABEL[q]
    Push({
        kind = (label and T(label[1], label[2]) or T("BUTIN", "LOOT")) .. "  -  " .. T("BUTIN", "LOOT"),
        text = link .. (count > 1 and (" x" .. count) or ""),
        icon = ItemIcon(link), color = color, link = link,
    })
end

local function OnStanding(msg)
    local db = DB()
    if not (db and db.enabled and db.reputation and matchStanding) then return end
    msg = Plain(msg)
    if type(msg) ~= "string" then return end
    local caps = matchStanding(msg)
    if not caps then return end
    -- FACTION_STANDING_CHANGED: "You are now %s with %s." -> standing, faction
    Push({
        kind = T("RÉPUTATION", "REPUTATION"),
        text = caps[2] or "",
        sub = caps[1],
        icon = ICON_REP, color = BLUE,
    })
end

local lastDiscovery, lastDiscoveryAt = nil, 0
local function OnDiscovery(msg)
    local db = DB()
    if not (db and db.enabled and db.discovery and matchDiscovery) then return end
    msg = Plain(msg)
    if type(msg) ~= "string" then return end
    local caps = matchDiscovery(msg)
    if not caps then return end
    local area = caps[1]
    -- Same discovery can come as chat and as a yellow screen message.
    if area == lastDiscovery and GetTime() - lastDiscoveryAt < 5 then return end
    lastDiscovery, lastDiscoveryAt = area, GetTime()
    local xp = tonumber(caps[2])
    Push({
        kind = T("DÉCOUVERTE", "DISCOVERED"),
        text = area or "",
        sub = xp and (Num(xp) .. " " .. T("XP", "XP")) or nil,
        icon = ICON_DISCOVERY, color = GOLD,
    })
end

-- Spells come in bursts at the trainer: gather them for a moment.
local learned, learnTimer = {}, nil
local function FlushSpells()
    learnTimer = nil
    local db = DB()
    if #learned == 0 or not (db and db.enabled and db.spells) then wipe(learned) return end
    local first = learned[1]
    if #learned == 1 then
        Push({
            kind = T("NOUVEAU SORT", "NEW SPELL"),
            text = first.name, icon = first.icon or ICON_SPELL,
            color = GOLD, spellID = first.id,
        })
    else
        local names = {}
        for i = 2, math.min(#learned, 4) do names[#names + 1] = learned[i].name end
        Push({
            kind = T("NOUVEAUX SORTS", "NEW SPELLS"),
            text = string.format(T("%d sorts appris", "%d spells learned"), #learned),
            sub = first.name .. (#names > 0 and (", " .. table.concat(names, ", ")) or ""),
            icon = first.icon or ICON_SPELL, color = GOLD,
        })
    end
    wipe(learned)
end

local function SpellIcon(id, name)
    if C_Spell and C_Spell.GetSpellTexture then
        local ok, v = pcall(C_Spell.GetSpellTexture, id or name)
        if ok and v then return v end
    end
    if GetSpellTexture then return GetSpellTexture(id or name) end
end

local function OnSpell(msg)
    local db = DB()
    if not (db and db.enabled and db.spells and matchSpell) then return end
    local caps = matchSpell(msg)
    if not caps then return end
    local raw = caps[1] or ""
    local id = tonumber(raw:match("|Hspell:(%d+)"))
    local name = raw:match("|h%[(.-)%]|h") or raw
    learned[#learned + 1] = { id = id, name = name, icon = SpellIcon(id, name) }
    if not learnTimer then learnTimer = C_Timer.NewTimer(1.2, FlushSpells) end
end

local function OnSystem(msg)
    msg = Plain(msg)
    if type(msg) ~= "string" then return end
    OnStanding(msg)
    OnDiscovery(msg)
    OnSpell(msg)
end

-- ---------------------------------------------------------------------
-- Level-up celebration
-- ---------------------------------------------------------------------
local cele

local function AlphaAnim(group, from, to, dur, delay, order)
    local a = group:CreateAnimation("Alpha")
    a:SetFromAlpha(from); a:SetToAlpha(to); a:SetDuration(dur)
    if delay then a:SetStartDelay(delay) end
    a:SetOrder(order or 1)
    return a
end

local function ScaleAnim(group, from, to, dur, delay, smooth)
    local s = group:CreateAnimation("Scale")
    if s.SetScaleFrom then s:SetScaleFrom(from, from); s:SetScaleTo(to, to)
    else s:SetFromScale(from, from); s:SetToScale(to, to) end
    s:SetDuration(dur)
    if delay then s:SetStartDelay(delay) end
    if smooth then s:SetSmoothing(smooth) end
    return s
end

local function CreateCelebration()
    if cele then return cele end
    local f = CreateFrame("Frame", "TomoMod_LevelUpFrame", UIParent)
    f:SetSize(420, 200)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 170)
    f:SetFrameStrata("HIGH")
    f:EnableMouse(false)
    f:Hide()

    local glow = f:CreateTexture(nil, "BACKGROUND")
    glow:SetTexture(GLOW)
    glow:SetBlendMode("ADD")
    glow:SetVertexColor(YELLOW[1], 0.75, 0.25, 1)
    glow:SetSize(360, 360)
    glow:SetPoint("CENTER", 0, 10)
    f.glow = glow

    local ring = f:CreateTexture(nil, "ARTWORK")
    ring:SetTexture(RING)
    ring:SetBlendMode("ADD")
    ring:SetVertexColor(YELLOW[1], YELLOW[2], 0.35, 1)
    ring:SetSize(110, 110)
    ring:SetPoint("CENTER", 0, 10)
    f.ring = ring

    local dash = f:CreateTexture(nil, "ARTWORK")
    dash:SetTexture(RING_DASH)
    dash:SetBlendMode("ADD")
    dash:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 1)
    dash:SetSize(190, 190)
    dash:SetPoint("CENTER", 0, 10)
    f.dash = dash

    f.embers = {}
    for i = 1, 12 do
        local e = f:CreateTexture(nil, "OVERLAY")
        e:SetTexture(EMBER)
        e:SetBlendMode("ADD")
        e:SetVertexColor(1, 0.75, 0.3, 1)
        e:SetSize(14, 14)
        e:SetPoint("CENTER", 0, 10)
        local ag = e:CreateAnimationGroup()
        local mv = ag:CreateAnimation("Translation")
        mv:SetDuration(1.3); mv:SetSmoothing("OUT")
        AlphaAnim(ag, 1, 0, 1.3)
        ScaleAnim(ag, 1, 0.3, 1.3)
        ag:SetScript("OnFinished", function() e:Hide() end)
        e.ag, e.move = ag, mv
        e:Hide()
        f.embers[i] = e
    end

    local title = f:CreateFontString(nil, "OVERLAY")
    title:SetFont(FONT_BLACK, 40, "OUTLINE")
    title:SetPoint("CENTER", 0, 14)
    title:SetTextColor(YELLOW[1], YELLOW[2], YELLOW[3])
    title:SetShadowColor(0, 0, 0, 0.8)
    title:SetShadowOffset(2, -2)
    f.title = title

    local line = f:CreateTexture(nil, "OVERLAY")
    line:SetTexture(SOLID)
    line:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0.9)
    line:SetSize(260, 1)
    line:SetPoint("TOP", title, "BOTTOM", 0, -4)
    f.line = line

    local sub = f:CreateFontString(nil, "OVERLAY")
    sub:SetFont(FONT_BOLD, 14, "OUTLINE")
    sub:SetPoint("TOP", line, "BOTTOM", 0, -6)
    sub:SetTextColor(TEXT[1], TEXT[2], TEXT[3])
    f.sub = sub

    local spells = f:CreateFontString(nil, "OVERLAY")
    spells:SetFont(FONT, 12, "OUTLINE")
    spells:SetPoint("TOP", sub, "BOTTOM", 0, -4)
    spells:SetTextColor(GREEN[1], GREEN[2], GREEN[3])
    f.spells = spells

    -- Whole frame: in, hold, out.
    local life = f:CreateAnimationGroup()
    AlphaAnim(life, 0, 1, 0.2, nil, 1)
    AlphaAnim(life, 1, 0, 0.8, 2.6, 2)
    life:SetToFinalAlpha(true)
    life:SetScript("OnFinished", function() f:Hide(); f:SetAlpha(1) end)
    f.life = life

    -- Full level only.
    local ringAG = ring:CreateAnimationGroup()
    ScaleAnim(ringAG, 0.3, 2.8, 1.1, nil, "OUT")
    AlphaAnim(ringAG, 1, 0, 1.1)
    f.ringAG = ringAG

    local dashAG = dash:CreateAnimationGroup()
    local rot = dashAG:CreateAnimation("Rotation"); rot:SetDegrees(-120); rot:SetDuration(3.4)
    AlphaAnim(dashAG, 0, 0.9, 0.4, nil, 1)
    AlphaAnim(dashAG, 0.9, 0, 0.9, 2.5, 1)
    dashAG:SetToFinalAlpha(true)
    f.dashAG = dashAG

    local glowAG = glow:CreateAnimationGroup()
    AlphaAnim(glowAG, 0, 0.75, 0.3, nil, 1)
    AlphaAnim(glowAG, 0.75, 0, 1.6, 0.5, 2)
    glowAG:SetToFinalAlpha(true)
    f.glowAG = glowAG

    local titleAG = title:CreateAnimationGroup()
    ScaleAnim(titleAG, 0.5, 1.12, 0.25, nil, "OUT"):SetOrder(1)
    ScaleAnim(titleAG, 1.12, 1, 0.2, nil, "IN_OUT"):SetOrder(2)
    f.titleAG = titleAG

    local lineAG = line:CreateAnimationGroup()
    local ls = lineAG:CreateAnimation("Scale")
    if ls.SetScaleFrom then ls:SetScaleFrom(0.01, 1); ls:SetScaleTo(1, 1)
    else ls:SetFromScale(0.01, 1); ls:SetToScale(1, 1) end
    ls:SetDuration(0.5); ls:SetStartDelay(0.15); ls:SetSmoothing("OUT")
    f.lineAG = lineAG

    cele = f
    return f
end

local function SpellsWaiting(level)
    local TR = TomoMod_TrainerReminder
    if not (TR and TR.PendingFor) then return 0 end
    local ok, list = pcall(TR.PendingFor, level)
    return (ok and type(list) == "table") and #list or 0
end

function TS.PlayLevelUp(level)
    local ldb = LDB()
    local f = CreateCelebration()
    level = tonumber(level) or (UnitLevel and UnitLevel("player")) or 1
    f:SetScale((ldb and ldb.scale) or 1)
    f.title:SetText(string.format(T("NIVEAU %d", "LEVEL %d"), level))
    f.sub:SetText(T("Félicitations !", "Congratulations!"))
    local n = 0
    if (not ldb or ldb.showSpells ~= false) and level % 2 == 0 then n = SpellsWaiting(level) end
    if n > 0 then
        f.spells:SetText(string.format(T("%d sort(s) t'attendent chez ton maître de classe",
            "%d spell(s) waiting at your class trainer"), n))
        f.spells:Show()
    else
        f.spells:Hide()
    end

    for _, ag in ipairs({ f.life, f.ringAG, f.dashAG, f.glowAG, f.titleAG, f.lineAG }) do ag:Stop() end
    f.ring:SetAlpha(0); f.dash:SetAlpha(0); f.glow:SetAlpha(0)
    f:SetAlpha(1)
    f:Show()

    if AnimFull() then
        f.ring:SetAlpha(1)
        f.ringAG:Play(); f.dashAG:Play(); f.glowAG:Play(); f.titleAG:Play(); f.lineAG:Play()
        for i, e in ipairs(f.embers) do
            local angle = (i / #f.embers) * 2 * math.pi + math.random() * 0.4
            local dist = 90 + math.random() * 70
            e.move:SetOffset(math.cos(angle) * dist, math.sin(angle) * dist)
            e:Show()
            e.ag:Stop()
            e.ag:Play()
        end
        f.life:Play()
    elseif AnimAny() then
        f.glow:SetAlpha(0.4)
        f.life:Play()
    else
        f.glow:SetAlpha(0.4)
        C_Timer.After(3, function() if not f.life:IsPlaying() then f:Hide() end end)
    end
end

function TS.OwnsLevelUp()
    local ldb = LDB()
    return ldb and ldb.enabled and true or false
end

-- The game's own level-up banner, hidden while ours plays: the classic
-- LevelUpDisplay frame and/or the modern event toast, whichever this client
-- has. Only during a short window after PLAYER_LEVEL_UP, so other toasts are
-- left alone; nothing is unregistered, so turning the option off restores
-- Blizzard's banner at once.
local blizzWindowUntil = 0
local function HidingBlizzard()
    local ldb = LDB()
    return ldb and ldb.enabled and ldb.hideBlizzard ~= false and GetTime() < blizzWindowUntil
end

local function HideBlizzardNow()
    if not HidingBlizzard() then return end
    local lud = _G.LevelUpDisplay
    if lud and lud:IsShown() then lud:Hide() end
    local etm = _G.EventToastManagerFrame
    if etm and etm:IsShown() then
        if etm.CloseActiveToasts then pcall(etm.CloseActiveToasts, etm) else etm:Hide() end
    end
end

local blizzHooked = false
local function HookBlizzardLevelUp()
    if blizzHooked then return end
    blizzHooked = true
    local lud = _G.LevelUpDisplay
    if lud and lud.HookScript then lud:HookScript("OnShow", HideBlizzardNow) end
    local etm = _G.EventToastManagerFrame
    if etm then
        if etm.DisplayToast then hooksecurefunc(etm, "DisplayToast", HideBlizzardNow) end
        if etm.HookScript then etm:HookScript("OnShow", HideBlizzardNow) end
    end
end

local function OnLevelUpBlizzard()
    blizzWindowUntil = GetTime() + 4
    HookBlizzardLevelUp()
    HideBlizzardNow()
    -- The banner may come a frame or two after the event.
    C_Timer.After(0.1, HideBlizzardNow)
    C_Timer.After(0.5, HideBlizzardNow)
end

-- ---------------------------------------------------------------------
-- Anchor, preview, public
-- ---------------------------------------------------------------------
local function CreateAnchor()
    if anchor then return anchor end
    anchor = CreateFrame("Frame", "TomoMod_ToastAnchor", UIParent)
    anchor:SetSize(TOAST_W, TOAST_H)
    anchor:SetFrameStrata("HIGH")
    anchor:SetClampedToScreen(true)
    local U = TomoMod_Utils
    if U and U.SetupDraggable then
        U.SetupDraggable(anchor, function()
            local d = DB()
            if d then
                d.position = d.position or {}
                U.SaveFramePosition(anchor, d.position)
            end
        end, T("Notifications", "Notifications"))
    end
    return anchor
end

function TS.ApplySettings()
    local db = DB()
    if not (db and anchor) then return end
    anchor:SetScale(db.scale or 1)
    local U = TomoMod_Utils
    if U and U.ApplyFramePosition and db.position then U.ApplyFramePosition(anchor, db.position) end
end

local SAMPLES = {
    function() return {
        kind = T("QUÊTE RENDUE", "QUEST TURNED IN"), text = T("Les loups de la forêt", "Wolves Across the Border"),
        sub = Num(1250) .. " XP   " .. (Coins(240) or ""), icon = ICON_QUEST, square = true, color = YELLOW } end,
    function() return {
        kind = T("RARE  -  BUTIN", "RARE  -  LOOT"), text = "|cff0070dd[" .. T("Lame de l'aube", "Dawnblade") .. "]|r",
        icon = "Interface\\Icons\\INV_Sword_04", color = { 0, 0.44, 0.87 } } end,
    function() return {
        kind = T("RÉPUTATION", "REPUTATION"), text = T("Hurlevent", "Stormwind"),
        sub = T("Honoré", "Honored"), icon = ICON_REP, color = BLUE } end,
}

function TS.Preview(on)
    preview = on and true or false
    if preview then
        CreateAnchor()
        for i = #active, 1, -1 do Release(active[i]) end
        local db = DB()
        local was = db and db.enabled
        if db then db.enabled = true end
        for _, make in ipairs(SAMPLES) do Push(make()) end
        if db then db.enabled = was end
    else
        for i = #active, 1, -1 do Dismiss(active[i]) end
    end
end
function TS.IsPreview() return preview end

function TS.SetEnabled(v)
    local db = DB()
    if not db then return end
    db.enabled = v and true or false
    if not v then
        preview = false
        wipe(queue)
        for i = #active, 1, -1 do Release(active[i]) end
    end
end

function TS.Initialize()
    if not DB() then return end
    BuildMatchers()
    CreateAnchor()
    TS.ApplySettings()

    local f = CreateFrame("Frame")
    for _, e in ipairs({
        "PLAYER_LEVEL_UP", "QUEST_TURNED_IN", "QUEST_LOG_UPDATE", "PLAYER_ENTERING_WORLD",
        "CHAT_MSG_LOOT", "CHAT_MSG_SYSTEM", "CHAT_MSG_COMBAT_FACTION_CHANGE", "UI_INFO_MESSAGE",
    }) do pcall(f.RegisterEvent, f, e) end
    f:SetScript("OnEvent", function(_, event, a1, a2, a3)
        if event == "PLAYER_LEVEL_UP" then
            local ldb = LDB()
            if ldb and ldb.enabled then
                OnLevelUpBlizzard()
                local level = tonumber(Plain(a1))
                C_Timer.After(0.2, function() TS.PlayLevelUp(level) end)
            end
        elseif event == "QUEST_TURNED_IN" then
            OnQuestTurnedIn(a1, a2, a3)
        elseif event == "QUEST_LOG_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
            QueueScan()
        elseif event == "CHAT_MSG_LOOT" then
            OnLoot(a1)
        elseif event == "CHAT_MSG_SYSTEM" or event == "CHAT_MSG_COMBAT_FACTION_CHANGE" then
            OnSystem(a1)
        elseif event == "UI_INFO_MESSAGE" then
            OnDiscovery(a2)
        end
    end)

    if TomoMod_Movers and TomoMod_Movers.RegisterEntry then
        TomoMod_Movers.RegisterEntry({
            label    = T("Notifications", "Notifications"),
            unlock   = function() TS.Preview(true); if anchor and anchor.SetLocked then anchor:SetLocked(false) end end,
            lock     = function() if anchor and anchor.SetLocked then anchor:SetLocked(true) end; TS.Preview(false) end,
            isActive = function() local d = DB(); return d and d.enabled end,
        })
    end
end
