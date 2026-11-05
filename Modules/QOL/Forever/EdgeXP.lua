-- =====================================================================
-- Modules/QOL/Forever/EdgeXP.lua -- full-width experience bar
--
-- A thin bar along the top or bottom edge of the screen:
--   * experience fill, rested segment, a tick every 10 %
--   * a level badge in the corner, with a "z" while resting
--   * "+xp" pop on every gain, XP per hour and time to the next level
--   * hover: details, and the quests ready to turn in
--   * at max level: the watched reputation instead (optional)
-- Modes: always shown, only on hover, or shown for a few seconds after
-- each gain.
-- =====================================================================

TomoMod_EdgeXP = TomoMod_EdgeXP or {}
local XP = TomoMod_EdgeXP

local FONT      = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local FONT_BOLD = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-SemiBold.ttf"
local TEX       = "Interface\\AddOns\\TomoModForever\\Assets\\Textures\\tomoaniki"
local WHITE     = "Interface\\Buttons\\WHITE8x8"

local IS_FR = GetLocale() == "frFR"
local function T(fr, en) return IS_FR and fr or en end

local GOLD   = { 0.788, 0.635, 0.322 }
local RESTED = { 0.30, 0.55, 1.00 }
local SHOW_AFTER_GAIN = 5

local bar, badge, info, pop
local PlaceBadge
local session = { t0 = 0, xp0 = 0, gained = 0 }
local lastXP, lastLevel
local showUntil = 0
local hovering = false

local function DB() return TomoModForeverDB and TomoModForeverDB.xpEdge end

local function Fmt(n)
    n = math.floor(n or 0)
    local s = tostring(n)
    local sep = IS_FR and " " or ","
    while true do
        local k
        s, k = s:gsub("^(%d+)(%d%d%d)", "%1" .. sep .. "%2")
        if k == 0 then break end
    end
    return s
end

local function Duration(sec)
    if not sec or sec <= 0 or sec ~= sec or sec == math.huge then return "?" end
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    if h > 0 then return string.format("%d h %02d", h, m) end
    return string.format("%d min", math.max(1, m))
end

local function AtMaxLevel()
    local maxL = (GetMaxLevelForPlayerExpansion and GetMaxLevelForPlayerExpansion())
        or (GetMaxPlayerLevel and GetMaxPlayerLevel()) or 60
    if IsXPUserDisabled and IsXPUserDisabled() then return true end
    return (UnitLevel("player") or 1) >= maxL
end

local function WatchedRep()
    if C_Reputation and C_Reputation.GetWatchedFactionData then
        local d = C_Reputation.GetWatchedFactionData()
        if d and d.name then
            local lo, hi, cur = d.currentReactionThreshold or 0, d.nextReactionThreshold or 1, d.currentStanding or 0
            return d.name, d.reaction or 4, cur - lo, math.max(1, hi - lo)
        end
    end
    if GetWatchedFactionInfo then
        local name, standing, lo, hi, value = GetWatchedFactionInfo()
        if name then return name, standing or 4, (value or 0) - (lo or 0), math.max(1, (hi or 1) - (lo or 0)) end
    end
end

