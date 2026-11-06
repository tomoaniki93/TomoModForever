-- =====================================================================
-- Modules/QOL/Forever/Campfire.lua -- "Campement" HUD (WoW: Forever)
--
-- Near a campfire, a round HUD appears. One click sits the character
-- down. While the fire's timed aura runs, the ring fills up, and every
-- buff picked up since arriving at the camp is shown around the ring so
-- it can be read before it is forgotten.
--
-- Finding the fire. The client only puts a "campfire" aura on the player
-- while sitting, so an aura alone cannot say "you are near a fire". Four
-- signals mark the camp: that aura appearing, pointing at a fire with the
-- mouse, a fire in soft-interact range, or lighting one yourself. Each one
-- records where the player stands (UnitPosition); the HUD then stays while
-- the player is within a few yards of that spot and leaves as soon as they
-- walk away, even if the timed aura is still running. Fires are recognised
-- by the localized word "campfire", so every client language works, and the
-- camp bonuses are simply the buffs gained while at the fire.
-- =====================================================================

TomoMod_Campfire = TomoMod_Campfire or {}
local CF = TomoMod_Campfire

local FONT      = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local FONT_BOLD = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-SemiBold.ttf"
local RING      = "Interface\\AddOns\\TomoModForever\\Assets\\Textures\\Cursor\\Ring.tga"
local GLOW      = "Interface\\AddOns\\TomoModForever\\Assets\\Textures\\Cursor\\Glow.tga"
local MASK      = "Interface\\CharacterFrame\\TempPortraitAlphaMask"
local FIRE_ICON = "Interface\\Icons\\Spell_Fire_Fire"
-- 16-frame flame sprite sheet (4 x 4 cells of 64 px), drawn for this addon.
local FLAMES    = "Interface\\AddOns\\TomoModForever\\Assets\\Textures\\Camp\\Flames.tga"
local FLAME_FRAMES, FLAME_COLS, FLAME_FPS = 16, 4, 14

local IS_FR = GetLocale() == "frFR"
local function T(fr, en)
    if TomoMod_GUIT then return TomoMod_GUIT(fr, en) end
    return IS_FR and fr or en
end

-- The word for "campfire" in each client language, lower case.
local KEYWORDS = {
    "feu de camp", "campfire", "lagerfeuer", "fogata", "hoguera",
    "falò", "fuoco da campo", "fogueira",
}

local MAX_BONUS = 8
local LINGER = 2          -- seconds the HUD stays after leaving the fire
local RADIUS_SIT   = 12   -- yards: a fire you sat at, interacted with or lit
local RADIUS_HOVER = 20   -- yards: a fire you only pointed at with the mouse
local FORGET_AT    = 3    -- forget the camp beyond RADIUS x this
local NOPOS_WINDOW = 30   -- seconds a signal keeps the HUD up where positions are hidden

local hud
local state = {
    near = false,         -- a campfire aura is on the player
    timed = nil,          -- { start, duration } of the fire's timed aura
    baseline = {},        -- [spellId] = true, buffs already there on arrival
    bonuses = {},         -- list of { id, name, icon, exp, instance }
    leftAt = nil,
    preview = false,
}

local function DB() return TomoModForeverDB and TomoModForeverDB.campfire end

local function Secret(v)
    return TomoMod_Utils and TomoMod_Utils.IsSecret and TomoMod_Utils.IsSecret(v) or false
end

local function IsCampfireName(name)
    if type(name) ~= "string" or Secret(name) then return false end
    local l = name:lower()
    for _, k in ipairs(KEYWORDS) do
        if l:find(k, 1, true) then return true end
    end
    return false
end

