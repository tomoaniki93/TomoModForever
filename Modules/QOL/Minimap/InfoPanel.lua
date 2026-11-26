-- =====================================
-- InfoPanel.lua — Integrated Minimap Info
-- Zone header, subzone + coords overlay, clock
-- =====================================

TomoMod_InfoPanel = TomoMod_InfoPanel or {}
local IP = TomoMod_InfoPanel

-- =====================================
-- LOCALS
-- =====================================

local FONT       = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local FONT_BOLD  = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-SemiBold.ttf"
local FONT_BLACK = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Bold.ttf"
local L = TomoMod_L

local zoneBar         -- Frame above minimap (zone name)
local zoneText        -- Zone name FontString
local subZoneText     -- Subzone overlay top-left
local coordsText      -- Coords overlay bottom-center
local clockBar        -- Frame below minimap (clock)
local clockText       -- Clock time FontString
local clockLabel      -- S/L indicator
local durabilityText  -- Gear durability overlay bottom-left
local isInitialized = false

local function DB()
    return TomoModForeverDB and TomoModForeverDB.infoPanel
end

-- [1.3.9] WoW: Forever look (minimap border "forever"): zone name and clock
-- on gold plates set on the minimap's bronze moulding.
local function Forever()
    return TomoMod_ForeverChrome ~= nil and TomoModForeverDB ~= nil and TomoModForeverDB.minimap ~= nil
end
IP.IsForever = Forever
local zonePlate, clockPlate
local lastZone

-- =====================================
-- DURABILITY POSITION (configurable — [12.0.7] the new expansion
-- minimap button can overlap the durability text corner)
-- =====================================

function IP.ApplyDurabilityPosition()
    if not durabilityText or not Minimap then return end
    local db = DB()
    local anchor = (db and db.durabilityAnchor) or "BOTTOMLEFT"
    local x = (db and db.durabilityX) or 6
    local y = (db and db.durabilityY) or 6
    -- Forever: clear of the moulding and of the plates.
    if Forever() then
        if anchor:find("TOP") then y = y - 12 elseif anchor:find("BOTTOM") then y = y + 12 end
        if anchor:find("LEFT") then x = x + 4 elseif anchor:find("RIGHT") then x = x - 4 end
    end
    durabilityText:ClearAllPoints()
    durabilityText:SetPoint(anchor, Minimap, anchor, x, y)
end

-- =====================================
-- HIDE BLIZZARD ELEMENTS
-- =====================================

local hookedPlayerCoords
local function HideBlizzardPlayerCoords()
    local db = DB()
    if not db or not db.enabled then return end
    local container = MinimapCluster and MinimapCluster.MinimapContainer
    local playerCoords = container and container.PlayerCoords
    if not playerCoords then return end

    -- The native coordinates sit below the minimap, on top of our clock.
    -- Blizzard can show them again after a setting or zone change.
    if hookedPlayerCoords ~= playerCoords then
        playerCoords:HookScript("OnShow", function(self)
            local settings = DB()
            if settings and settings.enabled then self:Hide() end
        end)
        hookedPlayerCoords = playerCoords
    end
    playerCoords:Hide()
end

local function HideBlizzardElements()
    HideBlizzardPlayerCoords()
    -- Hide Blizzard clock
    if TimeManagerClockButton then
        TimeManagerClockButton:Hide()
        TimeManagerClockButton:SetAlpha(0)
    end
    if GameTimeFrame then
        GameTimeFrame:Hide()
        GameTimeFrame:SetAlpha(0)
    end

    -- Hide Blizzard zone text
    if MinimapZoneText then
        MinimapZoneText:SetAlpha(0)
    end
    if MinimapZoneTextButton then
        MinimapZoneTextButton:SetAlpha(0)
    end
end

-- =====================================
-- TIME HELPERS
-- =====================================

function IP.GetFormattedTime()
    local hour, minute
    local db = DB()
    if not db then return "00:00" end

    if db.useServerTime then
        hour, minute = GetGameTime()
    else
        local d = date("*t")
        hour, minute = d.hour, d.min
    end

    if db.use24Hour then
        return string.format("%02d:%02d", hour, minute)
    else
        local suffix = hour >= 12 and "PM" or "AM"
        hour = hour % 12
        if hour == 0 then hour = 12 end
        return string.format("%d:%02d %s", hour, minute, suffix)
    end
