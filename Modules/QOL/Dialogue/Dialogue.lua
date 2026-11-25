-- =====================================================================
-- Modules/QOL/Dialogue/Dialogue.lua -- quest and NPC dialogue, TMF style (1.3.9)
--
-- Replaces the game's gossip and quest windows with one parchment panel in
-- bronze and gold: the NPC's name over a crest, the text written out as you
-- read, numbered choices, rewards, and keyboard control:
--   Space        continue / accept / turn in (first press finishes the text)
--   1 to 9       pick a choice (or a reward when turning in)
--   Escape       decline / goodbye
-- The camera on the NPC and the hidden interface live in DialogueScene.lua,
-- the rewards in DialogueRewards.lua, the books in DialogueBook.lua.
--
-- The game's GossipFrame and QuestFrame are simply not told about these
-- events while the module is on (their events are unregistered, and given
-- back when it is turned off): every choice goes through the same game
-- functions their buttons use. Stands down when Immersion or DialogueUI is
-- loaded. Idea from DialogueUI (Peterodox); nothing of its code is used.
-- =====================================================================

TomoMod_Dialogue = TomoMod_Dialogue or {}
local D = TomoMod_Dialogue

local FONT      = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local FONT_BOLD = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-SemiBold.ttf"
local ART       = "Interface\\AddOns\\TomoModForever\\Assets\\Textures\\Dialogue\\"

local GOLD   = { 0.788, 0.635, 0.322 }
local YELLOW = { 1.000, 0.820, 0.000 }
local TEXT   = { 0.949, 0.922, 0.859 }
local DIM    = { 0.700, 0.650, 0.560 }
local GREEN  = { 0.450, 0.850, 0.400 }

local WIDTH, PAD = 520, 26
local OPTION_H = 26

local ICON_AVAILABLE = "Interface\\GossipFrame\\AvailableQuestIcon"
local ICON_ACTIVE    = "Interface\\GossipFrame\\ActiveQuestIcon"
local ICON_PENDING   = "Interface\\GossipFrame\\IncompleteQuestIcon"
local ICON_GOSSIP    = "Interface\\GossipFrame\\GossipGossipIcon"

local IS_FR = GetLocale() == "frFR"
local function T(fr, en)
    if TomoMod_GUIT then return TomoMod_GUIT(fr, en) end
    return IS_FR and fr or en
end

local function DB() return TomoModForeverDB and TomoModForeverDB.dialogue end
local function U() return TomoMod_Utils end
local function AnimAny() local u = U(); return not (u and u.AnimAny) or u.AnimAny() end

local function Font(fs, path, size, flags)
    fs:SetFont(path, size, flags or "")
    fs:SetShadowOffset(1, -1)
    fs:SetShadowColor(0, 0, 0, 0.85)
end

-- [1.3.9] What happened lately (events, keys, actions), for /tmf dialogue.
local log = {}
local function Log(msg)
    log[#log + 1] = string.format("%.1f  %s", GetTime() % 1000, msg)
    if #log > 30 then table.remove(log, 1) end
end
D.Log = Log

function D.Report()
    print("|cffd4a64aTMF dialogue|r  actif " .. tostring(D.Active and D.Active())
        .. ", panneau " .. tostring(TomoMod_DialogueFrame and TomoMod_DialogueFrame:IsShown())
        .. ", clavier " .. tostring(TomoMod_DialogueFrame and TomoMod_DialogueFrame:IsKeyboardEnabled())
        .. ", scène " .. tostring(TomoMod_DialogueScene and TomoMod_DialogueScene.Active and TomoMod_DialogueScene.Active()))
    for _, l in ipairs(log) do print("  " .. l) end
end

-- Runs a game action, logged; an error is logged and reported, never stuck.
local function Do(name, fn)
    Log("action " .. name)
    local ok, err = pcall(fn)
    if not ok then
        Log("ERREUR " .. tostring(err))
        geterrorhandler()(err)
    end
end

local function Plain(v)
    if type(issecretvalue) == "function" and issecretvalue(v) then return nil end
    return v
end

-- ---------------------------------------------------------------------
-- Blizzard frames: kept, just not told
-- ---------------------------------------------------------------------
local BLIZZ = {
    GossipFrame = { "GOSSIP_SHOW", "GOSSIP_CLOSED" },
    QuestFrame  = { "QUEST_GREETING", "QUEST_DETAIL", "QUEST_PROGRESS", "QUEST_COMPLETE",
                    "QUEST_FINISHED", "QUEST_ITEM_UPDATE" },
}
local blizzMuted = false

local function MuteBlizzard(on)
    if on == blizzMuted then return end
    for name, events in pairs(BLIZZ) do
        local f = _G[name]
        if f then
            for _, e in ipairs(events) do
                if on then f:UnregisterEvent(e) else pcall(f.RegisterEvent, f, e) end
            end
            if on and f:IsShown() then HideUIPanel(f) end
        end
    end
    blizzMuted = on
end

local function OtherDialogueAddon()
    local loaded = C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded
    if not loaded then return nil end
    for _, name in ipairs({ "Immersion", "DialogueUI" }) do
        if loaded(name) then return name end
    end
    return nil
end

-- ---------------------------------------------------------------------
-- Panel
-- ---------------------------------------------------------------------
local panel, body, scroll, child
local options = {}       -- option buttons (pool)
local primaryBtn, secondaryBtn
local current            -- current page { kind = ..., ... }
local closeToken = 0
local typing             -- { fs, shown, total }
local FinishTyping       -- defined with the typewriter below

local function MakeKeycap(parent)
    local k = CreateFrame("Frame", nil, parent)
    k:SetSize(22, 18)
    local t = k:CreateTexture(nil, "ARTWORK")
    t:SetAllPoints()
    t:SetTexture(ART .. "keycap.tga")
    t:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0.9)
    k.text = k:CreateFontString(nil, "OVERLAY")
    Font(k.text, FONT_BOLD, 10)
    k.text:SetPoint("CENTER", 0, 0)
    k.text:SetTextColor(TEXT[1], TEXT[2], TEXT[3])
    function k:SetKey(s)
        self.text:SetText(s)
        self:SetWidth(math.max(18, (self.text:GetStringWidth() or 8) + 10))
    end
    return k
