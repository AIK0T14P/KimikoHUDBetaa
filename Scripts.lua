-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Variables principales
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Función para crear GUI
local function CreateGui()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OptimizationGui"
    ScreenGui.ResetOnSpawn = false
    
    -- Intentar establecer IgnoreGuiInset y ZIndexBehavior
    pcall(function()
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    end)
    
    -- Intentar establecer el Parent
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    return ScreenGui
end

-- Crear GUI principal
local ScreenGui = CreateGui()

-- Crear pantalla de carga
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
LoadingFrame.Parent = ScreenGui

local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(1, 0, 0, 40)
LoadingText.Position = UDim2.new(0, 0, 0.5, -20)
LoadingText.BackgroundTransparency = 1
LoadingText.Font = Enum.Font.GothamBold
LoadingText.Text = "Cargando..."
LoadingText.TextColor3 = Color3.new(1, 1, 1)
LoadingText.TextSize = 24
LoadingText.Parent = LoadingFrame

-- Función para optimizar gráficos
local function OptimizeGraphics(enable)
    local lighting = game:GetService("Lighting")
    if enable then
        settings().Rendering.QualityLevel = 1
        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
        lighting.Brightness = 0
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
        for i, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v.Enabled = false
            elseif v:IsA("MeshPart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
                v.TextureID = 10385902758728957
            end
        end
    else
        settings().Rendering.QualityLevel = 7
        lighting.GlobalShadows = true
        lighting.FogEnd = 100000
        lighting.Brightness = 2
    end
end

-- Botón de optimización
local OptimizeButton = Instance.new("TextButton")
OptimizeButton.Size = UDim2.new(0, 200, 0, 50)
OptimizeButton.Position = UDim2.new(0.5, -100, 0.5, 25)
OptimizeButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
OptimizeButton.Font = Enum.Font.GothamBold
OptimizeButton.Text = "Optimizar"
OptimizeButton.TextColor3 = Color3.new(1, 1, 1)
OptimizeButton.TextSize = 18
OptimizeButton.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = OptimizeButton

local Optimized = false

OptimizeButton.MouseButton1Click:Connect(function()
    Optimized = not Optimized
    OptimizeGraphics(Optimized)
    OptimizeButton.Text = Optimized and "Desactivar Optimización" or "Optimizar"
    OptimizeButton.BackgroundColor3 = Optimized and Color3.fromRGB(215, 0, 0) or Color3.fromRGB(0, 120, 215)
end)

-- Función para hacer el botón arrastrable
local Dragging
local DragInput
local DragStart
local StartPos

local function Update(input)
    local Delta = input.Position - DragStart
    OptimizeButton.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
end

OptimizeButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = OptimizeButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

OptimizeButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        Update(input)
    end
end)

-- Eliminar la pantalla de carga después de 2 segundos
wait(2)
LoadingFrame:Destroy()

print("Script de optimización cargado correctamente.")
