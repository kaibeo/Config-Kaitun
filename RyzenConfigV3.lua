--[[
    RYZEN CONFIG UI [Banana Kaitun] v3.0
    Made by Kaibeo | Server: discord.gg/fdyw76rTuD
    Đặt Script này là LocalScript bên trong StarterGui

    Đây là bảng thông tin (info dashboard) cho Roblox:
    - Avatar, Ping, FPS, Giờ, Ngày
    - Ticker chữ chạy ngang
    - Loading screen animation
    - Nút bật/tắt UI (mở/ẩn bảng chính)
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

-- glowing ring behind logo
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

-- progress bar track
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
verLabel.Text = "RYZEN CONFIG v3.0 — MADE BY KAIBEO"
verLabel.TextColor3 = COL_DIM
verLabel.Font = Enum.Font.Gotham
verLabel.TextSize = 11
verLabel.ZIndex = 101
verLabel.Parent = loader

-- "Hoàn tất" tick badge, ẩn sẵn, hiện khi loading xong
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

-- shadow effect (subtle, via ImageLabel with rounded 9-slice) — optional, skipped for simplicity

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
corner(tickerFrame, 14) -- bo nhẹ góc trên cùng theo main

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
tickerText.Text = "🎮 Config make by Kaibeo   •   Server: discord.gg/fdyw76rTuD   •   RYZEN CONFIG v3.0 [Banana Kaitun]   •   "
tickerText.TextColor3 = COL_DIM
tickerText.Font = Enum.Font.Gotham
tickerText.TextSize = 12
tickerText.TextXAlignment = Enum.TextXAlignment.Left
tickerText.Parent = tickerFrame

-- ===== Topbar =====
local topbar = Instance.new("Frame")
topbar.Name = "Topbar"
topbar.Size = UDim2.new(1, 0, 0, 58)
topbar.Position = UDim2.new(0, 0, 0, 26)
topbar.BackgroundColor3 = COL_BG1
topbar.BorderSizePixel = 0
topbar.Parent = main

local topLine = Instance.new("Frame")
topLine.Size = UDim2.new(1, 0, 0, 1)
topLine.Position = UDim2.new(0, 0, 1, -1)
topLine.BackgroundColor3 = COL_LINE
topLine.BorderSizePixel = 0
topLine.Parent = topbar

local avatarImg = Instance.new("ImageLabel")
avatarImg.Name = "Avatar"
avatarImg.Size = UDim2.fromOffset(36, 36)
avatarImg.Position = UDim2.new(0, 12, 0.5, -18)
avatarImg.BackgroundColor3 = COL_BG2
local ok, thumb = pcall(function()
    return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)
avatarImg.Image = ok and thumb or ""
avatarImg.Parent = topbar
corner(avatarImg, 18)
stroke(avatarImg, COL_REDDIM, 2)

local nameLbl = Instance.new("TextLabel")
nameLbl.BackgroundTransparency = 1
nameLbl.Size = UDim2.new(0, 130, 0, 16)
nameLbl.Position = UDim2.new(0, 56, 0, 11)
nameLbl.TextXAlignment = Enum.TextXAlignment.Left
nameLbl.Text = player.DisplayName
nameLbl.TextColor3 = COL_TXT
nameLbl.Font = Enum.Font.GothamBold
nameLbl.TextSize = 13
nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
nameLbl.Parent = topbar

local userLbl = Instance.new("TextLabel")
userLbl.BackgroundTransparency = 1
userLbl.Size = UDim2.new(0, 130, 0, 14)
userLbl.Position = UDim2.new(0, 56, 0, 29)
userLbl.TextXAlignment = Enum.TextXAlignment.Left
userLbl.Text = "@" .. player.Name
userLbl.TextColor3 = COL_DIM
userLbl.Font = Enum.Font.Gotham
userLbl.TextSize = 11
userLbl.TextTruncate = Enum.TextTruncate.AtEnd
userLbl.Parent = topbar

-- close (ẩn) button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = COL_DIM
closeBtn.Size = UDim2.fromOffset(26, 26)
closeBtn.Position = UDim2.new(1, -38, 0, 19)
closeBtn.BackgroundColor3 = COL_BG2
closeBtn.AutoButtonColor = false
closeBtn.Parent = topbar
corner(closeBtn, 8)
local closeStroke = stroke(closeBtn, COL_LINE, 1)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {TextColor3 = COL_RED}):Play()
    TweenService:Create(closeStroke, TweenInfo.new(0.15), {Color = COL_REDDIM}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {TextColor3 = COL_DIM}):Play()
    TweenService:Create(closeStroke, TweenInfo.new(0.15), {Color = COL_LINE}):Play()
end)

