-- =============================================
-- BLACK KAITUN - BLOX FRUITS SCRIPT v3
-- GUI Fix: Real stats + Clean layout
-- =============================================
-- Loadstring: loadstring(game:HttpGet("https://raw.githubusercontent.com/huydeptrai180312-oss/Black-Kaitun/main/BlackKaitun.lua"))()

-- SERVICES
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()

-- =============================================
-- CONFIG
-- =============================================
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
    }
}

-- =============================================
-- STATE & REAL STAT GETTERS
-- =============================================
local State = {
    Level = 1,
    Sea = 1,
    Race = "Human",
    Beli = 0,
    Health = 0,
    MaxHealth = 0,
    Energy = 0,
    MaxEnergy = 0,
    CurrentTask = "IDLE",
    TaskStatus = "IDLE",
    IsRunning = false
}

local function GetRealStats()
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    -- Level
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        State.Health = math.floor(humanoid.Health)
        State.MaxHealth = math.floor(humanoid.MaxHealth)
    end
    
    -- Try to get Level from Character stats
    local stats = character:FindFirstChild("Stats")
    if stats then
        local level = stats:FindFirstChild("Level")
        if level and level:IsA("IntValue") then
            State.Level = level.Value
        end
    end
    
    -- Try to get from PlayerGui or other sources
    local playerGui = player:WaitForChild("PlayerGui")
    for _, gui in pairs(playerGui:GetDescendants()) do
        if gui:IsA("TextLabel") or gui:IsA("TextBox") then
            local text = gui.Text or ""
            -- Try to extract Level from GUI
            if text:match("Lv%.%s*(%d+)") then
                State.Level = tonumber(text:match("Lv%.%s*(%d+)"))
            end
            -- Try to extract Beli
            if text:match("%$([%d,]+)") then
                local beliStr = text:match("%$([%d,]+)"):gsub(",", "")
                State.Beli = tonumber(beliStr) or 0
            end
        end
    end
    
    -- Sea detection
    local pos = character.HumanoidRootPart.Position
    if pos.Z > 10000 then
        State.Sea = 3
    elseif pos.Z > 0 then
        State.Sea = 2
    else
        State.Sea = 1
    end
end

-- =============================================
-- LOGGER
-- =============================================
local Logger = {}

function Logger.Info(...)
    print("[BlackKaitun]", ...)
end

-- =============================================
-- COLORS
-- =============================================
local COLOR_BLACK = Color3.fromRGB(0, 0, 0)
local COLOR_DARK_GRAY = Color3.fromRGB(50, 50, 50)
local COLOR_YELLOW = Color3.fromRGB(255, 255, 0)
local COLOR_GREEN = Color3.fromRGB(0, 255, 0)
local COLOR_CYAN = Color3.fromRGB(0, 255, 255)
local COLOR_WHITE = Color3.fromRGB(255, 255, 255)
local COLOR_RED = Color3.fromRGB(255, 0, 0)

-- =============================================
-- GUI SYSTEM (Compact, Clean)
-- =============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlackKaitunGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- MAIN PANEL (No Title, Just Stats)
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.BackgroundColor3 = COLOR_DARK_GRAY
mainPanel.BackgroundTransparency = 0.3
mainPanel.BorderSizePixel = 2
mainPanel.BorderColor3 = COLOR_YELLOW
mainPanel.Size = UDim2.new(0, 280, 0, 250)
mainPanel.Position = UDim2.new(0, 10, 0, 60)
mainPanel.Parent = screenGui

-- Account Stats Label
local statsTitle = Instance.new("TextLabel")
statsTitle.Text = "📋 Account Stats"
statsTitle.TextSize = 13
statsTitle.TextColor3 = COLOR_YELLOW
statsTitle.BackgroundColor3 = COLOR_BLACK
statsTitle.BackgroundTransparency = 0.5
statsTitle.BorderSizePixel = 0
statsTitle.Size = UDim2.new(1, 0, 0, 22)
statsTitle.Position = UDim2.new(0, 0, 0, 0)
statsTitle.Parent = mainPanel

-- Level Label
local levelLabel = Instance.new("TextLabel")
levelLabel.Name = "LevelLabel"
levelLabel.Text = "Level: 1"
levelLabel.TextSize = 12
levelLabel.TextColor3 = COLOR_WHITE
levelLabel.BackgroundColor3 = COLOR_BLACK
levelLabel.BackgroundTransparency = 0.4
levelLabel.BorderSizePixel = 0
levelLabel.Size = UDim2.new(1, -4, 0, 20)
levelLabel.Position = UDim2.new(0, 2, 0, 25)
levelLabel.Parent = mainPanel

