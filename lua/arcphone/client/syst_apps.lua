-- syst_apps.lua - System Applications for ARCPhone
-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- � Copyright 2014 Aritz Beobide-Cardinal All rights reserved.
--hsaaaasaaaa


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

APP = ARCPhone.NewAppObject()
APP.Name = "Home"
APP.Author = "ARitz Cracker"
APP.Purpose = "Home screen for ARCPhone"
APP.Options[2] = {}
APP.Options[2].text = "Customize"
APP.Options[2].func = function(phone,app) 
	if app.Customize then
		app:EndCustomization()
	else
		app:StartCustomization()
	end
end
function APP:Init()
	if #self.Disk == 0 then
		self.Disk = {{x=0,y=0,size=0,name="Call",flaticon=true,texture="phone",app="dialer"},{x=1,y=0,size=0,name="Test",flaticon=true,texture="box",app="test"},{x=2,y=0,size=0,name="Mutli-size test",flaticon=true,texture="box",app="test_multi"},{x=3,y=0,size=0,name="Messaging",flaticon=true,texture="comments",app="messaging"},{x=0,y=1,size=0,name="Settings",flaticon=true,texture="settings",app="settings"},{x=1,y=1,size=0,name="Timer",flaticon=true,texture="timer",app="timer"},{x=2,y=1,size=1,name="Console",flaticon=true,texture="terminal",app="test_multi"},{x=0,y=2,size=1,name="Contacts",flaticon=true,texture="people",app="contacts"}}
	end
	self.Tiles = {}
	for i =1,#self.Disk do
		self.Tiles[i] = ARCPhone.NewAppTile()
		self.Tiles[i].x = (self.Disk[i].x*32) + 6
		self.Tiles[i].y = self.Disk[i].y*32 + 29
		if self.Disk[i].size == 0 then
			self.Tiles[i].w = 30
			self.Tiles[i].h = 30
		elseif self.Disk[i].size == 1 then
			self.Tiles[i].w = 62
			self.Tiles[i].h = 62
			self.Tiles[i].text = self.Disk[i].name
		end
		if self.Disk[i].flaticon then
			self.Tiles[i].tex = ARCLib.FlatIcons64[self.Disk[i].texture]
		else
			self.Tiles[i].tex = surface.GetTextureID(self.Disk[i].texture)
		end
		self.Tiles[i].color = Color(255,255,255,255)
		self.Tiles[i].bgcolor = Color(25,25,255,255)
		self.Tiles[i].OnPressed = function(phone,app)
			app.Tiles[i].bgcolor = Color(25,25,255,128)
			app.Tiles[i].color = Color(255,255,255,128)
		end
		self.Tiles[i].OnUnPressed = function(phone,app)
			app.Tiles[i].bgcolor = Color(25,25,255,255)
			app.Tiles[i].color = Color(255,255,255,255)
			if self.Disk[i].app == "$folder" then
			
			else
				phone:OpenApp(self.Disk[i].app)
			end
		end
	end
	if self.Customize then
		self:StartCustomization()
	end
end
function APP:ForegroundThink()
	
	if self.Customize then
		for i =1,#self.Disk do
			if self.Tiles[i].moving then
				self.Tiles[i].x = (self.Disk[i].x*32) + 6
				self.Tiles[i].y = self.Disk[i].y*32 + 29
			else
				self.Tiles[i].x = (self.Disk[i].x*32) + 6 + self.Tiles[i].swivxend*(ARCLib.BetweenNumberScale(self.Tiles[i].swivxstarttime,CurTime(),self.Tiles[i].swivxendtime)) + self.Tiles[i].swivxstart*(ARCLib.BetweenNumberScaleReverse(self.Tiles[i].swivxstarttime,CurTime(),self.Tiles[i].swivxendtime))
				self.Tiles[i].y = self.Disk[i].y*32 + 29 + self.Tiles[i].swivyend*(ARCLib.BetweenNumberScale(self.Tiles[i].swivystarttime,CurTime(),self.Tiles[i].swivyendtime)) + self.Tiles[i].swivystart*(ARCLib.BetweenNumberScaleReverse(self.Tiles[i].swivystarttime,CurTime(),self.Tiles[i].swivyendtime))
			end
			if self.Tiles[i].swivxendtime < CurTime() then
				self.Tiles[i].swivxstart = self.Tiles[i].swivxend
				self.Tiles[i].swivystart = self.Tiles[i].swivyend
				self.Tiles[i].swivxend = math.Rand(-2,6)
				self.Tiles[i].swivyend = math.Rand(-2,6)
				self.Tiles[i].swivxstarttime = CurTime()
				self.Tiles[i].swivystarttime = CurTime()
				self.Tiles[i].swivxendtime = CurTime() + math.Rand(1,4)
				self.Tiles[i].swivyendtime = CurTime() + math.Rand(1,4)
			end
		end
	end
