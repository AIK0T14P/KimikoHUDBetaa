-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

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

-- Sistema de idiomas (ahora por defecto en español)
local Languages = {
    ["Español"] = {
        categories = {
            Movement = "Movimiento",
            Combat = "Combate",
            Visuals = "Visuales",
            Player = "Jugador",
            World = "Mundo",
            Optimization = "Optimización",
            Misc = "Varios",
            Settings = "Ajustes"
        },
        features = {
            Fly = "Volar",
            Speed = "Velocidad",
            SuperJump = "Super Salto",
            InfiniteJump = "Salto Infinito",
            NoClip = "Atravesar Paredes",
            GodMode = "Modo Dios",
            KillAura = "Aura Asesina",
            AutoParry = "Auto Bloqueo",
            Reach = "Alcance",
            ESP = "ESP",
            Chams = "Siluetas",
            Tracers = "Trazadores",
            Fullbright = "Brillo Total",
            Invisibility = "Invisibilidad",
            AntiAFK = "Anti AFK",
            AutoReset = "Auto Reinicio",
            RemoveFog = "Quitar Niebla",
            DayNight = "Día/Noche",
            RemoveTextures = "Quitar Texturas",
            ChatSpam = "Spam de Chat",
            AutoFarm = "Auto Farming",
            ServerHop = "Cambiar Servidor",
            Language = "Idioma",
            LowGraphics = "Gráficos Bajos",
            DisableEffects = "Desactivar Efectos",
            ReduceTextures = "Reducir Texturas",
            DisableLighting = "Desactivar Iluminación",
            SaveRespawn = "Guardar Reaparición",
            DeleteRespawn = "Borrar Reaparición",
            SavePosition = "Guardar Posición",
            TeleportToPosition = "Teletransportar",
            BunnyHop = "Salto Continuo",
            WallRun = "Correr en Paredes",
            DoubleJump = "Doble Salto",
            AirDash = "Dash Aéreo",
            Slide = "Deslizar",
            Grapple = "Gancho",
            SpeedBoost = "Aumento de Velocidad",
            JumpBoost = "Aumento de Salto",
            Levitation = "Levitación",
            Blink = "Parpadeo",
            Telekinesis = "Telequinesis",
            AutoDodge = "Auto Esquivar",
            AutoAim = "Auto Apuntar",
            RapidFire = "Disparo Rápido",
            InfiniteAmmo = "Munición Infinita",
            DamageMultiplier = "Multiplicador de Daño",
            AutoBlock = "Auto Bloquear",
            CriticalHit = "Golpe Crítico",
            Aimbot = "Apuntado Automático",
            SilentAim = "Apuntado Silencioso",
            Wallbang = "Disparar a través de Paredes",
            InstantKill = "Muerte Instantánea",
            AutoHeal = "Auto Curación",
            Triggerbot = "Disparo Automático",
            SpinBot = "Giro Automático",
            AntiAim = "Anti Apuntado",
            HitboxExpander = "Expandir Hitbox",
            WeaponMods = "Modificaciones de Armas",
            AutoReload = "Recarga Automática",
            RapidMelee = "Ataque Cuerpo a Cuerpo Rápido"
        },
        loading = "Cargando..."
    },
    ["English"] = {
        -- ... (English translations)
    }
}

local CurrentLanguage = "Español"
local Texts = Languages[CurrentLanguage]

-- Crear pantalla de carga
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "LoadingGui"
LoadingGui.ResetOnSpawn = false
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoadingGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

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

-- Función mejorada para crear botones de toggle
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
    Label.Text = Texts.features[name]
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
        
        -- Desconectar la conexión anterior si existe
        if Connection then
            Connection:Disconnect()
            Connection = nil
        end
        
        -- Llamar al callback con el nuevo estado
        callback(Enabled)
    end
    
    Switch.MouseButton1Click:Connect(Toggle)
    
    -- Función para obtener el estado actual
    local function GetState()
        return Enabled
    end
    
    -- Función para establecer el estado
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

-- Función mejorada para crear sliders
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
    Label.Text = Texts.features[name] .. ": " .. default
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
    else
        Character.Parent = workspace
        local clone = workspace:FindFirstChild(Character.Name)
        if clone then clone:Destroy() end
    end
end

