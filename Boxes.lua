local TeamCheck = false  -- Set this to false if you don't want to perform team checks

-- Function to create a 2D box with an outline around a player
local function create2DBox(player)
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Size = UDim2.new(0, 100, 0, 100)  -- Adjust the size of the box as needed
            billboardGui.StudsOffset = Vector3.new(0, 3, 0)  -- Offset the box above the player
            billboardGui.Adornee = humanoidRootPart
            billboardGui.AlwaysOnTop = true
            billboardGui.Parent = character

            local outline = Instance.new("Frame")
            outline.Size = UDim2.new(1, 4, 1, 4)  -- Outline size
            outline.Position = UDim2.new(0, -2, 0, -2)
            outline.BackgroundColor3 = Color3.new(0, 0, 0)  -- Black outline color
            outline.BorderSizePixel = 0
            outline.Parent = billboardGui

            local box = Instance.new("Frame")
            box.Size = UDim2.new(1, 0, 1, 0)
            box.Position = UDim2.new(0, 0, 0, 0)
            box.BackgroundColor3 = Color3.new(1, 1, 1)  -- White box color
            box.BorderSizePixel = 0
            box.Parent = outline
        end
    end
end

-- Function to check team
local function isSameTeam(player1, player2)
    if player1.Team and player2.Team then
        return player1.Team == player2.Team
    end
    return false
end

-- Function to handle new player
local function onPlayerAdded(player)
    if not TeamCheck or (TeamCheck and isSameTeam(player, game.Players.LocalPlayer)) then
        create2DBox(player)
    end
    
    player.CharacterAdded:Connect(function()
        if not TeamCheck or (TeamCheck and isSameTeam(player, game.Players.LocalPlayer)) then
            create2DBox(player)
        end
    end)
end

-- Connect the function to existing and new players
for _, player in pairs(game.Players:GetPlayers()) do
    onPlayerAdded(player)
end

game.Players.PlayerAdded:Connect(onPlayerAdded)

-- Handle team change (if required)
if TeamCheck then
    game.Players.PlayerRemoving:Connect(function(player)
        player:GetPropertyChangedSignal("Team"):Connect(function()
            -- Recreate boxes if team changes
            for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                create2DBox(otherPlayer)
            end
        end)
    end)
end
