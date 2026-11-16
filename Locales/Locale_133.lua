-- TomoModForever 1.3.3 release notes.

TomoMod_RegisterLocale("enUS", {
    ["wn_133_auras"] = "Fixed - Animation look: your buffs and debuffs and those of your target now show beside the halo. In 1.3.2 the aura blocks were never built on Forever.",
    ["wn_133_look"] = "Changed - Animation look: the aura icons are now built like those of the TMF unit frames and nameplates: dark backdrop, debuff border in the dispel colour, remaining time inside the icon, tooltip on hover. The icons are also larger and more spaced.",
    ["wn_133_level"] = "New - Animation look: the target's level is shown before its name, in the difficulty colour, with Elite or Rare when it applies and a red \"??\" for bosses.",
    ["wn_133_options"] = "New - Animation look: its main settings are now in Frames > Shared style when the look is chosen (theme, HUD size, idle opacity, embers, values), with two new sliders: text size and aura size, applied live.",
    ["wn_133_debug"] = "Changed - /tmf anim debug also says whether the TMF aura builder is available and which aura block could not be built.",
    ["wn_133_clicks"] = "Changed - Animation look: left and right clicks only work on the health arcs (player, target, pet) and the target of target. Clicking a resource arc no longer targets you.",
    ["wn_133_bank"] = "Fixed - Opening your personal bank no longer raises a \"PurchaseBankTab\" error when the TomoMod bags are on.",
    ["wn_133_bagtoggle"] = "Fixed - The Bags switch on the Home page now really turns the TomoMod bags on and off and keeps its state after a /reload.",
    ["wn_133_questslot"] = "Fixed - Bags: moving a quest item no longer leaves its gold border on the empty slot it came from.",
    ["wn_133_questdone"] = "Fixed - Bags: an item a quest objective asks for keeps its gold border and stays off the throw-away list once the objective is complete, until you hand in the quest.",
})

TomoMod_RegisterLocale("frFR", {
    ["wn_133_auras"] = "Corrigé - Style Animation : tes buffs et débuffs et ceux de ta cible s'affichent enfin de chaque côté du halo. En 1.3.2, les blocs d'auras n'étaient jamais construits sur Forever.",
    ["wn_133_look"] = "Modifié - Style Animation : les icônes d'auras sont maintenant construites comme celles des cadres d'unité et des barres de nom TMF : fond sombre, bordure des débuffs à la couleur de dissipation, temps restant dans l'icône, infobulle au survol. Les icônes sont aussi plus grandes et plus espacées.",
    ["wn_133_level"] = "Nouveau - Style Animation : le niveau de la cible s'affiche devant son nom, à la couleur de difficulté, avec Élite ou Rare le cas échéant et un \"??\" rouge pour les boss.",
    ["wn_133_options"] = "Nouveau - Style Animation : ses principaux réglages sont maintenant dans Cadres > Style commun quand le style est choisi (thème, taille du HUD, opacité hors combat, braises, valeurs), avec deux nouveaux curseurs : taille des textes et taille des auras, appliqués en direct.",
    ["wn_133_debug"] = "Modifié - /tmf anim debug indique aussi si le constructeur d'auras TMF est disponible et quel bloc d'auras n'a pas pu être construit.",
    ["wn_133_clicks"] = "Modifié - Style Animation : les clics gauche et droit ne fonctionnent plus que sur les arcs de vie (joueur, cible, familier) et la cible de la cible. Cliquer sur un arc de ressource ne te cible plus.",
    ["wn_133_bank"] = "Corrigé - Ouvrir ta banque personnelle ne provoque plus d'erreur « PurchaseBankTab » quand les sacs TomoMod sont activés.",
    ["wn_133_bagtoggle"] = "Corrigé - L'interrupteur Sacs de la page d'accueil active et désactive vraiment les sacs TomoMod et garde son état après un /reload.",
    ["wn_133_questslot"] = "Corrigé - Sacs : déplacer un objet de quête ne laisse plus son contour doré sur la case vide qu'il a quittée.",
    ["wn_133_questdone"] = "Corrigé - Sacs : un objet demandé par un objectif de quête garde son contour doré et ne passe plus dans la liste « à jeter » une fois l'objectif terminé, jusqu'à ce que tu rendes la quête.",
})

