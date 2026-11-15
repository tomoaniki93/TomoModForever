-- =====================================================================
-- Modules/QOL/Forever/SpellRanks.lua -- new spell ranks on the bars
--
-- On WoW: Forever a rank bought at the class trainer does not reach the
-- action bars: a button keeps casting the rank that was dragged onto it.
-- (With "Show all spell ranks" unticked in the spellbook, a spell dragged
-- from it follows the highest rank by itself; the problem is the ranks
-- placed while that box is ticked, i.e. players who downrank.)
--
-- What is "outdated". Per spell name, on all 180 action slots: the
-- HIGHEST rank present on the bars, when a higher rank is known. Only
-- the slots holding that highest present rank are offered; lower ranks
-- placed next to it (Flash Heal rank 1 kept for cheap heals) are never
-- touched. A rank can also be kept on purpose ("Keep this rank", per
-- character): its slots are left alone and the spell is not offered.
--
-- How it shows (mode "ask", default):
--   * a gold arrow on the new rank in the spellbook; left click updates
--     every outdated slot of that spell (the icon flies from the
--     spellbook to the button it lands on), right click keeps the rank
--     on the bars;
--   * the outdated buttons pulse gold on the action bars (Blizzard's,
--     and any LibActionButton bar: Bartender4, ElvUI...);
--   * one chat line when the trainer window closes.
-- Mode "auto": the update is done when the trainer window closes (and
-- after combat if it closes in one), with the same rules.
--
-- Spellbook: Forever uses the modern PlayerSpellsFrame. Its entries are
-- SpellBookItemMixin frames; UpdateVisuals / ClearSpellData are hooked on
-- the mixin (and the entries already built are walked once), so no
-- polling while the book is open.
--
-- Combat: PlaceAction is refused under lockdown, so nothing is replaced
-- in combat. Macros and click-casting are not handled.
-- Diagnostics: /tmf ranks (or /tmf rangs), /tmf ranks update, /tmf ranks reset.
-- =====================================================================

TomoMod_SpellRanks = TomoMod_SpellRanks or {}
local SR = TomoMod_SpellRanks

local FONT = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"

-- WoW: Forever palette
local BRONZE = { 0.545, 0.420, 0.247 }
local GOLD   = { 0.788, 0.635, 0.322 }
local YELLOW = { 1.000, 0.820, 0.000 }
local TEXT   = { 0.949, 0.922, 0.859 }

local MAX_ACTION_SLOT = 180

local IS_FR = GetLocale() == "frFR"
local function T(fr, en)
    if TomoMod_GUIT then return TomoMod_GUIT(fr, en) end
    return IS_FR and fr or en
end

local function DB() return TomoModForeverDB and TomoModForeverDB.spellRanks end
local function Enabled() local d = DB(); return d and d.enabled end

local function Print(msg)
    print("|cffffd100TomoModForever|r |cffc9a252" .. T("Rangs", "Ranks") .. "|r " .. msg)
end

-- Ranks kept on purpose, per character: [spellID] = true
local function Keep()
    if type(_G.TomoModForeverCharDB) ~= "table" then _G.TomoModForeverCharDB = {} end
    local c = _G.TomoModForeverCharDB
    if type(c.spellRanksKeep) ~= "table" then c.spellRanksKeep = {} end
    return c.spellRanksKeep
end

-- ---------------------------------------------------------------------
-- Spell data
-- ---------------------------------------------------------------------
local function SpellName(id)
    if C_Spell and C_Spell.GetSpellName then
        local ok, n = pcall(C_Spell.GetSpellName, id)
        if ok and n then return n end
    end
    if GetSpellInfo then
        local ok, n = pcall(GetSpellInfo, id)
        if ok then return n end
    end
end

local function SpellIcon(id)
    if C_Spell and C_Spell.GetSpellTexture then
        local ok, t = pcall(C_Spell.GetSpellTexture, id)
        if ok and t then return t end
    end
    if GetSpellTexture then
        local ok, t = pcall(GetSpellTexture, id)
        if ok then return t end
    end
