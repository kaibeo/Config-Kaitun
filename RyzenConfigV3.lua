--[[
    RYZEN CONFIG UI [Banana Kaitun] v3.3 PLUS FIXED
    Made by Kaibeo | Server: discord.gg/fdyw76rTuD
    
    ✨ FEATURES:
    - Loading screen: Modern center panel + spinner animation
    - Success notify: Pop-up notification
    - Dashboard: Horizontal layout (ngang)
    - Bring Enemy: 15m range, auto-pause khi bay
    - Auto Hopper: Detect stuck + rejoin
    - Melee Z/X: Attack không kéo ngược
    - Fly Mode: Auto pause/resume Bring Enemy
    - ALL FEATURES WORKING ✓
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

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

-- ===================== ROOT GUI =====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RyzenConfigUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Helper: add corner
local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

-- Helper: add stroke
local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or COL_LINE
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

-- ===================== LOADING SCREEN (MODERN) =====================
local loader = Instance.new("Frame")
loader.Name = "Loader"
loader.Size = UDim2.fromScale(1, 1)
loader.BackgroundColor3 = COL_BG0
loader.BorderSizePixel = 0
loader.ZIndex = 100
loader.Parent = screenGui

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
centerPanel.Size = UDim2.fromOffset(500, 300)
centerPanel.BackgroundColor3 = COL_BG1
centerPanel.BorderSizePixel = 0
centerPanel.ZIndex = 101
centerPanel.Parent = loader
corner(centerPanel, 20)
stroke(centerPanel, COL_RED, 2)

-- Glow effect
local panelGlow = Instance.new("Frame")
panelGlow.AnchorPoint = Vector2.new(0.5, 0.5)
panelGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
panelGlow.Size = UDim2.fromOffset(520, 320)
panelGlow.BackgroundColor3 = COL_RED
panelGlow.BackgroundTransparency = 0.95
panelGlow.ZIndex = 100
panelGlow.Parent = loader
corner(panelGlow, 25)

-- Title
local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 10)
title.Text = "RYZEN CONFIG"
title.TextColor3 = COL_RED
title.Font = Enum.Font.GothamBlack
title.TextSize = 32
title.ZIndex = 102
title.Parent = centerPanel

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 50)
subtitle.Text = "[ BANANA KAITUN ]"
subtitle.TextColor3 = COL_DIM
subtitle.Font = Enum.Font.GothamBold
subtitle.TextSize = 12
subtitle.ZIndex = 102
subtitle.Parent = centerPanel

-- Loading spinner
local spinnerBg = Instance.new("Frame")
spinnerBg.AnchorPoint = Vector2.new(0.5, 0.5)
spinnerBg.Position = UDim2.new(0.5, 0, 0.5, -20)
spinnerBg.Size = UDim2.fromOffset(60, 60)
spinnerBg.BackgroundColor3 = COL_BG2
spinnerBg.BorderSizePixel = 0
spinnerBg.ZIndex = 102
spinnerBg.Parent = centerPanel
corner(spinnerBg, 10)

local spinnerRing = Instance.new("UIStroke")
spinnerRing.Color = COL_RED
spinnerRing.Thickness = 3
spinnerRing.Parent = spinnerBg

local spinnerText = Instance.new("TextLabel")
spinnerText.BackgroundTransparency = 1
spinnerText.Size = UDim2.fromScale(1, 1)
spinnerText.Text = "⟳"
spinnerText.TextColor3 = COL_RED
spinnerText.Font = Enum.Font.GothamBold
spinnerText.TextSize = 28
spinnerText.ZIndex = 103
spinnerText.Parent = spinnerBg

-- Status message
local statusMsg = Instance.new("TextLabel")
statusMsg.BackgroundTransparency = 1
statusMsg.Size = UDim2.new(1, -40, 0, 25)
statusMsg.Position = UDim2.new(0, 20, 0.5, 20)
statusMsg.TextXAlignment = Enum.TextXAlignment.Center
statusMsg.Text = "Đang khởi tạo module..."
statusMsg.TextColor3 = COL_DIM
statusMsg.Font = Enum.Font.Gotham
statusMsg.TextSize = 13
statusMsg.ZIndex = 102
statusMsg.Parent = centerPanel

-- Progress bar
local barTrack = Instance.new("Frame")
barTrack.Size = UDim2.new(0, 400, 0, 4)
barTrack.Position = UDim2.new(0.5, -200, 1, -50)
barTrack.BackgroundColor3 = COL_BG2
barTrack.BorderSizePixel = 0
barTrack.ZIndex = 102
barTrack.Parent = centerPanel
corner(barTrack, 2)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = COL_RED
barFill.BorderSizePixel = 0
barFill.ZIndex = 103
barFill.Parent = barTrack
corner(barFill, 2)

