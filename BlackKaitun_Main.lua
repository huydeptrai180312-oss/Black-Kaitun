loadstring(game:HttpGet("https://raw.githubusercontent.com/fakekuri/NightXmixother/main/jointeam.lua"))()

-- local sitink
local sitinklib = loadstring(game:HttpGet("https://github.com/ErutTheTeru/uilibrary/blob/main/Sitink%20Lib/Source.lua?raw=true"))()
local Notify = sitinklib:Notify({
	["Title"] = "Black Kaitun ",
	["Description"] = "| Make by Shay",
	["Color"] = Color3.fromRGB(0,0,0, 146.00000649690628, 242.00000077486038),
	["Content"] = "Load Success!",
	["Time"] = 1,
	["Delay"] = 10
})
-- Main UI

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local blur = Instance.new("BlurEffect")
blur.Size = 20
blur.Parent = Lighting

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SkullHubUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundTransparency = 1
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.Parent = screenGui

local compactButton = Instance.new("TextButton")
compactButton.Size = UDim2.new(0, 60, 0, 60)
compactButton.Position = UDim2.new(0.5, -30, 0, -80)
compactButton.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
compactButton.Text = "▲"
compactButton.TextColor3 = Color3.fromRGB(255, 255, 255)
compactButton.Font = Enum.Font.FredokaOne
compactButton.TextSize = 24
compactButton.Visible = false
compactButton.Parent = mainFrame

local compactCorner = Instance.new("UICorner")
compactCorner.CornerRadius = UDim.new(1, 0)
compactCorner.Parent = compactButton

local compactStroke = Instance.new("UIStroke")
compactStroke.Thickness = 2
compactStroke.Color = Color3.fromRGB(72, 138, 182)
compactStroke.Transparency = 0.3
compactStroke.Parent = compactButton

local uiContainer = Instance.new("Frame")
uiContainer.Size = UDim2.new(0, 450, 0, 240)
uiContainer.Position = UDim2.new(0.5, -225, 1, 100)
uiContainer.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
uiContainer.BackgroundTransparency = 0.1
uiContainer.Parent = mainFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = uiContainer

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255,255,255)
stroke.Transparency = 0.3
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = uiContainer

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(72, 138, 182)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
})
gradient.Rotation = 45
gradient.Parent = uiContainer

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -40, 0, 10)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.FredokaOne
minimizeButton.TextSize = 20
minimizeButton.Parent = uiContainer

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimizeButton

local icon = Instance.new("ImageLabel")
icon.Size = UDim2.new(0, 64, 0, 64)
icon.Position = UDim2.new(0.5, -32, 0, 16)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://93951724347885 "
icon.Parent = uiContainer

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 90)
title.BackgroundTransparency = 1
title.Text = "Kaitun BF is Running"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 32
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = uiContainer

local desc = Instance.new("TextLabel")
desc.Size = UDim2.new(1, -40, 0, 60)
desc.Position = UDim2.new(0, 20, 0, 140)
desc.BackgroundTransparency = 1
desc.Text = "HNC rác"
desc.TextColor3 = Color3.fromRGB(180, 180, 180)
desc.Font = Enum.Font.FredokaOne
desc.TextSize = 16
desc.TextWrapped = true
desc.TextYAlignment = Enum.TextYAlignment.Top
desc.TextXAlignment = Enum.TextXAlignment.Center
desc.Parent = uiContainer

local isMinimized = false

local function toggleMinimize()
    isMinimized = not isMinimized
    
    if isMinimized then
        -- Minimize animation
        TweenService:Create(uiContainer, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -225, 0, -300),
            Size = UDim2.new(0, 450, 0, 0)
        }):Play()
        
        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        }):Play()
        
        task.wait(0.2)
        compactButton.Visible = true
        TweenService:Create(compactButton, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -30, 0, 10)
        }):Play()
        
        blur.Size = 0
        minimizeButton.Text = "+"
    else
        -- Maximize animation
        TweenService:Create(compactButton, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -30, 0, -80)
        }):Play()
        
        task.wait(0.2)
        compactButton.Visible = false
        
        TweenService:Create(uiContainer, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -225, 0.5, -120),
            Size = UDim2.new(0, 450, 0, 240)
        }):Play()
        
        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.4
        }):Play()
        
        blur.Size = 20
        minimizeButton.Text = "-"
    end
end

minimizeButton.MouseButton1Click:Connect(toggleMinimize)
compactButton.MouseButton1Click:Connect(toggleMinimize)

task.wait(0.1)

TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0.4
}):Play()

TweenService:Create(uiContainer, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -225, 0.5, -120)
}):Play()

-- Auto Detection
spawn(function()
		pcall(function()
			while wait() do
				if _G.XERUNKAITUN and World1 then
					if game.Players.LocalPlayer.Data.Level.Value >= 311 then
						_G.AutoPlayerHunter = false
					end
				end
			end
		end)
	end)

if game.PlaceId == 2753915549 then
    World1 = true
elseif game.PlaceId == 4442272183 then
    World2 = true
elseif game.PlaceId == 7449423635 then
    World3 = true
end

-- Load the comprehensive farming system
_G.XERUNKAITUN = true
_G.AutoFarm = true
_G.FastFarmMode = true
_G.BringMode = 300
_G.AUTOHAKI = true
_G.BringMonster = true
_G.AutoSetSpawn = true
_G.AutoSuperhuman = true
_G.AutoBuyLegendarySword = true
_G.AutoBringFruit = true
_G.AutoStoreSsFruit = true
_G.Remove_trct = true
getgenv().AutoRejoin = true
getgenv().remove = true
getgenv().removeheavy = true
getgenv().DisnableDame = true
_G.RemoveHit = true
_G.BuyAllAib = true
_G.BuyAllSword = true
_G.AutoSelectDungeon = true
_G.AutoBuyChip = true
_G.Auto_StartRaid = true
_G.Kill_Aura = true
_G.Auto_Dungeon = true
_G.Dun = true

print("[Kaitun] Complete Automation System Loaded Successfully!")
print("[Kaitun] Auto Farm: ENABLED")
print("[Kaitun] Auto Haki: ENABLED")
print("[Kaitun] Monster Bring: ENABLED")
print("[Kaitun] Raid System: ENABLED")

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
