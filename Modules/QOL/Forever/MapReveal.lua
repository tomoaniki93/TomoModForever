-- =====================================================================
-- Modules/QOL/Forever/MapReveal.lua -- show unexplored areas on the map
--
-- The world map only draws the areas you have explored. With this option,
-- the areas you have not explored yet are drawn too, tinted (or not) so
-- you can tell them apart, and the map shows where to go before you get
-- there.
--
-- How. Blizzard's exploration pin (MapExplorationPinTemplate) draws the
-- explored areas in RefreshOverlays. After it runs, this module draws the
-- other areas of the same map art from MapRevealData.lua (the game's own
-- overlay tables), cut into tiles the same way the game does: 256 px
-- tiles, the last one of a row or column smaller, stored in a file of the
-- next power of two. Our textures are separate from Blizzard's pool and
-- the pin is only hooked, never replaced.
-- =====================================================================

-- Zone levels (1.2.5): the name under the cursor on the world map gets the
-- zone's level range, coloured like quests for your level (red above you,
-- orange yours, green below, grey far below). The range comes from the game
-- (C_Map.GetMapLevels); a Classic table below covers a client that gives
-- none. Idea from OpenMap (MIT, OpenMap contributors).
-- =====================================================================

TomoMod_MapReveal = TomoMod_MapReveal or {}
local MR = TomoMod_MapReveal

local DEFAULT_TILE = 256
local DEFAULT_TINT = { r = 0.45, g = 0.70, b = 1.00 }

local function DB() return TomoModForeverDB and TomoModForeverDB.mapReveal end

-- Our state per Blizzard pin, kept outside the pin's own table.
local pins = setmetatable({}, { __mode = "k" })   -- [pin] = { textures = {}, used = 0 }

local function Store(pin)
    local s = pins[pin]
    if not s then
        s = { textures = {}, used = 0 }
        pins[pin] = s
    end
    return s
end

local function HideAll(s)
    for _, t in ipairs(s.textures) do t:Hide() end
    s.used = 0
end

local function NextTexture(pin, s)
    s.used = s.used + 1
    local t = s.textures[s.used]
    if not t then
        t = pin:CreateTexture(nil, "ARTWORK")
        s.textures[s.used] = t
    end
    return t
end

-- The file of a partial tile is the next power of two (16 minimum).
local function FileSize(pixels)
    local size = 16
    while size < pixels do size = size * 2 end
    return size
end

local function TileSize(map, mapID)
    if not (C_Map and C_Map.GetMapArtLayers) then return DEFAULT_TILE, DEFAULT_TILE end
    local ok, layers = pcall(C_Map.GetMapArtLayers, mapID)
    if not ok or type(layers) ~= "table" then return DEFAULT_TILE, DEFAULT_TILE end
    local index = 1
    local canvas = map.GetCanvasContainer and map:GetCanvasContainer()
    if canvas and canvas.GetCurrentLayerIndex then index = canvas:GetCurrentLayerIndex() or 1 end
    local layer = layers[index] or layers[1]
    if not layer then return DEFAULT_TILE, DEFAULT_TILE end
    return layer.tileWidth or DEFAULT_TILE, layer.tileHeight or DEFAULT_TILE
end

local function Explored(mapID)
    local done = {}
    if not (C_MapExplorationInfo and C_MapExplorationInfo.GetExploredMapTextures) then return done end
    local ok, list = pcall(C_MapExplorationInfo.GetExploredMapTextures, mapID)
    if ok and type(list) == "table" then
        for _, e in ipairs(list) do
            if e.offsetX and e.offsetY then done[e.offsetX .. ":" .. e.offsetY] = true end
        end
    end
    return done
end

