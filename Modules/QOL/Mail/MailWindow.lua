-- TomoMod_Mail | Modules/Window.lua
-- Standalone dark mail window that fully replaces the Blizzard frame.
-- The native MailFrame is kept functional but invisible (alpha 0); the
-- native SendMailFrame is reparented into our compose page so the real
-- send / attachment / money widgets keep working inside our own chrome.
-- Sized independently of Blizzard's frame, with a font picker and a
-- modern underline-tab layout.

local TM     = TomoMod_Mail
local UI     = TM.UI
local Window = {}
TM:RegisterModule("Window", Window)
TM.Window = Window

local win, inboxPage, composePage, settings, fontList
local tabs    = {}
local current = "INBOX"

local W, H = 440, 640

-- ============================================================
--  Gating
-- ============================================================

local function ModernEnabled()
    if not TM.db then return false end
    local p = TM.db.profile
    return p.skinEnabled ~= false and p.modernUI ~= false
end

-- ============================================================
--  Hide native frame visuals while keeping it functional
-- ============================================================

local function HideNativeChrome()
    pcall(function()
        if MailFrame then
            MailFrame:SetAlpha(0)
            MailFrame:EnableMouse(false)
        end
        if InboxFrame then InboxFrame:EnableMouse(false) end
        for _, n in ipairs({ "MailFrameTab1", "MailFrameTab2" }) do
            local t = _G[n]
            if t then t:EnableMouse(false) end
        end
    end)
end

-- ============================================================
--  Engine "send-mail is showing" flag (right-click-to-attach)
-- ============================================================
-- Right-clicking a bag item to attach it is gated engine-side by
-- SetSendMailShowing(), which Blizzard only ever calls from MailFrameTab_OnClick.
-- Our window shows the reparented SendMailFrame directly and never routes through
-- that tab handler, so the flag stayed false on the Send tab and a right-click
-- "used" the item instead of attaching it (drag-to-slot calls the slot directly,
-- so that path kept working -- exactly the reported symptom). We assert the flag
-- ourselves: true while the Send tab is up, false otherwise. Guarded so an
-- absent/renamed engine function degrades to the old behaviour instead of erroring.
local function SetSendShowing(on)
    if type(SetSendMailShowing) == "function" then
        pcall(SetSendMailShowing, on and true or false)
    end
end

-- ============================================================
--  Position persistence
-- ============================================================

local function SavePos()
    if not (win and TM.db and TM.db.global) then return end
    local point, _, _, x, y = win:GetPoint()
    if point then TM.db.global.window = { point = point, x = x, y = y } end
end

local function RestorePos()
    if not win then return end
    win:ClearAllPoints()
    local wp = TM.db and TM.db.global and TM.db.global.window
    if wp and wp.point and tostring(wp.point):find("TOP") then
        win:SetPoint(wp.point, UIParent, wp.point, wp.x or 0, wp.y or 0)
    else
        win:SetPoint("TOP", UIParent, "TOP", -160, -100)
    end
end

-- Fit the window height to the active tab: tall list for the inbox,
-- snug to the native compose content for the send tab. Anchoring by the
-- top means the height only grows/shrinks downward (no jump).
local function ApplyTabHeight(key)
    if not win then return end
    if key == "SEND" then
        C_Timer.After(0.05, function()
            if not win then return end
            -- Deterministic fit: window height = chrome + the native send
            -- frame's own logical height (+ small pad). GetHeight returns the
            -- set value, so this never depends on layout timing or UI scale,
            -- and the window always fully contains the native widgets.
            local newH = 540
            pcall(function()
                local fh = SendMailFrame and SendMailFrame:GetHeight()
                if fh and fh > 120 then
                    newH = 66 + 8 + fh + 12   -- chrome + frame top offset + frame + pad
                end
            end)
            if newH < 360 then newH = 360 elseif newH > 820 then newH = 820 end
            win:SetHeight(newH)
        end)
    else
        win:SetHeight(H)
    end
