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

-- AGGRESSIVE WAIT - Ensure everything is loaded
print("⏳ Waiting for game to fully load...")
repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer
repeat wait() until game.Players.LocalPlayer.Character
repeat wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")
repeat wait() until workspace:FindFirstChild("Terrain")

print("✅ Game fully loaded!")

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
brandTitle.TextSize = 42
brandTitle.ZIndex = 101
brandTitle.Parent = loader

local brandSub = Instance.new("TextLabel")
brandSub.BackgroundTransparency = 1
brandSub.Size = UDim2.new(1, 0, 0, 20)
brandSub.Position = UDim2.new(0, 0, 0.53, 0)
brandSub.Text = "Blox Fruits Auto Farm"
brandSub.TextColor3 = COL_DIM
brandSub.Font = Enum.Font.Gotham
brandSub.TextSize = 14
brandSub.ZIndex = 101
brandSub.Parent = loader

local barTrack = Instance.new("Frame")
barTrack.BackgroundColor3 = COL_BG2
barTrack.Size = UDim2.new(0.5, 0, 0, 4)
barTrack.Position = UDim2.new(0.25, 0, 0.68, 0)
barTrack.BorderSizePixel = 0
barTrack.ZIndex = 101
barTrack.Parent = loader
corner(barTrack, 2)
stroke(barTrack, COL_LINE, 1)

local barFill = Instance.new("Frame")
barFill.BackgroundColor3 = COL_RED
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BorderSizePixel = 0
barFill.ZIndex = 102
barFill.Parent = barTrack
corner(barFill, 1)

local statusMsg = Instance.new("TextLabel")
statusMsg.BackgroundTransparency = 1
statusMsg.Size = UDim2.new(1, 0, 0, 20)
statusMsg.Position = UDim2.new(0, 0, 0.75, 0)
statusMsg.Text = "Initializing..."
statusMsg.TextColor3 = COL_TXT
statusMsg.Font = Enum.Font.Gotham
statusMsg.TextSize = 12
statusMsg.ZIndex = 101
statusMsg.Parent = loader

local statusPct = Instance.new("TextLabel")
statusPct.BackgroundTransparency = 1
statusPct.Size = UDim2.new(1, 0, 0, 16)
statusPct.Position = UDim2.new(0, 0, 0.81, 0)
statusPct.Text = "0%"
statusPct.TextColor3 = COL_DIM
statusPct.Font = Enum.Font.Gotham
statusPct.TextSize = 11
statusPct.ZIndex = 101
statusPct.Parent = loader

local verLabel = Instance.new("TextLabel")
verLabel.BackgroundTransparency = 1
verLabel.Size = UDim2.new(1, -20, 0, 16)
verLabel.Position = UDim2.new(0, 10, 1, -26)
verLabel.Text = "v3.0 - Banana Kaitun"
verLabel.TextColor3 = COL_DIM
verLabel.Font = Enum.Font.GothamMonospace
verLabel.TextSize = 10
verLabel.ZIndex = 101
verLabel.Parent = loader

-- Animate loading bar
local progress = 0
local animConn
animConn = RunService.Heartbeat:Connect(function()
    progress = math.min(progress + 0.02, 1)
    barFill.Size = UDim2.new(progress, 0, 1, 0)
    statusPct.Text = math.floor(progress * 100) .. "%"
    
    if progress >= 1 then
        animConn:Disconnect()
    end
end)

print("✅ RyzenConfigV3 loaded successfully!")
wait(2)

-- Hide loader after delay
loader:TweenSize(UDim2.fromScale(0, 0), "Out", "Quad", 0.5, true)
wait(0.5)
loader.Visible = false
