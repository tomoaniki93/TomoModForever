-- =====================================================================
-- Modules/QOL/Forever/MapMarkers.lua -- travel markers and map comfort (1.3.6)
--
-- Markers on the world map, each kind with its own toggle:
--   * flight points of the zone (the game's own C_TaxiMap data: names and
--     positions, your faction and neutral ones)
--   * dungeon entrances (the codex's positions, your /codex set
--     corrections included), on the zone and on the continent
--   * boats and zeppelins (Classic positions, below)
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
    dungeon  = "Dungeon",
    raid     = "Raid",
}
local FALLBACK = {
    flight   = "Interface\\Minimap\\Tracking\\FlightMaster",
    boat     = "Interface\\Minimap\\Tracking\\FlightMaster",
    zeppelin = "Interface\\Minimap\\Tracking\\FlightMaster",
    dungeon  = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull",
    raid     = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull",
}
local SIZE = { flight = 18, boat = 20, zeppelin = 20, dungeon = 22, raid = 24 }

-- Boats and zeppelins: Classic uiMapID, x, y (0-100), kind, where to.
local TRANSPORTS = {
    { 1411, 50.9, 13.3, "zeppelin", T("Fossoyeuse, Grom'gol", "Undercity, Grom'gol") },
    { 1420, 61.0, 58.9, "zeppelin", T("Orgrimmar, Grom'gol", "Orgrimmar, Grom'gol") },
    { 1434, 31.5, 29.5, "zeppelin", T("Orgrimmar, Fossoyeuse", "Orgrimmar, Undercity") },
    { 1437,  4.6, 57.1, "boat",     T("Auberdine", "Auberdine") },
    { 1437,  5.1, 63.4, "boat",     T("Theramore", "Theramore") },
    { 1439, 32.4, 43.7, "boat",     T("Port de Menethil", "Menethil Harbor") },
    { 1445, 71.6, 56.5, "boat",     T("Port de Menethil", "Menethil Harbor") },
    { 1413, 63.7, 38.6, "boat",     T("Baie-du-Butin", "Booty Bay") },
    { 1434, 25.9, 73.1, "boat",     T("Cabestan", "Ratchet") },
}

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

local function DrawTransports(canvas, mapID)
    for _, t in ipairs(TRANSPORTS) do
        local px, py = Translate(t[1], t[2] / 100, t[3] / 100, mapID)
        if px then
            local title = t[4] == "zeppelin" and T("Zeppelin", "Zeppelin") or T("Bateau", "Boat")
            Place(canvas, t[4], px, py, title, T("Vers : ", "To: ") .. t[5], t[1], t[2], t[3])
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
