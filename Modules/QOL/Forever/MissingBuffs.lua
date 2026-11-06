-- =====================================================================
-- Modules/QOL/Forever/MissingBuffs.lua -- "Buffs manquants"
--
-- Shows an icon for every class buff, stance-like aura or weapon
-- enchant you should have up and do not. Click the icon to cast it.
--
-- Self only: aura data on other players is not reliably readable on the
-- modern client, and a reminder that is silently wrong is worse than
-- none. The check runs out of combat, where the click-to-cast buttons
-- (protected) can be laid out; in combat the alerts stay as they were.
--
-- Rules match by spell NAME, so every rank of a spell counts, and so do
-- the group versions (Arcane Brilliance satisfies Arcane Intellect).
-- =====================================================================

TomoMod_MissingBuffs = TomoMod_MissingBuffs or {}
local MB = TomoMod_MissingBuffs

local FONT      = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local FONT_BOLD = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-SemiBold.ttf"
local WHITE     = "Interface\\Buttons\\WHITE8x8"

local IS_FR = GetLocale() == "frFR"
local function T(fr, en)
    if TomoMod_GUIT then return TomoMod_GUIT(fr, en) end
    return IS_FR and fr or en
end

-- ---------------------------------------------------------------------
-- Rules
--   cast   spells the player may cast, in order of preference (first
--          known one is shown and cast on click); rank 1 ids
--   match  extra spells whose aura also satisfies the rule
--   weapon true = a temporary weapon enchant is expected instead
--   key    stable id, used by the per-rule on/off switches
-- ---------------------------------------------------------------------
local RULES = {
    MAGE = {
        { key = "mage_int",   cast = { 1459 }, match = { 23028 } },                   -- Arcane Intellect / Brilliance
        { key = "mage_armor", cast = { 6117, 7302, 168 } },                           -- Mage / Ice / Frost Armor
    },
    PRIEST = {
        { key = "priest_fort",  cast = { 1243 }, match = { 21562 } },                 -- Fortitude / Prayer of
        { key = "priest_inner", cast = { 588 } },                                     -- Inner Fire
    },
    DRUID = {
        { key = "druid_motw",  cast = { 1126 }, match = { 21849 } },                  -- Mark / Gift of the Wild
        { key = "druid_omen",  cast = { 16864 } },                                    -- Omen of Clarity
    },
    WARLOCK = {
        { key = "lock_armor", cast = { 706, 687 } },                                  -- Demon Armor / Skin
    },
    SHAMAN = {
        { key = "sham_shield", cast = { 324 } },                                      -- Lightning Shield
        { key = "sham_weapon", weapon = true, cast = { 8232, 8024, 8033, 8017 } },    -- Windfury, Flametongue, Frostbrand, Rockbiter
    },
    PALADIN = {
        { key = "pal_aura", cast = { 465, 7294, 19746, 19876, 19888, 19891, 20218 } },  -- any aura
        { key = "pal_bless", cast = { 19740, 19742, 20217, 1038, 19977, 20911 },
          match = { 25782, 25894, 25898, 25895, 25890, 25899 } },                     -- any blessing (or greater)
    },
    HUNTER = {
        { key = "hunt_aspect", cast = { 13165, 13163, 20043, 13159, 5118, 13161 } },  -- any aspect
        { key = "hunt_trueshot", cast = { 19506 } },                                  -- Trueshot Aura
    },
    ROGUE = {
        { key = "rogue_poison", weapon = true, known = { 2842 } },                    -- Poisons skill
    },
}

local container
local buttons = {}
local dirty = false
local lastScan = 0

local function DB() return TomoModForeverDB and TomoModForeverDB.missingBuffs end

local function Secret(v)
    return TomoMod_Utils and TomoMod_Utils.IsSecret and TomoMod_Utils.IsSecret(v) or false
end

local function SpellName(id)
    if C_Spell and C_Spell.GetSpellName then return C_Spell.GetSpellName(id) end
    if GetSpellInfo then return (GetSpellInfo(id)) end
end

local function SpellIcon(id)
    if C_Spell and C_Spell.GetSpellTexture then return C_Spell.GetSpellTexture(id) end
    if GetSpellTexture then return GetSpellTexture(id) end
