-- a pretty simple teleport tool script

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local lpMouse = lp:GetMouse()

local teleportTool = Instance.new("Tool", lp.Backpack)
teleportTool.Name = "TeleportTool"
teleportTool.RequiresHandle = false

teleportTool.Activated:Connect(function()
	local mousePosition = lpMouse.Hit.Position
	lp.Character:MoveTo(mousePosition)
end)
