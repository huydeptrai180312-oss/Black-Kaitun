-- =============================================
-- BLACK KAITUN - BLOX FRUITS SCRIPT v2
-- GUI + Framework + All Modules
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
-- CONFIG SYSTEM
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
    },
    Settings = {
        StayInSea2UntilHaveDarkFragments = false
    }
}

-- =============================================
-- STATE MANAGER
-- =============================================
local State = {
    Level = 1,
    Sea = 1,
    Race = "Human",
    Beli = 0,
    CurrentTask = "IDLE",
    TaskStatus = "IDLE",
    Progress = 0,
    IsRunning = false
}

local function UpdateState()
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        character = player.Character or player.CharacterAdded:Wait()
        return
    end
    
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
-- TASK MANAGER (State Machine)
-- =============================================
local TaskManager = {}
local taskQueue = {}

function TaskManager.SetStatus(status)
    State.TaskStatus = status
    Logger.Info("Task Status:", status)
end

function TaskManager.AddTask(taskName, taskFunc)
    table.insert(taskQueue, {name = taskName, func = taskFunc})
end

function TaskManager.ProcessQueue()
    if #taskQueue == 0 then
        TaskManager.SetStatus("IDLE")
        return
    end
    
    local currentTask = taskQueue[1]
    State.CurrentTask = currentTask.name
    TaskManager.SetStatus("RUNNING")
    
    local success, err = pcall(currentTask.func)
    
    if success then
        TaskManager.SetStatus("COMPLETED")
        table.remove(taskQueue, 1)
    else
        TaskManager.SetStatus("FAILED")
        Logger.Error("Task failed:", err)
    end
end

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
