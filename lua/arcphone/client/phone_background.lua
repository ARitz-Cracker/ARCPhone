-- phone_background.lua - background processes while the phone is holstered.
-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.

local CallingSound
local RingingSound

local NotifSound

function ARCPhone.OnStatusChanged()
	local newstatus = ARCPhone.PhoneSys.Status
	if !ARCPhone.PhoneSys.Booted then return end
	ARCPhone.PhoneSys.CallPending = false
	--MsgN("Phone status has been changed to "..ARCPhone.PhoneSys.Status)
	if newstatus == ARCPHONE_ERROR_DIALING then
		if !CallingSound then
			CallingSound = CreateSound( LocalPlayer(), "arcphone/ringback.wav" )
			CallingSound:PlayEx(0.35,100)
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
			ARCPhone.PhoneSys:AddMsgBox("ARCPhone",ARCPHONE_ERRORSTRINGS[newstatus],"warning-sign")
		elseif newstatus != ARCPHONE_ERROR_RINGING && newstatus != ARCPHONE_NO_ERROR then
			if ARCPhone.PhoneSys.OldStatus <= 0 && ARCPhone.PhoneSys.OldStatus != ARCPHONE_ERROR_RINGING then
				ARCPhone.PhoneSys:AddMsgBox("ARCPhone",ARCPHONE_ERRORSTRINGS[newstatus],"round-info-button")
			end
			if newstatus == ARCPHONE_ERROR_CALL_ENDED && istable(ARCPhone.PhoneSys.MsgBoxs) then
				for i=1,#ARCPhone.PhoneSys.MsgBoxs do
					if ARCPhone.PhoneSys.MsgBoxs[i].Title == "Incoming call" then
						ARCPhone.PhoneSys.MsgBoxs[i].Title = "Missed call!"
						ARCPhone.PhoneSys.MsgBoxs[i].Text = string.Replace( ARCPhone.PhoneSys.MsgBoxs[i].Text, "You're receiving a call from:", "You missed a call from:" )
						ARCPhone.PhoneSys.MsgBoxs[i].Icon = "missed-call-phone-receiver-with-left-arrow"
						ARCPhone.PhoneSys.MsgBoxs[i].Type = 1
						ARCPhone.PhoneSys.MsgBoxs[i].GreenFunc = NULLFUNC
						ARCPhone.PhoneSys.MsgBoxs[i].RedFunc = NULLFUNC
						ARCPhone.PhoneSys.MsgBoxs[i].YellowFunc = NULLFUNC
						break
					end
				end
			end
		end
		
		if newstatus == ARCPHONE_ERROR_RINGING then
			local lst = ""
			local contactapp = ARCPhone.PhoneSys:GetApp("contacts")
			for k,v in pairs(ARCPhone.PhoneSys.CurrentCall.on) do
				lst = lst.."\n"..contactapp:GetNameFromNumber(v).." ("..v..")"
			end
			ARCPhone.PhoneSys:AddMsgBox("Incoming call","You're receiving a call from:"..lst,"phone-working-indicator",8,function() ARCPhone.PhoneSys:Answer() ARCPhone.PhoneSys:OpenApp("dialer") end,function() ARCPhone.PhoneSys:HangUp() end,function() ARCPhone.PhoneSys:OpenApp("messaging"):OpenConvo(ARCPhone.PhoneSys.CurrentCall.on[1]) ARCPhone.PhoneSys:HangUp() end)
			--http://www.aritzcracker.ca/arcphone/ringtones/Reflection.mp3
			--"http://www.aritzcracker.ca/arcphone/ringtones/generic1.mp3"
			net.Start("arcphone_ringer")
			net.WriteString(ARCPhone.PhoneSys.Settings.Ringtones.PhoneCall)
			net.SendToServer()
			ARCLib.PlayCachedURL ( ARCPhone.PhoneSys.Settings.Ringtones.PhoneCall , "noblock", function( station,errid,errstr )
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
					ARCPhone.PhoneSys:AddMsgBox("PlayURL Error","Failed to play ARCPhone.PhoneSys.Ringtones.PhoneCall\n("..tostring(errid)..") "..tostring(errstr),"round-error-symbol")
				end
			end)
		end
	end
	hook.Call( "ARCPhone_StatusChanged",nil,newstatus)
end

function ARCPhone.PhoneSys:PlayNotification(snd)
	if isstring(snd) then
		ARCLib.PlayCachedURL( ARCPhone.PhoneSys.Settings.Ringtones[snd] , "", function( station,errid,errstr )
			if IsValid(NotifSound) then
				NotifSound:Stop()
			end
			if ( IsValid( station ) ) then
				NotifSound = station
				NotifSound:SetPos(LocalPlayer():GetPos() )
				NotifSound:Play()
				NotifSound:SetVolume(0.25)
			else
				ARCPhone.PhoneSys:AddMsgBox("PlayURL Error","Failed to play ARCPhone.PhoneSys.Ringtones."..snd.."\n("..tostring(errid)..") "..tostring(errstr),"round-error-symbol")
			end
		end)
	end