-- ===== Stats row (FPS / Ping / Time / Date) =====
local statsRow = Instance.new("Frame")
statsRow.Name = "StatsRow"
statsRow.Size = UDim2.new(1, -24, 0, 76)
statsRow.Position = UDim2.new(0, 12, 0, 94)
statsRow.BackgroundTransparency = 1
statsRow.Parent = main

local statsLayout = Instance.new("UIGridLayout")
statsLayout.CellPadding = UDim2.fromOffset(6, 6)
statsLayout.CellSize = UDim2.new(0.5, -3, 0, 35)
statsLayout.SortOrder = Enum.SortOrder.LayoutOrder
statsLayout.Parent = statsRow

local function makeStatCard(order, icon, label)
    local card = Instance.new("Frame")
    card.LayoutOrder = order
    card.BackgroundColor3 = COL_BG2
    card.Parent = statsRow
    corner(card, 10)
    stroke(card, COL_LINE, 1)

    local iconLbl = Instance.new("TextLabel")
    iconLbl.BackgroundTransparency = 1
    iconLbl.Size = UDim2.fromOffset(24, 24)
    iconLbl.Position = UDim2.new(0, 6, 0.5, -12)
    iconLbl.Text = icon
    iconLbl.TextColor3 = COL_RED
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.TextSize = 13
    iconLbl.Parent = card

    local capLbl = Instance.new("TextLabel")
    capLbl.BackgroundTransparency = 1
    capLbl.Size = UDim2.new(1, -36, 0, 12)
    capLbl.Position = UDim2.new(0, 32, 0, 4)
    capLbl.TextXAlignment = Enum.TextXAlignment.Left
    capLbl.Text = label
    capLbl.TextColor3 = COL_DIM
    capLbl.Font = Enum.Font.Gotham
    capLbl.TextSize = 9
    capLbl.Parent = card

    local valLbl = Instance.new("TextLabel")
    valLbl.BackgroundTransparency = 1
    valLbl.Size = UDim2.new(1, -36, 0, 16)
    valLbl.Position = UDim2.new(0, 32, 0, 16)
    valLbl.TextXAlignment = Enum.TextXAlignment.Left
    valLbl.Text = "--"
    valLbl.TextColor3 = COL_TXT
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 12
    valLbl.Parent = card

    return valLbl
end

local fpsVal  = makeStatCard(1, "⚡", "FPS")
local pingVal = makeStatCard(2, "📶", "PING")
local clockTime = makeStatCard(3, "🕒", "GIỜ")
local clockDate = makeStatCard(4, "📅", "NGÀY")

-- ===== Section label =====
local sectionLbl = Instance.new("TextLabel")
sectionLbl.BackgroundTransparency = 1
sectionLbl.Size = UDim2.new(1, -24, 0, 18)
sectionLbl.Position = UDim2.new(0, 12, 0, 176)
sectionLbl.TextXAlignment = Enum.TextXAlignment.Left
sectionLbl.Text = "THÔNG TIN MẠNG"
sectionLbl.TextColor3 = COL_DIM
sectionLbl.Font = Enum.Font.GothamBold
sectionLbl.TextSize = 10
sectionLbl.Parent = main

