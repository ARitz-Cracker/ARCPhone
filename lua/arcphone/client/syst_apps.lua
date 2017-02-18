-- syst_apps.lua - System Applications for ARCPhone
-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016 Aritz Beobide-Cardinal All rights reserved.
--[[

local APP = ARCPhone.NewAppObject()
APP.Name = "Test"
APP.Author = "ARitz Cracker"
APP.Purpose = "TestStuff for ARCPhone"

APP.Tiles[1] = ARCPhone.NewAppTile()
APP.Tiles[1].x = 0
APP.Tiles[1].y = 0
APP.Tiles[1].w = 32
APP.Tiles[1].h = 100
APP.Tiles[1].color = Color(math.random(1,255),math.random(1,255),math.random(1,255),255)

APP.Tiles[2] = ARCPhone.NewAppTile()
APP.Tiles[2].x = 40
APP.Tiles[2].y = -10
APP.Tiles[2].w = 32
APP.Tiles[2].h = 43
APP.Tiles[2].color = Color(math.random(1,255),math.random(1,255),math.random(1,255),255)

APP.Tiles[3] = ARCPhone.NewAppTile()
APP.Tiles[3].x = 0
APP.Tiles[3].y = 120
APP.Tiles[3].w = 100
APP.Tiles[3].h = 43
APP.Tiles[3].color = Color(math.random(1,255),math.random(1,255),math.random(1,255),255)

APP.Tiles[4] = ARCPhone.NewAppTile()
APP.Tiles[4].x = 40
APP.Tiles[4].y = 50
APP.Tiles[4].w = 100
APP.Tiles[4].h = 43
APP.Tiles[4].color = Color(math.random(1,255),math.random(1,255),math.random(1,255),255)

APP.Tiles[5] = ARCPhone.NewAppTile()
APP.Tiles[5].x = 90
APP.Tiles[5].y = 0
APP.Tiles[5].w = 20
APP.Tiles[5].h = 43
APP.Tiles[5].color = Color(math.random(1,255),math.random(1,255),math.random(1,255),255)
--APP.Tiles[5].text =

APP.Tiles[6] = ARCPhone.NewAppTile()
APP.Tiles[6].x = 145
APP.Tiles[6].y = 20
APP.Tiles[6].w = 300
APP.Tiles[6].h = 100
APP.Tiles[6].color = Color(math.random(1,255),math.random(1,255),math.random(1,255),255)
APP.Tiles[6].text = "hadasdsadsdsadsaadagfadshfgydaaauasyuktfya78iugqasdsadasdasd"

APP.Tiles[7] = ARCPhone.NewAppTile()
APP.Tiles[7].x = 0
APP.Tiles[7].y = 350
APP.Tiles[7].w = 50
APP.Tiles[7].h = 300
APP.Tiles[7].color = Color(math.random(1,255),math.random(1,255),math.random(1,255),255)


ARCPhone.RegisterApp(APP,"test_multi")


]]















--[[
local APP = ARCPhone.NewAppObject()
APP.Name = "Test"
APP.Author = "ARitz Cracker"
APP.Purpose = "TestStuff for ARCPhone"
for i = 0,80 do
	APP.Tiles[i] = ARCPhone.NewAppTile()
	APP.Tiles[i].x = ((i%10)*40) + 8
	APP.Tiles[i].y = math.floor(i/10)*48 + 29
	APP.Tiles[i].w = 32
	APP.Tiles[i].h = 32
	local rr = math.random(1,255)
	local rg = math.random(1,255)
	local rb = math.random(1,255)
	APP.Tiles[i].color = Color(rr,rg,rb,255)
	APP.Tiles[i].OnPressed = function(phone)
		APP.Tiles[i].color = Color(rr,rg,rb,128)
	end
	APP.Tiles[i].OnUnPressed = function(phone)
		APP.Tiles[i].color = Color(rr,rg,rb,255)
	end
end

ARCPhone.RegisterApp(APP,"test")
]]





--ARCPhone.PhoneSys:OpenApp("callscreen")

