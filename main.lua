--////////////////////////////////////////////////////
-- SERVICES
--////////////////////////////////////////////////////
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

--////////////////////////////////////////////////////
-- SETTINGS
--////////////////////////////////////////////////////
local Settings = {
    ESP = {
        Enabled       = true,
        ShowHealth    = true,
        ShowDistance  = true,
        ShowBox       = true,
        ShowHighlight = true,
    },
    Aimbot = {
        Enabled        = false,
        Radius         = 150,
        ShowCircle     = true,
        SmoothEnabled  = false,
        SmoothAmount   = 10,
        PredictEnabled = false,
        PredictAmount  = 5,
        Priority       = 1,
    },
    Graphics = {
        PotatoEnabled   = false,
        RemoveFog       = false,
        FovEnabled      = false,
        Fov             = 70,
        NoAnimation     = false,
    },
    Movement = {
        SpeedEnabled = false,
        Speed        = 400,
        FlyEnabled   = false,
        FlySpeed     = 480,
        InfiniteJump = false,
        NoClip       = false,
    }
}

--////////////////////////////////////////////////////
-- COULEURS
--////////////////////////////////////////////////////
local C = {
    BG      = Color3.fromRGB(14, 14, 18),
    SIDEBAR = Color3.fromRGB(20, 20, 26),
    CARD    = Color3.fromRGB(26, 26, 34),
    BORDER  = Color3.fromRGB(45, 45, 58),
    ACCENT  = Color3.fromRGB(99, 102, 241),
    ON      = Color3.fromRGB(34, 197, 94),
    OFF     = Color3.fromRGB(55,  55, 70),
    TEXT    = Color3.fromRGB(235, 235, 245),
    SUB     = Color3.fromRGB(140, 140, 160),
    WHITE   = Color3.new(1,1,1),
    RED     = Color3.fromRGB(239, 68,  68),
    ORANGE  = Color3.fromRGB(251, 146, 60),
    YELLOW  = Color3.fromRGB(250, 204, 21),
    BLUE    = Color3.fromRGB(96,  165, 250),
}

local originalSpeed = 16
local function captureOriginalSpeed()
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if hum and not Settings.Movement.SpeedEnabled then
        originalSpeed = hum.WalkSpeed
    end
end
task.defer(captureOriginalSpeed)

--////////////////////////////////////////////////////
-- NETTOYAGE
--////////////////////////////////////////////////////
for _, n in ipairs({"Azura-x Hub","AimbotCircle"}) do
    local old = game.CoreGui:FindFirstChild(n)
    if old then old:Destroy() end
end

--////////////////////////////////////////////////////
-- GUI ROOT
--////////////////////////////////////////////////////
local gui = Instance.new("ScreenGui")
gui.Name            = "Azura-x Hub"
gui.ResetOnSpawn    = false
gui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
gui.Parent          = game.CoreGui

--////////////////////////////////////////////////////
-- HELPERS
--////////////////////////////////////////////////////
local function mkCorner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 8)
end
local function mkStroke(p, col, th)
    local s = Instance.new("UIStroke", p)
    s.Color = col or C.BORDER
    s.Thickness = th or 1
end

--////////////////////////////////////////////////////
-- FENÊTRE  560 x 400
--////////////////////////////////////////////////////
local WIN_W, WIN_H = 560, 400
local SIDE_W       = 155
local TITLE_H      = 40

local win = Instance.new("Frame", gui)
win.Name             = "Win"
win.Size             = UDim2.new(0, WIN_W, 0, WIN_H)
win.Position         = UDim2.new(0, 60, 0, 60)
win.BackgroundColor3 = C.BG
win.BorderSizePixel  = 0
win.Active           = true
win.Draggable        = true
mkCorner(win, 12)
mkStroke(win, C.BORDER, 1)

-- Titre
local titleBar = Instance.new("Frame", win)
titleBar.Size             = UDim2.new(1, 0, 0, TITLE_H)
titleBar.Position         = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = C.SIDEBAR
titleBar.BorderSizePixel  = 0
titleBar.ZIndex           = 3
mkCorner(titleBar, 12)
local tpatch = Instance.new("Frame", titleBar)
tpatch.Size=UDim2.new(1,0,0,12); tpatch.Position=UDim2.new(0,0,1,-12)
tpatch.BackgroundColor3=C.SIDEBAR; tpatch.BorderSizePixel=0; tpatch.ZIndex=3

local tIcon = Instance.new("TextLabel", titleBar)
tIcon.Size=UDim2.new(0,32,1,0); tIcon.Position=UDim2.new(0,12,0,0)
tIcon.BackgroundTransparency=1; tIcon.Text="⚡"; tIcon.TextSize=16
tIcon.Font=Enum.Font.GothamBold; tIcon.TextColor3=C.ACCENT; tIcon.ZIndex=4

local tLbl = Instance.new("TextLabel", titleBar)
tLbl.Size=UDim2.new(1,-140,1,0); tLbl.Position=UDim2.new(0,40,0,0)
tLbl.BackgroundTransparency=1; tLbl.Text="Azura-x Hub"; tLbl.TextSize=13
tLbl.Font=Enum.Font.GothamBold; tLbl.TextColor3=C.TEXT
tLbl.TextXAlignment=Enum.TextXAlignment.Left; tLbl.ZIndex=4

local tHotkey = Instance.new("TextLabel", titleBar)
tHotkey.Size=UDim2.new(0,140,1,0); tHotkey.Position=UDim2.new(1,-148,0,0)
tHotkey.BackgroundTransparency=1; tHotkey.Text="Dev By uhquwu"
tHotkey.TextSize=10; tHotkey.Font=Enum.Font.Gotham
tHotkey.TextColor3=C.SUB; tHotkey.TextXAlignment=Enum.TextXAlignment.Right; tHotkey.ZIndex=4

-- Sidebar
local sidebar = Instance.new("Frame", win)
sidebar.Size             = UDim2.new(0, SIDE_W, 1, -TITLE_H)
sidebar.Position         = UDim2.new(0, 0, 0, TITLE_H)
sidebar.BackgroundColor3 = C.SIDEBAR
sidebar.BorderSizePixel  = 0
sidebar.ZIndex           = 2
mkCorner(sidebar, 12)
-- Cache coin haut-droit de la sidebar
local sbPatch = Instance.new("Frame", win)
sbPatch.Size=UDim2.new(0,12,0,12); sbPatch.Position=UDim2.new(0,SIDE_W-12,0,TITLE_H)
sbPatch.BackgroundColor3=C.SIDEBAR; sbPatch.BorderSizePixel=0; sbPatch.ZIndex=2

