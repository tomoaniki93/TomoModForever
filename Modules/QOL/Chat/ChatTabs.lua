-- =====================================================================
-- ChatTabs.lua — TomoMod Chat V4 tab strip
-- Blizzard tabs remain the behavior authority; TomoMod owns their visuals
-- and placement so detached windows (notably ChatFrame2 / Combat Log) still
-- live inside the single V4 container.
-- =====================================================================

local Chat = TomoMod_ChatFrameSkin
if not Chat then return end

local Tabs = {}
Chat.RegisterModule("Tabs", Tabs)

Tabs.ghosts = {}
Tabs.unread = {}
Tabs.selected = nil

local TEAL_R, TEAL_G, TEAL_B = 0.788, 0.635, 0.322
local WHITE = "Interface\\Buttons\\WHITE8X8"

local COMMUNITY_FILTERS = {
    { key = "whisper",   label = "chat_v4_community_whispers",    fallback = "Private messages" },
    { key = "bnWhisper", label = "chat_v4_community_bn_whispers", fallback = "Battle.net whispers" },
    { key = "guild",     label = "chat_v4_community_guild",       fallback = "Guild" },
    { key = "officer",   label = "chat_v4_community_officer",     fallback = "Officer" },
}

local function Localize(key, fallback)
    local value = TomoMod_L and TomoMod_L[key]
    if type(value) == "string" and value ~= key then return value end
    return fallback or key
end

-- Glyphs are drawn with textures, never typed: a font without "+", "»" or
-- "•" (custom fonts, ruRU / CJK clients) shows a box instead.
local CIRCLE = "Interface\\CHARACTERFRAME\\TempPortraitAlphaMask"

local function CreateDot(parent, size)
    local dot = parent:CreateTexture(nil, "OVERLAY")
    dot:SetTexture(CIRCLE)
    dot:SetSize(size or 5, size or 5)
    dot:SetVertexColor(TEAL_R, TEAL_G, TEAL_B, 1)
    dot:Hide()
    return dot
end

-- A glyph made of plain rectangles centred on the parent.
local function CreateGlyph(parent, bars)
    local glyph = { parts = {} }
    for _, bar in ipairs(bars) do
        local t = parent:CreateTexture(nil, "OVERLAY")
        t:SetColorTexture(1, 1, 1, 1)
        t:SetSize(bar[1], bar[2])
        t:SetPoint("CENTER", parent, "CENTER", bar[3] or 0, bar[4] or 0)
        glyph.parts[#glyph.parts + 1] = t
    end
    function glyph:SetColor(r, g, b, a)
        for _, t in ipairs(self.parts) do t:SetVertexColor(r, g, b, a or 1) end
    end
    return glyph
end

-- "+": two 2 px bars. "...": three 3 px squares (more tabs).
local PLUS_BARS = { { 10, 2, 0, 0 }, { 2, 10, 0, 0 } }
local MORE_BARS = { { 3, 3, -5, 0 }, { 3, 3, 0, 0 }, { 3, 3, 5, 0 } }

local function IsSecret(value)
    return issecretvalue and issecretvalue(value)
end

local function SafeNumber(value)
    return type(value) == "number" and not IsSecret(value)
end

local function SafeRect(frame)
    if not frame then return end
    local l, b, w, h = frame:GetLeft(), frame:GetBottom(), frame:GetWidth(), frame:GetHeight()
    if not SafeNumber(l) or not SafeNumber(b) or not SafeNumber(w) or not SafeNumber(h) then return end
    if w <= 1 or h <= 1 then return end
    return l, b, w, h
end

-- Native tab art is hidden per tab, not per ghost: ghosts are reused in row
-- order, so when a tab closed and the others shifted left, the freed ghost
-- restored the art of a tab another ghost still covered.
Tabs.suppressed = {}

local function SuppressNativeTab(tab)
    local saved = Tabs.suppressed[tab]
    if not saved then
        saved = {}
        Tabs.suppressed[tab] = saved
    end
    local count = select("#", tab:GetRegions())
    for i = 1, count do
        local region = select(i, tab:GetRegions())
        if region and region.SetAlpha then
            if saved[region] == nil then saved[region] = region:GetAlpha() end
            region:SetAlpha(0)
        end
    end
end

local function RestoreNativeTab(tab)
    local saved = Tabs.suppressed[tab]
    if not saved then return end
    for region, alpha in pairs(saved) do
        if region and region.SetAlpha then region:SetAlpha(alpha or 1) end
    end
    Tabs.suppressed[tab] = nil
end

-- Restore every native tab that is not in TomoMod's row any more (an
-- undocked window shows its own tab again), or all of them (keep == nil).
local function RestoreNativeTabsExcept(keep)
    for tab in pairs(Tabs.suppressed) do
        if not (keep and keep[tab]) then RestoreNativeTab(tab) end
    end
