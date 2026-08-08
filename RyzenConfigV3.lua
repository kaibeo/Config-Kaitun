--[[
    RYZEN CONFIG UI [Banana Kaitun] v3.2 - FIXED
    Made by Kaibeo | Server: discord.gg/fdyw76rTuD
    Đặt Script này là LocalScript bên trong StarterGui

    Đây là bảng thông tin (info dashboard) cho Roblox:
    - Avatar, Ping, FPS, Giờ, Ngày, TIME GAME
    - Ticker chữ chạy ngang
    - Loading screen animation
    - Nút bật/tắt UI ở góc TRÁI DƯỚI
    - TÍNH NĂNG TỰ BẬT: Fast Attack | Bring Enemy | Auto Hopper
    
    FIX:
    1. Auto Hopper hoạt động đúng - rejoin nếu stuck 60s
    2. Melee attack sử dụng Z/X để tránh bị kéo ngược khi bay
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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

-- ===================== LOADING SCREEN =====================
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

local glowRing = Instance.new("Frame")
glowRing.AnchorPoint = Vector2.new(0.5, 0.5)
glowRing.Position = UDim2.new(0.5, 0, 0.4, 0)
glowRing.Size = UDim2.fromOffset(120, 120)
glowRing.BackgroundColor3 = COL_RED
glowRing.BackgroundTransparency = 0.9
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
brandTitle.ZIndex = 101
brandTitle.Parent = loader

local brandSub = Instance.new("TextLabel")
brandSub.BackgroundTransparency = 1
brandSub.Size = UDim2.new(1, 0, 0, 24)
brandSub.Position = UDim2.new(0, 0, 0.49, 0)
brandSub.Text = "[ BANANA KAITUN ]"
brandSub.TextColor3 = COL_DIM
brandSub.Font = Enum.Font.GothamBold
brandSub.TextSize = 16
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

local barGlow = Instance.new("UIGradient")
barGlow.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COL_REDDIM),
    ColorSequenceKeypoint.new(1, COL_RED),
})
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
statusPct.ZIndex = 101
statusPct.Parent = loader

local verLabel = Instance.new("TextLabel")
verLabel.BackgroundTransparency = 1
verLabel.Size = UDim2.new(1, 0, 0, 18)
verLabel.Position = UDim2.new(0, 0, 0.92, 0)
verLabel.Text = "RYZEN CONFIG v3.2 FIXED — MADE BY KAIBEO"
verLabel.TextColor3 = COL_DIM
verLabel.Font = Enum.Font.Gotham
verLabel.TextSize = 11
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

-- ===================== MAIN FRAME =====================
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(300, 450)
main.Position = UDim2.new(0.5, -150, 0.5, -225)
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

-- ===== Ticker (marquee) =====
local tickerFrame = Instance.new("Frame")
tickerFrame.Name = "Ticker"
tickerFrame.Size = UDim2.new(1, 0, 0, 26)
tickerFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 7)
tickerFrame.BorderSizePixel = 0
tickerFrame.ClipsDescendants = true
tickerFrame.Parent = main
corner(tickerFrame, 14)

local tickerBottomLine = Instance.new("Frame")
tickerBottomLine.Size = UDim2.new(1, 0, 0, 1)
tickerBottomLine.Position = UDim2.new(0, 0, 1, -1)
tickerBottomLine.BackgroundColor3 = COL_REDDIM
tickerBottomLine.BorderSizePixel = 0
tickerBottomLine.Parent = tickerFrame

local tickerText = Instance.new("TextLabel")
tickerText.BackgroundTransparency = 1
tickerText.Size = UDim2.new(0, 700, 1, 0)
tickerText.Position = UDim2.new(0, 300, 0, 0)
tickerText.Text = "🎮 Config make by Kaibeo   •   Server: discord.gg/fdyw76rTuD   •   RYZEN CONFIG v3.2 FIXED [Banana Kaitun]   •   "
tickerText.TextColor3 = COL_DIM
tickerText.Font = Enum.Font.Gotham
tickerText.TextSize = 12
tickerText.Parent = tickerFrame

local function animateTicker()
    TweenService:Create(tickerText, TweenInfo.new(20, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
        Position = UDim2.new(0, -700, 0, 0)
    }):Play()
    
    task.wait(20)
    tickerText.Position = UDim2.new(0, 300, 0, 0)
    animateTicker()
end

task.spawn(animateTicker)

