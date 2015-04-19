-- hooks.lua - Hooks

-- This file is under copyright.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.
ARCPhone.Loaded = false

hook.Add( "PlayerSay", "ARCPhone Debugone", function( ply, text, public )
	MsgN("ARCPHONE TESTING: PlayerSay("..tostring(ply)",\""..text.."\","..tostring(public)..")")
end )

hook.Add( "OnPlayerChat", "ARCPhone Debugtwo", function( ply, text, teamchat, dead )
	MsgN("ARCPHONE TESTING: OnPlayerChat("..tostring(ply)",\""..text.."\","..tostring(teamchat)..","..tostring(dead)..")")
end )

if CLIENT then
	
	hook.Add("Think","ARCPhone",function()
		if LocalPlayer():GetActiveWeapon().IsDahAwesomePhone then
			if ARCPhone.PhoneSys:GetActiveApp() then
				ARCPhone.PhoneSys:GetActiveApp():Think(phone)
				ARCPhone.PhoneSys:GetActiveApp():ForegroundThink(phone)
			end
		elseif IsValid(LocalPlayer():GetWeapon("weapon_arc_phone")) then
			for k,v in pairs(ARCPhone.Apps) do
				if k != ARCPhone.PhoneSys.ActiveApp then
					v:BackgroundThink()
				end
				v:Think(phone)
			end
			--ARCPhone.PhoneSys:GetActiveApp():BackgroundThink(phone)
		end
		if ARCPhone.PhoneSys then
			for kk,vv in pairs(ARCPhone.PhoneSys.OutgoingTexts) do
				if vv.place == -1 then
					vv.place = 0
					-- Send dummy message
					net.Start("arcphone_comm_text")
					net.WriteInt(0,8)
					net.WriteUInt(0,32)
					net.WriteUInt(#vv.msg,32)
					net.WriteString(kk) --Hash
					net.WriteString(vv.number) --Number
					net.Send(v)
				end
			end
		end
		
	end)
	hook.Add("PostDrawOpaqueRenderables","ARCPhone Theatrics",function()
		if ARCPhone.VideoDisplay then 
			local phone = LocalPlayer():GetWeapon("weapon_arc_phone")
			if IsValid(phone) then
				if phone.WorldModelView && phone.VElements["screen"].draw_func then
					
					for k,v in pairs(ents.FindByClass("prop_physics")) do
						cam.Start3D2D(v:LocalToWorld(Vector(-1.45, 2.535,0.19)),v:GetAngles(),0.02265)
							phone.VElements["screen"].draw_func()
						cam.End3D2D()
					end
				end
			end
		end
	end)
	--[[
	
	]]
else

	hook.Add("PlayerButtonDown","ARCPhoneUp",function(ply,butt)
		if butt == KEY_UP && !ply:GetActiveWeapon().IsDahAwesomePhone then
			local lastwep = ply:GetActiveWeapon():GetClass()
			ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_HOLSTER)
			timer.Simple(0.25,function()
				if !IsValid(ply) then return end
				ply:SelectWeapon( "weapon_arc_phone" )
				if ply:GetActiveWeapon().IsDahAwesomePhone then
					ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW)
					timer.Simple(0.1,function()
						ply:SendLua("ARCPhone.PhoneSys.LastWep = \""..lastwep.."\"")
					end)
				end
			end)
			timer.Simple(0.9,function()
				if IsValid(ply) && ply:IsPlayer() && ply:GetActiveWeapon().IsDahAwesomePhone then
					ply:GetActiveWeapon():SendWeaponAnim( ACT_VM_IDLE )
				end
			end)
		end
	end)

	--ALL HAIL THE ALMISTHJY SKIRLLEX!!YTU!#%&^111


	hook.Add("PlayerCanHearPlayersVoice","ARCPHONEDO THE VOICE SHIZ",function(otherguy,loundmouth)
		if !ARCPhone.Calls then return end
		for k,v in pairs(ARCPhone.Calls) do
			if table.HasValue(v.on,ARCPhone.GetPhoneNumber(otherguy)) && table.HasValue(v.on,ARCPhone.GetPhoneNumber(loundmouth)) then
				return true,false
			end
		end
	end)
	
end

