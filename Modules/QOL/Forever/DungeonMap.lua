-- =====================================================================
-- Modules/QOL/Forever/DungeonMap.lua -- dungeon and raid maps (1.3.9)
--
-- The map of every classic dungeon and raid of WoW: Forever, opened from
-- the codex (Map button) or with /codex carte. The art is the game's own
-- (twelve 256 px tiles by file ID, nothing shipped with TMF); on top of
-- it: the bosses numbered in route order (rare and optional ones apart),
-- route notes and the passages to the other floors (click to go there).
-- Mouse wheel zooms on the cursor, dragging pans, floors as buttons.
--
-- Data (DungeonMapData.lua): ForeverDungeonRoutes by Checkov23 -- the
-- dungeon list, floors and art tiles from the game's map tables, boss
-- positions, notes and links of its built-in routes. Its maps of the new
-- Forever dungeons belong to Santiago Reyes and are not included.
--
-- The Russian, Spanish (Mexico) and Italian clients of Forever lack the
-- game's tiles of these maps (found by ForeverDungeonRoutes / OpenMap):
-- there TMF borrows the tiles of ForeverDungeonRoutes when that addon is
-- installed, and says so otherwise.
--
-- ---------------------------------------------------------------------
-- ForeverDungeonRoutes licence (applies to the data it comes from):
--
-- MIT License
--
-- Copyright (c) 2026 Checkov23
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
-- =====================================================================

TomoMod_DungeonMap = TomoMod_DungeonMap or {}
local DM = TomoMod_DungeonMap

local FONT      = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local FONT_BOLD = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-SemiBold.ttf"
local CODEX_TEX = "Interface\\AddOns\\TomoModForever\\Assets\\Textures\\Codex\\"
local WP_TEX    = "Interface\\AddOns\\TomoModForever\\Assets\\Textures\\Waypoint\\"
local WHITE     = "Interface\\Buttons\\WHITE8X8"
local DISC      = "Interface\\CHARACTERFRAME\\TempPortraitAlphaMask"
local FDR_TILES = "Interface\\AddOns\\ForeverDungeonRoutes\\tiles\\"

local YELLOW = { 1.000, 0.820, 0.000 }
local GOLD   = { 0.788, 0.635, 0.322 }
local BRONZE = { 0.620, 0.420, 0.210 }
local TEXT   = { 0.949, 0.922, 0.859 }
local DIM    = { 0.660, 0.620, 0.540 }
local KIND = {
    b = { ring = { 0.95, 0.76, 0.31 }, label = { "Boss", "Boss", "Boss", "Jefe", "Chefe" } },
    r = { ring = { 0.89, 0.87, 0.82 }, label = { "Rare", "Rare", "Selten", "Raro", "Raro" } },
    o = { ring = { 0.62, 0.78, 0.95 }, label = { "Optional", "Facultatif", "Optional", "Opcional", "Opcional" } },
}

local MAP_W, MAP_H, TILE = 1002, 668, 256
local W, H        = 980, 600
local LIST_W      = 210
local BAR_H       = 40
local FLOOR_H     = 26
local FOOT_H      = 20
local ROW_H       = 20
local MAX_ZOOM    = 4
local ZOOM_STEP   = 1.25

local LOCALE = GetLocale()
local LANG = ({ frFR = 2, deDE = 3, esES = 4, esMX = 4, ptBR = 5 })[LOCALE] or 1
local IS_FR = LANG == 2
local NO_GAME_TILES = ({ ruRU = true, esMX = true, itIT = true })[LOCALE] or false

local function T(fr, en) return IS_FR and fr or en end
local function N(t) if type(t) ~= "table" then return t end return t[LANG] or t[1] or "" end
local function Data() return TomoMod_DungeonMapData end

local function FDRInstalled()
    if not (C_AddOns and C_AddOns.GetAddOnInfo) then return false end
    local ok, name, _, _, _, reason = pcall(C_AddOns.GetAddOnInfo, "ForeverDungeonRoutes")
    return ok and name ~= nil and reason ~= "MISSING"
end

-- ---------------------------------------------------------------------
-- Lookups
-- ---------------------------------------------------------------------

--- Map key of a codex key or a map key, or nil.
local function Resolve(key)
    local d = Data()
    if not (d and key) then return nil end
    if d.instances[key] then return key end
    return d.codex[key]
end

function DM.HasMap(key) return Resolve(key) ~= nil end

