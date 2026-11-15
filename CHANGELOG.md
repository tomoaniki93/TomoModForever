## ####################################

## CHANGELOG 1.3.1

#### Resource bars: class power without a specialization

- **Fixed** - Rogues had no combo points in the resource bars (player report). On Forever the client often reports no specialization (low level), and `CLASS_RESOURCES` was looked up by spec index only, so nothing was built. The spec is now read with `C_SpecializationInfo.GetSpecialization` (global `GetSpecialization` fallback), and classes whose class power is the same in every spec get a `default` entry used when no spec is reported: Rogue (combo points), Paladin (Holy Power), Warlock (Soul Shards), Death Knight (runes), Evoker (Essence). Spec-specific powers (Chi, Arcane Charges, Icicles, Soul Fragments, Maelstrom Weapon, Tip of the Spear, Feral combo points) still need a spec.
- **Fixed** - Combo points read as 0 on Forever, where they are held on the target. `ReadPointPower` falls back to `GetComboPoints("player", "target")` when `UnitPower` reports 0, and to a cap of 5 when `UnitPowerMax` reports 0 (it was forced to 1, which drew a single point). Used by the segment, bar and band displays.
- **Fixed** - Changing target now refreshes the class power (combo points follow the target); it only refreshed the bar's alpha before.

#### Resource bars: missing resources

- **New** - A point-based class power whose cap is 0 for the character (a resource Forever does not have) is no longer drawn as one empty point: it is hidden. `UNIT_MAXPOWER` rebuilds the display if the resource appears later.

## ####################################

## CHANGELOG 1.3.0

#### Unit frames: shaman totems

