-- _core.lua - Base Resources and Virtual Netowrking

-- This shit is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- � Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

ARCPhone.LogFileWritten = false
ARCPhone.LogFile = ""
ARCPhone.Loaded = false
ARCPhone.Busy = true
ARCPhone.Dir = "_arcphone_server"
ARCPhone.AccountPrefix = "account_"

ARCPhone.Disk = {}
ARCPhone.Disk.Texts = ARCPhone.Disk.Texts or {}
ARCPhone.Disk.ProperShutdown = false
ARCPhone.Calls = ARCPhone.Calls or {}
function ARCPhone.FuckIdiotPlayer(ply,reason)
	ARCPhoneMsg("ARCPHONE ANTI-CHEAT WARNING: Some stupid shit by the name of "..ply:Nick().." ("..ply:SteamID()..") tried to use an exploit: ["..tostring(reason).."]")
	if ply.ARCPhone_AFuckingIdiot then
		--ply:Ban(ARCPhone.Settings["autoban_time"], ) 
		ply:Ban(ARCBank.Settings["autoban_time"])
		ply:SendLua("Derma_Message( \"You will be autobanned for "..ARCLib.TimeString( ARCPhone.Settings["autoban_time"]*60 )..".\", \"You're a failure at hacking\", \"Shit, Looks like I'm an idiot.\" )")
		timer.Simple(10,function()
			if IsValid(ply) && ply:IsPlayer() then 
				ply:Kick("ARCPhone Autobanned for "..ARCLib.TimeString( ARCPhone.Settings["autoban_time"]*60 ).." - Tried to be a L33T H4X0R ["..tostring(reason).."]") 
			end
		end)
	else
		ARCPhoneMsgCL(ply,table.Random({"I fucking swear, you better not try that again.","It's people like you that make my life harder.","I'LL BAN YO' FUCKIN' ASS IF YOU TRY THAT MUTHAFUKIN SHIT AGAIN!","Seriously? Do you really think you can get away with that?"}))
		ply.ARCPhone_AFuckingIdiot = true
	end
end

function ARCPhone.SaveDisk()
	ARCPhone.Disk.ProperShutdown = true
	file.Write(ARCPhone.Dir.."/__data.txt", util.TableToJSON(ARCPhone.Disk) )
end


function ARCPhone.PlayerCanAfford(ply,amount)
	if string.lower(GAMEMODE.Name) == "darkrp" then
		if string.StartWith( GAMEMODE.Version, "2.5." ) || GAMEMODE.Version == "Workshop" then
			return ply:canAfford(amount)
		else
			return ply:CanAfford(amount)
		end
	else
		return true
	end
end
function ARCPhone.PlayerAddMoney(ply,amount)
	if string.lower(GAMEMODE.Name) == "darkrp" then
		if string.StartWith( GAMEMODE.Version, "2.5." ) || GAMEMODE.Version == "Workshop" then
			ply:addMoney(amount)
		else
			ply:AddMoney(amount)
		end
	else
		ply:SendLua("notification.AddLegacy( \"I'm going to pretend that your wallet is unlimited because this is an unsupported gamemode.\", 0, 5 )")
	end
end

function ARCPhone.IsInCall(number)
	return ARCLib.RecursiveHasValue(ARCPhone.Calls,number)
end
 
 -- Makes a phone call. (Takes in phone numbers)
