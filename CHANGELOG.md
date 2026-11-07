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
