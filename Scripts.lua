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

-- New variables for respawn and position management
local RespawnPoint = nil
local SavedPositions = {}

-- Sistema de idiomas
local Languages = {
    ["English"] = {
        categories = {
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
            Language = "Language",
            LowGraphics = "Low Graphics",
            DisableEffects = "Disable Effects",
            ReduceTextures = "Reduce Textures",
            DisableLighting = "Disable Lighting",
            SaveRespawn = "Save Respawn",
            DeleteRespawn = "Delete Respawn",
            SavePosition = "Save Position",
            TeleportToPosition = "Teleport to Position",
            Jump = "Jump",
            Dash = "Dash",
            Crouch = "Crouch",
            WallClimb = "Wall Climb",
            AirJump = "Air Jump",
            Glide = "Glide",
            Teleport = "Teleport",
            DoubleJump = "Double Jump",
            WallRun = "Wall Run",
            Blink = "Blink",
            Grapple = "Grapple",
            Slide = "Slide",
            LongJump = "Long Jump",
            HighJump = "High Jump",
            SpeedBurst = "Speed Burst",
            Levitate = "Levitate",
            AirDash = "Air Dash",
            Stomp = "Stomp",
            WaterWalk = "Water Walk",
            PhaseThrough = "Phase Through",
            Moonwalk = "Moonwalk",
            Backflip = "Backflip",
            FrontFlip = "Front Flip",
            Barrel Roll = "Barrel Roll",
            Hover = "Hover",
            WallJump = "Wall Jump",
            AirStall = "Air Stall",
            GroundPound = "Ground Pound",
            SpiderClimb = "Spider Climb",
            Telekinesis = "Telekinesis"
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
            Optimization = "Optimización",
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
            Language = "Idioma",
            LowGraphics = "Gráficos Bajos",
            DisableEffects = "Desactivar Efectos",
            ReduceTextures = "Reducir Texturas",
            DisableLighting = "Desactivar Iluminación",
            SaveRespawn = "Guardar Punto de Respawn",
            DeleteRespawn = "Eliminar Punto de Respawn",
            SavePosition = "Guardar Posición",
            TeleportToPosition = "Teletransportar a Posición",
            Jump = "Salto",
            Dash = "Deslizamiento",
            Crouch = "Agacharse",
            WallClimb = "Escalar Paredes",
            AirJump = "Salto en Aire",
            Glide = "Planeo",
            Teleport = "Teletransporte",
            DoubleJump = "Doble Salto",
            WallRun = "Carrera en Pared",
            Blink = "Parpadeo",
            Grapple = "Gancho",
            Slide = "Deslizarse",
            LongJump = "Salto Largo",
            HighJump = "Salto Alto",
            SpeedBurst = "Ráfaga de Velocidad",
            Levitate = "Levitar",
            AirDash = "Dash Aéreo",
            Stomp = "Pisotón",
            WaterWalk = "Caminar sobre el Agua",
            PhaseThrough = "Atravesar",
            Moonwalk = "Paso Lunar",
            Backflip = "Voltereta Atrás",
            FrontFlip = "Voltereta Adelante",
            Barrel Roll = "Giro de Barril",
            Hover = "Flotar",
            WallJump = "Salto en Pared",
            AirStall = "Parada en Aire",
            GroundPound = "Golpe al Suelo",
            SpiderClimb = "Trepar como Araña",
            Telekinesis = "Telequinesis"
        },
        loading = "Cargando..."
    }
}

local CurrentLanguage = "English"
local Texts = Languages[CurrentLanguage]

-- Crear pantalla de carga
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "LoadingGui"
LoadingGui.ResetOnSpawn = false
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
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
local loadingTween = TweenService:Create(LoadingFill, TweenInfo.new(3), {Size = UDim2.new(1, 0, 1, 0)})
loadingTween:Play()
loadingTween.Completed:Wait()

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EnhancedGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
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

