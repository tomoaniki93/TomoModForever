-- TomoMod_Mail | UIHelpers.lua
-- Shared UI factory for modern dark-themed components

local TM = TomoMod_Mail

-- ============================================================
--  Theme constants
-- ============================================================

TM.UI = {}
local UI = TM.UI

UI.COLORS = {
    -- WoW: Forever palette (TomoModForever)
    accent     = { 0.788, 0.635, 0.322 },     -- antique gold  #C9A252
    accentDim  = { 0.545, 0.420, 0.247 },     -- aged bronze   #8B6B3F
    bg         = { 0.055, 0.047, 0.036 },     -- warm black    #0E0C09
    bgLight    = { 0.094, 0.078, 0.059 },     -- #18140F
    bgHover    = { 0.141, 0.114, 0.078 },     -- #241D14
    border     = { 0.306, 0.239, 0.149 },     -- dark bronze   #4E3D26
    borderDim  = { 0.196, 0.157, 0.102 },     -- #32281A
    text       = { 0.949, 0.922, 0.859 },     -- off-white     #F2EBDB
    textDim    = { 0.620, 0.580, 0.500 },     -- #9E9480
    textMuted  = { 0.450, 0.420, 0.360 },     -- #736B5C
    white      = { 1.0, 1.0, 1.0 },
    online     = { 0.180, 0.847, 0.518 },     -- #2ED884
    danger     = { 1.0, 0.47, 0.40 },         -- #FF7866
    dangerBg   = { 0.180, 0.078, 0.059 },     -- #2E140F
}

UI.BACKDROP = {
    bgFile   = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
}

-- ============================================================
--  CreatePanel — base dark panel with rounded feel
-- ============================================================

function UI:CreatePanel(parent, name, width, height)
    local f = CreateFrame("Frame", name, parent or UIParent, "BackdropTemplate")
    f:SetSize(width, height)
    f:SetBackdrop(UI.BACKDROP)
    f:SetBackdropColor(unpack(UI.COLORS.bg))
    f:SetBackdropBorderColor(unpack(UI.COLORS.border))
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(true)
    return f
end

-- ============================================================
--  CreateTab — a tab button for the flyout
-- ============================================================

function UI:CreateTab(parent, text, index, totalTabs)
    local tabWidth = parent:GetWidth() / totalTabs
    local tab = CreateFrame("Button", nil, parent)
    tab:SetSize(tabWidth, 30)

    tab.label = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    tab.label:SetPoint("CENTER", 0, 0)
    tab.label:SetText(text)
    tab.label:SetTextColor(unpack(UI.COLORS.textDim))

    tab.underline = tab:CreateTexture(nil, "OVERLAY")
    tab.underline:SetHeight(2)
    tab.underline:SetPoint("BOTTOMLEFT", tab, "BOTTOMLEFT", 0, 0)
    tab.underline:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 0, 0)
    tab.underline:SetColorTexture(unpack(UI.COLORS.accent))
    tab.underline:Hide()

    tab.count = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    tab.count:SetPoint("LEFT", tab.label, "RIGHT", 3, 0)
    tab.count:SetTextColor(unpack(UI.COLORS.textMuted))

    function tab:SetActive(active)
        if active then
            tab.label:SetTextColor(unpack(UI.COLORS.accent))
            tab.count:SetTextColor(unpack(UI.COLORS.accentDim))
            tab.underline:Show()
        else
            tab.label:SetTextColor(unpack(UI.COLORS.textDim))
            tab.count:SetTextColor(unpack(UI.COLORS.textMuted))
            tab.underline:Hide()
        end
    end

    function tab:SetCount(n)
        tab.count:SetText(n and ("(" .. n .. ")") or "")
    end

    tab:SetScript("OnEnter", function(self)
        if not self._active then
            self.label:SetTextColor(0.788, 0.635, 0.322)
        end
    end)
    tab:SetScript("OnLeave", function(self)
        if not self._active then
            self.label:SetTextColor(unpack(UI.COLORS.textDim))
        end
    end)

    return tab
end

-- ============================================================
--  CreateSearchBox — dark themed search input
-- ============================================================

