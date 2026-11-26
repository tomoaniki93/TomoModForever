-- =====================================================================
-- Modules/QOL/Forever/ResourceGlow.lua -- glow on ore, herbs, chests and
-- quest objects (1.3.9)
--
-- Idea seen in the Lueur addon: the game's soft targeting already picks,
-- at any moment, the one interactive world object closest to the player
-- (the "softinteract" unit) and can give it a nameplate. TMF hangs a glow
-- on that nameplate. Nothing of Lueur's code or art is used: TMF textures,
-- TMF code.
--
--   What it is   read from the cursor the game would show on the object
--                (SetUnitCursorTexture): mining pick, herb hand, lock or
--                loot hand. Quest objects: the game ties the object to an
--                active quest (UnitIsRelatedToActiveQuest, or a quest line
--                in its tooltip). Chests: a chest word in the name, or an
--                object the player has already looted (learned from the
--                loot window, by object ID).
--   States       far (out of interact range): soft and slow; ready: bright,
--                turning arcs and rising sparks; locked (skill too low,
--                locked chest): red.
--   CVars        while on: SoftTargetInteract 3, range (5-15 yd, the
--                client loses the target past 15), all-around arc,
--                SoftTargetIconGameObject 1 (no object nameplate without
--                it). SoftTargetNameplateInteract is opened only for an
--                object that should glow, so NPCs and chairs get no extra
--                nameplate. The player's values are kept, given back at
--                logout (taken again at login) and when the option is
--                turned off. Nothing is written in combat.
--   Others       stands down when Lueur is loaded. Fishing.lua widens the
--                same CVars while fishing and puts back what it found
--                (ours); the bobber is left to it.
-- =====================================================================

TomoMod_ResourceGlow = TomoMod_ResourceGlow or {}
local RG = TomoMod_ResourceGlow

local SOFT = "softinteract"
local TEX  = "Interface\\AddOns\\TomoModForever\\Assets\\Textures\\"
local POLL = 0.15

local COLORS = {
    ore   = { 0.95, 0.55, 0.25 },
    herb  = { 0.45, 0.95, 0.45 },
    chest = { 0.50, 0.80, 1.00 },
    quest = { 1.00, 0.82, 0.20 },
}
local LOCKED = { 0.95, 0.25, 0.20 }

local function DB() return TomoModForeverDB and TomoModForeverDB.resourceGlow end

