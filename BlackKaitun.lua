-- Black Kaitun Script for Blox Fruits
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
        -- Melees 
        AutoFullyMelees = true,

        -- Swords 
        Saber = true,
        CursedDualKatana = true,

        -- Guns 
        SoulGuitar = true,

        -- Upgrades 
        RaceV2 = true
    },
    Settings = {
        StayInSea2UntilHaveDarkFragments = false
    }
}

-- Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- ============ MAIN FUNCTIONS ============

local function ApplyFPS()
    if Config.FpsBoost then
        print("[Black Kaitun] Applying FPS Boost...")
        RunService:Set3dRenderingEnabled(false)
        wait(0.1)
        RunService:Set3dRenderingEnabled(true)
    end
end

local function EatFruit()
    if Config.Fruit.EatFruitStore then
        print("[Black Kaitun] Eating fruit: " .. table.concat(Config.Fruit.Fruit, ", "))
        -- Add your fruit eating logic here
    end
end

local function AutoFarm()
    if Config.Configuration.HopWhenIdle then
        print("[Black Kaitun] Auto farming enabled")
        -- Add your farming logic here
    end
end

local function ServerHop()
    if Config.Configuration.HopNear then
        print("[Black Kaitun] Server hop enabled")
        -- Add your server hop logic here
    end
end

local function ApplyItems()
    print("[Black Kaitun] Applying items configuration...")
    if Config.Items.AutoFullyMelees then
        print("[Black Kaitun] Auto fully melees: enabled")
    end
    if Config.Items.Saber then
        print("[Black Kaitun] Saber: enabled")
    end
    if Config.Items.CursedDualKatana then
        print("[Black Kaitun] Cursed Dual Katana: enabled")
    end
    if Config.Items.SoulGuitar then
        print("[Black Kaitun] Soul Guitar: enabled")
    end
    if Config.Items.RaceV2 then
        print("[Black Kaitun] Race V2: enabled")
    end
end

-- ============ INITIALIZATION ============

print("===========================================")
print("[Black Kaitun] Script Loaded Successfully!")
print("[Black Kaitun] Team: " .. Config.Team)
print("[Black Kaitun] FPS: " .. Config.FPS)
print("===========================================")

-- Apply initial settings
ApplyFPS()
ApplyItems()

-- Check if player has specific items
print("[Black Kaitun] Initializing farming...")

-- Main loop
RunService.Heartbeat:Connect(function()
    if not character or not character:FindFirstChild("Humanoid") then
        character = player.Character or player.CharacterAdded:Wait()
    end
    
    -- Auto farm logic
    if Config.Configuration.HopWhenIdle then
        -- Add idle detection and auto-hop logic
    end
end)

-- Cleanup on player death
character.Humanoid.Died:Connect(function()
    print("[Black Kaitun] Player died, respawning...")
end)

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    print("[Black Kaitun] Character respawned")
end)

print("[Black Kaitun] Script initialized and running!")