end

-- "Rang 3" / "Rank 3" -> 3, nil for a spell without ranks
local function RankOf(sub)
    if type(sub) ~= "string" then return nil end
    return tonumber(sub:match("(%d+)"))
end

local function SpellRank(id)
    local fn = (C_Spell and C_Spell.GetSpellSubtext) or GetSpellSubtext
    if not fn then return nil end
    local ok, sub = pcall(fn, id)
    return ok and RankOf(sub) or nil
end

local function PlayerBank()
    return Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player
end

-- Highest learned rank of every ranked spell in the player's spellbook:
-- name -> { id, rank, slot }
local function ReadBook()
    local best = {}
    local bank = PlayerBank()
    if not (C_SpellBook and C_SpellBook.GetSpellBookItemInfo and C_SpellBook.GetNumSpellBookSkillLines and bank) then
        return best
    end
    local spellType = Enum.SpellBookItemType and Enum.SpellBookItemType.Spell
    local okN, lines = pcall(C_SpellBook.GetNumSpellBookSkillLines)
    for i = 1, (okN and lines) or 0 do
        local ok, line = pcall(C_SpellBook.GetSpellBookSkillLineInfo, i)
        if ok and type(line) == "table" and not line.offSpecID then
            local first = (line.itemIndexOffset or 0) + 1
            local last = (line.itemIndexOffset or 0) + (line.numSpellBookItems or 0)
            for slot = first, last do
                local ok2, info = pcall(C_SpellBook.GetSpellBookItemInfo, slot, bank)
                if ok2 and type(info) == "table" and info.spellID and info.name
                   and (not spellType or info.itemType == spellType) and not info.isPassive then
                    local rank = RankOf(info.subName) or SpellRank(info.spellID)
                    if rank then
                        local b = best[info.name]
                        if not b or rank > b.rank then
                            best[info.name] = { id = info.spellID, rank = rank, slot = slot }
                        end
                    end
                end
            end
        end
    end
    return best
end

-- ---------------------------------------------------------------------
-- Analysis
-- ---------------------------------------------------------------------
-- pending[name] = { best = {id, rank, slot}, from = id, fromRank = n, slots = {...} }
local pending, pendingCount = {}, 0
local slotPending = {}   -- [action slot] = name

