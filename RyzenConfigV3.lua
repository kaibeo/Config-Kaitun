--[[
    COMBINED ENHANCED SCRIPT v3.0 WITH RYZEN CONFIG UI v3.2
    - Bring Mob tầm gấp 4 lần (60 -> 240)
    - Auto Rejoin khi bị tween trên không 60 giây
    - Auto skill Z/X mỗi 5 phút
    - Load BananaCat addon
    - ✨ INTEGRATED: RyzenConfigUI v3.2 with Game Time Display
    - Giao diện đầy đủ: Avatar, FPS, Ping, Giờ, Ngày, Playtime, Game Time, Network
]]

--[[
    ===================== PHẦN 1: UI SYSTEM (RyzenConfigUI v3.2) =====================
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
brandSub.Text = "[ BANANA KAITUN + GAME TIME ]"
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
verLabel.Text = "COMBINED v3.0 — KAIBEO + GAME TIME"
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

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(19, 9, 12)),
    ColorSequenceKeypoint.new(1, COL_BG1),
})
mainGradient.Rotation = 90
mainGradient.Parent = main

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -16, 1, -22)
content.Position = UDim2.new(0, 8, 0, 8)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ClipsDescendants = true
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 12)
layout.Parent = content

-- ===== BLOCK 1: AVATAR =====
local avatarBlock = Instance.new("Frame")
avatarBlock.Name = "AvatarBlock"
avatarBlock.Size = UDim2.new(0, 50, 0, 46)
avatarBlock.BackgroundColor3 = COL_BG2
avatarBlock.BorderSizePixel = 0
avatarBlock.Parent = content
corner(avatarBlock, 8)
stroke(avatarBlock, COL_LINE, 1)

local avatarImg = Instance.new("ImageLabel")
avatarImg.BackgroundTransparency = 1
avatarImg.Size = UDim2.fromScale(1, 1)
avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=420&h=420"
avatarImg.Parent = avatarBlock
corner(avatarImg, 8)

-- ===== BLOCK 2: FPS =====
local fpsBlock = Instance.new("Frame")
fpsBlock.Size = UDim2.new(0, 60, 0, 46)
fpsBlock.BackgroundColor3 = COL_BG2
fpsBlock.BorderSizePixel = 0
fpsBlock.Parent = content
corner(fpsBlock, 8)
stroke(fpsBlock, COL_LINE, 1)

local fpsLabel = Instance.new("TextLabel")
fpsLabel.BackgroundTransparency = 1
fpsLabel.Size = UDim2.new(1, -18, 0, 13)
fpsLabel.Position = UDim2.new(0, 9, 0, 7)
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Text = "FPS"
fpsLabel.TextColor3 = COL_DIM
fpsLabel.Font = Enum.Font.Gotham
fpsLabel.TextSize = 10
fpsLabel.Parent = fpsBlock

local fpsVal = Instance.new("TextLabel")
fpsVal.BackgroundTransparency = 1
fpsVal.Size = UDim2.new(1, -18, 0, 18)
fpsVal.Position = UDim2.new(0, 9, 0, 20)
fpsVal.TextXAlignment = Enum.TextXAlignment.Left
fpsVal.Text = "0"
fpsVal.TextColor3 = COL_RED
fpsVal.Font = Enum.Font.GothamBold
fpsVal.TextSize = 13
fpsVal.Parent = fpsBlock

-- ===== BLOCK 3: PING =====
local pingBlock = Instance.new("Frame")
pingBlock.Size = UDim2.new(0, 70, 0, 46)
pingBlock.BackgroundColor3 = COL_BG2
pingBlock.BorderSizePixel = 0
pingBlock.Parent = content
corner(pingBlock, 8)
stroke(pingBlock, COL_LINE, 1)

local pingLabel = Instance.new("TextLabel")
pingLabel.BackgroundTransparency = 1
pingLabel.Size = UDim2.new(1, -18, 0, 13)
pingLabel.Position = UDim2.new(0, 9, 0, 7)
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.Text = "PING"
pingLabel.TextColor3 = COL_DIM
pingLabel.Font = Enum.Font.Gotham
pingLabel.TextSize = 10
pingLabel.Parent = pingBlock

