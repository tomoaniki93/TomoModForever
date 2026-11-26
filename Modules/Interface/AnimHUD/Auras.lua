-- =====================================================================
-- AnimHUD / Auras.lua -- buffs and debuffs, for you and your target
-- (from Braise; the TMF player and target frames are hidden in this look,
-- so their auras live here)
--
--        your debuffs  |  halo  |  target debuffs
--        your buffs    |        |  target buffs
--
-- Yours sit to the left of the halo and grow leftward; the target's sit to
-- the right and grow rightward. Debuffs are larger and glow in their
-- dispel colour.
--
-- Addon code may not read auras in combat on this client, so nothing here
-- does. Each block is a container built by TomoMod_AuraContainer, the same
-- builder as the TMF unit frames, nameplates and group frames: we declare
-- a unit, a filter and a look, the client scans, sorts, lays out and
-- updates the buttons itself.
-- (Braise builds its own containers; in TMF that path built nothing on the
-- first in-game test, while TMF's builder is proven on the same client.)
-- =====================================================================

local B = TomoMod_AnimHUD
local Auras = B.Module("Auras")
local T = B.T

-- Room between icons: the remaining time ("47 m") is wider than a small
-- icon and spilled over its neighbours with 2.
local GAP = 5

-- side: -1 left of the halo (grows left), 1 right of it (grows right).
-- x, y: the block's top inner corner, from the centre of the halo.
local SPECS = {
    { key = "pDebuff", unit = "player", filter = "HARMFUL", size = 30, max = 10, perRow = 5,
      side = -1, x = -250, y = 112, option = "auraPlayer", fr = "Tes débuffs", en = "Your debuffs" },
    { key = "pBuff",   unit = "player", filter = "HELPFUL", size = 26, max = 12, perRow = 6,
      side = -1, x = -250, y = 46,  option = "auraPlayer", fr = "Tes buffs", en = "Your buffs" },
    { key = "tDebuff", unit = "target", filter = "HARMFUL", size = 30, max = 10, perRow = 5,
      side = 1,  x = 250,  y = 112, option = "auraTarget", fr = "Débuffs de la cible", en = "Target debuffs" },
    { key = "tBuff",   unit = "target", filter = "HELPFUL", size = 26, max = 12, perRow = 6,
      side = 1,  x = 250,  y = 46,  option = "auraTarget", fr = "Buffs de la cible", en = "Target buffs" },
}

local AC = TomoMod_AuraContainer

local function Available()
    return AC ~= nil and AC.IsAvailable() and true or false
end

--- Dark backdrop behind each icon, like Braise's buttons. Called by the
--- builder before the client registers anything on the button.
local function Backdrop(button)
    local back = button:CreateTexture(nil, "BACKGROUND")
    back:SetAllPoints()
    back:SetColorTexture(0, 0, 0, 0.85)
end

-- ---------------------------------------------------------------------
-- Blocks
-- ---------------------------------------------------------------------
local blocks = {}

local function Place(block)
    local s = block.spec
    local ox, oy = B.Off(s.key)
    block.host:ClearAllPoints()
    block.host:SetPoint(s.side < 0 and "TOPRIGHT" or "TOPLEFT", B.Halo.root, "CENTER", s.x + ox, s.y + oy)
end

local function AuraScale()
    local s = tonumber(B.db and B.db.auraScale) or 1
    return math.max(0.5, math.min(2, s))
end

local function SizeOf(spec) return math.floor(spec.size * AuraScale() + 0.5) end

local function Build(spec)
    local block = { spec = spec }
    local size = SizeOf(spec)
    local step = size + GAP
    block.size = size
    local harmful = spec.filter == "HARMFUL"

    -- Our own frame holds the place; the engine resizes its container at
    -- will, so the handle and the options talk to this one.
    block.host = CreateFrame("Frame", nil, B.Halo.root)
    block.host:SetSize(spec.perRow * step, math.ceil(spec.max / spec.perRow) * step)
    Place(block)

    -- Away from the halo, then downward; wrap after perRow icons. With
    -- anchorHost the builder pins the corner the flow grows away from.
    local container = AC.Create(block.host, {
        key           = "anim_" .. spec.key,
        unit          = spec.unit,
        filter        = AC.Filter(harmful and "HARMFUL" or "HELPFUL"),
        harmful       = harmful,
        size          = size,
        max           = spec.max,
        spacing       = GAP,
        font          = B.FONT_BOLD,
        growDirection = spec.side < 0 and "LEFT" or "RIGHT",
        growVertical  = "DOWN",
        rowWidth      = spec.perRow * step,
        anchorHost    = block.host,
        tooltips      = true,
        showDuration  = true,
        durationPoint = "BOTTOM", durationRelPoint = "BOTTOM", durationX = 0, durationY = 1,
        durationColor = { 0.95, 0.92, 0.86 },
        dispelBorder  = harmful,
        border        = Backdrop,
    })
    if not container then
        Auras.buildError = (Auras.buildError and Auras.buildError .. ", " or "") .. spec.key .. ": AC.Create nil"
        block.host:Hide()
        return nil
    end
    block.container = container
    block.unitOK = true

    B.Movable(spec.key, T(spec.fr, spec.en), function(h)
        h:SetAllPoints(block.host)
    end, function() Place(block) end)

    blocks[#blocks + 1] = block
    return block
end

--- Hand the unit to the engine again, enable, full update. TMF's unit
--- frames do this on every target change and on entering the world
--- (TomoMod_UFElements.UpdateAuras -> TomoMod_AuraContainer.SetUnit): the engine
--- does not always pick the new unit up on its own.
local function Rebind(block)
    block.unitOK = AC.SetUnit(block.container, block.spec.unit) and true or false
end

--- Aura size setting: resize the place holder and the engine's buttons.
local function Resize(block)
    local size = SizeOf(block.spec)
    if size == block.size then return end
    block.size = size
    local step = size + GAP
    local spec = block.spec
    block.host:SetSize(spec.perRow * step, math.ceil(spec.max / spec.perRow) * step)
    AC.Relayout(block.container, { size = size, max = spec.max, rowWidth = spec.perRow * step })
end

local function Apply()
    for _, block in ipairs(blocks) do
        Resize(block)
        local on = (B.active and B.db[block.spec.option]) and true or false
        if block.on ~= on then
            block.on = on
            block.host:SetShown(on)
            block.container:SetShown(on)
            if not on and block.container.SetEnabled then
                pcall(block.container.SetEnabled, block.container, false)
            end
        end
        if on then Rebind(block) end
    end
end

--- /tmf anim debug: what the aura blocks look like right now.
function Auras:Debug(out)
    out("auras: engine " .. tostring(Available()) .. ", builder " .. tostring(AC ~= nil) .. ", blocks " .. #blocks)
    for _, block in ipairs(blocks) do
        local h, c = block.host, block.container
        -- The engine sizes its container from aura data: the size can be
        -- secret. Only print it when Lua is allowed to read it.
        local w, ht = c:GetSize()
        w, ht = B.Num(w), B.Num(ht)
        local dims = (w and ht) and string.format("%dx%d", math.floor(w + 0.5), math.floor(ht + 0.5)) or "?x?"
        local n = c.GetNumChildren and B.Num(c:GetNumChildren()) or nil
        out(string.format("  %s (%s %s): option %s, host %s/%s, container %s/%s %s, icon %d, unit %s, buttons %s",
            block.spec.key, block.spec.unit, block.spec.filter,
            tostring(B.db[block.spec.option]), tostring(h:IsShown()), tostring(h:IsVisible()),
            tostring(B.Flag(c:IsShown())), tostring(B.Flag(c:IsVisible())), dims, block.size or 0,
            tostring(block.unitOK), n and tostring(n) or "?"))
    end
end

-- ---------------------------------------------------------------------
-- Module hooks
-- ---------------------------------------------------------------------
function Auras:Init()
    if not Available() then return end
    for _, spec in ipairs(SPECS) do
        local ok, err = pcall(Build, spec)
        if not ok then Auras.buildError = tostring(err) end
    end
    -- The target's blocks follow the target, like TMF's frames do.
    local ev = CreateFrame("Frame")
    ev:RegisterEvent("PLAYER_TARGET_CHANGED")
    ev:SetScript("OnEvent", function()
        if not B.active then return end
        for _, block in ipairs(blocks) do
            if block.on and block.spec.unit == "target" then Rebind(block) end
        end
    end)
end

function Auras:Refresh()
    Apply()
    AC.ResizePending()
end

function Auras:Disable()
    Apply()
end

function Auras:CombatEnd()
    AC.ResizePending()
end
