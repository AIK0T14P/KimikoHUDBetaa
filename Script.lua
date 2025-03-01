-- Servicios
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

-- Variables principales
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- Variables para el sistema de arrastre
local Dragging = false
local DragStart = nil
local StartPos = nil

-- Variables para guardado de posiciones
local SavedPositions = {}
local RespawnPoint = nil

-- Sistema de acceso por tiempo
local AccessSystem = {
    AdminUser = "AIK0T14",
    Users = {},
    SaveFileName = "AccessSystem.json"
}

-- Función para guardar los datos de acceso
function AccessSystem:SaveData()
    local data = HttpService:JSONEncode(self.Users)
    writefile(self.SaveFileName, data)
end

-- Función para cargar los datos de acceso
function AccessSystem:LoadData()
    if isfile(self.SaveFileName) then
        local data = readfile(self.SaveFileName)
        self.Users = HttpService:JSONDecode(data)
    end
end

-- Función para agregar o modificar el acceso de un usuario
function AccessSystem:SetAccess(username, duration)
    self.Users[username] = {
        EndTime = os.time() + duration
    }
    self:SaveData()
end

-- Función para eliminar el acceso de un usuario
function AccessSystem:RemoveAccess(username)
    self.Users[username] = nil
    self:SaveData()
end

-- Función para verificar si un usuario tiene acceso
function AccessSystem:HasAccess(username)
    local user = self.Users[username]
    if user then
        return os.time() < user.EndTime
    end
    return false
end

-- Función para obtener el tiempo restante de acceso
function AccessSystem:GetRemainingTime(username)
    local user = self.Users[username]
    if user then
        local remainingTime = user.EndTime - os.time()
        return remainingTime > 0 and remainingTime or 0
    end
    return 0
end

-- Cargar datos de acceso al inicio
AccessSystem:LoadData()

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EnhancedGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Botón para mostrar/ocultar
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(1, -60, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
ToggleButton.Image = "rbxassetid://3926305904"
ToggleButton.ImageRectOffset = Vector2.new(764, 244)
ToggleButton.ImageRectSize = Vector2.new(36, 36)
ToggleButton.Parent = ScreenGui
ToggleButton.ZIndex = 100

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

-- Frame Principal con borde morado y gradiente
local MainBorder = Instance.new("Frame")
MainBorder.Name = "MainBorder"
MainBorder.Size = UDim2.new(0, 600, 0, 400)
MainBorder.Position = UDim2.new(0.5, -300, 0.5, -200)
MainBorder.BackgroundColor3 = Color3.fromRGB(157, 122, 229)
MainBorder.BorderSizePixel = 0
MainBorder.Visible = false
MainBorder.Parent = ScreenGui
MainBorder.ZIndex = 10

-- Añadir gradiente al borde
local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 90
UIGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.8, 0),
    NumberSequenceKeypoint.new(1, 1)
})
UIGradient.Parent = MainBorder

local MainBorderCorner = Instance.new("UICorner")
MainBorderCorner.CornerRadius = UDim.new(0, 12)
MainBorderCorner.Parent = MainBorder

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(1, -4, 1, -4)
MainFrame.Position = UDim2.new(0, 2, 0, 2)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainBorder
MainFrame.ZIndex = 11

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Título "Kimiko HUD Beta"
local Title = Instance.new("TextButton")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "Kimiko HUD Beta"
Title.TextColor3 = Color3.fromRGB(147, 112, 219)
Title.TextSize = 24
Title.Parent = MainFrame
Title.ZIndex = 12

-- Sistema de arrastre
local function UpdateDrag(input)
    if Dragging then
        local delta = input.Position - DragStart
        MainBorder.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + delta.Y
        )
    end
end

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainBorder.Position
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        UpdateDrag(input)
    end
end)

Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

-- Sidebar con scroll
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0.25, 0, 1, -60)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Sidebar.BackgroundTransparency = 0.1
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 4
Sidebar.ScrollBarImageColor3 = Color3.fromRGB(147, 112, 219)
Sidebar.Parent = MainFrame
Sidebar.ZIndex = 12

-- Contenedor principal con scroll
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(0.75, 0, 1, -60)
ContentFrame.Position = UDim2.new(0.25, 0, 0, 50)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ContentFrame.BackgroundTransparency = 0.1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 6
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(147, 112, 219)
ContentFrame.Parent = MainFrame
ContentFrame.ZIndex = 12

