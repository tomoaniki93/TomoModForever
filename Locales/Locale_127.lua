-- TomoModForever 1.2.7 release notes, and the restart reminder of the
-- quest item sparkles (CVarOptimizer.lua).

TomoMod_RegisterLocale("enUS", {
    ["wn_127_alts"] = "Fixed - Mail, Alts tab: your other characters now show up. Forever's realm name can change between sessions, and the list only kept characters whose realm text matched exactly, so it often stayed empty. Characters are now matched by name and faction, and saved again on level up and at logout. Log in once on each of your characters to fill the list. /tml alts shows what is saved.",
    ["wn_127_guild"] = "Fixed - Mail, Guild tab: guild members show up when the mailbox opens (the roster was read before the server sent it), offline members included unless \"Online only\" is ticked.",
    ["wn_127_recent"] = "Fixed - Mail, Recent tab: sent letters are now remembered (the name was read after the send box was cleared), and the list no longer resets when the realm name changes.",
    ["wn_127_sparkles"] = "New - Quest items on the ground sparkle, so you no longer walk past them. Graphics presets switch the game's loot sparkle off; TomoMod switches it back on at login and after every graphics change. Your outline mode is left as you set it. On by default, under Adventure comforts > Quest items.",
    ["sparkles_restart"] = "Restart the game to remove the quest item sparkles (/reload is not enough).",
    ["wn_127_tracker"] = "Fixed - Quest tracker: every tracked quest now shows. Blizzard only builds the quests that fit in its own tracker height, so after ten or so the rest were never created, even with \"Max quests displayed\" at 0 (no limit).",
})

TomoMod_RegisterLocale("frFR", {
    ["wn_127_alts"] = "Corrigé - Courrier, onglet Alts : tes autres personnages apparaissent enfin. Le nom de royaume de Forever peut changer d'une session à l'autre, et la liste ne gardait que les personnages dont le royaume correspondait exactement, d'où une liste souvent vide. Les personnages sont maintenant reconnus par leur nom et leur faction, et réenregistrés à chaque niveau et à la déconnexion. Connecte-toi une fois sur chacun de tes personnages pour remplir la liste. /tml alts montre ce qui est enregistré.",
    ["wn_127_guild"] = "Corrigé - Courrier, onglet Guilde : les membres de la guilde s'affichent à l'ouverture de la boîte aux lettres (la liste était lue avant que le serveur l'envoie), membres hors ligne compris sauf si « En ligne uniquement » est coché.",
    ["wn_127_recent"] = "Corrigé - Courrier, onglet Récents : les envois sont maintenant retenus (le nom était lu après que le champ d'envoi soit vidé), et la liste ne repart plus de zéro quand le nom du royaume change.",
    ["wn_127_sparkles"] = "Nouveau - Les objets de quête au sol scintillent : fini de passer à côté. Les préréglages graphiques coupent le scintillement du jeu ; TomoMod le remet à la connexion et après chaque changement graphique. Ton mode contour n'est pas modifié. Activé par défaut, dans Confort d'aventure, Objets de quête.",
    ["sparkles_restart"] = "Redémarre le jeu pour retirer le scintillement des objets de quête (/reload ne suffit pas).",
    ["wn_127_tracker"] = "Corrigé - Suivi des quêtes : toutes les quêtes suivies s'affichent. Blizzard ne crée que les quêtes qui tiennent dans la hauteur de son propre suivi : au-delà d'une dizaine, les autres n'existaient pas, même avec « Quêtes affichées max » à 0 (sans limite).",
})

TomoMod_RegisterLocale("deDE", {
    ["wn_127_alts"] = "Behoben - Post, Reiter Twinks: Deine anderen Charaktere erscheinen jetzt. Der Realmname von Forever kann sich zwischen Sitzungen ändern, und die Liste behielt nur Charaktere mit exakt gleichem Realmtext, daher blieb sie oft leer. Charaktere werden jetzt über Name und Fraktion erkannt und bei Stufenaufstieg und beim Ausloggen neu gespeichert. Logge dich einmal mit jedem Charakter ein, um die Liste zu füllen. /tml alts zeigt, was gespeichert ist.",
    ["wn_127_guild"] = "Behoben - Post, Reiter Gilde: Gildenmitglieder erscheinen beim Öffnen des Briefkastens (die Liste wurde gelesen, bevor der Server sie schickte), auch Offline-Mitglieder, außer „Nur online Gildenmitglieder“ ist angehakt.",
    ["wn_127_recent"] = "Behoben - Post, Reiter Zuletzt: Gesendete Briefe werden jetzt gemerkt (der Name wurde gelesen, nachdem das Empfängerfeld geleert war), und die Liste beginnt nicht mehr von vorn, wenn sich der Realmname ändert.",
    ["wn_127_sparkles"] = "Neu - Questgegenstände am Boden funkeln, damit du nicht mehr an ihnen vorbeiläufst. Grafikvoreinstellungen schalten das Beute-Funkeln des Spiels aus; TomoMod schaltet es beim Einloggen und nach jeder Grafikänderung wieder ein. Dein Umrissmodus bleibt, wie du ihn eingestellt hast. Standardmäßig an, unter Abenteuer-Komfort, Questgegenstände.",
    ["sparkles_restart"] = "Starte das Spiel neu, um das Funkeln der Questgegenstände zu entfernen (/reload reicht nicht).",
    ["wn_127_tracker"] = "Behoben - Questverfolgung: Alle verfolgten Quests werden angezeigt. Blizzard baut nur die Quests, die in die Höhe seiner eigenen Verfolgung passen; nach etwa zehn fehlten die übrigen, selbst mit „Max. angezeigte Quests“ auf 0 (unbegrenzt).",
})