function UI:CreateSearchBox(parent, width)
    local container = CreateFrame("Frame", nil, parent)
    container:SetSize(width, 32)

    local bg = container:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(unpack(UI.COLORS.bgLight))

    local border = CreateFrame("Frame", nil, container, "BackdropTemplate")
    border:SetAllPoints()
    border:SetBackdrop(UI.BACKDROP)
    border:SetBackdropColor(0, 0, 0, 0)
    border:SetBackdropBorderColor(unpack(UI.COLORS.border))

    local icon = container:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    icon:SetPoint("LEFT", container, "LEFT", 8, 0)
    icon:SetText("|cFF736B5CQ|r")

    local editbox = CreateFrame("EditBox", nil, container)
    editbox:SetPoint("LEFT", container, "LEFT", 28, 0)
    editbox:SetPoint("RIGHT", container, "RIGHT", -8, 0)
    editbox:SetHeight(20)
    editbox:SetAutoFocus(false)
    editbox:SetFontObject(GameFontNormalSmall)
    editbox:SetTextColor(0.949, 0.922, 0.859)
    editbox:SetMaxLetters(50)

    editbox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    container.editbox = editbox
    return container
end

-- ============================================================
--  CreateToggle — modern on/off toggle switch
-- ============================================================

function UI:CreateToggle(parent, getter, setter)
    local toggle = CreateFrame("Button", nil, parent)
    toggle:SetSize(36, 20)

    toggle.bg = toggle:CreateTexture(nil, "BACKGROUND")
    toggle.bg:SetAllPoints()
    toggle.bg:SetColorTexture(0, 0, 0, 0)

    -- Track background
    toggle.track = toggle:CreateTexture(nil, "ARTWORK")
    toggle.track:SetSize(36, 20)
    toggle.track:SetPoint("CENTER")
    toggle.track:SetColorTexture(unpack(UI.COLORS.border))

    -- Rounded overlay via atlas if available, fallback to flat
    toggle.knob = toggle:CreateTexture(nil, "OVERLAY")
    toggle.knob:SetSize(16, 16)
    toggle.knob:SetColorTexture(1, 1, 1, 1)

    function toggle:Refresh()
        local on = getter()
        if on then
            toggle.track:SetColorTexture(unpack(UI.COLORS.accent))
            toggle.knob:ClearAllPoints()
            toggle.knob:SetPoint("RIGHT", toggle, "RIGHT", -2, 0)
        else
            toggle.track:SetColorTexture(unpack(UI.COLORS.border))
            toggle.knob:ClearAllPoints()
            toggle.knob:SetPoint("LEFT", toggle, "LEFT", 2, 0)
        end
    end

    toggle:SetScript("OnClick", function(self)
        local newVal = not getter()
        setter(newVal)
        self:Refresh()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    end)

    toggle:Refresh()
    return toggle
end

-- ============================================================
--  CreateStyledButton — flat dark button
-- ============================================================

function UI:CreateStyledButton(parent, text, width, height, colorKey)
    colorKey = colorKey or "bgLight"
    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(width, height)
    btn:SetBackdrop(UI.BACKDROP)

    local c = UI.COLORS[colorKey] or UI.COLORS.bgLight
    btn:SetBackdropColor(c[1], c[2], c[3], 1)
    btn:SetBackdropBorderColor(unpack(UI.COLORS.border))

    btn.label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    btn.label:SetPoint("CENTER")
    btn.label:SetText(text)

    if colorKey == "dangerBg" then
        btn.label:SetTextColor(unpack(UI.COLORS.danger))
    else
        btn.label:SetTextColor(unpack(UI.COLORS.textDim))
    end

    btn:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(unpack(UI.COLORS.accent))
    end)
    btn:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(unpack(UI.COLORS.border))
    end)

    return btn
end

-- ============================================================
--  CreateDivider — thin horizontal line
-- ============================================================

function UI:CreateDivider(parent, width, yOffset)
    local div = parent:CreateTexture(nil, "ARTWORK")
    div:SetSize(width, 1)
    div:SetColorTexture(unpack(UI.COLORS.borderDim))
    return div
end

-- ============================================================
--  CreateSectionTitle — small uppercase accent label
-- ============================================================

function UI:CreateSectionTitle(parent, text)
    local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    fs:SetText(text)
    fs:SetTextColor(unpack(UI.COLORS.accent))
    return fs
end

-- ============================================================
--  Row highlight helper
-- ============================================================

