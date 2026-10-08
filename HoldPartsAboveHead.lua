local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local lpMouse = lp:GetMouse()
local backpack = lp.Backpack
local character = lp.Character
local humanoid = character.Humanoid
local RootPart = humanoid.RootPart
local animator = humanoid.Animator

local R15CarryAnimation = Instance.new("Animation")
R15CarryAnimation.AnimationId = "rbxassetid://135078793551909"

local R6CarryAnimation = Instance.new("Animation")
R6CarryAnimation.AnimationId = "rbxassetid://180436148"

local R15animationTrack = animator:LoadAnimation(R15CarryAnimation)
local R6animationTrack = animator:LoadAnimation(R6CarryAnimation)

local sumTool = Instance.new("Tool", backpack)
sumTool.Name = "Click a part!"
sumTool.RequiresHandle = false
sumTool.CanBeDropped = false

local function ungrabPart()
	if BallGrabCon then
		BallGrabCon:Disconnect()
		BallGrabCon = nil
	end

	if ThrowPartInputCon then
		ThrowPartInputCon:Disconnect()
		ThrowPartInputCon = nil
	end

	sumTool.Name = "Click a part!"

	if SelectedPart and not SelectedPart.CanCollide then
		SelectedPart.CanCollide = true
	end

	if bodyPosition then
		bodyPosition:Destroy()
		bodyPosition = nil
	end

	if R15animationTrack.IsPlaying then
		R15animationTrack:Stop()
	end

	if R6animationTrack.IsPlaying then
		R6animationTrack:Stop()
	end

	SelectedPart = nil
end

local function ThrowPart(input)
	if input.KeyCode ~= Enum.KeyCode.Q or UserInputService:GetFocusedTextBox() then return end

	if SelectedPart then
		local part = SelectedPart

		ungrabPart()
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		part.AssemblyLinearVelocity = RootPart.CFrame.LookVector * 100
		part.AssemblyAngularVelocity = Vector3.new(0, 100, 0)
	end
end

local function grabPart()
	if SelectedPart then return end
	target = lpMouse.Target

	if target and target:IsA("BasePart") and not target.Anchored then
		SelectedPart = target
		sumTool.Name = `{SelectedPart.Name}!`

		if SelectedPart.CanCollide then
			SelectedPart.CanCollide = false
		end

		bodyPosition = Instance.new("BodyPosition", SelectedPart)

		if humanoid.RigType == Enum.HumanoidRigType.R15 then
			R15animationTrack:Play()
		elseif humanoid.RigType == Enum.HumanoidRigType.R6 then
			R6animationTrack:Play()
			R6animationTrack:AdjustSpeed(0)
		end

		BallGrabCon = RunService.RenderStepped:Connect(function()
			if humanoid.RigType == Enum.HumanoidRigType.R6 then
				for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
					if track ~= R6animationTrack then
						track:Stop()
					end
				end
			end

			if character:FindFirstChild("HumanoidRootPart") then
				SelectedPart.Velocity = Vector3.zero
				SelectedPart.CFrame = character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
				bodyPosition.Position = SelectedPart.Position
			end
		end)

		ThrowPartInputCon = UserInputService.InputEnded:Connect(ThrowPart)
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
