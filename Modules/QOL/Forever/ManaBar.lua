-- =====================================================================
-- Modules/QOL/Forever/ManaBar.lua -- five-second rule and spell cost
--                                    on the player's mana bar (1.3.6)
--
-- On WoW: Forever mana is the scarce resource, and two things decide how
-- much a caster gets back:
--   * the five-second rule: Spirit regeneration stops when a spell that
--     costs mana goes off, and comes back five seconds later. A bright
--     spark crosses the mana bar over those five seconds; another mana
--     spell starts it again.
--   * regen ticks: after the window, mana comes back in ticks every two
--     seconds. Dimmer sparks run back to back, two seconds each, as long
--     as mana keeps moving (a sweep that sees no mana change stops them:
--     the bar is full, or nothing regenerates). An estimate: the server
--     does not tell its tick clock.
-- And while a spell with a cast time is being cast, the mana it will cost
-- is drawn lighter on the end of the bar, like Blizzard's own player frame.
--
-- The host is the power bar of TMF's player frame (TMF or Forever style),
-- only while it shows mana. Secret-safe: a spell's cost and the bar's
-- maximum only reach SetMinMaxValues / SetValue of a bar of our own, never
-- a comparison or a sum; mana changes are noticed from the event alone.
-- =====================================================================

TomoMod_ManaBar = TomoMod_ManaBar or {}
local MB = TomoMod_ManaBar

local SPARK = "Interface\\CastingBar\\UI-CastingBar-Spark"
local SOLID = "Interface\\Buttons\\WHITE8X8"
local WINDOW, TICK = 5, 2
local MANA = (Enum and Enum.PowerType and Enum.PowerType.Mana) or 0

local function DB() return TomoModForeverDB and TomoModForeverDB.manaBar end

local function Readable(v)
    if type(issecretvalue) == "function" and issecretvalue(v) then return nil end
    return v
end

local function Host()
    local f = _G.TomoMod_UF_player
    local bar = f and f.power
    if bar and bar.GetStatusBarTexture and bar:IsVisible() then return bar end
end

local function ShowsMana()
    local pt = Readable(UnitPowerType("player"))
    return pt == nil or pt == MANA
end

-- Mana cost of a spell, as the game gives it (may be secret).
local function ManaCost(spellID)
    if not (spellID and C_Spell and C_Spell.GetSpellPowerCost) then return nil end
    local ok, costs = pcall(C_Spell.GetSpellPowerCost, spellID)
    if not ok or type(costs) ~= "table" then return nil end
    for _, c in ipairs(costs) do
        local t = Readable(c.type)
        if t == MANA then
            local cost = c.cost
            local plain = Readable(cost)
            if plain == nil or plain > 0 then return cost end
        end
    end
    return nil
end

-- ---------------------------------------------------------------------
-- Overlay
-- ---------------------------------------------------------------------
local ov            -- frame over the host bar, clipped to it
local hostBar
local mode          -- nil | "window" | "tick"
local sweepStart, sweepLen = 0, 0
local manaMoved = false

local function Build(host)
    if ov and hostBar == host then return ov end
    if not ov then
        ov = CreateFrame("Frame", nil, host)
        ov:EnableMouse(false)
        if ov.SetClipsChildren then ov:SetClipsChildren(true) end

        ov.spark = ov:CreateTexture(nil, "OVERLAY", nil, 7)
        ov.spark:SetTexture(SPARK)
        ov.spark:SetBlendMode("ADD")
        ov.spark:Hide()

        -- Cost: a bar of our own, as wide as the host, anchored at the end of
        -- the host's fill and filling back over it.
        ov.cost = CreateFrame("StatusBar", nil, ov)
        ov.cost:SetStatusBarTexture(SOLID)
        ov.cost:SetStatusBarColor(0.70, 0.85, 1.00, 0.55)
        ov.cost:Hide()
    end
    hostBar = host
    ov:SetParent(host)
    ov:ClearAllPoints()
    ov:SetAllPoints(host)
    ov:SetFrameLevel(host:GetFrameLevel() + 3)
    return ov
end

local function StopSweep()
    mode = nil
    if ov then
        ov.spark:Hide()
        ov:SetScript("OnUpdate", nil)
    end
end

