ARCPhone.PhoneSys = ARCPhone.PhoneSys or {}

ARCPhone.PhoneSys.Reception = 0

ARCPhone.PhoneSys.OldStatus = ARCPHONE_ERROR_CALL_ENDED


ARCPhone.PhoneSys.HideWhatsOffTheScreen = true
ARCPhone.PhoneSys.ValidKeys = {KEY_UP,KEY_DOWN,KEY_LEFT,KEY_RIGHT,KEY_ENTER,KEY_BACKSPACE,KEY_LCONTROL,KEY_RCONTROL}
ARCPhone.PhoneSys.KeyDelay = {}
ARCPhone.PhoneSys.OutgoingTexts = ARCPhone.PhoneSys.OutgoingTexts or {}

ARCPhone.PhoneSys.Booted = false

ARCPhone.PhoneSys.Ent = NULL

for k,v in pairs(ARCPhone.PhoneSys.ValidKeys) do
	ARCPhone.PhoneSys.KeyDelay[v] = CurTime() - 1
end

function ARCPhone.PhoneSys:EmitSound(snd,vol,pitch)
	sound.Play( snd, LocalPlayer():GetPos(), vol, pitch)
end

function ARCPhone.PhoneSys:ChoosePhoto(func,...)
	local curapp = ARCPhone.Apps[self.ActiveApp]
	local newapp = ARCPhone.PhoneSys:OpenApp("photos",false,true)
	if (newapp) then
		newapp:AttachPhoto(curapp.sysname,func,...)
	end
end

function ARCPhone.PhoneSys:GetActiveApp()
	return ARCPhone.Apps[self.ActiveApp]
end
function ARCPhone.PhoneSys:GetApp(id)
	return ARCPhone.Apps[id]
end
function ARCPhone.PhoneSys:SetLoading(percent)
	percent = percent or -0.01
	if percent > 0 then
		self.LoadingPer = math.floor(percent*100)
	else
		self.LoadingPer = -1
	end
	self.Loading = tobool(percent > -2)

end
function ARCPhone.PhoneSys:Think(wep)
	if !gui.IsGameUIVisible() && !self.PauseInput then
		if self.TextInputTile then
			return
		end
		if !self.Loading && !self.ShowConsole then
			for k,v in pairs(self.ValidKeys) do
				if (input.IsKeyDown(v) || input.WasKeyPressed(v)) && self.KeyDelay[v] <= CurTime() then -- The only reason why I merge IsKeyDown and WasKeyPressed is because of people with shitty computers
					if self.KeyDelay[v] < CurTime() - 1 then
						self:OnButtonDown(v)
						self:OnButton(v)
						self.KeyDelay[v] = CurTime() + 1
					elseif self.KeyDelay[v] <= CurTime() then
						self.KeyDelay[v] = CurTime() + 0.1
						self:OnButton(v)
					end

				end
				if input.WasKeyReleased(v) then
					if self.KeyDelay[v] >= CurTime() - 1 then
						self:OnButtonUp(v)
						self.KeyDelay[v] = CurTime() - 2
					end
				end
			end

		end
	end
end
ARCPhone.PhoneSys.icons_reception = {}
for i = 0,7 do
	ARCPhone.PhoneSys.icons_reception[i] = surface.GetTextureID( "arcphone/icons/"..i )

end

function ARCPhone.PhoneSys:AddMsgBox(title,txt,icon,typ,gfunc,rfunc,yfunc)
	if (!istable(self.MsgBoxs)) then return end
	self.ShowOptions = false
	local i = #self.MsgBoxs + 1
	self.MsgBoxOption = 1
	self.MsgBoxs[i] = {}
	self.MsgBoxs[i].Title = title or ""
	self.MsgBoxs[i].Text = txt or "Message Box"
	self.MsgBoxs[i].Icon = icon or "info"
	self.MsgBoxs[i].Type = typ or 1
	self.MsgBoxs[i].GreenFunc = gfunc or NULLFUNC
	self.MsgBoxs[i].RedFunc = rfunc or NULLFUNC
	self.MsgBoxs[i].YellowFunc = yfunc or NULLFUNC
end

function ARCPhone.PhoneSys:DrawHud(wep)
	local app = ARCPhone.Apps[self.ActiveApp]
	if (app && self.Booted) then
		app:DrawHUD()
	end
end

function ARCPhone.PhoneSys:DrawHud(wep)
	local app = ARCPhone.Apps[self.ActiveApp]
	if (app && self.Booted) then
		app:DrawHUD()
	end
end

function ARCPhone.PhoneSys:TranslateFOV(wep)
	local app = ARCPhone.Apps[self.ActiveApp]
	if (app && self.Booted) then
		return app:TranslateFOV()
	end
end

