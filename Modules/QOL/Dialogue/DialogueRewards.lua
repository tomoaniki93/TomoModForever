-- =====================================================================
-- Modules/QOL/Dialogue/DialogueRewards.lua -- rewards in the dialogue (1.3.9)
--
-- Cards in two columns: icon in a gold slot, name in its quality colour,
-- count, and two marks:
--   * a green arrow on gear that would be an upgrade for you (usable, and a
--     higher item level than what you wear in that slot, or the slot empty)
--   * a purse on the choice that sells for the most
-- Hover shows the item (Shift compares with yours, like the game's window).
-- When turning in, a click (or keys 1 to 9) picks among the choices; the
-- picked card glows.
-- Also: money, experience, a spell taught; on the progress page, the items
-- the quest asks for with how many you carry.
-- =====================================================================

TomoMod_DialogueRewards = TomoMod_DialogueRewards or {}
local R = TomoMod_DialogueRewards

local FONT      = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-Medium.ttf"
local FONT_BOLD = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Poppins-SemiBold.ttf"
local ART       = "Interface\\AddOns\\TomoModForever\\Assets\\Textures\\Dialogue\\"
local GOLD  = { 0.788, 0.635, 0.322 }
local TEXT  = { 0.949, 0.922, 0.859 }
local DIM   = { 0.700, 0.650, 0.560 }
local GREEN = { 0.450, 0.900, 0.400 }

local CARD_H, GAP = 46, 6

local IS_FR = GetLocale() == "frFR"
local function T(fr, en)
    if TomoMod_GUIT then return TomoMod_GUIT(fr, en) end
    return IS_FR and fr or en
end

local function DB() return TomoModForeverDB and TomoModForeverDB.dialogue end

local function Font(fs, path, size)
    fs:SetFont(path, size, "")
    fs:SetShadowOffset(1, -1)
    fs:SetShadowColor(0, 0, 0, 0.85)
end

local cards, heads = {}, {}
local choice = 0
local onChange

-- ---------------------------------------------------------------------
-- Upgrade check
-- ---------------------------------------------------------------------
local SLOTS = {
    INVTYPE_HEAD = { 1 }, INVTYPE_NECK = { 2 }, INVTYPE_SHOULDER = { 3 }, INVTYPE_BODY = { 4 },
    INVTYPE_CHEST = { 5 }, INVTYPE_ROBE = { 5 }, INVTYPE_WAIST = { 6 }, INVTYPE_LEGS = { 7 },
    INVTYPE_FEET = { 8 }, INVTYPE_WRIST = { 9 }, INVTYPE_HAND = { 10 }, INVTYPE_FINGER = { 11, 12 },
    INVTYPE_TRINKET = { 13, 14 }, INVTYPE_CLOAK = { 15 }, INVTYPE_WEAPON = { 16, 17 },
    INVTYPE_2HWEAPON = { 16 }, INVTYPE_WEAPONMAINHAND = { 16 }, INVTYPE_WEAPONOFFHAND = { 17 },
    INVTYPE_SHIELD = { 17 }, INVTYPE_HOLDABLE = { 17 }, INVTYPE_RANGED = { 18 }, INVTYPE_RANGEDRIGHT = { 18 },
    INVTYPE_THROWN = { 18 }, INVTYPE_RELIC = { 18 },
}

local function ItemLevel(link)
    if not link then return nil end
    if C_Item and C_Item.GetDetailedItemLevelInfo then
        local lvl = C_Item.GetDetailedItemLevelInfo(link)
        if lvl then return lvl end
    end
    if C_Item and C_Item.GetItemInfo then
        local _, _, _, lvl = C_Item.GetItemInfo(link)
        return lvl
    end
    return nil
end

local function IsUpgrade(link, usable)
    if not (link and usable) then return false end
    local equipLoc
    if C_Item and C_Item.GetItemInfoInstant then
        local _, _, _, loc = C_Item.GetItemInfoInstant(link)
        equipLoc = loc
    end
    local slots = equipLoc and SLOTS[equipLoc]
    if not slots then return false end
    local mine = ItemLevel(link)
    if not mine then return false end
    local worst
    for _, slot in ipairs(slots) do
        local worn = GetInventoryItemLink("player", slot)
        if not worn then return true end
        local lvl = ItemLevel(worn) or 0
        if not worst or lvl < worst then worst = lvl end
    end
    return worst ~= nil and mine > worst
end

local function SellValue(link, count)
    if not (link and C_Item and C_Item.GetItemInfo) then return 0 end
    local price = select(11, C_Item.GetItemInfo(link))
    return (price or 0) * (count or 1)
end

-- ---------------------------------------------------------------------
-- Widgets
-- ---------------------------------------------------------------------
local function GetHead(parent, i)
    local h = heads[i]
    if not h then
        h = parent:CreateFontString(nil, "OVERLAY")
        heads[i] = h
    end
    h:SetParent(parent)
    Font(h, FONT_BOLD, 14)
    h:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
    h:SetJustifyH("LEFT")
    return h
end

local function CardTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    if self.itemType and self.index then
        GameTooltip:SetQuestItem(self.itemType, self.index)
        if IsModifiedClick and IsModifiedClick("COMPAREITEMS") and GameTooltip_ShowCompareItem then
            GameTooltip_ShowCompareItem(GameTooltip)
        end
    elseif self.spellName then
        GameTooltip:AddLine(self.spellName, 1, 1, 1)
    elseif self.tip then
        GameTooltip:AddLine(self.tip, 1, 1, 1)
    end
    GameTooltip:Show()
    self.hover:Show()
end

local function GetCard(parent, i)
    local c = cards[i]
    if c then c:SetParent(parent); return c end
    c = CreateFrame("Button", nil, parent)
    c:SetHeight(CARD_H)
    c.bg = c:CreateTexture(nil, "BACKGROUND")
    c.bg:SetAllPoints()
    c.bg:SetColorTexture(0, 0, 0, 0.28)
    c.hover = c:CreateTexture(nil, "BACKGROUND", nil, 1)
    c.hover:SetAllPoints()
    c.hover:SetTexture(ART .. "highlight.tga")
    c.hover:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0.25)
    c.hover:Hide()
    c.pick = c:CreateTexture(nil, "BORDER")
    c.pick:SetAllPoints()
    c.pick:SetTexture(ART .. "button.tga")
    c.pick:SetVertexColor(1, 0.82, 0.2, 1)
    c.pick:Hide()
    c.slot = c:CreateTexture(nil, "ARTWORK", nil, 2)
    c.slot:SetSize(40, 40)
    c.slot:SetPoint("LEFT", 3, 0)
    c.slot:SetTexture(ART .. "slot.tga")
    c.icon = c:CreateTexture(nil, "ARTWORK", nil, 1)
    c.icon:SetSize(32, 32)
    c.icon:SetPoint("CENTER", c.slot, "CENTER")
    c.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    c.count = c:CreateFontString(nil, "OVERLAY")
    Font(c.count, FONT_BOLD, 11)
    c.count:SetPoint("BOTTOMRIGHT", c.icon, "BOTTOMRIGHT", 1, -1)
    c.name = c:CreateFontString(nil, "OVERLAY")
    Font(c.name, FONT, 12)
    c.name:SetPoint("LEFT", c.slot, "RIGHT", 6, 0)
    c.name:SetPoint("RIGHT", -24, 0)
    c.name:SetJustifyH("LEFT")
    c.name:SetMaxLines(2)
    c.up = c:CreateTexture(nil, "OVERLAY")
    c.up:SetSize(14, 14)
    c.up:SetPoint("TOPLEFT", c.icon, "TOPLEFT", -2, 2)
    c.up:SetTexture(ART .. "upgrade.tga")
    c.up:SetVertexColor(GREEN[1], GREEN[2], GREEN[3])
    c.purse = c:CreateTexture(nil, "OVERLAY")
    c.purse:SetSize(16, 16)
    c.purse:SetPoint("RIGHT", -5, 0)
    if C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo("Banker") then
        c.purse:SetAtlas("Banker")
    else
        c.purse:SetTexture("Interface\\Icons\\INV_Misc_Coin_01")
    end
    c.num = c:CreateFontString(nil, "OVERLAY")
    Font(c.num, FONT_BOLD, 10)
    c.num:SetPoint("TOPRIGHT", -5, -3)
    c.num:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
    c:SetScript("OnEnter", CardTooltip)
    c:SetScript("OnLeave", function(self) GameTooltip:Hide(); self.hover:Hide() end)
    c:SetScript("OnClick", function(self)
        if self.choiceIndex then
            if IsModifiedClick and IsModifiedClick("DRESSUP") and self.link then
                DressUpItemLink(self.link)
                return
            end
            choice = self.choiceIndex
            if onChange then onChange() end
        elseif IsModifiedClick and IsModifiedClick("CHATLINK") and self.link then
            ChatEdit_InsertLink(self.link)
        end
    end)
    cards[i] = c
    return c
