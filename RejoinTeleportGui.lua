local G2L = {};

-- StarterGui.TeleportGui (Rejoin)
G2L["1"] = Instance.new("ScreenGui", game:GetService("CoreGui"));
G2L["1"]["Name"] = [[TeleportGui (Rejoin)]];
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;


-- StarterGui.TeleportGui (Rejoin).Frame
G2L["2"] = Instance.new("Frame", G2L["1"]);
G2L["2"]["BorderSizePixel"] = 0;
G2L["2"]["BackgroundColor3"] = Color3.fromRGB(37, 37, 37);
G2L["2"]["Size"] = UDim2.new(0.24729, 0, 0.45545, 0);
G2L["2"]["Position"] = UDim2.new(0.44126, 0, 0.37129, 0);
G2L["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2"]["BackgroundTransparency"] = 0.15;


-- StarterGui.TeleportGui (Rejoin).Frame.UIDragDetector
G2L["3"] = Instance.new("UIDragDetector", G2L["2"]);



-- StarterGui.TeleportGui (Rejoin).Frame.TextBox
G2L["4"] = Instance.new("TextBox", G2L["2"]);
G2L["4"]["BorderSizePixel"] = 0;
G2L["4"]["TextWrapped"] = true;
G2L["4"]["TextSize"] = 26;
G2L["4"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["4"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["4"]["PlaceholderText"] = [[Search]];
G2L["4"]["Size"] = UDim2.new(1, 0, 0.11957, 0);
G2L["4"]["Position"] = UDim2.new(0, 0, 0.17786, 0);
G2L["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["4"]["Text"] = [[]];


-- StarterGui.TeleportGui (Rejoin).Frame.PlayerList
G2L["5"] = Instance.new("ScrollingFrame", G2L["2"]);
G2L["5"]["Active"] = true;
G2L["5"]["BorderSizePixel"] = 0;
G2L["5"]["Name"] = [[PlayerList]];
G2L["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["5"]["Size"] = UDim2.new(1, 0, 0.67935, 0);
G2L["5"]["Position"] = UDim2.new(0, 0, 0.31678, 0);
G2L["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5"]["BackgroundTransparency"] = 1;


-- StarterGui.TeleportGui (Rejoin).Frame.PlayerList.ButtonTemplate
G2L["6"] = Instance.new("TextButton", G2L["5"]);
G2L["6"]["TextWrapped"] = true;
G2L["6"]["BorderSizePixel"] = 0;
G2L["6"]["TextSize"] = 31;
G2L["6"]["TextScaled"] = true;
G2L["6"]["TextColor3"] = Color3.fromRGB(30, 30, 30);
G2L["6"]["BackgroundColor3"] = Color3.fromRGB(183, 183, 183);
G2L["6"]["FontFace"] = Font.new([[rbxasset://fonts/families/PermanentMarker.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["6"]["Size"] = UDim2.new(1, 0, 0.06793, 0);
G2L["6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["6"]["Text"] = [[BlahBlahBlah]];
G2L["6"]["Name"] = [[ButtonTemplate]];


-- StarterGui.TeleportGui (Rejoin).Frame.PlayerList.UIListLayout
G2L["7"] = Instance.new("UIListLayout", G2L["5"]);
G2L["7"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.TeleportGui (Rejoin).Frame.TextLabel
G2L["8"] = Instance.new("TextLabel", G2L["2"]);
G2L["8"]["TextWrapped"] = true;
G2L["8"]["BorderSizePixel"] = 0;
G2L["8"]["TextSize"] = 37;
G2L["8"]["TextScaled"] = true;
G2L["8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["8"]["FontFace"] = Font.new([[rbxasset://fonts/families/PermanentMarker.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["8"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["8"]["BackgroundTransparency"] = 0.5;
G2L["8"]["Size"] = UDim2.new(1, 0, 0.1413, 0);
G2L["8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["8"]["Text"] = [[Teleporter (by SenIns)]];
G2L["8"]["Position"] = UDim2.new(0, 0, -0.00018, 0);


-- StarterGui.TeleportGui (Rejoin).Frame.TextLabel.UIStroke
G2L["9"] = Instance.new("UIStroke", G2L["8"]);
G2L["9"]["Thickness"] = 3;
G2L["9"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.TeleportGui (Rejoin).Frame.UIStroke
G2L["a"] = Instance.new("UIStroke", G2L["2"]);



-- StarterGui.TeleportGui (Rejoin).Frame.UIAspectRatioConstraint
G2L["b"] = Instance.new("UIAspectRatioConstraint", G2L["2"]);
G2L["b"]["DominantAxis"] = Enum.DominantAxis.Height;
G2L["b"]["AspectRatio"] = 0.74457;
G2L["b"]["AspectType"] = Enum.AspectType.ScaleWithParentSize;


-- StarterGui.TeleportGui (Rejoin).LocalScript
G2L["c"] = Instance.new("LocalScript", G2L["1"]);



-- StarterGui.TeleportGui (Rejoin).LocalScript
local function C_c()
	local script = G2L["c"];
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

		local code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/Smthnrandom1/ScriptRepository/refs/heads/main/RejoinTeleportGui.lua'))()"..newline..Cordinates..newline..Orientation..[[ 
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

		setfflag("FFlagEnableQuickGameLaunch", true)
		setfflag("FIntRobloxGuiBlurIntensity", false)
		setfflag("FFlagXTargetMatchmakingOptimizations", true)
		setfflag("FFlagEnableTeleportFastChannel2", true)
		setfflag("FIntLocalPlayerTeleportDelayMillis", false)

		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
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
end
task.spawn(C_c);

return G2L["1"], require;