-- Sea Label
local seaLabel = Instance.new("TextLabel")
seaLabel.Text = "Sea: 1"
seaLabel.TextSize = 12
seaLabel.TextColor3 = COLOR_WHITE
seaLabel.BackgroundColor3 = COLOR_BLACK
seaLabel.BackgroundTransparency = 0.4
seaLabel.BorderSizePixel = 0
seaLabel.Size = UDim2.new(1, -4, 0, 20)
seaLabel.Position = UDim2.new(0, 2, 0, 48)
seaLabel.Parent = mainPanel

-- Race Label
local raceLabel = Instance.new("TextLabel")
raceLabel.Text = "Race: Human"
raceLabel.TextSize = 12
raceLabel.TextColor3 = COLOR_WHITE
raceLabel.BackgroundColor3 = COLOR_BLACK
raceLabel.BackgroundTransparency = 0.4
raceLabel.BorderSizePixel = 0
raceLabel.Size = UDim2.new(1, -4, 0, 20)
raceLabel.Position = UDim2.new(0, 2, 0, 71)
raceLabel.Parent = mainPanel

-- Beli Label
local beliLabel = Instance.new("TextLabel")
beliLabel.Name = "BeliLabel"
beliLabel.Text = "$0"
beliLabel.TextSize = 12
beliLabel.TextColor3 = COLOR_YELLOW
beliLabel.BackgroundColor3 = COLOR_BLACK
beliLabel.BackgroundTransparency = 0.4
beliLabel.BorderSizePixel = 0
beliLabel.Size = UDim2.new(1, -4, 0, 20)
beliLabel.Position = UDim2.new(0, 2, 0, 94)
beliLabel.Parent = mainPanel

-- Health Bar
local healthLabel = Instance.new("TextLabel")
healthLabel.Name = "HealthLabel"
healthLabel.Text = "Health: 0/0"
healthLabel.TextSize = 11
healthLabel.TextColor3 = COLOR_BLACK
healthLabel.BackgroundColor3 = COLOR_GREEN
healthLabel.BorderSizePixel = 1
healthLabel.BorderColor3 = COLOR_YELLOW
healthLabel.Size = UDim2.new(1, -4, 0, 22)
healthLabel.Position = UDim2.new(0, 2, 0, 120)
healthLabel.Parent = mainPanel

-- Energy Bar
local energyLabel = Instance.new("TextLabel")
energyLabel.Name = "EnergyLabel"
energyLabel.Text = "Energy: 0/0"
energyLabel.TextSize = 11
energyLabel.TextColor3 = COLOR_BLACK
energyLabel.BackgroundColor3 = COLOR_CYAN
energyLabel.BorderSizePixel = 1
energyLabel.BorderColor3 = COLOR_YELLOW
energyLabel.Size = UDim2.new(1, -4, 0, 22)
energyLabel.Position = UDim2.new(0, 2, 0, 146)
energyLabel.Parent = mainPanel

-- Task Status
local taskLabel = Instance.new("TextLabel")
taskLabel.Name = "TaskLabel"
taskLabel.Text = "Status: IDLE"
taskLabel.TextSize = 11
taskLabel.TextColor3 = COLOR_YELLOW
taskLabel.BackgroundColor3 = COLOR_BLACK
taskLabel.BackgroundTransparency = 0.4
taskLabel.BorderSizePixel = 0
taskLabel.Size = UDim2.new(1, -4, 0, 20)
taskLabel.Position = UDim2.new(0, 2, 0, 172)
taskLabel.Parent = mainPanel

-- Running Status
local runningLabel = Instance.new("TextLabel")
runningLabel.Name = "RunningLabel"
runningLabel.Text = "Running: OFF"
runningLabel.TextSize = 11
runningLabel.TextColor3 = COLOR_RED
runningLabel.BackgroundColor3 = COLOR_BLACK
runningLabel.BackgroundTransparency = 0.4
runningLabel.BorderSizePixel = 0
runningLabel.Size = UDim2.new(1, -4, 0, 20)
runningLabel.Position = UDim2.new(0, 2, 0, 195)
runningLabel.Parent = mainPanel

-- =============================================
-- CONTROL PANEL
-- =============================================

