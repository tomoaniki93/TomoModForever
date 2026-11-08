-- =====================================================================
-- Modules/QOL/Forever/BagAlert.lua -- "your bags are nearly full" banner
--
-- An animated banner in the Forever palette that tells you how full your
-- bags are before you head out:
--
--   * at login, when the bags are past the threshold (90 % by default);
--   * while playing, the moment looting crosses the threshold, and once
--     more when the last slot goes. It re-arms when you free space.
--
-- Only general-purpose bags count: a quiver, an ammo pouch or a soul bag
-- cannot take your loot, so their slots would make the bags look emptier
-- than they are. Grey items are counted with their vendor value, since
-- they are the first thing to sell.
--
-- The banner pops in, the bar and the percentage count up, the bag icon
-- shakes and the border pulses when past the threshold, then it fades out
-- (the timer waits while the mouse is over it). Left click opens the bags,
-- right click closes the banner. Not a secure frame: safe in combat, but
-- an alert raised in combat waits for the end of the fight.
-- =====================================================================

TomoMod_BagAlert = TomoMod_BagAlert or {}
local BA = TomoMod_BagAlert

local FONT      = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local FONT_BOLD = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-SemiBold.ttf"
local SOLID     = "Interface\\Buttons\\WHITE8X8"
local BAG_ICON  = "Interface\\Icons\\INV_Misc_Bag_08"

-- WoW: Forever palette
local BRONZE = { 0.545, 0.420, 0.247 }   -- #8B6B3F
local GOLD   = { 0.788, 0.635, 0.322 }   -- #C9A252
local YELLOW = { 1.000, 0.820, 0.000 }   -- #FFD100
local TEXT   = { 0.949, 0.922, 0.859 }   -- #F2EBDB
local WARN   = { 1.000, 0.560, 0.160 }   -- past the threshold
local FULL   = { 0.900, 0.220, 0.160 }   -- no slot left

local BAG_FIRST, BAG_LAST = 0, 4         -- backpack + four bag slots
local LOGIN_DELAY = 4                    -- seconds after the loading screen
local COUNT_TIME  = 0.9                  -- bar / percentage count-up
local FADE_TIME   = 0.5

local IS_FR = GetLocale() == "frFR"
local function T(fr, en)
    if TomoMod_GUIT then return TomoMod_GUIT(fr, en) end
    return IS_FR and fr or en
end

local function DB() return TomoModForeverDB and TomoModForeverDB.bagAlert end

local function Plain(v)
    if issecretvalue and issecretvalue(v) then return nil end
    return v
end

local function Coins(copper)
    if C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString then
        return C_CurrencyInfo.GetCoinTextureString(copper)
    elseif GetCoinTextureString then
        return GetCoinTextureString(copper)
    end
    return tostring(copper)
end

-- ---------------------------------------------------------------------
-- Scan
-- ---------------------------------------------------------------------
-- Returns { total, free, used, pct, greys, greyValue }.
local function Scan()
    local s = { total = 0, free = 0, greys = 0, greyValue = 0 }
    if not C_Container then return s end
    for bag = BAG_FIRST, BAG_LAST do
        local slots = Plain(C_Container.GetContainerNumSlots(bag)) or 0
        if slots > 0 then
            local free, family = C_Container.GetContainerNumFreeSlots(bag)
            free, family = Plain(free), Plain(family)
            if (family or 0) == 0 then
                s.total = s.total + slots
                s.free = s.free + (free or 0)
            end
            for slot = 1, slots do
                local info = C_Container.GetContainerItemInfo(bag, slot)
                if info and Plain(info.quality) == 0 and not Plain(info.hasNoValue) then
                    s.greys = s.greys + 1
                    local link = Plain(info.hyperlink)
                    local price = link and C_Item and C_Item.GetItemInfo and select(11, C_Item.GetItemInfo(link))
                    price = Plain(price)
                    if type(price) == "number" and price > 0 then
                        s.greyValue = s.greyValue + price * (Plain(info.stackCount) or 1)
                    end
                end
            end
        end
    end
    s.used = s.total - s.free
    s.pct = s.total > 0 and math.floor(s.used / s.total * 100 + 0.5) or 0
    return s