end

local function ShouldMirrorTab(cf)
    if not cf then return false end
    if cf._tomoCommunity then return true end
    -- Combat Log is special: players can undock/move ChatFrame2 independently,
    -- but V4 still treats it as a first-class tab beside General.
    return cf == _G.ChatFrame1 or cf == _G.ChatFrame2 or cf.isDocked == true
end

local function NativeSelectedFrame()
    local selected = GENERAL_CHAT_DOCK and FCFDock_GetSelectedWindow
        and FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK)
    return selected or SELECTED_CHAT_FRAME or _G.ChatFrame1
end

function Tabs:GetSelectedFrame()
    if self.selected and ShouldMirrorTab(self.selected) then
        return self.selected
    end
    local selected = NativeSelectedFrame()
    if selected and ShouldMirrorTab(selected) then return selected end
    return _G.ChatFrame1
end

function Tabs:SetSelectedFrame(cf)
    if not ShouldMirrorTab(cf) then return end
    self.selected = cf
    self.unread[cf] = nil
end

local function RefreshSelection()
    local renderer = Chat.Modules.Renderer
    if renderer then
        local selected = Tabs:GetSelectedFrame()
        if selected then renderer:EnsureFrame(selected) end
        renderer:RefreshVisibility()
    end
    local input = Chat.Modules.Input
    if input and input.Refresh then input:Refresh() end
end

function Tabs:RefreshCommunityMenu()
    local menu = self.communityMenu
    if not menu then return end
    local settings = Chat.GetDB().community or {}
    for _, row in ipairs(menu.rows) do
        row.mark:SetShown(settings[row.key] ~= false)
    end
end

local function CreateCommunityMenu()
    local menu = CreateFrame("Frame", "TomoModChatV4CommunityMenu", UIParent, "BackdropTemplate")
    menu:SetSize(252, 142)
    menu:SetFrameStrata("DIALOG")
    menu:SetFrameLevel(220)
    menu:SetClampedToScreen(true)
    menu:EnableMouse(true)
    menu:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 })
    menu:SetBackdropColor(0.025, 0.035, 0.045, 0.98)
    menu:SetBackdropBorderColor(TEAL_R, TEAL_G, TEAL_B, 0.75)
    menu:Hide()

    local title = menu:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    title:SetPoint("TOPLEFT", 12, -10)
    title:SetPoint("TOPRIGHT", -12, -10)
    title:SetJustifyH("LEFT")
    title:SetText(Localize("chat_v4_community_settings", "Community messages"))
    title:SetTextColor(1, 1, 1, 1)

    menu.rows = {}
    for index, option in ipairs(COMMUNITY_FILTERS) do
        local row = CreateFrame("Button", nil, menu)
        row:SetPoint("TOPLEFT", 7, -30 - ((index - 1) * 26))
        row:SetPoint("TOPRIGHT", -7, -30 - ((index - 1) * 26))
        row:SetHeight(24)
        row.key = option.key

        local hover = row:CreateTexture(nil, "BACKGROUND")
        hover:SetAllPoints()
        hover:SetColorTexture(TEAL_R, TEAL_G, TEAL_B, 0.10)
        hover:Hide()

        local box = row:CreateTexture(nil, "ARTWORK")
        box:SetSize(14, 14)
        box:SetPoint("LEFT", 5, 0)
        box:SetColorTexture(0.16, 0.19, 0.22, 1)

        local mark = row:CreateTexture(nil, "OVERLAY")
        mark:SetSize(8, 8)
        mark:SetPoint("CENTER", box)
        mark:SetColorTexture(TEAL_R, TEAL_G, TEAL_B, 1)
        row.mark = mark

        local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        label:SetPoint("LEFT", box, "RIGHT", 8, 0)
        label:SetPoint("RIGHT", -5, 0)
        label:SetJustifyH("LEFT")
        label:SetText(Localize(option.label, option.fallback))
        label:SetTextColor(0.84, 0.87, 0.90, 1)

        row:SetScript("OnEnter", function() hover:Show(); label:SetTextColor(1, 1, 1, 1) end)
        row:SetScript("OnLeave", function() hover:Hide(); label:SetTextColor(0.84, 0.87, 0.90, 1) end)
        row:SetScript("OnClick", function(self)
            local settings = Chat.GetDB().community
            settings[self.key] = settings[self.key] == false
            Tabs:RefreshCommunityMenu()
            local renderer = Chat.Modules.Renderer
            if renderer and renderer.RebuildAll then renderer:RebuildAll() end
        end)
        menu.rows[#menu.rows + 1] = row
    end

    Tabs.communityMenu = menu
    Tabs:RefreshCommunityMenu()
    return menu
end

function Tabs:ToggleCommunityMenu(anchor)
    local menu = self.communityMenu or CreateCommunityMenu()
    if menu:IsShown() and menu.anchor == anchor then
        menu:Hide()
        menu.anchor = nil
        return
    end
    menu.anchor = anchor
    self:RefreshCommunityMenu()
    menu:ClearAllPoints()
    menu:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -3)
    menu:Show()
