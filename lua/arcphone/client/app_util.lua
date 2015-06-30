-- app_util.lua - app utilities
-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright Aritz Beobide-Cardinal 2014 All rights reserved.
ARCPhone.Apps = {}


function ARCPhone.NewAppTile()
	local tile = {}
	tile.tile = true
	tile.x = 48
	tile.y = 48
	tile.w = 16
	tile.h = 16
	tile.color = Color(255,255,255,255)
	tile.tex = false
	tile.mat = false
	tile.drawfunc_override = false
	tile.drawfunc = false
	tile.text = ""
	tile.OnPressed = function(phone,app) end
	tile.OnUnPressed = function(phone,app) end
	tile.OnSelected = function(phone,app) end
	tile.OnUnSelected = function(phone,app) end
	return tile
end
--[[
ARCPHONE_TILE_INPUT_TYPE_TEXT = 1
ARCPHONE_TILE_INPUT_TYPE_NUMBER = 2
ARCPHONE_TILE_INPUT_TYPE_TOGGLE = 3
ARCPHONE_TILE_INPUT_TYPE_MENU = 4
ARCPHONE_TILE_INPUT_TYPE_COLOR = 5
ARCPHONE_TILE_INPUT_TYPE_SLIDER = 6

function ARCPhone.NewAppInputTile(typ)
	local tile = ARCPhone.NewAppTile()
	if typ == ARCPHONE_TILE_INPUT_TYPE_TEXT then
	
	end
	return tile
end
]]

function ARCPhone.NewAppTextInputTile(txt,resize,w)
	local tile = ARCPhone.NewAppTile()
	tile.TextInput = txt or ""
	tile.CanResize = resize
	tile.w = w or 100
	if tile.CanResize then
		tile._InputTable = ARCLib.FitText(tile.TextInput,"ARCPhoneSmall",tile.w - 2)
		tile._MaxLines = #tile._InputTable
		tile.h = tile._MaxLines * 12 + 2
	end
	tile.drawfunc = function(phone,app,xpos,ypos)
		if tile.Editable && tile.TextInput != tile.OldTextInput then
			if tile.CanResize then
				tile._InputTable = ARCLib.FitText(tile.TextInput,"ARCPhoneSmall",tile.w - 2)
				tile._MaxLines = #tile._InputTable
				tile.h = tile._MaxLines * 12 + 2
			else
				tile._MaxLines = math.floor((tile.h-2)/12)
				tile._InputTable = ARCLib.FitText(tile.TextInput,"ARCPhoneSmall",tile.w - 2)
			end
			tile.OldTextInput = tile.TextInput
		end
		for i=1,tile._MaxLines do
			if tile._InputTable[i] then
				draw.SimpleText( tile._InputTable[i], "ARCPhoneSmall", xpos+1, ypos-11 + i*12, Color(255,255,255,255),TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM )
			end
		end
		
	end
	tile.Editable = true
	tile.OnUnPressed = function(phone,app) 
		if tile.Editable then
			Derma_StringRequest( "ARCPhone", "Text input", tile.TextInput, function(text) 
				tile.TextInput = text
			end)
		end
	end
	return tile
end

