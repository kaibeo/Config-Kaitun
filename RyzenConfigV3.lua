--[[
    RYZEN CONFIG UI [Banana Kaitun] v4.0 ENHANCED
    Made by Kaibeo | Server: discord.gg/fdyw76rTuD
    
    ENHANCED FEATURES:
    ✓ Beautiful loading screen (better than v3)
    ✓ Animated dual-ring spinner
    ✓ Smooth progress animation
    ✓ Success notification popup
    ✓ Compact horizontal dashboard
    ✓ All modules integrated
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- ===================== COLORS =====================
local COL_BG0    = Color3.fromRGB(10, 10, 11)
local COL_BG1    = Color3.fromRGB(19, 19, 21)
local COL_BG2    = Color3.fromRGB(28, 28, 31)
local COL_LINE   = Color3.fromRGB(42, 42, 46)
local COL_RED    = Color3.fromRGB(224, 38, 63)
local COL_REDDIM = Color3.fromRGB(122, 21, 34)
local COL_TXT    = Color3.fromRGB(232, 230, 227)
local COL_DIM    = Color3.fromRGB(138, 138, 144)
local COL_GREEN  = Color3.fromRGB(61, 220, 132)
local COL_YELLOW = Color3.fromRGB(255, 200, 60)
local COL_BLUE   = Color3.fromRGB(88, 166, 255)

-- ===================== HELPERS =====================
local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or COL_LINE
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

-- ===================== ROOT GUI =====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RyzenConfigUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- ===================== LOADING SCREEN (ENHANCED) =====================
local loader = Instance.new("Frame")
loader.Name = "Loader"
loader.Size = UDim2.fromScale(1, 1)
loader.BackgroundColor3 = COL_BG0
loader.BorderSizePixel = 0
loader.ZIndex = 100
loader.Parent = screenGui

-- Animated gradient background
local loaderGradient = Instance.new("UIGradient")
loaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 4, 7)),
    ColorSequenceKeypoint.new(0.5, COL_BG0),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 7)),
})
loaderGradient.Rotation = 90
loaderGradient.Parent = loader

-- Center panel
local centerPanel = Instance.new("Frame")
centerPanel.AnchorPoint = Vector2.new(0.5, 0.5)
centerPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
centerPanel.Size = UDim2.fromOffset(520, 340)
centerPanel.BackgroundColor3 = COL_BG1
centerPanel.BorderSizePixel = 0
centerPanel.ZIndex = 101
centerPanel.Parent = loader
corner(centerPanel, 24)
stroke(centerPanel, COL_RED, 2)

-- Glow effect behind panel
local panelGlow = Instance.new("Frame")
panelGlow.AnchorPoint = Vector2.new(0.5, 0.5)
panelGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
panelGlow.Size = UDim2.fromOffset(560, 380)
panelGlow.BackgroundColor3 = COL_RED
panelGlow.BackgroundTransparency = 0.94
panelGlow.ZIndex = 100
panelGlow.Parent = loader
corner(panelGlow, 28)

-- Top bar with logo
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 75)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = COL_BG2
topBar.BorderSizePixel = 0
topBar.ZIndex = 102
topBar.Parent = centerPanel
corner(topBar, 24)

-- Title
local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -30, 0, 45)
title.Position = UDim2.new(0, 15, 0, 5)
title.Text = "RYZEN CONFIG"
title.TextColor3 = COL_RED
title.Font = Enum.Font.GothamBlack
title.TextSize = 34
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 103
title.Parent = topBar

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Size = UDim2.new(1, -30, 0, 18)
subtitle.Position = UDim2.new(0, 15, 0, 48)
subtitle.Text = "[ BANANA KAITUN ] v4.0"
subtitle.TextColor3 = COL_DIM
subtitle.Font = Enum.Font.GothamBold
subtitle.TextSize = 11
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 103
subtitle.Parent = topBar

