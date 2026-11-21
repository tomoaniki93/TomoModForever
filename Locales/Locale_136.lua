-- TomoModForever 1.3.6: memory and diagnostics.
-- No "+", guillemets or bullets in these strings: the font may not carry them.

TomoMod_RegisterLocale("enUS", {
    ["wn_136_memory"] = "Improved - Memory: the class trainer data now keeps your own class only (about 300 KB less).",
    ["wn_136_diag"] = "Improved - Diagnostics: the report shows how much memory TMF uses; normal game messages (shapeshift form, item use, camp placement) are no longer logged; stored errors are capped in size, and a few garbled dashes in the report are fixed.",
})

TomoMod_RegisterLocale("frFR", {
    ["wn_136_memory"] = "Amélioré - Mémoire : les données des maîtres de classe ne gardent plus que ta classe (environ 300 Ko de moins).",
    ["wn_136_diag"] = "Amélioré - Diagnostic : le rapport indique la mémoire utilisée par TMF ; les messages normaux du jeu (forme de druide, utilisation d'objet, placement au camp) ne sont plus enregistrés ; la taille des erreurs gardées est limitée, et quelques tirets illisibles du rapport sont corrigés.",
})

TomoMod_RegisterLocale("deDE", {
    ["wn_136_memory"] = "Verbessert - Speicher: Die Daten der Klassenlehrer behalten nur noch deine eigene Klasse (etwa 300 KB weniger).",
    ["wn_136_diag"] = "Verbessert - Diagnose: Der Bericht zeigt den Speicherverbrauch von TMF; normale Spielmeldungen (Gestaltwandel, Gegenstandsnutzung, Lagerplatzierung) werden nicht mehr erfasst; gespeicherte Fehler sind in der Größe begrenzt, und einige verstümmelte Striche im Bericht sind behoben.",
})

TomoMod_RegisterLocale("esES", {
    ["wn_136_memory"] = "Mejorado - Memoria: los datos de los instructores de clase solo guardan tu propia clase (unos 300 KB menos).",
    ["wn_136_diag"] = "Mejorado - Diagnóstico: el informe muestra la memoria que usa TMF; los mensajes normales del juego (forma de druida, uso de objetos, colocación en el campamento) ya no se registran; el tamaño de los errores guardados está limitado y se corrigen algunos guiones ilegibles del informe.",
})

TomoMod_RegisterLocale("itIT", {
    ["wn_136_memory"] = "Migliorato - Memoria: i dati degli istruttori di classe tengono solo la tua classe (circa 300 KB in meno).",
    ["wn_136_diag"] = "Migliorato - Diagnostica: il rapporto mostra la memoria usata da TMF; i normali messaggi di gioco (forma da druido, uso di oggetti, posizionamento al campo) non vengono più registrati; la dimensione degli errori salvati è limitata e alcuni trattini illeggibili del rapporto sono corretti.",
})

TomoMod_RegisterLocale("ptBR", {
    ["wn_136_memory"] = "Melhorado - Memória: os dados dos instrutores de classe guardam só a sua classe (cerca de 300 KB a menos).",
    ["wn_136_diag"] = "Melhorado - Diagnóstico: o relatório mostra a memória usada pelo TMF; mensagens normais do jogo (forma de druida, uso de itens, posicionamento no acampamento) não são mais registradas; o tamanho dos erros guardados é limitado e alguns traços ilegíveis do relatório foram corrigidos.",
})

-- Animations, level up, notifications, quest tooltips.
TomoMod_RegisterLocale("enUS", {
    ["mod_toasts"] = "Notifications",
    ["mod_questTooltip"] = "Quests in tooltips",
    ["wn_136_levelup"] = "New - Level up: a golden ring opens in the middle of the screen, \"Level N\" pops and embers fly out; at even levels it says how many spells wait at your class trainer.",
    ["wn_136_toasts"] = "New - Notifications: bronze banners at the top of the screen for quests turned in or complete, rare loot, new reputation standing, areas discovered and spells learned (one banner for a whole \"Train all\"). Each kind can be switched off in Adventure > Notifications.",
    ["wn_136_tooltip"] = "New - Quests in tooltips: hover a monster or an item a quest of your log asks for, and the quest and your progress are added to the tooltip. TMF stands down when Questie shows its own.",
    ["wn_136_anim"] = "New - Interface animations: full, reduced (short fades only) or none, on the home page of the options. Followed by all of TMF: level up, notifications, quest tracker, alerts, camp, options window.",
})

TomoMod_RegisterLocale("frFR", {
    ["mod_toasts"] = "Notifications",
    ["mod_questTooltip"] = "Quêtes dans les infobulles",
    ["wn_136_levelup"] = "Nouveau - Montée de niveau : un anneau doré s'ouvre au centre de l'écran, Niveau N apparaît et des étincelles jaillissent ; aux niveaux pairs, il indique combien de sorts t'attendent chez ton maître de classe.",
    ["wn_136_toasts"] = "Nouveau - Notifications : des bandeaux bronze en haut de l'écran pour les quêtes rendues ou terminées, le butin rare, une nouvelle réputation, les zones découvertes et les sorts appris (un seul bandeau pour tout un Tout apprendre). Chaque type se coupe dans Aventure > Notifications.",
    ["wn_136_tooltip"] = "Nouveau - Quêtes dans les infobulles : survole un monstre ou un objet demandé par une quête de ton journal, la quête et ta progression s'ajoutent à l'infobulle. TMF se met en retrait quand Questie affiche les siennes.",
    ["wn_136_anim"] = "Nouveau - Animations de l'interface : complètes, réduites (fondus courts seulement) ou aucune, sur l'accueil des options. Suivi par tout TMF : montée de niveau, notifications, suivi des quêtes, alertes, campement, fenêtre des options.",
})