local pingVal = Instance.new("TextLabel")
pingVal.BackgroundTransparency = 1
pingVal.Size = UDim2.new(1, -18, 0, 18)
pingVal.Position = UDim2.new(0, 9, 0, 20)
pingVal.TextXAlignment = Enum.TextXAlignment.Left
pingVal.Text = "0ms"
pingVal.TextColor3 = COL_RED
pingVal.Font = Enum.Font.GothamBold
pingVal.TextSize = 13
pingVal.Parent = pingBlock

-- ===== BLOCK 4: TIME =====
local timeBlock = Instance.new("Frame")
timeBlock.Size = UDim2.new(0, 95, 0, 46)
timeBlock.BackgroundColor3 = COL_BG2
timeBlock.BorderSizePixel = 0
timeBlock.Parent = content
corner(timeBlock, 8)
stroke(timeBlock, COL_LINE, 1)

local timeLabel = Instance.new("TextLabel")
timeLabel.BackgroundTransparency = 1
timeLabel.Size = UDim2.new(1, -18, 0, 13)
timeLabel.Position = UDim2.new(0, 9, 0, 3)
timeLabel.TextXAlignment = Enum.TextXAlignment.Left
timeLabel.Text = "SYS TIME"
timeLabel.TextColor3 = COL_DIM
timeLabel.Font = Enum.Font.Gotham
timeLabel.TextSize = 10
timeLabel.Parent = timeBlock

local clockTime = Instance.new("TextLabel")
clockTime.BackgroundTransparency = 1
clockTime.Size = UDim2.new(1, -18, 0, 12)
clockTime.Position = UDim2.new(0, 9, 0, 13)
clockTime.TextXAlignment = Enum.TextXAlignment.Left
clockTime.Text = "00:00:00"
clockTime.TextColor3 = COL_TXT
clockTime.Font = Enum.Font.GothamBold
clockTime.TextSize = 11
clockTime.Parent = timeBlock

local clockDate = Instance.new("TextLabel")
clockDate.BackgroundTransparency = 1
clockDate.Size = UDim2.new(1, -18, 0, 10)
clockDate.Position = UDim2.new(0, 9, 0, 26)
clockDate.TextXAlignment = Enum.TextXAlignment.Left
clockDate.Text = "00/00/0000"
clockDate.TextColor3 = COL_DIM
clockDate.Font = Enum.Font.Gotham
clockDate.TextSize = 9
clockDate.Parent = timeBlock

-- ===== BLOCK 5: PLAYTIME =====
local playtimeBlock = Instance.new("Frame")
playtimeBlock.Size = UDim2.new(0, 100, 0, 46)
playtimeBlock.BackgroundColor3 = COL_BG2
playtimeBlock.BorderSizePixel = 0
playtimeBlock.Parent = content
corner(playtimeBlock, 8)
stroke(playtimeBlock, COL_LINE, 1)

local playtimeLabel = Instance.new("TextLabel")
playtimeLabel.BackgroundTransparency = 1
playtimeLabel.Size = UDim2.new(1, -18, 0, 13)
playtimeLabel.Position = UDim2.new(0, 9, 0, 3)
playtimeLabel.TextXAlignment = Enum.TextXAlignment.Left
playtimeLabel.Text = "PLAYTIME"
playtimeLabel.TextColor3 = COL_DIM
playtimeLabel.Font = Enum.Font.Gotham
playtimeLabel.TextSize = 10
playtimeLabel.Parent = playtimeBlock

local playtimeVal = Instance.new("TextLabel")
playtimeVal.BackgroundTransparency = 1
playtimeVal.Size = UDim2.new(1, -18, 0, 18)
playtimeVal.Position = UDim2.new(0, 9, 0, 16)
playtimeVal.TextXAlignment = Enum.TextXAlignment.Left
playtimeVal.Text = "00m00s"
playtimeVal.TextColor3 = COL_PURPLE
playtimeVal.Font = Enum.Font.GothamBold
playtimeVal.TextSize = 13
playtimeVal.Parent = playtimeBlock

