-- =====================================================================
-- Modules/QOL/Forever/GatherTips.lua -- gathering skill in tooltips (1.3.6)
--
-- On a herb or ore node, the game's "Requires Herbalism" / "Requires
-- Mining" line gains the skill the node needs ("Requires Mining (75)") and
-- takes the colour of your chance to raise your skill there, as recipes
-- show it: orange (sure), yellow, green, grey (no more points). Red when
-- your skill is too low, or when you do not have the profession.
-- Skinning (option): a skinnable corpse's "Skinnable" line gains the skill
-- it needs, worked out from the creature's level as Classic does it
-- (1 up to level 10, then (level - 10) x 10 up to 20, then level x 5).
--
-- Node skill table: the Classic values, by node name in English and in
-- French (lower case). A node missing from the table (another language, a
-- new Forever node) keeps the game's line untouched.
-- =====================================================================

TomoMod_GatherTips = TomoMod_GatherTips or {}
local GT = TomoMod_GatherTips

local HERB, MINE, SKIN = 182, 186, 393   -- skill lines

local NODES = {
    -- Herbs: English, French, skill
    { HERB, "peacebloom", "pacifique", 1 },
    { HERB, "silverleaf", "feuillargent", 1 },
    { HERB, "earthroot", "terrestrine", 15 },
    { HERB, "mageroyal", "mage royal", 50 },
    { HERB, "briarthorn", "aubépine", 70 },
    { HERB, "stranglekelp", "algue étrangleuse", 85 },
    { HERB, "bruiseweed", "doulourante", 100 },
    { HERB, "wild steelbloom", "aciérite sauvage", 115 },
    { HERB, "grave moss", "tombeline", 120 },
    { HERB, "kingsblood", "sang-royal", 125 },
    { HERB, "liferoot", "vietérule", 150 },
    { HERB, "fadeleaf", "pâlerette", 160 },
    { HERB, "goldthorn", "dorépine", 170 },
    { HERB, "khadgar's whisker", "moustache de khadgar", 185 },
    { HERB, "wintersbite", "hivernale", 195 },
    { HERB, "firebloom", "fleur de feu", 205 },
    { HERB, "purple lotus", "lotus pourpre", 210 },
    { HERB, "arthas' tears", "larmes d'arthas", 220 },
    { HERB, "sungrass", "soleillette", 230 },
    { HERB, "blindweed", "aveuglette", 235 },
    { HERB, "ghost mushroom", "champignon fantôme", 245 },
    { HERB, "gromsblood", "gromsang", 250 },
    { HERB, "golden sansam", "sansam doré", 260 },
    { HERB, "dreamfoil", "feuillerêve", 270 },
    { HERB, "mountain silversage", "sauge-argent des montagnes", 280 },
    { HERB, "plaguebloom", "fleur de peste", 285 },
    { HERB, "icecap", "calot de glace", 290 },
    { HERB, "black lotus", "lotus noir", 300 },
    -- Ores
    { MINE, "copper vein", "filon de cuivre", 1 },
    { MINE, "tin vein", "filon d'étain", 65 },
    { MINE, "incendicite mineral vein", "filon d'incendicite", 65 },
    { MINE, "silver vein", "filon d'argent", 75 },
    { MINE, "lesser bloodstone deposit", "gisement de pierre de sang inférieure", 75 },
    { MINE, "ooze covered silver vein", "filon d'argent couvert de vase", 75 },
    { MINE, "iron deposit", "gisement de fer", 125 },
    { MINE, "indurium mineral vein", "filon d'indurium", 150 },
    { MINE, "gold vein", "filon d'or", 155 },
    { MINE, "ooze covered gold vein", "filon d'or couvert de vase", 155 },
    { MINE, "mithril deposit", "gisement de mithril", 175 },
    { MINE, "ooze covered mithril deposit", "gisement de mithril couvert de vase", 175 },
    { MINE, "truesilver deposit", "gisement de vrai-argent", 230 },
    { MINE, "ooze covered truesilver deposit", "gisement de vrai-argent couvert de vase", 230 },
    { MINE, "dark iron deposit", "gisement de sombrefer", 230 },
    { MINE, "small thorium vein", "petit filon de thorium", 245 },
    { MINE, "ooze covered thorium vein", "filon de thorium couvert de vase", 245 },
    { MINE, "rich thorium vein", "riche filon de thorium", 275 },
    { MINE, "ooze covered rich thorium vein", "riche filon de thorium couvert de vase", 275 },
}

local byName = {}
for _, n in ipairs(NODES) do
    byName[n[2]] = { line = n[1], req = n[4] }
    byName[n[3]] = { line = n[1], req = n[4] }
end

-- Profession names, to find the game's line (localized names come from the
-- player's own professions; these cover the rest).
local LINE_NAMES = {
    [HERB] = { "herbalism", "herboristerie", "kräuterkunde", "herboristería", "erbalismo", "herborismo" },
    [MINE] = { "mining", "minage", "bergbau", "minería", "estrazione", "mineração" },
}

