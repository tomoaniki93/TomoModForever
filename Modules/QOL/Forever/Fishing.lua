-- =====================================================================
-- Modules/QOL/Forever/Fishing.lua -- fishing helpers (1.3.6)
--
--   Fishing key   one key for everything (Key Bindings > AddOns >
--                 TomoMod Forever): it equips a fishing pole from your bags
--                 when none is in hand, applies a lure when the pole has
--                 none (option), and casts. With Reel In (option), while the
--                 line is out the same key interacts with the bobber, which
--                 the game's soft targeting picks up: press it when it bites.
--   Double-click  pole in hand: a quick second right click on the world
--                 casts (out of combat).
--   Sounds        while fishing, effects up, music and ambience down, so the
--                 splash is heard; everything goes back 20 seconds after the
--                 last cast, and at logout.
--
-- The key is a SecureActionButton (macro): its macro text is written out of
-- combat only (on bag / gear changes and right before each press). Override
-- bindings (Reel In, double-click) and the sound CVars are only touched out
-- of combat too, and always given back.
-- =====================================================================

TomoMod_Fishing = TomoMod_Fishing or {}
local FI = TomoMod_Fishing

local BUTTON_NAME = "TomoMod_FishingButton"
local BINDING     = "CLICK " .. BUTTON_NAME .. ":LeftButton"
local FISHING_ID  = 7620
local LURES = { 6533, 6811, 7307, 6532, 6530, 6529 }   -- best first
local SOUND_CVARS = { "Sound_EnableSFX", "Sound_SFXVolume", "Sound_MusicVolume", "Sound_AmbienceVolume" }
local SOUND_SET   = { Sound_EnableSFX = "1", Sound_SFXVolume = "1.0", Sound_MusicVolume = "0", Sound_AmbienceVolume = "0" }
local IDLE_RESTORE = 20

local IS_FR = GetLocale() == "frFR"
_G.BINDING_HEADER_TOMOMODFOREVER = "TomoMod Forever"
_G["BINDING_NAME_" .. BINDING] = IS_FR and "Pêche : équiper, appâter, lancer, ramener" or "Fishing: equip, lure, cast, reel in"

local function DB() return TomoModForeverDB and TomoModForeverDB.fishing end

local function Readable(v)
    if type(issecretvalue) == "function" and issecretvalue(v) then return nil end
    return v
end

local function FishingName()
    if C_Spell and C_Spell.GetSpellName then return C_Spell.GetSpellName(FISHING_ID) end
    return GetSpellInfo and (GetSpellInfo(FISHING_ID)) or "Fishing"
end

local function ItemName(id)
    if C_Item and C_Item.GetItemNameByID then
        local n = C_Item.GetItemNameByID(id)
        if n then return n end
    end
    return GetItemInfo and (GetItemInfo(id)) or nil
end

local function IsPole(itemID)
    if not itemID then return false end
    local classID, subID
    if C_Item and C_Item.GetItemInfoInstant then
        local _, _, _, _, _, c, s = C_Item.GetItemInfoInstant(itemID)
        classID, subID = c, s
    end
    return classID == 2 and subID == 20
end

local function PoleEquipped() return IsPole(GetInventoryItemID("player", 16)) end

local function BagItems()
    local list = {}
    local num = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
    local get = C_Container and C_Container.GetContainerItemID or GetContainerItemID
    if not (num and get) then return list end
    for bag = 0, 4 do
        for slot = 1, (num(bag) or 0) do
            local id = get(bag, slot)
            if id then list[id] = true end
        end
    end
    return list
end

local function LureActive()
    local has = GetWeaponEnchantInfo and GetWeaponEnchantInfo()
    return has and true or false
end

