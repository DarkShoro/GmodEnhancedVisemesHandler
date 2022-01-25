
Era_ntstr = "Eradium.MouthMove.Update"

--Added that back into client to avoid error
function Era_hAdd(hok, func)
	hook.Add(hok, "Eradium.MouthMove.Hook." .. hok, func)
end

-- we use this to send an update to the server if we are talking or not
function updateSpeak(isSpeak)
	-- if we are not speaking then send a false to let the server know we stopped
	if not isSpeak then
		net.Start(Era_ntstr)
		net.WriteBool(false)
		net.SendToServer()
	elseif isSpeak then
	-- if we are talking then send that we are talking
	-- and also send our voice volume
		net.Start(Era_ntstr)
		net.WriteBool(true)
		net.WriteFloat(LocalPlayer():VoiceVolume())
		net.SendToServer()
		Era_mouthMove(LocalPlayer())
	end
end

local speaking = false
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
timer.Create("Eradium.MouthMove.Timer",0.01, 0,function()
	if speaking then
		updateSpeak(true)
	end
end)