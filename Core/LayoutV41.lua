-- =====================================================================
-- LayoutV41.lua — TomoLayout precision placement & layout links
-- Original TomoMod implementation. No third-party layout code is used.
-- =====================================================================

TomoMod_LayoutV41 = TomoMod_LayoutV41 or {}
local P = TomoMod_LayoutV41

local Layout = TomoMod_Layout
local R = TomoMod_Registry

local WHITE = "Interface\\Buttons\\WHITE8X8"
local FONT  = "Interface\\AddOns\\TomoModForever\\Assets\\Fonts\\Tomo.ttf"

local ACCENT = TomoMod_Utils.BRAND
local BG     = { TomoMod_Utils.SURFACE_DEEP[1], TomoMod_Utils.SURFACE_DEEP[2], TomoMod_Utils.SURFACE_DEEP[3], 0.96 }
local PANEL  = { TomoMod_Utils.SURFACE[1], TomoMod_Utils.SURFACE[2], TomoMod_Utils.SURFACE[3], 0.96 }
local BORDER = { TomoMod_Utils.BRAND_DARK[1], TomoMod_Utils.BRAND_DARK[2], TomoMod_Utils.BRAND_DARK[3], 1.00 }
local DIM    = { 0.66, 0.62, 0.54 }

local selectedFrame
local selectedAnchorID
local selectedSurface   -- frame that owns the drag script (generic selection)
local editModeActive = false
local nudger
local anchorIndex
local applyingSnap = false
local applyingLink = false
local selectionHooks = setmetatable({}, { __mode = "k" })
local selectionOutline

local function Settings()
    if not TomoModForeverDB then return nil end
    TomoModForeverDB._layoutV41 = TomoModForeverDB._layoutV41 or {}
    local db = TomoModForeverDB._layoutV41
    if db.pixelPerfect == nil then db.pixelPerfect = false end
    db.nudgeStep = tonumber(db.nudgeStep) or 1
    if db.nudgeStep ~= 1 and db.nudgeStep ~= 5 and db.nudgeStep ~= 10 then db.nudgeStep = 1 end
    if db.playerTargetMirror == nil then db.playerTargetMirror = false end
    if db.gridSnap == nil then db.gridSnap = true end
    return db
end

local function BuildAnchorIndex()
    anchorIndex = {}
    if not R or not R.Anchors then return end
    for _, anchor in ipairs(R.Anchors()) do
        if anchor and anchor.id then anchorIndex[anchor.id] = anchor end
    end
end

local function Anchor(anchorID)
    if not anchorIndex then BuildAnchorIndex() end
    return anchorIndex and anchorIndex[anchorID]
end

local function Store(anchorID, root)
    root = root or TomoModForeverDB

    local a = Anchor(anchorID)
    if not a or not root or not R or not R.GetPath then return nil end
    return R.GetPath(root, a.path)
end

local function Round(v)
    if v >= 0 then return math.floor(v + 0.5) end
    return math.ceil(v - 0.5)
end

-- UIParent units occupied by one physical display pixel.
function P.PixelSize()
    if not Layout or not Layout.ScreenSize then return 1, 1 end
    local uiW, uiH = Layout.ScreenSize()
    if not uiW or not uiH then return 1, 1 end

    if GetPhysicalScreenSize then
        local pxW, pxH = GetPhysicalScreenSize()
        if pxW and pxH and pxW > 0 and pxH > 0 then
            return uiW / pxW, uiH / pxH
        end
    end

    local scale = UIParent and UIParent.GetEffectiveScale and UIParent:GetEffectiveScale() or 1
    if not scale or scale <= 0 then scale = 1 end
    local pixel = 1 / scale
    return pixel, pixel
end

function P.IsPixelPerfect()
    local db = Settings()
    return db and db.pixelPerfect == true or false
end

function P.SetPixelPerfect(enabled)
    local db = Settings()
    if not db then return end
    db.pixelPerfect = enabled and true or false

    if db.pixelPerfect and selectedFrame and selectedAnchorID and Layout and Layout.Save then
        local store = Store(selectedAnchorID)
        if store then
            Layout.Save(store, selectedFrame)
            P.OnAnchorSaved(selectedAnchorID, store, selectedFrame)
        end
    end
    P.RefreshUI()
end

function P.SnapStore(store)
    if type(store) ~= "table" then return false end
    if not P.IsPixelPerfect() then return false end

    local px, py = P.PixelSize()
    if not px or px <= 0 or not py or py <= 0 then return false end

    local oldX, oldY = tonumber(store.x) or 0, tonumber(store.y) or 0
    local newX = Round(oldX / px) * px
    local newY = Round(oldY / py) * py
    store.x, store.y = newX, newY
    return math.abs(newX - oldX) > 0.00001 or math.abs(newY - oldY) > 0.00001
end

-- Called by LayoutEngine.Save after it has captured a V4 position.
function P.OnLayoutSave(store, frame)
    if applyingSnap or not P.IsPixelPerfect() then return false end
    if not P.SnapStore(store) then return false end
    if not frame or not Layout or not Layout.Apply then return true end
    if InCombatLockdown and InCombatLockdown() and frame.IsProtected and frame:IsProtected() then return true end

    applyingSnap = true
    Layout.Apply(store, frame)
    applyingSnap = false
    return true
