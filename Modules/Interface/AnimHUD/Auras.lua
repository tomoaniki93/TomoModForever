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
-- does. Each block is an AuraContainer: we declare a unit, a filter and
-- how to build one button, and the client scans, sorts, lays out and
-- updates the buttons itself. Our part is the look of a button and where
-- the block sits. If the client has no such engine, the blocks are simply
-- not built.
-- =====================================================================

local B = TomoMod_AnimHUD
local Auras = B.Module("Auras")
local T = B.T

local GAP = 2

-- side: -1 left of the halo (grows left), 1 right of it (grows right).
-- x, y: the block's top inner corner, from the centre of the halo.
local SPECS = {
    { key = "pDebuff", unit = "player", filter = "HARMFUL", size = 28, max = 10, perRow = 5,
      side = -1, x = -250, y = 112, option = "auraPlayer", fr = "Tes débuffs", en = "Your debuffs" },
    { key = "pBuff",   unit = "player", filter = "HELPFUL", size = 20, max = 12, perRow = 6,
      side = -1, x = -250, y = 46,  option = "auraPlayer", fr = "Tes buffs", en = "Your buffs" },
    { key = "tDebuff", unit = "target", filter = "HARMFUL", size = 28, max = 10, perRow = 5,
      side = 1,  x = 250,  y = 112, option = "auraTarget", fr = "Débuffs de la cible", en = "Target debuffs" },
    { key = "tBuff",   unit = "target", filter = "HELPFUL", size = 20, max = 12, perRow = 6,
      side = 1,  x = 250,  y = 46,  option = "auraTarget", fr = "Buffs de la cible", en = "Target buffs" },
}

-- ---------------------------------------------------------------------
-- Engine availability
-- ---------------------------------------------------------------------
local available

local function Available()
    if available ~= nil then return available end
    local ok, probe = pcall(CreateFrame, "AuraContainer", nil, UIParent, "CustomAuraContainerTemplate")
    available = ok and probe and probe.AddAuraGroup and probe.SetUnit and true or false
    if available then
        probe:Hide()
        probe:SetParent(nil)
    end
    return available
end

-- ---------------------------------------------------------------------
-- Buttons
-- ---------------------------------------------------------------------
-- The client refuses to size an aura button while auras are restricted,
-- and it builds each pooled button only once: a button first built during
-- a fight would stay sizeless. Wanted sizes are kept here and retried.
local pending = setmetatable({}, { __mode = "k" })

local function TrySize(button)
    local size = pending[button]
    if size and pcall(button.SetSize, button, size, size) then
        pending[button] = nil
    end
end

local function RetrySizes()
    for button in pairs(pending) do TrySize(button) end
end