-- ===== BLOCK 6: GAME TIME =====
local gameTimeBlock = Instance.new("Frame")
gameTimeBlock.Size = UDim2.new(0, 140, 0, 46)
gameTimeBlock.BackgroundColor3 = COL_BG2
gameTimeBlock.BorderSizePixel = 0
gameTimeBlock.Parent = content
corner(gameTimeBlock, 8)
stroke(gameTimeBlock, COL_LINE, 1)

local gameTimeLabel = Instance.new("TextLabel")
gameTimeLabel.BackgroundTransparency = 1
gameTimeLabel.Size = UDim2.new(1, -18, 0, 13)
gameTimeLabel.Position = UDim2.new(0, 9, 0, 3)
gameTimeLabel.TextXAlignment = Enum.TextXAlignment.Left
gameTimeLabel.Text = "⏱️ GAME TIME"
gameTimeLabel.TextColor3 = COL_BLUE
gameTimeLabel.Font = Enum.Font.GothamBold
gameTimeLabel.TextSize = 10
gameTimeLabel.Parent = gameTimeBlock

local gameTimeVal = Instance.new("TextLabel")
gameTimeVal.BackgroundTransparency = 1
gameTimeVal.Size = UDim2.new(1, -18, 0, 13)
gameTimeVal.Position = UDim2.new(0, 9, 0, 16)
gameTimeVal.TextXAlignment = Enum.TextXAlignment.Left
gameTimeVal.Text = "Session: 00h00m"
gameTimeVal.TextColor3 = COL_GREEN
gameTimeVal.Font = Enum.Font.GothamBold
gameTimeVal.TextSize = 11
gameTimeVal.Parent = gameTimeBlock

local gameTimeDetail = Instance.new("TextLabel")
gameTimeDetail.BackgroundTransparency = 1
gameTimeDetail.Size = UDim2.new(1, -18, 0, 10)
gameTimeDetail.Position = UDim2.new(0, 9, 0, 30)
gameTimeDetail.TextXAlignment = Enum.TextXAlignment.Left
gameTimeDetail.Text = "Total session time"
gameTimeDetail.TextColor3 = COL_DIM
gameTimeDetail.Font = Enum.Font.Gotham
gameTimeDetail.TextSize = 9
gameTimeDetail.Parent = gameTimeBlock

-- ===== BLOCK 7: NETWORK =====
local netBlock = Instance.new("Frame")
netBlock.Size = UDim2.new(0, 110, 0, 46)
netBlock.BackgroundColor3 = COL_BG2
netBlock.BorderSizePixel = 0
netBlock.Parent = content
corner(netBlock, 8)
stroke(netBlock, COL_LINE, 1)

local netLabel = Instance.new("TextLabel")
netLabel.BackgroundTransparency = 1
netLabel.Size = UDim2.new(1, -18, 0, 13)
netLabel.Position = UDim2.new(0, 18, 0, 7)
netLabel.TextXAlignment = Enum.TextXAlignment.Left
netLabel.Text = "NETWORK"
netLabel.TextColor3 = COL_DIM
netLabel.Font = Enum.Font.Gotham
netLabel.TextSize = 10
netLabel.Parent = netBlock

local netDot = Instance.new("TextLabel")
netDot.BackgroundTransparency = 1
netDot.Size = UDim2.new(0, 8, 0, 8)
netDot.Position = UDim2.new(0, 9, 0.5, -4)
netDot.Text = "●"
netDot.TextColor3 = COL_GREEN
netDot.Font = Enum.Font.GothamBlack
netDot.TextSize = 8
netDot.Parent = netBlock

local netVal = Instance.new("TextLabel")
netVal.BackgroundTransparency = 1
netVal.Size = UDim2.new(1, -18, 0, 13)
netVal.Position = UDim2.new(0, 18, 0, 20)
netVal.TextXAlignment = Enum.TextXAlignment.Left
netVal.Text = "Đang kiểm tra..."
netVal.TextColor3 = COL_DIM
netVal.Font = Enum.Font.Gotham
netVal.TextSize = 10
netVal.Parent = netBlock

-- ===== TICKER =====
local tickerFrame = Instance.new("Frame")
tickerFrame.Size = UDim2.new(1, 0, 0, 16)
tickerFrame.Position = UDim2.new(0, 0, 1, -16)
tickerFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 7)
tickerFrame.BorderSizePixel = 0
tickerFrame.ClipsDescendants = true
tickerFrame.ZIndex = 2
tickerFrame.Parent = main