local function ReadyQuests()
    local out = {}
    if C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo then
        for i = 1, C_QuestLog.GetNumQuestLogEntries() do
            local q = C_QuestLog.GetInfo(i)
            if q and not q.isHeader and q.questID and C_QuestLog.IsComplete and C_QuestLog.IsComplete(q.questID) then
                out[#out + 1] = q.title
            end
        end
    elseif GetNumQuestLogEntries and GetQuestLogTitle then
        for i = 1, GetNumQuestLogEntries() do
            local title, _, _, isHeader, _, isComplete = GetQuestLogTitle(i)
            if title and not isHeader and isComplete == 1 then out[#out + 1] = title end
        end
    end
    return out
end

local function ClassColor()
    local _, cls = UnitClass("player")
    local c = cls and RAID_CLASS_COLORS and RAID_CLASS_COLORS[cls]
    if c then return c.r, c.g, c.b end
    return GOLD[1], GOLD[2], GOLD[3]
end

-- ---------------------------------------------------------------------
-- Frames
-- ---------------------------------------------------------------------
local function Create()
    if bar then return end
    bar = CreateFrame("Frame", "TomoMod_EdgeXPBar", UIParent)
    bar:SetFrameStrata("MEDIUM")
    bar:SetFrameLevel(2)
    bar:EnableMouse(true)

    local bg = bar:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.03, 0.025, 0.02, 0.75)

    bar.rested = bar:CreateTexture(nil, "BORDER")
    bar.rested:SetTexture(TEX)
    bar.rested:SetPoint("TOPLEFT")
    bar.rested:SetPoint("BOTTOMLEFT")

    bar.fill = bar:CreateTexture(nil, "ARTWORK")
    bar.fill:SetTexture(TEX)
    bar.fill:SetPoint("TOPLEFT")
    bar.fill:SetPoint("BOTTOMLEFT")

    bar.spark = bar:CreateTexture(nil, "OVERLAY")
    bar.spark:SetColorTexture(1, 0.95, 0.75, 0.9)
    bar.spark:SetWidth(2)
    bar.spark:SetPoint("TOP")
    bar.spark:SetPoint("BOTTOM")

    bar.edge = bar:CreateTexture(nil, "OVERLAY")
    bar.edge:SetHeight(1)
    bar.edge:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 0.6)

    bar.ticks = {}
    for i = 1, 9 do
        local t = bar:CreateTexture(nil, "OVERLAY")
        t:SetColorTexture(0, 0, 0, 0.55)
        t:SetWidth(1)
        bar.ticks[i] = t
    end

    -- Level badge
    badge = CreateFrame("Frame", nil, bar, "BackdropTemplate")
    badge:SetSize(30, 18)
    badge:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 })
    badge:SetBackdropColor(0.06, 0.05, 0.04, 0.95)
    badge:SetBackdropBorderColor(GOLD[1], GOLD[2], GOLD[3], 1)
    badge:EnableMouse(true)
    badge.text = badge:CreateFontString(nil, "OVERLAY")
    badge.text:SetFont(FONT_BOLD, 11, "")
    badge.text:SetPoint("CENTER", 0, 0)
    badge.text:SetTextColor(1, 0.82, 0)
    badge.flash = badge:CreateTexture(nil, "ARTWORK")
    badge.flash:SetPoint("TOPLEFT", 1, -1)
    badge.flash:SetPoint("BOTTOMRIGHT", -1, 1)
    badge.flash:SetColorTexture(1, 0.82, 0.25, 1)
    badge.flash:SetAlpha(0)
    badge.flash:Hide()
    do
        local ag = badge.flash:CreateAnimationGroup()
        local a1 = ag:CreateAnimation("Alpha"); a1:SetFromAlpha(0); a1:SetToAlpha(0.85); a1:SetDuration(0.15); a1:SetOrder(1)
        local a2 = ag:CreateAnimation("Alpha"); a2:SetFromAlpha(0.85); a2:SetToAlpha(0); a2:SetDuration(0.9); a2:SetOrder(2)
        ag:SetScript("OnFinished", function() badge.flash:Hide() end)
        badge.flashAG = ag
    end
    badge.zzz = badge:CreateFontString(nil, "OVERLAY")
    badge.zzz:SetFont(FONT_BOLD, 10, "OUTLINE")
    badge.zzz:SetPoint("LEFT", badge, "RIGHT", 4, 0)   -- re-anchored in ApplySettings
    badge.zzz:SetTextColor(RESTED[1], RESTED[2], RESTED[3])
    badge.zzz:SetText("z Z")

    -- +xp pop
    pop = bar:CreateFontString(nil, "OVERLAY")
    pop:SetFont(FONT_BOLD, 13, "OUTLINE")
    pop:SetTextColor(1, 0.82, 0)
    pop:Hide()

    -- Hover panel
    info = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    info:SetFrameStrata("TOOLTIP")
    info:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 })
    info:SetBackdropColor(0.06, 0.05, 0.04, 0.96)
    info:SetBackdropBorderColor(GOLD[1], GOLD[2], GOLD[3], 1)
    info.lines = {}
    info:Hide()

    local function Enter() hovering = true; XP.ShowInfo(); XP.UpdateAlpha() end
    local function Leave() hovering = false; info:Hide(); XP.UpdateAlpha() end
    bar:SetScript("OnEnter", Enter)
    bar:SetScript("OnLeave", Leave)
    badge:SetScript("OnEnter", Enter)
    badge:SetScript("OnLeave", Leave)

    bar:SetScript("OnUpdate", function(self, dt)
        if pop:IsShown() then
            pop._t = (pop._t or 0) + dt
            local p = pop._t / 1.6
            if p >= 1 then pop:Hide() else
                pop:SetAlpha(1 - p * p)
                pop:ClearAllPoints()
                local up = (DB() and DB().edge == "TOP") and -1 or 1
                local right = (DB() and DB().badgePos == "right")
                pop:SetPoint(right and "RIGHT" or "LEFT", badge, right and "LEFT" or "RIGHT", right and -28 or 28, up * (14 + 18 * p))
            end
        end
        if showUntil > 0 and GetTime() > showUntil then
            showUntil = 0
            XP.UpdateAlpha()
        end
    end)
