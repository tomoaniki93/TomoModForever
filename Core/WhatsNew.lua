-- ============================================================
-- WhatsNew.lua — "What's New" popup after addon updates
-- Compares TomoModForeverDB.lastSeenVersion with current version.
-- Shown once per version on PLAYER_LOGIN via C_Timer.After.
--
-- [fix] The dimmer used to be orphaned on close. It is a SEPARATE
-- full-screen mouse-blocking frame (the panel is its child), and only
-- WN.Hide() ever hid it -- but the panel was registered in
-- UISpecialFrames, so Escape made Blizzard call
-- TomoModWhatsNewFrame:Hide() directly, bypassing WN.Hide(). The panel
-- vanished, the dimmer stayed: dark screen, mouse dead, nothing to
-- click. MarkSeen() lived in the same bypassed function, so the popup
-- came back on the next login instead of staying closed.
--
-- Brand-new characters hit this every time: the popup is created while
-- the intro cinematic is playing (UIParent hidden, so it is invisible
-- but shown), and the first thing the player does is press Escape to
-- skip the cinematic -- closing a window they never saw.
--
-- Three changes make that state unreachable:
--   1. dimmer and panel are created HIDDEN and only shown once the
--      content is built, so a failure mid-construction leaves nothing
--      on screen (same pattern as Config/Installer.lua).
--   2. an OnHide script on the panel is now the single authority: it
--      hides the dimmer and calls MarkSeen(), so every close path
--      (X, "Compris !", Escape, any external Hide) behaves the same.
--   3. Escape is handled on the frame itself instead of through
--      UISpecialFrames -- which also drops the ToggleGameMenu ->
--      ClearTarget() taint path documented in Core/Forge/ForgeStudio.
--
-- The popup is additionally held back while a cinematic or movie is
-- playing, while in combat, and until a character's SECOND login.
-- ============================================================

TomoMod_WhatsNew = TomoMod_WhatsNew or {}
local WN = TomoMod_WhatsNew
local L  = TomoMod_L

local FONT      = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local FONT_BOLD = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-SemiBold.ttf"
local LOGO_TEX  = "Interface\\AddOns\\TomoModForever\\Assets\\Textures\\Logo.tga"

-- Palette (matches Installer)
local A  = { TomoMod_Utils.BRAND[1], TomoMod_Utils.BRAND[2], TomoMod_Utils.BRAND[3] }
local BG = { 0.086, 0.071, 0.055,  0.98 }
local BD = { 0.380, 0.290, 0.170,  1    }
local TX = { 0.949, 0.922, 0.859,  1    }
local DM = { 0.66,  0.62,  0.54,  1    }

local PANEL_W = 520
local PANEL_H = 480

-- ============================================================
-- CHANGELOG DATA
-- Each version entry: { title = "...", highlights = { "...", ... } }
-- Only keep the last few versions to avoid bloating memory.
-- ============================================================