end
local MovingTile = false
function APP:StartCustomization()
	self:AddMenuOption("Resize",function()
		if MovingTile then
			self.Disk[MovingTile].size = self.Disk[MovingTile].size + 1
			if self.Disk[MovingTile].size > 1 then
				self.Disk[MovingTile].size = 0
			end
			if self.Disk[MovingTile].size == 0 then
				self.Tiles[MovingTile].w = 24
				self.Tiles[MovingTile].h = 24
				self.Tiles[MovingTile].text = nil
			elseif self.Disk[MovingTile].size == 1 then
				self.Tiles[MovingTile].w = 56
				self.Tiles[MovingTile].h = 56
				self.Tiles[MovingTile].text = self.Disk[MovingTile].name
			end
			
		end
	end)
	for i =1,#self.Disk do
		self.Tiles[i].swivxstart = 0
		self.Tiles[i].swivystart = 0
		self.Tiles[i].swivxend = 0
		self.Tiles[i].swivyend = 0
		
		self.Tiles[i].swivxstarttime = CurTime()
		self.Tiles[i].swivystarttime = CurTime()
		self.Tiles[i].swivxendtime = CurTime()
		self.Tiles[i].swivyendtime = CurTime()
		self.Tiles[i].x = (self.Disk[i].x*32) + 6
		self.Tiles[i].y = self.Disk[i].y*32 + 29
		if self.Disk[i].size == 0 then
			self.Tiles[i].w = 24
			self.Tiles[i].h = 24
		elseif self.Disk[i].size == 1 then
			self.Tiles[i].w = 56
			self.Tiles[i].h = 56
		end
		self.Tiles[i].bgcolor = Color(25,25,255,100)
		self.Tiles[i].color = Color(255,255,255,100)
		self.Tiles[i].OnPressed = function(phone,app)

		end
		self.Tiles[i].OnUnPressed = function(phone,app)
			if self.Tiles[i].moving then
				app.Tiles[i].bgcolor = Color(25,25,255,100)
				app.Tiles[i].color = Color(255,255,255,100)
				app.DisableTileSwitching = false
				app.Tiles[i].moving = false
				MovingTile = false
				if self.Disk[i].size == 0 then
					self.Tiles[i].w = 24
					self.Tiles[i].h = 24
					self.Tiles[i].text = nil
				elseif self.Disk[i].size == 1 then
					self.Tiles[i].w = 56
					self.Tiles[i].h = 56
					self.Tiles[i].text = self.Disk[i].name
				end
			else
				app.Tiles[i].bgcolor = Color(25,25,255,255)
				app.Tiles[i].color = Color(255,255,255,255)
				app.Tiles[i].moving = true
				MovingTile = i
				app.DisableTileSwitching = true
				if app.Disk[i].size == 0 then
					app.Tiles[i].w = 30
					app.Tiles[i].h = 30
					self.Tiles[i].text = nil
				elseif app.Disk[i].size == 1 then
					app.Tiles[i].w = 62
					app.Tiles[i].h = 62
					self.Tiles[i].text = self.Disk[i].name
				end
			end
		end
		
	end
	self.Customize = true
end
function APP:EndCustomization()
	self:RemoveMenuOption("Resize")
	MovingTile = false
	for i =1,#self.Disk do
		self.Tiles[i].x = (self.Disk[i].x*32) + 6
		self.Tiles[i].y = self.Disk[i].y*32 + 29
		if self.Disk[i].size == 0 then
			self.Tiles[i].w = 30
			self.Tiles[i].h = 30
		elseif self.Disk[i].size == 1 then
			self.Tiles[i].w = 62
			self.Tiles[i].h = 62
			self.Tiles[i].text = self.Disk[i].name
		end
		self.Tiles[i].bgcolor = Color(25,25,255,255)
		self.Tiles[i].color = Color(255,255,255,255)
		self.Tiles[i].OnPressed = function(phone,app)
			app.Tiles[i].bgcolor = Color(25,25,255,128)
			app.Tiles[i].color = Color(255,255,255,128)
		end
		self.Tiles[i].OnUnPressed = function(phone,app)
			app.Tiles[i].bgcolor = Color(25,25,255,255)
			app.Tiles[i].color = Color(255,255,255,255)
			if self.Disk[i].app == "$folder" then
			
			else
				phone:OpenApp(self.Disk[i].app)
			end
		end
	end
	self.DisableTileSwitching = false
	self.Customize = false
	self:SaveData()
