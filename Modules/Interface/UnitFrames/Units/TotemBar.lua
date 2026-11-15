-- =====================================================================
-- Units/TotemBar.lua -- shaman totems under the TomoMod player frame (1.3.0)
--
-- Blizzard's TotemFrame is a child of PlayerFrame (PlayerBottomManagedFrame):
-- when oUF hides the Blizzard player frame for TomoMod's, the totems vanish
-- with it -- shamans could not see the totems they had dropped (player
-- report). Moving Blizzard's frame out is fragile (its manager re-anchors
-- it on every layout), so TomoMod draws its own bar:
--
--   * one fixed spot per element, in Blizzard's shaman order (earth, fire,
--     water, air), so a totem always shows at the same place;
--   * icon, cooldown sweep and time left; tooltip of the totem on hover;
--   * right click dismisses the totem. DestroyTotem is protected, so each
--     spot is a SecureActionButton (type2 = "destroytotem"); secure buttons
--     cannot be shown / hidden in combat, an empty spot only goes transparent;
--   * under the player frame by default, movable with /tmf move (the
--     position is then kept); size and empty spots in Frames > Player.
-- Shamans only, and only while TomoMod's player frame is on (otherwise
-- Blizzard's player frame and its own totems are there).
-- =====================================================================

TomoMod_TotemBar = TomoMod_TotemBar or {}
local TB = TomoMod_TotemBar

local SOLID  = "Interface\\Buttons\\WHITE8x8"
local FONT   = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local BRONZE = { 0.545, 0.420, 0.247 }
local GOLD   = { 0.788, 0.635, 0.322 }

-- Element colours of the empty spots: fire, earth, water, air (totem slots 1-4).
local ELEMENT = {
    [1] = { 0.90, 0.35, 0.15 },
    [2] = { 0.55, 0.40, 0.20 },
    [3] = { 0.25, 0.55, 0.95 },
    [4] = { 0.70, 0.80, 0.95 },
}

local bar, buttons = nil, {}
local unlocked = false

local function IsSecret(v)
    return type(issecretvalue) == "function" and issecretvalue(v) == true
end

local function DB()
    local uf = TomoModForeverDB and TomoModForeverDB.unitFrames
    if not uf then return nil end
    if type(uf.totems) ~= "table" then uf.totems = {} end
    local t = uf.totems
    if t.enabled == nil then t.enabled = true end
    t.size = t.size or 28
    t.spacing = t.spacing or 4
    if t.showEmpty == nil then t.showEmpty = false end
    return t
end

local function IsShaman()
    local _, class = UnitClass("player")
    return class == "SHAMAN"
end

local function PlayerFrameOn()
    local uf = TomoModForeverDB and TomoModForeverDB.unitFrames
    return uf and uf.enabled ~= false and uf.player and uf.player.enabled ~= false and _G.TomoMod_UF_player ~= nil
end

local function SlotOrder()
    if type(SHAMAN_TOTEM_PRIORITIES) == "table" and #SHAMAN_TOTEM_PRIORITIES >= 4 then
        return SHAMAN_TOTEM_PRIORITIES
    end
    return { 2, 1, 3, 4 }                                 -- earth, fire, water, air
end

local function FormatTime(s)
    if s >= 60 then return string.format("%d:%02d", math.floor(s / 60), math.floor(s % 60)) end
    return string.format("%d", math.ceil(s))
end

-- ---------------------------------------------------------------------
-- Position
-- ---------------------------------------------------------------------
local function Place()
    if not bar or InCombatLockdown() then return end
    local db = DB()
    bar:ClearAllPoints()
    if db.position and db.position.point then
        bar:SetPoint(db.position.point, UIParent, db.position.relativePoint or db.position.point, db.position.x or 0, db.position.y or 0)
    elseif _G.TomoMod_UF_player then
        bar:SetPoint("TOPLEFT", _G.TomoMod_UF_player, "BOTTOMLEFT", 0, -8)
    else
        bar:SetPoint("CENTER", UIParent, "CENTER", -200, -160)
    end
