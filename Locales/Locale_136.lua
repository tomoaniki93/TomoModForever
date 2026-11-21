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

-- Forever look drawn with the game's own art.
TomoMod_RegisterLocale("enUS", {
    ["wn_136_forever"] = "New - Forever frame style: an official skin drawn with WoW Forever's own art (bronze plate, portrait ring, level disc), with the elite and rare dragon, the quest mark, the skull for targets far above you, and on your frame the combat swords and a red, gold or threat glow. The old look stays as the classic skin, in Frames > Shared style. Inspired by FlareUI (Malkkav).",
})
TomoMod_RegisterLocale("frFR", {
    ["wn_136_forever"] = "Nouveau - Style de cadres Forever : un habillage officiel dessiné avec l'art de WoW Forever (plaque bronze, anneau de portrait, médaillon de niveau), avec le dragon des élites et des rares, la marque de quête, le crâne des cibles trop fortes, et sur ton cadre les épées de combat et une lueur rouge, dorée ou de menace. L'ancien rendu reste en habillage classique, dans Cadres > Style commun. Inspiré de FlareUI (Malkkav).",
})
TomoMod_RegisterLocale("deDE", {
    ["wn_136_forever"] = "Neu - Rahmenstil Forever: eine offizielle Optik mit der eigenen Grafik von WoW Forever (Bronzeplatte, Porträtring, Stufenmedaillon), mit dem Drachen für Elite und Rare, der Questmarkierung, dem Totenkopf für viel stärkere Ziele und auf deinem Rahmen den Kampfschwertern und einem roten, goldenen oder Bedrohungsleuchten. Die alte Optik bleibt als klassische Variante unter Rahmen > Gemeinsamer Stil. Inspiriert von FlareUI (Malkkav).",
})
TomoMod_RegisterLocale("esES", {
    ["wn_136_forever"] = "Nuevo - Estilo de marcos Forever: un aspecto oficial dibujado con el arte de WoW Forever (placa de bronce, anillo de retrato, medallón de nivel), con el dragón de élites y raros, la marca de misión, la calavera de los objetivos muy superiores y, en tu marco, las espadas de combate y un brillo rojo, dorado o de amenaza. El aspecto anterior queda como clásico, en Marcos > Estilo común. Inspirado en FlareUI (Malkkav).",
})
TomoMod_RegisterLocale("itIT", {
    ["wn_136_forever"] = "Nuovo - Stile dei riquadri Forever: un aspetto ufficiale disegnato con la grafica di WoW Forever (placca di bronzo, anello del ritratto, medaglione del livello), con il drago di élite e rari, il segno di missione, il teschio per i bersagli molto più forti e, sul tuo riquadro, le spade di combattimento e un bagliore rosso, dorato o di minaccia. Il vecchio aspetto resta come classico, in Riquadri > Stile comune. Ispirato a FlareUI (Malkkav).",
})
TomoMod_RegisterLocale("ptBR", {
    ["wn_136_forever"] = "Novo - Estilo de quadros Forever: um visual oficial desenhado com a arte do WoW Forever (placa de bronze, anel do retrato, medalhão de nível), com o dragão de elites e raros, a marca de missão, a caveira para alvos muito acima de você e, no seu quadro, as espadas de combate e um brilho vermelho, dourado ou de ameaça. O visual antigo continua como clássico, em Quadros > Estilo comum. Inspirado no FlareUI (Malkkav).",
})