TomoMod_RegisterLocale("esES", {
    ["wn_127_alts"] = "Corregido - Correo, pestaña Alters: tus otros personajes por fin aparecen. El nombre del reino de Forever puede cambiar entre sesiones y la lista solo guardaba los personajes cuyo reino coincidía exactamente, por eso a menudo estaba vacía. Ahora los personajes se reconocen por nombre y facción, y se guardan de nuevo al subir de nivel y al salir. Conéctate una vez con cada personaje para llenar la lista. /tml alts muestra lo guardado.",
    ["wn_127_guild"] = "Corregido - Correo, pestaña Hermandad: los miembros aparecen al abrir el buzón (la lista se leía antes de que el servidor la enviara), incluidos los desconectados salvo si «Solo miembros de la hermandad en línea» está marcado.",
    ["wn_127_recent"] = "Corregido - Correo, pestaña Recientes: los envíos ahora se recuerdan (el nombre se leía después de vaciarse el campo de destinatario), y la lista ya no se reinicia cuando cambia el nombre del reino.",
    ["wn_127_sparkles"] = "Nuevo - Los objetos de misión en el suelo destellan, así ya no pasas de largo. Los preajustes gráficos desactivan el destello de botín del juego; TomoMod lo vuelve a activar al conectarte y tras cada cambio gráfico. Tu modo de contorno no cambia. Activado por defecto, en Comodidades de aventura, Objetos de misión.",
    ["sparkles_restart"] = "Reinicia el juego para quitar el destello de los objetos de misión (/reload no basta).",
    ["wn_127_tracker"] = "Corregido - Seguimiento de misiones: ahora se muestran todas las misiones seguidas. Blizzard solo crea las misiones que caben en la altura de su propio seguimiento; a partir de unas diez, las demás no existían, incluso con «Máx. misiones mostradas» en 0 (sin límite).",
})

TomoMod_RegisterLocale("itIT", {
    ["wn_127_alts"] = "Corretto - Posta, scheda Alt: i tuoi altri personaggi ora compaiono. Il nome del reame di Forever può cambiare tra una sessione e l'altra e la lista teneva solo i personaggi con il reame identico, per questo restava spesso vuota. Ora i personaggi sono riconosciuti per nome e fazione, e salvati di nuovo a ogni livello e all'uscita. Entra una volta con ciascun personaggio per riempire la lista. /tml alts mostra cosa è salvato.",
    ["wn_127_guild"] = "Corretto - Posta, scheda Gilda: i membri compaiono all'apertura della cassetta (la lista veniva letta prima che il server la inviasse), anche quelli offline salvo se «Mostra solo i membri della gilda online» è spuntato.",
    ["wn_127_recent"] = "Corretto - Posta, scheda Recenti: le lettere inviate ora vengono ricordate (il nome veniva letto dopo lo svuotamento del campo destinatario), e la lista non si azzera più quando cambia il nome del reame.",
    ["wn_127_sparkles"] = "Nuovo - Gli oggetti delle missioni a terra scintillano, così non ci passi più accanto. Le preimpostazioni grafiche spengono lo scintillio del bottino; TomoMod lo riaccende all'accesso e dopo ogni modifica grafica. La tua modalità contorno resta com'è. Attivo di default, in Comodità d'avventura, Oggetti delle missioni.",
    ["sparkles_restart"] = "Riavvia il gioco per togliere lo scintillio degli oggetti delle missioni (/reload non basta).",
    ["wn_127_tracker"] = "Corretto - Tracciamento missioni: ora compaiono tutte le missioni tracciate. Blizzard crea solo le missioni che entrano nell'altezza del proprio tracciamento; oltre una decina le altre non esistevano, anche con il massimo di missioni mostrate a 0 (nessun limite).",
})

TomoMod_RegisterLocale("ptBR", {
    ["wn_127_alts"] = "Corrigido - Correio, aba Alts: seus outros personagens agora aparecem. O nome do reino de Forever pode mudar entre sessões e a lista só guardava personagens cujo reino era exatamente igual, por isso muitas vezes ficava vazia. Agora os personagens são reconhecidos pelo nome e pela facção, e salvos de novo ao subir de nível e ao sair. Entre uma vez com cada personagem para preencher a lista. /tml alts mostra o que está salvo.",
    ["wn_127_guild"] = "Corrigido - Correio, aba Guilda: os membros aparecem ao abrir a caixa de correio (a lista era lida antes de o servidor enviá-la), incluindo os offline, a menos que «Apenas membros da guilda online» esteja marcado.",
    ["wn_127_recent"] = "Corrigido - Correio, aba Recentes: as cartas enviadas agora são lembradas (o nome era lido depois de o campo de destinatário ser limpo), e a lista não recomeça mais quando o nome do reino muda.",
    ["wn_127_sparkles"] = "Novo - Os itens de missão no chão brilham, assim você não passa mais direto por eles. As predefinições gráficas desligam o brilho de saque do jogo; o TomoMod o religa ao entrar e após cada mudança gráfica. Seu modo de contorno fica como você deixou. Ativado por padrão, em Confortos de aventura, Itens de missão.",
    ["sparkles_restart"] = "Reinicie o jogo para remover o brilho dos itens de missão (/reload não basta).",
    ["wn_127_tracker"] = "Corrigido - Rastreador de missões: todas as missões rastreadas agora aparecem. A Blizzard só cria as missões que cabem na altura do próprio rastreador; depois de umas dez, as outras não existiam, mesmo com «Máx. de missões exibidas» em 0 (sem limite).",
})
