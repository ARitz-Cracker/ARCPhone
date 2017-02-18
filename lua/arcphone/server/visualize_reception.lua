-- visualize_reception.lua - Reception Visualizer 

-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016 Aritz Beobide-Cardinal All rights reserved.

local receptionPlayer = NULL
local progress = 0
local renderSegments
util.AddNetworkString( "arcphone_see_reception" ) 
ARCPhone.Loaded = false

local receptionThread
hook.Add( "Think", "ARCPhone SeeReceptionThink", function()
	if IsValid(receptionPlayer) and receptionPlayer:IsPlayer() then
		local done = false
		if receptionThread == nil then
			receptionThread = coroutine.create(ARCPhone.VisualizeRepThink) 
		else
			local stime = SysTime()
			while SysTime() - stime < 0.01 do
				if (coroutine.status(receptionThread) == "dead") then
					receptionThread = nil -- NEXT TICK!
					break
				else
					local succ,err = coroutine.resume(receptionThread)
					if !succ then
						error("Failed reception check! "..err)
						break
					end
				end
			end
		end
	end
end)


local distanceSteps = 50
local circleSegments = 58
function ARCPhone.VisualizeRepThink()
	if IsValid(receptionPlayer) and receptionPlayer:IsPlayer() then
		renderSegments = {}
		local radius = -distanceSteps
		while radius < ARCPhone.Settings["antenna_range"] do
			radius = radius + distanceSteps
			MsgN("Progress: "..tostring(radius/ARCPhone.Settings["antenna_range"]))
			for key, antenna in ipairs( ents.FindByClass("sent_arc_phone_antenna") ) do
				renderSegments[key] = renderSegments[key] or {}
				MsgN(key)
				for i = 0, circleSegments do
					renderSegments[key][i] = renderSegments[key][i] or {}
					local a = math.sin( i / circleSegments * math.pi)
					local az = math.cos( i / circleSegments * math.pi)
					for ii = 0, circleSegments do
						local aa = ( ii / circleSegments ) * 2 * math.pi 
						local pos = antenna:LocalToWorld(Vector(math.sin(aa)*radius*a,math.cos(aa)*radius*a, az*radius))
						if (util.IsInWorld(pos) ) then
							if ARCPhone.GetReceptionFromPos(pos,true) > 30 then
								--if radius >= ARCPhone.Settings["antenna_range"] then
									renderSegments[key][i][ii] = pos
								--else
									--renderSegments[k][i][ii] = vector_origin
								--end
							end
						end
						renderSegments[key][i][ii] = renderSegments[key][i][ii] || antenna:GetPos()
					end
				end
			end
		end
		if IsValid(receptionPlayer) and receptionPlayer:IsPlayer() then
			net.Start("arcphone_see_reception")
			net.WriteTable(renderSegments) -- todo: length is too long
			net.Send(receptionPlayer)
			receptionPlayer = null
		end
	end
end

local ThisWasAReallyBadIdea = true -- feel free to set this to true and run ARCPhone.SeeReception() on the client! Too much work went into this for it to be deleted
net.Receive("arcphone_see_reception",function(msgnlen,ply)
	if ThisWasAReallyBadIdea then
		ARCLib.NotifyBroadcast("This was an interesting, yet very bad idea.",NOTIFY_ERROR,5,true)
		return
	end
	if !ARCPhone.Loaded then
		ARCLib.NotifyPlayer(ply,"ARCPhone didn't load!",NOTIFY_ERROR,15,true)
	elseif IsValid(receptionPlayer) and receptionPlayer:IsPlayer() then
		ARCLib.NotifyPlayer(ply,"Someone is already loading reception information",NOTIFY_ERROR,15,true)
	else
		MsgN(ply)
		receptionPlayer = ply
		progress = 0
	end
end)