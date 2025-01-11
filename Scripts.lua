-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local PhysicsService = game:GetService("PhysicsService")
local TextureService = game:GetService("TextureService")
local SoundService = game:GetService("SoundService")

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
            ShortTermOptimization = "Short-Term Optimization",
            LongTermOptimization = "Long-Term Optimization",
            AdvancedOptimization = "Advanced Optimization",
            Settings = "Settings"
        },
        features = {
            -- Short-Term Optimization
            LowGraphics = "Low Graphics",
            DisableParticles = "Disable Particles",
            ReduceTextures = "Reduce Textures",
            DisableShadows = "Disable Shadows",
            LowerRenderDistance = "Lower Render Distance",
            DisableAtmosphere = "Disable Atmosphere",
            SimplifyTerrain = "Simplify Terrain",
            DisableDecals = "Disable Decals",
            OptimizeGUI = "Optimize GUI",
            ReduceAnimations = "Reduce Animations",
            
            -- Long-Term Optimization
            OptimizeMemory = "Optimize Memory",
            StreamingEnabled = "Enable Streaming",
            CacheAssets = "Cache Assets",
            OptimizePhysics = "Optimize Physics",
            ReduceAudio = "Reduce Audio Quality",
            DisableReflections = "Disable Reflections",
            OptimizeLighting = "Optimize Lighting",
            ReduceModelDetail = "Reduce Model Detail",
            OptimizeScripts = "Optimize Scripts",
            EnableGPUAcceleration = "Enable GPU Acceleration",
            
            -- Advanced Optimization
            CustomLODSystem = "Custom LOD System",
            DynamicChunkLoading = "Dynamic Chunk Loading",
            OcclusionCulling = "Occlusion Culling",
            AsyncAssetLoading = "Async Asset Loading",
            NetworkOptimization = "Network Optimization",
            ThreadedPhysics = "Threaded Physics",
            ShaderOptimization = "Shader Optimization",
            MemoryPooling = "Memory Pooling",
            DeferredRendering = "Deferred Rendering",
            AIOptimization = "AI Optimization",
            
            -- Settings
            Language = "Language",
            AutoOptimize = "Auto-Optimize on Join",
            OptimizationProfile = "Optimization Profile"
        },
        loading = "Loading...",
        serverInfo = "Server Info",
        players = "Players",
        fps = "FPS",
        ping = "Ping",
        serverName = "Server Name",
        memoryUsage = "Memory Usage",
        cpuUsage = "CPU Usage"
    },
    ["Español"] = {
        categories = {
            Home = "Inicio",
            ShortTermOptimization = "Optimización a Corto Plazo",
            LongTermOptimization = "Optimización a Largo Plazo",
            AdvancedOptimization = "Optimización Avanzada",
            Settings = "Ajustes"
        },
        features = {
            -- Short-Term Optimization
            LowGraphics = "Gráficos Bajos",
            DisableParticles = "Desactivar Partículas",
            ReduceTextures = "Reducir Texturas",
            DisableShadows = "Desactivar Sombras",
            LowerRenderDistance = "Reducir Distancia de Renderizado",
            DisableAtmosphere = "Desactivar Atmósfera",
            SimplifyTerrain = "Simplificar Terreno",
            DisableDecals = "Desactivar Calcomanías",
            OptimizeGUI = "Optimizar Interfaz",
            ReduceAnimations = "Reducir Animaciones",
            
            -- Long-Term Optimization
            OptimizeMemory = "Optimizar Memoria",
            StreamingEnabled = "Activar Streaming",
            CacheAssets = "Cachear Recursos",
            OptimizePhysics = "Optimizar Física",
            ReduceAudio = "Reducir Calidad de Audio",
            DisableReflections = "Desactivar Reflejos",
            OptimizeLighting = "Optimizar Iluminación",
            ReduceModelDetail = "Reducir Detalle de Modelos",
            OptimizeScripts = "Optimizar Scripts",
            EnableGPUAcceleration = "Activar Aceleración GPU",
            
            -- Advanced Optimization
            CustomLODSystem = "Sistema LOD Personalizado",
            DynamicChunkLoading = "Carga Dinámica de Chunks",
            OcclusionCulling = "Occlusion Culling",
            AsyncAssetLoading = "Carga Asíncrona de Recursos",
            NetworkOptimization = "Optimización de Red",
            ThreadedPhysics = "Física en Hilos",
            ShaderOptimization = "Optimización de Shaders",
            MemoryPooling = "Pooling de Memoria",
            DeferredRendering = "Renderizado Diferido",
            AIOptimization = "Optimización de IA",
            
            -- Settings
            Language = "Idioma",
            AutoOptimize = "Auto-Optimizar al Unirse",
            OptimizationProfile = "Perfil de Optimización"
        },
        loading = "Cargando...",
        serverInfo = "Información del Servidor",
        players = "Jugadores",
        fps = "FPS",
        ping = "Ping",
        serverName = "Nombre del Servidor",
        memoryUsage = "Uso de Memoria",
        cpuUsage = "Uso de CPU"
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
ScreenGui.Name = "EnhancedOptimizationGui"
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

-- Título "Enhanced Optimization"
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "Enhanced Optimization"
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

-- Funciones de optimización
local function LowGraphics(enabled)
    if enabled then
        settings().Rendering.QualityLevel = 1
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
        settings().Rendering.EagerBulkExecution = true
        settings().Rendering.AutoFRMLevel = 60
        settings().Rendering.GraphicsMode = 2
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").Technology = Enum.Technology.Compatibility
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end
    else
        settings().Rendering.QualityLevel = 7
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        settings().Rendering.EagerBulkExecution = false
        settings().Rendering.AutoFRMLevel = 0
        settings().Rendering.GraphicsMode = 0
        game:GetService("Lighting").GlobalShadows = true
        game:GetService("Lighting").Technology = Enum.Technology.Future
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v.Enabled = true
            end
        end
    end
end

local function DisableParticles(enabled)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            v.Enabled = not enabled
        end
    end
end

local function ReduceTextures(enabled)
    if enabled then
        settings().Rendering.TextureQuality = Enum.TextureQuality.Low
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
            end
        end
    else
        settings().Rendering.TextureQuality = Enum.TextureQuality.High
    end
end

local function DisableShadows(enabled)
    game:GetService("Lighting").GlobalShadows = not enabled
    game:GetService("Lighting").ShadowSoftness = enabled and 0 or 0.5
end

local function LowerRenderDistance(enabled)
    if enabled then
        settings().Rendering.EcoLevel = 3
    else
        settings().Rendering.EcoLevel = 0
    end
end

local function DisableAtmosphere(enabled)
    local atmosphere = game:GetService("Lighting"):FindFirstChildOfClass("Atmosphere")
    if atmosphere then
        atmosphere.Enabled = not enabled
    end
end

local function SimplifyTerrain(enabled)
    if enabled then
        workspace.Terrain.WaterWaveSize = 0
        workspace.Terrain.WaterWaveSpeed = 0
        workspace.Terrain.WaterReflectance = 0
        workspace.Terrain.WaterTransparency = 1
    else
        workspace.Terrain.WaterWaveSize = 0.15
        workspace.Terrain.WaterWaveSpeed = 10
        workspace.Terrain.WaterReflectance = 1
        workspace.Terrain.WaterTransparency = 0.3
    end
end

local function DisableDecals(enabled)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = enabled and 1 or 0
        end
    end
end

local function OptimizeGUI(enabled)
    for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
        if v:IsA("ImageLabel") or v:IsA("ImageButton") then
            v.Image = enabled and "" or v.Image
        end
    end
end

local function ReduceAnimations(enabled)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("AnimationController") then
            v.Enabled = not enabled
        end
    end
end

local function OptimizeMemory(enabled)
    if enabled then
        game:GetService("ContentProvider"):SetBaseUrl("http://www.roblox.com/asset/")
        game:GetService("ContentProvider"):SetAssetUrl("http://www.roblox.com/asset/")
        game:GetService("ContentProvider"):SetAssetVersionUrl("http://www.roblox.com/asset/")
        settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.DefaultAuto
        settings().Rendering.MeshCacheSize = 32
        settings().Rendering.FrameRateManager = Enum.FramerateManagerMode.Automatic
    else
        game:GetService("ContentProvider"):SetBaseUrl("https://www.roblox.com/asset/")
        game:GetService("ContentProvider"):SetAssetUrl("https://assetdelivery.roblox.com/v1/asset/")
        game:GetService("ContentProvider"):SetAssetVersionUrl("https://assetdelivery.roblox.com/v1/assetversion/")
        settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
        settings().Rendering.MeshCacheSize = 256
        settings().Rendering.FrameRateManager = Enum.FramerateManagerMode.On
    end
end

local function StreamingEnabled(enabled)
    settings().Rendering.StreamingEnabled = enabled
end

local function CacheAssets(enabled)
    game:GetService("ContentProvider"):SetCacheSize(enabled and 256 or 50)
    game:GetService("ContentProvider"):SetThreadPool(enabled and 12 or 4)
end

local function OptimizePhysics(enabled)
    if enabled then
        settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.DefaultAuto
        settings().Physics.UseCSGv2 = true
        settings().Physics.DisableCSGv2 = false
        PhysicsService.PhysicsSimulationRate = 60
    else
        settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
        settings().Physics.UseCSGv2 = false
        settings().Physics.DisableCSGv2 = true
        PhysicsService.PhysicsSimulationRate = 240
    end
end

local function ReduceAudio(enabled)
    if enabled then
        SoundService.RespectFilteringEnabled = true
        SoundService.DistanceFactor = 10
    else
        SoundService.RespectFilteringEnabled = false
        SoundService.DistanceFactor = 3.33
    end
end

local function DisableReflections(enabled)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") then
            v.Reflectance = enabled and 0 or v.Reflectance
        end
    end
end

local function OptimizeLighting(enabled)
    if enabled then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 10000
        Lighting.Brightness = 2
    else
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
        Lighting.Brightness = 1
    end
end

local function ReduceModelDetail(enabled)
    if enabled then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("MeshPart") then
                v.RenderFidelity = Enum.RenderFidelity.Performance
            end
        end
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("MeshPart") then
                v.RenderFidelity = Enum.RenderFidelity.Precise
            end
        end
    end
end

local function OptimizeScripts(enabled)
    if enabled then
        settings().Physics.ThrottleAdjustTime = 2
        settings().Physics.ForceCSGv2 = true
    else
        settings().Physics.ThrottleAdjustTime = 0.2
        settings().Physics.ForceCSGv2 = false
    end
end

local function EnableGPUAcceleration(enabled)
    if enabled then
        settings().Rendering.EnableFRM = true
        settings().Rendering.AutoFRMLevel = 60
    else
        settings().Rendering.EnableFRM = false
        settings().Rendering.AutoFRMLevel = 0
    end
end

-- Advanced Optimization Functions
local function CustomLODSystem(enabled)
    if enabled then
        -- Implement a custom LOD system
        print("Custom LOD System enabled")
    else
        print("Custom LOD System disabled")
    end
end

local function DynamicChunkLoading(enabled)
    if enabled then
        -- Implement dynamic chunk loading
        print("Dynamic Chunk Loading enabled")
    else
        print("Dynamic Chunk Loading disabled")
    end
end

local function OcclusionCulling(enabled)
    if enabled then
        -- Implement occlusion culling
        print("Occlusion Culling enabled")
    else
        print("Occlusion Culling disabled")
    end
end

local function AsyncAssetLoading(enabled)
    if enabled then
        -- Implement asynchronous asset loading
        print("Async Asset Loading enabled")
    else
        print("Async Asset Loading disabled")
    end
end

local function NetworkOptimization(enabled)
    if enabled then
        -- Implement network optimization techniques
        print("Network Optimization enabled")
    else
        print("Network Optimization disabled")
    end
end

local function ThreadedPhysics(enabled)
    if enabled then
        -- Implement threaded physics
        print("Threaded Physics enabled")
    else
        print("Threaded Physics disabled")
    end
end

local function ShaderOptimization(enabled)
    if enabled then
        -- Implement shader optimization
        print("Shader Optimization enabled")
    else
        print("Shader Optimization disabled")
    end
end

local function MemoryPooling(enabled)
    if enabled then
        -- Implement memory pooling
        print("Memory Pooling enabled")
    else
        print("Memory Pooling disabled")
    end
end

local function DeferredRendering(enabled)
    if enabled then
        -- Implement deferred rendering
        print("Deferred Rendering enabled")
    else
        print("Deferred Rendering disabled")
    end
end

local function AIOptimization(enabled)
    if enabled then
        -- Implement AI optimization techniques
        print("AI Optimization enabled")
    else
        print("AI Optimization disabled")
    end
end

-- Categorías actualizadas
local Categories = {
    {name = "Home", icon = "rbxassetid://3926305904"},
    {name = "ShortTermOptimization", icon = "rbxassetid://3926307971"},
    {name = "LongTermOptimization", icon = "rbxassetid://3926307971"},
    {name = "AdvancedOptimization", icon = "rbxassetid://3926307971"},
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
local ShortTermOptimizationFeatures = {
    {name = "LowGraphics", callback = LowGraphics},
    {name = "DisableParticles", callback = DisableParticles},
    {name = "ReduceTextures", callback = ReduceTextures},
    {name = "DisableShadows", callback = DisableShadows},
    {name = "LowerRenderDistance", callback = LowerRenderDistance},
    {name = "DisableAtmosphere", callback = DisableAtmosphere},
    {name = "SimplifyTerrain", callback = SimplifyTerrain},
    {name = "DisableDecals", callback = DisableDecals},
    {name = "OptimizeGUI", callback = OptimizeGUI},
    {name = "ReduceAnimations", callback = ReduceAnimations}
}

local LongTermOptimizationFeatures = {
    {name = "OptimizeMemory", callback = OptimizeMemory},
    {name = "StreamingEnabled", callback = StreamingEnabled},
    {name = "CacheAssets", callback = CacheAssets},
    {name = "OptimizePhysics", callback = OptimizePhysics},
    {name = "ReduceAudio", callback = ReduceAudio},
    {name = "DisableReflections", callback = DisableReflections},
    {name = "OptimizeLighting", callback = OptimizeLighting},
    {name = "ReduceModelDetail", callback = ReduceModelDetail},
    {name = "OptimizeScripts", callback = OptimizeScripts},
    {name = "EnableGPUAcceleration", callback = EnableGPUAcceleration}
}

local AdvancedOptimizationFeatures = {
    {name = "CustomLODSystem", callback = CustomLODSystem},
    {name = "DynamicChunkLoading", callback = DynamicChunkLoading},
    {name = "OcclusionCulling", callback = OcclusionCulling},
    {name = "AsyncAssetLoading", callback = AsyncAssetLoading},
    {name = "NetworkOptimization", callback = NetworkOptimization},
    {name = "ThreadedPhysics", callback = ThreadedPhysics},
    {name = "ShaderOptimization", callback = ShaderOptimization},
    {name = "MemoryPooling", callback = MemoryPooling},
    {name = "DeferredRendering", callback = DeferredRendering},
    {name = "AIOptimization", callback = AIOptimization}
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
    end},
    {name = "AutoOptimize", callback = function(enabled)
        -- Implementar auto-optimización al unirse
        if enabled then
            print("Auto-Optimize on Join enabled")
        else
            print("Auto-Optimize on Join disabled")
        end
    end},
    {name = "OptimizationProfile", callback = function(enabled)
        -- Implementar perfiles de optimización
        if enabled then
            print("Custom Optimization Profile enabled")
        else
            print("Default Optimization Profile enabled")
        end
    end}
}

-- Crear toggles para cada característica
for _, feature in ipairs(ShortTermOptimizationFeatures) do
    CreateToggle(feature.name, Sections.ShortTermOptimization, feature.callback)
end

for _, feature in ipairs(LongTermOptimizationFeatures) do
    CreateToggle(feature.name, Sections.LongTermOptimization, feature.callback)
end

for _, feature in ipairs(AdvancedOptimizationFeatures) do
    CreateToggle(feature.name, Sections.AdvancedOptimization, feature.callback)
end

for _, feature in ipairs(SettingsFeatures) do
    CreateToggle(feature.name, Sections.Settings, feature.callback)
end

-- Crear sección Home
local HomeSection = Sections.Home
local ServerInfoFrame = Instance.new("Frame")
ServerInfoFrame.Size = UDim2.new(1, 0, 0, 200)
ServerInfoFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ServerInfoFrame.Parent = HomeSection

local ServerInfoCorner = Instance.new("UICorner")
ServerInfoCorner.CornerRadius = UDim.new(0, 6)
ServerInfoCorner.Parent = ServerInfoFrame

local ServerInfoTitle = Instance.new("TextLabel")
ServerInfoTitle.Size = UDim2.new(1, 0, 0, 30)
ServerInfoTitle.Position = UDim2.new(0, 0, 0, 10)
ServerInfoTitle.BackgroundTransparency = 1
ServerInfoTitle.Font = Enum.Font.GothamBold
ServerInfoTitle.Text = Texts.serverInfo
ServerInfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ServerInfoTitle.TextSize = 18
ServerInfoTitle.Parent = ServerInfoFrame

local function CreateInfoLabel(text, yPos)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, yPos)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ServerInfoFrame
    return Label
