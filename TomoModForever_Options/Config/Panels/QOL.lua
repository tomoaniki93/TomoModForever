-- =====================================
-- Panels/QOL.lua — QOL Modules Config (Tabbed)
-- =====================================

local W = TomoMod_Widgets
local L = TomoMod_L

-- =====================================
-- TAB 1: CINEMATIC SKIP
-- =====================================

local function BuildCinematicTab(parent)
    local scroll = W.CreateScrollPanel(parent)
    local c = scroll.child
    local y = -10

    local _, ny = W.CreateSectionHeader(c, L["section_cinematic"], y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_cinematic_auto_skip"], TomoModForeverDB.cinematicSkip.enabled, y, function(v)
        TomoModForeverDB.cinematicSkip.enabled = v
        if v and TomoMod_CinematicSkip then TomoMod_CinematicSkip.Initialize() end
    end)
    y = ny

    local viewedStr = "0"
    if TomoMod_CinematicSkip and TomoMod_CinematicSkip.GetViewedCount then
        viewedStr = tostring(TomoMod_CinematicSkip.GetViewedCount())
    end
    local _, ny = W.CreateInfoText(c, string.format(L["info_cinematic_viewed"], viewedStr), y)
    y = ny

    local _, ny = W.CreateButton(c, L["btn_clear_history"], 180, y, function()
        if TomoMod_CinematicSkip then TomoMod_CinematicSkip.ClearHistory() end
    end)
    y = ny

    c:SetHeight(math.abs(y) + 40)
    if scroll.UpdateScroll then scroll.UpdateScroll() end
    return scroll
end

-- =====================================
-- TAB 2: AUTO QUEST
-- =====================================

local function BuildAutoQuestTab(parent)
    local scroll = W.CreateScrollPanel(parent)
    local c = scroll.child
    local y = -10

    local _, ny = W.CreateSectionHeader(c, L["section_auto_quest"], y)
    y = ny

    local _, ny = W.CreateCheckboxPair(c,
        L["opt_quest_auto_accept"], TomoModForeverDB.autoQuest.autoAccept, y,
        function(v) TomoModForeverDB.autoQuest.autoAccept = v end,
        L["opt_quest_auto_turnin"], TomoModForeverDB.autoQuest.autoTurnIn,
        function(v) TomoModForeverDB.autoQuest.autoTurnIn = v end)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_quest_auto_gossip"], TomoModForeverDB.autoQuest.autoGossip, y, function(v)
        TomoModForeverDB.autoQuest.autoGossip = v
    end)
    y = ny

    local _, ny = W.CreateInfoText(c, L["info_quest_shift"], y)
    y = ny

    c:SetHeight(math.abs(y) + 40)
    if scroll.UpdateScroll then scroll.UpdateScroll() end
    return scroll
end

-- =====================================
-- TAB 3: AUTOMATIONS (castbar, invite, summon, fill delete)
-- =====================================