local function MakeInitializer(spec)
    local size, harmful = spec.size, spec.filter == "HARMFUL"
    return function(button)
        pending[button] = size
        TrySize(button)

        -- Tooltips ride on mouse motion; clicks stay with the world.
        pcall(button.SetMouseClickEnabled, button, false)
        pcall(button.SetMouseMotionEnabled, button, true)

        -- Every region is created and styled before any is registered:
        -- registering one makes the client write into it straight away.
        local glow
        if harmful then
            glow = button:CreateTexture(nil, "BACKGROUND")
            glow:SetTexture(B.MEDIA .. "Glow")
            glow:SetBlendMode("ADD")
            glow:SetPoint("CENTER")
            glow:SetSize(size * 1.9, size * 1.9)
        end

        local back = button:CreateTexture(nil, "BORDER")
        back:SetAllPoints()
        back:SetColorTexture(0, 0, 0, 0.85)

        local icon = button:CreateTexture(nil, "ARTWORK")
        icon:SetPoint("TOPLEFT", 1, -1)
        icon:SetPoint("BOTTOMRIGHT", -1, 1)
        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
        cooldown:SetAllPoints(icon)
        cooldown:SetDrawEdge(false)
        cooldown:SetReverse(true)
        cooldown:SetHideCountdownNumbers(true)      -- the client writes the time on `duration` below
        cooldown:EnableMouse(false)

        local count = button:CreateFontString(nil, "OVERLAY")
        count:SetFont(B.FONT_BOLD, harmful and 10 or 9, "OUTLINE")
        count:SetPoint("TOPRIGHT", 2, 2)
        count:SetJustifyH("RIGHT")

        local duration = button:CreateFontString(nil, "OVERLAY")
        duration:SetFont(B.FONT_BOLD, harmful and 10 or 8, "OUTLINE")
        duration:SetPoint("BOTTOM", 0, -3)
        duration:SetTextColor(0.95, 0.92, 0.86)

        -- A new aura pops in. The animation lives on our own icon texture;
        -- if the client will not let us watch its button, there is no pop.
        local pop = icon:CreateAnimationGroup()
        local grow = pop:CreateAnimation("Scale")
        grow:SetScaleFrom(1.45, 1.45); grow:SetScaleTo(1, 1); grow:SetDuration(0.22); grow:SetSmoothing("OUT")
        local fade = pop:CreateAnimation("Alpha")
        fade:SetFromAlpha(0.2); fade:SetToAlpha(1); fade:SetDuration(0.22)
        pcall(button.HookScript, button, "OnShow", function()
            pop:Stop()
            pop:Play()
        end)

        -- Registration last, each call guarded: these are what the client
        -- refuses while auras are restricted, and one refusal must not
        -- stop the others.
        if glow and button.AddDispelTypeTexture then
            pcall(button.AddDispelTypeTexture, button, glow, { showWhenHarmful = true, showWhenHelpful = false })
        elseif glow then
            glow:SetVertexColor(0.9, 0.2, 0.15, 0.6)
        end
        pcall(button.SetIcon, button, icon)
        pcall(button.SetDurationCooldown, button, cooldown)
        pcall(button.SetApplicationCount, button, count, {})
        if button.SetDurationText then
            pcall(button.SetDurationText, button, duration, {})
        end
    end
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

local function Build(spec)
    local block = { spec = spec }
    local step = spec.size + GAP

    -- Our own frame holds the place; the engine resizes its container at
    -- will, so the handle and the options talk to this one.
    block.host = CreateFrame("Frame", nil, B.Halo.root)
    block.host:SetSize(spec.perRow * step, math.ceil(spec.max / spec.perRow) * step)
    Place(block)

    local ok, container = pcall(CreateFrame, "AuraContainer", nil, block.host, "CustomAuraContainerTemplate")
    if not ok or not container then return nil end
    local corner = spec.side < 0 and "TOPRIGHT" or "TOPLEFT"
    container:SetPoint(corner, block.host, corner)
    container:SetSize(1, 1)

    if not pcall(container.AddAuraGroup, container, spec.key, spec.filter, {
        maxFrameCount   = spec.max,
        initializeFrame = MakeInitializer(spec),
        layout = { elementWidth = spec.size, elementHeight = spec.size, elementSpacing = GAP, lineSpacing = GAP },
    }) then
        container:Hide()
        return nil
    end

    -- Away from the halo, then downward; wrap after perRow icons.
    local grow = container.SetFlowLayoutGrowthDirection or container.SetAuraLayoutGrowthDirection
    if grow then pcall(grow, container, spec.side < 0 and "Left" or "Right", "Down") end
    local wrap = container.SetFlowLayoutMaximumLineSize or container.SetAuraLayoutRowWidth
    if wrap then pcall(wrap, container, spec.perRow * step) end

    -- The unit goes last: assigning it makes the engine register its
    -- events, which it only does for a container that has groups.
    pcall(container.SetUnit, container, spec.unit)
    block.container = container

    B.Movable(spec.key, T(spec.fr, spec.en), function(h)
        h:SetAllPoints(block.host)
    end, function() Place(block) end)

    blocks[#blocks + 1] = block
    return block
end

local function Apply()
    for _, block in ipairs(blocks) do
        local on = (B.active and B.db[block.spec.option]) and true or false
        if block.on ~= on then
            block.on = on
            block.host:SetShown(on)
            if block.container.SetEnabled then pcall(block.container.SetEnabled, block.container, on) end
            if on then pcall(block.container.UpdateAllAuras, block.container) end
        end
    end
end

-- ---------------------------------------------------------------------
-- Module hooks
-- ---------------------------------------------------------------------
function Auras:Init()
    if not Available() then return end
    for _, spec in ipairs(SPECS) do Build(spec) end
end

function Auras:Refresh()
    Apply()
    RetrySizes()
end

function Auras:Disable()
    Apply()
end

function Auras:CombatEnd()
    RetrySizes()
end
