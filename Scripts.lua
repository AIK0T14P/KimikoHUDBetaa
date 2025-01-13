-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
-- Variables principales
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
-- Estado de auto-juego
local autoPlaying = false
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
LoadingText.Text = "Cargando..."
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.TextSize = 18
LoadingText.Parent = LoadingFrame
-- Animación de carga
local loadingTween = TweenService:Create(LoadingFill, TweenInfo.new(3), {Size = UDim2.new(1, 0, 1, 0)})
loadingTween:Play()
loadingTween.Completed:Wait()
-- GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OptimizationGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui
-- Botón para auto-jugar
local AutoPlayButton = Instance.new("TextButton")
AutoPlayButton.Size = UDim2.new(0, 200, 0, 50)
AutoPlayButton.Position = UDim2.new(0.5, -100, 0.5, -25)
AutoPlayButton.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
AutoPlayButton.Text = "Activar AutoJuego"
AutoPlayButton.Parent = ScreenGui
-- Función de auto-juego
local function autoPlay()
autoPlaying = not autoPlaying
AutoPlayButton.Text = autoPlaying and "Desactivar AutoJuego" or "Activar AutoJuego"
if autoPlaying then
while autoPlaying do
-- Simula apretar los botones de juego
-- Las teclas o acciones específicas pueden variar según el juego
UserInputService.InputBegan:Fire("A") -- Ejemplo de apretar 'A'
UserInputService.InputBegan:Fire("F") -- Ejemplo de apretar 'F'
wait(0.5) -- Espera medio segundo antes de la siguiente acción
end
end
end
AutoPlayButton.MouseButton1Click:Connect(autoPlay)
-- Finaliza la carga
LoadingGui:Destroy()
