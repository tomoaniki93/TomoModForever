-- =====================================
-- esES.lua — Español
-- =====================================

-- Perf: Lua builds the whole table constructor below before
-- TomoMod_RegisterLocale can decide to discard it. For a player on any other
-- locale that is ~2900 key/value pairs allocated and turned straight into
-- garbage, five files over, on every /reload. The chunk still compiles (the
-- TOC loads it), but the constructor never runs.
if GetLocale() ~= "esES" then return end

TomoMod_RegisterLocale("esES", {

    -- =====================
    -- CONFIG: Categories (ConfigUI.lua)
    -- =====================
    ["cat_general"]         = "General",
    ["cat_unitframes"]      = "UnitFrames",
    ["cat_nameplates"]      = "Nameplates",
    ["cat_cd_resource"]     = "CD y Recursos",
    ["cat_qol"]             = "Calidad de vida",
    ["cat_mythicplus"]      = "Mythic+",
    ["cat_profiles"]        = "Perfiles",
    ["cat_diagnostics"]     = "Diagnósticos",

    -- =====================
    -- CONFIG: General Panel
    -- =====================
    ["section_about"]                   = "Acerca de",
    ["about_text"]                      = "|cffffd100TomoModForever|r %s por TomoAniki\nInterfaz ligera con QOL, UnitFrames y Nameplates.\nEscribe /tmf help para la lista de comandos.",
    ["section_general"]                 = "General",
    ["btn_reset_all"]                   = "Reiniciar todo",
    ["info_reset_all"]                  = "Esto reiniciará TODOS los ajustes y recargará la interfaz.",

    -- Minimap
    ["section_minimap"]                 = "Minimapa",
    ["opt_minimap_enable"]              = "Activar minimapa personalizado",
    ["opt_size"]                        = "Tamaño",
    ["opt_scale"]                       = "Escala",
    ["opt_border"]                      = "Borde",
    ["border_class"]                    = "Color de clase",
    ["border_black"]                    = "Negro",

    -- Info Panel
    ["section_info_panel"]              = "Panel de información",
    ["opt_enable"]                      = "Activar",
    ["opt_durability"]                  = "Durabilidad (Equipo)",
    ["info_durability_position"]        = "Posición del texto de durabilidad — útil si un botón (p. ej. expansión) se superpone a la esquina predeterminada.",
    ["opt_durability_corner"]           = "Esquina (durabilidad)",
    ["opt_time"]                        = "Hora",
    ["opt_24h_format"]                  = "Formato 24h",
    ["opt_show_coords"]                 = "Mostrar coordenadas",
    ["btn_reset_position"]              = "Reiniciar posición",

    -- Cursor Ring
    ["section_cursor_ring"]             = "Anillo del cursor",
    ["opt_class_color"]                 = "Color de clase",
    ["opt_anchor_tooltip_ring"]         = "Anclar tooltip al cursor",

    -- =====================
    -- CONFIG: UnitFrames Panel
    -- =====================
    -- Tabs
    ["tab_general"]                     = "General",
    ["tab_player"]                      = "Jugador",
    ["tab_target"]                      = "Objetivo",
    ["tab_tot"]                         = "OdO",
    ["tab_pet"]                         = "Mascota",
    ["tab_focus"]                       = "Foco",
    ["tab_colors"]                      = "Colores",

    -- Sub-tabs (Player, Target, Focus)
    ["subtab_dimensions"]               = "Dimensiones",
    ["subtab_display"]                  = "Visualización",
    ["subtab_auras"]                    = "Auras",
    ["subtab_positioning"]              = "Posición",

    -- Sub-labels
    ["sublabel_dimensions"]             = "— Dimensiones —",
    ["sublabel_display"]                = "— Visualización —",
    ["sublabel_castbar"]                = "— Barra de lanzamiento —",
    ["sublabel_auras"]                  = "— Auras —",
    ["sublabel_element_offsets"]        = "— Posiciones de elementos —",

    -- Unit display names
    ["unit_player"]                     = "Jugador",
    ["unit_target"]                     = "Objetivo",
    ["unit_tot"]                        = "Objetivo del objetivo",
    ["unit_pet"]                        = "Mascota",
    ["unit_focus"]                      = "Foco",

    -- General tab
    ["section_general_settings"]        = "Ajustes generales",
    ["opt_uf_enable"]                   = "Activar UnitFrames de TomoMod",
    ["opt_hide_blizzard"]               = "Ocultar marcos de Blizzard",
    ["opt_global_font_size"]            = "Tamaño de fuente global",
    ["sublabel_font"]                   = "— Fuente —",
    ["opt_font_family"]                 = "Familia de fuente",

    -- Castbar colors
    ["section_castbar_colors"]          = "Colores de la barra de lanzamiento",
    ["info_castbar_colors"]             = "Personaliza los colores de la barra de lanzamiento para hechizos interrumpibles, no interrumpibles e interrumpidos.",
    ["opt_castbar_color"]               = "Hechizo interrumpible",
    ["opt_castbar_ni_color"]            = "Hechizo no interrumpible",
    ["opt_castbar_interrupt_color"]     = "Hechizo interrumpido",
    ["info_castbar_colors_reload"]      = "Los cambios de color se aplican a nuevos lanzamientos. /reload para efecto completo.",
    ["btn_toggle_lock"]                 = "Bloquear/Desbloquear (/tmf uf)",
    ["info_unlock_drag"]                = "Desbloquea para mover los marcos. Las posiciones se guardan automáticamente.",

    -- Per-unit options
    ["opt_width"]                       = "Ancho",
    ["opt_health_height"]               = "Altura de vida",
    ["opt_power_height"]                = "Altura de recurso",
    ["opt_show_name"]                   = "Mostrar nombre",
    ["opt_name_truncate"]               = "Truncar nombres largos",
    ["opt_name_truncate_length"]        = "Longitud máx. del nombre",
    ["opt_show_level"]                  = "Mostrar nivel",
    ["opt_show_health_text"]            = "Mostrar texto de vida",
    ["opt_health_format"]               = "Formato de vida",
    ["fmt_current"]                     = "Actual (25.3K)",
    ["fmt_percent"]                     = "Porcentaje (75%)",
    ["fmt_current_percent"]             = "Actual + % (25.3K | 75%)",
    ["fmt_current_max"]                 = "Actual / Máx",
    ["opt_class_color_uf"]              = "Color de clase",
    ["opt_faction_color"]               = "Color de facción (PNJ)",
    ["opt_use_nameplate_colors"]        = "Colores de Nameplate (tipo de PNJ)",
    ["opt_show_absorb"]                 = "Barra de absorción",
    ["opt_show_threat"]                 = "Indicador de amenaza (brillo de borde)",
    ["section_threat_text"]             = "Texto % de amenaza",
    ["opt_threat_text_enable"]          = "Mostrar % de amenaza en el objetivo",
    ["opt_threat_text_font_size"]       = "Tamaño de fuente",
    ["info_threat_text"]                = "Verde = tanqueando (ventaja), amarillo = advertencia, rojo = aggro perdido",
    ["opt_show_leader_icon"]            = "Icono de líder",
    ["opt_leader_icon_x"]               = "Icono de líder X",
    ["opt_leader_icon_y"]               = "Icono de líder Y",
    ["opt_raid_icon_x"]                 = "Marcador de raid X",
    ["opt_raid_icon_y"]                 = "Marcador de raid Y",

    -- Castbar
    ["opt_castbar_enable"]              = "Activar barra de lanzamiento",
    ["opt_castbar_width"]               = "Ancho de barra de lanzamiento",
    ["opt_castbar_height"]              = "Altura de barra de lanzamiento",
    ["opt_castbar_show_icon"]           = "Mostrar icono",
    ["opt_castbar_show_timer"]          = "Mostrar temporizador",
    ["info_castbar_drag"]               = "Posición: /tmf sr para desbloquear y mover la barra de lanzamiento.",
    ["btn_reset_castbar_position"]      = "Reiniciar posición de la barra de lanzamiento",
    ["opt_castbar_show_latency"]        = "Mostrar latencia",

    -- Auras
    ["opt_auras_enable"]                = "Activar auras",
    ["opt_auras_max"]                   = "Auras máximas",
    ["opt_auras_size"]                  = "Tamaño de icono",
    ["opt_auras_type"]                  = "Tipo de aura",
    ["aura_harmful"]                    = "Debuffs (perjudiciales)",
    ["aura_helpful"]                    = "Buffs (beneficiosos)",
    ["aura_all"]                        = "Beneficios y perjuicios",
    ["opt_auras_direction"]             = "Dirección de crecimiento",
    ["opt_auras_direction_v"]           = "Dirección vertical",
    ["aura_dir_down"]                   = "Hacia abajo",
    ["aura_dir_up"]                     = "Hacia arriba",
    ["aura_dir_right"]                  = "Hacia la derecha",
    ["aura_dir_left"]                   = "Hacia la izquierda",
    ["opt_auras_only_mine"]             = "Solo mis auras",

    -- Element offsets
    ["elem_name"]                       = "Nombre",
    ["elem_level"]                      = "Nivel",
    ["elem_health_text"]                = "Texto de vida",
    ["elem_power"]                      = "Barra de recurso",
    ["elem_castbar"]                    = "Barra de lanzamiento",
    ["elem_auras"]                      = "Auras",
    ["elem_enemy_buffs"]                = "Beneficios del objetivo",

    -- AstralForge: element registry
    ["elem_raid_icon"]                  = "Marca de banda",
    ["elem_leader_icon"]                = "Icono de líder",
    ["elem_threat_text"]                = "Texto de amenaza",
    ["elem_pet_happiness"]             = "Felicidad de la mascota",
    ["opt_element_anchor"]              = "Anclaje",
    ["btn_reset_elements"]              = "Restablecer posición de elementos",
    ["anchor_host_frame"]               = "Marco",
    ["anchor_host_health"]              = "Barra de salud",
    ["anchor_host_power"]               = "Barra de recurso",
    ["anchor_host_infobar"]             = "Barra de información",
    ["btn_open_astralforge"]            = "Abrir AstralForge",
    ["info_astralforge"]                = "AstralForge es el diseñador completo: arrastra cada elemento directamente sobre el marco y elige su punto de anclaje y su anfitrión. Los deslizadores de abajo siguen disponibles para ajustes al píxel.",
    ["target_kind_host"]                = "Estructura: ",
    ["target_kind_element"]             = "Elemento: ",

    -- AstralForge : proprietes par element
    ["sublabel_element_props"]          = "Propiedades visuales",
    ["opt_element_alpha"]               = "Opacidad (%)",
    ["opt_element_scale"]               = "Escala (%)",
    ["opt_element_font_size"]           = "Forzar tamaño de fuente",
    ["info_element_font_size"]          = "Déjalo en 0 para conservar el tamaño calculado por el módulo.",

    -- AstralForge : elements instancies
    ["elem_custom_text"]                = "Texto personalizado",
    ["opt_custom_text_template"]        = "Plantilla de texto",
    ["info_custom_text_tokens"]         = "Etiquetas disponibles:",
    ["btn_add_custom_text"]             = "Añadir un texto personalizado",
    ["btn_reset_element"]               = "Restablecer este elemento",
    ["btn_delete_element"]              = "Eliminar este elemento",
    ["msg_element_max_reached"]         = "Se alcanzó el número máximo de elementos de este tipo.",

    -- AstralForge : presets de disposition
    ["section_forge_presets"]           = "Ajustes de diseño",
    ["btn_forge_presets"]               = "Ajustes de diseño",
    ["info_forge_presets"]              = "Un ajuste guarda el diseño completo del sujeto actual: anclajes, propiedades visuales y elementos personalizados.",
    ["opt_preset_name"]                 = "Nombre del ajuste",
    ["btn_preset_save"]                 = "Guardar / sobrescribir",
    ["opt_preset_saved"]                = "Ajustes guardados",
    ["btn_preset_apply"]                = "Aplicar",
    ["btn_preset_delete"]               = "Eliminar",
    ["btn_preset_export"]               = "Generar cadena para compartir",
    ["opt_preset_share_string"]         = "Cadena para compartir",
    ["info_preset_copy"]                = "Haz clic en el campo y pulsa Ctrl+A y Ctrl+C para copiar.",
    ["opt_preset_import"]               = "Pega una cadena para compartir",
    ["btn_preset_import"]               = "Importar",
    ["info_no_preset"]                  = "Aún no hay ningún ajuste guardado para este sujeto.",
    ["msg_preset_saved"]                = "Ajuste guardado.",
    ["msg_preset_applied"]              = "Ajuste aplicado.",
    ["msg_preset_imported"]             = "Ajuste importado:",
    ["msg_preset_error"]                = "La operación sobre el ajuste falló.",
    ["msg_presets_unavailable"]         = "Los ajustes de diseño no están disponibles.",
    ["token_classification"]            = "Clasificación",
    ["token_name"]                      = "Nombre",
    ["token_level"]                     = "Nivel",
    ["token_class"]                     = "Clase",
    ["token_race"]                      = "Raza",
    ["token_guild"]                     = "Hermandad",

    -- AstralForge : domaine plaques de nom
    ["section_np_elements"]             = "Posición de los elementos",
    ["info_np_elements"]                = "Abre AstralForge para arrastrar cada elemento sobre la placa y elegir su anclaje. Los deslizadores de abajo sirven para ajustes al píxel.",
    ["np_host_plate"]                   = "Placa",
    ["np_host_health"]                  = "Barra de salud",
    ["np_host_castbar"]                 = "Barra de lanzamiento",
    ["np_host_name"]                    = "Nombre",
    ["np_elem_name"]                    = "Nombre",
    ["np_elem_hp_number"]               = "Valor de salud",
    ["np_elem_hp_percent"]              = "Porcentaje de salud",
    ["np_elem_level"]                   = "Nivel",
    ["np_elem_class_icon"]              = "Icono de clasificación",
    ["np_elem_class_text"]              = "Texto de clasificación",
    ["np_elem_castbar"]                 = "Barra de lanzamiento",
    ["np_elem_cast_icon"]               = "Icono de lanzamiento",
    ["np_elem_cast_text"]               = "Nombre del hechizo",
    ["np_elem_cast_timer"]              = "Temporizador de lanzamiento",
    ["np_elem_cast_shield"]             = "Escudo de lanzamiento",
    ["np_elem_quest_icon"]              = "Icono de misión",
    ["np_elem_raid_marker"]             = "Marca de banda",

    -- =====================
    -- CONFIG: Nameplates Panel
    -- =====================
    -- Nameplate tabs
    ["tab_np_auras"]                    = "Auras",
    ["tab_np_advanced"]                 = "Avanzado",
    ["info_np_colors_custom"]           = "Cada color se puede personalizar haciendo clic en la muestra de color.",

    ["section_np_general"]              = "Ajustes generales",
    ["opt_np_enable"]                   = "Activar Nameplates de TomoMod",
    ["info_np_description"]             = "Reemplaza las nameplates de Blizzard con un estilo minimalista personalizable.",
    ["section_dimensions"]              = "Dimensiones",
    ["opt_np_name_font_size"]           = "Tamaño de fuente del nombre",

    -- Display
    ["section_display"]                 = "Visualización",
    ["opt_np_show_classification"]      = "Mostrar clasificación (élite, raro, jefe)",
    ["opt_np_show_absorb"]               = "Mostrar barra de absorción",
    ["opt_np_class_colors"]             = "Colores de clase (jugadores)",
    ["opt_np_friendly_name_only"]       = "Aliados: solo nombre (sin barra de vida)",
    ["opt_np_friendly_role_icons"]      = "Mostrar iconos de rol (mazmorra/delve)",
    ["opt_np_role_show_tank"]           = "Mostrar icono de Tanque",
    ["opt_np_role_show_healer"]         = "Mostrar icono de Sanador",
    ["opt_np_role_show_dps"]            = "Mostrar icono de DPS",
    ["opt_np_role_icon_size"]           = "Tamaño del icono de rol",

    -- Raid Marker
    ["section_raid_marker"]             = "Marcador de banda",
    ["opt_np_raid_icon_x"]              = "Desplazamiento X",
    ["opt_np_raid_icon_y"]              = "Desplazamiento Y",
    ["opt_np_raid_icon_size"]           = "Tamaño del icono",

    -- Castbar
    ["section_castbar"]                 = "Barra de lanzamiento",
    ["opt_np_show_castbar"]             = "Mostrar barra de lanzamiento",
    ["opt_np_castbar_height"]           = "Altura de la barra de lanzamiento",
    ["color_castbar"]                   = "Barra de lanzamiento (interrumpible)",
    ["color_castbar_uninterruptible"]   = "Barra de lanzamiento (no interrumpible)",

    -- Auras
    ["section_auras"]                   = "Auras",
    ["opt_np_show_auras"]               = "Mostrar auras",
    ["opt_np_aura_size"]                = "Tamaño de icono",
    ["opt_np_max_auras"]                = "Cantidad máxima",
    ["opt_np_only_my_debuffs"]          = "Solo mis debuffs",

    -- Enemy Buffs
    ["section_enemy_buffs"]              = "Buffs enemigos",
    ["sublabel_enemy_buffs"]             = "— Buffs enemigos —",
    ["opt_enemy_buffs_enable"]           = "Mostrar buffs enemigos",
    ["opt_enemy_buffs_max"]              = "Máx. buffs",
    ["opt_enemy_buffs_size"]             = "Tamaño de icono de buff",
    ["opt_enemy_buffs_direction"]        = "Dirección",
    ["opt_enemy_buffs_per_row"]          = "Iconos por fila",
    ["opt_enemy_buffs_row_orientation"]  = "Fila siguiente",
    ["info_enemy_buffs"]                 = "Muestra buffs activos (Enfurecer, escudos...) en unidades hostiles. Los iconos aparecen arriba a la derecha, apilándose hacia arriba.",
    ["opt_np_show_enemy_buffs"]          = "Mostrar buffs enemigos",
    ["opt_np_enemy_buff_size"]           = "Tamaño de icono de buff",
    ["opt_np_max_enemy_buffs"]           = "Máx. buffs enemigos",
    ["opt_np_enemy_buff_y_offset"]       = "Desplazamiento Y de buffs enemigos",

    -- Transparency
    ["section_transparency"]            = "Transparencia",
    ["opt_np_selected_alpha"]           = "Alfa seleccionado",
    ["opt_np_unselected_alpha"]         = "Alfa no seleccionado",

    -- Stacking
    ["section_stacking"]                = "Apilamiento",
    ["opt_np_overlap"]                  = "Superposición vertical",
    ["opt_np_top_inset"]                = "Límite superior de pantalla",

    -- Colors
    ["section_colors"]                  = "Colores",
    ["color_hostile"]                   = "Hostil (Enemigo)",
    ["color_neutral"]                   = "Neutral",
    ["color_friendly"]                  = "Amistoso",
    ["color_tapped"]                    = "Marcado (tapped)",
    ["color_focus"]                     = "Objetivo de foco",

    -- NPC Type Colors
    ["section_npc_type_colors"]         = "Colores por tipo de PNJ",
    ["color_caster"]                    = "Lanzador de hechizos",
    ["color_miniboss"]                  = "Mini-jefe (élite + nivel superior)",
    ["color_enemy_in_combat"]           = "Enemigo (predeterminado)",
    ["info_np_darken_ooc"]              = "Los enemigos fuera de combate se oscurecen automáticamente.",

    -- Classification colors
    ["section_classification_colors"]   = "Colores de clasificación",
    ["opt_np_use_classification"]       = "Colores por tipo de enemigo",
    ["color_boss"]                      = "Jefe",
    ["color_elite"]                     = "Élite / Mini-jefe",
    ["color_rare"]                      = "Raro",
    ["color_normal"]                    = "Normal",
    ["color_trivial"]                   = "Trivial",

    -- Tank mode
    ["section_tank_mode"]               = "Modo tanque",
    ["opt_np_tank_mode"]                = "Activar modo tanque (colores de amenaza)",
    ["color_no_threat"]                 = "Sin amenaza",
    ["color_low_threat"]                = "Amenaza baja",
    ["color_has_threat"]                = "Amenaza mantenida",
    ["color_dps_has_aggro"]             = "DPS/Sanador tiene aggro",
    ["color_dps_near_aggro"]            = "DPS/Sanador cerca del aggro",

    -- NP health format
    ["np_fmt_percent"]                  = "Porcentaje (75%)",
    ["np_fmt_current"]                  = "Actual (25.3K)",
    ["np_fmt_current_percent"]          = "Actual + %",

    -- Reset
    ["btn_reset_nameplates"]            = "Reiniciar Nameplates",

    -- =====================
    -- CONFIG: CD & Resource Panel
    -- =====================
    -- Resource colors
    ["section_resource_colors"]         = "Colores de recursos",
    ["res_runes_ready"]                 = "Runas (listas)",
    ["res_runes_cd"]                    = "Runas (enfriamiento)",

    -- Cooldown Manager
    ["tab_cdm"]                         = "Enfriamientos",
    ["tab_cdm_bars"]                    = "Barras",
    ["tab_resource_bars"]               = "Barras de recursos",
    ["tab_text_position"]               = "Texto y posición",
    ["tab_rb_colors"]                   = "Colores",
    ["info_rb_colors_custom"]           = "Cada color se puede personalizar haciendo clic en la muestra de color.",

    ["section_cdm"]                     = "Gestor de enfriamientos",
    ["opt_cdm_enable"]                  = "Activar gestor de enfriamientos",
    ["info_cdm_description"]            = "Reskin de los iconos del CooldownManager de Blizzard: bordes redondeados, overlay de clase en auras activas, colores de barrido personalizados, atenuación de utilidades, diseño centrado. Colocación mediante Edit Mode de Blizzard.",
    ["opt_cdm_show_hotkeys"]            = "Mostrar atajos de teclado",
    ["opt_cdm_combat_alpha"]            = "Modificar opacidad (combate / objetivo)",
    ["opt_cdm_alpha_combat"]            = "Alfa en combate",
    ["opt_cdm_alpha_target"]            = "Alfa con objetivo (fuera de combate)",
    ["opt_cdm_alpha_ooc"]               = "Alfa fuera de combate",
    ["section_cdm_overlay"]             = "Overlay y bordes",
    ["opt_cdm_custom_overlay"]          = "Color de overlay personalizado",
    ["opt_cdm_overlay_color"]           = "Color del overlay",
    ["opt_cdm_custom_swipe"]            = "Color de barrido activo personalizado",
    ["opt_cdm_swipe_color"]             = "Color del barrido",
    ["opt_cdm_swipe_alpha"]             = "Opacidad del barrido",
    ["section_cdm_utility"]             = "Utilidad",
    ["opt_cdm_dim_utility"]             = "Atenuar iconos de utilidad fuera de CD",
    ["opt_cdm_dim_opacity"]             = "Opacidad de atenuación",
    ["opt_cdm_bufficon_direction"]        = "Dirección iconos de buff",
    ["opt_cdm_buffbar_direction"]         = "Dirección BuffBar",
    ["opt_cdm_buffbar_width"]             = "Ancho barra (horizontal)",
    ["buffbar_vertical"]                  = "Vertical",
    ["buffbar_horizontal"]                = "Horizontal",
    ["dir_centered"]                      = "Centrado (horizontal)",
    ["dir_left"]                          = "Izquierda",
    ["dir_right"]                         = "Derecha",
    ["dir_up"]                            = "Arriba",
    ["dir_down"]                          = "Abajo",
    ["info_cdm_editmode"]               = "La colocación se realiza mediante el Edit Mode de Blizzard (Esc |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Edit Mode).",

    -- CDM V3.2: Colocación y tarjetas de viewer (Phase 4)
    ["section_cdm_placement"]            = "Colocación y vista previa en vivo",
    ["info_cdm_placement"]               = "Las barras del CDM ahora son posicionadas por TomoMod (ya no se necesita el Edit Mode de Blizzard). El modo de colocación muestra iconos ficticios y permite arrastrar cada barra.",
    ["btn_cdm_unlock"]                   = "Modo de colocación (en vivo)",
    ["opt_cdm_preview"]                  = "Vista previa (iconos ficticios)",
    ["info_cdm_preview_live"]            = "Ajustes por barra en la pestaña «Barras» — todo se aplica en vivo.",
    ["info_cdm_bars"]                    = "Cada barra tiene su propia posición y disposición. Activa la vista previa para ver los cambios en vivo, o el modo de colocación para arrastrar las barras con el ratón.",
    ["btn_cdm_reset_pos"]                = "Restablecer posiciones",
    ["msg_cdm_pos_reset"]                = "Posiciones del CDM restablecidas.",
    ["section_cdm_essential"]            = "Essential (hechizos principales)",
    ["section_cdm_utility_bar"]          = "Utility (hechizos de utilidad)",
    ["section_cdm_bufficons"]            = "Iconos de buff (auras — iconos)",
    ["section_cdm_buffbars"]             = "Barras de buff (auras — barras)",
    ["opt_cdm_pos_x"]                    = "Posición X",
    ["opt_cdm_pos_y"]                    = "Posición Y",
    ["opt_cdm_icon_size"]                = "Tamaño de icono (0 = automático)",
    ["opt_cdm_spacing"]                  = "Espaciado",
    ["opt_cdm_row_limit"]                = "Por fila (0 = ilimitado)",
    ["opt_cdm_direction"]                = "Dirección",
    ["opt_cdm_secondary_direction"]      = "Dirección secundaria",
    ["opt_cdm_buffbar_spacing"]          = "Espaciado",
    ["secdir_auto"]                      = "Auto",
    ["secdir_down"]                      = "Filas hacia abajo",
    ["secdir_up"]                        = "Filas hacia arriba",
    ["secdir_right"]                     = "Columnas hacia la derecha",
    ["secdir_left"]                      = "Columnas hacia la izquierda",

    -- Resource Bars
    ["section_resource_bars"]           = "Barras de recursos",
    ["opt_rb_enable"]                   = "Activar barras de recursos",
    ["info_rb_description"]             = "Muestra recursos de clase (Maná, Ira, Energía, Puntos de combo, Runas, etc.) con soporte adaptativo para Druidas.",
    ["section_visibility"]              = "Visibilidad",
    ["opt_rb_visibility_mode"]          = "Modo de visibilidad",
    ["vis_always"]                      = "Siempre visible",
    ["vis_combat"]                      = "Solo en combate",
    ["vis_target"]                      = "Combate u objetivo",
    ["vis_hidden"]                      = "Oculto",
    ["opt_rb_combat_alpha"]             = "Alfa en combate",
    ["opt_rb_ooc_alpha"]                = "Alfa fuera de combate",
    ["opt_rb_width"]                    = "Ancho",
    ["opt_rb_classpower_height"]        = "Altura del poder de clase",
    ["opt_rb_druidmana_height"]         = "Altura de maná de druida",
    ["opt_rb_global_scale"]             = "Escala global",

    -- v2.9: Barra de vida (HUD)
    ["section_rb_healthbar"]            = "Barra de vida (HUD)",
    ["opt_rb_hb_enable"]                = "Mostrar barra de vida",
    ["info_rb_healthbar"]               = "Barra de vida centrada sobre los recursos. Texto y color de umbral gestionados en el cliente (compatible con Midnight).",
    ["opt_rb_hb_height"]                = "Altura",
    ["opt_rb_hb_text"]                  = "Texto",
    ["hb_text_none"]                    = "Ninguno",
    ["hb_text_value"]                   = "Valor",
    ["hb_text_percent"]                 = "Porcentaje",
    ["hb_text_both"]                    = "Valor | %",
    ["opt_rb_hb_classcolor"]            = "Color de clase",
    ["opt_rb_hb_color"]                 = "Color personalizado (si el color de clase está desactivado)",
    ["opt_rb_hb_threshold"]             = "Umbral de vida baja (cambia el color)",
    ["opt_rb_hb_threshold_pct"]         = "Umbral (%)",
    ["opt_rb_hb_threshold_color"]       = "Color de vida baja",

    -- v2.9: Animaciones y barra de poder
    ["section_rb_anim"]                 = "Animaciones y barra de poder",
    ["opt_rb_smooth"]                   = "Animaciones suaves de las barras",
    ["opt_rb_full_glow"]                = "Destello al máximo de recurso de clase",
    ["opt_rb_supercharged_points"]      = "Mostrar puntos de combo sobrecargados",
    ["opt_rb_power_ticks"]              = "Marcas en la barra de poder (% del máx.)",
    ["ticks_none"]                      = "Ninguno",
    ["opt_rb_power_threshold"]          = "Umbral de recurso bajo (barra de poder)",
    ["opt_rb_power_threshold_pct"]      = "Umbral (%)",
    ["opt_rb_power_threshold_color"]    = "Color de recurso bajo",
    ["info_rb_anim"]                    = "Las marcas y el umbral se aplican a la barra de poder centrada. El suavizado también se aplica a la barra de vida, al maná de druida y a las barras de auras.",

    ["opt_rb_sync_width"]               = "Sincronizar ancho con Essential Cooldowns",
    ["btn_sync_now"]                    = "Sincronizar ahora",
    ["info_rb_sync"]                    = "Alinea el ancho con el EssentialCooldownViewer del CooldownManager de Blizzard.",

    -- Text & Font
    ["section_text_font"]               = "Texto y fuente",
    ["opt_rb_show_text"]                = "Mostrar texto en barras",
    ["opt_rb_text_align"]               = "Alineación del texto",
    ["align_left"]                      = "Izquierda",
    ["align_center"]                    = "Centro",
    ["align_right"]                     = "Derecha",
    ["opt_rb_font_size"]                = "Tamaño de fuente",
    ["opt_rb_font"]                     = "Fuente",
    ["font_default_wow"]                = "WoW predeterminado",

    -- Position
    ["section_position"]                = "Posición",
    ["info_rb_position"]                = "Usa /tmf uf para desbloquear y mover las barras. La posición se guarda automáticamente.",
    ["info_rb_druid"]                   = "Las barras se adaptan automáticamente a tu clase y especialización.\nDruida: el recurso cambia con la forma (Oso |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Ira, Gato |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Energía, Equilibrio |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Poder astral).",

    -- =====================
    -- CONFIG: QOL Panel
    -- =====================
    ["tab_qol_cinematic"]               = "Cinemática",
    ["tab_qol_auto_quest"]              = "Auto misiones",
    ["tab_qol_automations"]             = "Automatizaciones",
    ["tab_qol_mythic_keys"]             = "Llaves M+",
    ["tab_qol_skyride"]                 = "SkyRide",
    ["tab_qol_action_bars"]             = "Barras de acción",
    ["section_action_bars"]             = "Skin de barras de acción",
    ["section_ab_system"]               = "Action Bar System",
    ["opt_ab_system_enable"]            = "Enable TomoMod Action Bar system (requires reload)",
    ["opt_ab_system_reload"]            = "Disabling this fully restores Blizzard action bars after /reload.",
    ["section_ab_skin"]                 = "Visual Skin",

    -- ActionBars: LibKeyBound integration (Lot A9)
    ["btn_ab_kb_lib"]                       = "Modo de asignación (LibKeyBound)",
    ["info_ab_kb_lib"]                      = "Modo de asignación compartido, detectado desde otro addon. Asigna las barras de TomoMod y las de ese addon a la vez.",

    -- ActionBars: keybinding command labels (Lot A8)
    ["binding_category"]                    = "Barras de acción de TomoMod",
    ["binding_bar_header"]                  = "Barra TomoMod %d",
    ["binding_button"]                      = "Barra %d Botón %d",

    ["options_load_failed"]             = "panel de opciones no disponible — ¿está activado el addon TomoModForever_Options?",

    ["anchor_queue"]                    = "Ojo de cola",

    ["microbar_native_not_found"]       = "no se ha encontrado el micromenú de Blizzard para ocultarlo — repórtalo con tu versión del cliente.",

    ["microbar_tt_perf"]                    = "Rendimiento",
    ["microbar_tt_fps"]                     = "Fotogramas por segundo",
    ["microbar_tt_latency"]                 = "Latencia",
    ["microbar_tt_cpu"]                     = "CPU de addons",
    ["microbar_tt_cpu_off"]                 = "perfilado desactivado",

    -- ActionBars: rebuilt panel on the Tui schema (lot P5)
    ["section_ab_totem"]                 = "Tótems",
    ["opt_ab_totem_enabled"]             = "Barra de tótems",
    ["info_ab_totem"]                    = "Una barra que muestra tus tótems activos y su duración restante. Colócala en el modo de disposición.",
    ["mover_totembar"]                  = "Barra de tótems",
    ["opt_ab_flash"]                    = "Efecto al pulsar",
    ["info_ab_flash"]                   = "Lo que se dibuja mientras se mantiene pulsado un botón. La textura de TomoMod oscurece el icono; la de Blizzard es el destello estándar.",
    ["info_ab_masque"]                      = "Solo tiene efecto si Masque está instalado. El aspecto propio se desactiva entonces para que no compitan.",
    ["info_ab_nodb"]                        = "Ajustes de las barras de acción no disponibles: la base de datos no se ha inicializado. Recarga la interfaz.",
    ["opt_ab_assisted"]                     = "Resaltado asistido",
    ["opt_ab_backdrop"]                     = "Fondo",
    ["opt_ab_backdrop_alpha"]               = "Opacidad del fondo",
    ["opt_ab_borders"]                      = "Bordes",
    ["opt_ab_gloss"]                        = "Brillo",
    ["opt_ab_gloss_alpha"]                  = "Opacidad del brillo",
    ["opt_ab_glow_color"]                   = "Color del brillo",
    ["opt_ab_glow_source"]                  = "Fuente del brillo",
    ["opt_ab_hide_empty"]                   = "Ocultar casillas vacías",
    ["opt_ab_hide_empty_keybinds"]          = "Ocultar la tecla en casillas vacías",
    ["opt_ab_icon_size"]                    = "Tamaño de los botones",
    ["opt_ab_icon_skin"]                    = "Aspecto de los iconos",
    ["opt_ab_keydown"]                      = "Lanzar al pulsar la tecla",
    ["opt_ab_lock"]                         = "Bloquear los botones",
    ["opt_ab_mana_color"]                   = "Color sin recurso",
    ["opt_ab_masque"]                       = "Dejar que Masque aplique el aspecto",
    ["opt_ab_range"]                        = "Indicador fuera de alcance",
    ["opt_ab_range_color"]                  = "Color fuera de alcance",
    ["opt_ab_skin_enabled"]                 = "Aplicar aspecto a los botones",
    ["opt_ab_spacing"]                      = "Espaciado",
    ["opt_ab_tooltips"]                     = "Mostrar descripciones",
    ["opt_ab_usability"]                    = "Indicador no utilizable",
    ["opt_ab_usability_color"]              = "Color no utilizable",
    ["opt_abf_combat"]                      = "Siempre visible en combate",
    ["opt_abf_delay"]                       = "Retraso antes de desvanecer",
    ["opt_abf_enabled"]                     = "Desvanecer las barras",
    ["opt_abf_in"]                          = "Duración de aparición",
    ["opt_abf_link"]                        = "Vincular las barras 1 a 8",
    ["opt_abf_out"]                         = "Duración de desaparición",
    ["opt_abf_out_alpha"]                   = "Opacidad desvanecida",
    ["opt_abt_anchor"]                      = "Posición",
    ["opt_abt_color"]                       = "Color",
    ["opt_abt_cooldowntext"]                = "Números de reutilización",
    ["opt_abt_counts"]                      = "Cargas y montones",
    ["opt_abt_keybinds"]                    = "Atajos",
    ["opt_abt_macronames"]                  = "Nombres de macro",
    ["opt_abt_offx"]                        = "Desplazamiento horizontal",
    ["opt_abt_offy"]                        = "Desplazamiento vertical",
    ["opt_abt_show"]                        = "Mostrar",
    ["opt_abt_size"]                        = "Tamaño de fuente",
    ["opt_bar_buttons"]                     = "Número de botones",
    ["opt_bar_grow_left"]                   = "Crecer hacia la izquierda",
    ["opt_bar_grow_up"]                     = "Crecer hacia arriba",
    ["opt_bar_size"]                        = "Tamaño de los botones",
    ["section_ab_behaviour"]                = "Comportamiento",
    ["section_ab_chrome"]                   = "Marco y fondo",
    ["section_ab_fade"]                     = "Desvanecido",
    ["section_ab_general"]                  = "Botones",
    ["section_ab_states"]                   = "Estados",
    ["tab_ab_fade"]                         = "Desvanecido",
    ["tab_ab_general"]                      = "General",
    ["tab_ab_indicators"]                   = "Indicadores",
    ["tab_ab_texts"]                        = "Textos",

    -- ActionBars: rebuild notice (lot P4)
    ["info_ab_rebuilding"]              = "Las barras de acción se están reconstruyendo sobre un nuevo motor. Sus ajustes vuelven en la próxima actualización; las barras funcionan con normalidad mientras tanto.",

    -- ActionBars: config tab labels (Lot A7)
    ["tab_abs_buttons"]                     = "Botones",
    ["tab_abs_glow"]                        = "Brillo",
    ["tab_abs_hotkeys"]                     = "Atajos",

    -- ActionBars: TomoMod-owned buttons (Lot A6)
    ["opt_bar_own_buttons"]                 = "Botones de TomoMod (experimental)",
    ["info_bar_own_buttons"]                = "Sustituye los botones de Blizzard por los de TomoMod en esta barra. Requiere /reload. Los flyouts (portales, trampas, frascos) y el resaltado asistido aún no son compatibles.",

    -- ActionBars: special bars (stances, pet, state decoration)
    ["section_ab_special"]                  = "Posturas, mascota y estados",
    ["opt_ab_sp_active"]                    = "Resaltar la acción activa",
    ["opt_ab_sp_active_color"]              = "Color activo",
    ["opt_ab_sp_equipped"]                  = "Resaltar objetos equipados",
    ["opt_ab_sp_equipped_color"]            = "Color equipado",
    ["opt_ab_sp_thickness"]                 = "Grosor del resaltado",
    ["opt_ab_sp_autocast"]                  = "Destello de lanzamiento automático",
    ["opt_ab_sp_autocast_color"]            = "Color del lanzamiento automático",
    ["opt_ab_sp_pet_autohide"]              = "Ocultar la barra de mascota sin mascota",
    ["info_ab_sp_pet_autohide"]             = "La oculta mientras no tengas ninguna mascota. Las posturas no tienen condición equivalente y quedan en manos de Blizzard.",

    -- ActionBars: hotkey layer (keybind text, binding mode)
    ["section_ab_hotkey"]                   = "Atajos de teclado",
    ["opt_ab_hk_enable"]                    = "Mostrar atajos",
    ["opt_ab_hk_abbrev"]                    = "Abreviar",
    ["opt_ab_hk_size"]                      = "Tamaño de fuente",
    ["opt_ab_hk_anchor"]                    = "Posición",
    ["opt_ab_hk_offx"]                      = "Desplazamiento horizontal",
    ["opt_ab_hk_offy"]                      = "Desplazamiento vertical",
    ["opt_ab_hk_color"]                     = "Color del texto",
    ["opt_ab_hk_hide_empty"]                = "Ocultar en casillas vacías",
    ["btn_ab_hk_bind"]                      = "Modo de asignación",
    ["info_ab_hk_bind"]                     = "Asigna teclas directamente en las barras. No disponible en combate.",
    ["hotkey_bind_enter"]                   = "Modo de asignación: pasa el ratón por un botón y pulsa una tecla. Clic derecho o Escape borra.",
    ["hotkey_bind_exit"]                    = "Modo de asignación cerrado, atajos guardados.",
    ["hotkey_combat_blocked"]               = "El modo de asignación no está disponible en combate.",

    -- ActionBars: glow layer (procs, rotation hint)
    ["section_ab_glow"]                     = "Brillo (procs y rotación)",
    ["opt_ab_glow_proc"]                    = "Brillo al activarse",
    ["opt_ab_glow_proc_type"]               = "Estilo del brillo de proc",
    ["opt_ab_glow_proc_color"]              = "Color del brillo de proc",
    ["opt_ab_glow_assist"]                  = "Brillo en sugerencia de rotación",
    ["opt_ab_glow_assist_type"]             = "Estilo del brillo de rotación",
    ["opt_ab_glow_assist_color"]            = "Color del brillo de rotación",
    ["info_ab_glow_assist"]                 = "Sigue la recomendación del Resaltado Asistido de Blizzard. Requiere que la función esté disponible en tu personaje.",
    ["opt_ab_glow_lines"]                   = "Píxel: número de líneas",
    ["opt_ab_glow_freq"]                    = "Velocidad de animación",
    ["opt_ab_glow_thickness"]               = "Píxel: grosor de las líneas",

    -- ActionBars: render layer (icons, cooldowns, texts)
    ["section_ab_icons"]                    = "Iconos y reutilizaciones",
    ["opt_ab_cd_backend"]                   = "Fuente de la reutilización",
    ["info_ab_cd_managed"]                  = "Gestionada: TomoMod dibuja la reutilización. Necesaria para los futuros botones de TomoMod; la fuente de Blizzard es más segura por ahora.",
    ["opt_ab_cd_numbers"]                   = "Números de reutilización",
    ["opt_ab_cd_size"]                      = "Tamaño de los números",
    ["opt_ab_swipe_color"]                  = "Color del barrido",
    ["opt_ab_swipe_alpha"]                  = "Opacidad del barrido",
    ["opt_ab_show_count"]                   = "Mostrar cargas / montones",
    ["opt_ab_count_size"]                   = "Tamaño del texto de cargas",
    ["opt_ab_show_macro"]                   = "Mostrar nombre de macro",
    ["opt_ab_desat_unusable"]               = "Desaturar si no se puede usar",
    ["opt_ab_icon_zoom"]                    = "Recorte del icono",
    ["cat_action_bars"]                 = "Barras de acción",
    ["opt_abs_enable"]                  = "Activar skin de barras de acción",
    ["opt_abs_class_color"]             = "Color de clase para bordes",
    ["opt_abs_shift_reveal"]            = "Mantener Shift para revelar barras ocultas",
    ["sublabel_bar_opacity"]            = "— Opacidad por barra —",
    ["opt_abs_select_bar"]              = "Seleccionar barra de acción",
    ["btn_abs_apply_all_opacity"]       = "Aplicar a todas las barras",
    ["msg_abs_all_opacity"]             = "Opacidad establecida a %d%% en todas las barras",
    ["sublabel_bar_combat"]             = "— Visibilidad en combate —",
    ["opt_abs_combat_show"]             = "Mostrar solo en combate",

    ["section_cinematic"]               = "Saltar cinemáticas",
    ["opt_cinematic_auto_skip"]         = "Saltar automáticamente después de verla una vez",
    ["info_cinematic_viewed"]           = "Cinemáticas ya vistas: %s\nEl historial se comparte entre personajes.",
    ["btn_clear_history"]               = "Borrar historial",

    -- Auto Quest
    ["section_auto_quest"]              = "Auto misiones",
    ["opt_quest_auto_accept"]           = "Aceptar misiones automáticamente",
    ["opt_quest_auto_turnin"]           = "Entregar misiones automáticamente",
    ["opt_quest_auto_gossip"]           = "Seleccionar diálogos automáticamente",
    ["info_quest_shift"]                = "Mantén SHIFT para desactivar temporalmente.\nLas misiones con múltiples recompensas no se entregan automáticamente.",

    -- Objective Tracker Skin
    ["tab_qol_obj_tracker"]             = "Rastreador",
    ["section_obj_tracker"]             = "Skin del rastreador de objetivos",
    ["opt_obj_tracker_enable"]          = "Activar skin del rastreador",
    ["opt_obj_tracker_bg_alpha"]        = "Opacidad del fondo",
    ["opt_obj_tracker_border"]          = "Mostrar borde",
    ["opt_obj_tracker_hide_empty"]      = "Ocultar si está vacío",
    ["opt_obj_tracker_buckets"]         = "Agrupar misiones en categorías plegables",
    ["opt_obj_tracker_header_size"]     = "Tamaño de fuente de encabezado",
    ["opt_obj_tracker_cat_size"]        = "Tamaño de fuente de categoría",
    ["opt_obj_tracker_quest_size"]      = "Tamaño de fuente de título de misión",
    ["opt_obj_tracker_obj_size"]        = "Tamaño de fuente de objetivo",
    ["opt_obj_tracker_max_quests"]       = "Máx. misiones mostradas (0 = sin límite)",
    ["ot_overflow_text"]                 = "%d misión(es) más oculta(s)...",
    ["info_obj_tracker"]                = "Aplica un skin oscuro al rastreador de objetivos de Blizzard con un panel, fuentes personalizadas y encabezados de categoría coloreados.",
    ["ot_header_title"]                 = "OBJETIVOS",
    ["ot_collapse_all"]                  = "Contraer todo",
    ["ot_expand_all"]                    = "Expandir todo",
    ["ot_header_options"]               = "Opciones",

    -- Automations
    ["section_automations"]             = "Automatizaciones",
    ["opt_hide_blizzard_castbar"]       = "Ocultar barra de lanzamiento de Blizzard",
    ["opt_hide_talking_head"]           = "Ocultar Talking Head (di\195\161logos de desplazamiento)",
    ["opt_hide_status_bar2"]            = "Ocultar la barra de estado 2 de Blizzard",
    ["opt_hide_status_bar2_desc"]       = "Hace invisible y no clicable la segunda barra de estado del modo edición. Sigue perteneciendo a Blizzard, por lo que permanece en su modo edición.",

    -- Auto Accept Invite
    ["sublabel_auto_accept_invite"]     = "— Aceptar invitación automáticamente —",
    ["sublabel_auto_skip_role"]         = "— Saltar verificación de rol —",
    ["sublabel_tooltip_ids"]            = "— IDs de Tooltip —",
    ["sublabel_combat_res_tracker"]     = "— Rastreador de res. en combate —",
    ["opt_cr_show_rating"]              = "Mostrar puntuación M+",
    ["opt_show_messages"]               = "Mostrar mensajes en chat",
    ["opt_tid_spell"]                   = "ID de hechizo / aura",
    ["opt_tid_item"]                    = "ID de objeto",
    ["opt_tid_npc"]                     = "ID de PNJ",
    ["opt_tid_quest"]                   = "ID de misión",
    ["opt_tid_mount"]                   = "ID de montura",
    ["opt_tid_currency"]                = "ID de moneda",
    ["opt_tid_achievement"]             = "ID de logro",
    ["opt_accept_friends"]              = "Aceptar de amigos",
    ["opt_accept_guild"]                = "Aceptar de hermandad",

    -- Auto Summon
    ["sublabel_auto_summon"]            = "— Auto invocación —",
    ["opt_summon_delay"]                = "Retraso (segundos)",

    -- Auto Fill Delete
    ["sublabel_auto_fill_delete"]       = "— Auto rellenar ELIMINAR —",
    ["sublabel_auto_vendor_repair"]     = "— Auto Vendedor / Reparación —",
    ["opt_avr_auto_repair"]             = "Reparación automática en el comerciante",
    ["opt_avr_sell_grays"]              = "Vender automáticamente objetos grises (pobres)",
    ["opt_focus_ok_button"]             = "Enfocar botón OK tras rellenar",

    -- Mythic+ Keys
    ["section_mythic_keys"]             = "Llaves Míticas+",
    ["opt_keys_enable_tracker"]         = "Activar rastreador",
    ["opt_keys_mini_frame"]             = "Mini-marco en interfaz M+",
    ["opt_keys_auto_refresh"]           = "Actualización automática",

    -- SkyRide
    ["section_skyride"]                 = "SkyRide",
    ["opt_skyride_enable"]              = "Activar (pantalla de vuelo)",
    ["section_skyride_dims"]            = "Dimensiones",
    ["opt_skyride_bar_height"]          = "Altura de barra de velocidad",
    ["opt_skyride_charge_height"]       = "Altura de barra de carga",
    ["opt_skyride_charge_gap"]          = "Espacio entre segmentos",
    ["section_skyride_text"]            = "Texto",
    ["opt_skyride_show_speed_text"]     = "Mostrar porcentaje de velocidad",
    ["opt_skyride_speed_font_size"]     = "Tamaño de fuente de velocidad",
    ["opt_skyride_show_charge_timer"]   = "Mostrar temporizador de carga",
    ["opt_skyride_charge_font_size"]    = "Tamaño de fuente del temporizador",
    ["btn_reset_skyride"]               = "Reiniciar posición de SkyRide",

    -- =====================
    -- CONFIG: QOL — CVar Optimizer
    -- =====================
    ["tab_qol_cvar_opt"]                = "CVars Perf",
    ["section_cvar_optimizer"]          = "Optimizador de CVars",
    ["info_cvar_optimizer"]             = "Aplica ajustes gráficos/rendimiento recomendados. Tus valores actuales se guardan y pueden restaurarse en cualquier momento.",
    ["btn_cvar_apply_all"]              = ">> Aplicar todo",
    ["btn_cvar_revert_all"]             = "<< Restaurar todo",
    ["btn_cvar_apply"]                  = "Aplicar",
    ["btn_cvar_revert"]                 = "Restaurar",
    -- Categories
    ["opt_cat_render"]                  = "Renderizado y pantalla",
    ["opt_cat_graphics"]                = "Calidad gráfica",
    ["opt_cat_detail"]                  = "Distancia de visión y detalles",
    ["opt_cat_advanced"]                = "Avanzado",
    ["opt_cat_fps"]                     = "Límites de FPS",
    ["opt_cat_post"]                    = "Post-procesado",
    -- CVar labels
    ["opt_cvar_render_scale"]           = "Escala de renderizado",
    ["opt_cvar_vsync"]                  = "VSync",
    ["opt_cvar_msaa"]                   = "Multisampling (MSAA)",
    ["opt_cvar_low_latency"]            = "Modo de baja latencia",
    ["opt_cvar_anti_aliasing"]          = "Anti-aliasing",
    ["opt_cvar_shadow"]                 = "Calidad de sombras",
    ["opt_cvar_ssao"]                   = "SSAO",
    ["opt_cvar_depth"]                  = "Efectos de profundidad",
    ["opt_cvar_compute"]                = "Efectos de cálculo",
    ["opt_cvar_particle"]               = "Densidad de partículas",
    ["opt_cvar_liquid"]                 = "Detalle de líquidos",
    ["opt_cvar_spell_density"]          = "Densidad de hechizos",
    ["opt_cvar_projected"]              = "Texturas proyectadas",
    ["opt_cvar_outline"]                = "Modo de contorno",
    ["opt_cvar_texture_res"]            = "Resolución de texturas",
    ["opt_cvar_view_distance"]          = "Distancia de visión",
    ["opt_cvar_env_detail"]             = "Detalle del entorno",
    ["opt_cvar_ground"]                 = "Vegetación del suelo",
    ["opt_cvar_gfx_api"]                = "API gráfica",
    ["opt_cvar_triple_buffering"]       = "Triple buffering",
    ["opt_cvar_texture_filtering"]      = "Filtrado de texturas",
    ["opt_cvar_rt_shadows"]             = "Sombras ray tracing",
    ["opt_cvar_resample_quality"]       = "Calidad de remuestreo",
    ["opt_cvar_physics"]                = "Nivel de física",
    ["opt_cvar_target_fps"]             = "FPS objetivo",
    ["opt_cvar_bg_fps_enable"]          = "Límite de FPS en segundo plano",
    ["opt_cvar_bg_fps"]                 = "Valor de FPS en segundo plano",
    ["opt_cvar_resample_sharpness"]     = "Nitidez de remuestreo",
    ["opt_cvar_camera_shake"]           = "Vibración de cámara",
    -- Messages
    ["msg_cvar_applied"]                = "CVars aplicadas",
    ["msg_cvar_reverted"]               = "CVars restauradas",
    ["msg_cvar_no_backup"]              = "No se encontró respaldo — aplica primero.",
    ["tab_qol_leveling"]                = "Leveling",
    ["section_leveling_bar"]            = "Barra de experiencia",
    ["opt_leveling_enable"]             = "Activar barra de experiencia",
    ["opt_leveling_width"]              = "Ancho de la barra",
    ["opt_leveling_height"]             = "Altura de la barra",
    ["btn_reset_leveling_pos"]          = "Reiniciar posición",
    ["leveling_bar_title"]              = "Barra de experiencia",
    ["leveling_level"]                  = "Nivel",
    ["leveling_progress"]               = "Progreso:",
    ["leveling_rested"]                 = "Descansado",
    ["leveling_last_quest"]             = "Última misión:",
    ["leveling_ttl"]                    = "Tiempo para nivel:",
    ["leveling_remaining"]              = "Restante",
    ["leveling_session"]                = "Este nivel",
    ["leveling_drag_hint"]              = "/tmf sr para desbloquear y mover",

    -- =====================
    -- CONFIG: Profiles Panel (3 Tabs)
    -- =====================
    ["tab_profiles"]                    = "Perfiles",
    ["tab_import_export"]               = "Importar/Exportar",
    ["tab_resets"]                      = "Reinicio",

    -- Tab 1: Named profiles & specializations
    ["section_named_profiles"]          = "Perfiles",
    ["info_named_profiles"]             = "Crea y gestiona perfiles con nombre. Cada perfil guarda una instantánea completa de tus ajustes.",
    ["profile_active_label"]            = "Perfil activo",
    ["opt_select_profile"]              = "Elegir un perfil",
    ["sublabel_create_profile"]         = "— Crear nuevo perfil —",
    ["placeholder_profile_name"]        = "Nombre del perfil...",
    ["btn_create_profile"]              = "Crear perfil",
    ["btn_delete_named_profile"]        = "Eliminar perfil",
    ["btn_save_profile"]                = "Guardar perfil actual",
    ["info_save_profile"]               = "Guarda todos los ajustes actuales en el perfil activo. Esto se hace automáticamente al cambiar de perfil.",

    ["section_profile_mode"]            = "Modo de perfil",
    ["info_spec_profiles"]              = "Activa perfiles por especialización para guardar y cargar ajustes automáticamente al cambiar de especialización.\nCada especialización tiene su propia configuración independiente.",
    ["opt_enable_spec_profiles"]        = "Activar perfiles por especialización",
    ["profile_status"]                  = "Perfil activo",
    ["profile_global"]                  = "Global (perfil único)",
    ["section_spec_list"]               = "Especializaciones",
    ["profile_badge_active"]            = "Activo",
    ["profile_badge_saved"]             = "Guardado",
    ["profile_badge_none"]              = "Sin perfil",
    ["btn_copy_to_spec"]                = "Copiar actual",
    ["btn_delete_profile"]              = "Eliminar",
    ["info_spec_reload"]                = "Cambiar de especialización con perfiles activados recargará automáticamente la interfaz para aplicar el perfil correspondiente.",
    ["info_global_mode"]                = "Todas las especializaciones comparten los mismos ajustes. Activa perfiles por especialización arriba para usar configuraciones diferentes.",

    -- Tab 2: Import / Export
    ["section_export"]                  = "Exportar ajustes",
    ["info_export"]                     = "Genera una cadena comprimida de todos tus ajustes actuales.\nCópiala para compartirla o como copia de seguridad.",
    ["label_export_string"]             = "Cadena de exportación (clic para seleccionar todo)",
    ["btn_export"]                      = "Generar cadena de exportación",
    ["btn_copy_clipboard"]              = "Copiar texto",
    ["section_import"]                  = "Importar ajustes",
    ["info_import"]                     = "Pega una cadena de exportación abajo. Se validará antes de aplicarla.",
    ["label_import_string"]             = "Pega la cadena de importación aquí",
    ["btn_import"]                      = "Importar y aplicar",
    ["btn_paste_clipboard"]             = "Pegar texto",
    ["import_preview"]                  = "Clase: %s | Módulos: %s | Fecha: %s",
    ["import_preview_valid"]            = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t Cadena válida",
    ["import_preview_invalid"]          = "Cadena inválida o corrupta",
    ["info_import_warning"]             = "La importación SOBRESCRIBIRÁ todos tus ajustes actuales y recargará la interfaz. Esta acción no se puede deshacer.",

    -- Tab 3: Resets
    ["section_profile_mgmt"]            = "Gestión de perfiles",
    ["info_profiles"]                   = "Reinicia módulos individuales o exporta/importa tus ajustes.\nExportar copia los ajustes al portapapeles (requiere LibSerialize + LibDeflate).",
    ["section_reset_module"]            = "Reiniciar un módulo",
    ["btn_reset_prefix"]                = "Reiniciar: ",
    ["btn_reset_all_reload"]            = "(!) REINICIAR TODO + Recargar",
    ["section_reset_all"]               = "Reinicio completo",
    ["info_resets"]                     = "Reinicia un módulo individual a sus valores predeterminados. El módulo se recargará con los ajustes de fábrica.",
    ["info_reset_all_warning"]          = "Esto reiniciará TODOS los módulos y TODOS los ajustes a valores de fábrica, y luego recargará la interfaz.",

    -- =====================
    -- PRINT MESSAGES: Core
    -- =====================
    ["msg_db_reset"]                    = "Base de datos reiniciada",
    ["msg_migration_failed"]           = "Un paso de migración de la base de datos falló — por favor, repórtalo en el Discord: ",
    ["msg_normalize_failed"]           = "La normalización de elementos falló — por favor, repórtalo en el Discord: ",
    ["msg_module_reset"]                = "Módulo '%s' reiniciado",
    ["msg_db_not_init"]                 = "Base de datos no inicializada",
    ["msg_loaded"]                      = "cargado — %s para configuración",
    ["msg_report_issue"]                = "Si encuentras algún problema, deja un comentario en CurseForge.",
    ["at_rescue_header"]              = "El rastreador de auras se ha eliminado; CooldownForge cubre lo mismo.",
    ["at_rescue_list"]                = "Hechizos que hab\195\173as a\195\177adido a mano: %s",
    ["at_rescue_hint"]                = "Vuelve a a\195\177adirlos en el Cooldown Studio si a\195\186n los quieres.",
    ["msg_help_title"]                  = "Comandos:",
    ["msg_help_open"]                   = "Abrir configuración",
    ["msg_help_reset"]                  = "Reiniciar todo + recargar",
    ["msg_help_uf"]                     = "Bloquear/Desbloquear UnitFrames + Recursos",
    ["msg_help_uf_reset"]               = "Reiniciar UnitFrames",
    ["msg_help_rb"]                     = "Bloquear/Desbloquear barras de recursos",
    ["msg_help_rb_sync"]                = "Sincronizar ancho con Essential Cooldowns",
    ["msg_help_np"]                     = "Activar/desactivar Nameplates",
    ["msg_help_minimap"]                = "Reiniciar minimapa",
    ["msg_help_panel"]                  = "Reiniciar panel de info",
    ["msg_help_cursor"]                 = "Reiniciar anillo de cursor",
    ["msg_help_clearcinema"]            = "Borrar historial de cinemáticas",
    ["msg_help_sr"]                     = "Bloquear/Desbloquear SkyRide + Anclas",
    ["msg_help_key"]                    = "Abrir llaves Míticas+",
    ["msg_help_help"]                   = "Esta ayuda",

    -- =====================
    -- PRINT MESSAGES: Modules
    -- =====================
    -- CDM
    ["msg_cdm_status"]                  = "Activado",
    ["msg_cdm_disabled"]                = "Desactivado",

    -- Nameplates
    ["msg_np_enabled"]                  = "Activadas",
    ["msg_np_disabled"]                 = "Desactivadas",

    -- UnitFrames
    ["msg_uf_locked"]                   = "Bloqueado",
    ["msg_uf_unlocked"]                 = "Desbloqueado — Arrastra para reposicionar",
    ["msg_uf_initialized"]              = "Inicializado — /tmf uf para bloquear/desbloquear",
    ["msg_uf_enabled"]                  = "activado (recarga necesaria)",
    ["msg_uf_disabled"]                 = "desactivado (recarga necesaria)",
    ["msg_uf_position_reset"]           = "posición reiniciada",

    -- ResourceBars
    ["msg_rb_width_synced"]             = "Ancho sincronizado (%dpx)",
    ["msg_rb_locked"]                   = "Bloqueado",
    ["msg_rb_unlocked"]                 = "Desbloqueado — Arrastra para reposicionar",
    ["msg_rb_position_reset"]           = "Posición de barras de recursos reiniciada",

    -- SkyRide
    ["msg_sr_pos_saved"]                = "Posición de SkyRide guardada",
    ["msg_sr_locked"]                   = "SkyRide bloqueado",
    ["msg_sr_unlock"]                   = "Modo de movimiento de SkyRide activado – Haz clic y arrastra",
    ["msg_sr_pos_reset"]                = "Posición de SkyRide reiniciada",
    ["msg_sr_db_not_init"]              = "TomoModForeverDB no inicializada",
    ["msg_sr_initialized"]              = "Módulo SkyRide inicializado",

    -- FrameAnchors
    ["anchor_alert"]                    = "Alertas",
    ["anchor_loot"]                     = "Botín",
    ["msg_anchors_locked"]              = "Bloqueados",
    ["msg_anchors_unlocked"]            = "Desbloqueados — mueve las anclas",

    -- AutoVendorRepair
    ["msg_avr_header"]                  = "[AutoVendedorReparar]",
    ["msg_avr_sold"]                    = " Objetos grises vendidos por |cffffff00%s|r",
    ["msg_avr_repaired"]                = " Equipo reparado por |cffffff00%s|r",

    -- AutoFillDelete
    ["msg_afd_filled"]                  = "Texto 'ELIMINAR' auto-rellenado – Haz clic en OK para confirmar",
    ["msg_afd_db_not_init"]             = "TomoModForeverDB no inicializada",
    ["msg_afd_initialized"]             = "Módulo AutoFillDelete inicializado",
    ["msg_afd_enabled"]                 = "Auto-rellenar ELIMINAR activado",
    ["msg_afd_disabled"]                = "Auto-rellenar ELIMINAR desactivado (el hook permanece activo)",

    -- HideCastBar
    ["msg_hcb_db_not_init"]             = "TomoModForeverDB no inicializada",
    ["msg_hcb_initialized"]             = "Módulo HideCastBar inicializado",
    ["msg_hcb_hidden"]                  = "Barra de lanzamiento oculta",
    ["msg_hcb_shown"]                   = "Barra de lanzamiento mostrada",

    -- AutoAcceptInvite
    ["msg_aai_accepted"]                = "Invitación aceptada de ",
    ["msg_aai_ignored"]                 = "Invitación ignorada de ",
    ["msg_aai_enabled"]                 = "Auto-aceptar invitaciones activado",
    ["msg_aai_disabled"]                = "Auto-aceptar invitaciones desactivado",
    ["msg_asr_lfg_accepted"]            = "Verificación de rol auto-confirmada",
    ["msg_asr_poll_accepted"]           = "Encuesta de rol auto-confirmada",
    ["msg_asr_enabled"]                 = "Auto saltar verificación de rol activado",
    ["msg_asr_disabled"]                = "Auto saltar verificación de rol desactivado",
    ["msg_tid_enabled"]                 = "Tooltip IDs activado",
    ["msg_tid_disabled"]                = "Tooltip IDs desactivado",
    ["msg_cr_enabled"]                  = "Rastreador de res. en combate activado",
    ["msg_cr_disabled"]                 = "Rastreador de res. en combate desactivado",
    ["msg_cr_locked"]                   = "Rastreador de res. en combate bloqueado",
    ["msg_cr_unlock"]                   = "Rastreador de res. en combate desbloqueado — arrastra para mover",
    ["msg_abs_enabled"]                 = "Skin de barras de acción activado (recarga recomendada)",
    ["msg_abs_disabled"]                = "Skin de barras de acción desactivado",
    ["opt_buffskin_enable"]             = "Activar skin de buffs",
    ["opt_buffskin_desc"]               = "Añade bordes negros y temporizador coloreado en buffs/debuffs del jugador",
    ["msg_buffskin_enabled"]            = "Skin de buffs activado",
    ["msg_buffskin_disabled"]           = "Skin de buffs desactivado",
    ["msg_help_cr"]                     = "Bloquear/desbloquear rastreador de res. en combate",
    ["msg_help_cs"]                     = "Bloquear/desbloquear posición de hoja de personaje",
    ["msg_help_cs_reset"]               = "Reiniciar posición de hoja de personaje",

    -- CinematicSkip
    ["msg_cin_skipped"]                 = "Cinemática saltada (ya vista)",
    ["msg_vid_skipped"]                 = "Video saltado (ya visto)",
    ["msg_vid_id_skipped"]              = "Video #%d saltado",
    ["msg_cin_cleared"]                 = "Historial de cinemáticas borrado",

    -- AutoSummon
    ["msg_sum_accepted"]                = "Invocación aceptada de %s a %s (%s)",
    ["msg_sum_ignored"]                 = "Invocación ignorada de %s (no confiable)",
    ["msg_sum_enabled"]                 = "Auto-invocación activada",
    ["msg_sum_disabled"]                = "Auto-invocación desactivada",
    ["msg_sum_manual"]                  = "Invocación aceptada manualmente",
    ["msg_sum_no_pending"]              = "Sin invocación pendiente",

    -- MythicKeys
    ["msg_keys_no_key"]                 = "Sin llave para enviar.",
    ["msg_keys_not_in_group"]           = "Debes estar en un grupo.",
    ["msg_keys_reload"]                 = "Cambio aplicado en el próximo /reload.",
    ["mk_not_in_group"]                 = "No estás en un grupo.",
    ["mk_not_in_group_short"]           = "No estás en grupo.",
    ["mk_no_key_self"]                  = "No se encontró piedra angular.",
    ["mk_title"]                        = "TM — Llaves Míticas",
    ["mk_btn_send"]                     = "Enviar al chat",
    ["mk_btn_refresh"]                  = "Actualizar",
    ["mk_tab_keys"]                     = "Llaves",
    ["mk_tab_tp"]                       = "TP",
    ["mk_tp_click_to_tp"]              = "Clic para teletransportarse",
    ["mk_tp_not_unlocked"]             = "No desbloqueado",
    ["msg_tp_not_owned"]               = "No tienes el teletransporte para %s",
    ["msg_tp_combat"]                  = "No se pueden actualizar teletransportes en combate.",

    -- =====================
    -- PRINT MESSAGES: Config Panels
    -- =====================
    ["msg_np_reset"]                    = "Nameplates reiniciadas (recarga recomendada)",
    ["msg_uf_toggle"]                   = "UnitFrames %s (recarga)",
    ["msg_profile_reset"]               = "%s reiniciado",
    ["msg_profile_copied"]              = "Ajustes actuales copiados a '%s'",
    ["msg_profile_deleted"]             = "Perfil eliminado para '%s'",
    ["msg_profile_loaded"]              = "Perfil '%s' cargado — recarga para aplicar",
    ["msg_profile_load_failed"]         = "Error al cargar el perfil '%s'",
    ["msg_profile_created"]             = "Perfil '%s' creado con los ajustes actuales",
    ["msg_profile_name_empty"]          = "Por favor, introduce un nombre de perfil",
    ["msg_profile_saved"]               = "Ajustes guardados en el perfil '%s'",

    -- New profile keys v2.3.0
    ["btn_rename_profile"]              = "Renombrar",
    ["btn_duplicate_profile"]           = "Duplicar",
    ["btn_load_profile"]                = "Cargar",
    ["btn_close"]                       = "Cerrar",
    ["btn_cancel"]                      = "Cancelar",
    ["section_spec_assign"]             = "Perfiles por especialización",
    ["info_spec_assign"]                = "Asigna cada especialización a un perfil con nombre. TomoMod cambiará automáticamente de perfil al cambiar de especialización.",
    ["spec_profile_none"]               = "— Ninguno —",
    ["popup_rename_profile"]            = "|cffffd100TomoModForever|r\n\nNuevo nombre para '%s':",
    ["popup_duplicate_profile"]         = "|cffffd100TomoModForever|r\n\nDuplicar '%s' como:",
    ["msg_profile_renamed"]             = "Perfil '%s' renombrado a '%s'",
    ["msg_profile_duplicated"]          = "Perfil '%s' duplicado como '%s'",
    ["msg_import_as_profile"]           = "Perfil importado como '%s'",
    ["popup_export_title"]              = "Exportar perfil",
    ["popup_export_hint"]               = "Selecciona todo (Ctrl+A) y copia (Ctrl+C)",
    ["popup_import_title"]              = "Importar perfil",
    ["popup_import_hint"]               = "Pega una cadena de exportación de TomoMod, luego haz clic en Importar",
    ["label_import_profile_name"]       = "Guardar como nombre de perfil:",
    ["placeholder_import_profile_name"] = "Nombre del perfil (opcional)...",
    ["msg_profile_name_deleted"]        = "Perfil '%s' eliminado",
    ["msg_export_success"]              = "Cadena de exportación generada — selecciona todo y copia",
    ["msg_import_success"]              = "Ajustes importados con éxito — recargando...",
    ["msg_import_empty"]                = "Nada que importar — pega una cadena primero",
    ["msg_copy_hint"]                   = "Texto seleccionado — pulsa Ctrl+C para copiar",
    ["msg_copy_empty"]                  = "Genera primero una cadena de exportación",
    ["msg_paste_hint"]                  = "Pulsa Ctrl+V para pegar tu cadena de importación",
    ["msg_spec_changed_reload"]         = "Especialización cambiada — cargando perfil...",

    -- =====================
    -- INFO PANEL (Minimap)
    -- =====================
    ["time_server"]                     = "Servidor",
    ["time_local"]                      = "Local",
    ["time_tooltip_title"]              = "Hora (%s - %s)",
    ["time_tooltip_left_click"]         = "|cffffd100Clic izquierdo:|r Calendario",
    ["time_tooltip_right_click"]        = "|cffffd100Clic derecho:|r Servidor / Local",
    ["time_tooltip_shift_right"]        = "|cffffd100Shift + Clic derecho:|r 12h / 24h",
    ["time_format_msg"]                 = "Formato: %s",
    ["time_mode_msg"]                   = "Hora: %s",

    -- =====================
    -- ENABLED / DISABLED (generic)
    -- =====================
    ["enabled"]                         = "Activado",
    ["disabled"]                        = "Desactivado",

    -- Static Popups
    ["popup_reset_text"]                = "|cffffd100TomoModForever|r\n\n¿Reiniciar TODOS los ajustes?\nEsto recargará tu interfaz.",
    ["popup_confirm"]                   = "Confirmar",
    ["popup_cancel"]                    = "Cancelar",
    ["popup_import_text"]               = "|cffffd100TomoModForever|r\n\n¿Importar ajustes?\nEsto SOBRESCRIBIRÁ todos tus ajustes actuales y recargará la interfaz.",
    ["popup_profile_reload"]            = "|cffffd100TomoModForever|r\n\nModo de perfil cambiado.\n¿Recargar interfaz para aplicar?",
    ["popup_delete_profile"]            = "|cffffd100TomoModForever|r\n\n¿Eliminar perfil '%s'?\nEsta acción no se puede deshacer.",

    -- FPS element
    ["label_fps"]                       = "FPS",

    -- =====================
    -- BOSS FRAMES
    -- =====================
    ["tab_boss"]                        = "Jefe",
    ["section_boss_frames"]             = "Barras de jefe",
    ["opt_boss_enable"]                 = "Activar barras de jefe",
    ["opt_boss_height"]                 = "Altura de barras",
    ["opt_boss_spacing"]                = "Espacio entre barras",
    ["info_boss_drag"]                  = "Desbloquea (/tmf uf) para mover. Arrastra Jefe 1 para reposicionar las 5 barras juntas.",
    ["info_boss_colors"]                = "Los colores de barra usan colores de clasificación de Nameplate (Jefe = rojo, Mini-jefe = morado).",
    ["msg_boss_initialized"]            = "Barras de jefe cargadas.",

    -- =====================
    -- SOUND / LUST DETECTION
    -- =====================
    ["cat_sound"]                       = "Sonido",
    ["section_sound_general"]           = "Sonido de Bloodlust",
        ["info_sound_desc"]                 = "Reproduce un sonido personalizado cuando se detecta un efecto de Bloodlust. La deteccion verifica directamente los buffs de Lust y los debuffs Sated/Exhaustion.",
    ["opt_sound_enable"]                = "Activar detección de Bloodlust",
    ["sublabel_sound_choice"]           = "Sonido y canal",
    ["opt_sound_file"]                  = "Sonido a reproducir",
    ["opt_sound_channel"]               = "Canal de audio",
    ["opt_sound_volume"]                = "Volumen del canal de audio",
    ["info_sound_volume"]               = "Cambia el volumen global del canal seleccionado en los ajustes de audio de WoW.",
    ["btn_sound_preview"]               = ">> Escuchar sonido",
    ["btn_sound_stop"]                  = "■  Detener",
    ["opt_sound_force"]                 = "Forzar sonido aunque el juego esté silenciado",
    ["opt_sound_chat"]                  = "Mostrar mensajes en chat",
    ["opt_sound_debug"]                 = "Mode debug",

    -- =====================
    -- BAG & MICRO MENU
    -- =====================
    ["tab_qol_bag_micro"]               = "Bolsa y menú",
    ["section_bag_micro"]               = "Barra de bolsa y micro menú",
    ["info_bag_micro"]                  = "Elige si mostrar siempre o revelar al pasar el ratón.",
    ["sublabel_bag_bar"]                = "— Barra de bolsa —",
    ["sublabel_micro_menu"]             = "— Micro menú —",
    ["opt_bag_bar_mode"]                = "Barra de bolsa",
    ["opt_micro_menu_mode"]             = "Micro menú",
    ["mode_show"]                       = "Siempre visible",
    ["mode_hover"]                      = "Mostrar al pasar el ratón",

    -- =====================
    -- MICRO BAR
    -- =====================
    ["microbar_btn_character"]          = "Personaje",
    ["microbar_btn_spells"]             = "Talentos y grimorio",
    ["microbar_btn_profession"]         = "Profesiones",
    ["microbar_btn_achievement"]        = "Logros",
    ["microbar_btn_quest"]              = "Registro de misiones",
    ["microbar_btn_guild"]              = "Hermandad y comunidades",
    ["microbar_btn_lfd"]                = "Buscador de grupos",
    ["microbar_btn_collections"]        = "Colecciones",
    ["microbar_btn_ej"]                 = "Guía de aventura",
    ["microbar_btn_housing"]            = "Vivienda",
    ["microbar_btn_social"]             = "Social",
    ["microbar_btn_store"]              = "Tienda",
    ["microbar_btn_bags"]               = "Bolsas",
    ["microbar_btn_mainmenu"]           = "Menú del juego",
    ["microbar_tt_memory"]              = "Memoria de los addons",
    ["microbar_tt_total"]               = "Total",
    ["mover_microbar"]                  = "Microbarra",
    ["section_microbar"]                = "Microbarra",
    ["info_microbar"]                   = "Sustituye el micromenú de Blizzard por una barra que puedes dimensionar, reordenar y colocar libremente. Cada botón reenvía su clic al botón original, así que todo sigue funcionando en combate. Los iconos se leen directamente de los recursos del juego. Mientras esté activa, el ajuste Micromenú de arriba deja de aplicarse.",
    ["opt_microbar_enable"]             = "Activar la microbarra",
    ["opt_microbar_lfg_eye"]                = "Ojo del buscador de grupos",
    ["opt_microbar_lfg_eye_scale"]          = "Tamaño del ojo",
    ["info_microbar_lfg_eye"]               = "Separado del micromenú de Blizzard para sobrevivir a su ocultación. Colócalo en modo de disposición.",
    ["opt_microbar_hide_native"]        = "Ocultar el micromenú de Blizzard",
    ["opt_microbar_buttons"]            = "Botones y orden",
    ["opt_microbar_orientation"]        = "Orientación",
    ["opt_microbar_per_line"]           = "Botones por línea (0 = una sola línea)",
    ["opt_microbar_icon_size"]          = "Tamaño de los iconos",
    ["opt_microbar_spacing"]            = "Espaciado",
    ["opt_microbar_scale"]              = "Escala",
    ["opt_microbar_alpha"]              = "Opacidad",
    ["opt_microbar_fade_mode"]          = "Visibilidad",
    ["opt_microbar_fade_alpha"]         = "Opacidad atenuada",
    ["opt_microbar_color_mode"]         = "Color de los iconos",
    ["opt_microbar_color"]              = "Color personalizado",
    ["opt_microbar_desaturate"]         = "Desaturar los iconos",
    ["opt_microbar_hover_zoom"]         = "Ampliar el icono al pasar el ratón",
    ["opt_microbar_memory_tooltip"]     = "Mostrar la memoria de los addons en el botón de menú",
    ["microbar_orient_h"]               = "Horizontal",
    ["microbar_orient_v"]               = "Vertical",
    ["microbar_fade_always"]            = "Siempre visible",
    ["microbar_fade_hover"]             = "Mostrar al pasar el ratón",
    ["microbar_fade_hovercombat"]       = "Al pasar el ratón, siempre en combate",
    ["microbar_color_class"]            = "Clase",
    ["microbar_color_custom"]           = "Personalizado",
    ["microbar_color_native"]           = "Original",
    ["btn_microbar_place"]              = "Colocar la barra",
    ["btn_microbar_reset_pos"]          = "Restablecer la posición",
    ["section_microbar_states"]         = "Microbarra — Estados nativos",
    ["info_microbar_states"]            = "Los botones originales siguen funcionando bajo la barra, así que sus avisos, estados atenuados y atajos continúan activos. Estas opciones los reflejan en tus propios botones.",
    ["opt_microbar_alert_style"]        = "Destello de aviso",
    ["opt_microbar_alert_color"]        = "Color del aviso",
    ["opt_microbar_dim_disabled"]       = "Atenuar los botones no disponibles",
    ["opt_microbar_disabled_alpha"]     = "Opacidad atenuada",
    ["opt_microbar_show_keybind"]       = "Mostrar los atajos en los iconos",
    ["opt_microbar_keybind_size"]       = "Tamaño del texto de los atajos",
    ["microbar_glow_none"]              = "Ninguno",
    ["microbar_glow_pixel"]             = "Destello de píxeles",
    ["microbar_glow_autocast"]          = "Brillo de autolanzamiento",
    ["microbar_glow_button"]            = "Destello de botón de acción",
    ["microbar_glow_proc"]              = "Destello de proc",

    -- =====================
    -- CHARACTER SKIN
    -- =====================
    ["tab_qol_char_skin"]               = "Skin de personaje",
    ["section_char_skin"]               = "Skin de hoja de personaje",
    ["info_char_skin_desc"]             = "Aplica el tema oscuro de TomoMod a la hoja de personaje, reputación, monedas y ventana de inspección.",
    ["opt_char_skin_enable"]            = "Activar skin de personaje",
    ["opt_char_skin_character"]         = "Skin Personaje / Reputación / Monedas",
    ["opt_char_skin_inspect"]           = "Skin ventana de inspección",
    ["opt_char_skin_inspect_iteminfo"]  = "Mostrar nivel de objeto, encantamientos y gemas al inspeccionar",
    ["opt_char_skin_iteminfo"]          = "Mostrar info de objeto en huecos",
    ["opt_char_skin_gems"]              = "Mostrar gemas en los huecos",
    ["opt_char_skin_midnight"]          = "Encantamientos Midnight (Cabeza/Hombros en vez de Muñequeras/Capa)",
    ["opt_char_skin_scale"]             = "Escala de ventana",
    ["msg_char_skin_reload"]            = "Skin de personaje: /reload para aplicar cambios.",

    -- =====================
    -- LAYOUT / MOVERS SYSTEM
    -- =====================
    ["btn_layout"]                      = "EditMode",
    ["btn_layout_tooltip"]              = "EditMode: desbloquea todos los elementos para moverlos.",
    ["btn_reload_ui"]                   = "Recargar interfaz",
    ["layout_mode_title"]               = "TomoMod — EditMode",
    ["layout_mode_hint"]                = "Arrastra los elementos para reposicionar — haz clic en Bloquear cuando termines",
    ["layout_btn_lock"]                 = "Bloquear",
    ["layout_btn_reload"]               = "RL",
    ["layout_btn_gui"]                  = "GUI",
    ["grid_dimmed"]                    = "Cuadrícula",
    ["grid_bright"]                    = "Cuadrícula +",
    ["grid_disabled"]                  = "Cuadrícula OFF",
    ["layout_unlocked"]                 = "EditMode ACTIVO — arrastra los elementos. Haz clic en Bloquear o /tmf layout cuando termines.",
    ["layout_snap_on"]                   = "Imán: SÍ",
    ["layout_snap_off"]                  = "Imán: NO",
    ["layout_nudger_hint"]               = "Haz clic o arrastra un elemento para abrir TomoLayout. Mayús: colocar sin imán.",
    ["layout_locked"]                   = "EditMode DESACTIVADO — posiciones guardadas.",
    ["msg_help_layout"]                 = "Alternar EditMode (mover todos los elementos UI)",
    ["mover_unitframes"]                = "Unit Frames",
    ["mover_resources"]                 = "Barras de recursos",
    ["mover_skyriding"]                 = "Barra de Skyriding",
    ["mover_levelingbar"]               = "Barra XP / Experiencia",
    ["mover_anchors"]                   = "Anclas de alertas y botín",
    ["mover_cotank"]                    = "Rastreador de Co-Tank",
    ["mover_repbar"]                    = "Barra de reputación",
    ["mover_castbar"]                   = "Barra de lanzamiento (jugador)",
    ["mover_mythictracker"]             = "Tracker M+",
    ["mover_chatframe"]                 = "Ventana de chat",

    -- =====================
    -- COMBAT TEXT
    -- =====================
    ["sublabel_combat_text"]             = "— Texto de combate —",
    ["opt_combat_text_enable"]           = "Activar texto de combate",
    ["opt_combat_text_offset_x"]         = "Desplazamiento X",
    ["opt_combat_text_offset_y"]         = "Desplazamiento Y",

    -- =====================
    -- PREY TRACKER
    -- =====================
    ["sublabel_prey_tracker"]            = "— Rastreador de Presa —",
    ["opt_prey_tracker_enable"]          = "Activar Rastreador de Presa",
    ["opt_prey_tracker_width"]           = "Ancho",
    ["opt_prey_tracker_font"]            = "Tamaño de fuente",
    ["info_prey_tracker"]                = "Función exclusiva de Midnight. Muestra una barra de progreso móvil durante una caza de Presa activa. Posiciónela mediante /tmf layout.",

    -- =====================
    -- SKINS (Chat)
    -- =====================
    ["tab_qol_skins"]                    = "Skins",
    ["section_skins"]                    = "Skins de interfaz",
    ["info_skins_desc"]                  = "Aplica el tema oscuro de TomoMod a varios elementos de la interfaz de Blizzard. Puede necesitar /reload para revertir.",
    ["sublabel_chat_skin"]               = "— Ventana de chat —",
    ["opt_chat_skin_enable"]             = "Skin de la ventana de chat",
    ["opt_chat_skin_style"]              = "Estilo del skin",
    ["opt_chat_skin_style_tui"]          = "TUI (Barra lateral + Ventana)",
    ["opt_chat_skin_style_classic"]      = "Clásico (Enmarcado)",
    ["opt_chat_skin_style_glass"]        = "Cristal (Esmerilado)",
    ["opt_chat_skin_style_minimal"]      = "Mínimo (Sin bordes)",
    ["opt_chat_skin_bg_alpha"]           = "Opacidad del marco",
    ["opt_chat_message_bg_alpha"]        = "Opacidad del área de mensajes",
    ["opt_chat_skin_font_size"]          = "Tamaño de fuente del chat",
    ["opt_chat_skin_fade"]               = "Fade chat when inactive",
    ["opt_chat_skin_short_channels"]     = "Short channel names (G, P, R…)",
    ["opt_chat_skin_timestamp"]          = "Show timestamps",
    ["opt_chat_skin_url"]                = "Clickable URLs",
    ["opt_chat_skin_emoji"]              = "Replace text emoticons with emoji",
    ["opt_chat_skin_class_colors"]       = "Class-color player names in chat",
    ["opt_chat_copy_button"]             = "Botón de copia en la ventana de chat",
    ["opt_chat_copy_button_always"]      = "Siempre visible",
    ["opt_chat_copy_button_hover"]       = "Al pasar el ratón",
    ["opt_chat_copy_button_hidden"]      = "Oculto",
    ["chat_copy_title"]                  = "Copiar texto del chat",
    ["chat_copy_hint"]                   = "Selecciona todo (Ctrl+A) y copia (Ctrl+C)",
    ["chat_copy_select_all"]             = "Seleccionar todo",
    ["chat_copy_close"]                  = "Cerrar",
    ["chat_copy_empty"]                  = "No hay mensajes copiables en esta ventana.",
    ["chat_copy_url_title"]              = "Pulsa Ctrl+C para copiar",
    ["opt_chat_skin_history"]               = "Restaurar el historial del chat al conectar",
    ["chat_history_section"]                = "Historial del chat",
    ["opt_chat_skin_history_info"]          = "Desmarcar detiene el registro Y borra lo ya almacenado. El historial se guarda para toda la cuenta, así que lo comparten todos los personajes.",
    ["opt_chat_history_max_age"]            = "Conservar los mensajes durante",
    ["opt_chat_history_age_1h"]             = "1 hora",
    ["opt_chat_history_age_6h"]             = "6 horas",
    ["opt_chat_history_age_24h"]            = "24 horas",
    ["opt_chat_history_age_3d"]             = "3 días",
    ["opt_chat_history_age_unlimited"]      = "Sin límite",
    ["opt_chat_history_max_lines"]          = "Líneas máximas conservadas",
    ["opt_chat_history_delay"]              = "Retraso antes de restaurar",
    ["opt_chat_history_delay_info"]         = "Esperar unos segundos permite que los mensajes de carga de addons y los errores de Lua aparezcan primero, en vez de quedar enterrados bajo el historial.",
    ["opt_chat_history_separator"]          = "Mostrar una marca de sesión",
    ["opt_chat_history_separator_info"]     = "Muestra una línea tras el historial restaurado: todo lo que aparezca debajo es claramente de la sesión actual.",
    ["chat_history_separator_text"]         = "Sesión actual",
    ["sublabel_chat_history_channels"]      = "Canales a restaurar",
    ["opt_chat_history_ch_whisper"]         = "Susurros",
    ["opt_chat_history_ch_guild"]           = "Hermandad",
    ["opt_chat_history_ch_officer"]         = "Oficial",
    ["opt_chat_history_ch_party"]           = "Grupo",
    ["opt_chat_history_ch_raid"]            = "Banda",
    ["opt_chat_history_ch_instance"]        = "Instancia",
    ["opt_chat_history_ch_channel"]         = "Canales",
    ["opt_chat_history_ch_say"]             = "Decir",
    ["opt_chat_history_ch_yell"]            = "Gritar",
    ["opt_chat_history_ch_emote"]           = "Emotes",
    ["btn_chat_history_clear"]              = "Borrar el historial ahora",
    ["popup_chat_history_clear"]            = "¿Eliminar todos los mensajes de chat almacenados? Esta acción no se puede deshacer.",
    ["msg_chat_history_cleared"]            = "Historial del chat borrado (%d mensaje(s)).",
    ["opt_chat_skin_copy_lines"]         = "Show copy icon per message",

    -- Buff Skin
    ["sublabel_buff_skin"]               = "— Skin de Buffs / Debuffs —",

    -- Game Menu Skin
    ["sublabel_game_menu_skin"]          = "— Menú de juego (Escape) —",
    ["opt_game_menu_skin_enable"]        = "Skinear menú de juego",
    ["info_game_menu_skin_reload"]       = "Se necesita /reload para revertir este skin.",
    ["msg_chat_skin_enabled"]            = "Skin del chat activado",
    ["msg_chat_skin_disabled"]           = "Skin del chat desactivado (reload para revertir)",
    ["sublabel_mail_skin"]               = "— Correo —",
    ["opt_mail_skin_enable"]             = "Skin del correo",
    ["msg_mail_skin_enabled"]            = "Skin del correo activado",
    ["msg_mail_skin_disabled"]           = "Skin del correo desactivado (reload para revertir)",

    -- =====================
    -- WORLD QUEST TAB
    -- =====================
    ["tab_qol_world_quests"]             = "Misiones de mundo",
    ["section_wq_tab"]                   = "Pestaña de misiones de mundo",
    ["info_wq_tab_desc"]                 = "Añade una pestaña de misiones de mundo al diario con búsqueda, ordenación, recompensas, zona y tiempo restante. Haz clic para seguir una misión y mostrar su zona en el mapa.",
    ["opt_wq_enable"]                    = "Activar pestaña de misiones de mundo",
    ["opt_wq_auto_show"]                 = "Abrir esta pestaña por defecto con el diario de misiones",
    ["opt_wq_max_quests"]                = "Máx. misiones mostradas (0 = ilimitado)",
    ["opt_wq_min_time"]                  = "Tiempo restante mín. (minutos, 0 = todas)",
    ["section_wq_filters"]               = "Filtros de recompensa",
    ["opt_wq_filter_gold"]               = "Mostrar recompensas de oro",
    ["opt_wq_filter_gear"]               = "Mostrar recompensas de equipo",
    ["opt_wq_filter_rep"]                = "Mostrar recompensas de reputación",
    ["opt_wq_filter_currency"]           = "Mostrar recompensas de moneda",
    ["opt_wq_filter_anima"]              = "Mostrar recompensas de ánima",
    ["opt_wq_filter_pet"]                = "Mostrar recompensas de mascota",
    ["opt_wq_filter_other"]              = "Mostrar otras recompensas",
    ["wq_tab_title"]                     = "MM Lista",
    ["wq_panel_title"]                   = "Misiones de mundo",
    ["wq_col_name"]                      = "Nombre",
    ["wq_col_zone"]                      = "Zona",
    ["wq_col_reward"]                    = "Recompensa",
    ["wq_col_time"]                      = "Tiempo",
    ["wq_zone"]                          = "Zona",
    ["wq_faction"]                       = "Facción",
    ["wq_reward"]                        = "Recompensa",
    ["wq_time_left"]                     = "Tiempo restante",
    ["wq_elite"]                         = "Misión de mundo élite",
    ["wq_sort_time"]                     = "Tiempo",
    ["wq_sort_zone"]                     = "Zona",
    ["wq_sort_name"]                     = "Nombre",
    ["wq_sort_reward"]                   = "Recompensa",
    ["wq_sort_faction"]                  = "Facción",
    ["wq_status_count"]                  = "Mostrando %d / %d misiones",
    ["wq_empty"]                         = "Ninguna misión de mundo coincide con estos filtros.",
    ["wq_expired"]                       = "Caducada",
    ["wq_click_hint"]                    = "Clic: seguir y mostrar en el mapa",
    ["wq_refresh_short"]                 = "A",
    ["wq_reward_gear"]                   = "Equipo",
    ["wq_reward_reputation"]             = "Reputación",
    ["wq_reward_pet"]                    = "Mascota",
    ["wq_reward_other"]                  = "Otro",

    -- Profession Helper
    ["tab_qol_prof_helper"]              = "Profesiones",
    ["section_prof_helper"]              = "Asistente de profesiones",
    ["info_prof_helper_desc"]            = "Desencantar, moler y prospectar objetos en lote con una interfaz visual.",
    ["opt_prof_helper_enable"]           = "Activar asistente de profesiones",
    ["sublabel_prof_de_filters"]         = "— Filtros de calidad de desencantamiento —",
    ["opt_prof_filter_green"]            = "Incluir objetos Poco común (Verdes)",
    ["opt_prof_filter_blue"]             = "Incluir objetos Raros (Azules)",
    ["opt_prof_filter_epic"]             = "Incluir objetos Épicos (Morados)",
    ["btn_prof_open_helper"]             = "Abrir asistente de profesiones",
    ["ph_title"]                         = "Asistente de profesiones",
    ["ph_tab_disenchant"]                = "Desencantar",
    ["ph_filter_quality"]                = "Calidad:",
    ["ph_quality_green"]                 = "Verde",
    ["ph_quality_blue"]                  = "Azul",
    ["ph_quality_epic"]                  = "Épico",
    ["ph_select_all"]                    = "Seleccionar todo",
    ["ph_deselect_all"]                  = "Deseleccionar todo",
    ["ph_btn_process"]                   = "Procesar",
    ["ph_btn_click_process"]             = "Clic para procesar",
    ["ph_btn_stop"]                      = "Detener",
    ["ph_status_idle"]                   = "Haz clic en Procesar",
    ["ph_status_processing"]             = "Procesando %d/%d: %s",
    ["ph_status_done"]                   = "¡Listo! Todos los objetos procesados.",
    ["ph_item_count"]                    = "%d objetos disponibles",
    ["ph_ilvl"]                          = "iLvl %d",

    -- ── Class Reminder ──────────────────────────────────────────
    ["tab_qol_class_reminder"]           = "Recordatorio de clase",
    ["section_class_reminder"]           = "Recordatorio de buff / forma de clase",
    ["info_class_reminder"]              = "Muestra un icono por cada aumento, forma, postura o aura de clase que te falte. Clic izquierdo para lanzarlo, clic central para ocultarlo hasta la próxima pantalla de carga.",
    ["opt_class_reminder_enable"]        = "Activar recordatorio de clase",
    ["opt_class_reminder_scale"]         = "Escala de la fila",
    ["opt_class_reminder_color"]         = "Color de etiqueta",
    ["sublabel_class_reminder_pos"]      = "— Posición —",
    ["info_class_reminder_clicks"]       = "El clic izquierdo lanza el hechizo que falta (solo fuera de combate). El clic central oculta ese aviso hasta la próxima pantalla de carga.",
    ["info_class_reminder_mover"]        = "Mueve la fila de iconos desde el panel de Movimiento, o restáurala al centro de la pantalla.",
    ["sublabel_class_reminder_icons"]    = "— Iconos —",
    ["opt_class_reminder_icon_size"]     = "Tamaño de icono",
    ["opt_class_reminder_spacing"]       = "Espaciado de iconos",
    ["opt_class_reminder_opacity"]       = "Opacidad",
    ["sublabel_class_reminder_text"]     = "— Etiqueta —",
    ["opt_class_reminder_show_text"]     = "Mostrar etiqueta bajo los iconos",
    ["opt_class_reminder_text_size"]     = "Tamaño de etiqueta",
    ["sublabel_class_reminder_glow"]     = "— Resplandor —",
    ["opt_class_reminder_glow"]          = "Tipo de resplandor",
    ["opt_class_reminder_glow_color"]    = "Color del resplandor",
    ["cr_glow_none"]                     = "Ninguno",
    ["cr_glow_pixel"]                    = "Resplandor de píxeles",
    ["cr_glow_autocast"]                 = "Destello automático",
    ["cr_glow_button"]                   = "Resplandor de botón",
    ["cr_glow_proc"]                     = "Resplandor de proc",
    ["info_class_reminder_preview_hint"] = "Haz clic en un icono para ir a su interruptor, en su etiqueta para las opciones de etiqueta, o en el área vacía para el tamaño.",
    ["info_class_reminder_coverage"]     = "Desmarca aquello sobre lo que no quieras recibir avisos. En el juego solo se comprueba tu propia clase.",
    ["cr_lethal_poison"]                 = "Veneno letal",
    ["cr_nonlethal_poison"]              = "Veneno no letal",
    ["cr_flametongue"]                   = "Arma de lengua de fuego",
    ["cr_windfury"]                      = "Arma de furia del viento",
    ["cr_earthliving"]                   = "Arma de tierra viva",
    ["cr_tidecaller"]                    = "Guardia del invocamareas",
    ["cr_thunderstrike"]                 = "Custodia de golpe de trueno",
    ["cr_earth_shield_self"]             = "Escudo de tierra (propio)",
    ["cr_orbit_shield"]                  = "Escudo de relámpagos / de agua",
    ["cr_shield"]                        = "Escudo",
    ["cr_paladin_rite"]                  = "Rito",
    ["sublabel_class_reminder_context"]  = "— Contexto —",
    ["opt_class_reminder_show_in"]       = "Mostrar avisos",
    ["cr_show_always"]                   = "En todas partes",
    ["cr_show_instances"]                = "Solo en mazmorras y bandas",
    ["cr_show_group"]                    = "Solo en grupo",
    ["opt_class_reminder_hide_resting"]  = "Ocultar en ciudades y posadas",
    ["opt_class_reminder_others_missing"] = "Avisar también cuando a un miembro del grupo le falta un aumento",
    ["info_class_reminder_others"]       = "Solo se cuentan los miembros a rango que se benefician del aumento, y solo fuera de combate: las auras de otro jugador no se pueden leer en combate.",

    -- Buff / Form names
    ["cr_fortitude"]                     = "Palabra de poder: Entereza",
    ["cr_shadowform"]                    = "Forma de las Sombras",
    ["cr_arcane_intellect"]              = "Intelecto Arcano",
    ["cr_skyfury"]                       = "Furia celeste",
    ["cr_mark_of_the_wild"]              = "Marca de lo Salvaje",
    ["cr_cat_form"]                      = "Forma de felino",
    ["cr_bear_form"]                     = "Forma de oso",
    ["cr_moonkin_form"]                  = "Forma de lechúcico lunar",
    ["cr_battle_shout"]                  = "Grito de batalla",
    ["cr_battle_stance"]                 = "Postura de batalla",
    ["cr_berserker_stance"]              = "Postura de berserker",
    ["cr_defensive_stance"]              = "Postura defensiva",
    ["cr_aura"]                          = "Aura",
    ["cr_blessing_bronze"]               = "Bendición del Bronce",
    ["cr_preview_sample"]                = "Ejemplo: buff de clase ausente",

    -- =====================
    -- MYTHIC TRACKER (TomoMythic integration)
    -- =====================
    ["tmt_cmd_usage"]               = "|cFF55B400/tmt|r : configuración  |  |cFF55B400unlock|r : mover  |  |cFF55B400lock|r : bloquear  |  |cFF55B400reset|r : reiniciar posición  |  |cFF55B400preview|r : vista previa  |  |cFF55B400key|r : llaves del grupo  |  |cFF55B400kr|r : ruleta  |  |cFF55B400keysync|r : diagnóstico de sincronización",
    ["tmt_unlock_msg"]              = "|cffffd100TomoModForever|r M+ Tracker: Marco desbloqueado \226\128\148 arrastra para reposicionar.",
    ["tmt_lock_msg"]                = "|cffffd100TomoModForever|r M+ Tracker: Marco bloqueado.",
    ["tmt_reset_msg"]               = "|cffffd100TomoModForever|r M+ Tracker: Posición reiniciada.",
    ["tmt_unknown_cmd"]             = "|cffffd100TomoModForever|r M+ Tracker: Comando desconocido.",
    ["tmt_key_level"]               = "+%d",
    ["tmt_dungeon_unknown"]         = "Mítico+",
    ["tmt_overtime"]                = "TIEMPO AGOTADO",
    ["tmt_completed_on_time"]       = "COMPLETADO",
    ["tmt_completed_depleted"]      = "FRACASADO",
    ["tmt_forces"]                  = "FUERZAS",
    ["tmt_forces_done"]             = "COMPLETO",
    ["tmt_forces_pct"]              = "%.1f%%",
    ["tmt_forces_count"]            = "%d / %d",
    ["tmt_forces_remaining"]        = "%d restantes",
    ["tmt_deaths"]                  = "Muertes",
    ["tmt_time_lost"]               = "Tiempo perdido: %s",
    ["tmt_cfg_preset"]              = "Estilo",
    ["tmt_cfg_preset_panel"]        = "Panel",
    ["tmt_cfg_preset_hud"]          = "HUD",
    ["tmt_cfg_show_background"]     = "Fondo del panel",
    ["tmt_cfg_show_header"]         = "Bloque de cabecera",
    ["tmt_cfg_show_dungeon"]        = "Nombre de la mazmorra",
    ["tmt_cfg_objective_style"]     = "Lista de jefes",
    ["tmt_cfg_objective_rows"]      = "Filas",
    ["tmt_cfg_objective_text"]      = "Texto",
    ["tmt_cfg_font_scale"]          = "Tamaño del texto",
    ["tmt_cfg_preset_minimal"]        = "Minimal",
    ["tmt_cfg_objective_none"]        = "Oculta",
    ["tmt_cfg_timer_layout"]          = "Diseño del cronómetro",
    ["tmt_cfg_timer_stacked"]         = "Dos líneas",
    ["tmt_cfg_timer_inline"]          = "Una línea",
    ["tmt_cfg_segment_colors"]        = "Colores de segmento",
    ["tmt_cfg_segment_palier"]        = "Por nivel",
    ["tmt_cfg_segment_brand"]         = "Marca",
    ["tmt_cfg_splits"]                = "Comparar con el mejor tiempo",
    ["tmt_cfg_checkpoints"]           = "Puntos de control de fuerzas",
    ["tmt_cfg_clear_splits"]          = "Borrar tiempos registrados",
    ["tmt_splits_cleared"]            = "|cffffd100TomoModForever|r M+ Tracker: tiempos registrados borrados.",
    ["tmt_cds_reload_text"]           = "Cooldown Studio permanece cargado hasta recargar la interfaz. Recargar ahora lo libera y elimina el taint de esta sesi\195\179n.",
    ["tmt_cds_reload_now"]            = "Recargar",
    ["tmt_cds_reload_later"]          = "M\195\161s tarde",
    ["tmt_cfg_cds_safety_reload"]     = "Recargar la interfaz al cerrar el Studio",
    ["tmt_cfg_title"]               = "Mythic",
    ["tmt_cfg_panel_enable"]         = "Activar tracker M+",
    ["tmt_cfg_show_timer"]          = "Mostrar barra de tiempo",
    ["tmt_cfg_show_forces"]         = "Mostrar fuerzas enemigas",
    ["tmt_cfg_show_bosses"]         = "Mostrar temporizadores de jefe",
    ["tmt_cfg_hide_blizzard"]       = "Ocultar rastreador de Blizzard",
    ["tmt_cfg_lock"]                = "Bloquear marco",
    ["tmt_cfg_scale"]               = "Escala",
    ["tmt_cfg_alpha"]               = "Opacidad de fondo",
    ["tmt_cfg_reset_pos"]           = "Reiniciar posición",
    ["tmt_cfg_preview"]             = "Vista previa",
    ["tmt_cfg_section_display"]     = "Pantalla",
    ["tmt_cfg_section_frame"]       = "Marco",
    ["tmt_cfg_section_actions"]     = "Acciones",
    ["tmt_key_not_available"]       = "no disponible.",
    ["tmt_key_not_in_group"]        = "No estás en un grupo.",
    ["tmt_key_none_found"]          = "No se encontraron piedras angulares.",
    ["tmt_kr_spin"]                 = "|TInterface\\Icons\\INV_Misc_Dice_02:14|t  ¡Girar!",
    ["tmt_preview_active"]          = "|cffffd100TomoModForever|r M+ Tracker: Vista previa activa \226\128\148 |cFF55B400/tmt lock|r para bloquear.",

    -- MythicHub
    ["mhub_title"]                  = "Puntuaci\195\179n M\195\173tica+",
    ["mhub_col_dungeon"]            = "Mazmorra",
    ["mhub_col_level"]              = "Nivel",
    ["mhub_col_rating"]             = "Puntuaci\195\179n",
    ["mhub_col_best"]               = "Mejor",
    ["mhub_tp_click"]               = "Clic para teletransportarte",
    ["mhub_tp_not_available"]        = "Teletransporte no aprendido",
    ["mhub_tp_not_learned"]          = "|cffffd100TomoModForever|r: Hechizo de teletransporte no aprendido.",
    ["mhub_vault_title"]            = "Gran C\195\161mara",
    ["mhub_vault_dungeons"]         = "Mazmorras",
    ["mhub_vault_raids"]            = "Bandas",
    ["mhub_vault_world"]            = "Profundidades",
    ["mhub_vault_ilvl"]             = "Nivel de objeto",
    ["mhub_vault_locked"]           = "Bloqueado",
    ["mhub_vault_claim"]            = "Vuelve a la Gran C\195\161mara para reclamar tu recompensa",

    -- ══════════════════════════════════════════════════════════
    -- INSTALLER
    -- ══════════════════════════════════════════════════════════

    -- Navigation
    ["ins_header_title"]             = "|cffffd100Tomo|r|cfff2ebdbMod|r |cffc9a252Forever|r  \226\128\148  Asistente de configuraci\195\179n",
    ["ins_step_counter"]             = "Paso %d / %d",
    ["ins_btn_prev"]                 = "|TInterface\\BUTTONS\\UI-SpellbookIcon-PrevPage:0|t Anterior",
    ["ins_btn_next"]                 = "Siguiente |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t",
    ["ins_btn_finish"]               = "Finalizar |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t",
    ["ins_btn_skip"]                 = "Omitir instalaci\195\179n",

    -- Step 1: Welcome
    ["ins_step1_title"]              = "Bienvenido a TomoMod",
    ["ins_subtitle"]                 = "Suite de interfaz y QOL para The War Within",
    ["ins_welcome_desc"]             = "Este asistente te guiar\195\161 en |cffffd10016 pasos|r para configurar TomoMod seg\195\186n\ntus preferencias: unit frames, party frames, castbars, nameplates, barras de acci\195\179n,\nrecursos, skins, sonido, Mythic+, QOL, optimizaciones y SkyRide.\n\nTodas estas opciones pueden cambiarse en cualquier momento con |cffffd100/tmf|r.",

    -- Step 2: Profile
    ["ins_step2_title"]              = "Perfil de juego",
    ["ins_profile_info"]             = "Crea un perfil con nombre para guardar tu configuraci\195\179n.",
    ["ins_profile_section"]          = "Nombre del perfil",
    ["ins_profile_placeholder"]      = "Mi perfil",
    ["ins_profile_create"]           = "Crear perfil",
    ["ins_profile_created"]          = "Perfil creado: ",
    ["ins_spec_section"]             = "Asignaci\195\179n de especializaci\195\179n",
    ["ins_spec_info"]                = "Puedes asignar este perfil a tus especializaciones desde el panel Perfiles (/tmf).\nCada especializaci\195\179n puede usar una configuraci\195\179n diferente.",

    -- Step 3: Visual Skins
    ["ins_step3_title"]              = "Skins visuales",
    ["ins_skins_info"]               = "Personaliza la interfaz de Blizzard con el tema oscuro de TomoMod.",
    ["ins_skins_section"]            = "Skins disponibles",
    ["ins_skin_gamemenu"]            = "Skin del men\195\186 de juego (Escape)",
    ["ins_skin_actionbar"]           = "Skin de botones de barra de acci\195\179n",
    ["ins_skin_chat"]                = "Skin del chat",
    ["ins_skin_character"]           = "Skin de la hoja de personaje",
    ["ins_skin_style_section"]       = "Estilo de botones de barra de acci\195\179n",
    ["ins_skin_style"]               = "Estilo visual",

    -- Step 4: Tank Mode
    ["ins_step4_title"]              = "Modo Tank",
    ["ins_tank_info"]                = "En modo tank, las nameplates y UnitFrames muestran\nel estado de amenaza por color para cada enemigo.",
    ["ins_tank_np_section"]          = "Nameplates \226\128\148 Colores de amenaza",
    ["ins_tank_enable_np"]           = "Activar modo tank (nameplates)",
    ["ins_tank_colors_info"]         = "Verde = tienes aggro  \194\183  Naranja = cerca de perderlo  \194\183  Rojo = aggro perdido",
    ["ins_tank_uf_section"]          = "UnitFrames \226\128\148 Indicador de amenaza",
    ["ins_tank_threat_indicator"]    = "Mostrar indicador de amenaza en el objetivo",
    ["ins_tank_threat_text"]         = "Mostrar texto de amenaza % en el objetivo",
    ["ins_tank_cotank_section"]      = "CoTank Tracker",
    ["ins_tank_cotank_enable"]       = "Activar seguimiento del co-tank",
    ["ins_tank_cotank_info"]         = "Muestra la amenaza del segundo tank en instancias.",

    -- Step 5: Nameplates
    ["ins_step5_title"]              = "Nameplates",
    ["ins_np_general"]               = "General",
    ["ins_np_enable"]                = "Activar nameplates de TomoMod",
    ["ins_np_reload_info"]           = "Se necesita un reload para activar/desactivar las nameplates.",
    ["ins_np_display"]               = "Visualizaci\195\179n",
    ["ins_np_class_colors"]          = "Colores de clase",
    ["ins_np_castbar"]               = "Mostrar barra de lanzamiento",
    ["ins_np_health_text"]           = "Mostrar texto de salud (porcentaje)",
    ["ins_np_auras"]                 = "Mostrar auras (debuffs)",
    ["ins_np_role_icons"]            = "Mostrar iconos de rol (mazmorra)",
    ["ins_np_dimensions"]            = "Dimensiones",
    ["ins_np_width"]                 = "Ancho",

    -- Step 6: Action Bars
    ["ins_step6_title"]              = "Barras de acci\195\179n",
    ["ins_ab_system_section"]        = "Action Bar System",
    ["ins_ab_system_info"]           = "TomoMod replaces Blizzard's action bars with custom containers,\npositioning, fade system and display conditions.\nDisable this to fully restore the default Blizzard action bars.",
    ["ins_ab_system_enable"]         = "Enable TomoMod Action Bar system",
    ["ins_ab_system_reload_info"]    = "Requires a /reload to take effect.",
    ["ins_ab_skin_section"]          = "Skin de botones",
    ["ins_ab_enable"]                = "Activar skin en botones de acci\195\179n",
    ["ins_ab_class_color"]           = "Color de borde = color de clase",
    ["ins_ab_shift_reveal"]          = "Mantener Shift para mostrar barras ocultas",
    ["ins_ab_opacity_section"]       = "Opacidad global de barras",
    ["ins_ab_opacity"]               = "Opacidad",
    ["ins_ab_manage_section"]        = "Gesti\195\179n de barras",
    ["ins_ab_manage_info"]           = "Usa el panel Barras de acci\195\179n (/tmf |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Barras de acci\195\179n |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Gesti\195\179n)\npara desbloquear y reposicionar cada barra.",

    -- Step 7: LustSound
    ["ins_step7_title"]              = "Sonido \226\128\148 Hero\195\173smo / Sed de sangre",
    ["ins_sound_info"]               = "Reproduce un sonido personalizado cuando Hero\195\173smo o Sed de sangre\nes lanzado por cualquier miembro del grupo.",
    ["ins_sound_activation"]         = "Activaci\195\179n",
    ["ins_sound_enable"]             = "Activar sonido de lust",
    ["ins_sound_choice"]             = "Selecci\195\179n de sonido",
    ["ins_sound_sound"]              = "Sonido",
    ["ins_sound_channel"]            = "Canal de audio",
    ["ins_sound_default"]            = "Por defecto",
    ["ins_sound_preview_section"]    = "Vista previa",
    ["ins_sound_preview_btn"]        = "|TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Vista previa",

    -- Step 8: Mythic+
    ["ins_step8_title"]              = "Mythic+ \226\128\148 Tracker y Tabla de puntuaci\195\179n",
    ["ins_mplus_tracker_section"]    = "M+ Tracker",
    ["ins_mplus_tracker_info"]       = "Muestra un temporizador, fuerzas, jefes y progreso\nde tu mazmorra Mythic+ en tiempo real.",
    ["ins_mplus_tracker_enable"]     = "Activar M+ Tracker",
    ["ins_mplus_show_timer"]         = "Mostrar temporizador",
    ["ins_mplus_show_forces"]        = "Mostrar fuerzas (%)",
    ["ins_mplus_hide_blizzard"]      = "Ocultar interfaz Blizzard en Mythic+",
    ["ins_mplus_score_section"]      = "TomoScore \226\128\148 Tabla de puntuaci\195\179n",
    ["ins_mplus_score_info"]         = "Muestra puntuaciones personales y de grupo al final de un Mythic+.",
    ["ins_mplus_score_enable"]       = "Activar TomoScore",
    ["ins_mplus_score_auto"]         = "Mostrar autom\195\161ticamente en M+",

    -- Step 9: CVars
    ["ins_step9_title"]              = "Optimizaciones del sistema (CVars)",
    ["ins_cvar_info"]                = "TomoMod puede aplicar un conjunto de CVars de WoW recomendadas\npara mejorar el rendimiento y la capacidad de respuesta.",
    ["ins_cvar_section"]             = "Optimizaciones incluidas",
    ["ins_cvar_opt1"]                = "Reducir el Level of Detail (LOD) innecesario",
    ["ins_cvar_opt2"]                = "Optimizar el frustum culling",
    ["ins_cvar_opt3"]                = "Desactivar el temporal AA excesivo",
    ["ins_cvar_opt4"]                = "Mejorar la capacidad de respuesta de red",
    ["ins_cvar_opt5"]                = "Desactivar animaciones de interfaz innecesarias",
    ["ins_cvar_opt6"]                = "Optimizar el streaming de texturas",
    ["ins_cvar_success"]             = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t  \194\161CVars aplicadas con \195\169xito!",
    ["ins_cvar_apply_btn"]           = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0|t Aplicar todas las CVars",
    ["ins_cvar_applied"]             = "CVars optimizadas aplicadas.",

    -- Step 10: QOL
    ["ins_step10_title"]             = "Calidad de vida (QOL)",
    ["ins_qol_info"]                 = "Activa los m\195\179dulos QOL que desees.\nTodos son accesibles por separado en /tmf |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t QOL.",
    ["ins_qol_auto_section"]         = "Automatizaciones",
    ["ins_qol_auto_repair"]          = "Reparar autom\195\161ticamente en el comerciante",
    ["ins_qol_fast_loot"]            = "Saqueo r\195\161pido (recogida r\195\161pida de objetos)",
    ["ins_qol_skip_cinematics"]      = "Omitir cinem\195\161ticas ya vistas",
    ["ins_qol_hide_talking_head"]    = "Ocultar Talking Head (di\195\161logos de desplazamiento)",
    ["ins_qol_auto_accept"]          = "Aceptar inv. de grupo autom\195\161ticamente (amigos y hermandad)",
    ["ins_qol_tooltip_ids"]          = "Mostrar IDs en tooltips (spell ID, item ID...)",
    ["ins_qol_combat_section"]       = "Combate",
    ["ins_qol_combat_text"]          = "Texto flotante de combate personalizado",
    ["ins_qol_hide_castbar"]         = "Ocultar barra de lanzamiento de Blizzard (usar la de TomoMod)",

    -- Step 11: SkyRide
    ["ins_step11_title"]             = "SkyRide \226\128\148 Barra de cabalgata drac\195\179nica",
    ["ins_skyride_info"]             = "SkyRide muestra una barra de Vigor (6 cargas) y una barra\nde Segundo Aliento (3 cargas) para la cabalgata drac\195\179nica.",
    ["ins_skyride_activation"]       = "Activaci\195\179n",
    ["ins_skyride_enable"]           = "Activar barra SkyRide",
    ["ins_skyride_auto_info"]        = "La barra aparece autom\195\161ticamente en modo de vuelo drac\195\179nico\ny se oculta fuera de \195\169l.",
    ["ins_skyride_dimensions"]       = "Dimensiones",
    ["ins_skyride_width"]            = "Ancho",
    ["ins_skyride_height"]           = "Altura",
    ["ins_skyride_reset_section"]    = "Reiniciar posici\195\179n",
    ["ins_skyride_reset_btn"]        = "Reiniciar posici\195\179n",

    -- Step 12: Done
    ["ins_step12_title"]             = "\194\161Configuraci\195\179n completada!",
    ["ins_done_check"]               = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t  \194\161Todo listo!",
    ["ins_done_recap"]               = "Tu configuraci\195\179n de TomoMod est\195\161 guardada. Algunos recordatorios:\n\n|cffffd100/tmf|r              |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t  Abrir el panel de configuraci\195\179n\n|cffffd100/tmf sr|r           |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t  Desbloquear y mover elementos\n|cffffd100/tmf install|r      |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t  Relanzar este instalador\n\nTodas las opciones configuradas aqu\195\173 pueden cambiarse en cualquier momento\ndesde los paneles correspondientes en la GUI de TomoMod.\n\nSe necesita un |cffffd100reload de la UI|r para aplicar ciertos cambios\n(nameplates, skins, UnitFrames).",
    ["ins_done_reload"]              = "|TInterface\\BUTTONS\\UI-RefreshButton:0|t  Recargar UI",

    -- Step NEW: Unit Frames
    ["ins_uf_title"]                 = "Unit Frames",
    ["ins_uf_info"]                  = "TomoMod reemplaza los marcos de unidad predeterminados de Blizzard (jugador, objetivo, foco, mascota)\ncon marcos modernos y personalizables.",
    ["ins_uf_section"]               = "General",
    ["ins_uf_enable"]                = "Activar UnitFrames de TomoMod",
    ["ins_uf_hide_blizzard"]         = "Ocultar marcos predeterminados de Blizzard",
    ["ins_uf_reload_info"]           = "Se necesita un reload para aplicar cambios a los UnitFrames.",

    -- Step NEW: Party Frames
    ["ins_pf_title"]                 = "Party Frames",
    ["ins_pf_info"]                  = "Marcos de grupo personalizados con iconos de rol, resaltado de disipaci\195\179n\ny seguimiento de cooldowns para juego en grupo.",
    ["ins_pf_section"]               = "General",
    ["ins_pf_enable"]                = "Activar Party Frames de TomoMod",
    ["ins_pf_hide_blizzard"]         = "Ocultar Party Frames de Blizzard",
    ["ins_pf_cd_section"]            = "Rastreadores de cooldown",
    ["ins_pf_cd_info"]               = "Rastrea los cooldowns de interrupci\195\179n y resurrecci\195\179n de combate\nde tus compa\195\177eros directamente en sus marcos de grupo.",
    ["ins_pf_show_interrupt"]        = "Mostrar rastreador de cooldown de interrupci\195\179n",
    ["ins_pf_show_brez"]             = "Mostrar rastreador de cooldown de resurrecci\195\179n de combate",
    ["ins_pf_reload_info"]           = "Se necesita un reload para aplicar cambios a los Party Frames.",

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
    ["ins_cb_title"]                 = "Barras de lanzamiento",
    ["ins_cb_info"]                  = "Barras de lanzamiento personalizadas para jugador, objetivo, foco y mascota\ncon animaci\195\179n de chispa y feedback de interrupci\195\179n.",
    ["ins_cb_section"]               = "General",
    ["ins_cb_enable"]                = "Activar castbars de TomoMod",
    ["ins_cb_hide_blizzard"]         = "Ocultar castbar predeterminada de Blizzard",
    ["ins_cb_class_color"]           = "Usar color de clase para el relleno",
    ["ins_cb_reload_info"]           = "Se necesita un reload para aplicar cambios a las castbars.",

    -- Step NEW: Resource Bars & Cooldown Manager
    ["ins_res_title"]                = "Recursos y Cooldowns",
    ["ins_res_info"]                 = "Visualizaci\195\179n de poder de clase (puntos de combo, runas, fragmentos de alma, etc.)\nen modo icono o barra.",
    ["ins_res_section"]              = "Barras de recursos",
    ["ins_res_enable"]               = "Activar barras de recursos",
    ["ins_res_display"]              = "Modo de visualizaci\195\179n",
    ["ins_cdm_section"]              = "Gestor de cooldowns",
    ["ins_cdm_info"]                 = "Espiral de cooldown en botones de acci\195\179n con\nalfa adaptativo al combate y filtrado de GCD.",
    ["ins_cdm_enable"]               = "Activar gestor de cooldowns",
    ["ins_cdm_hide_gcd"]             = "Ocultar espiral de GCD",
    ["ins_cdm_desat"]                = "Desaturar botones en cooldown",

    -- Enhanced Skins
    ["ins_skin_bag"]                 = "Skin de bolsas",
    ["ins_skin_tooltip"]             = "Skin de tooltips",
    ["ins_skin_objective"]           = "Objective Tracker skin (color-coded quest types)",
    ["ins_skin_mail"]                = "Mail skin",
    ["ins_skin_reputation"]          = "Reputation bar",

    -- Enhanced QOL
    ["ins_qol_interface_section"]    = "Interfaz",
    ["ins_qol_minimap"]              = "Minimapa personalizado (borde y escala)",
    ["ins_qol_cursor"]               = "Anillo de cursor luminoso",
    ["ins_qol_afk"]                  = "Pantalla AFK personalizada con modelo 3D",
    ["ins_qol_diag"]                 = "Diagn\195\179sticos (captura de errores sin popups)",
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
    ["opt_abs_style"]                = "Estilo visual",
    ["section_bar_opacity"]          = "Opacidad por barra",
    ["opt_abs_bar_select"]           = "Barra a configurar",
    ["opt_abs_opacity"]              = "Opacidad",
    ["btn_abs_apply_all"]            = "Aplicar a todas las barras",
    ["opt_abs_combat_only_label"]    = "Mostrar solo en combate:",
    ["opt_abs_combat_only"]          = "Barra visible solo en combate",
    ["section_bar_management"]       = "Gesti\195\179n de barras de acci\195\179n",
    ["btn_abs_unlock"]               = "Desbloquear barras",
    ["info_abs_unlock"]              = "Desbloquea las barras para mostrar los controles de arrastre.\nHaz clic derecho en un control para configurar una barra individualmente.",
    ["section_bar_quick"]            = "Ajustes r\195\161pidos",
    ["tab_abs_skin"]                 = "Skin de botones",
    ["tab_abs_bars"]                 = "Gesti\195\179n de barras",
    ["info_abs_layout"]              = "Usa el EditMode para mover las barras o arrastra las superposiciones.\nDespliega una barra abajo para ajustar el tama\195\177o de los botones y la escala.",
    -- General panel
    ["opt_gui_scale"]                = "Escala de la ventana de configuraci\195\179n",
    ["info_gui_scale"]               = "Escala de la ventana /tmf \226\128\148 tambi\195\169n se puede redimensionar arrastrando su esquina inferior derecha.",
    ["btn_gui_reset_size"]           = "Restablecer tama\195\177o y escala de la ventana",
    ["btn_relaunch_installer"]       = "Relanzar instalador",
    ["info_relaunch_installer"]      = "Inicia el asistente de configuraci\195\179n de 16 pasos.",
    -- Sound panel
    ["section_sound_preview"]        = "Vista previa y opciones",
    -- UFPreview
    ["preview_header"]               = "VISTA PREVIA EN VIVO",
    ["preview_player"]               = "Jugador",
    ["preview_target_name"]          = "Taurache",
    ["preview_focus_name"]           = "Sacerdotisa",
    ["preview_pet_name"]             = "Lobo de agua",
    ["preview_tot_name"]             = "Objetivo-del-objetivo",
    ["preview_cast_player"]          = "Descarga de Escarcha",
    ["preview_cast_target"]          = "Bola de Fuego",
    ["preview_lbl_player"]           = "JUGADOR",
    ["preview_lbl_target"]           = "OBJETIVO",
    ["preview_lbl_focus"]            = "FOCO",
    ["preview_lbl_pet"]              = "MASCOTA",
    ["preview_lbl_tot"]              = "TOT",
    ["preview_click_nav"]            = "clic para navegar",
    ["preview_click_isolate"]         = "clic para aislar",
    ["preview_click_show_all"]        = "clic para mostrar todo",
    ["preview_show_all"]              = "Mostrar todo",
    ["preview_zoom_fit"]                = "Ajustar",
    ["preview_zoom_11"]                 = "1:1",
    ["preview_zoom_tip"]                = "Alterna entre ajustar al panel y el tama\195\177o real 1:1.",
    ["preview_all_disabled"]            = "Todos los marcos de unidad est\195\161n desactivados.",
    ["preview_engine_missing"]          = "Motor UnitFrames no cargado.",
    ["preview_data_live"]               = "Datos reales",
    ["preview_data_mock"]               = "Simulado",
    ["preview_data_tip"]                = "Alimenta la vista previa con datos reales cuando la unidad existe; si no, usa valores simulados.",
    ["preview_tag_live"]                = "REAL",
    ["preview_tag_sim"]                 = "SIM",
    -- ConfigUI footer
    ["ui_footer_hint"]               = "/tmf  \194\183  /tmf sr para mover elementos",

    -- =====================
    -- SKINS CATEGORY (top-level)
    -- =====================
    ["cat_skins"]                        = "Skins",

    -- Chat Frame V2 — etiquetas de pesta\195\177as e interfaz
    ["chatv2_tab_general"]               = "General",
    ["chatv2_tab_instance"]              = "Instancia",
    ["chatv2_tab_chucho"]                = "Chucho",
    ["chatv2_tab_personnel"]             = "Personal",
    ["chatv2_tab_combat"]                = "Combate",
    ["chatv2_sidebar_title"]             = "CHAT",
    ["chatv2_expand_btn"]                = "Chat",
    ["chatv2_mover_label"]               = "Ventana de chat V2",
    ["chatv2_input_hint"]                = "Pulsa Intro para escribir...",

    -- Skins > Chat Frame tab
    ["tab_skin_chatframe"]               = "Ventana de chat",
    ["section_skin_chatframe"]           = "Skin de ventana de chat",
    ["info_skin_chatframe_desc"]         = "Panel de chat con barra lateral \226\128\148 General, Instancia, Chucho, Personal, Combate \226\128\148 con emblemas de no le\195\173dos e indicadores de pin.",
    ["opt_skin_chatframe_enable"]        = "Activar skin de chat",
    ["opt_skin_chatframe_width"]         = "Ancho",
    ["opt_skin_chatframe_height"]        = "Alto",
    ["opt_skin_chatframe_scale"]         = "Escala %",
    ["opt_skin_chatframe_opacity"]       = "Opacidad del fondo",
    ["opt_skin_chatframe_font_size"]     = "Tama\195\177o de fuente",
    ["opt_skin_chatframe_timestamp"]     = "Mostrar marca de tiempo",

    -- Skins > Bags tab
    ["tab_skin_bags"]                    = "Bolsas",
    ["section_skin_bags"]                = "Skin de bolsas",
    ["info_skin_bags_desc"]              = "Bolsas por categor\195\173a inspirada en BetterBags. Objetos agrupados en secciones plegables con bordes de calidad, b\195\186squeda, enfriamientos y nivel de objeto.",
    ["opt_skin_bags_enable"]             = "Activar skin de bolsas",
    -- Bolsas — Desencantar
    ["bagskin_currencies_none"]          = "Sin divisas seguidas (clic derecho en una divisa \226\134\146 Mostrar en la mochila)",
    ["opt_skin_bags_stack_merge"]        = "Fusionar pilas id\195\169nticas",
    ["opt_skin_bags_show_empty"]         = "Mostrar secci\195\179n de ranuras libres",
    ["opt_skin_bags_show_recent"]        = "Mostrar secci\195\179n de objetos recientes",
    ["opt_skin_bags_columns"]            = "Columnas",
    ["opt_skin_bags_slot_size"]          = "Tama\195\177o de ranura",
    ["opt_skin_bags_slot_spacing"]       = "Espaciado de ranuras",
    ["opt_skin_bags_scale"]              = "Escala %",
    ["opt_skin_bags_opacity"]            = "Opacidad del fondo",
    ["opt_skin_bags_quality_borders"]    = "Mostrar bordes de calidad",
    ["bags_v4_quality_style"]            = "Calidad de objeto",
    ["bags_v4_quality_tint"]             = "Casilla teñida",
    ["bags_v4_quality_border"]           = "Marco de color",
    ["bags_v4_quality_both"]             = "Ambos",
    ["bags_v4_quality_none"]             = "Ninguno",
    ["bags_v4_slot_pin"]                 = "Clic central: fijar",
    ["bags_v4_slot_unpin"]               = "Clic central: soltar",
    ["bags_v4_sidebar_click"]            = "Clic izquierdo: buscar en las bolsas",
    ["bags_v4_sidebar_unpin"]            = "Clic central: soltar",
    ["opt_skin_bags_cooldowns"]          = "Mostrar enfriamientos",
    ["opt_skin_bags_quantity"]           = "Mostrar distintivos de cantidad",
    ["opt_skin_bags_search"]             = "Mostrar barra de b\195\186squeda",
    ["opt_skin_bags_sort_mode"]          = "Modo de orden",
    ["opt_skin_bags_sort_quality"]       = "Calidad",
    ["opt_skin_bags_sort_name"]          = "Nombre",
    ["opt_skin_bags_sort_type"]          = "Tipo",
    ["opt_skin_bags_sort_ilvl"]          = "Nivel de objeto",
    ["opt_skin_bags_sort_recent"]        = "Reciente",
    ["opt_skin_bags_show_gold"]          = "Mostrar oro (pie de p\195\161gina)",
    ["opt_skin_bags_show_currencies"]    = "Mostrar divisas seguidas (pie de p\195\161gina)",

    -- Skins > Objective Tracker tab
    ["tab_skin_objtracker"]              = "Rastreador",

    -- Skins > Character tab
    ["tab_skin_character"]               = "Personaje",

    -- Skins > Buffs tab

    -- Skins > Game Menu tab
    ["tab_skin_gamemenu"]                = "Men\195\186 de juego",

    -- Skins > Mail tab
    ["tab_skin_mail"]                    = "Correo",

    -- =====================
    -- MÓDULO WAYPOINT (/tmf way)
    -- =====================
    -- GUI
    ["tab_qol_waypoint"]                  = "Marcador",
    ["section_waypoint"]                  = "Marcador",
    ["opt_way_zone_only"]                 = "Mostrar solo en la zona actual",
    ["opt_way_size"]                      = "Tamaño del marcador",
    ["opt_way_shape"]                     = "Forma",
    ["way_shape_ring"]                    = "Anillo",
    ["way_shape_arrow"]                   = "Flecha",
    ["opt_way_color"]                     = "Color del marcador",
    -- Slash
    ["msg_help_way"]                     = "Colocar un marcador en tu posición actual",
    ["msg_help_way_coords"]              = "Colocar un marcador en las coordenadas (x, y)",
    ["msg_help_way_clear"]               = "Eliminar el marcador activo",
    ["way_cleared"]                      = "Marcador eliminado.",
    ["way_set"]                          = "Marcador establecido en %s%s.",
    ["way_here"]                         = "Marcador colocado en la posición actual.",
    ["way_no_map"]                       = "No se puede determinar el mapa actual.",
    ["way_no_pos"]                       = "No se puede determinar la posición del jugador.",
    ["way_bad_map"]                      = "No se puede colocar un marcador en este mapa.",
    ["way_bad_coords"]                   = "Las coordenadas deben estar entre 0 y 100.",
    ["way_usage"]                        = "Uso: /tmf way [mapID] x y [nombre]  |  /tmf way clear",

    -- =====================
    -- Resource names
    -- =====================
    ["res_mana"]                        = "Maná (Druida)",
    ["res_soul_shards"]                 = "Fragmentos de alma",
    ["res_holy_power"]                  = "Poder sagrado",
    ["res_chi"]                         = "Chi",
    ["res_combo_points"]                = "Puntos de combo",
    ["res_charged_combo_points"]        = "Puntos de combo sobrecargados",
    ["res_arcane_charges"]              = "Cargas arcanas",
    ["res_essence"]                     = "Esencia",
    ["res_stagger"]                     = "Tambaleo",
    ["res_soul_fragments"]              = "Fragmentos de alma",
    ["res_tip_of_spear"]                = "Punta de la lanza",
    ["res_maelstrom_weapon"]            = "Arma de Maelström",
    ["res_icicles"]                      = "Carámbanos",

    -- =====================
    -- Resource Bars display mode
    -- =====================
    ["opt_rb_display_mode"]             = "Modo de visualización",
    ["display_mode_icons"]              = "Iconos (texturas TUI)",
    ["display_mode_bars"]               = "Barras (colores planos)",

    -- =====================
    -- Tooltip Skin
    -- =====================
    ["tab_skin_tooltip"]                 = "Tooltip",
    ["section_tooltip_skin"]             = "Skin de Tooltip",
    ["opt_tooltip_skin_enable"]          = "Activar skin de tooltip",
    ["info_tooltip_skin_reload"]         = "Algunos cambios requieren pasar el cursor sobre un nuevo objetivo.",
    ["opt_tooltip_bg_alpha"]             = "Opacidad del fondo",
    ["opt_tooltip_border_alpha"]         = "Opacidad del borde",
    ["opt_tooltip_bg_color"]              = "Color de fondo",
    ["opt_tooltip_border_color"]          = "Color del borde",
    ["opt_tooltip_font_size"]             = "Tamaño de fuente",
    ["opt_tooltip_hide_healthbar"]       = "Ocultar barra de vida",
    ["opt_tooltip_class_color"]          = "Nombres de jugador con color de clase",
    ["opt_tooltip_hide_server"]          = "Ocultar servidor en nombres de jugador",
    ["opt_tooltip_hide_title"]           = "Ocultar título en nombres de jugador",
    ["opt_tooltip_guild_color"]          = "Color personalizado de nombre de hermandad",
    ["opt_tooltip_guild_color_pick"]     = "Color de nombre de hermandad",
    ["sublabel_tooltip_info"]            = "— Información de unidad —",
    ["opt_tooltip_unit_info"]            = "Mostrar información de unidad",
    ["info_tooltip_unit_info"]           = "Añade rango de hermandad, objetivo, puntuación M+ y más a las descripciones.",
    ["opt_tooltip_reaction_border"]      = "Colorear borde por reacción / clase",
    ["opt_tooltip_color_level"]          = "Colorear nivel por dificultad",
    ["opt_tooltip_raid_marker"]          = "Mostrar icono de marcador",
    ["opt_tooltip_role_icon"]            = "Mostrar icono de rol",
    ["opt_tooltip_class_icon"]           = "Mostrar icono de clase",
    ["opt_tooltip_icon_size"]            = "Tamaño de iconos",
    ["opt_tooltip_guild_rank"]           = "Mostrar rango de hermandad",
    ["opt_tooltip_guild_rank_index"]     = "Mostrar número de rango",
    ["opt_tooltip_guild_realm"]          = "Mostrar reino de hermandad",
    ["opt_tooltip_show_target"]          = "Mostrar objetivo de la unidad",
    ["opt_tooltip_mythic_score"]         = "Mostrar puntuación M+",
    ["opt_tooltip_mount"]                = "Mostrar montura",
    ["opt_tooltip_speed"]                = "Mostrar velocidad de movimiento",
    ["opt_tooltip_location"]             = "Mostrar ubicación",
    ["info_tooltip_location"]            = "La ubicación solo está disponible para ti y los miembros de tu grupo.",
    ["tt_guild_rank"]                    = "Rango",
    ["tt_target"]                        = "Objetivo",
    ["tt_target_you"]                    = "Tú",
    ["tt_mythic_score"]                  = "Puntuación M+",
    ["tt_speed"]                         = "Velocidad",
    ["tt_mount"]                         = "Montura",
    ["tt_location"]                      = "Ubicación",
    ["sublabel_tooltip_inspect"]         = "— Inspección —",
    ["opt_tooltip_item_level"]           = "Mostrar nivel de objeto",
    ["opt_tooltip_spec"]                 = "Mostrar especialización",
    ["opt_tooltip_spec_icon"]            = "Mostrar icono de especialización",
    ["opt_tooltip_pending_text"]         = "Mostrar indicador durante la carga",
    ["info_tooltip_inspect"]             = "El nivel de objeto y la especialización requieren inspeccionar al jugador: solo aparecen dentro del alcance.",
    ["tt_item_level"]                    = "Nivel de objeto",
    ["tt_spec"]                          = "Especialización",
    ["tt_loading"]                       = "...",

    -- =====================
    -- Bag Skin extras
    -- =====================
    ["opt_skin_bags_show_ilvl"]          = "Mostrar nivel de objeto en equipo",
    ["opt_skin_bags_show_junk_icon"]     = "Mostrar icono de basura",
    ["opt_skin_bags_layout_mode"]        = "Modo de disposición",
    ["opt_skin_bags_layout_combined"]    = "Cuadrícula combinada",
    ["opt_skin_bags_layout_categories"]  = "Categorías",
    ["opt_skin_bags_layout_separate"]    = "Bolsas separadas",
    ["opt_skin_bags_reverse_order"]      = "Invertir orden de bolsas",
    ["opt_skin_bags_show_bag_bar"]       = "Mostrar barra de bolsas",
    ["opt_skin_bags_settings"]           = "Ajustes de bolsas",
    ["opt_skin_bags_slot_spacing_x"]     = "Espaciado de ranuras X",
    ["opt_skin_bags_slot_spacing_y"]     = "Espaciado de ranuras Y",
    ["opt_skin_bags_sort_none"]          = "Manual",

    -- =====================
    -- TOMOSCORE (Scoreboard)
    -- =====================
    ["ts_cfg_title"]                = "Marcador",
    ["ts_cfg_enable"]               = "Activar marcador de mazmorra",
    ["ts_cfg_auto_show_mplus"]      = "Mostrar automáticamente en M+",
    ["ts_cfg_scale"]                = "Escala",
    ["ts_cfg_alpha"]                = "Opacidad del fondo",
    ["ts_cfg_section_display"]      = "Visualización",
    ["ts_cfg_section_frame"]        = "Marco",
    ["ts_cfg_section_actions"]      = "Acciones",
    ["ts_cfg_preview"]              = "Vista previa",
    ["ts_cfg_last_run"]             = "Mostrar última partida",
    ["ts_cfg_reset_pos"]            = "Reiniciar posición",
    ["ts_reset_msg"]                = "|cffffd100TomoModForever|r Marcador: Posición reiniciada.",
    ["ts_no_data"]                  = "|cffffd100TomoModForever|r Marcador: No hay datos de mazmorra disponibles.",
    ["ts_mythic_zero"]              = "Mítica",
    ["ts_key_level"]                = "+%d",
    ["ts_completed"]                = "COMPLETADO",
    ["ts_depleted"]                 = "AGOTADO",
    ["ts_duration"]                 = "Duración",
    ["ts_col_player"]               = "Jugador",
    ["ts_col_rating"]               = "M+",
    ["ts_col_key_level"]            = "Llave",
    ["ts_col_key_name"]             = "Mazmorra",
    ["ts_col_damage"]               = "Daño",
    ["ts_col_healing"]              = "Sanación",
    ["ts_col_interrupts"]           = "Interrupciones",
    ["ts_footer_total"]             = "Total",
    ["ts_footer_players"]           = "%d jugadores",

    -- =====================
    -- CASTBARS (módulo independiente)
    -- =====================
    ["cat_castbars"]                     = "Barras de lanzamiento",

    ["cb_section_general"]               = "General",
    ["opt_cb_enable"]                    = "Activar barras de lanzamiento independientes",
    ["info_cb_description"]              = "Reemplaza las barras de lanzamiento de Blizzard con barras totalmente personalizables para Jugador, Objetivo, Foco, Mascota y Jefe.",
    ["btn_cb_toggle_preview"]            = "Show / Hide Preview",
    ["info_cb_preview_hint"]             = "Unlocks every castbar and shows a live mock spell so you can see your tweaks instantly.",
    ["opt_cb_hide_blizzard"]             = "Ocultar barras de lanzamiento de Blizzard",
    ["opt_cb_class_color"]               = "Usar color de clase",
    ["opt_cb_show_transitions"]          = "Animaciones de inicio/fin",
    ["opt_cb_show_channel_ticks"]        = "Mostrar marcas de canalización",
    ["opt_cb_timer_format"]              = "Formato del temporizador",
    ["cb_timer_remaining"]               = "Restante (1.5)",
    ["cb_timer_remaining_total"]         = "Restante / Total (1.5 / 3.0)",
    ["cb_timer_elapsed"]                 = "Transcurrido (1.5)",
    ["opt_cb_spell_max_len"]             = "Largo máx. del nombre (0 = sin límite)",

    ["cb_section_appearance"]            = "Apariencia",
    ["opt_cb_bar_texture"]               = "Textura de la barra",
    ["cb_tex_blizzard"]                  = "Blizzard",
    ["cb_tex_smooth"]                    = "Suave",
    ["cb_tex_flat"]                      = "Plano",
    ["opt_cb_font_size"]                 = "Tamaño de fuente",
    ["opt_cb_bg_mode"]                   = "Modo de fondo",
    ["cb_bg_black"]                      = "Negro",
    ["cb_bg_transparent"]                = "Transparente",
    ["cb_bg_custom"]                     = "Textura personalizada",

    ["cb_section_colors"]                = "Colores",
    ["opt_cb_cast_color"]                = "Color de lanzamiento",
    ["opt_cb_ni_color"]                  = "No interrumpible",
    ["opt_cb_interrupt_color"]           = "Color de interrupción",

    ["cb_section_spark"]                 = "Chispa",
    ["opt_cb_show_spark"]                = "Mostrar animación de chispa",
    ["opt_cb_spark_style"]               = "Estilo de chispa",
    ["opt_cb_spark_color"]               = "Color de chispa",
    ["opt_cb_spark_glow_color"]          = "Color de brillo",
    ["opt_cb_spark_tail_color"]          = "Color de estela",
    ["opt_cb_spark_glow_alpha"]          = "Opacidad del brillo",
    ["opt_cb_spark_tail_alpha"]          = "Opacidad de estela",

    ["cb_section_gcd"]                   = "Chispa GCD",
    ["opt_cb_show_gcd"]                  = "Mostrar barra GCD bajo la barra del jugador",
    ["opt_cb_gcd_height"]                = "Altura de la barra GCD",
    ["opt_cb_gcd_color"]                 = "Color GCD",

    ["cb_section_interrupt"]             = "Retroalimentación de interrupción",
    ["opt_cb_show_interrupt_feedback"]   = "Mostrar texto de interrupción",
    ["opt_cb_interrupt_fb_color"]        = "Color del texto",
    ["opt_cb_interrupt_fb_size"]         = "Tamaño de fuente",
    ["cb_interrupt_feedback_text"]       = "¡INTERRUMPIDO!",
    ["cb_interrupt_feedback_full"]       = "INTERRUMPIDO: %s",
    ["cb_interrupted"]                   = "Interrumpido",

    ["cb_tab_general"]                   = "General",
    ["cb_tab_player"]                    = "Jugador",
    ["cb_tab_target"]                    = "Objetivo",
    ["cb_tab_focus"]                     = "Foco",
    ["cb_tab_pet"]                       = "Mascota",
    ["cb_tab_boss"]                      = "Jefe",

    ["cb_section_unit"]                  = "Barra de %s",
    ["opt_cb_unit_enable"]               = "Activar",
    ["opt_cb_unit_width"]                = "Ancho",
    ["opt_cb_unit_height"]               = "Alto",
    ["opt_cb_unit_show_icon"]            = "Mostrar icono",
    ["opt_cb_unit_icon_side"]            = "Lado del icono",
    ["cb_icon_left"]                     = "Izquierda",
    ["cb_icon_right"]                    = "Derecha",
    ["opt_cb_unit_show_timer"]           = "Mostrar temporizador",
    ["opt_cb_unit_show_latency"]         = "Mostrar latencia",
    ["info_cb_latency"]                  = "Muestra una capa oscura con la latencia de red al final de la barra.",
    ["info_cb_position"]                 = "Usa /tmf layout para desbloquear y arrastrar esta barra.",
    ["btn_cb_reset_position"]            = "Restablecer posición",
    ["cb_move_label"]                    = "(Arrastra para mover)",
    ["cb_player_missing_notice"]         = "La barra de lanzamiento del jugador no está activada — actívala en los ajustes de Barras de lanzamiento antes de poder moverla.",
    ["cb_preview_castbar"]               = "Vista previa: %s",

    ["mover_castbar_standalone"]         = "Barras de lanzamiento",

    -- ═══════════════════════════════════
    -- Marcos de grupo (Party Frames)
    -- ═══════════════════════════════════
    ["cat_partyframes"]                  = "Marcos de grupo",
    ["mover_partyframes"]                = "Marcos de grupo",

    ["pf_tab_general"]                   = "General",
    ["pf_tab_features"]                  = "Funciones",
    ["pf_tab_cooldowns"]                 = "Enfriamientos",
    ["pf_tab_arena"]                     = "Arena",

    ["pf_section_general"]               = "General",
    ["pf_opt_enable"]                    = "Activar marcos de grupo",
    ["pf_info_description"]              = "Marcos de grupo personalizados para M+ y Arena con salud, absorción, predicción de curación, HoTs, CD de interrupción/rez de combate y resaltado de disipación.",
    ["pf_opt_hide_blizzard"]             = "Ocultar marcos de grupo de Blizzard",
    ["pf_opt_sort_role"]                 = "Ordenar por rol (Tanque > Sanador > DPS)",

    ["pf_section_dimensions"]            = "Dimensiones",
    ["pf_opt_width"]                     = "Ancho del marco",
    ["pf_opt_height"]                    = "Alto del marco",
    ["pf_opt_spacing"]                   = "Espaciado",
    ["pf_opt_grow_direction"]            = "Dirección de crecimiento",
    ["pf_dir_down"]                      = "Abajo",
    ["pf_dir_up"]                        = "Arriba",
    ["pf_dir_right"]                     = "Derecha",
    ["pf_dir_left"]                      = "Izquierda",

    ["pf_section_display"]               = "Visualización",
    ["pf_opt_show_name"]                 = "Mostrar nombre",
    ["pf_opt_show_health_text"]          = "Mostrar texto de salud",
    ["pf_opt_health_format"]             = "Formato de salud",
    ["pf_fmt_deficit"]                   = "Déficit",
    ["pf_opt_health_color"]              = "Modo de color de salud",
    ["pf_color_green"]                   = "Verde",
    ["pf_color_gradient"]                = "Degradado",
    ["pf_opt_show_power"]                = "Mostrar barra de poder",
    ["pf_opt_power_height"]              = "Altura de barra de poder",
    ["pf_opt_show_role"]                 = "Mostrar icono de rol",
    ["pf_opt_role_size"]                 = "Tamaño del icono de rol",
    ["pf_opt_show_leader"]               = "Mostrar icono de líder",
    ["pf_opt_leader_size"]               = "Tamaño del icono de líder",
    ["pf_opt_show_marker"]               = "Mostrar marca de banda",
    ["pf_opt_readycheck_size"]            = "Tamaño del icono de preparación",
    ["pf_opt_summon_size"]               = "Tamaño del indicador de invocación",

    ["pf_section_font"]                  = "Fuente",
    ["pf_opt_font_size"]                 = "Tamaño de fuente",

    ["pf_section_position"]              = "Posición",
    ["pf_info_position"]                 = "Usa /tmf layout para desbloquear y arrastrar los marcos de grupo.",
    ["pf_btn_reset_position"]            = "Restablecer posición",

    ["pf_section_health_extras"]         = "Extras de salud",
    ["pf_opt_show_absorb"]               = "Mostrar barra de absorción",
    ["pf_opt_absorb_color"]              = "Color de absorción",
    ["pf_opt_show_heal_pred"]            = "Mostrar predicción de curación",

    ["pf_section_range"]                 = "Comprobación de rango",
    ["pf_opt_show_range"]                = "Atenuar miembros fuera de rango",
    ["pf_opt_oor_alpha"]                 = "Opacidad fuera de rango",

    ["pf_section_dispel"]                = "Alerta de tipo de perjuicio",
    ["pf_opt_show_dispel"]               = "Activar la alerta de perjuicio",
    ["pf_opt_show_dispel_border"]        = "Colorear todo el marco según el perjuicio",
    ["pf_opt_show_dispel_icon"]          = "Mostrar el icono del perjuicio prioritario",
    ["pf_opt_show_dispel_bleed"]         = "Incluir los sangrados",
    ["pf_opt_dispel_size"]               = "Tamaño del icono de perjuicio",
    ["pf_opt_dispel_border_size"]        = "Grosor del borde de alerta",
    ["pf_info_dispel"]                   = "Usa el motor de auras de Midnight 12.1 para mostrar Magia (azul), Maldición (morado), Enfermedad (naranja), Veneno (verde) y Sangrado (rojo) sin leer datos de aura protegidos en combate. El icono es el perjuicio real y el borde nunca altera el relleno de la barra de vida.",

    ["pf_section_hots"]                  = "Rastreo de HoTs",
    ["pf_opt_show_hots"]                 = "Mostrar indicadores de HoT",
    ["pf_opt_hot_size"]                  = "Tamaño de icono HoT",
    ["pf_opt_max_hots"]                  = "Max. HoTs mostrados",
    ["pf_opt_hot_duration"]              = "Mostrar los segundos restantes en los HoTs",
    ["pf_info_hots"]                     = "Muestra efectos de curación con el tiempo con bordes de color de clase. Compatible con Sacerdote, Druida, Paladín, Chamán, Monje y Evocador.",
    ["pf_section_defensives"]            = "Reutilizaciones defensivas",
    ["pf_opt_show_defensives"]           = "Mostrar reutilizaciones defensivas",
    ["pf_opt_defensive_size"]            = "Tamaño de los iconos defensivos",
    ["pf_opt_max_defensives"]            = "Máx. defensivas mostradas",
    ["pf_opt_def_externals"]             = "Reutilizaciones externas (lanzadas sobre este jugador)",
    ["pf_opt_def_raidwide"]              = "Reutilizaciones de banda",
    ["pf_opt_def_personals"]             = "Reutilizaciones personales",
    ["pf_info_defensives"]               = "El color del borde indica la categoría: dorado para las externas (Corteza de hierro, Crisálida de vida, Supresión del dolor), cian para las de banda, rojo para las personales. Las de banda y personales están desactivadas por defecto porque se encienden en todos los marcos a la vez.",

    ["pf_section_cooldowns"]             = "Rastreador de enfriamiento",
    ["pf_opt_show_kick"]                 = "Mostrar CD de interrupción",
    ["pf_opt_show_brez"]                 = "Mostrar CD de rez de combate",
    ["pf_opt_cd_size"]                   = "Tamaño del icono CD",
    ["pf_opt_cd_layout"]                 = "Disposición de iconos CD",
    ["pf_cd_vertical"]                   = "Vertical (sobre marco)",
    ["pf_cd_horizontal"]                 = "Horizontal (debajo)",
    ["pf_info_cooldowns"]                = "Las interrupciones se detectan mediante UNIT_SPELLCAST_SUCCEEDED. El rez de combate lee el pool de cargas compartido, por lo que el icono se apaga para todos cuando se usa un rez en la instancia.",

    -- Indicador de resurrección (grupo)
    ["pf_section_resurrect"]             = "Indicador de resurrección",
    ["pf_opt_show_resurrect"]            = "Mostrar icono de resurrección entrante",
    ["pf_opt_resurrect_size"]            = "Tamaño del icono de resurrección",
    ["pf_info_resurrect"]                = "Muestra un icono de rez en un miembro mientras se está lanzando una resurrección sobre él.",

    ["pf_section_arena"]                 = "Marcos de enemigos de arena",
    ["pf_opt_arena_enable"]              = "Activar marcos de arena",
    ["pf_info_arena"]                    = "Muestra salud, poder y CD de abalorio PvP del equipo enemigo en Arena (2v2/3v3).",
    ["pf_section_arena_dims"]            = "Dimensiones de arena",
    ["pf_opt_arena_width"]               = "Ancho",
    ["pf_opt_arena_height"]              = "Alto",
    ["pf_opt_arena_spacing"]             = "Espaciado",
    ["pf_section_arena_trinket"]         = "Abalorio PvP",
    ["pf_opt_show_trinket"]              = "Mostrar CD de abalorio",
    ["pf_opt_trinket_size"]              = "Tamaño del icono de abalorio",
    ["pf_opt_show_spec"]                 = "Mostrar icono de especialización",
    ["pf_section_arena_pos"]             = "Posición de arena",
    ["pf_info_arena_pos"]                = "Usa /tmf layout para desbloquear y arrastrar los marcos de arena.",
    ["pf_btn_reset_arena_pos"]           = "Restablecer posición",

    -- ═══════════════════════════════════
    -- Raid Frames
    -- ═══════════════════════════════════
    ["cat_raidframes"]                   = "Marcos de banda",
    ["mover_raidframes"]                 = "Marcos de banda",
    ["rf_tab_general"]                   = "General",
    ["rf_tab_features"]                  = "Funciones",
    ["rf_section_general"]               = "General",
    ["rf_opt_enable"]                    = "Activar marcos de banda",
    ["rf_info_description"]              = "Marcos de banda personalizados con salud, absorción, predicción de curación, HoTs, debuffs, resaltado de disipación, CDs defensivos y verificación de rango.",
    ["rf_opt_hide_blizzard"]             = "Ocultar marcos de banda de Blizzard",
    ["rf_opt_skin_group_manager"]       = "Reskinear el panel de líder de grupo (comprobación, marcadores, abandonar grupo)",
    ["rf_opt_sort_role"]                 = "Ordenar por rol (Tanque > Sanador > DPS)",
    ["rf_section_layout"]                = "Disposición",
    ["rf_opt_layout_mode"]               = "Modo de disposición",
    ["rf_layout_grid"]                   = "Cuadrícula (grupos en columnas)",
    ["rf_layout_list"]                   = "Lista (columna única)",
    ["rf_opt_width"]                     = "Ancho del marco",
    ["rf_opt_height"]                    = "Alto del marco",
    ["rf_opt_spacing"]                   = "Espaciado",
    ["rf_opt_group_spacing"]             = "Espaciado de grupo",
    ["rf_section_display"]               = "Visualización",
    ["rf_opt_show_name"]                 = "Mostrar nombre",
    ["rf_opt_name_max_length"]           = "Letras máximas del nombre",
    ["rf_opt_show_health_text"]          = "Mostrar texto de salud",
    ["rf_opt_health_format"]             = "Formato de salud",
    ["rf_opt_health_color"]              = "Modo de color de salud",
    ["rf_opt_show_role"]                 = "Mostrar icono de rol",
    ["rf_opt_show_marker"]               = "Mostrar marcador de banda",
    ["rf_opt_readycheck_size"]            = "Tamaño del icono de preparación",
    ["rf_opt_summon_size"]               = "Tamaño del indicador de invocación",
    ["rf_section_font"]                  = "Fuente",
    ["rf_opt_font_size"]                 = "Tamaño de fuente",
    ["rf_section_position"]              = "Posición",
    ["rf_info_position"]                 = "Usa /tmf layout para desbloquear y mover los marcos de banda.",
    ["rf_btn_reset_position"]            = "Restablecer posición",
    ["rf_info_test_raid"]                = "Simula una banda de 20 jugadores para previsualizar el diseño fuera de combate.",
    ["rf_btn_test_raid"]                 = "Simular 20 jugadores",
    ["rf_btn_test_raid_stop"]            = "Detener simulación",
    ["rf_preview_group"]                 = "G",
    ["rf_mode_raid"]                     = "Raid",
    ["rf_mode_solo"]                     = "Solo",
    ["rf_section_health_extras"]         = "Funciones de salud",
    ["rf_opt_show_power"]                = "Barra de poder (solo sanadores)",
    ["rf_opt_power_height"]              = "Altura de la barra de poder",
    ["rf_opt_show_absorb"]               = "Mostrar barra de absorción",
    ["rf_opt_show_heal_pred"]            = "Mostrar predicción de curación",
    ["rf_section_range"]                 = "Verificación de rango",
    ["rf_opt_show_range"]                = "Desvanecer miembros fuera de rango",
    ["rf_opt_oor_alpha"]                 = "Opacidad fuera de rango",
    ["rf_section_dispel"]                = "Alerta de tipo de perjuicio",
    ["rf_opt_show_dispel"]               = "Activar la alerta de perjuicio",
    ["rf_opt_show_dispel_border"]        = "Colorear todo el marco según el perjuicio",
    ["rf_opt_show_dispel_icon"]          = "Mostrar el icono del perjuicio prioritario",
    ["rf_opt_show_dispel_bleed"]         = "Incluir los sangrados",
    ["rf_opt_dispel_size"]               = "Tamaño del icono de perjuicio",
    ["rf_opt_dispel_border_size"]        = "Grosor del borde de alerta",
    ["rf_info_dispel"]                   = "Magia = azul, Maldición = morado, Enfermedad = naranja, Veneno = verde, Sangrado = rojo. Usa los AuraSlots del motor, así que la alerta sigue siendo segura en combate cuando los datos de aura están protegidos.",
    ["rf_section_hots"]                  = "Rastreo de HoTs",
    ["rf_opt_show_hots"]                 = "Mostrar indicadores HoT",
    ["rf_opt_hot_size"]                  = "Tamaño de icono HoT",
    ["rf_opt_max_hots"]                  = "Máx. HoTs mostrados",
    ["rf_opt_hot_duration"]              = "Mostrar los segundos restantes en los HoTs",
    ["rf_section_debuffs"]               = "Rastreo de debuffs",
    ["rf_opt_show_debuffs"]              = "Mostrar iconos de debuff",
    ["rf_opt_debuff_size"]               = "Tamaño de icono de debuff",
    ["rf_opt_max_debuffs"]               = "Máx. debuffs mostrados",
    ["rf_section_defensives"]            = "CDs defensivos",
    ["rf_opt_show_defensives"]           = "Mostrar buffs defensivos activos",
    ["rf_opt_defensive_size"]            = "Tamaño de icono defensivo",
    ["rf_opt_max_defensives"]            = "Máx. defensivas mostradas",
    ["rf_opt_def_externals"]             = "Reutilizaciones externas (lanzadas sobre este jugador)",
    ["rf_opt_def_raidwide"]              = "Reutilizaciones de banda",
    ["rf_opt_def_personals"]             = "Reutilizaciones personales",
    ["rf_info_defensives"]               = "Muestra CDs defensivos activos (ej: Supresión del dolor, Piel de hierro, Escudo divino) en cada miembro de la banda.",

    -- Indicador de resurrección (banda)
    ["rf_section_resurrect"]             = "Indicador de resurrección",
    ["rf_opt_show_resurrect"]            = "Mostrar icono de resurrección entrante",
    ["rf_opt_resurrect_size"]            = "Tamaño del icono de resurrección",
    ["rf_info_resurrect"]                = "Muestra un icono de rez en un miembro mientras se está lanzando una resurrección sobre él (rez de combate o normal).",

    -- Contador de rez de combate
    ["rf_section_battlerez"]             = "Contador de rez de combate",
    ["rf_opt_br_enable"]                 = "Mostrar contador de rez de combate",
    ["rf_opt_br_only_instance"]          = "Solo en mazmorras/bandas",
    ["rf_opt_br_size"]                   = "Tamaño del contador",
    ["rf_opt_br_font"]                   = "Tamaño de fuente del contador",
    ["rf_info_battlerez"]                = "Un contador movible que muestra cuántas rez de combate hay disponibles y el tiempo hasta la siguiente carga. Lee el pool compartido, funciona en cualquier clase. Muévelo con /tmf layout.",

    -- Diseño por tamaño
    ["rf_section_size_overrides"]        = "Diseño por tamaño (10/25/40)",
    ["rf_opt_overrides_enable"]          = "Activar diseños por tamaño",
    ["rf_info_size_overrides"]           = "Cuando está activado, el tamaño del marco se adapta automáticamente al tamaño del grupo (el espaciado se ajusta por tramo).",
    ["rf_ov_small"]                      = "Pequeño  (hasta 10)",
    ["rf_ov_medium"]                     = "Mediano  (hasta 25)",
    ["rf_ov_large"]                      = "Grande  (26-40)",
    ["rf_ov_width"]                      = "Anchura",
    ["rf_ov_height"]                     = "Altura",

    -- ═══════════════════════════════════
    -- Aura Tracker
    -- ═══════════════════════════════════
    ["mover_battlerez"]                  = "Rez de combate",
    ["mover_preytracker"]                = "Rastreador de Presa",
    ["mover_extrabuttons"]               = "Botón Extra",

    ["at_section_general"]               = "General",
    ["at_opt_enable"]                    = "Activar rastreador de auras",
    ["at_info_description"]              = "Rastrea buffs importantes: procs de abalorios, procs de encantamientos, buffs personales y defensivas en un overlay de iconos.",

    ["at_section_appearance"]            = "Apariencia",
    ["at_opt_icon_size"]                 = "Tamaño de icono",
    ["at_opt_spacing"]                   = "Espaciado",
    ["at_opt_max_icons"]                 = "Máx. iconos",
    ["at_opt_grow_direction"]            = "Dirección de crecimiento",
    ["at_opt_font_size"]                 = "Tamaño de fuente",

    ["at_section_display"]               = "Visualización",
    ["at_opt_show_timer"]                = "Mostrar temporizador",
    ["at_opt_show_stacks"]               = "Mostrar pilas",
    ["at_opt_show_glow"]                 = "Brillo en nuevo proc",
    ["at_opt_timer_threshold"]           = "Umbral de parpadeo (seg.)",

    ["at_section_categories"]            = "Categorías",
    ["at_info_categories"]               = "Elige qué categorías de auras rastrear.",
    ["at_cat_trinkets"]                  = "Procs de abalorio",
    ["at_cat_enchants"]                  = "Procs de encantamiento",
    ["at_cat_selfbuffs"]                 = "Buffs personales (CDs)",
    ["at_cat_raidbuffs"]                 = "Buffs de banda",
    ["at_cat_defensives"]                = "Defensivas (externas + personales)",

    ["at_section_position"]              = "Posición",
    ["at_info_position"]                 = "Usa /tmf layout para desbloquear y arrastrar el rastreador.",
    ["at_btn_reset_position"]            = "Restablecer posición",

    -- ═══════════════════════════════════
    -- Battle Text
    -- ═══════════════════════════════════
    ["cat_battletext"]                   = "Texto de combate",
    ["mover_battletext"]                 = "Texto de combate",

    ["bt_section_general"]               = "General",
    ["bt_info_description"]              = "Texto de combate desplazable: daño y curación, entrante y saliente.",
    ["bt_opt_enable"]                    = "Activar texto de combate",

    ["bt_section_display"]               = "Visualización",
    ["bt_opt_outgoing"]                  = "Mostrar daño saliente",
    ["bt_opt_incoming"]                  = "Mostrar daño entrante",
    ["bt_opt_overheal"]                  = "Mostrar sobrecuración",
    ["bt_opt_throttle"]                  = "Fusionar ticks DoT/HoT",

    ["bt_section_appearance"]            = "Apariencia",
    ["bt_opt_font_size"]                 = "Tamaño de fuente",
    ["bt_opt_throttle_window"]           = "Ventana de fusión (seg)",

    ["bt_section_position"]              = "Posición",
    ["bt_info_position"]                 = "Usa /tmf layout para desbloquear y arrastrar las zonas.",
    ["bt_btn_reset_position"]            = "Restablecer posiciones",

    ["bt_zone_outgoing"]                 = "Saliente",
    ["bt_zone_incoming"]                 = "Entrante",
    ["bt_zone_heal_out"]                 = "Curación saliente",
    ["bt_zone_heal_in"]                  = "Curación recibida",

    ["bt_cmd_help"]                      = "/tmf bt <cmd>",
    ["bt_enabled"]                       = "activado",
    ["bt_disabled"]                      = "desactivado",
    ["bt_crit"]                          = "!",
    ["bt_zones_locked"]                  = "zonas bloqueadas",
    ["bt_zones_unlocked"]                = "zonas desbloqueadas",
    ["bt_reset_done"]                    = "posiciones restablecidas.",
    ["bt_miss_miss"]                     = "Fallo",
    ["bt_miss_dodge"]                    = "Esquivado",
    ["bt_miss_parry"]                    = "Parado",
    ["bt_miss_block"]                    = "Bloqueado",
    ["bt_miss_resist"]                   = "Resistido",
    ["bt_miss_absorb"]                   = "Absorbido",
    ["bt_miss_immune"]                   = "Inmune",
    ["bt_miss_evade"]                    = "Evasión",
    ["bt_miss_deflect"]                  = "Desviado",
    ["bt_miss_reflect"]                  = "Reflejado",

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

    -- =====================
    -- HOUSING
    -- =====================






    -- =====================
    -- CONFIG: Diagnostics Panel
    -- =====================
    ["section_diagnostics"]              = "Diagn\195\179sticos",
    ["opt_diag_enabled"]                 = "Activar captura de errores",
    ["opt_diag_capture_all"]             = "Capturar todos los addons",
    ["opt_diag_suppress_popups"]         = "Suprimir ventanas de error",
    ["opt_diag_auto_open"]               = "Abrir auto. con error de TomoMod",
    ["btn_diag_open_console"]            = "Abrir consola",
    ["btn_diag_clear"]                   = "Borrar errores",
    ["btn_diag_export"]                  = "Copiar informe",
    ["btn_diag_export_tracker"]          = "Exportar para Tracker",
    ["info_diag_desc"]                   = "Captura errores Lua en segundo plano sin ventanas emergentes en combate. /tmdiag para abrir la consola.",
    ["info_diag_session"]                = "Sesi\195\179n: #%d \226\128\148 %d errores capturados (%d TomoMod)",
    ["info_diag_capture_all_desc"]       = "Cuando est\195\161 desactivado, solo se capturan errores de TomoMod. Activa para capturar todos los errores de addons.",

    -- =====================
    -- HOUSING
    -- =====================
    ["cat_housing"]                  = "Housing",
    ["section_housing_general"]      = "Housing \226\128\148 General",
    ["section_housing_hover"]        = "Info decoraci\195\179n (hover)",
    ["section_housing_clock"]        = "Reloj del editor",
    ["section_housing_teleport"]     = "Teletransportaci\195\179n",
    ["section_housing_commands"]     = "Comandos",

    ["info_housing_desc"]            = "M\195\179dulo Housing: mejora el editor de casas y a\195\177ade atajos de teletransportaci\195\179n. Requiere Midnight / The War Within.",
    ["info_housing_hover"]           = "En el modo 'Decoraci\195\179n base', muestra nombre, coste de colocaci\195\179n y stock restante. Tambi\195\169n permite duplicar con tecla modificadora.",
    ["info_housing_clock"]           = "Muestra un reloj y registra el tiempo en el editor de casas. Clic derecho para cambiar entre anal\195\179gico y digital.",
    ["info_housing_teleport"]        = "Activa /tmf home: te teletransporta a tu casa o sales autom\195\161ticamente si est\195\161s de visita.",
    ["info_housing_commands"]        = "\226\128\162 /tmf home \226\128\148 teletransportarte a tu casa (o salir)\n\226\128\162 /tmf housing \226\128\148 abrir este panel\n\226\128\162 Clic derecho en el reloj \226\128\148 cambiar anal\195\179gico/digital",

    ["opt_housing_enable"]           = "Activar m\195\179dulo Housing",
    ["opt_housing_decorhover"]       = "Activar info decoraci\195\179n",
    ["opt_housing_dupe"]             = "Activar duplicaci\195\179n r\195\161pida (modificador)",
    ["opt_housing_dupekey"]          = "Tecla de duplicaci\195\179n",
    ["opt_housing_clock"]            = "Activar reloj",
    ["opt_housing_clock_analog"]     = "Modo anal\195\179gico (si no, digital)",
    ["opt_housing_teleport"]         = "Activar teletransportaci\195\179n /tmf home",

    ["btn_housing_tp_home"]          = "Teletransportar (prueba)",
    ["btn_housing_refresh"]          = "Actualizar casas",

    ["housing_duplicate"]            = "Duplicar",
    ["housing_alliance_zone"]        = "Promontorio del Fundador",
    ["housing_horde_zone"]           = "Costas de Viento Filo",
    ["housing_clock_title"]          = "TomoMod \226\128\148 Reloj",
    ["housing_clock_time"]           = "Hora",
    ["housing_clock_local"]          = "Hora local:",
    ["housing_clock_realm"]          = "Hora del reino:",
    ["housing_clock_time_spent"]     = "Tiempo en el editor",
    ["housing_clock_session"]        = "Esta sesi\195\179n:",
    ["housing_clock_total"]          = "Total:",
    ["housing_clock_rightclick"]     = "Clic derecho para cambiar anal\195\179gico / digital",

    ["msg_help_home"]                = "Teletransportarte a tu casa (o salir)",
    ["msg_help_housing"]             = "Abrir el panel Housing",
    ["msg_housing_refresh"]          = "Informaci\195\179n de casas solicitada.",
    ["msg_housing_unavailable"]      = "M\195\179dulo Housing no disponible en este cliente.",

    -- ═══════════════════════════════════
    -- Merchant Tools (2.9.9)
    -- ═══════════════════════════════════

    ["tab_qol_merchant_tools"]           = "Herramientas vendedor",

    ["section_already_known"]            = "Ya conocido",
    ["info_already_known"]               = "Atenúa o tinta los artículos del vendedor/recompra que ya posees (monturas, mascotas, juguetes, conjuntos de transmog, recetas).",
    ["opt_ak_enable"]                    = "Activar Ya conocido",
    ["opt_ak_mode"]                      = "Modo de visualización",
    ["ak_mode_mono"]                     = "Monocromático (gris)",
    ["ak_mode_color"]                    = "Tinte de color",
    ["opt_ak_color"]                     = "Color del tinte",

    ["section_extend_pages"]             = "Páginas de vendedor extendidas",
    ["info_extend_pages"]                = "Añade columnas extra a la ventana del vendedor.\nRequiere recargar la interfaz tras activar o cambiar el número de columnas.",
    ["opt_ep_enable"]                    = "Activar páginas extendidas",
    ["opt_ep_columns"]                   = "Número de columnas",

    ["preset_complet_name"]  = "Recomendado",
    ["preset_complet_tag"]   = "La experiencia TomoMod completa",
    ["preset_complet_desc"]  = "Activa todos los módulos principales con valores predeterminados sensatos: UnitFrames, marcos de grupo y banda, Nameplates, barras de lanzamiento, recursos, skin de barras de acción, todos los skins visuales, herramientas Mythic+ y las funciones de comodidad más útiles. El mejor punto de partida para la mayoría.",
    ["preset_tank_name"]     = "Tank",
    ["preset_tank_tag"]      = "Centrado en amenaza, Nameplates más anchas",
    ["preset_tank_desc"]     = "La configuración Recomendada, ajustada para tanquear: Nameplates coloreadas por amenaza (Modo Tank) y un poco más anchas para leer mejor la aggro, además del indicador de amenaza en el objetivo.",
    ["preset_healer_name"]   = "Sanador",
    ["preset_healer_tag"]    = "Marcos de banda más grandes, maná visible",
    ["preset_healer_desc"]   = "La configuración Recomendada, ajustada para sanar: marcos de banda y grupo más grandes y fáciles de clicar, con barras de recurso (maná) visibles, seguimiento de HoTs, resaltado de disipación y defensivos bien a la vista.",
    ["preset_dps_name"]      = "DPS",
    ["preset_dps_tag"]       = "Recursos y cooldowns destacados",
    ["preset_dps_desc"]      = "La configuración Recomendada, ajustada para daño: una barra de recursos más visible, seguimiento de buffs del objetivo para defensivos enemigos y Nameplates limpias sin coloración de amenaza de tank.",
    ["preset_minimal_name"]  = "Mínimo",
    ["preset_minimal_tag"]   = "Solo lo esencial",
    ["preset_minimal_desc"]  = "Una huella ligera: mantiene UnitFrames, marcos de grupo y banda, barras de lanzamiento, barras de recursos, el minimapa y las automatizaciones esenciales — todo lo cosmético (skins, chat, bolsas, Nameplates, paneles extra) queda desactivado. Lo más parecido a una sensación vanilla.",
    ["preset_custom_name"]   = "Personalizado",
    ["preset_custom_tag"]    = "Configúralo todo tú mismo",
    ["preset_custom_desc"]   = "Omite los presets y recorre cada categoría paso a paso para activar exactamente lo que quieras. Siempre puedes cambiar cualquier cosa después desde /tmf.",
    ["preset_applied"]       = "Preset aplicado: %s — escribe /reload para ver el resultado.",
    ["preset_unknown"]       = "Preset desconocido « %s ». Disponibles: complet, tank, healer, dps, minimal.",
    ["preset_usage"]         = "Uso: /tmpreset <complet|tank|healer|dps|minimal>",
    ["ins_v3_welcome_desc"]      = "¡Bienvenido! Este asistente rápido te deja una interfaz limpia y completa en segundos.\n\nElige una configuración acorde a tu forma de jugar — podrás ajustarlo todo después desde |cffffd100/tmf|r. ¿Prefieres elegir cada opción tú mismo? Elige |cffc89530Personalizado|r.",
    ["ins_pick_title"]           = "Elige tu configuración",
    ["ins_pick_subtitle"]        = "Selecciona un estilo de juego abajo. Todo queda ajustable después vía /tmf.",
    ["ins_pick_recommended"]     = "Recomendado",
    ["ins_custom_frames_title"]  = "Marcos",
    ["ins_custom_barsskins_title"] = "Barras y Skins",
    ["ins_custom_mythicqol_title"] = "Mythic+ y Comodidad",
    ["ins_custom_frames_intro"]  = "Activa los marcos que quieras. Las opciones sensatas vienen preseleccionadas.",
    ["ins_custom_barsskins_intro"] = "Skin de barras de acción y skins visuales de chat, bolsas, tooltips y más.",
    ["ins_custom_mythicqol_intro"] = "Herramientas Mythic+, extras de interfaz, automatizaciones y sonido.",
    ["ins_recap_title"]          = "Todo listo",
    ["ins_recap_preset"]         = "Configuración aplicada: |cffffd100%s|r",
    ["ins_recap_custom"]         = "Tu configuración personalizada está lista",
    ["ins_recap_desc"]           = "Recarga tu interfaz para aplicarlo todo. Puedes reabrir este asistente cuando quieras con |cffffd100/tmf install|r, y abrir el panel de configuración completo con |cffffd100/tmf|r.",
    ["cat_accueil"]              = "Inicio",
    ["ui_search_placeholder"]    = "Buscar ajuste...",
    ["dash_welcome"]             = "Vista rápida de TomoMod. Activa módulos, aplica una configuración, cambia de perfil o relanza el asistente.",
    ["dash_modules_section"]     = "Módulos",
    ["dash_quickcfg_section"]    = "Configuración rápida",
    ["dash_studio_section"]           = "Cooldown Studio",
    ["dash_studio_info"]              = "Editor a pantalla completa de las barras de reutilizaci\195\179n: disposici\195\179n, estilo, hechizos y visibilidad.",
    ["dash_studio_open"]              = "Abrir el Cooldown Studio",
    ["dash_profile_section"]     = "Perfil",
    ["dash_maint_section"]       = "Mantenimiento",
    ["dash_reload_hint"]         = "Los módulos se aplican en directo. Los cambios protegidos se aplican automáticamente al terminar el combate.",
    ["dash_reload_now"]          = "Recargar ahora",
    ["dash_apply_preset"]        = "Preset de configuración",
    ["dash_apply_preset_btn"]    = "Aplicar este preset",
    ["dash_apply_preset_info"]   = "Aplicar un preset reinicia qué módulos están activados o no, y luego recarga.",
    ["dash_active_profile"]      = "Perfil activo",
    ["dash_manage_profiles"]     = "Gestionar perfiles",
    ["dash_profile_info"]        = "Cambiar de perfil recarga la interfaz para aplicarlo.",
    ["dash_relaunch_info"]       = "Reabre el asistente de configuración « presets primero ».",
    ["dash_mod_resources"]       = "Recursos",
    ["dash_mod_cdm"]             = "Cooldown Manager",
    ["dash_mod_abskin"]          = "Skin de barras de acción",
    ["dash_mod_chatskin"]        = "Skin del chat",
    ["dash_mod_bagskin"]         = "Skin de bolsas",
    ["dash_mod_mtracker"]        = "Rastreador Mythic+",
    ["dash_mod_score"]           = "Puntuación Mythic+",
    ["dash_reload_popup"]        = "¿Recargar la interfaz ahora para aplicar tus cambios?",

    -- ═══════════════════════════════════
    -- MythicTracker Nombres EJ (2.9.10)
    -- ═══════════════════════════════════
    -- ═══════════════════════════════════
    -- Corrección CD PartyFrame + Rendimiento (2.9.12)
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
    -- Correcciones CooldownManager / ProcGlow / BuffSkin (2.9.11)
    -- ═══════════════════════════════════

    -- ═══════════════════════════════════
    -- MythicTracker Nombres EJ (2.9.10)
    -- ═══════════════════════════════════

    -- Player Auras Mover (v2.9.5)
    ["mover_player_auras"]       = "Auras del jugador",
    ["opt_auras_spacing"]        = "Espaciado entre iconos",
    ["btn_reset_aura_position"]  = "Restablecer posición de auras",

    -- Module Reload Safety (v2.9.21)
    ["msg_module_reload"]        = "Este cambio requiere recargar la interfaz.\n¿Recargar ahora?",
    ["info_module_reload"]       = "Requiere /reload para aplicarse.",

    -- Waypoint Arrow Reversed (v2.9.22)

    -- 3.0.3
    -- 3.0.4

    -- 3.0.3

    -- 3.0.0

    -- 3.0.5

    -- =====================
    -- Extra Action Button (v3.0.6)
    -- =====================
    ["mover_ab_extra"] = "Acción extra",
    ["mover_ab_pet"] = "Barra de mascota",
    ["mover_ab_stance"] = "Barra de posturas",
    ["section_extra_button"] = "Botón de acción extra",
    ["opt_extra_enabled"] = "Gestionar el botón de acción extra (recarga para liberar)",
    ["opt_extra_scale"] = "Escala del botón extra",
    ["btn_extra_reset_pos"] = "Restablecer posición",
    ["info_extra_button"] = "Coloca el botón de acción extra en el modo Diseño. Aparece durante misiones y encuentros. Al desactivarlo se devuelve a Blizzard tras un /reload.",
    -- 3.0.7

    -- 3.1.1
    ["art_searching"]        = "Buscando: %s",
    ["art_searching_qty"]    = "Buscando: %s × %d",

    -- 3.1.2

    -- 3.1.3

    -- Anclaje del tooltip
    ["opt_tooltip_anchor"]        = "Posición del tooltip",
    ["tooltip_anchor_default"]    = "Predeterminado",
    ["tooltip_anchor_cursor"]     = "Cursor",
    ["tooltip_anchor_corner"]     = "Esquina de pantalla",
    ["tooltip_anchor_custom"]     = "Personalizado",
    ["opt_tooltip_anchor_corner"] = "Esquina (modo Esquina)",
    ["corner_br"]                 = "Inferior derecha",
    ["corner_bl"]                 = "Inferior izquierda",
    ["corner_tr"]                 = "Superior derecha",
    ["corner_tl"]                 = "Superior izquierda",
    ["info_tooltip_anchor"]       = "Personalizado: selecciona este modo y arrastra el marco teal a la posición deseada.",
    ["btn_tooltip_toggle_anchor"] = "Mostrar/Ocultar el ancla",
    ["mover_tooltip_anchor"]      = "Ancla del tooltip",

    -- Nameplates preview
    ["np_preview_title"]   = "Vista previa de placas",
    ["np_preview_hint"]    = "Legibilidad rápida: color, conjuro, auras y amenaza en un solo lugar.",
    ["preview_np_friendly"] = "Aliado",
    ["preview_np_target"]  = "Objetivo hostil",
    ["preview_np_boss"]    = "Jefe marcado",

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
    ["cat_interface"]         = "Interfaz",
    ["cat_units"]             = "Unidades",
    ["cat_combat"]            = "Combate",
    ["cat_comfort"]           = "Comodidad",
    ["cat_tools"]             = "Herramientas",
    ["cat_accueil_desc"]      = "Resumen, preajustes y acciones rápidas.",
    ["cat_interface_desc"]    = "Apariencia global, barras, sonidos y ventanas de Blizzard.",
    ["cat_units_desc"]        = "Jugador, nameplates, grupo y banda en un solo lugar.",
    ["cat_combat_desc"]       = "Lanzamientos, recursos, cooldowns y Mythic+.",
    ["cat_comfort_desc"]      = "Automatizaciones, misiones, AFK, housing y comodidad.",
    ["cat_changelog"]                 = "Novedades",
    ["cat_changelog_desc"]            = "Todas las notas de versi\195\179n, de la m\195\161s reciente a la m\195\161s antigua.",
    ["cl_title"]                      = "Notas de versi\195\179n",
    ["cl_intro"]                      = "%d versiones. Haz clic en un n\195\186mero para leer sus notas.",
    ["cl_unavailable"]                = "No se han podido cargar las notas de versi\195\179n.",
    ["cat_tools_desc"]        = "Perfiles, copias de seguridad, diagnósticos y mantenimiento.",
    ["cat_profiles_desc"]     = "Perfiles, especializaciones, importar / exportar y reinicios.",
    ["cat_diagnostics_desc"]  = "Estado en vivo, errores de Lua y medidas de rendimiento.",
    ["cat_damagemeter"]                 = "Medidor de da\195\177o",
    ["cat_damagemeter_desc"]            = "Medidor de da\195\177o, resumen de muerte y resumen de mazmorra.",
    ["dm_cfg_title"]                    = "Medidor de da\195\177o",
    ["dm_cfg_intro"]                    = "El medidor conserva por ahora su propia ventana de ajustes. Se integrar\195\161 aqu\195\173 pr\195\179ximamente.",
    ["dm_cfg_open"]                     = "Abrir los ajustes del medidor",
    ["dm_cfg_toggle"]                   = "Mostrar / ocultar las ventanas",
    ["dm_cfg_standalone"]               = "El addon TomoDamageMeter independiente est\195\161 instalado y gestiona el medidor. El m\195\179dulo integrado permanece inactivo.",
    ["dm_cfg_unavailable"]              = "El medidor de da\195\177o de Blizzard no est\195\161 disponible en este cliente, el m\195\179dulo est\195\161 inactivo.",
    ["cfg_tab_general"]       = "General",
    ["cfg_tab_actionbars"]    = "Barras de acción",
    ["cfg_tab_skins"]         = "Skins",
    ["cfg_tab_sound"]         = "Sonido",
    ["cfg_tab_unitframes"]    = "UnitFrames",
    ["cfg_tab_nameplates"]    = "Nameplates",
    ["cfg_tab_partyframes"]   = "Grupo",
    ["cfg_tab_raidframes"]    = "Raid",
    ["cfg_tab_castbars"]      = "Barras de lanzamiento",
    ["cfg_tab_resources"]     = "CD y Recursos",
    ["cfg_tab_mythicplus"]    = "Mythic+",
    ["cfg_tab_qol"]           = "Calidad de vida",
    ["cfg_tab_housing"]       = "Housing",
    ["cfg_tab_profiles"]      = "Perfiles",
    ["cfg_tab_diagnostics"]   = "Diagnósticos",
    ["cfg_reload_text"]       = "¿Recargar la interfaz para aplicar este cambio?",
    ["cfg_reload_confirm"]    = "Recargar",
    ["cfg_reload_later"]      = "Más tarde",
    ["cfg_footer_perf"]       = "FPS: %d  |  Mem.: %s",
    -- =====================
    -- CONFIG: CD/Resource & Profiles panels [Lot D2]
    -- =====================
    ["section_cdm_alpha"]             = "Opacidad",
    ["opt_rb_primary_centered"]       = "Mostrar recurso principal en el centro de la pantalla",
    ["info_rb_primary_centered"]      = "Mueve la barra de maná/energía/furia del marco del jugador al centro de la pantalla.",
    ["opt_rb_primary_power_height"]   = "Altura de la barra principal",
    ["import_preview_analyzing"]      = "Analizando...",
    ["profiles_export_failed"]        = "Error al exportar",
    ["profiles_import_failed"]        = "Error al importar",
    ["profiles_error"]                = "Error",
    ["profiles_rename_failed"]        = "Error al renombrar",
    -- =====================
    -- CONFIG: General panel — minimap & buttonbag [Lot D3]
    -- =====================
    ["section_minimap_indicators"]    = "Indicadores del minimapa",
    ["info_minimap_indicators"]       = "Elige un indicador y luego define su esquina, tamaño y desplazamiento. Se aplica al instante.",
    ["opt_indicator"]                 = "Indicador",
    ["opt_corner"]                    = "Esquina",
    ["opt_offset_x"]                  = "Desplazamiento X",
    ["opt_offset_y"]                  = "Desplazamiento Y",
    ["corner_topleft"]                = "Arriba izquierda",
    ["corner_topright"]               = "Arriba derecha",
    ["corner_bottomleft"]             = "Abajo izquierda",
    ["corner_bottomright"]            = "Abajo derecha",
    ["opt_minimap_tracking"]          = "Botón de rastreo",
    ["opt_tracking_style"]            = "Estilo del botón de rastreo",
    ["opt_minimap_mail"]              = "Correo",
    ["opt_minimap_difficulty"]        = "Dificultad",
    ["opt_minimap_expansion"]         = "Botón de expansión",
    ["opt_minimap_crafting"]          = "Pedidos de fabricación",
    ["minimap_style_bliz"]            = "Blizzard",
    ["minimap_style_tomo"]            = "TomoMod",
    ["section_buttonbag"]             = "Botones de addons",
    ["info_buttonbag"]                = "Recoge los botones de addons del minimapa en una bolsa. Haz clic en el botón del minimapa para abrirla.",
    ["opt_buttonbag_enable"]          = "Activar el recolector",
    ["opt_collector_style"]           = "Estilo del recolector",
    ["collector_style_bliz"]          = "Blizzard (nativo)",
    ["collector_style_tomo"]          = "TomoMod (bolsa)",
    ["opt_buttonbag_anchor"]          = "Posición del botón",
    ["buttonbag_anchor_corner"]       = "En el minimapa (esquina)",
    ["buttonbag_anchor_clockl"]       = "A la izquierda del reloj",
    ["buttonbag_anchor_clockr"]       = "A la derecha del reloj",
    ["opt_buttonbag_columns"]         = "Columnas",
    ["opt_buttonbag_iconsize"]        = "Tamaño de icono",
    ["btn_buttonbag_rescan"]          = "Volver a buscar botones",
    -- =====================
    -- CONFIG: Remaining panels [Lot D4]
    -- =====================
    ["btn_bar_uniformize"]            = "Copiar el aspecto de esta barra a todas las barras",
    ["info_bar_uniformize"]           = "Copia el aspecto (tamaño, espaciado, columnas, transparencia, escala, desvanecido, textos…) a todas las demás barras. La posición y el estado de activación de cada barra se conservan.",
    ["opt_bar_hotkey_size"]           = "Tamaño de fuente de la tecla rápida",
    ["popup_ab_uniformize"]           = "¿Copiar el aspecto de la barra «%s» a todas las demás barras?",
    ["info_cb_anchor_uf"]             = "Esta barra de lanzamiento se ancla a su marco de unidad correspondiente (por lo que aparece en el marco de objetivo/foco/mascota/jefe).",
    ["tab_qol_compass"]               = "Brújula",
    ["section_compass"]               = "Barra de brújula",
    ["info_compass_desc"]             = "Una barra de rumbo en la parte superior de la pantalla que muestra N/E/S/O al girar, con un marcador que apunta hacia tu misión rastreada o el punto de ruta del mapa. Solo lectura, sin taint.",
    ["info_compass_layout"]           = "Consejo: usa el modo Layout (/tmf layout) para arrastrar la barra donde quieras.",
    ["opt_compass_enable"]            = "Activar barra de brújula",
    ["opt_compass_fov"]               = "Campo de visión",
    ["compass_fov_narrow"]            = "Estrecho (±45°)",
    ["compass_fov_standard"]          = "Estándar (±60°)",
    ["compass_fov_wide"]              = "Amplio (±90°)",
    ["opt_compass_width"]             = "Ancho de la barra",
    ["opt_compass_height"]            = "Altura de la barra",
    ["opt_compass_scale"]             = "Escala",
    ["opt_compass_show_heading"]      = "Mostrar lectura de rumbo (p. ej. 245° SO)",
    ["opt_compass_show_distance"]     = "Mostrar distancia en los marcadores",
    ["opt_compass_show_quest"]        = "Mostrar marcador de misión rastreada",
    ["opt_compass_show_waypoint"]     = "Mostrar marcador de punto de ruta del mapa",
    ["opt_skyride_ground_speed"]      = "Mostrar velocidad en tierra",
    ["info_skyride_ground_speed"]     = "Muestra también tu velocidad de movimiento en tierra (los indicadores de vuelo permanecen ocultos mientras no vuelas).",
    ["btn_class_reminder_preview"]    = "Vista previa",
    ["sublabel_class_reminder_coverage"] = "— Aumentos y formas seguidos —",
    ["opt_char_skin_movable"]         = "Ventana movible",
    ["info_char_skin_movable"]        = "Una vez activado, arrastra la ventana de Personaje para moverla. Su posición se recuerda.",
    ["btn_char_skin_reset_pos"]       = "Restablecer posición",
    ["btn_sound_test"]                = "▶ Reproducir este sonido",
    ["opt_auras_max_width"]           = "Ancho máximo (ajuste de línea)",
    ["opt_auras_per_row"]             = "Iconos por fila",

    -- 3.2.0
    ["cfg_tab_cdforge"]           = "Cooldowns",

    -- 3.2.1

    -- 3.2.2
    -- Soportes del Cooldown Manager (Movers / modo disposición)
    ["mover_cdm"]                        = "Cooldown Manager",
    ["cdm_drag_hint"]                    = "Arrastra para mover",
    ["cdm_preview_aura"]                 = "Aura",




    -- =====================
    -- Traducciones que faltaban -- these keys previously fell back to enUS
    -- =====================
    ["opt_cursor_ring_texture"]           = "Textura",
    ["cursor_tex_ring"]                   = "Anillo",
    ["cursor_tex_glow"]                   = "Resplandor",
    ["cursor_tex_cygle"]                  = "Cygle",
    ["cursor_tex_heart"]                  = "Corazón",
    ["opt_cdm_custom_cd_swipe"]           = "Color de barrido de reutilización personalizado",
    ["opt_cdm_cd_swipe_color"]            = "Color del barrido de reutilización",
    ["opt_cdm_cd_swipe_alpha"]            = "Opacidad del barrido de reutilización",
    ["section_cdm_advanced"]              = "Avanzado",
    ["opt_cdm_hide_gcd"]                  = "Ocultar el GCD",
    ["opt_cdm_desaturate"]                = "Desaturar durante la reutilización",
    ["opt_cdm_buff_alignment"]            = "Alineación de los beneficios",
    ["align_center_outward"]              = "Centro → hacia fuera",
    ["align_start"]                       = "Inicio (izquierda)",
    ["align_end"]                         = "Final (derecha)",
    ["section_cdm_visibility"]            = "Reglas de visibilidad",
    ["info_cdm_visibility"]               = "Reglas de ocultación con prioridad. Las condiciones «Mostrar» prevalecen sobre las condiciones «Ocultar».",
    ["opt_cdm_hide_mounted"]              = "Ocultar al ir montado",
    ["opt_cdm_hide_vehicle"]              = "Ocultar en vehículo",
    ["opt_cdm_hide_ooc"]                  = "Ocultar fuera de combate (sin objetivo)",
    ["opt_cdm_show_combat"]               = "Mostrar siempre en combate",
    ["opt_cdm_show_instance"]             = "Mostrar siempre en instancia",
    ["opt_cdm_show_enemy"]                = "Mostrar con objetivo enemigo",
    ["section_cdm_extras"]                = "Sonido / Pandemic / Alcance",
    ["opt_cdm_sound_alert"]               = "Sonido cuando el hechizo está listo",
    ["opt_cdm_sound_file"]                = "Archivo de sonido",
    ["opt_cdm_pandemic"]                  = "Pandemic (borde de renovación)",
    ["opt_cdm_pandemic_threshold"]        = "Umbral de Pandemic (%)",
    ["opt_cdm_range_check"]               = "Teñir de rojo fuera de alcance",
    ["ot_bucket_complete"]                = "Listas para entregar",
    ["ot_bucket_campaign"]                = "Campaña",
    ["ot_bucket_important"]               = "Importantes",
    ["ot_bucket_legendary"]               = "Legendarias",
    ["ot_bucket_weekly"]                  = "Semanales",
    ["ot_bucket_daily"]                   = "Diarias",
    ["ot_bucket_world"]                   = "Misiones del mundo",
    ["ot_bucket_dungeon"]                 = "Mazmorras",
    ["ot_bucket_raid"]                    = "Bandas",
    ["ot_bucket_profession"]              = "Profesiones",
    ["ot_bucket_achievement"]             = "Logros",
    ["ot_bucket_quests"]                  = "Misiones",
    ["ot_bucket_other"]                   = "Otras",
    ["mover_minimap"]                     = "Minimapa y panel",
    ["mover_objectivetracker"]            = "Rastreador de objetivos",
    ["tab_skin_chatframeui"]              = "Interfaz de chat",
    ["sublabel_chatframeui"]              = "— Interfaz de chat multiposición —",
    ["opt_cfui_enable"]                   = "Activar la interfaz de chat",
    ["opt_cfui_enable_desc"]              = "Añade contenedores decorativos, una barra de botones, iconos laterales y el cambio de diseño (estilo MayronUI).",
    ["opt_cfui_frame_topleft"]            = "Marco superior izquierdo",
    ["opt_cfui_frame_topright"]           = "Marco superior derecho",
    ["opt_cfui_frame_bottomleft"]         = "Marco inferior izquierdo",
    ["opt_cfui_frame_bottomright"]        = "Marco inferior derecho",
    ["opt_cfui_show_tab_bar"]             = "Mostrar la barra de pestañas",
    ["opt_cfui_tab_bar_offset"]           = "Desplazamiento Y de la barra de pestañas",
    ["opt_cfui_window_offset"]            = "Desplazamiento Y de la ventana",
    ["opt_cfui_x_offset"]                 = "Desplazamiento X",
    ["opt_cfui_y_offset"]                 = "Desplazamiento Y",
    ["opt_cfui_icons_anchor"]             = "Anclaje de los iconos laterales",
    ["opt_cfui_raid_frame_mgr"]           = "Rediseñar el gestor de marcos de banda",
    ["opt_cfui_editbox_position"]         = "Posición del cuadro de texto",
    ["opt_cfui_editbox_height"]           = "Altura del cuadro de texto",
    ["opt_cfui_swap_in_combat"]           = "Permitir el cambio de botones en combate",
    ["cfui_show_chat_menu"]               = "Mostrar el menú de chat",
    ["cfui_show_professions"]             = "Mostrar las profesiones",
    ["cfui_show_shortcuts"]               = "Mostrar los accesos directos de addons",
    ["cfui_copy_chat"]                    = "Copiar el texto del chat",
    ["cfui_click_toggle_status"]          = "Haz clic para alternar AFK",
    ["cfui_layout_button"]                = "Diseño TomoMod",
    ["cfui_left_click"]                   = "Clic izquierdo:",
    ["cfui_switch_layout"]                = "Cambiar de diseño",
    ["cfui_no_layouts"]                   = "No hay diseños guardados. Usa /tmf layout save <nombre>",
    ["cfui_no_professions"]               = "No tienes profesiones.",
    ["cfui_config_menu"]                  = "Configuración",
    ["cfui_profiles"]                     = "Perfiles",
    ["cfui_clear_chat"]                   = "Limpiar el chat",
    ["cfui_reload_ui"]                    = "Recargar la interfaz",
    ["cfui_btn_character"]                = "Personaje",
    ["cfui_btn_bags"]                     = "Bolsas",
    ["cfui_btn_friends"]                  = "Amigos",
    ["cfui_btn_guild"]                    = "Hermandad",
    ["cfui_btn_help"]                     = "Menú de ayuda",
    ["cfui_btn_pvp"]                      = "JcJ",
    ["cfui_btn_spellbook"]                = "Libro de hechizos",
    ["cfui_btn_talents"]                  = "Talentos",
    ["cfui_btn_achievements"]             = "Logros",
    ["cfui_btn_calendar"]                 = "Calendario",
    ["cfui_btn_lfd"]                      = "Buscar mazmorra",
    ["cfui_btn_raid"]                     = "Banda",
    ["cfui_btn_encounter"]                = "Guía de aventuras",
    ["cfui_btn_collections"]              = "Colecciones",
    ["cfui_btn_macros"]                   = "Macros",
    ["cfui_btn_worldmap"]                 = "Mapa del mundo",
    ["cfui_btn_questlog"]                 = "Registro de misiones",
    ["cfui_btn_reputation"]               = "Reputación",
    ["cfui_btn_pvpscore"]                 = "Puntuación JcJ",
    ["cfui_btn_currency"]                 = "Moneda",
    ["btn_abs_layout"]                    = "EditMode (/tmf layout)",
    ["opt_bar_enabled"]                   = "Activada",
    ["opt_bar_orientation"]               = "Orientación",
    ["opt_bar_grow_dir"]                  = "Dirección de crecimiento",
    ["opt_bar_columns"]                   = "Columnas",
    ["opt_bar_button_size"]               = "Tamaño de los botones",
    ["opt_bar_spacing"]                   = "Espaciado",
    ["opt_bar_alpha"]                     = "Transparencia",
    ["opt_bar_scale"]                     = "Escala",
    ["opt_bar_display_cond"]              = "Condición de visualización",
    ["opt_bar_fade"]                      = "Activar el desvanecimiento",
    ["opt_bar_fade_out_alpha"]            = "Transparencia al desvanecer",
    ["opt_bar_fade_out_delay"]            = "Retardo antes de desvanecer",
    ["opt_bar_fade_out_dur"]              = "Duración del desvanecimiento",
    ["opt_bar_fade_in_dur"]               = "Duración de la aparición",
    ["opt_bar_click_through"]             = "Ignorar clics",
    ["opt_bar_show_empty"]                = "Mostrar los botones vacíos",
    ["opt_bar_show_hotkey"]               = "Mostrar el texto de los atajos",
    ["opt_bar_disabled"]                  = "Desactivada",
    ["bar_name_bar1"]                     = "Barra 1 (principal)",
    ["bar_name_bar2"]                     = "Barra 2",
    ["bar_name_bar3"]                     = "Barra 3",
    ["bar_name_bar4"]                     = "Barra 4",
    ["bar_name_bar5"]                     = "Barra 5",
    ["bar_name_bar6"]                     = "Barra 6",
    ["bar_name_bar7"]                     = "Barra 7",
    ["bar_name_bar8"]                     = "Barra 8",
    ["bar_name_pet"]                      = "Barra de mascota",
    ["bar_name_stance"]                   = "Barra de actitud",
    ["pf_opt_name_max_length"]            = "Máx. de letras del nombre (0 = sin límite)",
    ["tab_qol_consumable_bar"]            = "Consumibles",
    ["section_consumable_bar"]            = "Barra de consumibles",
    ["info_cb_desc"]                      = "Muestra un icono y un temporizador por cada consumible activo: frasco (1 h), bien alimentado (1 h) y aceite de arma (2 h). La casilla del aceite de la mano izquierda solo aparece si llevas un arma equipada en ella.",
    ["opt_consumable_enable"]             = "Activar la barra de consumibles",
    ["opt_cb_show_missing"]               = "Mostrar los beneficios ausentes (atenuados)",
    ["opt_cb_icon_size"]                  = "Tamaño de los iconos",
    ["opt_cb_gap"]                        = "Separación entre iconos",
    ["opt_cb_orientation"]                = "Orientación",
    ["cb_orient_horizontal"]              = "Horizontal",
    ["cb_orient_vertical"]                = "Vertical",
    ["opt_cb_timer_pos"]                  = "Posición del temporizador",
    ["cb_timerpos_below"]                 = "Debajo (horizontal)",
    ["cb_timerpos_above"]                 = "Encima (horizontal)",
    ["cb_timerpos_right"]                 = "Derecha (vertical)",
    ["cb_timerpos_left"]                  = "Izquierda (vertical)",
    ["mover_consumable_bar"]              = "Barra de consumibles",
    ["mover_class_reminder"]              = "Aviso de clase",
    ["art_title"]                         = "Rastreador de recetas",
    ["art_no_recipes"]                    = "No hay recetas rastreadas — rastrea una receta en la ventana de profesión.",
    ["art_status_idle"]                   = "Haz clic en un ingrediente para buscarlo en la casa de subastas.",
    ["art_scan_btn"]                      = "Escanear la casa de subastas",
    ["art_scan_running"]                  = "Escaneando...",
    ["art_scan_started"]                  = "Escaneo iniciado — espera, por favor...",
    ["art_scan_done"]                     = "Escaneo finalizado: %d objetos registrados.",
    ["art_scan_failed"]                   = "El escaneo falló o se interrumpió.",
    ["art_scan_cooldown"]                 = "Próximo escaneo disponible en %dm %ds.",
    ["art_scan_tip_title"]                = "Escaneo completo de la casa de subastas",
    ["art_scan_tip_desc"]                 = "Registra la compra directa más baja por objeto. Limitado a una vez cada 15 minutos.",
    ["art_only_at_ah"]                    = "Abre primero la casa de subastas.",
    ["art_scan_already"]                  = "Ya hay un escaneo en curso.",
    ["art_tt_stack"]                      = "Montón",
    ["art_tt_scanned"]                    = "Escaneado",
    ["art_tt_just_now"]                   = "ahora mismo",
    ["art_tt_min_ago"]                    = "hace %dm",
    ["art_tt_hour_ago"]                   = "hace %dh",
    ["art_tt_day_ago"]                    = "hace %dd",
    ["tab_qol_rare_alert"]                = "Alerta de raros",
    ["section_rare_alert"]                = "Alerta de raros",
    ["opt_rare_alert_enable"]             = "Activar las alertas de proximidad de raros",
    ["opt_rare_alert_sound"]              = "Reproducir un sonido de alerta",
    ["opt_rare_alert_duration"]           = "Duración del cartel (s)",
    ["btn_reset_rare_alert_pos"]          = "Restablecer la posición del cartel",
    ["rare_alert_info"]                   = "Te avisa cuando hay un PNJ raro cerca. Haz clic en el cartel para seleccionarlo, colocar el marcador de calavera y fijar un punto de ruta. Clic derecho para descartarlo. Usa /tmf layout para mover el cartel.",
    ["rare_alert_tooltip"]                = "Clic izquierdo: seleccionar + calavera + punto de ruta. Clic derecho: descartar.",

    -- =====================
    -- 3.3.2 — Novedades
    -- =====================

    -- =====================
    -- 3.3.3 — Novedades
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
    -- 3.5.7 — Novedades
    -- =====================

    -- =====================
    -- 3.5.5 — Novedades
    -- =====================

    -- =====================
    -- 3.5.4 — Novedades

    -- =====================
    -- 3.5.3 — Novedades

    -- 3.5.2 — Novedades
    -- =====================

    -- =====================
    -- 3.5.1 — Novedades
    -- =====================

    -- =====================
    -- 3.4.6 — Novedades
    -- =====================


    -- =====================
    -- 3.4.5 — Novedades
    -- =====================


    -- =====================
    -- 3.4.4 — Novedades
    -- =====================


    -- =====================
    -- 3.4.3 — Novedades
    -- =====================

    -- =====================
    -- 3.4.2 — Novedades
    -- =====================

    -- =====================
    -- 3.4.1 — Novedades
    -- =====================

    -- =====================
    -- 3.3.6 — Novedades
    -- =====================

    -- =====================
    -- 3.3.5 — Novedades
    -- =====================

    -- =====================
    -- 3.3.4 — Novedades
    -- =====================

    -- =====================
    -- QOL: Companion Status (recordatorio de mascota)
    -- =====================
    ["tab_qol_companion"]             = "Aviso de mascota",
    ["section_companion"]             = "Estado de la mascota",
    ["info_companion_desc"]           = "Muestra un aviso cuando tu mascota falta o está muerta. Solo aparece en especializaciones que realmente usan una: cazadores de Bestias y Supervivencia, todos los brujos y caballeros de la Muerte Profanos. Lobo solitario y Grimorio de sacrificio lo desactivan por sí solos.",
    ["info_companion_unavailable"]    = "El módulo aún no ha terminado de cargarse. Vuelve a abrir esta pestaña en un momento.",
    ["opt_companion_enable"]          = "Activar aviso de mascota",
    ["opt_companion_hide_mounted"]    = "Ocultar con montura terrestre",
    ["info_companion_travel"]         = "El aviso siempre se oculta al volar, en vuelo de taxi y en vehículos. Desactiva esto para seguir viéndolo en una montura terrestre.",
    ["opt_companion_display_mode"]    = "Visualización",
    ["companion_mode_icon"]           = "Icono",
    ["companion_mode_text"]           = "Texto",
    ["companion_mode_both"]           = "Ambos",
    ["opt_companion_scale"]           = "Escala",
    ["opt_companion_size"]            = "Tamaño del icono",
    ["sublabel_companion_pos"]        = "Posición",
    ["opt_companion_x"]               = "Desplazamiento horizontal",
    ["opt_companion_y"]               = "Desplazamiento vertical",
    ["btn_companion_reset_pos"]       = "Reiniciar posición",
    ["info_companion_slash"]          = "Comandos: /cs on, /cs off, /cs mounted, /cs debug.",
    ["companion_pet_missing"]         = "Falta la mascota",
    ["companion_pet_dead"]            = "Mascota muerta",

    -- ActionBars: Secure Visibility Engine
    ["Secure Visibility"] = "Visibilidad segura",
    ["Visibility Mode"] = "Modo de visibilidad",
    ["Always"] = "Siempre",
    ["In Combat"] = "En combate",
    ["Out of Combat"] = "Fuera de combate",
    ["Solo"] = "Solo",
    ["Party Only"] = "Solo grupo",
    ["Raid Only"] = "Solo banda",
    ["Any Instance"] = "Cualquier instancia",
    ["Mounted"] = "Montado",
    ["Has Target"] = "Con objetivo",
    ["Hostile Target"] = "Objetivo hostil",
    ["Hidden"] = "Oculto",
    ["Custom Condition"] = "Condición personalizada",
    ["Securely show or hide this bar based on game state. These rules keep working in combat without normal Lua Show/Hide calls."] = "Muestra u oculta esta barra de forma segura según el estado del juego. Estas reglas siguen funcionando en combate sin llamadas Lua normales a Show/Hide.",

    -- ActionBars: Secure Paging
    ["Secure Paging"] = "Paginación segura",
    ["Securely switch Action Bar 1 by modifier, target, form, skyriding, or manual page. Vehicle and override pages always keep priority."] = "Cambia de forma segura la barra de acción 1 según modificador, objetivo, forma, vuelo dinámico o página manual. Las páginas de vehículo y reemplazo siempre tienen prioridad.",
    ["Alt Modifier Page"] = "Página con Alt",
    ["Shift Modifier Page"] = "Página con Mayús",
    ["Ctrl Modifier Page"] = "Página con Ctrl",
    ["Friendly Target Page"] = "Página con objetivo amistoso",
    ["Hostile Target Page"] = "Página con objetivo hostil",
    ["Disable Automatic Form Paging"] = "Desactivar paginación automática de formas",
    ["Disable Automatic Skyriding Paging"] = "Desactivar paginación automática de vuelo dinámico",
    ["Default (no page switch)"] = "Predeterminado (sin cambio)",
    ["Action Bar 1"] = "Barra de acción 1",
    ["Action Bar 2"] = "Barra de acción 2",
    ["Action Bar 3"] = "Barra de acción 3",
    ["Action Bar 4"] = "Barra de acción 4",
    ["Action Bar 5"] = "Barra de acción 5",
    ["Action Bar 6"] = "Barra de acción 6",
    ["Action Bar 7"] = "Barra de acción 7",
    ["Action Bar 8"] = "Barra de acción 8",

    -- =====================
    -- HEALER STUDIO (advanced Party/Raid healer indicators)
    -- =====================
    ["btn_open_healerstudio"]    = "Abrir Healer Studio",
    ["info_healerstudio"]        = "Perfil avanzado: elige tus HoTs, escudos y beneficios de sanacion, y coloca cada icono libremente en la celda. Sustituye la fila superior cuando esta activo.",
    ["hs_list"]                  = "AURAS",
    ["hs_mode"]                  = "Perfil",
    ["hs_mode_party"]            = "Grupo",
    ["hs_mode_raid"]             = "Banda",
    ["hs_class"]                 = "Clase",
    ["hs_enable"]                = "Activar el perfil avanzado",
    ["hs_healer_only"]           = "Solo en una especializacion de sanador",
    ["hs_show_duration"]         = "Mostrar los segundos restantes",
    ["hs_show_duration_info"]    = "Desactivado, el icono conserva su barrido de tiempo y solo pierde el número de encima. Útil en iconos pequeños, donde las cifras tapan casi toda la imagen.",
    ["hs_mode_on"]               = "Perfil avanzado activo: la fila de HoTs clasica se oculta en estas celdas.",
    ["hs_mode_off"]              = "La fila de HoTs clasica sigue en uso mientras este perfil este desactivado.",
    ["hs_preset"]                = "Preajuste inicial",
    ["hs_reset_class"]           = "Restablecer esta clase",
    ["hs_reset_position"]        = "Restablecer la posicion",
    ["hs_select"]                = "Selecciona un aura en la lista para colocarla.",
    ["hs_size"]                  = "Tamano del icono",
    ["hs_anchor"]                = "Anclaje",
    ["hs_offset_x"]              = "Desplazamiento horizontal",
    ["hs_offset_y"]              = "Desplazamiento vertical",
    ["hs_hint"]                  = "Arrastra los iconos sobre la celda - los cambios se guardan al instante",
    ["hs_combat"]                = "la disposicion no se puede modificar en combate.",
    ["hs_cat_hot"]               = "HoT",
    ["hs_cat_shield"]            = "Escudo",
    ["hs_cat_beacon"]            = "Faro / vinculo",
    ["hs_cat_marker"]            = "Marcador de sanacion",
    ["hs_cat_external"]          = "Externo",

    -- Slash command output (Core/Init.lua, CooldownManager, UnitFrames)
    ["cli_after_combat"]       = "tras el combate",
    ["cli_reload_required"]    = "/reload necesario",
    ["cli_dependents_off"]     = "dependientes desactivados:",
    ["cli_deps_off"]           = "dependencias desactivadas:",
    ["cli_pending_reload"]     = "%s pendientes de /reload",
    ["cli_mod_live"]           = "%d en caliente",
    ["cli_mod_reload"]         = "%d con /reload",
    ["cli_mod_none"]           = "%d sin conmutador",
    ["cli_modules_hint"]       = "/tmf modules <clave> para alternar",
    ["cli_backup_created"]     = "copia de seguridad creada.",
    ["cli_backup_usage"]       = "/tmf backup save | /tmf backup restore [número]",
    ["cli_layout_usage"]       = "/tmf layout export|import <cadena>",
    ["cli_capture_failed"]     = "captura fallida",
    ["cli_res_counts"]         = "%d fuentes, %d anclajes",
    ["msg_help_install"]       = "Volver a abrir el asistente de configuración",
    ["msg_help_loot"]          = "Abrir el explorador de botín (mazmorras y bandas)",
    ["msg_cdm_placement_mode"] = "Modo de colocación",
    ["msg_cdm_live_preview"]   = "Vista previa en vivo",
    ["msg_uf_ouf_missing"]     = "Biblioteca oUF no encontrada (X-oUF: TomoMod_oUF).",

})