end

local function HideCommunityMenu()
    if Tabs.communityMenu then
        Tabs.communityMenu:Hide()
        Tabs.communityMenu.anchor = nil
    end
end

-- A click on one of our tabs (or on a row of the overflow list).
local function ActivateTab(cf, tab, button, anchor)
    if not cf then return end
    Tabs:SetSelectedFrame(cf)

    if cf._tomoCommunity and button == "RightButton" and anchor then
        Tabs:ToggleCommunityMenu(anchor)
    else
        HideCommunityMenu()
    end

    -- Let Blizzard execute its normal tab behavior (Combat Log filter state,
    -- temporary windows, context menu). The native tab is only invisible;
    -- it is not replaced as a behavior implementation.
    if tab and tab.Click then
        tab:Click(button or "LeftButton")
    end

    C_Timer.After(0, function()
        RefreshSelection()
        Tabs:Refresh()
    end)
end

local function CreateGhost()
    local g = CreateFrame("Button", nil, UIParent, "BackdropTemplate")
    g:SetBackdrop({ bgFile = WHITE })
    g:SetBackdropColor(0.025, 0.045, 0.05, 0.88)
    g:SetFrameStrata("MEDIUM")
    g:SetFrameLevel(100)
    g:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    g:EnableMouse(true)
    g:Hide()

    local text = g:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    text:SetPoint("CENTER", 0, 1)
    text:SetTextColor(0.72, 0.76, 0.78, 1)
    g.text = text

    local underline = g:CreateTexture(nil, "OVERLAY")
    underline:SetColorTexture(TEAL_R, TEAL_G, TEAL_B, 1)
    underline:SetHeight(2)
    underline:SetPoint("BOTTOMLEFT", 2, 0)
    underline:SetPoint("BOTTOMRIGHT", -2, 0)
    underline:Hide()
    g.underline = underline

    local dot = CreateDot(g, 5)
    dot:SetPoint("TOPRIGHT", -4, -4)
    g.dot = dot

    g:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.045, 0.075, 0.08, 0.96)
        self.text:SetTextColor(1, 1, 1, 1)
    end)
    g:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0.025, 0.045, 0.05, 0.88)
        local active = self.cf == Tabs:GetSelectedFrame()
        self.text:SetTextColor(active and 1 or 0.72, active and 1 or 0.76, active and 1 or 0.78, 1)
    end)
    g:SetScript("OnClick", function(self, button)
        if Tabs.overflowList then Tabs.overflowList:Hide() end
        ActivateTab(self.cf, self.tab, button, self)
    end)

    return g
end

-- ---------------------------------------------------------------------
-- Overflow: when the tabs no longer fit even at their narrowest, the last
-- ones go into a list behind a "»" button at the end of the row (the open
-- tab always stays in the row). Before, extra tabs ran past the panel's
-- edge, so a new tab could be created and never seen.
-- ---------------------------------------------------------------------
local OVERFLOW_WIDTH = 24
local LIST_ROW_HEIGHT = 20
local LIST_WIDTH = 170

local function CreateOverflowButton()
    local b = CreateFrame("Button", nil, UIParent, "BackdropTemplate")
    b:SetBackdrop({ bgFile = WHITE })
    b:SetBackdropColor(0.025, 0.045, 0.05, 0.88)
    b:SetFrameStrata("MEDIUM")
    b:SetFrameLevel(100)
    b:RegisterForClicks("LeftButtonUp")
    b:Hide()

    b.glyph = CreateGlyph(b, MORE_BARS)
    b.glyph:SetColor(TEAL_R, TEAL_G, TEAL_B)

    local dot = CreateDot(b, 5)
    dot:SetPoint("TOPRIGHT", -3, -3)
    b.dot = dot

    b:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.045, 0.075, 0.08, 0.96)
        self.glyph:SetColor(1, 1, 1)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText(Localize("chat_v4_more_tabs", "More tabs"), 1, 1, 1)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0.025, 0.045, 0.05, 0.88)
        self.glyph:SetColor(TEAL_R, TEAL_G, TEAL_B)
        GameTooltip:Hide()
    end)
    b:SetScript("OnClick", function(self)
        GameTooltip:Hide()
        Tabs:ToggleOverflowList(self)
    end)
    return b
end