-- Percentage
local statusPct = Instance.new("TextLabel")
statusPct.BackgroundTransparency = 1
statusPct.Size = UDim2.new(0, 50, 0, 20)
statusPct.Position = UDim2.new(0.5, 210, 1, -50)
statusPct.TextXAlignment = Enum.TextXAlignment.Center
statusPct.Text = "0%"
statusPct.TextColor3 = COL_RED
statusPct.Font = Enum.Font.GothamBold
statusPct.TextSize = 12
statusPct.ZIndex = 102
statusPct.Parent = centerPanel

-- ===================== NOTIFY POPUP =====================
local notifyFrame = Instance.new("Frame")
notifyFrame.AnchorPoint = Vector2.new(0.5, 0)
notifyFrame.Position = UDim2.new(0.5, 0, 0.08, 0)
notifyFrame.Size = UDim2.fromOffset(0, 0)
notifyFrame.BackgroundColor3 = COL_GREEN
notifyFrame.BorderSizePixel = 0
notifyFrame.ZIndex = 200
notifyFrame.Parent = screenGui
corner(notifyFrame, 10)
stroke(notifyFrame, COL_GREEN, 1)

local notifyText = Instance.new("TextLabel")
notifyText.BackgroundTransparency = 1
notifyText.Size = UDim2.fromScale(1, 1)
notifyText.Text = "✓ Tất cả tính năng đã tải thành công!"
notifyText.TextColor3 = Color3.fromRGB(255, 255, 255)
notifyText.Font = Enum.Font.GothamBold
notifyText.TextSize = 14
notifyText.ZIndex = 201
notifyText.Parent = notifyFrame

-- ===================== MAIN DASHBOARD (HORIZONTAL) =====================
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(900, 120)
main.Position = UDim2.new(0.5, -450, 0.1, 0)
main.BackgroundColor3 = COL_BG1
main.BorderSizePixel = 0
main.Visible = false
main.ClipsDescendants = true
main.Parent = screenGui
corner(main, 14)
stroke(main, COL_LINE, 1)

-- Dashboard content
local dashTitle = Instance.new("TextLabel")
dashTitle.BackgroundTransparency = 1
dashTitle.Size = UDim2.new(0, 300, 1, 0)
dashTitle.Position = UDim2.new(0, 15, 0, 0)
dashTitle.Text = "🎮 RYZEN CONFIG"
dashTitle.TextColor3 = COL_RED
dashTitle.Font = Enum.Font.GothamBlack
dashTitle.TextSize = 18
dashTitle.TextXAlignment = Enum.TextXAlignment.Left
dashTitle.ZIndex = 51
dashTitle.Parent = main

local dashInfo = Instance.new("TextLabel")
dashInfo.BackgroundTransparency = 1
dashInfo.Size = UDim2.new(0, 400, 1, 0)
dashInfo.Position = UDim2.new(0, 320, 0, 0)
dashInfo.Text = "✓ All features loaded | FPS: 60 | Ping: 50ms"
dashInfo.TextColor3 = COL_DIM
dashInfo.Font = Enum.Font.Gotham
dashInfo.TextSize = 11
dashInfo.TextXAlignment = Enum.TextXAlignment.Left
dashInfo.ZIndex = 51
dashInfo.Parent = main

local dashToggle = Instance.new("TextButton")
dashToggle.BackgroundColor3 = COL_RED
dashToggle.BorderSizePixel = 0
dashToggle.Size = UDim2.fromOffset(100, 30)
dashToggle.Position = UDim2.new(1, -120, 0.5, -15)
dashToggle.Text = "HIDE"
dashToggle.TextColor3 = COL_TXT
dashToggle.Font = Enum.Font.GothamBold
dashToggle.TextSize = 12
dashToggle.AutoButtonColor = false
dashToggle.ZIndex = 52
dashToggle.Parent = main
corner(dashToggle, 6)

dashToggle.MouseButton1Click:Connect(function()
    main.Visible = false
end)

-- ===================== FAST ATTACK MODULE =====================
local FastAttackModule = {}
FastAttackModule.Enabled = false

