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
            Movement = "Movement",
            Combat = "Combat",
            Visuals = "Visuals",
            Player = "Player",
            World = "World",
            Misc = "Misc",
            Settings = "Settings"
        },
        features = {
            Fly = "Fly",
            Speed = "Speed",
            SuperJump = "Super Jump",
            InfiniteJump = "Infinite Jump",
            NoClip = "No Clip",
            GodMode = "God Mode",
            KillAura = "Kill Aura",
            AutoParry = "Auto Parry",
            Reach = "Reach",
            ESP = "ESP",
            Chams = "Chams",
            Tracers = "Tracers",
            Fullbright = "Fullbright",
            Invisibility = "Invisibility",
            AntiAFK = "Anti AFK",
            AutoReset = "Auto Reset",
            RemoveFog = "Remove Fog",
            DayNight = "Day/Night",
            RemoveTextures = "Remove Textures",
            ChatSpam = "Chat Spam",
            AutoFarm = "Auto Farm",
            ServerHop = "Server Hop",
            Language = "Language"
        },
        loading = "Loading..."
    },
    ["Español"] = {
        categories = {
            Movement = "Movimiento",
            Combat = "Combate",
            Visuals = "Visuales",
            Player = "Jugador",
            World = "Mundo",
            Misc = "Misc",
            Settings = "Ajustes"
        },
        features = {
            Fly = "Volar",
            Speed = "Velocidad",
            SuperJump = "Super Salto",
            InfiniteJump = "Salto Infinito",
            NoClip = "No Clip",
            GodMode = "Modo Dios",
            KillAura = "Aura Asesina",
            AutoParry = "Auto Parry",
            Reach = "Alcance",
            ESP = "ESP",
            Chams = "Chams",
            Tracers = "Trazadores",
            Fullbright = "Brillo Total",
            Invisibility = "Invisibilidad",
            AntiAFK = "Anti AFK",
            AutoReset = "Auto Reset",
            RemoveFog = "Quitar Niebla",
            DayNight = "Día/Noche",
            RemoveTextures = "Quitar Texturas",
            ChatSpam = "Spam Chat",
            AutoFarm = "Auto Farm",
            ServerHop = "Cambiar Servidor",
            Language = "Idioma"
        },
        loading = "Cargando..."
    }
}

local CurrentLanguage = "English"
local Texts = Languages[CurrentLanguage]

-- Crear pantalla de carga
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "LoadingGui"
LoadingGui.Parent = game.CoreGui

local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
LoadingFrame.Parent = LoadingGui

local LoadingBar = Instance.new("Frame")
LoadingBar.Size = UDim2.new(0.4, 0, 0.02, 0)
LoadingBar.Position = UDim2.new(0.3, 0, 0.5, 0)
LoadingBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
LoadingBar.BorderSizePixel = 0
LoadingBar.Parent = LoadingFrame

local LoadingFill = Instance.new("Frame")
LoadingFill.Size = UDim2.new(0, 0, 1, 0)
LoadingFill.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
LoadingFill.BorderSizePixel = 0
LoadingFill.Parent = LoadingBar

local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(0, 200, 0, 30)
LoadingText.Position = UDim2.new(0.5, -100, 0.45, -15)
LoadingText.BackgroundTransparency = 1
LoadingText.Font = Enum.Font.GothamBold
LoadingText.Text = Texts.loading
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.TextSize = 18
LoadingText.Parent = LoadingFrame

-- Animación de carga
TweenService:Create(LoadingFill, TweenInfo.new(3), {Size = UDim2.new(1, 0, 1, 0)}):Play()
wait(3)

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EnhancedGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Botón para mostrar/ocultar
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
ToggleButton.Image = "rbxassetid://3926305904"
ToggleButton.ImageRectOffset = Vector2.new(764, 244)
ToggleButton.ImageRectSize = Vector2.new(36, 36)
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

-- Frame Principal con borde morado
local MainBorder = Instance.new("Frame")
MainBorder.Name = "MainBorder"
MainBorder.Size = UDim2.new(0, 610, 0, 410)
MainBorder.Position = UDim2.new(0.5, -305, 0.5, -205)
MainBorder.BackgroundColor3 = Color3.fromRGB(157, 122, 229) -- Morado más claro
MainBorder.BorderSizePixel = 0
MainBorder.Visible = false
MainBorder.Parent = ScreenGui

