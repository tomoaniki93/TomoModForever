-- =====================================================================
-- Modules/QOL/Forever/TrainerReminder.lua -- "visit your class trainer"
--
-- On WoW: Forever new class spells come every second level. This module
-- shows a small, discreet panel when you level up (and at login) listing
-- what is waiting at your class trainer: icon, name, rank, price, and the
-- total next to what you carry.
--
-- Where the list comes from. The game only tells what a trainer teaches
-- while its window is open, so each visit to your class trainer is read
-- whole, the spells you cannot learn yet included, with their required
-- level. That list is kept per character (TomoModForeverCharDB.trainer).
-- After that, every level up shows the spells that just became
-- available, without going anywhere. Before the first visit, the panel
-- can only say that an even level usually brings new spells.
--
-- The trainer window filters ("available / unavailable / used") are
-- turned on for the read and put back as they were. Profession and pet
-- trainers are ignored. The panel hides as soon as you talk to a class
-- trainer, after a delay (option), or on right click.
-- =====================================================================

TomoMod_TrainerReminder = TomoMod_TrainerReminder or {}
local TR = TomoMod_TrainerReminder

local FONT      = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local FONT_BOLD = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-SemiBold.ttf"
local SOLID     = "Interface\\Buttons\\WHITE8X8"
local BOOK_ICON = "Interface\\Icons\\INV_Misc_Book_09"
local QMARK     = "Interface\\Icons\\INV_Misc_QuestionMark"

-- WoW: Forever palette
local BRONZE = { 0.545, 0.420, 0.247 }   -- #8B6B3F
local GOLD   = { 0.788, 0.635, 0.322 }   -- #C9A252
local YELLOW = { 1.000, 0.820, 0.000 }   -- #FFD100
local TEXT   = { 0.949, 0.922, 0.859 }   -- #F2EBDB
local DIM    = { 0.660, 0.620, 0.540 }
local RED    = { 1.000, 0.400, 0.300 }

local WIDTH      = 250
local ROW_H      = 18
local MAX_ROWS   = 8
local LEVELUP_DELAY = 2
local LOGIN_DELAY   = 6   -- after the bag banner, so both do not land at once

local IS_FR = GetLocale() == "frFR"
local function T(fr, en)
    if TomoMod_GUIT then return TomoMod_GUIT(fr, en) end
    return IS_FR and fr or en
end

local function DB() return TomoModForeverDB and TomoModForeverDB.trainerReminder end

local function Coins(copper)
    if C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString then
        return C_CurrencyInfo.GetCoinTextureString(copper)
    elseif GetCoinTextureString then
        return GetCoinTextureString(copper)
    end
    return tostring(copper)
end

-- Per-character cache: { class, scanned = time(), spells = { {name, rank, icon, cost, level}, ... } }
local function Cache()
    if type(_G.TomoModForeverCharDB) ~= "table" then _G.TomoModForeverCharDB = {} end
    local c = _G.TomoModForeverCharDB
    local _, class = UnitClass("player")
    if type(c.trainer) ~= "table" or c.trainer.class ~= class then
        c.trainer = { class = class, spells = {} }
    end
    c.trainer.spells = c.trainer.spells or {}
    return c.trainer
end

local function PlayerLevel(override)
    return override or (UnitLevel and UnitLevel("player")) or 1
end

