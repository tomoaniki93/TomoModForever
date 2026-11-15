-- =====================================================================
-- Units/ForeverStyle.lua -- "Forever" look for the unit frames (1.2.9)
--
-- A second look, chosen in Frames > Shared style (unitFrames.style =
-- "forever"; "tmf" is the default look). Same engine and bars, but its
-- OWN compact sizes (the TMF sizes stay untouched for the TMF look):
--
--   +==================================+  gold border, bronze outside,
--   |  .--------- Name strip -------.  |  dark background showing between
--   |  |        health  2.0k / 2.0k  |  |  the rows (no separators needed)
--   |  |        power   0 / 100      |  |
--   +==================================+
--   (18)  level medallion against the frame: left of the player, right of
--         the target / focus (none on target of target and pet)
--
--   player / target / focus : 170 x 48   (strip 14, health 16, power 9)
--   target of target / pet  : 110 x 34   (strip 12, health 10, power 4)
--
-- The strip is in the class colour (players) or reaction colour (NPCs),
-- darkened, the name in gold. Health text "current / max", power text on
-- its bar. The info bar of the TMF look is hidden. No portrait.
--
-- Hooks, all in UnitFrame.lua:
--   UF.ForeverSettings(unit, settings) -- start of ApplyVisuals: the compact
--       sizes, read through to the unit's settings for everything else.
--   UF.ForeverPre(frame, unit, settings) -- before the AstralForge registry:
--       anchors the health bar inside the frame, returns the extra height.
--   UF.ForeverPost(frame, unit, settings) -- after the registry: strip,
--       texts, power bar, border, medallion.
--   UF.ForeverUpdate(frame) -- from UpdateName / UpdateLevel: strip colour,
--       name and level (only handed to SetText: secret-safe).
-- Switching look needs no /reload (out of combat, like every ApplyVisuals).
--
-- Portrait (option unitFrames.foreverPortrait, off): a round 2D portrait
-- (SetPortraitTexture) in a bronze and gold ring, against the frame on the
-- medallion side (player, target, focus); the level medallion then sits on
-- the portrait's lower outer edge. Refreshed on UNIT_PORTRAIT_UPDATE,
-- UNIT_MODEL_CHANGED, target / focus change.
-- =====================================================================

TomoMod_UnitFrames = TomoMod_UnitFrames or {}
local UF = TomoMod_UnitFrames

local SOLID  = "Interface\\Buttons\\WHITE8x8"
local MASK   = "Interface\\CHARACTERFRAME\\TempPortraitAlphaMask"
local BRONZE = { 0.545, 0.420, 0.247 }
local GOLD   = { 0.788, 0.635, 0.322 }
local YELLOW = { 1.000, 0.820, 0.000 }

local INSET = 3     -- 1px gold border + 2px dark padding
local GAP   = 2     -- dark gap between strip, health and power

-- Default sizes; each can be changed in Frames > Shared style when the
-- Forever look is chosen (unitFrames.foreverSizes[unit] = { width, name,
-- health, power }). Fonts follow the strip and health heights.
local DEFAULTS = {
    player       = { width = 170, name = 14, health = 16, power = 9, badge = "LEFT" },
    target       = { width = 170, name = 14, health = 16, power = 9, badge = "RIGHT" },
    focus        = { width = 170, name = 14, health = 16, power = 9, badge = "RIGHT" },
    targettarget = { width = 110, name = 12, health = 10, power = 4 },
    focustarget  = { width = 110, name = 12, health = 10, power = 4 },
    pet          = { width = 110, name = 12, health = 10, power = 4 },
}
UF.FOREVER_DEFAULT_SIZES = DEFAULTS

local function Clamp(v, lo, hi) return math.max(lo, math.min(hi, v)) end