-- ===== Network status card =====
local netCard = Instance.new("Frame")
netCard.Size = UDim2.new(1, -24, 0, 50)
netCard.Position = UDim2.new(0, 12, 0, 198)
netCard.BackgroundColor3 = COL_BG2
netCard.Parent = main
corner(netCard, 10)
stroke(netCard, COL_LINE, 1)

local netDot = Instance.new("Frame")
netDot.Size = UDim2.fromOffset(9, 9)
netDot.Position = UDim2.new(0, 14, 0.5, -4)
netDot.BackgroundColor3 = COL_GREEN
netDot.Parent = netCard
corner(netDot, 5)

local netTitle = Instance.new("TextLabel")
netTitle.BackgroundTransparency = 1
netTitle.Size = UDim2.new(1, -60, 0, 15)
netTitle.Position = UDim2.new(0, 32, 0, 9)
netTitle.TextXAlignment = Enum.TextXAlignment.Left
netTitle.Text = "Trạng thái kết nối"
netTitle.TextColor3 = COL_TXT
netTitle.Font = Enum.Font.GothamBold
netTitle.TextSize = 12
netTitle.Parent = netCard

local netVal = Instance.new("TextLabel")
netVal.BackgroundTransparency = 1
netVal.Size = UDim2.new(1, -60, 0, 13)
netVal.Position = UDim2.new(0, 32, 0, 26)
netVal.TextXAlignment = Enum.TextXAlignment.Left
netVal.Text = "Đang kiểm tra..."
netVal.TextColor3 = COL_DIM
netVal.Font = Enum.Font.Gotham
netVal.TextSize = 10
netVal.Parent = netCard

-- ===== Footer =====
local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 1, -30)
footer.BackgroundColor3 = COL_BG1
footer.BorderSizePixel = 0
footer.Parent = main

local footerLine = Instance.new("Frame")
footerLine.Size = UDim2.new(1, 0, 0, 1)
footerLine.BackgroundColor3 = COL_LINE
footerLine.BorderSizePixel = 0
footerLine.Parent = footer

local footerLeft = Instance.new("TextLabel")
footerLeft.BackgroundTransparency = 1
footerLeft.Size = UDim2.new(0.5, -12, 1, 0)
footerLeft.Position = UDim2.new(0, 12, 0, 0)
footerLeft.TextXAlignment = Enum.TextXAlignment.Left
footerLeft.Text = "RYZEN CONFIG v3.0"
footerLeft.TextColor3 = COL_DIM
footerLeft.Font = Enum.Font.Gotham
footerLeft.TextSize = 10
footerLeft.Parent = footer

local footerRight = Instance.new("TextLabel")
footerRight.BackgroundTransparency = 1
footerRight.Size = UDim2.new(0.5, -12, 1, 0)
footerRight.Position = UDim2.new(0.5, 0, 0, 0)
footerRight.TextXAlignment = Enum.TextXAlignment.Right
footerRight.Text = "Made by Kaibeo"
footerRight.TextColor3 = COL_RED
footerRight.Font = Enum.Font.GothamBold
footerRight.TextSize = 10
footerRight.Parent = footer

-- ===================== TOGGLE BUTTON (bật/tắt UI) =====================
-- Nút nổi để ẩn/hiện toàn bộ bảng main, luôn hiển thị góc màn hình
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Text = ""
toggleBtn.Size = UDim2.fromOffset(44, 44)
toggleBtn.Position = UDim2.new(0, 20, 0, 20)
toggleBtn.BackgroundColor3 = COL_BG1
toggleBtn.AutoButtonColor = false
toggleBtn.ZIndex = 50
toggleBtn.Visible = false -- hiện sau khi loading xong
toggleBtn.Parent = screenGui
corner(toggleBtn, 10)
local toggleStroke = stroke(toggleBtn, COL_RED, 1.5)

-- gradient nền nhẹ cho hiệu ứng cyber
local toggleGradient = Instance.new("UIGradient")
toggleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 10, 12)),
    ColorSequenceKeypoint.new(1, COL_BG1),
})
toggleGradient.Rotation = 90
toggleGradient.Parent = toggleBtn