local controlPanel = Instance.new("Frame")
controlPanel.Name = "ControlPanel"
controlPanel.BackgroundColor3 = COLOR_DARK_GRAY
controlPanel.BackgroundTransparency = 0.3
controlPanel.BorderSizePixel = 2
controlPanel.BorderColor3 = COLOR_YELLOW
controlPanel.Size = UDim2.new(0, 280, 0, 75)
controlPanel.Position = UDim2.new(0, 10, 0, 320)
controlPanel.Parent = screenGui

-- Start Button
local startButton = Instance.new("TextButton")
startButton.Name = "StartButton"
startButton.Text = "START"
startButton.TextSize = 13
startButton.TextColor3 = COLOR_BLACK
startButton.BackgroundColor3 = COLOR_GREEN
startButton.BorderSizePixel = 2
startButton.BorderColor3 = COLOR_YELLOW
startButton.Size = UDim2.new(0.5, -3, 0, 33)
startButton.Position = UDim2.new(0, 2, 0, 5)
startButton.Parent = controlPanel

-- Stop Button
local stopButton = Instance.new("TextButton")
stopButton.Name = "StopButton"
stopButton.Text = "STOP"
stopButton.TextSize = 13
stopButton.TextColor3 = COLOR_BLACK
stopButton.BackgroundColor3 = COLOR_RED
stopButton.BorderSizePixel = 2
stopButton.BorderColor3 = COLOR_YELLOW
stopButton.Size = UDim2.new(0.5, -3, 0, 33)
stopButton.Position = UDim2.new(0.5, 1, 0, 5)
stopButton.Parent = controlPanel

-- Menu Button
local menuButton = Instance.new("TextButton")
menuButton.Name = "MenuButton"
menuButton.Text = "Menu"
menuButton.TextSize = 12
menuButton.TextColor3 = COLOR_BLACK
menuButton.BackgroundColor3 = COLOR_YELLOW
menuButton.BorderSizePixel = 2
menuButton.BorderColor3 = COLOR_DARK_GRAY
menuButton.Size = UDim2.new(1, -4, 0, 28)
menuButton.Position = UDim2.new(0, 2, 0, 42)
menuButton.Parent = controlPanel

-- Button Functions
startButton.MouseButton1Click:Connect(function()
    State.IsRunning = true
    runningLabel.Text = "Running: ON"
    runningLabel.TextColor3 = COLOR_GREEN
    Logger.Info("Script started!")
end)

stopButton.MouseButton1Click:Connect(function()
    State.IsRunning = false
    runningLabel.Text = "Running: OFF"
    runningLabel.TextColor3 = COLOR_RED
    Logger.Info("Script stopped!")
end)

-- Dragging
local dragging = false
local dragStart = Vector2.new()
local guiStart = Vector2.new()

statsTitle.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = UserInputService:GetMouseLocation()
        guiStart = mainPanel.Position
    end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = UserInputService:GetMouseLocation() - dragStart
        mainPanel.Position = guiStart + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Toggle GUI with M key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

-- =============================================
-- MAIN LOOP
-- =============================================

print("===========================================")
print("[BlackKaitun] v3 - GUI Updated!")
print("[BlackKaitun] Press M to toggle GUI")
print("[BlackKaitun] Click START to run script")
print("===========================================")

if Config.Configuration.FpsBoost then
    Logger.Info("FPS boost enabled")
    RunService:Set3dRenderingEnabled(false)
    wait(0.1)
    RunService:Set3dRenderingEnabled(true)
end

local lastUpdate = tick()

RunService.Heartbeat:Connect(function()
    if not player or not player.Character then return end
    character = player.Character
    
    if tick() - lastUpdate < 0.5 then return end
    lastUpdate = tick()
    
    -- Get real stats
    GetRealStats()
    
    -- Update UI
    levelLabel.Text = "Level: " .. State.Level
    seaLabel.Text = "Sea: " .. State.Sea
    beliLabel.Text = "$" .. string.format("%d", State.Beli)
    healthLabel.Text = "Health: " .. State.Health .. "/" .. State.MaxHealth
    energyLabel.Text = "Energy: " .. State.Energy .. "/" .. State.MaxEnergy
    taskLabel.Text = "Status: " .. State.TaskStatus
end)

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    Logger.Info("Character respawned")
end)

print("[BlackKaitun] Ready!")

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
-- LEVEL MODULE
-- =============================================
local Level = {}