-- Spells you can learn now (required level reached), cheapest first.
local function Pending(level)
    local out = {}
    for _, s in ipairs(Cache().spells) do
        if (s.level or 1) <= level then out[#out + 1] = s end
    end
    table.sort(out, function(a, b)
        if (a.level or 0) ~= (b.level or 0) then return (a.level or 0) > (b.level or 0) end
        return (a.cost or 0) < (b.cost or 0)
    end)
    return out
end
TR.Pending = function() return Pending(PlayerLevel()) end

-- ---------------------------------------------------------------------
-- Trainer read
-- ---------------------------------------------------------------------
local FILTERS = { "available", "unavailable", "used" }
local scanning = false
local scanQueued = false
local quietUntil = 0   -- our own filter flips fire TRAINER_UPDATE: ignore them

local function IsClassTrainer()
    if IsTradeskillTrainer and IsTradeskillTrainer() then return false end
    -- Hunter pet trainers use training points.
    if ClassTrainerFrame and ClassTrainerFrame.trainingPoints and ClassTrainerFrame.trainingPoints:IsShown() then
        return false
    end
    return GetNumTrainerServices ~= nil
end

-- The filter calls take a real boolean on this client: passing 1 / 0
-- throws "Missing on/off parameter".
local function SetFilter(f, on)
    SetTrainerServiceTypeFilter(f, on and true or false)
end

local function ReadServices()
    -- Show every kind of service for the read, then put the filters back.
    local saved = {}
    if GetTrainerServiceTypeFilter and SetTrainerServiceTypeFilter then
        for _, f in ipairs(FILTERS) do
            local on = GetTrainerServiceTypeFilter(f)
            saved[f] = on and true or false
            if not on then SetFilter(f, true) end
        end
    end

    local spells, sawAny = {}, false
    local n = GetNumTrainerServices() or 0
    for i = 1, n do
        local name, rank, status = GetTrainerServiceInfo(i)
        if status and status ~= "header" then sawAny = true end
        if name and (status == "available" or status == "unavailable") then
            local level = GetTrainerServiceLevelReq and GetTrainerServiceLevelReq(i) or 1
            spells[#spells + 1] = {
                name  = name,
                rank  = (rank and rank ~= "") and rank or nil,
                icon  = GetTrainerServiceIcon and GetTrainerServiceIcon(i) or nil,
                cost  = GetTrainerServiceCost and GetTrainerServiceCost(i) or 0,
                level = (type(level) == "number" and level > 0) and level or 1,
            }
        end
    end

    if GetTrainerServiceTypeFilter and SetTrainerServiceTypeFilter then
        for _, f in ipairs(FILTERS) do
            if saved[f] == false then SetFilter(f, false) end
        end
    end

    -- An empty read (window still loading) must not wipe a good cache.
    if sawAny then
        local c = Cache()
        c.spells = spells
        c.scanned = time()
    end
end

local function ScanTrainer()
    if scanning or not IsClassTrainer() then return end
    scanning = true
    -- Whatever happens in the read, the flag must come back down, or no
    -- later visit would ever be read again this session.
    local ok, err = pcall(ReadServices)
    scanning = false
    quietUntil = GetTime() + 0.5
    if not ok then geterrorhandler()(err) end
end

-- ---------------------------------------------------------------------
-- Panel
-- ---------------------------------------------------------------------
local panel
local rows = {}
local preview = false

local function Frame4(parent, size, c)
    for _, side in ipairs({ "TOP", "BOTTOM", "LEFT", "RIGHT" }) do
        local t = parent:CreateTexture(nil, "BORDER")
        t:SetTexture(SOLID)
        t:SetVertexColor(c[1], c[2], c[3], 1)
        if side == "TOP" or side == "BOTTOM" then
            t:SetPoint(side .. "LEFT"); t:SetPoint(side .. "RIGHT"); t:SetHeight(size)
        else
            t:SetPoint("TOP" .. side); t:SetPoint("BOTTOM" .. side); t:SetWidth(size)
        end
    end
end

local function GetRow(i)
    if rows[i] then return rows[i] end
    local r = CreateFrame("Frame", nil, panel)
    r:SetHeight(ROW_H)
    r:SetPoint("TOPLEFT", panel, "TOPLEFT", 8, -38 - (i - 1) * ROW_H)
    r:SetPoint("RIGHT", panel, "RIGHT", -8, 0)

    local icon = r:CreateTexture(nil, "ARTWORK")
    icon:SetSize(ROW_H - 3, ROW_H - 3)
    icon:SetPoint("LEFT")
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    r.icon = icon

    local cost = r:CreateFontString(nil, "OVERLAY")
    cost:SetFont(FONT, 10, "OUTLINE")
    cost:SetPoint("RIGHT")
    cost:SetJustifyH("RIGHT")
    cost:SetTextColor(TEXT[1], TEXT[2], TEXT[3])
    r.cost = cost

    local name = r:CreateFontString(nil, "OVERLAY")
    name:SetFont(FONT, 10, "OUTLINE")
    name:SetPoint("LEFT", icon, "RIGHT", 5, 0)
    name:SetPoint("RIGHT", cost, "LEFT", -6, 0)
    name:SetJustifyH("LEFT")
    name:SetWordWrap(false)
    name:SetTextColor(TEXT[1], TEXT[2], TEXT[3])
    r.name = name

    rows[i] = r
    return r
end

local function Hide()
    if not panel or not panel:IsShown() then return end
    if panel.fadeOut:IsPlaying() then return end
    panel.holdLeft = nil
    panel.fadeOut:Play()
end

local function CreatePanel()
    if panel then return panel end
    panel = CreateFrame("Button", "TomoMod_TrainerReminderFrame", UIParent)   -- not the module's own global name
    panel:SetWidth(WIDTH)
    panel:SetFrameStrata("MEDIUM")
    panel:SetClampedToScreen(true)
    panel:RegisterForClicks("RightButtonUp")

    local bg = panel:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(SOLID)
    bg:SetVertexColor(0.06, 0.05, 0.04, 0.85)
    Frame4(panel, 1, BRONZE)

    -- Thin gold accent on the left edge.
    local accent = panel:CreateTexture(nil, "ARTWORK")
    accent:SetTexture(SOLID)
    accent:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 1)
    accent:SetPoint("TOPLEFT", 1, -1)
    accent:SetPoint("BOTTOMLEFT", 1, 1)
    accent:SetWidth(2)

    local icon = panel:CreateTexture(nil, "ARTWORK")
    icon:SetSize(24, 24)
    icon:SetPoint("TOPLEFT", 8, -7)
    icon:SetTexture(BOOK_ICON)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    panel.icon = icon

    local title = panel:CreateFontString(nil, "OVERLAY")
    title:SetFont(FONT_BOLD, 12, "OUTLINE")
    title:SetPoint("TOPLEFT", icon, "TOPRIGHT", 7, 0)
    title:SetPoint("RIGHT", panel, "RIGHT", -8, 0)
    title:SetJustifyH("LEFT")
    title:SetWordWrap(false)
    title:SetTextColor(YELLOW[1], YELLOW[2], YELLOW[3])
    panel.title = title

    local sub = panel:CreateFontString(nil, "OVERLAY")
    sub:SetFont(FONT, 10, "OUTLINE")
    sub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
    sub:SetWidth(WIDTH - 47)
    sub:SetJustifyH("LEFT")
    sub:SetWordWrap(true)
    sub:SetTextColor(DIM[1], DIM[2], DIM[3])
    panel.sub = sub

    local sep = panel:CreateTexture(nil, "ARTWORK")
    sep:SetTexture(SOLID)
    sep:SetVertexColor(BRONZE[1], BRONZE[2], BRONZE[3], 0.6)
    sep:SetHeight(1)
    panel.sep = sep

    local total = panel:CreateFontString(nil, "OVERLAY")
    total:SetFont(FONT_BOLD, 10, "OUTLINE")
    total:SetJustifyH("RIGHT")
    panel.total = total

    local more = panel:CreateFontString(nil, "OVERLAY")
    more:SetFont(FONT, 10, "OUTLINE")
    more:SetJustifyH("LEFT")
    more:SetTextColor(DIM[1], DIM[2], DIM[3])
    panel.more = more

    -- Gentle fade in, gold glint on the book.
    local intro = panel:CreateAnimationGroup()
    local a = intro:CreateAnimation("Alpha")
    a:SetFromAlpha(0); a:SetToAlpha(1); a:SetDuration(0.4); a:SetSmoothing("OUT")
    intro:SetToFinalAlpha(true)
    panel.intro = intro

    local glint = icon:CreateAnimationGroup()
    for i = 1, 4 do
        local g = glint:CreateAnimation("Alpha")
        local down = (i % 2 == 1)
        g:SetFromAlpha(down and 1 or 0.35); g:SetToAlpha(down and 0.35 or 1)
        g:SetDuration(0.25); g:SetOrder(i)
    end
    panel.glint = glint

    local fadeOut = panel:CreateAnimationGroup()
    local fo = fadeOut:CreateAnimation("Alpha")
    fo:SetFromAlpha(1); fo:SetToAlpha(0); fo:SetDuration(0.5)
    fadeOut:SetToFinalAlpha(true)
    fadeOut:SetScript("OnFinished", function() panel:Hide(); panel:SetAlpha(1) end)
    panel.fadeOut = fadeOut

    panel:SetScript("OnClick", function()
        if preview then TR.Preview(false) else Hide() end
    end)
    panel:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT", -4, 0)
        GameTooltip:ClearLines()
        GameTooltip:AddLine(T("Maître de classe", "Class trainer"), YELLOW[1], YELLOW[2], YELLOW[3])
        local c = Cache()
        if c.scanned then
            GameTooltip:AddLine(string.format(T("Liste lue chez ton maître le %s.", "List read at your trainer on %s."),
                date("%d/%m %H:%M", c.scanned)), TEXT[1], TEXT[2], TEXT[3], true)
        end
        GameTooltip:AddLine(T("Clic droit : fermer", "Right click: close"), DIM[1], DIM[2], DIM[3])
        GameTooltip:Show()
    end)
    panel:SetScript("OnLeave", function() GameTooltip:Hide() end)
    panel:SetScript("OnUpdate", function(self, elapsed)
        if self.holdLeft and not preview and not self:IsMouseOver() then
            self.holdLeft = self.holdLeft - elapsed
            if self.holdLeft <= 0 then Hide() end
        end
    end)

    local U = TomoMod_Utils
    if U and U.SetupDraggable then
        U.SetupDraggable(panel, function()
            local d = DB()
            if d then
                d.position = d.position or {}
                U.SaveFramePosition(panel, d.position)
            end
        end, T("Maître de classe", "Class trainer"))
    end

    panel:Hide()
    TR.ApplySettings()
    return panel