-- góc cắt kiểu tech (2 vạch chéo nhỏ ở góc trên-trái & dưới-phải)
local cornerTick1 = Instance.new("Frame")
cornerTick1.Size = UDim2.fromOffset(10, 2)
cornerTick1.Position = UDim2.fromOffset(4, 4)
cornerTick1.BackgroundColor3 = COL_RED
cornerTick1.BorderSizePixel = 0
cornerTick1.ZIndex = 51
cornerTick1.Parent = toggleBtn

local cornerTick2 = Instance.new("Frame")
cornerTick2.Size = UDim2.fromOffset(2, 10)
cornerTick2.Position = UDim2.fromOffset(4, 4)
cornerTick2.BackgroundColor3 = COL_RED
cornerTick2.BorderSizePixel = 0
cornerTick2.ZIndex = 51
cornerTick2.Parent = toggleBtn

local cornerTick3 = Instance.new("Frame")
cornerTick3.Size = UDim2.fromOffset(10, 2)
cornerTick3.Position = UDim2.new(1, -14, 1, -6)
cornerTick3.BackgroundColor3 = COL_RED
cornerTick3.BorderSizePixel = 0
cornerTick3.ZIndex = 51
cornerTick3.Parent = toggleBtn

local cornerTick4 = Instance.new("Frame")
cornerTick4.Size = UDim2.fromOffset(2, 10)
cornerTick4.Position = UDim2.new(1, -6, 1, -14)
cornerTick4.BackgroundColor3 = COL_RED
cornerTick4.BorderSizePixel = 0
cornerTick4.ZIndex = 51
cornerTick4.Parent = toggleBtn

-- icon trung tâm dạng "power / circuit" bằng ký tự tech thay vì chữ R
local toggleIcon = Instance.new("TextLabel")
toggleIcon.BackgroundTransparency = 1
toggleIcon.Size = UDim2.fromScale(1, 1)
toggleIcon.Text = "⌁"
toggleIcon.TextColor3 = COL_RED
toggleIcon.Font = Enum.Font.GothamBlack
toggleIcon.TextSize = 22
toggleIcon.ZIndex = 51
toggleIcon.Parent = toggleBtn

-- glow mờ phía sau nút, sáng lên khi hover
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

-- kéo thả cho nút toggle
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
   
local FastAttackModule = {}
FastAttackModule.Rate = 0.1 -- Attack rate in seconds

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

InitializeHitRegistration()

function HitRegistrationModule.Execute()
    local LocalPlayer = game.Players.LocalPlayer
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local hitTargets = {}
    
    local Enemies = workspace.Enemies
    local Characters = workspace.Characters

    local function ScanFolder(folder)
        local children = folder:GetChildren()
        for i = 1, #children do
            local target = children[i]
            local humanoid = target:FindFirstChild("Humanoid")
            local rootPart = target:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 and target ~= character then
                local distance = (rootPart.Position - humanoidRootPart.Position).Magnitude
                if distance <= 60 then
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
        
        local seed = Modules.Net.seed:InvokeServer()
        
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

-- Disable Camera Shake (Optional)
local function DisableCameraShake()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local cameraModule = require(ReplicatedStorage.Util.CameraShaker)
    cameraModule:Stop()
end

-- Main Loop
local function StartMainLoops()
    task.spawn(function()
        while task.wait(FastAttackModule.Rate) do
            FastAttackModule.ExecuteFastAttack()
        end
    end)

    local RunService = game:GetService("RunService")
    RunService.Heartbeat:Connect(function()
        pcall(HitRegistrationModule.Execute)
    end)
end

-- Initialize
StartMainLoops()

local plr = game.Players.LocalPlayer
local Root = plr.Character.HumanoidRootPart
local PosMon = Vector3.new(0,0,0)
local Mon = nil

