-- =====================================================================
-- ChatOverlord.lua — TomoModForever x Overlord Forever (by Troma)
--
-- When the Overlord addon is loaded, TMF opens a chat tab named
-- "Overlord" and sends every Overlord notification there. Without
-- Overlord this file does nothing at all: no tab, no hook.
--
-- How:
--   * Overlord sends its player messages through one method,
--     Overlord:PrintNotification(text) (captures, general, kills, layer
--     codes, faction calls...). TMF wraps that method: while the TMF
--     Overlord tab is open, the line goes there; otherwise Overlord's own
--     code runs unchanged (its "notification chat tab" setting included).
--   * The tab is a normal Blizzard chat window (FCF_OpenNewWindow) with
--     no message group and no channel, so only Overlord lines land in it.
--   * Created once per character. A player who closes the tab keeps it
--     closed: Overlord lines go back to where Overlord puts them. The
--     option (Skins > Chat) brings the tab back or removes it.
--   * Overlord's raid-warning banners (middle of the screen), its debug
--     lines and its loading line stay where Overlord puts them.
-- Nothing of Blizzard's is replaced; OverlordDB is never written.
-- =====================================================================

local Chat = TomoMod_ChatFrameSkin
if not Chat then return end

local OV = {}
TomoMod_ChatOverlord = OV

local ADDON    = "Overlord"
local TAB_NAME = "Overlord"

local function IsLoaded()
    if C_AddOns and C_AddOns.IsAddOnLoaded then
        return C_AddOns.IsAddOnLoaded(ADDON) and true or false
    end
    return IsAddOnLoaded and IsAddOnLoaded(ADDON) and true or false
end
OV.IsLoaded = IsLoaded

local function IsEnabled()
    return Chat.GetDB().overlordTab ~= false
end

local function CharDB()
    if type(_G.TomoModForeverCharDB) ~= "table" then _G.TomoModForeverCharDB = {} end
    return _G.TomoModForeverCharDB
end

local function Truthy(v) return v ~= nil and v ~= false and v ~= 0 end

-- The Blizzard window named "Overlord", and whether it is open (shown,
-- or docked in the general dock). A closed window keeps its name.
local function FindWindow()
    if type(GetChatWindowInfo) ~= "function" then return nil, false end
    local max = (type(NUM_CHAT_WINDOWS) == "number" and NUM_CHAT_WINDOWS) or 10
    for i = 1, max do
        local name, _, _, _, _, _, shown, _, docked = GetChatWindowInfo(i)
        if name == TAB_NAME then
            local cf = _G["ChatFrame" .. i]
            if cf then
                local open = Truthy(shown) or Truthy(docked) or Chat.IsDocked(cf)
                return cf, open
            end
        end
    end
    return nil, false
end

-- Frame to write to, or nil when Overlord's own routing must run.
function OV:GetTarget()
    if not IsEnabled() then return nil end
    local cf, open = FindWindow()
    if cf and open and type(cf.AddMessage) == "function" then return cf end
    return nil
end

-- ---------------------------------------------------------------------
-- Routing: wrap Overlord:PrintNotification once. The wrapper reads the
-- state on every call, so turning the option off needs no unhook.
-- ---------------------------------------------------------------------
function OV:InstallRouting()
    if self.routed then return true end
    local addon = rawget(_G, "Overlord")
    if type(addon) ~= "table" or type(addon.PrintNotification) ~= "function" then
        return false
    end
    local original = addon.PrintNotification
    self.original = original
    addon.PrintNotification = function(selfOv, text, ...)
        if type(text) == "string" and text ~= "" then
            local cf = OV:GetTarget()
            if cf then
                cf:AddMessage(text)
                return
            end
        end
        return original(selfOv, text, ...)
    end
    self.routed = true
    return true
end

-- ---------------------------------------------------------------------
-- Tab
-- ---------------------------------------------------------------------
local function CanOpenWindow()
    return type(FCF_OpenNewWindow) == "function"
        and (type(FCF_CanOpenNewWindow) ~= "function" or FCF_CanOpenNewWindow())
end

local function SelectedDockFrame()
    if GENERAL_CHAT_DOCK and type(FCFDock_GetSelectedWindow) == "function" then
        return FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK)
    end
end

function OV:CreateTab()
    if not CanOpenWindow() then return nil end
    -- Blizzard selects a new window: give the player back the tab they read.
    local previous = SelectedDockFrame() or DEFAULT_CHAT_FRAME
    -- noDefaultChannels = true: no message group, no channel. Only the
    -- lines TMF writes from Overlord appear in this tab.
    local frame = FCF_OpenNewWindow(TAB_NAME, true)
    if not frame then return nil end
    if type(FCF_DockUpdate) == "function" then FCF_DockUpdate() end
    if previous and previous ~= frame and GENERAL_CHAT_DOCK
        and type(FCFDock_SelectWindow) == "function" and Chat.IsDocked(previous) then
        FCFDock_SelectWindow(GENERAL_CHAT_DOCK, previous)
    end
    return frame
end

-- Called after login and when the option changes.
--   force: the player asked for the tab (option turned on), so a tab
--   closed earlier comes back.
function OV:Ensure(force)
    if not IsLoaded() or not IsEnabled() then return end
    if InCombatLockdown and InCombatLockdown() then
        self.pendingForce = self.pendingForce or force
        self.events:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end
    self:InstallRouting()

    local char = CharDB()
    local cf, open = FindWindow()
    if cf and open then
        char.overlordTabCreated = true
        return
    end
    -- Already made once on this character and closed since: the player's
    -- choice stands, unless they asked for it again.
    if char.overlordTabCreated and not force then return end

    if self:CreateTab() then
        char.overlordTabCreated = true
    end
end

function OV:Remove()
    local cf, open = FindWindow()
    if cf and open and cf ~= DEFAULT_CHAT_FRAME and type(FCF_Close) == "function" then
        FCF_Close(cf)
    end
end

-- Options: Skins > Chat.
function OV:SetEnabled(enabled)
    Chat.GetDB().overlordTab = enabled and true or false
    if enabled then
        self:Ensure(true)
    else
        self:Remove()
    end
end

-- One line for diagnostics.
function OV:Status()
    if not IsLoaded() then return "Overlord: not loaded" end
    local cf, open = FindWindow()
    return string.format("Overlord: loaded, option %s, routing %s, tab %s",
        IsEnabled() and "on" or "off",
        self.routed and "on" or "off",
        cf and (open and ((cf:GetName() or "?") .. " open") or "closed") or "none")
end

-- ---------------------------------------------------------------------
-- Events. Overlord loads before TMF (OptionalDeps), but ADDON_LOADED is
-- kept for a client that loads it later. The tab is made a moment after
-- the first loading screen, once Blizzard has restored the chat windows.
-- ---------------------------------------------------------------------
local events = CreateFrame("Frame")
OV.events = events
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == ADDON then OV:InstallRouting() end
    elseif event == "PLAYER_ENTERING_WORLD" then
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        if not IsLoaded() then
            self:UnregisterEvent("ADDON_LOADED")
            return
        end
        OV:InstallRouting()
        C_Timer.After(2, function() OV:Ensure(false) end)
    elseif event == "PLAYER_REGEN_ENABLED" then
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        local force = OV.pendingForce
        OV.pendingForce = nil
        OV:Ensure(force)
    end
end)