end

-- list: spells to show (may be empty for the generic reminder).
local function Show(level, list, silent)
    local db = DB()
    if not db then return end
    CreatePanel()

    local count = #list
    if count > 0 then
        panel.title:SetText(T("Visite ton maître de classe", "Visit your class trainer"))
        panel.sub:SetText(string.format(T("Niveau %d : %d sort(s) à apprendre", "Level %d: %d spell(s) to learn"), level, count))
    else
        panel.title:SetText(string.format(T("Niveau %d", "Level %d"), level))
        panel.sub:SetText(T("De nouveaux sorts t'attendent sans doute chez ton maître de classe. Une visite et la liste sera connue pour les prochains niveaux.",
                            "New spells are probably waiting at your class trainer. One visit and the list will be known for the next levels."))
    end

    -- Rows
    local shown = math.min(count, MAX_ROWS)
    local sum = 0
    for _, s in ipairs(list) do sum = sum + (s.cost or 0) end
    for i = 1, #rows do rows[i]:Hide() end
    for i = 1, shown do
        local s, r = list[i], GetRow(i)
        r.icon:SetTexture(s.icon or QMARK)
        local label = s.name or "?"
        if s.rank then label = label .. " |cffa89e8a(" .. s.rank .. ")|r" end
        r.name:SetText(label)
        r.cost:SetText((s.cost or 0) > 0 and Coins(s.cost) or T("gratuit", "free"))
        r:Show()
    end

    -- Header height depends on the wrapped subtitle.
    local headerH = math.max(38, 7 + 14 + 2 + panel.sub:GetStringHeight() + 6)
    for i = 1, shown do
        rows[i]:ClearAllPoints()
        rows[i]:SetPoint("TOPLEFT", panel, "TOPLEFT", 8, -headerH - (i - 1) * ROW_H)
        rows[i]:SetPoint("RIGHT", panel, "RIGHT", -8, 0)
    end

    local y = headerH + shown * ROW_H
    panel.more:ClearAllPoints()
    panel.sep:ClearAllPoints()
    panel.total:ClearAllPoints()
    if count > 0 then
        if count > shown then
            panel.more:SetPoint("TOPLEFT", panel, "TOPLEFT", 8, -y - 1)
            panel.more:SetText(string.format(T("+ %d autre(s)", "+ %d more"), count - shown))
            panel.more:Show()
        else
            panel.more:Hide()
        end
        panel.sep:SetPoint("TOPLEFT", panel, "TOPLEFT", 8, -y - (count > shown and 15 or 3))
        panel.sep:SetPoint("RIGHT", panel, "RIGHT", -8, 0)
        panel.sep:Show()
        panel.total:SetPoint("TOPRIGHT", panel.sep, "BOTTOMRIGHT", 0, -4)
        local afford = GetMoney() >= sum
        local c = afford and YELLOW or RED
        panel.total:SetTextColor(c[1], c[2], c[3])
        panel.total:SetText(T("Total : ", "Total: ") .. Coins(sum)
            .. (afford and "" or (" |cffff6650" .. T("(fonds insuffisants)", "(not enough money)") .. "|r")))
        panel.total:Show()
        y = y + (count > shown and 15 or 3) + 20
    else
        panel.more:Hide(); panel.sep:Hide(); panel.total:Hide()
    end
    panel:SetHeight(y + 6)

    panel.holdLeft = (db.duration or 0) > 0 and db.duration or nil
    panel.fadeOut:Stop()
    panel:SetAlpha(1)
    panel:Show()
    panel.intro:Play()
    panel.glint:Play()
    if db.sound and not silent then
        PlaySound((SOUNDKIT and SOUNDKIT.IG_SPELLBOOK_OPEN) or 829, "Master")
    end
