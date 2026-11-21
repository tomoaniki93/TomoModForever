-- =====================================================================
-- Modules/QOL/Forever/QuestReward.lua -- most valuable quest reward (1.3.6)
--
-- When a quest lets you choose a reward (quest window at the NPC, quest
-- log, map details), a small purse sits on the choice that sells for the
-- most at a vendor, its count included. Handy when none of them is for you.
--
-- The game lays the rewards out in QuestInfo_Display: a post-hook reads
-- the shown choice buttons' item links and puts the purse on a texture of
-- our own on the button. Nothing of Blizzard's is written. An item the
-- client has not cached yet is read again when its data arrives.
-- =====================================================================

TomoMod_QuestReward = TomoMod_QuestReward or {}
local QR = TomoMod_QuestReward

local COIN = "Interface\\Icons\\INV_Misc_Coin_02"

local function DB() return TomoModForeverDB and TomoModForeverDB.questReward end

local purses = {}       -- button -> texture
local waiting = false

local function Purse(button)
    local t = purses[button]
    if t then return t end
    t = button:CreateTexture(nil, "OVERLAY", nil, 7)
    local icon = button.Icon or button.icon or (button.GetName and button:GetName() and _G[button:GetName() .. "IconTexture"])
    local size = 16
    if C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo("Banker") then
        t:SetAtlas("Banker")
    else
        t:SetTexture(COIN)
        t:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        size = 14
    end
    t:SetSize(size, size)
    t:SetPoint("BOTTOMRIGHT", icon or button, "BOTTOMRIGHT", 3, -3)
    t:Hide()
    purses[button] = t
    return t
end

local function HideAll()
    for _, t in pairs(purses) do t:Hide() end
end

-- Shown choice buttons of a rewards frame.
local function ChoiceButtons(frame)
    local list = {}
    if not frame then return list end
    local buttons = frame.RewardButtons
    if type(buttons) ~= "table" then
        buttons = {}
        local i = 1
        while _G["QuestInfoRewardsFrameQuestInfoItem" .. i] do
            buttons[i] = _G["QuestInfoRewardsFrameQuestInfoItem" .. i]
            i = i + 1
        end
    end
    for _, b in ipairs(buttons) do
        if b:IsShown() and b.type == "choice" then list[#list + 1] = b end
    end
    return list
end

local function Price(link, count)
    if not link then return nil end
    local sell
    if C_Item and C_Item.GetItemInfo then
        sell = select(11, C_Item.GetItemInfo(link))
    elseif GetItemInfo then
        sell = select(11, GetItemInfo(link))
    end
    if sell == nil then return nil end
    return sell * math.max(count or 1, 1)
end

local function ChoiceLink(fromLog, index)
    if fromLog then
        return GetQuestLogItemLink and GetQuestLogItemLink("choice", index)
    end
    return GetQuestItemLink and GetQuestItemLink("choice", index)
end

local function ChoiceCount(fromLog, index)
    if fromLog then
        if GetQuestLogChoiceInfo then return select(3, GetQuestLogChoiceInfo(index)) end
        return 1
    end
    if GetQuestItemInfo then return select(3, GetQuestItemInfo("choice", index)) end
    return 1
end

local function Mark(frame, fromLog)
    local buttons = ChoiceButtons(frame)
    if #buttons < 2 then return end
    local best, bestValue, missing = nil, 0, false
    for _, b in ipairs(buttons) do
        local index = b.GetID and b:GetID() or 0
        local value = Price(ChoiceLink(fromLog, index), ChoiceCount(fromLog, index))
        if value == nil then
            missing = true
        elseif value > bestValue then
            best, bestValue = b, value
        end
    end
    if best then Purse(best):Show() end
    if missing then waiting = true end
end

local function Update()
    HideAll()
    local db = DB()
    if not (db and db.enabled) then return end
    waiting = false
    local fromLog = QuestInfoFrame and QuestInfoFrame.questLog and true or false
    Mark(_G.QuestInfoRewardsFrame, fromLog)
    -- The map's quest details use their own rewards frame (always the log).
    if _G.MapQuestInfoRewardsFrame and _G.MapQuestInfoRewardsFrame:IsVisible() then
        Mark(_G.MapQuestInfoRewardsFrame, true)
    end
end

function QR.ApplySettings() Update() end

function QR.SetEnabled(v)
    local db = DB()
    if db then db.enabled = v and true or false end
    Update()
end

local hooked = false
function QR.Initialize()
    if not DB() or hooked then return end
    if type(QuestInfo_Display) ~= "function" then return end
    hooksecurefunc("QuestInfo_Display", function() Update() end)
    hooked = true
    local f = CreateFrame("Frame")
    f:RegisterEvent("GET_ITEM_INFO_RECEIVED")
    f:SetScript("OnEvent", function()
        if waiting then Update() end
    end)
end