-- Sizes of a unit: the saved ones over the defaults.
local function Dims(unit)
    local base = DEFAULTS[unit]
    if not base then return nil end
    local uf = TomoModForeverDB and TomoModForeverDB.unitFrames
    local saved = uf and type(uf.foreverSizes) == "table" and uf.foreverSizes[unit]
    local d = {
        width  = tonumber(saved and saved.width)  or base.width,
        name   = tonumber(saved and saved.name)   or base.name,
        health = tonumber(saved and saved.health) or base.health,
        power  = tonumber(saved and saved.power)  or base.power,
        badge  = base.badge,
    }
    d.font   = Clamp(math.floor(d.name - 3 + 0.5), 8, 16)
    d.hpFont = Clamp(math.floor(d.health * 0.6 + 0.5), 8, 16)
    return d
end

local function IsSecret(v)
    return type(issecretvalue) == "function" and issecretvalue(v) == true
end

function UF.IsForeverStyle()
    local uf = TomoModForeverDB and TomoModForeverDB.unitFrames
    return uf and uf.style == "forever" or false
end

local function PortraitOn()
    local uf = TomoModForeverDB and TomoModForeverDB.unitFrames
    return uf and uf.style == "forever" and uf.foreverPortrait == true or false
end

local PORTRAIT = 52                 -- diameter, a little taller than the frame
local portraitFrames = {}           -- [frame] = true, frames carrying a portrait

local function RefreshPortrait(frame)
    local fv = frame and frame._fv
    local p = fv and fv.portrait
    if not (p and p:IsShown()) then return end
    local unit = frame.unit or (frame.GetAttribute and frame:GetAttribute("unit"))
    if unit and UnitExists(unit) and SetPortraitTexture then
        pcall(SetPortraitTexture, p.tex, unit)
    end
end

local portraitEvents = CreateFrame("Frame")
portraitEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
pcall(portraitEvents.RegisterEvent, portraitEvents, "PLAYER_FOCUS_CHANGED")
pcall(portraitEvents.RegisterEvent, portraitEvents, "UNIT_PORTRAIT_UPDATE")
pcall(portraitEvents.RegisterEvent, portraitEvents, "UNIT_MODEL_CHANGED")
portraitEvents:SetScript("OnEvent", function(_, event, unit)
    if not PortraitOn() then return end
    for frame in pairs(portraitFrames) do
        local fu = frame.unit
        if event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_FOCUS_CHANGED"
           or not unit or (fu and UnitIsUnit and pcall(UnitIsUnit, fu, unit) and UnitIsUnit(fu, unit)) then
            RefreshPortrait(frame)
        end
    end
end)

-- The compact sizes, everything else read from the unit's own settings.
-- A unit whose power bar is switched off keeps it off.
function UF.ForeverSettings(unit, settings)
    local d = Dims(unit)
    if not d or not settings then return settings end
    local power = ((settings.powerHeight or 0) > 0) and d.power or 0
    return setmetatable({
        width = d.width,
        healthHeight = d.health,
        powerHeight = power,
        infoBarHeight = 0,
    }, { __index = settings })
end

function UF.ForeverPowerText(frame)
    return UF.IsForeverStyle() and frame and frame.power and (frame.power:GetHeight() or 0) >= 8
end

-- ---------------------------------------------------------------------
-- Widgets (built once per frame, on first use)
-- ---------------------------------------------------------------------
local function Tex(parent, layer, sub, r, g, b, a)
    local t = parent:CreateTexture(nil, layer, nil, sub or 0)
    t:SetTexture(SOLID)
    t:SetVertexColor(r, g, b, a or 1)
    return t
end