local function Draw(pin)
    local s = Store(pin)
    HideAll(s)
    local db = DB()
    if not (db and db.enabled) then return end
    local map = pin.GetMap and pin:GetMap()
    local mapID = map and map.GetMapID and map:GetMapID()
    if not mapID or not (C_Map and C_Map.GetMapArtID) then return end
    local artID = C_Map.GetMapArtID(mapID)
    local areas = artID and TomoMod_MapRevealData and TomoMod_MapRevealData[artID]
    if not areas then return end

    local explored = Explored(mapID)
    local tileW, tileH = TileSize(map, mapID)
    local tint = db.tint and (db.tintColor or DEFAULT_TINT) or nil
    local r, g, b = 1, 1, 1
    if tint then r, g, b = tint.r or 1, tint.g or 1, tint.b or 1 end

    for _, area in ipairs(areas) do
        local x, y, w, h, files = area[1], area[2], area[3], area[4], area[5]
        if not explored[x .. ":" .. y] then
            local cols, rows = math.ceil(w / tileW), math.ceil(h / tileH)
            for row = 1, rows do
                local lastRow = row == rows
                local ph = lastRow and (h - tileH * (rows - 1)) or tileH
                local fh = lastRow and FileSize(ph) or tileH
                for col = 1, cols do
                    local file = files[(row - 1) * cols + col]
                    if file then
                        local lastCol = col == cols
                        local pw = lastCol and (w - tileW * (cols - 1)) or tileW
                        local fw = lastCol and FileSize(pw) or tileW
                        local t = NextTexture(pin, s)
                        t:ClearAllPoints()
                        t:SetPoint("TOPLEFT", pin, "TOPLEFT", x + tileW * (col - 1), -(y + tileH * (row - 1)))
                        t:SetSize(pw, ph)
                        t:SetTexture(file, nil, nil, "TRILINEAR")
                        t:SetTexCoord(0, pw / fw, 0, ph / fh)
                        t:SetVertexColor(r, g, b, 1)
                        t:Show()
                    end
                end
            end
        end
    end
end

-- A drawing error must never break the map: it is reported once.
local reported = false
local function SafeDraw(pin)
    local ok, err = pcall(Draw, pin)
    if not ok and not reported then
        reported = true
        geterrorhandler()(err)
    end
end

local function HookPin(pin)
    if not pin or pins[pin] or not pin.RefreshOverlays then return end
    Store(pin)
    hooksecurefunc(pin, "RefreshOverlays", SafeDraw)
end

local mapHooked = false
local function HookMap()
    local map = _G.WorldMapFrame
    if not (map and map.EnumeratePinsByTemplate) then return false end
    for pin in map:EnumeratePinsByTemplate("MapExplorationPinTemplate") do HookPin(pin) end
    -- The pin is created the first time the map opens.
    if not mapHooked and map.AcquirePin then
        mapHooked = true
        hooksecurefunc(map, "AcquirePin", function(self, template)
            if template == "MapExplorationPinTemplate" then
                for pin in self:EnumeratePinsByTemplate("MapExplorationPinTemplate") do HookPin(pin) end
            end
        end)
    end
    return true
end

-- ---------------------------------------------------------------------
-- Zone levels on the hover label
-- ---------------------------------------------------------------------
-- Classic ranges by uiMapID, used only when the game gives no range.
local CLASSIC_LEVELS = {
    [1429] = { 1, 10 },  [1426] = { 1, 10 },  [1420] = { 1, 10 },  [1411] = { 1, 10 },
    [1412] = { 1, 10 },  [1438] = { 1, 10 },  [1436] = { 10, 20 }, [1432] = { 10, 20 },
    [1421] = { 10, 20 }, [1439] = { 10, 20 }, [1413] = { 10, 25 }, [1433] = { 15, 25 },
    [1442] = { 15, 27 }, [1431] = { 18, 30 }, [1440] = { 18, 30 }, [1437] = { 20, 30 },
    [1424] = { 20, 30 }, [1441] = { 25, 35 }, [1416] = { 30, 40 }, [1417] = { 30, 40 },
    [1443] = { 30, 40 }, [1434] = { 30, 45 }, [1418] = { 35, 45 }, [1435] = { 35, 45 },
    [1445] = { 35, 45 }, [1425] = { 40, 50 }, [1444] = { 40, 50 }, [1446] = { 40, 50 },
    [1427] = { 43, 50 }, [1419] = { 45, 55 }, [1447] = { 45, 55 }, [1448] = { 48, 55 },
    [1449] = { 48, 55 }, [1428] = { 50, 58 }, [1422] = { 51, 58 }, [1423] = { 53, 60 },
    [1430] = { 55, 60 }, [1451] = { 55, 60 }, [1452] = { 55, 60 },
}

local function Readable(v) return type(v) == "number" and not (issecretvalue and issecretvalue(v)) end

local function ZoneLevels(mapID)
    if C_Map and C_Map.GetMapLevels then
        local ok, lo, hi = pcall(C_Map.GetMapLevels, mapID)
        if ok and Readable(lo) and Readable(hi) and lo > 0 and hi >= lo then return lo, hi end
    end
    local t = CLASSIC_LEVELS[mapID]
    if t then return t[1], t[2] end
end

