-- =====================================================================
-- Modules/QOL/Forever/FlightTimer.lua -- flight path timer (WoW: Forever)
--
-- Taking a flight shows a bar with the destination and the time left.
-- Times are LEARNED: the first time a route is flown the bar counts up
-- ("measuring"), and on landing the duration is saved. Next time the bar
-- counts down. A route never flown whole but made of known pieces gets an
-- estimate (marked "≈") from the sum of those pieces.
--
-- Storage. TomoModForeverFlightDB is its own SavedVariable, account-wide
-- and outside profiles, so swapping or resetting a profile never loses
-- what was learned. Routes are keyed by the taxi map and the positions of
-- every node flown over, so the same route is the same key for every
-- character and both factions.
--
-- Times are stored at normal speed: a flight taken with Frequent Flier
-- (20 % faster) is converted before saving and converted back for the bar.
--
-- A flight that does not end normally (early landing, summon, battleground
-- port, death) is not saved. A /reload in flight keeps the bar: the start
-- is kept as a wall-clock time.
-- =====================================================================

TomoMod_FlightTimer = TomoMod_FlightTimer or {}
local FT = TomoMod_FlightTimer

local FONT      = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local FONT_BOLD = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-SemiBold.ttf"
local SOLID     = "Interface\\Buttons\\WHITE8X8"

-- WoW: Forever palette
local BRONZE = { 0.545, 0.420, 0.247 }   -- #8B6B3F
local GOLD   = { 0.788, 0.635, 0.322 }   -- #C9A252
local YELLOW = { 1.000, 0.820, 0.000 }   -- #FFD100
local TEXT   = { 0.949, 0.922, 0.859 }   -- #F2EBDB

local FREQUENT_FLIER_SPELL = 1225490
local FREQUENT_FLIER_SPEED = 1.2

local MIN_FLIGHT   = 5      -- seconds; shorter than this is not a real flight
local RESUME_LIMIT = 1800   -- seconds; an "active" flight older than this is stale
local TICK         = 0.1

local IS_FR = GetLocale() == "frFR"
local function T(fr, en)
    if TomoMod_GUIT then return TomoMod_GUIT(fr, en) end
    return IS_FR and fr or en
end

local function DB() return TomoModForeverDB and TomoModForeverDB.flightTimer end

local function FDB()
    TomoModForeverFlightDB = TomoModForeverFlightDB or {}
    local f = TomoModForeverFlightDB
    f.version = f.version or 1
    f.routes = f.routes or {}
    return f
end

local function SpeedFactor()
    if IsPlayerSpell and IsPlayerSpell(FREQUENT_FLIER_SPELL) then return FREQUENT_FLIER_SPEED end
    return 1
end

local function FormatTime(s)
    s = math.max(0, math.floor(s + 0.5))
    if s >= 3600 then
        return string.format("%d:%02d:%02d", math.floor(s / 3600), math.floor(s % 3600 / 60), s % 60)
    end
    return string.format("%d:%02d", math.floor(s / 60), s % 60)
end

-- ---------------------------------------------------------------------
-- Routes
-- ---------------------------------------------------------------------
local function TaxiMap()
    if GetTaxiMapID then
        local ok, id = pcall(GetTaxiMapID)
        if ok and type(id) == "number" and id > 0 then return id end
    end
    -- Fallback: the continent the player stands on.
    if C_Map and C_Map.GetBestMapForUnit then
        local info = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player") or 0)
        while info and info.mapType and info.mapType > 2 and info.parentMapID do
            info = C_Map.GetMapInfo(info.parentMapID)
        end
        if info and info.mapID then return info.mapID end
    end
    return 0
end

local function NodeKey(i)
    local x, y = TaxiNodePosition(i)
    if not x then return nil end
    return string.format("%.3f:%.3f", x, y)
end

local function NodeName(i)
    local name = TaxiNodeName and TaxiNodeName(i)
    return name and (name:match("^[^,]+") or name) or "?"
