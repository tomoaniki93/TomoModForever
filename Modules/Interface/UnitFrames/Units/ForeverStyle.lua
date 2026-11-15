-- =====================================================================
-- Units/ForeverStyle.lua -- "Forever" look for the unit frames (1.2.9)
--
-- A second look, chosen in Frames > Shared style (unitFrames.style =
-- "forever"; "tmf" is the default look). Same engine, same bars, same
-- settings: this file only dresses the frames built by UnitFrame.lua.
--
--   +------------------------------+
--   |          Name strip          |   class colour (players) or
--   +------------------------------+   reaction colour (NPCs), name in gold
--   |        health  2.0k/2.0k     |   health text centred
--   +------------------------------+
--   |        power   0/100         |   power text centred
--   +------------------------------+
--   (40)  level medallion outside the frame: left of the player, right of
--         the target / focus (none on the small target-of-target and pet)
--
-- Bronze and gold border around the whole frame, gold separators between
-- the rows. No portrait.
--
-- Hooks, all in UnitFrame.lua:
--   UF.ForeverPre(frame, unit, settings)  -- in ApplyVisuals, BEFORE the
--       AstralForge registry: makes room for the strip (health moves down,
--       frame height grows) or gives it back in the TMF look. Returns the
--       extra height.
--   UF.ForeverPost(frame, unit, settings) -- after the registry: puts the
--       name in the strip, centres the texts, draws border and medallion.
--   UF.ForeverUpdate(frame)               -- from UpdateName: strip colour,
--       level. Name and level are only handed to SetText (secret-safe).
-- Switching look needs no /reload (out of combat, like every ApplyVisuals).
-- =====================================================================

TomoMod_UnitFrames = TomoMod_UnitFrames or {}
local UF = TomoMod_UnitFrames

local SOLID  = "Interface\\Buttons\\WHITE8x8"
local MASK   = "Interface\\CHARACTERFRAME\\TempPortraitAlphaMask"
local U      = TomoMod_Utils or {}
local BRONZE = U.BRONZE or { 0.545, 0.420, 0.247 }
local GOLD   = { 0.788, 0.635, 0.322 }
local YELLOW = { 1.000, 0.820, 0.000 }

local SMALL = { targettarget = true, pet = true, focustarget = true }
local BADGE_SIDE = { player = "LEFT", target = "RIGHT", focus = "RIGHT" }

local function IsSecret(v)
    return type(issecretvalue) == "function" and issecretvalue(v) == true
end

function UF.IsForeverStyle()
    local uf = TomoModForeverDB and TomoModForeverDB.unitFrames
    return uf and uf.style == "forever" or false
end

local function StripHeight(unit)
    return SMALL[unit] and 13 or 17
end

-- ---------------------------------------------------------------------
-- Widgets (built once per frame, on first use)
-- ---------------------------------------------------------------------
local function Edge(parent, layer, r, g, b, a)
    local t = parent:CreateTexture(nil, layer)
    t:SetTexture(SOLID)
    t:SetVertexColor(r, g, b, a or 1)
    return t
end

-- Four edges of a rectangle around `frame`, `out` pixels outside, `size` thick.
local function Ring(holder, frame, out, size, color, sub)
    local e = {}
    for i = 1, 4 do e[i] = Edge(holder, "OVERLAY", color[1], color[2], color[3], 1); e[i]:SetDrawLayer("OVERLAY", sub or 0) end
    e[1]:SetPoint("TOPLEFT", frame, "TOPLEFT", -out, out);        e[1]:SetPoint("TOPRIGHT", frame, "TOPRIGHT", out, out);        e[1]:SetHeight(size)
    e[2]:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -out, -out); e[2]:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", out, -out); e[2]:SetHeight(size)
    e[3]:SetPoint("TOPLEFT", frame, "TOPLEFT", -out, out);        e[3]:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -out, -out);  e[3]:SetWidth(size)
    e[4]:SetPoint("TOPRIGHT", frame, "TOPRIGHT", out, out);       e[4]:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", out, -out); e[4]:SetWidth(size)
    return e
end

