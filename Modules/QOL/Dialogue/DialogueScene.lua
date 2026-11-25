-- =====================================================================
-- Modules/QOL/Dialogue/DialogueScene.lua -- the scene around a dialogue (1.3.9)
--
--   Camera     zooms in gently and shifts aside so the NPC stands beside
--              the panel; your own zoom and shoulder offset come back when
--              the dialogue ends.
--   Interface  the rest of the interface fades out, two cinema bars slide
--              in at the top and bottom; it all comes back at the end, and
--              at once if a fight starts.
-- The dialogue panel, the item tooltips and confirmation popups stay
-- visible (they ignore the interface's fade while a scene is on).
-- =====================================================================

TomoMod_DialogueScene = TomoMod_DialogueScene or {}
local S = TomoMod_DialogueScene

local ART = "Interface\\AddOns\\TomoModForever\\Assets\\Textures\\Dialogue\\"
local KEEP_VISIBLE = { "GameTooltip", "ShoppingTooltip1", "ShoppingTooltip2", "ItemRefTooltip",
                       "StaticPopup1", "StaticPopup2", "TomoMod_BookFrame" }

local function DB() return TomoModForeverDB and TomoModForeverDB.dialogue end
local function AnimAny()
    local U = TomoMod_Utils
    return not (U and U.AnimAny) or U.AnimAny()
end

local inScene = false
local saved = {}          -- camera values to give back
local uiAlphaWas
local keptIgnore = {}

-- ---------------------------------------------------------------------
-- Interface fade (own tween: nothing of Blizzard's fader)
-- ---------------------------------------------------------------------
local tween = CreateFrame("Frame")
tween:Hide()
local fromA, toA, t, dur = 1, 1, 0, 0.3
tween:SetScript("OnUpdate", function(self, dt)
    t = t + dt
    local p = math.min(1, t / dur)
    UIParent:SetAlpha(fromA + (toA - fromA) * p)
    if p >= 1 then self:Hide() end
end)

local function FadeUI(to, instant)
    fromA, toA, t = UIParent:GetAlpha(), to, 0
    if instant or not AnimAny() then
        tween:Hide()
        UIParent:SetAlpha(to)
        return
    end
    tween:Show()
end

local function KeepVisible(on)
    for _, name in ipairs(KEEP_VISIBLE) do
        local f = _G[name]
        if f and f.SetIgnoreParentAlpha then
            if on then
                if keptIgnore[name] == nil then keptIgnore[name] = f:IsIgnoringParentAlpha() and true or false end
                f:SetIgnoreParentAlpha(true)
            elseif keptIgnore[name] ~= nil then
                f:SetIgnoreParentAlpha(keptIgnore[name])
                keptIgnore[name] = nil
            end
        end
    end
end

-- ---------------------------------------------------------------------
-- Cinema bars
-- ---------------------------------------------------------------------
local bars
local function Bars()
    if bars then return bars end
    bars = CreateFrame("Frame", nil, UIParent)
    bars:SetAllPoints(UIParent)
    bars:SetFrameStrata("BACKGROUND")
    bars:EnableMouse(false)
    if bars.SetIgnoreParentAlpha then bars:SetIgnoreParentAlpha(true) end
    bars:Hide()
    local function Bar(point)
        local f = CreateFrame("Frame", nil, bars)
        f:SetPoint(point .. "LEFT"); f:SetPoint(point .. "RIGHT")
        local tex = f:CreateTexture(nil, "BACKGROUND")
        tex:SetAllPoints()
        tex:SetTexture(ART .. "letterbox.tga")
        if point == "BOTTOM" then tex:SetTexCoord(0, 1, 1, 0) end
        local ag = f:CreateAnimationGroup()
        local out = ag:CreateAnimation("Translation"); out:SetDuration(0); out:SetOrder(1)
        local back = ag:CreateAnimation("Translation"); back:SetDuration(0.35); back:SetSmoothing("OUT"); back:SetOrder(2)
        f.ag, f.out, f.back, f.point = ag, out, back, point
        return f
    end
    bars.top, bars.bottom = Bar("TOP"), Bar("BOTTOM")
    return bars
end

local function ShowBars(on)
    local db = DB()
    if on and not (db and db.letterbox ~= false) then on = false end
    if not on then
        if bars then bars:Hide() end
        return
    end
    local b = Bars()
    local h = math.floor(UIParent:GetHeight() * 0.10)
    for _, f in ipairs({ b.top, b.bottom }) do
        f:SetHeight(h)
        local dir = f.point == "TOP" and 1 or -1
        f.out:SetOffset(0, dir * h)
        f.back:SetOffset(0, -dir * h)
        f.ag:Stop()
        if AnimAny() then f.ag:Play() end
    end
    b:Show()
end

-- ---------------------------------------------------------------------
-- Camera
-- ---------------------------------------------------------------------
local cvarWarningMuted = false
local function MuteCVarWarning()
    -- Shoulder offset is an "experimental" camera setting: without this the
    -- game asks for a confirmation the first time.
    if cvarWarningMuted then return end
    cvarWarningMuted = true
    if UIParent and UIParent.UnregisterEvent then
        pcall(UIParent.UnregisterEvent, UIParent, "EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED")
    end
end

local function CameraIn()
    local db = DB()
    if not (db and db.camera ~= false) then return end
    if IsInInstance and select(1, IsInInstance()) and db.cameraInInstance == false then return end
    if not (GetCameraZoom and CameraZoomIn) then return end
    saved.zoom = GetCameraZoom()
    local target = db.cameraZoom or 3.5
    if saved.zoom and saved.zoom > target then CameraZoomIn(saved.zoom - target) end
    if GetCVar and SetCVar and (db.side ~= "center") then
        MuteCVarWarning()
        saved.shoulder = GetCVar("test_cameraOverShoulder")
        db.savedShoulder = saved.shoulder   -- given back at next login after a crash
        SetCVar("test_cameraOverShoulder", tostring(db.cameraShift or 1.2))
    end
end

local function CameraOut()
    if saved.zoom and GetCameraZoom and CameraZoomOut then
        local now = GetCameraZoom()
        if now and saved.zoom > now then CameraZoomOut(saved.zoom - now) end
    end
    if saved.shoulder ~= nil and SetCVar then SetCVar("test_cameraOverShoulder", saved.shoulder) end
    local db = DB()
    if db then db.savedShoulder = nil end
    saved = {}
end

-- ---------------------------------------------------------------------
-- Scene
-- ---------------------------------------------------------------------
function S.Enter()
    if inScene then return end
    inScene = true
    local db = DB()
    CameraIn()
    if db and db.hideUI ~= false and not InCombatLockdown() then
        uiAlphaWas = UIParent:GetAlpha()
        KeepVisible(true)
        FadeUI(0)
        ShowBars(true)
    end
end

function S.Leave(instant)
    if not inScene then return end
    inScene = false
    CameraOut()
    if uiAlphaWas then
        FadeUI(uiAlphaWas, instant)
        uiAlphaWas = nil
        C_Timer.After(instant and 0 or 0.35, function()
            if not inScene then KeepVisible(false) end
        end)
    end
    ShowBars(false)
end

function S.Active() return inScene end

--- At login: a shoulder offset left by a crash mid-dialogue goes back.
function S.Recover()
    local db = DB()
    if db and db.savedShoulder ~= nil and SetCVar then
        SetCVar("test_cameraOverShoulder", db.savedShoulder)
        db.savedShoulder = nil
    end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_REGEN_DISABLED")
ev:RegisterEvent("PLAYER_LOGOUT")
ev:SetScript("OnEvent", function(_, event)
    -- A fight: the interface comes back at once (the dialogue stays).
    if event == "PLAYER_REGEN_DISABLED" and uiAlphaWas then
        FadeUI(uiAlphaWas, true)
        uiAlphaWas = nil
        KeepVisible(false)
        ShowBars(false)
    elseif event == "PLAYER_LOGOUT" and inScene then
        S.Leave(true)
    end
end)
