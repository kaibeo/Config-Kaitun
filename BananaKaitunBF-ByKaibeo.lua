-- ============================================
-- ROBLOX UI - KAITUN BF CONFIG (v1.3 - Compact)
-- Tông ĐỎ - ĐEN | Icon tự vẽ 100% bằng Frame/UICorner (không emoji, không ảnh ngoài)
-- ============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================
-- BẢNG MÀU CHỦ ĐẠO (ĐỎ - ĐEN)
-- ============================================
local PALETTE = {
	Background   = Color3.fromRGB(10, 10, 12),
	HeaderBg     = Color3.fromRGB(22, 12, 14),
	Red          = Color3.fromRGB(220, 30, 45),
	RedBright    = Color3.fromRGB(255, 60, 70),
	RedDim       = Color3.fromRGB(120, 20, 28),
	StrokeGray   = Color3.fromRGB(60, 45, 46),
	TextWhite    = Color3.fromRGB(235, 235, 235),
	TextGray     = Color3.fromRGB(150, 140, 140),
	ValueBg      = Color3.fromRGB(24, 15, 17),
}

-- ============================================
-- SCREEN GUI
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KaitunBFUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 10
screenGui.Parent = playerGui

-- ============================================
-- MAIN PANEL (thu nhỏ)
-- ============================================
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 260, 0, 220)
mainPanel.Position = UDim2.new(0.5, -130, 0.5, -110)
mainPanel.BackgroundColor3 = PALETTE.Background
mainPanel.BorderSizePixel = 0
mainPanel.Visible = false -- ẩn ban đầu, chỉ hiện sau khi loading xong
mainPanel.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainPanel

local stroke = Instance.new("UIStroke")
stroke.Color = PALETTE.Red
stroke.Thickness = 1.2
stroke.Transparency = 0.25
stroke.Parent = mainPanel

local glow = Instance.new("Frame")
glow.Name = "Glow"
glow.Size = UDim2.new(1, 14, 1, 14)
glow.Position = UDim2.new(0, -7, 0, -7)
glow.BackgroundColor3 = PALETTE.Red
glow.BackgroundTransparency = 0.93
glow.BorderSizePixel = 0
glow.ZIndex = 0
glow.Parent = mainPanel

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 16)
glowCorner.Parent = glow

-- ============================================
-- HEADER
-- ============================================
local headerPanel = Instance.new("Frame")
headerPanel.Name = "HeaderPanel"
headerPanel.Size = UDim2.new(1, 0, 0, 40)
headerPanel.Position = UDim2.new(0, 0, 0, 0)
headerPanel.BackgroundColor3 = PALETTE.HeaderBg
headerPanel.BorderSizePixel = 0
headerPanel.Parent = mainPanel

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = headerPanel

local headerMask = Instance.new("Frame")
headerMask.Name = "HeaderMask"
headerMask.Size = UDim2.new(1, 0, 0, 12)
headerMask.Position = UDim2.new(0, 0, 1, -12)
headerMask.BackgroundColor3 = PALETTE.HeaderBg
headerMask.BorderSizePixel = 0
headerMask.ZIndex = 1
headerMask.Parent = headerPanel

local headerLine = Instance.new("Frame")
headerLine.Name = "HeaderLine"
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 1, 0)
headerLine.BackgroundColor3 = PALETTE.Red
headerLine.BackgroundTransparency = 0.3
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 2
headerLine.Parent = headerPanel

-- ============================================
-- ICON HEADER TỰ VẼ: KIẾM CHÉO SÚNG (đơn giản, nhỏ)
-- Kiếm: 1 thanh dọc (lưỡi) + 1 thanh ngang nhỏ (chuôi), xoay 45°
-- Súng: 1 khối chữ nhật ngang (nòng) + 1 khối vuông nhỏ (báng), xoay -45°
-- ============================================
local iconHolder = Instance.new("Frame")
iconHolder.Name = "IconHolder"
iconHolder.Size = UDim2.new(0, 26, 0, 26)
iconHolder.Position = UDim2.new(0, 8, 0.5, -13)
iconHolder.BackgroundTransparency = 1
iconHolder.ZIndex = 3
iconHolder.Parent = headerPanel

-- Nền tròn nhỏ phía sau (đế icon)
local iconBg = Instance.new("Frame")
iconBg.Size = UDim2.new(1, 0, 1, 0)
iconBg.BackgroundColor3 = PALETTE.ValueBg
iconBg.BorderSizePixel = 0
iconBg.ZIndex = 3
iconBg.Parent = iconHolder
local iconBgCorner = Instance.new("UICorner")
iconBgCorner.CornerRadius = UDim.new(1, 0)
iconBgCorner.Parent = iconBg
local iconBgStroke = Instance.new("UIStroke")
iconBgStroke.Color = PALETTE.RedDim
iconBgStroke.Thickness = 1
iconBgStroke.Parent = iconBg

