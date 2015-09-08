-- numbers.lua - Phone number stuff

-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

--[[
ARCPhone.CachedPhoneNumbers = {}
function ARCPhone.SteamIDToPhoneNumber(steamid)
	if !ARCPhone.CachedPhoneNumbers[steamid] then
		local hash = util.CRC(steamid)
		local num = string.rep("0",10-#hash)..hash
		ARCPhone.CachedPhoneNumbers[steamid] = num
		ARCPhone.CachedPhoneNumbers[num] = steamid
	end
	return ARCPhone.CachedPhoneNumbers[steamid]
end
function ARCPhone.SteamIDFromPhoneNumber(number)
	return ARCPhone.CachedPhoneNumbers[number]
end
function ARCPhone.GetPhoneNumber(ply)
	if !IsValid(ply) || !ply:IsPlayer() then return 0 end
	return ARCPhone.SteamIDToPhoneNumber(ply:SteamID())
end
function ARCPhone.GetPlayerFromPhoneNumber(number)
	local ply = NULL
	if ARCPhone.CachedPhoneNumbers[number] then
		ply = ARCLib.GetPlayerBySteamID(ARCPhone.CachedPhoneNumbers[number])
	else
		for k,v in pairs(player.GetHumans()) do
			if number == ARCPhone.SteamIDToPhoneNumber(v:SteamID()) then
				ply = v
			end
		end
	end
	if !IsValid(ply) then
		function ply:SteamID() return "STEAM_ID_PENDING" end
		function ply:Nick() return "[Player Offline]" end
		function ply:IsPlayer() return false end
		function ply:IsValid() return false end
	end
	return ply
end
-- Hashing way...
-- lua_run for k,v in pairs(player.GetAll()) do PrintMessage( HUD_PRINTTALK, v:Nick().."'s phone number is "..ARCPhone.GetPhoneNumber(v) ) end
]]

function ARCPhone.SteamIDToPhoneNumber(steamid)
	return string.sub( util.SteamIDTo64(steamid), #steamid-9)
end
function ARCPhone.SteamIDFromPhoneNumber(number)
	return ARCPhone.CachedPhoneNumbers[number]
end
function ARCPhone.GetPhoneNumber(ply)
	if !IsValid(ply) || !ply:IsPlayer() then return "**********" end
	local steamid = ply:SteamID64()
	return string.sub( steamid, #steamid-9)
end
function ARCPhone.GetPlayerFromPhoneNumber(number)
	local ply = player.GetBySteamID64( "7656119"..number ) or NULL
	if !IsValid(ply) then
		function ply:SteamID() return "STEAM_ID_PENDING" end
		function ply:Nick() return "[Player Offline]" end
		function ply:IsPlayer() return false end
		function ply:IsValid() return false end
	end
	return ply
end


function ARCPhone.ValidPhoneNumberChars(txt)
	local len = #txt
	local valid = true
	for i=1,len do
		if txt[i] != "1" && txt[i] != "2" && txt[i] != "3" && txt[i] != "4" && txt[i] != "5" && txt[i] != "6" && txt[i] != "7" && txt[i] != "8" && txt[i] != "9" && txt[i] != "0" && txt[i] != "*" && txt[i] != "#" then
			valid = false
			break
		end		
	end
	return valid
end

function ARCPhone.IsValidPhoneNumber(txt)
	if #txt != 10 then return false end
	return ARCPhone.ValidPhoneNumberChars(txt)
end
