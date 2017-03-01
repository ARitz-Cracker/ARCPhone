-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
local APP = ARCPhone.NewServerAppObject()
APP.Number = "0000000002" -- Boring, I know. I guess 0000000 to 0000099 is reserved for me, then



function APP:OnText(num,data)
	MsgN("SETTINGS APP GOT TEXT FROM "..num)
	local args = string.Explode( " ", data )
	if args[1] == "p" then -- privacy
		local ply = ARCPhone.GetPlayerFromPhoneNumber(num)
		if IsValid(ply) then
			ply._ARCPhone_Privacy = tobool(args[2])
		end
	end
end
ARCPhone.RegisterServerApp(APP)