-- 1.3.6: mana bar, gathering, quest reward, fishing, world map
TomoMod_RegisterLocale("enUS", {
    ["mod_manaBar"] = "Mana bar",
    ["mod_gatherTips"] = "Gathering tooltips",
    ["mod_questReward"] = "Best quest reward",
    ["mod_fishing"] = "Fishing",
    ["mod_mapMarkers"] = "World map markers",
    ["wn_136_mana"] = "New - Mana bar: on the player frame, a spark shows the five seconds without regeneration after a spell, then each regeneration tick; while casting, the mana the spell will cost is highlighted.",
    ["wn_136_gather"] = "New - Herbs, veins and skinnable beasts show the skill required in their tooltip, coloured against yours. In quest rewards, a purse marks the item that sells for the most.",
    ["wn_136_fishing"] = "New - Fishing: one key (Key Bindings, AddOns) equips the pole, applies a lure, casts, and reels in when it bites. Optional double right click to cast and fishing sounds brought forward.",
    ["wn_136_map"] = "New - World map: flight points, dungeon entrances, boats and zeppelins (click: waypoint). Options to fade the map while moving and to see the game behind the maximized map.",
})
TomoMod_RegisterLocale("frFR", {
    ["mod_manaBar"] = "Barre de mana",
    ["mod_gatherTips"] = "Infobulles de récolte",
    ["mod_questReward"] = "Meilleure récompense",
    ["mod_fishing"] = "Pêche",
    ["mod_mapMarkers"] = "Marqueurs de carte",
    ["wn_136_mana"] = "Nouveau - Barre de mana : sur le cadre du joueur, une étincelle montre les cinq secondes sans régénération après un sort, puis chaque tick de régénération ; pendant une incantation, le mana que coûtera le sort est surligné.",
    ["wn_136_gather"] = "Nouveau - Les herbes, filons et bêtes à dépecer indiquent la compétence requise dans leur infobulle, colorée selon la tienne. Dans les récompenses de quête, une bourse marque l'objet qui se vend le plus cher.",
    ["wn_136_fishing"] = "Nouveau - Pêche : une touche (Raccourcis, Addons) équipe la canne, pose un appât, lance, puis ramène quand ça mord. En option : double clic droit pour lancer et sons de pêche mis en avant.",
    ["wn_136_map"] = "Nouveau - Carte du monde : points de vol, entrées de donjons, bateaux et zeppelins (clic : point de passage). Options pour estomper la carte en mouvement et voir le jeu derrière la carte agrandie.",
})
TomoMod_RegisterLocale("deDE", {
    ["mod_manaBar"] = "Manaleiste",
    ["mod_gatherTips"] = "Sammel-Tooltips",
    ["mod_questReward"] = "Beste Questbelohnung",
    ["mod_fishing"] = "Angeln",
    ["mod_mapMarkers"] = "Kartenmarkierungen",
    ["wn_136_mana"] = "Neu - Manaleiste: Am Spielerrahmen zeigt ein Funke die fünf Sekunden ohne Regeneration nach einem Zauber, danach jeden Regenerationstick; beim Wirken werden die Manakosten des Zaubers hervorgehoben.",
    ["wn_136_gather"] = "Neu - Kräuter, Erzadern und kürschnerbare Tiere zeigen die nötige Fertigkeit im Tooltip, gefärbt nach deiner. Bei Questbelohnungen markiert ein Beutel den Gegenstand mit dem höchsten Verkaufswert.",
    ["wn_136_fishing"] = "Neu - Angeln: Eine Taste (Tastenbelegung, AddOns) legt die Angel an, bringt einen Köder an, wirft aus und holt ein, wenn etwas anbeißt. Optional Doppel-Rechtsklick zum Auswerfen und hervorgehobene Angelgeräusche.",
    ["wn_136_map"] = "Neu - Weltkarte: Flugpunkte, Instanzeingänge, Schiffe und Zeppeline (Klick: Wegpunkt). Optionen zum Ausblenden der Karte beim Laufen und um das Spiel hinter der maximierten Karte zu sehen.",
})
TomoMod_RegisterLocale("esES", {
    ["mod_manaBar"] = "Barra de maná",
    ["mod_gatherTips"] = "Descripciones de recolección",
    ["mod_questReward"] = "Mejor recompensa",
    ["mod_fishing"] = "Pesca",
    ["mod_mapMarkers"] = "Marcadores del mapa",
    ["wn_136_mana"] = "Nuevo - Barra de maná: en el marco del jugador, una chispa muestra los cinco segundos sin regeneración tras un hechizo y luego cada tic de regeneración; al lanzar, se resalta el maná que costará el hechizo.",
    ["wn_136_gather"] = "Nuevo - Hierbas, filones y bestias desollables muestran la habilidad necesaria en su descripción, coloreada según la tuya. En las recompensas de misión, una bolsa marca el objeto que se vende más caro.",
    ["wn_136_fishing"] = "Nuevo - Pesca: una tecla (Asignación de teclas, Accesorios) equipa la caña, pone un cebo, lanza y recoge cuando pican. Opcional: doble clic derecho para lanzar y sonidos de pesca destacados.",
    ["wn_136_map"] = "Nuevo - Mapa del mundo: puntos de vuelo, entradas de mazmorras, barcos y zepelines (clic: punto de ruta). Opciones para atenuar el mapa al moverte y ver el juego detrás del mapa ampliado.",
})
TomoMod_RegisterLocale("itIT", {
    ["mod_manaBar"] = "Barra del mana",
    ["mod_gatherTips"] = "Suggerimenti di raccolta",
    ["mod_questReward"] = "Ricompensa migliore",
    ["mod_fishing"] = "Pesca",
    ["mod_mapMarkers"] = "Indicatori della mappa",
    ["wn_136_mana"] = "Nuovo - Barra del mana: sul riquadro del giocatore, una scintilla mostra i cinque secondi senza rigenerazione dopo un incantesimo, poi ogni tick di rigenerazione; durante il lancio è evidenziato il mana che costerà l'incantesimo.",
    ["wn_136_gather"] = "Nuovo - Erbe, vene e bestie scuoiabili mostrano l'abilità richiesta nel suggerimento, colorata rispetto alla tua. Nelle ricompense delle missioni, una borsa indica l'oggetto che si vende di più.",
    ["wn_136_fishing"] = "Nuovo - Pesca: un tasto (Assegnazione tasti, AddOn) equipaggia la canna, applica un'esca, lancia e recupera quando abboccano. Opzionale: doppio clic destro per lanciare e suoni di pesca in evidenza.",
    ["wn_136_map"] = "Nuovo - Mappa del mondo: punti di volo, ingressi delle spedizioni, navi e zeppelin (clic: punto di passaggio). Opzioni per sfumare la mappa in movimento e vedere il gioco dietro la mappa ingrandita.",
})
TomoMod_RegisterLocale("ptBR", {
    ["mod_manaBar"] = "Barra de mana",
    ["mod_gatherTips"] = "Dicas de coleta",
    ["mod_questReward"] = "Melhor recompensa",
    ["mod_fishing"] = "Pesca",
    ["mod_mapMarkers"] = "Marcadores do mapa",
    ["wn_136_mana"] = "Novo - Barra de mana: no quadro do jogador, uma faísca mostra os cinco segundos sem regeneração após um feitiço e depois cada tique de regeneração; ao lançar, o mana que o feitiço vai custar fica destacado.",
    ["wn_136_gather"] = "Novo - Ervas, veios e feras esfoláveis mostram a perícia necessária na dica, colorida conforme a sua. Nas recompensas de missão, uma bolsa marca o item que vende pelo maior valor.",
    ["wn_136_fishing"] = "Novo - Pesca: uma tecla (Atalhos, AddOns) equipa a vara, aplica uma isca, lança e recolhe quando fisgar. Opcional: duplo clique direito para lançar e sons de pesca em destaque.",
    ["wn_136_map"] = "Novo - Mapa-múndi: pontos de voo, entradas de masmorras, barcos e zepelins (clique: ponto de referência). Opções para esmaecer o mapa ao andar e ver o jogo atrás do mapa ampliado.",
})
