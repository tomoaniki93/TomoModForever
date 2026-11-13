-- =====================================================================
-- Modules/QOL/Forever/Triage.lua -- what to throw away, what to loot
--
-- Ranks the items of your bags from the cheapest to sell to the dearest,
-- so you know what to drop or sell first when the bags are full:
--
--   * In TomoMod's bags, a number on the cheapest items (1 = first to go),
--     when the bags are nearly full (or always, or never).
--   * In the loot window, with full bags, a gold coin on each item worth
--     more than the bag item it would replace: the dearest loot is paired
--     with your cheapest item, the next with the next, and so on. Loot that
--     fits on a stack you already carry needs no room and gets nothing.
--   * In tooltips: "To throw away #3" with the stack's vendor value, and on
--     loot, which bag item to drop for it.
--   * In the bag space banner: how many items can go.
--
-- Never ranked (never suggested): items pinned in TomoMod's bags (middle
-- click), quest items, items an objective of your quest log asks for,
-- items with no vendor price, ammunition, and anything above green.
-- Only regular bags count (not quivers, ammo pouches or soul bags).
-- =====================================================================

TomoMod_Triage = TomoMod_Triage or {}
local TR = TomoMod_Triage

local BAG_FIRST, BAG_LAST = 0, (NUM_BAG_SLOTS or 4)
local MAX_QUALITY = 2            -- grey, white, green
local CLASS_PROJECTILE = 6       -- arrows, bullets: a hunter needs them
local GOLD_ICON = "Interface\\MoneyFrame\\UI-GoldIcon"

local function T(fr, en) return (GetLocale() == "frFR") and fr or en end
local function DB() return TomoModForeverDB and TomoModForeverDB.triage end
local function Secret(v) return issecretvalue and issecretvalue(v) end
local function Plain(v) if Secret(v) then return nil end return v end

local function Coins(copper)
    copper = math.floor(copper or 0)
    if GetCoinTextureString then return GetCoinTextureString(copper) end
    local g, s, c = math.floor(copper / 10000), math.floor(copper / 100) % 100, copper % 100
    if g > 0 then return string.format("%dg %ds", g, s) end
    if s > 0 then return string.format("%ds %dc", s, c) end
    return c .. "c"
end
TR.Coins = Coins

-- ---------------------------------------------------------------------
-- Item facts
-- ---------------------------------------------------------------------
-- Vendor price per unit, class and max stack; nil until the client has the
-- item (GET_ITEM_INFO_RECEIVED then ranks again).
local function ItemFacts(item)
    if not (item and C_Item and C_Item.GetItemInfo) then return nil end
    local name, _, quality, _, _, _, _, maxStack, _, _, price, classID = C_Item.GetItemInfo(item)
    if Plain(name) == nil then return nil end
    return Plain(price) or 0, Plain(classID), Plain(maxStack) or 1, Plain(quality)
end

-- ---------------------------------------------------------------------
-- Items your quest log asks for (by name: objectives give no item ID)
-- ---------------------------------------------------------------------
local questNeeds = {}

local function ObjectiveItemName(text)
    if type(text) ~= "string" or Secret(text) then return nil end
    -- "Wolf Meat: 3/8", "Viande de loup : 3/8" (French puts a space before
    -- the colon) or "3/8 Wolf Meat". Spaces around the name are dropped.
    local name = text:match("^(.-)%s*:%s*%d+%s*/%s*%d+") or text:match("^%d+%s*/%s*%d+%s+(.+)$")
    name = name and name:match("^%s*(.-)%s*$")
    if name and name ~= "" then return name end
end

local function ScanQuestLog()
    wipe(questNeeds)
    if C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo and C_QuestLog.GetQuestObjectives then
        local n = C_QuestLog.GetNumQuestLogEntries() or 0
        for i = 1, n do
            local info = C_QuestLog.GetInfo(i)
            if info and not info.isHeader and info.questID then
                for _, o in ipairs(C_QuestLog.GetQuestObjectives(info.questID) or {}) do
                    if o.type == "item" and not o.finished then
                        local name = ObjectiveItemName(o.text)
                        if name then questNeeds[name] = true end
                    end
                end
            end
        end
    elseif GetNumQuestLogEntries and GetQuestLogLeaderBoard then
        local n = GetNumQuestLogEntries() or 0
        for i = 1, n do
            local objectives = GetNumQuestLeaderBoards and GetNumQuestLeaderBoards(i) or 0
            for o = 1, objectives do
                local text, kind, finished = GetQuestLogLeaderBoard(o, i)
                if kind == "item" and not finished then
                    local name = ObjectiveItemName(text)
                    if name then questNeeds[name] = true end
                end
            end
        end
    end
