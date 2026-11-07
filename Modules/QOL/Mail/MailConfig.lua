-- TomoMod_Mail | Config.lua
-- Modern configuration panel with toggle switches

TomoMod_MailConfig = {}
local Config = TomoMod_MailConfig
local TM     = TomoMod_Mail

-- ============================================================
--  Panel state
-- ============================================================

local panel    = nil
local toggles  = {}  -- references to refresh on show

-- ============================================================
--  Helper: config row with label + optional subtitle
-- ============================================================

local function CreateConfigRow(parent, label, subtitle, yOffset, getter, setter, indent)
    local UI = TM.UI
    indent = indent or 0

    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(parent:GetWidth() - 32, 28)
    row:SetPoint("TOPLEFT", parent, "TOPLEFT", 16 + indent, yOffset)

    local lbl = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbl:SetPoint("LEFT", row, "LEFT", 0, subtitle and 4 or 0)
    lbl:SetText(label)
    lbl:SetTextColor(0.949, 0.922, 0.859)

    if subtitle then
        local sub = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        sub:SetPoint("TOPLEFT", lbl, "BOTTOMLEFT", 0, -1)
        sub:SetText(subtitle)
        sub:SetTextColor(0.450, 0.420, 0.360)
        row:SetHeight(36)
    end

    local toggle = UI:CreateToggle(row, getter, setter)
    toggle:SetPoint("RIGHT", row, "RIGHT", 0, 0)

    table.insert(toggles, toggle)
    return row
end

-- ============================================================
--  Helper: styled slider
-- ============================================================

local function CreateConfigSlider(parent, label, min, max, step, yOffset, getter, setter)
    local UI = TM.UI
    local container = CreateFrame("Frame", nil, parent)
    container:SetSize(parent:GetWidth() - 32, 44)
    container:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, yOffset)

    local lbl = container:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbl:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
    lbl:SetText(label)
    lbl:SetTextColor(0.949, 0.922, 0.859)

    local valText = container:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    valText:SetPoint("TOPRIGHT", container, "TOPRIGHT", 0, 0)
    valText:SetTextColor(unpack(UI.COLORS.accent))

    local sliderName = "TomoMod_MailCfgSlider_" .. label:gsub("%s", "_"):gsub("[^%w_]", "")
    local slider = CreateFrame("Slider", sliderName, container, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", container, "TOPLEFT", 0, -18)
    slider:SetWidth(container:GetWidth())
    slider:SetMinMaxValues(min, max)
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)

    -- Hide default low/high labels
    if slider.Low  then slider.Low:SetText("")  end
    if slider.High then slider.High:SetText("") end

    -- Try to style the thumb/track if accessible
    pcall(function()
        local thumb = slider:GetThumbTexture()
        if thumb then
            thumb:SetSize(14, 14)
            thumb:SetColorTexture(unpack(UI.COLORS.accent))
        end
    end)

    function container:Refresh()
        local v = getter()
        slider:SetValue(v)
        valText:SetText(tostring(v))
    end

    slider:SetScript("OnValueChanged", function(self, val)
        val = math.floor(val + 0.5)
        valText:SetText(tostring(val))
        setter(val)
    end)

    table.insert(toggles, container)  -- reuse refresh list
    return container
end

-- ============================================================
--  Build panel
-- ============================================================

local PANEL_WIDTH  = 320
local PANEL_HEIGHT = 510