-- Lưỡi kiếm (thanh chéo trắng-đỏ)
local swordBlade = Instance.new("Frame")
swordBlade.Size = UDim2.new(0, 3, 0, 16)
swordBlade.Position = UDim2.new(0.5, -1.5, 0.5, -8)
swordBlade.Rotation = -40
swordBlade.BackgroundColor3 = PALETTE.TextWhite
swordBlade.BorderSizePixel = 0
swordBlade.ZIndex = 4
swordBlade.Parent = iconHolder
local swordBladeCorner = Instance.new("UICorner")
swordBladeCorner.CornerRadius = UDim.new(1, 0)
swordBladeCorner.Parent = swordBlade

-- Chuôi kiếm (thanh ngang nhỏ đỏ, cắt lưỡi kiếm)
local swordHilt = Instance.new("Frame")
swordHilt.Size = UDim2.new(0, 7, 0, 2)
swordHilt.Position = UDim2.new(0.5, -3.5, 0.72, -1)
swordHilt.Rotation = -40
swordHilt.BackgroundColor3 = PALETTE.RedBright
swordHilt.BorderSizePixel = 0
swordHilt.ZIndex = 5
swordHilt.Parent = iconHolder
local swordHiltCorner = Instance.new("UICorner")
swordHiltCorner.CornerRadius = UDim.new(1, 0)
swordHiltCorner.Parent = swordHilt

-- Nòng súng (thanh chéo đỏ đậm, chéo ngược lại)
local gunBarrel = Instance.new("Frame")
gunBarrel.Size = UDim2.new(0, 3, 0, 13)
gunBarrel.Position = UDim2.new(0.5, -1.5, 0.42, -6.5)
gunBarrel.Rotation = 40
gunBarrel.BackgroundColor3 = PALETTE.RedBright
gunBarrel.BorderSizePixel = 0
gunBarrel.ZIndex = 4
gunBarrel.Parent = iconHolder
local gunBarrelCorner = Instance.new("UICorner")
gunBarrelCorner.CornerRadius = UDim.new(1, 0)
gunBarrelCorner.Parent = gunBarrel

-- Báng súng (khối nhỏ ở đuôi nòng)
local gunGrip = Instance.new("Frame")
gunGrip.Size = UDim2.new(0, 5, 0, 5)
gunGrip.Position = UDim2.new(0.72, -2.5, 0.68, -2.5)
gunGrip.Rotation = 40
gunGrip.BackgroundColor3 = PALETTE.RedDim
gunGrip.BorderSizePixel = 0
gunGrip.ZIndex = 4
gunGrip.Parent = iconHolder
local gunGripCorner = Instance.new("UICorner")
gunGripCorner.CornerRadius = UDim.new(0, 2)
gunGripCorner.Parent = gunGrip

-- ============================================
-- TIÊU ĐỀ (rút gọn)
-- ============================================
local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -100, 0, 16)
titleText.Position = UDim2.new(0, 40, 0, 6)
titleText.BackgroundTransparency = 1
titleText.TextColor3 = PALETTE.TextWhite
titleText.TextSize = 13
titleText.Font = Enum.Font.GothamBold
titleText.Text = "KAITUN BF"
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.ZIndex = 3
titleText.Parent = headerPanel

local subtitleText = Instance.new("TextLabel")
subtitleText.Name = "SubtitleText"
subtitleText.Size = UDim2.new(1, -100, 0, 12)
subtitleText.Position = UDim2.new(0, 40, 0, 21)
subtitleText.BackgroundTransparency = 1
subtitleText.TextColor3 = PALETTE.Red
subtitleText.TextSize = 10
subtitleText.Font = Enum.Font.Gotham
subtitleText.Text = "by Kaibeo · v1.3"
subtitleText.TextXAlignment = Enum.TextXAlignment.Left
subtitleText.ZIndex = 3
subtitleText.Parent = headerPanel

-- ============================================
-- TOGGLE SWITCH TỰ VẼ (bật/tắt UI) - nhỏ gọn
-- ============================================
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0, 32, 0, 16)
toggleBtn.Position = UDim2.new(1, -70, 0.5, -8)
toggleBtn.BackgroundColor3 = PALETTE.Red
toggleBtn.Text = ""
toggleBtn.AutoButtonColor = false
toggleBtn.ZIndex = 3
toggleBtn.Parent = headerPanel

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = PALETTE.RedBright
toggleStroke.Thickness = 1
toggleStroke.Transparency = 0.2
toggleStroke.Parent = toggleBtn

local toggleKnob = Instance.new("Frame")
toggleKnob.Name = "Knob"
toggleKnob.Size = UDim2.new(0, 12, 0, 12)
toggleKnob.Position = UDim2.new(1, -14, 0.5, -6) -- ON (phải)
toggleKnob.BackgroundColor3 = PALETTE.TextWhite
toggleKnob.BorderSizePixel = 0
toggleKnob.ZIndex = 4
toggleKnob.Parent = toggleBtn

local toggleKnobCorner = Instance.new("UICorner")
toggleKnobCorner.CornerRadius = UDim.new(1, 0)
toggleKnobCorner.Parent = toggleKnob