TomoMod_RegisterLocale("deDE", {
    ["wn_133_auras"] = "Behoben - Animationsstil: deine Buffs und Debuffs und die deines Ziels erscheinen jetzt neben dem Halo. In 1.3.2 wurden die Aurablöcke auf Forever nie erstellt.",
    ["wn_133_look"] = "Geändert - Animationsstil: die Aurensymbole werden jetzt wie die der TMF-Einheitenfenster und Namensplaketten erstellt: dunkler Hintergrund, Debuff-Rahmen in der Bannfarbe, Restzeit im Symbol, Tooltip beim Überfahren. Die Symbole sind außerdem größer und weiter auseinander.",
    ["wn_133_level"] = "Neu - Animationsstil: die Stufe des Ziels steht vor seinem Namen, in der Schwierigkeitsfarbe, mit \"Elite\" oder \"Rare\" falls zutreffend und einem roten \"??\" für Bosse.",
    ["wn_133_options"] = "Neu - Animationsstil: seine wichtigsten Einstellungen stehen jetzt unter Fenster > Gemeinsamer Stil, wenn der Stil gewählt ist (Thema, HUD-Größe, Deckkraft außerhalb des Kampfes, Glut, Werte), mit zwei neuen Reglern: Textgröße und Aurengröße, sofort übernommen.",
    ["wn_133_debug"] = "Geändert - /tmf anim debug zeigt auch, ob der TMF-Aurenbaukasten verfügbar ist und welcher Aurablock nicht erstellt werden konnte.",
    ["wn_133_clicks"] = "Geändert - Animationsstil: Links- und Rechtsklick funktionieren nur noch auf den Gesundheitsbögen (Spieler, Ziel, Begleiter) und beim Ziel des Ziels. Ein Klick auf einen Ressourcenbogen wählt dich nicht mehr als Ziel aus.",
    ["wn_133_bank"] = "Behoben - Das Öffnen deiner persönlichen Bank löst keinen \"PurchaseBankTab\"-Fehler mehr aus, wenn die TomoMod-Taschen aktiv sind.",
    ["wn_133_bagtoggle"] = "Behoben - Der Taschen-Schalter auf der Startseite schaltet die TomoMod-Taschen jetzt wirklich ein und aus und behält seinen Zustand nach einem /reload.",
    ["wn_133_questslot"] = "Behoben - Taschen: Wenn du einen Questgegenstand verschiebst, bleibt sein goldener Rahmen nicht mehr auf dem leeren Platz zurück.",
    ["wn_133_questdone"] = "Behoben - Taschen: ein Gegenstand, den ein Questziel verlangt, behält seinen goldenen Rahmen und kommt nicht auf die Wegwerfliste, sobald das Ziel erfüllt ist, bis du die Quest abgibst.",
})

TomoMod_RegisterLocale("esES", {
    ["wn_133_auras"] = "Corregido - Estilo Animación: tus beneficios y perjuicios y los de tu objetivo aparecen por fin junto al halo. En la 1.3.2 los bloques de auras nunca se creaban en Forever.",
    ["wn_133_look"] = "Cambiado - Estilo Animación: los iconos de auras se crean ahora como los de los marcos de unidad y las placas de nombre TMF: fondo oscuro, borde de los perjuicios con el color de disipación, tiempo restante dentro del icono, descripción al pasar el ratón. Los iconos son además más grandes y más espaciados.",
    ["wn_133_level"] = "Nuevo - Estilo Animación: el nivel del objetivo aparece delante de su nombre, con el color de dificultad, con \"Elite\" o \"Rare\" cuando corresponde y un \"??\" rojo para los jefes.",
    ["wn_133_options"] = "Nuevo - Estilo Animación: sus ajustes principales están ahora en Marcos > Estilo común cuando el estilo está elegido (tema, tamaño del HUD, opacidad fuera de combate, brasas, valores), con dos nuevos controles: tamaño de los textos y tamaño de las auras, aplicados al momento.",
    ["wn_133_debug"] = "Cambiado - /tmf anim debug indica también si el constructor de auras TMF está disponible y qué bloque de auras no se pudo crear.",
    ["wn_133_clicks"] = "Cambiado - Estilo Animación: los clics izquierdo y derecho solo funcionan en los arcos de salud (jugador, objetivo, mascota) y en el objetivo del objetivo. Hacer clic en un arco de recurso ya no te selecciona.",
    ["wn_133_bank"] = "Corregido - Abrir tu banco personal ya no provoca un error \"PurchaseBankTab\" cuando las bolsas de TomoMod están activadas.",
    ["wn_133_bagtoggle"] = "Corregido - El interruptor Bolsas de la página de inicio ahora activa y desactiva de verdad las bolsas de TomoMod y conserva su estado tras un /reload.",
    ["wn_133_questslot"] = "Corregido - Bolsas: mover un objeto de misión ya no deja su borde dorado en la casilla vacía que ocupaba.",
    ["wn_133_questdone"] = "Corregido - Bolsas: un objeto que pide un objetivo de misión conserva su borde dorado y ya no pasa a la lista de objetos para tirar al completar el objetivo, hasta que entregues la misión.",
})

