-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
ARCPhone.Apps = ARCPhone.Apps or {}



local ARCPHONE_APP = {}
ARCPHONE_APP._curapptime = 0
ARCPHONE_APP._oldapptime = 0
local tileThing = function(self,id)
	if id == self.SelectedAppTile then
		self.SelectedAppTile = nil
		self:SetSelectedTileID(id)
	end
end
function ARCPHONE_APP:CreateNewTile(x,y,w,h)
	local tile = ARCPhone.NewAppTile(self)
	tile.tile = true
	tile.x = x or 48
	tile.y = y or 48
	tile.h = h or 16
	tile.w = w or 16
	tile.ID = ARCLib.TableFillGapInsert(self.Tiles,tile)
	tileThing(self,tile.ID)
	return tile
end

function ARCPHONE_APP:CreateNewTileTextInput(x,y,w,h,txt,resize)
	local tile = ARCPhone.NewAppTextInputTile(self,txt,resize,w)
	tile.tile = true
	tile.x = x or 48
	tile.y = y or 48
	tile.h = h or 16
	tile.ID = ARCLib.TableFillGapInsert(self.Tiles,tile)
	tileThing(self,tile.ID)
	return tile
end
function ARCPHONE_APP:CreateNewTileColor(x,y,w,h,col,txt)
	local tile = ARCPhone.NewAppColorInputTile(self,col,txt)
	tile.tile = true
	tile.x = x or 48
	tile.y = y or 48
	tile.h = h or 16
	tile.w = w or 16
	tile.ID = ARCLib.TableFillGapInsert(self.Tiles,tile)
	tileThing(self,tile.ID)
	return tile
end

function ARCPHONE_APP:CreateNewTileChoice(x,y,w,h)
	local tile = ARCPhone.NewAppChoiceInputTile(self)
	tile.tile = true
	tile.x = x or 48
	tile.y = y or 48
	tile.h = h or 16
	tile.w = w or 16
	tile.ID = ARCLib.TableFillGapInsert(self.Tiles,tile)
	tileThing(self,tile.ID)
	return tile
end

function ARCPHONE_APP:CreateNewTileNumberInput(x,y,w,h,txt)
	local tile = ARCPhone.NewAppNumberInputTile(self,txt)
	tile.tile = true
	tile.x = x or 48
	tile.y = y or 48
	tile.h = h or 16
	tile.w = w or 16
	tile.ID = ARCLib.TableFillGapInsert(self.Tiles,tile)
	tileThing(self,tile.ID)
	return tile
end

function ARCPHONE_APP:CreateNewLabel(x,y,w,h,tex,font,color,bgcolor,xAlign,yAlign)
	local tile = ARCPhone.NewAppLabel(self,x,y,w,h,tex,font,color,bgcolor,xAlign,yAlign)
	tile.label = true
	tile.ID = ARCLib.TableFillGapInsert(self.Labels,tile)
	
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
ARCPHONE_APP.OnRestore = NULLFUNC
ARCPHONE_APP.OnMinimize = NULLFUNC

ARCPHONE_APP.Foreground = false
function ARCPHONE_APP:IsInForeground()
	return self.Foreground
end


function ARCPHONE_APP:Close()
	self.Phone:CloseApp(self.sysname)
end
function ARCPHONE_APP:GetSelectedTile()
	return self.Tiles[self.SelectedAppTile]
end
function ARCPHONE_APP:SetSelectedTileID(bti)
	local s = self.Phone.Settings.System
	local currenttile = self.Tiles[self.SelectedAppTile]
	if IsValid(currenttile) then
		currenttile:OnUnSelected()
		if (input.IsKeyDown(s.KeyEnter) or input.WasKeyPressed(s.KeyEnter)) then
			currenttile:OnUnPressed()
		end
		self._curapptime = CurTime() + 0.1
		self._oldapptime = CurTime()
	end
	self.OldSelectedAppTile = self.SelectedAppTile
	self.SelectedAppTile = bti 
	if IsValid(self.Tiles[bti]) then
		self.Tiles[bti]:OnSelected()
		if (input.IsKeyDown(s.KeyEnter) or input.WasKeyPressed(s.KeyEnter)) then
			self.Tiles[bti]:OnPressed()
		end
	else
		local k, v = next( self.Tiles )
		if k then
			self.SelectedAppTile = k
			self.OldSelectedAppTile = k
			if IsValid(v) then
				v:OnSelected()
				if (input.IsKeyDown(s.KeyEnter) or input.WasKeyPressed(s.KeyEnter)) then
					v:OnPressed()
				end
			end
		end
	end
