--[[
:::::::::: :::::::::      :::     ::::::::: ::::::::::: :::    ::: ::::    ::::  
:+:        :+:    :+:   :+: :+:   :+:    :+:    :+:     :+:    :+: +:+:+: :+:+:+ 
+:+        +:+    +:+  +:+   +:+  +:+    +:+    +:+     +:+    +:+ +:+ +:+:+ +:+ 
+#++:++#   +#++:++#:  +#++:++#++: +#+    +:+    +#+     +#+    +:+ +#+  +:+  +#+ 
+#+        +#+    +#+ +#+     +#+ +#+    +#+    +#+     +#+    +#+ +#+       +#+ 
#+#        #+#    #+# #+#     #+# #+#    #+#    #+#     #+#    #+# #+#       #+# 
########## ###    ### ###     ### ######### ###########  ########  ###       ### 

Visemes Handler Addon

This addon is made as a separate item to try and make VRChat and other Visemes work in garry's mod for mouth movement
this code may overwrite stuff sometimes, but really shouldn't.

If you can read this, and decompiled this addon, --> DO NOT PUT THIS LUA FILE ON A SERVER <-- because support will be interrupted as the file is no longer Workshop maintained
and won't receive automatic updates for the visemes list.

Made for Scoof, my friend.


Original idea by me
Code rewritten by Virtualraptor, thank you a lot ! ^^

]]--

-- simple table to add more flex names to
local flexCheck = {
	"jaw_drop",
	"left_part",
	"right_part",
	"left_mouth_drop",
	"right_mouth_drop",
	"aa",
	"vaa",
	"Jaw",
	"v_aa",
	"a",
	"e",
	"o",
	"i",
	"u",
	"v_a",
	"v_e",
	"v_o",
	"v_i",
	"v_u",
	"va",
	"ve",
	"vo",
	"vi",
	"vu",
	"sil",
	"FF",
	"ss",
	"PP",
	"TH",
	"DD",
	"kk",
	"ch",
	"nn",
	"rr",
	"vsil",
	"vFF",
	"vPP",
	"vTH",
	"vDD",
	"vss",
	"vkk",
	"vch",
	"vnn",
	"vrr",
	"v_sil",
	"v_FF",
	"v_PP",
	"v_TH",
	"v_DD",
	"v_kk",
	"v_ch",
	"v_nn",
	"v_ss",
	"v_rr"
}

-- a cached table of online players
-- calling player.GetAll() constantly in a think hook is not efficient
local player_list = {}

-- table of speaking players
local speakingPlys = {}

-- not really needed, whatever
-- adds a hook and creates the identifyer on its own
local function hAdd(hok, func)
	hook.Add(hok, "Eradium.MouthMove.Hook." .. hok, func)
end

-- the function to do all the mouth movements
-- the "reset" arg is for when the player stops talking and they are removed from the speaking list before their flex is reset
local function mouthMove(ply, reset)
	-- go through the list of flexes to check incrementally
	for i = 1, #flexCheck do
		-- check to see if we have a flexid by name, if we do it will return a number if we do not it will return nil
		local flexID = ply:GetFlexIDByName(flexCheck[i])
		-- if we have a number pass if it is nil it will fail
		if flexID then
			--[[
				Sets the flex weights of the player here
				if we need to reset then set the weight to 0
				if the player is on the speaking list then get their voice volume
			--]]
			ply:SetFlexWeight(flexID, (not reset and speakingPlys[ply] and math.Clamp(ply:VoiceVolume() * 5, 0, 2)) or 0)
			-- break the loop because we are done here
			break
		end
	end
end
-- this could prob be made faster by caching the model with the flex id so we can refer to that cached table first instead of trying to find the flex id every think call
-- ive done all i feel like doing so i don't really feel like doing more

-- listen for player connections and disconnections so we can cache them in the local table
gameevent.Listen("player_spawn")
gameevent.Listen("player_disconnect")

-- we add everyone to this list at this point the localplayer is valid
hAdd("InitPostEntity", function()
	-- if there are already players in the server then add them to the table
	-- we add any new players to the table further down
	local aply = player.GetAll()
	for i = 1, #aply do
		table.insert(player_list, aply[i])
	end
end)

-- adding them to local player list, ignoring bots
hAdd("PlayerSpawn", function(ply)
	if ply:IsBot() then return end
	table.insert(player_list, ply)
end)

-- removing them to local player list, ignoring bots
hAdd("PlayerDisconnected", function(ply)
	if ply:IsBot() then return end
	table.RemoveByValue(player_list, ply)
end)

