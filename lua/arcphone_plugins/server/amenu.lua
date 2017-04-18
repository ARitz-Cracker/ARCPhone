-- GUI for ARitz Cracker Bank (Serverside)
-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
util.AddNetworkString( "ARCPhone_Admin_GUI" )
util.AddNetworkString( "arcphone_emerg_numbers" )
ARCPhone.Commands["admin_gui"] = {
	command = function(ply,args) 
		if !ARCPhone.Loaded then ARCPhone.MsgCL(ply,ARCPhone.Msgs.CommandOutput.SysReset) return end
		if !args[1] then
			local place = 0
			local tab = {}
			for k,v in pairs(ARCPhone.SpecialSettings) do
				place = place + 1
				tab[place] = k
			end
			net.Start( "ARCPhone_Admin_GUI" )
			net.WriteString("")
			net.WriteTable(tab)
			net.Send(ply)
		elseif args[1] == "logs" then
			net.Start( "ARCPhone_Admin_GUI" )
			net.WriteString("logs")
			net.WriteTable(file.Find( ARCPhone.Dir.."/systemlog*", "DATA", "datedesc" ) )
			net.Send(ply)
		elseif args[1] == "adv" then
			if ARCPhone.SpecialSettings[args[2]] then
				net.Start( "ARCPhone_Admin_GUI" )
				net.WriteString("adv_"..args[2])
				net.WriteTable(ARCPhone.SpecialSettings[args[2]])
				net.Send(ply)
			end
		else
			ARCPhone.MsgCL(ply,"Invalid AdminGUI request")
		end
	end, 
	usage = "",
	description = "Opens the admin interface.",
	adminonly = true,
	hidden = false
}

net.Receive("ARCPhone_Admin_GUI",function(len,ply) 
	if not table.HasValue(ARCPhone.Settings.admins,string.lower(ply:GetUserGroup())) then
		ARCPhone.MsgCL(ply,ARCLib.PlaceholderReplace(ARCPhone.Msgs.CommandOutput.AdminCommand,{RANKS=table.concat( ARCPhone.Settings.admins, ", " )}))
	return end
	
	local setting = net.ReadString()
	local tab = net.ReadTable()
	if setting == "EmergencyNumbers" then -- Check if it's everything we expect
		local len = 0
		for k,v in pairs(tab) do
			assert(ARCPhone.ValidPhoneNumberChars(k))
			assert(istable(v))
			for kk,vv in pairs(v) do
				assert(isnumber(kk))
				assert(isstring(vv))
			end
			len = len + 1
		end
		if len > 255 then
			ARCPhone.MsgCL(ply,"There cannot be more than 255 emergency numbers.")
			return
		end
		net.Start("arcphone_emerg_numbers")
		net.WriteUInt(len,8)
		for k,v in pairs(tab) do
			net.WriteString(k)
		end
		net.Broadcast()
	end
	ARCPhone.SpecialSettings[setting] = tab

	ARCLib.AddonSaveSpecialSettings("ARCPhone")
end)
