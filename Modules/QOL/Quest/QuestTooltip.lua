-- =====================================================================
-- Modules/QOL/Quest/QuestTooltip.lua -- quest progress in tooltips
--
-- Hovering a monster or an item that a quest of your log asks for adds
-- the quest and where you stand:
--
--     Les loups de la forêt
--       Loup des bois tué : 3/8
--
-- How the match is made: each objective of the log ("Loup des bois tué :
-- 3/8") is cut back to the name it counts ("Loup des bois") with the
-- game's own objective strings (QUEST_MONSTERS_KILLED, QUEST_ITEMS_NEEDED,
-- QUEST_OBJECTS_FOUND) turned into patterns, so every client language
-- works. The tooltip's monster or item name must equal that name (case
-- aside): no guess, no false match on a monster whose name is part of
-- another one's. Every quest of the log counts, watched or not.
--
-- The index is rebuilt when the quest log changes (coalesced). Lines go in
-- through TooltipDataProcessor post-calls; names the game hands out as
-- secret values are skipped. When Questie adds its own quest tooltips,
-- TMF stands down so the lines are not doubled.
-- =====================================================================

TomoMod_QuestTooltip = TomoMod_QuestTooltip or {}
local QT = TomoMod_QuestTooltip

local GOLD  = { 1.000, 0.820, 0.000 }
local TEXT  = { 0.900, 0.880, 0.830 }
local GREEN = { 0.450, 0.850, 0.400 }
local MAX_QUESTS = 4

local function DB() return TomoModForeverDB and TomoModForeverDB.questTooltip end

local function Plain(v)
    if issecretvalue and issecretvalue(v) then return nil end
    return v
end

local function QuestieOwns()
    local C = TomoMod_Compat
    return C and C.QuestieOwnsTooltips and C.QuestieOwnsTooltips() or false
end

-- ---------------------------------------------------------------------
-- Objective text -> counted name
-- ---------------------------------------------------------------------
local function FormatToPattern(fmt)
    if type(fmt) ~= "string" or fmt == "" then return nil end
    local p = fmt:gsub("%%%%", "\002")
    p = p:gsub("%%%d?%$?([sd])", "\001%1")
    p = p:gsub("([%%%(%)%.%[%]%*%+%-%?%^%$])", "%%%1")
    p = p:gsub("\001s", "(.-)"):gsub("\001d", "%%d+"):gsub("\002", "%%%%")
    return "^" .. p .. "$"
end

local patterns
local function BuildPatterns()
    patterns = {}
    for _, key in ipairs({ "QUEST_MONSTERS_KILLED", "QUEST_ITEMS_NEEDED", "QUEST_OBJECTS_FOUND",
                           "QUEST_PLAYERS_KILLED" }) do
        local pat = FormatToPattern(rawget(_G, key))
        if pat then patterns[#patterns + 1] = pat end
    end
    -- Last resort: "Name: 3/8" / "Name : 3/8".
    patterns[#patterns + 1] = "^(.-)%s*:%s*%d+%s*/%s*%d+%s*$"
end

local function ObjectiveName(text)
    if not patterns then BuildPatterns() end
    for _, pat in ipairs(patterns) do
        local name = text:match(pat)
        if name and name ~= "" then
            return (name:gsub("^%s+", ""):gsub("%s+$", ""))
        end
    end
    return nil
end
QT._ObjectiveName = ObjectiveName

-- ---------------------------------------------------------------------
-- Index: lower(name) -> { { title, text, done }, ... }
-- ---------------------------------------------------------------------
local index = {}

local function Rebuild()
    wipe(index)
    if not (C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo
            and C_QuestLog.GetQuestObjectives) then return end
    local n = C_QuestLog.GetNumQuestLogEntries() or 0
    for i = 1, n do
        local info = C_QuestLog.GetInfo(i)
        local id = info and not info.isHeader and info.questID
        local title = info and Plain(info.title)
        if id and id > 0 and type(title) == "string" then
            local ok, objs = pcall(C_QuestLog.GetQuestObjectives, id)
            if ok and type(objs) == "table" then
                for _, o in ipairs(objs) do
                    local text = Plain(o.text)
                    if type(text) == "string" and text ~= "" then
                        local name = ObjectiveName(text)
                        if name then
                            local key = name:lower()
                            local list = index[key]
                            if not list then list = {}; index[key] = list end
                            list[#list + 1] = { title = title, text = text, done = o.finished and true or false }
                        end
                    end
                end
            end
        end
    end
end
QT._Rebuild = Rebuild
QT._index = index

local queued = false
local function QueueRebuild()
    if queued then return end
    queued = true
    C_Timer.After(0.5, function() queued = false; Rebuild() end)
end

-- ---------------------------------------------------------------------
-- Tooltip lines
-- ---------------------------------------------------------------------
local function AddLines(tooltip, name)
    name = Plain(name)
    if type(name) ~= "string" or name == "" then return false end
    local list = index[name:lower()]
    if not list then return false end
    local db = DB()
    local added, quests, lastTitle = false, 0, nil
    for _, e in ipairs(list) do
        if not e.done or db.showDone ~= false then
            if e.title ~= lastTitle then
                quests = quests + 1
                if quests > MAX_QUESTS then break end
                if not added then tooltip:AddLine(" ") end
                tooltip:AddLine(e.title, GOLD[1], GOLD[2], GOLD[3])
                lastTitle = e.title
            end
            local c = e.done and GREEN or TEXT
            tooltip:AddLine("   " .. e.text, c[1], c[2], c[3])
            added = true
        end
    end
    return added
end

local function Usable(tooltip)
    local db = DB()
    if not (db and db.enabled) then return false end
    if tooltip.IsForbidden and tooltip:IsForbidden() then return false end
    if QuestieOwns() then return false end
    return true
end

local function OnUnit(tooltip)
    if tooltip ~= GameTooltip or not Usable(tooltip) then return end
    if DB().units == false then return end
    local ok, _, unit = pcall(tooltip.GetUnit, tooltip)
    if not ok or not unit then return end
    -- The token may be secret: it is only handed back to the game.
    local okP, isPlayer = pcall(UnitIsPlayer, unit)
    isPlayer = okP and Plain(isPlayer)
    if isPlayer ~= false then return end
    local okN, name = pcall(UnitName, unit)
    if okN and AddLines(tooltip, name) then tooltip:Show() end
end

local function ItemName(tooltip)
    local ok, name, link = pcall(tooltip.GetItem, tooltip)
    if not ok then return nil end
    name = Plain(name)
    if type(name) == "string" and name ~= "" then return name end
    link = Plain(link)
    if type(link) == "string" then return link:match("|h%[(.-)%]|h") end
end

local function OnItem(tooltip)
    if not Usable(tooltip) then return end
    if DB().items == false then return end
    if AddLines(tooltip, ItemName(tooltip)) then tooltip:Show() end
end

-- ---------------------------------------------------------------------
-- Public
-- ---------------------------------------------------------------------
function QT.ApplySettings() Rebuild() end

function QT.SetEnabled(v)
    local db = DB()
    if not db then return end
    db.enabled = v and true or false
    if v then Rebuild() end
end

local hooked = false
function QT.Initialize()
    if not DB() then return end
    BuildPatterns()
    if not hooked and TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall
       and Enum and Enum.TooltipDataType then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, OnUnit)
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnItem)
        hooked = true
    end
    local f = CreateFrame("Frame")
    f:RegisterEvent("QUEST_LOG_UPDATE")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", QueueRebuild)
    Rebuild()
end