-- Published for the Changelog config page. One table, two readers: the
-- popup that shows what is new after an update, and the page that lets you
-- read any past version. A second copy would drift the first time a release
-- was added to only one of them.
local CHANGELOG
CHANGELOG = {
    {
        version = "1.2.6",
        highlights = {
            L["wn_126_dquests"],
            L["wn_126_levels"],
        },
    },
    {
        version = "1.2.5",
        highlights = {
            L["wn_125_elites"],
            L["wn_125_mana"],
            L["wn_125_levels"],
            L["wn_125_codexbtn"],
        },
    },
    {
        version = "1.2.4",
        highlights = {
            L["wn_124_triage"],
            L["wn_124_quests"],
        },
    },
    {
        version = "1.2.3",
        highlights = {
            L["wn_123_flight"],
            L["wn_123_pet"],
        },
    },
    {
        version = "1.2.2",
        highlights = {
            L["wn_122_tabs"],
            L["wn_122_overflow"],
            L["wn_122_trainer"],
            L["wn_122_camp"],
            L["wn_122_map"],
            L["wn_122_graphics"],
        },
    },
    {
        version = "1.2.1",
        highlights = {
            L["wn_121_bags"],
            L["wn_121_trainer"],
            L["wn_121_codex"],
            L["wn_121_pet"],
            L["wn_121_fixes"],
        },
    },
    {
        version = "1.2.0",
        highlights = {
            L["wn_120_mail"],
            L["wn_120_flight"],
            L["wn_120_flightmap"],
            L["wn_120_res"],
            L["wn_120_errors"],
            L["wn_120_train"],
            L["wn_120_camera"],
        },
    },
    {
        version = "1.1.3",
        highlights = {
            L["wn_113_actionbars"],
            L["wn_113_barfade"],
            L["wn_113_layout"],
            L["wn_113_magnet"],
            L["wn_113_tracker"],
            L["wn_113_chat"],
            L["wn_113_bags"],
            L["wn_113_narrow"],
            L["wn_113_waypoint"],
        },
    },
    {
        version = "1.1.2",
        highlights = {
            L["wn_112_healer"],
            L["wn_112_arrows"],
            L["wn_112_waypoint"],
            L["wn_112_i18n"],
            L["wn_112_removed"],
            L["wn_112_fixes"],
        },
    },
    {
        version = "1.1.1",
        highlights = {
            L["wn_111_camp"],
            L["wn_111_leave"],
            L["wn_111_signals"],
        },
    },
    {
        version = "1.1.0",
        highlights = {
            L["wn_110_gui"],
            L["wn_110_studios"],
            L["wn_110_showme"],
            L["wn_110_search"],
            L["wn_110_adventure"],
            L["wn_110_xpbar"],
            L["wn_110_power"],
            L["wn_110_anim"],
        },
    },
    {
        version = "1.0.1",
        highlights = {
            L["wn_101_minimap_daycycle"],
            L["wn_101_minimap_zonetext"],
            L["wn_101_minimap_persist"],
            L["wn_101_player_power"],
            L["wn_101_power_toggle"],
        },
    },
    {
        version = "1.0.0",
        highlights = {
            L["wn_100_first_release"],
            L["wn_100_removed_modules"],
            L["wn_100_palette"],
            L["wn_100_fresh_settings"],
        },
    },
}

WN.CHANGELOG = CHANGELOG

-- Returns the release list, newest first. Nil-safe for callers that load
-- before WhatsNew has run.
function WN.GetChangelog()
    return CHANGELOG
end

-- ============================================================
-- VERSION COMPARISON
-- ============================================================

local function GetCurrentVersion()
    return C_AddOns.GetAddOnMetadata("TomoModForever", "Version") or "0.0.0"
end

local function ShouldShow()
    if not TomoModForeverDB then return false end
    local current = GetCurrentVersion()
    local seen    = TomoModForeverDB.lastSeenVersion or ""
    return seen ~= current
end

local function MarkSeen()
    if TomoModForeverDB then
        TomoModForeverDB.lastSeenVersion = GetCurrentVersion()
    end
end

-- ============================================================
-- GATES
-- ============================================================

-- Per-character login counter. TomoModForeverCharDB is declared as
-- SavedVariablesPerCharacter in the TOC, so it starts empty on every
-- freshly created character. A /reload counts as a login, which is
-- fine: past the first one, the player is out of the intro sequence.
local function BumpLoginCount()
    if type(_G.TomoModForeverCharDB) ~= "table" then _G.TomoModForeverCharDB = {} end
    local db = _G.TomoModForeverCharDB
    db.loginCount = (tonumber(db.loginCount) or 0) + 1
    return db.loginCount
end

-- A brand-new character should not be greeted by a changelog while it
-- is still in the intro sequence, so the popup waits for login #2.
function WN.IsReturningCharacter()
    local db = _G.TomoModForeverCharDB
    return (tonumber(db and db.loginCount) or 0) >= 2
end

