-- =====================================================================
-- Locale_300.lua — Chaînes de la 3.0 (6 langues)
-- ---------------------------------------------------------------------
-- Source unique pour toutes les nouvelles chaînes 3.0 :
--   • Presets (preset_*)
--   • Installeur « presets d'abord » (ins_v3_*, ins_pick_*, ins_custom_*,
--     ins_recap_*)
--   • Accueil / Dashboard (dash_*) + recherche (cat_accueil, ui_search_*)
--   • What's New 3.0 (wn_300_*)
--
-- Chargé dans la section Locales du .toc (donc AVANT Core et Config),
-- pour que cat_accueil / wn_300_* soient résolus à temps.
-- enUS = fallback de base ; les autres langues le surchargent.
-- =====================================================================

-- =====================
-- enUS (base)
-- =====================
TomoMod_RegisterLocale("enUS", {
    -- [3.0.5] Compass (Waypoint 2.0)
    ["mover_compass"] = "Compass",
    ["ready_tracker_section"] = "Consumable readiness",
    ["ready_tracker_info"] = "Shows Flask, Well Fed and Thalassian Phoenix Oil below the minimap, next to the clock. The button is available everywhere; it only turns green or red in dungeons, raids, scenarios and delves.",
    ["ready_tracker_enable"] = "Enable consumable tracker",
    ["ready_tracker_button_side"] = "Button position",
    ["ready_tracker_button_size"] = "Button size",
    ["ready_tracker_tracker_size"] = "Tracker size",
    ["ready_tracker_side_left"] = "Left of the clock",
    ["ready_tracker_side_right"] = "Right of the clock",
    ["compass_dir_n"] = "N",
    ["compass_dir_e"] = "E",
    ["compass_dir_s"] = "S",
    ["compass_dir_w"] = "W",
    ["msg_help_compass"] = "Toggle the heading compass bar",
    -- [3.0.2] Changelog (What is New)
    -- [3.0.2] Minimap : style pistage + collecteur
    -- [3.0.1] Changelog (What is New)
    -- [3.0.1] ButtonBag : ancrage horloge
    -- [3.0.1] Clés ajoutées (movers anti-combat + libellés de panels manquants)
    ["layout_combat_blocked"] = "You can't move the interface while in combat.",
    ["btn_housing_leave"] = "Leave house",
    ["mover_actionbars"] = "Action Bars",
    -- Presets
    -- Installeur v3
    -- Accueil / recherche
    ["gs_no_results"]           = "No matching option",
    ["minimap_buttonbag"] = "Addon buttons",
    ["minimap_buttonbag_hint"] = "Click: show/hide",
    ["minimap_buttonbag_empty"] = "No buttons detected",
    ["cr_preview_sample"] = "Example: missing class buff",
    ["section_cdm_preview"] = "Preview",
    ["info_cdm_preview"] = "Cooldown bars only show icons when spells are actually on cooldown. To see and position them with examples, open Blizzard's Edit Mode.",
    ["section_rb_preview"] = "Preview",
    ["info_rb_preview"] = "Resource bars show your real resource (mana, energy, combo points…). To position them with a preview, open Blizzard's Edit Mode or unlock them from the Text tab.",
    ["btn_open_editmode"] = "Open Edit Mode",
    ["info_editmode_combat"] = "Edit Mode can't be opened in combat.",
    -- What's New 3.0
})

