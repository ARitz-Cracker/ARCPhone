-- clcomm.lua - Client/Server communications for ARCPhone

-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.

--Check if the thing is running
util.AddNetworkString( "arcphone_phone_settings" )
net.Receive( "arcphone_phone_settings", function(length,ply) -- Can't wait until people exploit this to make rainbow phones.
	local wep = ply:GetWeapon( "weapon_arc_phone" )
	if not IsValid(wep) then return end
	local case = net.ReadUInt(4)
	
	wep:SetSkin(case)
end)

util.AddNetworkString( "arcphone_switchholdtype" ) -- This isn't an exploit, it's purly cosmetic, ok? >_>
net.Receive( "arcphone_switchholdtype", function(length,ply)
	local wep = net.ReadString()
	local wepent = ply:GetActiveWeapon()
	if !wep then return end
	if !wepent then return end
	if wepent.IsDahAwesomePhone then
		wepent:SetHoldType( wep ) 
	end
end)
	

util.AddNetworkString( "arcphone_switchwep" )
ARCPhone.Loaded = false
net.Receive( "arcphone_switchwep", function(length,ply)
	local wep = net.ReadString()
	if !wep then return end
	if ply:GetActiveWeapon().IsDahAwesomePhone then
		ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_HOLSTER)
		timer.Simple(1,function()
			ply:SelectWeapon(wep)
			--timer.Simple(0.001,function()
				ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW)
			--end)
		end)
	end
end)
	
util.AddNetworkString( "arcphone_comm_check" )


ARCPhone.Loaded = false

net.Receive( "arcphone_comm_check", function(length,ply)
	net.Start("arcphone_comm_check")
	net.WriteBit(ARCPhone.Loaded)
	net.WriteBit(ARCPhone.Outdated)
	net.Send(ply)
end)

util.AddNetworkString( "arcphone_comm_status" )

net.Receive( "arcphone_comm_status", function(length,ply)
	net.Start("arcphone_comm_reception")
	net.WriteInt(ply.ARCPhone_Reception,8)
	net.WriteInt(ply.ARCPhone_Status,ARCPHONE_ERRORBITRATE)
	net.Send(ply)
end)

util.AddNetworkString( "arcphone_comm_call" )

net.Receive( "arcphone_comm_call", function(length,ply)
	local operation = net.ReadInt(8)
	local number = net.ReadString()
	if operation < 0 then
		local plynum = ARCPhone.GetPhoneNumber(ply)
		ARCPhone.MakeCall(plynum,number)
		--MsgN("operation "..operation*-1)
		for i = 1, (operation*-1) do
			local t_num = tonumber(net.ReadString())
			if t_num then
				ARCPhone.AddToCall(plynum,t_num)
			end
		end
		
		
	elseif operation == 1 then
		if ply.ARCPhone_Status != ARCPHONE_ERROR_CALL_ENDED then return end
		if number then
			ARCPhone.MakeCall(ARCPhone.GetPhoneNumber(ply),number)
			ARCPhone.Msg(ARCPhone.GetPhoneNumber(ply).." is calling "..number)
		else
			ARCPhone.MsgCL(ply,"No Phone number specified." )
		end
	elseif operation == 2 then
		ARCPhone.AnswerCall(ARCPhone.GetPhoneNumber(ply))
	elseif operation == 3 then
		ARCPhone.HangUp(ARCPhone.GetPhoneNumber(ply))
	elseif operation == 4 then
		if ply.ARCPhone_Status != ARCPHONE_ERROR_NONE then
			ARCPhone.MsgCL(ply,"No call running or call has not been established.")
		else
			ARCPhone.AddToCall(ARCPhone.GetPhoneNumber(ply),number)
		end
	else
		ARCPhone.MsgCL(ply,"Invalid operation" )
	end
end)