-- Never put a full-screen modal in front of a cinematic or a fight.
local function IsBlocked()
    if _G.CinematicFrame and _G.CinematicFrame:IsShown() then return true end
    if _G.MovieFrame and _G.MovieFrame:IsShown() then return true end
    if type(_G.InCinematic) == "function" and InCinematic() then return true end
    if InCombatLockdown() or UnitAffectingCombat("player") then return true end
    return false
end

-- ============================================================
-- FIND ENTRY FOR CURRENT VERSION
-- ============================================================

local function GetCurrentEntry()
    local ver = GetCurrentVersion()
    for _, entry in ipairs(CHANGELOG) do
        if entry.version == ver then
            return entry
        end
    end
    return nil
end

-- ============================================================
-- UI
-- ============================================================

local frame

local function CreateFrame_WN()
    if frame then return frame end

    local backdrop = {
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 2,
        insets   = { left = 2, right = 2, top = 2, bottom = 2 },
    }

    -- Dimmer
    local dimmer = CreateFrame("Frame", nil, UIParent)
    dimmer:SetFrameStrata("DIALOG")
    dimmer:SetFrameLevel(140)
    dimmer:SetAllPoints()
    local dimTex = dimmer:CreateTexture(nil, "BACKGROUND")
    dimTex:SetAllPoints()
    dimTex:SetColorTexture(0, 0, 0, 0.50)
    dimmer:EnableMouse(true)
    -- [fix] Created hidden, exactly like Config/Installer.lua's dimmer.
    -- CreateFrame() returns a SHOWN frame, so the old code put a
    -- full-screen mouse blocker on screen the instant this function ran;
    -- any error later in construction left it there with no way out.
    dimmer:Hide()

    -- Main panel
    frame = CreateFrame("Frame", "TomoModWhatsNewFrame", dimmer, "BackdropTemplate")
    frame:SetSize(PANEL_W, PANEL_H)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetFrameLevel(141)
    frame:SetBackdrop(backdrop)
    frame:SetBackdropColor(BG[1], BG[2], BG[3], BG[4])
    frame:SetBackdropBorderColor(A[1], A[2], A[3], 0.40)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()

    frame._dimmer = dimmer

    -- [fix] Single authority for closing. Whatever hides the panel --
    -- the X, the OK button, Escape, or any external Hide() -- lands
    -- here, so the dimmer can no longer outlive it and the version is
    -- always marked as seen.
    frame:SetScript("OnHide", function(self)
        -- An ancestor hiding us (UIParent during a cinematic) also fires
        -- OnHide, but leaves our own shown flag set. That is not a close:
        -- swallowing it would mark the version seen without the player
        -- ever having read it.
        if self:IsShown() then return end
        dimmer:Hide()
        -- Reading an old release from the Changelog page is browsing, not
        -- acknowledging this update: marking it seen here would swallow the
        -- notice for a version the player has not read yet.
        if self._browsing then
            self._browsing = nil
            return
        end
        MarkSeen()
    end)

    -- [fix] Escape handled here instead of via UISpecialFrames, which
    -- routes through ToggleGameMenu -> ClearTarget() (protected) and
    -- taints. Same pattern as Core/Forge/ForgeStudio.lua, including the
    -- combat guard: SetPropagateKeyboardInput is itself protected and
    -- throws ADDON_ACTION_BLOCKED on every keypress in combat.
    frame:EnableKeyboard(true)
    frame:SetScript("OnKeyDown", function(self, key)
        if InCombatLockdown() then return end
        if key == "ESCAPE" then
            self:SetPropagateKeyboardInput(false)
            WN.Hide()
        else
            self:SetPropagateKeyboardInput(true)
        end
    end)

    -- Header bar
    local header = CreateFrame("Frame", nil, frame)
    header:SetHeight(48)
    header:SetPoint("TOPLEFT", 0, 0)
    header:SetPoint("TOPRIGHT", 0, 0)
    local hbg = header:CreateTexture(nil, "BACKGROUND")
    hbg:SetAllPoints()
    hbg:SetColorTexture(0.063, 0.052, 0.040, 1)

    -- Logo
    local logo = header:CreateTexture(nil, "ARTWORK")
    logo:SetSize(24, 24)
    logo:SetPoint("LEFT", 14, 0)
    logo:SetTexture(LOGO_TEX)
    logo:SetVertexColor(A[1], A[2], A[3], 1)

    -- Title
    local title = header:CreateFontString(nil, "ARTWORK")
    title:SetFont(FONT_BOLD, 14)
    title:SetPoint("LEFT", logo, "RIGHT", 8, 0)
    title:SetTextColor(TX[1], TX[2], TX[3])
    frame._title = title

    -- Close button
    local close = CreateFrame("Button", nil, header)
    close:SetSize(28, 28)
    close:SetPoint("RIGHT", -10, 0)
    close:SetNormalFontObject(GameFontNormalLarge)
    local closeTxt = close:CreateFontString(nil, "ARTWORK")
    closeTxt:SetFont(FONT_BOLD, 18)
    closeTxt:SetPoint("CENTER")
    closeTxt:SetText("×")
    closeTxt:SetTextColor(DM[1], DM[2], DM[3])
    close:SetScript("OnEnter", function() closeTxt:SetTextColor(1, 0.3, 0.3) end)
    close:SetScript("OnLeave", function() closeTxt:SetTextColor(DM[1], DM[2], DM[3]) end)
    close:SetScript("OnClick", function() WN.Hide() end)

    -- Accent line under header
    local accent = frame:CreateTexture(nil, "ARTWORK")
    accent:SetHeight(1)
    accent:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, 0)
    accent:SetPoint("TOPRIGHT", header, "BOTTOMRIGHT", 0, 0)
    accent:SetColorTexture(A[1], A[2], A[3], 0.60)

    -- Scroll frame for content
    local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 12, -12)
    scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -28, 52)

    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetWidth(PANEL_W - 44)
    scrollFrame:SetScrollChild(scrollChild)


    -- Style scrollbar (hidden if not needed, modern look if shown)
    local sb = scrollFrame.ScrollBar
    if sb then
        Mixin(sb, BackdropTemplateMixin)
        sb:SetWidth(7)
        sb:ClearAllPoints()
        sb:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", 2, -2)
        sb:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", 2, 2)
        sb:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        sb:SetBackdropColor(0.145, 0.121, 0.091, 0.18)
        sb:SetBackdropBorderColor(A[1], A[2], A[3], 0.18)
        local thumb = sb:GetThumbTexture()
        if thumb then
            thumb:SetColorTexture(A[1], A[2], A[3], 0.55)
            thumb:SetWidth(7)
            thumb:SetHeight(32)
            thumb:SetTexelSnappingBias(0)
            thumb:SetSnapToPixelGrid(false)
            -- Arrondi visuel (simulateur)
            if not sb._thumbBG then
                local bg = sb:CreateTexture(nil, "BACKGROUND")
                bg:SetColorTexture(0.145, 0.121, 0.091, 0.22)
                bg:SetPoint("TOPLEFT", sb, "TOPLEFT", 1, -1)
                bg:SetPoint("BOTTOMRIGHT", sb, "BOTTOMRIGHT", -1, 1)
                sb._thumbBG = bg
            end
        end
        -- UIPanelScrollFrameTemplate ships two gold arrow buttons. The bar
        -- itself was restyled but the arrows were left alone, so the panel
        -- ended up with Blizzard's brass at both ends of a mint track.
        for _, name in ipairs({ "ScrollUpButton", "ScrollDownButton", "Back", "Forward" }) do
            local btn = sb[name]
            if btn then
                btn:Hide()
                btn:SetAlpha(0)
                btn:EnableMouse(false)
                -- Blizzard's scroll code re-shows these on update, so a
                -- one-off Hide does not hold.
                btn:SetScript("OnShow", btn.Hide)
            end
        end
        -- Reclaim the space the arrows had reserved at both ends.
        sb:ClearAllPoints()
        sb:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", 2, 0)
        sb:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", 2, 0)

        sb:Hide() -- caché par défaut, affiché si besoin
    end

    frame._scrollChild = scrollChild
    frame._scrollFrame = scrollFrame

    -- OK button
    local okBtn = CreateFrame("Button", nil, frame, "BackdropTemplate")
    okBtn:SetSize(140, 34)
    okBtn:SetPoint("BOTTOM", 0, 12)
    okBtn:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets   = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    okBtn:SetBackdropColor(A[1], A[2], A[3], 0.15)
    okBtn:SetBackdropBorderColor(A[1], A[2], A[3], 0.40)
    local okTxt = okBtn:CreateFontString(nil, "ARTWORK")
    okTxt:SetFont(FONT_BOLD, 13)
    okTxt:SetPoint("CENTER")
    okTxt:SetText(L["wn_btn_ok"])
    okTxt:SetTextColor(A[1], A[2], A[3])
    okBtn:SetScript("OnEnter", function()
        okBtn:SetBackdropColor(A[1], A[2], A[3], 0.30)
    end)
    okBtn:SetScript("OnLeave", function()
        okBtn:SetBackdropColor(A[1], A[2], A[3], 0.15)
    end)
    okBtn:SetScript("OnClick", function() WN.Hide() end)

    return frame