BringEnemy = function()
    -- Xoá connections cũ
    for i, v in ipairs(BringConnections) do
        v:Disconnect()
    end
    BringConnections = {}
    
    -- Thiết lập mob cần kéo
    Mon = plr.Character:FindFirstChild("HumanoidRootPart") and game.Workspace.Enemies:FindFirstChildOfClass("Model")
    
    if Mon then
        -- Kết nối cập nhật vị trí
        table.insert(BringConnections, game:GetService("RunService").Heartbeat:Connect(function()
            -- Kiểm tra mob còn sống
            if Mon and Mon:FindFirstChild("Humanoid") and Mon.Humanoid.Health > 0 then
                local root = Mon.HumanoidRootPart
                local hum = Mon.Humanoid
                local targetPos = PosMon
                
                if root and hum then
                    -- Kiểm tra khoảng cách
                    local dist = (root.Position - Root.Position).Magnitude
                    local AreaMob = dist <= 5
                    
                    -- Nếu mob gần nhân vật
                    if AreaMob then
                        root.CFrame = Root.CFrame + Root.CFrame.LookVector * 10
                    else
                        -- Kéo mob lại nếu là network owner và chưa ở gần
                        if not AreaMob and root:FindFirstChildOfClass("RenderStepped") == nil then
                            root.CFrame = CFrame.new(targetPos)
                        end
                        
                        -- Tắt va chạm và ngăn di chuyển
                        root.CanCollide = false
                        hum.WalkSpeed = 0
                        hum.JumpPower = 0
                    end
                end
            end
        end))
    end
end

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local placeId = game.PlaceId

-- Configuration
local IDLE_TIME_REQUIRED = 60 -- 1 phút đứng im
local POSITION_TOLERANCE = 0.5 -- độ chính xác phát hiện chuyển động
local SERVERS_TO_CHECK = 30

-- State tracking
local lastPosition = humanoidRootPart.Position
local idleStartTime = tick()



-- Function to get empty servers
local function getEmptyServers()
    local servers = {}
    local cursor = ""
    
    while #servers < SERVERS_TO_CHECK do
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
            if server.playing < 5 then -- Servers có < 5 người
                table.insert(servers, server.id)
            end
            if #servers >= SERVERS_TO_CHECK then break end
        end
        
        cursor = data.nextPageCursor
        if not cursor then break end
    end
    
    return servers
end

-- Function to hop server
local function hopServer()
    print("🚀 Phát hiện idle 1 phút - đang hop server...")
    
    local servers = getEmptyServers()
    
    if #servers == 0 then
        print("⚠️  Không tìm thấy server trống, thử lại...")
        wait(2)
        return
    end
    
    local randomServer = servers[math.random(1, #servers)]
    print("🌍 Hop sang server: " .. randomServer)
    
    TeleportService:TeleportToPlaceInstance(placeId, randomServer, player)
end

-- Main loop - check idle status
print("✅ Auto Hopper Started - đứng yên 1 phút sẽ hop server")

while character.Parent and humanoid.Health > 0 do
    local currentPosition = humanoidRootPart.Position
    local distanceMoved = (currentPosition - lastPosition).Magnitude
    
    -- Nếu di chuyển > tolerance, reset timer
    if distanceMoved > POSITION_TOLERANCE then
        lastPosition = currentPosition
        idleStartTime = tick()
    end
    
    -- Tính thời gian idle (chỉ check vị trí)
    local elapsedIdle = tick() - idleStartTime
    
    -- Nếu đứng im 60 giây, hop server
    if elapsedIdle >= IDLE_TIME_REQUIRED then
        hopServer()
        idleStartTime = tick() -- Reset sau khi hop
    elseif elapsedIdle > 0 and elapsedIdle % 10 < 0.5 then -- Log mỗi 10 giây
        print(string.format("⏱️  Đứng yên: %ds / 60s", math.floor(elapsedIdle)))
    end
    
    wait(0.5)
end
print("❌ Script dừng")

loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaCat-kaitunBF.lua"))()