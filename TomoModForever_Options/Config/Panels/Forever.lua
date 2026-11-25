-- =====================================================================
-- Panels/Forever.lua -- "Aventure" : camp HUD, edge XP bar, missing buffs
-- =====================================================================

local K = TomoMod_Kit
local T = K.T

local SECTION = "adventure"

local function ModuleToggle(c, key, label)
    c:Toggle(label, {
        get = function() return K.IsModuleOn(key) end,
        set = function(v) K.SetModule(key, v) end,
    }, nil)
end

local function Call(global, fn, ...)
    local m = _G[global]
    if m and m[fn] then return m[fn](...) end
end

-- ---------------------------------------------------------------------
-- Camp HUD
-- ---------------------------------------------------------------------
local function CampApply() Call("TomoMod_Campfire", "ApplySettings") end

K.RegisterPage({
    key = "campfire",
    section = SECTION,
    label = T("Campement", "Camp"),
    kw = "camp campement feu campfire repos rest bonus assis sit hud",
    locate = "TomoMod_CampfireHUD",
    onHide = function() if TomoMod_Campfire and TomoMod_Campfire.IsPreview and TomoMod_Campfire.IsPreview() then TomoMod_Campfire.Preview(false) end end,
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Campement", "Camp"),
                T("Près d'un feu de camp, un cercle apparaît : clique pour t'asseoir. L'anneau se remplit pendant le repos et les bonus du camp s'affichent autour.",
                  "Near a campfire a ring appears: click it to sit. It fills while you rest and the camp bonuses are shown around it."),
                "TomoMod_CampfireHUD", T("Campement", "Camp"))

            local c = page:Card(T("Activation", "On / off"))
            ModuleToggle(c, "campfire", T("Afficher le HUD de campement", "Show the camp HUD"))
            c:Button(T("Tester l'affichage", "Test the display"), function()
                local CF = TomoMod_Campfire
                if CF and CF.Preview then CF.Preview(not CF.IsPreview()) end
            end, 200, T("Affiche le cercle avec un faux minuteur et de faux bonus. Recliquer pour cacher.",
                        "Shows the ring with a sample timer and bonuses. Click again to hide."))
            c:Done()

            c = page:Card(T("Réglages", "Settings"))
            c:Slider(T("Taille", "Size"), "campfire.scale", 0.6, 2, 0.05, CampApply, "%.2f")
            c:Toggle(T("Montrer les bonus du camp autour du cercle", "Show camp bonuses around the ring"), "campfire.showBonuses", CampApply)
            c:Toggle(T("Clic sur le cercle pour s'asseoir", "Click the ring to sit down"), "campfire.clickToSit", CampApply)
            c:Toggle(T("Masquer en combat", "Hide in combat"), "campfire.hideInCombat", CampApply)
            c:Toggle(T("Flammes animées", "Animated flames"), "campfire.animatedFlames", CampApply)
            c:Info(T("Pour le placer : bouton « Déplacer » en haut de la fenêtre.",
                     "To place it: \"Move\" button at the top of the window."))
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- Edge XP bar
-- ---------------------------------------------------------------------
local function XPApply()
    Call("TomoMod_EdgeXP", "ApplySettings")
    Call("TomoMod_EdgeXP", "Flash")
end

K.RegisterPage({
    key = "xpedge",
    section = SECTION,
    label = T("Barre d'XP", "XP bar"),
    kw = "xp experience barre niveau level repos rested quetes quests reputation",
    locate = "TomoMod_EdgeXPBar",
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Barre d'XP", "XP bar"),
                T("Une barre fine sur toute la largeur de l'écran. Survole-la pour le détail : XP/h, temps avant le prochain niveau, quêtes prêtes à rendre.",
                  "A thin bar across the whole screen. Hover it for details: XP/hour, time to next level, quests ready to turn in."),
                "TomoMod_EdgeXPBar", T("Barre d'XP", "XP bar"))

            local c = page:Card(T("Activation", "On / off"))
            ModuleToggle(c, "xpEdge", T("Afficher la barre d'XP", "Show the XP bar"))
            c:Toggle(T("Cacher la barre d'XP de Blizzard", "Hide Blizzard's XP bar"), "xpEdge.hideBlizzard", XPApply)
            c:Done()

            c = page:Card(T("Affichage", "Display"))
            c:Seg(T("Bord de l'écran", "Screen edge"), "xpEdge.edge", {
                { text = T("En bas", "Bottom"), value = "BOTTOM" },
                { text = T("En haut", "Top"),   value = "TOP" },
            }, XPApply, 2)
            c:Seg(T("Quand l'afficher ?", "When to show it?"), "xpEdge.visibility", {
                { text = T("Toujours", "Always"), value = "always" },
                { text = T("Après un gain", "After a gain"), value = "gain" },
                { text = T("Au survol", "On hover"), value = "hover" },
            }, XPApply, 3)
            c:Slider(T("Épaisseur", "Thickness"), "xpEdge.height", 2, 20, 1, XPApply)
            c:Slider(T("Opacité", "Opacity"), "xpEdge.alpha", 0.2, 1, 0.05, XPApply, "%.2f")
            c:Seg(T("Couleur", "Colour"), "xpEdge.colorMode", {
                { text = T("Ma classe", "My class"), value = "class" },
                { text = T("Or", "Gold"), value = "gold" },
            }, XPApply, 2)
            c:Done()

            c = page:Card(T("Informations", "Information"))
            c:Pair(function(l) l:Toggle(T("XP reposée", "Rested XP"), "xpEdge.showRested", XPApply) end,
                   function(r) r:Toggle(T("Graduations 10 %", "10 % ticks"), "xpEdge.showTicks", XPApply) end)
            c:Pair(function(l) l:Toggle(T("Badge de niveau", "Level badge"), "xpEdge.showBadge", XPApply) end,
                   function(r) r:Toggle(T("« +xp » à chaque gain", "\"+xp\" on each gain"), "xpEdge.gainText", XPApply) end)
            c:Seg(T("Position du niveau", "Level position"), "xpEdge.badgePos", {
                { text = T("À gauche", "Left"),    value = "left" },
                { text = T("Au centre", "Center"), value = "center" },
                { text = T("À droite", "Right"),   value = "right" },
            }, XPApply, 3)
            c:Toggle(T("Quêtes prêtes à rendre au survol", "Quests ready to turn in on hover"), "xpEdge.showQuests", XPApply)
            c:Toggle(T("Au niveau max : afficher la réputation suivie", "At max level: show the watched reputation"), "xpEdge.repAtMax", XPApply)
            c:Done()

            c = page:Card(T("Animations", "Animations"))
            c:Toggle(T("L'XP gagnée remplit la barre en glissant", "Earned XP flows into the bar"), "xpEdge.glide", XPApply)
            c:Toggle(T("Reflet sur la part reposée", "Shimmer on the rested part"), "xpEdge.restedShimmer", XPApply,
                T("Avec les animations complètes.", "With full animations."))
            c:Done()

            c = page:Card(T("Passage de niveau", "Level up"))
            c:Toggle(T("Lumière dorée et « Niveau N ! » au centre de l'écran", "Golden sweep and \"Level N!\" in the middle of the screen"), "xpEdge.levelUpBurst", nil)
            c:Button(T("Tester l'animation", "Test the animation"), function()
                local XPm = TomoMod_EdgeXP
                if XPm and XPm.PlayLevelUp then XPm.PlayLevelUp((UnitLevel("player") or 1) + 1) end
            end, 200)
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- Missing buffs
-- ---------------------------------------------------------------------
local function MBApply() Call("TomoMod_MissingBuffs", "ApplySettings") end

K.RegisterPage({
    key = "missingbuffs",
    section = SECTION,
    label = T("Buffs manquants", "Missing buffs"),
    kw = "buffs manquants missing rappel reminder intelligence endurance armure aura aspect poison enchantement",
    locate = "TomoMod_MissingBuffsFrame",
    onHide = function() if TomoMod_MissingBuffs and TomoMod_MissingBuffs._preview then TomoMod_MissingBuffs.Preview(false) end end,
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Buffs manquants", "Missing buffs"),
                T("Une icône apparaît quand un buff de ta classe n'est pas actif sur toi. Clique dessus pour le lancer.",
                  "An icon appears when one of your class buffs is not up on you. Click it to cast it."),
                "TomoMod_MissingBuffsFrame", T("Buffs manquants", "Missing buffs"))

            local c = page:Card(T("Activation", "On / off"))
            ModuleToggle(c, "missingBuffs", T("Activer les rappels", "Enable reminders"))
            c:Button(T("Tester l'affichage", "Test the display"), function()
                local MB = TomoMod_MissingBuffs
                if MB and MB.Preview then MB.Preview(not MB._preview) end
            end, 200)
            c:Done()

            c = page:Card(T("Affichage", "Display"))
            c:Slider(T("Taille des icônes", "Icon size"), "missingBuffs.iconSize", 20, 64, 1, MBApply)
            c:Toggle(T("Nom du buff sous l'icône", "Buff name under the icon"), "missingBuffs.showLabel", MBApply)
            c:Toggle(T("Icônes qui s'agitent pour attirer l'œil", "Icons nudge to catch your eye"), "missingBuffs.wiggle", MBApply)
            c:Toggle(T("Masquer en ville / à l'auberge", "Hide in cities / inns"), "missingBuffs.hideResting", MBApply)
            c:Toggle(T("Masquer en combat", "Hide in combat"), "missingBuffs.hideInCombat", MBApply)
            c:Toggle(T("Vérifier les enchantements d'arme (poisons, imprégnations)", "Check weapon enchants (poisons, imbues)"), "missingBuffs.weaponEnchants", MBApply)
            c:Done()

            local MB = TomoMod_MissingBuffs
            local rules = MB and MB.ClassRules and MB.ClassRules() or {}
            c = page:Card(T("Buffs de ma classe", "My class buffs"))
            if #rules == 0 then
                c:Info(T("Pas de buff de classe suivi pour ta classe : ajoute les tiens ci-dessous.",
                         "No class buff tracked for your class: add your own below."))
            end
            for _, r in ipairs(rules) do
                c:Toggle(r.label, {
                    get = function()
                        local d = TomoModForeverDB.missingBuffs.disabled
                        return not (d and d[r.key])
                    end,
                    set = function(v)
                        local db = TomoModForeverDB.missingBuffs
                        db.disabled = db.disabled or {}
                        db.disabled[r.key] = (not v) or nil
                    end,
                }, MBApply)
            end
            c:Info(T("Seuls les sorts que tu connais sont vérifiés.", "Only spells you know are checked."))
            c:Done()

            c = page:Card(T("Mes buffs personnalisés", "My custom buffs"))
            local list = TomoModForeverDB.missingBuffs.custom
            for i, name in ipairs(list) do
                c:Pair(function(l) l:Label(name) end, function(r)
                    r:Button(T("Retirer", "Remove"), function()
                        table.remove(list, i); MBApply(); K.RefreshPage()
                    end, 100)
                end)
            end
            c:Input(nil, T("Nom exact du buff (ex. : Épines)", "Exact buff name (e.g. Thorns)"), T("Ajouter", "Add"), function(txt)
                list[#list + 1] = txt
                MBApply(); K.RefreshPage()
                return true
            end)
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- Adventure comforts (1.2.0): resurrection, red errors, trainer, camera
-- ---------------------------------------------------------------------
local function ATApply() Call("TomoMod_AdventureTweaks", "Apply") end
local function FXApply() Call("TomoMod_CVarOptimizer", "ApplyComfort") end
local function MapApply() Call("TomoMod_MapReveal", "ApplySettings") end

K.RegisterPage({
    key = "adventuretweaks",
    section = SECTION,
    label = T("Confort d'aventure", "Adventure comforts"),
    kw = "resurrection rez res erreur error rouge red message entraineur trainer apprendre train camera zoom ivresse drunk mort death effet effect ecran screen cvar carte map reveler reveal brouillard fog inexplore unexplored decouvrir scintillement sparkle quete quest objet item loot butin surbrillance highlight",
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Confort d'aventure", "Adventure comforts"),
                T("Petits réglages du quotidien : résurrections acceptées seules, erreurs rouges masquées, bouton « Tout apprendre » chez les maîtres, caméra plus éloignée, objets de quête qui scintillent, carte entièrement visible.",
                  "Everyday tweaks: resurrections accepted for you, red errors hidden, a \"Train all\" button at trainers, a farther camera, sparkling quest items, a fully visible map."))

            local c = page:Card(T("Résurrection", "Resurrection"))
            c:Toggle(T("Accepter les résurrections automatiquement", "Accept resurrections automatically"), "adventureTweaks.autoRes", ATApply)
            c:Toggle(T("Sauf si la personne qui me relève est en combat", "Unless the caster is in combat"), "adventureTweaks.autoResNoCombat", ATApply,
                T("En combat, mieux vaut parfois attendre la fin du pull avant de se relever.",
                  "In combat it is sometimes better to wait for the pull to end before getting up."))
            c:Toggle(T("Une ligne dans le chat à chaque résurrection acceptée", "A chat line for each accepted resurrection"), "adventureTweaks.autoResMessage", ATApply)
            c:Done()

            c = page:Card(T("Erreurs rouges", "Red errors"))
            c:Toggle(T("Masquer les erreurs rouges (et leur voix)", "Hide red errors (and their voice)"), "adventureTweaks.hideErrors", ATApply,
                T("« Pas assez de mana », « Hors de portée », « Le sort n'est pas prêt »… Les messages jaunes d'information restent affichés.",
                  "\"Not enough mana\", \"Out of range\", \"Spell is not ready yet\"... Yellow info messages still show."))
            c:Seg(T("Quand les masquer ?", "When to hide them?"), "adventureTweaks.hideErrorsMode", {
                { text = T("Toujours", "Always"), value = "always" },
                { text = T("En combat", "In combat"), value = "combat" },
            }, ATApply, 2)
            c:Toggle(T("Garder les messages importants (sacs pleins, journal de quêtes plein, mort…)", "Keep important ones (bags full, quest log full, dead...)"),
                "adventureTweaks.keepImportantErrors", ATApply)
            c:Done()

            c = page:Card(T("Maîtres", "Trainers"))
            c:Toggle(T("Bouton « Tout apprendre » chez les maîtres", "\"Train all\" button at trainers"), "adventureTweaks.trainAll", ATApply,
                T("Apprend tout ce que tu peux payer, du moins cher au plus cher. Le survol du bouton montre le nombre et le coût.",
                  "Learns everything you can afford, cheapest first. Hovering the button shows the count and the cost."))
            c:Done()

            c = page:Card(T("Caméra et effets d'écran", "Camera and screen effects"))
            c:Toggle(T("Zoom caméra maximal", "Max camera zoom"), "cameraFx.maxZoom", FXApply,
                T("Permet d'éloigner la caméra au maximum autorisé par le client.", "Lets the camera go as far as the client allows."))
            c:Toggle(T("Désactiver le flou d'ivresse", "Disable the drunken haze"), "cameraFx.noDrunkHaze", FXApply,
                T("Coupe aussi le léger halo lumineux plein écran.", "Also turns off the soft full-screen glow."))
            c:Toggle(T("Désactiver l'écran gris à la mort", "Disable the grey death screen"), "cameraFx.noDeathFx", FXApply)
            c:Info(T("Décocher remet la valeur que tu avais avant.", "Unticking puts back the value you had before."))
            c:Done()

            c = page:Card(T("Objets de quête", "Quest items"))
            c:Toggle(T("Faire scintiller les objets de quête à ramasser", "Make lootable quest items sparkle"), "cameraFx.lootSparkles", FXApply,
                T("Garde l'effet de scintillement du jeu sur les objets de quête au sol, même après un préréglage graphique qui le coupe. Ton mode contour n'est pas modifié.",
                  "Keeps the game's sparkle on quest items on the ground, even after a graphics preset turns it off. Your outline mode is left as you set it."))
            c:Info(T("Décocher ne prend effet qu'après un redémarrage complet du jeu (/reload ne suffit pas). Le jeu ne laisse pas choisir quels objets scintillent : c'est son propre effet.",
                  "Unticking only takes effect after restarting the game (/reload is not enough). The game decides which objects sparkle: it is its own effect."))
            c:Done()

            c = page:Card(T("Carte du monde", "World map"))
            c:Toggle(T("Afficher les zones inexplorées", "Show unexplored areas"), "mapReveal.enabled", MapApply,
                T("La carte montre aussi les zones que tu n'as pas encore découvertes : tu vois où aller avant d'y être passé. La découverte des zones (et son XP) ne change pas.",
                  "The map also shows the areas you have not discovered yet: you see where to go before you have been there. Discovering areas (and its XP) does not change."))
            c:Toggle(T("Teinter les zones inexplorées", "Tint unexplored areas"), "mapReveal.tint", MapApply,
                T("Les distingue des zones déjà découvertes.", "Tells them apart from the areas already discovered."))
            c:Color(T("Couleur de la teinte", "Tint colour"), "mapReveal.tintColor", MapApply)
            c:Toggle(T("Niveaux des zones sur la carte", "Zone levels on the map"), "mapReveal.zoneLevels", MapApply,
                T("Au survol, le nom de la zone affiche sa tranche de niveaux, colorée selon ton niveau (rouge : trop haut, orange : pour toi, vert : facile, gris : trop bas).",
                  "On hover, the zone name shows its level range, coloured for your level (red: too high, orange: right for you, green: easy, grey: too low)."))
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- Prettier graphics (1.2.2): optional CVars, all off by default
-- ---------------------------------------------------------------------
local GRAPHICS_KEYS = { "groundDensity", "groundFade", "groundDist", "sharpen",
    "objFade", "objCull", "terrainLod", "reflection", "weather" }

local function GraphicsAll(on)
    local db = TomoModForeverDB and TomoModForeverDB.graphicsFx
    if not db then return end
    for _, k in ipairs(GRAPHICS_KEYS) do db[k] = on and true or false end
    FXApply()
    K.RefreshPage()
end

K.RegisterPage({
    key = "graphics",
    section = SECTION,
    label = T("Graphismes", "Graphics"),
    kw = "graphisme graphics cvar joli pretty herbe grass vegetation vegetal densite density distance netteté sharpen objet object relief terrain reflet reflection eau water meteo weather pluie rain neige snow",
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Graphismes", "Graphics"),
                T("Des réglages cachés du jeu pour un rendu plus joli : végétation plus dense et visible plus loin, image plus nette, décor détaillé jusqu'à l'horizon. Rien n'est activé de base : chaque option coûte des FPS, à toi de choisir.",
                  "Hidden game settings for a prettier picture: denser vegetation seen from farther away, a sharper image, scenery detailed up to the horizon. Nothing is on by default: each option costs frames, your choice."))

            local c = page:Card(T("Végétation", "Vegetation"))
            c:Toggle(T("Herbe et plantes plus denses", "Denser grass and plants"), "graphicsFx.groundDensity", FXApply,
                T("groundEffectDensity : 256 (48 par défaut).", "groundEffectDensity: 256 (48 by default)."))
            c:Toggle(T("Végétation qui disparaît plus loin", "Vegetation fades out farther away"), "graphicsFx.groundFade", FXApply,
                T("groundEffectFade : 370 (70 par défaut).", "groundEffectFade: 370 (70 by default)."))
            c:Toggle(T("Végétation affichée plus loin", "Vegetation drawn farther away"), "graphicsFx.groundDist", FXApply,
                T("groundEffectDist : 500 (320 par défaut).", "groundEffectDist: 500 (320 by default)."))
            c:Done()

            c = page:Card(T("Décor et horizon", "Scenery and horizon"))
            c:Toggle(T("Objets visibles de plus loin", "Objects visible from farther away"), "graphicsFx.objFade", FXApply,
                T("lodObjectFadeScale : 200.", "lodObjectFadeScale: 200."))
            c:Toggle(T("Petits objets gardés à distance", "Small objects kept at a distance"), "graphicsFx.objCull", FXApply,
                T("lodObjectCullSize : 8. Plus la valeur est basse, plus les petits objets restent affichés de loin.",
                  "lodObjectCullSize: 8. The lower the value, the longer small objects stay visible at a distance."))
            c:Toggle(T("Relief détaillé jusqu'à l'horizon", "Terrain detailed up to the horizon"), "graphicsFx.terrainLod", FXApply,
                T("terrainLodDist : 1000.", "terrainLodDist: 1000."))
            c:Done()

            c = page:Card(T("Image, eau et météo", "Picture, water and weather"))
            c:Toggle(T("Image toujours nette", "Always sharpen the picture"), "graphicsFx.sharpen", FXApply,
                T("ResampleAlwaysSharpen : 1. Utile surtout avec une échelle de rendu sous 100 %.",
                  "ResampleAlwaysSharpen: 1. Mostly useful with a render scale under 100%."))
            c:Toggle(T("Reflets de l'eau détaillés", "Detailed water reflections"), "graphicsFx.reflection", FXApply,
                T("reflectionMode : 3 (1 par défaut).", "reflectionMode: 3 (1 by default)."))
            c:Toggle(T("Météo plus dense (pluie, neige)", "Denser weather (rain, snow)"), "graphicsFx.weather", FXApply,
                T("weatherDensity : 3 (1 par défaut).", "weatherDensity: 3 (1 by default)."))
            c:Done()

            c = page:Card(T("Tout d'un coup", "All at once"))
            c:Pair(function(l) l:Button(T("Tout activer", "Turn all on"), function() GraphicsAll(true) end, 150) end,
                   function(r) r:Button(T("Tout désactiver", "Turn all off"), function() GraphicsAll(false) end, 150) end)
            c:Info(T("Décocher remet la valeur que tu avais avant. Si tu changes ensuite ces réglages dans les options graphiques du jeu, TomoMod réapplique les siens à la connexion tant qu'ils sont cochés. Un réglage absent de ton client est ignoré.",
                     "Unticking puts back the value you had before. If you later change these in the game's graphics options, TomoMod applies its own again at login while they are ticked. A setting your client does not have is ignored."))
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- Flight timer
-- ---------------------------------------------------------------------
local function FTApply() Call("TomoMod_FlightTimer", "ApplySettings") end

K.RegisterPage({
    key = "flighttimer",
    section = SECTION,
    label = T("Temps de vol", "Flight timer"),
    kw = "vol flight trajet taxi griffon gryphon wyvern coursier maitre de vol flight master temps time duree duration barre bar",
    locate = "TomoMod_FlightTimerBar",
    noCache = true,   -- the learned-routes count changes after each flight
    onHide = function() if TomoMod_FlightTimer and TomoMod_FlightTimer.IsPreview and TomoMod_FlightTimer.IsPreview() then TomoMod_FlightTimer.Preview(false) end end,
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Temps de vol", "Flight timer"),
                T("Une barre pendant les trajets aériens : destination et temps restant. Chaque trajet est mesuré la première fois que tu le fais, puis le compte à rebours est exact.",
                  "A bar during flights: destination and time left. Each route is measured the first time you fly it, then the countdown is exact."),
                "TomoMod_FlightTimerBar", T("Temps de vol", "Flight timer"))

            local c = page:Card(T("Activation", "On / off"))
            ModuleToggle(c, "flightTimer", T("Afficher la barre de temps de vol", "Show the flight timer bar"))
            c:Button(T("Tester l'affichage", "Test the display"), function()
                local FTm = TomoMod_FlightTimer
                if FTm and FTm.Preview then FTm.Preview(not FTm.IsPreview()) end
            end, 200, T("Affiche la barre avec un faux trajet. Recliquer pour cacher.",
                        "Shows the bar with a sample flight. Click again to hide."))
            c:Done()

            c = page:Card(T("Affichage", "Display"))
            c:Slider(T("Taille", "Size"), "flightTimer.scale", 0.6, 2, 0.05, FTApply, "%.2f")
            c:Slider(T("Largeur", "Width"), "flightTimer.width", 160, 500, 5, FTApply)
            c:Seg(T("La barre…", "The bar..."), "flightTimer.fillMode", {
                { text = T("se vide", "drains"), value = "drain" },
                { text = T("se remplit", "fills"), value = "fill" },
            }, FTApply, 2)
            c:Toggle(T("Durée dans la bulle d'aide de la carte des vols", "Duration in the flight map tooltip"), "flightTimer.mapTooltip", FTApply)
            c:Info(T("« ≈ » : trajet jamais fait en entier, durée estimée à partir des morceaux connus. Pour placer la barre : bouton « Déplacer » en haut de la fenêtre.",
                     "\"≈\": route never flown whole, estimated from known pieces. To place the bar: \"Move\" button at the top of the window."))
            c:Done()

            c = page:Card(T("Temps appris", "Learned times"))
            local FTm = TomoMod_FlightTimer
            local n = FTm and FTm.CountRoutes and FTm.CountRoutes() or 0
            c:Info(string.format(T("%d trajet(s) mesuré(s), partagés par tous tes personnages.", "%d route(s) measured, shared by all your characters."), n))
            c:Danger(T("Oublier tous les temps", "Forget all times"), function()
                if FTm and FTm.ForgetAll then FTm.ForgetAll() end
                K.Toast(T("Temps de vol effacés", "Flight times cleared"))
                K.RefreshPage()
            end, 200)
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- [1.3.6] Notifications and level-up celebration (Toasts.lua)
-- ---------------------------------------------------------------------
local function TSApply() Call("TomoMod_Toasts", "ApplySettings") end

K.RegisterPage({
    key = "toasts",
    section = SECTION,
    label = T("Notifications", "Notifications"),
    kw = "notification notifications toast bandeau banner quete quest butin loot rare epique epic reputation decouverte discovery sort spell niveau level celebration animation",
    locate = "TomoMod_ToastAnchor",
    onHide = function() if TomoMod_Toasts and TomoMod_Toasts.IsPreview and TomoMod_Toasts.IsPreview() then TomoMod_Toasts.Preview(false) end end,
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Notifications", "Notifications"),
                T("Des bandeaux bronze en haut de l'écran pour ce qui compte : quête rendue ou terminée, butin rare, nouvelle réputation, découverte, sorts appris. Et une vraie célébration à chaque niveau.",
                  "Bronze banners at the top of the screen for what matters: quest turned in or complete, rare loot, new standing, discovery, spells learned. And a real celebration at every level."),
                "TomoMod_ToastAnchor", T("Notifications", "Notifications"))

            local c = page:Card(T("Montée de niveau", "Level up"))
            c:Toggle(T("Célébration au centre de l'écran (anneau, Niveau N, étincelles)", "Celebration in the middle of the screen (ring, \"Level N\", embers)"), "levelUp.enabled", nil,
                T("Quand elle est active, la barre d'XP garde son reflet doré et lui laisse le grand titre.",
                  "While on, the XP bar keeps its golden sweep and leaves the big title to it."))
            c:Toggle(T("Masquer l'annonce de niveau du jeu", "Hide the game's level-up banner"), "levelUp.hideBlizzard", nil,
                T("Évite que l'annonce de Blizzard se superpose à la célébration.", "Keeps Blizzard's banner from overlapping the celebration."))
            c:Toggle(T("Aux niveaux pairs : sorts qui t'attendent chez ton maître de classe", "At even levels: spells waiting at your class trainer"), "levelUp.showSpells", nil)
            c:Slider(T("Taille", "Size"), "levelUp.scale", 0.6, 1.6, 0.05, nil, "%.2f")
            c:Button(T("Tester l'animation", "Test the animation"), function()
                local TSm = TomoMod_Toasts
                if TSm and TSm.PlayLevelUp then TSm.PlayLevelUp(((UnitLevel("player") or 1) + 1)) end
            end, 200)
            c:Done()

            c = page:Card(T("Notifications", "Notifications"))
            ModuleToggle(c, "toasts", T("Afficher les notifications", "Show notifications"))
            c:Button(T("Tester l'affichage", "Test the display"), function()
                local TSm = TomoMod_Toasts
                if TSm and TSm.Preview then TSm.Preview(not TSm.IsPreview()) end
            end, 200, T("Affiche trois exemples. Recliquer pour cacher.", "Shows three samples. Click again to hide."))
            c:Pair(function(l) l:Toggle(T("Quête rendue", "Quest turned in"), "toasts.questDone", nil) end,
                   function(r) r:Toggle(T("Quête terminée", "Quest complete"), "toasts.questReady", nil) end)
            c:Pair(function(l) l:Toggle(T("Butin", "Loot"), "toasts.loot", nil) end,
                   function(r) r:Toggle(T("Nouvelle réputation", "New standing"), "toasts.reputation", nil) end)
            c:Pair(function(l) l:Toggle(T("Découverte de zone", "Area discovered"), "toasts.discovery", nil) end,
                   function(r) r:Toggle(T("Sorts appris", "Spells learned"), "toasts.spells", nil) end)
            c:Seg(T("Butin à partir de", "Loot from"), "toasts.lootQuality", {
                { text = T("Inhabituel", "Uncommon"), value = 2 },
                { text = T("Rare", "Rare"),           value = 3 },
                { text = T("Épique", "Epic"),         value = 4 },
            }, nil, 3)
            c:Done()

            c = page:Card(T("Affichage", "Display"))
            c:Slider(T("Taille", "Size"), "toasts.scale", 0.6, 1.6, 0.05, TSApply, "%.2f")
            c:Slider(T("Durée à l'écran (s)", "Time on screen (s)"), "toasts.duration", 2, 12, 1, nil)
            c:Slider(T("Nombre affiché en même temps", "Shown at the same time"), "toasts.maxShown", 1, 6, 1, nil)
            c:Info(T("Clic gauche sur une quête : ouvrir le journal. Clic droit : fermer. Survol d'un butin : infobulle de l'objet. Pour les placer : bouton « Déplacer » en haut de la fenêtre. Les animations suivent le réglage de l'accueil (complètes, réduites, aucune).",
                     "Left click a quest: open the log. Right click: close. Hover loot: item tooltip. To place them: \"Move\" button at the top of the window. Animations follow the setting on the home page (full, reduced, none)."))
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- [1.3.6] Quest progress in tooltips (QuestTooltip.lua)
-- ---------------------------------------------------------------------
local function QTApply() Call("TomoMod_QuestTooltip", "ApplySettings") end

K.RegisterPage({
    key = "questtooltip",
    section = SECTION,
    label = T("Quêtes dans les infobulles", "Quests in tooltips"),
    kw = "infobulle tooltip quete quest objectif objective monstre monster mob objet item progression progress questie",
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Quêtes dans les infobulles", "Quests in tooltips"),
                T("Survole un monstre ou un objet demandé par une quête de ton journal : la quête et ta progression s'ajoutent à l'infobulle (Loup des bois tué : 3/8).",
                  "Hover a monster or an item a quest of your log asks for: the quest and your progress are added to the tooltip (Forest Wolf slain: 3/8)."))

            local c = page:Card(T("Activation", "On / off"))
            ModuleToggle(c, "questTooltip", T("Ajouter la progression des quêtes aux infobulles", "Add quest progress to tooltips"))
            c:Pair(function(l) l:Toggle(T("Monstres", "Monsters"), "questTooltip.units", QTApply) end,
                   function(r) r:Toggle(T("Objets", "Items"), "questTooltip.items", QTApply) end)
            c:Toggle(T("Montrer aussi les objectifs déjà terminés", "Also show objectives already done"), "questTooltip.showDone", QTApply)
            c:Info(T("Le nom du monstre ou de l'objet doit être exactement celui de l'objectif : aucune supposition. Si Questie affiche déjà ses propres infobulles de quêtes, TMF se met en retrait pour ne pas doubler les lignes.",
                     "The monster or item name must be exactly the objective's name: no guessing. If Questie already shows its own quest tooltips, TMF stands down so lines are not doubled."))
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- Bag space banner
-- ---------------------------------------------------------------------
local function BAApply() Call("TomoMod_BagAlert", "ApplySettings") end
local function TRApply() Call("TomoMod_Triage", "ApplySettings") end

K.RegisterPage({
    key = "bagalert",
    section = SECTION,
    label = T("Place dans les sacs", "Bag space"),
    kw = "sac sacs bag bags place space plein full inventaire inventory vendre sell gris grey alerte alert jeter throw supprimer delete butin loot tri triage pièce coin",
    locate = "TomoMod_BagAlertFrame",
    onHide = function() if TomoMod_BagAlert and TomoMod_BagAlert.IsPreview and TomoMod_BagAlert.IsPreview() then TomoMod_BagAlert.Preview(false) end end,
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Place dans les sacs", "Bag space"),
                T("Une bannière animée te prévient quand tes sacs sont presque pleins : à la connexion pour vendre avant de partir, et en cours de jeu quand le butin franchit le seuil.",
                  "An animated banner warns you when your bags are nearly full: at login so you sell before heading out, and while playing when loot crosses the threshold."),
                "TomoMod_BagAlertFrame", T("Place dans les sacs", "Bag space"))

            local c = page:Card(T("Activation", "On / off"))
            ModuleToggle(c, "bagAlert", T("Afficher l'alerte de place dans les sacs", "Show the bag space alert"))
            c:Button(T("Tester l'affichage", "Test the display"), function()
                local B = TomoMod_BagAlert
                if B and B.Preview then B.Preview(not B.IsPreview()) end
            end, 200, T("Joue l'animation avec tes sacs actuels (ou un exemple s'ils sont presque vides). Recliquer pour cacher.",
                        "Plays the animation with your current bags (or a sample if they are nearly empty). Click again to hide."))
            c:Done()

            c = page:Card(T("Quand prévenir ?", "When to warn?"))
            c:Slider(T("Seuil de remplissage", "Fill threshold"), "bagAlert.threshold", 50, 100, 5, BAApply, "%.0f %%")
            c:Toggle(T("À la connexion", "At login"), "bagAlert.onLogin", BAApply,
                T("Quelques secondes après l'écran de chargement, si le seuil est dépassé. Pas après un /reload.",
                  "A few seconds after the loading screen, if past the threshold. Not after a /reload."))
            c:Toggle(T("En cours de jeu, quand le butin franchit le seuil", "While playing, when loot crosses the threshold"), "bagAlert.onFill", BAApply,
                T("Une seule fois : l'alerte se réarme quand tu repasses sous le seuil. En combat, elle attend la fin du combat.",
                  "Only once: it re-arms when you drop back below the threshold. In combat it waits for the fight to end."))
            c:Toggle(T("Prévenir encore quand la dernière place est prise", "Warn again when the last slot is taken"), "bagAlert.fullAlert", BAApply)
            c:Done()

            c = page:Card(T("Affichage", "Display"))
            c:Slider(T("Taille", "Size"), "bagAlert.scale", 0.6, 2, 0.05, BAApply, "%.2f")
            c:Slider(T("Durée à l'écran (s)", "Time on screen (s)"), "bagAlert.duration", 3, 20, 1, BAApply)
            c:Toggle(T("Compter les objets gris et leur valeur", "Count grey items and their value"), "bagAlert.showGreys", BAApply)
            c:Toggle(T("Son à l'apparition", "Sound when shown"), "bagAlert.sound", BAApply)
            c:Info(T("Seuls les sacs normaux comptent (pas les carquois, gibernes ni sacs d'âmes). Clic sur la bannière : ouvrir les sacs ; clic droit : fermer. Pour la placer : bouton « Déplacer » en haut de la fenêtre.",
                     "Only regular bags count (no quivers, ammo pouches or soul bags). Click the banner: open bags; right click: close. To place it: \"Move\" button at the top of the window."))
            c:Done()

            c = page:Card(T("Quoi jeter, quoi ramasser", "What to throw away, what to loot"))
            ModuleToggle(c, "triage", T("Classer les objets à jeter", "Rank items to throw away"))
            c:Select(T("Numéros dans les sacs", "Numbers in the bags"), "triage.badges", {
                { text = T("Quand les sacs sont presque pleins", "When the bags are nearly full"), value = "full" },
                { text = T("Toujours", "Always"), value = "always" },
                { text = T("Jamais", "Never"), value = "off" },
            }, TRApply, T("Les objets les moins chers à la revente portent un numéro (1 = le premier à jeter) dans les sacs TomoMod. « Presque pleins » suit le seuil de l'alerte ci-dessus.",
                          "The items cheapest to sell carry a number (1 = first to go) in TomoMod's bags. \"Nearly full\" follows the alert threshold above."))
            c:Slider(T("Objets numérotés", "Numbered items"), "triage.badgeCount", 1, 10, 1, TRApply)
            c:Toggle(T("Pièce d'or sur le butin qui vaut le coup", "Gold coin on loot worth taking"), "triage.lootCoins", TRApply,
                T("Sacs pleins : chaque objet du butin est comparé à ton objet le moins cher (le plus cher du butin avec ton moins cher, et ainsi de suite). S'il vaut plus, il a une pièce d'or. Un butin qui rentre sur une pile que tu as déjà n'a pas besoin de place.",
                  "Full bags: each loot item is compared with your cheapest item (the dearest loot with your cheapest item, and so on). If it is worth more, it gets a gold coin. Loot that fits on a stack you already carry needs no room."))
            c:Toggle(T("Lignes dans les infobulles", "Tooltip lines"), "triage.tooltip", TRApply,
                T("« À jeter n°3 » avec la valeur de la pile, et sur le butin, l'objet à jeter pour le prendre.",
                  "\"To throw away #3\" with the stack's value, and on loot, the item to drop to take it."))
            c:Toggle(T("Nombre d'objets à jeter dans l'alerte", "Items to throw away in the alert"), "triage.alertCount", BAApply)
            c:Info(T("Jamais proposés : les objets épinglés dans les sacs TomoMod (clic milieu), les objets de quête et ceux qu'un objectif de ton journal de quêtes demande, les objets sans prix de vente, les munitions, et tout ce qui est au-dessus de vert.",
                     "Never suggested: items pinned in TomoMod's bags (middle click), quest items and items an objective of your quest log asks for, items with no vendor price, ammunition, and anything above green."))
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- Class trainer reminder
-- ---------------------------------------------------------------------
local function TRApply() Call("TomoMod_TrainerReminder", "ApplySettings") end

K.RegisterPage({
    key = "trainerreminder",
    section = SECTION,
    label = T("Rappel du maître", "Trainer reminder"),
    kw = "maitre classe class trainer sort sorts spell spells apprendre learn niveau level rang rank rappel reminder prix cost",
    locate = "TomoMod_TrainerReminderFrame",
    noCache = true,   -- the known-spells count changes after each visit
    onHide = function() if TomoMod_TrainerReminder and TomoMod_TrainerReminder.IsPreview and TomoMod_TrainerReminder.IsPreview() then TomoMod_TrainerReminder.Preview(false) end end,
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Rappel du maître de classe", "Class trainer reminder"),
                T("Tous les deux niveaux, un petit panneau te rappelle d'aller voir ton maître de classe, avec l'icône, le nom, le rang et le prix de chaque sort à apprendre.",
                  "Every second level a small panel reminds you to visit your class trainer, with the icon, name, rank and price of each spell to learn."),
                "TomoMod_TrainerReminderFrame", T("Maître de classe", "Class trainer"))

            local c = page:Card(T("Activation", "On / off"))
            ModuleToggle(c, "trainerReminder", T("Afficher le rappel du maître de classe", "Show the class trainer reminder"))
            c:Button(T("Tester l'affichage", "Test the display"), function()
                local M = TomoMod_TrainerReminder
                if M and M.Preview then M.Preview(not M.IsPreview()) end
            end, 200, T("Montre tes sorts en attente (ou un exemple). Recliquer pour cacher.",
                        "Shows your waiting spells (or a sample). Click again to hide."))
            c:Done()

            c = page:Card(T("Quand le montrer ?", "When to show it?"))
            c:Toggle(T("À la connexion, s'il y a des sorts à apprendre", "At login, when spells are waiting"), "trainerReminder.onLogin", TRApply)
            c:Toggle(T("Aux niveaux pairs, avant la première visite au maître", "On even levels, before the first trainer visit"), "trainerReminder.genericReminder", TRApply,
                T("Tant que la liste du maître n'est pas connue, le panneau dit seulement que de nouveaux sorts t'attendent sans doute.",
                  "Until the trainer's list is known the panel only says new spells are probably waiting."))
            c:Slider(T("Durée à l'écran (s, 0 = jusqu'à la visite)", "Time on screen (s, 0 = until the visit)"), "trainerReminder.duration", 0, 60, 5, TRApply)
            c:Toggle(T("Son à l'apparition", "Sound when shown"), "trainerReminder.sound", TRApply)
            c:Done()

            c = page:Card(T("Affichage", "Display"))
            c:Slider(T("Taille", "Size"), "trainerReminder.scale", 0.6, 2, 0.05, TRApply, "%.2f")
            local M = TomoMod_TrainerReminder
            local known = TomoModForeverCharDB and TomoModForeverCharDB.trainer and TomoModForeverCharDB.trainer.spells
            if known and TomoModForeverCharDB.trainer.scanned then
                local waiting = M and M.Pending and #M.Pending() or 0
                c:Info(string.format(T("Liste du maître connue : %d sort(s) à venir, dont %d à apprendre dès maintenant.",
                                       "Trainer list known: %d upcoming spell(s), %d you can learn right now."), #known, waiting))
            else
                c:Info(T("Liste du maître pas encore connue : parle une fois à ton maître de classe pour qu'elle soit lue.",
                         "Trainer list not known yet: talk to your class trainer once so it can be read."))
            end
            c:Info(T("La liste est lue à chaque visite (sorts futurs compris) et gardée pour ce personnage. Le panneau disparaît dès que tu parles au maître. Clic droit : fermer. Pour le placer : bouton « Déplacer ».",
                     "The list is read at each visit (future spells included) and kept for this character. The panel hides as soon as you talk to the trainer. Right click: close. To place it: \"Move\" button."))
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- New spell ranks on the bars
-- ---------------------------------------------------------------------
local function SRApply() Call("TomoMod_SpellRanks", "ApplySettings") end

K.RegisterPage({
    key = "spellranks",
    section = SECTION,
    label = T("Nouveaux rangs", "New ranks"),
    kw = "rang rangs rank ranks sort sorts spell spells barre barres bar bars action grimoire spellbook maitre trainer mise a jour update downrank",
    noCache = true,   -- the pending count changes after each trainer visit
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Nouveaux rangs de sorts", "New spell ranks"),
                T("Sur Forever, un rang acheté au maître ne remplace pas l'ancien sur tes barres. TomoMod te montre les sorts concernés et les met à jour d'un clic, sans toucher aux rangs bas que tu gardes exprès.",
                  "On Forever a rank bought at the trainer does not replace the old one on your bars. TomoMod shows the spells concerned and updates them in one click, without touching the low ranks you keep on purpose."))

            local c = page:Card(T("Activation", "On / off"))
            ModuleToggle(c, "spellRanks", T("Suivre les nouveaux rangs", "Track new ranks"))
            c:Select(T("Mise à jour des barres", "Updating the bars"), "spellRanks.mode", {
                { text = T("Me demander (flèche dans le grimoire)", "Ask me (arrow in the spellbook)"), value = "ask" },
                { text = T("Automatique en quittant le maître", "Automatic when leaving the trainer"), value = "auto" },
            }, SRApply, T("Automatique : dès que la fenêtre du maître se ferme (après le combat si besoin), avec les mêmes règles.",
                          "Automatic: as soon as the trainer window closes (after combat if needed), with the same rules."))
            c:Done()

            c = page:Card(T("Affichage", "Display"))
            c:Toggle(T("Faire briller les boutons à mettre à jour", "Make the buttons to update glow"), "spellRanks.glow", SRApply)
            c:Toggle(T("Flèche dorée sur le nouveau rang dans le grimoire", "Gold arrow on the new rank in the spellbook"), "spellRanks.arrow", SRApply,
                T("Clic gauche sur la flèche : mettre à jour les barres. Clic droit : garder l'ancien rang. Si AishCore est installé, sa propre flèche suffit et celle de TomoMod reste cachée.",
                  "Left click on the arrow: update the bars. Right click: keep the old rank. If AishCore is installed, its own arrow is enough and TomoMod's stays hidden."))
            c:Toggle(T("Ligne dans le chat en quittant le maître", "Chat line when leaving the trainer"), "spellRanks.chat", SRApply)
            local M = TomoMod_SpellRanks
            local n = M and M.PendingCount and M.PendingCount() or 0
            c:Info(string.format(T("En ce moment : %d sort(s) à mettre à jour.", "Right now: %d spell(s) to update."), n))
            c:Done()

            c = page:Card(T("Règles", "Rules"))
            c:Info(T("Seul le rang le plus haut présent sur tes barres est remplacé. Un rang plus bas placé à côté (Soins rapides rang 1 pour économiser le mana) n'est jamais touché. Un rang gardé avec le clic droit n'est plus proposé.",
                     "Only the highest rank present on your bars is replaced. A lower rank placed next to it (Flash Heal rank 1 to save mana) is never touched. A rank kept with right click is not offered any more."))
            c:Info(T("Rien n'est changé en combat. Les macros et le clic de soin ne sont pas mis à jour. /tmf rangs : état et liste ; /tmf rangs maj : tout mettre à jour ; /tmf rangs reset : oublier les rangs gardés.",
                     "Nothing is changed in combat. Macros and click casting are not updated. /tmf ranks: status and list; /tmf ranks update: update everything; /tmf ranks reset: forget the kept ranks."))
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- Dungeon codex
-- ---------------------------------------------------------------------
local function DCApply() Call("TomoMod_DungeonCodex", "ApplySettings") end

K.RegisterPage({
    key = "dungeoncodex",
    section = SECTION,
    label = T("Codex des donjons", "Dungeon codex"),
    kw = "donjon donjons dungeon dungeons instance codex itineraire route waypoint entree entrance niveau level carte map",
    noCache = true,   -- the custom positions count changes with /codex set
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Codex des donjons", "Dungeon codex"),
                T("Les 35 donjons de WoW Forever, du niveau 13 au 60 : ceux de ton niveau, l'itinéraire pour ta faction étape par étape, et un waypoint sur l'entrée.",
                  "The 35 dungeons of WoW Forever, levels 13 to 60: the ones for your level, the route for your faction step by step, and a waypoint on the entrance."))

            local c = page:Card(T("Activation", "On / off"))
            ModuleToggle(c, "dungeonCodex", T("Activer le codex des donjons", "Enable the dungeon codex"))
            c:Button(T("Ouvrir le codex", "Open the codex"), function()
                local M = TomoMod_DungeonCodex
                if M and M.Toggle then M.Toggle(true) end
            end, 200, T("Aussi avec /codex.", "Also with /codex."))
            c:Done()

            c = page:Card(T("Réglages", "Settings"))
            c:Toggle(T("Rappeler /codex dans le chat à la connexion", "Remind /codex in the chat at login"), "dungeonCodex.loginHint", DCApply)
            c:Toggle(T("Butin : seulement ce qui sert à ma classe", "Loot: only what my class uses"), "dungeonCodex.lootMine", DCApply,
                T("Même réglage que le bouton « Pour moi » de la fenêtre Butin : ton type d'armure selon ton niveau (cuir puis maille au niveau 40 pour chasseur et chaman, maille puis plaque pour guerrier et paladin), tes armes, boucliers et reliques.", "Same setting as the \"For me\" button of the Loot window: your armour type by level (leather then mail at 40 for hunter and shaman, mail then plate for warrior and paladin), your weapons, shields and relics."))
            c:Toggle(T("Ligne « Butin : boss (donjon) » dans les infobulles d'objets", "\"Loot: boss (dungeon)\" line on item tooltips"), "dungeonCodex.lootTooltip", DCApply,
                T("Cachée quand ForeverLoot est installé : il affiche déjà la sienne.", "Hidden when ForeverLoot is installed: it already shows its own."))
            c:Toggle(T("Prévenir dans le chat quand un donjon devient accessible", "Chat line when a dungeon comes within reach"), "dungeonCodex.levelUpHint", DCApply,
                T("Deux niveaux avant le minimum du donjon.", "Two levels before the dungeon's minimum."))
            c:Slider(T("Taille de la fenêtre", "Window size"), "dungeonCodex.scale", 0.7, 1.6, 0.05, DCApply, "%.2f")
            c:Done()

            c = page:Card(T("Positions des entrées", "Entrance positions"))
            local db = TomoModForeverDB and TomoModForeverDB.dungeonCodex
            local n = 0
            if db and db.overrides then for _ in pairs(db.overrides) do n = n + 1 end end
            c:Info(T("Les entrées des donjons classiques sont placées à leur position Classic (approximative) ; celles des nouveaux donjons viennent des guides Forever quand elles sont connues. Trois ne sont pas encore placées : Krol'dok, Repaire des Noiregueules, Terrasse du Façonneur.",
                     "Classic dungeon entrances use their Classic position (approximate); the new ones come from Forever guides when known. Three are not placed yet: Krol'dok, Blackmaw Hold, Shaper's Terrace."))
            c:Info(T("Pour corriger ou ajouter une entrée : place-toi dessus et tape /codex set <clé> (liste des clés : /codex keys). /codex here donne ta position, /codex missing les entrées manquantes.",
                     "To fix or add an entrance: stand on it and type /codex set <key> (keys: /codex keys). /codex here gives your position, /codex missing the missing ones."))
            c:Info(string.format(T("%d position(s) enregistrée(s) par toi.", "%d position(s) recorded by you."), n))
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- Mail (TomoMail port, 1.2.0)
-- ---------------------------------------------------------------------
-- Display options live per character in TomoModForeverMailDB; the page
-- binds to them directly. Before the module runs (off, or not yet
-- reloaded) only the on/off switch is offered.
local function MailP() return TomoMod_Mail and TomoMod_Mail.db and TomoMod_Mail.db.profile end

local function MailBind(key, after)
    return {
        get = function() local p = MailP(); return p and p[key] end,
        set = function(v)
            local p = MailP()
            if not p then return end
            p[key] = v
            if after then after() end
        end,
    }
end

local function MailCall(fn) return function() Call("TomoMod_Mail", fn) end end

K.RegisterPage({
    key = "mail",
    section = "comfort",
    noCache = true,   -- content depends on whether the module is running
    label = T("Courrier", "Mail"),
    kw = "courrier mail boite aux lettres mailbox alts reroll guilde guild contacts envoi send tomomail",
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Courrier", "Mail"),
                T("La boîte aux lettres de TomoMail aux couleurs de Forever : réception avec filtres et « Tout prendre », envoi, contacts (tes personnages, ta guilde, les récents), envoi groupé à tous tes alts et autocomplétion.",
                  "TomoMail's mailbox in the Forever palette: inbox with filters and \"Take all\", send tab, contacts (your characters, your guild, recent), send to every alt at once and autocomplete."))

            local c = page:Card(T("Activation", "On / off"))
            ModuleToggle(c, "mailSkin", T("Activer le module Courrier", "Enable the Mail module"))
            c:Info(T("Changer ce réglage demande un /reload. Si l'addon TomoMail est aussi activé, le module se met en pause.",
                     "Changing this needs a /reload. If the TomoMail addon is enabled too, the module pauses."))
            c:Done()

            if not MailP() then
                c = page:Card(T("Réglages", "Settings"))
                c:Info(T("Les réglages apparaissent une fois le module actif (après /reload).",
                         "Settings appear once the module is running (after /reload)."))
                c:Done()
                return
            end

            c = page:Card(T("Contacts", "Contacts"))
            c:Pair(function(l) l:Toggle(T("Mes personnages", "My characters"), MailBind("showAlts"), nil) end,
                   function(r) r:Toggle(T("Membres de guilde", "Guild members"), MailBind("showGuild"), nil) end)
            c:Pair(function(l) l:Toggle(T("Guilde : en ligne seulement", "Guild: online only"), MailBind("guildOnlineOnly"), nil) end,
                   function(r) r:Toggle(T("Destinataires récents", "Recent recipients"), MailBind("showRecent"), nil) end)
            c:Slider(T("Récents à garder", "Recent to keep"), MailBind("maxRecent", MailCall("TrimRecent")), 5, 25, 1, nil)
            c:Toggle(T("Autocomplétion du destinataire", "Recipient autocomplete"), MailBind("useAutocomplete", MailCall("ApplyAutocomplete")), nil)
            c:Done()

            c = page:Card(T("Apparence", "Appearance"))
            c:Toggle(T("Fenêtre TomoMail (sinon, seulement l'habillage des cadres Blizzard)", "TomoMail window (otherwise only Blizzard's frames are skinned)"),
                MailBind("modernUI"), nil, nil, function() K.NeedReload() end)
            c:Slider(T("Échelle", "Scale"), MailBind("mailScale", MailCall("ApplyScale")), 0.8, 1.5, 0.05, nil, "%.2f")
            c:Slider(T("Taille des icônes d'objets", "Item icon size"), MailBind("inboxIconSize", MailCall("ApplyIconSize")), 18, 36, 2, nil)
            c:Button(T("Tous les réglages du courrier…", "All mail settings..."), MailCall("OpenSettings"), 220,
                T("Police, taille du texte, effacement des récents et des alts. Aussi avec /tml.",
                  "Font, text size, clearing recent and alts. Also with /tml."))
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- 1.3.6: Mana bar extras
-- ---------------------------------------------------------------------
local function MBApply2() Call("TomoMod_ManaBar", "ApplySettings") end

K.RegisterPage({
    key = "manabar",
    section = SECTION,
    label = T("Barre de mana", "Mana bar"),
    kw = "mana regen regeneration cinq secondes five second rule 5sr tick cout cost sort spell prediction",
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Barre de mana", "Mana bar"),
                T("Sur la barre de mana de ton cadre de joueur : une étincelle parcourt la barre pendant les cinq secondes sans régénération après un sort, puis marque chaque tick de régénération. Pendant une incantation, la part de mana que le sort va coûter est surlignée.",
                  "On your player frame mana bar: a spark runs along the bar during the five seconds without regeneration after a spell, then marks each regeneration tick. While casting, the mana the spell will cost is highlighted."))

            local c = page:Card(T("Activation", "On / off"))
            ModuleToggle(c, "manaBar", T("Ajouter ces repères à la barre de mana", "Add these marks to the mana bar"))
            c:Toggle(T("Règle des cinq secondes", "Five-second rule"), "manaBar.fiveSecond", MBApply2)
            c:Toggle(T("Ticks de régénération", "Regeneration ticks"), "manaBar.ticks", MBApply2)
            c:Toggle(T("Coût du sort en cours", "Cost of the spell being cast"), "manaBar.costPrediction", MBApply2)
            c:Button(T("Tester l'affichage", "Test the display"), function() Call("TomoMod_ManaBar", "Test") end, 200,
                T("Lance l'étincelle des cinq secondes une fois.", "Runs the five-second spark once."))
            c:Info(T("Utilise la barre de puissance du cadre de joueur TMF, quand elle montre du mana.",
                     "Uses the TMF player frame power bar, when it shows mana."))
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- 1.3.6: Gathering and quest rewards
-- ---------------------------------------------------------------------
K.RegisterPage({
    key = "gathertips",
    section = SECTION,
    label = T("Récolte et récompenses", "Gathering and rewards"),
    kw = "herboristerie herbalism minage mining depecage skinning noeud node filon herbe competence skill recompense reward vente sell valeur value bourse",
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Récolte et récompenses", "Gathering and rewards"),
                T("Les infobulles des herbes, des filons et des bêtes à dépecer indiquent la compétence requise, colorée selon la tienne. Dans les récompenses de quête, une bourse marque l'objet qui se vend le plus cher.",
                  "Tooltips of herbs, veins and skinnable beasts show the skill required, coloured against yours. In quest rewards, a purse marks the item that sells for the most."))

            local c = page:Card(T("Récolte", "Gathering"))
            ModuleToggle(c, "gatherTips", T("Compétence requise dans les infobulles", "Required skill in tooltips"))
            c:Toggle(T("Aussi pour le dépeçage", "Also for skinning"), "gatherTips.skinning", nil)
            c:Done()

            local r = page:Card(T("Récompenses de quête", "Quest rewards"))
            ModuleToggle(r, "questReward", T("Marquer la récompense qui vaut le plus chez le marchand", "Mark the reward worth the most at a vendor"))
            r:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- 1.3.6: Fishing
-- ---------------------------------------------------------------------
local function FIApply() Call("TomoMod_Fishing", "ApplySettings") end

K.RegisterPage({
    key = "fishing",
    section = SECTION,
    label = T("Pêche", "Fishing"),
    kw = "peche fishing canne pole appat lure bouchon bobber lancer cast ramener reel double clic sons sound touche key raccourci binding",
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Pêche", "Fishing"),
                T("Une seule touche pour pêcher : elle équipe la canne si tu n'en tiens pas, pose un appât si la canne n'en a plus, puis lance. Quand ça mord, la même touche ramène la ligne.",
                  "One key to fish: it equips the pole when you hold none, applies a lure when the pole has none left, then casts. When it bites, the same key reels in."))

            local c = page:Card(T("Touche de pêche", "Fishing key"))
            ModuleToggle(c, "fishing", T("Activer les aides à la pêche", "Turn on the fishing helpers"))
            c:Toggle(T("Poser un appât automatiquement", "Apply a lure automatically"), "fishing.lure", FIApply)
            c:Toggle(T("Ramener avec la même touche", "Reel in with the same key"), "fishing.reelIn", FIApply)
            local keys = TomoMod_Fishing and TomoMod_Fishing.BoundKeys and TomoMod_Fishing.BoundKeys()
            c:Info(keys and (T("Touche actuelle : ", "Current key: ") .. keys)
                or T("Choisis la touche dans Options, Raccourcis, Addons, TomoMod Forever.",
                     "Pick the key in Options, Key Bindings, AddOns, TomoMod Forever."))
            c:Done()

            local o = page:Card(T("Confort", "Comfort"))
            o:Toggle(T("Double clic droit pour lancer (canne en main)", "Double right click to cast (pole in hand)"), "fishing.doubleClick", FIApply)
            o:Info(T("Ligne à l'eau, le double clic droit ramène. Pendant la pêche, le ciblage du jeu porte jusqu'au bouchon : une main apparaît dessus quand il est ciblé.",
                     "Line out, a double right click reels in. While fishing, the game's targeting reaches the bobber: a hand shows on it when it is targeted."))
            o:Toggle(T("Sons de pêche mis en avant", "Fishing sounds brought forward"), "fishing.sounds", FIApply)
            o:Info(T("Pendant la pêche, les effets sonores montent, la musique et l'ambiance se taisent. Tout revient 20 secondes après le dernier lancer. Rien ne se fait en combat.",
                     "While fishing, sound effects go up, music and ambience go quiet. Everything comes back 20 seconds after the last cast. Nothing happens in combat."))
            o:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- 1.3.6: World map markers
-- ---------------------------------------------------------------------
local function MMApply() Call("TomoMod_MapMarkers", "ApplySettings") end

K.RegisterPage({
    key = "mapmarkers",
    section = SECTION,
    label = T("Carte du monde", "World map"),
    kw = "carte map marqueur marker vol flight donjon dungeon instance entree entrance bateau boat zeppelin transport fondu fade transparence behind",
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Carte du monde", "World map"),
                T("Des marqueurs sur la carte : points de vol, entrées de donjons, bateaux et zeppelins. Survole pour le nom, clique pour poser un point de passage.",
                  "Markers on the map: flight points, dungeon entrances, boats and zeppelins. Hover for the name, click to set a waypoint."))

            local c = page:Card(T("Marqueurs", "Markers"))
            ModuleToggle(c, "mapMarkers", T("Afficher les marqueurs", "Show the markers"))
            c:Toggle(T("Points de vol", "Flight points"), "mapMarkers.flightPoints", MMApply)
            c:Toggle(T("Entrées de donjons", "Dungeon entrances"), "mapMarkers.dungeons", MMApply)
            c:Toggle(T("Bateaux et zeppelins", "Boats and zeppelins"), "mapMarkers.transports", MMApply)
            c:Info(T("Les entrées de donjons viennent du codex (/codex), tes corrections comprises.",
                     "Dungeon entrances come from the codex (/codex), your corrections included."))
            c:Done()

            local o = page:Card(T("Confort", "Comfort"))
            o:Toggle(T("Estomper la carte quand tu bouges", "Fade the map while moving"), "mapMarkers.mapFade", MMApply)
            o:Toggle(T("Voir le jeu derrière la carte agrandie", "See the game behind the maximized map"), "mapMarkers.behind", MMApply)
            o:Slider(T("Opacité du fond", "Backdrop opacity"), "mapMarkers.behindAlpha", 0, 1, 0.05, MMApply, "%.2f")
            o:Toggle(T("Les clics traversent le fond", "Clicks go through the backdrop"), "mapMarkers.clickThrough", MMApply)
            o:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- 1.3.7: Screen edge alerts
-- ---------------------------------------------------------------------
local function EAApply() Call("TomoMod_EdgeAlerts", "ApplySettings") end

K.RegisterPage({
    key = "edgealerts",
    section = SECTION,
    label = T("Alertes en bord d'écran", "Screen edge alerts"),
    kw = "alerte alert bord edge ecran screen vie health mana basse low rouge red bleu blue vignette",
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Alertes en bord d'écran", "Screen edge alerts"),
                T("Un liseré rouge pulse sur les bords de l'écran quand ta vie est basse, un liseré bleu quand ta mana passe sous son seuil. La vie passe avant la mana.",
                  "A red glow pulses along the screen edges when your health is low, a blue one when your mana drops under its threshold. Health comes before mana."))

            local c = page:Card(T("Activation", "On / off"))
            ModuleToggle(c, "edgeAlerts", T("Afficher les alertes en bord d'écran", "Show the screen edge alerts"))
            c:Done()

            local h = page:Card(T("Vie", "Health"))
            h:Toggle(T("Liseré rouge quand ta vie est basse", "Red glow when your health is low"), "edgeAlerts.health", EAApply)
            h:Slider(T("Seuil", "Threshold"), "edgeAlerts.healthPct", 10, 60, 1, EAApply, "%d %%")
            h:Toggle(T("En combat seulement", "In combat only"), "edgeAlerts.healthInCombat", EAApply)
            h:Button(T("Tester", "Test"), function() Call("TomoMod_EdgeAlerts", "Test", "health") end, 160)
            h:Done()

            local m = page:Card(T("Mana", "Mana"))
            m:Toggle(T("Liseré bleu quand ta mana est basse", "Blue glow when your mana is low"), "edgeAlerts.mana", EAApply)
            m:Slider(T("Seuil", "Threshold"), "edgeAlerts.manaPct", 5, 50, 1, EAApply, "%d %%")
            m:Toggle(T("En combat seulement", "In combat only"), "edgeAlerts.manaInCombat", EAApply,
                T("Sinon il s'allume chaque fois que tu bois.", "Otherwise it lights up every time you drink."))
            m:Button(T("Tester", "Test"), function() Call("TomoMod_EdgeAlerts", "Test", "mana") end, 160)
            m:Done()

            local l = page:Card(T("Apparence", "Look"))
            l:Slider(T("Profondeur", "Depth"), "edgeAlerts.size", 30, 200, 5, EAApply, "%d px")
            l:Slider(T("Intensité", "Intensity"), "edgeAlerts.intensity", 0.2, 1, 0.05, EAApply, "%.2f")
            l:Info(T("Le liseré pulse avec les animations complètes, il reste fixe sinon : c'est une alerte, il ne disparaît jamais.",
                     "The glow pulses with full animations and stays steady otherwise: it is an alert, it never goes away."))
            l:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- 1.3.9: Quest dialogue
-- ---------------------------------------------------------------------
local function DLApply()
    Call("TomoMod_Dialogue", "ApplySettings")
    Call("TomoMod_DialogueBook", "ApplySettings")
end

K.RegisterPage({
    key = "dialogue",
    section = SECTION,
    label = T("Dialogues de quête", "Quest dialogue"),
    kw = "dialogue quete quest pnj npc discussion gossip parchemin camera zoom interface cacher hide livre book lettre letter recompense reward",
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Dialogues de quête", "Quest dialogue"),
                T("Les discussions avec les PNJ et les quêtes s'ouvrent sur un parchemin TMF : le texte s'écrit pendant que tu lis, les choix sont numérotés, et Espace continue, accepte ou rend la quête. La caméra se rapproche du PNJ et l'interface s'efface le temps du dialogue.",
                  "NPC conversations and quests open on a TMF parchment: the text writes itself as you read, choices are numbered, and Space continues, accepts or turns in. The camera moves closer to the NPC and the interface fades for the length of the dialogue."))

            local c = page:Card(T("Activation", "On / off"))
            ModuleToggle(c, "dialogue", T("Remplacer les fenêtres de quête et de discussion", "Replace the quest and conversation windows"))
            c:Info(T("Touches : Espace pour continuer, 1 à 9 pour choisir, Échap pour refuser ou partir. Se met en retrait si Immersion ou DialogueUI est chargé.",
                     "Keys: Space to continue, 1 to 9 to choose, Escape to decline or leave. Steps aside when Immersion or DialogueUI is loaded."))
            c:Done()

            local t = page:Card(T("Panneau", "Panel"))
            t:Seg(T("Position", "Position"), "dialogue.side", {
                { text = T("À droite", "Right"), value = "right" },
                { text = T("Au centre", "Center"), value = "center" },
            }, DLApply, 2)
            t:Slider(T("Taille", "Size"), "dialogue.scale", 0.8, 1.3, 0.05, DLApply, "%.2f")
            t:Slider(T("Taille du texte", "Text size"), "dialogue.fontSize", 12, 18, 1, DLApply)
            t:Toggle(T("Le texte s'écrit progressivement", "Text writes itself out"), "dialogue.typewriter", DLApply)
            t:Slider(T("Vitesse d'écriture", "Writing speed"), "dialogue.typeSpeed", 30, 160, 5, DLApply, "%d")
            t:Toggle(T("Récompenses détaillées", "Detailed rewards"), "dialogue.rewardsDetail", DLApply,
                T("Couleur de qualité, flèche verte si c'est mieux que ton équipement, bourse sur le choix qui se vend le plus cher.",
                  "Quality colour, green arrow when better than your gear, purse on the choice that sells for the most."))
            t:Done()

            local s = page:Card(T("Mise en scène", "Scene"))
            s:Toggle(T("Caméra sur le PNJ", "Camera on the NPC"), "dialogue.camera", DLApply)
            s:Slider(T("Distance de la caméra", "Camera distance"), "dialogue.cameraZoom", 2, 8, 0.5, DLApply, "%.1f")
            s:Slider(T("Décalage sur le côté", "Side offset"), "dialogue.cameraShift", 0, 2.5, 0.1, DLApply, "%.1f")
            s:Toggle(T("Aussi en donjon", "Also in dungeons"), "dialogue.cameraInInstance", DLApply)
            s:Toggle(T("Masquer l'interface", "Hide the interface"), "dialogue.hideUI", DLApply,
                T("Elle revient tout de suite si un combat commence.", "It comes back at once if a fight starts."))
            s:Toggle(T("Bandes de cinéma", "Cinema bars"), "dialogue.letterbox", DLApply)
            s:Info(T("Ta caméra (distance, décalage) revient comme elle était à la fin du dialogue.",
                     "Your camera (distance, offset) goes back as it was when the dialogue ends."))
            s:Done()

            local b = page:Card(T("Livres et lettres", "Books and letters"))
            b:Toggle(T("Ouvrir livres, lettres et plaques dans un livre TMF", "Open books, letters and plaques in a TMF book"), "dialogue.books", DLApply)
            b:Toggle(T("Assombrir l'écran derrière", "Darken the screen behind"), "dialogue.bookDim", DLApply)
            b:Done()
        end)
    end,
})
