-- TomoModForever 1.3.4 release notes, the quest tracker reset and the damage meter fixes.

TomoMod_RegisterLocale("enUS", {
    ["wn_134_tracker"] = "New - Quest tracker: if it ends up off screen (after a drag or an Edit Mode change), type /tmf tracker reset or use the \"Reset the tracker position\" button in Skins > Obj. Tracker. It goes back to the top right at 100 % scale.",
    ["msg_help_tracker_reset"] = "Put the quest tracker back on screen",
    ["msg_tracker_reset"] = "quest tracker put back at its default place.",
    ["msg_tracker_reset_combat"] = "quest tracker will go back to its default place when combat ends.",
    ["btn_obj_tracker_reset"] = "Reset the tracker position",
    ["info_obj_tracker_reset"] = "Tracker gone off screen? This puts it back at the top right, at 100 % scale. Also: /tmf tracker reset",
    ["wn_134_deathrecap"] = "Fixed - Damage meter: the automatic death recap now opens when you die mid-fight (it only worked once combat was over), and never shows the same death twice.",
    ["wn_134_dmstable"] = "Fixed - Damage meter: sturdier against Blizzard API errors. A failing call or an unknown event no longer stops the meter windows, breakdowns or reset.",
    ["wn_134_dmwindows"] = "Changed - Damage meter: the Benchmark no longer scans the fight while idle, and Escape closes the Benchmark and Fight history windows without tainting the interface.",
})

TomoMod_RegisterLocale("frFR", {
    ["wn_134_tracker"] = "Nouveau - Suivi des quêtes : s'il se retrouve hors de l'écran (après un déplacement ou un changement dans le mode Édition), tape /tmf tracker reset ou utilise le bouton \"Réinitialiser la position du suivi\" dans Apparence > Suivi d'objectifs. Il revient en haut à droite, à 100 %.",
    ["msg_help_tracker_reset"] = "Remettre le suivi des quêtes à l'écran",
    ["msg_tracker_reset"] = "suivi des quêtes remis à sa place par défaut.",
    ["msg_tracker_reset_combat"] = "le suivi des quêtes reviendra à sa place par défaut à la fin du combat.",
    ["btn_obj_tracker_reset"] = "Réinitialiser la position du suivi",
    ["info_obj_tracker_reset"] = "Suivi disparu hors de l'écran ? Ce bouton le remet en haut à droite, à 100 %. Aussi : /tmf tracker reset",
    ["wn_134_deathrecap"] = "Corrigé - Damage meter : le récap de mort automatique s'ouvre maintenant quand tu meurs en plein combat (il ne marchait qu'après le combat), et n'affiche jamais deux fois la même mort.",
    ["wn_134_dmstable"] = "Corrigé - Damage meter : plus solide face aux erreurs de l'API Blizzard. Un appel qui échoue ou un événement inconnu n'arrête plus les fenêtres, les détails ni la remise à zéro.",
    ["wn_134_dmwindows"] = "Modifié - Damage meter : le Benchmark ne lit plus le combat quand il est inactif, et Échap ferme les fenêtres Benchmark et Historique des combats sans corrompre l'interface (taint).",
})

TomoMod_RegisterLocale("deDE", {
    ["wn_134_tracker"] = "Neu - Questverfolgung: landet sie außerhalb des Bildschirms (nach dem Verschieben oder einer Änderung im Bearbeitungsmodus), tippe /tmf tracker reset oder nutze die Schaltfläche \"Position der Verfolgung zurücksetzen\" unter Skins > Questverfolgung. Sie kehrt oben rechts mit 100 % zurück.",
    ["msg_help_tracker_reset"] = "Questverfolgung zurück auf den Bildschirm",
    ["msg_tracker_reset"] = "Questverfolgung an ihren Standardplatz zurückgesetzt.",
    ["msg_tracker_reset_combat"] = "die Questverfolgung kehrt nach dem Kampf an ihren Standardplatz zurück.",
    ["btn_obj_tracker_reset"] = "Position der Verfolgung zurücksetzen",
    ["info_obj_tracker_reset"] = "Verfolgung außerhalb des Bildschirms? Diese Schaltfläche setzt sie oben rechts mit 100 % zurück. Auch: /tmf tracker reset",
    ["wn_134_deathrecap"] = "Behoben - Damage Meter: Die automatische Todesübersicht öffnet sich jetzt, wenn du mitten im Kampf stirbst (sie ging nur nach dem Kampf), und zeigt denselben Tod nie zweimal.",
    ["wn_134_dmstable"] = "Behoben - Damage Meter: robuster gegen Fehler der Blizzard-API. Ein fehlschlagender Aufruf oder ein unbekanntes Ereignis stoppt die Fenster, Aufschlüsselungen und das Zurücksetzen nicht mehr.",
    ["wn_134_dmwindows"] = "Geändert - Damage Meter: Der Benchmark liest den Kampf im Leerlauf nicht mehr aus, und Escape schließt die Fenster Benchmark und Kampfverlauf ohne Taint der Oberfläche.",
})

