-- =====================================================================
-- ActionBarSkin.lua -- cosmetic skins for Blizzard's own action bars
--
-- Look only. The bars stay Blizzard's: no button is moved, resized,
-- reparented, shown or hidden, and no attribute is written, so the
-- secure action system is never touched. What changes:
--   * regions of each button (icon crop, Blizzard border art alpha,
--     hotkey / count / macro-name fonts),
--   * a few textures and one non-secure child frame added per button
--     for the border, background, gloss and shadow.
-- Creating those is done out of combat only; recolouring is safe anytime.
-- State lives in weak tables keyed by the button, never in the button
-- table itself, so Blizzard code never reads a field written by us.
-- =====================================================================

TomoMod_ActionBarSkin = TomoMod_ActionBarSkin or {}
local ABS = TomoMod_ActionBarSkin

local MEDIA  = "Interface\\AddOns\\TomoModForever\\Assets\\Textures\\ActionBars\\"
local WHITE  = "Interface\\Buttons\\WHITE8x8"
local FONT   = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local RING   = MEDIA .. "ring"
local MASK   = MEDIA .. "mask_round"
local GLOSS  = MEDIA .. "gloss"
local SHADOW = MEDIA .. "shadow"

-- ---------------------------------------------------------------------
-- Skins. border = px, color = default border colour, inner = dark inner
-- line, round = circular icon, gloss / shadow = extra layers.
-- ---------------------------------------------------------------------
ABS.SKINS = {
    forever = { border = 1, color = { 0.545, 0.420, 0.247 }, inner = true },
    pixel   = { border = 1, color = { 0, 0, 0 } },
    thick   = { border = 2, color = { 0.788, 0.635, 0.322 }, inner = true },
    shadow  = { border = 1, color = { 0, 0, 0 }, shadow = true },
    glass   = { border = 1, color = { 0.10, 0.10, 0.10 }, gloss = true, inner = true },
    round   = { round = true, color = { 0.788, 0.635, 0.322 } },
}
ABS.SKIN_ORDER = { "forever", "pixel", "thick", "shadow", "glass", "round" }

local BUTTONS = {
    { "ActionButton", 12 }, { "MultiBarBottomLeftButton", 12 }, { "MultiBarBottomRightButton", 12 },
    { "MultiBarRightButton", 12 }, { "MultiBarLeftButton", 12 }, { "MultiBar5Button", 12 },
    { "MultiBar6Button", 12 }, { "MultiBar7Button", 12 }, { "PetActionButton", 10 },
    { "StanceButton", 10 }, { "PossessButton", 2 }, { "OverrideActionBarButton", 6 },
    { "ExtraActionButton", 1 },
}

local state  = setmetatable({}, { __mode = "k" })  -- button -> our layers
local hooked = setmetatable({}, { __mode = "k" })
local skinned = {}                                 -- list of buttons touched
local pending = false

local function DB()
    return TomoModForeverDB and TomoModForeverDB.barSkin
end

local function Active()
    local db = DB()
    return db and db.enabled ~= false and ABS.SKINS[db.skin or "forever"] ~= nil
end

local function BorderColor(skin)
    local db = DB() or {}
    if db.borderMode == "class" then
        local _, cls = UnitClass("player")
        local c = cls and RAID_CLASS_COLORS and RAID_CLASS_COLORS[cls]
        if c then return c.r, c.g, c.b end
    elseif db.borderMode == "custom" and type(db.borderColor) == "table" then
        return db.borderColor.r or 1, db.borderColor.g or 1, db.borderColor.b or 1
    end
    return skin.color[1], skin.color[2], skin.color[3]
end

-- A region field of a button, only when it really is a region.
local function F(b, k) local v = b[k]; if type(v) == "table" then return v end end
local function IconOf(b) return F(b, "icon") or F(b, "Icon") end

