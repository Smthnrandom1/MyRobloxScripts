local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local OriginalCharacter = player.Chawracter
local OriginalHumanoid = OriginalCharacter:FindFirstChildOfClass("Humanoid")
local OriginalRootPart = OriginalHumanoid.RootPart
local Camera = workspace.CurrentCamera

local ControlTool = Instance.new("Tool")
ControlTool.Name = "ControlTool"
ControlTool.RequiresHandle = false
ControlTool.Parent = player.Backpack

local function UncontrolNpc(NpcRootPart)	
	if UncontrolToolCon then
		UncontrolToolCon:Disconnect()
		UncontrolToolCon = nil
	end

	player.Character = OriginalCharacter
	Camera.CameraSubject = OriginalCharacter

	if OriginalHumanoid:GetState() ~= Enum.HumanoidStateType.Dead then
		OriginalCharacter:PivotTo(NpcRootPart.CFrame + Vector3.new(0,0,5))
	end
end

local function ControlNpc()
	local target = mouse.Target
	if not target then return end

	local char = target.Parent
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	local RootPart = char:FindFirstChild("HumanoidRootPart") or humanoid.RootPart
	if Players:GetPlayerFromCharacter(char) or not humanoid then return end

	player.Character = char
	Camera.CameraSubject = char

	UncontrolTool = Instance.new("Tool")
	UncontrolTool.Name = "Uncontrol"
	UncontrolTool.RequiresHandle = false
	UncontrolTool.Parent = player.Backpack

	UncontrolToolCon = UncontrolTool.Equipped:Connect(UncontrolNpc)

	task.spawn(function()
		repeat 
			OriginalCharacter:PivotTo(RootPart.CFrame * CFrame.Angles(math.rad(0),math.rad(0),math.rad(180)) + Vector3.new(0,-8,0) )
			OriginalRootPart.AssemblyAngularVelocity = Vector3.zero
			OriginalRootPart.AssemblyLinearVelocity = Vector3.zero
			wait()
		until humanoid:GetState() == Enum.HumanoidStateType.Dead or not char:IsDescendantOf(workspace) or OriginalHumanoid:GetState() == Enum.HumanoidStateType.Dead or not OriginalCharacter:IsDescendantOf(workspace) or player.Character == OriginalCharacter

		if UncontrolTool then
			UncontrolTool:Destroy()
		end
		UncontrolNpc(RootPart)
	end)
end

ControlTool.Activated:Connect(ControlNpc)