-- The instance and floor the player is in, from the map the game gives.
local function Here()
    local d = Data()
    if not d then return nil end
    local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    if map then
        for _, key in ipairs(d.order) do
            for _, f in ipairs(d.instances[key].floors) do
                if f == map then return key, f end
            end
        end
    end
    local _, kind, _, _, _, _, _, id = GetInstanceInfo()
    if kind == "party" or kind == "raid" then
        for _, key in ipairs(d.order) do
            if d.instances[key].id == id then return key end
        end
    end
end

-- ---------------------------------------------------------------------
-- Window
-- ---------------------------------------------------------------------
local win
local current, floor          -- map key, uiMapID
local zoom, panX, panY = 1, 0, 0
local listOffset = 0
local rows, pins, floorButtons = {}, {}, {}

local function FS(parent, font, size, color, justify)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(font, size, "")
    fs:SetShadowColor(0, 0, 0, 0.9)
    fs:SetShadowOffset(1, -1)
    fs:SetTextColor(color[1], color[2], color[3])
    if justify then fs:SetJustifyH(justify) end
    return fs
end

-- Leather button with a bronze line, golden when active.
local function Button(parent, w, h, label, onClick)
    local FC = TomoMod_ForeverChrome
    local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
    b:SetSize(w, h)
    if FC then FC.Backdrop(b, 0.92, true) else
        b:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 })
        b:SetBackdropColor(0.07, 0.055, 0.04, 0.92)
    end
    b.text = FS(b, FONT_BOLD, 11, TEXT, "CENTER")
    b.text:SetPoint("CENTER", 0, 0)
    b.text:SetText(label or "")
    function b:SetActive(on)
        self.active = on
        local c = on and YELLOW or BRONZE
        self:SetBackdropBorderColor(c[1], c[2], c[3], on and 1 or 0.8)
        local t = on and YELLOW or TEXT
        self.text:SetTextColor(t[1], t[2], t[3])
    end
    b:SetScript("OnEnter", function(self)
        if not self.active then self:SetBackdropBorderColor(GOLD[1], GOLD[2], GOLD[3], 1) end
    end)
    b:SetScript("OnLeave", function(self) self:SetActive(self.active) end)
    b:SetScript("OnClick", onClick)
    b:SetActive(false)
    return b
end

-- ---------------------------------------------------------------------
-- Map canvas
-- ---------------------------------------------------------------------
local function FitZoom()
    local vw, vh = win.view:GetWidth(), win.view:GetHeight()
    return math.min(vw / MAP_W, vh / MAP_H)
end

local function Clamp()
    local vw, vh = win.view:GetWidth(), win.view:GetHeight()
    local s = FitZoom() * zoom
    local cw, ch = MAP_W * s, MAP_H * s
    -- Smaller than the view: centred; larger: no empty border.
    if cw <= vw then panX = (vw - cw) / 2 else panX = math.min(0, math.max(vw - cw, panX)) end
    if ch <= vh then panY = (vh - ch) / 2 else panY = math.min(0, math.max(vh - ch, panY)) end
end

local function LayoutCanvas()
    if not (win and current) then return end
    Clamp()
    local s = FitZoom() * zoom
    local c = win.canvas
    c:SetSize(MAP_W * s, MAP_H * s)
    c:ClearAllPoints()
    c:SetPoint("TOPLEFT", win.view, "TOPLEFT", panX, -panY)
    for i, tex in ipairs(win.tiles) do
        local col, row = (i - 1) % 4, math.floor((i - 1) / 4)
        local tw = math.min(TILE, MAP_W - col * TILE)
        local th = math.min(TILE, MAP_H - row * TILE)
        tex:SetSize(tw * s, th * s)
        tex:ClearAllPoints()
        tex:SetPoint("TOPLEFT", c, "TOPLEFT", col * TILE * s, -row * TILE * s)
        tex:SetTexCoord(0, tw / TILE, 0, th / TILE)
    end
    local size = math.max(18, math.min(30, 22 * math.sqrt(zoom)))
    for _, p in ipairs(pins) do
        if p:IsShown() then
            p:ClearAllPoints()
            p:SetPoint("CENTER", c, "TOPLEFT", p.x * MAP_W * s, -p.y * MAP_H * s)
            local k = p.kind == "n" and size * 0.8 or (p.kind == "l" and size * 0.9 or size)
            p:SetSize(k, k)
        end
    end
end

