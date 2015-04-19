ARCPhone.PhoneSys = ARCPhone.PhoneSys or {}

ARCPhone.PhoneSys.Reception = 0

ARCPhone.PhoneSys.OldStatus = ARCPHONE_ERROR_CALL_ENDED


ARCPhone.PhoneSys.HideWhatsOffTheScreen = true
ARCPhone.PhoneSys.ValidKeys = {KEY_UP,KEY_DOWN,KEY_LEFT,KEY_RIGHT,KEY_ENTER,KEY_BACKSPACE,KEY_RCONTROL}
ARCPhone.PhoneSys.KeyDelay = {}
ARCPhone.PhoneSys.OutgoingTexts = ARCPhone.PhoneSys.OutgoingTexts or {}
for k,v in pairs(ARCPhone.PhoneSys.ValidKeys) do
	ARCPhone.PhoneSys.KeyDelay[v] = CurTime() - 1
	MsgN(v)
end

function ARCPhone.PhoneSys:EmitSound(snd,vol,pitch)
	sound.Play( snd, LocalPlayer():GetPos(), vol, pitch) 
end

function ARCPhone.PhoneSys:GetActiveApp()
	return ARCPhone.Apps[self.ActiveApp]
end
function ARCPhone.PhoneSys:SetLoading(loading,percent)
	percent = percent or -0.01
	if loading then
		self.LoadingPer = math.floor(percent*100)
	else
		self.LoadingPer = -1
	end
	
