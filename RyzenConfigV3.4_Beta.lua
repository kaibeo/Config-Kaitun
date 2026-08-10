--[[
    RYZEN CONFIG UI [Banana Kaitun] v3.4
    Made by Kaibeo | Server: discord.gg/fdyw76rTuD
    Đặt Script này là LocalScript bên trong StarterGui

    Đây là bảng thông tin (info dashboard) cho Roblox:
    - Avatar, Ping, FPS, Giờ, Ngày, TIME GAME
    - Ticker chữ chạy ngang
    - Loading screen animation
    - Nút bật/tắt UI ở góc TRÁI DƯỚI
    - TÍNH NĂNG TỰ BẬT: Fast Attack | Bring Enemy | Auto Hopper | Auto Farm | Auto Rejoin
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
verLabel.Text = "RYZEN CONFIG v3.4 — MADE BY KAIBEO"
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
tickerText.Text = "🎮 Config make by Kaibeo   •   Server: discord.gg/fdyw76rTuD   •   RYZEN CONFIG v3.4 [Banana Kaitun]   •   "
tickerText.TextColor3 = COL_DIM
tickerText.Font = Enum.Font.Gotham
tickerText.TextSize = 11
tickerText.Parent = tickerFrame

task.spawn(function()
    while true do
        for i = 300, -700, -2 do
            tickerText.Position = UDim2.new(0, i, 0, 0)
            task.wait(0.02)
        end
    end
end)

-- ===== Dashboard header =====
local headerLabel = Instance.new("TextLabel")
headerLabel.BackgroundTransparency = 1
headerLabel.Size = UDim2.new(1, 0, 0, 24)
headerLabel.Position = UDim2.new(0, 0, 0, 26)
headerLabel.Text = "📊 DASHBOARD"
headerLabel.TextColor3 = COL_TXT
headerLabel.Font = Enum.Font.GothamBold
headerLabel.TextSize = 12
headerLabel.Parent = main

-- ===== Dashboard items =====
local dashContainer = Instance.new("Frame")
dashContainer.Name = "DashContainer"
dashContainer.Size = UDim2.new(1, -16, 1, -200)
dashContainer.Position = UDim2.new(0, 8, 0, 50)
dashContainer.BackgroundTransparency = 1
dashContainer.Parent = main

local dashList = Instance.new("UIListLayout")
dashList.Padding = UDim.new(0, 6)
dashList.FillDirection = Enum.FillDirection.Vertical
dashList.Parent = dashContainer

local dashItems = {}

-- Function to create dashboard item
local function createDashItem(title, defaultValue)
    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, 0, 0, 30)
    item.BackgroundColor3 = COL_BG2
    item.BorderSizePixel = 0
    item.Parent = dashContainer
    corner(item, 8)
    stroke(item, COL_LINE, 1)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(0, 140, 1, 0)
    titleLabel.Text = title
    titleLabel.TextColor3 = COL_DIM
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.TextSize = 11
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = item

    local valueLabel = Instance.new("TextLabel")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(0, 100, 1, 0)
    valueLabel.Position = UDim2.new(1, -100, 0, 0)
    valueLabel.Text = defaultValue
    valueLabel.TextColor3 = COL_GREEN
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = item

    return valueLabel
end

dashItems.Avatar = createDashItem("👤 Avatar", player.Name)
dashItems.Ping = createDashItem("📶 Ping", "0 ms")
dashItems.FPS = createDashItem("🎮 FPS", "0")
dashItems.Time = createDashItem("🕐 Time", "00:00:00")
dashItems.GameTime = createDashItem("⏱️ Game Time", "00:00:00")

-- Update dashboard
local startTime = tick()
task.spawn(function()
    while true do
        -- Ping
        if game:GetService("Stats") then
            local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            dashItems.Ping.Text = ping .. " ms"
        end

        -- FPS
        local fps = math.floor(1 / RunService.Heartbeat:Wait())
        dashItems.FPS.Text = fps

        -- Real Time
        local now = os.date("*t")
        dashItems.Time.Text = string.format("%02d:%02d:%02d", now.hour, now.min, now.sec)

        -- Game Time
        local elapsed = math.floor(tick() - startTime)
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = elapsed % 60
        dashItems.GameTime.Text = string.format("%02d:%02d:%02d", hours, minutes, seconds)

        task.wait(0.5)
    end
end)

-- ===== Features section =====
local featureLabel = Instance.new("TextLabel")
featureLabel.BackgroundTransparency = 1
featureLabel.Size = UDim2.new(1, 0, 0, 20)
featureLabel.Position = UDim2.new(0, 8, 1, -120)
featureLabel.Text = "⚙️ FEATURES"
featureLabel.TextColor3 = COL_TXT
featureLabel.Font = Enum.Font.GothamBold
featureLabel.TextSize = 11
featureLabel.TextXAlignment = Enum.TextXAlignment.Left
featureLabel.Parent = main

-- Feature buttons
local featureContainer = Instance.new("Frame")
featureContainer.Name = "FeatureContainer"
featureContainer.Size = UDim2.new(1, -16, 0, 80)
featureContainer.Position = UDim2.new(0, 8, 1, -100)
featureContainer.BackgroundTransparency = 1
featureContainer.Parent = main

local featureGrid = Instance.new("UIGridLayout")
featureGrid.CellSize = UDim2.new(0.5, -3, 0, 38)
featureGrid.CellPadding = UDim2.new(0, 6, 0, 6)
featureGrid.FillDirection = Enum.FillDirection.Horizontal
featureGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
featureGrid.Parent = featureContainer

-- Function to create feature button
local function createFeatureBtn(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = COL_BG2
    btn.TextColor3 = COL_DIM
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Text = name
    btn.Parent = featureContainer
    corner(btn, 8)
    stroke(btn, COL_LINE, 1)

    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = COL_BG0
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = COL_BG2
    end)

    return btn
end

-- ===================== FAST ATTACK MODULE =====================
local FastAttackModule = {}
FastAttackModule.Enabled = false

function FastAttackModule.ExecuteFastAttack()
    if not FastAttackModule.Enabled then return end

    local plr = game.Players.LocalPlayer
    if not plr or not plr.Character then return end

    local character = plr.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local remotes = character:FindFirstChild("Remotes")
    if not remotes then return end

    local hitRemote = remotes:FindFirstChild("Hit")
    if not hitRemote then return end

    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return end

    local targetParts = {}
    local closestEnemy = nil
    local closestDistance = 100

    for _, enemy in ipairs(enemies:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") then
            local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
            if enemyRoot and enemy.Humanoid.Health > 0 then
                local distance = (humanoidRootPart.Position - enemyRoot.Position).Magnitude

                if distance < closestDistance then
                    closestDistance = distance
                    closestEnemy = enemy
                end
            end
        end
    end

    if closestEnemy then
        for _, part in ipairs(closestEnemy:GetDescendants()) do
            if part:IsA("BasePart") and part.Parent == closestEnemy then
                table.insert(targetParts, {part.Name, part})
            end
        end

        if #targetParts > 0 then
            local targetHead = targetParts[1][2]
            hitRemote:FireServer(targetHead, targetParts)
        end
    end
end

-- ===================== BRING ENEMY MODULE =====================
local BringEnemyModule = {}
BringEnemyModule.Enabled = false
BringEnemyModule.Connections = {}

function BringEnemyModule.Start()
    if BringEnemyModule.Enabled then return end
    BringEnemyModule.Enabled = true

    local plr = game.Players.LocalPlayer
    local character = plr.Character
    if not character then return end

    local Root = character:FindFirstChild("HumanoidRootPart")
    if not Root then return end

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

        local humanoid = Mon:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            BringEnemyModule.Stop()
            return
        end

        local root = Mon:FindFirstChild("HumanoidRootPart")
        local hum = humanoid

        if root and hum then
            local dist = (root.Position - Root.Position).Magnitude
            local AreaMob = dist <= 5

            if AreaMob then
                root.CFrame = Root.CFrame + Root.CFrame.LookVector * 10
            else
                root.CFrame = CFrame.new(Root.Position)
                root.CanCollide = false
                hum.WalkSpeed = 0
                hum.JumpPower = 0
            end
        end
    end))