end

local function FrameRatio(frame)
    if not frame or not frame.GetEffectiveScale or not UIParent or not UIParent.GetEffectiveScale then return 1 end
    local fs, us = frame:GetEffectiveScale(), UIParent:GetEffectiveScale()
    if fs and us and fs > 0 and us > 0 then return fs / us end
    return 1
end

-- Center position expressed in UIParent units relative to screen center.
function P.CenterOffset(frame)
    if not frame or not frame.GetCenter or not Layout or not Layout.ScreenSize then return nil end
    local cx, cy = frame:GetCenter()
    local w, h = Layout.ScreenSize()
    if not cx or not cy or not w or not h then return nil end
    local ratio = FrameRatio(frame)
    return cx * ratio - w * 0.5, cy * ratio - h * 0.5
end

function P.PixelCoordinates(frame)
    local x, y = P.CenterOffset(frame)
    if not x then return nil end
    local px, py = P.PixelSize()
    return Round(x / px), Round(y / py)
end

local function FindFrame(anchorID)
    if anchorID == "unitFrames.player" then return _G.TomoMod_UF_player end
    if anchorID == "unitFrames.target" then return _G.TomoMod_UF_target end
    if anchorID == "unitFrames.targettarget" then return _G.TomoMod_UF_targettarget end
    if anchorID == "unitFrames.focus" then return _G.TomoMod_UF_focus end
    if anchorID == "unitFrames.pet" then return _G.TomoMod_UF_pet end
    if anchorID == "unitFrames.bossFrames" then return _G.TomoMod_Boss_1 end
    if anchorID == "castbars.player" then return _G.TomoMod_Castbar_player end
    if anchorID == "resourceBars" then return _G.TomoMod_ResourceBars_Container end
    if anchorID == "partyFrames" then return _G.TomoMod_PartyAnchor end
    if anchorID == "raidFrames" then return _G.TomoMod_RaidAnchor end
    if anchorID == "battleRez" then return _G.TomoMod_BattleRezCounter end
    if anchorID == "objectiveTracker" then return _G.TomoModObjectiveTrackerMover end
    if anchorID == "minimap" then return _G.Minimap end
    return nil
end
P.FindFrame = FindFrame

function P.ResolveAnchorID(frame)
    if not frame then return nil end
    if frame == _G.Minimap then return "minimap" end

    local name = frame.GetName and frame:GetName()
    if not name then return nil end

    local unit = name:match("^TomoMod_UF_([%a]+)$")
    if unit == "player" or unit == "target" or unit == "targettarget"
        or unit == "focus" or unit == "pet" then
        return "unitFrames." .. unit
    end
    if name == "TomoMod_Boss_1" then return "unitFrames.bossFrames" end

    if name == "TomoMod_Castbar_player" then return "castbars.player" end
    if name == "TomoMod_ResourceBars_Container" then return "resourceBars" end
    if name == "TomoMod_PartyAnchor" then return "partyFrames" end
    if name == "TomoMod_RaidAnchor" then return "raidFrames" end
    if name == "TomoMod_BattleRezCounter" then return "battleRez" end
    if name == "TomoModObjectiveTrackerMover" then return "objectiveTracker" end
    return nil
end

local function CanMove(frame)
    if not frame then return false end
    if InCombatLockdown and InCombatLockdown() and frame.IsProtected and frame:IsProtected() then
        return false
    end
    return true
end

local function ApplyAndNotify(anchorID, store, frame)
    if P.IsPixelPerfect() then P.SnapStore(store) end
    if Layout and Layout.Apply then Layout.Apply(store, frame) end
    P.OnAnchorSaved(anchorID, store, frame)
    P.RefreshUI()
end

-- ---------------------------------------------------------------------
-- Generic elements. Anything with a drag handle in move mode (chat, bags,
-- auras, frame anchors such as the loot frame, tooltip, XP bar, camp HUD,
-- spell bars...) can be selected even without a layout anchor. Such an
-- element saves its position its own way, so TomoLayout never writes its
-- storage: it moves the frame, then runs the element's own drag-stop
-- handler, exactly as if the player had dropped it there.
-- ---------------------------------------------------------------------
local function Persist(surface)
    if not surface or not surface.GetScript then return end
    local fn = surface:GetScript("OnDragStop") or surface:GetScript("OnMouseUp")
    if fn then pcall(fn, surface, "LeftButton") end
end

local function MoveFrameBy(frame, dx, dy)
    local l, b = frame:GetLeft(), frame:GetBottom()
    if not (l and b) then return false end
    local ratio = FrameRatio(frame)
    frame:ClearAllPoints()
    frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", (l * ratio + dx) / ratio, (b * ratio + dy) / ratio)
    return true
end

local function GenericMove(frame, dx, dy)
    if not CanMove(frame) or (dx == 0 and dy == 0) then return false end
    if not MoveFrameBy(frame, dx, dy) then return false end
    Persist(selectedSurface or frame)
    P.RefreshUI()
    return true
