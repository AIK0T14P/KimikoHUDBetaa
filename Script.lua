-- Servicios
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local DataStoreService = DataStoreService:GetDataStore("AccessSystem")

-- Variables principales
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- Debugging
local function DebugPrint(message)
    print("[DEBUG] " .. message)
end

DebugPrint("Script iniciado")

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
local function FormatTime(seconds)
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%dd %02dh %02dm %02ds", days, hours, minutes, secs)
end

-- Cargar datos de acceso al inicio
AccessSystem:LoadData()

DebugPrint("Datos de acceso cargados")

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EnhancedGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

DebugPrint("ScreenGui creado")

-- Botón para mostrar/ocultar
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 50)
ToggleButton.Position = UDim2.new(1, -110, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
ToggleButton.Text = "Mostrar Menu"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

DebugPrint("Botón de toggle creado")

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

DebugPrint("MainFrame creado")

-- Título "Kimiko HUD Beta"
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "Kimiko HUD Beta"
Title.TextColor3 = Color3.fromRGB(147, 112, 219)
Title.TextSize = 24
Title.Parent = MainFrame

DebugPrint("Título creado")

-- Función para mostrar/ocultar el menú
local function ToggleMenu()
    MainFrame.Visible = not MainFrame.Visible
    ToggleButton.Text = MainFrame.Visible and "Ocultar Menu" or "Mostrar Menu"
    DebugPrint("Menu toggled. Visibility: " .. tostring(MainFrame.Visible))
end

ToggleButton.MouseButton1Click:Connect(ToggleMenu)

-- Mensaje de confirmación
DebugPrint("Script cargado correctamente. Use el botón en la esquina superior derecha para mostrar/ocultar el menú.")

-- Función para verificar si el script se está ejecutando
local function CheckExecution()
    if ScreenGui.Parent then
        DebugPrint("El script se está ejecutando correctamente.")
    else
        DebugPrint("El ScreenGui no está presente en el PlayerGui. El script puede no estar ejecutándose correctamente.")
    end
end

-- Verificar la ejecución después de un breve retraso
wait(1)
CheckExecution()
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

DebugPrint("Sección de acceso creada")

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
DebugPrint("Script cargado correctamente. Use el botón en la esquina superior derecha para mostrar/ocultar el menú.")