-- Four edges, `out` px outside the frame (negative = inside), `size` thick.
local function Ring(holder, frame, out, size, color, sub)
    local e = {}
    for i = 1, 4 do e[i] = Tex(holder, "OVERLAY", sub, color[1], color[2], color[3], 1) end
    e[1]:SetPoint("TOPLEFT", frame, "TOPLEFT", -out, out);        e[1]:SetPoint("TOPRIGHT", frame, "TOPRIGHT", out, out);        e[1]:SetHeight(size)
    e[2]:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -out, -out); e[2]:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", out, -out); e[2]:SetHeight(size)
    e[3]:SetPoint("TOPLEFT", frame, "TOPLEFT", -out, out);        e[3]:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -out, -out);  e[3]:SetWidth(size)
    e[4]:SetPoint("TOPRIGHT", frame, "TOPRIGHT", out, out);       e[4]:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", out, -out); e[4]:SetWidth(size)
    return e
end

local function Build(frame, unit)
    if frame._fv then return frame._fv end
    local fv = {}
    local lvl = frame.health:GetFrameLevel()

    -- Dark background behind the bars (shows in the padding and gaps).
    local back = CreateFrame("Frame", nil, frame)
    back:SetAllPoints(frame)
    back:EnableMouse(false)
    back:SetFrameLevel(math.max(0, lvl - 1))
    Tex(back, "BACKGROUND", -7, 0.055, 0.045, 0.035, 0.94):SetAllPoints()
    fv.back = back

    -- Name strip.
    local strip = CreateFrame("Frame", nil, frame)
    strip:EnableMouse(false)
    strip:SetFrameLevel(lvl + 2)
    fv.stripBg = Tex(strip, "BACKGROUND", 0, BRONZE[1], BRONZE[2], BRONZE[3], 1)
    fv.stripBg:SetAllPoints()
    -- Soft vertical shade (darker at the bottom) so the gold name reads on
    -- any class colour. A smooth gradient over the whole strip: the hard
    -- half-height shade of the first version cut the strip in two bands.
    local shade = strip:CreateTexture(nil, "BORDER")
    shade:SetAllPoints()
    shade:SetTexture(SOLID)
    if CreateColor and shade.SetGradient then
        shade:SetVertexColor(1, 1, 1, 1)
        local ok = pcall(shade.SetGradient, shade, "VERTICAL", CreateColor(0, 0, 0, 0.35), CreateColor(0, 0, 0, 0))
        if not ok then shade:Hide() end
    else
        shade:Hide()
    end
    fv.stripShade = shade
    -- 1px light line along the top: a touch of relief, like the classic frames.
    local shine = Tex(strip, "BORDER", 1, 1, 1, 1, 0.10)
    shine:SetPoint("TOPLEFT"); shine:SetPoint("TOPRIGHT"); shine:SetHeight(1)
    fv.strip = strip

    -- Border above the bars: gold on the frame edge, bronze just outside.
    local deco = CreateFrame("Frame", nil, frame)
    deco:SetAllPoints(frame)
    deco:EnableMouse(false)
    deco:SetFrameLevel(lvl + 6)
    fv.gold = Ring(deco, frame, 0, 1, GOLD, 1)
    fv.bronze = Ring(deco, frame, 1, 1, BRONZE, 0)
    fv.deco = deco

    -- Level medallion, against the frame.
    local d = Dims(unit)
    if d and d.badge then
        local badge = CreateFrame("Frame", nil, frame)
        badge:SetSize(24, 24)
        badge:EnableMouse(false)
        badge:SetFrameLevel(lvl + 7)
        local ring = badge:CreateTexture(nil, "BACKGROUND")
        ring:SetAllPoints(); ring:SetTexture(MASK)
        ring:SetVertexColor(BRONZE[1], BRONZE[2], BRONZE[3], 1)
        local gold = badge:CreateTexture(nil, "BORDER")
        gold:SetPoint("TOPLEFT", 1.5, -1.5); gold:SetPoint("BOTTOMRIGHT", -1.5, 1.5); gold:SetTexture(MASK)
        gold:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 1)
        local disc = badge:CreateTexture(nil, "ARTWORK")
        disc:SetPoint("TOPLEFT", 3, -3); disc:SetPoint("BOTTOMRIGHT", -3, 3); disc:SetTexture(MASK)
        disc:SetVertexColor(0.07, 0.06, 0.045, 1)
        badge.text = badge:CreateFontString(nil, "OVERLAY")
        badge.text:SetPoint("CENTER", 0, 0)
        fv.badge = badge

        -- Round portrait (option), under the medallion.
        local p = CreateFrame("Frame", nil, frame)
        p:SetSize(PORTRAIT, PORTRAIT)
        p:EnableMouse(false)
        p:SetFrameLevel(lvl + 6)
        local pr = p:CreateTexture(nil, "BACKGROUND")
        pr:SetAllPoints(); pr:SetTexture(MASK)
        pr:SetVertexColor(BRONZE[1], BRONZE[2], BRONZE[3], 1)
        local pg = p:CreateTexture(nil, "BORDER")
        pg:SetPoint("TOPLEFT", 1.5, -1.5); pg:SetPoint("BOTTOMRIGHT", -1.5, 1.5); pg:SetTexture(MASK)
        pg:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 1)
        local pd = p:CreateTexture(nil, "ARTWORK", nil, -1)
        pd:SetPoint("TOPLEFT", 3, -3); pd:SetPoint("BOTTOMRIGHT", -3, 3); pd:SetTexture(MASK)
        pd:SetVertexColor(0.07, 0.06, 0.045, 1)
        p.tex = p:CreateTexture(nil, "ARTWORK", nil, 1)
        p.tex:SetPoint("TOPLEFT", 3, -3); p.tex:SetPoint("BOTTOMRIGHT", -3, 3)
        p:Hide()
        fv.portrait = p
    end

    frame._fv = fv
    return fv
