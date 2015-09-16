-- phone_background.lua - background processes while the phone is holstered.

-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright Aritz Beobide-Cardinal 2014,2015 All rights reserved.

local CallingSound
local RingingSound

local NotifSound

function ARCPhone.OnStatusChanged()
	local newstatus = ARCPhone.PhoneSys.Status
	if !ARCPhone.PhoneSys.Booted then return end
	--MsgN("Phone status has been changed to "..ARCPhone.PhoneSys.Status)
	if newstatus == ARCPHONE_ERROR_DIALING then
		if !CallingSound then
			CallingSound = CreateSound( LocalPlayer(), "arcphone/ringback.wav" )
			CallingSound:Play()
		end
	else
		
		if CallingSound then
			CallingSound:ChangeVolume(0,0.1)
			CallingSound:Stop()
			CallingSound = nil
		end
		if IsValid(RingingSound) then
			net.Start("arcphone_ringer")
			net.WriteString("")
			net.SendToServer()
			RingingSound:EnableLooping(false) 
			RingingSound:Stop()
			RingingSound = nil
		end
		--MsgN("NEW STATUS:"..newstatus)
		if newstatus > 0 then
			LocalPlayer():EmitSound("arcphone/errors/"..newstatus..".wav")
			ARCPhone.PhoneSys:AddMsgBox("ARCPhone",ARCPHONE_ERRORSTRINGS[newstatus],"warning")
			if ARCPhone.PhoneSys.ActiveApp == "callscreen" then
				ARCPhone.PhoneSys:OpenApp("dialer")
			end
		elseif newstatus != ARCPHONE_ERROR_RINGING && newstatus != ARCPHONE_NO_ERROR then
			if ARCPhone.PhoneSys.OldStatus <= 0 then
				ARCPhone.PhoneSys:AddMsgBox("ARCPhone",ARCPHONE_ERRORSTRINGS[newstatus],"info")
			end
		end
		
		if newstatus == ARCPHONE_ERROR_RINGING then
			notification.AddLegacy( "You are being called! Press the up arrow key to unlock your phone!", NOTIFY_HINT, 10 ) 
			local lst = ""
			local contactapp = ARCPhone.PhoneSys:GetApp("contacts")
			for k,v in pairs(ARCPhone.PhoneSys.CurrentCall.on) do
				lst = lst.."\n"..contactapp:GetNameFromNumber(v).." ("..v..")"
			end
			ARCPhone.PhoneSys:AddMsgBox("Incoming call","You're recieving a call from:"..lst,"phone",8,function() ARCPhone.PhoneSys:Answer() ARCPhone.PhoneSys:OpenApp("callscreen") end,function() ARCPhone.PhoneSys:HangUp() end,function() ARCPhone.PhoneSys:AddMsgBox("Coming soon!","That feature hasn't been added yet. (You also ignored the call)","info") ARCPhone.PhoneSys:HangUp() end)
			--http://www.aritzcracker.ca/arcphone/ringtones/Reflection.mp3
			--"http://www.aritzcracker.ca/arcphone/ringtones/generic1.mp3"
			net.Start("arcphone_ringer")
			net.WriteString(ARCPhone.PhoneSys.Settings.Ringtones.PhoneCall)
			net.SendToServer()
			sound.PlayURL ( ARCPhone.PhoneSys.Settings.Ringtones.PhoneCall , "noblock", function( station,errid,errstr )
				if IsValid(RingingSound) then
					RingingSound:Stop()
				end
				if ( IsValid( station ) ) then
					RingingSound = station
					RingingSound:SetPos(LocalPlayer():GetPos() )
					RingingSound:Play()
					RingingSound:EnableLooping(true) 
					RingingSound:SetVolume(0.5)
				else
					notification.AddLegacy("Ringtone failed. ("..tostring(errid)..") "..tostring(errstr),NOTIFY_ERROR,5) 
					LocalPlayer():EmitSound("buttons/button8.wav" )
				end
			end)
		end
	end
	hook.Call( "ARCPhone_StatusChanged",nil,newstatus)
end

function ARCPhone.PhoneSys.PlayNotification(snd)
	if isstring(snd) then
		sound.PlayURL ( ARCPhone.PhoneSys.Settings.Ringtones[snd] , "", function( station,errid,errstr )
			if IsValid(NotifSound) then
				NotifSound:Stop()
			end
			if ( IsValid( station ) ) then
				NotifSound = station
				NotifSound:SetPos(LocalPlayer():GetPos() )
				NotifSound:Play()
				NotifSound:SetVolume(0.5)
			else
				notification.AddLegacy("ARCPhone.PhoneSys.Ringtones."..snd.." failed. ("..tostring(errid)..") "..tostring(errstr),NOTIFY_ERROR,5) 
				LocalPlayer():EmitSound("buttons/button8.wav" )
			end
		end)
	end
end