-- Séparateur
local divLine = Instance.new("Frame", win)
divLine.Size=UDim2.new(0,1,1,-TITLE_H); divLine.Position=UDim2.new(0,SIDE_W,0,TITLE_H)
divLine.BackgroundColor3=C.BORDER; divLine.BorderSizePixel=0; divLine.ZIndex=2

-- Contenu
local content = Instance.new("Frame", win)
content.Size=UDim2.new(0,WIN_W-SIDE_W-1,1,-TITLE_H)
content.Position=UDim2.new(0,SIDE_W+1,0,TITLE_H)
content.BackgroundTransparency=1; content.BorderSizePixel=0; content.ZIndex=2

--////////////////////////////////////////////////////
-- SYSTÈME D'ONGLETS
-- Boutons positionnés manuellement (pas de UIListLayout)
-- pour éviter tout conflit de layout
--////////////////////////////////////////////////////
local tabBtns  = {}
local pages    = {}
local activeTab = nil

local TABS = {
    {id="Info",      icon="👤",  label="Infos"},
    {id="ESP",      icon="👁",  label="ESP"},
    {id="Aimbot",   icon="🎯",  label="Aimbot"},
    {id="Movement", icon="🏃",  label="Movement"},
    {id="Graphics",  icon="🎨",  label="Graphisme"},
}

local function createPage()
    local sf = Instance.new("ScrollingFrame", content)
    sf.Size = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel = 0
    sf.ScrollBarThickness = 3
    sf.ScrollBarImageColor3 = C.ACCENT
    sf.CanvasSize = UDim2.new(0,0,0,0)
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.Visible = false
    local pad = Instance.new("UIPadding", sf)
    pad.PaddingTop=UDim.new(0,14); pad.PaddingLeft=UDim.new(0,14)
    pad.PaddingRight=UDim.new(0,18); pad.PaddingBottom=UDim.new(0,14)
    local layout = Instance.new("UIListLayout", sf)
    layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.Padding=UDim.new(0,8)
    return sf
end

local function selectTab(id)
    if activeTab == id then return end
    activeTab = id
    for tid, btn in pairs(tabBtns) do
        local on = tid == id
        btn.BackgroundColor3       = on and C.ACCENT or Color3.fromRGB(0,0,0)
        btn.BackgroundTransparency = on and 0 or 1
        btn.TextColor3             = on and C.WHITE or C.SUB
    end
    for tid, pg in pairs(pages) do
        pg.Visible = (tid == id)
    end
end

local BTN_H   = 38   -- hauteur bouton
local BTN_GAP = 4    -- espace entre boutons
local BTN_TOP = 14   -- padding haut

for i, tab in ipairs(TABS) do
    local yPos = BTN_TOP + (i-1) * (BTN_H + BTN_GAP)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size                = UDim2.new(1, -20, 0, BTN_H)
    btn.Position            = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel     = 0
    btn.Text                = tab.icon .. "   " .. tab.label
    btn.TextSize            = 13
    btn.Font                = Enum.Font.GothamBold
    btn.TextColor3          = C.SUB
    btn.TextXAlignment      = Enum.TextXAlignment.Left
    btn.ZIndex              = 3
    mkCorner(btn, 8)
    local bp = Instance.new("UIPadding", btn)
    bp.PaddingLeft = UDim.new(0, 10)

    tabBtns[tab.id] = btn
    pages[tab.id]   = createPage()

    btn.MouseButton1Click:Connect(function() selectTab(tab.id) end)
end

--////////////////////////////////////////////////////
-- HELPERS DE PAGE
--////////////////////////////////////////////////////
local function secTitle(page, text, order)
    local l = Instance.new("TextLabel", page)
    l.LayoutOrder = order; l.Size = UDim2.new(1, 0, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = text; l.TextSize = 10; l.Font = Enum.Font.GothamBold
    l.TextColor3 = C.ACCENT; l.TextXAlignment = Enum.TextXAlignment.Left
end

local function mkCard(page, h, order)
    local c = Instance.new("Frame", page)
    c.LayoutOrder = order; c.Size = UDim2.new(1, 0, 0, h)
    c.BackgroundColor3 = C.CARD; c.BorderSizePixel = 0
    mkCorner(c, 8); mkStroke(c, C.BORDER, 1)
    return c
end

-- Toggle pill : retourne (btn, setStateFn)
local function mkToggle(parent, label, sublabel, yOff, initState, col)
    col = col or C.ON

    local lbl = Instance.new("TextLabel", parent)
    lbl.Position = UDim2.new(0, 14, 0, yOff)
    lbl.Size     = UDim2.new(1, -72, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.Text = label; lbl.TextSize = 13; lbl.Font = Enum.Font.GothamBold
    lbl.TextColor3 = C.TEXT; lbl.TextXAlignment = Enum.TextXAlignment.Left

    if sublabel then
        local sl = Instance.new("TextLabel", parent)
        sl.Position = UDim2.new(0, 14, 0, yOff + 19)
        sl.Size     = UDim2.new(1, -72, 0, 13)
        sl.BackgroundTransparency = 1
        sl.Text = sublabel; sl.TextSize = 10; sl.Font = Enum.Font.Gotham
        sl.TextColor3 = C.SUB; sl.TextXAlignment = Enum.TextXAlignment.Left
    end

    local pill = Instance.new("TextButton", parent)
    pill.Position         = UDim2.new(1, -60, 0, yOff + (sublabel and 9 or 7))
    pill.Size             = UDim2.new(0, 46, 0, 22)
    pill.BorderSizePixel  = 0
    pill.Text             = ""
    pill.BackgroundColor3 = initState and col or C.OFF
    mkCorner(pill, 11)

    local dot = Instance.new("Frame", pill)
    dot.Size             = UDim2.new(0, 16, 0, 16)
    dot.Position         = initState and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
    dot.BackgroundColor3 = C.WHITE
    dot.BorderSizePixel  = 0
    mkCorner(dot, 8)

    local function setState(s)
        pill.BackgroundColor3 = s and col or C.OFF
        dot.Position = s and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
    end

    return pill, setState
end

-- Slider : retourne le tableau
local function mkSlider(parent, label, yOff, mn, mx, def, onChanged, fillCol)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Position = UDim2.new(0, 14, 0, yOff)
    lbl.Size     = UDim2.new(1, -20, 0, 15)
    lbl.BackgroundTransparency = 1
    lbl.TextSize = 11; lbl.Font = Enum.Font.Gotham
    lbl.TextColor3 = C.SUB; lbl.TextXAlignment = Enum.TextXAlignment.Left

    local track = Instance.new("Frame", parent)
    track.Position         = UDim2.new(0, 14, 0, yOff + 18)
    track.Size             = UDim2.new(1, -28, 0, 6)
    track.BackgroundColor3 = C.OFF
    track.BorderSizePixel  = 0
    mkCorner(track, 3)

    local fill = Instance.new("Frame", track)
    fill.BackgroundColor3 = fillCol or C.ACCENT
    fill.BorderSizePixel  = 0
    mkCorner(fill, 3)

    local dragging = false
    local function upd(v)
        v = math.clamp(math.floor(v), mn, mx)
        fill.Size = UDim2.new((v-mn)/(mx-mn), 0, 1, 0)
        lbl.Text  = label .. "  ·  " .. v
        return v
    end
    upd(def)

    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then dragging = true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch) then
            local px = math.clamp((i.Position.X - track.AbsolutePosition.X)
                / track.AbsoluteSize.X, 0, 1)
            onChanged(upd(mn + (mx-mn)*px))
        end
    end)