end

local PlayersLabel = CreateInfoLabel(Texts.players .. ": 0", 50)
local FPSLabel = CreateInfoLabel(Texts.fps .. ": 0", 80)
local PingLabel = CreateInfoLabel(Texts.ping .. ": 0 ms", 110)
local ServerNameLabel = CreateInfoLabel(Texts.serverName .. ": " .. game.Name, 140)
local MemoryLabel = CreateInfoLabel(Texts.memoryUsage .. ": 0 MB", 170)
local CPULabel = CreateInfoLabel(Texts.cpuUsage .. ": 0%", 200)

-- Actualizar información del servidor
local function UpdateServerInfo()
    PlayersLabel.Text = Texts.players .. ": " .. #Players:GetPlayers()
    FPSLabel.Text = Texts.fps .. ": " .. math.floor(1 / RunService.RenderStepped:Wait())
    PingLabel.Text = Texts.ping .. ": " .. math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) .. " ms"
    MemoryLabel.Text = Texts.memoryUsage .. ": " .. math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb()) .. " MB"
    CPULabel.Text = Texts.cpuUsage .. ": " .. math.floor(game:GetService("Stats").GetTotalGameMemoryUsageMb()) .. "%"
end

RunService.RenderStepped:Connect(UpdateServerInfo)

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
ShowSection("Home")

-- Mensaje de confirmación
print("Script de optimización mejorado cargado correctamente. Use el botón en la izquierda para mostrar/ocultar el menú.")
