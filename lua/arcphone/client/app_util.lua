-- app_util.lua - app utilities
-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright Aritz Beobide-Cardinal 2014 All rights reserved.
ARCPhone.Apps = {}
local tile = {}
tile.tile = true
tile.x = 48
tile.y = 48
tile.w = 16
tile.h = 16
tile.color = color_white
tile.tex = false
tile.mat = false
tile.drawfunc_override = false
tile.drawfunc = false
tile.text = ""
tile.OnPressed = NULLFUNC -- (self)
tile.OnUnPressed = NULLFUNC -- (self)
tile.OnSelected = NULLFUNC -- (self)
tile.OnUnSelected = NULLFUNC -- (self)
function ARCPhone.NewAppTile(app)
	local tab = table.Copy(tile)
	tab.App = app
	return tab
end


local texttile = table.Copy(tile)

function texttile:drawfunc(xpos,ypos)
	self._imagedisplay = 0
	self._nextimagedisplay = 1
	for i=1,self._MaxLines do
		if self._InputTable[i] then
			if (self._InputTable[i] == "IMG_"..self._nextimagedisplay) && self._images[self._nextimagedisplay] then
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial(self._images[self._nextimagedisplay])
				surface.DrawTexturedRect(xpos+1,ypos-11 + i*12 + self._imagedisplay*(self.w - 2),self.w - 2,self.w - 2)
				self._imagedisplay = self._imagedisplay + 1
				self._nextimagedisplay = self._nextimagedisplay + 1
			else
				draw.SimpleText( self._InputTable[i], "ARCPhoneSmall", xpos+1, ypos-11 + (i-self._imagedisplay)*12 + self._imagedisplay*(self.w - 2), Color(255,255,255,255),TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM )
			end
		end
	end
end
texttile._images = {}
function texttile:UpdateText()
	if self.CanResize then
		table.Empty(self._images)
		local displaytext = self.TextInput
		local matches = {string.gmatch(displaytext, "({{IMG:(.*):(.*):IMG}})")()} --WHY DOES string.gmatch RETURN A FUNCTION INSTEAD OF A TABLE? WHY DO I HAVE TO CALL THAT FUNCTION TO MAKE A TABLE MYSELF?!
		local imgnum = 0
		while #matches > 0 do
			imgnum = imgnum + 1;
			self._images[imgnum] = ARCLib.MaterialFromTxt(matches[2],"jpg")
			displaytext = string.Replace(displaytext, matches[1], "\nIMG_"..imgnum.."\n")
			matches = {string.gmatch(displaytext, "({{IMG:(.*):(.*):IMG}})")()}
		end
		self._InputTable = ARCLib.FitText(displaytext,"ARCPhoneSmall",self.w - 2)

		self._MaxLines = #self._InputTable
		self.h = (self._MaxLines-imgnum) * 12 + 2 + (imgnum*(self.w - 2))

	else
		self._MaxLines = math.floor((self.h-2)/12)
		self._InputTable = ARCLib.FitText(self.TextInput,"ARCPhoneSmall",self.w - 2)
	end
end

function texttile:GetText()
	return self.TextInput
end

function texttile:SetText(text)
	self.TextInput = text
	self:UpdateText()
end

texttile.Editable = true
function texttile:OnUnPressed() 
	if self.Editable then
		self.App.Phone.PauseInput = true
		--MsgN("SETTING TEXT TO "..tostring(self))
		--MsgN("UNPRESSED: "..self:GetText())
		Derma_StringRequest( "ARCPhone", "Text input", self.TextInput, function(text) 
			self.App.Phone.PauseInput = false
			self:SetText(text)
		end,function(text)
			self.App.Phone.PauseInput = false
		end)
	end
end


function ARCPhone.NewAppTextInputTile(app,txt,resize,w)
	local tab = table.Copy(texttile)
	tab.App = app
	tab.w = w or 100
	tab.CanResize = resize
	tab:SetText(txt or "")
	return tab
end

local curapptime = 0
local oldapptime = 0



local ARCPHONE_APP = {}

function ARCPHONE_APP:CreateNewTile(x,y,h,w)
	local tile = ARCPhone.NewAppTile(self)
	tile.tile = true
	tile.x = x or 48
	tile.y = y or 48
	tile.w = h or 16
	tile.h = w or 16
	return tile
end

function ARCPHONE_APP:CreateNewTileTextInput(x,y,h,w)
	local tile = ARCPhone.NewAppTextInputTile(self)
	tile.tile = true
	tile.x = x or 48
	tile.y = y or 48
	tile.w = h or 16
	tile.h = w or 16
	return tile
end