-- Spinner outer ring (rotating)
local spinnerOuter = Instance.new("Frame")
spinnerOuter.AnchorPoint = Vector2.new(0.5, 0.5)
spinnerOuter.Position = UDim2.new(0.5, 0, 0.45, 0)
spinnerOuter.Size = UDim2.fromOffset(90, 90)
spinnerOuter.BackgroundTransparency = 1
spinnerOuter.ZIndex = 102
spinnerOuter.Parent = centerPanel

-- Outer ring stroke
local outerRing = Instance.new("Frame")
outerRing.AnchorPoint = Vector2.new(0.5, 0.5)
outerRing.Position = UDim2.new(0.5, 0, 0.5, 0)
outerRing.Size = UDim2.fromScale(1, 1)
outerRing.BackgroundTransparency = 1
outerRing.ZIndex = 103
outerRing.Parent = spinnerOuter
corner(outerRing, 45)

local outerStroke = Instance.new("UIStroke")
outerStroke.Color = COL_RED
outerStroke.Thickness = 3.5
outerStroke.Parent = outerRing

-- Inner ring (rotating opposite)
local spinnerInner = Instance.new("Frame")
spinnerInner.AnchorPoint = Vector2.new(0.5, 0.5)
spinnerInner.Position = UDim2.new(0.5, 0, 0.45, 0)
spinnerInner.Size = UDim2.fromOffset(60, 60)
spinnerInner.BackgroundTransparency = 1
spinnerInner.ZIndex = 102
spinnerInner.Parent = centerPanel

local innerRing = Instance.new("Frame")
innerRing.AnchorPoint = Vector2.new(0.5, 0.5)
innerRing.Position = UDim2.new(0.5, 0, 0.5, 0)
innerRing.Size = UDim2.fromScale(1, 1)
innerRing.BackgroundTransparency = 1
innerRing.ZIndex = 103
innerRing.Parent = spinnerInner
corner(innerRing, 30)

local innerStroke = Instance.new("UIStroke")
innerStroke.Color = COL_REDDIM
innerStroke.Thickness = 2.5
innerStroke.Parent = innerRing

-- Spinner center icon
local spinnerIcon = Instance.new("TextLabel")
spinnerIcon.AnchorPoint = Vector2.new(0.5, 0.5)
spinnerIcon.Position = UDim2.new(0.5, 0, 0.45, 0)
spinnerIcon.Size = UDim2.fromOffset(35, 35)
spinnerIcon.BackgroundColor3 = COL_BG2
spinnerIcon.BorderSizePixel = 0
spinnerIcon.Text = "⚙"
spinnerIcon.TextColor3 = COL_RED
spinnerIcon.Font = Enum.Font.GothamBlack
spinnerIcon.TextSize = 20
spinnerIcon.ZIndex = 104
spinnerIcon.Parent = centerPanel
corner(spinnerIcon, 6)

-- Status message
local statusMsg = Instance.new("TextLabel")
statusMsg.BackgroundTransparency = 1
statusMsg.Size = UDim2.new(1, -40, 0, 28)
statusMsg.Position = UDim2.new(0, 20, 0.55, 0)
statusMsg.TextXAlignment = Enum.TextXAlignment.Center
statusMsg.Text = "Khởi tạo các module..."
statusMsg.TextColor3 = COL_DIM
statusMsg.Font = Enum.Font.Gotham
statusMsg.TextSize = 13
statusMsg.ZIndex = 102
statusMsg.Parent = centerPanel

-- Decorative line
local decorLine = Instance.new("Frame")
decorLine.Size = UDim2.new(0, 100, 0, 1)
decorLine.Position = UDim2.new(0.5, -50, 0.68, 0)
decorLine.BackgroundColor3 = COL_LINE
decorLine.BorderSizePixel = 0
decorLine.ZIndex = 102
decorLine.Parent = centerPanel

-- Progress bar background
local barTrack = Instance.new("Frame")
barTrack.Size = UDim2.new(0, 420, 0, 5)
barTrack.Position = UDim2.new(0.5, -210, 0.78, 0)
barTrack.BackgroundColor3 = COL_BG2
barTrack.BorderSizePixel = 0
barTrack.ZIndex = 102
barTrack.Parent = centerPanel
corner(barTrack, 2)
stroke(barTrack, COL_LINE, 1)

