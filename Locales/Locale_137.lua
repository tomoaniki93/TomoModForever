-- TomoModForever 1.3.7: livelier frames and bars.
-- No "+", guillemets or bullets in these strings: the font may not carry them.

TomoMod_RegisterLocale("enUS", {
    ["mod_edgeAlerts"] = "Edge alerts",
    ["wn_137_bars"] = "New - Livelier bars: health and power bars glide to their new value; a heal shows in green first and the bar flows into it; spent mana or energy leaves a pale trail that drains away (Frames, Animations).",
    ["wn_137_edge"] = "New - Screen edge alerts: a red glow pulses along the screen edges when your health is low, a blue one when your mana is low (in combat by default). Thresholds, depth and intensity in Adventure, Screen edge alerts.",
    ["wn_137_xp"] = "New - XP bar: earned XP flows into the bar after each kill, and a light runs over the rested part now and then.",
})

TomoMod_RegisterLocale("frFR", {
    ["mod_edgeAlerts"] = "Alertes en bord d'écran",
    ["wn_137_bars"] = "Nouveau - Barres plus vivantes : les barres de vie et de ressource glissent vers leur nouvelle valeur ; un soin s'affiche d'abord en vert puis la barre le remplit ; la mana ou l'énergie dépensée laisse une traînée pâle qui s'écoule (Cadres, Animations).",
    ["wn_137_edge"] = "Nouveau - Alertes en bord d'écran : un liseré rouge pulse sur les bords quand ta vie est basse, un bleu quand ta mana est basse (en combat par défaut). Seuils, profondeur et intensité dans Aventure, Alertes en bord d'écran.",
    ["wn_137_xp"] = "Nouveau - Barre d'XP : l'XP gagnée remplit la barre en glissant après chaque monstre, et un reflet passe de temps en temps sur la part reposée.",
})

TomoMod_RegisterLocale("deDE", {
    ["mod_edgeAlerts"] = "Bildschirmrand-Warnungen",
    ["wn_137_bars"] = "Neu - Lebendigere Leisten: Gesundheits- und Ressourcenleisten gleiten zu ihrem neuen Wert; eine Heilung erscheint zuerst grün und die Leiste fließt hinein; verbrauchtes Mana oder Energie hinterlässt eine blasse Spur, die abfließt (Rahmen, Animationen).",
    ["wn_137_edge"] = "Neu - Bildschirmrand-Warnungen: Ein roter Schein pulsiert an den Bildschirmrändern bei niedriger Gesundheit, ein blauer bei wenig Mana (standardmäßig im Kampf). Schwellen, Tiefe und Intensität unter Abenteuer, Bildschirmrand-Warnungen.",
    ["wn_137_xp"] = "Neu - EP-Leiste: Erhaltene EP fließen nach jedem Kill in die Leiste, und ab und zu läuft ein Licht über den erholten Teil.",
})

TomoMod_RegisterLocale("esES", {
    ["mod_edgeAlerts"] = "Alertas en el borde",
    ["wn_137_bars"] = "Nuevo - Barras más vivas: las barras de salud y de recurso se deslizan hasta su nuevo valor; una sanación se ve primero en verde y la barra la llena; el maná o la energía gastados dejan un rastro pálido que se vacía (Marcos, Animaciones).",
    ["wn_137_edge"] = "Nuevo - Alertas en el borde de la pantalla: un brillo rojo late en los bordes con poca salud, uno azul con poco maná (en combate por defecto). Umbrales, profundidad e intensidad en Aventura, Alertas en el borde.",
    ["wn_137_xp"] = "Nuevo - Barra de experiencia: la experiencia ganada llena la barra deslizándose tras cada muerte, y de vez en cuando pasa un reflejo sobre la parte descansada.",
})

TomoMod_RegisterLocale("itIT", {
    ["mod_edgeAlerts"] = "Avvisi sul bordo",
    ["wn_137_bars"] = "Nuovo - Barre più vive: le barre di salute e di risorsa scorrono verso il nuovo valore; una cura appare prima in verde e la barra la riempie; il mana o l'energia spesi lasciano una scia chiara che si svuota (Riquadri, Animazioni).",
    ["wn_137_edge"] = "Nuovo - Avvisi sul bordo dello schermo: un bagliore rosso pulsa sui bordi con poca salute, uno blu con poco mana (in combattimento di base). Soglie, profondità e intensità in Avventura, Avvisi sul bordo.",
    ["wn_137_xp"] = "Nuovo - Barra dell'esperienza: l'esperienza guadagnata riempie la barra scorrendo dopo ogni uccisione, e ogni tanto un riflesso passa sulla parte riposata.",
})