end

local function ShowAll(fv, on)
    fv.back:SetShown(on)
    fv.strip:SetShown(on)
    fv.deco:SetShown(on)
    if fv.badge then fv.badge:SetShown(on) end
    if fv.portrait and not on then fv.portrait:Hide() end
end

local function HasPower(frame)
    return frame.power and frame.power:IsShown() and (frame.power:GetHeight() or 0) > 0
end

-- ---------------------------------------------------------------------
-- Hooks
-- ---------------------------------------------------------------------
function UF.ForeverPre(frame, unit, settings)
    if not (frame and frame.health) then return 0 end
    local d = Dims(unit)
    frame.health:ClearAllPoints()
    if not (UF.IsForeverStyle() and d) then
        frame.health:SetPoint("TOP", frame, "TOP", 0, 0)
        if frame._fv then
            ShowAll(frame._fv, false)
            -- Hand name and level back to the health bar (the registry
            -- anchors them next) and bring the info bar back.
            if frame.health.nameText then frame.health.nameText:SetParent(frame.health) end
            if frame.health.levelText then frame.health.levelText:SetAlpha(1) end
            if frame.infoBar then frame.infoBar:Show() end
        end
        return 0
    end
    -- Health inside the border, under the strip.
    local top = INSET + d.name + GAP
    frame.health:SetPoint("TOPLEFT", frame, "TOPLEFT", INSET, -top)
    frame.health:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -INSET, -top)
    local power = (settings.powerHeight or 0) > 0 and frame.power
    return top + (power and GAP or 0) + INSET
end

