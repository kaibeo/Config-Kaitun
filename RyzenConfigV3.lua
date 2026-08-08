--[[
    RYZEN CONFIG v3.2 - INTEGRATED VERSION
    Made by Kaibeo | Server: discord.gg/fdyw76rTuD
    
    TÍCH HỢP CÁC MODULE:
    1. RYZEN CONFIG UI [Banana Kaitun] v3.0
    2. FAST ATTACK MODULE (Extracted from Bloxfruit)
    3. BRING ENEMY FUNCTION
    
    Đặt Script này là LocalScript bên trong StarterGui
    
    BẢO GỒM:
    - Avatar, Ping, FPS, Giờ, Ngày
    - Ticker chữ chạy ngang
    - Loading screen animation
    - Nút bật/tắt UI (mở/ẩn bảng chính)
    - Fast Attack Module
    - Bring Enemy Function
]]

-- ===================== SERVICES & VARIABLES =====================
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

-- ===================== UTILITY FUNCTIONS =====================
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
verLabel.Text = "RYZEN CONFIG v3.2 — MADE BY KAIBEO"
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
main.Size = UDim2.fromOffset(300, 360)
main.Position = UDim2.new(0.5, -150, 0.5, -180)
main.BackgroundColor3 = COL_BG1
main.BorderSizePixel = 0
main.Visible = false
main.ClipsDescendants = true
main.Parent = screenGui
corner(main, 14)
stroke(main, COL_LINE, 1)

-- Draggable main frame
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

-- ===================== UI COMPONENTS =====================

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = COL_BG2
header.BorderSizePixel = 0
header.Parent = main
stroke(header, COL_LINE, 1)

local titleLabel = Instance.new("TextLabel")
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 14, 0, 0)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Text = "RYZEN CONFIG v3.2"
titleLabel.TextColor3 = COL_TXT
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.fromOffset(38, 38)
closeBtn.Position = UDim2.new(1, -44, 0.5, -19)
closeBtn.BackgroundColor3 = COL_BG2
closeBtn.TextSize = 0
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header
corner(closeBtn, 8)

local closeX = Instance.new("TextLabel")
closeX.BackgroundTransparency = 1
closeX.Size = UDim2.fromScale(1, 1)
closeX.Text = "✕"
closeX.TextColor3 = COL_RED
closeX.Font = Enum.Font.GothamBlack
closeX.TextSize = 16
closeX.Parent = closeBtn

-- Content scroll
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, -4, 1, -60)
scrollFrame.Position = UDim2.new(0, 2, 0, 52)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = COL_LINE
scrollFrame.Parent = main

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

local function addSection(name)
    local section = Instance.new("Frame")
    section.Name = name
    section.Size = UDim2.new(1, -8, 0, 28)
    section.BackgroundColor3 = COL_BG2
    section.BorderSizePixel = 0
    section.Parent = scrollFrame
    corner(section, 8)
    stroke(section, COL_LINE, 1)
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = name
    label.TextColor3 = COL_TXT
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.Parent = section
    
    return section
end

local function addStat(parent, label, value)
    local statFrame = Instance.new("Frame")
    statFrame.Size = UDim2.new(1, -8, 0, 24)
    statFrame.BackgroundTransparency = 1
    statFrame.Parent = parent
    
    local lblText = Instance.new("TextLabel")
    lblText.BackgroundTransparency = 1
    lblText.Size = UDim2.new(0.5, 0, 1, 0)
    lblText.TextXAlignment = Enum.TextXAlignment.Left
    lblText.Text = label
    lblText.TextColor3 = COL_DIM
    lblText.Font = Enum.Font.Gotham
    lblText.TextSize = 10
    lblText.Parent = statFrame
    
    local valText = Instance.new("TextLabel")
    valText.BackgroundTransparency = 1
    valText.Size = UDim2.new(0.5, 0, 1, 0)
    valText.Position = UDim2.new(0.5, 0, 0, 0)
    valText.TextXAlignment = Enum.TextXAlignment.Right
    valText.Text = value or "---"
    valText.TextColor3 = COL_GREEN
    valText.Font = Enum.Font.GothamBold
    valText.TextSize = 10
    valText.Parent = statFrame
    
    return valText