local function BuildAutomationsTab(parent)
    local scroll = W.CreateScrollPanel(parent)
    local c = scroll.child
    local y = -10

    local _, ny = W.CreateSectionHeader(c, L["section_automations"], y)
    y = ny

    -- Hide Blizzard Castbar
    local _, ny = W.CreateCheckbox(c, L["opt_hide_blizzard_castbar"], TomoModForeverDB.hideCastBar.enabled, y, function(v)
        if TomoMod_HideCastBar then TomoMod_HideCastBar.SetEnabled(v) end
    end)
    y = ny

    -- Hide Talking Head
    local _, ny = W.CreateCheckbox(c, L["opt_hide_talking_head"], TomoModForeverDB.hideTalkingHead.enabled, y, function(v)
        if TomoMod_HideTalkingHead then TomoMod_HideTalkingHead.SetEnabled(v) end
    end)
    y = ny

    -- Hide Blizzard Status Bar 2
    local sb2, ny = W.CreateCheckbox(c, L["opt_hide_status_bar2"],
        TomoModForeverDB.hideStatusBar2.enabled, y, function(v)
            TomoModForeverDB.hideStatusBar2.enabled = v
            if v and TomoMod_ReputationBar_ApplySuppression then
                TomoMod_ReputationBar_ApplySuppression()
            end
        end)
    W.SetTooltip(sb2, L["opt_hide_status_bar2_desc"])
    y = ny

    -- Auto Accept Invite
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSubLabel(c, L["sublabel_auto_accept_invite"], y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_auto_accept_invite_enable"], TomoModForeverDB.autoAcceptInvite.enabled, y, function(v)
        TomoModForeverDB.autoAcceptInvite.enabled = v
    end)
    y = ny

    local _, ny = W.CreateCheckboxPair(c,
        L["opt_accept_friends"], TomoModForeverDB.autoAcceptInvite.acceptFriends, y,
        function(v) TomoModForeverDB.autoAcceptInvite.acceptFriends = v end,
        L["opt_accept_guild"],   TomoModForeverDB.autoAcceptInvite.acceptGuild,
        function(v) TomoModForeverDB.autoAcceptInvite.acceptGuild = v end)
    y = ny

    -- Auto Skip Role
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSubLabel(c, L["sublabel_auto_skip_role"], y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_auto_skip_role_enable"], TomoModForeverDB.autoSkipRole.enabled, y, function(v)
        TomoModForeverDB.autoSkipRole.enabled = v
        if TomoMod_AutoSkipRole then TomoMod_AutoSkipRole.SetEnabled(v) end
    end)
    y = ny

    -- Auto Summon
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSubLabel(c, L["sublabel_auto_summon"], y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_auto_summon_enable"], TomoModForeverDB.autoSummon.enabled, y, function(v)
        TomoModForeverDB.autoSummon.enabled = v
    end)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_accept_friends"], TomoModForeverDB.autoSummon.acceptFriends, y, function(v)
        TomoModForeverDB.autoSummon.acceptFriends = v
    end)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_accept_guild"], TomoModForeverDB.autoSummon.acceptGuild, y, function(v)
        TomoModForeverDB.autoSummon.acceptGuild = v
    end)
    y = ny

    local _, ny = W.CreateSlider(c, L["opt_summon_delay"], TomoModForeverDB.autoSummon.delaySec, 0, 10, 1, y, function(v)
        TomoModForeverDB.autoSummon.delaySec = v
    end)
    y = ny

    -- Auto Fill Delete
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSubLabel(c, L["sublabel_auto_fill_delete"], y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_auto_fill_delete_enable"], TomoModForeverDB.autoFillDelete.enabled, y, function(v)
        TomoModForeverDB.autoFillDelete.enabled = v
    end)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_focus_ok_button"], TomoModForeverDB.autoFillDelete.focusButton, y, function(v)
        TomoModForeverDB.autoFillDelete.focusButton = v
    end)
    y = ny

    -- Auto Vendor / Repair
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSubLabel(c, L["sublabel_auto_vendor_repair"], y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_avr_auto_repair"],
        TomoModForeverDB.autoVendorRepair.autoRepair, y, function(v)
        TomoModForeverDB.autoVendorRepair.autoRepair = v
    end)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_avr_sell_grays"],
        TomoModForeverDB.autoVendorRepair.sellGrays, y, function(v)
        TomoModForeverDB.autoVendorRepair.sellGrays = v
    end)
    y = ny

    -- Combat Text
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSubLabel(c, L["sublabel_combat_text"], y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_combat_text_enable"], TomoModForeverDB.combatText.enabled, y, function(v)
        TomoModForeverDB.combatText.enabled = v
        if TomoMod_CombatText then TomoMod_CombatText.SetEnabled(v) end
    end)
    y = ny

    local _, ny = W.CreateSlider(c, L["opt_combat_text_offset_x"], TomoModForeverDB.combatText.offsetX, -200, 200, 1, y, function(v)
        TomoModForeverDB.combatText.offsetX = v
        if TomoMod_CombatText then TomoMod_CombatText.UpdatePosition() end
    end)
    y = ny

    local _, ny = W.CreateSlider(c, L["opt_combat_text_offset_y"], TomoModForeverDB.combatText.offsetY, -200, 200, 1, y, function(v)
        TomoModForeverDB.combatText.offsetY = v
        if TomoMod_CombatText then TomoMod_CombatText.UpdatePosition() end
    end)
    y = ny

    c:SetHeight(math.abs(y) + 40)
    if scroll.UpdateScroll then scroll.UpdateScroll() end
    return scroll
end

-- =====================================
-- TAB: CVAR OPTIMIZER
-- =====================================

