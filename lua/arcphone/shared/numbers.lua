-- numbers.lua - Phone number stuff

-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

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
	local ply = {}
	for _, v in pairs( player.GetHumans() ) do
		if ARCPhone.GetPhoneNumber(v) == number then
			ply = v
		end
	end
	if !IsValid(ply) then
		ply.ARCPhone_Reception = 0
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