local secret = issecretvalue
local function Clean(v) if v ~= nil and secret and secret(v) then return nil end return v end
local function Safe(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, a, b = pcall(fn, ...)
    if not ok then return nil end
    return Clean(a), Clean(b)
end

local function LueurLoaded()
    if C_AddOns and C_AddOns.IsAddOnLoaded then return C_AddOns.IsAddOnLoaded("Lueur") and true or false end
    return IsAddOnLoaded and IsAddOnLoaded("Lueur") and true or false
end

local function Active()
    local db = DB()
    return db and db.enabled and not RG.standDown
end

-- ---------------------------------------------------------------------
-- CVars
-- ---------------------------------------------------------------------
local MANAGED = {
    "SoftTargetInteract", "SoftTargetInteractRange", "SoftTargetInteractArc",
    "SoftTargetInteractOnlyInRange", "SoftTargetIconGameObject",
    "SoftTargetNameplateInteract", "nameplateGameObjectMaxDistance",
}

local function GetCV(name)
    local fn = C_CVar and C_CVar.GetCVar or GetCVar
    local ok, v = pcall(fn, name)
    if ok then return v end
end
local function SetCV(name, value)
    if GetCV(name) == nil then return end
    pcall(C_CVar and C_CVar.SetCVar or SetCVar, name, tostring(value))
end

local gate        -- nameplate for the soft target open (true/false), nil = unknown
local pending     -- "apply" | "restore" waiting for the end of combat

local function ApplyCVars()
    local db = DB()
    if not db then return end
    if InCombatLockdown() then pending = "apply" return end
    -- Captured once: kept across logouts, so a value we gave back and
    -- write again is never mistaken for the player's.
    if type(db.saved) ~= "table" then
        db.saved = {}
        for _, name in ipairs(MANAGED) do db.saved[name] = GetCV(name) or false end
    end
    SetCV("SoftTargetInteract", 3)
    SetCV("SoftTargetInteractRange", math.max(5, math.min(15, db.range or 15)))
    SetCV("SoftTargetInteractArc", 2)
    SetCV("SoftTargetInteractOnlyInRange", 0)
    SetCV("SoftTargetIconGameObject", 1)
    SetCV("nameplateGameObjectMaxDistance", math.max(tonumber(db.saved.nameplateGameObjectMaxDistance) or 0, 40))
    gate = nil
    RG.applied = true
end

-- forget: the option is turned off, the next apply captures again.
local function RestoreCVars(forget)
    local db = DB()
    if not (db and type(db.saved) == "table") then return end
    if InCombatLockdown() then pending = "restore" return end
    for name, value in pairs(db.saved) do
        if value ~= false then SetCV(name, value) end
    end
    if forget then db.saved = nil end
    gate = nil
    RG.applied = false
end

local function SetGate(open)
    if open == gate or InCombatLockdown() or not RG.applied then return end
    gate = open
    if open then
        SetCV("SoftTargetNameplateInteract", 1)
    else
        local db = DB()
        local orig = db and db.saved and db.saved.SoftTargetNameplateInteract
        SetCV("SoftTargetNameplateInteract", (orig and orig ~= false) and orig or 0)
    end
end

-- ---------------------------------------------------------------------
-- What the target is
-- ---------------------------------------------------------------------
local probe
local cursorIDs = {}   -- fileID -> { category, unable }
local CURSORS = {
    Mine = "ore", GatherHerbs = "herb",
    PickLock = "chest", LootAll = "chest",
    Quest = "quest", QuestInteract = "quest", QuestTurnIn = "quest", QuestRepeatable = "quest",
}
local KEYWORDS = {
    { "gather", "herb" }, { "herb", "herb" }, { "mine", "ore" },
    { "picklock", "chest" }, { "lootall", "chest" }, { "quest", "quest" },
}

local function BuildCursors()
    probe = UIParent:CreateTexture(nil, "BACKGROUND")
    probe:Hide()
    if not GetFileIDFromPath then return end
    for name, cat in pairs(CURSORS) do
        for _, prefix in ipairs({ "", "Unable" }) do
            local path = "Interface\\Cursor\\" .. prefix .. name
            local id = Safe(GetFileIDFromPath, path) or Safe(GetFileIDFromPath, path .. ".blp")
            if id then cursorIDs[id] = { cat, prefix ~= "" } end
        end
    end
end

local function FromName(s)
    if type(s) ~= "string" then return nil end
    s = s:lower()
    local unable = s:find("unable", 1, true) ~= nil
    for _, k in ipairs(KEYWORDS) do
        if s:find(k[1], 1, true) then return k[2], unable end
    end
    return nil, unable
end

local function ReadCursor(unit)
    if not (probe and SetUnitCursorTexture) then return nil end
    local ok, has = pcall(SetUnitCursorTexture, probe, unit, nil, true)
    if not ok or not has then return nil end
    local tex = Clean(probe:GetTexture())
    local known = type(tex) == "number" and cursorIDs[tex]
    if known then return known[1], known[2] end
    local cat, unable = FromName(tex)
    if not cat and probe.GetAtlas then
        local atlas = Clean(probe:GetAtlas())
        local c2, u2 = FromName(atlas)
        cat, unable = c2, unable or u2
    end
    return cat, unable
end

local function ObjectID(unit)
    local guid = Safe(UnitGUID, unit)
    return type(guid) == "string" and tonumber(guid:match("^GameObject%-%d+%-%d+%-%d+%-%d+%-(%d+)")) or nil
end

local QUEST_LINE = Enum and Enum.TooltipDataLineType and Enum.TooltipDataLineType.QuestObjective
local function IsQuestObject(unit)
    if C_QuestLog and C_QuestLog.UnitIsRelatedToActiveQuest then
        if Safe(C_QuestLog.UnitIsRelatedToActiveQuest, unit) == true then return true end
    end
    if QUEST_LINE and C_TooltipInfo and C_TooltipInfo.GetUnit then
        local data = Safe(C_TooltipInfo.GetUnit, unit)
        if type(data) == "table" and type(data.lines) == "table" then
            for _, line in ipairs(data.lines) do
                if line.type == QUEST_LINE then return true end
            end
        end
    end
    return false
end

-- Chest words in the client languages, compared without case. A word of
-- the name that starts with one of them is enough ("Coffre endommagé",
-- "Battered Chest", "Footlocker").
local CHEST_WORDS = {
    "chest", "coffer", "strongbox", "lockbox", "footlocker", "trunk", "crate",
    "coffre", "caisse", "malle", "cassette",
    "truhe", "kiste", "schatulle",
    "cofre", "arcón", "baúl", "caja",
    "forziere", "scrigno", "baule", "cassa",
    "baú", "arca",
}
local gathered = {}   -- object IDs the game showed as ore or herb

local function IsChest(id, name)
    local db = DB()
    if id and db and type(db.containers) == "table" and db.containers[id] then return true end
    if type(name) ~= "string" then return false end
    local lower = name:lower()
    for word in lower:gmatch("[^%s%p]+") do
        for _, chest in ipairs(CHEST_WORDS) do
            if word:sub(1, #chest) == chest then return true end
        end
    end
    return false
end

local function LearnContainers()
    local db = DB()
    if not (db and GetNumLootItems and GetLootSourceInfo) then return end
    db.containers = type(db.containers) == "table" and db.containers or {}
    for slot = 1, Safe(GetNumLootItems) or 0 do
        local guid = Safe(GetLootSourceInfo, slot)
        local id = type(guid) == "string" and tonumber(guid:match("^GameObject%-%d+%-%d+%-%d+%-%d+%-(%d+)"))
        if id and id ~= 35591 and not gathered[id] then db.containers[id] = true end
    end
end

-- Has the character the profession? true / false, nil when the game does
-- not say yet (keeps the glow).
local FINDERS = { herb = 2383, ore = 2580 }   -- Find Herbs, Find Minerals
local function Trained(cat)
    local spell = FINDERS[cat]
    if not spell then return true end
    local known = Safe(IsPlayerSpell, spell)
    if known == nil and C_SpellBook and C_SpellBook.IsSpellKnown then known = Safe(C_SpellBook.IsSpellKnown, spell) end
    if known == nil then return true end
    return known
end

-- What an object is does not change while it is targeted: kept per GUID,
-- read again when the target or the quest log changes. Only "unable" (the
-- cursor) is read on every poll.
local cache = { guid = nil, cat = nil }
local function Invalidate() cache.guid = nil end
RG.Invalidate = Invalidate

local Classify
local function ClassifyFresh(unit)
    if Safe(UnitIsGameObject, unit) ~= true then return nil end
    local cat, unable = ReadCursor(unit)
    local id = ObjectID(unit)
    if id == 35591 then return nil end           -- fishing bobber: Fishing.lua
    if cat == "ore" or cat == "herb" then
        if id then gathered[id] = true end
        return cat, unable
    end
    if IsQuestObject(unit) or cat == "quest" then return "quest", unable end
    local name = Safe(UnitName, unit)
    if cat == "chest" or IsChest(id, name) then return "chest", unable end
    return nil
end

function Classify(unit)
    local guid = Safe(UnitGUID, unit)
    if guid and guid == cache.guid then
        if not cache.cat then return nil end
        local _, unable = ReadCursor(unit)
        return cache.cat, unable
    end
    local cat, unable = ClassifyFresh(unit)
    cache.guid, cache.cat = guid, cat
    return cat, unable
end

-- ---------------------------------------------------------------------
-- The glow
-- ---------------------------------------------------------------------
local glow          -- the frame
local anchorPlate   -- nameplate it follows
local current = { cat = nil, state = nil }

local function Tex(parent, file, layer, size)
    local t = parent:CreateTexture(nil, layer or "ARTWORK")
    t:SetTexture(TEX .. file)
    t:SetBlendMode("ADD")
    t:SetPoint("CENTER")
    if size then t:SetSize(size, size) end
    return t
end

local function BuildGlow()
    local f = CreateFrame("Frame", "TomoMod_ResourceGlowFrame", UIParent)
    f:SetFrameStrata("BACKGROUND")
    f:SetSize(100, 100)
    f:Hide()
    f.halo  = Tex(f, "Waypoint\\glow.tga", "BACKGROUND")
    f.core  = Tex(f, "Animation\\Glow.tga", "BORDER")
    f.arcs  = Tex(f, "Animation\\RingTri.tga", "ARTWORK")
    f.wave  = Tex(f, "Waypoint\\ring.tga", "ARTWORK")
    f.sparks = {}
    for i = 1, 4 do
        local s = Tex(f, "Animation\\Ember.tga", "OVERLAY", 10)
        s.phase = (i - 1) / 4
        s.x = (i % 2 == 0 and 1 or -1) * (8 + i * 5)
        f.sparks[i] = s
    end
    f.t = 0
    f:SetScript("OnUpdate", function(self, elapsed)
        self.t = self.t + elapsed
        local db = DB()
        local size = (db and db.size) or 110
        local amp = (db and db.intensity) or 1
        local anim = TomoMod_Utils and TomoMod_Utils.AnimLevel and TomoMod_Utils.AnimLevel() or "full"
        local t = (anim == "none") and 0 or self.t
        local state = current.state
        local speed = state == "ready" and 1 or 0.45
        local pulse = 0.5 + 0.5 * math.sin(t * 3.2 * speed)

        self.halo:SetSize(size * (1.0 + 0.08 * pulse), size * (1.0 + 0.08 * pulse))
        self.core:SetSize(size * 0.55, size * 0.55)
        if state == "far" then
            self.halo:SetAlpha((0.25 + 0.15 * pulse) * amp)
            self.core:SetAlpha(0.25 * amp)
        else
            self.halo:SetAlpha((0.45 + 0.25 * pulse) * amp)
            self.core:SetAlpha((0.55 + 0.25 * pulse) * amp)
        end

        local showArcs = state == "ready" and anim ~= "none"
        self.arcs:SetShown(showArcs)
        if showArcs then
            self.arcs:SetSize(size * 0.85, size * 0.85)
            self.arcs:SetRotation(-t * 1.2)
            self.arcs:SetAlpha(0.7 * amp)
        end

        -- Expanding ring, once a second (full animations only).
        local showWave = state ~= "locked" and anim == "full"
        self.wave:SetShown(showWave)
        if showWave then
            local p = (t * (state == "ready" and 0.9 or 0.5)) % 1
            self.wave:SetSize(size * (0.3 + 0.8 * p), size * (0.3 + 0.8 * p))
            self.wave:SetAlpha((1 - p) * 0.6 * amp)
        end

        local showSparks = state == "ready" and anim == "full"
        for _, s in ipairs(self.sparks) do
            s:SetShown(showSparks)
            if showSparks then
                local p = (t * 0.6 + s.phase) % 1
                s:ClearAllPoints()
                s:SetPoint("CENTER", self, "CENTER", s.x * (1 - p * 0.5), -size * 0.15 + p * size * 0.6)
                s:SetAlpha(math.sin(p * math.pi) * amp)
            end
        end
    end)
    return f
end

local function Paint(cat, state)
    local c = state == "locked" and LOCKED or COLORS[cat] or COLORS.quest
    for _, t in ipairs({ glow.halo, glow.core, glow.arcs, glow.wave }) do
        t:SetVertexColor(c[1], c[2], c[3])
    end
    for _, s in ipairs(glow.sparks) do s:SetVertexColor(c[1], c[2], c[3]) end
end

local function Release()
    if glow then glow:Hide(); glow:ClearAllPoints() end
    anchorPlate = nil
    current.cat, current.state = nil, nil
end

local function Show(plate, cat, state)
    glow = glow or BuildGlow()
    local db = DB()
    if anchorPlate ~= plate then
        glow:ClearAllPoints()
        glow:SetPoint("CENTER", plate, "CENTER", 0, (db and db.offsetY) or -40)
        anchorPlate = plate
        glow.t = 0
    end
    if current.cat ~= cat or current.state ~= state then
        current.cat, current.state = cat, state
        Paint(cat, state)
    end
    glow:Show()
end

-- ---------------------------------------------------------------------
-- Evaluation
-- ---------------------------------------------------------------------
local activeUnits = {}   -- nameplateN -> true

local function PlateFor(unit)
    local GetPlate = C_NamePlate and C_NamePlate.GetNamePlateForUnit
    local plate = Safe(GetPlate, unit)
    if plate then return plate end
    -- Some clients do not answer for "softinteract": find it among the plates.
    for token in pairs(activeUnits) do
        if Safe(UnitIsUnit, token, unit) == true then return Safe(GetPlate, token) end
    end
end

local function Paused()
    local db = DB()
    if db.hideInCombat and InCombatLockdown() then return true end
    return false
end

local function Evaluate()
    if not Active() then Release() return end
    local db = DB()
    if Paused() then Release() return end
    local exists = Safe(UnitExists, SOFT) == true or Safe(UnitIsGameObject, SOFT) == true
    if not exists then SetGate(false); Release() return end

    local cat, unable = Classify(SOFT)
    local wanted = cat and db[cat] ~= false
    if wanted and db.onlyTrained and Trained(cat) == false then wanted = false end
    if not wanted then SetGate(false); Release() return end

    SetGate(true)
    local plate = PlateFor(SOFT)
    if not plate then Release() return end   -- coming: NAME_PLATE_UNIT_ADDED

    local inRange = Safe(UnitIsInInteractRange, SOFT)
    local state
    if inRange == false then state = "far"
    elseif unable then state = (inRange == true) and "locked" or "far"
    else state = "ready" end
    if state == "locked" and db.hideLocked then Release() return end
    Show(plate, cat, state)
end
RG.Evaluate = Evaluate

-- ---------------------------------------------------------------------
-- Events
-- ---------------------------------------------------------------------
local ev = CreateFrame("Frame")
local poller = CreateFrame("Frame")
local since = 0
poller:Hide()
poller:SetScript("OnUpdate", function(_, elapsed)
    since = since + elapsed
    if since < POLL then return end
    since = 0
    Evaluate()
end)

ev:SetScript("OnEvent", function(_, event, arg1)
    if event == "PLAYER_SOFT_INTERACT_CHANGED" or event == "QUEST_LOG_UPDATE" then
        Invalidate()
        Evaluate()
    elseif event == "NAME_PLATE_UNIT_ADDED" then
        activeUnits[arg1] = true
        Evaluate()
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        activeUnits[arg1] = nil
        local GetPlate = C_NamePlate and C_NamePlate.GetNamePlateForUnit
        if anchorPlate and Safe(GetPlate, arg1) == anchorPlate then Release() end
    elseif event == "LOOT_READY" or event == "LOOT_OPENED" then
        LearnContainers()
        Invalidate()
    elseif event == "PLAYER_ENTERING_WORLD" then
        if Active() then ApplyCVars() end
    elseif event == "PLAYER_REGEN_ENABLED" then
        if pending == "apply" and Active() then ApplyCVars()
        elseif pending == "restore" then RestoreCVars(not Active()) end
        pending = nil
        Evaluate()
    elseif event == "PLAYER_REGEN_DISABLED" then
        Evaluate()
    elseif event == "PLAYER_LOGOUT" then
        -- The game gets the player's values back: turning TMF off in the
        -- addon list leaves nothing behind. Taken again at the next login.
        if RG.applied then RestoreCVars(false) end
    end
end)

local EVENTS = {
    "PLAYER_SOFT_INTERACT_CHANGED", "NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_REMOVED",
    "QUEST_LOG_UPDATE", "LOOT_READY", "LOOT_OPENED", "PLAYER_ENTERING_WORLD",
    "PLAYER_REGEN_ENABLED", "PLAYER_REGEN_DISABLED", "PLAYER_LOGOUT",
}

function RG.ApplySettings()
    if Active() then
        for _, e in ipairs(EVENTS) do pcall(ev.RegisterEvent, ev, e) end
        ApplyCVars()
        poller:Show()
        anchorPlate = nil  -- size / offset may have changed
        Evaluate()
    else
        poller:Hide()
        Release()
        for _, e in ipairs(EVENTS) do pcall(ev.UnregisterEvent, ev, e) end
        -- Off by the option (not when Lueur takes over): the player's values.
        local db = DB()
        if db and type(db.saved) == "table" then
            if InCombatLockdown() then
                pending = "restore"
                ev:RegisterEvent("PLAYER_REGEN_ENABLED")
            else
                RestoreCVars(true)
            end
        end
    end
end

function RG.SetEnabled(v)
    local db = DB()
    if not db then return end
    db.enabled = v and true or false
    RG.ApplySettings()
end

--- One line for diagnostics.
function RG.Status()
    local db = DB()
    if RG.standDown then return "Resource glow: Lueur is loaded, TMF stands down" end
    return string.format("Resource glow: %s, CVars %s, gate %s, glow %s",
        (db and db.enabled) and "on" or "off", RG.applied and "ours" or "player's",
        tostring(gate), current.cat and (current.cat .. " " .. tostring(current.state)) or "none")
end

function RG.Initialize()
    if not DB() then return end
    BuildCursors()
    RG.standDown = LueurLoaded()
    if RG.standDown then
        -- Values left by an older session of ours: give them back.
        local db = DB()
        if type(db.saved) == "table" and not InCombatLockdown() then RestoreCVars(true) end
        return
    end
    RG.ApplySettings()
end