end

local function MakeButton(parent, onClick, name)
    local b = CreateFrame("Button", name, parent)
    b:SetSize(170, 34)
    b.bg = b:CreateTexture(nil, "BACKGROUND")
    b.bg:SetAllPoints()
    b.bg:SetTexture(ART .. "button.tga")
    b.bg:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0.85)
    b.hl = b:CreateTexture(nil, "ARTWORK")
    b.hl:SetPoint("TOPLEFT", 3, -3); b.hl:SetPoint("BOTTOMRIGHT", -3, 3)
    b.hl:SetColorTexture(1, 0.82, 0.35, 0.14)
    b.hl:Hide()
    b.key = MakeKeycap(b)
    b.key:SetPoint("LEFT", 10, 0)
    b.text = b:CreateFontString(nil, "OVERLAY")
    Font(b.text, FONT_BOLD, 13)
    b.text:SetPoint("LEFT", b.key, "RIGHT", 8, 0)
    b.text:SetPoint("RIGHT", -10, 0)
    b.text:SetJustifyH("LEFT")
    b:SetScript("OnEnter", function(s) if s:IsEnabled() then s.hl:Show() end end)
    b:SetScript("OnLeave", function(s) s.hl:Hide() end)
    b:SetScript("OnClick", function(s)
        if s.action then FinishTyping(); Do("clic " .. tostring(s.text:GetText()), s.action) end
    end)
    function b:Set(label, key, action, enabled)
        self.text:SetText(label)
        self.key:SetKey(key)
        self.action = action
        self:SetEnabled(enabled ~= false)
        local on = enabled ~= false
        self.text:SetTextColor(on and YELLOW[1] or DIM[1], on and YELLOW[2] or DIM[2], on and YELLOW[3] or DIM[3])
        self.bg:SetAlpha(on and 1 or 0.45)
        self:SetWidth(math.max(140, (self.text:GetStringWidth() or 60) + self.key:GetWidth() + 40))
        self:Show()
    end
    if onClick then b.action = onClick end
    return b
end

local function GetOption(i)
    local o = options[i]
    if o then return o end
    o = CreateFrame("Button", nil, child)
    o:SetHeight(OPTION_H)
    o.hl = o:CreateTexture(nil, "BACKGROUND")
    o.hl:SetAllPoints()
    o.hl:SetTexture(ART .. "highlight.tga")
    o.hl:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0.35)
    o.hl:SetAlpha(0)
    o.num = o:CreateFontString(nil, "OVERLAY")
    Font(o.num, FONT_BOLD, 12)
    o.num:SetPoint("LEFT", 4, 0)
    o.num:SetWidth(16)
    o.num:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
    o.icon = o:CreateTexture(nil, "ARTWORK")
    o.icon:SetSize(16, 16)
    o.icon:SetPoint("LEFT", o.num, "RIGHT", 4, 0)
    o.text = o:CreateFontString(nil, "OVERLAY")
    Font(o.text, FONT, 13)
    o.text:SetPoint("LEFT", o.icon, "RIGHT", 8, 0)
    o.text:SetPoint("RIGHT", -6, 0)
    o.text:SetJustifyH("LEFT")
    o.text:SetWordWrap(false)
    o:SetScript("OnEnter", function(s) s.hl:SetAlpha(1) end)
    o:SetScript("OnLeave", function(s) s.hl:SetAlpha(0) end)
    o:SetScript("OnClick", function(s) if s.action then FinishTyping(); Do("clic choix " .. i, s.action) end end)
    options[i] = o
    return o
