-- app_util.lua - app utilities
-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright Aritz Beobide-Cardinal 2014 All rights reserved.
ARCPhone.Apps = ARCPhone.Apps or {}

local curapptime = 0
local oldapptime = 0

local ARCPHONE_APP = {}

function ARCPHONE_APP:CreateNewTile(x,y,h,w)
	local tile = ARCPhone.NewAppTile(self)
	tile.tile = true
	tile.x = x or 48
	tile.y = y or 48
	tile.h = h or 16
	tile.h = w or 16
	self.Tiles[#self.Tiles + 1] = tile
	tile.ID = #self.Tiles
	return tile
end

function ARCPHONE_APP:CreateNewTileTextInput(x,y,h,w,txt,resize)
	local tile = ARCPhone.NewAppTextInputTile(self,txt,resize,w)
	tile.tile = true
	tile.x = x or 48
	tile.y = y or 48
	tile.h = h or 16
	self.Tiles[#self.Tiles + 1] = tile
	tile.ID = #self.Tiles
	return tile
end
function ARCPHONE_APP:CreateNewTileColor(x,y,h,w,col,txt)
	local tile = ARCPhone.NewAppColorInputTile(self,col,txt)
	tile.tile = true
	tile.x = x or 48
	tile.y = y or 48
	tile.h = h or 16
	tile.h = w or 16
	self.Tiles[#self.Tiles + 1] = tile
	tile.ID = #self.Tiles
	return tile
end

function ARCPHONE_APP:CreateNewTileChoice(x,y,h,w)
	local tile = ARCPhone.NewAppChoiceInputTile(self)
	tile.tile = true
	tile.x = x or 48
	tile.y = y or 48
	tile.h = h or 16
	tile.h = w or 16
	self.Tiles[#self.Tiles + 1] = tile
	tile.ID = #self.Tiles
	return tile
end

function ARCPHONE_APP:CreateNewTileNumberInput(x,y,h,w,txt)
	local tile = ARCPhone.NewAppNumberInputTile(self,txt)
	tile.tile = true
	tile.x = x or 48
	tile.y = y or 48
	tile.h = h or 16
	tile.h = w or 16
	self.Tiles[#self.Tiles + 1] = tile
	tile.ID = #self.Tiles
	return tile
end

function ARCPHONE_APP:CreateNewLabel(x,y,w,h,tex,font,color,bgcolor,xAlign,yAlign)
	local tile = ARCPhone.NewAppLabel(self,x,y,w,h,tex,font,color,bgcolor,xAlign,yAlign)
	tile.label = true
	self.Labels[#self.Labels + 1] = tile
	tile.ID = #self.Labels
	return tile
end

ARCPHONE_APP.ARCPhoneApp = true
ARCPHONE_APP.Name = "Unnamed App"
ARCPHONE_APP.Author = "Anonymous"
ARCPHONE_APP.Purpose = "A brand-new ARCPhone app."
ARCPHONE_APP.DisableTileSwitching = false
--ARCPHONE_APP.Phone = ARCPhone.PhoneSys -- NOT A GOOD IDEA FOR table.FullCopy!!!
ARCPHONE_APP.Disk = {}
ARCPHONE_APP.Tiles = {}
ARCPHONE_APP.Labels = {}
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
	local place = #self.Options+1
	for k,v in ipairs(self.Options) do
		if v.text && v.text == name then
			place = k
		end
	end
	self.Options[place] = {}
	self.Options[place].text = name
	self.Options[place].func = func
	self.Options[place].args = {...}
end
function ARCPHONE_APP:RemoveMenuOption(name)
	for k,v in pairs(self.Options) do
		if v.text && v.text == name then
			self.Options[k] = nil
		end
	end
	self.Options = ARCLib.TableToSequential(self.Options)
end
function ARCPHONE_APP:RenameMenuOption(name,new)
	for k,v in pairs(self.Options) do
		if v.text && v.text == name then
			v.text = new
		end
	end
end
function ARCPHONE_APP:ClearOptions()
	table.Empty(self.Options)
	self.Options[1] = {}
	self.Options[1].text = "About"
	self.Options[1].func = function(app) app.Phone:AddMsgBox("About",tostring(app.Name).."\nby: "..tostring(app.Author).."\n"..tostring(app.Purpose),"box") end
	self.Options[1].args = {tab}
end
function ARCPHONE_APP:SaveData()
	file.Write(ARCPhone.ROOTDIR.."/appdata/"..self.sysname..".txt",util.TableToJSON(self.Disk))
end

function ARCPHONE_APP:RemoveTile(tileid)
	self.Tiles[tileid] = nil
end
function ARCPHONE_APP:ClearTiles()
	table.Empty(self.Tiles)
	self:ResetCurPos()
end
function ARCPHONE_APP:ClearLabels()
	table.Empty(self.Labels)
end
function ARCPHONE_APP:ClearScreen()
	self:ClearTiles()
	self:ClearLabels()
end
ARCPHONE_APP.BackgroundDraw = NULLFUNC
ARCPHONE_APP.ForegroundDraw = NULLFUNC
function ARCPHONE_APP:DrawTiles(mvx,mvy)
	local FuckingHell
	local AreYouKiddingMe
	for k,v in ipairs(self.Tiles) do
		if ARCLib.TouchingBox(v.x + mvx,v.x + mvx + v.w,v.y + mvy,v.y + mvy + v.h,0,self.Phone.ScreenResX,0,self.Phone.ScreenResY) then
			if v.drawfunc_override then
				v:drawfunc_override(v.x + mvx,v.y + mvy)
			else
				if (!v.bgcolor) then
					AreYouKiddingMe = v.color
					FuckingHell = color_white
				else
					AreYouKiddingMe = v.bgcolor
					FuckingHell = v.color
				end
				surface.SetDrawColor(ARCLib.ConvertColor(AreYouKiddingMe))
				surface.DrawRect(v.x + mvx,v.y + mvy,v.w,v.h)
				surface.SetDrawColor(ARCLib.ConvertColor(FuckingHell))
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
					if v.mat || v.tex then
						draw.SimpleText( ARCLib.CutOutText(v.text,"ARCPhoneSmall",v.w-1), "ARCPhoneSmall", v.x + mvx +1, v.y + mvy + v.h -1, FuckingHell,TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP ) 
					else
						--MsgN("TXT:"..ARCLib.CutOutText(v.text,"ARCPhone",v.w-1))
						draw.SimpleText(ARCLib.CutOutText(v.text,"ARCPhone",v.w-1), "ARCPhone", v.x + mvx+v.w*0.5, v.y + mvy+v.h*0.5, FuckingHell, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
					end
				end
			end
		end
	end
	
	for k,v in ipairs(self.Tiles) do
		if ARCLib.TouchingBox(v.x + mvx,v.x + mvx + v.w,v.y + mvy,v.y + mvy + v.h,0,self.Phone.ScreenResX,0,self.Phone.ScreenResY) then
			if v.drawfunc2 then
				v:drawfunc2(v.x + mvx,v.y + mvy)
			end
		end
	end
	
	if self.Tiles[self.Phone.SelectedAppTile] && self.Phone.ChoiceInputTile == nil then
		if self.Phone.TextInputTile == self.Tiles[self.Phone.SelectedAppTile] || self.Phone.ColourInputTile == self.Tiles[self.Phone.SelectedAppTile] then
			if math.sin(CurTime()*math.pi*2) > 0 then
				surface.SetDrawColor(ARCLib.ConvertColor(ARCLib.ColorNegative(self.Phone.Settings.Personalization.CL_00_CursorColour)))
			else
				surface.SetDrawColor(ARCLib.ConvertColor(self.Phone.Settings.Personalization.CL_00_CursorColour))
			end
		else
			surface.SetDrawColor(ARCLib.ConvertColor(self.Phone.Settings.Personalization.CL_00_CursorColour))
		end
		if curapptime <= CurTime() then
			surface.DrawOutlinedRect(self.Tiles[self.Phone.SelectedAppTile].x + mvx,self.Tiles[self.Phone.SelectedAppTile].y + mvy,self.Tiles[self.Phone.SelectedAppTile].w,self.Tiles[self.Phone.SelectedAppTile].h)
		else
			local thing = ARCLib.BetweenNumberScale(oldapptime,CurTime(),curapptime)
			local negthing = -thing + 1
			
			surface.DrawOutlinedRect((self.Tiles[self.Phone.SelectedAppTile].x*thing + self.Tiles[self.Phone.OldSelectedAppTile].x*negthing) + mvx,(self.Tiles[self.Phone.SelectedAppTile].y*thing + self.Tiles[self.Phone.OldSelectedAppTile].y*negthing) + mvy,self.Tiles[self.Phone.SelectedAppTile].w*thing + self.Tiles[self.Phone.OldSelectedAppTile].w*negthing,self.Tiles[self.Phone.SelectedAppTile].h*thing + self.Tiles[self.Phone.OldSelectedAppTile].h*negthing)
		end
	end
end
function ARCPHONE_APP:DrawLabels(mvx,mvy)
	for k,v in pairs(self.Labels) do
		surface.SetDrawColor(v.bgcolor)
		surface.DrawRect(mvx + v.x,mvy + v.y,v.w,v.h)
		for i=1,#v.Texts do
			draw.DrawText(unpack(v.Texts[i]))
		end
	end
end
ARCPHONE_APP.DrawHUD = NULLFUNC
ARCPHONE_APP.TranslateFOV = NULLFUNC
function ARCPHONE_APP:ResetCurPos()
	self.Phone.SelectedAppTile = 1
	self.Phone.OldSelectedAppTile = self.Phone.SelectedAppTile
	if self.Tiles[1] then
		self.Tiles[1]:OnSelected()
	end
end

function ARCPHONE_APP:SetCurPos(pos)
	self.Phone.OldSelectedAppTile = self.Phone.SelectedAppTile
	if self.Tiles[self.Phone.OldSelectedAppTile] then
		self.Tiles[self.Phone.OldSelectedAppTile]:OnUnSelected()
	end
	self.Phone.SelectedAppTile = pos
	self.Tiles[pos]:OnSelected()
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

local function searcheq(x)
	return math.sin((x+1.5) * math.pi) * math.floor((x+1.5)/2)
end
function ARCPHONE_APP:_SwitchTile(butt) 
	local ignoresound = false
	local currenttile = self.Tiles[self.Phone.SelectedAppTile]
	
	if (!currenttile) then
		self.Phone.SelectedAppTile = 1
		self.Phone.OldSelectedAppTile = self.Phone.SelectedAppTile
	end
	if (!currenttile) then
		self.Phone:EmitSound("common/wpn_denyselect.wav")
	end
	
	local ti = {}
	local potential = {}
	local bti = false
	local mvscr = false
	if butt == KEY_RIGHT then
		if currenttile.x + currenttile.w + self.Phone.MoveX > self.Phone.ScreenResX - 8 && currenttile.w > self.Phone.ScreenResX then
			self.Phone.BigTileX = self.Phone.BigTileX + self.Phone.ScreenResX - 20
			mvscr = true
		else

			for k,v in ipairs(self.Tiles) do
				if v.x > currenttile.x + currenttile.w then
					potential[#potential+1] = v
					potential[#potential]._number = k
				end
			end
			local srch = 0
			if #potential > 0 then
				while #ti == 0 do
					for k,v in ipairs(potential) do
						if ARCLib.InBetween(currenttile.y + currenttile.h*searcheq(srch),v.y,currenttile.y + currenttile.h + currenttile.h*searcheq(srch)) || ARCLib.InBetween(currenttile.y + currenttile.h*searcheq(srch),v.y + v.h,currenttile.y + currenttile.h + currenttile.h*searcheq(srch)) then
							ti[#ti+1] = v
						end
					end
					srch = srch + 1
				end
			end
		end
	elseif butt == KEY_LEFT then
		if currenttile.x + self.Phone.MoveX < 8 && currenttile.w > self.Phone.ScreenResX then
			self.Phone.BigTileX = self.Phone.BigTileX - self.Phone.ScreenResX + 20
			mvscr = true
		else
			for k,v in ipairs(self.Tiles) do
				if v.x + v.w < currenttile.x then
					potential[#potential+1] = v
					potential[#potential]._number = k
				end
			end
			local srch = 0
			if #potential > 0 then
				while #ti == 0 do
					for k,v in ipairs(potential) do
						if ARCLib.InBetween(currenttile.y + currenttile.h*searcheq(srch),v.y,currenttile.y + currenttile.h + currenttile.h*searcheq(srch)) || ARCLib.InBetween(currenttile.y + currenttile.h*searcheq(srch),v.y + v.h,currenttile.y + currenttile.h + currenttile.h*searcheq(srch)) then
							ti[#ti+1] = v
						end
					end
					srch = srch + 1
				end
			end
		end
	elseif butt == KEY_DOWN then
		if currenttile.y + currenttile.h + self.Phone.MoveY > self.Phone.ScreenResY - 8 && currenttile.h > self.Phone.ScreenResX then
			self.Phone.BigTileY = self.Phone.BigTileY + self.Phone.ScreenResY - 20
			mvscr = true
		else
			for k,v in ipairs(self.Tiles) do
				if v.y > currenttile.y + currenttile.h then
					potential[#potential+1] = v
					potential[#potential]._number = k
				end
			end
			local srch = 0
			if #potential > 0 then
				while #ti == 0 do
					for k,v in ipairs(potential) do
						if ARCLib.InBetween(currenttile.x + currenttile.w*searcheq(srch),v.x,currenttile.x + currenttile.w + currenttile.w*searcheq(srch)) || ARCLib.InBetween(currenttile.x + currenttile.w*searcheq(srch),v.x + v.w,currenttile.x + currenttile.w + currenttile.w*searcheq(srch)) then
							ti[#ti+1] = v
						end
					end
					srch = srch + 1
				end
			end
		end
	elseif butt == KEY_UP then
		if currenttile.y + self.Phone.MoveY < 29 && currenttile.h > self.Phone.ScreenResX then
			self.Phone.BigTileY = self.Phone.BigTileY - self.Phone.ScreenResY + 41
			mvscr = true
		else
			for k,v in ipairs(self.Tiles) do
				if v.y + v.h < currenttile.y then
					potential[#potential+1] = v
					potential[#potential]._number = k
				end
			end
			local srch = 0
			if #potential > 0 then
				while #ti == 0 do
					for k,v in ipairs(potential) do
						if ARCLib.InBetween(currenttile.x + currenttile.w*searcheq(srch),v.x,currenttile.x + currenttile.w + currenttile.w*searcheq(srch)) || ARCLib.InBetween(currenttile.x + currenttile.w*searcheq(srch),v.x + v.w,currenttile.x + currenttile.w + currenttile.w*searcheq(srch)) then
							ti[#ti+1] = v
						end
					end
					srch = srch + 1
				end
			end
		end
	end
	
	if #ti > 0 then
		local di = math.huge
		
		for i = 1,#ti do
			local curdis = 0
			if butt == KEY_RIGHT then
				curdis = ARCLib.PointDistToLine(currenttile.x + currenttile.w,currenttile.y,currenttile.x + currenttile.w,currenttile.y + currenttile.h,ti[i].x,ti[i].y)
			elseif butt == KEY_LEFT then
				curdis = ARCLib.PointDistToLine(currenttile.x, currenttile.y, currenttile.x, currenttile.y + currenttile.h,ti[i].x + ti[i].w,ti[i].y + ti[i].h)
			elseif butt == KEY_DOWN then
				curdis = ARCLib.PointDistToLine(currenttile.x, currenttile.y + currenttile.h, currenttile.x + currenttile.w, currenttile.y + currenttile.h,ti[i].x,ti[i].y)
			elseif butt == KEY_UP then
				curdis = ARCLib.PointDistToLine(currenttile.x, currenttile.y, currenttile.x + currenttile.w, currenttile.y,ti[i].x + ti[i].w,ti[i].y + ti[i].h)
			end
			
			if curdis < di then
				bti = ti[i]._number
				di = curdis
			end
		end
	end
	if bti then
		self.Phone:EmitSound("arcphone/menus/press.wav",60)
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
		self.Phone:EmitSound("arcphone/menus/press.wav",60)
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
	tab.Options[1].func = function(app) app.Phone:AddMsgBox("About",tostring(app.Name).."\nby: "..tostring(app.Author).."\n"..tostring(app.Purpose),"box") end
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