function Level.GetCurrentLevel()
    if not character or not character:FindFirstChild("Humanoid") then return 1 end
    return character.Humanoid.Health or 1
end

function Level.GetMaxLevel()
    return 2400
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
    
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    for _, enemy in pairs(enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
            local dist = (enemy.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
            if dist < distance and dist < 500 then
                distance = dist
                nearest = enemy
            end
        end
    end
    
    return nearest
end

-- =============================================
-- FRUIT MODULE
-- =============================================
local Fruit = {}

function Fruit.GetFruitInBackpack()
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

-- =============================================
-- SEA MODULE
-- =============================================
local Sea = {}

function Sea.GetCurrentSea()
    if not character or not character:FindFirstChild("HumanoidRootPart") then return 1 end
    
    local pos = character.HumanoidRootPart.Position
    
    if pos.Z > 10000 then
        return 3
    elseif pos.Z > 0 then
        return 2
    else
        return 1
    end
end

-- =============================================
-- GUI SYSTEM
-- =============================================

-- Colors
local COLOR_BLACK = Color3.fromRGB(0, 0, 0)
local COLOR_DARK_GRAY = Color3.fromRGB(50, 50, 50)
local COLOR_LIGHT_GRAY = Color3.fromRGB(100, 100, 100)
local COLOR_YELLOW = Color3.fromRGB(255, 255, 0)
local COLOR_GREEN = Color3.fromRGB(0, 255, 0)
local COLOR_CYAN = Color3.fromRGB(0, 255, 255)
local COLOR_WHITE = Color3.fromRGB(255, 255, 255)
local COLOR_RED = Color3.fromRGB(255, 0, 0)

-- Create Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlackKaitunGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Create Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Text = "⚡ Black Kaitun"
titleLabel.TextSize = 24
titleLabel.TextColor3 = COLOR_YELLOW
titleLabel.BackgroundColor3 = COLOR_DARK_GRAY
titleLabel.BackgroundTransparency = 0.3
titleLabel.BorderSizePixel = 2
titleLabel.BorderColor3 = COLOR_YELLOW
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Parent = screenGui

-- Create Main Window
local mainWindow = Instance.new("Frame")
mainWindow.Name = "MainWindow"
mainWindow.BackgroundColor3 = COLOR_DARK_GRAY
mainWindow.BackgroundTransparency = 0.4
mainWindow.BorderSizePixel = 2
mainWindow.BorderColor3 = COLOR_YELLOW
mainWindow.Size = UDim2.new(0, 400, 0, 300)
mainWindow.Position = UDim2.new(0, 10, 0, 60)
mainWindow.Parent = screenGui

-- Stats Container (Left)
local statsContainer = Instance.new("Frame")
statsContainer.Name = "StatsContainer"
statsContainer.BackgroundTransparency = 1
statsContainer.Size = UDim2.new(0.5, -5, 1, 0)
statsContainer.Position = UDim2.new(0, 5, 0, 10)
statsContainer.Parent = mainWindow

-- Account Stats Label
local accountStatsLabel = Instance.new("TextLabel")
accountStatsLabel.Text = "📋 Account Stats"
accountStatsLabel.TextSize = 14
accountStatsLabel.TextColor3 = COLOR_YELLOW
accountStatsLabel.BackgroundTransparency = 1
accountStatsLabel.Size = UDim2.new(1, 0, 0, 20)
accountStatsLabel.Position = UDim2.new(0, 0, 0, 0)
accountStatsLabel.Parent = statsContainer

-- Level Label
local levelLabel = Instance.new("TextLabel")
levelLabel.Name = "LevelLabel"
levelLabel.Text = "Level " .. State.Level
levelLabel.TextSize = 12
levelLabel.TextColor3 = COLOR_WHITE
levelLabel.BackgroundColor3 = COLOR_BLACK
levelLabel.BackgroundTransparency = 0.3
levelLabel.Size = UDim2.new(1, 0, 0, 25)
levelLabel.Position = UDim2.new(0, 0, 0, 25)
levelLabel.Parent = statsContainer

-- Sea Label
local seaLabel = Instance.new("TextLabel")
seaLabel.Name = "SeaLabel"
seaLabel.Text = "🗺 Sea: " .. State.Sea
seaLabel.TextSize = 12
seaLabel.TextColor3 = COLOR_WHITE
seaLabel.BackgroundColor3 = COLOR_BLACK
seaLabel.BackgroundTransparency = 0.3
seaLabel.Size = UDim2.new(1, 0, 0, 25)
seaLabel.Position = UDim2.new(0, 0, 0, 55)
seaLabel.Parent = statsContainer

-- Race Label
local raceLabel = Instance.new("TextLabel")
raceLabel.Name = "RaceLabel"
raceLabel.Text = "🔥 Race: " .. State.Race
raceLabel.TextSize = 12
raceLabel.TextColor3 = COLOR_WHITE
raceLabel.BackgroundColor3 = COLOR_BLACK
raceLabel.BackgroundTransparency = 0.3
raceLabel.Size = UDim2.new(1, 0, 0, 25)
raceLabel.Position = UDim2.new(0, 0, 0, 85)
raceLabel.Parent = statsContainer

-- Task Label
local taskLabel = Instance.new("TextLabel")
taskLabel.Name = "TaskLabel"
taskLabel.Text = "📍 Task: " .. State.CurrentTask
taskLabel.TextSize = 12
taskLabel.TextColor3 = COLOR_WHITE
taskLabel.BackgroundColor3 = COLOR_BLACK
taskLabel.BackgroundTransparency = 0.3
taskLabel.Size = UDim2.new(1, 0, 0, 25)
taskLabel.Position = UDim2.new(0, 0, 0, 115)
taskLabel.Parent = statsContainer

-- Status Container (Right)
local statusContainer = Instance.new("Frame")
statusContainer.Name = "StatusContainer"
statusContainer.BackgroundTransparency = 1
statusContainer.Size = UDim2.new(0.5, -5, 1, 0)
statusContainer.Position = UDim2.new(0.5, 5, 0, 10)
statusContainer.Parent = mainWindow

-- Status Title
local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "⚙️ Status"
statusLabel.TextSize = 14
statusLabel.TextColor3 = COLOR_RED
statusLabel.BackgroundTransparency = 1
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 0)
statusLabel.Parent = statusContainer

-- Status Value Label
local statusValueLabel = Instance.new("TextLabel")
statusValueLabel.Name = "StatusValue"
statusValueLabel.Text = "● " .. State.TaskStatus
statusValueLabel.TextSize = 12
statusValueLabel.TextColor3 = COLOR_GREEN
statusValueLabel.BackgroundColor3 = COLOR_BLACK
statusValueLabel.BackgroundTransparency = 0.3
statusValueLabel.Size = UDim2.new(1, 0, 0, 25)
statusValueLabel.Position = UDim2.new(0, 0, 0, 25)
statusValueLabel.Parent = statusContainer

-- Progress Label
local progressLabel = Instance.new("TextLabel")
progressLabel.Name = "ProgressLabel"
progressLabel.Text = "Progress: 0%"
progressLabel.TextSize = 11
progressLabel.TextColor3 = COLOR_WHITE
progressLabel.BackgroundColor3 = COLOR_BLACK
progressLabel.BackgroundTransparency = 0.3
progressLabel.Size = UDim2.new(1, 0, 0, 25)
progressLabel.Position = UDim2.new(0, 0, 0, 55)
progressLabel.Parent = statusContainer

-- Running Label
local runningLabel = Instance.new("TextLabel")
runningLabel.Name = "RunningLabel"
runningLabel.Text = "Running: OFF"
runningLabel.TextSize = 12
runningLabel.TextColor3 = COLOR_RED
runningLabel.BackgroundColor3 = COLOR_BLACK
runningLabel.BackgroundTransparency = 0.3
runningLabel.Size = UDim2.new(1, 0, 0, 25)
runningLabel.Position = UDim2.new(0, 0, 0, 85)
runningLabel.Parent = statusContainer

-- Beli Label
local beliLabel = Instance.new("TextLabel")
beliLabel.Name = "BeliLabel"
beliLabel.Text = "💰 Beli: 0"
beliLabel.TextSize = 12
beliLabel.TextColor3 = COLOR_WHITE
beliLabel.BackgroundColor3 = COLOR_BLACK
beliLabel.BackgroundTransparency = 0.3
beliLabel.Size = UDim2.new(1, 0, 0, 25)
beliLabel.Position = UDim2.new(0, 0, 0, 115)
beliLabel.Parent = statusContainer

-- Control Panel (Bottom)
local controlPanel = Instance.new("Frame")
controlPanel.Name = "ControlPanel"
controlPanel.BackgroundColor3 = COLOR_DARK_GRAY
controlPanel.BackgroundTransparency = 0.4
controlPanel.BorderSizePixel = 2
controlPanel.BorderColor3 = COLOR_YELLOW
controlPanel.Size = UDim2.new(0, 130, 0, 100)
controlPanel.Position = UDim2.new(0, 10, 0, 380)
controlPanel.Parent = screenGui

-- Start Button
local startButton = Instance.new("TextButton")
startButton.Name = "StartButton"
startButton.Text = "START"
startButton.TextSize = 14
startButton.TextColor3 = COLOR_BLACK
startButton.BackgroundColor3 = COLOR_GREEN
startButton.BackgroundTransparency = 0
startButton.BorderSizePixel = 2
startButton.BorderColor3 = COLOR_YELLOW
startButton.Size = UDim2.new(1, -10, 0, 35)
startButton.Position = UDim2.new(0, 5, 0, 5)
startButton.Parent = controlPanel

-- Stop Button
local stopButton = Instance.new("TextButton")
stopButton.Name = "StopButton"
stopButton.Text = "STOP"
stopButton.TextSize = 14
stopButton.TextColor3 = COLOR_BLACK
stopButton.BackgroundColor3 = COLOR_RED
stopButton.BackgroundTransparency = 0
stopButton.BorderSizePixel = 2
stopButton.BorderColor3 = COLOR_YELLOW
stopButton.Size = UDim2.new(1, -10, 0, 35)
stopButton.Position = UDim2.new(0, 5, 0, 45)
stopButton.Parent = controlPanel

-- Dragging GUI
local dragging = false
local dragStart = Vector2.new()
local guiStart = Vector2.new()

titleLabel.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = UserInputService:GetMouseLocation()
        guiStart = mainWindow.Position
    end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = UserInputService:GetMouseLocation() - dragStart
        mainWindow.Position = guiStart + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Button Click Handlers
startButton.MouseButton1Click:Connect(function()
    State.IsRunning = true
    runningLabel.Text = "Running: ON"
    runningLabel.TextColor3 = COLOR_GREEN
    Logger.Info("Script started!")
end)

stopButton.MouseButton1Click:Connect(function()
    State.IsRunning = false
    runningLabel.Text = "Running: OFF"
    runningLabel.TextColor3 = COLOR_RED
    Logger.Info("Script stopped!")
end)

-- Toggle GUI with M key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

-- =============================================
-- MAIN LOOP (Update UI + Process Tasks)
-- =============================================

print("===========================================")
print("[BlackKaitun] Script v2 Initializing...")
print("[BlackKaitun] Team: " .. Config.Team)
print("[BlackKaitun] Press M to toggle GUI")
print("[BlackKaitun] Click START to begin farming")
print("===========================================")

if Config.Configuration.FpsBoost then
    Logger.Info("Applying FPS boost...")
    RunService:Set3dRenderingEnabled(false)
    wait(0.1)
    RunService:Set3dRenderingEnabled(true)
end

local lastUpdate = tick()

RunService.Heartbeat:Connect(function()
    if not player or not player.Character then return end
    character = player.Character
    
    if tick() - lastUpdate < 1 then return end
    lastUpdate = tick()
    
    UpdateState()
    
    -- Update UI
    levelLabel.Text = "Level " .. State.Level
    seaLabel.Text = "🗺 Sea: " .. State.Sea
    taskLabel.Text = "📍 Task: " .. State.CurrentTask
    statusValueLabel.Text = "● " .. State.TaskStatus
    
    -- Color coding
    if State.TaskStatus == "RUNNING" then
        statusValueLabel.TextColor3 = COLOR_GREEN
    elseif State.TaskStatus == "COMPLETED" then
        statusValueLabel.TextColor3 = COLOR_CYAN
    elseif State.TaskStatus == "FAILED" then
        statusValueLabel.TextColor3 = COLOR_RED
    else
        statusValueLabel.TextColor3 = COLOR_YELLOW
    end
    
    -- Process tasks
    if State.IsRunning then
        local boss = Boss.GetNearestBoss()
        if boss and Config.Configuration.HopNear then
            TaskManager.AddTask("Fight: " .. boss.Name, function()
                Logger.Info("Fighting boss:", boss.Name)
                wait(2)
            end)
        end
        
        TaskManager.ProcessQueue()
    end
end)

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    Logger.Info("Character respawned")
end)

print("===========================================")
print("[BlackKaitun] Script v2 Ready!")
print("[BlackKaitun] GUI loaded - Press START to farm")
print("===========================================")