end

local function HasStore(anchorID)
    return anchorID ~= nil and Store(anchorID) ~= nil
end

function P.Nudge(anchorID, frame, dxPixels, dyPixels)
    if not HasStore(anchorID) then
        local px, py = P.PixelSize()
        return GenericMove(frame, (tonumber(dxPixels) or 0) * px, (tonumber(dyPixels) or 0) * py)
    end
    if not CanMove(frame) or not Layout or not Layout.Save then return false end
    local store = Store(anchorID)
    if not store then return false end

    Layout.Save(store, frame)
    local px, py = P.PixelSize()
    store.x = (tonumber(store.x) or 0) + (tonumber(dxPixels) or 0) * px
    store.y = (tonumber(store.y) or 0) + (tonumber(dyPixels) or 0) * py
    local w, h = Layout.ScreenSize()
    store.refW, store.refH = w, h
    ApplyAndNotify(anchorID, store, frame)
    return true
end

-- ---------------------------------------------------------------------
-- Grid magnet. After a drag, the nearest edge or centre of the frame is
-- pulled onto a grid line when it lands within SNAP_RANGE of one. The grid
-- is the one drawn by the move mode (lines every N units from the centre).
-- ---------------------------------------------------------------------
local SNAP_RANGE = 10

local function NearestLine(value, origin, spacing)
    local k = Round((value - origin) / spacing)
    return origin + k * spacing
end

-- Best correction on one axis: among the given edges, the one closest to a line.
local function AxisDelta(edges, origin, spacing)
    local best
    for _, v in ipairs(edges) do
        local d = NearestLine(v, origin, spacing) - v
        if not best or math.abs(d) < math.abs(best) then best = d end
    end
    if best and math.abs(best) <= SNAP_RANGE and math.abs(best) > 0.01 then return best end
    return 0
end

function P.IsGridSnap()
    local db = Settings()
    return db and db.gridSnap ~= false or false
end

function P.SetGridSnap(enabled)
    local db = Settings()
    if db then db.gridSnap = enabled and true or false end
    P.RefreshUI()
end

function P.SnapToGrid(anchorID, frame)
    if not P.IsGridSnap() or not CanMove(frame) then return false end
    local M = _G.TomoMod_Movers
    if not (M and M.GetGrid) then return false end
    local spacing, mode = M.GetGrid()
    if mode == "disabled" or not spacing or spacing <= 0 then return false end
    local store = HasStore(anchorID) and Store(anchorID) or nil
    local l, r, t, b = frame:GetLeft(), frame:GetRight(), frame:GetTop(), frame:GetBottom()
    if not (l and r and t and b) then return false end
    local ratio = FrameRatio(frame)
    l, r, t, b = l * ratio, r * ratio, t * ratio, b * ratio
    local w, h = UIParent:GetWidth(), UIParent:GetHeight()
    local cx, cy = math.floor(w / 2), math.floor(h / 2)
    -- Vertical lines sit at cx + k*spacing; horizontal ones at cy + k*spacing
    -- counted from the top, i.e. at (h - cy) + k*spacing counted from the bottom.
    local dx = AxisDelta({ l, (l + r) / 2, r }, cx, spacing)
    local dy = AxisDelta({ b, (b + t) / 2, t }, h - cy, spacing)
    if dx == 0 and dy == 0 then return false end
    if not store then return GenericMove(frame, dx, dy) end
    if not Layout or not Layout.Save then return false end
    Layout.Save(store, frame)
    store.x = (tonumber(store.x) or 0) + dx
    store.y = (tonumber(store.y) or 0) + dy
    local sw, sh = Layout.ScreenSize()
    store.refW, store.refH = sw, sh
    ApplyAndNotify(anchorID, store, frame)
    return true
end

-- A drag ends on mouse-up; the module saves its own position on that same
-- event, so the snap runs a moment later, on top of the saved position.
-- Only a real drag snaps: the selected frame must have moved between the
-- press and the release (a plain click or a nudge button never snaps).
-- Holding Shift while releasing places the frame freely.
local dragWatch
local function CenterKey(frame)
    local x, y = frame and frame:GetCenter()
    if not x then return nil end
    return math.floor(x * 10 + 0.5) .. ":" .. math.floor(y * 10 + 0.5)
end

-- Frames that belong to the move mode itself or to the settings window.
local function IsLayoutChrome(frame)
    local name = frame.GetName and frame:GetName()
    if not name then return false end
    return name:find("^TomoModLayout") ~= nil or name == "TomoModConfigFrame"
end

-- Only TomoMod elements are offered: a Blizzard window with its own drag
-- handle (character panel...) is never picked, so no Blizzard frame is moved.
local function IsTomoMod(f)
    local depth = 0
    while f and depth < 8 do
        if f == _G.Minimap or rawget(f, "_tmMoverLayerOwner") then return true end
        local name = f.GetName and f:GetName()
        if name and name:find("^TomoMod") then return true end
        f = f.GetParent and f:GetParent() or nil
        depth = depth + 1
    end
    return false