end

-- ============================================================
-- POPULATE CONTENT
-- ============================================================


local function PopulateContent(entry)
    local f = CreateFrame_WN()
    local parent = f._scrollChild
    local scrollFrame = f._scrollFrame

    -- Clear old children
    for _, child in ipairs({ parent:GetChildren() }) do
        child:Hide()
        child:SetParent(nil)
    end
    for _, region in ipairs({ parent:GetRegions() }) do
        region:Hide()
        region:SetParent(nil)
    end

    f._title:SetText("TomoModForever — " .. L["wn_title"])

    local y = 0

    -- Version badge
    local verText = parent:CreateFontString(nil, "ARTWORK")
    verText:SetFont(FONT_BOLD, 18)
    verText:SetPoint("TOPLEFT", 0, y)
    verText:SetText(string.format(L["wn_version"], entry.version))
    verText:SetTextColor(A[1], A[2], A[3])
    y = y - 30

    -- Subtitle
    local sub = parent:CreateFontString(nil, "ARTWORK")
    sub:SetFont(FONT, 12)
    sub:SetPoint("TOPLEFT", 0, y)
    sub:SetText(L["wn_subtitle"])
    sub:SetTextColor(DM[1], DM[2], DM[3])
    y = y - 24

    -- Separator
    local sep = parent:CreateTexture(nil, "ARTWORK")
    sep:SetHeight(1)
    sep:SetPoint("TOPLEFT", 0, y)
    sep:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, y)
    sep:SetColorTexture(A[1], A[2], A[3], 0.25)
    y = y - 16

    -- Highlights
    for _, text in ipairs(entry.highlights) do
        local bullet = parent:CreateFontString(nil, "ARTWORK")
        bullet:SetFont(FONT, 12.5)
        bullet:SetPoint("TOPLEFT", 4, y)
        bullet:SetWidth(PANEL_W - 64)
        bullet:SetJustifyH("LEFT")
        bullet:SetWordWrap(true)
        bullet:SetSpacing(3)
        bullet:SetText("|cffffd100•|r  " .. text)
        bullet:SetTextColor(TX[1], TX[2], TX[3])
        local textH = bullet:GetStringHeight() or 16
        y = y - textH - 10
    end

    y = y - 8

    -- Reminder: /tm
    local remind = parent:CreateFontString(nil, "ARTWORK")
    remind:SetFont(FONT, 11)
    remind:SetPoint("TOPLEFT", 0, y)
    remind:SetWidth(PANEL_W - 64)
    remind:SetJustifyH("LEFT")
    remind:SetWordWrap(true)
    remind:SetText(L["wn_footer"])
    remind:SetTextColor(DM[1], DM[2], DM[3])
    y = y - (remind:GetStringHeight() or 14) - 8

    parent:SetHeight(math.abs(y) + 20)

    -- Hide scrollbar if not needed, show and style if needed
    if scrollFrame and scrollFrame.ScrollBar then
        local contentH = parent:GetHeight()
        local viewH = scrollFrame:GetHeight()
        if contentH <= viewH + 2 then
            scrollFrame.ScrollBar:Hide()
            scrollFrame:EnableMouseWheel(false)
        else
            scrollFrame.ScrollBar:Show()
            scrollFrame:EnableMouseWheel(true)
        end
    end