end
BA.Scan = Scan

local function ColorFor(pct, free, threshold)
    if free == 0 then return FULL end
    if pct >= threshold then return WARN end
    return GOLD
end

-- ---------------------------------------------------------------------
-- Banner
-- ---------------------------------------------------------------------
local banner
local preview = false

local function Edge(parent, layer, sub)
    local t = parent:CreateTexture(nil, layer or "BORDER", nil, sub)
    t:SetTexture(SOLID)
    return t
end

local function Frame4(parent, layer, size, sub)
    local e = { Edge(parent, layer, sub), Edge(parent, layer, sub), Edge(parent, layer, sub), Edge(parent, layer, sub) }
    e[1]:SetPoint("TOPLEFT"); e[1]:SetPoint("TOPRIGHT"); e[1]:SetHeight(size)
    e[2]:SetPoint("BOTTOMLEFT"); e[2]:SetPoint("BOTTOMRIGHT"); e[2]:SetHeight(size)
    e[3]:SetPoint("TOPLEFT"); e[3]:SetPoint("BOTTOMLEFT"); e[3]:SetWidth(size)
    e[4]:SetPoint("TOPRIGHT"); e[4]:SetPoint("BOTTOMRIGHT"); e[4]:SetWidth(size)
    function e:SetColor(c, a) for i = 1, 4 do self[i]:SetVertexColor(c[1], c[2], c[3], a or 1) end end
    return e
end

local function StartFadeOut()
    if not banner or banner.fadeOut:IsPlaying() then return end
    banner.holdLeft = nil
    banner.fadeOut:Play()
end

local function OnUpdate(self, elapsed)
    -- Count-up of the bar and the percentage (ease-out).
    if self.countT then
        self.countT = math.min(COUNT_TIME, self.countT + elapsed)
        local k = self.countT / COUNT_TIME
        k = 1 - (1 - k) * (1 - k)
        local v = self.target * k
        self.bar:SetValue(v)
        self.pctFS:SetText(string.format("%d %%", math.floor(v + 0.5)))
        -- Width is only known once the frame is laid out: place here.
        local w = self.bar:GetWidth()
        self.spark:ClearAllPoints()
        self.spark:SetPoint("CENTER", self.bar, "LEFT", w * v / 100, 0)
        self.tick:ClearAllPoints()
        self.tick:SetPoint("CENTER", self.bar, "LEFT", w * (self.threshold or 90) / 100, 0)
        if self.countT >= COUNT_TIME then
            self.countT = nil
            if self.alarm then
                self.shake:Play()
                self.pulse:Play()
            end
        end
    end
    -- Hold, paused while hovered. Preview stays until switched off.
    if self.holdLeft and not preview and not self:IsMouseOver() then
        self.holdLeft = self.holdLeft - elapsed
        if self.holdLeft <= 0 then StartFadeOut() end
    end
end

