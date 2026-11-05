-- =====================================================================
-- Panels/SpellBars.lua -- "Barres de sorts" (CooldownForge)
-- Replaces the Cooldown Studio with the essentials: create a bar, fill
-- it with spells (by name or ID, or straight from Blizzard's cooldown
-- lists), size it, choose when it shows. Positions are set with "Move".
-- =====================================================================

local K = TomoMod_Kit
local W = TomoMod_Widgets
local TH = W.Theme
local T = K.T

local function CDF() return TomoMod_CooldownForge end

local function Bars()
    local cdf = CDF()
    if not (cdf and cdf.GetClassBars) then return nil end
    return cdf.GetClassBars()
end

local function SelectedBar()
    local bars = Bars()
    if not bars or #bars == 0 then return nil end
    local want = K.GuiDB().cdfBar
    for _, b in ipairs(bars) do
        if b.id == want then return b end
    end
    K.GuiDB().cdfBar = bars[1].id
    return bars[1]
end

local function Select(id)
    K.GuiDB().cdfBar = id
    K.Apply("cdf")
    K.RefreshPage()
end

local function SpellFromText(txt)
    local id = tonumber(txt)
    if id then return id end
    if C_Spell and C_Spell.GetSpellInfo then
        local info = C_Spell.GetSpellInfo(txt)
        if type(info) == "table" and info.spellID then return info.spellID end
    end
    if GetSpellInfo then
        local _, _, _, _, _, _, sid = GetSpellInfo(txt)
        return sid
    end
end

local function EntryInfo(e)
    if e.kind == "spell" and e.id then
        local name = C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(e.id)
        local icon = C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(e.id)
        return name or ("#" .. e.id), icon
    elseif e.kind == "item" and e.id then
        local name = C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(e.id)
        local icon = C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(e.id)
        return name or ("item " .. e.id), icon
    elseif e.kind == "equippedTrinket" then
        return T("Bijou équipé ", "Equipped trinket ") .. tostring(e.slot or ""), GetInventoryItemTexture and GetInventoryItemTexture("player", e.slot or 13)
    elseif e.kind == "racial" then
        return T("Racial", "Racial"), 136243
    end
    return e.preset or e.kind or "?", 134400
end

-- A compact list row: icon, name, up / down / remove.
local function SmallButton(parent, text, onClick, tip)
    local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
    b:SetSize(24, 22)
    b:SetBackdrop({ bgFile = K.WHITE, edgeFile = K.WHITE, edgeSize = 1 })
    b:SetBackdropColor(TH.bgLight[1], TH.bgLight[2], TH.bgLight[3], 1)
    b:SetBackdropBorderColor(TH.border[1], TH.border[2], TH.border[3], 1)
    local t = b:CreateFontString(nil, "OVERLAY")
    t:SetFont(K.FONT_BOLD, 11, "")
    t:SetPoint("CENTER")
    t:SetText(text)
    t:SetTextColor(TH.text[1], TH.text[2], TH.text[3], 1)
    b:SetScript("OnEnter", function(s) s:SetBackdropBorderColor(TH.accent[1], TH.accent[2], TH.accent[3], 1) end)
    b:SetScript("OnLeave", function(s) s:SetBackdropBorderColor(TH.border[1], TH.border[2], TH.border[3], 1) end)
    b:SetScript("OnClick", onClick)
    if tip then W.SetTooltip(b, tip) end
    return b
end

local function EntryRows(c, bar)
    c:Custom(function(parent, y)
        local cdf = CDF()
        local entries = bar.entries or {}
        if #entries == 0 then
            local _, ny = W.CreateInfoText(parent, T("Aucun sort pour l'instant. Ajoute-en un ci-dessous.",
                                                     "No spells yet. Add one below."), y)
            return ny
        end
        for i, e in ipairs(entries) do
            local row = CreateFrame("Frame", nil, parent)
            row:SetHeight(26)
            row:SetPoint("TOPLEFT", 16, y)
            row:SetPoint("TOPRIGHT", -16, y)
            local name, icon = EntryInfo(e)
            local ic = row:CreateTexture(nil, "ARTWORK")
            ic:SetSize(22, 22)
            ic:SetPoint("LEFT", 0, 0)
            ic:SetTexture(icon or 134400)
            ic:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            local fs = row:CreateFontString(nil, "OVERLAY")
            fs:SetFont(K.FONT, 11, "")
            fs:SetPoint("LEFT", ic, "RIGHT", 8, 0)
            fs:SetPoint("RIGHT", row, "RIGHT", -90, 0)
            fs:SetJustifyH("LEFT")
            fs:SetTextColor(TH.text[1], TH.text[2], TH.text[3], 1)
            fs:SetText(name .. (e.mode == "aura" and T("  (buff)", "  (buff)") or ""))
            local del = SmallButton(row, "x", function()
                cdf.RemoveEntry(nil, bar.id, i); K.Apply("cdf"); K.RefreshPage()
            end, T("Retirer", "Remove"))
            del:SetPoint("RIGHT", 0, 0)
            local down = SmallButton(row, "v", function()
                cdf.MoveEntry(nil, bar.id, i, 1); K.Apply("cdf"); K.RefreshPage()
            end, T("Descendre", "Move down"))
            down:SetPoint("RIGHT", del, "LEFT", -4, 0)
            local up = SmallButton(row, "^", function()
                cdf.MoveEntry(nil, bar.id, i, -1); K.Apply("cdf"); K.RefreshPage()
            end, T("Monter", "Move up"))
            up:SetPoint("RIGHT", down, "LEFT", -4, 0)
            if W._RegisterSearchEntry then W._RegisterSearchEntry(name, row, "option") end
            y = y - 28
        end
        return y - 4
    end)
