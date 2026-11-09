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

-- Redraw the open map after a settings change.
function MR.ApplySettings()
    HookMap()
    for pin in pairs(pins) do SafeDraw(pin) end
end

function MR.Initialize()
    if not DB() then return end
    if not HookMap() then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, _, name)
            if name == "Blizzard_WorldMap" and HookMap() then self:UnregisterAllEvents() end
        end)
    end
end
