-- =====================================================================
-- Panels/ActionBars.lua -- skins for Blizzard's action bars
-- Pick a skin from live tiles; every change lands on the real bars.
-- =====================================================================

local K  = TomoMod_Kit
local T  = K.T
local W  = TomoMod_Widgets
local TH = W.Theme
local WHITE = K.WHITE or "Interface\\Buttons\\WHITE8x8"

local SKIN_NAMES = {
    forever = { "Forever",          "Forever" },
    pixel   = { "Pixel",            "Pixel" },
    thick   = { "Bordure épaisse",  "Thick border" },
    shadow  = { "Ombre",            "Shadow" },
    glass   = { "Verre",            "Glass" },
    round   = { "Rond",             "Round" },
}

local ICONS = {
    "Interface\\Icons\\Spell_Fire_FlameBolt",
    "Interface\\Icons\\Spell_Nature_Lightning",
    "Interface\\Icons\\Spell_Holy_HolyBolt",
    "Interface\\Icons\\Ability_Warrior_Charge",
    "Interface\\Icons\\Spell_Shadow_ShadowBolt",
    "Interface\\Icons\\Ability_Rogue_Eviscerate",
}

-- Stand-in buttons drawn on the page, re-skinned on every change.
local samples = {}

local function ABS() return TomoMod_ActionBarSkin end

local function FakeButton(parent, size, icon, hotkey, count)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(size, size)
    b.icon = b:CreateTexture(nil, "BACKGROUND")
    b.icon:SetAllPoints()
    b.icon:SetTexture(icon)
    b.HotKey = b:CreateFontString(nil, "OVERLAY")
    b.HotKey:SetFont(K.FONT, 11, "OUTLINE")
    b.HotKey:SetPoint("TOPRIGHT", -2, -2)
    b.HotKey:SetText(hotkey or "")
    b.Count = b:CreateFontString(nil, "OVERLAY")
    b.Count:SetFont(K.FONT, 12, "OUTLINE")
    b.Count:SetPoint("BOTTOMRIGHT", -2, 2)
    b.Count:SetText(count or "")
    b.HighlightTexture = b:CreateTexture(nil, "HIGHLIGHT")
    b.HighlightTexture:SetAllPoints()
    b.HighlightTexture:SetColorTexture(1, 1, 1, 0.15)
    return b
end

local function Restyle()
    local A = ABS()
    if not A then return end
    for _, s in ipairs(samples) do
        if s.button then A.Skin(s.button, s.skin) end
        if s.tile then
            local sel = (K.Get("barSkin.skin") or "forever") == s.skinKey
            s.tile:SetBackdropBorderColor(sel and 1 or TH.border[1], sel and 0.82 or TH.border[2], sel and 0 or TH.border[3], 1)
            s.tile:SetBackdropColor(TH.accent[1], TH.accent[2], TH.accent[3], sel and 0.18 or 0.03)
        end
    end
end

K.RegisterApplier("abs", function()
    local A = ABS()
    if A and A.ApplySettings then A.ApplySettings() end
    Restyle()
end, false)