end

-- ---------------------------------------------------------------------
-- Triggers
-- ---------------------------------------------------------------------
local function Remind(level, fromLogin)
    local db = DB()
    if not (db and db.enabled) then return end
    if InCombatLockdown() then
        TR._pending = { level, fromLogin }
        return
    end
    local list = Pending(level)
    if #list > 0 then
        Show(level, list)
    elseif not fromLogin and db.genericReminder and not Cache().scanned and level % 2 == 0 then
        Show(level, list)
    end
end

-- ---------------------------------------------------------------------
-- Public
-- ---------------------------------------------------------------------
function TR.ApplySettings()
    local db = DB()
    if not (db and panel) then return end
    panel:SetScale(db.scale or 1)
    local U = TomoMod_Utils
    if U and U.ApplyFramePosition and db.position then U.ApplyFramePosition(panel, db.position) end
    if preview then TR.Preview(true) end
end

function TR.Preview(on)
    preview = on and true or false
    if preview then
        local level = PlayerLevel()
        local list = Pending(level)
        if #list == 0 then
            list = {
                { name = T("Éclair", "Lightning Bolt"), rank = T("Rang 4", "Rank 4"), icon = "Interface\\Icons\\Spell_Nature_Lightning", cost = 1800 },
                { name = T("Soins inférieurs", "Lesser Healing Wave"), rank = T("Rang 1", "Rank 1"), icon = "Interface\\Icons\\Spell_Nature_HealingWaveLesser", cost = 2000 },
                { name = T("Totem de peau de pierre", "Stoneskin Totem"), rank = T("Rang 2", "Rank 2"), icon = "Interface\\Icons\\Spell_Nature_StoneSkinTotem", cost = 1500 },
            }
        end
        Show(level, list, true)
    elseif panel and panel:IsShown() then
        Hide()
    end
