## ####################################

## CHANGELOG 1.2.2

#### Class Trainer Reminder

- **New** - The spells of every Forever class trainer are built in (`TrainerData.lua`, 9 classes, levels 1-60). The panel now lists what you can learn from level 1, without a first visit, and checks each spell against your spellbook: a spell you already know, or a higher rank of it, is left out; a spell missed at an earlier level stays listed.
- **New** - A spell line opened by a talent, a race or a quest (first trained rank above rank 1, or a price far below the level's) is only listed once you know the spell, so other races' spells and untaken talents do not show.
- **Changed** - The list read at the trainer now refines the built-in one: real prices (reputation discounts) and the spells the built-in list cannot place (talent ranks with no spell ID, your race's spells). The "new spells are probably waiting" message only remains for a class without built-in data.

#### Graphics

- **New** - Adventure > Graphics page: nine optional CVars for a prettier picture, all off by default (each costs frames): `groundEffectDensity` 256, `groundEffectFade` 370, `groundEffectDist` 500, `ResampleAlwaysSharpen` 1, `lodObjectFadeScale` 200, `lodObjectCullSize` 8, `terrainLodDist` 1000, `reflectionMode` 3, `weatherDensity` 3. "Turn all on / off" buttons.
- **New** - Same mechanism as the camera options: the value found before the first change is kept and put back when unticked (your own setting, not a fixed default), ticked settings are applied again at each login, changes wait for the end of combat, and a CVar the client does not have is ignored.

#### World Map

- **New** - Adventure comforts > World map: "Show unexplored areas" draws the areas you have not explored yet on the world map, so you can see where to go before you have been there. Discovering an area (and its XP) is unchanged.
- **New** - "Tint unexplored areas" (on by default) and a tint colour tell them apart from the areas you already discovered.
- **New** - The areas come from the game's own WorldMapOverlay / WorldMapOverlayTile tables for Forever (84 maps, 1073 areas, `MapRevealData.lua`) and are cut into tiles the way the game cuts them. Blizzard's exploration pin is only hooked: explored areas are still drawn by the game.

#### Camp HUD

- **New** - Camp spell IDs built in (gathered from Wowhead): the "campfire nearby" aura, the two "welcoming campfire" auras (the minute by the fire), the shared camp cooldown, the three campfires and the eleven camp objects with their bonuses and tier 2 / 3 variants.
- **New** - The HUD also shows while the game's own "campfire nearby" aura is on you. A fire you light or point at keeps the HUD within its own radius (10 yd for a basic fire, 30 for companion and specialist fires).
- **New** - Camp bonuses are recognised by ID and listed first (in gold in the tooltip), even when you already had them on arrival; other buffs gained at the fire still follow. The camp auras themselves are no longer counted as bonuses.
- **New** - Outside the fire's minute, the HUD says when camp bonuses are ready again.
- **New** - Pointing at a camp object adds its bonus to the tooltip (name and the game's own description, in every language), with "Bonus active" or the camp cooldown left.
- **Changed** - The localized word "campfire" stays as a fallback for any fire the list does not know.

#### Chat

- **Fixed** - Whisper tabs (and any temporary chat window) never showed in the TomoMod tab row: their name was read from the saved chat windows, which only know the ten permanent ones. Blizzard's own tab then stayed visible behind the panel. Tab names now come from the native tab, so every docked window gets its TomoMod tab.
- **Fixed** - The open tab follows Blizzard's selection wherever it comes from (a click, closing the open tab, a whisper tab Blizzard selects), so TomoMod always shows the window you type into.
- **Changed** - An incoming whisper's new tab gets its tab and unread dot without pulling you off the tab you are reading, as in Blizzard's chat.
- **Changed** - Tabs follow the order of Blizzard's dock instead of the window number.
- **Fixed** - Closing a tab could bring back the Blizzard tab art of another tab behind the TomoMod row.
- **Fixed** - Chat windows created after login (numbered past 20, or after the first scan) were not mirrored, and their input box kept Blizzard's art.
- **New** - A "+" button after the last tab opens a menu of ready-made tabs: Guild (guild, officer, achievements), Group (party, raid, raid warning, instance), Whispers (whispers and Battle.net whispers), Trade (while you are in the channel) and Loot (loot, money, currency), plus a field to name any other tab. A preset whose tab is already open is not listed; when Blizzard's ten windows are all used, the menu says so. The new tab is created by Blizzard's own function and selected.
- **New** - When the tabs no longer fit even at their narrowest, the last ones go into a list behind a "more" button at the end of the row (the open tab always stays visible); the button shows a dot when a hidden tab has unread messages. Before, extra tabs ran past the edge of the panel.
- **Changed** - The "+", the "more" button and the unread dots are drawn with textures instead of characters, so a font without these symbols cannot turn them into boxes.

## ####################################

## CHANGELOG 1.2.1

#### Bag Space

- **New** - Adventure > Bag space: an animated banner in the Forever palette warns you when your bags are nearly full. It pops in, the bar and the percentage count up, and past the threshold the bag icon shakes and the border pulses (orange, red when full). Fades out after a few seconds; the timer waits while the mouse is over it.
- **New** - Shown at login (a few seconds after the loading screen, not after a /reload) when past the threshold, so you sell before heading out; and while playing, once when loot crosses the threshold and once more when the last slot goes. Re-arms when you free space. An alert raised in combat waits for the end of the fight.
- **New** - Free slots out of total, number of grey items and their vendor value. Only regular bags count: quivers, ammo pouches and soul bags cannot take your loot.
- **New** - Threshold (50 to 100 %, 90 by default), time on screen, size, sound, grey items on / off. Left click opens the bags, right click closes the banner. Movable from the move mode.

#### Class Trainer Reminder

- **New** - Adventure > Trainer reminder: on level up a small, discreet panel lists the spells waiting at your class trainer, with icon, name, rank and price, and the total (in red when you cannot afford it). Up to 8 rows, then "+ N more".
- **New** - The list is read at each visit to your class trainer, future spells included with their required level, and kept per character (TomoModForeverCharDB). After one visit every level up shows what just became available. Before the first visit, even levels show a short generic reminder (option).
- **Changed** - The trainer window filters are switched on for the read and put back as they were. Profession and pet trainers are ignored. The list follows each purchase, "Train all" included.
- **New** - Also at login when spells are waiting (option). Hides when you talk to the trainer, after a delay (0 = until the visit) or on right click. Waits for the end of combat. Movable from the move mode.

#### Dungeon Codex

- **New** - Adventure > Dungeon codex (`/codex`): the 35 dungeons of WoW Forever (28 instances, wings listed apart), levels 13 to 60, with the live Forever level ranges and the 9 new Forever dungeons marked.
- **New** - "My level" shows the dungeons for your level and those within two levels; "All" lists every one. Each entry gives the level range, zone, a warning when it lies in the other faction's land, the route for your faction step by step, and buttons to set a waypoint on the entrance or open the zone map.
- **New** - Entrances come from Forever guides when published, else from their Classic position (marked approximate). Krol'dok Stronghold, Blackmaw Hold and Shaper's Terrace are not placed yet.
- **New** - Calibration: `/codex set <key>` saves the entrance where you stand (profile override) and prints the line for the data file; `/codex here`, `/codex missing`, `/codex keys`, `/codex reset <key>`.
- **Changed** - Zones use the Classic map IDs; when one does not match on the client, the zone is looked up by name in the client's map tree.
- **New** - Optional chat line on level up when a dungeon comes within reach.

#### Pet Happiness

- **New** - Unit frames > Pet: a happiness icon for hunter pets beside the pet health bar, with Blizzard's happy / content / unhappy faces and a border in the matching colour. Blizzard's own face disappears with the default pet frame, so TomoMod now carries its own.
- **Changed** - On Forever `GetPetHappiness` does not exist and happiness is a secret pet power (`Enum.PowerType.Happiness`): the face is picked C-side through colour curves on `UnitPowerPercent`, so the value never reaches Lua. Classic thresholds (thirds of the gauge). Where `GetPetHappiness` is readable, it is used directly.
- **New** - The tooltip shows the pet's diet. The icon can be moved in move mode (shown as "happy" while unlocked) and turned off from the Pet page. `/tm pethappy` prints what the client exposes, to diagnose an empty icon.

#### Fixes

- **Fixed** - Group manager skin: clicking the side tab no longer raises ADDON_ACTION_BLOCKED in combat. The tab is now visual only and Blizzard's own toggle takes the click (secure path), its hit area widened to cover the tab.
- **Fixed** - Reputation bar and fast loot: their frame shared the global name of their module, so once the frame existed the options toggle (and, for the reputation bar, locking in move mode) stopped working. Each frame now has its own name.

## ####################################

## CHANGELOG 1.2.0

#### Mail (TomoMail)

- **New** - Comfort > Mail: TomoMail 2.2.0 is now part of TomoModForever, in the Forever palette (antique gold, aged bronze, off-white, Poppins). Mail window with Inbox and Send tabs, inbox filters (players, auction house, system) and "Take all", reader with reply / delete, contacts panel (your characters, guild A-Z with online status, recent recipients), send to every alt at once, recipient autocomplete and the reskin of Blizzard's mail frames.
- **Changed** - Uses the existing "Mail skin" switch (mailSkin.enabled), which had no module behind it until now. Changing it needs a /reload.
- **Changed** - Alts, recent recipients and display options live in their own SavedVariable (TomoModForeverMailDB), outside TomoMod profiles. `/tml` still opens the full mail settings.
- **Changed** - If the standalone TomoMail addon is enabled too, the module pauses with one chat line instead of skinning the mailbox twice. The Mythic+ keystone library TomoMail bundled is not included (unused by mail, and Forever has no keystones).
- **Changed** - Listens to MAIL_SHOW / MAIL_CLOSED as well as the interaction-manager events, so the mailbox opens the same on every client.

#### Flight Timer

- **New** - Adventure > Flight timer: a bar during flights with the destination and the time left, in the Forever palette. Movable from the move mode, size, width, drain or fill.
- **New** - Times are learned: the first flight on a route counts up ("measuring") and is saved on landing; after that the bar counts down. A route never flown whole but made of known pieces gets an estimate marked "≈".
- **New** - The flight map tooltip shows the duration of each reachable destination.
- **Changed** - Learned times live in their own account-wide SavedVariable (TomoModForeverFlightDB), shared by every character and untouched by profile swaps or resets. Frequent Flier flights are stored at normal speed. Early landings, summons, battleground ports and deaths are never saved. A /reload in flight keeps the bar.

#### Adventure Comforts

- **New** - Adventure > Adventure comforts: accept resurrections automatically, unless the caster is in combat (option), with an optional chat line.
- **New** - Hide the red error text and its voice, always or in combat only; important messages (bags full, quest log full, dead...) can be kept. UIErrorsFrame only stops listening to the event: no Blizzard script is replaced.
- **New** - "Train all" button at trainers: learns every skill you can afford, cheapest first; its tooltip shows the count and the cost. Hidden at pet trainers.
- **New** - Max camera zoom, no drunken haze, no grey death screen (CVars, in CVarOptimizer). Unticking puts back the value found before.

## ####################################

## CHANGELOG 1.1.3

#### Action Bar Skins

- **New** - Combat > Action bars: skins for Blizzard's own action bars, picked from live tiles that show each style: Forever (aged bronze), Pixel, Thick border, Shadow, Glass and Round. The choice applies to the real bars at once.
- **New** - Border colour from the skin, your class or a custom colour; keybind text on / off and size, macro names on / off, charge count size, icon zoom, and an option to hide the main bar's ornaments.
- **Changed** - Look only: no button is moved, resized, shown, hidden or given an attribute, so the secure action bars are never tainted. Position and size stay in the game's Edit Mode. New layers are created out of combat; a change made in combat lands when combat ends.
- **Changed** - The green "equipped item" outline and every Blizzard state (range, usability, cooldown, proc glow) are kept.
- **New** - When the bars show, per bar (bars 1 to 8, pet, stance): on mouseover, and / or in combat or with a target (either condition shows the bar). Hidden opacity and fade time are adjustable. Alpha only: keybinds keep working on a hidden bar, and every bar shows while Edit Mode or the move mode is open, or while a spell or item is on the cursor.

#### Waypoint

- **Changed** - Every part of the waypoint takes the WoW Forever palette: antique-gold ring, arrow and beam, aged-bronze centre dot, golden-yellow distance and off-white destination name. The off-screen arrow has new gold artwork with an off-white edge, and the beacon arrow a neutral version that follows the chosen colour.
- **Changed** - The beacon ring is half its old size (16 px by default, adjustable from 8) and the square in its centre is gone. Profiles on the old 32 px default switch to 16 once.
- **Changed** - Profiles still on the old cyan or teal stock colour switch to antique gold once; a colour you picked yourself is kept. A "Forever colours" button on the Waypoint page brings the palette back.

#### Objective Tracker

- **New** - A "-" / "+" button on the tracker header folds the whole tracker down to its header, and unfolds it again. Quest buckets and their headers are hidden while folded; the choice is saved. A scenario / delve block stays visible. With buckets turned off, Blizzard's own collapse is used.

#### Chat

- **Fixed** - Clicking a name or a link in the TomoMod chat raised a Blizzard error ("editBox" nil): the link is now handed to the real chat window, so whispering a name or linking into chat opens its input box.
- **Fixed** - A chat tab created by the player (new window, whisper tab) was not picked up by the TomoMod chat and sat behind it. New docked tabs now appear in the TomoMod tab row and are selected, as in Blizzard's chat. Closing or undocking a tab updates the panel too.

#### Bags

- **Fixed** - Middle-click on an item in the bags pins or unpins it again. The click is read without touching Blizzard's secure item button, so using items stays untainted. The item tooltip shows the hint.

#### Edit Mode

- **New** - TomoLayout can select every movable TomoMod element, not only the main frames: chat, bags, auras, frame anchors (loot frame and other Blizzard windows), tooltip, reputation bar, camp HUD, spell bars and so on. Click or drag one to select it; nudge arrows, Center X / Y and the grid magnet work on all of them. Such elements keep saving their position their own way, as if dropped by hand; Reset stays available for layout anchors only. Blizzard's own windows are never picked.
- **New** - Grid magnet: after a drag, the closest edge or centre of the element snaps onto a grid line when it lands within 10 units of one. "Magnet: ON / OFF" in the TomoLayout panel; it follows the grid (no snap when the grid is off). Hold Shift while releasing to place freely. Nudge buttons and plain clicks never snap.

#### Settings Window

- **Fixed** - Texts could overlap in a narrow window (reported on Comfort > Companion): checkbox labels now wrap onto a second line instead of running into the next column, slider labels stop before the value badge, info texts measure their height from the width they will really get, and resizing the window rebuilds the open page (cached pages rebuild when next opened).

## ####################################

## CHANGELOG 1.1.2

#### Healer Indicators

- **New** - Group & Raid > Healer indicators: the healer editor of the old Party & Raid Studio is back as a regular page. Pick Party or Raid and a class, tick the spells to show (heals over time, shields, beacons, markers, externals) and drag each icon onto a live preview of the cell.
- **New** - Per spell: icon size, anchor point and X / Y offset, applied live. "Reset its position", "Starter layout" and "Reset this class" are available, with "Healer specialization only" and "Remaining duration" switches.
- **New** - The Party and Raid pages have a "Place my heals on the frame..." button that opens the editor on the matching frame type.
- **Changed** - Only Priest, Druid, Paladin and Shaman are offered: Monk and Evoker were removed from the editor and from the indicator engine, as they do not exist on Forever.
- **Changed** - Old links to the healer studio now open this page.
- **Fixed** - The Healer indicators page could fail to build ("Font not set") when a spell icon was shown on the preview.

#### Party Frames

- **Removed** - The enemy arena frames, with their module, mover, layout anchor and option. There are no arenas on Forever; their saved settings are dropped once. This also ends the "action blocked" errors they raised when laid out in combat.
- **Removed** - The class cooldown icons (interrupt and battle-rez) on party frames, with their module, options, installer step and preset entries. Their saved settings are dropped once. The raid battle-rez counter is unchanged.
- **Fixed** - Party (5) > Name and icons: the text size slider only changed the preview. The real frames now follow the font and size live, like the raid frames.

#### Nameplates

- **New** - Target arrows card: show or hide the arrows on each side of the target, five styles (Classic, Chevron, Triangle, Double, Glowing), size, gap, colour, and placement around the name or around the health bar. The four new arrow textures are original.

#### Waypoint

- **New** - Comfort > Waypoint: a master switch, plus separate switches for the in-world beacon and the tracking arrow at the screen edge. A part that is off gives Blizzard's own marker back.
- **Fixed** - The waypoint's "enabled" setting was saved but never read; turning it off now hides the TomoMod waypoint.

#### Player Frame

- **Changed** - The Blizzard aura frame options (manage, buffs, debuffs) moved from Interface > General to My frames > Player.

#### Settings Window

- **New** - The settings window pages and the Adventure modules (Camp HUD, Edge XP bar, Missing buffs) are translated into German, Spanish, Italian and Portuguese (BR), in addition to French and English. Spanish (Mexico) uses the Spanish texts and Portuguese (Portugal) the Brazilian ones.
- **Changed** - The Edge XP bar groups thousands with a dot in German, Spanish, Italian and Portuguese.
- **Changed** - When a page refreshes itself (for example when selecting a spell on the healer page), it keeps its scroll position and no longer replays the page glide.

## ####################################

## CHANGELOG 1.1.1

#### Camp HUD

- **Fixed** - The camp HUD only appeared while sitting. The client puts its "campfire" aura on the player only when seated, and the HUD relied on that aura alone. It now appears as soon as you reach the fire.
- **Fixed** - The camp HUD stayed on screen after walking away from the fire, as long as the one-minute rest aura was still running. It now hides about 2 seconds after you leave.
- **Changed** - The camp spot is recorded from four signals: sitting at the fire, pointing at it with the mouse, a fire in soft-interact range, or lighting one yourself. The HUD stays while you are within about 12 yards of that spot (20 yards when the fire was only pointed at from a distance) and follows the distance twice a second.
- **Changed** - Hovering the Campfire spell on an action bar or in the spellbook does not count as being at a fire.
- **Changed** - In instances, where the client hides positions, the HUD falls back to the sitting aura as before.

#### Release Notes And Version Metadata

- **Changed** - Every `.toc` declares version 1.1.1.
- **New** - The What's New popup has a 1.1.1 entry, translated into all six languages (enUS, frFR, deDE, esES, itIT, ptBR).

## ####################################

## CHANGELOG 1.1.0

#### Settings Window (GUI v2)

- **New** - The `/tm` window was rebuilt from scratch. It opens at 780 x 600 (was 1240 x 820), is resizable, and docks to the right edge of the screen so the frames being edited stay visible. "Dock" switches between the right and left edge; dragging the title bar frees it.
- **New** - Every setting is applied to the live UI as it changes, with an "Applied" confirmation. Settings that resize protected frames wait for the end of combat and say so.
- **New** - See-through mode: the window fades while a slider is dragged and while Alt is held, and (optional, on by default) while the mouse is away from it.
- **New** - "Show me": every frame page has a button that outlines the real frame on screen, and pulses it automatically when the page opens. Hovering a page in the sidebar does the same.
- **New** - Live previews while a page is open: five stand-in party members when you are solo, a 20-member raid grid outside a raid, and castbars without casting.
- **New** - Simple / expert mode. Simple mode keeps each page to the essentials; expert mode adds text placement, enemy buffs, size by raid size, spark styles, battle-rez counter and the rest.
- **New** - Search covers every page and every option: a result opens its page, switches to the right tab, scrolls to the setting and highlights it.
- **New** - Home page written for new players: "What do you want to do?" tiles, module switches in plain words, ready-made styles and help.
- **Changed** - The sidebar is grouped into collapsible sections: My frames, Party & raid, Combat, Adventure, Interface, Comfort and Tools.

#### Studios Removed

- **Removed** - `TomoModForever_AstralForge`, `TomoModForever_GroupStudio`, `TomoModForever_ResourceCastStudio` and `TomoModForever_CDStudio`, with the shared Studio window (`Core/Forge/ForgeStudio.lua`). Delete these four folders from `Interface\AddOns`.
- **Changed** - Their settings are now regular pages: Player, Target, Target of target, Focus, Pet, Boss, Shared style, Castbars, Resources, Party, Raid, Nameplates and Spell bars.
- **Changed** - The EditMode gear, `/tm` shortcuts and every old link open the matching page instead of a Studio.
- **Changed** - Saved element positions and healer layouts keep working. Editing healer layouts per class is no longer offered.

#### Player Frame

- **Changed** - The player mana / energy bar is 10 px high by default (was a 2 px line). Profiles still on 4 px or less move to 10 px once; any other value is kept.
- **Changed** - The power bar text now scales with the bar height.
- **New** - Player page: "Where should my resource go?" switches between the player frame and the middle of the screen.

#### Adventure (new modules, written for TomoModForever)

- **New** - Camp HUD: near a campfire a round HUD appears; click it to sit. The ring fills while the fire's timed aura runs and the buffs gained at the camp are shown around it. Detection uses aura names, so it works in every client language.
- **New** - Edge XP bar: a full-width bar on the top or bottom edge with rested segment, 10 % ticks, level badge, "+xp" on each gain, and a hover panel with XP per hour, time to next level and the quests ready to turn in. Shows the watched reputation at max level. Modes: always, after a gain, or on hover.
- **New** - Edge XP bar: the level badge is centered on the bar by default, with a left / center / right option.
- **New** - Edge XP bar: Blizzard's own XP bar is hidden while it is on (option, on by default). It is hidden by alpha and re-hidden after every Blizzard layout, so no taint.
- **New** - Missing buffs: an icon appears when one of your class self-buffs, auras, aspects or weapon enchants is not up; click it to cast. Each rule can be turned off and custom buffs can be added by name.
- **Removed** - The old Leveling Bar (Comfort > Leveling) is replaced by the edge XP bar. Its settings are dropped once.

#### Animations

- **New** - Window: pages glide in, the window slides in from its docked edge, the "Applied" toast pops, and Home tiles shine on hover. One switch on Home turns them off.
- **New** - Unit frames: a red damage trail drains behind the health bar after a hit (eased by the client, works with hidden health values).
- **New** - Player frame: breathes red under a low-health threshold (30 % by default, adjustable).
- **New** - Castbars: the bar shakes when a cast is interrupted, with a test button.
- **New** - Camp HUD: animated flames drawn for TomoModForever (16-frame sprite sheet).
- **New** - XP bar: on level up a golden light runs along the bar, the level number pops, the badge flashes and "Level N!" rises in the middle of the screen, with a test button.
- **New** - Missing buffs: icons nudge every few seconds with a red halo. Only textures are animated, never the secure buttons, so it is combat-safe.
- **Fixed** - The level-up animation no longer tears the badge border into long golden lines.

#### Release Notes And Version Metadata

- **Changed** - Every `.toc` declares version 1.1.0.
- **New** - The What's New popup has a 1.1.0 entry, translated into all six languages (enUS, frFR, deDE, esES, itIT, ptBR). The names of the three new modules are translated into the same six languages.

## ####################################

## CHANGELOG 1.0.1

#### Minimap

- **Changed** - The day/night cycle dial that Blizzard draws around the minimap (`UI-HUD-Minimap-DayCycle`) is now hidden when the TomoModForever minimap is enabled.
- **Changed** - The native zone name above the minimap (`MinimapCluster.ZoneTextButton`) and its header background (`MinimapCluster.BorderTop`) are now hidden. The zone is still shown by the TomoModForever info panel.
- **Fixed** - The zone text stayed visible because the info panel only looked for the old `MinimapZoneTextButton` name, which the current client no longer uses.
- **Fixed** - These elements stay hidden after loading screens and zone changes, even when Blizzard tries to show them again. They no longer react to the mouse.

#### Player Power Bar

- **New** - AstralForge: a "Show power on the player frame" checkbox in the player's Display section switches between the power bar in the player frame and the centered resource bar.
- **Fixed** - Characters without a specialization (low level) had no power bar at all: the centered resource bar was never built without a spec, and the player frame skipped its own bar because the centered one was expected. The centered primary power bar is now built without a spec (class power such as Holy Power still waits for one).
- **Fixed** - The player frame no longer hides its power bar for the centered one when the Resource Bars module is disabled.
- **Fixed** - The player frame power bar (mana, energy, rage) did not update when power was spent or regenerated, while the same bar on the target frame did. The unit frames now refresh the power bar on their own power events (`UNIT_POWER_UPDATE`, `UNIT_POWER_FREQUENT`, `UNIT_MAXPOWER`, `UNIT_DISPLAYPOWER`) instead of relying only on oUF.
- **Fixed** - Turning the power bar on or off (AstralForge checkbox, power height between 0 and above, or the "Centered primary power" option in ResourceCastStudio) now applies immediately instead of requiring a `/reload`. ResourceCastStudio was calling a `RebuildUnit` function that did not exist. The change is skipped in combat, where the frame is protected.
- **Fixed** - The player frame no longer keeps an empty gap where the power bar would be when power is shown on the centered bar.

#### Release Notes And Version Metadata

- **Changed** - Every `.toc` declares version 1.0.1.
- **New** - The What's New popup has a 1.0.1 entry, translated into all six languages (enUS, frFR, deDE, esES, itIT, ptBR). The new AstralForge checkbox is translated into the same six languages.

## ####################################

## CHANGELOG 1.0.0

#### TomoModForever — First Release

- **New** - TomoModForever is a streamlined edition of TomoMod built for WoW: Forever. It installs as its own addon (`TomoModForever`) with its own sub-addons (`TomoModForever_Options`, `TomoModForever_AstralForge`, `TomoModForever_CDStudio`, `TomoModForever_GroupStudio`, `TomoModForever_ResourceCastStudio`).
- **Changed** - Settings live in their own saved variables (`TomoModForeverDB`, `TomoModForeverCharDB`, `TomoModForeverDamageMeterDB`, `TomoModForeverCompanionDB`), so the addon starts from clean defaults and never touches a TomoMod profile. Do not enable TomoMod and TomoModForever at the same time.

#### Removed Modules

- **Removed** - Mythic+: the Mythic+ Studio sub-addon, tracker, TomoScore scoreboard, keystone sharing and roulette, teleport menu and the InfoPanel keystone shortcut.
- **Removed** - Interface: the owned action bars, extra-button movers and totem bar.
- **Removed** - Housing (editor clock).
- **Removed** - Comfort: auction recipe tracker, tooltip IDs, class reminder, prey tracker, compass, consumable tracker, gear advisor (and the bag upgrade marker), loot browser (and its chat sidebar button), profession helper, character skin, skyriding and world quests.
- **Changed** - Their options pages, slash commands (`/tm key`, `/tm score`, `/tm loot`, `/tm compass`, `/tm mhub`, `/tm skyride`, `/tm prof`), Layout-mode movers, installer and preset entries, module manifest entries and defaults were removed with them.

#### Forever Palette

- **New** - The interface adopts a WoW: Forever palette: aged bronze for borders and ornaments, antique gold for frames, golden yellow for titles and off-white for text.

#### Release Notes And Version Metadata

- **Changed** - Every `.toc` declares version 1.0.0 and interface 16001. The What's New history starts over at 1.0.0.
