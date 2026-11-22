-- =====================================================================
-- Modules/QOL/Quest/PartyQuests.lua -- quest progress shared in a group (1.3.7)
--
-- Group members who run TMF tell each other where they stand on their
-- quests, so the quest tracker tooltip can show, for each member, not only
-- whether they have the quest but how far along they are ("Wolf: 3/8") or
-- that it is ready to turn in.
--
-- Addon messages on the party channel (instance channel in an instance
-- group), party only, never in a raid. Prefix "TMFQ", protocol 1:
--   1H              hello: please send me your quests
--   1B              start of a full list: forget what you had from me
--   1Q|id:s|id:s    quests; s = c (ready), f (failed) or h/n.h/n per objective
--   1X|id|id        quests no longer in my log
-- A full list goes out when we join a group, when someone new joins, and in
-- answer to a hello; afterwards only the quests that changed, at most every
-- 1.5 seconds. Messages stay under 255 bytes.
-- =====================================================================

TomoMod_PartyQuests = TomoMod_PartyQuests or {}
local PQ = TomoMod_PartyQuests

local PREFIX = "TMFQ"
local MAX_LEN = 240
local DEBOUNCE = 1.5

local data = {}          -- shortName -> { [questID] = { state = "c"|"f"|nil, objs = { {h, n}, ... } } }
local lastSent = {}      -- questID -> encoded state we last announced
local members = {}       -- shortName -> true (current party)
local pending, fullPending = false, false

local function Enabled()
    local db = TomoModForeverDB and TomoModForeverDB.objectiveTracker
    return not (db and db.shareProgress == false)
end

local function Secret(v)
    return type(issecretvalue) == "function" and issecretvalue(v) or false
end

local function Short(name)
    if not name or Secret(name) then return nil end
    if Ambiguate then return Ambiguate(name, "short") end
    return (name:gsub("%-.*$", ""))
end

local function InParty()
    if not (IsInGroup and IsInGroup()) then return false end
    if IsInRaid and IsInRaid() then return false end
    return true
end

local function Channel()
    local instance = LE_PARTY_CATEGORY_INSTANCE and IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
    local home = LE_PARTY_CATEGORY_HOME and IsInGroup(LE_PARTY_CATEGORY_HOME)
    if instance and not home then return "INSTANCE_CHAT" end
    return "PARTY"
end

local function Send(msg)
    if not (C_ChatInfo and C_ChatInfo.SendAddonMessage) then return end
    pcall(C_ChatInfo.SendAddonMessage, PREFIX, msg, Channel())
end

