local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local lpMouse = lp:GetMouse()
local backpack = lp.Backpack
local character = lp.Character
local humanoid = character.Humanoid
local RootPart = character.HumanoidRootPart
local animator = humanoid.Animator
local toolname = "Click on a ball!"

local R15KickAnim = Instance.new("Animation")
R15KickAnim.AnimationId = "rbxassetid://111738020671830"

local R15animtrack = animator:LoadAnimation(R15KickAnim)

local sumTool = Instance.new("Tool", backpack)
sumTool.Name = toolname
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
    
    	sumTool.Name = toolname
    
    	if SelectedPart and not SelectedPart.CanCollide then
        		SelectedPart.CanCollide = true
    	end
    
    	if bodyPosition then
        		bodyPosition:Destroy()
        		bodyPosition = nil
    	end

    	SelectedPart = nil
end

local function ThrowPart(input)
    	if input.KeyCode ~= Enum.KeyCode.Q or UserInputService:GetFocusedTextBox() then return end
    
    	if SelectedPart then
        		local part = SelectedPart
        
                R15animtrack:Play()
                repeat wait() until not R15animtrack.IsPlaying
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        		ungrabPart()
        		part.AssemblyLinearVelocity = RootPart.CFrame.LookVector * 100
        		part.AssemblyAngularVelocity = Vector3.new(0, 100, 0)
    	end
end

local function grabPart()
    	if SelectedPart then return end
    	target = lpMouse.Target
    
    	if target and target:IsA("BasePart") and not target.Anchored then
        		SelectedPart = target
        		sumTool.Name = `Current Ball: {SelectedPart.Name}!`
        
        		if SelectedPart.CanCollide then
            			SelectedPart.CanCollide = false
        		end
        
        		bodyPosition = Instance.new("BodyPosition", SelectedPart)
        

        
        		BallGrabCon = RunService.RenderStepped:Connect(function()
            			if character:FindFirstChild("HumanoidRootPart") then
                				SelectedPart.Velocity = Vector3.zero
                				SelectedPart.CFrame = (character.HumanoidRootPart.CFrame + character.HumanoidRootPart.CFrame.LookVector * 2 + character.HumanoidRootPart.CFrame.UpVector * -2)
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