end

-- ---------------------------------------------------------------------
-- Typewriter: the text is revealed with the engine's alpha gradient
-- ---------------------------------------------------------------------
local typer = CreateFrame("Frame")
typer:Hide()

-- [1.3.9] The whole text: the gradient starts past the last character.
-- (A length of 0 is refused by the client: that error, raised every frame,
-- kept the text "being written" forever, so Space never got to the button
-- and closing never reached the scene.)
FinishTyping = function()
    if not typing then return false end
    local t = typing
    typing = nil
    typer:Hide()
    pcall(t.fs.SetAlphaGradient, t.fs, t.total + 50, 1)
    return true
end

typer:SetScript("OnUpdate", function(self, dt)
    if not typing then self:Hide() return end
    local db = DB()
    typing.shown = typing.shown + dt * ((db and db.typeSpeed) or 70)
    if typing.shown >= typing.total then
        FinishTyping()
        return
    end
    if not pcall(typing.fs.SetAlphaGradient, typing.fs, math.floor(typing.shown), 12) then FinishTyping() end
end)

local function StartTyping(fs, text)
    FinishTyping()
    local db = DB()
    if not (db and db.typewriter ~= false and AnimAny()) or not fs.SetAlphaGradient then return end
    local total = #(text or "")
    if total < 2 then return end
    if not pcall(fs.SetAlphaGradient, fs, 0, 12) then return end
    typing = { fs = fs, shown = 0, total = total }
    typer:Show()
end

-- ---------------------------------------------------------------------
-- Building a page
-- ---------------------------------------------------------------------
local blocks = {}        -- extra font strings used per page (pool)
local function GetBlock(i)
    local b = blocks[i]
    if b then return b end
    b = child:CreateFontString(nil, "OVERLAY")
    b:SetJustifyH("LEFT")
    b:SetWordWrap(true)
    blocks[i] = b
    return b
end

local function Layout()
    local innerW = WIDTH - PAD * 2 - 8
    child:SetWidth(innerW)

    body:ClearAllPoints()
    body:SetPoint("TOPLEFT", child, "TOPLEFT", 0, 0)
    body:SetWidth(innerW)
    local y = -(body:GetStringHeight() or 0) - 12

    -- headings and paragraphs after the text
    local bi = 0
    for _, para in ipairs(current.extra or {}) do
        bi = bi + 1
        local fs = GetBlock(bi)
        Font(fs, para.bold and FONT_BOLD or FONT, para.size or 13)
        local c = para.color or TEXT
        fs:SetTextColor(c[1], c[2], c[3])
        fs:SetWidth(innerW)
        fs:SetText(para.text)
        fs:ClearAllPoints()
        fs:SetPoint("TOPLEFT", child, "TOPLEFT", 0, y)
        fs:Show()
        y = y - (fs:GetStringHeight() or 0) - (para.gap or 8)
    end
    for i = bi + 1, #blocks do blocks[i]:Hide() end

    -- rewards / required items
    local R = TomoMod_DialogueRewards
    if R and current.rewards then
        local h = R.Build(child, current.rewards, innerW, y, function() D.Refresh(true) end)
        y = y - h
    elseif R then
        R.Hide()
    end

    -- choices
    local n = #(current.choices or {})
    for i, c in ipairs(current.choices or {}) do
        local o = GetOption(i)
        o:ClearAllPoints()
        o:SetPoint("TOPLEFT", child, "TOPLEFT", -4, y)
        o:SetPoint("RIGHT", child, "RIGHT", 0, 0)
        o.num:SetText(i <= 9 and tostring(i) or "")
        o.icon:SetTexture(c.icon or ICON_GOSSIP)
        o.text:SetText(c.text or "")
        local col = c.color or TEXT
        o.text:SetTextColor(col[1], col[2], col[3])
        o.action = c.action
        o:Show()
        y = y - OPTION_H - 2
    end
    for i = n + 1, #options do options[i]:Hide() end

    local contentH = math.abs(y) + 4
    child:SetHeight(contentH)

    -- panel height: header + content (scrolled past the max) + footer
    local maxContent = math.floor(UIParent:GetHeight() * 0.62)
    local viewH = math.min(contentH, maxContent)
    scroll:SetHeight(viewH)
    scroll:SetVerticalScroll(0)
    panel:SetHeight(92 + viewH + 64)
end