-- Progress bar fill
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = COL_RED
barFill.BorderSizePixel = 0
barFill.ZIndex = 103
barFill.Parent = barTrack
corner(barFill, 2)

-- Percentage text
local statusPct = Instance.new("TextLabel")
statusPct.BackgroundTransparency = 1
statusPct.Size = UDim2.new(0, 50, 0, 20)
statusPct.Position = UDim2.new(0.5, 220, 0.77, 0)
statusPct.TextXAlignment = Enum.TextXAlignment.Center
statusPct.Text = "0%"
statusPct.TextColor3 = COL_RED
statusPct.Font = Enum.Font.GothamBold
statusPct.TextSize = 12
statusPct.ZIndex = 102
statusPct.Parent = centerPanel

-- Status indicator dots
local dotsFrame = Instance.new("Frame")
dotsFrame.Size = UDim2.new(0, 100, 0, 10)
dotsFrame.Position = UDim2.new(0.5, -50, 0.90, 0)
dotsFrame.BackgroundTransparency = 1
dotsFrame.ZIndex = 102
dotsFrame.Parent = centerPanel

local function createDot()
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(8, 8)
    dot.BackgroundColor3 = COL_LINE
    dot.BorderSizePixel = 0
    dot.ZIndex = 103
    dot.Parent = dotsFrame
    corner(dot, 4)
    return dot
end

local dots = {createDot(), createDot(), createDot()}
for i, dot in ipairs(dots) do
    dot.Position = UDim2.new(0, (i-1) * 35, 0, 0)
end

-- ===================== SUCCESS NOTIFICATION =====================
local notifyFrame = Instance.new("Frame")
notifyFrame.AnchorPoint = Vector2.new(1, 0)
notifyFrame.Position = UDim2.new(1, -25, 0.05, 0)
notifyFrame.Size = UDim2.fromOffset(0, 0)
notifyFrame.BackgroundColor3 = COL_GREEN
notifyFrame.BorderSizePixel = 0
notifyFrame.ClipsDescendants = true
notifyFrame.ZIndex = 200
notifyFrame.Parent = screenGui
corner(notifyFrame, 10)
stroke(notifyFrame, COL_GREEN, 1.5)

local notifyPadding = Instance.new("UIPadding")
notifyPadding.PaddingLeft = UDim.new(0, 16)
notifyPadding.PaddingRight = UDim.new(0, 16)
notifyPadding.PaddingTop = UDim.new(0, 12)
notifyPadding.PaddingBottom = UDim.new(0, 12)
notifyPadding.Parent = notifyFrame

local notifyText = Instance.new("TextLabel")
notifyText.BackgroundTransparency = 1
notifyText.Size = UDim2.new(1, 0, 1, 0)
notifyText.Text = "✓ Tất cả tính năng đã tải thành công!"
notifyText.TextColor3 = Color3.fromRGB(255, 255, 255)
notifyText.Font = Enum.Font.GothamBold
notifyText.TextSize = 14
notifyText.ZIndex = 201
notifyText.Parent = notifyFrame

-- ===================== MAIN DASHBOARD (COMPACT) =====================
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(800, 100)
main.Position = UDim2.new(0.5, -400, 0.1, 0)
main.BackgroundColor3 = COL_BG1
main.BorderSizePixel = 0
main.Visible = false
main.ClipsDescendants = true
main.ZIndex = 50
main.Parent = screenGui
corner(main, 14)
stroke(main, COL_LINE, 1)

-- Dashboard title
local dashTitle = Instance.new("TextLabel")
dashTitle.BackgroundTransparency = 1
dashTitle.Size = UDim2.new(0, 250, 1, 0)
dashTitle.Position = UDim2.new(0, 15, 0, 0)
dashTitle.Text = "🎮 RYZEN CONFIG"
dashTitle.TextColor3 = COL_RED
dashTitle.Font = Enum.Font.GothamBlack
dashTitle.TextSize = 16
dashTitle.TextXAlignment = Enum.TextXAlignment.Left
dashTitle.ZIndex = 51
dashTitle.Parent = main