end

-- ============================================================
--  Underline tab button (modern)
-- ============================================================

local function CreateTabButton(parent, label, key)
    local b = CreateFrame("Button", nil, parent)
    b.label = UI:FS(b, "normal")
    b.label:SetPoint("CENTER", 0, 2)
    b.label:SetText(label)

    b.underline = b:CreateTexture(nil, "ARTWORK")
    b.underline:SetHeight(2)
    b.underline:SetPoint("BOTTOMLEFT", 8, 0)
    b.underline:SetPoint("BOTTOMRIGHT", -8, 0)
    b.underline:SetColorTexture(unpack(UI.COLORS.accent))
    b.underline:Hide()

    b._key = key
    function b:SetActive(a)
        if a then
            b.label:SetTextColor(unpack(UI.COLORS.accent))
            b.underline:Show()
        else
            b.label:SetTextColor(unpack(UI.COLORS.textDim))
            b.underline:Hide()
        end
    end
    b:SetScript("OnEnter", function(s) if s._key ~= current then s.label:SetTextColor(0.788, 0.635, 0.322) end end)
    b:SetScript("OnLeave", function(s) if s._key ~= current then s.label:SetTextColor(unpack(UI.COLORS.textDim)) end end)
    return b
end

-- ============================================================
--  Font picker popover
-- ============================================================

local function BuildFontList(ddBtn)
    if fontList then return fontList end
    fontList = UI:CreatePanel(win, "TomoMod_MailFontList", 210, 220)
    fontList:SetFrameStrata("TOOLTIP")
    fontList:SetFrameLevel((settings and settings:GetFrameLevel() or win:GetFrameLevel()) + 50)
    fontList:SetPoint("TOPLEFT", ddBtn, "BOTTOMLEFT", 0, -2)
    fontList:Hide()

    -- guaranteed-opaque background so the widgets behind never show through
    fontList:SetBackdropColor(UI.COLORS.bg[1], UI.COLORS.bg[2], UI.COLORS.bg[3], 1)
    local solid = fontList:CreateTexture(nil, "BACKGROUND")
    solid:SetAllPoints()
    solid:SetColorTexture(UI.COLORS.bg[1], UI.COLORS.bg[2], UI.COLORS.bg[3], 1)

    local scroll = CreateFrame("ScrollFrame", nil, fontList)
    scroll:SetPoint("TOPLEFT", 4, -4)
    scroll:SetPoint("BOTTOMRIGHT", -6, 4)
    scroll:EnableMouseWheel(true)
    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(10, 10)
    scroll:SetScrollChild(child)

    local fonts = UI:GetFontList()
    local y, rowH = 0, 22
    for _, e in ipairs(fonts) do
        local row = CreateFrame("Button", nil, child)
        row:SetHeight(rowH)
        row:SetPoint("TOPLEFT", 0, -y)
        row:SetPoint("TOPRIGHT", 0, -y)
        UI:AddRowHighlight(row)
        local fs = row:CreateFontString(nil, "OVERLAY")
        pcall(function() fs:SetFont(e.path, 13, "") end)
        if not fs:GetFont() then fs:SetFontObject(UI._fontObjects.small) end
        fs:SetPoint("LEFT", 8, 0)
        fs:SetText(e.name)
        fs:SetTextColor(unpack(UI.COLORS.text))
        row:SetScript("OnClick", function()
            TM.db.profile.font = e.path
            UI:RefreshFonts()
            ddBtn.label:SetText(UI:GetFontName())
            fontList:Hide()
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        end)
        y = y + rowH
    end
    child:SetHeight(math.max(y, 1))
    child:SetWidth(190)
    scroll:SetScript("OnMouseWheel", function(self, delta)
        local maxS = math.max(child:GetHeight() - self:GetHeight(), 0)
        self:SetVerticalScroll(math.max(0, math.min(self:GetVerticalScroll() - delta * rowH * 2, maxS)))
    end)
    return fontList