- **Fixed** - Shamans did not see their totems with TomoMod's unit frames (player report). Blizzard's `TotemFrame` is a child of `PlayerFrame` (`PlayerBottomManagedFrameTemplate`, laid out by the player frame's bottom container) and disappeared when oUF hid the Blizzard player frame; moving it out is fragile, the container re-anchors it on every layout.
- **New** - `Modules/Interface/UnitFrames/Units/TotemBar.lua`: TomoMod's own totem bar, shamans only and only while TomoMod's player frame is on. One fixed spot per element in Blizzard's shaman order (`SHAMAN_TOTEM_PRIORITIES`: earth, fire, water, air), icon, reverse cooldown sweep and time left (`GetTotemInfo`, `GetTotemTimeLeft`, secret values skipped), `GameTooltip:SetTotem` on hover. Right click dismisses the totem: `DestroyTotem` is protected, so each spot is a `SecureActionButtonTemplate` (`type2 = "destroytotem"`, `totem-slot`); an empty spot goes transparent rather than hidden (secure frames cannot be hidden in combat). Under the player frame by default, movable with `/tmf move` (position kept in `unitFrames.totems.position`). Frames > Player, shamans only: show, icon size, spacing, empty spots, back under the player frame.

#### Adventure: missing buffs

- **Fixed** - Druids always had an "Omen of Clarity" icon among the missing buffs. On Forever Omen of Clarity is a passive spell: it leaves no aura on the player, so the check could never be satisfied. The `druid_omen` rule is removed from `Modules/QOL/Forever/MissingBuffs.lua`; Mark of the Wild / Gift of the Wild is still checked.
- **Fixed** - A buff refreshed in combat still showed as missing once out of combat (player report). An aura cast or refreshed in combat can keep a secret name after combat ends, and the scan skipped secret names, so the buff looked absent. The scan now falls back to the aura's spell id, then asks the client by name (`C_UnitAuras.GetAuraDataBySpellName`, `AuraUtil.FindAuraByName` fallback), using only whether an aura is found and never one of its fields. Same for the player's own buffs.

## ####################################

## CHANGELOG 1.2.9

#### Unit frames: "Forever" look

- **New** - `Modules/Interface/UnitFrames/Units/ForeverStyle.lua`: a second look for the unit frames, `unitFrames.style` = `"tmf"` (default) or `"forever"`, chosen in Frames > Shared style. Same engine and settings; the file only dresses the frames: a name strip above the health bar (class colour for players, reaction colour for NPCs, toned down; name in gold), health and power texts centred, bronze outer and gold inner border, gold separators between the rows, and a level medallion outside the frame (left of the player, right of the target and focus; difficulty colour, "??" for skull levels). Target of target and pet get a thinner strip and no medallion. No portraits.
- **Changed** - After the first in-game test (it looked like the TMF frames plus a strip, at the TMF sizes, and the player strip stayed empty with "show name" off): the Forever look now has its own compact sizes through `UF.ForeverSettings` (a proxy read through to the unit settings, so the saved TMF sizes are untouched): 170 x 48 for player, target and focus (strip 14, health 16, power 9), 110 x 34 for target of target and pet (12 / 10 / 4); a unit with its power bar off keeps it off. Dark background with a 1px gold border and a bronze edge outside, bars inset by 3px and 2px dark gaps between the rows instead of separators; the TMF info bar is hidden; health text forced to "current / max" and power "current / max" on the bar (`UF.ForeverPowerText`); the strip always shows the name (`UpdateName` hands over to `UF.ForeverUpdate` before its "show name" check); medallion half over the frame edge.
- **New** - Optional round portrait, Forever look only (`unitFrames.foreverPortrait`, off; player request): a 2D portrait (`SetPortraitTexture`) in a bronze and gold ring against the frame, left of the player, right of the target and focus; the level medallion then sits on its lower outer edge. Refreshed on target / focus change, `UNIT_PORTRAIT_UPDATE` and `UNIT_MODEL_CHANGED`. Not drawn on target of target and pet, never in the TMF look.
- **New** - Forever sizes per frame (the sliders of the Player / Target... pages only set the TMF look): `unitFrames.foreverSizes[unit] = { width, name, health, power }` over the defaults, fonts following the strip and health heights. Frames > Shared style shows a "Forever sizes" card when the Forever look is chosen (choosing the look rebuilds the page): a frame selector (player, target, focus, target of target, pet), four sliders and a "default sizes" button. The unit pages say where the Forever sizes are while that look is on.
- **Fixed** - The name strip looked split in two bands: the darker half-height shade had a hard edge. It is now a smooth vertical gradient over the whole strip, with a faint 1px highlight on top.
- **Changed** - `UF.ApplyVisuals` calls `UF.ForeverPre` before the AstralForge registry (room for the strip: the health bar moves down, the frame grows) and `UF.ForeverPost` after it (name into the strip, texts centred, decoration). `UpdateName` / `UpdateLevel` show the name alone and leave the level to the medallion in that look. Switching look needs no `/reload` (out of combat, like every frame refresh); back to "TMF", the name and level go back to the registry. The configuration previews keep the TMF look.

#### Dungeon codex: Loot tab

- **New** - `Modules/QOL/Forever/DungeonLootData.lua`: the dungeon loot of ForeverLoot 1.12.1 by Ethan Elliott (data of 2026-11-04, built by ForeverLoot from Wowhead, wowtbc.gg, Mobalytics and cMaNGOS), **used with the author's permission**, credited in the file header and in the tab. Generated by `Tools/build_loot.py`: dungeon bosses only, mapped onto the codex keys; Scarlet Monastery, Dire Maul, Stratholme and Blackrock Spire are split by wing (event bosses and trash go to every wing). 35 codex entries, 297 boss entries, 1 407 items, 142 KB (ForeverLoot's whole data file is 1.7 MB). An offline fallback (quality, icon, English name and type) shows until the client knows an item.
- **New** - Codex, third button "Loot (n)": opens the loot in a window of its own (440 x 500) in place of the codex, with a scroll bar usable with the mouse alone (arrow buttons that repeat when held, click on the track for a page, draggable thumb; the wheel works too) and a "Back" button that returns to the codex where the window was; `/codex` closes it, Escape too. Boss headers (event / rare / summoned... tags), then their items: icon, name in the quality colour, slot and type, all from `C_Item` in the client's language. Hover: item tooltip; shift-click: link; ctrl-click: dressing room (`HandleModifiedItemClick`). Refreshed on `GET_ITEM_INFO_RECEIVED`. The new Forever dungeons with no known loot yet say so.
- **New** - "For me" switch (`dungeonCodex.lootMine`, off): keeps what the class actually uses, not all it can wear. Armour: its own type only (cloth for priest, mage, warlock; leather for rogue, druid; leather then mail at 40 for hunter, shaman; mail then plate at 40 for warrior, paladin), judged at the higher of the player's level and the item's required level (the dungeon's minimum while the item is unknown). Shields and relics for the classes that use them, the class's weapons (`GetItemInfoInstant` subclasses). Rings, necks, trinkets, cloaks and non-equipment always stay.
- **New** - "Loot: boss (dungeon)" on item tooltips (`TooltipDataProcessor`, `dungeonCodex.lootTooltip`, on); stands down when ForeverLoot is loaded, which shows its own.

#### Quest tracker

- **New** - Unfinished quests (the "Quests" bucket) are grouped by zone, under small gold sub-headers with their count (player request: two Elwynn Forest quests and four Westfall quests were mixed). The zone is the quest log header above the quest (`C_QuestLog.GetInfo` `isHeader`, `GetQuestLogTitle` fallback), so zones follow the order of the log; a quest found under no header goes to "Other". Ready-to-turn-in quests keep their own bucket, collapsed or folded buckets are left as they were. Option "Group quests by zone" (`objectiveTracker.groupByZone`, on), bucket mode only.
- **New** - Each zone folds and unfolds on a click, like the buckets (`objectiveTracker.zonesCollapsed`, by zone name, kept across sessions). Plus / minus drawn with Blizzard's textures. The Show hooks of the blocks and of their item buttons now ask `IsBlockCollapsed` (bucket or zone folded), so Blizzard's re-Show cannot bring a folded zone back, in combat neither (alpha until the deferred pass).

#### Camp HUD

- **Changed** - The ring is now drawn with round textures instead of `Ring.tga`: a thin gold ring (2px, bronze edge) around a full dark ember disc with a warm heart, so the square fire icon no longer shows behind the flames (its mask did not take on every client). The icon, when the animated flames are off, is cut round with `SetPortraitToTexture` (mask as fallback); with the flames on it stays hidden unless it could be cut round.

#### Bags

- **Fixed** - The apostrophe fix of `Triage.lua` ("Chair croustillante d'araignée" not recognised as wanted by the quest log) was missing from the published 1.2.8; it ships now.

## ####################################

## CHANGELOG 1.2.8

#### Adventure: new spell ranks

- **New** - `Modules/QOL/Forever/SpellRanks.lua` (inspired by AishCore's "New spell ranks", written for TomoMod). On Forever a rank bought at the trainer does not reach the action bars. Per spell name, over the 180 action slots, the highest rank present is compared with the highest rank in the spellbook (`C_SpellBook`, rank from the subtext). Only the slots holding that highest present rank are offered: a lower rank placed beside it (downranking for mana) is never touched, unlike a "replace every lower rank" pass.
- **New** - Spellbook: a gold arrow (gentle bob) on the new rank. Left click replaces the outdated slots (`C_SpellBook.PickupSpellBookItem`, `PlaceAction`, `ClearCursor`; the slot is re-checked first, the cursor must hold a spell) and the icon flies to the button it lands on; right click keeps that rank (`TomoModForeverCharDB.spellRanksKeep`). Hooks `SpellBookItemMixin.UpdateVisuals` / `ClearSpellData` instead of polling the open book. Hidden when AishCore is loaded (its own arrow does the same).
- **New** - Outdated buttons pulse gold on Blizzard's bars, Bartender4, Dominos and any LibActionButton bar (own overlay frames on UIParent, nothing added to the secure buttons). One chat line when the trainer window closes.
- **New** - Mode "auto": the update runs when the trainer window closes, after combat if it closes in one. Nothing is ever replaced in combat. Macros and click casting are not handled.
- **New** - `/tmf ranks` (`/tmf rangs`): status and list; `update` (`maj`) updates everything; `reset` forgets the kept ranks. Options under Adventure > New ranks.

#### Bags: quest items

- **New** - Blizzard's quest art in TomoMod's bags (player report: Blizzard outlines quest items so they are not sold). `TEXTURE_ITEM_QUEST_BORDER` on quest items (`isQuestItem`, `GetContainerItemQuestInfo`) and on any item an unfinished "item" objective of the quest log asks for, matched by name, even when the game does not flag it (cloth, meat...); `TEXTURE_ITEM_QUEST_BANG` on items that start a quest you do not have. The slot edge turns gold too. Bag settings: "Mark quest items" (`bagsV4.slots.questMarks`, on).
- **New** - Bag tooltip: "Quest: <title> (3/8)" for an item the quest log asks for; "Quest item: keep it" on other quest items while a merchant is open.
- **Changed** - `Triage.lua`'s quest log reading now keeps the quest title and the objective's counts (`TR.QuestNeed`, `TR.QuestStatus`) and refreshes the bags when the log changes.

#### Mail

- **Fixed** - Alts tab still empty in 1.2.7. Forever gives every character a first name and a surname ("Abla Stone"); only the pair is unique, and players often keep the same first name on every alt. `UnitName("player")` returns the two halves as two values and only the first was kept, so every alt sharing a first name replaced the others in `alts`, then was hidden as "ourselves": one entry, hidden, empty list. Mail to an alt also went to the first name alone, which is not an address on Forever. Same reading as Postbox and BlazeMail.
- **Changed** - Alt entries are now `Full Name|Ruleset|Faction|Level|Class|GUID`. One entry per GUID or full name. The ruleset (`C_GameRules`: PvE, PvP, RP, RPPvP, Hardcore, or the suffix of the realm text) replaces the realm text, which drifts on Forever; alts of another ruleset or faction are not listed (mail cannot cross them).
- **Migration** - First-name-only entries saved before 1.2.8 are dropped once (`altsVersion = 2`): each character is saved again, with its full name, at its next login. Per-character profiles move from a "Name" or "Name-Realm" key to the full name.
- **Fixed** - "Name-Surname" was cut at the hyphen as if it were "Name-Realm" (send box, recents, guild list, sender class colours). On Forever the first two words are kept and joined by the game's separator (`Constants.CharacterNameSeparatorConsts`); the autocomplete finds "Abla Stone" from "abla-stone".
- **Fixed** - The guild list and autocomplete hid every member sharing the player's first name.
- **Changed** - `/tml alts` also prints both halves given by `UnitName`, the full name, the ruleset and each entry's GUID.

#### Quest tracker

- **Fixed** - In combat the tracker jumped between a few quests and all of them (two player reports, since 1.2.7). The 4000 of room given to `ObjectiveTrackerFrame` was refused under `InCombatLockdown()`, yet Blizzard keeps calling `UpdateHeight` during fights (`OnShow`, and `ManageFramePositions` on shapeshift, pet bar, vehicle...): the height went back to ~800, the blocks that no longer fit were released, and every quest came back after combat. A re-anchor from the `SetPoint` hook in combat could also grow the 4000-high frame around its saved anchor, as in the bug fixed in 1.2.7. The container is not protected (`ApplyPosition` already re-anchors it in combat), so lifting, dropping and pinning now also run in combat, in the same tick as Blizzard's `SetHeight`; they still wait for the end of the fight if `IsProtected()` ever says otherwise.
- **Fixed** - "Max quests displayed" was not applied in combat (`Hide()` waits for the lockdown to lift) and a Blizzard update re-showed every block. Extra blocks are now kept at alpha 0 until the deferred layout.

#### Questie

- **New** - Side by side with Questie (it has a Forever build, `Questie_Forever.toc`). `Core/Compat.lua` reads Questie's AceDB profile live: `QuestieOwnsTracker()` (`trackerEnabled`, default on), `QuestieAutoAccept()` (`autoAccept.enabled`), `QuestieAutoComplete()` (`autocomplete`).
- **New** - Quest tracker: while Questie's tracker is on (it hides `ObjectiveTrackerFrame`), TomoMod installs nothing on Blizzard's tracker: no skin, no extra room, no anchor. Switched on later, the skin and the room are undone once; switched off later, a `/reload` brings TomoMod's tracker back. One chat line.
- **New** - Automatic questing: where Questie's auto accept or auto turn-in is on, the matching part of TomoMod's automation (gossip selection included) stands down, read on every event. One chat line per session.

## ####################################

## CHANGELOG 1.2.7

#### Mail

- **Fixed** - Alts tab empty (player report: a main and two alts, none listed). Forever's realm text can change between sessions (the cluster part of "CAMWOW EU4 Realm 7 PvE"), and the Alts tab, the autocomplete and "send to all alts" kept only the characters whose saved realm text matched exactly. Alts are now matched by name (not ourselves) and faction; one entry per name, so a realm change no longer lists a character twice.
- **Fixed** - A character whose level, class or faction was not known yet when saved was dropped; the save is now retried, and repeated on level up and at logout.
- **Fixed** - Per-character mail settings and recents were keyed "Name-Realm", so a realm change gave the character a fresh, empty profile. They are keyed by name now; an older "Name-Realm" profile is taken over.
- **Fixed** - Guild tab empty when the mailbox opens: the roster was read right after asking the server for it, and the empty result was cached for 10 seconds. An empty read is no longer cached, and the list refreshes on `GUILD_ROSTER_UPDATE`. Offline members are listed (unless "Online only" is ticked): the guild panel's "Show offline members" box is ticked while the mailbox is open and put back afterwards.
- **Fixed** - Recent tab never filled: the name was read from the send box once the letter was sent, when Blizzard has already cleared it. The name given to `SendMail()` is used. Names are trimmed and lose any "-Realm" suffix; recent names take their class colour when known.
- **Fixed** - Guild letter headers broke on names starting with an accented letter.
- **New** - `/tml alts`: what the module sees for this character and the saved character list.

#### Adventure comforts: quest items

- **New** - Lootable quest items sparkle (inspired by ForeverLootSparkles). Sets `outlineModeShowLootEffectWhenDisabled` to 1 through the comfort CVars of `CVarOptimizer.lua` (`cameraFx.lootSparkles`, on by default). The value found before is kept in `cameraFx.orig` and put back when unticked.
- **New** - Graphics presets reset that CVar: `CVAR_UPDATE` on `graphicsQuality`, `raidGraphicsQuality` or the CVar itself re-applies the comfort CVars one second later, and a second pass runs 5 seconds after entering the world (account-synced settings can arrive late). In combat it waits for the fight to end, as before.
- **Note** - The outline mode (`graphicsOutlineMode`, and with it the Self Highlight outline) is not touched. Unticking only takes effect after restarting the game (`/reload` is not enough); a chat line says so.

#### Quest tracker

- **Fixed** - Not every quest showed, even with "Max quests displayed" at 0 (player report). Blizzard's tracker only builds the blocks that fit in `ObjectiveTrackerFrame`'s own height (`CanFitBlock` against `GetAvailableHeight`); that height is the space down to the bottom of the screen in the default Edit Mode place, else the Edit Mode "Height" slider (400 to 1000). Blocks that did not fit were never created, so the bucket layout had nothing to place. The container now gets 4000 of room after every `UpdateHeight` and on each layout pass, out of combat. It is not mouse-enabled and TomoMod draws its own panel, so nothing changes on screen.
- **Fixed** - The tracker disappeared with that change: it grew around its saved anchor (often `RIGHT` or `CENTER`), which pushed its top edge, and the panel attached to it, above the screen. The top edge is now pinned (re-anchored by `TOPLEFT`) before the room is added, and positions are applied and saved at Blizzard's own height, as before. A position saved while the tracker was broken may need "Reset position".

## ####################################

## CHANGELOG 1.2.6

#### Commands

- **Changed** - The main command is `/tmf` (TomoMod Forever's initials) instead of `/tm`; every sub-command follows (`/tmf layout`, `/tmf vol`, `/tmf tri`, `/tmf camp`, `/tmf niveaux`...). `/tm` and `/tomomod` stay as aliases, so habits and older notes keep working. Every help text, tooltip and chat message now says `/tmf`.

#### Dungeon Codex: where quests start

- **New** - Dungeon quest tooltips say where the quest starts (giver, zone and coordinates, or the item that starts it), who to turn it in to, and the quests to do first, each ticked when done (player report: Hall of Thanes had a quest that only appears after a chain started by an item). Data for the 349 dungeon quests, the 270 elite quests and every quest of their chains, 1086 quests in all (`DungeonQuestPlaces.lua`), read from each quest's foreverchanges.pro page by `Tools/parse_quest_pages.py` and generated by `Tools/gen_questplaces.py`.
- **New** - A quest whose chain is not done is shown greyed with "Needs: <first missing quest>" and listed after the quests you can take.
- **New** - Click a dungeon quest for a waypoint: to the first quest of its chain still to do, else to its giver; when an item starts the quest, to the NPC it is brought to. 231 dungeon quests have their giver's position, 253 their turn-in's.
- **Fixed** - Elite tab: an elite quest showed "To take" while a quest of the same name was in the quest log (player report: The Defias Brotherhood). Chains of same-named quests are several quests: the log held step 1, the elite quest is step 6. Elite quests now get their chains too (174 of them, 272 more chain quests read), and a quest whose chain has a step in the log shows "Chain in progress: step n of m"; clicking it leads to where that step is turned in.
- **Changed** - In chain lists, a step in the quest log shows the quest log icon.
- **Note** - Where an item that starts a quest drops is not in the data (the site describes it for only 4 of 36 such quests).

#### World Map

- **Fixed** - Zone level ranges never showed (player report). Blizzard's map label keeps its text in `labelInfoByType[type].name`; 1.2.5 read a `.label` field that does not exist, so it never found a name to extend. The label is now rewritten with Blizzard's own fields (name, description, colours, texture). Blizzard adds the range itself when `C_Map.GetMapLevels` gives one; Forever gives none, so the ranges come from TomoMod's Classic table (Forever's new zones have no range yet).
- **Changed** - If the map label is not built yet at login, the hook is tried again when the world map opens.
- **New** - `/tm maplevels` (or `/tm niveaux`): whether the label is hooked, and the levels of the open map and its zones (game / table).

## ####################################

## CHANGELOG 1.2.5

#### Party Frames: mana

- **Changed** - The resource bar showed only for members with the HEALER role, which is rarely set on Forever, so most groups saw no mana at all. New "Resource bar for" setting: every mana user (default), healers only, or everyone (rage, energy...).
- **New** - Mana in % on the health bar, bottom right: blue, orange under 40%, red under 20%; hidden for disconnected or dead members. Druids switch with their form (`UNIT_DISPLAYPOWER`).

#### World Map: zone levels

- **New** - Hovering a zone on a continent map adds its level range to the name, coloured like quests for your level (red too high, orange right for you, green easy, grey too low); on a zone map, the zone's own range follows the area name. Ranges from the game (`C_Map.GetMapLevels`), a Classic table as fallback. Idea from OpenMap (MIT). Option "Zone levels on the map" on the Adventure comforts page, on by default.

#### Chat

- **New** - Sidebar button (open book icon, a texture) that opens the dungeon codex; added after "Copy" in existing layouts, can be hidden in the chat settings.

#### Dungeon Codex: elite quests

- **New** - "Elites" tab next to "My level" and "All": the zones with elite quests for your faction, by level (level range of their elite quests, coloured like the dungeons). 270 elite quests over 42 zones (`EliteQuestData.lua`), the quests foreverchanges.pro marks Elite on its zone pages, dungeons and raids left out; generated by `Tools/gen_elitequests.py` from `Tools/elite_quests.txt`. Thousand Needles and Mount Hyjal could not be read from the site and are not listed yet.
- **New** - Selecting a zone lists its elite quests: in your quest log first, then still to take (by level), then done, with the level, the minimum level, "Both factions" for shared quests and the game's own state icons. The header counts what is left to do. "Open map" opens the zone.
- **New** - Click an elite quest for a waypoint to its giver: 233 quests have the giver's position, 28 more (started by an item, or giver not placed) lead to the turn-in, 9 have none. Positions come from each quest's foreverchanges.pro page (`Tools/elite_quest_pins.txt`, read by `Tools/parse_quest_pins.py`); the tooltip names the turn-in NPC when it differs.
- **New** - Quest tooltips in the codex show the minimum level and, for elite quests, that they are group quests.

## ####################################

## CHANGELOG 1.2.4

#### Dungeon Codex

- **New** - "Route" and "Quests (n)" tabs in the dungeon detail. The Quests tab lists the dungeon's quests for your faction: 402 quests over the 35 dungeons and wings (`DungeonQuestData.lua`), compiled from the public Forever databases foreverchanges.pro and wowforevertalents.com, generated by `Tools/gen_dungeonquests.py` from `Tools/dungeon_quests.txt`.
- **New** - Each quest shows its state read from the game, with the game's own icons: in your quest log first, then still to take (by level), then done. The count on the tab is what is left to do. Level in red when above you, quest giver (or the item that starts it), "Both factions" for shared quests.
- **New** - At login (not after a /reload), one chat line points to `/codex` for the dungeons, their routes and their quests, in the six languages. Can be turned off on the codex page.
- **New** - Titles in the client's language when it knows the quest, the English name otherwise. Tooltip: level, giver, the quest it comes after, state and quest ID. The list follows the quest log live (accepted, turned in, abandoned).

#### Bags: what to throw away, what to loot

- **New** - `Triage.lua` ranks the items of your regular bags from the cheapest to sell (vendor price x stack) to the dearest. Never ranked: items pinned in TomoMod's bags (middle click), quest items, items an unfinished objective of your quest log asks for (read by name, French "Item : 3/8" included), items with no vendor price, ammunition, and anything above green.
- **New** - In TomoMod's bags, the cheapest items carry a gold number on a dark plate, bottom left, with a gold edge (1 = first to go). Shown when the bags are nearly full (the bag space alert threshold), always or never; 1 to 10 numbered items (5 by default). With the loot window open on full bags, every item paired with a loot is numbered.
- **New** - Loot window, full bags: the dearest loot is paired with your cheapest item, the next with the next, and so on. Loot worth more than its pair, or needed by a quest, gets a gold coin (a texture, not a font symbol). Loot that fits on a stack you already carry needs no room and is left out.
- **New** - Tooltips: "To throw away #3 - value" on ranked bag items; on loot, "Worth it: drop X (value)" or "Worth less than X".
- **New** - The bag space banner adds "N to throw" past its threshold.
- **New** - Settings on the Adventure > Bag space page; `/tm tri` lists the five cheapest items and what the quest log asks for. Works with Blizzard's bags too (coins, tooltips, banner); the numbers need TomoMod's bags.

## ####################################

## CHANGELOG 1.2.3

#### Pet Happiness

- **Fixed** - The happiness icon could change colour while Blizzard's pet sheet did not (player report). It only looked for the old global `GetPetHappiness`, which Forever does not have, so it always fell back to an estimate from the hidden happiness gauge. It now reads the game's own state from `C_PetInfo.GetPetHappiness` first, the value Blizzard's sheet shows; the gauge estimate remains a fallback for a client where the state is missing or secret.
- **New** - With the game's state readable, the tooltip shows the pet's damage percentage again.
- **Changed** - `/tm pethappy` reports both `C_PetInfo.GetPetHappiness` and `GetPetHappiness`.

#### Flight Timer

- **New** - Every Forever flight route is built in (`FlightData.lua`: 295 routes, 75 flight points), generated from the game's TaxiPath, TaxiPathNode and TaxiNodes tables of build 1.60.1.70862 by `Tools/gen_flight.py`. Each route's length is the curve a flight path mount follows through the path's waypoints.
- **New** - The bar counts down from the very first flight of a route, and the flight master's map shows each destination's duration before you leave, routes with stops included.
- **New** - Durations are the length divided by the flight speed. The speed starts at 30.4 yd/s (Classic flight times measured by the community) and fits itself to your own flights: the median of your last 9 normal landings on known routes. Frequent Flier is still converted. A cut flight (landed far too early) teaches nothing.
- **Changed** - Order of the sources: a time learned on the exact route first, then the built-in length, then an estimate from learned pieces ("≈"), then measuring.
- **New** - Flight points are matched through the taxi map API, or by their position when it does not say.
- **New** - `/tm flight` (or `/tm vol`) prints the data build, the speed in use and how it was fitted, and with a flight master's map open, which destinations have a built-in time.

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
- **New** - The HUD also shows while the game's own "campfire nearby" aura is on you. A fire you light keeps the HUD within its own radius (12 yd at least, 30 for companion and specialist fires); a fire you point at, within 20 yd of where you pointed from (40 for the bigger fires), so you can walk up to it.
- **New** - `/tm camp` prints what the camp HUD sees: camp radius and distance, camp auras on you, last fire pointed at, interacted with or lit.
- **New** - Camp bonuses are recognised by ID and listed first (in gold in the tooltip), even when you already had them on arrival; other buffs gained at the fire still follow. The camp auras themselves are no longer counted as bonuses.
- **New** - Outside the fire's minute, the HUD says when camp bonuses are ready again.
- **New** - Pointing at a camp object adds its bonus to the tooltip (name and the game's own description, in every language), with "Bonus active" or the camp cooldown left.
- **Changed** - The localized word "campfire" stays as a fallback for any fire the list does not know.

#### Chat

- **Fixed** - Whisper tabs (and any temporary chat window) never showed in the TomoMod tab row: their name was read from the saved chat windows, which only know the ten permanent ones. Blizzard's own tab then stayed visible behind the panel. Tab names now come from the native tab, so every docked window gets its TomoMod tab.
- **Fixed** - Windows docked after login (a new window, a whisper tab) were left out of the TomoMod chat and stayed behind it: Blizzard marks a docked window with `isDocked = 1`, and the chat tested `isDocked == true`.
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