local function BuildCVarOptimizerTab(parent)
    local OPT = TomoMod_CVarOptimizer
    if not OPT then return W.CreateScrollPanel(parent) end

    local scroll = W.CreateScrollPanel(parent)
    local c = scroll.child

    -- Palette locale (reprend T.accent du thème)
    local TEAL   = { TomoMod_Utils.BRAND[1], TomoMod_Utils.BRAND[2], TomoMod_Utils.BRAND[3] }
    local ORANGE = { 1.0,   0.65,  0.10  }
    local RED    = { 0.9,   0.25,  0.25  }
    local DIM    = { 0.66,  0.62,  0.54  }
    local FONT   = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
    local FONT_B = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Bold.ttf"

    local y = -10

    -- ── En-tête ──────────────────────────────────────────────────
    local _, ny = W.CreateSectionHeader(c, L["section_cvar_optimizer"], y)
    y = ny

    local _, ny = W.CreateInfoText(c, L["info_cvar_optimizer"], y)
    y = ny

    -- ── Boutons Apply All / Revert All ───────────────────────────
    local applyAllBtn, ny2 = W.CreateButton(c, L["btn_cvar_apply_all"], 160, y, function()
        OPT.ApplyAll()
        -- Refresh toutes les lignes via leur update callback
        for _, child in ipairs(c.cvarRows or {}) do
            if child.Refresh then child:Refresh() end
        end
    end)
    y = ny2

    local revertAllBtn, ny3 = W.CreateButton(c, L["btn_cvar_revert_all"], 160, y, function()
        OPT.RevertAll()
        for _, child in ipairs(c.cvarRows or {}) do
            if child.Refresh then child:Refresh() end
        end
    end)
    -- Placer Revert All à droite de Apply All
    revertAllBtn:ClearAllPoints()
    revertAllBtn:SetPoint("LEFT", applyAllBtn, "RIGHT", 10, 0)
    y = y  -- ny3 déjà avancé par Apply All

    local _, ny = W.CreateSeparator(c, y)
    y = ny

    -- ── Helper : couleur selon statut ────────────────────────────
    local function StatusColor(isOptimal)
        if isOptimal then return TEAL[1], TEAL[2], TEAL[3]
        else               return ORANGE[1], ORANGE[2], ORANGE[3] end
    end

    -- ── Création d'une ligne CVar ─────────────────────────────────
    -- Layout : [Nom 170px] [Valeur actuelle 90px] [→] [Optimal 90px] [Apply 70px] [Revert 70px]
    local ROW_H   = 26
    local COL_VAL = 158   -- x valeur actuelle
    local COL_SEP = 248   -- x séparateur ->
    local COL_OPT = 264   -- x valeur optimale
    local COL_APP = 372   -- x bouton Apply
    local COL_REV = 442   -- x bouton Revert

    c.cvarRows = {}

    local function CreateCVarRow(entry, yRow)
        local row = CreateFrame("Frame", nil, c)
        row:SetSize(c:GetWidth() - 20, ROW_H)
        row:SetPoint("TOPLEFT", c, "TOPLEFT", 16, yRow)

        -- Fond alternant léger
        local bg = row:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        bg:SetColorTexture(0, 0, 0, 0)

        -- Nom de la CVar
        local nameFS = row:CreateFontString(nil, "OVERLAY")
        nameFS:SetFont(FONT, 11, "")
        nameFS:SetPoint("LEFT", 0, 0)
        nameFS:SetWidth(COL_VAL - 10)
        nameFS:SetJustifyH("LEFT")
        nameFS:SetText(L[entry.labelKey] or entry.cvar)
        nameFS:SetTextColor(0.90, 0.90, 0.92)

        -- Valeur actuelle
        local curFS = row:CreateFontString(nil, "OVERLAY")
        curFS:SetFont(FONT, 11, "OUTLINE")
        curFS:SetPoint("LEFT", COL_VAL, 0)
        curFS:SetWidth(82)
        curFS:SetJustifyH("LEFT")

        -- Flèche
        local arrFS = row:CreateFontString(nil, "OVERLAY")
        arrFS:SetFont(FONT, 10, "")
        arrFS:SetPoint("LEFT", COL_SEP, 0)
        arrFS:SetTextColor(unpack(DIM))
        arrFS:SetText("->")

        -- Valeur optimale
        local optFS = row:CreateFontString(nil, "OVERLAY")
        optFS:SetFont(FONT_B, 11, "OUTLINE")
        optFS:SetPoint("LEFT", COL_OPT, 0)
        optFS:SetWidth(100)
        optFS:SetJustifyH("LEFT")
        optFS:SetText(OPT.FormatValue(entry.cvar, entry.optimal))
        optFS:SetTextColor(unpack(TEAL))

        -- Bouton Apply
        local appBtn = CreateFrame("Button", nil, row, "BackdropTemplate")
        appBtn:SetSize(62, 20)
        appBtn:SetPoint("LEFT", COL_APP, 0)
        appBtn:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8",
                              edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
        appBtn:SetBackdropColor(0.035, 0.60, 0.45, 1)
        appBtn:SetBackdropBorderColor(TomoMod_Utils.BRAND[1], TomoMod_Utils.BRAND[2], TomoMod_Utils.BRAND[3], 1)
        local appLabel = appBtn:CreateFontString(nil, "OVERLAY")
        appLabel:SetFont(FONT, 10, "")
        appLabel:SetPoint("CENTER")
        appLabel:SetText(L["btn_cvar_apply"])
        appLabel:SetTextColor(1, 1, 1, 1)
        appBtn:SetScript("OnEnter", function() appBtn:SetBackdropColor(TomoMod_Utils.BRAND[1], TomoMod_Utils.BRAND[2], TomoMod_Utils.BRAND[3], 1); appLabel:SetTextColor(0.05, 0.05, 0.08, 1) end)
        appBtn:SetScript("OnLeave", function() appBtn:SetBackdropColor(0.035, 0.60, 0.45, 1); appLabel:SetTextColor(1, 1, 1, 1) end)

        -- Bouton Revert
        local revBtn = CreateFrame("Button", nil, row, "BackdropTemplate")
        revBtn:SetSize(62, 20)
        revBtn:SetPoint("LEFT", COL_REV, 0)
        revBtn:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8",
                              edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
        revBtn:SetBackdropColor(0.20, 0.08, 0.08, 1)
        revBtn:SetBackdropBorderColor(0.60, 0.20, 0.20, 1)
        local revLabel = revBtn:CreateFontString(nil, "OVERLAY")
        revLabel:SetFont(FONT, 10, "")
        revLabel:SetPoint("CENTER")
        revLabel:SetText(L["btn_cvar_revert"])
        revLabel:SetTextColor(1, 1, 1, 1)
        revBtn:SetScript("OnEnter", function() revBtn:SetBackdropColor(0.60, 0.20, 0.20, 1); revLabel:SetTextColor(1, 1, 1, 1) end)
        revBtn:SetScript("OnLeave", function() revBtn:SetBackdropColor(0.20, 0.08, 0.08, 1); revLabel:SetTextColor(1, 1, 1, 1) end)

        -- Tooltip hover sur le nom
        row:EnableMouse(true)
        row:SetScript("OnEnter", function()
            GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
            GameTooltip:SetText(entry.cvar, 1, 0.8, 0.2, 1, true)
            local raw = OPT.GetRaw(entry.cvar)
            GameTooltip:AddLine(string.format(W.Loc("cvar_tip_current", "Current: %s"), tostring(raw or "?")), 0.8, 0.8, 0.8)
            GameTooltip:AddLine(string.format(W.Loc("cvar_tip_optimal", "Optimal: %s"), tostring(entry.optimal)), TomoMod_Utils.BRAND[1], TomoMod_Utils.BRAND[2], TomoMod_Utils.BRAND[3])
            GameTooltip:Show()
        end)
        row:SetScript("OnLeave", function() GameTooltip:Hide() end)

        -- Fonction de rafraîchissement
        local function Refresh()
            local raw = OPT.GetRaw(entry.cvar)
            local isOpt = OPT.IsOptimal(entry.cvar, entry.optimal)
            curFS:SetText(OPT.FormatValue(entry.cvar, raw))
            curFS:SetTextColor(StatusColor(isOpt))

            -- Revert dispo seulement si backup individuel existe
            local hasBackup = OPT.HasIndividualBackup(entry.cvar)
            revBtn:SetEnabled(hasBackup)
            revBtn:SetAlpha(hasBackup and 1 or 0.4)
        end
        Refresh()

        appBtn:SetScript("OnClick", function()
            OPT.ApplyOne(entry.cvar, entry.optimal)
            C_Timer.After(0.05, Refresh)
        end)

        revBtn:SetScript("OnClick", function()
            OPT.RevertOne(entry.cvar)
            C_Timer.After(0.05, Refresh)
        end)

        row.Refresh = Refresh
        table.insert(c.cvarRows, row)

        return row, yRow - ROW_H - 2
    end

    -- ── Rendu par catégorie ───────────────────────────────────────
    for _, cat in ipairs(OPT.CATEGORIES) do
        local _, ny = W.CreateSectionHeader(c, L[cat.labelKey] or cat.key, y)
        y = ny

        for _, entry in ipairs(OPT.CVARS) do
            if entry.category == cat.key then
                local _, newY = CreateCVarRow(entry, y)
                y = newY
            end
        end

        local _, ny = W.CreateSeparator(c, y)
        y = ny
    end

    -- ── Refresh All visible au scroll ─────────────────────────────
    -- Rafraîchit toutes les lignes à l'ouverture du panneau (CVar peuvent changer hors addon)
    scroll:SetScript("OnShow", function()
        for _, row in ipairs(c.cvarRows) do
            if row.Refresh then row:Refresh() end
        end
        -- Griser Revert All si pas de backup global
        revertAllBtn:SetEnabled(OPT.HasGlobalBackup())
        revertAllBtn:SetAlpha(OPT.HasGlobalBackup() and 1 or 0.4)
    end)

    c:SetHeight(math.abs(y) + 40)
    if scroll.UpdateScroll then scroll.UpdateScroll() end
    return scroll