end

-- ---------------------------------------------------------------------
-- Buttons
-- ---------------------------------------------------------------------
local function UpdateButton(b)
    local slot = b.slot
    local have, _, start, duration, icon = GetTotemInfo(slot)
    local db = DB()
    if have and icon and duration and not IsSecret(duration) and duration > 0 then
        b.icon:SetTexture(icon)
        b.icon:Show()
        b.empty:Hide()
        if not IsSecret(start) then
            pcall(b.cd.SetCooldown, b.cd, start, duration)
            b.cd:Show()
        end
        b.active = true
        b:SetAlpha(1)
    else
        b.icon:Hide()
        b.cd:Hide()
        b.time:SetText("")
        b.empty:Show()
        b.active = false
        b:SetAlpha((db.showEmpty or unlocked) and 0.45 or 0)
    end
end

local function UpdateAll()
    if not bar then return end
    for _, b in ipairs(buttons) do UpdateButton(b) end
end

local function Layout()
    if not bar or InCombatLockdown() then return end
    local db = DB()
    local size, gap = db.size, db.spacing
    bar:SetSize(size * 4 + gap * 3, size + 12)
    for i, b in ipairs(buttons) do
        b:SetSize(size, size)
        b:ClearAllPoints()
        b:SetPoint("TOPLEFT", bar, "TOPLEFT", (i - 1) * (size + gap), 0)
        b.time:SetFont(FONT, math.max(8, math.floor(size * 0.36)), "OUTLINE")
    end
end