local MainBorderCorner = Instance.new("UICorner")
MainBorderCorner.CornerRadius = UDim.new(0, 12)
MainBorderCorner.Parent = MainBorder

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(1, -4, 1, -4)
MainFrame.Position = UDim2.new(0, 2, 0, 2)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.1 -- Ligera transparencia
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainBorder

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Sidebar.BackgroundTransparency = 0.1 -- Ligera transparencia
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Contenedor principal
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -150, 1, 0)
ContentFrame.Position = UDim2.new(0, 150, 0, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ContentFrame.BackgroundTransparency = 0.1 -- Ligera transparencia
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Función para crear categorías en el sidebar
local function CreateCategory(name, icon, position)
    local CategoryButton = Instance.new("TextButton")
    CategoryButton.Name = name.."Category"
    CategoryButton.Size = UDim2.new(1, -20, 0, 40)
    CategoryButton.Position = UDim2.new(0, 10, 0, position + 20) -- Movido 20 píxeles más abajo
    CategoryButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    CategoryButton.BorderSizePixel = 0
    CategoryButton.Font = Enum.Font.GothamSemibold
    CategoryButton.TextSize = 14
    CategoryButton.Parent = Sidebar
    
    local IconImage = Instance.new("ImageLabel")
    IconImage.Size = UDim2.new(0, 20, 0, 20)
    IconImage.Position = UDim2.new(0, 10, 0.5, -10)
    IconImage.BackgroundTransparency = 1
    IconImage.Image = icon
    IconImage.Parent = CategoryButton
    
    CategoryButton.Text = Texts.categories[name]
    CategoryButton.TextXAlignment = Enum.TextXAlignment.Left
    CategoryButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryButton.AutoButtonColor = false
    
    local TextPadding = Instance.new("UIPadding")
    TextPadding.PaddingLeft = UDim.new(0, 40)
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
    Section.ScrollBarThickness = 4
    Section.ScrollBarImageColor3 = Color3.fromRGB(147, 112, 219)
    Section.Visible = false
    Section.Parent = ContentFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = Section
    
    return Section
end

-- Función para crear botones de toggle
local function CreateToggle(name, section, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleFrame.Parent = section
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = Texts.features[name]
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 40, 0, 20)
    Switch.Position = UDim2.new(1, -50, 0.5, -10)
    Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Switch.BorderSizePixel = 0
    Switch.Text = ""
    Switch.Parent = ToggleFrame
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = Switch
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    local Enabled = false
    
    local function Toggle()
        Enabled = not Enabled
        local Goal = {
            BackgroundColor3 = Enabled and Color3.fromRGB(147, 112, 219) or Color3.fromRGB(60, 60, 60),
            Position = Enabled and UDim2.new(0, 22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = Goal.Position}):Play()
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Goal.BackgroundColor3}):Play()
        callback(Enabled)
    end
    
    Switch.MouseButton1Click:Connect(Toggle)
    
    return Toggle
end