end

-- =====================================
-- TAB: BAG & MICRO MENU
-- =====================================

local function BuildBagMicroMenuTab(parent)
    local scroll = W.CreateScrollPanel(parent)
    local c = scroll.child
    local y = -10

    local _, ny = W.CreateSectionHeader(c, L["section_bag_micro"], y)
    y = ny

    local _, ny = W.CreateInfoText(c, L["info_bag_micro"], y)
    y = ny

    -- Bag Bar
    local _, ny = W.CreateSeparator(c, y)
    y = ny

    local bagModeOptions = {
        { value = "show",  text = L["mode_show"] },
        { value = "hover", text = L["mode_hover"] },
    }

    local _, ny = W.CreateSegmentedControl(c, L["opt_bag_bar_mode"],
        bagModeOptions,
        TomoModForeverDB.bagMicroMenu and TomoModForeverDB.bagMicroMenu.bagBarMode or "show",
        y, function(v)
        if not TomoModForeverDB.bagMicroMenu then TomoModForeverDB.bagMicroMenu = {} end
        TomoModForeverDB.bagMicroMenu.bagBarMode = v
        if TomoMod_BagMicroMenu then TomoMod_BagMicroMenu.SetBagBarMode(v) end
    end, 2)
    y = ny

    -- Micro Menu
    local _, ny = W.CreateSeparator(c, y)
    y = ny

    local microModeOptions = {
        { value = "show",  text = L["mode_show"] },
        { value = "hover", text = L["mode_hover"] },
    }

    local _, ny = W.CreateSegmentedControl(c, L["opt_micro_menu_mode"],
        microModeOptions,
        TomoModForeverDB.bagMicroMenu and TomoModForeverDB.bagMicroMenu.microMenuMode or "show",
        y, function(v)
        if not TomoModForeverDB.bagMicroMenu then TomoModForeverDB.bagMicroMenu = {} end
        TomoModForeverDB.bagMicroMenu.microMenuMode = v
        if TomoMod_BagMicroMenu then TomoMod_BagMicroMenu.SetMicroMenuMode(v) end
    end, 2)
    y = ny

    -- Œil LFG Blizzard natif : on conserve uniquement ON/OFF + taille.
    local function EyeDB()
        if not TomoModForeverDB.microBar then TomoModForeverDB.microBar = {} end
        return TomoModForeverDB.microBar
    end

    local _, ny = W.CreateSeparator(c, y)
    y = ny

    local _, ny = W.CreateSectionHeader(c, "Œil de recherche de groupe", y)
    y = ny

    local _, ny = W.CreateInfoText(c,
        "Le micro menu Blizzard n'est plus remplacé. TomoMod gère uniquement son affichage (toujours visible ou au survol) et l'œil LFG ci-dessous.",
        y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_microbar_lfg_eye"],
        EyeDB().lfgEyeEnabled ~= false, y, function(v)
            if TomoMod_BagMicroMenu and TomoMod_BagMicroMenu.SetLFGEyeEnabled then
                TomoMod_BagMicroMenu.SetLFGEyeEnabled(v)
            else
                EyeDB().lfgEyeEnabled = v
            end
        end)
    y = ny

    local _, ny = W.CreateSlider(c, L["opt_microbar_lfg_eye_scale"],
        EyeDB().lfgEyeScale or 1.0, 0.5, 2.0, 0.05, y, function(v)
            if TomoMod_BagMicroMenu and TomoMod_BagMicroMenu.SetLFGEyeScale then
                TomoMod_BagMicroMenu.SetLFGEyeScale(v)
            else
                EyeDB().lfgEyeScale = v
            end
        end, "%.2f")
    y = ny

    c:SetHeight(math.abs(y) + 40)
    if scroll.UpdateScroll then scroll.UpdateScroll() end
    return scroll
