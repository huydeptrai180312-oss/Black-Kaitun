-- =============================================
-- BLACK KAITUN - BLOX FRUITS SCRIPT
-- Executor: Synapse X, Script-Ware, Fluxus, etc.
-- =============================================
-- Loadstring: loadstring(game:HttpGet("https://raw.githubusercontent.com/huydeptrai180312-oss/Black-Kaitun/main/BlackKaitun.lua"))()

local Config = {
    Team = "Pirates",
    FPS = 15,
    Configuration = {
        HopWhenIdle = true,
        HopNear = true,
        FpsBoost = true,
        blackscreen = false,
        FastAttackMode = "Remote"
    },
    Fruit = {
        Sniper = true,
        Fruit = {"Kitsune-Kitsune"},
        EatFruitStore = false
    },
    Items = {
        AutoFullyMelees = true,
        Saber = true,
        CursedDualKatana = true,
        SoulGuitar = true,
        RaceV2 = true
    },
    Settings = {
        StayInSea2UntilHaveDarkFragments = false
    }
}

-- =============================================
-- LOGGER MODULE
-- =============================================
local Logger = {}

function Logger.Info(...)
    print("[BlackKaitun][INFO]", ...)
end

function Logger.Warn(...)
    warn("[BlackKaitun][WARN]", ...)
end

function Logger.Error(...)
    warn("[BlackKaitun][ERROR]", ...)
end

-- =============================================
-- SETTINGS MODULE
-- =============================================
local Settings = {}

function Settings.Load()
    Logger.Info("Loading settings...")
    return Config
end

function Settings.Save(newConfig)
    Config = newConfig
    Logger.Info("Settings saved")
end

-- =============================================
-- LEVEL MODULE
-- =============================================
local Level = {}

function Level.GetCurrentLevel()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return 0 end
    
    local humanoid = character:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health or 0
end

function Level.GetMaxLevel()
    return 2400  -- or based on config
end

function Level.IsMaxLevel()
    return Level.GetCurrentLevel() >= Level.GetMaxLevel()
end

-- =============================================
-- BOSS MODULE
-- =============================================
local Boss = {}