-- Mask calls are wrapped: adding a mask twice or removing one that is not
-- attached must never break a skin pass.
local function AddMask(t, m) if t and m and t.AddMaskTexture then pcall(t.AddMaskTexture, t, m) end end
local function DelMask(t, m) if t and m and t.RemoveMaskTexture then pcall(t.RemoveMaskTexture, t, m) end end

-- Blizzard's own decoration on a button. Alpha only: Blizzard keeps
-- re-applying these, the hooks below just put the alpha back.
local OVERLAYS = { "HighlightTexture", "PushedTexture", "CheckedTexture", "SpellHighlightTexture", "NewActionTexture" }
-- "Border" is left alone: it is the green "equipped item" outline.
local ART = { "SlotArt", "SlotBackground", "FloatingBG", "BorderShadow", "NormalTexture" }

local function HideArt(b, hide)
    local a = hide and 0 or 1
    for _, k in ipairs(ART) do
        local r = b[k]
        if type(r) == "table" and r.SetAlpha then r:SetAlpha(a) end
    end
    local nt = b.GetNormalTexture and b:GetNormalTexture()
    if nt then nt:SetAlpha(a) end
end

-- Remember the icon's original anchors and masks once, to undo cleanly.
local function Remember(b, st)
    if st.saved then return end
    local icon = IconOf(b)
    st.saved = true
    st.points = {}
    if icon and icon.GetNumPoints then
        for i = 1, icon:GetNumPoints() do st.points[i] = { icon:GetPoint(i) } end
    end
    st.masks = {}
    if icon and icon.GetMaskTexture then
        for i = 1, 8 do
            local m = icon:GetMaskTexture(i)
            if m then st.masks[#st.masks + 1] = m end
        end
    end
end

local function Layers(b, st)
    if st.frame then return end
    -- Background behind the icon (button region, lowest sublevel).
    st.bg = b:CreateTexture(nil, "BACKGROUND", nil, -8)
    st.bg:SetTexture(WHITE)
    -- Edge-only overlay above the icon: no fill, so nothing is hidden.
    local f = CreateFrame("Frame", nil, b, "BackdropTemplate")
    f:SetAllPoints(b)
    f:SetFrameLevel(b:GetFrameLevel() + 2)
    f:EnableMouse(false)
    st.frame = f
    st.inner = CreateFrame("Frame", nil, f, "BackdropTemplate")
    st.inner:EnableMouse(false)
    st.gloss = f:CreateTexture(nil, "OVERLAY")
    st.gloss:SetTexture(GLOSS)
    st.ring = f:CreateTexture(nil, "OVERLAY")
    st.ring:SetTexture(RING)
    st.ring:SetAllPoints(b)
    st.shadow = b:CreateTexture(nil, "BACKGROUND", nil, -7)
    st.shadow:SetTexture(SHADOW)
    st.shadow:SetVertexColor(0, 0, 0, 0.85)
    st.mask = b:CreateMaskTexture()
    st.mask:SetTexture(MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    st.mask:SetAllPoints(b)
end

local function StyleText(b)
    local db = DB() or {}
    local font = db.font or FONT
    local hk = F(b, "HotKey") or F(b, "hotKey")
    if hk and hk.SetFont then
        hk:SetFont(font, db.hotkeySize or 11, "OUTLINE")
        hk:SetAlpha(db.showHotkey == false and 0 or 1)
    end
    local ct = F(b, "Count")
    if ct and ct.SetFont then ct:SetFont(font, db.countSize or 12, "OUTLINE") end
    local nm = F(b, "Name")
    if nm and nm.SetAlpha then
        nm:SetFont(font, 9, "OUTLINE")
        nm:SetAlpha(db.showMacroName == false and 0 or 1)
    end
end

-- Skin one button (or a preview frame shaped like one).
function ABS.Skin(b, skinKey)
    if not b then return end
    local st = state[b]
    if not st then st = {}; state[b] = st end
    local icon = IconOf(b)
    local skin = ABS.SKINS[skinKey or (DB() or {}).skin or "forever"]
    if not skin or not icon then return end
    Remember(b, st)
    Layers(b, st)

    local db = DB() or {}
    local px = skin.border or 0
    local zoom = tonumber(db.zoom) or 0.08
    local w = b:GetWidth() or 36
    if w < 1 then w = 36 end

    HideArt(b, true)
    -- Masks: square skins drop Blizzard's rounded-corner mask, round adds ours.
    for _, m in ipairs(st.masks) do DelMask(icon, m) end
    DelMask(icon, st.mask)
    if F(b, "IconMask") then b.IconMask:SetAlpha(0) end

    icon:ClearAllPoints()
    if skin.round then
        icon:SetAllPoints(b)
        icon:SetTexCoord(0, 1, 0, 1)
        AddMask(icon, st.mask)
    else
        icon:SetPoint("TOPLEFT", b, "TOPLEFT", px, -px)
        icon:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -px, px)
        icon:SetTexCoord(zoom, 1 - zoom, zoom, 1 - zoom)
    end

    local r, g, bl = BorderColor(skin)
    st.frame:Show()
    if skin.round then
        st.frame:SetBackdrop(nil)
        st.inner:Hide()
        st.ring:Show()
        st.ring:SetVertexColor(r, g, bl, 1)
        st.bg:Hide()
    else
        st.ring:Hide()
        st.frame:SetBackdrop({ edgeFile = WHITE, edgeSize = px })
        st.frame:SetBackdropBorderColor(r, g, bl, 1)
        st.bg:Show()
        st.bg:ClearAllPoints()
        st.bg:SetAllPoints(b)
        st.bg:SetVertexColor(0.04, 0.035, 0.03, 0.85)
        if skin.inner then
            st.inner:Show()
            st.inner:ClearAllPoints()
            st.inner:SetPoint("TOPLEFT", px, -px)
            st.inner:SetPoint("BOTTOMRIGHT", -px, px)
            st.inner:SetBackdrop({ edgeFile = WHITE, edgeSize = 1 })
            st.inner:SetBackdropBorderColor(0, 0, 0, 0.9)
        else
            st.inner:Hide()
        end
    end

    st.gloss:SetShown(skin.gloss and true or false)
    if skin.gloss then
        st.gloss:ClearAllPoints()
        st.gloss:SetPoint("TOPLEFT", icon, "TOPLEFT")
        st.gloss:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT")
    end

    st.shadow:SetShown(skin.shadow and true or false)
    if skin.shadow then
        local pad = math.floor(w * 0.3 + 0.5)
        st.shadow:ClearAllPoints()
        st.shadow:SetPoint("TOPLEFT", b, "TOPLEFT", -pad, pad)
        st.shadow:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", pad, -pad)
    end

    -- Hover / pressed / checked follow the icon shape.
    for _, k in ipairs(OVERLAYS) do
        local t = F(b, k)
        DelMask(t, st.mask)
        if skin.round then AddMask(t, st.mask) end
    end

    local cd = F(b, "cooldown") or F(b, "Cooldown")
    if cd and cd.SetSwipeTexture then
        cd:SetSwipeTexture(skin.round and MASK or WHITE)
        cd:SetSwipeColor(0, 0, 0, 0.75)
    end

    StyleText(b)
    st.skinned = true
end

-- Back to Blizzard's look.
function ABS.Unskin(b)
    local st = state[b]
    if not (st and st.skinned) then return end
    local icon = IconOf(b)
    HideArt(b, false)
    if F(b, "IconMask") then b.IconMask:SetAlpha(1) end
    if icon then
        DelMask(icon, st.mask)
        for _, m in ipairs(st.masks or {}) do AddMask(icon, m) end
        icon:SetTexCoord(0, 1, 0, 1)
        if st.points and #st.points > 0 then
            icon:ClearAllPoints()
            for _, p in ipairs(st.points) do icon:SetPoint(unpack(p)) end
        end
    end
    for _, k in ipairs(OVERLAYS) do DelMask(F(b, k), st.mask) end
    local cd = F(b, "cooldown") or F(b, "Cooldown")
    if cd and cd.SetSwipeTexture then cd:SetSwipeTexture(WHITE) end
    if st.frame then st.frame:Hide() end
    if st.bg then st.bg:Hide() end
    if st.shadow then st.shadow:Hide() end
    st.skinned = false
end

-- Blizzard re-applies its art on every slot change: put our alpha back.
local function Reassert(b)
    local st = state[b]
    if st and st.skinned and Active() then
        HideArt(b, true)
        if F(b, "IconMask") then b.IconMask:SetAlpha(0) end
    end
end

local function Hook(b)
    if hooked[b] then return end
    hooked[b] = true
    for _, m in ipairs({ "UpdateButtonArt", "SetNormalAtlas", "SetNormalTexture" }) do
        if type(b[m]) == "function" then hooksecurefunc(b, m, Reassert) end
    end
    if type(b.UpdateHotkeys) == "function" then
        hooksecurefunc(b, "UpdateHotkeys", function(self)
            local st = state[self]
            if st and st.skinned and Active() then StyleText(self) end
        end)
    end
end

-- Bar art (end caps, border strip). Alpha only, reversible.
local function BarArt()
    local db = DB() or {}
    local hide = Active() and db.hideArt
    for _, barName in ipairs({ "MainActionBar", "MainMenuBar" }) do
        local bar = _G[barName]
        if bar then
            for _, k in ipairs({ "EndCaps", "BorderArt", "Background" }) do
                local r = bar[k]
                if type(r) == "table" and r.SetAlpha then r:SetAlpha(hide and 0 or 1) end
            end
        end
    end
end

local function ForEachButton(fn)
    for _, def in ipairs(BUTTONS) do
        for i = 1, def[2] do
            local b = _G[def[1] .. i]
            if b then fn(b) end
        end
    end
end

function ABS.ApplySettings()
    if InCombatLockdown() then
        pending = true
        return
    end
    pending = false
    local on = Active()
    ForEachButton(function(b)
        if on then
            Hook(b)
            ABS.Skin(b)
        else
            ABS.Unskin(b)
        end
    end)
    BarArt()
end

-- =====================================================================
-- Per-bar visibility: on mouseover and / or in combat / with a target.
-- Alpha only (allowed in combat, never protected): the bar keeps working,
-- keybinds still fire, and a faded bar can still be clicked where it sits.
-- Hover is read by polling IsMouseOver on the bar, so nothing is hooked on
-- the secure buttons. Bars always show while Blizzard's Edit Mode or the
-- TomoMod move mode is open, and while a spell or item is on the cursor.
-- =====================================================================
ABS.BAR_KEYS = { "bar1", "bar2", "bar3", "bar4", "bar5", "bar6", "bar7", "bar8", "pet", "stance" }
local BAR_FRAMES = {
    bar1   = { "MainActionBar", "MainMenuBar" },
    bar2   = { "MultiBarBottomLeft" },
    bar3   = { "MultiBarBottomRight" },
    bar4   = { "MultiBarRight" },
    bar5   = { "MultiBarLeft" },
    bar6   = { "MultiBar5" },
    bar7   = { "MultiBar6" },
    bar8   = { "MultiBar7" },
    pet    = { "PetActionBar", "PetActionBarFrame" },
    stance = { "StanceBar", "StanceBarFrame" },
}

local function BarFrame(key)
    for _, name in ipairs(BAR_FRAMES[key] or {}) do
        local f = _G[name]
        if type(f) == "table" and f.SetAlpha then return f end
    end
end

local fadeState = {}   -- key -> current alpha
local fader

local function ForceShow()
    if EditModeManagerFrame and EditModeManagerFrame.IsShown and EditModeManagerFrame:IsShown() then return true end
    local M = TomoMod_Movers
    if M and M.IsUnlocked and M.IsUnlocked() then return true end
    if GetCursorInfo and GetCursorInfo() then return true end
    if SpellFlyout and SpellFlyout.IsShown and SpellFlyout:IsShown() then return true end
    return false
end

local function WantVisible(key, cfg, bar)
    if not (cfg.mouseover or cfg.combat) then return true end
    if ForceShow() then return true end
    if cfg.combat and (InCombatLockdown() or UnitExists("target")) then return true end
    if cfg.mouseover and bar:IsMouseOver(4, -4, -4, 4) then return true end
    if cfg.mouseover and SpellFlyout and SpellFlyout.IsMouseOver and SpellFlyout:IsShown() and SpellFlyout:IsMouseOver() then return true end
    return false
end

local function AnyFade(db)
    for _, k in ipairs(ABS.BAR_KEYS) do
        local cfg = db.bars and db.bars[k]
        if type(cfg) == "table" and (cfg.mouseover or cfg.combat) then return true end
    end
    return false
end

local function FadeTick(_, elapsed)
    local db = DB()
    if not db then return end
    local low  = tonumber(db.fadeAlpha) or 0
    local time = math.max(0.01, tonumber(db.fadeTime) or 0.2)
    local step = (elapsed or 0.05) / time
    for _, k in ipairs(ABS.BAR_KEYS) do
        local bar = BarFrame(k)
        local cfg = db.bars and db.bars[k]
        if bar and type(cfg) == "table" then
            local goal = WantVisible(k, cfg, bar) and 1 or low
            -- Read back the real alpha: Blizzard may reset it (Edit Mode
            -- opacity, bar refresh), and the fade then simply resumes.
            local cur = bar:GetAlpha() or 1
            if math.abs(cur - goal) < 0.01 then cur = goal end
            if cur ~= goal then
                if cur < goal then cur = math.min(goal, cur + step) else cur = math.max(goal, cur - step) end
                fadeState[k] = cur
                bar:SetAlpha(cur)
            end
        end
    end
end

ABS._FadeTickForTest = function(dt) FadeTick(nil, dt) end

function ABS.ApplyFade()
    local db = DB()
    if not db then return end
    if not fader then
        fader = CreateFrame("Frame")
        fader.acc = 0
        fader:SetScript("OnUpdate", function(self, elapsed)
            self.acc = self.acc + elapsed
            if self.acc < 0.05 then return end
            FadeTick(self, self.acc)
            self.acc = 0
        end)
    end
    if AnyFade(db) then
        fader:Show()
    else
        fader:Hide()
    end
    -- Bars with no condition (or all, when nothing fades) go back to full.
    for _, k in ipairs(ABS.BAR_KEYS) do
        local cfg = db.bars and db.bars[k]
        if not (type(cfg) == "table" and (cfg.mouseover or cfg.combat)) then
            local bar = BarFrame(k)
            if bar and fadeState[k] and fadeState[k] ~= 1 then bar:SetAlpha(1) end
            fadeState[k] = nil
        end
    end
end

function ABS.Initialize()
    ABS.ApplySettings()
    ABS.ApplyFade()
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
ev:RegisterEvent("PET_BAR_UPDATE")
ev:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
ev:SetScript("OnEvent", function(_, event)
    -- Bar visibility runs whether or not the skin itself is on.
    if event == "PLAYER_ENTERING_WORLD" then ABS.ApplyFade() end
    if event == "PLAYER_REGEN_ENABLED" then
        if pending then ABS.ApplySettings() end
        return
    end
    if not Active() then
        if event == "PLAYER_ENTERING_WORLD" then BarArt() end
        return
    end
    -- New buttons can appear (pet, stance, override): skin them out of combat.
    C_Timer.After(0.2, ABS.ApplySettings)
end)