function ARCPhone.MakeCall(caller,reciever)
	
	local plycall = ARCPhone.GetPlayerFromPhoneNumber(caller)
	
	if !plycall:IsPlayer() then return end

	if !ARCPhone.Loaded then 
		plycall.ARCPhone_Status = ARCPHONE_ERROR_NOT_LOADED
		return
	end
	
	
	local phonecall = plycall:GetWeapon("weapon_arc_phone") 
	if ARCPhone.EntGetReception(phonecall) < 13 then
		plycall.ARCPhone_Status = ARCPHONE_ERROR_NO_RECEPTION
		return
	end
	
	--Process Special recievers here.
	
	--if !isnumber(reciever) then
	--	plycall.ARCPhone_Status = ARCPHONE_ERROR_NIL_NUMBER
	--	return 
	--end
	if #ARCPhone.Calls >= ARCPhone.Settings["max_lines"] then
		plycall.ARCPhone_Status = ARCPHONE_ERROR_TOO_MANY_CALLS
		return 
	end
	if caller == reciever then
		plycall.ARCPhone_Status = ARCPHONE_ERROR_BUSY
		return 
	end
	if ARCLib.RecursiveHasValue(ARCPhone.Calls,caller) || ARCLib.RecursiveHasValue(ARCPhone.Calls,reciever) then
		plycall.ARCPhone_Status = ARCPHONE_ERROR_BUSY
		return 
	end
	if ARCLib.TableAmount(ARCPhone.Calls) >= ARCPhone.Settings["max_lines"] then
		plycall.ARCPhone_Status = ARCPHONE_ERROR_TOO_MANY_CALLS
		return 
	end

	
	if #reciever != 10 then -- Check if it's a 10 digit number
		plycall.ARCPhone_Status = ARCPHONE_ERROR_NIL_NUMBER
		return 
	end
	
	local plyrec = ARCPhone.GetPlayerFromPhoneNumber(reciever)
	
	if !plyrec:IsPlayer() then
		plycall.ARCPhone_Status = ARCPHONE_ERROR_PLAYER_OFFLINE
		return 
	end
	
	local phonerec = plyrec:GetWeapon("weapon_arc_phone") 
	-- 15

	if ARCPhone.EntGetReception(phonerec) < 7 then
		plycall.ARCPhone_Status = ARCPHONE_ERROR_UNREACHABLE
		return 
	end
	plycall.ARCPhone_Status = ARCPHONE_ERROR_DIALING
	plyrec.ARCPhone_Status = ARCPHONE_ERROR_RINGING
	local newcall = {}
	newcall.on = {caller}
	newcall.pending = {reciever}
	table.insert( ARCPhone.Calls, newcall )
end
function ARCPhone.AnswerCall(number)
	local ply = ARCPhone.GetPlayerFromPhoneNumber(number)
	MsgN("Got Answer Request")
	if ply.ARCPhone_Status != ARCPHONE_ERROR_RINGING then return end -- You can't answer a call if no one is calling you!
	MsgN("passed")
	for k,v in pairs(ARCPhone.Calls) do
		if table.HasValue(v.pending,number) then
			table.RemoveByValue(v.pending,number)
			table.insert(v.on,number)
			ply.ARCPhone_Status = ARCPHONE_ERROR_NONE
			MsgN(tostring(ply).." - "..ARCPHONE_ERROR_NONE)
		end
		for kk,vv in pairs(v.on) do
			local cply = ARCPhone.GetPlayerFromPhoneNumber(vv)
			if cply.ARCPhone_Status != ARCPHONE_ERROR_NONE then
				cply.ARCPhone_Status = ARCPHONE_ERROR_NONE
				MsgN(tostring(ply).." - "..ARCPHONE_ERROR_NONE)
			end
		end
	end

end
function ARCPhone.TakeCosts()


end
function ARCPhone.GetReception(ply)
	if !ARCPhone.Loaded then return 0 end
	if !IsValid(ply) || !ply:IsPlayer() then return 0 end
	local phone = ply:GetWeapon("weapon_arc_phone")
	if IsValid(phone) then
		return ARCPhone.EntGetReception(phone)
	else
		return 0
	end