local function CreateBanner()
    if banner then return banner end
    banner = CreateFrame("Button", "TomoMod_BagAlertFrame", UIParent)   -- not the module's own global name
    banner:SetSize(300, 62)
    banner:SetFrameStrata("HIGH")
    banner:SetClampedToScreen(true)
    banner:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    local bg = banner:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(SOLID)
    bg:SetVertexColor(0.06, 0.05, 0.04, 0.92)

    -- 1 px aged-bronze frame, and a 2 px coloured frame that pulses.
    banner.edge = Frame4(banner, "BORDER", 1)
    banner.edge:SetColor(BRONZE)
    local glow = CreateFrame("Frame", nil, banner)
    glow:SetPoint("TOPLEFT", -2, 2)
    glow:SetPoint("BOTTOMRIGHT", 2, -2)
    glow.edge = Frame4(glow, "OVERLAY", 2)
    glow:SetAlpha(0)
    banner.glow = glow

    -- Bag icon in its own bronze frame.
    local iconHolder = CreateFrame("Frame", nil, banner)
    iconHolder:SetSize(38, 38)
    iconHolder:SetPoint("LEFT", 10, 3)
    Frame4(iconHolder, "BORDER", 1):SetColor(GOLD)
    local icon = iconHolder:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("TOPLEFT", 1, -1)
    icon:SetPoint("BOTTOMRIGHT", -1, 1)
    icon:SetTexture(BAG_ICON)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    banner.icon = icon

    local title = banner:CreateFontString(nil, "OVERLAY")
    title:SetFont(FONT_BOLD, 13, "OUTLINE")
    title:SetPoint("TOPLEFT", iconHolder, "TOPRIGHT", 9, -1)
    title:SetJustifyH("LEFT")
    title:SetTextColor(YELLOW[1], YELLOW[2], YELLOW[3])
    banner.title = title

    local pctFS = banner:CreateFontString(nil, "OVERLAY")
    pctFS:SetFont(FONT_BOLD, 15, "OUTLINE")
    pctFS:SetPoint("TOPRIGHT", -10, -7)
    pctFS:SetJustifyH("RIGHT")
    banner.pctFS = pctFS
    title:SetPoint("RIGHT", pctFS, "LEFT", -6, 0)
    title:SetWordWrap(false)

    local sub = banner:CreateFontString(nil, "OVERLAY")
    sub:SetFont(FONT, 10, "OUTLINE")
    sub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -3)
    sub:SetPoint("RIGHT", banner, "RIGHT", -10, 0)
    sub:SetJustifyH("LEFT")
    sub:SetWordWrap(false)
    sub:SetTextColor(TEXT[1], TEXT[2], TEXT[3])
    banner.sub = sub

    local bar = CreateFrame("StatusBar", nil, banner)
    bar:SetPoint("BOTTOMLEFT", iconHolder, "BOTTOMRIGHT", 9, -6)
    bar:SetPoint("RIGHT", banner, "RIGHT", -10, 0)
    bar:SetHeight(6)
    bar:SetStatusBarTexture(SOLID)
    bar:SetMinMaxValues(0, 100)
    local barBg = bar:CreateTexture(nil, "BACKGROUND")
    barBg:SetAllPoints()
    barBg:SetTexture(SOLID)
    barBg:SetVertexColor(BRONZE[1], BRONZE[2], BRONZE[3], 0.25)
    banner.bar = bar

    local spark = bar:CreateTexture(nil, "OVERLAY")
    spark:SetTexture(SOLID)
    spark:SetVertexColor(YELLOW[1], YELLOW[2], YELLOW[3], 0.9)
    spark:SetSize(2, 9)
    banner.spark = spark

    -- Threshold tick on the bar.
    local tick = bar:CreateTexture(nil, "OVERLAY")
    tick:SetTexture(SOLID)
    tick:SetVertexColor(TEXT[1], TEXT[2], TEXT[3], 0.7)
    tick:SetSize(1, 9)
    banner.tick = tick

    -- Animations ---------------------------------------------------------
    -- Pop in: fade + slight scale-up.
    local intro = banner:CreateAnimationGroup()
    local a = intro:CreateAnimation("Alpha")
    a:SetFromAlpha(0); a:SetToAlpha(1); a:SetDuration(0.3); a:SetSmoothing("OUT")
    local sc = intro:CreateAnimation("Scale")
    if sc.SetScaleFrom then
        sc:SetScaleFrom(0.85, 0.85); sc:SetScaleTo(1, 1)
    else
        sc:SetFromScale(0.85, 0.85); sc:SetToScale(1, 1)
    end
    sc:SetDuration(0.3); sc:SetSmoothing("OUT")
    intro:SetToFinalAlpha(true)
    banner.intro = intro

    -- Fade out, then hide.
    local fadeOut = banner:CreateAnimationGroup()
    local fo = fadeOut:CreateAnimation("Alpha")
    fo:SetFromAlpha(1); fo:SetToAlpha(0); fo:SetDuration(FADE_TIME); fo:SetSmoothing("IN")
    fadeOut:SetToFinalAlpha(true)
    fadeOut:SetScript("OnFinished", function()
        banner:Hide()
        banner:SetAlpha(1)
        banner.pulse:Stop()
        banner.glow:SetAlpha(0)
    end)
    banner.fadeOut = fadeOut

    -- Bag shake: a few quick wobbles.
    local shake = icon:CreateAnimationGroup()
    local angles = { 12, -24, 20, -14, 6 }
    for i, deg in ipairs(angles) do
        local r = shake:CreateAnimation("Rotation")
        r:SetDegrees(deg)
        r:SetDuration(0.07)
        r:SetOrder(i)
        r:SetOrigin("BOTTOM", 0, 0)
    end
    banner.shake = shake

    -- Border pulse while past the threshold.
    local pulse = glow:CreateAnimationGroup()
    pulse:SetLooping("BOUNCE")
    local pa = pulse:CreateAnimation("Alpha")
    pa:SetFromAlpha(0.15); pa:SetToAlpha(1); pa:SetDuration(0.6); pa:SetSmoothing("IN_OUT")
    banner.pulse = pulse

    -- Mouse ---------------------------------------------------------------
    banner:SetScript("OnClick", function(self, button)
        if self.isLocked == false then return end
        if button == "LeftButton" and ToggleAllBags then ToggleAllBags() end
        if preview then BA.Preview(false) else StartFadeOut() end
    end)
    banner:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -4)
        GameTooltip:ClearLines()
        GameTooltip:AddLine(T("Place dans les sacs", "Bag space"), YELLOW[1], YELLOW[2], YELLOW[3])
        GameTooltip:AddLine(T("Clic : ouvrir les sacs", "Click: open bags"), TEXT[1], TEXT[2], TEXT[3])
        GameTooltip:AddLine(T("Clic droit : fermer", "Right click: close"), TEXT[1], TEXT[2], TEXT[3])
        GameTooltip:Show()
    end)
    banner:SetScript("OnLeave", function() GameTooltip:Hide() end)
    banner:SetScript("OnUpdate", OnUpdate)

    local U = TomoMod_Utils
    if U and U.SetupDraggable then
        U.SetupDraggable(banner, function()
            local d = DB()
            if d then
                d.position = d.position or {}
                U.SaveFramePosition(banner, d.position)
            end
        end, T("Place dans les sacs", "Bag space"))
    end

    banner:Hide()
    BA.ApplySettings()
    return banner