-- Función para crear categorías en el sidebar
local function CreateCategory(name, icon, position)
    local CategoryButton = Instance.new("TextButton")
    CategoryButton.Name = name.."Category"
    CategoryButton.Size = UDim2.new(1, -20, 0, 40)
    CategoryButton.Position = UDim2.new(0, 10, 0, position)
    CategoryButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    CategoryButton.BorderSizePixel = 0
    CategoryButton.Font = Enum.Font.GothamSemibold
    CategoryButton.TextSize = 14
    CategoryButton.Parent = Sidebar
    CategoryButton.ZIndex = 13
    
    local IconImage = Instance.new("ImageLabel")
    IconImage.Size = UDim2.new(0, 20, 0, 20)
    IconImage.Position = UDim2.new(0, 2, 0.5, -10)
    IconImage.BackgroundTransparency = 1
    IconImage.Image = icon
    IconImage.Parent = CategoryButton
    IconImage.ZIndex = 14
    
    CategoryButton.Text = name
    CategoryButton.TextXAlignment = Enum.TextXAlignment.Left
    CategoryButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryButton.AutoButtonColor = false
    
    local TextPadding = Instance.new("UIPadding")
    TextPadding.PaddingLeft = UDim.new(0, 25)
    TextPadding.Parent = CategoryButton
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = CategoryButton
    
    return CategoryButton
end

-- Función para crear secciones de contenido
local function CreateSection(name)
    local Section = Instance.new("ScrollingFrame")
    Section.Name = name.."Section"
    Section.Size = UDim2.new(1, -40, 1, -20)
    Section.Position = UDim2.new(0, 20, 0, 10)
    Section.BackgroundTransparency = 1
    Section.BorderSizePixel = 0
    Section.ScrollBarThickness = 6
    Section.ScrollBarImageColor3 = Color3.fromRGB(147, 112, 219)
    Section.Visible = false
    Section.Parent = ContentFrame
    Section.ZIndex = 13
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = Section
    
    -- Ajustar el tamaño del contenido automáticamente
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Section.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    return Section
end

-- Función para crear botones de toggle
local function CreateToggle(name, section, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleFrame.Parent = section
    ToggleFrame.ZIndex = 14
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    Label.ZIndex = 15
    
    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 40, 0, 20)
    Switch.Position = UDim2.new(1, -50, 0.5, -10)
    Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Switch.BorderSizePixel = 0
    Switch.Text = ""
    Switch.Parent = ToggleFrame
    Switch.ZIndex = 15
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = Switch
    Circle.ZIndex = 16
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    local Enabled = false
    local Connection
    
    local function Toggle()
        Enabled = not Enabled
        local Goal = {
            BackgroundColor3 = Enabled and Color3.fromRGB(147, 112, 219) or Color3.fromRGB(60, 60, 60),
            Position = Enabled and UDim2.new(0, 22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = Goal.Position}):Play()
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Goal.BackgroundColor3}):Play()
        
        if Connection then
            Connection:Disconnect()
            Connection = nil
        end
        
        callback(Enabled)
    end
    
    Switch.MouseButton1Click:Connect(Toggle)
    
    local function GetState()
        return Enabled
    end
    
    local function SetState(state)
        if state ~= Enabled then
            Toggle()
        end
    end
    
    return {
        Toggle = Toggle,
        GetState = GetState,
        SetState = SetState
    }
end

-- Función para crear sliders
local function CreateSlider(name, section, callback, min, max, default)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderFrame.Parent = section
    SliderFrame.ZIndex = 14
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = name .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    Label.ZIndex = 15
    
    local SliderBar = Instance.new("TextButton")
    SliderBar.Name = "SliderBar"
    SliderBar.Size = UDim2.new(1, -20, 0, 20)
    SliderBar.Position = UDim2.new(0, 10, 0, 30)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBar.BorderSizePixel = 0
    SliderBar.AutoButtonColor = false
    SliderBar.Text = ""
    SliderBar.Parent = SliderFrame
    SliderBar.ZIndex = 15
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1, 0)
    SliderCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    SliderFill.ZIndex = 16
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local Value = default
    local Dragging = false
    
    local function UpdateSlider(input)
        local sizeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        Value = math.floor(min + ((max - min) * sizeX))
        SliderFill.Size = UDim2.new(sizeX, 0, 1, 0)
        Label.Text = name .. ": " .. Value
        callback(Value)
    end
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            UpdateSlider(input)
        end
    end)
    
    SliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    
    return function()
        return Value
    end