local function Footer()
    local p, s = current.primary, current.secondary
    if p then primaryBtn:Set(p.label, T("Espace", "Space"), p.action, p.enabled) else primaryBtn:Hide() end
    if s then secondaryBtn:Set(s.label, T("Échap", "Esc"), s.action, true) else secondaryBtn:Hide() end
    primaryBtn:ClearAllPoints()
    secondaryBtn:ClearAllPoints()
    if p and s then
        primaryBtn:SetPoint("BOTTOMRIGHT", panel, "BOTTOM", -6, 18)
        secondaryBtn:SetPoint("BOTTOMLEFT", panel, "BOTTOM", 6, 18)
    elseif p then
        primaryBtn:SetPoint("BOTTOM", panel, "BOTTOM", 0, 18)
    elseif s then
        secondaryBtn:SetPoint("BOTTOM", panel, "BOTTOM", 0, 18)
    end
end

local function NpcName()
    for _, unit in ipairs({ "questnpc", "npc" }) do
        if UnitExists(unit) then
            local n = Plain(UnitName(unit))
            if n then return n end
        end
    end
    return nil
end

local function Render(page, keepText)
    current = page
    panel.name:SetText(page.name or NpcName() or "")
    panel.title:SetText(page.title or "")
    panel.title:SetShown(page.title ~= nil and page.title ~= "")
    if not keepText then
        body:SetText(page.text or "")
        Font(body, FONT, ((DB() and DB().fontSize) or 14))
        body:SetTextColor(TEXT[1], TEXT[2], TEXT[3])
    end
    Layout()
    Footer()
    if not keepText then StartTyping(body, page.text) end
end

