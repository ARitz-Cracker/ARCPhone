
local APP = ARCPhone.NewAppObject()
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
	if file.Exists(ARCPhone.ROOTDIR.."/contactphotos/"..self.Disk[tileid][ARCPHONE_CONTACT_NUMBER]..".dat","DATA") then
		self.ProfilePics[1] = ARCLib.MaterialFromTxt(ARCPhone.ROOTDIR.."/contactphotos/"..self.Disk[tileid][ARCPHONE_CONTACT_NUMBER]..".dat","jpg");
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
	if app.Tiles[phone.SelectedAppTile].ContactEditable then
		app:EditContact(phone.SelectedAppTile)
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
	self.ProfilePics[0] = ARCLib.MaterialFromTxt(ARCPhone.ROOTDIR.."/contactphotos/0000000000.dat","jpg")
	local len = #self.Disk
	for i=1,len do
		if file.Exists(ARCPhone.ROOTDIR.."/contactphotos/"..self.Disk[i][ARCPHONE_CONTACT_NUMBER]..".dat","DATA") then
			self.ProfilePics[i] = ARCLib.MaterialFromTxt(ARCPhone.ROOTDIR.."/contactphotos/"..self.Disk[i][ARCPHONE_CONTACT_NUMBER]..".dat","jpg");
		end
	end
end
function APP:Init()
	self:ResetCurPos()
	self.Home = true;
	
	self.Tiles = {}
	table.Empty(self.ProfilePics)
	self.ProfilePics[0] = ARCLib.MaterialFromTxt(ARCPhone.ROOTDIR.."/contactphotos/0000000000.dat","jpg")
	
	

	local len = #self.Disk
	for i=1,len do
		self.Tiles[i] = ARCPhone.NewAppTile()
		self.Tiles[i].x = 8
		self.Tiles[i].y = 10 + i*32
		self.Tiles[i].w = 122
		self.Tiles[i].h = 28
		self.Tiles[i].color = Color(0,0,255,255)
		self.Tiles[i].ContactEditable = true
		if file.Exists(ARCPhone.ROOTDIR.."/contactphotos/"..self.Disk[i][ARCPHONE_CONTACT_NUMBER]..".dat","DATA") then
			self.ProfilePics[i] = ARCLib.MaterialFromTxt(ARCPhone.ROOTDIR.."/contactphotos/"..self.Disk[i][ARCPHONE_CONTACT_NUMBER]..".dat","jpg");
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
	self.Tiles[4].y = 196
	self.Tiles[4].w = 122
	self.Tiles[4].h = 18
	self.Tiles[4].color = Color(128,128,128,255)
	self.Tiles[4].OnPressed = function(phone,app)
		self.Tiles[4].color = Color(128,128,128,128)
	end
	self.Tiles[4].OnUnPressed = function(phone,app)
		self.Tiles[4].color = Color(128,128,128,255)	
		if (tileid > 0) then
			table.remove(app.Disk,tileid)
		end
		app:SaveData()
		app:Init()
	end
	self.Tiles[4].drawfunc = function(phone,app,x,y)
		draw.SimpleText( "Delete", "ARCPhone", x+app.Tiles[4].w*0.5, y+app.Tiles[4].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	
	self.Tiles[5] = ARCPhone.NewAppTile()
	self.Tiles[5].x = 8
	self.Tiles[5].y = 220
	self.Tiles[5].w = 122
	self.Tiles[5].h = 18
	self.Tiles[5].color = Color(0,0,255,255)
	self.Tiles[5].OnPressed = function(phone,app)
		self.Tiles[5].color = Color(0,0,255,128)
	end
	self.Tiles[5].OnUnPressed = function(phone,app)
		self.Tiles[5].color = Color(0,0,255,255)
		if (ARCPhone.IsValidPhoneNumber(app.Tiles[3].TextInput)) then
			if (tileid > 0) then
				app.Disk[tileid][ARCPHONE_CONTACT_NAME] = app.Tiles[2].TextInput
				app.Disk[tileid][ARCPHONE_CONTACT_NUMBER] = app.Tiles[3].TextInput
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
	self.Tiles[5].drawfunc = function(phone,app,x,y)
		draw.SimpleText( "Save", "ARCPhone", x+app.Tiles[5].w*0.5, y+app.Tiles[5].h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
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
