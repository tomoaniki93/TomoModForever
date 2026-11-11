-- =====================================================================
-- ChatCore.lua — TomoMod Chat V4
-- Fresh chat implementation for TomoMod v4.
--
-- Design rule: Blizzard keeps the secure chat data/formatting plane.
-- TomoMod owns only presentation frames and user-side controls.
-- =====================================================================

TomoMod_ChatFrameSkin = TomoMod_ChatFrameSkin or {}
local Chat = TomoMod_ChatFrameSkin

Chat.Modules = Chat.Modules or {}
Chat.VERSION = 1

local DEFAULTS = {
    enabled = true,
    appearance = {
        bgAlpha = 0.72,
        messageBgAlpha = 0.72,
        fontSize = 13,
        tabHeight = 25,
        inputHeight = 30,
        borderAlpha = 0.22,
        maxLines = 512,
    },
    messages = {
        fade = true,
        showTimestamp = true,
        timestampFormat = "%H:%M",
        shortChannelNames = true,
        findURL = true,
        emoji = true,
        classColorMentions = true,
    },
    community = {
        whisper = true,
        bnWhisper = true,
        guild = true,
        officer = true,
    },
    sidebar = {
        side = "LEFT",
        width = 32,
        iconSize = 20,
        spacing = 2,
        buttons = {
            friends = true,
            guild = true,
            playerStatus = true,
            voice = true,
            mute = true,
            deafen = true,
            copy = true,
            codex = true,
            settings = true,
            scroll = true,
        },
        order = {
            "friends", "guild", "playerStatus",
            "voice", "mute", "deafen",
            "copy", "codex",
            "settings",
            "scroll",
        },
    },
    copy = {
        maxLines = 500,
    },
}

local function CopyDefaults(dst, src)
    for key, value in pairs(src) do
        if type(value) == "table" then
            if type(dst[key]) ~= "table" then dst[key] = {} end
            CopyDefaults(dst[key], value)
        elseif dst[key] == nil then
            dst[key] = value
        end
    end
end

local function MigrateLegacySettings(db)
    if db._legacySettingsMigrated then return end
    local legacy = TomoModForeverDB and TomoModForeverDB.chatFrameSkin
    if type(legacy) == "table" then
        -- Database now provides concrete chatV4 defaults, so legacy values must
        -- deliberately win on the one-time migration instead of relying on nil.
        if legacy.enabled ~= nil then db.enabled = legacy.enabled and true or false end

        db.appearance = db.appearance or {}
        if type(legacy.bgAlpha) == "number" then
            db.appearance.bgAlpha = legacy.bgAlpha
            db.appearance.messageBgAlpha = legacy.bgAlpha
        end
        if type(legacy.fontSize) == "number" then db.appearance.fontSize = legacy.fontSize end

        db.messages = db.messages or {}
        local m = db.messages
        if legacy.fade ~= nil then m.fade = legacy.fade and true or false end
        if legacy.showTimestamp ~= nil then m.showTimestamp = legacy.showTimestamp and true or false end
        if type(legacy.timestampFormat) == "string" then m.timestampFormat = legacy.timestampFormat end
        if legacy.shortChannelNames ~= nil then m.shortChannelNames = legacy.shortChannelNames and true or false end
        if legacy.findURL ~= nil then m.findURL = legacy.findURL and true or false end
        if legacy.emoji ~= nil then m.emoji = legacy.emoji and true or false end
        if legacy.classColorMentions ~= nil then m.classColorMentions = legacy.classColorMentions and true or false end
    end
    db._legacySettingsMigrated = true
end

local function MigrateMessageBackground(db)
    if db._messageBackgroundMigrated then return end

    db.appearance = type(db.appearance) == "table" and db.appearance or {}
    local frameAlpha = db.appearance.bgAlpha
    db.appearance.messageBgAlpha = type(frameAlpha) == "number" and frameAlpha or 0.72
    db._messageBackgroundMigrated = true
end