end

-- =====================================
-- TAB: WAYPOINT
-- =====================================

local function BuildWaypointTab(parent)
    local scroll = W.CreateScrollPanel(parent)
    local c = scroll.child
    local y = -10

    local function WY_Apply()
        if TomoMod_Waypoint and TomoMod_Waypoint.ApplySettings then
            TomoMod_Waypoint.ApplySettings()
        end
        -- Re-evaluate zone visibility
        if TomoMod_Waypoint and TomoMod_Waypoint.CheckActivePublic then
            TomoMod_Waypoint.CheckActivePublic()
        end
    end

    local _, ny = W.CreateSectionHeader(c, L["section_waypoint"], y)
    y = ny

    local GT = TomoMod_GUIT or function(fr, en) return en end
    if not TomoModForeverDB.waypoint then TomoModForeverDB.waypoint = {} end
    local wdb = TomoModForeverDB.waypoint

    -- Master switch + the two visible parts. Each one off gives Blizzard's
    -- own marker back, so nothing is lost by turning it off.
    local _, ny = W.CreateCheckbox(c, GT("Activer le point de route TomoMod", "Enable the TomoMod waypoint"),
        wdb.enabled ~= false, y, function(v)
        wdb.enabled = v and true or false
        WY_Apply()
    end)
    y = ny
    local _, ny = W.CreateCheckbox(c, GT("Balise dans le monde (sinon : marqueur Blizzard)", "Beacon in the world (otherwise: Blizzard's marker)"),
        wdb.showBeacon ~= false, y, function(v)
        wdb.showBeacon = v and true or false
        if TomoMod_Waypoint and TomoMod_Waypoint.SetMode then TomoMod_Waypoint.SetMode("HIDDEN") end
        WY_Apply()
    end)
    y = ny
    local _, ny = W.CreateCheckbox(c, GT("Flèche de suivi au bord de l'écran", "Tracking arrow at the screen edge"),
        wdb.showArrow ~= false, y, function(v)
        wdb.showArrow = v and true or false
        if TomoMod_Waypoint and TomoMod_Waypoint.SetMode then TomoMod_Waypoint.SetMode("HIDDEN") end
        WY_Apply()
    end)
    y = ny

    local _, ny = W.CreateSeparator(c, y)
    y = ny

    -- Zone-only toggle
    local _, ny = W.CreateCheckbox(c, L["opt_way_zone_only"],
        TomoModForeverDB.waypoint and TomoModForeverDB.waypoint.zoneOnly or false, y, function(v)
        if not TomoModForeverDB.waypoint then TomoModForeverDB.waypoint = {} end
        TomoModForeverDB.waypoint.zoneOnly = v
        WY_Apply()
    end)
    y = ny

    local _, ny = W.CreateSeparator(c, y)
    y = ny

    -- Beacon size
    local _, ny = W.CreateSlider(c, L["opt_way_size"],
        TomoModForeverDB.waypoint and TomoModForeverDB.waypoint.beaconSize or 32, 16, 64, 1, y, function(v)
        if not TomoModForeverDB.waypoint then TomoModForeverDB.waypoint = {} end
        TomoModForeverDB.waypoint.beaconSize = v
        WY_Apply()
    end)
    y = ny

    -- Shape dropdown
    local shapeOptions = {
        { value = "ring",  text = L["way_shape_ring"] },
        { value = "arrow", text = L["way_shape_arrow"] },
    }
    local _, ny = W.CreateDropdown(c, L["opt_way_shape"],
        shapeOptions,
        TomoModForeverDB.waypoint and TomoModForeverDB.waypoint.shape or "ring",
        y, function(v)
        if not TomoModForeverDB.waypoint then TomoModForeverDB.waypoint = {} end
        TomoModForeverDB.waypoint.shape = v
        WY_Apply()
    end)
    y = ny

    -- Color picker
    if not TomoModForeverDB.waypoint then TomoModForeverDB.waypoint = {} end
    if not TomoModForeverDB.waypoint.color then
        TomoModForeverDB.waypoint.color = { r = 0.180, g = 0.847, b = 0.518 }
    end
    local _, ny = W.CreateColorPicker(c, L["opt_way_color"], TomoModForeverDB.waypoint.color, y, function(r, g, b)
        if not TomoModForeverDB.waypoint then TomoModForeverDB.waypoint = {} end
        if not TomoModForeverDB.waypoint.color then TomoModForeverDB.waypoint.color = {} end
        TomoModForeverDB.waypoint.color.r = r
        TomoModForeverDB.waypoint.color.g = g
        TomoModForeverDB.waypoint.color.b = b
        WY_Apply()
    end)
    y = ny

    c:SetHeight(math.abs(y) + 40)
    if scroll.UpdateScroll then scroll.UpdateScroll() end
    return scroll
