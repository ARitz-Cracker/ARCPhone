-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
util.AddNetworkString( "arcphone_atmos_support" )
local t = 0
local hours = 0
local minutes = 0
local lastHours = 0
local lastMinutes = 0
local function GetTime()
	if _G.AtmosGlobal then
		return AtmosGlobal:GetTime()
	elseif _G.SW then
		return SW.Time
	end
	return 0
end

local atmosSupportThink = function()
	t = GetTime()
	hours = math.floor( t )
	minutes = math.floor(( t - hours ) * 60)
	if hours ~= lastHours or minutes ~= lastMinutes then
		net.Start("arcphone_atmos_support")
		net.WriteUInt(hours,5)
		net.WriteUInt(minutes,6)
		net.Broadcast()
	end
	lastHours = hours
	lastMinutes = minutes
end

function ARCPhone.OnSettingChanged(key,val)
	if key == "phone_clock_cycle" then
		if (val) and _G.AtmosGlobal or _G.SW then
			hook.Add("Think","ARCPhone AtmosSupport",atmosSupportThink)
		else
			hook.Remove("Think","ARCPhone AtmosSupport")
		end
	end
end