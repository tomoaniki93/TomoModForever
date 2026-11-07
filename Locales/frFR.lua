-- =====================================
-- frFR.lua — Français
-- =====================================

-- Perf: Lua builds the whole table constructor below before
-- TomoMod_RegisterLocale can decide to discard it. For a player on any other
-- locale that is ~2900 key/value pairs allocated and turned straight into
-- garbage, five files over, on every /reload. The chunk still compiles (the
-- TOC loads it), but the constructor never runs.
if GetLocale() ~= "frFR" then return end

TomoMod_RegisterLocale("frFR", {

    -- =====================
    -- CONFIG: Categories (ConfigUI.lua)
    -- =====================
    ["cat_general"]         = "Général",
    ["cat_unitframes"]      = "UnitFrames",
    ["cat_nameplates"]      = "Nameplates",
    ["cat_cd_resource"]     = "CD & Ressource",
    ["cat_qol"]             = "Qualité de vie",
    ["cat_mythicplus"]      = "Mythic+",
    ["cat_profiles"]        = "Profils",
    ["cat_diagnostics"]     = "Diagnostics",

    -- =====================
    -- CONFIG: General Panel
    -- =====================
    ["section_about"]                   = "À propos",
    ["about_text"]                      = "|cffffd100TomoModForever|r %s par TomoAniki\nInterface légère avec Qualité de vie, UnitFrames et Nameplates.\nTapez /tm help pour la liste des commandes.",
    ["section_general"]                 = "Général",
    ["btn_reset_all"]                   = "Réinitialiser tout",
    ["info_reset_all"]                  = "Cela réinitialise TOUS les paramètres et recharge l'UI.",

    -- Minimap
    ["section_minimap"]                 = "Minimap",
    ["opt_minimap_enable"]              = "Activer la minimap personnalisée",
    ["opt_size"]                        = "Taille",
    ["opt_scale"]                       = "Échelle",
    ["opt_border"]                      = "Bordure",
    ["border_class"]                    = "Couleur de classe",
    ["border_black"]                    = "Noir",

    -- Info Panel
    ["section_info_panel"]              = "Panneau d'information",
    ["opt_enable"]                      = "Activer",
    ["opt_durability"]                  = "Durabilité (Équipement)",
    ["info_durability_position"]        = "Position du texte de durabilité — utile si un bouton (ex. extension) chevauche le coin par défaut.",
    ["opt_durability_corner"]           = "Coin (durabilité)",
    ["opt_time"]                        = "Heure",
    ["opt_24h_format"]                  = "Format 24h",
    ["opt_show_coords"]                 = "Afficher les coordonnées",
    ["btn_reset_position"]              = "Réinitialiser la position",

    -- Cursor Ring
    ["section_cursor_ring"]             = "Anneau du curseur",
    ["opt_class_color"]                 = "Couleur de classe",
    ["opt_anchor_tooltip_ring"]         = "Ancrer l'infobulle au curseur",
    ["opt_cursor_ring_texture"]         = "Texture",
    ["cursor_tex_ring"]                 = "Anneau",
    ["cursor_tex_glow"]                 = "Lueur",
    ["cursor_tex_cygle"]                = "Cygle",
    ["cursor_tex_heart"]                = "Cœur",

    -- =====================
    -- CONFIG: UnitFrames Panel
    -- =====================
    -- Tabs
    ["tab_general"]                     = "Général",
    ["tab_player"]                      = "Joueur",
    ["tab_target"]                      = "Cible",
    ["tab_tot"]                         = "CdC",
    ["tab_pet"]                         = "Familier",
    ["tab_focus"]                       = "Focus",
    ["tab_colors"]                      = "Couleurs",

    -- Sub-tabs (Player, Target, Focus)
    ["subtab_dimensions"]               = "Dimensions",
    ["subtab_display"]                  = "Affichage",
    ["subtab_auras"]                    = "Auras",
    ["subtab_positioning"]              = "Position",

    -- Sub-labels
    ["sublabel_dimensions"]             = "— Dimensions —",
    ["sublabel_display"]                = "— Affichage —",
    ["sublabel_castbar"]                = "— Barre de sort —",
    ["sublabel_auras"]                  = "— Auras —",
    ["sublabel_element_offsets"]        = "— Position des éléments —",

    -- Unit display names
    ["unit_player"]                     = "Joueur",
    ["unit_target"]                     = "Cible",
    ["unit_tot"]                        = "Cible de cible",
    ["unit_pet"]                        = "Familier",
    ["unit_focus"]                      = "Focus",

    -- General tab
    ["section_general_settings"]        = "Paramètres Généraux",
    ["opt_uf_enable"]                   = "Activer les UnitFrames TomoMod",
    ["opt_hide_blizzard"]               = "Masquer les frames Blizzard",
    ["opt_global_font_size"]            = "Taille de police globale",
    ["sublabel_font"]                   = "— Police —",
    ["opt_font_family"]                 = "Police de texte",

    -- Castbar colors
    ["section_castbar_colors"]          = "Couleurs Castbar",
    ["info_castbar_colors"]             = "Personnalisez les couleurs des barres de cast pour les sorts interruptibles, non-interruptibles et interrompus.",
    ["opt_castbar_color"]               = "Sort interruptible",
    ["opt_castbar_ni_color"]            = "Sort non-interruptible",
    ["opt_castbar_interrupt_color"]     = "Sort interrompu",
    ["info_castbar_colors_reload"]      = "Les couleurs s'appliquent aux nouveaux casts. /reload pour un effet complet.",
    ["btn_toggle_lock"]                 = "Verrouiller/Déverrouiller (/tm uf)",
    ["info_unlock_drag"]                = "Déverrouillez pour déplacer les frames. Les positions sont sauvegardées automatiquement.",

    -- Per-unit options
    ["opt_width"]                       = "Largeur",
    ["opt_health_height"]               = "Hauteur vie",
    ["opt_power_height"]                = "Hauteur ressource",
    ["opt_show_name"]                   = "Afficher le nom",
    ["opt_name_truncate"]               = "Tronquer les noms longs",
    ["opt_name_truncate_length"]        = "Longueur max du nom",
    ["opt_show_level"]                  = "Afficher le niveau",
    ["opt_show_health_text"]            = "Afficher le texte de vie",
    ["opt_health_format"]               = "Format vie",
    ["fmt_current"]                     = "Courant (25.3K)",
    ["fmt_percent"]                     = "Pourcentage (75%)",
    ["fmt_current_percent"]             = "Courant + % (25.3K | 75%)",
    ["fmt_current_max"]                 = "Courant / Max",
    ["opt_class_color_uf"]              = "Couleur de classe",
    ["opt_faction_color"]               = "Couleur de faction (PNJ)",
    ["opt_use_nameplate_colors"]        = "Couleurs Nameplates (type de PNJ)",
    ["opt_show_absorb"]                 = "Barre d'absorption",
    ["opt_show_threat"]                 = "Indicateur de menace (contour)",
    ["section_threat_text"]             = "Texte % de Menace",
    ["opt_threat_text_enable"]          = "Afficher le % de menace sur la cible",
    ["opt_threat_text_font_size"]       = "Taille de la police",
    ["info_threat_text"]                = "Vert = tank (avance sur le 2e), jaune = proche, rouge = aggro perdu",
    ["opt_show_leader_icon"]            = "Icône de Chef de groupe",
    ["opt_leader_icon_x"]               = "Icône de Chef de groupe X",
    ["opt_leader_icon_y"]               = "Icône de Chef de groupe Y",
    ["opt_raid_icon_x"]                 = "Marqueur raid X",
    ["opt_raid_icon_y"]                 = "Marqueur raid Y",

    -- Castbar
    ["opt_castbar_enable"]              = "Activer castbar",
    ["opt_castbar_width"]               = "Largeur castbar",
    ["opt_castbar_height"]              = "Hauteur castbar",
    ["opt_castbar_show_icon"]           = "Afficher icône",
    ["opt_castbar_show_timer"]          = "Afficher le timer",
    ["info_castbar_drag"]               = "Position: /tm sr pour déverrouiller et déplacer la castbar.",
    ["btn_reset_castbar_position"]      = "Réinitialiser la position de la castbar",
    ["opt_castbar_show_latency"]        = "Afficher la latence",

    -- Auras
    ["opt_auras_enable"]                = "Activer les auras",
    ["opt_auras_max"]                   = "Nombre max d'auras",
    ["opt_auras_size"]                  = "Taille des icônes",
    ["opt_auras_type"]                  = "Type d'auras",
    ["aura_harmful"]                    = "Debuffs (nocifs)",
    ["aura_helpful"]                    = "Buffs (bénéfiques)",
    ["aura_all"]                        = "Buffs et debuffs",
    ["opt_auras_direction"]             = "Direction de croissance",
    ["opt_auras_direction_v"]           = "Direction verticale",
    ["aura_dir_down"]                   = "Vers le bas",
    ["aura_dir_up"]                     = "Vers le haut",
    ["aura_dir_right"]                  = "Vers la droite",
    ["aura_dir_left"]                   = "Vers la gauche",
    ["opt_auras_only_mine"]             = "Seulement mes auras",

    -- Element offsets
    ["elem_name"]                       = "Nom",
    ["elem_level"]                      = "Niveau",
    ["elem_health_text"]                = "Texte de vie",
    ["elem_power"]                      = "Barre de ressource",
    ["elem_castbar"]                    = "Castbar",
    ["elem_auras"]                      = "Auras",
    ["elem_enemy_buffs"]                = "Buffs de la cible",

    -- AstralForge: element registry
    ["elem_raid_icon"]                  = "Marque de raid",
    ["elem_leader_icon"]                = "Icône de chef",
    ["elem_threat_text"]                = "Texte de menace",
    ["opt_element_anchor"]              = "Ancrage",
    ["btn_reset_elements"]              = "Réinitialiser la position des éléments",
    ["anchor_host_frame"]               = "Cadre",
    ["anchor_host_health"]              = "Barre de vie",
    ["anchor_host_power"]               = "Barre de ressource",
    ["anchor_host_infobar"]             = "Bandeau d'info",
    ["btn_open_astralforge"]            = "Ouvrir AstralForge",
    ["info_astralforge"]                = "AstralForge est le designer complet : glisse chaque élément directement sur le cadre, choisis son point d'ancrage et son hôte. Les curseurs ci-dessous restent disponibles pour un ajustement au pixel.",
    ["target_kind_host"]                = "Structure : ",
    ["target_kind_element"]             = "Élément : ",

    -- AstralForge : proprietes par element
    ["sublabel_element_props"]          = "Propriétés visuelles",
    ["opt_element_alpha"]               = "Opacité (%)",
    ["opt_element_scale"]               = "Échelle (%)",
    ["opt_element_font_size"]           = "Taille de police forcée",
    ["info_element_font_size"]          = "Laisse à 0 pour conserver la taille calculée par le module.",

    -- AstralForge : elements instancies
    ["elem_custom_text"]                = "Texte personnalisé",
    ["opt_custom_text_template"]        = "Modèle de texte",
    ["info_custom_text_tokens"]         = "Jetons disponibles :",
    ["btn_add_custom_text"]             = "Ajouter un texte personnalisé",
    ["btn_reset_element"]               = "Réinitialiser cet élément",
    ["btn_delete_element"]              = "Supprimer cet élément",
    ["msg_element_max_reached"]         = "Nombre maximum d'éléments de ce type atteint.",

    -- AstralForge : presets de disposition
    ["section_forge_presets"]           = "Presets de disposition",
    ["btn_forge_presets"]               = "Presets de disposition",
    ["info_forge_presets"]              = "Un preset enregistre la disposition complète du sujet courant : ancrages, propriétés visuelles et éléments personnalisés.",
    ["opt_preset_name"]                 = "Nom du preset",
    ["btn_preset_save"]                 = "Enregistrer / remplacer",
    ["opt_preset_saved"]                = "Presets enregistrés",
    ["btn_preset_apply"]                = "Appliquer",
    ["btn_preset_delete"]               = "Supprimer",
    ["btn_preset_export"]               = "Générer la chaîne de partage",
    ["opt_preset_share_string"]         = "Chaîne de partage",
    ["info_preset_copy"]                = "Clique dans le champ, puis Ctrl+A et Ctrl+C pour copier.",
    ["opt_preset_import"]               = "Colle une chaîne de partage",
    ["btn_preset_import"]               = "Importer",
    ["info_no_preset"]                  = "Aucun preset enregistré pour ce sujet.",
    ["msg_preset_saved"]                = "Preset enregistré.",
    ["msg_preset_applied"]              = "Preset appliqué.",
    ["msg_preset_imported"]             = "Preset importé :",
    ["msg_preset_error"]                = "L'opération sur le preset a échoué.",
    ["msg_presets_unavailable"]         = "Les presets de disposition sont indisponibles.",
    ["token_classification"]            = "Classification",
    ["token_name"]                      = "Nom",
    ["token_level"]                     = "Niveau",
    ["token_class"]                     = "Classe",
    ["token_race"]                      = "Race",
    ["token_guild"]                     = "Guilde",

    -- AstralForge : domaine plaques de nom
    ["section_np_elements"]             = "Position des éléments",
    ["info_np_elements"]                = "Ouvre AstralForge pour glisser chaque élément sur la plaque et choisir son ancrage. Les curseurs ci-dessous servent à l'ajustement au pixel.",
    ["np_host_plate"]                   = "Plaque",
    ["np_host_health"]                  = "Barre de vie",
    ["np_host_castbar"]                 = "Barre d'incantation",
    ["np_host_name"]                    = "Nom",
    ["np_elem_name"]                    = "Nom",
    ["np_elem_hp_number"]               = "Valeur de vie",
    ["np_elem_hp_percent"]              = "Pourcentage de vie",
    ["np_elem_level"]                   = "Niveau",
    ["np_elem_class_icon"]              = "Icône de classification",
    ["np_elem_class_text"]              = "Texte de classification",
    ["np_elem_castbar"]                 = "Barre d'incantation",
    ["np_elem_cast_icon"]               = "Icône d'incantation",
    ["np_elem_cast_text"]               = "Nom du sort",
    ["np_elem_cast_timer"]              = "Minuteur d'incantation",
    ["np_elem_cast_shield"]             = "Bouclier d'incantation",
    ["np_elem_quest_icon"]              = "Icône de quête",
    ["np_elem_raid_marker"]             = "Marque de raid",

    -- =====================
    -- CONFIG: Nameplates Panel
    -- =====================
    -- Nameplate tabs
    ["tab_np_auras"]                    = "Auras",
    ["tab_np_advanced"]                 = "Avancé",
    ["info_np_colors_custom"]           = "Chaque couleur peut être personnalisée selon vos envies en cliquant sur le carré de couleur.",

    ["section_np_general"]              = "Paramètres Généraux",
    ["opt_np_enable"]                   = "Activer les Nameplates TomoMod",
    ["info_np_description"]             = "Remplace les nameplates Blizzard par un style minimaliste personnalisable.",
    ["section_dimensions"]              = "Dimensions",
    ["opt_np_name_font_size"]           = "Taille police nom",

    -- Display
    ["section_display"]                 = "Affichage",
    ["opt_np_show_classification"]      = "Afficher classification (élite, rare, boss)",
    ["opt_np_show_absorb"]               = "Afficher la barre d'absorption",
    ["opt_np_class_colors"]             = "Couleurs de classe (joueurs)",
    ["opt_np_friendly_name_only"]       = "Alliés : nom uniquement (sans barre de vie)",
    ["opt_np_friendly_role_icons"]      = "Afficher icônes de rôle (donjon/delve)",
    ["opt_np_role_show_tank"]           = "Afficher icône Tank",
    ["opt_np_role_show_healer"]         = "Afficher icône Healer",
    ["opt_np_role_show_dps"]            = "Afficher icône DPS",
    ["opt_np_role_icon_size"]           = "Taille icône de rôle",

    -- Raid Marker
    ["section_raid_marker"]             = "Marqueur de raid",
    ["opt_np_raid_icon_x"]              = "Décalage X",
    ["opt_np_raid_icon_y"]              = "Décalage Y",
    ["opt_np_raid_icon_size"]           = "Taille de l'icône",

    -- Castbar
    ["section_castbar"]                 = "Barre de sort",
    ["opt_np_show_castbar"]             = "Afficher la barre de sort",
    ["opt_np_castbar_height"]           = "Hauteur de la barre de sort",
    ["color_castbar"]                   = "Barre de sort (interruptible)",
    ["color_castbar_uninterruptible"]   = "Barre de sort (non-interruptible)",

    -- Auras
    ["section_auras"]                   = "Auras",
    ["opt_np_show_auras"]               = "Afficher les auras",
    ["opt_np_aura_size"]                = "Taille des icônes",
    ["opt_np_max_auras"]                = "Nombre max",
    ["opt_np_only_my_debuffs"]          = "Seulement mes debuffs",

    -- Enemy Buffs
    ["section_enemy_buffs"]              = "Buffs ennemis",
    ["sublabel_enemy_buffs"]             = "— Buffs ennemis —",
    ["opt_enemy_buffs_enable"]           = "Afficher les buffs ennemis",
    ["opt_enemy_buffs_max"]              = "Nombre max de buffs",
    ["opt_enemy_buffs_size"]             = "Taille des icônes",
    ["opt_enemy_buffs_direction"]        = "Direction",
    ["opt_enemy_buffs_per_row"]          = "Icônes par ligne",
    ["opt_enemy_buffs_row_orientation"]  = "Ligne suivante",
    ["info_enemy_buffs"]                 = "Affiche les buffs actifs (Enrage, boucliers...) sur les unités hostiles. Les icônes apparaissent en haut à droite, empilées vers le haut.",
    ["opt_np_show_enemy_buffs"]          = "Afficher les buffs ennemis",
    ["opt_np_enemy_buff_size"]           = "Taille des icônes buff",
    ["opt_np_max_enemy_buffs"]           = "Nombre max de buffs ennemis",
    ["opt_np_enemy_buff_y_offset"]       = "Décalage Y des buffs ennemis",

    -- Transparency
    ["section_transparency"]            = "Transparence",
    ["opt_np_selected_alpha"]           = "Alpha sélectionné",
    ["opt_np_unselected_alpha"]         = "Alpha non-sélectionné",

    -- Stacking
    ["section_stacking"]                = "Empilement",
    ["opt_np_overlap"]                  = "Chevauchement vertical",
    ["opt_np_top_inset"]                = "Limite haute écran",

    -- Colors
    ["section_colors"]                  = "Couleurs",
    ["color_hostile"]                   = "Hostile (Ennemi)",
    ["color_neutral"]                   = "Neutre",
    ["color_friendly"]                  = "Amical",
    ["color_tapped"]                    = "Tagué (tapped)",
    ["color_focus"]                     = "Cible de focus",

    -- Couleurs par type de PNJ (style Ellesmere)
    ["section_npc_type_colors"]         = "Couleurs par Type de PNJ",
    ["color_caster"]                    = "Caster (lanceur de sorts)",
    ["color_miniboss"]                  = "Mini-boss (élite + niveau supérieur)",
    ["color_enemy_in_combat"]           = "Ennemi (par défaut)",
    ["info_np_darken_ooc"]              = "Les ennemis hors-combat sont automatiquement assombris.",

    -- Classification colors
    ["section_classification_colors"]   = "Couleurs par Classification",
    ["opt_np_use_classification"]       = "Couleurs par type d'ennemi",
    ["color_boss"]                      = "Boss",
    ["color_elite"]                     = "Élite / Mini-boss",
    ["color_rare"]                      = "Rare",
    ["color_normal"]                    = "Normal",
    ["color_trivial"]                   = "Trivial",

    -- Tank mode
    ["section_tank_mode"]               = "Mode Tank",
    ["opt_np_tank_mode"]                = "Activer le mode Tank (couleur par menace)",
    ["color_no_threat"]                 = "Pas de menace",
    ["color_low_threat"]                = "Menace faible",
    ["color_has_threat"]                = "Menace tenue",
    ["color_dps_has_aggro"]             = "DPS/Heal a l'aggro",
    ["color_dps_near_aggro"]            = "DPS/Heal proche de l'aggro",

    -- NP health format
    ["np_fmt_percent"]                  = "Pourcentage (75%)",
    ["np_fmt_current"]                  = "Courant (25.3K)",
    ["np_fmt_current_percent"]          = "Courant + %",

    -- Reset
    ["btn_reset_nameplates"]            = "Réinitialiser Nameplates",

    -- =====================
    -- CONFIG: CD & Resource Panel
    -- =====================
    -- Resource colors
    ["section_resource_colors"]         = "Couleurs des Ressources",
    ["res_runes_ready"]                 = "Runes (prêtes)",
    ["res_runes_cd"]                    = "Runes (cooldown)",
    -- NOTE: Most resource names (Mana, Rage, Energy, etc.) are the same in French

    -- Cooldown Manager
    -- CD & Resource tabs
    ["tab_cdm"]                         = "Cooldowns",
    ["tab_cdm_bars"]                    = "Barres",
    ["tab_resource_bars"]               = "Barres de Ressource",
    ["tab_text_position"]               = "Texte & Position",
    ["tab_rb_colors"]                   = "Couleurs",
    ["info_rb_colors_custom"]           = "Chaque couleur peut être personnalisée selon vos envies en cliquant sur le carré de couleur.",

    ["section_cdm"]                     = "Cooldown Manager",
    ["opt_cdm_enable"]                  = "Activer le Cooldown Manager",
    ["info_cdm_description"]            = "Reskin des icônes du CooldownManager Blizzard : bordures arrondies, overlay de classe sur les auras actives, couleurs de balayage personnalisées, atténuation utilitaire, disposition centrée. Placement via Edit Mode Blizzard.",
    ["opt_cdm_show_hotkeys"]            = "Afficher les hotkeys",
    ["opt_cdm_combat_alpha"]            = "Modifier l'opacité (combat / cible)",
    ["opt_cdm_alpha_combat"]            = "Alpha en combat",
    ["opt_cdm_alpha_target"]            = "Alpha avec cible (hors combat)",
    ["opt_cdm_alpha_ooc"]               = "Alpha hors combat",
    ["section_cdm_overlay"]             = "Overlay et bordures",
    ["opt_cdm_custom_overlay"]          = "Couleur d'overlay personnalisée",
    ["opt_cdm_overlay_color"]           = "Couleur de l'overlay",
    ["opt_cdm_custom_swipe"]            = "Couleur de balayage actif personnalisée",
    ["opt_cdm_swipe_color"]             = "Couleur du balayage",
    ["opt_cdm_swipe_alpha"]             = "Opacité du balayage",
    ["section_cdm_utility"]             = "Utilitaire",
    ["opt_cdm_dim_utility"]             = "Atténuer les icônes utilitaires hors CD",
    ["opt_cdm_dim_opacity"]             = "Opacité d'atténuation",
    ["info_cdm_editmode"]               = "Le placement des barres se fait via le Edit Mode de Blizzard (Échap |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Edit Mode).",

    -- CDM V3: CD Swipe
    ["opt_cdm_custom_cd_swipe"]          = "Couleur de balayage CD personnalisée",
    ["opt_cdm_cd_swipe_color"]           = "Couleur balayage CD",
    ["opt_cdm_cd_swipe_alpha"]           = "Opacité balayage CD",

    -- CDM V3: Advanced
    ["section_cdm_advanced"]             = "Avancé",
    ["opt_cdm_hide_gcd"]                 = "Masquer le GCD",
    ["opt_cdm_desaturate"]               = "Désaturer en CD",
    ["opt_cdm_buff_alignment"]           = "Alignement des buffs",
    ["align_center_outward"]             = "Centre > Extérieur",
    ["align_start"]                      = "Début (gauche)",
    ["align_end"]                        = "Fin (droite)",

    -- CDM V3: Visibility Rules
    ["section_cdm_visibility"]           = "Règles de visibilité",
    ["info_cdm_visibility"]              = "Règles prioritaires de masquage. Les conditions 'Afficher' supplantent 'Masquer'.",
    ["opt_cdm_hide_mounted"]             = "Masquer sur monture",
    ["opt_cdm_hide_vehicle"]             = "Masquer en véhicule",
    ["opt_cdm_hide_ooc"]                 = "Masquer hors combat (pas de cible)",
    ["opt_cdm_show_combat"]              = "Toujours afficher en combat",
    ["opt_cdm_show_instance"]            = "Toujours afficher en instance",
    ["opt_cdm_show_enemy"]               = "Afficher avec cible ennemie",

    -- CDM V3.1: Sound / Pandemic / Range
    ["section_cdm_extras"]               = "Son / Pandemic / Portée",
    ["opt_cdm_sound_alert"]              = "Son quand un sort est prêt",
    ["opt_cdm_sound_file"]               = "Fichier son",
    ["opt_cdm_pandemic"]                 = "Pandemic (bordure de refresh)",
    ["opt_cdm_pandemic_threshold"]       = "Seuil pandemic (%)",
    ["opt_cdm_range_check"]              = "Teinter rouge hors portée",
    ["opt_cdm_bufficon_direction"]        = "Direction buff icons",
    ["opt_cdm_buffbar_direction"]         = "Direction BuffBar",
    ["opt_cdm_buffbar_width"]             = "Largeur barre (horizontal)",
    ["buffbar_vertical"]                  = "Verticale",
    ["buffbar_horizontal"]                = "Horizontale",
    ["dir_centered"]                      = "Centré (horizontal)",
    ["dir_left"]                          = "Gauche",
    ["dir_right"]                         = "Droite",
    ["dir_up"]                            = "Haut",
    ["dir_down"]                          = "Bas",

    -- CDM V3.2: Placement & cartes viewer (Phase 4)
    ["section_cdm_placement"]            = "Placement & aperçu live",
    ["info_cdm_placement"]               = "Les barres CDM sont désormais positionnées par TomoMod (plus besoin de l'Edit Mode Blizzard). Le mode placement affiche des icônes factices et permet de glisser chaque barre.",
    ["btn_cdm_unlock"]                   = "Mode placement (live)",
    ["opt_cdm_preview"]                  = "Aperçu (icônes factices)",
    ["info_cdm_preview_live"]            = "Réglages par barre dans l'onglet « Barres » — tout s'applique en direct.",
    ["info_cdm_bars"]                    = "Chaque barre a sa position et sa disposition propres. Active l'aperçu pour voir les changements en direct, ou le mode placement pour glisser les barres à la souris.",
    ["btn_cdm_reset_pos"]                = "Réinitialiser positions",
    ["msg_cdm_pos_reset"]                = "Positions CDM réinitialisées.",
    ["section_cdm_essential"]            = "Essential (sorts principaux)",
    ["section_cdm_utility_bar"]          = "Utility (sorts utilitaires)",
    ["section_cdm_bufficons"]            = "Buff Icons (auras — icônes)",
    ["section_cdm_buffbars"]             = "Buff Bars (auras — barres)",
    ["opt_cdm_pos_x"]                    = "Position X",
    ["opt_cdm_pos_y"]                    = "Position Y",
    ["opt_cdm_icon_size"]                = "Taille des icônes (0 = auto)",
    ["opt_cdm_spacing"]                  = "Espacement",
    ["opt_cdm_row_limit"]                = "Par ligne (0 = illimité)",
    ["opt_cdm_direction"]                = "Direction",
    ["opt_cdm_secondary_direction"]      = "Direction secondaire",
    ["opt_cdm_buffbar_spacing"]          = "Espacement",
    ["secdir_auto"]                      = "Auto",
    ["secdir_down"]                      = "Lignes vers le bas",
    ["secdir_up"]                        = "Lignes vers le haut",
    ["secdir_right"]                     = "Colonnes vers droite",
    ["secdir_left"]                      = "Colonnes vers gauche",

    -- Resource Bars
    ["section_resource_bars"]           = "Barres de Ressources",
    ["opt_rb_enable"]                   = "Activer les barres de ressources",
    ["opt_rb_display_mode"]             = "Mode d'affichage",
    ["display_mode_icons"]              = "Icônes (textures TUI)",
    ["display_mode_bars"]               = "Barres (couleurs plates)",
    ["info_rb_description"]             = "Affiche les pouvoirs de classe (Combo Points, Runes, Soul Shards, etc.). La ressource principale (Mana, Rage, Energy...) est maintenant dans la barre d'info de l'UnitFrame.",
    ["section_visibility"]              = "Visibilité",
    ["opt_rb_visibility_mode"]          = "Mode de visibilité",
    ["vis_always"]                      = "Toujours visible",
    ["vis_combat"]                      = "En combat seulement",
    ["vis_target"]                      = "Combat ou cible",
    ["vis_hidden"]                      = "Cachée",
    ["opt_rb_combat_alpha"]             = "Alpha en combat",
    ["opt_rb_ooc_alpha"]                = "Alpha hors combat",
    ["opt_rb_width"]                    = "Largeur",
    ["opt_rb_classpower_height"]        = "Hauteur pouvoir de classe",
    ["opt_rb_druidmana_height"]         = "Hauteur mana druide",
    ["opt_rb_global_scale"]             = "Échelle globale",

    -- v2.9: Barre de vie (HUD)
    ["section_rb_healthbar"]            = "Barre de vie (HUD)",
    ["opt_rb_hb_enable"]                = "Afficher la barre de vie",
    ["info_rb_healthbar"]               = "Barre de vie centrée au-dessus des ressources. Texte et couleur de seuil gérés côté client (compatibles Midnight).",
    ["opt_rb_hb_height"]                = "Hauteur",
    ["opt_rb_hb_text"]                  = "Texte",
    ["hb_text_none"]                    = "Aucun",
    ["hb_text_value"]                   = "Valeur",
    ["hb_text_percent"]                 = "Pourcentage",
    ["hb_text_both"]                    = "Valeur | %",
    ["opt_rb_hb_classcolor"]            = "Couleur de classe",
    ["opt_rb_hb_color"]                 = "Couleur personnalisée (si classe désactivée)",
    ["opt_rb_hb_threshold"]             = "Seuil vie basse (change la couleur)",
    ["opt_rb_hb_threshold_pct"]         = "Seuil (%)",
    ["opt_rb_hb_threshold_color"]       = "Couleur vie basse",

    -- v2.9: Animations & barre de puissance
    ["section_rb_anim"]                 = "Animations & Barre de puissance",
    ["opt_rb_smooth"]                   = "Animations fluides des barres",
    ["opt_rb_full_glow"]                = "Glow à ressource de classe maximale",
    ["opt_rb_supercharged_points"]      = "Afficher les points de combo surchargés",
    ["opt_rb_power_ticks"]              = "Ticks sur la barre de puissance (% du max)",
    ["ticks_none"]                      = "Aucun",
    ["opt_rb_power_threshold"]          = "Seuil ressource basse (barre de puissance)",
    ["opt_rb_power_threshold_pct"]      = "Seuil (%)",
    ["opt_rb_power_threshold_color"]    = "Couleur ressource basse",
    ["info_rb_anim"]                    = "Ticks et seuil s'appliquent à la barre de puissance centrée. Le smoothing s'applique aussi à la barre de vie, au mana druide et aux barres d'auras.",

    ["opt_rb_sync_width"]               = "Synchroniser la largeur avec Essential Cooldowns",
    ["btn_sync_now"]                    = "Sync maintenant",
    ["info_rb_sync"]                    = "Aligne la largeur avec le EssentialCooldownViewer du Cooldown Manager Blizzard.",

    -- Text & Font
    ["section_text_font"]               = "Texte & Police",
    ["opt_rb_show_text"]                = "Afficher le texte sur les barres",
    ["opt_rb_text_align"]               = "Alignement du texte",
    ["align_left"]                      = "Gauche",
    ["align_center"]                    = "Centre",
    ["align_right"]                     = "Droite",
    ["opt_rb_font_size"]                = "Taille de police",
    ["opt_rb_font"]                     = "Police",
    ["font_default_wow"]                = "Défaut WoW",

    -- Position
    ["section_position"]                = "Position",
    ["info_rb_position"]                = "Utilisez /tm uf pour déverrouiller et déplacer les barres. La position est sauvegardée automatiquement.",
    ["info_rb_druid"]                   = "Les barres s'adaptent automatiquement à votre classe et spé.\nDruide : la ressource change selon la forme (Ours |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Rage, Chat |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Energy, Moonkin |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Astral Power).",

    -- =====================
    -- CONFIG: QOL Panel
    -- =====================
    -- Cinematic Skip
    -- QOL tabs
    ["tab_qol_cinematic"]               = "Cinématique",
    ["tab_qol_auto_quest"]              = "Auto Quêtes",
    ["tab_qol_automations"]             = "Automatisation",
    ["tab_qol_mythic_keys"]             = "Clés M+",
    ["tab_qol_skyride"]                 = "SkyRide",
    ["tab_qol_action_bars"]             = "Barres d'action",
    ["section_action_bars"]             = "Skin barres d'action",
    ["section_ab_system"]               = "Syst\195\168me de barres d'action",
    ["opt_ab_system_enable"]            = "Activer le syst\195\168me de barres d'action TomoMod (n\195\169cessite reload)",
    ["opt_ab_system_reload"]            = "D\195\169sactiver restaure enti\195\168rement les barres Blizzard apr\195\168s /reload.",
    ["section_ab_skin"]                 = "Skin visuel",

    -- ActionBars: LibKeyBound integration (Lot A9)
    ["btn_ab_kb_lib"]                       = "Mode assignation (LibKeyBound)",
    ["info_ab_kb_lib"]                      = "Mode d'assignation partagé, détecté depuis un autre addon. Assigne les barres de TomoMod et celles de cet addon dans la même passe.",

    -- ActionBars: keybinding command labels (Lot A8)
    ["binding_category"]                    = "Barres d'action TomoMod",
    ["binding_bar_header"]                  = "Barre TomoMod %d",
    ["binding_button"]                      = "Barre %d Bouton %d",

    ["options_load_failed"]             = "panneau d'options indisponible — l'addon TomoModForever_Options est-il activé ?",

    ["anchor_queue"]                    = "Œil de file d'attente",

    ["microbar_native_not_found"]       = "impossible de trouver le micro-menu de Blizzard à masquer — signalez-le avec votre version du client.",

    ["microbar_tt_perf"]                    = "Performances",
    ["microbar_tt_fps"]                     = "Images par seconde",
    ["microbar_tt_latency"]                 = "Latence",
    ["microbar_tt_cpu"]                     = "CPU des addons",
    ["microbar_tt_cpu_off"]                 = "profilage désactivé",

    -- ActionBars: rebuilt panel on the Tui schema (lot P5)
    ["section_ab_totem"]                 = "Totems",
    ["opt_ab_totem_enabled"]             = "Barre de totems",
    ["info_ab_totem"]                    = "Une barre affichant vos totems actifs et leur durée restante. Positionnez-la en mode disposition.",
    ["mover_totembar"]                  = "Barre de totems",
    ["opt_ab_flash"]                    = "Effet à l'appui",
    ["info_ab_flash"]                   = "Ce qui s'affiche quand un bouton est maintenu enfoncé. La texture TomoMod assombrit l'icône ; celle de Blizzard est le flash standard du jeu.",
    ["info_ab_masque"]                      = "Sans effet si Masque n'est pas installé. L'habillage intégré est alors désactivé pour éviter que les deux se marchent dessus.",
    ["info_ab_nodb"]                        = "Réglages des barres d'action indisponibles : la base de données n'est pas initialisée. Rechargez l'interface.",
    ["opt_ab_assisted"]                     = "Surbrillance assistée",
    ["opt_ab_backdrop"]                     = "Fond",
    ["opt_ab_backdrop_alpha"]               = "Opacité du fond",
    ["opt_ab_borders"]                      = "Bordures",
    ["opt_ab_gloss"]                        = "Brillance",
    ["opt_ab_gloss_alpha"]                  = "Opacité de la brillance",
    ["opt_ab_glow_color"]                   = "Couleur du glow",
    ["opt_ab_glow_source"]                  = "Source du glow",
    ["opt_ab_hide_empty"]                   = "Masquer les cases vides",
    ["opt_ab_hide_empty_keybinds"]          = "Masquer la touche sur les cases vides",
    ["opt_ab_icon_size"]                    = "Taille des boutons",
    ["opt_ab_icon_skin"]                    = "Habillage des icônes",
    ["opt_ab_keydown"]                      = "Lancer à l'appui de la touche",
    ["opt_ab_lock"]                         = "Verrouiller les boutons",
    ["opt_ab_mana_color"]                   = "Couleur ressource insuffisante",
    ["opt_ab_masque"]                       = "Laisser Masque habiller les boutons",
    ["opt_ab_range"]                        = "Indicateur hors de portée",
    ["opt_ab_range_color"]                  = "Couleur hors de portée",
    ["opt_ab_skin_enabled"]                 = "Habiller les boutons",
    ["opt_ab_spacing"]                      = "Espacement",
    ["opt_ab_tooltips"]                     = "Afficher les infobulles",
    ["opt_ab_usability"]                    = "Indicateur inutilisable",
    ["opt_ab_usability_color"]              = "Couleur inutilisable",
    ["opt_abf_combat"]                      = "Toujours visible en combat",
    ["opt_abf_delay"]                       = "Délai avant estompage",
    ["opt_abf_enabled"]                     = "Estomper les barres",
    ["opt_abf_in"]                          = "Durée d'apparition",
    ["opt_abf_link"]                        = "Lier les barres 1 à 8",
    ["opt_abf_out"]                         = "Durée de disparition",
    ["opt_abf_out_alpha"]                   = "Opacité estompée",
    ["opt_abt_anchor"]                      = "Position",
    ["opt_abt_color"]                       = "Couleur",
    ["opt_abt_cooldowntext"]                = "Chiffres de recharge",
    ["opt_abt_counts"]                      = "Charges et piles",
    ["opt_abt_keybinds"]                    = "Raccourcis",
    ["opt_abt_macronames"]                  = "Noms de macro",
    ["opt_abt_offx"]                        = "Décalage horizontal",
    ["opt_abt_offy"]                        = "Décalage vertical",
    ["opt_abt_show"]                        = "Afficher",
    ["opt_abt_size"]                        = "Taille de police",
    ["opt_bar_buttons"]                     = "Nombre de boutons",
    ["opt_bar_grow_left"]                   = "Croître vers la gauche",
    ["opt_bar_grow_up"]                     = "Croître vers le haut",
    ["opt_bar_size"]                        = "Taille des boutons",
    ["section_ab_behaviour"]                = "Comportement",
    ["section_ab_chrome"]                   = "Cadre et fond",
    ["section_ab_fade"]                     = "Fondu",
    ["section_ab_general"]                  = "Boutons",
    ["section_ab_states"]                   = "États",
    ["tab_ab_fade"]                         = "Fondu",
    ["tab_ab_general"]                      = "Général",
    ["tab_ab_indicators"]                   = "Indicateurs",
    ["tab_ab_texts"]                        = "Textes",

    -- ActionBars: rebuild notice (lot P4)
    ["info_ab_rebuilding"]              = "Les barres d'action sont en cours de reconstruction sur un nouveau moteur. Leurs réglages reviennent à la prochaine mise à jour ; les barres elles-mêmes fonctionnent normalement entre-temps.",

    -- ActionBars: config tab labels (Lot A7)
    ["tab_abs_buttons"]                     = "Boutons",
    ["tab_abs_glow"]                        = "Glow",
    ["tab_abs_hotkeys"]                     = "Raccourcis",

    -- ActionBars: TomoMod-owned buttons (Lot A6)
    ["opt_bar_own_buttons"]                 = "Boutons TomoMod (expérimental)",
    ["info_bar_own_buttons"]                = "Remplace les boutons Blizzard par ceux de TomoMod sur cette barre. Nécessite /reload. Les flyouts (portails, pièges, flacons) et la surbrillance assistée ne sont pas encore gérés.",

    -- ActionBars: special bars (stances, pet, state decoration)
    ["section_ab_special"]                  = "Postures, familier & états",
    ["opt_ab_sp_active"]                    = "Surligner l'action active",
    ["opt_ab_sp_active_color"]              = "Couleur active",
    ["opt_ab_sp_equipped"]                  = "Surligner les objets équipés",
    ["opt_ab_sp_equipped_color"]            = "Couleur équipé",
    ["opt_ab_sp_thickness"]                 = "Épaisseur du surlignage",
    ["opt_ab_sp_autocast"]                  = "Scintillement d'incantation auto",
    ["opt_ab_sp_autocast_color"]            = "Couleur de l'incantation auto",
    ["opt_ab_sp_pet_autohide"]              = "Masquer la barre de familier sans familier",
    ["info_ab_sp_pet_autohide"]             = "La masque tant que vous n'avez aucun familier. Les postures n'ont pas de condition équivalente et restent gérées par Blizzard.",

    -- ActionBars: hotkey layer (keybind text, binding mode)
    ["section_ab_hotkey"]                   = "Raccourcis",
    ["opt_ab_hk_enable"]                    = "Afficher les raccourcis",
    ["opt_ab_hk_abbrev"]                    = "Abréger",
    ["opt_ab_hk_size"]                      = "Taille de police",
    ["opt_ab_hk_anchor"]                    = "Position",
    ["opt_ab_hk_offx"]                      = "Décalage horizontal",
    ["opt_ab_hk_offy"]                      = "Décalage vertical",
    ["opt_ab_hk_color"]                     = "Couleur du texte",
    ["opt_ab_hk_hide_empty"]                = "Masquer sur les cases vides",
    ["btn_ab_hk_bind"]                      = "Mode assignation",
    ["info_ab_hk_bind"]                     = "Assigner les touches directement sur les barres. Indisponible en combat.",
    ["hotkey_bind_enter"]                   = "Mode assignation : survolez un bouton et appuyez sur une touche. Clic droit ou Échap efface.",
    ["hotkey_bind_exit"]                    = "Mode assignation fermé, raccourcis enregistrés.",
    ["hotkey_combat_blocked"]               = "Le mode assignation est indisponible en combat.",

    -- ActionBars: glow layer (procs, rotation hint)
    ["section_ab_glow"]                     = "Surbrillance (procs & rotation)",
    ["opt_ab_glow_proc"]                    = "Glow sur proc",
    ["opt_ab_glow_proc_type"]               = "Style du glow de proc",
    ["opt_ab_glow_proc_color"]              = "Couleur du glow de proc",
    ["opt_ab_glow_assist"]                  = "Glow sur suggestion de rotation",
    ["opt_ab_glow_assist_type"]             = "Style du glow de rotation",
    ["opt_ab_glow_assist_color"]            = "Couleur du glow de rotation",
    ["info_ab_glow_assist"]                 = "Suit la recommandation de l'Assistance de combat de Blizzard. Nécessite que la fonction soit disponible sur votre personnage.",
    ["opt_ab_glow_lines"]                   = "Pixel : nombre de lignes",
    ["opt_ab_glow_freq"]                    = "Vitesse d'animation",
    ["opt_ab_glow_thickness"]               = "Pixel : épaisseur des lignes",

    -- ActionBars: render layer (icons, cooldowns, texts)
    ["section_ab_icons"]                    = "Icônes & recharges",
    ["opt_ab_cd_backend"]                   = "Source des recharges",
    ["info_ab_cd_managed"]                  = "Gérée : TomoMod dessine lui-même la recharge. Nécessaire aux futurs boutons TomoMod ; la source Blizzard reste plus sûre pour l'instant.",
    ["opt_ab_cd_numbers"]                   = "Chiffres de recharge",
    ["opt_ab_cd_size"]                      = "Taille des chiffres",
    ["opt_ab_swipe_color"]                  = "Couleur du balayage",
    ["opt_ab_swipe_alpha"]                  = "Opacité du balayage",
    ["opt_ab_show_count"]                   = "Afficher charges / piles",
    ["opt_ab_count_size"]                   = "Taille du texte de charges",
    ["opt_ab_show_macro"]                   = "Afficher le nom de macro",
    ["opt_ab_desat_unusable"]               = "Désaturer si inutilisable",
    ["opt_ab_icon_zoom"]                    = "Recadrage de l'icône",
    ["cat_action_bars"]                 = "Barres d'action",
    ["opt_abs_enable"]                  = "Activer le skin des barres d'action",
    ["opt_abs_class_color"]             = "Couleur de classe pour les bordures",
    ["opt_abs_shift_reveal"]            = "Maintenir Shift pour révéler les barres masquées",
    ["sublabel_bar_opacity"]            = "— Opacité par barre —",
    ["opt_abs_select_bar"]              = "Sélectionner la barre",
    ["btn_abs_apply_all_opacity"]       = "Appliquer à toutes les barres",
    ["msg_abs_all_opacity"]             = "Opacité définie à %d%% sur toutes les barres",
    ["sublabel_bar_combat"]             = "— Visibilité en combat —",
    ["opt_abs_combat_show"]             = "Afficher uniquement en combat",

    ["section_cinematic"]               = "Passer les cinématiques",
    ["opt_cinematic_auto_skip"]         = "Skip automatique après 1ère vue",
    ["info_cinematic_viewed"]           = "Cinématiques déjà vues: %s\nL'historique est partagé entre personnages.",
    ["btn_clear_history"]               = "Effacer l'historique",

    -- Auto Quest
    ["section_auto_quest"]              = "Quêtes automatiques",
    ["opt_quest_auto_accept"]           = "Auto-accepter les quêtes",
    ["opt_quest_auto_turnin"]           = "Auto-compléter les quêtes",
    ["opt_quest_auto_gossip"]           = "Auto-sélectionner les dialogues",
    ["info_quest_shift"]                = "Maintenez SHIFT pour désactiver temporairement.\nLes quêtes avec choix multiples ne sont pas auto-complétées.",

    -- Objective Tracker Skin
    ["tab_qol_obj_tracker"]             = "Objectifs",
    ["section_obj_tracker"]             = "Affichage du Suivi d'Objectifs",
    ["opt_obj_tracker_enable"]          = "Activer l'affichage du Suivi d'Objectifs",
    ["opt_obj_tracker_bg_alpha"]        = "Opacité du fond",
    ["opt_obj_tracker_border"]          = "Afficher la bordure",
    ["opt_obj_tracker_hide_empty"]      = "Masquer si vide",
    ["opt_obj_tracker_buckets"]         = "Grouper les quêtes par catégories repliables",
    ["opt_obj_tracker_header_size"]     = "Taille police en-tête",
    ["opt_obj_tracker_cat_size"]        = "Taille police catégorie",
    ["opt_obj_tracker_quest_size"]      = "Taille police titre quête",
    ["opt_obj_tracker_obj_size"]        = "Taille police objectif",
    ["opt_obj_tracker_max_quests"]       = "Quêtes affichées max (0 = illimité)",
    ["ot_overflow_text"]                 = "%d quête(s) masquée(s)...",
    ["info_obj_tracker"]                = "Applique un affichage sombre au Suivi d'Objectifs Blizzard avec un panneau, des polices personnalisées et des catégories colorées.",
    ["ot_header_title"]                 = "OBJECTIFS",
    ["ot_collapse_all"]                  = "Tout réduire",
    ["ot_expand_all"]                    = "Tout déplier",
    ["ot_header_options"]               = "Options",
    ["ot_bucket_complete"]              = "À rendre",
    ["ot_bucket_campaign"]              = "Campagne",
    ["ot_bucket_important"]             = "Important",
    ["ot_bucket_legendary"]             = "Légendaire",
    ["ot_bucket_weekly"]                = "Hebdomadaire",
    ["ot_bucket_daily"]                 = "Quotidien",
    ["ot_bucket_world"]                 = "Quêtes du monde",
    ["ot_bucket_dungeon"]               = "Donjons",
    ["ot_bucket_raid"]                  = "Raids",
    ["ot_bucket_profession"]            = "Métiers",
    ["ot_bucket_achievement"]           = "Hauts faits",
    ["ot_bucket_quests"]                = "Quêtes",
    ["ot_bucket_other"]                 = "Autres",

    -- Automatisations
    ["section_automations"]             = "Automatisations",
    ["opt_hide_blizzard_castbar"]       = "Cacher la barre de cast Blizzard",
    ["opt_hide_talking_head"]           = "Masquer le Talking Head (dialogues de d\195\169filement)",
    ["opt_hide_status_bar2"]            = "Masquer la barre d'état 2 de Blizzard",
    ["opt_hide_status_bar2_desc"]       = "Rend invisible et non cliquable la seconde barre d'état du mode édition. Elle reste celle de Blizzard, donc toujours présente dans son mode édition.",

    -- Auto Accept Invite
    ["sublabel_auto_accept_invite"]     = "— Acceptation auto. des invitations —",
    ["sublabel_auto_skip_role"]         = "— Validation auto. de l'appel de rôle —",
    ["sublabel_tooltip_ids"]            = "— Tooltip IDs —",
    ["sublabel_combat_res_tracker"]     = "— Combat Res Tracker —",
    ["opt_cr_show_rating"]              = "Afficher le score M+",
    ["opt_show_messages"]               = "Afficher les messages chat",
    ["opt_tid_spell"]                   = "ID Sort / Aura",
    ["opt_tid_item"]                    = "ID Objet",
    ["opt_tid_npc"]                     = "ID PNJ",
    ["opt_tid_quest"]                   = "ID Quête",
    ["opt_tid_mount"]                   = "ID Monture",
    ["opt_tid_currency"]                = "ID Devise",
    ["opt_tid_achievement"]             = "ID Haut fait",
    ["opt_accept_friends"]              = "Accepter des amis",
    ["opt_accept_guild"]                = "Accepter de la guilde",

    -- Auto Summon
    ["sublabel_auto_summon"]            = "— Acceptation auto. des invocations —",
    ["opt_summon_delay"]                = "Délai (secondes)",

    -- Auto Fill Delete
    ["sublabel_auto_fill_delete"]       = "— Auto EFFACER —",
    ["opt_focus_ok_button"]             = "Focus sur OK après remplissage",

    -- Auto Vendor / Repair
    ["sublabel_auto_vendor_repair"]     = "— Auto Vendeur / Réparation —",
    ["opt_avr_auto_repair"]             = "Réparation auto chez le marchand",
    ["opt_avr_sell_grays"]              = "Vente auto des objets gris",

    -- Mythic+ Keys
    ["section_mythic_keys"]             = "Clés Mythic+",
    ["opt_keys_enable_tracker"]         = "Activer le tracker",
    ["opt_keys_mini_frame"]             = "Mini-frame sur l'UI M+",
    ["opt_keys_auto_refresh"]           = "Actualisation automatique",

    -- SkyRide
    ["section_skyride"]                 = "Vol Dynamique",
    ["opt_skyride_enable"]              = "Activer (affichage en vol)",
    ["section_skyride_dims"]            = "Dimensions",
    ["opt_skyride_bar_height"]          = "Hauteur barre vitesse",
    ["opt_skyride_charge_height"]       = "Hauteur cases charge",
    ["opt_skyride_charge_gap"]          = "Espace entre segments",
    ["section_skyride_text"]            = "Texte",
    ["opt_skyride_show_speed_text"]     = "Afficher le % de vitesse",
    ["opt_skyride_speed_font_size"]     = "Taille police vitesse",
    ["opt_skyride_show_charge_timer"]   = "Afficher le timer de charge",
    ["opt_skyride_charge_font_size"]    = "Taille police timer charge",
    ["btn_reset_skyride"]               = "Réinitialiser la position du Vol",

    -- =====================
    -- CONFIG: QOL — CVar Optimizer
    -- =====================
    ["tab_qol_cvar_opt"]                = "Perf CVars",
    ["section_cvar_optimizer"]          = "Optimisation CVars",
    ["info_cvar_optimizer"]             = "Applique les réglages graphiques/performance recommandés. Vos valeurs actuelles sont sauvegardées et restaurables à tout moment.",
    ["btn_cvar_apply_all"]              = ">> Tout appliquer",
    ["btn_cvar_revert_all"]             = "<< Tout restaurer",
    ["btn_cvar_apply"]                  = "Appliquer",
    ["btn_cvar_revert"]                 = "Restaurer",
    -- Catégories
    ["opt_cat_render"]                  = "Rendu & Affichage",
    ["opt_cat_graphics"]                = "Qualité Graphique",
    ["opt_cat_detail"]                  = "Distance de vue & Détails",
    ["opt_cat_advanced"]                = "Avancé",
    ["opt_cat_fps"]                     = "Limites FPS",
    ["opt_cat_post"]                    = "Post-traitement",
    -- Labels CVars
    ["opt_cvar_render_scale"]           = "Échelle de rendu",
    ["opt_cvar_vsync"]                  = "VSync",
    ["opt_cvar_msaa"]                   = "Multisampling (MSAA)",
    ["opt_cvar_low_latency"]            = "Mode basse latence",
    ["opt_cvar_anti_aliasing"]          = "Anti-aliasing",
    ["opt_cvar_shadow"]                 = "Qualité des ombres",
    ["opt_cvar_ssao"]                   = "SSAO",
    ["opt_cvar_depth"]                  = "Effets de profondeur",
    ["opt_cvar_compute"]                = "Effets calculés",
    ["opt_cvar_particle"]               = "Densité de particules",
    ["opt_cvar_liquid"]                 = "Détail des liquides",
    ["opt_cvar_spell_density"]          = "Densité des sorts",
    ["opt_cvar_projected"]              = "Textures projetées",
    ["opt_cvar_outline"]                = "Mode contour",
    ["opt_cvar_texture_res"]            = "Résolution des textures",
    ["opt_cvar_view_distance"]          = "Distance de vue",
    ["opt_cvar_env_detail"]             = "Détail de l'environnement",
    ["opt_cvar_ground"]                 = "Végétation au sol",
    ["opt_cvar_gfx_api"]                = "API graphique",
    ["opt_cvar_triple_buffering"]       = "Triple buffering",
    ["opt_cvar_texture_filtering"]      = "Filtrage de texture",
    ["opt_cvar_rt_shadows"]             = "Ombres ray-tracées",
    ["opt_cvar_resample_quality"]       = "Qualité de rééchantillonnage",
    ["opt_cvar_physics"]                = "Niveau de physique",
    ["opt_cvar_target_fps"]             = "FPS cible",
    ["opt_cvar_bg_fps_enable"]          = "Limite FPS en arrière-plan",
    ["opt_cvar_bg_fps"]                 = "Valeur FPS arrière-plan",
    ["opt_cvar_resample_sharpness"]     = "Netteté",
    ["opt_cvar_camera_shake"]           = "Tremblement de caméra",
    -- Messages
    ["msg_cvar_applied"]                = "CVars appliqués",
    ["msg_cvar_reverted"]               = "CVars restaurés",
    ["msg_cvar_no_backup"]              = "Aucune sauvegarde trouvée — appliquez d'abord.",
    ["tab_qol_leveling"]                = "Montée de niveau",
    ["section_leveling_bar"]            = "Barre de Leveling",
    ["opt_leveling_enable"]             = "Activer la barre de leveling",
    ["opt_leveling_width"]              = "Largeur de la barre",
    ["opt_leveling_height"]             = "Hauteur de la barre",
    ["btn_reset_leveling_pos"]          = "Réinitialiser la position",
    ["leveling_bar_title"]              = "Barre de Leveling",
    ["leveling_level"]                  = "Niveau",
    ["leveling_progress"]               = "Progression :",
    ["leveling_rested"]                 = "Reposé",
    ["leveling_last_quest"]             = "Dernière quête :",
    ["leveling_ttl"]                    = "Temps pour level :",
    ["leveling_remaining"]              = "Restant",
    ["leveling_session"]                = "Ce niveau",
    ["leveling_drag_hint"]              = "/tm sr pour débloquer & déplacer",

    -- =====================
    -- CONFIG: Profiles Panel (3 Onglets)
    -- =====================
    -- Labels des onglets
    ["tab_profiles"]                    = "Profils",
    ["tab_import_export"]               = "Import/Export",
    ["tab_resets"]                      = "Réinitialisation",

    -- Onglet 1 : Mode de profil & spécialisations
    -- Tab 1: Profils nommés & spécialisations
    ["section_named_profiles"]          = "Profils",
    ["info_named_profiles"]             = "Créez et gérez des profils nommés. Chaque profil sauvegarde un instantané complet de vos paramètres.",
    ["profile_active_label"]            = "Profil actif",
    ["opt_select_profile"]              = "Choisir un profil",
    ["sublabel_create_profile"]         = "— Créer un Nouveau Profil —",
    ["placeholder_profile_name"]        = "Nom du profil...",
    ["btn_create_profile"]              = "Créer le Profil",
    ["btn_delete_named_profile"]        = "Supprimer le profil",
    ["btn_save_profile"]                = "Sauvegarder le Profil Actif",
    ["info_save_profile"]               = "Sauvegarde tous les paramètres actuels dans le profil actif. Ceci est fait automatiquement lors du changement de profil.",

    ["section_profile_mode"]            = "Mode de Profil",
    ["info_spec_profiles"]              = "Activez les profils par spécialisation pour sauvegarder et charger automatiquement vos paramètres quand vous changez de spé.\nChaque spé obtient sa propre configuration indépendante.",
    ["opt_enable_spec_profiles"]        = "Activer les profils par spécialisation",
    ["profile_status"]                  = "Profil actif",
    ["profile_global"]                  = "Global (profil unique)",
    ["section_spec_list"]               = "Spécialisations",
    ["profile_badge_active"]            = "Actif",
    ["profile_badge_saved"]             = "Sauvegardé",
    ["profile_badge_none"]              = "Aucun profil",
    ["btn_copy_to_spec"]                = "Copier l'actuel",
    ["btn_delete_profile"]              = "Supprimer",
    ["info_spec_reload"]                = "Changer de spé avec les profils activés rechargera automatiquement votre UI pour appliquer le profil correspondant.",
    ["info_global_mode"]                = "Toutes les spécialisations partagent les mêmes paramètres. Activez les profils par spé ci-dessus pour utiliser des configs différentes.",

    -- Onglet 2 : Import / Export
    ["section_export"]                  = "Exporter les Paramètres",
    ["info_export"]                     = "Génère une chaîne compressée de tous vos paramètres actuels.\nCopiez-la pour la partager ou comme sauvegarde.",
    ["label_export_string"]             = "Chaîne d'export (cliquez pour tout sélectionner)",
    ["btn_export"]                      = "Générer la Chaîne d'Export",
    ["btn_copy_clipboard"]              = "Copier le Texte",
    ["section_import"]                  = "Importer des Paramètres",
    ["info_import"]                     = "Collez une chaîne d'export ci-dessous. Elle sera validée avant application.",
    ["label_import_string"]             = "Collez la chaîne d'import ici",
    ["btn_import"]                      = "Importer & Appliquer",
    ["btn_paste_clipboard"]             = "Coller le Texte",
    ["import_preview"]                  = "Classe: %s | Modules: %s | Date: %s",
    ["import_preview_valid"]            = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t Chaîne valide",
    ["import_preview_invalid"]          = "Chaîne invalide ou corrompue",
    ["info_import_warning"]             = "L'import va ÉCRASER tous vos paramètres actuels et recharger l'UI. Cette action est irréversible.",

    -- Onglet 3 : Réinitialisations
    ["section_profile_mgmt"]            = "Gestion des Profils",
    ["info_profiles"]                   = "Réinitialisez des modules individuellement ou exportez/importez vos paramètres.\nL'export copie vos settings dans le presse-papier (nécessite LibSerialize + LibDeflate).",
    ["section_reset_module"]            = "Réinitialiser un module",
    ["btn_reset_prefix"]                = "Réinitialiser: ",
    ["btn_reset_all_reload"]            = "TOUT Réinitialiser + Reload",
    ["section_reset_all"]               = "Réinitialisation Complète",
    ["info_resets"]                     = "Réinitialisez un module individuel à ses valeurs par défaut. Le module sera rechargé avec les paramètres d'usine.",
    ["info_reset_all_warning"]          = "Cela réinitialisera TOUS les modules et TOUS les paramètres aux valeurs d'usine, puis rechargera l'UI.",

    -- =====================
    -- PRINT MESSAGES: Core
    -- =====================
    ["msg_db_reset"]                    = "Base de données réinitialisée",
    ["msg_migration_failed"]           = "Une étape de migration de la base de données a échoué — merci de le signaler sur le Discord : ",
    ["msg_normalize_failed"]           = "La normalisation des éléments a échoué — merci de le signaler sur le Discord : ",
    ["msg_module_reset"]                = "Module '%s' réinitialisé",
    ["msg_db_not_init"]                 = "Base de données non initialisée",
    ["msg_loaded"]                      = "chargé — %s pour config",
    ["msg_report_issue"]                = "Si vous rencontrez un problème, merci de laisser un commentaire sur CurseForge.",
    ["at_rescue_header"]              = "Le suivi d\226\128\153aura a \195\169t\195\169 retir\195\169 ; CooldownForge couvre le m\195\170me besoin.",
    ["at_rescue_list"]                = "Sorts que tu avais ajout\195\169s \195\160 la main : %s",
    ["at_rescue_hint"]                = "Recr\195\169e-les dans le Cooldown Studio si tu veux toujours les suivre.",
    ["msg_help_title"]                  = "Commandes:",
    ["msg_help_open"]                   = "Ouvrir la configuration",
    ["msg_help_reset"]                  = "Réinitialiser tout + reload",
    ["msg_help_uf"]                     = "Verrouiller/Déverrouiller UnitFrames + Ressources",
    ["msg_help_uf_reset"]               = "Réinitialiser UnitFrames",
    ["msg_help_rb"]                     = "Verrouiller/Déverrouiller les barres de ressources",
    ["msg_help_rb_sync"]                = "Sync largeur avec Essential Cooldowns",
    ["msg_help_np"]                     = "Activer/Désactiver les Nameplates",
    ["msg_help_minimap"]                = "Réinitialiser la mini-carte",
    ["msg_help_panel"]                  = "Réinitialiser le panneau d'information",
    ["msg_help_cursor"]                 = "Réinitialiser l'anneau du curseur",
    ["msg_help_clearcinema"]            = "Effacer l'historique des cinématiques",
    ["msg_help_sr"]                     = "Toggle SkyRide + Anchors lock",
    ["msg_help_key"]                    = "Open Mythic+ Keys",
    ["msg_help_help"]                   = "Cette aide",

    -- =====================
    -- PRINT MESSAGES: Modules
    -- =====================
    -- CDM
    ["msg_cdm_status"]                  = "Activé",
    ["msg_cdm_disabled"]                = "Désactivé",

    -- Nameplates
    ["msg_np_enabled"]                  = "Activées",
    ["msg_np_disabled"]                 = "Désactivées",

    -- UnitFrames
    ["msg_uf_locked"]                   = "Verrouillé",
    ["msg_uf_unlocked"]                 = "Déverrouillé — Glissez pour repositionner",
    ["msg_uf_initialized"]              = "Initialisé — /tm uf pour lock/unlock",
    ["msg_uf_enabled"]                  = "activé (reload nécessaire)",
    ["msg_uf_disabled"]                 = "désactivé (reload nécessaire)",
    ["msg_uf_position_reset"]           = "position réinitialisée",

    -- ResourceBars
    ["msg_rb_width_synced"]             = "Largeur synchronisée (%dpx)",
    ["msg_rb_locked"]                   = "Verrouillé",
    ["msg_rb_unlocked"]                 = "Déverrouillé — Glissez pour repositionner",
    ["msg_rb_position_reset"]           = "Position des barres de ressources réinitialisée",

    -- SkyRide
    ["msg_sr_pos_saved"]                = "Position SkyRide sauvegardée",
    ["msg_sr_locked"]                   = "SkyRide verrouillée",
    ["msg_sr_unlock"]                   = "Mode déplacement SkyRide activé - Cliquez et glissez",
    ["msg_sr_pos_reset"]                = "Position SkyRide réinitialisée",
    ["msg_sr_db_not_init"]              = "TomoModForeverDB non initialisée",
    ["msg_sr_initialized"]              = "Module SkyRide initialisé",

    -- FrameAnchors
    ["anchor_alert"]                    = "Alertes",
    ["anchor_loot"]                     = "Loot",
    ["msg_anchors_locked"]              = "Verrouillés",
    ["msg_anchors_unlocked"]            = "Déverrouillés — déplacez les ancres",

    -- AutoVendorRepair
    ["msg_avr_sold"]                    = " Items gris vendus pour |cffffff00%s|r",
    ["msg_avr_repaired"]                = " Équipement réparé pour |cffffff00%s|r",

    -- AutoFillDelete
    ["msg_afd_filled"]                  = "Texte 'EFFACER' auto-rempli - Cliquez OK pour confirmer",
    ["msg_afd_db_not_init"]             = "TomoModForeverDB non initialisée",
    ["msg_afd_initialized"]             = "Module AutoFillDelete initialisé",
    ["msg_afd_enabled"]                 = "Auto-fill EFFACER activé",
    ["msg_afd_disabled"]                = "Auto-fill EFFACER désactivé (hook reste actif)",

    -- HideCastBar
    ["msg_hcb_db_not_init"]             = "TomoModForeverDB non initialisée",
    ["msg_hcb_initialized"]             = "Module HideCastBar initialisé",
    ["msg_hcb_hidden"]                  = "Barre de cast cachée",
    ["msg_hcb_shown"]                   = "Barre de cast affichée",

    -- AutoAcceptInvite
    ["msg_aai_accepted"]                = "Invitation acceptée de ",
    ["msg_aai_ignored"]                 = "Invitation ignorée de ",
    ["msg_aai_enabled"]                 = "Auto-accept invitations activé",
    ["msg_aai_disabled"]                = "Auto-accept invitations désactivé",
    ["msg_asr_lfg_accepted"]            = "Vérification de rôle auto-confirmée",
    ["msg_asr_poll_accepted"]           = "Sondage de rôle auto-confirmé",
    ["msg_asr_enabled"]                 = "Auto skip role check activé",
    ["msg_asr_disabled"]                = "Auto skip role check désactivé",
    ["msg_tid_enabled"]                 = "Tooltip IDs activé",
    ["msg_tid_disabled"]                = "Tooltip IDs désactivé",
    ["msg_cr_enabled"]                  = "Combat Res Tracker activé",
    ["msg_cr_disabled"]                 = "Combat Res Tracker désactivé",
    ["msg_cr_locked"]                   = "Combat Res Tracker verrouillé",
    ["msg_cr_unlock"]                   = "Combat Res Tracker déverrouillé — glissez pour déplacer",
    ["msg_abs_enabled"]                 = "Skin barres d'action activé (reload recommandé)",
    ["msg_abs_disabled"]                = "Skin barres d'action désactivé",
    ["opt_buffskin_enable"]             = "Activer le skin des buffs",
    ["opt_buffskin_desc"]               = "Ajoute un contour noir et un timer coloré sur les buffs/débuffs du joueur",
    ["msg_buffskin_enabled"]            = "Skin buffs activé",
    ["msg_buffskin_disabled"]           = "Skin buffs désactivé",
    ["msg_help_cr"]                     = "Verrouiller/déverrouiller le Combat Res Tracker",
    ["msg_help_cs"]                     = "Verrouiller/déverrouiller la feuille de personnage",
    ["msg_help_cs_reset"]               = "Réinitialiser la position de la feuille de personnage",

    -- CinematicSkip
    ["msg_cin_skipped"]                 = "Cinématique skippée (déjà vue)",
    ["msg_vid_skipped"]                 = "Vidéo skippée (déjà vue)",
    ["msg_vid_id_skipped"]              = "Vidéo #%d skippée",
    ["msg_cin_cleared"]                 = "Historique des cinématiques effacé",

    -- AutoSummon
    ["msg_sum_accepted"]                = "Summon accepté de %s vers %s (%s)",
    ["msg_sum_ignored"]                 = "Summon ignoré de %s (non fiable)",
    ["msg_sum_enabled"]                 = "Auto-summon activé",
    ["msg_sum_disabled"]                = "Auto-summon désactivé",
    ["msg_sum_manual"]                  = "Summon accepté manuellement",
    ["msg_sum_no_pending"]              = "Aucun summon en attente",

    -- MythicKeys
    ["msg_keys_no_key"]                 = "Aucune clé à envoyer.",
    ["msg_keys_not_in_group"]           = "Tu dois être en groupe.",
    ["msg_keys_reload"]                 = "Changement appliqué au prochain /reload.",
    ["mk_not_in_group"]                 = "Tu n'es pas en groupe.",
    ["mk_not_in_group_short"]           = "Pas en groupe.",
    ["mk_no_key_self"]                  = "Aucune clé trouvée.",
    ["mk_title"]                        = "TM — Mythic Keys",
    ["mk_btn_send"]                     = "Envoyer chat",
    ["mk_btn_refresh"]                  = "Refresh",
    ["mk_tab_keys"]                     = "Clés",
    ["mk_tab_tp"]                       = "TP",
    ["mk_tp_click_to_tp"]              = "Cliquer pour se téléporter",
    ["mk_tp_not_unlocked"]             = "Non débloqué",
    ["msg_tp_not_owned"]               = "Vous ne possédez pas le TP pour %s",
    ["msg_tp_combat"]                  = "Impossible de mettre à jour les TP en combat.",

    -- =====================
    -- PRINT MESSAGES: Config Panels
    -- =====================
    ["msg_np_reset"]                    = "Nameplates réinitialisées (reload recommandé)",
    ["msg_uf_toggle"]                   = "UnitFrames %s (reload)",
    ["msg_profile_reset"]               = "%s réinitialisé",
    ["msg_profile_copied"]              = "Paramètres actuels copiés vers '%s'",
    ["msg_profile_deleted"]             = "Profil supprimé pour '%s'",
    ["msg_profile_loaded"]              = "Profil '%s' chargé — rechargez pour appliquer",
    ["msg_profile_load_failed"]         = "Échec du chargement du profil '%s'",
    ["msg_profile_created"]             = "Profil '%s' créé avec les paramètres actuels",
    ["msg_profile_name_empty"]          = "Veuillez entrer un nom de profil",
    ["msg_profile_saved"]               = "Paramètres sauvegardés dans le profil '%s'",

    -- Nouvelles clés profils v2.3.0
    ["btn_rename_profile"]              = "Renommer",
    ["btn_duplicate_profile"]           = "Dupliquer",
    ["btn_load_profile"]                = "Charger",
    ["btn_close"]                       = "Fermer",
    ["btn_cancel"]                      = "Annuler",
    ["section_spec_assign"]             = "Profils par Spécialisation",
    ["info_spec_assign"]                = "Associez chaque spécialisation à un profil nommé. TomoMod chargera automatiquement le bon profil lors d'un changement de spé.",
    ["spec_profile_none"]               = "— Aucun —",
    ["popup_rename_profile"]            = "|cffffd100TomoModForever|r\n\nNouveau nom pour '%s' :",
    ["popup_duplicate_profile"]         = "|cffffd100TomoModForever|r\n\nDupliquer '%s' sous le nom :",
    ["msg_profile_renamed"]             = "Profil '%s' renommé en '%s'",
    ["msg_profile_duplicated"]          = "Profil '%s' dupliqué en '%s'",
    ["msg_import_as_profile"]           = "Profil importé sous le nom '%s'",
    ["popup_export_title"]              = "Exporter le Profil",
    ["popup_export_hint"]               = "Sélectionnez tout (Ctrl+A) et copiez (Ctrl+C)",
    ["popup_import_title"]              = "Importer un Profil",
    ["popup_import_hint"]               = "Collez une chaîne d'export TomoMod, puis cliquez sur Importer",
    ["label_import_profile_name"]       = "Sauvegarder sous le nom :",
    ["placeholder_import_profile_name"] = "Nom du profil (optionnel)...",
    ["msg_profile_name_deleted"]        = "Profil '%s' supprimé",
    ["msg_export_success"]              = "Chaîne d'export générée — sélectionnez tout et copiez",
    ["msg_import_success"]              = "Paramètres importés avec succès — rechargement...",
    ["msg_import_empty"]                = "Rien à importer — collez une chaîne d'abord",
    ["msg_copy_hint"]                   = "Texte sélectionné — appuyez sur Ctrl+C pour copier",
    ["msg_copy_empty"]                  = "Générez d'abord une chaîne d'export",
    ["msg_paste_hint"]                  = "Appuyez sur Ctrl+V pour coller votre chaîne d'import",
    ["msg_spec_changed_reload"]         = "Spécialisation changée — chargement du profil...",

    -- =====================
    -- INFO PANEL (Minimap)
    -- =====================
    ["time_server"]                     = "Serveur",
    ["time_local"]                      = "Locale",
    ["time_tooltip_title"]              = "Heure (%s - %s)",
    ["time_tooltip_left_click"]         = "|cffffd100Clic gauche:|r Calendrier",
    ["time_tooltip_right_click"]        = "|cffffd100Clic droit:|r Serveur / Locale",
    ["time_tooltip_shift_right"]        = "|cffffd100Shift + Clic droit:|r 12h / 24h",
    ["time_format_msg"]                 = "Format: %s",
    ["time_mode_msg"]                   = "Heure: %s",

    -- =====================
    -- ENABLED / DISABLED (generic)
    -- =====================
    ["enabled"]                         = "Activé",
    ["disabled"]                        = "Désactivé",

    -- Static Popups
    ["popup_reset_text"]                = "|cffffd100TomoModForever|r\n\nRéinitialiser TOUS les paramètres ?\nCela rechargera votre UI.",
    ["popup_confirm"]                   = "Confirmer",
    ["popup_cancel"]                    = "Annuler",
    ["popup_import_text"]               = "|cffffd100TomoModForever|r\n\nImporter les paramètres ?\nCela va ÉCRASER tous vos paramètres actuels et recharger l'UI.",
    ["popup_profile_reload"]            = "|cffffd100TomoModForever|r\n\nMode de profil modifié.\nRecharger l'UI pour appliquer ?",
    ["popup_delete_profile"]            = "|cffffd100TomoModForever|r\n\nSupprimer le profil '%s' ?\nCette action est irréversible.",

    -- FPS element
    ["label_fps"]                       = "FPS",

    -- =====================
    -- BOSS FRAMES
    -- =====================
    ["tab_boss"]                        = "Boss",
    ["section_boss_frames"]             = "Barres de Boss",
    ["opt_boss_enable"]                 = "Activer les barres de Boss",
    ["opt_boss_height"]                 = "Hauteur des barres",
    ["opt_boss_spacing"]                = "Espacement entre les barres",
    ["info_boss_drag"]                  = "Déverrouillez (/tm uf) pour déplacer. Glissez Boss 1 pour repositionner les 5 barres ensemble.",
    ["info_boss_colors"]                = "Les couleurs utilisent les couleurs de classification Nameplates (Boss = rouge, Mini-boss = violet).",
    ["msg_boss_initialized"]            = "Barres de Boss chargées.",

    -- =====================
    -- SOUND / LUST DETECTION
    -- =====================
    ["cat_sound"]                       = "Son",
    ["section_sound_general"]           = "Son de Bloodlust",
    ["info_sound_desc"]                 = "Joue un son personnalisé quand un effet de type Bloodlust est détecté sur votre personnage. La détection vérifie directement les buffs de Lust et les debuffs Sated/Exhaustion.",
    ["opt_sound_enable"]                = "Activer la détection de Bloodlust",
    ["sublabel_sound_choice"]           = "Son & Canal",
    ["opt_sound_file"]                  = "Son à jouer",
    ["opt_sound_channel"]               = "Canal audio",
    ["opt_sound_volume"]                = "Volume du canal audio",
    ["info_sound_volume"]               = "Modifie le volume global du canal sélectionné dans les réglages audio de WoW.",
    ["btn_sound_preview"]               = "Écouter le son",
    ["btn_sound_stop"]                  = "Arrêter",
    ["opt_sound_force"]                 = "Forcer le son même si le jeu est muet",
    ["opt_sound_chat"]                  = "Afficher les messages en chat",
    ["opt_sound_debug"]                 = "Mode debug",

    -- =====================
    -- BAG & MICRO MENU
    -- =====================
    ["tab_qol_bag_micro"]               = "Sac & Menu",
    ["section_bag_micro"]               = "Barre de sac & Micro Menu",
    ["info_bag_micro"]                  = "Choisissez d'afficher en permanence ou de révéler au survol de la souris.",
    ["sublabel_bag_bar"]                = "— Barre de sac —",
    ["sublabel_micro_menu"]             = "— Micro Menu —",
    ["opt_bag_bar_mode"]                = "Barre de sac",
    ["opt_micro_menu_mode"]             = "Micro Menu",
    ["mode_show"]                       = "Toujours visible",
    ["mode_hover"]                      = "Afficher au survol",

    -- =====================
    -- MICRO BAR
    -- =====================
    ["microbar_btn_character"]          = "Personnage",
    ["microbar_btn_spells"]             = "Talents & Grimoire",
    ["microbar_btn_profession"]         = "Métiers",
    ["microbar_btn_achievement"]        = "Hauts faits",
    ["microbar_btn_quest"]              = "Journal de quêtes",
    ["microbar_btn_guild"]              = "Guilde & Communautés",
    ["microbar_btn_lfd"]                = "Outil de groupe",
    ["microbar_btn_collections"]        = "Collections",
    ["microbar_btn_ej"]                 = "Guide d'aventure",
    ["microbar_btn_housing"]            = "Logement",
    ["microbar_btn_social"]             = "Social",
    ["microbar_btn_store"]              = "Boutique",
    ["microbar_btn_bags"]               = "Sacs",
    ["microbar_btn_mainmenu"]           = "Menu du jeu",
    ["microbar_tt_memory"]              = "Mémoire des addons",
    ["microbar_tt_total"]               = "Total",
    ["mover_microbar"]                  = "Micro Barre",
    ["section_microbar"]                = "Micro Barre",
    ["info_microbar"]                   = "Remplace le micro menu de Blizzard par une barre que vous pouvez dimensionner, réordonner et placer librement. Chaque bouton transmet son clic au bouton d'origine, tout continue donc de fonctionner en combat. Les icônes sont lues directement dans les ressources du jeu. Tant que cette option est active, le réglage Micro Menu ci-dessus ne s'applique plus.",
    ["opt_microbar_enable"]             = "Activer la Micro Barre",
    ["opt_microbar_lfg_eye"]                = "Œil de recherche de groupe",
    ["opt_microbar_lfg_eye_scale"]          = "Taille de l'œil",
    ["info_microbar_lfg_eye"]               = "Détaché du micro-menu Blizzard pour survivre à son masquage. Placez-le en mode disposition.",
    ["opt_microbar_hide_native"]        = "Masquer le micro menu de Blizzard",
    ["opt_microbar_buttons"]            = "Boutons & ordre",
    ["opt_microbar_orientation"]        = "Orientation",
    ["opt_microbar_per_line"]           = "Boutons par ligne (0 = une seule ligne)",
    ["opt_microbar_icon_size"]          = "Taille des icônes",
    ["opt_microbar_spacing"]            = "Espacement",
    ["opt_microbar_scale"]              = "Échelle",
    ["opt_microbar_alpha"]              = "Opacité",
    ["opt_microbar_fade_mode"]          = "Visibilité",
    ["opt_microbar_fade_alpha"]         = "Opacité estompée",
    ["opt_microbar_color_mode"]         = "Couleur des icônes",
    ["opt_microbar_color"]              = "Couleur personnalisée",
    ["opt_microbar_desaturate"]         = "Désaturer les icônes",
    ["opt_microbar_hover_zoom"]         = "Agrandir l'icône au survol",
    ["opt_microbar_memory_tooltip"]     = "Afficher la mémoire des addons sur le bouton menu",
    ["microbar_orient_h"]               = "Horizontale",
    ["microbar_orient_v"]               = "Verticale",
    ["microbar_fade_always"]            = "Toujours visible",
    ["microbar_fade_hover"]             = "Afficher au survol",
    ["microbar_fade_hovercombat"]       = "Au survol, toujours en combat",
    ["microbar_color_class"]            = "Classe",
    ["microbar_color_custom"]           = "Personnalisée",
    ["microbar_color_native"]           = "Origine",
    ["btn_microbar_place"]              = "Placer la barre",
    ["btn_microbar_reset_pos"]          = "Réinitialiser la position",
    ["section_microbar_states"]         = "Micro Barre — États natifs",
    ["info_microbar_states"]            = "Les boutons d'origine continuent de tourner sous la barre : leurs alertes, leurs états grisés et leurs raccourcis restent actifs. Ces options les reportent sur vos propres boutons.",
    ["opt_microbar_alert_style"]        = "Halo d'alerte",
    ["opt_microbar_alert_color"]        = "Couleur d'alerte",
    ["opt_microbar_dim_disabled"]       = "Estomper les boutons indisponibles",
    ["opt_microbar_disabled_alpha"]     = "Opacité estompée",
    ["opt_microbar_show_keybind"]       = "Afficher les raccourcis sur les icônes",
    ["opt_microbar_keybind_size"]       = "Taille du texte des raccourcis",
    ["microbar_glow_none"]              = "Aucun",
    ["microbar_glow_pixel"]             = "Halo pixel",
    ["microbar_glow_autocast"]          = "Halo tournoyant",
    ["microbar_glow_button"]            = "Halo de bouton d'action",
    ["microbar_glow_proc"]              = "Halo de proc",

    -- =====================
    -- CHARACTER SKIN
    -- =====================
    ["tab_qol_char_skin"]               = "Skin Personnage",
    ["section_char_skin"]               = "Skin de la fiche personnage",
    ["info_char_skin_desc"]             = "Applique le thème sombre TomoMod à la fiche personnage, la réputation, les monnaies et la fenêtre d'inspection.",
    ["opt_char_skin_enable"]            = "Activer le skin personnage",
    ["opt_char_skin_character"]         = "Skin Personnage / Réputation / Monnaies",
    ["opt_char_skin_inspect"]           = "Skin fenêtre d'inspection",
    ["opt_char_skin_inspect_iteminfo"]  = "Afficher niveau d'objet, enchantements et gemmes à l'inspection",
    ["opt_char_skin_iteminfo"]          = "Afficher les infos d'objet sur les emplacements",
    ["opt_char_skin_gems"]              = "Afficher les gemmes sur les emplacements",
    ["opt_char_skin_midnight"]          = "Enchantements Midnight (Tête/Épaules au lieu de Brassard/Cape)",
    ["opt_char_skin_scale"]             = "Échelle de la fenêtre",
    ["msg_char_skin_reload"]            = "Skin Personnage : /reload pour appliquer.",

    -- =====================
    -- LAYOUT / MOVERS SYSTEM
    -- =====================
    ["btn_layout"]                      = "EditMode",
    ["btn_layout_tooltip"]              = "EditMode : déverrouille tous les éléments pour les déplacer.",
    ["btn_reload_ui"]                   = "Recharger l'UI",
    ["layout_mode_title"]               = "TomoMod — EditMode",
    ["layout_mode_hint"]                = "Glissez les éléments pour les repositionner — cliquez Verrouiller quand c'est fait",
    ["layout_btn_lock"]                 = "Verrouiller",
    ["layout_btn_reload"]               = "RL",
    ["layout_btn_gui"]                  = "GUI",
    ["grid_dimmed"]                    = "Grille",
    ["grid_bright"]                    = "Grille +",
    ["grid_disabled"]                  = "Grille OFF",
    ["layout_unlocked"]                 = "EditMode ACTIF — glissez les éléments. Cliquez Verrouiller ou /tm layout pour finir.",
    ["layout_snap_on"]                   = "Aimant : ON",
    ["layout_snap_off"]                  = "Aimant : OFF",
    ["layout_nudger_hint"]               = "Cliquez ou déplacez un élément pour ouvrir TomoLayout. Maj : placer sans aimant.",
    ["layout_locked"]                   = "EditMode DÉSACTIVÉ — positions sauvegardées.",
    ["msg_help_layout"]                 = "Basculer l'EditMode (déplacer tous les éléments UI)",
    ["mover_unitframes"]                = "Unit Frames",
    ["mover_resources"]                 = "Barres de ressources",
    ["mover_skyriding"]                 = "Barre Skyriding",
    ["mover_levelingbar"]               = "Barre XP / Expérience",
    ["mover_anchors"]                   = "Ancres Alertes & Butin",
    ["mover_cotank"]                    = "Suivi Co-Tank",
    ["mover_repbar"]                    = "Barre de réputation",
    ["mover_castbar"]                   = "Barre de cast (joueur)",
    ["mover_mythictracker"]             = "Tracker M+",
    ["mover_minimap"]                   = "Minimap & Panel",
    ["mover_objectivetracker"]          = "Suivi des quêtes",
    ["mover_chatframe"]                 = "Fenêtre de chat",
    -- =====================
    -- COMBAT TEXT
    -- =====================
    ["sublabel_combat_text"]             = "— Texte de combat —",
    ["opt_combat_text_enable"]           = "Activer le texte de combat",
    ["opt_combat_text_offset_x"]         = "Décalage X",
    ["opt_combat_text_offset_y"]         = "Décalage Y",

    -- =====================
    -- PREY TRACKER
    -- =====================
    ["sublabel_prey_tracker"]            = "— Traqueur de proie —",
    ["opt_prey_tracker_enable"]          = "Activer le Traqueur de proie",
    ["opt_prey_tracker_width"]           = "Largeur",
    ["opt_prey_tracker_font"]            = "Taille de police",
    ["info_prey_tracker"]                = "Fonctionnalité exclusive à Midnight. Affiche une barre de progression déplaçable pendant une chasse Prey active. Positionnez-la via /tm layout.",

    -- =====================
    -- SKINS (Chat)
    -- =====================
    ["tab_qol_skins"]                    = "Skins",
    ["section_skins"]                    = "Skins d'interface",
    ["info_skins_desc"]                  = "Applique le thème sombre TomoMod à divers éléments de l'interface Blizzard. Un /reload peut être nécessaire pour revenir en arrière.",
    ["sublabel_chat_skin"]               = "— Fenêtre de chat —",
    ["opt_chat_skin_enable"]             = "Skin de la fenêtre de chat",
    ["opt_chat_skin_style"]              = "Style du skin",
    ["opt_chat_skin_style_tui"]          = "TUI (Barre latérale + Fenêtre)",
    ["opt_chat_skin_style_classic"]      = "Classique (Encadré)",
    ["opt_chat_skin_style_glass"]        = "Verre (Givré)",
    ["opt_chat_skin_style_minimal"]      = "Minimal (Sans bordure)",
    ["opt_chat_skin_bg_alpha"]           = "Opacité du cadre",
    ["opt_chat_message_bg_alpha"]        = "Opacité de la zone des messages",
    ["opt_chat_skin_font_size"]          = "Taille de police du chat",
    ["opt_chat_skin_fade"]               = "Masquer le chat en cas d'inactivité",
    ["opt_chat_skin_short_channels"]     = "Noms de canaux abrégés (G, P, R…)",
    ["opt_chat_skin_timestamp"]          = "Afficher les horodatages",
    ["opt_chat_skin_url"]                = "URLs cliquables",
    ["opt_chat_skin_emoji"]              = "Remplacer les émoticônes par des emoji",
    ["opt_chat_skin_class_colors"]       = "Noms colorés par classe dans le chat",
    ["opt_chat_copy_button"]             = "Bouton de copie sur la fenêtre de chat",
    ["opt_chat_copy_button_always"]      = "Toujours visible",
    ["opt_chat_copy_button_hover"]       = "Au survol",
    ["opt_chat_copy_button_hidden"]      = "Masqué",
    ["chat_copy_title"]                  = "Copier le texte du chat",
    ["chat_copy_hint"]                   = "Tout sélectionner (Ctrl+A) puis copier (Ctrl+C)",
    ["chat_copy_select_all"]             = "Tout sélectionner",
    ["chat_copy_close"]                  = "Fermer",
    ["chat_copy_empty"]                  = "Aucun message copiable dans cette fenêtre.",
    ["chat_copy_url_title"]              = "Appuyez sur Ctrl+C pour copier",
    ["opt_chat_skin_history"]               = "Restaurer l'historique du chat à la connexion",
    ["chat_history_section"]                = "Historique du chat",
    ["opt_chat_skin_history_info"]          = "Décocher arrête l'enregistrement ET efface ce qui est déjà stocké. L'historique est enregistré pour tout le compte : il est donc partagé par tous les personnages.",
    ["opt_chat_history_max_age"]            = "Conserver les messages pendant",
    ["opt_chat_history_age_1h"]             = "1 heure",
    ["opt_chat_history_age_6h"]             = "6 heures",
    ["opt_chat_history_age_24h"]            = "24 heures",
    ["opt_chat_history_age_3d"]             = "3 jours",
    ["opt_chat_history_age_unlimited"]      = "Sans limite",
    ["opt_chat_history_max_lines"]          = "Nombre de lignes conservées",
    ["opt_chat_history_delay"]              = "Délai avant restauration",
    ["opt_chat_history_delay_info"]         = "Attendre quelques secondes laisse les messages de chargement des addons et les erreurs Lua s'afficher d'abord, au lieu d'être noyés sous l'historique restauré.",
    ["opt_chat_history_separator"]          = "Afficher un repère de session",
    ["opt_chat_history_separator_info"]     = "Affiche une ligne après l'historique restauré : tout ce qui suit provient clairement de la session en cours.",
    ["chat_history_separator_text"]         = "Session en cours",
    ["sublabel_chat_history_channels"]      = "Canaux à restaurer",
    ["opt_chat_history_ch_whisper"]         = "Chuchotements",
    ["opt_chat_history_ch_guild"]           = "Guilde",
    ["opt_chat_history_ch_officer"]         = "Officier",
    ["opt_chat_history_ch_party"]           = "Groupe",
    ["opt_chat_history_ch_raid"]            = "Raid",
    ["opt_chat_history_ch_instance"]        = "Instance",
    ["opt_chat_history_ch_channel"]         = "Canaux",
    ["opt_chat_history_ch_say"]             = "Dire",
    ["opt_chat_history_ch_yell"]            = "Crier",
    ["opt_chat_history_ch_emote"]           = "Émotes",
    ["btn_chat_history_clear"]              = "Effacer l'historique maintenant",
    ["popup_chat_history_clear"]            = "Supprimer tous les messages de chat enregistrés ? Cette action est irréversible.",
    ["msg_chat_history_cleared"]            = "Historique du chat effacé (%d message(s)).",
    ["opt_chat_skin_copy_lines"]         = "Icône de copie par message",

    -- Buff Skin
    ["sublabel_buff_skin"]               = "— Skin Buffs / Debuffs —",

    -- Game Menu Skin
    ["sublabel_game_menu_skin"]          = "— Menu Echap —",
    ["opt_game_menu_skin_enable"]        = "Skinner le menu Echap",
    ["info_game_menu_skin_reload"]       = "Un /reload est nécessaire pour annuler ce skin.",
    ["msg_chat_skin_enabled"]            = "Skin du chat activé",
    ["msg_chat_skin_disabled"]           = "Skin du chat désactivé (reload pour revenir)",
    ["sublabel_mail_skin"]               = "— Courrier —",
    ["opt_mail_skin_enable"]             = "Skin du courrier",
    ["msg_mail_skin_enabled"]            = "Skin du courrier activé",
    ["msg_mail_skin_disabled"]           = "Skin du courrier désactivé (reload pour revenir)",

    -- =====================
    -- WORLD QUEST TAB
    -- =====================
    ["tab_qol_world_quests"]             = "Quêtes Monde",
    ["section_wq_tab"]                   = "Onglet Quêtes du monde",
    ["info_wq_tab_desc"]                 = "Ajoute un véritable onglet Quêtes du monde au journal de quêtes avec recherche, tri, récompenses, zone et temps restant. Cliquez sur une quête pour la suivre et afficher sa zone sur la carte.",
    ["opt_wq_enable"]                    = "Activer l'onglet Quêtes du monde",
    ["opt_wq_auto_show"]                 = "Ouvrir cet onglet par défaut avec le journal de quêtes",
    ["opt_wq_max_quests"]                = "Nombre max de quêtes (0 = illimité)",
    ["opt_wq_min_time"]                  = "Temps restant minimum (minutes, 0 = toutes)",
    ["section_wq_filters"]               = "Filtres de récompenses",
    ["opt_wq_filter_gold"]               = "Afficher les récompenses Or",
    ["opt_wq_filter_gear"]               = "Afficher les récompenses Équipement",
    ["opt_wq_filter_rep"]                = "Afficher les récompenses Réputation",
    ["opt_wq_filter_currency"]           = "Afficher les récompenses Monnaie",
    ["opt_wq_filter_anima"]              = "Afficher les récompenses Anima",
    ["opt_wq_filter_pet"]                = "Afficher les récompenses Mascotte",
    ["opt_wq_filter_other"]              = "Afficher les autres récompenses",
    ["wq_tab_title"]                     = "QM Liste",
    ["wq_panel_title"]                   = "Quêtes du monde",
    ["wq_col_name"]                      = "Nom",
    ["wq_col_zone"]                      = "Zone",
    ["wq_col_reward"]                    = "Récompense",
    ["wq_col_time"]                      = "Temps",
    ["wq_zone"]                          = "Zone",
    ["wq_faction"]                       = "Faction",
    ["wq_reward"]                        = "Récompense",
    ["wq_time_left"]                     = "Temps restant",
    ["wq_elite"]                         = "Quête du monde Élite",
    ["wq_sort_time"]                     = "Temps",
    ["wq_sort_zone"]                     = "Zone",
    ["wq_sort_name"]                     = "Nom",
    ["wq_sort_reward"]                   = "Récompense",
    ["wq_sort_faction"]                  = "Faction",
    ["wq_status_count"]                  = "Affichage %d / %d quêtes",
    ["wq_empty"]                         = "Aucune Quête du monde ne correspond à ces filtres.",
    ["wq_expired"]                       = "Expirée",
    ["wq_click_hint"]                    = "Clic : suivre et afficher sur la carte",
    ["wq_refresh_short"]                 = "R",
    ["wq_reward_gear"]                   = "Équipement",
    ["wq_reward_reputation"]             = "Réputation",
    ["wq_reward_pet"]                    = "Mascotte",
    ["wq_reward_other"]                  = "Autre",

    -- =====================
    -- PROFESSION HELPER
    -- =====================
    ["tab_qol_prof_helper"]              = "Métiers",
    ["section_prof_helper"]              = "Assistant Métiers",
    ["info_prof_helper_desc"]            = "Désenchantez, mouturez et prospectez vos objets en lot. Ouvrez la fenêtre pour sélectionner les objets à traiter.",
    ["opt_prof_helper_enable"]           = "Activer l'assistant Métiers",
    ["sublabel_prof_de_filters"]         = "— Filtres de qualité (Désenchantement) —",
    ["opt_prof_filter_green"]            = "Inclure les objets Peu communs (Verts)",
    ["opt_prof_filter_blue"]             = "Inclure les objets Rares (Bleus)",
    ["opt_prof_filter_epic"]             = "Inclure les objets Épiques (Violets)",
    ["btn_prof_open_helper"]             = "Ouvrir l'assistant Métiers",
    ["ph_title"]                         = "Assistant Métiers",
    ["ph_tab_disenchant"]                = "Désenchantement",
    ["ph_filter_quality"]                = "Qualité :",
    ["ph_quality_green"]                 = "Vert",
    ["ph_quality_blue"]                  = "Bleu",
    ["ph_quality_epic"]                  = "Épique",
    ["ph_select_all"]                    = "Tout sélectionner",
    ["ph_deselect_all"]                  = "Tout désélectionner",
    ["ph_btn_process"]                   = "Traiter la sélection",
    ["ph_btn_click_process"]              = "Cliquez pour traiter",
    ["ph_btn_stop"]                      = "Arrêter",
    ["ph_status_idle"]                   = "Sélectionnez des objets puis cliquez Traiter",
    ["ph_status_processing"]             = "Traitement %d/%d : %s",
    ["ph_status_done"]                   = "Terminé ! Tous les objets traités.",
    ["ph_item_count"]                    = "%d objets disponibles",
    ["ph_ilvl"]                          = "iNiv %d",

    -- =====================
    -- CLASS REMINDER
    -- =====================
    ["tab_qol_class_reminder"]            = "Rappel de classe",
    ["section_class_reminder"]            = "Rappel Buff / Forme de classe",
    ["info_class_reminder"]               = "Affiche une icône pour chaque buff, forme, posture ou aura de classe qui vous manque. Clic gauche pour le lancer, clic milieu pour le masquer jusqu'au prochain écran de chargement.",
    ["opt_class_reminder_enable"]         = "Activer le rappel de classe",
    ["opt_class_reminder_scale"]          = "Échelle de la rangée",
    ["opt_class_reminder_color"]          = "Couleur du libellé",
    ["sublabel_class_reminder_pos"]       = "— Position —",
    ["info_class_reminder_clicks"]        = "Le clic gauche lance le sort manquant (hors combat uniquement). Le clic milieu masque ce rappel jusqu'au prochain écran de chargement.",
    ["info_class_reminder_mover"]         = "Déplacez la rangée d'icônes depuis le panneau Déplacement, ou remettez-la au centre de l'écran.",
    ["sublabel_class_reminder_icons"]     = "— Icônes —",
    ["opt_class_reminder_icon_size"]      = "Taille des icônes",
    ["opt_class_reminder_spacing"]        = "Espacement des icônes",
    ["opt_class_reminder_opacity"]        = "Opacité",
    ["sublabel_class_reminder_text"]      = "— Libellé —",
    ["opt_class_reminder_show_text"]      = "Afficher le libellé sous les icônes",
    ["opt_class_reminder_text_size"]      = "Taille du libellé",
    ["sublabel_class_reminder_glow"]      = "— Effet lumineux —",
    ["opt_class_reminder_glow"]           = "Type d'effet lumineux",
    ["opt_class_reminder_glow_color"]     = "Couleur de l'effet",
    ["cr_glow_none"]                      = "Aucun",
    ["cr_glow_pixel"]                     = "Contour animé",
    ["cr_glow_autocast"]                  = "Scintillement",
    ["cr_glow_button"]                    = "Halo de barre d'action",
    ["cr_glow_proc"]                      = "Halo de proc",
    ["info_class_reminder_preview_hint"]  = "Cliquez sur une icône pour atteindre son interrupteur, sur son libellé pour les options de libellé, ou sur la zone vide pour la taille.",
    ["info_class_reminder_coverage"]      = "Décochez ce dont vous ne voulez pas être averti. Seule votre propre classe est vérifiée en jeu.",
    ["cr_lethal_poison"]                  = "Poison mortel",
    ["cr_nonlethal_poison"]               = "Poison non mortel",
    ["cr_flametongue"]                    = "Arme langue de feu",
    ["cr_windfury"]                       = "Arme furie-des-vents",
    ["cr_earthliving"]                    = "Arme terre vivante",
    ["cr_tidecaller"]                     = "Garde de l'appel des marées",
    ["cr_thunderstrike"]                  = "Gardien de frappe-tonnerre",
    ["cr_earth_shield_self"]              = "Bouclier de terre (soi)",
    ["cr_orbit_shield"]                   = "Bouclier d'éclairs / d'eau",
    ["cr_shield"]                         = "Bouclier",
    ["cr_paladin_rite"]                   = "Rite",
    ["sublabel_class_reminder_context"]   = "— Contexte —",
    ["opt_class_reminder_show_in"]        = "Afficher les rappels",
    ["cr_show_always"]                    = "Partout",
    ["cr_show_instances"]                 = "Donjons et raids uniquement",
    ["cr_show_group"]                     = "En groupe uniquement",
    ["opt_class_reminder_hide_resting"]   = "Masquer en ville et à l'auberge",
    ["opt_class_reminder_others_missing"] = "Avertir aussi quand un membre du groupe n'a pas le buff",
    ["info_class_reminder_others"]        = "Seuls les membres à portée qui bénéficient du buff sont comptés, et seulement hors combat : les auras d'un autre joueur sont illisibles en combat.",

    -- Class Reminder: noms buffs/formes
    ["cr_fortitude"]                     = "Mot de pouvoir : Robustesse",
    ["cr_shadowform"]                    = "Forme d'ombre",
    ["cr_arcane_intellect"]              = "Intelligence des Arcanes",
    ["cr_skyfury"]                       = "Furie céleste",
    ["cr_mark_of_the_wild"]              = "Marque du fauve",
    ["cr_cat_form"]                      = "Forme de félin",
    ["cr_bear_form"]                     = "Forme d'ours",
    ["cr_moonkin_form"]                  = "Forme de sélénien",
    ["cr_battle_shout"]                  = "Cri de guerre",
    ["cr_battle_stance"]                 = "Posture de combat",
    ["cr_berserker_stance"]              = "Posture du berserker",
    ["cr_defensive_stance"]              = "Posture défensive",
    ["cr_aura"]                          = "Aura",
    ["cr_blessing_bronze"]               = "Bénédiction du Bronze",
    ["cr_preview_sample"]                = "Exemple : buff de classe manquant",

    -- =====================
    -- MYTHIC TRACKER (TomoMythic integration)
    -- =====================
    ["tmt_cmd_usage"]               = "|cFF55B400/tmt|r : config  |  |cFF55B400unlock|r : déplacer  |  |cFF55B400lock|r : verrouiller  |  |cFF55B400reset|r : réinitialiser  |  |cFF55B400preview|r : aperçu  |  |cFF55B400key|r : clés du groupe  |  |cFF55B400kr|r : roulette  |  |cFF55B400keysync|r : diagnostic de synchro",
    ["tmt_unlock_msg"]              = "|cffffd100TomoModForever|r M+ Tracker : Cadre déverrouillé \226\128\148 glissez pour repositionner.",
    ["tmt_lock_msg"]                = "|cffffd100TomoModForever|r M+ Tracker : Cadre verrouillé.",
    ["tmt_reset_msg"]               = "|cffffd100TomoModForever|r M+ Tracker : Position réinitialisée.",
    ["tmt_unknown_cmd"]             = "|cffffd100TomoModForever|r M+ Tracker : Commande inconnue.",
    ["tmt_key_level"]               = "+%d",
    ["tmt_dungeon_unknown"]         = "Mythic+",
    ["tmt_overtime"]                = "TEMPS DÉPASSÉ",
    ["tmt_completed_on_time"]       = "TERMINÉ",
    ["tmt_completed_depleted"]      = "ÉCHOUÉ",
    ["tmt_forces"]                  = "FORCES",
    ["tmt_forces_done"]             = "COMPLET",
    ["tmt_forces_pct"]              = "%.1f%%",
    ["tmt_forces_count"]            = "%d / %d",
    ["tmt_forces_remaining"]        = "%d restants",
    ["tmt_deaths"]                  = "Morts",
    ["tmt_time_lost"]               = "Temps perdu : %s",
    ["tmt_cfg_preset"]              = "Style",
    ["tmt_cfg_preset_panel"]        = "Panneau",
    ["tmt_cfg_preset_hud"]          = "HUD",
    ["tmt_cfg_show_background"]     = "Fond du panneau",
    ["tmt_cfg_show_header"]         = "Bloc d'en-tête",
    ["tmt_cfg_show_dungeon"]        = "Nom du donjon",
    ["tmt_cfg_objective_style"]     = "Liste des boss",
    ["tmt_cfg_objective_rows"]      = "Lignes",
    ["tmt_cfg_objective_text"]      = "Texte",
    ["tmt_cfg_font_scale"]          = "Taille du texte",
    ["tmt_cfg_preset_minimal"]        = "Minimal",
    ["tmt_cfg_objective_none"]        = "Masquée",
    ["tmt_cfg_timer_layout"]          = "Disposition du chrono",
    ["tmt_cfg_timer_stacked"]         = "Deux lignes",
    ["tmt_cfg_timer_inline"]          = "Une ligne",
    ["tmt_cfg_segment_colors"]        = "Couleurs des segments",
    ["tmt_cfg_segment_palier"]        = "Par palier",
    ["tmt_cfg_segment_brand"]         = "Marque",
    ["tmt_cfg_splits"]                = "Comparer au meilleur temps",
    ["tmt_cfg_checkpoints"]           = "Points de contr\195\180le de forces",
    ["tmt_cfg_clear_splits"]          = "Effacer les temps enregistr\195\169s",
    ["tmt_splits_cleared"]            = "|cffffd100TomoModForever|r M+ Tracker : temps enregistr\195\169s effac\195\169s.",
    ["tmt_cds_reload_text"]           = "Le Cooldown Studio reste charg\195\169 jusqu\226\128\153au prochain rechargement. Recharger maintenant le lib\195\168re et efface le taint laiss\195\169 par cette session.",
    ["tmt_cds_reload_now"]            = "Recharger",
    ["tmt_cds_reload_later"]          = "Plus tard",
    ["tmt_cfg_cds_safety_reload"]     = "Recharger l\226\128\153interface apr\195\168s la fermeture du Studio",
    ["tmt_cfg_title"]               = "Mythic",
    ["tmt_cfg_panel_enable"]         = "Activer le tracker M+",
    ["tmt_cfg_show_timer"]          = "Barre de chronomètre",
    ["tmt_cfg_show_forces"]         = "Forces ennemies",
    ["tmt_cfg_show_bosses"]         = "Chronomètres de boss",
    ["tmt_cfg_hide_blizzard"]       = "Masquer le tracker Blizzard",
    ["tmt_cfg_lock"]                = "Verrouiller le cadre",
    ["tmt_cfg_scale"]               = "Échelle",
    ["tmt_cfg_alpha"]               = "Opacité du fond",
    ["tmt_cfg_reset_pos"]           = "Réinitialiser la position",
    ["tmt_cfg_preview"]             = "Aperçu",
    ["tmt_cfg_section_display"]     = "Affichage",
    ["tmt_cfg_section_frame"]       = "Cadre",
    ["tmt_cfg_section_actions"]     = "Actions",
    ["tmt_key_not_available"]       = "non disponible.",
    ["tmt_key_not_in_group"]        = "Vous n'êtes pas dans un groupe.",
    ["tmt_key_none_found"]          = "Aucune clé trouvée.",
    ["tmt_kr_spin"]                 = "|TInterface\\Icons\\INV_Misc_Dice_02:14|t  Tourner!",
    ["tmt_preview_active"]          = "|cffffd100TomoModForever|r M+ Tracker : Aperçu actif \226\128\148 |cFF55B400/tmt lock|r pour verrouiller.",

    -- =====================
    -- TOMOSCORE (Scoreboard)
    -- =====================
    ["ts_cfg_title"]                = "Tableau de scores",
    ["ts_cfg_enable"]               = "Activer le tableau de fin de donjon",
    ["ts_cfg_auto_show_mplus"]      = "Afficher en Mythique+",
    ["ts_cfg_scale"]                = "\195\137chelle",
    ["ts_cfg_alpha"]                = "Opacit\195\169 du fond",
    ["ts_cfg_section_display"]      = "Affichage",
    ["ts_cfg_section_frame"]        = "Cadre",
    ["ts_cfg_section_actions"]      = "Actions",
    ["ts_cfg_preview"]              = "Aper\195\167u",
    ["ts_cfg_last_run"]             = "Dernier donjon",
    ["ts_cfg_reset_pos"]            = "R\195\169initialiser la position",
    ["ts_reset_msg"]                = "|cffffd100TomoModForever|r Scoreboard : Position r\195\169initialis\195\169e.",
    ["ts_no_data"]                  = "|cffffd100TomoModForever|r Scoreboard : Aucune donn\195\169e de donjon disponible.",
    ["ts_mythic_zero"]              = "Mythique",
    ["ts_key_level"]                = "+%d",
    ["ts_completed"]                = "TERMIN\195\137",
    ["ts_depleted"]                 = "\195\137CHOU\195\137",
    ["ts_duration"]                 = "Dur\195\169e",
    ["ts_col_player"]               = "Joueur",
    ["ts_col_rating"]               = "M+",
    ["ts_col_key_level"]            = "Cl\195\169",
    ["ts_col_key_name"]             = "Donjon",
    ["ts_col_damage"]               = "D\195\169g\195\162ts",
    ["ts_col_healing"]              = "Soins",
    ["ts_col_interrupts"]           = "Interr.",
    ["ts_footer_total"]             = "Total",
    ["ts_footer_players"]           = "%d joueurs",

    -- =====================
    -- MYTHIC HUB (M+ Overview Panel)
    -- =====================
    ["mhub_title"]                  = "Cote Mythique+",
    ["mhub_col_dungeon"]            = "Donjon",
    ["mhub_col_level"]              = "Niveau",
    ["mhub_col_rating"]             = "Cote",
    ["mhub_col_best"]               = "Meilleur",
    ["mhub_tp_click"]               = "Cliquez pour vous t\195\169l\195\169porter",
    ["mhub_tp_not_available"]        = "T\195\169l\195\169portation non apprise",
    ["mhub_tp_not_learned"]          = "|cffffd100TomoModForever|r : Sort de t\195\169l\195\169portation non appris.",
    ["mhub_vault_title"]            = "Grande Chambre forte",
    ["mhub_vault_dungeons"]         = "Donjons",
    ["mhub_vault_raids"]            = "Raids",
    ["mhub_vault_world"]            = "Gouffres",
    ["mhub_vault_ilvl"]             = "Niveau d'objet",
    ["mhub_vault_locked"]           = "Verrouill\195\169",
    ["mhub_vault_claim"]            = "Retournez \195\160 la Grande Chambre forte pour r\195\169clamer votre r\195\169compense",

    -- =====================
    -- INSTALLER
    -- =====================
    ["ins_header_title"]             = "|cffffd100Tomo|r|cfff2ebdbMod|r |cffc9a252Forever|r  \226\128\148  Assistant de configuration",
    ["ins_step_counter"]             = "\195\137tape %d / %d",
    ["ins_btn_prev"]                 = "|TInterface\\BUTTONS\\UI-SpellbookIcon-PrevPage:0|t Pr\195\169c\195\169dent",
    ["ins_btn_next"]                 = "Suivant |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t",
    ["ins_btn_finish"]               = "Terminer |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t",
    ["ins_btn_skip"]                 = "Passer l'installation",

    ["ins_step1_title"]              = "Bienvenue dans TomoMod",
    ["ins_subtitle"]                 = "Suite d'interface et de QOL pour The War Within",
    ["ins_welcome_desc"]             = "Cet assistant va vous guider en |cffffd10016 \195\169tapes|r pour configurer TomoMod selon\nvos pr\195\169f\195\169rences : unit frames, party frames, castbars, nameplates, barres d'action,\nressources, skins, son, Mythic+, QOL, optimisations et SkyRide.\n\nToutes ces options seront accessibles \195\160 tout moment via |cffffd100/tm|r.",

    ["ins_step2_title"]              = "Profil de jeu",
    ["ins_profile_info"]             = "Cr\195\169ez un profil nomm\195\169 pour sauvegarder votre configuration.",
    ["ins_profile_section"]          = "Nom du profil",
    ["ins_profile_placeholder"]      = "Mon profil",
    ["ins_profile_create"]           = "Cr\195\169er le profil",
    ["ins_profile_created"]          = "Profil cr\195\169\195\169 : ",
    ["ins_spec_section"]             = "Assignation aux sp\195\169cialisations",
    ["ins_spec_info"]                = "Vous pouvez assigner ce profil \195\160 vos sp\195\169s depuis le panneau Profils (/tm).\nChaque sp\195\169 peut utiliser une configuration diff\195\169rente.",

    ["ins_step3_title"]              = "Skins visuels",
    ["ins_skins_info"]               = "Personnalisez l'apparence de l'interface Blizzard aux couleurs de TomoMod.",
    ["ins_skins_section"]            = "Skins disponibles",
    ["ins_skin_gamemenu"]            = "Skin du menu Echap (Game Menu)",
    ["ins_skin_actionbar"]           = "Skin des barres d'action (boutons)",
    ["ins_skin_chat"]                = "Skin du chat",
    ["ins_skin_character"]           = "Skin de la fiche de personnage",
    ["ins_skin_style_section"]       = "Style des boutons de barres d'action",
    ["ins_skin_style"]               = "Style visuel",

    ["ins_step4_title"]              = "Mode Tank",
    ["ins_tank_info"]                = "En mode tank, les nameplates et les UnitFrames affichent\nl'\195\169tat de menace par couleur pour chaque ennemi.",
    ["ins_tank_np_section"]          = "Nameplates \226\128\148 Couleurs de menace",
    ["ins_tank_enable_np"]           = "Activer le mode tank (nameplates)",
    ["ins_tank_colors_info"]         = "Vert = vous avez l'aggro  \194\183  Orange = proche de perdre  \194\183  Rouge = aggro perdue",
    ["ins_tank_uf_section"]          = "UnitFrames \226\128\148 Indicateur de menace",
    ["ins_tank_threat_indicator"]    = "Afficher l'indicateur de menace sur la cible",
    ["ins_tank_threat_text"]         = "Afficher le texte de menace en % sur la cible",
    ["ins_tank_cotank_section"]      = "CoTank Tracker",
    ["ins_tank_cotank_enable"]       = "Activer le suivi du co-tank",
    ["ins_tank_cotank_info"]         = "Affiche la menace du second tank en instance.",

    ["ins_step5_title"]              = "Nameplates",
    ["ins_np_general"]               = "G\195\169n\195\169ral",
    ["ins_np_enable"]                = "Activer les nameplates TomoMod",
    ["ins_np_reload_info"]           = "Un reload est n\195\169cessaire pour activer/d\195\169sactiver les nameplates.",
    ["ins_np_display"]               = "Affichage",
    ["ins_np_class_colors"]          = "Couleurs de classe",
    ["ins_np_castbar"]               = "Afficher la barre de sort (castbar)",
    ["ins_np_health_text"]           = "Afficher le texte de sant\195\169 (pourcentage)",
    ["ins_np_auras"]                 = "Afficher les auras (debuffs)",
    ["ins_np_role_icons"]            = "Afficher les ic\195\180nes de r\195\180le (donjon)",
    ["ins_np_dimensions"]            = "Dimensions",
    ["ins_np_width"]                 = "Largeur",

    ["ins_step6_title"]              = "Barres d'action",
    ["ins_ab_system_section"]        = "Syst\195\168me de barres d'action",
    ["ins_ab_system_info"]           = "TomoMod remplace les barres d'action Blizzard par des conteneurs\npersonnalis\195\169s avec positionnement, fondu et conditions d'affichage.\nD\195\169sactivez pour restaurer les barres Blizzard par d\195\169faut.",
    ["ins_ab_system_enable"]         = "Activer le syst\195\168me de barres d'action TomoMod",
    ["ins_ab_system_reload_info"]    = "N\195\169cessite un /reload pour prendre effet.",
    ["ins_ab_skin_section"]          = "Skin des boutons",
    ["ins_ab_enable"]                = "Activer le skin sur les boutons d'action",
    ["ins_ab_class_color"]           = "Couleur de bordure = couleur de classe",
    ["ins_ab_shift_reveal"]          = "Shift pour r\195\169v\195\169ler les barres cach\195\169es",
    ["ins_ab_opacity_section"]       = "Opacit\195\169 globale des barres",
    ["ins_ab_opacity"]               = "Opacit\195\169",
    ["ins_ab_manage_section"]        = "Gestion des barres",
    ["ins_ab_manage_info"]           = "Utilisez le panneau Barres d'action (/tm |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Barres d'action |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Gestion)\npour d\195\169verrouiller et repositionner chaque barre ind\195\169pendamment.",

    ["ins_step7_title"]              = "Son \226\128\148 H\195\169ro\195\175sme / Soif de sang",
    ["ins_sound_info"]               = "Jouez un son personnalis\195\169 lorsque H\195\169ro\195\175sme ou Soif de sang est lanc\195\169\npar n'importe quel membre du groupe.",
    ["ins_sound_activation"]         = "Activation",
    ["ins_sound_enable"]             = "Activer le son de lust",
    ["ins_sound_choice"]             = "Choix du son",
    ["ins_sound_sound"]              = "Son",
    ["ins_sound_channel"]            = "Canal audio",
    ["ins_sound_default"]            = "Par d\195\169faut",
    ["ins_sound_preview_section"]    = "Pr\195\169visualisation",
    ["ins_sound_preview_btn"]        = "|TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Pr\195\169visualiser",

    ["ins_step8_title"]              = "Mythic+ \226\128\148 Tracker & Scoreboard",
    ["ins_mplus_tracker_section"]    = "M+ Tracker",
    ["ins_mplus_tracker_info"]       = "Affiche un timer, les forces, les boss et l'avancement\nde votre donjon Mythique+ en temps r\195\169el.",
    ["ins_mplus_tracker_enable"]     = "Activer le M+ Tracker",
    ["ins_mplus_show_timer"]         = "Afficher le timer",
    ["ins_mplus_show_forces"]        = "Afficher les forces (%)",
    ["ins_mplus_hide_blizzard"]      = "Masquer l'interface Blizzard en Mythic+",
    ["ins_mplus_score_section"]      = "TomoScore \226\128\148 Tableau de scores",
    ["ins_mplus_score_info"]         = "Affiche les scores personnels et de groupe \195\160 la fin d'un Mythique+.",
    ["ins_mplus_score_enable"]       = "Activer TomoScore",
    ["ins_mplus_score_auto"]         = "Afficher automatiquement en M+",

    ["ins_step9_title"]              = "Optimisations syst\195\168me (CVars)",
    ["ins_cvar_info"]                = "TomoMod peut appliquer un ensemble de CVars WoW recommand\195\169es\npour am\195\169liorer les performances et la r\195\169activit\195\169.",
    ["ins_cvar_section"]             = "Optimisations incluses",
    ["ins_cvar_opt1"]                = "R\195\169duction du Level of Detail (LOD) inutile",
    ["ins_cvar_opt2"]                = "Optimisation du frustum culling",
    ["ins_cvar_opt3"]                = "D\195\169sactivation du temporal AA excessif",
    ["ins_cvar_opt4"]                = "Am\195\169lioration de la r\195\169activit\195\169 r\195\169seau",
    ["ins_cvar_opt5"]                = "D\195\169sactivation des animations d'interface superflues",
    ["ins_cvar_opt6"]                = "Optimisation du streaming de textures",
    ["ins_cvar_success"]             = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t  CVars appliqu\195\169es avec succ\195\168s !",
    ["ins_cvar_apply_btn"]           = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0|t Appliquer toutes les CVars",
    ["ins_cvar_applied"]             = "CVars optimis\195\169es appliqu\195\169es.",

    ["ins_step10_title"]             = "Qualit\195\169 de vie (QOL)",
    ["ins_qol_info"]                 = "Activez les modules QOL qui vous int\195\169ressent.\nTous sont accessibles s\195\169par\195\169ment dans /tm |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t QOL.",
    ["ins_qol_auto_section"]         = "Automatisations",
    ["ins_qol_auto_repair"]          = "R\195\169parer automatiquement chez le marchand",
    ["ins_qol_fast_loot"]            = "Fast loot (ramassage rapide des objets)",
    ["ins_qol_skip_cinematics"]      = "Skip automatique des cin\195\169matiques d\195\169j\195\160 vues",
    ["ins_qol_hide_talking_head"]    = "Masquer le Talking Head (dialogues de d\195\169filement)",
    ["ins_qol_auto_accept"]          = "Auto-accepter les invitations de groupe (amis & guilde)",
    ["ins_qol_tooltip_ids"]          = "Afficher les IDs dans les tooltips (spell ID, item ID...)",
    ["ins_qol_combat_section"]       = "Combat",
    ["ins_qol_combat_text"]          = "Texte de combat flottant personnalis\195\169",
    ["ins_qol_hide_castbar"]         = "Masquer la castbar Blizzard (utilisez celle de TomoMod)",

    ["ins_step11_title"]             = "SkyRide \226\128\148 Barre de chevauch\195\169e draconique",
    ["ins_skyride_info"]             = "SkyRide affiche une barre de Vigor (6 charges) et une barre de\nSecond Souffle (3 charges) pour la chevauch\195\169e draconique.",
    ["ins_skyride_activation"]       = "Activation",
    ["ins_skyride_enable"]           = "Activer la barre SkyRide",
    ["ins_skyride_auto_info"]        = "La barre s'affiche automatiquement en mode vol draconique\net se masque hors de ce mode.",
    ["ins_skyride_dimensions"]       = "Dimensions",
    ["ins_skyride_width"]            = "Largeur",
    ["ins_skyride_height"]           = "Hauteur",
    ["ins_skyride_reset_section"]    = "R\195\169initialiser la position",
    ["ins_skyride_reset_btn"]        = "R\195\169initialiser la position",

    ["ins_step12_title"]             = "Configuration termin\195\169e !",
    ["ins_done_check"]               = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t  Tout est pr\195\170t !",
    ["ins_done_recap"]               = "Votre configuration TomoMod est enregistr\195\169e. Voici quelques rappels :\n\n|cffffd100/tm|r              |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t  Ouvrir le panneau de configuration\n|cffffd100/tm sr|r           |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t  D\195\169verrouiller et d\195\169placer les \195\169l\195\169ments\n|cffffd100/tm install|r      |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t  Relancer cet installeur\n\nToutes les options configur\195\169es ici sont modifiables \195\160 tout moment\ndepuis les panneaux correspondants dans le GUI TomoMod.\n\nUn |cffffd100reload de l'UI|r est n\195\169cessaire pour appliquer certains changements\n(nameplates, skins, UnitFrames).",
    ["ins_done_reload"]              = "|TInterface\\BUTTONS\\UI-RefreshButton:0|t  Recharger l'UI",

    -- Step NEW: Unit Frames
    ["ins_uf_title"]                 = "Unit Frames",
    ["ins_uf_info"]                  = "TomoMod remplace les cadres d'unit\195\169 Blizzard par d\195\169faut (joueur, cible, focus, familier)\npar des cadres modernes et personnalisables.",
    ["ins_uf_section"]               = "G\195\169n\195\169ral",
    ["ins_uf_enable"]                = "Activer les unit frames TomoMod",
    ["ins_uf_hide_blizzard"]         = "Masquer les cadres Blizzard par d\195\169faut",
    ["ins_uf_reload_info"]           = "Un reload est n\195\169cessaire pour appliquer les changements aux unit frames.",

    -- Step NEW: Party Frames
    ["ins_pf_title"]                 = "Party Frames",
    ["ins_pf_info"]                  = "Cadres de groupe personnalis\195\169s avec ic\195\180nes de r\195\180le, surbrillance de dispel\net suivi des cooldowns pour le jeu en groupe.",
    ["ins_pf_section"]               = "G\195\169n\195\169ral",
    ["ins_pf_enable"]                = "Activer les party frames TomoMod",
    ["ins_pf_hide_blizzard"]         = "Masquer les party frames Blizzard",
    ["ins_pf_cd_section"]            = "Suivi des cooldowns",
    ["ins_pf_cd_info"]               = "Suivez les cooldowns d'interruption et de brez de combat\nde vos co\195\169quipiers directement sur leurs cadres de groupe.",
    ["ins_pf_show_interrupt"]        = "Afficher le suivi du cooldown d'interruption",
    ["ins_pf_show_brez"]             = "Afficher le suivi du cooldown de brez de combat",
    ["ins_pf_reload_info"]           = "Un reload est n\195\169cessaire pour appliquer les changements aux party frames.",

    -- Step 5: Raid Frames
    ["ins_rf_title"]                 = "Cadres de raid",
    ["ins_rf_info"]                  = "Cadres de raid personnalis\195\169s pour groupes de 6 \195\160 40 joueurs.\nDisposition grille ou liste avec dispel, suivi HoT et ic\195\180nes de debuffs.",
    ["ins_rf_section"]               = "G\195\169n\195\169ral",
    ["ins_rf_enable"]                = "Activer les cadres de raid TomoMod",
    ["ins_rf_hide_blizzard"]         = "Masquer les cadres de raid Blizzard",
    ["ins_rf_features_section"]      = "Fonctionnalit\195\169s",
    ["ins_rf_show_dispel"]           = "Surlignage dispel (bordure selon le type de debuff)",
    ["ins_rf_show_hots"]             = "Suivi HoT (indicateurs de sorts de heal)",
    ["ins_rf_show_debuffs"]          = "Afficher les ic\195\180nes de debuff sur les membres",
    ["ins_rf_show_defensives"]       = "Afficher les ic\195\180nes de cooldowns d\195\169fensifs",
    ["ins_rf_layout_section"]        = "Disposition",
    ["ins_rf_layout"]                = "Mode de disposition du raid",
    ["ins_rf_reload_info"]           = "Un reload est n\195\169cessaire pour appliquer les changements aux cadres de raid.",

    -- Step NEW: Castbars
    ["ins_cb_title"]                 = "Barres de sort",
    ["ins_cb_info"]                  = "Barres de sort personnalis\195\169es pour joueur, cible, focus et familier\navec animation spark et feedback d'interruption.",
    ["ins_cb_section"]               = "G\195\169n\195\169ral",
    ["ins_cb_enable"]                = "Activer les castbars TomoMod",
    ["ins_cb_hide_blizzard"]         = "Masquer la castbar Blizzard par d\195\169faut",
    ["ins_cb_class_color"]           = "Couleur de classe pour le remplissage",
    ["ins_cb_reload_info"]           = "Un reload est n\195\169cessaire pour appliquer les changements aux castbars.",

    -- Step NEW: Resource Bars & Cooldown Manager
    ["ins_res_title"]                = "Ressources & Cooldowns",
    ["ins_res_info"]                 = "Affichage de puissance de classe (points de combo, runes, \195\169clats d'\195\162me, etc.)\nen mode ic\195\180ne ou barre.",
    ["ins_res_section"]              = "Barres de ressources",
    ["ins_res_enable"]               = "Activer les barres de ressources",
    ["ins_res_display"]              = "Mode d'affichage",
    ["ins_cdm_section"]              = "Gestionnaire de cooldowns",
    ["ins_cdm_info"]                 = "Spirale de cooldown sur les boutons d'action avec\nalpha adaptatif au combat et filtrage du GCD.",
    ["ins_cdm_enable"]               = "Activer le gestionnaire de cooldowns",
    ["ins_cdm_hide_gcd"]             = "Masquer la spirale du GCD",
    ["ins_cdm_desat"]                = "D\195\169saturer les boutons en cooldown",

    -- Enhanced Skins
    ["ins_skin_bag"]                 = "Skin des sacs",
    ["ins_skin_tooltip"]             = "Skin des tooltips",
    ["ins_skin_objective"]           = "Skin du suivi d'objectifs (qu\195\170tes color\195\169es par type)",
    ["ins_skin_mail"]                = "Skin du courrier",
    ["ins_skin_reputation"]          = "Barre de r\195\169putation",

    -- Enhanced QOL
    ["ins_qol_interface_section"]    = "Interface",
    ["ins_qol_minimap"]              = "Minimap personnalis\195\169e (bordure & \195\169chelle)",
    ["ins_qol_cursor"]               = "Anneau de curseur lumineux",
    ["ins_qol_afk"]                  = "\195\137cran AFK personnalis\195\169 avec mod\195\168le 3D",
    ["ins_qol_diag"]                 = "Diagnostics (capture d'erreurs sans popups)",
    ["ins_qol_auto_summon"]          = "Accepter automatiquement les invocations",
    ["ins_qol_auto_fill_delete"]     = "Remplir automatiquement SUPPRIMER dans les popups",
    ["ins_qol_auto_quest"]           = "Accepter/rendre les qu\195\170tes auto (Shift pour annuler)",
    ["ins_qol_class_reminder"]       = "Rappel de buff de classe (Endurance, Intellect, etc.)",
    ["ins_qol_leveling_bar"]         = "Barre de niveau (XP/heure, repos\195\169 XP)",
    ["ins_qol_waypoint"]             = "Syst\195\168me de navigation waypoint",
    ["ins_qol_world_quest_tab"]      = "Navigateur de qu\195\170tes mondiales sur la carte",
    ["ins_qol_frame_anchors"]        = "Ancres de fen\195\170tres d\195\169pla\195\167ables (Alerte, Butin)",
    ["ins_qol_profession_helper"]    = "Aide aux m\195\169tiers (d\195\169senchantement en masse)",

    -- =========== Config Panels — i18n ===========
    -- ActionBars panel
    ["opt_abs_style"]                = "Style visuel",
    ["section_bar_opacity"]          = "Opacit\195\169 par barre",
    ["opt_abs_bar_select"]           = "Barre \195\160 configurer",
    ["opt_abs_opacity"]              = "Opacit\195\169",
    ["btn_abs_apply_all"]            = "Appliquer \195\160 toutes les barres",
    ["opt_abs_combat_only_label"]    = "Affichage seulement en combat :",
    ["opt_abs_combat_only"]          = "Barre visible en combat seulement",
    ["section_bar_management"]       = "Gestion des barres d'action",
    ["btn_abs_unlock"]               = "D\195\169verrouiller les barres",
    ["info_abs_unlock"]              = "D\195\169verrouillez les barres pour faire appara\195\174tre les poign\195\169es de d\195\169placement.\nClic droit sur une poign\195\169e pour configurer une barre individuellement.",
    ["section_bar_quick"]            = "Param\195\168tres rapides",
    ["btn_abs_layout"]               = "EditMode (/tm layout)",
    ["info_abs_layout"]              = "Utilisez l'EditMode pour d\195\169placer les barres, ou glissez les overlays pour repositionner.\nD\195\169pliez une barre ci-dessous pour r\195\169gler la taille des boutons et l'\195\169chelle.",
    ["tab_abs_skin"]                 = "Skin des boutons",
    ["tab_abs_bars"]                 = "Gestion des barres",
    -- Per-bar config
    ["opt_bar_enabled"]              = "Activ\195\169e",
    ["opt_bar_orientation"]          = "Orientation",
    ["opt_bar_grow_dir"]             = "Direction de croissance",
    ["opt_bar_columns"]              = "Colonnes",
    ["opt_bar_button_size"]          = "Taille des boutons",
    ["opt_bar_spacing"]              = "Espacement",
    ["opt_bar_alpha"]                = "Alpha",
    ["opt_bar_scale"]                = "\195\137chelle",
    ["opt_bar_display_cond"]         = "Condition d'affichage",
    ["opt_bar_fade"]                 = "Activer le fondu",
    ["opt_bar_fade_out_alpha"]       = "Alpha en fondu",
    ["opt_bar_fade_out_delay"]       = "D\195\169lai avant fondu",
    ["opt_bar_fade_out_dur"]         = "Dur\195\169e du fondu sortant",
    ["opt_bar_fade_in_dur"]          = "Dur\195\169e du fondu entrant",
    ["opt_bar_click_through"]        = "Clic traversant",
    ["opt_bar_show_empty"]           = "Afficher les boutons vides",
    ["opt_bar_show_hotkey"]          = "Afficher les raccourcis",
    ["opt_bar_disabled"]             = "D\195\169sactiv\195\169e",
    -- Bar names
    ["bar_name_bar1"]                = "Barre 1 (Principale)",
    ["bar_name_bar2"]                = "Barre 2",
    ["bar_name_bar3"]                = "Barre 3",
    ["bar_name_bar4"]                = "Barre 4",
    ["bar_name_bar5"]                = "Barre 5",
    ["bar_name_bar6"]                = "Barre 6",
    ["bar_name_bar7"]                = "Barre 7",
    ["bar_name_bar8"]                = "Barre 8",
    ["bar_name_pet"]                 = "Barre du familier",
    ["bar_name_stance"]              = "Barre de postures",
    -- General panel
    ["opt_gui_scale"]                = "\195\137chelle de la fen\195\170tre de configuration",
    ["info_gui_scale"]               = "\195\137chelle de la fen\195\170tre /tm \226\128\148 elle est aussi redimensionnable en tirant son coin inf\195\169rieur droit.",
    ["btn_gui_reset_size"]           = "R\195\169initialiser taille et \195\169chelle",
    ["btn_relaunch_installer"]       = "Relancer l'installeur",
    ["info_relaunch_installer"]      = "Lance l'assistant de configuration en 12 \195\169tapes.",
    -- Sound panel
    ["section_sound_preview"]        = "Pr\195\169visualisation & options",
    -- UFPreview
    ["preview_header"]               = "APER\195\135U EN DIRECT",
    ["preview_player"]               = "Joueur",
    ["preview_target_name"]          = "Taurache",
    ["preview_focus_name"]           = "Pr\195\170trelle",
    ["preview_pet_name"]             = "Loup d'eau",
    ["preview_tot_name"]             = "Cible-de-cible",
    ["preview_cast_player"]          = "\195\137clair de givre",
    ["preview_cast_target"]          = "Boule de feu",
    ["preview_lbl_player"]           = "JOUEUR",
    ["preview_lbl_target"]           = "CIBLE",
    ["preview_lbl_focus"]            = "FOCUS",
    ["preview_lbl_pet"]              = "PET",
    ["preview_lbl_tot"]              = "TOT",
    ["preview_click_nav"]            = "cliquer pour naviguer",
    ["preview_click_isolate"]         = "cliquer pour isoler",
    ["preview_click_show_all"]        = "cliquer pour tout afficher",
    ["preview_show_all"]              = "Tout afficher",
    ["preview_zoom_fit"]                = "Ajust\195\169",
    ["preview_zoom_11"]                 = "1:1",
    ["preview_zoom_tip"]                = "Bascule entre l'ajustement au panneau et la taille r\195\169elle 1:1.",
    ["preview_all_disabled"]            = "Tous les cadres d'unit\195\169 sont d\195\169sactiv\195\169s.",
    ["preview_engine_missing"]          = "Moteur UnitFrames non charg\195\169.",
    ["preview_data_live"]               = "Donn\195\169es r\195\169elles",
    ["preview_data_mock"]               = "Simul\195\169",
    ["preview_data_tip"]                = "Alimente l'aper\195\167u avec les vraies donn\195\169es quand l'unit\195\169 existe, sinon repli sur des valeurs simul\195\169es.",
    ["preview_tag_live"]                = "R\195\137EL",
    ["preview_tag_sim"]                 = "SIM",
    -- ConfigUI footer
    ["ui_footer_hint"]               = "/tm  \194\183  /tm sr pour d\195\169placer les \195\169l\195\169ments",

    -- =====================
    -- SKINS CATEGORY (top-level)
    -- =====================
    ["cat_skins"]                        = "Skins",

    -- Skins > Chat Frame V2 — labels des onglets & UI
    ["chatv2_tab_general"]               = "G\195\169n\195\169ral",
    ["chatv2_tab_instance"]              = "Instance",
    ["chatv2_tab_chucho"]                = "Chucho",
    ["chatv2_tab_personnel"]             = "Personnel",
    ["chatv2_tab_combat"]                = "Combat",
    ["chatv2_sidebar_title"]             = "CHAT",
    ["chatv2_expand_btn"]                = "Chat",
    ["chatv2_mover_label"]               = "Fen\195\170tre de chat V2",
    ["chatv2_input_hint"]                = "Entr\195\169e pour \195\169crire...",

    -- Skins > Chat Frame tab (panneau de config)
    ["tab_skin_chatframe"]               = "Fen\195\170tre de discussion",
    ["section_skin_chatframe"]           = "Skin de la fen\195\170tre de discussion",
    ["info_skin_chatframe_desc"]         = "Panneau de discussion \195\160 barre lat\195\169rale \226\128\148 G\195\169n\195\169ral, Instance, Chucho, Personnel, Combat \226\128\148 avec badges non lus et indicateurs de pins.",
    ["opt_skin_chatframe_enable"]        = "Activer le skin de discussion",
    ["opt_skin_chatframe_width"]         = "Largeur",
    ["opt_skin_chatframe_height"]        = "Hauteur",
    ["opt_skin_chatframe_scale"]         = "\195\137chelle %",
    ["opt_skin_chatframe_opacity"]       = "Opacit\195\169 du fond",
    ["opt_skin_chatframe_font_size"]     = "Taille de la police",
    ["opt_skin_chatframe_timestamp"]     = "Afficher l'horodatage",
    -- Bag skin — d\195\169senchantement
    ["bagskin_currencies_none"]          = "Aucune devise suivie (clic-droit sur une devise \226\134\146 Afficher dans le sac \195\160 dos)",

    -- Skins > Bags tab
    ["tab_skin_bags"]                    = "Sacs",
    ["section_skin_bags"]                = "Skin des sacs",
    ["info_skin_bags_desc"]              = "Disposition combin\195\169e/cat\195\169gories/par sac avec bordures de qualit\195\169, recherche, badges de niveau, ic\195\180nes camelote, barre de sacs et fen\195\170tre redimensionnable.",
    ["opt_skin_bags_enable"]             = "Activer le skin des sacs",
    ["opt_skin_bags_stack_merge"]        = "Fusionner les piles identiques",
    ["opt_skin_bags_show_empty"]         = "Afficher la section emplacements libres",
    ["opt_skin_bags_show_recent"]        = "Afficher la section objets r\195\169cents",
    ["opt_skin_bags_columns"]            = "Colonnes",
    ["opt_skin_bags_slot_size"]          = "Taille des emplacements",
    ["opt_skin_bags_slot_spacing"]       = "Espacement des emplacements",
    ["opt_skin_bags_slot_spacing_x"]     = "Espacement horizontal",
    ["opt_skin_bags_slot_spacing_y"]     = "Espacement vertical",
    ["opt_skin_bags_scale"]              = "\195\137chelle %",
    ["opt_skin_bags_opacity"]            = "Opacit\195\169 du fond",
    ["opt_skin_bags_quality_borders"]    = "Afficher les bordures de qualit\195\169",
    ["bags_v4_quality_style"]            = "Qualité des objets",
    ["bags_v4_quality_tint"]             = "Case teintée",
    ["bags_v4_quality_border"]           = "Cadre coloré",
    ["bags_v4_quality_both"]             = "Les deux",
    ["bags_v4_quality_none"]             = "Aucune",
    ["bags_v4_slot_pin"]                 = "Clic milieu : épingler",
    ["bags_v4_slot_unpin"]               = "Clic milieu : désépingler",
    ["bags_v4_sidebar_click"]            = "Clic gauche : trouver dans les sacs",
    ["bags_v4_sidebar_unpin"]            = "Clic milieu : désépingler",
    ["opt_skin_bags_cooldowns"]          = "Afficher les cooldowns",
    ["opt_skin_bags_quantity"]           = "Afficher les badges de quantit\195\169",
    ["opt_skin_bags_search"]             = "Afficher la barre de recherche",
    ["opt_skin_bags_show_ilvl"]          = "Afficher le niveau d'objet sur l'\195\169quipement",
    ["opt_skin_bags_show_junk_icon"]     = "Afficher l'ic\195\180ne camelote",
    ["opt_skin_bags_layout_mode"]        = "Mode de disposition",
    ["opt_skin_bags_layout_combined"]    = "Grille combin\195\169e",
    ["opt_skin_bags_layout_categories"]  = "Cat\195\169gories",
    ["opt_skin_bags_layout_separate"]    = "Sacs s\195\169par\195\169s",
    ["opt_skin_bags_reverse_order"]      = "Inverser l'ordre des sacs",
    ["opt_skin_bags_show_bag_bar"]       = "Afficher la barre de sacs",
    ["opt_skin_bags_settings"]           = "Param\195\168tres des sacs",
    ["opt_skin_bags_sort_mode"]          = "Mode de tri",
    ["opt_skin_bags_sort_none"]          = "Manuel",
    ["opt_skin_bags_sort_quality"]       = "Qualit\195\169",
    ["opt_skin_bags_sort_name"]          = "Nom",
    ["opt_skin_bags_sort_type"]          = "Type",
    ["opt_skin_bags_sort_ilvl"]          = "Niveau d'objet",
    ["opt_skin_bags_sort_recent"]        = "R\195\169cent",
    ["opt_skin_bags_show_gold"]          = "Afficher l'or (pied de page)",
    ["opt_skin_bags_show_currencies"]    = "Afficher les devises suivies (pied de page)",
    -- Bag skin — noms de cat\195\169gories

    -- Skins > Objective Tracker tab
    ["tab_skin_objtracker"]              = "Suivi d'objectifs",

    -- Skins > Character tab
    ["tab_skin_character"]               = "Personnage",

    -- Skins > Buffs tab

    -- Skins > Game Menu tab
    ["tab_skin_gamemenu"]                = "Menu de jeu",

    -- Skins > Tooltip tab
    ["tab_skin_tooltip"]                 = "Tooltip",
    ["section_tooltip_skin"]             = "Skin Tooltip",
    ["opt_tooltip_skin_enable"]          = "Activer le skin tooltip",
    ["info_tooltip_skin_reload"]         = "Certains changements nécessitent de survoler une nouvelle cible.",
    ["opt_tooltip_bg_alpha"]             = "Opacité du fond",
    ["opt_tooltip_border_alpha"]         = "Opacité des bordures",
    ["opt_tooltip_bg_color"]              = "Couleur du fond",
    ["opt_tooltip_border_color"]          = "Couleur de la bordure",
    ["opt_tooltip_font_size"]             = "Taille de police",
    ["opt_tooltip_hide_healthbar"]       = "Masquer la barre de vie",
    ["opt_tooltip_class_color"]          = "Noms colorés par classe",
    ["opt_tooltip_hide_server"]          = "Masquer le serveur dans les noms",
    ["opt_tooltip_hide_title"]           = "Masquer le titre dans les noms",
    ["opt_tooltip_guild_color"]          = "Couleur de guilde personnalisée",
    ["opt_tooltip_guild_color_pick"]     = "Couleur du nom de guilde",
    ["sublabel_tooltip_info"]            = "— Informations d'unité —",
    ["opt_tooltip_unit_info"]            = "Afficher les informations d'unité",
    ["info_tooltip_unit_info"]           = "Ajoute le rang de guilde, la cible, le score M+ et plus aux infobulles d'unité.",
    ["opt_tooltip_reaction_border"]      = "Colorer la bordure par réaction / classe",
    ["opt_tooltip_color_level"]          = "Colorer le niveau par difficulté",
    ["opt_tooltip_raid_marker"]          = "Afficher l'icône de marqueur",
    ["opt_tooltip_role_icon"]            = "Afficher l'icône de rôle",
    ["opt_tooltip_class_icon"]           = "Afficher l'icône de classe",
    ["opt_tooltip_icon_size"]            = "Taille des icônes",
    ["opt_tooltip_guild_rank"]           = "Afficher le rang de guilde",
    ["opt_tooltip_guild_rank_index"]     = "Afficher le numéro de rang",
    ["opt_tooltip_guild_realm"]          = "Afficher le royaume de guilde",
    ["opt_tooltip_show_target"]          = "Afficher la cible de l'unité",
    ["opt_tooltip_mythic_score"]         = "Afficher le score M+",
    ["opt_tooltip_mount"]                = "Afficher la monture",
    ["opt_tooltip_speed"]                = "Afficher la vitesse de déplacement",
    ["opt_tooltip_location"]             = "Afficher le lieu",
    ["info_tooltip_location"]            = "Le lieu n'est disponible que pour vous et les membres de votre groupe.",
    ["tt_guild_rank"]                    = "Rang",
    ["tt_target"]                        = "Cible",
    ["tt_target_you"]                    = "Vous",
    ["tt_mythic_score"]                  = "Score M+",
    ["tt_speed"]                         = "Vitesse",
    ["tt_mount"]                         = "Monture",
    ["tt_location"]                      = "Lieu",
    ["sublabel_tooltip_inspect"]         = "— Inspection —",
    ["opt_tooltip_item_level"]           = "Afficher le niveau d'objet",
    ["opt_tooltip_spec"]                 = "Afficher la spécialisation",
    ["opt_tooltip_spec_icon"]            = "Afficher l'icône de spécialisation",
    ["opt_tooltip_pending_text"]         = "Afficher un indicateur pendant le chargement",
    ["info_tooltip_inspect"]             = "Le niveau d'objet et la spécialisation nécessitent d'inspecter le joueur : ils n'apparaissent qu'à portée.",
    ["tt_item_level"]                    = "Niveau d'objet",
    ["tt_spec"]                          = "Spécialisation",
    ["tt_loading"]                       = "...",

    -- Skins > Mail tab
    ["tab_skin_mail"]                    = "Courrier",

    -- =====================
    -- MODULE WAYPOINT (/tm way)
    -- =====================
    -- GUI
    ["tab_qol_waypoint"]                  = "Waypoint",
    ["section_waypoint"]                  = "Waypoint",
    ["opt_way_zone_only"]                 = "Afficher uniquement dans la zone actuelle",
    ["opt_way_size"]                      = "Taille du balise",
    ["opt_way_shape"]                     = "Forme",
    ["way_shape_ring"]                    = "Anneau",
    ["way_shape_arrow"]                   = "Fl\195\168che",
    ["opt_way_color"]                     = "Couleur du waypoint",
    -- Slash
    ["msg_help_way"]                     = "Placer un point de cheminement \195\160 votre position",
    ["msg_help_way_coords"]              = "Placer un point de cheminement aux coordonnées (x, y)",
    ["msg_help_way_clear"]               = "Supprimer le point de cheminement actif",
    ["way_cleared"]                      = "Point de cheminement supprimé.",
    ["way_set"]                          = "Point de cheminement défini à %s%s.",
    ["way_here"]                         = "Point de cheminement placé à la position actuelle.",
    ["way_no_map"]                       = "Impossible de déterminer la carte actuelle.",
    ["way_no_pos"]                       = "Impossible de déterminer la position du joueur.",
    ["way_bad_map"]                      = "Impossible de placer un point de cheminement sur cette carte.",
    ["way_bad_coords"]                   = "Les coordonnées doivent être comprises entre 0 et 100.",
    ["way_usage"]                        = "Usage : /tm way [mapID] x y [nom]  |  /tm way clear",

    -- =====================
    -- Missing resource names
    -- =====================
    ["res_mana"]                        = "Mana (Druide)",
    ["res_soul_shards"]                 = "Éclats d'âme",
    ["res_holy_power"]                  = "Puissance sacrée",
    ["res_chi"]                         = "Chi",
    ["res_combo_points"]                = "Points de combo",
    ["res_charged_combo_points"]        = "Points de combo surchargés",
    ["res_arcane_charges"]              = "Charges arcaniques",
    ["res_essence"]                     = "Essence",
    ["res_stagger"]                     = "Report",
    ["res_soul_fragments"]              = "Fragments d'âme",
    ["res_tip_of_spear"]                = "Pointe de la lance",
    ["res_maelstrom_weapon"]            = "Arme du Maelström",
    ["res_icicles"]                      = "Glaçons",
    ["msg_avr_header"]                  = "[AutoVendeurRépa]",

    -- =====================
    -- CASTBARS (module autonome)
    -- =====================
    ["cat_castbars"]                     = "Barres d'incantation",

    ["cb_section_general"]               = "Général",
    ["opt_cb_enable"]                    = "Activer les barres d'incantation autonomes",
    ["info_cb_description"]              = "Remplace les barres d'incantation Blizzard par des barres entièrement personnalisables pour Joueur, Cible, Focus, Familier et Boss.",
    ["btn_cb_toggle_preview"]            = "Afficher / Masquer l'aperçu",
    ["info_cb_preview_hint"]             = "Déverrouille toutes les barres d'incantation et affiche un sort fictif en direct pour visualiser tes réglages instantanément.",
    ["opt_cb_hide_blizzard"]             = "Masquer les barres d'incantation Blizzard",
    ["opt_cb_class_color"]               = "Utiliser la couleur de classe",
    ["opt_cb_show_transitions"]          = "Animations de début/fin",
    ["opt_cb_show_channel_ticks"]        = "Afficher les marques de canalisation",
    ["opt_cb_timer_format"]              = "Format du minuteur",
    ["cb_timer_remaining"]               = "Restant (1.5)",
    ["cb_timer_remaining_total"]         = "Restant / Total (1.5 / 3.0)",
    ["cb_timer_elapsed"]                 = "Écoulé (1.5)",
    ["opt_cb_spell_max_len"]             = "Longueur max. du nom (0 = illimité)",

    ["cb_section_appearance"]            = "Apparence",
    ["opt_cb_bar_texture"]               = "Texture de la barre",
    ["cb_tex_blizzard"]                  = "Blizzard",
    ["cb_tex_smooth"]                    = "Lisse",
    ["cb_tex_flat"]                      = "Plat",
    ["opt_cb_font_size"]                 = "Taille de police",
    ["opt_cb_bg_mode"]                   = "Mode d'arrière-plan",
    ["cb_bg_black"]                      = "Noir",
    ["cb_bg_transparent"]                = "Transparent",
    ["cb_bg_custom"]                     = "Texture personnalisée",

    ["cb_section_colors"]                = "Couleurs",
    ["opt_cb_cast_color"]                = "Couleur d'incantation",
    ["opt_cb_ni_color"]                  = "Non interruptible",
    ["opt_cb_interrupt_color"]           = "Couleur d'interruption",

    ["cb_section_spark"]                 = "Étincelle",
    ["opt_cb_show_spark"]                = "Afficher l'animation d'étincelle",
    ["opt_cb_spark_style"]               = "Style d'étincelle",
    ["opt_cb_spark_color"]               = "Couleur de l'étincelle",
    ["opt_cb_spark_glow_color"]          = "Couleur de lueur",
    ["opt_cb_spark_tail_color"]          = "Couleur de traînée",
    ["opt_cb_spark_glow_alpha"]          = "Opacité de lueur",
    ["opt_cb_spark_tail_alpha"]          = "Opacité de traînée",

    ["cb_section_gcd"]                   = "Étincelle GCD",
    ["opt_cb_show_gcd"]                  = "Afficher la barre GCD sous la barre du joueur",
    ["opt_cb_gcd_height"]                = "Hauteur de la barre GCD",
    ["opt_cb_gcd_color"]                 = "Couleur GCD",

    ["cb_section_interrupt"]             = "Retour d'interruption",
    ["opt_cb_show_interrupt_feedback"]   = "Afficher le texte d'interruption",
    ["opt_cb_interrupt_fb_color"]        = "Couleur du texte",
    ["opt_cb_interrupt_fb_size"]         = "Taille de police",
    ["cb_interrupt_feedback_text"]       = "INTERROMPU !",
    ["cb_interrupt_feedback_full"]       = "INTERROMPU : %s",
    ["cb_interrupted"]                   = "Interrompu",

    ["cb_tab_general"]                   = "Général",
    ["cb_tab_player"]                    = "Joueur",
    ["cb_tab_target"]                    = "Cible",
    ["cb_tab_focus"]                     = "Focus",
    ["cb_tab_pet"]                       = "Familier",
    ["cb_tab_boss"]                      = "Boss",

    ["cb_section_unit"]                  = "Barre de %s",
    ["opt_cb_unit_enable"]               = "Activer",
    ["opt_cb_unit_width"]                = "Largeur",
    ["opt_cb_unit_height"]               = "Hauteur",
    ["opt_cb_unit_show_icon"]            = "Afficher l'icône",
    ["opt_cb_unit_icon_side"]            = "Côté de l'icône",
    ["cb_icon_left"]                     = "Gauche",
    ["cb_icon_right"]                    = "Droite",
    ["opt_cb_unit_show_timer"]           = "Afficher le minuteur",
    ["opt_cb_unit_show_latency"]         = "Afficher la latence",
    ["info_cb_latency"]                  = "Affiche un overlay sombre montrant la latence réseau à la fin de la barre.",
    ["info_cb_position"]                 = "Utilisez /tm layout pour déverrouiller et déplacer cette barre.",
    ["btn_cb_reset_position"]            = "Réinitialiser la position",
    ["cb_move_label"]                    = "(Glisser pour déplacer)",
    ["cb_player_missing_notice"]         = "La barre de cast du joueur n'est pas activée — active-la dans les réglages Barres de cast avant de pouvoir la déplacer.",
    ["cb_preview_castbar"]               = "Aperçu : %s",

    ["mover_castbar_standalone"]         = "Barres d'incantation",

    -- ═══════════════════════════════════
    -- Cadres de groupe (Party Frames)
    -- ═══════════════════════════════════
    ["cat_partyframes"]                  = "Cadres de groupe",
    ["mover_partyframes"]                = "Cadres de groupe",

    ["pf_tab_general"]                   = "Général",
    ["pf_tab_features"]                  = "Fonctionnalités",
    ["pf_tab_cooldowns"]                 = "Temps de recharge",
    ["pf_tab_arena"]                     = "Arène",

    ["pf_section_general"]               = "Général",
    ["pf_opt_enable"]                    = "Activer les cadres de groupe",
    ["pf_info_description"]              = "Cadres de groupe personnalisés pour M+ et Arène avec santé, absorption, prédiction de soin, HoTs, suivi CD d'interruption/rez de combat, et mise en évidence de dissipation.",
    ["pf_opt_hide_blizzard"]             = "Masquer les cadres de groupe Blizzard",
    ["pf_opt_sort_role"]                 = "Trier par rôle (Tank > Soigneur > DPS)",

    ["pf_section_dimensions"]            = "Dimensions",
    ["pf_opt_width"]                     = "Largeur du cadre",
    ["pf_opt_height"]                    = "Hauteur du cadre",
    ["pf_opt_spacing"]                   = "Espacement",
    ["pf_opt_grow_direction"]            = "Direction de croissance",
    ["pf_dir_down"]                      = "Bas",
    ["pf_dir_up"]                        = "Haut",
    ["pf_dir_right"]                     = "Droite",
    ["pf_dir_left"]                      = "Gauche",

    ["pf_section_display"]               = "Affichage",
    ["pf_opt_show_name"]                 = "Afficher le nom",
    ["pf_opt_show_health_text"]          = "Afficher le texte de santé",
    ["pf_opt_health_format"]             = "Format de santé",
    ["pf_fmt_deficit"]                   = "Déficit",
    ["pf_opt_health_color"]              = "Mode de couleur de santé",
    ["pf_color_green"]                   = "Vert",
    ["pf_color_gradient"]                = "Dégradé",
    ["pf_opt_show_power"]                = "Afficher la barre de puissance",
    ["pf_opt_power_height"]              = "Hauteur de la barre de puissance",
    ["pf_opt_name_max_length"]           = "Lettres max du nom (0 = illimité)",
    ["pf_opt_show_role"]                 = "Afficher l'icône de rôle",
    ["pf_opt_role_size"]                 = "Taille de l'icône de rôle",
    ["pf_opt_show_leader"]               = "Afficher l'icône de chef",
    ["pf_opt_leader_size"]               = "Taille de l'icône de chef",
    ["pf_opt_show_marker"]               = "Afficher le marqueur de raid",
    ["pf_opt_readycheck_size"]            = "Taille de l'icône de vérification",
    ["pf_opt_summon_size"]               = "Taille de l'indicateur d'invocation",

    ["pf_section_font"]                  = "Police",
    ["pf_opt_font_size"]                 = "Taille de police",

    ["pf_section_position"]              = "Position",
    ["pf_info_position"]                 = "Utilisez /tm layout pour déverrouiller et déplacer les cadres de groupe.",
    ["pf_btn_reset_position"]            = "Réinitialiser la position",

    ["pf_section_health_extras"]         = "Extras de santé",
    ["pf_opt_show_absorb"]               = "Afficher la barre d'absorption",
    ["pf_opt_absorb_color"]              = "Couleur d'absorption",
    ["pf_opt_show_heal_pred"]            = "Afficher la prédiction de soin",

    ["pf_section_range"]                 = "Vérification de portée",
    ["pf_opt_show_range"]                = "Atténuer les membres hors de portée",
    ["pf_opt_oor_alpha"]                 = "Opacité hors de portée",

    ["pf_section_dispel"]                = "Alerte de type de débuff",
    ["pf_opt_show_dispel"]               = "Activer l'alerte de débuff",
    ["pf_opt_show_dispel_border"]        = "Colorer tout le contour selon le débuff",
    ["pf_opt_show_dispel_icon"]          = "Afficher l'icône du débuff prioritaire",
    ["pf_opt_show_dispel_bleed"]         = "Inclure les saignements",
    ["pf_opt_dispel_size"]               = "Taille de l'icône de débuff",
    ["pf_opt_dispel_border_size"]        = "Épaisseur du contour d'alerte",
    ["pf_info_dispel"]                   = "Utilise le moteur d'auras Midnight 12.1 : Magie (bleu), Malédiction (violet), Maladie (orange), Poison (vert), Saignement (rouge). L'icône est celle du débuff réel et le contour n'altère jamais le rendu de la barre de vie.",

    ["pf_section_hots"]                  = "Suivi des HoTs",
    ["pf_opt_show_hots"]                 = "Afficher les indicateurs HoT",
    ["pf_opt_hot_size"]                  = "Taille d'icône HoT",
    ["pf_opt_max_hots"]                  = "Max. HoTs affichés",
    ["pf_opt_hot_duration"]              = "Afficher les secondes restantes sur les HoTs",
    ["pf_info_hots"]                     = "Affiche les effets de soin dans le temps avec des bordures colorées par classe. Compatible Prêtre, Druide, Paladin, Chaman, Moine et Évocateur.",
    ["pf_section_defensives"]            = "Temps de recharge défensifs",
    ["pf_opt_show_defensives"]           = "Afficher les CD défensifs",
    ["pf_opt_defensive_size"]            = "Taille des icônes défensives",
    ["pf_opt_max_defensives"]            = "Max. défensifs affichés",
    ["pf_opt_def_externals"]             = "CD externes (lancés sur ce joueur)",
    ["pf_opt_def_raidwide"]              = "CD de raid",
    ["pf_opt_def_personals"]             = "CD personnels",
    ["pf_info_defensives"]               = "La couleur de bordure indique la catégorie : or pour les externes (Écorce de fer, Cocon de vie, Suppression de la douleur), cyan pour les CD de raid, rouge pour les personnels. Les CD de raid et personnels sont désactivés par défaut car ils s'allument sur tous les cadres en même temps.",

    ["pf_section_cooldowns"]             = "Suivi des temps de recharge",
    ["pf_opt_show_kick"]                 = "Afficher le CD d'interruption",
    ["pf_opt_show_brez"]                 = "Afficher le CD de rez de combat",
    ["pf_opt_cd_size"]                   = "Taille d'icône CD",
    ["pf_opt_cd_layout"]                 = "Disposition des icônes CD",
    ["pf_cd_vertical"]                   = "Vertical (sur le cadre)",
    ["pf_cd_horizontal"]                 = "Horizontal (en dessous)",
    ["pf_info_cooldowns"]                = "Les interruptions sont détectées via UNIT_SPELLCAST_SUCCEEDED. Le rez de combat lit le pool de charges partagé, donc l'icône se grise pour tous dès qu'un rez est utilisé dans l'instance.",

    -- Indicateur de résurrection (groupe)
    ["pf_section_resurrect"]             = "Indicateur de résurrection",
    ["pf_opt_show_resurrect"]            = "Afficher l'icône de résurrection entrante",
    ["pf_opt_resurrect_size"]            = "Taille de l'icône de résurrection",
    ["pf_info_resurrect"]                = "Affiche une icône de rez sur un membre pendant qu'une résurrection est lancée sur lui.",

    ["pf_section_arena"]                 = "Cadres ennemis d'arène",
    ["pf_opt_arena_enable"]              = "Activer les cadres d'arène",
    ["pf_info_arena"]                    = "Affiche la santé, puissance et CD de bijou PvP de l'équipe ennemie en Arène (2v2/3v3).",
    ["pf_section_arena_dims"]            = "Dimensions d'arène",
    ["pf_opt_arena_width"]               = "Largeur",
    ["pf_opt_arena_height"]              = "Hauteur",
    ["pf_opt_arena_spacing"]             = "Espacement",
    ["pf_section_arena_trinket"]         = "Bijou PvP",
    ["pf_opt_show_trinket"]              = "Afficher le CD de bijou",
    ["pf_opt_trinket_size"]              = "Taille d'icône de bijou",
    ["pf_opt_show_spec"]                 = "Afficher l'icône de spécialisation",
    ["pf_section_arena_pos"]             = "Position d'arène",
    ["pf_info_arena_pos"]                = "Utilisez /tm layout pour déverrouiller et déplacer les cadres d'arène.",
    ["pf_btn_reset_arena_pos"]           = "Réinitialiser la position",

    -- ═══════════════════════════════════
    -- Raid Frames
    -- ═══════════════════════════════════
    ["cat_raidframes"]                   = "Cadres de raid",
    ["mover_raidframes"]                 = "Cadres de raid",

    ["rf_tab_general"]                   = "Général",
    ["rf_tab_features"]                  = "Fonctionnalités",

    ["rf_section_general"]               = "Général",
    ["rf_opt_enable"]                    = "Activer les cadres de raid",
    ["rf_info_description"]              = "Cadres de raid personnalisés avec santé, absorption, prédiction de soins, HoTs, debuffs, surbrillance de dissipation, CDs défensifs et vérification de portée.",
    ["rf_opt_hide_blizzard"]             = "Masquer les cadres de raid Blizzard",
    ["rf_opt_skin_group_manager"]       = "Reskin le panneau du leader de groupe (ready check, marqueurs, quitter le groupe)",
    ["rf_opt_sort_role"]                 = "Trier par rôle (Tank > Healer > DPS)",

    ["rf_section_layout"]                = "Disposition",
    ["rf_opt_layout_mode"]               = "Mode de disposition",
    ["rf_layout_grid"]                   = "Grille (groupes en colonnes)",
    ["rf_layout_list"]                   = "Liste (colonne unique)",
    ["rf_opt_width"]                     = "Largeur du cadre",
    ["rf_opt_height"]                    = "Hauteur du cadre",
    ["rf_opt_spacing"]                   = "Espacement",
    ["rf_opt_group_spacing"]             = "Espacement entre groupes",

    ["rf_section_display"]               = "Affichage",
    ["rf_opt_show_name"]                 = "Afficher le nom",
    ["rf_opt_name_max_length"]           = "Lettres max du nom",
    ["rf_opt_show_health_text"]          = "Afficher le texte de santé",
    ["rf_opt_health_format"]             = "Format de santé",
    ["rf_opt_health_color"]              = "Mode de couleur de santé",
    ["rf_opt_show_role"]                 = "Afficher l'icône de rôle",
    ["rf_opt_show_marker"]               = "Afficher le marqueur de raid",
    ["rf_opt_readycheck_size"]            = "Taille de l'icône de vérification",
    ["rf_opt_summon_size"]               = "Taille de l'indicateur d'invocation",

    ["rf_section_font"]                  = "Police",
    ["rf_opt_font_size"]                 = "Taille de police",

    ["rf_section_position"]              = "Position",
    ["rf_info_position"]                 = "Utilisez /tm layout pour déverrouiller et déplacer les cadres de raid.",
    ["rf_btn_reset_position"]            = "Réinitialiser la position",
    ["rf_info_test_raid"]                = "Simulez un raid de 20 joueurs pour prévisualiser la mise en page hors combat.",
    ["rf_btn_test_raid"]                 = "Simuler 20 joueurs",
    ["rf_btn_test_raid_stop"]            = "Arrêter la simulation",
    ["rf_preview_group"]                 = "G",
    ["rf_mode_raid"]                     = "Raid",
    ["rf_mode_solo"]                     = "Solo",

    ["rf_section_health_extras"]         = "Fonctions de santé",
    ["rf_opt_show_power"]                = "Barre de puissance (healers uniquement)",
    ["rf_opt_power_height"]              = "Hauteur de la barre de puissance",
    ["rf_opt_show_absorb"]               = "Afficher la barre d'absorption",
    ["rf_opt_show_heal_pred"]            = "Afficher la prédiction de soins",

    ["rf_section_range"]                 = "Vérification de portée",
    ["rf_opt_show_range"]                = "Estomper les membres hors portée",
    ["rf_opt_oor_alpha"]                 = "Opacité hors portée",

    ["rf_section_dispel"]                = "Alerte de type de débuff",
    ["rf_opt_show_dispel"]               = "Activer l'alerte de débuff",
    ["rf_opt_show_dispel_border"]        = "Colorer tout le contour selon le débuff",
    ["rf_opt_show_dispel_icon"]          = "Afficher l'icône du débuff prioritaire",
    ["rf_opt_show_dispel_bleed"]         = "Inclure les saignements",
    ["rf_opt_dispel_size"]               = "Taille de l'icône de débuff",
    ["rf_opt_dispel_border_size"]        = "Épaisseur du contour d'alerte",
    ["rf_info_dispel"]                   = "Magie = bleu, Malédiction = violet, Maladie = orange, Poison = vert, Saignement = rouge. Les AuraSlots du moteur 12.1 gardent l'affichage sûr en combat même quand les données d'aura sont protégées.",

    ["rf_section_hots"]                  = "Suivi des HoTs",
    ["rf_opt_show_hots"]                 = "Afficher les indicateurs HoT",
    ["rf_opt_hot_size"]                  = "Taille des icônes HoT",
    ["rf_opt_max_hots"]                  = "HoTs max affichés",
    ["rf_opt_hot_duration"]              = "Afficher les secondes restantes sur les HoTs",

    ["rf_section_debuffs"]               = "Suivi des debuffs",
    ["rf_opt_show_debuffs"]              = "Afficher les icônes de debuff",
    ["rf_opt_debuff_size"]               = "Taille des icônes de debuff",
    ["rf_opt_max_debuffs"]               = "Debuffs max affichés",

    ["rf_section_defensives"]            = "CDs défensifs",
    ["rf_opt_show_defensives"]           = "Afficher les buffs défensifs actifs",
    ["rf_opt_defensive_size"]            = "Taille de l'icône défensive",
    ["rf_opt_max_defensives"]            = "Max. défensifs affichés",
    ["rf_opt_def_externals"]             = "CD externes (lancés sur ce joueur)",
    ["rf_opt_def_raidwide"]              = "CD de raid",
    ["rf_opt_def_personals"]             = "CD personnels",
    ["rf_info_defensives"]               = "Affiche les CDs défensifs actifs (ex: Suppression de la douleur, Écorce de fer, Bouclier divin) sur chaque membre du raid.",

    -- Indicateur de résurrection (raid)
    ["rf_section_resurrect"]             = "Indicateur de résurrection",
    ["rf_opt_show_resurrect"]            = "Afficher l'icône de résurrection entrante",
    ["rf_opt_resurrect_size"]            = "Taille de l'icône de résurrection",
    ["rf_info_resurrect"]                = "Affiche une icône de rez sur un membre pendant qu'une résurrection est lancée sur lui (rez de combat ou normal).",

    -- Compteur de rez de combat
    ["rf_section_battlerez"]             = "Compteur de rez de combat",
    ["rf_opt_br_enable"]                 = "Afficher le compteur de rez de combat",
    ["rf_opt_br_only_instance"]          = "Uniquement dans les donjons/raids",
    ["rf_opt_br_size"]                   = "Taille du compteur",
    ["rf_opt_br_font"]                   = "Taille de police du compteur",
    ["rf_info_battlerez"]                = "Un compteur déplaçable indiquant combien de rez de combat sont disponibles et le temps avant la prochaine charge. Lit le pool partagé, compatible avec toutes les classes. Déplacez-le avec /tm layout.",

    -- Disposition par taille
    ["rf_section_size_overrides"]        = "Disposition par taille (10/25/40)",
    ["rf_opt_overrides_enable"]          = "Activer les dispositions par taille",
    ["rf_info_size_overrides"]           = "Si activé, la taille des cadres s'adapte automatiquement à la taille du groupe (espacement auto par palier).",
    ["rf_ov_small"]                      = "Petit  (jusqu'à 10)",
    ["rf_ov_medium"]                     = "Moyen  (jusqu'à 25)",
    ["rf_ov_large"]                      = "Grand  (26-40)",
    ["rf_ov_width"]                      = "Largeur",
    ["rf_ov_height"]                     = "Hauteur",

    -- ═══════════════════════════════════
    -- Aura Tracker
    -- ═══════════════════════════════════
    ["mover_battlerez"]                  = "Compteur de rez",
    ["mover_preytracker"]                = "Traqueur de proie",
    ["mover_extrabuttons"]               = "Bouton supplémentaire",

    ["at_section_general"]               = "Général",
    ["at_opt_enable"]                    = "Activer le suivi d'auras",
    ["at_info_description"]              = "Suit les buffs importants : procs de bijou, procs d'enchantement d'arme, buffs personnels et défensifs dans un overlay d'icônes.",

    ["at_section_appearance"]            = "Apparence",
    ["at_opt_icon_size"]                 = "Taille d'icône",
    ["at_opt_spacing"]                   = "Espacement",
    ["at_opt_max_icons"]                 = "Max. icônes",
    ["at_opt_grow_direction"]            = "Direction de croissance",
    ["at_opt_font_size"]                 = "Taille de police",

    ["at_section_display"]               = "Affichage",
    ["at_opt_show_timer"]                = "Afficher le minuteur",
    ["at_opt_show_stacks"]               = "Afficher le nombre de cumuls",
    ["at_opt_show_glow"]                 = "Lueur sur nouveau proc",
    ["at_opt_timer_threshold"]           = "Seuil de clignotement (sec)",

    ["at_section_categories"]            = "Catégories",
    ["at_info_categories"]               = "Choisissez quelles catégories d'auras suivre.",
    ["at_cat_trinkets"]                  = "Procs de bijou",
    ["at_cat_enchants"]                  = "Procs d'enchantement d'arme",
    ["at_cat_selfbuffs"]                 = "Buffs personnels (CDs)",
    ["at_cat_raidbuffs"]                 = "Buffs de raid",
    ["at_cat_defensives"]                = "Défensifs (externes + personnels)",

    ["at_section_position"]              = "Position",
    ["at_info_position"]                 = "Utilisez /tm layout pour déverrouiller et déplacer le suivi d'auras.",
    ["at_btn_reset_position"]            = "Réinitialiser la position",

    -- ═══════════════════════════════════
    -- Battle Text
    -- ═══════════════════════════════════
    ["cat_battletext"]                   = "Texte de combat",
    ["mover_battletext"]                 = "Texte de combat",

    ["bt_section_general"]               = "Général",
    ["bt_info_description"]              = "Texte de combat défilant : dégâts et soins, entrants et sortants.",
    ["bt_opt_enable"]                    = "Activer le texte de combat",

    ["bt_section_display"]               = "Affichage",
    ["bt_opt_outgoing"]                  = "Afficher les dégâts sortants",
    ["bt_opt_incoming"]                  = "Afficher les dégâts entrants",
    ["bt_opt_overheal"]                  = "Afficher le sur-soin",
    ["bt_opt_throttle"]                  = "Fusionner les ticks DoT/HoT",

    ["bt_section_appearance"]            = "Apparence",
    ["bt_opt_font_size"]                 = "Taille de police",
    ["bt_opt_throttle_window"]           = "Fenêtre de fusion (sec)",

    ["bt_section_position"]              = "Position",
    ["bt_info_position"]                 = "Utilisez /tm layout pour déverrouiller et déplacer les zones.",
    ["bt_btn_reset_position"]            = "Réinitialiser les positions",

    ["bt_zone_outgoing"]                 = "Sortants",
    ["bt_zone_incoming"]                 = "Entrants",
    ["bt_zone_heal_out"]                 = "Soins sortants",
    ["bt_zone_heal_in"]                  = "Soins reçus",

    ["bt_cmd_help"]                      = "/tm bt <cmd>",
    ["bt_enabled"]                       = "activé",
    ["bt_disabled"]                      = "désactivé",
    ["bt_crit"]                          = "!",
    ["bt_zones_locked"]                  = "zones verrouillées",
    ["bt_zones_unlocked"]                = "zones déverrouillées",
    ["bt_reset_done"]                    = "positions réinitialisées.",
    ["bt_miss_miss"]                     = "Raté",
    ["bt_miss_dodge"]                    = "Esquive",
    ["bt_miss_parry"]                    = "Parade",
    ["bt_miss_block"]                    = "Bloqué",
    ["bt_miss_resist"]                   = "Résisté",
    ["bt_miss_absorb"]                   = "Absorbé",
    ["bt_miss_immune"]                   = "Immunisé",
    ["bt_miss_evade"]                    = "Évasion",
    ["bt_miss_deflect"]                  = "Dévié",
    ["bt_miss_reflect"]                  = "Reflété",

    -- =====================
    -- CONFIG: Panneau Diagnostics
    -- =====================
    ["section_diagnostics"]              = "Diagnostics",
    ["opt_diag_enabled"]                 = "Activer la capture d'erreurs",
    ["opt_diag_capture_all"]             = "Capturer tous les addons",
    ["opt_diag_suppress_popups"]         = "Supprimer les popups d'erreur",
    ["opt_diag_auto_open"]               = "Ouvrir auto. si erreur TomoMod",
    ["btn_diag_open_console"]            = "Ouvrir la console",
    ["btn_diag_clear"]                   = "Effacer les erreurs",
    ["btn_diag_export"]                  = "Copier le rapport",
    ["btn_diag_export_tracker"]          = "Exporter pour le Tracker",
    ["info_diag_desc"]                   = "Capture les erreurs Lua en arrière-plan sans popup en combat. Tapez /tmdiag pour ouvrir la console.",
    ["info_diag_session"]                = "Session : #%d — %d erreurs capturées (%d TomoMod)",
    ["info_diag_capture_all_desc"]       = "Quand désactivé, seules les erreurs TomoMod sont capturées. Activez pour capturer toutes les erreurs d'addons.",

    -- =====================
    -- HOUSING
    -- =====================
    ["cat_housing"]                  = "Housing",
    ["section_housing_general"]      = "Housing — Général",
    ["section_housing_hover"]        = "Info décor (survol)",
    ["section_housing_clock"]        = "Horloge de l'éditeur",
    ["section_housing_teleport"]     = "Téléportation",
    ["section_housing_commands"]     = "Commandes",

    ["info_housing_desc"]            = "Module Housing : améliore l'éditeur de maison et ajoute des raccourcis de téléportation. Nécessite l'extension Midnight / The War Within.",
    ["info_housing_hover"]           = "En mode 'Décor de base', affiche le nom, le coût de placement et le stock restant du décor survolé. Permet aussi de dupliquer un décor avec une touche modificatrice.",
    ["info_housing_clock"]           = "Affiche une horloge et comptabilise le temps passé dans l'éditeur de maison. Clic droit sur l'horloge pour basculer analogique / digital.",
    ["info_housing_teleport"]        = "Active la commande /tm home : téléporte vers votre maison ou la quitte automatiquement si vous êtes en visite.",
    ["info_housing_commands"]        = "• /tm home — téléporter vers votre maison (ou la quitter)\n• /tm housing — ouvre ce panneau\n• Clic droit sur l'horloge — bascule analogique/digital",

    ["opt_housing_enable"]           = "Activer le module Housing",
    ["opt_housing_decorhover"]       = "Activer l'info décor",
    ["opt_housing_dupe"]             = "Activer la duplication rapide (modificateur)",
    ["opt_housing_dupekey"]          = "Touche de duplication",
    ["opt_housing_clock"]            = "Activer l'horloge",
    ["opt_housing_clock_analog"]     = "Mode analogique (sinon digital)",
    ["opt_housing_teleport"]         = "Activer la téléportation /tm home",

    ["btn_housing_tp_home"]          = "Téléporter (test)",
    ["btn_housing_refresh"]          = "Rafraîchir les maisons",

    ["housing_duplicate"]            = "Dupliquer",
    ["housing_alliance_zone"]        = "Promontoire des Fondateurs",
    ["housing_horde_zone"]           = "Rivages de Lamevent",
    ["housing_clock_title"]          = "TomoMod — Horloge",
    ["housing_clock_time"]           = "Heure",
    ["housing_clock_local"]          = "Heure locale :",
    ["housing_clock_realm"]          = "Heure royaume :",
    ["housing_clock_time_spent"]     = "Temps dans l'éditeur",
    ["housing_clock_session"]        = "Cette session :",
    ["housing_clock_total"]          = "Total :",
    ["housing_clock_rightclick"]     = "Clic droit pour basculer analogique / digital",

    ["msg_help_home"]                = "Téléporter vers votre maison (ou la quitter)",
    ["msg_help_housing"]             = "Ouvrir le panneau Housing",
    ["msg_housing_refresh"]          = "Informations maisons demandées.",
    ["msg_housing_unavailable"]      = "Module Housing indisponible sur ce client.",

    -- =========== What's New Popup ===========

    -- 2.9.8

    -- 2.9.6

    -- 2.9.7


    -- 2.9.5

    -- 2.9.4

    -- 2.9.3

    -- 2.9.2

    -- ═══════════════════════════════════
    -- Merchant Tools (2.9.9)
    -- ═══════════════════════════════════

    ["tab_qol_merchant_tools"]           = "Outils vendeur",

    -- Consumable Bar (3.0.4)
    ["tab_qol_consumable_bar"]           = "Consommables",
    ["section_consumable_bar"]           = "Barre de consommables",
    ["info_cb_desc"]                     = "Affiche une icône + timer pour chaque consommable actif\194\160: flacon (1h), bien nourri (1h) et huile sur arme (2h). Le slot huile main secondaire n'apparaît que si une arme est équipée en main secondaire.",
    ["opt_consumable_enable"]            = "Activer la barre de consommables",
    ["opt_cb_show_missing"]              = "Afficher les buffs manquants (fantôme)",
    ["opt_cb_icon_size"]                 = "Taille des icônes",
    ["opt_cb_gap"]                       = "Écart entre les icônes",
    ["opt_cb_orientation"]               = "Orientation",
    ["cb_orient_horizontal"]             = "Horizontale",
    ["cb_orient_vertical"]               = "Verticale",
    ["opt_cb_timer_pos"]                 = "Position du timer",
    ["cb_timerpos_below"]                = "Dessous (horizontal)",
    ["cb_timerpos_above"]                = "Dessus (horizontal)",
    ["cb_timerpos_right"]                = "Droite (vertical)",
    ["cb_timerpos_left"]                 = "Gauche (vertical)",
    ["mover_consumable_bar"]             = "Barre de consommables",
    ["mover_class_reminder"]             = "Rappel de classe",

    ["section_already_known"]            = "Déjà connu",
    ["info_already_known"]               = "Désature ou teinte les objets déjà possédés (montures, mascottes, jouets, transmogrification, recettes) dans les fenêtres du marchand et des rachats.",
    ["opt_ak_enable"]                    = "Activer Déjà connu",
    ["opt_ak_mode"]                      = "Mode d'affichage",
    ["ak_mode_mono"]                     = "Monochrome (gris)",
    ["ak_mode_color"]                    = "Teinte colorée",
    ["opt_ak_color"]                     = "Couleur de teinte",

    ["section_extend_pages"]             = "Pages vendeur étendues",
    ["info_extend_pages"]                = "Ajoute des colonnes supplémentaires à la fenêtre du marchand pour afficher plus d'objets par page.\nNécessite un rechargement de l'interface après activation ou changement du nombre de colonnes.",
    ["opt_ep_enable"]                    = "Activer les pages étendues",
    ["opt_ep_columns"]                   = "Nombre de colonnes",

    ["preset_complet_name"]  = "Recommandé",
    ["preset_complet_tag"]   = "L'expérience TomoMod complète",
    ["preset_complet_desc"]  = "Active tous les modules principaux avec des réglages cohérents : unit frames, cadres de groupe et de raid, nameplates, barres d'incantation, ressources, skin des barres d'action, tous les skins visuels, les outils Mythic+ et les fonctions de confort les plus utiles. Le meilleur point de départ pour la plupart des joueurs.",
    ["preset_tank_name"]     = "Tank",
    ["preset_tank_tag"]      = "Axé menace, nameplates élargies",
    ["preset_tank_desc"]     = "La configuration Recommandée, ajustée pour le tanking : nameplates colorées selon la menace (Mode Tank) et un peu plus larges pour mieux lire l'aggro, plus l'indicateur de menace sur la cible.",
    ["preset_healer_name"]   = "Soigneur",
    ["preset_healer_tag"]    = "Cadres de raid plus grands, mana visible",
    ["preset_healer_desc"]   = "La configuration Recommandée, ajustée pour le soin : cadres de raid et de groupe plus grands et plus faciles à cliquer, avec les barres de ressource (mana) affichées, le suivi des HoTs, la surbrillance de dissipation et les défensifs bien en évidence.",
    ["preset_dps_name"]      = "DPS",
    ["preset_dps_tag"]       = "Ressources et cooldowns mis en avant",
    ["preset_dps_desc"]      = "La configuration Recommandée, ajustée pour les dégâts : barre de ressource plus visible, suivi des buffs de la cible pour repérer les défensifs ennemis, et nameplates épurées sans coloration de menace tank.",
    ["preset_minimal_name"]  = "Minimal",
    ["preset_minimal_tag"]   = "Juste l'essentiel",
    ["preset_minimal_desc"]  = "Une empreinte légère : on garde les unit frames, les cadres de groupe et de raid, les barres d'incantation, les barres de ressource, la minimap et les automatisations essentielles — tout le cosmétique (skins, chat, sacs, nameplates, panneaux annexes) reste désactivé. Au plus proche d'une sensation vanilla.",
    ["preset_custom_name"]   = "Personnalisé",
    ["preset_custom_tag"]    = "Tout configurer soi-même",
    ["preset_custom_desc"]   = "Passez les presets et parcourez chaque catégorie étape par étape pour activer exactement ce que vous voulez. Tout reste modifiable ensuite via /tm.",
    ["preset_applied"]       = "Preset appliqué : %s — tapez /reload pour voir le résultat.",
    ["preset_unknown"]       = "Preset inconnu « %s ». Disponibles : complet, tank, healer, dps, minimal.",
    ["preset_usage"]         = "Usage : /tmpreset <complet|tank|healer|dps|minimal>",
    ["ins_v3_welcome_desc"]      = "Bienvenue ! Cet assistant rapide te prépare une interface propre et complète en quelques secondes.\n\nChoisis une configuration qui correspond à ta façon de jouer — tu pourras tout ajuster ensuite via |cffffd100/tm|r. Tu préfères choisir chaque option toi-même ? Prends |cffc89530Personnalisé|r.",
    ["ins_pick_title"]           = "Choisis ta configuration",
    ["ins_pick_subtitle"]        = "Sélectionne un style de jeu ci-dessous. Tout reste ajustable ensuite via /tm.",
    ["ins_pick_recommended"]     = "Recommandé",
    ["ins_custom_frames_title"]  = "Cadres",
    ["ins_custom_barsskins_title"] = "Barres & Skins",
    ["ins_custom_mythicqol_title"] = "Mythic+ & Confort",
    ["ins_custom_frames_intro"]  = "Active les cadres que tu veux. Les options conseillées sont pré-cochées.",
    ["ins_custom_barsskins_intro"] = "Skin des barres d'action et skins visuels : chat, sacs, infobulles et plus.",
    ["ins_custom_mythicqol_intro"] = "Outils Mythic+, options d'interface, automatisations et son.",
    ["ins_recap_title"]          = "Tout est prêt",
    ["ins_recap_preset"]         = "Configuration appliquée : |cffffd100%s|r",
    ["ins_recap_custom"]         = "Ta configuration personnalisée est prête",
    ["ins_recap_desc"]           = "Recharge ton interface pour tout appliquer. Tu peux rouvrir cet assistant à tout moment avec |cffffd100/tm install|r, et ouvrir le panneau de configuration complet avec |cffffd100/tm|r.",
    ["cat_accueil"]              = "Accueil",
    ["ui_search_placeholder"]    = "Rechercher un réglage...",
    ["dash_welcome"]             = "Vue d'ensemble de TomoMod. Active des modules, applique une configuration, change de profil ou relance l'assistant.",
    ["dash_modules_section"]     = "Modules",
    ["dash_quickcfg_section"]    = "Configuration rapide",
    ["dash_studio_section"]           = "Cooldown Studio",
    ["dash_studio_info"]              = "\195\137diteur plein \195\169cran des barres de cooldowns : disposition, style, sorts et visibilit\195\169.",
    ["dash_studio_open"]              = "Ouvrir le Cooldown Studio",
    ["dash_profile_section"]     = "Profil",
    ["dash_maint_section"]       = "Maintenance",
    ["dash_reload_hint"]         = "Les modules sont appliqués à chaud. Les changements protégés sont appliqués automatiquement à la fin du combat.",
    ["dash_reload_now"]          = "Recharger maintenant",
    ["dash_apply_preset"]        = "Preset de configuration",
    ["dash_apply_preset_btn"]    = "Appliquer ce preset",
    ["dash_apply_preset_info"]   = "Appliquer un preset réinitialise quels modules sont activés ou non, puis recharge.",
    ["dash_active_profile"]      = "Profil actif",
    ["dash_manage_profiles"]     = "Gérer les profils",
    ["dash_profile_info"]        = "Changer de profil recharge l'interface pour l'appliquer.",
    ["dash_relaunch_info"]       = "Rouvre l'assistant de configuration « presets d'abord ».",
    ["dash_mod_resources"]       = "Ressources",
    ["dash_mod_cdm"]             = "Cooldown Manager",
    ["dash_mod_abskin"]          = "Skin des barres d'action",
    ["dash_mod_chatskin"]        = "Skin du chat",
    ["dash_mod_bagskin"]         = "Skin des sacs",
    ["dash_mod_mtracker"]        = "Suivi Mythic+",
    ["dash_mod_score"]           = "Score Mythic+",
    ["dash_reload_popup"]        = "Recharger l'interface maintenant pour appliquer tes changements ?",

    -- ═══════════════════════════════════
    -- MythicTracker Noms EJ (2.9.10)
    -- ═══════════════════════════════════
    -- ═══════════════════════════════════
    -- Correction CD PartyFrame + Performances (2.9.12)
    -- ═══════════════════════════════════
    -- ═══════════════════════════════════
    -- =======================================
    -- Installer Overhaul & AB Toggle (2.9.17)
    -- =======================================
    -- ═══════════════════════════════════
    -- Waypoint intelligent (2.9.20)
    -- ═══════════════════════════════════

    -- Suivi des objectifs — Stabilité (2.9.19)
    -- ═══════════════════════════════════

    -- ═══════════════════════════════════
    -- Suivi des objectifs — Catégories (2.9.18)
    -- ═══════════════════════════════════


    -- AuctionRecipeTracker (2.9.15)
    -- ═══════════════════════════════════

    -- ═══════════════════════════════════
    -- MythicTracker Boss Names Fix (2.9.13)
    -- ═══════════════════════════════════


    -- ═══════════════════════════════════
    -- Corrections CooldownManager / ProcGlow / BuffSkin (2.9.11)
    -- ═══════════════════════════════════

    -- ═══════════════════════════════════
    -- MythicTracker Noms EJ (2.9.10)
    -- ═══════════════════════════════════

    -- =====================
    -- AuctionRecipeTracker
    -- =====================
    ["art_title"]            = "Suivi de recettes",
    ["art_no_recipes"]       = "Aucune recette suivie — suivez une recette depuis votre fenêtre de métier.",
    ["art_status_idle"]      = "Cliquez sur un ingrédient pour le chercher à l'HDV.",
    ["art_scan_btn"]         = "Scanner l'HDV",
    ["art_scan_running"]     = "Scan en cours...",
    ["art_scan_started"]     = "Scan démarré — veuillez patienter...",
    ["art_scan_done"]        = "Scan terminé : %d objets enregistrés.",
    ["art_scan_failed"]      = "Scan échoué ou interrompu.",
    ["art_scan_cooldown"]    = "Prochain scan disponible dans %dm %ds.",
    ["art_scan_tip_title"]   = "Scan complet de l'Hôtel des Ventes",
    ["art_scan_tip_desc"]    = "Enregistre le prix d'achat immédiat le plus bas par objet. Limité à une fois toutes les 15 minutes.",
    ["art_only_at_ah"]       = "Ouvrez d'abord l'Hôtel des Ventes.",
    ["art_scan_already"]     = "Un scan est déjà en cours.",
    ["art_tt_stack"]         = "Pile",
    ["art_tt_scanned"]       = "Scanné",
    ["art_tt_just_now"]      = "à l'instant",
    ["art_tt_min_ago"]       = "il y a %dm",
    ["art_tt_hour_ago"]      = "il y a %dh",
    ["art_tt_day_ago"]       = "il y a %dj",

    -- Player Auras Mover (v2.9.5)
    ["mover_player_auras"]       = "Auras du joueur",
    ["opt_auras_spacing"]        = "Espacement entre icônes",
    ["btn_reset_aura_position"]  = "Réinitialiser position auras",

    -- Module Reload Safety (v2.9.21)
    ["msg_module_reload"]        = "Ce changement nécessite un rechargement de l'interface.\nRecharger maintenant ?",
    ["info_module_reload"]       = "Nécessite un /reload pour prendre effet.",

    -- Waypoint Arrow Reversed (v2.9.22)

    -- 3.0.4

    -- 3.0.3

    -- 3.0.0

    -- =====================
    -- QOL: Rare Alert (RareAlert.lua)
    -- =====================
    ["tab_qol_rare_alert"]       = "Alerte Rare",
    ["section_rare_alert"]       = "Alerte Rare",
    ["opt_rare_alert_enable"]    = "Activer les alertes de rare à proximité",
    ["opt_rare_alert_sound"]     = "Jouer un son d'alerte",
    ["opt_rare_alert_duration"]  = "Durée d'affichage de la bannière (s)",
    ["btn_reset_rare_alert_pos"] = "Réinitialiser la position de la bannière",
    ["rare_alert_info"]          = "Vous avertit quand un PNJ rare est à proximité. Cliquez la bannière pour le cibler, poser la Tête de mort et créer un point de route. Clic droit pour fermer. Utilisez /tm layout pour déplacer la bannière.",
    ["rare_alert_tooltip"]       = "Clic gauche : cibler + Tête de mort + point de route. Clic droit : fermer.",

    -- 3.0.5

    -- =====================
    -- Extra Action Button (v3.0.6)
    -- =====================
    ["mover_ab_extra"] = "Bouton extra",
    ["mover_ab_pet"] = "Barre du familier",
    ["mover_ab_stance"] = "Barre de posture",
    ["section_extra_button"] = "Bouton d'action supplémentaire",
    ["opt_extra_enabled"] = "Gérer le bouton d'action supplémentaire (recharge pour libérer)",
    ["opt_extra_scale"] = "Échelle du bouton supplémentaire",
    ["btn_extra_reset_pos"] = "Réinitialiser la position",
    ["info_extra_button"] = "Positionnez le bouton d'action supplémentaire en mode Layout. Il apparaît pendant les quêtes et les combats de boss. Le désactiver le rend à Blizzard après un /reload.",
    -- 3.0.7

    -- 3.1.1
    ["art_searching"]        = "Recherche : %s",
    ["art_searching_qty"]    = "Recherche : %s × %d",

    -- 3.1.2

    -- 3.1.3

    -- Ancrage infobulle
    ["opt_tooltip_anchor"]        = "Position de l'infobulle",
    ["tooltip_anchor_default"]    = "Défaut",
    ["tooltip_anchor_cursor"]     = "Souris",
    ["tooltip_anchor_corner"]     = "Coin de l'écran",
    ["tooltip_anchor_custom"]     = "Personnalisé",
    ["opt_tooltip_anchor_corner"] = "Coin (mode Coin)",
    ["corner_br"]                 = "Bas droite",
    ["corner_bl"]                 = "Bas gauche",
    ["corner_tr"]                 = "Haut droite",
    ["corner_tl"]                 = "Haut gauche",
    ["info_tooltip_anchor"]       = "Personnalisé : choisis ce mode puis glisse le cadre teal à l'endroit voulu.",
    ["btn_tooltip_toggle_anchor"] = "Afficher/Masquer le repère",
    ["mover_tooltip_anchor"]      = "Ancre de l'infobulle",

    -- Nameplates preview
    ["np_preview_title"]   = "Aperçu des plaques",
    ["np_preview_hint"]    = "Lisibilité rapide : couleur, cast, auras et menace au même endroit.",
    ["preview_np_friendly"] = "Allié",
    ["preview_np_target"]  = "Cible hostile",
    ["preview_np_boss"]    = "Boss marqué",

    -- 3.1.4

    -- 3.1.5

    -- 3.1.6

    -- 3.1.7

    -- 3.1.8

    -- 3.1.9

    -- 3.1.11

    -- ChatFrameUI (panneau de config — libellés affichés dans Skins)
    ["sublabel_chatframeui"]        = "— UI de fenêtre de chat multi-positions —",
    ["opt_cfui_enable"]             = "Activer l'UI de fenêtre de chat",
    ["opt_cfui_editbox_height"]     = "Hauteur du champ de saisie",
    ["opt_cfui_editbox_position"]   = "Position du champ de saisie",
    ["opt_cfui_frame_topleft"]      = "Fenêtre en haut à gauche",
    ["opt_cfui_frame_topright"]     = "Fenêtre en haut à droite",
    ["opt_cfui_frame_bottomleft"]   = "Fenêtre en bas à gauche",
    ["opt_cfui_frame_bottomright"]  = "Fenêtre en bas à droite",
    ["opt_cfui_icons_anchor"]       = "Ancrage des icônes latérales",
    ["opt_cfui_raid_frame_mgr"]     = "Reskin du gestionnaire de cadres de raid",
    ["opt_cfui_swap_in_combat"]     = "Autoriser le changement de boutons en combat",
    -- =====================
    -- CONFIG: Categories, tabs & shell (ConfigUI.lua) [Lot D1]
    -- =====================
    ["cat_interface"]         = "Interface",
    ["cat_units"]             = "Unités",
    ["cat_combat"]            = "Combat",
    ["cat_comfort"]           = "Confort",
    ["cat_tools"]             = "Outils",
    ["cat_accueil_desc"]      = "Vue d'ensemble, presets et actions rapides.",
    ["cat_interface_desc"]    = "Apparence globale, barres, sons et fenêtres Blizzard.",
    ["cat_units_desc"]        = "Joueur, plaques, groupe et raid au même endroit.",
    ["cat_combat_desc"]       = "Incantations, ressources, cooldowns et Mythic+.",
    ["cat_comfort_desc"]      = "Automatisations, quêtes, AFK, logement et confort.",
    ["cat_changelog"]                 = "Nouveaut\195\169s",
    ["cat_changelog_desc"]            = "Toutes les notes de version, de la plus r\195\169cente \195\160 la plus ancienne.",
    ["cl_title"]                      = "Notes de version",
    ["cl_intro"]                      = "%d versions. Clique sur un num\195\169ro pour lire ses notes.",
    ["cl_unavailable"]                = "Les notes de version n\226\128\153ont pas pu \195\170tre charg\195\169es.",
    ["cat_tools_desc"]        = "Profils, sauvegardes, diagnostics et maintenance.",
    ["cat_profiles_desc"]     = "Profils, spécialisations, import / export et réinitialisations.",
    ["cat_diagnostics_desc"]  = "État en direct, erreurs Lua et relevés de performance.",
    ["cat_damagemeter"]                 = "Damage Meter",
    ["cat_damagemeter_desc"]            = "Compteur de d\195\169g\195\162ts, r\195\169cap de mort et r\195\169cap de donjon.",
    ["dm_cfg_title"]                    = "Damage Meter",
    ["dm_cfg_intro"]                    = "Le compteur conserve pour l\226\128\153instant sa propre fen\195\170tre de r\195\169glages. Elle sera int\195\169gr\195\169e ici prochainement.",
    ["dm_cfg_open"]                     = "Ouvrir les r\195\169glages du damage meter",
    ["dm_cfg_toggle"]                   = "Afficher / masquer les fen\195\170tres",
    ["dm_cfg_standalone"]               = "L\226\128\153addon TomoDamageMeter autonome est install\195\169 : c\226\128\153est lui qui g\195\168re le compteur. Le module int\195\169gr\195\169 reste en veille pour \195\169viter deux fen\195\170tres concurrentes.",
    ["dm_cfg_unavailable"]              = "Le compteur de d\195\169g\195\162ts de Blizzard n\226\128\153est pas disponible sur ce client, le module est inactif.",
    ["cfg_tab_general"]       = "Général",
    ["cfg_tab_actionbars"]    = "Barres d'action",
    ["cfg_tab_skins"]         = "Skins",
    ["cfg_tab_sound"]         = "Son",
    ["cfg_tab_unitframes"]    = "UnitFrames",
    ["cfg_tab_nameplates"]    = "Nameplates",
    ["cfg_tab_partyframes"]   = "Groupe",
    ["cfg_tab_raidframes"]    = "Raid",
    ["cfg_tab_castbars"]      = "Incantations",
    ["cfg_tab_resources"]     = "CD & Ressource",
    ["cfg_tab_mythicplus"]    = "Mythic+",
    ["cfg_tab_qol"]           = "Qualité de vie",
    ["cfg_tab_housing"]       = "Housing",
    ["cfg_tab_profiles"]      = "Profils",
    ["cfg_tab_diagnostics"]   = "Diagnostics",
    ["cfg_reload_text"]       = "Recharger l'interface pour appliquer ce changement ?",
    ["cfg_reload_confirm"]    = "Recharger",
    ["cfg_reload_later"]      = "Plus tard",
    ["cfg_footer_perf"]       = "FPS: %d  |  Mém: %s",
    -- =====================
    -- CONFIG: CD/Resource & Profiles panels [Lot D2]
    -- =====================
    ["section_cdm_alpha"]             = "Opacité",
    ["opt_rb_primary_centered"]       = "Afficher la ressource principale au centre",
    ["info_rb_primary_centered"]      = "Déplace la barre de mana/énergie/rage de la frame joueur vers le centre de l'écran.",
    ["opt_rb_primary_power_height"]   = "Hauteur barre principale",
    ["import_preview_analyzing"]      = "Analyse...",
    ["profiles_export_failed"]        = "Export échoué",
    ["profiles_import_failed"]        = "Import échoué",
    ["profiles_error"]                = "Erreur",
    ["profiles_rename_failed"]        = "Erreur renommage",
    -- =====================
    -- CONFIG: General panel — minimap & buttonbag [Lot D3]
    -- =====================
    ["section_minimap_indicators"]    = "Indicateurs de la minimap",
    ["info_minimap_indicators"]       = "Choisis un indicateur, puis règle son coin, sa taille et son décalage. Appliqué en direct.",
    ["opt_indicator"]                 = "Indicateur",
    ["opt_corner"]                    = "Coin",
    ["opt_offset_x"]                  = "Décalage X",
    ["opt_offset_y"]                  = "Décalage Y",
    ["corner_topleft"]                = "Haut gauche",
    ["corner_topright"]               = "Haut droite",
    ["corner_bottomleft"]             = "Bas gauche",
    ["corner_bottomright"]            = "Bas droite",
    ["opt_minimap_tracking"]          = "Bouton de pistage",
    ["opt_tracking_style"]            = "Style du bouton de pistage",
    ["opt_minimap_mail"]              = "Courrier",
    ["opt_minimap_difficulty"]        = "Difficulté",
    ["opt_minimap_expansion"]         = "Bouton d'extension",
    ["opt_minimap_crafting"]          = "Commandes de craft",
    ["minimap_style_bliz"]            = "Blizzard",
    ["minimap_style_tomo"]            = "TomoMod",
    ["section_buttonbag"]             = "Boutons d'addon",
    ["info_buttonbag"]                = "Regroupe les boutons d'addon de la minimap dans une boîte. Clique le bouton sur la minimap pour l'ouvrir.",
    ["opt_buttonbag_enable"]          = "Activer le collecteur",
    ["opt_collector_style"]           = "Style du collecteur",
    ["collector_style_bliz"]          = "Blizzard (natif)",
    ["collector_style_tomo"]          = "TomoMod (boîte)",
    ["opt_buttonbag_anchor"]          = "Position du bouton",
    ["buttonbag_anchor_corner"]       = "Sur la minimap (coin)",
    ["buttonbag_anchor_clockl"]       = "Gauche de l'horloge",
    ["buttonbag_anchor_clockr"]       = "Droite de l'horloge",
    ["opt_buttonbag_columns"]         = "Colonnes",
    ["opt_buttonbag_iconsize"]        = "Taille des icônes",
    ["btn_buttonbag_rescan"]          = "Rescanner les boutons",
    -- =====================
    -- CONFIG: Remaining panels [Lot D4]
    -- =====================
    ["btn_bar_uniformize"]            = "Uniformiser toutes les barres sur celle-ci",
    ["info_bar_uniformize"]           = "Copie l'apparence (taille, espacement, colonnes, alpha, échelle, fondu, textes…) vers toutes les autres barres. La position et l'activation de chaque barre sont conservées.",
    ["opt_bar_hotkey_size"]           = "Taille police raccourcis",
    ["popup_ab_uniformize"]           = "Copier l'apparence de la barre « %s » vers toutes les autres barres ?",
    ["info_cb_anchor_uf"]             = "Cette barre d'incantation s'ancre sur son cadre d'unité (elle apparaît donc sur la frame de cible / focus / familier / boss correspondante).",
    ["tab_qol_compass"]               = "Boussole",
    ["section_compass"]               = "Barre de boussole",
    ["info_compass_desc"]             = "Une barre de cap en haut de l'écran affichant N/E/S/O quand vous tournez, avec un marqueur pointant vers votre quête suivie ou un point de carte — la même cible que le faisceau. En lecture seule, elle ne peut donc pas provoquer de taint.",
    ["info_compass_layout"]           = "Astuce : ouvrez le mode Placement (/tm layout) pour glisser la barre exactement où vous voulez.",
    ["opt_compass_enable"]            = "Activer la barre de boussole",
    ["opt_compass_fov"]               = "Champ de vision",
    ["compass_fov_narrow"]            = "Étroit (±45°)",
    ["compass_fov_standard"]          = "Standard (±60°)",
    ["compass_fov_wide"]              = "Large (±90°)",
    ["opt_compass_width"]             = "Largeur de la barre",
    ["opt_compass_height"]            = "Hauteur de la barre",
    ["opt_compass_scale"]             = "Échelle",
    ["opt_compass_show_heading"]      = "Afficher le cap (ex. 245° SO)",
    ["opt_compass_show_distance"]     = "Afficher la distance sur les marqueurs",
    ["opt_compass_show_quest"]        = "Afficher le marqueur de quête suivie",
    ["opt_compass_show_waypoint"]     = "Afficher le marqueur de point de carte",
    ["opt_skyride_ground_speed"]      = "Afficher la vitesse au sol",
    ["info_skyride_ground_speed"]     = "Affiche ta vitesse de déplacement même au sol (les jauges de vol restent masquées hors vol).",
    ["btn_class_reminder_preview"]    = "Aperçu",
    ["sublabel_class_reminder_coverage"]  = "— Buffs et formes suivis —",
    ["opt_char_skin_movable"]         = "Fenêtre déplaçable",
    ["info_char_skin_movable"]        = "Une fois activé, glisse la fenêtre Personnage pour la déplacer. Sa position est mémorisée.",
    ["btn_char_skin_reset_pos"]       = "Réinitialiser la position",
    ["btn_sound_test"]                = "▶ Écouter ce son",
    ["opt_auras_max_width"]           = "Largeur max (retour à la ligne)",
    ["opt_auras_per_row"]             = "Icônes par ligne",

    -- 3.2.0
    ["cfg_tab_cdforge"]           = "Cooldowns",

    -- 3.2.1

    -- 3.2.2
    -- Supports du Cooldown Manager (Movers / mode disposition)
    ["mover_cdm"]                        = "Cooldown Manager",
    ["cdm_drag_hint"]                    = "Glisser pour déplacer",
    ["cdm_preview_aura"]                 = "Aura",




    -- =====================
    -- CHAT FRAME UI (cfui_*) -- were falling back to enUS
    -- =====================
    ["tab_skin_chatframeui"]             = "Interface de discussion",
    ["opt_cfui_enable_desc"]             = "Ajoute des conteneurs décoratifs, une barre de boutons, des icônes latérales et le changement de disposition (Placement). Rechargez l'interface après activation.",
    ["opt_cfui_show_tab_bar"]            = "Afficher la barre d'onglets",
    ["opt_cfui_tab_bar_offset"]          = "Décalage Y de la barre d'onglets",
    ["opt_cfui_window_offset"]           = "Décalage Y de la fenêtre",
    ["opt_cfui_x_offset"]                = "Décalage X",
    ["opt_cfui_y_offset"]                = "Décalage Y",
    ["cfui_show_chat_menu"]              = "Afficher le menu de discussion",
    ["cfui_show_professions"]            = "Afficher les métiers",
    ["cfui_show_shortcuts"]              = "Afficher les raccourcis d'addons",
    ["cfui_copy_chat"]                   = "Copier le texte de discussion",
    ["cfui_click_toggle_status"]         = "Cliquez pour basculer en absent",
    ["cfui_layout_button"]               = "Placement TomoMod",
    ["cfui_left_click"]                  = "Clic gauche :",
    ["cfui_switch_layout"]               = "Changer de disposition",
    ["cfui_no_layouts"]                  = "Aucune disposition enregistrée. Utilisez /tm layout save <nom>",
    ["cfui_no_professions"]              = "Vous n'avez aucun métier.",
    ["cfui_config_menu"]                 = "Configuration",
    ["cfui_profiles"]                    = "Profils",
    ["cfui_clear_chat"]                  = "Effacer la discussion",
    ["cfui_reload_ui"]                   = "Recharger l'interface",
    ["cfui_btn_character"]               = "Personnage",
    ["cfui_btn_bags"]                    = "Sacs",
    ["cfui_btn_friends"]                 = "Amis",
    ["cfui_btn_guild"]                   = "Guilde",
    ["cfui_btn_help"]                    = "Menu d'aide",
    ["cfui_btn_pvp"]                     = "JcJ",
    ["cfui_btn_spellbook"]               = "Grimoire",
    ["cfui_btn_talents"]                 = "Talents",
    ["cfui_btn_achievements"]            = "Hauts faits",
    ["cfui_btn_calendar"]                = "Calendrier",
    ["cfui_btn_lfd"]                     = "Recherche de donjon",
    ["cfui_btn_raid"]                    = "Raid",
    ["cfui_btn_encounter"]               = "Journal des aventures",
    ["cfui_btn_collections"]             = "Collections",
    ["cfui_btn_macros"]                  = "Macros",
    ["cfui_btn_worldmap"]                = "Carte du monde",
    ["cfui_btn_questlog"]                = "Journal de quêtes",
    ["cfui_btn_reputation"]              = "Réputation",
    ["cfui_btn_pvpscore"]                = "Score JcJ",
    ["cfui_btn_currency"]                = "Monnaies",

    -- =====================
    -- 3.3.2 — Quoi de neuf
    -- =====================

    -- =====================
    -- 3.3.3 — Quoi de neuf
    -- =====================
    -- =====================
    -- 4.0.1 — What's New
    -- =====================
    -- =====================
    -- 4.0.0 — What's New
    -- =====================


    -- =====================
    -- 3.6.5 — What's New
    -- =====================

    -- =====================
    -- 3.6.4 — What's New
    -- =====================

    -- =====================
    -- 3.6.3 — What's New
    -- =====================
    -- =====================
    -- 3.6.2 — What's New
    -- =====================
    -- =====================
    -- 3.6.1 — What's New
    -- =====================
    -- =====================
    -- 3.6.0 — What's New
    -- =====================
    -- =====================
    -- 3.5.9 — What's New
    -- =====================

    -- =====================
    -- 3.5.8 — What's New
    -- =====================


    -- =====================
    -- 3.5.7 — Quoi de neuf
    -- =====================

    -- =====================
    -- 3.5.5 — Quoi de neuf
    -- =====================

    -- =====================
    -- 3.5.4 — Quoi de neuf

    -- =====================
    -- 3.5.3 — Quoi de neuf

    -- 3.5.2 — Quoi de neuf
    -- =====================

    -- =====================
    -- 3.5.1 — Quoi de neuf
    -- =====================

    -- =====================
    -- 3.4.6 — Quoi de neuf
    -- =====================


    -- =====================
    -- 3.4.5 — Quoi de neuf
    -- =====================


    -- =====================
    -- 3.4.4 — Quoi de neuf
    -- =====================


    -- =====================
    -- 3.4.3 — Quoi de neuf
    -- =====================

    -- =====================
    -- 3.4.2 — Quoi de neuf
    -- =====================

    -- =====================
    -- 3.4.1 — Quoi de neuf
    -- =====================

    -- =====================
    -- 3.3.6 — Quoi de neuf
    -- =====================

    -- =====================
    -- 3.3.5 — Quoi de neuf
    -- =====================

    -- =====================
    -- 3.3.4 — Quoi de neuf
    -- =====================

    -- =====================
    -- QOL : Companion Status (rappel de familier)
    -- =====================
    ["tab_qol_companion"]             = "Rappel familier",
    ["section_companion"]             = "Statut du familier",
    ["info_companion_desc"]           = "Affiche un rappel quand votre familier est absent ou mort. N'apparaît que pour les spécialisations qui en utilisent un : chasseurs Maîtrise des bêtes et Survie, tous les démonistes, et chevaliers de la mort Impie. Loup solitaire et Grimoire du sacrifice le désactivent d'eux-mêmes.",
    ["info_companion_unavailable"]    = "Le module n'a pas fini de se charger. Rouvrez cet onglet dans un instant.",
    ["opt_companion_enable"]          = "Activer le rappel de familier",
    ["opt_companion_hide_mounted"]    = "Masquer en monture au sol",
    ["info_companion_travel"]         = "Le rappel est toujours masqué en vol, en trajet de vol et en véhicule. Décochez pour continuer à le voir sur une monture au sol.",
    ["opt_companion_display_mode"]    = "Affichage",
    ["companion_mode_icon"]           = "Icône",
    ["companion_mode_text"]           = "Texte",
    ["companion_mode_both"]           = "Les deux",
    ["opt_companion_scale"]           = "Échelle",
    ["opt_companion_size"]            = "Taille de l'icône",
    ["sublabel_companion_pos"]        = "Position",
    ["opt_companion_x"]               = "Décalage horizontal",
    ["opt_companion_y"]               = "Décalage vertical",
    ["btn_companion_reset_pos"]       = "Réinitialiser la position",
    ["info_companion_slash"]          = "Commandes : /cs on, /cs off, /cs mounted, /cs debug.",
    ["companion_pet_missing"]         = "Familier absent",
    ["companion_pet_dead"]            = "Familier mort",

    -- ActionBars: Secure Visibility Engine
    ["Secure Visibility"] = "Visibilité sécurisée",
    ["Visibility Mode"] = "Mode de visibilité",
    ["Always"] = "Toujours",
    ["In Combat"] = "En combat",
    ["Out of Combat"] = "Hors combat",
    ["Solo"] = "Solo",
    ["Party Only"] = "Groupe uniquement",
    ["Raid Only"] = "Raid uniquement",
    ["Any Instance"] = "Toute instance",
    ["Mounted"] = "Sur une monture",
    ["Has Target"] = "Avec une cible",
    ["Hostile Target"] = "Cible hostile",
    ["Hidden"] = "Masqué",
    ["Custom Condition"] = "Condition personnalisée",
    ["Securely show or hide this bar based on game state. These rules keep working in combat without normal Lua Show/Hide calls."] = "Affiche ou masque cette barre de façon sécurisée selon l’état du jeu. Ces règles continuent de fonctionner en combat sans appels Lua classiques à Show/Hide.",

    -- ActionBars: Secure Paging
    ["Secure Paging"] = "Pagination sécurisée",
    ["Securely switch Action Bar 1 by modifier, target, form, skyriding, or manual page. Vehicle and override pages always keep priority."] = "Changez la Barre d’action 1 de façon sécurisée selon un modificateur, la cible, la forme, le vol dynamique ou la page manuelle. Les pages de véhicule et de remplacement restent toujours prioritaires.",
    ["Alt Modifier Page"] = "Page avec Alt",
    ["Shift Modifier Page"] = "Page avec Maj",
    ["Ctrl Modifier Page"] = "Page avec Ctrl",
    ["Friendly Target Page"] = "Page avec cible alliée",
    ["Hostile Target Page"] = "Page avec cible hostile",
    ["Disable Automatic Form Paging"] = "Désactiver la pagination automatique des formes",
    ["Disable Automatic Skyriding Paging"] = "Désactiver la pagination automatique du vol dynamique",
    ["Default (no page switch)"] = "Par défaut (aucun changement)",
    ["Action Bar 1"] = "Barre d’action 1",
    ["Action Bar 2"] = "Barre d’action 2",
    ["Action Bar 3"] = "Barre d’action 3",
    ["Action Bar 4"] = "Barre d’action 4",
    ["Action Bar 5"] = "Barre d’action 5",
    ["Action Bar 6"] = "Barre d’action 6",
    ["Action Bar 7"] = "Barre d’action 7",
    ["Action Bar 8"] = "Barre d’action 8",

    -- =====================
    -- HEALER STUDIO (advanced Party/Raid healer indicators)
    -- =====================
    ["btn_open_healerstudio"]    = "Ouvrir Healer Studio",
    ["info_healerstudio"]        = "Profil avance : choisis tes HoTs, boucliers et buffs de soin, puis place chaque icone librement sur la cellule. Remplace la rangee ci-dessus quand il est actif.",
    ["hs_list"]                  = "AURAS",
    ["hs_mode"]                  = "Profil",
    ["hs_mode_party"]            = "Groupe",
    ["hs_mode_raid"]             = "Raid",
    ["hs_class"]                 = "Classe",
    ["hs_enable"]                = "Activer le profil avance",
    ["hs_healer_only"]           = "Uniquement en specialisation Soigneur",
    ["hs_show_duration"]         = "Afficher les secondes restantes",
    ["hs_show_duration_info"]    = "Désactivé, l'icône garde son balayage de temps et perd seulement le nombre affiché par-dessus. Pratique sur les petites icônes, où les chiffres recouvrent presque toute l'image.",
    ["hs_mode_on"]               = "Profil avance actif : la rangee de HoTs classique est masquee sur ces cellules.",
    ["hs_mode_off"]              = "La rangee de HoTs classique reste utilisee tant que ce profil est desactive.",
    ["hs_preset"]                = "Preset de base",
    ["hs_reset_class"]           = "Reinitialiser cette classe",
    ["hs_reset_position"]        = "Reinitialiser la position",
    ["hs_select"]                = "Selectionne une aura dans la liste pour la placer.",
    ["hs_size"]                  = "Taille de l'icone",
    ["hs_anchor"]                = "Ancrage",
    ["hs_offset_x"]              = "Decalage horizontal",
    ["hs_offset_y"]              = "Decalage vertical",
    ["hs_hint"]                  = "Glisse les icones sur la cellule - les changements sont enregistres immediatement",
    ["hs_combat"]                = "la disposition ne peut pas etre modifiee en combat.",
    ["hs_cat_hot"]               = "HoT",
    ["hs_cat_shield"]            = "Bouclier",
    ["hs_cat_beacon"]            = "Lien / balise",
    ["hs_cat_marker"]            = "Marqueur de soin",
    ["hs_cat_external"]          = "Externe",

    -- Slash command output (Core/Init.lua, CooldownManager, UnitFrames)
    ["cli_after_combat"]       = "après le combat",
    ["cli_reload_required"]    = "/reload requis",
    ["cli_dependents_off"]     = "dépendants coupés :",
    ["cli_deps_off"]           = "dépendances éteintes :",
    ["cli_pending_reload"]     = "%s en attente de /reload",
    ["cli_mod_live"]           = "%d à chaud",
    ["cli_mod_reload"]         = "%d au /reload",
    ["cli_mod_none"]           = "%d sans bascule",
    ["cli_modules_hint"]       = "/tm modules <clé> pour basculer",
    ["cli_backup_created"]     = "sauvegarde créée.",
    ["cli_backup_usage"]       = "/tm backup save | /tm backup restore [numéro]",
    ["cli_layout_usage"]       = "/tm layout export|import <chaîne>",
    ["cli_capture_failed"]     = "capture : échec",
    ["cli_res_counts"]         = "%d polices, %d ancres",
    ["msg_help_install"]       = "Relancer l'assistant de configuration",
    ["msg_help_loot"]          = "Ouvrir le navigateur de loots (donjons & raids)",
    ["msg_cdm_placement_mode"] = "Mode placement",
    ["msg_cdm_live_preview"]   = "Aperçu live",
    ["msg_uf_ouf_missing"]     = "Bibliothèque oUF introuvable (X-oUF: TomoMod_oUF) !",

})
