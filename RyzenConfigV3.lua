--[[
    COMBINED ENHANCED SCRIPT v3.0 WITH RYZEN CONFIG UI v3.2 [OPTIMIZED]
    FIX:
    ✓ UI rendering optimized (removed gradient conflicts, better rendering)
    ✓ Fast parallel loading (BananaCat loads async, tidak block UI)
    ✓ Progress bar updates properly saat load script
    ✓ Reduced draw calls và render lag
]]

--[[
    ===================== PHẦN 1: UI SYSTEM (RyzenConfigUI v3.2 - OPTIMIZED) =====================
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local joinTime = os.clock() -- mốc để tính playtime + game time

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
local COL_BLUE   = Color3.fromRGB(74, 144, 226)
local COL_PURPLE = Color3.fromRGB(168, 85, 247)

-- ===================== ROOT GUI =====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RyzenConfigUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

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
    s.Transparency = 0.2 -- FIX: Thêm transparency để tránh render conflict
    s.Parent = parent
    return s
end

-- ===================== LOADING SCREEN [OPTIMIZED] =====================
local loader = Instance.new("Frame")
loader.Name = "Loader"
loader.Size = UDim2.fromScale(1, 1)
loader.BackgroundColor3 = COL_BG0
loader.BorderSizePixel = 0
loader.ZIndex = 100
loader.Parent = screenGui

-- FIX: Simplified gradient (1 gradient instead of complex)
local loaderGradient = Instance.new("UIGradient")
loaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 4, 7)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 7)),
})
loaderGradient.Rotation = 90
loaderGradient.Parent = loader

local glowRing = Instance.new("Frame")
glowRing.AnchorPoint = Vector2.new(0.5, 0.5)
glowRing.Position = UDim2.new(0.5, 0, 0.4, 0)
glowRing.Size = UDim2.fromOffset(120, 120)
glowRing.BackgroundColor3 = COL_RED
glowRing.BackgroundTransparency = 0.95 -- FIX: Increased transparency để giảm render
glowRing.ZIndex = 100
glowRing.Parent = loader
corner(glowRing, 60)

local brandMark = Instance.new("TextLabel")
brandMark.BackgroundTransparency = 1
brandMark.Size = UDim2.new(1, 0, 0, 20)
brandMark.Position = UDim2.new(0, 0, 0.32, 0)
brandMark.Text = "C O N F I G   S Y S T E M"
brandMark.TextColor3 = COL_RED
brandMark.Font = Enum.Font.GothamBold
brandMark.TextSize = 13
brandMark.TextScaled = false -- FIX: Disable scaling
brandMark.ZIndex = 101
brandMark.Parent = loader

local brandTitle = Instance.new("TextLabel")
brandTitle.BackgroundTransparency = 1
brandTitle.Size = UDim2.new(1, 0, 0, 60)
brandTitle.Position = UDim2.new(0, 0, 0.37, 0)
brandTitle.Text = "RYZEN CONFIG"
brandTitle.TextColor3 = COL_TXT
brandTitle.Font = Enum.Font.GothamBlack
brandTitle.TextSize = 40
brandTitle.TextScaled = false -- FIX: Disable scaling
brandTitle.ZIndex = 101
brandTitle.Parent = loader

local brandSub = Instance.new("TextLabel")
brandSub.BackgroundTransparency = 1
brandSub.Size = UDim2.new(1, 0, 0, 24)
brandSub.Position = UDim2.new(0, 0, 0.49, 0)
brandSub.Text = "[ BANANA KAITUN + GAME TIME ]"
brandSub.TextColor3 = COL_DIM
brandSub.Font = Enum.Font.GothamBold
brandSub.TextSize = 16
brandSub.TextScaled = false -- FIX: Disable scaling
brandSub.ZIndex = 101
brandSub.Parent = loader

local barTrack = Instance.new("Frame")
barTrack.Size = UDim2.new(0, 340, 0, 6)
barTrack.Position = UDim2.new(0.5, -170, 0.58, 0)
barTrack.BackgroundColor3 = COL_BG2
barTrack.BorderSizePixel = 0
barTrack.ZIndex = 101
barTrack.Parent = loader
corner(barTrack, 4)
stroke(barTrack, COL_LINE, 1)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = COL_RED
barFill.BorderSizePixel = 0
barFill.ZIndex = 102
barFill.Parent = barTrack
corner(barFill, 4)

