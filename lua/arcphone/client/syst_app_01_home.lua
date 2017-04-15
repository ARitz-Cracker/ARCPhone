-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.

-- TODO: STOP MESSING WITH APP.Tiles and do the stuff properly!!
local APP = ARCPhone.NewAppObject()
APP.Name = "Home"
APP.Author = "ARitz Cracker"
APP.Purpose = "Home screen for ARCPhone\n\nARCPhone uses the \"Material Design\" icon set created by Google Inc. Used under the Creative Commons Attribution 3.0 Unported License"
APP.FlatIconName = "memory-chip"
APP.Hidden = true
APP.OpenApps = {}

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
	local appname = self.Tiles[self.SelectedAppTile].app
	local app = self.Phone:GetApp(appname)
	table.insert( self.Disk, {x=0,y=0,size=0,name=app.Name,flaticon=isstring(app.FlatIconName),texture=app.FlatIconName or appname,app=appname} )
	self:Init()
	self:StartCustomization()
	self.Tiles[#self.Tiles]:OnUnPressed()
	self:SetCurPos(#self.Tiles)
	self:RenameMenuOption("Customize","Finish customizing")
end
function APP:OpenAppsScreen(homeIsActiveApp)
	if #self.OpenApps == 0 then return end
	self.InOpenAppsScreen = true
	self:ClearScreen()
	self:RemoveMenuOption("Customize")
	self:RemoveMenuOption("All Apps")
	self:RemoveMenuOption("Resize")
	self:RemoveMenuOption("Delete Icon")
	self:RemoveMenuOption("Add app to home")
	self:RemoveMenuOption("Finish customizing")
	
	
	local w = self.Phone.ScreenResX*0.75
	local h = self.Phone.ScreenResY*0.75
	for i,v in ipairs(self.OpenApps) do
		-- TODO: Close button
		local xpos = 18 - ((i-ARCLib.BoolToNumber(not homeIsActiveApp)) * (w + 10))
		self:CreateNewLabel(xpos,34,0,0,ARCPhone.Apps[v].Name or "","ARCPhone",self.Phone.Settings.Personalization.CL_03_MainText,self.Phone.Settings.Personalization.CL_01_MainColour)
		self.Tiles[i] = ARCPhone.NewAppTile(self)
		self.Tiles[i].ID = i
		self.Tiles[i].x = xpos
		self.Tiles[i].y = 34 - i + 16
		self.Tiles[i].w = w
		self.Tiles[i].h = h
		self.Tiles[i].color = self.Phone.Settings.Personalization.CL_01_MainColour
		local mat = ARCPhone.Apps[v]._RTScreen:GetMaterial()
		ARCPhone.Apps[v]._RTScreen:Enable()
		self.Tiles[i].drawfunc = function(tile,x,y)
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(mat)
			surface.DrawTexturedRect(x+4,y+4,tile.w-8,tile.h-8)
		end
		self.Tiles[i].OnPressed = function(tile)
			tile.color = self.Phone.Settings.Personalization.CL_02_MainPressed
		end
		self.Tiles[i].OnUnPressed = function(tile)
			tile.color = self.Phone.Settings.Personalization.CL_01_MainColour
			tile.App:Init()
			tile.App.Phone:OpenApp(v)
		end
	end
	self:ResetScreenPos()
	self:ResetCurPos()
end
function APP:AllAppsScreen()
	self.InOpenAppsScreen = false
	self.InAllAppsScreen = true
	self:RemoveMenuOption("Customize")
	self:RemoveMenuOption("All Apps")
	self:AddMenuOption("Add app to home",self.NewAppIcon,self)
	self:ClearScreen()
	local i = 0
	for k,v in SortedPairs(ARCPhone.Apps) do
		if !v.Hidden then
			i = i + 1
			self.Tiles[i] = ARCPhone.NewAppTile(self)
			self.Tiles[i].ID = i
			self.Tiles[i].x = 8
			self.Tiles[i].y = 10 + i*24
			self.Tiles[i].w = 122
			self.Tiles[i].h = 22
			self.Tiles[i].color = self.Phone.Settings.Personalization.CL_01_MainColour
			self.Tiles[i].ContactEditable = true
			self.Tiles[i].app = k
			local tex 
			if v.FlatIconName then
				tex =ARCPhone.GetIcon(v.FlatIconName)
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
	self:ResetCurPos()
end

function APP:SaveHomeScreen()
	table.Empty(self.Disk)
	local i = 0
	for k,v in pairs(self.Tiles) do
		i = i + 1
		local savedTile = {}
		savedTile.app = v.app
		savedTile.x = v.disk_x
		savedTile.y = v.disk_y
		savedTile.name = v.disk_name
		savedTile.size = v.disk_size
		savedTile.flaticon = v.disk_flaticon
		savedTile.texture = v.disk_texture
		self.Disk[i] = savedTile
	end
	self:SaveData()
end

local function tileOnPressedDownWhileHomescreen(tile)
	tile.bgcolor = tile.App.Phone.Settings.Personalization.CL_02_MainPressed
end

local function tileOnPressedWhileHomescreen(tile)
	tile.bgcolor = tile.App.Phone.Settings.Personalization.CL_01_MainColour
	if tile.App.Disk[i].app == "$folder" then
	
	else
		tile.App.Phone:OpenApp(tile.app)
	end
end
function APP:Init()

	for k,v in pairs(ARCPhone.Apps) do
		if v._RTScreen then
			v._RTScreen:Disable()
		end
	end

	self.InOpenAppsScreen = false
	self.InAllAppsScreen = false
	self:RemoveMenuOption("Resize")
	self:RemoveMenuOption("Delete Icon")
	self:RemoveMenuOption("Add app to home")
	self:RemoveMenuOption("Finish customizing")
	self:AddMenuOption("Customize",self.ToggleCustomizing,self)
	self:AddMenuOption("All Apps",self.AllAppsScreen,self)
	
	
	if #self.Disk == 0 then
		self.Disk = {
			{
				app="dialer",
				flaticon=true,
				name="Call",
				size=0,
				texture="phone-call-button",
				x=0,
				y=0
			},
			{
				app="messaging",
				flaticon=true,
				name="Messaging",
				size=1,
				texture="chat-bubbles",
				x=2,
				y=0
			},
			{
				app="contacts",
				flaticon=true,
				name="Contacts",
				size=1,
				texture="users-social-symbol",
				x=0,
				y=1
			},
			{
				app="settings",
				flaticon=true,
				name="Settings",
				size=0,
				texture="settings-cogwheel-button",
				x=1,
				y=0
			},
			{
				app="camera",
				flaticon=true,
				name="Camera",
				size=0,
				texture="camera",
				x=3,
				y=2
			},
			{
				app="photos",
				flaticon=true,
				name="Photos",
				size=0,
				texture="photo-library",
				x=2,
				y=2
			}
		}
	end
	self:ClearScreen()
	for i =1,#self.Disk do
		self.Tiles[i] = ARCPhone.NewAppTile(self)
		self.Tiles[i].ID = i
		self.Tiles[i].app = self.Disk[i].app
		self.Tiles[i].disk_x = self.Disk[i].x
		self.Tiles[i].disk_y = self.Disk[i].y
		self.Tiles[i].disk_name = self.Disk[i].name
		self.Tiles[i].disk_size = self.Disk[i].size
		self.Tiles[i].disk_flaticon = self.Disk[i].flaticon
		self.Tiles[i].disk_texture = self.Disk[i].texture
		self:SetTileSizeFromDisk(self.Tiles[i])
		self:SetTilePosFromDisk(self.Tiles[i])
		if self.Disk[i].flaticon then
			self.Tiles[i].tex = ARCPhone.GetIcon(self.Disk[i].texture)
		else
			self.Tiles[i].tex = surface.GetTextureID("arcphone/appicons/"..self.Disk[i].texture)
		end
		self.Tiles[i].color = self.Phone.Settings.Personalization.CL_03_MainText
		self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_01_MainColour
		self.Tiles[i].OnPressed = tileOnPressedDownWhileHomescreen
		self.Tiles[i].OnUnPressed = tileOnPressedWhileHomescreen
	end
	if self.Customize then
		self:StartCustomization()
	end
	self:ResetCurPos()
	self:ResetScreenPos()
end
function APP:ForegroundThink()
	
	if self.Customize then
		for k,v in pairs(self.Tiles) do
			if v.moving then
				v.x = v.disk_x*32 + 6
				v.y = v.disk_y*32 + 29
			else
				v.x = v.disk_x*32 + 6 + v.swivxend*(ARCLib.BetweenNumberScale(v.swivxstarttime,CurTime(),v.swivxendtime)) + v.swivxstart*(ARCLib.BetweenNumberScaleReverse(v.swivxstarttime,CurTime(),v.swivxendtime))
				v.y = v.disk_y*32 + 29 + v.swivyend*(ARCLib.BetweenNumberScale(v.swivystarttime,CurTime(),v.swivyendtime)) + v.swivystart*(ARCLib.BetweenNumberScaleReverse(v.swivystarttime,CurTime(),v.swivyendtime))
			end
			if v.swivxendtime < CurTime() then
				v.swivxstart = v.swivxend
				v.swivystart = v.swivyend
				v.swivxend = math.Rand(-2,6)
				v.swivyend = math.Rand(-2,6)
				v.swivxstarttime = CurTime()
				v.swivystarttime = CurTime()
				v.swivxendtime = CurTime() + math.Rand(1,4)
				v.swivyendtime = CurTime() + math.Rand(1,4)
			end
		end
	end
end

function APP:DeleteIcon()
	--DisableTileSwitching
	local selectedTile = self:GetSelectedTile()
	if not IsValid(selectedTile) then return end
	selectedTile:Remove()
	self.DisableTileSwitching = false
	self.MovingTile = false
end
local tileSizesWC = {}
local tileSizesHC = {}
tileSizesWC[0] = 24
tileSizesHC[0] = 24
tileSizesWC[1] = 56
tileSizesHC[1] = 56

local tileSizesW = {}
local tileSizesH = {}
tileSizesW[0] = 30
tileSizesH[0] = 30
tileSizesW[1] = 62
tileSizesH[1] = 62


local function tileOnPressedWhileCustomizing(tile)
	if tile.moving then
		local overlap = false
		local b1x1 = tile.disk_x*32
		local b1x2 = b1x1 + tileSizesW[tile.disk_size]
		local b1y1 = tile.disk_y*32
		local b1y2 = b1y1 + tileSizesH[tile.disk_size]
		for k,v in pairs(tile.App.Tiles) do
			if v ~= tile then
				local b2x1 = v.disk_x*32
				local b2x2 = b2x1 + tileSizesW[v.disk_size]
				local b2y1 = v.disk_y*32
				local b2y2 = b2y1 + tileSizesH[v.disk_size]
				if ARCLib.TouchingBox(b1x1,b1x2,b1y1,b1y2,b2x1,b2x2,b2y1,b2y2) then
					overlap = true
					print("INTERSECT")
					print(tile.app)
					print("WITH")
					print(v.app)
					break
				end
			end
		end
		tile.bgcolor = tile.App.Phone.Settings.Personalization.CL_01_MainColour
		tile.color = tile.App.Phone.Settings.Personalization.CL_03_MainText
		if overlap then
			tile.App.Phone:AddMsgBox("Tile overlapping","You cannot overlap tiles. Folders are not implemented yet.","report-symbol")
			return
		end
		tile.bgcolor = tile.App.Phone.Settings.Personalization.CL_02_MainPressed
		
		tile.App.DisableTileSwitching = false
		tile.moving = false
		tile.App.MovingTile = false
	else
		tile.bgcolor = tile.App.Phone.Settings.Personalization.CL_01_MainColour
		tile.color = tile.App.Phone.Settings.Personalization.CL_03_MainText
		tile.moving = true
		tile.App.MovingTile = tile
		tile.App.DisableTileSwitching = true
	end
	tile.App:SetTilePosFromDisk(tile)
	tile.App:SetTileSizeFromDisk(tile)
end

function APP:SetTilePosFromDisk(tile)
	tile.x = tile.disk_x*32 + 6
	tile.y = tile.disk_y*32 + 29
end
function APP:SetTileSizeFromDisk(tile)
	
	if not self.Customize or tile.moving then
		tile.w = tileSizesW[tile.disk_size] or 16
		tile.h = tileSizesH[tile.disk_size] or 16
	else
		tile.w = tileSizesWC[tile.disk_size] or 16
		tile.h = tileSizesHC[tile.disk_size] or 16
	end
	if tile.disk_size > 0 then
		tile.text = tile.disk_name
	else
		tile.text = nil
	end
end
function APP:StartCustomization()
	self:RemoveMenuOption("All Apps")
	self:AddMenuOption("Delete Icon",self.DeleteIcon,self)
	self:AddMenuOption("Resize",function(app)
		local selectedTile = app:GetSelectedTile()
		if not IsValid(selectedTile) then return end
		selectedTile.disk_size = selectedTile.disk_size + 1
		if selectedTile.disk_size > 1 then
			selectedTile.disk_size = 0
		end
		app:SetTileSizeFromDisk(selectedTile)
	end,self)
	self.Customize = true
	for k,v in pairs(self.Tiles) do
		v.swivxstart = 0
		v.swivystart = 0
		v.swivxend = 0
		v.swivyend = 0
		
		v.swivxstarttime = CurTime()
		v.swivystarttime = CurTime()
		v.swivxendtime = CurTime()
		v.swivyendtime = CurTime()
		v.bgcolor = self.Phone.Settings.Personalization.CL_02_MainPressed
		v.color = self.Phone.Settings.Personalization.CL_03_MainText
		v.OnUnPressed = tileOnPressedWhileCustomizing
		self:SetTileSizeFromDisk(v)
		self:SetTilePosFromDisk(v)
	end
	
end
function APP:EndCustomization()
	self:RemoveMenuOption("Resize")
	self:RemoveMenuOption("Delete Icon")
	self:AddMenuOption("All Apps",self.AllAppsScreen,self)
	self.MovingTile = false
	self.Customize = false
	for k,v in pairs(self.Tiles) do
		self:SetTilePosFromDisk(v)
		self:SetTileSizeFromDisk(v)
		v.bgcolor = self.Phone.Settings.Personalization.CL_01_MainColour
		v.color = self.Phone.Settings.Personalization.CL_03_MainText
		v.OnPressed = tileOnPressedDownWhileHomescreen
		v.OnUnPressed = tileOnPressedWhileHomescreen
	end
	self.DisableTileSwitching = false
	self:SaveHomeScreen()
end
function APP:OnBack()
	if self.InOpenAppsScreen then
		self:Init()
	end
	if self.InAllAppsScreen then
		self:Init()
	end
	if self.Customize then
		self:EndCustomization()
	end
end
function APP:OnLeft()
	if IsValid(self.MovingTile) and self.MovingTile.disk_x > 0 then
		self.MovingTile.disk_x = self.MovingTile.disk_x - 1
	end
end
function APP:OnRight()
	if IsValid(self.MovingTile) then
		self.MovingTile.disk_x = self.MovingTile.disk_x + 1
	end
end
function APP:OnUp()
	if IsValid(self.MovingTile) and self.MovingTile.y > 0 then
		self.MovingTile.disk_y = self.MovingTile.disk_y - 1
	end
end
function APP:OnDown()
	if IsValid(self.MovingTile) then
		self.MovingTile.disk_y = self.MovingTile.disk_y + 1
	end
end
ARCPhone.RegisterApp(APP,"home")