end

-- Info Section
local infoSection = addSection("INFO")
local avatarVal = addStat(scrollFrame, "Avatar:", player.Name)
local pingVal = addStat(scrollFrame, "Ping:", "0ms")
local fpsVal = addStat(scrollFrame, "FPS:", "0")
local clockTime = addStat(scrollFrame, "Giờ:", "00:00:00")
local clockDate = addStat(scrollFrame, "Ngày:", "00/00/0000")

-- Network Status
local netSection = addSection("NETWORK")
local netVal = addStat(scrollFrame, "Trạng thái:", "Đang đo...")
local netDot = Instance.new("Frame")
netDot.Size = UDim2.fromOffset(8, 8)
netDot.Position = UDim2.new(0.85, 0, 0.02, 0)
netDot.BackgroundColor3 = COL_RED
netDot.BorderSizePixel = 0
netDot.Parent = netSection
corner(netDot, 4)

-- Ticker
local tickerFrame = Instance.new("Frame")
tickerFrame.Name = "TickerFrame"
tickerFrame.Size = UDim2.new(1, -8, 0, 20)
tickerFrame.BackgroundColor3 = COL_BG2
tickerFrame.BorderSizePixel = 0
tickerFrame.ClipsDescendants = true
tickerFrame.Parent = scrollFrame
corner(tickerFrame, 6)
stroke(tickerFrame, COL_LINE, 1)

local tickerText = Instance.new("TextLabel")
tickerText.BackgroundTransparency = 1
tickerText.Size = UDim2.new(0, 500, 1, 0)
tickerText.Text = "⚙ RYZEN CONFIG v3.2 — FAST ATTACK | BRING ENEMY | CONFIG SYSTEM ⚙"
tickerText.TextColor3 = COL_YELLOW
tickerText.Font = Enum.Font.Gotham
tickerText.TextSize = 9
tickerText.Parent = tickerFrame

-- Features Section
local featuresSection = addSection("FEATURES")

local function createButton(parent, text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 26)
    btn.BackgroundColor3 = COL_BG2
    btn.TextColor3 = color or COL_TXT
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    btn.Parent = parent
    btn.Text = text
    corner(btn, 6)
    stroke(btn, COL_LINE, 1)
    return btn
end

local fastAttackBtn = createButton(scrollFrame, "🚀 FAST ATTACK", COL_RED)
local bringEnemyBtn = createButton(scrollFrame, "🎯 BRING ENEMY", COL_YELLOW)
local autoHopperBtn = createButton(scrollFrame, "🌍 AUTO HOPPER", COL_GREEN)

-- ===================== TOGGLE BUTTON =====================
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.fromOffset(44, 44)
toggleBtn.Position = UDim2.new(1, -60, 1, -60)
toggleBtn.BackgroundColor3 = COL_BG1
toggleBtn.TextSize = 0
toggleBtn.Visible = false
toggleBtn.BorderSizePixel = 0
toggleBtn.ZIndex = 50
toggleBtn.Parent = screenGui
corner(toggleBtn, 12)

local toggleStroke = stroke(toggleBtn, COL_RED, 1.5)

local toggleIcon = Instance.new("TextLabel")
toggleIcon.BackgroundTransparency = 1
toggleIcon.Size = UDim2.fromScale(1, 1)
toggleIcon.Text = "⌁"
toggleIcon.TextColor3 = COL_RED
toggleIcon.Font = Enum.Font.GothamBlack
toggleIcon.TextSize = 22
toggleIcon.ZIndex = 51
toggleIcon.Parent = toggleBtn

local toggleGlow = Instance.new("Frame")
toggleGlow.AnchorPoint = Vector2.new(0.5, 0.5)
toggleGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
toggleGlow.Size = UDim2.new(1, 12, 1, 12)
toggleGlow.BackgroundColor3 = COL_RED
toggleGlow.BackgroundTransparency = 1
toggleGlow.ZIndex = 49
toggleGlow.Parent = toggleBtn
corner(toggleGlow, 12)

toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleStroke, TweenInfo.new(0.15), {Thickness = 2}):Play()
    TweenService:Create(toggleGlow, TweenInfo.new(0.15), {BackgroundTransparency = 0.85}):Play()
    TweenService:Create(toggleIcon, TweenInfo.new(0.15), {TextSize = 24}):Play()
end)
toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleStroke, TweenInfo.new(0.15), {Thickness = 1.5}):Play()
    TweenService:Create(toggleGlow, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
    TweenService:Create(toggleIcon, TweenInfo.new(0.15), {TextSize = 22}):Play()
end)

-- Draggable toggle button
do
    local dragging, dragStart, startPos
    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = toggleBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    toggleBtn.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local uiVisible = true
local function setUIVisible(v)
    uiVisible = v
    if v then
        main.Visible = true
        main.Size = UDim2.fromOffset(300, 0)
        for _, obj in ipairs(main:GetDescendants()) do
            if obj:IsA("TextLabel") then obj.TextTransparency = 1 end
        end
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(300, 360)}):Play()
        task.wait(0.12)
        for _, obj in ipairs(main:GetDescendants()) do
            if obj:IsA("TextLabel") then
                TweenService:Create(obj, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
            end
        end
        toggleStroke.Color = COL_RED
        toggleIcon.TextColor3 = COL_RED
    else
        local tw = TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(300, 0)})
        tw:Play()
        tw.Completed:Wait()
        main.Visible = false
        toggleStroke.Color = COL_LINE
        toggleIcon.TextColor3 = COL_DIM
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    setUIVisible(not uiVisible)
end)
closeBtn.MouseButton1Click:Connect(function()
    setUIVisible(false)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        setUIVisible(not uiVisible)
    end
end)

-- ===================== LOADING LOGIC =====================
local steps = {
    {12, "Đang khởi tạo module..."},
    {30, "Đang kết nối máy chủ..."},
    {50, "Đang tải cấu hình Ryzen..."},
    {70, "Đang xác thực thiết bị..."},
    {88, "Đang tối ưu hiệu năng..."},
    {100, "Hoàn tất — Khởi chạy!"},
}