end

-- ---------------------------------------------------------------------
-- Data
-- ---------------------------------------------------------------------
local function ReadItems(kind, num)
    local list = {}
    for i = 1, num do
        local name, texture, count, quality, isUsable, itemID = GetQuestItemInfo(kind, i)
        local link = GetQuestItemLink and GetQuestItemLink(kind, i)
        if (not quality or quality < 0) and link and C_Item and C_Item.GetItemInfo then
            quality = select(3, C_Item.GetItemInfo(link))
        end
        list[#list + 1] = {
            itemType = kind, index = i, itemID = itemID, name = name or (itemID and ("item:" .. itemID)) or "...",
            icon = texture, count = count, quality = quality, usable = isUsable ~= false, link = link,
        }
    end
    return list
end

-- [1.3.9] How many the player carries. The item ID first (the link of a
-- required item is often missing on the progress page, which read 0); and
-- when the game says the quest can be turned in, all are there.
function R.Carried(it)
    local need = it.count or 1
    if IsQuestCompletable and IsQuestCompletable() then return need end
    local n = 0
    local count = (C_Item and C_Item.GetItemCount) or GetItemCount
    local key = it.itemID or it.link or it.name
    if count and key then
        local ok, v = pcall(count, key)
        if ok and type(v) == "number" then n = v end
    end
    if n == 0 and it.name and count then
        local ok, v = pcall(count, it.name)
        if ok and type(v) == "number" then n = v end
    end
    return n