TomoMod_RegisterLocale("deDE", {
    ["mod_toasts"] = "Benachrichtigungen",
    ["mod_questTooltip"] = "Quests in Tooltips",
    ["wn_136_levelup"] = "Neu - Stufenaufstieg: Ein goldener Ring öffnet sich in der Bildschirmmitte, \"Stufe N\" erscheint und Funken sprühen; auf geraden Stufen steht dabei, wie viele Zauber beim Klassenlehrer warten.",
    ["wn_136_toasts"] = "Neu - Benachrichtigungen: Bronzebanner oben am Bildschirm für abgegebene oder erledigte Quests, seltene Beute, neuen Ruf, entdeckte Gebiete und erlernte Zauber (ein Banner für ein ganzes Alle erlernen). Jede Art lässt sich unter Abenteuer > Benachrichtigungen abschalten.",
    ["wn_136_tooltip"] = "Neu - Quests in Tooltips: Fahre über ein Monster oder einen Gegenstand, den eine Quest deines Logs verlangt, und Quest samt Fortschritt erscheinen im Tooltip. TMF tritt zurück, wenn Questie eigene zeigt.",
    ["wn_136_anim"] = "Neu - Animationen der Oberfläche: vollständig, reduziert (nur kurze Überblendungen) oder keine, auf der Startseite der Optionen. Gilt für ganz TMF: Stufenaufstieg, Benachrichtigungen, Questverfolgung, Warnungen, Lager, Optionsfenster.",
})

TomoMod_RegisterLocale("esES", {
    ["mod_toasts"] = "Notificaciones",
    ["mod_questTooltip"] = "Misiones en las descripciones",
    ["wn_136_levelup"] = "Nuevo - Subida de nivel: un anillo dorado se abre en el centro de la pantalla, aparece \"Nivel N\" y saltan chispas; en los niveles pares indica cuántos hechizos te esperan con tu instructor de clase.",
    ["wn_136_toasts"] = "Nuevo - Notificaciones: carteles de bronce arriba de la pantalla para misiones entregadas o completadas, botín raro, nueva reputación, zonas descubiertas y hechizos aprendidos (un solo cartel para todo un Aprender todo). Cada tipo se desactiva en Aventura > Notificaciones.",
    ["wn_136_tooltip"] = "Nuevo - Misiones en las descripciones: pasa el ratón sobre un monstruo o un objeto que pide una misión de tu registro y la misión y tu progreso se añaden a la descripción. TMF se retira cuando Questie muestra las suyas.",
    ["wn_136_anim"] = "Nuevo - Animaciones de la interfaz: completas, reducidas (solo fundidos cortos) o ninguna, en la página de inicio de las opciones. Las sigue todo TMF: subida de nivel, notificaciones, seguimiento de misiones, alertas, campamento, ventana de opciones.",
})

TomoMod_RegisterLocale("itIT", {
    ["mod_toasts"] = "Notifiche",
    ["mod_questTooltip"] = "Missioni nei tooltip",
    ["wn_136_levelup"] = "Nuovo - Passaggio di livello: un anello dorato si apre al centro dello schermo, appare \"Livello N\" e schizzano scintille; ai livelli pari indica quanti incantesimi ti aspettano dall'istruttore di classe.",
    ["wn_136_toasts"] = "Nuovo - Notifiche: banner di bronzo in alto sullo schermo per missioni consegnate o completate, bottino raro, nuova reputazione, zone scoperte e incantesimi appresi (un solo banner per tutto un Impara tutto). Ogni tipo si disattiva in Avventura > Notifiche.",
    ["wn_136_tooltip"] = "Nuovo - Missioni nei tooltip: passa sopra un mostro o un oggetto richiesto da una missione del registro e la missione con il tuo avanzamento si aggiunge al tooltip. TMF si ritira quando Questie mostra i suoi.",
    ["wn_136_anim"] = "Nuovo - Animazioni dell'interfaccia: complete, ridotte (solo brevi dissolvenze) o nessuna, nella pagina iniziale delle opzioni. Seguite da tutto TMF: passaggio di livello, notifiche, tracciamento missioni, avvisi, campo, finestra delle opzioni.",
})

TomoMod_RegisterLocale("ptBR", {
    ["mod_toasts"] = "Notificações",
    ["mod_questTooltip"] = "Missões nas dicas",
    ["wn_136_levelup"] = "Novo - Subida de nível: um anel dourado se abre no centro da tela, aparece \"Nível N\" e saltam faíscas; nos níveis pares ele mostra quantos feitiços esperam por você no instrutor de classe.",
    ["wn_136_toasts"] = "Novo - Notificações: faixas de bronze no topo da tela para missões entregues ou concluídas, saque raro, nova reputação, áreas descobertas e feitiços aprendidos (uma só faixa para todo um Aprender tudo). Cada tipo pode ser desligado em Aventura > Notificações.",
    ["wn_136_tooltip"] = "Novo - Missões nas dicas: passe o mouse sobre um monstro ou item pedido por uma missão do seu registro e a missão com seu progresso aparece na dica. O TMF se retira quando o Questie mostra as dele.",
    ["wn_136_anim"] = "Novo - Animações da interface: completas, reduzidas (só esmaecimentos curtos) ou nenhuma, na página inicial das opções. Seguidas por todo o TMF: subida de nível, notificações, rastreador de missões, alertas, acampamento, janela de opções.",
})