local function Analyse()
    wipe(pending); wipe(slotPending); pendingCount = 0
    if not Enabled() then return end
    local best = ReadBook()
    local keep = Keep()

    -- Per name: the highest rank present on the bars, and its slots.
    local top = {}
    for slot = 1, MAX_ACTION_SLOT do
        local ok, kind, id = pcall(GetActionInfo, slot)
        if ok and kind == "spell" and id then
            local name = SpellName(id)
            local b = name and best[name]
            if b then
                local rank = SpellRank(id)
                if rank then
                    local t = top[name]
                    if not t or rank > t.rank then
                        top[name] = { rank = rank, id = id, slots = { slot } }
                    elseif rank == t.rank then
                        t.slots[#t.slots + 1] = slot
                    end
                end
            end
        end
    end

    for name, t in pairs(top) do
        local b = best[name]
        if t.rank < b.rank and not keep[t.id] then
            pending[name] = { best = b, from = t.id, fromRank = t.rank, slots = t.slots }
            pendingCount = pendingCount + 1
            for _, s in ipairs(t.slots) do slotPending[s] = name end
        end
    end
end

-- ---------------------------------------------------------------------
-- Replacing
-- ---------------------------------------------------------------------
local function PickupBest(b)
    local bank = PlayerBank()
    if b.slot and C_SpellBook and C_SpellBook.PickupSpellBookItem and bank then
        pcall(C_SpellBook.PickupSpellBookItem, b.slot, bank)
    end
    if GetCursorInfo() ~= "spell" then
        if C_Spell and C_Spell.PickupSpell then pcall(C_Spell.PickupSpell, b.id)
        elseif PickupSpell then pcall(PickupSpell, b.id) end
    end
    return GetCursorInfo() == "spell"
end

local Refresh   -- defined below

-- Replaces the outdated slots of one spell. Returns the number of slots
-- updated and the first of them (for the animation).
local function ReplaceSpell(name)
    local p = pending[name]
    if not p then return 0 end
    if InCombatLockdown() then
        if UIErrorsFrame then
            UIErrorsFrame:AddMessage(T("Impossible de changer les barres en combat.", "Action bars cannot be changed in combat."), 1, 0.3, 0.2)
        end
        return 0
    end
    if GetCursorInfo() then ClearCursor() end
    local done, first = 0, nil
    for _, slot in ipairs(p.slots) do
        -- The slot must still hold the rank we analysed.
        local ok, kind, id = pcall(GetActionInfo, slot)
        if ok and kind == "spell" and id == p.from then
            if not PickupBest(p.best) then break end
            PlaceAction(slot)
            ClearCursor()   -- PlaceAction hands the old rank back to the cursor
            done = done + 1
            first = first or slot
        end
    end
    return done, first
end

local function ReplaceAll()
    if InCombatLockdown() then return 0, 0 end
    local spells, slots = 0, 0
    local names = {}
    for name in pairs(pending) do names[#names + 1] = name end
    for _, name in ipairs(names) do
        local n = ReplaceSpell(name)
        if n > 0 then spells = spells + 1; slots = slots + n end
    end
    return spells, slots
end

-- ---------------------------------------------------------------------
-- Action bar glow
-- ---------------------------------------------------------------------
local BAR_PREFIXES = {
    "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
    "MultiBarRightButton", "MultiBarLeftButton", "MultiBar5Button",
    "MultiBar6Button", "MultiBar7Button", "BT4Button", "DominosActionButton",
}

local function ButtonSlot(btn)
    if btn._state_type == "action" and tonumber(btn._state_action) then return tonumber(btn._state_action) end
    if tonumber(btn.action) then return tonumber(btn.action) end
    return nil
end

local function ForEachActionButton(fn)
    local seen = {}
    for _, prefix in ipairs(BAR_PREFIXES) do
        for i = 1, (prefix == "BT4Button" or prefix == "DominosActionButton") and MAX_ACTION_SLOT or 12 do
            local b = _G[prefix .. i]
            if b and not seen[b] then seen[b] = true; fn(b) end
        end
    end
    local LAB = LibStub and LibStub("LibActionButton-1.0", true)
    if LAB and type(LAB.buttonRegistry) == "table" then
        for b in pairs(LAB.buttonRegistry) do
            if not seen[b] then seen[b] = true; fn(b) end
        end
    end
end

local glows = {}   -- [button] = overlay frame

local function GetGlow(btn)
    local g = glows[btn]
    if g then return g end
    -- Own frame on UIParent, anchored to the button: nothing is added to
    -- the (secure) action button itself.
    g = CreateFrame("Frame", nil, UIParent)
    g:SetFrameStrata("HIGH")
    g:SetPoint("TOPLEFT", btn, "TOPLEFT", -3, 3)
    g:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 3, -3)
    local edge = {}
    for i, pts in ipairs({
        { "TOPLEFT", "TOPRIGHT", nil, 2 }, { "BOTTOMLEFT", "BOTTOMRIGHT", nil, 2 },
        { "TOPLEFT", "BOTTOMLEFT", 2, nil }, { "TOPRIGHT", "BOTTOMRIGHT", 2, nil },
    }) do
        local t = g:CreateTexture(nil, "OVERLAY")
        t:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 1)
        t:SetPoint(pts[1]); t:SetPoint(pts[2])
        if pts[3] then t:SetWidth(pts[3]) end
        if pts[4] then t:SetHeight(pts[4]) end
        edge[i] = t
    end
    local shine = g:CreateTexture(nil, "ARTWORK")
    shine:SetPoint("TOPLEFT", 3, -3)
    shine:SetPoint("BOTTOMRIGHT", -3, 3)
    shine:SetColorTexture(YELLOW[1], YELLOW[2], YELLOW[3], 0.18)
    local ag = g:CreateAnimationGroup()
    ag:SetLooping("BOUNCE")
    local a = ag:CreateAnimation("Alpha")
    a:SetFromAlpha(1); a:SetToAlpha(0.25); a:SetDuration(0.7); a:SetSmoothing("IN_OUT")
    g.anim = ag
    g:Hide()
    glows[btn] = g
    return g
