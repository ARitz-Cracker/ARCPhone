-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016 Aritz Beobide-Cardinal All rights reserved.
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
ENT.ARitzDDProtected = true
util.AddNetworkString("arcphone_see_reception_line")
function ENT:Initialize()
	if #ents.FindByClass("sent_arc_phone_test") > 1 then
		ARCLib.NotifyBroadcast("There can only be 1 phone tester because I am a lazy programmer",NOTIFY_ERROR,5,true)
		self:Remove()
		return
	end
	self:SetModel( "models/ap/phone/phone_model.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self.phys = self:GetPhysicsObject()
	if self.phys:IsValid() then
		self.phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
end
function ENT:SpawnFunction( ply, tr )
 	if ( !tr.Hit ) then return end
	local blarg = ents.Create ("sent_arc_phone_test")
	blarg:SetPos(tr.HitPos + tr.HitNormal * 40)
	blarg:Spawn()
	blarg.SpawnerGuy = ply
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
	if !IsValid(self.SpawnerGuy) then 
		self:Remove()
		return
	end
	local debugTab = {}
	local rep = ARCPhone.GetReceptionFromPos(self:GetPos(),false,debugTab)
	
	net.Start("arcphone_see_reception_line")
	net.WriteUInt(rep,8)
	net.WriteTable(debugTab)
	net.Send(self.SpawnerGuy)
end

function ENT:OnRemove()

end

function ENT:Use( ply, caller )--self:StopHack()

end