end

-- ---------------------------------------------------------------------
-- Build
-- ---------------------------------------------------------------------
function R.Reset() choice = 0 end
function R.Choice() return choice end

--- Picks choice `n` (keys 1 to 9) when turning in. True if it exists.
function R.Pick(n)
    local num = GetNumQuestChoices and GetNumQuestChoices() or 0
    if n >= 1 and n <= num then choice = n; return true end
    return false
end

function R.Hide()
    for _, c in ipairs(cards) do c:Hide() end
    for _, h in ipairs(heads) do h:Hide() end
end

--- Lays the rewards of `mode` ("detail", "complete", "progress") into
--- `parent` from `y` down, `width` wide. Returns the height used.
function R.Build(parent, mode, width, y, changed)
    onChange = changed
    R.Hide()
    local db = DB()
    local detailed = not (db and db.rewardsDetail == false)
    local startY = y
    local ci, hi = 0, 0
    local colW = math.floor((width - GAP) / 2)

    local function Head(text)
        hi = hi + 1
        local h = GetHead(parent, hi)
        h:SetText(text)
        h:ClearAllPoints()
        h:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, y - 4)
        h:Show()
        y = y - 24
    end

    local function Grid(list, opts)
        local best, bestVal = nil, 0
        if opts.purse and detailed and #list > 1 then
            for k, it in ipairs(list) do
                local v = SellValue(it.link, it.count)
                if v > bestVal then best, bestVal = k, v end
            end
        end
        for k, it in ipairs(list) do
            ci = ci + 1
            local c = GetCard(parent, ci)
            local col = (k - 1) % 2
            c:ClearAllPoints()
            c:SetPoint("TOPLEFT", parent, "TOPLEFT", col * (colW + GAP), y)
            c:SetWidth(colW)
            c.icon:SetTexture(it.icon or 134400)
            c.count:SetText((it.count and it.count > 1) and it.count or "")
            local qc = it.quality and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[it.quality]
            if detailed and qc then
                c.name:SetTextColor(qc.r, qc.g, qc.b)
                c.slot:SetVertexColor(qc.r, qc.g, qc.b, 0.95)
            else
                c.name:SetTextColor(TEXT[1], TEXT[2], TEXT[3])
                c.slot:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0.9)
            end
            c.name:SetText(it.name or "")
            if opts.have then
                local carried = R.Carried(it)
                local ok = carried >= (it.count or 1)
                c.count:SetText(carried .. "/" .. (it.count or 1))
                c.count:SetTextColor(ok and GREEN[1] or 1, ok and GREEN[2] or 0.35, ok and GREEN[3] or 0.3)
            else
                c.count:SetTextColor(1, 1, 1)
            end
            c.icon:SetDesaturated(not it.usable)
            c.up:SetShown(detailed and IsUpgrade(it.link, it.usable))
            c.purse:SetShown(best == k)
            c.itemType, c.index, c.link, c.spellName, c.tip = it.itemType, it.index, it.link, it.spellName, it.tip
            c.choiceIndex = opts.choose and k or nil
            c.num:SetText((opts.choose and k <= 9) and tostring(k) or "")
            c.pick:SetShown(opts.choose and choice == k)
            c:Show()
            if col == 1 or k == #list then y = y - CARD_H - GAP end
        end
    end

    if mode == "progress" then
        local list = ReadItems("required", GetNumQuestItems and GetNumQuestItems() or 0)
        local money = GetQuestMoneyToGet and GetQuestMoneyToGet() or 0
        if #list > 0 or money > 0 then
            Head(T("À apporter", "To bring"))
            Grid(list, { have = true })
            if money > 0 then
                ci = ci + 1
                local c = GetCard(parent, ci)
                c:ClearAllPoints(); c:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, y); c:SetWidth(colW)
                c.icon:SetTexture("Interface\\Icons\\INV_Misc_Coin_01")
                c.name:SetText(GetCoinTextureString(money)); c.name:SetTextColor(TEXT[1], TEXT[2], TEXT[3])
                c.slot:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0.9)
                c.count:SetText(""); c.up:Hide(); c.purse:Hide(); c.pick:Hide(); c.num:SetText("")
                c.itemType, c.index, c.link, c.choiceIndex = nil, nil, nil, nil
                c:Show()
                y = y - CARD_H - GAP
            end
        end
        return startY - y
    end

    local choices = ReadItems("choice", GetNumQuestChoices and GetNumQuestChoices() or 0)
    local fixed = ReadItems("reward", GetNumQuestRewards and GetNumQuestRewards() or 0)
    local money = GetRewardMoney and GetRewardMoney() or 0
    local xp = GetRewardXP and GetRewardXP() or 0
    local spellTex, spellName
    if GetRewardSpell then spellTex, spellName = GetRewardSpell() end

    if #choices + #fixed == 0 and money == 0 and xp == 0 and not spellName then return 0 end
    Head(T("Récompenses", "Rewards"))

    if #choices > 0 then
        if #choices > 1 then
            hi = hi + 1
            local h = GetHead(parent, hi)
            Font(h, FONT, 12)
            h:SetTextColor(DIM[1], DIM[2], DIM[3])
            h:SetText(mode == "complete" and T("Choisis une récompense :", "Choose one reward:")
                or T("Tu pourras choisir parmi :", "You will choose one of:"))
            h:ClearAllPoints()
            h:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, y)
            h:Show()
            y = y - 20
        end
        Grid(choices, { purse = true, choose = mode == "complete" and #choices > 1 })
    end
    if #fixed > 0 then
        if #choices > 0 then
            hi = hi + 1
            local h = GetHead(parent, hi)
            Font(h, FONT, 12)
            h:SetTextColor(DIM[1], DIM[2], DIM[3])
            h:SetText(T("Tu recevras aussi :", "You will also receive:"))
            h:ClearAllPoints()
            h:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, y)
            h:Show()
            y = y - 20
        end
        Grid(fixed, {})
    end
    -- money, experience, spell on one line of small cards
    local extras = {}
    if spellName then extras[#extras + 1] = { icon = spellTex, name = spellName, spellName = spellName } end
    if money > 0 then extras[#extras + 1] = { icon = "Interface\\Icons\\INV_Misc_Coin_01", name = GetCoinTextureString(money) } end
    if xp > 0 then
        extras[#extras + 1] = { icon = "Interface\\Icons\\XP_Icon", name = (BreakUpLargeNumbers and BreakUpLargeNumbers(xp) or xp) .. " " .. T("points d'expérience", "experience"),
            tip = T("Expérience", "Experience") }
    end
    for k, it in ipairs(extras) do
        it.usable = true
        ci = ci + 1
        local c = GetCard(parent, ci)
        local col = (k - 1) % 2
        c:ClearAllPoints()
        c:SetPoint("TOPLEFT", parent, "TOPLEFT", col * (colW + GAP), y)
        c:SetWidth(colW)
        c.icon:SetTexture(it.icon or 134400)
        c.icon:SetDesaturated(false)
        c.name:SetText(it.name); c.name:SetTextColor(TEXT[1], TEXT[2], TEXT[3])
        c.slot:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0.9)
        c.count:SetText(""); c.up:Hide(); c.purse:Hide(); c.pick:Hide(); c.num:SetText("")
        c.itemType, c.index, c.link, c.choiceIndex = nil, nil, nil, nil
        c.spellName, c.tip = it.spellName, it.tip
        c:Show()
        if col == 1 or k == #extras then y = y - CARD_H - GAP end
    end
    return startY - y
end