end

local function GetTimeLabel()
    local db = DB()
    if not db then return "L" end
    return db.useServerTime and "S" or "L"
end

-- =====================================
-- ZONE & COORDS HELPERS
-- =====================================

local function GetZoneName()
    return GetRealZoneText() or ""
end

local function GetSubZoneName()
    local sub = GetSubZoneText()
    if sub and sub ~= "" then return sub end
    return GetMinimapZoneText() or ""
end

local function GetPlayerCoords()
    local map = C_Map.GetBestMapForUnit("player")
    if not map then return nil, nil end
    local pos = C_Map.GetPlayerMapPosition(map, "player")
    if not pos then return nil, nil end
    local x, y = pos:GetXY()
    if x == 0 and y == 0 then return nil, nil end
    return x * 100, y * 100
end

-- =====================================
-- GET ZONE PVP COLOR
-- =====================================

local function GetZonePvPColor()
    local pvpType = C_PvP.GetZonePVPInfo()
    if pvpType == "sanctuary" then
        return 0.41, 0.80, 0.94  -- cyan
    elseif pvpType == "friendly" then
        return 0.10, 0.75, 0.10  -- green
    elseif pvpType == "hostile" then
        return 0.90, 0.15, 0.15  -- red
    elseif pvpType == "contested" then
        return 0.95, 0.65, 0.10  -- orange
    elseif pvpType == "combat" then
        return 1.00, 0.20, 0.20  -- bright red
    else
        return 0.85, 0.85, 0.85  -- neutral grey
    end
end


-- =====================================
-- CREATE UI ELEMENTS
-- =====================================