end

-- Sélecteur multi-boutons
local function mkSelect(parent, opts, yOff, sel, onSel)
    local W = content.AbsoluteSize.X - 28 - 28   -- approx
    local bw = math.max(60, math.floor((W - (# opts-1)*6) / #opts))
    local btns = {}
    for i, opt in ipairs(opts) do
        local b = Instance.new("TextButton", parent)
        b.Position         = UDim2.new(0, 14+(i-1)*(bw+6), 0, yOff)
        b.Size             = UDim2.new(0, bw, 0, 28)
        b.Text             = opt; b.TextSize = 11; b.Font = Enum.Font.GothamBold
        b.BorderSizePixel  = 0
        b.BackgroundColor3 = (i==sel) and C.ACCENT or C.OFF
        b.TextColor3       = C.WHITE
        mkCorner(b, 6)
        btns[i] = b
        b.MouseButton1Click:Connect(function()
            onSel(i)
            for j, bb in ipairs(btns) do
                bb.BackgroundColor3 = (j==i) and C.ACCENT or C.OFF
            end
        end)
    end
    return btns
end

--////////////////////////////////////////////////////
-- PAGE ESP
--////////////////////////////////////////////////////
local pESP = pages["ESP"]

secTitle(pESP, "GÉNÉRAL", 1)
local cESP = mkCard(pESP, 50, 2)
local espToggle, espSet = mkToggle(cESP, "ESP", "Afficher les ennemis", 8, Settings.ESP.Enabled)

secTitle(pESP, "OPTIONS D'AFFICHAGE", 3)
local cESPOpt = mkCard(pESP, 178, 4)
local hpTgl,   hpSet   = mkToggle(cESPOpt, "Santé",     "Barre de vie",      10, Settings.ESP.ShowHealth,    C.ON)
local disTgl,  disSet  = mkToggle(cESPOpt, "Distance",  "Afficher [Xm]",     52, Settings.ESP.ShowDistance,  C.ON)
local boxTgl,  boxSet  = mkToggle(cESPOpt, "Box",       "Contour 3D",        94, Settings.ESP.ShowBox,       C.ON)
local hlTgl,   hlSet   = mkToggle(cESPOpt, "Highlight", "Surbrillance",     136, Settings.ESP.ShowHighlight, C.ON)

--////////////////////////////////////////////////////
-- PAGE AIMBOT
--////////////////////////////////////////////////////
local pAB = pages["Aimbot"]

secTitle(pAB, "GÉNÉRAL", 1)
local cABMain = mkCard(pAB, 90, 2)
local abTgl,  abSet  = mkToggle(cABMain, "Aimbot",      "Touche G pour activer", 8,  Settings.Aimbot.Enabled,    C.RED)
local cirTgl, cirSet = mkToggle(cABMain, "Show Circle", "Cercle FOV souris",     50, Settings.Aimbot.ShowCircle, C.BLUE)

secTitle(pAB, "FOV", 3)
local cFOV = mkCard(pAB, 44, 4)
mkSlider(cFOV, "Rayon", 8, 50, 400, Settings.Aimbot.Radius,
    function(v) Settings.Aimbot.Radius = v end, C.ORANGE)

secTitle(pAB, "PRIORITÉ DE CIBLE", 5)
local cPrio = mkCard(pAB, 52, 6)
local prioInfoLbl = Instance.new("TextLabel", cPrio)
prioInfoLbl.Position = UDim2.new(0,14,0,6); prioInfoLbl.Size = UDim2.new(1,-20,0,14)
prioInfoLbl.BackgroundTransparency=1; prioInfoLbl.Text="Cibler en priorité"
prioInfoLbl.TextSize=10; prioInfoLbl.Font=Enum.Font.Gotham
prioInfoLbl.TextColor3=C.SUB; prioInfoLbl.TextXAlignment=Enum.TextXAlignment.Left
mkSelect(cPrio, {"Distance","HP bas","Écran"}, 22, Settings.Aimbot.Priority,
    function(i) Settings.Aimbot.Priority = i end)

secTitle(pAB, "SMOOTHING", 7)
local cSmooth = mkCard(pAB, 84, 8)
local smTgl, smSet = mkToggle(cSmooth, "Smooth", "Caméra fluide", 8, Settings.Aimbot.SmoothEnabled, C.BLUE)
mkSlider(cSmooth, "Intensité  (1=rapide · 50=lent)", 46, 1, 50, Settings.Aimbot.SmoothAmount,
    function(v) Settings.Aimbot.SmoothAmount = v end, C.BLUE)

secTitle(pAB, "PRÉDICTION", 9)
local cPredict = mkCard(pAB, 84, 10)
local prTgl, prSet = mkToggle(cPredict, "Predict", "Lead shot", 8, Settings.Aimbot.PredictEnabled, C.ORANGE)
mkSlider(cPredict, "Lead  (0=aucun · 20=fort)", 46, 0, 20, Settings.Aimbot.PredictAmount,
    function(v) Settings.Aimbot.PredictAmount = v end, C.ORANGE)

--////////////////////////////////////////////////////
-- PAGE MOVEMENT
--////////////////////////////////////////////////////
local pMov = pages["Movement"]

secTitle(pMov, "VITESSE", 1)
local cSpeed = mkCard(pMov, 84, 2)
local spTgl, spSet = mkToggle(cSpeed, "Speed", "Vitesse personnalisée", 8, Settings.Movement.SpeedEnabled, C.YELLOW)
mkSlider(cSpeed, "Valeur", 46, 16, 500, Settings.Movement.Speed,
    function(v) Settings.Movement.Speed = v end, C.YELLOW)

secTitle(pMov, "VOL", 3)
local cFly = mkCard(pMov, 84, 4)
local flyTgl, flySet = mkToggle(cFly, "Fly", "W/S/A/D + Space/Ctrl", 8, Settings.Movement.FlyEnabled, C.BLUE)
mkSlider(cFly, "Vitesse", 46, 50, 1000, Settings.Movement.FlySpeed,
    function(v) Settings.Movement.FlySpeed = v end, C.BLUE)

secTitle(pMov, "DIVERS", 5)
local cMisc = mkCard(pMov, 90, 6)
local ijTgl, ijSet = mkToggle(cMisc, "Infinite Jump", "Sauts illimités",       8,  Settings.Movement.InfiniteJump, C.ON)
local ncTgl, ncSet = mkToggle(cMisc, "NoClip",        "Passe à travers tout",  50, Settings.Movement.NoClip,       C.RED)

--////////////////////////////////////////////////////
-- PAGE GRAPHISME
--////////////////////////////////////////////////////
local pGfx = pages["Graphics"]

secTitle(pGfx, "PERFORMANCE", 1)
local cPotato = mkCard(pGfx, 50, 2)
local potatoTgl, potatoSet = mkToggle(cPotato, "Potato Graphics", "Qualité minimale", 8, Settings.Graphics.PotatoEnabled, C.YELLOW)

local cFog = mkCard(pGfx, 50, 3)
local fogTgl, fogSet = mkToggle(cFog, "Remove Fog", "Supprime le brouillard", 8, Settings.Graphics.RemoveFog, C.BLUE)

secTitle(pGfx, "CAMÉRA", 4)
local cFov = mkCard(pGfx, 84, 5)
local fovTgl, fovSet = mkToggle(cFov, "FOV personnalisé", "Champ de vision", 8, Settings.Graphics.FovEnabled, C.ORANGE)
mkSlider(cFov, "FOV", 46, 30, 120, Settings.Graphics.Fov,
    function(v)
        Settings.Graphics.Fov = v
        if Settings.Graphics.FovEnabled then
            workspace.CurrentCamera.FieldOfView = v
        end
    end, C.ORANGE)

secTitle(pGfx, "ANIMATIONS", 6)
local cAnim = mkCard(pGfx, 50, 7)
local animTgl, animSet = mkToggle(cAnim, "No Animation", "Désactive les animations", 8, Settings.Graphics.NoAnimation, C.RED)

--////////////////////////////////////////////////////
-- PAGE INFOS
--////////////////////////////////////////////////////
local pInfo = pages["Info"]

-- Card profil
local cProfil = mkCard(pInfo, 70, 1)

local avatarLbl = Instance.new("TextLabel", cProfil)
avatarLbl.Position = UDim2.new(0, 14, 0, 8)
avatarLbl.Size     = UDim2.new(1, -20, 0, 18)
avatarLbl.BackgroundTransparency = 1
avatarLbl.Text     = "👤  uhquwu"
avatarLbl.TextSize = 15
avatarLbl.Font     = Enum.Font.GothamBold
avatarLbl.TextColor3 = C.TEXT
avatarLbl.TextXAlignment = Enum.TextXAlignment.Left

local discordLbl = Instance.new("TextLabel", cProfil)
discordLbl.Position = UDim2.new(0, 14, 0, 32)
discordLbl.Size     = UDim2.new(1, -20, 0, 16)
discordLbl.BackgroundTransparency = 1
discordLbl.Text     = "💬  Discord : uhquwu"
discordLbl.TextSize = 12
discordLbl.Font     = Enum.Font.Gotham
discordLbl.TextColor3 = Color3.fromRGB(114, 137, 218)
discordLbl.TextXAlignment = Enum.TextXAlignment.Left

local versionLbl = Instance.new("TextLabel", cProfil)
versionLbl.Position = UDim2.new(0, 14, 0, 50)
versionLbl.Size     = UDim2.new(1, -20, 0, 14)
versionLbl.BackgroundTransparency = 1
versionLbl.Text     = "⚡  Script by uhquwu"
versionLbl.TextSize = 10
versionLbl.Font     = Enum.Font.Gotham
versionLbl.TextColor3 = C.ACCENT
versionLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Légende
local cLegend = mkCard(pInfo, 68, 2)

local legTitle = Instance.new("TextLabel", cLegend)
legTitle.Position = UDim2.new(0,14,0,6); legTitle.Size = UDim2.new(1,-20,0,14)
legTitle.BackgroundTransparency=1; legTitle.Text="LÉGENDE"
legTitle.TextSize=9; legTitle.Font=Enum.Font.GothamBold
legTitle.TextColor3=C.SUB; legTitle.TextXAlignment=Enum.TextXAlignment.Left

local function mkLegendRow(parent, yOff, symbol, desc, col)
    local sym = Instance.new("TextLabel", parent)
    sym.Position = UDim2.new(0,14,0,yOff); sym.Size = UDim2.new(0,30,0,14)
    sym.BackgroundTransparency=1; sym.Text=symbol
    sym.TextSize=11; sym.Font=Enum.Font.GothamBold
    sym.TextColor3=col; sym.TextXAlignment=Enum.TextXAlignment.Left

    local d = Instance.new("TextLabel", parent)
    d.Position=UDim2.new(0,44,0,yOff); d.Size=UDim2.new(1,-50,0,14)
    d.BackgroundTransparency=1; d.Text=desc
    d.TextSize=11; d.Font=Enum.Font.Gotham
    d.TextColor3=C.SUB; d.TextXAlignment=Enum.TextXAlignment.Left
end

mkLegendRow(cLegend, 24, "[=]", "Marche très bien",       Color3.fromRGB(34,197,94))
mkLegendRow(cLegend, 38, "[/]", "Marche moyen",            Color3.fromRGB(250,204,21))
mkLegendRow(cLegend, 52, "[x]", "Patché / Ne marche plus", Color3.fromRGB(239,68,68))

-- Changelog
local cLog = mkCard(pInfo, 200, 3)

local logTitle = Instance.new("TextLabel", cLog)
logTitle.Position=UDim2.new(0,14,0,8); logTitle.Size=UDim2.new(1,-20,0,16)
logTitle.BackgroundTransparency=1; logTitle.Text="📋  CHANGELOG"
logTitle.TextSize=11; logTitle.Font=Enum.Font.GothamBold
logTitle.TextColor3=C.ACCENT; logTitle.TextXAlignment=Enum.TextXAlignment.Left

local sep = Instance.new("Frame", cLog)
sep.Position=UDim2.new(0,14,0,28); sep.Size=UDim2.new(1,-28,0,1)
sep.BackgroundColor3=C.BORDER; sep.BorderSizePixel=0

-- Les logs — modifie juste ce tableau pour mettre à jour le changelog !
local LOGS = {
    { date="18/04/2025", status="/", text="ESP         | casi good" },
    { date="18/04/2025", status="=", text="Speed       | Actif" },
    { date="18/04/2025", status="/", text="Fly         | Casi good" },
    { date="18/04/2025", status="=", text="Infini Jump | Actif" },
    { date="18/04/2025", status="=", text="NoClip      | Actif" },
    { date="18/04/2025", status="/", text="aimbot      | Le aimbot se met mais que la ou le cercle est au centre" },
    { date="18/04/2025", status="x", text="Anti Fog    | Sa ne marche plus" },
    { date="18/04/2025", status="/", text="Potato mode | Potato marche casi pas" },
    { date="18/04/2025", status="=", text="FOV change  | Actif" },
    { date="18/04/2025", status="/", text="no anime    | Marche mais pas avec les m1" },
}

local STATUS_COLORS = {
    ["="] = Color3.fromRGB(34,197,94),
    ["/"] = Color3.fromRGB(250,204,21),
    ["x"] = Color3.fromRGB(239,68,68),
}

for i, log in ipairs(LOGS) do
    local yOff = 36 + (i-1)*19

    local statusLbl = Instance.new("TextLabel", cLog)
    statusLbl.Position = UDim2.new(0,14,0,yOff)
    statusLbl.Size     = UDim2.new(0,28,0,15)
    statusLbl.BackgroundTransparency=1
    statusLbl.Text     = "["..log.status.."]"
    statusLbl.TextSize = 11; statusLbl.Font=Enum.Font.GothamBold
    statusLbl.TextColor3 = STATUS_COLORS[log.status] or C.SUB
    statusLbl.TextXAlignment=Enum.TextXAlignment.Left

    local dateLbl = Instance.new("TextLabel", cLog)
    dateLbl.Position = UDim2.new(0,46,0,yOff)
    dateLbl.Size     = UDim2.new(0,80,0,15)
    dateLbl.BackgroundTransparency=1
    dateLbl.Text     = log.date
    dateLbl.TextSize = 10; dateLbl.Font=Enum.Font.Gotham
    dateLbl.TextColor3 = C.SUB
    dateLbl.TextXAlignment=Enum.TextXAlignment.Left

    local textLbl = Instance.new("TextLabel", cLog)
    textLbl.Position = UDim2.new(0,126,0,yOff)
    textLbl.Size     = UDim2.new(1,-140,0,15)
    textLbl.BackgroundTransparency=1
    textLbl.Text     = log.text
    textLbl.TextSize = 10; textLbl.Font=Enum.Font.Gotham
    textLbl.TextColor3 = C.TEXT
    textLbl.TextXAlignment=Enum.TextXAlignment.Left
end

-- Onglet par défaut
selectTab("Info")

--////////////////////////////////////////////////////
-- TOGGLE FENÊTRE
--////////////////////////////////////////////////////
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightAlt then
        win.Visible = not win.Visible
    end
end)

--////////////////////////////////////////////////////
-- FLY SYSTEM
--////////////////////////////////////////////////////
local flyBV, flyBG = nil, nil

local function enableFly(char)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    local bv = Instance.new("BodyVelocity", hrp)
    bv.Name="FlyBV"; bv.MaxForce=Vector3.new(1e6,1e6,1e6); bv.Velocity=Vector3.zero
    local bg = Instance.new("BodyGyro", hrp)
    bg.Name="FlyBG"; bg.MaxTorque=Vector3.new(1e6,1e6,1e6)
    bg.P=1e4; bg.D=500; bg.CFrame=hrp.CFrame
    flyBV=bv; flyBG=bg
end

local function disableFly()
    if flyBV then flyBV:Destroy(); flyBV=nil end
    if flyBG then flyBG:Destroy(); flyBG=nil end
    local char=LocalPlayer.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.PlatformStand=false
        local hrp=char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tmp=Instance.new("BodyVelocity",hrp)
            tmp.MaxForce=Vector3.new(1e6,1e6,1e6); tmp.Velocity=Vector3.zero
            task.delay(0.1,function() tmp:Destroy() end)
        end
    end
end

--////////////////////////////////////////////////////
-- NOCLIP
--////////////////////////////////////////////////////
local noClipConn = nil

local function applyNoClip(char)
    if noClipConn then noClipConn:Disconnect() end
    noClipConn = RunService.Stepped:Connect(function()
        if not Settings.Movement.NoClip then return end
        for _,p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end)
end

local function restoreCollision(char)
    if noClipConn then noClipConn:Disconnect(); noClipConn=nil end
    for _,p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide=true end
    end
end

--////////////////////////////////////////////////////
-- ESP SYSTEM
--////////////////////////////////////////////////////
local ESPObjects = {}

local function healthColor(pct)
    return Color3.fromRGB(255*(1-pct),255*pct,0)
end

local function removeESP(p)
    if ESPObjects[p] then
        for _,v in pairs(ESPObjects[p]) do
            if typeof(v)=="Instance" and v.Parent then v:Destroy() end
        end
        ESPObjects[p]=nil
    end
end

local function createESP(p)
    if p==LocalPlayer then return end
    removeESP(p)
    local char=p.Character; if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    char.AncestryChanged:Connect(function()
        if not char.Parent then removeESP(p) end
    end)

    local box=Instance.new("BoxHandleAdornment",workspace)
    box.Adornee=hrp; box.Size=hrp.Size+Vector3.new(0.2,0.2,0.2)
    box.AlwaysOnTop=true; box.Transparency=0.5; box.Color3=Color3.fromRGB(255,50,50)

    local hl=Instance.new("Highlight",char)
    hl.FillColor=Color3.fromRGB(255,50,50); hl.FillTransparency=0.65
    hl.OutlineColor=Color3.fromRGB(255,50,50); hl.OutlineTransparency=0

    local bb=Instance.new("BillboardGui",hrp)
    bb.Size=UDim2.new(0,150,0,46); bb.StudsOffset=Vector3.new(0,3.5,0); bb.AlwaysOnTop=true

    local txt=Instance.new("TextLabel",bb)
    txt.Size=UDim2.new(1,0,0,20); txt.BackgroundTransparency=1
    txt.TextStrokeTransparency=0.4; txt.Font=Enum.Font.GothamBold
    txt.TextSize=13; txt.TextColor3=Color3.fromRGB(255,80,80)

    local hpBG=Instance.new("Frame",bb)
    hpBG.Position=UDim2.new(0,10,0,26); hpBG.Size=UDim2.new(1,-20,0,6)
    hpBG.BackgroundColor3=Color3.fromRGB(35,35,35)
    Instance.new("UICorner",hpBG).CornerRadius=UDim.new(1,0)

    local hpBar=Instance.new("Frame",hpBG)
    hpBar.BackgroundColor3=Color3.fromRGB(0,200,80)
    Instance.new("UICorner",hpBar).CornerRadius=UDim.new(1,0)

    ESPObjects[p]={Box=box,HL=hl,BB=bb,TXT=txt,HP=hpBar,HUM=hum,HRP=hrp}
end

for _,p in ipairs(Players:GetPlayers()) do
    if p~=LocalPlayer then
        if p.Character then createESP(p) end
        p.CharacterAdded:Connect(function() task.wait(1); createESP(p) end)
    end
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.wait(1); createESP(p) end)
end)
Players.PlayerRemoving:Connect(removeESP)

--////////////////////////////////////////////////////
-- CERCLE AIMBOT
--////////////////////////////////////////////////////
local circleGui=Instance.new("ScreenGui")
circleGui.Name="AimbotCircle"; circleGui.ResetOnSpawn=false
circleGui.IgnoreGuiInset=true; circleGui.Parent=game.CoreGui

local SEGS, SEG_W = 128, 2
local circleSegs  = {}
for i=1,SEGS do
    local s=Instance.new("Frame",circleGui)
    s.BackgroundColor3=Color3.new(1,1,1); s.BorderSizePixel=0
    s.AnchorPoint=Vector2.new(0.5,0); s.Visible=false
    circleSegs[i]=s
end

local function updateCircle()
    if not (Settings.Aimbot.Enabled and Settings.Aimbot.ShowCircle) then
        for _,s in ipairs(circleSegs) do s.Visible=false end; return
    end
    local r=Settings.Aimbot.Radius
    local m=UIS:GetMouseLocation()
    local cx,cy=m.X,m.Y
    for i,seg in ipairs(circleSegs) do
        local a1=((i-1)/SEGS)*math.pi*2; local a2=(i/SEGS)*math.pi*2
        local x1=cx+math.cos(a1)*r; local y1=cy+math.sin(a1)*r
        local x2=cx+math.cos(a2)*r; local y2=cy+math.sin(a2)*r
        local len=math.sqrt((x2-x1)^2+(y2-y1)^2)+1
        seg.Size=UDim2.new(0,SEG_W,0,len)
        seg.Position=UDim2.new(0,x1,0,y1)
        seg.Rotation=math.deg(math.atan2(y2-y1,x2-x1))+90
        seg.Visible=true
    end
end

--////////////////////////////////////////////////////
-- AIMBOT
--////////////////////////////////////////////////////
local lastPositions = {}
local lastTime      = tick()

local function getAimbotTarget()
    local cx,cy=Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2
    local best,bestScore=nil,math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LocalPlayer then continue end
        local char=p.Character
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health<=0 then continue end
        local aimPart=char:FindFirstChild("Head") or hrp
        local pos2d,onScreen=Camera:WorldToViewportPoint(aimPart.Position)
        if not onScreen then continue end
        local sd=math.sqrt((pos2d.X-cx)^2+(pos2d.Y-cy)^2)
        if sd>Settings.Aimbot.Radius then continue end
        local score
        if Settings.Aimbot.Priority==1 then
            score=(Camera.CFrame.Position-hrp.Position).Magnitude
        elseif Settings.Aimbot.Priority==2 then
            score=hum.Health
        else
            score=sd
        end
        if score<bestScore then bestScore=score; best={part=aimPart,player=p,hum=hum,hrp=hrp} end
    end
    return best
end

local aimbotActive=false; local aimbotData=nil

local function smoothLook(cf,tp,sf)
    return cf:Lerp(CFrame.lookAt(cf.Position,tp), math.clamp(1/sf,0.01,1))
end

UIS.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if not Settings.Aimbot.Enabled then return end
    if input.KeyCode~=Enum.KeyCode.G then return end
    local t=getAimbotTarget(); if not t then return end
    aimbotData=t; aimbotActive=true
end)
UIS.InputEnded:Connect(function(input)
    if input.KeyCode~=Enum.KeyCode.G then return end
    aimbotActive=false; aimbotData=nil
end)

