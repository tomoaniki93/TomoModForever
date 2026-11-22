-- =====================================================================
-- Modules/QOL/Forever/EdgeAlerts.lua -- screen edge alerts (1.3.7)
--
-- A glow along the edges of the screen:
--   * red, breathing, when your health is under its threshold
--   * blue when your mana is under its threshold (mana users only, in
--     combat only by default: drinking would light it every time)
-- Health wins when both are due. Nothing while dead or a ghost.
--
-- The glow is four gradient textures (dark in the middle of the screen,
-- coloured at the edge), drawn under the interface and click-through. The
-- breathing is an AnimationGroup (engine side); with animations reduced or
-- off the glow stays steady, never hidden: it is an alert.
--
-- Needs readable health and mana. Where the client keeps them secret, the
-- engine's percent curves (UnitHealthPercent / UnitPowerPercent with a
-- colour curve) light the glow without the addon ever reading the value.
-- =====================================================================

TomoMod_EdgeAlerts = TomoMod_EdgeAlerts or {}
local EA = TomoMod_EdgeAlerts

local WHITE = "Interface\\Buttons\\WHITE8x8"
local COLORS = {
    health = { 1.00, 0.10, 0.06 },
    mana   = { 0.15, 0.45, 1.00 },
}

local holder, glow, pulse
local edges = {}
local current            -- "health" | "mana" | nil
local inCombat = false
local curves = {}

local function DB() return TomoModForeverDB and TomoModForeverDB.edgeAlerts end

local function Secret(v)
    return type(issecretvalue) == "function" and issecretvalue(v) or false
end

-- ---------------------------------------------------------------------
-- Frames
-- ---------------------------------------------------------------------
local function Gradient(tex, orient, r, g, b, a1, a2)
    tex:SetTexture(WHITE)
    local ok = CreateColor and pcall(tex.SetGradient, tex, orient, CreateColor(r, g, b, a1), CreateColor(r, g, b, a2))
    if not ok then tex:SetColorTexture(r, g, b, (a1 + a2) / 2) end
end

local function Create()
    if holder then return end
    holder = CreateFrame("Frame", "TomoMod_EdgeAlertFrame", UIParent)
    holder:SetAllPoints(UIParent)
    holder:SetFrameStrata("BACKGROUND")
    holder:SetFrameLevel(0)
    holder:EnableMouse(false)
    holder:Hide()

    -- Inner frame: its alpha breathes; the holder's alpha carries the
    -- secret-safe curve when it is used.
    glow = CreateFrame("Frame", nil, holder)
    glow:SetAllPoints()
    glow:EnableMouse(false)

    edges.top    = glow:CreateTexture(nil, "BACKGROUND")
    edges.bottom = glow:CreateTexture(nil, "BACKGROUND")
    edges.left   = glow:CreateTexture(nil, "BACKGROUND")
    edges.right  = glow:CreateTexture(nil, "BACKGROUND")
    edges.top:SetPoint("TOPLEFT");        edges.top:SetPoint("TOPRIGHT")
    edges.bottom:SetPoint("BOTTOMLEFT");  edges.bottom:SetPoint("BOTTOMRIGHT")
    edges.left:SetPoint("TOPLEFT");       edges.left:SetPoint("BOTTOMLEFT")
    edges.right:SetPoint("TOPRIGHT");     edges.right:SetPoint("BOTTOMRIGHT")

    pulse = glow:CreateAnimationGroup()
    pulse:SetLooping("BOUNCE")
    local a = pulse:CreateAnimation("Alpha")
    a:SetFromAlpha(1)
    a:SetToAlpha(0.35)
    a:SetDuration(0.7)
    a:SetSmoothing("IN_OUT")
    pulse.anim = a
end

local function Paint(kind)
    local db = DB()
    local c = COLORS[kind]
    local size = (db and db.size) or 90
    local alpha = (db and db.intensity) or 0.6
    edges.top:SetHeight(size);   Gradient(edges.top, "VERTICAL", c[1], c[2], c[3], 0, alpha)
    edges.bottom:SetHeight(size); Gradient(edges.bottom, "VERTICAL", c[1], c[2], c[3], alpha, 0)
    edges.left:SetWidth(size);   Gradient(edges.left, "HORIZONTAL", c[1], c[2], c[3], alpha, 0)
    edges.right:SetWidth(size);  Gradient(edges.right, "HORIZONTAL", c[1], c[2], c[3], 0, alpha)
    -- Health breathes faster than mana.
    if pulse and pulse.anim then pulse.anim:SetDuration(kind == "health" and 0.55 or 1.0) end
end

-- ---------------------------------------------------------------------
-- State
-- ---------------------------------------------------------------------
-- Readable fraction, or nil when secret / unknown.
local function Fraction(cur, max)
    if Secret(cur) or Secret(max) or type(cur) ~= "number" or type(max) ~= "number" or max <= 0 then return nil end
    return cur / max
end