end

-- ============================================================
-- SHOW / HIDE
-- ============================================================

-- Bypasses every gate on purpose: this is the manual/debug entry point.
-- The automatic path is WN.TryShow().
function WN.Show()
    local entry = GetCurrentEntry()
    if not entry then
        MarkSeen()
        return
    end
    -- Content is built BEFORE anything becomes visible: both frames are
    -- created hidden, so an error in PopulateContent leaves a clean
    -- screen instead of a dimmer with no dialog behind it.
    PopulateContent(entry)
    frame._dimmer:Show()
    frame:Show()
end

-- Opens the popup on a given release, for the Changelog config page.
--
-- The page used to lay the notes out inline and they came out overlapping:
-- the info-text widget measures its height right after SetText, before the
-- frame has a width, so a wrapped paragraph measures as a single line. This
-- popup already solves that with a real scroll frame, so the page hands the
-- text to it rather than growing a second layout engine.
function WN.ShowVersion(version)
    if type(CHANGELOG) ~= "table" then return false end

    local entry
    for _, rel in ipairs(CHANGELOG) do
        if tostring(rel.version) == tostring(version) then entry = rel; break end
    end
    if not entry then return false end

    if not frame then CreateFrame_WN() end
    if not frame then return false end

    PopulateContent(entry)
    frame._browsing = true
    frame._dimmer:Show()
    frame:Show()
    return true