local function CreateOverflowList()
    local list = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    list:SetFrameStrata("DIALOG")
    list:SetFrameLevel(220)
    list:SetClampedToScreen(true)
    list:EnableMouse(true)
    list:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 })
    list:SetBackdropColor(0.025, 0.035, 0.045, 0.98)
    list:SetBackdropBorderColor(TEAL_R, TEAL_G, TEAL_B, 0.75)
    list:Hide()
    list.rows = {}

    -- A click anywhere else closes it, like a menu.
    list:SetScript("OnShow", function(self) self:RegisterEvent("GLOBAL_MOUSE_DOWN") end)
    list:SetScript("OnHide", function(self) self:UnregisterEvent("GLOBAL_MOUSE_DOWN") end)
    list:SetScript("OnEvent", function(self)
        if not self:IsMouseOver() and not (self.anchor and self.anchor:IsMouseOver()) then
            self:Hide()
        end
    end)
    return list
end

local function ListRow(list, index)
    local row = list.rows[index]
    if row then return row end
    row = CreateFrame("Button", nil, list)
    row:SetHeight(LIST_ROW_HEIGHT)
    row:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    local hover = row:CreateTexture(nil, "BACKGROUND")
    hover:SetAllPoints()
    hover:SetColorTexture(TEAL_R, TEAL_G, TEAL_B, 0.10)
    hover:Hide()

    local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    label:SetPoint("LEFT", 8, 0)
    label:SetPoint("RIGHT", -16, 0)
    label:SetJustifyH("LEFT")
    label:SetWordWrap(false)
    label:SetTextColor(0.84, 0.87, 0.90, 1)
    row.label = label

    local dot = CreateDot(row, 5)
    dot:SetPoint("RIGHT", -6, 0)
    row.dot = dot

    row:SetScript("OnEnter", function() hover:Show(); label:SetTextColor(1, 1, 1, 1) end)
    row:SetScript("OnLeave", function() hover:Hide(); label:SetTextColor(0.84, 0.87, 0.90, 1) end)
    row:SetScript("OnClick", function(self, button)
        list:Hide()
        ActivateTab(self.cf, self.tab, button, nil)
    end)
    list.rows[index] = row
    return row
end