end
function ARCPhone.PhoneSys:Think(wep)

			
			if !self.Loading && !self.ShowConsole then
					if input.WasKeyReleased(KEY_LCONTROL) || input.WasKeyReleased(KEY_RCONTROL) then
						MsgN("CTRL!")
						self.ShowOptions = !self.ShowOptions
						if self.ShowOptions then
							self.CurrentOption = 1
							self.Options = table.Copy(ARCPhone.Apps[self.ActiveApp].Options)
							self.Options[#self.Options+1] = {}
							self.Options[#self.Options].text = "Lock"
							self.Options[#self.Options].func = function(ph,ap)
								ph:Lock()
							end
							
							self.Options[#self.Options+1] = {}
							self.Options[#self.Options].text = "Home"
							self.Options[#self.Options].func = function(ph,ap)
								ph:OpenApp("home")
							end
						end
					end
		
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
		--[[
		if self.OldStatus != self.Status then
			self:Print("Call Status has been changed to: "..tostring(ARCPHONE_ERRORSTRINGS[self.Status]))
			self.OldStatus = self.Status
		end
		]]
		--self.HideWhatsOffTheScreen = true


end
ARCPhone.PhoneSys.icons_reception = {}
for i = 0,7 do
	ARCPhone.PhoneSys.icons_reception[i] = surface.GetTextureID( "arcphone/icons/"..i ) 

end

function ARCPhone.PhoneSys:AddMsgBox(title,txt,icon,typ,gfunc,rfunc,yfunc)
	local i = #self.MsgBoxs + 1
	self.MsgBoxOption = 1
	self.MsgBoxs[i] = {}
	self.MsgBoxs[i].Title = title or ""
	self.MsgBoxs[i].Text = txt or "Message Box"
	self.MsgBoxs[i].Icon = icon or "info"
	self.MsgBoxs[i].Type = typ or 1
	self.MsgBoxs[i].GreenFunc = gfunc or function() end 
	self.MsgBoxs[i].RedFunc = rfunc or function() end
	self.MsgBoxs[i].YellowFunc = yfunc or function() end
end

function ARCPhone.PhoneSys:Init(wep)

	self.ScreenResX = 138
	self.ScreenResY = 250
	self.HalfScreenResX = self.ScreenResX/2
	self.HalfScreenResY = self.ScreenResY/2
	self.LastWep = "weapon_physgun"
	self.CurrentDir = "/"
	self.CurrentFolderIcon = "phone"
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
	self.Msgs = ""
	self.MsgsTab = {}
	
	self.MsgBoxs = {}
	self.MsgBoxOption = 1

	if !wep then return end
	wep.VElements["screen"].draw_func = function( weapon )
			
			if self.HideWhatsOffTheScreen then
				-- I have no idea how to stencil, but hey, it works, and doesn't cause significant FPS drop
				render.ClearStencil() --Clear stencil
				render.SetStencilEnable( true ) --Enable stencil
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
			
			
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawRect( 0, 0, self.ScreenResX, self.ScreenResY ) 
			
			if self.ShowConsole then
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.DrawOutlinedRect( 0, 40, 128, 1 ) 
				
				surface.SetMaterial( ARCLib.Icons16[self.CurrentFolderIcon] )
				surface.DrawTexturedRect( 2, 22, 16, 16 )
				
				local num = #self.MsgsTab - 15
				for i = 1,15 do
					if self.MsgsTab[num+i] then
						draw.SimpleText( self.MsgsTab[num+i], "ARCPhoneSmall", 2, 35+(i*12), Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER  )
					end
				end

				--draw.SimpleText( "ARCPhone", "ARCPhone", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
				draw.SimpleText( self.CurrentDir, "ARCPhone", 20, 32, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER  )
				--draw.SimpleText( self.thing[self.Selection], "ARCPhone", -36, -68, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER  )
			else
				local app = ARCPhone.Apps[self.ActiveApp]
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
				
				app:DrawTiles(self,self.MoveX,self.MoveY)
				if !self.HideWhatsOffTheScreen then
					surface.SetDrawColor( 255, 0, 0, 255 )
					surface.DrawOutlinedRect( relx1, rely1, relx2-relx1, rely2-rely1 ) 
				end
				if self.ShowOptions then
					for i = 1,#self.Options do
						if self.CurrentOption == i then
							draw.SimpleText("$"..self.Options[i].text, "ARCPhoneSmall", 126, 220 - ((i-1)*14), Color(255,255,255,255), TEXT_ALIGN_RIGHT , TEXT_ALIGN_TOP  )
						else
							draw.SimpleText(self.Options[i].text, "ARCPhoneSmall", 126, 220 - ((i-1)*14), Color(255,255,255,255), TEXT_ALIGN_RIGHT , TEXT_ALIGN_TOP  )
						end
					end
				end
				local maxmsgbox = #self.MsgBoxs  
				if maxmsgbox > 0 then -- ARITZ WORK HERE!
					
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

					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.DrawOutlinedRect( 0, 22, self.ScreenResX, 34 + 20*maxo + 12*#txttab) 
					surface.SetTexture(ARCLib.FlatIcons64[self.MsgBoxs[maxmsgbox].Icon])
					if self.MsgBoxs[maxmsgbox].Icon == "cross" then
						surface.SetDrawColor( 255, 32, 16, 255 )
					elseif self.MsgBoxs[maxmsgbox].Icon == "warning" then
						surface.SetDrawColor( 200, 200, 0, 255 )
					elseif self.MsgBoxs[maxmsgbox].Icon == "info" then
						surface.SetDrawColor( 64, 255, 64, 255 )
					elseif self.MsgBoxs[maxmsgbox].Icon == "question" then
						surface.SetDrawColor( 255, 64, 64, 255 )
					end
					surface.DrawTexturedRect( 4, 26, 16, 16 )
					
					draw.SimpleText(ARCLib.CutOutText(self.MsgBoxs[maxmsgbox].Title,"ARCPhone",buttonwidth),"ARCPhone", 24, 27, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
					for i = 1,#txttab do
						draw.SimpleText(txttab[i],"ARCPhoneSmall", 4, 34+(i*12), Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
					end
					surface.SetDrawColor( 75, 255, 75, 255 )
					surface.DrawRect( 4, 46 + 4 + 12*#txttab, buttonwidth, 20) 
					
					if typ == 1 || typ == 3 then
						draw.SimpleText("OK","ARCPhone", self.HalfScreenResX, 46 + 6 + 12*#txttab, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
					end
					if typ == 2 || typ == 6 then
						draw.SimpleText("Yes","ARCPhone", self.HalfScreenResX, 46 + 6 + 12*#txttab, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
					end
					if typ == 4 || typ == 7 then
						draw.SimpleText("Retry","ARCPhone", self.HalfScreenResX, 46 + 6 + 12*#txttab, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
					end
					if typ == 5 then
						draw.SimpleText("Reply","ARCPhone", self.HalfScreenResX, 46 + 6 + 12*#txttab, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
					end
					if typ == 8 then
						draw.SimpleText("Answer","ARCPhone", self.HalfScreenResX, 46 + 6 + 12*#txttab, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
					end
					if self.MsgBoxOption == 1 then
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.DrawOutlinedRect( 4, 46 + 4 + 12*#txttab, buttonwidth, 20) 
						
					end
					if maxo > 1 then
						surface.SetDrawColor( 255, 75, 75, 255 )
						surface.DrawRect( 4, 46 + 24 + 12*#txttab, buttonwidth, 20) 
						if typ == 2 || typ == 6 then
							draw.SimpleText("No","ARCPhone",self.HalfScreenResX,46 + 26 + 12*#txttab, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
						end
						if typ == 3 then
							draw.SimpleText("Cancel","ARCPhone",self.HalfScreenResX,46 + 26 + 12*#txttab, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
						end
						if typ == 4 || typ == 7 then
							draw.SimpleText("Abort","ARCPhone",self.HalfScreenResX,46 + 26 + 12*#txttab, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
						end
						if typ == 5 then
							draw.SimpleText("Close","ARCPhone",self.HalfScreenResX,46 + 26 + 12*#txttab, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
						end
						if typ == 8 then
							draw.SimpleText("Ignore","ARCPhone",self.HalfScreenResX,46 + 26 + 12*#txttab, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
						end
						if self.MsgBoxOption == 2 then
							surface.SetDrawColor( 255, 255, 255, 255 )
							surface.DrawOutlinedRect( 4, 46 + 24 + 12*#txttab, buttonwidth, 20) 
						end
					end
					if maxo > 2 then
						surface.SetDrawColor( 255, 255, 75, 255 )
						surface.DrawRect( 4, 46 + 44 + 12*#txttab, buttonwidth, 20) 
						if typ == 6 then
							draw.SimpleText("Cancel","ARCPhone", self.HalfScreenResX,  46 + 46 + 12*#txttab, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
						end
						if typ == 7 then
							draw.SimpleText("Ignore","ARCPhone", self.HalfScreenResX,  46 + 46 + 12*#txttab, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
						end
						if typ == 8 then
							draw.SimpleText("Text Excuse","ARCPhone", self.HalfScreenResX,  46 + 46 + 12*#txttab, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
						end
						if self.MsgBoxOption == 3 then
							surface.SetDrawColor( 255, 255, 255, 255 )
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
				
			end
			
			surface.SetDrawColor( 25*0.7, 25*0.7, 255*0.7, 255 )
			surface.DrawRect( 0, 0, self.ScreenResX, 20 ) 
			surface.SetDrawColor( 255, 255, 255, 255 )
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
				surface.SetDrawColor( 0, 0, 0, 185 )
				surface.DrawOutlinedRect( 0, 0, self.ScreenResX, self.ScreenResY ) 
				if self.LoadingPer < 0 then
					draw.SimpleText("Loading...", "ARCPhone", self.HalfScreenResX, self.HalfScreenResY, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
				else	
					draw.SimpleText("Loading... (".self.LoadingPer."%)", "ARCPhone", self.HalfScreenResX, self.HalfScreenResY, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
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
	for k,v in pairs(ARCPhone.Apps) do
		if file.Exists(ARCPhone.ROOTDIR.."/appdata/"..k..".txt","DATA") then
			local tab = util.JSONToTable(file.Read(ARCPhone.ROOTDIR.."/appdata/"..k..".txt","DATA"))
			if tab then
				v.Disk = tab
			end
		end
	end
	self:OpenApp("home")
	ARCPhone.PhoneSys:AddMsgBox("My excuse for a tutorial","Use the Arrow keys to move the cursor. Press BACKSPACE to go back, press CTRL to access the context menu, and press ENTER select.","info")
	ARCPhone.PhoneSys:AddMsgBox("PROTOTYPE VERSION","This is the prototype version of ARCPhone (pre-alpha), and does not represent the final product. Everything is subject to change. (Press ENTER to close this window)","info")
end

	function ARCPhone.PhoneSys:Print(msg)
		self.Msgs = self.Msgs..msg.."\n"
		if #self.Msgs > 4096 then
			self.Msgs = string.Right( self.Msgs, 4096 )
		end
		self.MsgsTab = ARCLib.FitText(self.Msgs,"ARCPhoneSmall",124)
	end
	function ARCPhone.PhoneSys:SendText(number,message)
		if file.Exists(fil,"DATA") then
			file.Append(fil,"\f\t"..message) 
		else
			file.Write(fil,"\t"..message) 
		end
		local hash = ARCLib.md5(msg)
		ARCPhone.PhoneSys.OutgoingTexts[hash] = {}
		ARCPhone.PhoneSys.OutgoingTexts[hash].msg = ARCLib.SplitString(msg,16384)
		ARCPhone.PhoneSys.OutgoingTexts[hash].number = number
		ARCPhone.PhoneSys.OutgoingTexts[hash].place = -1
	end
	function ARCPhone.PhoneSys:RecieveText(number,message)
		self:AddMsgBox("New Message","New Message from "..number,"comments",ARCPHONE_MSGBOX_REPLY,function()
			
		end)
		local fil = ARCPhone.ROOTDIR.."/messaging/"..number..".txt"
		if file.Exists(fil,"DATA") then
			file.Append(fil,"\f\v"..message) 
		else
			file.Write(fil,"\v"..message) 
		end
		file.Write(ARCPhone.ROOTDIR.."/messaging/"..number..".txt",util.TableToJSON(texts))
	end
	function ARCPhone.PhoneSys:Call(number)
		if !number || !isstring(number) || number == "" then
			self:AddMsgBox("ARCPhone","Invalid number.","cross")
		else
			if self.Status != ARCPHONE_ERROR_CALL_ENDED then
				self:AddMsgBox("ARCPhone","Call is not ended.","cross")
			else
				net.Start("arcphone_comm_call")
				net.WriteInt(1,8)
				net.WriteString(number)
				net.SendToServer()
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
	function ARCPhone.PhoneSys.GroupCall(tabonumbers)
		local number = #tabonumbers
		if number > 127 then
			self:Print("Too many numbers.")
		elseif number > 1 then
			net.Start("arcphone_comm_call")
			net.WriteInt(number*-1,8)
			for i = 1,number do
				if !tabonumbers[i] || !isstring(tabonumbers[i]) || tabonumbers[i] == "" then
					self:Print("Number "..i.." is invalid.")
				else
					MsgN(tabonumbers[i])
					net.WriteString(tabonumbers[i])
				end
			end
			net.SendToServer()
		else
			self:Print("Not enough numbers.")
		end
	end
	
	function ARCPhone.PhoneSys.AddToCall(number)
		if !number || !isstring(number) || number == "" then
			if self.Status != ARCPHONE_ERROR_NONE then
				self:Print("No call running or call has not been established.")
			else
				net.Start("arcphone_comm_call")
				net.WriteInt(4,8)
				net.WriteString(number)
				net.SendToServer()
			end
		else
			self:Print("Invalid phone number.")
		end
	end
	function ARCPhone.PhoneSys:HangUp()
		net.Start("arcphone_comm_call")
		net.WriteInt(3,8)
		net.SendToServer()
	end
	function ARCPhone.PhoneSys:OpenApp(app)
		if !app || !isstring(app) || app == "" || !ARCPhone.Apps[app] then
			self:AddMsgBox("Cannot open app","App is invalid or not available in this area.","cross")
		else
			self.OldSelectedAppTile = 1
			self.SelectedAppTile = 1
			self.ShowConsole = false
			self.ActiveApp = app
			self.MoveX = 0
			self.MoveY = 0
			ARCPhone.Apps[app]:Init()
		end
	end
	function ARCPhone.PhoneSys:Lock()
		if self.LastWep then
			net.Start("arcphone_switchwep")
			net.WriteString(self.LastWep)
			net.SendToServer()
		end
	end
	function ARCPhone.PhoneSys:RunCommand(cmdstring)
		self:Print("$ "..cmdstring)
		local args = string.Explode( " ", cmdstring )
		if args[1] == "call" then
			if args[2] == "-c" then
				self:Call(args[3])
			elseif args[2] == "-a" then
				self:Answer()
			elseif args[2] == "-m" then
				local tablel = args
				table.remove( tablel, 2 )
				table.remove( tablel, 2 )
				self:GroupCall(tablel)
			elseif args[2] == "-add" then
				self:AddToCall(args[3])
			elseif args[2] == "-h" || args[2] == "-e" then
				self:HangUp()
			else
				self:Print("Invalid usage.")
			end
		elseif args[1] == "app" then
			if args[2] then
				self:OpenApp(args[2])
			else
				self:Print("No app specified.")
			end
		elseif args[1] == "chatlist" then
			self.Print("--on--")
			for k,v in pairs(self.CurrentCall.on) do
				self.Print(v.." - "..ARCPhone.GetPlayerFromPhoneNumber(v):Nick())
			end
			self.Print("--pending--")
			for k,v in pairs(self.CurrentCall.pending) do
				self.Print(v.." - "..ARCPhone.GetPlayerFromPhoneNumber(v):Nick())
			end
		elseif args[1] == "showtext" then
			if args[2] then
				local texts
				if file.Exists(ARCPhone.ROOTDIR.."/messaging/"..args[2]..".txt","DATA") then
					texts = util.JSONToTable(file.Read(ARCPhone.ROOTDIR.."/messaging/"..args[2]..".txt","DATA"))
				end
				for i = 1, #texts do
					if texts[i][1] then
						self:Print("---SENT---")
					else
						self:Print("-RECIEVED-")
					end
					self:Print(texts[i][2])
				end
			else
				self:Print("No number specifiifiied")
			end
		
		elseif args[1] == "text" then
			local num = tonumber(args[2])
			if isnumber(num) then
				if self.Reception < 16 then
					self:Print("Not enough reception")
				else
					if #args < 3 then
						self:Print("Send a message, fool!")
					else
						local message = ""
						for i = 3,#args do
							message = message.." "..args[i]
						end
						local texts
						if file.Exists(ARCPhone.ROOTDIR.."/messaging/"..args[2]..".txt","DATA") then
							texts = util.JSONToTable(file.Read(ARCPhone.ROOTDIR.."/messaging/"..args[2]..".txt","DATA"))
						end
						if !texts then
							texts = {}
						end
						texts[#texts+1] = {true,message}
						file.Write(ARCPhone.ROOTDIR.."/messaging/"..args[2]..".txt",util.TableToJSON(texts))
						net.Start("arcphone_comm_text")
						net.WriteString(args[2])
						net.WriteString(message)
						net.SendToServer()
					end
				end
			else
				self:Print("Invalid phone number.")
			end
			
		elseif args[1] == "cd" then
			if !args[2] || args[2] == "" then return end
			if args[2] == ".." then
				if self.CurrentDir == "/" then
					self:Lock()
				else
					local dirs = string.Explode( "/", self.CurrentDir )
					local len = string.len(self.CurrentDir) - string.len(dirs[#dirs-1].."/")
					self.CurrentDir = string.Left(self.CurrentDir, len )
				end
			else
				if string.StartWith( args[2], "/" ) then
					if file.IsDir( ARCPhone.ROOTDIR..args[2], "DATA" ) then
						self.CurrentDir = args[2]
					end
				else
					if file.IsDir( ARCPhone.ROOTDIR..self.CurrentDir..args[2], "DATA" ) then
						self.CurrentDir = self.CurrentDir..args[2].."/"
					end
				end
			end
			return
		elseif args[1] == "ls" then
			local files, directories = file.Find( ARCPhone.ROOTDIR..self.CurrentDir.."*", "DATA" )
			for i = 1,#directories do
				self:Print("<DIR> "..directories[i])
			end
			for i = 1,#files do
				self:Print(files[i])
			end
			return
		elseif args[1] == "clear" then
			self.Msgs = ""
			self.MsgsTab = {}
			return
		elseif args[1] == "toggleconsole" then
			self.ShowConsole = !self.ShowConsole
		elseif args[1] == "lol" then
			self:Print("It Works!")
		elseif args[1] == "help" then
			self:Print("You don't need no help, this is a dev console!")
		else
			self:Print("'"..args[1].."' is not a valid file or command.")
		end
	end
		
	-- KEY_UP,KEY_DOWN,KEY_LEFT,KEY_RIGHT,KEY_ENTER,KEY_BACKSPACE,KEY_RCONTROL
	
	function ARCPhone.PhoneSys:OnButton(button)

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
					self:EmitSound("buttons/button9.wav",60,255)
				else
					self:EmitSound("common/wpn_denyselect.wav")
				end
			elseif button == KEY_UP then
				if self.MsgBoxOption > 1 then
					self.MsgBoxOption = self.MsgBoxOption - 1
					self:EmitSound("buttons/button9.wav",60,255)
				else
					self:EmitSound("common/wpn_denyselect.wav")
				end
			end
		elseif self.ShowOptions then
			if button == KEY_BACKSPACE then
				self.ShowOptions = false
			elseif button == KEY_UP then
				if self.CurrentOption < #self.Options then
					self.CurrentOption = self.CurrentOption + 1
					self:EmitSound("buttons/button9.wav",60,255)
				else
					self:EmitSound("common/wpn_denyselect.wav")
				end
			elseif button == KEY_DOWN then
				if self.CurrentOption > 1 then
					self.CurrentOption = self.CurrentOption - 1
					self:EmitSound("buttons/button9.wav",60,255)
				else
					self:EmitSound("common/wpn_denyselect.wav")
				end
			end
		else
			if !app.DisableTileSwitching then
				app:_SwitchTile(self,button)
			end
			if button == KEY_BACKSPACE then
				app:OnBack(self)
			elseif button == KEY_ENTER then
				app:OnEnter(self)
			elseif button == KEY_UP then
				app:OnUp(self)
			elseif button == KEY_DOWN then
				app:OnDown(self)
			elseif button == KEY_LEFT then
				app:OnLeft(self)
			elseif button == KEY_RIGHT then
				app:OnRight(self)
			end
		end
	end
	
	local ispressinginmanu = false
	function ARCPhone.PhoneSys:OnButtonUp(button)
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
		elseif self.ShowOptions then
			if button == KEY_ENTER then
				self.Options[self.CurrentOption].func(self,app)
				self.ShowOptions = false
			end
		else
			if button == KEY_BACKSPACE then
				app:OnBackUp(self)
			elseif button == KEY_ENTER then
				app:_OnEnterUp(self)
				app:OnEnterUp(self)
			elseif button == KEY_UP then
				app:OnUpUp(self)
			elseif button == KEY_DOWN then
				app:OnDownUp(self)
			elseif button == KEY_LEFT then
				app:OnLeftUp(self)
			elseif button == KEY_RIGHT then
				app:OnRightUp(self)
			end
		end
	end
	function ARCPhone.PhoneSys:OnButtonDown(button)
		if #self.MsgBoxs > 0 then
			ispressinginmanu = true
		elseif self.ShowOptions then return end
		local app = ARCPhone.Apps[self.ActiveApp]
		if button == KEY_BACKSPACE then
			app:OnBackDown(self)
		elseif button == KEY_ENTER then
			app:_OnEnterDown(self)
			app:OnEnterDown(self)
		elseif button == KEY_UP then
			app:OnUpDown(self)
		elseif button == KEY_DOWN then
			app:OnDownDown(self)
		elseif button == KEY_LEFT then
			app:OnLeftDown(self)
		elseif button == KEY_RIGHT then
			app:OnRightDown(self)
		end
	end
	
	--ARCPhone.PhoneSys.Init()