-- Every readable helpful aura on the player.
local function PlayerBuffs()
    local out = {}
    if C_UnitAuras and C_UnitAuras.GetAuraDataByIndex then
        for i = 1, 40 do
            local ok, a = pcall(C_UnitAuras.GetAuraDataByIndex, "player", i, "HELPFUL")
            if not ok or not a then break end
            if not Secret(a.name) and not Secret(a.spellId) then
                out[#out + 1] = a
            end
        end
    elseif UnitBuff then
        for i = 1, 40 do
            local name, icon, _, _, duration, expirationTime, _, _, _, spellId = UnitBuff("player", i)
            if not name then break end
            out[#out + 1] = { name = name, icon = icon, duration = duration,
                              expirationTime = expirationTime, spellId = spellId }
        end
    end
    return out
end

local function Num(v)
    if type(v) ~= "number" or Secret(v) then return nil end
    return v
end

-- ---------------------------------------------------------------------
-- HUD
-- ---------------------------------------------------------------------
local function BonusIcon(i)
    local b = hud.icons[i]
    if b then return b end
    b = CreateFrame("Frame", nil, hud)
    b:SetSize(26, 26)
    b.tex = b:CreateTexture(nil, "ARTWORK")
    b.tex:SetAllPoints()
    b.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    local border = b:CreateTexture(nil, "BACKGROUND")
    border:SetPoint("TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", 1, -1)
    border:SetColorTexture(0.788, 0.635, 0.322, 1)
    b.time = b:CreateFontString(nil, "OVERLAY")
    b.time:SetFont(FONT, 9, "OUTLINE")
    b.time:SetPoint("TOP", b, "BOTTOM", 0, -1)
    b.time:SetTextColor(0.95, 0.92, 0.86)
    b:EnableMouse(true)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        local done = false
        if self.instance and GameTooltip.SetUnitBuffByAuraInstanceID then
            done = pcall(GameTooltip.SetUnitBuffByAuraInstanceID, GameTooltip, "player", self.instance, "HELPFUL")
        end
        if not done and self.id and GameTooltip.SetSpellByID then
            pcall(GameTooltip.SetSpellByID, GameTooltip, self.id)
        elseif not done then
            GameTooltip:SetText(self.name or "")
        end
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    hud.icons[i] = b
    return b
end

local function FormatTime(s)
    if not s or s <= 0 then return "" end
    if s >= 60 then return string.format("%d:%02d", math.floor(s / 60), math.floor(s % 60)) end
    return string.format("%d", math.ceil(s))
end

local function LayoutBonuses()
    local list = state.bonuses
    local n = math.min(#list, MAX_BONUS)
    local r = 74
    for i = 1, MAX_BONUS do
        local b = hud.icons[i]
        if i > n then
            if b then b:Hide() end
        else
            b = BonusIcon(i)
            local bonus = list[i]
            -- An arc over the top of the ring, centred on 90 degrees.
            local spread = math.min(150, 32 * (n - 1))
            local deg = (n == 1) and 90 or (90 + spread / 2 - (i - 1) * spread / (n - 1))
            local rad = math.rad(deg)
            b:ClearAllPoints()
            b:SetPoint("CENTER", hud, "CENTER", math.cos(rad) * r, math.sin(rad) * r)
            b.tex:SetTexture(bonus.icon or 134400)
            b.id, b.name, b.instance, b.exp = bonus.id, bonus.name, bonus.instance, bonus.exp
            b:Show()
        end
    end
end

local function CreateHUD()
    if hud then return hud end
    local db = DB()
    hud = CreateFrame("Button", "TomoMod_CampfireHUD", UIParent)
    hud:SetSize(92, 92)
    hud:SetFrameStrata("MEDIUM")
    hud:SetClampedToScreen(true)
    hud:RegisterForClicks("LeftButtonUp")
    hud.icons = {}

    local glow = hud:CreateTexture(nil, "BACKGROUND")
    glow:SetPoint("TOPLEFT", -22, 22)
    glow:SetPoint("BOTTOMRIGHT", 22, -22)
    glow:SetTexture(GLOW)
    glow:SetVertexColor(1, 0.55, 0.15, 0.55)
    hud.glow = glow

    local icon = hud:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("TOPLEFT", 10, -10)
    icon:SetPoint("BOTTOMRIGHT", -10, 10)
    icon:SetTexture(FIRE_ICON)
    local mask = hud:CreateMaskTexture()
    mask:SetAllPoints(icon)
    mask:SetTexture(MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    icon:AddMaskTexture(mask)
    hud.icon = icon

    local cd = CreateFrame("Cooldown", nil, hud, "CooldownFrameTemplate")
    cd:SetAllPoints(icon)
    cd:SetDrawEdge(false)
    cd:SetDrawBling(false)
    cd:SetReverse(true)
    cd:SetHideCountdownNumbers(true)
    if cd.SetUseCircularEdge then cd:SetUseCircularEdge(true) end
    if cd.SetSwipeTexture then cd:SetSwipeTexture(MASK) end
    cd:SetSwipeColor(1, 0.75, 0.25, 0.55)
    hud.cd = cd

    -- Living fire: the sprite sheet is stepped cell by cell over the icon.
    local flames = hud:CreateTexture(nil, "ARTWORK", nil, 2)
    flames:SetPoint("BOTTOM", hud, "BOTTOM", 0, 14)
    flames:SetSize(58, 58)
    flames:SetTexture(FLAMES)
    flames:SetBlendMode("ADD")
    flames:SetTexCoord(0, 0.25, 0, 0.25)
    hud.flames = flames
    hud.flameT = 0

    local ring = hud:CreateTexture(nil, "OVERLAY")
    ring:SetAllPoints()
    ring:SetTexture(RING)
    ring:SetVertexColor(0.788, 0.635, 0.322, 1)

    local title = hud:CreateFontString(nil, "OVERLAY")
    title:SetFont(FONT_BOLD, 12, "OUTLINE")
    title:SetPoint("TOP", hud, "BOTTOM", 0, -4)
    title:SetTextColor(1, 0.82, 0)
    title:SetText(T("Campement", "Camp"))
    hud.title = title

    local sub = hud:CreateFontString(nil, "OVERLAY")
    sub:SetFont(FONT, 10, "OUTLINE")
    sub:SetPoint("TOP", title, "BOTTOM", 0, -2)
    sub:SetTextColor(0.95, 0.92, 0.86)
    hud.sub = sub

    local timer = hud:CreateFontString(nil, "OVERLAY")
    timer:SetFont(FONT_BOLD, 16, "OUTLINE")
    timer:SetPoint("CENTER")
    timer:SetTextColor(1, 1, 1)
    hud.timer = timer

    hud:SetScript("OnClick", function()
        local d = DB()
        if d and d.clickToSit ~= false and not InCombatLockdown() and DoEmote then DoEmote("SIT") end
    end)
    hud:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText(T("Campement", "Camp"), 1, 0.82, 0)
        GameTooltip:AddLine(T("Clic : s'asseoir près du feu.", "Click: sit by the fire."), 0.95, 0.92, 0.86)
        if #state.bonuses > 0 then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(T("Bonus obtenus au camp :", "Bonuses gained at camp:"), 0.79, 0.64, 0.32)
            for _, b in ipairs(state.bonuses) do GameTooltip:AddLine("- " .. (b.name or "?"), 1, 1, 1) end
        end
        GameTooltip:Show()
    end)
    hud:SetScript("OnLeave", function() GameTooltip:Hide() end)

    local acc = 0
    hud:SetScript("OnUpdate", function(self, dt)
        if self.flames:IsShown() then
            self.flameT = self.flameT + dt
            local cell = math.floor(self.flameT * FLAME_FPS) % FLAME_FRAMES
            if cell ~= self.flameCell then
                self.flameCell = cell
                local col, row = cell % FLAME_COLS, math.floor(cell / FLAME_COLS)
                local w = 1 / FLAME_COLS
                self.flames:SetTexCoord(col * w, (col + 1) * w, row * w, (row + 1) * w)
            end
        end
        acc = acc + dt
        if acc < 0.2 then return end
        acc = 0
        local now = GetTime()
        if state.timed then
            local left = state.timed.start + state.timed.duration - now
            self.timer:SetText(left > 0 and FormatTime(left) or "")
        else
            self.timer:SetText("")
        end
        for _, b in ipairs(self.icons) do
            if b:IsShown() then
                b.time:SetText(b.exp and b.exp > 0 and FormatTime(b.exp - now) or "")
            end
        end
        -- Pulse the glow gently while the fire burns.
        self.glow:SetAlpha(0.35 + 0.2 * math.sin(now * 2.2))
        if state.leftAt and now - state.leftAt > LINGER and not state.preview then
            state.leftAt = nil
            self:Hide()
        end
    end)

    local U = TomoMod_Utils
    if U and U.SetupDraggable then
        U.SetupDraggable(hud, function()
            local d = DB()
            if d then
                d.position = d.position or {}
                U.SaveFramePosition(hud, d.position)
            end
        end, T("Campement", "Camp"))
    end
    hud:Hide()
    CF.ApplySettings()
    return hud
end

local function Render()
    if not hud then return end
    local db = DB()
    if state.timed then
        hud.cd:SetCooldown(state.timed.start, state.timed.duration)
        hud.sub:SetText(T("Repos au coin du feu", "Resting by the fire"))
    else
        hud.cd:Clear()
        hud.sub:SetText(db and db.clickToSit ~= false and T("Clic : s'asseoir", "Click: sit down") or "")
    end
    if db and db.showBonuses ~= false then LayoutBonuses() else
        for _, b in ipairs(hud.icons) do b:Hide() end
    end
end

-- ---------------------------------------------------------------------
-- State
-- ---------------------------------------------------------------------
-- ---------------------------------------------------------------------
-- Where is the camp?
-- ---------------------------------------------------------------------
-- camp = { y, x, inst, radius } with positions, or { noPos = true,
-- expires } where the client hides them (instances).
local camp
local auraUp = false
local Scan, QueueScan

local function PlayerPos()
    if not UnitPosition then return nil end
    local ok, y, x, _, inst = pcall(UnitPosition, "player")
    if not ok or Secret(y) or Secret(x) or type(y) ~= "number" or type(x) ~= "number" then return nil end
    return y, x, inst
end

local function Distance()
    if not (camp and not camp.noPos) then return nil end
    local y, x, inst = PlayerPos()
    if not y or inst ~= camp.inst then return math.huge end
    local dy, dx = y - camp.y, x - camp.x
    return math.sqrt(dy * dy + dx * dx)
end

local function InCamp()
    if not camp then return false end
    if camp.noPos then return GetTime() < camp.expires end
    local d = Distance()
    return d ~= nil and d <= camp.radius
end

-- While a camp is known, watch the distance twice a second: walking away
-- hides the HUD without waiting for an aura event.
local ticker
local wasIn = false
local function StopWatch()
    if ticker then ticker:Cancel(); ticker = nil end
end
local function StartWatch()
    if ticker then return end
    ticker = C_Timer.NewTicker(0.5, function()
        if not camp then StopWatch() return end
        local inNow = InCamp()
        if not camp.noPos then
            local d = Distance()
            if d and d > camp.radius * FORGET_AT then camp = nil end
        elseif not inNow and not auraUp then
            camp = nil
        end
        if inNow ~= wasIn or not camp then
            wasIn = inNow
            Scan()
        end
        if not camp then StopWatch() end
    end)
end

local function MarkCamp(radius)
    local db = DB()
    if not (db and db.enabled) then return end
    local y, x, inst = PlayerPos()
    if y then
        -- A closer signal (sitting) narrows a wide one (hover), never the reverse.
        if camp and not camp.noPos and camp.inst == inst and (Distance() or math.huge) <= camp.radius then
            radius = math.min(radius, camp.radius)
        end
        camp = { y = y, x = x, inst = inst, radius = radius }
    else
        camp = { noPos = true, expires = GetTime() + NOPOS_WINDOW }
    end
    wasIn = true
    StartWatch()
    QueueScan()
end

-- ---------------------------------------------------------------------
-- State
-- ---------------------------------------------------------------------
Scan = function()
    local db = DB()
    if not (db and db.enabled) or state.preview then return end
    local buffs = PlayerBuffs()
    local hasAura, timed = false, nil
    for _, a in ipairs(buffs) do
        if IsCampfireName(a.name) then
            hasAura = true
            local dur, exp = Num(a.duration), Num(a.expirationTime)
            if dur and exp and dur > 0 and exp > 0 then
                if not timed or exp > timed.start + timed.duration then
                    timed = { start = exp - dur, duration = dur }
                end
            end
        end
    end

    -- Sitting down at a fire: that is exactly where the camp is.
    if hasAura and not auraUp then
        auraUp = true
        MarkCamp(RADIUS_SIT)
    elseif not hasAura then
        auraUp = false
    end

    -- Near = inside the camp radius. Without any known spot (positions
    -- hidden and no other signal), the aura is all there is to go on.
    local near = InCamp() or (hasAura and camp == nil)

    if near and not state.near then
        -- Arriving: everything already on the player is not a camp bonus.
        state.baseline = {}
        for _, a in ipairs(buffs) do
            if a.spellId then state.baseline[a.spellId] = true end
        end
        state.bonuses = {}
    end
    state.near = near
    state.timed = near and timed or nil

    if near then
        state.leftAt = nil
        local seen = {}
        local list = {}
        for _, a in ipairs(buffs) do
            local id = a.spellId
            if id and not state.baseline[id] and not IsCampfireName(a.name) and not seen[id] then
                seen[id] = true
                list[#list + 1] = { id = id, name = a.name, icon = a.icon,
                                    exp = Num(a.expirationTime), instance = a.auraInstanceID }
            end
        end
        state.bonuses = list
        if not (db.hideInCombat and InCombatLockdown()) then
            CreateHUD()
            Render()
            hud:Show()
        end
    elseif hud and hud:IsShown() and not state.leftAt then
        state.leftAt = GetTime()
        Render()
    end
end

local pending = false
QueueScan = function()
    if pending then return end
    pending = true
    C_Timer.After(0.15, function() pending = false; Scan() end)
end

-- ---------------------------------------------------------------------
-- Public
-- ---------------------------------------------------------------------
function CF.ApplySettings()
    local db = DB()
    if not (db and hud) then return end
    hud:SetScale(db.scale or 1)
    local animated = db.animatedFlames ~= false
    hud.flames:SetShown(animated)
    hud.icon:SetAlpha(animated and 0.35 or 1)
    local U = TomoMod_Utils
    if U and U.ApplyFramePosition and db.position then U.ApplyFramePosition(hud, db.position) end
    Render()
end

-- Shows the HUD with a sample timer and bonuses, to place and size it.
function CF.Preview(on)
    CreateHUD()
    state.preview = on and true or false
    if on then
        local now = GetTime()
        state.timed = { start = now - 20, duration = 60 }
        state.bonuses = {
            { name = T("Esprit du camp", "Camp spirit"), icon = "Interface\\Icons\\Spell_Holy_DivineSpirit", exp = now + 1500 },
            { name = T("Bien reposé", "Well rested"), icon = "Interface\\Icons\\Spell_Nature_Sleep", exp = now + 1500 },
            { name = T("Lame aiguisée", "Sharpened blade"), icon = "Interface\\Icons\\INV_Stone_SharpeningStone_01", exp = now + 900 },
        }
        state.leftAt = nil
        Render()
        hud:Show()
    else
        state.timed, state.bonuses, state.near = nil, {}, false
        hud:Hide()
        Scan()
    end
end
function CF.IsPreview() return state.preview end

function CF.SetEnabled(v)
    local db = DB()
    if not db then return end
    db.enabled = v and true or false
    if v then
        if CF._events then CF._events:RegisterUnitEvent("UNIT_AURA", "player") end
        Scan()
    else
        if CF._events then CF._events:UnregisterEvent("UNIT_AURA") end
        camp, auraUp = nil, false
        StopWatch()
        state.preview = false
        if hud then hud:Hide() end
    end
end

function CF.Initialize()
    local db = DB()
    if not db then return end
    local f = CreateFrame("Frame")
    CF._events = f
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("PLAYER_REGEN_DISABLED")
    f:RegisterEvent("PLAYER_REGEN_ENABLED")
    if db.enabled then f:RegisterUnitEvent("UNIT_AURA", "player") end
    f:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
    pcall(f.RegisterEvent, f, "PLAYER_SOFT_INTERACT_CHANGED")
    f:SetScript("OnEvent", function(_, event, _, _, spellID)
        local d = DB()
        if not (d and d.enabled) then return end
        if event == "PLAYER_REGEN_DISABLED" then
            if d.hideInCombat and hud and not state.preview then hud:Hide() end
        elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
            -- Lighting a fire yourself.
            if spellID and not Secret(spellID) and C_Spell and C_Spell.GetSpellName then
                local ok, name = pcall(C_Spell.GetSpellName, spellID)
                if ok and IsCampfireName(name) then MarkCamp(RADIUS_SIT) end
            end
        elseif event == "PLAYER_SOFT_INTERACT_CHANGED" then
            -- A fire close enough to interact with.
            local ok, name = pcall(UnitName, "softinteract")
            if ok and IsCampfireName(name) then MarkCamp(RADIUS_SIT) end
        elseif event == "PLAYER_ENTERING_WORLD" then
            camp, auraUp = nil, false
            StopWatch()
            QueueScan()
        else
            QueueScan()
        end
    end)

    -- Pointing at a fire in the world: a tooltip with a "campfire" title
    -- that belongs to no unit, item, spell or button. World objects use the
    -- default anchor, owned by UIParent; the Campfire spell on an action
    -- bar or in the spellbook is owned by its button, so it is ignored.
    if GameTooltip and GameTooltip.HookScript then
        GameTooltip:HookScript("OnShow", function(tip)
            local d = DB()
            if not (d and d.enabled) then return end
            local owner = tip.GetOwner and tip:GetOwner()
            if owner and owner ~= UIParent and owner ~= WorldFrame then return end
            local okU, unitName = pcall(tip.GetUnit, tip)
            if okU and unitName then return end
            if tip.GetSpell then
                local okS, _, sid = pcall(tip.GetSpell, tip)
                if okS and sid then return end
            end
            if tip.GetItem then
                local okI, _, link = pcall(tip.GetItem, tip)
                if okI and link then return end
            end
            local line = _G.GameTooltipTextLeft1
            local ok, text = pcall(line and line.GetText or function() end, line)
            if ok and IsCampfireName(text) then MarkCamp(RADIUS_HOVER) end
        end)
    end

    if TomoMod_Movers and TomoMod_Movers.RegisterEntry then
        TomoMod_Movers.RegisterEntry({
            label    = T("Campement", "Camp"),
            unlock   = function() CF.Preview(true); if hud and hud.SetLocked then hud:SetLocked(false) end end,
            lock     = function() if hud and hud.SetLocked then hud:SetLocked(true) end; CF.Preview(false) end,
            isActive = function() local d = DB(); return d and d.enabled end,
        })
    end
end