end

local function BuildSettings()
    settings = UI:CreatePanel(win, "TomoMod_MailSettings", 240, 205)
    settings:SetFrameStrata("FULLSCREEN_DIALOG")
    settings:SetPoint("TOPRIGHT", win, "TOPRIGHT", -8, -32)
    settings:Hide()

    local header = UI:FS(settings, "small")
    header:SetPoint("TOPLEFT", 12, -10)
    header:SetText(TM:L("SETTINGS") or "Réglages")
    header:SetTextColor(unpack(UI.COLORS.accent))

    -- Font dropdown
    local fLabel = UI:FS(settings, "small")
    fLabel:SetPoint("TOPLEFT", 12, -30)
    fLabel:SetText(TM:L("FONT") or "Police")
    fLabel:SetTextColor(unpack(UI.COLORS.textDim))

    local ddBtn = CreateFrame("Button", nil, settings, "BackdropTemplate")
    ddBtn:SetSize(150, 22)
    ddBtn:SetPoint("TOPRIGHT", settings, "TOPRIGHT", -12, -28)
    ddBtn:SetBackdrop(UI.BACKDROP)
    ddBtn:SetBackdropColor(UI.COLORS.bgLight[1], UI.COLORS.bgLight[2], UI.COLORS.bgLight[3], 1)
    ddBtn:SetBackdropBorderColor(unpack(UI.COLORS.border))
    ddBtn.label = UI:FS(ddBtn, "small")
    ddBtn.label:SetPoint("LEFT", 8, 0)
    ddBtn.label:SetText(UI:GetFontName())
    local arrow = UI:FS(ddBtn, "small")
    arrow:SetPoint("RIGHT", -8, 0)
    arrow:SetText("v")
    arrow:SetTextColor(unpack(UI.COLORS.textDim))
    ddBtn:SetScript("OnEnter", function(s) s:SetBackdropBorderColor(unpack(UI.COLORS.accent)) end)
    ddBtn:SetScript("OnLeave", function(s) s:SetBackdropBorderColor(unpack(UI.COLORS.border)) end)
    ddBtn:SetScript("OnClick", function()
        local fl = BuildFontList(ddBtn)
        if fl:IsShown() then fl:Hide() else fl:Show() end
    end)

    -- Size slider
    local slider = CreateFrame("Slider", "TomoMod_MailFontSizeSlider", settings, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", 14, -76)
    slider:SetWidth(210)
    slider:SetMinMaxValues(0.8, 1.4)
    slider:SetValueStep(0.05)
    pcall(function() slider:SetObeyStepOnDrag(true) end)
    slider:SetValue(UI:GetFontSizeScale())
    if _G["TomoMod_MailFontSizeSliderLow"]  then _G["TomoMod_MailFontSizeSliderLow"]:SetText("A-") end
    if _G["TomoMod_MailFontSizeSliderHigh"] then _G["TomoMod_MailFontSizeSliderHigh"]:SetText("A+") end
    if _G["TomoMod_MailFontSizeSliderText"] then
        _G["TomoMod_MailFontSizeSliderText"]:SetText(TM:L("FONT_SIZE") or "Taille du texte")
    end
    slider:SetScript("OnValueChanged", function(_, val)
        if TM.db and TM.db.profile then TM.db.profile.fontSize = val end
        UI:RefreshFonts()
    end)

    -- Item icon size slider (inbox attachment icons)
    local isl = CreateFrame("Slider", "TomoMod_MailIconSizeSlider", settings, "OptionsSliderTemplate")
    isl:SetPoint("TOPLEFT", 14, -120)
    isl:SetWidth(210)
    isl:SetMinMaxValues(18, 36)
    isl:SetValueStep(2)
    pcall(function() isl:SetObeyStepOnDrag(true) end)
    isl:SetValue((TM.db and TM.db.profile and TM.db.profile.inboxIconSize) or 30)
    if _G["TomoMod_MailIconSizeSliderLow"]  then _G["TomoMod_MailIconSizeSliderLow"]:SetText("-") end
    if _G["TomoMod_MailIconSizeSliderHigh"] then _G["TomoMod_MailIconSizeSliderHigh"]:SetText("+") end
    if _G["TomoMod_MailIconSizeSliderText"] then
        _G["TomoMod_MailIconSizeSliderText"]:SetText(TM:L("INBOX_ICON_SIZE") or "Taille des icônes")
    end
    isl:SetScript("OnValueChanged", function(_, val)
        val = math.floor((val or 30) + 0.5)
        if TM.db and TM.db.profile then TM.db.profile.inboxIconSize = val end
        local inbox = TM.modules and TM.modules["Inbox"]
        if inbox and inbox.ApplyIconSize then inbox:ApplyIconSize() end
    end)

    -- Reset position
    local reset = UI:CreateStyledButton(settings, TM:L("RESET_POS") or "Recentrer la fenêtre", 210, 22, "bgLight")
    reset:SetPoint("BOTTOMLEFT", 14, 10)
    reset:SetScript("OnClick", function()
        if TM.db and TM.db.global then TM.db.global.window = nil end
        RestorePos()
    end)
end

-- ============================================================
--  Build the window
-- ============================================================

local function Build()
    UI:RefreshFonts()

    win = UI:CreatePanel(UIParent, "TomoMod_MailWindow", W, H)
    win:SetFrameStrata("HIGH")
    win:SetToplevel(true)
    win:SetMovable(true)
    win:SetClampedToScreen(true)
    win:Hide()

    -- Title bar (drag handle)
    local titlebar = CreateFrame("Frame", nil, win)
    titlebar:SetPoint("TOPLEFT", 0, 0)
    titlebar:SetPoint("TOPRIGHT", 0, 0)
    titlebar:SetHeight(30)
    titlebar:EnableMouse(true)
    titlebar:RegisterForDrag("LeftButton")
    titlebar:SetScript("OnDragStart", function() win:StartMoving() end)
    titlebar:SetScript("OnDragStop", function() win:StopMovingOrSizing(); SavePos() end)

    local accentDot = titlebar:CreateTexture(nil, "ARTWORK")
    accentDot:SetSize(8, 8)
    accentDot:SetPoint("LEFT", 12, 0)
    accentDot:SetColorTexture(unpack(UI.COLORS.accent))

    local title = UI:FS(titlebar, "title")
    title:SetPoint("LEFT", 26, 0)
    title:SetText("|cFFFFD100Tomo|r|cFFF2EBDBMail|r")

    -- Close
    local close = CreateFrame("Button", nil, titlebar)
    close:SetSize(20, 20)
    close:SetPoint("RIGHT", -10, 0)
    close.t = UI:FS(close, "large")
    close.t:SetAllPoints()
    close.t:SetText("×")
    close.t:SetTextColor(0.620, 0.580, 0.500)
    close:SetScript("OnEnter", function(s) s.t:SetTextColor(1, 0.820, 0) end)
    close:SetScript("OnLeave", function(s) s.t:SetTextColor(0.620, 0.580, 0.500) end)
    close:SetScript("OnClick", function()
        pcall(function()
            if CloseMail then CloseMail()
            elseif HideUIPanel and MailFrame then HideUIPanel(MailFrame) end
        end)
        Window:Hide()
    end)

    -- Settings cog
    local cog = CreateFrame("Button", nil, titlebar)
    cog:SetSize(18, 18)
    cog:SetPoint("RIGHT", close, "LEFT", -6, 0)
    cog.icon = cog:CreateTexture(nil, "ARTWORK")
    cog.icon:SetAllPoints()
    cog.icon:SetTexture("Interface\\Buttons\\UI-OptionsButton")
    cog.icon:SetVertexColor(0.545, 0.420, 0.247)
    cog:SetScript("OnEnter", function(s) s.icon:SetVertexColor(unpack(UI.COLORS.accent)) end)
    cog:SetScript("OnLeave", function(s) s.icon:SetVertexColor(0.545, 0.420, 0.247) end)
    cog:SetScript("OnClick", function()
        if not settings then BuildSettings() end
        if settings:IsShown() then
            settings:Hide()
            if fontList then fontList:Hide() end
        else
            settings:Show()
        end
    end)

    -- Divider under title
    local d1 = win:CreateTexture(nil, "ARTWORK")
    d1:SetHeight(1)
    d1:SetPoint("TOPLEFT", 1, -30)
    d1:SetPoint("TOPRIGHT", -1, -30)
    d1:SetColorTexture(unpack(UI.COLORS.borderDim))

    -- Tabs
    local tabRow = CreateFrame("Frame", nil, win)
    tabRow:SetPoint("TOPLEFT", 10, -34)
    tabRow:SetPoint("TOPRIGHT", -10, -34)
    tabRow:SetHeight(28)

    local defs = {
        { key = "INBOX", label = TM:L("TAB_INBOX") or "Boîte de réception" },
        { key = "SEND",  label = TM:L("TAB_SEND")  or "Envoyer un objet" },
    }
    local tw = (W - 20) / 2
    for i, def in ipairs(defs) do
        local b = CreateTabButton(tabRow, def.label, def.key)
        b:SetSize(tw, 28)
        b:SetPoint("LEFT", (i - 1) * tw, 0)
        b:SetScript("OnClick", function(self) Window:SelectTab(self._key) end)
        tabs[i] = b
    end

    local d2 = win:CreateTexture(nil, "ARTWORK")
    d2:SetHeight(1)
    d2:SetPoint("TOPLEFT", 1, -62)
    d2:SetPoint("TOPRIGHT", -1, -62)
    d2:SetColorTexture(unpack(UI.COLORS.borderDim))

    -- Content pages
    inboxPage = CreateFrame("Frame", nil, win)
    inboxPage:SetPoint("TOPLEFT", 6, -66)
    inboxPage:SetPoint("BOTTOMRIGHT", -6, 8)

    composePage = CreateFrame("Frame", nil, win)
    composePage:SetPoint("TOPLEFT", 6, -66)
    composePage:SetPoint("BOTTOMRIGHT", -6, 8)
    composePage:Hide()

    RestorePos()
end

-- ============================================================
--  Public API
-- ============================================================

function Window:Ensure()
    if not win then
        local ok, err = pcall(Build)
        if not ok then
            TM:Print("|cFFFF4444Window: |r" .. tostring(err))
            return nil
        end
    end
    return win
end

function Window:GetInboxPage()   self:Ensure(); return inboxPage end
function Window:GetComposePage() self:Ensure(); return composePage end
function Window:GetCurrent()     return current end

function Window:SelectTab(key)
    self:Ensure()
    current = key
    for _, b in ipairs(tabs) do b:SetActive(b._key == key) end

    if key == "SEND" then
        if inboxPage then inboxPage:Hide() end
        if composePage then composePage:Show() end
        local C = TM.modules["Compose"]
        if C and C.OnSelect then C:OnSelect() end
        -- SendMailFrame is now mounted+shown; tell the engine the send
        -- interface is active so right-click-to-attach routes correctly.
        SetSendShowing(true)
    else
        if composePage then composePage:Hide() end
        if inboxPage then inboxPage:Show() end
        local I = TM.modules["Inbox"]
        if I and I.OnSelect then I:OnSelect() end
        SetSendShowing(false)
    end
    ApplyTabHeight(key)
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end

function Window:ApplyScale()
    self:Ensure()
    if not win then return end
    local s = TM.db and TM.db.profile and TM.db.profile.mailScale or 1.0
    s = tonumber(s) or 1.0
    if s < 0.6 then s = 0.6 elseif s > 1.6 then s = 1.6 end
    win:SetScale(s)
end

function Window:Show()
    self:Ensure()
    if not win then return end
    HideNativeChrome()
    self:ApplyScale()
    RestorePos()
    win:Show()
    self:SelectTab("INBOX")
end

function Window:Hide()
    -- Leaving the mail UI: drop the engine send-showing flag so a later
    -- right-click outside the mailbox isn't misrouted as an attach.
    SetSendShowing(false)
    if settings then settings:Hide() end
    if fontList then fontList:Hide() end
    if win then win:Hide() end
end

-- ============================================================
--  Re-assert invisibility when Blizzard touches the frame
-- ============================================================

local ef = CreateFrame("Frame")
ef:RegisterEvent("MAIL_SHOW")
ef:RegisterEvent("MAIL_INBOX_UPDATE")
ef:RegisterEvent("MAIL_SEND_SUCCESS")
ef:SetScript("OnEvent", function(_, event)
    if not ModernEnabled() then return end
    if win and win:IsShown() then
        HideNativeChrome()
        if event == "MAIL_SEND_SUCCESS" and current == "SEND" and SendMailFrame then
            pcall(function() SendMailFrame:Show() end)
            -- Native reset re-shows the frame; re-assert the flag so the next
            -- item can still be attached by right-click without a tab bounce.
            SetSendShowing(true)
        end
    end
end)

-- ============================================================
--  Module hooks
-- ============================================================

function Window:OnInitialize() end

function Window:OnMailShow()
    if not ModernEnabled() then return end
    self:Show()
end

function Window:OnMailHide()
    self:Hide()
end

-- ============================================================
--  GUI V2 override
--  Replaces only the window chrome/builder. Inbox, Compose and
--  mail-engine behavior above remain untouched.
-- ============================================================

local V2 = UI and UI.V2

local function V2WindowVersionText()
    local version
    pcall(function()
        if C_AddOns and C_AddOns.GetAddOnMetadata then
            version = C_AddOns.GetAddOnMetadata("TomoModForever", "Version")
        elseif GetAddOnMetadata then
            version = GetAddOnMetadata("TomoModForever", "Version")
        end
    end)
    return version and ("v" .. tostring(version)) or ""
end

local function CreateV2TabButton(parent, label, key)
    local b = CreateFrame("Button", nil, parent)
    b._key = key

    b.label = UI:FS(b, "normal")
    b.label:SetPoint("CENTER", 0, 2)
    b.label:SetText(label)
    b.label:SetTextColor(unpack(UI.COLORS.textDim))

    b.underline = V2:Solid(b, "ARTWORK")
    b.underline:SetHeight(2)
    b.underline:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", 10, 0)
    b.underline:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -10, 0)
    b.underline:SetVertexColor(unpack(UI.COLORS.accent))
    b.underline:Hide()

    function b:SetActive(active)
        self._active = active and true or false
        if self._active then
            self.label:SetTextColor(unpack(UI.COLORS.accent))
            self.underline:Show()
        else
            self.label:SetTextColor(unpack(UI.COLORS.textDim))
            self.underline:Hide()
        end
    end

    b:SetScript("OnEnter", function(self)
        if not self._active then
            self.label:SetTextColor(unpack(UI.COLORS.text))
        end
    end)
    b:SetScript("OnLeave", function(self)
        if not self._active then
            self.label:SetTextColor(unpack(UI.COLORS.textDim))
        end
    end)

    return b