end

K.RegisterPage({
    key = "spellbars",
    section = "combat",
    label = T("Barres de sorts", "Spell bars"),
    kw = "cooldown cooldowns cd recharge barres sorts spells forge suivi tracker icones",
    locate = function()
        local cdf, bar = CDF(), SelectedBar()
        return cdf and bar and cdf._barFrames and cdf._barFrames[bar.id]
    end,
    build = function(parent)
        return K.Page(parent, function(page)
            local cdf = CDF()
            page:Hero(T("Barres de sorts", "Spell bars"),
                T("Des rangées d'icônes qui montrent tes recharges. Une liste par classe.",
                  "Rows of icons showing your cooldowns. One list per class."),
                function()
                    local bar = SelectedBar()
                    return cdf and bar and cdf._barFrames and cdf._barFrames[bar.id]
                end, T("Barre de sorts", "Spell bar"))

            if not (cdf and cdf.GetClassBars) then
                local c = page:Card(T("Indisponible", "Unavailable"))
                c:Info(T("Le module de barres de sorts n'est pas chargé.", "The spell bar module is not loaded."))
                c:Done()
                return
            end

            local c = page:Card(T("Activation", "On / off"))
            c:Toggle(T("Activer les barres de sorts", "Enable spell bars"), {
                get = function() return K.IsModuleOn("cooldownForge") end,
                set = function(v) K.SetModule("cooldownForge", v) end,
            }, "cdf")
            c:Done()

            -- ---- choose / create ------------------------------------------
            local bars = Bars() or {}
            local bar = SelectedBar()
            c = page:Card(T("Mes barres", "My bars"))
            if #bars > 0 then
                local opts = {}
                for _, b in ipairs(bars) do
                    opts[#opts + 1] = { text = b.name .. "  (" .. #(b.entries or {}) .. ")", value = b.id }
                end
                c:Select(T("Barre à modifier", "Bar to edit"), {
                    get = function() return bar and bar.id end,
                    set = function(v) Select(v) end,
                }, opts, nil)
            end
            c:Pair(function(l)
                l:Button(T("Nouvelle barre vide", "New empty bar"), function()
                    local _, id = cdf.CreateBar(nil, T("Ma barre ", "My bar ") .. (#bars + 1))
                    if id then Select(id) end
                end, 200)
            end, function(r)
                if bar then
                    r:Danger(T("Supprimer cette barre", "Delete this bar"), function()
                        cdf.DeleteBar(nil, bar.id); K.GuiDB().cdfBar = nil; K.Apply("cdf"); K.RefreshPage()
                    end, 200)
                end
            end)
            if cdf.CreateBarFromViewer then
                c:Label(T("Créer depuis les listes de recharges de Blizzard :", "Create from Blizzard's cooldown lists:"))
                c:Custom(function(parent, y)
                    local x = 16
                    for _, key in ipairs({ "essential", "utility", "buff" }) do
                        local def = cdf.VIEWER_IMPORTS and cdf.VIEWER_IMPORTS[key]
                        if def then
                            local label = ({ essential = T("Essentiels", "Essential"),
                                             utility = T("Utilitaires", "Utility"),
                                             buff = T("Buffs suivis", "Tracked buffs") })[key]
                            local btn = W.CreateButton(parent, label, 130, y, function()
                                local id, status = cdf.CreateBarFromViewer(nil, key)
                                if id then Select(id) else
                                    K.Toast(T("Liste Blizzard vide ou indisponible", "Blizzard list empty or unavailable"), 1, 0.55, 0.3)
                                end
                            end)
                            btn:ClearAllPoints()
                            btn:SetPoint("TOPLEFT", x, y)
                            x = x + 138
                        end
                    end
                    return y - 34
                end)
            end
            c:Done()

            if not bar then
                page:Intro(T("Crée une barre pour commencer. Elle apparaît au centre de l'écran : déplace-la avec « Déplacer ».",
                             "Create a bar to begin. It appears in the middle of the screen: move it with \"Move\"."))
                return
            end

            -- ---- the selected bar ---------------------------------------------
            local function BarBind(field)
                return {
                    get = function() return bar[field] end,
                    set = function(v) bar[field] = v; if cdf.SanitizeBar then cdf.SanitizeBar(bar) end end,
                    default = cdf.NewBarSchema and cdf.NewBarSchema()[field],
                }
            end

            c = page:Card(T("Sorts de « ", "Spells in \"") .. bar.name .. T(" »", "\""))
            EntryRows(c, bar)
            c:Input(nil, T("Nom ou numéro du sort (ex. : Nova de givre)", "Spell name or ID (e.g. Frost Nova)"),
                T("Ajouter", "Add"), function(txt)
                    local id = SpellFromText(txt)
                    if not id then
                        K.Toast(T("Sort introuvable (vérifie l'orthographe)", "Spell not found (check the spelling)"), 1, 0.55, 0.3)
                        return false
                    end
                    cdf.AddEntry(nil, bar.id, { kind = "spell", id = id })
                    K.Apply("cdf"); K.RefreshPage()
                    return true
                end)
            c:Info(T("Astuce : pour suivre un buff (pas une recharge), ajoute-le puis active « Mode buff » en mode expert.",
                     "Tip: to track a buff (not a cooldown), add it then enable \"Buff mode\" in expert mode."))
            c:Done()

            c = page:Card(T("Apparence", "Look"))
            c:Input(T("Nom de la barre", "Bar name"), "", T("Renommer", "Rename"), function(txt)
                cdf.RenameBar(nil, bar.id, txt); K.RefreshPage(); return false
            end, bar.name)
            c:Slider(T("Taille des icônes", "Icon size"), BarBind("iconSize"), cdf.ICON_MIN or 8, cdf.ICON_MAX or 128, 1, "cdf")
            c:Slider(T("Espacement", "Spacing"), BarBind("spacing"), 0, 30, 1, "cdf")
            c:Seg(T("Direction", "Direction"), {
                get = function() return bar.growth end,
                set = function(v)
                    bar.growth = v
                    bar.orientation = (v == "UP" or v == "DOWN") and "vertical" or "horizontal"
                end,
            }, {
                { text = T("Droite", "Right"), value = "RIGHT" },
                { text = T("Gauche", "Left"),  value = "LEFT" },
                { text = T("Haut", "Up"),      value = "UP" },
                { text = T("Bas", "Down"),     value = "DOWN" },
            }, "cdf", 4)
            c:Slider(T("Icônes par ligne (0 = une seule ligne)", "Icons per line (0 = single line)"), BarBind("wrap"), 0, 12, 1, "cdf")
            c:Seg(T("Texte sur l'icône", "Text on the icon"), {
                get = function() return bar.text and bar.text.mode end,
                set = function(v) bar.text = bar.text or {}; bar.text.mode = v end,
            }, {
                { text = T("Temps", "Timer"), value = "timer" },
                { text = T("Nom", "Name"),    value = "name" },
                { text = T("Rien", "None"),   value = "none" },
            }, "cdf", 3)
            c:Done()

            c = page:Card(T("Comportement", "Behaviour"))
            c:Toggle(T("Barre active", "Bar enabled"), BarBind("enabled"), "cdf")
            c:Toggle(T("Seulement en combat", "Only in combat"), {
                get = function() return type(bar.visibility) == "table" and bar.visibility.inCombat == true end,
                set = function(v)
                    if v then
                        bar.visibility = bar.visibility or {}
                        bar.visibility.inCombat = true
                    elseif type(bar.visibility) == "table" then
                        bar.visibility.inCombat = nil
                        if next(bar.visibility) == nil then bar.visibility = nil end
                    end
                end,
            }, "cdf")
            c:Toggle(T("Lueur quand le sort est prêt", "Glow when the spell is ready"), {
                get = function() return bar.glow and bar.glow.enabled end,
                set = function(v) bar.glow = bar.glow or {}; bar.glow.enabled = v end,
            }, "cdf")
            c:Toggle(T("Cacher les sorts en recharge", "Hide spells on cooldown"), BarBind("hideOnCooldown"), "cdf")
            c:Done()

            c = page:Card(T("Mode buff par sort", "Buff mode per spell"), { adv = true })
            c:Info(T("Un sort en mode buff s'affiche seulement quand le buff est actif, avec sa durée.",
                     "A spell in buff mode shows only while the buff is up, with its duration."))
            for _, e in ipairs(bar.entries or {}) do
                if e.kind == "spell" then
                    local name = EntryInfo(e)
                    c:Toggle(name, {
                        get = function() return e.mode == "aura" end,
                        set = function(v) e.mode = v and "aura" or nil end,
                    }, "cdf")
                end
            end
            c:Done()

            c = page:Card(T("Partager", "Share"), { adv = true })
            c:Button(T("Exporter cette barre", "Export this bar"), function()
                local str = cdf.ExportBar and cdf.ExportBar(nil, bar.id)
                if str and TomoMod_Config and TomoMod_Config.ShowExportString then
                    TomoMod_Config.ShowExportString(str)
                end
            end, 200)
            c:Input(nil, T("Colle un code de barre ici", "Paste a bar code here"), T("Importer", "Import"), function(txt)
                local ok = cdf.Import and cdf.Import(txt)
                if ok then K.Apply("cdf"); K.RefreshPage(); return true end
                K.Toast(T("Code invalide", "Invalid code"), 1, 0.55, 0.3)
                return false
            end)
            c:Done()
        end)
    end,
})