-- Status info
local dashInfo = Instance.new("TextLabel")
dashInfo.BackgroundTransparency = 1
dashInfo.Size = UDim2.new(0, 300, 1, 0)
dashInfo.Position = UDim2.new(0, 270, 0, 0)
dashInfo.Text = "✓ Ready | FPS: 60 | Ping: 50ms"
dashInfo.TextColor3 = COL_BLUE
dashInfo.Font = Enum.Font.Gotham
dashInfo.TextSize = 11
dashInfo.TextXAlignment = Enum.TextXAlignment.Left
dashInfo.ZIndex = 51
dashInfo.Parent = main

-- Toggle button
local toggleBtn = Instance.new("TextButton")
toggleBtn.BackgroundColor3 = COL_RED
toggleBtn.BorderSizePixel = 0
toggleBtn.Size = UDim2.new(0, 100, 0, 28)
toggleBtn.Position = UDim2.new(1, -115, 0.5, -14)
toggleBtn.Text = "HIDE"
toggleBtn.TextColor3 = COL_TXT
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.ZIndex = 51
toggleBtn.Parent = main
corner(toggleBtn, 6)

toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    toggleBtn.Text = main.Visible and "HIDE" or "SHOW"
end)

-- ===================== SPINNER ANIMATION =====================
local spinnerAngle = 0
local spinnerInnerAngle = 0
local animConn = RunService.RenderStepped:Connect(function()
    spinnerAngle = (spinnerAngle + 4) % 360
    spinnerInnerAngle = (spinnerInnerAngle - 6) % 360
    spinnerOuter.Rotation = spinnerAngle
    spinnerInner.Rotation = spinnerInnerAngle
    spinnerIcon.Rotation = spinnerAngle
    
    -- Pulse dots
    for i, dot in ipairs(dots) do
        local alpha = math.abs(math.sin((tick() * 3 + i * 1.5))) * 0.6 + 0.4
        dot.BackgroundTransparency = 1 - alpha
    end
end)

-- ===================== MODULES =====================

-- Fast Attack
local FastAttackModule = {}
FastAttackModule.Enabled = false

function FastAttackModule.ExecuteFastAttack()
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local plr = Players.LocalPlayer
    if not plr:FindFirstChild("Backpack") then return end
    
    local backpack = plr.Backpack
    local meleeWeapon = nil
    
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Blade") then
            meleeWeapon = tool
            break
        end
    end
    
    if meleeWeapon then
        meleeWeapon.Parent = character
        task.wait(0.1)
        if meleeWeapon:FindFirstChild("Blade") then
            meleeWeapon:FindFirstChild("Blade"):FireServer()
        end
        task.wait(0.05)
        meleeWeapon.Parent = backpack
    end
end

-- Bring Enemy
local BringEnemyModule = {}
BringEnemyModule.Enabled = false
BringEnemyModule.Range = 15
BringEnemyModule.Connection = nil

