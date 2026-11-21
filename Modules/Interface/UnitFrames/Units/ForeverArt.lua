-- =====================================================================
-- Units/ForeverArt.lua -- "Forever" look drawn with the game's own art (1.3.6)
--
-- The Forever look (unitFrames.style = "forever") now has two skins,
-- chosen in Frames > Shared style (unitFrames.foreverArt):
--   * official (default): this file. The frame is drawn with WoW: Forever's
--     own unit frame art, the atlas UI-HUD-UnitFrame-Target-PortraitOn:
--     bronze plate with its name box and bar slots, portrait ring, level
--     disc. Read from the game, nothing copied into TMF.
--   * classic: ForeverStyle.lua's flat strip, border and medallion.
--
-- How the plate is drawn. The atlas (194 x 68 art pixels at 1x) is cut in
-- three slices across its full height: the left end (x 0-8) and the right
-- part (x 120-194: plate end, ring and rim) keep their size, the middle
-- (x 8-120) stretches with the frame's width. The ring stays whole, so no
-- mask is needed. Mirrored for the frames whose ring is on the left
-- (player, pet, target of target). The frame itself is the plate's body
-- (x 1-131, y 8-57): the ring hangs past it like on Blizzard's frames.
--   name box  x 4-125, y 11-26     health  y 29-42     power  y 45-53
--   ring      centre (158.6, 31.86), diameter 61.8
-- Placement of the level disc, raid / leader icons, PvP crest, elite and
-- rare dragon, quest mark, combat swords and corner piece follows
-- Blizzard's own frame (232 x 100, ring centre (176.9, -47.9), diameter
-- 61.1), scaled to the ring.
--
-- State art (Update): the elite / rare / boss dragon from the game's own
-- GetBossPortraitFrameData, the skull on the level disc for "??" units, the
-- quest mark for a quest boss or a hostile unit tied to an active quest, the
-- PvP crest, and on the player frame the combat swords, the resting corner
-- piece and a lit copy of the plate pulsing in the threat colour, red in
-- combat or gold while resting. Secret values hide the art.
--
-- Geometry, the slicing idea, the placement table and the state art follow
-- FlareUI by Malkkav (MIT License, https://github.com/malkkav/FlareUI),
-- rewritten for TMF's unit frame engine.
-- =====================================================================

TomoMod_UnitFrames = TomoMod_UnitFrames or {}
local UF = TomoMod_UnitFrames

local ATLAS        = "UI-HUD-UnitFrame-Target-PortraitOn"
local NAME_GLOW    = "UI-HUD-UnitFrame-Target-PortraitOn-Type"
local LEVEL_DISC   = "UI-HUD-UnitFrame-SmallCircle"
local SKULL        = "UI-HUD-UnitFrame-Target-HighLevelTarget_Icon"
local QUEST_MARK   = "UI-HUD-UnitFrame-Target-PortraitOn-Boss-Quest"
local LEADER       = "UI-HUD-UnitFrame-Player-Group-LeaderIcon"
local CORNER       = "UI-HUD-UnitFrame-Player-PortraitOn-CornerEmbellishment"
local SWORDS       = "UI-HUD-UnitFrame-Player-CombatIcon"
local PVP_ICONS    = {
    Horde    = "UI-HUD-UnitFrame-SmallCircle-Horde",
    Alliance = "UI-HUD-UnitFrame-SmallCircle-Alliance",
    FFA      = "UI-HUD-UnitFrame-Player-PVP-FFAIcon",
}
local MASK         = "Interface\\CHARACTERFRAME\\TempPortraitAlphaMask"
local LEVEL_FONT   = "Fonts\\FRIZQT__.TTF"

-- Bronze tint over the gold art, so it matches the rest of Forever's frames.
local PLATE_TINT   = { 0.88, 0.80, 0.66 }
local YELLOW       = { 1.000, 0.820, 0.000 }
local STATUS_REST  = { 1.00, 0.82, 0.35 }
local STATUS_FIGHT = { 1.00, 0.22, 0.18 }

-- Art space (1x atlas pixels)
local ART_W, ART_H = 194, 68
local CUT_L, CUT_R = 8, 120            -- the middle slice stretches between these
local X0, X1, Y0, Y1 = 1, 131, 8, 57   -- the frame: the plate's body
local NAME   = { 4, 125, 11, 26 }
local HEALTH = { 4, 125, 29, 42 }
local POWER  = { 4, 125, 45, 53 }
local HEALTH_FULL = { 4, 125, 29, 53 } -- no power bar: health down to the power slot's bottom
local RING_X, RING_Y, RING_D = 158.6, 31.86, 61.8
local PORTRAIT_SHARE = 0.86

-- Blizzard's frame (1x, origin top-left, y down): ring centre, diameter and
-- each element's anchor. Mirrored for the other side.
local BLIZZ = {
    player = {
        centre = { 232 - 176.9, -47.9 }, D = 61.1, side = "LEFT",
        level  = { atlas = LEVEL_DISC, point = "BOTTOMLEFT", x = 14.5, y = -91.5 },
        pvp    = { dx = -0.435, dy = 0.46, share = 0.8, move = { 6, -11.6 } },
        leader = { atlas = LEADER, point = "TOPLEFT", x = 86, y = -10 },
        raid   = { size = 26, point = "CENTER", x = 53.8, y = -19 },
        corner = { atlas = CORNER, point = "TOPLEFT", x = 58.5, y = -53.5 },
        attack = { atlas = SWORDS, point = "TOPLEFT", x = 64, y = -62 },
    },
    target = {
        centre = { 176.9, -47.9 }, D = 61.1, side = "RIGHT", boss = true,
        pvp    = { dx = 0.435, dy = 0.46, share = 0.8, move = { -6, -11.6 } },
        leader = { atlas = LEADER, point = "TOPRIGHT", x = 147, y = -8 },
        raid   = { size = 26, point = "CENTER", x = 177, y = -19 },
        quest  = { atlas = QUEST_MARK, point = "CENTER", x = 177, y = -77 },
    },
}
-- The level disc is the player's, mirrored, so the pair matches.
BLIZZ.target.level = { atlas = LEVEL_DISC, point = "BOTTOMLEFT", x = 14.5, y = -91.5, frame = "player" }
BLIZZ.focus = BLIZZ.target
BLIZZ.pet = { centre = BLIZZ.player.centre, D = BLIZZ.player.D, side = "LEFT", level = BLIZZ.player.level }
BLIZZ.targettarget = BLIZZ.pet
BLIZZ.focustarget = BLIZZ.pet
local BLIZZ_FRAME_W = 232

-- Default size per frame: width (px) and scale (1 = Blizzard's 1x art).
local DEFAULTS = {
    player       = { width = 170, scale = 1.30 },
    target       = { width = 170, scale = 1.30 },
    focus        = { width = 140, scale = 1.00 },
    pet          = { width = 100, scale = 0.75 },
    targettarget = { width = 90,  scale = 0.65 },
    focustarget  = { width = 90,  scale = 0.65 },
}
UF.FOREVER_ART_DEFAULTS = DEFAULTS

local function Readable(v)
    if type(issecretvalue) == "function" and issecretvalue(v) then return nil end
    return v
end

local atlasCache = {}
local function AtlasInfo(name)
    local v = atlasCache[name]
    if v == nil then
        v = (C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(name)) or false
        atlasCache[name] = v
    end
    return v or nil
end

local function SetAtlasSafe(tex, atlas)
    if not (atlas and AtlasInfo(atlas)) then return false end
    tex:SetAtlas(atlas)
    return true
end

--- The official skin is on: Forever look, foreverArt not switched off, and
--- the client has the art.
function UF.ForeverArtOn()
    local uf = TomoModForeverDB and TomoModForeverDB.unitFrames
    if not (uf and uf.style == "forever" and uf.foreverArt ~= false) then return false end
    return AtlasInfo(ATLAS) ~= nil
end

-- ---------------------------------------------------------------------
-- Geometry
-- ---------------------------------------------------------------------
local function Dims(unit)
    local base = DEFAULTS[unit]
    if not base then return nil end
    local uf = TomoModForeverDB and TomoModForeverDB.unitFrames
    local saved = uf and type(uf.foreverArtSizes) == "table" and uf.foreverArtSizes[unit]
    local s = tonumber(saved and saved.scale) or base.scale
    s = math.max(0.4, math.min(2.5, s))
    local fixed = ((CUT_L - X0) + (X1 - CUT_R)) * s
    local width = tonumber(saved and saved.width) or base.width
    width = math.max(width, math.ceil(fixed + 24 * s))
    local blizz = BLIZZ[unit]
    return { s = s, width = width, mid = width - fixed, height = (Y1 - Y0) * s,
             flip = blizz.side == "LEFT", blizz = blizz, kind = unit }
end
UF.ForeverArtDims = Dims

-- Art x -> distance from the frame's left edge (ring on the right).
local function FX(d, x)
    if x <= CUT_L then return (x - X0) * d.s end
    if x <= CUT_R then return (CUT_L - X0) * d.s + (x - CUT_L) / (CUT_R - CUT_L) * d.mid end
    return (CUT_L - X0) * d.s + d.mid + (x - CUT_R) * d.s
end
-- Art y -> offset from the frame's top (negative down).
local function FY(d, y) return -(y - Y0) * d.s end

-- Left / right edges of an art span on the frame, mirrored when needed.
local function Span(d, xa, xb)
    local l, r = FX(d, xa), FX(d, xb)
    if d.flip then return d.width - r, d.width - l end
    return l, r
end

local function PlaceBox(region, frame, d, box)
    local l, r = Span(d, box[1], box[2])
    region:ClearAllPoints()
    region:SetPoint("TOPLEFT", frame, "TOPLEFT", l, FY(d, box[3]))
    region:SetPoint("BOTTOMRIGHT", frame, "TOPLEFT", r, FY(d, box[4]))
end

-- The ring's centre on the frame (from its top-left) and diameter.
local function RingGeo(d)
    local cx = FX(d, RING_X)
    if d.flip then cx = d.width - cx end
    return cx, FY(d, RING_Y), RING_D * d.s
end

-- An element of BLIZZ: its centre (from the ring's centre) and size.
local function Place(d, e, atlasOverride)
    if not e then return nil end
    local blizz = BLIZZ[e.frame or d.kind] or d.blizz
    local _, _, D = RingGeo(d)
    local k = D / blizz.D
    local w, h
    if e.size then
        w, h = e.size, e.size
    else
        local info = AtlasInfo(atlasOverride or e.atlas)
        if not (info and info.width and info.height) then return nil end
        w, h = info.width, info.height
    end
    local p = e.point
    local cx = p:find("LEFT") and e.x + w / 2 or p:find("RIGHT") and e.x - w / 2 or e.x
    local cy = p:find("TOP") and e.y - h / 2 or p:find("BOTTOM") and e.y + h / 2 or e.y
    local dx, dy = (cx - blizz.centre[1]) * k, (cy - blizz.centre[2]) * k
    local side = d.flip and "LEFT" or "RIGHT"
    if side ~= blizz.side then dx = -dx end
    return dx, dy, w * k, h * k
end

local function PlaceAt(region, art, d, e, atlasOverride, scale)
    local dx, dy, w, h = Place(d, e, atlasOverride)
    if not dx then region:Hide() return false end
    scale = scale or 1
    region:ClearAllPoints()
    region:SetSize(w * scale, h * scale)
    region:SetPoint("CENTER", art.ringCentre, "CENTER", dx, dy)
    return true
end

-- ---------------------------------------------------------------------
-- Build (once per frame)
-- ---------------------------------------------------------------------
local function Slices(holder, layer, sub)
    local t = {}
    for i = 1, 3 do t[i] = holder:CreateTexture(nil, layer, nil, sub) end
    return t
end

local function Build(frame)
    if frame._fa then return frame._fa end
    local art = {}
    local lvl = frame.health:GetFrameLevel()

    -- Plate and ring, under the bars.
    local holder = CreateFrame("Frame", nil, frame)
    holder:SetAllPoints(frame)
    holder:EnableMouse(false)
    holder:SetFrameLevel(math.max(0, lvl - 2))
    art.holder = holder

    art.ringCentre = holder:CreateTexture(nil, "BACKGROUND")
    art.ringCentre:SetSize(1, 1)
    art.ringCentre:SetAlpha(0)

    art.portraitBack = holder:CreateTexture(nil, "BACKGROUND", nil, -2)
    art.portraitBack:SetTexture(MASK)
    art.portraitBack:SetVertexColor(0.04, 0.035, 0.03, 1)
    art.portrait = holder:CreateTexture(nil, "BACKGROUND", nil, -1)
    art.portraitMask = holder:CreateMaskTexture()
    art.portraitMask:SetTexture(MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    art.portraitMask:SetAllPoints(art.portrait)
    art.portrait:AddMaskTexture(art.portraitMask)

    art.slices = Slices(holder, "ARTWORK", 0)
    -- Lit copy for the threat / combat / rest glow, on its own layer so the
    -- pulse only touches it (above the plate, under the bars).
    local glowFrame = CreateFrame("Frame", nil, holder)
    glowFrame:SetAllPoints(frame)
    glowFrame:EnableMouse(false)
    glowFrame:SetFrameLevel(holder:GetFrameLevel() + 1)
    art.glow = Slices(glowFrame, "ARTWORK", 0)
    for _, g in ipairs(art.glow) do
        g:SetDesaturated(true)
        g:SetBlendMode("ADD")
        g:Hide()
    end
    local pulse = glowFrame:CreateAnimationGroup()
    pulse:SetLooping("BOUNCE")
    local a = pulse:CreateAnimation("Alpha")
    a:SetFromAlpha(0.15); a:SetToAlpha(0.6); a:SetDuration(1.2); a:SetSmoothing("IN_OUT")
    art.glowPulse = pulse
    art.glowFrame = glowFrame

    -- Name box glow (the game's reaction tint), behind the name.
    art.nameGlow = holder:CreateTexture(nil, "ARTWORK", nil, 1)
    art.nameBox = CreateFrame("Frame", nil, frame)
    art.nameBox:EnableMouse(false)
    art.nameBox:SetFrameLevel(lvl + 3)

    -- Above the bars: level disc, icons, dragon.
    local over = CreateFrame("Frame", nil, frame)
    over:SetAllPoints(frame)
    over:EnableMouse(false)
    over:SetFrameLevel(lvl + 6)
    art.over = over
    art.boss = over:CreateTexture(nil, "BACKGROUND")
    art.disc = over:CreateTexture(nil, "ARTWORK")
    art.skull = over:CreateTexture(nil, "OVERLAY", nil, 1)
    art.level = over:CreateFontString(nil, "OVERLAY")
    art.level:SetFont(LEVEL_FONT, 12, "")
    art.level:SetShadowOffset(1, -1)
    art.level:SetShadowColor(0, 0, 0, 1)
    art.quest = over:CreateTexture(nil, "OVERLAY")
    art.pvp = over:CreateTexture(nil, "ARTWORK", nil, 1)
    art.corner = over:CreateTexture(nil, "ARTWORK", nil, 2)
    art.attack = over:CreateTexture(nil, "OVERLAY", nil, 2)
    for _, k in ipairs({ "boss", "skull", "quest", "pvp", "corner", "attack" }) do art[k]:Hide() end

    frame._fa = art
    return art
end

local function ShowArt(art, on)
    art.holder:SetShown(on)
    art.over:SetShown(on)
    art.nameBox:SetShown(on)
end

--- Hides the official skin (classic skin or another style chosen).
function UF.ForeverArtHide(frame)
    local art = frame and frame._fa
    if not art then return end
    ShowArt(art, false)
    art.glowPulse:Stop()
    if art.hitSet and frame.SetHitRectInsets and not InCombatLockdown() then
        frame:SetHitRectInsets(0, 0, 0, 0)
        art.hitSet = nil
    end
    -- Icons and texts the skin had taken: back to the engine.
    local h = frame.health
    if h and h.nameText and h.nameText:GetParent() == art.nameBox then h.nameText:SetParent(h) end
    if h and h.raidIcon and h.raidIcon:GetParent() == art.over then h.raidIcon:SetParent(h) end
    if h and h.leaderIcon then
        if h.leaderIcon:GetParent() == art.over then h.leaderIcon:SetParent(h) end
        local t = art.leaderTex
        if type(t) == "string" or type(t) == "number" then h.leaderIcon:SetTexture(t) end
        art.leaderTex = nil
    end
    art.portraitUnit = nil
end

-- ---------------------------------------------------------------------
-- Layout (out of combat, from ApplyVisuals)
-- ---------------------------------------------------------------------
local function LayoutPlate(frame, art, d)
    local info = AtlasInfo(ATLAS)
    if not info or not info.file then
        for i = 1, 3 do art.slices[i]:Hide(); art.glow[i]:Hide() end
        return
    end
    local du = info.rightTexCoord - info.leftTexCoord
    local top, bottom = info.topTexCoord, info.bottomTexCoord
    local cuts = { 0, CUT_L, CUT_R, ART_W }
    for i = 1, 3 do
        local xa, xb = cuts[i], cuts[i + 1]
        local u1 = info.leftTexCoord + xa / ART_W * du
        local u2 = info.leftTexCoord + xb / ART_W * du
        if d.flip then u1, u2 = u2, u1 end
        for _, t in ipairs({ art.slices[i], art.glow[i] }) do
            t:SetTexture(info.file)
            t:SetTexCoord(u1, u2, top, bottom)
            -- x span on the frame, the art's full height (y 0-68)
            local l, r = Span(d, xa, xb)
            t:ClearAllPoints()
            t:SetPoint("TOPLEFT", frame, "TOPLEFT", l, FY(d, 0))
            t:SetPoint("BOTTOMRIGHT", frame, "TOPLEFT", r, FY(d, ART_H))
        end
        local tint = PLATE_TINT
        art.slices[i]:SetVertexColor(tint[1], tint[2], tint[3], 1)
        art.slices[i]:Show()
    end

    -- Ring centre, portrait under the ring.
    local cx, cy, D = RingGeo(d)
    art.ringCentre:ClearAllPoints()
    art.ringCentre:SetPoint("CENTER", frame, "TOPLEFT", cx, cy)
    local pd = D * PORTRAIT_SHARE
    art.portrait:ClearAllPoints()
    art.portrait:SetSize(pd, pd)
    art.portrait:SetPoint("CENTER", art.ringCentre, "CENTER", 0, 0)
    art.portraitBack:ClearAllPoints()
    art.portraitBack:SetSize(D * 0.94, D * 0.94)
    art.portraitBack:SetPoint("CENTER", art.ringCentre, "CENTER", 0, 0)

    -- Name box and its glow (clear edges of the glow hang out of the box).
    PlaceBox(art.nameBox, frame, d, NAME)
    if SetAtlasSafe(art.nameGlow, NAME_GLOW) then
        art.nameGlow:ClearAllPoints()
        art.nameGlow:SetPoint("TOPLEFT", art.nameBox, "TOPLEFT", -2 * d.s, 2 * d.s)
        art.nameGlow:SetPoint("BOTTOMRIGHT", art.nameBox, "BOTTOMRIGHT", 2 * d.s, -2 * d.s)
        art.nameGlow:SetTexCoord(d.flip and 1 or 0, d.flip and 0 or 1, 0, 1)
        art.nameGlow:Show()
    else
        art.nameGlow:Hide()
    end

    -- Level disc with the number and the skull on it.
    if SetAtlasSafe(art.disc, LEVEL_DISC) and PlaceAt(art.disc, art, d, d.blizz.level, nil, 0.94) then
        art.disc:Show()
        local w = art.disc:GetWidth() or 16
        art.level:ClearAllPoints()
        art.level:SetPoint("CENTER", art.disc, "CENTER", 0, 0)
        art.level:SetFont(LEVEL_FONT, math.max(7, math.floor(w * 0.45 + 0.5)), "")
        if SetAtlasSafe(art.skull, SKULL) then
            local info2 = AtlasInfo(SKULL)
            local k = w / ((AtlasInfo(LEVEL_DISC) or {}).width or w)
            art.skull:ClearAllPoints()
            art.skull:SetSize(info2.width * k, info2.height * k)
            art.skull:SetPoint("CENTER", art.disc, "CENTER", 0, 0)
        end
    else
        art.disc:Hide()
    end

    -- Player state pieces.
    if d.blizz.corner and SetAtlasSafe(art.corner, CORNER) then PlaceAt(art.corner, art, d, d.blizz.corner) end
    if d.blizz.attack and SetAtlasSafe(art.attack, SWORDS) then PlaceAt(art.attack, art, d, d.blizz.attack) end
    if d.blizz.quest and SetAtlasSafe(art.quest, QUEST_MARK) then PlaceAt(art.quest, art, d, d.blizz.quest) end
end

-- The engine's raid marker and leader crown, moved onto the ring.
local function LayoutIcons(frame, art, d)
    local h = frame.health
    if h.raidIcon and d.blizz.raid then
        local dx, dy, w = Place(d, d.blizz.raid)
        if dx then
            h.raidIcon:ClearAllPoints()
            h.raidIcon:SetSize(w, w)
            h.raidIcon:SetPoint("CENTER", art.ringCentre, "CENTER", dx, dy)
            h.raidIcon:SetParent(art.over)
            h.raidIcon:SetDrawLayer("OVERLAY", 3)
        end
    end
    if h.leaderIcon and d.blizz.leader and AtlasInfo(LEADER) then
        if not art.leaderTex then art.leaderTex = h.leaderIcon:GetTexture() or true end
        h.leaderIcon:SetAtlas(LEADER)
        local dx, dy, w, hh = Place(d, d.blizz.leader)
        if dx then
            h.leaderIcon:ClearAllPoints()
            h.leaderIcon:SetSize(w, hh)
            h.leaderIcon:SetPoint("CENTER", art.ringCentre, "CENTER", dx, dy)
            h.leaderIcon:SetParent(art.over)
            h.leaderIcon:SetDrawLayer("OVERLAY", 3)
        end
    end
end

-- The PvP crest: off the level disc, mirrored with it.
local function LayoutPvP(art, d)
    local e = d.blizz.pvp
    if not e then art.pvp:Hide() return end
    local lx, ly, lw = Place(d, d.blizz.level)
    if not lx then return end
    local side = d.flip and "LEFT" or "RIGHT"
    local sign = (side ~= d.blizz.side) and -1 or 1
    local x, y = lx + sign * e.dx * lw, ly + e.dy * lw
    local crest, disc = AtlasInfo(PVP_ICONS.Horde), AtlasInfo(LEVEL_DISC)
    if e.move and disc and disc.width and disc.width > 0 then
        local k = lw / disc.width
        local grow = (crest and crest.height and disc.height) and (crest.height - disc.height) * e.share / 2 or 0
        x = x + sign * e.move[1] * k
        y = y + (e.move[2] - grow) * k
    end
    art.pvp:ClearAllPoints()
    art.pvp:SetSize(lw * e.share, lw * e.share)
    art.pvp:SetPoint("CENTER", art.ringCentre, "CENTER", x, y)
end

function UF.ForeverArtSettings(unit, settings)
    local d = Dims(unit)
    if not d or not settings then return settings end
    local hasPower = (settings.powerHeight or 0) > 0
    local box = hasPower and HEALTH or HEALTH_FULL
    return setmetatable({
        width = d.width,
        healthHeight = (box[4] - box[3]) * d.s,
        powerHeight = hasPower and (POWER[4] - POWER[3]) * d.s or 0,
        infoBarHeight = 0,
    }, { __index = settings })
end

function UF.ForeverArtPre(frame, unit, settings)
    local d = Dims(unit)
    if not (frame and frame.health and d) then return 0 end
    local hasPower = (settings.powerHeight or 0) > 0 and frame.power
    local box = hasPower and HEALTH or HEALTH_FULL
    local l, r = Span(d, box[1], box[2])
    frame.health:ClearAllPoints()
    frame.health:SetPoint("TOPLEFT", frame, "TOPLEFT", l, FY(d, box[3]))
    frame.health:SetPoint("TOPRIGHT", frame, "TOPLEFT", r, FY(d, box[3]))
    local used = (settings.healthHeight or 0) + (hasPower and (settings.powerHeight or 0) or 0)
    return math.max(0, d.height - used)
end

function UF.ForeverArtPost(frame, unit, settings)
    local d = Dims(unit)
    if not (frame and frame.health and d) then return end
    local art = Build(frame)
    ShowArt(art, true)
    local uf = TomoModForeverDB.unitFrames
    local font = uf.fontFamily or uf.font or "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
    local outline = uf.fontOutline or "OUTLINE"

    LayoutPlate(frame, art, d)

    local hasPower = frame.power and (settings.powerHeight or 0) > 0
    local box = hasPower and HEALTH or HEALTH_FULL
    frame.health:SetHeight((box[4] - box[3]) * d.s)
    if frame.power then
        if hasPower then
            local l, r = Span(d, POWER[1], POWER[2])
            frame.power:ClearAllPoints()
            frame.power:SetPoint("TOPLEFT", frame, "TOPLEFT", l, FY(d, POWER[3]))
            frame.power:SetPoint("TOPRIGHT", frame, "TOPLEFT", r, FY(d, POWER[3]))
            frame.power:SetHeight((POWER[4] - POWER[3]) * d.s)
        end
        if frame.power.text then
            frame.power.text:ClearAllPoints()
            frame.power.text:SetPoint("CENTER", frame.power, "CENTER", 0, 0)
            frame.power.text:SetFont(font, math.max(7, math.min(math.floor(8 * d.s), 11)), outline)
        end
    end
    if frame.infoBar then frame.infoBar:Hide() end

    local name = frame.health.nameText
    if name then
        name:SetParent(art.nameBox)
        name:SetDrawLayer("OVERLAY", 7)
        name:ClearAllPoints()
        name:SetPoint("LEFT", art.nameBox, "LEFT", 3 * d.s, 0)
        name:SetPoint("RIGHT", art.nameBox, "RIGHT", -3 * d.s, 0)
        name:SetJustifyH("CENTER")
        name:SetWordWrap(false)
        name:SetFont(font, math.max(8, math.min(math.floor(9 * d.s + 0.5), 15)), outline)
        name:Show()
    end
    if frame.health.levelText then frame.health.levelText:SetAlpha(0) end
    if frame.health.text then
        frame.health.text:ClearAllPoints()
        frame.health.text:SetPoint("CENTER", frame.health, "CENTER", 0, 0)
        frame.health.text:SetFont(font, math.max(8, math.min(math.floor(9 * d.s + 0.5), 15)), outline)
    end

    LayoutIcons(frame, art, d)
    LayoutPvP(art, d)

    -- The ring hangs past the frame: the click area reaches over it, so a
    -- click on the portrait targets like on Blizzard's frames. Secure
    -- frame: out of combat only (ApplyVisuals already is).
    if frame.SetHitRectInsets and not InCombatLockdown() then
        local cx, cy, D = RingGeo(d)
        local over = math.max(0, math.ceil(d.flip and (D / 2 - cx) or (cx + D / 2 - d.width)))
        local below = math.max(0, math.ceil(-cy + D / 2 - d.height))
        local above = math.max(0, math.ceil(D / 2 + cy))
        if d.flip then
            frame:SetHitRectInsets(-over, 0, -above, -below)
        else
            frame:SetHitRectInsets(0, -over, -above, -below)
        end
        art.hitSet = true
    end
    art.dims = d
    art.portraitUnit = nil
    UF.ForeverArtUpdate(frame)
end

-- ---------------------------------------------------------------------
-- Update (any time: only setters, secret-safe)
-- ---------------------------------------------------------------------
local artFrames = {}   -- frames with the official skin, for the state events

local function AnimMode()
    local U = TomoMod_Utils
    if U and U.AnimFull and U.AnimFull() then return "full" end
    if U and U.AnimAny and U.AnimAny() then return "reduced" end
    return "none"
end

local function SetGlow(art, color)
    if color then
        for _, g in ipairs(art.glow) do
            g:SetVertexColor(color[1], color[2], color[3], 1)
            g:Show()
        end
        if AnimMode() == "full" then
            if not art.glowPulse:IsPlaying() then art.glowPulse:Play() end
        else
            art.glowPulse:Stop()
            art.glowFrame:SetAlpha(0.35)
        end
    else
        art.glowPulse:Stop()
        art.glowFrame:SetAlpha(1)
        for _, g in ipairs(art.glow) do g:Hide() end
    end
end

local function UpdatePlayerState(frame, art)
    local combat = Readable(UnitAffectingCombat("player"))
    local resting = not combat and Readable(IsResting and IsResting())
    local color
    local status = Readable(UnitThreatSituation and UnitThreatSituation("player"))
    if type(status) == "number" and status >= 2 and GetThreatStatusColor then
        local r, g, b = GetThreatStatusColor(status)
        if r then color = { r, g, b } end
    end
    if not color and combat then color = STATUS_FIGHT end
    if not color and resting then color = STATUS_REST end
    SetGlow(art, color)
    art.attack:SetShown(combat and AtlasInfo(SWORDS) and true or false)
    art.corner:SetShown(resting and AtlasInfo(CORNER) and true or false)
end

function UF.ForeverArtUpdate(frame)
    local art = frame and frame._fa
    if not (art and art.dims and UF.ForeverArtOn()) then return end
    local d = art.dims
    local unit = frame.unit or (frame.GetAttribute and frame:GetAttribute("unit"))
    if not unit then return end
    artFrames[frame] = true
    local exists = Readable(UnitExists(unit))
    if not exists then return end

    -- Name box tint: class colour for players, reaction for NPCs.
    local r, g, b = 0.55, 0.42, 0.25
    if Readable(UnitIsPlayer(unit)) then
        local _, class = UnitClass(unit)
        class = Readable(class)
        local c = class and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
        if c then r, g, b = c.r, c.g, c.b end
    else
        local reaction = Readable(UnitReaction(unit, "player"))
        local c = reaction and FACTION_BAR_COLORS and FACTION_BAR_COLORS[reaction]
        if c then r, g, b = c.r, c.g, c.b end
    end
    art.nameGlow:SetVertexColor(r, g, b, 1)

    local nameFS = frame.health.nameText
    if nameFS then
        local name = UnitName(unit)
        if name then nameFS:SetText(name) end
        nameFS:SetTextColor(YELLOW[1], YELLOW[2], YELLOW[3], 1)
        nameFS:Show()
    end

    -- Portrait (2D), refreshed when the unit behind the frame changes.
    local guid = Readable(UnitGUID(unit)) or unit
    if art.portraitUnit ~= guid and SetPortraitTexture then
        art.portraitUnit = guid
        pcall(SetPortraitTexture, art.portrait, unit)
    end

    -- Level on the disc; skull for a "??" target or focus.
    local level = UnitLevel(unit)
    local lv = Readable(level)
    local skull = lv and lv <= 0 and (d.kind == "target" or d.kind == "focus") and art.disc:IsShown() or false
    art.skull:SetShown(skull and true or false)
    if lv == nil then
        art.level:SetText(level or "")
        art.level:SetTextColor(1, 0.82, 0)
    elseif lv <= 0 then
        art.level:SetText(skull and "" or "??")
        art.level:SetTextColor(1, 0.25, 0.2)
    else
        art.level:SetFormattedText("%d", lv)
        if unit == "player" then
            art.level:SetTextColor(1, 1, 1)
        else
            local c = GetCreatureDifficultyColor and GetCreatureDifficultyColor(lv)
            if not c and GetQuestDifficultyColor then c = GetQuestDifficultyColor(lv) end
            if c then art.level:SetTextColor(c.r, c.g, c.b) else art.level:SetTextColor(1, 0.82, 0) end
        end
    end

    -- Elite / rare / boss dragon, as Forever picks it.
    art.boss:Hide()
    if d.blizz.boss and GetBossPortraitFrameData then
        local classification = Readable(UnitClassification(unit))
        local ok, atlas, ox, oy = pcall(GetBossPortraitFrameData, unit, classification)
        if ok and atlas and SetAtlasSafe(art.boss, atlas) then
            local e = { point = "TOPRIGHT", x = BLIZZ_FRAME_W + (ox or 0), y = oy or 0 }
            if PlaceAt(art.boss, art, d, e, atlas) then
                local side = d.flip and "LEFT" or "RIGHT"
                if side ~= d.blizz.side then art.boss:SetTexCoord(1, 0, 0, 1) else art.boss:SetTexCoord(0, 1, 0, 1) end
                art.boss:SetVertexColor(PLATE_TINT[1], PLATE_TINT[2], PLATE_TINT[3], 1)
                art.boss:Show()
            end
        end
    end

    -- Quest mark: a quest boss, or a hostile unit tied to an active quest.
    if d.blizz.quest then
        local show = UnitIsQuestBoss and Readable(UnitIsQuestBoss(unit)) == true or false
        if not show and Readable(UnitCanAttack("player", unit)) and C_QuestLog and C_QuestLog.UnitIsRelatedToActiveQuest then
            local ok, related = pcall(C_QuestLog.UnitIsRelatedToActiveQuest, unit)
            show = ok and Readable(related) == true or false
        end
        art.quest:SetShown(show and AtlasInfo(QUEST_MARK) and not art.boss:IsShown() and true or false)
    end

    -- PvP crest.
    if d.blizz.pvp then
        local atlas
        if Readable(UnitIsPVPFreeForAll(unit)) then
            atlas = PVP_ICONS.FFA
        elseif Readable(UnitIsPVP(unit)) then
            atlas = PVP_ICONS[Readable(UnitFactionGroup(unit)) or ""]
        end
        if atlas and SetAtlasSafe(art.pvp, atlas) then art.pvp:Show() else art.pvp:Hide() end
    end

    if d.kind == "player" then UpdatePlayerState(frame, art) end
end

-- State events: combat, resting, threat, classification, PvP, quests.
local ev = CreateFrame("Frame")
for _, e in ipairs({ "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "PLAYER_UPDATE_RESTING",
                     "UNIT_CLASSIFICATION_CHANGED", "UNIT_FACTION", "PLAYER_FLAGS_CHANGED",
                     "QUEST_LOG_UPDATE", "UNIT_PORTRAIT_UPDATE", "UNIT_MODEL_CHANGED", "UNIT_LEVEL" }) do
    pcall(ev.RegisterEvent, ev, e)
end
pcall(ev.RegisterUnitEvent, ev, "UNIT_THREAT_SITUATION_UPDATE", "player")
ev:SetScript("OnEvent", function(_, event, unit)
    if not UF.ForeverArtOn() then return end
    for frame in pairs(artFrames) do
        local art = frame._fa
        if art and art.holder:IsShown() then
            if event == "UNIT_PORTRAIT_UPDATE" or event == "UNIT_MODEL_CHANGED" then
                local fu = frame.unit
                if not unit or (fu and Readable(UnitIsUnit(fu, unit))) then art.portraitUnit = nil end
            end
            UF.ForeverArtUpdate(frame)
        end
    end
end)
