local UI = {}

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

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

-- Create Stats Container
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

-- Level
local levelLabel = Instance.new("TextLabel")
levelLabel.Text = "Level 2800  Third Sea 🗺"
levelLabel.TextSize = 12
levelLabel.TextColor3 = COLOR_WHITE
levelLabel.BackgroundColor3 = COLOR_BLACK
levelLabel.BackgroundTransparency = 0.3
levelLabel.Size = UDim2.new(1, 0, 0, 25)
levelLabel.Position = UDim2.new(0, 0, 0, 25)
levelLabel.Parent = statsContainer

-- Race
local raceLabel = Instance.new("TextLabel")
raceLabel.Text = "🔥 Race: Human"
raceLabel.TextSize = 12
raceLabel.TextColor3 = COLOR_WHITE
raceLabel.BackgroundColor3 = COLOR_BLACK
raceLabel.BackgroundTransparency = 0.3
raceLabel.Size = UDim2.new(1, 0, 0, 25)
raceLabel.Position = UDim2.new(0, 0, 0, 55)
raceLabel.Parent = statsContainer

-- Beli
local beliLabel = Instance.new("TextLabel")
beliLabel.Text = "💰 Beli: 54,881,186"
beliLabel.TextSize = 12
beliLabel.TextColor3 = COLOR_WHITE
beliLabel.BackgroundColor3 = COLOR_BLACK
beliLabel.BackgroundTransparency = 0.3
beliLabel.Size = UDim2.new(1, 0, 0, 25)
beliLabel.Position = UDim2.new(0, 0, 0, 85)
beliLabel.Parent = statsContainer

-- Frag
local fragLabel = Instance.new("TextLabel")
fragLabel.Text = "❄️ Frag: 916"
fragLabel.TextSize = 12
fragLabel.TextColor3 = COLOR_WHITE
fragLabel.BackgroundColor3 = COLOR_BLACK
fragLabel.BackgroundTransparency = 0.3
fragLabel.Size = UDim2.new(1, 0, 0, 25)
fragLabel.Position = UDim2.new(0, 0, 0, 115)
fragLabel.Parent = statsContainer

-- Items Container
local itemsContainer = Instance.new("Frame")
itemsContainer.Name = "ItemsContainer"
itemsContainer.BackgroundTransparency = 1
itemsContainer.Size = UDim2.new(0.5, -5, 1, 0)
itemsContainer.Position = UDim2.new(0.5, 5, 0, 10)
itemsContainer.Parent = mainWindow

-- Account Items Label
local itemsLabel = Instance.new("TextLabel")
itemsLabel.Text = "🎒 Account Items"
itemsLabel.TextSize = 14
itemsLabel.TextColor3 = COLOR_RED
itemsLabel.BackgroundTransparency = 1
itemsLabel.Size = UDim2.new(1, 0, 0, 20)
itemsLabel.Position = UDim2.new(0, 0, 0, 0)
itemsLabel.Parent = itemsContainer

-- Items List (Empty)
local itemsListFrame = Instance.new("Frame")
itemsListFrame.BackgroundColor3 = COLOR_BLACK
itemsListFrame.BackgroundTransparency = 0.3
itemsListFrame.BorderSizePixel = 0
itemsListFrame.Size = UDim2.new(1, 0, 0, 155)
itemsListFrame.Position = UDim2.new(0, 0, 0, 25)
itemsListFrame.Parent = itemsContainer

-- Create Status Checks Section
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Text = "⚔️ Status Checks"
statusLabel.TextSize = 12
statusLabel.TextColor3 = COLOR_WHITE
statusLabel.BackgroundTransparency = 1
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 5, 1, -70)
statusLabel.Parent = mainWindow

-- Status items
local statusItems = {
	{name = "GodiHuman", status = false},
	{name = "Cursed Dual Katana", status = false},
	{name = "Valkyrié Helm", status = false},
	{name = "Skull Guitar", status = false},
	{name = "Mirror Fractal", status = false},
	{name = "Pull Lever", status = false}
}

local startX = 5
local startY = -65
local itemWidth = (390 - 10) / 3

