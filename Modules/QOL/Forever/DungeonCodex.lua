-- =====================================================================
-- Modules/QOL/Forever/DungeonCodex.lua -- dungeon codex (WoW: Forever)
--
-- A window listing the dungeons of WoW: Forever (DungeonCodexData.lua):
-- by default the ones that fit your level, or all of them. Picking one
-- shows its level range, zone, the route for YOUR faction step by step,
-- and a button that drops a waypoint on the entrance (TomoMod Waypoint,
-- or Blizzard's user waypoint as a fallback) or opens the zone map.
--
-- Map IDs. Zones carry the Classic uiMapID. When that ID is missing on
-- this client, or names another zone, the zone is looked up by name in
-- the client's own map tree. New zones (Riverglades) have no ID at all
-- and rely on that lookup or on a calibration.
--
-- Calibration, for entrances not placed yet or placed a bit off:
--   /codex here           where am I (map ID, zone, coordinates)
--   /codex set <key>      the entrance of <key> is where I stand
--   /codex reset <key>    forget that override
--   /codex missing        dungeons without a position
-- Overrides live in the profile (dungeonCodex.overrides) and win over
-- the data file; `set` also prints the line to paste into it.
--
-- Optional: one chat line on level up when a dungeon comes within reach.
--
-- Elites tab (1.2.5): the zones with elite quests for your faction
-- (EliteQuestData.lua), by level; each zone lists its elite quests with
-- their level, minimum level and state, and opens the zone map.
--
-- Quests tab (1.2.4): the quests of the selected dungeon for your faction
-- (DungeonQuestData.lua), with their state read from the game: done,
-- in your quest log, or still to take. Titles come from the client in
-- its own language when it knows them, the English name otherwise.
-- =====================================================================

TomoMod_DungeonCodex = TomoMod_DungeonCodex or {}
local DC = TomoMod_DungeonCodex

local FONT      = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local FONT_BOLD = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-SemiBold.ttf"
local SOLID     = "Interface\\Buttons\\WHITE8X8"

-- WoW: Forever palette
local BRONZE = { 0.545, 0.420, 0.247 }   -- #8B6B3F
local GOLD   = { 0.788, 0.635, 0.322 }   -- #C9A252
local YELLOW = { 1.000, 0.820, 0.000 }   -- #FFD100
local TEXT   = { 0.949, 0.922, 0.859 }   -- #F2EBDB
local DIM    = { 0.660, 0.620, 0.540 }
local GREEN  = { 0.550, 0.850, 0.400 }
local RED    = { 1.000, 0.450, 0.350 }

local W, H      = 600, 420
local LIST_W    = 220
local ROW_H     = 22
local REACH     = 2      -- a dungeon is "for you" from min - REACH to max
local PREFIX    = "|cffffd100TomoModForever|r "

local IS_FR = GetLocale() == "frFR"
local function T(fr, en)
    if TomoMod_GUIT then return TomoMod_GUIT(fr, en) end
    return IS_FR and fr or en
end
local function L(t) return t and (IS_FR and t.fr or t.en) end   -- { fr, en } tables

local function DB() return TomoModForeverDB and TomoModForeverDB.dungeonCodex end
local function Data() return TomoMod_DungeonCodexData end

local function PlayerLevel() return (UnitLevel and UnitLevel("player")) or 1 end
local function Faction()
    local f = UnitFactionGroup and UnitFactionGroup("player")
    return f == "Alliance" and "A" or "H"
end

-- ---------------------------------------------------------------------
-- Zone resolution
-- ---------------------------------------------------------------------
local function NameKey(s)
    if type(s) ~= "string" then return nil end
    return (s:lower():gsub("[%s%p’]", ""))
end

local nameIndex   -- [NameKey] = uiMapID, built on first need

local function BuildNameIndex()
    nameIndex = {}
    if not (C_Map and C_Map.GetBestMapForUnit and C_Map.GetMapChildrenInfo) then return end
    -- Climb from where we stand to the top of the tree, then take every
    -- descendant zone.
    local id = C_Map.GetBestMapForUnit("player")
    local top, guard = id, 0
    while id and guard < 10 do
        local info = C_Map.GetMapInfo(id)
        if not info then break end
        top = id
        if not info.parentMapID or info.parentMapID == 0 then break end
        id = info.parentMapID
        guard = guard + 1
    end
    if not top then return end
    local ok, kids = pcall(C_Map.GetMapChildrenInfo, top, nil, true)
    if not ok or type(kids) ~= "table" then return end
    local zoneType = Enum and Enum.UIMapType and Enum.UIMapType.Zone or 3
    for _, m in ipairs(kids) do
        local k = NameKey(m.name)
        if k and (m.mapType == zoneType or not nameIndex[k]) then nameIndex[k] = m.mapID end
    end
end

local resolved = {}   -- [zoneKey] = mapID or false

local function ResolveZone(zoneKey)
    if resolved[zoneKey] ~= nil then return resolved[zoneKey] or nil end
    local z = Data().zones[zoneKey]
    if not z then resolved[zoneKey] = false return nil end
    local wanted = { [NameKey(z.en) or ""] = true, [NameKey(z.fr) or ""] = true }
    local englishOrFrench = IS_FR or GetLocale():sub(1, 2) == "en"

    -- 1) The Classic ID, if it exists and (where we can tell) is that zone.
    if z.id and C_Map and C_Map.GetMapInfo then
        local info = C_Map.GetMapInfo(z.id)
        if info and (not englishOrFrench or wanted[NameKey(info.name) or "?"]) then
            resolved[zoneKey] = z.id
            return z.id
        end
    end
    -- 2) By name in the client's map tree.
    if not nameIndex then BuildNameIndex() end
    local id = nameIndex[NameKey(z.en) or "?"] or nameIndex[NameKey(z.fr) or "?"]
    resolved[zoneKey] = id or false
    return id
end

-- Entrance of a dungeon: mapID, x, y, source ("override" | "guide" | "approx").
-- mapID alone (no x/y) when only the zone is known.
local function Entrance(d)
    local db = DB()
    local o = db and db.overrides and db.overrides[d.key]
    if o and o.map and o.x and o.y then return o.map, o.x, o.y, "override" end
    local map = ResolveZone(d.zone)
    if d.pos then return map, d.pos[1], d.pos[2], d.src or "approx" end
    return map, nil, nil, nil
