-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
local maxmsglen = 8000*255
function ARCPhone.PhoneSys:SendText(number,message,app)
	if message == "" then message = " " end
	if not app then
		local fil = ARCPhone.ROOTDIR.."/messaging/"..number..".txt"
		if file.Exists(fil,"DATA") then
			file.Append(fil,"\fs\v"..os.time().."\v"..message)
		else
			file.Write(fil,"s\v"..os.time().."\v"..message)
		end
	end
	local matches = {string.gmatch(message, "({{IMG%\"([^%\"]*)%\"IMG}})")()} --WHY DOES string.gmatch RETURN A FUNCTION INSTEAD OF A TABLE? WHY DO I HAVE TO CALL THAT FUNCTION TO MAKE A TABLE MYSELF?!
	while #matches > 0 do
		local imgdata = file.Read(ARCPhone.ROOTDIR.."/photos/"..matches[2],"DATA")
		message = string.Replace(message, matches[1], "{{IMGDATA\""..ARCLib.basexx.to_z85(imgdata..string.rep( "\0", -(#imgdata%4-4) )).."\"IMGDATA}}")
		matches = {string.gmatch(message, "({{IMG%\"([^%\"]*)%\"IMG}})")()}
	end
	message = number.."\v"..message
	if #message > maxmsglen then
		if not app then
			self:AddMsgBox("Text too long","The size limit for a message is 1.95MiB or 1.56MiB if the message contains an image.","report-symbol")
		end
		return false
	end
	
	local SendMessageCB 
	SendMessageCB = function(err,per)
		if err == ARCLib.NET_UPLOADING then
			MsgN("TODO: ARCPhone text sending progress icon")
		elseif err == ARCLib.NET_COMPLETE then
			MsgN("TODO: ARCPhone text sending complete??")
		else
			ARCPhone.Msg("Sending message error! "..err)
			ARCLib.SendBigMessage("arcphone_comm_text",message,nil,SendMessageCB) 
		end
	end
	ARCLib.SendBigMessage("arcphone_comm_text",message,nil,SendMessageCB) 
	return true
end
function ARCPhone.PhoneSys:ReceiveText(number,timestamp,message)
	local matches = {string.gmatch(message, "({{IMGDATA%\"([^%\"]*)%\"IMGDATA}})")()} --WHY DOES string.gmatch RETURN A FUNCTION INSTEAD OF A TABLE? WHY DO I HAVE TO CALL THAT FUNCTION TO MAKE A TABLE MYSELF?!
	local i = 1
	while #matches > 0 do
		local imgname = "texts/"..number.."_"..i..".photo.jpg"
		while file.Exists(ARCPhone.ROOTDIR.."/photos/"..imgname,"DATA") do
			i = i + 1
			imgname = "texts/"..number.."_"..i..".photo.jpg"
		end
		MsgN("Saving text image to "..ARCPhone.ROOTDIR.."/photos/"..imgname)
		file.Write(ARCPhone.ROOTDIR.."/photos/"..imgname,ARCLib.basexx.from_z85(matches[2]))
		message = string.Replace(message, matches[1], "{{IMG\""..imgname.."\"IMG}}")
		matches = {string.gmatch(message, "({{IMGDATA%\"([^%\"]*)%\"IMGDATA}})")()}
	end
	if string.sub( number, 1, 3 ) == "000" then
		if istable(self.TextApps[number]) then
			self.TextApps[number]:OnText(timestamp,message)
		else
			self:AddMsgBox("ERROR","This phone received a text from "..number.." but there is no app associated with that number.","report-symbol")
		end
	else
		local fil = ARCPhone.ROOTDIR.."/messaging/"..number..".txt"
		if file.Exists(fil,"DATA") then
			file.Append(fil,"\fr\v"..timestamp.."\v"..message)
		else
			file.Write(fil,"r\v"..timestamp.."\v"..message)
		end
		
		local app = self:GetActiveApp()
		if app.sysname == "messaging" && app.OpenNumber == number then
			--app:OpenConvo(number)
			app:UpdateCurrentConvo(timestamp,message,false)
		else
			local name = number
			local contactapp = self:GetApp("contacts")
			if contactapp then
				name = contactapp:GetNameFromNumber(number)
			end
			self:AddMsgBox("New Message","New Message from "..name.." ("..number..")","sms-speech-bubble",ARCPHONE_MSGBOX_REPLY,function()
				app = self:OpenApp("messaging")
				app:OpenConvo(number)
			end)
		end
		self:PlayNotification("TextMsg")
	end
end
function ARCPhone.PhoneSys:Call(number)
	if !ARCPhone.IsValidPhoneNumber(number) then
		self:AddMsgBox("ARCPhone","Invalid number.","report-symbol")
	else
		if self.Status != ARCPHONE_ERROR_CALL_ENDED then
			self:AddMsgBox("ARCPhone","A call is already in progress","report-symbol")
		else
			ARCPhone.PhoneSys.CallPending = true
			net.Start("arcphone_comm_call")
			net.WriteInt(1,8)
			net.WriteString(number)
			net.SendToServer()
			if (self:AppExists("dialer")) then
				self:OpenApp("dialer"):CallScreen()
			end
			
		end
	end
end
function ARCPhone.PhoneSys:Answer()
	if self.Status == ARCPHONE_ERROR_RINGING then
		net.Start("arcphone_comm_call")
		net.WriteInt(2,8)
		net.SendToServer()
	else
		self:AddMsgBox("ARCPhone","Cannot answer while not ringing","report-symbol")
	end
end
function ARCPhone.PhoneSys:GroupCall(tabonumbers)
	local number = #tabonumbers
	if number > 127 then
		self:AddMsgBox("ARCPhone","Too many numbers.","report-symbol")
	elseif number > 1 then
		net.Start("arcphone_comm_call")
		net.WriteInt(number*-1,8)
		for i = 1,number do
			if ARCPhone.IsValidPhoneNumber(tabonumbers[i]) then
				self:AddMsgBox("ARCPhone","Number "..i.." is invalid.","warning-sign")
			else
				net.WriteString(tabonumbers[i])
			end
		end
		net.SendToServer()
	else
		self:AddMsgBox("ARCPhone","Not enough numbers.","error")
		self:Print("Not enough numbers.")
	end
end

function ARCPhone.PhoneSys:AddToCall(number)
	if ARCPhone.IsValidPhoneNumber(number) then
		if ARCPhone.PhoneSys.Status != ARCPHONE_ERROR_NONE then
			self:AddMsgBox("ARCPhone","No call running or call has not been established.","report-symbol")
		else
			net.Start("arcphone_comm_call")
			net.WriteInt(4,8)
			net.WriteString(number)
			net.SendToServer()

			if (self:AppExists("dialer")) then
				self:OpenApp("dialer")
			--else
				--self:AddMsgBox("ARCPhone","The call progress screen doesn't seem to be installed! This means you cannot end your call in a nice GUI fasion!","cross")
			end
		end
	else
		self:AddMsgBox("ARCPhone","A phone number can only contain the following characters: 0-9 # *\nThe number must be 10 digits long or an emergency number.","report-symbol")
	end
end
function ARCPhone.PhoneSys:HangUp()
	net.Start("arcphone_comm_call")
	net.WriteInt(3,8)
	net.SendToServer()
end
