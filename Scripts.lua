-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Variables principales
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local GameUI = PlayerGui:WaitForChild("Game")
local MainUI = GameUI:WaitForChild("UI")
local SongPlayer = MainUI:WaitForChild("PlayerFrame")
local RemoteInput = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Input")

-- Variables de control
local AutoplayEnabled = false
local Accuracy = 96 -- Porcentaje de precisión

-- Crear GUI simple para móvil
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FunkyFridayMobile"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

-- Botón principal
local MainButton = Instance.new("TextButton")
MainButton.Size = UDim2.new(0, 120, 0, 50)
MainButton.Position = UDim2.new(0, 10, 0.7, 0) -- Posición más accesible para móvil
MainButton.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
MainButton.Text = "Activar Auto"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.TextSize = 18
MainButton.Font = Enum.Font.GothamBold
MainButton.Parent = ScreenGui

-- Esquinas redondeadas
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0.2, 0)
Corner.Parent = MainButton

-- Función para simular toque
local function SimulateTouch(arrow)
    if not AutoplayEnabled then return end
    
    local success, error = pcall(function()
        local direction = arrow.Name:match("Arrow(.+)")
        if direction then
            -- Simular input táctil
            RemoteInput:FireServer(direction, "down")
            task.wait(0.05)
            RemoteInput:FireServer(direction, "up")
        end
    end)
    
    if not success then
        warn("Error al simular toque:", error)
    end
end

-- Función principal de autoplay
local function AutoplayFunction()
    while true do
        if not AutoplayEnabled then
            task.wait(0.1)
            continue
        end

        local success, error = pcall(function()
            for _, arrow in pairs(SongPlayer:GetChildren()) do
                if arrow:IsA("Frame") and arrow:FindFirstChild("Position") then
                    local pos = arrow.Position.Value
                    -- Ajustar rango de detección para móvil
                    if pos >= -5 and pos <= 5 then
                        -- Verificar precisión
                        if math.random(1, 100) <= Accuracy then
                            SimulateTouch(arrow)
                        end
                    end
                end
            end
        end)

        if not success then
            warn("Error en autoplay:", error)
        end

        -- Esperar al siguiente frame
        RunService.RenderStepped:Wait()
    end
end

-- Activar/Desactivar autoplay
MainButton.MouseButton1Click:Connect(function()
    AutoplayEnabled = not AutoplayEnabled
    MainButton.Text = AutoplayEnabled and "Desactivar Auto" or "Activar Auto"
    MainButton.BackgroundColor3 = AutoplayEnabled and 
        Color3.fromRGB(76, 175, 80) or 
        Color3.fromRGB(147, 112, 219)
end)

-- Iniciar el loop principal
coroutine.wrap(AutoplayFunction)()

-- Mensaje de inicio
print("Auto-Player móvil iniciado")