function UI:AddRowHighlight(row)
    local hl = row:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints()
    hl:SetColorTexture(UI.COLORS.bgHover[1], UI.COLORS.bgHover[2], UI.COLORS.bgHover[3], 0.6)
    return hl
end

-- ============================================================
--  Font system — live-updatable font objects
--  Every Tomo fontstring created via UI:FS(...) is bound to a
--  shared font object, so changing the chosen font/size updates
--  the whole UI at once via UI:RefreshFonts().
-- ============================================================

UI._fontObjects = UI._fontObjects or {}
local FONT_SIZES = { tiny = 10, small = 11, normal = 12, large = 14, title = 16 }
local fontsInited = false

function UI:GetFontPath()
    local f = TM.db and TM.db.profile and TM.db.profile.font
    if type(f) == "string" and f ~= "" then return f end
    return "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
end

function UI:GetFontSizeScale()
    local s = TM.db and TM.db.profile and TM.db.profile.fontSize
    s = tonumber(s) or 1.0
    if s < 0.7 then s = 0.7 elseif s > 1.6 then s = 1.6 end
    return s
end

local function ensureFontObjects()
    for key in pairs(FONT_SIZES) do
        if not UI._fontObjects[key] then
            UI._fontObjects[key] = CreateFont("TomoMod_MailFont_" .. key)
        end
    end
end

function UI:RefreshFonts()
    ensureFontObjects()
    local path  = self:GetFontPath()
    local scale = self:GetFontSizeScale()
    for key, baseSize in pairs(FONT_SIZES) do
        local fo   = self._fontObjects[key]
        local size = math.floor(baseSize * scale + 0.5)
        local ok = pcall(function() fo:SetFont(path, size, "") end)
        if not ok then pcall(function() fo:SetFont("Fonts\\FRIZQT__.TTF", size, "") end) end
        fo:SetShadowColor(0, 0, 0, 1)
        fo:SetShadowOffset(1, -1)
        fo:SetTextColor(unpack(UI.COLORS.text))
    end
    fontsInited = true
end

-- Create a fontstring bound to a live Tomo font object.
function UI:FS(parent, sizeKey, layer)
    if not fontsInited then self:RefreshFonts() end
    local fo = self._fontObjects[sizeKey] or self._fontObjects.normal
    local fs = parent:CreateFontString(nil, layer or "OVERLAY")
    fs:SetFontObject(fo)
    return fs
end

-- Apply the chosen font directly to an existing (e.g. native) fontstring,
-- preserving its current size and flags.
function UI:ApplyFontTo(fs)
    if not fs or not fs.GetFont then return end
    local _, size, flags = fs:GetFont()
    pcall(function() fs:SetFont(self:GetFontPath(), size or 12, flags or "") end)
end

