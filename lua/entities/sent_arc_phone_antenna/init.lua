-- This shit is under copyright.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
ENT.ARitzDDProtected = true
function ENT:Initialize()
	self:SetModel( "models/props_lab/powerbox01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self.phys = self:GetPhysicsObject()
	if self.phys:IsValid() then
		self.phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.StartTime = CurTime() + 5
end
function ENT:SpawnFunction( ply, tr )
 	if ( !tr.Hit ) then return end
	local blarg = ents.Create ("sent_arc_phone_antenna")
	blarg:SetPos(tr.HitPos + tr.HitNormal * 40)
	blarg:Spawn()
	blarg:Activate()
	return blarg
end
--[[
function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg); -- React physically when getting shot/blown
	self.OurHealth = self.OurHealth - dmg:GetDamage(); -- Reduce the amount of damage took from our health-variable
	MsgN(self.OurHealth)
	if(self.OurHealth <= 0) then -- If our health-variable is zero or below it
		
	end
end
]]
function ENT:Think()

--[[

	--RECEPTION TESTR CODE
	local testtab = {}

	local ply = ARCLib.GetNearestEntity(self:GetPos(),"weapon_arc_phone")
	local beginpos = ply:GetPos()
	local dis = beginpos:Distance(self:GetPos())
	-- Target - Source
	local ang = (beginpos - self:GetPos()):Angle()
	local totaldistace = 0
	local totalblock = 0
	local failsafe = 0
	while math.ceil(totaldistace) < math.floor(dis) && failsafe < 200 do
		failsafe = failsafe + 1
		local trace = util.TraceLine( {
			start = self:GetPos() + ang:Forward()*(totaldistace+5),
			endpos = self:GetPos() + ang:Forward()*(dis),
			filter = function( ent ) if ( ent:GetClass() == "sent_arc_radio_blocker" ) then return true end end
		} )
		trace.IsInWorld = util.IsInWorld(trace.HitPos) 
		--trace.FractionLeftSolid = trace.FractionLeftSolid^2
		MsgN(failsafe)
		PrintTable(trace)
		if !trace.IsInWorld then
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
	PrintMessage( HUD_PRINTTALK, "----------------------------------" )
	PrintMessage( HUD_PRINTTALK, "dis: "..math.Round(dis) )
	PrintMessage( HUD_PRINTTALK, "blk: "..totalblock )
	PrintMessage( HUD_PRINTTALK, "ttl: "..math.Round(totaldistace) )
	PrintMessage( HUD_PRINTTALK, "opr: "..failsafe )
	local mul = math.Clamp(((totalblock/ARCPhone.Settings["antenna_strength"]) - 1)*-1,0,1)^2
	local per = (-1*(3^((totaldistace-ARCPhone.Settings["antenna_range"])/500)) + 100)*mul
	PrintMessage( HUD_PRINTTALK, "mul: "..mul )
	PrintMessage( HUD_PRINTTALK, "per: "..math.Clamp(math.Round(per),0,100) )
	PrintMessage( HUD_PRINTTALK, "----------------------------------" )
]]

end

function ENT:OnRemove()
	if self.ARCPhone_MapEntity then
		timer.Simple(1,function()
			ARCPhone.SpawnAntennas()
		end)
	end
end
--[[
function ENT:Use( ply, caller )--self:StopHack()
	for i = 1,180 do
		local pos = Vector(math.cos(math.rad(i*2)),math.sin(math.rad(i*2)),math.tan(math.rad(i*2)))
		local e = ents.Create("sent_arc_phone_rangetester")
		e:SetPos(self:GetPos() + (pos * 40))
		e:Spawn()
	end
end
]]