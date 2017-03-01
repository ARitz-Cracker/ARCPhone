-- GUI for ARitz Cracker Bank (Serverside)
-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
if ARCPhone then
	util.AddNetworkString( "ARCPhone_Admin_GUI" )
	ARCPhone.Commands["admin_gui"] = {
		command = function(ply,args) 
			if !ARCPhone.Loaded then ARCPhone.MsgCL(ply,ARCPhone.Msgs.CommandOutput.SysReset) return end
			if !args[1] then
				net.Start( "ARCPhone_Admin_GUI" )
				net.WriteString("")
				net.WriteTable({})
				net.Send(ply)
			elseif args[1] == "logs" then
				net.Start( "ARCPhone_Admin_GUI" )
				net.WriteString("logs")
				net.WriteTable(file.Find( ARCPhone.Dir.."/systemlog*", "DATA", "datedesc" ) )
				net.Send(ply)
			else
				ARCPhone.MsgCL(ply,"Invalid AdminGUI request")
			end
		end, 
		usage = "",
		description = "Opens the admin interface.",
		adminonly = true,
		hidden = false
	}
end