function UI:GetFontList()
    local list = {
        { name = "Poppins",          path = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf" },
        { name = "Poppins SemiBold", path = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-SemiBold.ttf" },
        { name = "Expressway",       path = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Expressway.TTF" },
        { name = "Friz Quadrata",    path = "Fonts\\FRIZQT__.TTF" },
        { name = "Arial Narrow",  path = "Fonts\\ARIALN.TTF" },
        { name = "Skurri",        path = "Fonts\\SKURRI.TTF" },
        { name = "Morpheus",      path = "Fonts\\MORPHEUS.TTF" },
        { name = "2002",          path = "Fonts\\2002.TTF" },
    }
    pcall(function()
        if LibStub then
            local LSM = LibStub("LibSharedMedia-3.0", true)
            if LSM then
                local seen = {}
                for _, e in ipairs(list) do seen[e.path] = true end
                for _, name in ipairs(LSM:List("font")) do
                    local p = LSM:Fetch("font", name, true)
                    if p and not seen[p] then
                        table.insert(list, { name = name, path = p })
                        seen[p] = true
                    end
                end
            end
        end
    end)
    return list
end

function UI:GetFontName()
    local cur = self:GetFontPath()
    for _, e in ipairs(self:GetFontList()) do
        if e.path == cur then return e.name end
    end
    return cur:match("([^\\]+)%.%w+$") or "Police"
end

-- ============================================================
--  TomoSuite GUI V2 core
--  Shared visual grammar used by TomoMod_Mail / TomoSync.
--  This layer is additive on purpose: legacy widgets remain
--  available while screens migrate progressively to UI.V2.
-- ============================================================

UI.V2 = UI.V2 or {}
local V2 = UI.V2

V2.VERSION = 1
V2.WHITE = "Interface\\Buttons\\WHITE8X8"

V2.COLORS = {
    accent       = UI.COLORS.accent,
    accentDim    = UI.COLORS.accentDim,
    bg           = UI.COLORS.bg,
    surface      = UI.COLORS.bgLight,
    surfaceHover = UI.COLORS.bgHover,
    border       = UI.COLORS.border,
    borderDim    = UI.COLORS.borderDim,
    text         = UI.COLORS.text,
    textDim      = UI.COLORS.textDim,
    textMuted    = UI.COLORS.textMuted,
    danger       = UI.COLORS.danger,
    dangerBg     = UI.COLORS.dangerBg,
}

V2.METRICS = {
    headerHeight = 42,
    outerPad     = 16,
    innerPad     = 12,
    rowHeight    = 38,
    controlGap   = 8,
}

local function Color4(c, fallbackAlpha)
    return c[1], c[2], c[3], c[4] or fallbackAlpha or 1
end

local function StyleBackdrop(frame, bg, border, borderAlpha)
    frame:SetBackdrop({
        bgFile   = V2.WHITE,
        edgeFile = V2.WHITE,
        edgeSize = 1,
        insets   = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    frame:SetBackdropColor(Color4(bg, 1))
    local r, g, b = border[1], border[2], border[3]
    frame:SetBackdropBorderColor(r, g, b, borderAlpha or border[4] or 1)
end

function V2:Solid(parent, layer)
    local tex = parent:CreateTexture(nil, layer or "ARTWORK")
    tex:SetTexture(self.WHITE)
    return tex
end

function V2:AddTooltip(frame, title, body, anchor)
    if not frame or not title then return end
    frame:HookScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, anchor or "ANCHOR_RIGHT")
        GameTooltip:AddLine(title, 1, 1, 1)
        if body and body ~= "" then
            GameTooltip:AddLine(body, 0.78, 0.78, 0.82, true)
        end
        GameTooltip:Show()
    end)
    frame:HookScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

function V2:CreatePanel(parent, name, width, height)
    local frame = CreateFrame("Frame", name, parent or UIParent, "BackdropTemplate")
    frame:SetSize(width, height)
    StyleBackdrop(frame, self.COLORS.bg, self.COLORS.border, 0.90)
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    frame:EnableMouse(true)
    return frame
end

function V2:CreateCard(parent, width, height)
    local card = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    card:SetSize(width, height)
    StyleBackdrop(card, self.COLORS.surface, self.COLORS.borderDim, 1)
    return card
end

function V2:CreateHeader(parent, suffix, version, height)
    local h = CreateFrame("Frame", nil, parent)
    h:SetPoint("TOPLEFT", parent, "TOPLEFT", 1, -1)
    h:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -1, -1)
    h:SetHeight(height or self.METRICS.headerHeight)

    local bg = self:Solid(h, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetVertexColor(Color4(self.COLORS.surface, 1))

    local accent = self:Solid(h, "ARTWORK")
    accent:SetSize(3, 18)
    accent:SetPoint("LEFT", h, "LEFT", 14, 0)
    accent:SetVertexColor(Color4(self.COLORS.accent, 1))

    local title = h:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("LEFT", accent, "RIGHT", 9, 0)
    title:SetText("|cFFFFD100Tomo|r|cFFF2EBDB" .. tostring(suffix or "") .. "|r")

    local versionText = h:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    versionText:SetPoint("LEFT", title, "RIGHT", 8, -1)
    versionText:SetText(version and tostring(version) or "")
    versionText:SetTextColor(Color4(self.COLORS.textMuted, 1))

    local line = self:Solid(h, "ARTWORK")
    line:SetHeight(1)
    line:SetPoint("BOTTOMLEFT", h, "BOTTOMLEFT", 0, 0)
    line:SetPoint("BOTTOMRIGHT", h, "BOTTOMRIGHT", 0, 0)
    line:SetVertexColor(self.COLORS.accent[1], self.COLORS.accent[2], self.COLORS.accent[3], 0.30)

    h.title = title
    h.version = versionText
    h.accent = accent
    return h
end

function V2:CreateCloseButton(parent, onClick)
    local button = CreateFrame("Button", nil, parent)
    button:SetSize(24, 24)

    local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    text:SetAllPoints()
    text:SetText("×")
    text:SetTextColor(Color4(self.COLORS.textMuted, 1))

    button:SetScript("OnEnter", function()
        text:SetTextColor(1, 1, 1)
    end)
    button:SetScript("OnLeave", function()
        text:SetTextColor(Color4(V2.COLORS.textMuted, 1))
    end)
    button:SetScript("OnClick", function()
        if onClick then onClick() end
    end)

    button.Text = text
    return button
end

function V2:CreateIconButton(parent, texture, size, tooltipTitle, tooltipBody)
    local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
    button:SetSize(size or 24, size or 24)
    StyleBackdrop(button, self.COLORS.surface, self.COLORS.borderDim, 1)

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("TOPLEFT", 4, -4)
    icon:SetPoint("BOTTOMRIGHT", -4, 4)
    icon:SetTexture(texture)
    icon:SetVertexColor(Color4(self.COLORS.textDim, 1))

    button:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(Color4(V2.COLORS.accent, 1))
        icon:SetVertexColor(1, 1, 1, 1)
    end)
    button:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(Color4(V2.COLORS.borderDim, 1))
        icon:SetVertexColor(Color4(V2.COLORS.textDim, 1))
    end)

    if tooltipTitle then
        self:AddTooltip(button, tooltipTitle, tooltipBody)
    end
    button.Icon = icon
    return button
end

function V2:CreateSectionTitle(parent, text, subtitle)
    local holder = CreateFrame("Frame", nil, parent)
    holder:SetHeight(subtitle and 34 or 20)

    local title = holder:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    title:SetPoint("TOPLEFT", 0, 0)
    title:SetText(text or "")
    title:SetTextColor(Color4(self.COLORS.accent, 1))

    if subtitle then
        local sub = holder:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        sub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -3)
        sub:SetPoint("RIGHT", holder, "RIGHT", 0, 0)
        sub:SetJustifyH("LEFT")
        sub:SetText(subtitle)
        sub:SetTextColor(Color4(self.COLORS.textMuted, 1))
        holder.Subtitle = sub
    end

    holder.Title = title
    return holder