end
function ARCPhone.EntGetReception(phone)
	if !ARCPhone.Loaded then return 0 end
	if !IsValid(phone) || !phone.IsDahAwesomePhone then return 0 end
	if !ARCPhone.Settings["realistic_reception"] then return 100 end
	local per = 0
	for _,antenna in pairs(ents.FindByClass("sent_arc_phone_antenna")) do
		
		local beginpos = phone:GetPos()
		local dis = beginpos:Distance(antenna:GetPos())
		-- Target - Source
		local ang = (beginpos - antenna:GetPos()):Angle()
		local totaldistace = 0
		local totalblock = 0
		local failsafe = 0
		while math.ceil(totaldistace) < math.floor(dis) && failsafe < 200 do
			failsafe = failsafe + 1
			local trace = util.TraceLine( {
				start = antenna:GetPos() + ang:Forward()*(totaldistace+5),
				endpos = antenna:GetPos() + ang:Forward()*(dis),
				filter = function( ent ) if ( ent:GetClass() == "sent_arc_radio_blocker" ) then failsafe = 200 return true end end
			} )
			--trace.FractionLeftSolid = trace.FractionLeftSolid^2
			if !util.IsInWorld(trace.HitPos) then
				totalblock = totalblock + (dis-totaldistace)*trace.Fraction+1
			else
				totalblock = totalblock + (dis-totaldistace)*trace.FractionLeftSolid+1
			end
			totaldistace = totaldistace + (dis-totaldistace)*trace.Fraction+1
		end
		if failsafe == 200 then
			totalblock = dis
			totaldistace = dis
		end

		local mul = math.Clamp(((totalblock/ARCPhone.Settings["antenna_strength"]) - 1)*-1,0,1)^2
		per = per + math.Clamp((-1*(3^((totaldistace-ARCPhone.Settings["antenna_range"])/500)) + 100)*mul,0,100)

	end

	
	for _,jammer in pairs(ents.FindByClass("sent_arc_phone_jammer")) do
		if jammer.Jamming then
			local beginpos = phone:GetPos()
			local dis = beginpos:Distance(jammer:GetPos())
			-- Target - Source
			local ang = (beginpos - jammer:GetPos()):Angle()
			local totaldistace = 0
			local totalblock = 0
			local failsafe = 0
			while math.ceil(totaldistace) < math.floor(dis) && failsafe < 200 do
				failsafe = failsafe + 1
				local trace = util.TraceLine( {
					start = jammer:GetPos() + ang:Forward()*(totaldistace+5),
					endpos = jammer:GetPos() + ang:Forward()*(dis),
					filter = function( ent ) if ( ent:GetClass() == "sent_arc_radio_blocker" ) then failsafe = 200 return true end end
				} )
				--trace.FractionLeftSolid = trace.FractionLeftSolid^2
				if !util.IsInWorld(trace.HitPos) then
					totalblock = totalblock + (dis-totaldistace)*trace.Fraction+1
				else
					totalblock = totalblock + (dis-totaldistace)*trace.FractionLeftSolid+1
				end
				totaldistace = totaldistace + (dis-totaldistace)*trace.Fraction+1
			end
			if failsafe == 200 then
				totalblock = dis
				totaldistace = dis
			end

			local mul = math.Clamp(((totalblock/ARCPhone.Settings["jammer_strength"]) - 1)*-1,0,1)^2
			per = per - math.Clamp((-1*(3^((totaldistace-ARCPhone.Settings["jammer_range"])/500)) + 100)*mul,0,100)
		end
	end
	return math.Clamp(math.Round(per),0,100)
end

function ARCPhone.GetLineFromCaller(number)
	local thing = -1
	if ARCPhone.Calls then
		for kk,vv in pairs(ARCPhone.Calls) do
			if ARCLib.RecursiveHasValue(vv,number) then
				thing = kk
			end
		end
	end
	return thing
end
ARCPhone.GetLineFromNumber = ARCPhone.GetLineFromCaller
function ARCPhone.DropAllFromCall(line) 
	for k,v in pairs(ARCPhone.Calls[line].on) do
		ARCPhone.GetPlayerFromPhoneNumber(v).ARCPhone_Status = ARCPHONE_ERROR_CALL_DROPPED
	end
	for k,v in pairs(ARCPhone.Calls[line].pending) do
		ARCPhone.GetPlayerFromPhoneNumber(v).ARCPhone_Status = ARCPHONE_ERROR_CALL_DROPPED
	end
	ARCPhone.Calls[line] = nil
end
function ARCPhone.HangUpAllFromCall(line) 
	for k,v in pairs(ARCPhone.Calls[line].on) do
		--MsgN("HANG UP ALL "..v)
		ARCPhone.GetPlayerFromPhoneNumber(v).ARCPhone_Status = ARCPHONE_ERROR_CALL_ENDED
	end
	for k,v in pairs(ARCPhone.Calls[line].pending) do
		ARCPhone.GetPlayerFromPhoneNumber(v).ARCPhone_Status = ARCPHONE_ERROR_CALL_ENDED
	end
	ARCPhone.Calls[line] = nil
end
function ARCPhone.HangUp(number)
	local ply = ARCPhone.GetPlayerFromPhoneNumber(number)
	for k,v in pairs(ARCPhone.Calls) do
		if table.RemoveByValue(v.on,number) || table.RemoveByValue(v.pending,number) then
			ply.ARCPhone_Status = ARCPHONE_ERROR_CALL_ENDED
			if #v.on < 2 then
				ARCPhone.HangUpAllFromCall(k) 
			end
		end
	end