end
DC.Entrance = Entrance

local function ZoneName(d)
    local z = Data().zones[d.zone]
    return z and (IS_FR and z.fr or z.en) or d.zone
end

local function DungeonName(d) return IS_FR and d.fr or d.en end

-- ---------------------------------------------------------------------
-- Waypoint / map
-- ---------------------------------------------------------------------
-- A point on a Classic uiMapID (x / y in %), named; the client's own map
-- when that ID exists there, else the codex zone it belongs to.
local function PlacePoint(name, map, x, y, fallbackZone)
    if map and C_Map and C_Map.GetMapInfo and not C_Map.GetMapInfo(map) then
        map = fallbackZone and ResolveZone(fallbackZone) or nil
    end
    if not (map and x and y) then return false end
    local WP = TomoMod_Waypoint
    if WP and WP.NewWaypoint then return WP.NewWaypoint(name, map, x, y) end
    if C_Map and C_Map.CanSetUserWaypointOnMap and C_Map.CanSetUserWaypointOnMap(map) then
        C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(map, x / 100, y / 100))
        if C_SuperTrack then C_SuperTrack.SetSuperTrackedUserWaypoint(true) end
        return true
    end
    return false
end

local function PlaceWaypoint(d)
    local map, x, y = Entrance(d)
    if not (map and x and y) then
        print(PREFIX .. string.format(T("Pas encore de position pour %s. Sur place : /codex set %s",
            "No position yet for %s. On the spot: /codex set %s"), DungeonName(d), d.key))
        return false
    end
    local WP = TomoMod_Waypoint
    if WP and WP.NewWaypoint then
        return WP.NewWaypoint(DungeonName(d), map, x, y)
    end
    if C_Map and C_Map.CanSetUserWaypointOnMap and C_Map.CanSetUserWaypointOnMap(map) then
        C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(map, x / 100, y / 100))
        if C_SuperTrack then C_SuperTrack.SetSuperTrackedUserWaypoint(true) end
        return true
    end
    print(PREFIX .. T("Impossible de poser un point sur cette carte.", "Cannot place a point on this map."))
    return false
end

local function OpenZoneMap(d)
    local map = Entrance(d)
    if not map then
        print(PREFIX .. string.format(T("Zone introuvable sur ce client : %s.", "Zone not found on this client: %s."), ZoneName(d)))
        return
    end
    if OpenWorldMap then
        OpenWorldMap(map)
    elseif WorldMapFrame then
        if not WorldMapFrame:IsShown() then ToggleWorldMap() end
        WorldMapFrame:SetMapID(map)
    end
end

-- ---------------------------------------------------------------------
-- Lists
-- ---------------------------------------------------------------------
local function Status(d, lvl)
    if lvl >= d.min and lvl <= d.max then return "now" end
    if lvl < d.min and lvl >= d.min - REACH then return "soon" end
    if lvl > d.max then return "past" end
    return "later"
end

local STATUS_COLOR = { now = GREEN, soon = YELLOW, later = DIM, past = DIM }

