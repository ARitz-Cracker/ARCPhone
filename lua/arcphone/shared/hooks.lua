-- hooks.lua - Hooks

-- This file is under copyright.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.
ARCPhone.Loaded = false


--[[
hook.Add( "OnPlayerChat", "ARCPhone Debugtwo", function( ply, text, teamchat, dead )
	MsgN("ARCPHONE TESTING: OnPlayerChat("..tostring(ply)..",\""..text.."\","..tostring(teamchat)..","..tostring(dead)..")")
end )
]]
if CLIENT then
	
	hook.Add("Think","ARCPhone Think",function()
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
					net.WriteUInt(0,32)
					net.SendToServer()
				end
			end
		end
		
		for k,v in pairs(ARCPhone.PhoneRingers) do
			local ply = Entity(k)
			if IsValid(ply) then
				v:SetPos(ply:GetPos())
			end
		end
	end)
	
	hook.Add( "StartChat", "ARCPhone OpenChat", function(t) 
		ARCPhone.PhoneSys.PauseInput = true
		timer.Simple(0.1,function()
			ARCPhone.PhoneSys.PauseInput = true
		end)
		timer.Simple(0.2,function()
			ARCPhone.PhoneSys.PauseInput = true
		end)
		timer.Simple(0.3,function()
			ARCPhone.PhoneSys.PauseInput = true
		end)
		timer.Simple(0.4,function()
			ARCPhone.PhoneSys.PauseInput = true
		end)
	end)
	hook.Add( "FinishChat", "ARCPhone CloseChat", function(t) 
		timer.Simple(0.5,function()
			ARCPhone.PhoneSys.PauseInput = false
		end)
	end)
	

	
	--[[
	
	]]
else

	hook.Add("PlayerButtonDown","ARCPhone UnlockPhone",function(ply,butt)
		if butt == KEY_UP && !ply:GetActiveWeapon().IsDahAwesomePhone && IsValid(ply:GetWeapon( "weapon_arc_phone" )) then
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

	--ALL HAIL THE ALMISTHJY SKIRLLEX!!YTU!#%&^111


	hook.Add("PlayerCanHearPlayersVoice","ARCPhone CallAudio",function(otherguy,loundmouth)
		if !ARCPhone.Calls then return end
		for k,v in pairs(ARCPhone.Calls) do
			if table.HasValue(v.on,ARCPhone.GetPhoneNumber(otherguy)) && table.HasValue(v.on,ARCPhone.GetPhoneNumber(loundmouth)) then
				return true,false
			end
		end
	end)
	
	hook.Add( "PlayerSay", "ARCPhone CallText", function( loundmouth, text, t )
		if !ARCPhone.Calls then return end
		for k,v in pairs(ARCPhone.Calls) do
			for _,otherguy in pairs(player.GetAll()) do
				if table.HasValue(v.on,ARCPhone.GetPhoneNumber(otherguy)) && table.HasValue(v.on,ARCPhone.GetPhoneNumber(loundmouth)) && otherguy != loundmouth then
					otherguy:PrintMessage( HUD_PRINTTALK, "(Phone Call) "..loundmouth:Nick()..": "..text)
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
end