function Tabs:RefreshOverflowList()
    local list = self.overflowList
    if not list or not list:IsShown() then return end
    local hidden = self.hiddenEntries or {}
    if #hidden == 0 then list:Hide() return end
    for index, entry in ipairs(hidden) do
        local row = ListRow(list, index)
        row.cf, row.tab = entry.cf, entry.tab
        row.label:SetText(entry.name)
        row.dot:SetShown(self.unread[entry.cf] == true)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", 4, -4 - (index - 1) * LIST_ROW_HEIGHT)
        row:SetPoint("TOPRIGHT", -4, -4 - (index - 1) * LIST_ROW_HEIGHT)
        row:Show()
    end
    for index = #hidden + 1, #list.rows do list.rows[index]:Hide() end
    list:SetSize(LIST_WIDTH, #hidden * LIST_ROW_HEIGHT + 8)
end

function Tabs:ToggleOverflowList(anchor)
    local list = self.overflowList or CreateOverflowList()
    self.overflowList = list
    if list:IsShown() then list:Hide() return end
    HideCommunityMenu()
    list.anchor = anchor
    list:ClearAllPoints()
    list:SetPoint("TOPRIGHT", anchor, "BOTTOMRIGHT", 0, -3)
    list:Show()
    self:RefreshOverflowList()
end

local function ValidName(name)
    return type(name) == "string" and not IsSecret(name) and name ~= "" and name
end

-- The native tab's own text first: Blizzard writes it for every window,
-- temporary whisper tabs included. GetChatWindowInfo only knows the ten
-- permanent windows, so whisper tabs had no name and were never drawn.
local function TabLabel(cf, tab)
    local name = tab and tab.GetText and ValidName(tab:GetText())
    if name then return name end
    name = ValidName(cf.name)
    if name then return name end
    local id = cf.GetID and cf:GetID()
    if GetChatWindowInfo and SafeNumber(id) and id >= 1 then
        return ValidName((GetChatWindowInfo(id)))
    end
end

-- ---------------------------------------------------------------------
-- "+": new tab. A menu of ready-made tabs (each copies its message groups;
-- General keeps showing them too) and a field for any other name. Windows
-- are created with Blizzard's own FCF_OpenNewWindow, the way its "New
-- window" popup does; the Bridge's hook then selects the new tab.
-- ---------------------------------------------------------------------
local ADD_WIDTH = 22
local MENU_WIDTH = 190
local MAX_NAME = 31 -- Blizzard's limit for a chat window name.
local TRADE_CHANNEL_ID = 2 -- the zone Trade channel

local function TradeChannelName()
    local info = C_ChatInfo
    local name = info and info.GetChannelShortcutForChannelID
        and info.GetChannelShortcutForChannelID(TRADE_CHANNEL_ID)
    if type(name) ~= "string" or IsSecret(name) or name == "" then return end
    local id = GetChannelName and GetChannelName(name)
    if type(id) == "number" and not IsSecret(id) and id > 0 then return name end
end

local function Presets()
    local list = {
        { name = Localize("chat_v4_new_guild", "Guild"),
          groups = { "GUILD", "OFFICER", "GUILD_ACHIEVEMENT" } },
        { name = Localize("chat_v4_new_group", "Group"),
          groups = { "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING",
                     "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER" } },
        { name = Localize("chat_v4_new_whispers", "Whispers"),
          groups = { "WHISPER", "BN_WHISPER" } },
    }
    -- Trade only while the player is in it (cities).
    local trade = TradeChannelName()
    if trade then list[#list + 1] = { name = trade, groups = {}, channels = { trade } } end
    list[#list + 1] = { name = Localize("chat_v4_new_loot", "Loot"),
        groups = { "LOOT", "MONEY", "CURRENCY" } }
    return list
end

-- A preset whose tab is already open is not offered a second time.
local function IsTabOpen(name)
    local open = false
    Chat.EachChatFrame(function(cf)
        if open or not (cf.isDocked or cf:IsShown()) then return end
        local tab = _G[(cf:GetName() or "") .. "Tab"]
        if tab and TabLabel(cf, tab) == name then open = true end
    end)
    return open
end

local function CanOpenWindow()
    return type(FCF_OpenNewWindow) == "function"
        and (type(FCF_CanOpenNewWindow) ~= "function" or FCF_CanOpenNewWindow())
end

local function AddGroup(frame, group)
    if frame.AddMessageGroup then
        frame:AddMessageGroup(group)
    elseif ChatFrame_AddMessageGroup then
        ChatFrame_AddMessageGroup(frame, group)
    end
end

local function AddChannel(frame, channel)
    if frame.AddChannel then
        frame:AddChannel(channel)
    elseif ChatFrame_AddChannel then
        ChatFrame_AddChannel(frame, channel)
    end
end

local function CreateTab(name, groups, channels)
    if not CanOpenWindow() then return end
    -- With a preset, the window starts empty and gets only its groups;
    -- a free name gets what Blizzard's own new windows show.
    local frame = FCF_OpenNewWindow(name, groups ~= nil)
    if not frame then return end
    if groups and type(FCF_CopyChatSettings) == "function" and DEFAULT_CHAT_FRAME then
        FCF_CopyChatSettings(frame, DEFAULT_CHAT_FRAME)
    end
    for _, group in ipairs(groups or {}) do AddGroup(frame, group) end
    for _, channel in ipairs(channels or {}) do AddChannel(frame, channel) end
    if type(FCF_DockUpdate) == "function" then FCF_DockUpdate() end
end

local function CreateAddButton()
    local b = CreateFrame("Button", nil, UIParent, "BackdropTemplate")
    b:SetBackdrop({ bgFile = WHITE })
    b:SetBackdropColor(0.025, 0.045, 0.05, 0.88)
    b:SetFrameStrata("MEDIUM")
    b:SetFrameLevel(100)
    b:RegisterForClicks("LeftButtonUp")
    b:Hide()

    b.glyph = CreateGlyph(b, PLUS_BARS)
    b.glyph:SetColor(TEAL_R, TEAL_G, TEAL_B)

    b:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.045, 0.075, 0.08, 0.96)
        self.glyph:SetColor(1, 1, 1)
        if not (Tabs.newTabMenu and Tabs.newTabMenu:IsShown()) then
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText(Localize("chat_v4_new_tab", "New tab"), 1, 1, 1)
            GameTooltip:Show()
        end
    end)
    b:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0.025, 0.045, 0.05, 0.88)
        self.glyph:SetColor(TEAL_R, TEAL_G, TEAL_B)
        GameTooltip:Hide()
    end)
    b:SetScript("OnClick", function(self)
        GameTooltip:Hide()
        Tabs:ToggleNewTabMenu(self)
    end)
    return b
end