end

function BringEnemyModule.Stop()
    BringEnemyModule.Enabled = false
    for i, v in ipairs(BringEnemyModule.Connections) do
        v:Disconnect()
    end
    BringEnemyModule.Connections = {}
end

-- ===================== AUTO HOPPER MODULE =====================
local AutoHopperModule = {}
AutoHopperModule.Enabled = false
AutoHopperModule.Connection = nil
AutoHopperModule.IdleTime = 60
AutoHopperModule.AutoHop = true

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
    print("🚀 Phát hiện idle quá lâu - tự động hop server...")
    local TeleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId
    local players = game:GetService("Players")
    local plr = players.LocalPlayer

    local servers = getEmptyServers()

    if #servers == 0 then
        print("⚠️  Không tìm thấy server trống")
        return false
    end

    local randomServer = servers[math.random(1, #servers)]
    print("🌍 Hop sang server: " .. randomServer)

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

    local lastPosition = humanoidRootPart.Position
    local idleStartTime = tick()

    if AutoHopperModule.Connection then
        AutoHopperModule.Connection:Disconnect()
    end

    print("✅ Auto Hopper bắt đầu - sẽ tự động hop nếu đứng im " .. AutoHopperModule.IdleTime .. "s")

    AutoHopperModule.Connection = RunService.Heartbeat:Connect(function()
        if not AutoHopperModule.Enabled or not character.Parent or humanoid.Health <= 0 then
            AutoHopperModule.Stop()
            return
        end

        local currentPosition = humanoidRootPart.Position
        local distanceMoved = (currentPosition - lastPosition).Magnitude

        if distanceMoved > 0.5 then
            lastPosition = currentPosition
            idleStartTime = tick()
        end

        local elapsedIdle = tick() - idleStartTime

        if AutoHopperModule.AutoHop and elapsedIdle >= AutoHopperModule.IdleTime then
            hopServer()
            idleStartTime = tick()
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

-- ===================== AUTO FARM MODULE =====================
local AutoFarmModule = {}
AutoFarmModule.Enabled = false
AutoFarmModule.Config = {
    ABILITY_KEY_1 = "z",
    ABILITY_KEY_2 = "x",
    INTERVAL = 300,
    RANDOM_OFFSET = 30
}
AutoFarmModule.ActionCount = 0

local function pressKey(key)
    local keyCode = Enum.KeyCode[key:upper()]
    if keyCode then
        UserInputService:SendKeyEvent(true, keyCode, false)
        wait(0.1)
        UserInputService:SendKeyEvent(false, keyCode, false)
        return true
    end
    return false
end

local function getRandomOffset()
    return math.random(-AutoFarmModule.Config.RANDOM_OFFSET, AutoFarmModule.Config.RANDOM_OFFSET)
end

function AutoFarmModule.Start()
    if AutoFarmModule.Enabled then return end
    AutoFarmModule.Enabled = true
    AutoFarmModule.ActionCount = 0

    print("✅ Auto Farm Script Started")
    print("⚙️ Interval: " .. AutoFarmModule.Config.INTERVAL .. " seconds (5 minutes)")
    print("🎮 Keys: " .. AutoFarmModule.Config.ABILITY_KEY_1:upper() .. " / " .. AutoFarmModule.Config.ABILITY_KEY_2:upper())

    task.spawn(function()
        while AutoFarmModule.Enabled do
            local waitTime = AutoFarmModule.Config.INTERVAL + getRandomOffset()

            print("\n⏳ Waiting " .. waitTime .. " seconds...")
            task.wait(waitTime)

            if not AutoFarmModule.Enabled then break end

            AutoFarmModule.ActionCount = AutoFarmModule.ActionCount + 1

            -- Press Z
            if pressKey(AutoFarmModule.Config.ABILITY_KEY_1) then
                print("✅ [" .. AutoFarmModule.ActionCount .. "] Pressed " .. AutoFarmModule.Config.ABILITY_KEY_1:upper())
            end

            task.wait(0.5)

            if not AutoFarmModule.Enabled then break end

            -- Press X
            if pressKey(AutoFarmModule.Config.ABILITY_KEY_2) then
                print("✅ [" .. AutoFarmModule.ActionCount .. "] Pressed " .. AutoFarmModule.Config.ABILITY_KEY_2:upper())
            end

            print("⚡ Action " .. AutoFarmModule.ActionCount .. " completed")
        end
    end)
end

function AutoFarmModule.Stop()
    AutoFarmModule.Enabled = false
    print("❌ Auto Farm dừng")
end

-- ===================== AUTO REJOIN MODULE =====================
local AutoRejoinModule = {}
AutoRejoinModule.Enabled = false
AutoRejoinModule.Config = {
    REJOIN_INTERVAL = 3600,  -- 60 phút (3600 giây)
    REJOIN_DELAY = 2
}
AutoRejoinModule.Connection = nil

local function rejoinServer()
    print("⚠️ 60 phút đã qua - tự động rejoin server...")

    task.wait(AutoRejoinModule.Config.REJOIN_DELAY)

    local teleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId
    local players = game:GetService("Players"):GetPlayers()

    pcall(function()
        teleportService:Teleport(placeId, players)
    end)
end

function AutoRejoinModule.Start()
    if AutoRejoinModule.Enabled then return end
    AutoRejoinModule.Enabled = true

    print("✅ Auto Rejoin Script Started")
    print("⏱️ Rejoin Interval: 60 phút (3600 giây)")

    if AutoRejoinModule.Connection then
        AutoRejoinModule.Connection:Disconnect()
    end

    AutoRejoinModule.Connection = task.spawn(function()
        while AutoRejoinModule.Enabled do
            task.wait(AutoRejoinModule.Config.REJOIN_INTERVAL)

            if AutoRejoinModule.Enabled then
                rejoinServer()
            end
        end
    end)
end

function AutoRejoinModule.Stop()
    AutoRejoinModule.Enabled = false
    print("❌ Auto Rejoin dừng")
end

-- Create feature buttons
createFeatureBtn("⚡ Fast\nAttack", function()
    FastAttackModule.Enabled = not FastAttackModule.Enabled
    print(FastAttackModule.Enabled and "✅ Fast Attack: ON" or "❌ Fast Attack: OFF")
end)

createFeatureBtn("💪 Bring\nEnemy", function()
    if BringEnemyModule.Enabled then
        BringEnemyModule.Stop()
    else
        BringEnemyModule.Start()
    end
end)

createFeatureBtn("🌍 Auto\nHopper", function()
    if AutoHopperModule.Enabled then
        AutoHopperModule.Stop()
    else
        AutoHopperModule.Start()
    end
end)

createFeatureBtn("🤖 Auto\nFarm", function()
    if AutoFarmModule.Enabled then
        AutoFarmModule.Stop()
    else
        AutoFarmModule.Start()
    end
end)

createFeatureBtn("📡 Auto\nRejoin", function()
    if AutoRejoinModule.Enabled then
        AutoRejoinModule.Stop()
    else
        AutoRejoinModule.Start()
    end
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

-- ===================== LOADING COMPLETE =====================
task.spawn(function()
    local steps = 4
    for i = 0, steps do
        statusMsg.Text = "Khởi tạo module (" .. i .. "/" .. steps .. ")"
        statusPct.Text = math.floor((i / steps) * 100) .. "%"
        
        local fillWidth = (i / steps) * 340
        barFill:TweenSize(UDim2.new(0, fillWidth, 1, 0), "In", "Quad", 0.3, true)
        
        task.wait(0.3)
    end

    statusMsg.Text = "Khởi tạo hoàn tất!"
    statusPct.Text = "100%"
    barFill:TweenSize(UDim2.new(1, 0, 1, 0), "In", "Quad", 0.3, true)

    task.wait(0.5)

    -- Show done badge
    doneBadge:TweenSize(UDim2.fromOffset(80, 80), "Out", "Back", 0.4, true)
    doneCheck.TextTransparency = 0

    task.wait(1.5)

    -- Fade loader
    local tweenInfo = TweenInfo.new(
        0.6,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    )
    local tween = TweenService:Create(loader, tweenInfo, {BackgroundTransparency = 1})
    tween:Play()

    tween.Completed:Connect(function()
        loader:Destroy()
        main.Visible = true
    end)
end)

-- ===================== TOGGLE UI =====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        main.Visible = not main.Visible
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

    -- Bật Auto Farm
    AutoFarmModule.Start()
    print("✅ Auto Farm: ON")

    -- Bật Auto Rejoin
    AutoRejoinModule.Start()
    print("✅ Auto Rejoin: ON")

    print("🎯 Tất cả tính năng đã bật!")
end)

print("✓ Ryzen Config v3.4 loaded successfully!")
print("✓ Features: Dashboard | Fast Attack | Bring Enemy | Auto Hopper | Auto Farm | Auto Rejoin | Time Game")
print("✓ Hotkey: Right Control to toggle UI")
print("✓ Auto Farm: Press Z & X every 5 minutes")
print("✓ Auto Rejoin: Rejoin every 60 minutes")
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