-- ===================== FAST ATTACK MODULE =====================
local FastAttackModule = {}
FastAttackModule.Enabled = false

function FastAttackModule.ExecuteFastAttack()
    local plr = game.Players.LocalPlayer
    local character = plr.Character
    
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    
    local hitRemote = game.ReplicatedStorage:FindFirstChild("HitPart")
    if not hitRemote then return end
    
    local targetParts = {}
    local targetFolder = workspace:FindFirstChild("Enemies")
    if not targetFolder then return end
    
    local targetCharacter = targetFolder:FindFirstChildOfClass("Model")
    if not targetCharacter then return end
    
    local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
    if not targetHumanoid or targetHumanoid.Health <= 0 then return end
    
    local targetHead = targetCharacter:FindFirstChild("Head")
    if not targetHead then return end
    
    local weaponFolder = character:FindFirstChild("Weapon")
    if not weaponFolder then return end
    
    for _, weapon in ipairs(weaponFolder:GetChildren()) do
        if weapon:FindFirstChild("Blade") or weapon:FindFirstChild("Handle") then
            local part = weapon:FindFirstChild("Blade") or weapon:FindFirstChild("Handle")
            if part then
                table.insert(targetParts, {part.Position, part, part.Name})
            end
        end
    end
    
    if #targetParts > 0 then
        task.wait(0.1)
        local targetParts = {
            {targetHead.Position, targetHead, "Head"}
        }
        
        targetParts[1][2] = targetHead
        hitRemote:FireServer(targetHead, targetParts)
    end
end

-- ===================== BRING ENEMY MODULE [FIXED] =====================
-- FIX: Chỉ hoạt động khi đứng trên đất, KHÔNG kéo lại khi bay
local BringEnemyModule = {}
BringEnemyModule.Enabled = false
BringEnemyModule.Connections = {}
BringEnemyModule.IsFlying = false

function BringEnemyModule.Start()
    if BringEnemyModule.Enabled then return end
    BringEnemyModule.Enabled = true
    
    local plr = game.Players.LocalPlayer
    local character = plr.Character
    if not character then return end
    
    local Root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not Root or not humanoid then return end
    
    for i, v in ipairs(BringEnemyModule.Connections) do
        v:Disconnect()
    end
    BringEnemyModule.Connections = {}
    
    local Enemies = workspace:FindFirstChild("Enemies")
    if not Enemies then return end
    
    local Mon = Enemies:FindFirstChildOfClass("Model")
    if not Mon then return end
    
    table.insert(BringEnemyModule.Connections, RunService.Heartbeat:Connect(function()
        if not BringEnemyModule.Enabled or not Mon then return end
        
        local mobHumanoid = Mon:FindFirstChild("Humanoid")
        if not mobHumanoid or mobHumanoid.Health <= 0 then
            BringEnemyModule.Stop()
            return
        end
        
        local mobRoot = Mon:FindFirstChild("HumanoidRootPart")
        
        -- FIX: Kiểm tra xem player đang bay hay không
        -- Nếu Y velocity lớn = đang bay/fall -> không bring enemy
        local playerYVelocity = Root.AssemblyLinearVelocity.Y
        local isPlayerFlying = humanoid:GetState() == Enum.HumanoidStateType.Flying or 
                               humanoid:GetState() == Enum.HumanoidStateType.Freefall or
                               math.abs(playerYVelocity) > 5
        
        if mobRoot then
            local dist = (mobRoot.Position - Root.Position).Magnitude
            local isEnemyNear = dist <= 15  -- Tăng từ 5 lên 15 (rộng hơn)
            
            -- CHỈ bring enemy khi player đứng trên đất (NOT flying)
            if isPlayerFlying then
                -- Đang bay: DỪNG bring, để enemy ở gần
                mobRoot.CanCollide = false
                -- Không kéo nữa
            else
                -- Đứng trên đất: bắt đầu bring
                if isEnemyNear then
                    -- Enemy đã gần: kéo theo phía trước (xa hơn)
                    mobRoot.CFrame = Root.CFrame + Root.CFrame.LookVector * 20  -- Tăng từ 10 lên 20
                    mobRoot.CanCollide = false
                else
                    -- Enemy ở xa: kéo đến player
                    mobRoot.CFrame = CFrame.new(Root.Position + Vector3.new(0, 3, 0))
                    mobRoot.CanCollide = false
                    mobHumanoid.WalkSpeed = 0
                    mobHumanoid.JumpPower = 0
                end
            end
        end
    end))
    
    print("✅ [BRING ENEMY] Start - Chỉ bring khi đứng trên đất, không bring khi bay")