end
function APP:OnBack(phone)
	if self.Customize then
		self:EndCustomization()
	end
end
function APP:OnLeft(phone)
	if MovingTile && self.Disk[MovingTile].x > 0 then
		self.Disk[MovingTile].x = self.Disk[MovingTile].x - 1
	end
end
function APP:OnRight(phone)
	if MovingTile then
		self.Disk[MovingTile].x = self.Disk[MovingTile].x + 1
	end
end
function APP:OnUp(phone)
	if MovingTile && self.Disk[MovingTile].y > 0 then
		self.Disk[MovingTile].y = self.Disk[MovingTile].y - 1
	end
end
function APP:OnDown(phone)
	if MovingTile then
		self.Disk[MovingTile].y = self.Disk[MovingTile].y + 1
	end
end
ARCPhone.RegisterApp(APP,"home")





APP = ARCPhone.NewAppObject()
APP.Name = "Phone Dialer"
APP.Author = "ARitz Cracker"
APP.Purpose = "Calling screen for ARCPhone"
function APP:AddNumber(num)
	if num < 10 && num > 0 then
		self.Dialnum = self.Dialnum..num
	elseif num == 10 then
		self.Dialnum = self.Dialnum.."*"
	elseif num == 11 then
		self.Dialnum = self.Dialnum.."0"
	elseif num == 12 then
		self.Dialnum = self.Dialnum.."#"
	elseif num == 0 then
		self.Dialnum = string.Left( self.Dialnum, #self.Dialnum -1 )
	end
end
function APP:Init()
	if ARCPhone.PhoneSys.Status == ARCPHONE_ERROR_CALL_RUNNING || ARCPhone.PhoneSys.Status == ARCPHONE_ERROR_DIALING then
		ARCPhone.PhoneSys:OpenApp("callscreen")
		return
	end
	self.Tiles = {}
	self.Dialnum = ""
	for i = 0,14 do
		self.Tiles[i] = ARCPhone.NewAppTile()
		self.Tiles[i].x = ((i%3)*42) + 8
		self.Tiles[i].y = math.floor(i/3)*28 + 64
		self.Tiles[i].w = 38
		self.Tiles[i].h = 24
		self.Tiles[i].color = Color(0,0,128,255)
		self.Tiles[i].OnPressed = function(phone,app)
			self.Tiles[i].color = Color(0,0,128,128)
		end
		self.Tiles[i].OnUnPressed = function(phone,app)
			self.Tiles[i].color = Color(0,0,128,255)
			self:AddNumber(i-2)
		end
		if i > 1 && i < 12 then

			self.Tiles[i].drawfunc = function(phone,app,x,y)
				draw.SimpleText( i-2, "ARCPhone", x+self.Tiles[i].w*0.5, y+self.Tiles[i].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
			end
		end
	end
	self.Tiles[2].drawfunc = function(phone,app,x,y)
		draw.SimpleText( "<[x]", "ARCPhone", x+self.Tiles[9].w*0.5, y+self.Tiles[9].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[1].drawfunc = function(phone,app,x,y)
		draw.SimpleText( "$", "ARCPhone", x+self.Tiles[9].w*0.5, y+self.Tiles[9].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[0].drawfunc = function(phone,app,x,y)
		draw.SimpleText( "$", "ARCPhone", x+self.Tiles[9].w*0.5, y+self.Tiles[9].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[12].drawfunc = function(phone,app,x,y)
		draw.SimpleText( "*", "ARCPhone", x+self.Tiles[9].w*0.5, y+self.Tiles[9].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[13].drawfunc = function(phone,app,x,y)
		draw.SimpleText( "0", "ARCPhone", x+self.Tiles[10].w*0.5, y+self.Tiles[10].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[14].drawfunc = function(phone,app,x,y)
		draw.SimpleText( "#", "ARCPhone", x+self.Tiles[11].w*0.5, y+self.Tiles[11].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	
	self.Tiles[16] = ARCPhone.NewAppTile()
	self.Tiles[16].x = 8
	self.Tiles[16].y = 30
	self.Tiles[16].w = 122
	self.Tiles[16].h = 30
	self.Tiles[16].color = Color(0,0,64,255)
	self.Tiles[16].OnPressed = function(phone,app)
		self.Tiles[16].color = Color(0,0,64,128)
	end
	self.Tiles[16].OnUnPressed = function(phone,app)
		self.Tiles[16].color = Color(0,0,64,255)
	end
	self.Tiles[16].drawfunc = function(phone,app,x,y)
		draw.SimpleText( self.Dialnum, "ARCPhone", x+self.Tiles[16].w*0.5, y+self.Tiles[16].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	
	self.Tiles[15] = ARCPhone.NewAppTile()
	self.Tiles[15].x = 8
	self.Tiles[15].y = 204
	self.Tiles[15].w = 122
	self.Tiles[15].h = 30
	self.Tiles[15].color = Color(0,0,255,255)
	self.Tiles[15].OnPressed = function(phone,app)
		self.Tiles[15].color = Color(0,0,255,128)
	end
	self.Tiles[15].OnUnPressed = function(phone,app)
		self.Tiles[15].color = Color(0,0,255,255)
		phone:Call(self.Dialnum)
		phone:OpenApp("callscreen")
	end
	self.Tiles[15].drawfunc = function(phone,app,x,y)
		draw.SimpleText( "Call", "ARCPhone", x+self.Tiles[15].w*0.5, y+self.Tiles[15].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
end
APP:Init()
ARCPhone.RegisterApp(APP,"dialer")



APP = ARCPhone.NewAppObject()
APP.Name = "Call Progress"
APP.Author = "ARitz Cracker"
APP.Purpose = "Calling screen for ARCPhone"

function APP:Init()


	self.Tiles[1] = ARCPhone.NewAppTile()
	self.Tiles[1].x = 8
	self.Tiles[1].y = 224
	self.Tiles[1].w = 122
	self.Tiles[1].h = 20
	self.Tiles[1].color = Color(0,0,255,255)
	self.Tiles[1].OnPressed = function(phone,app)
		self.Tiles[1].color = Color(0,0,255,128)
	end
	self.Tiles[1].OnUnPressed = function(phone,app)
		self.Tiles[1].color = Color(0,0,255,255)
		phone:HangUp()
		phone:OpenApp("dialer")
	end
	self.Tiles[1].drawfunc = function(phone,app,x,y)
		draw.SimpleText("End Call", "ARCPhone", x+self.Tiles[1].w*0.5, y+self.Tiles[1].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	
end
APP:Init()
ARCPhone.RegisterApp(APP,"callscreen")


APP = ARCPhone.NewAppObject()
APP.Name = "Messaging"
APP.Author = "ARitz Cracker"
APP.Purpose = "Messaging app for ARCPhone"

function APP:Init()
	self.Tiles = {}
	
	
	
	
	self.Tiles[1] = ARCPhone.NewAppTile()
	self.Tiles[1].x = 8
	self.Tiles[1].y = 32
	self.Tiles[1].w = 122
	self.Tiles[1].h = 18
	self.Tiles[1].color = Color(0,0,64,255)
	
	self.Tiles[1].drawfunc = function(phone,app,x,y)
		draw.SimpleText("**New Conversation**", "ARCPhone", x+self.Tiles[1].w*0.5, y+self.Tiles[1].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	--[[
	self.Tiles[1] = ARCPhone.NewAppTextInputTile("This is a text input tile, but it isn't editable because the Editable variable has been set to false")
	self.Tiles[1].x = 8
	self.Tiles[1].y = 154
	self.Tiles[1].w = 122
	self.Tiles[1].h = 40
	self.Tiles[1].color = Color(0,0,255,255)
	self.Tiles[1].Editable = false

	self.Tiles[2] = ARCPhone.NewAppTextInputTile("This is resizeable tile. This one is editable",true)
	self.Tiles[2].x = 8
	self.Tiles[2].y = 204
	self.Tiles[2].w = 122
	self.Tiles[2].h = 40
	self.Tiles[2].color = Color(0,0,255,255)
	]]
	
	
	
end
APP:Init()
ARCPhone.RegisterApp(APP,"messaging")

--ARCPhone.PhoneSys:OpenApp("callscreen")

--u4dd'dasdad