end

-- ---------------------------------------------------------------------
-- Ranking
-- ---------------------------------------------------------------------
local state = {
    dirty = true,
    ranked = {},       -- { bag, slot, link, itemID, count, value }, cheapest first
    rankOf = {},       -- ["bag:slot"] = rank
    free = 0, total = 0,
    stacks = {},       -- [itemID] = room left on stacks you carry
    pending = false,   -- some items were not loaded yet
}

local function IsPinned(itemID)
    local bags = TomoModForeverDB and TomoModForeverDB.bagsV4
    local pinned = bags and bags.pinned and bags.pinned.items
    return pinned and pinned[itemID] and true or false
end

local function Rebuild()
    state.dirty = false
    state.pending = false
    wipe(state.ranked)
    wipe(state.rankOf)
    wipe(state.stacks)
    state.free, state.total = 0, 0
    if not C_Container then return end

    for bag = BAG_FIRST, BAG_LAST do
        local slots = Plain(C_Container.GetContainerNumSlots(bag)) or 0
        local free, family = C_Container.GetContainerNumFreeSlots(bag)
        if slots > 0 and (Plain(family) or 0) == 0 then
            state.total = state.total + slots
            state.free = state.free + (Plain(free) or 0)
            for slot = 1, slots do
                local info = C_Container.GetContainerItemInfo(bag, slot)
                local itemID = info and Plain(info.itemID)
                if itemID then
                    local link = Plain(info.hyperlink) or itemID
                    local count = Plain(info.stackCount) or 1
                    local price, classID, maxStack, quality = ItemFacts(link)
                    if price == nil then
                        state.pending = true
                    else
                        if maxStack > count then
                            state.stacks[itemID] = (state.stacks[itemID] or 0) + (maxStack - count)
                        end
                        quality = Plain(info.quality) or quality or 0
                        local name = Plain(info.itemName) or (C_Item.GetItemNameByID and Plain(C_Item.GetItemNameByID(itemID)))
                        local questInfo = C_Container.GetContainerItemQuestInfo and C_Container.GetContainerItemQuestInfo(bag, slot)
                        local isQuest = Plain(info.isQuestItem) or (questInfo and (Plain(questInfo.isQuestItem) or Plain(questInfo.questID)))
                        local keep = isQuest or quality > MAX_QUALITY or price <= 0 or Plain(info.hasNoValue)
                            or classID == CLASS_PROJECTILE or IsPinned(itemID) or (name and questNeeds[name])
                        if not keep then
                            state.ranked[#state.ranked + 1] = {
                                bag = bag, slot = slot, link = link, itemID = itemID,
                                count = count, value = price * count, name = name,
                            }
                        end
                    end
                end
            end
        end
    end
    table.sort(state.ranked, function(a, b)
        if a.value ~= b.value then return a.value < b.value end
        if a.bag ~= b.bag then return a.bag < b.bag end
        return a.slot < b.slot
    end)
    for i, e in ipairs(state.ranked) do state.rankOf[e.bag .. ":" .. e.slot] = i end
end

local function Fresh()
    if state.dirty then Rebuild() end
    return state
end

-- Public: the rank of a bag slot (1 = cheapest), its entry.
function TR.RankOf(bag, slot)
    local s = Fresh()
    local r = s.rankOf[bag .. ":" .. slot]
    return r, r and s.ranked[r]
end

function TR.Count()
    local s = Fresh()
    local value = 0
    for _, e in ipairs(s.ranked) do value = value + e.value end
    return #s.ranked, value
end

local function NearlyFull(s)
    if s.free == 0 then return true end
    local alert = TomoModForeverDB and TomoModForeverDB.bagAlert
    local threshold = alert and alert.threshold or 90
    return s.total > 0 and (s.total - s.free) / s.total * 100 >= threshold
end

-- How many numbers the bags show right now (0 = none).
function TR.BadgeLimit()
    local db = DB()
    if not (db and db.enabled) or db.badges == "off" then return 0 end
    local s = Fresh()
    if db.badges ~= "always" and not NearlyFull(s) then return 0 end
    -- With the loot window open and full bags, every item paired with a loot.
    local limit = db.badgeCount or 5
    if state.lootPairs and #state.lootPairs > limit then limit = #state.lootPairs end
    return limit
