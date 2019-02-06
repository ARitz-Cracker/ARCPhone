-- hooks.lua - Hooks

-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
ARCPhone.Loaded = false


hook.Add( "ARCLib_OnPlayerFullyLoaded", "ARCPhone PlyAuth", function( ply ) 
	if IsValid(ply) && ply:IsPlayer() then
		net.Start("arcphone_emerg_numbers")
		local len = 0
		for k,v in pairs(ARCPhone.SpecialSettings.EmergencyNumbers) do
			len = len + 1
		end
		net.WriteUInt(len,8)
		for k,v in pairs(ARCPhone.SpecialSettings.EmergencyNumbers) do
			net.WriteString(k)
		end
		net.Send(ply)
		if ply:SteamID64() == "76561197997486016" then
			net.Start("arclib_thankyou")
			net.Send(ply)
		end
		net.Start("arcphone_nutscript_number")
		net.WriteUInt(ARCPhone.NumberStart,23)
		net.Send(ply)
	end
end)

hook.Add("PlayerButtonDown","ARCPhone UnlockPhone",function(ply,butt)
	if butt == (ply._ARCPhoneUnlockKey or KEY_UP) and not ply:GetActiveWeapon().IsDahAwesomePhone and IsValid(ply:GetWeapon( "weapon_arc_phone" )) then
		local lastwep = ply:GetActiveWeapon():GetClass()
		ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_HOLSTER)
		timer.Simple(0.1,function()
			if !IsValid(ply) then return end
			ply:SelectWeapon( "weapon_arc_phone" )
				timer.Simple(0.1,function()
					if ply:GetActiveWeapon().IsDahAwesomePhone then
						ply:SendLua("ARCPhone.PhoneSys.LastWep = \""..lastwep.."\"")
					end
				end)
		end)
	end
end)

local maxChatDist = 1000^2
hook.Add( "Initialize", "ARCPhone Overrides", function()
	local GAMEMODE_PlayerCanHearPlayersVoice = GAMEMODE.PlayerCanHearPlayersVoice

	GAMEMODE.PlayerCanHearPlayersVoice = function(gm,otherguy,loudMouth)
		if !ARCPhone.Calls then return end
		for k,v in pairs(ARCPhone.Calls) do
			if table.HasValue(v.on,ARCPhone.GetPhoneNumber(otherguy)) && table.HasValue(v.on,ARCPhone.GetPhoneNumber(loudMouth)) then
				return true,false
			end
		end
		if ARCPhone.Settings.override_voice_chat then
			if otherguy:GetPos():DistToSqr(loudMouth:GetPos()) < maxChatDist then
				return true,true
			else
				return false,false
			end
		end
		return GAMEMODE_PlayerCanHearPlayersVoice(gm,otherguy,loudMouth)
	end
	GAMEMODE_PlayerCanSeePlayersChat = GAMEMODE.PlayerCanSeePlayersChat
	
	GAMEMODE.PlayerCanSeePlayersChat = function(gm, text, teamOnly, otherguy, speaker)
		if ARCPhone.Settings.override_text_chat and otherguy:GetPos():DistToSqr(loudMouth:GetPos()) < maxChatDist then
			if not teamOnly or otherguy:Team() == speaker:Team() then
				return true
			else
				return false
			end
		else
			return GAMEMODE_PlayerCanSeePlayersChat(gm, text, teamOnly, otherguy, speaker)
		end
	end
end )


hook.Add( "PlayerSay", "ARCPhone CallText", function( loudMouth, text, t )
	if !ARCPhone.Calls then return end
	for k,v in pairs(ARCPhone.Calls) do
		for _,otherguy in pairs(player.GetAll()) do
			if table.HasValue(v.on,ARCPhone.GetPhoneNumber(otherguy)) && table.HasValue(v.on,ARCPhone.GetPhoneNumber(loudMouth)) && otherguy != loudMouth then
				otherguy:PrintMessage( HUD_PRINTTALK, "(Phone Call) "..loudMouth:Nick()..": "..text)
			end
		end
	end
end )

hook.Add( "PlayerDisconnected", "ARCPhone PlayerDisconnect", function(ply) 
	net.Start("arcphone_ringer")
	net.WriteUInt( 0, 16 )
	net.WriteString("")
	net.SendOmit(ply)
end)

hook.Add( "ShutDown", "ARCPhone Shutdown", function()
	for _, oldatms in pairs( ents.FindByClass("sent_arc_phone_antenna") ) do
		oldatms.ARCPhone_MapEntity = false
		--oldatms:Remove()
	end
	ARCPhone.SaveDisk()
end)



hook.Add( "CanTool", "ARCPhone Tool", function( ply, tr, tool )
	if IsValid(tr.Entity) then -- Overrides shitty FPP
		if tr.Entity.ARCPhone_MapEntity then return false end 
	end
end)
hook.Add( "CanPlayerUnfreeze", "ARCPhone BlockUnfreeze", function( ply, ent, phys )
	if ent.ARCPhone_MapEntity then return false end 
end )
hook.Add( "CanProperty", "ARCPhone BlockProperties", function( ply, property, ent )
	if ent.ARCPhone_MapEntity then return false end 
end )
hook.Add( "PhysgunPickup", "ARCPhone NoPhys", function( ply, ent ) 
	if ent.ARCPhone_MapEntity then return false end 
end)