--////////////////////////////////////////////////////
-- BOUCLE PRINCIPALE
--////////////////////////////////////////////////////
RunService.RenderStepped:Connect(function()
    local char=LocalPlayer.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local hrp=char and char:FindFirstChild("HumanoidRootPart")

    -- ESP
    for p,d in pairs(ESPObjects) do
        if not d.HRP or not d.HRP.Parent then removeESP(p); continue end
        if not Settings.ESP.Enabled or d.HUM.Health<=0 then
            d.Box.Visible=false; d.HL.Enabled=false; d.BB.Enabled=false; continue
        end
        local dist=math.floor((Camera.CFrame.Position-d.HRP.Position).Magnitude)
        d.Box.Visible=Settings.ESP.ShowBox; d.HL.Enabled=Settings.ESP.ShowHighlight
        d.BB.Enabled=true
        d.TXT.Text=p.Name..(Settings.ESP.ShowDistance and (" ["..dist.."m]") or "")
        if Settings.ESP.ShowHealth then
            local pct=math.clamp(d.HUM.Health/d.HUM.MaxHealth,0,1)
            d.HP.Size=UDim2.new(pct,0,1,0); d.HP.BackgroundColor3=healthColor(pct); d.HP.Visible=true
        else d.HP.Visible=false end
    end

    -- Cercle
    updateCircle()

    -- FOV
    if Settings.Graphics.FovEnabled then
        Camera.FieldOfView = Settings.Graphics.Fov
    end

    -- No Animation
    if Settings.Graphics.NoAnimation then
        local c = LocalPlayer.Character
        if c then
            local anim = c:FindFirstChildOfClass("Humanoid")
            anim = anim and anim:FindFirstChildOfClass("Animator")
            if anim then
                for _, track in ipairs(anim:GetPlayingAnimationTracks()) do
                    track:Stop(0)
                end
            end
        end
    end

    -- Aimbot lock-on
    if Settings.Aimbot.Enabled and aimbotActive and aimbotData then
        local part=aimbotData.part
        if not part or not part.Parent then
            local nt=getAimbotTarget()
            if nt then aimbotData=nt
            else Camera.CameraType=Enum.CameraType.Custom; aimbotActive=false; aimbotData=nil end
        else
            local tp=part.Position
            if Settings.Aimbot.PredictEnabled then
                local hrpT=aimbotData.hrp
                if hrpT and hrpT:IsA("BasePart") then
                    local ok,vel=pcall(function() return hrpT.AssemblyLinearVelocity end)
                    if ok then tp=tp+vel*(Settings.Aimbot.PredictAmount*0.05) end
                end
            end
            local newCF
            if Settings.Aimbot.SmoothEnabled and Settings.Aimbot.SmoothAmount>1 then
                newCF=smoothLook(Camera.CFrame,tp,Settings.Aimbot.SmoothAmount)
            else
                newCF=CFrame.lookAt(Camera.CFrame.Position,tp)
            end
            Camera.CameraType=Enum.CameraType.Scriptable
            Camera.CFrame=newCF
            task.defer(function()
                if aimbotActive then Camera.CameraType=Enum.CameraType.Custom end
            end)
        end
    end

    if not hum or not hrp then return end

    -- Speed
    if Settings.Movement.SpeedEnabled then
        hum.WalkSpeed=Settings.Movement.Speed
    else
        if hum.WalkSpeed~=originalSpeed and hum.WalkSpeed>0 then
            originalSpeed=hum.WalkSpeed
        else hum.WalkSpeed=originalSpeed end
    end

    -- Fly
    if Settings.Movement.FlyEnabled then
        if not flyBV or not flyBV.Parent then enableFly(char) end
        if flyBV then
            hum.PlatformStand=true
            local cf=Camera.CFrame
            local look=Vector3.new(cf.LookVector.X,0,cf.LookVector.Z)
            if look.Magnitude>0.01 then look=look.Unit end
            local right=Vector3.new(cf.RightVector.X,0,cf.RightVector.Z)
            if right.Magnitude>0.01 then right=right.Unit end
            local dir=Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W)           then dir+=look          end
            if UIS:IsKeyDown(Enum.KeyCode.S)           then dir-=look          end
            if UIS:IsKeyDown(Enum.KeyCode.A)           then dir-=right         end
            if UIS:IsKeyDown(Enum.KeyCode.D)           then dir+=right         end
            if UIS:IsKeyDown(Enum.KeyCode.Space)       then dir+=Vector3.yAxis end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir-=Vector3.yAxis end
            flyBV.Velocity=dir.Magnitude>0.01 and dir.Unit*Settings.Movement.FlySpeed or Vector3.zero
            flyBG.CFrame=CFrame.new(hrp.Position)*CFrame.Angles(0,math.atan2(-cf.LookVector.X,-cf.LookVector.Z),0)
        end
    else
        if flyBV then disableFly() end
    end
