local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local backpack = lp.Backpack

lp.Character:PivotTo(CFrame.new(0, 999999999999999, 0))

task.wait(0.3)

-- drops dropable tools into workspace
for i,v in pairs(backpack:GetChildren()) do
	if v:IsA("Tool") and v.CanBeDropped then
		task.spawn(function()
			v.Parent = lp.Character
			repeat task.wait() until v.Parent ~= backpack
			v.Parent = workspace
		end)
	end
end