local function BuildPanel()
    local UI = TM.UI

    panel = UI:CreatePanel(UIParent, "TomoMod_MailConfigPanel", PANEL_WIDTH, PANEL_HEIGHT)
    panel:SetPoint("CENTER")
    panel:SetMovable(true)
    panel:RegisterForDrag("LeftButton")
    panel:SetScript("OnDragStart", panel.StartMoving)
    panel:SetScript("OnDragStop", panel.StopMovingOrSizing)
    panel:Hide()

    tinsert(UISpecialFrames, "TomoMod_MailConfigPanel")

    -- ---- Header ----
    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -12)
    title:SetText("|cFFFFD100Tomo|r|cFFF2EBDBMail|r |cFF736B5C— " .. TM:L("SETTINGS") .. "|r")

    local closeBtn = CreateFrame("Button", nil, panel)
    closeBtn:SetSize(16, 16)
    closeBtn:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -8, -10)
    local closeTxt = closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    closeTxt:SetAllPoints()
    closeTxt:SetText("|cFF736B5C×|r")
    closeBtn:SetScript("OnClick", function() panel:Hide() end)
    closeBtn:SetScript("OnEnter", function() closeTxt:SetText("|cFFFFD100×|r") end)
    closeBtn:SetScript("OnLeave", function() closeTxt:SetText("|cFF736B5C×|r") end)

    -- ---- Divider ----
    local div1 = panel:CreateTexture(nil, "ARTWORK")
    div1:SetSize(PANEL_WIDTH - 2, 1)
    div1:SetPoint("TOPLEFT", panel, "TOPLEFT", 1, -32)
    div1:SetColorTexture(unpack(UI.COLORS.borderDim))

    -- ---- Section: Display ----
    local secDisplay = UI:CreateSectionTitle(panel, TM:L("CFG_SECTION_DISPLAY") or "AFFICHAGE")
    secDisplay:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, -42)

    local db = TM.db.profile
    local y = -58

    CreateConfigRow(panel,
        TM:L("CFG_SHOW_ALTS"), TM:L("CFG_SHOW_ALTS_SUB") or nil, y,
        function() return db.showAlts end,
        function(v) db.showAlts = v end)
    y = y - 36

    CreateConfigRow(panel,
        TM:L("CFG_SHOW_GUILD"), TM:L("CFG_SHOW_GUILD_SUB") or nil, y,
        function() return db.showGuild end,
        function(v) db.showGuild = v end)
    y = y - 36

    CreateConfigRow(panel,
        TM:L("CFG_GUILD_ONLINE"), nil, y,
        function() return db.guildOnlineOnly end,
        function(v) db.guildOnlineOnly = v end,
        16)  -- indented
    y = y - 30

    CreateConfigRow(panel,
        TM:L("CFG_SHOW_RECENT"), nil, y,
        function() return db.showRecent end,
        function(v) db.showRecent = v end)
    y = y - 36

    -- ---- Divider ----
    local div2 = panel:CreateTexture(nil, "ARTWORK")
    div2:SetSize(PANEL_WIDTH - 32, 1)
    div2:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, y)
    div2:SetColorTexture(unpack(UI.COLORS.borderDim))
    y = y - 12

    -- ---- Slider: max recent ----
    CreateConfigSlider(panel,
        TM:L("CFG_MAX_RECENT"), 5, 25, 1, y,
        function() return db.maxRecent end,
        function(v)
            db.maxRecent = v
            while #db.recent > v do
                table.remove(db.recent)
            end
        end)
    y = y - 52

    -- ---- Divider ----
    local div3 = panel:CreateTexture(nil, "ARTWORK")
    div3:SetSize(PANEL_WIDTH - 2, 1)
    div3:SetPoint("TOPLEFT", panel, "TOPLEFT", 1, y)
    div3:SetColorTexture(unpack(UI.COLORS.borderDim))
    y = y - 12

    -- ---- Section: Behavior ----
    local secBehav = UI:CreateSectionTitle(panel, TM:L("CFG_SECTION_BEHAVIOR") or "COMPORTEMENT")
    secBehav:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, y)
    y = y - 18

    CreateConfigRow(panel,
        TM:L("CFG_AUTOCOMPLETE"), TM:L("CFG_AUTOCOMPLETE_SUB") or nil, y,
        function() return db.useAutocomplete end,
        function(v)
            db.useAutocomplete = v
            if v then
                local qs = TM.modules["QuickSend"]
                if qs then qs:EnableAutocomplete() end
            end
        end)
    y = y - 44

    -- ---- Divider ----
    local div4 = panel:CreateTexture(nil, "ARTWORK")
    div4:SetSize(PANEL_WIDTH - 2, 1)
    div4:SetPoint("TOPLEFT", panel, "TOPLEFT", 1, y)
    div4:SetColorTexture(unpack(UI.COLORS.borderDim))
    y = y - 12

    -- ---- Section: Appearance ----
    local secAppear = UI:CreateSectionTitle(panel, TM:L("CFG_SECTION_APPEARANCE") or "APPARENCE")
    secAppear:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, y)
    y = y - 18

    CreateConfigRow(panel,
        TM:L("CFG_SKIN_ENABLED"), TM:L("CFG_SKIN_ENABLED_SUB") or nil, y,
        function() return db.skinEnabled end,
        function(v)
            db.skinEnabled = v
            TM:Print(TM:L("CFG_SKIN_RELOAD") or "Rechargement nécessaire pour appliquer.")
        end)
    y = y - 38

    -- Scale slider (0.8 to 1.5, step 0.05)
    -- Custom slider with decimal display
    local scaleContainer = CreateFrame("Frame", nil, panel)
    scaleContainer:SetSize(PANEL_WIDTH - 32, 44)
    scaleContainer:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, y)

    local scaleLbl = scaleContainer:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    scaleLbl:SetPoint("TOPLEFT", scaleContainer, "TOPLEFT", 0, 0)
    scaleLbl:SetText(TM:L("CFG_MAIL_SCALE") or "Echelle de l'interface")
    scaleLbl:SetTextColor(0.949, 0.922, 0.859)

    local scaleValText = scaleContainer:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    scaleValText:SetPoint("TOPRIGHT", scaleContainer, "TOPRIGHT", 0, 0)
    scaleValText:SetTextColor(unpack(UI.COLORS.accent))

    local scaleSliderName = "TomoMod_MailCfgSlider_Scale"
    local scaleSlider = CreateFrame("Slider", scaleSliderName, scaleContainer, "OptionsSliderTemplate")
    scaleSlider:SetPoint("TOPLEFT", scaleContainer, "TOPLEFT", 0, -18)
    scaleSlider:SetWidth(scaleContainer:GetWidth())
    scaleSlider:SetMinMaxValues(80, 150)
    scaleSlider:SetValueStep(5)
    scaleSlider:SetObeyStepOnDrag(true)

    if scaleSlider.Low  then scaleSlider.Low:SetText("")  end
    if scaleSlider.High then scaleSlider.High:SetText("") end

    pcall(function()
        local thumb = scaleSlider:GetThumbTexture()
        if thumb then
            thumb:SetSize(14, 14)
            thumb:SetColorTexture(unpack(UI.COLORS.accent))
        end
    end)

    function scaleContainer:Refresh()
        local v = math.floor((db.mailScale or 1.0) * 100 + 0.5)
        scaleSlider:SetValue(v)
        scaleValText:SetText(string.format("%d%%", v))
    end

    scaleSlider:SetScript("OnValueChanged", function(self, val)
        val = math.floor(val / 5 + 0.5) * 5  -- snap to 5%
        local scale = val / 100
        scaleValText:SetText(string.format("%d%%", val))
        db.mailScale = scale
        local skinMod = TM.modules["Skin"]
        if skinMod and skinMod.UpdateScale then
            skinMod:UpdateScale(scale)
        end
        if TM.Window and TM.Window.ApplyScale then
            TM.Window:ApplyScale()
        end
    end)

    table.insert(toggles, scaleContainer)

    -- ---- Action buttons ----
    local div4 = panel:CreateTexture(nil, "ARTWORK")
    div4:SetSize(PANEL_WIDTH - 2, 1)
    div4:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 1, 42)
    div4:SetColorTexture(unpack(UI.COLORS.borderDim))

    local btnWidth = (PANEL_WIDTH - 40 - 8) / 3

    local clearRecentBtn = UI:CreateStyledButton(panel, TM:L("CFG_CLEAR_RECENT") or "Récents", btnWidth, 28, "dangerBg")
    clearRecentBtn:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 12, 10)
    clearRecentBtn:SetScript("OnClick", function()
        TM.db.profile.recent = {}
        TM:Print(TM:L("CFG_RECENT_CLEARED") or "Historique des récents effacé.")
    end)

    local clearAltsBtn = UI:CreateStyledButton(panel, TM:L("CFG_CLEAR_ALTS") or "Alts", btnWidth, 28, "dangerBg")
    clearAltsBtn:SetPoint("LEFT", clearRecentBtn, "RIGHT", 4, 0)
    clearAltsBtn:SetScript("OnClick", function()
        TM.db.global.alts = {}
        TM:RegisterCurrentChar()
        TM:Print(TM:L("CFG_ALTS_CLEARED") or "Liste des alts effacée.")
    end)

    local closeActionBtn = UI:CreateStyledButton(panel, TM:L("CLOSE") or "Fermer", btnWidth, 28, "bgLight")
    closeActionBtn:SetPoint("LEFT", clearAltsBtn, "RIGHT", 4, 0)
    closeActionBtn:SetScript("OnClick", function() panel:Hide() end)