end

-- =====================================
-- TAB: MERCHANT TOOLS (AlreadyKnown + ExtendPages)
-- =====================================

local function BuildMerchantToolsTab(parent)
    local MT     = TomoMod_MerchantTools
    local scroll = W.CreateScrollPanel(parent)
    local c      = scroll.child
    local y      = -10

    -- ── Already Known ─────────────────────────────────────────────────────
    local _, ny = W.CreateSectionHeader(c, L["section_already_known"], y)
    y = ny

    local _, ny = W.CreateInfoText(c, L["info_already_known"], y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_ak_enable"],
        TomoModForeverDB.merchantTools and TomoModForeverDB.merchantTools.alreadyKnown.enabled or false,
        y, function(v)
            if TomoModForeverDB.merchantTools then
                TomoModForeverDB.merchantTools.alreadyKnown.enabled = v
            end
            if MT then MT.SetAlreadyKnownEnabled(v) end
        end)
    y = ny

    local modeOptions = {
        { value = "MONOCHROME", text = L["ak_mode_mono"] },
        { value = "COLOR",      text = L["ak_mode_color"] },
    }
    local _, ny = W.CreateDropdown(c, L["opt_ak_mode"], modeOptions,
        TomoModForeverDB.merchantTools and TomoModForeverDB.merchantTools.alreadyKnown.mode or "MONOCHROME",
        y, function(v)
            if MT then MT.SetMode(v) end
        end)
    y = ny

    local col = (TomoModForeverDB.merchantTools and TomoModForeverDB.merchantTools.alreadyKnown.color)
             or { r = 0.180, g = 0.847, b = 0.518 }
    local _, ny = W.CreateColorPicker(c, L["opt_ak_color"], col, y, function(r, g, b)
        if MT then MT.SetColor(r, g, b) end
    end)
    y = ny

    -- ── Extend Vendor Pages ────────────────────────────────────────────────
    local _, ny = W.CreateSeparator(c, y)
    y = ny

    local _, ny = W.CreateSectionHeader(c, L["section_extend_pages"], y)
    y = ny

    local _, ny = W.CreateInfoText(c, L["info_extend_pages"], y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_ep_enable"],
        TomoModForeverDB.merchantTools and TomoModForeverDB.merchantTools.extendPages.enabled or false,
        y, function(v)
            if TomoModForeverDB.merchantTools then
                TomoModForeverDB.merchantTools.extendPages.enabled = v
            end
        end)
    y = ny

    local _, ny = W.CreateSlider(c, L["opt_ep_columns"],
        TomoModForeverDB.merchantTools and TomoModForeverDB.merchantTools.extendPages.numberOfPages or 2,
        1, 4, 1, y, function(v)
            if TomoModForeverDB.merchantTools then
                TomoModForeverDB.merchantTools.extendPages.numberOfPages = v
            end
        end)
    y = ny

    c:SetHeight(math.abs(y) + 40)
    if scroll.UpdateScroll then scroll.UpdateScroll() end
    return scroll
