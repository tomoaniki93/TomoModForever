-- =====================================================================
-- Panels/Groups.lua -- "Groupe" : party and raid frames
-- Replaces the Party & Raid Studio. While a page is open and the player
-- is not grouped, stand-in frames are drawn where the real ones go and
-- follow every slider live.
-- =====================================================================

local K = TomoMod_Kit
local T = K.T

local SECTION = "group"

local HEALTH_COLORS = {
    { text = T("Classe", "Class"),     value = "class" },
    { text = T("Vert", "Green"),       value = "green" },
    { text = T("Dégradé", "Gradient"), value = "gradient" },
}

local GROW = {
    { text = T("Vers le bas", "Down"),     value = "DOWN" },
    { text = T("Vers le haut", "Up"),      value = "UP" },
    { text = T("Vers la droite", "Right"), value = "RIGHT" },
    { text = T("Vers la gauche", "Left"),  value = "LEFT" },
}

local function ModuleToggle(c, key, label, apply)
    c:Toggle(label, {
        get = function() return K.IsModuleOn(key) end,
        set = function(v) K.SetModule(key, v) end,
    }, apply)
end

-- Shared between party and raid: both modules use the same field names.
local function CommonCards(page, root, ap)
    local p = root .. "."

    local c = page:Card(T("Vie", "Health"))
    c:Seg(T("Couleur de la barre", "Bar colour"), p .. "healthColor", HEALTH_COLORS, ap, 3)
    c:Select(T("Texture", "Texture"), p .. "texture", K.TEXTURES, ap)
    c:Pair(function(l) l:Toggle(T("Vie en texte", "Health text"), p .. "showHealthText", ap) end,
           function(r) r:Select(T("Format", "Format"), p .. "healthTextFormat", {
                { text = T("Pourcentage", "Percent"), value = "percent" },
                { text = T("Valeur", "Current"), value = "current" },
                { text = T("Valeur + %", "Current + %"), value = "current_percent" },
                { text = T("Manquant", "Deficit"), value = "deficit" },
            }, ap) end)
    c:Pair(function(l) l:Toggle(T("Boucliers", "Shields"), p .. "showAbsorb", ap) end,
           function(r) r:Toggle(T("Soins entrants", "Incoming heals"), p .. "showHealPrediction", ap) end)
    c:Pair(function(l) l:Toggle(T("Barre de mana", "Mana bar"), p .. "showPower", ap) end,
           function(r) r:Slider(T("Hauteur mana", "Mana height"), p .. "powerHeight", 1, 10, 1, ap) end)
    c:Done()

    c = page:Card(T("Nom et icônes", "Name and icons"))
    c:Pair(function(l) l:Toggle(T("Nom", "Name"), p .. "showName", ap) end,
           function(r) r:Slider(T("Lettres max (0 = tout)", "Max letters (0 = all)"), p .. "nameMaxLength", 0, 20, 1, ap) end)
    c:Pair(function(l) l:Toggle(T("Icône de rôle", "Role icon"), p .. "showRoleIcon", ap) end,
           function(r) r:Toggle(T("Marque de raid", "Raid marker"), p .. "showRaidMarker", ap) end)
    c:Select(T("Police", "Font"), p .. "font", K.FONTS, ap)
    c:Slider(T("Taille du texte", "Text size"), p .. "fontSize", 7, 18, 1, ap)
    c:Done()

    c = page:Card(T("Soins et dissipation", "Healing and dispels"))
    c:Toggle(T("Alerte de débuff à dissiper (contour + icône)", "Dispellable debuff alert (outline + icon)"), p .. "showDispel", ap)
    c:Pair(function(l) l:Toggle(T("Mes soins sur la durée", "My heals over time"), p .. "showHoTs", ap) end,
           function(r) r:Slider(T("Nombre max", "Max count"), p .. "maxHoTs", 1, 6, 1, ap) end)
    c:Pair(function(l) l:Toggle(T("Défensifs reçus", "External defensives"), p .. "showDefensives", ap) end,
           function(r) r:Toggle(T("Résurrection en cours", "Incoming resurrection"), p .. "showResurrectIndicator", ap) end)
    c:Done()

    c = page:Card(T("Portée", "Range"))
    c:Toggle(T("Assombrir les membres hors de portée", "Fade out-of-range members"), p .. "showRange", ap)
    c:Slider(T("Opacité hors de portée", "Out of range opacity"), p .. "oorAlpha", 0.1, 1, 0.05, ap, "%.2f")
    c:Done()

    c = page:Card(T("Tailles des icônes", "Icon sizes"), { adv = true })
    c:Pair(function(l) l:Slider(T("Soins sur la durée", "Heals over time"), p .. "hotSize", 6, 30, 1, ap) end,
           function(r) r:Slider(T("Dissipation", "Dispel"), p .. "dispelSize", 8, 40, 1, ap) end)
    c:Pair(function(l) l:Slider(T("Défensifs", "Defensives"), p .. "defensiveIconSize", 8, 30, 1, ap) end,
           function(r) r:Slider(T("Rôle", "Role"), p .. "roleIconSize", 8, 30, 1, ap) end)
    c:Pair(function(l) l:Slider(T("Épaisseur du contour", "Outline thickness"), p .. "dispelBorderSize", 1, 6, 1, ap) end,
           function(r) r:Toggle(T("Durée sur les soins", "Duration on heals"), p .. "hotShowDuration", ap) end)
    c:Done()