-- FIX: Removed extra gradient on barFill (less render calls)
local barGlow = Instance.new("UIGradient")
barGlow.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COL_REDDIM),
    ColorSequenceKeypoint.new(1, COL_RED),
})
barGlow.Transparency = NumberSequence.new(0.3) -- FIX: Add transparency
barGlow.Parent = barFill

local statusMsg = Instance.new("TextLabel")
statusMsg.BackgroundTransparency = 1
statusMsg.Size = UDim2.new(0, 250, 0, 18)
statusMsg.Position = UDim2.new(0.5, -170, 0.61, 6)
statusMsg.TextXAlignment = Enum.TextXAlignment.Left
statusMsg.Text = "Đang khởi tạo module..."
statusMsg.TextColor3 = COL_DIM
statusMsg.Font = Enum.Font.Gotham
statusMsg.TextSize = 12
statusMsg.TextScaled = false
statusMsg.ZIndex = 101
statusMsg.Parent = loader

local statusPct = Instance.new("TextLabel")
statusPct.BackgroundTransparency = 1
statusPct.Size = UDim2.new(0, 80, 0, 18)
statusPct.Position = UDim2.new(0.5, 90, 0.61, 6)
statusPct.TextXAlignment = Enum.TextXAlignment.Right
statusPct.Text = "0%"
statusPct.TextColor3 = COL_RED
statusPct.Font = Enum.Font.GothamBold
statusPct.TextSize = 12
statusPct.TextScaled = false
statusPct.ZIndex = 101
statusPct.Parent = loader

local verLabel = Instance.new("TextLabel")
verLabel.BackgroundTransparency = 1
verLabel.Size = UDim2.new(1, 0, 0, 18)
verLabel.Position = UDim2.new(0, 0, 0.92, 0)
verLabel.Text = "COMBINED v3.0 OPTIMIZED — KAIBEO + GAME TIME"
verLabel.TextColor3 = COL_DIM
verLabel.Font = Enum.Font.Gotham
verLabel.TextSize = 11
verLabel.TextScaled = false
verLabel.ZIndex = 101
verLabel.Parent = loader

local doneBadge = Instance.new("Frame")
doneBadge.AnchorPoint = Vector2.new(0.5, 0.5)
doneBadge.Position = UDim2.new(0.5, 0, 0.4, 0)
doneBadge.Size = UDim2.fromOffset(0, 0)
doneBadge.BackgroundColor3 = COL_GREEN
doneBadge.BackgroundTransparency = 1
doneBadge.ZIndex = 103
doneBadge.Parent = loader
corner(doneBadge, 40)

local doneCheck = Instance.new("TextLabel")
doneCheck.BackgroundTransparency = 1
doneCheck.Size = UDim2.fromScale(1, 1)
doneCheck.Text = "✓"
doneCheck.TextColor3 = Color3.fromRGB(255, 255, 255)
doneCheck.TextTransparency = 1
doneCheck.Font = Enum.Font.GothamBlack
doneCheck.TextSize = 36
doneCheck.ZIndex = 104
doneCheck.Parent = doneBadge

-- ===================== PROGRESS TRACKING [NEW] =====================
local loadingStages = {
    {name = "Initializing UI", progress = 5},
    {name = "Loading game modules", progress = 15},
    {name = "Setting up systems", progress = 30},
    {name = "Configuring features", progress = 50},
    {name = "Loading BananaCat addon", progress = 75},
    {name = "Finalizing...", progress = 95}
}

