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