end

local function CurrentNode()
    for i = 1, (NumTaxiNodes and NumTaxiNodes() or 0) do
        if TaxiNodeGetType(i) == "CURRENT" then return i end
    end
end

-- Node keys of the whole route, start first, destination last.
local function BuildRoute(current, dest)
    local keys = {}
    local function add(i)
        local k = i and NodeKey(i)
        if k and keys[#keys] ~= k then keys[#keys + 1] = k end
    end
    add(current)
    local hops = GetNumRoutes and GetNumRoutes(dest) or 0
    for h = 2, hops + 1 do
        local ok, slot = pcall(TaxiGetNodeSlot, dest, h, true)
        if ok and slot then add(slot) end
    end
    local destKey = NodeKey(dest)
    if destKey and keys[#keys] ~= destKey then keys[#keys + 1] = destKey end
    return keys
end

local function RouteKey(map, keys, a, b)
    return map .. "|" .. table.concat(keys, ">", a or 1, b or #keys)
end

-- Saved time (normal speed) for the route, exact or estimated from known
-- pieces. Returns seconds, isExact. nil when nothing is known.
local function LookUp(map, keys)
    local routes = FDB().routes
    local n = #keys
    if n < 2 then return nil end
    local exact = routes[RouteKey(map, keys)]
    if exact then return exact, true end
    if n < 3 then return nil end
    -- Shortest cover of the route by known pieces, node 1 to node n.
    local best = { [1] = 0 }
    for j = 2, n do
        for i = 1, j - 1 do
            if best[i] then
                local t = routes[RouteKey(map, keys, i, j)]
                if t and (not best[j] or best[i] + t < best[j]) then best[j] = best[i] + t end
            end
        end
    end
    if best[n] then return best[n], false end
    return nil
end

local function Learn(key, seconds)
    local routes = FDB().routes
    local old = routes[key]
    seconds = math.floor(seconds + 0.5)
    -- A few seconds of noise: smooth. A big gap: the route changed, take the new one.
    if old and math.abs(old - seconds) <= 4 then
        routes[key] = math.floor((old + seconds) / 2 + 0.5)
    else
        routes[key] = seconds
    end
end

function FT.CountRoutes()
    local n = 0
    for _ in pairs(FDB().routes) do n = n + 1 end
    return n
end

function FT.ForgetAll()
    FDB().routes = {}
end

-- ---------------------------------------------------------------------
-- Bar
-- ---------------------------------------------------------------------
local bar
local flight      -- { key, dest, startGT, total (bar seconds) or nil, exact, factor, dirty }
local preview = false

local function Edge(parent, layer)
    local t = parent:CreateTexture(nil, layer or "BORDER")
    t:SetTexture(SOLID)
    t:SetVertexColor(BRONZE[1], BRONZE[2], BRONZE[3], 1)
    return t
end

local function CreateBar()
    if bar then return bar end
    bar = CreateFrame("Frame", "TomoMod_FlightTimerBar", UIParent)
    bar:SetSize(260, 34)
    bar:SetFrameStrata("MEDIUM")
    bar:SetClampedToScreen(true)

    local bg = bar:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(SOLID)
    bg:SetVertexColor(0.06, 0.05, 0.04, 0.88)

    -- 1 px aged-bronze frame
    local top, bot, left, right = Edge(bar), Edge(bar), Edge(bar), Edge(bar)
    top:SetPoint("TOPLEFT"); top:SetPoint("TOPRIGHT"); top:SetHeight(1)
    bot:SetPoint("BOTTOMLEFT"); bot:SetPoint("BOTTOMRIGHT"); bot:SetHeight(1)
    left:SetPoint("TOPLEFT"); left:SetPoint("BOTTOMLEFT"); left:SetWidth(1)
    right:SetPoint("TOPRIGHT"); right:SetPoint("BOTTOMRIGHT"); right:SetWidth(1)

    local sb = CreateFrame("StatusBar", nil, bar)
    sb:SetPoint("BOTTOMLEFT", 3, 3)
    sb:SetPoint("BOTTOMRIGHT", -3, 3)
    sb:SetHeight(6)
    sb:SetStatusBarTexture(SOLID)
    sb:SetStatusBarColor(GOLD[1], GOLD[2], GOLD[3], 1)
    sb:SetMinMaxValues(0, 1)
    local sbBg = sb:CreateTexture(nil, "BACKGROUND")
    sbBg:SetAllPoints()
    sbBg:SetTexture(SOLID)
    sbBg:SetVertexColor(BRONZE[1], BRONZE[2], BRONZE[3], 0.25)
    bar.sb = sb

    local spark = sb:CreateTexture(nil, "OVERLAY")
    spark:SetTexture(SOLID)
    spark:SetVertexColor(YELLOW[1], YELLOW[2], YELLOW[3], 0.9)
    spark:SetSize(2, 8)
    bar.spark = spark

    local icon = bar:CreateTexture(nil, "ARTWORK")
    icon:SetSize(18, 18)
    icon:SetPoint("TOPLEFT", 4, -3)
    icon:SetTexture("Interface\\Icons\\Ability_Mount_Gryphon_01")
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    bar.icon = icon

    local dest = bar:CreateFontString(nil, "OVERLAY")
    dest:SetFont(FONT_BOLD, 11, "OUTLINE")
    dest:SetPoint("LEFT", icon, "RIGHT", 5, 0)
    dest:SetTextColor(TEXT[1], TEXT[2], TEXT[3])
    dest:SetJustifyH("LEFT")
    dest:SetWordWrap(false)
    bar.dest = dest

    local timeFS = bar:CreateFontString(nil, "OVERLAY")
    timeFS:SetFont(FONT_BOLD, 12, "OUTLINE")
    timeFS:SetPoint("RIGHT", bar, "TOPRIGHT", -6, -12)
    timeFS:SetTextColor(YELLOW[1], YELLOW[2], YELLOW[3])
    timeFS:SetJustifyH("RIGHT")
    bar.time = timeFS
    dest:SetPoint("RIGHT", timeFS, "LEFT", -6, 0)

    local U = TomoMod_Utils
    if U and U.SetupDraggable then
        U.SetupDraggable(bar, function()
            local d = DB()
            if d then
                d.position = d.position or {}
                U.SaveFramePosition(bar, d.position)
            end
        end, T("Temps de vol", "Flight timer"))
    end

    bar:SetScript("OnUpdate", function(self, elapsed)
        self._acc = (self._acc or 0) + elapsed
        if self._acc < TICK then return end
        self._acc = 0
        FT.Tick()
    end)
    bar:Hide()
    FT.ApplySettings()
    return bar
end

local function Render()
    if not (bar and flight) then return end
    local db = DB() or {}
    local elapsed = GetTime() - flight.startGT
    local destText = flight.dest or "?"
    if flight.total and flight.total > 0 then
        local left = flight.total - elapsed
        local p = math.min(1, math.max(0, elapsed / flight.total))
        if db.fillMode ~= "fill" then p = 1 - p end
        bar.sb:SetValue(p)
        local prefix = flight.exact and "" or "≈ "
        if left < 0 then
            bar.time:SetText(T("Arrivée…", "Landing…"))
        else
            bar.time:SetText(prefix .. FormatTime(left))
        end
    else
        -- Unknown route: count up, bar pulses gently.
        bar.sb:SetValue(0.5 + 0.5 * math.sin(GetTime() * 2))
        bar.time:SetText(FormatTime(elapsed))
        local note = flight.early and T("(atterrissage anticipé)", "(early landing)") or T("(mesure)", "(measuring)")
        destText = destText .. "  |cff8b6b3f" .. note .. "|r"
    end
    bar.dest:SetText(destText)
    local w = bar.sb:GetWidth()
    local v = bar.sb:GetValue()
    bar.spark:ClearAllPoints()
    bar.spark:SetPoint("CENTER", bar.sb, "LEFT", w * v, 0)
end

local function StopFlight()
    flight = nil
    FDB().active = nil
    if bar then
        if preview then FT.Preview(true) else bar:Hide() end
    end
end

local function Land()
    if not flight then return end
    local f = flight
    local measured = (GetTime() - f.startGT) * (f.factor or 1)
    if not f.dirty and f.key and measured >= MIN_FLIGHT then
        -- An estimate that came out wildly short means the flight was cut.
        local known = f.total and f.total * (f.factor or 1)
        if not (known and f.exact and measured < known * 0.6) then
            Learn(f.key, measured)
        end
    end
    StopFlight()
end

function FT.Tick()
    if not flight then return end
    if flight._preview then Render(); return end
    local elapsed = GetTime() - flight.startGT
    if elapsed > 3 and not UnitOnTaxi("player") then
        Land()
        return
    end
    Render()
end

local function ShowFlight()
    local db = DB()
    if not (db and db.enabled) then return end
    CreateBar()
    Render()
    bar:Show()
end

-- ---------------------------------------------------------------------
-- Taxi hooks
-- ---------------------------------------------------------------------
local function OnTakeTaxi(node)
    local db = DB()
    if not (db and db.enabled) then return end
    local current = CurrentNode()
    if not current or current == node then return end
    local map = TaxiMap()
    local keys = BuildRoute(current, node)
    if #keys < 2 then return end
    local factor = SpeedFactor()
    local saved, exact = LookUp(map, keys)
    flight = {
        key = RouteKey(map, keys),
        dest = NodeName(node),
        startGT = GetTime(),
        total = saved and saved / factor or nil,
        exact = exact,
        factor = factor,
    }
    FDB().active = {
        key = flight.key, dest = flight.dest, start = time(),
        total = flight.total, exact = exact, factor = factor,
    }
    -- The taxi takes a moment to start; give up if it never does.
    local tries = 0
    local function check()
        if not flight then return end
        if UnitOnTaxi("player") then
            flight.startGT = GetTime()
            FDB().active.start = time()
            ShowFlight()
        elseif tries < 6 then
            tries = tries + 1
            C_Timer.After(0.5, check)
        else
            StopFlight()
        end
    end
    C_Timer.After(0.5, check)
end

-- The flight will not end where it was timed: never save it.
local function MarkDirty()
    if flight then flight.dirty = true end
    local a = FDB().active
    if a then a.dirty = true end
end

-- Early landing: the bar can no longer count down to the destination.
local function MarkEarly()
    MarkDirty()
    if flight then flight.total, flight.early = nil, true end
    local a = FDB().active
    if a then a.total, a.early = nil, true end
end

local function OnNodeEnter(button)
    local db = DB()
    if not (db and db.enabled and db.mapTooltip) or not button then return end
    local id = button.GetID and button:GetID()
    local current = CurrentNode()
    if not (id and current) or id == current then return end
    if TaxiNodeGetType(id) ~= "REACHABLE" then return end
    local keys = BuildRoute(current, id)
    local saved, exact = LookUp(TaxiMap(), keys)
    if saved then
        local t = FormatTime(saved / SpeedFactor())
        GameTooltip:AddLine((exact and T("Durée : ", "Duration: ") or T("Durée estimée : ≈ ", "Estimated duration: ≈ ")) .. t,
            TEXT[1], TEXT[2], TEXT[3])
    else
        GameTooltip:AddLine(T("Durée : inconnue (mesurée pendant ce vol)", "Duration: unknown (measured on this flight)"),
            BRONZE[1] + 0.2, BRONZE[2] + 0.2, BRONZE[3] + 0.2)
    end
    GameTooltip:Show()
end

local function SafeHook(tbl, name, fn)
    if tbl == _G then
        if type(_G[name]) == "function" then hooksecurefunc(name, fn) end
    elseif tbl and type(tbl[name]) == "function" then
        hooksecurefunc(tbl, name, fn)
    end
end

-- ---------------------------------------------------------------------
-- Public
-- ---------------------------------------------------------------------
function FT.ApplySettings()
    local db = DB()
    if not (db and bar) then return end
    bar:SetScale(db.scale or 1)
    bar:SetWidth(db.width or 260)
    local U = TomoMod_Utils
    if U and U.ApplyFramePosition and db.position then U.ApplyFramePosition(bar, db.position) end
    Render()
end

function FT.Preview(on)
    CreateBar()
    preview = on and true or false
    if preview then
        flight = flight or {
            dest = T("Hurlevent", "Stormwind"), startGT = GetTime() - 40, total = 155, exact = true,
            factor = 1, dirty = true, _preview = true,
        }
        Render()
        bar:Show()
    else
        if flight and flight._preview then flight = nil end
        if not flight then bar:Hide() end
    end
end
function FT.IsPreview() return preview end

function FT.SetEnabled(v)
    local db = DB()
    if not db then return end
    db.enabled = v and true or false
    if not v then
        preview = false
        flight = nil
        if bar then bar:Hide() end
    elseif UnitOnTaxi and UnitOnTaxi("player") then
        FT.Resume()
    end
end

-- Picks up the flight in progress after a /reload or a relog.
function FT.Resume()
    local a = FDB().active
    if not a then return end
    local age = time() - (a.start or 0)
    if not UnitOnTaxi("player") or age > RESUME_LIMIT or age < 0 then
        FDB().active = nil
        return
    end
    flight = {
        key = a.key, dest = a.dest, startGT = GetTime() - age,
        total = a.total, exact = a.exact, factor = a.factor or 1, dirty = a.dirty, early = a.early,
    }
    ShowFlight()
end

function FT.Initialize()
    local db = DB()
    if not db then return end
    FDB()

    SafeHook(_G, "TakeTaxiNode", OnTakeTaxi)
    SafeHook(_G, "TaxiNodeOnButtonEnter", OnNodeEnter)
    SafeHook(_G, "TaxiRequestEarlyLanding", MarkEarly)
    SafeHook(_G, "AcceptBattlefieldPort", MarkDirty)
    if C_SummonInfo then SafeHook(C_SummonInfo, "ConfirmSummon", MarkDirty) end

    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("PLAYER_DEAD")
    f:RegisterEvent("PLAYER_CONTROL_GAINED")
    f:SetScript("OnEvent", function(_, event)
        local d = DB()
        if not (d and d.enabled) then return end
        if event == "PLAYER_ENTERING_WORLD" then
            -- Loading screen mid-flight (instance portal, summon): drop it.
            if flight and not UnitOnTaxi("player") then
                MarkDirty(); StopFlight()
            elseif not flight then
                C_Timer.After(1, FT.Resume)
            end
        elseif event == "PLAYER_DEAD" then
            MarkDirty()
        elseif event == "PLAYER_CONTROL_GAINED" then
            -- Landing: let the next tick confirm UnitOnTaxi is false.
            if flight and not preview then C_Timer.After(0.2, FT.Tick) end
        end
    end)

    if TomoMod_Movers and TomoMod_Movers.RegisterEntry then
        TomoMod_Movers.RegisterEntry({
            label    = T("Temps de vol", "Flight timer"),
            unlock   = function() FT.Preview(true); if bar and bar.SetLocked then bar:SetLocked(false) end end,
            lock     = function() if bar and bar.SetLocked then bar:SetLocked(true) end; FT.Preview(false) end,
            isActive = function() local d = DB(); return d and d.enabled end,
        })
    end
end