-- ---------------------------------------------------------------------
-- Opening and closing
-- ---------------------------------------------------------------------
-- Keys: the panel listens to the keyboard (Space, 1 to 9, Escape), and as a
-- second way Space is also bound to the main button while the panel is up
-- (if the panel's own listening misses it). Out of combat only; the binding
-- goes when the panel hides or a fight starts.
local bindOwner = CreateFrame("Frame")
local function Bind(on)
    if InCombatLockdown() then return end
    ClearOverrideBindings(bindOwner)
    if on then SetOverrideBindingClick(bindOwner, true, "SPACE", "TomoMod_DialoguePrimary") end
end
D.Unbind = function() Bind(false) end

local function KeysOn(on)
    if not panel then return end
    if InCombatLockdown() then panel:EnableKeyboard(false) return end
    panel:SetPropagateKeyboardInput(true)
    panel:EnableKeyboard(on and true or false)
    Bind(on)
end

local function Open(page)
    closeToken = closeToken + 1
    local first = not panel:IsShown()
    Render(page)
    if first then
        panel:SetAlpha(1)
        panel:Show()
        if AnimAny() then panel.intro:Stop(); panel.intro:Play() end
        local S = TomoMod_DialogueScene
        if S and S.Enter then S.Enter() end
    elseif AnimAny() then
        child.fade:Stop(); child.fade:Play()
    end
    KeysOn(true)
end

local function HideNow()
    pcall(FinishTyping)
    current = nil
    if panel then panel:Hide() end
    local S = TomoMod_DialogueScene
    if S and S.Leave then S.Leave() end
end

-- The game ends the conversation (or moves to the next page): wait a moment,
-- a new page may follow at once (gossip -> quest).
local function CloseSoon()
    closeToken = closeToken + 1
    local token = closeToken
    C_Timer.After(0.12, function()
        if token == closeToken then HideNow() end
    end)
end

-- The player ends it: tell the game.
local function Goodbye()
    if not current then HideNow() return end
    local kind = current.kind
    if kind == "gossip" then
        if C_GossipInfo and C_GossipInfo.CloseGossip then C_GossipInfo.CloseGossip() end
    else
        CloseQuest()
    end
    HideNow()
end
D.Close = Goodbye

-- ---------------------------------------------------------------------
-- Pages
-- ---------------------------------------------------------------------
local function DifficultyColor(level)
    level = Plain(level)
    if not (level and GetQuestDifficultyColor) then return YELLOW end
    local c = GetQuestDifficultyColor(level)
    return c and { c.r, c.g, c.b } or YELLOW
end

local function QuestLabel(title, level)
    level = Plain(level)
    if level and level > 0 then return "[" .. level .. "] " .. (title or "") end
    return title or ""
end

local consumeGossipClose = false

local function GossipPage()
    local choices = {}
    local G = C_GossipInfo
    for _, q in ipairs((G.GetActiveQuests and G.GetActiveQuests()) or {}) do
        choices[#choices + 1] = {
            text = QuestLabel(q.title, q.questLevel), icon = q.isComplete and ICON_ACTIVE or ICON_PENDING,
            color = q.isComplete and GREEN or DIM,
            action = function() consumeGossipClose = true; G.SelectActiveQuest(q.questID) end,
        }
    end
    for _, q in ipairs((G.GetAvailableQuests and G.GetAvailableQuests()) or {}) do
        choices[#choices + 1] = {
            text = QuestLabel(q.title, q.questLevel), icon = ICON_AVAILABLE,
            color = q.isTrivial and DIM or DifficultyColor(q.questLevel),
            action = function() consumeGossipClose = true; G.SelectAvailableQuest(q.questID) end,
        }
    end
    local opts = (G.GetOptions and G.GetOptions()) or {}
    table.sort(opts, function(a, b) return (a.orderIndex or 0) < (b.orderIndex or 0) end)
    for _, o in ipairs(opts) do
        choices[#choices + 1] = {
            text = o.name, icon = o.icon or ICON_GOSSIP,
            action = function() G.SelectOption(o.gossipOptionID or o.orderIndex, "", true) end,
        }
    end
    local page = {
        kind = "gossip", text = G.GetText and G.GetText() or "", choices = choices,
        secondary = { label = T("Au revoir", "Goodbye"), action = Goodbye },
    }
    if #choices > 0 then
        page.primary = { label = choices[1].text:gsub("^%[%d+%] ", ""), action = choices[1].action }
        if #page.primary.label > 26 then page.primary.label = T("Choix 1", "Choice 1") end
    end
    return page
end

local function GreetingPage()
    local choices = {}
    for i = 1, (GetNumActiveQuests() or 0) do
        local title, isComplete = GetActiveTitle(i)
        choices[#choices + 1] = {
            text = QuestLabel(title, GetActiveLevel and GetActiveLevel(i)),
            icon = isComplete and ICON_ACTIVE or ICON_PENDING, color = isComplete and GREEN or DIM,
            action = function() SelectActiveQuest(i) end,
        }
    end
    for i = 1, (GetNumAvailableQuests() or 0) do
        local level = GetAvailableLevel and GetAvailableLevel(i)
        choices[#choices + 1] = {
            text = QuestLabel(GetAvailableTitle(i), level), icon = ICON_AVAILABLE,
            color = DifficultyColor(level),
            action = function() SelectAvailableQuest(i) end,
        }
    end
    local page = {
        kind = "quest", text = GetGreetingText() or "", choices = choices,
        secondary = { label = T("Au revoir", "Goodbye"), action = Goodbye },
    }
    if #choices > 0 then page.primary = { label = T("Choix 1", "Choice 1"), action = choices[1].action } end
    return page
end

local function DetailPage()
    local extra = {}
    local obj = GetObjectiveText and GetObjectiveText()
    if obj and obj ~= "" then
        extra[#extra + 1] = { text = T("Objectifs", "Objectives"), bold = true, size = 14, color = GOLD, gap = 4 }
        extra[#extra + 1] = { text = obj, gap = 12 }
    end
    local auto = QuestGetAutoAccept and QuestGetAutoAccept()
    local page = {
        kind = "quest", title = GetTitleText(), text = GetQuestText() or "", extra = extra,
        rewards = "detail",
    }
    if auto then
        page.primary = { label = T("D'accord", "Okay"), action = function()
            if AcknowledgeAutoAcceptQuest then AcknowledgeAutoAcceptQuest() end
            CloseQuest()
        end }
    else
        page.primary = { label = T("Accepter", "Accept"), action = function()
            if QuestFlagsPVP and QuestFlagsPVP() then
                StaticPopup_Show("CONFIRM_ACCEPT_PVP_QUEST")
            else
                AcceptQuest()
            end
        end }
        page.secondary = { label = T("Refuser", "Decline"), action = function() DeclineQuest(); HideNow() end }
    end
    return page
end

local function ProgressPage()
    local can = IsQuestCompletable()
    return {
        kind = "quest", title = GetTitleText(), text = GetProgressText() or "",
        rewards = "progress",
        primary = { label = can and T("Continuer", "Continue") or T("Pas encore terminée", "Not finished yet"),
                    action = function() CompleteQuest() end, enabled = can and true or false },
        secondary = { label = T("Au revoir", "Goodbye"), action = Goodbye },
    }
end

local function CompletePage()
    local R = TomoMod_DialogueRewards
    local need = (GetNumQuestChoices() or 0) > 1
    local chosen = R and R.Choice and R.Choice() or 0
    local ready = not need or chosen > 0
    return {
        kind = "quest", title = GetTitleText(), text = GetRewardText() or "",
        rewards = "complete",
        primary = {
            label = ready and T("Terminer la quête", "Complete quest") or T("Choisis une récompense", "Choose a reward"),
            enabled = ready,
            action = function()
                local c = need and (R and R.Choice and R.Choice() or 0) or 1
                if need and c == 0 then return end
                GetQuestReward(c)
            end,
        },
        secondary = { label = T("Plus tard", "Later"), action = Goodbye },
    }
end

local BUILDERS = {
    GOSSIP_SHOW = GossipPage, QUEST_GREETING = GreetingPage, QUEST_DETAIL = DetailPage,
    QUEST_PROGRESS = ProgressPage, QUEST_COMPLETE = CompletePage,
}
local lastEvent

--- Rebuilds the current page (a reward picked, item data arrived).
function D.Refresh(keepText)
    if not (panel and panel:IsShown() and lastEvent and BUILDERS[lastEvent]) then return end
    local ok, page = pcall(BUILDERS[lastEvent])
    if ok and page then Render(page, keepText) end
end

-- ---------------------------------------------------------------------
-- Keys
-- ---------------------------------------------------------------------
-- The key is kept or passed on BEFORE anything runs: an action can hide
-- the panel, and a hidden frame no longer decides about the key it got.
local function OnKey(self, key)
    if InCombatLockdown() then return end
    local run
    if key == "SPACE" or key == "ENTER" then
        run = function()
            if FinishTyping() then Log("texte affiché") return end
            local p = current and current.primary
            if p and p.enabled ~= false then Do("bouton principal: " .. tostring(p.label), p.action)
            else Log("bouton principal inactif") end
        end
    elseif key == "ESCAPE" then
        run = function()
            if current and current.secondary then Do("bouton secondaire", current.secondary.action) else Goodbye() end
        end
    else
        local n = tonumber(key)
        if n and n >= 1 and n <= 9 and current then
            if current.rewards == "complete" and TomoMod_DialogueRewards and TomoMod_DialogueRewards.Pick
                and (GetNumQuestChoices and GetNumQuestChoices() or 0) >= n then
                run = function() TomoMod_DialogueRewards.Pick(n); D.Refresh(true) end
            elseif current.choices and current.choices[n] then
                run = function() FinishTyping(); Do("choix " .. n, current.choices[n].action) end
            end
        end
    end
    self:SetPropagateKeyboardInput(run == nil)
    if run then
        Log("touche " .. key)
        run()
    end
end

-- ---------------------------------------------------------------------
-- Frame
-- ---------------------------------------------------------------------
local function Create()
    if panel then return end
    panel = CreateFrame("Frame", "TomoMod_DialogueFrame", UIParent)
    panel:SetSize(WIDTH, 300)
    panel:SetFrameStrata("DIALOG")
    panel:SetClampedToScreen(true)
    if panel.SetIgnoreParentAlpha then panel:SetIgnoreParentAlpha(true) end
    panel:EnableMouse(true)
    panel:Hide()

    local bg = panel:CreateTexture(nil, "BACKGROUND", nil, -2)
    bg:SetAllPoints()
    bg:SetTexture(ART .. "parchment.tga")
    bg:SetVertexColor(1, 1, 1, 0.97)
    local shade = panel:CreateTexture(nil, "BACKGROUND", nil, -1)
    shade:SetAllPoints()
    shade:SetColorTexture(0, 0, 0, 0.15)
    -- gold frame: thin border and four corners
    local function Edge(p1, p2, w, h)
        local t = panel:CreateTexture(nil, "BORDER")
        t:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 0.55)
        t:SetPoint(p1); t:SetPoint(p2)
        if w then t:SetWidth(w) else t:SetHeight(h) end
    end
    Edge("TOPLEFT", "TOPRIGHT", nil, 1); Edge("BOTTOMLEFT", "BOTTOMRIGHT", nil, 1)
    Edge("TOPLEFT", "BOTTOMLEFT", 1, nil); Edge("TOPRIGHT", "BOTTOMRIGHT", 1, nil)
    for _, c in ipairs({ { "TOPLEFT", 0, 1, 1, 0 }, { "TOPRIGHT", 1, 0, 1, 0 }, { "BOTTOMLEFT", 0, 1, 0, 1 }, { "BOTTOMRIGHT", 1, 0, 0, 1 } }) do
        local t = panel:CreateTexture(nil, "OVERLAY")
        t:SetSize(56, 56)
        t:SetPoint(c[1], panel, c[1], (c[1]:find("LEFT") and -4 or 4), (c[1]:find("TOP") and 4 or -4))
        t:SetTexture(ART .. "corner.tga")
        t:SetTexCoord(c[2], c[3], c[4], c[5])
        t:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 1)
    end

    -- header: crest, NPC name, quest title, divider
    local crest = panel:CreateTexture(nil, "ARTWORK")
    crest:SetSize(46, 46)
    crest:SetPoint("TOPLEFT", PAD - 6, -16)
    crest:SetTexture(ART .. "crest.tga")
    crest:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0.9)
    panel.crest = crest
    panel.name = panel:CreateFontString(nil, "OVERLAY")
    Font(panel.name, FONT_BOLD, 18)
    panel.name:SetPoint("TOPLEFT", crest, "TOPRIGHT", 10, -4)
    panel.name:SetPoint("RIGHT", panel, "RIGHT", -PAD, 0)
    panel.name:SetJustifyH("LEFT")
    panel.name:SetTextColor(YELLOW[1], YELLOW[2], YELLOW[3])
    panel.title = panel:CreateFontString(nil, "OVERLAY")
    Font(panel.title, FONT, 13)
    panel.title:SetPoint("TOPLEFT", panel.name, "BOTTOMLEFT", 0, -3)
    panel.title:SetPoint("RIGHT", panel, "RIGHT", -PAD, 0)
    panel.title:SetJustifyH("LEFT")
    panel.title:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
    panel.title:SetWordWrap(false)
    local div = panel:CreateTexture(nil, "ARTWORK")
    div:SetSize(WIDTH - PAD * 2, 16)
    div:SetPoint("TOP", panel, "TOP", 0, -72)
    div:SetTexture(ART .. "divider.tga")
    div:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0.85)

    -- content
    scroll = CreateFrame("ScrollFrame", nil, panel)
    scroll:SetPoint("TOPLEFT", PAD, -92)
    scroll:SetPoint("RIGHT", panel, "RIGHT", -PAD + 4, 0)
    scroll:SetHeight(100)
    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(self, delta)
        local max = math.max(0, child:GetHeight() - self:GetHeight())
        self:SetVerticalScroll(math.max(0, math.min(max, self:GetVerticalScroll() - delta * 40)))
    end)
    child = CreateFrame("Frame", nil, scroll)
    child:SetSize(WIDTH - PAD * 2, 10)
    scroll:SetScrollChild(child)
    body = child:CreateFontString(nil, "OVERLAY")
    Font(body, FONT, 14)
    body:SetJustifyH("LEFT")
    body:SetJustifyV("TOP")
    body:SetWordWrap(true)
    body:SetSpacing(3)
    -- a click on the text finishes it
    panel:SetScript("OnMouseDown", function() FinishTyping() end)

    -- page change: content fades in
    child.fade = child:CreateAnimationGroup()
    local cf = child.fade:CreateAnimation("Alpha")
    cf:SetFromAlpha(0); cf:SetToAlpha(1); cf:SetDuration(0.2)

    -- first open: rises and fades in
    panel.intro = panel:CreateAnimationGroup()
    local a = panel.intro:CreateAnimation("Alpha"); a:SetFromAlpha(0); a:SetToAlpha(1); a:SetDuration(0.25)
    local m0 = panel.intro:CreateAnimation("Translation"); m0:SetOffset(24, 0); m0:SetDuration(0); m0:SetOrder(1)
    local m1 = panel.intro:CreateAnimation("Translation"); m1:SetOffset(-24, 0); m1:SetDuration(0.3); m1:SetSmoothing("OUT"); m1:SetOrder(2)
    a:SetOrder(2)
    -- a light passes over the crest
    local shine = panel:CreateTexture(nil, "OVERLAY", nil, 2)
    shine:SetSize(18, 60)
    shine:SetPoint("CENTER", crest, "LEFT", -10, 0)
    shine:SetTexture(ART .. "shine.tga")
    shine:SetBlendMode("ADD")
    shine:SetVertexColor(1, 0.85, 0.5, 0)
    shine:SetRotation(math.rad(20))
    local sm = panel.intro:CreateAnimation("Translation"); sm:SetTarget(shine); sm:SetOffset(66, 0); sm:SetDuration(0.6); sm:SetStartDelay(0.2); sm:SetOrder(2)
    local sa = panel.intro:CreateAnimation("Alpha"); sa:SetTarget(shine); sa:SetFromAlpha(0.9); sa:SetToAlpha(0); sa:SetDuration(0.6); sa:SetStartDelay(0.2); sa:SetOrder(2)

    -- footer
    primaryBtn = MakeButton(panel, nil, "TomoMod_DialoguePrimary")
    secondaryBtn = MakeButton(panel)

    panel:SetScript("OnKeyDown", OnKey)
    -- Escape when the keys are not ours (combat), or any other hide: the
    -- game is told the conversation is over.
    panel:SetScript("OnHide", function()
        Bind(false)
        Log("panneau caché" .. (current and " (conversation ouverte : fermée)" or ""))
        local S0 = TomoMod_DialogueScene
        if not current then
            if S0 and S0.Leave then S0.Leave() end
            return
        end
        local kind = current.kind
        current = nil
        FinishTyping()
        if kind == "gossip" then
            if C_GossipInfo and C_GossipInfo.CloseGossip then C_GossipInfo.CloseGossip() end
        else
            CloseQuest()
        end
        local S = TomoMod_DialogueScene
        if S and S.Leave then S.Leave() end
    end)
    tinsert(UISpecialFrames, "TomoMod_DialogueFrame")
    if not InCombatLockdown() then panel:SetPropagateKeyboardInput(true) end
    D.Place()