-- Curve: alpha 1 at or under the threshold, 0 above (engine side).
local function Curve(kind, pct)
    local key = kind .. ":" .. pct
    if curves[key] ~= nil then return curves[key] or nil end
    local ok, curve = pcall(function()
        local cv = C_CurveUtil.CreateColorCurve()
        local t = pct / 100
        cv:AddPoint(0, CreateColor(1, 1, 1, 1))
        cv:AddPoint(t, CreateColor(1, 1, 1, 1))
        cv:AddPoint(math.min(1, t + 0.001), CreateColor(1, 1, 1, 0))
        cv:AddPoint(1, CreateColor(1, 1, 1, 0))
        return cv
    end)
    curves[key] = ok and curve or false
    return ok and curve or nil
end

-- Returns: true (due), false (not due), or a colour from the curve when
-- the value is secret (the alpha then comes from the engine).
local function Due(kind)
    local db = DB()
    if kind == "health" then
        if db.health == false then return false end
        if db.healthInCombat and not inCombat then return false end
        local pct = db.healthPct or 30
        local cur, max = UnitHealth("player"), UnitHealthMax("player")
        local f = Fraction(cur, max)
        if f then return f > 0 and f * 100 <= pct end
        if UnitHealthPercent and C_CurveUtil and C_CurveUtil.CreateColorCurve then
            local curve = Curve(kind, pct)
            if curve then
                local ok, color = pcall(UnitHealthPercent, "player", false, curve)
                if ok and color then return color end
            end
        end
        return false
    else
        if db.mana == false then return false end
        if db.manaInCombat ~= false and not inCombat then return false end
        local ptype = UnitPowerType("player")
        if Secret(ptype) or ptype ~= 0 then return false end
        local pct = db.manaPct or 20
        local cur, max = UnitPower("player", 0), UnitPowerMax("player", 0)
        local f = Fraction(cur, max)
        if f then return f * 100 <= pct end
        if UnitPowerPercent and C_CurveUtil and C_CurveUtil.CreateColorCurve then
            local curve = Curve(kind, pct)
            if curve then
                local ok, color = pcall(UnitPowerPercent, "player", 0, false, curve)
                if ok and color then return color end
            end
        end
        return false
    end
end

local function Stop()
    if pulse and pulse:IsPlaying() then pulse:Stop() end
    if holder then holder:Hide() end
    current = nil
end

local function Show(kind, color)
    Create()
    if current ~= kind then
        Paint(kind)
        current = kind
    end
    if color and color.GetRGBA then
        -- Secret: the curve's alpha (1 or 0) goes straight to the engine.
        local _, _, _, a = color:GetRGBA()
        pcall(holder.SetAlpha, holder, a)
    else
        holder:SetAlpha(1)
    end
    holder:Show()
    local U = TomoMod_Utils
    local full = not (U and U.AnimFull) or U.AnimFull()
    if full then
        if not pulse:IsPlaying() then pulse:Play() end
    elseif pulse:IsPlaying() then
        pulse:Stop()
    end
end

function EA.Update()
    local db = DB()
    if not (db and db.enabled) or UnitIsDeadOrGhost("player") then Stop() return end
    for _, kind in ipairs({ "health", "mana" }) do
        local due = Due(kind)
        if due == true then Show(kind) return end
        if type(due) == "table" then Show(kind, due) return end
    end
    Stop()
end

-- ---------------------------------------------------------------------
-- Settings
-- ---------------------------------------------------------------------
local testUntil = 0

function EA.ApplySettings()
    curves = {}
    current = nil
    if testUntil > GetTime() then return end
    EA.Update()
end

function EA.SetEnabled(v)
    local db = DB()
    if not db then return end
    db.enabled = v and true or false
    EA.ApplySettings()
end

--- Shows one glow for 3 seconds (options page): "health" or "mana".
function EA.Test(kind)
    Create()
    current = nil
    testUntil = GetTime() + 3
    Show(kind or "health")
    C_Timer.After(3.05, function()
        if GetTime() >= testUntil then testUntil = 0; EA.Update() end
    end)
end

local ev = CreateFrame("Frame")
ev:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_DISABLED" then inCombat = true
    elseif event == "PLAYER_REGEN_ENABLED" then inCombat = false end
    if testUntil > GetTime() then return end
    EA.Update()
end)

function EA.Initialize()
    if not DB() then return end
    inCombat = InCombatLockdown() and true or false
    ev:RegisterUnitEvent("UNIT_HEALTH", "player")
    ev:RegisterUnitEvent("UNIT_MAXHEALTH", "player")
    ev:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
    ev:RegisterUnitEvent("UNIT_MAXPOWER", "player")
    ev:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player")
    ev:RegisterEvent("PLAYER_REGEN_DISABLED")
    ev:RegisterEvent("PLAYER_REGEN_ENABLED")
    ev:RegisterEvent("PLAYER_DEAD")
    ev:RegisterEvent("PLAYER_ALIVE")
    ev:RegisterEvent("PLAYER_UNGHOST")
    ev:RegisterEvent("PLAYER_ENTERING_WORLD")
    EA.Update()
end