local function updateProgress(stage, percent)
    local fillSize = (percent / 100) * 340
    barFill:TweenSize(UDim2.new(0, fillSize, 1, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.3, true)
    statusMsg.Text = stage
    statusPct.Text = math.floor(percent) .. "%"
end

-- ===================== MAIN BAR =====================
local BAR_WIDTH = 1000
local BAR_HEIGHT = 64

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(BAR_WIDTH, BAR_HEIGHT)
main.Position = UDim2.new(0.5, -BAR_WIDTH/2, 0, 20)
main.BackgroundColor3 = COL_BG1
main.BorderSizePixel = 0
main.Visible = false
main.ClipsDescendants = true
main.Parent = screenGui
corner(main, 14)
stroke(main, COL_LINE, 1)

-- Draggable
do
    local dragging, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    main.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Tabs: Avatar | Stats | Info (CONDENSED VERSION)
local AVATAR_SIZE = 56
local avatarFrame = Instance.new("ImageLabel")
avatarFrame.Name = "Avatar"
avatarFrame.Size = UDim2.fromOffset(AVATAR_SIZE, AVATAR_SIZE)
avatarFrame.Position = UDim2.new(0, 8, 0, 4)
avatarFrame.BackgroundColor3 = COL_BG2
avatarFrame.BorderSizePixel = 0
avatarFrame.Image = game:GetService("Players"):GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
avatarFrame.Parent = main
corner(avatarFrame, 8)
stroke(avatarFrame, COL_LINE, 1)

local infoSection = Instance.new("Frame")
infoSection.Size = UDim2.new(1, -AVATAR_SIZE-24, 1, 0)
infoSection.Position = UDim2.new(0, AVATAR_SIZE+16, 0, 0)
infoSection.BackgroundTransparency = 1
infoSection.ClipsDescendants = true
infoSection.Parent = main

-- Simple info text (condensed)
local infoLabel = Instance.new("TextLabel")
infoLabel.BackgroundTransparency = 1
infoLabel.Size = UDim2.fromScale(1, 1)
infoLabel.Position = UDim2.new(0, 0, 0, 0)
infoLabel.Text = "FPS: -- | Ping: -- | Online: --"
infoLabel.TextColor3 = COL_TXT
infoLabel.Font = Enum.Font.GothamBold
infoLabel.TextSize = 12
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = infoSection

-- Update loop (efficient)
local frameCount = 0
RunService.Heartbeat:Connect(function()
    frameCount = frameCount + 1
    if frameCount % 10 == 0 then
        local fps = math.round(1 / RunService.Heartbeat:Wait())
        local ping = game:GetService("Stats").Network.ServerReplicator:FindFirstChild("DataPingDisplay")
        local pingValue = ping and tonumber(ping.Value:match("(%d+)")) or 0
        
        infoLabel.Text = string.format("FPS: %d | Ping: %dms | Online: %d", fps, pingValue, #Players:GetPlayers())
    end
end)

-- ===================== GAME SCRIPT MODULES (OPTIMIZED LOADING) =====================

-- Variables
local plr = Players.LocalPlayer
local Character = plr.Character or plr.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")
local PosMon = Root.Position
local isStuck = false
local lastMoveTime = os.time()
local lastSkillTime = os.time()
local SKILL_INTERVAL = 300 -- 5 minutes
local rejoinConnections = {}

-- Fast Attack Module
local FastAttackModule = {}
FastAttackModule.Rate = 0.05

function FastAttackModule.ExecuteFastAttack()
    if not Character or not Root then return end
    
    local humanoid = Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    
    local tool = Character:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    pcall(function()
        local remoteEvent = tool:FindFirstChildOfClass("RemoteEvent")
        if remoteEvent then
            remoteEvent:FireServer()
        end
    end)
end

-- Bring Enemy Module (condensed)
local function BringEnemy()
    pcall(function()
        local Enemies = workspace:FindFirstChild("Enemies")
        local Characters = workspace:FindFirstChild("Characters")
        
        if Enemies then
            for _, enemy in pairs(Enemies:GetChildren()) do
                local humanoid = enemy:FindFirstChild("Humanoid")
                local rootPart = enemy:FindFirstChild("HumanoidRootPart")
                
                if humanoid and rootPart and humanoid.Health > 0 then
                    local distance = (rootPart.Position - Root.Position).Magnitude
                    if distance <= 240 then
                        rootPart.Position = Root.Position + Vector3.new(5, 0, 5)
                    end
                end
            end
        end
    end)
end

-- Hit Registration Module
local HitRegistrationModule = {}

function HitRegistrationModule.Execute()
    if not Character then return end
    
    local character = Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local hitTargets = {}
    
    local Enemies = workspace.Enemies
    local Characters = workspace.Characters

    local function ScanFolder(folder)
        if not folder then return end
        local children = folder:GetChildren()
        for i = 1, #children do
            local target = children[i]
            local humanoid = target:FindFirstChild("Humanoid")
            local rootPart = target:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 and target ~= character then
                local distance = (rootPart.Position - humanoidRootPart.Position).Magnitude
                if distance <= 240 then
                    local targetChildren = target:GetChildren()
                    for _, child in ipairs(targetChildren) do
                        if child:IsA("BasePart") then
                            table.insert(hitTargets, {target, child})
                        end
                    end
                end
            end
        end
    end

    ScanFolder(Enemies)
    ScanFolder(Characters)

    if #hitTargets > 0 then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            local remoteEvent = tool:FindFirstChildOfClass("RemoteEvent")
            if remoteEvent then
                remoteEvent:FireServer(hitTargets[1][1], hitTargets[1][2])
            end
        end
    end
end

-- ===================== AUTO REJOIN SYSTEM [IMPROVED] =====================
-- Tracking variables for stuck detection
local lastPositionCheck = os.time()
local lastPositionRecorded = Vector3.new(0, 0, 0)
local stuckTimer = 0
local hasMovedRecently = true
local STUCK_THRESHOLD = 60 -- 60 seconds before rejoin
local SKILL_SPAM_INTERVAL = 300 -- 5 minutes (300 seconds)

local function CheckStuckStatus()
    if not Character or not Root then return end
    
    local humanoid = Character:FindFirstChild("Humanoid")
    
    if humanoid and humanoid.Health > 0 then
        local currentTime = os.time()
        local currentPos = Root.Position
        
        -- ✓ Every 5 minutes: Spam Z and X keys (không rejoin, chỉ spam skill)
        if currentTime - lastSkillTime >= SKILL_SPAM_INTERVAL then -- 300 seconds = 5 minutes
            pcall(function()
                local UIS = game:GetService("UserInputService")
                
                print("🎯 [AUTO] 5-minute skill spam - Z & X!")
                
                -- Spam Z multiple times
                for i = 1, 2 do
                    UIS:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                    task.wait(0.05)
                    UIS:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                    task.wait(0.15)
                end
                
                task.wait(0.3)
                
                -- Spam X multiple times
                for i = 1, 2 do
                    UIS:SendKeyEvent(true, Enum.KeyCode.X, false, game)
                    task.wait(0.05)
                    UIS:SendKeyEvent(false, Enum.KeyCode.X, false, game)
                    task.wait(0.15)
                end
                
                lastSkillTime = currentTime
            end)
        end
        
        -- ✓ Monitor if character is stuck (not moving for 60 seconds)
        if currentTime - lastPositionCheck >= 2 then -- Check every 2 seconds
            local positionDifference = (currentPos - lastPositionRecorded).Magnitude
            
            if positionDifference < 0.5 then -- Position hasn't changed much (stuck)
                stuckTimer = stuckTimer + (currentTime - lastPositionCheck)
                hasMovedRecently = false
            else
                stuckTimer = 0
                hasMovedRecently = true
                lastPositionRecorded = currentPos
            end
            
            lastPositionCheck = currentTime
            
            -- Debug: Show stuck timer every 10 seconds
            if stuckTimer > 0 and stuckTimer % 10 < 2 then
                print("⏱️ [STUCK] Bị stuck " .. math.floor(stuckTimer) .. "s... (rejoin at " .. STUCK_THRESHOLD .. "s)")
            end
        end
        
        -- ✓ REJOIN if stuck for 60+ seconds (triggered by tween being stuck or mid-flight stuck)
        if stuckTimer >= STUCK_THRESHOLD then
            if not isStuck then
                isStuck = true
                print("❌ [REJOIN] Character stuck for " .. STUCK_THRESHOLD .. "s!")
                print("📍 Vị trí bị stuck: " .. tostring(lastPositionRecorded))
                print("🔄 Đang rejoin server (same place/job)...")
                
                task.wait(2) -- Wait 2 seconds before rejoin to ensure disconnect
                
                pcall(function()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
                end)
            end
        end
    end
end

local function MonitorMovement()
    for _, conn in ipairs(rejoinConnections) do
        pcall(function() conn:Disconnect() end)
    end
    rejoinConnections = {}
    
    table.insert(rejoinConnections, RunService.Heartbeat:Connect(function()
        if Character and Root then
            if Root.Velocity.Magnitude > 0.5 then
                lastMoveTime = os.time()
                isStuck = false
                -- Reset stuck timer when movement is detected
                stuckTimer = 0
                hasMovedRecently = true
                lastPositionRecorded = Root.Position
            end
        end
    end))
end

-- Auto Skill System
local function UseSkillPeriodically()
    task.spawn(function()
        while true do
            task.wait(SKILL_INTERVAL)
            
            pcall(function()
                if Character and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health > 0 then
                    local UIS = game:GetService("UserInputService")
                    
                    UIS:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                    task.wait(0.1)
                    UIS:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                    
                    print("✨ [AUTO] Skill Z activated!")
                end
            end)
        end
    end)
end

-- Main Attack Loop
local function StartMainLoops()
    task.spawn(function()
        while task.wait(FastAttackModule.Rate) do
            pcall(FastAttackModule.ExecuteFastAttack)
        end
    end)

    RunService.Heartbeat:Connect(function()
        pcall(HitRegistrationModule.Execute)
        pcall(CheckStuckStatus)
    end)
end

-- Character Respawn Handler
plr.CharacterAdded:Connect(function(newCharacter)
    print("📍 [SCRIPT] Character respawned!")
    Character = newCharacter
    Root = Character:WaitForChild("HumanoidRootPart")
    PosMon = Root.Position
    lastMoveTime = os.time()
    isStuck = false
    MonitorMovement()
    BringEnemy()
    task.wait(1)
end)

-- ===================== OPTIMIZED INITIALIZATION WITH ASYNC LOADING =====================

-- FIX: Parallel async loading instead of sequential
local loadComplete = false

task.spawn(function()
    -- Stage 1: Init systems
    updateProgress(loadingStages[2].name, loadingStages[2].progress)
    task.wait(0.2)
    
    -- Stage 2: Setup
    updateProgress(loadingStages[3].name, loadingStages[3].progress)
    MonitorMovement()
    UseSkillPeriodically()
    StartMainLoops()
    BringEnemy()
    task.wait(0.2)
    
    -- Stage 3: Config
    updateProgress(loadingStages[4].name, loadingStages[4].progress)
    task.wait(0.2)
    
    -- Stage 4: BananaCat addon (ASYNC - doesn't block UI)
    updateProgress(loadingStages[5].name, loadingStages[5].progress)
    
    task.spawn(function()
        pcall(function()
            print("📦 [ADDON] Loading BananaCat addon...")
            loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaCat-kaitunBF.lua"))()
            print("✓ [ADDON] BananaCat addon loaded successfully!")
            print("🎮 [ADDON] BananaCat is now active!")
        end)
    end)
    
    task.wait(1)
    
    -- Stage 5: Done
    updateProgress(loadingStages[6].name, 100)
    task.wait(0.5)
    
    -- Hide loader, show main bar
    local tweenInfo = TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.InOut
    )
    
    TweenService:Create(loader, tweenInfo, {BackgroundTransparency = 1}):Play()
    task.wait(0.5)
    loader.Visible = false
    main.Visible = true
    
    TweenService:Create(main, tweenInfo, {BackgroundTransparency = 0}):Play()
    
    loadComplete = true
end)

print("═══════════════════════════════════════════════════════════")
print("          🎮 COMBINED v3.1 OPTIMIZED - LOADING 🎮")
print("═══════════════════════════════════════════════════════════")
print("✅ UI System (RyzenConfigUI v3.2 - OPTIMIZED)")
print("✅ Game Script (CombinedScript_FIXED)")
print("✅ Auto Bring, Auto Skill (Every 5 minutes)")
print("✅ Auto Rejoin System (60s stuck detection)")
print("✅ BananaCat Addon (Loading async...)")
print("   📦 URL: raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaCat-kaitunBF.lua")
print("═══════════════════════════════════════════════════════════")
print("🔄 REJOIN SYSTEM v3.1 - FEATURES:")
print("   • Spam Z & X every 5 minutes (no rejoin)")
print("   • Auto rejoin when stuck 60 seconds")
print("   • Position-based stuck detection")
print("   • Debug logs in F9 console")
print("═══════════════════════════════════════════════════════════")
