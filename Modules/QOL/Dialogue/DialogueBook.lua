-- =====================================================================
-- Modules/QOL/Dialogue/DialogueBook.lua -- books, letters and plaques (1.3.9)
--
-- What you read in the world (books, letters, plaques, notes) opens on a
-- page of parchment framed in gold instead of the game's window. The page
-- takes the tint of its material (stone, marble, silver, bronze), the
-- screen darkens behind it, and pages turn with a slide.
--   Right arrow / Space   next page
--   Left arrow            previous page
--   Escape                close
-- The game's ItemTextFrame is not told about these events while this is
-- on (given back when it is turned off).
-- =====================================================================

TomoMod_DialogueBook = TomoMod_DialogueBook or {}
local B = TomoMod_DialogueBook

local FONT      = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local FONT_BOLD = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-SemiBold.ttf"
local ART       = "Interface\\AddOns\\TomoModForever\\Assets\\Textures\\Dialogue\\"
local GOLD = { 0.788, 0.635, 0.322 }
local INK  = { 0.22, 0.14, 0.07 }

local W, H, PAD = 460, 560, 40

local MATERIAL = {
    Stone  = { 0.72, 0.72, 0.70 },
    Marble = { 0.95, 0.94, 0.92 },
    Silver = { 0.82, 0.84, 0.88 },
    Bronze = { 0.86, 0.66, 0.42 },
}

local IS_FR = GetLocale() == "frFR"
local function T(fr, en)
    if TomoMod_GUIT then return TomoMod_GUIT(fr, en) end
    return IS_FR and fr or en
end

local function DB() return TomoModForeverDB and TomoModForeverDB.dialogue end
local function AnimAny()
    local U = TomoMod_Utils
    return not (U and U.AnimAny) or U.AnimAny()
end

local book, html, scroll, dim
local muted = false
local BLIZZ_EVENTS = { "ITEM_TEXT_BEGIN", "ITEM_TEXT_TRANSLATION", "ITEM_TEXT_READY", "ITEM_TEXT_CLOSED" }

local function Mute(on)
    if on == muted then return end
    local f = _G.ItemTextFrame
    if f then
        for _, e in ipairs(BLIZZ_EVENTS) do
            if on then f:UnregisterEvent(e) else pcall(f.RegisterEvent, f, e) end
        end
        if on and f:IsShown() then HideUIPanel(f) end
    end
    muted = on
end

local function Font(fs, path, size)
    fs:SetFont(path, size, "")
end

local function ArrowButton(parent, left)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(32, 32)
    local t = b:CreateTexture(nil, "ARTWORK")
    t:SetAllPoints()
    t:SetTexture("Interface\\AddOns\\TomoModForever\\Assets\\Textures\\" .. (left and "arrow_left.tga" or "arrow_right.tga"))
    t:SetVertexColor(INK[1], INK[2], INK[3], 0.85)
    b.t = t
    b:SetScript("OnEnter", function(s) s.t:SetVertexColor(0.55, 0.35, 0.1, 1) end)
    b:SetScript("OnLeave", function(s) s.t:SetVertexColor(INK[1], INK[2], INK[3], 0.85) end)
    return b
end

local function Close()
    if book and book:IsShown() then book:Hide() end
end