local tickerText = Instance.new("TextLabel")
tickerText.BackgroundTransparency = 1
tickerText.Size = UDim2.new(0, 1200, 1, 0)
tickerText.Position = UDim2.new(0, BAR_WIDTH, 0, 0)
tickerText.Text = "🎮 Config by Kaibeo + Game Time   •   Server: discord.gg/fdyw76rTuD   •   RYZEN CONFIG v3.2 [Banana Kaitun]   •   "
tickerText.TextColor3 = COL_DIM
tickerText.Font = Enum.Font.Gotham
tickerText.TextSize = 10
tickerText.TextXAlignment = Enum.TextXAlignment.Left
tickerText.ZIndex = 2
tickerText.Parent = tickerFrame

-- ===== TOGGLE BUTTON =====
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Text = ""
toggleBtn.Size = UDim2.fromOffset(40, 40)
toggleBtn.Position = UDim2.new(0, 20, 0, 20)
toggleBtn.BackgroundColor3 = COL_BG1
toggleBtn.AutoButtonColor = false
toggleBtn.ZIndex = 50
toggleBtn.Visible = false
toggleBtn.Parent = screenGui
corner(toggleBtn, 10)
local toggleStroke = stroke(toggleBtn, COL_RED, 1.5)

local toggleGradient = Instance.new("UIGradient")
toggleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 10, 12)),
    ColorSequenceKeypoint.new(1, COL_BG1),
})
toggleGradient.Rotation = 90
toggleGradient.Parent = toggleBtn

local toggleIcon = Instance.new("TextLabel")
toggleIcon.BackgroundTransparency = 1
toggleIcon.Size = UDim2.fromScale(1, 1)
toggleIcon.Text = "⌁"
toggleIcon.TextColor3 = COL_RED
toggleIcon.Font = Enum.Font.GothamBlack
toggleIcon.TextSize = 20
toggleIcon.ZIndex = 51
toggleIcon.Parent = toggleBtn

toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleStroke, TweenInfo.new(0.15), {Thickness = 2}):Play()
    TweenService:Create(toggleIcon, TweenInfo.new(0.15), {TextSize = 22}):Play()
end)
toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleStroke, TweenInfo.new(0.15), {Thickness = 1.5}):Play()
    TweenService:Create(toggleIcon, TweenInfo.new(0.15), {TextSize = 20}):Play()
end)

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

local uiOpen = true
local function setOpen(open)
    uiOpen = open
    main.Visible = open
end

toggleBtn.MouseButton1Click:Connect(function()
    setOpen(not uiOpen)
end)

-- ===================== LOADING SEQUENCE =====================
local loadSteps = {
    {0.15, "Đang khởi tạo module..."},
    {0.35, "Đang tải giao diện..."},
    {0.60, "Đang kết nối máy chủ..."},
    {0.85, "Đang đồng bộ dữ liệu..."},
    {1.00, "Hoàn tất!"},
}

