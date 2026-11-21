-- =====================================================================
-- ObjectiveTracker.lua — TMF quest tracker (1.3.5, full rewrite)
--
-- Up to 1.3.4 this file re-skinned Blizzard's Retail objective tracker:
-- it walked its frame tree, re-parented quest blocks into "buckets" and
-- coloured them by Retail quest classification (campaign, world quest,
-- legendary...). None of that exists on Forever, so every quest landed in
-- one bucket in log order, with colours that meant nothing, and the
-- re-parenting fought Blizzard's own layout (combat flicker, lost blocks).
--
-- 1.3.5 draws its own tracker straight from the quest log:
--   * sections: Pinned, Ready to turn in, then one per zone, the zone you
--     are in first; other zones fold by themselves (option)
--   * quests sorted inside a section by level, name, progress or distance
--   * colours that carry meaning only: the level follows the quest
--     difficulty colour, finished objectives turn green, failed is red
--   * quest item buttons (secure), with cooldown, charges and range
--   * clicks: open the quest, Shift link, Ctrl pin, right click menu;
--     a quick menu in the header for display and sort
--   * a header that is clamped to the screen: it can no longer be lost
--
-- Combat. Item buttons are SecureActionButtons parented to `root` (the
-- header), so `root` is protected in combat: it is never moved, resized,
-- shown or hidden then -- only its alpha changes. While an item button is
-- on screen a structural change waits for the end of the fight and only
-- the texts are refreshed in place.
--
-- Public API kept: Initialize, Enable, Disable, SetEnabled, ApplySettings,
-- ResetPosition, SetLocked, IsLocked, ToggleLock, ToggleMinimized,
-- ApplyPosition, SavePosition.
-- =====================================================================

TomoMod_ObjectiveTracker = TomoMod_ObjectiveTracker or {}
local OT = TomoMod_ObjectiveTracker
local L  = TomoMod_L

local FONT       = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local FONT_BOLD  = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-SemiBold.ttf"
local FONT_BLACK = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Bold.ttf"
local BAR_TEX    = "Interface\\AddOns\\TomoModForever\\Assets\\Textures\\tomoaniki"
local CHECK_TEX  = "Interface\\RaidFrame\\ReadyCheck-Ready"
local FAIL_TEX   = "Interface\\RaidFrame\\ReadyCheck-NotReady"

-- Forever palette
local C_GOLD   = { 0.788, 0.635, 0.322 }
local C_YELLOW = { 1.000, 0.820, 0.000 }
local C_TEXT   = { 0.949, 0.922, 0.859 }
local C_OBJ    = { 0.860, 0.835, 0.780 }
local C_DIM    = { 0.620, 0.585, 0.515 }
local C_BRONZE = { 0.380, 0.290, 0.170 }
local C_GREEN  = { 0.450, 0.850, 0.400 }
local C_RED    = { 0.950, 0.330, 0.270 }
local C_BG     = { 0.060, 0.050, 0.040 }

local HEADER_H  = 24
local PAD       = 8
local ITEM_SIZE = 24
local LEVEL_W   = 20

-- =====================================================================
-- SETTINGS
-- =====================================================================

local DEFAULTS = {
    enabled = true,
    width = 260,
    bgAlpha = 0.65,
    showBorder = true,
    hideWhenEmpty = true,
    headerFontSize = 13,
    categoryFontSize = 11,
    questFontSize = 12,
    objectiveFontSize = 11,
    maxQuestsShown = 0,
    maxHeight = 0,
    displayMode = "watched",    -- "watched" (journal check boxes) | "all"
    questSort = "level",        -- "level" | "name" | "progress" | "distance"
    zoneSort = "level",         -- "level" | "name" | "log"
    groupByZone = true,
    separateComplete = true,
    autoFoldZones = true,
    hideCompletedObjectives = false,
    showLevel = true,
    showTags = true,
    showProgressBar = true,
    titleByDifficulty = false,
    showTooltips = true,
    combatAlpha = 1,
    itemSide = "left",          -- "left" | "right"
    scale = 1.0,
}

local function S()
    return (TomoModForeverDB and TomoModForeverDB.objectiveTracker) or DEFAULTS
end

local function Opt(key)
    local v = S()[key]
    if v == nil then v = DEFAULTS[key] end
    return v
end

local function SetOpt(key, value)
    local db = TomoModForeverDB and TomoModForeverDB.objectiveTracker
    if db then db[key] = value end
end

-- Per-character state: pins, hidden quests, folded sections.
local function CS()
    if type(TomoModForeverCharDB) ~= "table" then TomoModForeverCharDB = {} end
    local c = TomoModForeverCharDB.questTracker
    if type(c) ~= "table" then
        c = {}
        TomoModForeverCharDB.questTracker = c
    end
    if type(c.pinned) ~= "table" then c.pinned = {} end
    if type(c.hidden) ~= "table" then c.hidden = {} end
    if type(c.folded) ~= "table" then c.folded = {} end
    return c
end

local function T(key, fallback)
    local v = L and L[key]
    if v == nil or v == key or v == "" then return fallback end
    return v
end

-- [1.3.6] Global animation level (TomoMod_Utils.AnimLevel).
local function AnimAny()
    local U = TomoMod_Utils
    return not (U and U.AnimAny) or U.AnimAny()
end

local function Secret(v)
    return issecretvalue ~= nil and issecretvalue(v) or false
end

local function QuestieOwnsTracker()
    return TomoMod_Compat and TomoMod_Compat.QuestieOwnsTracker
        and TomoMod_Compat.QuestieOwnsTracker() or false
end

-- =====================================================================
-- STRINGS / ZONES
-- =====================================================================

-- Sort key: lower case, accents folded, so "Élan" sorts with the E and
-- not after "Zèbre" (strcmputf8i folds case, not accents).
local FOLD = {
    ["à"]="a", ["á"]="a", ["â"]="a", ["ã"]="a", ["ä"]="a", ["å"]="a",
    ["À"]="a", ["Á"]="a", ["Â"]="a", ["Ã"]="a", ["Ä"]="a", ["Å"]="a",
    ["ç"]="c", ["Ç"]="c", ["ñ"]="n", ["Ñ"]="n", ["ß"]="ss",
    ["è"]="e", ["é"]="e", ["ê"]="e", ["ë"]="e", ["È"]="e", ["É"]="e", ["Ê"]="e", ["Ë"]="e",
    ["ì"]="i", ["í"]="i", ["î"]="i", ["ï"]="i", ["Ì"]="i", ["Í"]="i", ["Î"]="i", ["Ï"]="i",
    ["ò"]="o", ["ó"]="o", ["ô"]="o", ["õ"]="o", ["ö"]="o", ["Ò"]="o", ["Ó"]="o", ["Ô"]="o", ["Õ"]="o", ["Ö"]="o",
    ["ù"]="u", ["ú"]="u", ["û"]="u", ["ü"]="u", ["Ù"]="u", ["Ú"]="u", ["Û"]="u", ["Ü"]="u",
    ["ý"]="y", ["ÿ"]="y", ["Ý"]="y", ["œ"]="oe", ["Œ"]="oe", ["æ"]="ae", ["Æ"]="ae",
}
local keyCache = {}
local function SortKey(str)
    local k = keyCache[str]
    if k then return k end
    k = str:gsub("[\192-\223][\128-\191]", FOLD):lower()
    keyCache[str] = k
    return k
end

local function Cmp(a, b)
    a, b = SortKey(a or ""), SortKey(b or "")
    if a == b then return 0 end
    return a < b and -1 or 1
end

local function CurrentZone()
    local z = GetRealZoneText and GetRealZoneText()
    if not z or z == "" then z = GetZoneText and GetZoneText() end
    return z
end

local function MapZone()
    if not (C_Map and C_Map.GetBestMapForUnit and C_Map.GetMapInfo) then return nil end
    local id = C_Map.GetBestMapForUnit("player")
    local info = id and C_Map.GetMapInfo(id)
    return info and info.name
end

local function IsHere(zone, here, mapHere)
    if not zone then return false end
    return (here and Cmp(zone, here) == 0) or (mapHere and Cmp(zone, mapHere) == 0) or false
end

local function DifficultyColor(level)
    if level and level > 0 and GetQuestDifficultyColor then
        local c = GetQuestDifficultyColor(level)
        if c and c.r then return c.r, c.g, c.b end
    end
    return C_TEXT[1], C_TEXT[2], C_TEXT[3]
end

-- =====================================================================
-- QUEST LOG READING
-- =====================================================================

local function ParseCount(text)
    if type(text) ~= "string" then return nil end
    local have, need = text:match("(%d+)%s*/%s*(%d+)")
    return tonumber(have), tonumber(need)
end