end

local function DragSurfaceOf(f)
    local depth = 0
    while f and f ~= UIParent and f ~= WorldFrame and depth < 6 do
        if IsLayoutChrome(f) then return nil end
        if f.GetScript and f:GetScript("OnDragStop") then
            local owner = rawget(f, "_tmMoverLayerOwner")
            local target = owner
            if not target then
                if f.IsMovable and f:IsMovable() then
                    target = f
                else
                    local parent = f.GetParent and f:GetParent()
                    if parent and parent ~= UIParent and parent.IsMovable and parent:IsMovable() then target = parent end
                end
            end
            if target and target ~= UIParent and (IsTomoMod(f) or IsTomoMod(target)) then return f, target end
        end
        f = f.GetParent and f:GetParent() or nil
        depth = depth + 1
    end
end

function P.PickUnderMouse()
    if not editModeActive then return false end
    local foci
    if GetMouseFoci then foci = GetMouseFoci()
    elseif GetMouseFocus then foci = { GetMouseFocus() } end
    for _, focus in ipairs(foci or {}) do
        local surface, target = DragSurfaceOf(focus)
        if surface then
            if target == selectedFrame then return true end
            return P.SelectFrame(target, surface)
        end
    end
    return false
end

local function EnsureDragWatch()
    if dragWatch then return end
    dragWatch = CreateFrame("Frame")
    dragWatch:RegisterEvent("GLOBAL_MOUSE_DOWN")
    dragWatch:RegisterEvent("GLOBAL_MOUSE_UP")
    dragWatch:SetScript("OnEvent", function(self, event, button)
        if not editModeActive or button ~= "LeftButton" then return end
        if event == "GLOBAL_MOUSE_DOWN" then
            self.armed = not (nudger and nudger:IsShown() and nudger:IsMouseOver())
            self.startKey, self.startFrame = nil, nil
            -- Pick whatever movable element is under the mouse, then read
            -- the selection next frame (movers also select on OnMouseDown).
            if self.armed then P.PickUnderMouse() end
            C_Timer.After(0, function()
                if selectedFrame then
                    self.startFrame = selectedFrame
                    self.startKey = CenterKey(selectedFrame)
                end
            end)
            return
        end
        if not self.armed then return end
        self.armed = false
        if IsShiftKeyDown() then return end
        C_Timer.After(0.05, function()
            local frame, anchorID = selectedFrame, selectedAnchorID
            if not frame or frame ~= self.startFrame then return end
            if CenterKey(frame) == self.startKey then return end
            P.SnapToGrid(anchorID, frame)
        end)
    end)
end

function P.CenterAxis(anchorID, frame, axis)
    if not HasStore(anchorID) then
        local x, y = P.CenterOffset(frame)
        if not x then return false end
        return GenericMove(frame, axis == "x" and -x or 0, axis == "y" and -y or 0)
    end
    if not CanMove(frame) or not Layout or not Layout.Save then return false end
    local store = Store(anchorID)
    if not store then return false end

    Layout.Save(store, frame)
    local x, y = P.CenterOffset(frame)
    if not x then return false end
    if axis == "x" then store.x = (tonumber(store.x) or 0) - x end
    if axis == "y" then store.y = (tonumber(store.y) or 0) - y end
    local w, h = Layout.ScreenSize()
    store.refW, store.refH = w, h
    ApplyAndNotify(anchorID, store, frame)
    return true
end

local function CopyTableInto(dst, src)
    for k in pairs(dst) do dst[k] = nil end
    for k, v in pairs(src) do
        if type(v) == "table" then
            local t = {}
            for kk, vv in pairs(v) do t[kk] = vv end
            dst[k] = t
        else
            dst[k] = v
        end
    end
end

function P.Reset(anchorID, frame)
    if not CanMove(frame) then return false end
    local store = Store(anchorID)
    local defaults = Store(anchorID, TomoMod_Defaults)
    if type(store) ~= "table" or type(defaults) ~= "table" then return false end
    CopyTableInto(store, defaults)
    if Layout and Layout.MigratePosition then Layout.MigratePosition(store) end
    ApplyAndNotify(anchorID, store, frame)
    return true
end

local function Mirror(sourceID, sourceFrame, targetID, targetFrame)
    if applyingLink or not CanMove(targetFrame) or not Layout or not Layout.Save then return false end
    local sx, sy = P.CenterOffset(sourceFrame)
    if not sx then return false end

    local targetStore = Store(targetID)
    if not targetStore then return false end

    applyingLink = true
    Layout.Save(targetStore, targetFrame)
    -- Layout.Save may itself snap the target by a fractional pixel. Read the
    -- centre after that pass so the mirror delta is computed from its final
    -- physical position, not from the pre-snap one.
    local tx, ty = P.CenterOffset(targetFrame)
    if not tx then applyingLink = false; return false end
    -- Horizontal mirror around the physical screen centre, same vertical coordinate.
    targetStore.x = (tonumber(targetStore.x) or 0) + ((-sx) - tx)
    targetStore.y = (tonumber(targetStore.y) or 0) + (sy - ty)
    local w, h = Layout.ScreenSize()
    targetStore.refW, targetStore.refH = w, h
    if P.IsPixelPerfect() then P.SnapStore(targetStore) end
    Layout.Apply(targetStore, targetFrame)
    applyingLink = false
    return true