end

-- ---------------------------------------------------------------------
-- Party
-- ---------------------------------------------------------------------
K.RegisterPage({
    key = "party",
    section = SECTION,
    label = T("Groupe (5)", "Party (5)"),
    kw = "party group groupe frames cadres donjon dungeon healer soigneur",
    locate = "TomoMod_PartyAnchor",
    onShow = function() K.PartyPreview(true) end,
    onHide = function() K.PartyPreview(false) end,
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Cadres de groupe", "Party frames"),
                T("Hors groupe, un aperçu de 5 membres s'affiche à l'emplacement réel pendant que tu règles.",
                  "Outside a group, a 5-member preview is drawn at the real spot while you tune it."),
                function() return _G.TomoMod_PartyAnchor end, T("Groupe", "Party"))

            local c = page:Card(T("Activation", "On / off"))
            ModuleToggle(c, "partyFrames", T("Utiliser les cadres de groupe TomoMod", "Use TomoMod party frames"), "party")
            c:Toggle(T("Trier par rôle (tank, soigneur, dégâts)", "Sort by role (tank, healer, damage)"), "partyFrames.sortByRole", "party")
            c:Done()

            c = page:Card(T("Taille et disposition", "Size and layout"))
            c:Pair(function(l) l:Slider(T("Largeur", "Width"), "partyFrames.width", 60, 300, 1, "party") end,
                   function(r) r:Slider(T("Hauteur", "Height"), "partyFrames.height", 16, 100, 1, "party") end)
            c:Slider(T("Espace entre les membres", "Space between members"), "partyFrames.spacing", 0, 30, 1, "party")
            c:Seg(T("Direction", "Direction"), "partyFrames.growDirection", GROW, "party", 4)
            c:Done()

            CommonCards(page, "partyFrames", "party")

            c = page:Card(T("Mythique+ et JcJ", "Mythic+ and PvP"), { adv = true })
            c:Pair(function(l) l:Toggle(T("Recharge d'interruption", "Interrupt cooldown"), "partyFrames.showInterruptCD", "party") end,
                   function(r) r:Toggle(T("Recharge de résurrection", "Battle-rez cooldown"), "partyFrames.showBrezCD", "party") end)
            c:Toggle(T("Cadres d'arène ennemis", "Enemy arena frames"), "partyFrames.arena.enabled", K.NeedReload)
            c:Done()
        end)
    end,
})