-- =====================
-- frFR
-- =====================
TomoMod_RegisterLocale("frFR", {
    -- [3.0.5] Compass (Waypoint 2.0)
    ["mover_compass"] = "Boussole",
    ["ready_tracker_section"] = "Préparation des consommables",
    ["ready_tracker_info"] = "Affiche Flacon, Bien nourri et Huile de phénix thalassienne sous la minicarte, à côté de l'heure. Le bouton est disponible partout ; il ne passe au vert ou au rouge qu'en donjon, raid, scénario et gouffre.",
    ["ready_tracker_enable"] = "Activer le suivi des consommables",
    ["ready_tracker_button_side"] = "Position du bouton",
    ["ready_tracker_button_size"] = "Taille du bouton",
    ["ready_tracker_tracker_size"] = "Taille du tracker",
    ["ready_tracker_side_left"] = "À gauche de l'heure",
    ["ready_tracker_side_right"] = "À droite de l'heure",
    ["compass_dir_n"] = "N",
    ["compass_dir_e"] = "E",
    ["compass_dir_s"] = "S",
    ["compass_dir_w"] = "O",
    ["msg_help_compass"] = "Afficher/masquer la barre de boussole",
    -- [3.0.2] Changelog (What is New)
    -- [3.0.2] Minimap : style pistage + collecteur
    -- [3.0.1] Changelog (What is New)
    -- [3.0.1] ButtonBag : ancrage horloge
    -- [3.0.1] Clés ajoutées (movers anti-combat + libellés de panels manquants)
    ["layout_combat_blocked"] = "Impossible de déplacer l'interface en combat.",
    ["btn_housing_leave"] = "Quitter la maison",
    ["mover_actionbars"] = "Barres d'action",
    ["gs_no_results"]           = "Aucune option correspondante",
    ["minimap_buttonbag"] = "Boutons d'addon",
    ["minimap_buttonbag_hint"] = "Clic : afficher/masquer",
    ["minimap_buttonbag_empty"] = "Aucun bouton détecté",
    ["cr_preview_sample"] = "Exemple : buff de classe manquant",
    ["section_cdm_preview"] = "Aperçu",
    ["info_cdm_preview"] = "Les barres de cooldown n'affichent des icônes que lorsque des sorts sont réellement en recharge. Pour les voir et les positionner avec des exemples, ouvre l'Edit Mode de Blizzard.",
    ["section_rb_preview"] = "Aperçu",
    ["info_rb_preview"] = "Les barres de ressources affichent ta ressource réelle (mana, énergie, points de combo…). Pour les positionner avec un aperçu, ouvre l'Edit Mode de Blizzard ou déverrouille-les depuis l'onglet Texte.",
    ["btn_open_editmode"] = "Ouvrir l'Edit Mode",
    ["info_editmode_combat"] = "L'Edit Mode ne peut pas être ouvert en combat.",
})

-- =====================
-- deDE
-- =====================
TomoMod_RegisterLocale("deDE", {
    -- [3.0.5] Compass (Waypoint 2.0)
    ["mover_compass"] = "Kompass",
    ["ready_tracker_section"] = "Verbrauchsbereitschaft",
    ["ready_tracker_info"] = "Zeigt Fläschchen, Satt und Thalassisches Phönixöl unter der Minikarte, neben der Uhr. Die Schaltfläche ist überall verfügbar; sie wird nur in Dungeons, Schlachtzügen, Szenarien und Tiefen grün oder rot.",
    ["ready_tracker_enable"] = "Verbrauchs-Tracker aktivieren",
    ["ready_tracker_button_side"] = "Schaltflächenposition",
    ["ready_tracker_button_size"] = "Schaltflächengröße",
    ["ready_tracker_tracker_size"] = "Tracker-Größe",
    ["ready_tracker_side_left"] = "Links von der Uhr",
    ["ready_tracker_side_right"] = "Rechts von der Uhr",
    ["compass_dir_n"] = "N",
    ["compass_dir_e"] = "O",
    ["compass_dir_s"] = "S",
    ["compass_dir_w"] = "W",
    ["msg_help_compass"] = "Kompassleiste umschalten",
    -- [3.0.2] Changelog (What is New)
    -- [3.0.2] Minimap : style pistage + collecteur
    -- [3.0.1] Changelog (What is New)
    -- [3.0.1] ButtonBag : ancrage horloge
    -- [3.0.1] Clés ajoutées (movers anti-combat + libellés de panels manquants)
    ["layout_combat_blocked"] = "Die Benutzeroberfläche kann im Kampf nicht verschoben werden.",
    ["btn_housing_leave"] = "Haus verlassen",
    ["mover_actionbars"] = "Aktionsleisten",
    ["gs_no_results"]           = "Keine passende Option",
    ["minimap_buttonbag"] = "Addon-Knöpfe",
    ["minimap_buttonbag_hint"] = "Klick: ein/aus",
    ["minimap_buttonbag_empty"] = "Keine Knöpfe erkannt",
    ["cr_preview_sample"] = "Beispiel: fehlender Klassen-Buff",
    ["section_cdm_preview"] = "Vorschau",
    ["info_cdm_preview"] = "Abklingzeitleisten zeigen nur Symbole, wenn Zauber tatsächlich abklingen. Um sie mit Beispielen zu sehen und zu positionieren, öffne Blizzards Bearbeitungsmodus.",
    ["section_rb_preview"] = "Vorschau",
    ["info_rb_preview"] = "Ressourcenleisten zeigen deine echte Ressource (Mana, Energie, Combopunkte…). Zum Positionieren mit Vorschau öffne Blizzards Bearbeitungsmodus oder entsperre sie im Reiter „Text“.",
    ["btn_open_editmode"] = "Bearbeitungsmodus öffnen",
    ["info_editmode_combat"] = "Der Bearbeitungsmodus kann im Kampf nicht geöffnet werden.",
})

