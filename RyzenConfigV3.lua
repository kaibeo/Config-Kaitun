--[[
    COMBINED ENHANCED SCRIPT WITH UI v2.0
    - Bring Mob tầm gấp 4 lần (60 -> 240)
    - Auto Rejoin khi bị tween trên không 60 giây
    - Auto skill Z/X mỗi 5 phút
    - Ryzen Config UI
    - Load BananaCat addon
]]

-- ===================== SETUP BAN ĐẦU =====================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local plr = Players.LocalPlayer
local Root = plr.Character.HumanoidRootPart
local joinTime = os.clock()

-- ===================== GLOBAL VARIABLES =====================
local PosMon = Vector3.new(0, 0, 0)
local Mon = nil
local BringConnections = {}
local rejoinConnections = {}
local lastSkillTime = 0
local lastMoveTime = os.time()
local isStuck = false
local SKILL_INTERVAL = 300 -- 5 phút = 300 giây

-- ===================== COLORS (from Ryzen UI) =====================
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

-- ===================== BRING ENEMY SYSTEM =====================
local function BringEnemy()
    for i, v in ipairs(BringConnections) do
        v:Disconnect()
    end
    BringConnections = {}
    
    Mon = plr.Character:FindFirstChild("HumanoidRootPart") and game.Workspace.Enemies:FindFirstChildOfClass("Model")
    
    if Mon then
        table.insert(BringConnections, game:GetService("RunService").Heartbeat:Connect(function()
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
                        if not AreaMob and root:FindFirstChildOfClass("RenderStepped") == nil then
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
    if not folder or not character then return result end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return result end
    
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
    if not targets or #targets == 0 then return result end
    
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
    for i = 1, #enemies do table.insert(allTargets, enemies[i]) end
    for i = 1, #otherCharacters do table.insert(allTargets, otherCharacters[i]) end
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

-- ===================== AUTO REJOIN & SKILL SYSTEM =====================
local function CheckStuckStatus()
    local character = plr.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local root = character.HumanoidRootPart
    local humanoid = character:FindFirstChild("Humanoid")
    
    if humanoid and root and humanoid.Health > 0 then
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
                end)
            end
            
            if not isStuck then
                isStuck = true
                print("⚠️ Bị stuck quá 60s, đang rejoin...")
                task.wait(5)
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
            end
        end
    end
end

local function MonitorMovement()
    for _, conn in ipairs(rejoinConnections) do
        conn:Disconnect()
    end
    rejoinConnections = {}
    
    table.insert(rejoinConnections, game:GetService("RunService").Heartbeat:Connect(function()
        local character = plr.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local root = character.HumanoidRootPart
            if root.Velocity.Magnitude > 0.5 then
                lastMoveTime = os.time()
                isStuck = false
            end
        end
    end))
end

local function UseSkillPeriodically()
    task.spawn(function()
        while true do
            task.wait(SKILL_INTERVAL)
            pcall(function()
                local UIS = game:GetService("UserInputService")
                local character = plr.Character
                if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                    UIS:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                    task.wait(0.1)
                    UIS:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                    print("🔥 Skill Z activated!")
                end
            end)
        end
    end)
end

-- ===================== STARTUP =====================
plr.CharacterAdded:Connect(function(character)
    Root = character:WaitForChild("HumanoidRootPart")
    PosMon = Root.Position
    MonitorMovement()
    task.wait(1)
end)

MonitorMovement()
UseSkillPeriodically()

-- Main attack loop
task.spawn(function()
    while task.wait(FastAttackModule.Rate) do
        pcall(FastAttackModule.ExecuteFastAttack)
    end
end)

RunService.Heartbeat:Connect(function()
    pcall(HitRegistrationModule.Execute)
    pcall(CheckStuckStatus)
end)

print("✅ Script loaded successfully!")
print("📍 Bring range: 240 (4x)")
print("⏱️  Auto rejoin: 60s stuck")
print("💫 Auto skill: 5 min interval")

-- ===================== LOAD BANANA CAT =====================
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaCat-kaitunBF.lua"))()
        print("✓ BananaCat loaded!")
    end)
end)
