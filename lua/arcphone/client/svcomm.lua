-- svcomm.lua - Client/Server communications for ARCPhone
-- This file is under copyright.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

local ARCPhone_PingBusy = false
local ARCPhone_PingCallBack = {}
local ARCPhone_PingCount = 1
function ARCPhone.GetStatus(callback)
	if ARCPhone_PingCallBack[1] then
		ARCPhone_PingCount = ARCPhone_PingCount + 1
		ARCPhone_PingCallBack[ARCPhone_PingCount] = callback
	else
		net.Start("arcphone_comm_check")
		net.SendToServer()
		ARCPhone_PingCallBack[1] = callback
	end
end


net.Receive( "arcphone_comm_check", function(length)
	local ready = tobool(net.ReadBit())
	local outdated = tobool(net.ReadBit())
	for k,v in pairs(ARCPhone_PingCallBack) do
		v(ready)
	end
	ARCPhone.Loaded = ready
	ARCPhone.Outdated = outdated
	ARCPhone_PingCallBack = {}
end)
ARCPhone.PhoneSys.Reception = 0
ARCPhone.PhoneSys.Status = ARCPHONE_ERROR_CALL_ENDED
ARCPhone.PhoneSys.CurrentCall = {on = {},pending = {}}

local oldstatus = ARCPHONE_ERROR_CALL_ENDED
net.Receive( "arcphone_comm_status", function(length)
	ARCPhone.PhoneSys.Reception = net.ReadInt(8)
	ARCPhone.PhoneSys.Status = net.ReadInt(ARCPHONE_ERRORBITRATE)
	ARCPhone.PhoneSys.CurrentCall = {}
	ARCPhone.PhoneSys.CurrentCall.on = {}
	ARCPhone.PhoneSys.CurrentCall.pending = {}
	local tab = net.ReadTable()
	for k,v in pairs(tab.on) do
		table.insert(ARCPhone.PhoneSys.CurrentCall.on,v)
	end
	for k,v in pairs(tab.pending) do
		table.insert(ARCPhone.PhoneSys.CurrentCall.pending,v)
	end
	ARCPhone.PhoneSys.CurrentCall = tab
	if oldstatus != ARCPhone.PhoneSys.Status then
		ARCPhone.OnStatusChanged(ARCPhone.PhoneSys.Status)
		oldstatus = ARCPhone.PhoneSys.Status
	end
end)


local msgchunks = {}

net.Receive( "arcphone_comm_text", function(length)
	local succ = net.ReadInt(8)
	local part = net.ReadUInt(32)
	local whole = net.ReadUInt(32)
	local hash = net.ReadString()
	local str = net.ReadString()

	if succ == -1 then
		
		if whole == len then
			if part == ARCPhone.PhoneSys.OutgoingTexts[hash].place then
				ARCPhone.PhoneSys.OutgoingTexts[hash].place = ARCPhone.PhoneSys.OutgoingTexts[hash].place + 1
				MsgN("ARCPhone: Sending Chunk "..ARCPhone.PhoneSys.OutgoingTexts[hash].place.."/"..len.." of text"..hash.." to the server")
				net.Start("arcphone_comm_text")
				net.WriteInt(0,8)
				net.WriteUInt(ARCPhone.PhoneSys.OutgoingTexts[hash].place,32)
				net.WriteUInt(len,32)
				net.WriteString(hash)
				net.WriteString(tostring(ARCPhone.PhoneSys.OutgoingTexts[hash].msg[ARCPhone.PhoneSys.OutgoingTexts[hash].place]))
				net.SendToServer()
			else
				MsgN("ARCPhone: Server mismatched in part")
				net.Start("arcphone_comm_text")
				net.WriteInt(1,8)
				net.WriteUInt(1,32)
				net.WriteUInt(1,32)
				net.WriteString(hash)
				net.WriteString("")
				net.SendToServer()
				ARCPhone.PhoneSys.OutgoingTexts[hash].place = -1
			end
		else
			MsgN("ARCPhone: Server mismatched on whole")
			net.Start("arcphone_comm_text")
			net.WriteInt(1,8)
			net.WriteUInt(1,32)
			net.WriteUInt(1,32)
			net.WriteString(hash)
			net.WriteString("")
			net.SendToServer()
			ARCPhone.PhoneSys.OutgoingTexts[hash].place = -1
		end
	elseif succ == -2 then
		ARCPhone.PhoneSys.OutgoingTexts[hash] = nil
		-- Done sending
	elseif succ == 0 then
		MsgN("ARCPhone: Server sent chunk "..part.."/"..whole.." on text "..hash)
		if part==0 then
			msgchunks[hash] = {}
			msgchunks[hash].prt = 0
			msgchunks[hash].msg = ""
		end
		if part != msgchunks[hash].prt then
			MsgN("ARCPhone: Chuck Mismatch Error. Possibly due to lag. "..hash)
		else
			msgchunks[hash].msg = msgchunks[hash].msg .. str
			if part == whole then
				MsgN(#msgchunks[hash].msg)
				timer.Simple(1,function()
					ARCPhone.PhoneSys:RecieveText(string.Left( msgchunks[hash].msg, 10 ),string.Right( msgchunks[hash].msg, #msgchunks[hash].msg-10 ))
					
					--Done Recieving
					
					msgchunks[hash] = nil
					net.Start("arcphone_comm_text")
					net.WriteInt(-2,8)
					net.WriteUInt(0,32)
					net.WriteUInt(0,32)
					net.WriteString(hash) --Hash
					net.WriteString("") --Number
					net.SendToServer()
					
				end)
			else
				net.Start("arcphone_comm_text")
				net.WriteInt(-1,8)
				net.WriteUInt(part,32)
				net.WriteUInt(whole,32)
				net.WriteString(hash) --Hash
				net.WriteString("") --Number
				net.SendToServer()
				msgchunks[hash].prt = msgchunks[hash].prt + 1
			end
		end
	else
		msgchunks[hash] = nil
		MsgN("ARCPhone: Server sent error on text "..hash)
	end
end)