-- =====================
-- esES
-- =====================
TomoMod_RegisterLocale("esES", {
    -- [3.0.5] Compass (Waypoint 2.0)
    ["mover_compass"] = "Brújula",
    ["ready_tracker_section"] = "Preparación de consumibles",
    ["ready_tracker_info"] = "Muestra Frasco, Bien alimentado y Aceite de fénix thalassiano bajo el minimapa, junto al reloj. El botón está disponible en todas partes; solo se pone verde o rojo en mazmorras, bandas, escenarios y simas.",
    ["ready_tracker_enable"] = "Activar seguimiento de consumibles",
    ["ready_tracker_button_side"] = "Posición del botón",
    ["ready_tracker_button_size"] = "Tamaño del botón",
    ["ready_tracker_tracker_size"] = "Tamaño del rastreador",
    ["ready_tracker_side_left"] = "A la izquierda del reloj",
    ["ready_tracker_side_right"] = "A la derecha del reloj",
    ["compass_dir_n"] = "N",
    ["compass_dir_e"] = "E",
    ["compass_dir_s"] = "S",
    ["compass_dir_w"] = "O",
    ["msg_help_compass"] = "Alternar la barra de brújula",
    -- [3.0.2] Changelog (What is New)
    -- [3.0.2] Minimap : style pistage + collecteur
    -- [3.0.1] Changelog (What is New)
    -- [3.0.1] ButtonBag : ancrage horloge
    -- [3.0.1] Clés ajoutées (movers anti-combat + libellés de panels manquants)
    ["layout_combat_blocked"] = "No puedes mover la interfaz en combate.",
    ["btn_housing_leave"] = "Salir de la casa",
    ["mover_actionbars"] = "Barras de acción",
    ["gs_no_results"]           = "Ninguna opción coincidente",
    ["minimap_buttonbag"] = "Botones de addon",
    ["minimap_buttonbag_hint"] = "Clic: mostrar/ocultar",
    ["minimap_buttonbag_empty"] = "No se detectaron botones",
    ["cr_preview_sample"] = "Ejemplo: falta una mejora de clase",
    ["section_cdm_preview"] = "Vista previa",
    ["info_cdm_preview"] = "Las barras de reutilización solo muestran iconos cuando los hechizos están realmente en reutilización. Para verlas y colocarlas con ejemplos, abre el Modo Edición de Blizzard.",
    ["section_rb_preview"] = "Vista previa",
    ["info_rb_preview"] = "Las barras de recursos muestran tu recurso real (maná, energía, puntos de combo…). Para colocarlas con vista previa, abre el Modo Edición de Blizzard o desbloquéalas desde la pestaña Texto.",
    ["btn_open_editmode"] = "Abrir Modo Edición",
    ["info_editmode_combat"] = "El Modo Edición no se puede abrir en combate.",
})