end

local function Known(id)
    if C_SpellBook and C_SpellBook.IsSpellKnown then
        local ok, v = pcall(C_SpellBook.IsSpellKnown, id)
        if ok and v then return true end
    end
    if IsPlayerSpell and IsPlayerSpell(id) then return true end
    if IsSpellKnown and IsSpellKnown(id) then return true end
    return false
end

-- Readable names of every helpful aura on the player.
local function BuffNames()
    local names = {}
    if C_UnitAuras and C_UnitAuras.GetAuraDataByIndex then
        for i = 1, 40 do
            local ok, a = pcall(C_UnitAuras.GetAuraDataByIndex, "player", i, "HELPFUL")
            if not ok or not a then break end
            if not Secret(a.name) and type(a.name) == "string" then names[a.name] = true end
        end
    elseif UnitBuff then
        for i = 1, 40 do
            local name = UnitBuff("player", i)
            if not name then break end
            names[name] = true
        end
    end
    return names
end

local function HasWeaponEnchant()
    if not GetWeaponEnchantInfo then return true end
    local hasMain, _, _, _, hasOff = GetWeaponEnchantInfo()
    if not GetInventoryItemID("player", 16) then return true end   -- no weapon, nothing to enchant
    if not hasMain then return false end
    local offID = GetInventoryItemID("player", 17)
    if offID and not hasOff then
        -- Only weapons take an enchant: a shield or held item in the off hand does not count.
        local _, _, _, _, _, _, _, _, equipLoc = (C_Item and C_Item.GetItemInfo or GetItemInfo)(offID)
        if equipLoc == "INVTYPE_WEAPON" or equipLoc == "INVTYPE_WEAPONOFFHAND" then return false end
    end
    return true
end

-- Returns the list of { key, label, icon, spell } currently missing.
function MB.Missing()
    local db = DB()
    if not db then return {} end
    local out = {}
    local names = BuffNames()
    local _, cls = UnitClass("player")
    local off = db.disabled or {}

    for _, rule in ipairs(RULES[cls] or {}) do
        if not off[rule.key] then
            local castID
            for _, id in ipairs(rule.cast or {}) do
                if Known(id) then castID = id break end
            end
            local knowsRule = castID ~= nil
            if not knowsRule and rule.known then
                for _, id in ipairs(rule.known) do if Known(id) then knowsRule = true break end end
            end
            if knowsRule then
                local ok
                if rule.weapon then
                    ok = (db.weaponEnchants == false) or HasWeaponEnchant()
                else
                    ok = false
                    for _, list in ipairs({ rule.cast or {}, rule.match or {} }) do
                        for _, id in ipairs(list) do
                            local n = SpellName(id)
                            if n and names[n] then ok = true break end
                        end
                        if ok then break end
                    end
                end
                if not ok then
                    local labelID = castID or (rule.known and rule.known[1])
                    out[#out + 1] = {
                        key = rule.key,
                        label = rule.weapon and not castID and T("Poison sur l'arme", "Weapon poison")
                            or (rule.weapon and T("Enchantement d'arme", "Weapon enchant"))
                            or (labelID and SpellName(labelID)) or "?",
                        icon = labelID and SpellIcon(labelID) or 134400,
                        spell = castID and SpellName(castID) or nil,
                    }
                end
            end
        end
    end

    -- Player-defined buffs, by name.
    for _, name in ipairs(db.custom or {}) do
        if type(name) == "string" and name ~= "" and not names[name] then
            local castable = C_Spell and C_Spell.GetSpellInfo and C_Spell.GetSpellInfo(name)
            out[#out + 1] = {
                key = "custom:" .. name,
                label = name,
                icon = (C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(name)) or 134400,
                spell = castable and name or nil,
            }
        end
    end
    return out
end