-- adding them to a list of speaking players, don't think bots can speak so no need to check
hAdd("PlayerStartVoice", function(ply)
	speakingPlys[ply] = true
end)

-- removing them to a list of speaking players
hAdd("PlayerEndVoice", function(ply)
	mouthMove(ply, true)
	speakingPlys[ply] = nil
end)

--[[
	go through the cached player table so we don't have to call player.GetAll() constantly
	the speed diff is small but can add up with more players
--]]
hAdd("Think", function()
	-- interate through the table of players
	for _, ply in ipairs(player_list) do
		-- if the player is not speaking then no need to try and do mouth movements
		if speakingPlys[ply] then
			-- do mouth movements
			mouthMove(ply)
		end
	end
end)





--[[ LEGACY CODE I WROTE

-- This is the function the game will handle as the mouth mouvement
hook.Add( "Think", "EradiumMouthMove", function()
    for _, i in pairs(player.GetAll()) do
        -- Define the voice to 0 to avoid error spamming
         voice = 0
        -- The client send it's voice volume to the server
        if CLIENT then i:SetNWFloat("Voice", i:VoiceVolume()) end
        -- Getting the player voice volume server side
        voice = i:GetNWFloat("Voice")
        -- Getting the volume and therefor how far to move the flex
        local weight = i:IsSpeaking() && math.Clamp( voice * 5, 0, 2 ) || 0
        -- This is the flexes list, the one the function will search by in order to make the mouth move
        local flexes = {
           -- Those are the flexes used for mouth speaking, default gmod visemes flexs are untouched
            i:GetFlexIDByName( "jaw_drop" ),
            i:GetFlexIDByName( "left_part" ),
            i:GetFlexIDByName( "right_part" ),
            i:GetFlexIDByName( "left_mouth_drop" ),
            i:GetFlexIDByName( "right_mouth_drop" ),
            i:GetFlexIDByName( "aa" ),
            i:GetFlexIDByName( "vaa" ),
            i:GetFlexIDByName( "Jaw" ),
            i:GetFlexIDByName( "v_aa" ),
            i:GetFlexIDByName( "a" ),
            i:GetFlexIDByName( "e" ),
            i:GetFlexIDByName( "o" ),
            i:GetFlexIDByName( "i" ),
            i:GetFlexIDByName( "u" ),
            i:GetFlexIDByName( "v_a" ),
            i:GetFlexIDByName( "v_e" ),
            i:GetFlexIDByName( "v_o" ),
            i:GetFlexIDByName( "v_i" ),
            i:GetFlexIDByName( "v_u" ),
            i:GetFlexIDByName( "va" ),
            i:GetFlexIDByName( "ve" ),
            i:GetFlexIDByName( "vo" ),
            i:GetFlexIDByName( "vi" ),
            i:GetFlexIDByName( "vu" ),
            i:GetFlexIDByName( "sil" ),
            i:GetFlexIDByName( "FF" ),
            i:GetFlexIDByName( "ss" ),
            i:GetFlexIDByName( "PP" ),
            i:GetFlexIDByName( "TH" ),
            i:GetFlexIDByName( "DD" ),
            i:GetFlexIDByName( "kk" ),
            i:GetFlexIDByName( "ch" ),
            i:GetFlexIDByName( "nn" ),
            i:GetFlexIDByName( "rr" ),
            i:GetFlexIDByName( "vsil" ),
            i:GetFlexIDByName( "vFF" ),
            i:GetFlexIDByName( "vPP" ),
            i:GetFlexIDByName( "vTH" ),
            i:GetFlexIDByName( "vDD" ),
            i:GetFlexIDByName( "vss" ),
            i:GetFlexIDByName( "vkk" ),
            i:GetFlexIDByName( "vch" ),
            i:GetFlexIDByName( "vnn" ),
            i:GetFlexIDByName( "vrr" ),
            i:GetFlexIDByName( "v_sil" ),
            i:GetFlexIDByName( "v_FF" ),
            i:GetFlexIDByName( "v_PP" ),
            i:GetFlexIDByName( "v_TH" ),
            i:GetFlexIDByName( "v_DD" ),
            i:GetFlexIDByName( "v_kk" ),
            i:GetFlexIDByName( "v_ch" ),
            i:GetFlexIDByName( "v_nn" ),
            i:GetFlexIDByName( "v_ss" ),
            i:GetFlexIDByName( "v_rr" ),
        }
        -- Loop trough the table to see if they are valid, once a valid flex is found, it will be used as the mouth flex
	    for k, v in pairs( flexes ) do
            if v == nil then continue else 
	    	    i:SetFlexWeight( v, weight )
                break
            end
	    end
    end
end)
print("reloaded")

]]--