-- =====================
-- itIT
-- =====================
TomoMod_RegisterLocale("itIT", {
    -- [3.0.5] Compass (Waypoint 2.0)
    ["mover_compass"] = "Bussola",
    ["ready_tracker_section"] = "Preparazione consumabili",
    ["ready_tracker_info"] = "Mostra Fiala, Ben nutrito e Olio di fenice thalassiano sotto la minimappa, accanto all'orologio. Il pulsante è disponibile ovunque; diventa verde o rosso solo in spedizioni, incursioni, scenari e cavità.",
    ["ready_tracker_enable"] = "Attiva monitor consumabili",
    ["ready_tracker_button_side"] = "Posizione del pulsante",
    ["ready_tracker_button_size"] = "Dimensione pulsante",
    ["ready_tracker_tracker_size"] = "Dimensione tracker",
    ["ready_tracker_side_left"] = "A sinistra dell'orologio",
    ["ready_tracker_side_right"] = "A destra dell'orologio",
    ["compass_dir_n"] = "N",
    ["compass_dir_e"] = "E",
    ["compass_dir_s"] = "S",
    ["compass_dir_w"] = "O",
    ["msg_help_compass"] = "Attiva/disattiva la barra bussola",
    -- [3.0.2] Changelog (What is New)
    -- [3.0.2] Minimap : style pistage + collecteur
    -- [3.0.1] Changelog (What is New)
    -- [3.0.1] ButtonBag : ancrage horloge
    -- [3.0.1] Clés ajoutées (movers anti-combat + libellés de panels manquants)
    ["layout_combat_blocked"] = "Non puoi spostare l'interfaccia durante il combattimento.",
    ["btn_housing_leave"] = "Esci dalla casa",
    ["mover_actionbars"] = "Barre delle azioni",
    ["gs_no_results"]           = "Nessuna opzione corrispondente",
    ["minimap_buttonbag"] = "Pulsanti addon",
    ["minimap_buttonbag_hint"] = "Clic: mostra/nascondi",
    ["minimap_buttonbag_empty"] = "Nessun pulsante rilevato",
    ["cr_preview_sample"] = "Esempio: potenziamento di classe mancante",
    ["section_cdm_preview"] = "Anteprima",
    ["info_cdm_preview"] = "Le barre di ricarica mostrano le icone solo quando le abilità sono effettivamente in ricarica. Per vederle e posizionarle con esempi, apri la Modalità Modifica di Blizzard.",
    ["section_rb_preview"] = "Anteprima",
    ["info_rb_preview"] = "Le barre delle risorse mostrano la tua risorsa reale (mana, energia, punti combo…). Per posizionarle con un'anteprima, apri la Modalità Modifica di Blizzard o sbloccale dalla scheda Testo.",
    ["btn_open_editmode"] = "Apri Modalità Modifica",
    ["info_editmode_combat"] = "La Modalità Modifica non può essere aperta in combattimento.",
})

-- =====================
-- ptBR
-- =====================
TomoMod_RegisterLocale("ptBR", {
    -- [3.0.5] Compass (Waypoint 2.0)
    ["mover_compass"] = "Bússola",
    ["ready_tracker_section"] = "Preparação de consumíveis",
    ["ready_tracker_info"] = "Mostra Frasco, Bem alimentado e Óleo de fênix thalassiano abaixo do minimapa, ao lado do relógio. O botão está disponível em qualquer lugar; ele só fica verde ou vermelho em masmorras, raides, cenários e delves.",
    ["ready_tracker_enable"] = "Ativar rastreador de consumíveis",
    ["ready_tracker_button_side"] = "Posição do botão",
    ["ready_tracker_button_size"] = "Tamanho do botão",
    ["ready_tracker_tracker_size"] = "Tamanho do rastreador",
    ["ready_tracker_side_left"] = "À esquerda do relógio",
    ["ready_tracker_side_right"] = "À direita do relógio",
    ["compass_dir_n"] = "N",
    ["compass_dir_e"] = "L",
    ["compass_dir_s"] = "S",
    ["compass_dir_w"] = "O",
    ["msg_help_compass"] = "Alternar a barra de bússola",
    -- [3.0.2] Changelog (What is New)
    -- [3.0.2] Minimap : style pistage + collecteur
    -- [3.0.1] Changelog (What is New)
    -- [3.0.1] ButtonBag : ancrage horloge
    -- [3.0.1] Clés ajoutées (movers anti-combat + libellés de panels manquants)
    ["layout_combat_blocked"] = "Não é possível mover a interface em combate.",
    ["btn_housing_leave"] = "Sair da casa",
    ["mover_actionbars"] = "Barras de ação",
    ["gs_no_results"]           = "Nenhuma opção correspondente",
    ["minimap_buttonbag"] = "Botões de addon",
    ["minimap_buttonbag_hint"] = "Clique: mostrar/ocultar",
    ["minimap_buttonbag_empty"] = "Nenhum botão detectado",
    ["cr_preview_sample"] = "Exemplo: bônus de classe ausente",
    ["section_cdm_preview"] = "Pré-visualização",
    ["info_cdm_preview"] = "As barras de recarga só mostram ícones quando as magias estão realmente em recarga. Para vê-las e posicioná-las com exemplos, abra o Modo de Edição da Blizzard.",
    ["section_rb_preview"] = "Pré-visualização",
    ["info_rb_preview"] = "As barras de recurso mostram seu recurso real (mana, energia, pontos de combo…). Para posicioná-las com pré-visualização, abra o Modo de Edição da Blizzard ou desbloqueie-as na aba Texto.",
    ["btn_open_editmode"] = "Abrir Modo de Edição",
    ["info_editmode_combat"] = "O Modo de Edição não pode ser aberto em combate.",
})
