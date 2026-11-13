-- =====================================================================
-- Modules/QOL/Mail/MailCore.lua -- TomoMail inside TomoModForever
--
-- Port of TomoMail 2.2.0: mail window with inbox / send tabs, contacts
-- (alts, guild, recent), quick send to every alt, autocomplete, and the
-- dark reskin of Blizzard's mail frames -- in the Forever palette.
--
-- Switch. The module answers to TomoModForeverDB.mailSkin.enabled (the
-- "Mail" skin toggle that already existed in the manifest, installer and
-- presets). Changing it needs a /reload, as declared in the manifest.
--
-- Storage. TomoModForeverMailDB is its own SavedVariable, with the same
-- layout TomoMail used: `global` (alt list, window position, shared by
-- the account) and one `profiles[Name-Realm]` table per character
-- (recent recipients and display options). It stays outside TomoMod
-- profiles, so swapping a profile never loses the alt list.
--
-- Standalone TomoMail. If the TomoMail addon is loaded too, this module
-- stands down (one line in chat) instead of skinning the mailbox twice.
--
-- Load order (Mail.xml): Locales, Core, UI, sub-modules, Config. Sub-modules
-- only register at load; nothing runs until Initialize() is called by
-- Core/Init.lua, and every event handler checks TM.db first.
-- =====================================================================

local L = TomoMod_MailLocale

TomoMod_Mail = TomoMod_Mail or {}
local TM = TomoMod_Mail
TM.modules = TM.modules or {}
TM.db = nil

local function AddonVersion()
    local v
    pcall(function()
        if C_AddOns and C_AddOns.GetAddOnMetadata then
            v = C_AddOns.GetAddOnMetadata("TomoModForever", "Version")
        elseif GetAddOnMetadata then
            v = GetAddOnMetadata("TomoModForever", "Version")
        end
    end)
    return v or ""
end
TM.version = AddonVersion()

-- ============================================================
--  Defaults (was Database.lua)
-- ============================================================
TomoMod_MailDB_Defaults = {
    -- Shared by every character of the account
    global = {
        -- "Name|Realm|Faction|Level|Class"
        alts = {},
        window = { point = "TOP", x = -160, y = -100 },
    },
    -- Per character
    profile = {
        recent          = {},          -- "Name|Realm|Faction", newest first
        showAlts        = true,
        showGuild       = true,
        showRecent      = true,
        guildOnlineOnly = false,
        useAutocomplete = true,
        maxRecent       = 10,
        skinEnabled     = true,
        modernUI        = true,
        mailScale       = 1.0,
        font            = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf",
        fontSize        = 1.0,
        inboxIconSize   = 30,          -- 18-36
    },
}

-- ============================================================
--  Public helpers
-- ============================================================
function TM:RegisterModule(name, obj)
    self.modules[name] = obj
    obj.name = name
end

function TM:ClassColor(class)
    if class and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class] then
        local c = RAID_CLASS_COLORS[class]
        return string.format("|cFF%02x%02x%02x", c.r * 255, c.g * 255, c.b * 255)
    end
    return "|cFFF2EBDB"
end

function TM:ClassColorRGB(class)
    if class and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class] then
        local c = RAID_CLASS_COLORS[class]
        return c.r, c.g, c.b
    end
    return 0.949, 0.922, 0.859
end

function TM:L(key)
    return (L and L[key]) or key
end

function TM:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cffffd100TomoModForever|r |cffc9a252Mail|r " .. (msg or ""))
end

function TM:SetRecipient(name)
    if SendMailNameEditBox then
        SendMailNameEditBox:SetText(name)
        SendMailNameEditBox:SetFocus()
        self:AddRecent(name)
    end
end

function TM:IsActive() return self.db ~= nil end

-- ============================================================
--  Database
-- ============================================================
local function MergeDefaults(target, defaults)
    for k, v in pairs(defaults) do
        if type(v) == "table" then
            if type(target[k]) ~= "table" then target[k] = {} end
            MergeDefaults(target[k], v)
        elseif target[k] == nil then
            target[k] = v
        end
    end
end

-- The old default was Blizzard's Friz Quadrata; the Forever look uses
-- Poppins. Only that exact old default is switched, a font the player
-- picked is kept.
local OLD_DEFAULT_FONT = "Fonts\\FRIZQT__.TTF"