end

local function UpdateGlows()
    local on = Enabled() and DB().glow
    ForEachActionButton(function(btn)
        local slot = on and btn:IsVisible() and ButtonSlot(btn)
        local want = slot and slotPending[slot] and true or false
        if want then
            local g = GetGlow(btn)
            if not g:IsShown() then g:Show(); g.anim:Play() end
        elseif glows[btn] and glows[btn]:IsShown() then
            glows[btn].anim:Stop(); glows[btn]:Hide()
        end
    end)
end

local function FindButtonForSlot(slot)
    local found
    ForEachActionButton(function(btn)
        if not found and btn:IsVisible() and ButtonSlot(btn) == slot then found = btn end
    end)
    return found
end

-- ---------------------------------------------------------------------
-- Flying icon (spellbook entry -> action button)
-- ---------------------------------------------------------------------
local flyPool = {}
local function Fly(fromFrame, toFrame, icon)
    if not (fromFrame and icon) then return end
    local f
    for _, x in ipairs(flyPool) do if not x:IsShown() then f = x; break end end
    if not f then
        f = CreateFrame("Frame", nil, UIParent)
        f:SetFrameStrata("TOOLTIP")
        f.tex = f:CreateTexture(nil, "ARTWORK")
        f.tex:SetAllPoints()
        f.tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        flyPool[#flyPool + 1] = f
    end
    local ui = UIParent:GetEffectiveScale()
    local function Center(fr)
        local x, y = fr:GetCenter()
        if not x then return nil end
        local s = fr:GetEffectiveScale() / ui
        return x * s, y * s, fr:GetWidth() * s
    end
    local x1, y1, w1 = Center(fromFrame)
    if not x1 then return end
    local x2, y2, w2
    if toFrame then x2, y2, w2 = Center(toFrame) end
    if not x2 then x2, y2, w2 = x1, y1 - 90, w1 * 0.7 end
    f.tex:SetTexture(icon)
    local DUR, t = 0.65, 0
    f:ClearAllPoints()
    f:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x1, y1)
    f:SetSize(w1, w1)
    f:SetAlpha(1)
    f:Show()
    f:SetScript("OnUpdate", function(self, elapsed)
        t = t + elapsed
        local p = math.min(t / DUR, 1)
        local e = 1 - (1 - p) ^ 3                         -- ease-out cubic
        local arc = math.sin(p * math.pi) * 40            -- small hop on the way
        local w = w1 + (w2 - w1) * e
        self:SetSize(w, w)
        self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x1 + (x2 - x1) * e, y1 + (y2 - y1) * e + arc)
        self:SetAlpha(p < 0.8 and 1 or (1 - (p - 0.8) / 0.2))
        if p >= 1 then self:SetScript("OnUpdate", nil); self:Hide() end
    end)
end

-- ---------------------------------------------------------------------
-- Spellbook arrow
-- ---------------------------------------------------------------------
local function AishCoreArrows()
    local loaded
    if C_AddOns and C_AddOns.IsAddOnLoaded then loaded = C_AddOns.IsAddOnLoaded("AishCore")
    elseif IsAddOnLoaded then loaded = IsAddOnLoaded("AishCore") end
    return loaded and true or false
