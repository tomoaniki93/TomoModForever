-- =====================================================================
-- AnimHUD / Core.lua -- the "Animation" look of the unit frames (1.3.2)
--
-- A third look, chosen in Frames > Shared style (unitFrames.style =
-- "animation"), next to "tmf" and "forever". It is the halo of Braise,
-- TomoAniki's HUD addon, brought into TMF: instead of boxes, thin arcs
-- around the character.
--
--   * arcs     your health (left) and power (right); the target one ring
--              further out, the pet one ring further in; target of target
--              above the target's name. Clickable like unit frames.
--   * signs    cast arcs (yours closes the circle at the bottom, the
--              target's just under it), threat gauge at the top, combo
--              points under the character.
--   * auras    your buffs / debuffs left of the halo, the target's right.
--   * centre   two rings turning in opposite directions, embers drifting
--              up; on combat start a shockwave, two blades and the arcs
--              snapping in, on combat end a wave closing back.
--
-- Left out on purpose (Braise keeps them): screen-edge heat and low-health
-- vignette, level-up fanfare, after-combat recap card with the XP gained,
-- missing-buff reminders (TMF has its own, Adventure > Missing buffs).
--
-- With this look the TMF frames of the player, target, target of target
-- and pet are switched off (UF.ApplyAnimationVisibility, UnitFrame.lua),
-- and so are the TMF cast bars of the player, target and pet
-- (CB.CreateCastbar, Castbar.lua). Focus and boss frames keep the TMF look.
-- If the Braise addon itself is loaded, this look stands down: two halos
-- would sit on top of each other.
--
-- Files: Core (settings, tweens, anchor, state, coordination), Fx (embers,
-- shockwave, blades), Halo (arcs, rings, timer, clicks, move mode), Signs
-- (casts, threat, combo points), Auras.
-- Forever runs the Midnight client: health, power and cast times may be
-- secret in combat, so they are never compared or added in Lua, only
-- handed to widgets and C-side curves (same rules as Braise).
-- =====================================================================

TomoMod_AnimHUD = TomoMod_AnimHUD or {}
local B = TomoMod_AnimHUD

local ROOT = "Interface\\AddOns\\TomoModForever\\Assets\\"
B.MEDIA     = ROOT .. "Textures\\Animation\\"
B.FONT      = ROOT .. "Fonts\\Poppins-Medium.ttf"
B.FONT_BOLD = ROOT .. "Fonts\\Poppins-SemiBold.ttf"
B.WHITE     = "Interface\\Buttons\\WHITE8x8"

local IS_FR = GetLocale() == "frFR"
function B.T(fr, en) return IS_FR and fr or en end
local T = B.T

-- ---------------------------------------------------------------------
-- Settings (TomoModForeverDB.unitFrames.animation; same defaults in
-- Core/Database.lua so profiles and import keep them)
-- ---------------------------------------------------------------------
B.defaults = {
    target       = true,   -- outer arcs for the target
    pet          = true,   -- inner arcs for the pet
    tot          = true,   -- target of target, above the target's name
    auraPlayer   = true,   -- your buffs and debuffs, left of the halo
    auraTarget   = true,   -- the target's buffs and debuffs, right of the halo
    cast         = true,   -- cast arcs (player, target)
    combo        = true,   -- combo point pips
    click        = true,   -- arcs take clicks: left targets, right opens the unit menu
    texts        = true,   -- health / power numbers by the arcs
    ring         = true,   -- rotating rings
    embers       = true,   -- drifting particles
    classEmbers  = true,   -- embers move the way the class does
    threat       = true,   -- threat gauge at the top of the halo
    tankMode     = false,  -- threat reads the other way round
    transitions  = true,   -- shockwave, blades and arcs snapping in on combat start / end
    timer        = true,   -- combat timer under the halo
    keepPetFrame = false,  -- keep the TMF pet frame (pet mood) instead of hiding it
    keepToTFrame = false,  -- keep the TMF target-of-target frame
    scale        = 1.0,
    textScale    = 1.0,    -- every text of the HUD (names, values, timer, cast names)
    auraScale    = 1.0,    -- buff / debuff icons
    oocAlpha     = 0.35,   -- halo opacity when idle
    emberAmount  = 1.0,
    x            = 0,
    y            = 0,
    theme        = "classe",
    offsets      = {},     -- per-element nudges set in move mode: key -> { x, y }
}

--- The settings table, filled with any missing default.
function B.DB()
    local uf = TomoModForeverDB and TomoModForeverDB.unitFrames
    if not uf then return nil end
    if type(uf.animation) ~= "table" then uf.animation = {} end
    local db = uf.animation
    for k, v in pairs(B.defaults) do
        if type(db[k]) ~= type(v) then
            db[k] = type(v) == "table" and {} or v     -- never share the default table
        end
    end
    return db
end

-- accent: idle colour. hot: combat colour.
B.themes = {
    { key = "braise", fr = "Braise", en = "Ember",  accent = { 0.79, 0.64, 0.32 }, hot = { 1.00, 0.42, 0.14 } },
    { key = "givre",  fr = "Givre",  en = "Frost",  accent = { 0.62, 0.82, 1.00 }, hot = { 0.30, 0.62, 1.00 } },
    { key = "seve",   fr = "Sève",   en = "Sap",    accent = { 0.62, 0.85, 0.48 }, hot = { 0.96, 0.84, 0.26 } },
    { key = "classe", fr = "Classe", en = "Class",  accent = { 1, 1, 1 },          hot = { 1, 1, 1 } },   -- palette from B.CLASS_FX
}

function B.Theme()
    local key = B.db and B.db.theme
    for _, th in ipairs(B.themes) do
        if th.key == key then return th end
    end
    return B.themes[1]
end

-- ---------------------------------------------------------------------
-- When the look is on
-- ---------------------------------------------------------------------
function B.BraiseLoaded()
    local f = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
    if not f then return false end
    local ok, loaded = pcall(f, "Braise")
    return ok and loaded and true or false
end

--- The player chose the Animation look (and nothing stands in its way).
function B.IsWanted()
    local uf = TomoModForeverDB and TomoModForeverDB.unitFrames
    return uf ~= nil and uf.enabled ~= false and uf.style == "animation" and not B.BraiseLoaded()
end

--- Is this TMF unit frame replaced by the halo?
function B.HidesUnit(unit)
    if not B.IsWanted() then return false end
    if unit == "player" or unit == "target" then return true end
    local db = B.DB()
    if unit == "targettarget" then return not (db and db.keepToTFrame) end
    if unit == "pet" then return not (db and db.keepPetFrame) end
    return false
end

--- Are the TMF cast bars of this unit replaced by the cast arcs?
function B.HidesCastbar(unit)
    return (unit == "player" or unit == "target" or unit == "pet") and B.IsWanted()
end

-- ---------------------------------------------------------------------
-- Secret values
-- ---------------------------------------------------------------------
local issecretvalue = issecretvalue
function B.Secret(v) return issecretvalue ~= nil and issecretvalue(v) end

--- A number Lua may do arithmetic on, or nil.
function B.Num(v)
    if type(v) ~= "number" or B.Secret(v) then return nil end
    return v
end

--- A boolean Lua may branch on (a secret boolean reads as false).
function B.Flag(v)
    if B.Secret(v) then return false end
    return v and true or false
end

-- ---------------------------------------------------------------------
-- Tweens: one driver frame, keyed so a new tween replaces the old one
-- ---------------------------------------------------------------------
B.Ease = {
    linear   = function(p) return p end,
    outCubic = function(p) p = 1 - p; return 1 - p * p * p end,
    inCubic  = function(p) return p * p * p end,
    inOut    = function(p) return p < 0.5 and 4 * p * p * p or 1 - ((-2 * p + 2) ^ 3) / 2 end,
    outBack  = function(p) local c = 1.70158; p = p - 1; return 1 + (c + 1) * p * p * p + c * p * p end,
}

local active = {}
local driver = CreateFrame("Frame")
driver:Hide()

--- Drive fn(value) from `from` to `to` over `dur` seconds.
function B.Tween(key, dur, from, to, fn, ease, done)
    if not dur or dur <= 0 then
        active[key] = nil
        fn(to)
        if done then done() end
        return
    end
    local tw = active[key] or {}
    tw.t, tw.d, tw.a, tw.b = 0, dur, from, to
    tw.fn, tw.e, tw.done = fn, ease or B.Ease.outCubic, done
    active[key] = tw
    fn(from)
    driver:Show()
end

function B.StopTween(key) active[key] = nil end

driver:SetScript("OnUpdate", function(_, dt)
    local finished
    for key, tw in pairs(active) do
        tw.t = tw.t + dt
        local p = tw.t / tw.d
        if p >= 1 then
            active[key] = nil
            tw.fn(tw.b)
            if tw.done then
                finished = finished or {}
                finished[#finished + 1] = tw.done
            end
        else
            tw.fn(tw.a + (tw.b - tw.a) * tw.e(p))
        end
    end
    if finished then
        for i = 1, #finished do finished[i]() end
    end
    if not next(active) then driver:Hide() end
end)

--- Fade a frame from its current alpha; hides it when it reaches 0.
function B.Fade(frame, to, dur, ease)
    if to > 0 then frame:Show() end
    B.Tween(frame, dur, frame:GetAlpha(), to, function(a) frame:SetAlpha(a) end, ease, function()
        if to <= 0 then frame:Hide() end
    end)
end

function B.Lerp(a, b, p) return a + (b - a) * p end

-- ---------------------------------------------------------------------
-- Anchor: everything centred on the character hangs from this frame
-- ---------------------------------------------------------------------
local anchor = CreateFrame("Frame", "TomoMod_AnimHUD_Anchor", UIParent)
anchor:SetSize(2, 2)
anchor:SetPoint("CENTER")
anchor:SetFrameStrata("LOW")
anchor:Hide()
B.anchor = anchor

function B.ApplyAnchor()
    local db = B.db
    if not db then return end
    -- The click zones are secure frames anchored here, which makes the
    -- anchor itself untouchable in combat: wait for the fight to end.
    if InCombatLockdown() then
        B.anchorPending = true
        return
    end
    B.anchorPending = nil
    local s = math.max(0.4, math.min(2, db.scale or 1))
    anchor:SetScale(s)
    anchor:ClearAllPoints()
    -- Offsets are stored in UIParent units; SetPoint reads them in the
    -- frame's own scale, hence the division.
    anchor:SetPoint("CENTER", UIParent, "CENTER", (db.x or 0) / s, (db.y or 0) / s)
end

-- ---------------------------------------------------------------------
-- Movable elements
-- ---------------------------------------------------------------------
-- Every bar of the HUD can be nudged away from its place in the halo. An
-- element registers a key, a label, how to lay a drag handle over itself,
-- and how to re-apply its position; move mode (Halo.lua) does the rest.
B.movables = {}

function B.Movable(key, label, place, apply)
    B.movables[#B.movables + 1] = { key = key, label = label, place = place, apply = apply }
end

--- The element's offset from its default place, in halo units.
function B.Off(key)
    local o = B.db and B.db.offsets and B.db.offsets[key]
    if o then return o.x or 0, o.y or 0 end
    return 0, 0
end

-- Colours ---------------------------------------------------------------
-- Each class has its own palette (idle, combat), used by every accent of
-- the HUD, and its own way of moving embers. speed > 1 is quicker, drift
-- widens the sideways wander, rise stretches the climb, size scales the
-- particle.
B.CLASS_FX = {
    WARRIOR     = { idle = { 0.86, 0.42, 0.24 }, hot = { 1.00, 0.26, 0.10 }, speed = 1.35, drift = 0.6, rise = 1.15, size = 0.9 },  -- forge sparks
    PALADIN     = { idle = { 1.00, 0.86, 0.50 }, hot = { 1.00, 0.72, 0.82 }, speed = 0.85, drift = 0.3, rise = 1.25, size = 1.15 }, -- motes of light
    HUNTER      = { idle = { 0.62, 0.82, 0.42 }, hot = { 0.74, 0.95, 0.36 }, speed = 1.00, drift = 2.4, rise = 0.75, size = 0.9 },  -- carried by the wind
    ROGUE       = { idle = { 0.92, 0.84, 0.36 }, hot = { 1.00, 0.92, 0.30 }, speed = 1.60, drift = 1.6, rise = 0.80, size = 0.75 }, -- quick glints
    PRIEST      = { idle = { 0.96, 0.95, 0.90 }, hot = { 1.00, 0.94, 0.70 }, speed = 0.70, drift = 0.5, rise = 1.10, size = 1.35 }, -- slow, soft, large
    SHAMAN      = { idle = { 0.30, 0.56, 1.00 }, hot = { 0.45, 0.78, 1.00 }, speed = 1.80, drift = 1.9, rise = 0.60, size = 0.8 },  -- static
    MAGE        = { idle = { 0.56, 0.82, 1.00 }, hot = { 0.74, 0.60, 1.00 }, speed = 0.90, drift = 1.0, rise = 1.00, size = 1.0 },  -- arcane frost
    WARLOCK     = { idle = { 0.62, 0.44, 0.90 }, hot = { 0.56, 1.00, 0.30 }, speed = 0.95, drift = 1.5, rise = 1.00, size = 1.05 }, -- shadow, then fel
    DRUID       = { idle = { 0.98, 0.58, 0.20 }, hot = { 0.55, 0.92, 0.38 }, speed = 0.80, drift = 2.0, rise = 0.85, size = 1.1 },  -- drifting leaves
    MONK        = { idle = { 0.36, 0.92, 0.66 }, hot = { 0.30, 1.00, 0.72 }, speed = 1.05, drift = 1.7, rise = 0.95, size = 0.95 }, -- jade mist
    DEATHKNIGHT = { idle = { 0.56, 0.80, 0.92 }, hot = { 0.82, 0.16, 0.22 }, speed = 0.80, drift = 0.7, rise = 0.90, size = 1.1 },
    DEMONHUNTER = { idle = { 0.66, 0.30, 0.86 }, hot = { 0.62, 1.00, 0.24 }, speed = 1.40, drift = 1.2, rise = 1.10, size = 0.9 },
    EVOKER      = { idle = { 0.30, 0.72, 0.62 }, hot = { 0.40, 0.92, 0.78 }, speed = 1.00, drift = 1.3, rise = 1.10, size = 1.0 },
}

--- r, g, b of the theme. hot = combat colour. The "classe" theme reads
--- the class palette above (class colour as a last resort).
function B.Color(hot)
    local th = B.Theme()
    if th.key == "classe" then
        local _, class = UnitClass("player")
        local fx = class and B.CLASS_FX[class]
        if fx then
            local c = hot and fx.hot or fx.idle
            return c[1], c[2], c[3]
        end
        local cc = class and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
        if cc then return cc.r, cc.g, cc.b end
        th = B.themes[1]
    end
    local c = hot and th.hot or th.accent
    return c[1], c[2], c[3]
end

--- Theme colour for the current state.
function B.StateColor() return B.Color(B.inCombat) end

-- ---------------------------------------------------------------------
-- Modules
-- ---------------------------------------------------------------------
B.modules = {}
function B.Module(name)
    local m = {}
    B.modules[#B.modules + 1] = m
    B[name] = m
    return m
end

function B.Call(method, ...)
    for _, m in ipairs(B.modules) do
        local fn = m[method]
        if fn then
            local ok, err = pcall(fn, m, ...)
            if not ok then B.lastError = method .. " : " .. tostring(err) end
            if not ok and TomoModForeverDB and TomoModForeverDB.diagnostics and TomoModForeverDB.diagnostics.debug then
                print("|cffffd100TomoModForever|r AnimHUD " .. method .. " : " .. tostring(err))
            end
        end
    end
end

-- ---------------------------------------------------------------------
-- Combat state
-- ---------------------------------------------------------------------
local fight = {}

local function StartCombat(simulated)
    if B.inCombat then return end
    B.inCombat = true
    B.combatT0 = GetTime()
    fight.simulated = simulated
    if B.active then B.Call("CombatStart") end
end

local function EndCombat(fakeDuration)
    if not B.inCombat then return end
    B.inCombat = false
    local duration = fakeDuration or (GetTime() - (B.combatT0 or GetTime()))
    if B.active then B.Call("CombatEnd", duration) end
end

--- A scripted fight: the combat-start and combat-end animations.
function B.Demo()
    if not B.active or InCombatLockdown() or B.inCombat then return end
    StartCombat(true)
    C_Timer.After(4.5, function()
        if fight.simulated and not InCombatLockdown() then
            fight.simulated = nil
            EndCombat(42)
        end
    end)
end

-- ---------------------------------------------------------------------
-- Turning the look on and off (no /reload; out of combat)
-- ---------------------------------------------------------------------
local lastWanted              -- nil until the first sync of the session

-- Blizzard's own player, target and pet cast bars would double the cast
-- arcs. Same anti-taint pattern as Castbar.lua (no OnShow hook on a
-- protected bar): no events, transparent, click-through. The focus bar is
-- left alone. Getting Blizzard's events back needs a /reload.
local BLIZZ_BARS = { "PlayerCastingBarFrame", "TargetFrameSpellBar", "PetCastingBarFrame" }

local function MuteBlizzardBars()
    for _, name in ipairs(BLIZZ_BARS) do
        local f = rawget(_G, name)
        if type(f) == "table" and f.UnregisterAllEvents then
            f:UnregisterAllEvents()
            f:SetAlpha(0)
            if f.EnableMouse then f:EnableMouse(false) end
        end
    end
end

local function SyncCastbars(want)
    local CB = TomoMod_Castbar
    if not CB then
        if want then MuteBlizzardBars() end
        return
    end
    if lastWanted ~= nil and lastWanted ~= want then
        -- The bars read B.HidesCastbar when they are created.
        local cdb = TomoModForeverDB and TomoModForeverDB.castbars
        if cdb and cdb.enabled and CB.RefreshAll then pcall(CB.RefreshAll) end
        if not want and CB.ShowBlizzardCastbar and not (cdb and cdb.enabled and cdb.hideBlizzardCastbar) then
            pcall(CB.ShowBlizzardCastbar)   -- Blizzard's events need a /reload to come back
        end
    end
    if want then MuteBlizzardBars() end
end

function B.Build()
    if B.built then return end
    B.built = true
    B.db = B.DB()
    B.ApplyAnchor()
    B.Call("Init")
end

function B.Sync()
    if not TomoModForeverDB then return end
    if InCombatLockdown() then
        B.syncPending = true
        return
    end
    B.syncPending = nil
    local want = B.IsWanted()

    if want then
        B.db = B.DB()
        -- Shown before the build: the aura engine lays out from an OnUpdate
        -- and registers its unit on a container that can be drawn.
        anchor:Show()
        if not B.built then B.Build() end
        B.active = true
        B.ApplyAnchor()
        B.Call("Refresh")
    elseif B.active then
        B.active = false
        B.Call("Disable")
        anchor:Hide()
    end

    local UF = TomoMod_UnitFrames
    if UF and UF.ApplyAnimationVisibility then UF.ApplyAnimationVisibility() end
    SyncCastbars(want)
    lastWanted = want
end

--- Settings changed in the panel: re-apply what can change live.
function B.Refresh()
    if not B.active then return end
    -- Frame visibility (keep the TMF pet / ToT frame) waits for the end of
    -- combat; everything else below applies now or defers itself.
    if InCombatLockdown() then B.syncPending = true end
    B.db = B.DB()
    B.ApplyAnchor()
    B.Call("Refresh")
    local UF = TomoMod_UnitFrames
    if UF and UF.ApplyAnimationVisibility then UF.ApplyAnimationVisibility() end
end

function B.ToggleMover()
    if not B.active then
        print("|cffffd100TomoModForever|r " .. T("le style Animation n'est pas actif (Cadres > Style commun).",
            "the Animation look is not on (Frames > Shared style)."))
        return
    end
    if B.Halo and B.Halo.ToggleMover then B.Halo:ToggleMover() end
end

--- /tmf anim debug
function B.Debug()
    local function out(msg) print("|cffffd100TMF anim|r " .. msg) end
    local uf = TomoModForeverDB and TomoModForeverDB.unitFrames
    out(string.format("style %s, unit frames %s, Braise %s, wanted %s, built %s, active %s",
        tostring(uf and uf.style), tostring(uf and uf.enabled), tostring(B.BraiseLoaded()),
        tostring(B.IsWanted()), tostring(B.built), tostring(B.active)))
    out("anchor shown " .. tostring(anchor:IsShown()) .. ", visible " .. tostring(anchor:IsVisible()))
    if B.lastError then out("|cffff5555last error|r " .. B.lastError) end
    if B.Auras and B.Auras.buildError then out("|cffff5555aura build error|r " .. B.Auras.buildError) end
    if B.Auras and B.Auras.Debug and B.built then B.Auras:Debug(out) end
end

function B.IsMoving()
    return B.Halo and B.Halo.IsMoving and B.Halo:IsMoving() or false
end

function B.Reset()
    local uf = TomoModForeverDB and TomoModForeverDB.unitFrames
    if not uf then return end
    uf.animation = {}
    B.db = B.DB()
    if B.active then
        for _, m in ipairs(B.movables) do m.apply() end
    end
    B.Sync()
end

-- ---------------------------------------------------------------------
-- Events
-- ---------------------------------------------------------------------
local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PLAYER_REGEN_DISABLED")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:RegisterEvent("PLAYER_DEAD")
events:RegisterEvent("PLAYER_ALIVE")
events:RegisterEvent("PLAYER_UNGHOST")
events:RegisterEvent("PLAYER_TARGET_CHANGED")
events:RegisterEvent("UI_SCALE_CHANGED")

events:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_ENTERING_WORLD" then
        fight.simulated = nil
        B.inCombat = InCombatLockdown() and true or false
        if B.inCombat then B.combatT0 = GetTime() end
        B.Sync()
        if B.active then B.Call("Refresh") end
    elseif event == "PLAYER_REGEN_DISABLED" then
        if fight.simulated then      -- a real fight interrupts the demo
            fight.simulated = nil
            B.inCombat = false
        end
        StartCombat(false)
    elseif event == "PLAYER_REGEN_ENABLED" then
        EndCombat()
        if B.syncPending then B.Sync() end
        if B.active then
            if B.anchorPending then B.ApplyAnchor() end
            if B.Halo and B.Halo.ApplyClicks then B.Halo:ApplyClicks() end
        end
    elseif B.active then
        B.Call("Refresh")
    end
end)

-- ---------------------------------------------------------------------
-- Layout mode (/tmf layout): the halo's own move mode opens with it.
-- ---------------------------------------------------------------------
if TomoMod_Movers and TomoMod_Movers.RegisterEntry then
    TomoMod_Movers.RegisterEntry({
        label    = T("HUD Animation", "Animation HUD"),
        unlock   = function()
            if B.active and not B.IsMoving() and B.Halo then B.Halo:ToggleMover() end
        end,
        lock     = function()
            if B.IsMoving() and B.Halo then B.Halo:ToggleMover() end
        end,
        isActive = function() return B.active == true end,
    })
end