function UF.ForeverPost(frame, unit, settings)
    local d = Dims(unit)
    if not (frame and frame.health and d and UF.IsForeverStyle()) then return end
    local fv = Build(frame, unit)
    ShowAll(fv, true)
    local uf = TomoModForeverDB.unitFrames
    local font = uf.fontFamily or uf.font or "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
    local outline = uf.fontOutline or "OUTLINE"

    -- Strip.
    fv.strip:ClearAllPoints()
    fv.strip:SetPoint("TOPLEFT", frame, "TOPLEFT", INSET, -INSET)
    fv.strip:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -INSET, -INSET)
    fv.strip:SetHeight(d.name)

    -- Health keeps its anchors from ForeverPre; height from the settings.
    frame.health:SetHeight(d.health)

    -- Power under the health bar, same width.
    if frame.power then
        frame.power:ClearAllPoints()
        frame.power:SetPoint("TOPLEFT", frame.health, "BOTTOMLEFT", 0, -GAP)
        frame.power:SetPoint("TOPRIGHT", frame.health, "BOTTOMRIGHT", 0, -GAP)
        if frame.power.text then
            frame.power.text:ClearAllPoints()
            frame.power.text:SetPoint("CENTER", frame.power, "CENTER", 0, 0)
            frame.power.text:SetFont(font, math.max(7, math.min(d.power - 1, 9)), outline)
        end
    end
    if frame.infoBar then frame.infoBar:Hide() end

    -- Name in the strip, centred, gold.
    local name = frame.health.nameText
    if name then
        name:SetParent(fv.strip)
        name:SetDrawLayer("OVERLAY", 7)
        name:ClearAllPoints()
        name:SetPoint("LEFT", fv.strip, "LEFT", 4, 0)
        name:SetPoint("RIGHT", fv.strip, "RIGHT", -4, 0)
        name:SetJustifyH("CENTER")
        name:SetWordWrap(false)
        name:SetFont(font, d.font, outline)
        name:Show()
    end
    if frame.health.levelText then frame.health.levelText:SetAlpha(0) end

    -- Health text centred.
    if frame.health.text then
        frame.health.text:ClearAllPoints()
        frame.health.text:SetPoint("CENTER", frame.health, "CENTER", 0, 0)
        frame.health.text:SetFont(font, d.hpFont, outline)
    end

    -- Portrait (option) against the frame, the medallion on its lower
    -- outer edge; without it, the medallion half over the frame edge.
    local left = d.badge == "LEFT"
    if fv.portrait then
        if PortraitOn() then
            fv.portrait:ClearAllPoints()
            local x = PORTRAIT / 2 - 4
            fv.portrait:SetPoint("CENTER", frame, left and "LEFT" or "RIGHT", left and -x or x, 0)
            fv.portrait:Show()
            portraitFrames[frame] = true
            RefreshPortrait(frame)
        else
            fv.portrait:Hide()
            portraitFrames[frame] = nil
        end
    end
    if fv.badge then
        fv.badge:ClearAllPoints()
        if fv.portrait and fv.portrait:IsShown() then
            fv.badge:SetSize(22, 22)
            fv.badge:SetPoint("CENTER", fv.portrait, left and "BOTTOMLEFT" or "BOTTOMRIGHT", left and 6 or -6, 6)
        else
            fv.badge:SetSize(24, 24)
            fv.badge:SetPoint("CENTER", frame, left and "LEFT" or "RIGHT", left and -6 or 6, 0)
        end
        fv.badge.text:SetFont(font, 10, outline)
    end

    UF.ForeverUpdate(frame)
end

-- Strip colour, name and level, on every name refresh (target change...).
function UF.ForeverUpdate(frame)
    local fv = frame and frame._fv
    if not (fv and UF.IsForeverStyle()) then return end
    local unit = frame.unit or (frame.GetAttribute and frame:GetAttribute("unit"))
    if not unit or not UnitExists(unit) then return end

    -- Players: class colour. NPCs: reaction colour. Secret / unknown: bronze.
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
    fv.stripBg:SetVertexColor(r * 0.45, g * 0.45, b * 0.45, 1)

    -- The name always shows in this look (the strip is made for it).
    local nameFS = frame.health.nameText
    if nameFS then
        local name = UnitName(unit)
        if name then nameFS:SetText(name) end
        nameFS:SetTextColor(YELLOW[1], YELLOW[2], YELLOW[3], 1)
        nameFS:Show()
    end

    RefreshPortrait(frame)

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