end

function P.OnAnchorSaved(anchorID, store, frame)
    local db = Settings()
    if not db or not db.playerTargetMirror or applyingLink then return end

    if anchorID == "unitFrames.player" then
        Mirror(anchorID, frame or FindFrame(anchorID), "unitFrames.target", FindFrame("unitFrames.target"))
    elseif anchorID == "unitFrames.target" then
        Mirror(anchorID, frame or FindFrame(anchorID), "unitFrames.player", FindFrame("unitFrames.player"))
    end
end

function P.IsPlayerTargetMirror()
    local db = Settings()
    return db and db.playerTargetMirror == true or false
end

function P.SetPlayerTargetMirror(enabled)
    local db = Settings()
    if not db then return end
    db.playerTargetMirror = enabled and true or false
    if db.playerTargetMirror then
        local player = FindFrame("unitFrames.player")
        local target = FindFrame("unitFrames.target")
        if player and target then Mirror("unitFrames.player", player, "unitFrames.target", target) end
    end
    P.RefreshUI()
end

local function EnsureSelectionOutline()
    if selectionOutline then return selectionOutline end

    local f = CreateFrame("Frame", "TomoModLayoutSelectionOutline", UIParent)
    -- The selection shell is part of the edit surface too. LOW keeps it above
    -- TomoLayout movers while every Blizzard panel remains free to cover it.
    f:SetFrameStrata("LOW")
    f:SetFrameLevel(9000)
    f:EnableMouse(false)
    f:Hide()

    local function Line()
        local tex = f:CreateTexture(nil, "OVERLAY")
        tex:SetTexture(WHITE)
        tex:SetColorTexture(ACCENT[1], ACCENT[2], ACCENT[3], 1)
        return tex
    end

    f._top = Line()
    f._bottom = Line()
    f._left = Line()
    f._right = Line()

    -- A second, faint shell separates the selected mover from teal artwork
    -- that may already exist inside the module itself.
    local glow = f:CreateTexture(nil, "BACKGROUND")
    glow:SetAllPoints()
    glow:SetTexture(WHITE)
    glow:SetColorTexture(ACCENT[1], ACCENT[2], ACCENT[3], 0.055)
    f._fill = glow

    selectionOutline = f
    return f
end

local function RefreshSelectionOutline()
    local f = EnsureSelectionOutline()
    if not editModeActive or not selectedFrame
        or not selectedFrame.IsShown or not selectedFrame:IsShown() then
        f:Hide()
        return
    end

    local px, py = P.PixelSize()
    px = (px and px > 0) and px or 1
    py = (py and py > 0) and py or 1

    -- Two *physical* pixels regardless of UI scale, plus a two-pixel gap so
    -- the highlight never hides the mover's own border.
    local thickX, thickY = px * 2, py * 2
    local gapX, gapY = px * 2, py * 2

    f:ClearAllPoints()
    f:SetPoint("TOPLEFT", selectedFrame, "TOPLEFT", -gapX, gapY)
    f:SetPoint("BOTTOMRIGHT", selectedFrame, "BOTTOMRIGHT", gapX, -gapY)

    f._top:ClearAllPoints()
    f._top:SetPoint("TOPLEFT")
    f._top:SetPoint("TOPRIGHT")
    f._top:SetHeight(thickY)

    f._bottom:ClearAllPoints()
    f._bottom:SetPoint("BOTTOMLEFT")
    f._bottom:SetPoint("BOTTOMRIGHT")
    f._bottom:SetHeight(thickY)

    f._left:ClearAllPoints()
    f._left:SetPoint("TOPLEFT")
    f._left:SetPoint("BOTTOMLEFT")
    f._left:SetWidth(thickX)

    f._right:ClearAllPoints()
    f._right:SetPoint("TOPRIGHT")
    f._right:SetPoint("BOTTOMRIGHT")
    f._right:SetWidth(thickX)

    f:Show()
end

local function RefreshMoverFocus()
    local U = TomoMod_Utils
    if U and U.SetMoverFocusSelection then
        U.SetMoverFocusSelection(
            selectedFrame,
            editModeActive and selectedFrame ~= nil
        )
    end
end

function P.SelectFrame(frame, surface)
    if not editModeActive or not frame then return false end
    local anchorID = P.ResolveAnchorID(frame)
    if anchorID and not Store(anchorID) then anchorID = nil end
    -- Without a layout anchor the element needs a drag handle to persist.
    if not anchorID and not surface then return false end
    selectedFrame = frame
    selectedAnchorID = anchorID
    selectedSurface = surface
    RefreshMoverFocus()
    RefreshSelectionOutline()
    if nudger then nudger:Show() end
    P.RefreshUI()
    return true
end

function P.GetSelection()
    return selectedFrame, selectedAnchorID
end