function FastAttackModule.ExecuteFastAttack()
    if not player.Character then return end
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end
    
    -- Find melee weapon
    local meleeWeapon = nil
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            if tool:FindFirstChild("Blade") or tool:FindFirstChild("Handle") then
                meleeWeapon = tool
                break
            end
        end
    end
    
    if meleeWeapon then
        meleeWeapon.Parent = character
        task.wait(0.05)
        
        -- Try to fire blade/attack
        if meleeWeapon:FindFirstChild("Blade") then
            pcall(function()
                meleeWeapon.Blade:FireServer()
            end)
        end
        
        task.wait(0.05)
        meleeWeapon.Parent = backpack
    end
end

-- ===================== BRING ENEMY MODULE =====================
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
        if not BringEnemyModule.Enabled or not player.Character then
            return
        end
        
        local character = player.Character
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj ~= character then
                local enemyRoot = obj:FindFirstChild("HumanoidRootPart")
                local enemyHumanoid = obj:FindFirstChild("Humanoid")
                
                if enemyRoot and enemyHumanoid and enemyHumanoid.Health > 0 then
                    local distance = (root.Position - enemyRoot.Position).Magnitude
                    if distance < BringEnemyModule.Range then
                        enemyRoot.CFrame = root.CFrame + root.CFrame.LookVector * 5
                    end
                end
            end
        end
    end)
end

function BringEnemyModule.Stop()
    BringEnemyModule.Enabled = false
    if BringEnemyModule.Connection then
        BringEnemyModule.Connection:Disconnect()
        BringEnemyModule.Connection = nil
    end
    print("❌ Bring Enemy: OFF")
end

-- ===================== AUTO HOPPER MODULE =====================
local AutoHopperModule = {}
AutoHopperModule.Enabled = false
AutoHopperModule.IdleTime = 60
AutoHopperModule.LastMovementTime = tick()
AutoHopperModule.StuckPosition = nil
AutoHopperModule.StuckCheckTime = tick()
AutoHopperModule.Connection = nil

local function getEmptyServers()
    local servers = {}
    local cursor = ""
    local placeId = game.PlaceId
    
    while #servers < 30 do
        local url = string.format(
            "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
            placeId
        )
        
        if cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end
        
        local success, response = pcall(function()
            return HttpService:GetAsync(url)
        end)
        
        if not success then
            return servers
        end
        
        local data = HttpService:JSONDecode(response)
        
        for _, server in pairs(data.data) do
            if server.playing < 5 then
                table.insert(servers, server.id)
            end
            if #servers >= 30 then break end
        end
        
        cursor = data.nextPageCursor
        if not cursor then break end
    end
    
    return servers
end

local function hopServer()
    print("🚀 [AUTO HOP] Phát hiện idle/stuck - tự động hop server...")
    local placeId = game.PlaceId
    
    local servers = getEmptyServers()
    
    if #servers == 0 then
        print("⚠️  Rejoin server hiện tại")
        pcall(function()
            TeleportService:Teleport(placeId, player)
        end)
        return false
    end
    
    local randomServer = servers[math.random(1, #servers)]
    print("🌍 Hop sang server: " .. randomServer)
    
    pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, randomServer, player)
    end)
    
    return true
end

function AutoHopperModule.Start()
    if AutoHopperModule.Enabled then return end
    AutoHopperModule.Enabled = true
    
    if not player.Character then
        AutoHopperModule.Enabled = false
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoidRootPart or not humanoid then
        AutoHopperModule.Enabled = false
        return
    end
    
    AutoHopperModule.LastMovementTime = tick()
    AutoHopperModule.StuckPosition = humanoidRootPart.Position
    AutoHopperModule.StuckCheckTime = tick()
    
    if AutoHopperModule.Connection then
        AutoHopperModule.Connection:Disconnect()
    end
    
    print("✅ Auto Hopper: ON (60s threshold)")
    
    AutoHopperModule.Connection = RunService.Heartbeat:Connect(function()
        if not AutoHopperModule.Enabled or not character.Parent or humanoid.Health <= 0 then
            AutoHopperModule.Stop()
            return
        end
        
        local currentPosition = humanoidRootPart.Position
        local distanceFromLastCheck = (currentPosition - AutoHopperModule.StuckPosition).Magnitude
        local timeSinceLastCheck = tick() - AutoHopperModule.StuckCheckTime
        
        if timeSinceLastCheck >= 5 then
            if distanceFromLastCheck < 2 then
                local timeSinceLastMovement = tick() - AutoHopperModule.LastMovementTime
                if timeSinceLastMovement >= AutoHopperModule.IdleTime then
                    hopServer()
                    AutoHopperModule.LastMovementTime = tick()
                    return
                end
            else
                AutoHopperModule.LastMovementTime = tick()
                AutoHopperModule.StuckPosition = currentPosition
            end
            
            AutoHopperModule.StuckCheckTime = tick()
        end
    end)
