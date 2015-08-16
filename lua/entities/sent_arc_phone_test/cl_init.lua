-- This shit is under copyright.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.
include('shared.lua')
function ENT:Initialize()
end

function ENT:Think()

end

function ENT:OnRestore()
end

hook.Add( "CalcView", "ARCPhone testview",function( ply, pos, angles, fov ) --Good
	local ent = ents.FindByClass("sent_arc_phone_test")[1]
	if IsValid(ent) then
		local view = {}
		view.origin = ent:GetPos() + (ent:GetAngles():Up() * 5)
		view.angles = ent:LocalToWorldAngles(Angle(90,90,0))
		--ply:SetEyeAngles(  )
		view.fov = fov
		
		return view
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