ARCLib.RegisterBigMessage("arcphone_comm_text",8000,255)
ARCLib.ReceiveBigMessage("arcphone_comm_text",function(err,per,data,ply)
	if err == ARCLib.NET_DOWNLOADING then
		--Nothing?
	elseif err == ARCLib.NET_COMPLETE then
		local vnum = ARCPhone.GetPhoneNumber(ply)
		ARCPhone.SendTextMsg(string.Left( data , 10 ),vnum,string.Right( data, #data-10 ))
	else
		ARCPhone.Msg("Incoming arcphone_comm_text message errored! "..err)
	end
end)
--ARCLib.SendBigMessage("arcphone_comm_text","",ply,NULLFUNC)

--[[
util.AddNetworkString( "arcphone_comm_text" )
local msgchunks = {}

net.Receive( "arcphone_comm_text", function(length,ply)
	local succ = net.ReadInt(8)
	local part = net.ReadUInt(32)
	local whole = net.ReadUInt(32)
	local hash = net.ReadString()
	local str = ""
	local strlen = net.ReadUInt(32)
	if (length - strlen*8) != 192 then
		ARCPhone.FuckIdiotPlayer(ply,"Text message buffer underflow")
	end
	if strlen > 0 then
		str = net.ReadData(strlen)
	end
	local vnum = ARCPhone.GetPhoneNumber(ply)
	
	
	
	if succ == -1 then
		MsgN(ARCPhone.Disk.Texts[vnum][hash])
		local len = #ARCPhone.Disk.Texts[vnum][hash].msg
		if whole == len then
			if part == ARCPhone.Disk.Texts[vnum][hash].place then
				ARCPhone.Disk.Texts[vnum][hash].place = ARCPhone.Disk.Texts[vnum][hash].place + 1
				MsgN("ARCPhone: Sending Chunk "..ARCPhone.Disk.Texts[vnum][hash].place.."/"..len.." of text"..hash.." to "..tostring(ply))
				net.Start("arcphone_comm_text")
				net.WriteInt(0,8)
				net.WriteUInt(ARCPhone.Disk.Texts[vnum][hash].place,32)
				net.WriteUInt(len,32)
				net.WriteString(hash)
				local str = ARCPhone.Disk.Texts[vnum][hash].msg[ARCPhone.Disk.Texts[vnum][hash].place]
				net.WriteUInt(#str,32)
				net.WriteData(str,#str)
				net.Send(ply)
			else
				MsgN("ARCPhone: Client mismatched in part")
				net.Start("arcphone_comm_text")
				net.WriteInt(1,8)
				net.WriteUInt(1,32)
				net.WriteUInt(1,32)
				net.WriteString(hash)
				net.WriteUInt(0,32)
				net.Send(ply)
				ARCPhone.Disk.Texts[vnum][hash].place = -1
			end
		else
			MsgN("ARCPhone: Client mismatched on whole")
			net.Start("arcphone_comm_text")
			net.WriteInt(1,8)
			net.WriteUInt(1,32)
			net.WriteUInt(1,32)
			net.WriteString(hash)
			net.WriteUInt(0,32)
			net.Send(ply)
			ARCPhone.Disk.Texts[vnum][hash].place = -1
		end
	elseif succ == -2 then
		ARCPhone.Disk.Texts[vnum][hash] = nil
		-- Done sending
	elseif succ == 0 then
		MsgN("ARCPhone: Client sent chunk "..part.."/"..whole.." on text "..hash)
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
				local destr = util.Decompress(msgchunks[hash].msg)
				ARCPhone.SendTextMsg(string.Left( destr , 10 ),vnum,string.Right( destr, #destr-10 ))
				msgchunks[hash] = nil
				net.Start("arcphone_comm_text")
				net.WriteInt(-2,8)
				net.WriteUInt(0,32)
				net.WriteUInt(0,32)
				net.WriteString(hash) --Hash
				net.WriteUInt(0,32)
				net.Send(ply)
			else
				net.Start("arcphone_comm_text")
				net.WriteInt(-1,8)
				net.WriteUInt(part,32)
				net.WriteUInt(whole,32)
				net.WriteString(hash) --Hash
				net.WriteUInt(0,32)
				net.Send(ply)
				msgchunks[hash].prt = msgchunks[hash].prt + 1
			end
		end
	else
		msgchunks[hash] = nil
		MsgN("ARCPhone: Client sent error on text "..hash)
	end
end)
]]

util.AddNetworkString( "arcphone_ringer" )
net.Receive( "arcphone_ringer", function(length,ply)
	local url = net.ReadString()
	if ply.ARCPhone_Status == ARCPHONE_ERROR_RINGING then
		net.Start("arcphone_ringer")
		net.WriteUInt( ply:EntIndex(), 16 )
		net.WriteString(url)
		net.SendOmit(ply)
	else
		net.Start("arcphone_ringer")
		net.WriteUInt( ply:EntIndex(), 16 )
		net.WriteString("")
		net.SendOmit(ply)
	end
end)