-- =====================================================================
-- ActionBarLayout.lua -- TMF's own action bars (1.4.1)
--
-- Idea taken from AishCore (Aishuu): no button is created. Blizzard's own
-- buttons (ActionButton1-12, MultiBar*Button, PetActionButton,
-- StanceButton, the shaman totem bar) are moved into secure bars that
-- TMF owns. Those buttons were created by the game, outside any addon,
-- so everything that matters keeps running on Blizzard's untainted code:
-- spells, cooldowns, range, procs, keybinds, drag and drop, quick
-- keybind mode. Written for TMF from scratch (AishCore is GPL-3).
--
-- What TMF does to them, and only out of combat (caught up on
-- PLAYER_REGEN_ENABLED):
--   * reparent / place / size them in its bars;
--   * write their action page from the secure environment (Execute and
--     _onstate snippets), never from Lua, so a click is never tainted;
--   * drive bar 1 paging and each bar's visibility with state drivers.
-- The look stays ActionBarSkin's job, the fade too (alpha is never
-- protected): ActionBarSkin.BarFrame() hands it our bars once adopted.
--
-- Turning the bars off gives the buttons back on the next /reload only:
-- a button cannot be handed back to a Blizzard bar mid-session safely.
--
-- Expert mode only: in simple mode the bars stay Blizzard's and only
-- keep the skin (ActionBarSkin).
--
-- Sets of bars (groups) and attached bars:
--   * a group shares size, button count, buttons per row, spacing, empty
--     slots and row order between its bars (barSkin.layout.groups[id]);
--     each bar keeps its own place and its on / off switch;
--   * a bar can be attached to another one (bars[key].attach = { to,
--     side, gap, off }): it is anchored to it, so it follows its moves and
--     its size changes. Dropping a bar against another one in Layout mode
--     attaches it (and it joins that bar's group if it has none). The
--     first turn-on attaches the bars Blizzard had stacked. The magnet and
--     that first attachment only concern bars 1 to 8; pet, stance and
--     totem bars can still be attached by hand in the settings.
-- =====================================================================

TomoMod_ActionBars = TomoMod_ActionBars or {}
local AB = TomoMod_ActionBars

local IS_FR = GetLocale and GetLocale() == "frFR"
local function T(fr, en)
    if TomoMod_GUIT then return TomoMod_GUIT(fr, en) end
    return IS_FR and fr or en
end

local WHITE = "Interface\\Buttons\\WHITE8x8"

-- ---------------------------------------------------------------------
-- Bars. page = fixed action page; paged = bar 1 (stances, forms, bar
-- switching); kind = pet / stance / totem.
-- ---------------------------------------------------------------------
local DEFS = {
    { key = "bar1", prefix = "ActionButton",              count = 12, paged = true, blizz = { "MainActionBar", "MainMenuBar" }, fr = "Barre 1 (principale)", en = "Bar 1 (main)" },
    { key = "bar2", prefix = "MultiBarBottomLeftButton",  count = 12, page = 6,  blizz = { "MultiBarBottomLeft" },  fr = "Barre 2", en = "Bar 2" },
    { key = "bar3", prefix = "MultiBarBottomRightButton", count = 12, page = 5,  blizz = { "MultiBarBottomRight" }, fr = "Barre 3", en = "Bar 3" },
    { key = "bar4", prefix = "MultiBarRightButton",       count = 12, page = 3,  blizz = { "MultiBarRight" },       fr = "Barre 4", en = "Bar 4" },
    { key = "bar5", prefix = "MultiBarLeftButton",        count = 12, page = 4,  blizz = { "MultiBarLeft" },        fr = "Barre 5", en = "Bar 5" },
    { key = "bar6", prefix = "MultiBar5Button",           count = 12, page = 13, blizz = { "MultiBar5" },           fr = "Barre 6", en = "Bar 6" },
    { key = "bar7", prefix = "MultiBar6Button",           count = 12, page = 14, blizz = { "MultiBar6" },           fr = "Barre 7", en = "Bar 7" },
    { key = "bar8", prefix = "MultiBar7Button",           count = 12, page = 15, blizz = { "MultiBar7" },           fr = "Barre 8", en = "Bar 8" },
    { key = "pet",    prefix = "PetActionButton", count = 10, kind = "pet",    blizz = { "PetActionBar", "PetActionBarFrame" }, fr = "Familier", en = "Pet" },
    { key = "stance", prefix = "StanceButton",    count = 10, kind = "stance", blizz = { "StanceBar", "StanceBarFrame" },       fr = "Postures", en = "Stances" },
    { key = "totem",  kind = "totem", count = 0, blizz = {}, fr = "Totems", en = "Totems" },
}
local DEF_BY = {}
for _, d in ipairs(DEFS) do DEF_BY[d.key] = d end
AB.DEFS = DEFS

-- Per-bar fallbacks (the real defaults live in Core/Database.lua).
local FALLBACK = { enabled = true, size = 36, count = 12, perRow = 12, spacing = 2, showEmpty = false, growUp = false }

-- ---------------------------------------------------------------------
-- State
-- ---------------------------------------------------------------------
local hidden = CreateFrame("Frame", "TomoMod_ActionBarsHidden", UIParent)
hidden:Hide()

local frames, buttons = {}, {}                         -- key -> bar ; key -> { buttons }
local owner  = setmetatable({}, { __mode = "k" })     -- button -> bar key
local native = setmetatable({}, { __mode = "k" })     -- button -> sizes as Blizzard made it
local adopted, pendingAdopt, pendingLayout, pendingFull = false, false, false, false
local placing = 0                                      -- > 0 while we move buttons ourselves
local unlocked, gridShown, reloadAsked = false, false, false
local worldReady = false                                -- first PLAYER_ENTERING_WORLD seen
local TOTEM                                             -- MultiCastActionBarFrame, shamans only

local function Round(v) return math.floor(v + 0.5) end
local function Secret(v) return issecretvalue and issecretvalue(v) end

-- ---------------------------------------------------------------------
-- Settings: TomoModForeverDB.barSkin.layout (follows the profiles with
-- the rest of the action bar settings).
-- ---------------------------------------------------------------------
local function LDB()
    local s = TomoModForeverDB and TomoModForeverDB.barSkin
    if type(s) ~= "table" then return nil end
    if type(s.layout) ~= "table" then s.layout = {} end
    if type(s.layout.bars) ~= "table" then s.layout.bars = {} end
    return s.layout
end

local function BarDB(key)
    local l = LDB()
    if not l then return {} end
    if type(l.bars[key]) ~= "table" then l.bars[key] = {} end
    return l.bars[key]
end
AB.BarDB = BarDB

-- Settings a group shares; everything else (enabled, x, y, attach,
-- group) stays the bar's own.
local SHARED = { size = true, count = true, perRow = true, spacing = true, showEmpty = true, growUp = true }
AB.SHARED = SHARED

local function GroupOf(key)
    local l = LDB()
    local id = l and l.bars[key] and l.bars[key].group
    local g = id and type(l.groups) == "table" and l.groups[id]
    if type(g) == "table" then
        if type(g.settings) ~= "table" then g.settings = {} end
        return g, id
    end
end
AB.GroupOf = GroupOf

local function BV(key, prop)
    local v
    local g = SHARED[prop] and GroupOf(key)
    if g then v = g.settings[prop] else v = BarDB(key)[prop] end
    if v == nil then v = FALLBACK[prop] end
    return v
end
AB.BV = BV

--- Dotted DB path a GUI control should write for this bar's setting:
--- the group's when the bar is in one and the setting is shared.
function AB.SettingPath(key, prop)
    local _, id = GroupOf(key)
    if SHARED[prop] and id then return "barSkin.layout.groups." .. id .. ".settings." .. prop end
    return "barSkin.layout.bars." .. key .. "." .. prop
end

function AB.Expert()
    local g = TomoModForeverDB and TomoModForeverDB.configGUI
    return type(g) == "table" and g.expert == true
end

--- Turned on in the settings AND the window in expert mode.
function AB.IsEnabled()
    local l = LDB()
    return (l and l.enabled == true and AB.Expert()) and true or false
end
function AB.IsAdopted() return adopted end
function AB.GetFrame(key) return adopted and frames[key] or nil end
function AB.IsUnlocked() return unlocked end
function AB.Label(key)
    local d = DEF_BY[key]
    return d and T(d.fr, d.en) or key
end

--- Bars this character actually has (the totem bar for shamans only).
function AB.ActiveDefs()
    local out = {}
    for _, d in ipairs(DEFS) do
        if d.kind == "totem" then
            local _, cls = UnitClass("player")
            if cls == "SHAMAN" and _G.MultiCastActionBarFrame then out[#out + 1] = d end
        elseif _G[d.prefix .. "1"] then
            out[#out + 1] = d
        end
    end
    return out
end

-- Another bar addon already owns these buttons: stand down.
local CONFLICTS = { "Bartender4", "Dominos", "ElvUI" }
function AB.Conflict()
    local loaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
    if loaded then
        for _, name in ipairs(CONFLICTS) do
            local ok, on = pcall(loaded, name)
            if ok and on then return name end
        end
    end
    if _G.AishCoreActionBar_bar1 then return "AishCore" end
    return nil
end

-- ---------------------------------------------------------------------
-- Sizes. A few of Blizzard's layers have a fixed size made for its own
-- button (green "equipped" border, pet autocast, flash): they are scaled
-- with the button, from the size Blizzard gave them.
-- ---------------------------------------------------------------------
local FIXED = { "Border", "AutoCastable", "AutoCastShine", "Shine", "Flash", "NewActionTexture", "SpellHighlightTexture" }

local function Native(b)
    local n = native[b]
    if n then return n end
    n = { w = 36, h = 36, fixed = {} }
    local ok, w, h = pcall(b.GetSize, b)
    if ok and type(w) == "number" and not Secret(w) and w > 4 then n.w, n.h = w, h end
    local name = b:GetName()
    local seen = {}
    for _, k in ipairs(FIXED) do
        local r = b[k]
        if type(r) ~= "table" and name then r = _G[name .. k] end
        if type(r) == "table" and not seen[r] and r.GetNumPoints and r.SetSize then
            seen[r] = true
            local okP, np = pcall(r.GetNumPoints, r)
            local okS, rw, rh = pcall(r.GetSize, r)
            if okP and np == 1 and okS and type(rw) == "number" and not Secret(rw) and rw > 0 and rh > 0 then
                n.fixed[#n.fixed + 1] = { r, rw, rh }
            end
        end
    end
    native[b] = n
    return n
end

local function FitButton(b, size)
    local n = Native(b)
    b:SetSize(size, size)
    local k = size / n.w
    for _, f in ipairs(n.fixed) do
        pcall(f[1].SetSize, f[1], f[2] * k, f[3] * k)
    end
end

-- ---------------------------------------------------------------------
-- Grid: bar size and the top-left offset of each button.
-- ---------------------------------------------------------------------
function AB.Count(key)
    local d = DEF_BY[key]
    local n = math.max(1, math.min(d.count, tonumber(BV(key, "count")) or d.count))
    if d.kind == "stance" and GetNumShapeshiftForms then
        local f = GetNumShapeshiftForms() or 0
        if not Secret(f) and f > 0 then n = math.min(n, f) end
    end
    return n
end

function AB.Grid(key, n)
    local s  = math.max(16, tonumber(BV(key, "size")) or 36)
    local sp = math.max(0, tonumber(BV(key, "spacing")) or 2)
    local per = math.max(1, math.min(n, tonumber(BV(key, "perRow")) or 12))
    local cols, rows = per, math.ceil(n / per)
    local W = cols * s + (cols - 1) * sp
    local H = rows * s + (rows - 1) * sp
    local up = BV(key, "growUp") == true
    local pos = {}
    for i = 1, n do
        local c, r = (i - 1) % per, math.floor((i - 1) / per)
        if up then r = rows - 1 - r end
        pos[i] = { c * (s + sp), -r * (s + sp) }
    end
    return W, H, pos, s
end

-- ---------------------------------------------------------------------
-- Paging of bar 1: same pages Blizzard uses (forms, stealth, possess,
-- manual bar switching with shift + wheel / shift + number).
-- ---------------------------------------------------------------------
local function PageIndex(fn, fallback)
    local f = _G[fn]
    if type(f) ~= "function" and C_ActionBar then f = C_ActionBar[fn] end
    if type(f) == "function" then
        local ok, v = pcall(f)
        if ok and type(v) == "number" and not Secret(v) and v > 0 then return v end
    end
    return fallback
end

function AB.PagingConditions()
    local vehicle = PageIndex("GetVehicleBarIndex", 12)
    local parts = {
        ("[overridebar] %d"):format(PageIndex("GetOverrideBarIndex", 14)),
        ("[vehicleui] %d"):format(vehicle),
        ("[possessbar] %d"):format(vehicle),
        ("[shapeshift] %d"):format(PageIndex("GetTempShapeshiftBarIndex", 13)),
        "[bonusbar:5] 11", "[bonusbar:1] 7", "[bonusbar:2] 8", "[bonusbar:3] 9", "[bonusbar:4] 10",
    }
    for p = 2, 6 do parts[#parts + 1] = ("[bar:%d] %d"):format(p, p) end
    parts[#parts + 1] = "1"
    return table.concat(parts, "; ")
end

-- ---------------------------------------------------------------------
-- Visibility (secure): hidden in pet battles / vehicles, pet bar without
-- a pet, stance bar without forms. Everything shows while moving.
-- ---------------------------------------------------------------------
function AB.VisCondition(key)
    local d = DEF_BY[key]
    if unlocked then return "show" end
    if d.kind == "totem" then return "[petbattle] hide; show" end
    if d.kind == "stance" then
        local n = GetNumShapeshiftForms and GetNumShapeshiftForms() or 0
        if Secret(n) or n == 0 then return "hide" end
    end
    local c = "[petbattle] hide; [vehicleui] hide; [overridebar] hide; "
    if d.kind == "pet" then c = c .. "[nopet] hide; " end
    return c .. "show"
end

local function ApplyVisibility(key)
    local f = frames[key]
    if not f then return end
    if InCombatLockdown() then pendingLayout = true; return end
    UnregisterStateDriver(f, "visibility")
    if not AB.IsEnabled() or BV(key, "enabled") == false then
        f:Hide()
        if f.SetLocked then f:SetLocked(true) end
        return
    end
    RegisterStateDriver(f, "visibility", AB.VisCondition(key))
    if f.SetLocked then f:SetLocked(not unlocked) end
end

-- ---------------------------------------------------------------------
-- Empty slots: drawn behind the buttons with plain textures (nothing
-- protected, so it works in combat): always with "Show empty slots",
-- and while a spell or item is being dragged or the bars are unlocked.
-- ---------------------------------------------------------------------
local function DrawSlots(f)
    local a = f._slotArgs
    f._slots = f._slots or {}
    local n, pos, s, key = 0, nil, 36, nil
    if a then key, n, pos, s = a[1], a[2], a[3], a[4] end
    local on = a and (gridShown or unlocked or BV(key, "showEmpty") == true)
    for i = 1, 12 do
        local t = f._slots[i]
        if on and i <= n then
            if not t then
                t = f:CreateTexture(nil, "BACKGROUND", nil, -8)
                t:SetTexture(WHITE)
                f._slots[i] = t
            end
            t:SetVertexColor(0.03, 0.025, 0.02, 0.55)
            t:ClearAllPoints()
            t:SetPoint("TOPLEFT", f, "TOPLEFT", pos[i][1], pos[i][2])
            t:SetSize(s, s)
            t:Show()
        elseif t then
            t:Hide()
        end
    end
end

local function RefreshSlots()
    for _, f in pairs(frames) do DrawSlots(f) end
end

-- ---------------------------------------------------------------------
-- Layout
-- ---------------------------------------------------------------------
-- Attachment sides: f's point, target's point, gap direction (x, y),
-- offset axis.
local SIDES = {
    TOP    = { "BOTTOM", "TOP",    0,  1, "x" },   -- above the target
    BOTTOM = { "TOP",    "BOTTOM", 0, -1, "x" },   -- below
    LEFT   = { "RIGHT",  "LEFT",  -1,  0, "y" },   -- left of it
    RIGHT  = { "LEFT",   "RIGHT",  1,  0, "y" },   -- right of it
}
AB.SIDES = SIDES

local function Attach(key)
    local a = BarDB(key).attach
    if type(a) == "table" and a.to and a.to ~= key and SIDES[a.side] and frames[a.to] then return a end
end

local function Anchor(f, key, scale)
    scale = scale or 1
    f:ClearAllPoints()
    local a = Attach(key)
    if a then
        local sd = SIDES[a.side]
        local gap, off = (tonumber(a.gap) or 0) / scale, (tonumber(a.off) or 0) / scale
        local x = sd[3] * gap + (sd[5] == "x" and off or 0)
        local y = sd[4] * gap + (sd[5] == "y" and off or 0)
        f:SetPoint(sd[1], frames[a.to], sd[2], x, y)
        return
    end
    f:SetPoint("CENTER", UIParent, "CENTER", (BV(key, "x") or 0) / scale, (BV(key, "y") or 0) / scale)
end

-- Would attaching key to target loop back (target already hangs on key)?
function AB.CanAttach(key, target)
    if not target or target == key then return false end
    local seen, cur = {}, target
    while cur and not seen[cur] do
        if cur == key then return false end
        seen[cur] = true
        local a = BarDB(cur).attach
        cur = type(a) == "table" and a.to or nil
    end
    return true
end

--- Attach key to target on a side (nil target: detach, keeping the spot).
function AB.SetAttach(key, target, side, gap, off)
    local bc = BarDB(key)
    local f = frames[key]
    if target and AB.CanAttach(key, target) then
        bc.attach = { to = target, side = SIDES[side] and side or "TOP", gap = gap or 2, off = off or 0 }
    else
        if f and type(bc.attach) == "table" then
            local cx, cy = f:GetCenter()
            local ux, uy = UIParent:GetCenter()
            local sc = f:GetEffectiveScale() / UIParent:GetEffectiveScale()
            if cx and ux then bc.x, bc.y = Round(cx * sc - ux), Round(cy * sc - uy) end
        end
        bc.attach = nil
    end
    if AB.QueueLayout then AB.QueueLayout() end
end

-- Edges of a bar in UIParent units (l, r, b, t).
local function Rect(f)
    local cx, cy = f:GetCenter()
    if not cx then return nil end
    local sc = f:GetEffectiveScale() / UIParent:GetEffectiveScale()
    local w, h = f:GetWidth() * sc, f:GetHeight() * sc
    cx, cy = cx * sc, cy * sc
    return cx - w / 2, cx + w / 2, cy - h / 2, cy + h / 2
end

-- Closest side of another rect within `reach` px, with gap and offset.
local function FindSnap(r, others, reach)
    local l, rr, b, t = r[1], r[2], r[3], r[4]
    local best
    for key, o in pairs(others) do
        local ol, orr, ob, ot = o[1], o[2], o[3], o[4]
        local hov = math.min(rr, orr) - math.max(l, ol) > 0
        local vov = math.min(t, ot) - math.max(b, ob) > 0
        local cands = {
            { "TOP",    b - ot,  hov, ((l + rr) - (ol + orr)) / 2 },
            { "BOTTOM", ob - t,  hov, ((l + rr) - (ol + orr)) / 2 },
            { "LEFT",   ol - rr, vov, ((b + t) - (ob + ot)) / 2 },
            { "RIGHT",  l - orr, vov, ((b + t) - (ob + ot)) / 2 },
        }
        for _, c in ipairs(cands) do
            local d = c[2]
            if c[3] and d > -reach and d < reach and (not best or math.abs(d) < math.abs(best.d)) then
                best = { to = key, side = c[1], d = d, gap = math.max(0, Round(d)), off = Round(c[4]) }
            end
        end
    end
    if best and math.abs(best.off) <= 10 then best.off = 0 end   -- centred when close
    return best
end
AB.FindSnap = FindSnap

local function LayoutTotem(f, light)
    if not TOTEM then return end
    placing = placing + 1
    if TOTEM:GetParent() ~= f then TOTEM:SetParent(f) end
    local slot = _G.MultiCastSlotButton1
    local nat = (slot and Native(slot).w) or 30
    local scale = math.max(0.5, math.min(2.5, (tonumber(BV("totem", "size")) or nat) / nat))
    f:SetScale(scale)
    local w, h = TOTEM:GetSize()
    if type(w) ~= "number" or Secret(w) or w < 10 then w, h = 160, 36 end
    f:SetSize(w, h)
    Anchor(f, "totem", scale)
    TOTEM:ClearAllPoints()
    TOTEM:SetPoint("CENTER", f, "CENTER", 0, 0)
    placing = placing - 1
    if not light then ApplyVisibility("totem") end
end

local function LayoutBar(key, light)
    local f, list = frames[key], buttons[key]
    if not f then return end
    if InCombatLockdown() then pendingLayout = true; if not light then pendingFull = true end; return end
    local d = DEF_BY[key]
    if d.kind == "totem" then return LayoutTotem(f, light) end
    local n = AB.Count(key)
    local W, H, pos, s = AB.Grid(key, n)
    placing = placing + 1
    Anchor(f, key)
    f:SetSize(W, H)
    for i, b in pairs(list) do
        if i <= n then
            if b:GetParent() ~= f then b:SetParent(f) end
            if b:GetScale() ~= 1 then b:SetScale(1) end
            FitButton(b, s)
            b:ClearAllPoints()
            b:SetPoint("TOPLEFT", f, "TOPLEFT", pos[i][1], pos[i][2])
        elseif b:GetParent() ~= hidden then
            b:SetParent(hidden)
        end
    end
    if not d.kind then
        -- Buttons Blizzard hid for its own icon count come back, from the
        -- secure environment. Empty ones stay hidden unless dragging.
        f:Execute(("local n = %d for i, b in pairs(btns) do if i <= n then b:SetAttribute('statehidden', nil) end end"):format(n))
        for i = 1, n do
            local b = list[i]
            local action = b and b.action
            if action and not Secret(action) and HasAction(action) then b:Show() end
        end
    end
    placing = placing - 1
    f._slotArgs = { key, n, pos, s }
    DrawSlots(f)
    if not light then ApplyVisibility(key) end
end

local function LayoutAll(light)
    if not adopted then return end
    if InCombatLockdown() then pendingLayout = true; if not light then pendingFull = true end; return end
    pendingLayout = false
    for key in pairs(frames) do LayoutBar(key, light) end
    if not light then
        local ABS = TomoMod_ActionBarSkin
        if ABS and ABS.Refresh then ABS.Refresh() end
        if ABS and ABS.ApplyFade then ABS.ApplyFade() end
    end
end
AB.LayoutAll = LayoutAll

-- Blizzard moves its buttons around (Edit Mode, icon count, slot
-- changes): coalesced into one light re-layout on the next frame.
local queued = false
local function QueueLayout(light)
    if not light then pendingFull = true end
    if queued then return end
    queued = true
    C_Timer.After(0, function()
        queued = false
        if InCombatLockdown() then pendingLayout = true; return end
        local full = pendingFull
        pendingFull = false
        LayoutAll(not full)
    end)
end
AB.QueueLayout = QueueLayout

local function OnBlizzMove()
    if placing > 0 or not adopted then return end
    QueueLayout(true)
end

-- ---------------------------------------------------------------------
-- Secure bars
-- ---------------------------------------------------------------------
local function CreateBar(d, list)
    local f = CreateFrame("Frame", "TomoMod_ActionBar_" .. d.key, UIParent, "SecureHandlerStateTemplate")
    f.key = d.key
    f:SetSize(1, 1)
    f:SetPoint("CENTER")
    f:SetFrameStrata("MEDIUM")
    f:SetClampedToScreen(true)
    for i, b in pairs(list) do f:SetFrameRef("b" .. i, b) end
    f:Execute([[
        btns = newtable()
        for i = 1, 12 do
            local b = self:GetFrameRef("b" .. i)
            if b then btns[i] = b end
        end
    ]])
    if d.page then
        f:Execute(([[
            self:SetAttribute("actionpage", %d)
            for _, b in pairs(btns) do b:SetAttribute("actionpage", %d) end
        ]]):format(d.page, d.page))
    elseif d.paged then
        f:SetAttribute("_onstate-page", [[
            local page = tonumber(newstate) or 1
            self:SetAttribute("actionpage", page)
            for _, b in pairs(btns) do b:SetAttribute("actionpage", page) end
        ]])
        RegisterStateDriver(f, "page", AB.PagingConditions())
    end
    return f
end

-- Drag handle (TMF mover look) and the saved position: centre offsets
-- from the middle of the screen, like the capture.
local function SetupMover(f)
    local U = TomoMod_Utils
    if not (U and U.SetupDraggable) then return end
    U.SetupDraggable(f, function()
        local cx, cy = f:GetCenter()
        local ux, uy = UIParent:GetCenter()
        if not (cx and ux) then return end
        local s = f:GetEffectiveScale() / UIParent:GetEffectiveScale()
        local key = f.key
        local bc = BarDB(key)
        bc.x, bc.y = Round(cx * s - ux), Round(cy * s - uy)
        bc.attach = nil
        -- Dropped against another bar: attached to it (magnet). Bars 1 to 8
        -- only: pet, stance and totem bars never stick nor get stuck to.
        local r = { Rect(f) }
        if r[1] and not DEF_BY[key].kind then
            local others = {}
            for k, o in pairs(frames) do
                if k ~= key and not DEF_BY[k].kind and o:IsShown() and BV(k, "enabled") ~= false and AB.CanAttach(key, k) then
                    local orr = { Rect(o) }
                    if orr[1] then others[k] = orr end
                end
            end
            local snap = FindSnap(r, others, 16)
            if snap then
                bc.attach = { to = snap.to, side = snap.side, gap = snap.gap, off = snap.off }
                if not bc.group and BarDB(snap.to).group then
                    AB.JoinGroup(key, BarDB(snap.to).group)
                end
            end
        end
        Anchor(f, key, f:GetScale())
        if bc.attach then QueueLayout() end
    end, AB.Label(f.key))
end

local function HookButton(b)
    hooksecurefunc(b, "SetPoint", OnBlizzMove)
    hooksecurefunc(b, "SetParent", OnBlizzMove)
    hooksecurefunc(b, "SetScale", OnBlizzMove)
end

-- Blizzard bars: emptied and out of sight, their events left alone (they
-- keep the pet and stance buttons up to date). The main bar stays "shown"
-- at alpha 0 (Blizzard's vehicle / override transitions expect it).
local blizzDone = {}
local function HideBlizzard(defs)
    for _, d in ipairs(defs) do
        for _, name in ipairs(d.blizz) do
            local bar = _G[name]
            if bar and not blizzDone[bar] then
                blizzDone[bar] = true
                if name == "MainActionBar" or name == "MainMenuBar" then
                    bar:SetAlpha(0)
                    bar:EnableMouse(false)
                    local guard = false
                    hooksecurefunc(bar, "SetAlpha", function(self, a)
                        if guard or a == 0 then return end
                        guard = true; self:SetAlpha(0); guard = false
                    end)
                    local pager = bar.ActionBarPageNumber
                    if pager then
                        for _, k in ipairs({ "UpButton", "DownButton" }) do
                            if pager[k] and pager[k].EnableMouse then pager[k]:EnableMouse(false) end
                        end
                    end
                else
                    bar:SetParent(hidden)
                    hooksecurefunc(bar, "SetParent", function(self, p)
                        if p ~= hidden and not InCombatLockdown() then self:SetParent(hidden) end
                    end)
                end
                for _, m in ipairs({ "UpdateGridLayout", "UpdateShownButtons", "UpdateVisibility" }) do
                    if type(bar[m]) == "function" then hooksecurefunc(bar, m, OnBlizzMove) end
                end
            end
        end
    end
end

-- First adoption: positions, icon count, rows and size read from
-- Blizzard's bars, so the screen looks the same right after turning on.
local function Capture(defs)
    local uiW, uiH = UIParent:GetSize()
    local us = UIParent:GetEffectiveScale()
    for idx, d in ipairs(defs) do
        local bc = BarDB(d.key)
        local bar
        if d.kind == "totem" then bar = _G.MultiCastActionBarFrame end
        for _, name in ipairs(d.blizz) do bar = bar or _G[name] end
        pcall(function()
            local b1 = d.kind == "totem" and _G.MultiCastSlotButton1 or (d.prefix and _G[d.prefix .. "1"])
            if b1 then
                local w = b1:GetWidth() * b1:GetEffectiveScale() / us
                if w > 10 then bc.size = Round(w) end
            end
            if bar and not d.kind then
                if d.key ~= "bar1" then bc.enabled = bar:IsShown() and true or false end
                local n = bar.numButtonsShowable
                if type(n) == "number" and n > 0 then bc.count = n end
                local rows = bar.numRows
                if type(rows) == "number" and rows > 0 then
                    local cnt = bc.count or d.count
                    bc.perRow = (bar.isHorizontal == false) and rows or math.ceil(cnt / rows)
                end
                if type(bar.buttonPadding) == "number" then bc.spacing = Round(bar.buttonPadding) end
            end
            if bar and bar:IsShown() then
                local cx, cy = bar:GetCenter()
                local s = bar:GetEffectiveScale()
                if cx and cy and not Secret(cx) then
                    bc.x = Round(cx * s / us - uiW / 2)
                    bc.y = Round(cy * s / us - uiH / 2)
                end
            end
        end)
        -- Nothing to read (bar off, missing): stacked above the bottom.
        if bc.x == nil or bc.y == nil then
            bc.x, bc.y = 0, Round(-uiH / 2 + 60 + (idx - 1) * 44)
        end
    end
end

-- Bars 1 to 8 Blizzard had stacked (edges within 8 px, overlapping) are
-- attached, from the bottom up, so they move and resize together.
local function AttachCaptured(defs)
    local rects, order = {}, {}
    for _, d in ipairs(defs) do
        local bc = BarDB(d.key)
        if not d.kind and bc.enabled ~= false and bc.x and bc.y then
            local W, H = AB.Grid(d.key, AB.Count(d.key))
            rects[d.key] = { bc.x - W / 2, bc.x + W / 2, bc.y - H / 2, bc.y + H / 2 }
            order[#order + 1] = d.key
        end
    end
    table.sort(order, function(a, b) return rects[a][3] < rects[b][3] end)
    for i = 2, #order do
        local key = order[i]
        local below = {}
        for j = 1, i - 1 do
            local k = order[j]
            if AB.CanAttach(key, k) then below[k] = rects[k] end
        end
        local snap = FindSnap(rects[key], below, 8)
        if snap then BarDB(key).attach = { to = snap.to, side = snap.side, gap = snap.gap, off = snap.off } end
    end
end

-- Profile without a capture while the bars are already ours: take the
-- current layout as the starting point.
local function CaptureFromOwn(defs)
    for _, d in ipairs(defs) do
        local bc, f = BarDB(d.key), frames[d.key]
        if f and (bc.x == nil or bc.y == nil) then
            local cx, cy = f:GetCenter()
            local ux, uy = UIParent:GetCenter()
            local s = f:GetEffectiveScale() / UIParent:GetEffectiveScale()
            if cx and ux then bc.x, bc.y = Round(cx * s - ux), Round(cy * s - uy) end
        end
    end
end

local function AdoptTotem(d)
    TOTEM = _G.MultiCastActionBarFrame
    if not TOTEM then return end
    local f = CreateBar(d, {})
    frames[d.key], buttons[d.key] = f, {}
    hooksecurefunc(TOTEM, "SetPoint", OnBlizzMove)
    hooksecurefunc(TOTEM, "SetParent", OnBlizzMove)
    -- Blizzard shows the bar when totems are learnt: size follows.
    hooksecurefunc(TOTEM, "Show", function() if adopted then QueueLayout(true) end end)
end

function AB.Adopt()
    if adopted then return true end
    if not AB.IsEnabled() then return false end
    if InCombatLockdown() then pendingAdopt = true; return false end
    local other = AB.Conflict()
    if other then
        AB.conflict = other
        return false
    end
    pendingAdopt = false
    local defs = AB.ActiveDefs()
    local l = LDB()
    if not l.captured then
        Capture(defs)
        AttachCaptured(defs)
        l.captured = true
    end
    HideBlizzard(defs)
    for _, d in ipairs(defs) do
        if d.kind == "totem" then
            AdoptTotem(d)
        else
            local list = {}
            for i = 1, d.count do
                local b = _G[d.prefix .. i]
                if b then
                    list[i] = b
                    owner[b] = d.key
                    Native(b)
                    HookButton(b)
                end
            end
            if list[1] then
                frames[d.key] = CreateBar(d, list)
                buttons[d.key] = list
            end
        end
    end
    for _, f in pairs(frames) do SetupMover(f) end
    adopted = true
    LayoutAll()
    return true
end

-- ---------------------------------------------------------------------
-- Groups (sets of bars sharing their settings)
-- ---------------------------------------------------------------------
function AB.Groups()
    local l = LDB()
    if not l then return {} end
    if type(l.groups) ~= "table" then l.groups = {} end
    return l.groups
end

function AB.GroupMembers(id)
    local out = {}
    for _, d in ipairs(DEFS) do
        if BarDB(d.key).group == id then out[#out + 1] = d.key end
    end
    return out
end

-- Effective shared settings of a bar (copied into or out of a group).
local function SharedOf(key)
    local t = {}
    for prop in pairs(SHARED) do t[prop] = BV(key, prop) end
    return t
end

-- Bars connected to key by attachments, in either direction.
function AB.Connected(key)
    local set, list = { [key] = true }, { key }
    local changed = true
    while changed do
        changed = false
        for _, d in ipairs(DEFS) do
            local a = BarDB(d.key).attach
            local to = type(a) == "table" and a.to
            if to and set[to] ~= set[d.key] then
                local add = set[to] and d.key or to
                if not set[add] then set[add] = true; list[#list + 1] = add; changed = true end
            end
        end
    end
    return list
end

function AB.JoinGroup(key, id)
    local g = id and AB.Groups()[id]
    if not g or DEF_BY[key].kind == "totem" then return end
    BarDB(key).group = id
    QueueLayout()
end

--- Leaves the group, keeping the shared settings as the bar's own.
--- An emptied group is deleted.
function AB.LeaveGroup(key)
    local bc = BarDB(key)
    local g, id = GroupOf(key)
    if not g then bc.group = nil; return end
    for prop, v in pairs(g.settings) do bc[prop] = v end
    bc.group = nil
    if #AB.GroupMembers(id) == 0 then AB.Groups()[id] = nil end
    QueueLayout()
end

--- New group from key's settings, with every bar attached to it.
function AB.NewGroup(key)
    local groups = AB.Groups()
    local n = 1
    while groups["g" .. n] do n = n + 1 end
    local id = "g" .. n
    groups[id] = { name = T("Ensemble ", "Set ") .. n, settings = SharedOf(key) }
    for _, k in ipairs(AB.Connected(key)) do
        if DEF_BY[k] and DEF_BY[k].kind ~= "totem" then
            if BarDB(k).group and BarDB(k).group ~= id then AB.LeaveGroup(k) end
            BarDB(k).group = id
        end
    end
    QueueLayout()
    return id
end

function AB.GroupName(id)
    local g = id and AB.Groups()[id]
    return g and g.name or id
end

-- ---------------------------------------------------------------------
-- Move mode (driven by TMF's layout mode, /tmf layout)
-- ---------------------------------------------------------------------
function AB.SetUnlocked(on)
    unlocked = on and true or false
    if not adopted then return end
    if InCombatLockdown() then pendingLayout = true; pendingFull = true; return end
    LayoutAll()
end

--- Puts one bar back above the bottom of the screen (lost off-screen).
function AB.ResetPosition(key)
    local bc = BarDB(key)
    bc.attach = nil
    local idx = 1
    for i, d in ipairs(DEFS) do if d.key == key then idx = i end end
    local _, uiH = UIParent:GetSize()
    bc.x, bc.y = 0, Round(-uiH / 2 + 60 + (idx - 1) * 44)
    QueueLayout()
end

-- Blizzard's quick keybind mode: works as is, the buttons are Blizzard's.
function AB.OpenQuickKeybind()
    if InCombatLockdown() then return false end
    local qk = _G.QuickKeybindFrame
    if not qk then return false end
    local C = TomoMod_Config
    if C and C.Hide then pcall(C.Hide) end
    qk:Show()
    return true
end

-- ---------------------------------------------------------------------
-- Apply (GUI, profile load through ActionBarSkin.ApplySettings)
-- ---------------------------------------------------------------------
function AB.ApplySettings()
    if not TomoModForeverDB then return end
    if not AB.IsEnabled() then
        if adopted and not reloadAsked then
            reloadAsked = true
            if not InCombatLockdown() then
                for _, f in pairs(frames) do UnregisterStateDriver(f, "visibility"); f:Hide() end
            end
            local l = LDB()
            if l and l.enabled and not AB.Expert() then
                print("|cffffd100TomoModForever|r " .. T(
                    "Mode simple : les barres d'action TMF sont réservées au mode expert. Les barres de Blizzard (avec le skin) reviennent après un /reload.",
                    "Simple mode: TMF action bars are an expert-mode feature. Blizzard's bars (skinned) come back after a /reload."))
            else
                print("|cffffd100TomoModForever|r " .. T(
                    "Barres d'action TMF désactivées : les barres de Blizzard reviennent après un /reload.",
                    "TMF action bars turned off: Blizzard's bars come back after a /reload."))
            end
            if StaticPopupDialogs and StaticPopupDialogs["TOMOMOD_MODULE_RELOAD"] then
                StaticPopup_Show("TOMOMOD_MODULE_RELOAD")
            end
        end
        return
    end
    reloadAsked = false
    -- Before the world is up (profile applied at login), the adoption
    -- waits for PLAYER_ENTERING_WORLD: Edit Mode has not placed the bars.
    if not adopted then
        if worldReady then AB.Adopt() end
        return
    end
    local l = LDB()
    if not l.captured then CaptureFromOwn(AB.ActiveDefs()); l.captured = true end
    if InCombatLockdown() then pendingLayout = true; pendingFull = true; return end
    LayoutAll()
end

function AB.Initialize()
    local M = TomoMod_Movers
    if M and M.RegisterEntry then
        M.RegisterEntry({
            label    = T("Barres d'action", "Action bars"),
            unlock   = function() AB.SetUnlocked(true) end,
            lock     = function() AB.SetUnlocked(false) end,
            isActive = function() return adopted and AB.IsEnabled() end,
        })
    end
end

local ev = CreateFrame("Frame")
for _, e in ipairs({ "PLAYER_ENTERING_WORLD", "PLAYER_REGEN_ENABLED", "UPDATE_SHAPESHIFT_FORMS",
                     "ACTIONBAR_SHOWGRID", "ACTIONBAR_HIDEGRID", "UPDATE_MULTI_CAST_ACTIONBAR",
                     "EDIT_MODE_LAYOUTS_UPDATED" }) do
    pcall(ev.RegisterEvent, ev, e)   -- an event this client lacks is skipped
end
ev:SetScript("OnEvent", function(_, event)
    if event == "ACTIONBAR_SHOWGRID" or event == "ACTIONBAR_HIDEGRID" then
        gridShown = event == "ACTIONBAR_SHOWGRID"
        if adopted then RefreshSlots() end
        return
    end
    if event == "PLAYER_ENTERING_WORLD" and not worldReady then
        C_Timer.After(0.5, function() worldReady = true end)
    end
    if not (TomoModForeverDB and AB.IsEnabled()) then return end
    if event == "PLAYER_ENTERING_WORLD" then
        -- Half a second: Edit Mode places Blizzard's bars around this
        -- event, and the first capture must read their final spots.
        if not adopted then C_Timer.After(0.5, AB.Adopt) else QueueLayout() end
    elseif event == "PLAYER_REGEN_ENABLED" then
        if pendingAdopt then AB.Adopt() end
        if pendingLayout and adopted then
            local full = pendingFull
            pendingFull = false
            LayoutAll(not full)
        end
    elseif adopted then
        QueueLayout(event ~= "UPDATE_SHAPESHIFT_FORMS" and event ~= "UPDATE_MULTI_CAST_ACTIONBAR")
    end
end)