-- Nút đóng tự vẽ (dấu X)
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -30, 0.5, -11)
closeBtn.BackgroundColor3 = PALETTE.ValueBg
closeBtn.Text = ""
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 3
closeBtn.Parent = headerPanel

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 6)
closeBtnCorner.Parent = closeBtn

local closeBtnStroke = Instance.new("UIStroke")
closeBtnStroke.Color = PALETTE.RedDim
closeBtnStroke.Thickness = 1
closeBtnStroke.Parent = closeBtn

local xBar1 = Instance.new("Frame")
xBar1.Size = UDim2.new(0, 11, 0, 2)
xBar1.Position = UDim2.new(0.5, -5.5, 0.5, -1)
xBar1.Rotation = 45
xBar1.BackgroundColor3 = PALETTE.RedBright
xBar1.BorderSizePixel = 0
xBar1.ZIndex = 4
xBar1.Parent = closeBtn
local xBar1Corner = Instance.new("UICorner")
xBar1Corner.CornerRadius = UDim.new(1, 0)
xBar1Corner.Parent = xBar1

local xBar2 = xBar1:Clone()
xBar2.Rotation = -45
xBar2.Parent = closeBtn

-- ============================================
-- CONTENT PANEL
-- ============================================
local contentPanel = Instance.new("Frame")
contentPanel.Name = "ContentPanel"
contentPanel.Size = UDim2.new(1, -16, 1, -66)
contentPanel.Position = UDim2.new(0, 8, 0, 46)
contentPanel.BackgroundTransparency = 1
contentPanel.BorderSizePixel = 0
contentPanel.Parent = mainPanel

-- ============================================
-- ICON RIÊNG CHO TỪNG DÒNG STATUS - đơn giản: 1 chữ cái viết tắt trong khung vuông nhỏ
-- (thay cho icon kim cương lặp lại cầu kỳ trước đây)
-- ============================================
local function createMiniIcon(parent, letter)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(0, 18, 0, 18)
	holder.Position = UDim2.new(0, 0, 0.5, -9)
	holder.BackgroundColor3 = PALETTE.ValueBg
	holder.BorderSizePixel = 0
	holder.Parent = parent

	local holderCorner = Instance.new("UICorner")
	holderCorner.CornerRadius = UDim.new(0, 5)
	holderCorner.Parent = holder

	local holderStroke = Instance.new("UIStroke")
	holderStroke.Color = PALETTE.RedDim
	holderStroke.Thickness = 1
	holderStroke.Parent = holder

	local letterLbl = Instance.new("TextLabel")
	letterLbl.Size = UDim2.new(1, 0, 1, 0)
	letterLbl.BackgroundTransparency = 1
	letterLbl.TextColor3 = PALETTE.RedBright
	letterLbl.TextSize = 11
	letterLbl.Font = Enum.Font.GothamBold
	letterLbl.Text = letter
	letterLbl.Parent = holder

	return holder
end

