-- svcomm.lua - Client/Server communications for ARCPhone

-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016 Aritz Beobide-Cardinal All rights reserved.

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
ARCPhone.PhoneSys.OldStatus = ARCPHONE_ERROR_CALL_ENDED
ARCPhone.PhoneSys.Status = ARCPHONE_ERROR_CALL_ENDED
ARCPhone.PhoneSys.CurrentCall = {on = {},pending = {}}

net.Receive( "arcphone_comm_status", function(length)
	ARCPhone.PhoneSys.Reception = net.ReadInt(8)
	ARCPhone.PhoneSys.Status = net.ReadInt(ARCPHONE_ERRORBITRATE)
	table.Empty(ARCPhone.PhoneSys.CurrentCall.on)
	local tab = net.ReadTable()
	for k,v in pairs(tab.on) do
		if v != ARCPhone.GetPhoneNumber(LocalPlayer()) then
			table.insert(ARCPhone.PhoneSys.CurrentCall.on,v)
		end
	end
	table.Empty(ARCPhone.PhoneSys.CurrentCall.pending)
	for k,v in pairs(tab.pending) do
		if v != ARCPhone.GetPhoneNumber(LocalPlayer()) then
			table.insert(ARCPhone.PhoneSys.CurrentCall.pending,v)
		end
	end
	if ARCPhone.PhoneSys.OldStatus != ARCPhone.PhoneSys.Status then
		ARCPhone.OnStatusChanged()
		ARCPhone.PhoneSys.OldStatus = ARCPhone.PhoneSys.Status
	end
	local app = ARCPhone.PhoneSys:GetActiveApp()
	if (app) then
		if app.sysname == "callscreen" then
			app:UpdateCallList()
		end
	end
end)


--ARCLib.SendBigMessage("arcphone_comm_text","",ply,NULLFUNC)
ARCLib.ReceiveBigMessage("arcphone_comm_text",function(err,per,data,ply)
	if err == ARCLib.NET_DOWNLOADING then
		MsgN("TODO: ARCPhone text receive progress icon")
	elseif err == ARCLib.NET_COMPLETE then
		ARCPhone.PhoneSys:RecieveText(unpack(string.Explode( "\v", data)))
	else
		ARCPhone.Msg("Incomming arcphone_comm_text message errored! "..err)
	end
end)

--[[
local msgchunks = {}
net.Receive( "arcphone_comm_text", function(length)
	local succ = net.ReadInt(8)
	local part = net.ReadUInt(32)
	local whole = net.ReadUInt(32)
	local hash = net.ReadString()
	local str = ""
	local strlen = net.ReadUInt(32)
	if strlen > 0 then
		str = net.ReadData(strlen)
	end
	
	if succ == -1 then
		local len = #ARCPhone.PhoneSys.OutgoingTexts[hash].msg
		if whole == len then
			if part == ARCPhone.PhoneSys.OutgoingTexts[hash].place then
				ARCPhone.PhoneSys.OutgoingTexts[hash].place = ARCPhone.PhoneSys.OutgoingTexts[hash].place + 1
				MsgN("ARCPhone: Sending Chunk "..ARCPhone.PhoneSys.OutgoingTexts[hash].place.."/"..len.." of text"..hash.." to the server")
				net.Start("arcphone_comm_text")
				net.WriteInt(0,8)
				net.WriteUInt(ARCPhone.PhoneSys.OutgoingTexts[hash].place,32)
				net.WriteUInt(len,32)
				net.WriteString(hash)
				local str = ARCPhone.PhoneSys.OutgoingTexts[hash].msg[ARCPhone.PhoneSys.OutgoingTexts[hash].place]
				net.WriteUInt(#str,32)
				net.WriteData(str,#str)
				net.SendToServer()
			else
				MsgN("ARCPhone: Server mismatched in part")
				net.Start("arcphone_comm_text")
				net.WriteInt(1,8)
				net.WriteUInt(1,32)
				net.WriteUInt(1,32)
				net.WriteString(hash)
				net.WriteUInt(0,32)
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
			net.WriteUInt(0,32)
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
					ARCPhone.PhoneSys:RecieveText(unpack(string.Explode( "\v", util.Decompress(msgchunks[hash].msg))))
					msgchunks[hash] = nil
					net.Start("arcphone_comm_text")
					net.WriteInt(-2,8)
					net.WriteUInt(0,32)
					net.WriteUInt(0,32)
					net.WriteString(hash) --Hash
					net.WriteUInt(0,32)
					net.SendToServer()
					
			else
				net.Start("arcphone_comm_text")
				net.WriteInt(-1,8)
				net.WriteUInt(part,32)
				net.WriteUInt(whole,32)
				net.WriteString(hash) --Hash
				net.WriteUInt(0,32)
				net.SendToServer()
				msgchunks[hash].prt = msgchunks[hash].prt + 1
			end
		end
	else
		msgchunks[hash] = nil
		MsgN("ARCPhone: Server sent error on text "..hash)
	end
end)
]]

ARCPhone.PhoneRingers = {}
net.Receive( "arcphone_ringer", function(length)
	local pid = net.ReadUInt(16)
	local url = net.ReadString()
	if IsValid(ARCPhone.PhoneRingers[pid]) then
		ARCPhone.PhoneRingers[pid]:EnableLooping(false) 
		ARCPhone.PhoneRingers[pid]:Stop()
		ARCPhone.PhoneRingers[pid] = nil
	end
	local ply = Entity(pid)
	if url != "" && IsValid(ply) then
		sound.PlayURL ( url, "3d noblock", function( station,errid,errstr )
			if IsValid(ARCPhone.PhoneRingers[pid]) then
				ARCPhone.PhoneRingers[pid]:Stop()
			end
			if ( IsValid( station ) ) then
				ARCPhone.PhoneRingers[pid] = station
				ARCPhone.PhoneRingers[pid]:SetPos(ply:GetPos() )
				ARCPhone.PhoneRingers[pid]:Play()
				ARCPhone.PhoneRingers[pid]:EnableLooping(true) 
				ARCPhone.PhoneRingers[pid]:SetVolume(0.4)
			else
				MsgN(ply:Nick().."'s ringtone failed. ("..tostring(errid)..") "..tostring(errstr))
				LocalPlayer():EmitSound("buttons/button8.wav" )
			end
		end)
	end
end)