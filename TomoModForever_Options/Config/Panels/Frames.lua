-- =====================================================================
-- Panels/Frames.lua -- "Mes cadres" : unit frames, castbars, resources
-- Replaces the Astral Forge and Resource & Cast Studios. Every control is
-- applied to the live frames as it moves; the page header pulses the real
-- frame so the player always knows what the page is talking about.
-- =====================================================================

local K = TomoMod_Kit
local T = K.T

local SECTION = "frames"

-- ---------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------
local function UF(unit) return "unitFrames." .. unit .. "." end

-- Auras "both" and the enemy-buff strip would draw the same buffs twice;
-- the old studio enforced this, the page keeps doing it.
local function EnforceAuraExclusivity(unit)
    local s = TomoModForeverDB.unitFrames[unit]
    if type(s) ~= "table" or type(s.auras) ~= "table" or type(s.enemyBuffs) ~= "table" then return end
    if s.auras.enabled ~= false and s.auras.type == "ALL" then
        s.enemyBuffs.enabled = false
    end
end

-- Element anchor presets: plain words instead of anchor points.
local NAME_POS = {
    left  = { point = "LEFT",       relTo = "health", relPoint = "LEFT",    x = 6,  y = 0 },
    center= { point = "CENTER",     relTo = "health", relPoint = "CENTER",  x = 0,  y = 0 },
    above = { point = "BOTTOMLEFT", relTo = "health", relPoint = "TOPLEFT", x = 2,  y = 3 },
}
local HP_POS = {
    right  = { point = "RIGHT",  relTo = "health", relPoint = "RIGHT",  x = -6, y = 0 },
    center = { point = "CENTER", relTo = "health", relPoint = "CENTER", x = 0,  y = 0 },
    left   = { point = "LEFT",   relTo = "health", relPoint = "LEFT",   x = 6,  y = 0 },
}

local function ElementBinding(unit, id, presets)
    return {
        get = function()
            local s = TomoModForeverDB.unitFrames[unit]
            local e = s and s.elements and s.elements[id]
            if type(e) ~= "table" then return nil end
            for key, p in pairs(presets) do
                if e.point == p.point and e.relPoint == p.relPoint and (e.relTo or "health") == p.relTo then
                    return key
                end
            end
            return nil
        end,
        set = function(key)
            local p = presets[key]
            local s = TomoModForeverDB.unitFrames[unit]
            if not (p and s) then return end
            s.elements = s.elements or {}
            local e = s.elements[id]
            if type(e) ~= "table" then e = {}; s.elements[id] = e end
            e.point, e.relTo, e.relPoint, e.x, e.y = p.point, p.relTo, p.relPoint, p.x, p.y
        end,
    }
end

local function ReloadToggle(c, label, path, tip)
    return c:Toggle(label, path, K.NeedReload, tip)
end

-- ---------------------------------------------------------------------
-- One page per unit frame
-- ---------------------------------------------------------------------
local UNITS = {
    { key = "player",       fr = "Joueur",           en = "Player",
      descFr = "Ton propre cadre : vie, ressource (mana, énergie, rage) et barre d'infos.",
      descEn = "Your own frame: health, resource (mana, energy, rage) and info bar." },
    { key = "target",       fr = "Cible",            en = "Target",
      descFr = "Le cadre de ce que tu cibles. Cible quelqu'un pour le voir changer en direct.",
      descEn = "The frame of what you target. Target something to see it change live." },
    { key = "targettarget", fr = "Cible de la cible", en = "Target of target",
      descFr = "Petit cadre qui montre qui ta cible regarde.",
      descEn = "Small frame showing who your target is looking at." },
    { key = "focus",        fr = "Focalisation",     en = "Focus",
      descFr = "Cadre de ta cible de focalisation (/focus).",
      descEn = "Frame of your focus target (/focus)." },
    { key = "pet",          fr = "Familier",         en = "Pet",
      descFr = "Le cadre de ton familier ou de ta créature invoquée.",
      descEn = "Your pet or summoned creature frame." },
}