end

local function ArrowEnabled()
    local d = DB()
    return d and d.enabled and d.arrow and not AishCoreArrows()
end

-- Name of the pending spell whose NEW rank this spellbook entry shows.
local function EntryPending(item)
    if not (item and item.slotIndex and item.spellBank == PlayerBank()) then return nil end
    local info = item.spellBookItemInfo
    local name = info and info.name
    local p = name and pending[name]
    if p and p.best.slot == item.slotIndex then return name end
    return nil
end

local arrows = {}   -- [spellbook entry] = arrow button

local function ArrowClick(self, button)
    local item = self.item
    local name = item and EntryPending(item)
    if not name then self:Hide(); return end
    local p = pending[name]
    if button == "RightButton" then
        Keep()[p.from] = true
        Print(string.format(T("%s rang %d gardé sur tes barres. /tmf rangs reset pour annuler.",
                              "%s rank %d kept on your bars. /tmf ranks reset to undo."), name, p.fromRank))
        if SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF then PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF) end
        GameTooltip:Hide()
        Refresh()
        return
    end
    local done, first = ReplaceSpell(name)
    if done > 0 then
        if SOUNDKIT and SOUNDKIT.IG_ABILITY_ICON_DROP then PlaySound(SOUNDKIT.IG_ABILITY_ICON_DROP) end
        Fly(item.Button or item, first and FindButtonForSlot(first), SpellIcon(p.best.id))
        GameTooltip:Hide()
        -- ACTIONBAR_SLOT_CHANGED refreshes too; this keeps the arrow from lingering.
        C_Timer.After(0.05, Refresh)
    end
end

local function GetArrow(item)
    local a = arrows[item]
    if a then return a end
    local host = item.Button or item
    a = CreateFrame("Button", nil, host)
    a:SetSize(22, 22)
    a:SetPoint("TOPLEFT", host, "TOPLEFT", -8, 8)
    a:SetFrameLevel(host:GetFrameLevel() + 10)
    a:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    local disc = a:CreateTexture(nil, "BACKGROUND")
    disc:SetAllPoints()
    disc:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
    disc:SetVertexColor(0.08, 0.06, 0.04, 0.92)
    local ring = a:CreateTexture(nil, "BORDER")
    ring:SetPoint("TOPLEFT", -1.5, 1.5); ring:SetPoint("BOTTOMRIGHT", 1.5, -1.5)
    ring:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
    ring:SetVertexColor(BRONZE[1], BRONZE[2], BRONZE[3], 1)
    ring:SetDrawLayer("BACKGROUND", -1)
    local tex = a:CreateTexture(nil, "ARTWORK")
    tex:SetPoint("TOPLEFT", 4, -4); tex:SetPoint("BOTTOMRIGHT", -4, 4)
    if C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo("bags-greenarrow") then
        tex:SetAtlas("bags-greenarrow")
        tex:SetDesaturated(true)
    else
        tex:SetTexture("Interface\\Buttons\\UI-MicroStream-Yellow")
        tex:SetRotation(math.pi)
    end
    tex:SetVertexColor(YELLOW[1], YELLOW[2], YELLOW[3], 1)
    local hl = a:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints(disc)
    hl:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
    hl:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0.25)
    -- Gentle bob so the arrow is noticed among the spellbook icons.
    local ag = a:CreateAnimationGroup()
    ag:SetLooping("BOUNCE")
    local tr = ag:CreateAnimation("Translation")
    tr:SetOffset(0, 3); tr:SetDuration(0.6); tr:SetSmoothing("IN_OUT")
    a.anim = ag
    a:SetScript("OnShow", function(self) self.anim:Play() end)
    a:SetScript("OnHide", function(self) self.anim:Stop() end)
    a:SetScript("OnClick", ArrowClick)
    a:SetScript("OnEnter", function(self)
        local name = EntryPending(self.item)
        local p = name and pending[name]
        if not p then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(T("Nouveau rang", "New rank"), YELLOW[1], YELLOW[2], YELLOW[3])
        GameTooltip:AddLine(string.format(T("%s : rang %d sur tes barres, rang %d appris.", "%s: rank %d on your bars, rank %d learned."),
            name, p.fromRank, p.best.rank), TEXT[1], TEXT[2], TEXT[3], true)
        GameTooltip:AddLine(T("Clic gauche : mettre à jour les barres", "Left click: update the bars"), GOLD[1], GOLD[2], GOLD[3])
        GameTooltip:AddLine(string.format(T("Clic droit : garder le rang %d", "Right click: keep rank %d"), p.fromRank), GOLD[1], GOLD[2], GOLD[3])
        GameTooltip:Show()
    end)
    a:SetScript("OnLeave", function() GameTooltip:Hide() end)
    a:Hide()
    a.item = item
    arrows[item] = a
    return a
