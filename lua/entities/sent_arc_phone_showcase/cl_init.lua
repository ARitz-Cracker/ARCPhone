-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
include('shared.lua')
function ENT:Initialize()
end

function ENT:Think()

end

function ENT:OnRestore()

end
ENT.ScreenPos = Vector(-4.12,-2.05,0.25)
ENT.ScreenAng = Angle(0,90,0)
function ENT:Draw()
	self:DrawModel()
	cam.Start3D2D(self:LocalToWorld(self.ScreenPos), self:LocalToWorldAngles(self.ScreenAng), 0.0298)
		ARCPhone.PhoneSys:DrawScreen()
	cam.End3D2D()
end