local function BuildUnitPage(page, u)
    local unit = u.key
    local p = UF(unit)
    local ap = "uf:" .. unit
    local s = TomoModForeverDB.unitFrames[unit]
    local title = T(u.fr, u.en)

    page:Hero(title, T(u.descFr, u.descEn), "TomoMod_UF_" .. unit, title)

    if not TomoModForeverDB.unitFrames.enabled then
        local c = page:Card(T("Module désactivé", "Module disabled"))
        c:Info(T("Les cadres d'unité TomoMod sont désactivés. Active-les depuis l'Accueil.",
                 "TomoMod unit frames are turned off. Turn them on from Home."))
        c:Done()
    end

    -- ---- Size ---------------------------------------------------------
    local c = page:Card(T("Taille", "Size"))
    local FOREVER_UNITS = { player = true, target = true, focus = true, targettarget = true, pet = true, focustarget = true }
    if TomoModForeverDB.unitFrames.style == "forever" and FOREVER_UNITS[unit] then
        c:Info(T("Style Forever actif : ces tailles sont celles du style TMF. Les tailles Forever se règlent dans Cadres > Style commun > Tailles Forever.",
                 "Forever look on: these sizes are the TMF look's. The Forever sizes are set in Frames > Shared style > Forever sizes."))
    end
    c:Slider(T("Largeur", "Width"), p .. "width", 60, 500, 1, ap)
    c:Slider(T("Hauteur de la barre de vie", "Health bar height"), p .. "healthHeight", 8, 80, 1, ap)
    if unit == "player" then
        c:Slider(T("Hauteur de la barre de mana / énergie", "Mana / energy bar height"), p .. "powerHeight", 0, 30, 1, ap, nil,
            T("0 = pas de barre. Si ta ressource est affichée au centre de l'écran, cette barre n'apparaît pas (voir plus bas).",
              "0 = no bar. If your resource is shown in the middle of the screen, this bar is not drawn (see below)."))
    else
        c:Slider(T("Hauteur de la barre de ressource", "Resource bar height"), p .. "powerHeight", 0, 30, 1, ap, nil,
            T("0 = pas de barre de ressource.", "0 = no resource bar."))
    end
    if s.infoBarHeight ~= nil then
        c:Slider(T("Hauteur de la barre d'infos", "Info bar height"), p .. "infoBarHeight", 0, 30, 1, ap, nil,
            T("Bande sous le cadre avec la vie et la ressource en texte. 0 = masquée.",
              "Strip under the frame with health and resource as text. 0 = hidden."))
    end
    c:Done()

    -- ---- Player: where is my mana? ---------------------------------------
    if unit == "player" then
        local c2 = page:Card(T("Où afficher ma ressource ?", "Where should my resource go?"))
        if K.IsModuleOn("resourceBars") then
            c2:Seg(nil, {
                get = function()
                    return TomoModForeverDB.resourceBars.primaryPowerCentered and "center" or "frame"
                end,
                set = function(v) TomoModForeverDB.resourceBars.primaryPowerCentered = (v == "center") end,
            }, {
                { text = T("Dans le cadre joueur", "In the player frame"), value = "frame" },
                { text = T("Au centre de l'écran", "Middle of the screen"), value = "center" },
            }, "res", 2)
            c2:Info(T("« Dans le cadre » utilise la hauteur réglée ci-dessus. « Au centre » se règle dans Ressources.",
                      "\"In the frame\" uses the height set above. \"Middle\" is set up in Resources."))
        else
            c2:Info(T("Les barres de ressources centrées sont désactivées : ta ressource est dans le cadre joueur.",
                      "Centered resource bars are off: your resource is in the player frame."))
        end
        c2:Done()
    end

    -- ---- Texts ------------------------------------------------------------
    c = page:Card(T("Textes", "Texts"))
    c:Pair(function(l) l:Toggle(T("Nom", "Name"), p .. "showName", ap) end,
           function(r) r:Toggle(T("Niveau", "Level"), p .. "showLevel", ap) end)
    c:Pair(function(l) l:Toggle(T("Vie en texte", "Health text"), p .. "showHealthText", ap) end,
           function(r) if s.showPowerText ~= nil then r:Toggle(T("Ressource en texte", "Resource text"), p .. "showPowerText", ap, T("Écrit sur la barre de ressource quand la barre d'infos est à 0.", "Written on the resource bar when the info bar is set to 0.")) end end)
    c:Select(T("Format de la vie", "Health format"), p .. "healthTextFormat", K.HP_FORMATS, ap)
    if s.nameTruncate ~= nil then
        c:Toggle(T("Raccourcir les noms longs", "Shorten long names"), p .. "nameTruncate", ap)
        c:Slider(T("Longueur maximale du nom", "Max name length"), p .. "nameTruncateLength", 4, 30, 1, ap)
    end
    c:Done()

    -- ---- Colours ----------------------------------------------------------
    c = page:Card(T("Couleurs", "Colours"))
    c:Toggle(T("Couleur de classe pour les joueurs", "Class colour for players"), p .. "useClassColor", ap)
    c:Toggle(T("Couleur de réaction (hostile, neutre, amical)", "Reaction colour (hostile, neutral, friendly)"), p .. "useFactionColor", ap)
    if s.useNameplateColors ~= nil then
        c:Toggle(T("Mêmes couleurs que les plaques de nom", "Same colours as nameplates"), p .. "useNameplateColors", ap,
            T("Lanceurs de sorts en bleu, élites en violet, etc.", "Casters blue, elites purple, etc."))
    end
    c:Done()

    if unit == "player" then
        c = page:Card(T("Alerte vie basse", "Low health alert"))
        c:Toggle(T("Le cadre pulse en rouge quand ta vie est basse", "The frame pulses red when your health is low"), "unitFrames.lowHealthPulse", ap)
        c:Slider(T("Seuil", "Threshold"), "unitFrames.lowHealthPct", 10, 60, 1, ap, "%d %%")
        c:Done()
    end

    -- ---- Indicators -------------------------------------------------------
    c = page:Card(T("Indicateurs", "Indicators"))
    c:Pair(function(l) l:Toggle(T("Boucliers (absorption)", "Shields (absorb)"), p .. "showAbsorb", ap) end,
           function(r) r:Toggle(T("Menace", "Threat"), p .. "showThreat", ap) end)
    if s.showLeaderIcon ~= nil or s.showRaidIcon ~= nil then
        c:Pair(function(l) if s.showLeaderIcon ~= nil then l:Toggle(T("Icône de chef", "Leader icon"), p .. "showLeaderIcon", ap) end end,
               function(r) if s.showRaidIcon ~= nil then r:Toggle(T("Marque de raid", "Raid marker"), p .. "showRaidIcon", ap) end end)
    end
    if s.showHappiness ~= nil then
        c:Toggle(T("Humeur du familier (chasseur)", "Pet happiness (hunter)"), p .. "showHappiness", ap,
            T("Heureux, content ou malheureux. Survole l'icône pour voir son régime.", "Happy, content or unhappy. Hover the icon to see its diet."))
    end
    if s.showQuestIcon ~= nil then
        c:Toggle(T("Icône de quête", "Quest icon"), p .. "showQuestIcon", ap)
    end
    if type(s.threatText) == "table" then
        c:Toggle(T("Pourcentage de menace en texte", "Threat percentage text"), p .. "threatText.enabled", ap)
    end
    c:Done()

    -- ---- Totems (shamans only) -----------------------------------------
    local _, playerClass = UnitClass("player")
    if unit == "player" and playerClass == "SHAMAN" then
        local function TBApply() if TomoMod_TotemBar and TomoMod_TotemBar.ApplySettings then TomoMod_TotemBar.ApplySettings() end end
        c = page:Card(T("Totems", "Totems"))
        c:Info(T("Tes totems sous le cadre joueur : une place par élément, minuteur, infobulle. Clic droit sur un totem pour le retirer. Déplaçable avec /tmf move.",
                 "Your totems under the player frame: one spot per element, timer, tooltip. Right click a totem to dismiss it. Movable with /tmf move."))
        c:Toggle(T("Afficher les totems", "Show the totems"), "unitFrames.totems.enabled", TBApply)
        c:Slider(T("Taille des icônes", "Icon size"), "unitFrames.totems.size", 18, 48, 1, TBApply)
        c:Slider(T("Espacement", "Spacing"), "unitFrames.totems.spacing", 0, 16, 1, TBApply)
        c:Toggle(T("Montrer les places vides", "Show empty spots"), "unitFrames.totems.showEmpty", TBApply,
            T("Une case discrète à la couleur de l'élément quand aucun totem n'est posé.", "A faint box in the element colour when no totem is down."))
        c:Button(T("Remettre sous le cadre joueur", "Back under the player frame"), function()
            if TomoMod_TotemBar and TomoMod_TotemBar.ResetPosition then TomoMod_TotemBar.ResetPosition() end
        end)
        c:Done()
    end

    -- ---- Auras --------------------------------------------------------------
    if type(s.auras) == "table" then
        c = page:Card(T("Buffs et débuffs", "Buffs and debuffs"))
        c:Toggle(T("Afficher les auras", "Show auras"), p .. "auras.enabled", ap, nil, function() EnforceAuraExclusivity(unit) end)
        c:Seg(T("Lesquelles ?", "Which ones?"), {
            get = function() return s.auras.type end,
            set = function(v) s.auras.type = v; EnforceAuraExclusivity(unit) end,
        }, {
            { text = T("Débuffs", "Debuffs"), value = "HARMFUL" },
            { text = T("Buffs", "Buffs"),     value = "HELPFUL" },
            { text = T("Les deux", "Both"),   value = "ALL" },
        }, ap, 3)
        c:Pair(function(l) l:Slider(T("Nombre", "Count"), p .. "auras.maxAuras", 1, 12, 1, ap) end,
               function(r) r:Slider(T("Taille", "Size"), p .. "auras.size", 12, 50, 1, ap) end)
        c:Pair(function(l) l:Slider(T("Par ligne", "Per row"), p .. "auras.perRow", 1, 12, 1, ap) end,
               function(r) r:Slider(T("Espacement", "Spacing"), p .. "auras.spacing", 0, 10, 1, ap) end)
        c:Pair(function(l) l:Toggle(T("Seulement les miennes", "Only mine"), p .. "auras.showOnlyMine", ap) end,
               function(r) r:Toggle(T("Durée restante", "Time left"), p .. "auras.showDuration", ap) end)
        c:Seg(T("Sens de remplissage", "Growth direction"), p .. "auras.growDirection", {
            { text = T("Vers la gauche", "Leftwards"),  value = "LEFT" },
            { text = T("Vers la droite", "Rightwards"), value = "RIGHT" },
        }, ap, 2)
        c:Done()
    end

    if type(s.enemyBuffs) == "table" then
        c = page:Card(T("Buffs des ennemis", "Enemy buffs"), { adv = true })
        c:Info(T("Montre les buffs à dissiper ou voler sur un ennemi. Désactivé si les auras affichent déjà « Les deux ».",
                 "Shows buffs you can dispel or steal on an enemy. Off when auras already show \"Both\"."))
        c:Toggle(T("Activer", "Enable"), p .. "enemyBuffs.enabled", ap, nil, function() EnforceAuraExclusivity(unit) end)
        c:Pair(function(l) l:Slider(T("Nombre", "Count"), p .. "enemyBuffs.maxAuras", 1, 8, 1, ap) end,
               function(r) r:Slider(T("Taille", "Size"), p .. "enemyBuffs.size", 12, 40, 1, ap) end)
        c:Done()
    end

    -- ---- Blizzard's own buff / debuff frames (top-right of the screen) -------
    if unit == "player" then
        c = page:Card(T("Cadres d'auras Blizzard", "Blizzard aura frames"))
        c:Info(T("Les buffs et débuffs Blizzard en haut à droite de l'écran. N'affecte pas les auras des cadres TomoMod.",
                 "Blizzard's buffs and debuffs at the top right of the screen. Does not affect TomoMod frame auras."))
        c:Toggle(T("Laisser TomoMod gérer ces cadres", "Let TomoMod manage these frames"), "blizzardAuraFrames.enabled", "baf")
        c:Pair(function(l) l:Toggle(T("Buffs Blizzard", "Blizzard buffs"), "blizzardAuraFrames.showBuffs", "baf") end,
               function(r) r:Toggle(T("Débuffs Blizzard", "Blizzard debuffs"), "blizzardAuraFrames.showDebuffs", "baf") end)
        c:Done()
    end

    -- ---- Text placement (expert) -------------------------------------------
    c = page:Card(T("Position des textes", "Text placement"), { adv = true })
    c:Seg(T("Nom", "Name"), ElementBinding(unit, "name", NAME_POS), {
        { text = T("À gauche", "Left"),     value = "left" },
        { text = T("Au centre", "Center"),  value = "center" },
        { text = T("Au-dessus", "Above"),   value = "above" },
    }, ap, 3)
    c:Seg(T("Vie", "Health"), ElementBinding(unit, "healthText", HP_POS), {
        { text = T("À gauche", "Left"),     value = "left" },
        { text = T("Au centre", "Center"),  value = "center" },
        { text = T("À droite", "Right"),    value = "right" },
    }, ap, 3)
    c:Done()

    -- ---- On / off -----------------------------------------------------------
    c = page:Card(T("Cadre", "Frame"), { adv = true })
    ReloadToggle(c, T("Afficher ce cadre", "Show this frame"), p .. "enabled",
        T("Les cadres sont créés au chargement : demande un /rl.", "Frames are created at load: needs a /rl."))
    c:Info(T("Pour le déplacer : bouton « Déplacer » en haut de la fenêtre.",
             "To move it: \"Move\" button at the top of the window."))
    c:Done()
