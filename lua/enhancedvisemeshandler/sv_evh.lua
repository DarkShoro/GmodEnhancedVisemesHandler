Era_ntstr = "Eradium.MouthMove.Update"

-- starts the networkstring
util.AddNetworkString(Era_ntstr)

-- receive if the player is talking or not
net.Receive(Era_ntstr, function(_,ply)
	-- if they are talking
	local bool = net.ReadBool()
	-- get their volume if they are talking, if they are not default to 0
	local vol = bool and net.ReadFloat() or 0
	-- add them to the speaking player list
	Era_speakingPlys[ply] = bool
	-- set the networked voicevolume
	ply:SetNW2Float("VoiceVolume", vol)
	-- if they are not talking then reset their mouth postion to 0
	if not bool then
		Era_mouthMove(ply, true)
	end
end)

-- we add everyone to this list at this point the localplayer is valid
-- this is only really useful for singleplayer
Era_hAdd("InitPostEntity", function()
	-- if there are already players in the server then add them to the table
	-- we add any new players to the table further down
	local aply = player.GetAll()
	for i = 1, #aply do
		if not Eradium_MouthMove_player_list[aply[i]] then
			Eradium_MouthMove_player_list[aply[i]] = true
			table.insert(Eradium_MouthMove_player_list, aply[i])
		end
	end
end)

-- adding them to local player list, ignoring bots
Era_hAdd("PlayerSpawn", function(ply)
	if ply:IsBot() then return end
	if not Eradium_MouthMove_player_list[ply] then
		table.insert(Eradium_MouthMove_player_list, ply)
	end
	table.insert(Eradium_MouthMove_player_list, ply)
end)

-- removing them to local player list, ignoring bots
Era_hAdd("PlayerDisconnected", function(ply)
	if ply:IsBot() then return end
	Eradium_MouthMove_player_list[ply] = nil
	table.RemoveByValue(Eradium_MouthMove_player_list, ply)
end)
-- we add a serverside think to do the mouth adjustments
-- if we try and do this client side it desyncs and spazzes out
Era_hAdd("Think", function()
	--[[
		interate through the cached player table so we don't have to call player.GetAll() constantly
		the speed diff is small but can add up with more players
	--]]
	for _, ply in ipairs(Eradium_MouthMove_player_list) do
		-- if the player is not speaking then no need to try and do mouth movements
		if Era_speakingPlys[ply] then
			-- do mouth movements
			Era_mouthMove(ply)
		end
	end
end)