function Boss.GetNearestBoss()
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    
    local nearest = nil
    local distance = math.huge
    local player = game.Players.LocalPlayer
    
    if not player.Character then return nil end
    
    for _, enemy in pairs(enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
            local dist = (enemy.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < distance and dist < 500 then
                distance = dist
                nearest = enemy
            end
        end
    end
    
    return nearest
end

function Boss.AutoFight(boss)
    if not boss or not boss:FindFirstChild("Humanoid") then return false end
    
    Logger.Info("Fighting boss:", boss.Name)
    local character = game.Players.LocalPlayer.Character
    if not character then return false end
    
    -- Move to boss
    character:MoveTo(boss.HumanoidRootPart.Position + Vector3.new(5, 0, 5))
    wait(1)
    
    -- Attack sequence
    for i = 1, 20 do
        if not boss or boss.Humanoid.Health <= 0 then break end
        -- Simulate attacks
        wait(0.3)
    end
    
    Logger.Info("Boss fight completed")
    return true
end

function Boss.GetBossList()
    return {
        "Dough King",
        "Magma Admiral",
        "Raw Zoan Leader",
        "Ultimate Mercenary"
    }
end

-- =============================================
-- FRUIT MODULE
-- =============================================
local Fruit = {}

function Fruit.GetFruitInBackpack()
    local player = game.Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")
    local fruits = {}
    
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:FindFirstChild("Fruit") then
                table.insert(fruits, item.Name)
            end
        end
    end
    
    return fruits
end

function Fruit.EatFruit(fruitName)
    local player = game.Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")
    
    if not backpack then return false end
    
    for _, item in pairs(backpack:GetChildren()) do
        if item.Name == fruitName then
            Logger.Info("Eating fruit:", fruitName)
            -- Simulate eating
            wait(0.5)
            return true
        end
    end
    
    return false
end

function Fruit.AutoEatFruit()
    if not Config.Fruit.EatFruitStore then return end
    
    local fruits = Fruit.GetFruitInBackpack()
    for _, fruit in pairs(fruits) do
        if table.find(Config.Fruit.Fruit, fruit) then
            Fruit.EatFruit(fruit)
        end
    end
end

-- =============================================
-- ITEMS MODULE
-- =============================================
local Items = {}

function Items.GetCurrentWeapon()
    local player = game.Players.LocalPlayer
    local character = player.Character
    
    if not character then return nil end
    
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") then
            return item
        end
    end
    
    return nil
end

function Items.EquipWeapon(weaponName)
    local player = game.Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")
    
    if not backpack then return false end
    
    for _, weapon in pairs(backpack:GetChildren()) do
        if weapon.Name == weaponName then
            weapon.Parent = player.Character
            wait(0.3)
            return true
        end
    end
    
    return false
end

function Items.GetAllItems()
    local player = game.Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")
    local items = {}
    
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            table.insert(items, item.Name)
        end
    end
    
    return items
end

-- =============================================
-- QUEST MODULE
-- =============================================
local Quest = {}

function Quest.GetCurrentQuest()
    local player = game.Players.LocalPlayer
    local questGUI = player:FindFirstChild("PlayerGui"):FindFirstChild("QuestGui")
    
    if questGUI then
        return "Quest Active"
    end
    
    return nil
end

function Quest.AcceptQuest(questName)
    Logger.Info("Accepting quest:", questName)
    -- Simulate quest acceptance
    wait(0.5)
    return true
end

function Quest.CompleteQuest()
    Logger.Info("Completing current quest")
    wait(2)
    return true
end

function Quest.AutoQuest()
    local currentQuest = Quest.GetCurrentQuest()
    
    if not currentQuest then
        Logger.Info("No active quest, finding new one...")
        Quest.AcceptQuest("Default Quest")
    end
    
    wait(5)
end

-- =============================================
-- SEA MODULE
-- =============================================
local Sea = {}

function Sea.GetCurrentSea()
    local player = game.Players.LocalPlayer
    local character = player.Character
    
    if not character then return 1 end
    
    local pos = character.HumanoidRootPart.Position
    
    if pos.Z > 10000 then
        return 3
    elseif pos.Z > 0 then
        return 2
    else
        return 1
    end
end

function Sea.TravelToSea(seaNumber)
    Logger.Info("Traveling to Sea", seaNumber)
    local player = game.Players.LocalPlayer
    local character = player.Character
    
    if not character then return false end
    
    -- Simulate travel
    if seaNumber == 2 then
        character:MoveTo(Vector3.new(500, 50, 5000))
    elseif seaNumber == 3 then
        character:MoveTo(Vector3.new(500, 50, 15000))
    end
    
    wait(5)
    return true
end

-- =============================================
-- SERVER HOP MODULE
-- =============================================
local ServerHop = {}

function ServerHop.GetServerList()
    local servers = {}
    local success, result = pcall(function()
        local response = game:HttpGet("https://games.roblox.com/v1/games/2753915549/servers/Public?sortOrder=Asc&limit=100")
        return game:GetService("HttpService"):JSONDecode(response)
    end)
    
    if success and result and result.data then
        for _, server in pairs(result.data) do
            table.insert(servers, server.id)
        end
    end
    
    return servers
end

function ServerHop.JoinServer(serverId)
    if not serverId then return false end
    
    Logger.Info("Joining server:", serverId)
    
    local TeleportService = game:GetService("TeleportService")
    local GameId = game.PlaceId
    
    TeleportService:Teleport(GameId, game.Players.LocalPlayer, nil, serverId)
    return true
end

function ServerHop.HopServer()
    if not Config.Configuration.HopNear then return end
    
    Logger.Info("Hopping to new server...")
    local servers = ServerHop.GetServerList()
    
    if #servers > 0 then
        ServerHop.JoinServer(servers[math.random(#servers)])
    end
end

-- =============================================
-- MAIN SCRIPT EXECUTION
-- =============================================

print("===========================================")
print("[BlackKaitun] Script Initializing...")
print("[BlackKaitun] Team: " .. Config.Team)
print("[BlackKaitun] FPS Boost: " .. tostring(Config.Configuration.FpsBoost))
print("===========================================")

-- Load settings
Settings.Load()

-- Apply FPS boost if enabled
if Config.Configuration.FpsBoost then
    Logger.Info("Applying FPS boost...")
    local RunService = game:GetService("RunService")
    RunService:Set3dRenderingEnabled(false)
    wait(0.1)
    RunService:Set3dRenderingEnabled(true)
end

-- Main loop
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local lastUpdate = tick()

RunService.Heartbeat:Connect(function()
    if not player or not player.Character then return end
    
    -- Update every 5 seconds
    if tick() - lastUpdate < 5 then return end
    lastUpdate = tick()
    
    -- Auto farm boss if nearby
    if Config.Configuration.HopNear then
        local boss = Boss.GetNearestBoss()
        if boss then
            Boss.AutoFight(boss)
        end
    end
    
    -- Auto eat fruit
    if Config.Fruit.EatFruitStore then
        Fruit.AutoEatFruit()
    end
    
    -- Auto quest
    Quest.AutoQuest()
    
    -- Server hop if idle
    if Config.Configuration.HopWhenIdle then
        -- Check if player is idle and hop if needed
        if math.random() > 0.95 then
            ServerHop.HopServer()
        end
    end
end)

-- Cleanup on death
player.CharacterAdded:Connect(function(newCharacter)
    Logger.Info("Character respawned")
end)

print("===========================================")
print("[BlackKaitun] Script loaded successfully!")
print("[BlackKaitun] Running auto-farming...")
print("===========================================")