-- Elite zones for the player's faction, as list entries shaped like the
-- dungeons (key, names, min / max, zone) so the list and the map button
-- work unchanged. Their zone joins the codex zones for the map lookup.
local function EliteZones()
    local out, fac = {}, Faction()
    local zones = Data().zones
    for _, z in ipairs(TomoMod_EliteQuestData or {}) do
        local quests, minL, maxL = {}, nil, nil
        for _, q in ipairs(z.quests) do
            if q[5] == "B" or q[5] == fac then
                quests[#quests + 1] = q
                minL = math.min(minL or q[3], q[3])
                maxL = math.max(maxL or q[3], q[3])
            end
        end
        if #quests > 0 then
            local zoneKey = "elite_" .. z.key
            if not zones[zoneKey] then zones[zoneKey] = { id = z.id, en = z.en, fr = z.fr } end
            out[#out + 1] = { elite = true, key = zoneKey, en = z.en, fr = z.fr, zone = zoneKey,
                              min = minL, max = maxL, quests = quests }
        end
    end
    table.sort(out, function(a, b)
        if a.min ~= b.min then return a.min < b.min end
        return DungeonName(a) < DungeonName(b)
    end)
    return out
end

local function BuildList(mode)
    if mode == "elite" then return EliteZones() end
    local out, lvl = {}, PlayerLevel()
    for _, d in ipairs(Data().dungeons) do
        local s = Status(d, lvl)
        if mode == "all" or s == "now" or s == "soon" then out[#out + 1] = d end
    end
    -- Too low for any dungeon yet: show the first ones to come.
    if mode ~= "all" and #out == 0 then
        local first
        for _, d in ipairs(Data().dungeons) do
            if d.min > lvl then
                first = first or d.min
                if d.min <= first + 2 then out[#out + 1] = d end
            end
        end
    end
    return out
end

-- ---------------------------------------------------------------------
-- Window
-- ---------------------------------------------------------------------
local win
local rows, steps = {}, {}
local list, offset, selected = {}, 0, nil
local VISIBLE
local detailTab = "route"         -- "route" | "quests"
local qrows, qlist, qoffset = {}, {}, 0
local QROW_H, QVISIBLE = 30, 0
local RefreshQuests

-- ---------------------------------------------------------------------
-- Dungeon quests
-- ---------------------------------------------------------------------
local ICON_DONE  = "Interface\\RaidFrame\\ReadyCheck-Ready"
local ICON_LOG   = "Interface\\GossipFrame\\ActiveQuestIcon"
local ICON_AVAIL = "Interface\\GossipFrame\\AvailableQuestIcon"

local function QuestTitle(id, fallback)
    if C_QuestLog and C_QuestLog.GetTitleForQuestID then
        local ok, t = pcall(C_QuestLog.GetTitleForQuestID, id)
        if ok and type(t) == "string" and t ~= "" and not (issecretvalue and issecretvalue(t)) then return t end
        if C_QuestLog.RequestLoadQuestByID then pcall(C_QuestLog.RequestLoadQuestByID, id) end
    end
    return fallback
end

local function QuestState(id)
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted and C_QuestLog.IsQuestFlaggedCompleted(id) then return "done" end
    if C_QuestLog and C_QuestLog.GetLogIndexForQuestID and C_QuestLog.GetLogIndexForQuestID(id) then return "log" end
    if C_QuestLog and C_QuestLog.IsOnQuest and C_QuestLog.IsOnQuest(id) then return "log" end
    return "avail"
end

local STATE_ORDER = { log = 1, avail = 2, done = 3 }

-- Quests of a dungeon for the player's faction, in log first, then to take
-- (by level), then done. Returns the list and how many are not done.
local function DungeonQuests(d, fac)
    local data = TomoMod_DungeonQuestData and TomoMod_DungeonQuestData[d.key]
    local out, todo = {}, 0
    for _, q in ipairs(data or {}) do
        local side = q[4]
        if side == "B" or side == fac then
            local state = QuestState(q[1])
            if state ~= "done" then todo = todo + 1 end
            out[#out + 1] = { id = q[1], name = q[2], level = q[3], side = side, giver = q[5], prereq = q[6], state = state }
        end
    end
    table.sort(out, function(a, b)
        if a.state ~= b.state then return STATE_ORDER[a.state] < STATE_ORDER[b.state] end
        if (a.level or 0) ~= (b.level or 0) then return (a.level or 0) < (b.level or 0) end
        return a.name < b.name
    end)
    return out, todo
end

local function EliteQuests(d)
    local out, todo = {}, 0
    for _, q in ipairs(d.quests or {}) do
        local state = QuestState(q[1])
        if state ~= "done" then todo = todo + 1 end
        out[#out + 1] = { id = q[1], name = q[2], level = q[3], req = q[4], side = q[5], state = state, elite = true,
                          giver = q[6], map = q[7], x = q[8], y = q[9],
                          ender = q[10], emap = q[11], ex = q[12], ey = q[13], zone = d.zone }
    end
    table.sort(out, function(a, b)
        if a.state ~= b.state then return STATE_ORDER[a.state] < STATE_ORDER[b.state] end
        if a.level ~= b.level then return a.level < b.level end
        return a.name < b.name
    end)
    return out, todo
end

local function GiverText(giver)
    if not giver then return nil end
    local item = giver:match("^item:(.+)$")
    if item then return string.format(T("Commence avec l'objet %s", "Starts from the item %s"), item) end
    return giver
end

local function Flat(parent, w, h, label, onClick)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(w, h)
    local bg = b:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(); bg:SetTexture(SOLID)
    bg:SetVertexColor(0.11, 0.09, 0.07, 1)
    b.bg = bg
    for _, side in ipairs({ "TOP", "BOTTOM", "LEFT", "RIGHT" }) do
        local t = b:CreateTexture(nil, "BORDER")
        t:SetTexture(SOLID)
        t:SetVertexColor(BRONZE[1], BRONZE[2], BRONZE[3], 1)
        if side == "TOP" or side == "BOTTOM" then
            t:SetPoint(side .. "LEFT"); t:SetPoint(side .. "RIGHT"); t:SetHeight(1)
        else
            t:SetPoint("TOP" .. side); t:SetPoint("BOTTOM" .. side); t:SetWidth(1)
        end
    end
    local fs = b:CreateFontString(nil, "OVERLAY")
    fs:SetFont(FONT_BOLD, 11, "OUTLINE")
    fs:SetPoint("CENTER")
    fs:SetTextColor(TEXT[1], TEXT[2], TEXT[3])
    fs:SetText(label)
    b.text = fs
    b:SetScript("OnEnter", function(self) if self:IsEnabled() then self.bg:SetVertexColor(0.20, 0.15, 0.09, 1) end end)
    b:SetScript("OnLeave", function(self) self.bg:SetVertexColor(0.11, 0.09, 0.07, 1) end)
    b:SetScript("OnClick", onClick)
    hooksecurefunc(b, "SetEnabled", function(self, on)
        self.text:SetTextColor(on and TEXT[1] or DIM[1], on and TEXT[2] or DIM[2], on and TEXT[3] or DIM[3], on and 1 or 0.6)
    end)
    return b
end

local function Line(parent, layer)
    local t = parent:CreateTexture(nil, layer or "ARTWORK")
    t:SetTexture(SOLID)
    t:SetVertexColor(BRONZE[1], BRONZE[2], BRONZE[3], 0.7)
    return t
end

local RefreshList, ShowDetail

local function FS(parent, font, size, color, justify)
    local f = parent:CreateFontString(nil, "OVERLAY")
    f:SetFont(font, size, "OUTLINE")
    f:SetTextColor(color[1], color[2], color[3])
    f:SetJustifyH(justify or "LEFT")
    return f
end

local function SetMode(mode)
    local db = DB()
    if db then db.mode = mode end
    for tab, m in pairs({ [win.tabMine] = "mine", [win.tabAll] = "all", [win.tabElite] = "elite" }) do
        local on = mode == m
        tab.bg:SetVertexColor(on and 0.24 or 0.11, on and 0.18 or 0.09, on and 0.10 or 0.07, 1)
    end
    list = BuildList(mode)
    offset = 0
    -- Keep the selection if it is still listed, else the first one.
    local keep
    for _, d in ipairs(list) do if d == selected then keep = d end end
    selected = keep or list[1]
    RefreshList()
    ShowDetail(selected)
end

local function CreateWindow()
    if win then return win end
    win = CreateFrame("Frame", "TomoMod_DungeonCodexFrame", UIParent)
    win:SetSize(W, H)
    win:SetFrameStrata("HIGH")
    win:SetClampedToScreen(true)
    win:SetMovable(true)
    win:EnableMouse(true)
    win:Hide()
    -- Escape closes it. The frame name must differ from the module table
    -- TomoMod_DungeonCodex: a named frame takes over that global, and
    -- CloseAllWindows calls IsShown on whatever the name points to.
    tinsert(UISpecialFrames, "TomoMod_DungeonCodexFrame")

    local bg = win:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(); bg:SetTexture(SOLID)
    bg:SetVertexColor(0.07, 0.06, 0.045, 0.97)
    for _, side in ipairs({ "TOP", "BOTTOM", "LEFT", "RIGHT" }) do
        local t = win:CreateTexture(nil, "BORDER")
        t:SetTexture(SOLID)
        t:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 1)
        if side == "TOP" or side == "BOTTOM" then
            t:SetPoint(side .. "LEFT"); t:SetPoint(side .. "RIGHT"); t:SetHeight(1)
        else
            t:SetPoint("TOP" .. side); t:SetPoint("BOTTOM" .. side); t:SetWidth(1)
        end
    end

    -- Title bar (drag handle)
    local bar = CreateFrame("Frame", nil, win)
    bar:SetPoint("TOPLEFT", 1, -1); bar:SetPoint("TOPRIGHT", -1, -1); bar:SetHeight(30)
    bar:EnableMouse(true)
    bar:RegisterForDrag("LeftButton")
    bar:SetScript("OnDragStart", function() win:StartMoving() end)
    bar:SetScript("OnDragStop", function()
        win:StopMovingOrSizing()
        local db, U = DB(), TomoMod_Utils
        if db and U and U.SaveFramePosition then db.position = db.position or {}; U.SaveFramePosition(win, db.position) end
    end)
    local barBg = bar:CreateTexture(nil, "BACKGROUND")
    barBg:SetAllPoints(); barBg:SetTexture(SOLID)
    barBg:SetVertexColor(0.12, 0.09, 0.06, 1)

    local icon = bar:CreateTexture(nil, "ARTWORK")
    icon:SetSize(20, 20); icon:SetPoint("LEFT", 8, 0)
    icon:SetTexture("Interface\\Icons\\INV_Misc_Book_11")
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    local title = FS(bar, FONT_BOLD, 13, YELLOW)
    title:SetPoint("LEFT", icon, "RIGHT", 7, 0)
    title:SetText(T("Codex des donjons", "Dungeon codex"))
    win.levelFS = FS(bar, FONT, 10, DIM)
    win.levelFS:SetPoint("LEFT", title, "RIGHT", 10, -1)

    local close = Flat(bar, 22, 20, "x", function() win:Hide() end)
    close:SetPoint("RIGHT", -5, 0)

    local sep = Line(win); sep:SetPoint("TOPLEFT", 1, -31); sep:SetPoint("TOPRIGHT", -1, -31); sep:SetHeight(1)

    -- Tabs
    local tabW = (LIST_W - 20) / 3
    win.tabMine = Flat(win, tabW + 12, 22, T("Mon niveau", "My level"), function() SetMode("mine") end)
    win.tabMine:SetPoint("TOPLEFT", 8, -40)
    win.tabAll = Flat(win, tabW - 12, 22, T("Tous", "All"), function() SetMode("all") end)
    win.tabAll:SetPoint("LEFT", win.tabMine, "RIGHT", 4, 0)
    win.tabElite = Flat(win, tabW, 22, T("Élites", "Elites"), function() SetMode("elite") end)
    win.tabElite:SetPoint("LEFT", win.tabAll, "RIGHT", 4, 0)

    -- List
    local listFrame = CreateFrame("Frame", nil, win)
    listFrame:SetPoint("TOPLEFT", 8, -70)
    listFrame:SetPoint("BOTTOMLEFT", 8, 10)
    listFrame:SetWidth(LIST_W - 8)
    listFrame:EnableMouseWheel(true)
    listFrame:SetScript("OnMouseWheel", function(_, delta)
        local maxOff = math.max(0, #list - VISIBLE)
        offset = math.min(maxOff, math.max(0, offset - delta * 2))
        RefreshList()
    end)
    win.listFrame = listFrame
    VISIBLE = math.floor((H - 80) / ROW_H)

    for i = 1, VISIBLE do
        local r = CreateFrame("Button", nil, listFrame)
        r:SetHeight(ROW_H - 2)
        r:SetPoint("TOPLEFT", 0, -(i - 1) * ROW_H)
        r:SetPoint("RIGHT", listFrame, "RIGHT", -6, 0)
        local hl = r:CreateTexture(nil, "BACKGROUND")
        hl:SetAllPoints(); hl:SetTexture(SOLID); hl:SetVertexColor(1, 1, 1, 0)
        r.hl = hl
        r.lvl = FS(r, FONT_BOLD, 10, TEXT, "LEFT")
        r.lvl:SetPoint("LEFT", 4, 0); r.lvl:SetWidth(40)
        r.name = FS(r, FONT, 10, TEXT, "LEFT")
        r.name:SetPoint("LEFT", r.lvl, "RIGHT", 2, 0)
        r.name:SetPoint("RIGHT", r, "RIGHT", -4, 0)
        r.name:SetWordWrap(false)
        r:SetScript("OnClick", function(self) selected = self.d; RefreshList(); ShowDetail(selected) end)
        r:SetScript("OnEnter", function(self) if self.d ~= selected then self.hl:SetVertexColor(1, 1, 1, 0.05) end end)
        r:SetScript("OnLeave", function(self) if self.d ~= selected then self.hl:SetVertexColor(1, 1, 1, 0) end end)
        rows[i] = r
    end

    -- Scroll indicator
    local track = listFrame:CreateTexture(nil, "BACKGROUND")
    track:SetTexture(SOLID); track:SetVertexColor(BRONZE[1], BRONZE[2], BRONZE[3], 0.2)
    track:SetPoint("TOPRIGHT"); track:SetPoint("BOTTOMRIGHT"); track:SetWidth(2)
    local thumb = listFrame:CreateTexture(nil, "ARTWORK")
    thumb:SetTexture(SOLID); thumb:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0.9)
    thumb:SetWidth(2)
    win.track, win.thumb = track, thumb

    local vsep = Line(win); vsep:SetPoint("TOPLEFT", LIST_W + 4, -38); vsep:SetPoint("BOTTOMLEFT", LIST_W + 4, 10); vsep:SetWidth(1)

    -- Detail
    local det = CreateFrame("Frame", nil, win)
    det:SetPoint("TOPLEFT", LIST_W + 16, -40)
    det:SetPoint("BOTTOMRIGHT", -12, 10)
    win.det = det
    local DW = W - LIST_W - 28

    det.name = FS(det, FONT_BOLD, 15, YELLOW); det.name:SetPoint("TOPLEFT"); det.name:SetWidth(DW)
    det.sub  = FS(det, FONT, 11, TEXT);        det.sub:SetPoint("TOPLEFT", det.name, "BOTTOMLEFT", 0, -4); det.sub:SetWidth(DW)
    det.tags = FS(det, FONT, 10, GOLD);        det.tags:SetPoint("TOPLEFT", det.sub, "BOTTOMLEFT", 0, -4); det.tags:SetWidth(DW)

    det.routeHead = FS(det, FONT_BOLD, 11, GOLD)
    det.routeHead:SetPoint("TOPLEFT", det.tags, "BOTTOMLEFT", 0, -38)
    local rline = Line(det); rline:SetPoint("TOPLEFT", det.routeHead, "BOTTOMLEFT", 0, -3); rline:SetPoint("RIGHT", det, "RIGHT", 0, 0); rline:SetHeight(1)
    det.rline = rline

    for i = 1, 4 do
        local num = FS(det, FONT_BOLD, 11, YELLOW, "RIGHT"); num:SetWidth(16)
        local txt = FS(det, FONT, 11, TEXT); txt:SetWidth(DW - 22); txt:SetWordWrap(true)
        txt:SetPoint("TOPLEFT", num, "TOPRIGHT", 6, 0)
        steps[i] = { num = num, txt = txt }
    end

    det.note = FS(det, FONT, 10, DIM); det.note:SetWidth(DW); det.note:SetWordWrap(true)
    det.pos  = FS(det, FONT, 10, DIM); det.pos:SetWidth(DW)

    det.wp = Flat(det, 150, 26, T("Poser le waypoint", "Set waypoint"), function()
        if selected and PlaceWaypoint(selected) then
            print(PREFIX .. string.format(T("Waypoint posé : %s (%s).", "Waypoint set: %s (%s)."), DungeonName(selected), ZoneName(selected)))
        end
    end)
    det.wp:SetPoint("BOTTOMLEFT", 0, 0)
    det.map = Flat(det, 130, 26, T("Ouvrir la carte", "Open map"), function() if selected then OpenZoneMap(selected) end end)
    det.map:SetPoint("LEFT", det.wp, "RIGHT", 8, 0)

    -- Route / Quests tabs, under the tags line.
    local TAB_W = 120
    det.tabRoute = Flat(det, TAB_W, 20, T("Itinéraire", "Route"), function() detailTab = "route"; ShowDetail(selected) end)
    det.tabRoute:SetPoint("TOPLEFT", det.tags, "BOTTOMLEFT", 0, -8)
    det.tabQuests = Flat(det, TAB_W + 30, 20, T("Quêtes", "Quests"), function() detailTab = "quests"; ShowDetail(selected) end)
    det.tabQuests:SetPoint("LEFT", det.tabRoute, "RIGHT", 6, 0)

    -- Quest list (scrollable), between the tabs and the position line.
    local qf = CreateFrame("Frame", nil, det)
    qf:SetPoint("TOPLEFT", det.tabRoute, "BOTTOMLEFT", 0, -8)
    qf:SetPoint("RIGHT", det, "RIGHT", 0, 0)
    qf:SetPoint("BOTTOM", det.wp, "TOP", 0, 26)
    qf:EnableMouseWheel(true)
    qf:SetScript("OnMouseWheel", function(_, delta)
        local maxOff = math.max(0, #qlist - QVISIBLE)
        qoffset = math.min(maxOff, math.max(0, qoffset - delta))
        RefreshQuests()
    end)
    qf:Hide()
    det.quests = qf
    QVISIBLE = math.max(1, math.floor((H - 40 - 10 - 120 - 60) / QROW_H))
    for i = 1, QVISIBLE do
        local r = CreateFrame("Button", nil, qf)
        r:SetHeight(QROW_H - 2)
        r:SetPoint("TOPLEFT", 0, -(i - 1) * QROW_H)
        r:SetPoint("RIGHT", qf, "RIGHT", -6, 0)
        local hl = r:CreateTexture(nil, "BACKGROUND")
        hl:SetAllPoints(); hl:SetTexture(SOLID); hl:SetVertexColor(1, 1, 1, 0)
        r.hl = hl
        r.icon = r:CreateTexture(nil, "ARTWORK")
        r.icon:SetSize(14, 14); r.icon:SetPoint("TOPLEFT", 2, -2)
        r.name = FS(r, FONT, 11, TEXT); r.name:SetPoint("TOPLEFT", r.icon, "TOPRIGHT", 6, 1)
        r.name:SetPoint("RIGHT", r, "RIGHT", -2, 0); r.name:SetWordWrap(false)
        r.info = FS(r, FONT, 9, DIM); r.info:SetPoint("TOPLEFT", r.name, "BOTTOMLEFT", 0, -2)
        r.info:SetPoint("RIGHT", r, "RIGHT", -2, 0); r.info:SetWordWrap(false)
        r:SetScript("OnEnter", function(self)
            local q = self.q
            if not q then return end
            self.hl:SetVertexColor(1, 1, 1, 0.05)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(QuestTitle(q.id, q.name), YELLOW[1], YELLOW[2], YELLOW[3], true)
            if q.level then GameTooltip:AddLine(string.format(T("Niveau %d", "Level %d"), q.level), TEXT[1], TEXT[2], TEXT[3]) end
            if q.req then GameTooltip:AddLine(string.format(T("Disponible dès le niveau %d", "Available from level %d"), q.req), TEXT[1], TEXT[2], TEXT[3]) end
            if q.elite then
                GameTooltip:AddLine(T("Élite : quête de groupe", "Elite: group quest"), RED[1], RED[2], RED[3])
                if q.ender and q.ender ~= q.giver then
                    GameTooltip:AddLine(string.format(T("À rendre : %s", "Turn in: %s"), q.ender), TEXT[1], TEXT[2], TEXT[3], true)
                end
                if q.x then
                    GameTooltip:AddLine(string.format(T("Clic : point de route vers le donneur (%d, %d)", "Click: waypoint to the giver (%d, %d)"), q.x, q.y), GREEN[1], GREEN[2], GREEN[3])
                elseif q.ex then
                    GameTooltip:AddLine(string.format(T("Clic : point de route vers le rendu (%d, %d)", "Click: waypoint to the turn-in (%d, %d)"), q.ex, q.ey), GREEN[1], GREEN[2], GREEN[3])
                end
            end
            local giver = GiverText(q.giver)
            if giver then GameTooltip:AddLine(string.format(T("Donneur : %s", "Quest giver: %s"), giver), TEXT[1], TEXT[2], TEXT[3], true) end
            if q.prereq then
                GameTooltip:AddLine(string.format(T("Après : %s", "After: %s"), QuestTitle(q.prereq, "#" .. q.prereq)), DIM[1], DIM[2], DIM[3], true)
            end
            local st = (q.state == "done" and T("Faite", "Done")) or (q.state == "log" and T("Dans ton journal", "In your quest log")) or T("À prendre", "To take")
            GameTooltip:AddLine(st, GOLD[1], GOLD[2], GOLD[3])
            GameTooltip:AddLine("ID " .. q.id, DIM[1], DIM[2], DIM[3])
            GameTooltip:Show()
        end)
        r:SetScript("OnLeave", function(self) self.hl:SetVertexColor(1, 1, 1, 0); GameTooltip:Hide() end)
        -- Elite quests: click for a waypoint to the giver (or to the turn-in
        -- when an item starts the quest).
        r:SetScript("OnClick", function(self)
            local q = self.q
            if not (q and q.elite) then return end
            local title = QuestTitle(q.id, q.name)
            local ok
            if q.x then
                ok = PlacePoint(string.format("%s (%s)", q.giver or title, title), q.map, q.x, q.y, q.zone)
                if ok then print(PREFIX .. string.format(T("Point de route : %s, donneur de %s.", "Waypoint: %s, giver of %s."), q.giver or "?", title)) end
            elseif q.ex then
                ok = PlacePoint(string.format("%s (%s)", q.ender or title, title), q.emap, q.ex, q.ey, q.zone)
                if ok then print(PREFIX .. string.format(T("Point de route : %s, à qui rendre %s.", "Waypoint: %s, turn-in of %s."), q.ender or "?", title)) end
            end
            if not ok then print(PREFIX .. string.format(T("Pas de position connue pour %s.", "No known position for %s."), title)) end
        end)
        qrows[i] = r
    end
    det.qempty = FS(qf, FONT, 11, DIM); det.qempty:SetPoint("TOPLEFT", 2, -4); det.qempty:SetWidth(DW)
    det.qempty:SetWordWrap(true)

    det.empty = FS(det, FONT, 11, DIM); det.empty:SetPoint("CENTER")

    local db, U = DB(), TomoMod_Utils
    if db and db.position and U and U.ApplyFramePosition then U.ApplyFramePosition(win, db.position)
    else win:SetPoint("CENTER", 0, 40) end
    win:SetScale(db and db.scale or 1)
    return win
end

RefreshList = function()
    local lvl = PlayerLevel()
    for i = 1, VISIBLE do
        local r, d = rows[i], list[i + offset]
        r.d = d
        if d then
            local c = STATUS_COLOR[Status(d, lvl)]
            r.lvl:SetText(d.min .. "-" .. d.max)
            r.lvl:SetTextColor(c[1], c[2], c[3])
            r.name:SetText(DungeonName(d) .. (d.new and " |cffc9a252*|r" or ""))
            r.name:SetTextColor(TEXT[1], TEXT[2], TEXT[3])
            r.hl:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], d == selected and 0.18 or 0)
            r:Show()
        else
            r:Hide()
        end
    end
    -- Scroll thumb
    local total = #list
    if total > VISIBLE then
        local h = win.listFrame:GetHeight()
        local th = math.max(20, h * VISIBLE / total)
        win.thumb:SetHeight(th)
        win.thumb:ClearAllPoints()
        win.thumb:SetPoint("TOPRIGHT", win.listFrame, "TOPRIGHT", 0, -(h - th) * offset / (total - VISIBLE))
        win.thumb:Show(); win.track:Show()
    else
        win.thumb:Hide(); win.track:Hide()
    end
    win.levelFS:SetText(string.format(T("Niveau %d", "Level %d"), lvl))
end

RefreshQuests = function()
    local det = win.det
    local lvl = PlayerLevel()
    for i = 1, QVISIBLE do
        local r, q = qrows[i], qlist[i + qoffset]
        r.q = q
        if q then
            r.icon:SetTexture(q.state == "done" and ICON_DONE or q.state == "log" and ICON_LOG or ICON_AVAIL)
            r.icon:SetDesaturated(false)
            r.name:SetText(QuestTitle(q.id, q.name))
            local c = (q.state == "done" and DIM) or (q.level and q.level > lvl + 2 and RED) or TEXT
            r.name:SetTextColor(c[1], c[2], c[3])
            local info = {}
            if q.level and q.req then
                info[#info + 1] = string.format(T("Niv. %d (dès le niv. %d)", "Lvl %d (from level %d)"), q.level, q.req)
            elseif q.level then
                info[#info + 1] = string.format(T("Niv. %d", "Lvl %d"), q.level)
            end
            local giver = GiverText(q.giver)
            if giver then info[#info + 1] = giver end
            if q.side == "B" then info[#info + 1] = T("Les deux factions", "Both factions") end
            if q.elite and (q.x or q.ex) then info[#info + 1] = T("clic : point de route", "click: waypoint") end
            r.info:SetText(table.concat(info, "  -  "))
            r:Show()
        else
            r:Hide()
        end
    end
    if #qlist == 0 then
        det.qempty:SetText(T("Aucune quête connue pour ta faction ici.", "No known quest for your faction here."))
        det.qempty:Show()
    else
        det.qempty:Hide()
    end
end

local SRC_TEXT = {
    override = { fr = "Position : enregistrée par toi", en = "Position: recorded by you" },
    guide    = { fr = "Position : relevée par les guides Forever", en = "Position: from Forever guides" },
    approx   = { fr = "Position : approximative (entrée Classic). Corrigeable avec /codex set", en = "Position: approximate (Classic entrance). Fix it with /codex set" },
}

ShowDetail = function(d)
    local det = win.det
    local show = d ~= nil
    for _, k in ipairs({ "name", "sub", "tags", "routeHead", "rline", "note", "pos", "wp", "map", "tabRoute", "tabQuests" }) do
        if show then det[k]:Show() else det[k]:Hide() end
    end
    for _, s in ipairs(steps) do s.num:Hide(); s.txt:Hide() end
    det.quests:Hide()
    if not d then
        det.empty:SetText(T("Aucun donjon.", "No dungeon."))
        det.empty:Show()
        return
    end
    det.empty:Hide()

    local lvl, fac = PlayerLevel(), Faction()
    det.name:SetText(DungeonName(d))

    if d.elite then
        -- Elite zone: its elite quests, the zone map; no route, no waypoint.
        local quests, todo = EliteQuests(d)
        local st = Status(d, lvl)
        local c = STATUS_COLOR[st]
        det.sub:SetText(string.format(T("Quêtes élites  -  niveaux |cff%02x%02x%02x%d-%d|r  -  %d à faire sur %d",
                                        "Elite quests  -  levels |cff%02x%02x%02x%d-%d|r  -  %d to do of %d"),
            c[1] * 255, c[2] * 255, c[3] * 255, d.min, d.max, todo, #quests))
        det.tags:SetText(T("Quêtes de groupe : prévois des alliés.", "Group quests: bring friends."))
        for _, k in ipairs({ "routeHead", "rline", "note", "tabRoute", "tabQuests", "wp" }) do det[k]:Hide() end
        if qlist.key ~= d.key then qoffset = 0 end
        qlist = quests
        qlist.key = d.key
        det.quests:Show()
        RefreshQuests()
        local map = Entrance(d)
        det.pos:ClearAllPoints()
        det.pos:SetPoint("BOTTOMLEFT", det.wp, "TOPLEFT", 0, 8)
        det.pos:SetText(string.format(T("Emplacement : %s", "Location: %s"), ZoneName(d)))
        det.pos:SetTextColor(DIM[1], DIM[2], DIM[3])
        det.map:ClearAllPoints()
        det.map:SetPoint("BOTTOMLEFT", 0, 0)
        det.map:SetEnabled(map ~= nil)
        return
    end
    det.wp:Show()
    det.map:ClearAllPoints()
    det.map:SetPoint("LEFT", det.wp, "RIGHT", 8, 0)
    local st = Status(d, lvl)
    local hint = (st == "now" and T("à ta portée", "right for you"))
        or (st == "soon" and string.format(T("dans %d niveau(x)", "in %d level(s)"), d.min - lvl))
        or (st == "past" and T("trop bas pour toi", "below your level"))
        or T("trop haut pour l'instant", "too high for now")
    local c = STATUS_COLOR[st]
    det.sub:SetText(string.format(T("Niveaux %d-%d  |cff%02x%02x%02x(%s)|r  -  %s", "Levels %d-%d  |cff%02x%02x%02x(%s)|r  -  %s"),
        d.min, d.max, c[1] * 255, c[2] * 255, c[3] * 255, hint, ZoneName(d)))

    local tags = {}
    if d.new then tags[#tags + 1] = T("Nouveau dans Forever", "New in Forever") end
    if d.side and d.side ~= fac then
        tags[#tags + 1] = "|cffff7359" .. (d.side == "H" and T("Territoire horde", "Horde territory") or T("Territoire alliance", "Alliance territory")) .. "|r"
    end
    det.tags:SetText(table.concat(tags, "  -  "))

    -- Tabs: the quest count says what is left to do.
    local quests, todo = DungeonQuests(d, fac)
    det.tabQuests.text:SetText(string.format(T("Quêtes (%d)", "Quests (%d)"), todo))
    local onQuests = detailTab == "quests"
    det.tabRoute.bg:SetVertexColor(onQuests and 0.11 or 0.24, onQuests and 0.09 or 0.18, onQuests and 0.07 or 0.10, 1)
    det.tabQuests.bg:SetVertexColor(onQuests and 0.24 or 0.11, onQuests and 0.18 or 0.09, onQuests and 0.10 or 0.07, 1)
    if onQuests then
        for _, k in ipairs({ "routeHead", "rline", "note" }) do det[k]:Hide() end
        if qlist.key ~= d.key then qoffset = 0 end
        qlist = quests
        qlist.key = d.key
        det.quests:Show()
        RefreshQuests()
    end

    det.routeHead:SetText(string.format(T("Itinéraire (%s)", "Route (%s)"), fac == "A" and "Alliance" or "Horde"))
    local r = d.routes and (d.routes[fac] or d.routes.both)
    local lines = (not onQuests and r) and L(r) or {}
    local prev = det.rline
    for i, s in ipairs(steps) do
        local text = lines[i]
        if text then
            s.num:ClearAllPoints()
            s.num:SetPoint("TOPLEFT", prev, i == 1 and "BOTTOMLEFT" or "BOTTOMLEFT", i == 1 and 0 or -22, i == 1 and -8 or -6)
            s.num:SetText(i .. ".")
            s.txt:SetText(text)
            s.num:Show(); s.txt:Show()
            prev = s.txt
            -- next number anchors under this text, shifted back to the number column
        end
    end

    det.note:ClearAllPoints()
    det.note:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", prev == det.rline and 0 or -22, -10)
    det.note:SetText(onQuests and "" or (L(d.note) or ""))

    local map, x, y, src = Entrance(d)
    det.pos:ClearAllPoints()
    det.pos:SetPoint("BOTTOMLEFT", det.wp, "TOPLEFT", 0, 8)
    if x then
        local line = L(SRC_TEXT[src] or SRC_TEXT.approx)
        det.pos:SetText(string.format("%s  (%.1f, %.1f)", line, x, y))
        det.pos:SetTextColor(src == "approx" and DIM[1] or GREEN[1], src == "approx" and DIM[2] or GREEN[2], src == "approx" and DIM[3] or GREEN[3])
    else
        det.pos:SetText(string.format(T("Position inconnue : sur place, tape /codex set %s", "Unknown position: on the spot, type /codex set %s"), d.key))
        det.pos:SetTextColor(RED[1], RED[2], RED[3])
    end
    det.wp:SetEnabled(map ~= nil and x ~= nil)
    det.map:SetEnabled(map ~= nil)
end

-- ---------------------------------------------------------------------
-- Public
-- ---------------------------------------------------------------------
function DC.Toggle(show)
    local db = DB()
    if not (db and db.enabled) then
        print(PREFIX .. T("Le codex des donjons est désactivé (Aventure > Codex des donjons).", "The dungeon codex is off (Adventure > Dungeon codex)."))
        return
    end
    CreateWindow()
    if show == nil then show = not win:IsShown() end
    if show then
        SetMode((db.mode == "all" or db.mode == "elite") and db.mode or "mine")
        win:Show()
    else
        win:Hide()
    end
end

function DC.ApplySettings()
    local db = DB()
    if not (db and win) then return end
    win:SetScale(db.scale or 1)
end

function DC.SetEnabled(v)
    local db = DB()
    if not db then return end
    db.enabled = v and true or false
    if not v and win then win:Hide() end
end

-- ---------------------------------------------------------------------
-- Calibration commands
-- ---------------------------------------------------------------------
local function Here()
    local map = C_Map.GetBestMapForUnit("player")
    if not map then return nil end
    local pos = C_Map.GetPlayerMapPosition(map, "player")
    if not pos then return map end
    local x, y = pos:GetXY()
    return map, x * 100, y * 100
end

local function Slash(msg)
    msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    local cmd, arg = msg:match("^(%S*)%s*(.-)$")
    local db = DB()
    if cmd == "" then
        DC.Toggle()
    elseif cmd == "here" then
        local map, x, y = Here()
        local info = map and C_Map.GetMapInfo(map)
        print(PREFIX .. string.format("map %s (%s)  %s", tostring(map), info and info.name or "?",
            x and string.format("%.1f, %.1f", x, y) or T("pas de position", "no position")))
    elseif cmd == "set" then
        local d = Data().byKey[arg]
        if not d then
            print(PREFIX .. string.format(T("Clé inconnue : %s. Les clés : /codex keys", "Unknown key: %s. Keys: /codex keys"), arg))
            return
        end
        local map, x, y = Here()
        if not (map and x) then print(PREFIX .. T("Position introuvable ici.", "No position here.")) return end
        db.overrides = db.overrides or {}
        db.overrides[d.key] = { map = map, x = math.floor(x * 10 + 0.5) / 10, y = math.floor(y * 10 + 0.5) / 10 }
        local o = db.overrides[d.key]
        print(PREFIX .. string.format(T("Entrée de %s enregistrée : map %d, %.1f, %.1f", "Entrance of %s saved: map %d, %.1f, %.1f"),
            DungeonName(d), o.map, o.x, o.y))
        print(string.format("  |cff8b6b3fpos = { %.1f, %.1f }, src = \"guide\",  -- %s (map %d)|r", o.x, o.y, d.key, o.map))
        if win and win:IsShown() then ShowDetail(selected) end
    elseif cmd == "reset" then
        if db.overrides then db.overrides[arg] = nil end
        print(PREFIX .. string.format(T("Position personnalisée oubliée : %s", "Custom position cleared: %s"), arg))
        if win and win:IsShown() then ShowDetail(selected) end
    elseif cmd == "missing" or cmd == "keys" then
        for _, d in ipairs(Data().dungeons) do
            local map, x = Entrance(d)
            if cmd == "keys" or not (map and x) then
                print(string.format("  |cffffd100%s|r  %s (%d-%d)%s", d.key, DungeonName(d), d.min, d.max,
                    (map and x) and "" or (map and T("  - pas de point", "  - no point") or T("  - zone introuvable", "  - zone not found"))))
            end
        end
    else
        print(PREFIX .. "/codex  |  /codex here  |  /codex set <key>  |  /codex reset <key>  |  /codex missing  |  /codex keys")
    end
end

-- ---------------------------------------------------------------------
-- Init
-- ---------------------------------------------------------------------
function DC.Initialize()
    if not (DB() and Data()) then return end
    SLASH_TOMOMODCODEX1 = "/codex"
    SLASH_TOMOMODCODEX2 = "/tmfcodex"
    SlashCmdList.TOMOMODCODEX = Slash

    -- Quest titles arrive from the server; the quest log changes state.
    local q = CreateFrame("Frame")
    for _, e in ipairs({ "QUEST_DATA_LOAD_RESULT", "QUEST_TURNED_IN", "QUEST_ACCEPTED", "QUEST_REMOVED" }) do
        pcall(q.RegisterEvent, q, e)
    end
    local pending = false
    q:SetScript("OnEvent", function()
        if pending or not (win and win:IsShown() and detailTab == "quests") then return end
        pending = true
        C_Timer.After(0.2, function()
            pending = false
            if win and win:IsShown() and selected then ShowDetail(selected) end
        end)
    end)

    -- One chat line at login (not after a /reload) about the codex.
    local login = CreateFrame("Frame")
    login:RegisterEvent("PLAYER_ENTERING_WORLD")
    login:SetScript("OnEvent", function(self, _, isInitialLogin)
        self:UnregisterAllEvents()
        local db = DB()
        if not (isInitialLogin and db and db.enabled and db.loginHint ~= false) then return end
        C_Timer.After(8, function()
            local text = TomoMod_L and TomoMod_L["codex_login_hint"]
            if type(text) ~= "string" or text == "codex_login_hint" then
                text = T("Tape |cffffd100/codex|r pour voir les donjons de ton niveau, leur itinéraire et leurs quêtes.",
                         "Type |cffffd100/codex|r to see the dungeons for your level, how to get there and their quests.")
            end
            print(PREFIX .. text)
        end)
    end)

    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_LEVEL_UP")
    f:SetScript("OnEvent", function(_, _, newLevel)
        local db = DB()
        newLevel = tonumber(newLevel)
        if not (db and db.enabled and db.levelUpHint and newLevel) then return end
        -- Dungeons that just came within reach at this level.
        local names = {}
        for _, d in ipairs(Data().dungeons) do
            if d.min - REACH == newLevel or (d.min - REACH < 1 and d.min == newLevel) then
                names[#names + 1] = DungeonName(d)
            end
        end
        if #names > 0 then
            print(PREFIX .. string.format(T("Nouveau(x) donjon(s) à ta portée : %s. Itinéraire : /codex",
                "New dungeon(s) within reach: %s. Route: /codex"), table.concat(names, ", ")))
        end
        if win and win:IsShown() then SetMode((db.mode == "all" or db.mode == "elite") and db.mode or "mine") end
    end)
end
