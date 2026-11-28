-- =====================================================================
-- Modules/QOL/Forever/MapMarkers.lua -- travel markers and map comfort (1.3.6)
--
-- Markers on the world map, each kind with its own toggle:
--   * flight points of the zone (the game's own C_TaxiMap data: names and
--     positions, your faction and neutral ones)
--   * dungeon entrances (the codex's positions, your /codex set
--     corrections included), on the zone and on the continent
--   * boats, zeppelins and airships: every transport path of the game
--     (1.4.1, below), placed and named by the client
-- Hovering a marker names it; a left click sets a waypoint there (TMF's
-- arrow when it is on).
--
-- Comfort:
--   * Fade the map while moving: the game's own map fade (mapFade CVar,
--     which no options page offers), given back when switched off.
--   * Show the game behind the map: the black behind the maximized map goes
--     to the chosen opacity and, with click-through, lets the mouse reach
--     the world.
--
-- The markers are frames of our own on the map canvas; hooks on the map
-- tell map changes and zoom (no data provider: see Hook below). Nothing of
-- Blizzard's map is written.
-- =====================================================================

TomoMod_MapMarkers = TomoMod_MapMarkers or {}
local MM = TomoMod_MapMarkers

local IS_FR = GetLocale() == "frFR"
local function T(fr, en) return IS_FR and fr or en end

local ATLAS = {
    flight   = "flightmaster",
    boat     = "flightmasterferry",
    zeppelin = "vehicle-air-horde",
    airship  = "vehicle-air-horde",
    dungeon  = "Dungeon",
    raid     = "Raid",
}
local FALLBACK = {
    flight   = "Interface\\Minimap\\Tracking\\FlightMaster",
    boat     = "Interface\\Minimap\\Tracking\\FlightMaster",
    zeppelin = "Interface\\Minimap\\Tracking\\FlightMaster",
    airship  = "Interface\\Minimap\\Tracking\\FlightMaster",
    dungeon  = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull",
    raid     = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull",
}
local SIZE = { flight = 18, boat = 20, zeppelin = 20, airship = 20, dungeon = 22, raid = 24 }

-- [1.4.1] Boats, zeppelins and airships of WoW: Forever: every transport
-- path of the game's TaxiPathNode table (build 1.60.1.71139), each stop
-- where the transport waits, in world yards { continent, x, y }
-- (continent 0 Eastern Kingdoms, 1 Kalimdor, 2991 Zephras Isle). Facts
-- read from the game's own tables; the list was cross-checked with
-- KW Boats And Zeppelins (Krool) and OpenMap, thanks to them.
-- The client places each dock on the map being looked at and names the
-- zones it leads to, so names come out in the player's language. Nothing
-- says which faction may ride a path: all are shown.
local ROUTES = {
    { "boat",     { 1, -1005.6, -3841.6 }, { 0, -14277.7, 582.9 } },                    -- Ratchet, Booty Bay
    { "zeppelin", { 0, -12464.0, 231.6 },  { 1, 1360.9, -4631.3 } },                    -- Grom'gol, Orgrimmar
    { "boat",     { 0, -3905.2, -585.8 },  { 1, -4016.4, -4740.6 } },                   -- Menethil, Theramore
    { "boat",     { 1, 8532.0, 1023.7 },   { 1, 6594.4, 759.8 } },                      -- Rut'theran, Auberdine
    { "zeppelin", { 0, -12406.9, 211.8 },  { 0, 2062.6, 235.3 } },                      -- Grom'gol, Undercity
    { "zeppelin", { 1, 1318.1, -4658.0 },  { 0, 2062.4, 293.0 } },                      -- Orgrimmar, Undercity
    { "boat",     { 1, -4197.3, 3286.6 },  { 1, -4347.8, 2444.4 } },                    -- Feathermoon, Feralas coast
    { "boat",     { 0, -3709.5, -575.1 },  { 0, -1102.6, -554.7 }, { 1, 6406.2, 823.1 } }, -- Menethil, Southshore, Auberdine
    { "boat",     { 1, -6932.6, -4950.8 }, { 0, -8232.3, -5800.8 } },                   -- Steamwheedle Port, Powderfuse Port
    { "airship",  { 0, 544.8, 424.2 },     { 2991, 1848.3, 569.1 } },                   -- Alterac Mountains, Zephras Isle
    { "airship",  { 1, -802.0, 366.5 },    { 2991, 1952.1, 1017.1 } },                  -- Mulgore, Zephras Isle
    { "boat",     { 1, 6548.3, 942.2 },    { 0, -8654.5, 1344.4 } },                    -- Darkshore, Stormwind
}
MM.ROUTES = ROUTES
local DOCK = 100   -- yards: stops this close on one continent are one dock

