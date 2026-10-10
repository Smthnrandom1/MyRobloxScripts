local env = getgenv()

env.IntermissionCd = 20
env.RoundTime = 25

env.HdAdminCmd = function(cmd)
	local event = game:GetService("ReplicatedStorage").HDAdminClient.Signals.RequestCommand
	event:InvokeServer(cmd)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Round toggles
local roundsEnabled = true
local forceEndRound = false
local ignoreMinPlayers = false
_G.forceTagPlayer = nil

-- Chat commands
LocalPlayer.Chatted:Connect(function(msg)
	msg = msg:lower()

	if msg == "/disable" then
		roundsEnabled = false
		env.HdAdminCmd(";h Round system disabled.")
	end

	if msg == "/enable" then
		roundsEnabled = true
		env.HdAdminCmd(";h Round system enabled.")
	end

	if msg == "/end" then
		forceEndRound = true
		env.HdAdminCmd(";h Force-ending round...")
	end

	if msg == "/minoff" then
		ignoreMinPlayers = true
		env.HdAdminCmd(";h Minimum player check disabled.")
	end

	if msg == "/minon" then
		ignoreMinPlayers = false
		env.HdAdminCmd(";h Minimum player check enabled.")
	end

	if msg:sub(1, 5) == "/tag " then
		local name = msg:sub(6)
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr.Name:lower() == name then
				_G.forceTagPlayer = plr
				env.HdAdminCmd(";h Forced tag: " .. plr.Name)
				break
			end
		end
	end
end)

-- SPEED CONTROL
local function setSpeed(player, speed)
	if player.Character then
		local hum = player.Character:FindFirstChildOfClass("Humanoid")
		if hum then env.HdAdminCmd(";speed " .. player.Name .. " " .. speed) end
	end
end

-- JUMP CONTROL
local function setJump(player, power)
	if player.Character then
		local hum = player.Character:FindFirstChildOfClass("Humanoid")
		if hum then env.HdAdminCmd(";jumpPower " .. player.Name .. " " .. power) end
	end
end

-- REMOVE ALL TAGGER BOOSTS
local function removeBoosts(player)
	setSpeed(player, 16)
	setJump(player, 50)
	env.HdAdminCmd(";unsparkles " .. player.Name)
	env.HdAdminCmd(";removehats " .. player.Name)
end

-- APPLY TAGGER BOOSTS
local function applyTaggerBoosts(player)
	setSpeed(player, 30)
	setJump(player, 70)
	env.HdAdminCmd(";sparkles " .. player.Name)
end

