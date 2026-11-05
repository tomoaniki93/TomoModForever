-- =====================================================================
-- Panels/Home.lua -- "Accueil"
-- Written for someone who just installed the addon: what do you want to
-- do? Every tile goes straight to the page (or the action) that does it.
-- =====================================================================

local K = TomoMod_Kit
local W = TomoMod_Widgets
local TH = W.Theme
local T = K.T

local function Open(key)
    local C = TomoMod_Config
    if C and C.OpenCategory then C.OpenCategory(key) end
end

local TASKS = {
    { fr = "Déplacer mes cadres", en = "Move my frames",
      subFr = "Déverrouille l'interface et glisse les éléments", subEn = "Unlock the UI and drag things around",
      run = function() if TomoMod_Movers and TomoMod_Movers.Toggle then TomoMod_Movers.Toggle() end end },
    { fr = "Agrandir mon cadre joueur", en = "Resize my player frame",
      subFr = "Largeur, vie, barre de mana", subEn = "Width, health, mana bar",
      page = "uf_player" },
    { fr = "Régler mes cadres de groupe", en = "Set up party frames",
      subFr = "Avec un aperçu même en solo", subEn = "With a preview even when solo",
      page = "party" },
    { fr = "Régler les plaques de nom", en = "Set up nameplates",
      subFr = "Taille, couleurs, mode tank", subEn = "Size, colours, tank mode",
      page = "nameplates" },
    { fr = "Suivre mes recharges", en = "Track my cooldowns",
      subFr = "Créer une barre de sorts", subEn = "Create a spell bar",
      page = "spellbars" },
    { fr = "Sauvegarder mon profil", en = "Save my profile",
      subFr = "Copier, exporter, partager", subEn = "Copy, export, share",
      page = "profiles" },
}

local function Tile(parent, task)
    local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
    b:SetHeight(52)
    b:SetBackdrop({ bgFile = K.WHITE, edgeFile = K.WHITE, edgeSize = 1 })
    b:SetBackdropColor(TH.bgMid[1], TH.bgMid[2], TH.bgMid[3], 1)
    b:SetBackdropBorderColor(TH.border[1], TH.border[2], TH.border[3], 1)
    local bar = b:CreateTexture(nil, "ARTWORK")
    bar:SetWidth(3)
    bar:SetPoint("TOPLEFT", 1, -1)
    bar:SetPoint("BOTTOMLEFT", 1, 1)
    bar:SetColorTexture(TH.accent[1], TH.accent[2], TH.accent[3], 0.9)
    local h = b:CreateFontString(nil, "OVERLAY")
    h:SetFont(K.FONT_BOLD, 12, "")
    h:SetPoint("TOPLEFT", 14, -10)
    h:SetPoint("RIGHT", -10, 0)
    h:SetJustifyH("LEFT")
    h:SetTextColor(TH.textHeader[1], TH.textHeader[2], TH.textHeader[3], 1)
    h:SetText(T(task.fr, task.en))
    local s = b:CreateFontString(nil, "OVERLAY")
    s:SetFont(K.FONT, 10, "")
    s:SetPoint("TOPLEFT", h, "BOTTOMLEFT", 0, -3)
    s:SetPoint("RIGHT", -10, 0)
    s:SetJustifyH("LEFT")
    s:SetTextColor(TH.textDim[1], TH.textDim[2], TH.textDim[3], 1)
    s:SetText(T(task.subFr, task.subEn))
    -- Hover shine: a soft light band glides across the tile once.
    b:SetClipsChildren(true)
    local shine = CreateFrame("Frame", nil, b)
    shine:SetSize(60, 52)
    shine:SetPoint("LEFT", b, "LEFT", -60, 0)
    local function Half(point, fromA, toA)
        local t = shine:CreateTexture(nil, "OVERLAY")
        t:SetTexture(K.WHITE)
        t:SetWidth(30)
        t:SetPoint("TOP" .. point); t:SetPoint("BOTTOM" .. point)
        local ok = CreateColor and pcall(t.SetGradient, t, "HORIZONTAL",
            CreateColor(1, 0.9, 0.6, fromA), CreateColor(1, 0.9, 0.6, toA))
        if not ok then t:SetColorTexture(1, 0.9, 0.6, 0.08) end
    end
    Half("LEFT", 0, 0.16)
    Half("RIGHT", 0.16, 0)
    shine:Hide()
    local sweep = shine:CreateAnimationGroup()
    local move = sweep:CreateAnimation("Translation")
    move:SetDuration(0.55)
    move:SetSmoothing("IN_OUT")
    sweep:SetScript("OnFinished", function() shine:Hide() end)

    b:SetScript("OnEnter", function(self)
        self:SetBackdropColor(TH.accent[1] * 0.22, TH.accent[2] * 0.18, TH.accent[3] * 0.12, 1)
        self:SetBackdropBorderColor(TH.accent[1], TH.accent[2], TH.accent[3], 1)
        if K.Animated() then
            move:SetOffset((self:GetWidth() or 200) + 60, 0)
            shine:Show()
            if sweep:IsPlaying() then sweep:Stop() end
            sweep:Play()
        end
    end)
    b:SetScript("OnLeave", function(self)
        self:SetBackdropColor(TH.bgMid[1], TH.bgMid[2], TH.bgMid[3], 1)
        self:SetBackdropBorderColor(TH.border[1], TH.border[2], TH.border[3], 1)
    end)
    b:SetScript("OnClick", function()
        if task.run then task.run() elseif task.page then Open(task.page) end
    end)
    if W._RegisterSearchEntry then W._RegisterSearchEntry(T(task.fr, task.en), b, "option") end
    return b