local function DB() return TomoModForeverDB and TomoModForeverDB.gatherTips end

local function Readable(v)
    if type(issecretvalue) == "function" and issecretvalue(v) then return nil end
    return v
end

-- Player's skill in a line: rank (nil when the profession is not known).
local function Skill(line)
    if GetProfessions and GetProfessionInfo then
        for _, idx in ipairs({ GetProfessions() }) do
            if idx then
                local name, _, rank, _, _, _, skillLine = GetProfessionInfo(idx)
                if skillLine == line then return rank, name end
            end
        end
    end
    if GetNumSkillLines and GetSkillLineInfo then
        local wanted = LINE_NAMES[line] or {}
        if line == SKIN then wanted = { "skinning", "dépeçage", "kürschnerei", "desuello", "scuoiatura", "esfolamento" } end
        for i = 1, GetNumSkillLines() do
            local name, isHeader, _, rank = GetSkillLineInfo(i)
            if name and not isHeader then
                local low = name:lower()
                for _, w in ipairs(wanted) do
                    if low == w then return rank, name end
                end
            end
        end
    end
    return nil
end

-- Recipe colours: red (too low), orange, yellow, green, grey.
local function Color(rank, req)
    if not rank or rank < req then return 1, 0.13, 0.13 end
    if rank < req + 25 then return 1, 0.50, 0.25 end
    if rank < req + 50 then return 1, 1, 0 end
    if rank < req + 100 then return 0.25, 0.75, 0.25 end
    return 0.55, 0.55, 0.55
end

local function Lines(tooltip)
    local name = tooltip.GetName and tooltip:GetName()
    if not name then return nil end
    return name, tooltip.NumLines and tooltip:NumLines() or 0
end

local function MatchesLine(text, line)
    local low = text:lower()
    for _, n in ipairs(LINE_NAMES[line] or {}) do
        if low:find(n, 1, true) then return true end
    end
    local _, profName = Skill(line)
    if profName and low:find(profName:lower(), 1, true) then return true end
    return false
end

local function Decorate(fs, req, line)
    local text = fs:GetText()
    if type(text) ~= "string" or text:find("%(%d+%)") then return end
    fs:SetText(text .. " (" .. req .. ")")
    fs:SetTextColor(Color(Skill(line), req))
end

-- Herb / ore node tooltips (world objects).
local function OnAny(tooltip)
    local db = DB()
    if not (db and db.enabled) or tooltip ~= GameTooltip then return end
    if tooltip.IsForbidden and tooltip:IsForbidden() then return end
    local tname, n = Lines(tooltip)
    if not tname or n < 2 then return end
    local first = _G[tname .. "TextLeft1"]
    local title = first and Readable(first:GetText())
    if type(title) ~= "string" then return end
    local node = byName[title:lower()]
    if not node then return end
    for i = 2, n do
        local fs = _G[tname .. "TextLeft" .. i]
        local text = fs and Readable(fs:GetText())
        if type(text) == "string" and MatchesLine(text, node.line) then
            Decorate(fs, node.req, node.line)
            tooltip:Show()
            return
        end
    end
end

-- Skinnable corpses.
local function SkinReq(level)
    if level <= 10 then return 1 end
    if level <= 20 then return (level - 10) * 10 end
    return level * 5
end

local function OnUnit(tooltip)
    local db = DB()
    if not (db and db.enabled and db.skinning) or tooltip ~= GameTooltip then return end
    if tooltip.IsForbidden and tooltip:IsForbidden() then return end
    local ok, _, unit = pcall(tooltip.GetUnit, tooltip)
    if not ok or not unit then return end
    local level = Readable(UnitLevel(unit))
    if type(level) ~= "number" or level < 1 then return end
    local skinnable = _G.UNIT_SKINNABLE_LEATHER
    if type(skinnable) ~= "string" then return end
    local tname, n = Lines(tooltip)
    if not tname then return end
    for i = 2, n do
        local fs = _G[tname .. "TextLeft" .. i]
        local text = fs and Readable(fs:GetText())
        if text == skinnable then
            Decorate(fs, SkinReq(level), SKIN)
            tooltip:Show()
            return
        end
    end
end

function GT.ApplySettings() end

function GT.SetEnabled(v)
    local db = DB()
    if db then db.enabled = v and true or false end
end

local hooked = false
function GT.Initialize()
    if not DB() or hooked then return end
    if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
        local all = TooltipDataProcessor.AllTypes or "ALL"
        TooltipDataProcessor.AddTooltipPostCall(all, OnAny)
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, OnUnit)
        hooked = true
    elseif GameTooltip and GameTooltip.HookScript then
        GameTooltip:HookScript("OnShow", OnAny)
        GameTooltip:HookScript("OnTooltipSetUnit", OnUnit)
        hooked = true
    end
end
GT._byName, GT._Color, GT._SkinReq = byName, Color, SkinReq
