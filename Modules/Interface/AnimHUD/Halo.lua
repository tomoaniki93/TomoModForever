-- =====================================================================
-- AnimHUD / Halo.lua -- the halo around the character (from Braise)
--
--        health  (           )  power
--                 '  rings  '
--                    0:42
--
--   * two arcs: health on the left, power on the right. Each is a
--     vertical StatusBar wearing an arc texture, so the client crops the
--     arc itself and secret values never pass through Lua arithmetic.
--     The health arc glows red when health runs low (C-side curve).
--   * the target one ring further out, the pet one ring further in, the
--     target of target above the target's name.
--   * two rings turning in opposite directions; slow when idle, fast in
--     combat.
--   * idle: the halo dims to the chosen opacity and breathes. It wakes up
--     on its own when you target something or are missing health.
--   * combat start: arcs snap in, flash, rings pop. Combat end: everything
--     eases back. (Braise's recap card is not part of the TMF look.)
--   * click zones (secure) and move mode.
-- =====================================================================

local B = TomoMod_AnimHUD
local Halo = B.Module("Halo")
local T = B.T
local MEDIA = B.MEDIA

-- Geometry, in screen units. The arc textures are a slice of a circle of
-- radius 190 whose centre sits 195.5 from the texture's outer edge.
local ARC_W, ARC_H, ARC_CENTER = 64, 256, 195.5
local DASH_SIZE, TRI_SIZE = 272, 276

local TARGET_K = 1.17          -- the target arc is the same slice, one ring further out
local PET_K = 0.83             -- and the pet's one ring further in, so a little thinner

local INTERP = Enum and Enum.StatusBarInterpolation and Enum.StatusBarInterpolation.ExponentialEaseOut
local ScaleTo100 = CurveConstants and CurveConstants.ScaleTo100

local root, breath, rings, texts
local arcL, arcR, tgt, pet, tot
local hpText, pwText, timerText, ticker
local mover
local PlaceAll           -- re-applies every text and name position (defined below)

-- ---------------------------------------------------------------------
-- Low-health colour, evaluated client-side
-- ---------------------------------------------------------------------
local DR, DG, DB = 0.90, 0.08, 0.04
local dangerCurve

--- r, g, b, a of the low-health glow on the health arc. May be secret:
--- only ever pass the result straight to SetVertexColor.
local function DangerRGBA()
    if UnitHealthPercent and C_CurveUtil and C_CurveUtil.CreateColorCurve and CreateColor then
        if not dangerCurve then
            dangerCurve = C_CurveUtil.CreateColorCurve()
            dangerCurve:AddPoint(0.00, CreateColor(DR, DG, DB, 1))
            dangerCurve:AddPoint(0.18, CreateColor(DR, DG, DB, 0.9))
            -- Fades to black as well as to transparent: the glow is
            -- additive, so it vanishes even if alpha is ignored.
            dangerCurve:AddPoint(0.38, CreateColor(0, 0, 0, 0))
            dangerCurve:AddPoint(1.00, CreateColor(0, 0, 0, 0))
        end
        local ok, col = pcall(UnitHealthPercent, "player", true, dangerCurve)
        if ok and col and col.GetRGBA then return col:GetRGBA() end
    end
    local cur, mx = B.Num(UnitHealth("player")), B.Num(UnitHealthMax("player"))
    if cur and mx and mx > 0 then
        local p = cur / mx
        local a = p < 0.38 and math.min(1, (0.38 - p) / 0.2) or 0
        return DR * a, DG * a, DB * a, a
    end
    return 0, 0, 0, 0
end

-- ---------------------------------------------------------------------
-- Building blocks
-- ---------------------------------------------------------------------
local function MakeArc(side, parent, k, key, label)
    local a = {}
    k = k or 1
    local file = side < 0 and "ArcL" or "ArcR"
    a.side = side

    a.frame = CreateFrame("Frame", nil, parent)
    a.frame:SetSize(ARC_W * k, ARC_H * k)

    a.bg = a.frame:CreateTexture(nil, "BACKGROUND")
    a.bg:SetTexture(MEDIA .. file)
    a.bg:SetAllPoints()
    a.bg:SetVertexColor(0.5, 0.5, 0.5, 0.40) -- mid-grey track: reads on dark and bright scenes alike

    a.bar = CreateFrame("StatusBar", nil, a.frame)
    a.bar:SetAllPoints()
    a.bar:SetOrientation("VERTICAL")
    a.bar:SetStatusBarTexture(MEDIA .. file)
    a.bar:SetMinMaxValues(0, 1)
    a.bar:SetValue(1)

    -- Additive glows: one flashes on combat start, one carries the
    -- low-health warning (left arc only).
    a.flash = a.frame:CreateTexture(nil, "OVERLAY")
    a.flash:SetTexture(MEDIA .. (side < 0 and "ArcGlowL" or "ArcGlowR"))
    a.flash:SetAllPoints()
    a.flash:SetBlendMode("ADD")
    a.flash:SetAlpha(0)

    -- off: animation offset along the radius; the player's own nudge
    -- (move mode) is added on top.
    function a.SetOffset(off)
        a.off = off
        local ox, oy = B.Off(key)
        a.frame:ClearAllPoints()
        if side < 0 then
            a.frame:SetPoint("LEFT", parent, "CENTER", -ARC_CENTER * k - off + ox, oy)
        else
            a.frame:SetPoint("RIGHT", parent, "CENTER", ARC_CENTER * k + off + ox, oy)
        end
    end
    a.SetOffset(0)

    -- Handle: a strip over the outer edge of the arc, narrow enough not
    -- to cover the neighbouring arcs.
    B.Movable(key, label, function(h)
        local edge = side < 0 and "LEFT" or "RIGHT"
        h:SetSize(30, ARC_H * k)
        h:SetPoint(edge, a.frame, edge)
    end, function()
        a.SetOffset(a.off or 0)
        PlaceAll()
    end)
    return a
end

local function SetBar(bar, value)
    if INTERP then bar:SetValue(value, INTERP) else bar:SetValue(value) end
end

local function MakeRing(file, size, degrees)
    local r = {}
    r.tex = rings:CreateTexture(nil, "ARTWORK")
    r.tex:SetTexture(MEDIA .. file)
    r.tex:SetBlendMode("ADD")
    r.tex:SetSize(size, size)
    r.tex:SetPoint("CENTER")
    r.ag = r.tex:CreateAnimationGroup()
    r.ag:SetLooping("REPEAT")
    r.rot = r.ag:CreateAnimation("Rotation")
    r.rot:SetDegrees(degrees)
    r.rot:SetDuration(60)
    return r
end

local function Text(parent, size, bold)   -- shared with Signs.lua as B.Text
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(bold and B.FONT_BOLD or B.FONT, size, "")
    fs:SetShadowOffset(1, -1)
    fs:SetShadowColor(0, 0, 0, 0.9)
    fs:SetTextColor(0.95, 0.92, 0.86)
    return fs
end

B.Text = Text

-- ---------------------------------------------------------------------
-- Health and power
-- ---------------------------------------------------------------------
local HP_STOPS = {
    { 0.00, 1.00, 0.20, 0.16 },
    { 0.30, 1.00, 0.48, 0.18 },
    { 0.60, 0.96, 0.84, 0.36 },
    { 1.00, 0.50, 0.90, 0.52 },
}
local hpCurve

local function HealthColor(unit)
    unit = unit or "player"
    if UnitHealthPercent and C_CurveUtil and C_CurveUtil.CreateColorCurve and CreateColor then
        if not hpCurve then
            hpCurve = C_CurveUtil.CreateColorCurve()
            for _, s in ipairs(HP_STOPS) do hpCurve:AddPoint(s[1], CreateColor(s[2], s[3], s[4], 1)) end
        end
        local ok, col = pcall(UnitHealthPercent, unit, true, hpCurve)
        if ok and col and col.GetRGBA then return col:GetRGBA() end
    end
    local cur, mx = B.Num(UnitHealth(unit)), B.Num(UnitHealthMax(unit))
    if cur and mx and mx > 0 then
        local p = math.max(0, math.min(1, cur / mx))
        for i = 2, #HP_STOPS do
            local a, b = HP_STOPS[i - 1], HP_STOPS[i]
            if p <= b[1] then
                local k = (p - a[1]) / (b[1] - a[1])
                return B.Lerp(a[2], b[2], k), B.Lerp(a[3], b[3], k), B.Lerp(a[4], b[4], k), 1
            end
        end
    end
    local s = HP_STOPS[#HP_STOPS]
    return s[2], s[3], s[4], 1
end

local function WriteHealthPct()
    hpText:SetFormattedText("%d%%", UnitHealthPercent("player", true, ScaleTo100))
end

local function WritePowerPct(pt)
    pwText:SetFormattedText("%d%%", UnitPowerPercent("player", pt, false, ScaleTo100))
end

local function UpdateHealth()
    if not arcL then return end
    local cur, mx = UnitHealth("player"), UnitHealthMax("player")
    arcL.bar:SetMinMaxValues(0, mx)
    SetBar(arcL.bar, cur)
    arcL.bar:SetStatusBarColor(HealthColor())
    arcL.danger:SetVertexColor(DangerRGBA())

    if B.db.texts then
        if UnitHealthPercent then
            -- The percentage may be secret: it goes straight to the widget.
            if not pcall(WriteHealthPct) then hpText:SetText("") end
        else
            local c, m = B.Num(cur), B.Num(mx)
            if c and m and m > 0 then hpText:SetFormattedText("%d%%", c / m * 100) else hpText:SetText("") end
        end
    end
end

local function PowerRGB(pt, token)
    local c = PowerBarColor and (PowerBarColor[token] or PowerBarColor[pt])
    -- Blizzard's mana blue is too dark for a thin arc.
    if pt == 0 or not (c and c.r) then return 0.30, 0.62, 1.00 end
    return c.r, c.g, c.b
end

local function UpdatePower()
    if not arcR then return end
    local pt, token = UnitPowerType("player")
    local cur, mx = UnitPower("player", pt), UnitPowerMax("player", pt)
    arcR.bar:SetMinMaxValues(0, mx)
    SetBar(arcR.bar, cur)

    arcR.bar:SetStatusBarColor(PowerRGB(pt, token))

    if B.db.texts then
        -- Mana reads better as a percentage; everything else as a value.
        if not (pt == 0 and UnitPowerPercent and pcall(WritePowerPct, pt)) then
            pwText:SetFormattedText("%d", cur)
        end
    end
end

-- ---------------------------------------------------------------------
-- Target arc
-- ---------------------------------------------------------------------
local function WriteTargetPct()
    tgt.pct:SetFormattedText("%d%%", UnitHealthPercent("target", true, ScaleTo100))
end

local function WriteTargetPowerPct(pt)
    tgt.pwText:SetFormattedText("%d%%", UnitPowerPercent("target", pt, false, ScaleTo100))
end

local function UpdateTargetPower(instant)
    if not tgt or not tgt.on then return end
    local pt, token = UnitPowerType("target")
    local cur, mx = UnitPower("target", pt), UnitPowerMax("target", pt)
    -- Many creatures have no resource at all: no arc for them.
    local known = B.Num(mx)
    local has = Halo.preview or not (known and known <= 0)
    tgt.pw.frame:SetShown(has)
    tgt.pwText:SetShown(has)
    if not has then return end
    tgt.pw.bar:SetMinMaxValues(0, mx)
    if instant then tgt.pw.bar:SetValue(cur) else SetBar(tgt.pw.bar, cur) end
    tgt.pw.bar:SetStatusBarColor(PowerRGB(pt, token))
    if not (pt == 0 and UnitPowerPercent and pcall(WriteTargetPowerPct, pt)) then
        tgt.pwText:SetFormattedText("%d", cur)
    end
end

local function TargetColor(unit)
    unit = unit or "target"
    if B.Flag(UnitIsDead(unit)) then return 0.55, 0.55, 0.55 end
    if B.Flag(UnitIsPlayer(unit)) then
        local _, class = UnitClass(unit)
        local c = class and not B.Secret(class) and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
        if c then return c.r, c.g, c.b end
    end
    if B.Flag(UnitIsTapDenied(unit)) then return 0.60, 0.60, 0.60 end
    local reaction = B.Num(UnitReaction(unit, "player"))
    if reaction then
        if reaction <= 3 then return 0.95, 0.28, 0.22 end
        if reaction == 4 then return 0.96, 0.82, 0.28 end
        return 0.40, 0.88, 0.48
    end
    if B.Flag(UnitCanAttack("player", unit)) then return 0.95, 0.28, 0.22 end
    return 0.40, 0.88, 0.48
end

-- ---------------------------------------------------------------------
-- Target of target
-- ---------------------------------------------------------------------
-- A name and a hairline health bar above the target's name. When the
-- target turns on you it says so, in the combat colour, with a pop.
local TOT_Y = 221

local function WriteToTName()
    tot.name:SetFormattedText("> %s", UnitName("targettarget"))
end

local function UpdateToT()
    if not tot or not tot.on then return end
    if not B.Flag(UnitExists("targettarget")) then        -- move mode, nothing to show
        tot.name:SetText("> " .. T("cible de la cible", "target of target"))
        tot.name:SetTextColor(0.80, 0.77, 0.72)
        return
    end
    local cur, mx = UnitHealth("targettarget"), UnitHealthMax("targettarget")
    tot.bar:SetMinMaxValues(0, mx)
    tot.bar:SetValue(cur)

    local me = B.Flag(UnitIsUnit("targettarget", "player"))
    local r, g, b
    if me then
        r, g, b = B.Color(true)
        tot.name:SetText("> " .. T("TOI", "YOU"))
    else
        r, g, b = TargetColor("targettarget")
        if not pcall(WriteToTName) then tot.name:SetText("") end
    end
    tot.name:SetTextColor(r, g, b)
    tot.bar:SetStatusBarColor(r, g, b)

    if me and not tot.me then
        B.Tween("tot.pop", 0.45, 1.5, 1, tot.Place, B.Ease.outBack)
    end
    tot.me = me
end

--- Called when the target, or the target's target, changes.
local function ToTChanged()
    if not tot then return end
    local want = B.db.tot and (B.Flag(UnitExists("targettarget")) or Halo.preview)
    if want then
        if not tot.on then
            tot.on = true
            tot.me = nil
            B.Fade(tot, 1, 0.25)
        end
        UpdateToT()
    elseif tot.on then
        tot.on = false
        B.Fade(tot, 0, 0.25)
    end
end

local function BuildToT()
    tot = CreateFrame("Frame", nil, root)
    tot:SetSize(120, 20)
    tot:SetAlpha(0)
    tot:Hide()
    -- Scaling a frame scales its anchor offsets too: divide them back.
    function tot.Place(s)
        tot.s = s
        local ox, oy = B.Off("names")
        tot:SetScale(s)
        tot:ClearAllPoints()
        tot:SetPoint("CENTER", root, "CENTER", ox / s, (TOT_Y + oy) / s)
    end
    tot.Place(1)

    tot.name = Text(tot, 10, true)
    tot.name:SetPoint("TOP")
    tot.name:SetWidth(200)
    tot.name:SetWordWrap(false)

    local track = tot:CreateTexture(nil, "BACKGROUND")
    track:SetTexture(B.WHITE)
    track:SetVertexColor(0.5, 0.5, 0.5, 0.40)
    track:SetSize(90, 3)
    track:SetPoint("BOTTOM")
    tot.bar = CreateFrame("StatusBar", nil, tot)
    tot.bar:SetStatusBarTexture(B.WHITE)
    tot.bar:SetAllPoints(track)
    tot.bar:SetMinMaxValues(0, 1)
    tot.bar:SetValue(1)

    -- No event reports the health of "targettarget": poll while shown.
    tot:SetScript("OnUpdate", function(self, dt)
        self.acc = (self.acc or 0) + dt
        if self.acc < 0.2 then return end
        self.acc = 0
        if tot.on then ToTChanged() end
    end)
end

local function UpdateTarget(instant)
    if not tgt or not tgt.on then return end
    local cur, mx = UnitHealth("target"), UnitHealthMax("target")
    tgt.hp.bar:SetMinMaxValues(0, mx)
    -- A new target must not ease in from the previous target's health.
    if instant then tgt.hp.bar:SetValue(cur) else SetBar(tgt.hp.bar, cur) end
    local r, g, b = TargetColor()
    tgt.hp.bar:SetStatusBarColor(r, g, b)
    tgt.name:SetTextColor(r, g, b)

    if UnitHealthPercent then
        if not pcall(WriteTargetPct) then tgt.pct:SetText("") end
    else
        local c, m = B.Num(cur), B.Num(mx)
        if c and m and m > 0 then tgt.pct:SetFormattedText("%d%%", c / m * 100) else tgt.pct:SetText("") end
    end
end

--- Called when the target changes or the option is toggled.
local function TargetChanged(flash)
    if not tgt then return end
    local want = B.db.target and (B.Flag(UnitExists("target")) or Halo.preview)
    if want then
        if B.Flag(UnitExists("target")) then
            tgt.name:SetText(UnitName("target") or "")
        else
            tgt.name:SetText(T("Cible", "Target"))          -- move mode, no target
        end
        local r, g, b = TargetColor()
        tgt.hp.flash:SetVertexColor(r, g, b)
        tgt.pw.flash:SetVertexColor(r, g, b)
        if not tgt.on then
            -- Acquired: both arcs slide in from outside.
            tgt.on = true
            B.Fade(tgt, 1, 0.3)
            B.Tween("tgt.in", 0.45, 34, 0, tgt.SetOffset, B.Ease.outBack)
        end
        UpdateTarget(true)
        UpdateTargetPower(true)
        if flash then
            B.Tween("tgt.flash", 0.7, 0.9, 0, function(a)
                tgt.hp.flash:SetAlpha(a)
                tgt.pw.flash:SetAlpha(a)
            end)
        end
    elseif tgt.on then
        tgt.on = false
        B.Fade(tgt, 0, 0.3)
        B.Tween("tgt.in", 0.3, 0, 22, tgt.SetOffset, B.Ease.inCubic)
    end
end

local function BuildTarget()
    tgt = CreateFrame("Frame", nil, root)
    tgt:SetSize(2, 2)
    tgt:SetPoint("CENTER")
    tgt:SetAlpha(0)
    tgt:Hide()
    -- Same sides as the player's arcs: health left, power right.
    tgt.hp = MakeArc(-1, tgt, TARGET_K, "thp", T("Vie de la cible", "Target health"))
    tgt.pw = MakeArc(1, tgt, TARGET_K, "tpw", T("Ressource de la cible", "Target power"))
    function tgt.SetOffset(off)
        tgt.hp.SetOffset(off)
        tgt.pw.SetOffset(off)
    end

    -- Name centred above the halo; values at the upper ends of the arcs,
    -- mirroring the player's values at the lower ends.
    tgt.name = Text(tgt, 12, true)
    tgt.name:SetPoint("BOTTOM", tgt, "CENTER", 0, 194)             -- above the threat gauge
    tgt.name:SetWidth(240)
    tgt.name:SetJustifyH("CENTER")
    tgt.name:SetWordWrap(false)
    B.Movable("names", T("Nom de la cible et cible de la cible", "Target name and target of target"), function(h)
        h:SetSize(200, 42)
        h:SetPoint("BOTTOM", tgt.name, "BOTTOM", 0, -2)
    end, function() PlaceAll() end)
    tgt.pct = Text(tgt, 11, true)
    tgt.pct:SetPoint("CENTER", tgt, "CENTER", -180, 166)
    tgt.pct:SetTextColor(0.80, 0.77, 0.72)
    tgt.pwText = Text(tgt, 11, true)
    tgt.pwText:SetPoint("CENTER", tgt, "CENTER", 180, 166)
    tgt.pwText:SetTextColor(0.80, 0.77, 0.72)
end

-- ---------------------------------------------------------------------
-- Pet arcs
-- ---------------------------------------------------------------------
local function UpdatePet(instant)
    if not pet or not pet.on then return end
    local cur, mx = UnitHealth("pet"), UnitHealthMax("pet")
    pet.hp.bar:SetMinMaxValues(0, mx)
    if instant then pet.hp.bar:SetValue(cur) else SetBar(pet.hp.bar, cur) end
    if B.Flag(UnitIsDead("pet")) then
        pet.hp.bar:SetStatusBarColor(0.55, 0.55, 0.55)
    else
        pet.hp.bar:SetStatusBarColor(HealthColor("pet"))
    end

    local pt, token = UnitPowerType("pet")
    local pcur, pmax = UnitPower("pet", pt), UnitPowerMax("pet", pt)
    pet.pw.bar:SetMinMaxValues(0, pmax)
    if instant then pet.pw.bar:SetValue(pcur) else SetBar(pet.pw.bar, pcur) end
    pet.pw.bar:SetStatusBarColor(PowerRGB(pt, token))
end

--- Called when the pet appears, changes or leaves, or the option is toggled.
local function PetChanged()
    if not pet then return end
    local want = B.db.pet and (B.Flag(UnitExists("pet")) or Halo.preview)
    if want then
        if not pet.on then
            -- Summoned: the arcs open outward from the centre.
            pet.on = true
            B.Fade(pet, 1, 0.3)
            B.Tween("pet.in", 0.45, -26, 0, pet.SetOffset, B.Ease.outBack)
        end
        UpdatePet(true)
    elseif pet.on then
        pet.on = false
        B.Fade(pet, 0, 0.3)
        B.Tween("pet.in", 0.3, 0, -18, pet.SetOffset, B.Ease.inCubic)
    end
end

local function BuildPet()
    pet = CreateFrame("Frame", nil, root)
    pet:SetSize(2, 2)
    pet:SetPoint("CENTER")
    pet:SetAlpha(0)
    pet:Hide()
    pet.hp = MakeArc(-1, pet, PET_K, "php", T("Vie du familier", "Pet health"))
    pet.pw = MakeArc(1, pet, PET_K, "ppw", T("Ressource du familier", "Pet power"))
    function pet.SetOffset(off)
        pet.hp.SetOffset(off)
        pet.pw.SetOffset(off)
    end
end

-- ---------------------------------------------------------------------
-- State
-- ---------------------------------------------------------------------
local function StateAlpha()
    local db = B.db
    if mover and mover:IsShown() then return 1 end
    if B.Flag(UnitIsDeadOrGhost("player")) then return 0.15 end
    if B.inCombat then return 1 end
    local idle = db.oocAlpha or 0.35
    if B.Flag(UnitExists("target")) then return math.max(idle, 0.8) end
    local cur, mx = B.Num(UnitHealth("player")), B.Num(UnitHealthMax("player"))
    if cur and mx and cur < mx then return math.max(idle, 0.6) end
    return idle
end

local function ApplyRings(instant)
    local r, g, b = B.StateColor()
    local hot = B.inCombat
    rings.dash.tex:SetVertexColor(r, g, b)
    rings.tri.tex:SetVertexColor(r, g, b)
    rings.dash.rot:SetDuration(hot and 16 or 80)
    rings.tri.rot:SetDuration(hot and 9 or 46)
    if B.db.ring then
        rings:Show()
        if not rings.dash.ag:IsPlaying() then rings.dash.ag:Play() end
        if not rings.tri.ag:IsPlaying() then rings.tri.ag:Play() end
        B.Fade(rings, hot and 0.6 or 0.22, instant and 0 or 0.6)
    else
        rings.dash.ag:Stop()
        rings.tri.ag:Stop()
        rings:Hide()
    end
end

local function ApplyState(dur)
    local db = B.db
    local dead = B.Flag(UnitIsDeadOrGhost("player"))

    arcL.frame:Show()
    arcR.frame:Show()
    texts:SetShown(db.texts)
    arcL.bar:GetStatusBarTexture():SetDesaturated(dead)
    arcR.bar:GetStatusBarTexture():SetDesaturated(dead)

    B.Fade(root, StateAlpha(), dur or 0.5, B.Ease.inOut)

    -- Breathe only when truly idle.
    if B.inCombat or dead then
        breath.ag:Stop()
    elseif not breath.ag:IsPlaying() then
        breath.ag:Play()
    end
end

-- ---------------------------------------------------------------------
-- Combat timer
-- ---------------------------------------------------------------------
local function FormatTime(sec)
    sec = math.max(0, math.floor(sec + 0.5))
    return string.format("%d:%02d", math.floor(sec / 60), sec % 60)
end

local function StartTimer()
    if not B.db.timer then return end
    timerText:SetText("0:00")
    timerText:SetTextColor(B.Color(true))
    B.Fade(timerText, 1, 0.3)
    ticker.acc = 0
    ticker:Show()
end

local function StopTimer(duration)
    ticker:Hide()
    if timerText:IsShown() then
        timerText:SetText(FormatTime(duration))
        B.Fade(timerText, 0, 1.6, B.Ease.inCubic)
    end
end

-- ---------------------------------------------------------------------
-- Click zones
-- ---------------------------------------------------------------------
-- The arcs behave like unit frames: left-click targets the unit,
-- right-click opens its menu, hovering shows its tooltip. Each arc is
-- covered by a chain of small secure buttons that follow its curve, so the
-- zones stay as thin as the arcs and the world remains clickable between
-- them. Secure frames cannot be shown or hidden in combat: the target's
-- zones are driven by the client (RegisterUnitWatch), and option changes
-- made during a fight are applied when it ends.
local CLICK_SEGMENTS, CLICK_PAD = 6, 5
local clicks = { player = {}, target = {}, pet = {}, targettarget = {} }

local function MakeClick(unit, level, key)
    local btn = CreateFrame("Button", nil, B.anchor, "SecureUnitButtonTemplate")
    btn.key = key                       -- the element this zone follows in move mode
    btn:SetAttribute("unit", unit)
    btn:SetAttribute("*type1", "target")
    btn:SetAttribute("*type2", "togglemenu")
    btn:RegisterForClicks("AnyUp")
    btn:SetFrameLevel(B.anchor:GetFrameLevel() + level)
    btn:SetScript("OnEnter", function()
        if GameTooltip_SetDefaultAnchor then
            GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
            GameTooltip:SetUnit(unit)
            GameTooltip:Show()
        end
    end)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    table.insert(clicks[unit], btn)
    return btn
end

--- Cover one side arc of the given radius with buttons.
--- Remember a zone's default place; LayoutClicks adds the element's nudge.
local function Pin(btn, point, x, y)
    btn.pt, btn.bx, btn.by = point, x, y
    btn:SetPoint(point, B.anchor, "CENTER", x, y)
end

local function LayoutClicks()
    for _, list in pairs(clicks) do
        if type(list) == "table" then
            for _, btn in ipairs(list) do
                local ox, oy = B.Off(btn.key)
                btn:ClearAllPoints()
                btn:SetPoint(btn.pt, B.anchor, "CENTER", btn.bx + ox, btn.by + oy)
            end
        end
    end
end

local function ClickArc(unit, side, radius, level, key)
    local half = math.deg(math.asin((ARC_H / 2 - 6) / 190))     -- half-angle of the slice
    local step = half * 2 / CLICK_SEGMENTS
    for i = 1, CLICK_SEGMENTS do
        local a0 = math.rad(-half + (i - 1) * step)
        local a1 = math.rad(-half + i * step)
        local x0, x1 = radius * math.cos(a0), radius * math.cos(a1)
        local y0, y1 = radius * math.sin(a0), radius * math.sin(a1)
        local xmin, xmax = math.min(x0, x1) - CLICK_PAD, math.max(x0, x1, i == CLICK_SEGMENTS / 2 and radius or 0) + CLICK_PAD
        local btn = MakeClick(unit, level, key)
        btn:SetSize(xmax - xmin, math.abs(y1 - y0))
        if side < 0 then
            Pin(btn, "BOTTOMRIGHT", -xmin, math.min(y0, y1))
        else
            Pin(btn, "BOTTOMLEFT", xmin, math.min(y0, y1))
        end
    end
end

local function BuildClicks()
    if clicks.built then return end
    clicks.built = true
    ClickArc("player", -1, 190, 2, "hp")
    ClickArc("player", 1, 190, 2, "pw")
    -- The target's zones sit above the player's where the two overlap.
    ClickArc("target", -1, 190 * TARGET_K, 4, "thp")
    ClickArc("target", 1, 190 * TARGET_K, 4, "tpw")
    ClickArc("pet", -1, 190 * PET_K, 3, "php")
    ClickArc("pet", 1, 190 * PET_K, 3, "ppw")
    local name = MakeClick("target", 4, "names")
    name:SetSize(200, 18)
    Pin(name, "BOTTOM", 0, 192)
    local totName = MakeClick("targettarget", 4, "names")
    totName:SetSize(140, 20)
    Pin(totName, "CENTER", 0, TOT_Y)
end

function Halo:ApplyClicks()
    if not clicks.built or InCombatLockdown() then return end
    local db = B.db
    LayoutClicks()
    local on = B.active and db.click and not (mover and mover:IsShown())
    for _, btn in ipairs(clicks.player) do
        btn:SetShown(on and true or false)
    end
    for unit, key in pairs({ target = "target", pet = "pet", targettarget = "tot" }) do
        for _, btn in ipairs(clicks[unit]) do
            if on and db[key] then
                RegisterUnitWatch(btn)      -- shown only while the unit exists
            else
                UnregisterUnitWatch(btn)
                btn:Hide()
            end
        end
    end
end

-- ---------------------------------------------------------------------
-- Mover
-- ---------------------------------------------------------------------
--- Texts and names follow the element they belong to.
function PlaceAll()
    local x, y
    if hpText then
        x, y = B.Off("hp")
        hpText:ClearAllPoints(); hpText:SetPoint("CENTER", texts, "CENTER", -122 + x, -138 + y)
        x, y = B.Off("pw")
        pwText:ClearAllPoints(); pwText:SetPoint("CENTER", texts, "CENTER", 122 + x, -138 + y)
    end
    if tgt then
        x, y = B.Off("thp")
        tgt.pct:ClearAllPoints(); tgt.pct:SetPoint("CENTER", tgt, "CENTER", -180 + x, 166 + y)
        x, y = B.Off("tpw")
        tgt.pwText:ClearAllPoints(); tgt.pwText:SetPoint("CENTER", tgt, "CENTER", 180 + x, 166 + y)
        x, y = B.Off("names")
        tgt.name:ClearAllPoints(); tgt.name:SetPoint("BOTTOM", tgt, "CENTER", x, 194 + y)
    end
    if tot then tot.Place(tot.s or 1) end
end

local HINT_FR = "Glisse une poignée pour déplacer un élément - clic droit : le remettre en place"
local HINT_EN = "Drag a handle to move one element - right-click: put it back"

local function Frame4(f, r, g, b, a)
    for _, p in ipairs({ { "TOPLEFT", "TOPRIGHT", false }, { "BOTTOMLEFT", "BOTTOMRIGHT", false },
                         { "TOPLEFT", "BOTTOMLEFT", true }, { "TOPRIGHT", "BOTTOMRIGHT", true } }) do
        local e = f:CreateTexture(nil, "BORDER")
        e:SetColorTexture(r, g, b, a)
        e:SetPoint(p[1]); e:SetPoint(p[2])
        if p[3] then e:SetWidth(1) else e:SetHeight(1) end
    end
end

--- One drag handle per movable element.
local function MakeHandle(m)
    local h = CreateFrame("Frame", nil, mover)
    h:EnableMouse(true)
    h.bg = h:CreateTexture(nil, "BACKGROUND")
    h.bg:SetAllPoints()
    h.bg:SetColorTexture(0.79, 0.64, 0.32, 0.22)
    Frame4(h, 0.79, 0.64, 0.32, 0.8)
    m.place(h)                  -- anchored to the element: it follows it around

    local function Stop()
        h:SetScript("OnUpdate", nil)
    end
    h:SetScript("OnMouseDown", function(_, button)
        if button ~= "LeftButton" then return end
        local cx, cy = GetCursorPosition()
        local ox, oy = B.Off(m.key)
        h:SetScript("OnUpdate", function()
            local x, y = GetCursorPosition()
            local s = B.anchor:GetEffectiveScale()
            B.db.offsets[m.key] = { x = math.floor(ox + (x - cx) / s + 0.5), y = math.floor(oy + (y - cy) / s + 0.5) }
            m.apply()
        end)
    end)
    h:SetScript("OnMouseUp", function(_, button)
        Stop()
        if button == "RightButton" then
            B.db.offsets[m.key] = nil
            m.apply()
        end
    end)
    h:SetScript("OnHide", Stop)
    h:SetScript("OnEnter", function()
        h.bg:SetColorTexture(0.79, 0.64, 0.32, 0.5)
        mover.info:SetText(m.label)
    end)
    h:SetScript("OnLeave", function()
        h.bg:SetColorTexture(0.79, 0.64, 0.32, 0.22)
        mover.info:SetText(T(HINT_FR, HINT_EN))
    end)
    return h
end

local function BuildMover()
    -- The layer that holds every handle.
    mover = CreateFrame("Frame", nil, B.anchor)
    mover:SetSize(2, 2)
    mover:SetPoint("CENTER")
    mover:SetFrameStrata("DIALOG")
    mover:Hide()

    mover.info = Text(mover, 11, true)
    mover.info:SetPoint("CENTER", mover, "CENTER", 0, 268)
    mover.info:SetText(T(HINT_FR, HINT_EN))

    -- Centre handle: moves the whole HUD.
    local all = CreateFrame("Frame", nil, mover)
    all:SetSize(150, 44)
    all:SetPoint("CENTER")
    all:EnableMouse(true)
    all:RegisterForDrag("LeftButton")
    local bg = all:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.79, 0.64, 0.32, 0.22)
    Frame4(all, 0.79, 0.64, 0.32, 0.8)
    local label = Text(all, 11, true)
    label:SetPoint("CENTER")
    label:SetText(T("Tout le HUD", "Whole HUD"))

    all:SetScript("OnDragStart", function()
        if InCombatLockdown() then return end
        B.anchor:SetMovable(true)
        B.anchor:StartMoving()
    end)
    all:SetScript("OnDragStop", function()
        B.anchor:StopMovingOrSizing()
        local ax, ay = B.anchor:GetCenter()
        local ux, uy = UIParent:GetCenter()
        if ax and ux then
            local sa, su = B.anchor:GetEffectiveScale(), UIParent:GetEffectiveScale()
            B.db.x = math.floor((ax * sa - ux * su) / su + 0.5)
            B.db.y = math.floor((ay * sa - uy * su) / su + 0.5)
        end
        B.ApplyAnchor()
        B.Call("Refresh")
    end)
    all:SetScript("OnMouseUp", function(_, button)
        if button == "RightButton" then Halo:ToggleMover() end
    end)
    all:SetScript("OnEnter", function()
        mover.info:SetText(T("Tout le HUD - clic droit : verrouiller", "Whole HUD - right-click: lock"))
    end)
    all:SetScript("OnLeave", function() mover.info:SetText(T(HINT_FR, HINT_EN)) end)

    for _, m in ipairs(B.movables) do MakeHandle(m) end
end

--- Leave move mode (also called when a fight starts).
local function CloseMover()
    if not mover or not mover:IsShown() then return end
    mover:Hide()
    Halo.preview = false
    B.Signs:SetPreview(false)
    TargetChanged()             -- drop the placeholders
    PetChanged()
    ToTChanged()
end

function Halo:ToggleMover()
    if InCombatLockdown() then
        print("|cffffd100TomoModForever|r " .. T("le HUD ne peut pas être déplacé en combat.", "the HUD cannot be moved in combat."))
        return
    end
    if not mover then BuildMover() end
    if mover:IsShown() then
        CloseMover()
    else
        mover:Show()
        -- Show every element, even those with nothing to display right now.
        Halo.preview = true
        B.Signs:SetPreview(true)
    end
    B.Call("Refresh")           -- also re-places the click zones
end

-- ---------------------------------------------------------------------
-- Module hooks
-- ---------------------------------------------------------------------
function Halo:Init()
    root = CreateFrame("Frame", nil, B.anchor)
    root:SetSize(2, 2)
    root:SetPoint("CENTER")
    root:SetAlpha(0)
    Halo.root = root

    breath = CreateFrame("Frame", nil, root)
    breath:SetSize(2, 2)
    breath:SetPoint("CENTER")
    breath.ag = breath:CreateAnimationGroup()
    breath.ag:SetLooping("BOUNCE")
    local al = breath.ag:CreateAnimation("Alpha")
    al:SetFromAlpha(1); al:SetToAlpha(0.55); al:SetDuration(2.8); al:SetSmoothing("IN_OUT")

    arcL = MakeArc(-1, breath, 1, "hp", T("Ta vie", "Your health"))
    arcR = MakeArc(1, breath, 1, "pw", T("Ta ressource", "Your power"))
    BuildTarget()
    BuildPet()
    BuildToT()
    arcL.danger = arcL.frame:CreateTexture(nil, "OVERLAY")
    arcL.danger:SetTexture(MEDIA .. "ArcGlowL")
    arcL.danger:SetAllPoints()
    arcL.danger:SetBlendMode("ADD")
    arcL.danger:SetVertexColor(1, 0, 0, 0)

    rings = CreateFrame("Frame", nil, root)
    rings:SetSize(2, 2)
    rings:SetPoint("CENTER")
    rings:SetAlpha(0)
    rings.dash = MakeRing("RingDash", DASH_SIZE, -360)
    rings.tri  = MakeRing("RingTri", TRI_SIZE, 360)

    texts = CreateFrame("Frame", nil, root)
    texts:SetSize(2, 2)
    texts:SetPoint("CENTER")
    hpText = Text(texts, 12, true)
    -- Inside the halo, clear of the target arcs' lower ends.
    hpText:SetPoint("CENTER", texts, "CENTER", -122, -138)
    pwText = Text(texts, 12, true)
    pwText:SetPoint("CENTER", texts, "CENTER", 122, -138)

    timerText = Text(root, 11, true)
    timerText:SetPoint("CENTER", root, "CENTER", 0, -195)       -- between the two cast arcs
    timerText:SetAlpha(0)
    timerText:Hide()

    ticker = CreateFrame("Frame")
    ticker:Hide()
    ticker:SetScript("OnUpdate", function(self, dt)
        self.acc = (self.acc or 0) + dt
        if self.acc < 0.2 then return end
        self.acc = 0
        timerText:SetText(FormatTime(GetTime() - (B.combatT0 or GetTime())))
    end)

    PlaceAll()
    BuildClicks()
    Halo:ApplyClicks()

    local ev = CreateFrame("Frame")
    ev:RegisterUnitEvent("UNIT_HEALTH", "player", "target")
    ev:RegisterUnitEvent("UNIT_MAXHEALTH", "player", "target")
    ev:RegisterUnitEvent("UNIT_FACTION", "target")
    ev:RegisterEvent("PLAYER_TARGET_CHANGED")
    ev:RegisterUnitEvent("UNIT_TARGET", "target")
    ev:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
    ev:RegisterUnitEvent("UNIT_POWER_UPDATE", "target")
    ev:RegisterUnitEvent("UNIT_MAXPOWER", "player", "target")
    ev:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player", "target")
    -- RegisterUnitEvent takes two units at most: the pet gets its own frame.
    local pev = CreateFrame("Frame")
    for _, e in ipairs({ "UNIT_HEALTH", "UNIT_MAXHEALTH", "UNIT_POWER_UPDATE", "UNIT_MAXPOWER", "UNIT_DISPLAYPOWER" }) do
        pev:RegisterUnitEvent(e, "pet")
    end
    pev:RegisterUnitEvent("UNIT_PET", "player")
    pev:SetScript("OnEvent", function(_, event)
        if not B.active then return end
        if event == "UNIT_PET" then PetChanged() else UpdatePet() end
    end)

    ev:SetScript("OnEvent", function(_, event, unit)
        if not B.active then return end
        if event == "UNIT_TARGET" then
            ToTChanged()
        elseif event == "PLAYER_TARGET_CHANGED" then
            TargetChanged(true)
            ToTChanged()
        elseif unit == "target" then
            if event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" or event == "UNIT_FACTION" then
                UpdateTarget()
            else
                UpdateTargetPower()
            end
        elseif event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then
            UpdateHealth()
            -- Missing health wakes the halo up; only worth checking when idle.
            if not B.inCombat then
                local want = StateAlpha()
                if math.abs(want - (root.want or -1)) > 0.01 then
                    root.want = want
                    B.Fade(root, want, 0.5, B.Ease.inOut)
                end
            end
        else
            UpdatePower()
        end
    end)
end

function Halo:Refresh()
    if not root then return end
    Halo:ApplyClicks()
    UpdateHealth()
    UpdatePower()
    TargetChanged()
    UpdateTarget()
    UpdateTargetPower()
    PetChanged()
    ToTChanged()
    ApplyRings()
    ApplyState()
    root.want = StateAlpha()
    if B.inCombat and not ticker:IsShown() then StartTimer() end
    if not B.db.timer then
        ticker:Hide()
        timerText:Hide()
    end
end

--- The look was switched off (out of combat): drop the click zones,
--- leave move mode, stop the loops. The anchor is hidden by Core.
function Halo:Disable()
    if not root then return end
    CloseMover()
    if not InCombatLockdown() then
        for _, list in pairs(clicks) do
            if type(list) == "table" then
                for _, btn in ipairs(list) do
                    UnregisterUnitWatch(btn)
                    btn:Hide()
                end
            end
        end
    end
    ticker:Hide()
    timerText:Hide()
    breath.ag:Stop()
    rings.dash.ag:Stop()
    rings.tri.ag:Stop()
end

function Halo:IsMoving()
    return mover ~= nil and mover:IsShown()
end

function Halo:CombatStart()
    if not root then return end
    CloseMover()
    ApplyState(0.25)
    ApplyRings()
    StartTimer()

    if B.db.transitions then
        local r, g, b = B.Color(true)
        -- Arcs snap in from outside and flash.
        B.Tween("arcs.in", 0.5, 46, 0, function(off)
            arcL.SetOffset(off)
            arcR.SetOffset(off)
        end, B.Ease.outBack)
        arcL.flash:SetVertexColor(r, g, b)
        arcR.flash:SetVertexColor(r, g, b)
        B.Tween("arcs.flash", 0.9, 1, 0, function(a)
            arcL.flash:SetAlpha(a)
            arcR.flash:SetAlpha(a)
        end, B.Ease.outCubic)
        if B.db.ring then
            B.Tween("rings.pop", 0.6, 1.3, 1, function(s) rings:SetScale(s) end, B.Ease.outBack)
        end
    end
end

function Halo:CombatEnd(duration)
    if not root then return end
    StopTimer(duration)
    ApplyRings()
    ApplyState(1.4)
    root.want = StateAlpha()
    if B.db.transitions then
        -- A small exhale: the arcs drift out and settle back.
        B.Tween("arcs.in", 1.2, 0, 1, function(p)
            local off = math.sin(p * math.pi) * 12
            arcL.SetOffset(off)
            arcR.SetOffset(off)
        end, B.Ease.inOut)
    end
end