end

-- =====================================
-- TAB: RARE ALERT
-- =====================================
local function BuildRareAlertTab(parent)
    local scroll = W.CreateScrollPanel(parent)
    local c = scroll.child
    local y = -10

    local _, ny = W.CreateSectionHeader(c, L["section_rare_alert"], y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_rare_alert_enable"],
        TomoModForeverDB.rareAlert and TomoModForeverDB.rareAlert.enabled or false, y, function(v)
        if not TomoModForeverDB.rareAlert then TomoModForeverDB.rareAlert = {} end
        TomoModForeverDB.rareAlert.enabled = v
        if TomoMod_RareAlert then TomoMod_RareAlert.SetEnabled(v) end
    end)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_rare_alert_sound"],
        TomoModForeverDB.rareAlert and TomoModForeverDB.rareAlert.sound ~= false, y, function(v)
        if not TomoModForeverDB.rareAlert then TomoModForeverDB.rareAlert = {} end
        TomoModForeverDB.rareAlert.sound = v
    end)
    y = ny

    local _, ny = W.CreateSlider(c, L["opt_rare_alert_duration"],
        TomoModForeverDB.rareAlert and TomoModForeverDB.rareAlert.duration or 20, 5, 60, 1, y, function(v)
        if not TomoModForeverDB.rareAlert then TomoModForeverDB.rareAlert = {} end
        TomoModForeverDB.rareAlert.duration = v
    end)
    y = ny

    local _, ny = W.CreateButton(c, L["btn_reset_rare_alert_pos"], 220, y, function()
        if TomoModForeverDB.rareAlert then TomoModForeverDB.rareAlert.position = nil end
        if TomoMod_RareAlert then TomoMod_RareAlert.PositionBanner() end
    end)
    y = ny

    local _, ny = W.CreateInfoText(c, L["rare_alert_info"], y)
    y = ny

    c:SetHeight(math.abs(y) + 20)
    if scroll.UpdateScroll then scroll.UpdateScroll() end
    return scroll
end

-- =====================================
-- TAB: COMPANION STATUS (pet reminder)
-- =====================================