TomoMod_RegisterLocale("ptBR", {
    ["mod_edgeAlerts"] = "Alertas na borda",
    ["wn_137_bars"] = "Novo - Barras mais vivas: as barras de vida e de recurso deslizam até o novo valor; uma cura aparece primeiro em verde e a barra a preenche; mana ou energia gastos deixam um rastro claro que escoa (Quadros, Animações).",
    ["wn_137_edge"] = "Novo - Alertas na borda da tela: um brilho vermelho pulsa nas bordas com vida baixa, um azul com mana baixa (em combate por padrão). Limites, profundidade e intensidade em Aventura, Alertas na borda.",
    ["wn_137_xp"] = "Novo - Barra de experiência: a experiência ganha preenche a barra deslizando após cada abate, e de vez em quando um reflexo passa sobre a parte descansada.",
})

-- 1.3.7: finishing touches (tracker, bags, options window)
TomoMod_RegisterLocale("enUS", {
    ["opt_ot_animate"] = "Bars glide, an objective that moves lights up",
    ["opt_ot_zone_banner"] = "Zone name above the tracker on zone change",
    ["opt_skin_bags_new_glint"] = "Golden light on new items",
    ["wn_137_polish"] = "New - Finishing touches: in the quest tracker the progress bar glides and an objective that moves lights up, and the new zone's name shows above it on zone change; new items in the bags get a golden light until the bags close; the options window brings its cards in one after another and its menus light up softly on hover.",
})

TomoMod_RegisterLocale("frFR", {
    ["opt_ot_animate"] = "Barres qui glissent, objectif qui s'éclaire quand il avance",
    ["opt_ot_zone_banner"] = "Nom de la zone au-dessus du suivi quand tu changes de zone",
    ["opt_skin_bags_new_glint"] = "Reflet doré sur les nouveaux objets",
    ["wn_137_polish"] = "Nouveau - Finitions : dans le suivi des quêtes, la barre de progression glisse et l'objectif qui avance s'éclaire, et le nom de la nouvelle zone s'affiche au-dessus quand tu en changes ; les nouveaux objets des sacs ont un reflet doré jusqu'à la fermeture des sacs ; la fenêtre des options fait arriver ses cartes l'une après l'autre et ses menus s'éclairent en douceur au survol.",
})

TomoMod_RegisterLocale("deDE", {
    ["opt_ot_animate"] = "Leisten gleiten, ein fortschreitendes Ziel leuchtet auf",
    ["opt_ot_zone_banner"] = "Zonenname über der Questverfolgung beim Zonenwechsel",
    ["opt_skin_bags_new_glint"] = "Goldenes Licht auf neuen Gegenständen",
    ["wn_137_polish"] = "Neu - Feinschliff: In der Questverfolgung gleitet der Fortschrittsbalken und ein fortschreitendes Ziel leuchtet auf, beim Zonenwechsel erscheint der Name der neuen Zone darüber; neue Gegenstände in den Taschen leuchten golden, bis die Taschen geschlossen werden; das Optionsfenster lässt seine Karten nacheinander erscheinen und seine Menüs leuchten beim Überfahren sanft auf.",
})

TomoMod_RegisterLocale("esES", {
    ["opt_ot_animate"] = "Las barras se deslizan, el objetivo que avanza se ilumina",
    ["opt_ot_zone_banner"] = "Nombre de la zona sobre el seguimiento al cambiar de zona",
    ["opt_skin_bags_new_glint"] = "Brillo dorado en los objetos nuevos",
    ["wn_137_polish"] = "Nuevo - Detalles finales: en el seguimiento de misiones la barra de progreso se desliza y el objetivo que avanza se ilumina, y el nombre de la nueva zona aparece encima al cambiar de zona; los objetos nuevos de las bolsas tienen un brillo dorado hasta cerrar las bolsas; la ventana de opciones muestra sus tarjetas una tras otra y sus menús se iluminan suavemente al pasar el ratón.",
})

TomoMod_RegisterLocale("itIT", {
    ["opt_ot_animate"] = "Le barre scorrono, l'obiettivo che avanza si illumina",
    ["opt_ot_zone_banner"] = "Nome della zona sopra il tracciamento al cambio di zona",
    ["opt_skin_bags_new_glint"] = "Riflesso dorato sui nuovi oggetti",
    ["wn_137_polish"] = "Nuovo - Rifiniture: nel tracciamento delle missioni la barra di avanzamento scorre e l'obiettivo che avanza si illumina, e al cambio di zona il nome della nuova zona appare sopra; i nuovi oggetti nelle borse hanno un riflesso dorato fino alla chiusura delle borse; la finestra delle opzioni fa arrivare le sue schede una dopo l'altra e i suoi menu si illuminano dolcemente al passaggio del mouse.",
})