local function Create()
    if book then return end
    dim = CreateFrame("Frame", nil, UIParent)
    dim:SetAllPoints(UIParent)
    dim:SetFrameStrata("DIALOG")
    dim:SetFrameLevel(1)
    local dt = dim:CreateTexture(nil, "BACKGROUND")
    dt:SetAllPoints()
    dt:SetColorTexture(0, 0, 0, 0.55)
    dim:Hide()

    book = CreateFrame("Frame", "TomoMod_BookFrame", UIParent)
    book:SetSize(W, H)
    book:SetPoint("CENTER", 0, 20)
    book:SetFrameStrata("DIALOG")
    book:SetFrameLevel(20)
    book:EnableMouse(true)
    book:SetClampedToScreen(true)
    book:Hide()

    book.page = book:CreateTexture(nil, "BACKGROUND")
    book.page:SetAllPoints()
    book.page:SetTexture(ART .. "page.tga")
    for _, c in ipairs({ { "TOPLEFT", 0, 1, 1, 0 }, { "TOPRIGHT", 1, 0, 1, 0 }, { "BOTTOMLEFT", 0, 1, 0, 1 }, { "BOTTOMRIGHT", 1, 0, 0, 1 } }) do
        local t = book:CreateTexture(nil, "OVERLAY")
        t:SetSize(64, 64)
        t:SetPoint(c[1], book, c[1], (c[1]:find("LEFT") and -4 or 4), (c[1]:find("TOP") and 4 or -4))
        t:SetTexture(ART .. "corner.tga")
        t:SetTexCoord(c[2], c[3], c[4], c[5])
        t:SetVertexColor(GOLD[1] * 0.85, GOLD[2] * 0.85, GOLD[3] * 0.85, 1)
    end
    local border = CreateFrame("Frame", nil, book, "BackdropTemplate")
    border:SetAllPoints()
    if border.SetBackdrop then
        border:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
        border:SetBackdropBorderColor(GOLD[1], GOLD[2], GOLD[3], 0.8)
    end

    book.title = book:CreateFontString(nil, "OVERLAY")
    Font(book.title, FONT_BOLD, 18)
    book.title:SetPoint("TOP", 0, -30)
    book.title:SetWidth(W - PAD * 2)
    book.title:SetTextColor(INK[1], INK[2], INK[3])
    local div = book:CreateTexture(nil, "ARTWORK")
    div:SetSize(W - PAD * 2, 14)
    div:SetPoint("TOP", book.title, "BOTTOM", 0, -6)
    div:SetTexture(ART .. "divider.tga")
    div:SetVertexColor(0.45, 0.30, 0.12, 0.8)

    scroll = CreateFrame("ScrollFrame", nil, book)
    scroll:SetPoint("TOPLEFT", PAD, -78)
    scroll:SetPoint("BOTTOMRIGHT", -PAD, 58)
    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(self, delta)
        local max = math.max(0, (html:GetHeight() or 0) - self:GetHeight())
        self:SetVerticalScroll(math.max(0, math.min(max, self:GetVerticalScroll() - delta * 40)))
    end)
    html = CreateFrame("SimpleHTML", nil, scroll)
    html:SetWidth(W - PAD * 2)
    html:SetHeight(10)
    for _, tag in ipairs({ "P", "H1", "H2", "H3" }) do
        local size = (tag == "H1" and 18) or (tag == "H2" and 16) or (tag == "H3" and 15) or 14
        html:SetFont(tag, (tag == "P") and FONT or FONT_BOLD, size, "")
        html:SetTextColor(tag, INK[1], INK[2], INK[3])
    end
    if html.SetSpacing then pcall(html.SetSpacing, html, "P", 3) end
    scroll:SetScrollChild(html)

    book.pageNum = book:CreateFontString(nil, "OVERLAY")
    Font(book.pageNum, FONT, 12)
    book.pageNum:SetPoint("BOTTOM", 0, 26)
    book.pageNum:SetTextColor(INK[1], INK[2], INK[3], 0.8)
    book.prev = ArrowButton(book, true)
    book.prev:SetPoint("BOTTOMLEFT", 26, 18)
    book.prev:SetScript("OnClick", function() B.Turn(-1) end)
    book.next = ArrowButton(book, false)
    book.next:SetPoint("BOTTOMRIGHT", -26, 18)
    book.next:SetScript("OnClick", function() B.Turn(1) end)

    local close = CreateFrame("Button", nil, book)
    close:SetSize(20, 20)
    close:SetPoint("TOPRIGHT", -14, -14)
    local x = close:CreateTexture(nil, "ARTWORK")
    x:SetAllPoints()
    x:SetTexture("Interface\\AddOns\\TomoModForever\\Assets\\Textures\\Codex\\x.tga")
    x:SetVertexColor(INK[1], INK[2], INK[3], 0.8)
    close:SetScript("OnClick", Close)

    -- page turn: the text slides in from the side it comes from
    book.turn = scroll:CreateAnimationGroup()
    local o = book.turn:CreateAnimation("Translation"); o:SetDuration(0); o:SetOrder(1)
    local a0 = book.turn:CreateAnimation("Alpha"); a0:SetFromAlpha(0); a0:SetToAlpha(0); a0:SetDuration(0); a0:SetOrder(1)
    local m = book.turn:CreateAnimation("Translation"); m:SetDuration(0.25); m:SetSmoothing("OUT"); m:SetOrder(2)
    local a1 = book.turn:CreateAnimation("Alpha"); a1:SetFromAlpha(0); a1:SetToAlpha(1); a1:SetDuration(0.25); a1:SetOrder(2)
    book.turnOut, book.turnIn = o, m

    book.open = book:CreateAnimationGroup()
    local s0 = book.open:CreateAnimation("Scale"); s0:SetScaleFrom(0.94, 0.94); s0:SetScaleTo(1, 1); s0:SetDuration(0.22); s0:SetSmoothing("OUT")
    local f0 = book.open:CreateAnimation("Alpha"); f0:SetFromAlpha(0); f0:SetToAlpha(1); f0:SetDuration(0.22)

    book:EnableKeyboard(false)   -- turned on when shown, out of combat
    book:SetScript("OnKeyDown", function(self, key)
        if InCombatLockdown() then return end
        local handled = true
        if key == "RIGHT" or key == "SPACE" then
            if ItemTextHasNextPage() then B.Turn(1) else Close() end
        elseif key == "LEFT" then B.Turn(-1)
        elseif key == "ESCAPE" then Close()
        else handled = false end
        self:SetPropagateKeyboardInput(not handled)
    end)
    book:SetScript("OnHide", function()
        dim:Hide()
        CloseItemText()
    end)
    tinsert(UISpecialFrames, "TomoMod_BookFrame")