local function CreateButton(i, slot)
    local b = CreateFrame("Button", nil, bar, "SecureActionButtonTemplate")
    b.slot = slot
    b:RegisterForClicks("RightButtonUp", "RightButtonDown")
    -- Right click: dismiss this totem (secure action, works in combat).
    b:SetAttribute("type2", "destroytotem")
    b:SetAttribute("totem-slot", slot)

    local c = ELEMENT[slot] or GOLD
    local edge = b:CreateTexture(nil, "BACKGROUND")
    edge:SetPoint("TOPLEFT", -1, 1); edge:SetPoint("BOTTOMRIGHT", 1, -1)
    edge:SetTexture(SOLID); edge:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 1)
    local back = b:CreateTexture(nil, "BACKGROUND", nil, 1)
    back:SetAllPoints(); back:SetTexture(SOLID); back:SetVertexColor(0.06, 0.05, 0.04, 1)

    b.empty = b:CreateTexture(nil, "BORDER")
    b.empty:SetPoint("TOPLEFT", 3, -3); b.empty:SetPoint("BOTTOMRIGHT", -3, 3)
    b.empty:SetTexture(SOLID); b.empty:SetVertexColor(c[1], c[2], c[3], 0.35)

    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetPoint("TOPLEFT", 1, -1); b.icon:SetPoint("BOTTOMRIGHT", -1, 1)
    b.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    b.cd = CreateFrame("Cooldown", nil, b, "CooldownFrameTemplate")
    b.cd:SetAllPoints(b.icon)
    b.cd:SetReverse(true)
    b.cd:SetDrawEdge(false)
    if b.cd.SetHideCountdownNumbers then b.cd:SetHideCountdownNumbers(true) end

    b.time = b:CreateFontString(nil, "OVERLAY")
    b.time:SetPoint("TOP", b, "BOTTOM", 0, -1)
    b.time:SetTextColor(1, 0.82, 0)

    b:SetScript("OnEnter", function(self)
        if not self.active then return end
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
        GameTooltip:SetTotem(self.slot)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    b:HookScript("OnUpdate", function(self, elapsed)
        if not self.active then return end
        self.tick = (self.tick or 0) - elapsed
        if self.tick > 0 then return end
        self.tick = 0.2
        local left = GetTotemTimeLeft and GetTotemTimeLeft(self.slot)
        if left and not IsSecret(left) and left > 0 then
            self.time:SetText(FormatTime(left))
        else
            self.time:SetText("")
        end
        if GameTooltip:IsOwned(self) then GameTooltip:SetTotem(self.slot) end
    end)
    return b
end

-- ---------------------------------------------------------------------
-- Mover (/tmf move)
-- ---------------------------------------------------------------------
local function SetUnlocked(on)
    if not bar then return end
    unlocked = on and true or false
    if not bar.mover then
        local m = CreateFrame("Frame", nil, bar)
        m:SetAllPoints(bar)
        m:SetFrameLevel(bar:GetFrameLevel() + 20)
        m:EnableMouse(true)
        m:RegisterForDrag("LeftButton")
        m:SetScript("OnDragStart", function() if not InCombatLockdown() then bar:StartMoving() end end)
        m:SetScript("OnDragStop", function()
            bar:StopMovingOrSizing()
            local db = DB()
            db.position = db.position or {}
            if TomoMod_Utils and TomoMod_Utils.SaveFramePosition then
                TomoMod_Utils.SaveFramePosition(bar, db.position)
            end
        end)
        if TomoMod_Utils and TomoMod_Utils.StyleMoverOverlay then
            TomoMod_Utils.StyleMoverOverlay(m, (TomoMod_L and TomoMod_L["mover_totems"]) or "Totems")
        end
        m:Hide()
        bar.mover = m
    end
    bar:SetMovable(true)
    bar.mover:SetShown(unlocked)
    UpdateAll()
end

function TB.IsLocked() return not unlocked end
function TB.ToggleLock() SetUnlocked(not unlocked) end

-- ---------------------------------------------------------------------
-- Public
-- ---------------------------------------------------------------------
function TB.ApplySettings()
    if not bar then
        if InCombatLockdown() then return end
        TB.Initialize()
        return
    end
    if InCombatLockdown() then return end
    local db = DB()
    local on = db.enabled and IsShaman() and PlayerFrameOn()
    bar:SetShown(on)
    Layout()
    Place()
    UpdateAll()
end

function TB.ResetPosition()
    local db = DB()
    if db then db.position = nil end
    Place()
end

function TB.Initialize()
    if bar or not IsShaman() then return end
    local db = DB()
    if not db then return end
    if InCombatLockdown() then
        local f = CreateFrame("Frame")
        f:RegisterEvent("PLAYER_REGEN_ENABLED")
        f:SetScript("OnEvent", function(self) self:UnregisterAllEvents(); TB.Initialize() end)
        return
    end
    bar = CreateFrame("Frame", "TomoMod_TotemBarFrame", UIParent)
    bar:SetClampedToScreen(true)
    bar:SetFrameStrata("MEDIUM")
    for i, slot in ipairs(SlotOrder()) do
        if i > 4 then break end
        buttons[i] = CreateButton(i, slot)
    end
    Layout()
    Place()

    local ev = CreateFrame("Frame")
    ev:RegisterEvent("PLAYER_TOTEM_UPDATE")
    ev:RegisterEvent("PLAYER_ENTERING_WORLD")
    ev:SetScript("OnEvent", function(_, event)
        if event == "PLAYER_ENTERING_WORLD" and not InCombatLockdown() then
            TB.ApplySettings()
            return
        end
        UpdateAll()
    end)

    if TomoMod_Movers and TomoMod_Movers.RegisterEntry then
        TomoMod_Movers.RegisterEntry({
            label = (TomoMod_L and TomoMod_L["mover_totems"]) or "Totems",
            unlock = function() SetUnlocked(true) end,
            lock = function() SetUnlocked(false) end,
            isActive = function() local d = DB(); return d and d.enabled and IsShaman() and PlayerFrameOn() end,
        })
    end
    TB.ApplySettings()
end
