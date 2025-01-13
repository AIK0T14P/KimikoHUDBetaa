-- Services
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables principales
local LocalPlayer = Players.LocalPlayer
local Enabled = false
local InputFolder = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Input")
local ArrowGui = LocalPlayer.PlayerGui:WaitForChild("Game"):WaitForChild("UI"):WaitForChild("PlayerFrame")

-- Mapeo de teclas
local KeyBinds = {
    ["Left"] = "Left",
    ["Down"] = "Down",
    ["Up"] = "Up",
    ["Right"] = "Right",
}

-- Variables de configuración
local CONFIG = {
    HitAccuracy = 96,    -- Porcentaje de precisión (0-100)
    VisualOffset = 0,    -- Ajuste visual de las notas (-10 a 10)
    AutoDelay = 20,      -- Retraso en ms (0-50)
    HitDelayMax = 50,    -- Máximo retraso de golpe (20-100)
}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FunkyFridayAutoplay"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Esquinas redondeadas
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Funky Friday Autoplay"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Botón de Activación
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
ToggleButton.Text = "Activar Autoplay"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.GothamSemibold
ToggleButton.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

-- Función para crear sliders
local function CreateSlider(title, defaultValue, minValue, maxValue, yPosition)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(0.8, 0, 0, 60)
    SliderFrame.Position = UDim2.new(0.1, 0, 0, yPosition)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = MainFrame

    local SliderTitle = Instance.new("TextLabel")
    SliderTitle.Size = UDim2.new(1, 0, 0, 20)
    SliderTitle.BackgroundTransparency = 1
    SliderTitle.Text = title .. ": " .. defaultValue
    SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderTitle.TextSize = 14
    SliderTitle.Font = Enum.Font.GothamSemibold
    SliderTitle.Parent = SliderFrame

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, 0, 0, 4)
    SliderBar.Position = UDim2.new(0, 0, 0.7, 0)
    SliderBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    SliderBar.Parent = SliderFrame

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((defaultValue - minValue)/(maxValue - minValue), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
    SliderFill.Parent = SliderBar

    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 12, 0, 12)
    SliderButton.Position = UDim2.new((defaultValue - minValue)/(maxValue - minValue), -6, 0.5, -6)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = SliderButton

    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local value = math.floor(minValue + (pos * (maxValue - minValue)))
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        SliderButton.Position = UDim2.new(pos, -6, 0.5, -6)
        SliderTitle.Text = title .. ": " .. value
        return value
    end

    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local value = updateSlider(input)
            if title == "Precisión" then
                CONFIG.HitAccuracy = value
            elseif title == "Offset Visual" then
                CONFIG.VisualOffset = value
            elseif title == "Retraso Auto" then
                CONFIG.AutoDelay = value
            elseif title == "Retraso Máximo" then
                CONFIG.HitDelayMax = value
            end
        end
    end)
end

-- Crear sliders
CreateSlider("Precisión", CONFIG.HitAccuracy, 0, 100, 120)
CreateSlider("Offset Visual", CONFIG.VisualOffset, -10, 10, 190)
CreateSlider("Retraso Auto", CONFIG.AutoDelay, 0, 50, 260)
CreateSlider("Retraso Máximo", CONFIG.HitDelayMax, 20, 100, 330)

-- Botón de Toggle flotante
local FloatingButton = Instance.new("ImageButton")
FloatingButton.Size = UDim2.new(0, 40, 0, 40)
FloatingButton.Position = UDim2.new(0, 10, 0.5, -20)
FloatingButton.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
FloatingButton.Image = "rbxassetid://3926305904"
FloatingButton.Parent = ScreenGui

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(1, 0)
FloatingCorner.Parent = FloatingButton

-- Sistema de detección y autopresión de notas
local function GetClosestNote(arrows)
    local closest = nil
    local minDist = math.huge
    
    for _, arrow in pairs(arrows) do
        if arrow:FindFirstChild("Position") then
            local pos = arrow.Position.Value
            if pos > -150 and pos < 150 then
                local dist = math.abs(pos)
                if dist < minDist then
                    minDist = dist
                    closest = arrow
                end
            end
        end
    end
    
    return closest
end

local function PressKey(key)
    if math.random(1, 100) <= CONFIG.HitAccuracy then
        local delay = math.random(CONFIG.AutoDelay, CONFIG.HitDelayMax) / 1000
        wait(delay)
        InputFolder:FireServer(key, "down")
        wait(0.05)
        InputFolder:FireServer(key, "up")
    end
end

-- Sistema principal de autoplay
local function AutoPlay()
    while Enabled do
        local success, error = pcall(function()
            for _, arrow in pairs(ArrowGui:GetChildren()) do
                if arrow:IsA("Frame") and arrow:FindFirstChild("Position") then
                    local pos = arrow.Position.Value + CONFIG.VisualOffset
                    if pos >= -5 and pos <= 5 then
                        local direction = arrow.Name:match("Arrow(.+)")
                        if direction and KeyBinds[direction] then
                            PressKey(KeyBinds[direction])
                        end
                    end
                end
            end
        end)
        if not success then
            warn("Error en AutoPlay:", error)
        end
        RunService.RenderStepped:Wait()
    end
end

-- Conexiones de botones
ToggleButton.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    ToggleButton.BackgroundColor3 = Enabled and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(147, 112, 219)
    ToggleButton.Text = Enabled and "Desactivar Autoplay" or "Activar Autoplay"
    
    if Enabled then
        coroutine.wrap(AutoPlay)()
    end
end)

FloatingButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Mensaje de inicio
print("Script de Funky Friday cargado correctamente")