function ARCPhone.PhoneSys:Init(wep)
	self.Booted = false
	self:SetLoading(0)
	self.ScreenResX = 138
	self.ScreenResY = 250
	self.HalfScreenResX = self.ScreenResX/2
	self.HalfScreenResY = self.ScreenResY/2
	self.LastWep = "weapon_physgun"
	self.ActiveApp = "home"
	self.OldSelectedAppTile = 1
	self.SelectedAppTile = 1
	self.ShowOptions = false
	self.Options = {}
	self.CurrentOption = 1
	self.MoveX = 0
	self.MoveY = 0
	self.BigTileX = 0
	self.BigTileY = 0

	self.MsgBoxs = {}
	self.MsgBoxOption = 1

	self.OptionAnimStartTime = 0
	self.OptionAnimEndTime = 1

	self.Ent = wep or NULL
	if !wep then return end
	wep.VElements["screen"].draw_func = function( weapon )

			if self.HideWhatsOffTheScreen then
				-- I have no idea how to stencil, but hey, it works, and doesn't cause significant FPS drop
				render.ClearStencil() --Clear stencil
				render.SetStencilEnable( true ) --Enable stencil
				render.SetStencilWriteMask( 255 )
				render.SetStencilTestMask( 255 )
				--STENCILOPERATION_KEEP
				--STENCILOPERATION_INCR
				render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
				render.SetStencilFailOperation( STENCILOPERATION_INCR )
				render.SetStencilPassOperation( STENCILOPERATION_KEEP )
				render.SetStencilZFailOperation(  STENCILOPERATION_KEEP  )


				-- Yeah yeah, I know drawing a giant box around the phone is probaly not the best way to do it. If anyone is willing to teach me how to stencil, that would be appriciated (You'd get moneh for it toooo!)
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( self.ScreenResX, 0, 1000, self.ScreenResY )
				surface.DrawRect( -5000, 0, 5000, self.ScreenResY )
				surface.DrawRect( -5000, -4000, 6000+self.ScreenResX, 4000 )
				surface.DrawRect( -5000, self.ScreenResY, 6000+self.ScreenResX, 1000 )
				--render.SetStencilPassOperation( STENCILOPERATION_DECR )

				--surface.SetDrawColor( 255, 255, 255, 255 )
				--surface.DrawRect( -100, 0, 100, 100 ) --224

				render.SetStencilReferenceValue( 0 ) --Reference value 1
				render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL ) --Only draw if pixel value == reference value
				-----------------------------------
				--Thing to be drawn in the cutout--4
				-----------------------------------
			end


			surface.SetDrawColor(ARCLib.ConvertColor(self.Settings.Personalization.CL_13_BackgroundColour))
			surface.DrawRect( 0, 0, self.ScreenResX, self.ScreenResY )

			local app = ARCPhone.Apps[self.ActiveApp]

			if (app && self.Booted && app.Tiles && #app.Tiles > 0) then

				local relx1 = app.Tiles[self.SelectedAppTile].x + self.MoveX
				local relx2 = app.Tiles[self.SelectedAppTile].x + app.Tiles[self.SelectedAppTile].w + self.MoveX
				local rely1 = app.Tiles[self.SelectedAppTile].y + self.MoveY
				local rely2 = app.Tiles[self.SelectedAppTile].y + app.Tiles[self.SelectedAppTile].h + self.MoveY

				if app.Tiles[self.SelectedAppTile].w > self.ScreenResX then
					relx1 = self.BigTileX + self.MoveX

					if relx2 >= self.ScreenResX - 20 then
						relx2 = self.BigTileX + self.MoveX + self.ScreenResX - 20
					end
				end
				if app.Tiles[self.SelectedAppTile].h > self.ScreenResY then
					rely1 = self.BigTileY + self.MoveY
					if rely2 >= self.ScreenResY - 20 then
						rely2 = self.BigTileY + self.MoveY + self.ScreenResY - 20
					end
				end

				if relx1 < 6 then
					local dist = -relx1+6
					self.MoveX = self.MoveX + math.ceil(dist*0.2)
				end
				if relx2 > self.ScreenResX - 6 then
					local dist = relx2 - (self.ScreenResX - 6)
					self.MoveX = self.MoveX - math.ceil(dist*0.2)
					math.ceil(dist*0.2)
				end

				if rely1 < 29 then
					local dist = -rely1+29
					self.MoveY = self.MoveY + math.ceil(dist*0.2)
				end
				if rely2 > self.ScreenResY - 8 then
					local dist = rely2 - (self.ScreenResY - 8)
					self.MoveY = self.MoveY - math.ceil(dist*0.2)
				end
				app:BackgroundDraw(self.MoveX,self.MoveY)
				app:DrawLabels(self.MoveX,self.MoveY)
				app:DrawTiles(self.MoveX,self.MoveY)
				app:ForegroundDraw(self.MoveX,self.MoveY)
				if !self.HideWhatsOffTheScreen then
					surface.SetDrawColor( 255, 0, 0, 255 )
					surface.DrawOutlinedRect( relx1, rely1, relx2-relx1, rely2-rely1 )
				end
			end

			local multiplier
			if self.ShowOptions then
				surface.SetDrawColor(ARCLib.ConvertColor(self.Settings.Personalization.CL_18_FadeColour))
				surface.DrawOutlinedRect( 0, 0, self.ScreenResX, self.ScreenResY )
				multiplier = (ARCLib.BetweenNumberScaleReverse(self.OptionAnimStartTime,CurTime(),self.OptionAnimEndTime)^2 -1)*-1
			else
				multiplier = ARCLib.BetweenNumberScaleReverse(self.OptionAnimStartTime,CurTime(),self.OptionAnimEndTime)^2
			end
			if multiplier > 0 then
			--[[	self.OptionAnimStartTime = 0
self.OptionAnimEndTime = 1]]

				local size = #self.Options * 14
				surface.SetDrawColor(ARCLib.ConvertColor(self.Settings.Personalization.CL_14_ContextMenuMain))
				surface.DrawRect( 0, self.ScreenResY - size*multiplier, self.ScreenResX, size )
				for i = 1,#self.Options do
					if self.CurrentOption == i then
						surface.SetDrawColor(ARCLib.ConvertColor(self.Settings.Personalization.CL_15_ContextMenuSelect))
						surface.DrawRect( 0, self.ScreenResY - ((i)*14)*multiplier, self.ScreenResX, 14 )
					end
					draw.SimpleText(self.Options[i].text, "ARCPhoneSmall", 2, self.ScreenResY - (i*14)*multiplier, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
				end
				surface.SetDrawColor(ARCLib.ConvertColor(self.Settings.Personalization.CL_16_ContextMenuBorder))
				surface.DrawOutlinedRect( 0, self.ScreenResY - size*multiplier, self.ScreenResX, size )
			end

			local maxmsgbox = #self.MsgBoxs
			if maxmsgbox > 0 then
				surface.SetDrawColor( 0, 0, 0, 185 )
				surface.DrawOutlinedRect( 0, 0, self.ScreenResX, self.ScreenResY )
				local buttonwidth = self.ScreenResX - 8
				local maxo = 1
				local typ = self.MsgBoxs[maxmsgbox].Type
				if typ < 2 then
					maxo = 1
				elseif typ > 1 && typ < 6 then
					maxo = 2
				else
					maxo = 3
				end
				local txttab = ARCLib.FitText(self.MsgBoxs[maxmsgbox].Text,"ARCPhoneSmall",buttonwidth)

				surface.SetDrawColor( 100, 100, 100, 255 )
				surface.DrawRect( 0, 22, self.ScreenResX, 34 + 20*maxo + 12*#txttab)

				surface.SetDrawColor(ARCLib.ConvertColor(self.Settings.Personalization.CL_21_PopupBoxText))
				surface.DrawOutlinedRect( 0, 22, self.ScreenResX, 34 + 20*maxo + 12*#txttab)
				surface.SetTexture(ARCLib.FlatIcons64[self.MsgBoxs[maxmsgbox].Icon])
				if self.MsgBoxs[maxmsgbox].Icon == "cross" then
					surface.SetDrawColor( 255, 32, 16, 255 )
				elseif self.MsgBoxs[maxmsgbox].Icon == "warning" then
					surface.SetDrawColor( 200, 200, 0, 255 )
				elseif self.MsgBoxs[maxmsgbox].Icon == "info" then
					surface.SetDrawColor( 64, 255, 64, 255 )
				elseif self.MsgBoxs[maxmsgbox].Icon == "question" then
					surface.SetDrawColor( 64, 64, 255, 255 )
				end
				surface.DrawTexturedRect( 4, 26, 16, 16 )

				draw.SimpleText(ARCLib.CutOutText(self.MsgBoxs[maxmsgbox].Title,"ARCPhone",buttonwidth),"ARCPhone", 24, 27, self.Settings.Personalization.CL_21_PopupBoxText, TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
				for i = 1,#txttab do
					draw.SimpleText(txttab[i],"ARCPhoneSmall", 4, 34+(i*12), self.Settings.Personalization.CL_21_PopupBoxText, TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
				end
				surface.SetDrawColor( self.Settings.Personalization.CL_22_PopupAccept )
				surface.DrawRect( 4, 46 + 4 + 12*#txttab, buttonwidth, 20)

				if typ == 1 || typ == 3 then -- Case statements would work really nice here :/
					draw.SimpleText("OK","ARCPhone", self.HalfScreenResX, 46 + 6 + 12*#txttab, self.Settings.Personalization.CL_23_PopupAcceptText, TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
				end
				if typ == 2 || typ == 6 then
					draw.SimpleText("Yes","ARCPhone", self.HalfScreenResX, 46 + 6 + 12*#txttab, self.Settings.Personalization.CL_23_PopupAcceptText, TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
				end
				if typ == 4 || typ == 7 then
					draw.SimpleText("Retry","ARCPhone", self.HalfScreenResX, 46 + 6 + 12*#txttab, self.Settings.Personalization.CL_23_PopupAcceptText, TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
				end
				if typ == 5 then
					draw.SimpleText("Reply","ARCPhone", self.HalfScreenResX, 46 + 6 + 12*#txttab, self.Settings.Personalization.CL_23_PopupAcceptText, TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
				end
				if typ == 8 then
					draw.SimpleText("Answer","ARCPhone", self.HalfScreenResX, 46 + 6 + 12*#txttab, self.Settings.Personalization.CL_23_PopupAcceptText, TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
				end
				if self.MsgBoxOption == 1 then
					surface.SetDrawColor(ARCPhone.PhoneSys.Settings.Personalization.CL_00_CursorColour)
					surface.DrawOutlinedRect( 4, 46 + 4 + 12*#txttab, buttonwidth, 20)

				end
				if maxo > 1 then
					surface.SetDrawColor(self.Settings.Personalization.CL_24_PopupDeny)
					surface.DrawRect( 4, 46 + 24 + 12*#txttab, buttonwidth, 20)
					if typ == 2 || typ == 6 then -- Case statements would work really nice here :/
						draw.SimpleText("No","ARCPhone",self.HalfScreenResX,46 + 26 + 12*#txttab, self.Settings.Personalization.CL_25_PopupDenyText, TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
					end
					if typ == 3 then
						draw.SimpleText("Cancel","ARCPhone",self.HalfScreenResX,46 + 26 + 12*#txttab, self.Settings.Personalization.CL_25_PopupDenyText, TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
					end
					if typ == 4 || typ == 7 then
						draw.SimpleText("Abort","ARCPhone",self.HalfScreenResX,46 + 26 + 12*#txttab, self.Settings.Personalization.CL_25_PopupDenyText, TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
					end
					if typ == 5 then
						draw.SimpleText("Close","ARCPhone",self.HalfScreenResX,46 + 26 + 12*#txttab, self.Settings.Personalization.CL_25_PopupDenyText, TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
					end
					if typ == 8 then
						draw.SimpleText("Ignore","ARCPhone",self.HalfScreenResX,46 + 26 + 12*#txttab, self.Settings.Personalization.CL_25_PopupDenyText, TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
					end
					if self.MsgBoxOption == 2 then
						surface.SetDrawColor(ARCPhone.PhoneSys.Settings.Personalization.CL_00_CursorColour)
						surface.DrawOutlinedRect( 4, 46 + 24 + 12*#txttab, buttonwidth, 20)
					end
				end
				if maxo > 2 then
					surface.SetDrawColor(self.Settings.Personalization.CL_26_PopupDefer)
					surface.DrawRect( 4, 46 + 44 + 12*#txttab, buttonwidth, 20)
					if typ == 6 then -- Case statements would work really nice here :/
						draw.SimpleText("Cancel","ARCPhone", self.HalfScreenResX,  46 + 46 + 12*#txttab, self.Settings.Personalization.CL_27_PopupDeferText, TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
					end
					if typ == 7 then
						draw.SimpleText("Ignore","ARCPhone", self.HalfScreenResX,  46 + 46 + 12*#txttab, self.Settings.Personalization.CL_27_PopupDeferText, TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
					end
					if typ == 8 then
						draw.SimpleText("Text Excuse","ARCPhone", self.HalfScreenResX,  46 + 46 + 12*#txttab, self.Settings.Personalization.CL_27_PopupDeferText, TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
					end
					if self.MsgBoxOption == 3 then
						surface.SetDrawColor(ARCPhone.PhoneSys.Settings.Personalization.CL_00_CursorColour)
						surface.DrawOutlinedRect( 4, 46 + 44 + 12*#txttab, buttonwidth, 20)
					end
				end
				--[[
					self.MsgBoxs[i].Title = title or ""
					self.MsgBoxs[i].Text = txt or "Message Box"
					self.MsgBoxs[i].Icon = icon or ""
					self.MsgBoxs[i].Type = typ or 1
				]]

			end



			surface.SetDrawColor(ARCPhone.PhoneSys.Settings.Personalization.CL_12_HotbarColour)
			surface.DrawRect( 0, 0, self.ScreenResX, 20 )
			surface.SetDrawColor( ARCPhone.PhoneSys.Settings.Personalization.CL_12_HotbarBorder )
			surface.DrawOutlinedRect( 0, 0, self.ScreenResX, self.ScreenResY )
			surface.DrawOutlinedRect( 0, 0, self.ScreenResX, 21 )

			surface.SetDrawColor( 255, 255, 255, 255 )
			local sigicon = math.ceil(6*(self.Reception/100)+1)

			--[[
			if self.Reception <= 0 then
				if math.sin(CurTime()*math.pi) > 0 then
					surface.SetTexture( self.icons_reception[1] )
				else
					surface.SetTexture( self.icons_reception[2] )
				end

			end
			]]
			surface.SetTexture( self.icons_reception[sigicon] )

			surface.DrawTexturedRect( 2, 2, 16, 16 )


			if self.Status != ARCPHONE_ERROR_CALL_ENDED then
				surface.SetMaterial( ARCLib.Icons16["phone"] )
				surface.DrawTexturedRect( 20, 2, 16, 16 )
				if self.Status == ARCPHONE_ERROR_NOT_LOADED then
					surface.SetDrawColor( 255, 255, 255, math.sin(CurTime()*5)^2 *255 )
					surface.SetMaterial( ARCLib.Icons16["cross"] )
					surface.DrawTexturedRect( 20, 2, 16, 16)
				elseif self.Reception < 30 || self.Status > ARCPHONE_ERROR_NONE then
					surface.SetDrawColor( 255, 255, 255, math.sin(CurTime()*5)^2 *255 )
					surface.SetMaterial( ARCLib.Icons16["bullet_error"] )
					surface.DrawTexturedRect( 20, 2, 16, 16)
				end
			end


			--[[
			surface.SetDrawColor( 255, 100, 100, 255 )
			surface.SetMaterial( ARCLib.Icons16["cross"] )
			--surface.DrawTexturedRect( -54, -98, 16, 16 )
			]]


			if self.Loading then
				surface.SetDrawColor( ARCPhone.PhoneSys.Settings.Personalization.CL_19_MegaFadeColour )
				surface.DrawOutlinedRect( 0, 0, self.ScreenResX, self.ScreenResY )
				if self.LoadingPer < 0 then
					draw.SimpleText("Loading...", "ARCPhone", self.HalfScreenResX, self.HalfScreenResY, ARCPhone.PhoneSys.Settings.Personalization.CL_03_MainText, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
				else
					draw.SimpleText("Loading... ("..self.LoadingPer.."%)", "ARCPhone", self.HalfScreenResX, self.HalfScreenResY, ARCPhone.PhoneSys.Settings.Personalization.CL_03_MainText , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
				end
			end
			surface.SetDrawColor( 255, 255, 255, 255 )
			render.SetStencilEnable( false )
		end


	if game.SinglePlayer() then
		self:AddMsgBox("CRITICAL ERROR","This is a single-player game.")
		return
	end
	if !file.IsDir( "_arcphone_client","DATA" ) then
		file.CreateDir("_arcphone_client")
	end
	if !file.IsDir( "_arcphone_client","DATA" ) then
		self:AddMsgBox("CRITICAL ERROR","Failed to create root folder. All apps that require data to be saved (including the home screen) won't work.")
		return
	end
	ARCPhone.ROOTDIR = "_arcphone_client/"..string.lower(string.gsub(ARCLib.GetUserID(LocalPlayer()), "[^_%w]", "_"))
	if !file.IsDir( ARCPhone.ROOTDIR,"DATA" ) then
		file.CreateDir( ARCPhone.ROOTDIR)
	end
	if !file.IsDir( ARCPhone.ROOTDIR.."/appdata","DATA" ) then
		file.CreateDir( ARCPhone.ROOTDIR.."/appdata")
	end
	if !file.IsDir( ARCPhone.ROOTDIR.."/messaging","DATA" ) then
		file.CreateDir( ARCPhone.ROOTDIR.."/messaging")
	end
	if !file.IsDir( ARCPhone.ROOTDIR.."/contactphotos","DATA" ) then
		file.CreateDir( ARCPhone.ROOTDIR.."/contactphotos")
	end
	if !file.IsDir( ARCPhone.ROOTDIR.."/camera","DATA" ) then
		file.CreateDir( ARCPhone.ROOTDIR.."/camera")
	end
	if !file.IsDir( ARCPhone.ROOTDIR.."/photos","DATA" ) then
		file.CreateDir( ARCPhone.ROOTDIR.."/photos")
	end
	if !file.IsDir( ARCPhone.ROOTDIR.."/photos/texts","DATA" ) then
		file.CreateDir( ARCPhone.ROOTDIR.."/photos/texts")
	end
	if !file.IsDir( ARCPhone.ROOTDIR.."/photos/camera","DATA" ) then
		file.CreateDir( ARCPhone.ROOTDIR.."/photos/camera")
	end
	if !file.IsDir( ARCPhone.ROOTDIR.."/photos/saved","DATA" ) then
		file.CreateDir( ARCPhone.ROOTDIR.."/photos/saved")
	end
	if (ARCPhone.ClientFiles) then
		for k,v in pairs(ARCPhone.ClientFiles) do
			MsgN("WRITING "..ARCPhone.ROOTDIR..k)
			file.Write(ARCPhone.ROOTDIR..k,util.Base64Decode(v))
		end
		ARCPhone.ClientFiles = nil
	end
	--contactphotos
	ARCPhone.PhoneSys:Init_DLFiles(1,0)
end


	function ARCPhone.PhoneSys:Init_Final()
		for k,v in pairs(ARCPhone.Apps) do
			if file.Exists(ARCPhone.ROOTDIR.."/appdata/"..k..".txt","DATA") then
				local tab = util.JSONToTable(file.Read(ARCPhone.ROOTDIR.."/appdata/"..k..".txt","DATA"))
				if tab then
					v.Disk = tab
				end
			end
		end
		for k,v in pairs(ARCPhone.Apps) do
			v:PhoneStart()
		end
		self:SetLoading(-2)
		self:OpenApp("home")
		self.Booted = true
		self:AddMsgBox("PROTOTYPE VERSION","Because this is not a public release, BE PREPARED TO LOOSE ALL DATA WITH EVERY UPDATE.","warning")
		self:AddMsgBox("My excuse for a tutorial","Use the Arrow keys to move the cursor. Press BACKSPACE to go back, press CTRL to access the context menu, and press ENTER to select.","info")
		self:AddMsgBox("PROTOTYPE VERSION","This is the prototype version of ARCPhone (pre-alpha), and does not represent the final product. Everything is subject to change. (Press ENTER to close this window)","info")
	end

	function ARCPhone.PhoneSys:Init_DLFiles(num,retries)
		if (ARCPhone.ClientFilesDL && ARCPhone.ClientFilesDL[num]) then
			if (file.Exists(ARCPhone.ROOTDIR..ARCPhone.ClientFilesDL[num],"DATA")) then
				self:SetLoading(num/#ARCPhone.ClientFilesDL)
				timer.Simple(0.1, function() ARCPhone.PhoneSys:Init_DLFiles(num+1) end)
			else
				http.Fetch( "https://update.aritzcracker.ca/arcphone_dlfiles"..ARCPhone.ClientFilesDL[num],
					function( body, len, headers, code )
						if code == 200 then
							file.Write(ARCPhone.ROOTDIR..ARCPhone.ClientFilesDL[num],util.Base64Decode(body))
							self:SetLoading(num/#ARCPhone.ClientFilesDL)
							ARCPhone.PhoneSys:Init_DLFiles(num+1)
						else
							self:AddMsgBox("HTTP Error code: "..code.." while getting "..ARCPhone.ClientFilesDL[num].."\nThis may cause graphical glitches","cross")
						end
					end,
					function( err )
						if retries < 10 then
							timer.Simple(10,function() ARCPhone.PhoneSys:Init_DLFiles(num) end)
						else
							ARCPhone.PhoneSys:Init_DLFiles(num+1)
							self:SetLoading(num/#ARCPhone.ClientFilesDL)
							self:AddMsgBox("HTTP Error: "..err.." while getting "..ARCPhone.ClientFilesDL[num].."\nThis may cause graphical glitches","cross")
						end
					end
				);
			end
		else
			ARCPhone.PhoneSys:Init_Final()
		end
	end

	function ARCPhone.PhoneSys:SendText(number,message)
		local fil = ARCPhone.ROOTDIR.."/messaging/"..number..".txt"
		if file.Exists(fil,"DATA") then
			file.Append(fil,"\fs\v"..os.time().."\v"..message)
		else
			file.Write(fil,"s\v"..os.time().."\v"..message)
		end

		local matches = {string.gmatch(message, "({{IMG:([^:]*):([^:]*):IMG}})")()} --WHY DOES string.gmatch RETURN A FUNCTION INSTEAD OF A TABLE? WHY DO I HAVE TO CALL THAT FUNCTION TO MAKE A TABLE MYSELF?!
		while #matches > 0 do
			message = string.Replace(message, matches[1], "{{IMGDATA:"..util.Base64Encode(file.Read(matches[2],"DATA"))..":"..util.Base64Encode(file.Read(matches[3],"DATA"))..":IMGDATA}}")
			matches = {string.gmatch(message, "({{IMG:([^:]*):([^:]*):IMG}})")()}
		end
		local hash = ARCLib.JamesHash(message)
		ARCPhone.PhoneSys.OutgoingTexts[hash] = {}
		ARCPhone.PhoneSys.OutgoingTexts[hash].msg = ARCLib.SplitString(util.Compress(number..message),16384)
		ARCPhone.PhoneSys.OutgoingTexts[hash].number = number
		ARCPhone.PhoneSys.OutgoingTexts[hash].place = -1
	end
	function ARCPhone.PhoneSys:RecieveText(number,timestamp,message)

		local matches = {string.gmatch(message, "({{IMGDATA:([^:]*):([^:]*):IMGDATA}})")()} --WHY DOES string.gmatch RETURN A FUNCTION INSTEAD OF A TABLE? WHY DO I HAVE TO CALL THAT FUNCTION TO MAKE A TABLE MYSELF?!
		local i = 1
		while #matches > 0 do
			local imgname = ARCPhone.ROOTDIR.."/photos/texts/"..number.."_"..i..".photo.dat"
			while file.Exists(imgname,"DATA") do
				i = i + 1
				imgname = ARCPhone.ROOTDIR.."/photos/texts/"..number.."_"..i..".photo.dat"
			end
			local thumbname = ARCPhone.ROOTDIR.."/photos/texts/"..number.."_"..i..".thumb.dat"
			file.Write(thumbname,util.Base64Decode(matches[2]))
			file.Write(imgname,util.Base64Decode(matches[3]))
			message = string.Replace(message, matches[1], "{{IMG:"..thumbname..":"..imgname..":IMG}}")
			matches = {string.gmatch(message, "({{IMGDATA:([^:]*):([^:]*):IMGDATA}})")()}
		end
		local fil = ARCPhone.ROOTDIR.."/messaging/"..number..".txt"
		if file.Exists(fil,"DATA") then
			file.Append(fil,"\fr\v"..timestamp.."\v"..message)
		else
			file.Write(fil,"r\v"..timestamp.."\v"..message)
		end
		
		local app = self:GetActiveApp()
		if app.sysname == "messaging" && app.OpenNumber == number then
			app:OpenConvo(number)
		else
			local name = number
			local contactapp = self:GetApp("contacts")
			if contactapp then
				name = contactapp:GetNameFromNumber(number)
			end
			self:AddMsgBox("New Message","New Message from "..name.." ("..number..")","comments",ARCPHONE_MSGBOX_REPLY,function()
				app = self:OpenApp("messaging")
				app:OpenConvo(number)
			end)
		end
		ARCPhone.PhoneSys.PlayNotification("TextMsg")
		//file.Write(ARCPhone.ROOTDIR.."/messaging/"..number..".txt",util.TableToJSON(texts))
	end
	function ARCPhone.PhoneSys:Call(number)
		if !ARCPhone.IsValidPhoneNumber(number) then
			self:AddMsgBox("ARCPhone","Invalid number.","cross")
		else
			if self.Status != ARCPHONE_ERROR_CALL_ENDED then
				self:AddMsgBox("ARCPhone","Call is not ended.","cross")
			else
				net.Start("arcphone_comm_call")
				net.WriteInt(1,8)
				net.WriteString(number)
				net.SendToServer()
				if (self:AppExists("callscreen")) then
					self:OpenApp("callscreen")
				else
					self:AddMsgBox("ARCPhone","The call progress screen doesn't seem to be installed! This means you cannot end your call in a nice GUI fasion!","cross")
				end
			end
		end
	end
	function ARCPhone.PhoneSys:Answer()
		if self.Status == ARCPHONE_ERROR_RINGING then
			net.Start("arcphone_comm_call")
			net.WriteInt(2,8)
			net.SendToServer()
		else
			self:AddMsgBox("ARCPhone","Cannot answer while not ringing","cross")
		end
	end
	function ARCPhone.PhoneSys:GroupCall(tabonumbers)
		local number = #tabonumbers
		if number > 127 then
			self:AddMsgBox("ARCPhone","Too many numbers.","cross")
		elseif number > 1 then
			net.Start("arcphone_comm_call")
			net.WriteInt(number*-1,8)
			for i = 1,number do
				if ARCPhone.IsValidPhoneNumber(tabonumbers[i]) then
					self:AddMsgBox("ARCPhone","Number "..i.." is invalid.","warning")
				else
					net.WriteString(tabonumbers[i])
				end
			end
			net.SendToServer()
		else
			self:AddMsgBox("ARCPhone","Not enough numbers.","cross")
			self:Print("Not enough numbers.")
		end
	end

	function ARCPhone.PhoneSys:AddToCall(number)
		if ARCPhone.IsValidPhoneNumber(number) then
			if ARCPhone.PhoneSys.Status != ARCPHONE_ERROR_NONE then
				self:AddMsgBox("ARCPhone","No call running or call has not been established.","warning")
			else
				net.Start("arcphone_comm_call")
				net.WriteInt(4,8)
				net.WriteString(number)
				net.SendToServer()
				if (self:AppExists("callscreen")) then
					self:OpenApp("callscreen")
				else
					self:AddMsgBox("ARCPhone","The call progress screen doesn't seem to be installed! This means you cannot end your call in a nice GUI fasion!","cross")
				end
			end
		else
			self:AddMsgBox("ARCPhone","Invalid number.","cross")
		end
	end
	function ARCPhone.PhoneSys:HangUp()
		net.Start("arcphone_comm_call")
		net.WriteInt(3,8)
		net.SendToServer()
	end
	function ARCPhone.PhoneSys:AppExists(app)
		return ARCPhone.Apps[app] != nil
	end
	function ARCPhone.PhoneSys:OpenApp(app,noinit,noclose)
		if !isstring(app) || !istable(ARCPhone.Apps[app]) then
			app = tostring(app)
			self:AddMsgBox("Cannot open "..app,"App '"..app.."' is invalid or not available in this area.\n("..type(ARCPhone.Apps[app])..")","cross")
		else
			if (!noclose) then
				ARCPhone.Apps[self.ActiveApp]:OnClose()
			end
			self.OldSelectedAppTile = 1
			self.SelectedAppTile = 1
			self.ShowConsole = false
			self.ActiveApp = app
			self.MoveX = 0
			self.MoveY = 0
			if (!noinit) then
				ARCPhone.Apps[app]:Init()
			end
			return ARCPhone.Apps[app]
		end
	end
	function ARCPhone.PhoneSys:Lock()
		if self.LastWep then
			net.Start("arcphone_switchwep")
			net.WriteString(self.LastWep)
			net.SendToServer()
		end
	end
	

	-- KEY_UP,KEY_DOWN,KEY_LEFT,KEY_RIGHT,KEY_ENTER,KEY_BACKSPACE,KEY_RCONTROL
	local lastback = 0;
	function ARCPhone.PhoneSys:OnButton(button)
		if self.ColourInputTile then
			self:ColourInputFunc(button)
			return
		end
		if self.ChoiceInputTile then
			self:ChoiceInputFunc(button)
			return
		end
		local app = ARCPhone.Apps[self.ActiveApp]
		if #self.MsgBoxs > 0 then
			local i = #self.MsgBoxs
			local maxo = 1
			local typ = self.MsgBoxs[i].Type

			if typ < 2 then
				maxo = 1
			elseif typ > 1 && typ < 6 then
				maxo = 2
			else
				maxo = 3
			end
			if button == KEY_DOWN then
				if self.MsgBoxOption < maxo then
					self.MsgBoxOption = self.MsgBoxOption + 1
					self:EmitSound("arcphone/menus/press.wav",60)
				else
					self:EmitSound("common/wpn_denyselect.wav")
				end
			elseif button == KEY_UP then
				if self.MsgBoxOption > 1 then
					self.MsgBoxOption = self.MsgBoxOption - 1
					self:EmitSound("arcphone/menus/press.wav",60)
				else
					self:EmitSound("common/wpn_denyselect.wav")
				end
			end
			return
		elseif button == KEY_LCONTROL || button == KEY_LCONTROL then
			self.ShowOptions = !self.ShowOptions
			self.OptionAnimStartTime = CurTime()
			self.OptionAnimEndTime = CurTime() + 0.35
			if self.ShowOptions then
				self.Options = table.LiteCopy(app.Options)
				self.Options[#self.Options+1] = {}
				self.Options[#self.Options].text = "Lock"
				self.Options[#self.Options].args = {self}
				self.Options[#self.Options].func = self.Lock

				self.Options[#self.Options+1] = {}
				self.Options[#self.Options].text = "Home"
				self.Options[#self.Options].args = {self,"home"}
				self.Options[#self.Options].func = self.OpenApp
				self.CurrentOption = #self.Options
			end
		elseif self.ShowOptions then
			if button == KEY_BACKSPACE then
				self.OptionAnimStartTime = CurTime()
				self.OptionAnimEndTime = CurTime() + 0.35
				self.ShowOptions = false
			elseif button == KEY_UP then
				if self.CurrentOption < #self.Options then
					self.CurrentOption = self.CurrentOption + 1
					self:EmitSound("arcphone/menus/press.wav",60)
				else
					self:EmitSound("common/wpn_denyselect.wav")
				end
			elseif button == KEY_DOWN then
				if self.CurrentOption > 1 then
					self.CurrentOption = self.CurrentOption - 1
					self:EmitSound("arcphone/menus/press.wav",60)
				else
					self:EmitSound("common/wpn_denyselect.wav")
				end
			end
			return
		else
			if !app.DisableTileSwitching then
				app:_SwitchTile(button)
			end
			if button == KEY_BACKSPACE then
				if (CurTime() < lastback) then
					self:Lock()
				end
				lastback = CurTime() + 0.1
				app:OnBack()
			elseif button == KEY_ENTER then
				app:OnEnter()
			elseif button == KEY_UP then
				app:OnUp()
			elseif button == KEY_DOWN then
				app:OnDown()
			elseif button == KEY_LEFT then
				app:OnLeft()
			elseif button == KEY_RIGHT then
				app:OnRight()
			end
		end
	end

	local ispressinginmanu = false
	function ARCPhone.PhoneSys:OnButtonUp(button)
		if button == KEY_RCONTROL || button == KEY_LCONTROL then return end
		if self.ColourInputTile && button == KEY_ENTER then
			self.ColourInputTile = nil
			return
		end
		if self.ChoiceInputTile && button == KEY_ENTER then
			self.ChoiceInputTile.AnimStart = CurTime()
			self.ChoiceInputTile.AnimEnd = CurTime() + 0.5
			self.ChoiceInputTile = nil
			return
		end
		local app = ARCPhone.Apps[self.ActiveApp]
		if #self.MsgBoxs > 0 then
			if ispressinginmanu then
				local i = #self.MsgBoxs
				if button == KEY_ENTER then
					if self.MsgBoxOption == 1 then
						self.MsgBoxs[i].GreenFunc()
					elseif self.MsgBoxOption == 2 then
						self.MsgBoxs[i].RedFunc()
					elseif self.MsgBoxOption == 3 then
						self.MsgBoxs[i].YellowFunc()
					end
					self.MsgBoxs[i] = nil
					self.MsgBoxOption = 1
					ispressinginmanu = false
				end
			end
			return
		elseif self.ShowOptions then
			if button == KEY_ENTER then
				self.Options[self.CurrentOption].func(unpack(self.Options[self.CurrentOption].args))
				self.OptionAnimStartTime = CurTime()
				self.OptionAnimEndTime = CurTime() + 0.1
				self.ShowOptions = false
				return
			end
		else
			if button == KEY_BACKSPACE then
				app:OnBackUp()
			elseif button == KEY_ENTER then
				app:_OnEnterUp()
				app:OnEnterUp()
			elseif button == KEY_UP then
				app:OnUpUp()
			elseif button == KEY_DOWN then
				app:OnDownUp()
			elseif button == KEY_LEFT then
				app:OnLeftUp()
			elseif button == KEY_RIGHT then
				app:OnRightUp()
			end
		end
	end
	function ARCPhone.PhoneSys:OnButtonDown(button)
		if self.ColourInputTile || self.ChoiceInputTile || button == KEY_RCONTROL || button == KEY_LCONTROL then return end
		if #self.MsgBoxs > 0 then
			ispressinginmanu = true
		elseif self.ShowOptions then return end
		local app = ARCPhone.Apps[self.ActiveApp]
		if button == KEY_BACKSPACE then
			app:OnBackDown()
		elseif button == KEY_ENTER then
			app:_OnEnterDown()
			app:OnEnterDown()
		elseif button == KEY_UP then
			app:OnUpDown()
		elseif button == KEY_DOWN then
			app:OnDownDown()
		elseif button == KEY_LEFT then
			app:OnLeftDown()
		elseif button == KEY_RIGHT then
			app:OnRightDown()
		end
	end

	--ARCPhone.PhoneSys.Init()
