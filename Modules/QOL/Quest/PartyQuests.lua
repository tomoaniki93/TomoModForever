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
-- 1.5 seconds, and never in combat (sent right after it). Messages stay
-- under 255 bytes. Nothing reads the combat log.
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
local lastHello = 0

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

-- [1.3.7] Counters for /tmf groupe (in-game check of the exchange).
local stats = {
    sent = 0, failed = 0, lastResult = nil, lastChannel = nil, recv = {}, hello = 0,
    -- [1.3.8] Raw view of CHAT_MSG_ADDON for our prefix, before any check.
    raw = 0, self = 0, secret = 0, byChannel = {}, register = "?", whisperSent = 0,
}

-- [1.3.8] Members reached by whisper as well (their party messages never
-- arrived, or they answered by whisper): shortName -> name to whisper.
local whisper = {}

local function Accepted(ok, res)
    if not ok then return false end
    if res == nil or res == true or res == 0 then return true end
    local E = Enum and Enum.SendAddonMessageResult
    return E ~= nil and res == E.Success
end

-- The group's channel first; if the client refuses it (a group made by
-- the group finder is an "instance" group even outdoors, or the reverse),
-- the other one.
local function Send(msg)
    if not (C_ChatInfo and C_ChatInfo.SendAddonMessage) then return end
    local first = Channel()
    local ok, res = pcall(C_ChatInfo.SendAddonMessage, PREFIX, msg, first)
    local used = first
    if not Accepted(ok, res) then
        local other = first == "PARTY" and "INSTANCE_CHAT" or "PARTY"
        ok, res = pcall(C_ChatInfo.SendAddonMessage, PREFIX, msg, other)
        used = other
    end
    stats.lastResult, stats.lastChannel = ok and tostring(res) or ("error: " .. tostring(res)), used
    if Accepted(ok, res) then stats.sent = stats.sent + 1 else stats.failed = stats.failed + 1 end
    -- [1.3.8] Same message straight to the members on whisper.
    for _, target in pairs(whisper) do
        local okW, resW = pcall(C_ChatInfo.SendAddonMessage, PREFIX, msg, "WHISPER", target)
        if Accepted(okW, resW) then stats.whisperSent = stats.whisperSent + 1 end
    end
end

-- [1.3.8] Name to whisper a party unit (with realm when it differs).
local function WhisperName(unit)
    local name, realm = UnitName(unit)
    if not name or Secret(name) then return nil end
    if realm and realm ~= "" and not Secret(realm) then return name .. "-" .. realm end
    return name
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