-- ============================================
-- STATUS BAR NÂNG CẤP (kiểu Maru, tông đỏ-đen)
-- - Chấm trạng thái nhấp nháy nhẹ (pulse) đầu icon
-- - Viền value box sáng dần khi giá trị cập nhật (flash hiệu ứng)
-- - Có thể tô màu value theo mức tốt/xấu (dùng cho Ping/FPS)
-- ============================================
local function createStatusBar(parent, labelText, iconLetter, yPos)
	local statusContainer = Instance.new("Frame")
	statusContainer.Name = labelText .. "Container"
	statusContainer.Size = UDim2.new(1, 0, 0, 26)
	statusContainer.Position = UDim2.new(0, 0, 0, yPos)
	statusContainer.BackgroundTransparency = 1
	statusContainer.Parent = parent

	local iconHolder = createMiniIcon(statusContainer, iconLetter)

	-- Chấm trạng thái nhỏ ở góc icon, nhấp nháy liên tục cho cảm giác "live"
	local pulseDot = Instance.new("Frame")
	pulseDot.Name = "PulseDot"
	pulseDot.Size = UDim2.new(0, 6, 0, 6)
	pulseDot.AnchorPoint = Vector2.new(0.5, 0.5)
	pulseDot.Position = UDim2.new(1, 1, 0, 1)
	pulseDot.BackgroundColor3 = PALETTE.RedBright
	pulseDot.BorderSizePixel = 0
	pulseDot.ZIndex = 5
	pulseDot.Parent = iconHolder
	local pulseDotCorner = Instance.new("UICorner")
	pulseDotCorner.CornerRadius = UDim.new(1, 0)
	pulseDotCorner.Parent = pulseDot
	local pulseGlow = Instance.new("UIStroke")
	pulseGlow.Color = PALETTE.RedBright
	pulseGlow.Thickness = 2
	pulseGlow.Transparency = 0.5
	pulseGlow.Parent = pulseDot

	task.spawn(function()
		-- lệch pha nhẹ theo yPos để các chấm không nhấp nháy cùng lúc, nhìn sống động hơn
		task.wait(yPos * 0.006)
		while pulseDot.Parent do
			TweenService:Create(pulseDot, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.7}):Play()
			TweenService:Create(pulseGlow, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {Transparency = 1}):Play()
			task.wait(0.6)
			TweenService:Create(pulseDot, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {BackgroundTransparency = 0}):Play()
			TweenService:Create(pulseGlow, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {Transparency = 0.5}):Play()
			task.wait(0.6)
		end
	end)

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(0, 58, 1, 0)
	label.Position = UDim2.new(0, 24, 0, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = PALETTE.TextGray
	label.TextSize = 12
	label.Font = Enum.Font.GothamMedium
	label.Text = labelText
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = statusContainer

	local valueBg = Instance.new("Frame")
	valueBg.Name = "ValueBg"
	valueBg.Size = UDim2.new(1, -84, 1, -4)
	valueBg.Position = UDim2.new(0, 82, 0, 2)
	valueBg.BackgroundColor3 = PALETTE.ValueBg
	valueBg.BorderSizePixel = 0
	valueBg.ClipsDescendants = true
	valueBg.Parent = statusContainer

	local valueBgCorner = Instance.new("UICorner")
	valueBgCorner.CornerRadius = UDim.new(0, 6)
	valueBgCorner.Parent = valueBg

	local valueBgStroke = Instance.new("UIStroke")
	valueBgStroke.Color = PALETTE.StrokeGray
	valueBgStroke.Thickness = 1
	valueBgStroke.Transparency = 0.3
	valueBgStroke.Parent = valueBg

	-- Gradient nền rất nhẹ cho value box, tạo chiều sâu thay vì phẳng 1 màu
	local valueBgGradient = Instance.new("UIGradient")
	valueBgGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 18, 20)),
		ColorSequenceKeypoint.new(1, PALETTE.ValueBg),
	})
	valueBgGradient.Rotation = 0
	valueBgGradient.Parent = valueBg

	local accentBar = Instance.new("Frame")
	accentBar.Size = UDim2.new(0, 2, 1, -6)
	accentBar.Position = UDim2.new(0, 3, 0, 3)
	accentBar.BackgroundColor3 = PALETTE.Red
	accentBar.BorderSizePixel = 0
	accentBar.Parent = valueBg
	local accentCorner = Instance.new("UICorner")
	accentCorner.CornerRadius = UDim.new(1, 0)
	accentCorner.Parent = accentBar

	local valueText = Instance.new("TextLabel")
	valueText.Name = "ValueText"
	valueText.Size = UDim2.new(1, -14, 1, 0)
	valueText.Position = UDim2.new(0, 10, 0, 0)
	valueText.BackgroundTransparency = 1
	valueText.TextColor3 = PALETTE.RedBright
	valueText.TextSize = 12
	valueText.Font = Enum.Font.GothamMedium
	valueText.Text = "..."
	valueText.TextXAlignment = Enum.TextXAlignment.Left
	valueText.Parent = valueBg

	-- Hiệu ứng flash nhẹ trên viền mỗi khi giá trị được cập nhật (dùng cho Ping/FPS/Giờ)
	local function flashUpdate()
		TweenService:Create(valueBgStroke, TweenInfo.new(0.08), {Color = PALETTE.RedBright, Transparency = 0}):Play()
		task.delay(0.15, function()
			TweenService:Create(valueBgStroke, TweenInfo.new(0.35), {Color = PALETTE.StrokeGray, Transparency = 0.3}):Play()
		end)
	end

	-- Hover: sáng nhẹ toàn dòng cho cảm giác tương tác được (dù chỉ để hiển thị)
	local hoverArea = Instance.new("TextButton")
	hoverArea.Size = UDim2.new(1, 0, 1, 0)
	hoverArea.BackgroundTransparency = 1
	hoverArea.Text = ""
	hoverArea.AutoButtonColor = false
	hoverArea.ZIndex = 6
	hoverArea.Parent = valueBg
	hoverArea.MouseEnter:Connect(function()
		TweenService:Create(valueBg, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
		TweenService:Create(valueBgStroke, TweenInfo.new(0.15), {Transparency = 0.05}):Play()
	end)
	hoverArea.MouseLeave:Connect(function()
		TweenService:Create(valueBgStroke, TweenInfo.new(0.15), {Transparency = 0.3}):Play()
	end)

	return statusContainer, valueText, flashUpdate
end

-- 5 dòng: Username, Thời gian, Ping, FPS, Trạng thái (mỗi dòng cách nhau 28px, vừa đủ trong panel 220 cao)
local statusUsername, usernameValue, flashUsername = createStatusBar(contentPanel, "User", "U", 0)
local statusHour, hourValue, flashHour = createStatusBar(contentPanel, "Giờ", "T", 28)
local statusPing, pingValue, flashPing = createStatusBar(contentPanel, "Ping", "P", 56)
local statusFps, fpsValue, flashFps = createStatusBar(contentPanel, "FPS", "F", 84)
local statusStatus, statusValue, flashStatus = createStatusBar(contentPanel, "Status", "S", 112)

-- Hàm tô màu value theo ngưỡng tốt/vừa/xấu, cho Ping và FPS đẹp và trực quan hơn
local function colorizeByThreshold(valueLbl, num, goodMax, okMax, higherIsBetter)
	local good, ok_, bad = Color3.fromRGB(90, 220, 130), PALETTE.RedBright, Color3.fromRGB(255, 90, 90)
	if higherIsBetter then
		if num >= goodMax then valueLbl.TextColor3 = good
		elseif num >= okMax then valueLbl.TextColor3 = ok_
		else valueLbl.TextColor3 = bad end
	else
		if num <= goodMax then valueLbl.TextColor3 = good
		elseif num <= okMax then valueLbl.TextColor3 = ok_
		else valueLbl.TextColor3 = bad end
	end
end

-- ============================================
-- NÚT NỔI (FLOATING BUTTON) - nhỏ gọn, icon kiếm-súng mini
-- ============================================
local floatBtn = Instance.new("TextButton")
floatBtn.Name = "FloatButton"
floatBtn.Size = UDim2.new(0, 34, 0, 34)
floatBtn.Position = UDim2.new(0, 16, 0, 16)
floatBtn.BackgroundColor3 = PALETTE.Background
floatBtn.Text = ""
floatBtn.AutoButtonColor = false
floatBtn.Visible = false
floatBtn.Parent = screenGui

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(1, 0)
floatCorner.Parent = floatBtn

local floatStroke = Instance.new("UIStroke")
floatStroke.Color = PALETTE.Red
floatStroke.Thickness = 1.2
floatStroke.Transparency = 0.2
floatStroke.Parent = floatBtn

local floatBlade = Instance.new("Frame")
floatBlade.Size = UDim2.new(0, 2, 0, 12)
floatBlade.Position = UDim2.new(0.5, -1, 0.5, -6)
floatBlade.Rotation = -40
floatBlade.BackgroundColor3 = PALETTE.TextWhite
floatBlade.BorderSizePixel = 0
floatBlade.Parent = floatBtn
local floatBladeCorner = Instance.new("UICorner")
floatBladeCorner.CornerRadius = UDim.new(1, 0)
floatBladeCorner.Parent = floatBlade

local floatBarrel = Instance.new("Frame")
floatBarrel.Size = UDim2.new(0, 2, 0, 10)
floatBarrel.Position = UDim2.new(0.5, -1, 0.42, -5)
floatBarrel.Rotation = 40
floatBarrel.BackgroundColor3 = PALETTE.RedBright
floatBarrel.BorderSizePixel = 0
floatBarrel.Parent = floatBtn
local floatBarrelCorner = Instance.new("UICorner")
floatBarrelCorner.CornerRadius = UDim.new(1, 0)
floatBarrelCorner.Parent = floatBarrel

-- ============================================
-- LOADING SCREEN (hiện khi UI khởi tạo, tông đỏ-đen, icon tự vẽ)
-- ============================================
local loadingScreen = Instance.new("Frame")
loadingScreen.Name = "LoadingScreen"
loadingScreen.Size = UDim2.new(1, 0, 1, 0)
loadingScreen.BackgroundColor3 = PALETTE.Background
loadingScreen.BackgroundTransparency = 0
loadingScreen.BorderSizePixel = 0
loadingScreen.ZIndex = 50
loadingScreen.Parent = screenGui

-- Khối icon giữa màn hình (kiếm chéo súng, to hơn, xoay nhẹ khi loading)
local loadIconHolder = Instance.new("Frame")
loadIconHolder.Size = UDim2.new(0, 54, 0, 54)
loadIconHolder.Position = UDim2.new(0.5, -27, 0.5, -70)
loadIconHolder.BackgroundColor3 = PALETTE.ValueBg
loadIconHolder.BorderSizePixel = 0
loadIconHolder.ZIndex = 51
loadIconHolder.Parent = loadingScreen

local loadIconCorner = Instance.new("UICorner")
loadIconCorner.CornerRadius = UDim.new(1, 0)
loadIconCorner.Parent = loadIconHolder

local loadIconStroke = Instance.new("UIStroke")
loadIconStroke.Color = PALETTE.Red
loadIconStroke.Thickness = 1.5
loadIconStroke.Transparency = 0.15
loadIconStroke.ZIndex = 51
loadIconStroke.Parent = loadIconHolder

local loadBlade = Instance.new("Frame")
loadBlade.Size = UDim2.new(0, 4, 0, 26)
loadBlade.Position = UDim2.new(0.5, -2, 0.5, -13)
loadBlade.Rotation = -40
loadBlade.BackgroundColor3 = PALETTE.TextWhite
loadBlade.BorderSizePixel = 0
loadBlade.ZIndex = 52
loadBlade.Parent = loadIconHolder
local loadBladeCorner = Instance.new("UICorner")
loadBladeCorner.CornerRadius = UDim.new(1, 0)
loadBladeCorner.Parent = loadBlade

local loadBarrel = Instance.new("Frame")
loadBarrel.Size = UDim2.new(0, 4, 0, 21)
loadBarrel.Position = UDim2.new(0.5, -2, 0.42, -10.5)
loadBarrel.Rotation = 40
loadBarrel.BackgroundColor3 = PALETTE.RedBright
loadBarrel.BorderSizePixel = 0
loadBarrel.ZIndex = 52
loadBarrel.Parent = loadIconHolder
local loadBarrelCorner = Instance.new("UICorner")
loadBarrelCorner.CornerRadius = UDim.new(1, 0)
loadBarrelCorner.Parent = loadBarrel

-- Vòng xoay quanh icon (hiệu ứng loading spinner tự vẽ, chỉ hiện 1 cung tròn bằng 4 chấm)
local spinnerDots = {}
for i = 1, 8 do
	local angle = (i - 1) * (360 / 8)
	local dot = Instance.new("Frame")
	dot.Size = UDim2.new(0, 5, 0, 5)
	dot.AnchorPoint = Vector2.new(0.5, 0.5)
	dot.Position = UDim2.new(0.5, 34 * math.cos(math.rad(angle)), 0.5, 34 * math.sin(math.rad(angle)))
	dot.BackgroundColor3 = PALETTE.Red
	dot.BackgroundTransparency = 0.7
	dot.BorderSizePixel = 0
	dot.ZIndex = 51
	dot.Parent = loadIconHolder
	local dotCorner = Instance.new("UICorner")
	dotCorner.CornerRadius = UDim.new(1, 0)
	dotCorner.Parent = dot
	table.insert(spinnerDots, dot)
end

-- Tiêu đề loading
local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(0, 260, 0, 22)
loadTitle.Position = UDim2.new(0.5, -130, 0.5, -6)
loadTitle.BackgroundTransparency = 1
loadTitle.TextColor3 = PALETTE.TextWhite
loadTitle.TextSize = 16
loadTitle.Font = Enum.Font.GothamBold
loadTitle.Text = ""
loadTitle.ZIndex = 51
loadTitle.Parent = loadingScreen

-- Dòng chữ trạng thái (hiệu ứng chạy chữ dần từng ký tự, đổi text theo tiến trình)
local loadStatusText = Instance.new("TextLabel")
loadStatusText.Size = UDim2.new(0, 260, 0, 16)
loadStatusText.Position = UDim2.new(0.5, -130, 0.5, 18)
loadStatusText.BackgroundTransparency = 1
loadStatusText.TextColor3 = PALETTE.TextGray
loadStatusText.TextSize = 11
loadStatusText.Font = Enum.Font.Gotham
loadStatusText.Text = ""
loadStatusText.ZIndex = 51
loadStatusText.Parent = loadingScreen

-- Khung progress bar
local progressBarBg = Instance.new("Frame")
progressBarBg.Size = UDim2.new(0, 200, 0, 6)
progressBarBg.Position = UDim2.new(0.5, -100, 0.5, 44)
progressBarBg.BackgroundColor3 = PALETTE.ValueBg
progressBarBg.BorderSizePixel = 0
progressBarBg.ZIndex = 51
progressBarBg.Parent = loadingScreen

local progressBarBgCorner = Instance.new("UICorner")
progressBarBgCorner.CornerRadius = UDim.new(1, 0)
progressBarBgCorner.Parent = progressBarBg

local progressBarBgStroke = Instance.new("UIStroke")
progressBarBgStroke.Color = PALETTE.StrokeGray
progressBarBgStroke.Thickness = 1
progressBarBgStroke.Transparency = 0.3
progressBarBgStroke.Parent = progressBarBg

local progressBarFill = Instance.new("Frame")
progressBarFill.Size = UDim2.new(0, 0, 1, 0)
progressBarFill.BackgroundColor3 = PALETTE.Red
progressBarFill.BorderSizePixel = 0
progressBarFill.ZIndex = 52
progressBarFill.Parent = progressBarBg

local progressBarFillCorner = Instance.new("UICorner")
progressBarFillCorner.CornerRadius = UDim.new(1, 0)
progressBarFillCorner.Parent = progressBarFill

local progressBarGlow = Instance.new("UIStroke")
progressBarGlow.Color = PALETTE.RedBright
progressBarGlow.Thickness = 1
progressBarGlow.Transparency = 0.4
progressBarGlow.Parent = progressBarFill

-- Phần trăm loading
local progressPercent = Instance.new("TextLabel")
progressPercent.Size = UDim2.new(0, 200, 0, 14)
progressPercent.Position = UDim2.new(0.5, -100, 0.5, 54)
progressPercent.BackgroundTransparency = 1
progressPercent.TextColor3 = PALETTE.RedBright
progressPercent.TextSize = 11
progressPercent.Font = Enum.Font.GothamBold
progressPercent.Text = "0%"
progressPercent.ZIndex = 51
progressPercent.Parent = loadingScreen

-- Hàm hiệu ứng chữ chạy dần (typewriter effect) - hiện từng ký tự một
local function typewriter(label, fullText, charDelay)
	label.Text = ""
	for i = 1, #fullText do
		label.Text = string.sub(fullText, 1, i)
		task.wait(charDelay or 0.02)
	end
end

-- Luồng chạy loading: xoay spinner + tăng progress bar + đổi chữ trạng thái
task.spawn(function()
	-- Chữ tiêu đề chạy hiệu ứng typewriter
	typewriter(loadTitle, "KAITUN BF CONFIG", 0.035)

	local steps = {
		{text = "Đang kết nối server...", percent = 25},
		{text = "Đang tải dữ liệu người dùng...", percent = 55},
		{text = "Đang khởi tạo giao diện...", percent = 80},
		{text = "Hoàn tất!", percent = 100},
	}

	local spinAngle = 0
	local spinning = true

	-- Luồng xoay spinner song song
	task.spawn(function()
		while spinning do
			spinAngle += 6
			for i, dot in ipairs(spinnerDots) do
				local baseAngle = (i - 1) * (360 / 8)
				local a = baseAngle + spinAngle
				dot.Position = UDim2.new(0.5, 34 * math.cos(math.rad(a)), 0.5, 34 * math.sin(math.rad(a)))
				-- Đuôi sao chổi: chấm gần góc hiện tại sáng hơn
				local diff = (a - spinAngle) % 360
				dot.BackgroundTransparency = 0.3 + (diff / 360) * 0.6
			end
			task.wait(0.02)
		end
	end)

	for _, step in ipairs(steps) do
		typewriter(loadStatusText, step.text, 0.015)
		TweenService:Create(progressBarFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Size = UDim2.new(step.percent / 100, 0, 1, 0)}):Play()
		-- Đếm số % chạy dần
		local startPercent = tonumber(string.match(progressPercent.Text, "%d+")) or 0
		for p = startPercent, step.percent do
			progressPercent.Text = p .. "%"
			task.wait(0.008)
		end
		task.wait(0.25)
	end

	spinning = false
	task.wait(0.3)

	-- Hiệu ứng ẩn màn hình loading: fade out + icon phóng to mờ dần
	local fadeTween = TweenService:Create(loadingScreen, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
	local iconFadeTween = TweenService:Create(loadIconHolder, TweenInfo.new(0.4), {BackgroundTransparency = 1, Size = UDim2.new(0, 70, 0, 70)})
	TweenService:Create(loadTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
	TweenService:Create(loadStatusText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
	TweenService:Create(progressPercent, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
	TweenService:Create(progressBarBg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	TweenService:Create(loadIconStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
	TweenService:Create(loadBlade, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	TweenService:Create(loadBarrel, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	for _, dot in ipairs(spinnerDots) do
		TweenService:Create(dot, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	end
	fadeTween:Play()
	iconFadeTween:Play()

	fadeTween.Completed:Wait()
	loadingScreen.Visible = false
	loadingScreen:Destroy()

	-- ============================================
	-- HIỆU ỨNG BẬT UI CHÍNH LẦN ĐẦU (scale + fade vào, sau khi loading xong)
	-- ============================================
	mainPanel.Visible = true
	mainPanel.Size = UDim2.new(0, 260 * 0.85, 0, 220 * 0.85)
	mainPanel.BackgroundTransparency = 1
	stroke.Transparency = 1
	glow.BackgroundTransparency = 1

	TweenService:Create(mainPanel, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 260, 0, 220),
		BackgroundTransparency = 0,
	}):Play()
	TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0.25}):Play()
	TweenService:Create(glow, TweenInfo.new(0.3), {BackgroundTransparency = 0.93}):Play()

	-- Cập nhật lại vị trí căn giữa sau khi đổi size (vì Size neo theo offset, không neo scale/anchor)
	mainPanel.Position = UDim2.new(0.5, -130, 0.5, -110)
end)

-- ============================================
-- CẬP NHẬT DỮ LIỆU (có hiệu ứng flash + màu theo trạng thái)
-- ============================================
usernameValue.Text = player.Name
statusValue.Text = "● Online"
statusValue.TextColor3 = Color3.fromRGB(90, 220, 130)

-- Giờ: chỉ flash mỗi khi giây thay đổi, không flash liên tục mỗi frame
do
	local lastSecond = nil
	RunService.Heartbeat:Connect(function()
		local nowText = os.date("%H:%M:%S")
		if nowText ~= hourValue.Text then
			hourValue.Text = nowText
			if lastSecond then flashHour() end
			lastSecond = nowText
		end
	end)
end

-- Ping (ms) - lấy từ Stats service, tô màu xanh/đỏ/vàng theo chất lượng mạng
task.spawn(function()
	while task.wait(1) do
		local ok, ping = pcall(function()
			return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		end)
		if ok and ping then
			pingValue.Text = math.floor(ping) .. " ms"
			colorizeByThreshold(pingValue, ping, 60, 150, false) -- thấp = tốt
		else
			pingValue.Text = "N/A"
			pingValue.TextColor3 = PALETTE.TextGray
		end
		flashPing()
	end
end)

-- FPS - đo qua Heartbeat, tô màu theo mức mượt
do
	local frameCount = 0
	local fpsTimer = 0
	RunService.Heartbeat:Connect(function(dt)
		frameCount += 1
		fpsTimer += dt
		if fpsTimer >= 1 then
			fpsValue.Text = tostring(frameCount)
			colorizeByThreshold(fpsValue, frameCount, 50, 30, true) -- cao = tốt
			flashFps()
			frameCount = 0
			fpsTimer = 0
		end
	end)
end

-- ============================================
-- KIỂM SOÁT UI - BẬT/TẮT (toggle switch, nút X, nút nổi) - KHÔNG DÙNG PHÍM
-- Có hiệu ứng scale + fade mượt khi bật/tắt
-- ============================================
local uiVisible = true
local animating = false

local PANEL_SIZE = UDim2.new(0, 260, 0, 220)
local PANEL_POS = UDim2.new(0.5, -130, 0.5, -110)

local function setUIVisible(visible)
	if animating then return end
	if visible == uiVisible then return end
	animating = true
	uiVisible = visible

	-- Trượt knob của toggle switch theo trạng thái
	local knobTarget = visible and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
	local bgTarget = visible and PALETTE.Red or Color3.fromRGB(40, 35, 36)
	TweenService:Create(toggleKnob, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = knobTarget}):Play()
	TweenService:Create(toggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = bgTarget}):Play()

	if visible then
		-- BẬT: hiện nút nổi biến mất trước, panel phóng to + fade vào
		floatBtn.Visible = false
		mainPanel.Visible = true
		mainPanel.Size = UDim2.new(0, 260 * 0.85, 0, 220 * 0.85)
		mainPanel.Position = UDim2.new(0.5, -110.5, 0.5, -93.5)
		mainPanel.BackgroundTransparency = 1
		stroke.Transparency = 1
		glow.BackgroundTransparency = 1

		local tw = TweenService:Create(mainPanel, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = PANEL_SIZE,
			Position = PANEL_POS,
			BackgroundTransparency = 0,
		})
		TweenService:Create(stroke, TweenInfo.new(0.28), {Transparency = 0.25}):Play()
		TweenService:Create(glow, TweenInfo.new(0.28), {BackgroundTransparency = 0.93}):Play()
		tw:Play()
		tw.Completed:Wait()
	else
		-- TẮT: panel co lại + fade ra, sau đó hiện nút nổi với hiệu ứng bật lên
		local currentPos = mainPanel.Position
		local tw = TweenService:Create(mainPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 260 * 0.85, 0, 220 * 0.85),
			Position = UDim2.new(currentPos.X.Scale, currentPos.X.Offset + 19.5, currentPos.Y.Scale, currentPos.Y.Offset + 16.5),
			BackgroundTransparency = 1,
		})
		TweenService:Create(stroke, TweenInfo.new(0.18), {Transparency = 1}):Play()
		TweenService:Create(glow, TweenInfo.new(0.18), {BackgroundTransparency = 1}):Play()
		tw:Play()
		tw.Completed:Wait()
		mainPanel.Visible = false
		-- Reset lại size/pos/transparency để lần bật sau đúng chuẩn
		mainPanel.Size = PANEL_SIZE
		mainPanel.Position = PANEL_POS
		mainPanel.BackgroundTransparency = 0
		stroke.Transparency = 0.25
		glow.BackgroundTransparency = 0.93

		floatBtn.Visible = true
		floatBtn.Size = UDim2.new(0, 0, 0, 0)
		TweenService:Create(floatBtn, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 34, 0, 34),
		}):Play()
	end

	print("UI toggled: " .. tostring(visible))
	animating = false
end

toggleBtn.MouseButton1Click:Connect(function()
	task.spawn(setUIVisible, not uiVisible)
end)

closeBtn.MouseButton1Click:Connect(function()
	task.spawn(setUIVisible, false)
end)

closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = PALETTE.RedDim}):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = PALETTE.ValueBg}):Play()
end)

floatBtn.MouseButton1Click:Connect(function()
	task.spawn(setUIVisible, true)
end)

floatBtn.MouseEnter:Connect(function()
	TweenService:Create(floatBtn, TweenInfo.new(0.15), {BackgroundColor3 = PALETTE.HeaderBg}):Play()
end)
floatBtn.MouseLeave:Connect(function()
	TweenService:Create(floatBtn, TweenInfo.new(0.15), {BackgroundColor3 = PALETTE.Background}):Play()
end)

-- Kéo UI qua header
local dragging = false
local dragStart = nil
local startPos = nil

headerPanel.InputBegan:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainPanel.Position
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		mainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✅ UI KAITUN BF COMPACT (RED-BLACK) LOADED!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("  Bấm nút gạt hoặc nút X để ẩn UI")
print("  Bấm nút nổi để mở lại UI")
print("  Kéo tiêu đề để di chuyển")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaCat-kaitunBF.lua"))()
