-- Delta Executor uyumlu ImGui + ESP
-- GitHub'a script.lua olarak yükle, raw URL'yi kullan

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Güvenli parent
local parent = (typeof(gethui) == "function" and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Temizlik
for _, v in ipairs(parent:GetChildren()) do
    if v.Name == "RonuxUI" then v:Destroy() end
end

-- Ana GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RonuxUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parent

-- Ana Frame (ImGui tarzı)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 260)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Kenarlık (premium görünüm)
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(80, 140, 255)
UIStroke.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 36)
Title.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
Title.Text = "Ronux"
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- ESP Toggle Button
local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(0, 160, 0, 42)
ESPButton.Position = UDim2.new(0, 20, 0, 60)
ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ESPButton.Text = "ESP: KAPALI"
ESPButton.TextSize = 14
ESPButton.Font = Enum.Font.GothamSemibold
ESPButton.TextColor3 = Color3.fromRGB(200, 200, 200)
ESPButton.Parent = MainFrame

local ESPButtonCorner = Instance.new("UICorner")
ESPButtonCorner.CornerRadius = UDim.new(0, 6)
ESPButtonCorner.Parent = ESPButton

local ESPButtonStroke = Instance.new("UIStroke")
ESPButtonStroke.Thickness = 1
ESPButtonStroke.Color = Color3.fromRGB(80, 140, 255)
ESPButtonStroke.Transparency = 0.5
ESPButtonStroke.Parent = ESPButton

-- İkinci buton
local InfoButton = Instance.new("TextButton")
InfoButton.Size = UDim2.new(0, 160, 0, 42)
InfoButton.Position = UDim2.new(0, 200, 0, 60)
InfoButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
InfoButton.Text = "Durum: Hazır"
InfoButton.TextSize = 14
InfoButton.Font = Enum.Font.GothamSemibold
InfoButton.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoButton.Parent = MainFrame

local InfoButtonCorner = Instance.new("UICorner")
InfoButtonCorner.CornerRadius = UDim.new(0, 6)
InfoButtonCorner.Parent = InfoButton

-- Alt bilgi
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, -40, 0, 30)
Footer.Position = UDim2.new(0, 20, 1, -45)
Footer.BackgroundTransparency = 1
Footer.Text = "Delta Executor | Ronux"
Footer.TextSize = 11
Footer.Font = Enum.Font.Gotham
Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
Footer.Parent = MainFrame

-- ESP Sistemi
local espEnabled = false
local espObjects = {}

local function ApplyESP(player)
    if player == LocalPlayer then return end
    
    local function Setup(character)
        if espObjects[player] then
            for _, obj in pairs(espObjects[player]) do
                if obj and obj.Parent then obj:Destroy() end
            end
        end
        
        espObjects[player] = {}
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "RonuxESP"
        highlight.FillColor = Color3.fromRGB(255, 50, 50)
        highlight.FillTransparency = 0.6
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character
        
        table.insert(espObjects[player], highlight)
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "RonuxName"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 100, 0, 20)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Parent = character
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.Parent = billboard
        
        table.insert(espObjects[player], billboard)
    end
    
    if player.Character then Setup(player.Character) end
    player.CharacterAdded:Connect(Setup)
end

local function ClearESP()
    for _, objs in pairs(espObjects) do
        for _, obj in pairs(objs) do
            if obj and obj.Parent then obj:Destroy() end
        end
    end
    espObjects = {}
end

-- ESP Toggle
ESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    
    if espEnabled then
        ESPButton.Text = "ESP: ACIK"
        ESPButton.TextColor3 = Color3.fromRGB(100, 255, 100)
        ESPButtonStroke.Color = Color3.fromRGB(100, 255, 100)
        
        for _, player in ipairs(Players:GetPlayers()) do
            ApplyESP(player)
        end
        Players.PlayerAdded:Connect(ApplyESP)
    else
        ESPButton.Text = "ESP: KAPALI"
        ESPButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        ESPButtonStroke.Color = Color3.fromRGB(80, 140, 255)
        ClearESP()
    end
end)

-- Başlangıç mesajı
print("Ronux yüklendi | Delta Executor")
