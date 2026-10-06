local ToolHandles = workspace.Regen:QueryDescendants("Part#Handle")
local head = game:GetService("Players").LocalPlayer.Character.Head

for _,handle in pairs(ToolHandles) do
	if not handle.Parent:IsA("Tool") then continue end
	
	task.spawn(function()
		firetouchinterest(handle, head, 0)
		task.wait(0.1)
		firetouchinterest(handle, head, 1)
	end)
end

print(#ToolHandles)
print("done")