local function InitDB()
    if type(TomoModForeverMailDB) ~= "table" then TomoModForeverMailDB = {} end
    local db = TomoModForeverMailDB
    if type(db.global) ~= "table" then db.global = {} end
    if type(db.profiles) ~= "table" then db.profiles = {} end
    MergeDefaults(db.global, TomoMod_MailDB_Defaults.global)

    -- Profiles are keyed by the character name alone. The realm string
    -- Forever reports can change between sessions (the cluster part of
    -- "CAMWOW EU4 Realm 7 PvE"), and a "Name-Realm" key then gave the
    -- character a fresh, empty profile (no recents) on the next login.
    -- An older "Name-Realm" profile is taken over the first time.
    local name = UnitName("player") or "?"
    local key = name
    if type(db.profiles[key]) ~= "table" then
        local prefix = name .. "-"
        for k, v in pairs(db.profiles) do
            if type(v) == "table" and k:sub(1, #prefix) == prefix then
                if type(db.profiles[key]) ~= "table" or #(v.recent or {}) > #(db.profiles[key].recent or {}) then
                    db.profiles[key] = v
                end
            end
        end
    end
    if type(db.profiles[key]) ~= "table" then db.profiles[key] = {} end
    local p = db.profiles[key]
    MergeDefaults(p, TomoMod_MailDB_Defaults.profile)
    if p.font == OLD_DEFAULT_FONT and not p._forever then p.font = TomoMod_MailDB_Defaults.profile.font end
    p._forever = true

    TM.db = { global = db.global, profile = p }
end

-- ============================================================
--  Names
-- ============================================================
-- Trims a typed name and drops a "-Realm" suffix: mail between
-- characters of the same server only needs the name.
function TM:CleanName(name)
    if type(name) ~= "string" then return nil end
    name = name:gsub("^%s+", ""):gsub("%s+$", "")
    name = strsplit("-", name)
    if not name or name == "" then return nil end
    return name
end

-- The faction of the character being played, or nil while the client
-- does not know it yet.
local function PlayerFaction()
    local f = UnitFactionGroup("player")
    if f == "Alliance" or f == "Horde" then return f end
    return nil
end

-- Can this stored alt be written to from the current character?
-- The realm is not compared (its text is not stable on Forever, see
-- InitDB), only the name (not ourselves) and the faction, when both
-- sides know it.
function TM:IsMailableAlt(p, f)
    if not p or p == "" then return false end
    local me = UnitName("player")
    if me and p:lower() == me:lower() then return false end
    local mine = PlayerFaction()
    if mine and (f == "Alliance" or f == "Horde") and f ~= mine then return false end
    return true
end

-- ============================================================
--  Recent recipients
-- ============================================================
function TM:AddRecent(name)
    name = self:CleanName(name)
    if not name or not self.db then return end
    local realm   = GetRealmName() or ""
    local faction = PlayerFaction() or "Neutral"
    local entry   = name .. "|" .. realm .. "|" .. faction

    local recent = self.db.profile.recent
    local lname = name:lower()
    for i = #recent, 1, -1 do
        local n = strsplit("|", recent[i])
        if not n or n:lower() == lname then table.remove(recent, i) end
    end
    table.insert(recent, 1, entry)
    local max = self.db.profile.maxRecent or 10
    while #recent > max do table.remove(recent) end
end

-- ============================================================
--  Current character
-- ============================================================
-- Called at login, on entering the world, on level up and at logout,
-- so the entry exists and stays current even if the first call came
-- before the client knew the level, class or faction. A missing value
-- is retried a little later instead of dropping the character.
local retries = 0
function TM:RegisterCurrentChar()
    if not self.db then return end
    local player  = UnitName("player")
    local level   = UnitLevel("player")
    local _, class = UnitClass("player")
    local faction = PlayerFaction()
    if not player or player == "" or player == UNKNOWNOBJECT or not class or not faction or not level or level <= 0 then
        if retries < 10 and C_Timer and C_Timer.After then
            retries = retries + 1
            C_Timer.After(2, function() TM:RegisterCurrentChar() end)
        end
        return
    end

    local realm = GetRealmName() or ""
    local entry = table.concat({ player, realm, faction, level, class }, "|")
    local alts  = self.db.global.alts
    local lname = player:lower()
    -- One entry per name: the realm text is not compared, otherwise a
    -- change of that text would list the same character twice.
    for i = #alts, 1, -1 do
        local p = strsplit("|", alts[i])
        if not p or p:lower() == lname then table.remove(alts, i) end
    end
    table.insert(alts, entry)
end

-- /tml alts: what the module sees and what it has stored.
function TM:PrintAlts()
    if not self.db then return end
    local _, class = UnitClass("player")
    self:Print(string.format("player=%s realm=%s faction=%s level=%s class=%s",
        tostring(UnitName("player")), tostring(GetRealmName()), tostring(UnitFactionGroup("player")),
        tostring(UnitLevel("player")), tostring(class)))
    local alts = self.db.global.alts
    self:Print(string.format("%d stored:", #alts))
    for _, e in ipairs(alts) do
        local p, _, f = strsplit("|", e)
        self:Print("  " .. e .. (self:IsMailableAlt(p, f) and "" or "  (hidden here)"))
    end
end

-- ============================================================
--  Events
-- ============================================================
local function Broadcast(method, ...)
    for name, mod in pairs(TM.modules) do
        if mod[method] then
            local ok, err = pcall(mod[method], mod, ...)
            if not ok then TM:Print("|cffff4040" .. name .. "." .. method .. ":|r " .. tostring(err)) end
        end
    end
end

-- MAIL_SHOW / MAIL_CLOSED exist on every client; the interaction manager
-- events only on recent ones. Both are listened to, and a flag keeps the
-- modules from being told twice.
local mailOpen = false
local function MailOpened()
    if mailOpen then return end
    mailOpen = true
    Broadcast("OnMailShow")
end
local function MailClosed()
    if not mailOpen then return end
    mailOpen = false
    Broadcast("OnMailHide")
end

local function IsMailPane(paneType)
    return Enum and Enum.PlayerInteractionType and paneType == Enum.PlayerInteractionType.MailInfo
end

local function StandaloneLoaded()
    if C_AddOns and C_AddOns.IsAddOnLoaded then return C_AddOns.IsAddOnLoaded("TomoMail") end
    return IsAddOnLoaded and IsAddOnLoaded("TomoMail")
end

function TM.Initialize()
    local cfg = TomoModForeverDB and TomoModForeverDB.mailSkin
    if not (cfg and cfg.enabled) then return end
    if StandaloneLoaded() then
        TM:Print(TM:L("STANDALONE_ACTIVE"))
        return
    end

    InitDB()
    Broadcast("OnInitialize")

    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("PLAYER_LEVEL_UP")
    f:RegisterEvent("PLAYER_LOGOUT")
    f:RegisterEvent("MAIL_SEND_SUCCESS")
    f:RegisterEvent("MAIL_SHOW")
    f:RegisterEvent("MAIL_CLOSED")
    pcall(f.RegisterEvent, f, "PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
    pcall(f.RegisterEvent, f, "PLAYER_INTERACTION_MANAGER_FRAME_HIDE")
    f:SetScript("OnEvent", function(_, event, ...)
        if event == "PLAYER_ENTERING_WORLD" then
            TM:RegisterCurrentChar()
            Broadcast("OnEnteringWorld")
        elseif event == "PLAYER_LEVEL_UP" then
            -- UnitLevel still gives the old level during this event.
            if C_Timer and C_Timer.After then C_Timer.After(1, function() TM:RegisterCurrentChar() end) end
        elseif event == "PLAYER_LOGOUT" then
            TM:RegisterCurrentChar()
        elseif event == "MAIL_SEND_SUCCESS" then
            -- The send box is often already cleared when this fires: the
            -- name given to SendMail() is used first.
            local recipient = TM._pendingRecipient
            if not recipient or recipient == "" then
                recipient = SendMailNameEditBox and SendMailNameEditBox:GetText() or ""
            end
            TM._pendingRecipient = nil
            if recipient ~= "" then TM:AddRecent(recipient) end
            Broadcast("OnMailSent", recipient)
        elseif event == "MAIL_SHOW" then
            MailOpened()
        elseif event == "MAIL_CLOSED" then
            MailClosed()
        elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" then
            if IsMailPane(...) then MailOpened() end
        elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_HIDE" then
            if IsMailPane(...) then MailClosed() end
        end
    end)
    TM:RegisterCurrentChar()

    if SendMail then
        hooksecurefunc("SendMail", function(recipient) TM._pendingRecipient = recipient end)
    end

    SLASH_TOMOMODMAIL1 = "/tml"
    SLASH_TOMOMODMAIL2 = "/tomomail"
    SlashCmdList["TOMOMODMAIL"] = function(msg)
        msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
        if msg == "alts" or msg == "persos" then TM:PrintAlts() return end
        if TomoMod_MailConfig and TomoMod_MailConfig.Toggle then TomoMod_MailConfig:Toggle() end
    end
end

-- Appliers used by the TomoMod options page (same work as the cog panel).
function TM.ApplyScale()
    if not TM.db then return end
    local scale = TM.db.profile.mailScale or 1
    local skinMod = TM.modules["Skin"]
    if skinMod and skinMod.UpdateScale then pcall(skinMod.UpdateScale, skinMod, scale) end
    if TM.Window and TM.Window.ApplyScale then pcall(TM.Window.ApplyScale, TM.Window) end
end

function TM.ApplyIconSize()
    local inbox = TM.modules["Inbox"]
    if TM.db and inbox and inbox.ApplyIconSize then pcall(inbox.ApplyIconSize, inbox) end
end

function TM.ApplyAutocomplete()
    if not TM.db then return end
    local qs = TM.modules["QuickSend"]
    if TM.db.profile.useAutocomplete and qs and qs.EnableAutocomplete then pcall(qs.EnableAutocomplete, qs) end
end

function TM.TrimRecent()
    if not TM.db then return end
    local p = TM.db.profile
    while #p.recent > (p.maxRecent or 10) do table.remove(p.recent) end
end

function TM.OpenSettings()
    if TomoMod_MailConfig and TomoMod_MailConfig.Toggle then TomoMod_MailConfig:Toggle() end
end

-- Used by the TomoMod options page after a change.
function TM.Refresh()
    if not TM.db then return end
    Broadcast("OnSettingsChanged")
    if TomoMod_MailConfig and TomoMod_MailConfig.Refresh then pcall(TomoMod_MailConfig.Refresh, TomoMod_MailConfig) end
    if TM.UI and TM.UI.RefreshFonts then pcall(TM.UI.RefreshFonts, TM.UI) end
end
