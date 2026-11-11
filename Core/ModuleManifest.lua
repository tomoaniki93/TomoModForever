-- =====================================================================
-- ModuleManifest.lua — The module inventory (v4 Lot 0)
-- ---------------------------------------------------------------------
-- One entry per top-level key of TomoMod_Defaults. Nothing may be
-- missing and nothing may be invented: Tools/test_module_manifest_static
-- .lua walks the real defaults table and fails on either side of that
-- equality, so this file cannot silently drift as the DB grows.
--
-- Field notes
-- -----------
-- group          One of the nine groups in Core/ModuleRegistry.lua.
--                Absent for internal entries.
--
-- internal       Bookkeeping rather than configuration: installer
--                progress, cached keystones, CVar backups, the last
--                seen version. Never listed, never toggled, never
--                offered at import time.
--
-- enabledPath    A single boolean. The common case.
-- toggles        Several booleans with no master switch. The module
--                counts as on when at least one of them is on.
--                Neither field: the module is passive (no flag at all).
--
-- requiresReload Set where turning the module off at runtime cannot
--                currently undo what it did at load: secure frames that
--                may not be respawned in combat, and hooksecurefunc
--                hooks, which cannot be removed once installed. This is
--                a statement about today's code, not a design goal --
--                Lot 1's measurable objective is to flip as many of
--                these to false as possible by making hook bodies read
--                the flag instead of assuming it.
--
-- contextSwap    Arbitration A. Content profiles are swapped whole, so
--                what matters is which modules must NOT follow the
--                swap. Diagnostics, addon detection and the studios are
--                tooling: a player who opens them in a raid should not
--                find them closed after stepping into a key.
--
-- anchors        Arbitration B. Only paths that actually resolve in
--                TomoMod_Defaults are declared, and each carries the
--                shape it is stored in today -- three variants grew
--                independently and all three are still live. That turns
--                the Lot 2 normalisation into a table walk.
--
--                A few more modules (levelingBar, rareAlert,
--                reputationBar, chatFrameUI, frameAnchors)
--                materialise a position only on first drag, so they have
--                no default to point at. Giving them declared defaults
--                is part of Lot 2; declaring a path here that resolves
--                to nil would only move the problem.
-- =====================================================================

local R = TomoMod_Registry

-- ---------------------------------------------------------------------
-- GENERAL
-- ---------------------------------------------------------------------

R.Define{
    key = "minimap", label = "mod_minimap", group = "general",
    enabledPath = "minimap.enabled",
    anchors = { { id = "minimap", path = "minimap.position", shape = "anchor_relTo", label = "frame_minimap" } },
    global = "TomoMod_Minimap",
}

R.Define{
    key = "infoPanel", label = "mod_infoPanel", group = "general",
    enabledPath = "infoPanel.enabled",
    global = "TomoMod_InfoPanel",
}

R.Define{
    key = "cursorRing", label = "mod_cursorRing", group = "general",
    enabledPath = "cursorRing.enabled",
    global = "TomoMod_CursorRing", applyMode = "gate", apply = "ApplySettings",
    combatSafe = true,
}

R.Define{
    key = "frameAnchors", label = "mod_frameAnchors", group = "general",
    enabledPath = "frameAnchors.enabled",
    global = "TomoMod_FrameAnchors",
}

-- Modes are strings ("show" / "hide"), not booleans, so there is no
-- flag for the registry to own. Passive until Lot 1 decides whether a
-- third mode or a real master switch is the better shape.
R.Define{
    key = "bagMicroMenu", label = "mod_bagMicroMenu", group = "general",
    global = "TomoMod_BagMicroMenu",
}

R.Define{
    key = "addonDetect", label = "mod_addonDetect", group = "general",
    enabledPath = "addonDetect.enabled",
    contextSwap = false,
    global = "TomoMod_AddonDetect",
}

R.Define{
    key = "diagnostics", label = "mod_diagnostics", group = "general",
    enabledPath = "diagnostics.enabled",
    contextSwap = false,
}

-- ---------------------------------------------------------------------
-- SKINS
-- ---------------------------------------------------------------------
-- Every module in this group installs hooksecurefunc hooks, which
-- cannot be uninstalled. They are all marked requiresReload for now.
-- ---------------------------------------------------------------------

R.Define{
    key = "objectiveTracker", label = "mod_objectiveTracker", group = "skins",
    enabledPath = "objectiveTracker.enabled",
    anchors = { { id = "objectiveTracker", path = "objectiveTracker.position", shape = "point_relativePoint", label = "frame_objectivetracker" } },
    global = "TomoMod_ObjectiveTracker", applyMode = "pair",
}