-- ---------------------------------------------------------------------
-- Display
-- ---------------------------------------------------------------------
local function Button(i)
    local b = buttons[i]
    if b then return b end
    b = CreateFrame("Button", "TomoMod_MissingBuff" .. i, container, "SecureActionButtonTemplate, BackdropTemplate")
    b:RegisterForClicks("AnyUp", "AnyDown")
    b:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 2 })
    b:SetBackdropColor(0, 0, 0, 0.6)
    b:SetBackdropBorderColor(0.95, 0.25, 0.20, 1)
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetPoint("TOPLEFT", 2, -2)
    b.icon:SetPoint("BOTTOMRIGHT", -2, 2)
    b.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    -- Every few seconds the icon gives a little shake, and a red halo
    -- breathes behind it. Only regions are animated, never the secure
    -- button itself, so this is safe in combat.
    local halo = b:CreateTexture(nil, "BACKGROUND", nil, -1)
    halo:SetPoint("TOPLEFT", -6, 6)
    halo:SetPoint("BOTTOMRIGHT", 6, -6)
    halo:SetColorTexture(1, 0.2, 0.15, 0.35)
    b.halo = halo
    local wig = b.icon:CreateAnimationGroup()
    wig:SetLooping("REPEAT")
    local steps = { 9, -18, 14, -8, 3 }
    for i, deg in ipairs(steps) do
        local r = wig:CreateAnimation("Rotation")
        r:SetDegrees(deg)
        r:SetDuration(0.07)
        r:SetOrder(i)
    end
    local rest = wig:CreateAnimation("Alpha")   -- a pause before the next shake
    rest:SetFromAlpha(1); rest:SetToAlpha(1)
    rest:SetDuration(2.6)
    rest:SetOrder(#steps + 1)
    b.wiggle = wig

    b.label = b:CreateFontString(nil, "OVERLAY")
    b.label:SetFont(FONT, 10, "OUTLINE")
    b.label:SetPoint("TOP", b, "BOTTOM", 0, -3)
    b.label:SetWidth(90)
    b.label:SetTextColor(1, 0.82, 0)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText(T("Buff manquant", "Missing buff"), 1, 0.3, 0.25)
        GameTooltip:AddLine(self.labelText or "", 1, 1, 1)
        if self.spellName then GameTooltip:AddLine(T("Clic : lancer le sort", "Click: cast it"), 0.79, 0.64, 0.32) end
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    buttons[i] = b
    return b
end

local function Layout(list)
    local db = DB()
    local size = db.iconSize or 36
    local gap = 10
    local n = #list
    container:SetSize(math.max(size, n * size + (n - 1) * gap), size + (db.showLabel ~= false and 16 or 0))
    for i = 1, math.max(n, #buttons) do
        local b = buttons[i]
        local m = list[i]
        if m then
            b = Button(i)
            b:SetSize(size, size)
            b:ClearAllPoints()
            b:SetPoint("TOPLEFT", (i - 1) * (size + gap), 0)
            b.icon:SetTexture(m.icon)
            b.labelText, b.spellName = m.label, m.spell
            b.label:SetText(db.showLabel ~= false and m.label or "")
            local pulse = TomoMod_Utils.Pulse and TomoMod_Utils.Pulse(b.halo, 0.1, 0.6, 1.4)
            if db.wiggle ~= false then
                if not b.wiggle:IsPlaying() then b.wiggle:Play() end
                if pulse and not pulse:IsPlaying() then pulse:Play() end
                b.halo:Show()
            else
                b.wiggle:Stop()
                if pulse then pulse:Stop() end
                b.halo:Hide()
            end
            if m.spell then
                b:SetAttribute("type", "spell")
                b:SetAttribute("spell", m.spell)
                b:SetAttribute("unit", "player")
            else
                b:SetAttribute("type", nil)
                b:SetAttribute("spell", nil)
            end
            b:Show()
        elseif b then
            b:Hide()
            b.wiggle:Stop()
            b:SetAttribute("type", nil)
        end
    end
end

local function Hidden()
    local db = DB()
    if not (db and db.enabled) then return true end
    if UnitIsDeadOrGhost("player") or UnitOnTaxi("player") then return true end
    if db.hideResting ~= false and IsResting() then return true end
    if UnitInVehicle and UnitInVehicle("player") then return true end
    return false
end

function MB.Update()
    dirty = false
    if not container then return end
    if InCombatLockdown() then dirty = true return end
    local db = DB()
    local list = Hidden() and {} or MB.Missing()
    if MB._preview then
        list = {
            { key = "p1", label = T("Intelligence des Arcanes", "Arcane Intellect"), icon = "Interface\\Icons\\Spell_Holy_MagicalSentry" },
            { key = "p2", label = T("Enchantement d'arme", "Weapon enchant"), icon = "Interface\\Icons\\Spell_Nature_RockBiter" },
        }
    end
    Layout(list)
    container:SetShown(#list > 0 or not container.isLocked)
    container:SetAlpha(1)
    lastScan = GetTime()
end

local function Queue()
    if dirty and InCombatLockdown() then return end
    dirty = true
    C_Timer.After(0.25, function() if dirty then MB.Update() end end)
end

function MB.ApplySettings()
    local db = DB()
    if not (db and container) then return end
    container:SetScale(db.scale or 1)
    local U = TomoMod_Utils
    if U and U.ApplyFramePosition and db.position and not InCombatLockdown() then U.ApplyFramePosition(container, db.position) end
    MB.Update()
end

function MB.Preview(on)
    MB._preview = on and true or false
    MB.Update()
end

function MB.SetEnabled(v)
    local db = DB()
    if not db then return end
    db.enabled = v and true or false
    if v and not container then MB.Initialize() return end
    MB.Update()
end

function MB.Initialize()
    local db = DB()
    if not db or container then return end
    container = CreateFrame("Frame", "TomoMod_MissingBuffsFrame", UIParent)
    container:SetSize(36, 36)
    container:SetFrameStrata("MEDIUM")
    container:SetClampedToScreen(true)
    local U = TomoMod_Utils
    if U and U.SetupDraggable then
        U.SetupDraggable(container, function()
            local d = DB()
            if d then d.position = d.position or {}; U.SaveFramePosition(container, d.position) end
        end, T("Buffs manquants", "Missing buffs"))
    end

    local f = CreateFrame("Frame")
    for _, e in ipairs({ "PLAYER_ENTERING_WORLD", "PLAYER_REGEN_ENABLED", "PLAYER_REGEN_DISABLED", "SPELLS_CHANGED",
                         "PLAYER_UPDATE_RESTING", "UNIT_INVENTORY_CHANGED", "PLAYER_DEAD", "PLAYER_ALIVE",
                         "PLAYER_UNGHOST", "PLAYER_CONTROL_GAINED", "PLAYER_CONTROL_LOST" }) do
        pcall(f.RegisterEvent, f, e)
    end
    f:RegisterUnitEvent("UNIT_AURA", "player")
    f:SetScript("OnEvent", function(_, event)
        local d = DB()
        if not (d and d.enabled) then return end
        if event == "PLAYER_REGEN_DISABLED" then
            if d.hideInCombat then container:SetAlpha(0) end
            return
        end
        Queue()
    end)
    -- Weapon enchants run out without an event of their own.
    C_Timer.NewTicker(5, function()
        local d = DB()
        if d and d.enabled and not InCombatLockdown() and GetTime() - lastScan > 4 then MB.Update() end
    end)

    if TomoMod_Movers and TomoMod_Movers.RegisterEntry then
        TomoMod_Movers.RegisterEntry({
            label    = T("Buffs manquants", "Missing buffs"),
            unlock   = function() MB._preview = true; container:SetLocked(false); MB.Update() end,
            lock     = function() container:SetLocked(true); MB._preview = false; MB.Update() end,
            isActive = function() local d = DB(); return d and d.enabled end,
        })
    end
    MB.ApplySettings()
end

-- For the settings page: the class rules, with readable names.
function MB.ClassRules()
    local _, cls = UnitClass("player")
    local out = {}
    for _, rule in ipairs(RULES[cls] or {}) do
        local id = (rule.cast and rule.cast[1]) or (rule.known and rule.known[1])
        local name = rule.weapon and (cls == "ROGUE" and T("Poison sur l'arme", "Weapon poison") or T("Enchantement d'arme", "Weapon enchant"))
            or (id and SpellName(id)) or rule.key
        if rule.cast and #rule.cast > 1 and not rule.weapon then
            name = name .. T(" (ou équivalent)", " (or equivalent)")
        end
        out[#out + 1] = { key = rule.key, label = name }
    end
    return out
end
