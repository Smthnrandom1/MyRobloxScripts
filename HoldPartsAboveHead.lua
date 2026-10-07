local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local lpMouse = lp:GetMouse()
local backpack = lp.Backpack
local character = lp.Character
local humanoid = character.Humanoid
local animator = humanoid.Animator

local R15CarryAnimation = Instance.new("Animation")
R15CarryAnimation.AnimationId = "rbxassetid://135078793551909"

local R15animationTrack = animator:LoadAnimation(R15CarryAnimation)

local sumTool = Instance.new("Tool", backpack)
sumTool.Name = "Click a part!"
sumTool.RequiresHandle = false
sumTool.CanBeDropped = false

local function ungrabPart()
	if BallGrabCon then
		BallGrabCon:Disconnect()
		BallGrabCon = nil
	end

	SelectedPart = nil
	sumTool.Name = "Click a part!"
	
	if target and not target.CanCollide then
		target.CanCollide = true
	end
	
	if bodyPosition then
		bodyPosition:Destroy()
	end
	
	if R15animationTrack.IsPlaying then
		R15animationTrack:Stop()
	end
end

local function grabPart()
	target = lpMouse.Target

	if target and target:IsA("BasePart") and not target.Anchored and not SelectedPart then
		SelectedPart = target
		sumTool.Name = `{target.Name}!`

		if target.CanCollide then
			target.CanCollide = false
		end

		bodyPosition = Instance.new("BodyPosition", target)
		
		if humanoid.RigType == Enum.HumanoidRigType.R15 then
			R15animationTrack:Play()
		end

		BallGrabCon = RunService.RenderStepped:Connect(function()
			--[[if not isnetworkowner(target) then
				ungrabPart()
				return
			end]]

			if character:FindFirstChild("HumanoidRootPart") then
				target.AssemblyLinearVelocity = Vector3.zero
				target.AssemblyAngularVelocity = Vector3.zero
				target.CFrame = character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
				bodyPosition.Position = target.Position
			end
		end)
	end
end

sumTool.Activated:Connect(grabPart)
sumTool.Equipped:Connect(function()
	settings().Physics.AreOwnersShown = true
end)
sumTool.Unequipped:Connect(function()
	ungrabPart()
	settings().Physics.AreOwnersShown = false
end)