-- Frame Principal con borde morado y gradiente
local MainBorder = Instance.new("Frame")
MainBorder.Name = "MainBorder"
MainBorder.Size = UDim2.new(0, 610, 0, 410)
MainBorder.Position = UDim2.new(0.5, -305, 0.5, -205)
MainBorder.BackgroundColor3 = Color3.fromRGB(157, 122, 229)
MainBorder.BorderSizePixel = 0
MainBorder.Visible = false
MainBorder.Parent = ScreenGui

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

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

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

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Sidebar.BackgroundTransparency = 0.1
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Contenedor principal
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -150, 1, -50)
ContentFrame.Position = UDim2.new(0, 150, 0, 50)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ContentFrame.BackgroundTransparency = 0.1
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Función para crear categorías en el sidebar
local function CreateCategory(name, icon, position)
    local CategoryButton = Instance.new("TextButton")
    CategoryButton.Name = name.."Category"
    CategoryButton.Size = UDim2.new(1, -20, 0, 40)
    CategoryButton.Position = UDim2.new(0, 10, 0, position + 20)
    CategoryButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    CategoryButton.BorderSizePixel = 0
    CategoryButton.Font = Enum.Font.GothamSemibold
    CategoryButton.TextSize = 14
    CategoryButton.Parent = Sidebar
    
    local IconImage = Instance.new("ImageLabel")
    IconImage.Size = UDim2.new(0, 20, 0, 20)
    IconImage.Position = UDim2.new(0, 2, 0.5, -10)
    IconImage.BackgroundTransparency = 1
    IconImage.Image = icon
    IconImage.Parent = CategoryButton
    
    CategoryButton.Text = Texts.categories[name]
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

-- Función para crear sliders
local function CreateSlider(name, section, callback, min, max, default)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderFrame.Parent = section
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = Texts.features[name] .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local SliderBar = Instance.new("TextButton")
    SliderBar.Name = "SliderBar"
    SliderBar.Size = UDim2.new(1, -20, 0, 20)
    SliderBar.Position = UDim2.new(0, 10, 0, 30)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBar.BorderSizePixel = 0
    SliderBar.AutoButtonColor = false
    SliderBar.Text = ""
    SliderBar.Parent = SliderFrame
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1, 0)
    SliderCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local Value = default
    local Dragging = false
    
    local function UpdateSlider(input)
        local sizeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        Value = math.floor(min + ((max - min) * sizeX))
        SliderFill.Size = UDim2.new(sizeX, 0, 1, 0)
        Label.Text = Texts.features[name] .. ": " .. Value
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

local function ToggleSpeed(value)
    Humanoid.WalkSpeed = value
end

local function ToggleSuperJump(value)
    Humanoid.JumpPower = value
    Humanoid.JumpHeight = 7.2
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
    local connection
    if enabled then
        connection = UserInputService.JumpRequest:Connect(function()
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function NoClip(enabled)
    local connection
    if enabled then
        connection = RunService.Stepped:Connect(function()
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function ESP(enabled)
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.Parent = player.Character
                highlight.FillColor = Color3.fromRGB(147, 112, 219)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
        
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(character)
                if enabled then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESPHighlight"
                    highlight.Parent = character
                    highlight.FillColor = Color3.fromRGB(147, 112, 219)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            end)
        end)
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChild("ESPHighlight")
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
    local tracers = {}
    
    local function createTracer(player)
        if player == LocalPlayer then return end
        
        local tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Color = Color3.new(1, 1, 1)
        tracer.Thickness = 1
        tracer.Transparency = 1
        tracers[player] = tracer
        
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not enabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                tracer.Visible = false
                return
            end
            
            local vector, onScreen = Camera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                tracer.To = Vector2.new(vector.X, vector.Y)
                tracer.Visible = true
            else
                tracer.Visible = false
            end
        end)
    end
    
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            createTracer(player)
        end
        
        Players.PlayerAdded:Connect(createTracer)
        Players.PlayerRemoving:Connect(function(player)
            if tracers[player] then
                tracers[player]:Remove()
                tracers[player] = nil
            end
        end)
    else
        for _, tracer in pairs(tracers) do
            tracer:Remove()
        end
        tracers = {}
    end
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
    local connection
    if enabled then
        connection = RunService.Heartbeat:Connect(function()
            local currentTime = tick() % 24
            game.Lighting.ClockTime = currentTime
        end)
    else
        if connection then
            connection:Disconnect()
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
    local connection
    if enabled then
        connection = RunService.Heartbeat:Connect(function()
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Spam message", "All")
            wait(1)
        end)
    else
        if connection then
            connection:Disconnect()
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

