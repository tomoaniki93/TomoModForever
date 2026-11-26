-- TomoModForever 1.4.0: colour of the Forever patterns (chat, minimap, meter)
-- and the What's new entries 1.4.0 and 1.4.0b (Core/WhatsNew.lua).
-- No "+", guillemets or bullets in these strings: the font may not carry them.

TomoMod_RegisterLocale("enUS", {
    ["opt_forever_color"] = "Pattern colour",
    ["tint_forever"] = "Forever (bronze and gold)", ["tint_gold"] = "Gold", ["tint_black"] = "Black", ["tint_class"] = "Class colour",
    ["border_gold"] = "Gold",

    -- What's new 1.4.0
    ["wn_140_colour"] = "New - Colour of the Forever patterns: the moulding, corners, plates and gems of the chat, the minimap and the damage meter can be Forever (bronze and gold), Gold, Black or your class colour. Skins, Chat, Appearance, and the minimap and damage meter options.",
    ["wn_140_look"] = "New - Installer step Your look: pick the unit frame style (TMF, Forever, Animation) and the colour of the patterns with a live preview. The colour shows at once behind the installer. /tmf install.",
    ["wn_140_mapkey"] = "New - In a dungeon or raid that has a TMF map, the map key (M) opens that map on your floor; press it again to close it. The World map button of the window opens the game's map. The quest log (L) is never taken. Adventure, Codex, Settings.",
    ["wn_140_simple"] = "Changed - Simple mode of the settings window: General and Skins keep the essentials, the fine tuning waits for expert mode (one button at the bottom of each page). Diagnostics, Graphics and New ranks are listed in expert mode only. The cards no longer rise into place when a page opens.",
    ["wn_140_power"] = "Fixed - The centred power bar of the resource bars now glides and leaves a pale trail when mana or energy is spent, like the power bar of the unit frames.",
    ["wn_140_dialogue"] = "Fixed - Quest dialogue: no more Lua error on quests that reward money, and the choices are no longer drawn over the end of a long text.",
    ["wn_140_fixes"] = "Fixed - Nameplate settings changed in combat are applied when the combat ends. The game's Lua error window works again after Diagnostics gives it back. The Stockade entrance is at its real place in the codex. Resource glow uses less CPU when nothing is targeted.",

    -- What's new 1.4.0b
    ["wn_140b_reyes"] = "New - Maps of the 9 new Forever dungeons, drawn by Santiago Reyes (Atlas de Azeroth: Forever, sreyesmaps.com) and used with his permission: Hall of Thanes, Ruins of Lordaeron, Excavation Site, Dalaran, Drowned City, Krol'dok, Alcaz Prison, Blackmaw Hold and Shaper's Terrace, with bosses, notes and passages. Every codex dungeon now has a map, and the map key opens it inside these dungeons too.",
    ["wn_140b_wailing"] = "Fixed - Wailing Caverns map: TMF now shows the whole original cave, so Lord Pythas, Skum and the Deviate Faerie Dragon stand in their rooms instead of on empty parchment.",
    ["wn_140b_pins"] = "Fixed - Dungeon maps: pins that covered each other (Zul'Farrak and others) are pushed apart; zoom in to see them back on their exact spots.",
})
TomoMod_RegisterLocale("frFR", {
    ["opt_forever_color"] = "Couleur des motifs",
    ["tint_forever"] = "Forever (bronze et or)", ["tint_gold"] = "Or", ["tint_black"] = "Noir", ["tint_class"] = "Couleur de classe",
    ["border_gold"] = "Or",

    -- Nouveautés 1.4.0
    ["wn_140_colour"] = "Nouveau - Couleur des motifs Forever : les moulures, coins, plaques et gemmes du chat, de la minimap et du compteur de dégâts peuvent être Forever (bronze et or), Or, Noir ou à la couleur de ta classe. Apparence, Chat, Apparence, et les options de la minimap et du compteur.",
    ["wn_140_look"] = "Nouveau - Étape Ton visuel dans l'assistant d'installation : choisis le style des cadres d'unité (TMF, Forever, Animation) et la couleur des motifs avec un aperçu en direct. La couleur s'affiche tout de suite derrière l'assistant. /tmf install.",
    ["wn_140_mapkey"] = "Nouveau - Dans un donjon ou un raid qui a une carte TMF, la touche de la carte (M) ouvre cette carte à ton étage ; appuie encore pour la fermer. Le bouton Carte du monde de la fenêtre ouvre la carte du jeu. Le journal de quêtes (L) n'est jamais intercepté. Aventure, Codex, Réglages.",
    ["wn_140_simple"] = "Modifié - Mode simple de la fenêtre d'options : Général et Apparence gardent l'essentiel, les réglages fins attendent le mode expert (un bouton en bas de chaque page). Diagnostic, Graphismes et Nouveaux rangs ne sont listés qu'en mode expert. Les cartes ne montent plus en place à l'ouverture d'une page.",
    ["wn_140_power"] = "Corrigé - La barre de ressource centrale glisse maintenant et laisse une traînée pâle quand la mana ou l'énergie est dépensée, comme la barre de ressource des cadres d'unité.",
    ["wn_140_dialogue"] = "Corrigé - Dialogues de quête : plus d'erreur Lua sur les quêtes qui donnent de l'argent, et les choix ne recouvrent plus la fin d'un long texte.",
    ["wn_140_fixes"] = "Corrigé - Les réglages des barres de nom changés en combat s'appliquent à la fin du combat. La fenêtre d'erreurs Lua du jeu remarche après que le Diagnostic la rend. L'entrée de la Prison est à sa vraie place dans le codex. La surbrillance des ressources consomme moins quand rien n'est ciblé.",

    -- Nouveautés 1.4.0b
    ["wn_140b_reyes"] = "Nouveau - Cartes des 9 nouveaux donjons de Forever, dessinées par Santiago Reyes (Atlas de Azeroth: Forever, sreyesmaps.com) et utilisées avec son accord : Salle des Thanes, Ruines de Lordaeron, Site de fouilles, Dalaran, Cité engloutie, Krol'dok, Prison d'Alcaz, Bastion de Blackmaw et Terrasse du Façonneur, avec boss, notes et passages. Chaque donjon du codex a maintenant sa carte, et la touche de la carte l'ouvre aussi dans ces donjons.",
    ["wn_140b_wailing"] = "Corrigé - Carte des Cavernes des lamentations : TMF affiche maintenant la grotte originale entière, le seigneur Pythas, Skum et le Dragon féerique déviant sont dans leurs salles et non plus sur du parchemin vide.",
    ["wn_140b_pins"] = "Corrigé - Cartes des donjons : les repères qui se recouvraient (Zul'Farrak et d'autres) sont écartés ; zoome pour les retrouver à leur place exacte.",
})
TomoMod_RegisterLocale("deDE", {
    ["opt_forever_color"] = "Farbe der Muster",
    ["tint_forever"] = "Forever (Bronze und Gold)", ["tint_gold"] = "Gold", ["tint_black"] = "Schwarz", ["tint_class"] = "Klassenfarbe",
    ["border_gold"] = "Gold",

    -- Neuigkeiten 1.4.0
    ["wn_140_colour"] = "Neu - Farbe der Forever-Muster: Leisten, Ecken, Plaketten und Edelsteine von Chat, Minimap und Schadensmesser können Forever (Bronze und Gold), Gold, Schwarz oder deine Klassenfarbe sein. Skins, Chat, Aussehen, sowie die Optionen von Minimap und Schadensmesser.",
    ["wn_140_look"] = "Neu - Installationsschritt Dein Aussehen: Wähle den Stil der Einheitenfenster (TMF, Forever, Animation) und die Farbe der Muster mit Live-Vorschau. Die Farbe erscheint sofort hinter dem Assistenten. /tmf install.",
    ["wn_140_mapkey"] = "Neu - In einem Dungeon oder Schlachtzug mit TMF-Karte öffnet die Kartentaste (M) diese Karte auf deiner Ebene; erneut drücken schließt sie. Der Knopf Weltkarte im Fenster öffnet die Karte des Spiels. Das Questlog (L) wird nie abgefangen. Abenteuer, Kodex, Einstellungen.",
    ["wn_140_simple"] = "Geändert - Einfacher Modus des Optionsfensters: Allgemein und Skins zeigen das Wesentliche, die Feineinstellungen warten auf den Expertenmodus (ein Knopf unten auf jeder Seite). Diagnose, Grafik und Neue Ränge erscheinen nur im Expertenmodus. Die Karten steigen beim Öffnen einer Seite nicht mehr ein.",
    ["wn_140_power"] = "Behoben - Die zentrierte Ressourcenleiste gleitet jetzt und hinterlässt eine blasse Spur, wenn Mana oder Energie verbraucht wird, wie die Ressourcenleiste der Einheitenfenster.",
    ["wn_140_dialogue"] = "Behoben - Questdialog: kein Lua-Fehler mehr bei Quests mit Geldbelohnung, und die Auswahlen überdecken nicht mehr das Ende eines langen Textes.",
    ["wn_140_fixes"] = "Behoben - Im Kampf geänderte Einstellungen der Namensplaketten werden nach dem Kampf angewendet. Das Lua-Fehlerfenster des Spiels funktioniert wieder, nachdem die Diagnose es zurückgibt. Der Eingang des Verlieses ist im Kodex an seinem echten Ort. Das Leuchten der Ressourcen braucht weniger CPU, wenn nichts anvisiert ist.",

    -- Neuigkeiten 1.4.0b
    ["wn_140b_reyes"] = "Neu - Karten der 9 neuen Forever-Dungeons, gezeichnet von Santiago Reyes (Atlas de Azeroth: Forever, sreyesmaps.com) und mit seiner Erlaubnis verwendet: Halle der Thane, Ruinen von Lordaeron, Ausgrabungsstätte, Dalaran, Versunkene Stadt, Krol'dok, Gefängnis von Alcaz, Blackmaw-Feste und Terrasse des Formers, mit Bossen, Notizen und Übergängen. Jeder Dungeon im Kodex hat jetzt eine Karte, und die Kartentaste öffnet sie auch in diesen Dungeons.",
    ["wn_140b_wailing"] = "Behoben - Karte der Höhlen des Wehklagens: TMF zeigt jetzt die ganze ursprüngliche Höhle, Lord Pythas, Skum und der Deviatfeendrache stehen in ihren Räumen statt auf leerem Pergament.",
    ["wn_140b_pins"] = "Behoben - Dungeonkarten: Markierungen, die sich verdeckten (Zul'Farrak und andere), werden auseinandergeschoben; hineinzoomen zeigt sie wieder an ihrer genauen Stelle.",
})
TomoMod_RegisterLocale("esES", {
    ["opt_forever_color"] = "Color de los motivos",
    ["tint_forever"] = "Forever (bronce y oro)", ["tint_gold"] = "Oro", ["tint_black"] = "Negro", ["tint_class"] = "Color de clase",
    ["border_gold"] = "Oro",

    -- Novedades 1.4.0
    ["wn_140_colour"] = "Nuevo - Color de los motivos Forever: las molduras, esquinas, placas y gemas del chat, el minimapa y el medidor de daño pueden ser Forever (bronce y oro), Oro, Negro o el color de tu clase. Aspecto, Chat, Apariencia, y las opciones del minimapa y del medidor.",
    ["wn_140_look"] = "Nuevo - Paso Tu aspecto en el asistente de instalación: elige el estilo de los marcos de unidad (TMF, Forever, Animation) y el color de los motivos con vista previa en directo. El color se ve al instante detrás del asistente. /tmf install.",
    ["wn_140_mapkey"] = "Nuevo - En una mazmorra o banda con mapa TMF, la tecla del mapa (M) abre ese mapa en tu piso; púlsala otra vez para cerrarlo. El botón Mapa del mundo de la ventana abre el mapa del juego. El registro de misiones (L) nunca se intercepta. Aventura, Códice, Ajustes.",
    ["wn_140_simple"] = "Cambiado - Modo simple de la ventana de opciones: General y Aspecto muestran lo esencial, los ajustes finos esperan al modo experto (un botón al final de cada página). Diagnóstico, Gráficos y Nuevos rangos solo aparecen en modo experto. Las tarjetas ya no suben a su sitio al abrir una página.",
    ["wn_140_power"] = "Corregido - La barra de recurso centrada ahora se desliza y deja un rastro pálido al gastar maná o energía, como la barra de recurso de los marcos de unidad.",
    ["wn_140_dialogue"] = "Corregido - Diálogo de misión: ya no hay error Lua en las misiones que dan dinero, y las opciones ya no tapan el final de un texto largo.",
    ["wn_140_fixes"] = "Corregido - Los ajustes de placas de nombre cambiados en combate se aplican al terminar el combate. La ventana de errores Lua del juego vuelve a funcionar cuando el Diagnóstico la devuelve. La entrada de las Mazmorras está en su sitio real en el códice. El brillo de recursos consume menos cuando no hay nada seleccionado.",

    -- Novedades 1.4.0b
    ["wn_140b_reyes"] = "Nuevo - Mapas de las 9 nuevas mazmorras de Forever, dibujados por Santiago Reyes (Atlas de Azeroth: Forever, sreyesmaps.com) y usados con su permiso: Sala de los Thanes, Ruinas de Lordaeron, Excavación, Dalaran, Ciudad Sumergida, Krol'dok, Prisión de Alcaz, Bastión de Blackmaw y Terraza del Modelador, con jefes, notas y pasajes. Cada mazmorra del códice tiene ahora su mapa, y la tecla del mapa lo abre también dentro de estas mazmorras.",
    ["wn_140b_wailing"] = "Corregido - Mapa de las Cuevas de los Lamentos: TMF muestra ahora la cueva original completa, Lord Pythas, Skum y el Dragón Feérico Descarriado están en sus salas y no sobre pergamino vacío.",
    ["wn_140b_pins"] = "Corregido - Mapas de mazmorras: los marcadores que se tapaban (Zul'Farrak y otros) se separan; acerca el zoom para verlos en su sitio exacto.",
})
TomoMod_RegisterLocale("itIT", {
    ["opt_forever_color"] = "Colore dei motivi",
    ["tint_forever"] = "Forever (bronzo e oro)", ["tint_gold"] = "Oro", ["tint_black"] = "Nero", ["tint_class"] = "Colore della classe",
    ["border_gold"] = "Oro",

    -- Novità 1.4.0
    ["wn_140_colour"] = "Nuovo - Colore dei motivi Forever: modanature, angoli, placche e gemme di chat, minimappa e misuratore dei danni possono essere Forever (bronzo e oro), Oro, Nero o il colore della tua classe. Aspetto, Chat, Aspetto, e le opzioni di minimappa e misuratore.",
    ["wn_140_look"] = "Nuovo - Passo Il tuo aspetto nell'installazione guidata: scegli lo stile dei riquadri unità (TMF, Forever, Animation) e il colore dei motivi con anteprima dal vivo. Il colore appare subito dietro la procedura. /tmf install.",
    ["wn_140_mapkey"] = "Nuovo - In una spedizione o incursione con mappa TMF, il tasto della mappa (M) apre quella mappa al tuo piano; premilo di nuovo per chiuderla. Il pulsante Mappa del mondo della finestra apre la mappa del gioco. Il registro missioni (L) non viene mai intercettato. Avventura, Codice, Impostazioni.",
    ["wn_140_simple"] = "Modificato - Modalità semplice della finestra delle opzioni: Generale e Aspetto mostrano l'essenziale, le regolazioni fini aspettano la modalità esperto (un pulsante in fondo a ogni pagina). Diagnostica, Grafica e Nuovi ranghi compaiono solo in modalità esperto. Le schede non salgono più in posizione all'apertura di una pagina.",
    ["wn_140_power"] = "Corretto - La barra della risorsa centrale ora scorre e lascia una scia chiara quando mana o energia vengono spesi, come la barra della risorsa dei riquadri unità.",
    ["wn_140_dialogue"] = "Corretto - Dialogo delle missioni: niente più errore Lua sulle missioni che danno denaro, e le scelte non coprono più la fine di un testo lungo.",
    ["wn_140_fixes"] = "Corretto - Le impostazioni delle barre dei nomi cambiate in combattimento si applicano a fine combattimento. La finestra degli errori Lua del gioco funziona di nuovo dopo che la Diagnostica la restituisce. L'ingresso della Prigione è al suo vero posto nel codice. Il bagliore delle risorse consuma meno quando nulla è selezionato.",

    -- Novità 1.4.0b
    ["wn_140b_reyes"] = "Nuovo - Mappe delle 9 nuove spedizioni di Forever, disegnate da Santiago Reyes (Atlas de Azeroth: Forever, sreyesmaps.com) e usate con il suo permesso: Sala dei Thane, Rovine di Lordaeron, Sito di Scavo, Dalaran, Città Sommersa, Krol'dok, Prigione di Alcaz, Roccaforte di Blackmaw e Terrazza del Plasmatore, con boss, note e passaggi. Ogni spedizione del codice ha ora la sua mappa, e il tasto della mappa la apre anche dentro queste spedizioni.",
    ["wn_140b_wailing"] = "Corretto - Mappa delle Caverne dei Lamenti: TMF mostra ora l'intera grotta originale, Lord Pythas, Skum e il Draco Fatato Deviato stanno nelle loro sale e non su pergamena vuota.",
    ["wn_140b_pins"] = "Corretto - Mappe delle spedizioni: i segnalini che si coprivano (Zul'Farrak e altri) vengono allontanati; ingrandisci per vederli al loro posto esatto.",
})
TomoMod_RegisterLocale("ptBR", {
    ["opt_forever_color"] = "Cor dos padrões",
    ["tint_forever"] = "Forever (bronze e ouro)", ["tint_gold"] = "Ouro", ["tint_black"] = "Preto", ["tint_class"] = "Cor da classe",
    ["border_gold"] = "Ouro",

    -- Novidades 1.4.0
    ["wn_140_colour"] = "Novo - Cor dos padrões Forever: molduras, cantos, placas e gemas do chat, do minimapa e do medidor de dano podem ser Forever (bronze e ouro), Ouro, Preto ou a cor da sua classe. Aparência, Chat, Aparência, e as opções do minimapa e do medidor.",
    ["wn_140_look"] = "Novo - Etapa Seu visual no assistente de instalação: escolha o estilo dos quadros de unidade (TMF, Forever, Animation) e a cor dos padrões com prévia ao vivo. A cor aparece na hora atrás do assistente. /tmf install.",
    ["wn_140_mapkey"] = "Novo - Numa masmorra ou raide com mapa TMF, a tecla do mapa (M) abre esse mapa no seu andar; aperte de novo para fechar. O botão Mapa-múndi da janela abre o mapa do jogo. O registro de missões (L) nunca é interceptado. Aventura, Códice, Configurações.",
    ["wn_140_simple"] = "Alterado - Modo simples da janela de opções: Geral e Aparência mostram o essencial, os ajustes finos esperam o modo especialista (um botão no fim de cada página). Diagnóstico, Gráficos e Novos níveis só aparecem no modo especialista. Os cartões não sobem mais para o lugar ao abrir uma página.",
    ["wn_140_power"] = "Corrigido - A barra de recurso central agora desliza e deixa um rastro claro quando mana ou energia é gasta, como a barra de recurso dos quadros de unidade.",
    ["wn_140_dialogue"] = "Corrigido - Diálogo de missão: sem mais erro Lua nas missões que dão dinheiro, e as escolhas não cobrem mais o fim de um texto longo.",
    ["wn_140_fixes"] = "Corrigido - Os ajustes das placas de nome alterados em combate são aplicados ao fim do combate. A janela de erros Lua do jogo volta a funcionar depois que o Diagnóstico a devolve. A entrada do Cárcere está no lugar certo no códice. O brilho de recursos consome menos quando nada está selecionado.",

    -- Novidades 1.4.0b
    ["wn_140b_reyes"] = "Novo - Mapas das 9 novas masmorras de Forever, desenhados por Santiago Reyes (Atlas de Azeroth: Forever, sreyesmaps.com) e usados com a permissão dele: Salão dos Thanes, Ruínas de Lordaeron, Sítio de Escavação, Dalaran, Cidade Submersa, Krol'dok, Prisão de Alcaz, Fortaleza Blackmaw e Terraço do Moldador, com chefes, notas e passagens. Cada masmorra do códice agora tem seu mapa, e a tecla do mapa também o abre dentro dessas masmorras.",
    ["wn_140b_wailing"] = "Corrigido - Mapa das Cavernas Lamuriantes: o TMF agora mostra a caverna original inteira, Lorde Pythas, Skum e o Dragão Feérico Desviante ficam nas suas salas e não sobre pergaminho vazio.",
    ["wn_140b_pins"] = "Corrigido - Mapas de masmorras: marcadores que se cobriam (Zul'Farrak e outros) são afastados; aproxime o zoom para vê-los no lugar exato.",
})