local function PinTooltip(p)
    GameTooltip:SetOwner(p, "ANCHOR_RIGHT")
    if p.kind == "l" then
        local d = Data()
        local f = d.floors[p.to]
        GameTooltip:AddLine(string.format(T("Passage %s", "Passage %s"), p.label or ""), YELLOW[1], YELLOW[2], YELLOW[3])
        GameTooltip:AddLine(string.format(T("Vers : %s  (clic)", "To: %s  (click)"), f and N(f.n) or "?"), TEXT[1], TEXT[2], TEXT[3])
    elseif p.kind == "n" then
        GameTooltip:AddLine(N(p.name), TEXT[1], TEXT[2], TEXT[3], true)
    else
        local k = KIND[p.kind]
        local title = p.num and (p.num .. ". " .. N(p.name)) or N(p.name)
        GameTooltip:AddLine(title, YELLOW[1], YELLOW[2], YELLOW[3])
        GameTooltip:AddLine(N(k.label), k.ring[1], k.ring[2], k.ring[3])
        if p.note then GameTooltip:AddLine(N(p.note), TEXT[1], TEXT[2], TEXT[3], true) end
    end
    GameTooltip:Show()
end

local function Pin(i)
    local p = pins[i]
    if p then return p end
    p = CreateFrame("Button", nil, win.canvas)
    p:SetFrameLevel(win.canvas:GetFrameLevel() + 5)
    p.disc = p:CreateTexture(nil, "ARTWORK")
    p.disc:SetTexture(DISC)
    p.disc:SetPoint("TOPLEFT", 2, -2); p.disc:SetPoint("BOTTOMRIGHT", -2, 2)
    p.disc:SetVertexColor(0.07, 0.05, 0.03, 0.92)
    p.ring = p:CreateTexture(nil, "OVERLAY")
    p.ring:SetTexture(WP_TEX .. "ring")
    p.ring:SetAllPoints()
    p.icon = p:CreateTexture(nil, "OVERLAY", nil, 1)
    p.icon:SetPoint("TOPLEFT", 4, -4); p.icon:SetPoint("BOTTOMRIGHT", -4, 4)
    p.num = nil
    p.label = FS(p, FONT_BOLD, 11, TEXT, "CENTER")
    p.label:SetPoint("CENTER", 0, 0)
    p:SetScript("OnEnter", PinTooltip)
    p:SetScript("OnLeave", function() GameTooltip:Hide() end)
    p:SetScript("OnClick", function(self)
        if self.kind == "l" and self.to then DM.SetFloor(self.to) end
    end)
    pins[i] = p
    return p
end

local function ShowPins()
    for _, p in ipairs(pins) do p:Hide() end
    local d = Data()
    local list = (not d.instances[current].noPins) and d.pins[current] or nil
    if not list then return end
    -- Bosses are numbered over the whole dungeon, in route order.
    local n, num = 0, 0
    for _, e in ipairs(list) do
        local kind, f, x, y, name, extra = e[1], e[2], e[3], e[4], e[5], e[6]
        local isBoss = kind == "b"
        if isBoss then num = num + 1 end
        if f == floor then
            n = n + 1
            local p = Pin(n)
            p.kind, p.x, p.y, p.name = kind, x, y, name
            p.note, p.to, p.num = nil, nil, nil
            p.icon:Hide(); p.label:Hide(); p.disc:Show(); p.ring:Show()
            if kind == "l" then
                p.label:SetText(name ~= "" and name or ">")
                p.to = extra
                p.label:Show()
                p.ring:SetVertexColor(BRONZE[1], BRONZE[2], BRONZE[3])
                p.label:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
            elseif kind == "n" then
                p.disc:Hide()
                p.ring:Hide()
                p.icon:SetTexture(CODEX_TEX .. "pin")
                p.icon:SetVertexColor(TEXT[1], TEXT[2], TEXT[3], 0.9)
                p.icon:Show()
            else
                local k = KIND[kind]
                p.note = extra
                p.ring:SetVertexColor(k.ring[1], k.ring[2], k.ring[3])
                if isBoss then
                    p.num = num
                    p.label:SetText(num)
                    p.label:SetTextColor(1, 0.91, 0.66)
                    p.label:Show()
                else
                    p.icon:SetTexture(CODEX_TEX .. "diamond")
                    p.icon:SetVertexColor(k.ring[1], k.ring[2], k.ring[3])
                    p.icon:Show()
                end
            end
            p:Show()
        end
    end
end