local function CreateNewTabMenu()
    local menu = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    menu:SetFrameStrata("DIALOG")
    menu:SetFrameLevel(220)
    menu:SetClampedToScreen(true)
    menu:EnableMouse(true)
    menu:SetWidth(MENU_WIDTH)
    menu:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 })
    menu:SetBackdropColor(0.025, 0.035, 0.045, 0.98)
    menu:SetBackdropBorderColor(TEAL_R, TEAL_G, TEAL_B, 0.75)
    menu:Hide()
    menu.rows = {}

    local title = menu:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    title:SetPoint("TOPLEFT", 10, -9)
    title:SetPoint("TOPRIGHT", -10, -9)
    title:SetJustifyH("LEFT")
    title:SetText(Localize("chat_v4_new_tab", "New tab"))
    title:SetTextColor(1, 1, 1, 1)
    menu.title = title

    -- Any other name. A plain edit box drawn by TomoMod (no template art).
    local edit = CreateFrame("EditBox", nil, menu, "BackdropTemplate")
    edit:SetAutoFocus(false)
    edit:SetMaxLetters(MAX_NAME)
    edit:SetHeight(20)
    edit:SetFontObject(GameFontHighlightSmall)
    edit:SetTextInsets(6, 6, 0, 0)
    edit:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 })
    edit:SetBackdropColor(0.06, 0.07, 0.08, 1)
    edit:SetBackdropBorderColor(TEAL_R, TEAL_G, TEAL_B, 0.45)
    local placeholder = edit:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    placeholder:SetPoint("LEFT", 6, 0)
    placeholder:SetPoint("RIGHT", -6, 0)
    placeholder:SetJustifyH("LEFT")
    placeholder:SetText(Localize("chat_v4_new_other", "Other name, then Enter"))
    local function UpdatePlaceholder()
        placeholder:SetShown(edit:GetText() == "" and not edit:HasFocus())
    end
    edit:SetScript("OnTextChanged", UpdatePlaceholder)
    edit:SetScript("OnEditFocusGained", function(self)
        self:SetBackdropBorderColor(TEAL_R, TEAL_G, TEAL_B, 1)
        UpdatePlaceholder()
    end)
    edit:SetScript("OnEditFocusLost", function(self)
        self:SetBackdropBorderColor(TEAL_R, TEAL_G, TEAL_B, 0.45)
        UpdatePlaceholder()
    end)
    edit:SetScript("OnEscapePressed", function() menu:Hide() end)
    edit:SetScript("OnEnterPressed", function(self)
        local name = strtrim(self:GetText() or "")
        if name ~= "" then
            menu:Hide()
            CreateTab(name)
        end
    end)
    menu.edit = edit

    local note = menu:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    note:SetJustifyH("LEFT")
    note:SetText(Localize("chat_v4_new_full", "All chat windows are in use: close one first."))
    menu.note = note

    menu:SetScript("OnShow", function(self) self:RegisterEvent("GLOBAL_MOUSE_DOWN") end)
    menu:SetScript("OnHide", function(self)
        self:UnregisterEvent("GLOBAL_MOUSE_DOWN")
        self.edit:SetText("")
        self.edit:ClearFocus()
    end)
    menu:SetScript("OnEvent", function(self)
        if not self:IsMouseOver() and not (self.anchor and self.anchor:IsMouseOver()) then
            self:Hide()
        end
    end)
    return menu
end

local function NewTabRow(menu, index)
    local row = menu.rows[index]
    if row then return row end
    row = CreateFrame("Button", nil, menu)
    row:SetHeight(LIST_ROW_HEIGHT)

    local hover = row:CreateTexture(nil, "BACKGROUND")
    hover:SetAllPoints()
    hover:SetColorTexture(TEAL_R, TEAL_G, TEAL_B, 0.10)
    hover:Hide()

    local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    label:SetPoint("LEFT", 6, 0)
    label:SetPoint("RIGHT", -6, 0)
    label:SetJustifyH("LEFT")
    label:SetWordWrap(false)
    row.label = label

    row:SetScript("OnEnter", function(self)
        if self:IsEnabled() then hover:Show(); label:SetTextColor(1, 1, 1, 1) end
    end)
    row:SetScript("OnLeave", function(self)
        hover:Hide()
        if self:IsEnabled() then label:SetTextColor(0.84, 0.87, 0.90, 1) end
    end)
    row:SetScript("OnClick", function(self)
        local preset = self.preset
        menu:Hide()
        if preset then CreateTab(preset.name, preset.groups, preset.channels) end
    end)
    menu.rows[index] = row
    return row
end

