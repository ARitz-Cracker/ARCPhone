-- This shit is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

--ENUMS FOR ARC BANKING SYSTEM!
--137164355

function ARCPhoneMsg(msg)
	Msg("ARCPhone: "..tostring(msg).."\n")
	if !ARCPhone then return end
	if ARCPhone.LogFileWritten then
		file.Append(ARCPhone.LogFile, os.date("%d-%m-%Y %H:%M:%S").." > "..tostring(msg).."\r\n")
	end
end
ARCPhoneMsg("Running...\n ____ ____ _ ___ ___     ____ ____ ____ ____ _  _ ____ ____    ___  _  _ ____ _  _ ____ \n |__| |__/ |  |    /     |    |__/ |__| |    |_/  |___ |__/    |__] |__| |  | |\\ | |___ \n |  | |  \\ |  |   /__    |___ |  \\ |  | |___ | \\_ |___ |  \\    |    |  | |__| | \\| |___ \n")
ARCPhoneMsg(table.Random({"RIIING RIIIING!!!","ARitz Cracker's NEXT BIG PROJECT!","fone","Call your friends!","Super fukin' Sexy edition!","3rd party app support!"}))
ARCPhoneMsg("© Copyright 2014 Aritz Beobide-Cardinal (ARitz Cracker) All rights reserved.")

ARCPhone = ARCPhone or {}
ARCPhone.Update = "September 21st 2015"
ARCPhone.Version = "0.8.0"

NULLFUNC = function(...) end

-- STATUSES
ARCPHONE_ERRORSTRINGS = {}



ARCPHONE_ERROR_RINGING = -4
ARCPHONE_ERRORSTRINGS[-4] = "Incomming call"
ARCPHONE_ERROR_CALL_ENDED = -3
ARCPHONE_ERRORSTRINGS[-3] = "Call ended"
ARCPHONE_ERROR_ABORTED = -2
ARCPHONE_ERRORSTRINGS[-2] = "Operation Aborted"
ARCPHONE_ERROR_DIALING = -1
ARCPHONE_ERRORSTRINGS[-1] = "Dialing..."
ARCPHONE_ERROR_NONE = 0
ARCPHONE_ERRORSTRINGS[0] = "Call in progress"
ARCPHONE_NO_ERROR = 0
ARCPHONE_ERROR_CALL_RUNNING = 0
-- CALLING ERRORS
ARCPHONE_ERROR_UNREACHABLE = 1
ARCPHONE_ERRORSTRINGS[1] = "The person who you're trying to call is out of range"
ARCPHONE_ERROR_INVALID_CODE = 2
ARCPHONE_ERRORSTRINGS[2] = "Invalid call code"
ARCPHONE_ERROR_TOO_MANY_CALLS = 3
ARCPHONE_ERRORSTRINGS[3] = "All lines busy. Try again later."
ARCPHONE_ERROR_NUMBER_BLOCKED = 4
ARCPHONE_ERROR_BLOCKED_NUMBER = 4
ARCPHONE_ERRORSTRINGS[4] = "Number blocked/disconnected"
ARCPHONE_ERROR_PLAYER_OFFLINE = 5
ARCPHONE_ERRORSTRINGS[5] = "The person who you're trying to call is not in this area"
ARCPHONE_ERROR_BUSY = 6
ARCPHONE_ERRORSTRINGS[6] = "The person who you're trying to call is already in one"
ARCPHONE_ERROR_NIL_NUMBER = 7
ARCPHONE_ERRORSTRINGS[7] = "Invalid phone number"
-- DIALING ERRORS
ARCPHONE_ERROR_NO_RECEPTION = 16
ARCPHONE_ERRORSTRINGS[16] = "Not enough reception"
ARCPHONE_ERROR_CALL_DROPPED = 17
ARCPHONE_ERRORSTRINGS[17] = "Call dropped"
ARCPHONE_ERROR_INVALID_PLAN = 18
ARCPHONE_ERRORSTRINGS[18] = "Your phone plan doesn't support this"

--OTHER ERRORS
ARCPHONE_ERROR_NOT_LOADED = -127
ARCPHONE_ERRORSTRINGS[-127] = "The ARCPhone system failed to load."
ARCPHONE_ERROR_UNKNOWN = -128
ARCPHONE_ERRORSTRINGS[-128] = "Unknown Error. Try again later."

ARCPHONE_ERRORBITRATE = 8

--Message box types
ARCPHONE_MSGBOX_OK = 1
ARCPHONE_MSGBOX_YESNO = 2
ARCPHONE_MSGBOX_OKCANCEL = 3
ARCPHONE_MSGBOX_RETRYABORT = 4
ARCPHONE_MSGBOX_REPLY = 5
ARCPHONE_MSGBOX_YESNOCANCEL = 6
ARCPHONE_MSGBOX_ABORTRETRYIGNORE = 7
ARCPHONE_MSGBOX_CALL = 8


ARCPhoneMsg("Version: "..ARCPhone.Version)
ARCPhoneMsg("Updated on: "..ARCPhone.Update)
if SERVER then
	util.AddNetworkString( "ARCPhone_Msg" )
	function ARCPhoneMsgCL(ply,msg)
		--net.Start( "ARCPhone_Msg" )
		--net.WriteString( msg )
		if !ply || !ply:IsPlayer() then
			ARCPhoneMsg(tostring(msg))
		else
			ply:PrintMessage( HUD_PRINTTALK, "ARCPhone: "..tostring(msg))
			--net.Send(ply)
		end
	end
	net.Receive( "ARCPhone_Msg", function(length,ply)
		local msg = net.ReadString() 
		MsgN("ARCPhone - "..ply:Nick().." ("..ply:SteamID().."): "..msg)
	end)
else

	net.Receive( "ARCPhone_Msg", function(length)
		local msg = net.ReadString() 
		MsgC(Color(255,255,255,255),"ARCPhone Server: "..tostring(msg).."\n")
	end)
	function ARCPhoneMsgToServer(msg)
		net.Start( "ARCPhone_Msg" )
		net.WriteString( msg )
		net.SendToServer()
	end
end