-- Docks: stops merged, each with the stops it leads to.
local docks
local function Docks()
    if docks then return docks end
    docks = {}
    local function DockOf(kind, st)
        for _, d in ipairs(docks) do
            if d.c == st[1] and math.abs(d.x - st[2]) <= DOCK and math.abs(d.y - st[3]) <= DOCK then
                if kind ~= "boat" then d.kind = kind end   -- a tower is a tower
                return d
            end
        end
        local d = { kind = kind, c = st[1], x = st[2], y = st[3], to = {} }
        docks[#docks + 1] = d
        return d
    end
    for _, r in ipairs(ROUTES) do
        for i = 2, #r do
            local d = DockOf(r[1], r[i])
            for j = 2, #r do
                if j ~= i then d.to[#d.to + 1] = r[j] end
            end
        end
    end
    return docks
end
MM.Docks = Docks

local function Vec(x, y)
    if not CreateVector2D then return nil end
    local ok, v = pcall(CreateVector2D, x, y)
    return ok and v or nil
end

-- A world position on map `uiMapID` (0-1), or nil when off it.
local function OnMap(c, x, y, uiMapID)
    local vec = Vec(x, y)
    if not (vec and C_Map and C_Map.GetMapPosFromWorldPos) then return nil end
    local ok, id, pos = pcall(C_Map.GetMapPosFromWorldPos, c, vec, uiMapID)
    if not (ok and pos) then return nil end
    local px, py = pos.x, pos.y
    if pos.GetXY then px, py = pos:GetXY() end
    if type(px) ~= "number" or px < 0 or px > 1 or py < 0 or py > 1 then return nil end
    return px, py, id
end

-- The zone a stop lies in, by the client (localized), cached once known.
local zoneNames = {}
local function ZoneName(st)
    local key = st[1] .. ":" .. st[2] .. ":" .. st[3]
    if zoneNames[key] then return zoneNames[key] end
    local px, py, top = OnMap(st[1], st[2], st[3], nil)
    if not top then return nil end
    local name
    if C_Map.GetMapInfoAtPosition then
        local ok, info = pcall(C_Map.GetMapInfoAtPosition, top, px, py)
        if ok and info and info.name and info.mapID ~= top then name = info.name end
    end
    if not name and C_Map.GetMapInfo then
        local info = C_Map.GetMapInfo(top)
        name = info and info.name
    end
    zoneNames[key] = name
    return name
end

local function DB() return TomoModForeverDB and TomoModForeverDB.mapMarkers end

local function Faction()
    local f = UnitFactionGroup and UnitFactionGroup("player")
    return f
end

-- ---------------------------------------------------------------------
-- Pins
-- ---------------------------------------------------------------------
local pins, used = {}, 0
local hooked, mapRef

local function Atlas(tex, kind, atlasOverride)
    local a = atlasOverride or ATLAS[kind]
    if a and C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(a) then
        tex:SetAtlas(a)
        tex:SetTexCoord(0, 1, 0, 1)
    else
        tex:SetTexture(FALLBACK[kind] or FALLBACK.flight)
        tex:SetTexCoord(0, 1, 0, 1)
    end
end

local function GetPin(canvas)
    used = used + 1
    local p = pins[used]
    if not p then
        p = CreateFrame("Button", nil, canvas)
        p:RegisterForClicks("LeftButtonUp")
        p.tex = p:CreateTexture(nil, "OVERLAY")
        p.tex:SetAllPoints()
        p:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(self.title or "", 1, 0.82, 0)
            if self.sub then GameTooltip:AddLine(self.sub, 0.9, 0.9, 0.9, true) end
            GameTooltip:AddLine(T("Clic : point de passage", "Click: set a waypoint"), 0.55, 0.55, 0.55)
            GameTooltip:Show()
        end)
        p:SetScript("OnLeave", function() GameTooltip:Hide() end)
        p:SetScript("OnClick", function(self)
            local WP = TomoMod_Waypoint
            if WP and WP.NewWaypoint and self.wpMap then
                WP.NewWaypoint(self.title or "", self.wpMap, self.wpX, self.wpY)
            elseif C_Map and C_Map.SetUserWaypoint and self.wpMap and UiMapPoint then
                C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(self.wpMap, self.wpX / 100, self.wpY / 100))
                if C_SuperTrack then C_SuperTrack.SetSuperTrackedUserWaypoint(true) end
            end
        end)
        pins[used] = p
    end
    p:SetParent(canvas)
    return p