local SELECTION_ANCHORS = {
    "unitFrames.player", "unitFrames.target", "unitFrames.targettarget",
    "unitFrames.focus", "unitFrames.pet", "unitFrames.bossFrames",
    "castbars.player", "resourceBars",
    "partyFrames", "raidFrames", "battleRez",
    "objectiveTracker", "minimap",
}

local function BindSelectionFrame(frame)
    if not frame then return end

    -- SetupDraggable owners expose a dedicated, non-secure mover overlay.
    -- Party and Raid predate dragFrame and publish the same surface as
    -- moverOverlay, so accept both names here.
    -- Selecting from that overlay avoids touching the underlying unit button.
    -- Store the actual hooked surface rather than a boolean: action-bar
    -- overlays can be created after TomoLayout entered edit mode.
    local drag = frame.dragFrame or frame.moverOverlay
    if drag and drag.HookScript then
        if selectionHooks[frame] == drag then return end
        drag:HookScript("OnMouseDown", function(_, button)
            if button == "LeftButton" and editModeActive then P.SelectFrame(frame) end
        end)
        selectionHooks[frame] = drag
        return
    end

    if selectionHooks[frame] then return end

    -- A few TomoMod movers (Minimap/Mythic tracker/etc.) own their drag
    -- scripts directly. Hook the existing drag start rather than replacing it.
    if frame.HookScript then
        local ok = pcall(frame.HookScript, frame, "OnDragStart", function()
            if editModeActive then P.SelectFrame(frame) end
        end)
        if ok then selectionHooks[frame] = frame end
    end
end

function P.BindSelectionFrames()
    for i = 1, #SELECTION_ANCHORS do
        BindSelectionFrame(FindFrame(SELECTION_ANCHORS[i]))
    end
end

local function SelectionRoute()
    if not selectedFrame then return nil end
    if selectedFrame == _G.Minimap then return "general" end

    local movers = TomoMod_Movers
    if not movers or not movers.RouteForName then return nil end

    local frame, depth = selectedFrame, 0
    while frame and depth < 12 do
        local name = frame.GetName and frame:GetName()
        if name then
            local route = movers.RouteForName(name)
            if route then return route end
        end
        frame = frame.GetParent and frame:GetParent() or nil
        depth = depth + 1
    end
end

-- The Studios are gone: every layout anchor opens its page in the /tm
-- window, which stays open beside the frames while they are edited.
local PAGE_BY_ANCHOR = {
    ["unitFrames.player"]       = "uf_player",
    ["unitFrames.target"]       = "uf_target",
    ["unitFrames.targettarget"] = "uf_targettarget",
    ["unitFrames.focus"]        = "uf_focus",
    ["unitFrames.pet"]          = "uf_pet",
    ["unitFrames.bossFrames"]   = "uf_boss",
    ["unitFrames.target.auras"] = "uf_target",
    ["unitFrames.focus.auras"]  = "uf_focus",
    ["resourceBars"]            = "resources",
    ["castbars.player"]         = "castbar",
    ["castbars.target"]         = "castbar",
    ["castbars.focus"]          = "castbar",
    ["castbars.pet"]            = "castbar",
    ["castbars.boss"]           = "castbar",
    ["partyFrames"]             = "party",
    ["raidFrames"]              = "raid",
    ["battleRez"]               = "raid",
}

local function OpenPage(page)
    local cfg = TomoMod_Config
    if not (cfg and cfg.OpenCategory) then return false end
    cfg.OpenCategory(page)
    return true
end

local function HasSelectionConfiguration()
    return PAGE_BY_ANCHOR[selectedAnchorID] ~= nil or SelectionRoute() ~= nil
end

function P.ConfigureSelection()
    local page = PAGE_BY_ANCHOR[selectedAnchorID]
    if page then return OpenPage(page) end

    local movers = TomoMod_Movers
    local route = SelectionRoute()
    if route and movers and movers.OpenConfigRoute then
        movers.OpenConfigRoute(route)
        return true
    end
    return false
end

local function MakeButton(parent, w, h, text, callback)
    local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
    b:SetSize(w, h)
    b:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 })
    b:SetBackdropColor(PANEL[1], PANEL[2], PANEL[3], PANEL[4])
    b:SetBackdropBorderColor(BORDER[1], BORDER[2], BORDER[3], BORDER[4])
    local fs = b:CreateFontString(nil, "OVERLAY")
    fs:SetFont(FONT, 11, "OUTLINE")
    fs:SetPoint("CENTER")
    fs:SetText(text)
    fs:SetTextColor(0.88, 0.91, 0.93)
    b._text = fs
    b:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(ACCENT[1], ACCENT[2], ACCENT[3], 0.95)
    end)
    b:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(BORDER[1], BORDER[2], BORDER[3], BORDER[4])
    end)
    b:SetScript("OnClick", callback)
    return b
end

