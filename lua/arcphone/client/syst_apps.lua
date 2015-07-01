-- syst_apps.lua - System Applications for ARCPhone
-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.


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












APP = ARCPhone.NewAppObject()
APP.Name = "Contacts"
APP.Author = "ARitz Cracker"
APP.Purpose = "Contacts app for ARCPhone"

APP.ContactOptionNames = {}
APP.ContactOptionFuncs = {}
APP.ContactOptionArgs = {}
local ARCPHONE_CONTACT_NUMBER = 1
local ARCPHONE_CONTACT_NAME = 2
function APP:AddContactOption(name,func,...)
	local dothing = true
	for i=1,#self.ContactOptionNames do
		if self.ContactOptionNames[i] == name then
			dothing = false
		end
	end
	if dothing then
		i = #self.ContactOptionNames + 1
		self.ContactOptionNames[i] = name
		self.ContactOptionFuncs[i] = func
		self.ContactOptionArgs[i] = {...}
	end
end

function APP:RemoveContactOption(name)
	
	key = table.RemoveByValue( self.ContactOptionNames,name) 
	if key then
		table.remove( self.ContactOptionFuncs, key )
		table.remove( self.ContactOptionArgs, key )
	end
end


function APP:SelectContact(tileid)
	self:ResetCurPos()
	self.Home = false
	table.Empty(self.Tiles)
	self.Tiles[1] = ARCPhone.NewAppTile()
	self.Tiles[1].x = 8
	self.Tiles[1].y = 42
	self.Tiles[1].w = 122
	self.Tiles[1].h = 28
	self.Tiles[1].color = Color(0,0,255,255)
	self.Tiles[1].ContactEditable = true
	if file.Exists(ARCPhone.ROOTDIR.."/contactphotos/"..self.Disk[tileid][ARCPHONE_CONTACT_NUMBER]..".txt","DATA") then
		self.ProfilePics[1] = ARCLib.MaterialFromTxt(ARCPhone.ROOTDIR.."/contactphotos/"..self.Disk[tileid][ARCPHONE_CONTACT_NUMBER]..".txt","jpg");
	end
	self.Tiles[1].drawfunc = function(phone,app,x,y)
		surface.SetDrawColor(255,255,255,255)
		if (self.ProfilePics[tileid]) then
			surface.SetMaterial(self.ProfilePics[tileid])
		else
			surface.SetMaterial(self.ProfilePics[0])
		end
		surface.DrawTexturedRect( x + 2, y + 2, 24, 24 )
		draw.SimpleText(self.Disk[tileid][ARCPHONE_CONTACT_NAME], "ARCPhone", x + 28, y+self.Tiles[1].h*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP) 
		draw.SimpleText(self.Disk[tileid][ARCPHONE_CONTACT_NUMBER], "ARCPhone", x + 28, y+self.Tiles[1].h*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM) 
	end
	
	local len = #self.ContactOptionNames + 1
	
	for i=2,len do
		self.Tiles[i] = ARCPhone.NewAppTile()
		self.Tiles[i].x = 8
		self.Tiles[i].y = 42 + i*22
		self.Tiles[i].w = 122
		self.Tiles[i].h = 18
		self.Tiles[i].color = Color(0,0,64,255)
		self.Tiles[i].drawfunc = function(phone,app,x,y)
			draw.SimpleText(self.ContactOptionNames[i-1], "ARCPhone", x+self.Tiles[i].w*0.5, y+self.Tiles[i].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 

		end
		self.Tiles[i].OnPressed = function(phone,app)
			self.Tiles[i].color = Color(0,0,64,128)
		end
		self.Tiles[i].OnUnPressed = function(phone,app)
			self.Tiles[i].color = Color(0,0,64,255)
			self.ContactOptionFuncs[i-1](unpack(self.ContactOptionArgs[i-1]),self.Disk[tileid][ARCPHONE_CONTACT_NUMBER])
		end
	end
	
	--[[
	self.Tiles[1].OnPressed = function(phone,app)
		self.Tiles[1].color = Color(0,0,255,128)
	end
	self.Tiles[1].OnUnPressed = function(phone,app)
		self.Tiles[1].color = Color(0,0,255,255)
		ARCPhone.PhoneSys:AddMsgBox("Coming soon!","Todo: contact options screen","info")
	end
	]]
end

function APP:ForegroundThink()

end

APP.Options[2] = {}
APP.Options[2].text = "Edit"
APP.Options[2].func = function(phone,app) 
	if self.Tiles[phone.SelectedAppTile].ContactEditable then
		self:EditContact(phone.SelectedAppTile)
	else
		ARCPhone.PhoneSys:AddMsgBox("Cannot edit","You cannot edit this icon because it's not a contact entry","cross")
	end
end


function APP:GetNameFromNumber(number)
	local result = "Unknown"
	local len = #self.Disk
	for i=1,len do
		if (self.Disk[i][ARCPHONE_CONTACT_NUMBER] == number) then
			result = self.Disk[i][ARCPHONE_CONTACT_NAME]
			break
		end
	end
	return result
end

function APP:GetDiskIDFromNumber(number)
	local result = 0
	local len = #self.Disk
	for i=1,len do
		if (self.Disk[i][ARCPHONE_CONTACT_NUMBER] == number) then
			result = i
			break
		end
	end
	return result
end
function APP:PhoneStart()
	self.ProfilePics = {}
	self.ProfilePics[0] = ARCLib.MaterialFromTxt(ARCPhone.ROOTDIR.."/contactphotos/0000000000.txt","jpg")
	local len = #self.Disk
	for i=1,len do
		if file.Exists(ARCPhone.ROOTDIR.."/contactphotos/"..self.Disk[i][ARCPHONE_CONTACT_NUMBER]..".txt","DATA") then
			self.ProfilePics[i] = ARCLib.MaterialFromTxt(ARCPhone.ROOTDIR.."/contactphotos/"..self.Disk[i][ARCPHONE_CONTACT_NUMBER]..".txt","jpg");
		end
	end
end
function APP:Init()
	self:ResetCurPos()
	self.Home = true;
	
	self.Tiles = {}
	table.Empty(self.ProfilePics)
	self.ProfilePics[0] = ARCLib.MaterialFromTxt(ARCPhone.ROOTDIR.."/contactphotos/0000000000.txt","jpg")
	
	

	local len = #self.Disk
	for i=1,len do
		self.Tiles[i] = ARCPhone.NewAppTile()
		self.Tiles[i].x = 8
		self.Tiles[i].y = 10 + i*32
		self.Tiles[i].w = 122
		self.Tiles[i].h = 28
		self.Tiles[i].color = Color(0,0,255,255)
		self.Tiles[i].ContactEditable = true
		if file.Exists(ARCPhone.ROOTDIR.."/contactphotos/"..self.Disk[i][ARCPHONE_CONTACT_NUMBER]..".txt","DATA") then
			self.ProfilePics[i] = ARCLib.MaterialFromTxt(ARCPhone.ROOTDIR.."/contactphotos/"..self.Disk[i][ARCPHONE_CONTACT_NUMBER]..".txt","jpg");
		end
		self.Tiles[i].drawfunc = function(phone,app,x,y)
			surface.SetDrawColor(255,255,255,255)
			if (self.ProfilePics[i]) then
				surface.SetMaterial(self.ProfilePics[i])
			else
				surface.SetMaterial(self.ProfilePics[0])
			end
			surface.DrawTexturedRect( x + 2, y + 2, 24, 24 )
			draw.SimpleText(self.Disk[i][ARCPHONE_CONTACT_NAME], "ARCPhone", x + 28, y+self.Tiles[i].h*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP) 
			draw.SimpleText(self.Disk[i][ARCPHONE_CONTACT_NUMBER], "ARCPhone", x + 28, y+self.Tiles[i].h*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM) 
		end
		self.Tiles[i].OnPressed = function(phone,app)
			self.Tiles[i].color = Color(0,0,255,128)
		end
		self.Tiles[i].OnUnPressed = function(phone,app)
			self.Tiles[i].color = Color(0,0,255,255)
			self:SelectContact(i)
		end
	end
	
	--[[
	len = len + 1
	self.Tiles[len] = ARCPhone.NewAppTile()
	self.Tiles[len].x = 8
	self.Tiles[len].y = 10 + len*32
	self.Tiles[len].w = 122
	self.Tiles[len].h = 28
	self.Tiles[len].ContactEditable = true
	self.Tiles[len].color = Color(0,0,128,255)
	self.Tiles[len].drawfunc = function(phone,app,x,y)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(self.ProfilePics[0])
		surface.DrawTexturedRect( x + 2, y + 2, 24, 24 )
		draw.SimpleText("ARitz Cracker", "ARCPhone", x + 28, y+self.Tiles[len].h*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP) 
		draw.SimpleText("0027745146", "ARCPhone", x + 28, y+self.Tiles[len].h*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM) 
	end
	self.Tiles[len].OnPressed = function(phone,app)
		self.Tiles[len].color = Color(0,0,128,128)
	end
	self.Tiles[len].OnUnPressed = function(phone,app)
		self.Tiles[len].color = Color(0,0,128,255)
		self:NewConvo()
	end
	]]
	len = len + 1
	self.Tiles[len] = ARCPhone.NewAppTile()
	self.Tiles[len].x = 8
	self.Tiles[len].y = 10 + len*32
	self.Tiles[len].w = 122
	self.Tiles[len].h = 28
	self.Tiles[len].color = Color(0,0,64,255)
	self.Tiles[len].drawfunc = function(phone,app,x,y)
		draw.SimpleText("**New contact**", "ARCPhone", x+self.Tiles[len].w*0.5, y+self.Tiles[len].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 

	end
	self.Tiles[len].OnPressed = function(phone,app)
		self.Tiles[len].color = Color(0,0,64,128)
	end
	self.Tiles[len].OnUnPressed = function(phone,app)
		self.Tiles[len].color = Color(0,0,64,255)
		self:EditContact(0)
	end

	len = len + 1
	self.Tiles[len] = ARCPhone.NewAppTile()
	self.Tiles[len].x = 8
	self.Tiles[len].y = 10 + len*32
	self.Tiles[len].w = 122
	self.Tiles[len].h = 28
	self.Tiles[len].color = Color(0,0,64,255)
	self.Tiles[len].drawfunc = function(phone,app,x,y)
		draw.SimpleText("**People near by**", "ARCPhone", x+self.Tiles[len].w*0.5, y+self.Tiles[len].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[len].OnPressed = function(phone,app)
		self.Tiles[len].color = Color(0,0,64,128)
	end
	self.Tiles[len].OnUnPressed = function(phone,app)
		self.Tiles[len].color = Color(0,0,64,255)
		ARCPhone.PhoneSys:AddMsgBox("Coming soon!","This feature has not been implemented yet, it will be available in a later version of ARCPhone","info")
	end
	
end
--APP:Init()

function APP:EditContact(tileid)
	self:ResetCurPos()
	self.Home = false
	self.Tiles = {}
	self.Tiles[1] = ARCPhone.NewAppTile()
	self.Tiles[1].x = 8
	self.Tiles[1].y = 24
	self.Tiles[1].w = 24
	self.Tiles[1].h = 24
	self.Tiles[1].TextureNoresize = true
	self.Tiles[1].color = Color(255,255,255,255)
	if self.ProfilePics[tileid] then
		self.Tiles[1].mat = self.ProfilePics[tileid]
	else
		self.Tiles[1].mat = self.ProfilePics[0]
	end
	self.Tiles[1].OnPressed = function(phone,app)
		self.Tiles[1].color = Color(255,255,255,128)
	end
	self.Tiles[1].OnUnPressed = function(phone,app)
		self.Tiles[1].color = Color(255,255,255,255)
		ARCPhone.PhoneSys:AddMsgBox("Coming soon!","You cannot change contact photos yet","info")
	end
	
	if (tileid > 0) then
		self.Tiles[2] = ARCPhone.NewAppTextInputTile(self.Disk[tileid][ARCPHONE_CONTACT_NAME],false,118)
		self.Tiles[3] = ARCPhone.NewAppTextInputTile(self.Disk[tileid][ARCPHONE_CONTACT_NUMBER],false,118)
	else
		self.Tiles[2] = ARCPhone.NewAppTextInputTile("Contact Name",false,118)
		self.Tiles[3] = ARCPhone.NewAppTextInputTile("Insert Number",false,118)
	end
	self.Tiles[2].y = 24
	self.Tiles[2].w = 92
	self.Tiles[2].x = 34
	self.Tiles[2].color = Color(72,72,72,255)
	
	
	self.Tiles[3].y = 42
	self.Tiles[3].w = 92
	self.Tiles[3].x = 34
	self.Tiles[3].color = Color(72,72,72,255)
	
	
	self.Tiles[4] = ARCPhone.NewAppTile()
	self.Tiles[4].x = 8
	self.Tiles[4].y = 204
	self.Tiles[4].w = 122
	self.Tiles[4].h = 18
	self.Tiles[4].color = Color(0,0,255,255)
	self.Tiles[4].OnPressed = function(phone,app)
		self.Tiles[4].color = Color(0,0,255,128)
	end
	self.Tiles[4].OnUnPressed = function(phone,app)
		self.Tiles[4].color = Color(0,0,255,255)
		if (ARCPhone.IsValidPhoneNumber(app.Tiles[3].TextInput)) then
			if (tileid > 0) then
				app.Disk[i][ARCPHONE_CONTACT_NAME] = app.Tiles[2].TextInput
				app.Disk[i][ARCPHONE_CONTACT_NUMBER] = app.Tiles[3].TextInput
			else
				local len = #app.Disk + 1
				app.Disk[len] = {}
				app.Disk[len][ARCPHONE_CONTACT_NAME] = app.Tiles[2].TextInput
				app.Disk[len][ARCPHONE_CONTACT_NUMBER] = app.Tiles[3].TextInput
			end
			app:SaveData()
			app:Init()
		else
			ARCPhone.PhoneSys:AddMsgBox("Cannot save","the number you have entered is invalid.","warning")
		end
		--phone:Call(self.Dialnum)
	end
	self.Tiles[4].drawfunc = function(phone,app,x,y)
		draw.SimpleText( "Save", "ARCPhone", x+app.Tiles[4].w*0.5, y+app.Tiles[4].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	
end

function APP:OnBack()
	if self.Home then
		self.Phone:OpenApp("home")
	else
		self:Init();
	end
end

ARCPhone.RegisterApp(APP,"contacts")








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
function APP:OnBack()
	if self.Customize then
		self:EndCustomization()
	end
end
function APP:OnLeft()
	if MovingTile && self.Disk[MovingTile].x > 0 then
		self.Disk[MovingTile].x = self.Disk[MovingTile].x - 1
	end
end
function APP:OnRight()
	if MovingTile then
		self.Disk[MovingTile].x = self.Disk[MovingTile].x + 1
	end
end
function APP:OnUp()
	if MovingTile && self.Disk[MovingTile].y > 0 then
		self.Disk[MovingTile].y = self.Disk[MovingTile].y - 1
	end
end
function APP:OnDown()
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
function APP:PhoneStart()
	ARCPhone.Apps["contacts"]:AddContactOption("Call",self.Phone.Call,self.Phone)
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
	end
	self.Tiles[15].drawfunc = function(phone,app,x,y)
		draw.SimpleText( "Call", "ARCPhone", x+self.Tiles[15].w*0.5, y+self.Tiles[15].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
end
function APP:OnBack()
	self.Phone:OpenApp("home")
end
ARCPhone.RegisterApp(APP,"dialer")



APP = ARCPhone.NewAppObject()
APP.Name = "Call Progress"
APP.Author = "ARitz Cracker"
APP.Purpose = "Calling screen for ARCPhone"
APP.NextCheck = 0;
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

function APP:ForegroundThink()
	if self.NextCheck <= CurTime() then
		--MsgN("Updating call list")
		--MsgN("ON:")
		--PrintTable(ARCPhone.PhoneSys.CurrentCall.on)
		--MsgN("PENDING:")
		--PrintTable(ARCPhone.PhoneSys.CurrentCall.pending)
		--ARCPhone.PhoneSys.CurrentCall.on
		--ARCPhone.PhoneSys.CurrentCall.pending
		local len = #ARCPhone.PhoneSys.CurrentCall.on
		local total = len + #ARCPhone.PhoneSys.CurrentCall.pending
		for i=2,len+1 do
			self.Tiles[i] = ARCPhone.NewAppTile()
			self.Tiles[i].x = 8
			self.Tiles[i].y = 10 + (i-1)*32
			self.Tiles[i].w = 122
			self.Tiles[i].h = 28
			self.Tiles[i].color = Color(0,0,255,255)
			self.Tiles[i].ContactEditable = true
			local diski = ARCPhone.Apps["contacts"]:GetDiskIDFromNumber(ARCPhone.PhoneSys.CurrentCall.on[i-1])
			--
			self.Tiles[i].drawfunc = function(phone,app,x,y)
				surface.SetDrawColor(255,255,255,255)
				if (ARCPhone.Apps["contacts"].ProfilePics[diski]) then
					surface.SetMaterial(ARCPhone.Apps["contacts"].ProfilePics[diski])
				else
					surface.SetMaterial(ARCPhone.Apps["contacts"].ProfilePics[0])
				end
				surface.DrawTexturedRect( x + 2, y + 2, 24, 24 )
				draw.SimpleText(ARCPhone.Apps["contacts"]:GetNameFromNumber(ARCPhone.PhoneSys.CurrentCall.on[i-1]), "ARCPhone", x + 28, y+self.Tiles[len].h*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP) 
				draw.SimpleText(ARCPhone.PhoneSys.CurrentCall.on[i-1], "ARCPhone", x + 28, y+self.Tiles[len].h*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM) 
			end
			--[[
			self.Tiles[i].OnPressed = function(phone,app)
				self.Tiles[i].color = Color(0,0,255,128)
			end
			self.Tiles[i].OnUnPressed = function(phone,app)
				self.Tiles[i].color = Color(0,0,255,255)
				ARCPhone.PhoneSys:AddMsgBox("Coming soon!","Todo: contact options screen","info")
			end
			]]
		end
		
		
		for i=len+2,total+1 do
			self.Tiles[i] = ARCPhone.NewAppTile()
			self.Tiles[i].x = 8
			self.Tiles[i].y = 10 + (i-1)*32
			self.Tiles[i].w = 122
			self.Tiles[i].h = 28
			self.Tiles[i].color = Color(0,0,128,255)
			self.Tiles[i].ContactEditable = true
			local diski = ARCPhone.Apps["contacts"]:GetDiskIDFromNumber(ARCPhone.PhoneSys.CurrentCall.pending[i-1])
			--
			self.Tiles[i].drawfunc = function(phone,app,x,y)
				surface.SetDrawColor(255,255,255,255)
				if (ARCPhone.Apps["contacts"].ProfilePics[diski]) then
					surface.SetMaterial(ARCPhone.Apps["contacts"].ProfilePics[diski])
				else
					surface.SetMaterial(ARCPhone.Apps["contacts"].ProfilePics[0])
				end
				surface.DrawTexturedRect( x + 2, y + 2, 24, 24 )
				draw.SimpleText(ARCPhone.Apps["contacts"]:GetNameFromNumber(RCPhone.PhoneSys.CurrentCall.pending[i-1]), "ARCPhone", x + 28, y+self.Tiles[len].h*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP) 
				draw.SimpleText(ARCPhone.PhoneSys.CurrentCall.pending[i-1], "ARCPhone", x + 28, y+self.Tiles[len].h*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM) 
			end
			--[[
			self.Tiles[i].OnPressed = function(phone,app)
				self.Tiles[i].color = Color(0,0,255,128)
			end
			self.Tiles[i].OnUnPressed = function(phone,app)
				self.Tiles[i].color = Color(0,0,255,255)
				ARCPhone.PhoneSys:AddMsgBox("Coming soon!","Todo: contact options screen","info")
			end
			]]
		end
		--
		total = total + 1
		self.Tiles[1].y = 10 + total*32
		if (self.Tiles[1].y < 224) then
			self.Tiles[1].y = 224
		end
		
		self.NextCheck = CurTime() + 1
	end
end

function APP:OnBack()
	self.Phone:OpenApp("home")
end
ARCPhone.RegisterApp(APP,"callscreen")


APP = ARCPhone.NewAppObject()
APP.Name = "Messaging"
APP.Author = "ARitz Cracker"
APP.Purpose = "Messaging app for ARCPhone"

function APP:OpenConvo(num)
	self.Home = false
	local numdir = ARCPhone.ROOTDIR.."/messaging/"..num..".txt"
	local len = 0
	if file.Exists(numdir,"DATA") then
		local msgs = string.Explode( "\f", file.Read(numdir))
		len = #msgs
		for i=1,len do
			self.Tiles[i] = ARCPhone.NewAppTextInputTile(string.sub( msgs[i], 2),true,118)
			self.Tiles[i].Editable = false
			if i > 1 then
				self.Tiles[i].y = self.Tiles[i-1].y + self.Tiles[i-1].h + 4
			else
				self.Tiles[i].y = 24
			end
			if msgs[i][1] == "s" then
				self.Tiles[i].x = 12
				self.Tiles[i].color = Color(0,0,255,255)
			else
				self.Tiles[i].x = 4
				self.Tiles[i].color = Color(0,0,128,255)
			end
		end
	end
	len = len + 1
	self.Tiles[len] = ARCPhone.NewAppTextInputTile("Enter your message",true,118)
	if len > 1 then
		self.Tiles[len].y = self.Tiles[len-1].y + self.Tiles[len-1].h + 4
	else
		self.Tiles[len].y = 24
	end
	self.Tiles[len].w = 118
	self.Tiles[len].x = 12
	self.Tiles[len].color = Color(72,72,72,255)
	len = len + 1
	
	self.InConvo = true
	self.SendIcon = len
	self.Tiles[len] = ARCPhone.NewAppTile()
	self.Tiles[len].x = 12
	self.Tiles[len].y = self.Tiles[len-1].y + self.Tiles[len-1].h + 2
	self.Tiles[len].w = 118
	self.Tiles[len].h = 18
	self.Tiles[len].color = Color(75, 255, 75,255)
	self.Tiles[len].drawfunc = function(phone,app,x,y)
		draw.SimpleText("SEND", "ARCPhone", x+self.Tiles[len].w*0.5, y+self.Tiles[len].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[len].OnPressed = function(phone,app)
		self.Tiles[len].color = Color(75, 255, 75,128)
	end
	self.Tiles[len].OnUnPressed = function(phone,app)
		self.Tiles[len].color = Color(75, 255, 75,255)
		
		self.Phone:SendText(num,self.Tiles[self.SendIcon-1].TextInput)
		self:OpenConvo(num)
	end
end

function APP:ForegroundThink()
	if self.InConvo then
		self.Tiles[self.SendIcon].y = self.Tiles[self.SendIcon-1].y + self.Tiles[self.SendIcon-1].h + 2
	end
end

function APP:NewConvo()
	Derma_StringRequest("ARCPhone","Enter the phone number of the person you want to text","",function( text ) 
		if ARCPhone.IsValidPhoneNumber(text) then
			self:OpenConvo(text)
		else
			ARCPhone.PhoneSys:AddMsgBox("Invalid phone number","The phone number you entered was invalid","warning")
		end
	end)
end
function APP:Init()
	self.Home = true
	self.Tiles = {}
	self.InConvo = false
	
	
	
	local files,_ = file.Find(ARCPhone.ROOTDIR.."/messaging/*", "DATA", "datedesc")
	--ARCPhone.Apps["contacts"].Disk
	local len = #files
	for i=1,len do
		local num = string.sub( files[i], 1, #files[i]-4 )
		self.Tiles[i] = ARCPhone.NewAppTile()
		self.Tiles[i].x = 8
		self.Tiles[i].y = 10 + i*22
		self.Tiles[i].w = 122
		self.Tiles[i].h = 18
		self.Tiles[i].color = Color(0,0,255,255)
		self.Tiles[i].drawfunc = function(phone,app,x,y)
			draw.SimpleText(num, "ARCPhone", x+self.Tiles[i].w*0.5, y+self.Tiles[i].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
		end
		self.Tiles[i].OnPressed = function(phone,app)
			self.Tiles[i].color = Color(0,0,255,128)
		end
		self.Tiles[1].OnUnPressed = function(phone,app)
			self.Tiles[1].color = Color(0,0,255,255)
			self:OpenConvo(num)
		end
	end
	len = len + 1
	self.Tiles[len] = ARCPhone.NewAppTile()
	self.Tiles[len].x = 8
	self.Tiles[len].y = 10 + len*22
	self.Tiles[len].w = 122
	self.Tiles[len].h = 18
	self.Tiles[len].color = Color(0,0,64,255)
	self.Tiles[len].drawfunc = function(phone,app,x,y)
		draw.SimpleText("**New Conversation**", "ARCPhone", x+self.Tiles[len].w*0.5, y+self.Tiles[len].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[len].OnPressed = function(phone,app)
		self.Tiles[len].color = Color(0,0,64,128)
	end
	self.Tiles[len].OnUnPressed = function(phone,app)
		self.Tiles[len].color = Color(0,0,64,255)
		self:NewConvo()
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
//APP:Init()
function APP:OnBack()
	if self.Home then
		self.Phone:OpenApp("home")
	else
		self:Init();
	end
end
ARCPhone.RegisterApp(APP,"messaging")



--ARCPhone.PhoneSys:OpenApp("callscreen")