TomoMod_RegisterLocale("itIT", {
    ["wn_133_auras"] = "Corretto - Stile Animazione: i tuoi benefici e penalità e quelli del bersaglio ora appaiono accanto all'alone. Nella 1.3.2 i blocchi delle aure non venivano mai creati su Forever.",
    ["wn_133_look"] = "Modificato - Stile Animazione: le icone delle aure sono ora create come quelle dei riquadri unità e delle targhette TMF: sfondo scuro, bordo delle penalità nel colore di dissoluzione, tempo rimanente dentro l'icona, tooltip al passaggio del mouse. Le icone sono anche più grandi e più distanziate.",
    ["wn_133_level"] = "Nuovo - Stile Animazione: il livello del bersaglio appare prima del nome, nel colore di difficoltà, con \"Elite\" o \"Rare\" quando serve e un \"??\" rosso per i boss.",
    ["wn_133_options"] = "Nuovo - Stile Animazione: le sue impostazioni principali sono ora in Riquadri > Stile comune quando lo stile è scelto (tema, dimensione dell'HUD, opacità fuori combattimento, braci, valori), con due nuovi cursori: dimensione dei testi e dimensione delle aure, applicati subito.",
    ["wn_133_debug"] = "Modificato - /tmf anim debug indica anche se il costruttore di aure TMF è disponibile e quale blocco di aure non è stato possibile creare.",
    ["wn_133_clicks"] = "Modificato - Stile Animazione: i clic sinistro e destro funzionano solo sugli archi della salute (giocatore, bersaglio, famiglio) e sul bersaglio del bersaglio. Cliccare su un arco di risorsa non ti seleziona più.",
    ["wn_133_bank"] = "Corretto - Aprire la tua banca personale non provoca più un errore \"PurchaseBankTab\" quando le borse di TomoMod sono attive.",
    ["wn_133_bagtoggle"] = "Corretto - L'interruttore Borse della pagina iniziale ora attiva e disattiva davvero le borse di TomoMod e mantiene il suo stato dopo un /reload.",
    ["wn_133_questslot"] = "Corretto - Borse: spostare un oggetto della missione non lascia più il suo bordo dorato sulla casella vuota da cui proviene.",
    ["wn_133_questdone"] = "Corretto - Borse: un oggetto richiesto da un obiettivo di missione mantiene il bordo dorato e non finisce più nella lista da buttare quando l'obiettivo è completato, finché non consegni la missione.",
})

TomoMod_RegisterLocale("ptBR", {
    ["wn_133_auras"] = "Corrigido - Estilo Animação: seus bônus e penalidades e os do seu alvo agora aparecem ao lado do halo. Na 1.3.2 os blocos de auras nunca eram criados no Forever.",
    ["wn_133_look"] = "Alterado - Estilo Animação: os ícones de auras agora são criados como os dos quadros de unidade e placas de nome TMF: fundo escuro, borda das penalidades na cor de dissipação, tempo restante dentro do ícone, dica ao passar o mouse. Os ícones também estão maiores e mais espaçados.",
    ["wn_133_level"] = "Novo - Estilo Animação: o nível do alvo aparece antes do nome, na cor de dificuldade, com \"Elite\" ou \"Rare\" quando for o caso e um \"??\" vermelho para chefes.",
    ["wn_133_options"] = "Novo - Estilo Animação: seus principais ajustes agora ficam em Quadros > Estilo comum quando o estilo está escolhido (tema, tamanho do HUD, opacidade fora de combate, brasas, valores), com dois novos controles: tamanho dos textos e tamanho das auras, aplicados na hora.",
    ["wn_133_debug"] = "Alterado - /tmf anim debug também mostra se o construtor de auras TMF está disponível e qual bloco de auras não pôde ser criado.",
    ["wn_133_clicks"] = "Alterado - Estilo Animação: os cliques esquerdo e direito só funcionam nos arcos de vida (jogador, alvo, ajudante) e no alvo do alvo. Clicar num arco de recurso não seleciona mais você.",
    ["wn_133_bank"] = "Corrigido - Abrir seu banco pessoal não causa mais um erro \"PurchaseBankTab\" quando as bolsas do TomoMod estão ativadas.",
    ["wn_133_bagtoggle"] = "Corrigido - O interruptor Bolsas da página inicial agora liga e desliga de verdade as bolsas do TomoMod e mantém o estado após um /reload.",
    ["wn_133_questslot"] = "Corrigido - Bolsas: mover um item de missão não deixa mais a borda dourada no espaço vazio de onde ele saiu.",
    ["wn_133_questdone"] = "Corrigido - Bolsas: um item pedido por um objetivo de missão mantém a borda dourada e não vai mais para a lista de descarte quando o objetivo é concluído, até você entregar a missão.",
})