end

local lastPage = 1
function B.Turn(dir)
    if dir > 0 and ItemTextHasNextPage() then ItemTextNextPage()
    elseif dir < 0 and (ItemTextGetPage() or 1) > 1 then ItemTextPrevPage() end
end

local function Fill()
    Create()
    local title = ItemTextGetItem() or ""
    local text = ItemTextGetText() or ""
    local page = ItemTextGetPage() or 1
    book.title:SetText(title)
    local tint = MATERIAL[ItemTextGetMaterial and ItemTextGetMaterial() or ""] or { 1, 1, 1 }
    book.page:SetVertexColor(tint[1], tint[2], tint[3])
    html:SetWidth(W - PAD * 2)
    html:SetText(text)
    local h = (html.GetContentHeight and html:GetContentHeight()) or 400
    html:SetHeight(math.max(10, h))
    scroll:SetVerticalScroll(0)
    local hasNext = ItemTextHasNextPage()
    book.prev:SetShown(page > 1)
    book.next:SetShown(hasNext)
    book.pageNum:SetText((page > 1 or hasNext) and (T("Page ", "Page ") .. page) or "")
    local first = not book:IsShown()
    if first then
        if not InCombatLockdown() then book:SetPropagateKeyboardInput(true); book:EnableKeyboard(true) end
        local db = DB()
        if not (db and db.bookDim == false) then dim:Show() end
        book:Show()
        if AnimAny() then book.open:Stop(); book.open:Play() end
    elseif AnimAny() and page ~= lastPage then
        local dir = page > lastPage and 1 or -1
        book.turnOut:SetOffset(dir * 30, 0)
        book.turnIn:SetOffset(-dir * 30, 0)
        book.turn:Stop(); book.turn:Play()
    end
    lastPage = page
end

local ev = CreateFrame("Frame")
ev:SetScript("OnEvent", function(_, event)
    if event == "ITEM_TEXT_READY" then
        local ok = pcall(Fill)
        if not ok then
            -- Never stuck: the game's window this time.
            Mute(false)
            local f = _G.ItemTextFrame
            local h = f and f:GetScript("OnEvent")
            if h then pcall(h, f, "ITEM_TEXT_BEGIN"); pcall(h, f, "ITEM_TEXT_READY") end
            C_Timer.After(0, function() if B.Active() then Mute(true) end end)
        end
    elseif event == "ITEM_TEXT_CLOSED" then
        if book and book:IsShown() then book:Hide() end
    elseif event == "ITEM_TEXT_BEGIN" then
        lastPage = 1
    elseif event == "PLAYER_REGEN_DISABLED" then
        if book then book:EnableKeyboard(false) end
    elseif event == "PLAYER_REGEN_ENABLED" then
        if book and book:IsShown() then book:SetPropagateKeyboardInput(true); book:EnableKeyboard(true) end
    end
end)

local active = false
function B.Active() return active end

function B.ApplySettings()
    local db = DB()
    local want = db and db.enabled ~= false and db.books ~= false
    if want and not active then
        for _, e in ipairs({ "ITEM_TEXT_BEGIN", "ITEM_TEXT_READY", "ITEM_TEXT_CLOSED", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED" }) do
            ev:RegisterEvent(e)
        end
        Mute(true)
        active = true
    elseif not want and active then
        ev:UnregisterAllEvents()
        Close()
        Mute(false)
        active = false
    end
end

function B.Initialize()
    if not DB() then return end
    B.ApplySettings()
end
