-- =====================================================================
-- AnimHUD / Fx.lua -- the centre animation (from Braise)
--
--   * embers   a pool of particles rising around the character: few,
--              slow and in the idle colour out of combat; many, fast and
--              hot in combat. Can move the way the class does.
--   * pulses   shockwave + two blades on combat start, a contracting
--              wave on combat end.
--
-- Braise's screen-edge heat, low-health vignette and level-up fanfare are
-- not part of the TMF look.
-- Every looping effect is an AnimationGroup (runs client-side, no Lua per
-- frame); one-shot eases go through B.Tween.
-- =====================================================================

local B = TomoMod_AnimHUD
local Fx = B.Module("Fx")

local random, floor = math.random, math.floor
local MEDIA = B.MEDIA

-- ---------------------------------------------------------------------
-- Embers
-- ---------------------------------------------------------------------
local POOL = 24
local holder
local embers = {}

local PLAIN = { speed = 1, drift = 1, rise = 1, size = 1 }
local classFx

local function Launch(e, burst)
    local hot = burst or B.inCombat
    local fx = B.db.classEmbers and classFx or PLAIN     -- motion only; colours follow the theme
    local r, g, b = B.Color(hot)
    local w = random() * 0.4
    local peak = hot and (0.65 + random() * 0.35) or (0.3 + random() * 0.3)
    e.tex:SetVertexColor(B.Lerp(r, 1, w), B.Lerp(g, 1, w), B.Lerp(b, 1, w), peak)

    local size = (hot and random(4, 9) or random(3, 6)) * fx.size
    e.tex:SetSize(size, size)
    e.tex:ClearAllPoints()
    e.tex:SetPoint("CENTER", holder, "CENTER", random(-150, 150), random(-150, -50))

    local dur   = (hot and (0.9 + random() * 1.0) or (2.8 + random() * 2.6)) / fx.speed
    local delay = burst and random() * 0.3 or random() * (hot and 0.7 or 2.4)
    local dx    = random(-28, 28) * fx.drift
    local dy    = (hot and random(110, 230) or random(45, 105)) * fx.rise

    -- Two legs: fade in over the first quarter of the climb, out over the rest.
    e.moveA:SetOffset(dx * 0.25, dy * 0.25); e.moveA:SetDuration(dur * 0.25); e.moveA:SetStartDelay(delay)
    e.fadeA:SetDuration(dur * 0.25);         e.fadeA:SetStartDelay(delay)
    e.moveB:SetOffset(dx * 0.75, dy * 0.75); e.moveB:SetDuration(dur * 0.75)
    e.fadeB:SetDuration(dur * 0.75)

    e.ag:Stop()
    e.ag:Play()
end

local function BuildEmbers()
    holder = CreateFrame("Frame", nil, B.anchor)
    holder:SetSize(2, 2)
    holder:SetPoint("CENTER")
    for i = 1, POOL do
        local e = {}
        e.tex = holder:CreateTexture(nil, "ARTWORK")
        e.tex:SetTexture(MEDIA .. "Ember")
        e.tex:SetBlendMode("ADD")
        e.tex:SetAlpha(0)
        e.ag = e.tex:CreateAnimationGroup()
        e.moveA = e.ag:CreateAnimation("Translation"); e.moveA:SetOrder(1)
        e.fadeA = e.ag:CreateAnimation("Alpha");       e.fadeA:SetOrder(1)
        e.fadeA:SetFromAlpha(0); e.fadeA:SetToAlpha(1)
        e.moveB = e.ag:CreateAnimation("Translation"); e.moveB:SetOrder(2)
        e.fadeB = e.ag:CreateAnimation("Alpha");       e.fadeB:SetOrder(2)
        e.fadeB:SetFromAlpha(1); e.fadeB:SetToAlpha(0)
        e.ag:SetScript("OnFinished", function()
            if e.live and B.active then Launch(e) end
        end)
        embers[i] = e
    end
end

local function UpdateEmbers()
    local db = B.db
    local count = 0
    if B.active and db.embers and not B.Flag(UnitIsDeadOrGhost("player")) then
        count = floor((B.inCombat and 18 or 7) * (db.emberAmount or 1) + 0.5)
        count = math.min(POOL, count)
    end
    for i, e in ipairs(embers) do
        e.live = i <= count
        if e.live and not e.ag:IsPlaying() then Launch(e) end
    end
