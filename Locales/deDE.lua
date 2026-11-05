-- =====================================
-- deDE.lua — Deutsch
-- =====================================

-- Perf: Lua builds the whole table constructor below before
-- TomoMod_RegisterLocale can decide to discard it. For a player on any other
-- locale that is ~2900 key/value pairs allocated and turned straight into
-- garbage, five files over, on every /reload. The chunk still compiles (the
-- TOC loads it), but the constructor never runs.
if GetLocale() ~= "deDE" then return end

TomoMod_RegisterLocale("deDE", {

    -- =====================
    -- CONFIG: Categories (ConfigUI.lua)
    -- =====================
    ["cat_general"]         = "Allgemein",
    ["cat_unitframes"]      = "UnitFrames",
    ["cat_nameplates"]      = "Nameplates",
    ["cat_cd_resource"]     = "CD & Ressourcen",
    ["cat_qol"]             = "Lebensqualität",
    ["cat_mythicplus"]      = "Mythic+",
    ["cat_profiles"]        = "Profile",
    ["cat_diagnostics"]     = "Diagnose",
    ["cat_housing"]         = "Housing",

    -- =====================
    -- CONFIG: General Panel
    -- =====================
    ["section_about"]                   = "Über",
    ["about_text"]                      = "|cffffd100TomoModForever|r %s von TomoAniki\nLeichtgewichtige Oberfläche mit QOL, UnitFrames und Nameplates.\nTippe /tm help für die Befehlsliste.",
    ["section_general"]                 = "Allgemein",
    ["btn_reset_all"]                   = "Alles zurücksetzen",
    ["info_reset_all"]                  = "Dies setzt ALLE Einstellungen zurück und lädt die Oberfläche neu.",

    -- Minimap
    ["section_minimap"]                 = "Minimap",
    ["opt_minimap_enable"]              = "Eigene Minimap aktivieren",
    ["opt_size"]                        = "Größe",
    ["opt_scale"]                       = "Skalierung",
    ["opt_border"]                      = "Rahmen",
    ["border_class"]                    = "Klassenfarbe",
    ["border_black"]                    = "Schwarz",

    -- Info Panel
    ["section_info_panel"]              = "Infopanel",
    ["opt_enable"]                      = "Aktivieren",
    ["opt_durability"]                  = "Haltbarkeit (Ausrüstung)",
    ["info_durability_position"]        = "Position des Haltbarkeitstextes — nützlich, wenn ein Button (z. B. Erweiterung) die Standardecke überlappt.",
    ["opt_durability_corner"]           = "Ecke (Haltbarkeit)",
    ["opt_time"]                        = "Uhrzeit",
    ["opt_24h_format"]                  = "24h-Format",
    ["opt_show_coords"]                 = "Koordinaten anzeigen",
    ["btn_reset_position"]              = "Position zurücksetzen",

    -- Cursor Ring
    ["section_cursor_ring"]             = "Cursorring",
    ["opt_class_color"]                 = "Klassenfarbe",
    ["opt_anchor_tooltip_ring"]         = "Tooltip am Cursor verankern",

    -- =====================
    -- CONFIG: UnitFrames Panel
    -- =====================
    -- Tabs
    ["tab_general"]                     = "Allgemein",
    ["tab_player"]                      = "Spieler",
    ["tab_target"]                      = "Ziel",
    ["tab_tot"]                         = "ZdZ",
    ["tab_pet"]                         = "Begleiter",
    ["tab_focus"]                       = "Fokus",
    ["tab_colors"]                      = "Farben",

    -- Sub-tabs (Player, Target, Focus)
    ["subtab_dimensions"]               = "Abmessungen",
    ["subtab_display"]                  = "Anzeige",
    ["subtab_auras"]                    = "Auren",
    ["subtab_positioning"]              = "Position",

    -- Sub-labels
    ["sublabel_dimensions"]             = "— Abmessungen —",
    ["sublabel_display"]                = "— Anzeige —",
    ["sublabel_castbar"]                = "— Zauberleiste —",
    ["sublabel_auras"]                  = "— Auren —",
    ["sublabel_element_offsets"]        = "— Elementpositionen —",

    -- Unit display names
    ["unit_player"]                     = "Spieler",
    ["unit_target"]                     = "Ziel",
    ["unit_tot"]                        = "Ziel des Ziels",
    ["unit_pet"]                        = "Begleiter",
    ["unit_focus"]                      = "Fokus",

    -- General tab
    ["section_general_settings"]        = "Allgemeine Einstellungen",
    ["opt_uf_enable"]                   = "TomoMod UnitFrames aktivieren",
    ["opt_hide_blizzard"]               = "Blizzard-Frames ausblenden",
    ["opt_global_font_size"]            = "Globale Schriftgröße",
    ["sublabel_font"]                   = "— Schriftart —",
    ["opt_font_family"]                 = "Schriftfamilie",

    -- Castbar colors
    ["section_castbar_colors"]          = "Zauberleisten-Farben",
    ["info_castbar_colors"]             = "Passe die Farben der Zauberleiste für unterbrechbare, nicht unterbrechbare und unterbrochene Zauber an.",
    ["opt_castbar_color"]               = "Unterbrechbarer Zauber",
    ["opt_castbar_ni_color"]            = "Nicht unterbrechbarer Zauber",
    ["opt_castbar_interrupt_color"]     = "Unterbrochener Zauber",
    ["info_castbar_colors_reload"]      = "Farbänderungen gelten für neue Zauber. /reload für vollständige Wirkung.",
    ["btn_toggle_lock"]                 = "Sperren/Entsperren (/tm uf)",
    ["info_unlock_drag"]                = "Entsperren zum Verschieben. Positionen werden automatisch gespeichert.",

    -- Per-unit options
    ["opt_width"]                       = "Breite",
    ["opt_health_height"]               = "Lebenshöhe",
    ["opt_power_height"]                = "Ressourcenhöhe",
    ["opt_show_name"]                   = "Name anzeigen",
    ["opt_name_truncate"]               = "Lange Namen kürzen",
    ["opt_name_truncate_length"]        = "Max. Namenslänge",
    ["opt_show_level"]                  = "Stufe anzeigen",
    ["opt_show_health_text"]            = "Lebenstext anzeigen",
    ["opt_health_format"]               = "Lebensformat",
    ["fmt_current"]                     = "Aktuell (25.3K)",
    ["fmt_percent"]                     = "Prozent (75%)",
    ["fmt_current_percent"]             = "Aktuell + % (25.3K | 75%)",
    ["fmt_current_max"]                 = "Aktuell / Max",
    ["opt_class_color_uf"]              = "Klassenfarbe",
    ["opt_faction_color"]               = "Fraktionsfarbe (NSC)",
    ["opt_use_nameplate_colors"]        = "Nameplate-Farben (NSC-Typ)",
    ["opt_show_absorb"]                 = "Absorptionsleiste",
    ["opt_show_threat"]                 = "Bedrohungsanzeige (Randleuchten)",
    ["section_threat_text"]             = "Bedrohung % Text",
    ["opt_threat_text_enable"]          = "Bedrohung % auf dem Ziel anzeigen",
    ["opt_threat_text_font_size"]       = "Schriftgröße",
    ["info_threat_text"]                = "Grün = Tank (Vorsprung), gelb = Warnung, rot = Aggro verloren",
    ["opt_show_leader_icon"]            = "Anführersymbol",
    ["opt_leader_icon_x"]               = "Anführersymbol X",
    ["opt_leader_icon_y"]               = "Anführersymbol Y",
    ["opt_raid_icon_x"]                 = "Raidmarkierung X",
    ["opt_raid_icon_y"]                 = "Raidmarkierung Y",

    -- Castbar
    ["opt_castbar_enable"]              = "Zauberleiste aktivieren",
    ["opt_castbar_width"]               = "Zauberleistenbreite",
    ["opt_castbar_height"]              = "Zauberleistenhöhe",
    ["opt_castbar_show_icon"]           = "Symbol anzeigen",
    ["opt_castbar_show_timer"]          = "Timer anzeigen",
    ["info_castbar_drag"]               = "Position: /tm sr zum Entsperren und Verschieben der Zauberleiste.",
    ["btn_reset_castbar_position"]      = "Position der Zauberleiste zurücksetzen",
    ["opt_castbar_show_latency"]        = "Latenz anzeigen",

    -- Auras
    ["opt_auras_enable"]                = "Auren aktivieren",
    ["opt_auras_max"]                   = "Max. Auren",
    ["opt_auras_size"]                  = "Symbolgröße",
    ["opt_auras_type"]                  = "Aurentyp",
    ["aura_harmful"]                    = "Debuffs (schädlich)",
    ["aura_helpful"]                    = "Buffs (nützlich)",
    ["aura_all"]                        = "Buffs und Debuffs",
    ["opt_auras_direction"]             = "Wachstumsrichtung",
    ["opt_auras_direction_v"]           = "Vertikale Richtung",
    ["aura_dir_down"]                   = "Nach unten",
    ["aura_dir_up"]                     = "Nach oben",
    ["aura_dir_right"]                  = "Nach rechts",
    ["aura_dir_left"]                   = "Nach links",
    ["opt_auras_only_mine"]             = "Nur eigene Auren",

    -- Element offsets
    ["elem_name"]                       = "Name",
    ["elem_level"]                      = "Stufe",
    ["elem_health_text"]                = "Lebenstext",
    ["elem_power"]                      = "Ressourcenleiste",
    ["elem_castbar"]                    = "Zauberleiste",
    ["elem_auras"]                      = "Auren",
    ["elem_enemy_buffs"]                = "Ziel-Stärkungszauber",

    -- AstralForge: element registry
    ["elem_raid_icon"]                  = "Schlachtzugsmarkierung",
    ["elem_leader_icon"]                = "Anführersymbol",
    ["elem_threat_text"]                = "Bedrohungstext",
    ["opt_element_anchor"]              = "Verankerung",
    ["btn_reset_elements"]              = "Elementpositionen zurücksetzen",
    ["anchor_host_frame"]               = "Rahmen",
    ["anchor_host_health"]              = "Lebensleiste",
    ["anchor_host_power"]               = "Ressourcenleiste",
    ["anchor_host_infobar"]             = "Infoleiste",
    ["btn_open_astralforge"]            = "AstralForge öffnen",
    ["info_astralforge"]                = "AstralForge ist der vollständige Designer: Ziehe jedes Element direkt auf den Rahmen und wähle Ankerpunkt und Bezugsobjekt. Die Regler unten bleiben für pixelgenaue Feinabstimmung verfügbar.",
    ["target_kind_host"]                = "Struktur: ",
    ["target_kind_element"]             = "Element: ",

    -- AstralForge : proprietes par element
    ["sublabel_element_props"]          = "Visuelle Eigenschaften",
    ["opt_element_alpha"]               = "Deckkraft (%)",
    ["opt_element_scale"]               = "Skalierung (%)",
    ["opt_element_font_size"]           = "Schriftgröße überschreiben",
    ["info_element_font_size"]          = "Auf 0 lassen, um die vom Modul berechnete Größe zu behalten.",

    -- AstralForge : elements instancies
    ["elem_custom_text"]                = "Eigener Text",
    ["opt_custom_text_template"]        = "Textvorlage",
    ["info_custom_text_tokens"]         = "Verfügbare Platzhalter:",
    ["btn_add_custom_text"]             = "Eigenen Text hinzufügen",
    ["btn_reset_element"]               = "Dieses Element zurücksetzen",
    ["btn_delete_element"]              = "Dieses Element löschen",
    ["msg_element_max_reached"]         = "Maximale Anzahl an Elementen dieses Typs erreicht.",

    -- AstralForge : presets de disposition
    ["section_forge_presets"]           = "Layout-Vorlagen",
    ["btn_forge_presets"]               = "Layout-Vorlagen",
    ["info_forge_presets"]              = "Eine Vorlage speichert das komplette Layout des aktuellen Objekts: Verankerungen, visuelle Eigenschaften und eigene Elemente.",
    ["opt_preset_name"]                 = "Name der Vorlage",
    ["btn_preset_save"]                 = "Speichern / überschreiben",
    ["opt_preset_saved"]                = "Gespeicherte Vorlagen",
    ["btn_preset_apply"]                = "Anwenden",
    ["btn_preset_delete"]               = "Löschen",
    ["btn_preset_export"]               = "Teilen-Code erzeugen",
    ["opt_preset_share_string"]         = "Teilen-Code",
    ["info_preset_copy"]                = "Ins Feld klicken, dann Strg+A und Strg+C zum Kopieren.",
    ["opt_preset_import"]               = "Teilen-Code einfügen",
    ["btn_preset_import"]               = "Importieren",
    ["info_no_preset"]                  = "Noch keine Vorlage für dieses Objekt gespeichert.",
    ["msg_preset_saved"]                = "Vorlage gespeichert.",
    ["msg_preset_applied"]              = "Vorlage angewendet.",
    ["msg_preset_imported"]             = "Vorlage importiert:",
    ["msg_preset_error"]                = "Vorgang für die Vorlage fehlgeschlagen.",
    ["msg_presets_unavailable"]         = "Layout-Vorlagen sind nicht verfügbar.",
    ["token_classification"]            = "Einstufung",
    ["token_name"]                      = "Name",
    ["token_level"]                     = "Stufe",
    ["token_class"]                     = "Klasse",
    ["token_race"]                      = "Volk",
    ["token_guild"]                     = "Gilde",

    -- AstralForge : domaine plaques de nom
    ["section_np_elements"]             = "Elementpositionen",
    ["info_np_elements"]                = "Öffne AstralForge, um jedes Element auf die Namensplakette zu ziehen und seine Verankerung zu wählen. Die Regler unten dienen der pixelgenauen Feinabstimmung.",
    ["np_host_plate"]                   = "Plakette",
    ["np_host_health"]                  = "Lebensleiste",
    ["np_host_castbar"]                 = "Zauberleiste",
    ["np_host_name"]                    = "Name",
    ["np_elem_name"]                    = "Name",
    ["np_elem_hp_number"]               = "Lebenswert",
    ["np_elem_hp_percent"]              = "Lebensprozent",
    ["np_elem_level"]                   = "Stufe",
    ["np_elem_class_icon"]              = "Einstufungssymbol",
    ["np_elem_class_text"]              = "Einstufungstext",
    ["np_elem_castbar"]                 = "Zauberleiste",
    ["np_elem_cast_icon"]               = "Zaubersymbol",
    ["np_elem_cast_text"]               = "Zaubername",
    ["np_elem_cast_timer"]              = "Zauberzeit",
    ["np_elem_cast_shield"]             = "Zauberschild",
    ["np_elem_quest_icon"]              = "Questsymbol",
    ["np_elem_raid_marker"]             = "Schlachtzugsmarkierung",

    -- =====================
    -- CONFIG: Nameplates Panel
    -- =====================
    -- Nameplate tabs
    ["tab_np_auras"]                    = "Auren",
    ["tab_np_advanced"]                 = "Erweitert",
    ["info_np_colors_custom"]           = "Jede Farbe kann durch Klick auf das Farbfeld individuell angepasst werden.",

    ["section_np_general"]              = "Allgemeine Einstellungen",
    ["opt_np_enable"]                   = "TomoMod Nameplates aktivieren",
    ["info_np_description"]             = "Ersetzt Blizzard-Nameplates durch einen anpassbaren minimalistischen Stil.",
    ["section_dimensions"]              = "Abmessungen",
    ["opt_np_name_font_size"]           = "Namensschriftgröße",

    -- Display
    ["section_display"]                 = "Anzeige",
    ["opt_np_show_classification"]      = "Klassifizierung anzeigen (Elite, Selten, Boss)",
    ["opt_np_show_absorb"]               = "Absorptionsleiste anzeigen",
    ["opt_np_class_colors"]             = "Klassenfarben (Spieler)",
    ["opt_np_friendly_name_only"]       = "Verbündete: nur Name (ohne Lebensbalken)",
    ["opt_np_friendly_role_icons"]      = "Rollensymbole anzeigen (Dungeon/Delve)",
    ["opt_np_role_show_tank"]           = "Tank-Symbol anzeigen",
    ["opt_np_role_show_healer"]         = "Heiler-Symbol anzeigen",
    ["opt_np_role_show_dps"]            = "DPS-Symbol anzeigen",
    ["opt_np_role_icon_size"]           = "Rollensymbol-Größe",

    -- Raid Marker
    ["section_raid_marker"]             = "Raid-Markierung",
    ["opt_np_raid_icon_x"]              = "Versatz X",
    ["opt_np_raid_icon_y"]              = "Versatz Y",
    ["opt_np_raid_icon_size"]           = "Symbolgröße",

    -- Castbar
    ["section_castbar"]                 = "Zauberleiste",
    ["opt_np_show_castbar"]             = "Zauberleiste anzeigen",
    ["opt_np_castbar_height"]           = "Zauberleistenhöhe",
    ["color_castbar"]                   = "Zauberleiste (unterbrechbar)",
    ["color_castbar_uninterruptible"]   = "Zauberleiste (nicht unterbrechbar)",

    -- Auras
    ["section_auras"]                   = "Auren",
    ["opt_np_show_auras"]               = "Auren anzeigen",
    ["opt_np_aura_size"]                = "Symbolgröße",
    ["opt_np_max_auras"]                = "Max. Anzahl",
    ["opt_np_only_my_debuffs"]          = "Nur eigene Debuffs",

    -- Enemy Buffs
    ["section_enemy_buffs"]              = "Feindliche Buffs",
    ["sublabel_enemy_buffs"]             = "— Feindliche Buffs —",
    ["opt_enemy_buffs_enable"]           = "Feindliche Buffs anzeigen",
    ["opt_enemy_buffs_max"]              = "Max. Buffs",
    ["opt_enemy_buffs_size"]             = "Buff-Symbolgröße",
    ["opt_enemy_buffs_direction"]        = "Richtung",
    ["opt_enemy_buffs_per_row"]          = "Symbole pro Zeile",
    ["opt_enemy_buffs_row_orientation"]  = "Nächste Zeile",
    ["info_enemy_buffs"]                 = "Zeigt aktive Buffs (Wutanfall, Schilde...) auf feindlichen Einheiten. Symbole erscheinen oben rechts, stapeln sich nach oben.",
    ["opt_np_show_enemy_buffs"]          = "Feindliche Buffs anzeigen",
    ["opt_np_enemy_buff_size"]           = "Buff-Symbolgröße",
    ["opt_np_max_enemy_buffs"]           = "Max. feindliche Buffs",
    ["opt_np_enemy_buff_y_offset"]       = "Feindliche Buffs Y-Versatz",

    -- Transparency
    ["section_transparency"]            = "Transparenz",
    ["opt_np_selected_alpha"]           = "Alpha (ausgewählt)",
    ["opt_np_unselected_alpha"]         = "Alpha (nicht ausgewählt)",

    -- Stacking
    ["section_stacking"]                = "Stapeln",
    ["opt_np_overlap"]                  = "Vertikale Überlappung",
    ["opt_np_top_inset"]                = "Obere Bildschirmgrenze",

    -- Colors
    ["section_colors"]                  = "Farben",
    ["color_hostile"]                   = "Feindlich (Gegner)",
    ["color_neutral"]                   = "Neutral",
    ["color_friendly"]                  = "Freundlich",
    ["color_tapped"]                    = "Markiert (tapped)",
    ["color_focus"]                     = "Fokusziel",

    -- NPC Type Colors
    ["section_npc_type_colors"]         = "NSC-Typfarben",
    ["color_caster"]                    = "Zauberwirker",
    ["color_miniboss"]                  = "Mini-Boss (Elite + höhere Stufe)",
    ["color_enemy_in_combat"]           = "Feind (Standard)",
    ["info_np_darken_ooc"]              = "Feinde außerhalb des Kampfes werden automatisch abgedunkelt.",

    -- Classification colors
    ["section_classification_colors"]   = "Klassifizierungsfarben",
    ["opt_np_use_classification"]       = "Farben nach Gegnertyp",
    ["color_boss"]                      = "Boss",
    ["color_elite"]                     = "Elite / Mini-Boss",
    ["color_rare"]                      = "Selten",
    ["color_normal"]                    = "Normal",
    ["color_trivial"]                   = "Trivial",

    -- Tank mode
    ["section_tank_mode"]               = "Tank-Modus",
    ["opt_np_tank_mode"]                = "Tank-Modus aktivieren (Bedrohungsfarben)",
    ["color_no_threat"]                 = "Keine Bedrohung",
    ["color_low_threat"]                = "Niedrige Bedrohung",
    ["color_has_threat"]                = "Bedrohung gehalten",
    ["color_dps_has_aggro"]             = "DPS/Heiler hat Aggro",
    ["color_dps_near_aggro"]            = "DPS/Heiler nahe Aggro",

    -- NP health format
    ["np_fmt_percent"]                  = "Prozent (75%)",
    ["np_fmt_current"]                  = "Aktuell (25.3K)",
    ["np_fmt_current_percent"]          = "Aktuell + %",

    -- Reset
    ["btn_reset_nameplates"]            = "Nameplates zurücksetzen",

    -- =====================
    -- CONFIG: CD & Resource Panel
    -- =====================
    -- Resource colors
    ["section_resource_colors"]         = "Ressourcenfarben",
    ["res_runes_ready"]                 = "Runen (bereit)",
    ["res_runes_cd"]                    = "Runen (Abklingzeit)",

    -- Cooldown Manager
    ["tab_cdm"]                         = "Abklingzeiten",
    ["tab_cdm_bars"]                    = "Leisten",
    ["tab_resource_bars"]               = "Ressourcenleisten",
    ["tab_text_position"]               = "Text & Position",
    ["tab_rb_colors"]                   = "Farben",
    ["info_rb_colors_custom"]           = "Jede Farbe kann durch Klick auf das Farbfeld individuell angepasst werden.",

    ["section_cdm"]                     = "Abklingzeitenmanager",
    ["opt_cdm_enable"]                  = "Abklingzeitenmanager aktivieren",
    ["info_cdm_description"]            = "Reskin der Blizzard-CooldownManager-Symbole: abgerundete Ränder, Klassen-Overlay bei aktiven Auren, benutzerdefinierte Sweep-Farben, Utility-Dimmen, zentriertes Layout. Platzierung über Blizzard Edit Mode.",
    ["opt_cdm_show_hotkeys"]            = "Hotkeys anzeigen",
    ["opt_cdm_combat_alpha"]            = "Deckkraft ändern (Kampf / Ziel)",
    ["opt_cdm_alpha_combat"]            = "Alpha im Kampf",
    ["opt_cdm_alpha_target"]            = "Alpha mit Ziel (außerhalb Kampf)",
    ["opt_cdm_alpha_ooc"]               = "Alpha außerhalb Kampf",
    ["section_cdm_overlay"]             = "Overlay und Ränder",
    ["opt_cdm_custom_overlay"]          = "Benutzerdefinierte Overlay-Farbe",
    ["opt_cdm_overlay_color"]           = "Overlay-Farbe",
    ["opt_cdm_custom_swipe"]            = "Benutzerdefinierte aktive Sweep-Farbe",
    ["opt_cdm_swipe_color"]             = "Sweep-Farbe",
    ["opt_cdm_swipe_alpha"]             = "Sweep-Deckkraft",
    ["section_cdm_utility"]             = "Utility",
    ["opt_cdm_dim_utility"]             = "Utility-Symbole dimmen, wenn nicht auf CD",
    ["opt_cdm_dim_opacity"]             = "Dimm-Deckkraft",
    ["opt_cdm_bufficon_direction"]        = "Richtung der Buff-Symbole",
    ["opt_cdm_buffbar_direction"]         = "BuffBar-Richtung",
    ["opt_cdm_buffbar_width"]             = "Balkenbreite (horizontal)",
    ["buffbar_vertical"]                  = "Vertikal",
    ["buffbar_horizontal"]                = "Horizontal",
    ["dir_centered"]                      = "Zentriert (horizontal)",
    ["dir_left"]                          = "Links",
    ["dir_right"]                         = "Rechts",
    ["dir_up"]                            = "Nach oben",
    ["dir_down"]                          = "Nach unten",
    ["info_cdm_editmode"]               = "Die Platzierung erfolgt über den Blizzard Edit Mode (Esc |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Edit Mode).",

    -- CDM V3.2: Platzierung & Viewer-Karten (Phase 4)
    ["section_cdm_placement"]            = "Platzierung & Live-Vorschau",
    ["info_cdm_placement"]               = "CDM-Leisten werden jetzt von TomoMod positioniert (der Blizzard Edit Mode wird nicht mehr benötigt). Der Platzierungsmodus zeigt Platzhaltersymbole und erlaubt es, jede Leiste zu verschieben.",
    ["btn_cdm_unlock"]                   = "Platzierungsmodus (live)",
    ["opt_cdm_preview"]                  = "Vorschau (Platzhaltersymbole)",
    ["info_cdm_preview_live"]            = "Einstellungen pro Leiste im Tab „Leisten“ — alles wird live angewendet.",
    ["info_cdm_bars"]                    = "Jede Leiste hat ihre eigene Position und ihr eigenes Layout. Aktiviere die Vorschau, um Änderungen live zu sehen, oder den Platzierungsmodus, um Leisten mit der Maus zu verschieben.",
    ["btn_cdm_reset_pos"]                = "Positionen zurücksetzen",
    ["msg_cdm_pos_reset"]                = "CDM-Positionen zurückgesetzt.",
    ["section_cdm_essential"]            = "Essential (Hauptzauber)",
    ["section_cdm_utility_bar"]          = "Utility (Hilfszauber)",
    ["section_cdm_bufficons"]            = "Buff-Symbole (Auren — Symbole)",
    ["section_cdm_buffbars"]             = "Buff-Leisten (Auren — Leisten)",
    ["opt_cdm_pos_x"]                    = "Position X",
    ["opt_cdm_pos_y"]                    = "Position Y",
    ["opt_cdm_icon_size"]                = "Symbolgröße (0 = automatisch)",
    ["opt_cdm_spacing"]                  = "Abstand",
    ["opt_cdm_row_limit"]                = "Pro Zeile (0 = unbegrenzt)",
    ["opt_cdm_direction"]                = "Richtung",
    ["opt_cdm_secondary_direction"]      = "Sekundäre Richtung",
    ["opt_cdm_buffbar_spacing"]          = "Abstand",
    ["secdir_auto"]                      = "Automatisch",
    ["secdir_down"]                      = "Zeilen nach unten",
    ["secdir_up"]                        = "Zeilen nach oben",
    ["secdir_right"]                     = "Spalten nach rechts",
    ["secdir_left"]                      = "Spalten nach links",

    -- Resource Bars
    ["section_resource_bars"]           = "Ressourcenleisten",
    ["opt_rb_enable"]                   = "Ressourcenleisten aktivieren",
    ["info_rb_description"]             = "Zeigt Klassenressourcen (Mana, Wut, Energie, Kombopunkte, Runen usw.) mit adaptiver Druiden-Unterstützung.",
    ["section_visibility"]              = "Sichtbarkeit",
    ["opt_rb_visibility_mode"]          = "Sichtbarkeitsmodus",
    ["vis_always"]                      = "Immer sichtbar",
    ["vis_combat"]                      = "Nur im Kampf",
    ["vis_target"]                      = "Kampf oder Ziel",
    ["vis_hidden"]                      = "Versteckt",
    ["opt_rb_combat_alpha"]             = "Alpha im Kampf",
    ["opt_rb_ooc_alpha"]                = "Alpha außerhalb Kampf",
    ["opt_rb_width"]                    = "Breite",
    ["opt_rb_classpower_height"]        = "Klassenkrafthöhe",
    ["opt_rb_druidmana_height"]         = "Druiden-Manahöhe",
    ["opt_rb_global_scale"]             = "Globale Skalierung",

    -- v2.9: Lebensbalken (HUD)
    ["section_rb_healthbar"]            = "Lebensbalken (HUD)",
    ["opt_rb_hb_enable"]                = "Lebensbalken anzeigen",
    ["info_rb_healthbar"]               = "Lebensbalken zentriert über den Ressourcen. Text und Schwellenfarbe werden clientseitig verwaltet (Midnight-kompatibel).",
    ["opt_rb_hb_height"]                = "Höhe",
    ["opt_rb_hb_text"]                  = "Text",
    ["hb_text_none"]                    = "Kein",
    ["hb_text_value"]                   = "Wert",
    ["hb_text_percent"]                 = "Prozent",
    ["hb_text_both"]                    = "Wert | %",
    ["opt_rb_hb_classcolor"]            = "Klassenfarbe",
    ["opt_rb_hb_color"]                 = "Benutzerdefinierte Farbe (wenn Klassenfarbe deaktiviert)",
    ["opt_rb_hb_threshold"]             = "Schwelle niedrige Lebenspunkte (ändert Farbe)",
    ["opt_rb_hb_threshold_pct"]         = "Schwelle (%)",
    ["opt_rb_hb_threshold_color"]       = "Farbe niedrige Lebenspunkte",

    -- v2.9: Animationen & Kraftbalken
    ["section_rb_anim"]                 = "Animationen & Kraftbalken",
    ["opt_rb_smooth"]                   = "Flüssige Balkenanimationen",
    ["opt_rb_full_glow"]                = "Leuchten bei maximaler Klassenressource",
    ["opt_rb_supercharged_points"]      = "Aufgeladene Kombopunkte anzeigen",
    ["opt_rb_power_ticks"]              = "Markierungen auf dem Kraftbalken (% des Max)",
    ["ticks_none"]                      = "Kein",
    ["opt_rb_power_threshold"]          = "Schwelle niedrige Ressource (Kraftbalken)",
    ["opt_rb_power_threshold_pct"]      = "Schwelle (%)",
    ["opt_rb_power_threshold_color"]    = "Farbe niedrige Ressource",
    ["info_rb_anim"]                    = "Markierungen und Schwelle gelten für den zentrierten Kraftbalken. Die Glättung gilt auch für den Lebensbalken, das Druiden-Mana und die Auren-Balken.",

    ["opt_rb_sync_width"]               = "Breite mit Essential Cooldowns synchronisieren",
    ["btn_sync_now"]                    = "Jetzt synchronisieren",
    ["info_rb_sync"]                    = "Gleicht die Breite mit dem EssentialCooldownViewer des Blizzard-CooldownManagers ab.",

    -- Text & Font
    ["section_text_font"]               = "Text & Schrift",
    ["opt_rb_show_text"]                = "Text auf Leisten anzeigen",
    ["opt_rb_text_align"]               = "Textausrichtung",
    ["align_left"]                      = "Links",
    ["align_center"]                    = "Mitte",
    ["align_right"]                     = "Rechts",
    ["opt_rb_font_size"]                = "Schriftgröße",
    ["opt_rb_font"]                     = "Schriftart",
    ["font_default_wow"]                = "WoW-Standard",

    -- Position
    ["section_position"]                = "Position",
    ["info_rb_position"]                = "Verwende /tm uf zum Entsperren und Verschieben. Position wird automatisch gespeichert.",
    ["info_rb_druid"]                   = "Leisten passen sich automatisch an Klasse und Spezialisierung an.\nDruide: Ressource ändert sich mit Form (Bär |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Wut, Katze |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Energie, Eule |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Astrale Macht).",

    -- =====================
    -- CONFIG: QOL Panel
    -- =====================
    ["tab_qol_cinematic"]               = "Zwischensequenz",
    ["tab_qol_auto_quest"]              = "Auto-Quest",
    ["tab_qol_automations"]             = "Automatisierungen",
    ["tab_qol_mythic_keys"]             = "M+-Schlüssel",
    ["tab_qol_skyride"]                 = "SkyRide",
    ["tab_qol_action_bars"]             = "Aktionsleisten",
    ["section_action_bars"]             = "Aktionsleisten-Skin",
    ["section_ab_system"]               = "Action Bar System",
    ["opt_ab_system_enable"]            = "Enable TomoMod Action Bar system (requires reload)",
    ["opt_ab_system_reload"]            = "Disabling this fully restores Blizzard action bars after /reload.",
    ["section_ab_skin"]                 = "Visual Skin",

    -- ActionBars: LibKeyBound integration (Lot A9)
    ["btn_ab_kb_lib"]                       = "Belegungsmodus (LibKeyBound)",
    ["info_ab_kb_lib"]                      = "Gemeinsamer Belegungsmodus, von einem anderen Addon bereitgestellt. Belegt TomoMods Leisten und die des anderen Addons im selben Durchgang.",

    -- ActionBars: keybinding command labels (Lot A8)
    ["binding_category"]                    = "TomoMod-Aktionsleisten",
    ["binding_bar_header"]                  = "TomoMod-Leiste %d",
    ["binding_button"]                      = "Leiste %d Schaltfläche %d",

    ["options_load_failed"]             = "Optionsfenster nicht verfügbar — ist das Addon TomoModForever_Options aktiviert?",

    ["anchor_queue"]                    = "Warteschlangen-Auge",

    ["microbar_native_not_found"]       = "Blizzards Mikromenü zum Ausblenden nicht gefunden — bitte mit Client-Version melden.",

    ["microbar_tt_perf"]                    = "Leistung",
    ["microbar_tt_fps"]                     = "Bildrate",
    ["microbar_tt_latency"]                 = "Latenz",
    ["microbar_tt_cpu"]                     = "Addon-CPU",
    ["microbar_tt_cpu_off"]                 = "Profiling deaktiviert",

    -- ActionBars: rebuilt panel on the Tui schema (lot P5)
    ["section_ab_totem"]                 = "Totems",
    ["opt_ab_totem_enabled"]             = "Totemleiste",
    ["info_ab_totem"]                    = "Eine Leiste mit euren aktiven Totems und deren Restdauer. Im Layoutmodus positionieren.",
    ["mover_totembar"]                  = "Totemleiste",
    ["opt_ab_flash"]                    = "Druckeffekt",
    ["info_ab_flash"]                   = "Was angezeigt wird, während eine Schaltfläche gedrückt gehalten wird. TomoMods Textur dunkelt das Symbol ab; Blizzards ist der übliche Blitz.",
    ["info_ab_masque"]                      = "Nur wirksam, wenn Masque installiert ist. Der eigene Stil wird dann deaktiviert, damit sich beide nicht in die Quere kommen.",
    ["info_ab_nodb"]                        = "Einstellungen der Aktionsleisten nicht verfügbar: Die Datenbank wurde nicht initialisiert. Interface neu laden.",
    ["opt_ab_assisted"]                     = "Assistierte Hervorhebung",
    ["opt_ab_backdrop"]                     = "Hintergrund",
    ["opt_ab_backdrop_alpha"]               = "Deckkraft des Hintergrunds",
    ["opt_ab_borders"]                      = "Ränder",
    ["opt_ab_gloss"]                        = "Glanz",
    ["opt_ab_gloss_alpha"]                  = "Deckkraft des Glanzes",
    ["opt_ab_glow_color"]                   = "Leuchtfarbe",
    ["opt_ab_glow_source"]                  = "Leuchtquelle",
    ["opt_ab_hide_empty"]                   = "Leere Felder ausblenden",
    ["opt_ab_hide_empty_keybinds"]          = "Taste bei leeren Feldern ausblenden",
    ["opt_ab_icon_size"]                    = "Schaltflächengröße",
    ["opt_ab_icon_skin"]                    = "Symbol-Stil",
    ["opt_ab_keydown"]                      = "Beim Tastendruck wirken",
    ["opt_ab_lock"]                         = "Schaltflächen sperren",
    ["opt_ab_mana_color"]                   = "Farbe bei fehlender Ressource",
    ["opt_ab_masque"]                       = "Masque die Schaltflächen gestalten lassen",
    ["opt_ab_range"]                        = "Anzeige außer Reichweite",
    ["opt_ab_range_color"]                  = "Farbe außer Reichweite",
    ["opt_ab_skin_enabled"]                 = "Schaltflächen gestalten",
    ["opt_ab_spacing"]                      = "Abstand",
    ["opt_ab_tooltips"]                     = "Tooltips anzeigen",
    ["opt_ab_usability"]                    = "Anzeige nicht benutzbar",
    ["opt_ab_usability_color"]              = "Farbe nicht benutzbar",
    ["opt_abf_combat"]                      = "Im Kampf immer sichtbar",
    ["opt_abf_delay"]                       = "Verzögerung vor dem Ausblenden",
    ["opt_abf_enabled"]                     = "Leisten ausblenden",
    ["opt_abf_in"]                          = "Dauer des Einblendens",
    ["opt_abf_link"]                        = "Leisten 1 bis 8 verknüpfen",
    ["opt_abf_out"]                         = "Dauer des Ausblendens",
    ["opt_abf_out_alpha"]                   = "Deckkraft im ausgeblendeten Zustand",
    ["opt_abt_anchor"]                      = "Position",
    ["opt_abt_color"]                       = "Farbe",
    ["opt_abt_cooldowntext"]                = "Abklingzeit-Zahlen",
    ["opt_abt_counts"]                      = "Aufladungen und Stapel",
    ["opt_abt_keybinds"]                    = "Tastenbelegung",
    ["opt_abt_macronames"]                  = "Makronamen",
    ["opt_abt_offx"]                        = "Horizontaler Versatz",
    ["opt_abt_offy"]                        = "Vertikaler Versatz",
    ["opt_abt_show"]                        = "Anzeigen",
    ["opt_abt_size"]                        = "Schriftgröße",
    ["opt_bar_buttons"]                     = "Anzahl der Schaltflächen",
    ["opt_bar_grow_left"]                   = "Nach links wachsen",
    ["opt_bar_grow_up"]                     = "Nach oben wachsen",
    ["opt_bar_size"]                        = "Schaltflächengröße",
    ["section_ab_behaviour"]                = "Verhalten",
    ["section_ab_chrome"]                   = "Rahmen und Hintergrund",
    ["section_ab_fade"]                     = "Ausblenden",
    ["section_ab_general"]                  = "Schaltflächen",
    ["section_ab_states"]                   = "Zustände",
    ["tab_ab_fade"]                         = "Ausblenden",
    ["tab_ab_general"]                      = "Allgemein",
    ["tab_ab_indicators"]                   = "Anzeigen",
    ["tab_ab_texts"]                        = "Texte",

    -- ActionBars: rebuild notice (lot P4)
    ["info_ab_rebuilding"]              = "Die Aktionsleisten werden auf einer neuen Engine neu aufgebaut. Ihre Einstellungen kehren mit dem nächsten Update zurück; die Leisten selbst funktionieren in der Zwischenzeit normal.",

    -- ActionBars: config tab labels (Lot A7)
    ["tab_abs_buttons"]                     = "Schaltflächen",
    ["tab_abs_glow"]                        = "Leuchten",
    ["tab_abs_hotkeys"]                     = "Tasten",

    -- ActionBars: TomoMod-owned buttons (Lot A6)
    ["opt_bar_own_buttons"]                 = "TomoMod-Schaltflächen (experimentell)",
    ["info_bar_own_buttons"]                = "Ersetzt Blizzards Schaltflächen auf dieser Leiste durch TomoMods eigene. Erfordert /reload. Flyouts (Portale, Fallen, Phiolen) und die assistierte Hervorhebung werden noch nicht unterstützt.",

    -- ActionBars: special bars (stances, pet, state decoration)
    ["section_ab_special"]                  = "Haltungen, Begleiter & Zustände",
    ["opt_ab_sp_active"]                    = "Aktive Aktion hervorheben",
    ["opt_ab_sp_active_color"]              = "Farbe für aktiv",
    ["opt_ab_sp_equipped"]                  = "Ausgerüstete Gegenstände hervorheben",
    ["opt_ab_sp_equipped_color"]            = "Farbe für ausgerüstet",
    ["opt_ab_sp_thickness"]                 = "Stärke der Hervorhebung",
    ["opt_ab_sp_autocast"]                  = "Autozauber-Schimmern des Begleiters",
    ["opt_ab_sp_autocast_color"]            = "Farbe des Autozaubers",
    ["opt_ab_sp_pet_autohide"]              = "Begleiterleiste ohne Begleiter ausblenden",
    ["info_ab_sp_pet_autohide"]             = "Blendet sie aus, solange kein Begleiter da ist. Für Haltungen gibt es keine entsprechende Bedingung; sie bleiben bei Blizzard.",

    -- ActionBars: hotkey layer (keybind text, binding mode)
    ["section_ab_hotkey"]                   = "Tastenbelegung",
    ["opt_ab_hk_enable"]                    = "Tastenbelegung anzeigen",
    ["opt_ab_hk_abbrev"]                    = "Abkürzen",
    ["opt_ab_hk_size"]                      = "Schriftgröße",
    ["opt_ab_hk_anchor"]                    = "Position",
    ["opt_ab_hk_offx"]                      = "Horizontaler Versatz",
    ["opt_ab_hk_offy"]                      = "Vertikaler Versatz",
    ["opt_ab_hk_color"]                     = "Textfarbe",
    ["opt_ab_hk_hide_empty"]                = "Bei leeren Feldern ausblenden",
    ["btn_ab_hk_bind"]                      = "Belegungsmodus",
    ["info_ab_hk_bind"]                     = "Tasten direkt auf den Leisten zuweisen. Im Kampf nicht verfügbar.",
    ["hotkey_bind_enter"]                   = "Belegungsmodus: Schaltfläche überfahren und Taste drücken. Rechtsklick oder Esc löscht.",
    ["hotkey_bind_exit"]                    = "Belegungsmodus beendet, Belegungen gespeichert.",
    ["hotkey_combat_blocked"]               = "Der Belegungsmodus ist im Kampf nicht verfügbar.",

    -- ActionBars: glow layer (procs, rotation hint)
    ["section_ab_glow"]                     = "Leuchten (Procs & Rotation)",
    ["opt_ab_glow_proc"]                    = "Leuchten bei Proc",
    ["opt_ab_glow_proc_type"]               = "Proc-Leuchtstil",
    ["opt_ab_glow_proc_color"]              = "Proc-Leuchtfarbe",
    ["opt_ab_glow_assist"]                  = "Leuchten bei Rotationshinweis",
    ["opt_ab_glow_assist_type"]             = "Rotations-Leuchtstil",
    ["opt_ab_glow_assist_color"]            = "Rotations-Leuchtfarbe",
    ["info_ab_glow_assist"]                 = "Folgt Blizzards Assistierter Hervorhebung. Die Funktion muss auf dem Charakter verfügbar sein.",
    ["opt_ab_glow_lines"]                   = "Pixel: Anzahl der Linien",
    ["opt_ab_glow_freq"]                    = "Animationsgeschwindigkeit",
    ["opt_ab_glow_thickness"]               = "Pixel: Linienstärke",

    -- ActionBars: render layer (icons, cooldowns, texts)
    ["section_ab_icons"]                    = "Symbole & Abklingzeiten",
    ["opt_ab_cd_backend"]                   = "Abklingzeit-Quelle",
    ["info_ab_cd_managed"]                  = "Verwaltet: TomoMod zeichnet die Abklingzeit selbst. Für künftige TomoMod-Schaltflächen nötig; Blizzards Quelle bleibt vorerst sicherer.",
    ["opt_ab_cd_numbers"]                   = "Abklingzeit-Zahlen",
    ["opt_ab_cd_size"]                      = "Größe der Zahlen",
    ["opt_ab_swipe_color"]                  = "Farbe des Wischeffekts",
    ["opt_ab_swipe_alpha"]                  = "Deckkraft des Wischeffekts",
    ["opt_ab_show_count"]                   = "Aufladungen / Stapel anzeigen",
    ["opt_ab_count_size"]                   = "Textgröße der Aufladungen",
    ["opt_ab_show_macro"]                   = "Makronamen anzeigen",
    ["opt_ab_desat_unusable"]               = "Entsättigen wenn unbenutzbar",
    ["opt_ab_icon_zoom"]                    = "Symbolzuschnitt",
    ["cat_action_bars"]                 = "Aktionsleisten",
    ["opt_abs_enable"]                  = "Aktionsleisten-Skin aktivieren",
    ["opt_abs_class_color"]             = "Klassenfarbe für Ränder",
    ["opt_abs_shift_reveal"]            = "Shift halten zum Einblenden versteckter Leisten",
    ["sublabel_bar_opacity"]            = "— Deckkraft pro Leiste —",
    ["opt_abs_select_bar"]              = "Aktionsleiste auswählen",
    ["btn_abs_apply_all_opacity"]       = "Auf alle Leisten anwenden",
    ["msg_abs_all_opacity"]             = "Deckkraft auf %d%% für alle Leisten gesetzt",
    ["sublabel_bar_combat"]             = "— Kampfsichtbarkeit —",
    ["opt_abs_combat_show"]             = "Nur im Kampf anzeigen",

    ["section_cinematic"]               = "Zwischensequenzen überspringen",
    ["opt_cinematic_auto_skip"]         = "Auto-überspringen nach erstem Ansehen",
    ["info_cinematic_viewed"]           = "Bereits gesehene Zwischensequenzen: %s\nVerlauf wird charakterübergreifend geteilt.",
    ["btn_clear_history"]               = "Verlauf löschen",

    -- Auto Quest
    ["section_auto_quest"]              = "Auto-Quest",
    ["opt_quest_auto_accept"]           = "Quests automatisch annehmen",
    ["opt_quest_auto_turnin"]           = "Quests automatisch abgeben",
    ["opt_quest_auto_gossip"]           = "Dialogoptionen automatisch wählen",
    ["info_quest_shift"]                = "SHIFT halten zum vorübergehenden Deaktivieren.\nQuests mit mehreren Belohnungen werden nicht automatisch abgegeben.",

    -- Objective Tracker Skin
    ["tab_qol_obj_tracker"]             = "Zielverfolgung",
    ["section_obj_tracker"]             = "Zielverfolgung-Skin",
    ["opt_obj_tracker_enable"]          = "Zielverfolgung-Skin aktivieren",
    ["opt_obj_tracker_bg_alpha"]        = "Hintergrund-Deckkraft",
    ["opt_obj_tracker_border"]          = "Rahmen anzeigen",
    ["opt_obj_tracker_hide_empty"]      = "Ausblenden wenn leer",
    ["opt_obj_tracker_buckets"]         = "Quests in einklappbare Kategorien gruppieren",
    ["opt_obj_tracker_header_size"]     = "Kopfzeilen-Schriftgröße",
    ["opt_obj_tracker_cat_size"]        = "Kategorie-Schriftgröße",
    ["opt_obj_tracker_quest_size"]      = "Quest-Titel-Schriftgröße",
    ["opt_obj_tracker_obj_size"]        = "Ziel-Schriftgröße",
    ["opt_obj_tracker_max_quests"]       = "Max. angezeigte Quests (0 = unbegrenzt)",
    ["ot_overflow_text"]                 = "%d weitere Quest(s) ausgeblendet...",
    ["info_obj_tracker"]                = "Skinnt die Blizzard-Zielverfolgung mit dunklem Panel, eigenen Schriften und farbigen Kategorieüberschriften.",
    ["ot_header_title"]                 = "ZIELE",
    ["ot_header_options"]               = "Optionen",

    -- Automations
    ["section_automations"]             = "Automatisierungen",
    ["opt_hide_blizzard_castbar"]       = "Blizzard-Zauberleiste ausblenden",
    ["opt_hide_talking_head"]           = "Talking Head ausblenden (Scrolldialoge)",
    ["opt_hide_status_bar2"]            = "Blizzards Statusleiste 2 ausblenden",
    ["opt_hide_status_bar2_desc"]       = "Macht die zweite Statusleiste des Bearbeitungsmodus unsichtbar und klickdurchlässig. Sie gehört weiterhin Blizzard und bleibt im Bearbeitungsmodus sichtbar.",

    -- Auto Accept Invite
    ["sublabel_auto_accept_invite"]     = "— Auto-Einladungsannahme —",
    ["sublabel_auto_skip_role"]         = "— Auto-Rollenprüfung überspringen —",
    ["sublabel_tooltip_ids"]            = "— Tooltip-IDs —",
    ["sublabel_combat_res_tracker"]     = "— Kampfwiederbelebungs-Tracker —",
    ["opt_cr_show_rating"]              = "M+-Wertung anzeigen",
    ["opt_show_messages"]               = "Chatnachrichten anzeigen",
    ["opt_tid_spell"]                   = "Zauber-/Aura-ID",
    ["opt_tid_item"]                    = "Gegenstands-ID",
    ["opt_tid_npc"]                     = "NSC-ID",
    ["opt_tid_quest"]                   = "Quest-ID",
    ["opt_tid_mount"]                   = "Reittier-ID",
    ["opt_tid_currency"]                = "Währungs-ID",
    ["opt_tid_achievement"]             = "Erfolgs-ID",
    ["opt_accept_friends"]              = "Von Freunden annehmen",
    ["opt_accept_guild"]                = "Von Gilde annehmen",

    -- Auto Summon
    ["sublabel_auto_summon"]            = "— Auto-Beschwörung —",
    ["opt_summon_delay"]                = "Verzögerung (Sekunden)",

    -- Auto Fill Delete
    ["sublabel_auto_fill_delete"]       = "— Auto-LÖSCHEN ausfüllen —",
    ["sublabel_auto_vendor_repair"]     = "— Auto-Verkauf / Reparatur —",
    ["opt_avr_auto_repair"]             = "Automatische Reparatur beim Händler",
    ["opt_avr_sell_grays"]              = "Graue (schlechte) Gegenstände automatisch verkaufen",
    ["opt_focus_ok_button"]             = "OK-Button nach Ausfüllen fokussieren",

    -- Mythic+ Keys
    ["section_mythic_keys"]             = "Mythisch+-Schlüssel",
    ["opt_keys_enable_tracker"]         = "Tracker aktivieren",
    ["opt_keys_mini_frame"]             = "Mini-Frame auf M+-Oberfläche",
    ["opt_keys_auto_refresh"]           = "Automatisch aktualisieren",

    -- SkyRide
    ["section_skyride"]                 = "SkyRide",
    ["opt_skyride_enable"]              = "Aktivieren (Fluganzeige)",
    ["section_skyride_dims"]            = "Abmessungen",
    ["opt_skyride_bar_height"]          = "Geschwindigkeitsleistenhöhe",
    ["opt_skyride_charge_height"]       = "Aufladungsleistenhöhe",
    ["opt_skyride_charge_gap"]          = "Abstand zwischen Segmenten",
    ["section_skyride_text"]            = "Text",
    ["opt_skyride_show_speed_text"]     = "Geschwindigkeitsprozent anzeigen",
    ["opt_skyride_speed_font_size"]     = "Geschwindigkeitstext-Schriftgröße",
    ["opt_skyride_show_charge_timer"]   = "Aufladungstimer anzeigen",
    ["opt_skyride_charge_font_size"]    = "Aufladungstimer-Schriftgröße",
    ["btn_reset_skyride"]               = "SkyRide-Position zurücksetzen",

    -- =====================
    -- CONFIG: QOL — CVar Optimizer
    -- =====================
    ["tab_qol_cvar_opt"]                = "Perf CVars",
    ["section_cvar_optimizer"]          = "CVar-Optimierer",
    ["info_cvar_optimizer"]             = "Wendet empfohlene Grafik-/Leistungseinstellungen an. Deine aktuellen Werte werden gespeichert und können jederzeit wiederhergestellt werden.",
    ["btn_cvar_apply_all"]              = ">> Alle anwenden",
    ["btn_cvar_revert_all"]             = "<< Alle wiederherstellen",
    ["btn_cvar_apply"]                  = "Anwenden",
    ["btn_cvar_revert"]                 = "Wiederherstellen",
    -- Categories
    ["opt_cat_render"]                  = "Rendering & Anzeige",
    ["opt_cat_graphics"]                = "Grafikqualität",
    ["opt_cat_detail"]                  = "Sichtweite & Details",
    ["opt_cat_advanced"]                = "Erweitert",
    ["opt_cat_fps"]                     = "FPS-Begrenzungen",
    ["opt_cat_post"]                    = "Nachbearbeitung",
    -- CVar labels
    ["opt_cvar_render_scale"]           = "Renderskalierung",
    ["opt_cvar_vsync"]                  = "VSync",
    ["opt_cvar_msaa"]                   = "Multisampling (MSAA)",
    ["opt_cvar_low_latency"]            = "Niedriger Latenz-Modus",
    ["opt_cvar_anti_aliasing"]          = "Kantenglättung",
    ["opt_cvar_shadow"]                 = "Schattenqualität",
    ["opt_cvar_ssao"]                   = "SSAO",
    ["opt_cvar_depth"]                  = "Tiefeneffekte",
    ["opt_cvar_compute"]                = "Berechnungseffekte",
    ["opt_cvar_particle"]               = "Partikeldichte",
    ["opt_cvar_liquid"]                 = "Flüssigkeitsdetails",
    ["opt_cvar_spell_density"]          = "Zauberdichte",
    ["opt_cvar_projected"]              = "Projizierte Texturen",
    ["opt_cvar_outline"]                = "Umrissmodus",
    ["opt_cvar_texture_res"]            = "Texturauflösung",
    ["opt_cvar_view_distance"]          = "Sichtweite",
    ["opt_cvar_env_detail"]             = "Umgebungsdetails",
    ["opt_cvar_ground"]                 = "Bodenbewuchs",
    ["opt_cvar_gfx_api"]                = "Grafik-API",
    ["opt_cvar_triple_buffering"]       = "Dreifachpufferung",
    ["opt_cvar_texture_filtering"]      = "Texturfilterung",
    ["opt_cvar_rt_shadows"]             = "Raytracing-Schatten",
    ["opt_cvar_resample_quality"]       = "Resample-Qualität",
    ["opt_cvar_physics"]                = "Physikstufe",
    ["opt_cvar_target_fps"]             = "Ziel-FPS",
    ["opt_cvar_bg_fps_enable"]          = "Hintergrund-FPS-Begrenzung",
    ["opt_cvar_bg_fps"]                 = "Hintergrund-FPS-Wert",
    ["opt_cvar_resample_sharpness"]     = "Resample-Schärfe",
    ["opt_cvar_camera_shake"]           = "Kamerawackeln",
    -- Messages
    ["msg_cvar_applied"]                = "CVars angewendet",
    ["msg_cvar_reverted"]               = "CVars wiederhergestellt",
    ["msg_cvar_no_backup"]              = "Kein Backup gefunden — zuerst anwenden.",
    ["tab_qol_leveling"]                = "Leveling",
    ["section_leveling_bar"]            = "Leveling-Leiste",
    ["opt_leveling_enable"]             = "Leveling-Leiste aktivieren",
    ["opt_leveling_width"]              = "Leistenbreite",
    ["opt_leveling_height"]             = "Leistenhöhe",
    ["btn_reset_leveling_pos"]          = "Position zurücksetzen",
    ["leveling_bar_title"]              = "Leveling-Leiste",
    ["leveling_level"]                  = "Stufe",
    ["leveling_progress"]               = "Fortschritt:",
    ["leveling_rested"]                 = "Ausgeruht",
    ["leveling_last_quest"]             = "Letzte Quest:",
    ["leveling_ttl"]                    = "Zeit bis Level:",
    ["leveling_remaining"]              = "Verbleibend",
    ["leveling_session"]                = "Diese Stufe",
    ["leveling_drag_hint"]              = "/tm sr zum Entsperren & Verschieben",

    -- =====================
    -- CONFIG: Profiles Panel (3 Tabs)
    -- =====================
    ["tab_profiles"]                    = "Profile",
    ["tab_import_export"]               = "Import/Export",
    ["tab_resets"]                      = "Zurücksetzen",

    -- Tab 1: Named profiles & specializations
    ["section_named_profiles"]          = "Profile",
    ["info_named_profiles"]             = "Erstelle und verwalte benannte Profile. Jedes Profil speichert einen vollständigen Schnappschuss deiner Einstellungen.",
    ["profile_active_label"]            = "Aktives Profil",
    ["opt_select_profile"]              = "Profil wählen",
    ["sublabel_create_profile"]         = "— Neues Profil erstellen —",
    ["placeholder_profile_name"]        = "Profilname...",
    ["btn_create_profile"]              = "Profil erstellen",
    ["btn_delete_named_profile"]        = "Profil löschen",
    ["btn_save_profile"]                = "Aktuelles Profil speichern",
    ["info_save_profile"]               = "Speichert alle aktuellen Einstellungen im aktiven Profil. Dies geschieht automatisch beim Profilwechsel.",

    ["section_profile_mode"]            = "Profilmodus",
    ["info_spec_profiles"]              = "Aktiviere Spezialisierungsprofile zum automatischen Speichern und Laden der Einstellungen beim Spezialisierungswechsel.\nJede Spezialisierung erhält eine eigene Konfiguration.",
    ["opt_enable_spec_profiles"]        = "Spezialisierungsprofile aktivieren",
    ["profile_status"]                  = "Aktives Profil",
    ["profile_global"]                  = "Global (einzelnes Profil)",
    ["section_spec_list"]               = "Spezialisierungen",
    ["profile_badge_active"]            = "Aktiv",
    ["profile_badge_saved"]             = "Gespeichert",
    ["profile_badge_none"]              = "Kein Profil",
    ["btn_copy_to_spec"]                = "Aktuelles kopieren",
    ["btn_delete_profile"]              = "Löschen",
    ["info_spec_reload"]                = "Spezialisierungswechsel mit aktivierten Profilen lädt die Oberfläche automatisch neu, um das entsprechende Profil anzuwenden.",
    ["info_global_mode"]                = "Alle Spezialisierungen teilen die gleichen Einstellungen. Aktiviere Spezialisierungsprofile oben, um verschiedene Konfigurationen zu nutzen.",

    -- Tab 2: Import / Export
    ["section_export"]                  = "Einstellungen exportieren",
    ["info_export"]                     = "Erstellt eine komprimierte Zeichenkette aller aktuellen Einstellungen.\nKopiere sie zum Teilen oder als Backup.",
    ["label_export_string"]             = "Exportstring (klicken um alles auszuwählen)",
    ["btn_export"]                      = "Exportstring generieren",
    ["btn_copy_clipboard"]              = "Text kopieren",
    ["section_import"]                  = "Einstellungen importieren",
    ["info_import"]                     = "Füge unten einen Exportstring ein. Er wird vor der Anwendung validiert.",
    ["label_import_string"]             = "Importstring hier einfügen",
    ["btn_import"]                      = "Importieren & Anwenden",
    ["btn_paste_clipboard"]             = "Text einfügen",
    ["import_preview"]                  = "Klasse: %s | Module: %s | Datum: %s",
    ["import_preview_valid"]            = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t Gültiger String",
    ["import_preview_invalid"]          = "Ungültiger oder beschädigter String",
    ["info_import_warning"]             = "Der Import ÜBERSCHREIBT alle aktuellen Einstellungen und lädt die Oberfläche neu. Dies kann nicht rückgängig gemacht werden.",

    -- Tab 3: Resets
    ["section_profile_mgmt"]            = "Profilverwaltung",
    ["info_profiles"]                   = "Setze einzelne Module zurück oder exportiere/importiere deine Einstellungen.\nExport kopiert Einstellungen in die Zwischenablage (benötigt LibSerialize + LibDeflate).",
    ["section_reset_module"]            = "Modul zurücksetzen",
    ["btn_reset_prefix"]                = "Zurücksetzen: ",
    ["btn_reset_all_reload"]            = "(!) ALLES ZURÜCKSETZEN + Neuladen",
    ["section_reset_all"]               = "Vollständiges Zurücksetzen",
    ["info_resets"]                     = "Setze ein einzelnes Modul auf Standardwerte zurück. Das Modul wird mit Werkseinstellungen neu geladen.",
    ["info_reset_all_warning"]          = "Dies setzt ALLE Module und ALLE Einstellungen auf Werkseinstellungen zurück und lädt dann die Oberfläche neu.",

    -- =====================
    -- PRINT MESSAGES: Core
    -- =====================
    ["msg_db_reset"]                    = "Datenbank zurückgesetzt",
    ["msg_migration_failed"]           = "Ein Datenbank-Migrationsschritt ist fehlgeschlagen — bitte im Discord melden: ",
    ["msg_normalize_failed"]           = "Die Element-Normalisierung ist fehlgeschlagen — bitte im Discord melden: ",
    ["msg_module_reset"]                = "Modul '%s' zurückgesetzt",
    ["msg_db_not_init"]                 = "Datenbank nicht initialisiert",
    ["msg_loaded"]                      = "geladen — %s für Konfiguration",
    ["msg_report_issue"]                = "Falls ein Problem auftritt, hinterlasst bitte einen Kommentar auf CurseForge.",
    ["at_rescue_header"]              = "Der Aura-Tracker wurde entfernt; CooldownForge deckt dasselbe ab.",
    ["at_rescue_list"]                = "Manuell hinzugef\195\188gte Zauber: %s",
    ["at_rescue_hint"]                = "F\195\188ge sie im Cooldown Studio erneut hinzu, wenn du sie weiter verfolgen willst.",
    ["msg_help_title"]                  = "Befehle:",
    ["msg_help_open"]                   = "Konfiguration öffnen",
    ["msg_help_reset"]                  = "Alles zurücksetzen + Neuladen",
    ["msg_help_uf"]                     = "UnitFrames + Ressourcen sperren/entsperren",
    ["msg_help_uf_reset"]               = "UnitFrames zurücksetzen",
    ["msg_help_rb"]                     = "Ressourcenleisten sperren/entsperren",
    ["msg_help_rb_sync"]                = "Breite mit Essential Cooldowns synchronisieren",
    ["msg_help_np"]                     = "Nameplates ein/ausschalten",
    ["msg_help_minimap"]                = "Minimap zurücksetzen",
    ["msg_help_panel"]                  = "Infopanel zurücksetzen",
    ["msg_help_cursor"]                 = "Cursorring zurücksetzen",
    ["msg_help_clearcinema"]            = "Zwischensequenz-Verlauf löschen",
    ["msg_help_sr"]                     = "SkyRide + Anker sperren/entsperren",
    ["msg_help_key"]                    = "Mythisch+-Schlüssel öffnen",
    ["msg_help_help"]                   = "Diese Hilfe",

    -- =====================
    -- PRINT MESSAGES: Modules
    -- =====================
    -- CDM
    ["msg_cdm_status"]                  = "Aktiviert",
    ["msg_cdm_disabled"]                = "Deaktiviert",

    -- Nameplates
    ["msg_np_enabled"]                  = "Aktiviert",
    ["msg_np_disabled"]                 = "Deaktiviert",

    -- UnitFrames
    ["msg_uf_locked"]                   = "Gesperrt",
    ["msg_uf_unlocked"]                 = "Entsperrt — Ziehen zum Neupositionieren",
    ["msg_uf_initialized"]              = "Initialisiert — /tm uf zum Sperren/Entsperren",
    ["msg_uf_enabled"]                  = "aktiviert (Neuladen erforderlich)",
    ["msg_uf_disabled"]                 = "deaktiviert (Neuladen erforderlich)",
    ["msg_uf_position_reset"]           = "Position zurückgesetzt",

    -- ResourceBars
    ["msg_rb_width_synced"]             = "Breite synchronisiert (%dpx)",
    ["msg_rb_locked"]                   = "Gesperrt",
    ["msg_rb_unlocked"]                 = "Entsperrt — Ziehen zum Neupositionieren",
    ["msg_rb_position_reset"]           = "Position der Ressourcenleisten zurückgesetzt",

    -- SkyRide
    ["msg_sr_pos_saved"]                = "SkyRide-Position gespeichert",
    ["msg_sr_locked"]                   = "SkyRide gesperrt",
    ["msg_sr_unlock"]                   = "SkyRide-Verschiebemodus aktiviert – Klicken und ziehen",
    ["msg_sr_pos_reset"]                = "SkyRide-Position zurückgesetzt",
    ["msg_sr_db_not_init"]              = "TomoModForeverDB nicht initialisiert",
    ["msg_sr_initialized"]              = "SkyRide-Modul initialisiert",

    -- FrameAnchors
    ["anchor_alert"]                    = "Warnungen",
    ["anchor_loot"]                     = "Beute",
    ["msg_anchors_locked"]              = "Gesperrt",
    ["msg_anchors_unlocked"]            = "Entsperrt — Anker verschieben",

    -- AutoVendorRepair
    ["msg_avr_header"]                  = "[AutoHändlerReparatur]",
    ["msg_avr_sold"]                    = " Graue Gegenstände verkauft für |cffffff00%s|r",
    ["msg_avr_repaired"]                = " Ausrüstung repariert für |cffffff00%s|r",

    -- AutoFillDelete
    ["msg_afd_filled"]                  = "Text 'LÖSCHEN' automatisch ausgefüllt – Klicke OK zum Bestätigen",
    ["msg_afd_db_not_init"]             = "TomoModForeverDB nicht initialisiert",
    ["msg_afd_initialized"]             = "AutoFillDelete-Modul initialisiert",
    ["msg_afd_enabled"]                 = "Auto-Ausfüllen LÖSCHEN aktiviert",
    ["msg_afd_disabled"]                = "Auto-Ausfüllen LÖSCHEN deaktiviert (Hook bleibt aktiv)",

    -- HideCastBar
    ["msg_hcb_db_not_init"]             = "TomoModForeverDB nicht initialisiert",
    ["msg_hcb_initialized"]             = "HideCastBar-Modul initialisiert",
    ["msg_hcb_hidden"]                  = "Zauberleiste ausgeblendet",
    ["msg_hcb_shown"]                   = "Zauberleiste eingeblendet",

    -- AutoAcceptInvite
    ["msg_aai_accepted"]                = "Einladung angenommen von ",
    ["msg_aai_ignored"]                 = "Einladung ignoriert von ",
    ["msg_aai_enabled"]                 = "Auto-Einladungsannahme aktiviert",
    ["msg_aai_disabled"]                = "Auto-Einladungsannahme deaktiviert",
    ["msg_asr_lfg_accepted"]            = "Rollenprüfung automatisch bestätigt",
    ["msg_asr_poll_accepted"]           = "Rollenumfrage automatisch bestätigt",
    ["msg_asr_enabled"]                 = "Auto-Rollenprüfung überspringen aktiviert",
    ["msg_asr_disabled"]                = "Auto-Rollenprüfung überspringen deaktiviert",
    ["msg_tid_enabled"]                 = "Tooltip-IDs aktiviert",
    ["msg_tid_disabled"]                = "Tooltip-IDs deaktiviert",
    ["msg_cr_enabled"]                  = "Kampfwiederbelebungs-Tracker aktiviert",
    ["msg_cr_disabled"]                 = "Kampfwiederbelebungs-Tracker deaktiviert",
    ["msg_cr_locked"]                   = "Kampfwiederbelebungs-Tracker gesperrt",
    ["msg_cr_unlock"]                   = "Kampfwiederbelebungs-Tracker entsperrt — ziehen zum Verschieben",
    ["msg_abs_enabled"]                 = "Aktionsleisten-Skin aktiviert (Neuladen empfohlen)",
    ["msg_abs_disabled"]                = "Aktionsleisten-Skin deaktiviert",
    ["opt_buffskin_enable"]             = "Buff-Skin aktivieren",
    ["opt_buffskin_desc"]               = "Fügt schwarze Ränder und farbige Timer auf Spieler-Buffs/Debuffs hinzu",
    ["msg_buffskin_enabled"]            = "Buff-Skin aktiviert",
    ["msg_buffskin_disabled"]           = "Buff-Skin deaktiviert",
    ["msg_help_cr"]                     = "Kampfwiederbelebungs-Tracker sperren/entsperren",
    ["msg_help_cs"]                     = "Charakterbogen sperren/entsperren",
    ["msg_help_cs_reset"]               = "Charakterbogen auf Standardposition zurücksetzen",

    -- CinematicSkip
    ["msg_cin_skipped"]                 = "Zwischensequenz übersprungen (bereits gesehen)",
    ["msg_vid_skipped"]                 = "Video übersprungen (bereits gesehen)",
    ["msg_vid_id_skipped"]              = "Video #%d übersprungen",
    ["msg_cin_cleared"]                 = "Zwischensequenz-Verlauf gelöscht",

    -- AutoSummon
    ["msg_sum_accepted"]                = "Beschwörung angenommen von %s nach %s (%s)",
    ["msg_sum_ignored"]                 = "Beschwörung ignoriert von %s (nicht vertrauenswürdig)",
    ["msg_sum_enabled"]                 = "Auto-Beschwörung aktiviert",
    ["msg_sum_disabled"]                = "Auto-Beschwörung deaktiviert",
    ["msg_sum_manual"]                  = "Beschwörung manuell angenommen",
    ["msg_sum_no_pending"]              = "Keine ausstehende Beschwörung",

    -- MythicKeys
    ["msg_keys_no_key"]                 = "Kein Schlüssel zum Senden.",
    ["msg_keys_not_in_group"]           = "Du musst in einer Gruppe sein.",
    ["msg_keys_reload"]                 = "Änderung wird beim nächsten /reload angewendet.",
    ["mk_not_in_group"]                 = "Du bist nicht in einer Gruppe.",
    ["mk_not_in_group_short"]           = "Nicht in Gruppe.",
    ["mk_no_key_self"]                  = "Kein Schlüsselstein gefunden.",
    ["mk_title"]                        = "TM — Mythisch+ Schlüssel",
    ["mk_btn_send"]                     = "Im Chat senden",
    ["mk_btn_refresh"]                  = "Aktualisieren",
    ["mk_tab_keys"]                     = "Schlüssel",
    ["mk_tab_tp"]                       = "TP",
    ["mk_tp_click_to_tp"]              = "Klicken zum Teleportieren",
    ["mk_tp_not_unlocked"]             = "Nicht freigeschaltet",
    ["msg_tp_not_owned"]               = "Du besitzt den Teleport für %s nicht",
    ["msg_tp_combat"]                  = "Teleporte können im Kampf nicht aktualisiert werden.",

    -- =====================
    -- PRINT MESSAGES: Config Panels
    -- =====================
    ["msg_np_reset"]                    = "Nameplates zurückgesetzt (Neuladen empfohlen)",
    ["msg_uf_toggle"]                   = "UnitFrames %s (Neuladen)",
    ["msg_profile_reset"]               = "%s zurückgesetzt",
    ["msg_profile_copied"]              = "Aktuelle Einstellungen nach '%s' kopiert",
    ["msg_profile_deleted"]             = "Profil gelöscht für '%s'",
    ["msg_profile_loaded"]              = "Profil '%s' geladen — Neuladen zum Anwenden",
    ["msg_profile_load_failed"]         = "Laden des Profils '%s' fehlgeschlagen",
    ["msg_profile_created"]             = "Profil '%s' mit aktuellen Einstellungen erstellt",
    ["msg_profile_name_empty"]          = "Bitte einen Profilnamen eingeben",
    ["msg_profile_saved"]               = "Einstellungen im Profil '%s' gespeichert",

    -- New profile keys v2.3.0
    ["btn_rename_profile"]              = "Umbenennen",
    ["btn_duplicate_profile"]           = "Duplizieren",
    ["btn_load_profile"]                = "Laden",
    ["btn_close"]                       = "Schließen",
    ["btn_cancel"]                      = "Abbrechen",
    ["section_spec_assign"]             = "Profile pro Spezialisierung",
    ["info_spec_assign"]                = "Weise jeder Spezialisierung ein benanntes Profil zu. TomoMod wechselt automatisch das Profil beim Spezialisierungswechsel.",
    ["spec_profile_none"]               = "— Keins —",
    ["popup_rename_profile"]            = "|cffffd100TomoModForever|r\n\nNeuer Name für '%s':",
    ["popup_duplicate_profile"]         = "|cffffd100TomoModForever|r\n\n'%s' duplizieren als:",
    ["msg_profile_renamed"]             = "Profil '%s' umbenannt zu '%s'",
    ["msg_profile_duplicated"]          = "Profil '%s' dupliziert als '%s'",
    ["msg_import_as_profile"]           = "Profil importiert als '%s'",
    ["popup_export_title"]              = "Profil exportieren",
    ["popup_export_hint"]               = "Alles auswählen (Strg+A) und kopieren (Strg+C)",
    ["popup_import_title"]              = "Profil importieren",
    ["popup_import_hint"]               = "TomoMod-Exportstring einfügen, dann auf Importieren klicken",
    ["label_import_profile_name"]       = "Speichern als Profilname:",
    ["placeholder_import_profile_name"] = "Profilname (optional)...",
    ["msg_profile_name_deleted"]        = "Profil '%s' gelöscht",
    ["msg_export_success"]              = "Exportstring generiert — alles auswählen und kopieren",
    ["msg_import_success"]              = "Einstellungen erfolgreich importiert — Neuladen...",
    ["msg_import_empty"]                = "Nichts zu importieren — zuerst einen String einfügen",
    ["msg_copy_hint"]                   = "Text ausgewählt — Strg+C zum Kopieren drücken",
    ["msg_copy_empty"]                  = "Zuerst einen Exportstring generieren",
    ["msg_paste_hint"]                  = "Strg+V drücken um den Importstring einzufügen",
    ["msg_spec_changed_reload"]         = "Spezialisierung geändert — Profil wird geladen...",

    -- =====================
    -- INFO PANEL (Minimap)
    -- =====================
    ["time_server"]                     = "Server",
    ["time_local"]                      = "Lokal",
    ["time_tooltip_title"]              = "Uhrzeit (%s - %s)",
    ["time_tooltip_left_click"]         = "|cffffd100Linksklick:|r Kalender",
    ["time_tooltip_right_click"]        = "|cffffd100Rechtsklick:|r Server / Lokal",
    ["time_tooltip_shift_right"]        = "|cffffd100Shift + Rechtsklick:|r 12h / 24h",
    ["time_format_msg"]                 = "Format: %s",
    ["time_mode_msg"]                   = "Uhrzeit: %s",

    -- =====================
    -- ENABLED / DISABLED (generic)
    -- =====================
    ["enabled"]                         = "Aktiviert",
    ["disabled"]                        = "Deaktiviert",

    -- Static Popups
    ["popup_reset_text"]                = "|cffffd100TomoModForever|r\n\nALLE Einstellungen zurücksetzen?\nDies lädt die Oberfläche neu.",
    ["popup_confirm"]                   = "Bestätigen",
    ["popup_cancel"]                    = "Abbrechen",
    ["popup_import_text"]               = "|cffffd100TomoModForever|r\n\nEinstellungen importieren?\nDies ÜBERSCHREIBT alle aktuellen Einstellungen und lädt die Oberfläche neu.",
    ["popup_profile_reload"]            = "|cffffd100TomoModForever|r\n\nProfilmodus geändert.\nOberfläche neu laden zum Anwenden?",
    ["popup_delete_profile"]            = "|cffffd100TomoModForever|r\n\nProfil '%s' löschen?\nDies kann nicht rückgängig gemacht werden.",

    -- FPS element
    ["label_fps"]                       = "FPS",

    -- =====================
    -- BOSS FRAMES
    -- =====================
    ["tab_boss"]                        = "Boss",
    ["section_boss_frames"]             = "Boss-Leisten",
    ["opt_boss_enable"]                 = "Boss-Leisten aktivieren",
    ["opt_boss_height"]                 = "Leistenhöhe",
    ["opt_boss_spacing"]                = "Abstand zwischen Leisten",
    ["info_boss_drag"]                  = "Entsperren (/tm uf) zum Verschieben. Boss 1 ziehen, um alle 5 Leisten gemeinsam zu positionieren.",
    ["info_boss_colors"]                = "Leistenfarben nutzen Nameplate-Klassifizierungsfarben (Boss = rot, Mini-Boss = lila).",
    ["msg_boss_initialized"]            = "Boss-Leisten geladen.",

    -- =====================
    -- SOUND / LUST DETECTION
    -- =====================
    ["cat_sound"]                       = "Sound",
    ["section_sound_general"]           = "Bloodlust-Sound",
        ["info_sound_desc"]                 = "Spielt einen benutzerdefinierten Sound ab, wenn ein Bloodlust-Effekt erkannt wird. Die Erkennung prueft direkt die Lust-Buffs und Sated/Exhaustion-Debuffs.",
    ["opt_sound_enable"]                = "Bloodlust-Erkennung aktivieren",
    ["sublabel_sound_choice"]           = "Sound & Kanal",
    ["opt_sound_file"]                  = "Abzuspielender Sound",
    ["opt_sound_channel"]               = "Audiokanal",
    ["opt_sound_volume"]                = "Lautstärke des Audiokanals",
    ["info_sound_volume"]               = "Ändert die globale Lautstärke des ausgewählten Kanals in den Audioeinstellungen von WoW.",
    ["btn_sound_preview"]               = ">> Sound anhören",
    ["btn_sound_stop"]                  = "■  Stoppen",
    ["opt_sound_force"]                 = "Sound erzwingen, auch wenn das Spiel stummgeschaltet ist",
    ["opt_sound_chat"]                  = "Chatnachrichten anzeigen",
    ["opt_sound_debug"]                 = "Mode debug",

    -- =====================
    -- BAG & MICRO MENU
    -- =====================
    ["tab_qol_bag_micro"]               = "Tasche & Menü",
    ["section_bag_micro"]               = "Taschenleiste & Mikromenü",
    ["info_bag_micro"]                  = "Wähle, ob immer angezeigt oder bei Mauszeigerkontakt eingeblendet wird.",
    ["sublabel_bag_bar"]                = "— Taschenleiste —",
    ["sublabel_micro_menu"]             = "— Mikromenü —",
    ["opt_bag_bar_mode"]                = "Taschenleiste",
    ["opt_micro_menu_mode"]             = "Mikromenü",
    ["mode_show"]                       = "Immer sichtbar",
    ["mode_hover"]                      = "Bei Hover anzeigen",

    -- =====================
    -- MICRO BAR
    -- =====================
    ["microbar_btn_character"]          = "Charakter",
    ["microbar_btn_spells"]             = "Talente & Zauberbuch",
    ["microbar_btn_profession"]         = "Berufe",
    ["microbar_btn_achievement"]        = "Erfolge",
    ["microbar_btn_quest"]              = "Questlog",
    ["microbar_btn_guild"]              = "Gilde & Communities",
    ["microbar_btn_lfd"]                = "Gruppensuche",
    ["microbar_btn_collections"]        = "Sammlungen",
    ["microbar_btn_ej"]                 = "Abenteuerführer",
    ["microbar_btn_housing"]            = "Behausung",
    ["microbar_btn_social"]             = "Sozial",
    ["microbar_btn_store"]              = "Shop",
    ["microbar_btn_bags"]               = "Taschen",
    ["microbar_btn_mainmenu"]           = "Spielmenü",
    ["microbar_tt_memory"]              = "Addon-Speicher",
    ["microbar_tt_total"]               = "Gesamt",
    ["mover_microbar"]                  = "Mikroleiste",
    ["section_microbar"]                = "Mikroleiste",
    ["info_microbar"]                   = "Ersetzt das Mikromenü von Blizzard durch eine Leiste, die du frei skalieren, sortieren und platzieren kannst. Jeder Knopf leitet seinen Klick an den ursprünglichen Knopf weiter, sodass alles auch im Kampf funktioniert. Die Symbole werden direkt aus den Spieldateien gelesen. Solange dies aktiv ist, greift die Einstellung Mikromenü oben nicht mehr.",
    ["opt_microbar_enable"]             = "Mikroleiste aktivieren",
    ["opt_microbar_lfg_eye"]                = "Gruppensuche-Auge",
    ["opt_microbar_lfg_eye_scale"]          = "Größe des Auges",
    ["info_microbar_lfg_eye"]               = "Vom Blizzard-Mikromenü gelöst, damit es dessen Ausblenden übersteht. Im Layoutmodus platzieren.",
    ["opt_microbar_hide_native"]        = "Blizzard-Mikromenü ausblenden",
    ["opt_microbar_buttons"]            = "Knöpfe & Reihenfolge",
    ["opt_microbar_orientation"]        = "Ausrichtung",
    ["opt_microbar_per_line"]           = "Knöpfe pro Reihe (0 = eine Reihe)",
    ["opt_microbar_icon_size"]          = "Symbolgröße",
    ["opt_microbar_spacing"]            = "Abstand",
    ["opt_microbar_scale"]              = "Skalierung",
    ["opt_microbar_alpha"]              = "Deckkraft",
    ["opt_microbar_fade_mode"]          = "Sichtbarkeit",
    ["opt_microbar_fade_alpha"]         = "Deckkraft beim Ausblenden",
    ["opt_microbar_color_mode"]         = "Symbolfarbe",
    ["opt_microbar_color"]              = "Eigene Farbe",
    ["opt_microbar_desaturate"]         = "Symbole entsättigen",
    ["opt_microbar_hover_zoom"]         = "Symbol beim Überfahren vergrößern",
    ["opt_microbar_memory_tooltip"]     = "Addon-Speicher am Menüknopf anzeigen",
    ["microbar_orient_h"]               = "Horizontal",
    ["microbar_orient_v"]               = "Vertikal",
    ["microbar_fade_always"]            = "Immer sichtbar",
    ["microbar_fade_hover"]             = "Bei Hover anzeigen",
    ["microbar_fade_hovercombat"]       = "Bei Hover, im Kampf immer",
    ["microbar_color_class"]            = "Klasse",
    ["microbar_color_custom"]           = "Eigene",
    ["microbar_color_native"]           = "Original",
    ["btn_microbar_place"]              = "Leiste platzieren",
    ["btn_microbar_reset_pos"]          = "Position zurücksetzen",
    ["section_microbar_states"]         = "Mikroleiste — Native Zustände",
    ["info_microbar_states"]            = "Die ursprünglichen Knöpfe laufen unter der Leiste weiter, ihre Hinweise, ausgegrauten Zustände und Tastenbelegungen bleiben also aktiv. Diese Optionen spiegeln sie auf deine eigenen Knöpfe.",
    ["opt_microbar_alert_style"]        = "Hinweis-Leuchten",
    ["opt_microbar_alert_color"]        = "Hinweisfarbe",
    ["opt_microbar_dim_disabled"]       = "Nicht verfügbare Knöpfe abdunkeln",
    ["opt_microbar_disabled_alpha"]     = "Abgedunkelte Deckkraft",
    ["opt_microbar_show_keybind"]       = "Tastenbelegung auf den Symbolen anzeigen",
    ["opt_microbar_keybind_size"]       = "Textgröße der Tastenbelegung",
    ["microbar_glow_none"]              = "Keines",
    ["microbar_glow_pixel"]             = "Pixel-Leuchten",
    ["microbar_glow_autocast"]          = "Autozauber-Schimmer",
    ["microbar_glow_button"]            = "Aktionsknopf-Leuchten",
    ["microbar_glow_proc"]              = "Proc-Leuchten",

    -- =====================
    -- CHARACTER SKIN
    -- =====================
    ["tab_qol_char_skin"]               = "Charakter-Skin",
    ["section_char_skin"]               = "Charakterbogen-Skin",
    ["info_char_skin_desc"]             = "Wendet das dunkle TomoMod-Thema auf Charakterbogen, Ruf, Währungen und Inspektionsfenster an.",
    ["opt_char_skin_enable"]            = "Charakter-Skin aktivieren",
    ["opt_char_skin_character"]         = "Skin Charakter / Ruf / Währungen",
    ["opt_char_skin_inspect"]           = "Skin Inspektionsfenster",
    ["opt_char_skin_inspect_iteminfo"]  = "Gegenstandsstufe, Verzauberungen & Edelsteine bei Inspektion anzeigen",
    ["opt_char_skin_iteminfo"]          = "Gegenstandsinfo auf Plätzen anzeigen",
    ["opt_char_skin_gems"]              = "Edelstein-Sockel auf Plätzen anzeigen",
    ["opt_char_skin_midnight"]          = "Midnight-Verzauberungen (Kopf/Schultern statt Armschienen/Umhang)",
    ["opt_char_skin_scale"]             = "Fensterskalierung",
    ["msg_char_skin_reload"]            = "Charakter-Skin: /reload zum Anwenden.",

    -- =====================
    -- LAYOUT / MOVERS SYSTEM
    -- =====================
    ["btn_layout"]                      = "EditMode",
    ["btn_layout_tooltip"]              = "EditMode: entsperrt alle Elemente, damit du sie verschieben kannst.",
    ["btn_reload_ui"]                   = "UI neuladen",
    ["layout_mode_title"]               = "TomoMod — EditMode",
    ["layout_mode_hint"]                = "Elemente ziehen zum Neupositionieren — Sperren klicken wenn fertig",
    ["layout_btn_lock"]                 = "Sperren",
    ["layout_btn_reload"]               = "RL",
    ["layout_btn_gui"]                  = "GUI",
    ["grid_dimmed"]                    = "Raster",
    ["grid_bright"]                    = "Raster +",
    ["grid_disabled"]                  = "Raster AUS",
    ["layout_unlocked"]                 = "EditMode AN — Elemente ziehen. Sperren klicken oder /tm layout wenn fertig.",
    ["layout_locked"]                   = "EditMode AUS — Positionen gespeichert.",
    ["msg_help_layout"]                 = "EditMode umschalten (alle UI-Elemente verschieben)",
    ["mover_unitframes"]                = "Unit Frames",
    ["mover_resources"]                 = "Ressourcenleisten",
    ["mover_skyriding"]                 = "Skyriding-Leiste",
    ["mover_levelingbar"]               = "XP / Leveling-Leiste",
    ["mover_anchors"]                   = "Warn- & Beuteanker",
    ["mover_cotank"]                    = "Co-Tank-Tracker",
    ["mover_repbar"]                    = "Rufleiste",
    ["mover_castbar"]                   = "Spieler-Zauberleiste",
    ["mover_mythictracker"]             = "M+ Tracker",
    ["mover_chatframe"]                 = "Chat-Fenster",

    -- =====================
    -- COMBAT TEXT
    -- =====================
    ["sublabel_combat_text"]             = "— Kampftext —",
    ["opt_combat_text_enable"]           = "Kampftext aktivieren",
    ["opt_combat_text_offset_x"]         = "Versatz X",
    ["opt_combat_text_offset_y"]         = "Versatz Y",

    -- =====================
    -- PREY TRACKER
    -- =====================
    ["sublabel_prey_tracker"]            = "— Beute-Tracker —",
    ["opt_prey_tracker_enable"]          = "Beute-Tracker aktivieren",
    ["opt_prey_tracker_width"]           = "Breite",
    ["opt_prey_tracker_font"]            = "Schriftgröße",
    ["info_prey_tracker"]                = "Nur Midnight-Inhalt. Zeigt eine verschiebbare Fortschrittsleiste während aktiver Prey-Hunts. Positionierung über /tm layout.",

    -- =====================
    -- SKINS (Chat)
    -- =====================
    ["tab_qol_skins"]                    = "Skins",
    ["section_skins"]                    = "UI-Skins",
    ["info_skins_desc"]                  = "Wendet das dunkle TomoMod-Design auf verschiedene Blizzard-UI-Elemente an. Ein /reload kann nötig sein.",
    ["sublabel_chat_skin"]               = "— Chat-Fenster —",
    ["opt_chat_skin_enable"]             = "Chat-Fenster-Skin",
    ["opt_chat_skin_style"]              = "Skin-Stil",
    ["opt_chat_skin_style_tui"]          = "TUI (Seitenleiste + Fenster)",
    ["opt_chat_skin_style_classic"]      = "Klassisch (Gerahmt)",
    ["opt_chat_skin_style_glass"]        = "Glas (Mattiert)",
    ["opt_chat_skin_style_minimal"]      = "Minimal (Randlos)",
    ["opt_chat_skin_bg_alpha"]           = "Deckkraft des Rahmens",
    ["opt_chat_message_bg_alpha"]        = "Deckkraft des Nachrichtenbereichs",
    ["opt_chat_skin_font_size"]          = "Chat-Schriftgröße",
    ["opt_chat_skin_fade"]               = "Fade chat when inactive",
    ["opt_chat_skin_short_channels"]     = "Short channel names (G, P, R…)",
    ["opt_chat_skin_timestamp"]          = "Show timestamps",
    ["opt_chat_skin_url"]                = "Clickable URLs",
    ["opt_chat_skin_emoji"]              = "Replace text emoticons with emoji",
    ["opt_chat_skin_class_colors"]       = "Class-color player names in chat",
    ["opt_chat_copy_button"]             = "Kopier-Schaltfläche am Chatfenster",
    ["opt_chat_copy_button_always"]      = "Immer sichtbar",
    ["opt_chat_copy_button_hover"]       = "Beim Überfahren",
    ["opt_chat_copy_button_hidden"]      = "Ausgeblendet",
    ["chat_copy_title"]                  = "Chattext kopieren",
    ["chat_copy_hint"]                   = "Alles markieren (Strg+A), dann kopieren (Strg+C)",
    ["chat_copy_select_all"]             = "Alles markieren",
    ["chat_copy_close"]                  = "Schließen",
    ["chat_copy_empty"]                  = "Keine kopierbaren Nachrichten in diesem Fenster.",
    ["chat_copy_url_title"]              = "Strg+C zum Kopieren drücken",
    ["opt_chat_skin_history"]               = "Chatverlauf beim Anmelden wiederherstellen",
    ["chat_history_section"]                = "Chatverlauf",
    ["opt_chat_skin_history_info"]          = "Deaktivieren stoppt die Aufzeichnung UND löscht das bereits Gespeicherte. Der Verlauf wird accountweit gespeichert und daher von allen Charakteren geteilt.",
    ["opt_chat_history_max_age"]            = "Nachrichten aufbewahren für",
    ["opt_chat_history_age_1h"]             = "1 Stunde",
    ["opt_chat_history_age_6h"]             = "6 Stunden",
    ["opt_chat_history_age_24h"]            = "24 Stunden",
    ["opt_chat_history_age_3d"]             = "3 Tage",
    ["opt_chat_history_age_unlimited"]      = "Keine Grenze",
    ["opt_chat_history_max_lines"]          = "Maximal gespeicherte Zeilen",
    ["opt_chat_history_delay"]              = "Verzögerung vor Wiederherstellung",
    ["opt_chat_history_delay_info"]         = "Ein paar Sekunden Wartezeit lassen Addon-Ladehinweise und Lua-Fehler zuerst erscheinen, statt sie unter dem Verlauf zu begraben.",
    ["opt_chat_history_separator"]          = "Sitzungsmarkierung anzeigen",
    ["opt_chat_history_separator_info"]     = "Zeigt nach dem wiederhergestellten Verlauf eine Trennlinie: alles darunter stammt eindeutig aus der aktuellen Sitzung.",
    ["chat_history_separator_text"]         = "Aktuelle Sitzung",
    ["sublabel_chat_history_channels"]      = "Wiederherzustellende Kanäle",
    ["opt_chat_history_ch_whisper"]         = "Flüstern",
    ["opt_chat_history_ch_guild"]           = "Gilde",
    ["opt_chat_history_ch_officer"]         = "Offizier",
    ["opt_chat_history_ch_party"]           = "Gruppe",
    ["opt_chat_history_ch_raid"]            = "Schlachtzug",
    ["opt_chat_history_ch_instance"]        = "Instanz",
    ["opt_chat_history_ch_channel"]         = "Kanäle",
    ["opt_chat_history_ch_say"]             = "Sagen",
    ["opt_chat_history_ch_yell"]            = "Rufen",
    ["opt_chat_history_ch_emote"]           = "Emotes",
    ["btn_chat_history_clear"]              = "Chatverlauf jetzt löschen",
    ["popup_chat_history_clear"]            = "Alle gespeicherten Chatnachrichten löschen? Das lässt sich nicht rückgängig machen.",
    ["msg_chat_history_cleared"]            = "Chatverlauf gelöscht (%d Nachricht(en)).",
    ["opt_chat_skin_copy_lines"]         = "Show copy icon per message",

    -- Buff Skin
    ["sublabel_buff_skin"]               = "— Buff-/Debuff-Skin —",

    -- Game Menu Skin
    ["sublabel_game_menu_skin"]          = "— Spielmenü (Escape) —",
    ["opt_game_menu_skin_enable"]        = "Spielmenü skinnen",
    ["info_game_menu_skin_reload"]       = "Ein /reload ist nötig, um den Skin rückgängig zu machen.",
    ["msg_chat_skin_enabled"]            = "Chat-Skin aktiviert",
    ["msg_chat_skin_disabled"]           = "Chat-Skin deaktiviert (Reload zum Zurücksetzen)",
    ["sublabel_mail_skin"]               = "— Postfenster —",
    ["opt_mail_skin_enable"]             = "Postfenster-Skin",
    ["msg_mail_skin_enabled"]            = "Post-Skin aktiviert",
    ["msg_mail_skin_disabled"]           = "Post-Skin deaktiviert (Reload zum Zurücksetzen)",

    -- =====================
    -- WORLD QUEST TAB
    -- =====================
    ["tab_qol_world_quests"]             = "Weltquests",
    ["section_wq_tab"]                   = "Weltquest-Tab",
    ["info_wq_tab_desc"]                 = "Fügt dem Questtagebuch einen eigenen Weltquest-Tab mit Suche, Sortierung, Belohnungen, Zone und Restzeit hinzu. Klicke auf eine Quest, um sie zu verfolgen und auf der Karte anzuzeigen.",
    ["opt_wq_enable"]                    = "Weltquest-Tab aktivieren",
    ["opt_wq_auto_show"]                 = "Diesen Tab standardmäßig mit dem Questtagebuch öffnen",
    ["opt_wq_max_quests"]                = "Max. angezeigte Quests (0 = unbegrenzt)",
    ["opt_wq_min_time"]                  = "Min. verbleibende Zeit (Minuten, 0 = alle)",
    ["section_wq_filters"]               = "Belohnungsfilter",
    ["opt_wq_filter_gold"]               = "Goldbelohnungen anzeigen",
    ["opt_wq_filter_gear"]               = "Ausrüstungsbelohnungen anzeigen",
    ["opt_wq_filter_rep"]                = "Rufbelohnungen anzeigen",
    ["opt_wq_filter_currency"]           = "Währungsbelohnungen anzeigen",
    ["opt_wq_filter_anima"]              = "Animabelohnungen anzeigen",
    ["opt_wq_filter_pet"]                = "Haustierbelohnungen anzeigen",
    ["opt_wq_filter_other"]              = "Sonstige Belohnungen anzeigen",
    ["wq_tab_title"]                     = "WQ Liste",
    ["wq_panel_title"]                   = "Weltquests",
    ["wq_col_name"]                      = "Name",
    ["wq_col_zone"]                      = "Zone",
    ["wq_col_reward"]                    = "Belohnung",
    ["wq_col_time"]                      = "Zeit",
    ["wq_zone"]                          = "Zone",
    ["wq_faction"]                       = "Fraktion",
    ["wq_reward"]                        = "Belohnung",
    ["wq_time_left"]                     = "Verbleibende Zeit",
    ["wq_elite"]                         = "Elite-Weltquest",
    ["wq_sort_time"]                     = "Zeit",
    ["wq_sort_zone"]                     = "Zone",
    ["wq_sort_name"]                     = "Name",
    ["wq_sort_reward"]                   = "Belohnung",
    ["wq_sort_faction"]                  = "Fraktion",
    ["wq_status_count"]                  = "Zeige %d / %d Quests",
    ["wq_empty"]                         = "Keine Weltquest entspricht diesen Filtern.",
    ["wq_expired"]                       = "Abgelaufen",
    ["wq_click_hint"]                    = "Klicken: verfolgen und auf der Karte zeigen",
    ["wq_refresh_short"]                 = "A",
    ["wq_reward_gear"]                   = "Ausrüstung",
    ["wq_reward_reputation"]             = "Ruf",
    ["wq_reward_pet"]                    = "Haustier",
    ["wq_reward_other"]                  = "Andere",

    -- Profession Helper
    ["tab_qol_prof_helper"]              = "Berufe",
    ["section_prof_helper"]              = "Berufshelfer",
    ["info_prof_helper_desc"]            = "Entzaubern, Mahlen und Sondieren von Gegenständen im Stapel mit einer visuellen Oberfläche.",
    ["opt_prof_helper_enable"]           = "Berufshelfer aktivieren",
    ["sublabel_prof_de_filters"]         = "— Entzauber-Qualitätsfilter —",
    ["opt_prof_filter_green"]            = "Ungewöhnliche (Grüne) einschließen",
    ["opt_prof_filter_blue"]             = "Seltene (Blaue) einschließen",
    ["opt_prof_filter_epic"]             = "Epische (Lila) einschließen",
    ["btn_prof_open_helper"]             = "Berufshelfer öffnen",
    ["ph_title"]                         = "Berufshelfer",
    ["ph_tab_disenchant"]                = "Entzaubern",
    ["ph_filter_quality"]                = "Qualität:",
    ["ph_quality_green"]                 = "Grün",
    ["ph_quality_blue"]                  = "Blau",
    ["ph_quality_epic"]                  = "Episch",
    ["ph_select_all"]                    = "Alle auswählen",
    ["ph_deselect_all"]                  = "Alle abwählen",
    ["ph_btn_process"]                   = "Verarbeiten",
    ["ph_btn_click_process"]             = "Klicken zum Verarbeiten",
    ["ph_btn_stop"]                      = "Stopp",
    ["ph_status_idle"]                   = "Klicke auf Verarbeiten",
    ["ph_status_processing"]             = "Verarbeite %d/%d: %s",
    ["ph_status_done"]                   = "Fertig! Alle Gegenstände verarbeitet.",
    ["ph_item_count"]                    = "%d Gegenstände verfügbar",
    ["ph_ilvl"]                          = "iLvl %d",

    -- ── Class Reminder ──────────────────────────────────────────
    ["tab_qol_class_reminder"]           = "Klassenerinnerung",
    ["section_class_reminder"]           = "Klassen-Buff / Form-Erinnerung",
    ["info_class_reminder"]              = "Zeigt ein Symbol für jeden fehlenden Klassenbuff, jede Gestalt, Haltung oder Aura. Linksklick wirkt den Zauber, Mittelklick blendet ihn bis zum nächsten Ladebildschirm aus.",
    ["opt_class_reminder_enable"]        = "Klassenerinnerung aktivieren",
    ["opt_class_reminder_scale"]         = "Skalierung der Reihe",
    ["opt_class_reminder_color"]         = "Beschriftungsfarbe",
    ["sublabel_class_reminder_pos"]      = "— Position —",
    ["info_class_reminder_clicks"]       = "Linksklick wirkt den fehlenden Zauber (nur außerhalb des Kampfes). Mittelklick blendet diese Erinnerung bis zum nächsten Ladebildschirm aus.",
    ["info_class_reminder_mover"]        = "Verschiebe die Symbolreihe über das Verschieben-Panel oder setze sie zurück in die Bildschirmmitte.",
    ["sublabel_class_reminder_icons"]    = "— Symbole —",
    ["opt_class_reminder_icon_size"]     = "Symbolgröße",
    ["opt_class_reminder_spacing"]       = "Symbolabstand",
    ["opt_class_reminder_opacity"]       = "Deckkraft",
    ["sublabel_class_reminder_text"]     = "— Beschriftung —",
    ["opt_class_reminder_show_text"]     = "Beschriftung unter Symbolen anzeigen",
    ["opt_class_reminder_text_size"]     = "Schriftgröße",
    ["sublabel_class_reminder_glow"]     = "— Leuchteffekt —",
    ["opt_class_reminder_glow"]          = "Leuchttyp",
    ["opt_class_reminder_glow_color"]    = "Leuchtfarbe",
    ["cr_glow_none"]                     = "Keiner",
    ["cr_glow_pixel"]                    = "Pixel-Leuchten",
    ["cr_glow_autocast"]                 = "Autocast-Glanz",
    ["cr_glow_button"]                   = "Aktionsleisten-Leuchten",
    ["cr_glow_proc"]                     = "Proc-Leuchten",
    ["info_class_reminder_preview_hint"] = "Klicke ein Symbol an, um zu seinem Schalter zu springen, die Beschriftung für die Beschriftungsoptionen oder die leere Fläche für die Größe.",
    ["info_class_reminder_coverage"]     = "Entferne den Haken bei allem, woran du nicht erinnert werden willst. Im Spiel wird nur deine eigene Klasse geprüft.",
    ["cr_lethal_poison"]                 = "Tödliches Gift",
    ["cr_nonlethal_poison"]              = "Nicht tödliches Gift",
    ["cr_flametongue"]                   = "Waffe der Flammenzunge",
    ["cr_windfury"]                      = "Windzornwaffe",
    ["cr_earthliving"]                   = "Erdlebenwaffe",
    ["cr_tidecaller"]                    = "Wache des Flutenrufers",
    ["cr_thunderstrike"]                 = "Donnerschlagschutz",
    ["cr_earth_shield_self"]             = "Erdschild (selbst)",
    ["cr_orbit_shield"]                  = "Blitz-/Wasserschild",
    ["cr_shield"]                        = "Schild",
    ["cr_paladin_rite"]                  = "Ritus",
    ["sublabel_class_reminder_context"]  = "— Kontext —",
    ["opt_class_reminder_show_in"]       = "Erinnerungen anzeigen",
    ["cr_show_always"]                   = "Überall",
    ["cr_show_instances"]                = "Nur in Dungeons und Schlachtzügen",
    ["cr_show_group"]                    = "Nur in einer Gruppe",
    ["opt_class_reminder_hide_resting"]  = "In Städten und Gasthäusern ausblenden",
    ["opt_class_reminder_others_missing"] = "Auch erinnern, wenn einem Gruppenmitglied ein Buff fehlt",
    ["info_class_reminder_others"]       = "Es zählen nur Mitglieder in Reichweite, die vom Buff profitieren, und nur außerhalb des Kampfes: die Auren anderer Spieler sind im Kampf nicht lesbar.",

    -- Buff / Form names
    ["cr_fortitude"]                     = "Machtwort: Seelenstärke",
    ["cr_shadowform"]                    = "Schattengestalt",
    ["cr_arcane_intellect"]              = "Arkane Intelligenz",
    ["cr_skyfury"]                       = "Himmelszorn",
    ["cr_mark_of_the_wild"]              = "Mal der Wildnis",
    ["cr_cat_form"]                      = "Katzengestalt",
    ["cr_bear_form"]                     = "Bärengestalt",
    ["cr_moonkin_form"]                  = "Mondkingestalt",
    ["cr_battle_shout"]                  = "Schlachtruf",
    ["cr_battle_stance"]                 = "Kampfhaltung",
    ["cr_berserker_stance"]              = "Berserkerhaltung",
    ["cr_defensive_stance"]              = "Verteidigungshaltung",
    ["cr_aura"]                          = "Aura",
    ["cr_blessing_bronze"]               = "Segen der Bronze",
    ["cr_preview_sample"]                = "Beispiel: fehlender Klassenbuff",

    -- =====================
    -- MYTHIC TRACKER (TomoMythic integration)
    -- =====================
    ["tmt_cmd_usage"]               = "|cFF55B400/tmt|r : Einstellungen  |  |cFF55B400unlock|r : verschieben  |  |cFF55B400lock|r : sperren  |  |cFF55B400reset|r : Position zurücksetzen  |  |cFF55B400preview|r : Vorschau  |  |cFF55B400key|r : Gruppenschlüssel  |  |cFF55B400kr|r : Roulette  |  |cFF55B400keysync|r : Synchronisationsdiagnose",
    ["tmt_unlock_msg"]              = "|cffffd100TomoModForever|r M+ Tracker: Rahmen entsperrt \226\128\148 ziehen zum Verschieben.",
    ["tmt_lock_msg"]                = "|cffffd100TomoModForever|r M+ Tracker: Rahmen gesperrt.",
    ["tmt_reset_msg"]               = "|cffffd100TomoModForever|r M+ Tracker: Position zurückgesetzt.",
    ["tmt_unknown_cmd"]             = "|cffffd100TomoModForever|r M+ Tracker: Unbekannter Befehl.",
    ["tmt_key_level"]               = "+%d",
    ["tmt_dungeon_unknown"]         = "Mythisch+",
    ["tmt_overtime"]                = "ÜBERZOGEN",
    ["tmt_completed_on_time"]       = "ABGESCHLOSSEN",
    ["tmt_completed_depleted"]      = "GESCHEITERT",
    ["tmt_forces"]                  = "KRÄFTE",
    ["tmt_forces_done"]             = "KOMPLETT",
    ["tmt_forces_pct"]              = "%.1f%%",
    ["tmt_forces_count"]            = "%d / %d",
    ["tmt_forces_remaining"]        = "%d übrig",
    ["tmt_deaths"]                  = "Tode",
    ["tmt_time_lost"]               = "Verlorene Zeit: %s",
    ["tmt_cfg_preset"]              = "Stil",
    ["tmt_cfg_preset_panel"]        = "Panel",
    ["tmt_cfg_preset_hud"]          = "HUD",
    ["tmt_cfg_show_background"]     = "Panel-Hintergrund",
    ["tmt_cfg_show_header"]         = "Kopfzeilenblock",
    ["tmt_cfg_show_dungeon"]        = "Dungeonname",
    ["tmt_cfg_objective_style"]     = "Bossliste",
    ["tmt_cfg_objective_rows"]      = "Zeilen",
    ["tmt_cfg_objective_text"]      = "Text",
    ["tmt_cfg_font_scale"]          = "Schriftgröße",
    ["tmt_cfg_preset_minimal"]        = "Minimal",
    ["tmt_cfg_objective_none"]        = "Ausgeblendet",
    ["tmt_cfg_timer_layout"]          = "Timer-Layout",
    ["tmt_cfg_timer_stacked"]         = "Zwei Zeilen",
    ["tmt_cfg_timer_inline"]          = "Eine Zeile",
    ["tmt_cfg_segment_colors"]        = "Segmentfarben",
    ["tmt_cfg_segment_palier"]        = "Pro Stufe",
    ["tmt_cfg_segment_brand"]         = "Marke",
    ["tmt_cfg_splits"]                = "Mit Bestzeit vergleichen",
    ["tmt_cfg_checkpoints"]           = "Gegner-Checkpoints",
    ["tmt_cfg_clear_splits"]          = "Aufgezeichnete Zeiten l\195\182schen",
    ["tmt_splits_cleared"]            = "|cffffd100TomoModForever|r M+ Tracker: Aufgezeichnete Zeiten gel\195\182scht.",
    ["tmt_cds_reload_text"]           = "Cooldown Studio bleibt geladen, bis die Oberfl\195\164che neu geladen wird. Jetzt neu laden gibt es frei und beseitigt den Taint dieser Sitzung.",
    ["tmt_cds_reload_now"]            = "Neu laden",
    ["tmt_cds_reload_later"]          = "Sp\195\164ter",
    ["tmt_cfg_cds_safety_reload"]     = "Oberfl\195\164che nach dem Schlie\195\159en des Studios neu laden",
    ["tmt_cfg_title"]               = "Mythic",
    ["tmt_cfg_panel_enable"]         = "M+ Tracker aktivieren",
    ["tmt_cfg_show_timer"]          = "Timerleiste anzeigen",
    ["tmt_cfg_show_forces"]         = "Feindkräfte anzeigen",
    ["tmt_cfg_show_bosses"]         = "Boss-Timer anzeigen",
    ["tmt_cfg_hide_blizzard"]       = "Blizzard-Tracker ausblenden",
    ["tmt_cfg_lock"]                = "Rahmen sperren",
    ["tmt_cfg_scale"]               = "Skalierung",
    ["tmt_cfg_alpha"]               = "Hintergrundtransparenz",
    ["tmt_cfg_reset_pos"]           = "Position zurücksetzen",
    ["tmt_cfg_preview"]             = "Vorschau",
    ["tmt_cfg_section_display"]     = "Anzeige",
    ["tmt_cfg_section_frame"]       = "Rahmen",
    ["tmt_cfg_section_actions"]     = "Aktionen",
    ["tmt_key_not_available"]       = "nicht verfügbar.",
    ["tmt_key_not_in_group"]        = "Du bist in keiner Gruppe.",
    ["tmt_key_none_found"]          = "Keine Schlüsselsteine gefunden.",
    ["tmt_kr_spin"]                 = "|TInterface\\Icons\\INV_Misc_Dice_02:14|t  Drehen!",
    ["tmt_preview_active"]          = "|cffffd100TomoModForever|r M+ Tracker: Vorschau aktiv \226\128\148 |cFF55B400/tmt lock|r zum Sperren.",

    -- MythicHub
    ["mhub_title"]                  = "Mythisch+ Wertung",
    ["mhub_col_dungeon"]            = "Dungeon",
    ["mhub_col_level"]              = "Stufe",
    ["mhub_col_rating"]             = "Wertung",
    ["mhub_col_best"]               = "Beste",
    ["mhub_tp_click"]               = "Klicke zum Teleportieren",
    ["mhub_tp_not_available"]        = "Teleport nicht gelernt",
    ["mhub_tp_not_learned"]          = "|cffffd100TomoModForever|r: Teleportzauber nicht gelernt.",
    ["mhub_vault_title"]            = "Die Gro\195\159e Schatzkammer",
    ["mhub_vault_dungeons"]         = "Dungeons",
    ["mhub_vault_raids"]            = "Schlachtz\195\188ge",
    ["mhub_vault_world"]            = "Tiefen",
    ["mhub_vault_ilvl"]             = "Gegenstandsstufe",
    ["mhub_vault_locked"]           = "Gesperrt",
    ["mhub_vault_claim"]            = "Kehre zur Gro\195\159en Schatzkammer zur\195\188ck, um deine Belohnung abzuholen",

    -- ══════════════════════════════════════════════════════════
    -- INSTALLER
    -- ══════════════════════════════════════════════════════════

    -- Navigation
    ["ins_header_title"]             = "|cffffd100Tomo|r|cfff2ebdbMod|r |cffc9a252Forever|r  \226\128\148  Einrichtungsassistent",
    ["ins_step_counter"]             = "Schritt %d / %d",
    ["ins_btn_prev"]                 = "|TInterface\\BUTTONS\\UI-SpellbookIcon-PrevPage:0|t Zur\195\188ck",
    ["ins_btn_next"]                 = "Weiter |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t",
    ["ins_btn_finish"]               = "Fertig |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t",
    ["ins_btn_skip"]                 = "Installation \195\188berspringen",

    -- Step 1: Welcome
    ["ins_step1_title"]              = "Willkommen bei TomoMod",
    ["ins_subtitle"]                 = "Interface- & QOL-Suite f\195\188r The War Within",
    ["ins_welcome_desc"]             = "Dieser Assistent f\195\188hrt Sie in |cffffd10016 Schritten|r durch die Konfiguration von TomoMod:\nUnitFrames, Party Frames, Zauberleisten, Nameplates, Aktionsleisten,\nRessourcen, Skins, Sound, Mythic+, QOL, Optimierungen und SkyRide.\n\nAlle Optionen k\195\182nnen jederzeit \195\188ber |cffffd100/tm|r ge\195\164ndert werden.",

    -- Step 2: Profile
    ["ins_step2_title"]              = "Spielprofil",
    ["ins_profile_info"]             = "Erstelle ein benanntes Profil, um deine Konfiguration zu speichern.",
    ["ins_profile_section"]          = "Profilname",
    ["ins_profile_placeholder"]      = "Mein Profil",
    ["ins_profile_create"]           = "Profil erstellen",
    ["ins_profile_created"]          = "Profil erstellt: ",
    ["ins_spec_section"]             = "Spezialisierungszuweisung",
    ["ins_spec_info"]                = "Du kannst dieses Profil deinen Spezialisierungen im Profil-Panel (/tm) zuweisen.\nJede Spezialisierung kann eine andere Konfiguration verwenden.",

    -- Step 3: Visual Skins
    ["ins_step3_title"]              = "Visuelle Skins",
    ["ins_skins_info"]               = "Passe das Blizzard-UI mit dem dunklen Design von TomoMod an.",
    ["ins_skins_section"]            = "Verf\195\188gbare Skins",
    ["ins_skin_gamemenu"]            = "Spielmen\195\188-Skin (Escape-Men\195\188)",
    ["ins_skin_actionbar"]           = "Aktionsleisten-Button-Skin",
    ["ins_skin_chat"]                = "Chat-Fenster-Skin",
    ["ins_skin_character"]           = "Charakterbogen-Skin",
    ["ins_skin_style_section"]       = "Aktionsleisten-Button-Stil",
    ["ins_skin_style"]               = "Visueller Stil",

    -- Step 4: Tank Mode
    ["ins_step4_title"]              = "Tank-Modus",
    ["ins_tank_info"]                = "Im Tank-Modus zeigen Nameplates und UnitFrames\nden Bedrohungsstatus farblich f\195\188r jeden Gegner an.",
    ["ins_tank_np_section"]          = "Nameplates \226\128\148 Bedrohungsfarben",
    ["ins_tank_enable_np"]           = "Tank-Modus aktivieren (Nameplates)",
    ["ins_tank_colors_info"]         = "Gr\195\188n = Aggro gehalten  \194\183  Orange = kurz vor Verlust  \194\183  Rot = Aggro verloren",
    ["ins_tank_uf_section"]          = "UnitFrames \226\128\148 Bedrohungsanzeige",
    ["ins_tank_threat_indicator"]    = "Bedrohungsanzeige beim Ziel anzeigen",
    ["ins_tank_threat_text"]         = "Bedrohungs-% beim Ziel anzeigen",
    ["ins_tank_cotank_section"]      = "CoTank-Tracker",
    ["ins_tank_cotank_enable"]       = "Co-Tank-Verfolgung aktivieren",
    ["ins_tank_cotank_info"]         = "Zeigt die Bedrohung des zweiten Tanks in Instanzen an.",

    -- Step 5: Nameplates
    ["ins_step5_title"]              = "Nameplates",
    ["ins_np_general"]               = "Allgemein",
    ["ins_np_enable"]                = "TomoMod-Nameplates aktivieren",
    ["ins_np_reload_info"]           = "Ein Reload ist erforderlich, um Nameplates zu aktivieren/deaktivieren.",
    ["ins_np_display"]               = "Anzeige",
    ["ins_np_class_colors"]          = "Klassenfarben",
    ["ins_np_castbar"]               = "Zauberbalken anzeigen",
    ["ins_np_health_text"]           = "Gesundheitstext anzeigen (Prozent)",
    ["ins_np_auras"]                 = "Auren anzeigen (Debuffs)",
    ["ins_np_role_icons"]            = "Rollensymbole anzeigen (Dungeon)",
    ["ins_np_dimensions"]            = "Abmessungen",
    ["ins_np_width"]                 = "Breite",

    -- Step 6: Action Bars
    ["ins_step6_title"]              = "Aktionsleisten",
    ["ins_ab_system_section"]        = "Action Bar System",
    ["ins_ab_system_info"]           = "TomoMod replaces Blizzard's action bars with custom containers,\npositioning, fade system and display conditions.\nDisable this to fully restore the default Blizzard action bars.",
    ["ins_ab_system_enable"]         = "Enable TomoMod Action Bar system",
    ["ins_ab_system_reload_info"]    = "Requires a /reload to take effect.",
    ["ins_ab_skin_section"]          = "Button-Skin",
    ["ins_ab_enable"]                = "Skin auf Aktionsleisten-Buttons aktivieren",
    ["ins_ab_class_color"]           = "Randfarbe = Klassenfarbe",
    ["ins_ab_shift_reveal"]          = "Shift halten, um versteckte Leisten anzuzeigen",
    ["ins_ab_opacity_section"]       = "Globale Leistendeckkraft",
    ["ins_ab_opacity"]               = "Deckkraft",
    ["ins_ab_manage_section"]        = "Leistenverwaltung",
    ["ins_ab_manage_info"]           = "Verwende das Aktionsleisten-Panel (/tm |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Aktionsleisten |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Verwaltung),\num jede Leiste einzeln zu entsperren und zu verschieben.",

    -- Step 7: LustSound
    ["ins_step7_title"]              = "Sound \226\128\148 Heldentum / Kampfrausch",
    ["ins_sound_info"]               = "Spielt einen benutzerdefinierten Sound ab, wenn Heldentum oder\nKampfrausch von einem Gruppenmitglied gewirkt wird.",
    ["ins_sound_activation"]         = "Aktivierung",
    ["ins_sound_enable"]             = "Lust-Sound aktivieren",
    ["ins_sound_choice"]             = "Soundauswahl",
    ["ins_sound_sound"]              = "Sound",
    ["ins_sound_channel"]            = "Audiokanal",
    ["ins_sound_default"]            = "Standard",
    ["ins_sound_preview_section"]    = "Vorschau",
    ["ins_sound_preview_btn"]        = "|TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Vorschau",

    -- Step 8: Mythic+
    ["ins_step8_title"]              = "Mythic+ \226\128\148 Tracker & Rangliste",
    ["ins_mplus_tracker_section"]    = "M+ Tracker",
    ["ins_mplus_tracker_info"]       = "Zeigt Timer, Kr\195\164fte, Bosse und Fortschritt\ndeines Mythic+-Dungeons in Echtzeit an.",
    ["ins_mplus_tracker_enable"]     = "M+ Tracker aktivieren",
    ["ins_mplus_show_timer"]         = "Timer anzeigen",
    ["ins_mplus_show_forces"]        = "Kr\195\164fte anzeigen (%)",
    ["ins_mplus_hide_blizzard"]      = "Blizzard-UI in Mythic+ ausblenden",
    ["ins_mplus_score_section"]      = "TomoScore \226\128\148 Rangliste",
    ["ins_mplus_score_info"]         = "Zeigt pers\195\182nliche und Gruppenscores am Ende eines Mythic+ an.",
    ["ins_mplus_score_enable"]       = "TomoScore aktivieren",
    ["ins_mplus_score_auto"]         = "Automatisch in M+ anzeigen",

    -- Step 9: CVars
    ["ins_step9_title"]              = "Systemoptimierungen (CVars)",
    ["ins_cvar_info"]                = "TomoMod kann empfohlene WoW-CVars anwenden,\num Leistung und Reaktionsf\195\164higkeit zu verbessern.",
    ["ins_cvar_section"]             = "Enthaltene Optimierungen",
    ["ins_cvar_opt1"]                = "Unn\195\182tiges Level of Detail (LOD) reduzieren",
    ["ins_cvar_opt2"]                = "Frustum Culling optimieren",
    ["ins_cvar_opt3"]                = "\195\156berm\195\164\195\159iges Temporal AA deaktivieren",
    ["ins_cvar_opt4"]                = "Netzwerkreaktivit\195\164t verbessern",
    ["ins_cvar_opt5"]                = "Unn\195\182tige UI-Animationen deaktivieren",
    ["ins_cvar_opt6"]                = "Textur-Streaming optimieren",
    ["ins_cvar_success"]             = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t  CVars erfolgreich angewendet!",
    ["ins_cvar_apply_btn"]           = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0|t Alle CVars anwenden",
    ["ins_cvar_applied"]             = "Optimierte CVars angewendet.",

    -- Step 10: QOL
    ["ins_step10_title"]             = "Lebensqualit\195\164t (QOL)",
    ["ins_qol_info"]                 = "Aktiviere die QOL-Module, die du m\195\182chtest.\nAlle sind separat unter /tm |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t QOL erreichbar.",
    ["ins_qol_auto_section"]         = "Automatisierungen",
    ["ins_qol_auto_repair"]          = "Automatisch beim H\195\164ndler reparieren",
    ["ins_qol_fast_loot"]            = "Schnelles Looten (schnelle Gegenstandsaufnahme)",
    ["ins_qol_skip_cinematics"]      = "Bereits gesehene Zwischensequenzen \195\188berspringen",
    ["ins_qol_hide_talking_head"]    = "Talking Head ausblenden (Scrolldialoge)",
    ["ins_qol_auto_accept"]          = "Gruppeneinladungen automatisch annehmen (Freunde & Gilde)",
    ["ins_qol_tooltip_ids"]          = "IDs in Tooltips anzeigen (Spell-ID, Item-ID...)",
    ["ins_qol_combat_section"]       = "Kampf",
    ["ins_qol_combat_text"]          = "Benutzerdefinierter schwebender Kampftext",
    ["ins_qol_hide_castbar"]         = "Blizzard-Zauberbalken ausblenden (TomoMod verwenden)",

    -- Step 11: SkyRide
    ["ins_step11_title"]             = "SkyRide \226\128\148 Drachenreit-Leiste",
    ["ins_skyride_info"]             = "SkyRide zeigt eine Vigor-Leiste (6 Ladungen) und eine\nZweiter-Wind-Leiste (3 Ladungen) f\195\188r das Drachenreiten an.",
    ["ins_skyride_activation"]       = "Aktivierung",
    ["ins_skyride_enable"]           = "SkyRide-Leiste aktivieren",
    ["ins_skyride_auto_info"]        = "Die Leiste erscheint automatisch im Drachenreit-Modus\nund verschwindet au\195\159erhalb davon.",
    ["ins_skyride_dimensions"]       = "Abmessungen",
    ["ins_skyride_width"]            = "Breite",
    ["ins_skyride_height"]           = "H\195\182he",
    ["ins_skyride_reset_section"]    = "Position zur\195\188cksetzen",
    ["ins_skyride_reset_btn"]        = "Position zur\195\188cksetzen",

    -- Step 12: Done
    ["ins_step12_title"]             = "Einrichtung abgeschlossen!",
    ["ins_done_check"]               = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t  Alles bereit!",
    ["ins_done_recap"]               = "Deine TomoMod-Konfiguration ist gespeichert. Hier einige Hinweise:\n\n|cffffd100/tm|r              |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t  Konfigurationspanel \195\182ffnen\n|cffffd100/tm sr|r           |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t  Elemente entsperren und verschieben\n|cffffd100/tm install|r      |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t  Diesen Installer neu starten\n\nAlle hier konfigurierten Optionen k\195\182nnen jederzeit\n\195\188ber die entsprechenden Panels in der TomoMod-GUI ge\195\164ndert werden.\n\nEin |cffffd100UI-Reload|r ist erforderlich, um bestimmte \195\132nderungen anzuwenden\n(Nameplates, Skins, UnitFrames).",
    ["ins_done_reload"]              = "|TInterface\\BUTTONS\\UI-RefreshButton:0|t  UI neu laden",

    -- Step NEW: Unit Frames
    ["ins_uf_title"]                 = "Unit Frames",
    ["ins_uf_info"]                  = "TomoMod ersetzt die Standard-Blizzard-UnitFrames (Spieler, Ziel, Fokus, Begleiter)\nmit modernen, anpassbaren Frames.",
    ["ins_uf_section"]               = "Allgemein",
    ["ins_uf_enable"]                = "TomoMod UnitFrames aktivieren",
    ["ins_uf_hide_blizzard"]         = "Standard Blizzard-Frames ausblenden",
    ["ins_uf_reload_info"]           = "Ein Reload ist erforderlich, um \195\132nderungen an UnitFrames anzuwenden.",

    -- Step NEW: Party Frames
    ["ins_pf_title"]                 = "Party Frames",
    ["ins_pf_info"]                  = "Eigene Gruppenframes mit Rollensymbolen, Dispel-Hervorhebung\nund Cooldown-Verfolgung f\195\188r Gruppenspiel.",
    ["ins_pf_section"]               = "Allgemein",
    ["ins_pf_enable"]                = "TomoMod Party Frames aktivieren",
    ["ins_pf_hide_blizzard"]         = "Blizzard Party Frames ausblenden",
    ["ins_pf_cd_section"]            = "Cooldown-Tracker",
    ["ins_pf_cd_info"]               = "Verfolge die Interrupt- und Kampfrez-Cooldowns deiner\nGruppenmitglieder direkt auf ihren Frames.",
    ["ins_pf_show_interrupt"]        = "Interrupt-Cooldown-Tracker anzeigen",
    ["ins_pf_show_brez"]             = "Kampfrez-Cooldown-Tracker anzeigen",
    ["ins_pf_reload_info"]           = "Ein Reload ist erforderlich, um \195\132nderungen an Party Frames anzuwenden.",

    -- Step 5: Raid Frames
    ["ins_rf_title"]                 = "Raid Frames",
    ["ins_rf_info"]                  = "Custom raid frames for groups of 6-40 players.\nGrid or list layout with dispel highlights, HoT tracking, and debuff icons.",
    ["ins_rf_section"]               = "General",
    ["ins_rf_enable"]                = "Enable TomoMod raid frames",
    ["ins_rf_hide_blizzard"]         = "Hide Blizzard raid frames",
    ["ins_rf_features_section"]      = "Features",
    ["ins_rf_show_dispel"]           = "Dispel highlight (border glow by debuff type)",
    ["ins_rf_show_hots"]             = "HoT tracking (healer spell indicators)",
    ["ins_rf_show_debuffs"]          = "Show debuff icons on raid members",
    ["ins_rf_show_defensives"]       = "Show defensive cooldown icons",
    ["ins_rf_layout_section"]        = "Layout",
    ["ins_rf_layout"]                = "Raid layout mode",
    ["ins_rf_reload_info"]           = "A reload is required to apply changes to raid frames.",

    -- Step NEW: Castbars
    ["ins_cb_title"]                 = "Zauberleisten",
    ["ins_cb_info"]                  = "Eigene Zauberleisten f\195\188r Spieler, Ziel, Fokus und Begleiter\nmit Funken-Animation und Unterbrechungs-Feedback.",
    ["ins_cb_section"]               = "Allgemein",
    ["ins_cb_enable"]                = "TomoMod Zauberleisten aktivieren",
    ["ins_cb_hide_blizzard"]         = "Blizzard Standard-Zauberleiste ausblenden",
    ["ins_cb_class_color"]           = "Klassenfarbe f\195\188r Balken verwenden",
    ["ins_cb_reload_info"]           = "Ein Reload ist erforderlich, um \195\132nderungen an Zauberleisten anzuwenden.",

    -- Step NEW: Resource Bars & Cooldown Manager
    ["ins_res_title"]                = "Ressourcen & Cooldowns",
    ["ins_res_info"]                 = "Klassenmacht-Anzeige (Kombopunkte, Runen, Seelensplitter usw.)\nim Symbol- oder Balkenmodus.",
    ["ins_res_section"]              = "Ressourcenleisten",
    ["ins_res_enable"]               = "Ressourcenleisten aktivieren",
    ["ins_res_display"]              = "Anzeigemodus",
    ["ins_cdm_section"]              = "Cooldown-Manager",
    ["ins_cdm_info"]                 = "Cooldown-Spirale auf Aktionstasten mit\nkampfbewusstem Alpha und GCD-Filterung.",
    ["ins_cdm_enable"]               = "Cooldown-Manager aktivieren",
    ["ins_cdm_hide_gcd"]             = "GCD-Spirale ausblenden",
    ["ins_cdm_desat"]                = "Tasten bei Cooldown ents\195\164ttigen",

    -- Enhanced Skins
    ["ins_skin_bag"]                 = "Taschen-Skin",
    ["ins_skin_tooltip"]             = "Tooltip-Skin",
    ["ins_skin_objective"]           = "Objective Tracker skin (color-coded quest types)",
    ["ins_skin_mail"]                = "Mail skin",
    ["ins_skin_reputation"]          = "Reputation bar",

    -- Enhanced QOL
    ["ins_qol_interface_section"]    = "Oberfl\195\164che",
    ["ins_qol_minimap"]              = "Eigene Minimap (Rahmen & Skalierung)",
    ["ins_qol_cursor"]               = "Cursor-Ring-Hervorhebung",
    ["ins_qol_afk"]                  = "Eigener AFK-Bildschirm mit 3D-Modell",
    ["ins_qol_diag"]                 = "Diagnose (Fehlererfassung ohne Popups)",
    ["ins_qol_auto_summon"]          = "Auto-accept summons",
    ["ins_qol_auto_fill_delete"]     = "Auto-fill DELETE in destroy popups",
    ["ins_qol_auto_quest"]           = "Auto accept/turn in quests (Shift to override)",
    ["ins_qol_class_reminder"]       = "Class buff reminder (Fortitude, Intellect, etc.)",
    ["ins_qol_leveling_bar"]         = "Leveling bar (XP/hour, rested XP overlay)",
    ["ins_qol_waypoint"]             = "Waypoint navigation system",
    ["ins_qol_world_quest_tab"]      = "World Quest browser on World Map",
    ["ins_qol_frame_anchors"]        = "Movable frame anchors (Alert, Loot)",
    ["ins_qol_profession_helper"]    = "Profession Helper (batch disenchant)",

    -- =========== Config Panels — i18n ===========
    -- ActionBars panel
    ["opt_abs_style"]                = "Visueller Stil",
    ["section_bar_opacity"]          = "Deckkraft pro Leiste",
    ["opt_abs_bar_select"]           = "Leiste konfigurieren",
    ["opt_abs_opacity"]              = "Deckkraft",
    ["btn_abs_apply_all"]            = "Auf alle Leisten anwenden",
    ["opt_abs_combat_only_label"]    = "Nur im Kampf anzeigen:",
    ["opt_abs_combat_only"]          = "Leiste nur im Kampf sichtbar",
    ["section_bar_management"]       = "Aktionsleisten-Verwaltung",
    ["btn_abs_unlock"]               = "Leisten entsperren",
    ["info_abs_unlock"]              = "Entsperre die Leisten, um die Ziehgriffe anzuzeigen.\nRechtsklick auf einen Griff, um eine Leiste individuell zu konfigurieren.",
    ["section_bar_quick"]            = "Schnelleinstellungen",
    ["tab_abs_skin"]                 = "Button-Skin",
    ["tab_abs_bars"]                 = "Leisten-Verwaltung",
    ["info_abs_layout"]              = "Nutze den EditMode zum Verschieben der Leisten oder ziehe die Overlays.\nKlappe unten eine Leiste auf, um Buttongr\195\182\195\159e und Skalierung zu \195\164ndern.",
    -- General panel
    ["opt_gui_scale"]                = "Skalierung des Konfigurationsfensters",
    ["info_gui_scale"]               = "Skalierung des /tm-Fensters \226\128\148 es l\195\164sst sich auch durch Ziehen der unteren rechten Ecke in der Gr\195\182\195\159e \195\164ndern.",
    ["btn_gui_reset_size"]           = "Fenstergr\195\182\195\159e & Skalierung zur\195\188cksetzen",
    ["btn_relaunch_installer"]       = "Installer neu starten",
    ["info_relaunch_installer"]      = "Startet den 16-Schritte-Einrichtungsassistenten.",
    -- Sound panel
    ["section_sound_preview"]        = "Vorschau & Optionen",
    -- UFPreview
    ["preview_header"]               = "LIVE-VORSCHAU",
    ["preview_player"]               = "Spieler",
    ["preview_target_name"]          = "Taurache",
    ["preview_focus_name"]           = "Priestella",
    ["preview_pet_name"]             = "Wasserwolf",
    ["preview_tot_name"]             = "Ziel-des-Ziels",
    ["preview_cast_player"]          = "Frostblitz",
    ["preview_cast_target"]          = "Feuerball",
    ["preview_lbl_player"]           = "SPIELER",
    ["preview_lbl_target"]           = "ZIEL",
    ["preview_lbl_focus"]            = "FOKUS",
    ["preview_lbl_pet"]              = "PET",
    ["preview_lbl_tot"]              = "TOT",
    ["preview_click_nav"]            = "Klicken zum Navigieren",
    ["preview_click_isolate"]         = "Klicken zum Isolieren",
    ["preview_click_show_all"]        = "Klicken um alle anzuzeigen",
    ["preview_show_all"]              = "Alle anzeigen",
    ["preview_zoom_fit"]                = "Anpassen",
    ["preview_zoom_11"]                 = "1:1",
    ["preview_zoom_tip"]                = "Wechselt zwischen Anpassung an das Fenster und echter 1:1-Gr\195\182\195\159e.",
    ["preview_all_disabled"]            = "Alle Einheitenfenster sind deaktiviert.",
    ["preview_engine_missing"]          = "UnitFrames-Engine nicht geladen.",
    ["preview_data_live"]               = "Echtdaten",
    ["preview_data_mock"]               = "Simuliert",
    ["preview_data_tip"]                = "Speist die Vorschau mit echten Einheitendaten, sofern die Einheit existiert, sonst mit simulierten Werten.",
    ["preview_tag_live"]                = "ECHT",
    ["preview_tag_sim"]                 = "SIM",
    -- ConfigUI footer
    ["ui_footer_hint"]               = "/tm  \194\183  /tm sr zum Verschieben der Elemente",

    -- =====================
    -- SKINS CATEGORY (top-level)
    -- =====================
    ["cat_skins"]                        = "Skins",

    -- Chat Frame V2 — Reiter-Bezeichnungen & UI
    ["chatv2_tab_general"]               = "Allgemein",
    ["chatv2_tab_instance"]              = "Instanz",
    ["chatv2_tab_chucho"]                = "Chucho",
    ["chatv2_tab_personnel"]             = "Pers\195\182nlich",
    ["chatv2_tab_combat"]                = "Kampf",
    ["chatv2_sidebar_title"]             = "CHAT",
    ["chatv2_expand_btn"]                = "Chat",
    ["chatv2_mover_label"]               = "Chatfenster V2",
    ["chatv2_input_hint"]                = "Enter zum Tippen...",

    -- Skins > Chat Frame tab
    ["tab_skin_chatframe"]               = "Chatfenster",
    ["section_skin_chatframe"]           = "Chatfenster-Skin",
    ["info_skin_chatframe_desc"]         = "Chat-Panel mit Seitenleiste \226\128\148 Allgemein, Instanz, Chucho, Pers\195\182nlich, Kampf \226\128\148 mit Abzeichen f\195\188r ungelesene Nachrichten.",
    ["opt_skin_chatframe_enable"]        = "Chatfenster-Skin aktivieren",
    ["opt_skin_chatframe_width"]         = "Breite",
    ["opt_skin_chatframe_height"]        = "H\195\182he",
    ["opt_skin_chatframe_scale"]         = "Skalierung %",
    ["opt_skin_chatframe_opacity"]       = "Hintergrund-Transparenz",
    ["opt_skin_chatframe_font_size"]     = "Schriftgr\195\182\195\159e",
    ["opt_skin_chatframe_timestamp"]     = "Zeitstempel anzeigen",

    -- Skins > Bags tab
    -- Taschen — Entzauberung
    ["bagskin_currencies_none"]          = "Keine verfolgten W\195\164hrungen (Rechtsklick auf W\195\164hrung \226\134\146 In Rucksack anzeigen)",
    ["tab_skin_bags"]                    = "Taschen",
    ["section_skin_bags"]                = "Taschen-Skin",
    ["info_skin_bags_desc"]              = "Kategoriebasiertes Taschenraster inspiriert von BetterBags. Gegenst\195\164nde in einklappbare Abschnitte mit Qualit\195\164tsrahmen, Suche, Abklingzeiten und Gegenstandslevel-Abzeichen.",
    ["opt_skin_bags_enable"]             = "Taschen-Skin aktivieren",
    ["opt_skin_bags_stack_merge"]        = "Identische Stapel zusammenf\195\188hren",
    ["opt_skin_bags_show_empty"]         = "Freie Pl\195\164tze anzeigen",
    ["opt_skin_bags_show_recent"]        = "Neue Gegenst\195\164nde anzeigen",
    ["opt_skin_bags_columns"]            = "Spalten",
    ["opt_skin_bags_slot_size"]          = "Platzgr\195\182\195\159e",
    ["opt_skin_bags_slot_spacing"]       = "Platzabstand",
    ["opt_skin_bags_scale"]              = "Skalierung %",
    ["opt_skin_bags_opacity"]            = "Hintergrund-Transparenz",
    ["opt_skin_bags_quality_borders"]    = "Qualit\195\164tsrahmen anzeigen",
    ["bags_v4_quality_style"]            = "Gegenstandsqualität",
    ["bags_v4_quality_tint"]             = "Getöntes Feld",
    ["bags_v4_quality_border"]           = "Farbiger Rahmen",
    ["bags_v4_quality_both"]             = "Beides",
    ["bags_v4_quality_none"]             = "Keine",
    ["opt_skin_bags_cooldowns"]          = "Abklingzeiten anzeigen",
    ["opt_skin_bags_quantity"]           = "Mengenabzeichen anzeigen",
    ["opt_skin_bags_search"]             = "Suchleiste anzeigen",
    ["opt_skin_bags_sort_mode"]          = "Sortiermodus",
    ["opt_skin_bags_sort_quality"]       = "Qualit\195\164t",
    ["opt_skin_bags_sort_name"]          = "Name",
    ["opt_skin_bags_sort_type"]          = "Typ",
    ["opt_skin_bags_sort_ilvl"]          = "Gegenstandslevel",
    ["opt_skin_bags_sort_recent"]        = "Neueste",
    ["opt_skin_bags_show_gold"]          = "Gold anzeigen (Fu\195\159zeile)",
    ["opt_skin_bags_show_currencies"]    = "Verfolgte W\195\164hrungen anzeigen (Fu\195\159zeile)",

    -- Skins > Objective Tracker tab
    ["tab_skin_objtracker"]              = "Zieltracker",

    -- Skins > Character tab
    ["tab_skin_character"]               = "Charakter",

    -- Skins > Buffs tab

    -- Skins > Game Menu tab
    ["tab_skin_gamemenu"]                = "Spielmen\195\188",

    -- Skins > Mail tab
    ["tab_skin_mail"]                    = "Post",

    -- =====================
    -- WEGPUNKT-MODUL (/tm way)
    -- =====================
    -- GUI
    ["tab_qol_waypoint"]                  = "Wegpunkt",
    ["section_waypoint"]                  = "Wegpunkt",
    ["opt_way_zone_only"]                 = "Nur in der aktuellen Zone anzeigen",
    ["opt_way_size"]                      = "Gr\195\182\195\159e des Leuchtfeuers",
    ["opt_way_shape"]                     = "Form",
    ["way_shape_ring"]                    = "Ring",
    ["way_shape_arrow"]                   = "Pfeil",
    ["opt_way_color"]                     = "Wegpunkt-Farbe",
    -- Slash
    ["msg_help_way"]                     = "Wegpunkt an aktueller Position setzen",
    ["msg_help_way_coords"]              = "Wegpunkt bei Koordinaten (x, y) setzen",
    ["msg_help_way_clear"]               = "Aktiven Wegpunkt entfernen",
    ["way_cleared"]                      = "Wegpunkt entfernt.",
    ["way_set"]                          = "Wegpunkt gesetzt auf %s%s.",
    ["way_here"]                         = "Wegpunkt an aktueller Position gesetzt.",
    ["way_no_map"]                       = "Aktuelle Karte konnte nicht ermittelt werden.",
    ["way_no_pos"]                       = "Spielerposition konnte nicht ermittelt werden.",
    ["way_bad_map"]                      = "Auf dieser Karte kann kein Wegpunkt gesetzt werden.",
    ["way_bad_coords"]                   = "Koordinaten m\195\188ssen zwischen 0 und 100 liegen.",
    ["way_usage"]                        = "Verwendung: /tm way [MapID] x y [Name]  |  /tm way clear",

    -- =====================
    -- Resource names
    -- =====================
    ["res_mana"]                        = "Mana (Druide)",
    ["res_soul_shards"]                 = "Seelensplitter",
    ["res_holy_power"]                  = "Heilige Kraft",
    ["res_chi"]                         = "Chi",
    ["res_combo_points"]                = "Kombopunkte",
    ["res_charged_combo_points"]        = "Aufgeladene Kombopunkte",
    ["res_arcane_charges"]              = "Arkane Aufladungen",
    ["res_essence"]                     = "Essenz",
    ["res_stagger"]                     = "Staffelung",
    ["res_soul_fragments"]              = "Seelenfragmente",
    ["res_tip_of_spear"]                = "Spitze des Speers",
    ["res_maelstrom_weapon"]            = "Mahlstromwaffe",
    ["res_icicles"]                      = "Eiszapfen",

    -- =====================
    -- Resource Bars display mode
    -- =====================
    ["opt_rb_display_mode"]             = "Anzeigemodus",
    ["display_mode_icons"]              = "Symbole (TUI-Texturen)",
    ["display_mode_bars"]               = "Leisten (flache Farben)",

    -- =====================
    -- Tooltip Skin
    -- =====================
    ["tab_skin_tooltip"]                 = "Tooltip",
    ["section_tooltip_skin"]             = "Tooltip-Skin",
    ["opt_tooltip_skin_enable"]          = "Tooltip-Skin aktivieren",
    ["info_tooltip_skin_reload"]         = "Einige Änderungen erfordern das Überfahren eines neuen Ziels.",
    ["opt_tooltip_bg_alpha"]             = "Hintergrund-Deckkraft",
    ["opt_tooltip_border_alpha"]         = "Rahmen-Deckkraft",
    ["opt_tooltip_bg_color"]              = "Hintergrundfarbe",
    ["opt_tooltip_border_color"]          = "Rahmenfarbe",
    ["opt_tooltip_font_size"]             = "Schriftgröße",
    ["opt_tooltip_hide_healthbar"]       = "Lebensleiste ausblenden",
    ["opt_tooltip_class_color"]          = "Klassenfarbige Spielernamen",
    ["opt_tooltip_hide_server"]          = "Server in Spielernamen ausblenden",
    ["opt_tooltip_hide_title"]           = "Titel in Spielernamen ausblenden",
    ["opt_tooltip_guild_color"]          = "Benutzerdefinierte Gildennamenfarbe",
    ["opt_tooltip_guild_color_pick"]     = "Gildennamenfarbe",
    ["sublabel_tooltip_info"]            = "— Einheitsinformationen —",
    ["opt_tooltip_unit_info"]            = "Einheitsinformationen anzeigen",
    ["info_tooltip_unit_info"]           = "Fügt Gildenrang, Ziel, M+-Wertung und mehr zu Einheits-Tooltips hinzu.",
    ["opt_tooltip_reaction_border"]      = "Rahmen nach Reaktion / Klasse färben",
    ["opt_tooltip_color_level"]          = "Stufe nach Schwierigkeit färben",
    ["opt_tooltip_raid_marker"]          = "Schlachtzugssymbol anzeigen",
    ["opt_tooltip_role_icon"]            = "Rollensymbol anzeigen",
    ["opt_tooltip_class_icon"]           = "Klassensymbol anzeigen",
    ["opt_tooltip_icon_size"]            = "Symbolgröße",
    ["opt_tooltip_guild_rank"]           = "Gildenrang anzeigen",
    ["opt_tooltip_guild_rank_index"]     = "Gildenrangnummer anzeigen",
    ["opt_tooltip_guild_realm"]          = "Gildenrealm anzeigen",
    ["opt_tooltip_show_target"]          = "Ziel der Einheit anzeigen",
    ["opt_tooltip_mythic_score"]         = "M+-Wertung anzeigen",
    ["opt_tooltip_mount"]                = "Reittier anzeigen",
    ["opt_tooltip_speed"]                = "Bewegungstempo anzeigen",
    ["opt_tooltip_location"]             = "Ort anzeigen",
    ["info_tooltip_location"]            = "Der Ort ist nur für dich und deine Gruppenmitglieder verfügbar.",
    ["tt_guild_rank"]                    = "Rang",
    ["tt_target"]                        = "Ziel",
    ["tt_target_you"]                    = "Du",
    ["tt_mythic_score"]                  = "M+-Wertung",
    ["tt_speed"]                         = "Tempo",
    ["tt_mount"]                         = "Reittier",
    ["tt_location"]                      = "Ort",
    ["sublabel_tooltip_inspect"]         = "— Untersuchen —",
    ["opt_tooltip_item_level"]           = "Gegenstandsstufe anzeigen",
    ["opt_tooltip_spec"]                 = "Spezialisierung anzeigen",
    ["opt_tooltip_spec_icon"]            = "Spezialisierungssymbol anzeigen",
    ["opt_tooltip_pending_text"]         = "Platzhalter beim Laden anzeigen",
    ["info_tooltip_inspect"]             = "Gegenstandsstufe und Spezialisierung erfordern das Untersuchen des Spielers und erscheinen nur in Reichweite.",
    ["tt_item_level"]                    = "Gegenstandsstufe",
    ["tt_spec"]                          = "Spezialisierung",
    ["tt_loading"]                       = "...",

    -- =====================
    -- Bag Skin extras
    -- =====================
    ["opt_skin_bags_show_ilvl"]          = "Gegenstandsstufe auf Ausrüstung anzeigen",
    ["opt_skin_bags_show_junk_icon"]     = "Trödel-Münzsymbol anzeigen",
    ["opt_skin_bags_layout_mode"]        = "Layout-Modus",
    ["opt_skin_bags_layout_combined"]    = "Kombiniertes Raster",
    ["opt_skin_bags_layout_categories"]  = "Kategorien",
    ["opt_skin_bags_layout_separate"]    = "Separate Taschen",
    ["opt_skin_bags_reverse_order"]      = "Taschenreihenfolge umkehren",
    ["opt_skin_bags_show_bag_bar"]       = "Taschenleiste anzeigen",
    ["opt_skin_bags_settings"]           = "Tascheneinstellungen",
    ["opt_skin_bags_slot_spacing_x"]     = "Fach-Abstand X",
    ["opt_skin_bags_slot_spacing_y"]     = "Fach-Abstand Y",
    ["opt_skin_bags_sort_none"]          = "Manuell",

    -- =====================
    -- TOMOSCORE (Scoreboard)
    -- =====================
    ["ts_cfg_title"]                = "Anzeigetafel",
    ["ts_cfg_enable"]               = "Dungeon-Anzeigetafel aktivieren",
    ["ts_cfg_auto_show_mplus"]      = "Automatisch für Mythic+ anzeigen",
    ["ts_cfg_scale"]                = "Skalierung",
    ["ts_cfg_alpha"]                = "Hintergrund-Deckkraft",
    ["ts_cfg_section_display"]      = "Anzeige",
    ["ts_cfg_section_frame"]        = "Rahmen",
    ["ts_cfg_section_actions"]      = "Aktionen",
    ["ts_cfg_preview"]              = "Vorschau",
    ["ts_cfg_last_run"]             = "Letzten Lauf anzeigen",
    ["ts_cfg_reset_pos"]            = "Position zurücksetzen",
    ["ts_reset_msg"]                = "|cffffd100TomoModForever|r Anzeigetafel: Position zurückgesetzt.",
    ["ts_no_data"]                  = "|cffffd100TomoModForever|r Anzeigetafel: Keine Dungeon-Daten verfügbar.",
    ["ts_mythic_zero"]              = "Mythisch",
    ["ts_key_level"]                = "+%d",
    ["ts_completed"]                = "ABGESCHLOSSEN",
    ["ts_depleted"]                 = "ERSCHÖPFT",
    ["ts_duration"]                 = "Dauer",
    ["ts_col_player"]               = "Spieler",
    ["ts_col_rating"]               = "M+",
    ["ts_col_key_level"]            = "Schlüssel",
    ["ts_col_key_name"]             = "Dungeon",
    ["ts_col_damage"]               = "Schaden",
    ["ts_col_healing"]              = "Heilung",
    ["ts_col_interrupts"]           = "Unterbrechungen",
    ["ts_footer_total"]             = "Gesamt",
    ["ts_footer_players"]           = "%d Spieler",

    -- =====================
    -- CASTBARS (Standalone-Modul)
    -- =====================
    ["cat_castbars"]                     = "Zauberleisten",

    -- Allgemein
    ["cb_section_general"]               = "Allgemein",
    ["opt_cb_enable"]                    = "Eigenständige Zauberleisten aktivieren",
    ["info_cb_description"]              = "Ersetzt die Blizzard-Zauberleisten durch vollständig anpassbare Leisten für Spieler, Ziel, Fokus, Begleiter und Boss.",
    ["btn_cb_toggle_preview"]            = "Show / Hide Preview",
    ["info_cb_preview_hint"]             = "Unlocks every castbar and shows a live mock spell so you can see your tweaks instantly.",
    ["opt_cb_hide_blizzard"]             = "Blizzard-Zauberleisten verstecken",
    ["opt_cb_class_color"]               = "Klassenfarbe verwenden",
    ["opt_cb_show_transitions"]          = "Start-/Endanimationen",
    ["opt_cb_show_channel_ticks"]        = "Kanal-Tick-Markierungen anzeigen",
    ["opt_cb_timer_format"]              = "Timer-Format",
    ["cb_timer_remaining"]               = "Verbleibend (1.5)",
    ["cb_timer_remaining_total"]         = "Verbleibend / Gesamt (1.5 / 3.0)",
    ["cb_timer_elapsed"]                 = "Vergangen (1.5)",
    ["opt_cb_spell_max_len"]             = "Max. Zaubernamenslänge (0 = unbegrenzt)",

    -- Aussehen
    ["cb_section_appearance"]            = "Darstellung",
    ["opt_cb_bar_texture"]               = "Balkentextur",
    ["cb_tex_blizzard"]                  = "Blizzard",
    ["cb_tex_smooth"]                    = "Glatt",
    ["cb_tex_flat"]                      = "Flach",
    ["opt_cb_font_size"]                 = "Schriftgröße",
    ["opt_cb_bg_mode"]                   = "Hintergrundmodus",
    ["cb_bg_black"]                      = "Schwarz",
    ["cb_bg_transparent"]                = "Transparent",
    ["cb_bg_custom"]                     = "Eigene Textur",

    -- Farben
    ["cb_section_colors"]                = "Farben",
    ["opt_cb_cast_color"]                = "Zauberfarbe",
    ["opt_cb_ni_color"]                  = "Nicht unterbrechbar",
    ["opt_cb_interrupt_color"]           = "Unterbrochen-Farbe",

    -- Funke
    ["cb_section_spark"]                 = "Funke",
    ["opt_cb_show_spark"]                = "Funken-Animation anzeigen",
    ["opt_cb_spark_style"]               = "Funken-Stil",
    ["opt_cb_spark_color"]               = "Funkenfarbe",
    ["opt_cb_spark_glow_color"]          = "Funkenglühen-Farbe",
    ["opt_cb_spark_tail_color"]          = "Funkenschweif-Farbe",
    ["opt_cb_spark_glow_alpha"]          = "Glühen-Deckkraft",
    ["opt_cb_spark_tail_alpha"]          = "Schweif-Deckkraft",

    -- GCD
    ["cb_section_gcd"]                   = "GCD-Funke",
    ["opt_cb_show_gcd"]                  = "GCD-Leiste unter Spieler-Zauberleiste",
    ["opt_cb_gcd_height"]                = "GCD-Balkenhöhe",
    ["opt_cb_gcd_color"]                 = "GCD-Farbe",

    -- Unterbrechungs-Feedback
    ["cb_section_interrupt"]             = "Unterbrechungs-Feedback",
    ["opt_cb_show_interrupt_feedback"]   = "Unterbrechungs-Feedback anzeigen",
    ["opt_cb_interrupt_fb_color"]        = "Feedbacktext-Farbe",
    ["opt_cb_interrupt_fb_size"]         = "Feedback-Schriftgröße",
    ["cb_interrupt_feedback_text"]       = "UNTERBROCHEN!",
    ["cb_interrupt_feedback_full"]       = "UNTERBROCHEN: %s",
    ["cb_interrupted"]                   = "Unterbrochen",

    -- Tabs
    ["cb_tab_general"]                   = "Allgemein",
    ["cb_tab_player"]                    = "Spieler",
    ["cb_tab_target"]                    = "Ziel",
    ["cb_tab_focus"]                     = "Fokus",
    ["cb_tab_pet"]                       = "Begleiter",
    ["cb_tab_boss"]                      = "Boss",

    -- Pro-Einheit
    ["cb_section_unit"]                  = "%s Zauberleiste",
    ["opt_cb_unit_enable"]               = "Aktivieren",
    ["opt_cb_unit_width"]                = "Breite",
    ["opt_cb_unit_height"]               = "Höhe",
    ["opt_cb_unit_show_icon"]            = "Symbol anzeigen",
    ["opt_cb_unit_icon_side"]            = "Symbolseite",
    ["cb_icon_left"]                     = "Links",
    ["cb_icon_right"]                    = "Rechts",
    ["opt_cb_unit_show_timer"]           = "Timer anzeigen",
    ["opt_cb_unit_show_latency"]         = "Latenz anzeigen",
    ["info_cb_latency"]                  = "Zeigt ein dunkles Overlay mit Netzwerklatenz am Ende der Leiste.",
    ["info_cb_position"]                 = "/tm layout eingeben, um diese Zauberleiste zu verschieben.",
    ["btn_cb_reset_position"]            = "Position zurücksetzen",
    ["cb_move_label"]                    = "(Ziehen zum Bewegen)",
    ["cb_player_missing_notice"]         = "Die Spieler-Zauberleiste ist nicht aktiviert — schalte sie in den Zauberleisten-Einstellungen ein, bevor sie verschoben werden kann.",
    ["cb_preview_castbar"]               = "Vorschau: %s",

    -- Mover
    ["mover_castbar_standalone"]         = "Zauberleisten",

    -- ═══════════════════════════════════
    -- Gruppenrahmen (Party Frames)
    -- ═══════════════════════════════════
    ["cat_partyframes"]                  = "Gruppenrahmen",
    ["mover_partyframes"]                = "Gruppenrahmen",

    ["pf_tab_general"]                   = "Allgemein",
    ["pf_tab_features"]                  = "Funktionen",
    ["pf_tab_cooldowns"]                 = "Abklingzeiten",
    ["pf_tab_arena"]                     = "Arena",

    ["pf_section_general"]               = "Allgemein",
    ["pf_opt_enable"]                    = "Gruppenrahmen aktivieren",
    ["pf_info_description"]              = "Eigene Gruppenrahmen für M+ und Arena mit Gesundheit, Absorption, Heilungsvorhersage, HoTs, Unterbrechung/Kampfrez-CD und Enthexungs-Hervorhebung.",
    ["pf_opt_hide_blizzard"]             = "Blizzard-Gruppenrahmen verstecken",
    ["pf_opt_sort_role"]                 = "Nach Rolle sortieren (Tank > Heiler > DPS)",

    ["pf_section_dimensions"]            = "Abmessungen",
    ["pf_opt_width"]                     = "Rahmenbreite",
    ["pf_opt_height"]                    = "Rahmenhöhe",
    ["pf_opt_spacing"]                   = "Abstand",
    ["pf_opt_grow_direction"]            = "Wachstumsrichtung",
    ["pf_dir_down"]                      = "Unten",
    ["pf_dir_up"]                        = "Oben",
    ["pf_dir_right"]                     = "Rechts",
    ["pf_dir_left"]                      = "Links",

    ["pf_section_display"]               = "Anzeige",
    ["pf_opt_show_name"]                 = "Name anzeigen",
    ["pf_opt_show_health_text"]          = "Gesundheitstext anzeigen",
    ["pf_opt_health_format"]             = "Gesundheitsformat",
    ["pf_fmt_deficit"]                   = "Defizit",
    ["pf_opt_health_color"]              = "Gesundheitsfarbmodus",
    ["pf_color_green"]                   = "Grün",
    ["pf_color_gradient"]                = "Verlauf",
    ["pf_opt_show_power"]                = "Kraftleiste anzeigen",
    ["pf_opt_power_height"]              = "Kraftleistenhöhe",
    ["pf_opt_show_role"]                 = "Rollensymbol anzeigen",
    ["pf_opt_role_size"]                 = "Rollensymbol-Größe",
    ["pf_opt_show_leader"]               = "Anführersymbol anzeigen",
    ["pf_opt_leader_size"]               = "Größe des Anführersymbols",
    ["pf_opt_show_marker"]               = "Schlachtzugsmarkierung anzeigen",
    ["pf_opt_readycheck_size"]            = "Bereitschaftsprüfung-Symbolgröße",
    ["pf_opt_summon_size"]               = "Vorladungsanzeige-Größe",

    ["pf_section_font"]                  = "Schrift",
    ["pf_opt_font_size"]                 = "Schriftgröße",

    ["pf_section_position"]              = "Position",
    ["pf_info_position"]                 = "/tm layout eingeben, um Gruppenrahmen zu verschieben.",
    ["pf_btn_reset_position"]            = "Position zurücksetzen",

    ["pf_section_health_extras"]         = "Gesundheits-Extras",
    ["pf_opt_show_absorb"]               = "Absorptionsleiste anzeigen",
    ["pf_opt_absorb_color"]              = "Absorptionsfarbe",
    ["pf_opt_show_heal_pred"]            = "Heilungsvorhersage anzeigen",

    ["pf_section_range"]                 = "Reichweitenprüfung",
    ["pf_opt_show_range"]                = "Außer-Reichweite-Mitglieder ausblenden",
    ["pf_opt_oor_alpha"]                 = "Außer-Reichweite-Transparenz",

    ["pf_section_dispel"]                = "Debufftyp-Warnung",
    ["pf_opt_show_dispel"]               = "Debufftyp-Warnung aktivieren",
    ["pf_opt_show_dispel_border"]        = "Ganzen Rahmen nach Debufftyp einfärben",
    ["pf_opt_show_dispel_icon"]          = "Symbol des vorrangigen Debuffs anzeigen",
    ["pf_opt_show_dispel_bleed"]         = "Blutungen einbeziehen",
    ["pf_opt_dispel_size"]               = "Symbolgröße des vorrangigen Debuffs",
    ["pf_opt_dispel_border_size"]        = "Randstärke der Warnung",
    ["pf_info_dispel"]                   = "Nutzt die Aura-Engine von Midnight 12.1 und zeigt Magie (blau), Fluch (lila), Krankheit (orange), Gift (grün) und Blutung (rot), ohne im Kampf geschützte Aurendaten zu lesen. Das Symbol ist der echte Debuff; der Rahmenrand verändert die Füllung der Lebensleiste nie.",

    ["pf_section_hots"]                  = "HoT-Anzeige",
    ["pf_opt_show_hots"]                 = "HoT-Symbole anzeigen",
    ["pf_opt_hot_size"]                  = "HoT-Symbolgröße",
    ["pf_opt_max_hots"]                  = "Max. angezeigte HoTs",
    ["pf_opt_hot_duration"]              = "Verbleibende Sekunden auf HoTs anzeigen",
    ["pf_info_hots"]                     = "Zeigt Heilung-über-Zeit-Effekte mit klassenfarbierten Rändern an. Unterstützt Priester, Druide, Paladin, Schamane, Mönch und Rufer.",
    ["pf_section_defensives"]            = "Verteidigungs-Cooldowns",
    ["pf_opt_show_defensives"]           = "Verteidigungs-Cooldowns anzeigen",
    ["pf_opt_defensive_size"]            = "Größe der Verteidigungssymbole",
    ["pf_opt_max_defensives"]            = "Max. angezeigte Verteidigungen",
    ["pf_opt_def_externals"]             = "Externe Cooldowns (auf diesen Spieler gewirkt)",
    ["pf_opt_def_raidwide"]              = "Schlachtzugsweite Cooldowns",
    ["pf_opt_def_personals"]             = "Persönliche Cooldowns",
    ["pf_info_defensives"]               = "Die Rahmenfarbe zeigt die Kategorie: Gold für externe (Eisenrinde, Lebenskokon, Schmerzunterdrückung), Cyan für schlachtzugsweite, Rot für persönliche. Schlachtzugsweite und persönliche Cooldowns sind standardmäßig aus, da sie alle Rahmen gleichzeitig aufleuchten lassen.",

    ["pf_section_cooldowns"]             = "Abklingzeit-Tracker",
    ["pf_opt_show_kick"]                 = "Unterbrechungs-CD anzeigen",
    ["pf_opt_show_brez"]                 = "Kampf-Rez-CD anzeigen",
    ["pf_opt_cd_size"]                   = "CD-Symbolgröße",
    ["pf_opt_cd_layout"]                 = "CD-Symbol-Layout",
    ["pf_cd_vertical"]                   = "Vertikal (auf Rahmen)",
    ["pf_cd_horizontal"]                 = "Horizontal (darunter)",
    ["pf_info_cooldowns"]                = "Unterbrechungen werden über UNIT_SPELLCAST_SUCCEEDED erkannt. Der Kampf-Rez liest den gemeinsamen Ladepool, daher graut das Symbol für alle aus, sobald ein Rez in der Instanz genutzt wird.",

    -- Auferstehungs-Anzeige (Gruppe)
    ["pf_section_resurrect"]             = "Auferstehungs-Anzeige",
    ["pf_opt_show_resurrect"]            = "Eingehende Auferstehung anzeigen",
    ["pf_opt_resurrect_size"]            = "Auferstehungs-Symbolgröße",
    ["pf_info_resurrect"]                = "Zeigt ein Rez-Symbol auf einem Mitglied, während eine Auferstehung auf es gewirkt wird.",

    ["pf_section_arena"]                 = "Arena-Gegnerrahmen",
    ["pf_opt_arena_enable"]              = "Arena-Rahmen aktivieren",
    ["pf_info_arena"]                    = "Zeigt Gesundheit, Kraft und PvP-Schmuck-CD der Gegner in der Arena (2v2/3v3).",
    ["pf_section_arena_dims"]            = "Arena-Abmessungen",
    ["pf_opt_arena_width"]               = "Breite",
    ["pf_opt_arena_height"]              = "Höhe",
    ["pf_opt_arena_spacing"]             = "Abstand",
    ["pf_section_arena_trinket"]         = "PvP-Schmuck",
    ["pf_opt_show_trinket"]              = "Schmuck-CD anzeigen",
    ["pf_opt_trinket_size"]              = "Schmuck-Symbolgröße",
    ["pf_opt_show_spec"]                 = "Spezialisierungssymbol anzeigen",
    ["pf_section_arena_pos"]             = "Arena-Position",
    ["pf_info_arena_pos"]                = "/tm layout eingeben, um Arena-Rahmen zu verschieben.",
    ["pf_btn_reset_arena_pos"]           = "Position zurücksetzen",

    -- ═══════════════════════════════════
    -- Raid Frames
    -- ═══════════════════════════════════
    ["cat_raidframes"]                   = "Schlachtzug-Rahmen",
    ["mover_raidframes"]                 = "Schlachtzug-Rahmen",
    ["rf_tab_general"]                   = "Allgemein",
    ["rf_tab_features"]                  = "Funktionen",
    ["rf_section_general"]               = "Allgemein",
    ["rf_opt_enable"]                    = "Schlachtzug-Rahmen aktivieren",
    ["rf_info_description"]              = "Benutzerdefinierte Schlachtzug-Rahmen mit Gesundheit, Absorption, Heilvorhersage, HoTs, Debuffs, Entfluch-Highlight, defensive CDs und Reichweiten-Check.",
    ["rf_opt_hide_blizzard"]             = "Blizzard Schlachtzug-Rahmen ausblenden",
    ["rf_opt_skin_group_manager"]       = "Gruppenleiter-Panel im TomoMod-Stil gestalten (Bereitschaftscheck, Markierungen, Gruppe verlassen)",
    ["rf_opt_sort_role"]                 = "Nach Rolle sortieren (Tank > Heiler > DPS)",
    ["rf_section_layout"]                = "Layout",
    ["rf_opt_layout_mode"]               = "Layout-Modus",
    ["rf_layout_grid"]                   = "Raster (Gruppen als Spalten)",
    ["rf_layout_list"]                   = "Liste (einzelne Spalte)",
    ["rf_opt_width"]                     = "Rahmenbreite",
    ["rf_opt_height"]                    = "Rahmenhöhe",
    ["rf_opt_spacing"]                   = "Abstand",
    ["rf_opt_group_spacing"]             = "Gruppenabstand",
    ["rf_section_display"]               = "Anzeige",
    ["rf_opt_show_name"]                 = "Name anzeigen",
    ["rf_opt_name_max_length"]           = "Max. Buchstaben",
    ["rf_opt_show_health_text"]          = "Gesundheitstext anzeigen",
    ["rf_opt_health_format"]             = "Gesundheitsformat",
    ["rf_opt_health_color"]              = "Gesundheitsfarb-Modus",
    ["rf_opt_show_role"]                 = "Rollensymbol anzeigen",
    ["rf_opt_show_marker"]               = "Schlachtzug-Markierung anzeigen",
    ["rf_opt_readycheck_size"]            = "Bereitschaftsprüfung-Symbolgröße",
    ["rf_opt_summon_size"]               = "Vorladungsanzeige-Größe",
    ["rf_section_font"]                  = "Schriftart",
    ["rf_opt_font_size"]                 = "Schriftgröße",
    ["rf_section_position"]              = "Position",
    ["rf_info_position"]                 = "Verwende /tm layout zum Entsperren und Verschieben der Schlachtzug-Rahmen.",
    ["rf_btn_reset_position"]            = "Position zurücksetzen",
    ["rf_info_test_raid"]                = "Simuliere einen 20-Spieler-Schlachtzug zur Vorschau des Layouts außerhalb des Kampfes.",
    ["rf_btn_test_raid"]                 = "20 Spieler simulieren",
    ["rf_btn_test_raid_stop"]            = "Simulation beenden",
    ["rf_preview_group"]                 = "G",
    ["rf_mode_raid"]                     = "Raid",
    ["rf_mode_solo"]                     = "Solo",
    ["rf_section_health_extras"]         = "Gesundheitsfunktionen",
    ["rf_opt_show_power"]                = "Energieleiste (nur Heiler)",
    ["rf_opt_power_height"]              = "Energieleisten-Höhe",
    ["rf_opt_show_absorb"]               = "Absorptionsleiste anzeigen",
    ["rf_opt_show_heal_pred"]            = "Heilvorhersage anzeigen",
    ["rf_section_range"]                 = "Reichweiten-Check",
    ["rf_opt_show_range"]                = "Außer Reichweite ausblenden",
    ["rf_opt_oor_alpha"]                 = "Außer-Reichweite-Transparenz",
    ["rf_section_dispel"]                = "Debufftyp-Warnung",
    ["rf_opt_show_dispel"]               = "Debufftyp-Warnung aktivieren",
    ["rf_opt_show_dispel_border"]        = "Ganzen Rahmen nach Debufftyp einfärben",
    ["rf_opt_show_dispel_icon"]          = "Symbol des vorrangigen Debuffs anzeigen",
    ["rf_opt_show_dispel_bleed"]         = "Blutungen einbeziehen",
    ["rf_opt_dispel_size"]               = "Symbolgröße des vorrangigen Debuffs",
    ["rf_opt_dispel_border_size"]        = "Randstärke der Warnung",
    ["rf_info_dispel"]                   = "Magie = blau, Fluch = lila, Krankheit = orange, Gift = grün, Blutung = rot. Nutzt AuraSlots der Engine, sodass die Warnung im Kampf auch bei geschützten Aurendaten sicher bleibt.",
    ["rf_section_hots"]                  = "HoT-Verfolgung",
    ["rf_opt_show_hots"]                 = "HoT-Indikatoren anzeigen",
    ["rf_opt_hot_size"]                  = "HoT-Symbolgröße",
    ["rf_opt_max_hots"]                  = "Max. angezeigte HoTs",
    ["rf_opt_hot_duration"]              = "Verbleibende Sekunden auf HoTs anzeigen",
    ["rf_section_debuffs"]               = "Debuff-Verfolgung",
    ["rf_opt_show_debuffs"]              = "Debuff-Symbole anzeigen",
    ["rf_opt_debuff_size"]               = "Debuff-Symbolgröße",
    ["rf_opt_max_debuffs"]               = "Max. angezeigte Debuffs",
    ["rf_section_defensives"]            = "Defensive Abklingzeiten",
    ["rf_opt_show_defensives"]           = "Aktive defensive Buffs anzeigen",
    ["rf_opt_defensive_size"]            = "Defensive Symbolgröße",
    ["rf_opt_max_defensives"]            = "Max. angezeigte Verteidigungen",
    ["rf_opt_def_externals"]             = "Externe Cooldowns (auf diesen Spieler gewirkt)",
    ["rf_opt_def_raidwide"]              = "Schlachtzugsweite Cooldowns",
    ["rf_opt_def_personals"]             = "Persönliche Cooldowns",
    ["rf_info_defensives"]               = "Zeigt aktive defensive CDs (z.B. Schmerzunterdrückung, Eisenborke, Gottesschild) bei jedem Schlachtzug-Mitglied an.",

    -- Auferstehungs-Anzeige (Schlachtzug)
    ["rf_section_resurrect"]             = "Auferstehungs-Anzeige",
    ["rf_opt_show_resurrect"]            = "Eingehende Auferstehung anzeigen",
    ["rf_opt_resurrect_size"]            = "Auferstehungs-Symbolgröße",
    ["rf_info_resurrect"]                = "Zeigt ein Rez-Symbol auf einem Mitglied, während eine Auferstehung auf es gewirkt wird (Kampf-Rez oder normal).",

    -- Kampf-Rez-Zähler
    ["rf_section_battlerez"]             = "Kampf-Rez-Zähler",
    ["rf_opt_br_enable"]                 = "Kampf-Rez-Zähler anzeigen",
    ["rf_opt_br_only_instance"]          = "Nur in Dungeons/Schlachtzügen",
    ["rf_opt_br_size"]                   = "Zählergröße",
    ["rf_opt_br_font"]                   = "Schriftgröße des Zählers",
    ["rf_info_battlerez"]                = "Ein verschiebbarer Zähler, der zeigt, wie viele Kampf-Rezs verfügbar sind und wann die nächste Aufladung kommt. Liest den gemeinsamen Pool, funktioniert auf jeder Klasse. Mit /tm layout verschieben.",

    -- Größenabhängiges Layout
    ["rf_section_size_overrides"]        = "Größenabhängiges Layout (10/25/40)",
    ["rf_opt_overrides_enable"]          = "Größenabhängige Layouts aktivieren",
    ["rf_info_size_overrides"]           = "Wenn aktiviert, passt die Rahmengröße sich automatisch an die Gruppengröße an (Abstand wird pro Stufe angepasst).",
    ["rf_ov_small"]                      = "Klein  (bis 10)",
    ["rf_ov_medium"]                     = "Mittel  (bis 25)",
    ["rf_ov_large"]                      = "Groß  (26-40)",
    ["rf_ov_width"]                      = "Breite",
    ["rf_ov_height"]                     = "Höhe",

    -- ═══════════════════════════════════
    -- Aura Tracker
    -- ═══════════════════════════════════
    ["mover_battlerez"]                  = "Kampf-Rez",
    ["mover_preytracker"]                = "Beute-Tracker",
    ["mover_extrabuttons"]               = "Extra-Button",

    ["at_section_general"]               = "Allgemein",
    ["at_opt_enable"]                    = "Aura-Tracker aktivieren",
    ["at_info_description"]              = "Verfolgt wichtige Buffs: Schmuck-Procs, Waffen-Verzauberung-Procs, Eigenbuffs und Defensiv-CDs in einem einfachen Symbol-Overlay.",

    ["at_section_appearance"]            = "Darstellung",
    ["at_opt_icon_size"]                 = "Symbolgröße",
    ["at_opt_spacing"]                   = "Abstand",
    ["at_opt_max_icons"]                 = "Max. Symbole",
    ["at_opt_grow_direction"]            = "Wachstumsrichtung",
    ["at_opt_font_size"]                 = "Schriftgröße",

    ["at_section_display"]               = "Anzeige",
    ["at_opt_show_timer"]                = "Timer anzeigen",
    ["at_opt_show_stacks"]               = "Stapelanzahl anzeigen",
    ["at_opt_show_glow"]                 = "Leuchten bei neuem Proc",
    ["at_opt_timer_threshold"]           = "Timer-Blinkschwelle (Sek.)",

    ["at_section_categories"]            = "Kategorien",
    ["at_info_categories"]               = "Wähle welche Aura-Kategorien verfolgt werden.",
    ["at_cat_trinkets"]                  = "Schmuck-Procs",
    ["at_cat_enchants"]                  = "Waffen-Verzauberung-Procs",
    ["at_cat_selfbuffs"]                 = "Eigenbuffs (Cooldowns)",
    ["at_cat_raidbuffs"]                 = "Schlachtzug-Buffs",
    ["at_cat_defensives"]                = "Defensiv (extern + persönlich)",

    ["at_section_position"]              = "Position",
    ["at_info_position"]                 = "/tm layout eingeben, um den Aura-Tracker zu verschieben.",
    ["at_btn_reset_position"]            = "Position zurücksetzen",

    -- ═══════════════════════════════════
    -- Battle Text
    -- ═══════════════════════════════════
    ["cat_battletext"]                   = "Kampftext",
    ["mover_battletext"]                 = "Kampftext",

    ["bt_section_general"]               = "Allgemein",
    ["bt_info_description"]              = "Scrollender Kampftext: Schaden und Heilung, ein- und ausgehend.",
    ["bt_opt_enable"]                    = "Kampftext aktivieren",

    ["bt_section_display"]               = "Anzeige",
    ["bt_opt_outgoing"]                  = "Ausgehenden Schaden anzeigen",
    ["bt_opt_incoming"]                  = "Eingehenden Schaden anzeigen",
    ["bt_opt_overheal"]                  = "Überheilung anzeigen",
    ["bt_opt_throttle"]                  = "DoT/HoT-Ticks zusammenfassen",

    ["bt_section_appearance"]            = "Darstellung",
    ["bt_opt_font_size"]                 = "Schriftgröße",
    ["bt_opt_throttle_window"]           = "Zusammenfassungsfenster (Sek)",

    ["bt_section_position"]              = "Position",
    ["bt_info_position"]                 = "/tm layout eingeben, um die Kampftext-Zonen zu verschieben.",
    ["bt_btn_reset_position"]            = "Positionen zurücksetzen",

    ["bt_zone_outgoing"]                 = "Ausgehend",
    ["bt_zone_incoming"]                 = "Eingehend",
    ["bt_zone_heal_out"]                 = "Heilung aus",
    ["bt_zone_heal_in"]                  = "Heilung ein",

    ["bt_cmd_help"]                      = "/tm bt <cmd>",
    ["bt_enabled"]                       = "aktiviert",
    ["bt_disabled"]                      = "deaktiviert",
    ["bt_crit"]                          = "!",
    ["bt_zones_locked"]                  = "Zonen gesperrt",
    ["bt_zones_unlocked"]                = "Zonen entsperrt",
    ["bt_reset_done"]                    = "Positionen zurückgesetzt.",
    ["bt_miss_miss"]                     = "Verfehlt",
    ["bt_miss_dodge"]                    = "Ausgewichen",
    ["bt_miss_parry"]                    = "Pariert",
    ["bt_miss_block"]                    = "Geblockt",
    ["bt_miss_resist"]                   = "Widerstanden",
    ["bt_miss_absorb"]                   = "Absorbiert",
    ["bt_miss_immune"]                   = "Immun",
    ["bt_miss_evade"]                    = "Ausweichen",
    ["bt_miss_deflect"]                  = "Abgelenkt",
    ["bt_miss_reflect"]                  = "Reflektiert",

    -- =========== What's New Popup ===========

    -- 2.9.8

    -- 2.9.6

    -- 2.9.7

    -- 2.9.5

    -- 2.9.4

    -- 2.9.3

    -- 2.9.2

    -- =====================
    -- CONFIG: Diagnostics Panel
    -- =====================
    ["section_diagnostics"]              = "Diagnose",
    ["opt_diag_enabled"]                 = "Fehlererfassung aktivieren",
    ["opt_diag_capture_all"]             = "Alle Addons erfassen",
    ["opt_diag_suppress_popups"]         = "Fehler-Popups unterdrücken",
    ["opt_diag_auto_open"]               = "Auto-Öffnen bei TomoMod-Fehler",
    ["btn_diag_open_console"]            = "Konsole öffnen",
    ["btn_diag_clear"]                   = "Fehler löschen",
    ["btn_diag_export"]                  = "Bericht kopieren",
    ["btn_diag_export_tracker"]          = "Für Tracker exportieren",
    ["info_diag_desc"]                   = "Erfasst Lua-Fehler im Hintergrund ohne Kampf-Popups. /tmdiag zum Öffnen der Konsole.",
    ["info_diag_session"]                = "Sitzung: #%d — %d Fehler erfasst (%d TomoMod)",
    ["info_diag_capture_all_desc"]       = "Wenn deaktiviert, werden nur TomoMod-Fehler erfasst. Aktivieren, um alle Addon-Fehler zu erfassen.",

    -- =====================
    -- HOUSING
    -- =====================
    ["section_housing_general"]      = "Housing — Allgemein",
    ["section_housing_hover"]        = "Dekor-Info (Hover)",
    ["section_housing_clock"]        = "Editor-Uhr",
    ["section_housing_teleport"]     = "Teleportation",
    ["section_housing_commands"]     = "Befehle",

    ["info_housing_desc"]            = "Housing-Modul: verbessert den Hauseditor und fügt Teleportations-Shortcuts hinzu. Benötigt Midnight / The War Within.",
    ["info_housing_hover"]           = "Im Modus 'Basis-Dekor' werden Name, Platzierungskosten und Restbestand des gehoverten Dekors angezeigt. Erlaubt auch das Duplizieren eines Dekors mit einer Modifikatortaste.",
    ["info_housing_clock"]           = "Zeigt eine Uhr an und verfolgt die im Hauseditor verbrachte Zeit. Rechtsklick auf die Uhr zum Wechseln zwischen analog und digital.",
    ["info_housing_teleport"]        = "Aktiviert den Befehl /tm home: Teleportiert zu deinem Haus oder verlässt es automatisch, wenn du zu Besuch bist.",
    ["info_housing_commands"]        = "• /tm home — zu deinem Haus teleportieren (oder es verlassen)\n• /tm housing — dieses Panel öffnen\n• Rechtsklick auf Uhr — analog/digital umschalten",

    ["opt_housing_enable"]           = "Housing-Modul aktivieren",
    ["opt_housing_decorhover"]       = "Dekor-Info aktivieren",
    ["opt_housing_dupe"]             = "Schnellvervielfältigung aktivieren (Modifikatortaste)",
    ["opt_housing_dupekey"]          = "Dupliziertaste",
    ["opt_housing_clock"]            = "Uhr aktivieren",
    ["opt_housing_clock_analog"]     = "Analogmodus (sonst digital)",
    ["opt_housing_teleport"]         = "Teleportation /tm home aktivieren",

    ["btn_housing_tp_home"]          = "Teleportieren (Test)",
    ["btn_housing_refresh"]          = "Häuser aktualisieren",

    ["housing_duplicate"]            = "Duplizieren",
    ["housing_alliance_zone"]        = "Gründervorgebirge",
    ["housing_horde_zone"]           = "Rasierklingenküste",
    ["housing_clock_title"]          = "TomoMod — Uhr",
    ["housing_clock_time"]           = "Uhrzeit",
    ["housing_clock_local"]          = "Lokale Zeit:",
    ["housing_clock_realm"]          = "Serverzeit:",
    ["housing_clock_time_spent"]     = "Zeit im Editor",
    ["housing_clock_session"]        = "Diese Sitzung:",
    ["housing_clock_total"]          = "Gesamt:",
    ["housing_clock_rightclick"]     = "Rechtsklick zum Umschalten analog / digital",

    ["msg_help_home"]                = "Zu deinem Haus teleportieren (oder es verlassen)",
    ["msg_help_housing"]             = "Das Housing-Panel öffnen",
    ["msg_housing_refresh"]          = "Hausinformationen angefragt.",
    ["msg_housing_unavailable"]      = "Housing-Modul auf diesem Client nicht verfügbar.",

    -- ═══════════════════════════════════
    -- Merchant Tools (2.9.9)
    -- ═══════════════════════════════════

    ["tab_qol_merchant_tools"]           = "Händler-Tools",

    ["section_already_known"]            = "Bereits bekannt",
    ["info_already_known"]               = "Graut aus oder färbt Händler-/Rückkaufartikel ein, die du bereits besitzt (Reittiere, Haustiere, Spielzeug, Transmog-Sets, Rezepte).",
    ["opt_ak_enable"]                    = "Bereits bekannt aktivieren",
    ["opt_ak_mode"]                      = "Anzeigemodus",
    ["ak_mode_mono"]                     = "Monochrom (grau)",
    ["ak_mode_color"]                    = "Farbtönung",
    ["opt_ak_color"]                     = "Tönungsfarbe",

    ["section_extend_pages"]             = "Erweiterte Händlerseiten",
    ["info_extend_pages"]                = "Fügt dem Händlerfenster zusätzliche Spalten hinzu.\nNach dem Aktivieren oder Ändern der Spaltenanzahl ist ein UI-Reload erforderlich.",
    ["opt_ep_enable"]                    = "Erweiterte Händlerseiten aktivieren",
    ["opt_ep_columns"]                   = "Anzahl der Spalten",

    ["preset_complet_name"]  = "Empfohlen",
    ["preset_complet_tag"]   = "Das komplette TomoMod-Erlebnis",
    ["preset_complet_desc"]  = "Aktiviert alle Kernmodule mit sinnvollen Standardwerten: UnitFrames, Gruppen- und Schlachtzugsrahmen, Nameplates, Zauberleisten, Ressourcen, Aktionsleisten-Skin, alle visuellen Skins, Mythic+-Werkzeuge und die nützlichsten Komfortfunktionen. Der beste Startpunkt für die meisten Spieler.",
    ["preset_tank_name"]     = "Tank",
    ["preset_tank_tag"]      = "Bedrohungsfokus, breitere Nameplates",
    ["preset_tank_desc"]     = "Die empfohlene Konfiguration, fürs Tanken angepasst: bedrohungsgefärbte Nameplates (Tank-Modus) und etwas breitere Plaketten für bessere Lesbarkeit der Bedrohung, plus die Bedrohungsanzeige am Ziel.",
    ["preset_healer_name"]   = "Heiler",
    ["preset_healer_tag"]    = "Größere Schlachtzugsrahmen, Mana sichtbar",
    ["preset_healer_desc"]   = "Die empfohlene Konfiguration, fürs Heilen angepasst: größere, leichter anklickbare Schlachtzugs- und Gruppenrahmen mit angezeigten Ressourcen- (Mana-)Leisten, HoT-Verfolgung, Dispel-Hervorhebung und defensiven Cooldowns im Vordergrund.",
    ["preset_dps_name"]      = "DPS",
    ["preset_dps_tag"]       = "Ressourcen & Cooldowns betont",
    ["preset_dps_desc"]      = "Die empfohlene Konfiguration, für Schaden angepasst: eine auffälligere Ressourcenleiste, Buff-Verfolgung am Ziel für gegnerische Defensiven und aufgeräumte Nameplates ohne Tank-Bedrohungsfärbung.",
    ["preset_minimal_name"]  = "Minimal",
    ["preset_minimal_tag"]   = "Nur das Wesentliche",
    ["preset_minimal_desc"]  = "Ein schlanker Fußabdruck: behält UnitFrames, Gruppen- und Schlachtzugsrahmen, Zauberleisten, Ressourcenleisten, die Minimap und die wichtigsten Automatisierungen — alles Kosmetische (Skins, Chat, Taschen, Nameplates, Zusatzpanels) bleibt aus. Am nächsten an einem Vanilla-Gefühl.",
    ["preset_custom_name"]   = "Benutzerdefiniert",
    ["preset_custom_tag"]    = "Alles selbst einrichten",
    ["preset_custom_desc"]   = "Überspringe die Voreinstellungen und gehe Kategorie für Kategorie durch, um genau das zu aktivieren, was du willst. Du kannst später jederzeit alles über /tm ändern.",
    ["preset_applied"]       = "Voreinstellung angewendet: %s — gib /reload ein, um das Ergebnis zu sehen.",
    ["preset_unknown"]       = "Unbekannte Voreinstellung « %s ». Verfügbar: complet, tank, healer, dps, minimal.",
    ["preset_usage"]         = "Verwendung: /tmpreset <complet|tank|healer|dps|minimal>",
    ["ins_v3_welcome_desc"]      = "Willkommen! Dieser schnelle Assistent richtet dir in Sekunden eine saubere, vollständige Oberfläche ein.\n\nWähle eine Konfiguration, die zu deiner Spielweise passt — du kannst danach alles über |cffffd100/tm|r feineinstellen. Möchtest du jede Option selbst wählen? Nimm |cffc89530Benutzerdefiniert|r.",
    ["ins_pick_title"]           = "Wähle deine Konfiguration",
    ["ins_pick_subtitle"]        = "Wähle unten einen Spielstil. Alles bleibt später über /tm anpassbar.",
    ["ins_pick_recommended"]     = "Empfohlen",
    ["ins_custom_frames_title"]  = "Rahmen",
    ["ins_custom_barsskins_title"] = "Leisten & Skins",
    ["ins_custom_mythicqol_title"] = "Mythic+ & Komfort",
    ["ins_custom_frames_intro"]  = "Aktiviere die gewünschten Rahmen. Sinnvolle Optionen sind vorausgewählt.",
    ["ins_custom_barsskins_intro"] = "Aktionsleisten-Skin und visuelle Skins für Chat, Taschen, Tooltips und mehr.",
    ["ins_custom_mythicqol_intro"] = "Mythic+-Werkzeuge, Oberflächen-Extras, Automatisierungen und Ton.",
    ["ins_recap_title"]          = "Alles bereit",
    ["ins_recap_preset"]         = "Konfiguration angewendet: |cffffd100%s|r",
    ["ins_recap_custom"]         = "Deine benutzerdefinierte Konfiguration ist bereit",
    ["ins_recap_desc"]           = "Lade deine Oberfläche neu, um alles anzuwenden. Du kannst diesen Assistenten jederzeit mit |cffffd100/tm install|r erneut öffnen und das vollständige Konfigurationsfenster mit |cffffd100/tm|r.",
    ["cat_accueil"]              = "Start",
    ["ui_search_placeholder"]    = "Einstellung suchen...",
    ["dash_welcome"]             = "Schnellübersicht von TomoMod. Module umschalten, eine Konfiguration anwenden, Profil wechseln oder den Assistenten neu starten.",
    ["dash_modules_section"]     = "Module",
    ["dash_quickcfg_section"]    = "Schnellkonfiguration",
    ["dash_studio_section"]           = "Cooldown Studio",
    ["dash_studio_info"]              = "Vollbild-Editor f\195\188r Cooldown-Leisten: Layout, Stil, Zauber und Sichtbarkeit.",
    ["dash_studio_open"]              = "Cooldown Studio \195\182ffnen",
    ["dash_profile_section"]     = "Profil",
    ["dash_maint_section"]       = "Wartung",
    ["dash_reload_hint"]         = "Moduländerungen werden live angewendet. Geschützte Änderungen folgen automatisch nach dem Kampf.",
    ["dash_reload_now"]          = "Jetzt neu laden",
    ["dash_apply_preset"]        = "Konfigurations-Voreinstellung",
    ["dash_apply_preset_btn"]    = "Diese Voreinstellung anwenden",
    ["dash_apply_preset_info"]   = "Eine Voreinstellung setzt zurück, welche Module an oder aus sind, und lädt dann neu.",
    ["dash_active_profile"]      = "Aktives Profil",
    ["dash_manage_profiles"]     = "Profile verwalten",
    ["dash_profile_info"]        = "Ein Profilwechsel lädt die Oberfläche neu, um ihn anzuwenden.",
    ["dash_relaunch_info"]       = "Öffnet den « Voreinstellungen zuerst »-Einrichtungsassistenten erneut.",
    ["dash_mod_resources"]       = "Ressourcen",
    ["dash_mod_cdm"]             = "Cooldown-Manager",
    ["dash_mod_abskin"]          = "Aktionsleisten-Skin",
    ["dash_mod_chatskin"]        = "Chat-Skin",
    ["dash_mod_bagskin"]         = "Taschen-Skin",
    ["dash_mod_mtracker"]        = "Mythic+-Tracker",
    ["dash_mod_score"]           = "Mythic+-Wertung",
    ["dash_reload_popup"]        = "Oberfläche jetzt neu laden, um deine Änderungen anzuwenden?",

    -- ═══════════════════════════════════
    -- MythicTracker EJ-Boss-Namen (2.9.10)
    -- ═══════════════════════════════════
    -- ═══════════════════════════════════
    -- PartyFrame-CD-Fix + Performance (2.9.12)
    -- ═══════════════════════════════════
    -- ═══════════════════════════════════
    -- Installer Overhaul & AB Toggle (2.9.17)
    -- ═══════════════════════════════════
    -- Smart Waypoint (2.9.20)
    -- ═══════════════════════════════════

    -- Objective Tracker Stability (2.9.19)
    -- ═══════════════════════════════════

    -- ═══════════════════════════════════
    -- Objective Tracker Quest Buckets (2.9.18)
    -- ═══════════════════════════════════


    -- AuctionRecipeTracker (2.9.15)
    -- ═══════════════════════════════════

    -- ═══════════════════════════════════
    -- MythicTracker Boss Names Fix (2.9.13)
    -- ═══════════════════════════════════


    -- ═══════════════════════════════════
    -- CooldownManager / ProcGlow / BuffSkin Korrekturen (2.9.11)
    -- ═══════════════════════════════════

    -- ═══════════════════════════════════
    -- MythicTracker EJ-Boss-Namen (2.9.10)
    -- ═══════════════════════════════════

    -- Player Auras Mover (v2.9.5)
    ["mover_player_auras"]       = "Spieler-Auren",
    ["opt_auras_spacing"]        = "Symbolabstand",
    ["btn_reset_aura_position"]  = "Aura-Position zurücksetzen",

    -- Module Reload Safety (v2.9.21)
    ["msg_module_reload"]        = "Diese Änderung erfordert ein Neuladen der Oberfläche.\nJetzt neu laden?",
    ["info_module_reload"]       = "Erfordert /reload um wirksam zu werden.",

    -- Waypoint Arrow Reversed (v2.9.22)

    -- 3.0.3
    -- 3.0.4

    -- 3.0.3

    -- 3.0.0

    -- 3.0.5

    -- =====================
    -- Extra Action Button (v3.0.6)
    -- =====================
    ["mover_ab_extra"] = "Extra-Aktion",
    ["mover_ab_pet"] = "Begleiterleiste",
    ["mover_ab_stance"] = "Haltungsleiste",
    ["section_extra_button"] = "Extra-Aktionsschaltflaeche",
    ["opt_extra_enabled"] = "Extra-Aktionsschaltflaeche verwalten (/reload zum Freigeben)",
    ["opt_extra_scale"] = "Skalierung der Extra-Schaltflaeche",
    ["btn_extra_reset_pos"] = "Position zuruecksetzen",
    ["info_extra_button"] = "Positioniere die Extra-Aktionsschaltflaeche im Layout-Modus. Sie erscheint bei Quests und Kaempfen. Beim Deaktivieren wird sie nach einem /reload an Blizzard zurueckgegeben.",
    -- 3.0.7

    -- 3.1.1
    ["art_searching"]        = "Suche: %s",
    ["art_searching_qty"]    = "Suche: %s × %d",

    -- 3.1.2

    -- 3.1.3

    -- Tooltip-Verankerung
    ["opt_tooltip_anchor"]        = "Tooltip-Position",
    ["tooltip_anchor_default"]    = "Standard",
    ["tooltip_anchor_cursor"]     = "Maus",
    ["tooltip_anchor_corner"]     = "Bildschirmecke",
    ["tooltip_anchor_custom"]     = "Benutzerdefiniert",
    ["opt_tooltip_anchor_corner"] = "Ecke (Ecken-Modus)",
    ["corner_br"]                 = "Unten rechts",
    ["corner_bl"]                 = "Unten links",
    ["corner_tr"]                 = "Oben rechts",
    ["corner_tl"]                 = "Oben links",
    ["info_tooltip_anchor"]       = "Benutzerdefiniert: Diesen Modus wählen, dann den türkisfarbenen Rahmen an die gewünschte Position ziehen.",
    ["btn_tooltip_toggle_anchor"] = "Anker anzeigen/ausblenden",
    ["mover_tooltip_anchor"]      = "Tooltip-Anker",

    -- Nameplates preview
    ["np_preview_title"]   = "Nameplates-Vorschau",
    ["np_preview_hint"]    = "Schnelle Lesbarkeit: Farbe, Cast-Leiste, Auren und Bedrohung auf einen Blick.",
    ["preview_np_friendly"] = "Verbündeter",
    ["preview_np_target"]  = "Feindliches Ziel",
    ["preview_np_boss"]    = "Markierter Boss",

    -- 3.1.4

    -- 3.1.5

    -- 3.1.6

    -- 3.1.7

    -- 3.1.8

    -- 3.1.9

    -- 3.1.11
    -- =====================
    -- CONFIG: Categories, tabs & shell (ConfigUI.lua) [Lot D1]
    -- =====================
    ["cat_interface"]         = "Interface",
    ["cat_units"]             = "Einheiten",
    ["cat_combat"]            = "Kampf",
    ["cat_comfort"]           = "Komfort",
    ["cat_tools"]             = "Werkzeuge",
    ["cat_accueil_desc"]      = "Übersicht, Presets und Schnellaktionen.",
    ["cat_interface_desc"]    = "Globales Erscheinungsbild, Leisten, Sounds und Blizzard-Fenster.",
    ["cat_units_desc"]        = "Spieler, Nameplates, Gruppe und Schlachtzug an einem Ort.",
    ["cat_combat_desc"]       = "Zauber, Ressourcen, Cooldowns und Mythic+.",
    ["cat_comfort_desc"]      = "Automatisierungen, Quests, AFK, Housing und Komfort.",
    ["cat_changelog"]                 = "Neuerungen",
    ["cat_changelog_desc"]            = "Alle Versionshinweise, neueste zuerst.",
    ["cl_title"]                      = "Versionshinweise",
    ["cl_intro"]                      = "%d Versionen. Klicke auf eine Nummer, um die Hinweise zu lesen.",
    ["cl_unavailable"]                = "Die Versionshinweise konnten nicht geladen werden.",
    ["cat_tools_desc"]        = "Profile, Backups, Diagnose und Wartung.",
    ["cat_profiles_desc"]     = "Profile, Spezialisierungen, Import / Export und Zurücksetzen.",
    ["cat_diagnostics_desc"]  = "Live-Status, Lua-Fehler und Leistungswerte.",
    ["cat_damagemeter"]                 = "Schadensmesser",
    ["cat_damagemeter_desc"]            = "Schadensmesser, Todesr\195\188ckblick und Dungeon-R\195\188ckblick.",
    ["dm_cfg_title"]                    = "Schadensmesser",
    ["dm_cfg_intro"]                    = "Der Messer hat vorerst sein eigenes Einstellungsfenster. Es wird hier in K\195\188rze integriert.",
    ["dm_cfg_open"]                     = "Einstellungen des Schadensmessers \195\182ffnen",
    ["dm_cfg_toggle"]                   = "Fenster ein- / ausblenden",
    ["dm_cfg_standalone"]               = "Das eigenst\195\164ndige Addon TomoDamageMeter ist installiert und \195\188bernimmt. Das eingebettete Modul bleibt inaktiv.",
    ["dm_cfg_unavailable"]              = "Blizzards Schadensmesser ist auf diesem Client nicht verf\195\188gbar, das Modul ist inaktiv.",
    ["cfg_tab_general"]       = "Allgemein",
    ["cfg_tab_actionbars"]    = "Aktionsleisten",
    ["cfg_tab_skins"]         = "Skins",
    ["cfg_tab_sound"]         = "Sound",
    ["cfg_tab_unitframes"]    = "UnitFrames",
    ["cfg_tab_nameplates"]    = "Nameplates",
    ["cfg_tab_partyframes"]   = "Gruppe",
    ["cfg_tab_raidframes"]    = "Raid",
    ["cfg_tab_castbars"]      = "Zauberleisten",
    ["cfg_tab_resources"]     = "CD & Ressourcen",
    ["cfg_tab_mythicplus"]    = "Mythic+",
    ["cfg_tab_qol"]           = "Lebensqualität",
    ["cfg_tab_housing"]       = "Housing",
    ["cfg_tab_profiles"]      = "Profile",
    ["cfg_tab_diagnostics"]   = "Diagnose",
    ["cfg_reload_text"]       = "Interface neu laden, um diese Änderung anzuwenden?",
    ["cfg_reload_confirm"]    = "Neu laden",
    ["cfg_reload_later"]      = "Später",
    ["cfg_footer_perf"]       = "FPS: %d  |  Sp.: %s",
    -- =====================
    -- CONFIG: CD/Resource & Profiles panels [Lot D2]
    -- =====================
    ["section_cdm_alpha"]             = "Deckkraft",
    ["opt_rb_primary_centered"]       = "Primäre Ressource in Bildschirmmitte anzeigen",
    ["info_rb_primary_centered"]      = "Verschiebt die Mana-/Energie-/Wut-Leiste des Spielerrahmens in die Bildschirmmitte.",
    ["opt_rb_primary_power_height"]   = "Höhe der primären Leiste",
    ["import_preview_analyzing"]      = "Analysiere …",
    ["profiles_export_failed"]        = "Export fehlgeschlagen",
    ["profiles_import_failed"]        = "Import fehlgeschlagen",
    ["profiles_error"]                = "Fehler",
    ["profiles_rename_failed"]        = "Umbenennen fehlgeschlagen",
    -- =====================
    -- CONFIG: General panel — minimap & buttonbag [Lot D3]
    -- =====================
    ["section_minimap_indicators"]    = "Minimap-Indikatoren",
    ["info_minimap_indicators"]       = "Wähle einen Indikator und lege dann Ecke, Größe und Versatz fest. Wird sofort angewendet.",
    ["opt_indicator"]                 = "Indikator",
    ["opt_corner"]                    = "Ecke",
    ["opt_offset_x"]                  = "Versatz X",
    ["opt_offset_y"]                  = "Versatz Y",
    ["corner_topleft"]                = "Oben links",
    ["corner_topright"]               = "Oben rechts",
    ["corner_bottomleft"]             = "Unten links",
    ["corner_bottomright"]            = "Unten rechts",
    ["opt_minimap_tracking"]          = "Spurensuche-Button",
    ["opt_tracking_style"]            = "Stil des Spurensuche-Buttons",
    ["opt_minimap_mail"]              = "Post",
    ["opt_minimap_difficulty"]        = "Schwierigkeitsgrad",
    ["opt_minimap_expansion"]         = "Erweiterungs-Button",
    ["opt_minimap_crafting"]          = "Handwerksaufträge",
    ["minimap_style_bliz"]            = "Blizzard",
    ["minimap_style_tomo"]            = "TomoMod",
    ["section_buttonbag"]             = "Addon-Buttons",
    ["info_buttonbag"]                = "Sammelt Addon-Buttons der Minimap in einer Tasche. Klicke auf den Button auf der Minimap, um sie zu öffnen.",
    ["opt_buttonbag_enable"]          = "Sammler aktivieren",
    ["opt_collector_style"]           = "Sammler-Stil",
    ["collector_style_bliz"]          = "Blizzard (nativ)",
    ["collector_style_tomo"]          = "TomoMod (Tasche)",
    ["opt_buttonbag_anchor"]          = "Button-Position",
    ["buttonbag_anchor_corner"]       = "Auf der Minimap (Ecke)",
    ["buttonbag_anchor_clockl"]       = "Links von der Uhr",
    ["buttonbag_anchor_clockr"]       = "Rechts von der Uhr",
    ["opt_buttonbag_columns"]         = "Spalten",
    ["opt_buttonbag_iconsize"]        = "Symbolgröße",
    ["btn_buttonbag_rescan"]          = "Buttons neu suchen",
    -- =====================
    -- CONFIG: Remaining panels [Lot D4]
    -- =====================
    ["btn_bar_uniformize"]            = "Aussehen dieser Leiste auf alle Leisten übertragen",
    ["info_bar_uniformize"]           = "Überträgt das Erscheinungsbild (Größe, Abstand, Spalten, Transparenz, Skalierung, Ausblenden, Texte …) auf jede andere Leiste. Position und Aktivierungsstatus jeder Leiste bleiben erhalten.",
    ["opt_bar_hotkey_size"]           = "Schriftgröße der Tastenkürzel",
    ["popup_ab_uniformize"]           = "Das Aussehen der Leiste „%s“ auf alle anderen Leisten übertragen?",
    ["info_cb_anchor_uf"]             = "Diese Zauberleiste ist am zugehörigen Unit-Frame verankert (sie erscheint also am Ziel-/Fokus-/Begleiter-/Boss-Rahmen).",
    ["tab_qol_compass"]               = "Kompass",
    ["section_compass"]               = "Kompassleiste",
    ["info_compass_desc"]             = "Eine Richtungsleiste oben am Bildschirm, die beim Drehen N/O/S/W anzeigt, mit einem Marker, der auf deine verfolgte Quest oder den Kartenwegpunkt zeigt. Nur lesend – kein Taint.",
    ["info_compass_layout"]           = "Tipp: Nutze den Layout-Modus (/tm layout), um die Leiste an die gewünschte Stelle zu ziehen.",
    ["opt_compass_enable"]            = "Kompassleiste aktivieren",
    ["opt_compass_fov"]               = "Sichtfeld",
    ["compass_fov_narrow"]            = "Eng (±45°)",
    ["compass_fov_standard"]          = "Standard (±60°)",
    ["compass_fov_wide"]              = "Weit (±90°)",
    ["opt_compass_width"]             = "Leistenbreite",
    ["opt_compass_height"]            = "Leistenhöhe",
    ["opt_compass_scale"]             = "Skalierung",
    ["opt_compass_show_heading"]      = "Richtungsanzeige anzeigen (z. B. 245° SW)",
    ["opt_compass_show_distance"]     = "Entfernung an Markern anzeigen",
    ["opt_compass_show_quest"]        = "Marker für verfolgte Quest anzeigen",
    ["opt_compass_show_waypoint"]     = "Marker für Kartenwegpunkt anzeigen",
    ["opt_skyride_ground_speed"]      = "Bodengeschwindigkeit anzeigen",
    ["info_skyride_ground_speed"]     = "Zeigt deine Bewegungsgeschwindigkeit auch am Boden an (Fluganzeigen bleiben verborgen, solange du nicht fliegst).",
    ["btn_class_reminder_preview"]    = "Vorschau",
    ["sublabel_class_reminder_coverage"] = "— Verfolgte Buffs & Gestalten —",
    ["opt_char_skin_movable"]         = "Verschiebbares Fenster",
    ["info_char_skin_movable"]        = "Sobald aktiviert, kannst du das Charakterfenster ziehen, um es zu verschieben. Die Position wird gespeichert.",
    ["btn_char_skin_reset_pos"]       = "Position zurücksetzen",
    ["btn_sound_test"]                = "▶ Diesen Sound abspielen",
    ["opt_auras_max_width"]           = "Max. Breite (Zeilenumbruch)",
    ["opt_auras_per_row"]             = "Symbole pro Zeile",

    -- 3.2.0
    ["cfg_tab_cdforge"]           = "Cooldowns",

    -- 3.2.1

    -- 3.2.2
    -- Cooldown-Manager-Halter (Movers / Layout-Modus)
    ["mover_cdm"]                        = "Cooldown Manager",
    ["cdm_drag_hint"]                    = "Zum Verschieben ziehen",
    ["cdm_preview_aura"]                 = "Aura",




    -- =====================
    -- Fehlende Ubersetzungen -- these keys previously fell back to enUS
    -- =====================
    ["opt_cursor_ring_texture"]           = "Textur",
    ["cursor_tex_ring"]                   = "Ring",
    ["cursor_tex_glow"]                   = "Leuchten",
    ["cursor_tex_cygle"]                  = "Cygle",
    ["cursor_tex_heart"]                  = "Herz",
    ["opt_cdm_custom_cd_swipe"]           = "Eigene Farbe für Abklingzeit-Sweep",
    ["opt_cdm_cd_swipe_color"]            = "Farbe des Abklingzeit-Sweeps",
    ["opt_cdm_cd_swipe_alpha"]            = "Deckkraft des Abklingzeit-Sweeps",
    ["section_cdm_advanced"]              = "Erweitert",
    ["opt_cdm_hide_gcd"]                  = "GCD ausblenden",
    ["opt_cdm_desaturate"]                = "Bei Abklingzeit entsättigen",
    ["opt_cdm_buff_alignment"]            = "Ausrichtung der Stärkungszauber",
    ["align_center_outward"]              = "Mitte → nach außen",
    ["align_start"]                       = "Anfang (links)",
    ["align_end"]                         = "Ende (rechts)",
    ["section_cdm_visibility"]            = "Sichtbarkeitsregeln",
    ["info_cdm_visibility"]               = "Regeln mit Priorität. »Anzeigen«-Bedingungen haben Vorrang vor »Ausblenden«-Bedingungen.",
    ["opt_cdm_hide_mounted"]              = "Beritten ausblenden",
    ["opt_cdm_hide_vehicle"]              = "Im Fahrzeug ausblenden",
    ["opt_cdm_hide_ooc"]                  = "Außerhalb des Kampfes ausblenden (ohne Ziel)",
    ["opt_cdm_show_combat"]               = "Im Kampf immer anzeigen",
    ["opt_cdm_show_instance"]             = "In Instanzen immer anzeigen",
    ["opt_cdm_show_enemy"]                = "Bei feindlichem Ziel anzeigen",
    ["section_cdm_extras"]                = "Ton / Pandemic / Reichweite",
    ["opt_cdm_sound_alert"]               = "Ton, wenn der Zauber bereit ist",
    ["opt_cdm_sound_file"]                = "Tondatei",
    ["opt_cdm_pandemic"]                  = "Pandemic (Auffrischungsrahmen)",
    ["opt_cdm_pandemic_threshold"]        = "Pandemic-Schwelle (%)",
    ["opt_cdm_range_check"]               = "Rot einfärben außer Reichweite",
    ["ot_bucket_complete"]                = "Abgabebereit",
    ["ot_bucket_campaign"]                = "Kampagne",
    ["ot_bucket_important"]               = "Wichtig",
    ["ot_bucket_legendary"]               = "Legendär",
    ["ot_bucket_weekly"]                  = "Wöchentlich",
    ["ot_bucket_daily"]                   = "Täglich",
    ["ot_bucket_world"]                   = "Weltquests",
    ["ot_bucket_dungeon"]                 = "Dungeons",
    ["ot_bucket_raid"]                    = "Schlachtzüge",
    ["ot_bucket_profession"]              = "Berufe",
    ["ot_bucket_achievement"]             = "Erfolge",
    ["ot_bucket_quests"]                  = "Quests",
    ["ot_bucket_other"]                   = "Sonstiges",
    ["mover_minimap"]                     = "Minikarte & Panel",
    ["mover_objectivetracker"]            = "Questverfolgung",
    ["tab_skin_chatframeui"]              = "Chatfenster-UI",
    ["sublabel_chatframeui"]              = "— Chatfenster-UI mit mehreren Positionen —",
    ["opt_cfui_enable"]                   = "Chatfenster-UI aktivieren",
    ["opt_cfui_enable_desc"]              = "Fügt dekorative Container, eine Schaltflächenleiste, Seitenleistensymbole und den Layoutwechsel hinzu (MayronUI-Stil).",
    ["opt_cfui_frame_topleft"]            = "Rahmen oben links",
    ["opt_cfui_frame_topright"]           = "Rahmen oben rechts",
    ["opt_cfui_frame_bottomleft"]         = "Rahmen unten links",
    ["opt_cfui_frame_bottomright"]        = "Rahmen unten rechts",
    ["opt_cfui_show_tab_bar"]             = "Registerkartenleiste anzeigen",
    ["opt_cfui_tab_bar_offset"]           = "Y-Versatz der Registerkartenleiste",
    ["opt_cfui_window_offset"]            = "Y-Versatz des Fensters",
    ["opt_cfui_x_offset"]                 = "X-Versatz",
    ["opt_cfui_y_offset"]                 = "Y-Versatz",
    ["opt_cfui_icons_anchor"]             = "Verankerung der Seitenleistensymbole",
    ["opt_cfui_raid_frame_mgr"]           = "Schlachtzugsrahmen-Manager umgestalten",
    ["opt_cfui_editbox_position"]         = "Position des Eingabefelds",
    ["opt_cfui_editbox_height"]           = "Höhe des Eingabefelds",
    ["opt_cfui_swap_in_combat"]           = "Schaltflächenwechsel im Kampf erlauben",
    ["cfui_show_chat_menu"]               = "Chatmenü anzeigen",
    ["cfui_show_professions"]             = "Berufe anzeigen",
    ["cfui_show_shortcuts"]               = "Addon-Verknüpfungen anzeigen",
    ["cfui_copy_chat"]                    = "Chattext kopieren",
    ["cfui_click_toggle_status"]          = "Klicken, um AFK umzuschalten",
    ["cfui_layout_button"]                = "TomoMod-Layout",
    ["cfui_left_click"]                   = "Linksklick:",
    ["cfui_switch_layout"]                = "Layout wechseln",
    ["cfui_no_layouts"]                   = "Keine gespeicherten Layouts. Verwende /tm layout save <Name>",
    ["cfui_no_professions"]               = "Du hast keine Berufe.",
    ["cfui_config_menu"]                  = "Einstellungen",
    ["cfui_profiles"]                     = "Profile",
    ["cfui_clear_chat"]                   = "Chat leeren",
    ["cfui_reload_ui"]                    = "Benutzeroberfläche neu laden",
    ["cfui_btn_character"]                = "Charakter",
    ["cfui_btn_bags"]                     = "Taschen",
    ["cfui_btn_friends"]                  = "Freunde",
    ["cfui_btn_guild"]                    = "Gilde",
    ["cfui_btn_help"]                     = "Hilfemenü",
    ["cfui_btn_pvp"]                      = "PvP",
    ["cfui_btn_spellbook"]                = "Zauberbuch",
    ["cfui_btn_talents"]                  = "Talente",
    ["cfui_btn_achievements"]             = "Erfolge",
    ["cfui_btn_calendar"]                 = "Kalender",
    ["cfui_btn_lfd"]                      = "Dungeonsuche",
    ["cfui_btn_raid"]                     = "Schlachtzug",
    ["cfui_btn_encounter"]                = "Abenteuerführer",
    ["cfui_btn_collections"]              = "Sammlungen",
    ["cfui_btn_macros"]                   = "Makros",
    ["cfui_btn_worldmap"]                 = "Weltkarte",
    ["cfui_btn_questlog"]                 = "Questlog",
    ["cfui_btn_reputation"]               = "Ruf",
    ["cfui_btn_pvpscore"]                 = "JcJ-Wertung",
    ["cfui_btn_currency"]                 = "Währung",
    ["btn_abs_layout"]                    = "EditMode (/tm layout)",
    ["opt_bar_enabled"]                   = "Aktiviert",
    ["opt_bar_orientation"]               = "Ausrichtung",
    ["opt_bar_grow_dir"]                  = "Wachstumsrichtung",
    ["opt_bar_columns"]                   = "Spalten",
    ["opt_bar_button_size"]               = "Schaltflächengröße",
    ["opt_bar_spacing"]                   = "Abstand",
    ["opt_bar_alpha"]                     = "Transparenz",
    ["opt_bar_scale"]                     = "Skalierung",
    ["opt_bar_display_cond"]              = "Anzeigebedingung",
    ["opt_bar_fade"]                      = "Ausblenden aktivieren",
    ["opt_bar_fade_out_alpha"]            = "Transparenz beim Ausblenden",
    ["opt_bar_fade_out_delay"]            = "Verzögerung vor dem Ausblenden",
    ["opt_bar_fade_out_dur"]              = "Dauer des Ausblendens",
    ["opt_bar_fade_in_dur"]               = "Dauer des Einblendens",
    ["opt_bar_click_through"]             = "Klicks durchlassen",
    ["opt_bar_show_empty"]                = "Leere Schaltflächen anzeigen",
    ["opt_bar_show_hotkey"]               = "Tastenkürzel anzeigen",
    ["opt_bar_disabled"]                  = "Deaktiviert",
    ["bar_name_bar1"]                     = "Leiste 1 (Haupt)",
    ["bar_name_bar2"]                     = "Leiste 2",
    ["bar_name_bar3"]                     = "Leiste 3",
    ["bar_name_bar4"]                     = "Leiste 4",
    ["bar_name_bar5"]                     = "Leiste 5",
    ["bar_name_bar6"]                     = "Leiste 6",
    ["bar_name_bar7"]                     = "Leiste 7",
    ["bar_name_bar8"]                     = "Leiste 8",
    ["bar_name_pet"]                      = "Begleiterleiste",
    ["bar_name_stance"]                   = "Haltungsleiste",
    ["pf_opt_name_max_length"]            = "Max. Buchstaben im Namen (0 = unbegrenzt)",
    ["tab_qol_consumable_bar"]            = "Verbrauchsgüter",
    ["section_consumable_bar"]            = "Verbrauchsgüterleiste",
    ["info_cb_desc"]                      = "Zeigt ein Symbol und einen Timer für jedes aktive Verbrauchsgut: Fläschchen (1 Std.), Sattgegessen (1 Std.) und Waffenöl (2 Std.). Der Platz für das Öl der Nebenhand erscheint nur, wenn dort eine Waffe getragen wird.",
    ["opt_consumable_enable"]             = "Verbrauchsgüterleiste aktivieren",
    ["opt_cb_show_missing"]               = "Fehlende Stärkungszauber anzeigen (abgeblendet)",
    ["opt_cb_icon_size"]                  = "Symbolgröße",
    ["opt_cb_gap"]                        = "Abstand zwischen den Symbolen",
    ["opt_cb_orientation"]                = "Ausrichtung",
    ["cb_orient_horizontal"]              = "Horizontal",
    ["cb_orient_vertical"]                = "Vertikal",
    ["opt_cb_timer_pos"]                  = "Position des Timers",
    ["cb_timerpos_below"]                 = "Unten (horizontal)",
    ["cb_timerpos_above"]                 = "Oben (horizontal)",
    ["cb_timerpos_right"]                 = "Rechts (vertikal)",
    ["cb_timerpos_left"]                  = "Links (vertikal)",
    ["mover_consumable_bar"]              = "Verbrauchsgüterleiste",
    ["mover_class_reminder"]              = "Klassenerinnerung",
    ["art_title"]                         = "Rezeptverfolgung",
    ["art_no_recipes"]                    = "Keine verfolgten Rezepte — verfolge ein Rezept in deinem Berufsfenster.",
    ["art_status_idle"]                   = "Klicke auf eine Zutat, um im Auktionshaus zu suchen.",
    ["art_scan_btn"]                      = "Auktionshaus scannen",
    ["art_scan_running"]                  = "Wird gescannt...",
    ["art_scan_started"]                  = "Scan gestartet — bitte warten...",
    ["art_scan_done"]                     = "Scan abgeschlossen: %d Gegenstände erfasst.",
    ["art_scan_failed"]                   = "Scan fehlgeschlagen oder unterbrochen.",
    ["art_scan_cooldown"]                 = "Nächster Scan in %dm %ds verfügbar.",
    ["art_scan_tip_title"]                = "Vollständiger Auktionshaus-Scan",
    ["art_scan_tip_desc"]                 = "Erfasst den niedrigsten Sofortkaufpreis pro Gegenstand. Auf einmal alle 15 Minuten begrenzt.",
    ["art_only_at_ah"]                    = "Öffne zuerst das Auktionshaus.",
    ["art_scan_already"]                  = "Ein Scan läuft bereits.",
    ["art_tt_stack"]                      = "Stapel",
    ["art_tt_scanned"]                    = "Gescannt",
    ["art_tt_just_now"]                   = "gerade eben",
    ["art_tt_min_ago"]                    = "vor %dm",
    ["art_tt_hour_ago"]                   = "vor %dh",
    ["art_tt_day_ago"]                    = "vor %dt",
    ["tab_qol_rare_alert"]                = "Seltene Gegner",
    ["section_rare_alert"]                = "Seltene Gegner",
    ["opt_rare_alert_enable"]             = "Näherungswarnung für seltene Gegner aktivieren",
    ["opt_rare_alert_sound"]              = "Warnton abspielen",
    ["opt_rare_alert_duration"]           = "Anzeigedauer des Banners (Sek.)",
    ["btn_reset_rare_alert_pos"]          = "Bannerposition zurücksetzen",
    ["rare_alert_info"]                   = "Warnt dich, wenn ein seltener NSC in der Nähe ist. Klicke auf das Banner, um ihn ins Visier zu nehmen, die Totenkopfmarkierung zu setzen und einen Wegpunkt anzulegen. Rechtsklick zum Schließen. Mit /tm layout lässt sich das Banner verschieben.",
    ["rare_alert_tooltip"]                = "Linksklick: anvisieren + Totenkopf + Wegpunkt. Rechtsklick: schließen.",

    -- =====================
    -- 3.3.2 — Was ist neu
    -- =====================

    -- =====================
    -- 3.3.3 — Was ist neu
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
    -- 3.5.7 — Was ist neu
    -- =====================

    -- =====================
    -- 3.5.5 — Was ist neu
    -- =====================

    -- =====================
    -- 3.5.4 — Was ist neu

    -- =====================
    -- 3.5.3 — Was ist neu

    -- 3.5.2 — Was ist neu
    -- =====================

    -- =====================
    -- 3.5.1 — Was ist neu
    -- =====================

    -- =====================
    -- 3.4.6 — Was ist neu
    -- =====================


    -- =====================
    -- 3.4.5 — Was ist neu
    -- =====================


    -- =====================
    -- 3.4.4 — Was ist neu
    -- =====================


    -- =====================
    -- 3.4.3 — Was ist neu
    -- =====================

    -- =====================
    -- 3.4.2 — Was ist neu
    -- =====================

    -- =====================
    -- 3.4.1 — Was ist neu
    -- =====================

    -- =====================
    -- 3.3.6 — Was ist neu
    -- =====================

    -- =====================
    -- 3.3.5 — Was ist neu
    -- =====================

    -- =====================
    -- 3.3.4 — Was ist neu
    -- =====================

    -- =====================
    -- QOL: Companion Status (Begleiter-Erinnerung)
    -- =====================
    ["tab_qol_companion"]             = "Begleiter-Hinweis",
    ["section_companion"]             = "Begleiterstatus",
    ["info_companion_desc"]           = "Zeigt einen Hinweis, wenn dein Begleiter fehlt oder tot ist. Erscheint nur bei Spezialisierungen, die tatsächlich einen nutzen: Tierherrschafts- und Überlebensjäger, alle Hexenmeister und unheilige Todesritter. Einsamer Wolf und Foliant des Opfers deaktivieren ihn von selbst.",
    ["info_companion_unavailable"]    = "Das Modul ist noch nicht fertig geladen. Öffne diesen Reiter gleich erneut.",
    ["opt_companion_enable"]          = "Begleiter-Hinweis aktivieren",
    ["opt_companion_hide_mounted"]    = "Auf Bodenreittier ausblenden",
    ["info_companion_travel"]         = "Der Hinweis ist im Flug, auf Flugrouten und in Fahrzeugen immer ausgeblendet. Deaktiviere dies, um ihn auf einem Bodenreittier weiterhin zu sehen.",
    ["opt_companion_display_mode"]    = "Anzeige",
    ["companion_mode_icon"]           = "Symbol",
    ["companion_mode_text"]           = "Text",
    ["companion_mode_both"]           = "Beides",
    ["opt_companion_scale"]           = "Skalierung",
    ["opt_companion_size"]            = "Symbolgröße",
    ["sublabel_companion_pos"]        = "Position",
    ["opt_companion_x"]               = "Horizontaler Versatz",
    ["opt_companion_y"]               = "Vertikaler Versatz",
    ["btn_companion_reset_pos"]       = "Position zurücksetzen",
    ["info_companion_slash"]          = "Befehle: /cs on, /cs off, /cs mounted, /cs debug.",
    ["companion_pet_missing"]         = "Begleiter fehlt",
    ["companion_pet_dead"]            = "Begleiter tot",

    -- ActionBars: Secure Visibility Engine
    ["Secure Visibility"] = "Sichere Sichtbarkeit",
    ["Visibility Mode"] = "Sichtbarkeitsmodus",
    ["Always"] = "Immer",
    ["In Combat"] = "Im Kampf",
    ["Out of Combat"] = "Außerhalb des Kampfes",
    ["Solo"] = "Solo",
    ["Party Only"] = "Nur Gruppe",
    ["Raid Only"] = "Nur Schlachtzug",
    ["Any Instance"] = "Beliebige Instanz",
    ["Mounted"] = "Auf Reittier",
    ["Has Target"] = "Mit Ziel",
    ["Hostile Target"] = "Feindliches Ziel",
    ["Hidden"] = "Ausgeblendet",
    ["Custom Condition"] = "Benutzerdefinierte Bedingung",
    ["Securely show or hide this bar based on game state. These rules keep working in combat without normal Lua Show/Hide calls."] = "Blendet diese Leiste abhängig vom Spielzustand sicher ein oder aus. Die Regeln funktionieren auch im Kampf ohne normale Lua-Show/Hide-Aufrufe.",

    -- ActionBars: Secure Paging
    ["Secure Paging"] = "Sicherer Seitenwechsel",
    ["Securely switch Action Bar 1 by modifier, target, form, skyriding, or manual page. Vehicle and override pages always keep priority."] = "Wechselt Aktionsleiste 1 sicher nach Modifikatortaste, Ziel, Gestalt, Himmelsreiten oder manueller Seite. Fahrzeug- und Überschreibungsseiten haben immer Vorrang.",
    ["Alt Modifier Page"] = "Seite mit Alt",
    ["Shift Modifier Page"] = "Seite mit Umschalt",
    ["Ctrl Modifier Page"] = "Seite mit Strg",
    ["Friendly Target Page"] = "Seite bei freundlichem Ziel",
    ["Hostile Target Page"] = "Seite bei feindlichem Ziel",
    ["Disable Automatic Form Paging"] = "Automatischen Gestaltwechsel deaktivieren",
    ["Disable Automatic Skyriding Paging"] = "Automatischen Himmelsreitwechsel deaktivieren",
    ["Default (no page switch)"] = "Standard (kein Seitenwechsel)",
    ["Action Bar 1"] = "Aktionsleiste 1",
    ["Action Bar 2"] = "Aktionsleiste 2",
    ["Action Bar 3"] = "Aktionsleiste 3",
    ["Action Bar 4"] = "Aktionsleiste 4",
    ["Action Bar 5"] = "Aktionsleiste 5",
    ["Action Bar 6"] = "Aktionsleiste 6",
    ["Action Bar 7"] = "Aktionsleiste 7",
    ["Action Bar 8"] = "Aktionsleiste 8",

    -- =====================
    -- HEALER STUDIO (advanced Party/Raid healer indicators)
    -- =====================
    ["btn_open_healerstudio"]    = "Healer Studio oeffnen",
    ["info_healerstudio"]        = "Erweitertes Profil: waehle deine HoTs, Schilde und Heilbuffs und platziere jedes Symbol frei auf der Zelle. Ersetzt die Reihe darueber, wenn aktiviert.",
    ["hs_list"]                  = "AUREN",
    ["hs_mode"]                  = "Profil",
    ["hs_mode_party"]            = "Gruppe",
    ["hs_mode_raid"]             = "Schlachtzug",
    ["hs_class"]                 = "Klasse",
    ["hs_enable"]                = "Erweitertes Profil aktivieren",
    ["hs_healer_only"]           = "Nur in einer Heiler-Spezialisierung",
    ["hs_show_duration"]         = "Verbleibende Sekunden anzeigen",
    ["hs_show_duration_info"]    = "Ausgeschaltet behält das Symbol seinen Cooldown-Sweep und verliert nur die Zahl darüber. Nützlich bei kleinen Symbolen, bei denen die Ziffern fast das ganze Bild verdecken.",
    ["hs_mode_on"]               = "Erweitertes Profil aktiv: die klassische HoT-Reihe ist auf diesen Zellen ausgeblendet.",
    ["hs_mode_off"]              = "Die klassische HoT-Reihe bleibt aktiv, solange dieses Profil deaktiviert ist.",
    ["hs_preset"]                = "Startvorlage",
    ["hs_reset_class"]           = "Diese Klasse zuruecksetzen",
    ["hs_reset_position"]        = "Position zuruecksetzen",
    ["hs_select"]                = "Waehle eine Aura in der Liste, um sie zu platzieren.",
    ["hs_size"]                  = "Symbolgroesse",
    ["hs_anchor"]                = "Ankerpunkt",
    ["hs_offset_x"]              = "Horizontaler Versatz",
    ["hs_offset_y"]              = "Vertikaler Versatz",
    ["hs_hint"]                  = "Ziehe die Symbole auf die Zelle - Aenderungen werden sofort gespeichert",
    ["hs_combat"]                = "die Anordnung kann im Kampf nicht geaendert werden.",
    ["hs_cat_hot"]               = "HoT",
    ["hs_cat_shield"]            = "Schild",
    ["hs_cat_beacon"]            = "Verbindung",
    ["hs_cat_marker"]            = "Heilungsmarker",
    ["hs_cat_external"]          = "Externer Schutz",

    -- Slash command output (Core/Init.lua, CooldownManager, UnitFrames)
    ["cli_after_combat"]       = "nach dem Kampf",
    ["cli_reload_required"]    = "/reload erforderlich",
    ["cli_dependents_off"]     = "abhaengige Module deaktiviert:",
    ["cli_deps_off"]           = "deaktivierte Abhaengigkeiten:",
    ["cli_pending_reload"]     = "%s warten auf /reload",
    ["cli_mod_live"]           = "%d sofort",
    ["cli_mod_reload"]         = "%d per /reload",
    ["cli_mod_none"]           = "%d ohne Umschalter",
    ["cli_modules_hint"]       = "/tm modules <Schluessel> zum Umschalten",
    ["cli_backup_created"]     = "Sicherung erstellt.",
    ["cli_backup_usage"]       = "/tm backup save | /tm backup restore [Nummer]",
    ["cli_layout_usage"]       = "/tm layout export|import <Text>",
    ["cli_capture_failed"]     = "Erfassung fehlgeschlagen",
    ["cli_res_counts"]         = "%d Schriftarten, %d Anker",
    ["msg_help_install"]       = "Einrichtungsassistenten erneut starten",
    ["msg_help_loot"]          = "Beute-Browser oeffnen (Dungeons & Schlachtzuege)",
    ["msg_cdm_placement_mode"] = "Platzierungsmodus",
    ["msg_cdm_live_preview"]   = "Live-Vorschau",
    ["msg_uf_ouf_missing"]     = "oUF-Bibliothek nicht gefunden (X-oUF: TomoMod_oUF)!",

})