end

-- Fills the banner from a scan and plays it.
local function Play(s, silent)
    local db = DB()
    if not db then return end
    CreateBanner()
    local threshold = db.threshold or 90
    local c = ColorFor(s.pct, s.free, threshold)

    if s.free == 0 then
        banner.title:SetText(T("Sacs pleins !", "Bags full!"))
    elseif s.pct >= threshold then
        banner.title:SetText(T("Sacs presque pleins", "Bags nearly full"))
    else
        banner.title:SetText(T("Place dans les sacs", "Bag space"))
    end

    local line
    if s.free == 0 then
        line = string.format(T("0 place libre sur %d", "0 free slot of %d"), s.total)
    else
        line = string.format(T("%d place(s) libre(s) sur %d", "%d free slot(s) of %d"), s.free, s.total)
    end
    if db.showGreys and s.greys > 0 then
        line = line .. string.format(T("  -  %d gris", "  -  %d grey"), s.greys)
        if s.greyValue > 0 then line = line .. " (" .. Coins(s.greyValue) .. ")" end
    elseif s.pct >= threshold then
        line = line .. T("  -  pense à vendre", "  -  time to sell")
    end
    banner.sub:SetText(line)

    banner.pctFS:SetTextColor(c[1], c[2], c[3])
    banner.bar:SetStatusBarColor(c[1], c[2], c[3], 1)
    banner.glow.edge:SetColor(c)
    banner.bar:SetValue(0)
    banner.pctFS:SetText("0 %")
    banner.threshold = threshold
    banner.target = s.pct
    banner.alarm = s.pct >= threshold or s.free == 0
    banner.countT = 0
    banner.holdLeft = db.duration or 7

    banner.fadeOut:Stop()
    banner.pulse:Stop()
    banner.shake:Stop()
    banner.glow:SetAlpha(0)
    banner:SetAlpha(1)
    banner:Show()
    banner.intro:Play()

    if db.sound and not silent then
        PlaySound((SOUNDKIT and SOUNDKIT.IG_BACKPACK_OPEN) or 862, "Master")
    end