-- ---------------------------------------------------------------------
-- The key
-- ---------------------------------------------------------------------
local button = CreateFrame("Button", BUTTON_NAME, UIParent, "SecureActionButtonTemplate")
-- Up only: one press runs the macro once (key release, and the release of
-- the double-click's second right click).
button:RegisterForClicks("AnyUp")
button:Hide()

local function MacroText()
    local db = DB()
    local cast = "/cast " .. (FishingName() or "Fishing")
    if not PoleEquipped() then
        local items = BagItems()
        for id in pairs(items) do
            if IsPole(id) then
                local name = ItemName(id)
                if name then return "/equip " .. name end
            end
        end
        return cast
    end
    if db and db.lure and not LureActive() then
        local items = BagItems()
        for _, id in ipairs(LURES) do
            if items[id] then
                local name = ItemName(id)
                if name then return "/use " .. name .. "\n/use 16" end
            end
        end
    end
    return cast
end

local function Refresh()
    if InCombatLockdown() then return end
    if button:GetAttribute("type") ~= "macro" then button:SetAttribute("type", "macro") end
    button:SetAttribute("macrotext", MacroText())
end
button:SetScript("PreClick", Refresh)

-- ---------------------------------------------------------------------
-- Reel In: the key interacts while the line is out
-- ---------------------------------------------------------------------
local reelOwner = CreateFrame("Frame")
local reeling = false
local softWas

local function KeysOf(binding)
    local keys = { GetBindingKey(binding) }
    return keys
end

local function StartReel()
    local db = DB()
    if not (db and db.reelIn) or InCombatLockdown() then return end
    local keys = KeysOf(BINDING)
    if #keys == 0 then return end
    if softWas == nil and GetCVar then softWas = GetCVar("SoftTargetInteract") end
    if SetCVar then SetCVar("SoftTargetInteract", "3") end
    for _, key in ipairs(keys) do SetOverrideBinding(reelOwner, true, key, "INTERACTTARGET") end
    reeling = true
end

local pendingClear = false
local function StopReel()
    if not reeling then return end
    if InCombatLockdown() then pendingClear = true return end
    ClearOverrideBindings(reelOwner)
    reeling = false
end

-- ---------------------------------------------------------------------
-- Sounds
-- ---------------------------------------------------------------------
local restoreTimer

local function RestoreSession()
    local db = DB()
    if db and type(db.savedSound) == "table" and SetCVar then
        for k, v in pairs(db.savedSound) do SetCVar(k, v) end
        db.savedSound = nil
    end
    if softWas ~= nil and SetCVar and not InCombatLockdown() then
        SetCVar("SoftTargetInteract", softWas)
        softWas = nil
    end
end

local function StartSounds()
    local db = DB()
    if not (db and db.sounds and GetCVar and SetCVar) then return end
    if not db.savedSound then
        db.savedSound = {}
        for _, k in ipairs(SOUND_CVARS) do db.savedSound[k] = GetCVar(k) end
    end
    for k, v in pairs(SOUND_SET) do SetCVar(k, v) end
end

local function ArmRestore()
    if restoreTimer then restoreTimer:Cancel() end
    restoreTimer = C_Timer.NewTimer(IDLE_RESTORE, function()
        restoreTimer = nil
        RestoreSession()
    end)
end

-- ---------------------------------------------------------------------
-- Double-click to cast
-- ---------------------------------------------------------------------
local dcOwner = CreateFrame("Frame")
local lastRight = 0
local dcSet = false

local function ClearDoubleClick()
    if dcSet and not InCombatLockdown() then
        ClearOverrideBindings(dcOwner)
        dcSet = false
    end
end

local function OnWorldMouseDown(_, mouse)
    local db = DB()
    if not (db and db.enabled and db.doubleClick) or mouse ~= "RightButton" then return end
    if InCombatLockdown() or not PoleEquipped() then return end
    local now = GetTime()
    if now - lastRight < 0.4 then
        lastRight = 0
        Refresh()
        -- The release of this second click goes to the fishing key.
        SetOverrideBindingClick(dcOwner, true, "BUTTON2", BUTTON_NAME)
        dcSet = true
        C_Timer.After(0.6, ClearDoubleClick)
    else
        lastRight = now
    end
end

-- ---------------------------------------------------------------------
-- Events
-- ---------------------------------------------------------------------
local function IsFishingSpell(spellID)
    spellID = Readable(spellID)
    if not spellID then return false end
    local name = C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(spellID)
    return name ~= nil and name == FishingName()
end

local ev = CreateFrame("Frame")
ev:SetScript("OnEvent", function(_, event, _, _, spellID)
    local db = DB()
    if event == "PLAYER_LOGOUT" then
        RestoreSession()
        return
    elseif event == "PLAYER_REGEN_ENABLED" then
        if pendingClear then pendingClear = false; StopReel() end
        ClearDoubleClick()
        Refresh()
        return
    elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
        if not (db and db.enabled) or not IsFishingSpell(spellID) then return end
        if restoreTimer then restoreTimer:Cancel(); restoreTimer = nil end
        StartSounds()
        StartReel()
        ClearDoubleClick()
        return
    elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then
        if not IsFishingSpell(spellID) then return end
        -- Let the interact go through before the key casts again.
        C_Timer.After(0.3, function() StopReel(); Refresh() end)
        ArmRestore()
        return
    end
    Refresh()
end)

function FI.ApplySettings()
    local db = DB()
    if not (db and db.enabled) then
        StopReel()
        ClearDoubleClick()
        RestoreSession()
    end
    Refresh()
end

function FI.SetEnabled(v)
    local db = DB()
    if not db then return end
    db.enabled = v and true or false
    FI.ApplySettings()
end

--- The key(s) bound to the fishing key, for the options page.
function FI.BoundKeys()
    local keys = KeysOf(BINDING)
    return #keys > 0 and table.concat(keys, ", ") or nil
end

local worldHooked = false
function FI.Initialize()
    local db = DB()
    if not db then return end
    -- Sounds left changed by a crash: put them back.
    if db.savedSound then RestoreSession() end
    ev:RegisterEvent("PLAYER_LOGOUT")
    ev:RegisterEvent("PLAYER_REGEN_ENABLED")
    ev:RegisterEvent("BAG_UPDATE_DELAYED")
    ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    ev:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player")
    ev:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
    ev:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
    if not worldHooked and WorldFrame and WorldFrame.HookScript then
        WorldFrame:HookScript("OnMouseDown", OnWorldMouseDown)
        worldHooked = true
    end
    Refresh()
end
