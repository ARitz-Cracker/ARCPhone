local APP = ARCPhone.NewServerAppObject()
APP.Number = "0000000001" -- Boring, I know. I gues 0000000 to 0000099 is reserved for me, then



function ARCPHONE_SERVERAPP:OnText(num,data)
	if data == "f" then
		local ply = ARCPhone.GetPlayerFromPhoneNumber(num)
		if IsValid(ply) then
			local pos = ply:GetPos()
			local people = player.GetHumans()
			local numbers = {}
			
			table.sort( people, function( a, b ) return a:GetPos():DistToSqr(pos) < b:GetPos():DistToSqr(pos) end )
			for i,v in ipairs(people) do
				if v != ply then
					table.insert(numbers,ARCPhone.GetPhoneNumber(v))
				end
			end
			self:SendText(num,table.concat(numbers, " "))
		end
	end
end