-- The rows follow what is available right now (Trade comes and goes, an
-- open preset is left out, ten windows is Blizzard's limit).
function Tabs:RefreshNewTabMenu()
    local menu = self.newTabMenu
    if not menu or not menu:IsShown() then return end
    local free = CanOpenWindow()

    local previous, count = menu.title, 0
    for _, preset in ipairs(Presets()) do
        if not IsTabOpen(preset.name) then
            count = count + 1
            local row = NewTabRow(menu, count)
            row.preset = preset
            row.label:SetText(preset.name)
            row:SetEnabled(free)
            row.label:SetTextColor(free and 0.84 or 0.45, free and 0.87 or 0.45, free and 0.90 or 0.45, 1)
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", previous == menu.title and -4 or 0, previous == menu.title and -5 or 0)
            row:SetPoint("RIGHT", menu, "RIGHT", -6, 0)
            row:Show()
            previous = row
        end
    end
    for index = count + 1, #menu.rows do menu.rows[index]:Hide() end

    local height = 9 + 14 + 5 + count * LIST_ROW_HEIGHT
    menu.edit:ClearAllPoints()
    menu.edit:SetPoint("TOPLEFT", menu, "TOPLEFT", 8, -height - 6)
    menu.edit:SetPoint("RIGHT", menu, "RIGHT", -8, 0)
    menu.edit:SetEnabled(free)
    height = height + 6 + 20
    menu.note:ClearAllPoints()
    menu.note:SetPoint("TOPLEFT", menu.edit, "BOTTOMLEFT", 0, -6)
    menu.note:SetPoint("RIGHT", menu, "RIGHT", -8, 0)
    menu.note:SetShown(not free)
    if not free then
        local noteHeight = menu.note:GetStringHeight()
        height = height + 6 + (SafeNumber(noteHeight) and noteHeight or 24)
    end
    menu:SetHeight(height + 9)
end

function Tabs:ToggleNewTabMenu(anchor)
    local menu = self.newTabMenu or CreateNewTabMenu()
    self.newTabMenu = menu
    if menu:IsShown() then menu:Hide() return end
    HideCommunityMenu()
    if self.overflowList then self.overflowList:Hide() end
    menu.anchor = anchor
    menu:ClearAllPoints()
    menu:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -3)
    menu:Show()
    self:RefreshNewTabMenu()
end

-- Blizzard's own overflow arrow sits on the dock, under our row; it stays
-- working but invisible, like the native tabs.
local function SetNativeOverflowShown(shown)
    local native = GENERAL_CHAT_DOCK and GENERAL_CHAT_DOCK.overflowButton
    if native and native.SetAlpha then native:SetAlpha(shown and 1 or 0) end
end