end

function V2:CreateDivider(parent)
    local line = self:Solid(parent, "ARTWORK")
    line:SetHeight(1)
    line:SetVertexColor(Color4(self.COLORS.borderDim, 1))
    return line
end

function V2:CreateButton(parent, text, width, height, kind)
    kind = kind or "secondary"
    local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
    button:SetSize(width or 120, height or 28)

    local bg = self.COLORS.surface
    local border = self.COLORS.border
    local textColor = self.COLORS.text

    if kind == "primary" then
        bg = self.COLORS.accentDim
        border = self.COLORS.accent
    elseif kind == "danger" then
        bg = self.COLORS.dangerBg
        border = self.COLORS.dangerBg
        textColor = self.COLORS.danger
    end

    StyleBackdrop(button, bg, border, 1)

    local label = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("CENTER")
    label:SetText(text or "")
    label:SetTextColor(Color4(textColor, 1))

    button._kind = kind
    button:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(Color4(V2.COLORS.accent, 1))
        if kind ~= "primary" then
            self:SetBackdropColor(Color4(V2.COLORS.surfaceHover, 1))
        end
    end)
    button:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(Color4(border, 1))
        self:SetBackdropColor(Color4(bg, 1))
    end)

    button.Text = label
    return button
end

function V2:CreateToggle(parent, getter, setter, onChanged)
    local toggle = CreateFrame("Button", nil, parent)
    toggle:SetSize(38, 20)

    local track = self:Solid(toggle, "ARTWORK")
    track:SetAllPoints()

    local knob = self:Solid(toggle, "OVERLAY")
    knob:SetSize(16, 16)
    knob:SetVertexColor(0.949, 0.922, 0.859, 1)

    function toggle:Refresh()
        local enabled = getter() and true or false
        if enabled then
            track:SetVertexColor(Color4(V2.COLORS.accent, 1))
            knob:ClearAllPoints()
            knob:SetPoint("RIGHT", self, "RIGHT", -2, 0)
        else
            track:SetVertexColor(Color4(V2.COLORS.border, 1))
            knob:ClearAllPoints()
            knob:SetPoint("LEFT", self, "LEFT", 2, 0)
        end
        self._checked = enabled
    end

    toggle:SetScript("OnClick", function(self)
        local value = not (getter() and true or false)
        setter(value)
        self:Refresh()
        if onChanged then onChanged(value) end
        if SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON then
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        end
    end)

    toggle.Track = track
    toggle.Knob = knob
    toggle:Refresh()
    return toggle
