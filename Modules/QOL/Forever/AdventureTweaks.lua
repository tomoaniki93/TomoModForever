-- =====================================================================
-- Modules/QOL/Forever/AdventureTweaks.lua -- small adventure comforts
--
--   * Accept resurrection: takes RESURRECT_REQUEST and accepts it, unless
--     the caster is in combat (option), with one chat line.
--   * Hide red errors: UIErrorsFrame stops listening to UI_ERROR_MESSAGE;
--     our own frame forwards the messages that should still show (all of
--     them out of combat in "combat" mode, the important ones always when
--     asked) to Blizzard's own handler. No Blizzard script is replaced, so
--     turning it off just re-registers the event.
--   * Train all: a button next to "Train" at class / profession trainers
--     that buys every available skill you can afford, cheapest first.
--
-- Every toggle is read live: Apply() re-reads them all (manifest "gate").
-- =====================================================================

TomoMod_AdventureTweaks = TomoMod_AdventureTweaks or {}
local AT = TomoMod_AdventureTweaks

local IS_FR = GetLocale() == "frFR"
local function T(fr, en)
    if TomoMod_GUIT then return TomoMod_GUIT(fr, en) end
    return IS_FR and fr or en
end

local function DB() return TomoModForeverDB and TomoModForeverDB.adventureTweaks end

local PREFIX = "|cffffd100TomoModForever|r "

local function Coins(copper)
    if C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString then
        return C_CurrencyInfo.GetCoinTextureString(copper)
    elseif GetCoinTextureString then
        return GetCoinTextureString(copper)
    end
    return tostring(copper)
end

local events = CreateFrame("Frame")

-- ---------------------------------------------------------------------
-- Resurrection
-- ---------------------------------------------------------------------
local RES_POPUPS = { "RESURRECT", "RESURRECT_NO_SICKNESS", "RESURRECT_NO_TIMER" }

local function OnResurrectRequest(inviter)
    local db = DB()
    if not (db and db.autoRes) then return end
    -- The name can be a unit we do not see (out of range): then we cannot
    -- tell whether they are fighting, and we accept.
    if db.autoResNoCombat and inviter then
        local ok, fighting = pcall(UnitAffectingCombat, inviter)
        if ok and fighting then return end
    end
    AcceptResurrect()
    for _, which in ipairs(RES_POPUPS) do
        if StaticPopup_Hide then StaticPopup_Hide(which) end
    end
    if db.autoResMessage then
        print(PREFIX .. string.format(T("Résurrection acceptée (%s).", "Resurrection accepted (%s)."),
            tostring(inviter or "?")))
    end
end

-- ---------------------------------------------------------------------
-- Red errors
-- ---------------------------------------------------------------------
-- Shown even when hiding: things you need to act on, not spam.
local IMPORTANT = {}
local function BuildImportant()
    wipe(IMPORTANT)
    for _, g in ipairs({
        "ERR_INV_FULL", "ERR_BAG_FULL", "ERR_QUEST_LOG_FULL", "ERR_PLAYER_DEAD",
        "ERR_PET_SPELL_DEAD", "ERR_LOOT_GONE", "ERR_ITEM_MAX_COUNT",
        "ERR_NOT_ENOUGH_MONEY", "ERR_RAID_GROUP_ONLY", "SPELL_FAILED_TARGET_NO_POCKETS",
        "ERR_ALREADY_PICKPOCKETED", "ERR_NO_ROOM_FOR_ITEM",
    }) do
        local s = _G[g]
        if type(s) == "string" then IMPORTANT[s] = true end
    end
end

local errorsHooked = false   -- true while UIErrorsFrame is unhooked from the event

local function ShouldShow(message)
    local db = DB()
    if not db then return true end
    if db.hideErrorsMode == "combat" and not InCombatLockdown() then return true end
    if db.keepImportantErrors and type(message) == "string" and IMPORTANT[message] then return true end
    return false
end

-- UI_ERROR_MESSAGE is (errorType, message) on current clients and
-- (message) on very old ones; find the string either way.
local function ForwardError(...)
    local a, b = ...
    local message = type(b) == "string" and b or (type(a) == "string" and a or nil)
    if not ShouldShow(message) then return end
    local handler = UIErrorsFrame and UIErrorsFrame:GetScript("OnEvent")
    if handler then pcall(handler, UIErrorsFrame, "UI_ERROR_MESSAGE", ...) end
end

local function ApplyErrors()
    local db = DB()
    local want = db and db.hideErrors and UIErrorsFrame ~= nil
    if want and not errorsHooked then
        BuildImportant()
        UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
        events:RegisterEvent("UI_ERROR_MESSAGE")
        errorsHooked = true
    elseif not want and errorsHooked then
        events:UnregisterEvent("UI_ERROR_MESSAGE")
        UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
        errorsHooked = false
    end
end

-- ---------------------------------------------------------------------
-- Train all
-- ---------------------------------------------------------------------
local trainBtn