-- Quest colours for the player's level.
local function LevelColor(lo, hi)
    local level = UnitLevel and UnitLevel("player") or 1
    local c
    if GetQuestDifficultyColor then
        if level < lo then c = GetQuestDifficultyColor(lo)
        elseif level > hi then c = GetQuestDifficultyColor(hi - 2)
        else c = GetQuestDifficultyColor(level + 3) end
    end
    c = c or { r = 1, g = 0.5, b = 0.25 }
    return string.format("|cff%02x%02x%02x", c.r * 255, c.g * 255, c.b * 255)
end

local function LevelSuffix(mapID)
    local lo, hi = ZoneLevels(mapID)
    if not lo then return nil end
    return string.format(" %s(%s)|r", LevelColor(lo, hi), lo == hi and tostring(lo) or (lo .. "-" .. hi))
end

-- After Blizzard has written the label of the place under the cursor: on a
-- continent, the zone hovered; on a zone map, that zone.
local function DecorateLabel(label)
    local db = DB()
    if not (db and db.zoneLevels ~= false) then return end
    local typeKey = MAP_AREA_LABEL_TYPE and MAP_AREA_LABEL_TYPE.AREA_NAME
    -- Blizzard keeps the label in labelInfoByType[type].name (1.2.5 read a
    -- .label field that does not exist, so no level was ever added).
    local infos = label.labelInfoByType
    local info = typeKey and infos and infos[typeKey]
    local name = info and info.name
    if type(name) ~= "string" or name == "" or name:find("|r$") then return end
    local map = label.dataProvider and label.dataProvider:GetMap()
    local mapID = map and map:GetMapID()
    if not mapID then return end
    local target
    local x, y = map:GetNormalizedCursorPosition()
    if x and C_Map.GetMapInfoAtPosition then
        local at = C_Map.GetMapInfoAtPosition(mapID, x, y)
        if at and at.mapID ~= mapID then target = at.mapID end
    end
    if not target then
        local here = C_Map.GetMapInfo(mapID)
        if here and Enum and Enum.UIMapType and here.mapType == Enum.UIMapType.Zone then target = mapID end
    end
    local suffix = target and LevelSuffix(target)
    if not suffix then return end
    label:SetLabel(typeKey, name .. suffix, info.description, info.nameColor, info.descriptionColor, info.textureInfo)
    label:EvaluateLabels()
end

local labelHooked = false
local function HookLabel()
    if labelHooked then return true end
    local map = _G.WorldMapFrame
    if not (map and map.dataProviders) then return false end
    for provider in pairs(map.dataProviders) do
        local label = provider.Label
        if label and label.SetLabel and label.labelInfoByType then
            label:HookScript("OnUpdate", function(self) pcall(DecorateLabel, self) end)
            labelHooked = true
            return true
        end
    end
    return false
end

-- /tm maplevels : is the label hooked, and what levels does the open map get.
function MR.DebugLevels()
    local function P(...) print("|cffc9a252[TMF carte]|r", ...) end
    P("label hooked:", tostring(labelHooked), "option:", tostring(DB() and DB().zoneLevels ~= false))
    local map = _G.WorldMapFrame
    local mapID = map and map.GetMapID and map:GetMapID()
    if not mapID then P("open the world map first") return end
    local ok, lo, hi = pcall(C_Map.GetMapLevels, mapID)
    P("map", mapID, "game levels:", tostring(ok and lo), tostring(ok and hi), "table:", CLASSIC_LEVELS[mapID] and (CLASSIC_LEVELS[mapID][1] .. "-" .. CLASSIC_LEVELS[mapID][2]) or "-")
    for _, child in ipairs(C_Map.GetMapChildrenInfo and C_Map.GetMapChildrenInfo(mapID) or {}) do
        local l, h = ZoneLevels(child.mapID)
        P("  ", child.mapID, child.name, l and (l .. "-" .. h) or "-")
    end
end

-- Redraw the open map after a settings change.
function MR.ApplySettings()
    HookMap()
    HookLabel()
    for pin in pairs(pins) do SafeDraw(pin) end
end

function MR.Initialize()
    if not DB() then return end
    -- The label provider may only exist once the map has been shown.
    if not HookLabel() and _G.WorldMapFrame and _G.WorldMapFrame.HookScript then
        _G.WorldMapFrame:HookScript("OnShow", HookLabel)
    end
    if not HookMap() then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, _, name)
            if name == "Blizzard_WorldMap" then
                HookLabel()
                if HookMap() then self:UnregisterAllEvents() end
            end
        end)
    end
end
