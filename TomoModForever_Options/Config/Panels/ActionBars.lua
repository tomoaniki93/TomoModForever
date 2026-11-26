-- =====================================================================
-- Panels/ActionBars.lua -- action bars: TMF's own bars (1.4.1) and skins
-- Pick a skin from live tiles; every change lands on the real bars.
-- =====================================================================

local K  = TomoMod_Kit
local T  = K.T
local W  = TomoMod_Widgets
local TH = W.Theme
local WHITE = K.WHITE or "Interface\\Buttons\\WHITE8x8"

local SKIN_NAMES = {
    ornate  = { "Forever orné",     "Forever ornate" },
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
    "Interface\\Icons\\Spell_Nature_HealingTouch",
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

-- [1.4.1] TMF's own bars: moves protected buttons, so it waits for the
-- end of combat (secure applier).
local function ABL() return TomoMod_ActionBars end
K.RegisterApplier("abl", function()
    local A = ABL()
    if A and A.ApplySettings then A.ApplySettings() end
    Restyle()
end, true)

K.RegisterApplier("absfade", function()
    local A = ABS()
    if A and A.ApplyFade then A.ApplyFade() end
end, false)

local BAR_NAMES = {
    bar1 = { "Barre 1 (principale)", "Bar 1 (main)" },
    bar2 = { "Barre 2", "Bar 2" }, bar3 = { "Barre 3", "Bar 3" }, bar4 = { "Barre 4", "Bar 4" },
    bar5 = { "Barre 5", "Bar 5" }, bar6 = { "Barre 6", "Bar 6" }, bar7 = { "Barre 7", "Bar 7" },
    bar8 = { "Barre 8", "Bar 8" },
    pet    = { "Barre du familier", "Pet bar" },
    stance = { "Barre de posture", "Stance bar" },
    totem  = { "Barre des totems", "Totem bar" },
}

-- Bar picked in the layout card (kept between visits).
local function SelectedBar(defs)
    local sel = K.GuiDB().abBar
    for _, d in ipairs(defs) do if d.key == sel then return sel end end
    return defs[1] and defs[1].key or "bar1"
end

local function LayoutCards(page)
    local A = ABL()
    if not A then return end
    local on = A.IsEnabled and A.IsEnabled()

    local c = page:Card(T("Barres TMF", "TMF bars"))
    c:Info(T("TMF place les boutons du jeu dans ses propres barres : tu choisis leur taille, leur nombre de boutons, leurs lignes et tu les déplaces avec le mode Disposition. Tes sorts, macros et raccourcis restent les mêmes.",
             "TMF puts the game's buttons into its own bars: you choose their size, button count and rows, and move them with Layout mode. Your spells, macros and keybinds stay the same."))
    c:Toggle(T("Utiliser les barres d'action TMF", "Use TMF action bars"), {
        get = function() return K.Get("barSkin.layout.enabled") == true end,
        set = function(v)
            local was = K.Get("barSkin.layout.enabled") == true
            K.Set("barSkin.layout.enabled", v and true or false)
            if was and not v and A.IsAdopted and A.IsAdopted() then K.NeedReload() end
            K.RefreshPage()
        end,
        default = false,
    }, "abl", T("Désactivé : les barres de Blizzard reviennent après un /reload.", "Off: Blizzard's bars come back after a /reload."))
    local other = A.Conflict and A.Conflict()
    if other then
        c:Info(string.format(T("|cffff8855%s gère déjà les barres d'action : les barres TMF restent en retrait.|r",
                               "|cffff8855%s already handles the action bars: TMF bars stand down.|r"), other))
    end
    if not on then c:Done(); return end
    c:Pair(function(l) l:Button(T("Déplacer les barres", "Move the bars"), function()
                local M = TomoMod_Movers
                if M and M.Toggle then M.Toggle() end
            end, 170, T("Ouvre le mode Disposition : glisse les barres où tu veux, puis verrouille.", "Opens Layout mode: drag the bars where you want, then lock."))
           end,
           function(r) r:Button(T("Raccourcis clavier", "Keybinds"), function()
                if not (A.OpenQuickKeybind and A.OpenQuickKeybind()) and SlashCmdList and SlashCmdList.TOMOMOD_KB then
                    SlashCmdList.TOMOMOD_KB()
                end
            end, 170, T("Survole un bouton et appuie sur une touche pour l'assigner (aussi : /kb).", "Hover a button and press a key to bind it (also: /kb)."))
           end)
    c:Done()

    local defs = A.ActiveDefs and A.ActiveDefs() or {}
    local key = SelectedBar(defs)
    local def
    for _, d in ipairs(defs) do if d.key == key then def = d end end
    local opts = {}
    for _, d in ipairs(defs) do opts[#opts + 1] = { text = A.Label(d.key), value = d.key } end

    c = page:Card(T("Disposition", "Layout"))
    c:Seg(T("Barre à régler", "Bar to set up"), {
        get = function() return key end,
        set = function(v) K.GuiDB().abBar = v; K.RefreshPage() end,
    }, opts, nil, 4)
    local base = "barSkin.layout.bars." .. key .. "."
    c:Toggle(T("Afficher cette barre", "Show this bar"), base .. "enabled", "abl")
    if def and def.kind == "totem" then
        c:Slider(T("Taille", "Size"), base .. "size", 20, 64, 1, "abl")
        c:Info(T("Les totems gardent la disposition du jeu ; seules leur taille et leur place changent.",
                 "Totems keep the game's arrangement; only their size and place change."))
    else
        local max = (def and def.count) or 12
        c:Pair(function(l) l:Slider(T("Nombre de boutons", "Buttons"), base .. "count", 1, max, 1, "abl") end,
               function(r) r:Slider(T("Boutons par ligne", "Buttons per row"), base .. "perRow", 1, max, 1, "abl") end)
        c:Pair(function(l) l:Slider(T("Taille des boutons", "Button size"), base .. "size", 20, 64, 1, "abl") end,
               function(r) r:Slider(T("Espacement", "Spacing"), base .. "spacing", 0, 12, 1, "abl") end)
    end
    c:Done()

    c = page:Card(T("Disposition avancée", "Advanced layout"), { adv = true })
    if not (def and def.kind == "totem") then
        c:Toggle(T("Afficher les cases vides", "Show empty slots"), base .. "showEmpty", "abl",
            T("Les cases vides apparaissent toujours quand tu glisses un sort ou en mode Disposition.",
              "Empty slots always show while dragging a spell or in Layout mode."))
        c:Toggle(T("Première ligne en bas", "First row at the bottom"), base .. "growUp", "abl")
    end
    c:Button(T("Remettre la barre en bas de l'écran", "Bring the bar back to the bottom"), function()
        if A.ResetPosition then A.ResetPosition(key) end
    end, 280, T("Pour une barre perdue hors de l'écran.", "For a bar lost off-screen."))
    c:Done()
end

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
    kw = "action bars barres action boutons buttons skin habillage icones icons raccourcis keybinds disposition layout taille size totems familier pet posture stance",
    locate = function() return _G.ActionButton1 end,
    build = function(parent)
        wipe(samples)
        return K.Page(parent, function(page)
            local ownBars = TomoMod_ActionBars and TomoMod_ActionBars.IsEnabled and TomoMod_ActionBars.IsEnabled()
            page:Hero(T("Barres d'action", "Action bars"),
                ownBars and T("Les barres d'action TMF : disposition, apparence et visibilité. Déplace-les avec le mode Disposition (/tmf layout).",
                              "TMF action bars: layout, look and visibility. Move them with Layout mode (/tmf layout).")
                    or T("Change l'apparence des barres d'action. Active les barres TMF pour régler aussi leur taille et leur position ici ; sinon elles se règlent dans le Mode Édition du jeu.",
                         "Changes the look of the action bars. Turn on TMF bars to also set their size and position here; otherwise they are set in the game's Edit Mode."),
                function() return _G.ActionButton1 end, T("Barre 1", "Bar 1"))

            LayoutCards(page)

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
            c:Toggle(T("Éclat quand une recharge se termine", "Shine when a cooldown ends"), "barSkin.readyShine", "abs",
                T("Un reflet doré traverse l'icône quand un sort à longue recharge est de nouveau prêt. Suit le réglage des animations.",
                  "A golden gleam crosses the icon when a long-cooldown spell is ready again. Follows the animation setting."))
            c:Done()

            c = page:Card(T("Quand afficher les barres", "When the bars show"))
            c:Info(T("Rien de coché : la barre est toujours visible. Au survol : elle apparaît sous la souris. Combat / cible : en combat ou avec une cible. Les deux : l'un ou l'autre suffit. Les raccourcis marchent toujours, même barre cachée.",
                     "Nothing ticked: the bar is always visible. Mouseover: it shows under the mouse. Combat / target: in combat or with a target. Both: either one is enough. Keybinds always work, even on a hidden bar."))
            local AL = ABL()
            for _, key in ipairs(A.BAR_KEYS or {}) do
              if key ~= "totem" or (AL and AL.GetFrame and AL.GetFrame("totem")) then
                local nm = BAR_NAMES[key] or { key, key }
                c:Label(T(nm[1], nm[2]))
                c:Pair(function(l) l:Toggle(T("Au survol", "Mouseover"), "barSkin.bars." .. key .. ".mouseover", "absfade") end,
                       function(r) r:Toggle(T("Combat / cible", "Combat / target"), "barSkin.bars." .. key .. ".combat", "absfade") end)
              end
            end
            c:Pair(function(l) l:Slider(T("Opacité cachée", "Hidden opacity"), "barSkin.fadeAlpha", 0, 0.8, 0.05, "absfade", "%.2f") end,
                   function(r) r:Slider(T("Durée du fondu", "Fade time"), "barSkin.fadeTime", 0.05, 1, 0.05, "absfade", "%.2f") end)
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