end

function V2:CreateSettingRow(parent, width, label, subtitle, getter, setter, onChanged)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(width, subtitle and 46 or self.METRICS.rowHeight)

    local labelText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    labelText:SetPoint("LEFT", row, "LEFT", 0, subtitle and 6 or 0)
    labelText:SetPoint("RIGHT", row, "RIGHT", -54, 0)
    labelText:SetJustifyH("LEFT")
    labelText:SetText(label or "")
    labelText:SetTextColor(Color4(self.COLORS.text, 1))

    if subtitle then
        local sub = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        sub:SetPoint("TOPLEFT", labelText, "BOTTOMLEFT", 0, -2)
        sub:SetPoint("RIGHT", row, "RIGHT", -54, 0)
        sub:SetJustifyH("LEFT")
        sub:SetText(subtitle)
        sub:SetTextColor(Color4(self.COLORS.textMuted, 1))
        row.Subtitle = sub
    end

    local toggle = self:CreateToggle(row, getter, setter, onChanged)
    toggle:SetPoint("RIGHT", row, "RIGHT", 0, 0)

    function row:Refresh()
        toggle:Refresh()
    end

    row.Label = labelText
    row.Toggle = toggle
    return row
end

function V2:CreateSearchBox(parent, width, placeholder, onTextChanged)
    local box = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    box:SetSize(width or 220, 30)
    StyleBackdrop(box, self.COLORS.bg, self.COLORS.border, 1)

    local edit = CreateFrame("EditBox", nil, box)
    edit:SetPoint("LEFT", 9, 0)
    edit:SetPoint("RIGHT", -28, 0)
    edit:SetHeight(20)
    edit:SetAutoFocus(false)
    edit:SetFontObject(GameFontNormalSmall)
    edit:SetTextColor(Color4(self.COLORS.text, 1))

    local ph = box:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    ph:SetPoint("LEFT", edit, "LEFT", 0, 0)
    ph:SetPoint("RIGHT", edit, "RIGHT", 0, 0)
    ph:SetJustifyH("LEFT")
    ph:SetText(placeholder or "")
    ph:SetTextColor(Color4(self.COLORS.textMuted, 1))

    local clear = CreateFrame("Button", nil, box)
    clear:SetSize(20, 20)
    clear:SetPoint("RIGHT", box, "RIGHT", -4, 0)
    local clearText = clear:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    clearText:SetAllPoints()
    clearText:SetText("×")
    clearText:SetTextColor(Color4(self.COLORS.textMuted, 1))
    clear:Hide()

    local function RefreshPlaceholder()
        local hasText = edit:GetText() ~= ""
        ph:SetShown(not hasText and not edit:HasFocus())
        clear:SetShown(hasText)
    end

    clear:SetScript("OnClick", function()
        edit:SetText("")
        edit:SetFocus()
    end)
    clear:SetScript("OnEnter", function()
        clearText:SetTextColor(1, 1, 1)
    end)
    clear:SetScript("OnLeave", function()
        clearText:SetTextColor(Color4(V2.COLORS.textMuted, 1))
    end)

    edit:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    edit:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    edit:SetScript("OnEditFocusGained", function()
        box:SetBackdropBorderColor(Color4(V2.COLORS.accent, 1))
        RefreshPlaceholder()
    end)
    edit:SetScript("OnEditFocusLost", function()
        box:SetBackdropBorderColor(Color4(V2.COLORS.border, 1))
        RefreshPlaceholder()
    end)
    edit:SetScript("OnTextChanged", function(self, userInput)
        RefreshPlaceholder()
        if onTextChanged then onTextChanged(self:GetText() or "", userInput) end
    end)

    box.EditBox = edit
    box.Placeholder = ph
    box.ClearButton = clear
    return box
end