end)

RunService.Heartbeat:Connect(function()
    if not Settings.Aimbot.Enabled then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LocalPlayer then continue end
        local char=p.Character
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if hrp then lastPositions[p]=hrp.Position end
    end
    lastTime=tick()
end)

UIS.JumpRequest:Connect(function()
    if not Settings.Movement.InfiniteJump then return end
    local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

--////////////////////////////////////////////////////
-- LOGIQUE TOGGLES
--////////////////////////////////////////////////////
-- ESP
espToggle.MouseButton1Click:Connect(function()
    Settings.ESP.Enabled=not Settings.ESP.Enabled; espSet(Settings.ESP.Enabled) end)
hpTgl.MouseButton1Click:Connect(function()
    Settings.ESP.ShowHealth=not Settings.ESP.ShowHealth; hpSet(Settings.ESP.ShowHealth) end)
disTgl.MouseButton1Click:Connect(function()
    Settings.ESP.ShowDistance=not Settings.ESP.ShowDistance; disSet(Settings.ESP.ShowDistance) end)
boxTgl.MouseButton1Click:Connect(function()
    Settings.ESP.ShowBox=not Settings.ESP.ShowBox; boxSet(Settings.ESP.ShowBox) end)
hlTgl.MouseButton1Click:Connect(function()
    Settings.ESP.ShowHighlight=not Settings.ESP.ShowHighlight; hlSet(Settings.ESP.ShowHighlight) end)

-- Aimbot
abTgl.MouseButton1Click:Connect(function()
    Settings.Aimbot.Enabled=not Settings.Aimbot.Enabled; abSet(Settings.Aimbot.Enabled)
    if not Settings.Aimbot.Enabled then
        aimbotActive=false; aimbotData=nil; Camera.CameraType=Enum.CameraType.Custom
    end
end)
cirTgl.MouseButton1Click:Connect(function()
    Settings.Aimbot.ShowCircle=not Settings.Aimbot.ShowCircle; cirSet(Settings.Aimbot.ShowCircle) end)
smTgl.MouseButton1Click:Connect(function()
    Settings.Aimbot.SmoothEnabled=not Settings.Aimbot.SmoothEnabled; smSet(Settings.Aimbot.SmoothEnabled) end)
prTgl.MouseButton1Click:Connect(function()
    Settings.Aimbot.PredictEnabled=not Settings.Aimbot.PredictEnabled; prSet(Settings.Aimbot.PredictEnabled) end)

-- Graphics
--////////////////////////////////////////////////////
-- POTATO MODE
--////////////////////////////////////////////////////
local potatoConns    = {}  -- connexions DescendantAdded
local potatoOrigFx   = {}  -- post-effets sauvegardés
local potatoOrigLight = {}  -- données lighting sauvegardées
local potatoDestroyed = {}  -- objets détruits (SurfaceAppearance, lights)

local function applyPotato()
    local ls  = game:GetService("Lighting")
    local ter = workspace:FindFirstChildOfClass("Terrain")

    pcall(function() settings().Rendering.QualityLevel = 1 end)

    -- Sauvegarde lighting
    potatoOrigLight = {
        GlobalShadows  = ls.GlobalShadows,
        FogEnd         = ls.FogEnd,
        FogStart       = ls.FogStart,
        Brightness     = ls.Brightness,
        Ambient        = ls.Ambient,
        OutdoorAmbient = ls.OutdoorAmbient,
    }
    ls.GlobalShadows  = false
    ls.FogEnd         = 9e9
    ls.FogStart       = 9e9

    -- Post-effets off
    potatoOrigFx = {}
    for _, ef in ipairs(ls:GetChildren()) do
        if ef:IsA("PostEffect") then
            potatoOrigFx[ef] = ef.Enabled
            ef.Enabled = false
        end
    end

    -- Terrain deco off
    if ter then
        potatoOrigLight.Decoration = ter.Decoration
        ter.Decoration = false
    end

    -- Fonction optim workspace
    local function optimPart(v)
        if v:IsA("BasePart") then
            v.Material    = Enum.Material.Plastic
            v.Reflectance = 0
            v.CastShadow  = false
        end
    end
    local function disableVFX(v)
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
            v.Enabled = false
        end
    end
    local function removeTextures(v)
        if v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("SurfaceAppearance") then
            v:Destroy()
        end
    end
    local function removeLights(v)
        if v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
            v:Destroy()
        end
    end

    -- Appliquer sur tous les descendants existants
    for _, v in ipairs(workspace:GetDescendants()) do
        optimPart(v)
        disableVFX(v)
        removeTextures(v)
        removeLights(v)
    end

    -- Optimiser perso
    local function optimChar(char)
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CastShadow = false
                v.Material   = Enum.Material.Plastic
            elseif v:IsA("Decal") then
                v.Transparency = 1
            end
        end
    end
    if LocalPlayer.Character then optimChar(LocalPlayer.Character) end
    local charConn = LocalPlayer.CharacterAdded:Connect(optimChar)

    -- Connexions pour les nouveaux objets
    local c1 = workspace.DescendantAdded:Connect(optimPart)
    local c2 = workspace.DescendantAdded:Connect(disableVFX)
    local c3 = workspace.DescendantAdded:Connect(removeTextures)
    local c4 = workspace.DescendantAdded:Connect(removeLights)
    potatoConns = {c1, c2, c3, c4, charConn}
end

local function removePotato()
    local ls  = game:GetService("Lighting")
    local ter = workspace:FindFirstChildOfClass("Terrain")

    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic end)

    -- Restore lighting
    ls.GlobalShadows  = potatoOrigLight.GlobalShadows  ~= nil and potatoOrigLight.GlobalShadows  or true
    ls.FogEnd         = potatoOrigLight.FogEnd         or 100000
    ls.FogStart       = potatoOrigLight.FogStart       or 0
    ls.Brightness     = potatoOrigLight.Brightness     or 2
    ls.Ambient        = potatoOrigLight.Ambient        or Color3.fromRGB(70,70,70)
    ls.OutdoorAmbient = potatoOrigLight.OutdoorAmbient or Color3.fromRGB(70,70,70)

    -- Restore post-effets
    for ef, state in pairs(potatoOrigFx) do
        if ef and ef.Parent then ef.Enabled = state end
    end
    potatoOrigFx = {}

    if ter and potatoOrigLight.Decoration ~= nil then
        ter.Decoration = potatoOrigLight.Decoration
    end
    potatoOrigLight = {}

    -- Déconnecter les listeners
    for _, c in ipairs(potatoConns) do
        if c then c:Disconnect() end
    end
    potatoConns = {}