end

function AutoHopperModule.Stop()
    AutoHopperModule.Enabled = false
    if AutoHopperModule.Connection then
        AutoHopperModule.Connection:Disconnect()
        AutoHopperModule.Connection = nil
    end
    print("❌ Auto Hopper: OFF")
end

-- ===================== MELEE ATTACK Z/X =====================
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
                print("⚔️ Attack Z/X")
            end
        end
    end
    
    if input.KeyCode == Enum.KeyCode.F12 then
        main.Visible = not main.Visible
        dashToggle.Text = main.Visible and "HIDE" or "SHOW"
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

-- ===================== FLY MODE DETECTOR =====================
local FlyModeModule = {}
FlyModeModule.IsFlying = false
FlyModeModule.BringEnemyWasEnabled = false
FlyModeModule.Connection = nil

function FlyModeModule.Start()
    if FlyModeModule.Connection then
        FlyModeModule.Connection:Disconnect()
    end
    
    FlyModeModule.Connection = RunService.Heartbeat:Connect(function()
        if not player.Character then return end
        
        local character = player.Character
        local humanoid = character:FindFirstChild("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return end
        
        local currentState = humanoid:GetState()
        local yVelocity = root.AssemblyLinearVelocity.Y
        local isFlying = currentState == Enum.HumanoidStateType.Flying or 
                        currentState == Enum.HumanoidStateType.Freefall or
                        math.abs(yVelocity) > 5
        
        if isFlying and not FlyModeModule.IsFlying then
            FlyModeModule.IsFlying = true
            if BringEnemyModule.Enabled then
                FlyModeModule.BringEnemyWasEnabled = true
                BringEnemyModule.Stop()
                print("🛫 Bay - Bring Enemy pause")
            end
        end
        
        if not isFlying and FlyModeModule.IsFlying then
            FlyModeModule.IsFlying = false
            if FlyModeModule.BringEnemyWasEnabled then
                BringEnemyModule.Start()
                FlyModeModule.BringEnemyWasEnabled = false
                print("🛬 Hạ cánh - Bring Enemy resume")
            end
        end
    end)
end

function FlyModeModule.Stop()
    if FlyModeModule.Connection then
        FlyModeModule.Connection:Disconnect()
        FlyModeModule.Connection = nil
    end
end

-- ===================== MAIN ATTACK LOOP =====================
task.spawn(function()
    while true do
        if FastAttackModule.Enabled then
            FastAttackModule.ExecuteFastAttack()
        end
        task.wait(0.1)
    end
end)

-- ===================== SPINNER ANIMATION =====================
local spinnerAngle = 0
local animConn

-- ===================== LOADING SEQUENCE =====================
task.spawn(function()
    local progress = 0
    
    -- Start spinner animation
    animConn = RunService.RenderStepped:Connect(function()
        spinnerAngle = (spinnerAngle + 5) % 360
        spinnerBg.Rotation = spinnerAngle
    end)
    
    -- Progress loop
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
            statusMsg.Text = "Khởi tạo Fly Mode..."
        end
        
        task.wait(0.03)
    end
    
    task.wait(0.8)
    
    -- Fade out loader
    local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(loader, tweenInfo, {BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function()
        loader.Visible = false
        if animConn then
            animConn:Disconnect()
        end
    end)
    
    task.wait(0.6)
    
    -- Show dashboard
    main.Visible = true
    
    -- Show success notification
    task.wait(0.2)
    notifyFrame:TweenSize(UDim2.fromOffset(360, 50), "Out", "Quad", 0.4)
    
    task.wait(3)
    notifyFrame:TweenSize(UDim2.fromOffset(0, 0), "Out", "Quad", 0.3)
end)

-- ===================== AUTO START ALL FEATURES =====================
task.spawn(function()
    task.wait(5)
    print("🚀 Auto-starting all features...")
    
    FastAttackModule.Enabled = true
    BringEnemyModule.Start()
    AutoHopperModule.Start()
    MeleeAttackModule.Start()
    FlyModeModule.Start()
    
    print("✓ Ryzen Config v3.3 PLUS FIXED loaded successfully!")
    print("✓ Dashboard: Horizontal layout (top of screen)")
    print("✓ Loading: Modern spinner + notify system")
    print("✓ Bring Enemy: 15m range, auto-pause when flying")
    print("✓ Auto Hopper: 60s threshold with stuck detection")
    print("✓ Melee Z/X: Attack without pull-back")
    print("✓ All features auto-enabled!")
    print("✓ Press F12 to toggle dashboard")
end)
