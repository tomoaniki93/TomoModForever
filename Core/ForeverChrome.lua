-- =====================================================================
-- Core/ForeverChrome.lua -- the WoW: Forever look, shared (1.3.9)
--
-- Bronze moulding, filigree corners with a gold gem, a crest, tiled dark
-- leather, golden title plates, bronze button settings and a glint that
-- runs along a border now and then. Used by the chat, the minimap and its
-- info panel, and the damage meter's "Forever" skin.
--
-- Textures: Assets/Textures/Forever/ (drawn for TMF, see tools in the repo
-- history). Every animation follows the global level (TomoMod_Utils.AnimLevel):
-- the glint only runs with full animations, pulses only when not "none".
-- Nothing here takes the mouse.
-- =====================================================================

TomoMod_ForeverChrome = TomoMod_ForeverChrome or {}
local FC = TomoMod_ForeverChrome

FC.TEX   = "Interface\\AddOns\\TomoModForever\\Assets\\Textures\\Forever\\"
FC.WHITE = "Interface\\Buttons\\WHITE8X8"

-- Palette (WoW: Forever): aged bronze, antique gold, golden titles,
-- off-white text, warm dark leather.
FC.C = {
    title      = { 1.000, 0.820, 0.000 },
    text       = { 0.949, 0.922, 0.859 },
    muted      = { 0.760, 0.700, 0.600 },
    dim        = { 0.520, 0.470, 0.400 },
    antique    = { 0.788, 0.635, 0.322 },
    bronze     = { 0.620, 0.420, 0.210 },
    bronzeDark = { 0.300, 0.190, 0.090 },
    fill       = { 0.072, 0.056, 0.040 },
    fillHover  = { 0.115, 0.088, 0.058 },
    red        = { 0.950, 0.300, 0.250 },
    yellow     = { 1.000, 0.780, 0.200 },
    green      = { 0.450, 0.900, 0.450 },
}

local function AnimLevel()
    local U = TomoMod_Utils
    return (U and U.AnimLevel and U.AnimLevel()) or "full"
end
FC.AnimLevel = AnimLevel

-- ---------------------------------------------------------------------
-- Fills
-- ---------------------------------------------------------------------

--- Tiled leather on a texture.
function FC.Fill(tex, alpha)
    tex:SetTexture(FC.TEX .. "fill", "REPEAT", "REPEAT")
    if tex.SetHorizTile then tex:SetHorizTile(true) end
    if tex.SetVertTile then tex:SetVertTile(true) end
    tex:SetVertexColor(1, 1, 1, alpha or 1)
end

--- Tiled leather as a frame's backdrop; edge: thin bronze line.
function FC.Backdrop(frame, alpha, edge)
    if not frame.SetBackdrop then return end
    frame:SetBackdrop({
        bgFile = FC.TEX .. "fill", tile = true, tileSize = 256,
        edgeFile = edge and FC.WHITE or nil, edgeSize = edge and 1 or nil,
    })
    frame:SetBackdropColor(1, 1, 1, alpha or 0.94)
    if edge then
        local b = FC.C.bronze
        frame:SetBackdropBorderColor(b[1], b[2], b[3], 0.9)
    end
end

-- ---------------------------------------------------------------------
-- Frame chrome: moulding, corners, crest, glint
-- ---------------------------------------------------------------------
local chromes = {}

local function Flip(tex, fx, fy)
    local l, r = fx and 1 or 0, fx and 0 or 1
    local t, b = fy and 1 or 0, fy and 0 or 1
    tex:SetTexCoord(l, r, t, b)
end

local function LayoutGlint(ch)
    if not ch.glint then return end
    local w = ch:GetWidth()
    if type(w) ~= "number" or w <= 0 then return end
    local gw = ch.glint:GetWidth()
    ch.glintMove:SetOffset(math.max(0, w - gw - ch.opts.corner), 0)
end

local function PlayGlint(ch)
    if not ch.glintGroup then return end
    if ch.opts.glint and ch:IsShown() and AnimLevel() == "full" then
        LayoutGlint(ch)
        if not ch.glintGroup:IsPlaying() then ch.glintGroup:Play() end
    else
        ch.glintGroup:Stop()
        ch.glint:SetAlpha(0)
    end
end