local function SanitizeSidebar(db)
    local sidebar = db.sidebar
    if type(sidebar) ~= "table" then return end

    -- Phase 2.1 removes the Emotes shortcut entirely. Existing SavedVariables
    -- may still carry both the old enable flag and the old order entry.
    if type(sidebar.buttons) == "table" then
        sidebar.buttons.emotes = nil
    end
    if type(sidebar.order) == "table" then
        for i = #sidebar.order, 1, -1 do
            if sidebar.order[i] == "emotes" then
                table.remove(sidebar.order, i)
            end
        end
        -- 1.2.5: the codex button goes after "copy" in saved orders.
        local has, at = false, nil
        for i, key in ipairs(sidebar.order) do
            if key == "codex" then has = true end
            if key == "copy" then at = i + 1 end
            if not at and (key == "settings" or key == "scroll") then at = i end
        end
        if not has then table.insert(sidebar.order, at or (#sidebar.order + 1), "codex") end
    end
end

function Chat.GetDB()
    TomoModForeverDB = TomoModForeverDB or {}
    TomoModForeverDB.chatV4 = TomoModForeverDB.chatV4 or {}
    MigrateLegacySettings(TomoModForeverDB.chatV4)
    MigrateMessageBackground(TomoModForeverDB.chatV4)
    CopyDefaults(TomoModForeverDB.chatV4, DEFAULTS)
    SanitizeSidebar(TomoModForeverDB.chatV4)
    return TomoModForeverDB.chatV4
end

function Chat.IsEnabled()
    return Chat.GetDB().enabled ~= false
end

-- Docked in Blizzard's general dock. FCF_DockFrame writes isDocked = 1
-- (some code paths true), FCF_UnDockFrame nil.
function Chat.IsDocked(cf)
    local docked = cf and cf.isDocked
    return docked ~= nil and docked ~= false and docked ~= 0
end

-- Every Blizzard chat window: the permanent ones (ChatFrame1-10) and the
-- temporary ones (whisper tabs), which Blizzard numbers from 11 up as they are
-- created and lists in CHAT_FRAMES. A fixed 1-20 loop missed a temporary
-- window past 20 and anything created after the loop ran.
function Chat.EachChatFrame(callback)
    local seen = {}
    for i = 1, 20 do
        local cf = _G["ChatFrame" .. i]
        if cf and not seen[cf] then seen[cf] = true; callback(cf) end
    end
    if type(CHAT_FRAMES) == "table" then
        for _, name in ipairs(CHAT_FRAMES) do
            local cf = type(name) == "string" and _G[name]
            if cf and not seen[cf] then seen[cf] = true; callback(cf) end
        end
    end
end

function Chat.RegisterModule(name, module)
    if not name or not module then return end
    Chat.Modules[name] = module
end

local INIT_ORDER = {
    "Layout",
    "Messages",
    "Renderer",
    "Tabs",
    "Input",
    "Copy",
    "Sidebar",
    "Bridge",
}

function Chat.Initialize()
    if Chat._initialized then return end
    Chat._initialized = true
    Chat.GetDB()

    for _, name in ipairs(INIT_ORDER) do
        local module = Chat.Modules[name]
        if module and module.Initialize then
            local ok, err = pcall(module.Initialize, module)
            if not ok and geterrorhandler then
                geterrorhandler()(string.format("TomoMod Chat V4 [%s]: %s", name, tostring(err)))
            end
        end
    end

    Chat.ApplySettings()
end

function Chat.ApplySettings()
    local enabled = Chat.IsEnabled()
    for _, name in ipairs(INIT_ORDER) do
        local module = Chat.Modules[name]
        if module and module.ApplySettings then
            local ok, err = pcall(module.ApplySettings, module, enabled)
            if not ok and geterrorhandler then
                geterrorhandler()(string.format("TomoMod Chat V4 [%s]: %s", name, tostring(err)))
            end
        end
    end
end

function Chat.SetEnabled(enabled)
    Chat.GetDB().enabled = enabled and true or false
    Chat.ApplySettings()
end

-- Compatibility surface for the current Skins panel during Phase 1.
-- The public global name is kept so Core/Init.lua and the existing options
-- loader can reach this module; the legacy ChatFrameSkin file is not loaded.
function Chat.ApplyHistorySettings()
end