end

if V2 then
    W, H = 468, 650

    ApplyTabHeight = function(key)
        if not win then return end
        if key == "SEND" then
            C_Timer.After(0.05, function()
                if not win then return end

                local newH = 556
                pcall(function()
                    local fh = SendMailFrame and SendMailFrame:GetHeight()
                    if fh and fh > 120 then
                        newH = 84 + 8 + fh + 12
                    end
                end)

                if newH < 380 then
                    newH = 380
                elseif newH > 840 then
                    newH = 840
                end
                win:SetHeight(newH)
            end)
        else
            win:SetHeight(H)
        end
    end

    Build = function()
        UI:RefreshFonts()

        win = V2:CreatePanel(UIParent, "TomoMod_MailWindow", W, H)
        win:SetFrameStrata("HIGH")
        win:SetToplevel(true)
        win:SetMovable(true)
        win:SetClampedToScreen(true)
        win:Hide()

        local header = V2:CreateHeader(win, "Mail", V2WindowVersionText(), 42)
        header:EnableMouse(true)
        header:RegisterForDrag("LeftButton")
        header:SetScript("OnDragStart", function()
            win:StartMoving()
        end)
        header:SetScript("OnDragStop", function()
            win:StopMovingOrSizing()
            SavePos()
        end)
        if header.title then UI:ApplyFontTo(header.title) end

        local close = V2:CreateCloseButton(header, function()
            pcall(function()
                if CloseMail then
                    CloseMail()
                elseif HideUIPanel and MailFrame then
                    HideUIPanel(MailFrame)
                end
            end)
            Window:Hide()
        end)
        close:SetPoint("RIGHT", header, "RIGHT", -10, 0)

        local cog = V2:CreateIconButton(
            header,
            "Interface\\Buttons\\UI-OptionsButton",
            24,
            TM:L("SETTINGS") or "Settings"
        )
        cog:SetPoint("RIGHT", close, "LEFT", -6, 0)
        cog:SetScript("OnClick", function()
            if TomoMod_MailConfig and TomoMod_MailConfig.Toggle then
                TomoMod_MailConfig:Toggle(win)
            end
        end)

        local tabRow = CreateFrame("Frame", nil, win)
        tabRow:SetPoint("TOPLEFT", win, "TOPLEFT", 10, -46)
        tabRow:SetPoint("TOPRIGHT", win, "TOPRIGHT", -10, -46)
        tabRow:SetHeight(30)

        local defs = {
            { key = "INBOX", label = TM:L("TAB_INBOX") or "Inbox" },
            { key = "SEND",  label = TM:L("TAB_SEND")  or "Send Mail" },
        }

        wipe(tabs)
        local tabWidth = (W - 20) / #defs
        for i, def in ipairs(defs) do
            local tab = CreateV2TabButton(tabRow, def.label, def.key)
            tab:SetSize(tabWidth, 30)
            tab:SetPoint("LEFT", tabRow, "LEFT", (i - 1) * tabWidth, 0)
            tab:SetScript("OnClick", function(self)
                Window:SelectTab(self._key)
            end)
            tabs[i] = tab
        end

        local navDivider = V2:CreateDivider(win)
        navDivider:SetPoint("TOPLEFT", win, "TOPLEFT", 1, -80)
        navDivider:SetPoint("TOPRIGHT", win, "TOPRIGHT", -1, -80)

        inboxPage = CreateFrame("Frame", nil, win)
        inboxPage:SetPoint("TOPLEFT", win, "TOPLEFT", 8, -84)
        inboxPage:SetPoint("BOTTOMRIGHT", win, "BOTTOMRIGHT", -8, 8)

        composePage = CreateFrame("Frame", nil, win)
        composePage:SetPoint("TOPLEFT", win, "TOPLEFT", 8, -84)
        composePage:SetPoint("BOTTOMRIGHT", win, "BOTTOMRIGHT", -8, 8)
        composePage:Hide()

        RestorePos()
    end
end

function Window:GetFrame()
    self:Ensure()
    return win
end

function Window:ResetPosition()
    if TM.db and TM.db.global then
        TM.db.global.window = nil
    end
    RestorePos()
end

function Window:Hide()
    SetSendShowing(false)

    if TomoMod_MailConfig and TomoMod_MailConfig.Close then
        TomoMod_MailConfig:Close()
    end

    if settings then settings:Hide() end
    if fontList then fontList:Hide() end

    if win then win:Hide() end
end