-- ---------------------------------------------------------------------
-- Our own log, encoded
-- ---------------------------------------------------------------------
local function Encode(q)
    if q.failed then return "f" end
    if q.complete then return "c" end
    local parts = {}
    for _, o in ipairs(q.objectives or {}) do
        local h, n = o.have, o.need
        if not (type(n) == "number" and n > 0) then h, n = o.done and 1 or 0, 1 end
        parts[#parts + 1] = math.min(h or 0, n) .. "/" .. n
    end
    return table.concat(parts, ".")
end

local function OwnLog()
    local OT = TomoMod_ObjectiveTracker
    if not (OT and OT.GatherLog) then return {} end
    local ok, quests = pcall(OT.GatherLog)
    if not ok or type(quests) ~= "table" then return {} end
    local out = {}
    for _, q in ipairs(quests) do
        if q.id then out[q.id] = Encode(q) end
    end
    return out
end

-- Sends `head` then the entries, packed into messages of MAX_LEN bytes.
local function SendList(head, entries)
    local msg = head
    for _, e in ipairs(entries) do
        if #msg + #e + 1 > MAX_LEN then
            Send(msg)
            msg = head
        end
        msg = msg .. "|" .. e
    end
    if msg ~= head then Send(msg) end
end

local function SendFull()
    if not (Enabled() and InParty()) then return end
    local log = OwnLog()
    local entries = {}
    for id, s in pairs(log) do entries[#entries + 1] = id .. ":" .. s end
    Send("1B")
    SendList("1Q", entries)
    lastSent = log
end

local function SendDelta()
    if not (Enabled() and InParty()) then return end
    local log = OwnLog()
    local changed, gone = {}, {}
    for id, s in pairs(log) do
        if lastSent[id] ~= s then changed[#changed + 1] = id .. ":" .. s end
    end
    for id in pairs(lastSent) do
        if log[id] == nil then gone[#gone + 1] = tostring(id) end
    end
    SendList("1Q", changed)
    SendList("1X", gone)
    lastSent = log
end

local function Schedule(full)
    if full then fullPending = true end
    if pending then return end
    pending = true
    C_Timer.After(full and (0.5 + math.random() * 1.0) or DEBOUNCE, function()
        pending = false
        if fullPending then
            fullPending = false
            SendFull()
        else
            SendDelta()
        end
    end)
end

-- ---------------------------------------------------------------------
-- Receiving
-- ---------------------------------------------------------------------
local function Parse(s)
    if s == "c" or s == "f" then return { state = s } end
    local objs = {}
    for h, n in s:gmatch("(%d+)/(%d+)") do objs[#objs + 1] = { tonumber(h), tonumber(n) } end
    return { objs = objs }
end

local function OnMessage(msg, sender)
    local who = Short(sender)
    if not who or who == UnitName("player") then return end
    if type(msg) ~= "string" or Secret(msg) then return end
    local kind = msg:sub(1, 2)
    if kind == "1H" then
        Schedule(true)
        return
    end
    local t = data[who]
    if kind == "1B" then
        data[who] = {}
        return
    end
    if not t then t = {}; data[who] = t end
    if kind == "1Q" then
        for id, s in msg:gmatch("|(%d+):([^|]+)") do t[tonumber(id)] = Parse(s) end
    elseif kind == "1X" then
        for id in msg:gmatch("|(%d+)") do t[tonumber(id)] = nil end
    end
end

-- ---------------------------------------------------------------------
-- Group changes
-- ---------------------------------------------------------------------
local function ReadMembers()
    local now, new = {}, false
    if InParty() then
        for i = 1, 4 do
            local unit = "party" .. i
            if UnitExists(unit) then
                local n = Short(UnitName(unit))
                if n then
                    now[n] = true
                    if not members[n] then new = true end
                end
            end
        end
    end
    for n in pairs(data) do if not now[n] then data[n] = nil end end
    local wasAlone = next(members) == nil
    members = now
    return new, wasAlone and next(now) ~= nil
end

local function OnRoster()
    local someoneNew, joined = ReadMembers()
    if not (Enabled() and InParty()) then
        lastSent = {}
        return
    end
    if joined then Send("1H") end
    if someoneNew or joined then Schedule(true) end
end

-- ---------------------------------------------------------------------
-- Public
-- ---------------------------------------------------------------------
--- What `unit`'s TMF last told about `questID`: nil when it never did
--- (no TMF, or not on the quest), else { state = "c"|"f"|nil, objs = {{have, need}, ...} }.
function PQ.Get(unit, questID)
    local n = Short(UnitName(unit))
    local t = n and data[n]
    return t and t[questID] or nil
end

--- True once `unit` sent anything (it runs TMF with sharing on).
function PQ.Knows(unit)
    local n = Short(UnitName(unit))
    return n ~= nil and data[n] ~= nil
end

function PQ.ApplySettings()
    if Enabled() and InParty() then Schedule(true) end
end

local ev = CreateFrame("Frame")
ev:SetScript("OnEvent", function(_, event, a1, a2, _, a4)
    if event == "CHAT_MSG_ADDON" then
        if a1 == PREFIX then OnMessage(a2, a4) end
    elseif event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
        OnRoster()
    elseif event == "QUEST_LOG_UPDATE" or event == "QUEST_REMOVED" or event == "QUEST_ACCEPTED" then
        if Enabled() and InParty() then Schedule(false) end
    end
end)

function PQ.Initialize()
    if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
        pcall(C_ChatInfo.RegisterAddonMessagePrefix, PREFIX)
    end
    ev:RegisterEvent("CHAT_MSG_ADDON")
    ev:RegisterEvent("GROUP_ROSTER_UPDATE")
    ev:RegisterEvent("PLAYER_ENTERING_WORLD")
    ev:RegisterEvent("QUEST_LOG_UPDATE")
    ev:RegisterEvent("QUEST_REMOVED")
    ev:RegisterEvent("QUEST_ACCEPTED")
    OnRoster()
end
