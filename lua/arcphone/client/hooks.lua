-- hooks.lua - Hooks

-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
ARCPhone.Loaded = false


hook.Add("Think","ARCPhone Think",function()
	if !ARCPhone.PhoneSys then return end
	if LocalPlayer():GetActiveWeapon().IsDahAwesomePhone then
		if !ARCPhone.PhoneSys.FirstOpened then
			ARCPhone.PhoneSys.FirstOpened = true
			ARCPhone.PhoneSys.ControlHints = SysTime() + 75
		end
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
		--[[
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
		]]
	end
	--[[
	for k,v in pairs(ARCPhone.PhoneRingers) do
		local ply = Entity(k)
		if IsValid(ply) then
			v:SetPos(ply:GetPos())
		end
	end
	]]
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