--- Chrome around `host`.
-- opts: outset (4), edge (8), corner (30), crest (false), crestWidth (112),
--       crestY (centre on the top moulding),
--       vignette (true), fill (false), fillAlpha (0.92), glint (true),
--       strata, level.
function FC.Frame(host, opts)
    opts = opts or {}
    opts.outset   = opts.outset or 4
    opts.edge     = opts.edge or 8
    opts.corner   = opts.corner or 30
    if opts.vignette == nil then opts.vignette = true end
    if opts.glint == nil then opts.glint = true end

    local ch = CreateFrame("Frame", nil, host)
    ch.opts, ch.host = opts, host
    local o = opts.outset
    ch:SetPoint("TOPLEFT", host, "TOPLEFT", -o, o)
    ch:SetPoint("BOTTOMRIGHT", host, "BOTTOMRIGHT", o, -o)
    if opts.strata then ch:SetFrameStrata(opts.strata) end
    ch:SetFrameLevel(opts.level or (host:GetFrameLevel() + 10))
    ch:EnableMouse(false)

    -- Back layers live on the host so they stay under its content.
    if opts.fill then
        ch.fill = host:CreateTexture(nil, "BACKGROUND", nil, -8)
        ch.fill:SetAllPoints(host)
        FC.Fill(ch.fill, opts.fillAlpha or 0.92)
    end
    if opts.vignette then
        ch.vignette = host:CreateTexture(nil, "BACKGROUND", nil, -6)
        ch.vignette:SetAllPoints(host)
        ch.vignette:SetTexture(FC.TEX .. "vignette")
    end

    local e = opts.edge
    local function Edge(file, p1, p2, horiz)
        local t = ch:CreateTexture(nil, "BORDER")
        t:SetTexture(FC.TEX .. file)
        t:SetPoint(p1)
        t:SetPoint(p2)
        if horiz then t:SetHeight(e) else t:SetWidth(e) end
        return t
    end
    ch.top    = Edge("edge_h",  "TOPLEFT",    "TOPRIGHT",    true)
    ch.bottom = Edge("edge_hb", "BOTTOMLEFT", "BOTTOMRIGHT", true)
    ch.left   = Edge("edge_v",  "TOPLEFT",    "BOTTOMLEFT",  false)
    ch.right  = Edge("edge_vr", "TOPRIGHT",   "BOTTOMRIGHT", false)

    local c, n = opts.corner, -3
    local function Corner(point, fx, fy, x, y)
        local t = ch:CreateTexture(nil, "ARTWORK")
        t:SetTexture(FC.TEX .. "corner")
        t:SetSize(c, c)
        t:SetPoint(point, ch, point, x, y)
        Flip(t, fx, fy)
        return t
    end
    ch.corners = {
        Corner("TOPLEFT",     false, false,  n, -n),
        Corner("TOPRIGHT",    true,  false, -n, -n),
        Corner("BOTTOMLEFT",  false, true,   n,  n),
        Corner("BOTTOMRIGHT", true,  true,  -n,  n),
    }

    if opts.crest then
        local cw = opts.crestWidth or 112
        ch.crest = ch:CreateTexture(nil, "OVERLAY")
        ch.crest:SetTexture(FC.TEX .. "crest")
        ch.crest:SetSize(cw, cw / 4)
        ch.crest:SetPoint("CENTER", ch, "TOP", 0, opts.crestY or (-e / 2))
    end

    -- Glint: a soft light that runs along the top moulding every few seconds.
    if opts.glint then
        local g = ch:CreateTexture(nil, "OVERLAY", nil, 2)
        g:SetTexture(FC.TEX .. "glint")
        g:SetBlendMode("ADD")
        g:SetSize(56, 22)
        g:SetPoint("CENTER", ch, "TOPLEFT", opts.corner, -e / 2)
        g:SetAlpha(0)
        ch.glint = g
        local ag = g:CreateAnimationGroup()
        ag:SetLooping("REPEAT")
        local move = ag:CreateAnimation("Translation")
        move:SetDuration(2.2)
        move:SetSmoothing("IN_OUT")
        move:SetStartDelay(opts.glintDelay or 9)
        local fadeIn = ag:CreateAnimation("Alpha")
        fadeIn:SetFromAlpha(0); fadeIn:SetToAlpha(0.85)
        fadeIn:SetDuration(0.5)
        fadeIn:SetStartDelay(opts.glintDelay or 9)
        local fadeOut = ag:CreateAnimation("Alpha")
        fadeOut:SetFromAlpha(0.85); fadeOut:SetToAlpha(0)
        fadeOut:SetDuration(0.6)
        fadeOut:SetStartDelay((opts.glintDelay or 9) + 1.6)
        ch.glintGroup, ch.glintMove = ag, move
        ch:SetScript("OnSizeChanged", LayoutGlint)
        ch:SetScript("OnShow", PlayGlint)
        ch:SetScript("OnHide", function(self) if self.glintGroup then self.glintGroup:Stop() end end)
    end

    function ch:Toggle(on)
        self:SetShown(on and true or false)
        if self.fill then self.fill:SetShown(on and true or false) end
        if self.vignette then self.vignette:SetShown(on and true or false) end
        PlayGlint(self)
    end

    chromes[#chromes + 1] = ch
    PlayGlint(ch)
    return ch
end

--- Re-read the animation level for every chrome (after the option changed).
function FC.RefreshAnimations()
    for _, ch in ipairs(chromes) do PlayGlint(ch) end
end

-- ---------------------------------------------------------------------
-- Title plate (3-slice): the frame's whole area is the plate.
-- ---------------------------------------------------------------------
function FC.Plate(frame, layer, sub)
    layer = layer or "BACKGROUND"
    local p = {}
    p.l = frame:CreateTexture(nil, layer, nil, sub)
    p.m = frame:CreateTexture(nil, layer, nil, sub)
    p.r = frame:CreateTexture(nil, layer, nil, sub)
    p.l:SetTexture(FC.TEX .. "plate_l")
    p.m:SetTexture(FC.TEX .. "plate_m")
    p.r:SetTexture(FC.TEX .. "plate_r")
    p.l:SetPoint("TOPLEFT"); p.l:SetPoint("BOTTOMLEFT")
    p.r:SetPoint("TOPRIGHT"); p.r:SetPoint("BOTTOMRIGHT")
    p.m:SetPoint("TOPLEFT", p.l, "TOPRIGHT")
    p.m:SetPoint("BOTTOMRIGHT", p.r, "BOTTOMLEFT")
    local function Size()
        local h = frame:GetHeight()
        if type(h) ~= "number" or h <= 0 then h = 24 end
        local w = frame:GetWidth()
        local cap = h * 0.5
        if type(w) == "number" and w > 0 then cap = math.min(cap, w * 0.4) end
        p.l:SetWidth(cap); p.r:SetWidth(cap)
    end
    frame:HookScript("OnSizeChanged", Size)
    Size()
    function p:SetShown(on)
        self.l:SetShown(on); self.m:SetShown(on); self.r:SetShown(on)
    end
    return p
end

-- ---------------------------------------------------------------------
-- Button setting: bronze socket behind an icon, gold glow for states.
-- ---------------------------------------------------------------------
local STATE_COLOR = {
    active  = FC.C.title,
    danger  = FC.C.red,
    warning = FC.C.yellow,
    good    = FC.C.green,
}

function FC.Socket(button, inset)
    if button.fcSocket then return button.fcSocket end
    local s = button:CreateTexture(nil, "BACKGROUND", nil, 2)
    s:SetTexture(FC.TEX .. "socket")
    local i = inset or -1
    s:SetPoint("TOPLEFT", -i, i)
    s:SetPoint("BOTTOMRIGHT", i, -i)
    local hl = button:CreateTexture(nil, "OVERLAY", nil, 6)
    hl:SetTexture(FC.TEX .. "socket_hl")
    hl:SetBlendMode("ADD")
    hl:SetPoint("TOPLEFT", s, "TOPLEFT", -3, 3)
    hl:SetPoint("BOTTOMRIGHT", s, "BOTTOMRIGHT", 3, -3)
    hl:Hide()
    button.fcSocket, button.fcGlow = s, hl
    return s
end

--- mode: "active" | "danger" | "warning" | "good" | "hover" | nil (rest)
function FC.SocketState(button, mode)
    local hl = button.fcGlow
    if not hl then return end
    local c = STATE_COLOR[mode]
    if c then
        hl:SetVertexColor(c[1], c[2], c[3])
        hl:SetAlpha(0.95)
        hl:Show()
    elseif mode == "hover" then
        local a = FC.C.antique
        hl:SetVertexColor(a[1], a[2], a[3])
        hl:SetAlpha(0.55)
        hl:Show()
    else
        hl:Hide()
    end
end

-- ---------------------------------------------------------------------
-- Small animations
-- ---------------------------------------------------------------------

--- Slow alpha breathing on a region (unread markers). Stops at level "none".
function FC.Pulse(region, low, period)
    if region.fcPulse then return region.fcPulse end
    local ag = region:CreateAnimationGroup()
    ag:SetLooping("BOUNCE")
    local a = ag:CreateAnimation("Alpha")
    a:SetFromAlpha(1)
    a:SetToAlpha(low or 0.35)
    a:SetDuration(period or 0.9)
    a:SetSmoothing("IN_OUT")
    region.fcPulse = ag
    region:HookScript("OnShow", function(self)
        if AnimLevel() ~= "none" then self.fcPulse:Play() end
    end)
    region:HookScript("OnHide", function(self) self.fcPulse:Stop() end)
    if region:IsShown() and AnimLevel() ~= "none" then ag:Play() end
    return ag
end

--- One soft flash of a region (text change, zone change).
function FC.Flash(region, from)
    if AnimLevel() == "none" then return end
    if not region.fcFlash then
        local ag = region:CreateAnimationGroup()
        local a = ag:CreateAnimation("Alpha")
        a:SetFromAlpha(from or 0.15)
        a:SetToAlpha(1)
        a:SetDuration(AnimLevel() == "full" and 0.7 or 0.3)
        a:SetSmoothing("OUT")
        region.fcFlash = ag
    end
    region.fcFlash:Stop()
    region.fcFlash:Play()
end
