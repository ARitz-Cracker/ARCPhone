-- This shit is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

--ENUMS FOR ARC BANKING SYSTEM!
--137164355
ARCPhone = ARCPhone or {}
function ARCPhone.Msg(msg)
	Msg("ARCPhone: "..tostring(msg).."\n")
	if !ARCPhone then return end
	if ARCPhone.LogFileWritten then
		file.Append(ARCPhone.LogFile, os.date("%d-%m-%Y %H:%M:%S").." > "..tostring(msg).."\r\n")
	end
end
ARCPhone.Msg("Running...\n ____ ____ _ ___ ___     ____ ____ ____ ____ _  _ ____ ____    ___  _  _ ____ _  _ ____ \n |__| |__/ |  |    /     |    |__/ |__| |    |_/  |___ |__/    |__] |__| |  | |\\ | |___ \n |  | |  \\ |  |   /__    |___ |  \\ |  | |___ | \\_ |___ |  \\    |    |  | |__| | \\| |___ \n")
ARCPhone.Msg(table.Random({"RIIING RIIIING!!!","ARitz Cracker's NEXT BIG PROJECT!","fone","Call your friends!","Super fukin' Sexy edition!","3rd party app support!"}))
ARCPhone.Msg("© Copyright 2014 Aritz Beobide-Cardinal (ARitz Cracker) All rights reserved.")


ARCPhone.Update = "%%UPDATE%%"
ARCPhone.Version = "%%VERSION%%"

NULLFUNC = function(...) end

-- STATUSES
ARCPHONE_ERROR_RINGING = -4
ARCPHONE_ERROR_CALL_ENDED = -3
ARCPHONE_ERROR_ABORTED = -2
ARCPHONE_ERROR_DIALING = -1
ARCPHONE_ERROR_NONE = 0
ARCPHONE_NO_ERROR = 0
ARCPHONE_ERROR_CALL_RUNNING = 0

-- CALLING ERRORS
ARCPHONE_ERROR_UNREACHABLE = 1
ARCPHONE_ERROR_INVALID_CODE = 2
ARCPHONE_ERROR_TOO_MANY_CALLS = 3
ARCPHONE_ERROR_NUMBER_BLOCKED = 4
ARCPHONE_ERROR_BLOCKED_NUMBER = 4
ARCPHONE_ERROR_PLAYER_OFFLINE = 5
ARCPHONE_ERROR_BUSY = 6
ARCPHONE_ERROR_NIL_NUMBER = 7

-- DIALING ERRORS
ARCPHONE_ERROR_NO_RECEPTION = 16
ARCPHONE_ERROR_CALL_DROPPED = 17
ARCPHONE_ERROR_INVALID_PLAN = 18

--OTHER ERRORS
ARCPHONE_ERROR_NOT_LOADED = -127
ARCPHONE_ERROR_UNKNOWN = -128


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


ARCPhone.Msg("Version: "..ARCPhone.Version)
ARCPhone.Msg("Updated on: "..ARCPhone.Update)
if SERVER then
	util.AddNetworkString( "ARCPhone_Msg" )
	function ARCPhone.MsgCL(ply,msg)
		--net.Start( "ARCPhone_Msg" )
		--net.WriteString( msg )
		if !ply || !ply:IsPlayer() then
			ARCPhone.Msg(tostring(msg))
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
	function ARCPhone.MsgToServer(msg)
		net.Start( "ARCPhone_Msg" )
		net.WriteString( msg )
		net.SendToServer()
	end
end

