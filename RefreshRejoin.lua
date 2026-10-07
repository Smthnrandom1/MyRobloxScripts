local TeleportService = game:GetService("TeleportService")
local player = game:GetService("Players").LocalPlayer
local RootPart = player.Character.HumanoidRootPart
local newline = "; "
local comma = ","

local Cordinates = [[local X,Y,Z = ]]..tostring(RootPart.CFrame.Position.X)..comma..tostring(RootPart.CFrame.Position.Y)..comma..tostring(RootPart.CFrame.Position.Z)
local Orientation = [[local RX,RY,RZ = ]]..tostring(RootPart.Orientation.X)..comma..tostring(RootPart.Orientation.Y)..comma..tostring(RootPart.Orientation.Z)

local code = Cordinates..newline..Orientation..[[ 
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    character:WaitForChild("HumanoidRootPart")


    local position = Vector3.new(X,Y,Z)
    local TargetCframe = CFrame.new(position) * CFrame.fromEulerAnglesXYZ(math.rad(RX), math.rad(RY), math.rad(RZ))

    character:PivotTo(TargetCframe)
    --print("Rotation:", "RX:", RX, "RY:", RY, "RZ:", RZ)
    --print("Position:", "X:", X, "Y:", Y, "Z:", Z)
]]

queueonteleport(code)

TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)

print("done")
