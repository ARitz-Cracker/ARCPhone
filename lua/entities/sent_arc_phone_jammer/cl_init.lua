-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.

include('shared.lua')
function ENT:Initialize()
	self.Jamming = false
	--Special thanks to swep construction kit
	local selectsprite = { sprite = "effects/yellowflare", nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
	local name = selectsprite.sprite.."-"
	local params = { ["$basetexture"] = selectsprite.sprite }
	local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
	for i, j in pairs( tocheck ) do
		if (selectsprite[j]) then
			params["$"..j] = 1
			name = name.."1"
		else
			name = name.."0"
		end
	end
	self.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
	self.buttonpos = {}
	self.buttonglow = {}
end

function ENT:Think()

end

function ENT:Draw()--Good
	self:DrawModel()
	self:DrawShadow( true )
	if self.Jamming then
		render.SetMaterial(self.spriteMaterial)
		self.buttonglow[1] = math.sin(CurTime()*math.pi) > 0
		self.buttonglow[2] = math.sin((CurTime()+0.5)*math.pi) > 0
		self.buttonglow[3] = math.sin((CurTime())*math.pi*2) > 0
		self.buttonpos[1] = self:GetPos() + ((self:GetAngles():Up() * 5.5) + (self:GetAngles():Forward() * 0.88) + (self:GetAngles():Right() * -13))
		self.buttonpos[2] = self:GetPos() + ((self:GetAngles():Up() * 5.5) + (self:GetAngles():Forward() * 0.88) + (self:GetAngles():Right() * -6.1))
		self.buttonpos[3] = self:GetPos() + ((self:GetAngles():Up() * 5.5) + (self:GetAngles():Forward() * 0.88) + (self:GetAngles():Right() * 0.5))
		self.buttonpos[4] = self:GetPos() + ((self:GetAngles():Up() * 5.5) + (self:GetAngles():Forward() * 0.88) + (self:GetAngles():Right() * 7.25))
		self.buttonpos[5] = self:GetPos() + ((self:GetAngles():Up() * 5.5) + (self:GetAngles():Forward() * 0.88) + (self:GetAngles():Right() * 14))
		for i=1,5 do
			if self.buttonglow[i] then
				render.DrawSprite(self.buttonpos[i], 6.5, 6.5, Color(255,0,0,255))
			end
		end
	end
end
function ENT:OnRestore()
end
local ARCJammerTime = CurTime()
local ARCJammerValid = false
hook.Add("HUDPaint", "ARCPhone JammerHud", function()
	surface.SetDrawColor( 255, 255, 255, math.Clamp((((ARCJammerTime - CurTime())/0.5 -1)*-1)*255,0,255) )
	if ARCJammerValid then
		local tr = LocalPlayer():GetEyeTrace()
		if tr.Entity.IsARCJammer && LocalPlayer():GetShootPos():DistToSqr(tr.HitPos) < 8282 then
			if ARCJammerTime <= CurTime() then
				surface.SetMaterial(ARCLib.Icons16["lock_open"])
			else
				surface.SetMaterial(ARCLib.Icons16["lock"])
			end
			surface.DrawTexturedRect( ScrW()*0.5-16, ScrH()*0.5-16, 32, 32 )
		else
			ARCJammerValid = false
		end
	end
end)
hook.Add("KeyPress", "ARCPhone JammerPress", function(ply,key)
	if ply == LocalPlayer() && key == IN_USE then -- I dunno. Just in case I guess?
		local tr = ply:GetEyeTrace()
		if tr.Entity.IsARCJammer && ply:GetShootPos():DistToSqr(tr.HitPos) < 8282 then
			ARCJammerValid = true
			ARCJammerTime = CurTime() + 0.5
		end
	end
end)
hook.Add("KeyRelease", "ARCPhone JammerUnPress", function(ply,key)
	if ply == LocalPlayer() && key == IN_USE && ARCJammerValid then -- I dunno. Just in case I guess?
		local tr = ply:GetEyeTrace()
		if tr.Entity.IsARCJammer && ply:GetShootPos():DistToSqr(tr.HitPos) < 8282 then
			net.Start("ARCJammer")
			net.WriteBit(ARCJammerTime <= CurTime())
			net.WriteEntity(tr.Entity)
			net.SendToServer()
		end
		ARCJammerValid = false
	end
end)
net.Receive("ARCJammer",function(len,ply)
	local open = tobool(net.ReadBit()) 
	local jammer = net.ReadEntity()
	if !IsValid(jammer) then return end
	jammer.Jamming = open
end)

hook.Add( "PostDrawTranslucentRenderables", "ARCPhone VisualizeReceptionJammer", function(wut,skybox)
	if skybox then return end
	local ent = ents.FindByClass("sent_arc_phone_test")[1]
	if IsValid(ent) then
		for k,v in pairs(ents.FindByClass("sent_arc_phone_jammer")) do
			if v.Jamming then
				render.DrawWireframeSphere( v:GetPos(), ARCPhone.Settings["jammer_range"], 32,32, Color(255,0,0,255), true ) 
			end
		end
	end
end)
--[[
local curtab = {}
net.Receive( "ARCDEVTESTPHONE", function(length)
	curtab = net.ReadTable()
end)
hook.Add("HUDPaint", "ARCVisionHUD", function()
	for k,v in pairs(curtab) do
		local spos = v.StartPos:ToScreen()
		local epos = v.HitPos:ToScreen()
		draw.SimpleText("S", "default", spos.x,spos.y, Color(0,255,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER)
		draw.SimpleText("E", "default", epos.x,epos.y, Color(255,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER)
		if !v.IsInWorld then
			surface.SetDrawColor(255,0,0,255)
		elseif v.HitNoDraw then
			surface.SetDrawColor(255,255,0,255)
		else
			surface.SetDrawColor(0,0,255,255)
		end
		surface.DrawLine(spos.x,spos.y,epos.x,epos.y)
	end
end)
]]

