-- clcomm.lua - Client/Server communications for ARCPhone
-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

--Check if the thing is running

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
			MsgN(ARCPhone.GetPhoneNumber(ply).." - "..number)
		else
			ARCPhoneMsgCL(ply,"No Phone number specified." )
		end
	elseif operation == 2 then
		ARCPhone.AnswerCall(ARCPhone.GetPhoneNumber(ply))
	elseif operation == 3 then
		ARCPhone.HangUp(ARCPhone.GetPhoneNumber(ply))
	elseif operation == 4 then
		if ply.ARCPhone_Status != ARCPHONE_ERROR_NONE then
			ARCPhoneMsgCL(ply,"No call running or call has not been established.")
		else
			ARCPhone.AddToCall(ARCPhone.GetPhoneNumber(ply),number)
		end
	else
		ARCPhoneMsgCL(ply,"Invalid operation" )
	end
end)

util.AddNetworkString( "arcphone_comm_text" )


local msgchunks = {}


net.Receive( "arcphone_comm_text", function(length,ply)
	local succ = net.ReadInt(8)
	local part = net.ReadUInt(32)
	local whole = net.ReadUInt(32)
	local hash = net.ReadString()
	local str = ""
	local strlen = net.ReadUInt(32)
	if strlen > 0 then
		str = net.ReadData(strlen)
	end
	--MsgN("NET MSG NET LENGTH: "..(length - strlen))
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
--[[
net.Receive( "arcphone_comm_text", function(length,ply)
	local number = net.ReadString()
	local message = net.ReadString()
	if number == "confirming" then
		local plynum = ARCPhone.Disk.Texts[ARCPhone.GetPhoneNumber(ply)]
		if plynum then
			MsgN(table.RemoveByValue(plynum,message))
		end
	else
		if ply.ARCPhone_Reception > 15 then
			number = tonumber(number)
			if isnumber(number) && math.floor(math.log10(number)) == 9 && number >= 7960265729 then -- That phone number translates to STEAM_0:1:0. But I doubt rich (The first user ever on steam) will ever play DarkRP any time soon.
				if ARCPhone.Disk.Texts[number] then
					table.insert(ARCPhone.Disk.Texts[number],ARCPhone.GetPhoneNumber(ply)..message.."\nSent: "..os.date("%d-%m-%Y %H:%M:%S"))
				else
					ARCPhone.Disk.Texts[number] = {ARCPhone.GetPhoneNumber(ply)..message.."\nSent: "..os.date("%d-%m-%Y %H:%M:%S")}
				end
			else
				if ARCPhone.Disk.Texts[ARCPhone.GetPhoneNumber(ply)] then
					table.insert(ARCPhone.Disk.Texts[ARCPhone.GetPhoneNumber(ply)],"*002728398Text to "..tostring(number).." failed because the number is invalid.")
				else
					ARCPhone.Disk.Texts[ARCPhone.GetPhoneNumber(ply)] = {"*002728398Text to "..tostring(number).." failed because the number is invalid."}
				end
			end
		else
			if ARCPhone.Disk.Texts[ARCPhone.GetPhoneNumber(ply)] then
				table.insert(ARCPhone.Disk.Texts[ARCPhone.GetPhoneNumber(ply)],"*002728398Text to "..tostring(number).." failed because you didn't have enough bars.")
			else
				ARCPhone.Disk.Texts[ARCPhone.GetPhoneNumber(ply)] = {"*002728398Text to "..tostring(number).." failed because you didn't have enough bars."}
			end
		end
	end
end)
]]

util.AddNetworkString( "arcphone_ringer" )
net.Receive( "arcphone_ringer", function(length,ply)
	local url = net.ReadString()
	if ply.ARCPhone_Status == ARCPHONE_ERROR_RINGING then
		net.Start("arcphone_ringer")
		net.WriteUInt( 0, 16 )
		net.WriteString(url)
		net.SendOmit(ply)
	else
		net.Start("arcphone_ringer")
		net.WriteUInt( 0, 16 )
		net.WriteString("")
		net.SendOmit(ply)
	end
end)