end

-- Two columns that follow the window width.
local function TileGrid(parent, y, tasks)
    local holder = CreateFrame("Frame", nil, parent)
    holder:SetPoint("TOPLEFT", 16, y)
    holder:SetPoint("TOPRIGHT", -16, y)
    local tiles = {}
    for i, task in ipairs(tasks) do tiles[i] = Tile(holder, task) end
    local rows = math.ceil(#tiles / 2)
    holder:SetHeight(rows * 58)
    local function Layout()
        local w = holder:GetWidth() or 0
        if w < 50 then return end
        local colW = math.floor((w - 8) / 2)
        for i, t in ipairs(tiles) do
            local col, row = (i - 1) % 2, math.floor((i - 1) / 2)
            t:ClearAllPoints()
            t:SetWidth(colW)
            t:SetPoint("TOPLEFT", col * (colW + 8), -row * 58)
        end
    end
    holder:SetScript("OnSizeChanged", Layout)
    Layout()
    return y - rows * 58 - 4
end

-- Main switches, in plain words.
local MODULES = {
    { key = "unitFrames",   fr = "Cadres joueur / cible",   en = "Player / target frames" },
    { key = "castbars",     fr = "Barres d'incantation",    en = "Castbars" },
    { key = "resourceBars", fr = "Ressources au centre",    en = "Centered resources" },
    { key = "partyFrames",  fr = "Cadres de groupe",        en = "Party frames" },
    { key = "raidFrames",   fr = "Cadres de raid",          en = "Raid frames" },
    { key = "nameplates",   fr = "Plaques de nom",          en = "Nameplates" },
    { key = "cooldownForge", fr = "Barres de sorts",        en = "Spell bars" },
    { key = "chatV4",       fr = "Fenêtre de discussion",   en = "Chat window" },
    { key = "bagsV4",       fr = "Sacs",                    en = "Bags" },
    { key = "tooltipSkin",  fr = "Infobulles",              en = "Tooltips" },
    { key = "minimap",      fr = "Minicarte",               en = "Minimap" },
    { key = "objectiveTracker", fr = "Suivi des quêtes",    en = "Quest tracker" },
    { key = "campfire",     fr = "HUD de campement",        en = "Camp HUD" },
    { key = "xpEdge",       fr = "Barre d'XP",              en = "XP bar" },
    { key = "missingBuffs", fr = "Buffs manquants",         en = "Missing buffs" },
}

StaticPopupDialogs["TOMOMOD_GUI_PRESET"] = StaticPopupDialogs["TOMOMOD_GUI_PRESET"] or {
    text = "%s",
    button1 = YES or "Yes",
    button2 = NO or "No",
    OnAccept = function(self, data)
        local P = TomoMod_Presets
        if P and P.Apply and data and P.Apply(data) then ReloadUI() end
    end,
    OnShow = function(self)
        local U = TomoMod_Utils
        if U and U.RaiseAboveTomoUI then U.RaiseAboveTomoUI(self) end
    end,
    OnHide = function(self)
        local U = TomoMod_Utils
        if U and U.RestoreTomoUILayer then U.RestoreTomoUILayer(self) end
    end,
    timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
}

K.RegisterPage({
    key = "home",
    section = "home",
    label = T("Accueil", "Home"),
    kw = "accueil home bienvenue welcome debut start modules presets styles",
    build = function(parent)
        return K.Page(parent, function(page)
            local name = UnitName("player") or ""
            page:Hero(T("Bienvenue, ", "Welcome, ") .. name,
                T("Chaque réglage s'applique tout de suite. La fenêtre devient transparente quand tu tires un curseur ou maintiens Alt : tu vois ton interface derrière.",
                  "Every setting applies instantly. The window turns see-through while you drag a slider or hold Alt, so you can see your UI behind it."))

            local c = page:Card(T("Que veux-tu faire ?", "What do you want to do?"))
            c:Custom(function(p, y) return TileGrid(p, y, TASKS) end)
            c:Done()

            c = page:Card(T("Modules", "Modules"))
            c:Info(T("Allume ou éteins une partie de TomoMod. Certains demandent un /rl.",
                     "Turn parts of TomoMod on or off. Some need a /rl."))
            for i = 1, #MODULES, 2 do
                local a, b = MODULES[i], MODULES[i + 1]
                local function Mod(col, m)
                    if not m then return end
                    col:Toggle(T(m.fr, m.en), {
                        get = function() return K.IsModuleOn(m.key) end,
                        set = function(v) K.SetModule(m.key, v) end,
                    }, nil)
                end
                c:Pair(function(l) Mod(l, a) end, function(r) Mod(r, b) end)
            end
            c:Done()

            local P = TomoMod_Presets
            if P and P.GetList then
                c = page:Card(T("Styles tout prêts", "Ready-made styles"))
                c:Info(T("Applique une configuration complète adaptée à ton rôle. Ton profil actuel est sauvegardé avant.",
                         "Applies a complete setup for your role. Your current profile is backed up first."))
                local active = P.GetActive and P.GetActive()
                for _, def in ipairs(P.GetList()) do
                    if P.IsApplicable(def.key) then
                        local label = (def.name or def.key) .. (active == def.key and T("  (actif)", "  (active)") or "")
                        local btn = c:Button(label, function()
                            local msg = string.format(T("Appliquer le style « %s » ?\nL'interface va se recharger.",
                                                        "Apply the \"%s\" style?\nThe UI will reload."), def.name or def.key)
                            StaticPopup_Show("TOMOMOD_GUI_PRESET", msg, nil, def.key)
                        end, 260)
                        if def.tagline and btn then W.SetTooltip(btn, def.desc or def.tagline, def.name) end
                    end
                end
                c:Done()
            end

            c = page:Card(T("Besoin d'aide ?", "Need help?"))
            c:Pair(function(l)
                l:Button(T("Relancer l'assistant", "Run the setup wizard"), function()
                    if TomoMod_OpenInstaller then TomoMod_OpenInstaller(true) end
                end, 200)
            end, function(r)
                r:Button(T("Recharger l'interface", "Reload the UI"), function() ReloadUI() end, 200)
            end)
            c:Toggle(T("Animations de la fenêtre (transitions, survols)", "Window animations (transitions, hovers)"), {
                get = function() return K.Animated() end,
                set = function(v) K.GuiDB().animations = v and true or false end,
            }, nil)
            c:Info(T("Commandes : /tm (cette fenêtre), /tm layout (déplacer), /rl (recharger).",
                     "Commands: /tm (this window), /tm layout (move), /rl (reload)."))
            c:Done()
        end)
    end,
})