end

local function Burst(n)
    if not B.db.embers then return end
    for i = 1, math.min(POOL, n) do Launch(embers[i], true) end
end

-- ---------------------------------------------------------------------
-- Pulses (shockwave, blades)
-- ---------------------------------------------------------------------
local fx
local shock, calm, bladeL, bladeR

local function MakePulse(parent, file, size)
    local p = {}
    p.tex = parent:CreateTexture(nil, "ARTWORK")
    p.tex:SetTexture(MEDIA .. file)
    p.tex:SetBlendMode("ADD")
    p.tex:SetSize(size, size)
    p.tex:SetPoint("CENTER")
    p.tex:SetAlpha(0)
    p.ag = p.tex:CreateAnimationGroup()
    p.scale = p.ag:CreateAnimation("Scale")
    p.alpha = p.ag:CreateAnimation("Alpha")
    return p
end

local function PlayPulse(p, s0, s1, a0, dur, smoothing, r, g, b, delay)
    p.tex:SetVertexColor(r, g, b)
    p.scale:SetScaleFrom(s0, s0); p.scale:SetScaleTo(s1, s1)
    p.scale:SetDuration(dur); p.scale:SetSmoothing(smoothing); p.scale:SetStartDelay(delay or 0)
    p.alpha:SetFromAlpha(a0); p.alpha:SetToAlpha(0)
    p.alpha:SetDuration(dur); p.alpha:SetSmoothing("IN"); p.alpha:SetStartDelay(delay or 0)
    p.ag:Stop()
    p.ag:Play()
end

local function MakeBlade(dir)
    local b = {}
    b.tex = fx:CreateTexture(nil, "OVERLAY")
    b.tex:SetTexture(MEDIA .. "Blade")
    b.tex:SetBlendMode("ADD")
    b.tex:SetSize(300, 10)
    b.tex:SetPoint("CENTER", fx, "CENTER", dir * 110, 0)
    b.tex:SetAlpha(0)
    b.ag = b.tex:CreateAnimationGroup()
    local mv = b.ag:CreateAnimation("Translation")
    mv:SetOffset(dir * 190, 0); mv:SetDuration(0.5); mv:SetSmoothing("OUT")
    local al = b.ag:CreateAnimation("Alpha")
    al:SetFromAlpha(1); al:SetToAlpha(0); al:SetDuration(0.5); al:SetSmoothing("IN")
    return b
end

local function BuildPulses()
    fx = CreateFrame("Frame", nil, B.anchor)
    fx:SetSize(2, 2)
    fx:SetPoint("CENTER")
    fx:SetFrameStrata("MEDIUM")
    shock  = MakePulse(fx, "Wave", 360)
    calm   = MakePulse(fx, "Wave", 360)
    bladeL = MakeBlade(-1)
    bladeR = MakeBlade(1)
end

-- ---------------------------------------------------------------------
-- Module hooks
-- ---------------------------------------------------------------------
function Fx:Init()
    local _, class = UnitClass("player")
    classFx = B.CLASS_FX[class] or PLAIN
    BuildEmbers()
    BuildPulses()
end

function Fx:Refresh()
    UpdateEmbers()
end

function Fx:Disable()
    for _, e in ipairs(embers) do
        e.live = false
        e.ag:Stop()
        e.tex:SetAlpha(0)
    end
end

function Fx:CombatStart()
    if B.db.transitions then
        local r, g, b = B.Color(true)
        PlayPulse(shock, 0.3, 1.45, 0.85, 0.6, "OUT", r, g, b)
        bladeL.tex:SetVertexColor(r, g, b); bladeL.ag:Stop(); bladeL.ag:Play()
        bladeR.tex:SetVertexColor(r, g, b); bladeR.ag:Stop(); bladeR.ag:Play()
        Burst(14)
    end
    UpdateEmbers()
end

function Fx:CombatEnd()
    if B.db.transitions then
        local r, g, b = B.Color(false)
        PlayPulse(calm, 1.35, 0.45, 0.5, 0.9, "IN_OUT", r, g, b)
    end
    UpdateEmbers()
end