end

function WN.Hide()
    -- The OnHide script hides the dimmer and calls MarkSeen().
    if frame then
        frame:Hide()
    else
        MarkSeen()
    end
end

-- ============================================================
-- AUTO TRIGGER (called from Init.lua)
-- ============================================================

-- Retry cadence while a cinematic or a fight is in the way. The ceiling
-- is generous (~5 min) but finite: past it we give up WITHOUT marking
-- the version seen, so the changelog simply shows up next session.
local RETRY_DELAY  = 2
local MAX_ATTEMPTS = 150

function WN.TryShow(attempt)
    attempt = tonumber(attempt) or 1
    if not ShouldShow() then return end

    -- Skip if installer is about to show (first run)
    if TomoModForeverDB and TomoModForeverDB.installer and not TomoModForeverDB.installer.completed then
        MarkSeen()
        return
    end

    -- [fix] A character's very first login is the intro sequence:
    -- cinematic, first steps, and a player who has not asked for a
    -- changelog yet. Deliberately no MarkSeen() here -- the popup is
    -- postponed, not consumed.
    if not WN.IsReturningCharacter() then return end

    if IsBlocked() then
        if attempt < MAX_ATTEMPTS then
            C_Timer.After(RETRY_DELAY, function() WN.TryShow(attempt + 1) end)
        end
        return
    end

    WN.Show()
end

-- ============================================================
-- PER-CHARACTER LOGIN COUNTER
-- ============================================================
-- PLAYER_LOGIN fires once per session and well before Init.lua's
-- 3-second TryShow timer, so the counter is always up to date by the
-- time the gate reads it.
local loginWatcher = CreateFrame("Frame")
loginWatcher:RegisterEvent("PLAYER_LOGIN")
loginWatcher:SetScript("OnEvent", function(self)
    self:UnregisterAllEvents()
    BumpLoginCount()
end)
