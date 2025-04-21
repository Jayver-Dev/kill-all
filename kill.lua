return function(Value)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Username = Value

    local function RemoveSpaces(String)
        return String:gsub("%s+", "") or String
    end

    local function FindPlayer(String)
        String = RemoveSpaces(String)
        for _, _Player in pairs(Players:GetPlayers()) do
            if _Player.Name:lower():match("^" .. String:lower()) then
                return _Player
            end
        end
        return nil
    end

    local Target = FindPlayer(Username)
    if Target and Target.Character then
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local Torso = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")

        local savepos = Character:FindFirstChild("HumanoidRootPart").CFrame
        Torso.Anchored = true

        local tool = Instance.new("Tool", LocalPlayer.Backpack)
        local hat = Character:FindFirstChildOfClass("Accessory")
        local hathandle = hat and hat:FindFirstChild("Handle")
        if not hathandle then
            warn("No valid hat or handle found.")
            return
        end

        hathandle.Parent = tool
        hathandle.Massless = true
        tool.GripPos = Vector3.new(0, 9e99, 0)
        tool.Parent = Character

        repeat wait() until Character:FindFirstChildOfClass("Tool") ~= nil
        tool.Grip = CFrame.new(Vector3.new(0, 0, 0))
        Torso.Anchored = false

        repeat
            Character:FindFirstChild("HumanoidRootPart").CFrame = Target.Character:FindFirstChild("HumanoidRootPart").CFrame
            wait()
        until
            not Target.Character
            or Target.Character:FindFirstChild("Humanoid").Health <= 0
            or not Character
            or Character:FindFirstChild("Humanoid").Health <= 0
            or (Target.Character:FindFirstChild("HumanoidRootPart").Velocity.Magnitude - Target.Character:FindFirstChild("Humanoid").WalkSpeed)
                > (Target.Character:FindFirstChild("Humanoid").WalkSpeed + 20)

        Character:FindFirstChild("Humanoid"):UnequipTools()
        hathandle.Parent = hat
        hathandle.Massless = false
        tool:Destroy()

        Character:FindFirstChild("HumanoidRootPart").CFrame = savepos
    else
        warn("No player found with that name or they have no character.")
    end
end