end

-- Categorías actualizadas
local Categories = {
    {name = "Movement", icon = "rbxassetid://3926307971"},
    {name = "Combat", icon = "rbxassetid://3926307971"},
    {name = "Visuals", icon = "rbxassetid://3926307971"},
    {name = "Player", icon = "rbxassetid://3926307971"},
    {name = "World", icon = "rbxassetid://3926307971"},
    {name = "Optimization", icon = "rbxassetid://3926307971"},
    {name = "Misc", icon = "rbxassetid://3926307971"},
    {name = "Settings", icon = "rbxassetid://3926307971"},
    {name = "Access", icon = "rbxassetid://3926307971"}  -- Nueva categoría para el sistema de acceso
}

-- Crear categorías y secciones
local Sections = {}
local ActiveCategory = nil

for i, category in ipairs(Categories) do
    local button = CreateCategory(category.name, category.icon, (i-1) * 50)
    Sections[category.name] = CreateSection(category.name)
end

-- Función para crear la sección de acceso
local function CreateAccessSection()
    local AccessSection = Sections.Access
    
    -- Input para el nombre de usuario
    local UsernameInput = Instance.new("TextBox")
    UsernameInput.Size = UDim2.new(1, -20, 0, 30)
    UsernameInput.Position = UDim2.new(0, 10, 0, 10)
    UsernameInput.PlaceholderText = "Nombre de usuario"
    UsernameInput.Parent = AccessSection
    
    -- Input para la duración del acceso
    local DurationInput = Instance.new("TextBox")
    DurationInput.Size = UDim2.new(1, -20, 0, 30)
    DurationInput.Position = UDim2.new(0, 10, 0, 50)
    DurationInput.PlaceholderText = "Duración en segundos"
    DurationInput.Parent = AccessSection
    
    -- Botón para agregar acceso
    local AddButton = Instance.new("TextButton")
    AddButton.Size = UDim2.new(1, -20, 0, 30)
    AddButton.Position = UDim2.new(0, 10, 0, 90)
    AddButton.Text = "Agregar acceso"
    AddButton.Parent = AccessSection
    
    AddButton.MouseButton1Click:Connect(function()
        local username = UsernameInput.Text
        local duration = tonumber(DurationInput.Text)
        if username ~= "" and duration then
            AccessSystem:SetAccess(username, duration)
            print("Acceso agregado para " .. username .. " por " .. duration .. " segundos.")
        end
    end)
    
    -- Botón para eliminar acceso
    local RemoveButton = Instance.new("TextButton")
    RemoveButton.Size = UDim2.new(1, -20, 0, 30)
    RemoveButton.Position = UDim2.new(0, 10, 0, 130)
    RemoveButton.Text = "Eliminar acceso"
    RemoveButton.Parent = AccessSection
    
    RemoveButton.MouseButton1Click:Connect(function()
        local username = UsernameInput.Text
        if username ~= "" then
            AccessSystem:RemoveAccess(username)
            print("Acceso eliminado para " .. username)
        end
    end)
end

-- Crear la sección de acceso
CreateAccessSection()

-- Función para mostrar/ocultar la sección de acceso según el usuario
local function UpdateAccessVisibility()
    local accessCategory = Sidebar:FindFirstChild("AccessCategory")
    if accessCategory then
        accessCategory.Visible = (LocalPlayer.Name == AccessSystem.AdminUser)
    end
end

-- Actualizar la visibilidad de la sección de acceso al inicio
UpdateAccessVisibility()

-- Manejar la visibilidad de las secciones y mantener el color morado
local function ShowSection(sectionName)
    for name, section in pairs(Sections) do
        section.Visible = (name == sectionName)
        local button = Sidebar:FindFirstChild(name.."Category")
        if button then
            button.BackgroundColor3 = (name == sectionName) and Color3.fromRGB(147, 112, 219) or Color3.fromRGB(45, 45, 45)
        end
    end
    ActiveCategory = sectionName
