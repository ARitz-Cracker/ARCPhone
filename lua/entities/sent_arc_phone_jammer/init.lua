-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
ENT.ARitzDDProtected = true
util.AddNetworkString("ARCJammer")
function ENT:Initialize()
	self:SetModel( "models/ap/box/blocker.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self.phys = self:GetPhysicsObject()
	if self.phys:IsValid() then
		self.phys:Wake()
	end
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.StartTime = CurTime() + 5
	self.Jamming = false
	self.Opened = false
	self:SetUseType( SIMPLE_USE )
	self.AnimEndTime = CurTime()
	self.AnimScale = 0.5
	self.AnimTime = 0
end
function ENT:SpawnFunction( ply, tr )
 	if ( !tr.Hit ) then return end
	local blarg = ents.Create ("sent_arc_phone_jammer")
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

end

function ENT:Use( ply, caller )--self:StopHack()

end
function ENT:ToggleJammer()
	if self.Opened then
		self:EmitSound("arcphone/jammer/knobturn"..math.random(1,3)..".wav",65,120)
		self.Jamming = !self.Jamming
		if self.Jamming then
			self:ARCLib_SetAnimationTime("reload" ,0.2)
		else
			self:ARCLib_SetAnimationTime("throw" ,0.2)
		end
	end
	net.Start("ARCJammer")
	net.WriteBit(self.Jamming)
	net.WriteBit(self.Opened)
	net.WriteEntity(self.Entity)
	net.Broadcast()
end
function ENT:ToggleOpen()
	if self.Opened then
		self:ARCLib_SetAnimationTime("secondaryattack",0.5)
			self.Opened = false
			timer.Simple(0.4,function() self:EmitSound("vehicles/atv_ammo_close.wav") end)
			timer.Simple(0.55,function()
				self:ARCLib_SetAnimationTime("idle",0)
			end)
			if self.Jamming then
				self:EmitSound("arcphone/jammer/knobturn"..math.random(1,3)..".wav",65,120)
				self.Jamming = false
			end
	else
		self:ARCLib_SetAnimationTime("primaryattack",0.5)
		self:EmitSound("vehicles/atv_ammo_open.wav")
		self.Opened = true
		timer.Simple(0.55,function()
			self:ARCLib_SetAnimationTime("draw",0)
		end)
	end
	net.Start("ARCJammer")
	net.WriteBit(self.Jamming)
	net.WriteBit(self.Opened)
	net.WriteEntity(self.Entity)
	net.Broadcast()
end
net.Receive("ARCJammer",function(len,ply)
	local tr = ply:GetEyeTrace()
	local status = tobool(net.ReadBit())
	if status then
		local jammer = net.ReadEntity()
		net.Start("ARCJammer")
		net.WriteBit(jammer.Jamming)
		net.WriteBit(jammer.Opened)
		net.WriteEntity(jammer)
		net.Send(ply)
	else
		if tr.Entity.IsARCJammer and ply:GetShootPos():DistToSqr(tr.HitPos) < 8282 then
			local open = tobool(net.ReadBit()) 
			if open then
				tr.Entity:ToggleOpen()
			else
				tr.Entity:ToggleJammer()
			end
		end
	end
end)