end

-- ---------------------------------------------------------------------
-- Loot coins
-- ---------------------------------------------------------------------
local coins = {}           -- [loot button] = coin frame

local function LootEntries()
    local out = {}
    local n = GetNumLootItems and GetNumLootItems() or 0
    for slot = 1, n do
        local hasItem = LootSlotHasItem and LootSlotHasItem(slot)
        local link = hasItem and GetLootSlotLink and Plain(GetLootSlotLink(slot))
        if link then
            local _, _, qty, _, _, _, isQuestItem = GetLootSlotInfo(slot)
            qty = Plain(qty) or 1
            local itemID = C_Item.GetItemInfoInstant and Plain((C_Item.GetItemInfoInstant(link)))
            local price = ItemFacts(link)
            local fits = itemID and (state.stacks[itemID] or 0) >= qty
            out[#out + 1] = {
                slot = slot, link = link, qty = qty, fits = fits,
                quest = Plain(isQuestItem) and true or false,
                value = (price or 0) * qty,
            }
        end
    end
    return out
end

-- Dearest loot with your cheapest item, and so on; a loot worth more than
-- its pair (or needed by a quest) gets the coin.
local function PairLoot()
    state.lootPairs = nil
    state.lootBySlot = {}
    local db = DB()
    if not (db and db.enabled and db.lootCoins) then return end
    local s = Fresh()
    if s.free > 0 then return end
    local loot = {}
    for _, e in ipairs(LootEntries()) do
        if not e.fits then loot[#loot + 1] = e end
    end
    table.sort(loot, function(a, b)
        if a.quest ~= b.quest then return a.quest end
        return a.value > b.value
    end)
    state.lootPairs = {}
    for i, e in ipairs(loot) do
        local victim = s.ranked[i]
        e.victim = victim
        e.worth = e.quest or (victim ~= nil and e.value > victim.value)
        state.lootPairs[i] = e
        state.lootBySlot[e.slot] = e
    end
end

local function CoinFor(button)
    local c = coins[button]
    if c then return c end
    c = CreateFrame("Frame", nil, button)
    c:SetSize(16, 16)
    c:SetPoint("TOPLEFT", button, "TOPLEFT", -4, 4)
    c:SetFrameLevel(button:GetFrameLevel() + 5)
    local tex = c:CreateTexture(nil, "OVERLAY")
    tex:SetAllPoints()
    tex:SetTexture(GOLD_ICON)
    c:Hide()
    coins[button] = c
    return c
end

-- Loot buttons of the open loot window, with their loot slot: the classic
-- LootButton1..n (button.slot) or a scroll box of loot elements.
local function EachLootButton(callback)
    local i = 1
    while _G["LootButton" .. i] do
        local b = _G["LootButton" .. i]
        if b:IsShown() and b.slot then callback(b, b.slot) end
        i = i + 1
    end
    local box = LootFrame and LootFrame.ScrollBox
    if box and box.ForEachFrame then
        pcall(box.ForEachFrame, box, function(frame)
            local data = frame.GetElementData and frame:GetElementData()
            local slot = data and (data.slotIndex or data.slot)
            if slot then callback(frame.Item or frame, slot) end
        end)
    end
end

local function RefreshCoins()
    for _, c in pairs(coins) do c:Hide() end
    if not state.lootBySlot then return end
    EachLootButton(function(button, slot)
        local e = state.lootBySlot[slot]
        if e and e.worth then CoinFor(button):Show() end
    end)
end

local function RefreshBags()
    local bags = TomoMod_BagSkin
    local slots = bags and bags.Modules and bags.Modules.Slots
    if slots and slots.Refresh and bags.IsVisible and bags.IsVisible() then
        pcall(slots.Refresh, slots, false)
    end
end

local function OnLootChanged()
    state.dirty = true
    PairLoot()
    RefreshCoins()
    RefreshBags()
end

local function OnLootClosed()
    state.lootPairs, state.lootBySlot = nil, nil
    for _, c in pairs(coins) do c:Hide() end
    RefreshBags()
end

-- ---------------------------------------------------------------------
-- Tooltips
-- ---------------------------------------------------------------------
local GOLD = { 1, 0.82, 0 }
local GREY = { 0.72, 0.72, 0.72 }

local function AddBagLine(tip, bag, slot)
    local db = DB()
    if not (db and db.enabled and db.tooltip) then return end
    local rank, e = TR.RankOf(bag, slot)
    if rank then
        tip:AddLine(string.format(T("À jeter n°%d  -  %s", "To throw away #%d  -  %s"), rank, Coins(e.value)), GOLD[1], GOLD[2], GOLD[3])
        tip:Show()
    end
end

local function AddLootLine(tip, slot)
    local db = DB()
    if not (db and db.enabled and db.tooltip and state.lootBySlot) then return end
    local e = state.lootBySlot[slot]
    if not e then return end
    if e.victim then
        local name = e.victim.name or e.victim.link
        if e.worth then
            tip:AddLine(string.format(T("Vaut le coup : jette %s (%s)", "Worth it: drop %s (%s)"), tostring(name), Coins(e.victim.value)), GOLD[1], GOLD[2], GOLD[3], true)
        else
            tip:AddLine(string.format(T("Vaut moins que %s (%s)", "Worth less than %s (%s)"), tostring(name), Coins(e.victim.value)), GREY[1], GREY[2], GREY[3], true)
        end
    elseif e.quest then
        tip:AddLine(T("Objet de quête : fais de la place", "Quest item: make room"), GOLD[1], GOLD[2], GOLD[3])
    end
    tip:Show()
end

-- ---------------------------------------------------------------------
-- Settings and events
-- ---------------------------------------------------------------------
function TR.ApplySettings()
    state.dirty = true
    if GetNumLootItems and (GetNumLootItems() or 0) > 0 then OnLootChanged() else RefreshBags() end
end

function TR.Initialize()
    if TR.initialized or not DB() then return end
    TR.initialized = true

    local f = CreateFrame("Frame")
    for _, e in ipairs({ "BAG_UPDATE", "BAG_UPDATE_DELAYED", "QUEST_LOG_UPDATE", "GET_ITEM_INFO_RECEIVED",
                         "LOOT_OPENED", "LOOT_SLOT_CLEARED", "LOOT_CLOSED", "PLAYER_ENTERING_WORLD" }) do
        pcall(f.RegisterEvent, f, e)
    end
    local questPending = false
    f:SetScript("OnEvent", function(_, event)
        if event == "QUEST_LOG_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
            -- The quest log fires in bursts: read it once per frame.
            if questPending then return end
            questPending = true
            C_Timer.After(0, function()
                questPending = false
                ScanQuestLog()
                state.dirty = true
            end)
        elseif event == "BAG_UPDATE" then
            state.dirty = true
        elseif event == "GET_ITEM_INFO_RECEIVED" then
            if state.pending then
                state.dirty = true
                RefreshBags()
            end
        elseif event == "BAG_UPDATE_DELAYED" then
            state.dirty = true
            if state.lootBySlot then OnLootChanged() end
        elseif event == "LOOT_OPENED" or event == "LOOT_SLOT_CLEARED" then
            -- After Blizzard has laid out its loot buttons.
            C_Timer.After(0, OnLootChanged)
        elseif event == "LOOT_CLOSED" then
            OnLootClosed()
        end
    end)

    if GameTooltip and GameTooltip.SetBagItem then
        hooksecurefunc(GameTooltip, "SetBagItem", function(tip, bag, slot) pcall(AddBagLine, tip, bag, slot) end)
    end
    if GameTooltip and GameTooltip.SetLootItem then
        hooksecurefunc(GameTooltip, "SetLootItem", function(tip, slot) pcall(AddLootLine, tip, slot) end)
    end
    -- Pinning in TomoMod's bags changes what can go.
    local bags = TomoMod_BagSkin
    local data = bags and bags.Modules and bags.Modules.Data
    if data and data.TogglePinned then
        hooksecurefunc(data, "TogglePinned", function() state.dirty = true end)
    end
end

-- For tests and /tmf triage.
function TR.Debug()
    local s = Fresh()
    local function P(...) print("|cffc9a252[TMF tri]|r", ...) end
    P(string.format("free %d / %d, ranked %d, waiting for item data: %s", s.free, s.total, #s.ranked, tostring(s.pending)))
    for i = 1, math.min(5, #s.ranked) do
        local e = s.ranked[i]
        P(string.format("#%d %s x%d = %s", i, tostring(e.name or e.link), e.count, Coins(e.value)))
    end
    local needs = {}
    for name in pairs(questNeeds) do needs[#needs + 1] = name end
    P("quest log asks for:", #needs > 0 and table.concat(needs, ", ") or "-")
end