end
function ARCPhone.AddToCall(caller,reciever)
	if !ARCLib.RecursiveHasValue(ARCPhone.Calls,caller) then
		ARCPhone.MakeCall(caller,reciever)
	else
		local line = ARCPhone.GetLineFromCaller(caller)
		if #reciever != 10 then -- Check if it's a 10 digit number
			return 
		end
		
		local plyrec = ARCPhone.GetPlayerFromPhoneNumber(reciever)
		
		if !plyrec:IsPlayer() then
			return 
		end
		
		local phonerec = plyrec:GetWeapon("weapon_arc_phone") 
		-- 15

		if ARCPhone.EntGetReception(phonerec) < 7 then
			return 
		end
		if line == -1 then return end
		--MsgN("Line: "..line)
		
		table.insert(ARCPhone.Calls[line].pending,reciever)
		plyrec.ARCPhone_Status = ARCPHONE_ERROR_RINGING
	end
end

function ARCPhone.SendTextMsg(tonum,fromnum,msg)
	local hash = ARCLib.md5(msg)
	if !ARCPhone.Disk.Texts[tonum] then
		ARCPhone.Disk.Texts[tonum] = {}
	end
	ARCPhone.Disk.Texts[tonum][hash] = {}
	ARCPhone.Disk.Texts[tonum][hash].msg = msg
	ARCPhone.Disk.Texts[tonum][hash].number = fromnum
	ARCPhone.Disk.Texts[tonum][hash].place = -1
end