end

function BringEnemyModule.Stop()
    BringEnemyModule.Enabled = false
    for i, v in ipairs(BringEnemyModule.Connections) do
        v:Disconnect()
    end
    BringEnemyModule.Connections = {}
    print("❌ [BRING ENEMY] Stop")
end

-- ===================== AUTO HOPPER MODULE [FIXED] =====================
local AutoHopperModule = {}
AutoHopperModule.Enabled = false
AutoHopperModule.Connection = nil
AutoHopperModule.IdleTime = 60
AutoHopperModule.AutoHop = true
AutoHopperModule.LastMovementTime = tick()
AutoHopperModule.StuckPosition = nil
AutoHopperModule.StuckCheckTime = tick()

local function getEmptyServers()
    local servers = {}
    local cursor = ""
    local placeId = game.PlaceId
    local HttpService = game:GetService("HttpService")
    
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
    print("🚀 [AUTO HOP] Phát hiện idle quá lâu hoặc bị stuck - tự động hop server...")
    local TeleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId
    local players = game:GetService("Players")
    local plr = players.LocalPlayer
    
    local servers = getEmptyServers()
    
    if #servers == 0 then
        print("⚠️  [AUTO HOP] Không tìm thấy server trống - rejoin server hiện tại")
        pcall(function()
            TeleportService:Teleport(placeId, plr)
        end)
        return false
    end
    
    local randomServer = servers[math.random(1, #servers)]
    print("🌍 [AUTO HOP] Hop sang server: " .. randomServer)
    
    pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, randomServer, plr)
    end)
    
    return true
end

function AutoHopperModule.Start()
    if AutoHopperModule.Enabled then return end
    AutoHopperModule.Enabled = true
    
    local plr = game.Players.LocalPlayer
    local character = plr.Character
    if not character then
        AutoHopperModule.Enabled = false
        return
    end
    
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
    
    print("✅ [AUTO HOP] Auto Hopper bắt đầu - sẽ tự động hop nếu đứng im " .. AutoHopperModule.IdleTime .. "s")
    
    AutoHopperModule.Connection = RunService.Heartbeat:Connect(function()
        if not AutoHopperModule.Enabled or not character.Parent or humanoid.Health <= 0 then
            AutoHopperModule.Stop()
            return
        end
        
        local currentPosition = humanoidRootPart.Position
        
        -- Kiểm tra xem character có bị stuck không (không di chuyển nhưng đang bay)
        local distanceFromLastCheck = (currentPosition - AutoHopperModule.StuckPosition).Magnitude
        local timeSinceLastCheck = tick() - AutoHopperModule.StuckCheckTime
        
        if timeSinceLastCheck >= 5 then
            if distanceFromLastCheck < 2 then
                -- Bị stuck - không di chuyển được
                local timeSinceLastMovement = tick() - AutoHopperModule.LastMovementTime
                if timeSinceLastMovement >= AutoHopperModule.IdleTime then
                    print("🔴 [AUTO HOP] Phát hiện stuck " .. math.floor(timeSinceLastMovement) .. "s - HOP NGAY!")
                    hopServer()
                    AutoHopperModule.LastMovementTime = tick()
                    return
                end
            else
                -- Đang di chuyển được
                AutoHopperModule.LastMovementTime = tick()
                AutoHopperModule.StuckPosition = currentPosition
            end
            
            AutoHopperModule.StuckCheckTime = tick()
        end
        
        -- Kiểm tra idle thông thường
        local elapsedSinceMovement = tick() - AutoHopperModule.LastMovementTime
        
        if AutoHopperModule.AutoHop and elapsedSinceMovement >= AutoHopperModule.IdleTime then
            print("🟡 [AUTO HOP] Đứng im " .. math.floor(elapsedSinceMovement) .. "s - HOP NGAY!")
            hopServer()
            AutoHopperModule.LastMovementTime = tick()
        end
    end)
end

function AutoHopperModule.Stop()
    AutoHopperModule.Enabled = false
    if AutoHopperModule.Connection then
        AutoHopperModule.Connection:Disconnect()
        AutoHopperModule.Connection = nil
    end
    print("❌ Auto Hopper dừng")
end