end
function TR.IsPreview() return preview end

function TR.SetEnabled(v)
    local db = DB()
    if not db then return end
    db.enabled = v and true or false
    if not v then
        preview = false
        if panel then panel:Hide() end
    end
end

function TR.Initialize()
    if not DB() then return end
    Cache()
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_LEVEL_UP")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("TRAINER_SHOW")
    f:RegisterEvent("TRAINER_UPDATE")
    f:RegisterEvent("PLAYER_REGEN_ENABLED")
    f:SetScript("OnEvent", function(_, event, arg1)
        if event == "TRAINER_SHOW" then
            -- The service list fills a moment after the window opens.
            C_Timer.After(0.2, function()
                if IsClassTrainer() then
                    ScanTrainer()
                    if panel and panel:IsShown() and not preview then Hide() end
                end
            end)
        elseif event == "TRAINER_UPDATE" then
            -- Learning a spell (or "Train all") changes the list.
            if scanning or scanQueued or GetTime() < quietUntil then return end
            scanQueued = true
            C_Timer.After(0.3, function() scanQueued = false; ScanTrainer() end)
        elseif event == "PLAYER_LEVEL_UP" then
            local level = tonumber(arg1)
            C_Timer.After(LEVELUP_DELAY, function() Remind(PlayerLevel(level), false) end)
        elseif event == "PLAYER_ENTERING_WORLD" then
            local db = DB()
            if arg1 and db and db.onLogin then
                C_Timer.After(LOGIN_DELAY, function() Remind(PlayerLevel(), true) end)
            end
        elseif event == "PLAYER_REGEN_ENABLED" then
            local p = TR._pending
            if p then TR._pending = nil; Remind(p[1], p[2]) end
        end
    end)

    if TomoMod_Movers and TomoMod_Movers.RegisterEntry then
        TomoMod_Movers.RegisterEntry({
            label    = T("Maître de classe", "Class trainer"),
            unlock   = function() TR.Preview(true); if panel and panel.SetLocked then panel:SetLocked(false) end end,
            lock     = function() if panel and panel.SetLocked then panel:SetLocked(true) end; TR.Preview(false) end,
            isActive = function() local d = DB(); return d and d.enabled end,
        })
    end
end