-- ---------------------------------------------------------------------
-- Raid
-- ---------------------------------------------------------------------
K.RegisterPage({
    key = "raid",
    section = SECTION,
    label = T("Raid", "Raid"),
    kw = "raid frames cadres raid grille grid healer soigneur",
    locate = "TomoMod_RaidAnchor",
    onShow = function() K.RaidPreview(true) end,
    onHide = function() K.RaidPreview(false) end,
    build = function(parent)
        return K.Page(parent, function(page)
            page:Hero(T("Cadres de raid", "Raid frames"),
                T("Hors raid, une grille de 20 membres s'affiche pour régler la taille et l'espacement.",
                  "Outside a raid, a 20-member grid is drawn so you can tune size and spacing."),
                function() return _G.TomoMod_RaidAnchor end, T("Raid", "Raid"))

            local c = page:Card(T("Activation", "On / off"))
            ModuleToggle(c, "raidFrames", T("Utiliser les cadres de raid TomoMod", "Use TomoMod raid frames"), "raid")
            c:Toggle(T("Trier par rôle", "Sort by role"), "raidFrames.sortByRole", "raid")
            c:Done()

            c = page:Card(T("Taille et disposition", "Size and layout"))
            c:Seg(T("Disposition", "Layout"), "raidFrames.layout", {
                { text = T("Grille", "Grid"), value = "grid" },
                { text = T("Liste", "List"), value = "list" },
            }, "raid", 2)
            c:Pair(function(l) l:Slider(T("Largeur", "Width"), "raidFrames.width", 30, 200, 1, "raid") end,
                   function(r) r:Slider(T("Hauteur", "Height"), "raidFrames.height", 14, 80, 1, "raid") end)
            c:Pair(function(l) l:Slider(T("Espace", "Spacing"), "raidFrames.spacing", 0, 20, 1, "raid") end,
                   function(r) r:Slider(T("Espace entre groupes", "Group spacing"), "raidFrames.groupSpacing", 0, 30, 1, "raid") end)
            c:Done()

            CommonCards(page, "raidFrames", "raid")

            c = page:Card(T("Débuffs", "Debuffs"))
            c:Toggle(T("Afficher les débuffs", "Show debuffs"), "raidFrames.showDebuffs", "raid")
            c:Pair(function(l) l:Slider(T("Nombre", "Count"), "raidFrames.maxDebuffs", 1, 6, 1, "raid") end,
                   function(r) r:Slider(T("Taille", "Size"), "raidFrames.debuffSize", 8, 30, 1, "raid") end)
            c:Done()

            c = page:Card(T("Taille selon le raid (10 / 25 / 40)", "Size by raid size (10 / 25 / 40)"), { adv = true })
            c:Toggle(T("Adapter la taille au nombre de joueurs", "Adapt size to player count"), "raidFrames.raidSizeOverrides.enabled", "raid")
            for _, n in ipairs({ "10", "25", "40" }) do
                local p = "raidFrames.raidSizeOverrides." .. n .. "."
                c:Label(n .. T(" joueurs", " players"))
                c:Pair(function(l) l:Slider(T("Largeur", "Width"), p .. "width", 30, 200, 1, "raid") end,
                       function(r) r:Slider(T("Hauteur", "Height"), p .. "height", 14, 80, 1, "raid") end)
            end
            c:Done()

            c = page:Card(T("Compteur de résurrections de combat", "Battle-rez counter"), { adv = true })
            c:Toggle(T("Afficher", "Show"), "battleRez.enabled", "rez")
            c:Toggle(T("Seulement en instance", "Instances only"), "battleRez.onlyInstance", "rez")
            c:Slider(T("Taille", "Size"), "battleRez.size", 24, 80, 1, "rez")
            c:Done()

            c = page:Card(T("Habillage du gestionnaire de groupe", "Group manager skin"), { adv = true })
            c:Toggle(T("Habiller le gestionnaire de raid Blizzard", "Skin Blizzard's raid manager"), "raidFrames.skinGroupManager", function()
                local GM = TomoMod_GroupManagerSkin
                if GM and GM.ApplySettings then GM.ApplySettings() end
            end)
            c:Done()
        end)
    end,
})
