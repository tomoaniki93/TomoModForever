-- =====================================
-- itIT.lua — Italiano
-- =====================================

-- Perf: Lua builds the whole table constructor below before
-- TomoMod_RegisterLocale can decide to discard it. For a player on any other
-- locale that is ~2900 key/value pairs allocated and turned straight into
-- garbage, five files over, on every /reload. The chunk still compiles (the
-- TOC loads it), but the constructor never runs.
if GetLocale() ~= "itIT" then return end

TomoMod_RegisterLocale("itIT", {

    -- =====================
    -- CONFIG: Categories (ConfigUI.lua)
    -- =====================
    ["cat_general"]         = "Generale",
    ["cat_unitframes"]      = "UnitFrames",
    ["cat_nameplates"]      = "Nameplates",
    ["cat_cd_resource"]     = "CD e Risorse",
    ["cat_qol"]             = "Qualità della vita",
    ["cat_mythicplus"]      = "Mythic+",
    ["cat_profiles"]        = "Profili",
    ["cat_diagnostics"]     = "Diagnostica",
    ["cat_housing"]         = "Housing",

    -- =====================
    -- CONFIG: General Panel
    -- =====================
    ["section_about"]                   = "Informazioni",
    ["about_text"]                      = "|cffffd100TomoModForever|r %s di TomoAniki\nInterfaccia leggera con QOL, UnitFrames e Nameplates.\nDigita /tm help per la lista dei comandi.",
    ["section_general"]                 = "Generale",
    ["btn_reset_all"]                   = "Ripristina tutto",
    ["info_reset_all"]                  = "Questo ripristinerà TUTTE le impostazioni e ricaricherà l'interfaccia.",

    -- Minimap
    ["section_minimap"]                 = "Minimappa",
    ["opt_minimap_enable"]              = "Attiva minimappa personalizzata",
    ["opt_size"]                        = "Dimensione",
    ["opt_scale"]                       = "Scala",
    ["opt_border"]                      = "Bordo",
    ["border_class"]                    = "Colore di classe",
    ["border_black"]                    = "Nero",

    -- Info Panel
    ["section_info_panel"]              = "Pannello informazioni",
    ["opt_enable"]                      = "Attiva",
    ["opt_durability"]                  = "Durabilità (Equipaggiamento)",
    ["info_durability_position"]        = "Posizione del testo di durabilità — utile se un pulsante (es. espansione) si sovrappone all'angolo predefinito.",
    ["opt_durability_corner"]           = "Angolo (durabilità)",
    ["opt_time"]                        = "Orario",
    ["opt_24h_format"]                  = "Formato 24h",
    ["opt_show_coords"]                 = "Mostra coordinate",
    ["btn_reset_position"]              = "Ripristina posizione",

    -- Cursor Ring
    ["section_cursor_ring"]             = "Anello del cursore",
    ["opt_class_color"]                 = "Colore di classe",
    ["opt_anchor_tooltip_ring"]         = "Ancora tooltip al cursore",

    -- =====================
    -- CONFIG: UnitFrames Panel
    -- =====================
    -- Tabs
    ["tab_general"]                     = "Generale",
    ["tab_player"]                      = "Giocatore",
    ["tab_target"]                      = "Bersaglio",
    ["tab_tot"]                         = "BdB",
    ["tab_pet"]                         = "Famiglio",
    ["tab_focus"]                       = "Focus",
    ["tab_colors"]                      = "Colori",

    -- Sub-tabs (Player, Target, Focus)
    ["subtab_dimensions"]               = "Dimensioni",
    ["subtab_display"]                  = "Visualizzazione",
    ["subtab_auras"]                    = "Aure",
    ["subtab_positioning"]              = "Posizione",

    -- Sub-labels
    ["sublabel_dimensions"]             = "— Dimensioni —",
    ["sublabel_display"]                = "— Visualizzazione —",
    ["sublabel_castbar"]                = "— Barra di lancio —",
    ["sublabel_auras"]                  = "— Aure —",
    ["sublabel_element_offsets"]        = "— Posizioni elementi —",

    -- Unit display names
    ["unit_player"]                     = "Giocatore",
    ["unit_target"]                     = "Bersaglio",
    ["unit_tot"]                        = "Bersaglio del bersaglio",
    ["unit_pet"]                        = "Famiglio",
    ["unit_focus"]                      = "Focus",

    -- General tab
    ["section_general_settings"]        = "Impostazioni generali",
    ["opt_uf_enable"]                   = "Attiva UnitFrames di TomoMod",
    ["opt_hide_blizzard"]               = "Nascondi frame di Blizzard",
    ["opt_global_font_size"]            = "Dimensione font globale",
    ["sublabel_font"]                   = "— Font —",
    ["opt_font_family"]                 = "Famiglia di font",

    -- Castbar colors
    ["section_castbar_colors"]          = "Colori barra di lancio",
    ["info_castbar_colors"]             = "Personalizza i colori della barra di lancio per incantesimi interrompibili, non interrompibili e interrotti.",
    ["opt_castbar_color"]               = "Incantesimo interrompibile",
    ["opt_castbar_ni_color"]            = "Incantesimo non interrompibile",
    ["opt_castbar_interrupt_color"]     = "Incantesimo interrotto",
    ["info_castbar_colors_reload"]      = "Le modifiche ai colori si applicano ai nuovi lanci. /reload per effetto completo.",
    ["btn_toggle_lock"]                 = "Blocca/Sblocca (/tm uf)",
    ["info_unlock_drag"]                = "Sblocca per spostare i frame. Le posizioni vengono salvate automaticamente.",

    -- Per-unit options
    ["opt_width"]                       = "Larghezza",
    ["opt_health_height"]               = "Altezza vita",
    ["opt_power_height"]                = "Altezza risorsa",
    ["opt_show_name"]                   = "Mostra nome",
    ["opt_name_truncate"]               = "Tronca nomi lunghi",
    ["opt_name_truncate_length"]        = "Lunghezza max. nome",
    ["opt_show_level"]                  = "Mostra livello",
    ["opt_show_health_text"]            = "Mostra testo vita",
    ["opt_health_format"]               = "Formato vita",
    ["fmt_current"]                     = "Attuale (25.3K)",
    ["fmt_percent"]                     = "Percentuale (75%)",
    ["fmt_current_percent"]             = "Attuale + % (25.3K | 75%)",
    ["fmt_current_max"]                 = "Attuale / Max",
    ["opt_class_color_uf"]              = "Colore di classe",
    ["opt_faction_color"]               = "Colore di fazione (PNG)",
    ["opt_use_nameplate_colors"]        = "Colori Nameplate (tipo di PNG)",
    ["opt_show_absorb"]                 = "Barra di assorbimento",
    ["opt_show_threat"]                 = "Indicatore di minaccia (bagliore bordo)",
    ["section_threat_text"]             = "Testo % minaccia",
    ["opt_threat_text_enable"]          = "Mostra % di minaccia sul bersaglio",
    ["opt_threat_text_font_size"]       = "Dimensione font",
    ["info_threat_text"]                = "Verde = tank (vantaggio), giallo = avviso, rosso = aggro perso",
    ["opt_show_leader_icon"]            = "Icona leader",
    ["opt_leader_icon_x"]               = "Icona leader X",
    ["opt_leader_icon_y"]               = "Icona leader Y",
    ["opt_raid_icon_x"]                 = "Marcatore raid X",
    ["opt_raid_icon_y"]                 = "Marcatore raid Y",

    -- Castbar
    ["opt_castbar_enable"]              = "Attiva barra di lancio",
    ["opt_castbar_width"]               = "Larghezza barra di lancio",
    ["opt_castbar_height"]              = "Altezza barra di lancio",
    ["opt_castbar_show_icon"]           = "Mostra icona",
    ["opt_castbar_show_timer"]          = "Mostra timer",
    ["info_castbar_drag"]               = "Posizione: /tm sr per sbloccare e spostare la barra di lancio.",
    ["btn_reset_castbar_position"]      = "Ripristina posizione barra di lancio",
    ["opt_castbar_show_latency"]        = "Mostra latenza",

    -- Auras
    ["opt_auras_enable"]                = "Attiva aure",
    ["opt_auras_max"]                   = "Aure massime",
    ["opt_auras_size"]                  = "Dimensione icona",
    ["opt_auras_type"]                  = "Tipo di aura",
    ["aura_harmful"]                    = "Debuff (dannosi)",
    ["aura_helpful"]                    = "Buff (benefici)",
    ["aura_all"]                        = "Benefici e penalità",
    ["opt_auras_direction"]             = "Direzione di crescita",
    ["opt_auras_direction_v"]           = "Direzione verticale",
    ["aura_dir_down"]                   = "Verso il basso",
    ["aura_dir_up"]                     = "Verso l'alto",
    ["aura_dir_right"]                  = "Verso destra",
    ["aura_dir_left"]                   = "Verso sinistra",
    ["opt_auras_only_mine"]             = "Solo le mie aure",

    -- Element offsets
    ["elem_name"]                       = "Nome",
    ["elem_level"]                      = "Livello",
    ["elem_health_text"]                = "Testo vita",
    ["elem_power"]                      = "Barra risorsa",
    ["elem_castbar"]                    = "Barra di lancio",
    ["elem_auras"]                      = "Aure",
    ["elem_enemy_buffs"]                = "Benefici del bersaglio",

    -- AstralForge: element registry
    ["elem_raid_icon"]                  = "Simbolo incursione",
    ["elem_leader_icon"]                = "Icona capogruppo",
    ["elem_threat_text"]                = "Testo minaccia",
    ["opt_element_anchor"]              = "Ancoraggio",
    ["btn_reset_elements"]              = "Reimposta posizione elementi",
    ["anchor_host_frame"]               = "Riquadro",
    ["anchor_host_health"]              = "Barra della vita",
    ["anchor_host_power"]               = "Barra risorsa",
    ["anchor_host_infobar"]             = "Barra info",
    ["btn_open_astralforge"]            = "Apri AstralForge",
    ["info_astralforge"]                = "AstralForge è il designer completo: trascina ogni elemento direttamente sul riquadro e scegli il punto di ancoraggio e l'host. I cursori qui sotto restano disponibili per regolazioni al pixel.",
    ["target_kind_host"]                = "Struttura: ",
    ["target_kind_element"]             = "Elemento: ",

    -- AstralForge : proprietes par element
    ["sublabel_element_props"]          = "Proprietà visive",
    ["opt_element_alpha"]               = "Opacità (%)",
    ["opt_element_scale"]               = "Scala (%)",
    ["opt_element_font_size"]           = "Forza dimensione carattere",
    ["info_element_font_size"]          = "Lascia a 0 per mantenere la dimensione calcolata dal modulo.",

    -- AstralForge : elements instancies
    ["elem_custom_text"]                = "Testo personalizzato",
    ["opt_custom_text_template"]        = "Modello di testo",
    ["info_custom_text_tokens"]         = "Segnaposto disponibili:",
    ["btn_add_custom_text"]             = "Aggiungi un testo personalizzato",
    ["btn_reset_element"]               = "Reimposta questo elemento",
    ["btn_delete_element"]              = "Elimina questo elemento",
    ["msg_element_max_reached"]         = "Numero massimo di elementi di questo tipo raggiunto.",

    -- AstralForge : presets de disposition
    ["section_forge_presets"]           = "Preimpostazioni di layout",
    ["btn_forge_presets"]               = "Preimpostazioni di layout",
    ["info_forge_presets"]              = "Una preimpostazione salva l'intero layout del soggetto corrente: ancoraggi, proprietà visive ed elementi personalizzati.",
    ["opt_preset_name"]                 = "Nome della preimpostazione",
    ["btn_preset_save"]                 = "Salva / sovrascrivi",
    ["opt_preset_saved"]                = "Preimpostazioni salvate",
    ["btn_preset_apply"]                = "Applica",
    ["btn_preset_delete"]               = "Elimina",
    ["btn_preset_export"]               = "Genera stringa di condivisione",
    ["opt_preset_share_string"]         = "Stringa di condivisione",
    ["info_preset_copy"]                = "Clicca nel campo, poi Ctrl+A e Ctrl+C per copiare.",
    ["opt_preset_import"]               = "Incolla una stringa di condivisione",
    ["btn_preset_import"]               = "Importa",
    ["info_no_preset"]                  = "Nessuna preimpostazione salvata per questo soggetto.",
    ["msg_preset_saved"]                = "Preimpostazione salvata.",
    ["msg_preset_applied"]              = "Preimpostazione applicata.",
    ["msg_preset_imported"]             = "Preimpostazione importata:",
    ["msg_preset_error"]                = "Operazione sulla preimpostazione fallita.",
    ["msg_presets_unavailable"]         = "Le preimpostazioni di layout non sono disponibili.",
    ["token_classification"]            = "Classificazione",
    ["token_name"]                      = "Nome",
    ["token_level"]                     = "Livello",
    ["token_class"]                     = "Classe",
    ["token_race"]                      = "Razza",
    ["token_guild"]                     = "Gilda",

    -- AstralForge : domaine plaques de nom
    ["section_np_elements"]             = "Posizione degli elementi",
    ["info_np_elements"]                = "Apri AstralForge per trascinare ogni elemento sulla targhetta e scegliere il suo ancoraggio. I cursori qui sotto servono per regolazioni al pixel.",
    ["np_host_plate"]                   = "Targhetta",
    ["np_host_health"]                  = "Barra della vita",
    ["np_host_castbar"]                 = "Barra di lancio",
    ["np_host_name"]                    = "Nome",
    ["np_elem_name"]                    = "Nome",
    ["np_elem_hp_number"]               = "Valore vita",
    ["np_elem_hp_percent"]              = "Percentuale vita",
    ["np_elem_level"]                   = "Livello",
    ["np_elem_class_icon"]              = "Icona classificazione",
    ["np_elem_class_text"]              = "Testo classificazione",
    ["np_elem_castbar"]                 = "Barra di lancio",
    ["np_elem_cast_icon"]               = "Icona di lancio",
    ["np_elem_cast_text"]               = "Nome incantesimo",
    ["np_elem_cast_timer"]              = "Timer di lancio",
    ["np_elem_cast_shield"]             = "Scudo di lancio",
    ["np_elem_quest_icon"]              = "Icona missione",
    ["np_elem_raid_marker"]             = "Simbolo incursione",

    -- =====================
    -- CONFIG: Nameplates Panel
    -- =====================
    -- Nameplate tabs
    ["tab_np_auras"]                    = "Aure",
    ["tab_np_advanced"]                 = "Avanzato",
    ["info_np_colors_custom"]           = "Ogni colore può essere personalizzato cliccando sul campione di colore.",

    ["section_np_general"]              = "Impostazioni generali",
    ["opt_np_enable"]                   = "Attiva Nameplates di TomoMod",
    ["info_np_description"]             = "Sostituisce le nameplates di Blizzard con uno stile minimalista personalizzabile.",
    ["section_dimensions"]              = "Dimensioni",
    ["opt_np_name_font_size"]           = "Dimensione font nome",

    -- Display
    ["section_display"]                 = "Visualizzazione",
    ["opt_np_show_classification"]      = "Mostra classificazione (élite, raro, boss)",
    ["opt_np_show_absorb"]               = "Mostra barra di assorbimento",
    ["opt_np_class_colors"]             = "Colori di classe (giocatori)",
    ["opt_np_friendly_name_only"]       = "Alleati: solo nome (senza barra vita)",
    ["opt_np_friendly_role_icons"]      = "Mostra icone ruolo (dungeon/delve)",
    ["opt_np_role_show_tank"]           = "Mostra icona Tank",
    ["opt_np_role_show_healer"]         = "Mostra icona Healer",
    ["opt_np_role_show_dps"]            = "Mostra icona DPS",
    ["opt_np_role_icon_size"]           = "Dimensione icona ruolo",

    -- Raid Marker
    ["section_raid_marker"]             = "Indicatore del raid",
    ["opt_np_raid_icon_x"]              = "Offset X",
    ["opt_np_raid_icon_y"]              = "Offset Y",
    ["opt_np_raid_icon_size"]           = "Dimensione icona",

    -- Castbar
    ["section_castbar"]                 = "Barra di lancio",
    ["opt_np_show_castbar"]             = "Mostra barra di lancio",
    ["opt_np_castbar_height"]           = "Altezza barra di lancio",
    ["color_castbar"]                   = "Barra di lancio (interrompibile)",
    ["color_castbar_uninterruptible"]   = "Barra di lancio (non interrompibile)",

    -- Auras
    ["section_auras"]                   = "Aure",
    ["opt_np_show_auras"]               = "Mostra aure",
    ["opt_np_aura_size"]                = "Dimensione icona",
    ["opt_np_max_auras"]                = "Conteggio massimo",
    ["opt_np_only_my_debuffs"]          = "Solo i miei debuff",

    -- Enemy Buffs
    ["section_enemy_buffs"]              = "Buff nemici",
    ["sublabel_enemy_buffs"]             = "— Buff nemici —",
    ["opt_enemy_buffs_enable"]           = "Mostra buff nemici",
    ["opt_enemy_buffs_max"]              = "Max. buff",
    ["opt_enemy_buffs_size"]             = "Dimensione icona buff",
    ["opt_enemy_buffs_direction"]        = "Direzione",
    ["opt_enemy_buffs_per_row"]          = "Icone per riga",
    ["opt_enemy_buffs_row_orientation"]  = "Riga successiva",
    ["info_enemy_buffs"]                 = "Mostra i buff attivi (Furia, scudi...) sulle unità ostili. Le icone appaiono in alto a destra, impilate verso l'alto.",
    ["opt_np_show_enemy_buffs"]          = "Mostra buff nemici",
    ["opt_np_enemy_buff_size"]           = "Dimensione icona buff",
    ["opt_np_max_enemy_buffs"]           = "Max. buff nemici",
    ["opt_np_enemy_buff_y_offset"]       = "Offset Y buff nemici",

    -- Transparency
    ["section_transparency"]            = "Trasparenza",
    ["opt_np_selected_alpha"]           = "Alfa selezionato",
    ["opt_np_unselected_alpha"]         = "Alfa non selezionato",

    -- Stacking
    ["section_stacking"]                = "Impilamento",
    ["opt_np_overlap"]                  = "Sovrapposizione verticale",
    ["opt_np_top_inset"]                = "Limite superiore schermo",

    -- Colors
    ["section_colors"]                  = "Colori",
    ["color_hostile"]                   = "Ostile (Nemico)",
    ["color_neutral"]                   = "Neutrale",
    ["color_friendly"]                  = "Amichevole",
    ["color_tapped"]                    = "Contrassegnato (tapped)",
    ["color_focus"]                     = "Bersaglio focus",

    -- NPC Type Colors
    ["section_npc_type_colors"]         = "Colori tipo PNG",
    ["color_caster"]                    = "Incantatore",
    ["color_miniboss"]                  = "Mini-boss (élite + livello superiore)",
    ["color_enemy_in_combat"]           = "Nemico (predefinito)",
    ["info_np_darken_ooc"]              = "I nemici fuori combattimento vengono automaticamente oscurati.",

    -- Classification colors
    ["section_classification_colors"]   = "Colori classificazione",
    ["opt_np_use_classification"]       = "Colori per tipo di nemico",
    ["color_boss"]                      = "Boss",
    ["color_elite"]                     = "Élite / Mini-boss",
    ["color_rare"]                      = "Raro",
    ["color_normal"]                    = "Normale",
    ["color_trivial"]                   = "Insignificante",

    -- Tank mode
    ["section_tank_mode"]               = "Modalità tank",
    ["opt_np_tank_mode"]                = "Attiva modalità tank (colori minaccia)",
    ["color_no_threat"]                 = "Nessuna minaccia",
    ["color_low_threat"]                = "Minaccia bassa",
    ["color_has_threat"]                = "Minaccia mantenuta",
    ["color_dps_has_aggro"]             = "DPS/Guaritore ha aggro",
    ["color_dps_near_aggro"]            = "DPS/Guaritore vicino all'aggro",

    -- NP health format
    ["np_fmt_percent"]                  = "Percentuale (75%)",
    ["np_fmt_current"]                  = "Attuale (25.3K)",
    ["np_fmt_current_percent"]          = "Attuale + %",

    -- Reset
    ["btn_reset_nameplates"]            = "Ripristina Nameplates",

    -- =====================
    -- CONFIG: CD & Resource Panel
    -- =====================
    -- Resource colors
    ["section_resource_colors"]         = "Colori risorse",
    ["res_runes_ready"]                 = "Rune (pronte)",
    ["res_runes_cd"]                    = "Rune (ricarica)",

    -- Cooldown Manager
    ["tab_cdm"]                         = "Ricariche",
    ["tab_cdm_bars"]                    = "Barre",
    ["tab_resource_bars"]               = "Barre risorse",
    ["tab_text_position"]               = "Testo e posizione",
    ["tab_rb_colors"]                   = "Colori",
    ["info_rb_colors_custom"]           = "Ogni colore può essere personalizzato cliccando sul campione di colore.",

    ["section_cdm"]                     = "Gestore ricariche",
    ["opt_cdm_enable"]                  = "Attiva gestore ricariche",
    ["info_cdm_description"]            = "Reskin delle icone del CooldownManager di Blizzard: bordi arrotondati, overlay di classe sulle aure attive, colori di sweep personalizzati, dimming utilità, layout centrato. Posizionamento tramite Edit Mode di Blizzard.",
    ["opt_cdm_show_hotkeys"]            = "Mostra tasti rapidi",
    ["opt_cdm_combat_alpha"]            = "Modifica opacità (combattimento / bersaglio)",
    ["opt_cdm_alpha_combat"]            = "Alfa in combattimento",
    ["opt_cdm_alpha_target"]            = "Alfa con bersaglio (fuori combattimento)",
    ["opt_cdm_alpha_ooc"]               = "Alfa fuori combattimento",
    ["section_cdm_overlay"]             = "Overlay e bordi",
    ["opt_cdm_custom_overlay"]          = "Colore overlay personalizzato",
    ["opt_cdm_overlay_color"]           = "Colore overlay",
    ["opt_cdm_custom_swipe"]            = "Colore sweep attivo personalizzato",
    ["opt_cdm_swipe_color"]             = "Colore sweep",
    ["opt_cdm_swipe_alpha"]             = "Opacità sweep",
    ["section_cdm_utility"]             = "Utilità",
    ["opt_cdm_dim_utility"]             = "Attenua icone utilità quando non in CD",
    ["opt_cdm_dim_opacity"]             = "Opacità attenuazione",
    ["opt_cdm_bufficon_direction"]        = "Direzione icone buff",
    ["opt_cdm_buffbar_direction"]         = "Direzione BuffBar",
    ["opt_cdm_buffbar_width"]             = "Larghezza barra (orizzontale)",
    ["buffbar_vertical"]                  = "Verticale",
    ["buffbar_horizontal"]                = "Orizzontale",
    ["dir_centered"]                      = "Centrato (orizzontale)",
    ["dir_left"]                          = "Sinistra",
    ["dir_right"]                         = "Destra",
    ["dir_up"]                            = "Su",
    ["dir_down"]                          = "Giù",
    ["info_cdm_editmode"]               = "Il posizionamento avviene tramite l'Edit Mode di Blizzard (Esc |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Edit Mode).",

    -- CDM V3.2: Posizionamento e card viewer (Phase 4)
    ["section_cdm_placement"]            = "Posizionamento e anteprima live",
    ["info_cdm_placement"]               = "Le barre CDM sono ora posizionate da TomoMod (non serve più l'Edit Mode di Blizzard). La modalità di posizionamento mostra icone fittizie e permette di trascinare ogni barra.",
    ["btn_cdm_unlock"]                   = "Modalità posizionamento (live)",
    ["opt_cdm_preview"]                  = "Anteprima (icone fittizie)",
    ["info_cdm_preview_live"]            = "Le impostazioni per barra si trovano nella scheda «Barre» — tutto si applica in tempo reale.",
    ["info_cdm_bars"]                    = "Ogni barra ha una propria posizione e disposizione. Attiva l'anteprima per vedere le modifiche in tempo reale, oppure la modalità posizionamento per trascinare le barre con il mouse.",
    ["btn_cdm_reset_pos"]                = "Reimposta posizioni",
    ["msg_cdm_pos_reset"]                = "Posizioni CDM reimpostate.",
    ["section_cdm_essential"]            = "Essential (incantesimi principali)",
    ["section_cdm_utility_bar"]          = "Utility (incantesimi di utilità)",
    ["section_cdm_bufficons"]            = "Icone buff (aure — icone)",
    ["section_cdm_buffbars"]             = "Barre buff (aure — barre)",
    ["opt_cdm_pos_x"]                    = "Posizione X",
    ["opt_cdm_pos_y"]                    = "Posizione Y",
    ["opt_cdm_icon_size"]                = "Dimensione icone (0 = auto)",
    ["opt_cdm_spacing"]                  = "Spaziatura",
    ["opt_cdm_row_limit"]                = "Per riga (0 = illimitato)",
    ["opt_cdm_direction"]                = "Direzione",
    ["opt_cdm_secondary_direction"]      = "Direzione secondaria",
    ["opt_cdm_buffbar_spacing"]          = "Spaziatura",
    ["secdir_auto"]                      = "Auto",
    ["secdir_down"]                      = "Righe verso il basso",
    ["secdir_up"]                        = "Righe verso l'alto",
    ["secdir_right"]                     = "Colonne verso destra",
    ["secdir_left"]                      = "Colonne verso sinistra",

    -- Resource Bars
    ["section_resource_bars"]           = "Barre risorse",
    ["opt_rb_enable"]                   = "Attiva barre risorse",
    ["info_rb_description"]             = "Mostra le risorse di classe (Mana, Ira, Energia, Punti combo, Rune, ecc.) con supporto adattativo per i Druidi.",
    ["section_visibility"]              = "Visibilità",
    ["opt_rb_visibility_mode"]          = "Modalità visibilità",
    ["vis_always"]                      = "Sempre visibile",
    ["vis_combat"]                      = "Solo in combattimento",
    ["vis_target"]                      = "Combattimento o bersaglio",
    ["vis_hidden"]                      = "Nascosto",
    ["opt_rb_combat_alpha"]             = "Alfa in combattimento",
    ["opt_rb_ooc_alpha"]                = "Alfa fuori combattimento",
    ["opt_rb_width"]                    = "Larghezza",
    ["opt_rb_classpower_height"]        = "Altezza potere di classe",
    ["opt_rb_druidmana_height"]         = "Altezza mana druido",
    ["opt_rb_global_scale"]             = "Scala globale",

    -- v2.9: Barra della vita (HUD)
    ["section_rb_healthbar"]            = "Barra della vita (HUD)",
    ["opt_rb_hb_enable"]                = "Mostra barra della vita",
    ["info_rb_healthbar"]               = "Barra della vita centrata sopra le risorse. Testo e colore soglia gestiti lato client (compatibili con Midnight).",
    ["opt_rb_hb_height"]                = "Altezza",
    ["opt_rb_hb_text"]                  = "Testo",
    ["hb_text_none"]                    = "Nessuno",
    ["hb_text_value"]                   = "Valore",
    ["hb_text_percent"]                 = "Percentuale",
    ["hb_text_both"]                    = "Valore | %",
    ["opt_rb_hb_classcolor"]            = "Colore di classe",
    ["opt_rb_hb_color"]                 = "Colore personalizzato (se colore di classe disattivato)",
    ["opt_rb_hb_threshold"]             = "Soglia vita bassa (cambia colore)",
    ["opt_rb_hb_threshold_pct"]         = "Soglia (%)",
    ["opt_rb_hb_threshold_color"]       = "Colore vita bassa",

    -- v2.9: Animazioni e barra del potere
    ["section_rb_anim"]                 = "Animazioni e barra del potere",
    ["opt_rb_smooth"]                   = "Animazioni fluide delle barre",
    ["opt_rb_full_glow"]                = "Bagliore al massimo della risorsa di classe",
    ["opt_rb_supercharged_points"]      = "Mostra punti combo sovraccarichi",
    ["opt_rb_power_ticks"]              = "Tacche sulla barra del potere (% del max)",
    ["ticks_none"]                      = "Nessuno",
    ["opt_rb_power_threshold"]          = "Soglia risorsa bassa (barra del potere)",
    ["opt_rb_power_threshold_pct"]      = "Soglia (%)",
    ["opt_rb_power_threshold_color"]    = "Colore risorsa bassa",
    ["info_rb_anim"]                    = "Tacche e soglia si applicano alla barra del potere centrata. Lo smoothing si applica anche alla barra della vita, al mana del druido e alle barre delle aure.",

    ["opt_rb_sync_width"]               = "Sincronizza larghezza con Essential Cooldowns",
    ["btn_sync_now"]                    = "Sincronizza ora",
    ["info_rb_sync"]                    = "Allinea la larghezza con l'EssentialCooldownViewer del CooldownManager di Blizzard.",

    -- Text & Font
    ["section_text_font"]               = "Testo e font",
    ["opt_rb_show_text"]                = "Mostra testo sulle barre",
    ["opt_rb_text_align"]               = "Allineamento testo",
    ["align_left"]                      = "Sinistra",
    ["align_center"]                    = "Centro",
    ["align_right"]                     = "Destra",
    ["opt_rb_font_size"]                = "Dimensione font",
    ["opt_rb_font"]                     = "Font",
    ["font_default_wow"]                = "Predefinito WoW",

    -- Position
    ["section_position"]                = "Posizione",
    ["info_rb_position"]                = "Usa /tm uf per sbloccare e spostare le barre. La posizione viene salvata automaticamente.",
    ["info_rb_druid"]                   = "Le barre si adattano automaticamente alla tua classe e specializzazione.\nDruido: la risorsa cambia in base alla forma (Orso |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Ira, Gatto |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Energia, Gufo |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Potere astrale).",

    -- =====================
    -- CONFIG: QOL Panel
    -- =====================
    ["tab_qol_cinematic"]               = "Filmato",
    ["tab_qol_auto_quest"]              = "Auto missioni",
    ["tab_qol_automations"]             = "Automazioni",
    ["tab_qol_mythic_keys"]             = "Chiavi M+",
    ["tab_qol_skyride"]                 = "SkyRide",
    ["tab_qol_action_bars"]             = "Barre d'azione",
    ["section_action_bars"]             = "Skin barre d'azione",
    ["section_ab_system"]               = "Action Bar System",
    ["opt_ab_system_enable"]            = "Enable TomoMod Action Bar system (requires reload)",
    ["opt_ab_system_reload"]            = "Disabling this fully restores Blizzard action bars after /reload.",
    ["section_ab_skin"]                 = "Visual Skin",

    -- ActionBars: LibKeyBound integration (Lot A9)
    ["btn_ab_kb_lib"]                       = "Modalità assegnazione (LibKeyBound)",
    ["info_ab_kb_lib"]                      = "Modalità di assegnazione condivisa, rilevata da un altro addon. Assegna le barre di TomoMod e quelle dell'altro addon nello stesso passaggio.",

    -- ActionBars: keybinding command labels (Lot A8)
    ["binding_category"]                    = "Barre delle azioni TomoMod",
    ["binding_bar_header"]                  = "Barra TomoMod %d",
    ["binding_button"]                      = "Barra %d Pulsante %d",

    ["options_load_failed"]             = "pannello delle opzioni non disponibile — l'addon TomoModForever_Options è attivo?",

    ["anchor_queue"]                    = "Occhio della coda",

    ["microbar_native_not_found"]       = "impossibile trovare il micro-menu di Blizzard da nascondere — segnalalo con la versione del client.",

    ["microbar_tt_perf"]                    = "Prestazioni",
    ["microbar_tt_fps"]                     = "Fotogrammi al secondo",
    ["microbar_tt_latency"]                 = "Latenza",
    ["microbar_tt_cpu"]                     = "CPU degli addon",
    ["microbar_tt_cpu_off"]                 = "profilazione disattivata",

    -- ActionBars: rebuilt panel on the Tui schema (lot P5)
    ["section_ab_totem"]                 = "Totem",
    ["opt_ab_totem_enabled"]             = "Barra dei totem",
    ["info_ab_totem"]                    = "Una barra che mostra i totem attivi e la loro durata residua. Posizionala in modalità disposizione.",
    ["mover_totembar"]                  = "Barra dei totem",
    ["opt_ab_flash"]                    = "Effetto alla pressione",
    ["info_ab_flash"]                   = "Cosa viene disegnato mentre un pulsante è premuto. La texture di TomoMod scurisce l'icona; quella Blizzard è il lampo standard.",
    ["info_ab_masque"]                      = "Ha effetto solo se Masque è installato. Lo stile integrato viene disattivato per evitare conflitti.",
    ["info_ab_nodb"]                        = "Impostazioni delle barre delle azioni non disponibili: il database non è inizializzato. Ricarica l'interfaccia.",
    ["opt_ab_assisted"]                     = "Evidenziazione assistita",
    ["opt_ab_backdrop"]                     = "Sfondo",
    ["opt_ab_backdrop_alpha"]               = "Opacità dello sfondo",
    ["opt_ab_borders"]                      = "Bordi",
    ["opt_ab_gloss"]                        = "Lucentezza",
    ["opt_ab_gloss_alpha"]                  = "Opacità della lucentezza",
    ["opt_ab_glow_color"]                   = "Colore del bagliore",
    ["opt_ab_glow_source"]                  = "Sorgente del bagliore",
    ["opt_ab_hide_empty"]                   = "Nascondi caselle vuote",
    ["opt_ab_hide_empty_keybinds"]          = "Nascondi il tasto sulle caselle vuote",
    ["opt_ab_icon_size"]                    = "Dimensione dei pulsanti",
    ["opt_ab_icon_skin"]                    = "Stile delle icone",
    ["opt_ab_keydown"]                      = "Lancia alla pressione del tasto",
    ["opt_ab_lock"]                         = "Blocca i pulsanti",
    ["opt_ab_mana_color"]                   = "Colore risorsa insufficiente",
    ["opt_ab_masque"]                       = "Lascia che Masque applichi lo stile",
    ["opt_ab_range"]                        = "Indicatore fuori portata",
    ["opt_ab_range_color"]                  = "Colore fuori portata",
    ["opt_ab_skin_enabled"]                 = "Applica lo stile ai pulsanti",
    ["opt_ab_spacing"]                      = "Spaziatura",
    ["opt_ab_tooltips"]                     = "Mostra i suggerimenti",
    ["opt_ab_usability"]                    = "Indicatore non utilizzabile",
    ["opt_ab_usability_color"]              = "Colore non utilizzabile",
    ["opt_abf_combat"]                      = "Sempre visibile in combattimento",
    ["opt_abf_delay"]                       = "Ritardo prima della dissolvenza",
    ["opt_abf_enabled"]                     = "Dissolvi le barre",
    ["opt_abf_in"]                          = "Durata della comparsa",
    ["opt_abf_link"]                        = "Collega le barre da 1 a 8",
    ["opt_abf_out"]                         = "Durata della scomparsa",
    ["opt_abf_out_alpha"]                   = "Opacità dissolta",
    ["opt_abt_anchor"]                      = "Posizione",
    ["opt_abt_color"]                       = "Colore",
    ["opt_abt_cooldowntext"]                = "Numeri di recupero",
    ["opt_abt_counts"]                      = "Cariche e pile",
    ["opt_abt_keybinds"]                    = "Scorciatoie",
    ["opt_abt_macronames"]                  = "Nomi delle macro",
    ["opt_abt_offx"]                        = "Scostamento orizzontale",
    ["opt_abt_offy"]                        = "Scostamento verticale",
    ["opt_abt_show"]                        = "Mostra",
    ["opt_abt_size"]                        = "Dimensione del carattere",
    ["opt_bar_buttons"]                     = "Numero di pulsanti",
    ["opt_bar_grow_left"]                   = "Cresci verso sinistra",
    ["opt_bar_grow_up"]                     = "Cresci verso l'alto",
    ["opt_bar_size"]                        = "Dimensione dei pulsanti",
    ["section_ab_behaviour"]                = "Comportamento",
    ["section_ab_chrome"]                   = "Cornice e sfondo",
    ["section_ab_fade"]                     = "Dissolvenza",
    ["section_ab_general"]                  = "Pulsanti",
    ["section_ab_states"]                   = "Stati",
    ["tab_ab_fade"]                         = "Dissolvenza",
    ["tab_ab_general"]                      = "Generale",
    ["tab_ab_indicators"]                   = "Indicatori",
    ["tab_ab_texts"]                        = "Testi",

    -- ActionBars: rebuild notice (lot P4)
    ["info_ab_rebuilding"]              = "Le barre delle azioni sono in fase di ricostruzione su un nuovo motore. Le loro impostazioni torneranno con il prossimo aggiornamento; le barre funzionano normalmente nel frattempo.",

    -- ActionBars: config tab labels (Lot A7)
    ["tab_abs_buttons"]                     = "Pulsanti",
    ["tab_abs_glow"]                        = "Bagliore",
    ["tab_abs_hotkeys"]                     = "Scorciatoie",

    -- ActionBars: TomoMod-owned buttons (Lot A6)
    ["opt_bar_own_buttons"]                 = "Pulsanti TomoMod (sperimentale)",
    ["info_bar_own_buttons"]                = "Sostituisce i pulsanti Blizzard con quelli di TomoMod su questa barra. Richiede /reload. I flyout (portali, trappole, fiale) e l'evidenziazione assistita non sono ancora supportati.",

    -- ActionBars: special bars (stances, pet, state decoration)
    ["section_ab_special"]                  = "Posizioni, famiglio e stati",
    ["opt_ab_sp_active"]                    = "Evidenzia l'azione attiva",
    ["opt_ab_sp_active_color"]              = "Colore attivo",
    ["opt_ab_sp_equipped"]                  = "Evidenzia gli oggetti equipaggiati",
    ["opt_ab_sp_equipped_color"]            = "Colore equipaggiato",
    ["opt_ab_sp_thickness"]                 = "Spessore dell'evidenziazione",
    ["opt_ab_sp_autocast"]                  = "Bagliore di lancio automatico",
    ["opt_ab_sp_autocast_color"]            = "Colore del lancio automatico",
    ["opt_ab_sp_pet_autohide"]              = "Nascondi la barra del famiglio senza famiglio",
    ["info_ab_sp_pet_autohide"]             = "La nasconde finché non hai alcun famiglio. Le posizioni non hanno una condizione equivalente e restano a Blizzard.",

    -- ActionBars: hotkey layer (keybind text, binding mode)
    ["section_ab_hotkey"]                   = "Scorciatoie",
    ["opt_ab_hk_enable"]                    = "Mostra le scorciatoie",
    ["opt_ab_hk_abbrev"]                    = "Abbrevia",
    ["opt_ab_hk_size"]                      = "Dimensione del carattere",
    ["opt_ab_hk_anchor"]                    = "Posizione",
    ["opt_ab_hk_offx"]                      = "Scostamento orizzontale",
    ["opt_ab_hk_offy"]                      = "Scostamento verticale",
    ["opt_ab_hk_color"]                     = "Colore del testo",
    ["opt_ab_hk_hide_empty"]                = "Nascondi sulle caselle vuote",
    ["btn_ab_hk_bind"]                      = "Modalità assegnazione",
    ["info_ab_hk_bind"]                     = "Assegna i tasti direttamente sulle barre. Non disponibile in combattimento.",
    ["hotkey_bind_enter"]                   = "Modalità assegnazione: passa su un pulsante e premi un tasto. Clic destro o Esc cancella.",
    ["hotkey_bind_exit"]                    = "Modalità assegnazione chiusa, scorciatoie salvate.",
    ["hotkey_combat_blocked"]               = "La modalità assegnazione non è disponibile in combattimento.",

    -- ActionBars: glow layer (procs, rotation hint)
    ["section_ab_glow"]                     = "Bagliore (proc e rotazione)",
    ["opt_ab_glow_proc"]                    = "Bagliore sui proc",
    ["opt_ab_glow_proc_type"]               = "Stile del bagliore proc",
    ["opt_ab_glow_proc_color"]              = "Colore del bagliore proc",
    ["opt_ab_glow_assist"]                  = "Bagliore sul suggerimento di rotazione",
    ["opt_ab_glow_assist_type"]             = "Stile del bagliore rotazione",
    ["opt_ab_glow_assist_color"]            = "Colore del bagliore rotazione",
    ["info_ab_glow_assist"]                 = "Segue il suggerimento dell'Evidenziazione Assistita di Blizzard. Richiede che la funzione sia disponibile sul personaggio.",
    ["opt_ab_glow_lines"]                   = "Pixel: numero di linee",
    ["opt_ab_glow_freq"]                    = "Velocità dell'animazione",
    ["opt_ab_glow_thickness"]               = "Pixel: spessore delle linee",

    -- ActionBars: render layer (icons, cooldowns, texts)
    ["section_ab_icons"]                    = "Icone e recuperi",
    ["opt_ab_cd_backend"]                   = "Sorgente dei recuperi",
    ["info_ab_cd_managed"]                  = "Gestita: TomoMod disegna da sé il recupero. Necessaria per i futuri pulsanti TomoMod; la sorgente Blizzard resta più sicura per ora.",
    ["opt_ab_cd_numbers"]                   = "Numeri di recupero",
    ["opt_ab_cd_size"]                      = "Dimensione dei numeri",
    ["opt_ab_swipe_color"]                  = "Colore dello sweep",
    ["opt_ab_swipe_alpha"]                  = "Opacità dello sweep",
    ["opt_ab_show_count"]                   = "Mostra cariche / pile",
    ["opt_ab_count_size"]                   = "Dimensione testo cariche",
    ["opt_ab_show_macro"]                   = "Mostra nome macro",
    ["opt_ab_desat_unusable"]               = "Desatura se inutilizzabile",
    ["opt_ab_icon_zoom"]                    = "Ritaglio icona",
    ["cat_action_bars"]                 = "Barre d'azione",
    ["opt_abs_enable"]                  = "Attiva skin barre d'azione",
    ["opt_abs_class_color"]             = "Colore di classe per i bordi",
    ["opt_abs_shift_reveal"]            = "Tieni Shift per rivelare le barre nascoste",
    ["sublabel_bar_opacity"]            = "— Opacità per barra —",
    ["opt_abs_select_bar"]              = "Seleziona barra d'azione",
    ["btn_abs_apply_all_opacity"]       = "Applica a tutte le barre",
    ["msg_abs_all_opacity"]             = "Opacità impostata a %d%% su tutte le barre",
    ["sublabel_bar_combat"]             = "— Visibilità in combattimento —",
    ["opt_abs_combat_show"]             = "Mostra solo in combattimento",

    ["section_cinematic"]               = "Salta filmati",
    ["opt_cinematic_auto_skip"]         = "Salta automaticamente dopo la prima visione",
    ["info_cinematic_viewed"]           = "Filmati già visti: %s\nLa cronologia è condivisa tra i personaggi.",
    ["btn_clear_history"]               = "Cancella cronologia",

    -- Auto Quest
    ["section_auto_quest"]              = "Auto missioni",
    ["opt_quest_auto_accept"]           = "Accetta missioni automaticamente",
    ["opt_quest_auto_turnin"]           = "Completa missioni automaticamente",
    ["opt_quest_auto_gossip"]           = "Seleziona dialoghi automaticamente",
    ["info_quest_shift"]                = "Tieni SHIFT per disattivare temporaneamente.\nLe missioni con ricompense multiple non vengono completate automaticamente.",

    -- Objective Tracker Skin
    ["tab_qol_obj_tracker"]             = "Tracciatore",
    ["section_obj_tracker"]             = "Skin tracciatore obiettivi",
    ["opt_obj_tracker_enable"]          = "Attiva skin tracciatore",
    ["opt_obj_tracker_bg_alpha"]        = "Opacità sfondo",
    ["opt_obj_tracker_border"]          = "Mostra bordo",
    ["opt_obj_tracker_hide_empty"]      = "Nascondi se vuoto",
    ["opt_obj_tracker_buckets"]         = "Raggruppa le missioni in categorie comprimibili",
    ["opt_obj_tracker_header_size"]     = "Dimensione font intestazione",
    ["opt_obj_tracker_cat_size"]        = "Dimensione font categoria",
    ["opt_obj_tracker_quest_size"]      = "Dimensione font titolo missione",
    ["opt_obj_tracker_obj_size"]        = "Dimensione font obiettivo",
    ["opt_obj_tracker_max_quests"]       = "Max. missioni mostrate (0 = nessun limite)",
    ["ot_overflow_text"]                 = "%d missione/i nascosta/e...",
    ["info_obj_tracker"]                = "Applica una skin scura al tracciatore obiettivi di Blizzard con pannello, font personalizzati e intestazioni di categoria colorate.",
    ["ot_header_title"]                 = "OBIETTIVI",
    ["ot_header_options"]               = "Opzioni",

    -- Automations
    ["section_automations"]             = "Automazioni",
    ["opt_hide_blizzard_castbar"]       = "Nascondi barra di lancio di Blizzard",
    ["opt_hide_talking_head"]           = "Nascondi Talking Head (dialoghi a scorrimento)",
    ["opt_hide_status_bar2"]            = "Nascondi la barra di stato 2 di Blizzard",
    ["opt_hide_status_bar2_desc"]       = "Rende invisibile e non cliccabile la seconda barra di stato della modalità modifica. Resta di Blizzard, quindi rimane nella sua modalità modifica.",

    -- Auto Accept Invite
    ["sublabel_auto_accept_invite"]     = "— Accetta invito automaticamente —",
    ["sublabel_auto_skip_role"]         = "— Salta verifica ruolo —",
    ["sublabel_tooltip_ids"]            = "— ID Tooltip —",
    ["sublabel_combat_res_tracker"]     = "— Tracciatore res. in combattimento —",
    ["opt_cr_show_rating"]              = "Mostra punteggio M+",
    ["opt_show_messages"]               = "Mostra messaggi in chat",
    ["opt_tid_spell"]                   = "ID incantesimo / aura",
    ["opt_tid_item"]                    = "ID oggetto",
    ["opt_tid_npc"]                     = "ID PNG",
    ["opt_tid_quest"]                   = "ID missione",
    ["opt_tid_mount"]                   = "ID cavalcatura",
    ["opt_tid_currency"]                = "ID valuta",
    ["opt_tid_achievement"]             = "ID impresa",
    ["opt_accept_friends"]              = "Accetta dagli amici",
    ["opt_accept_guild"]                = "Accetta dalla gilda",

    -- Auto Summon
    ["sublabel_auto_summon"]            = "— Auto evocazione —",
    ["opt_summon_delay"]                = "Ritardo (secondi)",

    -- Auto Fill Delete
    ["sublabel_auto_fill_delete"]       = "— Auto compila ELIMINA —",
    ["sublabel_auto_vendor_repair"]     = "— Auto Vendita / Riparazione —",
    ["opt_avr_auto_repair"]             = "Riparazione automatica dal mercante",
    ["opt_avr_sell_grays"]              = "Vendi automaticamente gli oggetti grigi (scarsi)",
    ["opt_focus_ok_button"]             = "Focus su OK dopo compilazione",

    -- Mythic+ Keys
    ["section_mythic_keys"]             = "Chiavi Mitiche+",
    ["opt_keys_enable_tracker"]         = "Attiva tracciatore",
    ["opt_keys_mini_frame"]             = "Mini-frame sull'interfaccia M+",
    ["opt_keys_auto_refresh"]           = "Aggiornamento automatico",

    -- SkyRide
    ["section_skyride"]                 = "SkyRide",
    ["opt_skyride_enable"]              = "Attiva (display di volo)",
    ["section_skyride_dims"]            = "Dimensioni",
    ["opt_skyride_bar_height"]          = "Altezza barra velocità",
    ["opt_skyride_charge_height"]       = "Altezza barra carica",
    ["opt_skyride_charge_gap"]          = "Spazio tra segmenti",
    ["section_skyride_text"]            = "Testo",
    ["opt_skyride_show_speed_text"]     = "Mostra percentuale velocità",
    ["opt_skyride_speed_font_size"]     = "Dimensione font velocità",
    ["opt_skyride_show_charge_timer"]   = "Mostra timer carica",
    ["opt_skyride_charge_font_size"]    = "Dimensione font timer carica",
    ["btn_reset_skyride"]               = "Ripristina posizione SkyRide",

    -- =====================
    -- CONFIG: QOL — CVar Optimizer
    -- =====================
    ["tab_qol_cvar_opt"]                = "CVars Perf",
    ["section_cvar_optimizer"]          = "Ottimizzatore CVars",
    ["info_cvar_optimizer"]             = "Applica impostazioni grafiche/prestazioni raccomandate. I tuoi valori attuali vengono salvati e possono essere ripristinati in qualsiasi momento.",
    ["btn_cvar_apply_all"]              = ">> Applica tutto",
    ["btn_cvar_revert_all"]             = "<< Ripristina tutto",
    ["btn_cvar_apply"]                  = "Applica",
    ["btn_cvar_revert"]                 = "Ripristina",
    -- Categories
    ["opt_cat_render"]                  = "Rendering e display",
    ["opt_cat_graphics"]                = "Qualità grafica",
    ["opt_cat_detail"]                  = "Distanza visiva e dettagli",
    ["opt_cat_advanced"]                = "Avanzato",
    ["opt_cat_fps"]                     = "Limiti FPS",
    ["opt_cat_post"]                    = "Post-elaborazione",
    -- CVar labels
    ["opt_cvar_render_scale"]           = "Scala di rendering",
    ["opt_cvar_vsync"]                  = "VSync",
    ["opt_cvar_msaa"]                   = "Multisampling (MSAA)",
    ["opt_cvar_low_latency"]            = "Modalità bassa latenza",
    ["opt_cvar_anti_aliasing"]          = "Anti-aliasing",
    ["opt_cvar_shadow"]                 = "Qualità ombre",
    ["opt_cvar_ssao"]                   = "SSAO",
    ["opt_cvar_depth"]                  = "Effetti di profondità",
    ["opt_cvar_compute"]                = "Effetti di calcolo",
    ["opt_cvar_particle"]               = "Densità particelle",
    ["opt_cvar_liquid"]                 = "Dettaglio liquidi",
    ["opt_cvar_spell_density"]          = "Densità incantesimi",
    ["opt_cvar_projected"]              = "Texture proiettate",
    ["opt_cvar_outline"]                = "Modalità contorno",
    ["opt_cvar_texture_res"]            = "Risoluzione texture",
    ["opt_cvar_view_distance"]          = "Distanza visiva",
    ["opt_cvar_env_detail"]             = "Dettaglio ambiente",
    ["opt_cvar_ground"]                 = "Vegetazione del suolo",
    ["opt_cvar_gfx_api"]                = "API grafica",
    ["opt_cvar_triple_buffering"]       = "Triple buffering",
    ["opt_cvar_texture_filtering"]      = "Filtraggio texture",
    ["opt_cvar_rt_shadows"]             = "Ombre ray tracing",
    ["opt_cvar_resample_quality"]       = "Qualità di ricampionamento",
    ["opt_cvar_physics"]                = "Livello fisica",
    ["opt_cvar_target_fps"]             = "FPS obiettivo",
    ["opt_cvar_bg_fps_enable"]          = "Limite FPS in background",
    ["opt_cvar_bg_fps"]                 = "Valore FPS in background",
    ["opt_cvar_resample_sharpness"]     = "Nitidezza di ricampionamento",
    ["opt_cvar_camera_shake"]           = "Vibrazione telecamera",
    -- Messages
    ["msg_cvar_applied"]                = "CVars applicate",
    ["msg_cvar_reverted"]               = "CVars ripristinate",
    ["msg_cvar_no_backup"]              = "Nessun backup trovato — applica prima.",
    ["tab_qol_leveling"]                = "Leveling",
    ["section_leveling_bar"]            = "Barra di esperienza",
    ["opt_leveling_enable"]             = "Attiva barra di esperienza",
    ["opt_leveling_width"]              = "Larghezza barra",
    ["opt_leveling_height"]             = "Altezza barra",
    ["btn_reset_leveling_pos"]          = "Ripristina posizione",
    ["leveling_bar_title"]              = "Barra di esperienza",
    ["leveling_level"]                  = "Livello",
    ["leveling_progress"]               = "Progresso:",
    ["leveling_rested"]                 = "Riposato",
    ["leveling_last_quest"]             = "Ultima missione:",
    ["leveling_ttl"]                    = "Tempo per livello:",
    ["leveling_remaining"]              = "Rimanente",
    ["leveling_session"]                = "Questo livello",
    ["leveling_drag_hint"]              = "/tm sr per sbloccare e spostare",

    -- =====================
    -- CONFIG: Profiles Panel (3 Tabs)
    -- =====================
    ["tab_profiles"]                    = "Profili",
    ["tab_import_export"]               = "Importa/Esporta",
    ["tab_resets"]                      = "Ripristino",

    -- Tab 1: Named profiles & specializations
    ["section_named_profiles"]          = "Profili",
    ["info_named_profiles"]             = "Crea e gestisci profili con nome. Ogni profilo salva un'istantanea completa delle tue impostazioni.",
    ["profile_active_label"]            = "Profilo attivo",
    ["opt_select_profile"]              = "Scegli un profilo",
    ["sublabel_create_profile"]         = "— Crea nuovo profilo —",
    ["placeholder_profile_name"]        = "Nome profilo...",
    ["btn_create_profile"]              = "Crea profilo",
    ["btn_delete_named_profile"]        = "Elimina profilo",
    ["btn_save_profile"]                = "Salva profilo attuale",
    ["info_save_profile"]               = "Salva tutte le impostazioni attuali nel profilo attivo. Questo avviene automaticamente al cambio di profilo.",

    ["section_profile_mode"]            = "Modalità profilo",
    ["info_spec_profiles"]              = "Attiva i profili per specializzazione per salvare e caricare automaticamente le impostazioni quando cambi specializzazione.\nOgni specializzazione ha la propria configurazione indipendente.",
    ["opt_enable_spec_profiles"]        = "Attiva profili per specializzazione",
    ["profile_status"]                  = "Profilo attivo",
    ["profile_global"]                  = "Globale (profilo unico)",
    ["section_spec_list"]               = "Specializzazioni",
    ["profile_badge_active"]            = "Attivo",
    ["profile_badge_saved"]             = "Salvato",
    ["profile_badge_none"]              = "Nessun profilo",
    ["btn_copy_to_spec"]                = "Copia attuale",
    ["btn_delete_profile"]              = "Elimina",
    ["info_spec_reload"]                = "Cambiare specializzazione con i profili attivati ricaricherà automaticamente l'interfaccia per applicare il profilo corrispondente.",
    ["info_global_mode"]                = "Tutte le specializzazioni condividono le stesse impostazioni. Attiva i profili per specializzazione sopra per usare configurazioni diverse.",

    -- Tab 2: Import / Export
    ["section_export"]                  = "Esporta impostazioni",
    ["info_export"]                     = "Genera una stringa compressa di tutte le impostazioni attuali.\nCopiala per condividerla o come backup.",
    ["label_export_string"]             = "Stringa di esportazione (clicca per selezionare tutto)",
    ["btn_export"]                      = "Genera stringa di esportazione",
    ["btn_copy_clipboard"]              = "Copia testo",
    ["section_import"]                  = "Importa impostazioni",
    ["info_import"]                     = "Incolla una stringa di esportazione qui sotto. Verrà validata prima dell'applicazione.",
    ["label_import_string"]             = "Incolla la stringa di importazione qui",
    ["btn_import"]                      = "Importa e applica",
    ["btn_paste_clipboard"]             = "Incolla testo",
    ["import_preview"]                  = "Classe: %s | Moduli: %s | Data: %s",
    ["import_preview_valid"]            = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t Stringa valida",
    ["import_preview_invalid"]          = "Stringa invalida o corrotta",
    ["info_import_warning"]             = "L'importazione SOVRASCRIVERÀ tutte le impostazioni attuali e ricaricherà l'interfaccia. Questa azione non può essere annullata.",

    -- Tab 3: Resets
    ["section_profile_mgmt"]            = "Gestione profili",
    ["info_profiles"]                   = "Ripristina moduli singoli o esporta/importa le impostazioni.\nL'esportazione copia le impostazioni negli appunti (richiede LibSerialize + LibDeflate).",
    ["section_reset_module"]            = "Ripristina un modulo",
    ["btn_reset_prefix"]                = "Ripristina: ",
    ["btn_reset_all_reload"]            = "(!) RIPRISTINA TUTTO + Ricarica",
    ["section_reset_all"]               = "Ripristino completo",
    ["info_resets"]                     = "Ripristina un singolo modulo ai valori predefiniti. Il modulo verrà ricaricato con le impostazioni di fabbrica.",
    ["info_reset_all_warning"]          = "Questo ripristinerà TUTTI i moduli e TUTTE le impostazioni ai valori di fabbrica, poi ricaricherà l'interfaccia.",

    -- =====================
    -- PRINT MESSAGES: Core
    -- =====================
    ["msg_db_reset"]                    = "Database ripristinato",
    ["msg_migration_failed"]           = "Un passaggio di migrazione del database è fallito — segnalalo sul Discord: ",
    ["msg_normalize_failed"]           = "La normalizzazione degli elementi è fallita — segnalalo sul Discord: ",
    ["msg_module_reset"]                = "Modulo '%s' ripristinato",
    ["msg_db_not_init"]                 = "Database non inizializzato",
    ["msg_loaded"]                      = "caricato — %s per configurazione",
    ["msg_report_issue"]                = "Se riscontri un problema, lascia un commento su CurseForge.",
    ["at_rescue_header"]              = "Il tracciatore di aure \195\168 stato rimosso; CooldownForge copre lo stesso ambito.",
    ["at_rescue_list"]                = "Incantesimi aggiunti a mano: %s",
    ["at_rescue_hint"]                = "Aggiungili di nuovo nel Cooldown Studio se vuoi ancora seguirli.",
    ["msg_help_title"]                  = "Comandi:",
    ["msg_help_open"]                   = "Apri configurazione",
    ["msg_help_reset"]                  = "Ripristina tutto + ricarica",
    ["msg_help_uf"]                     = "Blocca/Sblocca UnitFrames + Risorse",
    ["msg_help_uf_reset"]               = "Ripristina UnitFrames",
    ["msg_help_rb"]                     = "Blocca/Sblocca barre risorse",
    ["msg_help_rb_sync"]                = "Sincronizza larghezza con Essential Cooldowns",
    ["msg_help_np"]                     = "Attiva/disattiva Nameplates",
    ["msg_help_minimap"]                = "Ripristina minimappa",
    ["msg_help_panel"]                  = "Ripristina pannello info",
    ["msg_help_cursor"]                 = "Ripristina anello cursore",
    ["msg_help_clearcinema"]            = "Cancella cronologia filmati",
    ["msg_help_sr"]                     = "Blocca/Sblocca SkyRide + Ancore",
    ["msg_help_key"]                    = "Apri chiavi Mitiche+",
    ["msg_help_help"]                   = "Questo aiuto",

    -- =====================
    -- PRINT MESSAGES: Modules
    -- =====================
    -- CDM
    ["msg_cdm_status"]                  = "Attivato",
    ["msg_cdm_disabled"]                = "Disattivato",

    -- Nameplates
    ["msg_np_enabled"]                  = "Attivate",
    ["msg_np_disabled"]                 = "Disattivate",

    -- UnitFrames
    ["msg_uf_locked"]                   = "Bloccato",
    ["msg_uf_unlocked"]                 = "Sbloccato — Trascina per riposizionare",
    ["msg_uf_initialized"]              = "Inizializzato — /tm uf per bloccare/sbloccare",
    ["msg_uf_enabled"]                  = "attivato (ricarica necessaria)",
    ["msg_uf_disabled"]                 = "disattivato (ricarica necessaria)",
    ["msg_uf_position_reset"]           = "posizione ripristinata",

    -- ResourceBars
    ["msg_rb_width_synced"]             = "Larghezza sincronizzata (%dpx)",
    ["msg_rb_locked"]                   = "Bloccato",
    ["msg_rb_unlocked"]                 = "Sbloccato — Trascina per riposizionare",
    ["msg_rb_position_reset"]           = "Posizione barre risorse ripristinata",

    -- SkyRide
    ["msg_sr_pos_saved"]                = "Posizione SkyRide salvata",
    ["msg_sr_locked"]                   = "SkyRide bloccato",
    ["msg_sr_unlock"]                   = "Modalità spostamento SkyRide attivata – Clicca e trascina",
    ["msg_sr_pos_reset"]                = "Posizione SkyRide ripristinata",
    ["msg_sr_db_not_init"]              = "TomoModForeverDB non inizializzato",
    ["msg_sr_initialized"]              = "Modulo SkyRide inizializzato",

    -- FrameAnchors
    ["anchor_alert"]                    = "Avvisi",
    ["anchor_loot"]                     = "Bottino",
    ["msg_anchors_locked"]              = "Bloccati",
    ["msg_anchors_unlocked"]            = "Sbloccati — sposta le ancore",

    -- AutoVendorRepair
    ["msg_avr_header"]                  = "[AutoVenditoreRipara]",
    ["msg_avr_sold"]                    = " Oggetti grigi venduti per |cffffff00%s|r",
    ["msg_avr_repaired"]                = " Equipaggiamento riparato per |cffffff00%s|r",

    -- AutoFillDelete
    ["msg_afd_filled"]                  = "Testo 'ELIMINA' auto-compilato – Clicca OK per confermare",
    ["msg_afd_db_not_init"]             = "TomoModForeverDB non inizializzato",
    ["msg_afd_initialized"]             = "Modulo AutoFillDelete inizializzato",
    ["msg_afd_enabled"]                 = "Auto-compilazione ELIMINA attivata",
    ["msg_afd_disabled"]                = "Auto-compilazione ELIMINA disattivata (hook ancora attivo)",

    -- HideCastBar
    ["msg_hcb_db_not_init"]             = "TomoModForeverDB non inizializzato",
    ["msg_hcb_initialized"]             = "Modulo HideCastBar inizializzato",
    ["msg_hcb_hidden"]                  = "Barra di lancio nascosta",
    ["msg_hcb_shown"]                   = "Barra di lancio mostrata",

    -- AutoAcceptInvite
    ["msg_aai_accepted"]                = "Invito accettato da ",
    ["msg_aai_ignored"]                 = "Invito ignorato da ",
    ["msg_aai_enabled"]                 = "Auto-accettazione inviti attivata",
    ["msg_aai_disabled"]                = "Auto-accettazione inviti disattivata",
    ["msg_asr_lfg_accepted"]            = "Verifica ruolo auto-confermata",
    ["msg_asr_poll_accepted"]           = "Sondaggio ruolo auto-confermato",
    ["msg_asr_enabled"]                 = "Auto salta verifica ruolo attivato",
    ["msg_asr_disabled"]                = "Auto salta verifica ruolo disattivato",
    ["msg_tid_enabled"]                 = "Tooltip IDs attivato",
    ["msg_tid_disabled"]                = "Tooltip IDs disattivato",
    ["msg_cr_enabled"]                  = "Tracciatore res. in combattimento attivato",
    ["msg_cr_disabled"]                 = "Tracciatore res. in combattimento disattivato",
    ["msg_cr_locked"]                   = "Tracciatore res. in combattimento bloccato",
    ["msg_cr_unlock"]                   = "Tracciatore res. in combattimento sbloccato — trascina per spostare",
    ["msg_abs_enabled"]                 = "Skin barre d'azione attivato (ricarica consigliata)",
    ["msg_abs_disabled"]                = "Skin barre d'azione disattivato",
    ["opt_buffskin_enable"]             = "Attiva skin buff",
    ["opt_buffskin_desc"]               = "Aggiunge bordi neri e timer colorato sui buff/debuff del giocatore",
    ["msg_buffskin_enabled"]            = "Skin buff attivato",
    ["msg_buffskin_disabled"]           = "Skin buff disattivato",
    ["msg_help_cr"]                     = "Blocca/sblocca tracciatore res. in combattimento",
    ["msg_help_cs"]                     = "Blocca/sblocca posizione scheda personaggio",
    ["msg_help_cs_reset"]               = "Ripristina posizione scheda personaggio",

    -- CinematicSkip
    ["msg_cin_skipped"]                 = "Filmato saltato (già visto)",
    ["msg_vid_skipped"]                 = "Video saltato (già visto)",
    ["msg_vid_id_skipped"]              = "Video #%d saltato",
    ["msg_cin_cleared"]                 = "Cronologia filmati cancellata",

    -- AutoSummon
    ["msg_sum_accepted"]                = "Evocazione accettata da %s verso %s (%s)",
    ["msg_sum_ignored"]                 = "Evocazione ignorata da %s (non fidato)",
    ["msg_sum_enabled"]                 = "Auto-evocazione attivata",
    ["msg_sum_disabled"]                = "Auto-evocazione disattivata",
    ["msg_sum_manual"]                  = "Evocazione accettata manualmente",
    ["msg_sum_no_pending"]              = "Nessuna evocazione in sospeso",

    -- MythicKeys
    ["msg_keys_no_key"]                 = "Nessuna chiave da inviare.",
    ["msg_keys_not_in_group"]           = "Devi essere in un gruppo.",
    ["msg_keys_reload"]                 = "Modifica applicata al prossimo /reload.",
    ["mk_not_in_group"]                 = "Non sei in un gruppo.",
    ["mk_not_in_group_short"]           = "Non in gruppo.",
    ["mk_no_key_self"]                  = "Nessuna chiave del trionfo trovata.",
    ["mk_title"]                        = "TM — Chiavi Mitiche",
    ["mk_btn_send"]                     = "Invia in chat",
    ["mk_btn_refresh"]                  = "Aggiorna",
    ["mk_tab_keys"]                     = "Chiavi",
    ["mk_tab_tp"]                       = "TP",
    ["mk_tp_click_to_tp"]              = "Clicca per teletrasportarti",
    ["mk_tp_not_unlocked"]             = "Non sbloccato",
    ["msg_tp_not_owned"]               = "Non possiedi il teletrasporto per %s",
    ["msg_tp_combat"]                  = "Impossibile aggiornare i teletrasporti in combattimento.",

    -- =====================
    -- PRINT MESSAGES: Config Panels
    -- =====================
    ["msg_np_reset"]                    = "Nameplates ripristinate (ricarica consigliata)",
    ["msg_uf_toggle"]                   = "UnitFrames %s (ricarica)",
    ["msg_profile_reset"]               = "%s ripristinato",
    ["msg_profile_copied"]              = "Impostazioni attuali copiate in '%s'",
    ["msg_profile_deleted"]             = "Profilo eliminato per '%s'",
    ["msg_profile_loaded"]              = "Profilo '%s' caricato — ricarica per applicare",
    ["msg_profile_load_failed"]         = "Caricamento del profilo '%s' fallito",
    ["msg_profile_created"]             = "Profilo '%s' creato con le impostazioni attuali",
    ["msg_profile_name_empty"]          = "Inserisci un nome per il profilo",
    ["msg_profile_saved"]               = "Impostazioni salvate nel profilo '%s'",

    -- New profile keys v2.3.0
    ["btn_rename_profile"]              = "Rinomina",
    ["btn_duplicate_profile"]           = "Duplica",
    ["btn_load_profile"]                = "Carica",
    ["btn_close"]                       = "Chiudi",
    ["btn_cancel"]                      = "Annulla",
    ["section_spec_assign"]             = "Profili per specializzazione",
    ["info_spec_assign"]                = "Assegna ogni specializzazione a un profilo con nome. TomoMod cambierà automaticamente profilo quando cambi specializzazione.",
    ["spec_profile_none"]               = "— Nessuno —",
    ["popup_rename_profile"]            = "|cffffd100TomoModForever|r\n\nNuovo nome per '%s':",
    ["popup_duplicate_profile"]         = "|cffffd100TomoModForever|r\n\nDuplica '%s' come:",
    ["msg_profile_renamed"]             = "Profilo '%s' rinominato in '%s'",
    ["msg_profile_duplicated"]          = "Profilo '%s' duplicato come '%s'",
    ["msg_import_as_profile"]           = "Profilo importato come '%s'",
    ["popup_export_title"]              = "Esporta profilo",
    ["popup_export_hint"]               = "Seleziona tutto (Ctrl+A) e copia (Ctrl+C)",
    ["popup_import_title"]              = "Importa profilo",
    ["popup_import_hint"]               = "Incolla una stringa di esportazione TomoMod, poi clicca su Importa",
    ["label_import_profile_name"]       = "Salva come nome profilo:",
    ["placeholder_import_profile_name"] = "Nome profilo (opzionale)...",
    ["msg_profile_name_deleted"]        = "Profilo '%s' eliminato",
    ["msg_export_success"]              = "Stringa di esportazione generata — seleziona tutto e copia",
    ["msg_import_success"]              = "Impostazioni importate con successo — ricaricamento...",
    ["msg_import_empty"]                = "Niente da importare — incolla prima una stringa",
    ["msg_copy_hint"]                   = "Testo selezionato — premi Ctrl+C per copiare",
    ["msg_copy_empty"]                  = "Genera prima una stringa di esportazione",
    ["msg_paste_hint"]                  = "Premi Ctrl+V per incollare la stringa di importazione",
    ["msg_spec_changed_reload"]         = "Specializzazione cambiata — caricamento profilo...",

    -- =====================
    -- INFO PANEL (Minimap)
    -- =====================
    ["time_server"]                     = "Server",
    ["time_local"]                      = "Locale",
    ["time_tooltip_title"]              = "Orario (%s - %s)",
    ["time_tooltip_left_click"]         = "|cffffd100Clic sinistro:|r Calendario",
    ["time_tooltip_right_click"]        = "|cffffd100Clic destro:|r Server / Locale",
    ["time_tooltip_shift_right"]        = "|cffffd100Shift + Clic destro:|r 12h / 24h",
    ["time_format_msg"]                 = "Formato: %s",
    ["time_mode_msg"]                   = "Orario: %s",

    -- =====================
    -- ENABLED / DISABLED (generic)
    -- =====================
    ["enabled"]                         = "Attivato",
    ["disabled"]                        = "Disattivato",

    -- Static Popups
    ["popup_reset_text"]                = "|cffffd100TomoModForever|r\n\nRipristinare TUTTE le impostazioni?\nQuesto ricaricherà l'interfaccia.",
    ["popup_confirm"]                   = "Conferma",
    ["popup_cancel"]                    = "Annulla",
    ["popup_import_text"]               = "|cffffd100TomoModForever|r\n\nImportare le impostazioni?\nQuesto SOVRASCRIVERÀ tutte le impostazioni attuali e ricaricherà l'interfaccia.",
    ["popup_profile_reload"]            = "|cffffd100TomoModForever|r\n\nModalità profilo cambiata.\nRicaricare l'interfaccia per applicare?",
    ["popup_delete_profile"]            = "|cffffd100TomoModForever|r\n\nEliminare il profilo '%s'?\nQuesta azione non può essere annullata.",

    -- FPS element
    ["label_fps"]                       = "FPS",

    -- =====================
    -- BOSS FRAMES
    -- =====================
    ["tab_boss"]                        = "Boss",
    ["section_boss_frames"]             = "Barre boss",
    ["opt_boss_enable"]                 = "Attiva barre boss",
    ["opt_boss_height"]                 = "Altezza barre",
    ["opt_boss_spacing"]                = "Spaziatura tra le barre",
    ["info_boss_drag"]                  = "Sblocca (/tm uf) per spostare. Trascina Boss 1 per riposizionare tutte e 5 le barre insieme.",
    ["info_boss_colors"]                = "I colori delle barre usano i colori di classificazione Nameplate (Boss = rosso, Mini-boss = viola).",
    ["msg_boss_initialized"]            = "Barre boss caricate.",

    -- =====================
    -- SOUND / LUST DETECTION
    -- =====================
    ["cat_sound"]                       = "Suono",
    ["section_sound_general"]           = "Suono Bloodlust",
        ["info_sound_desc"]                 = "Riproduce un suono personalizzato quando viene rilevato un effetto Bloodlust. Il rilevamento verifica direttamente i buff di Lust e i debuff Sated/Exhaustion.",
    ["opt_sound_enable"]                = "Attiva rilevamento Bloodlust",
    ["sublabel_sound_choice"]           = "Suono e canale",
    ["opt_sound_file"]                  = "Suono da riprodurre",
    ["opt_sound_channel"]               = "Canale audio",
    ["opt_sound_volume"]                = "Volume del canale audio",
    ["info_sound_volume"]               = "Modifica il volume globale del canale selezionato nelle impostazioni audio di WoW.",
    ["btn_sound_preview"]               = ">> Ascolta suono",
    ["btn_sound_stop"]                  = "■  Ferma",
    ["opt_sound_force"]                 = "Forza il suono anche se il gioco è in muto",
    ["opt_sound_chat"]                  = "Mostra messaggi in chat",
    ["opt_sound_debug"]                 = "Mode debug",

    -- =====================
    -- BAG & MICRO MENU
    -- =====================
    ["tab_qol_bag_micro"]               = "Borsa e menu",
    ["section_bag_micro"]               = "Barra borse e micro menu",
    ["info_bag_micro"]                  = "Scegli se mostrare sempre o rivelare al passaggio del mouse.",
    ["sublabel_bag_bar"]                = "— Barra borse —",
    ["sublabel_micro_menu"]             = "— Micro menu —",
    ["opt_bag_bar_mode"]                = "Barra borse",
    ["opt_micro_menu_mode"]             = "Micro menu",
    ["mode_show"]                       = "Sempre visibile",
    ["mode_hover"]                      = "Mostra al passaggio del mouse",

    -- =====================
    -- MICRO BAR
    -- =====================
    ["microbar_btn_character"]          = "Personaggio",
    ["microbar_btn_spells"]             = "Talenti e libro degli incantesimi",
    ["microbar_btn_profession"]         = "Professioni",
    ["microbar_btn_achievement"]        = "Imprese",
    ["microbar_btn_quest"]              = "Registro missioni",
    ["microbar_btn_guild"]              = "Gilda e comunità",
    ["microbar_btn_lfd"]                = "Cerca gruppo",
    ["microbar_btn_collections"]        = "Collezioni",
    ["microbar_btn_ej"]                 = "Guida all'avventura",
    ["microbar_btn_housing"]            = "Abitazione",
    ["microbar_btn_social"]             = "Sociale",
    ["microbar_btn_store"]              = "Negozio",
    ["microbar_btn_bags"]               = "Borse",
    ["microbar_btn_mainmenu"]           = "Menu di gioco",
    ["microbar_tt_memory"]              = "Memoria degli addon",
    ["microbar_tt_total"]               = "Totale",
    ["mover_microbar"]                  = "Microbarra",
    ["section_microbar"]                = "Microbarra",
    ["info_microbar"]                   = "Sostituisce il micromenu di Blizzard con una barra che puoi dimensionare, riordinare e posizionare liberamente. Ogni pulsante inoltra il proprio clic al pulsante originale, quindi tutto continua a funzionare in combattimento. Le icone vengono lette direttamente dalle risorse del gioco. Finché è attiva, l'impostazione Micromenu qui sopra non si applica più.",
    ["opt_microbar_enable"]             = "Attiva la microbarra",
    ["opt_microbar_lfg_eye"]                = "Occhio del cerca gruppo",
    ["opt_microbar_lfg_eye_scale"]          = "Dimensione dell'occhio",
    ["info_microbar_lfg_eye"]               = "Staccato dal micro-menu Blizzard per sopravvivere al suo occultamento. Posizionalo in modalità disposizione.",
    ["opt_microbar_hide_native"]        = "Nascondi il micromenu di Blizzard",
    ["opt_microbar_buttons"]            = "Pulsanti e ordine",
    ["opt_microbar_orientation"]        = "Orientamento",
    ["opt_microbar_per_line"]           = "Pulsanti per riga (0 = una sola riga)",
    ["opt_microbar_icon_size"]          = "Dimensione delle icone",
    ["opt_microbar_spacing"]            = "Spaziatura",
    ["opt_microbar_scale"]              = "Scala",
    ["opt_microbar_alpha"]              = "Opacità",
    ["opt_microbar_fade_mode"]          = "Visibilità",
    ["opt_microbar_fade_alpha"]         = "Opacità attenuata",
    ["opt_microbar_color_mode"]         = "Colore delle icone",
    ["opt_microbar_color"]              = "Colore personalizzato",
    ["opt_microbar_desaturate"]         = "Desatura le icone",
    ["opt_microbar_hover_zoom"]         = "Ingrandisci l'icona al passaggio del mouse",
    ["opt_microbar_memory_tooltip"]     = "Mostra la memoria degli addon sul pulsante menu",
    ["microbar_orient_h"]               = "Orizzontale",
    ["microbar_orient_v"]               = "Verticale",
    ["microbar_fade_always"]            = "Sempre visibile",
    ["microbar_fade_hover"]             = "Mostra al passaggio del mouse",
    ["microbar_fade_hovercombat"]       = "Al passaggio del mouse, sempre in combattimento",
    ["microbar_color_class"]            = "Classe",
    ["microbar_color_custom"]           = "Personalizzato",
    ["microbar_color_native"]           = "Originale",
    ["btn_microbar_place"]              = "Posiziona la barra",
    ["btn_microbar_reset_pos"]          = "Reimposta la posizione",
    ["section_microbar_states"]         = "Microbarra — Stati nativi",
    ["info_microbar_states"]            = "I pulsanti originali continuano a funzionare sotto la barra, quindi i loro avvisi, gli stati disattivati e le scorciatoie restano attivi. Queste opzioni li riportano sui tuoi pulsanti.",
    ["opt_microbar_alert_style"]        = "Bagliore di avviso",
    ["opt_microbar_alert_color"]        = "Colore dell'avviso",
    ["opt_microbar_dim_disabled"]       = "Attenua i pulsanti non disponibili",
    ["opt_microbar_disabled_alpha"]     = "Opacità attenuata",
    ["opt_microbar_show_keybind"]       = "Mostra le scorciatoie sulle icone",
    ["opt_microbar_keybind_size"]       = "Dimensione del testo delle scorciatoie",
    ["microbar_glow_none"]              = "Nessuno",
    ["microbar_glow_pixel"]             = "Bagliore a pixel",
    ["microbar_glow_autocast"]          = "Scintillio di lancio automatico",
    ["microbar_glow_button"]            = "Bagliore del pulsante d'azione",
    ["microbar_glow_proc"]              = "Bagliore di proc",

    -- =====================
    -- CHARACTER SKIN
    -- =====================
    ["tab_qol_char_skin"]               = "Skin personaggio",
    ["section_char_skin"]               = "Skin scheda personaggio",
    ["info_char_skin_desc"]             = "Applica il tema scuro TomoMod alla scheda personaggio, reputazione, valute e finestra di ispezione.",
    ["opt_char_skin_enable"]            = "Attiva skin personaggio",
    ["opt_char_skin_character"]         = "Skin Personaggio / Reputazione / Valute",
    ["opt_char_skin_inspect"]           = "Skin finestra di ispezione",
    ["opt_char_skin_inspect_iteminfo"]  = "Mostra iLvl, incantamenti e gemme durante l'ispezione",
    ["opt_char_skin_iteminfo"]          = "Mostra info oggetto sugli slot",
    ["opt_char_skin_gems"]              = "Mostra gemme sugli slot",
    ["opt_char_skin_midnight"]          = "Incantamenti Midnight (Testa/Spalle invece di Polsi/Mantello)",
    ["opt_char_skin_scale"]             = "Scala finestra",
    ["msg_char_skin_reload"]            = "Skin personaggio: /reload per applicare le modifiche.",

    -- =====================
    -- LAYOUT / MOVERS SYSTEM
    -- =====================
    ["btn_layout"]                      = "EditMode",
    ["btn_layout_tooltip"]              = "EditMode: sblocca tutti gli elementi per spostarli.",
    ["btn_reload_ui"]                   = "Ricarica interfaccia",
    ["layout_mode_title"]               = "TomoMod — EditMode",
    ["layout_mode_hint"]                = "Trascina gli elementi per riposizionare — clicca Blocca quando hai finito",
    ["layout_btn_lock"]                 = "Blocca",
    ["layout_btn_reload"]               = "RL",
    ["layout_btn_gui"]                  = "GUI",
    ["grid_dimmed"]                    = "Griglia",
    ["grid_bright"]                    = "Griglia +",
    ["grid_disabled"]                  = "Griglia OFF",
    ["layout_unlocked"]                 = "EditMode ATTIVO — trascina gli elementi. Clicca Blocca o /tm layout quando hai finito.",
    ["layout_locked"]                   = "EditMode DISATTIVATO — posizioni salvate.",
    ["msg_help_layout"]                 = "Attiva/disattiva EditMode (sposta tutti gli elementi UI)",
    ["mover_unitframes"]                = "Unit Frames",
    ["mover_resources"]                 = "Barre risorse",
    ["mover_skyriding"]                 = "Barra Skyriding",
    ["mover_levelingbar"]               = "Barra XP / Esperienza",
    ["mover_anchors"]                   = "Ancore avvisi e bottino",
    ["mover_cotank"]                    = "Tracciatore Co-Tank",
    ["mover_repbar"]                    = "Barra reputazione",
    ["mover_castbar"]                   = "Barra di lancio (giocatore)",
    ["mover_mythictracker"]             = "Tracker M+",
    ["mover_chatframe"]                 = "Finestra chat",

    -- =====================
    -- COMBAT TEXT
    -- =====================
    ["sublabel_combat_text"]             = "— Testo di combattimento —",
    ["opt_combat_text_enable"]           = "Attiva testo di combattimento",
    ["opt_combat_text_offset_x"]         = "Offset X",
    ["opt_combat_text_offset_y"]         = "Offset Y",

    -- =====================
    -- PREY TRACKER
    -- =====================
    ["sublabel_prey_tracker"]            = "— Tracciatore di Preda —",
    ["opt_prey_tracker_enable"]          = "Abilita Tracciatore di Preda",
    ["opt_prey_tracker_width"]           = "Larghezza",
    ["opt_prey_tracker_font"]            = "Dimensione carattere",
    ["info_prey_tracker"]                = "Funzione esclusiva di Midnight. Mostra una barra di progresso mobile durante una caccia Prey attiva. Posizionala tramite /tm layout.",

    -- =====================
    -- SKINS (Chat)
    -- =====================
    ["tab_qol_skins"]                    = "Skins",
    ["section_skins"]                    = "Skin dell'interfaccia",
    ["info_skins_desc"]                  = "Applica il tema scuro TomoMod a vari elementi dell'interfaccia Blizzard. Potrebbe essere necessario /reload per ripristinare.",
    ["sublabel_chat_skin"]               = "— Finestra chat —",
    ["opt_chat_skin_enable"]             = "Skin della finestra chat",
    ["opt_chat_skin_style"]              = "Stile skin",
    ["opt_chat_skin_style_tui"]          = "TUI (Barra laterale + Finestra)",
    ["opt_chat_skin_style_classic"]      = "Classico (Incorniciato)",
    ["opt_chat_skin_style_glass"]        = "Vetro (Smerigliato)",
    ["opt_chat_skin_style_minimal"]      = "Minimale (Senza bordi)",
    ["opt_chat_skin_bg_alpha"]           = "Opacità del riquadro",
    ["opt_chat_message_bg_alpha"]        = "Opacità dell'area messaggi",
    ["opt_chat_skin_font_size"]          = "Dimensione font chat",
    ["opt_chat_skin_fade"]               = "Fade chat when inactive",
    ["opt_chat_skin_short_channels"]     = "Short channel names (G, P, R…)",
    ["opt_chat_skin_timestamp"]          = "Show timestamps",
    ["opt_chat_skin_url"]                = "Clickable URLs",
    ["opt_chat_skin_emoji"]              = "Replace text emoticons with emoji",
    ["opt_chat_skin_class_colors"]       = "Class-color player names in chat",
    ["opt_chat_copy_button"]             = "Pulsante di copia sulla finestra chat",
    ["opt_chat_copy_button_always"]      = "Sempre visibile",
    ["opt_chat_copy_button_hover"]       = "Al passaggio del mouse",
    ["opt_chat_copy_button_hidden"]      = "Nascosto",
    ["chat_copy_title"]                  = "Copia il testo della chat",
    ["chat_copy_hint"]                   = "Seleziona tutto (Ctrl+A) e copia (Ctrl+C)",
    ["chat_copy_select_all"]             = "Seleziona tutto",
    ["chat_copy_close"]                  = "Chiudi",
    ["chat_copy_empty"]                  = "Nessun messaggio copiabile in questa finestra.",
    ["chat_copy_url_title"]              = "Premi Ctrl+C per copiare",
    ["opt_chat_skin_history"]               = "Ripristinare la cronologia della chat all'accesso",
    ["chat_history_section"]                = "Cronologia della chat",
    ["opt_chat_skin_history_info"]          = "Deselezionare interrompe la registrazione E cancella quanto già memorizzato. La cronologia è salvata per l'intero account, quindi è condivisa da tutti i personaggi.",
    ["opt_chat_history_max_age"]            = "Conservare i messaggi per",
    ["opt_chat_history_age_1h"]             = "1 ora",
    ["opt_chat_history_age_6h"]             = "6 ore",
    ["opt_chat_history_age_24h"]            = "24 ore",
    ["opt_chat_history_age_3d"]             = "3 giorni",
    ["opt_chat_history_age_unlimited"]      = "Nessun limite",
    ["opt_chat_history_max_lines"]          = "Righe massime conservate",
    ["opt_chat_history_delay"]              = "Ritardo prima del ripristino",
    ["opt_chat_history_delay_info"]         = "Attendere qualche secondo permette ai messaggi di caricamento degli addon e agli errori Lua di comparire per primi, invece di finire sepolti sotto la cronologia.",
    ["opt_chat_history_separator"]          = "Mostrare un indicatore di sessione",
    ["opt_chat_history_separator_info"]     = "Stampa una riga dopo la cronologia ripristinata: tutto ciò che segue proviene chiaramente dalla sessione corrente.",
    ["chat_history_separator_text"]         = "Sessione corrente",
    ["sublabel_chat_history_channels"]      = "Canali da ripristinare",
    ["opt_chat_history_ch_whisper"]         = "Sussurri",
    ["opt_chat_history_ch_guild"]           = "Gilda",
    ["opt_chat_history_ch_officer"]         = "Ufficiale",
    ["opt_chat_history_ch_party"]           = "Gruppo",
    ["opt_chat_history_ch_raid"]            = "Incursione",
    ["opt_chat_history_ch_instance"]        = "Istanza",
    ["opt_chat_history_ch_channel"]         = "Canali",
    ["opt_chat_history_ch_say"]             = "Dire",
    ["opt_chat_history_ch_yell"]            = "Urlare",
    ["opt_chat_history_ch_emote"]           = "Emote",
    ["btn_chat_history_clear"]              = "Cancellare la cronologia ora",
    ["popup_chat_history_clear"]            = "Eliminare tutti i messaggi di chat memorizzati? L'operazione è irreversibile.",
    ["msg_chat_history_cleared"]            = "Cronologia della chat cancellata (%d messaggio/i).",
    ["opt_chat_skin_copy_lines"]         = "Show copy icon per message",

    -- Buff Skin
    ["sublabel_buff_skin"]               = "— Skin Buff / Debuff —",

    -- Game Menu Skin
    ["sublabel_game_menu_skin"]          = "— Menu di gioco (Escape) —",
    ["opt_game_menu_skin_enable"]        = "Skin del menu di gioco",
    ["info_game_menu_skin_reload"]       = "Necessario /reload per annullare la skin.",
    ["msg_chat_skin_enabled"]            = "Skin della chat attivato",
    ["msg_chat_skin_disabled"]           = "Skin della chat disattivato (reload per ripristinare)",
    ["sublabel_mail_skin"]               = "— Posta —",
    ["opt_mail_skin_enable"]             = "Skin della posta",
    ["msg_mail_skin_enabled"]            = "Skin della posta attivato",
    ["msg_mail_skin_disabled"]           = "Skin della posta disattivato (reload per ripristinare)",

    -- =====================
    -- WORLD QUEST TAB
    -- =====================
    ["tab_qol_world_quests"]             = "Missioni mondo",
    ["section_wq_tab"]                   = "Tab missioni del mondo",
    ["info_wq_tab_desc"]                 = "Aggiunge al registro missioni una scheda dedicata alle missioni mondiali con ricerca, ordinamento, ricompense, zona e tempo rimanente. Clicca per tracciare una missione e mostrarla sulla mappa.",
    ["opt_wq_enable"]                    = "Attiva tab missioni del mondo",
    ["opt_wq_auto_show"]                 = "Apri questa scheda per impostazione predefinita con il registro missioni",
    ["opt_wq_max_quests"]                = "Max missioni mostrate (0 = illimitato)",
    ["opt_wq_min_time"]                  = "Tempo rimanente min. (minuti, 0 = tutte)",
    ["section_wq_filters"]               = "Filtri ricompense",
    ["opt_wq_filter_gold"]               = "Mostra ricompense oro",
    ["opt_wq_filter_gear"]               = "Mostra ricompense equipaggiamento",
    ["opt_wq_filter_rep"]                = "Mostra ricompense reputazione",
    ["opt_wq_filter_currency"]           = "Mostra ricompense valuta",
    ["opt_wq_filter_anima"]              = "Mostra ricompense anima",
    ["opt_wq_filter_pet"]                = "Mostra ricompense mascotte",
    ["opt_wq_filter_other"]              = "Mostra altre ricompense",
    ["wq_tab_title"]                     = "MM Lista",
    ["wq_panel_title"]                   = "Missioni del mondo",
    ["wq_col_name"]                      = "Nome",
    ["wq_col_zone"]                      = "Zona",
    ["wq_col_reward"]                    = "Ricompensa",
    ["wq_col_time"]                      = "Tempo",
    ["wq_zone"]                          = "Zona",
    ["wq_faction"]                       = "Fazione",
    ["wq_reward"]                        = "Ricompensa",
    ["wq_time_left"]                     = "Tempo rimanente",
    ["wq_elite"]                         = "Missione del mondo élite",
    ["wq_sort_time"]                     = "Tempo",
    ["wq_sort_zone"]                     = "Zona",
    ["wq_sort_name"]                     = "Nome",
    ["wq_sort_reward"]                   = "Ricompensa",
    ["wq_sort_faction"]                  = "Fazione",
    ["wq_status_count"]                  = "Mostrando %d / %d missioni",
    ["wq_empty"]                         = "Nessuna missione mondiale corrisponde ai filtri.",
    ["wq_expired"]                       = "Scaduta",
    ["wq_click_hint"]                    = "Clic: traccia e mostra sulla mappa",
    ["wq_refresh_short"]                 = "A",
    ["wq_reward_gear"]                   = "Equipaggiamento",
    ["wq_reward_reputation"]             = "Reputazione",
    ["wq_reward_pet"]                    = "Mascotte",
    ["wq_reward_other"]                  = "Altro",

    -- Profession Helper
    ["tab_qol_prof_helper"]              = "Professioni",
    ["section_prof_helper"]              = "Assistente professioni",
    ["info_prof_helper_desc"]            = "Disincanta, macina e prospezione di oggetti in blocco con un'interfaccia visiva.",
    ["opt_prof_helper_enable"]           = "Attiva assistente professioni",
    ["sublabel_prof_de_filters"]         = "— Filtri qualità disincantamento —",
    ["opt_prof_filter_green"]            = "Includi oggetti Non comuni (Verdi)",
    ["opt_prof_filter_blue"]             = "Includi oggetti Rari (Blu)",
    ["opt_prof_filter_epic"]             = "Includi oggetti Epici (Viola)",
    ["btn_prof_open_helper"]             = "Apri assistente professioni",
    ["ph_title"]                         = "Assistente professioni",
    ["ph_tab_disenchant"]                = "Disincanta",
    ["ph_filter_quality"]                = "Qualità:",
    ["ph_quality_green"]                 = "Verde",
    ["ph_quality_blue"]                  = "Blu",
    ["ph_quality_epic"]                  = "Epico",
    ["ph_select_all"]                    = "Seleziona tutto",
    ["ph_deselect_all"]                  = "Deseleziona tutto",
    ["ph_btn_process"]                   = "Elabora",
    ["ph_btn_click_process"]             = "Clicca per elaborare",
    ["ph_btn_stop"]                      = "Ferma",
    ["ph_status_idle"]                   = "Clicca su Elabora",
    ["ph_status_processing"]             = "Elaborazione %d/%d: %s",
    ["ph_status_done"]                   = "Fatto! Tutti gli oggetti elaborati.",
    ["ph_item_count"]                    = "%d oggetti disponibili",
    ["ph_ilvl"]                          = "iLvl %d",

    -- ── Class Reminder ──────────────────────────────────────────
    ["tab_qol_class_reminder"]           = "Promemoria classe",
    ["section_class_reminder"]           = "Promemoria buff / forma di classe",
    ["info_class_reminder"]              = "Mostra un'icona per ogni buff, forma, postura o aura di classe mancante. Clic sinistro per lanciarlo, clic centrale per nasconderlo fino al prossimo caricamento.",
    ["opt_class_reminder_enable"]        = "Attiva promemoria classe",
    ["opt_class_reminder_scale"]         = "Scala della fila",
    ["opt_class_reminder_color"]         = "Colore etichetta",
    ["sublabel_class_reminder_pos"]      = "— Posizione —",
    ["info_class_reminder_clicks"]       = "Il clic sinistro lancia l'incantesimo mancante (solo fuori dal combattimento). Il clic centrale nasconde il promemoria fino al prossimo caricamento.",
    ["info_class_reminder_mover"]        = "Sposta la fila di icone dal pannello Spostamento, o riportala al centro dello schermo.",
    ["sublabel_class_reminder_icons"]    = "— Icone —",
    ["opt_class_reminder_icon_size"]     = "Dimensione icone",
    ["opt_class_reminder_spacing"]       = "Spaziatura icone",
    ["opt_class_reminder_opacity"]       = "Opacità",
    ["sublabel_class_reminder_text"]     = "— Etichetta —",
    ["opt_class_reminder_show_text"]     = "Mostra etichetta sotto le icone",
    ["opt_class_reminder_text_size"]     = "Dimensione etichetta",
    ["sublabel_class_reminder_glow"]     = "— Bagliore —",
    ["opt_class_reminder_glow"]          = "Tipo di bagliore",
    ["opt_class_reminder_glow_color"]    = "Colore del bagliore",
    ["cr_glow_none"]                     = "Nessuno",
    ["cr_glow_pixel"]                    = "Bagliore a pixel",
    ["cr_glow_autocast"]                 = "Scintillio",
    ["cr_glow_button"]                   = "Bagliore da barra azioni",
    ["cr_glow_proc"]                     = "Bagliore proc",
    ["info_class_reminder_preview_hint"] = "Clicca un'icona per raggiungere il suo interruttore, la sua etichetta per le opzioni etichetta, o l'area vuota per le dimensioni.",
    ["info_class_reminder_coverage"]     = "Deseleziona ciò per cui non vuoi promemoria. In gioco viene controllata solo la tua classe.",
    ["cr_lethal_poison"]                 = "Veleno letale",
    ["cr_nonlethal_poison"]              = "Veleno non letale",
    ["cr_flametongue"]                   = "Arma Linguafiamma",
    ["cr_windfury"]                      = "Arma Furia del Vento",
    ["cr_earthliving"]                   = "Arma Terra Vivente",
    ["cr_tidecaller"]                    = "Guardia dell'Evocamaree",
    ["cr_thunderstrike"]                 = "Egida del Colpo di Tuono",
    ["cr_earth_shield_self"]             = "Scudo di Terra (su di sé)",
    ["cr_orbit_shield"]                  = "Scudo di Fulmini / d'Acqua",
    ["cr_shield"]                        = "Scudo",
    ["cr_paladin_rite"]                  = "Rito",
    ["sublabel_class_reminder_context"]  = "— Contesto —",
    ["opt_class_reminder_show_in"]       = "Mostra promemoria",
    ["cr_show_always"]                   = "Ovunque",
    ["cr_show_instances"]                = "Solo in spedizioni e incursioni",
    ["cr_show_group"]                    = "Solo in gruppo",
    ["opt_class_reminder_hide_resting"]  = "Nascondi in città e locande",
    ["opt_class_reminder_others_missing"] = "Avvisa anche quando a un membro del gruppo manca un buff",
    ["info_class_reminder_others"]       = "Contano solo i membri a portata che beneficiano del buff, e solo fuori dal combattimento: le aure di un altro giocatore non sono leggibili in combattimento.",

    -- Buff / Form names
    ["cr_fortitude"]                     = "Parola del Potere: Tempra",
    ["cr_shadowform"]                    = "Forma d'Ombra",
    ["cr_arcane_intellect"]              = "Intelletto Arcano",
    ["cr_skyfury"]                       = "Furia Celeste",
    ["cr_mark_of_the_wild"]              = "Marchio del Selvaggio",
    ["cr_cat_form"]                      = "Forma di Felino",
    ["cr_bear_form"]                     = "Forma di Orso",
    ["cr_moonkin_form"]                  = "Forma di Lunagufo",
    ["cr_battle_shout"]                  = "Grido di Battaglia",
    ["cr_battle_stance"]                 = "Postura di Battaglia",
    ["cr_berserker_stance"]              = "Postura Berserker",
    ["cr_defensive_stance"]              = "Postura Difensiva",
    ["cr_aura"]                          = "Aura",
    ["cr_blessing_bronze"]               = "Benedizione del Bronzo",
    ["cr_preview_sample"]                = "Esempio: buff di classe mancante",

    -- =====================
    -- MYTHIC TRACKER (TomoMythic integration)
    -- =====================
    ["tmt_cmd_usage"]               = "|cFF55B400/tmt|r : configurazione  |  |cFF55B400unlock|r : sposta  |  |cFF55B400lock|r : blocca  |  |cFF55B400reset|r : reimposta posizione  |  |cFF55B400preview|r : anteprima  |  |cFF55B400key|r : chiavi del gruppo  |  |cFF55B400kr|r : roulette  |  |cFF55B400keysync|r : diagnostica di sincronizzazione",
    ["tmt_unlock_msg"]              = "|cffffd100TomoModForever|r M+ Tracker: Riquadro sbloccato \226\128\148 trascina per riposizionare.",
    ["tmt_lock_msg"]                = "|cffffd100TomoModForever|r M+ Tracker: Riquadro bloccato.",
    ["tmt_reset_msg"]               = "|cffffd100TomoModForever|r M+ Tracker: Posizione reimpostata.",
    ["tmt_unknown_cmd"]             = "|cffffd100TomoModForever|r M+ Tracker: Comando sconosciuto.",
    ["tmt_key_level"]               = "+%d",
    ["tmt_dungeon_unknown"]         = "Mitico+",
    ["tmt_overtime"]                = "TEMPO SCADUTO",
    ["tmt_completed_on_time"]       = "COMPLETATO",
    ["tmt_completed_depleted"]      = "FALLITO",
    ["tmt_forces"]                  = "FORZE",
    ["tmt_forces_done"]             = "COMPLETO",
    ["tmt_forces_pct"]              = "%.1f%%",
    ["tmt_forces_count"]            = "%d / %d",
    ["tmt_forces_remaining"]        = "%d rimasti",
    ["tmt_deaths"]                  = "Morti",
    ["tmt_time_lost"]               = "Tempo perso: %s",
    ["tmt_cfg_preset"]              = "Stile",
    ["tmt_cfg_preset_panel"]        = "Pannello",
    ["tmt_cfg_preset_hud"]          = "HUD",
    ["tmt_cfg_show_background"]     = "Sfondo del pannello",
    ["tmt_cfg_show_header"]         = "Blocco intestazione",
    ["tmt_cfg_show_dungeon"]        = "Nome del dungeon",
    ["tmt_cfg_objective_style"]     = "Elenco boss",
    ["tmt_cfg_objective_rows"]      = "Righe",
    ["tmt_cfg_objective_text"]      = "Testo",
    ["tmt_cfg_font_scale"]          = "Dimensione testo",
    ["tmt_cfg_preset_minimal"]        = "Minimale",
    ["tmt_cfg_objective_none"]        = "Nascosta",
    ["tmt_cfg_timer_layout"]          = "Disposizione timer",
    ["tmt_cfg_timer_stacked"]         = "Due righe",
    ["tmt_cfg_timer_inline"]          = "Una riga",
    ["tmt_cfg_segment_colors"]        = "Colori dei segmenti",
    ["tmt_cfg_segment_palier"]        = "Per soglia",
    ["tmt_cfg_segment_brand"]         = "Marchio",
    ["tmt_cfg_splits"]                = "Confronta col miglior tempo",
    ["tmt_cfg_checkpoints"]           = "Checkpoint delle forze",
    ["tmt_cfg_clear_splits"]          = "Cancella i tempi registrati",
    ["tmt_splits_cleared"]            = "|cffffd100TomoModForever|r M+ Tracker: tempi registrati cancellati.",
    ["tmt_cds_reload_text"]           = "Cooldown Studio resta caricato fino al ricaricamento dell\226\128\153interfaccia. Ricaricare ora lo libera ed elimina il taint di questa sessione.",
    ["tmt_cds_reload_now"]            = "Ricarica",
    ["tmt_cds_reload_later"]          = "Pi\195\185 tardi",
    ["tmt_cfg_cds_safety_reload"]     = "Ricarica l\226\128\153interfaccia dopo la chiusura dello Studio",
    ["tmt_cfg_title"]               = "Mythic",
    ["tmt_cfg_panel_enable"]         = "Abilita tracker M+",
    ["tmt_cfg_show_timer"]          = "Mostra barra del timer",
    ["tmt_cfg_show_forces"]         = "Mostra forze nemiche",
    ["tmt_cfg_show_bosses"]         = "Mostra timer dei boss",
    ["tmt_cfg_hide_blizzard"]       = "Nascondi tracker di Blizzard",
    ["tmt_cfg_lock"]                = "Blocca riquadro",
    ["tmt_cfg_scale"]               = "Scala",
    ["tmt_cfg_alpha"]               = "Opacità sfondo",
    ["tmt_cfg_reset_pos"]           = "Reimposta posizione",
    ["tmt_cfg_preview"]             = "Anteprima",
    ["tmt_cfg_section_display"]     = "Visualizzazione",
    ["tmt_cfg_section_frame"]       = "Riquadro",
    ["tmt_cfg_section_actions"]     = "Azioni",
    ["tmt_key_not_available"]       = "non disponibile.",
    ["tmt_key_not_in_group"]        = "Non sei in un gruppo.",
    ["tmt_key_none_found"]          = "Nessuna chiave trovata.",
    ["tmt_kr_spin"]                 = "|TInterface\\Icons\\INV_Misc_Dice_02:14|t  Gira!",
    ["tmt_preview_active"]          = "|cffffd100TomoModForever|r M+ Tracker: Anteprima attiva \226\128\148 |cFF55B400/tmt lock|r per bloccare.",

    -- MythicHub
    ["mhub_title"]                  = "Punteggio Mitica+",
    ["mhub_col_dungeon"]            = "Spedizione",
    ["mhub_col_level"]              = "Livello",
    ["mhub_col_rating"]             = "Punteggio",
    ["mhub_col_best"]               = "Migliore",
    ["mhub_tp_click"]               = "Clicca per teletrasportarti",
    ["mhub_tp_not_available"]        = "Teletrasporto non appreso",
    ["mhub_tp_not_learned"]          = "|cffffd100TomoModForever|r: Incantesimo di teletrasporto non appreso.",
    ["mhub_vault_title"]            = "Grande Camera Blindata",
    ["mhub_vault_dungeons"]         = "Spedizioni",
    ["mhub_vault_raids"]            = "Incursioni",
    ["mhub_vault_world"]            = "Abissi",
    ["mhub_vault_ilvl"]             = "Livello oggetto",
    ["mhub_vault_locked"]           = "Bloccato",
    ["mhub_vault_claim"]            = "Torna alla Grande Camera Blindata per riscuotere la tua ricompensa",

    -- ══════════════════════════════════════════════════════════
    -- INSTALLER
    -- ══════════════════════════════════════════════════════════

    -- Navigation
    ["ins_header_title"]             = "|cffffd100Tomo|r|cfff2ebdbMod|r |cffc9a252Forever|r  \226\128\148  Assistente di configurazione",
    ["ins_step_counter"]             = "Passaggio %d / %d",
    ["ins_btn_prev"]                 = "|TInterface\\BUTTONS\\UI-SpellbookIcon-PrevPage:0|t Precedente",
    ["ins_btn_next"]                 = "Avanti |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t",
    ["ins_btn_finish"]               = "Termina |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t",
    ["ins_btn_skip"]                 = "Salta l'installazione",

    -- Step 1: Welcome
    ["ins_step1_title"]              = "Benvenuto in TomoMod",
    ["ins_subtitle"]                 = "Suite di interfaccia e QOL per The War Within",
    ["ins_welcome_desc"]             = "Questo assistente ti guider\195\160 in |cffffd10016 passaggi|r per configurare TomoMod\nsecondo le tue preferenze: unit frame, party frame, barre di lancio, nameplate, barre azione,\nrisorse, skin, suoni, Mythic+, QOL, ottimizzazioni e SkyRide.\n\nTutte queste opzioni possono essere modificate in qualsiasi momento con |cffffd100/tm|r.",

    -- Step 2: Profile
    ["ins_step2_title"]              = "Profilo di gioco",
    ["ins_profile_info"]             = "Crea un profilo con nome per salvare la tua configurazione.",
    ["ins_profile_section"]          = "Nome del profilo",
    ["ins_profile_placeholder"]      = "Il mio profilo",
    ["ins_profile_create"]           = "Crea profilo",
    ["ins_profile_created"]          = "Profilo creato: ",
    ["ins_spec_section"]             = "Assegnazione specializzazioni",
    ["ins_spec_info"]                = "Puoi assegnare questo profilo alle tue spec dal pannello Profili (/tm).\nOgni spec pu\195\178 usare una configurazione diversa.",

    -- Step 3: Visual Skins
    ["ins_step3_title"]              = "Skin visive",
    ["ins_skins_info"]               = "Personalizza l'interfaccia Blizzard con il tema scuro di TomoMod.",
    ["ins_skins_section"]            = "Skin disponibili",
    ["ins_skin_gamemenu"]            = "Skin del menu di gioco (Escape)",
    ["ins_skin_actionbar"]           = "Skin dei pulsanti barra azione",
    ["ins_skin_chat"]                = "Skin della chat",
    ["ins_skin_character"]           = "Skin della scheda personaggio",
    ["ins_skin_style_section"]       = "Stile pulsanti barra azione",
    ["ins_skin_style"]               = "Stile visivo",

    -- Step 4: Tank Mode
    ["ins_step4_title"]              = "Modalit\195\160 Tank",
    ["ins_tank_info"]                = "In modalit\195\160 tank, le nameplate e gli UnitFrame mostrano\nlo stato di minaccia a colori per ogni nemico.",
    ["ins_tank_np_section"]          = "Nameplate \226\128\148 Colori minaccia",
    ["ins_tank_enable_np"]           = "Attiva modalit\195\160 tank (nameplate)",
    ["ins_tank_colors_info"]         = "Verde = hai l'aggro  \194\183  Arancione = stai per perderlo  \194\183  Rosso = aggro perso",
    ["ins_tank_uf_section"]          = "UnitFrame \226\128\148 Indicatore di minaccia",
    ["ins_tank_threat_indicator"]    = "Mostra indicatore di minaccia sul bersaglio",
    ["ins_tank_threat_text"]         = "Mostra testo minaccia % sul bersaglio",
    ["ins_tank_cotank_section"]      = "CoTank Tracker",
    ["ins_tank_cotank_enable"]       = "Attiva tracciamento co-tank",
    ["ins_tank_cotank_info"]         = "Mostra la minaccia del secondo tank nelle istanze.",

    -- Step 5: Nameplates
    ["ins_step5_title"]              = "Nameplate",
    ["ins_np_general"]               = "Generale",
    ["ins_np_enable"]                = "Attiva nameplate di TomoMod",
    ["ins_np_reload_info"]           = "\195\136 necessario un reload per attivare/disattivare le nameplate.",
    ["ins_np_display"]               = "Visualizzazione",
    ["ins_np_class_colors"]          = "Colori di classe",
    ["ins_np_castbar"]               = "Mostra barra di lancio",
    ["ins_np_health_text"]           = "Mostra testo salute (percentuale)",
    ["ins_np_auras"]                 = "Mostra aure (debuff)",
    ["ins_np_role_icons"]            = "Mostra icone ruolo (dungeon)",
    ["ins_np_dimensions"]            = "Dimensioni",
    ["ins_np_width"]                 = "Larghezza",

    -- Step 6: Action Bars
    ["ins_step6_title"]              = "Barre azione",
    ["ins_ab_system_section"]        = "Action Bar System",
    ["ins_ab_system_info"]           = "TomoMod replaces Blizzard's action bars with custom containers,\npositioning, fade system and display conditions.\nDisable this to fully restore the default Blizzard action bars.",
    ["ins_ab_system_enable"]         = "Enable TomoMod Action Bar system",
    ["ins_ab_system_reload_info"]    = "Requires a /reload to take effect.",
    ["ins_ab_skin_section"]          = "Skin pulsanti",
    ["ins_ab_enable"]                = "Attiva skin sui pulsanti azione",
    ["ins_ab_class_color"]           = "Colore bordo = colore di classe",
    ["ins_ab_shift_reveal"]          = "Tieni Shift per mostrare le barre nascoste",
    ["ins_ab_opacity_section"]       = "Opacit\195\160 globale barre",
    ["ins_ab_opacity"]               = "Opacit\195\160",
    ["ins_ab_manage_section"]        = "Gestione barre",
    ["ins_ab_manage_info"]           = "Usa il pannello Barre azione (/tm |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Barre azione |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Gestione)\nper sbloccare e riposizionare ogni barra.",

    -- Step 7: LustSound
    ["ins_step7_title"]              = "Suono \226\128\148 Eroismo / Sete di sangue",
    ["ins_sound_info"]               = "Riproduce un suono personalizzato quando Eroismo o Sete di sangue\nviene lanciato da un membro del gruppo.",
    ["ins_sound_activation"]         = "Attivazione",
    ["ins_sound_enable"]             = "Attiva suono lust",
    ["ins_sound_choice"]             = "Selezione suono",
    ["ins_sound_sound"]              = "Suono",
    ["ins_sound_channel"]            = "Canale audio",
    ["ins_sound_default"]            = "Predefinito",
    ["ins_sound_preview_section"]    = "Anteprima",
    ["ins_sound_preview_btn"]        = "|TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Anteprima",

    -- Step 8: Mythic+
    ["ins_step8_title"]              = "Mythic+ \226\128\148 Tracker e Classifica",
    ["ins_mplus_tracker_section"]    = "M+ Tracker",
    ["ins_mplus_tracker_info"]       = "Mostra un timer, le forze, i boss e il progresso\ndel tuo dungeon Mythic+ in tempo reale.",
    ["ins_mplus_tracker_enable"]     = "Attiva M+ Tracker",
    ["ins_mplus_show_timer"]         = "Mostra timer",
    ["ins_mplus_show_forces"]        = "Mostra forze (%)",
    ["ins_mplus_hide_blizzard"]      = "Nascondi interfaccia Blizzard in Mythic+",
    ["ins_mplus_score_section"]      = "TomoScore \226\128\148 Classifica",
    ["ins_mplus_score_info"]         = "Mostra i punteggi personali e di gruppo alla fine di un Mythic+.",
    ["ins_mplus_score_enable"]       = "Attiva TomoScore",
    ["ins_mplus_score_auto"]         = "Mostra automaticamente in M+",

    -- Step 9: CVars
    ["ins_step9_title"]              = "Ottimizzazioni di sistema (CVars)",
    ["ins_cvar_info"]                = "TomoMod pu\195\178 applicare un set di CVars WoW consigliate\nper migliorare prestazioni e reattivit\195\160.",
    ["ins_cvar_section"]             = "Ottimizzazioni incluse",
    ["ins_cvar_opt1"]                = "Ridurre il Level of Detail (LOD) non necessario",
    ["ins_cvar_opt2"]                = "Ottimizzare il frustum culling",
    ["ins_cvar_opt3"]                = "Disattivare il temporal AA eccessivo",
    ["ins_cvar_opt4"]                = "Migliorare la reattivit\195\160 di rete",
    ["ins_cvar_opt5"]                = "Disattivare le animazioni UI non necessarie",
    ["ins_cvar_opt6"]                = "Ottimizzare lo streaming delle texture",
    ["ins_cvar_success"]             = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t  CVars applicate con successo!",
    ["ins_cvar_apply_btn"]           = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0|t Applica tutte le CVars",
    ["ins_cvar_applied"]             = "CVars ottimizzate applicate.",

    -- Step 10: QOL
    ["ins_step10_title"]             = "Qualit\195\160 della vita (QOL)",
    ["ins_qol_info"]                 = "Attiva i moduli QOL che desideri.\nTutti sono accessibili separatamente in /tm |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t QOL.",
    ["ins_qol_auto_section"]         = "Automatismi",
    ["ins_qol_auto_repair"]          = "Ripara automaticamente dal mercante",
    ["ins_qol_fast_loot"]            = "Loot veloce (raccolta rapida degli oggetti)",
    ["ins_qol_skip_cinematics"]      = "Salta cinematiche gi\195\160 viste",
    ["ins_qol_hide_talking_head"]    = "Nascondi Talking Head (dialoghi a scorrimento)",
    ["ins_qol_auto_accept"]          = "Accetta inv. di gruppo automaticamente (amici e gilda)",
    ["ins_qol_tooltip_ids"]          = "Mostra ID nei tooltip (spell ID, item ID...)",
    ["ins_qol_combat_section"]       = "Combattimento",
    ["ins_qol_combat_text"]          = "Testo di combattimento fluttuante personalizzato",
    ["ins_qol_hide_castbar"]         = "Nascondi barra di lancio Blizzard (usa quella di TomoMod)",

    -- Step 11: SkyRide
    ["ins_step11_title"]             = "SkyRide \226\128\148 Barra cavalcatura draconica",
    ["ins_skyride_info"]             = "SkyRide mostra una barra Vigore (6 cariche) e una barra\nSecondo Respiro (3 cariche) per la cavalcatura draconica.",
    ["ins_skyride_activation"]       = "Attivazione",
    ["ins_skyride_enable"]           = "Attiva barra SkyRide",
    ["ins_skyride_auto_info"]        = "La barra appare automaticamente in modalit\195\160 volo draconico\ne si nasconde al di fuori.",
    ["ins_skyride_dimensions"]       = "Dimensioni",
    ["ins_skyride_width"]            = "Larghezza",
    ["ins_skyride_height"]           = "Altezza",
    ["ins_skyride_reset_section"]    = "Ripristina posizione",
    ["ins_skyride_reset_btn"]        = "Ripristina posizione",

    -- Step 12: Done
    ["ins_step12_title"]             = "Configurazione completata!",
    ["ins_done_check"]               = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t  Tutto pronto!",
    ["ins_done_recap"]               = "La tua configurazione TomoMod \195\168 salvata. Ecco alcuni promemoria:\n\n|cffffd100/tm|r              |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t  Apri il pannello di configurazione\n|cffffd100/tm sr|r           |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t  Sblocca e sposta gli elementi\n|cffffd100/tm install|r      |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t  Rilancia questo installatore\n\nTutte le opzioni configurate qui possono essere modificate in qualsiasi momento\ndai pannelli corrispondenti nella GUI di TomoMod.\n\nUn |cffffd100reload della UI|r \195\168 necessario per applicare alcune modifiche\n(nameplate, skin, UnitFrame).",
    ["ins_done_reload"]              = "|TInterface\\BUTTONS\\UI-RefreshButton:0|t  Ricarica UI",

    -- Step NEW: Unit Frames
    ["ins_uf_title"]                 = "Unit Frame",
    ["ins_uf_info"]                  = "TomoMod sostituisce i frame unit\195\160 predefiniti di Blizzard (giocatore, bersaglio, focus, famiglio)\ncon frame moderni e personalizzabili.",
    ["ins_uf_section"]               = "Generale",
    ["ins_uf_enable"]                = "Attiva UnitFrame di TomoMod",
    ["ins_uf_hide_blizzard"]         = "Nascondi frame predefiniti di Blizzard",
    ["ins_uf_reload_info"]           = "\195\136 necessario un reload per applicare le modifiche agli UnitFrame.",

    -- Step NEW: Party Frames
    ["ins_pf_title"]                 = "Party Frame",
    ["ins_pf_info"]                  = "Frame di gruppo personalizzati con icone ruolo, evidenziazione dispel\ne tracciamento cooldown per il gioco di gruppo.",
    ["ins_pf_section"]               = "Generale",
    ["ins_pf_enable"]                = "Attiva Party Frame di TomoMod",
    ["ins_pf_hide_blizzard"]         = "Nascondi Party Frame di Blizzard",
    ["ins_pf_cd_section"]            = "Tracker cooldown",
    ["ins_pf_cd_info"]               = "Traccia i cooldown di interruzione e resurrezione in combattimento\ndei tuoi compagni direttamente sui loro frame di gruppo.",
    ["ins_pf_show_interrupt"]        = "Mostra tracker cooldown interruzione",
    ["ins_pf_show_brez"]             = "Mostra tracker cooldown resurrezione in combattimento",
    ["ins_pf_reload_info"]           = "\195\136 necessario un reload per applicare le modifiche ai Party Frame.",

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
    ["ins_cb_title"]                 = "Barre di lancio",
    ["ins_cb_info"]                  = "Barre di lancio personalizzate per giocatore, bersaglio, focus e famiglio\ncon animazione scintilla e feedback di interruzione.",
    ["ins_cb_section"]               = "Generale",
    ["ins_cb_enable"]                = "Attiva barre di lancio di TomoMod",
    ["ins_cb_hide_blizzard"]         = "Nascondi barra di lancio predefinita di Blizzard",
    ["ins_cb_class_color"]           = "Usa colore di classe per il riempimento",
    ["ins_cb_reload_info"]           = "\195\136 necessario un reload per applicare le modifiche alle barre di lancio.",

    -- Step NEW: Resource Bars & Cooldown Manager
    ["ins_res_title"]                = "Risorse & Cooldown",
    ["ins_res_info"]                 = "Visualizzazione potere di classe (punti combo, rune, frammenti d'anima, ecc.)\nin modalit\195\160 icona o barra.",
    ["ins_res_section"]              = "Barre risorse",
    ["ins_res_enable"]               = "Attiva barre risorse",
    ["ins_res_display"]              = "Modalit\195\160 di visualizzazione",
    ["ins_cdm_section"]              = "Gestore cooldown",
    ["ins_cdm_info"]                 = "Spirale di cooldown sui pulsanti azione con\nalfa adattivo al combattimento e filtraggio GCD.",
    ["ins_cdm_enable"]               = "Attiva gestore cooldown",
    ["ins_cdm_hide_gcd"]             = "Nascondi spirale GCD",
    ["ins_cdm_desat"]                = "Desatura pulsanti in cooldown",

    -- Enhanced Skins
    ["ins_skin_bag"]                 = "Skin borse",
    ["ins_skin_tooltip"]             = "Skin tooltip",
    ["ins_skin_objective"]           = "Objective Tracker skin (color-coded quest types)",
    ["ins_skin_mail"]                = "Mail skin",
    ["ins_skin_reputation"]          = "Reputation bar",

    -- Enhanced QOL
    ["ins_qol_interface_section"]    = "Interfaccia",
    ["ins_qol_minimap"]              = "Minimappa personalizzata (bordo e scala)",
    ["ins_qol_cursor"]               = "Anello cursore luminoso",
    ["ins_qol_afk"]                  = "Schermata AFK personalizzata con modello 3D",
    ["ins_qol_diag"]                 = "Diagnostica (cattura errori senza popup)",
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
    ["opt_abs_style"]                = "Stile visivo",
    ["section_bar_opacity"]          = "Opacit\195\160 per barra",
    ["opt_abs_bar_select"]           = "Barra da configurare",
    ["opt_abs_opacity"]              = "Opacit\195\160",
    ["btn_abs_apply_all"]            = "Applica a tutte le barre",
    ["opt_abs_combat_only_label"]    = "Mostra solo in combattimento:",
    ["opt_abs_combat_only"]          = "Barra visibile solo in combattimento",
    ["section_bar_management"]       = "Gestione barre d'azione",
    ["btn_abs_unlock"]               = "Sblocca barre",
    ["info_abs_unlock"]              = "Sblocca le barre per mostrare le maniglie di trascinamento.\nClic destro su una maniglia per configurare una barra singolarmente.",
    ["section_bar_quick"]            = "Impostazioni rapide",
    ["tab_abs_skin"]                 = "Skin pulsanti",
    ["tab_abs_bars"]                 = "Gestione barre",
    ["info_abs_layout"]              = "Usa l'EditMode per spostare le barre o trascina gli overlay.\nEspandi una barra qui sotto per regolare dimensione dei pulsanti e scala.",
    -- General panel
    ["opt_gui_scale"]                = "Scala della finestra di configurazione",
    ["info_gui_scale"]               = "Scala della finestra /tm \226\128\148 pu\195\178 anche essere ridimensionata trascinando l'angolo in basso a destra.",
    ["btn_gui_reset_size"]           = "Ripristina dimensione e scala della finestra",
    ["btn_relaunch_installer"]       = "Rilancia installatore",
    ["info_relaunch_installer"]      = "Avvia la procedura guidata di configurazione in 16 passaggi.",
    -- Sound panel
    ["section_sound_preview"]        = "Anteprima e opzioni",
    -- UFPreview
    ["preview_header"]               = "ANTEPRIMA DAL VIVO",
    ["preview_player"]               = "Giocatore",
    ["preview_target_name"]          = "Taurache",
    ["preview_focus_name"]           = "Sacerdotessa",
    ["preview_pet_name"]             = "Lupo d'acqua",
    ["preview_tot_name"]             = "Bersaglio-del-bersaglio",
    ["preview_cast_player"]          = "Saetta di Gelo",
    ["preview_cast_target"]          = "Palla di Fuoco",
    ["preview_lbl_player"]           = "GIOCATORE",
    ["preview_lbl_target"]           = "BERSAGLIO",
    ["preview_lbl_focus"]            = "FOCUS",
    ["preview_lbl_pet"]              = "PET",
    ["preview_lbl_tot"]              = "TOT",
    ["preview_click_nav"]            = "clicca per navigare",
    ["preview_click_isolate"]         = "clicca per isolare",
    ["preview_click_show_all"]        = "clicca per mostrare tutto",
    ["preview_show_all"]              = "Mostra tutto",
    ["preview_zoom_fit"]                = "Adatta",
    ["preview_zoom_11"]                 = "1:1",
    ["preview_zoom_tip"]                = "Alterna tra adattamento al pannello e dimensione reale 1:1.",
    ["preview_all_disabled"]            = "Tutti i riquadri unit\195\160 sono disattivati.",
    ["preview_engine_missing"]          = "Motore UnitFrames non caricato.",
    ["preview_data_live"]               = "Dati reali",
    ["preview_data_mock"]               = "Simulato",
    ["preview_data_tip"]                = "Alimenta l'anteprima con i dati reali quando l'unit\195\160 esiste, altrimenti usa valori simulati.",
    ["preview_tag_live"]                = "REALE",
    ["preview_tag_sim"]                 = "SIM",
    -- ConfigUI footer
    ["ui_footer_hint"]               = "/tm  \194\183  /tm sr per spostare gli elementi",

    -- =====================
    -- SKINS CATEGORY (top-level)
    -- =====================
    ["cat_skins"]                        = "Skins",

    -- Chat Frame V2 — etichette schede e interfaccia
    ["chatv2_tab_general"]               = "Generale",
    ["chatv2_tab_instance"]              = "Istanza",
    ["chatv2_tab_chucho"]                = "Chucho",
    ["chatv2_tab_personnel"]             = "Personale",
    ["chatv2_tab_combat"]                = "Combattimento",
    ["chatv2_sidebar_title"]             = "CHAT",
    ["chatv2_expand_btn"]                = "Chat",
    ["chatv2_mover_label"]               = "Finestra chat V2",
    ["chatv2_input_hint"]                = "Premi Invio per scrivere...",

    -- Skins > Chat Frame tab
    ["tab_skin_chatframe"]               = "Finestra di chat",
    ["section_skin_chatframe"]           = "Skin finestra di chat",
    ["info_skin_chatframe_desc"]         = "Pannello chat con barra laterale \226\128\148 Generale, Istanza, Chucho, Personale, Combattimento \226\128\148 con badge non letti e indicatori pin.",
    ["opt_skin_chatframe_enable"]        = "Attiva skin della chat",
    ["opt_skin_chatframe_width"]         = "Larghezza",
    ["opt_skin_chatframe_height"]        = "Altezza",
    ["opt_skin_chatframe_scale"]         = "Scala %",
    ["opt_skin_chatframe_opacity"]       = "Opacit\195\160 dello sfondo",
    ["opt_skin_chatframe_font_size"]     = "Dimensione del carattere",
    ["opt_skin_chatframe_timestamp"]     = "Mostra data e ora",

    -- Skins > Bags tab
    ["tab_skin_bags"]                    = "Borse",
    ["section_skin_bags"]                = "Skin delle borse",
    ["info_skin_bags_desc"]              = "Griglia borse per categoria ispirata a BetterBags. Oggetti raggruppati in sezioni comprimibili con bordi qualit\195\160, ricerca, tempi di ricarica e livello oggetto.",
    ["opt_skin_bags_enable"]             = "Attiva skin delle borse",
    -- Borse — Disincanto
    ["bagskin_currencies_none"]          = "Nessuna valuta monitorata (clic destro su una valuta \226\134\146 Mostra nello zaino)",
    ["opt_skin_bags_stack_merge"]        = "Unisci pile identiche",
    ["opt_skin_bags_show_empty"]         = "Mostra sezione slot liberi",
    ["opt_skin_bags_show_recent"]        = "Mostra sezione oggetti recenti",
    ["opt_skin_bags_columns"]            = "Colonne",
    ["opt_skin_bags_slot_size"]          = "Dimensione slot",
    ["opt_skin_bags_slot_spacing"]       = "Spaziatura slot",
    ["opt_skin_bags_scale"]              = "Scala %",
    ["opt_skin_bags_opacity"]            = "Opacit\195\160 dello sfondo",
    ["opt_skin_bags_quality_borders"]    = "Mostra bordi qualit\195\160",
    ["bags_v4_quality_style"]            = "Qualità oggetto",
    ["bags_v4_quality_tint"]             = "Casella colorata",
    ["bags_v4_quality_border"]           = "Cornice colorata",
    ["bags_v4_quality_both"]             = "Entrambi",
    ["bags_v4_quality_none"]             = "Nessuno",
    ["opt_skin_bags_cooldowns"]          = "Mostra tempi di ricarica",
    ["opt_skin_bags_quantity"]           = "Mostra badge quantit\195\160",
    ["opt_skin_bags_search"]             = "Mostra barra di ricerca",
    ["opt_skin_bags_sort_mode"]          = "Modalit\195\160 di ordinamento",
    ["opt_skin_bags_sort_quality"]       = "Qualit\195\160",
    ["opt_skin_bags_sort_name"]          = "Nome",
    ["opt_skin_bags_sort_type"]          = "Tipo",
    ["opt_skin_bags_sort_ilvl"]          = "Livello oggetto",
    ["opt_skin_bags_sort_recent"]        = "Recente",
    ["opt_skin_bags_show_gold"]          = "Mostra oro (pi\195\168 di pagina)",
    ["opt_skin_bags_show_currencies"]    = "Mostra valute tracciate (pi\195\168 di pagina)",

    -- Skins > Objective Tracker tab
    ["tab_skin_objtracker"]              = "Obiettivi",

    -- Skins > Character tab
    ["tab_skin_character"]               = "Personaggio",

    -- Skins > Buffs tab

    -- Skins > Game Menu tab
    ["tab_skin_gamemenu"]                = "Menu di gioco",

    -- Skins > Mail tab
    ["tab_skin_mail"]                    = "Posta",

    -- =====================
    -- MODULO WAYPOINT (/tm way)
    -- =====================
    -- GUI
    ["tab_qol_waypoint"]                  = "Waypoint",
    ["section_waypoint"]                  = "Waypoint",
    ["opt_way_zone_only"]                 = "Mostra solo nella zona corrente",
    ["opt_way_size"]                      = "Dimensione del segnale",
    ["opt_way_shape"]                     = "Forma",
    ["way_shape_ring"]                    = "Anello",
    ["way_shape_arrow"]                   = "Freccia",
    ["opt_way_color"]                     = "Colore del waypoint",
    -- Slash
    ["msg_help_way"]                     = "Posiziona un waypoint alla tua posizione attuale",
    ["msg_help_way_coords"]              = "Posiziona un waypoint alle coordinate (x, y)",
    ["msg_help_way_clear"]               = "Rimuovi il waypoint attivo",
    ["way_cleared"]                      = "Waypoint rimosso.",
    ["way_set"]                          = "Waypoint impostato su %s%s.",
    ["way_here"]                         = "Waypoint posizionato alla posizione attuale.",
    ["way_no_map"]                       = "Impossibile determinare la mappa attuale.",
    ["way_no_pos"]                       = "Impossibile determinare la posizione del giocatore.",
    ["way_bad_map"]                      = "Impossibile posizionare un waypoint su questa mappa.",
    ["way_bad_coords"]                   = "Le coordinate devono essere comprese tra 0 e 100.",
    ["way_usage"]                        = "Uso: /tm way [mapID] x y [nome]  |  /tm way clear",

    -- =====================
    -- Resource names
    -- =====================
    ["res_mana"]                        = "Mana (Druido)",
    ["res_soul_shards"]                 = "Frammenti d'anima",
    ["res_holy_power"]                  = "Potere sacro",
    ["res_chi"]                         = "Chi",
    ["res_combo_points"]                = "Punti combo",
    ["res_charged_combo_points"]        = "Punti combo sovraccarichi",
    ["res_arcane_charges"]              = "Cariche arcane",
    ["res_essence"]                     = "Essenza",
    ["res_stagger"]                     = "Barcollamento",
    ["res_soul_fragments"]              = "Frammenti d'anima",
    ["res_tip_of_spear"]                = "Punta della lancia",
    ["res_maelstrom_weapon"]            = "Arma del Maelstrom",
    ["res_icicles"]                      = "Ghiaccioli",

    -- =====================
    -- Resource Bars display mode
    -- =====================
    ["opt_rb_display_mode"]             = "Modalità di visualizzazione",
    ["display_mode_icons"]              = "Icone (texture TUI)",
    ["display_mode_bars"]               = "Barre (colori piatti)",

    -- =====================
    -- Tooltip Skin
    -- =====================
    ["tab_skin_tooltip"]                 = "Tooltip",
    ["section_tooltip_skin"]             = "Skin Tooltip",
    ["opt_tooltip_skin_enable"]          = "Attiva skin tooltip",
    ["info_tooltip_skin_reload"]         = "Alcune modifiche richiedono di passare il cursore su un nuovo bersaglio.",
    ["opt_tooltip_bg_alpha"]             = "Opacità sfondo",
    ["opt_tooltip_border_alpha"]         = "Opacità bordo",
    ["opt_tooltip_bg_color"]              = "Colore sfondo",
    ["opt_tooltip_border_color"]          = "Colore bordo",
    ["opt_tooltip_font_size"]             = "Dimensione font",
    ["opt_tooltip_hide_healthbar"]       = "Nascondi barra vita",
    ["opt_tooltip_class_color"]          = "Nomi giocatore con colore di classe",
    ["opt_tooltip_hide_server"]          = "Nascondi server nei nomi giocatore",
    ["opt_tooltip_hide_title"]           = "Nascondi titolo nei nomi giocatore",
    ["opt_tooltip_guild_color"]          = "Colore personalizzato nome gilda",
    ["opt_tooltip_guild_color_pick"]     = "Colore nome gilda",
    ["sublabel_tooltip_info"]            = "— Informazioni unità —",
    ["opt_tooltip_unit_info"]            = "Mostra informazioni unità",
    ["info_tooltip_unit_info"]           = "Aggiunge grado di gilda, bersaglio, punteggio M+ e altro ai tooltip delle unità.",
    ["opt_tooltip_reaction_border"]      = "Colora bordo per reazione / classe",
    ["opt_tooltip_color_level"]          = "Colora livello per difficoltà",
    ["opt_tooltip_raid_marker"]          = "Mostra icona bersaglio raid",
    ["opt_tooltip_role_icon"]            = "Mostra icona ruolo",
    ["opt_tooltip_class_icon"]           = "Mostra icona classe",
    ["opt_tooltip_icon_size"]            = "Dimensione icone",
    ["opt_tooltip_guild_rank"]           = "Mostra grado di gilda",
    ["opt_tooltip_guild_rank_index"]     = "Mostra numero di grado",
    ["opt_tooltip_guild_realm"]          = "Mostra reame di gilda",
    ["opt_tooltip_show_target"]          = "Mostra bersaglio dell'unità",
    ["opt_tooltip_mythic_score"]         = "Mostra punteggio M+",
    ["opt_tooltip_mount"]                = "Mostra cavalcatura",
    ["opt_tooltip_speed"]                = "Mostra velocità di movimento",
    ["opt_tooltip_location"]             = "Mostra posizione",
    ["info_tooltip_location"]            = "La posizione è disponibile solo per te e i membri del tuo gruppo.",
    ["tt_guild_rank"]                    = "Grado",
    ["tt_target"]                        = "Bersaglio",
    ["tt_target_you"]                    = "Tu",
    ["tt_mythic_score"]                  = "Punteggio M+",
    ["tt_speed"]                         = "Velocità",
    ["tt_mount"]                         = "Cavalcatura",
    ["tt_location"]                      = "Posizione",
    ["sublabel_tooltip_inspect"]         = "— Ispezione —",
    ["opt_tooltip_item_level"]           = "Mostra livello oggetto",
    ["opt_tooltip_spec"]                 = "Mostra specializzazione",
    ["opt_tooltip_spec_icon"]            = "Mostra icona specializzazione",
    ["opt_tooltip_pending_text"]         = "Mostra segnaposto durante il caricamento",
    ["info_tooltip_inspect"]             = "Livello oggetto e specializzazione richiedono di ispezionare il giocatore: appaiono solo a portata.",
    ["tt_item_level"]                    = "Livello oggetto",
    ["tt_spec"]                          = "Specializzazione",
    ["tt_loading"]                       = "...",

    -- =====================
    -- Bag Skin extras
    -- =====================
    ["opt_skin_bags_show_ilvl"]          = "Mostra livello oggetto sull'equipaggiamento",
    ["opt_skin_bags_show_junk_icon"]     = "Mostra icona spazzatura",
    ["opt_skin_bags_layout_mode"]        = "Modalità layout",
    ["opt_skin_bags_layout_combined"]    = "Griglia combinata",
    ["opt_skin_bags_layout_categories"]  = "Categorie",
    ["opt_skin_bags_layout_separate"]    = "Borse separate",
    ["opt_skin_bags_reverse_order"]      = "Inverti ordine borse",
    ["opt_skin_bags_show_bag_bar"]       = "Mostra barra borse",
    ["opt_skin_bags_settings"]           = "Impostazioni borse",
    ["opt_skin_bags_slot_spacing_x"]     = "Spaziatura slot X",
    ["opt_skin_bags_slot_spacing_y"]     = "Spaziatura slot Y",
    ["opt_skin_bags_sort_none"]          = "Manuale",

    -- =====================
    -- TOMOSCORE (Scoreboard)
    -- =====================
    ["ts_cfg_title"]                = "Tabellone",
    ["ts_cfg_enable"]               = "Attiva tabellone dungeon",
    ["ts_cfg_auto_show_mplus"]      = "Mostra automaticamente per Mythic+",
    ["ts_cfg_scale"]                = "Scala",
    ["ts_cfg_alpha"]                = "Opacità sfondo",
    ["ts_cfg_section_display"]      = "Visualizzazione",
    ["ts_cfg_section_frame"]        = "Cornice",
    ["ts_cfg_section_actions"]      = "Azioni",
    ["ts_cfg_preview"]              = "Anteprima",
    ["ts_cfg_last_run"]             = "Mostra ultima partita",
    ["ts_cfg_reset_pos"]            = "Ripristina posizione",
    ["ts_reset_msg"]                = "|cffffd100TomoModForever|r Tabellone: Posizione ripristinata.",
    ["ts_no_data"]                  = "|cffffd100TomoModForever|r Tabellone: Nessun dato dungeon disponibile.",
    ["ts_mythic_zero"]              = "Mitico",
    ["ts_key_level"]                = "+%d",
    ["ts_completed"]                = "COMPLETATO",
    ["ts_depleted"]                 = "ESAURITO",
    ["ts_duration"]                 = "Durata",
    ["ts_col_player"]               = "Giocatore",
    ["ts_col_rating"]               = "M+",
    ["ts_col_key_level"]            = "Chiave",
    ["ts_col_key_name"]             = "Dungeon",
    ["ts_col_damage"]               = "Danni",
    ["ts_col_healing"]              = "Cure",
    ["ts_col_interrupts"]           = "Interruzioni",
    ["ts_footer_total"]             = "Totale",
    ["ts_footer_players"]           = "%d giocatori",

    -- =====================
    -- CASTBARS (modulo autonomo)
    -- =====================
    ["cat_castbars"]                     = "Barre di lancio",

    ["cb_section_general"]               = "Generale",
    ["opt_cb_enable"]                    = "Attiva barre di lancio autonome",
    ["info_cb_description"]              = "Sostituisce le barre di lancio Blizzard con barre completamente personalizzabili per Giocatore, Bersaglio, Focus, Famiglio e Boss.",
    ["btn_cb_toggle_preview"]            = "Show / Hide Preview",
    ["info_cb_preview_hint"]             = "Unlocks every castbar and shows a live mock spell so you can see your tweaks instantly.",
    ["opt_cb_hide_blizzard"]             = "Nascondi barre di lancio Blizzard",
    ["opt_cb_class_color"]               = "Usa colore di classe",
    ["opt_cb_show_transitions"]          = "Animazioni di inizio/fine",
    ["opt_cb_show_channel_ticks"]        = "Mostra segni di canalizzazione",
    ["opt_cb_timer_format"]              = "Formato timer",
    ["cb_timer_remaining"]               = "Rimanente (1.5)",
    ["cb_timer_remaining_total"]         = "Rimanente / Totale (1.5 / 3.0)",
    ["cb_timer_elapsed"]                 = "Trascorso (1.5)",
    ["opt_cb_spell_max_len"]             = "Lunghezza max. nome (0 = illimitato)",

    ["cb_section_appearance"]            = "Aspetto",
    ["opt_cb_bar_texture"]               = "Texture della barra",
    ["cb_tex_blizzard"]                  = "Blizzard",
    ["cb_tex_smooth"]                    = "Liscio",
    ["cb_tex_flat"]                      = "Piatto",
    ["opt_cb_font_size"]                 = "Dimensione carattere",
    ["opt_cb_bg_mode"]                   = "Modalità sfondo",
    ["cb_bg_black"]                      = "Nero",
    ["cb_bg_transparent"]                = "Trasparente",
    ["cb_bg_custom"]                     = "Texture personalizzata",

    ["cb_section_colors"]                = "Colori",
    ["opt_cb_cast_color"]                = "Colore di lancio",
    ["opt_cb_ni_color"]                  = "Non interrompibile",
    ["opt_cb_interrupt_color"]           = "Colore interruzione",

    ["cb_section_spark"]                 = "Scintilla",
    ["opt_cb_show_spark"]                = "Mostra animazione scintilla",
    ["opt_cb_spark_style"]               = "Stile scintilla",
    ["opt_cb_spark_color"]               = "Colore scintilla",
    ["opt_cb_spark_glow_color"]          = "Colore bagliore",
    ["opt_cb_spark_tail_color"]          = "Colore scia",
    ["opt_cb_spark_glow_alpha"]          = "Opacità bagliore",
    ["opt_cb_spark_tail_alpha"]          = "Opacità scia",

    ["cb_section_gcd"]                   = "Scintilla GCD",
    ["opt_cb_show_gcd"]                  = "Mostra barra GCD sotto la barra del giocatore",
    ["opt_cb_gcd_height"]                = "Altezza barra GCD",
    ["opt_cb_gcd_color"]                 = "Colore GCD",

    ["cb_section_interrupt"]             = "Feedback interruzione",
    ["opt_cb_show_interrupt_feedback"]   = "Mostra testo di interruzione",
    ["opt_cb_interrupt_fb_color"]        = "Colore del testo",
    ["opt_cb_interrupt_fb_size"]         = "Dimensione carattere",
    ["cb_interrupt_feedback_text"]       = "INTERROTTO!",
    ["cb_interrupt_feedback_full"]       = "INTERROTTO: %s",
    ["cb_interrupted"]                   = "Interrotto",

    ["cb_tab_general"]                   = "Generale",
    ["cb_tab_player"]                    = "Giocatore",
    ["cb_tab_target"]                    = "Bersaglio",
    ["cb_tab_focus"]                     = "Focus",
    ["cb_tab_pet"]                       = "Famiglio",
    ["cb_tab_boss"]                      = "Boss",

    ["cb_section_unit"]                  = "Barra di %s",
    ["opt_cb_unit_enable"]               = "Attiva",
    ["opt_cb_unit_width"]                = "Larghezza",
    ["opt_cb_unit_height"]               = "Altezza",
    ["opt_cb_unit_show_icon"]            = "Mostra icona",
    ["opt_cb_unit_icon_side"]            = "Lato icona",
    ["cb_icon_left"]                     = "Sinistra",
    ["cb_icon_right"]                    = "Destra",
    ["opt_cb_unit_show_timer"]           = "Mostra timer",
    ["opt_cb_unit_show_latency"]         = "Mostra latenza",
    ["info_cb_latency"]                  = "Mostra un overlay scuro con la latenza di rete alla fine della barra.",
    ["info_cb_position"]                 = "Usa /tm layout per sbloccare e trascinare questa barra.",
    ["btn_cb_reset_position"]            = "Reimposta posizione",
    ["cb_move_label"]                    = "(Trascina per spostare)",
    ["cb_player_missing_notice"]         = "La barra di lancio del giocatore non è attivata — attivala nelle impostazioni Barre di lancio prima di poterla spostare.",
    ["cb_preview_castbar"]               = "Anteprima: %s",

    ["mover_castbar_standalone"]         = "Barre di lancio",

    -- ═══════════════════════════════════
    -- Riquadri di gruppo (Party Frames)
    -- ═══════════════════════════════════
    ["cat_partyframes"]                  = "Riquadri di gruppo",
    ["mover_partyframes"]                = "Riquadri di gruppo",

    ["pf_tab_general"]                   = "Generale",
    ["pf_tab_features"]                  = "Funzionalità",
    ["pf_tab_cooldowns"]                 = "Tempo di ricarica",
    ["pf_tab_arena"]                     = "Arena",

    ["pf_section_general"]               = "Generale",
    ["pf_opt_enable"]                    = "Attiva riquadri di gruppo",
    ["pf_info_description"]              = "Riquadri di gruppo personalizzati per M+ e Arena con salute, assorbimento, previsione cure, HoT, CD interruzioni/rez da combattimento e evidenziazione dissolvi.",
    ["pf_opt_hide_blizzard"]             = "Nascondi riquadri di gruppo Blizzard",
    ["pf_opt_sort_role"]                 = "Ordina per ruolo (Tank > Guaritore > DPS)",

    ["pf_section_dimensions"]            = "Dimensioni",
    ["pf_opt_width"]                     = "Larghezza riquadro",
    ["pf_opt_height"]                    = "Altezza riquadro",
    ["pf_opt_spacing"]                   = "Spaziatura",
    ["pf_opt_grow_direction"]            = "Direzione di crescita",
    ["pf_dir_down"]                      = "Giù",
    ["pf_dir_up"]                        = "Su",
    ["pf_dir_right"]                     = "Destra",
    ["pf_dir_left"]                      = "Sinistra",

    ["pf_section_display"]               = "Visualizzazione",
    ["pf_opt_show_name"]                 = "Mostra nome",
    ["pf_opt_show_health_text"]          = "Mostra testo salute",
    ["pf_opt_health_format"]             = "Formato salute",
    ["pf_fmt_deficit"]                   = "Deficit",
    ["pf_opt_health_color"]              = "Modalità colore salute",
    ["pf_color_green"]                   = "Verde",
    ["pf_color_gradient"]                = "Gradiente",
    ["pf_opt_show_power"]                = "Mostra barra potere",
    ["pf_opt_power_height"]              = "Altezza barra potere",
    ["pf_opt_show_role"]                 = "Mostra icona ruolo",
    ["pf_opt_role_size"]                 = "Dimensione icona ruolo",
    ["pf_opt_show_leader"]               = "Mostra icona del capo",
    ["pf_opt_leader_size"]               = "Dimensione icona del capo",
    ["pf_opt_show_marker"]               = "Mostra marcatore raid",
    ["pf_opt_readycheck_size"]            = "Dimensione icona controllo prontezza",
    ["pf_opt_summon_size"]               = "Dimensione indicatore evocazione",

    ["pf_section_font"]                  = "Carattere",
    ["pf_opt_font_size"]                 = "Dimensione carattere",

    ["pf_section_position"]              = "Posizione",
    ["pf_info_position"]                 = "Usa /tm layout per sbloccare e trascinare i riquadri di gruppo.",
    ["pf_btn_reset_position"]            = "Reimposta posizione",

    ["pf_section_health_extras"]         = "Extra salute",
    ["pf_opt_show_absorb"]               = "Mostra barra assorbimento",
    ["pf_opt_absorb_color"]              = "Colore assorbimento",
    ["pf_opt_show_heal_pred"]            = "Mostra previsione cure",

    ["pf_section_range"]                 = "Controllo raggio",
    ["pf_opt_show_range"]                = "Attenua membri fuori raggio",
    ["pf_opt_oor_alpha"]                 = "Opacità fuori raggio",

    ["pf_section_dispel"]                = "Avviso tipo di effetto negativo",
    ["pf_opt_show_dispel"]               = "Attiva l'avviso sugli effetti negativi",
    ["pf_opt_show_dispel_border"]        = "Colora tutto il riquadro in base all'effetto",
    ["pf_opt_show_dispel_icon"]          = "Mostra l'icona dell'effetto prioritario",
    ["pf_opt_show_dispel_bleed"]         = "Includi i sanguinamenti",
    ["pf_opt_dispel_size"]               = "Dimensione dell'icona dell'effetto",
    ["pf_opt_dispel_border_size"]        = "Spessore del bordo di avviso",
    ["pf_info_dispel"]                   = "Usa il motore delle aure di Midnight 12.1 per mostrare Magia (blu), Maledizione (viola), Malattia (arancione), Veleno (verde) e Sanguinamento (rosso) senza leggere dati d'aura protetti in combattimento. L'icona è l'effetto reale e il bordo non altera mai il riempimento della barra della salute.",

    ["pf_section_hots"]                  = "Tracciamento HoT",
    ["pf_opt_show_hots"]                 = "Mostra indicatori HoT",
    ["pf_opt_hot_size"]                  = "Dimensione icona HoT",
    ["pf_opt_max_hots"]                  = "Max. HoT mostrati",
    ["pf_opt_hot_duration"]              = "Mostra i secondi rimanenti sugli HoT",
    ["pf_info_hots"]                     = "Mostra effetti di cura nel tempo con bordi colorati per classe. Supporta Sacerdote, Druido, Paladino, Sciamano, Monaco ed Evocatore.",
    ["pf_section_defensives"]            = "Recuperi difensivi",
    ["pf_opt_show_defensives"]           = "Mostra i recuperi difensivi",
    ["pf_opt_defensive_size"]            = "Dimensione icone difensive",
    ["pf_opt_max_defensives"]            = "Max. difensivi mostrati",
    ["pf_opt_def_externals"]             = "Recuperi esterni (lanciati su questo giocatore)",
    ["pf_opt_def_raidwide"]              = "Recuperi di incursione",
    ["pf_opt_def_personals"]             = "Recuperi personali",
    ["pf_info_defensives"]               = "Il colore del bordo indica la categoria: oro per gli esterni (Scorza di Ferro, Bozzolo Vitale, Soppressione del Dolore), ciano per quelli di incursione, rosso per i personali. Quelli di incursione e personali sono disattivati di default perché si accendono su tutti i riquadri insieme.",

    ["pf_section_cooldowns"]             = "Tracciamento ricarica",
    ["pf_opt_show_kick"]                 = "Mostra CD interruzione",
    ["pf_opt_show_brez"]                 = "Mostra CD rez da combattimento",
    ["pf_opt_cd_size"]                   = "Dimensione icona CD",
    ["pf_opt_cd_layout"]                 = "Layout icone CD",
    ["pf_cd_vertical"]                   = "Verticale (sul riquadro)",
    ["pf_cd_horizontal"]                 = "Orizzontale (sotto)",
    ["pf_info_cooldowns"]                = "Le interruzioni vengono rilevate tramite UNIT_SPELLCAST_SUCCEEDED. Il rez da combattimento legge il pool di cariche condiviso, quindi l'icona diventa grigia per tutti quando un rez viene usato nell'istanza.",

    -- Indicatore resurrezione (gruppo)
    ["pf_section_resurrect"]             = "Indicatore resurrezione",
    ["pf_opt_show_resurrect"]            = "Mostra icona resurrezione in arrivo",
    ["pf_opt_resurrect_size"]            = "Dimensione icona resurrezione",
    ["pf_info_resurrect"]                = "Mostra un'icona rez su un membro mentre una resurrezione viene lanciata su di lui.",

    ["pf_section_arena"]                 = "Riquadri nemici arena",
    ["pf_opt_arena_enable"]              = "Attiva riquadri arena",
    ["pf_info_arena"]                    = "Mostra salute, potere e CD bijou PvP del team nemico in Arena (2v2/3v3).",
    ["pf_section_arena_dims"]            = "Dimensioni arena",
    ["pf_opt_arena_width"]               = "Larghezza",
    ["pf_opt_arena_height"]              = "Altezza",
    ["pf_opt_arena_spacing"]             = "Spaziatura",
    ["pf_section_arena_trinket"]         = "Bijou PvP",
    ["pf_opt_show_trinket"]              = "Mostra CD bijou",
    ["pf_opt_trinket_size"]              = "Dimensione icona bijou",
    ["pf_opt_show_spec"]                 = "Mostra icona specializzazione",
    ["pf_section_arena_pos"]             = "Posizione arena",
    ["pf_info_arena_pos"]                = "Usa /tm layout per sbloccare e trascinare i riquadri arena.",
    ["pf_btn_reset_arena_pos"]           = "Reimposta posizione",

    -- ═══════════════════════════════════
    -- Raid Frames
    -- ═══════════════════════════════════
    ["cat_raidframes"]                   = "Riquadri incursione",
    ["mover_raidframes"]                 = "Riquadri incursione",
    ["rf_tab_general"]                   = "Generale",
    ["rf_tab_features"]                  = "Funzionalità",
    ["rf_section_general"]               = "Generale",
    ["rf_opt_enable"]                    = "Attiva riquadri incursione",
    ["rf_info_description"]              = "Riquadri incursione personalizzati con salute, assorbimento, previsione cure, HoT, debuff, evidenziazione dissolvi, CD difensivi e controllo distanza.",
    ["rf_opt_hide_blizzard"]             = "Nascondi riquadri incursione di Blizzard",
    ["rf_opt_skin_group_manager"]       = "Personalizza il pannello del capogruppo (ready check, indicatori, abbandona gruppo)",
    ["rf_opt_sort_role"]                 = "Ordina per ruolo (Tank > Guaritore > DPS)",
    ["rf_section_layout"]                = "Layout",
    ["rf_opt_layout_mode"]               = "Modalità layout",
    ["rf_layout_grid"]                   = "Griglia (gruppi in colonne)",
    ["rf_layout_list"]                   = "Lista (colonna singola)",
    ["rf_opt_width"]                     = "Larghezza riquadro",
    ["rf_opt_height"]                    = "Altezza riquadro",
    ["rf_opt_spacing"]                   = "Spaziatura",
    ["rf_opt_group_spacing"]             = "Spaziatura gruppo",
    ["rf_section_display"]               = "Visualizzazione",
    ["rf_opt_show_name"]                 = "Mostra nome",
    ["rf_opt_name_max_length"]           = "Lettere max del nome",
    ["rf_opt_show_health_text"]          = "Mostra testo salute",
    ["rf_opt_health_format"]             = "Formato salute",
    ["rf_opt_health_color"]              = "Modalità colore salute",
    ["rf_opt_show_role"]                 = "Mostra icona ruolo",
    ["rf_opt_show_marker"]               = "Mostra marcatore incursione",
    ["rf_opt_readycheck_size"]            = "Dimensione icona controllo prontezza",
    ["rf_opt_summon_size"]               = "Dimensione indicatore evocazione",
    ["rf_section_font"]                  = "Carattere",
    ["rf_opt_font_size"]                 = "Dimensione carattere",
    ["rf_section_position"]              = "Posizione",
    ["rf_info_position"]                 = "Usa /tm layout per sbloccare e trascinare i riquadri incursione.",
    ["rf_btn_reset_position"]            = "Reimposta posizione",
    ["rf_info_test_raid"]                = "Simula un'incursione di 20 giocatori per visualizzare l'anteprima del layout fuori combattimento.",
    ["rf_btn_test_raid"]                 = "Simula 20 giocatori",
    ["rf_btn_test_raid_stop"]            = "Interrompi simulazione",
    ["rf_preview_group"]                 = "G",
    ["rf_mode_raid"]                     = "Raid",
    ["rf_mode_solo"]                     = "Solo",
    ["rf_section_health_extras"]         = "Funzioni salute",
    ["rf_opt_show_power"]                = "Barra potere (solo guaritori)",
    ["rf_opt_power_height"]              = "Altezza barra potere",
    ["rf_opt_show_absorb"]               = "Mostra barra assorbimento",
    ["rf_opt_show_heal_pred"]            = "Mostra previsione cure",
    ["rf_section_range"]                 = "Controllo distanza",
    ["rf_opt_show_range"]                = "Sfuma membri fuori portata",
    ["rf_opt_oor_alpha"]                 = "Opacità fuori portata",
    ["rf_section_dispel"]                = "Avviso tipo di effetto negativo",
    ["rf_opt_show_dispel"]               = "Attiva l'avviso sugli effetti negativi",
    ["rf_opt_show_dispel_border"]        = "Colora tutto il riquadro in base all'effetto",
    ["rf_opt_show_dispel_icon"]          = "Mostra l'icona dell'effetto prioritario",
    ["rf_opt_show_dispel_bleed"]         = "Includi i sanguinamenti",
    ["rf_opt_dispel_size"]               = "Dimensione dell'icona dell'effetto",
    ["rf_opt_dispel_border_size"]        = "Spessore del bordo di avviso",
    ["rf_info_dispel"]                   = "Magia = blu, Maledizione = viola, Malattia = arancione, Veleno = verde, Sanguinamento = rosso. Usa gli AuraSlot del motore, così l'avviso resta sicuro in combattimento anche quando i dati d'aura sono protetti.",
    ["rf_section_hots"]                  = "Tracciamento HoT",
    ["rf_opt_show_hots"]                 = "Mostra indicatori HoT",
    ["rf_opt_hot_size"]                  = "Dimensione icona HoT",
    ["rf_opt_max_hots"]                  = "Max HoT mostrati",
    ["rf_opt_hot_duration"]              = "Mostra i secondi rimanenti sugli HoT",
    ["rf_section_debuffs"]               = "Tracciamento debuff",
    ["rf_opt_show_debuffs"]              = "Mostra icone debuff",
    ["rf_opt_debuff_size"]               = "Dimensione icona debuff",
    ["rf_opt_max_debuffs"]               = "Max debuff mostrati",
    ["rf_section_defensives"]            = "CD difensivi",
    ["rf_opt_show_defensives"]           = "Mostra buff difensivi attivi",
    ["rf_opt_defensive_size"]            = "Dimensione icona difensiva",
    ["rf_opt_max_defensives"]            = "Max. difensivi mostrati",
    ["rf_opt_def_externals"]             = "Recuperi esterni (lanciati su questo giocatore)",
    ["rf_opt_def_raidwide"]              = "Recuperi di incursione",
    ["rf_opt_def_personals"]             = "Recuperi personali",
    ["rf_info_defensives"]               = "Mostra i CD difensivi attivi (es: Soppressione del Dolore, Corteccia di Ferro, Scudo Divino) su ogni membro dell'incursione.",

    -- Indicatore resurrezione (incursione)
    ["rf_section_resurrect"]             = "Indicatore resurrezione",
    ["rf_opt_show_resurrect"]            = "Mostra icona resurrezione in arrivo",
    ["rf_opt_resurrect_size"]            = "Dimensione icona resurrezione",
    ["rf_info_resurrect"]                = "Mostra un'icona rez su un membro mentre una resurrezione viene lanciata su di lui (rez da combattimento o normale).",

    -- Contatore rez da combattimento
    ["rf_section_battlerez"]             = "Contatore rez da combattimento",
    ["rf_opt_br_enable"]                 = "Mostra contatore rez da combattimento",
    ["rf_opt_br_only_instance"]          = "Solo in dungeon/raid",
    ["rf_opt_br_size"]                   = "Dimensione contatore",
    ["rf_opt_br_font"]                   = "Dimensione font contatore",
    ["rf_info_battlerez"]                = "Un contatore spostabile che mostra quante rez da combattimento sono disponibili e il tempo alla prossima carica. Legge il pool condiviso, funziona su qualsiasi classe. Spostalo con /tm layout.",

    -- Layout per dimensione
    ["rf_section_size_overrides"]        = "Layout per dimensione (10/25/40)",
    ["rf_opt_overrides_enable"]          = "Attiva layout per dimensione",
    ["rf_info_size_overrides"]           = "Quando attivo, la dimensione del riquadro si adatta automaticamente alla dimensione del gruppo (la spaziatura si regola per fascia).",
    ["rf_ov_small"]                      = "Piccolo  (fino a 10)",
    ["rf_ov_medium"]                     = "Medio  (fino a 25)",
    ["rf_ov_large"]                      = "Grande  (26-40)",
    ["rf_ov_width"]                      = "Larghezza",
    ["rf_ov_height"]                     = "Altezza",

    -- ═══════════════════════════════════
    -- Aura Tracker
    -- ═══════════════════════════════════
    ["mover_battlerez"]                  = "Rez combattimento",
    ["mover_preytracker"]                = "Tracciatore di Preda",
    ["mover_extrabuttons"]               = "Pulsante Extra",

    ["at_section_general"]               = "Generale",
    ["at_opt_enable"]                    = "Attiva tracciatore aure",
    ["at_info_description"]              = "Traccia buff importanti: proc bijou, proc incantamento arma, buff personali e difensivi in un overlay di icone.",

    ["at_section_appearance"]            = "Aspetto",
    ["at_opt_icon_size"]                 = "Dimensione icona",
    ["at_opt_spacing"]                   = "Spaziatura",
    ["at_opt_max_icons"]                 = "Max. icone",
    ["at_opt_grow_direction"]            = "Direzione di crescita",
    ["at_opt_font_size"]                 = "Dimensione carattere",

    ["at_section_display"]               = "Visualizzazione",
    ["at_opt_show_timer"]                = "Mostra timer",
    ["at_opt_show_stacks"]               = "Mostra cumuli",
    ["at_opt_show_glow"]                 = "Bagliore su nuovo proc",
    ["at_opt_timer_threshold"]           = "Soglia lampeggio (sec)",

    ["at_section_categories"]            = "Categorie",
    ["at_info_categories"]               = "Scegli quali categorie di aure tracciare.",
    ["at_cat_trinkets"]                  = "Proc bijou",
    ["at_cat_enchants"]                  = "Proc incantamento arma",
    ["at_cat_selfbuffs"]                 = "Buff personali (CD)",
    ["at_cat_raidbuffs"]                 = "Buff raid",
    ["at_cat_defensives"]                = "Difensivi (esterni + personali)",

    ["at_section_position"]              = "Posizione",
    ["at_info_position"]                 = "Usa /tm layout per sbloccare e trascinare il tracciatore.",
    ["at_btn_reset_position"]            = "Reimposta posizione",

    -- ═══════════════════════════════════
    -- Battle Text
    -- ═══════════════════════════════════
    ["cat_battletext"]                   = "Testo di combattimento",
    ["mover_battletext"]                 = "Testo di combattimento",

    ["bt_section_general"]               = "Generale",
    ["bt_info_description"]              = "Testo di combattimento scorrevole: danni e cure, in entrata e in uscita.",
    ["bt_opt_enable"]                    = "Attiva testo di combattimento",

    ["bt_section_display"]               = "Visualizzazione",
    ["bt_opt_outgoing"]                  = "Mostra danni in uscita",
    ["bt_opt_incoming"]                  = "Mostra danni in entrata",
    ["bt_opt_overheal"]                  = "Mostra sovra-cura",
    ["bt_opt_throttle"]                  = "Unisci tick DoT/HoT",

    ["bt_section_appearance"]            = "Aspetto",
    ["bt_opt_font_size"]                 = "Dimensione carattere",
    ["bt_opt_throttle_window"]           = "Finestra di unione (sec)",

    ["bt_section_position"]              = "Posizione",
    ["bt_info_position"]                 = "Usa /tm layout per sbloccare e trascinare le zone.",
    ["bt_btn_reset_position"]            = "Reimposta posizioni",

    ["bt_zone_outgoing"]                 = "In uscita",
    ["bt_zone_incoming"]                 = "In entrata",
    ["bt_zone_heal_out"]                 = "Cure in uscita",
    ["bt_zone_heal_in"]                  = "Cure ricevute",

    ["bt_cmd_help"]                      = "/tm bt <cmd>",
    ["bt_enabled"]                       = "attivato",
    ["bt_disabled"]                      = "disattivato",
    ["bt_crit"]                          = "!",
    ["bt_zones_locked"]                  = "zone bloccate",
    ["bt_zones_unlocked"]                = "zone sbloccate",
    ["bt_reset_done"]                    = "posizioni reimpostate.",
    ["bt_miss_miss"]                     = "Mancato",
    ["bt_miss_dodge"]                    = "Schivato",
    ["bt_miss_parry"]                    = "Parato",
    ["bt_miss_block"]                    = "Bloccato",
    ["bt_miss_resist"]                   = "Resistito",
    ["bt_miss_absorb"]                   = "Assorbito",
    ["bt_miss_immune"]                   = "Immune",
    ["bt_miss_evade"]                    = "Evasione",
    ["bt_miss_deflect"]                  = "Deviato",
    ["bt_miss_reflect"]                  = "Riflesso",

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
    ["section_diagnostics"]              = "Diagnostica",
    ["opt_diag_enabled"]                 = "Abilita cattura errori",
    ["opt_diag_capture_all"]             = "Cattura tutti gli addon",
    ["opt_diag_suppress_popups"]         = "Sopprimi finestre di errore",
    ["opt_diag_auto_open"]               = "Apri automaticamente con errore TomoMod",
    ["btn_diag_open_console"]            = "Apri console",
    ["btn_diag_clear"]                   = "Cancella errori",
    ["btn_diag_export"]                  = "Copia report",
    ["btn_diag_export_tracker"]          = "Esporta per Tracker",
    ["info_diag_desc"]                   = "Cattura errori Lua in background senza popup durante il combattimento. /tmdiag per aprire la console.",
    ["info_diag_session"]                = "Sessione: #%d \226\128\148 %d errori catturati (%d TomoMod)",
    ["info_diag_capture_all_desc"]       = "Quando disabilitato, vengono catturati solo gli errori di TomoMod. Attiva per catturare tutti gli errori degli addon.",

    -- =====================
    -- HOUSING
    -- =====================
    ["section_housing_general"]      = "Housing \226\128\148 Generale",
    ["section_housing_hover"]        = "Info decorazione (hover)",
    ["section_housing_clock"]        = "Orologio editor",
    ["section_housing_teleport"]     = "Teletrasporto",
    ["section_housing_commands"]     = "Comandi",

    ["info_housing_desc"]            = "Modulo Housing: migliora l'editor di case e aggiunge scorciatoie di teletrasporto. Richiede Midnight / The War Within.",
    ["info_housing_hover"]           = "In modalit\195\160 'Decorazione base', mostra nome, costo di posizionamento e stock rimanente. Consente anche di duplicare con tasto modificatore.",
    ["info_housing_clock"]           = "Mostra un orologio e registra il tempo nell'editor di case. Clic destro per passare tra analogico e digitale.",
    ["info_housing_teleport"]        = "Attiva /tm home: ti teletrasporta a casa tua o esci automaticamente se sei in visita.",
    ["info_housing_commands"]        = "\226\128\162 /tm home \226\128\148 teletrasportati a casa (o esci)\n\226\128\162 /tm housing \226\128\148 apri questo pannello\n\226\128\162 Clic destro sull'orologio \226\128\148 cambia analogico/digitale",

    ["opt_housing_enable"]           = "Abilita modulo Housing",
    ["opt_housing_decorhover"]       = "Abilita info decorazione",
    ["opt_housing_dupe"]             = "Abilita duplicazione rapida (modificatore)",
    ["opt_housing_dupekey"]          = "Tasto di duplicazione",
    ["opt_housing_clock"]            = "Abilita orologio",
    ["opt_housing_clock_analog"]     = "Modalit\195\160 analogica (altrimenti digitale)",
    ["opt_housing_teleport"]         = "Abilita teletrasporto /tm home",

    ["btn_housing_tp_home"]          = "Teletrasportati (test)",
    ["btn_housing_refresh"]          = "Aggiorna case",

    ["housing_duplicate"]            = "Duplica",
    ["housing_alliance_zone"]        = "Promontorio del Fondatore",
    ["housing_horde_zone"]           = "Coste di Vento Lama",
    ["housing_clock_title"]          = "TomoMod \226\128\148 Orologio",
    ["housing_clock_time"]           = "Ora",
    ["housing_clock_local"]          = "Ora locale:",
    ["housing_clock_realm"]          = "Ora del reame:",
    ["housing_clock_time_spent"]     = "Tempo nell'editor",
    ["housing_clock_session"]        = "Questa sessione:",
    ["housing_clock_total"]          = "Totale:",
    ["housing_clock_rightclick"]     = "Clic destro per passare analogico / digitale",

    ["msg_help_home"]                = "Teletrasportati a casa tua (o esci)",
    ["msg_help_housing"]             = "Apri il pannello Housing",
    ["msg_housing_refresh"]          = "Informazioni sulle case richieste.",
    ["msg_housing_unavailable"]      = "Modulo Housing non disponibile su questo client.",

    -- ═══════════════════════════════════
    -- Merchant Tools (2.9.9)
    -- ═══════════════════════════════════

    ["tab_qol_merchant_tools"]           = "Strumenti venditore",

    ["section_already_known"]            = "Già noto",
    ["info_already_known"]               = "Desatura o colora gli articoli del venditore/riacquisto già posseduti (cavalcature, pet, giocattoli, set transmog, ricette).",
    ["opt_ak_enable"]                    = "Abilita Già noto",
    ["opt_ak_mode"]                      = "Modalità di visualizzazione",
    ["ak_mode_mono"]                     = "Monocromatico (grigio)",
    ["ak_mode_color"]                    = "Tinta colorata",
    ["opt_ak_color"]                     = "Colore tinta",

    ["section_extend_pages"]             = "Pagine venditore estese",
    ["info_extend_pages"]                = "Aggiunge colonne extra alla finestra del venditore.\nRichiede il ricaricamento dell'interfaccia dopo l'attivazione o la modifica del numero di colonne.",
    ["opt_ep_enable"]                    = "Abilita pagine estese",
    ["opt_ep_columns"]                   = "Numero di colonne",

    ["preset_complet_name"]  = "Consigliato",
    ["preset_complet_tag"]   = "L'esperienza TomoMod completa",
    ["preset_complet_desc"]  = "Attiva tutti i moduli principali con impostazioni sensate: UnitFrames, riquadri gruppo e incursione, Nameplates, barre di lancio, risorse, skin delle barre delle azioni, tutti gli skin visivi, strumenti Mythic+ e le funzioni di comodità più utili. Il miglior punto di partenza per la maggior parte dei giocatori.",
    ["preset_tank_name"]     = "Tank",
    ["preset_tank_tag"]      = "Focus sulla minaccia, Nameplates più larghe",
    ["preset_tank_desc"]     = "La configurazione Consigliata, ottimizzata per il tanking: Nameplates colorate in base alla minaccia (Modalità Tank) e un po' più larghe per leggere meglio l'aggro, oltre all'indicatore di minaccia sul bersaglio.",
    ["preset_healer_name"]   = "Curatore",
    ["preset_healer_tag"]    = "Riquadri incursione più grandi, mana visibile",
    ["preset_healer_desc"]   = "La configurazione Consigliata, ottimizzata per la cura: riquadri incursione e gruppo più grandi e facili da cliccare, con barre delle risorse (mana) mostrate, monitoraggio degli HoT, evidenziazione delle dissoluzioni e difensivi in primo piano.",
    ["preset_dps_name"]      = "DPS",
    ["preset_dps_tag"]       = "Risorse e cooldown in evidenza",
    ["preset_dps_desc"]      = "La configurazione Consigliata, ottimizzata per il danno: una barra delle risorse più evidente, monitoraggio dei buff sul bersaglio per i difensivi nemici e Nameplates pulite senza colorazione della minaccia da tank.",
    ["preset_minimal_name"]  = "Minimale",
    ["preset_minimal_tag"]   = "Solo l'essenziale",
    ["preset_minimal_desc"]  = "Un ingombro leggero: mantiene UnitFrames, riquadri gruppo e incursione, barre di lancio, barre delle risorse, la minimappa e le automazioni essenziali — tutto il cosmetico (skin, chat, borse, Nameplates, pannelli extra) resta disattivato. Il più vicino a una sensazione vanilla.",
    ["preset_custom_name"]   = "Personalizzato",
    ["preset_custom_tag"]    = "Configura tutto da te",
    ["preset_custom_desc"]   = "Salta i preset e scorri ogni categoria passo dopo passo per attivare esattamente ciò che vuoi. Puoi sempre cambiare tutto in seguito da /tm.",
    ["preset_applied"]       = "Preset applicato: %s — digita /reload per vedere il risultato.",
    ["preset_unknown"]       = "Preset sconosciuto « %s ». Disponibili: complet, tank, healer, dps, minimal.",
    ["preset_usage"]         = "Uso: /tmpreset <complet|tank|healer|dps|minimal>",
    ["ins_v3_welcome_desc"]      = "Benvenuto! Questo assistente rapido ti prepara un'interfaccia pulita e completa in pochi secondi.\n\nScegli una configurazione adatta al tuo modo di giocare — potrai regolare tutto in seguito da |cffffd100/tm|r. Preferisci scegliere ogni opzione da solo? Scegli |cffc89530Personalizzato|r.",
    ["ins_pick_title"]           = "Scegli la tua configurazione",
    ["ins_pick_subtitle"]        = "Seleziona uno stile di gioco qui sotto. Tutto resta regolabile in seguito tramite /tm.",
    ["ins_pick_recommended"]     = "Consigliato",
    ["ins_custom_frames_title"]  = "Riquadri",
    ["ins_custom_barsskins_title"] = "Barre e Skin",
    ["ins_custom_mythicqol_title"] = "Mythic+ e Comfort",
    ["ins_custom_frames_intro"]  = "Attiva i riquadri che vuoi. Le opzioni sensate sono preselezionate.",
    ["ins_custom_barsskins_intro"] = "Skin delle barre delle azioni e skin visivi per chat, borse, tooltip e altro.",
    ["ins_custom_mythicqol_intro"] = "Strumenti Mythic+, extra dell'interfaccia, automazioni e suono.",
    ["ins_recap_title"]          = "Tutto pronto",
    ["ins_recap_preset"]         = "Configurazione applicata: |cffffd100%s|r",
    ["ins_recap_custom"]         = "La tua configurazione personalizzata è pronta",
    ["ins_recap_desc"]           = "Ricarica l'interfaccia per applicare tutto. Puoi riaprire questo assistente in qualsiasi momento con |cffffd100/tm install|r e aprire il pannello di configurazione completo con |cffffd100/tm|r.",
    ["cat_accueil"]              = "Home",
    ["ui_search_placeholder"]    = "Cerca impostazione...",
    ["dash_welcome"]             = "Panoramica rapida di TomoMod. Attiva moduli, applica una configurazione, cambia profilo o rilancia l'assistente.",
    ["dash_modules_section"]     = "Moduli",
    ["dash_quickcfg_section"]    = "Configurazione rapida",
    ["dash_studio_section"]           = "Cooldown Studio",
    ["dash_studio_info"]              = "Editor a schermo intero delle barre di ricarica: disposizione, stile, incantesimi e visibilit\195\160.",
    ["dash_studio_open"]              = "Apri il Cooldown Studio",
    ["dash_profile_section"]     = "Profilo",
    ["dash_maint_section"]       = "Manutenzione",
    ["dash_reload_hint"]         = "Le modifiche ai moduli vengono applicate in tempo reale. Le modifiche protette vengono applicate automaticamente dopo il combattimento.",
    ["dash_reload_now"]          = "Ricarica ora",
    ["dash_apply_preset"]        = "Preset di configurazione",
    ["dash_apply_preset_btn"]    = "Applica questo preset",
    ["dash_apply_preset_info"]   = "Applicare un preset reimposta quali moduli sono attivi o meno, poi ricarica.",
    ["dash_active_profile"]      = "Profilo attivo",
    ["dash_manage_profiles"]     = "Gestisci profili",
    ["dash_profile_info"]        = "Cambiare profilo ricarica l'interfaccia per applicarlo.",
    ["dash_relaunch_info"]       = "Riapre l'assistente di configurazione « preset prima ».",
    ["dash_mod_resources"]       = "Risorse",
    ["dash_mod_cdm"]             = "Cooldown Manager",
    ["dash_mod_abskin"]          = "Skin barre delle azioni",
    ["dash_mod_chatskin"]        = "Skin della chat",
    ["dash_mod_bagskin"]         = "Skin delle borse",
    ["dash_mod_mtracker"]        = "Tracker Mythic+",
    ["dash_mod_score"]           = "Punteggio Mythic+",
    ["dash_reload_popup"]        = "Ricaricare l'interfaccia ora per applicare le tue modifiche?",

    -- ═══════════════════════════════════
    -- MythicTracker Nomi EJ (2.9.10)
    -- ═══════════════════════════════════
    -- ═══════════════════════════════════
    -- Correzione CD PartyFrame + Prestazioni (2.9.12)
    -- ═══════════════════════════════════
    -- ═══════════════════════════════════
    -- Installer Overhaul & AB Toggle (2.9.17)
    -- ═══════════════════════════════════
    -- Objective Tracker Quest Buckets (2.9.18)
    -- ═══════════════════════════════════
    -- Smart Waypoint (2.9.20)
    -- ═══════════════════════════════════
    -- Objective Tracker Stability (2.9.19)
    -- ═══════════════════════════════════


    -- AuctionRecipeTracker (2.9.15)
    -- ═══════════════════════════════════

    -- ═══════════════════════════════════
    -- MythicTracker Boss Names Fix (2.9.13)
    -- ═══════════════════════════════════


    -- ═══════════════════════════════════
    -- Correzioni CooldownManager / ProcGlow / BuffSkin (2.9.11)
    -- ═══════════════════════════════════

    -- ═══════════════════════════════════
    -- MythicTracker Nomi EJ (2.9.10)
    -- ═══════════════════════════════════

    -- Player Auras Mover (v2.9.5)
    ["mover_player_auras"]       = "Aure del giocatore",
    ["opt_auras_spacing"]        = "Spaziatura tra icone",
    ["btn_reset_aura_position"]  = "Reimposta posizione aure",

    -- Module Reload Safety (v2.9.21)
    ["msg_module_reload"]        = "Questa modifica richiede un ricaricamento dell'interfaccia.\nRicaricare ora?",
    ["info_module_reload"]       = "Richiede /reload per avere effetto.",

    -- Waypoint Arrow Reversed (v2.9.22)

    -- 3.0.3
    -- 3.0.4

    -- 3.0.3

    -- 3.0.0

    -- 3.0.5

    -- =====================
    -- Extra Action Button (v3.0.6)
    -- =====================
    ["mover_ab_extra"] = "Azione extra",
    ["mover_ab_pet"] = "Barra del famiglio",
    ["mover_ab_stance"] = "Barra delle posture",
    ["section_extra_button"] = "Pulsante azione extra",
    ["opt_extra_enabled"] = "Gestisci il pulsante azione extra (ricarica per rilasciare)",
    ["opt_extra_scale"] = "Scala del pulsante extra",
    ["btn_extra_reset_pos"] = "Reimposta posizione",
    ["info_extra_button"] = "Posiziona il pulsante azione extra in modalità Layout. Appare durante missioni e scontri. Disattivandolo viene restituito a Blizzard dopo un /reload.",
    -- 3.0.7

    -- 3.1.1
    ["art_searching"]        = "Ricerca: %s",
    ["art_searching_qty"]    = "Ricerca: %s × %d",

    -- 3.1.2

    -- 3.1.3

    -- Ancoraggio tooltip
    ["opt_tooltip_anchor"]        = "Posizione del tooltip",
    ["tooltip_anchor_default"]    = "Predefinito",
    ["tooltip_anchor_cursor"]     = "Cursore",
    ["tooltip_anchor_corner"]     = "Angolo dello schermo",
    ["tooltip_anchor_custom"]     = "Personalizzato",
    ["opt_tooltip_anchor_corner"] = "Angolo (modalità Angolo)",
    ["corner_br"]                 = "In basso a destra",
    ["corner_bl"]                 = "In basso a sinistra",
    ["corner_tr"]                 = "In alto a destra",
    ["corner_tl"]                 = "In alto a sinistra",
    ["info_tooltip_anchor"]       = "Personalizzato: seleziona questa modalità e trascina la cornice teal nella posizione desiderata.",
    ["btn_tooltip_toggle_anchor"] = "Mostra/Nascondi l'ancoraggio",
    ["mover_tooltip_anchor"]      = "Ancoraggio tooltip",

    -- Nameplates preview
    ["np_preview_title"]   = "Anteprima nameplate",
    ["np_preview_hint"]    = "Leggibilità rapida: colore, cast, aure e minaccia in un unico posto.",
    ["preview_np_friendly"] = "Alleato",
    ["preview_np_target"]  = "Bersaglio ostile",
    ["preview_np_boss"]    = "Boss segnalato",

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
    ["cat_interface"]         = "Interfaccia",
    ["cat_units"]             = "Unità",
    ["cat_combat"]            = "Combattimento",
    ["cat_comfort"]           = "Comodità",
    ["cat_tools"]             = "Strumenti",
    ["cat_accueil_desc"]      = "Panoramica, preset e azioni rapide.",
    ["cat_interface_desc"]    = "Aspetto globale, barre, suoni e finestre di Blizzard.",
    ["cat_units_desc"]        = "Giocatore, nameplates, gruppo e raid in un unico posto.",
    ["cat_combat_desc"]       = "Lanci, risorse, cooldown e Mythic+.",
    ["cat_comfort_desc"]      = "Automazioni, missioni, AFK, housing e comodità.",
    ["cat_changelog"]                 = "Novit\195\160",
    ["cat_changelog_desc"]            = "Tutte le note di versione, dalla pi\195\185 recente alla pi\195\185 vecchia.",
    ["cl_title"]                      = "Note di versione",
    ["cl_intro"]                      = "%d versioni. Clicca su un numero per leggerne le note.",
    ["cl_unavailable"]                = "Impossibile caricare le note di versione.",
    ["cat_tools_desc"]        = "Profili, backup, diagnostica e manutenzione.",
    ["cat_profiles_desc"]     = "Profili, specializzazioni, importa / esporta e ripristini.",
    ["cat_diagnostics_desc"]  = "Stato in tempo reale, errori Lua e misure di prestazione.",
    ["cat_damagemeter"]                 = "Misuratore di danni",
    ["cat_damagemeter_desc"]            = "Misuratore di danni, riepilogo morte e riepilogo dungeon.",
    ["dm_cfg_title"]                    = "Misuratore di danni",
    ["dm_cfg_intro"]                    = "Il misuratore mantiene per ora la propria finestra di impostazioni. Sar\195\160 integrata qui a breve.",
    ["dm_cfg_open"]                     = "Apri le impostazioni del misuratore",
    ["dm_cfg_toggle"]                   = "Mostra / nascondi le finestre",
    ["dm_cfg_standalone"]               = "L\226\128\153addon TomoDamageMeter autonomo \195\168 installato e gestisce il misuratore. Il modulo integrato resta inattivo.",
    ["dm_cfg_unavailable"]              = "Il misuratore di danni di Blizzard non \195\168 disponibile su questo client, il modulo \195\168 inattivo.",
    ["cfg_tab_general"]       = "Generale",
    ["cfg_tab_actionbars"]    = "Barre d'azione",
    ["cfg_tab_skins"]         = "Skins",
    ["cfg_tab_sound"]         = "Suono",
    ["cfg_tab_unitframes"]    = "UnitFrames",
    ["cfg_tab_nameplates"]    = "Nameplates",
    ["cfg_tab_partyframes"]   = "Gruppo",
    ["cfg_tab_raidframes"]    = "Raid",
    ["cfg_tab_castbars"]      = "Barre di lancio",
    ["cfg_tab_resources"]     = "CD e Risorse",
    ["cfg_tab_mythicplus"]    = "Mythic+",
    ["cfg_tab_qol"]           = "Qualità della vita",
    ["cfg_tab_housing"]       = "Housing",
    ["cfg_tab_profiles"]      = "Profili",
    ["cfg_tab_diagnostics"]   = "Diagnostica",
    ["cfg_reload_text"]       = "Ricaricare l'interfaccia per applicare questa modifica?",
    ["cfg_reload_confirm"]    = "Ricarica",
    ["cfg_reload_later"]      = "Più tardi",
    ["cfg_footer_perf"]       = "FPS: %d  |  Mem.: %s",
    -- =====================
    -- CONFIG: CD/Resource & Profiles panels [Lot D2]
    -- =====================
    ["section_cdm_alpha"]             = "Opacità",
    ["opt_rb_primary_centered"]       = "Mostra risorsa primaria al centro dello schermo",
    ["info_rb_primary_centered"]      = "Sposta la barra di mana/energia/furia del frame del giocatore al centro dello schermo.",
    ["opt_rb_primary_power_height"]   = "Altezza barra principale",
    ["import_preview_analyzing"]      = "Analisi in corso...",
    ["profiles_export_failed"]        = "Esportazione non riuscita",
    ["profiles_import_failed"]        = "Importazione non riuscita",
    ["profiles_error"]                = "Errore",
    ["profiles_rename_failed"]        = "Ridenominazione non riuscita",
    -- =====================
    -- CONFIG: General panel — minimap & buttonbag [Lot D3]
    -- =====================
    ["section_minimap_indicators"]    = "Indicatori minimappa",
    ["info_minimap_indicators"]       = "Scegli un indicatore, poi imposta il suo angolo, dimensione e offset. Applicato in tempo reale.",
    ["opt_indicator"]                 = "Indicatore",
    ["opt_corner"]                    = "Angolo",
    ["opt_offset_x"]                  = "Offset X",
    ["opt_offset_y"]                  = "Offset Y",
    ["corner_topleft"]                = "In alto a sinistra",
    ["corner_topright"]               = "In alto a destra",
    ["corner_bottomleft"]             = "In basso a sinistra",
    ["corner_bottomright"]            = "In basso a destra",
    ["opt_minimap_tracking"]          = "Pulsante di tracciamento",
    ["opt_tracking_style"]            = "Stile pulsante di tracciamento",
    ["opt_minimap_mail"]              = "Posta",
    ["opt_minimap_difficulty"]        = "Difficoltà",
    ["opt_minimap_expansion"]         = "Pulsante espansione",
    ["opt_minimap_crafting"]          = "Ordini di lavorazione",
    ["minimap_style_bliz"]            = "Blizzard",
    ["minimap_style_tomo"]            = "TomoMod",
    ["section_buttonbag"]             = "Pulsanti addon",
    ["info_buttonbag"]                = "Raccoglie i pulsanti degli addon della minimappa in una borsa. Clicca sul pulsante sulla minimappa per aprirla.",
    ["opt_buttonbag_enable"]          = "Attiva il raccoglitore",
    ["opt_collector_style"]           = "Stile raccoglitore",
    ["collector_style_bliz"]          = "Blizzard (nativo)",
    ["collector_style_tomo"]          = "TomoMod (borsa)",
    ["opt_buttonbag_anchor"]          = "Posizione pulsante",
    ["buttonbag_anchor_corner"]       = "Sulla minimappa (angolo)",
    ["buttonbag_anchor_clockl"]       = "A sinistra dell'orologio",
    ["buttonbag_anchor_clockr"]       = "A destra dell'orologio",
    ["opt_buttonbag_columns"]         = "Colonne",
    ["opt_buttonbag_iconsize"]        = "Dimensione icona",
    ["btn_buttonbag_rescan"]          = "Rileva di nuovo i pulsanti",
    -- =====================
    -- CONFIG: Remaining panels [Lot D4]
    -- =====================
    ["btn_bar_uniformize"]            = "Copia l'aspetto di questa barra su tutte le barre",
    ["info_bar_uniformize"]           = "Copia l'aspetto (dimensione, spaziatura, colonne, alpha, scala, dissolvenza, testi…) su ogni altra barra. Posizione e stato di attivazione di ciascuna barra vengono mantenuti.",
    ["opt_bar_hotkey_size"]           = "Dimensione carattere tasto rapido",
    ["popup_ab_uniformize"]           = "Copiare l'aspetto della barra «%s» su tutte le altre barre?",
    ["info_cb_anchor_uf"]             = "Questa barra di lancio è ancorata al frame unità corrispondente (quindi appare sul frame bersaglio/focus/famiglio/boss).",
    ["tab_qol_compass"]               = "Bussola",
    ["section_compass"]               = "Barra bussola",
    ["info_compass_desc"]             = "Una barra di direzione nella parte superiore dello schermo che mostra N/E/S/O mentre ti giri, con un indicatore che punta verso la tua missione tracciata o il punto di passaggio sulla mappa. Sola lettura, nessun taint.",
    ["info_compass_layout"]           = "Suggerimento: usa la modalità Layout (/tm layout) per trascinare la barra dove preferisci.",
    ["opt_compass_enable"]            = "Attiva barra bussola",
    ["opt_compass_fov"]               = "Campo visivo",
    ["compass_fov_narrow"]            = "Stretto (±45°)",
    ["compass_fov_standard"]          = "Standard (±60°)",
    ["compass_fov_wide"]              = "Ampio (±90°)",
    ["opt_compass_width"]             = "Larghezza barra",
    ["opt_compass_height"]            = "Altezza barra",
    ["opt_compass_scale"]             = "Scala",
    ["opt_compass_show_heading"]      = "Mostra lettura direzione (es. 245° SO)",
    ["opt_compass_show_distance"]     = "Mostra distanza sugli indicatori",
    ["opt_compass_show_quest"]        = "Mostra indicatore missione tracciata",
    ["opt_compass_show_waypoint"]     = "Mostra indicatore punto di passaggio mappa",
    ["opt_skyride_ground_speed"]      = "Mostra velocità al suolo",
    ["info_skyride_ground_speed"]     = "Mostra anche la tua velocità di movimento al suolo (gli indicatori di volo restano nascosti quando non stai volando).",
    ["btn_class_reminder_preview"]    = "Anteprima",
    ["sublabel_class_reminder_coverage"] = "— Buff e forme monitorati —",
    ["opt_char_skin_movable"]         = "Finestra spostabile",
    ["info_char_skin_movable"]        = "Una volta attivato, trascina la finestra Personaggio per spostarla. La sua posizione viene memorizzata.",
    ["btn_char_skin_reset_pos"]       = "Ripristina posizione",
    ["btn_sound_test"]                = "▶ Riproduci questo suono",
    ["opt_auras_max_width"]           = "Larghezza massima (a capo)",
    ["opt_auras_per_row"]             = "Icone per riga",

    -- 3.2.0
    ["cfg_tab_cdforge"]           = "Cooldowns",

    -- 3.2.1

    -- 3.2.2
    -- Supporti del Cooldown Manager (Movers / modalità disposizione)
    ["mover_cdm"]                        = "Cooldown Manager",
    ["cdm_drag_hint"]                    = "Trascina per spostare",
    ["cdm_preview_aura"]                 = "Aura",




    -- =====================
    -- Traduzioni mancanti -- these keys previously fell back to enUS
    -- =====================
    ["opt_cursor_ring_texture"]           = "Texture",
    ["cursor_tex_ring"]                   = "Anello",
    ["cursor_tex_glow"]                   = "Bagliore",
    ["cursor_tex_cygle"]                  = "Cygle",
    ["cursor_tex_heart"]                  = "Cuore",
    ["opt_cdm_custom_cd_swipe"]           = "Colore sweep di recupero personalizzato",
    ["opt_cdm_cd_swipe_color"]            = "Colore dello sweep di recupero",
    ["opt_cdm_cd_swipe_alpha"]            = "Opacità dello sweep di recupero",
    ["section_cdm_advanced"]              = "Avanzate",
    ["opt_cdm_hide_gcd"]                  = "Nascondi il GCD",
    ["opt_cdm_desaturate"]                = "Desatura durante il recupero",
    ["opt_cdm_buff_alignment"]            = "Allineamento dei potenziamenti",
    ["align_center_outward"]              = "Centro → verso l'esterno",
    ["align_start"]                       = "Inizio (sinistra)",
    ["align_end"]                         = "Fine (destra)",
    ["section_cdm_visibility"]            = "Regole di visibilità",
    ["info_cdm_visibility"]               = "Regole di occultamento con priorità. Le condizioni «Mostra» hanno la precedenza sulle condizioni «Nascondi».",
    ["opt_cdm_hide_mounted"]              = "Nascondi quando in sella",
    ["opt_cdm_hide_vehicle"]              = "Nascondi nel veicolo",
    ["opt_cdm_hide_ooc"]                  = "Nascondi fuori dal combattimento (senza bersaglio)",
    ["opt_cdm_show_combat"]               = "Mostra sempre in combattimento",
    ["opt_cdm_show_instance"]             = "Mostra sempre in istanza",
    ["opt_cdm_show_enemy"]                = "Mostra con bersaglio nemico",
    ["section_cdm_extras"]                = "Suono / Pandemic / Portata",
    ["opt_cdm_sound_alert"]               = "Suono quando la magia è pronta",
    ["opt_cdm_sound_file"]                = "File audio",
    ["opt_cdm_pandemic"]                  = "Pandemic (bordo di rinnovo)",
    ["opt_cdm_pandemic_threshold"]        = "Soglia Pandemic (%)",
    ["opt_cdm_range_check"]               = "Colora di rosso fuori portata",
    ["ot_bucket_complete"]                = "Pronte da consegnare",
    ["ot_bucket_campaign"]                = "Campagna",
    ["ot_bucket_important"]               = "Importanti",
    ["ot_bucket_legendary"]               = "Leggendarie",
    ["ot_bucket_weekly"]                  = "Settimanali",
    ["ot_bucket_daily"]                   = "Giornaliere",
    ["ot_bucket_world"]                   = "Missioni del mondo",
    ["ot_bucket_dungeon"]                 = "Spedizioni",
    ["ot_bucket_raid"]                    = "Incursioni",
    ["ot_bucket_profession"]              = "Professioni",
    ["ot_bucket_achievement"]             = "Imprese",
    ["ot_bucket_quests"]                  = "Missioni",
    ["ot_bucket_other"]                   = "Altre",
    ["mover_minimap"]                     = "Minimappa e pannello",
    ["mover_objectivetracker"]            = "Tracciatore obiettivi",
    ["tab_skin_chatframeui"]              = "Interfaccia chat",
    ["sublabel_chatframeui"]              = "— Interfaccia chat multi-posizione —",
    ["opt_cfui_enable"]                   = "Attiva l'interfaccia chat",
    ["opt_cfui_enable_desc"]              = "Aggiunge contenitori decorativi, una barra di pulsanti, icone laterali e il cambio di layout (stile MayronUI).",
    ["opt_cfui_frame_topleft"]            = "Riquadro in alto a sinistra",
    ["opt_cfui_frame_topright"]           = "Riquadro in alto a destra",
    ["opt_cfui_frame_bottomleft"]         = "Riquadro in basso a sinistra",
    ["opt_cfui_frame_bottomright"]        = "Riquadro in basso a destra",
    ["opt_cfui_show_tab_bar"]             = "Mostra la barra delle schede",
    ["opt_cfui_tab_bar_offset"]           = "Scostamento Y della barra delle schede",
    ["opt_cfui_window_offset"]            = "Scostamento Y della finestra",
    ["opt_cfui_x_offset"]                 = "Scostamento X",
    ["opt_cfui_y_offset"]                 = "Scostamento Y",
    ["opt_cfui_icons_anchor"]             = "Ancoraggio delle icone laterali",
    ["opt_cfui_raid_frame_mgr"]           = "Ridisegna il gestore dei riquadri incursione",
    ["opt_cfui_editbox_position"]         = "Posizione della casella di testo",
    ["opt_cfui_editbox_height"]           = "Altezza della casella di testo",
    ["opt_cfui_swap_in_combat"]           = "Consenti il cambio dei pulsanti in combattimento",
    ["cfui_show_chat_menu"]               = "Mostra il menu chat",
    ["cfui_show_professions"]             = "Mostra le professioni",
    ["cfui_show_shortcuts"]               = "Mostra le scorciatoie degli addon",
    ["cfui_copy_chat"]                    = "Copia il testo della chat",
    ["cfui_click_toggle_status"]          = "Clicca per attivare/disattivare AFK",
    ["cfui_layout_button"]                = "Layout TomoMod",
    ["cfui_left_click"]                   = "Clic sinistro:",
    ["cfui_switch_layout"]                = "Cambia layout",
    ["cfui_no_layouts"]                   = "Nessun layout salvato. Usa /tm layout save <nome>",
    ["cfui_no_professions"]               = "Non hai professioni.",
    ["cfui_config_menu"]                  = "Configurazione",
    ["cfui_profiles"]                     = "Profili",
    ["cfui_clear_chat"]                   = "Svuota la chat",
    ["cfui_reload_ui"]                    = "Ricarica l'interfaccia",
    ["cfui_btn_character"]                = "Personaggio",
    ["cfui_btn_bags"]                     = "Borse",
    ["cfui_btn_friends"]                  = "Amici",
    ["cfui_btn_guild"]                    = "Gilda",
    ["cfui_btn_help"]                     = "Menu di aiuto",
    ["cfui_btn_pvp"]                      = "PvP",
    ["cfui_btn_spellbook"]                = "Manuale delle magie",
    ["cfui_btn_talents"]                  = "Talenti",
    ["cfui_btn_achievements"]             = "Imprese",
    ["cfui_btn_calendar"]                 = "Calendario",
    ["cfui_btn_lfd"]                      = "Cerca spedizione",
    ["cfui_btn_raid"]                     = "Incursione",
    ["cfui_btn_encounter"]                = "Guida alle avventure",
    ["cfui_btn_collections"]              = "Collezioni",
    ["cfui_btn_macros"]                   = "Macro",
    ["cfui_btn_worldmap"]                 = "Mappa del mondo",
    ["cfui_btn_questlog"]                 = "Diario delle missioni",
    ["cfui_btn_reputation"]               = "Reputazione",
    ["cfui_btn_pvpscore"]                 = "Punteggio PvP",
    ["cfui_btn_currency"]                 = "Valuta",
    ["btn_abs_layout"]                    = "EditMode (/tm layout)",
    ["opt_bar_enabled"]                   = "Attivata",
    ["opt_bar_orientation"]               = "Orientamento",
    ["opt_bar_grow_dir"]                  = "Direzione di crescita",
    ["opt_bar_columns"]                   = "Colonne",
    ["opt_bar_button_size"]               = "Dimensione dei pulsanti",
    ["opt_bar_spacing"]                   = "Spaziatura",
    ["opt_bar_alpha"]                     = "Trasparenza",
    ["opt_bar_scale"]                     = "Scala",
    ["opt_bar_display_cond"]              = "Condizione di visualizzazione",
    ["opt_bar_fade"]                      = "Attiva la dissolvenza",
    ["opt_bar_fade_out_alpha"]            = "Trasparenza in dissolvenza",
    ["opt_bar_fade_out_delay"]            = "Ritardo prima della dissolvenza",
    ["opt_bar_fade_out_dur"]              = "Durata della dissolvenza in uscita",
    ["opt_bar_fade_in_dur"]               = "Durata della dissolvenza in entrata",
    ["opt_bar_click_through"]             = "Ignora i clic",
    ["opt_bar_show_empty"]                = "Mostra i pulsanti vuoti",
    ["opt_bar_show_hotkey"]               = "Mostra il testo delle scorciatoie",
    ["opt_bar_disabled"]                  = "Disattivata",
    ["bar_name_bar1"]                     = "Barra 1 (principale)",
    ["bar_name_bar2"]                     = "Barra 2",
    ["bar_name_bar3"]                     = "Barra 3",
    ["bar_name_bar4"]                     = "Barra 4",
    ["bar_name_bar5"]                     = "Barra 5",
    ["bar_name_bar6"]                     = "Barra 6",
    ["bar_name_bar7"]                     = "Barra 7",
    ["bar_name_bar8"]                     = "Barra 8",
    ["bar_name_pet"]                      = "Barra del famiglio",
    ["bar_name_stance"]                   = "Barra delle posture",
    ["pf_opt_name_max_length"]            = "Lettere max nel nome (0 = nessun limite)",
    ["tab_qol_consumable_bar"]            = "Consumabili",
    ["section_consumable_bar"]            = "Barra dei consumabili",
    ["info_cb_desc"]                      = "Mostra un'icona e un timer per ogni consumabile attivo: fiala (1 h), ben nutrito (1 h) e olio per armi (2 h). Lo slot dell'olio per la mano secondaria appare solo se vi è equipaggiata un'arma.",
    ["opt_consumable_enable"]             = "Attiva la barra dei consumabili",
    ["opt_cb_show_missing"]               = "Mostra i potenziamenti mancanti (attenuati)",
    ["opt_cb_icon_size"]                  = "Dimensione delle icone",
    ["opt_cb_gap"]                        = "Spazio tra le icone",
    ["opt_cb_orientation"]                = "Orientamento",
    ["cb_orient_horizontal"]              = "Orizzontale",
    ["cb_orient_vertical"]                = "Verticale",
    ["opt_cb_timer_pos"]                  = "Posizione del timer",
    ["cb_timerpos_below"]                 = "Sotto (orizzontale)",
    ["cb_timerpos_above"]                 = "Sopra (orizzontale)",
    ["cb_timerpos_right"]                 = "Destra (verticale)",
    ["cb_timerpos_left"]                  = "Sinistra (verticale)",
    ["mover_consumable_bar"]              = "Barra dei consumabili",
    ["mover_class_reminder"]              = "Promemoria di classe",
    ["art_title"]                         = "Tracciatore di ricette",
    ["art_no_recipes"]                    = "Nessuna ricetta tracciata — traccia una ricetta nella finestra della professione.",
    ["art_status_idle"]                   = "Clicca su un ingrediente per cercarlo nella casa d'aste.",
    ["art_scan_btn"]                      = "Scansiona la casa d'aste",
    ["art_scan_running"]                  = "Scansione...",
    ["art_scan_started"]                  = "Scansione avviata — attendi...",
    ["art_scan_done"]                     = "Scansione completata: %d oggetti registrati.",
    ["art_scan_failed"]                   = "Scansione fallita o interrotta.",
    ["art_scan_cooldown"]                 = "Prossima scansione disponibile tra %dm %ds.",
    ["art_scan_tip_title"]                = "Scansione completa della casa d'aste",
    ["art_scan_tip_desc"]                 = "Registra l'acquisto immediato più basso per oggetto. Limitato a una volta ogni 15 minuti.",
    ["art_only_at_ah"]                    = "Apri prima la casa d'aste.",
    ["art_scan_already"]                  = "Una scansione è già in corso.",
    ["art_tt_stack"]                      = "Pila",
    ["art_tt_scanned"]                    = "Scansionato",
    ["art_tt_just_now"]                   = "proprio ora",
    ["art_tt_min_ago"]                    = "%dm fa",
    ["art_tt_hour_ago"]                   = "%dh fa",
    ["art_tt_day_ago"]                    = "%dg fa",
    ["tab_qol_rare_alert"]                = "Avviso rari",
    ["section_rare_alert"]                = "Avviso rari",
    ["opt_rare_alert_enable"]             = "Attiva gli avvisi di prossimità dei rari",
    ["opt_rare_alert_sound"]              = "Riproduci un suono di avviso",
    ["opt_rare_alert_duration"]           = "Durata del banner (s)",
    ["btn_reset_rare_alert_pos"]          = "Reimposta la posizione del banner",
    ["rare_alert_info"]                   = "Ti avvisa quando un PNG raro è nelle vicinanze. Clicca sul banner per bersagliarlo, applicare il simbolo del teschio e impostare un punto di rotta. Clic destro per chiuderlo. Usa /tm layout per spostare il banner.",
    ["rare_alert_tooltip"]                = "Clic sinistro: bersaglia + teschio + punto di rotta. Clic destro: chiudi.",

    -- =====================
    -- 3.3.2 — Novità
    -- =====================

    -- =====================
    -- 3.3.3 — Novità
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
    -- 3.5.7 — Novità
    -- =====================

    -- =====================
    -- 3.5.5 — Novità
    -- =====================

    -- =====================
    -- 3.5.4 — Novità

    -- =====================
    -- 3.5.3 — Novità

    -- 3.5.2 — Novità
    -- =====================

    -- =====================
    -- 3.5.1 — Novità
    -- =====================

    -- =====================
    -- 3.4.6 — Novità
    -- =====================


    -- =====================
    -- 3.4.5 — Novità
    -- =====================


    -- =====================
    -- 3.4.4 — Novità
    -- =====================


    -- =====================
    -- 3.4.3 — Novità
    -- =====================

    -- =====================
    -- 3.4.2 — Novità
    -- =====================

    -- =====================
    -- 3.4.1 — Novità
    -- =====================

    -- =====================
    -- 3.3.6 — Novità
    -- =====================

    -- =====================
    -- 3.3.5 — Novità
    -- =====================

    -- =====================
    -- 3.3.4 — Novità
    -- =====================

    -- =====================
    -- QOL: Companion Status (promemoria del famiglio)
    -- =====================
    ["tab_qol_companion"]             = "Promemoria famiglio",
    ["section_companion"]             = "Stato del famiglio",
    ["info_companion_desc"]           = "Mostra un promemoria quando il tuo famiglio manca o è morto. Appare solo per le specializzazioni che ne usano davvero uno: cacciatori Maestria delle Bestie e Sopravvivenza, tutti gli stregoni e i cavalieri della morte Empi. Lupo Solitario e Grimorio del Sacrificio lo disattivano da soli.",
    ["info_companion_unavailable"]    = "Il modulo non ha ancora finito di caricarsi. Riapri questa scheda tra poco.",
    ["opt_companion_enable"]          = "Attiva promemoria famiglio",
    ["opt_companion_hide_mounted"]    = "Nascondi su cavalcatura terrestre",
    ["info_companion_travel"]         = "Il promemoria è sempre nascosto in volo, sui voli di linea e nei veicoli. Disattiva questa opzione per continuare a vederlo su una cavalcatura terrestre.",
    ["opt_companion_display_mode"]    = "Visualizzazione",
    ["companion_mode_icon"]           = "Icona",
    ["companion_mode_text"]           = "Testo",
    ["companion_mode_both"]           = "Entrambi",
    ["opt_companion_scale"]           = "Scala",
    ["opt_companion_size"]            = "Dimensione icona",
    ["sublabel_companion_pos"]        = "Posizione",
    ["opt_companion_x"]               = "Scostamento orizzontale",
    ["opt_companion_y"]               = "Scostamento verticale",
    ["btn_companion_reset_pos"]       = "Reimposta posizione",
    ["info_companion_slash"]          = "Comandi: /cs on, /cs off, /cs mounted, /cs debug.",
    ["companion_pet_missing"]         = "Famiglio assente",
    ["companion_pet_dead"]            = "Famiglio morto",

    -- ActionBars: Secure Visibility Engine
    ["Secure Visibility"] = "Visibilità sicura",
    ["Visibility Mode"] = "Modalità visibilità",
    ["Always"] = "Sempre",
    ["In Combat"] = "In combattimento",
    ["Out of Combat"] = "Fuori combattimento",
    ["Solo"] = "Solo",
    ["Party Only"] = "Solo gruppo",
    ["Raid Only"] = "Solo incursione",
    ["Any Instance"] = "Qualsiasi istanza",
    ["Mounted"] = "In sella",
    ["Has Target"] = "Con bersaglio",
    ["Hostile Target"] = "Bersaglio ostile",
    ["Hidden"] = "Nascosta",
    ["Custom Condition"] = "Condizione personalizzata",
    ["Securely show or hide this bar based on game state. These rules keep working in combat without normal Lua Show/Hide calls."] = "Mostra o nasconde questa barra in modo sicuro in base allo stato di gioco. Le regole continuano a funzionare in combattimento senza normali chiamate Lua Show/Hide.",

    -- ActionBars: Secure Paging
    ["Secure Paging"] = "Cambio pagina sicuro",
    ["Securely switch Action Bar 1 by modifier, target, form, skyriding, or manual page. Vehicle and override pages always keep priority."] = "Cambia in sicurezza la Barra azioni 1 in base a modificatore, bersaglio, forma, volo dinamico o pagina manuale. Le pagine veicolo e sostitutive hanno sempre la priorità.",
    ["Alt Modifier Page"] = "Pagina con Alt",
    ["Shift Modifier Page"] = "Pagina con Maiusc",
    ["Ctrl Modifier Page"] = "Pagina con Ctrl",
    ["Friendly Target Page"] = "Pagina con bersaglio amico",
    ["Hostile Target Page"] = "Pagina con bersaglio ostile",
    ["Disable Automatic Form Paging"] = "Disattiva cambio automatico delle forme",
    ["Disable Automatic Skyriding Paging"] = "Disattiva cambio automatico del volo dinamico",
    ["Default (no page switch)"] = "Predefinito (nessun cambio)",
    ["Action Bar 1"] = "Barra azioni 1",
    ["Action Bar 2"] = "Barra azioni 2",
    ["Action Bar 3"] = "Barra azioni 3",
    ["Action Bar 4"] = "Barra azioni 4",
    ["Action Bar 5"] = "Barra azioni 5",
    ["Action Bar 6"] = "Barra azioni 6",
    ["Action Bar 7"] = "Barra azioni 7",
    ["Action Bar 8"] = "Barra azioni 8",

    -- =====================
    -- HEALER STUDIO (advanced Party/Raid healer indicators)
    -- =====================
    ["btn_open_healerstudio"]    = "Apri Healer Studio",
    ["info_healerstudio"]        = "Profilo avanzato: scegli i tuoi HoT, scudi e benefici di cura, poi posiziona ogni icona liberamente sulla cella. Sostituisce la riga sopra quando e attivo.",
    ["hs_list"]                  = "AURE",
    ["hs_mode"]                  = "Profilo",
    ["hs_mode_party"]            = "Gruppo",
    ["hs_mode_raid"]             = "Incursione",
    ["hs_class"]                 = "Classe",
    ["hs_enable"]                = "Attiva il profilo avanzato",
    ["hs_healer_only"]           = "Solo in una specializzazione da guaritore",
    ["hs_show_duration"]         = "Mostra i secondi rimanenti",
    ["hs_show_duration_info"]    = "Disattivato, l'icona mantiene la sua spazzata di ricarica e perde solo il numero sopra. Utile sulle icone piccole, dove le cifre coprono quasi tutta l'immagine.",
    ["hs_mode_on"]               = "Profilo avanzato attivo: la riga di HoT classica e nascosta su queste celle.",
    ["hs_mode_off"]              = "La riga di HoT classica resta in uso finche questo profilo e disattivato.",
    ["hs_preset"]                = "Preimpostazione iniziale",
    ["hs_reset_class"]           = "Reimposta questa classe",
    ["hs_reset_position"]        = "Reimposta la posizione",
    ["hs_select"]                = "Seleziona un'aura nell'elenco per posizionarla.",
    ["hs_size"]                  = "Dimensione icona",
    ["hs_anchor"]                = "Ancoraggio",
    ["hs_offset_x"]              = "Scostamento orizzontale",
    ["hs_offset_y"]              = "Scostamento verticale",
    ["hs_hint"]                  = "Trascina le icone sulla cella - le modifiche vengono salvate subito",
    ["hs_combat"]                = "la disposizione non puo essere modificata in combattimento.",
    ["hs_cat_hot"]               = "HoT",
    ["hs_cat_shield"]            = "Scudo",
    ["hs_cat_beacon"]            = "Faro / legame",
    ["hs_cat_marker"]            = "Marcatore di cura",
    ["hs_cat_external"]          = "Esterno",

    -- Slash command output (Core/Init.lua, CooldownManager, UnitFrames)
    ["cli_after_combat"]       = "dopo il combattimento",
    ["cli_reload_required"]    = "/reload necessario",
    ["cli_dependents_off"]     = "dipendenti disattivati:",
    ["cli_deps_off"]           = "dipendenze disattivate:",
    ["cli_pending_reload"]     = "%s in attesa di /reload",
    ["cli_mod_live"]           = "%d a caldo",
    ["cli_mod_reload"]         = "%d con /reload",
    ["cli_mod_none"]           = "%d senza interruttore",
    ["cli_modules_hint"]       = "/tm modules <chiave> per attivare/disattivare",
    ["cli_backup_created"]     = "backup creato.",
    ["cli_backup_usage"]       = "/tm backup save | /tm backup restore [numero]",
    ["cli_layout_usage"]       = "/tm layout export|import <stringa>",
    ["cli_capture_failed"]     = "acquisizione non riuscita",
    ["cli_res_counts"]         = "%d caratteri, %d ancoraggi",
    ["msg_help_install"]       = "Riavvia l'assistente di configurazione",
    ["msg_help_loot"]          = "Apri il browser del bottino (spedizioni e incursioni)",
    ["msg_cdm_placement_mode"] = "Modalità posizionamento",
    ["msg_cdm_live_preview"]   = "Anteprima dal vivo",
    ["msg_uf_ouf_missing"]     = "Libreria oUF non trovata (X-oUF: TomoMod_oUF)!",

})