local function KillAura(enabled)
    local connection
    if enabled then
        connection = RunService.Heartbeat:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (player.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                    if distance <= 10 then
                        local args = {
                            [1] = player.Character.Humanoid
                        }
                        game:GetService("ReplicatedStorage").RemoteEvents.DamageEvent:FireServer(unpack(args))
                    end
                end
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function AutoParry(enabled)
    local connection
    if enabled then
        connection = RunService.Heartbeat:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (player.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                    if distance <= 15 then
                        game:GetService("ReplicatedStorage").RemoteEvents.ParryEvent:FireServer()
                    end
                end
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function Reach(enabled)
    if enabled then
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") then
                local handle = tool:FindFirstChild("Handle")
                if handle then
                    local originalSize = handle.Size
                    handle.Size = originalSize * 2
                    handle.Massless = true
                end
            end
        end
    else
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") then
                local handle = tool:FindFirstChild("Handle")
                if handle then
                    handle.Size = handle.Size / 2
                    handle.Massless = false
                end
            end
        end
    end
end

local function AutoDodge(enabled)
    local connection
    if enabled then
        connection = RunService.Heartbeat:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (player.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                    if distance <= 10 then
                        local randomDirection = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
                        Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame + randomDirection * 5
                    end
                end
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function AutoAim(enabled)
    local connection
    if enabled then
        connection = RunService.RenderStepped:Connect(function()
            local closestPlayer = nil
            local closestDistance = math.huge
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (player.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestPlayer = player
                        closestDistance = distance
                    end
                end
            end
            if closestPlayer then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Character.HumanoidRootPart.Position)
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function RapidFire(enabled)
    if enabled then
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") then
                local fireRate = tool:FindFirstChild("FireRate")
                if fireRate and fireRate:IsA("NumberValue") then
                    fireRate.Value = 0.05
                end
            end
        end
    else
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") then
                local fireRate = tool:FindFirstChild("FireRate")
                if fireRate and fireRate:IsA("NumberValue") then
                    fireRate.Value = 0.5
                end
            end
        end
    end
end

local function InfiniteAmmo(enabled)
    local connection
    if enabled then
        connection = RunService.Stepped:Connect(function()
            for _, tool in pairs(Character:GetChildren()) do
                if tool:IsA("Tool") then
                    local ammo = tool:FindFirstChild("Ammo")
                    if ammo and ammo:IsA("IntValue") then
                        ammo.Value = 999
                    end
                end
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function DamageMultiplier(enabled)
    if enabled then
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") then
                local damage = tool:FindFirstChild("Damage")
                if damage and damage:IsA("NumberValue") then
                    damage.Value = damage.Value * 2
                end
            end
        end
    else
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") then
                local damage = tool:FindFirstChild("Damage")
                if damage and damage:IsA("NumberValue") then
                    damage.Value = damage.Value / 2
                end
            end
        end
    end
end

local function AutoBlock(enabled)
    local connection
    if enabled then
        connection = RunService.Heartbeat:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (player.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                    if distance <= 10 then
                        game:GetService("ReplicatedStorage").RemoteEvents.BlockEvent:FireServer(true)
                    else
                        game:GetService("ReplicatedStorage").RemoteEvents.BlockEvent:FireServer(false)
                    end
                end
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
        game:GetService("ReplicatedStorage").RemoteEvents.BlockEvent:FireServer(false)
    end
end

local function CriticalHit(enabled)
    if enabled then
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") then
                local critChance = Instance.new("NumberValue")
                critChance.Name = "CriticalChance"
                critChance.Value = 100
                critChance.Parent = tool
            end
        end
    else
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") then
                local critChance = tool:FindFirstChild("CriticalChance")
                if critChance then
                    critChance:Destroy()
                end
            end
        end
    end
end

local function Aimbot(enabled)
    local connection
    if enabled then
        connection = RunService.RenderStepped:Connect(function()
            local closestPlayer = nil
            local closestDistance = math.huge
            local mousePosition = UserInputService:GetMouseLocation()

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local screenPosition, onScreen = Camera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
                    if onScreen then
                        local distance = (Vector2.new(mousePosition.X, mousePosition.Y) - Vector2.new(screenPosition.X, screenPosition.Y)).Magnitude
                        if distance < closestDistance then
                            closestPlayer = player
                            closestDistance = distance
                        end
                    end
                end
            end

            if closestPlayer then
                local aimPart = closestPlayer.Character.HumanoidRootPart
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPart.Position)
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function SilentAim(enabled)
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if enabled and (method == "FireServer" or method == "InvokeServer") and self.Name == "RemoteEvents" then
            local closestPlayer = nil
            local closestDistance = math.huge
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (player.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestPlayer = player
                        closestDistance = distance
                    end
                end
            end
            
            if closestPlayer and args[1] == "FireWeapon" then
                args[2] = closestPlayer.Character.HumanoidRootPart.Position
            end
        end
        
        return oldNamecall(self, unpack(args))
    end)
end

local function Wallbang(enabled)
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if enabled and (method == "Raycast" or method == "FindPartOnRayWithIgnoreList") then
            args[2] = Ray.new(args[2].Origin, args[2].Direction * 1000)
            args[3] = {Character, workspace.Map}
        end
        
        return oldNamecall(self, unpack(args))
    end)
end

local function InstantKill(enabled)
    if enabled then
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") then
                local damage = tool:FindFirstChild("Damage")
                if damage and damage:IsA("NumberValue") then
                    damage.Value = 1000000
                end
            end
        end
    else
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") then
                local damage = tool:FindFirstChild("Damage")
                if damage and damage:IsA("NumberValue") then
                    damage.Value = damage.Value / 1000000
                end
            end
        end
    end
end

local function AutoHeal(enabled)
    local connection
    if enabled then
        connection = RunService.Heartbeat:Connect(function()
            if Humanoid.Health < Humanoid.MaxHealth then
                Humanoid.Health = Humanoid.Health + 1
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function Triggerbot(enabled)
    local connection
    if enabled then
        connection = RunService.RenderStepped:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Target
            if target and target.Parent:FindFirstChild("Humanoid") then
                mouse1press()
                wait()
                mouse1release()
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function BunnyHop(enabled)
    local connection
    if enabled then
        connection = RunService.Heartbeat:Connect(function()
            if Humanoid:GetState() == Enum.HumanoidStateType.Running then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function SpinBot(enabled)
    local connection
    if enabled then
        connection = RunService.RenderStepped:Connect(function()
            Character:SetPrimaryPartCFrame(Character:GetPrimaryPartCFrame() * CFrame.Angles(0, math.rad(10), 0))
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function AntiAim(enabled)
    local connection
    if enabled then
        connection = RunService.RenderStepped:Connect(function()
            Character:SetPrimaryPartCFrame(Character:GetPrimaryPartCFrame() * CFrame.Angles(math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180))))
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function HitboxExpander(enabled)
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
                player.Character.HumanoidRootPart.Transparency = 0.5
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                player.Character.HumanoidRootPart.Transparency = 1
            end
        end
    end
end

local function WeaponMods(enabled)
    if enabled then
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") then
                local fireRate = tool:FindFirstChild("FireRate")
                if fireRate and fireRate:IsA("NumberValue") then
                    fireRate.Value = 0.05
                end
                local recoil = tool:FindFirstChild("Recoil")
                if recoil and recoil:IsA("NumberValue") then
                    recoil.Value = 0
                end
                local spread = tool:FindFirstChild("Spread")
                if spread and spread:IsA("NumberValue") then
                    spread.Value = 0
                end
            end
        end
    else
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") then
                local fireRate = tool:FindFirstChild("FireRate")
                if fireRate and fireRate:IsA("NumberValue") then
                    fireRate.Value = 0.5
                end
                local recoil = tool:FindFirstChild("Recoil")
                if recoil and recoil:IsA("NumberValue") then
                    recoil.Value = 1
                end
                local spread = tool:FindFirstChild("Spread")
                if spread and spread:IsA("NumberValue") then
                    spread.Value = 1
                end
            end
        end
    end
end

local function AutoReload(enabled)
    local connection
    if enabled then
        connection = RunService.Heartbeat:Connect(function()
            for _, tool in pairs(Character:GetChildren()) do
                if tool:IsA("Tool") then
                    local ammo = tool:FindFirstChild("Ammo")
                    if ammo and ammo:IsA("IntValue") and ammo.Value == 0 then
                        tool:Activate()
                    end
                end
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function RapidMelee(enabled)
    if enabled then
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Melee") then
                local cooldown = tool:FindFirstChild("Cooldown")
                if cooldown and cooldown:IsA("NumberValue") then
                    cooldown.Value = 0
                end
            end
        end
    else
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Melee") then
                local cooldown = tool:FindFirstChild("Cooldown")
                if cooldown and cooldown:IsA("NumberValue") then
                    cooldown.Value = 1
                end
            end
        end
    end
end

local function WallRun(enabled)
    local connection
    if enabled then
        connection = RunService.Stepped:Connect(function()
            local ray = Ray.new(HumanoidRootPart.Position, HumanoidRootPart.CFrame.RightVector * 4)
            local hit, pos, normal = workspace:FindPartOnRay(ray, Character)
            if hit then
                HumanoidRootPart.Velocity = Vector3.new(0, 20, 0)
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function DoubleJump(enabled)
    local jumps = 0
    local connection
    if enabled then
        connection = Humanoid.StateChanged:Connect(function(oldState, newState)
            if newState == Enum.HumanoidStateType.Landed then
                jumps = 0
            elseif newState == Enum.HumanoidStateType.Jumping then
                if jumps < 1 then
                    jumps = jumps + 1
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function AirDash(enabled)
    local connection
    if enabled then
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftShift and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                local direction = HumanoidRootPart.CFrame.LookVector
                HumanoidRootPart.Velocity = direction * 100
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function Slide(enabled)
    local connection
    if enabled then
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == Enum.KeyCode.C and Humanoid:GetState() == Enum.HumanoidStateType.Running then
                Humanoid.Sit = true
                HumanoidRootPart.Velocity = HumanoidRootPart.CFrame.LookVector * 50
                wait(1)
                Humanoid.Sit = false
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function Grapple(enabled)
    local tool = Instance.new("Tool")
    tool.Name = "Grapple"
    tool.Parent = LocalPlayer.Backpack

    local function Grapple()
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Hit.Position
        local direction = (target - HumanoidRootPart.Position).Unit
        HumanoidRootPart.Velocity = direction * 100
    end

    if enabled then
        tool.Activated:Connect(Grapple)
    else
        tool:Destroy()
    end
end

local function SpeedBoost(enabled)
    if enabled then
        Humanoid.WalkSpeed = Humanoid.WalkSpeed * 2
    else
        Humanoid.WalkSpeed = 16
    end
end

local function JumpBoost(enabled)
    if enabled then
        Humanoid.JumpPower = Humanoid.JumpPower * 2
    else
        Humanoid.JumpPower = 50
    end
end

local function Levitation(enabled)
    local connection
    if enabled then
        connection = RunService.Heartbeat:Connect(function()
            HumanoidRootPart.Velocity = Vector3.new(0, 5, 0)
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function Blink(enabled)
    local connection
    if enabled then
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == Enum.KeyCode.E then
                local direction = HumanoidRootPart.CFrame.LookVector
                HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 20
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function Telekinesis(enabled)
    local mouse = LocalPlayer:GetMouse()
    local heldObject = nil
    local connection

    if enabled then
        connection = mouse.Button1Down:Connect(function()
            local target = mouse.Target
            if target and target:IsA("BasePart") and not target:IsDescendantOf(Character) then
                heldObject = target
                local bodyPosition = Instance.new("BodyPosition")
                bodyPosition.Position = heldObject.Position
                bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyPosition.Parent = heldObject
            end
        end)

        mouse.Button1Up:Connect(function()
            if heldObject then
                heldObject:FindFirstChildOfClass("BodyPosition"):Destroy()
                heldObject = nil
            end
        end)

        RunService.RenderStepped:Connect(function()
            if heldObject then
                local bodyPosition = heldObject:FindFirstChildOfClass("BodyPosition")
                if bodyPosition then
                    bodyPosition.Position = mouse.Hit.Position
                end
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
        if heldObject and heldObject:FindFirstChildOfClass("BodyPosition") then
            heldObject:FindFirstChildOfClass("BodyPosition"):Destroy()
        end
    end
end

-- Implementación mejorada del ESP
local function ESP(enabled)
    local ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "ESPFolder"
    ESPFolder.Parent = game.CoreGui
    
    local function createESP(player)
        if player == LocalPlayer then return end
        
        local function createBoxHighlight()
            local highlight = Instance.new("Highlight")
            highlight.Name = player.Name .. "Highlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = ESPFolder
            return highlight
        end
        
        local function createNameTag()
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = player.Name .. "NameTag"
            billboardGui.Size = UDim2.new(0, 200, 0, 50)
            billboardGui.StudsOffset = Vector3.new(0, 3, 0)
            billboardGui.AlwaysOnTop = true
            billboardGui.Parent = ESPFolder
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0, 20)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.new(1, 1, 1)
            nameLabel.TextStrokeTransparency = 0
            nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            nameLabel.Font = Enum.Font.SourceSansBold
            nameLabel.TextScaled = true
            nameLabel.Parent = billboardGui
            
            return billboardGui, nameLabel
        end
        
        local highlight = createBoxHighlight()
        local nameTag, nameLabel = createNameTag()
        
        local function updateESP()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                highlight.Parent = player.Character
                nameTag.Parent = player.Character.HumanoidRootPart
                nameLabel.Text = string.format("%s\n%.1f studs", player.Name,
                    (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
            end
        end
        
        local connection = RunService.RenderStepped:Connect(updateESP)
        
        player.CharacterAdded:Connect(function(char)
            highlight.Parent = char
            nameTag.Parent = char:WaitForChild("HumanoidRootPart")
        end)
        
        return {
            highlight = highlight,
            nameTag = nameTag,
            connection = connection
        }
    end
    
    local espData = {}
    
    if enabled then
        -- Crear ESP para jugadores existentes
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                espData[player] = createESP(player)
            end
        end
        
        -- Crear ESP para nuevos jugadores
        Players.PlayerAdded:Connect(function(player)
            espData[player] = createESP(player)
        end)
        
        -- Limpiar ESP cuando los jugadores salen
        Players.PlayerRemoving:Connect(function(player)
            if espData[player] then
                espData[player].highlight:Destroy()
                espData[player].nameTag:Destroy()
                espData[player].connection:Disconnect()
                espData[player] = nil
            end
        end)
    else
        -- Limpiar todo el ESP
        for player, data in pairs(espData) do
            data.highlight:Destroy()
            data.nameTag:Destroy()
            data.connection:Disconnect()
            espData[player] = nil
        end
        ESPFolder:Destroy()
    end
end

-- Función para Chams
local function Chams(enabled)
    local ChamsFolder = Instance.new("Folder")
    ChamsFolder.Name = "ChamsFolder"
    ChamsFolder.Parent = game.CoreGui

    local function createChams(player)
        if player == LocalPlayer then return end

        local function applyChams(part)
            local chamPart = Instance.new("BoxHandleAdornment")
            chamPart.Name = player.Name .. "Cham"
            chamPart.Adornee = part
            chamPart.AlwaysOnTop = true
            chamPart.ZIndex = 5
            chamPart.Size = part.Size
            chamPart.Transparency = 0.5
            chamPart.Color3 = Color3.new(1, 0, 0)
            chamPart.Parent = ChamsFolder
            return chamPart
        end

        local chams = {}
        local function updateChams()
            if player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") and not chams[part] then
                        chams[part] = applyChams(part)
                    end
                end
            end
        end

        local connection = RunService.RenderStepped:Connect(updateChams)

        player.CharacterAdded:Connect(updateChams)

        return {
            chams = chams,
            connection = connection
        }
    end

    local chamsData = {}

    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                chamsData[player] = createChams(player)
            end
        end

        Players.PlayerAdded:Connect(function(player)
            chamsData[player] = createChams(player)
        end)

        Players.PlayerRemoving:Connect(function(player)
            if chamsData[player] then
                for _, cham in pairs(chamsData[player].chams) do
                    cham:Destroy()
                end
                chamsData[player].connection:Disconnect()
                chamsData[player] = nil
            end
        end)
    else
        for player, data in pairs(chamsData) do
            for _, cham in pairs(data.chams) do
                cham:Destroy()
            end
            data.connection:Disconnect()
            chamsData[player] = nil
        end
        ChamsFolder:Destroy()
    end
end

-- Función para Tracers
local function Tracers(enabled)
    local TracersFolder = Instance.new("Folder")
    TracersFolder.Name = "TracersFolder"
    TracersFolder.Parent = game.CoreGui

    local function createTracer(player)
        if player == LocalPlayer then return end

        local tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Color = Color3.new(1, 0, 0)
        tracer.Thickness = 1
        tracer.Transparency = 1

        local function updateTracer()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
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
        end

        local connection = RunService.RenderStepped:Connect(updateTracer)

        return {
            tracer = tracer,
            connection = connection
        }
    end

    local tracersData = {}

    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                tracersData[player] = createTracer(player)
            end
        end

        Players.PlayerAdded:Connect(function(player)
            tracersData[player] = createTracer(player)
        end)

        Players.PlayerRemoving:Connect(function(player)
            if tracersData[player] then
                tracersData[player].tracer:Remove()
                tracersData[player].connection:Disconnect()
                tracersData[player] = nil
            end
        end)
    else
        for player, data in pairs(tracersData) do
            data.tracer:Remove()
            data.connection:Disconnect()
            tracersData[player] = nil
        end
        TracersFolder:Destroy()
    end
end

-- Función para Fullbright
local function Fullbright(enabled)
    if enabled then
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").FogEnd = 100000
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").ClockTime = 12
        game:GetService("Lighting").FogEnd = 10000
        game:GetService("Lighting").GlobalShadows = true
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(127, 127, 127)
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

-- Características



-- Características actualizadas
local MovementFeatures = {
    {name = "Fly", callback = ToggleFly},
    {name = "Speed", callback = ToggleSpeed, slider = true, min = 16, max = 200, default = 16},
    {name = "SuperJump", callback = ToggleSuperJump, slider = true, min = 50, max = 500, default = 50},
    {name = "InfiniteJump", callback = InfiniteJump},
    {name = "NoClip", callback = NoClip},
    {name = "BunnyHop", callback = BunnyHop},
    {name = "WallRun", callback = WallRun},
    {name = "DoubleJump", callback = DoubleJump},
    {name = "AirDash", callback = AirDash},
    {name = "Slide", callback = Slide},
    {name = "Grapple", callback = Grapple},
    {name = "SpeedBoost", callback = SpeedBoost},
    {name = "JumpBoost", callback = JumpBoost},
    {name = "Levitation", callback = Levitation},
    {name = "Blink", callback = Blink}
}

local CombatFeatures = {
    {name = "GodMode", callback = GodMode},
    {name = "KillAura", callback = KillAura},
    {name = "AutoParry", callback = AutoParry},
    {name = "Reach", callback = Reach},
    {name = "AutoDodge", callback = AutoDodge},
    {name = "AutoAim", callback = AutoAim},
    {name = "RapidFire", callback = RapidFire},
    {name = "InfiniteAmmo", callback = InfiniteAmmo},
    {name = "DamageMultiplier", callback = DamageMultiplier},
    {name = "AutoBlock", callback = AutoBlock},
    {name = "CriticalHit", callback = CriticalHit},
    {name = "Aimbot", callback = Aimbot},
    {name = "SilentAim", callback = SilentAim},
    {name = "Wallbang", callback = Wallbang},
    {name = "InstantKill", callback = InstantKill},
    {name = "AutoHeal", callback = AutoHeal},
    {name = "Triggerbot", callback = Triggerbot},
    {name = "SpinBot", callback = SpinBot},
    {name = "AntiAim", callback = AntiAim},
    {name = "HitboxExpander", callback = HitboxExpander},
    {name = "WeaponMods", callback = WeaponMods},
    {name = "AutoReload", callback = AutoReload},
    {name = "RapidMelee", callback = RapidMelee}
}

local VisualFeatures = {
    {name = "ESP", callback = ESP},
    {name = "Chams", callback = Chams},
    {name = "Tracers", callback = Tracers},
    {name = "Fullbright", callback = Fullbright}
}

local PlayerFeatures = {
    {name = "Invisibility", callback = function() end},
    {name = "AntiAFK", callback = function() end},
    {name = "AutoReset", callback = function() end},
    {name = "SaveRespawn", callback = function() end},
    {name = "DeleteRespawn", callback = function() end},
    {name = "SavePosition", callback = function() end},
    {name = "TeleportToPosition", callback = function() end},
    {name = "Telekinesis", callback = Telekinesis}
}

local WorldFeatures = {
    {name = "RemoveFog", callback = function() end},
    {name = "DayNight", callback = function() end},
    {name = "RemoveTextures", callback = function() end}
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
    {name = "ReduceTextures", callback = function(enabled)
        if enabled then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Material ~= Enum.Material.Air then
                    v.Material = Enum.Material.SmoothPlastic
                end
            end
        else
            -- Restore original textures (this is a simplified version, you might want to store original textures)
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Material == Enum.Material.SmoothPlastic then
                    v.Material = Enum.Material.Plastic
                end
            end
        end
    end},
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
    {name = "ChatSpam", callback = function() end},
    {name = "AutoFarm", callback = function() end},
    {name = "ServerHop", callback = function() end}
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

-- Eliminar la GUI de carga
LoadingGui:Destroy()

-- Mostrar la primera sección por defecto
ShowSection("Movement")

-- Mensaje de confirmación
print("Script mejorado cargado correctamente. Use el botón en la izquierda para mostrar/ocultar el menú.")