end

local function UpdateEntry(item)
    if not item then return end
    local want = ArrowEnabled() and item:IsShown() and EntryPending(item)
    if want then
        GetArrow(item):Show()
    elseif arrows[item] then
        arrows[item]:Hide()
    end
end

local function SpellBook()
    return PlayerSpellsFrame and PlayerSpellsFrame.SpellBookFrame
end

-- Entries already built when the hooks went in (and a refresh after a
-- rescan): walk the visible page once.
local function WalkEntries(frame, depth)
    for _, child in ipairs({ frame:GetChildren() }) do
        if child.elementData and child.slotIndex ~= nil then
            UpdateEntry(child)
        elseif depth < 5 then
            WalkEntries(child, depth + 1)
        end
    end
end

local function UpdateBook()
    local sb = SpellBook()
    if sb and sb:IsVisible() then WalkEntries(sb.PagedSpellsFrame or sb, 0) end
end

local bookHooked
local function HookBook()
    if bookHooked or not SpellBookItemMixin then return end
    bookHooked = true
    hooksecurefunc(SpellBookItemMixin, "UpdateVisuals", UpdateEntry)
    hooksecurefunc(SpellBookItemMixin, "ClearSpellData", function(self)
        if arrows[self] then arrows[self]:Hide() end
    end)
    local sb = SpellBook()
    if sb then
        sb:HookScript("OnShow", function() C_Timer.After(0, UpdateBook) end)
    end
    UpdateBook()
end

-- ---------------------------------------------------------------------
-- Refresh
-- ---------------------------------------------------------------------
local refreshQueued
Refresh = function()
    Analyse()
    UpdateGlows()
    UpdateBook()
end

local function QueueRefresh()
    if refreshQueued then return end
    refreshQueued = true
    C_Timer.After(0.25, function() refreshQueued = false; Refresh() end)
end

-- ---------------------------------------------------------------------
-- Trainer window closed: chat line, or the update in "auto" mode
-- ---------------------------------------------------------------------
local autoOwed = false
local lastTrainerClose = 0

local function AfterTrainer()
    local d = DB()
    if not (d and d.enabled) then return end
    -- TRAINER_CLOSED and the interaction manager both report the close.
    if GetTime() - lastTrainerClose < 1 then return end
    lastTrainerClose = GetTime()
    Analyse()
    if pendingCount == 0 then UpdateGlows(); return end
    if d.mode == "auto" then
        if InCombatLockdown() then autoOwed = true; return end
        local spells = ReplaceAll()
        if spells > 0 and d.chat then
            Print(string.format(T("%d sort(s) mis à jour au nouveau rang sur tes barres.", "%d spell(s) updated to their new rank on your bars."), spells))
        end
        C_Timer.After(0.1, Refresh)
    else
        UpdateGlows()
        UpdateBook()
        if d.chat then
            Print(string.format(T("%d sort(s) ont un nouveau rang. Ouvre ton grimoire et clique sur la flèche dorée, ou tape /tmf rangs maj.",
                                  "%d spell(s) have a new rank. Open your spellbook and click the gold arrow, or type /tmf ranks update."), pendingCount))
        end
    end