for i, item in ipairs(statusItems) do
	local row = math.floor((i - 1) / 3)
	local col = (i - 1) % 3
	
	local statusButton = Instance.new("TextLabel")
	statusButton.Name = item.name
	statusButton.Text = (item.status and "✓ " or "✗ ") .. item.name
	statusButton.TextSize = 10
	statusButton.TextColor3 = COLOR_RED
	statusButton.BackgroundColor3 = COLOR_BLACK
	statusButton.BackgroundTransparency = 0.5
	statusButton.BorderSizePixel = 1
	statusButton.BorderColor3 = COLOR_LIGHT_GRAY
	statusButton.Size = UDim2.new(0, itemWidth - 3, 0, 18)
	statusButton.Position = UDim2.new(0, startX + (itemWidth * col), 1, startY + (row * 20))
	statusButton.Parent = mainWindow
end

-- Create Left Panel (Menu & Stats)
local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.BackgroundColor3 = COLOR_DARK_GRAY
leftPanel.BackgroundTransparency = 0.4
leftPanel.BorderSizePixel = 2
leftPanel.BorderColor3 = COLOR_YELLOW
leftPanel.Size = UDim2.new(0, 130, 0, 200)
leftPanel.Position = UDim2.new(0, 10, 0, 380)
leftPanel.Parent = screenGui

-- Menu Button
local menuButton = Instance.new("TextButton")
menuButton.Name = "MenuButton"
menuButton.Text = "Menu"
menuButton.TextSize = 16
menuButton.TextColor3 = COLOR_BLACK
menuButton.BackgroundColor3 = COLOR_BLACK
menuButton.BackgroundTransparency = 0
menuButton.BorderSizePixel = 2
menuButton.BorderColor3 = COLOR_YELLOW
menuButton.Size = UDim2.new(1, -10, 0, 40)
menuButton.Position = UDim2.new(0, 5, 0, 5)
menuButton.Parent = leftPanel

-- Money Display
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Name = "Money"
moneyLabel.Text = "$54,881,186"
moneyLabel.TextSize = 18
moneyLabel.TextColor3 = COLOR_YELLOW
moneyLabel.BackgroundTransparency = 1
moneyLabel.Size = UDim2.new(1, -10, 0, 30)
moneyLabel.Position = UDim2.new(0, 5, 0, 55)
moneyLabel.Parent = leftPanel

-- Level Cap
local capLabel = Instance.new("TextLabel")
capLabel.Name = "Cap"
capLabel.Text = "Cap 2800 (TỐI ĐA)"
capLabel.TextSize = 12
capLabel.TextColor3 = COLOR_RED
capLabel.BackgroundTransparency = 1
capLabel.Size = UDim2.new(1, -10, 0, 25)
capLabel.Position = UDim2.new(0, 5, 0, 90)
capLabel.Parent = leftPanel

-- HP Bar
local hpLabel = Instance.new("TextLabel")
hpLabel.Name = "HPLabel"
hpLabel.Text = "Mau 14095/14095"
hpLabel.TextSize = 12
hpLabel.TextColor3 = COLOR_BLACK
hpLabel.BackgroundColor3 = COLOR_GREEN
hpLabel.BorderSizePixel = 1
hpLabel.BorderColor3 = COLOR_YELLOW
hpLabel.Size = UDim2.new(1, -10, 0, 25)
hpLabel.Position = UDim2.new(0, 5, 0, 120)
hpLabel.Parent = leftPanel

-- Stamina Bar
local staminaLabel = Instance.new("TextLabel")
staminaLabel.Name = "StaminaLabel"
staminaLabel.Text = "Năng Lượng 14095/14095"
staminaLabel.TextSize = 12
staminaLabel.TextColor3 = COLOR_BLACK
staminaLabel.BackgroundColor3 = COLOR_CYAN
staminaLabel.BorderSizePixel = 1
staminaLabel.BorderColor3 = COLOR_YELLOW
staminaLabel.Size = UDim2.new(1, -10, 0, 25)
staminaLabel.Position = UDim2.new(0, 5, 0, 150)
staminaLabel.Parent = leftPanel

-- Make GUI draggable
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

-- Toggle GUI with M key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.M then
		screenGui.Enabled = not screenGui.Enabled
	end
end)

UI.screenGui = screenGui

return UI
