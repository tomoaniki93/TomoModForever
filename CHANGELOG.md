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