-- Nothing is sent in combat: kill counts move there, they go out together
-- right after it (PLAYER_REGEN_ENABLED).
local afterCombat = false
local function Schedule(full)
    if full then fullPending = true end
    if InCombatLockdown() then afterCombat = true return end
    if pending then return end
    pending = true
    C_Timer.After(full and (0.5 + math.random() * 1.0) or DEBOUNCE, function()
        pending = false
        if InCombatLockdown() then afterCombat = true return end
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

local function OnMessage(msg, sender, channel)
    local who = Short(sender)
    if who and channel == "WHISPER" and not whisper[who] and not Secret(sender) then
        whisper[who] = sender
    end
    if not who or who == UnitName("player") then return end
    if type(msg) ~= "string" or Secret(msg) then return end
    stats.recv[who] = (stats.recv[who] or 0) + 1
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
                -- Still loading: "Unknown" must not wipe what we know.
                if n == UNKNOWNOBJECT or n == UNKNOWN then return false, false end
                if n then
                    now[n] = true
                    if not members[n] then new = true end
                end
            end
        end
    end
    for n in pairs(data) do if not now[n] then data[n] = nil end end
    for n in pairs(whisper) do if not now[n] then whisper[n] = nil end end
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

--- [1.3.7] The tooltip found a member on the quest with nothing from them:
--- ask the group again (at most every 15 s, never in combat).
function PQ.Ask()
    if not (Enabled() and InParty()) or InCombatLockdown() then return end
    if GetTime() - lastHello < 15 then return end
    lastHello = GetTime()
    stats.hello = stats.hello + 1
    Send("1H")
    C_Timer.After(5, function() PQ.WhisperSilent() end)
end

--- [1.3.8] Members silent so far get our messages by whisper as well, and
--- a hello and our full list right away.
function PQ.WhisperSilent()
    if not (Enabled() and InParty()) or InCombatLockdown() then return end
    local added = false
    for i = 1, 4 do
        local unit = "party" .. i
        if UnitExists(unit) and (not UnitIsConnected or UnitIsConnected(unit)) then
            local n = Short(UnitName(unit))
            if n and not stats.recv[n] and not whisper[n] then
                local target = WhisperName(unit)
                if target then whisper[n] = target; added = true end
            end
        end
    end
    if added then
        Send("1H")
        Schedule(true)
    end
end

--- /tmf groupe: what was sent and received, to check the exchange in game.
function PQ.Report()
    local out = {}
    local function add(t) out[#out + 1] = t end
    local L = TomoMod_L
    local function T(key, fallback)
        local v = L and L[key]
        if v == nil or v == key or v == "" then return fallback end
        return v
    end
    local yes, no = T("pq_rep_yes", "yes"), T("pq_rep_no", "no")
    add(string.format(T("pq_rep_head", "|cffd4a64aTMF group|r  sharing %s, in a group %s, channel %s"),
        Enabled() and yes or no, InParty() and yes or no, Channel()))
    add(string.format(T("pq_rep_sent", "  sent %d, refused %d, last result %s (%s)"),
        stats.sent, stats.failed, tostring(stats.lastResult), tostring(stats.lastChannel)))
    -- [1.3.8] Whisper relay and raw CHAT_MSG_ADDON view.
    add(string.format(T("pq_rep_whisper", "  sent by whisper %d"), stats.whisperSent))
    local chans = {}
    for c, n in pairs(stats.byChannel) do chans[#chans + 1] = c .. " " .. n end
    add(string.format(T("pq_rep_prefix", "  prefix %s: %s"), PREFIX, tostring(stats.register)))
    add(string.format(T("pq_rep_raw", "  events received %d (own %d, secret %d)"),
        stats.raw, stats.self, stats.secret)
        .. (#chans > 0 and (": " .. table.concat(chans, ", ")) or ""))
    local mine = 0
    for _ in pairs(lastSent) do mine = mine + 1 end
    add(string.format(T("pq_rep_mine", "  my quests announced: %d"), mine))
    for i = 1, 4 do
        local unit = "party" .. i
        if UnitExists(unit) then
            local n = Short(UnitName(unit)) or "?"
            local q = 0
            if data[n] then for _ in pairs(data[n]) do q = q + 1 end end
            add(string.format(T("pq_rep_member", "  %s: messages received %d, quests known %d"),
                n, stats.recv[n] or 0, q)
                .. (whisper[n] and T("pq_rep_onwhisper", ", by whisper") or ""))
        end
    end
    for _, line in ipairs(out) do print(line) end
end

--- True once `unit` sent anything (it runs TMF with sharing on).
function PQ.Knows(unit)
    local n = Short(UnitName(unit))
    return n ~= nil and data[n] ~= nil
end

function PQ.ApplySettings()
    if Enabled() and InParty() then Schedule(true) end
end

local function Register()
    if not (C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix) then stats.register = "no API" return end
    local ok, res = pcall(C_ChatInfo.RegisterAddonMessagePrefix, PREFIX)
    stats.register = ok and tostring(res) or ("error: " .. tostring(res))
    if C_ChatInfo.IsAddonMessagePrefixRegistered then
        local okR, isReg = pcall(C_ChatInfo.IsAddonMessagePrefixRegistered, PREFIX)
        stats.register = stats.register .. (okR and (", registered " .. tostring(isReg)) or "")
    end
end

local ev = CreateFrame("Frame")
ev:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
    if event == "CHAT_MSG_ADDON" or event == "CHAT_MSG_ADDON_LOGGED" then
        if a1 ~= PREFIX then return end
        stats.raw = stats.raw + 1
        if Secret(a2) or Secret(a4) then stats.secret = stats.secret + 1 end
        local chan = (not Secret(a3)) and tostring(a3) or "?"
        stats.byChannel[chan] = (stats.byChannel[chan] or 0) + 1
        if not Secret(a4) and Short(a4) == UnitName("player") then stats.self = stats.self + 1 end
        OnMessage(a2, a4, a3)
    elseif event == "PLAYER_REGEN_ENABLED" then
        if afterCombat then
            afterCombat = false
            if Enabled() and InParty() then Schedule(false) end
        end
    elseif event == "GROUP_ROSTER_UPDATE" then
        OnRoster()
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- [1.3.8] Prefix lost or refused at load: register it again.
        if C_ChatInfo and C_ChatInfo.IsAddonMessagePrefixRegistered then
            local ok, isReg = pcall(C_ChatInfo.IsAddonMessagePrefixRegistered, PREFIX)
            if ok and not isReg then Register() end
        end
        OnRoster()
        -- [1.3.7] Messages sent during a loading screen or right at login
        -- can be lost: once settled, ask everyone and send our list again.
        C_Timer.After(5, function()
            if not (Enabled() and InParty()) then return end
            if InCombatLockdown() then afterCombat = true; fullPending = true return end
            lastHello = GetTime()
            Send("1H")
            Schedule(true)
            -- [1.3.8] Ten seconds later, members we heard nothing from are
            -- reached by whisper too (party addon messages that never arrive).
            C_Timer.After(10, function() PQ.WhisperSilent() end)
        end)
    elseif event == "QUEST_LOG_UPDATE" or event == "QUEST_REMOVED" or event == "QUEST_ACCEPTED" then
        if Enabled() and InParty() then Schedule(false) end
    end
end)

function PQ.Initialize()
    Register()
    ev:RegisterEvent("CHAT_MSG_ADDON")
    pcall(ev.RegisterEvent, ev, "CHAT_MSG_ADDON_LOGGED")
    ev:RegisterEvent("GROUP_ROSTER_UPDATE")
    ev:RegisterEvent("PLAYER_ENTERING_WORLD")
    ev:RegisterEvent("QUEST_LOG_UPDATE")
    ev:RegisterEvent("QUEST_REMOVED")
    ev:RegisterEvent("QUEST_ACCEPTED")
    ev:RegisterEvent("PLAYER_REGEN_ENABLED")
    OnRoster()
end