end

function D.Place()
    if not panel then return end
    local db = DB()
    panel:SetScale((db and db.scale) or 1)
    panel:ClearAllPoints()
    if db and db.side == "center" then
        panel:SetPoint("CENTER", UIParent, "CENTER", 0, -40)
    else
        panel:SetPoint("RIGHT", UIParent, "RIGHT", -math.floor(UIParent:GetWidth() * 0.08), 20)
    end
end

-- ---------------------------------------------------------------------
-- Events
-- ---------------------------------------------------------------------
local ev = CreateFrame("Frame")
ev:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_REGEN_DISABLED" then
        -- Fires just before the lockdown: the Space binding can still go.
        Bind(false)
        if panel then panel:EnableKeyboard(false) end
        return
    elseif event == "PLAYER_REGEN_ENABLED" then
        if panel and panel:IsShown() then KeysOn(true) end
        return
    elseif event == "GOSSIP_CLOSED" or event == "QUEST_FINISHED" then
        Log("événement " .. event)
        -- Picking a quest in a gossip closes the gossip AFTER the quest page
        -- came: that close is not the end of the conversation.
        if event == "GOSSIP_CLOSED" and consumeGossipClose and current and current.kind == "quest" then
            consumeGossipClose = false
            return
        end
        CloseSoon()
        return
    elseif event == "QUEST_ITEM_UPDATE" or event == "GET_ITEM_INFO_RECEIVED" then
        if lastEvent == "QUEST_DETAIL" or lastEvent == "QUEST_PROGRESS" or lastEvent == "QUEST_COMPLETE" then
            D.Refresh(true)
        end
        return
    end
    local build = BUILDERS[event]
    if not build then return end
    Log("événement " .. event)
    if event == "GOSSIP_SHOW" then consumeGossipClose = false end
    Create()
    -- A gossip with nothing but one quest or nothing to say still shows:
    -- the player opened it on purpose.
    local ok, page = pcall(build)
    if not ok then
        -- Never leave the player stuck: give the game's window back.
        D.Fallback(event, page)
        return
    end
    if event == "QUEST_COMPLETE" and TomoMod_DialogueRewards and TomoMod_DialogueRewards.Reset then
        TomoMod_DialogueRewards.Reset()
        page = build()
    end
    lastEvent = event
    Open(page)
