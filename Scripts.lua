-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables principales
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local InputRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Input")

-- Sistema de idiomas
local Languages = {
    ["Español"] = {
        categories = {
            Home = "Inicio",
            AutoPlay = "Auto-Jugar",
            Settings = "Ajustes"
        },
        features = {
            AutoPlayer = "Auto-Jugador",
            HitAccuracy = "Precisión de Golpes",
            AutoDelay = "Retraso Automático",
            Language = "Idioma"
        },
        loading = "Cargando...",
        serverInfo = "Información del Servidor",
        players = "Jugadores",
        enabled = "Activado",
        disabled = "Desactivado",
        status = "Estado"
    }
}

local CurrentLanguage = "Español"
local Texts = Languages[CurrentLanguage]

-- Variables del auto-player
local AutoPlayerEnabled = false
local HitAccuracy = 98 -- Porcentaje de precisión
local AutoDelay = 0 -- Retraso en milisegundos

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FunkyFridayHelper"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Botón para mostrar/ocultar
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
ToggleButton.Parent = ScreenGui

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Crear botón de Auto-Play
local AutoPlayButton = Instance.new("TextButton")
AutoPlayButton.Size = UDim2.new(0, 200, 0, 50)
AutoPlayButton.Position = UDim2.new(0.5, -100, 0.3, 0)
AutoPlayButton.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
AutoPlayButton.Text = "Auto-Play: " .. (AutoPlayerEnabled and Texts.enabled or Texts.disabled)
AutoPlayButton.Parent = MainFrame

-- Nueva función mejorada para detectar y presionar notas
local function PressArrow(arrow)
    local direction = arrow.Name:match("Arrow(.+)")
    if direction then
        -- Simular presión
        task.spawn(function()
            InputRemote:FireServer(direction, "down")
            task.wait(0.05)
            InputRemote:FireServer(direction, "up")
        end)
    end
end

-- Nueva función de detección de notas mejorada
local function GetNoteData()
    local success, result = pcall(function()
        local playerFrame = LocalPlayer.PlayerGui:WaitForChild("Game"):WaitForChild("UI"):WaitForChild("PlayerFrame")
        
        for _, arrow in pairs(playerFrame:GetChildren()) do
            if arrow:IsA("Frame") and arrow:FindFirstChild("Position") then
                local pos = arrow.Position.Value
                -- Ajuste del rango de detección
                if pos >= -2 and pos <= 2 then
                    -- Verificar precisión
                    if math.random(1, 100) <= HitAccuracy then
                        PressArrow(arrow)
                    end
                end
            end
        end
    end)
    
    if not success then
        warn("Error en GetNoteData:", result)
    end
end

-- Función principal del Auto-Player
local function ToggleAutoPlayer()
    AutoPlayerEnabled = not AutoPlayerEnabled
    AutoPlayButton.Text = "Auto-Play: " .. (AutoPlayerEnabled and Texts.enabled or Texts.disabled)
    AutoPlayButton.BackgroundColor3 = AutoPlayerEnabled and 
        Color3.fromRGB(76, 175, 80) or 
        Color3.fromRGB(147, 112, 219)
    
    if AutoPlayerEnabled then
        -- Crear una nueva conexión cada vez que se activa
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not AutoPlayerEnabled then
                connection:Disconnect()
                return
            end
            GetNoteData()
        end)
    end
end

AutoPlayButton.MouseButton1Click:Connect(ToggleAutoPlayer)

-- Slider para la precisión
local AccuracySlider = Instance.new("TextBox")
AccuracySlider.Size = UDim2.new(0, 200, 0, 30)
AccuracySlider.Position = UDim2.new(0.5, -100, 0.5, 0)
AccuracySlider.Text = "Precisión: " .. HitAccuracy .. "%"
AccuracySlider.Parent = MainFrame

-- Función para actualizar la precisión
AccuracySlider.FocusLost:Connect(function()
    local newValue = tonumber(AccuracySlider.Text:match("%d+"))
    if newValue and newValue >= 0 and newValue <= 100 then
        HitAccuracy = newValue
    end
    AccuracySlider.Text = "Precisión: " .. HitAccuracy .. "%"
end)

-- Toggle del botón principal
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Esquinas redondeadas para los elementos
local function AddCorners(element)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = element
end

AddCorners(ToggleButton)
AddCorners(MainFrame)
AddCorners(AutoPlayButton)
AddCorners(AccuracySlider)

-- Mensaje de inicio
print("FunkyFriday Helper actualizado cargado. Presiona el botón para mostrar/ocultar el menú.")