TomoMod_RegisterLocale("ptBR", {
    ["opt_ot_animate"] = "As barras deslizam, o objetivo que avança se ilumina",
    ["opt_ot_zone_banner"] = "Nome da zona acima do rastreador ao mudar de zona",
    ["opt_skin_bags_new_glint"] = "Brilho dourado nos itens novos",
    ["wn_137_polish"] = "Novo - Acabamentos: no rastreador de missões a barra de progresso desliza e o objetivo que avança se ilumina, e o nome da nova zona aparece acima ao mudar de zona; os itens novos nas bolsas têm um brilho dourado até fechar as bolsas; a janela de opções traz seus cartões um após o outro e seus menus se iluminam suavemente ao passar o mouse.",
})


-- 1.3.7: group members in the quest tracker tooltip
TomoMod_RegisterLocale("enUS", {
    ["ot_party"] = "Group",
    ["ot_party_on"] = "On this quest",
    ["ot_party_off"] = "Not on it",
})

TomoMod_RegisterLocale("frFR", {
    ["ot_party"] = "Groupe",
    ["ot_party_on"] = "A cette quête",
    ["ot_party_off"] = "Ne l'a pas",
})

TomoMod_RegisterLocale("deDE", {
    ["ot_party"] = "Gruppe",
    ["ot_party_on"] = "Hat die Quest",
    ["ot_party_off"] = "Hat sie nicht",
})

TomoMod_RegisterLocale("esES", {
    ["ot_party"] = "Grupo",
    ["ot_party_on"] = "Tiene la misión",
    ["ot_party_off"] = "No la tiene",
})

TomoMod_RegisterLocale("itIT", {
    ["ot_party"] = "Gruppo",
    ["ot_party_on"] = "Ha la missione",
    ["ot_party_off"] = "Non ce l'ha",
})

TomoMod_RegisterLocale("ptBR", {
    ["ot_party"] = "Grupo",
    ["ot_party_on"] = "Tem a missão",
    ["ot_party_off"] = "Não tem",
})


-- 1.3.7: quest progress shared in a group
TomoMod_RegisterLocale("enUS", {
    ["opt_ot_share"] = "Share my quest progress with my group (TMF users)",
    ["wn_137_party"] = "New - In a group, members running TMF share their quest progress: the quest tracker tooltip shows how far each one is (Wolf 3/8) or that the quest is ready to turn in. Option in the quest tracker settings.",
})

TomoMod_RegisterLocale("frFR", {
    ["opt_ot_share"] = "Partager ma progression de quêtes avec mon groupe (joueurs TMF)",
    ["wn_137_party"] = "Nouveau - En groupe, les membres qui ont TMF partagent leur progression : l'infobulle du suivi indique où en est chacun (Loup 3/8) ou que la quête est prête à rendre. Option dans les réglages du suivi des quêtes.",
})

TomoMod_RegisterLocale("deDE", {
    ["opt_ot_share"] = "Questfortschritt mit der Gruppe teilen (TMF-Nutzer)",
    ["wn_137_party"] = "Neu - In der Gruppe teilen Mitglieder mit TMF ihren Questfortschritt: Der Tooltip der Questverfolgung zeigt, wie weit jeder ist (Wolf 3/8) oder dass die Quest abgabebereit ist. Option in den Einstellungen der Questverfolgung.",
})

TomoMod_RegisterLocale("esES", {
    ["opt_ot_share"] = "Compartir mi progreso de misiones con el grupo (jugadores de TMF)",
    ["wn_137_party"] = "Nuevo - En grupo, los miembros con TMF comparten su progreso: la descripción del seguimiento muestra cómo va cada uno (Lobo 3/8) o que la misión está lista para entregar. Opción en los ajustes del seguimiento de misiones.",
})

TomoMod_RegisterLocale("itIT", {
    ["opt_ot_share"] = "Condividi i miei progressi delle missioni col gruppo (giocatori TMF)",
    ["wn_137_party"] = "Nuovo - In gruppo, i membri con TMF condividono i progressi: il suggerimento del tracciamento mostra a che punto è ognuno (Lupo 3/8) o che la missione è pronta da consegnare. Opzione nelle impostazioni del tracciamento.",
})

TomoMod_RegisterLocale("ptBR", {
    ["opt_ot_share"] = "Compartilhar meu progresso de missões com o grupo (jogadores do TMF)",
    ["wn_137_party"] = "Novo - Em grupo, os membros com TMF compartilham o progresso: a dica do rastreador mostra como cada um está (Lobo 3/8) ou que a missão está pronta para entregar. Opção nas configurações do rastreador de missões.",
})