end
function ARCPHONE_APP:GetSelectedTileID()
	return self.SelectedAppTile
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
	self.Options[1].func = function(app) app.Phone:AddMsgBox("About",tostring(app.Name).."\nby: "..tostring(app.Author).."\n"..tostring(app.Purpose),"memory-chip") end
	self.Options[1].args = {self}
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
function ARCPHONE_APP:PreDraw()
	if not self.Tiles[self.SelectedAppTile] then return end
	local relx1 = self.Tiles[self.SelectedAppTile].x + self.MoveX
	local relx2 = self.Tiles[self.SelectedAppTile].x + self.Tiles[self.SelectedAppTile].w + self.MoveX
	local rely1 = self.Tiles[self.SelectedAppTile].y + self.MoveY
	local rely2 = self.Tiles[self.SelectedAppTile].y + self.Tiles[self.SelectedAppTile].h + self.MoveY
	if self.Tiles[self.SelectedAppTile].w > self.Phone.ScreenResX then
		relx1 = self.BigTileX + self.MoveX

		if relx2 >= self.Phone.ScreenResX - 20 then
			relx2 = self.BigTileX + self.MoveX + self.Phone.ScreenResX - 20
		end
	end
	if self.Tiles[self.SelectedAppTile].h > self.Phone.ScreenResY then
		rely1 = self.BigTileY + self.MoveY
		if rely2 >= self.Phone.ScreenResY - 20 then
			rely2 = self.BigTileY + self.MoveY + self.Phone.ScreenResY - 20
		end
	end

	if relx1 < 6 then
		local dist = -relx1+6
		self.MoveX = self.MoveX + math.ceil(dist*0.2)
	end
	if relx2 > self.Phone.ScreenResX - 6 then
		local dist = relx2 - (self.Phone.ScreenResX - 6)
		self.MoveX = self.MoveX - math.ceil(dist*0.2)
		math.ceil(dist*0.2)
	end

	if rely1 < 29 then
		local dist = -rely1+29
		self.MoveY = self.MoveY + math.ceil(dist*0.2)
	end
	if rely2 > self.Phone.ScreenResY - 8 then
		local dist = rely2 - (self.Phone.ScreenResY - 8)
		self.MoveY = self.MoveY - math.ceil(dist*0.2)
	end