local function BuildCompanionStatusTab(parent)
    local scroll = W.CreateScrollPanel(parent)
    local c = scroll.child
    local y = -10

    local CS = TomoMod_CompanionStatus
    local db = CS and CS.GetSettings and CS.GetSettings() or nil

    local function CS_Apply()
        if CS and CS.ApplySettings then CS.ApplySettings() end
    end

    local _, ny = W.CreateSectionHeader(c, L["section_companion"], y)
    y = ny

    local _, ny = W.CreateInfoText(c, L["info_companion_desc"], y)
    y = ny

    if not db then
        local _, ny2 = W.CreateInfoText(c, L["info_companion_unavailable"], y)
        y = ny2
        c:SetHeight(math.abs(y) + 40)
        if scroll.UpdateScroll then scroll.UpdateScroll() end
        return scroll
    end

    local _, ny = W.CreateCheckbox(c, L["opt_companion_enable"], db.enabled, y, function(v)
        if CS and CS.SetEnabled then CS.SetEnabled(v) end
    end)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["opt_companion_hide_mounted"], db.hideWhileMounted, y, function(v)
        db.hideWhileMounted = v
        CS_Apply()
    end)
    y = ny

    local _, ny = W.CreateInfoText(c, L["info_companion_travel"], y)
    y = ny

    local _, ny = W.CreateSeparator(c, y)
    y = ny

    local _, ny = W.CreateSegmentedControl(c, L["opt_companion_display_mode"], {
        { value = "icon", text = L["companion_mode_icon"] },
        { value = "text", text = L["companion_mode_text"] },
        { value = "both", text = L["companion_mode_both"] },
    }, db.displayMode or "both", y, function(v)
        db.displayMode = v
        CS_Apply()
    end, 3)
    y = ny

    local _, ny = W.CreateSlider(c, L["opt_companion_scale"], db.scale, 0.5, 6.0, 0.1, y, function(v)
        db.scale = v; CS_Apply()
    end, "%.1f", 4.0)
    y = ny

    local _, ny = W.CreateSlider(c, L["opt_companion_size"], db.size, 16, 96, 1, y, function(v)
        db.size = v; CS_Apply()
    end, "%.0f", 36)
    y = ny

    local _, ny = W.CreateSeparator(c, y)
    y = ny

    local _, ny = W.CreateSubLabel(c, L["sublabel_companion_pos"], y)
    y = ny

    -- point is { anchorPoint, relativePoint, offsetX, offsetY }; only the
    -- offsets are exposed, the anchor stays CENTER.
    local _, ny = W.CreateSlider(c, L["opt_companion_x"], db.point and db.point[3] or 0, -800, 800, 1, y, function(v)
        if db.point then db.point[3] = v end
        CS_Apply()
    end, "%.0f", 0)
    y = ny

    local _, ny = W.CreateSlider(c, L["opt_companion_y"], db.point and db.point[4] or 0, -800, 800, 1, y, function(v)
        if db.point then db.point[4] = v end
        CS_Apply()
    end, "%.0f", 0)
    y = ny

    local _, ny = W.CreateButton(c, L["btn_companion_reset_pos"], 200, y, function()
        if CS and CS.ResetPosition then CS.ResetPosition() end
    end)
    y = ny

    local _, ny = W.CreateSeparator(c, y)
    y = ny

    local _, ny = W.CreateInfoText(c, L["info_companion_slash"], y)
    y = ny

    c:SetHeight(math.abs(y) + 40)
    if scroll.UpdateScroll then scroll.UpdateScroll() end
    return scroll
end

-- =====================================
-- MAIN PANEL ENTRY POINT
-- =====================================

function TomoMod_ConfigPanel_QOL(parent)
    local tabs = {
        { key = "cinematic",    label = L["tab_qol_cinematic"],    builder = function(p) return BuildCinematicTab(p) end },
        { key = "autoquest",    label = L["tab_qol_auto_quest"],   builder = function(p) return BuildAutoQuestTab(p) end },
        { key = "automations",  label = L["tab_qol_automations"],  builder = function(p) return BuildAutomationsTab(p) end },
        { key = "bagmicro",     label = L["tab_qol_bag_micro"],    builder = function(p) return BuildBagMicroMenuTab(p) end },
        { key = "cvaropt",      label = L["tab_qol_cvar_opt"],     builder = function(p) return BuildCVarOptimizerTab(p) end },
        { key = "waypoint",    label = L["tab_qol_waypoint"],       builder = function(p) return BuildWaypointTab(p) end },
        { key = "merchant",    label = L["tab_qol_merchant_tools"], builder = function(p) return BuildMerchantToolsTab(p) end },
        { key = "rarealert",   label = L["tab_qol_rare_alert"],     builder = function(p) return BuildRareAlertTab(p) end },
        { key = "companion",   label = L["tab_qol_companion"], builder = function(p) return BuildCompanionStatusTab(p) end },
    }

    -- Tabs whose module cannot run on this client are dropped, not
    -- disabled: a tab that opens onto controls for something the game
    -- does not have reads as a bug, not as a limitation.
    if TomoMod_Compat and TomoMod_Compat.IsTabBlocked then
        for i = #tabs, 1, -1 do
            if TomoMod_Compat.IsTabBlocked(tabs[i].key) then
                table.remove(tabs, i)
            end
        end
    end

    return W.CreateTabPanel(parent, tabs)
end