end

potatoTgl.MouseButton1Click:Connect(function()
    Settings.Graphics.PotatoEnabled = not Settings.Graphics.PotatoEnabled
    potatoSet(Settings.Graphics.PotatoEnabled)
    if Settings.Graphics.PotatoEnabled then
        applyPotato()
    else
        removePotato()
    end
end)

fogTgl.MouseButton1Click:Connect(function()
    Settings.Graphics.RemoveFog = not Settings.Graphics.RemoveFog
    fogSet(Settings.Graphics.RemoveFog)
    local ls = game:GetService("Lighting")
    if Settings.Graphics.RemoveFog then
        ls.FogEnd   = 9e9
        ls.FogStart = 9e9
    else
        ls.FogEnd   = 100000
        ls.FogStart = 0
    end
end)

fovTgl.MouseButton1Click:Connect(function()
    Settings.Graphics.FovEnabled = not Settings.Graphics.FovEnabled
    fovSet(Settings.Graphics.FovEnabled)
    if Settings.Graphics.FovEnabled then
        workspace.CurrentCamera.FieldOfView = Settings.Graphics.Fov
    else
        workspace.CurrentCamera.FieldOfView = 70
    end
end)

animTgl.MouseButton1Click:Connect(function()
    Settings.Graphics.NoAnimation = not Settings.Graphics.NoAnimation
    animSet(Settings.Graphics.NoAnimation)
    local char = LocalPlayer.Character
    if not char then return end
    local animator = char:FindFirstChildOfClass("Humanoid")
        and char:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator")
    if Settings.Graphics.NoAnimation then
        if animator then animator:GetPlayingAnimationTracks() end
        for _, track in ipairs(animator and animator:GetPlayingAnimationTracks() or {}) do
            track:Stop()
        end
    end
end)