-- ---------------------------------------------------------------------
-- Floors, list, header
-- ---------------------------------------------------------------------
local function TilePath(id)
    if NO_GAME_TILES and FDRInstalled() then return FDR_TILES .. id end
    return id
end

function DM.SetFloor(f)
    if not (win and current) then return end
    floor = f
    local d = Data()
    local fl = d.floors[f]
    for i, tex in ipairs(win.tiles) do
        local id = fl and fl.t[i]
        if id then tex:SetTexture(TilePath(id)); tex:Show() else tex:Hide() end
    end
    for _, b in ipairs(floorButtons) do b:SetActive(b.floor == f) end
    zoom, panX, panY = 1, 0, 0
    ShowPins()
    LayoutCanvas()
end

local function LayoutFloors()
    local d = Data()
    local inst = d.instances[current]
    for _, b in ipairs(floorButtons) do b:Hide() end
    if #inst.floors < 2 then win.floorBar:Hide() return end
    win.floorBar:Show()
    local x = 0
    local avail = win.floorBar:GetWidth()
    local wEach = math.min(160, math.floor((avail - 4 * (#inst.floors - 1)) / #inst.floors))
    for i, f in ipairs(inst.floors) do
        local b = floorButtons[i]
        if not b then
            b = Button(win.floorBar, 100, FLOOR_H - 4, "", function(self) DM.SetFloor(self.floor) end)
            floorButtons[i] = b
        end
        b.floor = f
        b:SetWidth(wEach)
        b.text:SetWidth(wEach - 8)
        b.text:SetWordWrap(false)
        b.text:SetText(N(d.floors[f].n))
        b:ClearAllPoints()
        b:SetPoint("LEFT", win.floorBar, "LEFT", x, 0)
        b:Show()
        x = x + wEach + 4
    end
end

local function RefreshList()
    local d = Data()
    local entries = {}
    local function Add(raid, heading)
        entries[#entries + 1] = { heading = heading }
        for _, key in ipairs(d.order) do
            local inst = d.instances[key]
            if inst.raid == raid then entries[#entries + 1] = { key = key } end
        end
    end
    Add(false, T("Donjons", "Dungeons"))
    Add(true, T("Raids", "Raids"))
    win.entries = entries
    local visible = math.floor(win.list:GetHeight() / ROW_H)
    listOffset = math.max(0, math.min(listOffset, #entries - visible))
    for i = 1, visible do
        local r = rows[i]
        if not r then
            r = CreateFrame("Button", nil, win.list)
            r:SetHeight(ROW_H)
            r:SetPoint("TOPLEFT", 0, -(i - 1) * ROW_H)
            r:SetPoint("TOPRIGHT", 0, -(i - 1) * ROW_H)
            r.hl = r:CreateTexture(nil, "BACKGROUND")
            r.hl:SetAllPoints()
            r.hl:SetTexture(CODEX_TEX .. "fade_h")
            r.hl:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0)
            r.name = FS(r, FONT, 11, TEXT, "LEFT")
            r.name:SetPoint("LEFT", 8, 0)
            r.name:SetPoint("RIGHT", -40, 0)
            r.name:SetWordWrap(false)
            r.lv = FS(r, FONT, 10, DIM, "RIGHT")
            r.lv:SetPoint("RIGHT", -4, 0)
            r:SetScript("OnClick", function(self) if self.key then DM.Show(self.key) end end)
            r:SetScript("OnEnter", function(self) if self.key and self.key ~= current then self.hl:SetAlpha(0.18) end end)
            r:SetScript("OnLeave", function(self) self.hl:SetAlpha(self.key == current and 0.35 or 0) end)
            rows[i] = r
        end
        local e = entries[i + listOffset]
        r.key = e and e.key
        if not e then
            r:Hide()
        elseif e.heading then
            r.name:SetFont(FONT_BOLD, 11, "")
            r.name:SetText(e.heading)
            r.name:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
            r.lv:SetText("")
            r.hl:SetAlpha(0)
            r:Show()
        else
            local inst = d.instances[e.key]
            r.name:SetFont(FONT, 11, "")
            r.name:SetText(N(inst.n))
            local on = e.key == current
            local c = on and YELLOW or TEXT
            r.name:SetTextColor(c[1], c[2], c[3])
            r.lv:SetText(inst.min == inst.max and tostring(inst.min) or (inst.min .. "-" .. inst.max))
            r.hl:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 1)
            r.hl:SetAlpha(on and 0.35 or 0)
            r:Show()
        end
    end
end

local function CreateWindow()
    if win then return win end
    local FC = TomoMod_ForeverChrome
    win = CreateFrame("Frame", "TomoMod_DungeonMapFrame", UIParent)
    win:SetSize(W, H)
    win:SetPoint("CENTER")
    win:SetFrameStrata("HIGH")
    win:SetClampedToScreen(true)
    win:SetMovable(true)
    win:EnableMouse(true)
    win:Hide()
    tinsert(UISpecialFrames, "TomoMod_DungeonMapFrame")
    if FC then
        win.chrome = FC.Frame(win, { outset = 5, edge = 8, corner = 30, crest = true, crestWidth = 112, crestY = 10,
            fill = true, fillAlpha = 0.96, glintDelay = 12 })
    else
        local bg = win:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(); bg:SetColorTexture(0.07, 0.055, 0.04, 0.96)
    end

    -- Title bar: drag handle, gold title, levels, close.
    local bar = CreateFrame("Frame", nil, win)
    bar:SetPoint("TOPLEFT", 10, -8); bar:SetPoint("TOPRIGHT", -10, -8)
    bar:SetHeight(BAR_H - 8)
    bar:EnableMouse(true)
    bar:RegisterForDrag("LeftButton")
    bar:SetScript("OnDragStart", function() win:StartMoving() end)
    bar:SetScript("OnDragStop", function() win:StopMovingOrSizing() end)
    win.title = FS(bar, FONT_BOLD, 16, YELLOW, "LEFT")
    win.title:SetPoint("LEFT", LIST_W, 0)
    win.sub = FS(bar, FONT, 11, DIM, "LEFT")
    win.sub:SetPoint("LEFT", win.title, "RIGHT", 12, -1)
    local heading = FS(bar, FONT_BOLD, 13, GOLD, "LEFT")
    heading:SetPoint("LEFT", 6, 0)
    heading:SetText(T("Cartes des donjons", "Dungeon maps"))
    local close = CreateFrame("Button", nil, bar)
    close:SetSize(20, 20)
    close:SetPoint("RIGHT", -4, 0)
    close.icon = close:CreateTexture(nil, "ARTWORK")
    close.icon:SetAllPoints()
    close.icon:SetTexture(CODEX_TEX .. "x")
    close.icon:SetVertexColor(GOLD[1], GOLD[2], GOLD[3])
    close:SetScript("OnEnter", function(self) self.icon:SetVertexColor(YELLOW[1], YELLOW[2], YELLOW[3]) end)
    close:SetScript("OnLeave", function(self) self.icon:SetVertexColor(GOLD[1], GOLD[2], GOLD[3]) end)
    close:SetScript("OnClick", function() win:Hide() end)
    local rule = win:CreateTexture(nil, "ARTWORK")
    rule:SetTexture(FC and (FC.TEX .. "divider") or WHITE)
    rule:SetHeight(FC and 10 or 1)
    rule:SetPoint("TOPLEFT", 12, -BAR_H)
    rule:SetPoint("TOPRIGHT", -12, -BAR_H)

    -- Instance list (mouse wheel scrolls).
    local list = CreateFrame("Frame", nil, win)
    list:SetPoint("TOPLEFT", 12, -(BAR_H + 10))
    list:SetPoint("BOTTOMLEFT", 12, FOOT_H + 10)
    list:SetWidth(LIST_W - 22)
    list:EnableMouseWheel(true)
    list:SetScript("OnMouseWheel", function(_, delta)
        listOffset = listOffset - delta * 3
        RefreshList()
    end)
    win.list = list

    -- Floor buttons above the map.
    local floorBar = CreateFrame("Frame", nil, win)
    floorBar:SetPoint("TOPLEFT", LIST_W, -(BAR_H + 10))
    floorBar:SetPoint("TOPRIGHT", -14, -(BAR_H + 10))
    floorBar:SetHeight(FLOOR_H)
    win.floorBar = floorBar

    -- Map view: clips the canvas; wheel zooms on the cursor, drag pans.
    local view = CreateFrame("Frame", nil, win)
    view:SetPoint("TOPLEFT", LIST_W, -(BAR_H + 12 + FLOOR_H))
    view:SetPoint("BOTTOMRIGHT", -14, FOOT_H + 10)
    view:SetClipsChildren(true)
    view:EnableMouse(true)
    view:EnableMouseWheel(true)
    local vbg = view:CreateTexture(nil, "BACKGROUND")
    vbg:SetAllPoints(); vbg:SetColorTexture(0, 0, 0, 0.55)
    win.view = view
    local canvas = CreateFrame("Frame", nil, view)
    canvas:SetSize(MAP_W, MAP_H)
    win.canvas = canvas
    win.tiles = {}
    for i = 1, 12 do win.tiles[i] = canvas:CreateTexture(nil, "ARTWORK") end

    view:SetScript("OnMouseWheel", function(self, delta)
        local old = zoom
        zoom = math.max(1, math.min(MAX_ZOOM, zoom * (delta > 0 and ZOOM_STEP or 1 / ZOOM_STEP)))
        if zoom == old then return end
        -- Keep the point under the cursor in place.
        local scale = self:GetEffectiveScale()
        local cx, cy = GetCursorPosition()
        cx = cx / scale - self:GetLeft()
        cy = self:GetTop() - cy / scale
        local f = zoom / old
        panX = cx - (cx - panX) * f
        panY = cy - (cy - panY) * f
        LayoutCanvas()
    end)
    view:SetScript("OnMouseDown", function(self, button)
        if button ~= "LeftButton" then return end
        local scale = self:GetEffectiveScale()
        local sx, sy = GetCursorPosition()
        local px, py = panX, panY
        self:SetScript("OnUpdate", function()
            local x, y = GetCursorPosition()
            panX = px + (x - sx) / scale
            panY = py - (y - sy) / scale
            LayoutCanvas()
        end)
    end)
    view:SetScript("OnMouseUp", function(self) self:SetScript("OnUpdate", nil) end)
    view:SetScript("OnHide", function(self) self:SetScript("OnUpdate", nil) end)
    view:SetScript("OnSizeChanged", LayoutCanvas)

    -- Message over the map (no tiles on this client), and credits.
    win.msg = FS(view, FONT, 11, TEXT, "CENTER")
    win.msg:SetPoint("BOTTOM", 0, 8)
    win.msg:SetWidth(520)
    win.foot = FS(win, FONT, 9, DIM, "RIGHT")
    win.foot:SetPoint("BOTTOMRIGHT", -16, 10)
    win.foot:SetText(T("Cartes du jeu  -  boss, notes et passages : ForeverDungeonRoutes (Checkov23, licence MIT)  -  molette : zoom, glisser : déplacer",
                       "Game maps  -  bosses, notes and passages: ForeverDungeonRoutes (Checkov23, MIT licence)  -  wheel: zoom, drag: move"))

    win:SetScript("OnShow", function() RefreshList() end)
    return win
end

-- ---------------------------------------------------------------------
-- API
-- ---------------------------------------------------------------------

--- Show a map (map key or codex key), on `onFloor` if given.
function DM.Show(key, onFloor)
    local d = Data()
    key = Resolve(key)
    if not (d and key) then return end
    CreateWindow()
    current = key
    local inst = d.instances[key]
    win.title:SetText(N(inst.n))
    win.sub:SetText(inst.raid and string.format(T("Raid  -  niveau %d", "Raid  -  level %d"), inst.max)
        or string.format(T("Niveaux %d-%d", "Levels %d-%d"), inst.min, inst.max))
    if NO_GAME_TILES and not FDRInstalled() then
        win.msg:SetText(T("Ce client du jeu n'a pas les images de ces cartes : installe ForeverDungeonRoutes pour les voir.",
                          "This game client lacks the pictures of these maps: install ForeverDungeonRoutes to see them."))
        win.msg:Show()
    elseif inst.noPins then
        win.msg:SetText(T("Pic Rochenoire : la carte du jeu, sans les boss du Pic supérieur.",
                          "Blackrock Spire: the game's map, without the Upper Spire bosses."))
        win.msg:Show()
    else
        win.msg:Hide()
    end
    win:Show()
    LayoutFloors()
    local f = onFloor
    if not f then
        f = inst.floors[1]
    end
    DM.SetFloor(f)
    RefreshList()
end

--- Open the window: the given dungeon, else the one the player is in,
-- else the last one shown, else the first.
function DM.Open(key)
    local d = Data()
    if not d then return end
    if key then
        if not Resolve(key) then
            print("|cffffd100TomoModForever|r " .. string.format(T("Pas de carte pour : %s", "No map for: %s"), key))
            return
        end
        DM.Show(key)
        return
    end
    local here, f = Here()
    DM.Show(here or current or d.order[1], f)
end

function DM.Toggle()
    if win and win:IsShown() then win:Hide() else DM.Open() end
end
