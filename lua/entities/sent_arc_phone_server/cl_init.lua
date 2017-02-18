-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016 Aritz Beobide-Cardinal All rights reserved.
include('shared.lua')
function ENT:Initialize()

end

function ENT:Think()

end

function ENT:OnRestore()
end
local function FakeConsole()
	surface.SetDrawColor(0,0,0,255)
	surface.DrawRect(0,0,32,32)
	surface.SetDrawColor(0,255,0,255)
	surface.DrawRect(2,2,28,2)
	
	surface.DrawRect(2,5,10,2)
	surface.DrawRect(13,5,10,2)
	surface.DrawRect(2,8,3,2)
	surface.DrawRect(6,8,22,2)
	surface.DrawRect(2,11,5,2)
	surface.DrawRect(8,11,9,2)
	surface.DrawRect(18,11,12,2)
	surface.DrawRect(2,14,12,2)
	if math.sin(CurTime()*4*math.pi) > 0 then
		surface.DrawRect(15,14,1,2)
	end
end
local function FakeConsole2(speed)
	surface.SetDrawColor(0,0,0,255)
	surface.DrawRect(0,0,32,32)
	surface.SetDrawColor(0,255,0,255)
	
	surface.DrawRect(2,(((CurTime()*speed)+2)%33)*-1+30,28,2)
	surface.DrawRect(2,(((CurTime()*speed)+5)%33)*-1+30,10,2)
	surface.DrawRect(13,(((CurTime()*speed)+5)%33)*-1+30,10,2)
	surface.DrawRect(2,(((CurTime()*speed)+8)%33)*-1+30,3,2)
	surface.DrawRect(6,(((CurTime()*speed)+8)%33)*-1+30,22,2)
	surface.DrawRect(2,(((CurTime()*speed)+11)%33)*-1+30,5,2)
	surface.DrawRect(8,(((CurTime()*speed)+11)%33)*-1+30,9,2)
	surface.DrawRect(18,(((CurTime()*speed)+11)%33)*-1+30,12,2)
	surface.DrawRect(2,(((CurTime()*speed)+14)%33)*-1+30,12,2)

	surface.DrawRect(2,(((CurTime()*speed)+17)%33)*-1+30,28,2)
	surface.DrawRect(2,(((CurTime()*speed)+20)%33)*-1+30,10,2)
	surface.DrawRect(13,(((CurTime()*speed)+20)%33)*-1+30,10,2)
	surface.DrawRect(2,(((CurTime()*speed)+23)%33)*-1+30,3,2)
	surface.DrawRect(6,(((CurTime()*speed)+23)%33)*-1+30,22,2)
	surface.DrawRect(2,(((CurTime()*speed)+26)%33)*-1+30,5,2)
	surface.DrawRect(8,(((CurTime()*speed)+26)%33)*-1+30,9,2)
	surface.DrawRect(18,(((CurTime()*speed)+26)%33)*-1+30,12,2)
	surface.DrawRect(2,(((CurTime()*speed)+29)%33)*-1+30,12,2)
	surface.DrawRect(2,(((CurTime()*speed)+32)%33)*-1+30,3,2)
	surface.DrawRect(6,(((CurTime()*speed)+32)%33)*-1+30,22,2)
	--[[
	surface.DrawRect(2,5,10,2)
	surface.DrawRect(13,5,10,2)
	surface.DrawRect(2,8,3,2)
	surface.DrawRect(6,8,22,2)
	surface.DrawRect(2,11,5,2)
	surface.DrawRect(8,11,9,2)
	surface.DrawRect(18,11,12,2)
	surface.DrawRect(2,14,12,2)
	if math.sin(CurTime()*4*math.pi) > 0 then
		surface.DrawRect(15,14,1,2)
	end
	]]
end

function ENT:Draw()
	self:DrawModel()
	self:DrawShadow( true )
	--[[
	--local DisplayPos = self:GetPos() + ((self:GetAngles():Up() * -0.41) + (self:GetAngles():Forward() * 5.7) + (self:GetAngles():Right() * 2.7 ))
	self.displayangle1 = self:GetAngles()
	self.displayangle1:RotateAroundAxis( self.displayangle1:Up(), 97.8 )
	self.displayangle1:RotateAroundAxis( self.displayangle1:Forward(), 90 )
	cam.Start3D2D(self:LocalToWorld(Vector(13.1,-3.55,42.55)), self.displayangle1, 0.23)
		FakeConsole()
	cam.End3D2D()
	self.displayangle1:RotateAroundAxis( self.displayangle1:Right(), 7.8 )
	cam.Start3D2D(self:LocalToWorld(Vector(12.62,-4.73,52.55)), self.displayangle1, 0.23)
		FakeConsole2(10)
	cam.End3D2D()
	]]
	--[[
	cam.Start3D2D(self:LocalToWorld(Vector(40,-5,53)), Angle(0,0,0), 1)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawRect(0,0,1,1)
	cam.End3D2D()
	]]
end

