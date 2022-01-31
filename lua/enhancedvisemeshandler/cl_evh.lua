--Added that back into client to avoid error
function Era_hAdd(hok, func)
	hook.Add(hok, "Eradium.MouthMove.Hook." .. hok, func)
end
print("Era_loaded",Era_loaded)
Era_loaded = Era_loaded or false

-- we use this to send an update to the server if we are talking or not
function updateSpeak(isSpeak)
	-- if we are not speaking then send a false to let the server know we stopped
	if not isSpeak then
		net.Start(Era_ntstr)
		net.WriteBool(false)
		net.SendToServer()
		print("Speaking stop")
	elseif isSpeak then
		-- if we are talking then send that we are talking
		-- and also send our voice volume
		net.Start(Era_ntstr)
		net.WriteBool(true)
		local vol = LocalPlayer():VoiceVolume()
		net.WriteFloat(LocalPlayer():VoiceVolume())
		net.SendToServer()
		print("volume client", vol)
		-- Era_mouthMove(LocalPlayer())
	end
end

local speaking
function Era_LoadCL()
	Era_loaded = true
	print("testLoad", string.rep("testasd", 10, "\n"))

	-- adding them to a list of speaking players, don't think bots can speak so no need to check
	Era_hAdd("PlayerStartVoice", function(ply)
		speaking = true
	end)

	-- removing them to a list of speaking players
	Era_hAdd("PlayerEndVoice", function(ply)
		updateSpeak(false)
		speaking = nil
	end)

	-- Create a timer clientside to update the server on our voice volume
	-- we also call this every .01 seconds bcuz calling this every think call is overkill
	timer.Create("Eradium.MouthMove.Timer", 0.01, 0, function()
		if speaking then
			updateSpeak(true)
		end
	end)
	print("era client side loaded")
end

-- we run start these here because LocalPlayer is valid at this point
Era_hAdd("InitPostEntity", Era_LoadCL)

-- if not Era_loaded then
	-- Era_LoadCL()
-- end