-- Tiles: one per skin, each showing a real skinned sample. Click = apply.
local function BuildTiles(parent, y)
    local A = ABS()
    local holder = CreateFrame("Frame", nil, parent)
    holder:SetPoint("TOPLEFT", 16, y)
    holder:SetPoint("TOPRIGHT", -16, y)
    local cols, tileH, gap = 3, 78, 8
    local rows = math.ceil(#A.SKIN_ORDER / cols)
    holder:SetHeight(rows * (tileH + gap))
    local tiles = {}
    for i, key in ipairs(A.SKIN_ORDER) do
        local tile = CreateFrame("Button", nil, holder, "BackdropTemplate")
        tile:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 })
        tile:SetHeight(tileH)
        local fb = FakeButton(tile, 36, ICONS[i], tostring(i), (i == 3) and "3" or nil)
        fb:SetPoint("TOP", 0, -10)
        fb:EnableMouse(false)
        local lbl = tile:CreateFontString(nil, "OVERLAY")
        lbl:SetFont(K.FONT, 10, "")
        lbl:SetPoint("BOTTOM", 0, 8)
        lbl:SetTextColor(TH.text[1], TH.text[2], TH.text[3], 1)
        local nm = SKIN_NAMES[key] or { key, key }
        lbl:SetText(T(nm[1], nm[2]))
        tile:SetScript("OnClick", function()
            K.Set("barSkin.skin", key)
            K.Apply("abs")
        end)
        tile:SetScript("OnEnter", function(s) s:SetBackdropColor(TH.accent[1], TH.accent[2], TH.accent[3], 0.25) end)
        tile:SetScript("OnLeave", function() Restyle() end)
        samples[#samples + 1] = { button = fb, skin = key, tile = tile, skinKey = key }
        tiles[i] = tile
    end
    local function Layout()
        local w = holder:GetWidth() or 0
        if w < 60 then w = 360 end
        local tw = math.floor((w - gap * (cols - 1)) / cols)
        for i, tile in ipairs(tiles) do
            local c, r = (i - 1) % cols, math.floor((i - 1) / cols)
            tile:ClearAllPoints()
            tile:SetPoint("TOPLEFT", holder, "TOPLEFT", c * (tw + gap), -r * (tileH + gap))
            tile:SetWidth(tw)
        end
    end
    holder:SetScript("OnSizeChanged", Layout)
    Layout()
    return y - rows * (tileH + gap) - 4
end

-- A row of six buttons in the current skin, like a real bar.
local function BuildRow(parent, y)
    local holder = CreateFrame("Frame", nil, parent)
    holder:SetPoint("TOPLEFT", 16, y)
    holder:SetPoint("TOPRIGHT", -16, y)
    holder:SetHeight(44)
    local prev
    for i = 1, #ICONS do
        local fb = FakeButton(holder, 38, ICONS[i], tostring(i), (i == 2) and "5" or nil)
        if prev then fb:SetPoint("LEFT", prev, "RIGHT", 4, 0) else fb:SetPoint("LEFT", 0, 0) end
        prev = fb
        samples[#samples + 1] = { button = fb }
    end
    return y - 50
end

K.RegisterPage({
    key = "actionbars",
    section = "combat",
    label = T("Barres d'action", "Action bars"),
    kw = "action bars barres action boutons buttons skin habillage icones icons raccourcis keybinds",
    locate = function() return _G.ActionButton1 end,
    build = function(parent)
        wipe(samples)
        return K.Page(parent, function(page)
            page:Hero(T("Barres d'action", "Action bars"),
                T("Change l'apparence des barres d'action de Blizzard. Leur position et leur taille se règlent toujours dans le Mode Édition du jeu.",
                  "Changes the look of Blizzard's action bars. Their position and size are still set in the game's Edit Mode."),
                function() return _G.ActionButton1 end, T("Barre 1", "Bar 1"))

            local A = ABS()
            if not A then
                local c = page:Card(T("Indisponible", "Unavailable"))
                c:Done()
                return
            end

            local c = page:Card(T("Habillage", "Skin"))
            c:Toggle(T("Habiller les barres d'action", "Skin the action bars"), "barSkin.enabled", "abs",
                T("Désactivé : retour à l'apparence Blizzard.", "Off: back to Blizzard's look."))
            c:Custom(BuildTiles)
            c:Label(T("Aperçu", "Preview"))
            c:Custom(BuildRow)
            c:Done()

            c = page:Card(T("Bordure", "Border"))
            c:Seg(T("Couleur", "Colour"), "barSkin.borderMode", {
                { text = T("Du style", "Skin's"),   value = "skin" },
                { text = T("Classe", "Class"),      value = "class" },
                { text = T("Perso", "Custom"),      value = "custom" },
            }, "abs", 3)
            c:Color(T("Couleur perso", "Custom colour"), "barSkin.borderColor", "abs")
            c:Done()

            c = page:Card(T("Textes", "Texts"))
            c:Pair(function(l) l:Toggle(T("Raccourcis", "Keybinds"), "barSkin.showHotkey", "abs") end,
                   function(r) r:Slider(T("Taille", "Size"), "barSkin.hotkeySize", 7, 18, 1, "abs") end)
            c:Pair(function(l) l:Toggle(T("Noms des macros", "Macro names"), "barSkin.showMacroName", "abs") end,
                   function(r) r:Slider(T("Taille des charges", "Charges size"), "barSkin.countSize", 7, 20, 1, "abs") end)
            c:Done()

            c = page:Card(T("Avancé", "Advanced"), { adv = true })
            c:Slider(T("Zoom des icônes", "Icon zoom"), "barSkin.zoom", 0, 0.2, 0.01, "abs", "%.2f",
                T("Rogne le bord des icônes pour enlever leur cadre d'origine.", "Crops the icon edge to remove its built-in frame."))
            c:Toggle(T("Masquer les ornements de la barre principale", "Hide the main bar ornaments"), "barSkin.hideArt", "abs")
            c:Done()

            Restyle()
        end)
    end,
})