-- The tabs in the order Blizzard's dock shows them (a new or dragged tab
-- keeps its place), then an undocked Combat Log. Ordering by window ID put
-- tabs out of place, and listed whisper tabs (ChatFrame11+) only by luck.
local function OrderedFrames()
    local list, seen = {}, {}
    local function Add(cf)
        if cf and not seen[cf] and ShouldMirrorTab(cf) then
            seen[cf] = true
            list[#list + 1] = cf
        end
    end
    Add(_G.ChatFrame1)
    local docked = GENERAL_CHAT_DOCK and FCFDock_GetChatFrames and FCFDock_GetChatFrames(GENERAL_CHAT_DOCK)
    if type(docked) == "table" then
        for _, cf in ipairs(docked) do Add(cf) end
    end
    if _G.ChatFrame2 and not seen[_G.ChatFrame2] then
        table.insert(list, math.min(2, #list + 1), _G.ChatFrame2)
        seen[_G.ChatFrame2] = true
    end
    Chat.EachChatFrame(Add)
    return list
end


function Tabs:NotifyMessage(cf)
    if cf ~= self:GetSelectedFrame() then
        self.unread[cf] = true
        self:Refresh()
    end
end

function Tabs:Refresh()
    if not self._initialized then return end
    local enabled = Chat.IsEnabled()
    local selected = self:GetSelectedFrame()
    if selected then self.unread[selected] = nil end

    local layout = Chat.Modules.Layout
    local host = layout and layout.tabsHost
    local _, _, hostWidth, hostHeight = SafeRect(host)
    if not host then return end

    local entries = {}
    if enabled then
        for _, cf in ipairs(OrderedFrames()) do
            local tab = _G[(cf:GetName() or "") .. "Tab"]
            local name = tab and TabLabel(cf, tab)
            if name then entries[#entries + 1] = { cf = cf, tab = tab, name = name } end
        end
        local renderer = Chat.Modules.Renderer
        local community = renderer and renderer.communityFrame
        if community then
            entries[#entries + 1] = { cf = community, name =
                (TomoMod_L and TomoMod_L["chat_v4_tab_community"]) or "Community" }
        end
    end

    -- Natural width of each tab, then fit them into the row.
    local GAP, MIN_W, MAX_W = 3, 42, 130
    local measure = self.measure
    if not measure then
        measure = host:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        measure:Hide()
        self.measure = measure
    end
    local total = 0
    for _, entry in ipairs(entries) do
        local nativeWidth = entry.tab and entry.tab.GetWidth and entry.tab:GetWidth()
        local width
        if SafeNumber(nativeWidth) and nativeWidth > 1 then
            width = nativeWidth
        else
            measure:SetText(entry.name)
            local textWidth = measure:GetStringWidth()
            width = (SafeNumber(textWidth) and textWidth or 48) + 22
        end
        entry.width = math.max(62, math.min(MAX_W, width))
        total = total + entry.width
    end
    total = total + GAP * math.max(0, #entries - 1)

    local canAdd = enabled and type(FCF_OpenNewWindow) == "function"
    local available = hostWidth and (hostWidth - 2) or math.huge
    if canAdd then available = available - ADD_WIDTH - GAP end
    local visible, hidden = entries, {}
    local overflow = false
    if total > available and #entries > 0 then
        local n = #entries
        local even = math.floor((available - GAP * (n - 1)) / n)
        if even >= MIN_W then
            for _, entry in ipairs(entries) do entry.width = math.min(entry.width, even) end
        else
            -- Not even at the narrowest: keep what fits, the open tab always.
            overflow = true
            local room = available - OVERFLOW_WIDTH - GAP
            local keep = math.max(1, math.floor((room + GAP) / (MIN_W + GAP)))
            local selectedIndex
            for index, entry in ipairs(entries) do
                if entry.cf == selected then selectedIndex = index end
            end
            -- The first tabs that fit; the open one takes the last slot when
            -- it sits further along.
            local last = (selectedIndex and selectedIndex > keep) and keep - 1 or keep
            visible = {}
            for index, entry in ipairs(entries) do
                if index <= last or index == selectedIndex then
                    visible[#visible + 1] = entry
                else
                    hidden[#hidden + 1] = entry
                end
            end
            local width = math.floor((room - GAP * (#visible - 1)) / #visible)
            width = math.max(MIN_W, math.min(MAX_W, width))
            for _, entry in ipairs(visible) do entry.width = math.min(entry.width, width) end
        end
    end
    self.hiddenEntries = hidden

    local used = 0
    local x = 1
    for _, entry in ipairs(visible) do
        used = used + 1
        local g = self.ghosts[used] or CreateGhost()
        self.ghosts[used] = g
        g.cf = entry.cf
        g.tab = entry.tab
        g.text:SetText(entry.name)

        -- Never use the native tab's screen position. ChatFrame2 can be
        -- undocked and physically moved by Blizzard; V4 tabs always flow
        -- left-to-right inside our own tabsHost.
        g:ClearAllPoints()
        g:SetPoint("BOTTOMLEFT", host, "BOTTOMLEFT", x, 1)
        g:SetSize(entry.width, math.max(18, (hostHeight or 25) - 2))
        x = x + entry.width + GAP

        local active = entry.cf == selected
        g.text:SetTextColor(active and 1 or 0.72, active and 1 or 0.76, active and 1 or 0.78, 1)
        g.underline:SetShown(active)
        g.dot:SetShown(self.unread[entry.cf] == true and not active)
        g:Show()
    end

    -- Every tab of the row, shown or in the overflow list, stays invisible
    -- natively; any other native tab gets its art back.
    local mirrored = {}
    for _, entry in ipairs(entries) do
        if entry.tab then
            mirrored[entry.tab] = true
            SuppressNativeTab(entry.tab)
        end
    end
    RestoreNativeTabsExcept(mirrored)

    for i = used + 1, #self.ghosts do
        local g = self.ghosts[i]
        g:Hide()
        g.cf = nil
        g.tab = nil
    end

    local add = self.addButton
    if canAdd then
        add = add or CreateAddButton()
        self.addButton = add
        add:ClearAllPoints()
        add:SetPoint("BOTTOMLEFT", host, "BOTTOMLEFT", x, 1)
        add:SetSize(ADD_WIDTH, math.max(18, (hostHeight or 25) - 2))
        add:Show()
        self:RefreshNewTabMenu()
    else
        if add then add:Hide() end
        if self.newTabMenu then self.newTabMenu:Hide() end
    end

    local more = self.overflowButton
    if overflow then
        more = more or CreateOverflowButton()
        self.overflowButton = more
        more:ClearAllPoints()
        more:SetPoint("BOTTOMRIGHT", host, "BOTTOMRIGHT", -1, 1)
        more:SetSize(OVERFLOW_WIDTH, math.max(18, (hostHeight or 25) - 2))
        local unread = false
        for _, entry in ipairs(hidden) do
            if self.unread[entry.cf] then unread = true break end
        end
        more.dot:SetShown(unread)
        more:Show()
        self:RefreshOverflowList()
    else
        if more then more:Hide() end
        if self.overflowList then self.overflowList:Hide() end
    end
    SetNativeOverflowShown(not enabled)
end

function Tabs:Initialize()
    self._initialized = true
    self.selected = NativeSelectedFrame() or _G.ChatFrame1
    self:Refresh()
end

function Tabs:ApplySettings(enabled)
    if enabled then
        self:Refresh()
    else
        self.selected = nil
        if self.communityMenu then self.communityMenu:Hide() end
        if self.overflowButton then self.overflowButton:Hide() end
        if self.overflowList then self.overflowList:Hide() end
        if self.addButton then self.addButton:Hide() end
        if self.newTabMenu then self.newTabMenu:Hide() end
        SetNativeOverflowShown(true)
        RestoreNativeTabsExcept(nil)
        for _, g in ipairs(self.ghosts) do g:Hide() end
    end
end