-- PICK TAGGER
local function pickTagger(list)
	return list[math.random(1, #list)]
end

-- ANNOUNCE
local function announce(msg)
	env.HdAdminCmd(";h " .. msg)
end

-- DISTANCE TAGGING
local function isTaggedDistance(tagger, target)
	if not tagger.Character or not target.Character then return false end
	local hrp1 = tagger.Character:FindFirstChild("HumanoidRootPart")
	local hrp2 = target.Character:FindFirstChild("HumanoidRootPart")
	if not hrp1 or not hrp2 then return false end
	return (hrp1.Position - hrp2.Position).Magnitude < 5
end

-- TOUCH TAGGING (patched: connection cleanup)
local function connectTouchEvents(tagger, activePlayers, taggedCallback)
    if not tagger.Character then return end

    local char = tagger.Character

    -- Clear old connections
    if char._touchConnections then
        for _, c in ipairs(char._touchConnections) do
            c:Disconnect()
        end
    end
    char._touchConnections = {}

    -- Create new connections
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local conn = part.Touched:Connect(function(hit)
                local otherChar = hit:FindFirstAncestorOfClass("Model")
                if not otherChar then return end

                local otherPlayer = Players:GetPlayerFromCharacter(otherChar)
                if not otherPlayer then return end

                for _, plr in ipairs(activePlayers) do
                    if plr == otherPlayer and plr ~= tagger then
                        taggedCallback(otherPlayer)
                    end
                end
            end)

            table.insert(char._touchConnections, conn)
        end
    end
end


while true do
	if not roundsEnabled then
		task.wait(1)
		continue
	end

	env.HdAdminCmd(";unhighlight all")

	for i = env.IntermissionCd, 1, -1 do
		if not roundsEnabled then break end
		announce("Intermission: " .. i)
		task.wait(1)
	end

	if not roundsEnabled then continue end

	if not ignoreMinPlayers and #Players:GetPlayers() < 2 then
		announce("Not enough players to start a round!")
		task.wait(5)
		continue
	end

	announce("Teleporting players...")
	env.HdAdminCmd(";position all 0 10 0")
	task.wait(1)

	local activePlayers = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		table.insert(activePlayers, plr)
	end

	announce("Starting elimination tag!")
	task.wait(1)
	while #activePlayers > 1 do
		if not roundsEnabled then break end

		-- Pick initial tagger
		local tagger = pickTagger(activePlayers)
		announce(tagger.Name .. " is the tagger!")
		applyTaggerBoosts(tagger)
		env.HdAdminCmd(";highlight " .. tagger.Name .. " red")

		local taggedSomeone = false
		local taggerRemoved = false

		-- Touch tagging
		connectTouchEvents(tagger, activePlayers, function(victim)
			if taggerRemoved then return end
			taggedSomeone = true

			removeBoosts(victim)
			announce(victim.Name .. " was tagged and eliminated!")
			env.HdAdminCmd(";explode " .. victim.Name)
			env.HdAdminCmd(";unhighlight " .. victim.Name)

			for i, p in ipairs(activePlayers) do
				if p == victim then
					table.remove(activePlayers, i)
					break
				end
			end
		end)

		-- Round loop
		for i = env.RoundTime, 1, -1 do
			if not roundsEnabled then break end
			announce("Tag Time: " .. i)

			----------------------------------------------------
			-- Forced tag command
			----------------------------------------------------
			if _G.forceTagPlayer then
				local victim = _G.forceTagPlayer
				_G.forceTagPlayer = nil

				if table.find(activePlayers, victim) then
					announce(victim.Name .. " was force-tagged and eliminated!")
					env.HdAdminCmd(";explode " .. victim.Name)
					env.HdAdminCmd(";unhighlight " .. victim.Name)
					removeBoosts(victim)

					for i, p in ipairs(activePlayers) do
						if p == victim then
							table.remove(activePlayers, i)
							break
						end
					end

					taggedSomeone = true

					-- If tagger was force-tagged → pick new tagger
					if victim == tagger then
						taggerRemoved = true

						if #activePlayers <= 1 then break end

						tagger = pickTagger(activePlayers)
						announce(tagger.Name .. " is the new tagger!")
						applyTaggerBoosts(tagger)
						env.HdAdminCmd(";highlight " .. tagger.Name .. " red")
					end
				end
			end

			----------------------------------------------------
			-- Tagger leaves → pick new tagger
			----------------------------------------------------
			if not Players:FindFirstChild(tagger.Name) then
				taggerRemoved = true
				announce("Tagger left! Selecting a new tagger...")

				for i, p in ipairs(activePlayers) do
					if p == tagger then
						table.remove(activePlayers, i)
						break
					end
				end

				if #activePlayers <= 1 then break end

				tagger = pickTagger(activePlayers)
				announce(tagger.Name .. " is the new tagger!")
				applyTaggerBoosts(tagger)
				env.HdAdminCmd(";highlight " .. tagger.Name .. " red")
			end

			----------------------------------------------------
			-- Tagger dies → pick new tagger
			----------------------------------------------------
			if tagger.Character then
				local hum = tagger.Character:FindFirstChildOfClass("Humanoid")
				if hum and hum.Health <= 0 then
					taggerRemoved = true
					announce("Tagger died! Selecting a new tagger...")

					for i, p in ipairs(activePlayers) do
						if p == tagger then
							table.remove(activePlayers, i)
							break
						end
					end

					if #activePlayers <= 1 then break end

					tagger = pickTagger(activePlayers)
					announce(tagger.Name .. " is the new tagger!")
					applyTaggerBoosts(tagger)
					env.HdAdminCmd(";highlight " .. tagger.Name .. " red")
				end
			end

			----------------------------------------------------
			-- Distance fallback tagging
			----------------------------------------------------
			if not taggedSomeone then
				for _, plr in ipairs(activePlayers) do
					if plr ~= tagger and isTaggedDistance(tagger, plr) then
						taggedSomeone = true

						announce(plr.Name .. " was tagged and eliminated!")
						env.HdAdminCmd(";explode " .. plr.Name)
						env.HdAdminCmd(";unhighlight " .. plr.Name)
						removeBoosts(plr)

						for idx, p in ipairs(activePlayers) do
							if p == plr then
								table.remove(activePlayers, idx)
								break
							end
						end
						break
					end
				end
			end

			if taggedSomeone then break end
			task.wait(1)
		end

		if not roundsEnabled then break end

		----------------------------------------------------
		-- Tagger fails to tag anyone
		----------------------------------------------------
		if not taggedSomeone and not taggerRemoved then
			announce("Tagger " .. tagger.Name .. " failed and is eliminated!")
			env.HdAdminCmd(";explode " .. tagger.Name)
			removeBoosts(tagger)

			for idx, p in ipairs(activePlayers) do
				if p == tagger then
					table.remove(activePlayers, idx)
					break
				end
			end
		end

		env.HdAdminCmd(";unhighlight all")
		task.wait(2)
	end

	----------------------------------------------------
	-- Winner logic
	----------------------------------------------------
	if #activePlayers == 0 then
		announce("No players left. Ending round.")
		env.HdAdminCmd(";reset all")
		env.HdAdminCmd(";unhighlight all")
		forceEndRound = false
		task.wait(5)
		continue
	end

	local winner = activePlayers[1]
	announce(winner.Name .. " is the winner!")
	env.HdAdminCmd(";highlight " .. winner.Name .. " yellow")
	env.HdAdminCmd(";size " .. winner.Name .. " 5")

	task.wait(5)

	----------------------------------------------------
	-- Reset round
	----------------------------------------------------
	announce("Resetting players...")
	env.HdAdminCmd(";reset all")
	env.HdAdminCmd(";size all 1")
	env.HdAdminCmd(";unhighlight all")

	forceEndRound = false
	task.wait(5)
end