end

for _, category in ipairs(Categories) do
    local button = Sidebar:FindFirstChild(category.name.."Category")
    if button then
        button.MouseButton1Click:Connect(function()
            ShowSection(category.name)
        end)
    end
end

-- Animación del botón de toggle
ToggleButton.MouseButton1Click:Connect(function()
    MainBorder.Visible = not MainBorder.Visible
    local goal = {
        Rotation = MainBorder.Visible and 180 or 0,
        Size = MainBorder.Visible and UDim2.new(0, 800, 0, 600) or UDim2.new(0, 0, 0, 0)
    }
    TweenService:Create(ToggleButton, TweenInfo.new(0.3), {Rotation = goal.Rotation}):Play()
    TweenService:Create(MainBorder, TweenInfo.new(0.3), {Size = goal.Size}):Play()
end)

-- Manejar el respawn del personaje
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

-- Mostrar la primera sección por defecto
ShowSection("Movement")

-- Crear un frame para mostrar el tiempo restante de acceso
local AccessTimeFrame = Instance.new("Frame")
AccessTimeFrame.Size = UDim2.new(0, 200, 0, 30)
AccessTimeFrame.Position = UDim2.new(1, -210, 0, 10)
AccessTimeFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AccessTimeFrame.Parent = ScreenGui

local AccessTimeLabel = Instance.new("TextLabel")
AccessTimeLabel.Size = UDim2.new(1, 0, 1, 0)
AccessTimeLabel.BackgroundTransparency = 1
AccessTimeLabel.Font = Enum.Font.GothamSemibold
AccessTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AccessTimeLabel.TextSize = 14
AccessTimeLabel.Parent = AccessTimeFrame

-- Función para actualizar el tiempo de acceso mostrado
local function UpdateAccessTimeDisplay()
    local remainingTime = AccessSystem:GetRemainingTime(LocalPlayer.Name)
    if remainingTime > 0 then
        AccessTimeLabel.Text = "Tiempo restante: " .. math.floor(remainingTime / 60) .. "m " .. remainingTime % 60 .. "s"
        AccessTimeFrame.Visible = true
    else
        AccessTimeFrame.Visible = false
    end
end

-- Actualizar el tiempo de acceso cada segundo
spawn(function()
    while wait(1) do
        UpdateAccessTimeDisplay()
    end
end)

-- Función para verificar el acceso y mostrar la pantalla de bloqueo si es necesario
local function CheckAccess()
    if not AccessSystem:HasAccess(LocalPlayer.Name) and LocalPlayer.Name ~= AccessSystem.AdminUser then
        -- Crear pantalla de bloqueo
        local BlockScreen = Instance.new("Frame")
        BlockScreen.Size = UDim2.new(1, 0, 1, 0)
        BlockScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        BlockScreen.BackgroundTransparency = 0.5
        BlockScreen.ZIndex = 1000
        BlockScreen.Parent = ScreenGui

        local BlockMessage = Instance.new("TextLabel")
        BlockMessage.Size = UDim2.new(1, 0, 0, 50)
        BlockMessage.Position = UDim2.new(0, 0, 0.5, -25)
        BlockMessage.BackgroundTransparency = 1
        BlockMessage.Font = Enum.Font.GothamBold
        BlockMessage.Text = "No tienes acceso. Contacta al administrador."
        BlockMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
        BlockMessage.TextSize = 24
        BlockMessage.ZIndex = 1001
        BlockMessage.Parent = BlockScreen

        -- Deshabilitar la interacción con el menú principal
        MainBorder.Visible = false
        ToggleButton.Visible = false
    else
        -- Eliminar la pantalla de bloqueo si existe
        local existingBlockScreen = ScreenGui:FindFirstChild("BlockScreen")
        if existingBlockScreen then
            existingBlockScreen:Destroy()
        end
        ToggleButton.Visible = true
    end
end

-- Verificar el acceso cada 5 segundos
spawn(function()
    while wait(5) do
        CheckAccess()
    end
end)

-- Verificar el acceso al inicio
CheckAccess()

-- Mensaje de confirmación
print("Script mejorado cargado correctamente. Use el botón en la esquina superior derecha para mostrar/ocultar el menú.")

