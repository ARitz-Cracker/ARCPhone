-- cmds.lua - Commands for ARCPhone (Can be editable using a plugin)

-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.
ARCPhone.Loaded = false
ARCPhone.VarTypeExamples = {}
ARCPhone.VarTypeExamples["list"] = {"aritz,snow,cathy,kenzie,isaac,tasha,bubby","bob,joe,frank,bill","red,green,blue,yellow","lol,wtf,omg,rly"}
ARCPhone.VarTypeExamples["number"] = {"1337","15","27","9","69","20140331"}
ARCPhone.VarTypeExamples["boolean"] = {"true","false"}
ARCPhone.VarTypeExamples["string"] = {"word","helloworld","iloveyou","MONEY!","bob","aritz"}
ARCPhone.Commands = { --Make sure they are less then 16 chars long.$
	["about"] = {
		command = function(ply,args) 
			if !ARCPhone.Loaded then ARCPhoneMsgCL(ply,"System reset required!") return end
			ARCPhoneMsgCL(ply,"ARitz Cracker Phone v"..ARCPhone.Version.." Last updated on "..ARCPhone.Update )
			ARCPhoneMsgCL(ply,"© Copyright 2015 Aritz Beobide-Cardinal (ARitz Cracker) All rights reserved.")
			ARCPhoneMsgCL(ply,"If you have any questions, please go to this webpage: ")
			ARCPhoneMsgCL(ply,"www.aritzcracker.ca")
		end, 
		usage = "",
		description = "About ARitz Cracker Phone.",
		adminonly = false,
		hidden = false
	},
	["number"] = {
		command = function(ply,args) 
			 ARCPhoneMsgCL(ply,ARCPhone.GetPhoneNumber(ply))
		end, 
		usage = "",
		description = "Get your phone number",
		adminonly = false,
		hidden = false
	},
	["call"] = {
		command = function(ply,args) 
			if args[1] then
				ARCPhone.MakeCall(ARCPhone.GetPhoneNumber(ply),args[1])
				MsgN(ARCPhone.GetPhoneNumber(ply).." - "..args[1])
			else
				ARCPhoneMsgCL(ply,"No Phone number specified." )
			end
		end, 
		usage = "",
		description = "Call someone",
		adminonly = false,
		hidden = false
	},
	["answer"] = {
		command = function(ply,args) 
			 ARCPhone.AnswerCall(ARCPhone.GetPhoneNumber(ply))
		end, 
		usage = "",
		description = "Answer the phone",
		adminonly = false,
		hidden = false
	},
	["hangup"] = {
		command = function(ply,args) 
			 ARCPhone.HangUp(ARCPhone.GetPhoneNumber(ply))
		end, 
		usage = "",
		description = "Hang up",
		adminonly = false,
		hidden = false
	},
	["help"] = {
		command = function(ply,args) 
			if !ARCPhone.Loaded then ARCPhoneMsgCL(ply,"System reset required!") return end
			if args[1] then
				if ARCPhone.Commands[args[1]] then
					ARCPhoneMsgCL(ply,args[1]..tostring(ARCPhone.Commands[args[1]].usage).." - "..tostring(ARCPhone.Commands[args[1]].description))
				else
					ARCPhoneMsgCL(ply,"No such command as "..tostring(args[1]))
				end
			else
				local cmdlist = "\n*** ARCBANK HELP MENU ***\n\nSyntax:\n<name(type)> = required argument\n[name(type)] = optional argument\n\nList of commands:"
				for key,a in SortedPairs(ARCPhone.Commands) do
					if !ARCPhone.Commands[key].hidden then
						local desc = "*                                                 - "..ARCPhone.Commands[key].description.."" -- +2
						for i=1,string.len( key..ARCPhone.Commands[key].usage ) do
							desc = string.SetChar( desc, (i+2), string.GetChar( key..ARCPhone.Commands[key].usage, i ) )
						end
						cmdlist = cmdlist.."\n"..desc
					end
				end
				for _,v in pairs(string.Explode( "\n", cmdlist ))do
					ARCPhoneMsgCL(ply,v)
				end
			end
			
		end, 
		usage = " [command(string)]",
		description = "Gives you a description of every command.",
		adminonly = false,
		hidden = false
	},
	["test"] = {
		command = function(ply,args) 
			local str = "Arguments:"
			for _,arg in ipairs(args) do
				str = str.." | "..arg
			end
			ARCPhoneMsgCL(ply,str)
		end, 
		usage = " [argument(any)] [argument(any)] [argument(any)]",
		description = "[Debug] Tests arguments",
		adminonly = false,
		hidden = true
	},
	["settings"] = {
		command = function(ply,args) 
			if !ARCPhone.Loaded then ARCPhoneMsgCL(ply,"System reset required!") return end
			if !args[1] then ARCPhoneMsgCL(ply,"You didn't enter a setting!") return end
			if ARCPhone.Settings[args[1]] || isbool(ARCPhone.Settings[args[1]]) then
				if isnumber(ARCPhone.Settings[args[1]]) then
					if tonumber(args[2]) then
						ARCPhone.Settings[args[1]] = tonumber(args[2])
						for k,v in pairs(player.GetAll()) do
							ARCPhoneMsgCL(v,args[1].." has been set to: "..tostring(tonumber(args[2])))
						end
					else
						ARCPhoneMsgCL(ply,"You cannot set "..args[1].." to "..tostring(tonumber(args[2])))
					end
				elseif istable(ARCPhone.Settings[args[1]]) then
					if args[2] == "" || args[2] == " " then
						ARCPhone.Settings[args[1]] = {}
					else
						ARCPhone.Settings[args[1]] = string.Explode( ",", args[2])
					end
					for k,v in pairs(player.GetAll()) do
						ARCPhoneMsgCL(v,args[1].." has been set to: "..args[2])
					end
				elseif isstring(ARCPhone.Settings[args[1]]) then
					ARCPhone.Settings[args[1]] = string.gsub(args[2], "[^_%w]", "_")
					for k,v in pairs(player.GetAll()) do
						ARCPhoneMsgCL(v,args[1].." has been set to: "..string.gsub(args[2], "[^_%w]", "_"))
					end
				elseif isbool(ARCPhone.Settings[args[1]]) then
					ARCPhone.Settings[args[1]] = tobool(args[2])
					for k,v in pairs(player.GetAll()) do
						ARCPhoneMsgCL(v,args[1].." has been set to: "..tostring(tobool(args[2])))
					end
				end
			else
				ARCPhoneMsgCL(ply,"Invalid setting "..args[1])
			end
		end, 
		usage = " <setting(str)> <value(any)>",
		description = "Changes settings (see settings_help)",
		adminonly = true,
		hidden = false
	},
	["settings_help"] = {
		command = function(ply,args) 
			if !ARCPhone.Loaded then ARCPhoneMsgCL(ply,"System reset required!") return end
			if !args[1] then 
				for k,v in SortedPairs(ARCPhone.Settings) do
					if istable(v) then
						local s = ""
						for o,p in pairs(v) do
							if o > 1 then
								s = s..","..p
							else
								s = p
							end
						end
						ARCPhoneMsgCL(ply,tostring(k).." = "..s)
					else
						ARCPhoneMsgCL(ply,tostring(k).." = "..tostring(v))
					end
				end
				ARCPhoneMsgCL(ply,"Type 'settings_help (setting) for a more detailed description of a setting.")
				return
			end
			if ARCPhone.Settings[args[1]] || isbool(ARCPhone.Settings[args[1]]) then
				if isnumber(ARCPhone.Settings[args[1]]) then
					ARCPhoneMsgCL(ply,"Type: number")
					ARCPhoneMsgCL(ply,"Example: "..args[1].." "..table.Random(ARCPhone.VarTypeExamples["number"]))
					ARCPhoneMsgCL(ply,"Description: "..tostring(ARCPhone.SettingsDesc[args[1]]))
					ARCPhoneMsgCL(ply,"Currently set to: "..tostring(ARCPhone.Settings[args[1]]))
				elseif istable(ARCPhone.Settings[args[1]]) then
					local s = ""
					for o,p in pairs(ARCPhone.Settings[args[1]]) do
						if o > 1 then
							s = s..","..p
						else
							s = p
						end
					end
					ARCPhoneMsgCL(ply,"Type: list")
					ARCPhoneMsgCL(ply,"Example: "..args[1].." "..table.Random(ARCPhone.VarTypeExamples["list"]))
					ARCPhoneMsgCL(ply,"Description: "..tostring(ARCPhone.SettingsDesc[args[1]]))
					ARCPhoneMsgCL(ply,"Currently set to: "..s)
				elseif isstring(ARCPhone.Settings[args[1]]) then
					ARCPhoneMsgCL(ply,"Type: string")
					ARCPhoneMsgCL(ply,"Example: "..args[1].." "..table.Random(ARCPhone.VarTypeExamples["string"]))
					ARCPhoneMsgCL(ply,"Description: "..tostring(ARCPhone.SettingsDesc[args[1]]))
					ARCPhoneMsgCL(ply,"Currently set to: "..ARCPhone.Settings[args[1]])
				elseif isbool(ARCPhone.Settings[args[1]]) then
					ARCPhoneMsgCL(ply,"Type: boolean")
					ARCPhoneMsgCL(ply,"Example: "..args[1].." "..table.Random(ARCPhone.VarTypeExamples["boolean"]))
					ARCPhoneMsgCL(ply,"Description: "..tostring(ARCPhone.SettingsDesc[args[1]]))
					ARCPhoneMsgCL(ply,"Currently set to: "..tostring(ARCPhone.Settings[args[1]]))
				end
			else
				ARCPhoneMsgCL(ply,"Invalid setting")
			end
		end, 
		usage = " [setting(str)]",
		description = "Shows you and gives you a description of all the settings",
		adminonly = false,
		hidden = false
	},
	["settings_save"] = {
		command = function(ply,args) 
			if !ARCPhone.Loaded then ARCPhoneMsgCL(ply,"System reset required!") return end
			ARCPhoneMsgCL(ply,"Saving settings...")
			ARCPhoneMsg("Saving settings...")
			file.Write(ARCPhone.Dir.."/_saved_settings.txt",util.TableToJSON(ARCPhone.Settings))
			if file.Exists(ARCPhone.Dir.."/_saved_settings.txt","DATA") then
				ARCPhoneMsgCL(ply,"Settings Saved!")
				ARCPhoneMsg("Settings Saved!")
			else
				ARCPhoneMsgCL(ply,"Error saving settings!")
				ARCPhoneMsg("Error saving settings!")
			end
		end, 
		usage = "",
		description = "Saves all settings",
		adminonly = true,
		hidden = false
	},
	["antenna_save"] = {
		command = function(ply,args)
			if !ARCPhone.Loaded then ARCPhoneMsgCL(ply,"System reset required!") return end
			ARCPhoneMsgCL(ply,"Saving Antennas to map...")
			if ARCPhone.SaveAntennas() then
				ARCPhoneMsgCL(ply,"Antennas saved onto map!")
			else
				ARCPhoneMsgCL(ply,"An error occured while saving the Antennas onto the map.")
			end
		end, 
		usage = "",
		description = "Makes all active Antennas a part of the map.",
		adminonly = true,
		hidden = false
	},
	["antenna_unsave"] = {
		command = function(ply,args)
			if !ARCPhone.Loaded then ARCPhoneMsgCL(ply,"System reset required!") return end
			ARCPhoneMsgCL(ply,"Detatching Antennas from map...")
			if ARCPhone.UnSaveAntennas() then
				ARCPhoneMsgCL(ply,"Antennas Detached from map!")
			else
				ARCPhoneMsgCL(ply,"An error occured while detatching Antennas from map.")
			end
		end, 
		usage = "",
		description = "Makes all saved Antennas moveable again.",
		adminonly = true,
		hidden = false
	},
	["antenna_respawn"] = {
		command = function(ply,args) 
			if !ARCPhone.Loaded then ARCPhoneMsgCL(ply,"System reset required!") return end
			ARCPhoneMsgCL(ply,"Spawning Map-Based Antennas...")
			if ARCPhone.SpawnAntennas() then
				ARCPhoneMsgCL(ply,"Map-Based Antennas Spawned!")
			else
				ARCPhoneMsgCL(ply,"No Antennas associated with this map. (Non-existent/Currupt file)")
			end
		end, 
		usage = "",
		description = "Respawns all Map-Based Antennas.",
		adminonly = true,
		hidden = false
	},
	["screen_debug"] = {
		command = function(ply,args)
			ply:SendLua("ARCPhone.PhoneSys.HideWhatsOffTheScreen = !ARCPhone.PhoneSys.HideWhatsOffTheScreen")
		end, 
		usage = "",
		description = "Screen Debug Mode",
		adminonly = true,
		hidden = true
	},
	["print_json"] = {
		command = function(ply,args) 
			if !ARCPhone.Loaded then ARCPhoneMsgCL(ply,"System reset required!") return end
			local translations = {}
			translations.errmsgs = ARCPHONE_ERRORSTRINGS
			translations.msgs = ARCPhone.Msgs
			translations.settingsdesc = ARCPhone.SettingsDesc
			local strs = ARCLib.SplitString(util.TableToJSON(translations),4000)
			for i = 1,#strs do
				Msg(strs[i])
			end
			Msg("\n")
		end, 
		usage = "",
		description = "Prints a JSON of all the translation shiz.",
		adminonly = true,
		hidden = true
	},
	["reset"] = {
		command = function(ply,args) 
			ARCPhoneMsgCL(ply,"Resetting ARCPhone system...")
			ARCPhone.SaveDisk()
			ARCPhone.Load()
			timer.Simple(math.Rand(4,5),function()
				if ARCPhone.Loaded then
					ARCPhoneMsgCL(ply,"System resetted!")
				else
					ARCPhoneMsgCL(ply,"Error. Check server console for details.")
				end
			end)
		end, 
		usage = "",
		description = "Updates settings and checks for any currupt or invalid accounts. (SAVE YOUR SETTINGS BEFORE DOING THIS!)",
		adminonly = true,
		hidden = false
	}
}
concommand.Add( "arcphone", function( ply, cmd, args )
	local comm = args[1]
	table.remove( args, 1 )
	if ARCPhone.Commands[comm] then
		if ARCPhone.Commands[comm].adminonly && ply && ply:IsPlayer() && !ply:IsAdmin() && !ply:IsSuperAdmin() then
			ARCPhoneMsgCL(ply,"You must be an admin to use this command!")
		return end
		if ARCPhone.Commands[comm].adminonly && ARCPhone.Settings["superadmin_only"] && ply && ply:IsPlayer() && !ply:IsSuperAdmin() then
			ARCPhoneMsgCL(ply,"You must be an superadmin to use this command!")
		
		return end
		
		if ply && ply:IsPlayer() then
			local shitstring = ply:Nick().." ("..ply:SteamID()..") used the command: "..comm
			for i=1,#args do
				shitstring = shitstring.." "..args[i]
			end
			ARCPhoneMsg(shitstring)
		end
		ARCPhone.Commands[comm].command(ply,args)
	elseif !comm then
		ARCPhoneMsgCL(ply,"No command. Type 'arcphone help' for help.")
	else
		ARCPhoneMsgCL(ply,"Invalid command '"..tostring(comm).."' Type 'arcphone help' for help.")
	end
end)


