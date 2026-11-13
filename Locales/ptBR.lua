-- =====================================
-- ptBR.lua — Português (Brasil)
-- =====================================

-- Perf: Lua builds the whole table constructor below before
-- TomoMod_RegisterLocale can decide to discard it. For a player on any other
-- locale that is ~2900 key/value pairs allocated and turned straight into
-- garbage, five files over, on every /reload. The chunk still compiles (the
-- TOC loads it), but the constructor never runs.
if GetLocale() ~= "ptBR" then return end

TomoMod_RegisterLocale("ptBR", {

    -- =====================
    -- CONFIG: Categories (ConfigUI.lua)
    -- =====================
    ["cat_general"]         = "Geral",
    ["cat_unitframes"]      = "UnitFrames",
    ["cat_nameplates"]      = "Nameplates",
    ["cat_cd_resource"]     = "CD e Recursos",
    ["cat_qol"]             = "Qualidade de vida",
    ["cat_mythicplus"]      = "Mythic+",
    ["cat_profiles"]        = "Perfis",
    ["cat_diagnostics"]     = "Diagn\195\179sticos",
    ["cat_housing"]         = "Housing",

    -- =====================
    -- CONFIG: General Panel
    -- =====================
    ["section_about"]                   = "Sobre",
    ["about_text"]                      = "|cffffd100TomoModForever|r %s por TomoAniki\nInterface leve com QOL, UnitFrames e Nameplates.\nDigite /tmf help para a lista de comandos.",
    ["section_general"]                 = "Geral",
    ["btn_reset_all"]                   = "Redefinir tudo",
    ["info_reset_all"]                  = "Isso redefinirá TODAS as configurações e recarregará a interface.",

    -- Minimap
    ["section_minimap"]                 = "Minimapa",
    ["opt_minimap_enable"]              = "Ativar minimapa personalizado",
    ["opt_size"]                        = "Tamanho",
    ["opt_scale"]                       = "Escala",
    ["opt_border"]                      = "Borda",
    ["border_class"]                    = "Cor da classe",
    ["border_black"]                    = "Preto",

    -- Info Panel
    ["section_info_panel"]              = "Painel de informações",
    ["opt_enable"]                      = "Ativar",
    ["opt_durability"]                  = "Durabilidade (Equipamento)",
    ["info_durability_position"]        = "Posição do texto de durabilidade — útil se um botão (ex. expansão) sobrepõe o canto padrão.",
    ["opt_durability_corner"]           = "Canto (durabilidade)",
    ["opt_time"]                        = "Hora",
    ["opt_24h_format"]                  = "Formato 24h",
    ["opt_show_coords"]                 = "Mostrar coordenadas",
    ["btn_reset_position"]              = "Redefinir posição",

    -- Cursor Ring
    ["section_cursor_ring"]             = "Anel do cursor",
    ["opt_class_color"]                 = "Cor da classe",
    ["opt_anchor_tooltip_ring"]         = "Ancorar tooltip ao cursor",

    -- =====================
    -- CONFIG: UnitFrames Panel
    -- =====================
    -- Tabs
    ["tab_general"]                     = "Geral",
    ["tab_player"]                      = "Jogador",
    ["tab_target"]                      = "Alvo",
    ["tab_tot"]                         = "AdA",
    ["tab_pet"]                         = "Pet",
    ["tab_focus"]                       = "Foco",
    ["tab_colors"]                      = "Cores",

    -- Sub-tabs (Player, Target, Focus)
    ["subtab_dimensions"]               = "Dimensões",
    ["subtab_display"]                  = "Exibição",
    ["subtab_auras"]                    = "Auras",
    ["subtab_positioning"]              = "Posição",

    -- Sub-labels
    ["sublabel_dimensions"]             = "— Dimensões —",
    ["sublabel_display"]                = "— Exibição —",
    ["sublabel_castbar"]                = "— Barra de lançamento —",
    ["sublabel_auras"]                  = "— Auras —",
    ["sublabel_element_offsets"]        = "— Posições dos elementos —",

    -- Unit display names
    ["unit_player"]                     = "Jogador",
    ["unit_target"]                     = "Alvo",
    ["unit_tot"]                        = "Alvo do alvo",
    ["unit_pet"]                        = "Pet",
    ["unit_focus"]                      = "Foco",

    -- General tab
    ["section_general_settings"]        = "Configurações gerais",
    ["opt_uf_enable"]                   = "Ativar UnitFrames do TomoMod",
    ["opt_hide_blizzard"]               = "Ocultar quadros da Blizzard",
    ["opt_global_font_size"]            = "Tamanho de fonte global",
    ["sublabel_font"]                   = "— Fonte —",
    ["opt_font_family"]                 = "Família de fonte",

    -- Castbar colors
    ["section_castbar_colors"]          = "Cores da barra de lançamento",
    ["info_castbar_colors"]             = "Personalize as cores da barra de lançamento para feitiços interrompíveis, não interrompíveis e interrompidos.",
    ["opt_castbar_color"]               = "Feitiço interrompível",
    ["opt_castbar_ni_color"]            = "Feitiço não interrompível",
    ["opt_castbar_interrupt_color"]     = "Feitiço interrompido",
    ["info_castbar_colors_reload"]      = "As mudanças de cor se aplicam a novos lançamentos. /reload para efeito completo.",
    ["btn_toggle_lock"]                 = "Bloquear/Desbloquear (/tmf uf)",
    ["info_unlock_drag"]                = "Desbloqueie para mover os quadros. As posições são salvas automaticamente.",

    -- Per-unit options
    ["opt_width"]                       = "Largura",
    ["opt_health_height"]               = "Altura de vida",
    ["opt_power_height"]                = "Altura de recurso",
    ["opt_show_name"]                   = "Mostrar nome",
    ["opt_name_truncate"]               = "Truncar nomes longos",
    ["opt_name_truncate_length"]        = "Comprimento máx. do nome",
    ["opt_show_level"]                  = "Mostrar nível",
    ["opt_show_health_text"]            = "Mostrar texto de vida",
    ["opt_health_format"]               = "Formato de vida",
    ["fmt_current"]                     = "Atual (25.3K)",
    ["fmt_percent"]                     = "Porcentagem (75%)",
    ["fmt_current_percent"]             = "Atual + % (25.3K | 75%)",
    ["fmt_current_max"]                 = "Atual / Máx",
    ["opt_class_color_uf"]              = "Cor da classe",
    ["opt_faction_color"]               = "Cor de facção (NPC)",
    ["opt_use_nameplate_colors"]        = "Cores de Nameplate (tipo de NPC)",
    ["opt_show_absorb"]                 = "Barra de absorção",
    ["opt_show_threat"]                 = "Indicador de ameaça (brilho de borda)",
    ["section_threat_text"]             = "Texto % de ameaça",
    ["opt_threat_text_enable"]          = "Mostrar % de ameaça no alvo",
    ["opt_threat_text_font_size"]       = "Tamanho de fonte",
    ["info_threat_text"]                = "Verde = tanqueando (vantagem), amarelo = aviso, vermelho = aggro perdido",
    ["opt_show_leader_icon"]            = "Ícone de líder",
    ["opt_leader_icon_x"]               = "Ícone de líder X",
    ["opt_leader_icon_y"]               = "Ícone de líder Y",
    ["opt_raid_icon_x"]                 = "Marcador de raid X",
    ["opt_raid_icon_y"]                 = "Marcador de raid Y",

    -- Castbar
    ["opt_castbar_enable"]              = "Ativar barra de lançamento",
    ["opt_castbar_width"]               = "Largura da barra de lançamento",
    ["opt_castbar_height"]              = "Altura da barra de lançamento",
    ["opt_castbar_show_icon"]           = "Mostrar ícone",
    ["opt_castbar_show_timer"]          = "Mostrar temporizador",
    ["info_castbar_drag"]               = "Posição: /tmf sr para desbloquear e mover a barra de lançamento.",
    ["btn_reset_castbar_position"]      = "Redefinir posição da barra de lançamento",
    ["opt_castbar_show_latency"]        = "Mostrar latência",

    -- Auras
    ["opt_auras_enable"]                = "Ativar auras",
    ["opt_auras_max"]                   = "Auras máximas",
    ["opt_auras_size"]                  = "Tamanho do ícone",
    ["opt_auras_type"]                  = "Tipo de aura",
    ["aura_harmful"]                    = "Debuffs (prejudiciais)",
    ["aura_helpful"]                    = "Buffs (benéficos)",
    ["aura_all"]                        = "Benefícios e penalidades",
    ["opt_auras_direction"]             = "Direção de crescimento",
    ["opt_auras_direction_v"]           = "Direção vertical",
    ["aura_dir_down"]                   = "Para baixo",
    ["aura_dir_up"]                     = "Para cima",
    ["aura_dir_right"]                  = "Para a direita",
    ["aura_dir_left"]                   = "Para a esquerda",
    ["opt_auras_only_mine"]             = "Apenas minhas auras",

    -- Element offsets
    ["elem_name"]                       = "Nome",
    ["elem_level"]                      = "Nível",
    ["elem_health_text"]                = "Texto de vida",
    ["elem_power"]                      = "Barra de recurso",
    ["elem_castbar"]                    = "Barra de lançamento",
    ["elem_auras"]                      = "Auras",
    ["elem_enemy_buffs"]                = "Bônus do alvo",

    -- AstralForge: element registry
    ["elem_raid_icon"]                  = "Marca de raide",
    ["elem_leader_icon"]                = "Ícone de líder",
    ["elem_threat_text"]                = "Texto de ameaça",
    ["elem_pet_happiness"]             = "Felicidade do ajudante",
    ["opt_element_anchor"]              = "Ancoragem",
    ["btn_reset_elements"]              = "Redefinir posição dos elementos",
    ["anchor_host_frame"]               = "Quadro",
    ["anchor_host_health"]              = "Barra de vida",
    ["anchor_host_power"]               = "Barra de recurso",
    ["anchor_host_infobar"]             = "Barra de informações",
    ["btn_open_astralforge"]            = "Abrir AstralForge",
    ["info_astralforge"]                = "AstralForge é o designer completo: arraste cada elemento diretamente sobre o quadro e escolha seu ponto de ancoragem e seu hospedeiro. Os controles abaixo continuam disponíveis para ajustes ao pixel.",
    ["target_kind_host"]                = "Estrutura: ",
    ["target_kind_element"]             = "Elemento: ",

    -- AstralForge : proprietes par element
    ["sublabel_element_props"]          = "Propriedades visuais",
    ["opt_element_alpha"]               = "Opacidade (%)",
    ["opt_element_scale"]               = "Escala (%)",
    ["opt_element_font_size"]           = "Forçar tamanho da fonte",
    ["info_element_font_size"]          = "Deixe em 0 para manter o tamanho calculado pelo módulo.",

    -- AstralForge : elements instancies
    ["elem_custom_text"]                = "Texto personalizado",
    ["opt_custom_text_template"]        = "Modelo de texto",
    ["info_custom_text_tokens"]         = "Marcadores disponíveis:",
    ["btn_add_custom_text"]             = "Adicionar um texto personalizado",
    ["btn_reset_element"]               = "Redefinir este elemento",
    ["btn_delete_element"]              = "Excluir este elemento",
    ["msg_element_max_reached"]         = "Número máximo de elementos deste tipo atingido.",

    -- AstralForge : presets de disposition
    ["section_forge_presets"]           = "Predefinições de layout",
    ["btn_forge_presets"]               = "Predefinições de layout",
    ["info_forge_presets"]              = "Uma predefinição guarda o layout completo do sujeito atual: ancoragens, propriedades visuais e elementos personalizados.",
    ["opt_preset_name"]                 = "Nome da predefinição",
    ["btn_preset_save"]                 = "Salvar / substituir",
    ["opt_preset_saved"]                = "Predefinições salvas",
    ["btn_preset_apply"]                = "Aplicar",
    ["btn_preset_delete"]               = "Excluir",
    ["btn_preset_export"]               = "Gerar código de compartilhamento",
    ["opt_preset_share_string"]         = "Código de compartilhamento",
    ["info_preset_copy"]                = "Clique no campo e use Ctrl+A e Ctrl+C para copiar.",
    ["opt_preset_import"]               = "Cole um código de compartilhamento",
    ["btn_preset_import"]               = "Importar",
    ["info_no_preset"]                  = "Nenhuma predefinição salva para este sujeito.",
    ["msg_preset_saved"]                = "Predefinição salva.",
    ["msg_preset_applied"]              = "Predefinição aplicada.",
    ["msg_preset_imported"]             = "Predefinição importada:",
    ["msg_preset_error"]                = "A operação com a predefinição falhou.",
    ["msg_presets_unavailable"]         = "As predefinições de layout não estão disponíveis.",
    ["token_classification"]            = "Classificação",
    ["token_name"]                      = "Nome",
    ["token_level"]                     = "Nível",
    ["token_class"]                     = "Classe",
    ["token_race"]                      = "Raça",
    ["token_guild"]                     = "Guilda",

    -- AstralForge : domaine plaques de nom
    ["section_np_elements"]             = "Posição dos elementos",
    ["info_np_elements"]                = "Abra o AstralForge para arrastar cada elemento sobre a placa e escolher sua ancoragem. Os controles abaixo servem para ajustes ao pixel.",
    ["np_host_plate"]                   = "Placa",
    ["np_host_health"]                  = "Barra de vida",
    ["np_host_castbar"]                 = "Barra de conjuração",
    ["np_host_name"]                    = "Nome",
    ["np_elem_name"]                    = "Nome",
    ["np_elem_hp_number"]               = "Valor de vida",
    ["np_elem_hp_percent"]              = "Porcentagem de vida",
    ["np_elem_level"]                   = "Nível",
    ["np_elem_class_icon"]              = "Ícone de classificação",
    ["np_elem_class_text"]              = "Texto de classificação",
    ["np_elem_castbar"]                 = "Barra de conjuração",
    ["np_elem_cast_icon"]               = "Ícone de conjuração",
    ["np_elem_cast_text"]               = "Nome da magia",
    ["np_elem_cast_timer"]              = "Temporizador de conjuração",
    ["np_elem_cast_shield"]             = "Escudo de conjuração",
    ["np_elem_quest_icon"]              = "Ícone de missão",
    ["np_elem_raid_marker"]             = "Marca de raide",

    -- =====================
    -- CONFIG: Nameplates Panel
    -- =====================
    -- Nameplate tabs
    ["tab_np_auras"]                    = "Auras",
    ["tab_np_advanced"]                 = "Avançado",
    ["info_np_colors_custom"]           = "Cada cor pode ser personalizada clicando na amostra de cor.",

    ["section_np_general"]              = "Configurações gerais",
    ["opt_np_enable"]                   = "Ativar Nameplates do TomoMod",
    ["info_np_description"]             = "Substitui as nameplates da Blizzard por um estilo minimalista personalizável.",
    ["section_dimensions"]              = "Dimensões",
    ["opt_np_name_font_size"]           = "Tamanho de fonte do nome",

    -- Display
    ["section_display"]                 = "Exibição",
    ["opt_np_show_classification"]      = "Mostrar classificação (elite, raro, chefe)",
    ["opt_np_show_absorb"]               = "Mostrar barra de absorção",
    ["opt_np_class_colors"]             = "Cores de classe (jogadores)",
    ["opt_np_friendly_name_only"]       = "Aliados: apenas nome (sem barra de vida)",
    ["opt_np_friendly_role_icons"]      = "Mostrar ícones de função (dungeon/delve)",
    ["opt_np_role_show_tank"]           = "Mostrar ícone de Tank",
    ["opt_np_role_show_healer"]         = "Mostrar ícone de Healer",
    ["opt_np_role_show_dps"]            = "Mostrar ícone de DPS",
    ["opt_np_role_icon_size"]           = "Tamanho do ícone de função",

    -- Raid Marker
    ["section_raid_marker"]             = "Marcador de raide",
    ["opt_np_raid_icon_x"]              = "Deslocamento X",
    ["opt_np_raid_icon_y"]              = "Deslocamento Y",
    ["opt_np_raid_icon_size"]           = "Tamanho do ícone",

    -- Castbar
    ["section_castbar"]                 = "Barra de lançamento",
    ["opt_np_show_castbar"]             = "Mostrar barra de lançamento",
    ["opt_np_castbar_height"]           = "Altura da barra de lançamento",
    ["color_castbar"]                   = "Barra de lançamento (interrompível)",
    ["color_castbar_uninterruptible"]   = "Barra de lançamento (não interrompível)",

    -- Auras
    ["section_auras"]                   = "Auras",
    ["opt_np_show_auras"]               = "Mostrar auras",
    ["opt_np_aura_size"]                = "Tamanho do ícone",
    ["opt_np_max_auras"]                = "Quantidade máxima",
    ["opt_np_only_my_debuffs"]          = "Apenas meus debuffs",

    -- Enemy Buffs
    ["section_enemy_buffs"]              = "Buffs inimigos",
    ["sublabel_enemy_buffs"]             = "— Buffs inimigos —",
    ["opt_enemy_buffs_enable"]           = "Mostrar buffs inimigos",
    ["opt_enemy_buffs_max"]              = "Máx. buffs",
    ["opt_enemy_buffs_size"]             = "Tamanho do ícone de buff",
    ["opt_enemy_buffs_direction"]        = "Direção",
    ["opt_enemy_buffs_per_row"]          = "Ícones por linha",
    ["opt_enemy_buffs_row_orientation"]  = "Linha seguinte",
    ["info_enemy_buffs"]                 = "Mostra buffs ativos (Enfurecer, escudos...) em unidades hostis. Os ícones aparecem acima à direita, empilhando para cima.",
    ["opt_np_show_enemy_buffs"]          = "Mostrar buffs inimigos",
    ["opt_np_enemy_buff_size"]           = "Tamanho do ícone de buff",
    ["opt_np_max_enemy_buffs"]           = "Máx. buffs inimigos",
    ["opt_np_enemy_buff_y_offset"]       = "Deslocamento Y de buffs inimigos",

    -- Transparency
    ["section_transparency"]            = "Transparência",
    ["opt_np_selected_alpha"]           = "Alfa selecionado",
    ["opt_np_unselected_alpha"]         = "Alfa não selecionado",

    -- Stacking
    ["section_stacking"]                = "Empilhamento",
    ["opt_np_overlap"]                  = "Sobreposição vertical",
    ["opt_np_top_inset"]                = "Limite superior da tela",

    -- Colors
    ["section_colors"]                  = "Cores",
    ["color_hostile"]                   = "Hostil (Inimigo)",
    ["color_neutral"]                   = "Neutro",
    ["color_friendly"]                  = "Amigável",
    ["color_tapped"]                    = "Marcado (tapped)",
    ["color_focus"]                     = "Alvo de foco",

    -- NPC Type Colors
    ["section_npc_type_colors"]         = "Cores por tipo de NPC",
    ["color_caster"]                    = "Lançador de feitiços",
    ["color_miniboss"]                  = "Mini-chefe (elite + nível superior)",
    ["color_enemy_in_combat"]           = "Inimigo (padrão)",
    ["info_np_darken_ooc"]              = "Inimigos fora de combate são escurecidos automaticamente.",

    -- Classification colors
    ["section_classification_colors"]   = "Cores de classificação",
    ["opt_np_use_classification"]       = "Cores por tipo de inimigo",
    ["color_boss"]                      = "Chefe",
    ["color_elite"]                     = "Elite / Mini-chefe",
    ["color_rare"]                      = "Raro",
    ["color_normal"]                    = "Normal",
    ["color_trivial"]                   = "Trivial",

    -- Tank mode
    ["section_tank_mode"]               = "Modo tanque",
    ["opt_np_tank_mode"]                = "Ativar modo tanque (cores de ameaça)",
    ["color_no_threat"]                 = "Sem ameaça",
    ["color_low_threat"]                = "Ameaça baixa",
    ["color_has_threat"]                = "Ameaça mantida",
    ["color_dps_has_aggro"]             = "DPS/Curandeiro tem aggro",
    ["color_dps_near_aggro"]            = "DPS/Curandeiro perto do aggro",

    -- NP health format
    ["np_fmt_percent"]                  = "Porcentagem (75%)",
    ["np_fmt_current"]                  = "Atual (25.3K)",
    ["np_fmt_current_percent"]          = "Atual + %",

    -- Reset
    ["btn_reset_nameplates"]            = "Redefinir Nameplates",

    -- =====================
    -- CONFIG: CD & Resource Panel
    -- =====================
    -- Resource colors
    ["section_resource_colors"]         = "Cores de recursos",
    ["res_runes_ready"]                 = "Runas (prontas)",
    ["res_runes_cd"]                    = "Runas (recarga)",

    -- Cooldown Manager
    ["tab_cdm"]                         = "Recargas",
    ["tab_cdm_bars"]                    = "Barras",
    ["tab_resource_bars"]               = "Barras de recursos",
    ["tab_text_position"]               = "Texto e posição",
    ["tab_rb_colors"]                   = "Cores",
    ["info_rb_colors_custom"]           = "Cada cor pode ser personalizada clicando na amostra de cor.",

    ["section_cdm"]                     = "Gerenciador de recargas",
    ["opt_cdm_enable"]                  = "Ativar gerenciador de recargas",
    ["info_cdm_description"]            = "Reskin dos ícones do CooldownManager da Blizzard: bordas arredondadas, overlay de classe em auras ativas, cores de varredura personalizadas, esmaecimento de utilitários, layout centralizado. Posicionamento pelo Edit Mode da Blizzard.",
    ["opt_cdm_show_hotkeys"]            = "Mostrar atalhos de teclado",
    ["opt_cdm_combat_alpha"]            = "Modificar opacidade (combate / alvo)",
    ["opt_cdm_alpha_combat"]            = "Alfa em combate",
    ["opt_cdm_alpha_target"]            = "Alfa com alvo (fora de combate)",
    ["opt_cdm_alpha_ooc"]               = "Alfa fora de combate",
    ["section_cdm_overlay"]             = "Overlay e bordas",
    ["opt_cdm_custom_overlay"]          = "Cor de overlay personalizada",
    ["opt_cdm_overlay_color"]           = "Cor do overlay",
    ["opt_cdm_custom_swipe"]            = "Cor de varredura ativa personalizada",
    ["opt_cdm_swipe_color"]             = "Cor da varredura",
    ["opt_cdm_swipe_alpha"]             = "Opacidade da varredura",
    ["section_cdm_utility"]             = "Utilitário",
    ["opt_cdm_dim_utility"]             = "Esmaecer ícones utilitários fora de CD",
    ["opt_cdm_dim_opacity"]             = "Opacidade de esmaecimento",
    ["opt_cdm_bufficon_direction"]        = "Direção ícones de buff",
    ["opt_cdm_buffbar_direction"]         = "Direção BuffBar",
    ["opt_cdm_buffbar_width"]             = "Largura barra (horizontal)",
    ["buffbar_vertical"]                  = "Vertical",
    ["buffbar_horizontal"]                = "Horizontal",
    ["dir_centered"]                      = "Centralizado (horizontal)",
    ["dir_left"]                          = "Esquerda",
    ["dir_right"]                         = "Direita",
    ["dir_up"]                            = "Cima",
    ["dir_down"]                          = "Baixo",
    ["info_cdm_editmode"]               = "O posicionamento é feito pelo Edit Mode da Blizzard (Esc |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Edit Mode).",

    -- CDM V3.2: Posicionamento e cards de viewer (Phase 4)
    ["section_cdm_placement"]            = "Posicionamento e pré-visualização ao vivo",
    ["info_cdm_placement"]               = "As barras do CDM agora são posicionadas pelo TomoMod (não é mais necessário o Edit Mode da Blizzard). O modo de posicionamento mostra ícones fictícios e permite arrastar cada barra.",
    ["btn_cdm_unlock"]                   = "Modo de posicionamento (ao vivo)",
    ["opt_cdm_preview"]                  = "Pré-visualização (ícones fictícios)",
    ["info_cdm_preview_live"]            = "Ajustes por barra na aba «Barras» — tudo é aplicado ao vivo.",
    ["info_cdm_bars"]                    = "Cada barra tem sua própria posição e disposição. Ative a pré-visualização para ver as mudanças ao vivo, ou o modo de posicionamento para arrastar as barras com o mouse.",
    ["btn_cdm_reset_pos"]                = "Redefinir posições",
    ["msg_cdm_pos_reset"]                = "Posições do CDM redefinidas.",
    ["section_cdm_essential"]            = "Essential (feitiços principais)",
    ["section_cdm_utility_bar"]          = "Utility (feitiços utilitários)",
    ["section_cdm_bufficons"]            = "Ícones de buff (auras — ícones)",
    ["section_cdm_buffbars"]             = "Barras de buff (auras — barras)",
    ["opt_cdm_pos_x"]                    = "Posição X",
    ["opt_cdm_pos_y"]                    = "Posição Y",
    ["opt_cdm_icon_size"]                = "Tamanho do ícone (0 = automático)",
    ["opt_cdm_spacing"]                  = "Espaçamento",
    ["opt_cdm_row_limit"]                = "Por linha (0 = ilimitado)",
    ["opt_cdm_direction"]                = "Direção",
    ["opt_cdm_secondary_direction"]      = "Direção secundária",
    ["opt_cdm_buffbar_spacing"]          = "Espaçamento",
    ["secdir_auto"]                      = "Automático",
    ["secdir_down"]                      = "Linhas para baixo",
    ["secdir_up"]                        = "Linhas para cima",
    ["secdir_right"]                     = "Colunas para a direita",
    ["secdir_left"]                      = "Colunas para a esquerda",

    -- Resource Bars
    ["section_resource_bars"]           = "Barras de recursos",
    ["opt_rb_enable"]                   = "Ativar barras de recursos",
    ["info_rb_description"]             = "Mostra recursos de classe (Mana, Fúria, Energia, Pontos de combo, Runas, etc.) com suporte adaptativo para Druidas.",
    ["section_visibility"]              = "Visibilidade",
    ["opt_rb_visibility_mode"]          = "Modo de visibilidade",
    ["vis_always"]                      = "Sempre visível",
    ["vis_combat"]                      = "Apenas em combate",
    ["vis_target"]                      = "Combate ou alvo",
    ["vis_hidden"]                      = "Oculto",
    ["opt_rb_combat_alpha"]             = "Alfa em combate",
    ["opt_rb_ooc_alpha"]                = "Alfa fora de combate",
    ["opt_rb_width"]                    = "Largura",
    ["opt_rb_classpower_height"]        = "Altura do poder de classe",
    ["opt_rb_druidmana_height"]         = "Altura de mana do druida",
    ["opt_rb_global_scale"]             = "Escala global",

    -- v2.9: Barra de vida (HUD)
    ["section_rb_healthbar"]            = "Barra de vida (HUD)",
    ["opt_rb_hb_enable"]                = "Mostrar barra de vida",
    ["info_rb_healthbar"]               = "Barra de vida centralizada acima dos recursos. Texto e cor de limite gerenciados no cliente (compatível com Midnight).",
    ["opt_rb_hb_height"]                = "Altura",
    ["opt_rb_hb_text"]                  = "Texto",
    ["hb_text_none"]                    = "Nenhum",
    ["hb_text_value"]                   = "Valor",
    ["hb_text_percent"]                 = "Porcentagem",
    ["hb_text_both"]                    = "Valor | %",
    ["opt_rb_hb_classcolor"]            = "Cor de classe",
    ["opt_rb_hb_color"]                 = "Cor personalizada (se cor de classe desativada)",
    ["opt_rb_hb_threshold"]             = "Limite de vida baixa (muda a cor)",
    ["opt_rb_hb_threshold_pct"]         = "Limite (%)",
    ["opt_rb_hb_threshold_color"]       = "Cor de vida baixa",

    -- v2.9: Animações e barra de poder
    ["section_rb_anim"]                 = "Animações e barra de poder",
    ["opt_rb_smooth"]                   = "Animações suaves das barras",
    ["opt_rb_full_glow"]                = "Brilho no máximo do recurso de classe",
    ["opt_rb_supercharged_points"]      = "Mostrar pontos de combo sobrecarregados",
    ["opt_rb_power_ticks"]              = "Marcas na barra de poder (% do máx.)",
    ["ticks_none"]                      = "Nenhum",
    ["opt_rb_power_threshold"]          = "Limite de recurso baixo (barra de poder)",
    ["opt_rb_power_threshold_pct"]      = "Limite (%)",
    ["opt_rb_power_threshold_color"]    = "Cor de recurso baixo",
    ["info_rb_anim"]                    = "Marcas e limite se aplicam à barra de poder centralizada. O suavização também se aplica à barra de vida, ao mana do druida e às barras de auras.",

    ["opt_rb_sync_width"]               = "Sincronizar largura com Essential Cooldowns",
    ["btn_sync_now"]                    = "Sincronizar agora",
    ["info_rb_sync"]                    = "Alinha a largura com o EssentialCooldownViewer do CooldownManager da Blizzard.",

    -- Text & Font
    ["section_text_font"]               = "Texto e fonte",
    ["opt_rb_show_text"]                = "Mostrar texto nas barras",
    ["opt_rb_text_align"]               = "Alinhamento do texto",
    ["align_left"]                      = "Esquerda",
    ["align_center"]                    = "Centro",
    ["align_right"]                     = "Direita",
    ["opt_rb_font_size"]                = "Tamanho de fonte",
    ["opt_rb_font"]                     = "Fonte",
    ["font_default_wow"]                = "WoW padrão",

    -- Position
    ["section_position"]                = "Posição",
    ["info_rb_position"]                = "Use /tmf uf para desbloquear e mover as barras. A posição é salva automaticamente.",
    ["info_rb_druid"]                   = "As barras se adaptam automaticamente à sua classe e especialização.\nDruida: o recurso muda com a forma (Urso |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Fúria, Gato |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Energia, Equilíbrio |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Poder astral).",

    -- =====================
    -- CONFIG: QOL Panel
    -- =====================
    ["tab_qol_cinematic"]               = "Cinemática",
    ["tab_qol_auto_quest"]              = "Auto missões",
    ["tab_qol_automations"]             = "Automações",
    ["tab_qol_mythic_keys"]             = "Chaves M+",
    ["tab_qol_skyride"]                 = "SkyRide",
    ["tab_qol_action_bars"]             = "Barras de ação",
    ["section_action_bars"]             = "Skin de barras de ação",
    ["section_ab_system"]               = "Action Bar System",
    ["opt_ab_system_enable"]            = "Enable TomoMod Action Bar system (requires reload)",
    ["opt_ab_system_reload"]            = "Disabling this fully restores Blizzard action bars after /reload.",
    ["section_ab_skin"]                 = "Visual Skin",

    -- ActionBars: LibKeyBound integration (Lot A9)
    ["btn_ab_kb_lib"]                       = "Modo de atribuição (LibKeyBound)",
    ["info_ab_kb_lib"]                      = "Modo de atribuição compartilhado, detectado a partir de outro addon. Atribui as barras do TomoMod e as desse addon na mesma passagem.",

    -- ActionBars: keybinding command labels (Lot A8)
    ["binding_category"]                    = "Barras de ação do TomoMod",
    ["binding_bar_header"]                  = "Barra TomoMod %d",
    ["binding_button"]                      = "Barra %d Botão %d",

    ["options_load_failed"]             = "painel de opções indisponível — o addon TomoModForever_Options está ativado?",

    ["anchor_queue"]                    = "Olho da fila",

    ["microbar_native_not_found"]       = "não foi possível encontrar o micromenu da Blizzard para ocultar — relate com a versão do seu cliente.",

    ["microbar_tt_perf"]                    = "Desempenho",
    ["microbar_tt_fps"]                     = "Quadros por segundo",
    ["microbar_tt_latency"]                 = "Latência",
    ["microbar_tt_cpu"]                     = "CPU dos addons",
    ["microbar_tt_cpu_off"]                 = "criação de perfil desativada",

    -- ActionBars: rebuilt panel on the Tui schema (lot P5)
    ["section_ab_totem"]                 = "Totens",
    ["opt_ab_totem_enabled"]             = "Barra de totens",
    ["info_ab_totem"]                    = "Uma barra que mostra seus totens ativos e a duração restante. Posicione-a no modo de disposição.",
    ["mover_totembar"]                  = "Barra de totens",
    ["opt_ab_flash"]                    = "Efeito ao pressionar",
    ["info_ab_flash"]                   = "O que é desenhado enquanto um botão fica pressionado. A textura do TomoMod escurece o ícone; a da Blizzard é o clarão padrão.",
    ["info_ab_masque"]                      = "Só tem efeito se o Masque estiver instalado. O visual próprio é então desativado para evitar conflito.",
    ["info_ab_nodb"]                        = "Configurações das barras de ação indisponíveis: o banco de dados não foi inicializado. Recarregue a interface.",
    ["opt_ab_assisted"]                     = "Destaque assistido",
    ["opt_ab_backdrop"]                     = "Fundo",
    ["opt_ab_backdrop_alpha"]               = "Opacidade do fundo",
    ["opt_ab_borders"]                      = "Bordas",
    ["opt_ab_gloss"]                        = "Brilho",
    ["opt_ab_gloss_alpha"]                  = "Opacidade do brilho",
    ["opt_ab_glow_color"]                   = "Cor do brilho",
    ["opt_ab_glow_source"]                  = "Fonte do brilho",
    ["opt_ab_hide_empty"]                   = "Ocultar casas vazias",
    ["opt_ab_hide_empty_keybinds"]          = "Ocultar a tecla nas casas vazias",
    ["opt_ab_icon_size"]                    = "Tamanho dos botões",
    ["opt_ab_icon_skin"]                    = "Visual dos ícones",
    ["opt_ab_keydown"]                      = "Conjurar ao pressionar a tecla",
    ["opt_ab_lock"]                         = "Bloquear os botões",
    ["opt_ab_mana_color"]                   = "Cor sem recurso",
    ["opt_ab_masque"]                       = "Deixar o Masque aplicar o visual",
    ["opt_ab_range"]                        = "Indicador fora de alcance",
    ["opt_ab_range_color"]                  = "Cor fora de alcance",
    ["opt_ab_skin_enabled"]                 = "Aplicar visual aos botões",
    ["opt_ab_spacing"]                      = "Espaçamento",
    ["opt_ab_tooltips"]                     = "Mostrar dicas",
    ["opt_ab_usability"]                    = "Indicador inutilizável",
    ["opt_ab_usability_color"]              = "Cor inutilizável",
    ["opt_abf_combat"]                      = "Sempre visível em combate",
    ["opt_abf_delay"]                       = "Atraso antes de esmaecer",
    ["opt_abf_enabled"]                     = "Esmaecer as barras",
    ["opt_abf_in"]                          = "Duração da aparição",
    ["opt_abf_link"]                        = "Vincular as barras 1 a 8",
    ["opt_abf_out"]                         = "Duração do desaparecimento",
    ["opt_abf_out_alpha"]                   = "Opacidade esmaecida",
    ["opt_abt_anchor"]                      = "Posição",
    ["opt_abt_color"]                       = "Cor",
    ["opt_abt_cooldowntext"]                = "Números de recarga",
    ["opt_abt_counts"]                      = "Cargas e pilhas",
    ["opt_abt_keybinds"]                    = "Atalhos",
    ["opt_abt_macronames"]                  = "Nomes das macros",
    ["opt_abt_offx"]                        = "Deslocamento horizontal",
    ["opt_abt_offy"]                        = "Deslocamento vertical",
    ["opt_abt_show"]                        = "Mostrar",
    ["opt_abt_size"]                        = "Tamanho da fonte",
    ["opt_bar_buttons"]                     = "Número de botões",
    ["opt_bar_grow_left"]                   = "Crescer para a esquerda",
    ["opt_bar_grow_up"]                     = "Crescer para cima",
    ["opt_bar_size"]                        = "Tamanho dos botões",
    ["section_ab_behaviour"]                = "Comportamento",
    ["section_ab_chrome"]                   = "Moldura e fundo",
    ["section_ab_fade"]                     = "Esmaecimento",
    ["section_ab_general"]                  = "Botões",
    ["section_ab_states"]                   = "Estados",
    ["tab_ab_fade"]                         = "Esmaecimento",
    ["tab_ab_general"]                      = "Geral",
    ["tab_ab_indicators"]                   = "Indicadores",
    ["tab_ab_texts"]                        = "Textos",

    -- ActionBars: rebuild notice (lot P4)
    ["info_ab_rebuilding"]              = "As barras de ação estão sendo reconstruídas sobre um novo motor. Suas configurações voltam na próxima atualização; as barras em si funcionam normalmente enquanto isso.",

    -- ActionBars: config tab labels (Lot A7)
    ["tab_abs_buttons"]                     = "Botões",
    ["tab_abs_glow"]                        = "Brilho",
    ["tab_abs_hotkeys"]                     = "Atalhos",

    -- ActionBars: TomoMod-owned buttons (Lot A6)
    ["opt_bar_own_buttons"]                 = "Botões do TomoMod (experimental)",
    ["info_bar_own_buttons"]                = "Substitui os botões da Blizzard pelos do TomoMod nesta barra. Requer /reload. Flyouts (portais, armadilhas, frascos) e o destaque assistido ainda não são suportados.",

    -- ActionBars: special bars (stances, pet, state decoration)
    ["section_ab_special"]                  = "Posturas, lacaio e estados",
    ["opt_ab_sp_active"]                    = "Destacar a ação ativa",
    ["opt_ab_sp_active_color"]              = "Cor ativa",
    ["opt_ab_sp_equipped"]                  = "Destacar itens equipados",
    ["opt_ab_sp_equipped_color"]            = "Cor equipado",
    ["opt_ab_sp_thickness"]                 = "Espessura do destaque",
    ["opt_ab_sp_autocast"]                  = "Brilho de conjuração automática",
    ["opt_ab_sp_autocast_color"]            = "Cor da conjuração automática",
    ["opt_ab_sp_pet_autohide"]              = "Ocultar a barra de lacaio sem lacaio",
    ["info_ab_sp_pet_autohide"]             = "Oculta enquanto você não tiver nenhum lacaio. As posturas não têm condição equivalente e ficam a cargo da Blizzard.",

    -- ActionBars: hotkey layer (keybind text, binding mode)
    ["section_ab_hotkey"]                   = "Atalhos",
    ["opt_ab_hk_enable"]                    = "Mostrar atalhos",
    ["opt_ab_hk_abbrev"]                    = "Abreviar",
    ["opt_ab_hk_size"]                      = "Tamanho da fonte",
    ["opt_ab_hk_anchor"]                    = "Posição",
    ["opt_ab_hk_offx"]                      = "Deslocamento horizontal",
    ["opt_ab_hk_offy"]                      = "Deslocamento vertical",
    ["opt_ab_hk_color"]                     = "Cor do texto",
    ["opt_ab_hk_hide_empty"]                = "Ocultar nas casas vazias",
    ["btn_ab_hk_bind"]                      = "Modo de atribuição",
    ["info_ab_hk_bind"]                     = "Atribua teclas diretamente nas barras. Indisponível em combate.",
    ["hotkey_bind_enter"]                   = "Modo de atribuição: passe o cursor sobre um botão e pressione uma tecla. Clique direito ou Esc limpa.",
    ["hotkey_bind_exit"]                    = "Modo de atribuição encerrado, atalhos salvos.",
    ["hotkey_combat_blocked"]               = "O modo de atribuição não está disponível em combate.",

    -- ActionBars: glow layer (procs, rotation hint)
    ["section_ab_glow"]                     = "Brilho (procs e rotação)",
    ["opt_ab_glow_proc"]                    = "Brilho ao ativar",
    ["opt_ab_glow_proc_type"]               = "Estilo do brilho de proc",
    ["opt_ab_glow_proc_color"]              = "Cor do brilho de proc",
    ["opt_ab_glow_assist"]                  = "Brilho na sugestão de rotação",
    ["opt_ab_glow_assist_type"]             = "Estilo do brilho de rotação",
    ["opt_ab_glow_assist_color"]            = "Cor do brilho de rotação",
    ["info_ab_glow_assist"]                 = "Segue a recomendação do Destaque Assistido da Blizzard. Requer que o recurso esteja disponível no seu personagem.",
    ["opt_ab_glow_lines"]                   = "Pixel: número de linhas",
    ["opt_ab_glow_freq"]                    = "Velocidade da animação",
    ["opt_ab_glow_thickness"]               = "Pixel: espessura das linhas",

    -- ActionBars: render layer (icons, cooldowns, texts)
    ["section_ab_icons"]                    = "Ícones e recargas",
    ["opt_ab_cd_backend"]                   = "Fonte das recargas",
    ["info_ab_cd_managed"]                  = "Gerenciada: o TomoMod desenha a recarga. Necessária para os futuros botões do TomoMod; a fonte da Blizzard é mais segura por enquanto.",
    ["opt_ab_cd_numbers"]                   = "Números de recarga",
    ["opt_ab_cd_size"]                      = "Tamanho dos números",
    ["opt_ab_swipe_color"]                  = "Cor da varredura",
    ["opt_ab_swipe_alpha"]                  = "Opacidade da varredura",
    ["opt_ab_show_count"]                   = "Mostrar cargas / pilhas",
    ["opt_ab_count_size"]                   = "Tamanho do texto de cargas",
    ["opt_ab_show_macro"]                   = "Mostrar nome da macro",
    ["opt_ab_desat_unusable"]               = "Dessaturar se inutilizável",
    ["opt_ab_icon_zoom"]                    = "Recorte do ícone",
    ["cat_action_bars"]                 = "Barras de ação",
    ["opt_abs_enable"]                  = "Ativar skin de barras de ação",
    ["opt_abs_class_color"]             = "Cor da classe para bordas",
    ["opt_abs_shift_reveal"]            = "Segurar Shift para revelar barras ocultas",
    ["sublabel_bar_opacity"]            = "— Opacidade por barra —",
    ["opt_abs_select_bar"]              = "Selecionar barra de ação",
    ["btn_abs_apply_all_opacity"]       = "Aplicar a todas as barras",
    ["msg_abs_all_opacity"]             = "Opacidade definida em %d%% em todas as barras",
    ["sublabel_bar_combat"]             = "— Visibilidade em combate —",
    ["opt_abs_combat_show"]             = "Mostrar apenas em combate",

    ["section_cinematic"]               = "Pular cinemáticas",
    ["opt_cinematic_auto_skip"]         = "Pular automaticamente após assistir uma vez",
    ["info_cinematic_viewed"]           = "Cinemáticas já assistidas: %s\nO histórico é compartilhado entre personagens.",
    ["btn_clear_history"]               = "Limpar histórico",

    -- Auto Quest
    ["section_auto_quest"]              = "Auto missões",
    ["opt_quest_auto_accept"]           = "Aceitar missões automaticamente",
    ["opt_quest_auto_turnin"]           = "Entregar missões automaticamente",
    ["opt_quest_auto_gossip"]           = "Selecionar diálogos automaticamente",
    ["info_quest_shift"]                = "Segure SHIFT para desativar temporariamente.\nMissões com múltiplas recompensas não são entregues automaticamente.",

    -- Objective Tracker Skin
    ["tab_qol_obj_tracker"]             = "Rastreador",
    ["section_obj_tracker"]             = "Skin do rastreador de objetivos",
    ["opt_obj_tracker_enable"]          = "Ativar skin do rastreador",
    ["opt_obj_tracker_bg_alpha"]        = "Opacidade do fundo",
    ["opt_obj_tracker_border"]          = "Mostrar borda",
    ["opt_obj_tracker_hide_empty"]      = "Ocultar se vazio",
    ["opt_obj_tracker_buckets"]         = "Agrupar missões em categorias recolhíveis",
    ["opt_obj_tracker_header_size"]     = "Tamanho de fonte do cabeçalho",
    ["opt_obj_tracker_cat_size"]        = "Tamanho de fonte de categoria",
    ["opt_obj_tracker_quest_size"]      = "Tamanho de fonte do título da missão",
    ["opt_obj_tracker_obj_size"]        = "Tamanho de fonte do objetivo",
    ["opt_obj_tracker_max_quests"]       = "Máx. missões mostradas (0 = sem limite)",
    ["ot_overflow_text"]                 = "%d missão(ões) oculta(s)...",
    ["info_obj_tracker"]                = "Aplica um skin escuro ao rastreador de objetivos da Blizzard com um painel, fontes personalizadas e cabeçalhos de categoria coloridos.",
    ["ot_header_title"]                 = "OBJETIVOS",
    ["ot_collapse_all"]                  = "Recolher tudo",
    ["ot_expand_all"]                    = "Expandir tudo",
    ["ot_header_options"]               = "Opções",

    -- Automations
    ["section_automations"]             = "Automações",
    ["opt_hide_blizzard_castbar"]       = "Ocultar barra de lançamento da Blizzard",
    ["opt_hide_talking_head"]           = "Ocultar Talking Head (di\195\161logos de rolagem)",
    ["opt_hide_status_bar2"]            = "Ocultar a barra de status 2 da Blizzard",
    ["opt_hide_status_bar2_desc"]       = "Torna invisível e não clicável a segunda barra de status do modo de edição. Continua sendo da Blizzard, portanto permanece no modo de edição dela.",

    -- Auto Accept Invite
    ["sublabel_auto_accept_invite"]     = "— Aceitar convite automaticamente —",
    ["sublabel_auto_skip_role"]         = "— Pular verificação de papel —",
    ["sublabel_tooltip_ids"]            = "— IDs de Tooltip —",
    ["sublabel_combat_res_tracker"]     = "— Rastreador de res. em combate —",
    ["opt_cr_show_rating"]              = "Mostrar pontuação M+",
    ["opt_show_messages"]               = "Mostrar mensagens no chat",
    ["opt_tid_spell"]                   = "ID de feitiço / aura",
    ["opt_tid_item"]                    = "ID de item",
    ["opt_tid_npc"]                     = "ID de NPC",
    ["opt_tid_quest"]                   = "ID de missão",
    ["opt_tid_mount"]                   = "ID de montaria",
    ["opt_tid_currency"]                = "ID de moeda",
    ["opt_tid_achievement"]             = "ID de conquista",
    ["opt_accept_friends"]              = "Aceitar de amigos",
    ["opt_accept_guild"]                = "Aceitar da guilda",

    -- Auto Summon
    ["sublabel_auto_summon"]            = "— Auto invocação —",
    ["opt_summon_delay"]                = "Atraso (segundos)",

    -- Auto Fill Delete
    ["sublabel_auto_fill_delete"]       = "— Auto preencher DELETAR —",
    ["sublabel_auto_vendor_repair"]     = "— Auto Vendedor / Reparo —",
    ["opt_avr_auto_repair"]             = "Reparo automático no comerciante",
    ["opt_avr_sell_grays"]              = "Vender automaticamente itens cinzas (pobres)",
    ["opt_focus_ok_button"]             = "Focar botão OK após preencher",

    -- Mythic+ Keys
    ["section_mythic_keys"]             = "Chaves Míticas+",
    ["opt_keys_enable_tracker"]         = "Ativar rastreador",
    ["opt_keys_mini_frame"]             = "Mini-quadro na interface M+",
    ["opt_keys_auto_refresh"]           = "Atualização automática",

    -- SkyRide
    ["section_skyride"]                 = "SkyRide",
    ["opt_skyride_enable"]              = "Ativar (tela de voo)",
    ["section_skyride_dims"]            = "Dimensões",
    ["opt_skyride_bar_height"]          = "Altura da barra de velocidade",
    ["opt_skyride_charge_height"]       = "Altura da barra de carga",
    ["opt_skyride_charge_gap"]          = "Espaço entre segmentos",
    ["section_skyride_text"]            = "Texto",
    ["opt_skyride_show_speed_text"]     = "Mostrar porcentagem de velocidade",
    ["opt_skyride_speed_font_size"]     = "Tamanho de fonte de velocidade",
    ["opt_skyride_show_charge_timer"]   = "Mostrar temporizador de carga",
    ["opt_skyride_charge_font_size"]    = "Tamanho de fonte do temporizador",
    ["btn_reset_skyride"]               = "Redefinir posição do SkyRide",

    -- =====================
    -- CONFIG: QOL — CVar Optimizer
    -- =====================
    ["tab_qol_cvar_opt"]                = "CVars Perf",
    ["section_cvar_optimizer"]          = "Otimizador de CVars",
    ["info_cvar_optimizer"]             = "Aplica ajustes gráficos/desempenho recomendados. Seus valores atuais são salvos e podem ser restaurados a qualquer momento.",
    ["btn_cvar_apply_all"]              = ">> Aplicar tudo",
    ["btn_cvar_revert_all"]             = "<< Restaurar tudo",
    ["btn_cvar_apply"]                  = "Aplicar",
    ["btn_cvar_revert"]                 = "Restaurar",
    -- Categories
    ["opt_cat_render"]                  = "Renderização e tela",
    ["opt_cat_graphics"]                = "Qualidade gráfica",
    ["opt_cat_detail"]                  = "Distância de visão e detalhes",
    ["opt_cat_advanced"]                = "Avançado",
    ["opt_cat_fps"]                     = "Limites de FPS",
    ["opt_cat_post"]                    = "Pós-processamento",
    -- CVar labels
    ["opt_cvar_render_scale"]           = "Escala de renderização",
    ["opt_cvar_vsync"]                  = "VSync",
    ["opt_cvar_msaa"]                   = "Multisampling (MSAA)",
    ["opt_cvar_low_latency"]            = "Modo de baixa latência",
    ["opt_cvar_anti_aliasing"]          = "Anti-aliasing",
    ["opt_cvar_shadow"]                 = "Qualidade de sombras",
    ["opt_cvar_ssao"]                   = "SSAO",
    ["opt_cvar_depth"]                  = "Efeitos de profundidade",
    ["opt_cvar_compute"]                = "Efeitos de cálculo",
    ["opt_cvar_particle"]               = "Densidade de partículas",
    ["opt_cvar_liquid"]                 = "Detalhe de líquidos",
    ["opt_cvar_spell_density"]          = "Densidade de feitiços",
    ["opt_cvar_projected"]              = "Texturas projetadas",
    ["opt_cvar_outline"]                = "Modo de contorno",
    ["opt_cvar_texture_res"]            = "Resolução de texturas",
    ["opt_cvar_view_distance"]          = "Distância de visão",
    ["opt_cvar_env_detail"]             = "Detalhe do ambiente",
    ["opt_cvar_ground"]                 = "Vegetação do solo",
    ["opt_cvar_gfx_api"]                = "API gráfica",
    ["opt_cvar_triple_buffering"]       = "Triple buffering",
    ["opt_cvar_texture_filtering"]      = "Filtragem de texturas",
    ["opt_cvar_rt_shadows"]             = "Sombras ray tracing",
    ["opt_cvar_resample_quality"]       = "Qualidade de reamostragem",
    ["opt_cvar_physics"]                = "Nível de física",
    ["opt_cvar_target_fps"]             = "FPS alvo",
    ["opt_cvar_bg_fps_enable"]          = "Limite de FPS em segundo plano",
    ["opt_cvar_bg_fps"]                 = "Valor de FPS em segundo plano",
    ["opt_cvar_resample_sharpness"]     = "Nitidez de reamostragem",
    ["opt_cvar_camera_shake"]           = "Vibração de câmera",
    -- Messages
    ["msg_cvar_applied"]                = "CVars aplicadas",
    ["msg_cvar_reverted"]               = "CVars restauradas",
    ["msg_cvar_no_backup"]              = "Nenhum backup encontrado — aplique primeiro.",
    ["tab_qol_leveling"]                = "Leveling",
    ["section_leveling_bar"]            = "Barra de experiência",
    ["opt_leveling_enable"]             = "Ativar barra de experiência",
    ["opt_leveling_width"]              = "Largura da barra",
    ["opt_leveling_height"]             = "Altura da barra",
    ["btn_reset_leveling_pos"]          = "Redefinir posição",
    ["leveling_bar_title"]              = "Barra de experiência",
    ["leveling_level"]                  = "Nível",
    ["leveling_progress"]               = "Progresso:",
    ["leveling_rested"]                 = "Descansado",
    ["leveling_last_quest"]             = "Última missão:",
    ["leveling_ttl"]                    = "Tempo para nível:",
    ["leveling_remaining"]              = "Restante",
    ["leveling_session"]                = "Este nível",
    ["leveling_drag_hint"]              = "/tmf sr para desbloquear e mover",

    -- =====================
    -- CONFIG: Profiles Panel (3 Tabs)
    -- =====================
    ["tab_profiles"]                    = "Perfis",
    ["tab_import_export"]               = "Importar/Exportar",
    ["tab_resets"]                      = "Redefinição",

    -- Tab 1: Named profiles & specializations
    ["section_named_profiles"]          = "Perfis",
    ["info_named_profiles"]             = "Crie e gerencie perfis nomeados. Cada perfil salva uma cópia completa das suas configurações.",
    ["profile_active_label"]            = "Perfil ativo",
    ["opt_select_profile"]              = "Escolher um perfil",
    ["sublabel_create_profile"]         = "— Criar novo perfil —",
    ["placeholder_profile_name"]        = "Nome do perfil...",
    ["btn_create_profile"]              = "Criar perfil",
    ["btn_delete_named_profile"]        = "Excluir perfil",
    ["btn_save_profile"]                = "Salvar perfil atual",
    ["info_save_profile"]               = "Salva todas as configurações atuais no perfil ativo. Isso é feito automaticamente ao trocar de perfil.",

    ["section_profile_mode"]            = "Modo de perfil",
    ["info_spec_profiles"]              = "Ative perfis por especialização para salvar e carregar configurações automaticamente ao trocar de especialização.\nCada especialização tem sua própria configuração independente.",
    ["opt_enable_spec_profiles"]        = "Ativar perfis por especialização",
    ["profile_status"]                  = "Perfil ativo",
    ["profile_global"]                  = "Global (perfil único)",
    ["section_spec_list"]               = "Especializações",
    ["profile_badge_active"]            = "Ativo",
    ["profile_badge_saved"]             = "Salvo",
    ["profile_badge_none"]              = "Sem perfil",
    ["btn_copy_to_spec"]                = "Copiar atual",
    ["btn_delete_profile"]              = "Excluir",
    ["info_spec_reload"]                = "Trocar de especialização com perfis ativados recarregará automaticamente a interface para aplicar o perfil correspondente.",
    ["info_global_mode"]                = "Todas as especializações compartilham as mesmas configurações. Ative perfis por especialização acima para usar configurações diferentes.",

    -- Tab 2: Import / Export
    ["section_export"]                  = "Exportar configurações",
    ["info_export"]                     = "Gera uma string comprimida de todas as suas configurações atuais.\nCopie para compartilhar ou como backup.",
    ["label_export_string"]             = "String de exportação (clique para selecionar tudo)",
    ["btn_export"]                      = "Gerar string de exportação",
    ["btn_copy_clipboard"]              = "Copiar texto",
    ["section_import"]                  = "Importar configurações",
    ["info_import"]                     = "Cole uma string de exportação abaixo. Ela será validada antes de ser aplicada.",
    ["label_import_string"]             = "Cole a string de importação aqui",
    ["btn_import"]                      = "Importar e aplicar",
    ["btn_paste_clipboard"]             = "Colar texto",
    ["import_preview"]                  = "Classe: %s | Módulos: %s | Data: %s",
    ["import_preview_valid"]            = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t String válida",
    ["import_preview_invalid"]          = "String inválida ou corrompida",
    ["info_import_warning"]             = "A importação SOBRESCREVERÁ todas as suas configurações atuais e recarregará a interface. Esta ação não pode ser desfeita.",

    -- Tab 3: Resets
    ["section_profile_mgmt"]            = "Gerenciamento de perfis",
    ["info_profiles"]                   = "Redefina módulos individuais ou exporte/importe suas configurações.\nExportar copia as configurações para a área de transferência (requer LibSerialize + LibDeflate).",
    ["section_reset_module"]            = "Redefinir um módulo",
    ["btn_reset_prefix"]                = "Redefinir: ",
    ["btn_reset_all_reload"]            = "(!) REDEFINIR TUDO + Recarregar",
    ["section_reset_all"]               = "Redefinição completa",
    ["info_resets"]                     = "Redefine um módulo individual para seus valores padrão. O módulo será recarregado com as configurações de fábrica.",
    ["info_reset_all_warning"]          = "Isso redefinirá TODOS os módulos e TODAS as configurações para os valores de fábrica, e então recarregará a interface.",

    -- =====================
    -- PRINT MESSAGES: Core
    -- =====================
    ["msg_db_reset"]                    = "Banco de dados redefinido",
    ["msg_migration_failed"]           = "Uma etapa de migração do banco de dados falhou — por favor, reporte no Discord: ",
    ["msg_normalize_failed"]           = "A normalização de elementos falhou — por favor, reporte no Discord: ",
    ["msg_module_reset"]                = "Módulo '%s' redefinido",
    ["msg_db_not_init"]                 = "Banco de dados não inicializado",
    ["msg_loaded"]                      = "carregado — %s para configuração",
    ["msg_report_issue"]                = "Se encontrar algum problema, deixe um comentário no CurseForge.",
    ["at_rescue_header"]              = "O rastreador de auras foi removido; o CooldownForge cobre o mesmo.",
    ["at_rescue_list"]                = "Magias que voc\195\170 havia adicionado \195\160 m\195\163o: %s",
    ["at_rescue_hint"]                = "Adicione-as novamente no Cooldown Studio se ainda quiser acompanh\195\161-las.",
    ["msg_help_title"]                  = "Comandos:",
    ["msg_help_open"]                   = "Abrir configuração",
    ["msg_help_reset"]                  = "Redefinir tudo + recarregar",
    ["msg_help_uf"]                     = "Bloquear/Desbloquear UnitFrames + Recursos",
    ["msg_help_uf_reset"]               = "Redefinir UnitFrames",
    ["msg_help_rb"]                     = "Bloquear/Desbloquear barras de recursos",
    ["msg_help_rb_sync"]                = "Sincronizar largura com Essential Cooldowns",
    ["msg_help_np"]                     = "Ativar/desativar Nameplates",
    ["msg_help_minimap"]                = "Redefinir minimapa",
    ["msg_help_panel"]                  = "Redefinir painel de info",
    ["msg_help_cursor"]                 = "Redefinir anel do cursor",
    ["msg_help_clearcinema"]            = "Limpar histórico de cinemáticas",
    ["msg_help_sr"]                     = "Bloquear/Desbloquear SkyRide + Âncoras",
    ["msg_help_key"]                    = "Abrir chaves Míticas+",
    ["msg_help_help"]                   = "Esta ajuda",

    -- =====================
    -- PRINT MESSAGES: Modules
    -- =====================
    -- CDM
    ["msg_cdm_status"]                  = "Ativado",
    ["msg_cdm_disabled"]                = "Desativado",

    -- Nameplates
    ["msg_np_enabled"]                  = "Ativadas",
    ["msg_np_disabled"]                 = "Desativadas",

    -- UnitFrames
    ["msg_uf_locked"]                   = "Bloqueado",
    ["msg_uf_unlocked"]                 = "Desbloqueado — Arraste para reposicionar",
    ["msg_uf_initialized"]              = "Inicializado — /tmf uf para bloquear/desbloquear",
    ["msg_uf_enabled"]                  = "ativado (recarga necessária)",
    ["msg_uf_disabled"]                 = "desativado (recarga necessária)",
    ["msg_uf_position_reset"]           = "posição redefinida",

    -- ResourceBars
    ["msg_rb_width_synced"]             = "Largura sincronizada (%dpx)",
    ["msg_rb_locked"]                   = "Bloqueado",
    ["msg_rb_unlocked"]                 = "Desbloqueado — Arraste para reposicionar",
    ["msg_rb_position_reset"]           = "Posição das barras de recursos redefinida",

    -- SkyRide
    ["msg_sr_pos_saved"]                = "Posição do SkyRide salva",
    ["msg_sr_locked"]                   = "SkyRide bloqueado",
    ["msg_sr_unlock"]                   = "Modo de movimento do SkyRide ativado – Clique e arraste",
    ["msg_sr_pos_reset"]                = "Posição do SkyRide redefinida",
    ["msg_sr_db_not_init"]              = "TomoModForeverDB não inicializado",
    ["msg_sr_initialized"]              = "Módulo SkyRide inicializado",

    -- FrameAnchors
    ["anchor_alert"]                    = "Alertas",
    ["anchor_loot"]                     = "Saque",
    ["msg_anchors_locked"]              = "Bloqueados",
    ["msg_anchors_unlocked"]            = "Desbloqueados — mova as âncoras",

    -- AutoVendorRepair
    ["msg_avr_header"]                  = "[AutoVendedorReparar]",
    ["msg_avr_sold"]                    = " Itens cinzas vendidos por |cffffff00%s|r",
    ["msg_avr_repaired"]                = " Equipamento reparado por |cffffff00%s|r",

    -- AutoFillDelete
    ["msg_afd_filled"]                  = "Texto 'DELETAR' preenchido automaticamente – Clique em OK para confirmar",
    ["msg_afd_db_not_init"]             = "TomoModForeverDB não inicializado",
    ["msg_afd_initialized"]             = "Módulo AutoFillDelete inicializado",
    ["msg_afd_enabled"]                 = "Auto-preencher DELETAR ativado",
    ["msg_afd_disabled"]                = "Auto-preencher DELETAR desativado (o hook permanece ativo)",

    -- HideCastBar
    ["msg_hcb_db_not_init"]             = "TomoModForeverDB não inicializado",
    ["msg_hcb_initialized"]             = "Módulo HideCastBar inicializado",
    ["msg_hcb_hidden"]                  = "Barra de lançamento oculta",
    ["msg_hcb_shown"]                   = "Barra de lançamento exibida",

    -- AutoAcceptInvite
    ["msg_aai_accepted"]                = "Convite aceito de ",
    ["msg_aai_ignored"]                 = "Convite ignorado de ",
    ["msg_aai_enabled"]                 = "Auto-aceitar convites ativado",
    ["msg_aai_disabled"]                = "Auto-aceitar convites desativado",
    ["msg_asr_lfg_accepted"]            = "Verificação de papel auto-confirmada",
    ["msg_asr_poll_accepted"]           = "Enquete de papel auto-confirmada",
    ["msg_asr_enabled"]                 = "Auto pular verificação de papel ativado",
    ["msg_asr_disabled"]                = "Auto pular verificação de papel desativado",
    ["msg_tid_enabled"]                 = "Tooltip IDs ativado",
    ["msg_tid_disabled"]                = "Tooltip IDs desativado",
    ["msg_cr_enabled"]                  = "Rastreador de res. em combate ativado",
    ["msg_cr_disabled"]                 = "Rastreador de res. em combate desativado",
    ["msg_cr_locked"]                   = "Rastreador de res. em combate bloqueado",
    ["msg_cr_unlock"]                   = "Rastreador de res. em combate desbloqueado — arraste para mover",
    ["msg_abs_enabled"]                 = "Skin de barras de ação ativado (recarga recomendada)",
    ["msg_abs_disabled"]                = "Skin de barras de ação desativado",
    ["opt_buffskin_enable"]             = "Ativar skin de buffs",
    ["opt_buffskin_desc"]               = "Adiciona bordas pretas e temporizador colorido em buffs/debuffs do jogador",
    ["msg_buffskin_enabled"]            = "Skin de buffs ativado",
    ["msg_buffskin_disabled"]           = "Skin de buffs desativado",
    ["msg_help_cr"]                     = "Bloquear/desbloquear rastreador de res. em combate",
    ["msg_help_cs"]                     = "Bloquear/desbloquear posição da ficha de personagem",
    ["msg_help_cs_reset"]               = "Redefinir posição da ficha de personagem",

    -- CinematicSkip
    ["msg_cin_skipped"]                 = "Cinemática pulada (já assistida)",
    ["msg_vid_skipped"]                 = "Vídeo pulado (já assistido)",
    ["msg_vid_id_skipped"]              = "Vídeo #%d pulado",
    ["msg_cin_cleared"]                 = "Histórico de cinemáticas limpo",

    -- AutoSummon
    ["msg_sum_accepted"]                = "Invocação aceita de %s para %s (%s)",
    ["msg_sum_ignored"]                 = "Invocação ignorada de %s (não confiável)",
    ["msg_sum_enabled"]                 = "Auto-invocação ativada",
    ["msg_sum_disabled"]                = "Auto-invocação desativada",
    ["msg_sum_manual"]                  = "Invocação aceita manualmente",
    ["msg_sum_no_pending"]              = "Sem invocação pendente",

    -- MythicKeys
    ["msg_keys_no_key"]                 = "Sem chave para enviar.",
    ["msg_keys_not_in_group"]           = "Você precisa estar em um grupo.",
    ["msg_keys_reload"]                 = "Mudança aplicada no próximo /reload.",
    ["mk_not_in_group"]                 = "Você não está em um grupo.",
    ["mk_not_in_group_short"]           = "Não está em grupo.",
    ["mk_no_key_self"]                  = "Pedra angular não encontrada.",
    ["mk_title"]                        = "TM — Chaves Míticas",
    ["mk_btn_send"]                     = "Enviar no chat",
    ["mk_btn_refresh"]                  = "Atualizar",
    ["mk_tab_keys"]                     = "Chaves",
    ["mk_tab_tp"]                       = "TP",
    ["mk_tp_click_to_tp"]              = "Clique para se teletransportar",
    ["mk_tp_not_unlocked"]             = "Não desbloqueado",
    ["msg_tp_not_owned"]               = "Você não tem o teletransporte para %s",
    ["msg_tp_combat"]                  = "Não é possível atualizar teletransportes em combate.",

    -- =====================
    -- PRINT MESSAGES: Config Panels
    -- =====================
    ["msg_np_reset"]                    = "Nameplates redefinidas (recarga recomendada)",
    ["msg_uf_toggle"]                   = "UnitFrames %s (recarga)",
    ["msg_profile_reset"]               = "%s redefinido",
    ["msg_profile_copied"]              = "Configurações atuais copiadas para '%s'",
    ["msg_profile_deleted"]             = "Perfil excluído para '%s'",
    ["msg_profile_loaded"]              = "Perfil '%s' carregado — recarga para aplicar",
    ["msg_profile_load_failed"]         = "Erro ao carregar o perfil '%s'",
    ["msg_profile_created"]             = "Perfil '%s' criado com as configurações atuais",
    ["msg_profile_name_empty"]          = "Por favor, insira um nome de perfil",
    ["msg_profile_saved"]               = "Configurações salvas no perfil '%s'",

    -- New profile keys v2.3.0
    ["btn_rename_profile"]              = "Renomear",
    ["btn_duplicate_profile"]           = "Duplicar",
    ["btn_load_profile"]                = "Carregar",
    ["btn_close"]                       = "Fechar",
    ["btn_cancel"]                      = "Cancelar",
    ["section_spec_assign"]             = "Perfis por especialização",
    ["info_spec_assign"]                = "Atribua cada especialização a um perfil nomeado. TomoMod trocará automaticamente de perfil ao mudar de especialização.",
    ["spec_profile_none"]               = "— Nenhum —",
    ["popup_rename_profile"]            = "|cffffd100TomoModForever|r\n\nNovo nome para '%s':",
    ["popup_duplicate_profile"]         = "|cffffd100TomoModForever|r\n\nDuplicar '%s' como:",
    ["msg_profile_renamed"]             = "Perfil '%s' renomeado para '%s'",
    ["msg_profile_duplicated"]          = "Perfil '%s' duplicado como '%s'",
    ["msg_import_as_profile"]           = "Perfil importado como '%s'",
    ["popup_export_title"]              = "Exportar perfil",
    ["popup_export_hint"]               = "Selecione tudo (Ctrl+A) e copie (Ctrl+C)",
    ["popup_import_title"]              = "Importar perfil",
    ["popup_import_hint"]               = "Cole uma string de exportação do TomoMod, depois clique em Importar",
    ["label_import_profile_name"]       = "Salvar como nome de perfil:",
    ["placeholder_import_profile_name"] = "Nome do perfil (opcional)...",
    ["msg_profile_name_deleted"]        = "Perfil '%s' excluído",
    ["msg_export_success"]              = "String de exportação gerada — selecione tudo e copie",
    ["msg_import_success"]              = "Configurações importadas com sucesso — recarregando...",
    ["msg_import_empty"]                = "Nada para importar — cole uma string primeiro",
    ["msg_copy_hint"]                   = "Texto selecionado — pressione Ctrl+C para copiar",
    ["msg_copy_empty"]                  = "Gere primeiro uma string de exportação",
    ["msg_paste_hint"]                  = "Pressione Ctrl+V para colar sua string de importação",
    ["msg_spec_changed_reload"]         = "Especialização alterada — carregando perfil...",

    -- =====================
    -- INFO PANEL (Minimap)
    -- =====================
    ["time_server"]                     = "Servidor",
    ["time_local"]                      = "Local",
    ["time_tooltip_title"]              = "Hora (%s - %s)",
    ["time_tooltip_left_click"]         = "|cffffd100Clique esquerdo:|r Calendário",
    ["time_tooltip_right_click"]        = "|cffffd100Clique direito:|r Servidor / Local",
    ["time_tooltip_shift_right"]        = "|cffffd100Shift + Clique direito:|r 12h / 24h",
    ["time_format_msg"]                 = "Formato: %s",
    ["time_mode_msg"]                   = "Hora: %s",

    -- =====================
    -- ENABLED / DISABLED (generic)
    -- =====================
    ["enabled"]                         = "Ativado",
    ["disabled"]                        = "Desativado",

    -- Static Popups
    ["popup_reset_text"]                = "|cffffd100TomoModForever|r\n\nRedefinir TODAS as configurações?\nIsso recarregará sua interface.",
    ["popup_confirm"]                   = "Confirmar",
    ["popup_cancel"]                    = "Cancelar",
    ["popup_import_text"]               = "|cffffd100TomoModForever|r\n\nImportar configurações?\nIsso SOBRESCREVERÁ todas as suas configurações atuais e recarregará a interface.",
    ["popup_profile_reload"]            = "|cffffd100TomoModForever|r\n\nModo de perfil alterado.\nRecarregar interface para aplicar?",
    ["popup_delete_profile"]            = "|cffffd100TomoModForever|r\n\nExcluir perfil '%s'?\nEsta ação não pode ser desfeita.",

    -- FPS element
    ["label_fps"]                       = "FPS",

    -- =====================
    -- BOSS FRAMES
    -- =====================
    ["tab_boss"]                        = "Chefe",
    ["section_boss_frames"]             = "Barras de chefe",
    ["opt_boss_enable"]                 = "Ativar barras de chefe",
    ["opt_boss_height"]                 = "Altura das barras",
    ["opt_boss_spacing"]                = "Espaço entre barras",
    ["info_boss_drag"]                  = "Desbloqueie (/tmf uf) para mover. Arraste Chefe 1 para reposicionar as 5 barras juntas.",
    ["info_boss_colors"]                = "As cores da barra usam cores de classificação de Nameplate (Chefe = vermelho, Mini-chefe = roxo).",
    ["msg_boss_initialized"]            = "Barras de chefe carregadas.",

    -- =====================
    -- SOUND / LUST DETECTION
    -- =====================
    ["cat_sound"]                       = "Som",
    ["section_sound_general"]           = "Som de Bloodlust",
        ["info_sound_desc"]                 = "Reproduz um som personalizado quando um efeito de Bloodlust e detectado. A deteccao verifica diretamente os buffs de Lust e os debuffs Sated/Exhaustion.",
    ["opt_sound_enable"]                = "Ativar detecção de Bloodlust",
    ["sublabel_sound_choice"]           = "Som e canal",
    ["opt_sound_file"]                  = "Som a reproduzir",
    ["opt_sound_channel"]               = "Canal de áudio",
    ["opt_sound_volume"]                = "Volume do canal de áudio",
    ["info_sound_volume"]               = "Altera o volume global do canal selecionado nas configurações de áudio do WoW.",
    ["btn_sound_preview"]               = ">> Ouvir som",
    ["btn_sound_stop"]                  = "■  Parar",
    ["opt_sound_force"]                 = "Forçar som mesmo com o jogo no mudo",
    ["opt_sound_chat"]                  = "Mostrar mensagens no chat",
    ["opt_sound_debug"]                 = "Mode debug",

    -- =====================
    -- BAG & MICRO MENU
    -- =====================
    ["tab_qol_bag_micro"]               = "Bolsa e menu",
    ["section_bag_micro"]               = "Barra de bolsa e micro menu",
    ["info_bag_micro"]                  = "Escolha se deseja mostrar sempre ou revelar ao passar o mouse.",
    ["sublabel_bag_bar"]                = "— Barra de bolsa —",
    ["sublabel_micro_menu"]             = "— Micro menu —",
    ["opt_bag_bar_mode"]                = "Barra de bolsa",
    ["opt_micro_menu_mode"]             = "Micro menu",
    ["mode_show"]                       = "Sempre visível",
    ["mode_hover"]                      = "Mostrar ao passar o mouse",

    -- =====================
    -- MICRO BAR
    -- =====================
    ["microbar_btn_character"]          = "Personagem",
    ["microbar_btn_spells"]             = "Talentos e grimório",
    ["microbar_btn_profession"]         = "Profissões",
    ["microbar_btn_achievement"]        = "Conquistas",
    ["microbar_btn_quest"]              = "Registro de missões",
    ["microbar_btn_guild"]              = "Guilda e comunidades",
    ["microbar_btn_lfd"]                = "Busca de grupo",
    ["microbar_btn_collections"]        = "Coleções",
    ["microbar_btn_ej"]                 = "Guia de aventura",
    ["microbar_btn_housing"]            = "Moradia",
    ["microbar_btn_social"]             = "Social",
    ["microbar_btn_store"]              = "Loja",
    ["microbar_btn_bags"]               = "Bolsas",
    ["microbar_btn_mainmenu"]           = "Menu do jogo",
    ["microbar_tt_memory"]              = "Memória dos addons",
    ["microbar_tt_total"]               = "Total",
    ["mover_microbar"]                  = "Microbarra",
    ["section_microbar"]                = "Microbarra",
    ["info_microbar"]                   = "Substitui o micromenu da Blizzard por uma barra que você pode dimensionar, reordenar e posicionar livremente. Cada botão encaminha o clique para o botão original, então tudo continua funcionando em combate. Os ícones são lidos direto dos recursos do jogo. Enquanto isto estiver ativo, a opção Micromenu acima deixa de valer.",
    ["opt_microbar_enable"]             = "Ativar a microbarra",
    ["opt_microbar_lfg_eye"]                = "Olho do localizador de grupo",
    ["opt_microbar_lfg_eye_scale"]          = "Tamanho do olho",
    ["info_microbar_lfg_eye"]               = "Separado do micromenu da Blizzard para sobreviver à ocultação. Posicione-o no modo de disposição.",
    ["opt_microbar_hide_native"]        = "Ocultar o micromenu da Blizzard",
    ["opt_microbar_buttons"]            = "Botões e ordem",
    ["opt_microbar_orientation"]        = "Orientação",
    ["opt_microbar_per_line"]           = "Botões por linha (0 = uma única linha)",
    ["opt_microbar_icon_size"]          = "Tamanho dos ícones",
    ["opt_microbar_spacing"]            = "Espaçamento",
    ["opt_microbar_scale"]              = "Escala",
    ["opt_microbar_alpha"]              = "Opacidade",
    ["opt_microbar_fade_mode"]          = "Visibilidade",
    ["opt_microbar_fade_alpha"]         = "Opacidade esmaecida",
    ["opt_microbar_color_mode"]         = "Cor dos ícones",
    ["opt_microbar_color"]              = "Cor personalizada",
    ["opt_microbar_desaturate"]         = "Dessaturar os ícones",
    ["opt_microbar_hover_zoom"]         = "Ampliar o ícone ao passar o mouse",
    ["opt_microbar_memory_tooltip"]     = "Mostrar a memória dos addons no botão de menu",
    ["microbar_orient_h"]               = "Horizontal",
    ["microbar_orient_v"]               = "Vertical",
    ["microbar_fade_always"]            = "Sempre visível",
    ["microbar_fade_hover"]             = "Mostrar ao passar o mouse",
    ["microbar_fade_hovercombat"]       = "Ao passar o mouse, sempre em combate",
    ["microbar_color_class"]            = "Classe",
    ["microbar_color_custom"]           = "Personalizada",
    ["microbar_color_native"]           = "Original",
    ["btn_microbar_place"]              = "Posicionar a barra",
    ["btn_microbar_reset_pos"]          = "Redefinir a posição",
    ["section_microbar_states"]         = "Microbarra — Estados nativos",
    ["info_microbar_states"]            = "Os botões originais continuam funcionando sob a barra, então seus alertas, estados esmaecidos e atalhos seguem ativos. Estas opções os espelham nos seus próprios botões.",
    ["opt_microbar_alert_style"]        = "Brilho de alerta",
    ["opt_microbar_alert_color"]        = "Cor do alerta",
    ["opt_microbar_dim_disabled"]       = "Esmaecer os botões indisponíveis",
    ["opt_microbar_disabled_alpha"]     = "Opacidade esmaecida",
    ["opt_microbar_show_keybind"]       = "Mostrar os atalhos nos ícones",
    ["opt_microbar_keybind_size"]       = "Tamanho do texto dos atalhos",
    ["microbar_glow_none"]              = "Nenhum",
    ["microbar_glow_pixel"]             = "Brilho de pixels",
    ["microbar_glow_autocast"]          = "Cintilação de autolançamento",
    ["microbar_glow_button"]            = "Brilho de botão de ação",
    ["microbar_glow_proc"]              = "Brilho de proc",

    -- =====================
    -- CHARACTER SKIN
    -- =====================
    ["tab_qol_char_skin"]               = "Skin de personagem",
    ["section_char_skin"]               = "Skin da ficha de personagem",
    ["info_char_skin_desc"]             = "Aplica o tema escuro do TomoMod à ficha de personagem, reputação, moedas e janela de inspeção.",
    ["opt_char_skin_enable"]            = "Ativar skin de personagem",
    ["opt_char_skin_character"]         = "Skin Personagem / Reputação / Moedas",
    ["opt_char_skin_inspect"]           = "Skin janela de inspeção",
    ["opt_char_skin_inspect_iteminfo"]  = "Mostrar nível de item, encantamentos e gemas ao inspecionar",
    ["opt_char_skin_iteminfo"]          = "Mostrar info do item nos espaços",
    ["opt_char_skin_gems"]              = "Mostrar gemas nos espaços",
    ["opt_char_skin_midnight"]          = "Encantamentos Midnight (Cabeça/Ombros em vez de Pulsos/Capa)",
    ["opt_char_skin_scale"]             = "Escala da janela",
    ["msg_char_skin_reload"]            = "Skin de personagem: /reload para aplicar mudanças.",

    -- =====================
    -- LAYOUT / MOVERS SYSTEM
    -- =====================
    ["btn_layout"]                      = "EditMode",
    ["btn_layout_tooltip"]              = "EditMode: desbloqueia todos os elementos para movê-los.",
    ["btn_reload_ui"]                   = "Recarregar interface",
    ["layout_mode_title"]               = "TomoMod — EditMode",
    ["layout_mode_hint"]                = "Arraste os elementos para reposicionar — clique em Bloquear quando terminar",
    ["layout_btn_lock"]                 = "Bloquear",
    ["layout_btn_reload"]               = "RL",
    ["layout_btn_gui"]                  = "GUI",
    ["grid_dimmed"]                    = "Grade",
    ["grid_bright"]                    = "Grade +",
    ["grid_disabled"]                  = "Grade OFF",
    ["layout_unlocked"]                 = "EditMode ATIVO — arraste os elementos. Clique em Bloquear ou /tmf layout quando terminar.",
    ["layout_snap_on"]                   = "Ímã: LIGADO",
    ["layout_snap_off"]                  = "Ímã: DESLIGADO",
    ["layout_nudger_hint"]               = "Clique ou arraste um elemento para abrir o TomoLayout. Shift: posicionar sem ímã.",
    ["layout_locked"]                   = "EditMode DESATIVADO — posições salvas.",
    ["msg_help_layout"]                 = "Alternar EditMode (mover todos os elementos UI)",
    ["mover_unitframes"]                = "Unit Frames",
    ["mover_resources"]                 = "Barras de recursos",
    ["mover_skyriding"]                 = "Barra de Skyriding",
    ["mover_levelingbar"]               = "Barra XP / Experiência",
    ["mover_anchors"]                   = "Âncoras de alertas e saque",
    ["mover_cotank"]                    = "Rastreador de Co-Tank",
    ["mover_repbar"]                    = "Barra de reputação",
    ["mover_castbar"]                   = "Barra de lançamento (jogador)",
    ["mover_mythictracker"]             = "Tracker M+",
    ["mover_chatframe"]                 = "Janela de chat",

    -- =====================
    -- COMBAT TEXT
    -- =====================
    ["sublabel_combat_text"]             = "— Texto de combate —",
    ["opt_combat_text_enable"]           = "Ativar texto de combate",
    ["opt_combat_text_offset_x"]         = "Deslocamento X",
    ["opt_combat_text_offset_y"]         = "Deslocamento Y",

    -- =====================
    -- PREY TRACKER
    -- =====================
    ["sublabel_prey_tracker"]            = "— Rastreador de Presa —",
    ["opt_prey_tracker_enable"]          = "Ativar Rastreador de Presa",
    ["opt_prey_tracker_width"]           = "Largura",
    ["opt_prey_tracker_font"]            = "Tamanho da fonte",
    ["info_prey_tracker"]                = "Recurso exclusivo de Midnight. Exibe uma barra de progresso móvel durante uma caçada Prey ativa. Posicione-a via /tmf layout.",

    -- =====================
    -- SKINS (Chat)
    -- =====================
    ["tab_qol_skins"]                    = "Skins",
    ["section_skins"]                    = "Skins da interface",
    ["info_skins_desc"]                  = "Aplica o tema escuro do TomoMod a vários elementos da interface da Blizzard. Pode ser necessário /reload para reverter.",
    ["sublabel_chat_skin"]               = "— Janela de chat —",
    ["opt_chat_skin_enable"]             = "Skin da janela de chat",
    ["opt_chat_skin_style"]              = "Estilo do skin",
    ["opt_chat_skin_style_tui"]          = "TUI (Barra lateral + Janela)",
    ["opt_chat_skin_style_classic"]      = "Clássico (Emoldurado)",
    ["opt_chat_skin_style_glass"]        = "Vidro (Fosco)",
    ["opt_chat_skin_style_minimal"]      = "Mínimo (Sem bordas)",
    ["opt_chat_skin_bg_alpha"]           = "Opacidade do quadro",
    ["opt_chat_message_bg_alpha"]        = "Opacidade da área de mensagens",
    ["opt_chat_skin_font_size"]          = "Tamanho da fonte do chat",
    ["opt_chat_skin_fade"]               = "Fade chat when inactive",
    ["opt_chat_skin_short_channels"]     = "Short channel names (G, P, R…)",
    ["opt_chat_skin_timestamp"]          = "Show timestamps",
    ["opt_chat_skin_url"]                = "Clickable URLs",
    ["opt_chat_skin_emoji"]              = "Replace text emoticons with emoji",
    ["opt_chat_skin_class_colors"]       = "Class-color player names in chat",
    ["opt_chat_copy_button"]             = "Botão de cópia na janela de chat",
    ["opt_chat_copy_button_always"]      = "Sempre visível",
    ["opt_chat_copy_button_hover"]       = "Ao passar o mouse",
    ["opt_chat_copy_button_hidden"]      = "Oculto",
    ["chat_copy_title"]                  = "Copiar texto do chat",
    ["chat_copy_hint"]                   = "Selecione tudo (Ctrl+A) e copie (Ctrl+C)",
    ["chat_copy_select_all"]             = "Selecionar tudo",
    ["chat_copy_close"]                  = "Fechar",
    ["chat_copy_empty"]                  = "Nenhuma mensagem copiável nesta janela.",
    ["chat_copy_url_title"]              = "Pressione Ctrl+C para copiar",
    ["opt_chat_skin_history"]               = "Restaurar o histórico do bate-papo ao conectar",
    ["chat_history_section"]                = "Histórico do bate-papo",
    ["opt_chat_skin_history_info"]          = "Desmarcar interrompe o registro E apaga o que já está armazenado. O histórico é salvo para toda a conta, portanto é compartilhado por todos os personagens.",
    ["opt_chat_history_max_age"]            = "Manter as mensagens por",
    ["opt_chat_history_age_1h"]             = "1 hora",
    ["opt_chat_history_age_6h"]             = "6 horas",
    ["opt_chat_history_age_24h"]            = "24 horas",
    ["opt_chat_history_age_3d"]             = "3 dias",
    ["opt_chat_history_age_unlimited"]      = "Sem limite",
    ["opt_chat_history_max_lines"]          = "Máximo de linhas mantidas",
    ["opt_chat_history_delay"]              = "Atraso antes de restaurar",
    ["opt_chat_history_delay_info"]         = "Esperar alguns segundos deixa as mensagens de carregamento de addons e os erros de Lua aparecerem primeiro, em vez de ficarem soterrados sob o histórico.",
    ["opt_chat_history_separator"]          = "Mostrar um marcador de sessão",
    ["opt_chat_history_separator_info"]     = "Exibe uma linha após o histórico restaurado: tudo abaixo dela é claramente da sessão atual.",
    ["chat_history_separator_text"]         = "Sessão atual",
    ["sublabel_chat_history_channels"]      = "Canais a restaurar",
    ["opt_chat_history_ch_whisper"]         = "Sussurros",
    ["opt_chat_history_ch_guild"]           = "Guilda",
    ["opt_chat_history_ch_officer"]         = "Oficial",
    ["opt_chat_history_ch_party"]           = "Grupo",
    ["opt_chat_history_ch_raid"]            = "Raide",
    ["opt_chat_history_ch_instance"]        = "Instância",
    ["opt_chat_history_ch_channel"]         = "Canais",
    ["opt_chat_history_ch_say"]             = "Falar",
    ["opt_chat_history_ch_yell"]            = "Gritar",
    ["opt_chat_history_ch_emote"]           = "Emotes",
    ["btn_chat_history_clear"]              = "Apagar o histórico agora",
    ["popup_chat_history_clear"]            = "Excluir todas as mensagens de bate-papo armazenadas? Esta ação não pode ser desfeita.",
    ["msg_chat_history_cleared"]            = "Histórico do bate-papo apagado (%d mensagem(ns)).",
    ["opt_chat_skin_copy_lines"]         = "Show copy icon per message",

    -- Buff Skin
    ["sublabel_buff_skin"]               = "— Skin de Buffs / Debuffs —",

    -- Game Menu Skin
    ["sublabel_game_menu_skin"]          = "— Menu do jogo (Escape) —",
    ["opt_game_menu_skin_enable"]        = "Skinear menu do jogo",
    ["info_game_menu_skin_reload"]       = "Necessário /reload para reverter a skin.",
    ["msg_chat_skin_enabled"]            = "Skin do chat ativado",
    ["msg_chat_skin_disabled"]           = "Skin do chat desativado (reload para reverter)",
    ["sublabel_mail_skin"]               = "— Correio —",
    ["opt_mail_skin_enable"]             = "Skin do correio",
    ["msg_mail_skin_enabled"]            = "Skin do correio ativado",
    ["msg_mail_skin_disabled"]           = "Skin do correio desativado (reload para reverter)",

    -- =====================
    -- WORLD QUEST TAB
    -- =====================
    ["tab_qol_world_quests"]             = "Missões do mundo",
    ["section_wq_tab"]                   = "Aba de missões do mundo",
    ["info_wq_tab_desc"]                 = "Adiciona uma aba de missões mundiais ao diário com busca, ordenação, recompensas, zona e tempo restante. Clique para rastrear uma missão e mostrar sua zona no mapa.",
    ["opt_wq_enable"]                    = "Ativar aba de missões do mundo",
    ["opt_wq_auto_show"]                 = "Abrir esta aba por padrão com o diário de missões",
    ["opt_wq_max_quests"]                = "Máx. missões exibidas (0 = ilimitado)",
    ["opt_wq_min_time"]                  = "Tempo restante mín. (minutos, 0 = todas)",
    ["section_wq_filters"]               = "Filtros de recompensa",
    ["opt_wq_filter_gold"]               = "Mostrar recompensas de ouro",
    ["opt_wq_filter_gear"]               = "Mostrar recompensas de equipamento",
    ["opt_wq_filter_rep"]                = "Mostrar recompensas de reputação",
    ["opt_wq_filter_currency"]           = "Mostrar recompensas de moeda",
    ["opt_wq_filter_anima"]              = "Mostrar recompensas de ânima",
    ["opt_wq_filter_pet"]                = "Mostrar recompensas de mascote",
    ["opt_wq_filter_other"]              = "Mostrar outras recompensas",
    ["wq_tab_title"]                     = "MM Lista",
    ["wq_panel_title"]                   = "Missões do mundo",
    ["wq_col_name"]                      = "Nome",
    ["wq_col_zone"]                      = "Zona",
    ["wq_col_reward"]                    = "Recompensa",
    ["wq_col_time"]                      = "Tempo",
    ["wq_zone"]                          = "Zona",
    ["wq_faction"]                       = "Facção",
    ["wq_reward"]                        = "Recompensa",
    ["wq_time_left"]                     = "Tempo restante",
    ["wq_elite"]                         = "Missão do mundo elite",
    ["wq_sort_time"]                     = "Tempo",
    ["wq_sort_zone"]                     = "Zona",
    ["wq_sort_name"]                     = "Nome",
    ["wq_sort_reward"]                   = "Recompensa",
    ["wq_sort_faction"]                  = "Facção",
    ["wq_status_count"]                  = "Exibindo %d / %d missões",
    ["wq_empty"]                         = "Nenhuma missão mundial corresponde a estes filtros.",
    ["wq_expired"]                       = "Expirada",
    ["wq_click_hint"]                    = "Clique: rastrear e mostrar no mapa",
    ["wq_refresh_short"]                 = "A",
    ["wq_reward_gear"]                   = "Equipamento",
    ["wq_reward_reputation"]             = "Reputação",
    ["wq_reward_pet"]                    = "Mascote",
    ["wq_reward_other"]                  = "Outro",

    -- Profession Helper
    ["tab_qol_prof_helper"]              = "Profissões",
    ["section_prof_helper"]              = "Auxiliar de profissões",
    ["info_prof_helper_desc"]            = "Desencantar, triturar e prospectar itens em lote com uma interface visual.",
    ["opt_prof_helper_enable"]           = "Ativar auxiliar de profissões",
    ["sublabel_prof_de_filters"]         = "— Filtros de qualidade de desencantamento —",
    ["opt_prof_filter_green"]            = "Incluir itens Incomuns (Verdes)",
    ["opt_prof_filter_blue"]             = "Incluir itens Raros (Azuis)",
    ["opt_prof_filter_epic"]             = "Incluir itens Épicos (Roxos)",
    ["btn_prof_open_helper"]             = "Abrir auxiliar de profissões",
    ["ph_title"]                         = "Auxiliar de profissões",
    ["ph_tab_disenchant"]                = "Desencantar",
    ["ph_filter_quality"]                = "Qualidade:",
    ["ph_quality_green"]                 = "Verde",
    ["ph_quality_blue"]                  = "Azul",
    ["ph_quality_epic"]                  = "Épico",
    ["ph_select_all"]                    = "Selecionar tudo",
    ["ph_deselect_all"]                  = "Desmarcar tudo",
    ["ph_btn_process"]                   = "Processar",
    ["ph_btn_click_process"]             = "Clique para processar",
    ["ph_btn_stop"]                      = "Parar",
    ["ph_status_idle"]                   = "Clique em Processar",
    ["ph_status_processing"]             = "Processando %d/%d: %s",
    ["ph_status_done"]                   = "Pronto! Todos os itens processados.",
    ["ph_item_count"]                    = "%d itens disponíveis",
    ["ph_ilvl"]                          = "iLvl %d",

    -- ── Class Reminder ──────────────────────────────────────────
    ["tab_qol_class_reminder"]           = "Lembrete de classe",
    ["section_class_reminder"]           = "Lembrete de buff / forma de classe",
    ["info_class_reminder"]              = "Mostra um ícone para cada bônus, forma, postura ou aura de classe que esteja faltando. Clique esquerdo para conjurar, clique do meio para ocultar até a próxima tela de carregamento.",
    ["opt_class_reminder_enable"]        = "Ativar lembrete de classe",
    ["opt_class_reminder_scale"]         = "Escala da fileira",
    ["opt_class_reminder_color"]         = "Cor do rótulo",
    ["sublabel_class_reminder_pos"]      = "— Posição —",
    ["info_class_reminder_clicks"]       = "O clique esquerdo conjura a magia que falta (apenas fora de combate). O clique do meio oculta o lembrete até a próxima tela de carregamento.",
    ["info_class_reminder_mover"]        = "Mova a fileira de ícones pelo painel de Movimentação, ou volte-a para o centro da tela.",
    ["sublabel_class_reminder_icons"]    = "— Ícones —",
    ["opt_class_reminder_icon_size"]     = "Tamanho do ícone",
    ["opt_class_reminder_spacing"]       = "Espaçamento dos ícones",
    ["opt_class_reminder_opacity"]       = "Opacidade",
    ["sublabel_class_reminder_text"]     = "— Rótulo —",
    ["opt_class_reminder_show_text"]     = "Mostrar rótulo sob os ícones",
    ["opt_class_reminder_text_size"]     = "Tamanho do rótulo",
    ["sublabel_class_reminder_glow"]     = "— Brilho —",
    ["opt_class_reminder_glow"]          = "Tipo de brilho",
    ["opt_class_reminder_glow_color"]    = "Cor do brilho",
    ["cr_glow_none"]                     = "Nenhum",
    ["cr_glow_pixel"]                    = "Brilho de pixels",
    ["cr_glow_autocast"]                 = "Cintilação",
    ["cr_glow_button"]                   = "Brilho de botão de ação",
    ["cr_glow_proc"]                     = "Brilho de proc",
    ["info_class_reminder_preview_hint"] = "Clique em um ícone para ir ao seu interruptor, no rótulo para as opções de rótulo, ou na área vazia para o tamanho.",
    ["info_class_reminder_coverage"]     = "Desmarque aquilo sobre o que não quer ser lembrado. No jogo apenas a sua própria classe é verificada.",
    ["cr_lethal_poison"]                 = "Veneno letal",
    ["cr_nonlethal_poison"]              = "Veneno não letal",
    ["cr_flametongue"]                   = "Arma Língua de Fogo",
    ["cr_windfury"]                      = "Arma Fúria do Vento",
    ["cr_earthliving"]                   = "Arma Terra Viva",
    ["cr_tidecaller"]                    = "Guarda do Chamamarés",
    ["cr_thunderstrike"]                 = "Guarda de Golpe Trovão",
    ["cr_earth_shield_self"]             = "Escudo de Terra (próprio)",
    ["cr_orbit_shield"]                  = "Escudo de Relâmpagos / de Água",
    ["cr_shield"]                        = "Escudo",
    ["cr_paladin_rite"]                  = "Rito",
    ["sublabel_class_reminder_context"]  = "— Contexto —",
    ["opt_class_reminder_show_in"]       = "Mostrar lembretes",
    ["cr_show_always"]                   = "Em toda parte",
    ["cr_show_instances"]                = "Apenas em masmorras e raides",
    ["cr_show_group"]                    = "Apenas em grupo",
    ["opt_class_reminder_hide_resting"]  = "Ocultar em cidades e estalagens",
    ["opt_class_reminder_others_missing"] = "Avisar também quando falta um bônus a um membro do grupo",
    ["info_class_reminder_others"]       = "Apenas membros ao alcance que se beneficiam do bônus são contados, e apenas fora de combate: as auras de outro jogador não podem ser lidas em combate.",

    -- Buff / Form names
    ["cr_fortitude"]                     = "Palavra de Poder: Fortitude",
    ["cr_shadowform"]                    = "Forma de Sombra",
    ["cr_arcane_intellect"]              = "Intelecto Arcano",
    ["cr_skyfury"]                       = "Fúria Celeste",
    ["cr_mark_of_the_wild"]              = "Marca da Natureza",
    ["cr_cat_form"]                      = "Forma de Felino",
    ["cr_bear_form"]                     = "Forma de Urso",
    ["cr_moonkin_form"]                  = "Forma de Lua-Coruja",
    ["cr_battle_shout"]                  = "Grito de Batalha",
    ["cr_battle_stance"]                 = "Postura de Batalha",
    ["cr_berserker_stance"]              = "Postura Berserker",
    ["cr_defensive_stance"]              = "Postura Defensiva",
    ["cr_aura"]                          = "Aura",
    ["cr_blessing_bronze"]               = "Bênção do Bronze",
    ["cr_preview_sample"]                = "Exemplo: buff de classe ausente",

    -- =====================
    -- MYTHIC TRACKER (TomoMythic integration)
    -- =====================
    ["tmt_cmd_usage"]               = "|cFF55B400/tmt|r : configurações  |  |cFF55B400unlock|r : mover  |  |cFF55B400lock|r : travar  |  |cFF55B400reset|r : redefinir posição  |  |cFF55B400preview|r : pré-visualizar  |  |cFF55B400key|r : chaves do grupo  |  |cFF55B400kr|r : roleta  |  |cFF55B400keysync|r : diagnóstico de sincronização",
    ["tmt_unlock_msg"]              = "|cffffd100TomoModForever|r M+ Tracker: Moldura destravada \226\128\148 arraste para reposicionar.",
    ["tmt_lock_msg"]                = "|cffffd100TomoModForever|r M+ Tracker: Moldura travada.",
    ["tmt_reset_msg"]               = "|cffffd100TomoModForever|r M+ Tracker: Posição redefinida.",
    ["tmt_unknown_cmd"]             = "|cffffd100TomoModForever|r M+ Tracker: Comando desconhecido.",
    ["tmt_key_level"]               = "+%d",
    ["tmt_dungeon_unknown"]         = "Mítico+",
    ["tmt_overtime"]                = "TEMPO ESGOTADO",
    ["tmt_completed_on_time"]       = "CONCLUÍDO",
    ["tmt_completed_depleted"]      = "FRACASSADO",
    ["tmt_forces"]                  = "FORÇAS",
    ["tmt_forces_done"]             = "COMPLETO",
    ["tmt_forces_pct"]              = "%.1f%%",
    ["tmt_forces_count"]            = "%d / %d",
    ["tmt_forces_remaining"]        = "%d restantes",
    ["tmt_deaths"]                  = "Mortes",
    ["tmt_time_lost"]               = "Tempo perdido: %s",
    ["tmt_cfg_preset"]              = "Estilo",
    ["tmt_cfg_preset_panel"]        = "Painel",
    ["tmt_cfg_preset_hud"]          = "HUD",
    ["tmt_cfg_show_background"]     = "Fundo do painel",
    ["tmt_cfg_show_header"]         = "Bloco de cabeçalho",
    ["tmt_cfg_show_dungeon"]        = "Nome da masmorra",
    ["tmt_cfg_objective_style"]     = "Lista de chefes",
    ["tmt_cfg_objective_rows"]      = "Linhas",
    ["tmt_cfg_objective_text"]      = "Texto",
    ["tmt_cfg_font_scale"]          = "Tamanho do texto",
    ["tmt_cfg_preset_minimal"]        = "Mínimo",
    ["tmt_cfg_objective_none"]        = "Oculta",
    ["tmt_cfg_timer_layout"]          = "Layout do cronômetro",
    ["tmt_cfg_timer_stacked"]         = "Duas linhas",
    ["tmt_cfg_timer_inline"]          = "Uma linha",
    ["tmt_cfg_segment_colors"]        = "Cores dos segmentos",
    ["tmt_cfg_segment_palier"]        = "Por nível",
    ["tmt_cfg_segment_brand"]         = "Marca",
    ["tmt_cfg_splits"]                = "Comparar com o melhor tempo",
    ["tmt_cfg_checkpoints"]           = "Pontos de controle de for\195\167as",
    ["tmt_cfg_clear_splits"]          = "Limpar tempos registrados",
    ["tmt_splits_cleared"]            = "|cffffd100TomoModForever|r M+ Tracker: tempos registrados limpos.",
    ["tmt_cds_reload_text"]           = "O Cooldown Studio continua carregado até a interface ser recarregada. Recarregar agora o libera e limpa o taint desta sessão.",
    ["tmt_cds_reload_now"]            = "Recarregar",
    ["tmt_cds_reload_later"]          = "Mais tarde",
    ["tmt_cfg_cds_safety_reload"]     = "Recarregar a interface ao fechar o Studio",
    ["tmt_cfg_title"]               = "Mythic",
    ["tmt_cfg_panel_enable"]         = "Ativar tracker M+",
    ["tmt_cfg_show_timer"]          = "Mostrar barra de tempo",
    ["tmt_cfg_show_forces"]         = "Mostrar forças inimigas",
    ["tmt_cfg_show_bosses"]         = "Mostrar temporizadores de chefe",
    ["tmt_cfg_hide_blizzard"]       = "Ocultar rastreador da Blizzard",
    ["tmt_cfg_lock"]                = "Travar moldura",
    ["tmt_cfg_scale"]               = "Escala",
    ["tmt_cfg_alpha"]               = "Opacidade do fundo",
    ["tmt_cfg_reset_pos"]           = "Redefinir posição",
    ["tmt_cfg_preview"]             = "Pré-visualizar",
    ["tmt_cfg_section_display"]     = "Exibição",
    ["tmt_cfg_section_frame"]       = "Moldura",
    ["tmt_cfg_section_actions"]     = "Ações",
    ["tmt_key_not_available"]       = "não disponível.",
    ["tmt_key_not_in_group"]        = "Você não está em um grupo.",
    ["tmt_key_none_found"]          = "Nenhuma chave encontrada.",
    ["tmt_kr_spin"]                 = "|TInterface\\Icons\\INV_Misc_Dice_02:14|t  Girar!",
    ["tmt_preview_active"]          = "|cffffd100TomoModForever|r M+ Tracker: Pré-visualização ativa \226\128\148 |cFF55B400/tmt lock|r para travar.",

    -- MythicHub
    ["mhub_title"]                  = "Pontua\195\167\195\163o M\195\173tica+",
    ["mhub_col_dungeon"]            = "Masmorra",
    ["mhub_col_level"]              = "N\195\173vel",
    ["mhub_col_rating"]             = "Pontua\195\167\195\163o",
    ["mhub_col_best"]               = "Melhor",
    ["mhub_tp_click"]               = "Clique para se teletransportar",
    ["mhub_tp_not_available"]        = "Teletransporte n\195\163o aprendido",
    ["mhub_tp_not_learned"]          = "|cffffd100TomoModForever|r: Feiti\195\167o de teletransporte n\195\163o aprendido.",
    ["mhub_vault_title"]            = "Grande C\195\162mara",
    ["mhub_vault_dungeons"]         = "Masmorras",
    ["mhub_vault_raids"]            = "Raides",
    ["mhub_vault_world"]            = "Abismos",
    ["mhub_vault_ilvl"]             = "N\195\173vel do item",
    ["mhub_vault_locked"]           = "Bloqueado",
    ["mhub_vault_claim"]            = "Volte \195\160 Grande C\195\162mara para reivindicar sua recompensa",

    -- ══════════════════════════════════════════════════════════
    -- INSTALLER
    -- ══════════════════════════════════════════════════════════

    -- Navigation
    ["ins_header_title"]             = "|cffffd100Tomo|r|cfff2ebdbMod|r |cffc9a252Forever|r  \226\128\148  Assistente de configura\195\167\195\163o",
    ["ins_step_counter"]             = "Etapa %d / %d",
    ["ins_btn_prev"]                 = "|TInterface\\BUTTONS\\UI-SpellbookIcon-PrevPage:0|t Anterior",
    ["ins_btn_next"]                 = "Pr\195\179ximo |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t",
    ["ins_btn_finish"]               = "Concluir |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t",
    ["ins_btn_skip"]                 = "Pular instala\195\167\195\163o",

    -- Step 1: Welcome
    ["ins_step1_title"]              = "Bem-vindo ao TomoMod",
    ["ins_subtitle"]                 = "Suite de interface e QOL para The War Within",
    ["ins_welcome_desc"]             = "Este assistente ir\195\161 gui\195\161-lo em |cffffd10016 etapas|r para configurar o TomoMod de\nacordo com suas prefer\195\170ncias: unit frames, party frames, castbars, nameplates, barras de a\195\167\195\163o,\nrecursos, skins, som, Mythic+, QOL, otimiza\195\167\195\181es e SkyRide.\n\nTodas essas op\195\167\195\181es podem ser alteradas a qualquer momento via |cffffd100/tmf|r.",

    -- Step 2: Profile
    ["ins_step2_title"]              = "Perfil de jogo",
    ["ins_profile_info"]             = "Crie um perfil nomeado para salvar sua configura\195\167\195\163o.",
    ["ins_profile_section"]          = "Nome do perfil",
    ["ins_profile_placeholder"]      = "Meu perfil",
    ["ins_profile_create"]           = "Criar perfil",
    ["ins_profile_created"]          = "Perfil criado: ",
    ["ins_spec_section"]             = "Atribui\195\167\195\163o de especializa\195\167\195\163o",
    ["ins_spec_info"]                = "Voc\195\170 pode atribuir este perfil \195\160s suas specs no painel Perfis (/tmf).\nCada spec pode usar uma configura\195\167\195\163o diferente.",

    -- Step 3: Visual Skins
    ["ins_step3_title"]              = "Skins visuais",
    ["ins_skins_info"]               = "Personalize a interface da Blizzard com o tema escuro do TomoMod.",
    ["ins_skins_section"]            = "Skins dispon\195\173veis",
    ["ins_skin_gamemenu"]            = "Skin do menu do jogo (Escape)",
    ["ins_skin_actionbar"]           = "Skin dos bot\195\181es da barra de a\195\167\195\163o",
    ["ins_skin_chat"]                = "Skin do chat",
    ["ins_skin_character"]           = "Skin da ficha de personagem",
    ["ins_skin_style_section"]       = "Estilo dos bot\195\181es da barra de a\195\167\195\163o",
    ["ins_skin_style"]               = "Estilo visual",

    -- Step 4: Tank Mode
    ["ins_step4_title"]              = "Modo Tank",
    ["ins_tank_info"]                = "No modo tank, as nameplates e UnitFrames exibem\no status de amea\195\167a por cor para cada inimigo.",
    ["ins_tank_np_section"]          = "Nameplates \226\128\148 Cores de amea\195\167a",
    ["ins_tank_enable_np"]           = "Ativar modo tank (nameplates)",
    ["ins_tank_colors_info"]         = "Verde = voc\195\170 tem aggro  \194\183  Laranja = perto de perder  \194\183  Vermelho = aggro perdido",
    ["ins_tank_uf_section"]          = "UnitFrames \226\128\148 Indicador de amea\195\167a",
    ["ins_tank_threat_indicator"]    = "Mostrar indicador de amea\195\167a no alvo",
    ["ins_tank_threat_text"]         = "Mostrar texto de amea\195\167a % no alvo",
    ["ins_tank_cotank_section"]      = "CoTank Tracker",
    ["ins_tank_cotank_enable"]       = "Ativar rastreamento do co-tank",
    ["ins_tank_cotank_info"]         = "Exibe a amea\195\167a do segundo tank nas inst\195\162ncias.",

    -- Step 5: Nameplates
    ["ins_step5_title"]              = "Nameplates",
    ["ins_np_general"]               = "Geral",
    ["ins_np_enable"]                = "Ativar nameplates do TomoMod",
    ["ins_np_reload_info"]           = "Um reload \195\169 necess\195\161rio para ativar/desativar as nameplates.",
    ["ins_np_display"]               = "Exibi\195\167\195\163o",
    ["ins_np_class_colors"]          = "Cores de classe",
    ["ins_np_castbar"]               = "Mostrar barra de lan\195\167amento",
    ["ins_np_health_text"]           = "Mostrar texto de sa\195\186de (porcentagem)",
    ["ins_np_auras"]                 = "Mostrar auras (debuffs)",
    ["ins_np_role_icons"]            = "Mostrar \195\173cones de fun\195\167\195\163o (masmorra)",
    ["ins_np_dimensions"]            = "Dimens\195\181es",
    ["ins_np_width"]                 = "Largura",

    -- Step 6: Action Bars
    ["ins_step6_title"]              = "Barras de a\195\167\195\163o",
    ["ins_ab_system_section"]        = "Action Bar System",
    ["ins_ab_system_info"]           = "TomoMod replaces Blizzard's action bars with custom containers,\npositioning, fade system and display conditions.\nDisable this to fully restore the default Blizzard action bars.",
    ["ins_ab_system_enable"]         = "Enable TomoMod Action Bar system",
    ["ins_ab_system_reload_info"]    = "Requires a /reload to take effect.",
    ["ins_ab_skin_section"]          = "Skin dos bot\195\181es",
    ["ins_ab_enable"]                = "Ativar skin nos bot\195\181es de a\195\167\195\163o",
    ["ins_ab_class_color"]           = "Cor da borda = cor da classe",
    ["ins_ab_shift_reveal"]          = "Segure Shift para revelar barras ocultas",
    ["ins_ab_opacity_section"]       = "Opacidade global das barras",
    ["ins_ab_opacity"]               = "Opacidade",
    ["ins_ab_manage_section"]        = "Gerenciamento de barras",
    ["ins_ab_manage_info"]           = "Use o painel Barras de a\195\167\195\163o (/tmf |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Barras de a\195\167\195\163o |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Gerenciamento)\npara desbloquear e reposicionar cada barra.",

    -- Step 7: LustSound
    ["ins_step7_title"]              = "Som \226\128\148 Hero\195\173smo / Sede de sangue",
    ["ins_sound_info"]               = "Reproduz um som personalizado quando Hero\195\173smo ou Sede de sangue\n\195\169 lan\195\167ado por qualquer membro do grupo.",
    ["ins_sound_activation"]         = "Ativa\195\167\195\163o",
    ["ins_sound_enable"]             = "Ativar som de lust",
    ["ins_sound_choice"]             = "Sele\195\167\195\163o de som",
    ["ins_sound_sound"]              = "Som",
    ["ins_sound_channel"]            = "Canal de \195\161udio",
    ["ins_sound_default"]            = "Padr\195\163o",
    ["ins_sound_preview_section"]    = "Pr\195\169-visualiza\195\167\195\163o",
    ["ins_sound_preview_btn"]        = "|TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t Pr\195\169-visualizar",

    -- Step 8: Mythic+
    ["ins_step8_title"]              = "Mythic+ \226\128\148 Tracker e Placar",
    ["ins_mplus_tracker_section"]    = "M+ Tracker",
    ["ins_mplus_tracker_info"]       = "Exibe um temporizador, for\195\167as, chefes e progresso\nda sua masmorra Mythic+ em tempo real.",
    ["ins_mplus_tracker_enable"]     = "Ativar M+ Tracker",
    ["ins_mplus_show_timer"]         = "Mostrar temporizador",
    ["ins_mplus_show_forces"]        = "Mostrar for\195\167as (%)",
    ["ins_mplus_hide_blizzard"]      = "Ocultar interface Blizzard em Mythic+",
    ["ins_mplus_score_section"]      = "TomoScore \226\128\148 Placar",
    ["ins_mplus_score_info"]         = "Exibe pontua\195\167\195\181es pessoais e de grupo ao final de um Mythic+.",
    ["ins_mplus_score_enable"]       = "Ativar TomoScore",
    ["ins_mplus_score_auto"]         = "Mostrar automaticamente em M+",

    -- Step 9: CVars
    ["ins_step9_title"]              = "Otimiza\195\167\195\181es do sistema (CVars)",
    ["ins_cvar_info"]                = "O TomoMod pode aplicar um conjunto de CVars WoW recomendadas\npara melhorar desempenho e responsividade.",
    ["ins_cvar_section"]             = "Otimiza\195\167\195\181es inclu\195\173das",
    ["ins_cvar_opt1"]                = "Reduzir Level of Detail (LOD) desnecess\195\161rio",
    ["ins_cvar_opt2"]                = "Otimizar frustum culling",
    ["ins_cvar_opt3"]                = "Desativar temporal AA excessivo",
    ["ins_cvar_opt4"]                = "Melhorar responsividade de rede",
    ["ins_cvar_opt5"]                = "Desativar anima\195\167\195\181es de interface desnecess\195\161rias",
    ["ins_cvar_opt6"]                = "Otimizar streaming de texturas",
    ["ins_cvar_success"]             = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t  CVars aplicadas com sucesso!",
    ["ins_cvar_apply_btn"]           = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0|t Aplicar todas as CVars",
    ["ins_cvar_applied"]             = "CVars otimizadas aplicadas.",

    -- Step 10: QOL
    ["ins_step10_title"]             = "Qualidade de vida (QOL)",
    ["ins_qol_info"]                 = "Ative os m\195\179dulos QOL que desejar.\nTodos s\195\163o acess\195\173veis separadamente em /tmf |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t QOL.",
    ["ins_qol_auto_section"]         = "Automatiza\195\167\195\181es",
    ["ins_qol_auto_repair"]          = "Reparar automaticamente no comerciante",
    ["ins_qol_fast_loot"]            = "Loot r\195\161pido (coleta r\195\161pida de itens)",
    ["ins_qol_skip_cinematics"]      = "Pular cinem\195\161ticas j\195\161 vistas",
    ["ins_qol_hide_talking_head"]    = "Ocultar Talking Head (di\195\161logos de rolagem)",
    ["ins_qol_auto_accept"]          = "Aceitar convites de grupo automaticamente (amigos e guilda)",
    ["ins_qol_tooltip_ids"]          = "Mostrar IDs nos tooltips (spell ID, item ID...)",
    ["ins_qol_combat_section"]       = "Combate",
    ["ins_qol_combat_text"]          = "Texto flutuante de combate personalizado",
    ["ins_qol_hide_castbar"]         = "Ocultar barra de lan\195\167amento da Blizzard (usar a do TomoMod)",

    -- Step 11: SkyRide
    ["ins_step11_title"]             = "SkyRide \226\128\148 Barra de montaria drac\195\180nica",
    ["ins_skyride_info"]             = "SkyRide exibe uma barra de Vigor (6 cargas) e uma barra de\nSegundo F\195\180lego (3 cargas) para montaria drac\195\180nica.",
    ["ins_skyride_activation"]       = "Ativa\195\167\195\163o",
    ["ins_skyride_enable"]           = "Ativar barra SkyRide",
    ["ins_skyride_auto_info"]        = "A barra aparece automaticamente no modo de voo drac\195\180nico\ne se oculta fora dele.",
    ["ins_skyride_dimensions"]       = "Dimens\195\181es",
    ["ins_skyride_width"]            = "Largura",
    ["ins_skyride_height"]           = "Altura",
    ["ins_skyride_reset_section"]    = "Redefinir posi\195\167\195\163o",
    ["ins_skyride_reset_btn"]        = "Redefinir posi\195\167\195\163o",

    -- Step 12: Done
    ["ins_step12_title"]             = "Configura\195\167\195\163o conclu\195\173da!",
    ["ins_done_check"]               = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t  Tudo pronto!",
    ["ins_done_recap"]               = "Sua configura\195\167\195\163o do TomoMod est\195\161 salva. Alguns lembretes:\n\n|cffffd100/tmf|r              |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t  Abrir o painel de configura\195\167\195\163o\n|cffffd100/tmf sr|r           |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t  Desbloquear e mover elementos\n|cffffd100/tmf install|r      |TInterface\\BUTTONS\\UI-SpellbookIcon-NextPage:0|t  Relan\195\167ar este instalador\n\nTodas as op\195\167\195\181es configuradas aqui podem ser alteradas a qualquer momento\nnos pain\195\169is correspondentes na GUI do TomoMod.\n\nUm |cffffd100reload da UI|r \195\169 necess\195\161rio para aplicar certas altera\195\167\195\181es\n(nameplates, skins, UnitFrames).",
    ["ins_done_reload"]              = "|TInterface\\BUTTONS\\UI-RefreshButton:0|t  Recarregar UI",

    -- Step NEW: Unit Frames
    ["ins_uf_title"]                 = "Unit Frames",
    ["ins_uf_info"]                  = "O TomoMod substitui os quadros de unidade padr\195\163o da Blizzard (jogador, alvo, foco, pet)\npor quadros modernos e personaliz\195\161veis.",
    ["ins_uf_section"]               = "Geral",
    ["ins_uf_enable"]                = "Ativar UnitFrames do TomoMod",
    ["ins_uf_hide_blizzard"]         = "Ocultar quadros padr\195\163o da Blizzard",
    ["ins_uf_reload_info"]           = "Um reload \195\169 necess\195\161rio para aplicar altera\195\167\195\181es nos UnitFrames.",

    -- Step NEW: Party Frames
    ["ins_pf_title"]                 = "Party Frames",
    ["ins_pf_info"]                  = "Quadros de grupo personalizados com \195\173cones de fun\195\167\195\163o, destaque de dissipa\195\167\195\163o\ne rastreamento de cooldowns para jogo em grupo.",
    ["ins_pf_section"]               = "Geral",
    ["ins_pf_enable"]                = "Ativar Party Frames do TomoMod",
    ["ins_pf_hide_blizzard"]         = "Ocultar Party Frames da Blizzard",
    ["ins_pf_cd_section"]            = "Rastreadores de cooldown",
    ["ins_pf_cd_info"]               = "Rastreie os cooldowns de interrup\195\167\195\163o e ressurrei\195\167\195\163o de combate\ndos seus companheiros diretamente nos quadros de grupo.",
    ["ins_pf_show_interrupt"]        = "Mostrar rastreador de cooldown de interrup\195\167\195\163o",
    ["ins_pf_show_brez"]             = "Mostrar rastreador de cooldown de ressurrei\195\167\195\163o de combate",
    ["ins_pf_reload_info"]           = "Um reload \195\169 necess\195\161rio para aplicar altera\195\167\195\181es nos Party Frames.",

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
    ["ins_cb_title"]                 = "Barras de lan\195\167amento",
    ["ins_cb_info"]                  = "Barras de lan\195\167amento personalizadas para jogador, alvo, foco e pet\ncom anima\195\167\195\163o de fa\195\173sca e feedback de interrup\195\167\195\163o.",
    ["ins_cb_section"]               = "Geral",
    ["ins_cb_enable"]                = "Ativar castbars do TomoMod",
    ["ins_cb_hide_blizzard"]         = "Ocultar castbar padr\195\163o da Blizzard",
    ["ins_cb_class_color"]           = "Usar cor da classe para o preenchimento",
    ["ins_cb_reload_info"]           = "Um reload \195\169 necess\195\161rio para aplicar altera\195\167\195\181es nas castbars.",

    -- Step NEW: Resource Bars & Cooldown Manager
    ["ins_res_title"]                = "Recursos & Cooldowns",
    ["ins_res_info"]                 = "Exibi\195\167\195\163o de poder de classe (pontos de combo, runas, fragmentos de alma, etc.)\nem modo \195\173cone ou barra.",
    ["ins_res_section"]              = "Barras de recursos",
    ["ins_res_enable"]               = "Ativar barras de recursos",
    ["ins_res_display"]              = "Modo de exibi\195\167\195\163o",
    ["ins_cdm_section"]              = "Gerenciador de cooldowns",
    ["ins_cdm_info"]                 = "Espiral de cooldown nos bot\195\181es de a\195\167\195\163o com\nalfa adaptativo ao combate e filtragem de GCD.",
    ["ins_cdm_enable"]               = "Ativar gerenciador de cooldowns",
    ["ins_cdm_hide_gcd"]             = "Ocultar espiral de GCD",
    ["ins_cdm_desat"]                = "Dessaturar bot\195\181es em cooldown",

    -- Enhanced Skins
    ["ins_skin_bag"]                 = "Skin de bolsas",
    ["ins_skin_tooltip"]             = "Skin de tooltips",
    ["ins_skin_objective"]           = "Objective Tracker skin (color-coded quest types)",
    ["ins_skin_mail"]                = "Mail skin",
    ["ins_skin_reputation"]          = "Reputation bar",

    -- Enhanced QOL
    ["ins_qol_interface_section"]    = "Interface",
    ["ins_qol_minimap"]              = "Minimapa personalizado (borda e escala)",
    ["ins_qol_cursor"]               = "Anel de cursor luminoso",
    ["ins_qol_afk"]                  = "Tela AFK personalizada com modelo 3D",
    ["ins_qol_diag"]                 = "Diagn\195\179sticos (captura de erros sem popups)",
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
    ["section_bar_opacity"]          = "Opacidade por barra",
    ["opt_abs_bar_select"]           = "Barra a configurar",
    ["opt_abs_opacity"]              = "Opacidade",
    ["btn_abs_apply_all"]            = "Aplicar a todas as barras",
    ["opt_abs_combat_only_label"]    = "Exibir apenas em combate:",
    ["opt_abs_combat_only"]          = "Barra vis\195\173vel apenas em combate",
    ["section_bar_management"]       = "Gerenciamento de barras de a\195\167\195\163o",
    ["btn_abs_unlock"]               = "Desbloquear barras",
    ["info_abs_unlock"]              = "Desbloqueie as barras para exibir as al\195\167as de arrasto.\nClique com o bot\195\163o direito em uma al\195\167a para configurar uma barra individualmente.",
    ["section_bar_quick"]            = "Configura\195\167\195\181es r\195\161pidas",
    ["tab_abs_skin"]                 = "Skin de bot\195\181es",
    ["tab_abs_bars"]                 = "Gerenciamento de barras",
    ["info_abs_layout"]              = "Use o EditMode para mover as barras ou arraste as sobreposi\195\167\195\181es.\nExpanda uma barra abaixo para ajustar o tamanho dos bot\195\181es e a escala.",
    -- General panel
    ["opt_gui_scale"]                = "Escala da janela de configura\195\167\195\163o",
    ["info_gui_scale"]               = "Escala da janela /tmf \226\128\148 tamb\195\169m \195\169 poss\195\173vel redimension\195\161-la arrastando o canto inferior direito.",
    ["btn_gui_reset_size"]           = "Redefinir tamanho e escala da janela",
    ["btn_relaunch_installer"]       = "Relan\195\167ar instalador",
    ["info_relaunch_installer"]      = "Inicia o assistente de configura\195\167\195\163o de 16 etapas.",
    -- Sound panel
    ["section_sound_preview"]        = "Pr\195\169-visualiza\195\167\195\163o e op\195\167\195\181es",
    -- UFPreview
    ["preview_header"]               = "PR\195\137-VISUALIZA\195\135\195\131O AO VIVO",
    ["preview_player"]               = "Jogador",
    ["preview_target_name"]          = "Taurache",
    ["preview_focus_name"]           = "Sacerdotisa",
    ["preview_pet_name"]             = "Lobo d'\195\161gua",
    ["preview_tot_name"]             = "Alvo-do-alvo",
    ["preview_cast_player"]          = "Rel\195\162mpago de Gelo",
    ["preview_cast_target"]          = "Bola de Fogo",
    ["preview_lbl_player"]           = "JOGADOR",
    ["preview_lbl_target"]           = "ALVO",
    ["preview_lbl_focus"]            = "FOCO",
    ["preview_lbl_pet"]              = "PET",
    ["preview_lbl_tot"]              = "TOT",
    ["preview_click_nav"]            = "clique para navegar",
    ["preview_click_isolate"]         = "clique para isolar",
    ["preview_click_show_all"]        = "clique para mostrar tudo",
    ["preview_show_all"]              = "Mostrar tudo",
    ["preview_zoom_fit"]                = "Ajustar",
    ["preview_zoom_11"]                 = "1:1",
    ["preview_zoom_tip"]                = "Alterna entre ajuste ao painel e tamanho real 1:1.",
    ["preview_all_disabled"]            = "Todos os quadros de unidade est\195\163o desativados.",
    ["preview_engine_missing"]          = "Motor UnitFrames n\195\163o carregado.",
    ["preview_data_live"]               = "Dados reais",
    ["preview_data_mock"]               = "Simulado",
    ["preview_data_tip"]                = "Alimenta a pr\195\169via com dados reais quando a unidade existe; caso contr\195\161rio, usa valores simulados.",
    ["preview_tag_live"]                = "REAL",
    ["preview_tag_sim"]                 = "SIM",
    -- ConfigUI footer
    ["ui_footer_hint"]               = "/tmf  \194\183  /tmf sr para mover elementos",

    -- =====================
    -- SKINS CATEGORY (top-level)
    -- =====================
    ["cat_skins"]                        = "Skins",

    -- Chat Frame V2 — r\195\179tulos das abas e interface
    ["chatv2_tab_general"]               = "Geral",
    ["chatv2_tab_instance"]              = "Inst\195\162ncia",
    ["chatv2_tab_chucho"]                = "Chucho",
    ["chatv2_tab_personnel"]             = "Pessoal",
    ["chatv2_tab_combat"]                = "Combate",
    ["chatv2_sidebar_title"]             = "CHAT",
    ["chatv2_expand_btn"]                = "Chat",
    ["chatv2_mover_label"]               = "Janela de chat V2",
    ["chatv2_input_hint"]                = "Pressione Enter para digitar...",

    -- Skins > Chat Frame tab
    ["tab_skin_chatframe"]               = "Janela de chat",
    ["section_skin_chatframe"]           = "Skin da janela de chat",
    ["info_skin_chatframe_desc"]         = "Painel de chat com barra lateral \226\128\148 Geral, Inst\195\162ncia, Chucho, Pessoal, Combate \226\128\148 com emblemas de n\195\163o lidos e indicadores de pin.",
    ["opt_skin_chatframe_enable"]        = "Ativar skin de chat",
    ["opt_skin_chatframe_width"]         = "Largura",
    ["opt_skin_chatframe_height"]        = "Altura",
    ["opt_skin_chatframe_scale"]         = "Escala %",
    ["opt_skin_chatframe_opacity"]       = "Opacidade do fundo",
    ["opt_skin_chatframe_font_size"]     = "Tamanho da fonte",
    ["opt_skin_chatframe_timestamp"]     = "Mostrar data/hora",

    -- Skins > Bags tab
    ["tab_skin_bags"]                    = "Bolsas",
    ["section_skin_bags"]                = "Skin das bolsas",
    ["info_skin_bags_desc"]              = "Grade de bolsas por categoria inspirada no BetterBags. Itens agrupados em se\195\167\195\181es dobr\195\161veis com bordas de qualidade, busca, tempos de recarga e n\195\173vel de item.",
    ["opt_skin_bags_enable"]             = "Ativar skin das bolsas",
    -- Bolsas — Desencantamento
    ["bagskin_currencies_none"]          = "Nenhuma moeda rastreada (clique direito em uma moeda \226\134\146 Mostrar na mochila)",
    ["opt_skin_bags_stack_merge"]        = "Fundir pilhas id\195\170nticas",
    ["opt_skin_bags_show_empty"]         = "Mostrar se\195\167\195\163o de espa\195\167os livres",
    ["opt_skin_bags_show_recent"]        = "Mostrar se\195\167\195\163o de itens recentes",
    ["opt_skin_bags_columns"]            = "Colunas",
    ["opt_skin_bags_slot_size"]          = "Tamanho do espa\195\167o",
    ["opt_skin_bags_slot_spacing"]       = "Espa\195\167amento",
    ["opt_skin_bags_scale"]              = "Escala %",
    ["opt_skin_bags_opacity"]            = "Opacidade do fundo",
    ["opt_skin_bags_quality_borders"]    = "Mostrar bordas de qualidade",
    ["bags_v4_quality_style"]            = "Qualidade do item",
    ["bags_v4_quality_tint"]             = "Espaço colorido",
    ["bags_v4_quality_border"]           = "Moldura colorida",
    ["bags_v4_quality_both"]             = "Ambos",
    ["bags_v4_quality_none"]             = "Nenhum",
    ["bags_v4_slot_pin"]                 = "Clique do meio: fixar",
    ["bags_v4_slot_unpin"]               = "Clique do meio: desafixar",
    ["bags_v4_sidebar_click"]            = "Clique esquerdo: encontrar nas bolsas",
    ["bags_v4_sidebar_unpin"]            = "Clique do meio: desafixar",
    ["opt_skin_bags_cooldowns"]          = "Mostrar tempos de recarga",
    ["opt_skin_bags_quantity"]           = "Mostrar emblemas de quantidade",
    ["opt_skin_bags_search"]             = "Mostrar barra de busca",
    ["opt_skin_bags_sort_mode"]          = "Modo de ordena\195\167\195\163o",
    ["opt_skin_bags_sort_quality"]       = "Qualidade",
    ["opt_skin_bags_sort_name"]          = "Nome",
    ["opt_skin_bags_sort_type"]          = "Tipo",
    ["opt_skin_bags_sort_ilvl"]          = "N\195\173vel de item",
    ["opt_skin_bags_sort_recent"]        = "Recente",
    ["opt_skin_bags_show_gold"]          = "Mostrar ouro (rodap\195\169)",
    ["opt_skin_bags_show_currencies"]    = "Mostrar moedas rastreadas (rodap\195\169)",

    -- Skins > Objective Tracker tab
    ["tab_skin_objtracker"]              = "Rastreador",

    -- Skins > Character tab
    ["tab_skin_character"]               = "Personagem",

    -- Skins > Buffs tab

    -- Skins > Game Menu tab
    ["tab_skin_gamemenu"]                = "Menu do jogo",

    -- Skins > Mail tab
    ["tab_skin_mail"]                    = "Correio",

    -- =====================
    -- MÓDULO WAYPOINT (/tmf way)
    -- =====================
    -- GUI
    ["tab_qol_waypoint"]                  = "Waypoint",
    ["section_waypoint"]                  = "Waypoint",
    ["opt_way_zone_only"]                 = "Mostrar apenas na zona atual",
    ["opt_way_size"]                      = "Tamanho do sinal",
    ["opt_way_shape"]                     = "Forma",
    ["way_shape_ring"]                    = "Anel",
    ["way_shape_arrow"]                   = "Seta",
    ["opt_way_color"]                     = "Cor do waypoint",
    -- Slash
    ["msg_help_way"]                     = "Colocar um waypoint na sua posição atual",
    ["msg_help_way_coords"]              = "Colocar um waypoint nas coordenadas (x, y)",
    ["msg_help_way_clear"]               = "Remover o waypoint ativo",
    ["way_cleared"]                      = "Waypoint removido.",
    ["way_set"]                          = "Waypoint definido em %s%s.",
    ["way_here"]                         = "Waypoint colocado na posição atual.",
    ["way_no_map"]                       = "Não foi possível determinar o mapa atual.",
    ["way_no_pos"]                       = "Não foi possível determinar a posição do jogador.",
    ["way_bad_map"]                      = "Não é possível colocar um waypoint neste mapa.",
    ["way_bad_coords"]                   = "As coordenadas devem estar entre 0 e 100.",
    ["way_usage"]                        = "Uso: /tmf way [mapID] x y [nome]  |  /tmf way clear",

    -- =====================
    -- Resource names
    -- =====================
    ["res_mana"]                        = "Mana (Druida)",
    ["res_soul_shards"]                 = "Estilhaços de Alma",
    ["res_holy_power"]                  = "Poder Sagrado",
    ["res_chi"]                         = "Chi",
    ["res_combo_points"]                = "Pontos de Combo",
    ["res_charged_combo_points"]        = "Pontos de Combo Sobrecarregados",
    ["res_arcane_charges"]              = "Cargas Arcanas",
    ["res_essence"]                     = "Essência",
    ["res_stagger"]                     = "Cambalear",
    ["res_soul_fragments"]              = "Fragmentos de Alma",
    ["res_tip_of_spear"]                = "Ponta da Lança",
    ["res_maelstrom_weapon"]            = "Arma de Maelstrom",
    ["res_icicles"]                      = "Icicles",

    -- =====================
    -- Resource Bars display mode
    -- =====================
    ["opt_rb_display_mode"]             = "Modo de exibição",
    ["display_mode_icons"]              = "Ícones (texturas TUI)",
    ["display_mode_bars"]               = "Barras (cores planas)",

    -- =====================
    -- Tooltip Skin
    -- =====================
    ["tab_skin_tooltip"]                 = "Tooltip",
    ["section_tooltip_skin"]             = "Skin de Tooltip",
    ["opt_tooltip_skin_enable"]          = "Ativar skin de tooltip",
    ["info_tooltip_skin_reload"]         = "Algumas mudanças exigem passar o cursor sobre um novo alvo.",
    ["opt_tooltip_bg_alpha"]             = "Opacidade do fundo",
    ["opt_tooltip_border_alpha"]         = "Opacidade da borda",
    ["opt_tooltip_bg_color"]              = "Cor do fundo",
    ["opt_tooltip_border_color"]          = "Cor da borda",
    ["opt_tooltip_font_size"]             = "Tamanho de fonte",
    ["opt_tooltip_hide_healthbar"]       = "Ocultar barra de vida",
    ["opt_tooltip_class_color"]          = "Nomes de jogador com cor da classe",
    ["opt_tooltip_hide_server"]          = "Ocultar servidor nos nomes de jogador",
    ["opt_tooltip_hide_title"]           = "Ocultar título nos nomes de jogador",
    ["opt_tooltip_guild_color"]          = "Cor personalizada do nome da guilda",
    ["opt_tooltip_guild_color_pick"]     = "Cor do nome da guilda",
    ["sublabel_tooltip_info"]            = "— Informações da unidade —",
    ["opt_tooltip_unit_info"]            = "Mostrar informações da unidade",
    ["info_tooltip_unit_info"]           = "Adiciona cargo de guilda, alvo, pontuação M+ e mais às dicas de unidade.",
    ["opt_tooltip_reaction_border"]      = "Colorir borda por reação / classe",
    ["opt_tooltip_color_level"]          = "Colorir nível por dificuldade",
    ["opt_tooltip_raid_marker"]          = "Mostrar ícone de marcador",
    ["opt_tooltip_role_icon"]            = "Mostrar ícone de função",
    ["opt_tooltip_class_icon"]           = "Mostrar ícone de classe",
    ["opt_tooltip_icon_size"]            = "Tamanho dos ícones",
    ["opt_tooltip_guild_rank"]           = "Mostrar cargo de guilda",
    ["opt_tooltip_guild_rank_index"]     = "Mostrar número do cargo",
    ["opt_tooltip_guild_realm"]          = "Mostrar reino da guilda",
    ["opt_tooltip_show_target"]          = "Mostrar alvo da unidade",
    ["opt_tooltip_mythic_score"]         = "Mostrar pontuação M+",
    ["opt_tooltip_mount"]                = "Mostrar montaria",
    ["opt_tooltip_speed"]                = "Mostrar velocidade de movimento",
    ["opt_tooltip_location"]             = "Mostrar localização",
    ["info_tooltip_location"]            = "A localização só está disponível para você e membros do seu grupo.",
    ["tt_guild_rank"]                    = "Cargo",
    ["tt_target"]                        = "Alvo",
    ["tt_target_you"]                    = "Você",
    ["tt_mythic_score"]                  = "Pontuação M+",
    ["tt_speed"]                         = "Velocidade",
    ["tt_mount"]                         = "Montaria",
    ["tt_location"]                      = "Localização",
    ["sublabel_tooltip_inspect"]         = "— Inspeção —",
    ["opt_tooltip_item_level"]           = "Mostrar nível de item",
    ["opt_tooltip_spec"]                 = "Mostrar especialização",
    ["opt_tooltip_spec_icon"]            = "Mostrar ícone de especialização",
    ["opt_tooltip_pending_text"]         = "Mostrar indicador durante o carregamento",
    ["info_tooltip_inspect"]             = "Nível de item e especialização exigem inspecionar o jogador: só aparecem dentro do alcance.",
    ["tt_item_level"]                    = "Nível de item",
    ["tt_spec"]                          = "Especialização",
    ["tt_loading"]                       = "...",

    -- =====================
    -- Bag Skin extras
    -- =====================
    ["opt_skin_bags_show_ilvl"]          = "Mostrar nível de item no equipamento",
    ["opt_skin_bags_show_junk_icon"]     = "Ícone de lixo",
    ["opt_skin_bags_layout_mode"]        = "Modo de layout",
    ["opt_skin_bags_layout_combined"]    = "Grade combinada",
    ["opt_skin_bags_layout_categories"]  = "Categorias",
    ["opt_skin_bags_layout_separate"]    = "Bolsas separadas",
    ["opt_skin_bags_reverse_order"]      = "Inverter ordem das bolsas",
    ["opt_skin_bags_show_bag_bar"]       = "Mostrar barra de bolsas",
    ["opt_skin_bags_settings"]           = "Configurações de bolsas",
    ["opt_skin_bags_slot_spacing_x"]     = "Espaçamento de slot X",
    ["opt_skin_bags_slot_spacing_y"]     = "Espaçamento de slot Y",
    ["opt_skin_bags_sort_none"]          = "Manual",

    -- =====================
    -- TOMOSCORE (Scoreboard)
    -- =====================
    ["ts_cfg_title"]                = "Placar",
    ["ts_cfg_enable"]               = "Ativar placar de dungeon",
    ["ts_cfg_auto_show_mplus"]      = "Mostrar automaticamente no M+",
    ["ts_cfg_scale"]                = "Escala",
    ["ts_cfg_alpha"]                = "Opacidade do fundo",
    ["ts_cfg_section_display"]      = "Exibição",
    ["ts_cfg_section_frame"]        = "Quadro",
    ["ts_cfg_section_actions"]      = "Ações",
    ["ts_cfg_preview"]              = "Pré-visualização",
    ["ts_cfg_last_run"]             = "Mostrar última partida",
    ["ts_cfg_reset_pos"]            = "Redefinir posição",
    ["ts_reset_msg"]                = "|cffffd100TomoModForever|r Placar: Posição redefinida.",
    ["ts_no_data"]                  = "|cffffd100TomoModForever|r Placar: Nenhum dado de dungeon disponível.",
    ["ts_mythic_zero"]              = "Mítico",
    ["ts_key_level"]                = "+%d",
    ["ts_completed"]                = "COMPLETO",
    ["ts_depleted"]                 = "ESGOTADO",
    ["ts_duration"]                 = "Duração",
    ["ts_col_player"]               = "Jogador",
    ["ts_col_rating"]               = "M+",
    ["ts_col_key_level"]            = "Chave",
    ["ts_col_key_name"]             = "Dungeon",
    ["ts_col_damage"]               = "Dano",
    ["ts_col_healing"]              = "Cura",
    ["ts_col_interrupts"]           = "Interrupções",
    ["ts_footer_total"]             = "Total",
    ["ts_footer_players"]           = "%d jogadores",

    -- =====================
    -- CASTBARS (módulo autônomo)
    -- =====================
    ["cat_castbars"]                     = "Barras de lançamento",

    ["cb_section_general"]               = "Geral",
    ["opt_cb_enable"]                    = "Ativar barras de lançamento autônomas",
    ["info_cb_description"]              = "Substitui as barras de lançamento da Blizzard por barras totalmente personalizáveis para Jogador, Alvo, Foco, Bichano e Chefe.",
    ["btn_cb_toggle_preview"]            = "Show / Hide Preview",
    ["info_cb_preview_hint"]             = "Unlocks every castbar and shows a live mock spell so you can see your tweaks instantly.",
    ["opt_cb_hide_blizzard"]             = "Ocultar barras de lançamento da Blizzard",
    ["opt_cb_class_color"]               = "Usar cor de classe",
    ["opt_cb_show_transitions"]          = "Animações de início/fim",
    ["opt_cb_show_channel_ticks"]        = "Mostrar marcas de canalização",
    ["opt_cb_timer_format"]              = "Formato do temporizador",
    ["cb_timer_remaining"]               = "Restante (1.5)",
    ["cb_timer_remaining_total"]         = "Restante / Total (1.5 / 3.0)",
    ["cb_timer_elapsed"]                 = "Decorrido (1.5)",
    ["opt_cb_spell_max_len"]             = "Comprimento máx. do nome (0 = ilimitado)",

    ["cb_section_appearance"]            = "Aparência",
    ["opt_cb_bar_texture"]               = "Textura da barra",
    ["cb_tex_blizzard"]                  = "Blizzard",
    ["cb_tex_smooth"]                    = "Suave",
    ["cb_tex_flat"]                      = "Plano",
    ["opt_cb_font_size"]                 = "Tamanho da fonte",
    ["opt_cb_bg_mode"]                   = "Modo de fundo",
    ["cb_bg_black"]                      = "Preto",
    ["cb_bg_transparent"]                = "Transparente",
    ["cb_bg_custom"]                     = "Textura personalizada",

    ["cb_section_colors"]                = "Cores",
    ["opt_cb_cast_color"]                = "Cor de lançamento",
    ["opt_cb_ni_color"]                  = "Não interrompível",
    ["opt_cb_interrupt_color"]           = "Cor de interrupção",

    ["cb_section_spark"]                 = "Faísca",
    ["opt_cb_show_spark"]                = "Mostrar animação de faísca",
    ["opt_cb_spark_style"]               = "Estilo de faísca",
    ["opt_cb_spark_color"]               = "Cor da faísca",
    ["opt_cb_spark_glow_color"]          = "Cor do brilho",
    ["opt_cb_spark_tail_color"]          = "Cor da cauda",
    ["opt_cb_spark_glow_alpha"]          = "Opacidade do brilho",
    ["opt_cb_spark_tail_alpha"]          = "Opacidade da cauda",

    ["cb_section_gcd"]                   = "Faísca GCD",
    ["opt_cb_show_gcd"]                  = "Mostrar barra GCD abaixo da barra do jogador",
    ["opt_cb_gcd_height"]                = "Altura da barra GCD",
    ["opt_cb_gcd_color"]                 = "Cor GCD",

    ["cb_section_interrupt"]             = "Feedback de interrupção",
    ["opt_cb_show_interrupt_feedback"]   = "Mostrar texto de interrupção",
    ["opt_cb_interrupt_fb_color"]        = "Cor do texto",
    ["opt_cb_interrupt_fb_size"]         = "Tamanho da fonte",
    ["cb_interrupt_feedback_text"]       = "INTERROMPIDO!",
    ["cb_interrupt_feedback_full"]       = "INTERROMPIDO: %s",
    ["cb_interrupted"]                   = "Interrompido",

    ["cb_tab_general"]                   = "Geral",
    ["cb_tab_player"]                    = "Jogador",
    ["cb_tab_target"]                    = "Alvo",
    ["cb_tab_focus"]                     = "Foco",
    ["cb_tab_pet"]                       = "Bichano",
    ["cb_tab_boss"]                      = "Chefe",

    ["cb_section_unit"]                  = "Barra de %s",
    ["opt_cb_unit_enable"]               = "Ativar",
    ["opt_cb_unit_width"]                = "Largura",
    ["opt_cb_unit_height"]               = "Altura",
    ["opt_cb_unit_show_icon"]            = "Mostrar ícone",
    ["opt_cb_unit_icon_side"]            = "Lado do ícone",
    ["cb_icon_left"]                     = "Esquerda",
    ["cb_icon_right"]                    = "Direita",
    ["opt_cb_unit_show_timer"]           = "Mostrar temporizador",
    ["opt_cb_unit_show_latency"]         = "Mostrar latência",
    ["info_cb_latency"]                  = "Exibe uma sobreposição escura mostrando a latência da rede no final da barra.",
    ["info_cb_position"]                 = "Use /tmf layout para desbloquear e arrastar esta barra.",
    ["btn_cb_reset_position"]            = "Redefinir posição",
    ["cb_move_label"]                    = "(Arraste para mover)",
    ["cb_player_missing_notice"]         = "A barra de conjuração do jogador não está ativada — ative-a nas configurações de Barras de Conjuração antes de poder movê-la.",
    ["cb_preview_castbar"]               = "Prévia: %s",

    ["mover_castbar_standalone"]         = "Barras de lançamento",

    -- ═══════════════════════════════════
    -- Quadros de grupo (Party Frames)
    -- ═══════════════════════════════════
    ["cat_partyframes"]                  = "Quadros de grupo",
    ["mover_partyframes"]                = "Quadros de grupo",

    ["pf_tab_general"]                   = "Geral",
    ["pf_tab_features"]                  = "Recursos",
    ["pf_tab_cooldowns"]                 = "Recarga",
    ["pf_tab_arena"]                     = "Arena",

    ["pf_section_general"]               = "Geral",
    ["pf_opt_enable"]                    = "Ativar quadros de grupo",
    ["pf_info_description"]              = "Quadros de grupo personalizados para M+ e Arena com saúde, absorção, previsão de cura, HoTs, CD de interrupção/rez de combate e destaque de dissipação.",
    ["pf_opt_hide_blizzard"]             = "Ocultar quadros de grupo da Blizzard",
    ["pf_opt_sort_role"]                 = "Ordenar por função (Tanque > Curador > DPS)",

    ["pf_section_dimensions"]            = "Dimensões",
    ["pf_opt_width"]                     = "Largura do quadro",
    ["pf_opt_height"]                    = "Altura do quadro",
    ["pf_opt_spacing"]                   = "Espaçamento",
    ["pf_opt_grow_direction"]            = "Direção de crescimento",
    ["pf_dir_down"]                      = "Baixo",
    ["pf_dir_up"]                        = "Cima",
    ["pf_dir_right"]                     = "Direita",
    ["pf_dir_left"]                      = "Esquerda",

    ["pf_section_display"]               = "Exibição",
    ["pf_opt_show_name"]                 = "Mostrar nome",
    ["pf_opt_show_health_text"]          = "Mostrar texto de saúde",
    ["pf_opt_health_format"]             = "Formato de saúde",
    ["pf_fmt_deficit"]                   = "Déficit",
    ["pf_opt_health_color"]              = "Modo de cor de saúde",
    ["pf_color_green"]                   = "Verde",
    ["pf_color_gradient"]                = "Gradiente",
    ["pf_opt_show_power"]                = "Mostrar barra de poder",
    ["pf_opt_power_height"]              = "Altura da barra de poder",
    ["pf_opt_show_role"]                 = "Mostrar ícone de função",
    ["pf_opt_role_size"]                 = "Tamanho do ícone de função",
    ["pf_opt_show_leader"]               = "Mostrar ícone de líder",
    ["pf_opt_leader_size"]               = "Tamanho do ícone de líder",
    ["pf_opt_show_marker"]               = "Mostrar marcador de raide",
    ["pf_opt_readycheck_size"]            = "Tamanho do ícone de verificação",
    ["pf_opt_summon_size"]               = "Tamanho do indicador de invocação",

    ["pf_section_font"]                  = "Fonte",
    ["pf_opt_font_size"]                 = "Tamanho da fonte",

    ["pf_section_position"]              = "Posição",
    ["pf_info_position"]                 = "Use /tmf layout para desbloquear e arrastar os quadros de grupo.",
    ["pf_btn_reset_position"]            = "Redefinir posição",

    ["pf_section_health_extras"]         = "Extras de saúde",
    ["pf_opt_show_absorb"]               = "Mostrar barra de absorção",
    ["pf_opt_absorb_color"]              = "Cor de absorção",
    ["pf_opt_show_heal_pred"]            = "Mostrar previsão de cura",

    ["pf_section_range"]                 = "Verificação de alcance",
    ["pf_opt_show_range"]                = "Esmaecer membros fora de alcance",
    ["pf_opt_oor_alpha"]                 = "Opacidade fora de alcance",

    ["pf_section_dispel"]                = "Alerta de tipo de penalidade",
    ["pf_opt_show_dispel"]               = "Ativar o alerta de penalidade",
    ["pf_opt_show_dispel_border"]        = "Colorir todo o quadro conforme a penalidade",
    ["pf_opt_show_dispel_icon"]          = "Mostrar o ícone da penalidade prioritária",
    ["pf_opt_show_dispel_bleed"]         = "Incluir sangramentos",
    ["pf_opt_dispel_size"]               = "Tamanho do ícone de penalidade",
    ["pf_opt_dispel_border_size"]        = "Espessura da borda de alerta",
    ["pf_info_dispel"]                   = "Usa o motor de auras do Midnight 12.1 para mostrar Magia (azul), Maldição (roxo), Doença (laranja), Veneno (verde) e Sangramento (vermelho) sem ler dados de aura protegidos em combate. O ícone é a penalidade real e a borda nunca altera o preenchimento da barra de vida.",

    ["pf_section_hots"]                  = "Rastreamento de HoTs",
    ["pf_opt_show_hots"]                 = "Mostrar indicadores HoT",
    ["pf_opt_hot_size"]                  = "Tamanho do ícone HoT",
    ["pf_opt_max_hots"]                  = "Máx. HoTs mostrados",
    ["pf_opt_hot_duration"]              = "Mostrar os segundos restantes nos HoTs",
    ["pf_info_hots"]                     = "Exibe efeitos de cura ao longo do tempo com bordas coloridas por classe. Suporta Sacerdote, Druida, Paladino, Xamã, Monge e Evocador.",
    ["pf_section_defensives"]            = "Recargas defensivas",
    ["pf_opt_show_defensives"]           = "Exibir recargas defensivas",
    ["pf_opt_defensive_size"]            = "Tamanho dos ícones defensivos",
    ["pf_opt_max_defensives"]            = "Máx. de defensivas exibidas",
    ["pf_opt_def_externals"]             = "Recargas externas (conjuradas neste jogador)",
    ["pf_opt_def_raidwide"]              = "Recargas de raide",
    ["pf_opt_def_personals"]             = "Recargas pessoais",
    ["pf_info_defensives"]               = "A cor da borda indica a categoria: dourado para as externas (Casca de Ferro, Casulo Vital, Supressão da Dor), ciano para as de raide, vermelho para as pessoais. As de raide e pessoais vêm desativadas porque acendem em todos os quadros ao mesmo tempo.",

    ["pf_section_cooldowns"]             = "Rastreador de recarga",
    ["pf_opt_show_kick"]                 = "Mostrar CD de interrupção",
    ["pf_opt_show_brez"]                 = "Mostrar CD de rez de combate",
    ["pf_opt_cd_size"]                   = "Tamanho do ícone CD",
    ["pf_opt_cd_layout"]                 = "Layout de ícones CD",
    ["pf_cd_vertical"]                   = "Vertical (no quadro)",
    ["pf_cd_horizontal"]                 = "Horizontal (abaixo)",
    ["pf_info_cooldowns"]                = "As interrupções são detectadas via UNIT_SPELLCAST_SUCCEEDED. O rez de combate lê o pool de cargas compartilhado, então o ícone fica cinza para todos quando um rez é usado na instância.",

    -- Indicador de ressurreição (grupo)
    ["pf_section_resurrect"]             = "Indicador de ressurreição",
    ["pf_opt_show_resurrect"]            = "Mostrar ícone de ressurreição chegando",
    ["pf_opt_resurrect_size"]            = "Tamanho do ícone de ressurreição",
    ["pf_info_resurrect"]                = "Exibe um ícone de rez em um membro enquanto uma ressurreição está sendo lançada nele.",

    ["pf_section_arena"]                 = "Quadros inimigos de arena",
    ["pf_opt_arena_enable"]              = "Ativar quadros de arena",
    ["pf_info_arena"]                    = "Exibe saúde, poder e CD de bijuteria PvP da equipe inimiga na Arena (2v2/3v3).",
    ["pf_section_arena_dims"]            = "Dimensões de arena",
    ["pf_opt_arena_width"]               = "Largura",
    ["pf_opt_arena_height"]              = "Altura",
    ["pf_opt_arena_spacing"]             = "Espaçamento",
    ["pf_section_arena_trinket"]         = "Bijuteria PvP",
    ["pf_opt_show_trinket"]              = "Mostrar CD de bijuteria",
    ["pf_opt_trinket_size"]              = "Tamanho do ícone de bijuteria",
    ["pf_opt_show_spec"]                 = "Mostrar ícone de especialização",
    ["pf_section_arena_pos"]             = "Posição de arena",
    ["pf_info_arena_pos"]                = "Use /tmf layout para desbloquear e arrastar os quadros de arena.",
    ["pf_btn_reset_arena_pos"]           = "Redefinir posição",

    -- ═══════════════════════════════════
    -- Raid Frames
    -- ═══════════════════════════════════
    ["cat_raidframes"]                   = "Quadros de raide",
    ["mover_raidframes"]                 = "Quadros de raide",
    ["rf_tab_general"]                   = "Geral",
    ["rf_tab_features"]                  = "Recursos",
    ["rf_section_general"]               = "Geral",
    ["rf_opt_enable"]                    = "Ativar quadros de raide",
    ["rf_info_description"]              = "Quadros de raide personalizados com vida, absorção, previsão de cura, HoTs, debuffs, destaque de dissipação, CDs defensivos e verificação de alcance.",
    ["rf_opt_hide_blizzard"]             = "Ocultar quadros de raide da Blizzard",
    ["rf_opt_skin_group_manager"]       = "Personalizar o painel do líder de grupo (ready check, marcadores, sair do grupo)",
    ["rf_opt_sort_role"]                 = "Ordenar por função (Tanque > Curandeiro > DPS)",
    ["rf_section_layout"]                = "Layout",
    ["rf_opt_layout_mode"]               = "Modo de layout",
    ["rf_layout_grid"]                   = "Grade (grupos em colunas)",
    ["rf_layout_list"]                   = "Lista (coluna única)",
    ["rf_opt_width"]                     = "Largura do quadro",
    ["rf_opt_height"]                    = "Altura do quadro",
    ["rf_opt_spacing"]                   = "Espaçamento",
    ["rf_opt_group_spacing"]             = "Espaçamento de grupo",
    ["rf_section_display"]               = "Exibição",
    ["rf_opt_show_name"]                 = "Mostrar nome",
    ["rf_opt_name_max_length"]           = "Letras máx. do nome",
    ["rf_opt_show_health_text"]          = "Mostrar texto de vida",
    ["rf_opt_health_format"]             = "Formato de vida",
    ["rf_opt_health_color"]              = "Modo de cor da vida",
    ["rf_opt_show_role"]                 = "Mostrar ícone de função",
    ["rf_opt_show_marker"]               = "Mostrar marcador de raide",
    ["rf_opt_readycheck_size"]            = "Tamanho do ícone de verificação",
    ["rf_opt_summon_size"]               = "Tamanho do indicador de invocação",
    ["rf_section_font"]                  = "Fonte",
    ["rf_opt_font_size"]                 = "Tamanho da fonte",
    ["rf_section_position"]              = "Posição",
    ["rf_info_position"]                 = "Use /tmf layout para desbloquear e arrastar os quadros de raide.",
    ["rf_btn_reset_position"]            = "Redefinir posição",
    ["rf_info_test_raid"]                = "Simule uma raide de 20 jogadores para pré-visualizar o layout fora de combate.",
    ["rf_btn_test_raid"]                 = "Simular 20 jogadores",
    ["rf_btn_test_raid_stop"]            = "Parar simulação",
    ["rf_preview_group"]                 = "G",
    ["rf_mode_raid"]                     = "Raid",
    ["rf_mode_solo"]                     = "Solo",
    ["rf_section_health_extras"]         = "Recursos de vida",
    ["rf_opt_show_power"]                = "Barra de poder (apenas curandeiros)",
    ["rf_opt_power_height"]              = "Altura da barra de poder",
    ["rf_opt_show_absorb"]               = "Mostrar barra de absorção",
    ["rf_opt_show_heal_pred"]            = "Mostrar previsão de cura",
    ["rf_section_range"]                 = "Verificação de alcance",
    ["rf_opt_show_range"]                = "Esmaecer membros fora de alcance",
    ["rf_opt_oor_alpha"]                 = "Opacidade fora de alcance",
    ["rf_section_dispel"]                = "Alerta de tipo de penalidade",
    ["rf_opt_show_dispel"]               = "Ativar o alerta de penalidade",
    ["rf_opt_show_dispel_border"]        = "Colorir todo o quadro conforme a penalidade",
    ["rf_opt_show_dispel_icon"]          = "Mostrar o ícone da penalidade prioritária",
    ["rf_opt_show_dispel_bleed"]         = "Incluir sangramentos",
    ["rf_opt_dispel_size"]               = "Tamanho do ícone de penalidade",
    ["rf_opt_dispel_border_size"]        = "Espessura da borda de alerta",
    ["rf_info_dispel"]                   = "Magia = azul, Maldição = roxo, Doença = laranja, Veneno = verde, Sangramento = vermelho. Usa os AuraSlots do motor, então o alerta continua seguro em combate quando os dados de aura estão protegidos.",
    ["rf_section_hots"]                  = "Rastreamento de HoTs",
    ["rf_opt_show_hots"]                 = "Mostrar indicadores HoT",
    ["rf_opt_hot_size"]                  = "Tamanho do ícone HoT",
    ["rf_opt_max_hots"]                  = "Máx. HoTs mostrados",
    ["rf_opt_hot_duration"]              = "Mostrar os segundos restantes nos HoTs",
    ["rf_section_debuffs"]               = "Rastreamento de debuffs",
    ["rf_opt_show_debuffs"]              = "Mostrar ícones de debuff",
    ["rf_opt_debuff_size"]               = "Tamanho do ícone de debuff",
    ["rf_opt_max_debuffs"]               = "Máx. debuffs mostrados",
    ["rf_section_defensives"]            = "CDs defensivos",
    ["rf_opt_show_defensives"]           = "Mostrar buffs defensivos ativos",
    ["rf_opt_defensive_size"]            = "Tamanho do ícone defensivo",
    ["rf_opt_max_defensives"]            = "Máx. de defensivas exibidas",
    ["rf_opt_def_externals"]             = "Recargas externas (conjuradas neste jogador)",
    ["rf_opt_def_raidwide"]              = "Recargas de raide",
    ["rf_opt_def_personals"]             = "Recargas pessoais",
    ["rf_info_defensives"]               = "Exibe CDs defensivos ativos (ex: Supressão de Dor, Casca de Ferro, Escudo Divino) em cada membro da raide.",

    -- Indicador de ressurreição (raide)
    ["rf_section_resurrect"]             = "Indicador de ressurreição",
    ["rf_opt_show_resurrect"]            = "Mostrar ícone de ressurreição chegando",
    ["rf_opt_resurrect_size"]            = "Tamanho do ícone de ressurreição",
    ["rf_info_resurrect"]                = "Exibe um ícone de rez em um membro enquanto uma ressurreição está sendo lançada nele (rez de combate ou normal).",

    -- Contador de rez de combate
    ["rf_section_battlerez"]             = "Contador de rez de combate",
    ["rf_opt_br_enable"]                 = "Exibir contador de rez de combate",
    ["rf_opt_br_only_instance"]          = "Apenas em masmorras/raide",
    ["rf_opt_br_size"]                   = "Tamanho do contador",
    ["rf_opt_br_font"]                   = "Tamanho da fonte do contador",
    ["rf_info_battlerez"]                = "Um contador movível mostrando quantas rez de combate estão disponíveis e o tempo até a próxima carga. Lê o pool compartilhado, funciona em qualquer classe. Use /tmf layout para mover.",

    -- Layout por tamanho
    ["rf_section_size_overrides"]        = "Layout por tamanho (10/25/40)",
    ["rf_opt_overrides_enable"]          = "Ativar layouts por tamanho",
    ["rf_info_size_overrides"]           = "Quando ativado, o tamanho do quadro se adapta automaticamente ao tamanho do grupo (espaçamento ajustado por faixa).",
    ["rf_ov_small"]                      = "Pequeno  (até 10)",
    ["rf_ov_medium"]                     = "Médio  (até 25)",
    ["rf_ov_large"]                      = "Grande  (26-40)",
    ["rf_ov_width"]                      = "Largura",
    ["rf_ov_height"]                     = "Altura",

    -- ═══════════════════════════════════
    -- Aura Tracker
    -- ═══════════════════════════════════
    ["mover_battlerez"]                  = "Rez de combate",
    ["mover_preytracker"]                = "Rastreador de Presa",
    ["mover_extrabuttons"]               = "Botão Extra",

    ["at_section_general"]               = "Geral",
    ["at_opt_enable"]                    = "Ativar rastreador de auras",
    ["at_info_description"]              = "Rastreia buffs importantes: procs de bijuteria, procs de encantamento, buffs pessoais e defensivos em um overlay de ícones.",

    ["at_section_appearance"]            = "Aparência",
    ["at_opt_icon_size"]                 = "Tamanho do ícone",
    ["at_opt_spacing"]                   = "Espaçamento",
    ["at_opt_max_icons"]                 = "Máx. ícones",
    ["at_opt_grow_direction"]            = "Direção de crescimento",
    ["at_opt_font_size"]                 = "Tamanho da fonte",

    ["at_section_display"]               = "Exibição",
    ["at_opt_show_timer"]                = "Mostrar temporizador",
    ["at_opt_show_stacks"]               = "Mostrar acumulações",
    ["at_opt_show_glow"]                 = "Brilho em novo proc",
    ["at_opt_timer_threshold"]           = "Limiar de piscamento (seg)",

    ["at_section_categories"]            = "Categorias",
    ["at_info_categories"]               = "Escolha quais categorias de auras rastrear.",
    ["at_cat_trinkets"]                  = "Procs de bijuteria",
    ["at_cat_enchants"]                  = "Procs de encantamento de arma",
    ["at_cat_selfbuffs"]                 = "Buffs pessoais (CDs)",
    ["at_cat_raidbuffs"]                 = "Buffs de raide",
    ["at_cat_defensives"]                = "Defensivos (externos + pessoais)",

    ["at_section_position"]              = "Posição",
    ["at_info_position"]                 = "Use /tmf layout para desbloquear e arrastar o rastreador.",
    ["at_btn_reset_position"]            = "Redefinir posição",

    -- ═══════════════════════════════════
    -- Battle Text
    -- ═══════════════════════════════════
    ["cat_battletext"]                   = "Texto de combate",
    ["mover_battletext"]                 = "Texto de combate",

    ["bt_section_general"]               = "Geral",
    ["bt_info_description"]              = "Texto de combate rolante: dano e cura, recebido e causado.",
    ["bt_opt_enable"]                    = "Ativar texto de combate",

    ["bt_section_display"]               = "Exibição",
    ["bt_opt_outgoing"]                  = "Mostrar dano causado",
    ["bt_opt_incoming"]                  = "Mostrar dano recebido",
    ["bt_opt_overheal"]                  = "Mostrar sobrecura",
    ["bt_opt_throttle"]                  = "Agrupar ticks DoT/HoT",

    ["bt_section_appearance"]            = "Aparência",
    ["bt_opt_font_size"]                 = "Tamanho da fonte",
    ["bt_opt_throttle_window"]           = "Janela de agrupamento (seg)",

    ["bt_section_position"]              = "Posição",
    ["bt_info_position"]                 = "Use /tmf layout para desbloquear e arrastar as zonas.",
    ["bt_btn_reset_position"]            = "Redefinir posições",

    ["bt_zone_outgoing"]                 = "Causado",
    ["bt_zone_incoming"]                 = "Recebido",
    ["bt_zone_heal_out"]                 = "Cura causada",
    ["bt_zone_heal_in"]                  = "Cura recebida",

    ["bt_cmd_help"]                      = "/tmf bt <cmd>",
    ["bt_enabled"]                       = "ativado",
    ["bt_disabled"]                      = "desativado",
    ["bt_crit"]                          = "!",
    ["bt_zones_locked"]                  = "zonas bloqueadas",
    ["bt_zones_unlocked"]                = "zonas desbloqueadas",
    ["bt_reset_done"]                    = "posições redefinidas.",
    ["bt_miss_miss"]                     = "Errou",
    ["bt_miss_dodge"]                    = "Esquivou",
    ["bt_miss_parry"]                    = "Aparou",
    ["bt_miss_block"]                    = "Bloqueou",
    ["bt_miss_resist"]                   = "Resistiu",
    ["bt_miss_absorb"]                   = "Absorveu",
    ["bt_miss_immune"]                   = "Imune",
    ["bt_miss_evade"]                    = "Evasão",
    ["bt_miss_deflect"]                  = "Desviou",
    ["bt_miss_reflect"]                  = "Refletiu",

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
    ["section_diagnostics"]              = "Diagn\195\179sticos",
    ["opt_diag_enabled"]                 = "Ativar captura de erros",
    ["opt_diag_capture_all"]             = "Capturar todos os addons",
    ["opt_diag_suppress_popups"]         = "Suprimir janelas de erro",
    ["opt_diag_auto_open"]               = "Abrir automaticamente com erro do TomoMod",
    ["btn_diag_open_console"]            = "Abrir console",
    ["btn_diag_clear"]                   = "Limpar erros",
    ["btn_diag_export"]                  = "Copiar relat\195\179rio",
    ["btn_diag_export_tracker"]          = "Exportar para Tracker",
    ["info_diag_desc"]                   = "Captura erros Lua em segundo plano sem popups durante o combate. /tmdiag para abrir o console.",
    ["info_diag_session"]                = "Sess\195\163o: #%d \226\128\148 %d erros capturados (%d TomoMod)",
    ["info_diag_capture_all_desc"]       = "Quando desativado, apenas erros do TomoMod s\195\163o capturados. Ative para capturar todos os erros de addons.",

    -- =====================
    -- HOUSING
    -- =====================
    ["section_housing_general"]      = "Housing \226\128\148 Geral",
    ["section_housing_hover"]        = "Info decora\195\167\195\163o (hover)",
    ["section_housing_clock"]        = "Rel\195\179gio do editor",
    ["section_housing_teleport"]     = "Teleporte",
    ["section_housing_commands"]     = "Comandos",

    ["info_housing_desc"]            = "M\195\179dulo Housing: melhora o editor de casas e adiciona atalhos de teleporte. Requer Midnight / The War Within.",
    ["info_housing_hover"]           = "No modo 'Decora\195\167\195\163o base', exibe nome, custo de posicionamento e estoque restante. Tamb\195\169m permite duplicar com tecla modificadora.",
    ["info_housing_clock"]           = "Exibe um rel\195\179gio e registra o tempo no editor de casas. Clique direito para alternar entre anal\195\179gico e digital.",
    ["info_housing_teleport"]        = "Ativa /tmf home: teleporta voc\195\170 para sua casa ou sai automaticamente se estiver visitando.",
    ["info_housing_commands"]        = "\226\128\162 /tmf home \226\128\148 teleportar para sua casa (ou sair)\n\226\128\162 /tmf housing \226\128\148 abrir este painel\n\226\128\162 Clique direito no rel\195\179gio \226\128\148 alternar anal\195\179gico/digital",

    ["opt_housing_enable"]           = "Ativar m\195\179dulo Housing",
    ["opt_housing_decorhover"]       = "Ativar info de decora\195\167\195\163o",
    ["opt_housing_dupe"]             = "Ativar duplica\195\167\195\163o r\195\161pida (modificador)",
    ["opt_housing_dupekey"]          = "Tecla de duplica\195\167\195\163o",
    ["opt_housing_clock"]            = "Ativar rel\195\179gio",
    ["opt_housing_clock_analog"]     = "Modo anal\195\179gico (sen\195\163o, digital)",
    ["opt_housing_teleport"]         = "Ativar teleporte /tmf home",

    ["btn_housing_tp_home"]          = "Teleportar (teste)",
    ["btn_housing_refresh"]          = "Atualizar casas",

    ["housing_duplicate"]            = "Duplicar",
    ["housing_alliance_zone"]        = "Promontório do Fundador",
    ["housing_horde_zone"]           = "Costa do Vento Lâmina",
    ["housing_clock_title"]          = "TomoMod \226\128\148 Rel\195\179gio",
    ["housing_clock_time"]           = "Hora",
    ["housing_clock_local"]          = "Hora local:",
    ["housing_clock_realm"]          = "Hora do reino:",
    ["housing_clock_time_spent"]     = "Tempo no editor",
    ["housing_clock_session"]        = "Esta sess\195\163o:",
    ["housing_clock_total"]          = "Total:",
    ["housing_clock_rightclick"]     = "Clique direito para alternar anal\195\179gico / digital",

    ["msg_help_home"]                = "Teleportar para sua casa (ou sair)",
    ["msg_help_housing"]             = "Abrir o painel Housing",
    ["msg_housing_refresh"]          = "Informa\195\167\195\181es de casas solicitadas.",
    ["msg_housing_unavailable"]      = "M\195\179dulo Housing n\195\163o dispon\195\173vel neste cliente.",

    -- ═══════════════════════════════════
    -- Merchant Tools (2.9.9)
    -- ═══════════════════════════════════

    ["tab_qol_merchant_tools"]           = "Ferramentas de vendedor",

    ["section_already_known"]            = "Já conhecido",
    ["info_already_known"]               = "Dessatura ou tinge itens do vendedor/recompra que você já possui (montarias, mascotes, brinquedos, conjuntos de transmog, receitas).",
    ["opt_ak_enable"]                    = "Ativar Já conhecido",
    ["opt_ak_mode"]                      = "Modo de exibição",
    ["ak_mode_mono"]                     = "Monocromático (cinza)",
    ["ak_mode_color"]                    = "Tonalidade de cor",
    ["opt_ak_color"]                     = "Cor da tonalidade",

    ["section_extend_pages"]             = "Páginas de vendedor estendidas",
    ["info_extend_pages"]                = "Adiciona colunas extras à janela do vendedor.\nRequer recarregamento da interface após ativar ou alterar o número de colunas.",
    ["opt_ep_enable"]                    = "Ativar páginas estendidas",
    ["opt_ep_columns"]                   = "Número de colunas",

    ["preset_complet_name"]  = "Recomendado",
    ["preset_complet_tag"]   = "A experiência TomoMod completa",
    ["preset_complet_desc"]  = "Ativa todos os módulos principais com padrões sensatos: UnitFrames, quadros de grupo e raide, Nameplates, barras de lançamento, recursos, skin das barras de ação, todos os skins visuais, ferramentas Mythic+ e os recursos de conforto mais úteis. O melhor ponto de partida para a maioria dos jogadores.",
    ["preset_tank_name"]     = "Tank",
    ["preset_tank_tag"]      = "Foco em ameaça, Nameplates mais largas",
    ["preset_tank_desc"]     = "A configuração Recomendada, ajustada para tankar: Nameplates coloridas por ameaça (Modo Tank) e um pouco mais largas para ler melhor a aggro, além do indicador de ameaça no alvo.",
    ["preset_healer_name"]   = "Curandeiro",
    ["preset_healer_tag"]    = "Quadros de raide maiores, mana visível",
    ["preset_healer_desc"]   = "A configuração Recomendada, ajustada para curar: quadros de raide e grupo maiores e mais fáceis de clicar, com barras de recurso (mana) exibidas, rastreamento de HoTs, destaque de dissipação e defensivos em evidência.",
    ["preset_dps_name"]      = "DPS",
    ["preset_dps_tag"]       = "Recursos e cooldowns em destaque",
    ["preset_dps_desc"]      = "A configuração Recomendada, ajustada para dano: uma barra de recursos mais visível, rastreamento de buffs no alvo para defensivos inimigos e Nameplates limpas sem coloração de ameaça de tank.",
    ["preset_minimal_name"]  = "Mínimo",
    ["preset_minimal_tag"]   = "Apenas o essencial",
    ["preset_minimal_desc"]  = "Uma pegada leve: mantém UnitFrames, quadros de grupo e raide, barras de lançamento, barras de recursos, o minimapa e as automações essenciais — tudo cosmético (skins, chat, bolsas, Nameplates, painéis extras) fica desativado. O mais próximo de uma sensação vanilla.",
    ["preset_custom_name"]   = "Personalizado",
    ["preset_custom_tag"]    = "Configure tudo você mesmo",
    ["preset_custom_desc"]   = "Pule os presets e percorra cada categoria passo a passo para ativar exatamente o que quiser. Você sempre pode mudar qualquer coisa depois pelo /tmf.",
    ["preset_applied"]       = "Preset aplicado: %s — digite /reload para ver o resultado.",
    ["preset_unknown"]       = "Preset desconhecido « %s ». Disponíveis: complet, tank, healer, dps, minimal.",
    ["preset_usage"]         = "Uso: /tmpreset <complet|tank|healer|dps|minimal>",
    ["ins_v3_welcome_desc"]      = "Bem-vindo! Este assistente rápido deixa você com uma interface limpa e completa em segundos.\n\nEscolha uma configuração que combine com seu jeito de jogar — você poderá ajustar tudo depois pelo |cffffd100/tmf|r. Prefere escolher cada opção você mesmo? Escolha |cffc89530Personalizado|r.",
    ["ins_pick_title"]           = "Escolha sua configuração",
    ["ins_pick_subtitle"]        = "Selecione um estilo de jogo abaixo. Tudo continua ajustável depois via /tmf.",
    ["ins_pick_recommended"]     = "Recomendado",
    ["ins_custom_frames_title"]  = "Quadros",
    ["ins_custom_barsskins_title"] = "Barras e Skins",
    ["ins_custom_mythicqol_title"] = "Mythic+ e Conforto",
    ["ins_custom_frames_intro"]  = "Ative os quadros que quiser. As opções sensatas vêm pré-selecionadas.",
    ["ins_custom_barsskins_intro"] = "Skin das barras de ação e skins visuais de chat, bolsas, tooltips e mais.",
    ["ins_custom_mythicqol_intro"] = "Ferramentas Mythic+, extras de interface, automações e som.",
    ["ins_recap_title"]          = "Tudo pronto",
    ["ins_recap_preset"]         = "Configuração aplicada: |cffffd100%s|r",
    ["ins_recap_custom"]         = "Sua configuração personalizada está pronta",
    ["ins_recap_desc"]           = "Recarregue sua interface para aplicar tudo. Você pode reabrir este assistente a qualquer momento com |cffffd100/tmf install|r e abrir o painel de configuração completo com |cffffd100/tmf|r.",
    ["cat_accueil"]              = "Início",
    ["ui_search_placeholder"]    = "Buscar configuração...",
    ["dash_welcome"]             = "Visão rápida do TomoMod. Alterne módulos, aplique uma configuração, troque de perfil ou relance o assistente.",
    ["dash_modules_section"]     = "Módulos",
    ["dash_quickcfg_section"]    = "Configuração rápida",
    ["dash_studio_section"]           = "Cooldown Studio",
    ["dash_studio_info"]              = "Editor em tela cheia das barras de recarga: disposi\195\167\195\163o, estilo, magias e visibilidade.",
    ["dash_studio_open"]              = "Abrir o Cooldown Studio",
    ["dash_profile_section"]     = "Perfil",
    ["dash_maint_section"]       = "Manutenção",
    ["dash_reload_hint"]         = "As alterações dos módulos são aplicadas em tempo real. Alterações protegidas são aplicadas automaticamente ao fim do combate.",
    ["dash_reload_now"]          = "Recarregar agora",
    ["dash_apply_preset"]        = "Preset de configuração",
    ["dash_apply_preset_btn"]    = "Aplicar este preset",
    ["dash_apply_preset_info"]   = "Aplicar um preset redefine quais módulos estão ligados ou não e depois recarrega.",
    ["dash_active_profile"]      = "Perfil ativo",
    ["dash_manage_profiles"]     = "Gerenciar perfis",
    ["dash_profile_info"]        = "Trocar de perfil recarrega a interface para aplicá-lo.",
    ["dash_relaunch_info"]       = "Reabre o assistente de configuração « presets primeiro ».",
    ["dash_mod_resources"]       = "Recursos",
    ["dash_mod_cdm"]             = "Cooldown Manager",
    ["dash_mod_abskin"]          = "Skin das barras de ação",
    ["dash_mod_chatskin"]        = "Skin do chat",
    ["dash_mod_bagskin"]         = "Skin das bolsas",
    ["dash_mod_mtracker"]        = "Rastreador Mythic+",
    ["dash_mod_score"]           = "Pontuação Mythic+",
    ["dash_reload_popup"]        = "Recarregar a interface agora para aplicar suas mudanças?",

    -- ═══════════════════════════════════
    -- MythicTracker Nomes EJ (2.9.10)
    -- ═══════════════════════════════════
    -- ═══════════════════════════════════
    -- Correção CD PartyFrame + Desempenho (2.9.12)
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
    -- Correções CooldownManager / ProcGlow / BuffSkin (2.9.11)
    -- ═══════════════════════════════════

    -- ═══════════════════════════════════
    -- MythicTracker Nomes EJ (2.9.10)
    -- ═══════════════════════════════════

    -- Player Auras Mover (v2.9.5)
    ["mover_player_auras"]       = "Auras do jogador",
    ["opt_auras_spacing"]        = "Espaçamento entre ícones",
    ["btn_reset_aura_position"]  = "Redefinir posição das auras",

    -- Module Reload Safety (v2.9.21)
    ["msg_module_reload"]        = "Esta alteração requer recarregar a interface.\nRecarregar agora?",
    ["info_module_reload"]       = "Requer /reload para ter efeito.",

    -- Waypoint Arrow Reversed (v2.9.22)

    -- 3.0.3
    -- 3.0.4

    -- 3.0.3

    -- 3.0.0

    -- 3.0.5

    -- =====================
    -- Extra Action Button (v3.0.6)
    -- =====================
    ["mover_ab_extra"] = "Ação extra",
    ["mover_ab_pet"] = "Barra do familiar",
    ["mover_ab_stance"] = "Barra de posturas",
    ["section_extra_button"] = "Botão de ação extra",
    ["opt_extra_enabled"] = "Gerenciar o botão de ação extra (recarregar para liberar)",
    ["opt_extra_scale"] = "Escala do botão extra",
    ["btn_extra_reset_pos"] = "Redefinir posição",
    ["info_extra_button"] = "Posicione o botão de ação extra no Modo de Layout. Ele aparece durante missões e encontros. Ao desativar, ele volta para a Blizzard após um /reload.",
    -- 3.0.7

    -- 3.1.1
    ["art_searching"]        = "Pesquisando: %s",
    ["art_searching_qty"]    = "Pesquisando: %s × %d",

    -- 3.1.2

    -- 3.1.3

    -- Ancoragem do tooltip
    ["opt_tooltip_anchor"]        = "Posição do tooltip",
    ["tooltip_anchor_default"]    = "Padrão",
    ["tooltip_anchor_cursor"]     = "Cursor",
    ["tooltip_anchor_corner"]     = "Canto da tela",
    ["tooltip_anchor_custom"]     = "Personalizado",
    ["opt_tooltip_anchor_corner"] = "Canto (modo Canto)",
    ["corner_br"]                 = "Inferior direito",
    ["corner_bl"]                 = "Inferior esquerdo",
    ["corner_tr"]                 = "Superior direito",
    ["corner_tl"]                 = "Superior esquerdo",
    ["info_tooltip_anchor"]       = "Personalizado: selecione este modo e arraste o quadro teal para a posição desejada.",
    ["btn_tooltip_toggle_anchor"] = "Mostrar/Ocultar a âncora",
    ["mover_tooltip_anchor"]      = "Âncora da dica de ferramenta",

    -- Nameplates preview
    ["np_preview_title"]   = "Pré-visualização de placas",
    ["np_preview_hint"]    = "Legibilidade rápida: cor, conjuro, auras e ameaça em um só lugar.",
    ["preview_np_friendly"] = "Aliado",
    ["preview_np_target"]  = "Alvo hostil",
    ["preview_np_boss"]    = "Chefe marcado",

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
    ["cat_units"]             = "Unidades",
    ["cat_combat"]            = "Combate",
    ["cat_comfort"]           = "Conforto",
    ["cat_tools"]             = "Ferramentas",
    ["cat_accueil_desc"]      = "Visão geral, predefinições e ações rápidas.",
    ["cat_interface_desc"]    = "Aparência global, barras, sons e janelas da Blizzard.",
    ["cat_units_desc"]        = "Jogador, nameplates, grupo e raide em um só lugar.",
    ["cat_combat_desc"]       = "Lançamentos, recursos, cooldowns e Mythic+.",
    ["cat_comfort_desc"]      = "Automações, missões, AFK, housing e conforto.",
    ["cat_changelog"]                 = "Novidades",
    ["cat_changelog_desc"]            = "Todas as notas de vers\195\163o, da mais recente \195\160 mais antiga.",
    ["cl_title"]                      = "Notas de vers\195\163o",
    ["cl_intro"]                      = "%d vers\195\181es. Clique em um n\195\186mero para ler suas notas.",
    ["cl_unavailable"]                = "N\195\163o foi poss\195\173vel carregar as notas de vers\195\163o.",
    ["cat_tools_desc"]        = "Perfis, backups, diagnósticos e manutenção.",
    ["cat_profiles_desc"]     = "Perfis, especializações, importar / exportar e redefinições.",
    ["cat_diagnostics_desc"]  = "Estado ao vivo, erros de Lua e medidas de desempenho.",
    ["cat_damagemeter"]                 = "Medidor de dano",
    ["cat_damagemeter_desc"]            = "Medidor de dano, resumo de morte e resumo de masmorra.",
    ["dm_cfg_title"]                    = "Medidor de dano",
    ["dm_cfg_intro"]                    = "O medidor mant\195\169m por enquanto sua pr\195\179pria janela de ajustes. Ela ser\195\161 integrada aqui em breve.",
    ["dm_cfg_open"]                     = "Abrir os ajustes do medidor",
    ["dm_cfg_toggle"]                   = "Mostrar / ocultar as janelas",
    ["dm_cfg_standalone"]               = "O addon TomoDamageMeter independente est\195\161 instalado e gerencia o medidor. O m\195\179dulo integrado permanece inativo.",
    ["dm_cfg_unavailable"]              = "O medidor de dano da Blizzard n\195\163o est\195\161 dispon\195\173vel neste cliente, o m\195\179dulo est\195\161 inativo.",
    ["cfg_tab_general"]       = "Geral",
    ["cfg_tab_actionbars"]    = "Barras de ação",
    ["cfg_tab_skins"]         = "Skins",
    ["cfg_tab_sound"]         = "Som",
    ["cfg_tab_unitframes"]    = "UnitFrames",
    ["cfg_tab_nameplates"]    = "Nameplates",
    ["cfg_tab_partyframes"]   = "Grupo",
    ["cfg_tab_raidframes"]    = "Raid",
    ["cfg_tab_castbars"]      = "Barras de lançamento",
    ["cfg_tab_resources"]     = "CD e Recursos",
    ["cfg_tab_mythicplus"]    = "Mythic+",
    ["cfg_tab_qol"]           = "Qualidade de vida",
    ["cfg_tab_housing"]       = "Housing",
    ["cfg_tab_profiles"]      = "Perfis",
    ["cfg_tab_diagnostics"]   = "Diagnósticos",
    ["cfg_reload_text"]       = "Recarregar a interface para aplicar esta alteração?",
    ["cfg_reload_confirm"]    = "Recarregar",
    ["cfg_reload_later"]      = "Mais tarde",
    ["cfg_footer_perf"]       = "FPS: %d  |  Mem.: %s",
    -- =====================
    -- CONFIG: CD/Resource & Profiles panels [Lot D2]
    -- =====================
    ["section_cdm_alpha"]             = "Opacidade",
    ["opt_rb_primary_centered"]       = "Mostrar recurso principal no centro da tela",
    ["info_rb_primary_centered"]      = "Move a barra de mana/energia/fúria do quadro do jogador para o centro da tela.",
    ["opt_rb_primary_power_height"]   = "Altura da barra principal",
    ["import_preview_analyzing"]      = "Analisando...",
    ["profiles_export_failed"]        = "Falha ao exportar",
    ["profiles_import_failed"]        = "Falha ao importar",
    ["profiles_error"]                = "Erro",
    ["profiles_rename_failed"]        = "Falha ao renomear",
    -- =====================
    -- CONFIG: General panel — minimap & buttonbag [Lot D3]
    -- =====================
    ["section_minimap_indicators"]    = "Indicadores do minimapa",
    ["info_minimap_indicators"]       = "Escolha um indicador e defina seu canto, tamanho e deslocamento. Aplicado instantaneamente.",
    ["opt_indicator"]                 = "Indicador",
    ["opt_corner"]                    = "Canto",
    ["opt_offset_x"]                  = "Deslocamento X",
    ["opt_offset_y"]                  = "Deslocamento Y",
    ["corner_topleft"]                = "Superior esquerdo",
    ["corner_topright"]               = "Superior direito",
    ["corner_bottomleft"]             = "Inferior esquerdo",
    ["corner_bottomright"]            = "Inferior direito",
    ["opt_minimap_tracking"]          = "Botão de rastreamento",
    ["opt_tracking_style"]            = "Estilo do botão de rastreamento",
    ["opt_minimap_mail"]              = "Correio",
    ["opt_minimap_difficulty"]        = "Dificuldade",
    ["opt_minimap_expansion"]         = "Botão de expansão",
    ["opt_minimap_crafting"]          = "Encomendas de criação",
    ["minimap_style_bliz"]            = "Blizzard",
    ["minimap_style_tomo"]            = "TomoMod",
    ["section_buttonbag"]             = "Botões de addons",
    ["info_buttonbag"]                = "Reúne os botões de addons do minimapa em uma bolsa. Clique no botão do minimapa para abri-la.",
    ["opt_buttonbag_enable"]          = "Ativar o coletor",
    ["opt_collector_style"]           = "Estilo do coletor",
    ["collector_style_bliz"]          = "Blizzard (nativo)",
    ["collector_style_tomo"]          = "TomoMod (bolsa)",
    ["opt_buttonbag_anchor"]          = "Posição do botão",
    ["buttonbag_anchor_corner"]       = "No minimapa (canto)",
    ["buttonbag_anchor_clockl"]       = "À esquerda do relógio",
    ["buttonbag_anchor_clockr"]       = "À direita do relógio",
    ["opt_buttonbag_columns"]         = "Colunas",
    ["opt_buttonbag_iconsize"]        = "Tamanho do ícone",
    ["btn_buttonbag_rescan"]          = "Reescanear botões",
    -- =====================
    -- CONFIG: Remaining panels [Lot D4]
    -- =====================
    ["btn_bar_uniformize"]            = "Copiar a aparência desta barra para todas as barras",
    ["info_bar_uniformize"]           = "Copia a aparência (tamanho, espaçamento, colunas, transparência, escala, esmaecimento, textos…) para todas as outras barras. A posição e o estado de ativação de cada barra são mantidos.",
    ["opt_bar_hotkey_size"]           = "Tamanho da fonte da tecla de atalho",
    ["popup_ab_uniformize"]           = "Copiar a aparência da barra \"%s\" para todas as outras barras?",
    ["info_cb_anchor_uf"]             = "Esta barra de lançamento é ancorada ao quadro de unidade correspondente (portanto aparece no quadro de alvo/foco/animal de estimação/chefe).",
    ["tab_qol_compass"]               = "Bússola",
    ["section_compass"]               = "Barra de bússola",
    ["info_compass_desc"]             = "Uma barra de direção no topo da tela mostrando N/L/S/O conforme você gira, com um marcador apontando para sua missão rastreada ou ponto de rota do mapa. Somente leitura — sem taint.",
    ["info_compass_layout"]           = "Dica: use o modo Layout (/tmf layout) para arrastar a barra para onde quiser.",
    ["opt_compass_enable"]            = "Ativar barra de bússola",
    ["opt_compass_fov"]               = "Campo de visão",
    ["compass_fov_narrow"]            = "Estreito (±45°)",
    ["compass_fov_standard"]          = "Padrão (±60°)",
    ["compass_fov_wide"]              = "Amplo (±90°)",
    ["opt_compass_width"]             = "Largura da barra",
    ["opt_compass_height"]            = "Altura da barra",
    ["opt_compass_scale"]             = "Escala",
    ["opt_compass_show_heading"]      = "Mostrar leitura de direção (ex.: 245° SO)",
    ["opt_compass_show_distance"]     = "Mostrar distância nos marcadores",
    ["opt_compass_show_quest"]        = "Mostrar marcador de missão rastreada",
    ["opt_compass_show_waypoint"]     = "Mostrar marcador de ponto de rota do mapa",
    ["opt_skyride_ground_speed"]      = "Mostrar velocidade no solo",
    ["info_skyride_ground_speed"]     = "Também mostra sua velocidade de movimento no solo (os indicadores de voo permanecem ocultos enquanto você não estiver voando).",
    ["btn_class_reminder_preview"]    = "Pré-visualização",
    ["sublabel_class_reminder_coverage"] = "— Bônus e formas monitorados —",
    ["opt_char_skin_movable"]         = "Janela movível",
    ["info_char_skin_movable"]        = "Uma vez ativado, arraste a janela de Personagem para movê-la. Sua posição é lembrada.",
    ["btn_char_skin_reset_pos"]       = "Redefinir posição",
    ["btn_sound_test"]                = "▶ Reproduzir este som",
    ["opt_auras_max_width"]           = "Largura máxima (quebra de linha)",
    ["opt_auras_per_row"]             = "Ícones por linha",

    -- 3.2.0
    ["cfg_tab_cdforge"]           = "Cooldowns",

    -- 3.2.1

    -- 3.2.2
    -- Suportes do Cooldown Manager (Movers / modo disposição)
    ["mover_cdm"]                        = "Cooldown Manager",
    ["cdm_drag_hint"]                    = "Arraste para mover",
    ["cdm_preview_aura"]                 = "Aura",




    -- =====================
    -- Traducoes ausentes -- these keys previously fell back to enUS
    -- =====================
    ["opt_cursor_ring_texture"]           = "Textura",
    ["cursor_tex_ring"]                   = "Anel",
    ["cursor_tex_glow"]                   = "Brilho",
    ["cursor_tex_cygle"]                  = "Cygle",
    ["cursor_tex_heart"]                  = "Coração",
    ["opt_cdm_custom_cd_swipe"]           = "Cor de varredura de recarga personalizada",
    ["opt_cdm_cd_swipe_color"]            = "Cor da varredura de recarga",
    ["opt_cdm_cd_swipe_alpha"]            = "Opacidade da varredura de recarga",
    ["section_cdm_advanced"]              = "Avançado",
    ["opt_cdm_hide_gcd"]                  = "Ocultar o GCD",
    ["opt_cdm_desaturate"]                = "Dessaturar durante a recarga",
    ["opt_cdm_buff_alignment"]            = "Alinhamento dos benefícios",
    ["align_center_outward"]              = "Centro → para fora",
    ["align_start"]                       = "Início (esquerda)",
    ["align_end"]                         = "Fim (direita)",
    ["section_cdm_visibility"]            = "Regras de visibilidade",
    ["info_cdm_visibility"]               = "Regras de ocultação com prioridade. As condições «Mostrar» têm precedência sobre as condições «Ocultar».",
    ["opt_cdm_hide_mounted"]              = "Ocultar quando montado",
    ["opt_cdm_hide_vehicle"]              = "Ocultar em veículo",
    ["opt_cdm_hide_ooc"]                  = "Ocultar fora de combate (sem alvo)",
    ["opt_cdm_show_combat"]               = "Sempre mostrar em combate",
    ["opt_cdm_show_instance"]             = "Sempre mostrar em instância",
    ["opt_cdm_show_enemy"]                = "Mostrar com alvo inimigo",
    ["section_cdm_extras"]                = "Som / Pandemic / Alcance",
    ["opt_cdm_sound_alert"]               = "Som quando a magia estiver pronta",
    ["opt_cdm_sound_file"]                = "Arquivo de som",
    ["opt_cdm_pandemic"]                  = "Pandemic (borda de renovação)",
    ["opt_cdm_pandemic_threshold"]        = "Limite de Pandemic (%)",
    ["opt_cdm_range_check"]               = "Colorir de vermelho fora de alcance",
    ["ot_bucket_complete"]                = "Prontas para entregar",
    ["ot_bucket_campaign"]                = "Campanha",
    ["ot_bucket_important"]               = "Importantes",
    ["ot_bucket_legendary"]               = "Lendárias",
    ["ot_bucket_weekly"]                  = "Semanais",
    ["ot_bucket_daily"]                   = "Diárias",
    ["ot_bucket_world"]                   = "Missões mundiais",
    ["ot_bucket_dungeon"]                 = "Masmorras",
    ["ot_bucket_raid"]                    = "Raides",
    ["ot_bucket_profession"]              = "Profissões",
    ["ot_bucket_achievement"]             = "Conquistas",
    ["ot_bucket_quests"]                  = "Missões",
    ["ot_bucket_other"]                   = "Outras",
    ["mover_minimap"]                     = "Minimapa e painel",
    ["mover_objectivetracker"]            = "Rastreador de objetivos",
    ["tab_skin_chatframeui"]              = "Interface de bate-papo",
    ["sublabel_chatframeui"]              = "— Interface de bate-papo multiposição —",
    ["opt_cfui_enable"]                   = "Ativar a interface de bate-papo",
    ["opt_cfui_enable_desc"]              = "Adiciona contêineres decorativos, uma barra de botões, ícones laterais e a troca de layout (estilo MayronUI).",
    ["opt_cfui_frame_topleft"]            = "Quadro superior esquerdo",
    ["opt_cfui_frame_topright"]           = "Quadro superior direito",
    ["opt_cfui_frame_bottomleft"]         = "Quadro inferior esquerdo",
    ["opt_cfui_frame_bottomright"]        = "Quadro inferior direito",
    ["opt_cfui_show_tab_bar"]             = "Mostrar a barra de abas",
    ["opt_cfui_tab_bar_offset"]           = "Deslocamento Y da barra de abas",
    ["opt_cfui_window_offset"]            = "Deslocamento Y da janela",
    ["opt_cfui_x_offset"]                 = "Deslocamento X",
    ["opt_cfui_y_offset"]                 = "Deslocamento Y",
    ["opt_cfui_icons_anchor"]             = "Ancoragem dos ícones laterais",
    ["opt_cfui_raid_frame_mgr"]           = "Redesenhar o gerenciador de quadros de raide",
    ["opt_cfui_editbox_position"]         = "Posição da caixa de texto",
    ["opt_cfui_editbox_height"]           = "Altura da caixa de texto",
    ["opt_cfui_swap_in_combat"]           = "Permitir a troca de botões em combate",
    ["cfui_show_chat_menu"]               = "Mostrar o menu de bate-papo",
    ["cfui_show_professions"]             = "Mostrar as profissões",
    ["cfui_show_shortcuts"]               = "Mostrar os atalhos de addons",
    ["cfui_copy_chat"]                    = "Copiar o texto do bate-papo",
    ["cfui_click_toggle_status"]          = "Clique para alternar AFK",
    ["cfui_layout_button"]                = "Layout TomoMod",
    ["cfui_left_click"]                   = "Clique esquerdo:",
    ["cfui_switch_layout"]                = "Trocar de layout",
    ["cfui_no_layouts"]                   = "Nenhum layout salvo. Use /tmf layout save <nome>",
    ["cfui_no_professions"]               = "Você não tem profissões.",
    ["cfui_config_menu"]                  = "Configuração",
    ["cfui_profiles"]                     = "Perfis",
    ["cfui_clear_chat"]                   = "Limpar o bate-papo",
    ["cfui_reload_ui"]                    = "Recarregar a interface",
    ["cfui_btn_character"]                = "Personagem",
    ["cfui_btn_bags"]                     = "Bolsas",
    ["cfui_btn_friends"]                  = "Amigos",
    ["cfui_btn_guild"]                    = "Guilda",
    ["cfui_btn_help"]                     = "Menu de ajuda",
    ["cfui_btn_pvp"]                      = "JxJ",
    ["cfui_btn_spellbook"]                = "Grimório de magias",
    ["cfui_btn_talents"]                  = "Talentos",
    ["cfui_btn_achievements"]             = "Conquistas",
    ["cfui_btn_calendar"]                 = "Calendário",
    ["cfui_btn_lfd"]                      = "Busca de masmorra",
    ["cfui_btn_raid"]                     = "Raide",
    ["cfui_btn_encounter"]                = "Guia de aventuras",
    ["cfui_btn_collections"]              = "Coleções",
    ["cfui_btn_macros"]                   = "Macros",
    ["cfui_btn_worldmap"]                 = "Mapa do mundo",
    ["cfui_btn_questlog"]                 = "Registro de missões",
    ["cfui_btn_reputation"]               = "Reputação",
    ["cfui_btn_pvpscore"]                 = "Pontuação JxJ",
    ["cfui_btn_currency"]                 = "Moeda",
    ["btn_abs_layout"]                    = "EditMode (/tmf layout)",
    ["opt_bar_enabled"]                   = "Ativada",
    ["opt_bar_orientation"]               = "Orientação",
    ["opt_bar_grow_dir"]                  = "Direção de crescimento",
    ["opt_bar_columns"]                   = "Colunas",
    ["opt_bar_button_size"]               = "Tamanho dos botões",
    ["opt_bar_spacing"]                   = "Espaçamento",
    ["opt_bar_alpha"]                     = "Transparência",
    ["opt_bar_scale"]                     = "Escala",
    ["opt_bar_display_cond"]              = "Condição de exibição",
    ["opt_bar_fade"]                      = "Ativar o esmaecimento",
    ["opt_bar_fade_out_alpha"]            = "Transparência ao esmaecer",
    ["opt_bar_fade_out_delay"]            = "Atraso antes de esmaecer",
    ["opt_bar_fade_out_dur"]              = "Duração do esmaecimento",
    ["opt_bar_fade_in_dur"]               = "Duração do surgimento",
    ["opt_bar_click_through"]             = "Ignorar cliques",
    ["opt_bar_show_empty"]                = "Mostrar os botões vazios",
    ["opt_bar_show_hotkey"]               = "Mostrar o texto dos atalhos",
    ["opt_bar_disabled"]                  = "Desativada",
    ["bar_name_bar1"]                     = "Barra 1 (principal)",
    ["bar_name_bar2"]                     = "Barra 2",
    ["bar_name_bar3"]                     = "Barra 3",
    ["bar_name_bar4"]                     = "Barra 4",
    ["bar_name_bar5"]                     = "Barra 5",
    ["bar_name_bar6"]                     = "Barra 6",
    ["bar_name_bar7"]                     = "Barra 7",
    ["bar_name_bar8"]                     = "Barra 8",
    ["bar_name_pet"]                      = "Barra do ajudante",
    ["bar_name_stance"]                   = "Barra de postura",
    ["pf_opt_name_max_length"]            = "Máx. de letras do nome (0 = sem limite)",
    ["tab_qol_consumable_bar"]            = "Consumíveis",
    ["section_consumable_bar"]            = "Barra de consumíveis",
    ["info_cb_desc"]                      = "Mostra um ícone e um temporizador para cada consumível ativo: frasco (1 h), bem alimentado (1 h) e óleo de arma (2 h). O espaço do óleo da mão secundária só aparece quando há uma arma equipada nela.",
    ["opt_consumable_enable"]             = "Ativar a barra de consumíveis",
    ["opt_cb_show_missing"]               = "Mostrar os benefícios ausentes (esmaecidos)",
    ["opt_cb_icon_size"]                  = "Tamanho dos ícones",
    ["opt_cb_gap"]                        = "Espaço entre os ícones",
    ["opt_cb_orientation"]                = "Orientação",
    ["cb_orient_horizontal"]              = "Horizontal",
    ["cb_orient_vertical"]                = "Vertical",
    ["opt_cb_timer_pos"]                  = "Posição do temporizador",
    ["cb_timerpos_below"]                 = "Abaixo (horizontal)",
    ["cb_timerpos_above"]                 = "Acima (horizontal)",
    ["cb_timerpos_right"]                 = "Direita (vertical)",
    ["cb_timerpos_left"]                  = "Esquerda (vertical)",
    ["mover_consumable_bar"]              = "Barra de consumíveis",
    ["mover_class_reminder"]              = "Lembrete de classe",
    ["art_title"]                         = "Rastreador de receitas",
    ["art_no_recipes"]                    = "Nenhuma receita rastreada — rastreie uma receita na janela de profissão.",
    ["art_status_idle"]                   = "Clique em um ingrediente para pesquisá-lo na casa de leilões.",
    ["art_scan_btn"]                      = "Escanear a casa de leilões",
    ["art_scan_running"]                  = "Escaneando...",
    ["art_scan_started"]                  = "Escaneamento iniciado — aguarde...",
    ["art_scan_done"]                     = "Escaneamento concluído: %d itens registrados.",
    ["art_scan_failed"]                   = "O escaneamento falhou ou foi interrompido.",
    ["art_scan_cooldown"]                 = "Próximo escaneamento disponível em %dm %ds.",
    ["art_scan_tip_title"]                = "Escaneamento completo da casa de leilões",
    ["art_scan_tip_desc"]                 = "Registra a compra imediata mais baixa por item. Limitado a uma vez a cada 15 minutos.",
    ["art_only_at_ah"]                    = "Abra primeiro a casa de leilões.",
    ["art_scan_already"]                  = "Um escaneamento já está em andamento.",
    ["art_tt_stack"]                      = "Pilha",
    ["art_tt_scanned"]                    = "Escaneado",
    ["art_tt_just_now"]                   = "agora mesmo",
    ["art_tt_min_ago"]                    = "há %dm",
    ["art_tt_hour_ago"]                   = "há %dh",
    ["art_tt_day_ago"]                    = "há %dd",
    ["tab_qol_rare_alert"]                = "Alerta de raros",
    ["section_rare_alert"]                = "Alerta de raros",
    ["opt_rare_alert_enable"]             = "Ativar os alertas de proximidade de raros",
    ["opt_rare_alert_sound"]              = "Reproduzir um som de alerta",
    ["opt_rare_alert_duration"]           = "Duração do banner (s)",
    ["btn_reset_rare_alert_pos"]          = "Redefinir a posição do banner",
    ["rare_alert_info"]                   = "Avisa você quando um NPC raro está por perto. Clique no banner para alvejá-lo, colocar o marcador de caveira e definir um ponto de rota. Clique com o botão direito para dispensar. Use /tmf layout para mover o banner.",
    ["rare_alert_tooltip"]                = "Clique esquerdo: alvejar + caveira + ponto de rota. Clique direito: dispensar.",

    -- =====================
    -- 3.3.2 — Novidades
    -- =====================

    -- =====================
    -- 3.3.3 — Novidades
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
    -- 3.5.7 — Novidades
    -- =====================

    -- =====================
    -- 3.5.5 — Novidades
    -- =====================

    -- =====================
    -- 3.5.4 — Novidades

    -- =====================
    -- 3.5.3 — Novidades

    -- 3.5.2 — Novidades
    -- =====================

    -- =====================
    -- 3.5.1 — Novidades
    -- =====================

    -- =====================
    -- 3.4.6 — Novidades
    -- =====================


    -- =====================
    -- 3.4.5 — Novidades
    -- =====================


    -- =====================
    -- 3.4.4 — Novidades
    -- =====================


    -- =====================
    -- 3.4.3 — Novidades
    -- =====================

    -- =====================
    -- 3.4.2 — Novidades
    -- =====================

    -- =====================
    -- 3.4.1 — Novidades
    -- =====================

    -- =====================
    -- 3.3.6 — Novidades
    -- =====================

    -- =====================
    -- 3.3.5 — Novidades
    -- =====================

    -- =====================
    -- 3.3.4 — Novidades
    -- =====================

    -- =====================
    -- QOL: Companion Status (lembrete de mascote)
    -- =====================
    ["tab_qol_companion"]             = "Lembrete de mascote",
    ["section_companion"]             = "Status do mascote",
    ["info_companion_desc"]           = "Mostra um lembrete quando seu mascote está ausente ou morto. Só aparece para especializações que realmente usam um: caçadores de Domínio das Feras e Sobrevivência, todos os bruxos e cavaleiros da morte Profanos. Lobo Solitário e Grimório do Sacrifício o desativam sozinhos.",
    ["info_companion_unavailable"]    = "O módulo ainda não terminou de carregar. Reabra esta aba em instantes.",
    ["opt_companion_enable"]          = "Ativar lembrete de mascote",
    ["opt_companion_hide_mounted"]    = "Ocultar em montaria terrestre",
    ["info_companion_travel"]         = "O lembrete fica sempre oculto durante voo, rotas de voo e veículos. Desmarque para continuar vendo-o em uma montaria terrestre.",
    ["opt_companion_display_mode"]    = "Exibição",
    ["companion_mode_icon"]           = "Ícone",
    ["companion_mode_text"]           = "Texto",
    ["companion_mode_both"]           = "Ambos",
    ["opt_companion_scale"]           = "Escala",
    ["opt_companion_size"]            = "Tamanho do ícone",
    ["sublabel_companion_pos"]        = "Posição",
    ["opt_companion_x"]               = "Deslocamento horizontal",
    ["opt_companion_y"]               = "Deslocamento vertical",
    ["btn_companion_reset_pos"]       = "Redefinir posição",
    ["info_companion_slash"]          = "Comandos: /cs on, /cs off, /cs mounted, /cs debug.",
    ["companion_pet_missing"]         = "Mascote ausente",
    ["companion_pet_dead"]            = "Mascote morto",

    -- ActionBars: Secure Visibility Engine
    ["Secure Visibility"] = "Visibilidade segura",
    ["Visibility Mode"] = "Modo de visibilidade",
    ["Always"] = "Sempre",
    ["In Combat"] = "Em combate",
    ["Out of Combat"] = "Fora de combate",
    ["Solo"] = "Solo",
    ["Party Only"] = "Somente grupo",
    ["Raid Only"] = "Somente raide",
    ["Any Instance"] = "Qualquer instância",
    ["Mounted"] = "Montado",
    ["Has Target"] = "Com alvo",
    ["Hostile Target"] = "Alvo hostil",
    ["Hidden"] = "Oculto",
    ["Custom Condition"] = "Condição personalizada",
    ["Securely show or hide this bar based on game state. These rules keep working in combat without normal Lua Show/Hide calls."] = "Mostra ou oculta esta barra com segurança conforme o estado do jogo. As regras continuam funcionando em combate sem chamadas Lua normais de Show/Hide.",

    -- ActionBars: Secure Paging
    ["Secure Paging"] = "Paginação segura",
    ["Securely switch Action Bar 1 by modifier, target, form, skyriding, or manual page. Vehicle and override pages always keep priority."] = "Alterne com segurança a Barra de Ações 1 por modificador, alvo, forma, voo dinâmico ou página manual. As páginas de veículo e substituição sempre têm prioridade.",
    ["Alt Modifier Page"] = "Página com Alt",
    ["Shift Modifier Page"] = "Página com Shift",
    ["Ctrl Modifier Page"] = "Página com Ctrl",
    ["Friendly Target Page"] = "Página com alvo amistoso",
    ["Hostile Target Page"] = "Página com alvo hostil",
    ["Disable Automatic Form Paging"] = "Desativar paginação automática de formas",
    ["Disable Automatic Skyriding Paging"] = "Desativar paginação automática do voo dinâmico",
    ["Default (no page switch)"] = "Padrão (sem troca de página)",
    ["Action Bar 1"] = "Barra de Ações 1",
    ["Action Bar 2"] = "Barra de Ações 2",
    ["Action Bar 3"] = "Barra de Ações 3",
    ["Action Bar 4"] = "Barra de Ações 4",
    ["Action Bar 5"] = "Barra de Ações 5",
    ["Action Bar 6"] = "Barra de Ações 6",
    ["Action Bar 7"] = "Barra de Ações 7",
    ["Action Bar 8"] = "Barra de Ações 8",

    -- =====================
    -- HEALER STUDIO (advanced Party/Raid healer indicators)
    -- =====================
    ["btn_open_healerstudio"]    = "Abrir o Healer Studio",
    ["info_healerstudio"]        = "Perfil avancado: escolha seus HoTs, escudos e bencaos de cura e posicione cada icone livremente na celula. Substitui a linha acima quando ativado.",
    ["hs_list"]                  = "AURAS",
    ["hs_mode"]                  = "Perfil",
    ["hs_mode_party"]            = "Grupo",
    ["hs_mode_raid"]             = "Raide",
    ["hs_class"]                 = "Classe",
    ["hs_enable"]                = "Ativar o perfil avancado",
    ["hs_healer_only"]           = "Apenas em uma especializacao de curandeiro",
    ["hs_show_duration"]         = "Mostrar os segundos restantes",
    ["hs_show_duration_info"]    = "Desativado, o ícone mantém a varredura de tempo e perde apenas o número por cima. Útil em ícones pequenos, onde os dígitos cobrem quase toda a arte.",
    ["hs_mode_on"]               = "Perfil avancado ativo: a linha de HoTs classica fica oculta nessas celulas.",
    ["hs_mode_off"]              = "A linha de HoTs classica continua em uso enquanto este perfil estiver desativado.",
    ["hs_preset"]                = "Predefinicao inicial",
    ["hs_reset_class"]           = "Redefinir esta classe",
    ["hs_reset_position"]        = "Redefinir a posicao",
    ["hs_select"]                = "Selecione uma aura na lista para posiciona-la.",
    ["hs_size"]                  = "Tamanho do icone",
    ["hs_anchor"]                = "Ancoragem",
    ["hs_offset_x"]              = "Deslocamento horizontal",
    ["hs_offset_y"]              = "Deslocamento vertical",
    ["hs_hint"]                  = "Arraste os icones sobre a celula - as alteracoes sao salvas na hora",
    ["hs_combat"]                = "o layout nao pode ser alterado em combate.",
    ["hs_cat_hot"]               = "HoT",
    ["hs_cat_shield"]            = "Escudo",
    ["hs_cat_beacon"]            = "Farol / vinculo",
    ["hs_cat_marker"]            = "Marcador de cura",
    ["hs_cat_external"]          = "Externo",

    -- Slash command output (Core/Init.lua, CooldownManager, UnitFrames)
    ["cli_after_combat"]       = "após o combate",
    ["cli_reload_required"]    = "/reload necessário",
    ["cli_dependents_off"]     = "dependentes desativados:",
    ["cli_deps_off"]           = "dependências desativadas:",
    ["cli_pending_reload"]     = "%s aguardando /reload",
    ["cli_mod_live"]           = "%d em tempo real",
    ["cli_mod_reload"]         = "%d com /reload",
    ["cli_mod_none"]           = "%d sem alternância",
    ["cli_modules_hint"]       = "/tmf modules <chave> para alternar",
    ["cli_backup_created"]     = "backup criado.",
    ["cli_backup_usage"]       = "/tmf backup save | /tmf backup restore [número]",
    ["cli_layout_usage"]       = "/tmf layout export|import <texto>",
    ["cli_capture_failed"]     = "falha na captura",
    ["cli_res_counts"]         = "%d fontes, %d âncoras",
    ["msg_help_install"]       = "Reabrir o assistente de configuração",
    ["msg_help_loot"]          = "Abrir o navegador de saques (masmorras e raides)",
    ["msg_cdm_placement_mode"] = "Modo de posicionamento",
    ["msg_cdm_live_preview"]   = "Pré-visualização ao vivo",
    ["msg_uf_ouf_missing"]     = "Biblioteca oUF não encontrada (X-oUF: TomoMod_oUF)!",

})