-- Available services, cheapest first, with what you can afford.
local function Available()
    local list = {}
    local n = GetNumTrainerServices and GetNumTrainerServices() or 0
    for i = 1, n do
        local _, status = GetTrainerServiceInfo(i)
        if status == "available" then
            list[#list + 1] = { index = i, cost = GetTrainerServiceCost(i) or 0 }
        end
    end
    table.sort(list, function(x, y) return x.cost < y.cost end)
    local money, affordable, total = GetMoney(), 0, 0
    for _, s in ipairs(list) do
        if total + s.cost <= money then
            total = total + s.cost
            affordable = affordable + 1
            s.ok = true
        end
    end
    return list, affordable, total
end

local function RefreshTrainButton()
    if not trainBtn then return end
    local db = DB()
    local pointsTrainer = ClassTrainerFrame and ClassTrainerFrame.trainingPoints
        and ClassTrainerFrame.trainingPoints:IsShown()
    if not (db and db.trainAll) or pointsTrainer then
        trainBtn:Hide()
        return
    end
    trainBtn:Show()
    local _, affordable = Available()
    trainBtn:SetEnabled(affordable > 0)
    if trainBtn:IsMouseOver() and trainBtn:GetScript("OnEnter") then
        trainBtn:GetScript("OnEnter")(trainBtn)
    end
end

local function CreateTrainButton()
    if trainBtn or not ClassTrainerFrame then return end
    local anchor = _G.ClassTrainerTrainButton
    if not anchor then return end

    trainBtn = CreateFrame("Button", "TomoMod_TrainAllButton", ClassTrainerFrame, "UIPanelButtonTemplate")
    trainBtn:SetText(T("Tout apprendre", "Train all"))
    trainBtn:SetHeight(anchor:GetHeight() > 0 and anchor:GetHeight() or 22)
    trainBtn:SetWidth(math.max(90, (trainBtn:GetFontString() and trainBtn:GetFontString():GetStringWidth() or 70) + 24))
    trainBtn:SetPoint("RIGHT", anchor, "LEFT", -2, 0)

    trainBtn:SetScript("OnEnter", function(self)
        local list, affordable, total = Available()
        GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 4)
        GameTooltip:ClearLines()
        GameTooltip:AddLine(T("Tout apprendre", "Train all"), 1, 0.82, 0)
        if #list == 0 then
            GameTooltip:AddLine(T("Rien à apprendre pour l'instant.", "Nothing to learn right now."), 0.95, 0.92, 0.86)
        else
            GameTooltip:AddLine(string.format(T("%d compétence(s) pour %s", "%d skill(s) for %s"), affordable, Coins(total)), 0.95, 0.92, 0.86)
            if affordable < #list then
                GameTooltip:AddLine(string.format(T("%d autre(s) trop chère(s) pour l'instant.", "%d more you cannot afford yet."),
                    #list - affordable), 1, 0.4, 0.3)
            end
        end
        GameTooltip:Show()
    end)
    trainBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

    trainBtn:SetScript("OnClick", function()
        local list, affordable, total = Available()
        if affordable == 0 then return end
        -- Highest index first: buying never shifts the indices still to buy.
        local picks = {}
        for _, s in ipairs(list) do if s.ok then picks[#picks + 1] = s.index end end
        table.sort(picks, function(x, y) return x > y end)
        for _, i in ipairs(picks) do BuyTrainerService(i) end
        print(PREFIX .. string.format(T("%d compétence(s) apprise(s) pour %s.", "%d skill(s) learned for %s."),
            affordable, Coins(total)))
    end)

    if type(_G.ClassTrainerFrame_Update) == "function" then
        hooksecurefunc("ClassTrainerFrame_Update", RefreshTrainButton)
    end
    ClassTrainerFrame:HookScript("OnShow", RefreshTrainButton)
    events:RegisterEvent("TRAINER_UPDATE")
    events:RegisterEvent("PLAYER_MONEY")
    RefreshTrainButton()
end

local function IsTrainerLoaded()
    if C_AddOns and C_AddOns.IsAddOnLoaded then return C_AddOns.IsAddOnLoaded("Blizzard_TrainerUI") end
    return IsAddOnLoaded and IsAddOnLoaded("Blizzard_TrainerUI")
end

-- ---------------------------------------------------------------------
-- Public
-- ---------------------------------------------------------------------
function AT.Apply()
    local db = DB()
    if not db then return end
    if db.autoRes then events:RegisterEvent("RESURRECT_REQUEST")
    else events:UnregisterEvent("RESURRECT_REQUEST") end
    ApplyErrors()
    if db.trainAll and not trainBtn and IsTrainerLoaded() then CreateTrainButton() end
    RefreshTrainButton()
end

function AT.Initialize()
    if not DB() then return end
    events:RegisterEvent("ADDON_LOADED")
    events:SetScript("OnEvent", function(_, event, ...)
        if event == "UI_ERROR_MESSAGE" then
            ForwardError(...)
        elseif event == "RESURRECT_REQUEST" then
            OnResurrectRequest(...)
        elseif event == "TRAINER_UPDATE" or event == "PLAYER_MONEY" then
            RefreshTrainButton()
        elseif event == "ADDON_LOADED" then
            if ... == "Blizzard_TrainerUI" then
                local db = DB()
                if db and db.trainAll then CreateTrainButton() end
            end
        end
    end)
    AT.Apply()
end
