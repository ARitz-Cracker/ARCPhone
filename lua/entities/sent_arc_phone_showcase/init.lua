-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
function ENT:Initialize()
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
	local blarg = ents.Create ("sent_arc_phone_showcase")
	blarg:SetPos(tr.HitPos + tr.HitNormal * 40)
	blarg:Spawn()
	blarg.SpawnerGuy = ply
	blarg:Activate()
	return blarg
end

function ENT:Think()

end

function ENT:OnRemove()

end

function ENT:Use( ply, caller )--self:StopHack()

end