local function CreateUI()
    if zoneBar then return end

    local db = DB()
    if not db then return end

    local minimap = Minimap
    if not minimap then return end

    -- Get class color for accent
    local classR, classG, classB = 1, 1, 1
    if TomoMod_Utils and TomoMod_Utils.GetClassColor then
        classR, classG, classB = TomoMod_Utils.GetClassColor()
    end

    -- =========================================
    -- ZONE BAR (above minimap)
    -- =========================================
    zoneBar = CreateFrame("Frame", "TomoMod_ZoneBar", minimap, "BackdropTemplate")
    zoneBar:SetHeight(24)
    zoneBar:SetPoint("BOTTOMLEFT", minimap, "TOPLEFT", 0, 2)
    zoneBar:SetPoint("BOTTOMRIGHT", minimap, "TOPRIGHT", 0, 2)
    zoneBar:SetFrameLevel(minimap:GetFrameLevel() + 5)

    zoneBar:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 2,
    })
    zoneBar:SetBackdropColor(0.075, 0.063, 0.050, 0.90)

    -- Border color: class or black
    if TomoModForeverDB.minimap.borderColor == "class" then
        zoneBar:SetBackdropBorderColor(classR, classG, classB, 1)
    else
        zoneBar:SetBackdropBorderColor(0, 0, 0, 1)
    end

    -- Zone name text
    zoneText = zoneBar:CreateFontString(nil, "OVERLAY")
    zoneText:SetFont(FONT_BLACK, 12, "OUTLINE")
    zoneText:SetPoint("CENTER", zoneBar, "CENTER", 0, 0)
    zoneText:SetTextColor(0.949, 0.922, 0.859, 1)
    zoneText:SetText("")

    -- =========================================
    -- OVERLAY: Subzone (top-left on minimap)
    -- =========================================
    subZoneText = minimap:CreateFontString(nil, "OVERLAY")
    subZoneText:SetFont(FONT_BOLD, 11, "OUTLINE")
    subZoneText:SetPoint("TOPLEFT", minimap, "TOPLEFT", 6, -6)
    subZoneText:SetTextColor(0.41, 0.80, 0.94, 1)
    subZoneText:SetText("")

    -- =========================================
    -- OVERLAY: Coords (bottom-center on minimap)
    -- =========================================
    coordsText = minimap:CreateFontString(nil, "OVERLAY")
    coordsText:SetFont(FONT, 11, "OUTLINE")
    coordsText:SetPoint("BOTTOM", minimap, "BOTTOM", 0, 6)
    coordsText:SetTextColor(0.85, 0.85, 0.85, 1)
    coordsText:SetText("")

    -- =========================================
    -- OVERLAY: Durability (position configurable — voir IP.ApplyDurabilityPosition)
    -- =========================================
    durabilityText = minimap:CreateFontString(nil, "OVERLAY")
    durabilityText:SetFont(FONT_BOLD, 11, "OUTLINE")
    durabilityText:SetText("")
    IP.ApplyDurabilityPosition()

    -- =========================================
    -- CLOCK BAR (below minimap)
    -- =========================================
    clockBar = CreateFrame("Button", "TomoMod_ClockBar", minimap, "BackdropTemplate")
    clockBar:SetHeight(28)
    clockBar:SetPoint("TOPLEFT", minimap, "BOTTOMLEFT", 0, -2)
    clockBar:SetPoint("TOPRIGHT", minimap, "BOTTOMRIGHT", 0, -2)
    clockBar:SetFrameLevel(minimap:GetFrameLevel() + 5)

    clockBar:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 2,
    })
    clockBar:SetBackdropColor(0.075, 0.063, 0.050, 0.90)

    if TomoModForeverDB.minimap.borderColor == "class" then
        clockBar:SetBackdropBorderColor(classR, classG, classB, 1)
    else
        clockBar:SetBackdropBorderColor(0, 0, 0, 1)
    end

    -- Clock text (large, centered)
    clockText = clockBar:CreateFontString(nil, "OVERLAY")
    clockText:SetFont(FONT_BLACK, 16, "OUTLINE")
    clockText:SetPoint("CENTER", clockBar, "CENTER", 0, 0)
    clockText:SetTextColor(0.949, 0.922, 0.859, 1)

    -- S/L label (small, right of clock)
    clockLabel = clockBar:CreateFontString(nil, "OVERLAY")
    clockLabel:SetFont(FONT, 9, "OUTLINE")
    clockLabel:SetPoint("LEFT", clockText, "RIGHT", 4, -2)
    clockLabel:SetTextColor(0.45, 0.45, 0.50, 1)

    -- [3.0.5] Exposé pour ancrage externe : le collecteur de la minimap peut se
    -- placer « à gauche/droite de l'horloge » en s'ancrant au TEXTE de l'heure
    -- (centré dans cette barre pleine largeur) plutôt qu'au bord de la barre.
    clockBar.timeText  = clockText
    clockBar.timeLabel = clockLabel

    -- =========================================
    -- CLOCK INTERACTIONS
    -- =========================================
    clockBar:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    clockBar:SetScript("OnClick", function(self, button)
        local db = DB()
        if not db then return end

        if button == "LeftButton" then
            ToggleCalendar()
        elseif button == "RightButton" then
            if IsShiftKeyDown() then
                db.use24Hour = not db.use24Hour
                local fmt = db.use24Hour and "24h" or "12h"
                print("|cffffd100TomoModForever|r " .. string.format(L["time_format_msg"], fmt))
            else
                db.useServerTime = not db.useServerTime
                local mode = db.useServerTime and L["time_server"] or L["time_local"]
                print("|cffffd100TomoModForever|r " .. string.format(L["time_mode_msg"], mode))
            end
            IP.Update()
        end
    end)

    clockBar:SetScript("OnEnter", function(self)
        clockText:SetTextColor(0.788, 0.635, 0.322, 1)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -4)
        GameTooltip:ClearLines()
        local db = DB()
        if db then
            local mode = db.useServerTime and L["time_server"] or L["time_local"]
            local fmt = db.use24Hour and "24h" or "12h"
            GameTooltip:AddLine(string.format(L["time_tooltip_title"], mode, fmt), 1, 1, 1)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(L["time_tooltip_left_click"], 0.8, 0.8, 0.8)
            GameTooltip:AddLine(L["time_tooltip_right_click"], 0.8, 0.8, 0.8)
            GameTooltip:AddLine(L["time_tooltip_shift_right"], 0.8, 0.8, 0.8)
        end
        GameTooltip:Show()
    end)

    clockBar:SetScript("OnLeave", function(self)
        clockText:SetTextColor(0.949, 0.922, 0.859, 1)
        GameTooltip:Hide()
    end)

    IP.ApplyStyle()
    -- Plates follow the minimap size (options slider).
    minimap:HookScript("OnSizeChanged", function()
        if Forever() then IP.ApplyStyle() end
    end)