local function Build(frame, unit)
    if frame._fv then return frame._fv end
    local fv = {}

    -- Name strip, above the health bar, inside the (grown) frame.
    local strip = CreateFrame("Frame", nil, frame)
    strip:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    strip:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    strip:EnableMouse(false)
    strip:SetFrameLevel(frame.health:GetFrameLevel() + 2)
    fv.stripBg = Edge(strip, "BACKGROUND", BRONZE[1], BRONZE[2], BRONZE[3], 1)
    fv.stripBg:SetAllPoints()
    -- Soft shade on the lower half, so the gold name reads on any colour.
    fv.stripShade = Edge(strip, "BORDER", 0, 0, 0, 0.35)
    fv.stripShade:SetPoint("BOTTOMLEFT"); fv.stripShade:SetPoint("BOTTOMRIGHT")
    fv.stripShade:SetPoint("TOP", strip, "CENTER", 0, 0)
    fv.strip = strip

    -- Border + separators, above the bars.
    local deco = CreateFrame("Frame", nil, frame)
    deco:SetAllPoints(frame)
    deco:EnableMouse(false)
    deco:SetFrameLevel(frame.health:GetFrameLevel() + 6)
    fv.outer = Ring(deco, frame, 3, 2, BRONZE, 0)
    fv.inner = Ring(deco, frame, 1, 1, GOLD, 1)
    fv.sepName = Edge(deco, "OVERLAY", GOLD[1], GOLD[2], GOLD[3], 0.9)
    fv.sepName:SetHeight(1)
    fv.sepPower = Edge(deco, "OVERLAY", GOLD[1], GOLD[2], GOLD[3], 0.9)
    fv.sepPower:SetHeight(1)
    fv.deco = deco

    -- Level medallion (player / target / focus).
    if BADGE_SIDE[unit] then
        local badge = CreateFrame("Frame", nil, frame)
        badge:SetSize(26, 26)
        badge:EnableMouse(false)
        badge:SetFrameLevel(frame.health:GetFrameLevel() + 7)
        local ring = badge:CreateTexture(nil, "BACKGROUND")
        ring:SetAllPoints(); ring:SetTexture(MASK)
        ring:SetVertexColor(BRONZE[1], BRONZE[2], BRONZE[3], 1)
        local gold = badge:CreateTexture(nil, "BORDER")
        gold:SetPoint("TOPLEFT", 2, -2); gold:SetPoint("BOTTOMRIGHT", -2, 2); gold:SetTexture(MASK)
        gold:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 1)
        local disc = badge:CreateTexture(nil, "ARTWORK")
        disc:SetPoint("TOPLEFT", 3, -3); disc:SetPoint("BOTTOMRIGHT", -3, 3); disc:SetTexture(MASK)
        disc:SetVertexColor(0.07, 0.06, 0.045, 1)
        local text = badge:CreateFontString(nil, "OVERLAY")
        text:SetPoint("CENTER", 0, 0)
        badge.text = text
        fv.badge = badge
    end

    frame._fv = fv
    return fv
end

local function ShowAll(fv, on)
    fv.strip:SetShown(on)
    fv.deco:SetShown(on)
    if fv.badge then fv.badge:SetShown(on) end
end

-- ---------------------------------------------------------------------
-- Hooks
-- ---------------------------------------------------------------------
function UF.ForeverPre(frame, unit, settings)
    if not (frame and frame.health) then return 0 end
    local on = UF.IsForeverStyle()
    frame.health:ClearAllPoints()
    if not on then
        frame.health:SetPoint("TOP", frame, "TOP", 0, 0)
        if frame._fv then
            ShowAll(frame._fv, false)
            -- Hand the name and level back to the health bar: the registry
            -- anchors them next.
            if frame.health.nameText then frame.health.nameText:SetParent(frame.health) end
            if frame.health.levelText then frame.health.levelText:SetAlpha(1) end
        end
        return 0
    end
    local h = StripHeight(unit)
    frame.health:SetPoint("TOP", frame, "TOP", 0, -h)
    return h
end