function V2:CreateSlider(parent, width, label, minValue, maxValue, step, getter, setter, formatter, onChanged)
    local holder = CreateFrame("Frame", nil, parent)
    holder:SetSize(width, 48)

    local labelText = holder:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    labelText:SetPoint("TOPLEFT", 0, 0)
    labelText:SetText(label or "")
    labelText:SetTextColor(Color4(self.COLORS.text, 1))

    local valueText = holder:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    valueText:SetPoint("TOPRIGHT", 0, 0)
    valueText:SetTextColor(Color4(self.COLORS.accent, 1))

    local slider = CreateFrame("Slider", nil, holder)
    slider:SetOrientation("HORIZONTAL")
    slider:SetPoint("TOPLEFT", 0, -21)
    slider:SetPoint("TOPRIGHT", 0, -21)
    slider:SetHeight(18)
    slider:SetMinMaxValues(minValue, maxValue)
    slider:SetValueStep(step or 1)
    pcall(function() slider:SetObeyStepOnDrag(true) end)

    local track = self:Solid(holder, "BACKGROUND")
    track:SetHeight(4)
    track:SetPoint("LEFT", slider, "LEFT", 0, 0)
    track:SetPoint("RIGHT", slider, "RIGHT", 0, 0)
    track:SetVertexColor(Color4(self.COLORS.border, 1))

    slider:SetThumbTexture(self.WHITE)
    local thumb = slider:GetThumbTexture()
    if thumb then
        thumb:SetSize(12, 16)
        thumb:SetVertexColor(Color4(self.COLORS.accent, 1))
    end

    local function FormatValue(value)
        if formatter then return formatter(value) end
        return tostring(value)
    end

    local function Snap(value)
        local s = step or 1
        if s <= 0 then return value end
        local snapped = minValue + math.floor(((value - minValue) / s) + 0.5) * s
        if snapped < minValue then snapped = minValue end
        if snapped > maxValue then snapped = maxValue end
        return snapped
    end

    function holder:Refresh()
        local value = tonumber(getter()) or minValue
        value = Snap(value)
        self._refreshing = true
        slider:SetValue(value)
        self._refreshing = false
        valueText:SetText(FormatValue(value))
    end

    slider:SetScript("OnValueChanged", function(_, value)
        value = Snap(value)
        valueText:SetText(FormatValue(value))
        if holder._refreshing then return end
        setter(value)
        if onChanged then onChanged(value) end
    end)

    holder.Label = labelText
    holder.Value = valueText
    holder.Slider = slider
    holder:Refresh()
    return holder
end

function V2:CreateBadge(parent, text, width)
    local badge = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    badge:SetSize(width or 52, 20)
    StyleBackdrop(badge, self.COLORS.bg, self.COLORS.borderDim, 1)

    local label = badge:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("CENTER")
    label:SetText(text or "")
    label:SetTextColor(Color4(self.COLORS.accent, 1))

    function badge:SetText(value)
        label:SetText(value or "")
    end

    badge.Text = label
    return badge
end

function V2:SkinScrollBar(bar)
    if not bar then return end
    bar:SetWidth(8)

    local name = bar:GetName()
    local up = bar.ScrollUpButton or (name and _G[name .. "ScrollUpButton"])
    local down = bar.ScrollDownButton or (name and _G[name .. "ScrollDownButton"])
    local thumb = (bar.GetThumbTexture and bar:GetThumbTexture()) or (name and _G[name .. "ThumbTexture"])

    for _, region in ipairs({ bar:GetRegions() }) do
        if region ~= thumb and region.GetObjectType and region:GetObjectType() == "Texture" then
            region:SetAlpha(0)
        end
    end

    for _, button in ipairs({ up, down }) do
        if button then
            button:SetAlpha(0)
            button:EnableMouse(false)
        end
    end

    if not bar._tomoV2Track then
        local track = self:Solid(bar, "BACKGROUND")
        track:SetPoint("TOPLEFT", bar, "TOPLEFT", 2, -2)
        track:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -2, 2)
        track:SetVertexColor(1, 1, 1, 0.05)
        bar._tomoV2Track = track
    end

    if thumb then
        thumb:SetTexture(self.WHITE)
        thumb:SetVertexColor(self.COLORS.accent[1], self.COLORS.accent[2], self.COLORS.accent[3], 0.65)
        thumb:SetWidth(4)
    end
end