R.Define{
    key = "reputationBar", label = "mod_reputationBar", group = "skins",
    enabledPath = "reputationBar.enabled",
    requiresReload = true,
    global = "TomoMod_ReputationBar",
}

R.Define{
    key = "tooltipSkin", label = "mod_tooltipSkin", group = "skins",
    enabledPath = "tooltipSkin.enabled",
    global = "TomoMod_TooltipSkin", applyMode = "gate", apply = "ApplySettings",
    combatSafe = true,
}

R.Define{
    key = "chatV4", label = "mod_chatFrameSkin", group = "skins",
    enabledPath = "chatV4.enabled",
    anchors = { { id = "chatV4", path = "chatV4.position", shape = "point_relativePoint", label = "frame_chat_v4" } },
    global = "TomoMod_ChatFrameSkin", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

-- Migration-only roots. They stay in the registry as internal entries while
-- old profiles are still accepted, but no GUI/import/content-profile list
-- exposes them as modules anymore.
R.Define{
    key = "chatFrameSkin", label = "mod_chatFrameSkin", internal = true,
    enabledPath = "chatFrameSkin.enabled",
    requiresReload = true,
}

R.Define{
    key = "chatFrameSkinV2", label = "mod_chatFrameSkinV2", internal = true,
    enabledPath = "chatFrameSkinV2.enabled",
    requiresReload = true,
}

R.Define{
    key = "chatFrameUI", label = "mod_chatFrameUI", internal = true,
    enabledPath = "chatFrameUI.enabled",
    requiresReload = true,
}

R.Define{
    key = "bagSkin", label = "mod_bagSkin", group = "skins",
    enabledPath = "bagSkin.enabled",
    -- No anchor any more: the legacy BagSkin frame is gone, and BagCore
    -- migrates bagSkin.position into bagsV4.position once. The Bags V4
    -- window is the only movable bag frame (anchor "bagsV4" below).
    global = "TomoMod_BagSkin", applyMode = "setter", apply = "SetEnabled",
}

R.Define{
    key = "bagsV4", label = "mod_bagsV4", group = "skins",
    -- Pas de flag propre : l'affichage des sacs v4 est pilote par bagSkin.
    -- Seule la position lui appartient, et elle doit etre declaree pour que le
    -- moteur de layout la migre, l'estampille et la capture dans un preset.
    anchors = { { id = "bagsV4", path = "bagsV4.position", shape = "point_relativePoint", label = "frame_bags_v4" } },
}

R.Define{
    key = "gameMenuSkin", label = "mod_gameMenuSkin", group = "skins",
    enabledPath = "gameMenuSkin.enabled",
    global = "TomoMod_GameMenuSkin", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

R.Define{
    key = "blizzardAuraFrames", label = "mod_blizzardAuraFrames", group = "skins",
    enabledPath = "blizzardAuraFrames.enabled",
    global = "TomoMod_BlizzardAuraFrames", applyMode = "gate", apply = "ApplySettings",
    combatSafe = true,
}

R.Define{
    key = "actionBarSkin", label = "mod_actionBarSkin", group = "skins",
    enabledPath = "barSkin.enabled",
    global = "TomoMod_ActionBarSkin", applyMode = "gate", apply = "ApplySettings",
    combatSafe = true,
}

R.Define{
    key = "mailSkin", label = "mod_mailSkin", group = "skins",
    enabledPath = "mailSkin.enabled",
    requiresReload = true,
}

-- ---------------------------------------------------------------------
-- UNIT FRAMES
-- ---------------------------------------------------------------------

R.Define{
    key = "unitFrames", label = "mod_unitFrames", group = "unitframes",
    enabledPath = "unitFrames.enabled",
    forgeDomain = "unitframes",
    anchors = {
        { id = "unitFrames.player",       path = "unitFrames.player.position",       shape = "point_relativePoint", label = "frame_player" },
        { id = "unitFrames.target",       path = "unitFrames.target.position",       shape = "point_relativePoint", label = "frame_target" },
        { id = "unitFrames.targettarget", path = "unitFrames.targettarget.position", shape = "point_relativePoint", label = "frame_targettarget" },
        { id = "unitFrames.focus",        path = "unitFrames.focus.position",        shape = "point_relativePoint", label = "frame_focus" },
        { id = "unitFrames.pet",          path = "unitFrames.pet.position",          shape = "point_relativePoint", label = "frame_pet" },
        { id = "unitFrames.bossFrames",   path = "unitFrames.bossFrames.position",   shape = "point_relativePoint", label = "frame_boss" },
        { id = "unitFrames.target.auras", path = "unitFrames.target.auras.position", shape = "point_relativePoint", label = "frame_target_auras" },
        { id = "unitFrames.focus.auras",  path = "unitFrames.focus.auras.position",  shape = "point_relativePoint", label = "frame_focus_auras" },
    },
    global = "TomoMod_UnitFrames", applyMode = "setter", apply = "SetEnabled",
}

R.Define{
    key = "castbars", label = "mod_castbars", group = "unitframes",
    enabledPath = "castbars.enabled",
    anchors = {
        { id = "castbars.player", path = "castbars.player.position", shape = "point_relativePoint", label = "frame_cast_player" },
        { id = "castbars.target", path = "castbars.target.position", shape = "point_relativePoint", label = "frame_cast_target" },
        { id = "castbars.focus",  path = "castbars.focus.position",  shape = "point_relativePoint", label = "frame_cast_focus" },
        { id = "castbars.pet",    path = "castbars.pet.position",    shape = "point_relativePoint", label = "frame_cast_pet" },
        { id = "castbars.boss",   path = "castbars.boss.position",   shape = "point_relativePoint", label = "frame_cast_boss" },
    },
    global = "TomoMod_Castbar", applyMode = "setter", apply = "SetEnabled",
}

R.Define{
    key = "resourceBars", label = "mod_resourceBars", group = "unitframes",
    enabledPath = "resourceBars.enabled",
    anchors = { { id = "resourceBars", path = "resourceBars.position", shape = "point_relativePoint", label = "frame_resources" } },
    global = "TomoMod_ResourceBars", applyMode = "setter", apply = "SetEnabled",
}

-- ---------------------------------------------------------------------
-- PARTY & RAID
-- ---------------------------------------------------------------------

R.Define{
    key = "partyFrames", label = "mod_partyFrames", group = "groupframes",
    enabledPath = "partyFrames.enabled",
    anchors = {
        { id = "partyFrames",       path = "partyFrames.position",       shape = "point_relativePoint", label = "frame_party" },
    },
    global = "TomoMod_PartyFrames", applyMode = "setter", apply = "SetEnabled",
}

R.Define{
    key = "raidFrames", label = "mod_raidFrames", group = "groupframes",
    enabledPath = "raidFrames.enabled",
    anchors = { { id = "raidFrames", path = "raidFrames.position", shape = "point_anchor", label = "frame_raid" } },
    global = "TomoMod_RaidFrames", applyMode = "setter", apply = "SetEnabled",
}

R.Define{
    key = "battleRez", label = "mod_battleRez", group = "groupframes",
    enabledPath = "battleRez.enabled",
    anchors = { { id = "battleRez", path = "battleRez.position", shape = "point_relativePoint", label = "frame_battlerez" } },
    global = "TomoMod_ResurrectTracker",
}

R.Define{
    key = "healerStudio", label = "mod_healerStudio", group = "groupframes",
    toggles = {
        { path = "healerStudio.party.enabled", label = "mod_healerStudio_party" },
        { path = "healerStudio.raid.enabled",  label = "mod_healerStudio_raid"  },
    },
}

-- ---------------------------------------------------------------------
-- NAMEPLATES
-- ---------------------------------------------------------------------

R.Define{
    key = "nameplates", label = "mod_nameplates", group = "nameplates",
    enabledPath = "nameplates.enabled",
    forgeDomain = "nameplates",
    global = "TomoMod_Nameplates", applyMode = "pair",
}

-- ---------------------------------------------------------------------
-- COOLDOWNS
-- ---------------------------------------------------------------------

R.Define{
    key = "cooldownManager", label = "mod_cooldownManager", group = "cooldowns",
    enabledPath = "cooldownManager.enabled",
    global = "TomoMod_CooldownManager", applyMode = "setter", apply = "SetEnabled",
}

R.Define{
    key = "cooldownForge", label = "mod_cooldownForge", group = "cooldowns",
    enabledPath = "cooldownForge.enabled",
}

-- The editor for Cooldown Forge, shipped as a LoadOnDemand sibling. It
-- holds one safety flag and no gameplay setting, so it is passive and
-- pinned: an editor should not open or close because the player zoned
-- into a key.
R.Define{
    key = "CDStudio", label = "mod_CDStudio", group = "cooldowns",
    deps = { "cooldownForge" },
    contextSwap = false,
}

-- ---------------------------------------------------------------------
-- QUALITY OF LIFE
-- ---------------------------------------------------------------------

R.Define{
    key = "cinematicSkip", label = "mod_cinematicSkip", group = "qol",
    enabledPath = "cinematicSkip.enabled",
    global = "TomoMod_CinematicSkip",
}

R.Define{
    key = "autoQuest", label = "mod_autoQuest", group = "qol",
    toggles = {
        { path = "autoQuest.autoAccept", label = "mod_autoQuest_accept" },
        { path = "autoQuest.autoTurnIn", label = "mod_autoQuest_turnin" },
        { path = "autoQuest.autoGossip", label = "mod_autoQuest_gossip" },
    },
    global = "TomoMod_AutoQuest",
}

R.Define{
    key = "rareAlert", label = "mod_rareAlert", group = "qol",
    enabledPath = "rareAlert.enabled",
    global = "TomoMod_RareAlert", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

R.Define{
    key = "autoAcceptInvite", label = "mod_autoAcceptInvite", group = "qol",
    enabledPath = "autoAcceptInvite.enabled",
    global = "TomoMod_AutoAcceptInvite", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

R.Define{
    key = "autoSkipRole", label = "mod_autoSkipRole", group = "qol",
    enabledPath = "autoSkipRole.enabled",
    global = "TomoMod_AutoSkipRole", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

R.Define{
    key = "autoSummon", label = "mod_autoSummon", group = "qol",
    enabledPath = "autoSummon.enabled",
    global = "TomoMod_AutoSummon", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

R.Define{
    key = "hideCastBar", label = "mod_hideCastBar", group = "qol",
    enabledPath = "hideCastBar.enabled",
    global = "TomoMod_HideCastBar", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

R.Define{
    key = "hideTalkingHead", label = "mod_hideTalkingHead", group = "qol",
    enabledPath = "hideTalkingHead.enabled",
    global = "TomoMod_HideTalkingHead", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

R.Define{
    key = "hideStatusBar2", label = "mod_hideStatusBar2", group = "qol",
    enabledPath = "hideStatusBar2.enabled",
}

R.Define{
    key = "fastLoot", label = "mod_fastLoot", group = "qol",
    enabledPath = "fastLoot.enabled",
    global = "TomoMod_FastLoot", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

R.Define{
    key = "combatText", label = "mod_combatText", group = "qol",
    enabledPath = "combatText.enabled",
    global = "TomoMod_CombatText", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

R.Define{
    key = "floatingCombatText", label = "mod_floatingCombatText", group = "qol",
    toggles = {
        { path = "floatingCombatText.hideDamage", label = "opt_hide_fct_damage" },
        { path = "floatingCombatText.hideHealing", label = "opt_hide_fct_healing" },
    },
    global = "TomoMod_CombatText", applyMode = "gate", apply = "ApplyFloatingTextSettings",
    combatSafe = true,
}

R.Define{
    key = "autoFillDelete", label = "mod_autoFillDelete", group = "qol",
    enabledPath = "autoFillDelete.enabled",
    global = "TomoMod_AutoFillDelete", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

R.Define{
    key = "autoVendorRepair", label = "mod_autoVendorRepair", group = "qol",
    toggles = {
        { path = "autoVendorRepair.sellGrays",    label = "mod_autoVendorRepair_sell"    },
        { path = "autoVendorRepair.autoRepair",   label = "mod_autoVendorRepair_repair"  },
        { path = "autoVendorRepair.printSummary", label = "mod_autoVendorRepair_summary" },
    },
}

R.Define{
    key = "merchantTools", label = "mod_merchantTools", group = "qol",
    toggles = {
        { path = "merchantTools.alreadyKnown.enabled", label = "mod_merchantTools_known" },
        { path = "merchantTools.extendPages.enabled",  label = "mod_merchantTools_pages" },
    },
}

R.Define{
    key = "waypoint", label = "mod_waypoint", group = "qol",
    enabledPath = "waypoint.enabled",
    global = "TomoMod_Waypoint",
}

R.Define{
    key = "afkDisplay", label = "mod_afkDisplay", group = "qol",
    enabledPath = "afkDisplay.enabled",
    global = "TomoMod_AFKDisplay", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

R.Define{
    key = "lustSound", label = "mod_lustSound", group = "qol",
    enabledPath = "lustSound.enabled",
    global = "TomoMod_LustSound", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

-- WoW: Forever extras (1.1.0).
R.Define{
    key = "campfire", label = "mod_campfire", group = "qol",
    enabledPath = "campfire.enabled",
    anchors = { { id = "campfire", path = "campfire.position", shape = "point_relativePoint", label = "mod_campfire" } },
    global = "TomoMod_Campfire", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

R.Define{
    key = "xpEdge", label = "mod_xpEdge", group = "qol",
    enabledPath = "xpEdge.enabled",
    global = "TomoMod_EdgeXP", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

-- Click-to-cast icons are secure buttons: switched out of combat only.
R.Define{
    key = "missingBuffs", label = "mod_missingBuffs", group = "qol",
    enabledPath = "missingBuffs.enabled",
    anchors = { { id = "missingBuffs", path = "missingBuffs.position", shape = "point_relativePoint", label = "mod_missingBuffs" } },
    global = "TomoMod_MissingBuffs", applyMode = "setter", apply = "SetEnabled",
}

-- 1.2.0: adventure comforts. No master switch: each toggle stands alone
-- and Apply() re-reads them all.
R.Define{
    key = "adventureTweaks", label = "mod_adventureTweaks", group = "qol",
    toggles = {
        { path = "adventureTweaks.autoRes",    label = "mod_adventureTweaks_autoRes"    },
        { path = "adventureTweaks.hideErrors", label = "mod_adventureTweaks_hideErrors" },
        { path = "adventureTweaks.trainAll",   label = "mod_adventureTweaks_trainAll"   },
    },
    global = "TomoMod_AdventureTweaks", applyMode = "gate", apply = "Apply",
    combatSafe = true,
}

R.Define{
    key = "triage", label = "mod_triage", group = "qol",
    toggles = {
        { path = "triage.enabled", label = "mod_triage_enabled" },
    },
    global = "TomoMod_Triage", applyMode = "gate", apply = "ApplySettings",
    combatSafe = true,
}

R.Define{
    key = "mapReveal", label = "mod_mapReveal", group = "qol",
    toggles = {
        { path = "mapReveal.enabled", label = "mod_mapReveal_enabled" },
    },
    global = "TomoMod_MapReveal", applyMode = "gate", apply = "ApplySettings",
    combatSafe = true,
}

R.Define{
    key = "cameraFx", label = "mod_cameraFx", group = "qol",
    toggles = {
        { path = "cameraFx.maxZoom",     label = "mod_cameraFx_maxZoom"     },
        { path = "cameraFx.noDrunkHaze", label = "mod_cameraFx_noDrunkHaze" },
        { path = "cameraFx.noDeathFx",   label = "mod_cameraFx_noDeathFx"   },
    },
    global = "TomoMod_CVarOptimizer", applyMode = "gate", apply = "ApplyComfort",
    combatSafe = true,
}

R.Define{
    key = "bagAlert", label = "mod_bagAlert", group = "qol",
    enabledPath = "bagAlert.enabled",
    anchors = { { id = "bagAlert", path = "bagAlert.position", shape = "point_relativePoint", label = "mod_bagAlert" } },
    global = "TomoMod_BagAlert", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

R.Define{
    key = "trainerReminder", label = "mod_trainerReminder", group = "qol",
    enabledPath = "trainerReminder.enabled",
    anchors = { { id = "trainerReminder", path = "trainerReminder.position", shape = "point_relativePoint", label = "mod_trainerReminder" } },
    global = "TomoMod_TrainerReminder", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

R.Define{
    key = "dungeonCodex", label = "mod_dungeonCodex", group = "qol",
    enabledPath = "dungeonCodex.enabled",
    global = "TomoMod_DungeonCodex", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

R.Define{
    key = "flightTimer", label = "mod_flightTimer", group = "qol",
    enabledPath = "flightTimer.enabled",
    anchors = { { id = "flightTimer", path = "flightTimer.position", shape = "point_relativePoint", label = "mod_flightTimer" } },
    global = "TomoMod_FlightTimer", applyMode = "setter", apply = "SetEnabled",
    combatSafe = true,
}

-- ---------------------------------------------------------------------
-- INTERNAL
-- ---------------------------------------------------------------------
-- State, not settings. Declared so the coverage test can prove that
-- every key of TomoMod_Defaults was considered, and so that nothing
-- here is ever offered in a selective import.
-- ---------------------------------------------------------------------

-- Le module Micro Bar a ete supprime, mais sa table de reglages est encore
-- lue par BagMicroMenu et le panneau Confort (lfgEyeEnabled, positions des
-- boutons). Declaree interne : la cle reste couverte par la bijection
-- manifeste <-> defaults sans etre proposee a l'import ni au cycle de vie.
R.Define{ key = "microBar",         internal = true }
R.Define{ key = "forgeAssets",      internal = true }
R.Define{ key = "resourceCastStudio", internal = true } -- studio tutorial/preview state
R.Define{ key = "installer",        internal = true }
R.Define{ key = "cvarOptimizer",    internal = true }
R.Define{ key = "lastSeenVersion",  internal = true }
