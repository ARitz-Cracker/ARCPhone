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
--[[
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
]]

local curtab = {}
local rep = 0
net.Receive( "arcphone_see_reception_line", function(length)
	rep = net.ReadUInt(8)
	curtab = net.ReadTable()
end)
hook.Add("HUDPaint", "ARCPhone ReceptionLine", function()
	local ent = ents.FindByClass("sent_arc_phone_test")[1]
	if IsValid(ent) && curtab.len then
		local reppos = ent:GetPos():ToScreen()
		
		for i=1,curtab.len do
			local spos = curtab.startLines[i]:ToScreen()
			local epos = curtab.endLines[i]:ToScreen()
			--draw.SimpleText("S", "default", spos.x,spos.y, Color(0,255,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER)
			--draw.SimpleText("E", "default", epos.x,epos.y, Color(255,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER)
			surface.SetDrawColor(curtab.colour[i])
			surface.DrawLine(spos.x,spos.y,epos.x,epos.y)
		end
		draw.SimpleText("Total reception: "..rep, "default", reppos.x,reppos.y, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER)
		
		
		for i=1,curtab.antlen do
			local apos = curtab.antpos[i]:ToScreen()
			draw.SimpleText("Reception without walls: "..math.Round(curtab.antrange[i]), "default", apos.x,apos.y-12, color_white, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER)
			draw.SimpleText("Wall percentage: "..math.Round(curtab.antblock[i]), "default", apos.x,apos.y, color_white, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER)
			draw.SimpleText("Reception with walls: "..math.Round(curtab.anttotal[i]), "default", apos.x,apos.y+12, color_white, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER)
		end
	end
end)

