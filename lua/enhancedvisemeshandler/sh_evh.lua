-- simple table to add more flex names to
local flexCheck = {
	"jaw_drop",
	"jaw_open",
	"jaw_down",
	"MouthOpen",
	"OpenMouth",
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
	"A",
	"E",
	"O",
	"I",
	"U",
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
Eradium_MouthMove_player_list = Eradium_MouthMove_player_list or {}

-- table of speaking players
Era_speakingPlys = {}

-- not really needed, whatever
-- adds a hook and creates the identifyer on its own
function Era_hAdd(hok, func)
	hook.Add(hok, "Eradium.MouthMove.Hook." .. hok, func)
end

-- the function to do all the mouth movements
-- the "reset" arg is for when the player stops talking and they are removed from the speaking list before their flex is reset
function Era_mouthMove(ply, reset)
	-- if CLIENT then return end
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
			ply:SetFlexWeight(flexID, (not reset and Era_speakingPlys[ply] and math.Clamp(ply:GetNW2Float("VoiceVolume") * 5, 0, 2)) or 0)
			if SERVER then 
				side = "server"
			else
				side = "client"
			end
			print(ply:GetNW2Float("VoiceVolume"), side)
			-- break the loop because we are done here
			break
		end
	end
end
-- this could prob be made faster by caching the model with the flex id so we can refer to that cached table first instead of trying to find the flex id every think call
-- ive done all i feel like doing so i don't really feel like doing more


local updateSpeak