local function OnUpdate(self)
    local host = hostBar
    if not (host and host:IsVisible()) or not mode then StopSweep() return end
    local t = (GetTime() - sweepStart) / sweepLen
    if t >= 1 then
        local db = DB()
        if mode == "window" or (mode == "tick" and manaMoved) then
            if db and db.ticks ~= false then
                mode, sweepStart, sweepLen, manaMoved = "tick", GetTime(), TICK, false
                self.spark:SetVertexColor(0.45, 0.70, 1.00, 0.70)
                return
            end
        end
        StopSweep()
        return
    end
    local w = host:GetWidth() or 0
    self.spark:ClearAllPoints()
    self.spark:SetPoint("CENTER", host, "LEFT", w * t, 0)
end

local function StartWindow()
    local db = DB()
    if not (db and db.enabled and db.fiveSecond ~= false) then return end
    local host = Host()
    if not host or not ShowsMana() then return end
    local o = Build(host)
    local h = host:GetHeight() or 10
    o.spark:SetSize(math.max(8, h * 1.1), h * 2.2)
    o.spark:SetVertexColor(1, 0.95, 0.75, 1)
    o.spark:Show()
    mode, sweepStart, sweepLen, manaMoved = "window", GetTime(), WINDOW, false
    o:SetScript("OnUpdate", OnUpdate)
end

local function ShowCost(spellID)
    local db = DB()
    if not (db and db.enabled and db.costPrediction ~= false) then return end
    local host = Host()
    if not host or not ShowsMana() then return end
    local cost = ManaCost(spellID)
    if cost == nil then return end
    local o = Build(host)
    local fill = host:GetStatusBarTexture()
    if not fill then return end
    local reverse = host.GetReverseFill and host:GetReverseFill()
    local bar = o.cost
    bar:ClearAllPoints()
    if reverse then
        bar:SetPoint("TOPLEFT", fill, "TOPLEFT", 0, 0)
        bar:SetPoint("BOTTOMLEFT", fill, "BOTTOMLEFT", 0, 0)
        bar:SetReverseFill(false)
    else
        bar:SetPoint("TOPRIGHT", fill, "TOPRIGHT", 0, 0)
        bar:SetPoint("BOTTOMRIGHT", fill, "BOTTOMRIGHT", 0, 0)
        bar:SetReverseFill(true)
    end
    bar:SetWidth(host:GetWidth() or 1)
    bar:SetMinMaxValues(0, UnitPowerMax("player", MANA))
    bar:SetValue(cost)
    bar:Show()
end

local function HideCost()
    if ov then ov.cost:Hide() end
end

-- ---------------------------------------------------------------------
-- Events
-- ---------------------------------------------------------------------
local ev = CreateFrame("Frame")
ev:SetScript("OnEvent", function(_, event, _, a2, a3)
    if event == "UNIT_POWER_UPDATE" then
        -- (unit, powerToken): only mana moves count for the ticks.
        if a2 == "MANA" then manaMoved = true end
        return
    end
    -- Spellcast events: (unit, castGUID, spellID).
    local spellID = Readable(a3)
    if event == "UNIT_SPELLCAST_SUCCEEDED" or event == "UNIT_SPELLCAST_CHANNEL_START" then
        if ManaCost(spellID) ~= nil then StartWindow() end
        if event == "UNIT_SPELLCAST_SUCCEEDED" then HideCost() end
    elseif event == "UNIT_SPELLCAST_START" then
        ShowCost(spellID)
    else
        HideCost()
    end
end)

function MB.ApplySettings()
    local db = DB()
    ev:UnregisterAllEvents()
    if not (db and db.enabled) then
        StopSweep()
        HideCost()
        return
    end
    for _, e in ipairs({ "UNIT_SPELLCAST_SUCCEEDED", "UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_START",
                         "UNIT_SPELLCAST_STOP", "UNIT_SPELLCAST_FAILED", "UNIT_SPELLCAST_INTERRUPTED" }) do
        ev:RegisterUnitEvent(e, "player")
    end
    ev:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
    if db.fiveSecond == false then StopSweep() end
    if db.costPrediction == false then HideCost() end
end

function MB.SetEnabled(v)
    local db = DB()
    if not db then return end
    db.enabled = v and true or false
    MB.ApplySettings()
end

--- Options preview: one five-second sweep on the bar.
function MB.Test()
    local db = DB()
    if not db then return end
    local was = db.enabled
    db.enabled = true
    StartWindow()
    db.enabled = was
end

function MB.Initialize()
    if not DB() then return end
    MB.ApplySettings()
end