task.spawn(function()
    for _, step in ipairs(loadSteps) do
        local pct, msg = step[1], step[2]
        statusMsg.Text = msg
        TweenService:Create(barFill, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Size = UDim2.new(pct, 0, 1, 0)}):Play()
        local elapsed = 0
        while elapsed < 0.35 do
            local dt = task.wait()
            elapsed += dt
            statusPct.Text = math.floor((tonumber(statusPct.Text:gsub("%%","")) or 0) + (pct*100 - (tonumber(statusPct.Text:gsub("%%","")) or 0)) * 0.3) .. "%"
        end
        statusPct.Text = math.floor(pct * 100) .. "%"
        task.wait(0.15)
    end

    TweenService:Create(doneBadge, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.fromOffset(80, 80), BackgroundTransparency = 0}):Play()
    TweenService:Create(doneCheck, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    task.wait(0.6)

    local fadeTargets = {brandMark, brandTitle, brandSub, statusMsg, statusPct, verLabel, glowRing}
    for _, obj in ipairs(fadeTargets) do
        TweenService:Create(obj, TweenInfo.new(0.3), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
    end
    TweenService:Create(doneBadge, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(doneCheck, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(barTrack, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(barFill, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()

    task.wait(0.35)
    TweenService:Create(loader, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    task.wait(0.4)
    loader.Visible = false

    main.Visible = true
    main.Size = UDim2.fromOffset(BAR_WIDTH, 0)
    main.Position = UDim2.new(0.5, -BAR_WIDTH/2, 0, 20)
    TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Size = UDim2.fromOffset(BAR_WIDTH, BAR_HEIGHT)}):Play()

    toggleBtn.Visible = true
end)

-- ===================== LIVE UI UPDATES =====================
local frameCount, fpsTimer = 0, 0
RunService.RenderStepped:Connect(function(dt)
    frameCount += 1
    fpsTimer += dt
    if fpsTimer >= 0.5 then
        local fps = math.floor(frameCount / fpsTimer)
        fpsVal.Text = tostring(fps)
        fpsVal.TextColor3 = fps >= 50 and COL_GREEN or (fps >= 30 and COL_YELLOW or COL_RED)
        frameCount, fpsTimer = 0, 0
    end
end)

task.spawn(function()
    while true do
        local ok2, pingMs = pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if ok2 and pingMs then
            local ping = math.floor(pingMs)
            pingVal.Text = ping .. "ms"
            pingVal.TextColor3 = ping <= 80 and COL_GREEN or (ping <= 150 and COL_YELLOW or COL_RED)
        end

        local t = os.date("*t")
        clockTime.Text = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
        clockDate.Text = string.format("%02d/%02d/%04d", t.day, t.month, t.year)

        local elapsedSec = math.floor(os.clock() - joinTime)
        local h = math.floor(elapsedSec / 3600)
        local m = math.floor((elapsedSec % 3600) / 60)
        local s = elapsedSec % 60
        if h > 0 then
            playtimeVal.Text = string.format("%dh%02dm", h, m)
        else
            playtimeVal.Text = string.format("%02dm%02ds", m, s)
        end

        -- GAME TIME
        local gameSessionSeconds = math.floor(os.clock() - joinTime)
        local gameH = math.floor(gameSessionSeconds / 3600)
        local gameM = math.floor((gameSessionSeconds % 3600) / 60)
        local gameS = gameSessionSeconds % 60
        
        if gameH > 0 then
            gameTimeVal.Text = "Session: " .. gameH .. "h " .. gameM .. "m"
        else
            gameTimeVal.Text = "Session: " .. gameM .. "m " .. gameS .. "s"
        end
        
        gameTimeDetail.Text = "In-game: " .. string.format("%02d:%02d:%02d", gameH, gameM, gameS)

        local connected = game:IsLoaded()
        if connected then
            netDot.BackgroundColor3 = COL_GREEN
            netVal.Text = "Ổn định"
            netVal.TextColor3 = COL_DIM
        else
            netDot.BackgroundColor3 = COL_YELLOW
            netVal.Text = "Đang tải..."
            netVal.TextColor3 = COL_YELLOW
        end

        task.wait(1)
    end
end)

task.spawn(function()
    while true do
        local textWidth = tickerText.AbsoluteSize.X
        tickerText.Position = UDim2.new(0, BAR_WIDTH, 0, 0)
        local tween = TweenService:Create(tickerText, TweenInfo.new(14, Enum.EasingStyle.Linear), {Position = UDim2.new(0, -textWidth, 0, 0)})
        tween:Play()
        tween.Completed:Wait()
    end
end)

print("✅ [UI] RyzenConfigUI v3.2 with Game Time loaded!")

--[[
    ===================== PHẦN 2: GAME SCRIPT (CombinedScript_FIXED) =====================
]]

local plr = game.Players.LocalPlayer
local Root = nil
local Character = nil
local PosMon = Vector3.new(0, 0, 0)
local Mon = nil
local BringConnections = {}
local rejoinConnections = {}
local lastSkillTime = 0
local lastMoveTime = os.time()
local isStuck = false
local SKILL_INTERVAL = 300 -- 5 phút

-- ===================== WAIT FOR CHARACTER =====================
local function WaitForCharacter()
    if plr.Character then
        Character = plr.Character
        Root = Character:FindFirstChild("HumanoidRootPart")
        if Root then
            return true
        end
    end
    
    Character = plr.CharacterAdded:Wait()
    Root = Character:WaitForChild("HumanoidRootPart")
    return true
end

print("⏳ Chờ character load...")
WaitForCharacter()
print("✅ [SCRIPT] Character loaded!")

-- ===================== BRING ENEMY SYSTEM =====================
local function BringEnemy()
    if not Root or not Character then return end
    
    for i, v in ipairs(BringConnections) do
        pcall(function() v:Disconnect() end)
    end
    BringConnections = {}
    
    Mon = Character:FindFirstChild("HumanoidRootPart") and game.Workspace.Enemies:FindFirstChildOfClass("Model")
    
    if Mon then
        table.insert(BringConnections, game:GetService("RunService").Heartbeat:Connect(function()
            if not Root or not Character then return end
            
            if Mon and Mon:FindFirstChild("Humanoid") and Mon.Humanoid.Health > 0 then
                local root = Mon.HumanoidRootPart
                local hum = Mon.Humanoid
                local targetPos = PosMon
                
                if root and hum then
                    local dist = (root.Position - Root.Position).Magnitude
                    local AreaMob = dist <= 5
                    
                    if AreaMob then
                        root.CFrame = Root.CFrame + Root.CFrame.LookVector * 10
                    else
                        if not AreaMob then
                            root.CFrame = CFrame.new(targetPos)
                        end
                        
                        root.CanCollide = false
                        hum.WalkSpeed = 0
                        hum.JumpPower = 0
                    end
                end
            end
        end))
    end
end

-- ===================== FAST ATTACK MODULE =====================
local FastAttackModule = {}
FastAttackModule.Rate = 0.1

local HitRegistrationModule = {}

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
            if distance <= 240 then
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
    local Enemies = workspace.Enemies
    local Characters = workspace.Characters
    
    local enemies = FastAttackModule.GetNearbyTargets(character, Enemies)
    local otherCharacters = FastAttackModule.GetNearbyTargets(character, Characters)
    
    local allTargets = {}
    for i = 1, #enemies do
        table.insert(allTargets, enemies[i])
    end
    for i = 1, #otherCharacters do
        table.insert(allTargets, otherCharacters[i])
    end
    return allTargets
end

function FastAttackModule.ExecuteFastAttack()
    if not Character then return end
    
    local character = Character
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    local targets = FastAttackModule.GetAllTargets(character)
    if #targets < 1 then return end
    
    local targetParts = FastAttackModule.GetTargetParts(targets)
    if #targetParts < 1 then return end
    
    local replicated = game:GetService("ReplicatedStorage")
    local Net = replicated.Modules.Net
    
    local attackRemote = Net["RE/RegisterAttack"]
    local hitRemote = Net["RE/RegisterHit"]
    
    attackRemote:FireServer(FastAttackModule.Rate)
    local targetHead = targetParts[1][2]
    hitRemote:FireServer(targetHead, targetParts)
end

-- Hit Registration Module
local AttackRemoteTarget
local AttackRemoteId

local function InitializeHitRegistration()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local foldersToCheck = {
        ReplicatedStorage.Util,
        ReplicatedStorage.Common,
        ReplicatedStorage.Remotes,
        ReplicatedStorage.Assets,
        ReplicatedStorage.FX
    }

    for _, folder in ipairs(foldersToCheck) do
        if folder then
            local children = folder:GetChildren()
            
            for _, child in ipairs(children) do
                if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
                    AttackRemoteTarget = child
                    AttackRemoteId = child:GetAttribute("Id")
                end
            end

            folder.ChildAdded:Connect(function(child)
                if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
                    AttackRemoteTarget = child
                    AttackRemoteId = child:GetAttribute("Id")
                end
            end)
        end
    end
end

InitializeHitRegistration()

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

    local tool = character:FindFirstChildOfClass("Tool")
    
    if #hitTargets > 0 and tool and (tool:GetAttribute("WeaponType") == "Melee" or tool:GetAttribute("WeaponType") == "Sword") then
        local replicated = game:GetService("ReplicatedStorage")
        local Modules = replicated.Modules
        local Net = Modules.Net
        
        local ok, seed = pcall(function()
            return Modules.Net.seed:InvokeServer()
        end)
        if not ok then return end
        
        local attackRemote = Net["RE/RegisterAttack"]
        local hitRemote = Net["RE/RegisterHit"]
        
        attackRemote:FireServer()
        
        local targetHead = hitTargets[1][1]:FindFirstChild("Head")
        if not targetHead then return end

        hitRemote:FireServer(targetHead, hitTargets, {})
        
        if AttackRemoteTarget then
            local remoteCode = "RE/RegisterHit"
            local encryptionKey = math.floor(workspace:GetServerTimeNow() / 10 % 10) + 1
            
            local encodedString = string.gsub(remoteCode, ".", function(char)
                return string.char(bit32.bxor(string.byte(char), encryptionKey))
            end)

            local finalId = bit32.bxor(AttackRemoteId + 909090, seed * 2)
            
            cloneref(AttackRemoteTarget):FireServer(
                encodedString,
                finalId,
                targetHead,
                hitTargets
            )
        end
    end
end

-- ===================== AUTO REJOIN SYSTEM =====================
local function CheckStuckStatus()
    if not Character or not Root then return end
    
    local humanoid = Character:FindFirstChild("Humanoid")
    
    if humanoid and humanoid.Health > 0 then
        if os.time() - lastMoveTime > 60 then
            if os.time() - lastSkillTime > SKILL_INTERVAL then
                pcall(function()
                    local UIS = game:GetService("UserInputService")
                    
                    UIS:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                    task.wait(0.1)
                    UIS:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                    
                    task.wait(0.5)
                    
                    UIS:SendKeyEvent(true, Enum.KeyCode.X, false, game)
                    task.wait(0.1)
                    UIS:SendKeyEvent(false, Enum.KeyCode.X, false, game)
                    
                    lastSkillTime = os.time()
                    print("🔥 [AUTO] Skill Z/X activated!")
                end)
            end
            
            if not isStuck then
                isStuck = true
                print("⚠️ [AUTO] Bị stuck quá 60 giây, đang rejoin...")
                task.wait(5)
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
    
    table.insert(rejoinConnections, game:GetService("RunService").Heartbeat:Connect(function()
        if Character and Root then
            if Root.Velocity.Magnitude > 0.5 then
                lastMoveTime = os.time()
                isStuck = false
            end
        end
    end))
end

-- ===================== AUTO SKILL SYSTEM =====================
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
                    
                    print("✨ [AUTO] Skill Z activated! (" .. SKILL_INTERVAL .. "s)")
                end
            end)
        end
    end)
end

-- ===================== MAIN ATTACK LOOP =====================
local function StartMainLoops()
    task.spawn(function()
        while task.wait(FastAttackModule.Rate) do
            pcall(FastAttackModule.ExecuteFastAttack)
        end
    end)

    local RunService = game:GetService("RunService")
    RunService.Heartbeat:Connect(function()
        pcall(HitRegistrationModule.Execute)
        pcall(CheckStuckStatus)
    end)
end

-- ===================== CHARACTER RESPAWN HANDLER =====================
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

-- ===================== INITIALIZE SYSTEMS =====================
MonitorMovement()
UseSkillPeriodically()
StartMainLoops()
BringEnemy()

print("✅ [SCRIPT] Script loaded successfully!")
print("📍 [SCRIPT] Bring range: 240 (4x)")
print("⏱️  [SCRIPT] Auto rejoin: 60s stuck")
print("💫 [SCRIPT] Auto skill: 5 min interval")

-- ===================== LOAD BANANCAT ADDON =====================
print("🍌 [ADDON] Đang tải BananaCat addon...")

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaCat-kaitunBF.lua"))()
        print("✓ [ADDON] BananaCat addon đã tải thành công!")
    end)
end)

print("═══════════════════════════════════════════════════════════")
print("          🎮 COMBINED v3.0 - READY TO USE 🎮")
print("═══════════════════════════════════════════════════════════")
print("✅ UI System (RyzenConfigUI v3.2 + Game Time)")
print("✅ Game Script (CombinedScript_FIXED)")
print("✅ Auto Bring, Auto Rejoin, Auto Skill")
print("✅ BananaCat Addon (Loading...)")
print("═══════════════════════════════════════════════════════════")
