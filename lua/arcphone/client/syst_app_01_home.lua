local APP = ARCPhone.NewAppObject()
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
