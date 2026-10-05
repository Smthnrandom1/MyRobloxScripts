local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local ScreenGui = script.Parent
local Frame = ScreenGui.Frame
local List = Frame.PlayerList
local ButtonTemp = List.ButtonTemplate

ButtonTemp.Visible = false

local function rejoinTeleportToPlayer(player2)
	local RootPart = player2.Character.HumanoidRootPart
	local newline = "; "
	local comma = ","

	local Cordinates = [[local X,Y,Z = ]]..tostring(RootPart.CFrame.Position.X)..comma..tostring(RootPart.CFrame.Position.Y)..comma..tostring(RootPart.CFrame.Position.Z)
	local Orientation = [[local RX,RY,RZ = ]]..tostring(RootPart.Orientation.X)..comma..tostring(RootPart.Orientation.Y)..comma..tostring(RootPart.Orientation.Z)

	local code = Cordinates..newline..Orientation..[[ 
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    character:WaitForChild("HumanoidRootPart")

    local X, Y, Z = tonumber(X), tonumber(Y), tonumber(Z)
    local RX, RY, RZ = tonumber(RX), tonumber(RY), tonumber(RZ)
    local position = Vector3.new(X,Y,Z)
    local TargetCframe = CFrame.new(position) * CFrame.fromEulerAnglesXYZ(math.rad(RX), math.rad(RY), math.rad(RZ))
    TargetCframe = (TargetCframe + TargetCframe.LookVector * -2)

    character:PivotTo(TargetCframe)
    --print("Rotation:", "RX:", RX, "RY:", RY, "RZ:", RZ)
    --print("Position:", "X:", X, "Y:", Y, "Z:", Z)
]]

	queueonteleport(code)

	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)

	print("done")
end

local function UpdatePlayerList()
	for i,v in pairs(List:GetChildren()) do
		if v:IsA("TextButton") and v.Name ~= "ButtonTemplate" then
			v:Destroy()
		end
	end

	local Players2 = Players:GetPlayers()
	local PlayerList = {}

	for i,v in pairs(Players2) do
		if v == player then continue end
		table.insert(PlayerList, v)
	end

	for i,v in pairs(PlayerList) do
		local Button = ButtonTemp:Clone()
		Button.Name = v.Name.."("..v.DisplayName..")"
		Button.Text = v.Name.."("..v.DisplayName..")"
		Button.Visible = true
		Button.Parent = List

		Button.MouseButton1Click:Connect(function()
			rejoinTeleportToPlayer(v)
		end)
	end 
end

UpdatePlayerList()

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
