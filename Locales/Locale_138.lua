-- TomoModForever 1.3.8: group quest progress fixes.
-- No "+", guillemets or bullets in these strings: the font may not carry them.

TomoMod_RegisterLocale("enUS", {
    ["wn_138_party"] = "Fixed - Group quest progress: after a login, reload or loading screen the lists are asked for and sent again, hovering a quest asks a member who sent nothing yet, and the instance channel is tried when the party channel is refused. New command /tmf groupe to check the exchange.",
    ["msg_help_groupe"] = "Group quest progress: what was sent, refused and received per member",
    ["pq_rep_yes"] = "yes",
    ["pq_rep_no"] = "no",
    ["pq_rep_head"] = "|cffd4a64aTMF group|r  sharing %s, in a group %s, channel %s",
    ["pq_rep_sent"] = "  sent %d, refused %d, last result %s (%s)",
    ["pq_rep_mine"] = "  my quests announced: %d",
    ["pq_rep_member"] = "  %s: messages received %d, quests known %d",
})

TomoMod_RegisterLocale("frFR", {
    ["wn_138_party"] = "Corrigé - Progression de groupe : après une connexion, un reload ou un écran de chargement, les listes sont redemandées et renvoyées, le survol d'une quête redemande à un membre qui n'a encore rien envoyé, et le canal d'instance est essayé si celui du groupe est refusé. Nouvelle commande /tmf groupe pour vérifier l'échange.",
    ["msg_help_groupe"] = "Progression de groupe : ce qui a été envoyé, refusé et reçu par membre",
    ["pq_rep_yes"] = "oui",
    ["pq_rep_no"] = "non",
    ["pq_rep_head"] = "|cffd4a64aTMF groupe|r  partage %s, en groupe %s, canal %s",
    ["pq_rep_sent"] = "  envoyés %d, refusés %d, dernier résultat %s (%s)",
    ["pq_rep_mine"] = "  mes quêtes annoncées : %d",
    ["pq_rep_member"] = "  %s : messages reçus %d, quêtes connues %d",
})

TomoMod_RegisterLocale("deDE", {
    ["wn_138_party"] = "Behoben - Gruppen-Questfortschritt: Nach Anmeldung, Reload oder Ladebildschirm werden die Listen neu angefragt und gesendet, das Überfahren einer Quest fragt ein Mitglied an, das noch nichts gesendet hat, und der Instanzkanal wird versucht, wenn der Gruppenkanal abgelehnt wird. Neuer Befehl /tmf groupe zur Prüfung.",
    ["msg_help_groupe"] = "Gruppen-Questfortschritt: Gesendetes, Abgelehntes und Empfangenes pro Mitglied",
    ["pq_rep_yes"] = "ja",
    ["pq_rep_no"] = "nein",
    ["pq_rep_head"] = "|cffd4a64aTMF Gruppe|r  Teilen %s, in Gruppe %s, Kanal %s",
    ["pq_rep_sent"] = "  gesendet %d, abgelehnt %d, letztes Ergebnis %s (%s)",
    ["pq_rep_mine"] = "  meine gemeldeten Quests: %d",
    ["pq_rep_member"] = "  %s: empfangene Nachrichten %d, bekannte Quests %d",
})

TomoMod_RegisterLocale("esES", {
    ["wn_138_party"] = "Corregido - Progreso de grupo: tras conectar, recargar o una pantalla de carga se vuelven a pedir y enviar las listas, pasar el ratón por una misión pregunta a quien aún no envió nada, y se prueba el canal de instancia si el de grupo es rechazado. Nuevo comando /tmf groupe para comprobar el intercambio.",
    ["msg_help_groupe"] = "Progreso de grupo: lo enviado, rechazado y recibido por miembro",
    ["pq_rep_yes"] = "sí",
    ["pq_rep_no"] = "no",
    ["pq_rep_head"] = "|cffd4a64aTMF grupo|r  compartir %s, en grupo %s, canal %s",
    ["pq_rep_sent"] = "  enviados %d, rechazados %d, último resultado %s (%s)",
    ["pq_rep_mine"] = "  mis misiones anunciadas: %d",
    ["pq_rep_member"] = "  %s: mensajes recibidos %d, misiones conocidas %d",
})

TomoMod_RegisterLocale("itIT", {
    ["wn_138_party"] = "Corretto - Progressi di gruppo: dopo accesso, reload o schermata di caricamento le liste vengono richieste e rinviate, passare sopra una missione chiede a chi non ha ancora inviato nulla, e si prova il canale d'istanza se quello di gruppo è rifiutato. Nuovo comando /tmf groupe per controllare lo scambio.",
    ["msg_help_groupe"] = "Progressi di gruppo: inviato, rifiutato e ricevuto per membro",
    ["pq_rep_yes"] = "sì",
    ["pq_rep_no"] = "no",
    ["pq_rep_head"] = "|cffd4a64aTMF gruppo|r  condivisione %s, in gruppo %s, canale %s",
    ["pq_rep_sent"] = "  inviati %d, rifiutati %d, ultimo risultato %s (%s)",
    ["pq_rep_mine"] = "  mie missioni annunciate: %d",
    ["pq_rep_member"] = "  %s: messaggi ricevuti %d, missioni note %d",
})

TomoMod_RegisterLocale("ptBR", {
    ["wn_138_party"] = "Corrigido - Progresso do grupo: após login, reload ou tela de carregamento as listas são pedidas e enviadas de novo, passar o mouse numa missão pergunta a quem ainda não enviou nada, e o canal de instância é tentado se o do grupo for recusado. Novo comando /tmf groupe para verificar a troca.",
    ["msg_help_groupe"] = "Progresso do grupo: o que foi enviado, recusado e recebido por membro",
    ["pq_rep_yes"] = "sim",
    ["pq_rep_no"] = "não",
    ["pq_rep_head"] = "|cffd4a64aTMF grupo|r  compartilhar %s, em grupo %s, canal %s",
    ["pq_rep_sent"] = "  enviados %d, recusados %d, último resultado %s (%s)",
    ["pq_rep_mine"] = "  minhas missões anunciadas: %d",
    ["pq_rep_member"] = "  %s: mensagens recebidas %d, missões conhecidas %d",
})