end)

-- If building a page fails, the game's own window shows this time.
function D.Fallback(event, err)
    if TomoMod_Utils and TomoMod_Utils.Debug then TomoMod_Utils.Debug("Dialogue", event, err) end
    MuteBlizzard(false)
    local f = (event == "GOSSIP_SHOW") and _G.GossipFrame or _G.QuestFrame
    if f then
        local handler = f:GetScript("OnEvent")
        if handler then pcall(handler, f, event) end
    end
    C_Timer.After(0, function() if D.Active() then MuteBlizzard(true) end end)
end

local EVENTS = { "GOSSIP_SHOW", "GOSSIP_CLOSED", "QUEST_GREETING", "QUEST_DETAIL", "QUEST_PROGRESS",
                 "QUEST_COMPLETE", "QUEST_FINISHED", "QUEST_ITEM_UPDATE", "GET_ITEM_INFO_RECEIVED",
                 "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED" }
local active = false

function D.Active() return active end

function D.ApplySettings()
    local db = DB()
    local want = db and db.enabled ~= false and not OtherDialogueAddon()
    if want and not active then
        for _, e in ipairs(EVENTS) do ev:RegisterEvent(e) end
        MuteBlizzard(true)
        active = true
    elseif not want and active then
        ev:UnregisterAllEvents()
        if panel and panel:IsShown() then Goodbye() end
        MuteBlizzard(false)
        active = false
    end
    if panel then D.Place() end
    if TomoMod_DialogueBook and TomoMod_DialogueBook.ApplySettings then TomoMod_DialogueBook.ApplySettings() end
end

function D.SetEnabled(v)
    local db = DB()
    if not db then return end
    db.enabled = v and true or false
    D.ApplySettings()
end

function D.Initialize()
    if not DB() then return end
    if TomoMod_DialogueScene and TomoMod_DialogueScene.Recover then TomoMod_DialogueScene.Recover() end
    D.ApplySettings()
end