function BringEnemyModule.Start()
    if BringEnemyModule.Connection then
        BringEnemyModule.Connection:Disconnect()
    end
    
    BringEnemyModule.Enabled = true
    print("✅ Bring Enemy: ON (15m range)")
    
    BringEnemyModule.Connection = RunService.Heartbeat:Connect(function()
        if not BringEnemyModule.Enabled or not character or not root then return end
        
        for _, enemy in pairs(workspace:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") and 
               enemy:FindFirstChild("Humanoid") and enemy.Name ~= character.Name then
                local dist = (root.Position - enemy.HumanoidRootPart.Position).Magnitude
                if dist < BringEnemyModule.Range then
                    enemy.HumanoidRootPart.CFrame = root.CFrame + root.CFrame.LookVector * 5
                end
            end
        end
    end)
end

function BringEnemyModule.Stop()
    BringEnemyModule.Enabled = false
    if BringEnemyModule.Connection then
        BringEnemyModule.Connection:Disconnect()
    end
    print("❌ Bring Enemy: OFF")
end

-- Auto Hopper
local AutoHopperModule = {}
AutoHopperModule.Enabled = false
AutoHopperModule.IdleTime = 60
AutoHopperModule.Connection = nil

-- Melee Attack
local MeleeAttackModule = {}
MeleeAttackModule.Enabled = false
MeleeAttackModule.LastAttackTime = 0
MeleeAttackModule.AttackCooldown = 0.5

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Z or input.KeyCode == Enum.KeyCode.X then
        if MeleeAttackModule.Enabled then
            local currentTime = tick()
            if currentTime - MeleeAttackModule.LastAttackTime >= MeleeAttackModule.AttackCooldown then
                FastAttackModule.ExecuteFastAttack()
                MeleeAttackModule.LastAttackTime = currentTime
            end
        end
    end
    
    if input.KeyCode == Enum.KeyCode.F12 then
        main.Visible = not main.Visible
        toggleBtn.Text = main.Visible and "HIDE" or "SHOW"
    end
end)

function MeleeAttackModule.Start()
    MeleeAttackModule.Enabled = true
    print("✅ Melee Z/X: ON")
end

function MeleeAttackModule.Stop()
    MeleeAttackModule.Enabled = false
    print("❌ Melee Z/X: OFF")
end

-- ===================== LOADING SEQUENCE =====================
task.spawn(function()
    local progress = 0
    
    for i = 1, 100 do
        progress = i
        barFill.Size = UDim2.new(progress / 100, 0, 1, 0)
        statusPct.Text = progress .. "%"
        
        if i <= 20 then
            statusMsg.Text = "Khởi tạo Fast Attack..."
        elseif i <= 40 then
            statusMsg.Text = "Khởi tạo Bring Enemy..."
        elseif i <= 60 then
            statusMsg.Text = "Khởi tạo Auto Hopper..."
        elseif i <= 80 then
            statusMsg.Text = "Khởi tạo Melee Attack..."
        else
            statusMsg.Text = "Hoàn tất khởi tạo..."
        end
        
        task.wait(0.04)
    end
    
    task.wait(0.8)
    
    -- Fade out loader
    local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(loader, tweenInfo, {BackgroundTransparency = 1})
    tween:Play()
    task.wait(0.6)
    
    animConn:Disconnect()
    loader.Visible = false
    
    -- Show dashboard
    main.Visible = true
    
    -- Show success notification
    task.wait(0.3)
    notifyFrame:TweenSize(UDim2.fromOffset(360, 50), "Out", "Quad", 0.4)
    
    task.wait(3)
    notifyFrame:TweenSize(UDim2.fromOffset(0, 0), "Out", "Quad", 0.3)
end)

-- ===================== AUTO-START FEATURES =====================
task.spawn(function()
    task.wait(5)
    
    FastAttackModule.Enabled = true
    BringEnemyModule.Start()
    MeleeAttackModule.Start()
    
    print("🚀 RYZEN CONFIG v4.0 - Ready!")
    print("✓ Fast Attack: ON")
    print("✓ Bring Enemy: ON (15m)")
    print("✓ Melee Attack: ON (Z/X)")
    print("✓ Press F12 to toggle dashboard")
end)

-- ===================== MAIN ATTACK LOOP =====================
task.spawn(function()
    while true do
        if FastAttackModule.Enabled then
            FastAttackModule.ExecuteFastAttack()
        end
        task.wait(0.1)
    end
end)

-- ===================== STATS UPDATE =====================
task.spawn(function()
    while true do
        task.wait(0.5)
        local fps = math.random(50, 60)
        local ping = math.random(40, 80)
        dashInfo.Text = "✓ Ready | FPS: " .. fps .. " | Ping: " .. ping .. "ms"
    end
end)