function UF.ForeverPost(frame, unit, settings)
    if not (frame and frame.health and UF.IsForeverStyle()) then return end
    local fv = Build(frame, unit)
    ShowAll(fv, true)
    local uf = TomoModForeverDB.unitFrames
    local font = uf.fontFamily or uf.font or "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
    local size = uf.fontSize or 12
    local outline = uf.fontOutline or "OUTLINE"
    local h = StripHeight(unit)

    fv.strip:SetHeight(h)

    -- Name: in the strip, centred, gold.
    local name = frame.health.nameText
    if name then
        name:SetParent(fv.strip)
        name:SetDrawLayer("OVERLAY", 7)
        name:ClearAllPoints()
        name:SetPoint("CENTER", fv.strip, "CENTER", 0, 0)
        name:SetJustifyH("CENTER")
        name:SetFont(font, SMALL[unit] and math.max(8, size - 3) or size - 1, outline)
    end
    -- Level: shown on the medallion instead.
    if frame.health.levelText then frame.health.levelText:SetAlpha(0) end

    -- Health and power texts centred on their bars.
    if frame.health.text then
        frame.health.text:ClearAllPoints()
        frame.health.text:SetPoint("CENTER", frame.health, "CENTER", 0, 0)
    end
    if frame.power and frame.power.text then
        frame.power.text:ClearAllPoints()
        frame.power.text:SetPoint("CENTER", frame.power, "CENTER", 0, 0)
    end

    -- Separators: under the strip, and between health and power.
    fv.sepName:ClearAllPoints()
    fv.sepName:SetPoint("TOPLEFT", frame.health, "TOPLEFT", 0, 0)
    fv.sepName:SetPoint("TOPRIGHT", frame.health, "TOPRIGHT", 0, 0)
    fv.sepPower:ClearAllPoints()
    if frame.power and frame.power:IsShown() then
        fv.sepPower:SetPoint("TOPLEFT", frame.power, "TOPLEFT", 0, 0)
        fv.sepPower:SetPoint("TOPRIGHT", frame.power, "TOPRIGHT", 0, 0)
        fv.sepPower:Show()
    else
        fv.sepPower:Hide()
    end

    -- Medallion, outside the frame, on the strip + health block.
    if fv.badge then
        fv.badge:ClearAllPoints()
        if BADGE_SIDE[unit] == "LEFT" then
            fv.badge:SetPoint("RIGHT", frame, "LEFT", -5, 0)
        else
            fv.badge:SetPoint("LEFT", frame, "RIGHT", 5, 0)
        end
        fv.badge.text:SetFont(font, math.max(9, size - 1), outline)
    end

    UF.ForeverUpdate(frame)
end

-- Strip colour and level, on every name refresh (target change, etc.).
function UF.ForeverUpdate(frame)
    local fv = frame and frame._fv
    if not (fv and UF.IsForeverStyle()) then return end
    local unit = frame.unit or (frame.GetAttribute and frame:GetAttribute("unit"))
    if not unit or not UnitExists(unit) then return end

    -- Players: class colour. NPCs: reaction colour. Secret or unknown: bronze.
    local r, g, b = BRONZE[1], BRONZE[2], BRONZE[3]
    if UnitIsPlayer(unit) then
        local _, class = UnitClass(unit)
        local c = class and not IsSecret(class) and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
        if c then r, g, b = c.r, c.g, c.b end
    else
        local reaction = UnitReaction(unit, "player")
        local c = reaction and not IsSecret(reaction) and FACTION_BAR_COLORS and FACTION_BAR_COLORS[reaction]
        if c then r, g, b = c.r, c.g, c.b end
    end
    -- Toned down so it matches the bronze border and the gold text reads.
    fv.stripBg:SetVertexColor(r * 0.62, g * 0.62, b * 0.62, 1)
    if frame.health.nameText then frame.health.nameText:SetTextColor(YELLOW[1], YELLOW[2], YELLOW[3], 1) end

    if fv.badge then
        local level = UnitLevel(unit)
        local text = fv.badge.text
        if level == nil or IsSecret(level) then
            text:SetText(level or "")
            text:SetTextColor(YELLOW[1], YELLOW[2], YELLOW[3])
        elseif level <= 0 then
            text:SetText("??")
            text:SetTextColor(1, 0.25, 0.2)
        else
            text:SetFormattedText("%d", level)
            local c = unit ~= "player" and GetCreatureDifficultyColor and GetCreatureDifficultyColor(level)
            if not c and unit ~= "player" and GetQuestDifficultyColor then c = GetQuestDifficultyColor(level) end
            if c then text:SetTextColor(c.r, c.g, c.b) else text:SetTextColor(YELLOW[1], YELLOW[2], YELLOW[3]) end
        end
    end
end