end
ARCPHONE_APP.BackgroundDraw = NULLFUNC
ARCPHONE_APP.ForegroundDraw = NULLFUNC
function ARCPHONE_APP:DrawTiles(mvx,mvy)
	local FuckingHell
	local AreYouKiddingMe
	for k,v in pairs(self.Tiles) do
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
						draw.SimpleText( ARCLib.CutOutText(v.text,"ARCPhoneSmall",v.w-1), "ARCPhoneSmall", v.x + mvx +1, v.y + mvy + v.h -1, FuckingHell,TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM ) 
					else
						--MsgN("TXT:"..ARCLib.CutOutText(v.text,"ARCPhone",v.w-1))
						draw.SimpleText(ARCLib.CutOutText(v.text,"ARCPhone",v.w-1), "ARCPhone", v.x + mvx+v.w*0.5, v.y + mvy+v.h*0.5, FuckingHell, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
					end
				end
			end
		end
	end
	
	for k,v in pairs(self.Tiles) do
		if ARCLib.TouchingBox(v.x + mvx,v.x + mvx + v.w,v.y + mvy,v.y + mvy + v.h,0,self.Phone.ScreenResX,0,self.Phone.ScreenResY) then
			if v.drawfunc2 then
				v:drawfunc2(v.x + mvx,v.y + mvy)
			end
		end
	end
	
	if self.Tiles[self.SelectedAppTile] && self.Phone.ChoiceInputTile == nil then
		if self.Phone.TextInputTile == self.Tiles[self.SelectedAppTile] || self.Phone.ColourInputTile == self.Tiles[self.SelectedAppTile] then
			if math.sin(CurTime()*math.pi*2) > 0 then
				surface.SetDrawColor(ARCLib.ConvertColor(ARCLib.ColorNegative(self.Phone.Settings.Personalization.CL_00_CursorColour)))
			else
				surface.SetDrawColor(ARCLib.ConvertColor(self.Phone.Settings.Personalization.CL_00_CursorColour))
			end
		else
			surface.SetDrawColor(ARCLib.ConvertColor(self.Phone.Settings.Personalization.CL_00_CursorColour))
		end
		if self._curapptime <= CurTime() then
			surface.DrawOutlinedRect(self.Tiles[self.SelectedAppTile].x + mvx,self.Tiles[self.SelectedAppTile].y + mvy,self.Tiles[self.SelectedAppTile].w,self.Tiles[self.SelectedAppTile].h)
		else
			local thing = ARCLib.BetweenNumberScale(self._oldapptime,CurTime(),self._curapptime)^0.5
			local negthing = -thing + 1
			
			surface.DrawOutlinedRect((self.Tiles[self.SelectedAppTile].x*thing + self.Tiles[self.OldSelectedAppTile].x*negthing) + mvx,(self.Tiles[self.SelectedAppTile].y*thing + self.Tiles[self.OldSelectedAppTile].y*negthing) + mvy,self.Tiles[self.SelectedAppTile].w*thing + self.Tiles[self.OldSelectedAppTile].w*negthing,self.Tiles[self.SelectedAppTile].h*thing + self.Tiles[self.OldSelectedAppTile].h*negthing)
		end
	end
end
function ARCPHONE_APP:DrawLabels(mvx,mvy)
	for k,v in pairs(self.Labels) do
		surface.SetDrawColor(v.bgcolor)
		surface.DrawRect(mvx + v.x,mvy + v.y,v.w,v.h)
		for i=1,#v.Texts do
			v.Texts[i].args[3] = v.Texts[i].x + mvx
			v.Texts[i].args[4] = v.Texts[i].y + mvy
			draw.DrawText(unpack(v.Texts[i].args))
		end
	end
end
ARCPHONE_APP.DrawHUD = NULLFUNC
ARCPHONE_APP.TranslateFOV = NULLFUNC
function ARCPHONE_APP:ResetCurPos()
	self.SelectedAppTile = nil
	self:SetSelectedTileID(1)
end
ARCPHONE_APP.SetCurPos = ARCPHONE_APP.SetSelectedTileID

function ARCPHONE_APP:SelectTile(tile)
	self:SetSelectedTileID(tile.ID or 1)
end


function ARCPHONE_APP:RegisterTextNumber()
	assert(ARCPhone.IsValidPhoneNumber(self.Number),"ARCPHONE_APP.RegisterTextNumber: Bad argument #1: Invalid phone number")
	assert(string.sub( self.Number, 1, 3 ) == "000","ARCPHONE_APP.RegisterTextNumber: Bad argument #1: Phone number must start with 000")
	self.Phone.TextApps[self.Number] = self
end
function ARCPHONE_APP:SendText(data)
	assert(ARCPhone.IsValidPhoneNumber(self.Number),"ARCPHONE_APP.SendText: This app isn't registered to text!")
	return ARCPhone.PhoneSys:SendText(self.Number,data,true)
end

ARCPHONE_APP.ShowTaskbar = true
ARCPHONE_APP.ForegroundThink = NULLFUNC
ARCPHONE_APP.BackgroundThink = NULLFUNC
ARCPHONE_APP.Think = NULLFUNC
ARCPHONE_APP.OnText = NULLFUNC -- (TIME,DATA)
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

function ARCPHONE_APP:IsSelectedTileValid()
	return IsValid(self.Tiles[self.SelectedAppTile])
end

function ARCPHONE_APP:_OnEnterDown()
	local selectedTile = self.Tiles[self.SelectedAppTile]
	if IsValid(selectedTile) then
		selectedTile:OnPressed()
	end
end

function ARCPHONE_APP:_OnEnterUp() 
	local selectedTile = self.Tiles[self.SelectedAppTile]
	if IsValid(selectedTile) then
		selectedTile:OnUnPressed()
	end
end

local function searcheq(x)
	return math.sin((x+1.5) * math.pi) * math.floor((x+1.5)/2)
end
function ARCPHONE_APP:_SwitchTile(butt)
	local s = self.Phone.Settings.System
	local ignoresound = false
	local currenttile = self.Tiles[self.SelectedAppTile]
	
	if (not IsValid(currenttile)) then
		self:ResetCurPos()
		self.Phone:EmitSound("arcphone/menus/press.wav",50,100,0.8)
		return
	end
	
	local ti = {}
	local potential = {}
	local bti = false
	local mvscr = false
	if butt == s.KeyRight then
		if currenttile.x + currenttile.w + self.MoveX > self.Phone.ScreenResX - 8 && currenttile.w > self.Phone.ScreenResX then
			self.BigTileX = self.BigTileX + self.Phone.ScreenResX - 20
			mvscr = true
		else

			for k,v in pairs(self.Tiles) do
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
	elseif butt == s.KeyLeft then
		if currenttile.x + self.MoveX < 8 && currenttile.w > self.Phone.ScreenResX then
			self.BigTileX = self.BigTileX - self.Phone.ScreenResX + 20
			mvscr = true
		else
			for k,v in pairs(self.Tiles) do
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
	elseif butt == s.KeyDown then
		if currenttile.y + currenttile.h + self.MoveY > self.Phone.ScreenResY - 8 && currenttile.h > self.Phone.ScreenResX then
			self.BigTileY = self.BigTileY + self.Phone.ScreenResY - 20
			mvscr = true
		else
			for k,v in pairs(self.Tiles) do
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
	elseif butt == s.KeyUp then
		if currenttile.y + self.MoveY < 29 && currenttile.h > self.Phone.ScreenResX then
			self.BigTileY = self.BigTileY - self.Phone.ScreenResY + 41
			mvscr = true
		else
			for k,v in pairs(self.Tiles) do
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
			if butt == s.KeyRight then
				curdis = ARCLib.PointDistToLine(currenttile.x + currenttile.w,currenttile.y,currenttile.x + currenttile.w,currenttile.y + currenttile.h,ti[i].x,ti[i].y)
			elseif butt == s.KeyLeft then
				curdis = ARCLib.PointDistToLine(currenttile.x, currenttile.y, currenttile.x, currenttile.y + currenttile.h,ti[i].x + ti[i].w,ti[i].y + ti[i].h)
			elseif butt == s.KeyDown then
				curdis = ARCLib.PointDistToLine(currenttile.x, currenttile.y + currenttile.h, currenttile.x + currenttile.w, currenttile.y + currenttile.h,ti[i].x,ti[i].y)
			elseif butt == s.KeyUp then
				curdis = ARCLib.PointDistToLine(currenttile.x, currenttile.y, currenttile.x + currenttile.w, currenttile.y,ti[i].x + ti[i].w,ti[i].y + ti[i].h)
			end
			
			if curdis < di then
				bti = ti[i]._number
				di = curdis
			end
		end
	end
	if bti then
		self.Phone:EmitSound("arcphone/menus/press.wav",50,100,0.8)
		self:SetSelectedTileID(bti)
		if butt == s.KeyRight then
			self.BigTileX = self.Tiles[bti].x
		elseif butt == s.KeyLeft then
			self.BigTileX = self.Tiles[bti].x + self.Tiles[bti].w - self.Phone.ScreenResX + 8
		elseif butt == s.KeyDown then
			self.BigTileY = self.Tiles[bti].y
		elseif butt == s.KeyUp then
			self.BigTileY = self.Tiles[bti].y + self.Tiles[bti].h - self.Phone.ScreenResY + 8
		end
	elseif butt == s.KeyBack || butt == s.KeyEnter || mvscr then
		self.Phone:EmitSound("arcphone/menus/press.wav",50,100,0.8)
	else
		self.Phone:EmitSound("common/wpn_denyselect.wav",50,100,0.8)
	end
end
ARCPHONE_APP.OldSelectedAppTile = 1
ARCPHONE_APP.SelectedAppTile = 1
ARCPHONE_APP.MoveX = 0
ARCPHONE_APP.MoveY = 0
ARCPHONE_APP.BigTileX = 0
ARCPHONE_APP.BigTileY = 0
function ARCPHONE_APP:Draw()
	self:PreDraw()
	self:BackgroundDraw(self.MoveX,self.MoveY)
	self:DrawLabels(self.MoveX,self.MoveY)
	self:DrawTiles(self.MoveX,self.MoveY)
	self:ForegroundDraw(self.MoveX,self.MoveY)
end
function ARCPHONE_APP:ResetScreenPos()
	self.MoveX = 0
	self.MoveY = 0
end
local aboutFunc = function(app) app.Phone:AddMsgBox("About",tostring(app.Name).."\nby: "..tostring(app.Author).."\n"..tostring(app.Purpose),"memory-chip") end
function ARCPhone.NewAppObject()
	local tab = table.FullCopy(ARCPHONE_APP)
	tab.Phone = ARCPhone.PhoneSys
	tab.Options = {}
	tab.Options[1] = {}
	tab.Options[1].text = "About"
	tab.Options[1].func = aboutFunc
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