-- =====================================================================
-- Modules/QOL/Forever/DungeonCodexData.lua -- the dungeons of WoW: Forever
--
-- 35 dungeons over 28 instances, levels 13 to 60: the 20 original
-- instances (with their wings) and the 9 new Forever ones, and (1.4.1)
-- 8 raids: the 6 Classic ones and Forever's Hyjal Summit and Barrow Deeps.
-- Level ranges are the live Forever ranges (Warcraft Tavern / Icy Veins,
-- Nov 2026; the Stockade from the game's group finder), not the old
-- Classic ones.
--
-- Entrance positions. `pos` is { x, y } in 0-100 map coordinates on the
-- zone `zone`. `src` says how much to trust it:
--   "guide"  -- coordinates published by Forever guides
--   "approx" -- the Classic position of the entrance, or a close guess
--   nil pos  -- unknown yet: the codex offers the zone map but no point
-- [1.4.1] D.game (end of file): the entrances from the game's own tables.
-- The codex prefers them to "approx" positions and to unknown ones; a
-- "guide" position, or `usePos = true` (the point is the way in, not the
-- portal: Blackrock Mountain, Stratholme's two gates), keeps its `pos`.
-- /codex compare prints, in game, the gap between `pos` and the game.
-- Any position can be replaced in game: stand on the entrance and type
-- `/codex set <key>`. The override wins and is printed as a ready-to-
-- paste line for this file.
--
-- Zones carry the Classic uiMapID (1411-1458 family, the vanilla
-- geometry) and their English / French names. If the ID does not match
-- on this client, the codex looks the zone up by name instead.
-- =====================================================================

TomoMod_DungeonCodexData = TomoMod_DungeonCodexData or {}
local D = TomoMod_DungeonCodexData

-- ---------------------------------------------------------------------
-- Zones
-- ---------------------------------------------------------------------
D.zones = {
    orgrimmar      = { id = 1454, en = "Orgrimmar",            fr = "Orgrimmar" },
    ironforge      = { id = 1455, en = "Ironforge",            fr = "Forgefer" },
    stormwind      = { id = 1453, en = "Stormwind City",       fr = "Hurlevent" },
    barrens        = { id = 1413, en = "The Barrens",          fr = "Les Tarides" },
    westfall       = { id = 1436, en = "Westfall",             fr = "Marche de l'Ouest" },
    silverpine     = { id = 1421, en = "Silverpine Forest",    fr = "Forêt des Pins-Argentés" },
    ashenvale      = { id = 1440, en = "Ashenvale",            fr = "Orneval" },
    wetlands       = { id = 1437, en = "Wetlands",             fr = "Les Paluns" },
    alterac        = { id = 1416, en = "Alterac Mountains",    fr = "Montagnes d'Alterac" },
    dunmorogh      = { id = 1426, en = "Dun Morogh",           fr = "Dun Morogh" },
    tirisfal       = { id = 1420, en = "Tirisfal Glades",      fr = "Clairières de Tirisfal" },
    stranglethorn  = { id = 1434, en = "Stranglethorn Vale",   fr = "Vallée de Strangleronce" },
    riverglades    = { id = 2548, en = "Riverglades",          fr = "Riverglades" },
    badlands       = { id = 1418, en = "Badlands",             fr = "Terres ingrates" },
    tanaris        = { id = 1446, en = "Tanaris",              fr = "Tanaris" },
    desolace       = { id = 1443, en = "Desolace",             fr = "Désolace" },
    dustwallow     = { id = 1445, en = "Dustwallow Marsh",     fr = "Marécage d'Âprefange" },
    swamp          = { id = 1435, en = "Swamp of Sorrows",     fr = "Marais des Chagrins" },
    burningsteppes = { id = 1428, en = "Burning Steppes",      fr = "Steppes ardentes" },
    feralas        = { id = 1444, en = "Feralas",              fr = "Féralas" },
    azshara        = { id = 1447, en = "Azshara",              fr = "Azshara" },
    ungoro         = { id = 1449, en = "Un'Goro Crater",       fr = "Cratère d'Un'Goro" },
    epl            = { id = 1423, en = "Eastern Plaguelands",  fr = "Maleterres de l'Est" },
    wpl            = { id = 1422, en = "Western Plaguelands",  fr = "Maleterres de l'Ouest" },
    silithus       = { id = 1451, en = "Silithus",             fr = "Silithus" },
    hyjal          = { id = 2482, en = "Mount Hyjal",          fr = "Mont Hyjal" },
}

-- ---------------------------------------------------------------------
-- Routes shared by several wings
-- ---------------------------------------------------------------------
local R_SM = {
    H = {
        fr = { "Fossoyeuse : maître de vol, ou à cheval vers l'est dans les Clairières de Tirisfal.",
               "Tout au nord-est de Tirisfal, le Monastère écarlate : les quatre ailes ont leur porte dans la même cour." },
        en = { "Undercity: flight master, or ride east through Tirisfal Glades.",
               "In the far north-east of Tirisfal lies the Scarlet Monastery: all four wings open on the same courtyard." },
    },
    A = {
        fr = { "Austrivage (Hillsbrad) : monte au nord par les Montagnes d'Alterac puis les Maleterres de l'Ouest.",
               "Entre dans Tirisfal par l'est : le Monastère écarlate est au nord-est, les quatre ailes dans la même cour." },
        en = { "Southshore (Hillsbrad): head north through Alterac Mountains, then Western Plaguelands.",
               "Enter Tirisfal from the east: the Scarlet Monastery is in the north-east, all four wings in one courtyard." },
    },
}

local R_BRM = {
    H = {
        fr = { "Maître de vol de Kargath (Terres ingrates) ou de Flame Crest (Steppes ardentes).",
               "Entre dans le mont Rochenoire : les Profondeurs sont en bas (par la chaîne), le Pic Rochenoire en haut." },
        en = { "Kargath (Badlands) or Flame Crest (Burning Steppes) flight master.",
               "Enter Blackrock Mountain: the Depths are at the bottom (down the chain), the Spire at the top." },
    },
    A = {
        fr = { "Maître de vol de Morgan's Vigil (Steppes ardentes) ou de Thorium Point (Gorge des Vents brûlants).",
               "Entre dans le mont Rochenoire : les Profondeurs sont en bas (par la chaîne), le Pic Rochenoire en haut." },
        en = { "Morgan's Vigil (Burning Steppes) or Thorium Point (Searing Gorge) flight master.",
               "Enter Blackrock Mountain: the Depths are at the bottom (down the chain), the Spire at the top." },
    },
}

local R_DM = {
    H = {
        fr = { "Camp Mojache (Féralas) : maître de vol.",
               "À l'ouest du camp, la cité en ruines de Hache-Tripes : chaque aile a son entrée dans la cité." },
        en = { "Camp Mojache (Feralas): flight master.",
               "West of the camp lies the ruined city of Dire Maul: each wing has its own entrance." },
    },
    A = {
        fr = { "Bastion de Plumelune (île à l'ouest de Féralas) : bateau vers la côte, puis à l'est.",
               "Au centre de Féralas, la cité en ruines de Hache-Tripes : chaque aile a son entrée dans la cité." },
        en = { "Feathermoon Stronghold (island off western Feralas): boat to the shore, then head east.",
               "In central Feralas lies the ruined city of Dire Maul: each wing has its own entrance." },
    },
}

local R_STRAT = {
    both = {
        fr = { "Chapelle de l'Espoir-de-Lumière (Maleterres de l'Est) : maître de vol des deux factions.",
               "Au nord-ouest de la zone, la cité de Stratholme." },
        en = { "Light's Hope Chapel (Eastern Plaguelands): flight master for both factions.",
               "In the north-west of the zone lies the city of Stratholme." },
    },
}

-- ---------------------------------------------------------------------
-- Dungeons, by entry level
-- ---------------------------------------------------------------------
-- key, names, min, max, zone, pos, src, new (Forever), faction hint,
-- note, routes { H, A } or { both }.
D.dungeons = {
    {
        key = "rfc", en = "Ragefire Chasm", fr = "Gouffre de Ragefeu",
        min = 13, max = 18, zone = "orgrimmar", pos = { 52.0, 49.6 }, src = "approx", side = "H",
        routes = {
            H = { fr = { "Dans Orgrimmar, va à la Faille de l'Ombre (accès depuis la vallée de la Force).",
                         "L'entrée du gouffre est au fond de la faille." },
                  en = { "In Orgrimmar, go to the Cleft of Shadow (reached from the Valley of Strength).",
                         "The chasm entrance is at the far end of the cleft." } },
            A = { fr = { "Ville horde : bateau Menethil → Theramore, puis rejoins Durotar et Orgrimmar.",
                         "Entrée dans la Faille de l'Ombre, en ville hostile : viens en groupe." },
                  en = { "Horde city: boat Menethil → Theramore, then make your way to Durotar and Orgrimmar.",
                         "Entrance in the Cleft of Shadow, in a hostile city: come as a group." } },
        },
    },
    {
        key = "hot", en = "Hall of Thanes", fr = "Salle des Thanes",
        min = 13, max = 20, zone = "ironforge", pos = { 43.5, 52.0 }, src = "guide", new = true, side = "A",
        routes = {
            A = { fr = { "Forgefer : traverse la Grande Forge jusqu'à la salle du trône (Haut-Siège).",
                         "Prends le couloir de gauche et descends dans le Vieux Forgefer : l'entrée est tout en bas." },
                  en = { "Ironforge: cross the Great Forge to the throne room (the High Seat).",
                         "Take the left corridor down into Old Ironforge: the entrance is at the very bottom." } },
            H = { fr = { "Ville alliée : depuis les Paluns, remonte par le Loch Modan et Dun Morogh jusqu'à Forgefer.",
                         "Salle du trône, couloir de gauche, tout en bas du Vieux Forgefer (ville hostile)." },
                  en = { "Alliance city: from the Wetlands, go up through Loch Modan and Dun Morogh to Ironforge.",
                         "Throne room, left corridor, at the bottom of Old Ironforge (hostile city)." } },
        },
    },
    {
        key = "rol", en = "Ruins of Lordaeron", fr = "Ruines de Lordaeron",
        min = 15, max = 22, zone = "tirisfal", pos = { 62.4, 65.6 }, src = "approx", new = true, side = "H",
        routes = {
            H = { fr = { "Fossoyeuse : remonte à la surface par l'ascenseur, dans les Ruines de Lordaeron.",
                         "Passe la grande porte : l'entrée est sur la gauche, en haut des escaliers, côté est de la cour." },
                  en = { "Undercity: take the lift up to the Ruins of Lordaeron.",
                         "Through the front gate: the entrance is on the left, up the stairs, east side of the courtyard." } },
            A = { fr = { "Depuis Austrivage, passe par Hillsbrad et la forêt des Pins-Argentés jusqu'à Tirisfal (territoire horde).",
                         "Ruines au-dessus de Fossoyeuse : après la grande porte, à gauche en haut des escaliers." },
                  en = { "From Southshore, go through Hillsbrad and Silverpine Forest to Tirisfal (Horde land).",
                         "Ruins above Undercity: past the front gate, on the left up the stairs." } },
        },
    },
    {
        key = "wc", en = "Wailing Caverns", fr = "Cavernes des Lamentations",
        min = 15, max = 24, zone = "barrens", pos = { 46.0, 36.4 }, src = "approx",
        routes = {
            H = { fr = { "Orgrimmar : sors par la porte ouest et suis la route jusqu'à la Croisée (maître de vol).",
                         "Au sud-ouest de la Croisée, au-dessus de l'oasis : grotte en forme de gueule dans la falaise." },
                  en = { "Orgrimmar: leave by the west gate and follow the road to the Crossroads (flight master).",
                         "South-west of the Crossroads, above the oasis: a maw-shaped cave in the cliff." } },
            A = { fr = { "Bateau Menethil → Theramore, puis à l'ouest vers les Tarides (ou Baie-du-Butin → Cabestan).",
                         "Au sud-ouest de la Croisée, au-dessus de l'oasis : grotte en forme de gueule dans la falaise." },
                  en = { "Boat Menethil → Theramore, then west into the Barrens (or Booty Bay → Ratchet).",
                         "South-west of the Crossroads, above the oasis: a maw-shaped cave in the cliff." } },
        },
    },
    {
        key = "vc", en = "The Deadmines", fr = "Les Mortemines",
        min = 17, max = 26, zone = "westfall", pos = { 42.6, 72.0 }, src = "approx", side = "A",
        routes = {
            A = { fr = { "Hurlevent → Marche de l'Ouest ; maître de vol à Sentinelle.",
                         "Plein sud jusqu'à Ruisselune : entrée dans la maison des Défias, puis la mine." },
                  en = { "Stormwind → Westfall; flight master at Sentinel Hill.",
                         "Due south to Moonbrook: enter the Defias house, then the mine." } },
            H = { fr = { "Zeppelin Orgrimmar → Grom'gol, puis au nord par Strangleronce et le Bois de la Pénombre.",
                         "Au sud de la Marche de l'Ouest, à Ruisselune : maison des Défias puis la mine." },
                  en = { "Zeppelin Orgrimmar → Grom'gol, then north through Stranglethorn and Duskwood.",
                         "In southern Westfall, at Moonbrook: the Defias house, then the mine." } },
        },
    },
    {
        key = "sfk", en = "Shadowfang Keep", fr = "Donjon d'Ombrecroc",
        min = 20, max = 30, zone = "silverpine", pos = { 44.8, 67.8 }, src = "approx", side = "H",
        routes = {
            H = { fr = { "Fossoyeuse → forêt des Pins-Argentés par la route du sud ; maître de vol au Sépulcre.",
                         "Continue au sud : le donjon domine la route, au sud du Sépulcre." },
                  en = { "Undercity → Silverpine Forest by the south road; flight master at The Sepulcher.",
                         "Keep going south: the keep overlooks the road, south of The Sepulcher." } },
            A = { fr = { "Depuis les Paluns, traverse Arathi et Hillsbrad, puis l'ouest vers les Pins-Argentés.",
                         "Le donjon est au sud du Sépulcre, au-dessus de la route (territoire horde)." },
                  en = { "From the Wetlands, cross Arathi and Hillsbrad, then west into Silverpine.",
                         "The keep is south of The Sepulcher, above the road (Horde land)." } },
        },
    },
    {
        key = "bfd", en = "Blackfathom Deeps", fr = "Profondeurs de Brassenoire",
        min = 24, max = 32, zone = "ashenvale", pos = { 14.2, 14.0 }, src = "approx",
        routes = {
            A = { fr = { "Auberdine (Sombrivage) : longe la côte vers le sud jusqu'à l'Orneval.",
                         "Côte nord-ouest de l'Orneval : temple en ruines dans l'eau, entrée sous l'eau." },
                  en = { "Auberdine (Darkshore): follow the coast south into Ashenvale.",
                         "North-west coast of Ashenvale: a ruined temple in the water, entrance underwater." } },
            H = { fr = { "De la Croisée, monte au nord vers l'Orneval, puis à l'ouest jusqu'à Zoram'gar.",
                         "Le temple est sur la côte, au nord de Zoram'gar : entrée sous l'eau." },
                  en = { "From the Crossroads, go north into Ashenvale, then west to Zoram'gar Outpost.",
                         "The temple is on the coast, north of Zoram'gar: entrance underwater." } },
        },
    },
    {
        key = "stocks", en = "The Stockade", fr = "La Prison",
        min = 24, max = 32, zone = "stormwind", pos = { 50.8, 66.9 }, src = "guide", side = "A",   -- [1.4.0] entrance checked in game; [1.4.1] levels from the game's group finder
        routes = {
            A = { fr = { "Dans Hurlevent : la prison est au bord d'un canal, côté quartier des Mages.",
                         "Suis le waypoint : la porte est gardée, au pied d'un pont." },
                  en = { "In Stormwind: the prison sits by a canal, on the Mage Quarter side.",
                         "Follow the waypoint: the gate is guarded, at the foot of a bridge." } },
            H = { fr = { "Ville alliée : à éviter sans groupe solide.",
                         "Entrée dans Hurlevent, au bord d'un canal côté quartier des Mages." },
                  en = { "Alliance city: avoid without a strong group.",
                         "Entrance inside Stormwind, by a canal on the Mage Quarter side." } },
        },
    },
    {
        key = "exc", en = "Excavation Site: Wetlands", fr = "Site de fouilles : Les Paluns",
        min = 26, max = 33, zone = "wetlands", pos = { 53.9, 65.4 }, src = "guide", new = true,
        note = { fr = "Le point marque le début du sentier, à gauche du rocher de Thelgen.",
                 en = "The point marks the start of the path, left of Thelgen Rock." },
        routes = {
            A = { fr = { "Port de Menethil (Paluns) : maître de vol, puis la route vers l'est.",
                         "Au rocher de Thelgen, prends le sentier sur sa gauche (vers Dun Algaz) et grimpe jusqu'à l'entrée." },
                  en = { "Menethil Harbor (Wetlands): flight master, then the road east.",
                         "At Thelgen Rock, take the path on its left (towards Dun Algaz) and climb to the entrance." } },
            H = { fr = { "Hammerfall (Hautes-terres d'Arathi) : descends au sud par le pont de Thandol dans les Paluns.",
                         "Au rocher de Thelgen, prends le sentier sur sa gauche (vers Dun Algaz) et grimpe jusqu'à l'entrée." },
                  en = { "Hammerfall (Arathi Highlands): go south over Thandol Span into the Wetlands.",
                         "At Thelgen Rock, take the path on its left (towards Dun Algaz) and climb to the entrance." } },
        },
    },
    {
        key = "dal", en = "City of Dalaran", fr = "Cité de Dalaran",
        min = 28, max = 35, zone = "alterac", pos = { 8.8, 59.6 }, src = "guide", new = true,
        note = { fr = "Clé des égouts de Dalaran nécessaire (quête « Heart of Disruption »).",
                 en = "Needs the Dalaran Sewer Key (quest \"Heart of Disruption\")." },
        routes = {
            H = { fr = { "Moulin-de-Tarren (Hillsbrad) : chaîne d'accès qui donne la clé des égouts.",
                         "Rejoins le lac Lordamere : l'entrée des égouts est hors des murs, au nord-ouest de Dalaran." },
                  en = { "Tarren Mill (Hillsbrad): attunement chain that gives the sewer key.",
                         "Reach Lordamere Lake: the sewer entrance is outside the walls, north-west of Dalaran." } },
            A = { fr = { "Austrivage (Hillsbrad) : chaîne d'accès auprès de l'émissaire Jacques.",
                         "Monte au nord vers Dalaran : l'entrée des égouts est hors des murs, au nord-ouest." },
                  en = { "Southshore (Hillsbrad): attunement chain from Emissary Jacques.",
                         "Head north to Dalaran: the sewer entrance is outside the walls, to the north-west." } },
        },
    },
    {
        key = "rfk", en = "Razorfen Kraul", fr = "Kraal de Tranchebauge",
        min = 29, max = 38, zone = "barrens", pos = { 42.3, 89.9 }, src = "approx",
        routes = {
            both = { fr = { "La Croisée (Tarides) : prends la route du sud vers les Mille Pointes.",
                            "Juste avant la frontière, à l'ouest de la route : entrée dans les ronces de Tranchebauge." },
                     en = { "The Crossroads (Barrens): take the road south towards Thousand Needles.",
                            "Just before the border, west of the road: the entrance among the Razorfen brambles." } },
        },
    },
    {
        key = "gnomer", en = "Gnomeregan", fr = "Gnomeregan",
        min = 29, max = 38, zone = "dunmorogh", pos = { 24.3, 39.8 }, src = "approx", side = "A",
        routes = {
            A = { fr = { "Forgefer : sors de la ville et pars vers l'ouest dans Dun Morogh.",
                         "Au nord-ouest, suis la route vers la zone irradiée : entrée par la porte de Gnomeregan." },
                  en = { "Ironforge: leave the city and head west across Dun Morogh.",
                         "In the north-west, follow the road to the irradiated area: enter by Gnomeregan's gate." } },
            H = { fr = { "Depuis les Paluns, traverse le Loch Modan puis Dun Morogh (zone alliée).",
                         "Entrée au nord-ouest de Dun Morogh, après Kharanos." },
                  en = { "From the Wetlands, cross Loch Modan, then Dun Morogh (Alliance land).",
                         "Entrance in north-west Dun Morogh, past Kharanos." } },
        },
    },
    { key = "smgy",  en = "Scarlet Monastery: Graveyard", fr = "Monastère écarlate : Cimetière",
      min = 30, max = 38, zone = "tirisfal", pos = { 82.6, 33.4 }, src = "approx", routes = R_SM },
    { key = "smlib", en = "Scarlet Monastery: Library",   fr = "Monastère écarlate : Bibliothèque",
      min = 33, max = 41, zone = "tirisfal", pos = { 82.6, 33.4 }, src = "approx", routes = R_SM },
    {
        key = "drowned", en = "The Drowned City", fr = "La Cité engloutie",
        min = 35, max = 42, zone = "stranglethorn", pos = { 21.4, 27.9 }, src = "guide", new = true,
        note = { fr = "Entrée sous l'eau : prévois de quoi respirer.", en = "Underwater entrance: bring water breathing." },
        routes = {
            H = { fr = { "Zeppelin Orgrimmar → Grom'gol (Strangleronce).",
                         "Plein ouest depuis Grom'gol jusqu'à la côte : l'entrée est sous l'eau, au large." },
                  en = { "Zeppelin Orgrimmar → Grom'gol (Stranglethorn Vale).",
                         "Due west from Grom'gol to the coast: the entrance is underwater, offshore." } },
            A = { fr = { "Maître de vol du camp Rebelle (nord de Strangleronce), puis au sud-ouest vers la côte.",
                         "À l'ouest de Grom'gol (camp horde) : l'entrée est sous l'eau, au large." },
                  en = { "Rebel Camp flight master (northern Stranglethorn), then south-west to the coast.",
                         "West of Grom'gol (Horde camp): the entrance is underwater, offshore." } },
        },
    },
    { key = "smarm", en = "Scarlet Monastery: Armory",    fr = "Monastère écarlate : Armurerie",
      min = 36, max = 44, zone = "tirisfal", pos = { 82.6, 33.4 }, src = "approx", routes = R_SM },
    {
        key = "rfd", en = "Razorfen Downs", fr = "Souilles de Tranchebauge",
        min = 37, max = 46, zone = "barrens", pos = { 49.0, 92.8 }, src = "approx",
        routes = {
            both = { fr = { "La Croisée (Tarides) : route du sud jusqu'à la frontière des Mille Pointes.",
                            "Tout au sud des Tarides, à l'est du Kraal : grand tertre de ronces." },
                     en = { "The Crossroads (Barrens): road south to the Thousand Needles border.",
                            "At the very south of the Barrens, east of the Kraul: a great bramble mound." } },
        },
    },
    { key = "smcath", en = "Scarlet Monastery: Cathedral", fr = "Monastère écarlate : Cathédrale",
      min = 38, max = 46, zone = "tirisfal", pos = { 82.6, 33.4 }, src = "approx", routes = R_SM },
    {
        key = "kroldok", en = "Krol'dok Stronghold", fr = "Bastion de Krol'dok",
        min = 40, max = 47, zone = "riverglades", pos = nil, new = true,
        note = { fr = "La forteresse ogre domine le centre-ouest des Riverglades.",
                 en = "The ogre fortress overlooks the west-centre of the Riverglades." },
        routes = {
            H = { fr = { "Riverglades : nouvelle zone à l'est des Terres ingrates et des Steppes ardentes.",
                         "Maîtres de vol : Rog'mar ou Flame Crest. La forteresse ogre domine la zone." },
                  en = { "Riverglades: new zone east of the Badlands and Burning Steppes.",
                         "Flight masters: Rog'mar or Flame Crest. The ogre fortress overlooks the zone." } },
            A = { fr = { "Riverglades : nouvelle zone à l'est des Terres ingrates et des Steppes ardentes.",
                         "Maîtres de vol : Morgan's Vigil ou Farholde Keep. La forteresse ogre domine la zone." },
                  en = { "Riverglades: new zone east of the Badlands and Burning Steppes.",
                         "Flight masters: Morgan's Vigil or Farholde Keep. The ogre fortress overlooks the zone." } },
        },
    },
    {
        key = "ulda", en = "Uldaman", fr = "Uldaman",
        min = 41, max = 51, zone = "badlands", pos = { 42.4, 13.0 }, src = "approx",
        routes = {
            H = { fr = { "Kargath (Terres ingrates) : maître de vol horde.",
                         "Monte au nord-est jusqu'à la grande porte taillée dans la montagne." },
                  en = { "Kargath (Badlands): Horde flight master.",
                         "Head north-east to the great gate carved into the mountain." } },
            A = { fr = { "Thelsamar (Loch Modan) : prends la porte sud vers les Terres ingrates.",
                         "L'entrée est juste au sud de la porte, au nord de la zone." },
                  en = { "Thelsamar (Loch Modan): take the south gate into the Badlands.",
                         "The entrance is just south of the gate, in the north of the zone." } },
        },
    },
    {
        key = "zf", en = "Zul'Farrak", fr = "Zul'Farrak",
        min = 44, max = 54, zone = "tanaris", pos = { 38.7, 20.0 }, src = "approx",
        routes = {
            both = { fr = { "Gadgetzan (Tanaris) : maître de vol des deux factions.",
                            "Au nord-ouest de Gadgetzan, la cité troll : entrée par la grande porte." },
                     en = { "Gadgetzan (Tanaris): flight master for both factions.",
                            "North-west of Gadgetzan, the troll city: enter by the great gate." } },
        },
    },
    {
        key = "mara", en = "Maraudon", fr = "Maraudon",
        min = 46, max = 55, zone = "desolace", pos = { 29.1, 62.5 }, src = "approx",
        routes = {
            H = { fr = { "Village des Ombreproies (Désolace) : maître de vol horde.",
                         "Au centre-sud, dans la vallée des Lances : grotte de Maraudon (entrées violette et orange)." },
                  en = { "Shadowprey Village (Desolace): Horde flight master.",
                         "South-centre, in the Valley of Spears: Maraudon's cave (purple and orange entrances)." } },
            A = { fr = { "Pointe de Nijel (Désolace) : maître de vol alliance.",
                         "Au centre-sud, dans la vallée des Lances : grotte de Maraudon (entrées violette et orange)." },
                  en = { "Nijel's Point (Desolace): Alliance flight master.",
                         "South-centre, in the Valley of Spears: Maraudon's cave (purple and orange entrances)." } },
        },
    },
    {
        key = "alcaz", en = "Alcaz Island Prison", fr = "Prison d'Alcaz",
        min = 48, max = 55, zone = "dustwallow", pos = { 76.0, 17.5 }, src = "approx", new = true,
        note = { fr = "Position de l'île : l'entrée exacte de la prison reste à confirmer.",
                 en = "Island position: the exact prison entrance is still to be confirmed." },
        routes = {
            A = { fr = { "Theramore (Marécage d'Âprefange) : maître de vol alliance.",
                         "Longe la côte au nord, puis nage jusqu'à l'île d'Alcaz au nord-est." },
                  en = { "Theramore (Dustwallow Marsh): Alliance flight master.",
                         "Follow the coast north, then swim to Alcaz Island in the north-east." } },
            H = { fr = { "Mur-de-Fougères (Marécage d'Âprefange) : maître de vol horde.",
                         "Traverse le marécage vers le nord-est, puis nage jusqu'à l'île d'Alcaz." },
                  en = { "Brackenwall Village (Dustwallow Marsh): Horde flight master.",
                         "Cross the marsh to the north-east, then swim to Alcaz Island." } },
        },
    },
    {
        key = "st", en = "Sunken Temple", fr = "Temple englouti",
        min = 50, max = 60, zone = "swamp", pos = { 69.9, 53.6 }, src = "approx",
        routes = {
            H = { fr = { "Pierre-Cassée (Marais des Chagrins) : maître de vol horde.",
                         "À l'est, le bassin des Larmes : descends par l'une des tours en ruines jusqu'à l'entrée." },
                  en = { "Stonard (Swamp of Sorrows): Horde flight master.",
                         "To the east, the Pool of Tears: go down one of the ruined towers to the entrance." } },
            A = { fr = { "Sombre-Comté (Bois de la Pénombre) ou fort de Nethergarde, puis le Marais des Chagrins.",
                         "À l'est, le bassin des Larmes : descends par l'une des tours en ruines jusqu'à l'entrée." },
                  en = { "Darkshire (Duskwood) or Nethergarde Keep, then into the Swamp of Sorrows.",
                         "To the east, the Pool of Tears: go down one of the ruined towers to the entrance." } },
        },
    },
    { key = "brd",  en = "Blackrock Depths", fr = "Profondeurs de Rochenoire",
      min = 52, max = 60, zone = "burningsteppes", pos = { 29.4, 38.0 }, src = "approx", usePos = true, routes = R_BRM,
      note = { fr = "Le point marque l'entrée du mont Rochenoire depuis les Steppes ardentes.",
               en = "The point marks the way into Blackrock Mountain from the Burning Steppes." } },
    { key = "dme",  en = "Dire Maul: East", fr = "Hache-Tripes : Est",
      min = 54, max = 60, zone = "feralas", pos = { 59.2, 44.8 }, src = "approx", routes = R_DM },
    { key = "lbrs", en = "Lower Blackrock Spire", fr = "Pic Rochenoire inférieur",
      min = 55, max = 60, zone = "burningsteppes", pos = { 29.4, 38.0 }, src = "approx", usePos = true, routes = R_BRM },
    {
        key = "blackmaw", en = "Blackmaw Hold", fr = "Repaire des Noiregueules",
        min = 55, max = 60, zone = "azshara", pos = nil, new = true,
        note = { fr = "Derrière la grande porte de pierre du nord de l'Azshara.",
                 en = "Behind the great stone gate of northern Azshara." },
        routes = {
            H = { fr = { "Valormok (Azshara) : maître de vol horde.",
                         "Au nord de la zone, la grande porte de pierre restée fermée en Vanilla (« Timbermaw Hold »)." },
                  en = { "Valormok (Azshara): Horde flight master.",
                         "In the north of the zone, the great stone gate that stayed shut in Vanilla (\"Timbermaw Hold\")." } },
            A = { fr = { "Pointe de Talrendis (Azshara) : maître de vol alliance.",
                         "Au nord de la zone, la grande porte de pierre restée fermée en Vanilla (« Timbermaw Hold »)." },
                  en = { "Talrendis Point (Azshara): Alliance flight master.",
                         "In the north of the zone, the great stone gate that stayed shut in Vanilla (\"Timbermaw Hold\")." } },
        },
    },
    { key = "dmw",  en = "Dire Maul: West", fr = "Hache-Tripes : Ouest",
      min = 56, max = 60, zone = "feralas", pos = { 59.2, 44.8 }, src = "approx", routes = R_DM },
    { key = "dmn",  en = "Dire Maul: North", fr = "Hache-Tripes : Nord",
      min = 56, max = 60, zone = "feralas", pos = { 59.2, 44.8 }, src = "approx", routes = R_DM },
    {
        key = "shaper", en = "Shaper's Terrace", fr = "Terrasse du Façonneur",
        min = 58, max = 60, zone = "ungoro", pos = nil, new = true,
        note = { fr = "Dans les collines au nord du cratère.",
                 en = "In the northern hills of the crater." },
        routes = {
            both = { fr = { "Refuge des Marshal (Un'Goro) : maître de vol des deux factions.",
                            "Le site titan est dans les collines nord du cratère." },
                     en = { "Marshal's Refuge (Un'Goro): flight master for both factions.",
                            "The titan site lies in the northern hills of the crater." } },
        },
    },
    { key = "stratlive", en = "Stratholme: Main Gate", fr = "Stratholme : Porte principale",
      min = 58, max = 60, zone = "epl", pos = { 30.8, 14.8 }, src = "approx", usePos = true, routes = R_STRAT,
      note = { fr = "Porte principale, au bout du pont (côté écarlate).", en = "Main gate, at the end of the bridge (Scarlet side)." } },
    { key = "stratud", en = "Stratholme: Service Gate", fr = "Stratholme : Porte de service",
      min = 58, max = 60, zone = "epl", pos = { 47.9, 23.9 }, src = "approx", usePos = true, routes = R_STRAT,
      note = { fr = "Porte de service sur le flanc est des remparts (côté mort-vivant).", en = "Service gate on the east side of the walls (undead side)." } },
    {
        key = "scholo", en = "Scholomance", fr = "Scholomance",
        min = 58, max = 60, zone = "wpl", pos = { 69.4, 73.2 }, src = "approx",
        routes = {
            A = { fr = { "Camp du Noroît (Maleterres de l'Ouest) : maître de vol alliance.",
                         "Au sud-est, l'île de Caer Darrow sur le lac : traverse à la nage, entrée dans le château." },
                  en = { "Chillwind Camp (Western Plaguelands): Alliance flight master.",
                         "To the south-east, Caer Darrow island on the lake: swim over, entrance inside the castle." } },
            H = { fr = { "Fossoyeuse : à l'est par le Rempart vers les Maleterres de l'Ouest.",
                         "Au sud-est, l'île de Caer Darrow sur le lac : traverse à la nage, entrée dans le château." },
                  en = { "Undercity: east through the Bulwark into the Western Plaguelands.",
                         "To the south-east, Caer Darrow island on the lake: swim over, entrance inside the castle." } },
        },
    },
    { key = "ubrs", en = "Upper Blackrock Spire", fr = "Pic Rochenoire supérieur",
      min = 59, max = 60, zone = "burningsteppes", pos = { 29.4, 38.0 }, src = "approx", usePos = true, routes = R_BRM },

    -- -----------------------------------------------------------------
    -- [1.4.1] Raids (raid = true, size = players)
    -- -----------------------------------------------------------------
    { key = "mc", en = "Molten Core", fr = "Cœur du Magma", raid = true, size = 40,
      min = 60, max = 60, zone = "burningsteppes", pos = { 29.4, 38.0 }, src = "approx", usePos = true, routes = R_BRM,
      note = { fr = "Dans le mont Rochenoire : le portail est au fond, près de l'entrée des Profondeurs de Rochenoire.",
               en = "Inside Blackrock Mountain: the portal is at the bottom, near the Blackrock Depths entrance." } },
    { key = "bwl", en = "Blackwing Lair", fr = "Repaire de l'Aile noire", raid = true, size = 40,
      min = 60, max = 60, zone = "burningsteppes", pos = { 29.4, 38.0 }, src = "approx", usePos = true, routes = R_BRM,
      note = { fr = "Par le Pic Rochenoire supérieur : l'accès est au bout du pic.",
               en = "Through Upper Blackrock Spire: the way in is at the top of the spire." } },
    {
        key = "ony", en = "Onyxia's Lair", fr = "Repaire d'Onyxia", raid = true, size = 40,
        min = 60, max = 60, zone = "dustwallow", pos = { 52.6, 76.8 }, src = "approx",
        routes = {
            A = { fr = { "Theramore (Marécage d'Âprefange) : maître de vol alliance.",
                         "Au sud du marais, la grotte d'Onyxia dans les collines de Wyrmbog." },
                  en = { "Theramore (Dustwallow Marsh): Alliance flight master.",
                         "South of the marsh, Onyxia's cave in the hills of the Wyrmbog." } },
            H = { fr = { "Brackenwall Village (Marécage d'Âprefange) : maître de vol horde.",
                         "Au sud du marais, la grotte d'Onyxia dans les collines de Wyrmbog." },
                  en = { "Brackenwall Village (Dustwallow Marsh): Horde flight master.",
                         "South of the marsh, Onyxia's cave in the hills of the Wyrmbog." } },
        },
    },
    {
        key = "zg", en = "Zul'Gurub", fr = "Zul'Gurub", raid = true, size = 20,
        min = 60, max = 60, zone = "stranglethorn", pos = { 53.9, 17.6 }, src = "approx",
        routes = {
            H = { fr = { "Grom'gol (Strangleronce) : maître de vol horde.",
                         "Au nord-est de la vallée, la cité troll : entrée par le grand pont." },
                  en = { "Grom'gol (Stranglethorn): Horde flight master.",
                         "In the north-east of the vale, the troll city: enter by the great bridge." } },
            A = { fr = { "Maître de vol du camp Rebelle (nord de Strangleronce).",
                         "À l'est, la cité troll : entrée par le grand pont." },
                  en = { "Rebel Camp flight master (northern Stranglethorn).",
                         "To the east, the troll city: enter by the great bridge." } },
        },
    },
    {
        key = "aq20", en = "Ruins of Ahn'Qiraj", fr = "Ruines d'Ahn'Qiraj", raid = true, size = 20,
        min = 60, max = 60, zone = "silithus", pos = { 28.6, 92.4 }, src = "approx",
        routes = {
            both = { fr = { "Fort Cénarien (Silithus) : maître de vol des deux factions.",
                            "Tout au sud, derrière le Mur du Scarabée : les Ruines sont à gauche des portes." },
                     en = { "Cenarion Hold (Silithus): flight master for both factions.",
                            "At the far south, past the Scarab Wall: the Ruins are left of the gates." } },
        },
    },
    {
        key = "aq40", en = "Ahn'Qiraj Temple", fr = "Temple d'Ahn'Qiraj", raid = true, size = 40,
        min = 60, max = 60, zone = "silithus", pos = { 28.6, 92.4 }, src = "approx",
        routes = {
            both = { fr = { "Fort Cénarien (Silithus) : maître de vol des deux factions.",
                            "Tout au sud, derrière le Mur du Scarabée : le Temple est au fond, passé les portes." },
                     en = { "Cenarion Hold (Silithus): flight master for both factions.",
                            "At the far south, past the Scarab Wall: the Temple lies beyond the gates." } },
        },
    },
    {
        key = "hyjal", en = "Hyjal Summit", fr = "Sommet d'Hyjal", raid = true, size = 20, new = true,
        min = 60, max = 60, zone = "hyjal", pos = nil,
        note = { fr = "Ouvre le 9 décembre. Au sommet du mont Hyjal, près de l'Arbre-Monde Nordrassil. Sur place, tape /codex set hyjal.",
                 en = "Opens on 9 December. At the summit of Mount Hyjal, near the World Tree Nordrassil. On the spot, type /codex set hyjal." },
        routes = {
            both = { fr = { "Long-guet (Berceau-de-l'Hiver), puis au sud par les gorges de Darkwhisper vers le mont Hyjal.",
                            "Maîtres de vol : Summit of Eternity ou Tainted Foothills. Le raid est au sommet, près de Nordrassil." },
                     en = { "Everlook (Winterspring), then south through Darkwhisper Gorge into Mount Hyjal.",
                            "Flight masters: Summit of Eternity or Tainted Foothills. The raid is at the summit, near Nordrassil." } },
        },
    },
    {
        key = "barrow", en = "Barrow Deeps", fr = "Barrow Deeps", raid = true, size = 10, new = true,
        min = 60, max = 60, zone = "hyjal", pos = nil,
        note = { fr = "Ouvre le 9 décembre. Entrées par le mont Hyjal, le Berceau-de-l'Hiver et le Repaire des Noiregueules. Sur place, tape /codex set barrow.",
                 en = "Opens on 9 December. Entrances through Mount Hyjal, Winterspring and Blackmaw Hold. On the spot, type /codex set barrow." },
        routes = {
            both = { fr = { "Long-guet (Berceau-de-l'Hiver), puis au sud par les gorges de Darkwhisper vers le mont Hyjal.",
                            "Le raid est sous la montagne : plusieurs entrées, dont une depuis le Repaire des Noiregueules." },
                     en = { "Everlook (Winterspring), then south through Darkwhisper Gorge into Mount Hyjal.",
                            "The raid lies under the mountain: several entrances, one of them from Blackmaw Hold." } },
        },
    },
}

D.byKey = {}
for _, d in ipairs(D.dungeons) do D.byKey[d.key] = d end

-- ---------------------------------------------------------------------
-- [1.4.1] Entrances from the game's own tables (instance entrances and
-- Group Finder data, builds 1.60.1.70245 / 70888), cross-checked with
-- OpenMap, thanks to its contributors.
--   { continent, worldX, worldY }        a world position (yards): the
--                                         client puts it on the zone map
--   { map = uiMapID, x, y }              a spot on that map (0-100)
-- ---------------------------------------------------------------------
local SM, DM, BRM, STRAT, AQ = { 0, 2892.2, -811.3 }, { 1, -3908.0, 1130.0 }, { 0, -7522.5, -1233.0 }, { 0, 3392.3, -3378.5 }, { 1, -8114.5, 1526.4 }
D.game = {
    rfc = { 1, 1816.8, -4423.4 },          hot = { map = 1455, 27.7, 47.9 },
    rol = { map = 1458, 72.5, 11.4 },      wc = { 1, -751.1, -2209.2 },
    vc = { 0, -11207.8, 1681.2 },          sfk = { 0, -231.0, 1571.6 },
    bfd = { 1, 4249.1, 748.4 },            stocks = { 0, -8762.4, 848.0 },
    exc = { map = 1437, 47.8, 56.2 },      dal = { map = 1416, 8.5, 59.3 },
    rfk = { 1, -4459.4, -1660.2 },         gnomer = { 0, -5162.7, 931.6 },
    smgy = SM, smlib = SM, smarm = SM, smcath = SM,
    drowned = { map = 1434, 21.3, 27.8 },  rfd = { 1, -4662.9, -2535.9 },
    kroldok = { map = 2548, 37.5, 37.3 },  ulda = { 0, -6060.2, -2955.0 },
    zf = { 1, -6790.6, -2891.3 },          mara = { 1, -1432.7, 2925.0 },
    alcaz = { map = 1445, 75.3, 14.1 },    st = { 0, -10170.1, -3996.0 },
    brd = { 0, -7178.1, -928.6 },          dme = DM, dmw = DM, dmn = DM,
    lbrs = BRM, ubrs = BRM, mc = BRM, bwl = BRM,
    blackmaw = { map = 1447, 38.6, 33.2 }, shaper = { map = 1449, 48.1, 6.1 },
    stratlive = STRAT, stratud = STRAT,    scholo = { 0, 1274.8, -2552.6 },
    ony = { 1, -4753.3, -3752.4 },         zg = { 0, -11916.1, -1224.6 },
    aq20 = AQ, aq40 = AQ,
}