end

-- =====================================
-- STYLE (TMF bars or Forever plates)
-- =====================================

function IP.ApplyStyle()
    if not zoneBar or not clockBar then return end
    local minimap = Minimap
    local FC = TomoMod_ForeverChrome
    local forever = Forever()

    if forever and not zonePlate then
        zonePlate = FC.Plate(zoneBar, "BACKGROUND", nil, "minimap")
        clockPlate = FC.Plate(clockBar, "BACKGROUND", nil, "minimap")
    end
    if zonePlate then zonePlate:SetShown(forever) end
    if clockPlate then clockPlate:SetShown(forever) end

    zoneBar:ClearAllPoints()
    clockBar:ClearAllPoints()
    subZoneText:ClearAllPoints()
    coordsText:ClearAllPoints()
    if forever then
        local C = FC.C
        zoneBar:SetBackdrop(nil)
        clockBar:SetBackdrop(nil)
        -- Plates sit on the moulding, centred, narrower than the map.
        local w = minimap:GetWidth() or 200
        zoneBar:SetSize(math.max(120, w * 0.82), 28)
        zoneBar:SetPoint("CENTER", minimap, "TOP", 0, 7)
        clockBar:SetSize(math.max(96, w * 0.56), 32)
        clockBar:SetPoint("CENTER", minimap, "BOTTOM", 0, -8)
        zoneText:SetTextColor(C.title[1], C.title[2], C.title[3], 1)
        clockText:SetTextColor(C.text[1], C.text[2], C.text[3], 1)
        clockLabel:SetTextColor(C.antique[1], C.antique[2], C.antique[3], 1)
        coordsText:SetTextColor(C.text[1], C.text[2], C.text[3], 1)
        subZoneText:SetPoint("TOPLEFT", minimap, "TOPLEFT", 10, -18)
        coordsText:SetPoint("BOTTOM", minimap, "BOTTOM", 0, 20)
        zoneBar:SetFrameLevel(minimap:GetFrameLevel() + 8)
        clockBar:SetFrameLevel(minimap:GetFrameLevel() + 8)
    else
        zoneBar:SetHeight(24)
        zoneBar:SetPoint("BOTTOMLEFT", minimap, "TOPLEFT", 0, 2)
        zoneBar:SetPoint("BOTTOMRIGHT", minimap, "TOPRIGHT", 0, 2)
        clockBar:SetHeight(28)
        clockBar:SetPoint("TOPLEFT", minimap, "BOTTOMLEFT", 0, -2)
        clockBar:SetPoint("TOPRIGHT", minimap, "BOTTOMRIGHT", 0, -2)
        local edge = { bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 2 }
        zoneBar:SetBackdrop(edge)
        clockBar:SetBackdrop(edge)
        zoneBar:SetBackdropColor(0.075, 0.063, 0.050, 0.90)
        clockBar:SetBackdropColor(0.075, 0.063, 0.050, 0.90)
        zoneText:SetTextColor(0.949, 0.922, 0.859, 1)
        clockText:SetTextColor(0.949, 0.922, 0.859, 1)
        clockLabel:SetTextColor(0.45, 0.45, 0.50, 1)
        coordsText:SetTextColor(0.85, 0.85, 0.85, 1)
        subZoneText:SetPoint("TOPLEFT", minimap, "TOPLEFT", 6, -6)
        coordsText:SetPoint("BOTTOM", minimap, "BOTTOM", 0, 6)
    end
    IP.ApplyDurabilityPosition()
end

-- =====================================
-- UPDATE
-- =====================================