end

local function HideAll()
    for i = 1, #pins do pins[i]:Hide() end
    used = 0
end

local function Rescale()
    local map = mapRef
    if not map then return end
    local scale = map.GetCanvasScale and map:GetCanvasScale() or 1
    if not scale or scale <= 0 then scale = 1 end
    for i = 1, used do pins[i]:SetScale(1 / scale) end
end

-- x, y in 0-1 on the shown map.
local function Place(canvas, kind, x, y, title, sub, wpMap, wpX, wpY, atlas)
    local p = GetPin(canvas)
    local s = SIZE[kind] or 18
    p:SetSize(s, s)
    Atlas(p.tex, kind, atlas)
    p.title, p.sub, p.wpMap, p.wpX, p.wpY = title, sub, wpMap, wpX, wpY
    p:SetFrameLevel(canvas:GetFrameLevel() + 2100)
    p:ClearAllPoints()
    -- Position in canvas units: the pin's own scale undoes the zoom.
    local scale = mapRef and mapRef.GetCanvasScale and mapRef:GetCanvasScale() or 1
    if not scale or scale <= 0 then scale = 1 end
    p:SetScale(1 / scale)
    p:SetPoint("CENTER", canvas, "TOPLEFT", x * canvas:GetWidth() * scale, -y * canvas:GetHeight() * scale)
    p:Show()
end

-- A point on map `fromMap` (0-1) seen on map `toMap` (0-1), or nil.
local function Translate(fromMap, x, y, toMap)
    if fromMap == toMap then return x, y end
    if not (C_Map and C_Map.GetWorldPosFromMapPos and C_Map.GetMapPosFromWorldPos and CreateVector2D) then return nil end
    local ok, cont, world = pcall(C_Map.GetWorldPosFromMapPos, fromMap, CreateVector2D(x, y))
    if not ok or not world then return nil end
    local ok2, _, pos = pcall(C_Map.GetMapPosFromWorldPos, cont, world, toMap)
    if not ok2 or not pos then return nil end
    local px, py = pos:GetXY()
    if px < 0 or px > 1 or py < 0 or py > 1 then return nil end
    return px, py
end

local function MapType(mapID)
    local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(mapID)
    return info and info.mapType
end

local ZONE = (Enum and Enum.UIMapType and Enum.UIMapType.Zone) or 3
local CONTINENT = (Enum and Enum.UIMapType and Enum.UIMapType.Continent) or 2

local function DrawFlights(canvas, mapID)
    if not (C_TaxiMap and C_TaxiMap.GetTaxiNodesForMap) then return end
    local ok, nodes = pcall(C_TaxiMap.GetTaxiNodesForMap, mapID)
    if not ok or type(nodes) ~= "table" then return end
    local mine = Faction()
    local FPF = Enum and Enum.FlightPathFaction
    for _, n in ipairs(nodes) do
        local pos = n.position
        local fac = n.faction
        local ours = true
        if FPF and fac ~= nil and fac ~= FPF.Neutral then
            ours = (fac == FPF.Horde and mine == "Horde") or (fac == FPF.Alliance and mine == "Alliance")
        end
        if pos and ours then
            local x, y = pos:GetXY()
            local atlas = (n.atlasName and n.atlasName ~= "") and n.atlasName or nil
            Place(canvas, "flight", x, y, n.name, T("Maître de vol", "Flight master"), mapID, x * 100, y * 100, atlas)
        end
    end
end

local function DrawDungeons(canvas, mapID)
    local data = TomoMod_DungeonCodexData
    local DC = TomoMod_DungeonCodex
    if not (data and data.dungeons and DC and DC.Entrance) then return end
    local seen = {}
    for _, d in ipairs(data.dungeons) do
        local map, x, y = DC.Entrance(d)
        if map and x and y then
            local px, py = Translate(map, x / 100, y / 100, mapID)
            local key = px and (math.floor(px * 200) .. ":" .. math.floor(py * 200))
            local name = IS_FR and d.fr or d.en
            local range = (d.min and d.max) and (d.min .. "-" .. d.max) or nil
            if px and not seen[key] then
                seen[key] = true
                Place(canvas, d.raid and "raid" or "dungeon", px, py, name,
                    range and (T("Niveaux ", "Levels ") .. range) or nil, map, x, y)
            elseif px and seen[key] then
                -- Same door (wings): add the name to the pin already there.
                for i = 1, used do
                    local p = pins[i]
                    if p.wpMap == map and math.abs((p.wpX or 0) - x) < 0.6 and math.abs((p.wpY or 0) - y) < 0.6 then
                        p.sub = (p.sub and (p.sub .. "\n") or "") .. name .. (range and (" (" .. range .. ")") or "")
                        break
                    end
                end
            end
        end
    end
