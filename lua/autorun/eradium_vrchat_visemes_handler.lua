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

if SERVER then
	include("enhancedvisemeshandler/sv_evh.lua")
	include("enhancedvisemeshandler/sh_evh.lua")
	AddCSLuaFile("enhancedvisemeshandler/sh_evh.lua")
	AddCSLuaFile("enhancedvisemeshandler/cl_evh.lua")
else
	include("enhancedvisemeshandler/cl_evh.lua")
	include("enhancedvisemeshandler/sh_evh.lua")
end


print("Visemes Handler Addon Loaded")



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
				print(weight)
	    	    i:SetFlexWeight( v, weight )
                break
            end
	    end
    end
end)
print("reloaded")
--]]
-- hook.Remove("Think", "EradiumMouthMove")