end

local function InfoLine(i)
    local l = info.lines[i]
    if l then return l end
    l = info:CreateFontString(nil, "OVERLAY")
    l:SetFont(FONT, 11, "")
    l:SetJustifyH("LEFT")
    info.lines[i] = l
    return l
end

function XP.ShowInfo()
    local db = DB()
    if not (bar and db) then return end
    local rows = {}
    local function Add(text, r, g, b, bold) rows[#rows + 1] = { text, r or 0.95, g or 0.92, b or 0.86, bold } end
    local lvl = UnitLevel("player") or 1

    if AtMaxLevel() then
        local name, _, cur, max = WatchedRep()
        if name then
            Add(name, 1, 0.82, 0, true)
            Add(string.format("%s / %s  (%.1f %%)", Fmt(cur), Fmt(max), cur / max * 100))
        else
            Add(T("Niveau maximum", "Max level"), 1, 0.82, 0, true)
            Add(T("Suis une réputation pour l'afficher ici.", "Watch a reputation to show it here."))
        end
    else
        local cur, max = UnitXP("player") or 0, math.max(1, UnitXPMax("player") or 1)
        local rested = GetXPExhaustion and GetXPExhaustion() or 0
        Add(string.format(T("Niveau %d  >  %d", "Level %d  >  %d"), lvl, lvl + 1), 1, 0.82, 0, true)
        Add(string.format("%s / %s  (%.1f %%)", Fmt(cur), Fmt(max), cur / max * 100))
        Add(string.format(T("Restant : %s", "To go: %s"), Fmt(max - cur)))
        if rested > 0 then
            Add(string.format(T("Reposé : %s  (%.0f %% du niveau)", "Rested: %s  (%.0f %% of a level)"), Fmt(rested), rested / max * 100),
                RESTED[1], RESTED[2], RESTED[3])
        end
        local elapsed = GetTime() - session.t0
        if session.gained > 0 and elapsed > 30 then
            local perH = session.gained / elapsed * 3600
            Add(string.format(T("%s xp/h  -  niveau dans %s", "%s xp/h  -  level in %s"), Fmt(perH), Duration((max - cur) / perH * 3600)),
                0.79, 0.64, 0.32)
        end
        if IsResting and IsResting() then Add(T("Zone de repos : l'XP reposée se recharge", "Resting area: rested XP is building up"), RESTED[1], RESTED[2], RESTED[3]) end
    end

    if db.showQuests ~= false then
        local ready = ReadyQuests()
        if #ready > 0 then
            Add(" ")
            Add(string.format(T("Quêtes prêtes à rendre : %d", "Quests ready to turn in: %d"), #ready), 0.30, 0.90, 0.40, true)
            for i = 1, math.min(6, #ready) do Add("  " .. ready[i]) end
            if #ready > 6 then Add(string.format(T("  et %d autre(s)...", "  and %d more..."), #ready - 6)) end
        end
    end

    local y, w = -8, 0
    for i, r in ipairs(rows) do
        local l = InfoLine(i)
        l:SetFont(r[5] and FONT_BOLD or FONT, r[5] and 12 or 11, "")
        l:SetTextColor(r[2], r[3], r[4])
        l:SetText(r[1])
        l:ClearAllPoints()
        l:SetPoint("TOPLEFT", 10, y)
        l:Show()
        w = math.max(w, l:GetStringWidth() or 0)
        y = y - (r[5] and 17 or 15)
    end
    for i = #rows + 1, #info.lines do info.lines[i]:Hide() end
    info:SetSize(w + 22, -y + 6)
    info:ClearAllPoints()
    local x = GetCursorPosition() / (UIParent:GetEffectiveScale() or 1)
    if db.edge == "TOP" then
        info:SetPoint("TOP", UIParent, "BOTTOMLEFT", math.max(info:GetWidth() / 2 + 4, x), (UIParent:GetHeight() or 768) - (db.height or 6) - 26)
    else
        info:SetPoint("BOTTOM", UIParent, "BOTTOMLEFT", math.max(info:GetWidth() / 2 + 4, x), (db.height or 6) + 26)
    end
    info:SetClampedToScreen(true)
    info:Show()
end

function XP.UpdateAlpha()
    local db = DB()
    if not (bar and db) then return end
    local mode = db.visibility or "always"
    local a = db.alpha or 1
    if hovering then a = 1
    elseif mode == "hover" then a = 0
    elseif mode == "gain" then a = (GetTime() < showUntil) and a or 0 end
    bar:SetAlpha(a)
end

function XP.Refresh()
    local db = DB()
    if not (bar and db) then return end
    local w = bar:GetWidth() or 0
    if w < 2 then return end
    local frac, restFrac, r, g, b
    if AtMaxLevel() then
        local name, reaction, cur, max = WatchedRep()
        if not (name and db.repAtMax ~= false) then bar:Hide(); return end
        frac, restFrac = cur / max, 0
        local c = FACTION_BAR_COLORS and FACTION_BAR_COLORS[reaction]
        r, g, b = c and c.r or 0.2, c and c.g or 0.7, c and c.b or 0.3
        badge.text:SetText(T("Rép.", "Rep"))
    else
        local cur, max = UnitXP("player") or 0, math.max(1, UnitXPMax("player") or 1)
        local rested = (db.showRested ~= false and GetXPExhaustion and GetXPExhaustion()) or 0
        frac = cur / max
        restFrac = math.min(1, (cur + rested) / max)
        if db.colorMode == "gold" then r, g, b = GOLD[1], GOLD[2], GOLD[3] else r, g, b = ClassColor() end
        badge.text:SetText(tostring(UnitLevel("player") or ""))
    end
    bar:Show()
    frac = math.max(0, math.min(1, frac))
    bar.fill:SetVertexColor(r, g, b, 1)
    bar.fill:SetWidth(math.max(0.001, w * frac))
    bar.fill:SetShown(frac > 0)
    bar.rested:SetVertexColor(RESTED[1], RESTED[2], RESTED[3], 0.45)
    bar.rested:SetWidth(math.max(0.001, w * restFrac))
    bar.rested:SetShown(restFrac > frac)
    bar.spark:ClearAllPoints()
    bar.spark:SetPoint("TOP", bar, "TOPLEFT", w * frac, 0)
    bar.spark:SetPoint("BOTTOM", bar, "BOTTOMLEFT", w * frac, 0)
    bar.spark:SetShown(frac > 0 and frac < 1)
    for i, t in ipairs(bar.ticks) do
        t:ClearAllPoints()
        t:SetPoint("TOP", bar, "TOPLEFT", w * i / 10, 0)
        t:SetPoint("BOTTOM", bar, "BOTTOMLEFT", w * i / 10, 0)
        t:SetShown(db.showTicks ~= false)
    end
    badge.zzz:SetShown(IsResting and IsResting() and not AtMaxLevel() or false)
    XP.UpdateAlpha()
end

-- The level badge sits on the inner side of the bar: centred by default,
-- or at either end.
PlaceBadge = function(db, side, barSide, dy)
    local pos = db.badgePos or "center"
    if pos == "left" then
        badge:SetPoint(side .. "LEFT", bar, barSide .. "LEFT", 6, dy)
    elseif pos == "right" then
        badge:SetPoint(side .. "RIGHT", bar, barSide .. "RIGHT", -6, dy)
    else
        badge:SetPoint(side, bar, barSide, 0, dy)
    end
end

-- ---------------------------------------------------------------------
-- Blizzard's own experience bar
-- ---------------------------------------------------------------------
-- Hidden by alpha, never by Hide() or SetParent(): the status tracking
-- bars are driven by secure Blizzard code (Edit Mode, UI scale), and an
-- insecure Hide() there spreads taint. The frames stay "shown" for
-- Blizzard, invisible and click-through for the player. Bars are pooled
-- and rebuilt, so the tree is re-hidden whenever Blizzard lays them out.
local BLIZZ_XP = { "MainStatusTrackingBarContainer", "MainMenuExpBar", "MainMenuBarExpBar" }
local blizzHidden = {}
local blizzHooked = false

local function WantBlizzHidden()
    local db = DB()
    return db and db.enabled and db.hideBlizzard ~= false
end

local function HideBlizzTree(f, depth)
    if not f or depth > 2 then return end
    if not f._tmXPHidden then
        f._tmXPHidden = true
        blizzHidden[#blizzHidden + 1] = f
        if not f._tmXPHooked and f.Show then
            f._tmXPHooked = true
            hooksecurefunc(f, "Show", function(self)
                if self._tmXPHidden then
                    if self.SetIgnoreParentAlpha then self:SetIgnoreParentAlpha(false) end
                    self:SetAlpha(0)
                end
            end)
        end
    end
    if f.SetIgnoreParentAlpha then f:SetIgnoreParentAlpha(false) end
    f:SetAlpha(0)
    if f.EnableMouse then f:EnableMouse(false) end
    if f.GetChildren then
        for _, child in ipairs({ f:GetChildren() }) do HideBlizzTree(child, depth + 1) end
    end
end

function XP.SuppressBlizzard()
    if WantBlizzHidden() then
        for _, name in ipairs(BLIZZ_XP) do HideBlizzTree(_G[name], 0) end
        local mgr = StatusTrackingBarManager
        if mgr and mgr.UpdateBarsShown and not blizzHooked then
            blizzHooked = true
            hooksecurefunc(mgr, "UpdateBarsShown", function()
                if WantBlizzHidden() then
                    for _, name in ipairs(BLIZZ_XP) do HideBlizzTree(_G[name], 0) end
                end
            end)
        end
    else
        for i = #blizzHidden, 1, -1 do
            local f = blizzHidden[i]
            f._tmXPHidden = nil
            f:SetAlpha(1)
            if f.EnableMouse then f:EnableMouse(true) end
            blizzHidden[i] = nil
        end
    end
end

function XP.ApplySettings()
    local db = DB()
    if not (bar and db) then return end
    local h = db.height or 6
    bar:ClearAllPoints()
    bar.edge:ClearAllPoints()
    badge:ClearAllPoints()
    if db.edge == "TOP" then
        bar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
        bar:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0)
        bar.edge:SetPoint("TOPLEFT", bar, "BOTTOMLEFT")
        bar.edge:SetPoint("TOPRIGHT", bar, "BOTTOMRIGHT")
        PlaceBadge(db, "TOP", "BOTTOM", -3)
    else
        bar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
        bar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
        bar.edge:SetPoint("BOTTOMLEFT", bar, "TOPLEFT")
        bar.edge:SetPoint("BOTTOMRIGHT", bar, "TOPRIGHT")
        PlaceBadge(db, "BOTTOM", "TOP", 3)
    end
    bar:SetHeight(h)
    XP.SuppressBlizzard()
    badge.zzz:ClearAllPoints()
    if db.badgePos == "right" then badge.zzz:SetPoint("RIGHT", badge, "LEFT", -4, 0)
    else badge.zzz:SetPoint("LEFT", badge, "RIGHT", 4, 0) end
    badge:SetShown(db.showBadge ~= false)
    XP.Refresh()
end

-- Shows the bar for a few seconds, used by the settings page.
function XP.Flash()
    showUntil = GetTime() + SHOW_AFTER_GAIN
    XP.UpdateAlpha()
end

-- ---------------------------------------------------------------------
-- Level up: a golden light runs along the bar, the badge pops and a big
-- "Level N" rises in the middle of the screen.
-- ---------------------------------------------------------------------
local burst

local function GradientHalf(parent, point, fromA, toA, width)
    local t = parent:CreateTexture(nil, "OVERLAY")
    t:SetTexture(WHITE)
    t:SetWidth(width)
    t:SetPoint("TOP" .. point); t:SetPoint("BOTTOM" .. point)
    local ok = CreateColor and pcall(t.SetGradient, t, "HORIZONTAL",
        CreateColor(1, 0.85, 0.3, fromA), CreateColor(1, 0.85, 0.3, toA))
    if not ok then t:SetColorTexture(1, 0.85, 0.3, 0.4) end
    return t
end

local function CreateBurst()
    if burst then return burst end
    burst = {}
    -- Sweep along the bar (a child of the bar: it follows its edge).
    local sweep = CreateFrame("Frame", nil, bar)
    sweep:SetSize(260, 1)
    sweep:SetPoint("TOP", bar, "TOP", 0, 6)
    sweep:SetPoint("BOTTOM", bar, "BOTTOM", 0, -6)
    sweep:SetPoint("RIGHT", bar, "LEFT", 0, 0)
    GradientHalf(sweep, "LEFT", 0, 0.9, 130)
    GradientHalf(sweep, "RIGHT", 0.9, 0, 130)
    sweep:Hide()
    local sag = sweep:CreateAnimationGroup()
    local mv = sag:CreateAnimation("Translation")
    mv:SetDuration(1.1)
    mv:SetSmoothing("IN_OUT")
    sag:SetScript("OnFinished", function() sweep:Hide() end)
    burst.sweep, burst.sweepAG, burst.move = sweep, sag, mv

    -- Big title in the middle of the screen.
    local title = CreateFrame("Frame", nil, UIParent)
    title:SetSize(400, 60)
    title:SetPoint("CENTER", UIParent, "CENTER", 0, 180)
    title:SetFrameStrata("HIGH")
    local fs = title:CreateFontString(nil, "OVERLAY")
    fs:SetFont(FONT_BOLD, 34, "OUTLINE")
    fs:SetPoint("CENTER")
    fs:SetTextColor(1, 0.82, 0)
    local sub = title:CreateFontString(nil, "OVERLAY")
    sub:SetFont(FONT, 13, "OUTLINE")
    sub:SetPoint("TOP", fs, "BOTTOM", 0, -2)
    sub:SetTextColor(0.95, 0.92, 0.86)
    sub:SetText(T("Félicitations !", "Congratulations!"))
    title:Hide()
    local tag = title:CreateAnimationGroup()
    local a1 = tag:CreateAnimation("Alpha"); a1:SetFromAlpha(0); a1:SetToAlpha(1); a1:SetDuration(0.25); a1:SetOrder(1)
    local s1 = tag:CreateAnimation("Scale"); s1:SetScaleFrom(0.6, 0.6); s1:SetScaleTo(1, 1); s1:SetDuration(0.35); s1:SetSmoothing("OUT"); s1:SetOrder(1)
    local up = tag:CreateAnimation("Translation"); up:SetOffset(0, 24); up:SetDuration(2.6); up:SetOrder(1)
    local a2 = tag:CreateAnimation("Alpha"); a2:SetFromAlpha(1); a2:SetToAlpha(0); a2:SetDuration(0.7); a2:SetStartDelay(1.9); a2:SetOrder(1)
    tag:SetScript("OnFinished", function() title:Hide() end)
    burst.title, burst.titleFS, burst.titleAG = title, fs, tag
    return burst
end

function XP.PlayLevelUp(level)
    if not bar then return end
    local b = CreateBurst()
    b.move:SetOffset((bar:GetWidth() or 1920) + 260, 0)
    b.sweep:Show()
    if b.sweepAG:IsPlaying() then b.sweepAG:Stop() end
    b.sweepAG:Play()
    b.titleFS:SetText(string.format(T("Niveau %d !", "Level %d!"), level or UnitLevel("player") or 1))
    b.title:Show()
    if b.titleAG:IsPlaying() then b.titleAG:Stop() end
    b.titleAG:Play()
    -- Scaling a backdrop frame tears its border into long lines, so the
    -- number pops on its own and the badge gets a golden flash instead.
    if TomoMod_Utils.Pop and badge then TomoMod_Utils.Pop(badge.text, 1.8, 0.6) end
    if badge and badge.flashAG then
        if badge.flashAG:IsPlaying() then badge.flashAG:Stop() end
        badge.flash:Show()
        badge.flashAG:Play()
    end
    -- Make sure the bar is visible for the show, whatever the mode.
    showUntil = GetTime() + SHOW_AFTER_GAIN
    XP.UpdateAlpha()
end

local function OnXPChanged()
    local db = DB()
    local cur, lvl = UnitXP("player") or 0, UnitLevel("player") or 1
    if lastXP and lastLevel then
        local gained
        if lvl > lastLevel then gained = nil else gained = cur - lastXP end
        if gained and gained > 0 then
            session.gained = session.gained + gained
            if db and db.gainText ~= false and pop then
                pop:SetText("+" .. Fmt(gained) .. " xp")
                pop._t = 0
                pop:SetAlpha(1)
                pop:Show()
            end
            showUntil = GetTime() + SHOW_AFTER_GAIN
        end
    end
    lastXP, lastLevel = cur, lvl
    XP.Refresh()
end

function XP.SetEnabled(v)
    local db = DB()
    if not db then return end
    db.enabled = v and true or false
    if v then
        if not bar then XP.Initialize() return end
        XP.ApplySettings()
    elseif bar then
        bar:Hide()
        if info then info:Hide() end
    end
    XP.SuppressBlizzard()
end

function XP.Initialize()
    local db = DB()
    if not (db and db.enabled) then return end
    if bar then XP.ApplySettings() return end
    Create()
    session.t0 = GetTime()
    lastXP, lastLevel = UnitXP("player"), UnitLevel("player")
    local f = CreateFrame("Frame")
    for _, e in ipairs({ "PLAYER_ENTERING_WORLD", "PLAYER_XP_UPDATE", "PLAYER_LEVEL_UP", "UPDATE_EXHAUSTION",
                         "PLAYER_UPDATE_RESTING", "UPDATE_FACTION", "DISPLAY_SIZE_CHANGED", "UI_SCALE_CHANGED" }) do
        pcall(f.RegisterEvent, f, e)
    end
    f:SetScript("OnEvent", function(_, event, arg1)
        local d = DB()
        if not (d and d.enabled) then return end
        if event == "PLAYER_LEVEL_UP" and d.levelUpBurst ~= false then
            local lvl = arg1
            C_Timer.After(0.1, function() XP.PlayLevelUp(lvl) end)
        end
        if event == "PLAYER_XP_UPDATE" or event == "PLAYER_LEVEL_UP" then
            C_Timer.After(0, OnXPChanged)
        elseif event == "PLAYER_ENTERING_WORLD" then
            XP.SuppressBlizzard()
            XP.Refresh()
        elseif event == "DISPLAY_SIZE_CHANGED" or event == "UI_SCALE_CHANGED" then
            C_Timer.After(0, XP.ApplySettings)
        else
            XP.Refresh()
        end
    end)
    bar:SetScript("OnSizeChanged", function() XP.Refresh() end)
    XP.ApplySettings()
end