function IP.Update()
    if not zoneBar or not clockBar then return end
    local db = DB()
    if not db or not db.enabled then return end

    -- Also discover the native frame if it was created after initialization.
    HideBlizzardPlayerCoords()

    -- Zone name (Forever: a soft fade in when it changes)
    local zone = GetZoneName()
    zoneText:SetText(zone)
    if zone ~= lastZone then
        if lastZone and Forever() then TomoMod_ForeverChrome.Flash(zoneText) end
        lastZone = zone
    end

    -- Subzone with PvP color
    local r, g, b = GetZonePvPColor()
    subZoneText:SetTextColor(r, g, b, 1)
    subZoneText:SetText(GetSubZoneName())

    -- Coords
    if db.showCoords ~= false then
        local x, y = GetPlayerCoords()
        if x and y then
            coordsText:SetText(string.format("%.1f, %.1f", x, y))
            coordsText:Show()
        else
            coordsText:SetText("")
        end
    else
        coordsText:Hide()
    end

    -- Clock
    if db.showTime ~= false then
        clockText:SetText(IP.GetFormattedTime())
        clockLabel:SetText(GetTimeLabel())
        clockBar:Show()
    else
        clockBar:Hide()
    end

    -- Durability
    if durabilityText and db.showDurability ~= false then
        local dur = IP.GetAverageDurability()
        local color
        if dur > 50 then
            color = "|cff00ff00"    -- green
        elseif dur > 25 then
            color = "|cffffff00"    -- yellow
        else
            color = "|cffff0000"    -- red
        end
        durabilityText:SetText(string.format("%s%d%%|r", color, dur))
        durabilityText:Show()
    elseif durabilityText then
        durabilityText:Hide()
    end
end

-- =====================================
-- UPDATE APPEARANCE (border sync)
-- =====================================

function IP.UpdateAppearance()
    if not zoneBar or not clockBar then return end

    local classR, classG, classB = 1, 1, 1
    if TomoMod_Utils and TomoMod_Utils.GetClassColor then
        classR, classG, classB = TomoMod_Utils.GetClassColor()
    end

    local useClass = TomoModForeverDB.minimap.borderColor == "class"
    local bR, bG, bB = 0, 0, 0
    if useClass then bR, bG, bB = classR, classG, classB end

    IP.ApplyStyle()
    if Forever() then return end
    zoneBar:SetBackdropBorderColor(bR, bG, bB, 1)
    clockBar:SetBackdropBorderColor(bR, bG, bB, 1)
end

-- =====================================
-- HIDE / SHOW
-- =====================================

function IP.Hide()
    if zoneBar then zoneBar:Hide() end
    if subZoneText then subZoneText:Hide() end
    if coordsText then coordsText:Hide() end
    if durabilityText then durabilityText:Hide() end
    if clockBar then clockBar:Hide() end
end

function IP.Show()
    if zoneBar then zoneBar:Show() end
    if subZoneText then subZoneText:Show() end
    if coordsText then coordsText:Show() end
    if durabilityText then durabilityText:Show() end
    if clockBar then clockBar:Show() end
end

-- =====================================
-- SET POSITION (compatibility stub)
-- =====================================

function IP.SetPosition()
    -- No-op: elements are anchored directly to Minimap
end

-- =====================================
-- DURABILITY HELPER
-- =====================================

function IP.GetAverageDurability()
    local total, count = 0, 0
    for slot = 1, 18 do
        local current, maximum = GetInventoryItemDurability(slot)
        if current and maximum and maximum > 0 then
            total = total + (current / maximum * 100)
            count = count + 1
        end
    end
    return count > 0 and (total / count) or 100
end

-- =====================================
-- INITIALIZE
-- =====================================

function IP.Initialize()
    local db = DB()
    if not db or not db.enabled then return end
    if isInitialized then return end

    -- Migration: add new fields if absent
    if db.showCoords == nil then db.showCoords = true end
    if db.showDurability == nil then db.showDurability = true end
    if db.useServerTime == nil then db.useServerTime = true end

    C_Timer.After(1, function()
        HideBlizzardElements()
        CreateUI()
        IP.Update()

        -- Event-driven updates for zone changes
        local evFrame = CreateFrame("Frame")
        evFrame:RegisterEvent("ZONE_CHANGED")
        evFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
        evFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
        evFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
        evFrame:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
        evFrame:SetScript("OnEvent", function()
            C_Timer.After(0.1, IP.Update)
        end)

        -- Throttled ticker for clock + coords (every 1s)
        C_Timer.NewTicker(1, IP.Update)

        isInitialized = true
    end)
end

-- Alias for compatibility
IP.HideBlizzardClock = HideBlizzardElements
