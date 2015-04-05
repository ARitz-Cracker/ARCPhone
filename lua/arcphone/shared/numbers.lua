-- numbers.lua - Phone number stuff

-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.
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