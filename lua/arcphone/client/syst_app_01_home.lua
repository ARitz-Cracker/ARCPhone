local APP = ARCPhone.NewAppObject()
APP.Name = "Home"
APP.Author = "ARitz Cracker"
APP.Purpose = "Home screen for ARCPhone"
APP.FlatIconName = "box"
APP.Hidden = true

function APP:ToggleCustomizing()
	if self.Customize then
		self:RenameMenuOption("Finish customizing","Customize")
		self:EndCustomization()
	else
		self:RenameMenuOption("Customize","Finish customizing")
		self:StartCustomization()
	end
end

function APP:NewAppIcon()
	local appname = self.Tiles[self.Phone.SelectedAppTile].app
	local app = self.Phone:GetApp(appname)
	table.insert( self.Disk, {x=0,y=0,size=0,name=app.Name,flaticon=isstring(app.FlatIconName),texture=app.FlatIconName or appname,app=appname} )
	self:Init()
	self:StartCustomization()
	self.Tiles[#self.Tiles]:OnUnPressed()
	self:SetCurPos(#self.Tiles)
end

function APP:AllAppsScreen()
	self:ResetCurPos()
	self.InAllAppsScreen = true
	self:RemoveMenuOption("Customize")
	self:RemoveMenuOption("All Apps")
	self:AddMenuOption("Add app to home",self.NewAppIcon,self)
	table.Empty(self.Tiles)
	local i = 0
	for k,v in SortedPairs(ARCPhone.Apps) do
		if !v.Hidden then
			i = i + 1
			self.Tiles[i] = ARCPhone.NewAppTile(self)
			self.Tiles[i].x = 8
			self.Tiles[i].y = 10 + i*24
			self.Tiles[i].w = 122
			self.Tiles[i].h = 22
			self.Tiles[i].color = self.Phone.Settings.Personalization.CL_01_MainColour
			self.Tiles[i].ContactEditable = true
			self.Tiles[i].app = k
			local tex 
			if v.FlatIconName then
				tex = ARCLib.FlatIcons64[v.FlatIconName]
			else
				tex = surface.GetTextureID("arcphone/appicons/"..k)
			end
			self.Tiles[i].drawfunc = function(tile,x,y)
				surface.SetDrawColor(ARCLib.ConvertColor(self.Phone.Settings.Personalization.CL_03_MainText))
				surface.SetTexture(tex)
				surface.DrawTexturedRect( x + 2, y + 2, 20, 20 )
				draw.SimpleText(ARCLib.CutOutText(v.Name,"ARCPhone",90), "ARCPhone", x + 30, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_03_MainText, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) 
			end
			self.Tiles[i].OnPressed = function(tile)
				tile.color = self.Phone.Settings.Personalization.CL_02_MainPressed
			end
			self.Tiles[i].OnUnPressed = function(tile)
				tile.color = self.Phone.Settings.Personalization.CL_01_MainColour
				tile.App.Phone:OpenApp(k)
			end
		end
	end
end

function APP:Init()
	self.InAllAppsScreen = false
	self:RemoveMenuOption("Resize")
	self:RemoveMenuOption("Delete Icon")
	self:RemoveMenuOption("Add app to home")
	self:RemoveMenuOption("Finish customizing")
	self:AddMenuOption("Customize",self.ToggleCustomizing,self)
	self:AddMenuOption("All Apps",self.AllAppsScreen,self)
	
	self:ResetCurPos()
	if #self.Disk == 0 then
		self.Disk = {{x=0,y=0,size=0,name="Call",flaticon=true,texture="phone",app="dialer"},{x=1,y=0,size=0,name="Test",flaticon=true,texture="box",app="test"},{x=2,y=0,size=0,name="Mutli-size test",flaticon=true,texture="box",app="test_multi"},{x=3,y=0,size=0,name="Messaging",flaticon=true,texture="comments",app="messaging"},{x=0,y=1,size=0,name="Settings",flaticon=true,texture="settings",app="settings"},{x=1,y=1,size=0,name="Timer",flaticon=true,texture="timer",app="timer"},{x=2,y=1,size=1,name="Console",flaticon=true,texture="terminal",app="test_multi"},{x=0,y=2,size=1,name="Contacts",flaticon=true,texture="people",app="contacts"},{x=2,y=3,size=0,name="Camera",flaticon=true,texture="camera",app="camera"},{x=3,y=3,size=0,name="Photos",flaticon=true,texture="images",app="photos"}}
	end
	table.Empty(self.Tiles)
	for i =1,#self.Disk do
		self.Tiles[i] = ARCPhone.NewAppTile(self)
		self.Tiles[i].app = self.Disk[i].app
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
			self.Tiles[i].tex = surface.GetTextureID("arcphone/appicons"..self.Disk[i].texture)
		end
		self.Tiles[i].color = self.Phone.Settings.Personalization.CL_03_MainText
		self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_01_MainColour
		self.Tiles[i].OnPressed = function(tile)
			tile.bgcolor = self.Phone.Settings.Personalization.CL_02_MainPressed
		end
		self.Tiles[i].OnUnPressed = function(tile)
			tile.bgcolor = self.Phone.Settings.Personalization.CL_01_MainColour
			if tile.app == "$folder" then
			
			else
				tile.App.Phone:OpenApp(tile.app)
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

function APP:DeleteIcon()
	table.remove( self.Disk, self.Phone.SelectedAppTile )
	table.remove( self.Tiles, self.Phone.SelectedAppTile )
	if !self.Tiles[self.Phone.SelectedAppTile] then
		self:ResetCurPos()
	end
end

function APP:StartCustomization()
	self:RemoveMenuOption("All Apps")
	self:AddMenuOption("Delete Icon",self.DeleteIcon,self)
	self:AddMenuOption("Resize",function(app)
		app.Disk[self.Phone.SelectedAppTile].size = app.Disk[self.Phone.SelectedAppTile].size + 1
		if app.Disk[self.Phone.SelectedAppTile].size > 1 then
			app.Disk[self.Phone.SelectedAppTile].size = 0
		end
		if app.Disk[self.Phone.SelectedAppTile].size == 0 then
			app.Tiles[self.Phone.SelectedAppTile].w = 24
			app.Tiles[self.Phone.SelectedAppTile].h = 24
			app.Tiles[self.Phone.SelectedAppTile].text = nil
		elseif app.Disk[self.Phone.SelectedAppTile].size == 1 then
			app.Tiles[self.Phone.SelectedAppTile].w = 56
			app.Tiles[self.Phone.SelectedAppTile].h = 56
			app.Tiles[self.Phone.SelectedAppTile].text = app.Disk[self.Phone.SelectedAppTile].name
		end
	end,self)
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
		self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_02_MainPressed
		self.Tiles[i].color = self.Phone.Settings.Personalization.CL_03_MainText
		--[[
		self.Tiles[i].OnPressed = function(tile,app)

		end
		]]
		self.Tiles[i].OnUnPressed = function(tile)
			if tile.moving then
				tile.bgcolor = Color(25,25,255,100)
				tile.color = Color(255,255,255,100)
				tile.App.DisableTileSwitching = false
				tile.moving = false
				self.MovingTile = false
				if tile.App.Disk[i].size == 0 then
					tile.w = 24
					tile.h = 24
					tile.text = nil
				elseif tile.App.Disk[i].size == 1 then
					tile.w = 56
					tile.h = 56
					tile.text = tile.App.Disk[i].name
				end
			else
				tile.bgcolor = self.Phone.Settings.Personalization.CL_01_MainColour
				tile.color = self.Phone.Settings.Personalization.CL_03_MainText
				tile.moving = true
				self.MovingTile = i
				tile.App.DisableTileSwitching = true
				if tile.App.Disk[i].size == 0 then
					tile.w = 30
					tile.h = 30
					tile.text = nil
				elseif tile.App.Disk[i].size == 1 then
					tile.w = 62
					tile.h = 62
					tile.text = tile.App.Disk[i].name
				end
			end
		end
		
	end
	self.Customize = true
end
function APP:EndCustomization()
	self:RemoveMenuOption("Resize")
	self:RemoveMenuOption("Delete Icon")
	self:AddMenuOption("All Apps",self.AllAppsScreen,self)
	self.MovingTile = false
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
		self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_01_MainColour
		self.Tiles[i].color = self.Phone.Settings.Personalization.CL_03_MainText
		self.Tiles[i].OnPressed = function(tile)
			tile.bgcolor = self.Phone.Settings.Personalization.CL_02_MainPressed
		end
		self.Tiles[i].OnUnPressed = function(tile)
			tile.bgcolor = self.Phone.Settings.Personalization.CL_02_MainPressed
			if tile.App.Disk[i].app == "$folder" then
			
			else
				tile.App.Phone:OpenApp(tile.app)
			end
		end
	end
	self.DisableTileSwitching = false
	self.Customize = false
	self:SaveData()
end
function APP:OnBack()
	if self.InAllAppsScreen then
		self:Init()
	end
	if self.Customize then
		self:EndCustomization()
	end
end
function APP:OnLeft()
	if self.MovingTile && self.Disk[self.MovingTile].x > 0 then
		self.Disk[self.MovingTile].x = self.Disk[self.MovingTile].x - 1
	end
end
function APP:OnRight()
	if self.MovingTile then
		self.Disk[self.MovingTile].x = self.Disk[self.MovingTile].x + 1
	end
end
function APP:OnUp()
	if self.MovingTile && self.Disk[self.MovingTile].y > 0 then
		self.Disk[self.MovingTile].y = self.Disk[self.MovingTile].y - 1
	end
end
function APP:OnDown()
	if self.MovingTile then
		self.Disk[self.MovingTile].y = self.Disk[self.MovingTile].y + 1
	end
end
ARCPhone.RegisterApp(APP,"home")
