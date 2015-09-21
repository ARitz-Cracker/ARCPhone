-- antspawn.lua - Antenna spawner
-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2015 Aritz Beobide-Cardinal All rights reserved.

function ARCPhone.SpawnAntennas()
	local shit = file.Read(ARCPhone.Dir.."/saved_atms/"..string.lower(game.GetMap())..".txt", "DATA" )
	if !shit then
		ARCPhoneMsg("Cannot spawn Antennas. No file associated with this map.")
		return false
	end
	local atmdata = util.JSONToTable(shit)
	if !atmdata then
		ARCPhoneMsg("Cannot spawn Antennas. Corrupt file associated with this map.")
		return false
	end
	for _, oldatms in pairs( ents.FindByClass("sent_arc_antenna") ) do
		oldatms.ARCPhone_MapEntity = false
		oldatms:Remove()
	end
	ARCPhoneMsg("Spawning Map Antennas...")
	for i=1,atmdata.atmcount do
			local shizniggle = ents.Create("sent_arc_antenna")
			if !IsValid(shizniggle) then
				atmdata.atmcount = 1
				ARCPhoneMsg("Antennas failed to spawn.")
			return false end
			if atmdata.pos[i] && atmdata.angles[i] then
				shizniggle:SetPos(atmdata.pos[i]+Vector(0,0,ARCLib.BoolToNumber(!atmdata.NewATMModel)*8.6))
				shizniggle:SetAngles(atmdata.angles[i])
				shizniggle:SetPos(shizniggle:GetPos()+(shizniggle:GetRight()*ARCLib.BoolToNumber(!atmdata.NewATMModel)*-4.1)+(shizniggle:GetForward()*ARCLib.BoolToNumber(!atmdata.NewATMModel)*19))
				if atmdata.atmtype then
					shizniggle.ARCPhone_InitSpawnType = atmdata.atmtype[i]
				end
				shizniggle:Spawn()
				shizniggle:Activate()
			else
				shizniggle:Remove()
				atmdata.atmcount = 1
				ARCPhoneMsg("Corrupt File")
				return false 
			end
			local phys = shizniggle:GetPhysicsObject()
			if IsValid(phys) then
				phys:EnableMotion( false )
			end
			shizniggle.ARCPhone_MapEntity = true
			shizniggle.ARitzDDProtected = true
	end
	return true
end
function ARCPhone.SaveAntennas()
	ARCPhoneMsg("Saving Antennas...")
	local atmdata = {}
	atmdata.angles = {}
	atmdata.pos = {}
	atmdata.atmtype = {}
	local atms = ents.FindByClass("sent_arc_antenna")
	atmdata.atmcount = table.maxn(atms)
	atmdata.NewATMModel = true
	if atmdata.atmcount <= 0 then
		ARCPhoneMsg("No Antennas to save!")
		return false
	end
	for i=1,atmdata.atmcount do
		local phys = atms[i]:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion( false )
		end
		atms[i].ARCPhone_MapEntity = true
		atms[i].ARitzDDProtected = true
		atmdata.pos[i] = atms[i]:GetPos()
		atmdata.angles[i] = atms[i]:GetAngles()
		atmdata.atmtype[i] = atms[i]:GetATMType()
	end
	PrintTable(atmdata)
	local savepos = ARCPhone.Dir.."/saved_atms/"..string.lower(game.GetMap())..".txt"
	file.Write(savepos,util.TableToJSON(atmdata))
	if file.Exists(savepos,"DATA") then
		ARCPhoneMsg("Antennas Saved in: "..savepos)
		return true
	else
		ARCPhoneMsg("Error while saving map.")
		return false
	end
end
function ARCPhone.UnSaveAntennas()
	ARCPhoneMsg("UnSaving Antennas...")
	local atms = ents.FindByClass("sent_arc_antenna")
	if table.maxn(atms) <= 0 then
		ARCPhoneMsg("No Antennas to Unsave!")
		return false
	end
	for i=1,table.maxn(atms) do
		local phys = atms[i]:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion( true )
		end
		atms[i].ARCPhone_MapEntity = false
		atms[i].ARitzDDProtected = false
	end
	local savepos = ARCPhone.Dir.."/saved_atms/"..string.lower(game.GetMap())..".txt"
	file.Delete(savepos)
	return true
end
function ARCPhone.ClearAntennas() -- Make sure this doesn't crash (dump %%CONFIRMATION_HASH%%)
	for _, oldatms in pairs( ents.FindByClass("sent_arc_antenna") ) do
		oldatms.ARCPhone_MapEntity = false
		oldatms:Remove()
	end
	ARCPhoneMsg("All Antennas Removed.")
end