end


local color_white_fade = Color(255,255,255,255)
local color_black_fade = Color(0,0,0,255)
hook.Add( "HUDPaint", "ARCPhone TutorialHud", function()
	
	local xpos
	local xposimg
	local ypos
	local w

	xpos = ScrW() - 96
	
	ypos = ScrH() - 96 - 96 - 8
	
	local s = ARCPhone.PhoneSys.Settings.System
	if ARCPhone.PhoneSys.ControlHints > SysTime() then
		color_white_fade.a = (191 + (math.cos(SysTime()*math.pi*2 + math.pi))*64)*ARCLib.BetweenNumberScaleReverse(ARCPhone.PhoneSys.ControlHints-5,SysTime(),ARCPhone.PhoneSys.ControlHints)
		color_black_fade.a = color_white_fade.a
		w = draw.SimpleTextOutlined( "Use ["..ARCLib.HumanReadableKey(s.KeyUp)..","..ARCLib.HumanReadableKey(s.KeyLeft)..","..ARCLib.HumanReadableKey(s.KeyDown)..","..ARCLib.HumanReadableKey(s.KeyRight).."] to navigate", "ARCPhoneBig", xpos, ypos+16, color_white_fade, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, color_black_fade ) 
		xposimg = xpos - w - 36
		surface.SetMaterial( ARCLib.GetWebIcon32("transform_move") ) 
		surface.SetDrawColor(color_white_fade)
		surface.DrawTexturedRect( xposimg,ypos,32,32 )
		
		ypos = ypos + 36
		w = draw.SimpleTextOutlined( "Press ["..ARCLib.HumanReadableKey(s.KeyEnter).."] to select", "ARCPhoneBig", xpos, ypos+16, color_white_fade, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, color_black_fade ) 
		xposimg = xpos - w - 36
		surface.SetMaterial( ARCLib.GetWebIcon32("mouse_select_left") ) 
		surface.SetDrawColor(color_white_fade)
		surface.DrawTexturedRect( xposimg,ypos,32,32 ) 
		
		ypos = ypos + 36
		w = draw.SimpleTextOutlined( "Press ["..ARCLib.HumanReadableKey(s.KeyContext).."] to view app options", "ARCPhoneBig", xpos, ypos+16, color_white_fade, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, color_black_fade ) 
		xposimg = xpos - w - 36
		surface.SetMaterial( ARCLib.GetWebIcon32("mouse_select_right") ) 
		surface.SetDrawColor(color_white_fade)
		surface.DrawTexturedRect( xposimg,ypos,32,32 )
		
		ypos = ypos + 36
		w = draw.SimpleTextOutlined( "Press ["..ARCLib.HumanReadableKey(s.KeyBack).."] to go back", "ARCPhoneBig", xpos, ypos+16, color_white_fade, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, color_black_fade ) 
		xposimg = xpos - w - 36
		surface.SetMaterial( ARCLib.GetWebIcon32("arrow_left") ) 
		surface.SetDrawColor(color_white_fade)
		surface.DrawTexturedRect( xposimg,ypos,32,32 ) 
	end
	if (ARCPhone.PhoneSys.Status == ARCPHONE_ERROR_RINGING or !ARCPhone.PhoneSys.FirstOpened) and not LocalPlayer():GetActiveWeapon().IsDahAwesomePhone and LocalPlayer():HasWeapon( "weapon_arc_phone" ) then
		xpos = ScrW() - 96
		ypos = ScrH() - 96 - (SysTime()*0.5%1)*96

		color_white_fade.a = (math.cos(SysTime()*math.pi + math.pi)*0.5+0.5)*255
		color_black_fade.a = color_white_fade.a
		surface.SetDrawColor(color_white_fade)
		w = draw.SimpleTextOutlined( "Press ["..ARCLib.HumanReadableKey(s.KeyUp).."] to unlock your phone", "ARCPhoneBig", xpos, ypos+16, color_white_fade, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, color_black_fade ) 
		xpos = xpos - w - 32
		if ARCPhone.PhoneSys.Status == ARCPHONE_ERROR_RINGING then
			surface.SetMaterial( ARCLib.GetWebIcon32("phone_sound") ) 
		else
			surface.SetMaterial( ARCLib.GetWebIcon32("iphone") ) 
		end
		surface.DrawTexturedRect( xpos,ypos,32,32 ) 
		surface.SetMaterial( ARCLib.GetWebIcon32("bullet_up") ) 
		surface.DrawTexturedRect( xpos,ypos,32,32 ) 
	end
end)