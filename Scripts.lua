-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables principales
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

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

-- Función para detectar las notas
local function GetNoteData()
    local success, result = pcall(function()
        -- Buscar el marco de notas en la interfaz
        local playerFrame = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Game"):WaitForChild("UI"):WaitForChild("PlayerFrame")
        -- Obtener información sobre las notas activas
        local notes = playerFrame:GetChildren()
        for _, note in pairs(notes) do
            if note:IsA("Frame") and note.Name == "Note" then
                -- Procesar la nota cuando esté en el momento correcto
                local position = note.AbsolutePosition
                local size = note.AbsoluteSize
                -- Calcular el momento óptimo para golpear
                if position.Y >= (workspace.CurrentCamera.ViewportSize.Y * 0.8) then
                    -- Simular la pulsación de tecla correspondiente
                    local key = note:GetAttribute("Key")
                    if key then
                        -- Añadir un pequeño retraso aleatorio para simular timing humano
                        wait(math.random() * (AutoDelay/1000))
                        -- Simular la pulsación con la precisión configurada
                        if math.random(1, 100) <= HitAccuracy then
                            -- Enviar evento de tecla
                            game:GetService("ReplicatedStorage").Remotes.Input:FireServer(key, "down")
                            wait(0.05)
                            game:GetService("ReplicatedStorage").Remotes.Input:FireServer(key, "up")
                        end
                    end
                end
            end
        end
    end)
    if not success then
        warn("Error al procesar notas:", result)
    end
end

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

-- Función principal del Auto-Player
local function ToggleAutoPlayer()
    AutoPlayerEnabled = not AutoPlayerEnabled
    AutoPlayButton.Text = "Auto-Play: " .. (AutoPlayerEnabled and Texts.enabled or Texts.disabled)
    
    if AutoPlayerEnabled then
        -- Iniciar el bucle de detección de notas
        RunService.RenderStepped:Connect(function()
            if AutoPlayerEnabled then
                GetNoteData()
            end
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

-- Mensaje de inicio
print("FunkyFriday Helper cargado. Presiona el botón para mostrar/ocultar el menú.")