-- Funciones de habilidades mejoradas
local function ToggleFly(enabled)
    if enabled then
        local BG = Instance.new("BodyGyro", HumanoidRootPart)
        BG.P = 9e4
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.CFrame = HumanoidRootPart.CFrame
        
        local BV = Instance.new("BodyVelocity", HumanoidRootPart)
        BV.Velocity = Vector3.new(0, 0.1, 0)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        -- Conexión para el vuelo
        RunService:BindToRenderStep("Fly", 100, function()
            if not enabled then return end
            
            BG.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + Camera.CFrame.LookVector)
            
            local moveDirection = Vector3.new(
                UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0),
                (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 1 or 0),
                UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0)
            )
            
            local cameraCFrame = Camera.CFrame
            local lookVector = cameraCFrame.LookVector
            local rightVector = cameraCFrame.RightVector
            
            -- Calcular la velocidad basada en la dirección de la cámara
            local velocity = (rightVector * moveDirection.X + cameraCFrame.UpVector * moveDirection.Y + lookVector * moveDirection.Z) * 50
            
            if velocity.Magnitude > 0 then
                BV.Velocity = velocity
            else
                BV.Velocity = Vector3.new(0, 0.1, 0)
            end
        end)
    else
        RunService:UnbindFromRenderStep("Fly")
        for _, v in pairs(HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then
                v:Destroy()
            end
        end
    end
end

local function ToggleSpeed(enabled)
    if enabled then
        Humanoid.WalkSpeed = 50
    else
        Humanoid.WalkSpeed = 16
    end
end

local function ToggleSuperJump(enabled)
    if enabled then
        Humanoid.JumpPower = 100
        Humanoid.JumpHeight = 7.2
    else
        Humanoid.JumpPower = 50
        Humanoid.JumpHeight = 7.2
    end
end

local function Invisibility(enabled)
    if enabled then
        local clone = Character:Clone()
        clone.Parent = workspace
        
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("Part") then
                part.Transparency = 1
            end
        end
        
        Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    else
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("Part") then
                part.Transparency = 0
            end
        end
        
        Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        
        local clone = workspace:FindFirstChild(Character.Name)
        if clone then clone:Destroy() end
    end
end

local function GodMode(enabled)
    if enabled then
        local clone = Character:Clone()
        clone.Parent = workspace
        Character.Parent = game.ReplicatedStorage
        
        local function onDied()
            Character.Parent = workspace
            local clone = workspace:FindFirstChild(Character.Name)
            if clone then clone:Destroy() end
        end
        
        clone.Humanoid.Died:Connect(onDied)
    end
end

local function InfiniteJump(enabled)
    UserInputService.JumpRequest:Connect(function()
        if enabled then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function NoClip(enabled)
    RunService.Stepped:Connect(function()
        if enabled then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function ESP(enabled)
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.FillColor = Color3.fromRGB(147, 112, 219)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
        
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(character)
                local highlight = Instance.new("Highlight")
                highlight.Parent = character
                highlight.FillColor = Color3.fromRGB(147, 112, 219)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            end)
        end)
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChild("Highlight")
                if highlight then highlight:Destroy() end
            end
        end
    end
end

local function Fullbright(enabled)
    if enabled then
        game.Lighting.Brightness = 2
        game.Lighting.ClockTime = 14
        game.Lighting.FogEnd = 100000
        game.Lighting.GlobalShadows = false
        game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        game.Lighting.Brightness = 1
        game.Lighting.ClockTime = 12
        game.Lighting.FogEnd = 10000
        game.Lighting.GlobalShadows = true
        game.Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    end
end

local function Tracers(enabled)
    local function createTracer(player)
        local tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Color = Color3.new(1, 1, 1)
        tracer.Thickness = 1
        tracer.Transparency = 1
        
        RunService.RenderStepped:Connect(function()
            if enabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local vector, onScreen = Camera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    tracer.To = Vector2.new(vector.X, vector.Y)
                    tracer.Visible = true
                else
                    tracer.Visible = false
                end
            else
                tracer.Visible = false
            end
        end)
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createTracer(player)
        end
    end
    
    Players.PlayerAdded:Connect(createTracer)
end

local function RemoveFog(enabled)
    if enabled then
        game.Lighting.FogStart = 100000
        game.Lighting.FogEnd = 100000
    else
        game.Lighting.FogStart = 0
        game.Lighting.FogEnd = 100000
    end
end

local function DayNight(enabled)
    local dayNightLoop = nil
    if enabled then
        dayNightLoop = RunService.Heartbeat:Connect(function()
            local currentTime = tick() % 24
            game.Lighting.ClockTime = currentTime
        end)
    else
        if dayNightLoop then
            dayNightLoop:Disconnect()
        end
        game.Lighting.ClockTime = 12
    end
end

local function RemoveTextures(enabled)
    local originalMaterials = {}
    if enabled then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Material ~= Enum.Material.Air then
                originalMaterials[v] = v.Material
                v.Material = Enum.Material.SmoothPlastic
            end
        end
    else
        for part, material in pairs(originalMaterials) do
            if part then
                part.Material = material
            end
        end
        originalMaterials = {}
    end
end

local function ChatSpam(enabled)
    local spamLoop = nil
    if enabled then
        spamLoop = RunService.Heartbeat:Connect(function()
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Spam message", "All")
            wait(1)
        end)
    else
        if spamLoop then
            spamLoop:Disconnect()
        end
    end
end

local function AutoFarm(enabled)
    if enabled then
        print("Auto Farm enabled. Implement game-specific farming logic here.")
    else
        print("Auto Farm disabled.")
    end
end

local function ServerHop()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local PlaceId = game.PlaceId
    
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, server in pairs(servers.data) do
        if server.playing < server.maxPlayers then
            TeleportService:TeleportToPlaceInstance(PlaceId, server.id)
            break
        end
    end
end

-- Categorías actualizadas
local Categories = {
    {name = "Movement", icon = "rbxassetid://3926307971"},
    {name = "Combat", icon = "rbxassetid://3926307971"},
    {name = "Visuals", icon = "rbxassetid://3926307971"},
    {name = "Player", icon = "rbxassetid://3926307971"},
    {name = "World", icon = "rbxassetid://3926307971"},
    {name = "Misc", icon = "rbxassetid://3926307971"},
    {name = "Settings", icon = "rbxassetid://3926307971"}
}

-- Crear categorías y secciones
local Sections = {}
for i, category in ipairs(Categories) do
    local button = CreateCategory(category.name, category.icon, (i-1) * 50)
    Sections[category.name] = CreateSection(category.name)
    
    -- Añadir animación al botón
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
    end)
