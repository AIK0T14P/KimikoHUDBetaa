-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

-- Variables principales
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- Sistema de idiomas
local Languages = {
    ["English"] = {
        categories = {
            Home = "Home",
            Movement = "Movement",
            Combat = "Combat",
            Visuals = "Visuals",
            Player = "Player",
            World = "World",
            Optimization = "Optimization",
            Misc = "Misc",
            Settings = "Settings"
        },
        features = {
            -- [Resto del sistema de idiomas se mantiene igual...]
        }
    },
    ["Español"] = {
        categories = {
            -- [Categorías en español se mantienen igual...]
        },
        features = {
            -- [Features en español se mantienen igual...]
        }
    }
}

local CurrentLanguage = "English"
local Texts = Languages[CurrentLanguage]

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EnhancedGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Botón de Toggle con nuevo diseño
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
ToggleButton.Text = ""
ToggleButton.AutoButtonColor = false
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

-- Frame Principal con nuevo diseño
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Barra lateral
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.Parent = Sidebar

-- Contenedor principal
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -160, 1, -10)
ContentFrame.Position = UDim2.new(0, 155, 0, 5)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentFrame

-- Función para crear categorías
local function CreateCategory(name)
    local CategoryButton = Instance.new("TextButton")
    CategoryButton.Name = name.."Category"
    CategoryButton.Size = UDim2.new(1, -10, 0, 40)
    CategoryButton.Position = UDim2.new(0, 5, 0, 0)
    CategoryButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CategoryButton.Text = name
    CategoryButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryButton.TextSize = 14
    CategoryButton.Font = Enum.Font.GothamSemibold
    CategoryButton.AutoButtonColor = false
    CategoryButton.Parent = Sidebar

    local CategoryCorner = Instance.new("UICorner")
    CategoryCorner.CornerRadius = UDim.new(0, 6)
    CategoryCorner.Parent = CategoryButton

    return CategoryButton
end

-- Función para crear secciones
local function CreateSection(name)
    local Section = Instance.new("ScrollingFrame")
    Section.Name = name.."Section"
    Section.Size = UDim2.new(1, -20, 1, -20)
    Section.Position = UDim2.new(0, 10, 0, 10)
    Section.BackgroundTransparency = 1
    Section.ScrollBarThickness = 4
    Section.Visible = false
    Section.Parent = ContentFrame

    local SectionLayout = Instance.new("UIListLayout")
    SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SectionLayout.Padding = UDim.new(0, 10)
    SectionLayout.Parent = Section

    return Section
end

-- Función para crear botones de toggle mejorada
local function CreateToggle(name, section, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ToggleFrame.Parent = section

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Text = name
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 14
    ToggleButton.Font = Enum.Font.GothamSemibold
    ToggleButton.Parent = ToggleFrame

    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Size = UDim2.new(0, 40, 0, 20)
    ToggleIndicator.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ToggleIndicator.Parent = ToggleFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleIndicator

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleCircle.Parent = ToggleIndicator

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle

    local enabled = false

    ToggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        local goal = {
            Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
            BackgroundColor3 = enabled and Color3.fromRGB(147, 112, 219) or Color3.fromRGB(60, 60, 60)
        }
        
        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = goal.Position}):Play()
        TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {BackgroundColor3 = goal.BackgroundColor3}):Play()
        
        if callback then
            callback(enabled)
        end
    end)

    return ToggleButton
end

-- Crear categorías y secciones
local Categories = {"Home", "Movement", "Combat", "Visuals", "Player", "World", "Settings"}
local Sections = {}

for _, category in ipairs(Categories) do
    local button = CreateCategory(category)
    Sections[category] = CreateSection(category)
    
    button.MouseButton1Click:Connect(function()
        for _, section in pairs(Sections) do
            section.Visible = false
        end
        Sections[category].Visible = true
        
        for _, catButton in ipairs(Sidebar:GetChildren()) do
            if catButton:IsA("TextButton") then
                catButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
        end
        button.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
    end)
end

-- Manejar el toggle del menú principal
local menuVisible = false
ToggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
    
    -- Animación del botón
    local rotation = menuVisible and 180 or 0
    TweenService:Create(ToggleButton, TweenInfo.new(0.3), {Rotation = rotation}):Play()
end)

-- Mostrar la sección Home por defecto
Sections.Home.Visible = true
Sidebar:FindFirstChild("HomeCategory").BackgroundColor3 = Color3.fromRGB(147, 112, 219)

-- Ejemplo de creación de toggles
CreateToggle("Speed", Sections.Movement, function(enabled)
    if enabled then
        Humanoid.WalkSpeed = 50
    else
        Humanoid.WalkSpeed = 16
    end
end)

CreateToggle("Jump Power", Sections.Movement, function(enabled)
    if enabled then
        Humanoid.JumpPower = 100
    else
        Humanoid.JumpPower = 50
    end
end)

-- Manejar el respawn del personaje
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)