end

-- ============================================================
--  Public API
-- ============================================================

function Config:Toggle()
    if not panel then
        BuildPanel()
    end

    if panel:IsShown() then
        panel:Hide()
    else
        -- Refresh all toggles/sliders
        for _, widget in ipairs(toggles) do
            if widget.Refresh then
                widget:Refresh()
            end
        end
        panel:Show()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
    end
end

-- ============================================================
--  GUI V2 override
--  Requires Patch 1 (TM.UI.V2). The legacy builder above stays
--  intact as a fallback/reference, but Config:Toggle now routes
--  exclusively through this unified side-panel implementation.
-- ============================================================

local V2 = TM.UI and TM.UI.V2
local v2FontList
local v2Anchor
local v2Refreshables = {}
local v2FontButton

local function V2VersionText()
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

local function V2AddRefreshable(widget)
    if widget and widget.Refresh then
        v2Refreshables[#v2Refreshables + 1] = widget
    end
    return widget
end

local function V2RefreshAll()
    for _, widget in ipairs(v2Refreshables) do
        if widget and widget.Refresh then
            widget:Refresh()
        end
    end
    if v2FontButton and v2FontButton.Text then
        v2FontButton.Text:SetText(TM.UI:GetFontName())
    end
end

local function V2HideFontList()
    if v2FontList then v2FontList:Hide() end
end

local function V2BuildFontList(button)
    if v2FontList then
        v2FontList:ClearAllPoints()
        v2FontList:SetPoint("TOPRIGHT", button, "BOTTOMRIGHT", 0, -4)
        return v2FontList
    end

    local UI = TM.UI
    local fonts = UI:GetFontList()
    local rowH = 24
    local visibleRows = math.min(#fonts, 9)
    local listH = math.max(36, visibleRows * rowH + 8)

    v2FontList = V2:CreatePanel(panel, "TomoMod_MailConfigFontListV2", 224, listH)
    v2FontList:SetFrameStrata("TOOLTIP")
    v2FontList:SetFrameLevel(panel:GetFrameLevel() + 50)
    v2FontList:SetPoint("TOPRIGHT", button, "BOTTOMRIGHT", 0, -4)
    v2FontList:Hide()

    local scroll = CreateFrame("ScrollFrame", nil, v2FontList)
    scroll:SetPoint("TOPLEFT", 4, -4)
    scroll:SetPoint("BOTTOMRIGHT", -4, 4)
    scroll:EnableMouseWheel(true)

    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(210, math.max(1, #fonts * rowH))
    scroll:SetScrollChild(child)

    for i, entry in ipairs(fonts) do
        local row = CreateFrame("Button", nil, child)
        row:SetHeight(rowH)
        row:SetPoint("TOPLEFT", child, "TOPLEFT", 0, -(i - 1) * rowH)
        row:SetPoint("TOPRIGHT", child, "TOPRIGHT", 0, -(i - 1) * rowH)

        local hl = row:CreateTexture(nil, "HIGHLIGHT")
        hl:SetAllPoints()
        hl:SetTexture("Interface\\Buttons\\WHITE8X8")
        hl:SetVertexColor(
            UI.COLORS.accent[1],
            UI.COLORS.accent[2],
            UI.COLORS.accent[3],
            0.12
        )

        local fs = row:CreateFontString(nil, "OVERLAY")
        pcall(function() fs:SetFont(entry.path, 13, "") end)
        if not fs:GetFont() and UI._fontObjects and UI._fontObjects.small then
            fs:SetFontObject(UI._fontObjects.small)
        end
        fs:SetPoint("LEFT", row, "LEFT", 8, 0)
        fs:SetPoint("RIGHT", row, "RIGHT", -8, 0)
        fs:SetJustifyH("LEFT")
        fs:SetText(entry.name)
        fs:SetTextColor(unpack(UI.COLORS.text))

        row:SetScript("OnClick", function()
            TM.db.profile.font = entry.path
            UI:RefreshFonts()
            if v2FontButton and v2FontButton.Text then
                v2FontButton.Text:SetText(UI:GetFontName())
            end
            V2HideFontList()
            if SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON then
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            end
        end)
    end

    scroll:SetScript("OnMouseWheel", function(self, delta)
        local maxScroll = math.max(child:GetHeight() - self:GetHeight(), 0)
        local value = self:GetVerticalScroll() - delta * rowH * 2
        self:SetVerticalScroll(math.max(0, math.min(value, maxScroll)))
    end)

    return v2FontList
end

local function V2PositionPanel(anchor)
    if not panel then return end
    v2Anchor = anchor

    panel:ClearAllPoints()
    panel:SetScale(1)

    if anchor and anchor.IsShown and anchor:IsShown() then
        panel:SetScale((anchor.GetScale and anchor:GetScale()) or 1)
        panel:SetPoint("TOPLEFT", anchor, "TOPRIGHT", 8, 0)
    else
        v2Anchor = nil
        panel:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end
end

local function BuildPanelV2()
    if not V2 then
        TM:Print("|cFFFF5555" .. (TM:L("CFG_V2_MISSING") or "GUI V2 core missing: UIHelpers.lua is out of date.") .. "|r")
        return nil
    end

    local UI = TM.UI
    local db = TM.db.profile
    local PANEL_W, PANEL_H = 386, 620
    local CONTENT_W = 338

    panel = V2:CreatePanel(UIParent, "TomoMod_MailConfigPanelV2", PANEL_W, PANEL_H)
    panel:SetMovable(true)
    panel:Hide()

    tinsert(UISpecialFrames, "TomoMod_MailConfigPanelV2")

    local header = V2:CreateHeader(panel, "Mail", V2VersionText(), 42)
    header:EnableMouse(true)
    header:RegisterForDrag("LeftButton")
    header:SetScript("OnDragStart", function()
        if not v2Anchor then panel:StartMoving() end
    end)
    header:SetScript("OnDragStop", function()
        if not v2Anchor then panel:StopMovingOrSizing() end
    end)

    local settingsLabel = header:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    settingsLabel:SetPoint("LEFT", header.version, "RIGHT", 8, 0)
    settingsLabel:SetText("— " .. (TM:L("SETTINGS") or "Settings"))
    settingsLabel:SetTextColor(unpack(UI.COLORS.textMuted))

    local close = V2:CreateCloseButton(header, function()
        Config:Close()
    end)
    close:SetPoint("RIGHT", header, "RIGHT", -10, 0)

    local scroll = CreateFrame("ScrollFrame", "TomoMod_MailConfigV2Scroll", panel, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, -54)
    scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -26, 14)

    local child = CreateFrame("Frame", "TomoMod_MailConfigV2ScrollChild", scroll)
    child:SetSize(CONTENT_W, 824)
    scroll:SetScrollChild(child)

    local scrollBar = scroll.ScrollBar or _G["TomoMod_MailConfigV2ScrollScrollBar"]
    if scrollBar then V2:SkinScrollBar(scrollBar) end

    -- DISPLAY -------------------------------------------------
    local displayCard = V2:CreateCard(child, CONTENT_W, 268)
    displayCard:SetPoint("TOPLEFT", child, "TOPLEFT", 0, 0)

    local displayTitle = V2:CreateSectionTitle(
        displayCard,
        TM:L("CFG_SECTION_DISPLAY") or "DISPLAY"
    )
    displayTitle:SetPoint("TOPLEFT", displayCard, "TOPLEFT", 12, -12)
    displayTitle:SetPoint("RIGHT", displayCard, "RIGHT", -12, 0)

    local rowAlts = V2AddRefreshable(V2:CreateSettingRow(
        displayCard, CONTENT_W - 24,
        TM:L("CFG_SHOW_ALTS"),
        TM:L("CFG_SHOW_ALTS_SUB"),
        function() return db.showAlts end,
        function(v) db.showAlts = v end
    ))
    rowAlts:SetPoint("TOPLEFT", displayCard, "TOPLEFT", 12, -38)

    local rowGuild = V2AddRefreshable(V2:CreateSettingRow(
        displayCard, CONTENT_W - 24,
        TM:L("CFG_SHOW_GUILD"),
        TM:L("CFG_SHOW_GUILD_SUB"),
        function() return db.showGuild end,
        function(v) db.showGuild = v end
    ))
    rowGuild:SetPoint("TOPLEFT", displayCard, "TOPLEFT", 12, -84)

    local rowOnline = V2AddRefreshable(V2:CreateSettingRow(
        displayCard, CONTENT_W - 40,
        TM:L("CFG_GUILD_ONLINE"),
        nil,
        function() return db.guildOnlineOnly end,
        function(v) db.guildOnlineOnly = v end
    ))
    rowOnline:SetPoint("TOPLEFT", displayCard, "TOPLEFT", 28, -130)

    local rowRecent = V2AddRefreshable(V2:CreateSettingRow(
        displayCard, CONTENT_W - 24,
        TM:L("CFG_SHOW_RECENT"),
        nil,
        function() return db.showRecent end,
        function(v) db.showRecent = v end
    ))
    rowRecent:SetPoint("TOPLEFT", displayCard, "TOPLEFT", 12, -168)

    local maxRecent = V2AddRefreshable(V2:CreateSlider(
        displayCard, CONTENT_W - 24,
        TM:L("CFG_MAX_RECENT"),
        5, 25, 1,
        function() return db.maxRecent or 10 end,
        function(v)
            db.maxRecent = math.floor(v + 0.5)
            while #db.recent > db.maxRecent do
                table.remove(db.recent)
            end
        end,
        function(v) return tostring(math.floor(v + 0.5)) end
    ))
    maxRecent:SetPoint("TOPLEFT", displayCard, "TOPLEFT", 12, -212)

    -- BEHAVIOR ------------------------------------------------
    local behaviorCard = V2:CreateCard(child, CONTENT_W, 98)
    behaviorCard:SetPoint("TOPLEFT", displayCard, "BOTTOMLEFT", 0, -12)

    local behaviorTitle = V2:CreateSectionTitle(
        behaviorCard,
        TM:L("CFG_SECTION_BEHAVIOR") or "BEHAVIOR"
    )
    behaviorTitle:SetPoint("TOPLEFT", behaviorCard, "TOPLEFT", 12, -12)
    behaviorTitle:SetPoint("RIGHT", behaviorCard, "RIGHT", -12, 0)

    local autocomplete = V2AddRefreshable(V2:CreateSettingRow(
        behaviorCard, CONTENT_W - 24,
        TM:L("CFG_AUTOCOMPLETE"),
        TM:L("CFG_AUTOCOMPLETE_SUB"),
        function() return db.useAutocomplete end,
        function(v)
            db.useAutocomplete = v
            if v then
                local qs = TM.modules["QuickSend"]
                if qs and qs.EnableAutocomplete then qs:EnableAutocomplete() end
            end
        end
    ))
    autocomplete:SetPoint("TOPLEFT", behaviorCard, "TOPLEFT", 12, -38)

    -- APPEARANCE ----------------------------------------------
    local appearanceCard = V2:CreateCard(child, CONTENT_W, 304)
    appearanceCard:SetPoint("TOPLEFT", behaviorCard, "BOTTOMLEFT", 0, -12)

    local appearanceTitle = V2:CreateSectionTitle(
        appearanceCard,
        TM:L("CFG_SECTION_APPEARANCE") or "APPEARANCE"
    )
    appearanceTitle:SetPoint("TOPLEFT", appearanceCard, "TOPLEFT", 12, -12)
    appearanceTitle:SetPoint("RIGHT", appearanceCard, "RIGHT", -12, 0)

    local skinRow = V2AddRefreshable(V2:CreateSettingRow(
        appearanceCard, CONTENT_W - 24,
        TM:L("CFG_SKIN_ENABLED"),
        TM:L("CFG_SKIN_ENABLED_SUB"),
        function() return db.skinEnabled end,
        function(v)
            db.skinEnabled = v
            TM:Print(TM:L("CFG_SKIN_RELOAD") or "Reload required (/reload).")
        end
    ))
    skinRow:SetPoint("TOPLEFT", appearanceCard, "TOPLEFT", 12, -38)

    local scaleSlider = V2AddRefreshable(V2:CreateSlider(
        appearanceCard, CONTENT_W - 24,
        TM:L("CFG_MAIL_SCALE") or "Interface scale",
        80, 150, 5,
        function()
            return math.floor((db.mailScale or 1.0) * 100 + 0.5)
        end,
        function(v)
            local scale = math.floor(v / 5 + 0.5) * 5 / 100
            db.mailScale = scale

            local skinMod = TM.modules["Skin"]
            if skinMod and skinMod.UpdateScale then
                skinMod:UpdateScale(scale)
            end
            if TM.Window and TM.Window.ApplyScale then
                TM.Window:ApplyScale()
            end
            if v2Anchor and panel then
                panel:SetScale(scale)
            end
        end,
        function(v) return string.format("%d%%", math.floor(v + 0.5)) end
    ))
    scaleSlider:SetPoint("TOPLEFT", appearanceCard, "TOPLEFT", 12, -92)

    local fontRow = CreateFrame("Frame", nil, appearanceCard)
    fontRow:SetSize(CONTENT_W - 24, 32)
    fontRow:SetPoint("TOPLEFT", appearanceCard, "TOPLEFT", 12, -150)

    local fontLabel = fontRow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fontLabel:SetPoint("LEFT", fontRow, "LEFT", 0, 0)
    fontLabel:SetText(TM:L("FONT") or "Font")
    fontLabel:SetTextColor(unpack(UI.COLORS.text))

    v2FontButton = V2:CreateButton(fontRow, UI:GetFontName(), 174, 28, "secondary")
    v2FontButton:SetPoint("RIGHT", fontRow, "RIGHT", 0, 0)
    v2FontButton:SetScript("OnClick", function(self)
        local list = V2BuildFontList(self)
        list:SetShown(not list:IsShown())
    end)

    local fontSize = V2AddRefreshable(V2:CreateSlider(
        appearanceCard, CONTENT_W - 24,
        TM:L("FONT_SIZE") or "Text size",
        80, 140, 5,
        function()
            return math.floor((db.fontSize or 1.0) * 100 + 0.5)
        end,
        function(v)
            db.fontSize = math.floor(v / 5 + 0.5) * 5 / 100
            UI:RefreshFonts()
        end,
        function(v) return string.format("%d%%", math.floor(v + 0.5)) end
    ))
    fontSize:SetPoint("TOPLEFT", appearanceCard, "TOPLEFT", 12, -192)

    local iconSize = V2AddRefreshable(V2:CreateSlider(
        appearanceCard, CONTENT_W - 24,
        TM:L("INBOX_ICON_SIZE") or "Item icon size",
        18, 36, 2,
        function() return db.inboxIconSize or 30 end,
        function(v)
            db.inboxIconSize = math.floor(v + 0.5)
            local inbox = TM.modules["Inbox"]
            if inbox and inbox.ApplyIconSize then
                inbox:ApplyIconSize()
            end
        end,
        function(v) return string.format("%d px", math.floor(v + 0.5)) end
    ))
    iconSize:SetPoint("TOPLEFT", appearanceCard, "TOPLEFT", 12, -246)

    -- MAINTENANCE ---------------------------------------------
    local maintenanceCard = V2:CreateCard(child, CONTENT_W, 118)
    maintenanceCard:SetPoint("TOPLEFT", appearanceCard, "BOTTOMLEFT", 0, -12)

    local maintenanceTitle = V2:CreateSectionTitle(
        maintenanceCard,
        TM:L("CFG_SECTION_MAINTENANCE") or "MAINTENANCE"
    )
    maintenanceTitle:SetPoint("TOPLEFT", maintenanceCard, "TOPLEFT", 12, -12)
    maintenanceTitle:SetPoint("RIGHT", maintenanceCard, "RIGHT", -12, 0)

    local reset = V2:CreateButton(
        maintenanceCard,
        TM:L("RESET_POS") or "Recenter window",
        CONTENT_W - 24, 28, "secondary"
    )
    reset:SetPoint("TOPLEFT", maintenanceCard, "TOPLEFT", 12, -38)
    reset:SetScript("OnClick", function()
        if TM.Window and TM.Window.ResetPosition then
            TM.Window:ResetPosition()
        else
            TM.db.global.window = nil
        end
    end)

    local half = math.floor((CONTENT_W - 28) / 2)
    local clearRecent = V2:CreateButton(
        maintenanceCard,
        TM:L("CFG_CLEAR_RECENT") or "Recent",
        half, 28, "danger"
    )
    clearRecent:SetPoint("BOTTOMLEFT", maintenanceCard, "BOTTOMLEFT", 12, 12)
    clearRecent:SetScript("OnClick", function()
        db.recent = {}
        TM:Print(TM:L("CFG_RECENT_CLEARED") or "Recent history cleared.")
    end)

    local clearAlts = V2:CreateButton(
        maintenanceCard,
        TM:L("CFG_CLEAR_ALTS") or "Alts",
        half, 28, "danger"
    )
    clearAlts:SetPoint("BOTTOMRIGHT", maintenanceCard, "BOTTOMRIGHT", -12, 12)
    clearAlts:SetScript("OnClick", function()
        TM.db.global.alts = {}
        TM:RegisterCurrentChar()
        TM:Print(TM:L("CFG_ALTS_CLEARED") or "Alt list cleared.")
    end)

    panel:SetScript("OnHide", function()
        V2HideFontList()
        v2Anchor = nil
        panel:SetScale(1)
    end)

    return panel
end

function Config:Refresh()
    if panel then V2RefreshAll() end
end

function Config:IsShown()
    return panel and panel:IsShown() or false
end

function Config:Open(anchor)
    if not panel then
        if not BuildPanelV2() then return end
    end

    V2PositionPanel(anchor)
    V2RefreshAll()
    panel:Show()

    if SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPEN then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
    end
end

function Config:Close()
    V2HideFontList()
    if panel then panel:Hide() end
end

function Config:Toggle(anchor)
    if panel and panel:IsShown() then
        self:Close()
    else
        self:Open(anchor)
    end
end