end

for i, u in ipairs(UNITS) do
    K.RegisterPage({
        key = "uf_" .. u.key,
        section = SECTION,
        label = T(u.fr, u.en),
        kw = "unit frame cadre unite " .. u.key .. " " .. u.fr .. " " .. u.en
            .. (u.key == "player" and " mana energie energy rage ressource power moi" or ""),
        locate = "TomoMod_UF_" .. u.key,
        build = function(parent)
            return K.Page(parent, function(page) BuildUnitPage(page, u) end)
        end,
    })
end

-- ---------------------------------------------------------------------
-- Boss frames
-- ---------------------------------------------------------------------
K.RegisterPage({
    key = "uf_boss",
    section = SECTION,
    label = T("Boss", "Boss"),
    kw = "boss frames cadres boss rencontre encounter",
    locate = "TomoMod_Boss_1",
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Cadres de boss", "Boss frames"),
                T("Apparaissent pendant les rencontres de boss. Utilise « Déplacer » pour les voir hors combat.",
                  "Shown during boss encounters. Use \"Move\" to see them outside a fight."),
                "TomoMod_Boss_1", T("Boss", "Boss"))
            local c = page:Card(T("Taille", "Size"))
            c:Slider(T("Largeur", "Width"), "unitFrames.bossFrames.width", 80, 400, 1, "boss")
            c:Slider(T("Hauteur", "Height"), "unitFrames.bossFrames.height", 12, 60, 1, "boss")
            c:Slider(T("Espace entre les cadres", "Space between frames"), "unitFrames.bossFrames.spacing", 0, 30, 1, "boss")
            c:Done()
            c = page:Card(T("Cadre", "Frame"), { adv = true })
            ReloadToggle(c, T("Utiliser les cadres de boss TomoMod", "Use TomoMod boss frames"), "unitFrames.bossFrames.enabled")
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- Shared look of every unit frame
-- ---------------------------------------------------------------------
-- Animation look (AnimHUD): settings live in unitFrames.animation.
local function AnimRefresh()
    local AH = TomoMod_AnimHUD
    if AH and AH.Refresh then AH.Refresh() end
end

local function A(key) return "unitFrames.animation." .. key end

--- The main Animation-look settings, shared by the Shared style page and
--- the Animation HUD page.
local function AnimLookControls(c)
    local AH = TomoMod_AnimHUD
    local uf = TomoModForeverDB.unitFrames
    local themes = {}
    for _, th in ipairs((AH and AH.themes) or {}) do
        themes[#themes + 1] = { text = T(th.fr, th.en), value = th.key }
    end
    c:Seg(T("Thème", "Theme"), A("theme"), themes, AnimRefresh, 4,
        T("Classe : chaque classe a ses couleurs, au repos et en combat.", "Class: each class has its own colours, idle and in combat."))
    c:Slider(T("Taille du HUD", "HUD size"), A("scale"), 0.6, 1.6, 0.05, AnimRefresh, "%.2f",
        T("Tout le halo : arcs, anneaux, incantations, menace, combo, auras et textes.", "The whole halo: arcs, rings, casts, threat, combo, auras and texts."))
    c:Slider(T("Taille des textes", "Text size"), A("textScale"), 0.6, 1.8, 0.05, AnimRefresh, "%.2f",
        T("Noms, valeurs, chrono et noms des sorts, par rapport à la taille du HUD.", "Names, values, timer and spell names, relative to the HUD size."))
    c:Slider(T("Taille des auras", "Aura size"), A("auraScale"), 0.5, 2.0, 0.05, AnimRefresh, "%.2f",
        T("Icônes des buffs et débuffs, par rapport à la taille du HUD.", "Buff and debuff icons, relative to the HUD size."))
    c:Slider(T("Opacité hors combat", "Opacity out of combat"), {
        get = function() return math.floor((tonumber(uf.animation and uf.animation.oocAlpha) or 0.35) * 100 + 0.5) end,
        set = function(v)
            uf.animation = type(uf.animation) == "table" and uf.animation or {}
            uf.animation.oocAlpha = v / 100
        end,
        default = 35,
    }, 0, 100, 5, AnimRefresh, "%d %%",
        T("Le halo se réveille tout seul quand tu cibles quelque chose ou qu'il te manque de la vie.",
          "The halo wakes up on its own when you target something or are missing health."))
    c:Slider(T("Quantité de braises", "Ember amount"), A("emberAmount"), 0.2, 1.3, 0.1, AnimRefresh, "%.1f")
    c:Toggle(T("Valeurs de vie et de ressource", "Health and power values"), A("texts"), AnimRefresh)
end

K.RegisterPage({
    key = "uf_style",
    section = SECTION,
    label = T("Style commun", "Shared style"),
    kw = "texture police font taille contour style unit frames cadres apparence",
    locate = "TomoMod_UF_player",
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Style commun des cadres", "Shared frame style"),
                T("Texture et police utilisées par tous les cadres d'unité.", "Texture and font used by every unit frame."),
                "TomoMod_UF_player", T("Joueur", "Player"))
            local c = page:Card(T("Apparence", "Look"))
            -- Choosing the look rebuilds the page: the Forever sizes card only
            -- shows with the Forever look.
            c:Seg(T("Style des cadres", "Frame style"), {
                get = function() return TomoModForeverDB.unitFrames.style or "tmf" end,
                set = function(v)
                    local changed = TomoModForeverDB.unitFrames.style ~= v
                    TomoModForeverDB.unitFrames.style = v
                    if changed then
                        -- Animation look: the halo takes over (or gives back)
                        -- the frames and cast bars; deferred to the end of
                        -- combat by AnimHUD itself.
                        local AH = TomoMod_AnimHUD
                        if AH and AH.Sync then AH.Sync() end
                        K.RefreshPage()
                    end
                end,
                default = "tmf",
            }, {
                { text = "TMF", value = "tmf" },
                { text = "Forever", value = "forever" },
                { text = "Animation", value = "animation" },
            }, "ufall", 3)
            c:Info(T("TMF : le style par défaut. Forever : bandeau de nom aux couleurs de la classe (ou de la réaction pour les PNJ), vie et ressource centrées, cadre bronze et or, médaillon de niveau. S'applique au joueur, à la cible, à la cible de la cible, au familier et au focus.",
                     "TMF: the default look. Forever: name strip in the class colour (reaction colour for NPCs), centred health and power, bronze and gold border, level medallion. Applies to the player, target, target of target, pet and focus."))
            c:Info(T("Animation : un halo animé autour du personnage remplace les cadres du joueur, de la cible, de la cible de la cible et du familier, ainsi que leurs barres d'incantation TMF. Le focus et les boss gardent le style TMF. Quand ce style est choisi, la page Cadres > HUD Animation apparaît dans le menu.",
                     "Animation: an animated halo around your character replaces the player, target, target of target and pet frames, and their TMF cast bars. Focus and boss frames keep the TMF look. When this look is chosen, the Frames > Animation HUD page shows in the menu."))
            -- [1.3.6] Two skins for the Forever look: the game's own art, or
            -- the classic flat strip.
            if TomoModForeverDB.unitFrames.style == "forever" then
                c:Seg(T("Habillage Forever", "Forever skin"), {
                    get = function() return TomoModForeverDB.unitFrames.foreverArt ~= false and "art" or "classic" end,
                    set = function(v)
                        local on = v == "art"
                        local changed = (TomoModForeverDB.unitFrames.foreverArt ~= false) ~= on
                        TomoModForeverDB.unitFrames.foreverArt = on
                        if changed then K.RefreshPage() end
                    end,
                    default = "art",
                }, {
                    { text = T("Officiel (art du jeu)", "Official (game art)"), value = "art" },
                    { text = T("Classique", "Classic"), value = "classic" },
                }, "ufall", 2)
                c:Info(T("Officiel : la plaque bronze, l'anneau de portrait et le médaillon de niveau de WoW Forever, avec le dragon des élites et des rares, la marque de quête, le crâne des cibles trop fortes, et sur ton cadre les épées de combat et une lueur rouge (combat), dorée (repos) ou de menace. Classique : le bandeau plat de TMF.",
                         "Official: WoW Forever's bronze plate, portrait ring and level disc, with the elite and rare dragon, the quest mark, the skull for targets far above you, and on your frame the combat swords and a red (combat), gold (resting) or threat glow. Classic: TMF's flat strip."))
                if TomoModForeverDB.unitFrames.foreverArt == false then
                    c:Toggle(T("Forever : afficher le portrait", "Forever: show the portrait"), "unitFrames.foreverPortrait", "ufall",
                        T("Portrait rond à côté du joueur, de la cible et du focus, avec le niveau posé dessus.",
                          "Round portrait beside the player, target and focus, with the level on it."))
                end
            end

            c:Select(T("Texture des barres", "Bar texture"), "unitFrames.texture", K.TEXTURES, "ufall")
            c:Select(T("Police", "Font"), {
                get = function() return TomoModForeverDB.unitFrames.fontFamily or TomoModForeverDB.unitFrames.font end,
                set = function(v) TomoModForeverDB.unitFrames.fontFamily = v; TomoModForeverDB.unitFrames.font = v end,
            }, K.FONTS, "ufall")
            c:Slider(T("Taille du texte", "Text size"), "unitFrames.fontSize", 8, 22, 1, "ufall")
            c:Seg(T("Contour du texte", "Text outline"), "unitFrames.fontOutline", K.OUTLINES, "ufall", 3)
            c:Done()

            -- Forever sizes: the Forever look has its own sizes (the sliders
            -- of the Player / Target... pages are those of the TMF look).
            -- [1.3.6] Official skin: width and scale per frame (the art keeps
            -- its proportions, only its middle stretches).
            if TomoModForeverDB.unitFrames.style == "forever" and TomoModForeverDB.unitFrames.foreverArt ~= false then
                c = page:Card(T("Tailles Forever", "Forever sizes"))
                c:Info(T("L'art garde ses proportions : la largeur étire le milieu de la plaque, l'échelle agrandit tout le cadre, anneau compris. Choisis le cadre à régler.",
                         "The art keeps its proportions: width stretches the middle of the plate, scale grows the whole frame, ring included. Pick the frame to size."))
                local gui = K.GuiDB()
                local ART_UNITS = {
                    { text = T("Joueur", "Player"), value = "player" },
                    { text = T("Cible", "Target"), value = "target" },
                    { text = T("Focus", "Focus"), value = "focus" },
                    { text = T("Cible cible", "Target target"), value = "targettarget" },
                    { text = T("Familier", "Pet"), value = "pet" },
                }
                c:Seg(T("Cadre", "Frame"), {
                    get = function() return gui.foreverSizeUnit or "player" end,
                    set = function(v)
                        local changed = gui.foreverSizeUnit ~= v
                        gui.foreverSizeUnit = v
                        if changed then K.RefreshPage() end
                    end,
                    default = "player",
                }, ART_UNITS, nil, 5)
                local unit = gui.foreverSizeUnit or "player"
                local UFm = TomoMod_UnitFrames
                local def = (UFm and UFm.FOREVER_ART_DEFAULTS and UFm.FOREVER_ART_DEFAULTS[unit]) or { width = 170, scale = 1 }
                local function ArtSize(key, toUI, fromUI)
                    return {
                        get = function()
                            local t = TomoModForeverDB.unitFrames.foreverArtSizes
                            local u = type(t) == "table" and t[unit]
                            return toUI((u and u[key]) or def[key])
                        end,
                        set = function(v)
                            local uf = TomoModForeverDB.unitFrames
                            uf.foreverArtSizes = type(uf.foreverArtSizes) == "table" and uf.foreverArtSizes or {}
                            uf.foreverArtSizes[unit] = uf.foreverArtSizes[unit] or {}
                            uf.foreverArtSizes[unit][key] = fromUI(v)
                        end,
                        default = toUI(def[key]),
                    }
                end
                local same = function(v) return v end
                c:Slider(T("Largeur", "Width"), ArtSize("width", same, same), 60, 400, 1, "ufall")
                c:Slider(T("Échelle", "Scale"), ArtSize("scale",
                    function(v) return math.floor(v * 100 + 0.5) end,
                    function(v) return v / 100 end), 40, 250, 5, "ufall", "%d %%",
                    T("100 % : la taille de l'art de Blizzard. Joueur et cible : 130 % par défaut.",
                      "100 %: Blizzard's art size. Player and target: 130 % by default."))
                c:Button(T("Tailles par défaut pour ce cadre", "Default sizes for this frame"), function()
                    local t = TomoModForeverDB.unitFrames.foreverArtSizes
                    if type(t) == "table" then t[unit] = nil end
                    K.Apply("ufall")
                    K.RefreshPage()
                end)
                c:Done()
            end
            if TomoModForeverDB.unitFrames.style == "forever" and TomoModForeverDB.unitFrames.foreverArt == false then
                c = page:Card(T("Tailles Forever", "Forever sizes"))
                c:Info(T("Le style Forever a ses propres tailles : les curseurs des pages Joueur, Cible... règlent le style TMF. Choisis le cadre à régler.",
                         "The Forever look has its own sizes: the sliders of the Player, Target... pages set the TMF look. Pick the frame to size."))
                local gui = K.GuiDB()
                local UNITS = {
                    { text = T("Joueur", "Player"), value = "player" },
                    { text = T("Cible", "Target"), value = "target" },
                    { text = T("Focus", "Focus"), value = "focus" },
                    { text = T("Cible cible", "Target target"), value = "targettarget" },
                    { text = T("Familier", "Pet"), value = "pet" },
                }
                c:Seg(T("Cadre", "Frame"), {
                    get = function() return gui.foreverSizeUnit or "player" end,
                    set = function(v)
                        local changed = gui.foreverSizeUnit ~= v
                        gui.foreverSizeUnit = v
                        if changed then K.RefreshPage() end
                    end,
                    default = "player",
                }, UNITS, nil, 5)
                local unit = gui.foreverSizeUnit or "player"
                local UFm = TomoMod_UnitFrames
                local def = (UFm and UFm.FOREVER_DEFAULT_SIZES and UFm.FOREVER_DEFAULT_SIZES[unit]) or {}
                local function Size(key, fallback)
                    return {
                        get = function()
                            local t = TomoModForeverDB.unitFrames.foreverSizes
                            local u = type(t) == "table" and t[unit]
                            return (u and u[key]) or def[key] or fallback
                        end,
                        set = function(v)
                            local uf = TomoModForeverDB.unitFrames
                            uf.foreverSizes = type(uf.foreverSizes) == "table" and uf.foreverSizes or {}
                            uf.foreverSizes[unit] = uf.foreverSizes[unit] or {}
                            uf.foreverSizes[unit][key] = v
                        end,
                        default = def[key] or fallback,
                    }
                end
                c:Slider(T("Largeur", "Width"), Size("width", 170), 80, 400, 1, "ufall")
                c:Slider(T("Hauteur du bandeau de nom", "Name strip height"), Size("name", 14), 8, 30, 1, "ufall")
                c:Slider(T("Hauteur de la vie", "Health height"), Size("health", 16), 6, 60, 1, "ufall")
                c:Slider(T("Hauteur de la ressource", "Power height"), Size("power", 9), 0, 30, 1, "ufall",
                    nil, T("0 : pas de barre de ressource dans ce style.", "0: no power bar in this look."))
                c:Button(T("Tailles par défaut pour ce cadre", "Default sizes for this frame"), function()
                    local t = TomoModForeverDB.unitFrames.foreverSizes
                    if type(t) == "table" then t[unit] = nil end
                    K.Apply("ufall")
                    K.RefreshPage()
                end)
                c:Done()
            end
            -- Animation look: its main settings right here, like the Forever
            -- sizes; everything else on the Animation HUD page.
            if TomoModForeverDB.unitFrames.style == "animation" then
                c = page:Card(T("Style Animation", "Animation look"))
                AnimLookControls(c)
                c:Button(T("Déplacer les éléments", "Move the elements"), function()
                    local AH = TomoMod_AnimHUD
                    if AH and AH.ToggleMover then AH.ToggleMover() end
                end, 240)
                c:Button(T("Tous les réglages du HUD", "All HUD settings"), function()
                    local C = TomoMod_Config
                    if C and C.SwitchCategory then C.SwitchCategory("uf_anim") end
                end, 240, T("Arcs, signes, auras, animation centrale.", "Arcs, signs, auras, centre animation."))
                c:Done()
            end

            c = page:Card(T("Animations", "Animations"))
            c:Toggle(T("Traînée rouge quand un cadre perd de la vie", "Red trail when a frame loses health"), "unitFrames.healthTrail", "ufall",
                T("Le morceau de vie perdu reste affiché en rouge un instant puis s'écoule.", "The lost chunk of health stays red for a moment, then drains away."))
            c:Toggle(T("Cadre joueur qui pulse en rouge quand ta vie est basse", "Player frame pulses red on low health"), "unitFrames.lowHealthPulse", "uf:player")
            c:Slider(T("Seuil de vie basse", "Low health threshold"), "unitFrames.lowHealthPct", 10, 60, 1, "uf:player", "%d %%")
            c:Done()

            c = page:Card(T("Cadres Blizzard", "Blizzard frames"), { adv = true })
            ReloadToggle(c, T("Masquer les cadres Blizzard d'origine", "Hide the default Blizzard frames"), "unitFrames.hideBlizzardFrames")
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- Animation look (Modules/Interface/AnimHUD, from Braise): helpers above
-- the Shared style page, which also shows the main settings.
-- ---------------------------------------------------------------------

K.RegisterPage({
    key = "uf_anim",
    section = SECTION,
    label = T("HUD Animation", "Animation HUD"),
    -- [1.3.6] Only listed while the Animation look is the chosen style.
    visible = function()
        local uf = TomoModForeverDB and TomoModForeverDB.unitFrames
        return uf and uf.style == "animation"
    end,
    fallback = "uf_style",
    kw = "animation braise halo arc arcs hud anneau anneaux braises menace combo incantation cast onde",
    build = function(parent)
        return K.Page(parent, function(page)
            local AH = TomoMod_AnimHUD
            page:Hero(T("HUD Animation", "Animation HUD"),
                T("Le style Animation : des arcs autour du personnage pour ta vie, ta ressource, ta cible et ton familier, la menace, les points de combo, les incantations, et une animation au centre qui respire hors combat et s'embrase en combat.",
                  "The Animation look: arcs around your character for your health, power, target and pet, threat, combo points, casts, and a centre animation that breathes out of combat and ignites in combat."))

            local c = page:Card(T("Style", "Look"))
            local uf = TomoModForeverDB.unitFrames
            if AH and AH.BraiseLoaded and AH.BraiseLoaded() then
                c:Info(T("L'addon Braise est chargé : il affiche déjà son halo, le style Animation reste en retrait pour ne pas en dessiner un second. Désactive Braise pour utiliser celui de TMF.",
                         "The Braise addon is loaded: it already draws its halo, so the Animation look stands down rather than draw a second one. Turn Braise off to use TMF's."))
            elseif not uf.enabled then
                c:Info(T("Les cadres d'unité TomoMod sont désactivés : le HUD Animation aussi. Active-les depuis l'Accueil.",
                         "TomoMod unit frames are turned off, and so is the Animation HUD. Turn them on from Home."))
            else
                c:Info(T("Style Animation actif. Les barres d'incantation TMF du joueur, de la cible et du familier sont remplacées par les arcs d'incantation.",
                         "Animation look on. The TMF cast bars of the player, target and pet are replaced by the cast arcs."))
                c:Button(T("Déplacer les éléments", "Move the elements"), function()
                    if AH and AH.ToggleMover then AH.ToggleMover() end
                end, 240, T("Une poignée par élément, une au centre pour tout le HUD. Clic droit sur une poignée : la remettre en place. Aussi : /tmf anim.",
                            "One handle per element, one in the centre for the whole HUD. Right-click a handle: put it back. Also: /tmf anim."))
                c:Button(T("Combat de démonstration", "Demo fight"), function()
                    if AH and AH.Demo then AH.Demo() end
                end, 240, T("Joue l'entrée et la sortie de combat. Aussi : /tmf anim test.",
                            "Plays the combat start and end. Also: /tmf anim test."))
            end
            c:Done()

            c = page:Card(T("Apparence", "Look"))
            AnimLookControls(c)
            c:Done()

            c = page:Card(T("Arcs", "Arcs"))
            c:Toggle(T("Cible (arcs extérieurs)", "Target (outer arcs)"), A("target"), AnimRefresh)
            c:Toggle(T("Familier (arcs intérieurs)", "Pet (inner arcs)"), A("pet"), AnimRefresh)
            c:Toggle(T("Cible de la cible (au-dessus du nom de la cible)", "Target of target (above the target's name)"), A("tot"), AnimRefresh)
            c:Toggle(T("Clic sur les arcs (cibler, menu, infobulle)", "Click the arcs (target, menu, tooltip)"), A("click"), AnimRefresh,
                T("Clic gauche : cibler. Clic droit : menu de l'unité. Survol : infobulle. Appliqué à la sortie du combat.",
                  "Left-click: target. Right-click: unit menu. Hover: tooltip. Applied when combat ends."))
            c:Toggle(T("Garder le cadre TMF du familier", "Keep the TMF pet frame"), A("keepPetFrame"), AnimRefresh,
                T("Utile aux chasseurs : le cadre TMF montre l'humeur du familier.", "Handy for hunters: the TMF frame shows the pet's mood."))
            c:Toggle(T("Garder le cadre TMF de la cible de la cible", "Keep the TMF target-of-target frame"), A("keepToTFrame"), AnimRefresh)
            c:Done()

            c = page:Card(T("Signes", "Signs"))
            c:Toggle(T("Arcs d'incantation (toi et ta cible)", "Cast arcs (you and your target)"), A("cast"), AnimRefresh)
            c:Toggle(T("Jauge de menace (en groupe ou avec un familier)", "Threat gauge (in a group or with a pet)"), A("threat"), AnimRefresh)
            c:Toggle(T("Je suis tank (garder l'aggro est bon)", "I am the tank (holding aggro is good)"), A("tankMode"), AnimRefresh)
            c:Toggle(T("Points de combo", "Combo points"), A("combo"), AnimRefresh)
            c:Toggle(T("Tes buffs et débuffs (à gauche du halo)", "Your buffs and debuffs (left of the halo)"), A("auraPlayer"), AnimRefresh)
            c:Toggle(T("Buffs et débuffs de la cible (à droite du halo)", "Target buffs and debuffs (right of the halo)"), A("auraTarget"), AnimRefresh)
            c:Done()

            c = page:Card(T("Animation centrale", "Centre animation"))
            c:Toggle(T("Anneaux qui tournent", "Turning rings"), A("ring"), AnimRefresh)
            c:Toggle(T("Braises", "Embers"), A("embers"), AnimRefresh)
            c:Toggle(T("Braises à la façon de la classe", "Embers move the way your class does"), A("classEmbers"), AnimRefresh,
                T("Étincelles du guerrier, feuilles du druide, statique du chaman...", "Warrior sparks, druid leaves, shaman static..."))
            c:Toggle(T("Onde de choc et lames en début et fin de combat", "Shockwave and blades on combat start and end"), A("transitions"), AnimRefresh)
            c:Toggle(T("Chrono de combat", "Combat timer"), A("timer"), AnimRefresh)
            c:Done()

            c = page:Card(T("Réinitialiser", "Reset"), { adv = true })
            c:Danger(T("Réglages et positions par défaut", "Default settings and positions"), function()
                if AH and AH.Reset then AH.Reset() end
                K.RefreshPage()
            end, 260)
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- Castbars
-- ---------------------------------------------------------------------
local CAST_UNITS = {
    { key = "player", fr = "Joueur", en = "Player" },
    { key = "target", fr = "Cible",  en = "Target" },
    { key = "focus",  fr = "Focalisation", en = "Focus", adv = true },
    { key = "pet",    fr = "Familier", en = "Pet", adv = true },
    { key = "boss",   fr = "Boss", en = "Boss", adv = true },
}

K.RegisterPage({
    key = "castbar",
    section = SECTION,
    label = T("Barres d'incantation", "Castbars"),
    kw = "castbar cast incantation sort lancement barre gcd interrupt interruption",
    locate = "TomoMod_Castbar_player",
    onShow = function() K.CastPreview(true) end,
    onHide = function() K.CastPreview(false) end,
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Barres d'incantation", "Castbars"),
                T("Un aperçu reste affiché tant que cette page est ouverte, pour régler sans lancer de sort.",
                  "A preview stays on screen while this page is open, so you can tune it without casting."),
                "TomoMod_Castbar_player", T("Incantation", "Castbar"))

            local c = page:Card(T("Apparence", "Look"))
            c:Seg(T("Texture", "Texture"), "castbars.barTexture", {
                { text = "Blizzard", value = "blizzard" },
                { text = T("Lisse", "Smooth"), value = "smooth" },
                { text = T("Plat", "Flat"), value = "flat" },
            }, "cast", 3)
            c:Select(T("Police", "Font"), "castbars.font", K.FONTS, "cast")
            c:Slider(T("Taille du texte", "Text size"), "castbars.fontSize", 8, 20, 1, "cast")
            c:Toggle(T("Couleur de ma classe", "My class colour"), "castbars.useClassColor", "cast")
            c:Pair(function(l) l:Color(T("Interruptible", "Interruptible"), "castbars.castbarColor", "cast") end,
                   function(r) r:Color(T("Non interruptible", "Uninterruptible"), "castbars.castbarNIColor", "cast") end)
            c:Done()

            c = page:Card(T("Effets", "Effects"))
            c:Pair(function(l) l:Toggle(T("Étincelle", "Spark"), "castbars.showSpark", "cast") end,
                   function(r) r:Toggle(T("Ticks des canalisations", "Channel ticks"), "castbars.showChannelTicks", "cast") end)
            c:Toggle(T("Message « Interrompu ! »", "\"Interrupted!\" message"), "castbars.showInterruptFeedback", "cast")
            c:Toggle(T("La barre tremble quand un sort est interrompu", "The bar shakes when a cast is interrupted"), "castbars.interruptShake", "cast")
            c:Button(T("Tester la secousse", "Test the shake"), function()
                local cb = TomoMod_Castbar and TomoMod_Castbar.castbars and TomoMod_Castbar.castbars.player
                if cb and TomoMod_Utils.Shake then TomoMod_Utils.Shake(cb, 5, 0.3) end
            end, 180)
            c:Seg(T("Chronomètre", "Timer"), "castbars.timerFormat", {
                { text = T("Restant", "Remaining"), value = "remaining" },
                { text = T("Restant / total", "Left / total"), value = "remaining_total" },
                { text = T("Écoulé", "Elapsed"), value = "elapsed" },
            }, "cast", 3)
            c:Done()

            c = page:Card(T("Effets avancés", "Advanced effects"), { adv = true })
            c:Select(T("Style d'étincelle", "Spark style"), "castbars.sparkStyle", {
                { text = "Comet", value = "Comet" }, { text = "Pulse", value = "Pulse" },
                { text = "Helix", value = "Helix" }, { text = "Glitch", value = "Glitch" },
            }, "cast")
            c:Toggle(T("Barre de temps global (GCD)", "Global cooldown bar (GCD)"), "castbars.showGCDSpark", "cast")
            c:Slider(T("Hauteur du GCD", "GCD height"), "castbars.gcdHeight", 1, 12, 1, "cast")
            c:Done()

            for _, u in ipairs(CAST_UNITS) do
                local p = "castbars." .. u.key .. "."
                c = page:Card(T(u.fr, u.en), { adv = u.adv })
                c:Toggle(T("Activer", "Enable"), p .. "enabled", "cast")
                c:Pair(function(l) l:Slider(T("Largeur", "Width"), p .. "width", 60, 500, 1, "cast") end,
                       function(r) r:Slider(T("Hauteur", "Height"), p .. "height", 6, 40, 1, "cast") end)
                c:Pair(function(l) l:Toggle(T("Icône du sort", "Spell icon"), p .. "showIcon", "cast") end,
                       function(r) r:Toggle(T("Chronomètre", "Timer"), p .. "showTimer", "cast") end)
                if u.key == "player" then
                    c:Toggle(T("Latence (zone rouge)", "Latency (red zone)"), p .. "showLatency", "cast")
                else
                    c:Toggle(T("Coller sous le cadre d'unité", "Stick under the unit frame"), p .. "anchorToUnitFrame", "cast")
                end
                c:Done()
            end
        end)
    end,
})

-- ---------------------------------------------------------------------
-- Resources (centered HUD)
-- ---------------------------------------------------------------------
K.RegisterPage({
    key = "resources",
    section = SECTION,
    label = T("Ressources", "Resources"),
    kw = "resource ressources mana energie energy rage combo points runes hud barre centree",
    locate = "TomoMod_ResourceBars_Container",
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Ressources au centre de l'écran", "Resources in the middle of the screen"),
                T("Mana, énergie, rage, points de combo... juste sous ton personnage.",
                  "Mana, energy, rage, combo points... right under your character."),
                "TomoMod_ResourceBars_Container", T("Ressources", "Resources"))

            local c = page:Card(T("Activation", "On / off"))
            c:Toggle(T("Activer les barres de ressources", "Enable resource bars"), {
                get = function() return K.IsModuleOn("resourceBars") end,
                set = function(v) K.SetModule("resourceBars", v) end,
            }, "res")
            c:Toggle(T("Afficher la mana / énergie au centre", "Show mana / energy in the middle"), "resourceBars.primaryPowerCentered", "res",
                T("Sinon elle reste dans le cadre joueur.", "Otherwise it stays in the player frame."))
            c:Done()

            c = page:Card(T("Taille", "Size"))
            c:Slider(T("Largeur", "Width"), "resourceBars.width", 80, 500, 1, "res")
            c:Slider(T("Hauteur de la mana / énergie", "Mana / energy height"), "resourceBars.primaryPowerBarHeight", 4, 40, 1, "res")
            c:Slider(T("Hauteur des points (combo, runes...)", "Points height (combo, runes...)"), "resourceBars.primaryHeight", 4, 40, 1, "res")
            c:Slider(T("Échelle", "Scale"), "resourceBars.scale", 0.5, 2, 0.05, "res")
            c:Done()

            c = page:Card(T("Quand les afficher ?", "When to show them?"))
            c:Seg(nil, "resourceBars.visibilityMode", {
                { text = T("Toujours", "Always"),         value = "always" },
                { text = T("En combat", "In combat"),     value = "combat" },
                { text = T("Combat ou cible", "Combat or target"), value = "target" },
                { text = T("Jamais", "Never"),            value = "hidden" },
            }, "res", 2)
            c:Slider(T("Opacité hors combat", "Out of combat opacity"), "resourceBars.oocAlpha", 0, 1, 0.05, "res", "%.2f")
            c:Done()

            c = page:Card(T("Textes", "Texts"))
            c:Toggle(T("Valeur en texte", "Value as text"), "resourceBars.showText", "res")
            c:Slider(T("Taille du texte", "Text size"), "resourceBars.fontSize", 8, 20, 1, "res")
            c:Done()

            c = page:Card(T("Avancé", "Advanced"), { adv = true })
            c:Seg(T("Style", "Style"), "resourceBars.displayMode", {
                { text = T("Barres", "Bars"), value = "bars" },
                { text = T("Icônes", "Icons"), value = "icons" },
            }, "res", 2)
            c:Toggle(T("Barres fluides", "Smooth bars"), "resourceBars.smoothBars", "res")
            c:Toggle(T("Lueur quand la ressource est pleine", "Glow when the resource is full"), "resourceBars.showFullResourceGlow", "res")
            c:Toggle(T("Barre de vie centrée", "Centered health bar"), "resourceBars.healthBarEnabled", "res")
            c:Slider(T("Hauteur de la barre de vie", "Health bar height"), "resourceBars.healthBarHeight", 4, 30, 1, "res")
            c:Color(T("Couleur de la mana", "Mana colour"), "resourceBars.colors.mana", "res")
            c:Done()
        end)
    end,
})