end

-- ---------------------------------------------------------------------
-- Triggers
-- ---------------------------------------------------------------------
-- stage: 0 = below the threshold, 1 = past it (warned), 2 = full (warned).
local stage = 0
local pending       -- scan waiting for the end of combat
local loginDone = false

local function StageOf(s, threshold)
    if s.total == 0 then return 0 end
    if s.free == 0 then return 2 end
    if s.pct >= threshold then return 1 end
    return 0
end

local function Raise(s)
    if InCombatLockdown() then pending = true return end
    pending = nil
    Play(s)
end

local function OnBagsChanged()
    local db = DB()
    if not (db and db.enabled and loginDone) then return end
    local s = Scan()
    local now = StageOf(s, db.threshold or 90)
    if now > stage and db.onFill and (now == 1 or db.fullAlert) then
        Raise(s)
    end
    stage = now
end

local function OnLogin()
    loginDone = true
    local db = DB()
    if not (db and db.enabled) then return end
    local s = Scan()
    stage = StageOf(s, db.threshold or 90)
    if db.onLogin and stage > 0 then Raise(s) end
end

-- ---------------------------------------------------------------------
-- Public
-- ---------------------------------------------------------------------
function BA.ApplySettings()
    local db = DB()
    if not db then return end
    if banner then
        banner:SetScale(db.scale or 1)
        local U = TomoMod_Utils
        if U and U.ApplyFramePosition and db.position then U.ApplyFramePosition(banner, db.position) end
    end
    -- The threshold may have moved: re-read the stage without alerting.
    if loginDone then stage = StageOf(Scan(), db.threshold or 90) end
    if preview then Play(Scan(), true) end
end

function BA.Preview(on)
    preview = on and true or false
    if preview then
        local s = Scan()
        -- Real bags, unless they are nearly empty: then a sample that shows
        -- the alarm look.
        if s.total == 0 or s.pct < 50 then
            local total = s.total > 0 and s.total or 80
            local free = math.max(1, math.floor(total * 0.08))
            s = { total = total, free = free, used = total - free, greys = 6, greyValue = 4235 }
            s.pct = math.floor(s.used / s.total * 100 + 0.5)
        end
        Play(s)
    elseif banner and banner:IsShown() then
        StartFadeOut()
    end
end
function BA.IsPreview() return preview end

function BA.SetEnabled(v)
    local db = DB()
    if not db then return end
    db.enabled = v and true or false
    if not v then
        preview, pending = false, nil
        if banner then banner:Hide() end
    elseif loginDone then
        stage = StageOf(Scan(), db.threshold or 90)
    end
end

function BA.Initialize()
    if not DB() then return end
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("BAG_UPDATE_DELAYED")
    f:RegisterEvent("PLAYER_REGEN_ENABLED")
    f:SetScript("OnEvent", function(_, event, isLogin, isReload)
        if event == "BAG_UPDATE_DELAYED" then
            OnBagsChanged()
        elseif event == "PLAYER_REGEN_ENABLED" then
            if pending then
                local db = DB()
                if db and db.enabled then
                    local s = Scan()
                    if StageOf(s, db.threshold or 90) > 0 then Play(s) end
                end
                pending = nil
            end
        elseif event == "PLAYER_ENTERING_WORLD" then
            if isLogin then
                C_Timer.After(LOGIN_DELAY, OnLogin)
            elseif not loginDone then
                -- /reload: arm silently, no banner.
                loginDone = true
                local db = DB()
                if db then stage = StageOf(Scan(), db.threshold or 90) end
            end
        end
    end)

    if TomoMod_Movers and TomoMod_Movers.RegisterEntry then
        TomoMod_Movers.RegisterEntry({
            label    = T("Place dans les sacs", "Bag space"),
            unlock   = function() BA.Preview(true); if banner and banner.SetLocked then banner:SetLocked(false) end end,
            lock     = function() if banner and banner.SetLocked then banner:SetLocked(true) end; BA.Preview(false) end,
            isActive = function() local d = DB(); return d and d.enabled end,
        })
    end
end