-- Movement
spTgl.MouseButton1Click:Connect(function()
    Settings.Movement.SpeedEnabled=not Settings.Movement.SpeedEnabled; spSet(Settings.Movement.SpeedEnabled) end)
flyTgl.MouseButton1Click:Connect(function()
    Settings.Movement.FlyEnabled=not Settings.Movement.FlyEnabled; flySet(Settings.Movement.FlyEnabled)
    if not Settings.Movement.FlyEnabled then disableFly() end
end)
ijTgl.MouseButton1Click:Connect(function()
    Settings.Movement.InfiniteJump=not Settings.Movement.InfiniteJump; ijSet(Settings.Movement.InfiniteJump) end)
ncTgl.MouseButton1Click:Connect(function()
    Settings.Movement.NoClip=not Settings.Movement.NoClip; ncSet(Settings.Movement.NoClip)
    local char=LocalPlayer.Character
    if char then
        if Settings.Movement.NoClip then applyNoClip(char) else restoreCollision(char) end
    end
end)

--////////////////////////////////////////////////////
-- RESPAWN
--////////////////////////////////////////////////////
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1); flyBV=nil; flyBG=nil
    if not Settings.Movement.SpeedEnabled then
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum then originalSpeed=hum.WalkSpeed end
    end
    if Settings.Movement.FlyEnabled  then enableFly(char)   end
    if Settings.Movement.NoClip      then applyNoClip(char) end
end)
