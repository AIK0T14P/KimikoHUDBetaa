local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local AccessStore = DataStoreService:GetDataStore("AccessStore")

local AccessGui = script.Parent
local AccessFrame = AccessGui:WaitForChild("AccessFrame")
local PlayerNameInput = AccessFrame:WaitForChild("PlayerNameInput")
local TimeInput = AccessFrame:WaitForChild("TimeInput")
local AddButton = AccessFrame:WaitForChild("AddButton")
local PlayerList = AccessFrame:WaitForChild("PlayerList")

local AdminUsername = "AIK0T14"

local function updatePlayerList()
    PlayerList:ClearAllChildren()
    for _, player in pairs(Players:GetPlayers()) do
        local accessData = AccessStore:GetAsync(player.UserId)
        if accessData then
            local remainingTime = accessData.endTime - os.time()
            if remainingTime > 0 then
                local playerItem = Instance.new("Frame")
                playerItem.Size = UDim2.new(1, 0, 0, 50)
                playerItem.BackgroundTransparency = 0.5
                
                local playerName = Instance.new("TextLabel")
                playerName.Text = player.Name
                playerName.Size = UDim2.new(0.5, 0, 1, 0)
                playerName.Parent = playerItem
                
                local timeLeft = Instance.new("TextLabel")
                timeLeft.Text = string.format("%d hours, %d minutes", remainingTime // 3600, (remainingTime % 3600) // 60)
                timeLeft.Size = UDim2.new(0.3, 0, 1, 0)
                timeLeft.Position = UDim2.new(0.5, 0, 0, 0)
                timeLeft.Parent = playerItem
                
                local removeButton = Instance.new("TextButton")
                removeButton.Text = "Remove"
                removeButton.Size = UDim2.new(0.2, 0, 1, 0)
                removeButton.Position = UDim2.new(0.8, 0, 0, 0)
                removeButton.Parent = playerItem
                
                removeButton.MouseButton1Click:Connect(function()
                    AccessStore:RemoveAsync(player.UserId)
                    updatePlayerList()
                end)
                
                playerItem.Parent = PlayerList
            end
        end
    end
end

AddButton.MouseButton1Click:Connect(function()
    local playerName = PlayerNameInput.Text
    local accessTime = tonumber(TimeInput.Text)
    
    if playerName and accessTime then
        local player = Players:FindFirstChild(playerName)
        if player then
            local accessData = {
                endTime = os.time() + (accessTime * 3600)
            }
            AccessStore:SetAsync(player.UserId, accessData)
            updatePlayerList()
        end
    end
end)

local function checkAccess(player)
    if player.Name == AdminUsername then
        AccessGui.Enabled = true
        return true
    end
    
    local accessData = AccessStore:GetAsync(player.UserId)
    if accessData then
        local remainingTime = accessData.endTime - os.time()
        if remainingTime > 0 then
            return true
        else
            AccessStore:RemoveAsync(player.UserId)
        end
    end
    
    return false
end

Players.PlayerAdded:Connect(function(player)
    local hasAccess = checkAccess(player)
    
    if not hasAccess then
        local noAccessGui = Instance.new("ScreenGui")
        local noAccessFrame = Instance.new("Frame")
        noAccessFrame.Size = UDim2.new(1, 0, 1, 0)
        noAccessFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        noAccessFrame.BackgroundTransparency = 0.5
        
        local noAccessText = Instance.new("TextLabel")
        noAccessText.Text = "No tienes acceso. Contacta al administrador."
        noAccessText.Size = UDim2.new(1, 0, 1, 0)
        noAccessText.Parent = noAccessFrame
        
        noAccessFrame.Parent = noAccessGui
        noAccessGui.Parent = player:WaitForChild("PlayerGui")
    end
end)

game:BindToClose(function()
    for _, player in pairs(Players:GetPlayers()) do
        local accessData = AccessStore:GetAsync(player.UserId)
        if accessData then
            AccessStore:SetAsync(player.UserId, accessData)
        end
    end
end)

while true do
    updatePlayerList()
    wait(60)  -- Actualiza la lista cada minuto
end