-- New functions for respawn and position management
local function SaveRespawnPoint()
    RespawnPoint = Character.HumanoidRootPart.Position
    print("Respawn point saved!")
end

local function DeleteRespawnPoint()
    RespawnPoint = nil
    print("Respawn point deleted!")
end

local function SavePosition(name)
    SavedPositions[name] = Character.HumanoidRootPart.Position
    print("Position '" .. name .. "' saved!")
end

local function TeleportToPosition(name)
    if SavedPositions[name] then
        Character.HumanoidRootPart.CFrame = CFrame.new(SavedPositions[name])
        print("Teleported to '" .. name .. "'!")
    else
        print("Position '" .. name .. "' not found!")
    end
end

-- New movement functions
local function Jump(enabled)
    if enabled then
        Humanoid.Jump = true
    end
end

local function Dash(enabled)
    if enabled then
        local direction = HumanoidRootPart.CFrame.LookVector
        HumanoidRootPart.Velocity = direction * 100
    end
end

local function Crouch(enabled)
    if enabled then
        Humanoid.CameraOffset = Vector3.new(0, -1, 0)
    else
        Humanoid.CameraOffset = Vector3.new(0, 0, 0)
    end
end

local function WallClimb(enabled)
    local connection
    if enabled then
        connection = RunService.Stepped:Connect(function()
            local ray = Ray.new(HumanoidRootPart.Position, HumanoidRootPart.CFrame.LookVector * 1)
            local hit, _ = workspace:FindPartOnRay(ray, Character)
            if hit and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                Humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function AirJump(enabled)
    local connection
    if enabled then
        connection = UserInputService.JumpRequest:Connect(function()
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function Glide(enabled)
    local connection
    if enabled then
        connection = RunService.Stepped:Connect(function()
            if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, -2, HumanoidRootPart.Velocity.Z)
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function Teleport()
    local mouse = LocalPlayer:GetMouse()
    local target = mouse.Hit.p
    HumanoidRootPart.CFrame = CFrame.new(target)
end

local function DoubleJump(enabled)
    local doubleJumpCount = 0
    local connection
    if enabled then
        connection = UserInputService.JumpRequest:Connect(function()
            if doubleJumpCount < 1 then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                doubleJumpCount = doubleJumpCount + 1
            end
        end)
        Humanoid.StateChanged:Connect(function(oldState, newState)
            if newState == Enum.HumanoidStateType.Landed then
                doubleJumpCount = 0
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function WallRun(enabled)
    local connection
    if enabled then
        connection = RunService.Stepped:Connect(function()
            local ray = Ray.new(HumanoidRootPart.Position, HumanoidRootPart.CFrame.RightVector * 1)
            local hit, _ = workspace:FindPartOnRay(ray, Character)
            if hit and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                Humanoid:Move(Vector3.new(0, 1, 0))
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function Blink(enabled)
    if enabled then
        local mouse = LocalPlayer:GetMouse()
        mouse.KeyDown:Connect(function(key)
            if key == "e" then
                local target = mouse.Hit.p
                HumanoidRootPart.CFrame = CFrame.new(target)
            end
        end)
    end
end

local function Grapple(enabled)
    if enabled then
        local mouse = LocalPlayer:GetMouse()
        mouse.Button1Down:Connect(function()
            local target = mouse.Hit.p
            local grappleBeam = Instance.new("Beam")
            grappleBeam.Attachment0 = Instance.new("Attachment", HumanoidRootPart)
            grappleBeam.Attachment1 = Instance.new("Attachment", workspace.Terrain)
            grappleBeam.Attachment1.WorldPosition = target
            grappleBeam.Width0 = 0.5
            grappleBeam.Width1 = 0.5
            grappleBeam.Parent = HumanoidRootPart
            
            local bodyVelocity = Instance.new("BodyVelocity", HumanoidRootPart)
            bodyVelocity.Velocity = (target - HumanoidRootPart.Position).Unit * 50
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            
            wait(1)
            grappleBeam:Destroy()
            bodyVelocity:Destroy()
        end)
    end
end

local function Slide(enabled)
    if enabled then
        local mouse = LocalPlayer:GetMouse()
        mouse.KeyDown:Connect(function(key)
            if key == "c" and Humanoid:GetState() == Enum.HumanoidStateType.Running then
                Humanoid.PlatformStand = true
                HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + HumanoidRootPart.Velocity.Unit)
                HumanoidRootPart.Velocity = HumanoidRootPart.Velocity * 1.5
                wait(1)
                Humanoid.PlatformStand = false
            end
        end)
    end
end

local function LongJump(enabled)
    if enabled then
        local mouse = LocalPlayer:GetMouse()
        mouse.KeyDown:Connect(function(key)
            if key == "x" and Humanoid:GetState() == Enum.HumanoidStateType.Running then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                HumanoidRootPart.Velocity = HumanoidRootPart.Velocity * Vector3.new(2, 1, 2)
            end
        end)
    end
end

local function HighJump(enabled)
    if enabled then
        local mouse = LocalPlayer:GetMouse()
        mouse.KeyDown:Connect(function(key)
            if key == "h" then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                HumanoidRootPart.Velocity = Vector3.new(0, 100, 0)
            end
        end)
    end
end

local function SpeedBurst(enabled)
    if enabled then
        local mouse = LocalPlayer:GetMouse()
        mouse.KeyDown:Connect(function(key)
            if key == "v" then
                local originalSpeed = Humanoid.WalkSpeed
                Humanoid.WalkSpeed = originalSpeed * 3
                wait(1)
                Humanoid.WalkSpeed = originalSpeed
            end
        end)
    end
end

local function Levitate(enabled)
    local connection
    if enabled then
        connection = RunService.Heartbeat:Connect(function()
            HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, 5, HumanoidRootPart.Velocity.Z)
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function AirDash(enabled)
    if enabled then
        local mouse = LocalPlayer:GetMouse()
        mouse.KeyDown:Connect(function(key)
            if key == "q" and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                local lookVector = HumanoidRootPart.CFrame.LookVector
                HumanoidRootPart.Velocity = lookVector * 100
            end
        end)
    end
end

local function Stomp(enabled)
    if enabled then
        local mouse = LocalPlayer:GetMouse()
        mouse.KeyDown:Connect(function(key)
            if key == "f" and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                HumanoidRootPart.Velocity = Vector3.new(0, -100, 0)
            end
        end)
    end
end

local function WaterWalk(enabled)
    local connection
    if enabled then
        connection = RunService.Stepped:Connect(function()
            local ray = Ray.new(HumanoidRootPart.Position, Vector3.new(0, -3.5, 0))
            local hit, position = workspace:FindPartOnRay(ray, Character)
            if hit and hit.Material == Enum.Material.Water then
                HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position.X, position.Y + 3.5, HumanoidRootPart.Position.Z)
                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function PhaseThrough(enabled)
    if enabled then
        local mouse = LocalPlayer:GetMouse()
        mouse.KeyDown:Connect(function(key)
            if key == "r" then
                NoClip(true)
                wait(1)
                NoClip(false)
            end
        end)
    end
end

local function Moonwalk(enabled)
    local connection
    if enabled then
        connection = RunService.Heartbeat:Connect(function()
            if Humanoid.MoveDirection.Magnitude > 0 then
                HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position - Humanoid.MoveDirection)
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function Backflip(enabled)
    if enabled then
        local mouse = LocalPlayer:GetMouse()
        mouse.KeyDown:Connect(function(key)
            if key == "b" and Humanoid:GetState() == Enum.HumanoidStateType.Running then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                HumanoidRootPart.Velocity = Vector3.new(0, 50, -20)
                for i = 1, 360, 10 do
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(math.rad(10), 0, 0)
                    RunService.Heartbeat:Wait()
                end
            end
        end)
    end
end

local function FrontFlip(enabled)
    if enabled then
        local mouse = LocalPlayer:GetMouse()
        mouse.KeyDown:Connect(function(key)
            if key == "n" and Humanoid:GetState() == Enum.HumanoidStateType.Running then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                HumanoidRootPart.Velocity = Vector3.new(0, 50, 20)
                for i = 1, 360, 10 do
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(math.rad(-10), 0, 0)
                    RunService.Heartbeat:Wait()
                end
            end
        end)
    end
end

local function BarrelRoll(enabled)
    if enabled then
        local mouse = LocalPlayer:GetMouse()
        mouse.KeyDown:Connect(function(key)
            if key == "m" and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                for i = 1, 360, 10 do
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, 0, math.rad(10))
                    RunService.Heartbeat:Wait()
                end
            end
        end)
    end
end

local function Hover(enabled)
    local connection
    if enabled then
        connection = RunService.Heartbeat:Connect(function()
            if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, 0, HumanoidRootPart.Velocity.Z)
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function WallJump(enabled)
    if enabled then
        local lastJumpTime = 0
        local wallJumpCooldown = 1 -- seconds
        local connection = RunService.Stepped:Connect(function()
            local ray = Ray.new(HumanoidRootPart.Position, HumanoidRootPart.CFrame.LookVector * 2)
            local hit, _ = workspace:FindPartOnRay(ray, Character)
            if hit and Humanoid:GetState() == Enum.HumanoidStateType.Freefall and tick() - lastJumpTime > wallJumpCooldown then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, 50, HumanoidRootPart.Velocity.Z) - HumanoidRootPart.CFrame.LookVector * 20
                lastJumpTime = tick()
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function AirStall(enabled)
    if enabled then
        local mouse = LocalPlayer:GetMouse()
        mouse.KeyDown:Connect(function(key)
            if key == "j" and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                wait(0.5)
            end
        end)
    end
end

local function GroundPound(enabled)
    if enabled then
        local mouse = LocalPlayer:GetMouse()
        mouse.KeyDown:Connect(function(key)
            if key == "g" and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                HumanoidRootPart.Velocity = Vector3.new(0, -100, 0)
                local connection
                connection = RunService.Stepped:Connect(function()
                    if Humanoid:GetState() == Enum.HumanoidStateType.Landed then
                        local explosion = Instance.new("Explosion")
                        explosion.Position = HumanoidRootPart.Position
                        explosion.BlastPressure = 500
                        explosion.BlastRadius = 5
                        explosion.Parent = workspace
                        connection:Disconnect()
                    end
                end)
            end
        end)
    end
end

local function SpiderClimb(enabled)
    local connection
    if enabled then
        connection = RunService.Stepped:Connect(function()
            local ray = Ray.new(HumanoidRootPart.Position, HumanoidRootPart.CFrame.LookVector * 1)
            local hit, _ = workspace:FindPartOnRay(ray, Character)
            if hit then
                Humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
                HumanoidRootPart.Velocity = Vector3.new(0, 10, 0)
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function Telekinesis(enabled)
    if enabled then
        local mouse = LocalPlayer:GetMouse()
        local heldPart = nil
        mouse.Button1Down:Connect(function()
            local target = mouse.Target
            if target and target:IsA("BasePart") and not target:IsDescendantOf(Character) then
                heldPart = target
                local bodyPosition = Instance.new("BodyPosition")
                bodyPosition.Position = heldPart.Position
                bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyPosition.P = 1000
                bodyPosition.Parent = heldPart
            end
        end)
        mouse.Button1Up:Connect(function()
            if heldPart then
                heldPart.BodyPosition:Destroy()
                heldPart = nil
            end
        end)
        RunService.Stepped:Connect(function()
            if heldPart then
                local targetPos = HumanoidRootPart.Position + (HumanoidRootPart.CFrame.LookVector * 5) + Vector3.new(0, 2, 0)
                heldPart.BodyPosition.Position = targetPos
            end
        end)
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
    {name = "Settings", icon = "rbxassetid://3926307971"}
}

-- Crear categorías y secciones
local Sections = {}
local ActiveCategory = nil

for i, category in ipairs(Categories) do
    local button = CreateCategory(category.name, category.icon, (i-1) * 50)
    Sections[category.name] = CreateSection(category.name)
end

-- Características actualizadas
local MovementFeatures = {
    {name = "Fly", callback = ToggleFly},
    {name = "Speed", callback = ToggleSpeed, slider = true, min = 16, max = 200, default = 16},
    {name = "SuperJump", callback = ToggleSuperJump, slider = true, min = 50, max = 500, default = 50},
    {name = "InfiniteJump", callback = InfiniteJump},
    {name = "NoClip", callback = NoClip},
    {name = "Jump", callback = Jump},
    {name = "Dash", callback = Dash},
    {name = "Crouch", callback = Crouch},
    {name = "WallClimb", callback = WallClimb},
    {name = "AirJump", callback = AirJump},
    {name = "Glide", callback = Glide},
    {name = "Teleport", callback = Teleport},
    {name = "DoubleJump", callback = DoubleJump},
    {name = "WallRun", callback = WallRun},
    {name = "Blink", callback = Blink},
    {name = "Grapple", callback = Grapple},
    {name = "Slide", callback = Slide},
    {name = "LongJump", callback = LongJump},
    {name = "HighJump", callback = HighJump},
    {name = "SpeedBurst", callback = SpeedBurst},
    {name = "Levitate", callback = Levitate},
    {name = "AirDash", callback = AirDash},
    {name = "Stomp", callback = Stomp},
    {name = "WaterWalk", callback = WaterWalk},
    {name = "PhaseThrough", callback = PhaseThrough},
    {name = "Moonwalk", callback = Moonwalk},
    {name = "Backflip", callback = Backflip},
    {name = "FrontFlip", callback = FrontFlip},
    {name = "BarrelRoll", callback = BarrelRoll},
    {name = "Hover", callback = Hover},
    {name = "WallJump", callback = WallJump},
    {name = "AirStall", callback = AirStall},
    {name = "GroundPound", callback = GroundPound},
    {name = "SpiderClimb", callback = SpiderClimb},
    {name = "Telekinesis", callback = Telekinesis}
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
    {name = "AutoReset", callback = function() end},
    {name = "SaveRespawn", callback = SaveRespawnPoint},
    {name = "DeleteRespawn", callback = DeleteRespawnPoint},
    {name = "SavePosition", callback = function() 
        local name = "Position" .. tostring(#SavedPositions + 1)
        SavePosition(name)
    end},
    {name = "TeleportToPosition", callback = function()
        -- This should be replaced with a proper UI for selecting a saved position
        if #SavedPositions > 0 then
            TeleportToPosition(SavedPositions[1])
        else
            print("No saved positions!")
        end
    end}
}

local WorldFeatures = {
    {name = "RemoveFog", callback = RemoveFog},
    {name = "DayNight", callback = DayNight},
    {name = "RemoveTextures", callback = RemoveTextures}
}

local OptimizationFeatures = {
    {name = "LowGraphics", callback = function(enabled)
        if enabled then
            settings().Rendering.QualityLevel = 1
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").Technology = Enum.Technology.Compatibility
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                    v.Enabled = false
                end
            end
        else
            settings().Rendering.QualityLevel = 7
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").Technology = Enum.Technology.Future
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                    v.Enabled = true
                end
            end
        end
    end},
    {name = "DisableEffects", callback = function(enabled)
        if enabled then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") then
                    v.Enabled = false
                end
            end
        else
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") then
                    v.Enabled = true
                end
            end
        end
    end},
    {name = "ReduceTextures", callback = RemoveTextures},
    {name = "DisableLighting", callback = function(enabled)
        if enabled then
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").ShadowSoftness = 0
            game:GetService("Lighting").Technology = Enum.Technology.Compatibility
        else
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").ShadowSoftness = 0.5
            game:GetService("Lighting").Technology = Enum.Technology.Future
        end
    end}
}

local MiscFeatures = {
    {name = "ChatSpam", callback = ChatSpam},
    {name = "AutoFarm", callback = AutoFarm},
    {name = "ServerHop", callback = ServerHop}
}

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

-- Crear toggles y sliders para cada característica
for _, feature in ipairs(MovementFeatures) do
    if feature.slider then
        CreateSlider(feature.name, Sections.Movement, feature.callback, feature.min, feature.max, feature.default)
    else
        CreateToggle(feature.name, Sections.Movement, feature.callback)
    end
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

for _, feature in ipairs(OptimizationFeatures) do
    CreateToggle(feature.name, Sections.Optimization, feature.callback)
end

for _, feature in ipairs(MiscFeatures) do
    CreateToggle(feature.name, Sections.Misc, feature.callback)
end

for _, feature in ipairs(SettingsFeatures) do
    CreateToggle(feature.name, Sections.Settings, feature.callback)
end

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