local function SetToggleVisual(button, enabled, onText, offText)
    if not button then return end
    button._text:SetText(enabled and onText or offText)
    if enabled then
        button:SetBackdropColor(ACCENT[1] * 0.16, ACCENT[2] * 0.16, ACCENT[3] * 0.16, 0.96)
        button:SetBackdropBorderColor(ACCENT[1], ACCENT[2], ACCENT[3], 0.85)
        button._text:SetTextColor(ACCENT[1], ACCENT[2], ACCENT[3])
    else
        button:SetBackdropColor(PANEL[1], PANEL[2], PANEL[3], PANEL[4])
        button:SetBackdropBorderColor(BORDER[1], BORDER[2], BORDER[3], BORDER[4])
        button._text:SetTextColor(0.70, 0.73, 0.76)
    end
end

local function EnsureNudger(headerBar)
    if nudger then
        if headerBar and nudger._header ~= headerBar then
            nudger:ClearAllPoints()
            nudger:SetPoint("TOP", headerBar, "BOTTOM", 0, -6)
            nudger._header = headerBar
        end
        return nudger
    end

    local f = CreateFrame("Frame", "TomoModLayoutNudger", UIParent, "BackdropTemplate")
    nudger = f
    f:SetSize(390, 246)
    f:SetFrameStrata("DIALOG")
    f:SetFrameLevel(610)
    f:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 })
    f:SetBackdropColor(BG[1], BG[2], BG[3], BG[4])
    f:SetBackdropBorderColor(BORDER[1], BORDER[2], BORDER[3], BORDER[4])
    f:EnableMouse(true)
    f:SetClampedToScreen(true)
    if headerBar then
        f:SetPoint("TOP", headerBar, "BOTTOM", 0, -6)
        f._header = headerBar
    else
        f:SetPoint("TOP", UIParent, "TOP", 0, -74)
    end

    local accent = f:CreateTexture(nil, "OVERLAY")
    accent:SetHeight(2)
    accent:SetPoint("TOPLEFT")
    accent:SetPoint("TOPRIGHT")
    accent:SetColorTexture(ACCENT[1], ACCENT[2], ACCENT[3], 1)

    local title = f:CreateFontString(nil, "OVERLAY")
    title:SetFont(FONT, 12, "OUTLINE")
    title:SetPoint("TOPLEFT", 12, -12)
    title:SetText("TOMOLAYOUT")
    title:SetTextColor(ACCENT[1], ACCENT[2], ACCENT[3])

    local selected = f:CreateFontString(nil, "OVERLAY")
    selected:SetFont(FONT, 11, "OUTLINE")
    selected:SetPoint("TOPLEFT", 12, -34)
    selected:SetWidth(220)
    selected:SetJustifyH("LEFT")
    f._selected = selected

    local configure = MakeButton(f, 132, 26,
        (TomoMod_L and TomoMod_L["layout_configure"]) or "Configurer",
        function() P.ConfigureSelection() end)
    configure:SetPoint("TOPRIGHT", -12, -28)
    f._config = configure

    local coords = f:CreateFontString(nil, "OVERLAY")
    coords:SetFont(FONT, 10, "OUTLINE")
    coords:SetPoint("TOPLEFT", 12, -54)
    coords:SetTextColor(DIM[1], DIM[2], DIM[3])
    f._coords = coords

    local up = MakeButton(f, 36, 28, "^", function()
        local db = Settings(); if selectedFrame then P.Nudge(selectedAnchorID, selectedFrame, 0, db.nudgeStep) end
    end)
    up:SetPoint("TOPLEFT", 58, -80)
    local left = MakeButton(f, 36, 28, "<", function()
        local db = Settings(); if selectedFrame then P.Nudge(selectedAnchorID, selectedFrame, -db.nudgeStep, 0) end
    end)
    left:SetPoint("TOPLEFT", 18, -112)
    local down = MakeButton(f, 36, 28, "v", function()
        local db = Settings(); if selectedFrame then P.Nudge(selectedAnchorID, selectedFrame, 0, -db.nudgeStep) end
    end)
    down:SetPoint("TOPLEFT", 58, -112)
    local right = MakeButton(f, 36, 28, ">", function()
        local db = Settings(); if selectedFrame then P.Nudge(selectedAnchorID, selectedFrame, db.nudgeStep, 0) end
    end)
    right:SetPoint("TOPLEFT", 98, -112)

    local step = MakeButton(f, 86, 28, "Pas : 1 px", function(self)
        local db = Settings()
        db.nudgeStep = db.nudgeStep == 1 and 5 or (db.nudgeStep == 5 and 10 or 1)
        P.RefreshUI()
    end)
    step:SetPoint("TOPLEFT", 18, -148)
    f._step = step

    local pp = MakeButton(f, 110, 28, "Pixel : OFF", function()
        P.SetPixelPerfect(not P.IsPixelPerfect())
    end)
    pp:SetPoint("TOPLEFT", 112, -148)
    f._pixel = pp

    local snap = MakeButton(f, 110, 28, "Aimant : ON", function()
        P.SetGridSnap(not P.IsGridSnap())
    end)
    snap:SetPoint("TOPLEFT", 18, -180)
    f._snap = snap

    local mirror = MakeButton(f, 148, 28, "Player <-> Target", function()
        P.SetPlayerTargetMirror(not P.IsPlayerTargetMirror())
    end)
    mirror:SetPoint("TOPLEFT", 230, -148)
    f._mirror = mirror

    local centerX = MakeButton(f, 78, 28, "Centrer X", function()
        if selectedFrame then P.CenterAxis(selectedAnchorID, selectedFrame, "x") end
    end)
    centerX:SetPoint("TOPLEFT", 154, -80)
    local centerY = MakeButton(f, 78, 28, "Centrer Y", function()
        if selectedFrame then P.CenterAxis(selectedAnchorID, selectedFrame, "y") end
    end)
    centerY:SetPoint("LEFT", centerX, "RIGHT", 6, 0)
    local reset
    reset = MakeButton(f, 62, 28, "Reset", function()
        if selectedFrame then P.Reset(selectedAnchorID, selectedFrame) end
    end)
    reset:SetPoint("LEFT", centerY, "RIGHT", 6, 0)
    f._reset = reset

    local hint = f:CreateFontString(nil, "OVERLAY")
    hint:SetFont(FONT, 9, "")
    hint:SetPoint("BOTTOMLEFT", 12, 10)
    hint:SetPoint("BOTTOMRIGHT", -12, 10)
    hint:SetJustifyH("LEFT")
    hint:SetTextColor(0.42, 0.45, 0.48)
    hint:SetText((TomoMod_L and TomoMod_L["layout_nudger_hint"]) or "Cliquez ou déplacez un élément pour ouvrir TomoLayout. Maj : placer sans aimant.")

    f:SetScript("OnUpdate", function(self, elapsed)
        self._elapsed = (self._elapsed or 0) + elapsed
        if self._elapsed < 0.10 then return end
        self._elapsed = 0
        P.RefreshUI()
    end)
    f:Hide()
    return f