end

-- ---------------------------------------------------------------------
-- Slash: /tmf ranks [update | reset]
-- ---------------------------------------------------------------------
function SR.Slash(arg)
    arg = (arg or ""):lower()
    if arg == "maj" or arg == "update" then
        if InCombatLockdown() then Print(T("Pas en combat.", "Not in combat.")); return end
        Analyse()
        local spells, slots = ReplaceAll()
        Print(string.format(T("%d sort(s) mis à jour (%d bouton(s)).", "%d spell(s) updated (%d button(s))."), spells, slots))
        C_Timer.After(0.1, Refresh)
        return
    elseif arg == "reset" then
        wipe(Keep())
        Print(T("Plus aucun rang gardé : tous les sorts peuvent de nouveau être proposés.", "No rank kept any more: every spell can be offered again."))
        Refresh()
        return
    end
    Refresh()
    local d = DB() or {}
    local nKeep = 0
    for _ in pairs(Keep()) do nKeep = nKeep + 1 end
    Print(string.format("enabled=%s mode=%s glow=%s arrow=%s%s spellbook=%s | %d %s, %d %s",
        tostring(d.enabled), tostring(d.mode), tostring(d.glow), tostring(d.arrow),
        AishCoreArrows() and " (AishCore)" or "", tostring(SpellBook() ~= nil),
        pendingCount, T("à mettre à jour", "to update"), nKeep, T("rang(s) gardé(s)", "rank(s) kept")))
    for name, p in pairs(pending) do
        Print(string.format("  %s : %d -> %d  (%s %s)", name, p.fromRank, p.best.rank,
            T("emplacements", "slots"), table.concat(p.slots, ",")))
    end
end

-- ---------------------------------------------------------------------
-- Public
-- ---------------------------------------------------------------------
function SR.ApplySettings()
    Refresh()
end

function SR.SetEnabled(v)
    local d = DB()
    if not d then return end
    d.enabled = v and true or false
    Refresh()
end

function SR.PendingCount() return pendingCount end

function SR.Initialize()
    if not DB() then return end
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("SPELLS_CHANGED")
    f:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
    f:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
    f:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
    f:RegisterEvent("TRAINER_CLOSED")
    f:RegisterEvent("PLAYER_REGEN_ENABLED")
    f:RegisterEvent("ADDON_LOADED")
    pcall(f.RegisterEvent, f, "LEARNED_SPELL_IN_SKILL_LINE")
    pcall(f.RegisterEvent, f, "LEARNED_SPELL_IN_TAB")
    pcall(f.RegisterEvent, f, "PLAYER_INTERACTION_MANAGER_FRAME_HIDE")
    f:SetScript("OnEvent", function(_, event, arg1)
        if event == "ADDON_LOADED" then
            if arg1 == "Blizzard_PlayerSpells" then HookBook() end
            return
        elseif event == "ACTIONBAR_PAGE_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR" then
            -- Same slots, other buttons: only the glows move.
            C_Timer.After(0.05, UpdateGlows)
            return
        elseif event == "TRAINER_CLOSED" then
            C_Timer.After(0.3, AfterTrainer)
            return
        elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_HIDE" then
            local trainer = Enum and Enum.PlayerInteractionType and Enum.PlayerInteractionType.Trainer
            if trainer and arg1 == trainer then C_Timer.After(0.3, AfterTrainer) end
            return
        elseif event == "PLAYER_REGEN_ENABLED" then
            if autoOwed then autoOwed = false; lastTrainerClose = 0; AfterTrainer() end
            return
        end
        QueueRefresh()
    end)
    if PlayerSpellsFrame or (C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded("Blizzard_PlayerSpells")) then
        HookBook()
    end
end