-- ===================== MELEE ATTACK Z/X FIX =====================
-- Sử dụng Z, X để attack - tránh bị kéo ngược khi bay
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
                print("⚔️  [MELEE] Attack từ Z/X")
            end
        end
    end
end)

function MeleeAttackModule.Start()
    MeleeAttackModule.Enabled = true
    print("✅ Melee Z/X Attack: ON")
end

function MeleeAttackModule.Stop()
    MeleeAttackModule.Enabled = false
    print("❌ Melee Z/X Attack: OFF")
end

-- ===================== FLY MODE DETECTOR =====================
-- Tự động pause Bring Enemy khi bay, resume khi hạ cánh
local FlyModeModule = {}
FlyModeModule.IsFlying = false
FlyModeModule.BringEnemyWasEnabled = false
FlyModeModule.Connection = nil

function FlyModeModule.Start()
    if FlyModeModule.Connection then
        FlyModeModule.Connection:Disconnect()
    end
    
    FlyModeModule.Connection = RunService.Heartbeat:Connect(function()
        local plr = game.Players.LocalPlayer
        local character = plr.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return end
        
        -- Detect flying state
        local currentState = humanoid:GetState()
        local yVelocity = root.AssemblyLinearVelocity.Y
        local isFlying = currentState == Enum.HumanoidStateType.Flying or 
                        currentState == Enum.HumanoidStateType.Freefall or
                        math.abs(yVelocity) > 5
        
        -- State change: ground -> flying
        if isFlying and not FlyModeModule.IsFlying then
            FlyModeModule.IsFlying = true
            if BringEnemyModule.Enabled then
                FlyModeModule.BringEnemyWasEnabled = true
                BringEnemyModule.Stop()
                print("🛫 [FLY MODE] Bay lên - tạm dừng Bring Enemy")
            end
        end
        
        -- State change: flying -> ground
        if not isFlying and FlyModeModule.IsFlying then
            FlyModeModule.IsFlying = false
            if FlyModeModule.BringEnemyWasEnabled then
                BringEnemyModule.Start()
                FlyModeModule.BringEnemyWasEnabled = false
                print("🛬 [FLY MODE] Hạ cánh - bật lại Bring Enemy")
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

-- ===================== AUTO START ALL FEATURES =====================
task.spawn(function()
    task.wait(3)
    
    print("🚀 Tự động khởi chạy tất cả tính năng...")
    
    -- Bật Fast Attack
    FastAttackModule.Enabled = true
    print("✅ Fast Attack: ON")
    
    -- Bật Bring Enemy
    BringEnemyModule.Start()
    print("✅ Bring Enemy: ON")
    
    -- Bật Auto Hopper
    AutoHopperModule.Start()
    print("✅ Auto Hopper: ON")
    
    -- Bật Melee Z/X
    MeleeAttackModule.Start()
    print("✅ Melee Z/X Attack: ON")
    
    -- Bật FLY MODE (tự động pause/resume Bring Enemy)
    FlyModeModule.Start()
    print("✅ Fly Mode Detector: ON")
    
    print("🎯 Tất cả tính năng đã bật!")
end)

print("✓ Ryzen Config v3.2 FIXED loaded successfully!")
print("✓ Features: Dashboard | Fast Attack | Bring Enemy | Auto Hopper | Melee Z/X | Fly Mode | Time Game")
print("✓ Hotkey: Right Control to toggle UI")
print("✓ Auto Hopper: Tự động hop server nếu đứng im > 60 giây HOẶC bị stuck")
print("✓ Melee Z/X: Nhấn Z hoặc X để attack mà không bị kéo ngược")
print("✓ Fly Mode: Tự động pause Bring Enemy khi bay, resume khi hạ cánh")
print("✓ Bring Enemy: Chỉ hoạt động khi đứng trên đất, NOT hoạt động khi bay")
print("✓ Tất cả tính năng sẽ TỰ ĐỘNG BẬT sau 3 giây!")

-- ===================== LOAD BANANA CAT SCRIPT =====================
task.spawn(function()
    task.wait(2)
    print("🍌 Đang tải Banana Cat script...")
    local success, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaCat-kaitunBF.lua")
    end)
    
    if success then
        print("✅ Banana Cat script loaded!")
        pcall(function()
            loadstring(result)()
        end)
    else
        print("⚠️  Không thể tải Banana Cat script: " .. tostring(result))
    end
end)