TomoMod_RegisterLocale("esES", {
    ["wn_134_tracker"] = "Nuevo - Seguimiento de misiones: si acaba fuera de la pantalla (tras moverlo o un cambio en el modo Edición), escribe /tmf tracker reset o usa el botón \"Restablecer la posición del seguimiento\" en Apariencia > Seguimiento de misiones. Vuelve arriba a la derecha, al 100 %.",
    ["msg_help_tracker_reset"] = "Devolver el seguimiento de misiones a la pantalla",
    ["msg_tracker_reset"] = "seguimiento de misiones devuelto a su posición por defecto.",
    ["msg_tracker_reset_combat"] = "el seguimiento de misiones volverá a su posición por defecto al terminar el combate.",
    ["btn_obj_tracker_reset"] = "Restablecer la posición del seguimiento",
    ["info_obj_tracker_reset"] = "¿El seguimiento desapareció de la pantalla? Este botón lo devuelve arriba a la derecha, al 100 %. También: /tmf tracker reset",
    ["wn_134_deathrecap"] = "Corregido - Medidor de daño: el resumen de muerte automático ahora se abre cuando mueres en pleno combate (solo funcionaba al terminar el combate) y nunca muestra dos veces la misma muerte.",
    ["wn_134_dmstable"] = "Corregido - Medidor de daño: más robusto ante errores de la API de Blizzard. Una llamada fallida o un evento desconocido ya no detiene las ventanas, los desgloses ni el reinicio.",
    ["wn_134_dmwindows"] = "Cambiado - Medidor de daño: el Benchmark ya no analiza el combate cuando está inactivo, y Escape cierra las ventanas Benchmark e Historial de combates sin contaminar (taint) la interfaz.",
})

TomoMod_RegisterLocale("itIT", {
    ["wn_134_tracker"] = "Nuovo - Tracciamento missioni: se finisce fuori dallo schermo (dopo uno spostamento o una modifica in modalità Modifica), digita /tmf tracker reset o usa il pulsante \"Ripristina la posizione del tracciamento\" in Aspetto > Tracciamento missioni. Torna in alto a destra, al 100 %.",
    ["msg_help_tracker_reset"] = "Riporta il tracciamento missioni sullo schermo",
    ["msg_tracker_reset"] = "tracciamento missioni riportato alla posizione predefinita.",
    ["msg_tracker_reset_combat"] = "il tracciamento missioni tornerà alla posizione predefinita a fine combattimento.",
    ["btn_obj_tracker_reset"] = "Ripristina la posizione del tracciamento",
    ["info_obj_tracker_reset"] = "Tracciamento sparito dallo schermo? Questo pulsante lo riporta in alto a destra, al 100 %. Anche: /tmf tracker reset",
    ["wn_134_deathrecap"] = "Corretto - Damage meter: il riepilogo di morte automatico ora si apre quando muori in pieno combattimento (funzionava solo a fine combattimento) e non mostra mai due volte la stessa morte.",
    ["wn_134_dmstable"] = "Corretto - Damage meter: più solido contro gli errori dell'API Blizzard. Una chiamata fallita o un evento sconosciuto non blocca più le finestre, i dettagli né il reset.",
    ["wn_134_dmwindows"] = "Modificato - Damage meter: il Benchmark non analizza più il combattimento quando è inattivo, ed Esc chiude le finestre Benchmark e Cronologia combattimenti senza contaminare (taint) l'interfaccia.",
})

TomoMod_RegisterLocale("ptBR", {
    ["wn_134_tracker"] = "Novo - Rastreador de missões: se ele sair da tela (depois de movê-lo ou de uma mudança no modo de Edição), digite /tmf tracker reset ou use o botão \"Redefinir a posição do rastreador\" em Aparência > Rastreador de missões. Ele volta ao canto superior direito, a 100 %.",
    ["msg_help_tracker_reset"] = "Trazer o rastreador de missões de volta à tela",
    ["msg_tracker_reset"] = "rastreador de missões de volta à posição padrão.",
    ["msg_tracker_reset_combat"] = "o rastreador de missões voltará à posição padrão quando o combate terminar.",
    ["btn_obj_tracker_reset"] = "Redefinir a posição do rastreador",
    ["info_obj_tracker_reset"] = "Rastreador sumiu da tela? Este botão o traz de volta ao canto superior direito, a 100 %. Também: /tmf tracker reset",
    ["wn_134_deathrecap"] = "Corrigido - Medidor de dano: o resumo de morte automático agora abre quando você morre no meio do combate (só funcionava depois do combate) e nunca mostra a mesma morte duas vezes.",
    ["wn_134_dmstable"] = "Corrigido - Medidor de dano: mais robusto contra erros da API da Blizzard. Uma chamada que falha ou um evento desconhecido não para mais as janelas, os detalhamentos nem a redefinição.",
    ["wn_134_dmwindows"] = "Alterado - Medidor de dano: o Benchmark não analisa mais o combate quando está inativo, e Esc fecha as janelas Benchmark e Histórico de combates sem contaminar (taint) a interface.",
})