end

-- Name shown in the panel: the anchor label, else the mover's own caption,
-- else a cleaned-up frame name.
local function SelectionLabel(anchorID, frame, surface)
    if anchorID then
        return Layout and Layout.Label and Layout.Label(anchorID, anchorID) or anchorID
    end
    for _, f in ipairs({ surface, frame }) do
        if f and f.GetRegions then
            for _, r in ipairs({ f:GetRegions() }) do
                if r.GetObjectType and r:GetObjectType() == "FontString" and r:IsShown() then
                    local t = r:GetText()
                    if type(t) == "string" and t ~= "" and #t < 48 then return t end
                end
            end
        end
    end
    local name = frame and frame.GetName and frame:GetName() or "?"
    name = name:gsub("^TomoModAnchor_", ""):gsub("^TomoMod_?", ""):gsub("_", " ")
    return name
end

function P.RefreshUI()
    if not nudger then return end
    local db = Settings()
    if not db then return end

    if selectedFrame then
        RefreshSelectionOutline()
        nudger._selected:SetText(SelectionLabel(selectedAnchorID, selectedFrame, selectedSurface))
        nudger._selected:SetTextColor(0.949, 0.922, 0.859)
        local x, y = P.PixelCoordinates(selectedFrame)
        if x and y then
            nudger._coords:SetText(string.format("X %+d px    Y %+d px", x, y))
        else
            nudger._coords:SetText("X -    Y -")
        end
        if nudger._config then
            if HasSelectionConfiguration() then nudger._config:Show() else nudger._config:Hide() end
        end
        -- Reset needs a stored default: only layout anchors have one.
        if nudger._reset then nudger._reset:SetAlpha(HasStore(selectedAnchorID) and 1 or 0.35) end
    else
        if selectionOutline then selectionOutline:Hide() end
        if nudger._config then nudger._config:Hide() end
        if editModeActive then nudger:Hide() end
        return
    end

    nudger._step._text:SetText(string.format("Pas : %d px", db.nudgeStep))
    SetToggleVisual(nudger._pixel, db.pixelPerfect, "Pixel : ON", "Pixel : OFF")
    SetToggleVisual(nudger._mirror, db.playerTargetMirror, "Player <-> Target : ON", "Player <-> Target")
    if nudger._snap then
        local LL = TomoMod_L or {}
        SetToggleVisual(nudger._snap, db.gridSnap ~= false,
            LL["layout_snap_on"] or "Aimant : ON", LL["layout_snap_off"] or "Aimant : OFF")
    end
end

function P.SetEditMode(enabled, headerBar)
    editModeActive = enabled and true or false
    local f = EnsureNudger(headerBar)
    selectedFrame, selectedAnchorID, selectedSurface = nil, nil, nil
    RefreshMoverFocus()
    if TomoMod_Utils and TomoMod_Utils.SetMoverLayerMode then
        TomoMod_Utils.SetMoverLayerMode(editModeActive)
    end
    if selectionOutline then selectionOutline:Hide() end
    if editModeActive then
        EnsureDragWatch()
        P.BindSelectionFrames()
        -- v1.2: TomoLayout only appears after the player selects a mover.
        f:Hide()
    else
        f:Hide()
    end
end

function P.IsEditModeActive()
    return editModeActive
end

_G.TomoMod_LayoutV41 = P
