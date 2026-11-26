## ####################################

## CHANGELOG 1.3.9

#### Quest dialogue (new)

- **New** - `Modules/QOL/Dialogue/Dialogue.lua` (`dialogue.*`): NPC conversations (`GOSSIP_SHOW`), greetings (`QUEST_GREETING`) and the quest pages (`QUEST_DETAIL`, `QUEST_PROGRESS`, `QUEST_COMPLETE`) open on one bronze and gold parchment panel: NPC name over a gold crest, quest title, divider, objectives, rewards, numbered choices (active quests, available quests in their difficulty colour, gossip options) and two key-cap buttons.
- **New** - Typewriter text: the text is revealed with the engine's alpha gradient (`FontString:SetAlphaGradient`, speed in the options); a click or Space shows it all at once. Every gradient call is protected, and the full text is shown by placing the gradient past the last character (the client refuses a length of 0).
- **New** - Keyboard, out of combat: Space / Enter continue, accept or turn in, 1 to 9 pick a choice (or a reward when turning in), Escape declines or leaves. The key is kept or passed on before the action runs, and Space is also bound to the main button while the panel is up (override binding, dropped when the panel hides and as a fight starts). Escape also works in combat (`UISpecialFrames`).
- **New** - Every action is the game's own function (`C_GossipInfo.Select*`, `AcceptQuest`, `CompleteQuest`, `GetQuestReward`, `CloseQuest`...). The game's `GossipFrame` and `QuestFrame` lose their events while the module is on and get them back when it is turned off; a page that fails to build hands that conversation to the game's window. Stands down when Immersion or DialogueUI is loaded. Gossip to quest: the panel stays (close delayed 0.12 s, cancelled by the next page), and the gossip close that follows the quest page no longer closes it.
- **New** - `DialogueRewards.lua`: reward cards in two columns, quality colour on name and slot, green arrow on usable gear with a higher item level than the worn piece (or an empty slot), purse on the choice with the best sell value, count. Hover shows the item, Shift compares, Ctrl dresses up, Shift-click links. Money, experience and a taught spell as small cards. On the progress page, the required items show carried / needed, counted by item ID (then by name), and all as carried when the game says the quest can be turned in.
- **New** - `DialogueScene.lua`: the camera zooms to `dialogue.cameraZoom` on the NPC; the interface fades (own tween on `UIParent`'s alpha) while the panel, item tooltips and popups stay visible; cinema bars slide in. The scene ends whenever no dialogue or book is on screen (checked every 0.3 s while a scene is on), the interface always comes back (even when a new dialogue starts half-way through the fade back), and a fight brings it back at once. The zoom goes back at the end.
- **New** - Optional side offset of the camera (`dialogue.cameraShift`, `test_cameraOverShoulder`) so the NPC stands beside the panel. Off by default: it is an experimental camera setting and the game asks to confirm it on Forever; above 0 the options say to pick Accept. The offset is given back at the end, or at the next login after a crash.
- **New** - `DialogueBook.lua`: `ITEM_TEXT_*` (books, letters, plaques) open a TMF book: parchment page tinted by material (stone, marble, silver, bronze), gold corners, title and divider, `SimpleHTML` body (plain and HTML texts), page number, arrows. Right / Space next, Left previous, Escape closes; pages slide in, the screen darkens behind (option). The game's `ItemTextFrame` loses those events while this is on.
- **New** - Textures drawn for TMF in `Assets/Textures/Dialogue/`: parchment and page, corner filigree, divider, crest, key cap, slot, button, highlight, upgrade arrow, shine band, cinema bar.
- **New** - Options: Adventure > Quest dialogue (position, size, text size, writing speed, detailed rewards, camera distance and offset, in dungeons, hide interface, cinema bars, books, darkened screen). Module registry entry.
- **New** - `/tmf dialogue`: state of the panel, keyboard and scene, and the last 30 events, keys and actions, to check the dialogue in game. Listed in `/tmf help`.
- Idea from DialogueUI by Peterodox (no licence, all rights reserved): nothing of its code or art is used.

#### Overlord Forever compatibility (new)

- **New** - `Modules/QOL/Chat/ChatOverlord.lua`: with the Overlord addon (Troma) loaded, TMF opens a chat tab named "Overlord" and every Overlord notification goes there (captures, general, kills, layer codes, faction calls). Without Overlord, nothing: no tab, no hook.
- **New** - The tab is a normal Blizzard chat window (`FCF_OpenNewWindow(name, true)`) with no message group and no channel, so only Overlord lines land in it. It is created once per character (`TomoModForeverCharDB.overlordTabCreated`), docked, and the tab the player was reading stays selected. Postponed after combat if needed.
- **New** - Routing wraps `Overlord:PrintNotification`, the one method Overlord uses for its player messages. Tab closed or option off: Overlord's own code runs unchanged (its notification tab setting included). `OverlordDB` is never written. Raid-warning banners, debug lines and the loading line stay where Overlord puts them.
- **New** - Option Skins > Chat > Overlord (`chatV4.overlordTab`, on by default), shown only when Overlord is loaded: turning it on brings a closed tab back, turning it off closes it. Six locales.
- **Changed** - `## OptionalDeps: Overlord` so Overlord loads first.

#### Changed

- **Changed** - Settings migration `dialogueShiftOff`: the dialogue camera side offset is reset to 0 once.
- **Changed** - What's New and the six locales (`Locales/Locale_139.lua`) cover the quest dialogue, the scene, rewards, books, the Overlord tab and the fixes below.

#### Fixed

- **Fixed** - World map: `ADDON_ACTION_BLOCKED ... Button:SetPassThroughButtons()` on every map refresh (reported since 1.3.6). The map markers were a data provider in the map's own list, which tainted the pins the game's quest provider acquired. They now follow the map through hooks (`OnMapChanged`, `OnCanvasScaleChanged`, show and hide) and the map's providers are left alone.
- **Fixed** - Diagnostics: more normal game messages are no longer logged as UIError (report session 179): no pockets to empty, non-empty bags, ammo-only slots, line not in fishable water, while swimming, a more powerful spell already active, while moving (FR and EN).

## ####################################

## CHANGELOG 1.3.8

#### Group quest progress

- **Fixed** - Shared quest progress showed nothing in the first in-game test (3 players): messages sent at login or during a loading screen can be lost, and only changes were sent afterwards. Now, 5 s after each loading screen a hello and the full list go out again; a tooltip that finds a member on the quest with nothing from them asks again (at most every 15 s); a member still "Unknown" while loading no longer wipes what we had; if the client refuses the party channel the instance channel is tried (group finder groups), and the reverse. `/tmf groupe` prints what was sent, refused and received per member.
- **Changed** - `/tmf groupe` is listed in `/tmf help`, and its report is translated in the six languages (`Locales/Locale_138.lua`).
- **Fixed** - Second in-game test (3 players): each sent 37 messages, none refused, none received. Members we hear nothing from 10 s after a hello are now reached by whisper as well (`WHISPER` addon messages, name with realm when it differs), and someone who writes to us by whisper gets our messages that way too; the prefix is registered again after a loading screen if the client lost it, and `CHAT_MSG_ADDON_LOGGED` is listened to as well.
- **New** - `/tmf groupe` also shows the prefix registration result, every `TMFQ` event received before any check (own echoes, secret values, per channel) and who is on whisper, to tell a message that never arrives from one dropped on arrival.

## ####################################

## CHANGELOG 1.3.7 - Release

#### Livelier frames and bars

- **New** - Smooth bars (`unitFrames.smoothBars`): unit frame health and power bars glide to their new value with the engine's own easing (`StatusBar:SetValue` with `Enum.StatusBarInterpolation.ExponentialEaseOut`, C-side, secret-safe). A new unit in the frame (target swap) or a power type change snaps. Off with the option or with animations set to none.
- **New** - Heal gain (`unitFrames.healGain`): a green bar under the health fill is set at once to the new health; with the fill gliding, a heal shows its green part first and the fill flows into it, while on a hit it stays hidden under the fill. No comparison of values, so secret health is never read. Layers: trail (-2), gain (-1), fill; the lowest visible bar carries the background.
- **New** - Spent trail (`unitFrames.powerTrail`): a pale bar under the power fill drains 0.4 s after mana / energy is spent, like the health trail (shared `TrailTo`).
- **Changed** - Health and power bars sit 5 levels above their frame so the trail, heal gain and the Forever skins' plate / background (now -3 / -4 under the fill) each have a level of their own; the threat border moves to +7.
- **New** - `EdgeAlerts.lua` (`edgeAlerts.*`): a glow along the screen edges, four gradient textures under the interface, click-through. Red and breathing under the health threshold (30 %), blue under the mana threshold (20 %, mana users, in combat only by default). Health wins; nothing while dead. Breathing (AnimationGroup) with full animations, steady otherwise, never hidden. Readable values are compared; when the client keeps them secret, `UnitHealthPercent` / `UnitPowerPercent` with a colour curve light it engine-side. Options page with test buttons, thresholds, depth and intensity.
- **New** - Quest tracker (`objectiveTracker.animateProgress`): the progress bar under a quest glides to its new value (same quest only); an objective whose text changed since the last draw gets a gold glint behind its line (texts remembered per quest, forgotten on turn-in or abandon).
- **New** - Quest tracker (`objectiveTracker.zoneBanner`): on a zone change the new zone's name rises above the tracker with a gold underline, then fades (2.5 s). Not at login, not while the tracker is hidden, not with animations off.
- **Fixed** - Quest tracker tooltip: in a group, the members on the same quest are listed again (class colour, check or cross, `C_QuestLog.IsUnitOnQuest`), as with the game's own tracker. Party only, not in a raid.
- **New** - `Quest/PartyQuests.lua` (`objectiveTracker.shareProgress`): group members running TMF share their quest progress over addon messages (prefix `TMFQ`, party channel or instance channel, party only, never in a raid). A full list when you join, when someone new joins or in answer to a hello; then only the quests that changed, at most every 1.5 s, never in combat (held until it ends; no combat log read); messages under 255 bytes. The tracker tooltip's group lines show it: "Ready to turn in", "Failed", or the counts per objective (with the objective's name when there are several); members without TMF keep the check / cross. Data of members who left is dropped. The tracker's quest log reader is shared (`OT.GatherLog`).
- **Fixed** - Waypoint: tracking a quest sometimes showed no beacon until a reload. The beacon followed a cached navigation frame after the game destroyed and rebuilt it; it now asks the game every time and re-anchors when the frame changes (and makes the new one transparent, not the old). And a beacon kept off because you stood in the quest area, or outside the waypoint's zone with "zone only", stayed off after you left, since no event tells that: while something is tracked and the beacon is off, the state is checked again every second.
- **New** - Bags (`bags.slots.newGlint`): items the game flags as new (`C_NewItems.IsNewItem`) get a golden light sweeping over the icon every few seconds (clipped band, AnimationGroup; a soft gold veil with reduced or no animations). Built on the first new item a slot shows, nothing on Blizzard's secure button. Closing the bags clears the flags (`C_NewItems.ClearAll`), as Blizzard's bags do.
- **New** - Options window: the hero and the cards of a page rise into place one after another (8 at most, 45 ms apart) when a page opens, not on an in-place refresh; navigation rows and section titles get a hover wash that fades in and out (`K.HoverFade`), the current page's accent bar grows from the middle, the "Show me" button glows softly. All follow the window's animation setting and the global level.
- **New** - XP bar (`xpEdge.glide`, `xpEdge.restedShimmer`): after a gain on the same level the earned part lights at once in pale gold and the fill flows into it (eased in the bar's existing OnUpdate, only while it moves); level changes and losses snap. A light passes over the rested part every few seconds (clipped frame, Translation in an AnimationGroup, full animations only).

## ####################################

## CHANGELOG 1.3.6 - Release

#### Forever frame style: official skin

- **New** - `Units/ForeverArt.lua`: the Forever look (`unitFrames.style = "forever"`) gets an official skin, on by default (`unitFrames.foreverArt`; `false` = the classic flat strip of `ForeverStyle.lua`, unchanged). The frame is drawn with WoW Forever's own unit frame art read from the game (atlas `UI-HUD-UnitFrame-Target-PortraitOn`, nothing copied into TMF): the atlas is cut in three slices across its full height, the left end (x 0-8) and the right part (x 120-194: plate end, ring and rim) keep their size and the middle stretches with the width, so the ring stays whole without a mask. Tinted bronze, mirrored for the frames whose ring is on the left (player, pet, target of target). Health and power sit in the plate's slots (the health bar runs down to the power slot's bottom when the power bar is off), the name in the name box over the game's reaction tint (`...-PortraitOn-Type`, class colour for players), a 2D portrait under the ring, the level on the game's small disc.
- **New** - State art on the ring: the elite / rare / boss dragon from the game's own `GetBossPortraitFrameData`, the skull on the level disc for a "??" target or focus, the quest mark for a quest boss or a hostile unit tied to an active quest (`UnitIsQuestBoss`, `C_QuestLog.UnitIsRelatedToActiveQuest`), the PvP crest (faction or free-for-all), the engine's raid marker and leader crown moved onto the ring, and on the player frame the combat swords, the resting corner piece and a lit copy of the plate pulsing in the threat colour, red in combat or gold while resting (steady glow at the reduced or none animation level). Refreshed on combat, resting, threat, classification, faction, quest log, portrait and level events. Secret values hide the art.
- **New** - The click area reaches over the ring (`SetHitRectInsets`, out of combat), so a click on the portrait targets like on Blizzard's frames.
- **New** - Frames > Shared style: Forever skin (official or classic). Official skin sizes per frame: width (stretches the middle of the plate) and scale (100 % = Blizzard's art; player and target 130 %, focus 100 %, pet 75 %, target of target 65 %). The classic skin keeps its own sizes and its portrait option.
- Credit: the geometry, the slicing idea, Blizzard's placement table and the state art follow FlareUI by Malkkav (MIT License, https://github.com/malkkav/FlareUI), rewritten for TMF's unit frame engine. No FlareUI file is shipped.

#### Options window

- **Changed** - The Frames > Animation HUD page is only listed (sidebar and search) while the Animation look is the chosen frame style. Pages can now declare `visible = function() ... end` and a `fallback` page: a saved last page or a link to a hidden page opens the fallback instead, and the sidebar is laid out again whenever a page is rebuilt (choosing a style shows or hides the page at once).

#### Level up, notifications, quests in tooltips, animation level

- **New** - Interface animations (home page of the options): full, reduced or none, stored in `animations.level` and read through `TomoMod_Utils.AnimLevel()` / `AnimFull()` / `AnimAny()`. Full: everything. Reduced: short fades and feedback only, no movement, scale, shake, looping pulse, sweep or flying icon. None: frames appear and disappear at once. Followed by the quest tracker (fade-in, completion flash), the bag space banner (pop, count-up, shake, pulse, fade), the class trainer reminder (fade, glint), the new spell ranks (flying icon), the camp flames, the XP bar (sweep, badge flash), `U.Pop` / `U.Shake` (every caller), the options window (`K.Animated`), and the new modules below.
- **New** - Level-up celebration (`Toasts.lua`, `levelUp.*`): a golden ring opens in the middle of the screen with a turning dashed ring, a glow, embers flying out, "Level N" popping and a gold line drawing under it. At even levels it says how many spells wait at the class trainer (`TomoMod_TrainerReminder.PendingFor(level)`, new: the level comes from `PLAYER_LEVEL_UP` before `UnitLevel` catches up). While it is on, the XP bar keeps its sweep and badge flash and leaves the big title to it (`TomoMod_Toasts.OwnsLevelUp()`).
- **New** - While the celebration plays, the game's own level-up banner is hidden (`levelUp.hideBlizzard`, on by default): `LevelUpDisplay` and/or `EventToastManagerFrame`, whichever the client has, only for 4 s after `PLAYER_LEVEL_UP` so other toasts stay; nothing is unregistered.
- **New** - Notifications (`Toasts.lua`, `toasts.*`): bronze banners stacked under a movable anchor at the top of the screen, newest on top, for quests turned in (`QUEST_TURNED_IN`, with XP and money), quests becoming complete (only known quests with objectives going from unfinished to finished: nothing at login, nothing for a "talk to" quest complete on accept), loot of a chosen quality (rare by default), new reputation standings (not every gain), areas discovered and spells learned (gathered for 1.2 s, so a "Train all" gives one banner). The messages are read from the game's own strings (`LOOT_ITEM_SELF*`, `FACTION_STANDING_CHANGED`, `ERR_ZONE_EXPLORED*`, `ERR_LEARN_*_S`) turned into patterns, numbered placeholders (`%2$s`) included, so every client language works. Up to `maxShown` at once; when more come, the oldest gives its place once it has been on screen 1.5 s. Hover pauses the timer; click a quest banner to open the log, right click to close; loot and spell banners show their tooltip.
- **New** - Quests in tooltips (`QuestTooltip.lua`, `questTooltip.*`): hovering a monster or an item a quest of your log asks for adds the quest title and the objective line. Each objective is cut back to the name it counts with `QUEST_MONSTERS_KILLED`, `QUEST_ITEMS_NEEDED`, `QUEST_OBJECTS_FOUND` as patterns, and the tooltip name must equal it (case aside): no false match on "Wolf" for "Forest Wolf". Every quest of the log counts, watched or not. Index rebuilt on `QUEST_LOG_UPDATE` (coalesced 0.5 s), lines added through `TooltipDataProcessor` post-calls, secret names skipped. Stands down when Questie shows its own quest tooltips (`TomoMod_Compat.QuestieOwnsTooltips()`, Questie's `enableTooltips`).
- **New** - Options: Adventure > Notifications (level up and notifications, with tests) and Adventure > Quests in tooltips. Both new modules are in the module registry (notifications anchor movable with the others).

#### Mana bar, gathering, quest rewards, fishing, world map

- **New** - `ManaBar.lua` (`manaBar.*`): on the TMF player frame power bar, while it shows mana. A spark runs along the bar for the five seconds without regeneration after a spell (`UNIT_SPELLCAST_SUCCEEDED` with mana spent), then a lighter spark marks each 2 s regeneration tick while mana moves. While casting or channelling, an overlay at the end of the fill shows the mana the spell will cost (`C_Spell.GetSpellPowerCost`, secret-safe: the value is handed to a StatusBar, never compared). Test button in the options.
- **New** - `GatherTips.lua` (`gatherTips.*`): herb and ore tooltips (English and French node names) show the Classic skill required, coloured like recipes against your Herbalism / Mining (orange: below, yellow, green, grey); skinnable beasts (`UNIT_SKINNABLE_LEATHER`) show the Skinning required by their level.
- **New** - `QuestReward.lua` (`questReward.enabled`): in the quest frame and the map's quest details, a purse marks the choice reward with the highest vendor price (count included); refreshed when item data arrives.
- **New** - `Fishing.lua` (`fishing.*`) and `Bindings.xml`: a Fishing key (Key Bindings > AddOns > TomoMod Forever), a secure macro button whose text is written out of combat before each press: equip a pole from the bags, else apply the best lure from the bags when the main hand has no temporary enchant (option), else cast Fishing. The button is registered for both click edges: the modern client only acts on the edge `ActionButtonUseKeyDown` picks. Reel In (option): during the fishing channel the same key is overridden to `INTERACTTARGET`, with soft interact on and reaching the bobber (`SoftTargetInteract` 3, `SoftTargetInteractArc` 2, `SoftTargetInteractRange` 60, hand icon on the bobber `SoftTargetIconGameObject` / `SoftTargetIconInteract`; previous values given back with the sounds, or at the next login after a crash), the override removed when the channel stops. Double right click on the world casts (option, pole in hand): a short right click on the world arms the next one for 0.4 s (global mouse events: the world frame does not receive right clicks); line out, that click reels in. Fishing sounds (option): effects up, music and ambience muted while fishing, restored 20 s after the last cast, at logout, or after a crash at the next login.
- **New** - `MapMarkers.lua` (`mapMarkers.*`): a world map data provider with its own pins: flight points of the zone (`C_TaxiMap.GetTaxiNodesForMap`, your faction and neutral), dungeon entrances from the codex (your `/codex set` corrections included; on zone and continent maps, wings sharing a door merged), boats and zeppelins (Classic positions). Hover names the marker, click sets a waypoint (TMF arrow when on). Comfort: fade the map while moving (game `mapFade` CVar, previous value given back) and see the game behind the maximized map (backdrop opacity, optional click-through).
- **Fixed** - Quest tracker: after turning in or accepting a quest, Blizzard's objective tracker showed again over TMF's. The game puts its tracker back in the screen's managed-frame container (`SetParent`) when that layout is rebuilt; a `SetParent` / `OnShow` hook now sends it back to the hidden parent on the next frame (out of combat, else after it), and it stays transparent while hidden.
- **Fixed** - Nameplates: a soft-targeted world object (fishing bobber, chest, node) got a health bar reading "Offline". World objects (`UnitIsGameObject`, else a non-player that is not "connected") now get a name-only plate, whatever the friendly name-only setting.
- **New** - Options: Adventure > Mana bar, Gathering and rewards, Fishing, World map. All five modules are in the module registry.
- Note: ideas taken from the feature list of EUI Standalone Forever Essentials (all rights reserved). Nothing of its code is used: everything is written for TMF.

#### Code audit after 1.3.5 (errors, memory, CPU)

Whole addon checked: 247 loaded files, `luacheck` (Lua 5.1, plus undefined-global reads), every `OnUpdate`, ticker and high-frequency event, every growing table, static data measured in Lua 5.1. No syntax error, no leaked global, no unthrottled per-frame work, frequent unit events all filtered (`RegisterUnitEvent`), histories all capped, no forced `collectgarbage`.

- **Improved** - `TrainerData.lua` drops the eight classes you are not at load: 360 KB of tables down to 47 KB. Only `TrainerReminder` reads it, for your own class.
- **Improved** - Diagnostics: stack (4000 chars) and locals (2000 chars) are capped at capture. `debuglocals` dumps whole tables, and entries are kept in SavedVariables (up to 500).
- **Improved** - Diagnostics: the report gains a `Memory:` line (TMF's own memory, measured when the report is built).
- **Fixed** - Diagnostics: normal game messages from report session 151 are no longer logged as UIError: shapeshift form, "Must be in Bear Form", "Can't use that here", item not usable, no equipment slot, camp placement and full camp (FR and EN keywords).
- **Fixed** - Diagnostics: seven em dashes saved as double-encoded UTF-8 showed as garbled text in the report and console.

## ####################################

## CHANGELOG 1.3.5

#### Quest tracker: rebuilt from scratch

Player reports: quests in no particular order, colours that mean nothing, the Ready to turn in group mixed with everything else, quests missing from the tracker. The cause was structural: up to 1.3.4 `ObjectiveTracker.lua` re-skinned Blizzard's Retail objective tracker, walked its frame tree and sorted blocks by Retail quest classification (campaign, world quest, legendary, calling...), none of which exists on Forever. Every quest fell in the same bucket in log order, and the re-parenting fought Blizzard's own layout (combat flicker, blocks shown then hidden, 1.2.7 / 1.2.8 / 1.2.9 fixes).

- **Changed** - TMF now draws its own tracker straight from the quest log (`C_QuestLog.GetInfo` / `GetQuestObjectives`, Classic `GetQuestLogTitle` / `GetQuestLogLeaderBoard` as fallback). Blizzard's tracker (`ObjectiveTrackerFrame`, `QuestWatchFrame`) is moved under a hidden parent out of combat, and put back when the module is switched off. `TomoMod_ObjectiveTracker` keeps its public API.
- **New** - Sections: Pinned, Ready to turn in, then one per zone (quest log headers). The zone you are in comes first and is marked; the others fold by themselves (option), and the folds you make last until you change zone. Each zone header shows its level range and quest count.
- **New** - Sort inside a section: by level (default), name (A-Z, `strcmputf8i` so accents sort right), progress, or distance when `C_QuestLog.GetDistanceSqToQuest` exists. Zone order: current zone then by level, by name, or quest log order.
- **New** - Colours with a meaning only: the level takes the quest difficulty colour (`GetQuestDifficultyColor`), titles stay off-white (option to colour them too), finished objectives turn green, failed quests red. Optional tag (Elite, Dungeon, Group N) and a thin progress bar per quest.
- **New** - The tracker follows the check boxes of the quest log (`C_QuestLog.GetQuestWatchType`, refreshed on `QUEST_WATCH_LIST_CHANGED`): untick a quest in the log and it leaves the tracker, tick it and it comes back. "Hide from the tracker" unticks it in the log too. A pin only moves a ticked quest to the top. "Every quest, ignoring the quest log boxes" stays available as an option, with its own hidden list (migration `questTrackerWatched` sets every profile back to the check boxes).
- **New** - Clicks: open the quest (click again closes the log), Shift link in chat, Ctrl pin to the top. Right click: open, pin, arrow (`C_SuperTrack`, when available), link, share with the group, hide, abandon (Blizzard's confirmation). Header: left click folds everything, right click (or the three dots) opens the quick menu for display, sort and zone options.
- **New** - Quest item buttons (`SecureActionButtonTemplate`, `type = item`) beside each quest, left or right of the tracker, with cooldown, charges and an out-of-range tint.
- **New** - A green pulse when a quest becomes ready to turn in, a short fade-in for a newly accepted quest.
- **New** - Mouse wheel scrolls when the list is taller than the screen (or the max height option); a footer says how many quests are below.
- **New** - Opacity in combat, width, max height, item side, tooltips, level, tags and progress bar in Skins > Quest tracker.
- **Changed** - Combat: item buttons are parented to the header, so the header is never moved, resized, shown or hidden in combat (alpha only). While an item button is on screen a change of structure waits for `PLAYER_REGEN_ENABLED` and only the texts are refreshed in place; without one the tracker re-lays out freely.
- **Fixed** - The title bar is clamped to the screen: the tracker can no longer be lost off screen (`/tmf tracker reset` stays available).
- **Changed** - Pins, hidden quests and folded sections are saved per character (`TomoModForeverCharDB.questTracker`).
- **Changed** - Migration `questTrackerV2`: the bucket keys (`buckets`, `bucketsCollapsed`, `zonesCollapsed`, `minimized`) are dropped. A saved position anchored by its top is kept; any other goes back to the default corner (it was measured on Blizzard's frame, up to 4000 px high).
- Questie: unchanged, TMF stands down when Questie draws the tracker.

#### Class trainer reminder

- **Fixed** - The reminder showed on every level up as soon as a spell was waiting, so a spell left unlearned at 52 brought it back at 53. `Remind` now returns at odd levels, on level up and at login alike (54 yes, 53 no). The move-mode preview is unchanged.

## ####################################

## CHANGELOG 1.3.4

#### Quest tracker: reset position

- **New** - `TomoMod_ObjectiveTracker.ResetPosition()`: back to the default place (`TomoMod_Defaults.objectiveTracker.position`, top right) and a 100 % scale, applied live. In combat the settings are written at once and the move waits for `PLAYER_REGEN_ENABLED`. Reported: a player changed something in Blizzard's Edit Mode and his quest tracker vanished since, off screen. The tracker is not clamped to the screen (on purpose, see `ApplyPosition`) and its place is TMF's own, re-applied on every load, so Edit Mode's reset cannot bring it back; the move-mode handle sits on the tracker, off screen with it. The only way back was a `/run`, and the code comment pointing to a "Reset position" setting referred to a button that did not exist.
- **New** - `/tmf tracker reset` (also `/tmf suivi reset`), listed in `/tmf help`.
- **New** - Skins (Apparence) > Obj. Tracker tab: "Reset the tracker position" button, with a line explaining when to use it.

#### Resource bars: druid combo points

- **Fixed** - Druid combo points only showed for spec 2 (Feral) in `CLASS_RESOURCES`. On Forever a low-level druid has no spec (`GetSpecialization` 0) or another one, so Cat Form showed no points with either unit frame look (TMF, Forever). They now follow Cat Form whatever the spec (`DruidResources`: `GetShapeshiftFormID() == 1`, energy power type as fallback), and `UPDATE_SHAPESHIFT_FORM` rebuilds the display when the druid enters or leaves Cat Form. The druid mana bar is unchanged.

#### Damage meter: death recap

- **Fixed** - The automatic death recap ("Show on death") never appeared when the player died mid-pull, the usual case. The recap ID was read from a `C_Timer` callback 0.5 s after `PLAYER_DEAD`, where the Deaths session comes back secret during combat. `PLAYER_DEAD` now only arms a 15 s window and the lookup runs synchronously in the next readable event (`DAMAGE_METER_COMBAT_SESSION_UPDATED`, `DAMAGE_METER_CURRENT_SESSION_UPDATED` or `PLAYER_REGEN_ENABLED`). The timer read is kept as an out-of-combat fallback.
- **Fixed** - A recap already shown is never opened again: the Overall session still holds earlier deaths.

#### Damage meter: stability

- **New** - `ns.SafeRegisterEvent(frame, event)`: event registration through `pcall`. An event unknown to the client used to throw and abort the whole calling file, taking the database and the windows down with it. Benchmark and Fight history already looked for this helper and fell back to a bare `pcall` because it was never defined. Used for the `DAMAGE_METER_*` events and the death recap.
- **New** - `ns.GetSessionFromType(sessionType, meterType)` and `ns.ResetAllSessions()`: protected wrappers around `C_DamageMeter.GetCombatSessionFromType` and `C_DamageMeter.ResetAllCombatSessions`. An error raised by the API (expired session, API change) no longer aborts the whole refresh handler. Used by the meter windows, the report snapshot, the spell and target breakdowns, the death recap lookup, the reset button, `/tdm reset` and the auto-reset on entering an instance.
- **Fixed** - Spell breakdown (player list) and Target breakdown (enemy list): the `combatSources` list is checked with `issecretvalue` before its length is read, which raised an error when the list came back secret.

#### Damage meter: Benchmark and Fight history

- **Changed** - Benchmark: the player DPS is no longer read on every `DAMAGE_METER_*` event while the benchmark is idle. The mode (armed, waiting for data, running, capturing) is checked before any session scan.
- **Fixed** - Benchmark and Fight history windows: Escape now closes them through `TomoMod_Utils.CloseOnEscape` instead of adding them to `UISpecialFrames`. Reassigning that global tainted it.

## ####################################

## CHANGELOG 1.3.3

#### Unit frames: "Animation" look, buffs and debuffs

- **Fixed** - Still no buffs or debuffs around the halo in 1.3.2: `/tmf anim debug` showed the aura engine available but 0 blocks built, with no error. The containers were built the Braise way (`CreateFrame("AuraContainer", ..., "CustomAuraContainerTemplate")` and our own button initializer), and on Forever that path failed quietly.
- **Changed** - The four aura blocks (player buffs and debuffs on the left, target buffs and debuffs on the right) now go through `TomoMod_AuraContainer.Create` / `.SetUnit` / `.ResizePending`, the builder already used by the TMF unit frames, nameplates and group frames on the same client. Same places, sizes, rows and options as before; still nothing read from addon code in combat.
- **Changed** - Look of the aura icons: dark backdrop behind each icon, dispel-coloured border on debuffs (was a dispel-coloured glow), remaining time inside the bottom of the icon, tooltip on hover. The small "pop" when a new aura appears is gone with the old buttons.
- **Changed** - Larger aura icons (buffs 26 instead of 20, debuffs 30 instead of 28) with more room between them (5 instead of 2): on the first render the remaining time ("47 m") was wider than a small icon and spilled over its neighbours.
- **Changed** - `/tmf anim debug` also says whether the TMF aura builder is there, the icon size of each block, and names the block that failed when one cannot be built (`AC.Create nil`).
- **Fixed** - `/tmf anim debug` raised an error on the container size, which the engine can make secret since it sizes the container from aura data. The size and button count are only printed when Lua may read them (`?x?` otherwise).

#### Unit frames: "Animation" look, target level

- **New** - Target level before its name above the halo, in the difficulty colour, with "Elite" / "Rare" when it applies, and "??" in red for bosses and skull-level targets. Refreshed on `UNIT_LEVEL` / `UNIT_CLASSIFICATION_CHANGED`, uses the effective level when the client has it, and falls back to the bare name if anything goes wrong.

#### Unit frames: "Animation" look, settings in Shared style

- **New** - Frames > Shared style, with the Animation look chosen: an "Animation look" card like the Forever sizes one, with theme, HUD size, text size, aura size, idle opacity, ember amount and values, plus "Move the elements" and "All HUD settings" (opens Frames > Animation HUD). The Animation HUD page shows the same controls in its "Look" card; both pages share one builder (`AnimLookControls`).
- **New** - Text size (`unitFrames.animation.textScale`, 0.6 to 1.8): every text of the HUD (names, values, timer, spell names), relative to the HUD size, applied live on refresh (`B.ApplyTextScale`).
- **New** - Aura size (`unitFrames.animation.auraScale`, 0.5 to 2.0): the buff and debuff icons and their place holders, relative to the HUD size, resized live through `TomoMod_AuraContainer.Relayout`, no `/reload`.
- **Changed** - The "Size" slider of the Animation HUD page is now called "HUD size", and "Ember amount" moved from the Centre animation card to the Look card.

#### Unit frames: "Animation" look, clicks

- **Changed** - Only the health arcs are clickable now (player, target and pet), plus the target's name and the target-of-target line. The power arcs (right side) no longer carry click zones: a left or right click on a resource used to target the unit or open its menu, it now goes through to the world.

#### Bags

- **Fixed** - Opening the personal bank raised `[ADDON_ACTION_FORBIDDEN] TomoModForever: PurchaseBankTab()`. On show, Blizzard's bank opens the bags and then, in the same call path, buys the free first bank tab, a protected action that fails as soon as that path is tainted. The Bags module replaced `BackpackTokenFrame.GetMaxTokensWatched` with an addon function (to keep three tracked currencies in combined mode), which tainted every caller; the override is removed and Blizzard's own value is used.
- **Changed** - The `combinedBags` CVar is only written when its value actually changes (`SetCVarIfChanged`), instead of on every login: a CVar written by an addon is tainted for the rest of the session and Blizzard's bag code reads this one while the bank opens.
- **Fixed** - The "Bags" switch of the Home page always read as on and did nothing: it pointed to the `bagsV4` manifest, which only owns the window position (passive, always on). It now drives the `bagSkin` module, like the Bags tab of the Skins page.
- **Fixed** - Moving a quest item left its gold quest border on the slot it came from, until another item filled that slot. The empty-slot path of `Slots:Render` reset every mark but the quest border and the quest-starter "!"; both are now hidden there. The native `IconQuestTexture` of the Blizzard item button is also made transparent, like its other decorative regions.
- **Fixed** - An item asked for by a quest objective lost its gold quest border, and went back on the throw-away list, as soon as the objective was complete ("Côtes de sanglier des rochers : 6/6"): `Triage.lua` only read unfinished objectives. Finished item objectives now count too, as long as the quest is in the log, since the items still have to be handed in; an unfinished objective wins when two quests ask for the same item.
- **Changed** - Item names are compared with accented capitals folded as well (`É` = `é`, Latin-1 range), on top of the apostrophes, no-break spaces and ASCII case already folded.

## ####################################

## CHANGELOG 1.3.2

#### Dungeon codex: new look

- **Changed** - The codex and its loot window are redrawn. Only the drawing code of `Modules/QOL/Forever/DungeonCodex.lua` changed: the data, the lists and filters, the quest states, the waypoints, the `/codex` commands, the tooltips and the clicks are untouched. A "Visual toolkit" section holds what both windows share (`Shell`, `TabStrip`, `RowLook`, `Flat`, `ScrollMark`): soft drop shadow, bronze edge with gold corners, title bar in a gradient with the player's level on a gold plate, and text with a soft shadow instead of an outline.
- **Changed** - Larger windows: the codex is 680 x 470 (was 600 x 420), the loot window 460 x 540 (was 440 x 500), and both are drawn 20% larger, text included (`ZOOM = 1.2`). The "Window size" option multiplies that, so 1.00 is the new size.
- **Changed** - "My level / All / Elites" and "Route / Quests" are text tabs sharing a gold underline that slides to the active one. "Loot (n)", which opens its own window, is a button at the right end of the same line. The header (name, levels and zone, tags) has a fixed height, so the tabs no longer move from one dungeon to the next; elite zones get a heading where the tabs would be.
- **Changed** - Dungeon list: the level range sits on a plate tinted like its status (in reach, soon, out of reach), the selected line has a gold wash and a bright bar on its left, and new dungeons are marked with a gold diamond instead of `*`.
- **Changed** - Route: each step is numbered in a gold diamond, the note is aligned with the steps, the position line has a pin, and "Set waypoint" is a gold button, as the main action.
- **New** - The quest list shows a scroll mark when there are more quests than fit (nothing said so before), and 7 lines are visible instead of 6.
- **Fixed** - The arrow of the routes ("Menethil → Theramore") was an empty box: Poppins has no such glyph. It is replaced when displayed by a drawn arrow (`Pretty`); the data file is unchanged.
- **Changed** - Loot window: boss headings on a gold band with their item count, item icons framed in the colour of their quality, every other item barely lighter, a slimmer scroll bar with drawn chevrons (same behaviour: hold the arrows, click the track, drag the thumb, wheel), and "For me: on / off" is now a switch.
- **New** - Animations, driven by one hidden frame that sleeps when nothing moves: the window fades in and the gold rule under its title opens from the centre, the lines of a list arrive one after the other, the tab underline slides, hovers fade in and out, the detail fades in on another dungeon or tab (not on the refreshes that quest and item events trigger), and the "For me" switch slides.
- **New** - `Assets/Textures/Codex/`: 12 textures (shadow, corner, gradients, diamonds, chevrons, arrow, pin, cross), white shapes tinted with `SetVertexColor`, generated by `Tools/gen_codex_textures.py`. New texture files need a full restart of the game, not a `/reload`.
- **Changed** - The lines of the quest list are built by `QuestRow`, split out of `CreateWindow`, which would otherwise pass Lua's limit of 60 upvalues per function. Their tooltip and click code is copied as it was.

#### Unit frames: "Animation" look

- **New** - `Modules/Interface/AnimHUD/`: a third look for the unit frames, `unitFrames.style = "animation"`, chosen in Frames > Shared style next to TMF and Forever. It is the halo of Braise 1.11 (TomoAniki's HUD addon) brought into TMF, settings in `unitFrames.animation`: thin arcs around the character instead of boxes. Your health (left) and power (right), the target one ring further out (class or reaction colour, name above the halo, slides in on target change, no power arc for creatures without one), the pet one ring further in (opens on summon), the target of target above the target's name ("YOU" in the combat colour when the target turns on you). Health arc colour from a C-side curve, low-health red glow on it, values by the arcs. Idle, the halo dims to the chosen opacity and breathes; it wakes up on a target or missing health.
- **New** - Signs: cast arcs (`UnitCastingDuration` / `UnitChannelDuration` timers, so secret cast times are fine; flash on success, red "Interrupted"), threat gauge at the top (in a group or with a pet, tank mode), combo points as pips under the character (read like ResourceBars since 1.3.1: `GetComboPoints` on the target when `UnitPower` reads 0, cap 5 when `UnitPowerMax` reads 0, refreshed on target change), buffs / debuffs of the player (left) and target (right) through the client's `AuraContainer`.
- **New** - Centre animation: two rings turning in opposite directions (slow idle, fast in combat), embers (theme colours, class motion optional), and on combat start a shockwave, two blades, arcs snapping in with a flash and the rings popping; on combat end a closing wave. Combat timer under the halo. Four themes: Ember, Frost, Sap, Class.
- **Not ported** (on purpose): Braise's screen-edge heat and low-health vignette, level-up fanfare, after-combat recap card with the XP gained, and its missing-buff reminders (TMF has its own).
- **New** - With this look, the TMF frames of the player, target, target of target and pet are switched off the oUF way (`UF.ApplyAnimationVisibility`: `Disable`, flagged `_animHidden` so `ToggleLock` and the master switch leave them off) and come back when the look changes, no `/reload`. The pet and target-of-target frames can be kept (`keepPetFrame`, for the hunter pet mood; `keepToTFrame`). Focus and boss frames keep the TMF look.
- **New** - The TMF cast bars of the player, target and pet are not built with this look (`CB.CreateCastbar` asks `TomoMod_AnimHUD.HidesCastbar`), nor the GCD spark; they are rebuilt when the look changes. Blizzard's cast bars are kept hidden.
- **New** - Clickable arcs: chains of small `SecureUnitButtonTemplate` buttons along each arc (left-click targets, right-click opens the unit menu, hover shows the tooltip); the target, pet and target-of-target zones follow `RegisterUnitWatch`. Changes made in combat wait for the end of the fight, as does switching the look.
- **New** - Move mode: one handle per element plus one for the whole HUD, right-click a handle to put it back (`unitFrames.animation.offsets`). From the options page, `/tmf anim`, or with the layout mode (`/tmf layout`). `/tmf anim test` plays a demo fight.
- **New** - Options: Frames > Animation HUD (theme, size, idle opacity, values; target, pet, target of target, clicks, keep the TMF pet / ToT frames; cast arcs, threat, tank mode, combo points, auras; rings, embers, amount, class motion, shockwave and blades, timer; reset). Frames > Shared style explains the look.
- **Changed** - If the Braise addon itself is loaded, the Animation look stands down (two halos would overlap) and the options page says so.
- Textures in `Assets/Textures/Animation/` (from Braise), font Poppins already shipped by TMF.
- **Fixed** - First in-game test: no buffs or debuffs around the halo. The aura blocks were given their unit once, at build time, under a parent that was still hidden. They now follow the TMF pattern (`TomoMod_AuraContainer.SetUnit`): unit, `SetEnabled(true)`, `UpdateAllAuras`, again on every refresh, target change and entering the world; the HUD anchor is shown before the build.
- **New** - `/tmf anim debug`: state of the look (style, Braise, active), last module error, and per aura block: option, host and container shown / visible, container size, unit accepted, button count.

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