local function ReadObjectives(questID, logIndex)
    local out = {}
    if C_QuestLog and C_QuestLog.GetQuestObjectives then
        local ok, objs = pcall(C_QuestLog.GetQuestObjectives, questID)
        if ok and type(objs) == "table" then
            for _, o in ipairs(objs) do
                local text = o.text
                if type(text) == "string" and text ~= "" and not Secret(text) then
                    local have, need = o.numFulfilled, o.numRequired
                    if Secret(have) or Secret(need) then have, need = nil, nil end
                    if not need or need == 0 then have, need = ParseCount(text) end
                    out[#out + 1] = {
                        text = text, done = o.finished and true or false,
                        have = have, need = need,
                    }
                end
            end
            return out
        end
    end
    if GetNumQuestLeaderBoards and GetQuestLogLeaderBoard and logIndex then
        local n = GetNumQuestLeaderBoards(logIndex) or 0
        for i = 1, n do
            local text, _, finished = GetQuestLogLeaderBoard(i, logIndex)
            if type(text) == "string" and text ~= "" and not Secret(text) then
                local have, need = ParseCount(text)
                out[#out + 1] = { text = text, done = finished and true or false, have = have, need = need }
            end
        end
    end
    return out
end

local function QuestTag(questID, group)
    local tag
    if C_QuestLog and C_QuestLog.GetQuestTagInfo then
        local ok, info = pcall(C_QuestLog.GetQuestTagInfo, questID)
        if ok and type(info) == "table" then
            local name = info.tagName
            if type(name) == "string" and name ~= "" and not Secret(name) then
                tag = name
            elseif info.isElite then
                tag = T("ot_tag_elite", "Elite")
            end
        end
    elseif GetQuestTagInfo then
        local ok, _, name = pcall(GetQuestTagInfo, questID)
        if ok and type(name) == "string" and name ~= "" then tag = name end
    end
    if group and group > 1 then
        if tag then
            tag = tag .. " " .. group
        else
            tag = string.format(T("ot_tag_group", "Group %d"), group)
        end
    end
    return tag
end

local function IsWatched(questID, logIndex)
    if C_QuestLog and C_QuestLog.GetQuestWatchType then
        return C_QuestLog.GetQuestWatchType(questID) ~= nil
    end
    if IsQuestWatched and logIndex then return IsQuestWatched(logIndex) and true or false end
    return true
end

local function QuestItem(logIndex, complete)
    if not (GetQuestLogSpecialItemInfo and logIndex) then return nil end
    local ok, link, icon, charges, showWhenComplete = pcall(GetQuestLogSpecialItemInfo, logIndex)
    if not ok or type(link) ~= "string" or Secret(link) then return nil end
    if complete and not showWhenComplete then return nil end
    local itemID = tonumber(link:match("item:(%d+)"))
    if not itemID then return nil end
    return { link = link, icon = icon, charges = charges, itemID = itemID, logIndex = logIndex }
end

local function Distance(questID)
    if not (C_QuestLog and C_QuestLog.GetDistanceSqToQuest) then return nil end
    local ok, d = pcall(C_QuestLog.GetDistanceSqToQuest, questID)
    if ok and type(d) == "number" and not Secret(d) and d > 0 then return d end
    return nil
end

local function IsTrue(v) return v == true or v == 1 end

local function MakeQuest(id, logIndex, title, level, group, zone, zoneOrder, isComplete)
    if Secret(title) or type(title) ~= "string" or title == "" then title = "#" .. id end
    local q = {
        id = id, logIndex = logIndex, title = title,
        level = tonumber(level) or 0, group = tonumber(group) or 0,
        zone = zone or T("ot_zone_other", "Other"), zoneOrder = zoneOrder or 0,
    }
    local complete, failed = IsTrue(isComplete), isComplete == -1
    if C_QuestLog and C_QuestLog.IsComplete then
        local ok, v = pcall(C_QuestLog.IsComplete, id)
        if ok and v == true then complete = true end
    end
    if C_QuestLog and C_QuestLog.IsFailed then
        local ok, v = pcall(C_QuestLog.IsFailed, id)
        if ok and v == true then failed = true end
    end
    q.failed = failed
    q.complete = complete and not failed
    q.objectives = ReadObjectives(id, logIndex)

    local have, need, counted = 0, 0, false
    for _, o in ipairs(q.objectives) do
        if o.need and o.need > 0 then
            have = have + math.min(o.have or 0, o.need)
            need = need + o.need
            counted = true
        else
            need = need + 1
            if o.done then have = have + 1 end
        end
    end
    q.counted = counted
    q.progress = (need > 0) and (have / need) or (q.complete and 1 or 0)
    if q.complete then q.progress = 1 end
    q.tag = QuestTag(id, q.group)
    q.watched = IsWatched(id, logIndex)
    q.item = QuestItem(logIndex, q.complete)
    return q
end

local function GatherLog()
    local quests, byID = {}, {}
    local zone, zoneOrder = nil, 0
    local function add(q)
        quests[#quests + 1] = q
        byID[q.id] = q
    end

    if C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo then
        local n = C_QuestLog.GetNumQuestLogEntries() or 0
        for i = 1, n do
            local info = C_QuestLog.GetInfo(i)
            if info then
                if info.isHeader then
                    zone, zoneOrder = info.title, zoneOrder + 1
                elseif info.questID and info.questID > 0 and not info.isHidden
                    and not info.isTask and not info.isBounty and not byID[info.questID] then
                    add(MakeQuest(info.questID, i, info.title, info.level,
                        info.suggestedGroup, zone, zoneOrder, info.isComplete))
                end
            end
        end
    elseif GetNumQuestLogEntries and GetQuestLogTitle then
        local n = GetNumQuestLogEntries() or 0
        for i = 1, n do
            local title, level, group, isHeader, _, isComplete, _, questID = GetQuestLogTitle(i)
            if isHeader then
                zone, zoneOrder = title, zoneOrder + 1
            elseif questID and questID > 0 and not byID[questID] then
                add(MakeQuest(questID, i, title, level, group, zone, zoneOrder, isComplete))
            end
        end
    end
    return quests, byID
end

-- =====================================================================
-- MODEL (sections + sorted quests)
-- =====================================================================

local function QuestLess(mode)
    return function(a, b)
        if mode == "name" then
            local c = Cmp(a.title, b.title)
            if c ~= 0 then return c < 0 end
        elseif mode == "progress" then
            if a.progress ~= b.progress then return a.progress > b.progress end
        elseif mode == "distance" then
            local da, db = a.distance or math.huge, b.distance or math.huge
            if da ~= db then return da < db end
        end
        if a.level ~= b.level then return a.level < b.level end
        local c = Cmp(a.title, b.title)
        if c ~= 0 then return c < 0 end
        return a.id < b.id
    end
end

local function BuildModel()
    local quests = GatherLog()
    local cs = CS()
    local mode = Opt("displayMode")
    local here, mapHere = CurrentZone(), MapZone()
    local sortMode = Opt("questSort")
    local useDistance = sortMode == "distance"

    local visible, hidden = {}, 0
    for _, q in ipairs(quests) do
        -- "watched" follows the check boxes of the quest log: unticking a
        -- quest there removes it here, a pin only moves it to the top.
        local show
        if mode == "watched" then
            show = q.watched
        else
            show = cs.pinned[q.id] or not cs.hidden[q.id]
        end
        if show then
            if useDistance then q.distance = Distance(q.id) end
            visible[#visible + 1] = q
        else
            hidden = hidden + 1
        end
    end

    local pinned, complete, rest = {}, {}, {}
    local separate = Opt("separateComplete")
    for _, q in ipairs(visible) do
        if cs.pinned[q.id] then
            pinned[#pinned + 1] = q
        elseif separate and q.complete then
            complete[#complete + 1] = q
        else
            rest[#rest + 1] = q
        end
    end

    local less = QuestLess(sortMode)
    local sections = {}
    local function section(key, kind, label, list, color)
        table.sort(list, less)
        sections[#sections + 1] = { key = key, kind = kind, label = label, quests = list, color = color }
        return sections[#sections]
    end

    if #pinned > 0 then section("_pinned", "pinned", T("ot_section_pinned", "Pinned"), pinned, C_YELLOW) end
    if #complete > 0 then section("_complete", "complete", T("ot_section_complete", "Ready to turn in"), complete, C_GREEN) end

    if Opt("groupByZone") then
        local zones, order = {}, {}
        for _, q in ipairs(rest) do
            local z = zones[q.zone]
            if not z then
                z = { name = q.zone, quests = {}, minL = 999, maxL = 0, order = q.zoneOrder,
                      here = IsHere(q.zone, here, mapHere) }
                zones[q.zone] = z
                order[#order + 1] = z
            end
            z.quests[#z.quests + 1] = q
            if q.level > 0 then
                if q.level < z.minL then z.minL = q.level end
                if q.level > z.maxL then z.maxL = q.level end
            end
        end
        local zs = Opt("zoneSort")
        table.sort(order, function(a, b)
            if zs ~= "log" and a.here ~= b.here then return a.here end
            if zs == "level" and a.minL ~= b.minL then return a.minL < b.minL end
            if zs == "log" and a.order ~= b.order then return a.order < b.order end
            local c = Cmp(a.name, b.name)
            if c ~= 0 then return c < 0 end
            return a.order < b.order
        end)
        for _, z in ipairs(order) do
            local s = section("z:" .. z.name, "zone", z.name, z.quests, z.here and C_YELLOW or C_GOLD)
            s.here = z.here
            if z.maxL > 0 then
                s.range = (z.minL == z.maxL) and tostring(z.minL) or (z.minL .. "-" .. z.maxL)
            end
        end
    elseif #rest > 0 then
        section("_all", "all", T("ot_section_quests", "Quests"), rest, C_GOLD)
    end

    return {
        sections = sections, total = #quests, shown = #visible, hidden = hidden,
        here = here, mapHere = mapHere,
    }
end

-- Auto-fold: a zone with no saved state is open only when you are in it.
-- Entering a new zone drops the saved state of every zone, so the
-- tracker re-centres on where you are; manual folds last until then.
local function IsFolded(sec)
    local cs = CS()
    if cs.minimized then return true end
    local f = cs.folded[sec.key]
    if f == nil then
        if sec.kind == "zone" and Opt("autoFoldZones") then return not sec.here end
        return false
    end
    return f
end

local function SyncAutoFold(model)
    local cs = CS()
    local here = model.here or model.mapHere
    if not here or here == "" then return end
    if cs.lastZone ~= here then
        cs.lastZone = here
        for key in pairs(cs.folded) do
            if type(key) == "string" and key:sub(1, 2) == "z:" then cs.folded[key] = nil end
        end
    end
end

-- =====================================================================
-- STATE
-- =====================================================================

local root, body, border, hdr, mover
local active        = false   -- tracker built and running
local isInitialized = false
local isUnlocked    = false
local state = {
    model        = nil,
    sig          = nil,
    scroll       = 0,
    itemsShown   = 0,
    needLayout   = false,
    needPosition = false,
    needBlizz    = false,
    needDisable  = false,
    emptyHidden  = false,
    rendered     = false,
    seen         = {},        -- questIDs drawn in the last pass
    wasComplete  = {},
}
local blockByID = {}
local RequestRefresh -- forward

-- =====================================================================
-- SMALL DRAWING HELPERS (no typed glyphs: the font may not carry them)
-- =====================================================================

local function SetColor(t, c, a) t:SetColorTexture(c[1], c[2], c[3], a or 1) end

-- Plus / minus drawn with two bars.
local function CreateFoldIcon(parent, size, color)
    local h = parent:CreateTexture(nil, "OVERLAY")
    h:SetSize(size, 2)
    SetColor(h, color)
    local v = parent:CreateTexture(nil, "OVERLAY")
    v:SetSize(2, size)
    SetColor(v, color)
    v:SetPoint("CENTER", h, "CENTER")
    return {
        h = h, v = v,
        SetPoint = function(self, ...) h:SetPoint(...) end,
        SetFolded = function(self, folded) v:SetShown(folded) end,
        SetColor = function(self, c, a) SetColor(h, c, a); SetColor(v, c, a) end,
    }
end

local function AddBorder(frame, color, alpha)
    local list = {}
    for _, info in ipairs({
        { "TOPLEFT", "TOPRIGHT", nil, 1 },
        { "BOTTOMLEFT", "BOTTOMRIGHT", nil, 1 },
        { "TOPLEFT", "BOTTOMLEFT", 1, nil },
        { "TOPRIGHT", "BOTTOMRIGHT", 1, nil },
    }) do
        local t = frame:CreateTexture(nil, "BORDER")
        SetColor(t, color, alpha)
        t:SetPoint(info[1])
        t:SetPoint(info[2])
        if info[3] then t:SetWidth(info[3]) end
        if info[4] then t:SetHeight(info[4]) end
        list[#list + 1] = t
    end
    return list
end

local function Font(fs, path, size, flags)
    fs:SetFont(path, size, flags or "OUTLINE")
    fs:SetShadowOffset(0, 0)
end

-- =====================================================================
-- QUEST ACTIONS
-- =====================================================================

local function SelectQuest(q)
    if C_QuestLog and C_QuestLog.SetSelectedQuest then
        C_QuestLog.SetSelectedQuest(q.id)
    elseif SelectQuestLogEntry then
        SelectQuestLogEntry(q.logIndex)
    end
end

local function OpenQuest(q)
    -- Clicking the quest that is already open closes the log again.
    if QuestMapFrame_OpenToQuestDetails then
        local open = WorldMapFrame and WorldMapFrame:IsShown()
            and QuestMapFrame_GetDetailQuestID and QuestMapFrame_GetDetailQuestID() == q.id
        if open then HideUIPanel(WorldMapFrame) return end
        pcall(QuestMapFrame_OpenToQuestDetails, q.id)
        return
    end
    if QuestLogFrame then
        local shown = QuestLogFrame:IsShown()
        if shown and GetQuestLogSelection and GetQuestLogSelection() == q.logIndex then
            HideUIPanel(QuestLogFrame)
            return
        end
        if QuestLog_OpenToQuest then
            pcall(QuestLog_OpenToQuest, q.logIndex)
            return
        end
        if not shown then ShowUIPanel(QuestLogFrame) end
        if QuestLog_SetSelection then
            pcall(QuestLog_SetSelection, q.logIndex)
        elseif SelectQuestLogEntry then
            SelectQuestLogEntry(q.logIndex)
        end
        if QuestLog_Update then pcall(QuestLog_Update) end
        return
    end
    if ToggleQuestLog then ToggleQuestLog() end
end

local function LinkQuest(q)
    local link
    if GetQuestLink then
        -- Modern clients take a questID, Classic ones a log index.
        local arg = (C_QuestLog and C_QuestLog.GetInfo) and q.id or q.logIndex
        local ok, l = pcall(GetQuestLink, arg)
        if ok and type(l) == "string" then link = l end
    end
    link = link or q.title
    local inserted = false
    if ChatEdit_InsertLink then inserted = ChatEdit_InsertLink(link) end
    if not inserted and ChatFrame_OpenChat then ChatFrame_OpenChat(link) end
end

local function CanShare(q)
    if not (IsInGroup and IsInGroup()) then return false end
    if C_QuestLog and C_QuestLog.IsPushableQuest then
        local ok, v = pcall(C_QuestLog.IsPushableQuest, q.id)
        return ok and v and true or false
    end
    return QuestLogPushQuest ~= nil
end

local function ShareQuest(q)
    SelectQuest(q)
    if QuestLogPushQuest then QuestLogPushQuest() end
end

local function AbandonQuest(q)
    SelectQuest(q)
    if C_QuestLog and C_QuestLog.SetAbandonQuest then
        C_QuestLog.SetAbandonQuest()
    elseif SetAbandonQuest then
        SetAbandonQuest()
    end
    local name = (GetAbandonQuestName and GetAbandonQuestName()) or q.title
    if StaticPopup_Show then StaticPopup_Show("ABANDON_QUEST", name) end
end

local function CanArrow()
    return C_SuperTrack and C_SuperTrack.SetSuperTrackedQuestID ~= nil
end

local function IsArrowed(q)
    return C_SuperTrack and C_SuperTrack.GetSuperTrackedQuestID
        and C_SuperTrack.GetSuperTrackedQuestID() == q.id
end

local function ToggleArrow(q)
    if not CanArrow() then return end
    C_SuperTrack.SetSuperTrackedQuestID(IsArrowed(q) and 0 or q.id)
end

local function TogglePin(q)
    local cs = CS()
    cs.pinned[q.id] = (not cs.pinned[q.id]) or nil
    RequestRefresh()
end

local function HideQuest(q)
    local cs = CS()
    cs.pinned[q.id] = nil
    if Opt("displayMode") == "watched" then
        if C_QuestLog and C_QuestLog.RemoveQuestWatch then
            C_QuestLog.RemoveQuestWatch(q.id)
        elseif RemoveQuestWatch then
            RemoveQuestWatch(q.logIndex)
        end
    else
        cs.hidden[q.id] = true
    end
    RequestRefresh()
end

local function Forget(questID)
    if not questID then return end
    local cs = CS()
    cs.pinned[questID], cs.hidden[questID] = nil, nil
    state.wasComplete[questID] = nil
end

-- =====================================================================
-- MENUS
-- =====================================================================

local function OpenMenu(owner, build)
    if not (MenuUtil and MenuUtil.CreateContextMenu) then return end
    MenuUtil.CreateContextMenu(owner, function(_, rootDesc) build(rootDesc) end)
end

local function QuestMenu(owner, q)
    OpenMenu(owner, function(m)
        m:CreateTitle(q.title)
        m:CreateButton(T("ot_menu_open", "Open in the quest log"), function() OpenQuest(q) end)
        m:CreateButton(CS().pinned[q.id] and T("ot_menu_unpin", "Unpin") or T("ot_menu_pin", "Pin to the top"),
            function() TogglePin(q) end)
        if CanArrow() then
            m:CreateButton(IsArrowed(q) and T("ot_menu_arrow_off", "Remove the arrow") or T("ot_menu_arrow", "Arrow to this quest"),
                function() ToggleArrow(q) end)
        end
        m:CreateButton(T("ot_menu_link", "Link in chat"), function() LinkQuest(q) end)
        if CanShare(q) then
            m:CreateButton(T("ot_menu_share", "Share with the group"), function() ShareQuest(q) end)
        end
        m:CreateButton(T("ot_menu_hide", "Hide from the tracker"), function() HideQuest(q) end)
        m:CreateDivider()
        m:CreateButton(T("ot_menu_abandon", "Abandon the quest..."), function() AbandonQuest(q) end)
    end)
end

local function SetAndRefresh(key, value)
    SetOpt(key, value)
    state.scroll = 0
    RequestRefresh()
end

local function FoldAll(folded)
    local cs = CS()
    cs.minimized = nil
    local model = state.model
    if model then
        for _, sec in ipairs(model.sections) do cs.folded[sec.key] = folded end
    end
    RequestRefresh()
end

local function QuickMenu(owner)
    OpenMenu(owner, function(m)
        m:CreateTitle(T("ot_qm_title", "Quest tracker"))

        local show = m:CreateButton(T("ot_qm_show", "Show"))
        for _, e in ipairs({
            { "watched", T("ot_qm_show_watched", "Quests ticked in the quest log") },
            { "all",     T("ot_qm_show_all", "Every quest, ignoring the quest log boxes") },
        }) do
            show:CreateRadio(e[2], function() return Opt("displayMode") == e[1] end,
                function() SetAndRefresh("displayMode", e[1]) end)
        end

        local sort = m:CreateButton(T("ot_qm_sort", "Sort quests"))
        local sorts = {
            { "level",    T("ot_sort_level", "By level") },
            { "name",     T("ot_sort_name", "By name (A-Z)") },
            { "progress", T("ot_sort_progress", "By progress") },
        }
        if C_QuestLog and C_QuestLog.GetDistanceSqToQuest then
            sorts[#sorts + 1] = { "distance", T("ot_sort_distance", "By distance") }
        end
        for _, e in ipairs(sorts) do
            sort:CreateRadio(e[2], function() return Opt("questSort") == e[1] end,
                function() SetAndRefresh("questSort", e[1]); OT.UpdateTicker() end)
        end

        local zsort = m:CreateButton(T("ot_qm_zones", "Zone order"))
        for _, e in ipairs({
            { "level", T("ot_zsort_level", "Current zone, then by level") },
            { "name",  T("ot_zsort_name", "Current zone, then by name") },
            { "log",   T("ot_zsort_log", "Quest log order") },
        }) do
            zsort:CreateRadio(e[2], function() return Opt("zoneSort") == e[1] end,
                function() SetAndRefresh("zoneSort", e[1]) end)
        end

        m:CreateDivider()
        for _, e in ipairs({
            { "groupByZone",             T("ot_qm_group", "Group by zone") },
            { "separateComplete",        T("ot_qm_complete", "Separate Ready to turn in section") },
            { "autoFoldZones",           T("ot_qm_autofold", "Fold the other zones automatically") },
            { "hideCompletedObjectives", T("ot_qm_hidedone", "Hide finished objectives") },
        }) do
            m:CreateCheckbox(e[2], function() return Opt(e[1]) and true or false end,
                function() SetAndRefresh(e[1], not Opt(e[1])) end)
        end

        m:CreateDivider()
        m:CreateButton(T("ot_qm_expand", "Expand all"), function() FoldAll(false) end)
        m:CreateButton(T("ot_qm_collapse", "Collapse all"), function() FoldAll(true) end)
        local nHidden = 0
        for _ in pairs(CS().hidden) do nHidden = nHidden + 1 end
        if nHidden > 0 then
            m:CreateButton(string.format(T("ot_qm_unhide", "Show hidden quests again (%d)"), nHidden), function()
                wipe(CS().hidden)
                RequestRefresh()
            end)
        end
        m:CreateDivider()
        m:CreateButton(T("ot_qm_move", "Move the tracker"), function() OT.SetLocked(false) end)
        if TomoMod_Config and TomoMod_Config.Toggle then
            m:CreateButton(T("ot_qm_options", "TMF options"), function() TomoMod_Config.Toggle() end)
        end
    end)
end

-- =====================================================================
-- TOOLTIP
-- =====================================================================

local function AnchorTooltip(owner)
    GameTooltip:SetOwner(owner, "ANCHOR_NONE")
    GameTooltip:ClearAllPoints()
    local cx = root:GetCenter()
    if cx and cx * root:GetEffectiveScale() > (UIParent:GetWidth() * UIParent:GetEffectiveScale()) / 2 then
        GameTooltip:SetPoint("TOPRIGHT", owner, "TOPLEFT", -(ITEM_SIZE + 12), 0)
    else
        GameTooltip:SetPoint("TOPLEFT", owner, "TOPRIGHT", ITEM_SIZE + 12, 0)
    end
end

local function QuestTooltip(owner, q)
    if not Opt("showTooltips") then return end
    AnchorTooltip(owner)
    local r, g, b = DifficultyColor(q.level)
    GameTooltip:AddLine(q.title, r, g, b, true)
    local sub = q.zone
    if q.level > 0 then sub = string.format(T("ot_level_zone", "Level %d - %s"), q.level, q.zone) end
    if q.tag then sub = sub .. "  -  " .. q.tag end
    GameTooltip:AddLine(sub, C_DIM[1], C_DIM[2], C_DIM[3], true)
    if #q.objectives > 0 then
        GameTooltip:AddLine(" ")
        for _, o in ipairs(q.objectives) do
            local c = o.done and C_GREEN or C_TEXT
            GameTooltip:AddLine(o.text, c[1], c[2], c[3], true)
        end
    end
    GameTooltip:AddLine(" ")
    local h = 0.55
    GameTooltip:AddLine(T("ot_hint_open", "Left click: open the quest"), h, h, h)
    GameTooltip:AddLine(T("ot_hint_link", "Shift click: link in chat"), h, h, h)
    GameTooltip:AddLine(T("ot_hint_pin", "Ctrl click: pin to the top"), h, h, h)
    GameTooltip:AddLine(T("ot_hint_menu", "Right click: more actions"), h, h, h)
    GameTooltip:Show()
end

-- =====================================================================
-- ROW POOLS
-- =====================================================================

local sectionPool, questPool, itemPool = {}, {}, {}
local sectionUsed, questUsed = 0, 0

local function ToggleSection(key)
    local cs = CS()
    local sec
    for _, s in ipairs(state.model and state.model.sections or {}) do
        if s.key == key then sec = s break end
    end
    if cs.minimized then
        cs.minimized = nil
        cs.folded[key] = false
    else
        cs.folded[key] = not (sec and IsFolded(sec))
    end
    RequestRefresh()
end

local function GetSectionRow(i)
    local r = sectionPool[i]
    if r then return r end
    r = CreateFrame("Button", nil, body)
    r:RegisterForClicks("LeftButtonUp")
    r.icon = CreateFoldIcon(r, 8, C_GOLD)
    r.icon:SetPoint("LEFT", r, "LEFT", 2, 0)
    r.here = r:CreateTexture(nil, "OVERLAY")
    r.here:SetSize(5, 5)
    SetColor(r.here, C_YELLOW)
    r.here:SetRotation(math.pi / 4)
    r.label = r:CreateFontString(nil, "OVERLAY")
    r.label:SetJustifyH("LEFT")
    r.label:SetWordWrap(false)
    r.right = r:CreateFontString(nil, "OVERLAY")
    r.right:SetJustifyH("RIGHT")
    r.right:SetPoint("RIGHT", r, "RIGHT", 0, 0)
    r.line = r:CreateTexture(nil, "ARTWORK")
    r.line:SetHeight(1)
    r.line:SetPoint("BOTTOMLEFT", r, "BOTTOMLEFT", 0, 0)
    r.line:SetPoint("BOTTOMRIGHT", r, "BOTTOMRIGHT", 0, 0)
    r:SetScript("OnClick", function(self) if self.key then ToggleSection(self.key) end end)
    r:SetScript("OnEnter", function(self) self.line:SetAlpha(1) end)
    r:SetScript("OnLeave", function(self) self.line:SetAlpha(0.45) end)
    sectionPool[i] = r
    return r
end

local function GetQuestBlock(i)
    local b = questPool[i]
    if b then return b end
    b = CreateFrame("Button", nil, body)
    b:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    b.hl = b:CreateTexture(nil, "BACKGROUND")
    b.hl:SetPoint("TOPLEFT", -4, 2)
    b.hl:SetPoint("BOTTOMRIGHT", 4, -2)
    SetColor(b.hl, C_GOLD, 0.10)
    b.hl:Hide()

    -- Gold pulse when the quest becomes ready to turn in.
    b.flash = b:CreateTexture(nil, "BACKGROUND", nil, 1)
    b.flash:SetAllPoints(b.hl)
    SetColor(b.flash, C_GREEN, 0.35)
    b.flash:SetAlpha(0)
    local ag = b.flash:CreateAnimationGroup()
    local a1 = ag:CreateAnimation("Alpha"); a1:SetFromAlpha(0); a1:SetToAlpha(1); a1:SetDuration(0.25); a1:SetOrder(1)
    local a2 = ag:CreateAnimation("Alpha"); a2:SetFromAlpha(1); a2:SetToAlpha(0); a2:SetDuration(0.9);  a2:SetOrder(2)
    ag:SetScript("OnFinished", function() b.flash:SetAlpha(0) end)
    b.flashAnim = ag

    -- Soft fade-in for a newly accepted quest.
    local fade = b:CreateAnimationGroup()
    local f1 = fade:CreateAnimation("Alpha"); f1:SetFromAlpha(0); f1:SetToAlpha(1); f1:SetDuration(0.35)
    b.fadeAnim = fade

    b.level = b:CreateFontString(nil, "OVERLAY")
    b.level:SetJustifyH("LEFT")
    b.level:SetWordWrap(false)
    b.title = b:CreateFontString(nil, "OVERLAY")
    b.title:SetJustifyH("LEFT")
    b.title:SetWordWrap(false)
    b.tag = b:CreateFontString(nil, "OVERLAY")
    b.tag:SetJustifyH("RIGHT")
    b.tag:SetWordWrap(false)
    b.mark = b:CreateTexture(nil, "OVERLAY")
    b.mark:SetSize(12, 12)

    b.bar = CreateFrame("StatusBar", nil, b)
    b.bar:SetStatusBarTexture(BAR_TEX)
    b.bar:SetStatusBarColor(C_GOLD[1], C_GOLD[2], C_GOLD[3], 0.9)
    b.bar:SetMinMaxValues(0, 1)
    b.bar:SetHeight(3)
    b.bar.bg = b.bar:CreateTexture(nil, "BACKGROUND")
    b.bar.bg:SetAllPoints()
    b.bar.bg:SetColorTexture(1, 1, 1, 0.08)

    b.lines = {}

    b:SetScript("OnClick", function(self, button)
        local q = self.quest
        if not q then return end
        if button == "RightButton" then
            QuestMenu(self, q)
        elseif IsShiftKeyDown() then
            LinkQuest(q)
        elseif IsControlKeyDown() then
            TogglePin(q)
        else
            OpenQuest(q)
        end
    end)
    b:SetScript("OnEnter", function(self)
        self.hl:Show()
        self.title:SetTextColor(C_YELLOW[1], C_YELLOW[2], C_YELLOW[3], 1)
        if self.quest then QuestTooltip(self, self.quest) end
    end)
    b:SetScript("OnLeave", function(self)
        self.hl:Hide()
        if self.titleColor then self.title:SetTextColor(unpack(self.titleColor)) end
        GameTooltip:Hide()
    end)
    questPool[i] = b
    return b
end

local function GetLine(b, i)
    local ln = b.lines[i]
    if ln then return ln end
    ln = {}
    ln.dot = b:CreateTexture(nil, "OVERLAY")
    ln.dot:SetSize(3, 3)
    ln.fs = b:CreateFontString(nil, "OVERLAY")
    ln.fs:SetJustifyH("LEFT")
    ln.fs:SetWordWrap(true)
    b.lines[i] = ln
    return ln
end

-- Fills a block and lays out its inside. Returns its height. Only touches
-- the block's own regions: safe in combat.
local function FillQuestBlock(b, q, width)
    local qSize, oSize = Opt("questFontSize"), Opt("objectiveFontSize")
    local titleH = qSize + 5
    b.quest = q

    local x = 0
    if Opt("showLevel") and q.level > 0 then
        Font(b.level, FONT_BOLD, qSize)
        b.level:SetText(q.level)
        b.level:SetTextColor(DifficultyColor(q.level))
        b.level:ClearAllPoints()
        b.level:SetPoint("TOPLEFT", b, "TOPLEFT", 0, -1)
        b.level:SetWidth(LEVEL_W + 4)
        b.level:Show()
        x = LEVEL_W + 4
    else
        b.level:Hide()
    end

    -- Right side: tag, or a check / cross for finished / failed quests.
    local rightW = 0
    b.mark:Hide()
    b.tag:Hide()
    if q.failed or (q.complete and not Opt("separateComplete")) then
        b.mark:SetTexture(q.failed and FAIL_TEX or CHECK_TEX)
        b.mark:ClearAllPoints()
        b.mark:SetPoint("TOPRIGHT", b, "TOPRIGHT", 0, -1)
        b.mark:Show()
        rightW = 16
    elseif Opt("showTags") and q.tag then
        Font(b.tag, FONT, math.max(qSize - 2, 8))
        b.tag:SetText(q.tag)
        b.tag:SetTextColor(C_DIM[1], C_DIM[2], C_DIM[3], 1)
        b.tag:ClearAllPoints()
        b.tag:SetPoint("TOPRIGHT", b, "TOPRIGHT", 0, -2)
        b.tag:Show()
        rightW = math.min(b.tag:GetStringWidth() + 6, width * 0.4)
        b.tag:SetWidth(rightW)
    end

    Font(b.title, FONT_BOLD, qSize)
    b.title:ClearAllPoints()
    b.title:SetPoint("TOPLEFT", b, "TOPLEFT", x, -1)
    b.title:SetWidth(math.max(width - x - rightW - 2, 40))
    b.title:SetText(q.title)
    local tc
    if q.failed then
        tc = { C_RED[1], C_RED[2], C_RED[3], 1 }
    elseif Opt("titleByDifficulty") then
        local r, g, bl = DifficultyColor(q.level)
        tc = { r, g, bl, 1 }
    else
        tc = { C_TEXT[1], C_TEXT[2], C_TEXT[3], 1 }
    end
    b.titleColor = tc
    b.title:SetTextColor(unpack(tc))

    local y = -titleH
    local indent = (x > 0) and x or 8

    if Opt("showProgressBar") and q.counted and not q.complete and not q.failed then
        b.bar:ClearAllPoints()
        b.bar:SetPoint("TOPLEFT", b, "TOPLEFT", indent, y + 1)
        b.bar:SetPoint("TOPRIGHT", b, "TOPRIGHT", 0, y + 1)
        b.bar:SetValue(q.progress)
        b.bar:Show()
        y = y - 4
    else
        b.bar:Hide()
    end

    -- Objective lines
    local lines = {}
    if q.failed then
        lines[1] = { text = T("ot_failed", "Failed"), color = C_RED }
    elseif q.complete then
        local text = T("ot_ready", "Ready to turn in")
        if GetQuestLogCompletionText and q.logIndex then
            local ok, t = pcall(GetQuestLogCompletionText, q.logIndex)
            if ok and type(t) == "string" and t ~= "" and not Secret(t) then text = t end
        end
        lines[1] = { text = text, color = C_GREEN }
    else
        local hideDone = Opt("hideCompletedObjectives")
        for _, o in ipairs(q.objectives) do
            if not (hideDone and o.done) then
                lines[#lines + 1] = { text = o.text, color = o.done and C_GREEN or C_OBJ, done = o.done }
            end
        end
    end

    local lineW = math.max(width - indent - 8, 40)
    for i, info in ipairs(lines) do
        local ln = GetLine(b, i)
        Font(ln.fs, FONT, oSize)
        ln.fs:SetWidth(lineW)
        ln.fs:SetText(info.text)
        ln.fs:SetTextColor(info.color[1], info.color[2], info.color[3], info.done and 0.8 or 1)
        ln.fs:ClearAllPoints()
        ln.fs:SetPoint("TOPLEFT", b, "TOPLEFT", indent + 8, y)
        ln.fs:Show()
        SetColor(ln.dot, info.done and C_GREEN or C_GOLD, info.done and 0.8 or 0.9)
        ln.dot:ClearAllPoints()
        ln.dot:SetPoint("TOPLEFT", b, "TOPLEFT", indent + 1, y - math.floor(oSize / 2))
        ln.dot:Show()
        local h = ln.fs:GetStringHeight()
        if not h or h < oSize then h = oSize + 1 end
        y = y - h - 2
    end
    for i = #lines + 1, #b.lines do
        b.lines[i].fs:Hide()
        b.lines[i].dot:Hide()
    end

    local height = -y + 2
    if q.item and height < ITEM_SIZE + 2 then height = ITEM_SIZE + 2 end
    return height
end

-- =====================================================================
-- QUEST ITEM BUTTONS (secure)
-- =====================================================================

local function GetItemButton(i)
    local b = itemPool[i]
    if b then return b end
    b = CreateFrame("Button", "TomoMod_QuestItemButton" .. i, root, "SecureActionButtonTemplate")
    b:SetSize(ITEM_SIZE, ITEM_SIZE)
    b:RegisterForClicks("AnyUp", "AnyDown")
    b:SetAttribute("type", "item")
    local bg = b:CreateTexture(nil, "BACKGROUND")
    bg:SetPoint("TOPLEFT", -1, 1)
    bg:SetPoint("BOTTOMRIGHT", 1, -1)
    SetColor(bg, C_BRONZE, 1)
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetAllPoints()
    b.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    b.cd = CreateFrame("Cooldown", nil, b, "CooldownFrameTemplate")
    b.cd:SetAllPoints()
    b.count = b:CreateFontString(nil, "OVERLAY")
    Font(b.count, FONT_BOLD, 10)
    b.count:SetPoint("BOTTOMRIGHT", 1, 0)
    local hl = b:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints()
    hl:SetColorTexture(1, 1, 1, 0.18)
    b:SetScript("OnEnter", function(self)
        if not self.link then return end
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetHyperlink(self.link)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    b:Hide()
    itemPool[i] = b
    return b
end

local function UpdateItemState()
    for _, b in ipairs(itemPool) do
        if b:IsShown() and b.logIndex then
            if GetQuestLogSpecialItemCooldown then
                local start, duration, enable = GetQuestLogSpecialItemCooldown(b.logIndex)
                if start and duration and not Secret(start) and not Secret(duration) then
                    if CooldownFrame_Set then
                        CooldownFrame_Set(b.cd, start, duration, enable)
                    else
                        b.cd:SetCooldown(start, duration)
                    end
                end
            end
            if IsQuestLogSpecialItemInRange then
                local r = IsQuestLogSpecialItemInRange(b.logIndex)
                if r == 0 then b.icon:SetVertexColor(0.9, 0.25, 0.25) else b.icon:SetVertexColor(1, 1, 1) end
            end
        end
    end
end

local itemTicker
local function UpdateItemTicker()
    local want = state.itemsShown > 0
    if want and not itemTicker then
        itemTicker = C_Timer.NewTicker(0.3, UpdateItemState)
    elseif not want and itemTicker then
        itemTicker:Cancel()
        itemTicker = nil
    end
end

-- Out of combat only.
local function PlaceItemButtons(placements)
    local side = Opt("itemSide")
    for i, p in ipairs(placements) do
        local b = GetItemButton(i)
        b:SetAttribute("item", "item:" .. p.item.itemID)
        b.link, b.logIndex = p.item.link, p.item.logIndex
        b.icon:SetTexture(p.item.icon)
        local charges = tonumber(p.item.charges)
        b.count:SetText((charges and charges > 1) and charges or "")
        b:ClearAllPoints()
        if side == "right" then
            b:SetPoint("TOPLEFT", root, "TOPRIGHT", 5, p.y)
        else
            b:SetPoint("TOPRIGHT", root, "TOPLEFT", -5, p.y)
        end
        b:Show()
    end
    for i = #placements + 1, #itemPool do
        local b = itemPool[i]
        b:Hide()
        b.link, b.logIndex = nil, nil
    end
    state.itemsShown = #placements
    UpdateItemState()
    UpdateItemTicker()
end

-- =====================================================================
-- LAYOUT
-- =====================================================================

local function Signature(model)
    local cs = CS()
    local parts = { cs.minimized and "m" or "", state.scroll }
    for _, sec in ipairs(model.sections) do
        parts[#parts + 1] = sec.key .. (IsFolded(sec) and "-" or "")
        if not IsFolded(sec) then
            for _, q in ipairs(sec.quests) do
                parts[#parts + 1] = q.id .. ":" .. #q.objectives .. (q.complete and "c" or "")
                    .. (q.failed and "f" or "") .. (q.item and "i" or "")
            end
        end
    end
    return table.concat(parts, "|")
end

local function ApplyAlpha()
    if not root then return end
    local a = 1
    if state.emptyHidden then
        a = 0
    elseif InCombatLockdown() then
        a = Opt("combatAlpha") or 1
    end
    root:SetAlpha(a)
end

local function SetEmptyHidden(hidden)
    state.emptyHidden = hidden
    hdr:EnableMouse(not hidden)
    hdr.menu:EnableMouse(not hidden)
    if hidden then body:Hide() end
    ApplyAlpha()
end

local function MaxBodyHeight()
    local m = Opt("maxHeight") or 0
    if m > 0 then return m end
    local bottom = root:GetBottom()
    if not bottom then return 600 end
    return math.max(bottom - 30, 120)
end

local function UpdateHeaderTexts(model)
    local cs = CS()
    hdr.fold:SetFolded(cs.minimized and true or false)
    local maxQ = (C_QuestLog and C_QuestLog.GetMaxNumQuestsCanAccept and C_QuestLog.GetMaxNumQuestsCanAccept())
        or MAX_QUESTLOG_QUESTS or 25
    hdr.count:SetText((model and model.total or 0) .. "/" .. maxQ)
end

local function Layout(model, inCombat)
    local width = Opt("width")
    local inner = width - PAD * 2
    local cs = CS()
    local catSize = Opt("categoryFontSize")
    local maxH = MaxBodyHeight()
    local maxQuests = Opt("maxQuestsShown") or 0

    for i = 1, sectionUsed do sectionPool[i]:Hide() end
    for i = 1, questUsed do
        local b = questPool[i]
        b:Hide()
        b.quest = nil
    end
    sectionUsed, questUsed = 0, 0
    wipe(blockByID)

    UpdateHeaderTexts(model)

    local y = -6
    local entry, overflow, drawnQuests = 0, 0, 0
    local placements, newSeen = {}, {}
    local full = false
    local firstPass = not state.rendered

    local function room(h) return (-y + h) <= maxH end

    if not cs.minimized then
        for _, sec in ipairs(model.sections) do
            local folded = IsFolded(sec)
            entry = entry + 1
            if entry > state.scroll and not full then
                local rowH = catSize + 8
                if room(rowH) then
                    sectionUsed = sectionUsed + 1
                    local r = GetSectionRow(sectionUsed)
                    r.key = sec.key
                    r:ClearAllPoints()
                    r:SetPoint("TOPLEFT", body, "TOPLEFT", PAD, y)
                    r:SetSize(inner, rowH)
                    r.icon:SetFolded(folded)
                    r.icon:SetColor(sec.color, 0.95)
                    Font(r.label, FONT_BLACK, catSize)
                    r.label:SetText(sec.label)
                    r.label:SetTextColor(sec.color[1], sec.color[2], sec.color[3], 1)
                    r.label:ClearAllPoints()
                    if sec.here then
                        r.here:ClearAllPoints()
                        r.here:SetPoint("LEFT", r, "LEFT", 15, 0)
                        r.here:Show()
                        r.label:SetPoint("LEFT", r, "LEFT", 25, 0)
                    else
                        r.here:Hide()
                        r.label:SetPoint("LEFT", r, "LEFT", 15, 0)
                    end
                    Font(r.right, FONT, math.max(catSize - 1, 8))
                    local right = tostring(#sec.quests)
                    if sec.range then right = sec.range .. "   " .. right end
                    r.right:SetText(right)
                    r.right:SetTextColor(C_DIM[1], C_DIM[2], C_DIM[3], 1)
                    r.label:SetPoint("RIGHT", r.right, "LEFT", -6, 0)
                    SetColor(r.line, sec.color, 0.35)
                    r.line:SetAlpha(0.45)
                    r:Show()
                    y = y - rowH - 3
                else
                    full = true
                end
            end
            if not folded then
                for _, q in ipairs(sec.quests) do
                    entry = entry + 1
                    if maxQuests > 0 and drawnQuests >= maxQuests then
                        overflow = overflow + 1
                    elseif entry <= state.scroll then
                        -- scrolled past
                    elseif full then
                        overflow = overflow + 1
                    else
                        questUsed = questUsed + 1
                        local b = GetQuestBlock(questUsed)
                        b:SetWidth(inner - 2)
                        local h = FillQuestBlock(b, q, inner - 2)
                        if room(h) then
                            b:ClearAllPoints()
                            b:SetPoint("TOPLEFT", body, "TOPLEFT", PAD + 2, y)
                            b:SetHeight(h)
                            b:Show()
                            blockByID[q.id] = b
                            newSeen[q.id] = true
                            drawnQuests = drawnQuests + 1
                            if not firstPass and not state.seen[q.id] and AnimAny() then b.fadeAnim:Play() end
                            if state.wasComplete[q.id] == false and q.complete and AnimAny() then b.flashAnim:Play() end
                            if q.item then
                                placements[#placements + 1] = { item = q.item, y = -HEADER_H + y }
                            end
                            y = y - h - 5
                        else
                            questUsed = questUsed - 1
                            b.quest = nil
                            full = true
                            overflow = overflow + 1
                        end
                    end
                end
            end
        end
    end

    -- Footer: what did not fit, or an empty-state line.
    local footer = body.footer
    if overflow > 0 then
        footer:SetText(string.format(T("ot_more", "%d more quest(s) - scroll to see them"), overflow))
        footer:ClearAllPoints()
        footer:SetPoint("TOPLEFT", body, "TOPLEFT", PAD, y - 2)
        footer:SetPoint("TOPRIGHT", body, "TOPRIGHT", -PAD, y - 2)
        footer:Show()
        y = y - footer:GetStringHeight() - 4
    elseif model.shown == 0 and not cs.minimized then
        footer:SetText(T("ot_empty", "No quest to show"))
        footer:ClearAllPoints()
        footer:SetPoint("TOPLEFT", body, "TOPLEFT", PAD, y - 2)
        footer:SetPoint("TOPRIGHT", body, "TOPRIGHT", -PAD, y - 2)
        footer:Show()
        y = y - footer:GetStringHeight() - 4
    else
        footer:Hide()
    end

    -- Remember completion states for the next flash.
    for _, sec in ipairs(model.sections) do
        for _, q in ipairs(sec.quests) do state.wasComplete[q.id] = q.complete end
    end
    state.seen = newSeen
    state.rendered = true
    state.overflow = overflow

    local bodyH = -y + 4
    local drawnSomething = sectionUsed > 0 or questUsed > 0 or footer:IsShown()
    if cs.minimized or not drawnSomething then
        body:Hide()
    else
        body:SetHeight(bodyH)
        body:Show()
    end

    -- Empty tracker: hide (by alpha, see header).
    local empty = model.shown == 0
    SetEmptyHidden(empty and Opt("hideWhenEmpty") and not isUnlocked)

    if inCombat then
        if #placements > 0 or state.itemsShown > 0 then state.needLayout = true end
    else
        PlaceItemButtons(placements)
    end

    if mover then
        mover:ClearAllPoints()
        mover:SetPoint("TOPLEFT", root, "TOPLEFT")
        mover:SetPoint("BOTTOMRIGHT", body:IsShown() and body or root, "BOTTOMRIGHT")
    end
end

-- In combat with item buttons on screen: refresh what each drawn block
-- says without moving anything.
local function UpdateInPlace(model)
    UpdateHeaderTexts(model)
    local width = Opt("width") - PAD * 2 - 2
    for _, sec in ipairs(model.sections) do
        for _, q in ipairs(sec.quests) do
            local b = blockByID[q.id]
            if b then
                local wasComplete = state.wasComplete[q.id]
                FillQuestBlock(b, q, width)
                if wasComplete == false and q.complete and AnimAny() then b.flashAnim:Play() end
                state.wasComplete[q.id] = q.complete
            end
        end
    end
end

local function Refresh()
    if not active or not root then return end
    local model = BuildModel()
    SyncAutoFold(model)
    state.model = model
    local sig = Signature(model)
    if InCombatLockdown() and state.itemsShown > 0 then
        UpdateInPlace(model)
        if sig ~= state.sig then state.needLayout = true end
        return
    end
    Layout(model, InCombatLockdown())
    state.sig = sig
end

local refreshQueued = false
local function RunQueuedRefresh()
    refreshQueued = false
    Refresh()
end

RequestRefresh = function()
    if refreshQueued then return end
    refreshQueued = true
    C_Timer.After(0.05, RunQueuedRefresh)
end
OT.Refresh = RequestRefresh

-- Distance sort re-sorts while you move (out of combat).
local distTicker
function OT.UpdateTicker()
    local want = active and Opt("questSort") == "distance"
        and C_QuestLog and C_QuestLog.GetDistanceSqToQuest ~= nil
    if want and not distTicker then
        distTicker = C_Timer.NewTicker(3, function()
            if not InCombatLockdown() then RequestRefresh() end
        end)
    elseif not want and distTicker then
        distTicker:Cancel()
        distTicker = nil
    end
end

local function ToggleMinimized()
    local cs = CS()
    cs.minimized = (not cs.minimized) or nil
    state.scroll = 0
    RequestRefresh()
end
OT.ToggleMinimized = ToggleMinimized

-- =====================================================================
-- FRAMES
-- =====================================================================

local function ApplyLook()
    if not root then return end
    local a = Opt("bgAlpha") or 0.65
    SetColor(root.bg, C_BG, math.min(a + 0.2, 1))
    SetColor(body.bg, C_BG, a)
    local showBorder = Opt("showBorder")
    for _, t in ipairs(border.lines) do t:SetShown(showBorder) end
    Font(hdr.title, FONT_BLACK, Opt("headerFontSize"))
    Font(hdr.count, FONT, math.max(Opt("headerFontSize") - 2, 8))
    Font(body.footer, FONT, math.max(Opt("objectiveFontSize") - 1, 8))
end

local function CreateFrames()
    if root then return end

    root = CreateFrame("Frame", "TomoMod_QuestTracker", UIParent)
    root:SetFrameStrata("LOW")
    root:SetFrameLevel(10)
    root:SetHeight(HEADER_H)
    root:SetClampedToScreen(true)
    root:SetMovable(true)
    root.bg = root:CreateTexture(nil, "BACKGROUND")
    root.bg:SetAllPoints()
    local accent = root:CreateTexture(nil, "ARTWORK")
    accent:SetHeight(1)
    accent:SetPoint("BOTTOMLEFT")
    accent:SetPoint("BOTTOMRIGHT")
    SetColor(accent, C_GOLD, 0.6)

    -- Header click area: left folds everything, right opens the quick menu.
    hdr = CreateFrame("Button", nil, root)
    hdr:SetAllPoints()
    hdr:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    hdr.fold = CreateFoldIcon(hdr, 9, C_GOLD)
    hdr.fold:SetPoint("LEFT", hdr, "LEFT", 9, 0)
    hdr.title = hdr:CreateFontString(nil, "OVERLAY")
    Font(hdr.title, FONT_BLACK, Opt("headerFontSize"))
    hdr.title:SetPoint("LEFT", hdr, "LEFT", 24, 0)
    hdr.title:SetTextColor(C_TEXT[1], C_TEXT[2], C_TEXT[3], 1)
    hdr.title:SetText(T("ot_header_title", "QUESTS"))
    hdr.count = hdr:CreateFontString(nil, "OVERLAY")
    Font(hdr.count, FONT, math.max(Opt("headerFontSize") - 2, 8))
    hdr.count:SetTextColor(C_DIM[1], C_DIM[2], C_DIM[3], 1)
    hdr:SetScript("OnClick", function(self, button)
        if button == "RightButton" then QuickMenu(self) else ToggleMinimized() end
    end)
    hdr:SetScript("OnEnter", function(self)
        hdr.fold:SetColor(C_YELLOW)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:AddLine(T("ot_qm_title", "Quest tracker"), C_GOLD[1], C_GOLD[2], C_GOLD[3])
        GameTooltip:AddLine(T("ot_hdr_hint_fold", "Left click: fold / unfold"), 0.7, 0.7, 0.7)
        GameTooltip:AddLine(T("ot_hdr_hint_menu", "Right click: display and sort"), 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    hdr:SetScript("OnLeave", function()
        hdr.fold:SetColor(C_GOLD)
        GameTooltip:Hide()
    end)

    -- Menu button: three dots drawn with textures.
    local menu = CreateFrame("Button", nil, hdr)
    menu:SetSize(20, HEADER_H)
    menu:SetPoint("RIGHT", hdr, "RIGHT", -4, 0)
    menu:SetFrameLevel(hdr:GetFrameLevel() + 2)
    menu.dots = {}
    for i = 1, 3 do
        local d = menu:CreateTexture(nil, "OVERLAY")
        d:SetSize(3, 3)
        d:SetPoint("CENTER", menu, "CENTER", (i - 2) * 5, 0)
        SetColor(d, C_GOLD)
        menu.dots[i] = d
    end
    menu:SetScript("OnClick", function(self) QuickMenu(self) end)
    menu:SetScript("OnEnter", function(self)
        for _, d in ipairs(self.dots) do SetColor(d, C_YELLOW) end
    end)
    menu:SetScript("OnLeave", function(self)
        for _, d in ipairs(self.dots) do SetColor(d, C_GOLD) end
    end)
    hdr.menu = menu
    hdr.count:SetPoint("RIGHT", menu, "LEFT", -2, 0)

    body = CreateFrame("Frame", nil, root)
    body:SetPoint("TOPLEFT", root, "BOTTOMLEFT", 0, 0)
    body:SetPoint("TOPRIGHT", root, "BOTTOMRIGHT", 0, 0)
    body:SetHeight(40)
    body.bg = body:CreateTexture(nil, "BACKGROUND")
    body.bg:SetAllPoints()
    body:EnableMouseWheel(true)
    body:SetScript("OnMouseWheel", function(_, delta)
        if InCombatLockdown() and state.itemsShown > 0 then return end
        local before = state.scroll
        state.scroll = math.max(0, state.scroll - delta)
        -- Stop when the end is already on screen.
        if delta < 0 and (state.overflow or 0) == 0 then state.scroll = before end
        if state.scroll ~= before then Refresh() end
    end)
    body.footer = body:CreateFontString(nil, "OVERLAY")
    Font(body.footer, FONT, math.max(Opt("objectiveFontSize") - 1, 8))
    body.footer:SetJustifyH("LEFT")
    body.footer:SetTextColor(C_DIM[1], C_DIM[2], C_DIM[3], 1)

    -- Border around header and body together.
    border = CreateFrame("Frame", nil, root)
    border:SetPoint("TOPLEFT", root, "TOPLEFT", 0, 0)
    border:SetPoint("BOTTOMRIGHT", body, "BOTTOMRIGHT", 0, 0)
    border:SetFrameLevel(root:GetFrameLevel() + 5)
    border.lines = AddBorder(border, C_BRONZE, 0.85)
    body:HookScript("OnHide", function()
        border:ClearAllPoints()
        border:SetPoint("TOPLEFT", root, "TOPLEFT")
        border:SetPoint("BOTTOMRIGHT", root, "BOTTOMRIGHT")
    end)
    body:HookScript("OnShow", function()
        border:ClearAllPoints()
        border:SetPoint("TOPLEFT", root, "TOPLEFT")
        border:SetPoint("BOTTOMRIGHT", body, "BOTTOMRIGHT")
    end)

    -- Item buttons are created on the first out-of-combat layout, so the
    -- pool exists before any fight.
    ApplyLook()
end

-- =====================================================================
-- BLIZZARD TRACKER
-- =====================================================================

local hiddenParent
local origParents = {}
local blizzHidden = false

local function BlizzardTrackers()
    local list = {}
    for _, name in ipairs({ "ObjectiveTrackerFrame", "QuestWatchFrame", "WatchFrame" }) do
        local f = rawget(_G, name)
        if type(f) == "table" and f.SetParent then list[#list + 1] = f end
    end
    return list
end

-- The game puts its tracker back in the screen's managed-frame container
-- (SetParent) whenever that layout is rebuilt, e.g. on quest turn-in or
-- accept: it then showed over ours. A hook sends it back to the hidden
-- parent, and it stays transparent while hidden as a second guard.
local hooked = setmetatable({}, { __mode = "k" })
local reparenting = false

local function SendBack(f)
    if not blizzHidden or reparenting then return end
    if InCombatLockdown() then state.needBlizz = true return end
    if f:GetParent() ~= hiddenParent then
        reparenting = true
        f:SetParent(hiddenParent)
        reparenting = false
    end
end

local function HookTracker(f)
    if hooked[f] then return end
    hooked[f] = true
    hooksecurefunc(f, "SetParent", function(self, parent)
        if reparenting or not blizzHidden or parent == hiddenParent then return end
        origParents[self] = parent or origParents[self]
        C_Timer.After(0, function() SendBack(self) end)
    end)
    if f.HookScript then
        f:HookScript("OnShow", function(self)
            if blizzHidden then C_Timer.After(0, function() SendBack(self) end) end
        end)
    end
end

local function HideBlizzardTracker()
    if InCombatLockdown() then state.needBlizz = true return end
    hiddenParent = hiddenParent or CreateFrame("Frame")
    hiddenParent:Hide()
    for _, f in ipairs(BlizzardTrackers()) do
        local parent = f:GetParent()
        if origParents[f] == nil and parent ~= hiddenParent then origParents[f] = parent or UIParent end
        HookTracker(f)
        if parent ~= hiddenParent then
            reparenting = true
            f:SetParent(hiddenParent)
            reparenting = false
        end
        f:SetAlpha(0)
    end
    blizzHidden = true
    state.needBlizz = false
end

local function RestoreBlizzardTracker()
    if not blizzHidden then return end
    if InCombatLockdown() then return end
    blizzHidden = false
    reparenting = true
    for f, parent in pairs(origParents) do
        f:SetParent(parent)
        f:SetAlpha(1)
    end
    reparenting = false
    wipe(origParents)
end

-- =====================================================================
-- POSITION / MOVER
-- =====================================================================

local function DefaultPosition()
    local def = TomoMod_Defaults and TomoMod_Defaults.objectiveTracker
    if def and type(def.position) == "table" then return CopyTable(def.position) end
    return { point = "TOPRIGHT", relativePoint = "TOPRIGHT", x = -110, y = -260 }
end

local function ApplyPosition()
    if not root then return end
    if InCombatLockdown() then state.needPosition = true return end
    state.needPosition = false
    local db = S()
    root:SetScale((db.scale and db.scale > 0) and db.scale or 1)
    root:SetWidth(Opt("width"))
    local pos = db.position
    root:ClearAllPoints()
    if type(pos) == "table" and (pos.point or pos.anchor) then
        if TomoMod_Layout and TomoMod_Layout.MigratePosition then TomoMod_Layout.MigratePosition(pos) end
        local point = pos.point or pos.anchor or "TOPRIGHT"
        local rel = pos.anchor or pos.relativePoint or point
        local x, y = pos.x or 0, pos.y or 0
        if TomoMod_Layout and TomoMod_Layout.Rescale then
            x, y = TomoMod_Layout.Rescale(x, y, pos.refW, pos.refH, UIParent:GetWidth(), UIParent:GetHeight())
        end
        local ratio = root:GetEffectiveScale() / UIParent:GetEffectiveScale()
        if not (ratio and ratio > 0) then ratio = 1 end
        root:SetPoint(point, UIParent, rel, x / ratio, y / ratio)
    else
        root:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -110, -260)
    end
end
OT.ApplyPosition = ApplyPosition

local function SavePosition()
    if not root then return end
    local db = S()
    db.position = db.position or {}
    if TomoMod_Layout and TomoMod_Layout.Save then
        TomoMod_Layout.Save(db.position, root)
        return
    end
    local left, top = root:GetLeft(), root:GetTop()
    if not left or not top then return end
    local scale = root:GetEffectiveScale() / UIParent:GetEffectiveScale()
    db.position.point, db.position.relativePoint = "TOPLEFT", "BOTTOMLEFT"
    db.position.x, db.position.y = left * scale, top * scale
end
OT.SavePosition = SavePosition

local function CreateMover()
    if mover or not root then return mover end
    mover = CreateFrame("Frame", "TomoModObjectiveTrackerMover", UIParent, "BackdropTemplate")
    mover:SetFrameStrata("HIGH")
    mover:SetFrameLevel(200)
    if TomoMod_Utils and TomoMod_Utils.StyleMoverOverlay then
        TomoMod_Utils.StyleMoverOverlay(mover, TomoMod_Layout and TomoMod_Layout.Label and TomoMod_Layout.Label("objectiveTracker"))
    end
    mover:SetPoint("TOPLEFT", root, "TOPLEFT")
    mover:SetPoint("BOTTOMRIGHT", root, "BOTTOMRIGHT")
    mover:EnableMouse(true)
    mover:RegisterForDrag("LeftButton")
    mover:SetScript("OnDragStart", function()
        if InCombatLockdown() then return end
        root:StartMoving()
    end)
    mover:SetScript("OnDragStop", function()
        root:StopMovingOrSizing()
        if InCombatLockdown() then return end
        SavePosition()
        ApplyPosition()
    end)
    mover:EnableMouseWheel(true)
    function mover:UpdateScaleLabel(scale)
        if not self.SetMoverLabel then return end
        local base = (TomoMod_Layout and TomoMod_Layout.Label and TomoMod_Layout.Label("objectiveTracker")) or "Quest tracker"
        self:SetMoverLabel(("%s  -  %d %%"):format(base, math.floor((scale or 1) * 100 + 0.5)))
    end
    mover:SetScript("OnMouseWheel", function(self, delta)
        if InCombatLockdown() then return end
        local db = S()
        local s = (db.scale or 1) + (delta > 0 and 0.05 or -0.05)
        db.scale = math.min(math.max(s, 0.6), 1.8)
        ApplyPosition()
        self:UpdateScaleLabel(db.scale)
    end)
    mover:Hide()
    return mover
end

function OT.IsLocked() return not isUnlocked end

function OT.SetLocked(value)
    if not root then return end
    isUnlocked = not value
    if isUnlocked then
        CreateMover()
        mover:UpdateScaleLabel(S().scale or 1)
        mover:Show()
    else
        if mover then mover:Hide() end
        if not InCombatLockdown() then
            SavePosition()
            ApplyPosition()
        end
    end
    RequestRefresh()
end

function OT.ToggleLock() OT.SetLocked(isUnlocked) end

--- Back to the default place and scale. Returns "now" or "after_combat".
function OT.ResetPosition()
    local db = S()
    db.position = DefaultPosition()
    db.scale = 1.0
    if not root then return "now" end
    if InCombatLockdown() then
        state.needPosition = true
        return "after_combat"
    end
    ApplyPosition()
    if mover and mover:IsShown() then mover:UpdateScaleLabel(1) end
    return "now"
end

local function RegisterWithMovers()
    if not TomoMod_Movers or not TomoMod_Movers.RegisterEntry then return end
    TomoMod_Movers.RegisterEntry({
        label    = T("mover_objectivetracker", "Quest tracker"),
        unlock   = function() OT.SetLocked(false) end,
        lock     = function() OT.SetLocked(true) end,
        isActive = function() return Opt("enabled") and active end,
    })
end

-- =====================================================================
-- EVENTS
-- =====================================================================

local ev = CreateFrame("Frame")

local function OnCombatEnd()
    if state.needDisable then
        state.needDisable = false
        OT.Disable()
        return
    end
    if not active then return end
    if state.needBlizz then HideBlizzardTracker() end
    if state.needPosition then ApplyPosition() end
    state.needLayout = false
    state.sig = nil
    ApplyAlpha()
    Refresh()
end

ev:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_REGEN_DISABLED" then
        ApplyAlpha()
        return
    elseif event == "PLAYER_REGEN_ENABLED" then
        OnCombatEnd()
        return
    elseif event == "UNIT_QUEST_LOG_CHANGED" then
        if ... ~= "player" then return end
    elseif event == "QUEST_REMOVED" or event == "QUEST_TURNED_IN" then
        Forget((...))
    elseif event == "BAG_UPDATE_COOLDOWN" then
        UpdateItemState()
        return
    end
    if active then RequestRefresh() end
end)

local EVENTS = {
    "QUEST_LOG_UPDATE", "QUEST_WATCH_LIST_CHANGED", "QUEST_ACCEPTED",
    "QUEST_REMOVED", "QUEST_TURNED_IN", "UNIT_QUEST_LOG_CHANGED",
    "ZONE_CHANGED", "ZONE_CHANGED_NEW_AREA", "ZONE_CHANGED_INDOORS",
    "PLAYER_ENTERING_WORLD", "PLAYER_LEVEL_UP", "PLAYER_REGEN_DISABLED",
    "PLAYER_REGEN_ENABLED", "BAG_UPDATE_COOLDOWN",
}

local function RegisterEvents()
    for _, e in ipairs(EVENTS) do pcall(ev.RegisterEvent, ev, e) end
end

-- =====================================================================
-- PUBLIC API
-- =====================================================================

local questieNoticeShown = false
local function QuestieNotice()
    if questieNoticeShown then return end
    questieNoticeShown = true
    print("|cffffd100TomoModForever|r " .. T("ot_questie_standdown",
        "Questie draws the quest tracker: TMF's tracker stands down."))
end

function OT.ApplySettings()
    if not isInitialized then return end
    if not Opt("enabled") then
        OT.Disable()
        return
    end
    if not active then
        OT.Enable()
        return
    end
    ApplyLook()
    ApplyPosition()
    OT.UpdateTicker()
    state.sig = nil
    Refresh()
end

function OT.Enable()
    if QuestieOwnsTracker() then QuestieNotice() return end
    CreateFrames()
    active = true
    state.needDisable = false
    HideBlizzardTracker()
    RegisterEvents()
    ApplyLook()
    ApplyPosition()
    if not InCombatLockdown() then root:Show() end
    OT.UpdateTicker()
    state.sig = nil
    Refresh()
end

function OT.Disable()
    active = false
    OT.UpdateTicker()
    if not root then return end
    if InCombatLockdown() then
        -- root holds secure buttons: hide it after the fight.
        state.needDisable = true
        root:SetAlpha(0)
        return
    end
    for _, b in ipairs(itemPool) do b:Hide() end
    state.itemsShown = 0
    UpdateItemTicker()
    if mover then mover:Hide() end
    root:Hide()
    RestoreBlizzardTracker()
end

function OT.SetEnabled(value)
    SetOpt("enabled", value and true or false)
    isInitialized = true
    if value then OT.Enable() else OT.Disable() end
end

function OT.Initialize()
    if isInitialized then return end
    isInitialized = true
    ev:RegisterEvent("PLAYER_REGEN_ENABLED")
    if not Opt("enabled") then return end
    if QuestieOwnsTracker() then QuestieNotice() return end
    OT.Enable()
    RegisterWithMovers()
    -- The quest log is often still empty at login: one more pass shortly.
    C_Timer.After(2, RequestRefresh)
end
