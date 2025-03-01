-- Servicios
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local DataStoreService = game:GetService("DataStoreService")

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

-- Sistema de acceso por tiempo
local AccessSystem = {
    AdminUser = "AIK0T14",
    Users = {},
    DataStore = DataStoreService:GetDataStore("AccessSystem")
}

-- Función para guardar los datos de acceso en la nube
function AccessSystem:SaveData()
    local success, error = pcall(function()
        self.DataStore:SetAsync("Users", self.Users)
    end)
    if not success then
        warn("Error al guardar datos: " .. tostring(error))
    end
end

-- Función para cargar los datos de acceso desde la nube
function AccessSystem:LoadData()
    local success, result = pcall(function()
        return self.DataStore:GetAsync("Users")
    end)
    if success and result then
        self.Users = result
    else
        warn("Error al cargar datos: " .. tostring(result))
    end
end

-- Función para agregar o modificar el acceso de un usuario
function AccessSystem:SetAccess(username, hours)
    local seconds = hours * 3600
    self.Users[username] = {
        EndTime = os.time() + seconds,
        TotalTime = seconds
    }
    self:SaveData()
    self:UpdateAccessDisplay()
end

-- Función para eliminar el acceso de un usuario
function AccessSystem:RemoveAccess(username)
    self.Users[username] = nil
    self:SaveData()
    self:UpdateAccessDisplay()
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