end

-- Características actualizadas
local MovementFeatures = {
    {name = "Fly", callback = ToggleFly},
    {name = "Speed", callback = ToggleSpeed},
    {name = "SuperJump", callback = ToggleSuperJump},
    {name = "InfiniteJump", callback = InfiniteJump},
    {name = "NoClip", callback = NoClip}
}

local CombatFeatures = {
    {name = "GodMode", callback = GodMode},
    {name = "KillAura", callback = function() end},
    {name = "AutoParry", callback = function() end},
    {name = "Reach", callback = function() end}
}

local VisualFeatures = {
    {name = "ESP", callback = ESP},
    {name = "Chams", callback = function() end},
    {name = "Tracers", callback = Tracers},
    {name = "Fullbright", callback = Fullbright}
}

local PlayerFeatures = {
    {name = "Invisibility", callback = Invisibility},
    {name = "AntiAFK", callback = function() end},
    {name = "AutoReset", callback = function() end}
}

local WorldFeatures = {
    {name = "RemoveFog", callback = RemoveFog},
    {name = "DayNight", callback = DayNight},
    {name = "RemoveTextures", callback = RemoveTextures}
}

local MiscFeatures = {
    {name = "ChatSpam", callback = ChatSpam},
    {name = "AutoFarm", callback = AutoFarm},
    {name = "ServerHop", callback = ServerHop}
}

-- Configuración de idioma
local SettingsFeatures = {
    {name = "Language", callback = function(enabled)
        if enabled then
            CurrentLanguage = "Español"
        else
            CurrentLanguage = "English"
        end
        Texts = Languages[CurrentLanguage]
        
        -- Actualizar textos
        for name, section in pairs(Sections) do
            local categoryButton = Sidebar:FindFirstChild(name.."Category")
            if categoryButton then
                categoryButton.Text = Texts.categories[name]
            end
            
            for _, child in pairs(section:GetChildren()) do
                if child:IsA("Frame") then
                    local label = child:FindFirstChild("TextLabel")
                    if label and label.Text then
                        for featureName, translatedName in pairs(Texts.features) do
                            if label.Text == Languages[CurrentLanguage == "English" and "Español" or "English"].features[featureName] then
                                label.Text = translatedName
                                break
                            end
                        end
                    end
                end
            end
        end
    end}
}

-- Crear toggles para cada característica
for _, feature in ipairs(MovementFeatures) do
    CreateToggle(feature.name, Sections.Movement, feature.callback)
end

for _, feature in ipairs(CombatFeatures) do
    CreateToggle(feature.name, Sections.Combat, feature.callback)
end

for _, feature in ipairs(VisualFeatures) do
    CreateToggle(feature.name, Sections.Visuals, feature.callback)
end

for _, feature in ipairs(PlayerFeatures) do
    CreateToggle(feature.name, Sections.Player, feature.callback)
end

for _, feature in ipairs(WorldFeatures) do
    CreateToggle(feature.name, Sections.World, feature.callback)
end

for _, feature in ipairs(MiscFeatures) do
    CreateToggle(feature.name, Sections.Misc, feature.callback)
end

for _, feature in ipairs(SettingsFeatures) do
    CreateToggle(feature.name, Sections.Settings, feature.callback)
end

-- Manejar la visibilidad de las secciones
local function ShowSection(sectionName)
    for name, section in pairs(Sections) do
        section.Visible = (name == sectionName)
        local button = Sidebar:FindFirstChild(name.."Category")
        if button then
            button.BackgroundColor3 = (name == sectionName) and Color3.fromRGB(147, 112, 219) or Color3.fromRGB(45, 45, 45)
        end
    end
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
        Size = MainBorder.Visible and UDim2.new(0, 610, 0, 410) or UDim2.new(0, 0, 0, 0)
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

-- Eliminar la GUI de carga
LoadingGui:Destroy()

-- Mostrar la primera sección por defecto
ShowSection("Movement")

-- Mensaje de confirmación
print("Script mejorado cargado correctamente. Use el botón en la izquierda para mostrar/ocultar el menú.")