end

local TITLES = {
    boat     = T("Bateau", "Boat"),
    zeppelin = T("Zeppelin", "Zeppelin"),
    airship  = T("Dirigeable", "Airship"),
}

local function DrawTransports(canvas, mapID)
    for _, d in ipairs(Docks()) do
        local px, py = OnMap(d.c, d.x, d.y, mapID)
        if px then
            local names, seen = {}, {}
            for _, st in ipairs(d.to) do
                local n = ZoneName(st) or "?"
                if not seen[n] then seen[n] = true; names[#names + 1] = n end
            end
            Place(canvas, d.kind, px, py, TITLES[d.kind] or TITLES.boat,
                T("Vers : ", "To: ") .. table.concat(names, ", "), mapID, px * 100, py * 100)
        end
    end
end

local function Draw()
    HideAll()
    local db = DB()
    local map = mapRef
    if not (db and db.enabled and map and map.GetMapID) then return end
    local mapID = map:GetMapID()
    local canvas = map.GetCanvas and map:GetCanvas()
    if not (mapID and canvas) then return end
    local mtype = MapType(mapID)
    if mtype ~= ZONE and mtype ~= CONTINENT then return end
    if db.transports ~= false and mtype == ZONE then pcall(DrawTransports, canvas, mapID) end
    if db.dungeons ~= false then pcall(DrawDungeons, canvas, mapID) end
    if db.flightPoints ~= false and mtype == ZONE then pcall(DrawFlights, canvas, mapID) end
end
MM.Draw = Draw

-- ---------------------------------------------------------------------
-- Comfort: map fade, game behind the map
-- ---------------------------------------------------------------------
local function ApplyFade()
    local db = DB()
    if not (db and GetCVar and SetCVar) then return end
    if db.mapFade then
        if db.mapFadeWas == nil then db.mapFadeWas = GetCVar("mapFade") or "0" end
        SetCVar("mapFade", "1")
    elseif db.mapFadeWas ~= nil then
        SetCVar("mapFade", db.mapFadeWas)
        db.mapFadeWas = nil
    end
end

local function ApplyBehind()
    local db = DB()
    local map = _G.WorldMapFrame
    local black = map and map.BlackoutFrame
    if not (db and black) then return end
    if db.behind then
        black:SetAlpha(db.behindAlpha or 0.4)
        black:EnableMouse(not db.clickThrough)
    elseif db._behindTouched then
        black:SetAlpha(1)
        black:EnableMouse(true)
    end
    db._behindTouched = db.behind and true or nil
end

-- ---------------------------------------------------------------------
-- Setup
-- ---------------------------------------------------------------------
-- [1.3.9] Hooks, not a map data provider. A provider of ours sits in the
-- map's own provider list, and every pin the game's quest provider then
-- acquired was tainted: SetPassThroughButtons() was blocked each time the
-- map refreshed (reports from 1.3.6 on). Following the map from outside
-- leaves its pins alone.
local function Hook()
    local map = _G.WorldMapFrame
    if hooked then return true end
    if not (map and map.GetCanvas and map.HookScript) then return false end
    hooked = true
    mapRef = map
    if map.OnMapChanged then hooksecurefunc(map, "OnMapChanged", function() Draw() end) end
    if map.OnCanvasScaleChanged then hooksecurefunc(map, "OnCanvasScaleChanged", function() Rescale() end) end
    map:HookScript("OnShow", function() Draw(); ApplyBehind() end)
    map:HookScript("OnHide", function() HideAll() end)
    return true
end

function MM.ApplySettings()
    ApplyFade()
    ApplyBehind()
    if hooked and mapRef and mapRef:IsShown() then Draw() end
end

function MM.SetEnabled(v)
    local db = DB()
    if not db then return end
    db.enabled = v and true or false
    MM.ApplySettings()
end

function MM.Initialize()
    if not DB() then return end
    ApplyFade()
    if not Hook() then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, _, name)
            if name == "Blizzard_WorldMap" and Hook() then self:UnregisterAllEvents() end
        end)
    end
end