-- Función para formatear el tiempo en días, horas, minutos y segundos
function FormatTime(seconds)
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%dd %02dh %02dm %02ds", days, hours, minutes, secs)
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
    {name = "Access", icon = "rbxassetid://3926307971"}  -- Categoría para el sistema de acceso
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
    
    -- Input para la duración del acceso en horas
    local DurationInput = Instance.new("TextBox")
    DurationInput.Size = UDim2.new(1, -20, 0, 30)
    DurationInput.Position = UDim2.new(0, 10, 0, 50)
    DurationInput.PlaceholderText = "Duración en horas"
    DurationInput.Parent = AccessSection
    
    -- Botón para agregar acceso
    local AddButton = Instance.new("TextButton")
    AddButton.Size = UDim2.new(1, -20, 0, 30)
    AddButton.Position = UDim2.new(0, 10, 0, 90)
    AddButton.Text = "Agregar acceso"
    AddButton.Parent = AccessSection
    
    -- Contenedor para10,0,90)
    AddButton.Text = "Agregar acceso"
    AddButton.Parent = AccessSection
    
    -- Contenedor para la lista de usuarios con acceso
    local UserListContainer = Instance.new("ScrollingFrame")
    UserListContainer.Size = UDim2.new(1, -20, 0, 200)
    UserListContainer.Position = UDim2.new(0, 10, 0, 130)
    UserListContainer.BackgroundTransparency = 1
    UserListContainer.ScrollBarThickness = 6
    UserListContainer.Parent = AccessSection
    
    local UserListLayout = Instance.new("UIListLayout")
    UserListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UserListLayout.Padding = UDim.new(0, 10)
    UserListLayout.Parent = UserListContainer
    
    -- Función para actualizar la lista de usuarios con acceso
    function AccessSystem:UpdateAccessDisplay()
        -- Limpiar la lista actual
        for _, child in pairs(UserListContainer:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        -- Agregar cada usuario a la lista
        for username, userData in pairs(self.Users) do
            local UserFrame = Instance.new("Frame")
            UserFrame.Size = UDim2.new(1, 0, 0, 60)
            UserFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            UserFrame.Parent = UserListContainer
            
            local UserAvatar = Instance.new("ImageLabel")
            UserAvatar.Size = UDim2.new(0, 50, 0, 50)
            UserAvatar.Position = UDim2.new(0, 5, 0, 5)
            UserAvatar.BackgroundTransparency = 1
            UserAvatar.Image = Players:GetUserThumbnailAsync(Players:GetUserIdFromNameAsync(username), Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size50x50)
            UserAvatar.Parent = UserFrame
            
            local UserNameLabel = Instance.new("TextLabel")
            UserNameLabel.Size = UDim2.new(0.5, -60, 0, 25)
            UserNameLabel.Position = UDim2.new(0, 60, 0, 5)
            UserNameLabel.BackgroundTransparency = 1
            UserNameLabel.Font = Enum.Font.GothamSemibold
            UserNameLabel.Text = username
            UserNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            UserNameLabel.TextSize = 14
            UserNameLabel.TextXAlignment = Enum.TextXAlignment.Left
            UserNameLabel.Parent = UserFrame
            
            local TimeRemainingLabel = Instance.new("TextLabel")
            TimeRemainingLabel.Size = UDim2.new(0.5, -60, 0, 25)
            TimeRemainingLabel.Position = UDim2.new(0, 60, 0, 30)
            TimeRemainingLabel.BackgroundTransparency = 1
            TimeRemainingLabel.Font = Enum.Font.Gotham
            TimeRemainingLabel.Text = "Tiempo restante: " .. FormatTime(self:GetRemainingTime(username))
            TimeRemainingLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            TimeRemainingLabel.TextSize = 12
            TimeRemainingLabel.TextXAlignment = Enum.TextXAlignment.Left
            TimeRemainingLabel.Parent = UserFrame
            
            local ModifyButton = Instance.new("TextButton")
            ModifyButton.Size = UDim2.new(0, 60, 0, 25)
            ModifyButton.Position = UDim2.new(1, -130, 0, 5)
            ModifyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
            ModifyButton.Text = "Modificar"
            ModifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            ModifyButton.TextSize = 12
            ModifyButton.Parent = UserFrame
            
            local DeleteButton = Instance.new("TextButton")
            DeleteButton.Size = UDim2.new(0, 60, 0, 25)
            DeleteButton.Position = UDim2.new(1, -65, 0, 5)
            DeleteButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
            DeleteButton.Text = "Eliminar"
            DeleteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            DeleteButton.TextSize = 12
            DeleteButton.Parent = UserFrame
            
            ModifyButton.MouseButton1Click:Connect(function()
                UsernameInput.Text = username
                DurationInput.Text = tostring(math.floor(self:GetRemainingTime(username) / 3600))
            end)
            
            DeleteButton.MouseButton1Click:Connect(function()
                self:RemoveAccess(username)
            end)
        end
        
        -- Ajustar el tamaño del contenedor
        UserListContainer.CanvasSize = UDim2.new(0, 0, 0, UserListLayout.AbsoluteContentSize.Y)
    end
    
    AddButton.MouseButton1Click:Connect(function()
        local username = UsernameInput.Text
        local duration = tonumber(DurationInput.Text)
        if username ~= "" and duration and duration > 0 then
            AccessSystem:SetAccess(username, duration)
            UsernameInput.Text = ""
            DurationInput.Text = ""
            -- Mostrar mensaje de confirmación
            local ConfirmationLabel = Instance.new("TextLabel")
            ConfirmationLabel.Size = UDim2.new(1, -20, 0, 30)
            ConfirmationLabel.Position = UDim2.new(0, 10, 0, 340)
            ConfirmationLabel.BackgroundTransparency = 1
            ConfirmationLabel.Font = Enum.Font.GothamBold
            ConfirmationLabel.Text = "Acceso agregado/modificado para " .. username
            ConfirmationLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            ConfirmationLabel.TextSize = 14
            ConfirmationLabel.Parent = AccessSection
            game.Debris:AddItem(ConfirmationLabel, 3)  -- El mensaje desaparecerá después de 3 segundos
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
        AccessTimeLabel.Text = "Tiempo restante: " .. FormatTime(remainingTime)
        AccessTimeFrame.Visible = true
    else
        AccessTimeFrame.Visible = false
    end
end

-- Actualizar el tiempo de acceso cada segundo
spawn(function()
    while wait(1) do
        UpdateAccessTimeDisplay()
        if LocalPlayer.Name == AccessSystem.AdminUser then
            AccessSystem:UpdateAccessDisplay()
        end
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