local refr = -15
local trefr = -2
function ARCPhone.Think()
	--MsgN("Update Status")
	for k,v in pairs(player.GetAll()) do
		--MsgN("Status of "..v:Nick())
		if !v.ARCPhone_Status then
			v.ARCPhone_Status = ARCPHONE_ERROR_CALL_ENDED
		end
		if !v.ARCPhone_Reception then
			v.ARCPhone_Reception = 0
		end
		if refr > 3 then
			v.ARCPhone_Reception = ARCPhone.GetReception(v)
		end
		local vnum = ARCPhone.GetPhoneNumber(v)
		if trefr > 1 then
			if v.ARCPhone_Reception > 10 then
				for kk,vv in pairs(ARCPhone.Disk.Texts[vnum]) do
					if vv.place == -1 then
						vv.place = 0
						-- Send dummy message
						net.Start("arcphone_comm_text")
						net.WriteInt(0,8)
						net.WriteUInt(0,32)
						net.WriteUInt(#vv.msg,32)
						net.WriteString(kk) --Hash
						net.WriteString(vv.number) --Number
						net.Send(v)
					end
				end
			end
		end
		--MsgN("Texting Refresh done - "..v:Nick())
		net.Start("arcphone_comm_status")
		net.WriteInt(v.ARCPhone_Reception,8)
		net.WriteInt(v.ARCPhone_Status,ARCPHONE_ERRORBITRATE)
		local line = ARCPhone.GetLineFromCaller(vnum)
		--MsgN("Got line - "..v:Nick())
		if ARCPhone.Calls[line] then
			--MsgN("Line IsValid - "..v:Nick())
			local tab = {on = {},pending = {}}
			for k,v in pairs(ARCPhone.Calls[line].on) do
				table.insert(tab.on,v)
			end
			for k,v in pairs(ARCPhone.Calls[line].pending) do
				table.insert(tab.pending,v)
			end
			net.WriteTable(tab)
		else
			net.WriteTable({on = {},pending = {}})
		end
		net.Send(v)
		if v.ARCPhone_Status > 0 then
			v.ARCPhone_Status = ARCPHONE_ERROR_CALL_ENDED
		end
	end
	
	--MsgN("Update calls")
	for k,v in pairs(ARCPhone.Calls) do	
		--MsgN("Line "..tostring(v))
		for kk,vv in pairs(v.on) do
			--MsgN("      ON: "..tostring(vv))
			local ply = ARCPhone.GetPlayerFromPhoneNumber(vv)
			local rep = ARCPhone.GetReception(ply)
			if rep < 40 then
				local chance = math.random(0,rep)
				if chance < 5 then
					for kkk,vvv in pairs(v.on) do
						ARCPhone.GetPlayerFromPhoneNumber(vvv):ConCommand("play ambient/levels/prison/radio_random"..math.random(1,15)..".wav")
					end
				end
				if chance == 0 then
					ply.ARCPhone_Status = ARCPHONE_ERROR_CALL_DROPPED
					table.remove(v.on,kk)
				end
				if #v.on < 2 then
					ARCPhone.DropAllFromCall(k) 
				end
			end
		end
		--[[
		for kk,vv in pairs(v.pending) do
			
		end
		]]
	end
	
		if refr > 3 then
			refr = 1
		else
			refr = refr + 1
		end
		if trefr > 1 then
			trefr = 1
		else
			trefr = trefr + 1
		end
end
function ARCPhone.UpdateLang(lang)
--[[
	local lanstr = file.Read(ARCPhone.Dir.."/languages/"..lang..".txt","DATA")
	if lanstr && lanstr != "" then
		local tab = util.JSONToTable(lanstr)
		if tab then
			ARCPHONE_ERRORSTRINGS = tab.errmsgs
			ARCPhone.Msgs = tab.msgs
			ARCPhone.SettingsDesc = tab.settingsdesc
			--[[
			local translations = {}
			translations.errmsgs = ARCPHONE_ERRORSTRINGS
			translations.msgs = ARCPhone.Msgs
			translations.settingsdesc = ARCPhone.SettingsDesc
			--]
			ARCPhone.JSON_Lang = ARCLib.SplitString(lanstr,16384) -- Splitting the string every 16 kb just in case
			for k,v in pairs(player.GetHumans()) do
				net.Start("arcphone_comm_lang")
				net.WriteInt(0,ARCPHONE_ERRORBITRATE)
				v._ARCPhone_Lang_Place = 0
				net.WriteUInt(0,32)
				net.WriteUInt(#ARCPhone.JSON_Lang,32)
				net.WriteString("")
				net.Send(v)
			end
		else
			ARCPhoneMsg("WARNING! The language file '"..tostring(lang).."' is not a valid JSON file!")
		end
	else
		ARCPhoneMsg("WARNING! The language file '"..tostring(lang).."' wasn't found!")
	end
	--]]
end
function ARCPhone.Load()
	ARCPhone.Loaded = false
		if #player.GetAll() == 0 then
			ARCPhoneMsg("A player must be online before continuing...")
		end
		timer.Simple(1,function()
		
		if game.SinglePlayer() then
			ARCPhoneMsg("CRITICAL ERROR! THIS IS A SINGLE PLAYER GAME!")
			ARCPhoneMsg("LOADING FALIURE!")
			return
		end
		if !file.IsDir( ARCPhone.Dir,"DATA" ) then
			ARCPhoneMsg("Created Folder: "..ARCPhone.Dir)
			file.CreateDir(ARCPhone.Dir)
		end
		
		if !file.IsDir( ARCPhone.Dir,"DATA" ) then
			ARCPhoneMsg("CRITICAL ERROR! FAILED TO CREATE ROOT FOLDER!")
			ARCPhoneMsg("LOADING FALIURE!")
			return
		end
		if file.Exists(ARCPhone.Dir.."/__data.txt","DATA") then
			ARCPhone.Disk = util.JSONToTable(file.Read( ARCPhone.Dir.."/__data.txt","DATA" ))
		end
		ARCPhone.Disk.Texts = ARCPhone.Disk.Texts or {}
		if ARCPhone.Disk.ProperShutdown then
			ARCPhone.Disk.ProperShutdown = false
		else
			ARCPhoneMsg("WARNING! THE SYSTEM DIDN'T SHUT DOWN PROPERLY!")
		end
		
		if file.Exists(ARCPhone.Dir.."/_saved_settings.txt","DATA") then
			local disksettings = util.JSONToTable(file.Read(ARCPhone.Dir.."/_saved_settings.txt","DATA"))
			if disksettings then
				for k,v in pairs(ARCPhone.Settings) do
					if disksettings[k] || isbool(disksettings[k]) then
						ARCPhone.Settings[k] = disksettings[k]
					else
						ARCPhoneMsg(""..k.." not found in disk settings. Possibly out of date. Using default.")
					end
				end
				ARCPhoneMsg("Settings succesfully set.")
			else
				ARCPhoneMsg("Settings file is corrupt or something! Using defaults.")
			end
		else
			ARCPhoneMsg("No settings file found! Using defaults.")
		end
		--[[
		if !file.IsDir( ARCPhone.Dir.."/languages","DATA" ) then
			ARCPhoneMsg("Created Folder: "..ARCPhone.Dir.."/languages")
			file.CreateDir(ARCPhone.Dir.."/languages")
		end	
		file.Write(ARCPhone.Dir.."/languages/en.txt", file.Read( "arcphone/data/languages/en.lua", "LUA" ) )
		--end
		ARCPhone.UpdateLang(ARCPhone.Settings["language"])
		]]
		
		--MORE FOLDER CREATIONS HERE
		
		
		ARCPhone.LogFile = os.date(ARCPhone.Dir.."/systemlog - %d %b %Y - "..tostring(os.date("%H")*60+os.date("%M"))..".log.txt")
		file.Write(ARCPhone.LogFile,"***ARCPhone System Log***    \nIT IS RECCOMENDED TO USE NOTEPAD++ TO VIEW THIS FILE!    \nDates are in DD-MM-YYYY\n")
		ARCPhone.LogFileWritten = true
		ARCPhoneMsg("Log File Created at "..ARCPhone.LogFile)
		
		--[[
		if timer.Exists( "ARCPHONE_TAKRCOST" ) then
			ARCPhoneMsg("Stopping current cost timer...")
			timer.Destroy( "ARCPHONE_TAKRCOST" )
		end
		ARCPhoneMsg("Billing periods are every "..ARCLib.TimeString(ARCPhone.Settings["cost_time"]*3600))
		timer.Create( "ARCPHONE_TAKRCOST", ARCPhone.Settings["cost_time"]*3600, 0, ARCPhone.TakeCosts )
		timer.Start( "ARCPHONE_TAKRCOST" ) 
		]]
		for k,v in pairs(player.GetAll()) do
				v.ARCPhone_Reception = 0
				v.ARCPhone_Status = ARCPHONE_ERROR_CALL_DROPPED
				net.Start("arcphone_comm_status")
				net.WriteInt(v.ARCPhone_Reception,8)
				net.WriteInt(v.ARCPhone_Status,ARCPHONE_ERRORBITRATE)
				net.WriteTable({on = {},pending = {}})
				net.Send(v)
		end
		if timer.Exists( "ARCPHONE_SAVEDISK" ) then
			ARCPhoneMsg("Stopping current savedisk timer...")
			timer.Destroy( "ARCPHONE_SAVEDISK" )
		end
		timer.Create( "ARCPHONE_SAVEDISK", 300, 0, function() 
			file.Write(ARCPhone.Dir.."/__data.txt", util.TableToJSON(ARCPhone.Disk) )
			--ARCPhone.UpdateLang(ARCPhone.Settings["atm_language"])

			if !ARCPhone.Settings["notify_update"] then return end
			http.Fetch( "http://www.aritzcracker.ca/arcphoneversion.txt",
				function( body, len, headers, code )
					if code == 200 then
						ARCPhone.Outdated = !string.find(body,"--ARCPhone Version "..ARCPhone.Version.."--")
						if ARCPhone.Outdated then
							ARCPhoneMsg("ARCPhone is out of date!")
						end
					else
						ARCPhoneMsg("FAILED TO CHECK FOR UPDATES! (HTTP Status "..code..") I'll check again later.")
					end
				end,
				function( err )
					ARCPhoneMsg("FAILED TO CHECK FOR UPDATES! ("..err..") I'll check again later.")
				end
			)
			
		end )
		timer.Start( "ARCPHONE_SAVEDISK" ) 
		if timer.Exists( "ARCPHONE_THINK" ) then
			ARCPhoneMsg("Stopping current think timer...")
			timer.Destroy( "ARCPHONE_THINK" )
		end
		timer.Create( "ARCPHONE_THINK", 1.337, 0, ARCPhone.Think)
		timer.Start( "ARCPHONE_THINK" ) 
		ARCPhoneMsg("ARCPhone is ready!")
		ARCPhone.Loaded = true
		ARCPhone.Busy = false
	end)
end