ARCPHONE_APP.ARCPhoneApp = true
ARCPHONE_APP.Name = "Unnamed App"
ARCPHONE_APP.Author = "Anonymous"
ARCPHONE_APP.Purpose = "A brand-new ARCPHONE_APP."
ARCPHONE_APP.DisableTileSwitching = false
--ARCPHONE_APP.Phone = ARCPhone.PhoneSys -- NOT A GOOD IDEA FOR table.FullCopy!!!
ARCPHONE_APP.Disk = {}
ARCPHONE_APP.Tiles = {}
ARCPHONE_APP.Init = NULLFUNC
ARCPHONE_APP.PhoneStart = NULLFUNC
ARCPHONE_APP.OnClose = NULLFUNC
function ARCPHONE_APP:GetSelectedTile()
	return self.Tiles[self.Phone.SelectedAppTile]
end
function ARCPHONE_APP:SetSelectedTileID(id)
	self.Phone.SelectedAppTile = id
end
function ARCPHONE_APP:GetSelectedTileID()
	return self.Phone.SelectedAppTile
end
function ARCPHONE_APP:AddMenuOption(name,func,...)
	self.Options[#self.Options+1] = {}
	self.Options[#self.Options].text = name
	self.Options[#self.Options].func = func
	self.Options[#self.Options].args = {...}
	MsgN("Added menu option with arguments: ")
	for i=1,#self.Options[#self.Options].args do
		MsgN(self.Options[#self.Options].args[i])
	end
end
function ARCPHONE_APP:RemoveMenuOption(name)
	for k,v in pairs(self.Options) do
		if v.text && v.text == name then
			self.Options[k] = nil
		end
	end
end
function ARCPHONE_APP:SaveData()
	file.Write(ARCPhone.ROOTDIR.."/appdata/"..self.sysname..".txt",util.TableToJSON(self.Disk))
end
function ARCPHONE_APP:AddTile(tile)
	assert( tile.tile, "ARCPHONE_APP.AddTile: Bad argument #1; Invalid tile object" )
	self.Tiles[#self.Tiles + 1] = tile
end
function ARCPHONE_APP:RemoveTile(tileid)
	self.Tiles[tileid] = nil
end
function ARCPHONE_APP:ResetTiles(tileid)
	self.Tiles = {}
end
ARCPHONE_APP.BackgroundDraw = NULLFUNC
ARCPHONE_APP.ForegroundDraw = NULLFUNC
function ARCPHONE_APP:DrawTiles(mvx,mvy)
	for k,v in pairs(self.Tiles) do
		--
		if ARCLib.TouchingBox(v.x + mvx,v.x + mvx + v.w,v.y + mvy,v.y + mvy + v.h,0,self.Phone.ScreenResX,0,self.Phone.ScreenResY) then
			
			if v.drawfunc_override then
				v:drawfunc_override(v.x + mvx,v.y + mvy)
			else
				if (!v.bgcolor) then
					v.bgcolor = v.color
				end
				surface.SetDrawColor(ARCLib.ConvertColor(v.bgcolor))
				surface.DrawRect(v.x + mvx,v.y + mvy,v.w,v.h)
				surface.SetDrawColor(ARCLib.ConvertColor(v.color))
				local mfact = 12
				if v.TextureNoresize then
					mfact = 0
				end
				if v.text && string.len(v.text) > 0 then
					mfact = 20
				end
				if v.mat then
					surface.SetMaterial(v.mat)
					
					local rez = v.w - mfact
					if v.w > v.h then
						rez = v.h - mfact
					end
					surface.DrawTexturedRect(v.x + mvx + v.w/2 - rez/2,v.y + mvy + v.h/2 - rez/2,rez,rez)
				elseif v.tex then
					surface.SetTexture(v.tex)
					local rez = v.w - mfact
					if v.w > v.h then
						rez = v.h - mfact
					end
					surface.DrawTexturedRect(v.x + mvx + v.w/2 - rez/2,v.y + mvy + v.h/2 - rez/2,rez,rez)
				end
				if v.drawfunc then
					v:drawfunc(v.x + mvx,v.y + mvy)
				end
				if v.text && string.len(v.text) > 0 then
					draw.SimpleText( ARCLib.CutOutText(v.text,"ARCPhoneSSmall",v.w), "ARCPhoneSSmall", v.x + mvx +1, v.y + mvy + v.h -1, Color(255,255,255,255),TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP ) 
				end
			end
		end
	end
	if self.Tiles[self.Phone.SelectedAppTile] then
		surface.SetDrawColor(255,255,255,255)

		if curapptime <= CurTime() then
			surface.DrawOutlinedRect(self.Tiles[self.Phone.SelectedAppTile].x + mvx,self.Tiles[self.Phone.SelectedAppTile].y + mvy,self.Tiles[self.Phone.SelectedAppTile].w,self.Tiles[self.Phone.SelectedAppTile].h)
		else
			local thing = ARCLib.BetweenNumberScale(oldapptime,CurTime(),curapptime)
			local negthing = -thing + 1
			
			surface.DrawOutlinedRect((self.Tiles[self.Phone.SelectedAppTile].x*thing + self.Tiles[self.Phone.OldSelectedAppTile].x*negthing) + mvx,(self.Tiles[self.Phone.SelectedAppTile].y*thing + self.Tiles[self.Phone.OldSelectedAppTile].y*negthing) + mvy,self.Tiles[self.Phone.SelectedAppTile].w*thing + self.Tiles[self.Phone.OldSelectedAppTile].w*negthing,self.Tiles[self.Phone.SelectedAppTile].h*thing + self.Tiles[self.Phone.OldSelectedAppTile].h*negthing)
		end
	end
end
ARCPHONE_APP.DrawHUD = NULLFUNC
ARCPHONE_APP.TranslateFOV = NULLFUNC
function ARCPHONE_APP:ResetCurPos()
	self.Phone.SelectedAppTile = 1
	self.Phone.OldSelectedAppTile = self.Phone.SelectedAppTile
end
ARCPHONE_APP.ShowTaskbar = true
ARCPHONE_APP.ForegroundThink = NULLFUNC
ARCPHONE_APP.BackgroundThink = NULLFUNC
ARCPHONE_APP.Think = NULLFUNC
ARCPHONE_APP.OnBack = NULLFUNC
ARCPHONE_APP.OnEnter = NULLFUNC
ARCPHONE_APP.OnUp = NULLFUNC
ARCPHONE_APP.OnDown = NULLFUNC
ARCPHONE_APP.OnLeft = NULLFUNC
ARCPHONE_APP.OnRight = NULLFUNC

ARCPHONE_APP.OnBackUp = NULLFUNC
ARCPHONE_APP.OnEnterUp = NULLFUNC
ARCPHONE_APP.OnUpUp = NULLFUNC
ARCPHONE_APP.OnDownUp = NULLFUNC
ARCPHONE_APP.OnLeftUp = NULLFUNC
ARCPHONE_APP.OnRightUp = NULLFUNC

ARCPHONE_APP.OnBackDown = NULLFUNC
ARCPHONE_APP.OnEnterDown = NULLFUNC
ARCPHONE_APP.OnUpDown = NULLFUNC
ARCPHONE_APP.OnDownDown = NULLFUNC
ARCPHONE_APP.OnLeftDown = NULLFUNC
ARCPHONE_APP.OnRightDown = NULLFUNC

function ARCPHONE_APP:_OnEnterDown() 
	self.Tiles[self.Phone.SelectedAppTile]:OnPressed()
end

function ARCPHONE_APP:_OnEnterUp() 
	self.Tiles[self.Phone.SelectedAppTile]:OnUnPressed()
end

function ARCPHONE_APP:_SwitchTile(butt) 
	local ignoresound = false
	local currenttile = self.Tiles[self.Phone.SelectedAppTile]
	
	if (!currenttile) then
		self.Phone.SelectedAppTile = 1
		self.Phone.OldSelectedAppTile = self.Phone.SelectedAppTile
	end
	
	
	local ti = {}
	local bti = false
	local mvscr = false
	if butt == KEY_RIGHT then
		if currenttile.x + currenttile.w + self.Phone.MoveX > self.Phone.ScreenResX - 8 && currenttile.w > self.Phone.ScreenResX then
			self.Phone.BigTileX = self.Phone.BigTileX + self.Phone.ScreenResX - 20
			
		
			mvscr = true
		else
			for k,v in pairs(self.Tiles) do
				if v.x > currenttile.x + currenttile.w then
					ti[#ti+1] = v
					ti[#ti]._number = k
				end
			end
		end
	elseif butt == KEY_LEFT then
		if currenttile.x + self.Phone.MoveX < 8 && currenttile.w > self.Phone.ScreenResX then

			self.Phone.BigTileX = self.Phone.BigTileX - self.Phone.ScreenResX + 20

			mvscr = true
		else
			for k,v in pairs(self.Tiles) do
				if v.x + v.w < currenttile.x then
					ti[#ti+1] = v
					ti[#ti]._number = k
				end
			end
		end
	elseif butt == KEY_DOWN then
		if currenttile.y + currenttile.h + self.Phone.MoveY > self.Phone.ScreenResY - 8 && currenttile.h > self.Phone.ScreenResX then
			self.Phone.BigTileY = self.Phone.BigTileY + self.Phone.ScreenResY - 20

			mvscr = true
		else
			for k,v in pairs(self.Tiles) do
				if v.y > currenttile.y + currenttile.h then
					ti[#ti+1] = v
					ti[#ti]._number = k
				end
			end
		end
	elseif butt == KEY_UP then
		if currenttile.y + self.Phone.MoveY < 29 && currenttile.h > self.Phone.ScreenResX then
			self.Phone.BigTileY = self.Phone.BigTileY - self.Phone.ScreenResY + 41
		

			mvscr = true
		else
			for k,v in pairs(self.Tiles) do
				if v.y + v.h < currenttile.y then
					ti[#ti+1] = v
					ti[#ti]._number = k
				end
			end
		end
	end
	
	if #ti > 0 then
		local di = math.huge
		for i = 1,#ti do
			local curdis = 0
			if butt == KEY_RIGHT then
				curdis = math.Distance((currenttile.x + currenttile.w), (currenttile.y + currenttile.h*0.5), ti[i].x , (ti[i].y + ti[i].h*0.5) )
			elseif butt == KEY_LEFT then
				curdis = math.Distance(currenttile.x, (currenttile.y + currenttile.h*0.5), ti[i].x + ti[i].w, (ti[i].y + ti[i].h*0.5) )
			elseif butt == KEY_DOWN then
				curdis = math.Distance((currenttile.x + currenttile.w*0.5), (currenttile.y + currenttile.h), (ti[i].x + ti[i].w*0.5), ti[i].y )
			elseif butt == KEY_UP then
				curdis = math.Distance((currenttile.x + currenttile.w*0.5), currenttile.y , (ti[i].x + ti[i].w*0.5), ti[i].y + ti[i].h) 
			end
			
			if curdis < di then
				bti = ti[i]._number
				di = curdis
			end
		end
	end
	if bti then
		self.Phone:EmitSound("buttons/button9.wav",60,255)
		curapptime = CurTime() + 0.1
		oldapptime = CurTime()
		currenttile:OnUnSelected()
		if (input.IsKeyDown(KEY_ENTER) || input.WasKeyPressed(KEY_ENTER)) then
			currenttile:OnUnPressed()
		end
		self.Phone.OldSelectedAppTile = self.Phone.SelectedAppTile
		self.Phone.SelectedAppTile = bti 
		if butt == KEY_RIGHT then
			self.Phone.BigTileX = self.Tiles[bti].x
		elseif butt == KEY_LEFT then
			self.Phone.BigTileX = self.Tiles[bti].x + self.Tiles[bti].w - self.Phone.ScreenResX + 8
		elseif butt == KEY_DOWN then
			self.Phone.BigTileY = self.Tiles[bti].y
		elseif butt == KEY_UP then
			self.Phone.BigTileY = self.Tiles[bti].y + self.Tiles[bti].h - self.Phone.ScreenResY + 8
		end
		self.Tiles[bti]:OnSelected()
		if (input.IsKeyDown(KEY_ENTER) || input.WasKeyPressed(KEY_ENTER)) then
			self.Tiles[bti]:OnPressed()
		end
	elseif butt == KEY_BACKSPACE || butt == KEY_ENTER || mvscr then
		self.Phone:EmitSound("buttons/button9.wav",60,255)
	else
		self.Phone:EmitSound("common/wpn_denyselect.wav")
	end
end

function ARCPhone.NewAppObject()
	local tab = table.FullCopy(ARCPHONE_APP)
	tab.Phone = ARCPhone.PhoneSys
	tab.Options = {}
	tab.Options[1] = {}
	tab.Options[1].text = "About"
	tab.Options[1].func = function(app) app.Phone:AddMsgBox("About",tostring(app.Name).."\nby: "..tostring(app.Author).."\n\n"..tostring(app.Purpose),"box") end
	tab.Options[1].args = {tab}
	return tab
end
function ARCPhone.RegisterApp(app,name)
	assert( istable(app), "ARCPhone.RegisterApp: Bad argument #1; All I wanted was a table, but I got some sort of "..type(app).." thing..." )
	assert( app.ARCPhoneApp, "ARCPhone.RegisterApp: Bad argument #1; This doesn't look like an ARCPhone app to me!" )
	assert( isstring(name), "ARCPhone.RegisterApp: Bad argument #2; All I wanted was a string, but I got some sort of "..type(name).." thing..." )
	name = string.lower(string.gsub(name, "[^_%w]", "_"))
	app.sysname = name
	ARCPhone.Apps[name] = app
	MsgN(name.." registered!")
end