task.spawn(function()
    for _, step in ipairs(steps) do
        local pct, msg = step[1], step[2]
        statusMsg.Text = msg
        statusPct.Text = pct .. "%"
        TweenService:Create(barFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(pct / 100, 0, 1, 0)
        }):Play()
        task.wait(0.35 + math.random() * 0.25)
    end

    statusPct.TextColor3 = COL_GREEN
    barFill.BackgroundColor3 = COL_GREEN

    TweenService:Create(doneBadge, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(80, 80),
        BackgroundTransparency = 0,
    }):Play()
    TweenService:Create(doneCheck, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    task.wait(0.6)

    local fadeOut = TweenService:Create(loader, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    for _, obj in ipairs(loader:GetDescendants()) do
        if obj:IsA("TextLabel") then
            TweenService:Create(obj, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        elseif obj:IsA("Frame") then
            TweenService:Create(obj, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        end
    end
    fadeOut:Play()

    main.Visible = true
    main.Size = UDim2.fromOffset(300, 0)
    main.BackgroundTransparency = 1
    for _, obj in ipairs(main:GetDescendants()) do
        if obj:IsA("TextLabel") then obj.TextTransparency = 1 end
    end

    TweenService:Create(main, TweenInfo.new(0.45, Enum.EasingStyle.Quad), {
        Size = UDim2.fromOffset(300, 360),
        BackgroundTransparency = 0
    }):Play()

    task.wait(0.15)
    for _, obj in ipairs(main:GetDescendants()) do
        if obj:IsA("TextLabel") then
            TweenService:Create(obj, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        end
    end

    fadeOut.Completed:Wait()
    loader:Destroy()

    toggleBtn.Visible = true
    toggleBtn.Size = UDim2.fromOffset(0, 0)
    TweenService:Create(toggleBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(44, 44)
    }):Play()
end)

-- ===================== CLOCK LOOP =====================
task.spawn(function()
    while true do
        local t = os.date("*t")
        clockTime.Text = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
        clockDate.Text = string.format("%02d/%02d/%04d", t.day, t.month, t.year)
        task.wait(1)
    end
end)

-- ===================== STATS LOOP (FPS / Ping / Network) =====================
task.spawn(function()
    local frameCount = 0
    local lastCheck = os.clock()
    RunService.RenderStepped:Connect(function()
        frameCount += 1
    end)

    while true do
        task.wait(1)
        local now = os.clock()
        local dt = now - lastCheck
        local fps = math.floor(frameCount / dt)
        frameCount = 0
        lastCheck = now

        fpsVal.Text = tostring(fps)
        fpsVal.TextColor3 = fps >= 50 and COL_GREEN or (fps >= 30 and COL_YELLOW or COL_RED)

        local ping = 0
        local success = pcall(function()
            local stats = game:GetService("Stats")
            local network = stats.Network
            ping = math.floor(network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        if not success or ping <= 0 then ping = 0 end

        pingVal.Text = ping .. "ms"
        pingVal.TextColor3 = ping <= 60 and COL_GREEN or (ping <= 120 and COL_YELLOW or COL_RED)

        local isGood = ping > 0 and ping <= 100
        netVal.Text = isGood and "Ổn định" or (ping == 0 and "Đang đo..." or "Kém")
        netVal.TextColor3 = isGood and COL_GREEN or COL_RED
        netDot.BackgroundColor3 = isGood and COL_GREEN or COL_RED
    end
end)

-- ===================== TICKER MARQUEE LOOP =====================
task.spawn(function()
    while true do
        local frameWidth = tickerFrame.AbsoluteSize.X
        tickerText.Position = UDim2.new(0, frameWidth, 0, 0)
        local tween = TweenService:Create(
            tickerText,
            TweenInfo.new(14, Enum.EasingStyle.Linear),
            {Position = UDim2.new(0, -tickerText.AbsoluteSize.X, 0, 0)}
        )
        tween:Play()
        tween.Completed:Wait()
        task.wait(0.5)
    end
end)

-- ===================== FAST ATTACK MODULE =====================
local FastAttackModule = {}
FastAttackModule.Rate = 0.1
FastAttackModule.Enabled = false

function FastAttackModule.GetNearbyTargets(character, folder)
    local result = {}
    if not folder or not character then
        return result
    end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return result
    end
    
    local children = folder:GetChildren()
    for i = 1, #children do
        local target = children[i]
        local humanoid = target:FindFirstChild("Humanoid")
        local rootPart = target:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart and humanoid.Health > 0 and target ~= character then
            local distance = (rootPart.Position - humanoidRootPart.Position).Magnitude
            if distance <= 60 then
                table.insert(result, target)
            end
        end
    end
    return result
end

function FastAttackModule.GetTargetParts(targets)
    local result = {}
    if not targets or #targets == 0 then
        return result
    end
    
    for i = 1, #targets do
        local targetChildren = targets[i]:GetChildren()
        for _, child in ipairs(targetChildren) do
            if child:IsA("BasePart") then
                table.insert(result, {targets[i], child})
            end
        end
    end
    return result
end

function FastAttackModule.GetAllTargets(character)
    local Enemies = workspace:FindFirstChild("Enemies")
    local Characters = workspace:FindFirstChild("Characters")
    
    local allTargets = {}
    
    if Enemies then
        local enemies = FastAttackModule.GetNearbyTargets(character, Enemies)
        for i = 1, #enemies do
            table.insert(allTargets, enemies[i])
        end
    end
    
    if Characters then
        local otherCharacters = FastAttackModule.GetNearbyTargets(character, Characters)
        for i = 1, #otherCharacters do
            table.insert(allTargets, otherCharacters[i])
        end
    end
    
    return allTargets
end

function FastAttackModule.ExecuteFastAttack()
    if not FastAttackModule.Enabled then return end
    
    local LocalPlayer = game.Players.LocalPlayer
    local character = LocalPlayer.Character
    if not character then return end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    local targets = FastAttackModule.GetAllTargets(character)
    if #targets < 1 then return end
    
    local targetParts = FastAttackModule.GetTargetParts(targets)
    if #targetParts < 1 then return end
    
    local replicated = game:GetService("ReplicatedStorage")
    local Net = replicated:FindFirstChild("Modules") and replicated.Modules:FindFirstChild("Net")
    
    if Net then
        local attackRemote = Net:FindFirstChild("RE/RegisterAttack")
        local hitRemote = Net:FindFirstChild("RE/RegisterHit")
        
        if attackRemote and hitRemote then
            pcall(function()
                attackRemote:FireServer(FastAttackModule.Rate)
                local targetHead = targetParts[1][2]
                hitRemote:FireServer(targetHead, targetParts)
            end)
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
AutoHopperModule.IdleTime = 60 -- 1 phút
AutoHopperModule.AutoHop = true -- Tự động hop khi idle
AutoHopperModule.LastHopTime = 0

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
        print("⚠️  Không tìm thấy server trống, thử lại sau...")
        return false
    end
    
    local randomServer = servers[math.random(1, #servers)]
    print("🌍 Hop sang server: " .. randomServer)
    print("⏱️  Idle time: " .. AutoHopperModule.IdleTime .. "s")
    
    pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, randomServer, plr)
    end)
    
    AutoHopperModule.LastHopTime = tick()
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
    local logInterval = 0
    
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
        
        -- Nếu di chuyển đủ xa, reset timer
        if distanceMoved > 0.5 then
            lastPosition = currentPosition
            idleStartTime = tick()
            logInterval = 0
        end
        
        local elapsedIdle = tick() - idleStartTime
        
        -- Log mỗi 10 giây
        logInterval = logInterval + 1
        if logInterval % 600 == 0 then -- Heartbeat ~60fps, 600 frames = 10s
            print(string.format("⏱️  Idle: %ds / %ds", math.floor(elapsedIdle), AutoHopperModule.IdleTime))
        end
        
        -- Tự động hop nếu đứng im đủ lâu
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

-- ===================== BUTTON CONNECTIONS =====================
fastAttackBtn.MouseButton1Click:Connect(function()
    FastAttackModule.Enabled = not FastAttackModule.Enabled
    if FastAttackModule.Enabled then
        fastAttackBtn.TextColor3 = COL_GREEN
        fastAttackBtn.Text = "✓ FAST ATTACK ACTIVE"
    else
        fastAttackBtn.TextColor3 = COL_RED
        fastAttackBtn.Text = "🚀 FAST ATTACK"
    end
end)

bringEnemyBtn.MouseButton1Click:Connect(function()
    if BringEnemyModule.Enabled then
        BringEnemyModule.Stop()
        bringEnemyBtn.TextColor3 = COL_RED
        bringEnemyBtn.Text = "🎯 BRING ENEMY"
    else
        BringEnemyModule.Start()
        bringEnemyBtn.TextColor3 = COL_GREEN
        bringEnemyBtn.Text = "✓ BRING ENEMY ACTIVE"
    end
end)

autoHopperBtn.MouseButton1Click:Connect(function()
    if AutoHopperModule.Enabled then
        AutoHopperModule.Stop()
        autoHopperBtn.TextColor3 = COL_RED
        autoHopperBtn.Text = "🌍 AUTO HOPPER"
    else
        AutoHopperModule.Start()
        autoHopperBtn.TextColor3 = COL_GREEN
        autoHopperBtn.Text = "✓ AUTO HOPPER ACTIVE"
    end
end)

-- ===================== MAIN ATTACK LOOP =====================
task.spawn(function()
    while true do
        if FastAttackModule.Enabled then
            FastAttackModule.ExecuteFastAttack()
        end
        task.wait(FastAttackModule.Rate)
    end
end)

print("✓ Ryzen Config v3.2 loaded successfully!")
print("✓ Features: UI Dashboard | Fast Attack | Bring Enemy | Auto Hopper")
print("✓ Hotkey: Right Control to toggle UI")
print("✓ Auto Hopper: Tự động hop server nếu đứng im > 60 giây")

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