local curapptime = 0
local oldapptime = 0
function ARCPhone.NewAppObject()
	local app = {}
	app.ARCPhoneApp = true
	app.Name = "Unnamed App"
	app.Author = "Anonymous"
	app.Purpose = "A brand-new app."
	app.DisableTileSwitching = false
	app.Phone = ARCPhone.PhoneSys
	app.Disk = {}
	app.Options = {}
	app.Options[1] = {}
	app.Options[1].text = "About"
	
	app.Options[1].func = function(phone,app) phone:AddMsgBox("About",tostring(app.Name).."\nby: "..tostring(app.Author).."\n\n"..tostring(app.Purpose),"box") end
	app.Tiles = {ARCPhone.NewAppTile()}
	function app:Init() end
	function app:GetSelectedTile()
		return self.Tiles[self.Phone.SelectedAppTile]
	end
	function app:SetSelectedTileID(id)
		self.Phone.SelectedAppTile = id
	end
	function app:GetSelectedTileID()
		return self.Phone.SelectedAppTile
	end
	function app:AddMenuOption(name,func)
		self.Options[#self.Options+1] = {}
		self.Options[#self.Options].text = name
		self.Options[#self.Options].func = func
	end
	function app:RemoveMenuOption(name)
		for k,v in pairs(self.Options) do
			if v.text && v.text == name then
				self.Options[k] = nil
			end
		end
	end
	function app:SaveData()
		file.Write(ARCPhone.ROOTDIR.."/appdata/"..self.sysname..".txt",util.TableToJSON(self.Disk))
	end
	function app:AddTile(tile)
		assert( tile.tile, "ARCPHONE_APP.AddTile: Bad argument #1; Invalid tile object" )
		self.Tiles[#self.Tiles + 1] = tile
	end
	function app:RemoveTile(tileid)
		self.Tiles[tileid] = nil
	end
	function app:ResetTiles(tileid)
		self.Tiles = {}
	end
	function app:BackgroundDraw(phone) end
	function app:ForegroundDraw(phone) end
	function app:DrawTiles(phone,mvx,mvy)
		for k,v in pairs(self.Tiles) do
			--
			if ARCLib.TouchingBox(v.x + mvx,v.x + mvx + v.w,v.y + mvy,v.y + mvy + v.h,0,128,0,224) then
				
				if v.drawfunc_override then
					v.drawfunc_override(phone,app,v.x + mvx,v.y + mvy)
				else
					if (!v.bgcolor) then
						v.bgcolor = v.color
					end
					surface.SetDrawColor(ARCLib.ConvertColor(v.bgcolor))
					surface.DrawRect(v.x + mvx,v.y + mvy,v.w,v.h)
					surface.SetDrawColor(ARCLib.ConvertColor(v.color))
					local mfact = 12
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
						v.drawfunc(phone,app,v.x + mvx,v.y + mvy)
					end
					if v.text && string.len(v.text) > 0 then
						draw.SimpleText( ARCLib.CutOutText(v.text,"ARCPhoneSSmall",v.w), "ARCPhoneSSmall", v.x + mvx +1, v.y + mvy + v.h -1, Color(255,255,255,255),TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP ) 
					end
				end
			end
		end
		if self.Tiles[phone.SelectedAppTile] then
			surface.SetDrawColor(255,255,255,255)

			if curapptime <= CurTime() then
				surface.DrawOutlinedRect(self.Tiles[phone.SelectedAppTile].x + mvx,self.Tiles[phone.SelectedAppTile].y + mvy,self.Tiles[phone.SelectedAppTile].w,self.Tiles[phone.SelectedAppTile].h)
			else
				local thing = ARCLib.BetweenNumberScale(oldapptime,CurTime(),curapptime)
				local negthing = -thing + 1
				
				surface.DrawOutlinedRect((self.Tiles[phone.SelectedAppTile].x*thing + self.Tiles[phone.OldSelectedAppTile].x*negthing) + mvx,(self.Tiles[phone.SelectedAppTile].y*thing + self.Tiles[phone.OldSelectedAppTile].y*negthing) + mvy,self.Tiles[phone.SelectedAppTile].w*thing + self.Tiles[phone.OldSelectedAppTile].w*negthing,self.Tiles[phone.SelectedAppTile].h*thing + self.Tiles[phone.OldSelectedAppTile].h*negthing)
			end
		end
	end
	app.ShowTaskbar = true
	function app:ForegroundThink() end
	function app:BackgroundThink() end
	function app:Think() end
	function app:OnBack() end
	function app:OnEnter() end
	function app:OnUp() end
	function app:OnDown() end
	function app:OnLeft() end
	function app:OnRight() end
	
	function app:OnBackUp() end
	function app:OnEnterUp() end
	function app:OnUpUp() end
	function app:OnDownUp() end
	function app:OnLeftUp() end
	function app:OnRightUp() end
	
	function app:OnBackDown() end
	function app:OnEnterDown() end
	function app:OnUpDown() end
	function app:OnDownDown() end
	function app:OnLeftDown() end
	function app:OnRightDown() end
	
	function app:_OnEnterDown(phone) 
		self.Tiles[phone.SelectedAppTile].OnPressed(phone,self)
	end
	
	function app:_OnEnterUp(phone) 
		self.Tiles[phone.SelectedAppTile].OnUnPressed(phone,self)
	end
	
	function app:_SwitchTile(phone,butt) 
		local ignoresound = false
		local currenttile = self.Tiles[phone.SelectedAppTile]

		
		
		local ti = {}
		local bti = false
		local mvscr = false
		if butt == KEY_RIGHT then
			if currenttile.x + currenttile.w + ARCPhone.PhoneSys.MoveX > ARCPhone.PhoneSys.ScreenResX - 8 && currenttile.w > ARCPhone.PhoneSys.ScreenResX then
				ARCPhone.PhoneSys.BigTileX = ARCPhone.PhoneSys.BigTileX + ARCPhone.PhoneSys.ScreenResX - 20
				
			
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
			if currenttile.x + ARCPhone.PhoneSys.MoveX < 8 && currenttile.w > ARCPhone.PhoneSys.ScreenResX then

				ARCPhone.PhoneSys.BigTileX = ARCPhone.PhoneSys.BigTileX - ARCPhone.PhoneSys.ScreenResX + 20
				MsgN(ARCPhone.PhoneSys.BigTileX)

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
			if currenttile.y + currenttile.h + ARCPhone.PhoneSys.MoveY > ARCPhone.PhoneSys.ScreenResY - 8 && currenttile.h > ARCPhone.PhoneSys.ScreenResX then
				ARCPhone.PhoneSys.BigTileY = ARCPhone.PhoneSys.BigTileY + ARCPhone.PhoneSys.ScreenResY - 20

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
			if currenttile.y + ARCPhone.PhoneSys.MoveY < 29 && currenttile.h > ARCPhone.PhoneSys.ScreenResX then
				ARCPhone.PhoneSys.BigTileY = ARCPhone.PhoneSys.BigTileY - ARCPhone.PhoneSys.ScreenResY + 41
			

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
			phone:EmitSound("buttons/button9.wav",60,255)
			curapptime = CurTime() + 0.1
			oldapptime = CurTime()
			currenttile.OnUnSelected(phone,self)
			if (input.IsKeyDown(KEY_ENTER) || input.WasKeyPressed(KEY_ENTER)) then
				currenttile.OnUnPressed(phone,self)
			end
			ARCPhone.PhoneSys.OldSelectedAppTile = phone.SelectedAppTile
			phone.SelectedAppTile = bti 
			if butt == KEY_RIGHT then
				ARCPhone.PhoneSys.BigTileX = self.Tiles[bti].x
			elseif butt == KEY_LEFT then
				ARCPhone.PhoneSys.BigTileX = self.Tiles[bti].x + self.Tiles[bti].w - ARCPhone.PhoneSys.ScreenResX + 8
			elseif butt == KEY_DOWN then
				ARCPhone.PhoneSys.BigTileY = self.Tiles[bti].y
			elseif butt == KEY_UP then
				ARCPhone.PhoneSys.BigTileY = self.Tiles[bti].y + self.Tiles[bti].h - ARCPhone.PhoneSys.ScreenResY + 8
			end
			self.Tiles[bti].OnSelected(phone,self)
			if (input.IsKeyDown(KEY_ENTER) || input.WasKeyPressed(KEY_ENTER)) then
				self.Tiles[bti].OnPressed(phone,self)
			end
		elseif butt == KEY_BACKSPACE || butt == KEY_ENTER || mvscr then
			phone:EmitSound("buttons/button9.wav",60,255)
		else
			phone:EmitSound("common/wpn_denyselect.wav")
		end
	end
	return app
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