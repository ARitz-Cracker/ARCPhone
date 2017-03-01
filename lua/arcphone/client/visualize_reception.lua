-- visualize_reception.lua - Reception Visualizer 
-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
local renderAntennas = {}
local visualizeReception = true
local seeThroughWalls = true

local function DrawRenderSegments()
	if #renderAntennas == 0 then return end
	for k,renderSegments in ipairs(renderAntennas) do
		--MsgN(k)
		for i=0,#renderSegments-1 do
			for ii=0,#renderSegments[i]-2 do
				if renderSegments[i][ii] != vector_origin && renderSegments[i][ii+1] != vector_origin then
					render.DrawLine( renderSegments[i][ii], renderSegments[i][ii+1], Color(0,0,255,255), !seeThroughWalls )
				end
			end
			if renderSegments[i][#renderSegments-1] != vector_origin && renderSegments[i][0] != vector_origin then
				render.DrawLine( renderSegments[i][#renderSegments-1], renderSegments[i][0], Color(0,0,255,255), !seeThroughWalls ) 
			end
			for ii=0,#renderSegments[i]-1 do
				if renderSegments[i][ii] != vector_origin && renderSegments[i+1][ii] != vector_origin then
					render.DrawLine( renderSegments[i][ii], renderSegments[i+1][ii], Color(0,0,255,255), !seeThroughWalls )
				end
			end 
			
		end
	end
end

function ARCPhone.SeeReception()
	net.Start("arcphone_see_reception")
	net.SendToServer()
end


hook.Add( "PostDrawTranslucentRenderables", "ARCPhone VisualizeReception", function(wut,skybox)
	if skybox then return end
	local seg = 12
	if !visualizeReception then return end
	
	DrawRenderSegments()
end)

net.Receive("arcphone_see_reception",function(len)
	local rs = net.ReadTable()
	MsgN(rs)
	PrintTable(rs)
	renderAntennas = rs
	ARCPhone.renderAntennas = rs
end)

