-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.

-- TODO: STOP MESSING WITH APP.Tiles and do the stuff properly!!
local APP = ARCPhone.NewAppObject()
APP.Name = "Settings"
APP.Author = "ARitz Cracker"
APP.Purpose = "Something I put off until the last minute"
APP.FlatIconName = "settings-cogwheel-button"

--[[
function APP:PhoneStart()

end
]]
--tile.App

function APP:SelectCategory(a)
	self.FriendlyScreen = false
	self.Section = a
	self:ClearScreen()
	local i = 0
	local ypos = 32
	for k,v in SortedPairs(self.Phone.Settings[a]) do
		--PrintTable(self.Phone.SettingChoices[a][v])
		local multiChoice = false
		if self.Phone.SettingChoices[a] && self.Phone.SettingChoices[a][k] then
			multiChoice = true
			i = i + 1
			self:CreateNewLabel(8,ypos,0,0,k,"ARCPhone",self.Phone.Settings.Personalization.CL_03_MainText,self.Phone.Settings.Personalization.CL_01_MainColour)
			ypos = ypos + 16
			
			self.Tiles[i] = ARCPhone.NewAppChoiceInputTile(self)
			self.Tiles[i].ID = i
			self.Tiles[i].x = 8
			self.Tiles[i].y = ypos
			self.Tiles[i].w = 122
			self.Tiles[i].h = 20
			self.Tiles[i].color = self.Phone.Settings.Personalization.CL_03_MainText
			self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_01_MainColour
			--PrintTable(self.Phone.SettingChoices[a][k])
			local customChoice = true
			for ii=1,#self.Phone.SettingChoices[a][k] do
				self.Tiles[i]:AddChoice(self.Phone.SettingChoices[a][k][ii][1],self.Phone.SettingChoices[a][k][ii][2])
				if (v==self.Phone.SettingChoices[a][k][ii][2]) then
					self.Tiles[i].SelectedChoice = ii
					customChoice = false
				end
			end
			if customChoice then
				self.Tiles[i].ChoiceText = "*CUSTOM*"
			end
			ypos = ypos + 22 + 5
			self.Tiles[i].Setting = k
		end
		
		if IsColor(v) then
			i = i + 1
			self.Tiles[i] = ARCPhone.NewAppColorInputTile(self,v,k)
			self.Tiles[i].ID = i
			self.Tiles[i].x = 8
			self.Tiles[i].y = ypos
			self.Tiles[i].w = 122
			self.Tiles[i].h = 48
			self.Tiles[i].Setting = k
			ypos = ypos + 50 + 5
		elseif isnumber(v) then
			self:CreateNewLabel(8,ypos,90,30,k,"ARCPhone",self.Phone.Settings.Personalization.CL_03_MainText,self.Phone.Settings.Personalization.CL_01_MainColour)
			i = i + 1
			self.Tiles[i] = ARCPhone.NewAppNumberInputTile(self,v)
			self.Tiles[i].ID = i
			self.Tiles[i].x = 100
			self.Tiles[i].y = ypos
			self.Tiles[i].w = 24
			self.Tiles[i].h = 30
			self.Tiles[i].Setting = k
			self.Tiles[i].color = self.Phone.Settings.Personalization.CL_03_MainText
			self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_01_MainColour
			self.Tiles[i]:SetMax(100000000000-1)
			self.Tiles[i]:SetMin(-100000000000+1)
			self.Tiles[i]:SetValue(v)
			ypos = ypos + 32 + 5
		elseif isstring(v) then
			if not multiChoice then
				self:CreateNewLabel(8,ypos,0,0,k,"ARCPhone",self.Phone.Settings.Personalization.CL_03_MainText,self.Phone.Settings.Personalization.CL_01_MainColour)
				ypos = ypos + 16 
			else
				ypos = ypos - 4
			end
			i = i + 1
			self.Tiles[i] = ARCPhone.NewAppTextInputTile(self,v,false,122)
			self.Tiles[i].ID = i
			self.Tiles[i].y = ypos
			self.Tiles[i].w = 122
			self.Tiles[i].x = 8
			self.Tiles[i].color = self.Phone.Settings.Personalization.CL_11_QuaternaryText
			self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_09_QuaternaryColour
			self.Tiles[i].SingleLine = true
			self.Tiles[i].Setting = k
			ypos = ypos + 18 + 5
			
			if a == "Ringtones" then
				i = i + 1
				ypos = ypos - 5
				local textInput = self.Tiles[i-1]
				self.Tiles[i] = ARCPhone.NewAppColorInputTile(self,v,k)
				self.Tiles[i].ID = i
				self.Tiles[i].x = 8
				self.Tiles[i].y = ypos
				self.Tiles[i].w = 122
				self.Tiles[i].h = 18
				self.Tiles[i].color = self.Phone.Settings.Personalization.CL_01_MainColour
				self.Tiles[i].drawfunc = function(tile,x,y)
					draw.SimpleText("Preview ringtone", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_03_MainText, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
				end
				self.Tiles[i].OnPressed = function(tile)
					tile.color = tile.App.Phone.Settings.Personalization.CL_02_MainPressed
				end
				self.Tiles[i].OnUnPressed = function(tile)
					tile.color = tile.App.Phone.Settings.Personalization.CL_01_MainColour
					tile.App.Phone:OpenApp("music"):PlayURL(textInput:GetValue())
				end
				
				ypos = ypos + 18 + 5
			end
		end
		if multiChoice then

			local ii = i
			if a == "Ringtones" then
				ii = ii - 1
			end
			self.Tiles[ii-1].OnChosen = function(tile,val)
				MsgN(val)
				self.Tiles[ii]:SetValue(val)
			end
			self.Tiles[ii].OnChosen = function(tile)
				self.Tiles[ii-1].ChoiceText = "*CUSTOM*"
			end
		end
	end
	if a == "System" then
		
	end
end

function APP:Init()
	self.FriendlyScreen = false
	self.Section = ""
	self:ClearScreen()
	local i = 0
	for k in SortedPairs(self.Phone.Settings) do
		i = i + 1
		self.Tiles[i] = ARCPhone.NewAppTile(self)
		self.Tiles[i].ID = i
		self.Tiles[i].x = 8
		self.Tiles[i].y = 12 + 20*i
		self.Tiles[i].w = 122
		self.Tiles[i].h = 18
		self.Tiles[i].color = self.Phone.Settings.Personalization.CL_03_MainText
		self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_01_MainColour
		self.Tiles[i].text = k
		
		self.Tiles[i].OnPressed = function(tile)
			tile.bgcolor = self.Phone.Settings.Personalization.CL_02_MainPressed
		end
		self.Tiles[i].OnUnPressed = function(tile)
			tile.bgcolor = self.Phone.Settings.Personalization.CL_01_MainColour
			if k == "Privacy" then
				tile.App.Phone:AddMsgBox("Coming soon!","There's nothing here yet!")
			elseif k == "System" then
				self.FriendlyScreen = true
				self:ClearScreen()
				local i = 1
				local ypos = 32
				self:CreateNewLabel(8,ypos,0,0,"Your phone number","ARCPhone",self.Phone.Settings.Personalization.CL_03_MainText,self.Phone.Settings.Personalization.CL_01_MainColour)
				ypos = ypos + 16
				self.Tiles[i] = ARCPhone.NewAppTextInputTile(self,ARCPhone.GetPhoneNumber(LocalPlayer()),false,122)
				self.Tiles[i].ID = i
				self.Tiles[i].y = ypos
				self.Tiles[i].w = 122
				self.Tiles[i].x = 8
				self.Tiles[i].color = self.Phone.Settings.Personalization.CL_11_QuaternaryText
				self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_09_QuaternaryColour
				self.Tiles[i].SingleLine = true
				self.Tiles[i].Editable = false
				ypos = ypos + 18 + 5
				--{s.KeyUp,s.KeyDown,s.KeyLeft,s.KeyRight,s.KeyEnter,s.KeyBack,s.KeyContext}
				
				self:CreateNewLabel(8,ypos,0,0,"Move Up","ARCPhone",self.Phone.Settings.Personalization.CL_03_MainText,self.Phone.Settings.Personalization.CL_01_MainColour)
				ypos = ypos + 16 
				i = i + 1
				self.Tiles[i] = ARCPhone.NewAppKeyInputTile(self,self.Phone.Settings.System.KeyUp)
				self.Tiles[i].ID = i
				self.Tiles[i].y = ypos
				self.Tiles[i].w = 122
				self.Tiles[i].x = 8
				self.Tiles[i].h = 18
				self.Tiles[i].color = self.Phone.Settings.Personalization.CL_11_QuaternaryText
				self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_09_QuaternaryColour
				self.Tiles[i].OnDeselect = function(tile)
					local s = tile.App.Phone.Settings.System
					local val = tile:GetValue()
					if s.KeyUp == val then return end
					if table.HasValue( tile.App.Phone.ValidKeys, val ) then
						tile.App.Phone:AddMsgBox("I just saved your ass","Your actions would have made your phone unusable","report-symbol")
						tile:SetValue(s.KeyUp)
						return
					end
					
					s.KeyUp = val
					tile.App.Phone:SetValidKeys({s.KeyUp,s.KeyDown,s.KeyLeft,s.KeyRight,s.KeyEnter,s.KeyBack,s.KeyContext})
					net.Start("arcphone_phone_settings")
					net.WriteUInt(tile.App.Phone.Settings.Personalization.PhoneCase,4)
					net.WriteUInt(s.KeyUp,8)
					net.SendToServer()
				end
				ypos = ypos + 18 + 5
				
				self:CreateNewLabel(8,ypos,0,0,"Move Down","ARCPhone",self.Phone.Settings.Personalization.CL_03_MainText,self.Phone.Settings.Personalization.CL_01_MainColour)
				ypos = ypos + 16 
				i = i + 1
				self.Tiles[i] = ARCPhone.NewAppKeyInputTile(self,self.Phone.Settings.System.KeyDown)
				self.Tiles[i].ID = i
				self.Tiles[i].y = ypos
				self.Tiles[i].w = 122
				self.Tiles[i].x = 8
				self.Tiles[i].h = 18
				self.Tiles[i].color = self.Phone.Settings.Personalization.CL_11_QuaternaryText
				self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_09_QuaternaryColour
				self.Tiles[i].OnDeselect = function(tile)
					local s = tile.App.Phone.Settings.System
					local val = tile:GetValue()
					if s.KeyDown == val then return end
					if table.HasValue( tile.App.Phone.ValidKeys, val ) then
						tile.App.Phone:AddMsgBox("I just saved your ass","Your actions would have made your phone unusable","report-symbol")
						tile:SetValue(s.KeyDown)
						return
					end
					s.KeyDown = val
					tile.App.Phone:SetValidKeys({s.KeyUp,s.KeyDown,s.KeyLeft,s.KeyRight,s.KeyEnter,s.KeyBack,s.KeyContext})
				end
				ypos = ypos + 18 + 5
				
				self:CreateNewLabel(8,ypos,0,0,"Move Left","ARCPhone",self.Phone.Settings.Personalization.CL_03_MainText,self.Phone.Settings.Personalization.CL_01_MainColour)
				ypos = ypos + 16 
				i = i + 1
				self.Tiles[i] = ARCPhone.NewAppKeyInputTile(self,self.Phone.Settings.System.KeyLeft)
				self.Tiles[i].ID = i
				self.Tiles[i].y = ypos
				self.Tiles[i].w = 122
				self.Tiles[i].x = 8
				self.Tiles[i].h = 18
				self.Tiles[i].color = self.Phone.Settings.Personalization.CL_11_QuaternaryText
				self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_09_QuaternaryColour
				self.Tiles[i].OnDeselect = function(tile)
					local s = tile.App.Phone.Settings.System
					local val = tile:GetValue()
					if s.KeyLeft == val then return end
					if table.HasValue( tile.App.Phone.ValidKeys, val ) then
						tile.App.Phone:AddMsgBox("I just saved your ass","Your actions would have made your phone unusable","report-symbol")
						tile:SetValue(s.KeyLeft)
						return
					end
					s.KeyLeft = val
					tile.App.Phone:SetValidKeys({s.KeyUp,s.KeyDown,s.KeyLeft,s.KeyRight,s.KeyEnter,s.KeyBack,s.KeyContext})
				end
				ypos = ypos + 18 + 5
				
				self:CreateNewLabel(8,ypos,0,0,"Move Right","ARCPhone",self.Phone.Settings.Personalization.CL_03_MainText,self.Phone.Settings.Personalization.CL_01_MainColour)
				ypos = ypos + 16 
				i = i + 1
				self.Tiles[i] = ARCPhone.NewAppKeyInputTile(self,self.Phone.Settings.System.KeyRight)
				self.Tiles[i].ID = i
				self.Tiles[i].y = ypos
				self.Tiles[i].w = 122
				self.Tiles[i].x = 8
				self.Tiles[i].h = 18
				self.Tiles[i].color = self.Phone.Settings.Personalization.CL_11_QuaternaryText
				self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_09_QuaternaryColour
				self.Tiles[i].OnDeselect = function(tile)
					local s = tile.App.Phone.Settings.System
					local val = tile:GetValue()
					if s.KeyRight == val then return end
					if table.HasValue( tile.App.Phone.ValidKeys, val ) then
						tile.App.Phone:AddMsgBox("I just saved your ass","Your actions would have made your phone unusable","report-symbol")
						tile:SetValue(s.KeyRight)
						return
					end
					s.KeyRight = val
					tile.App.Phone:SetValidKeys({s.KeyUp,s.KeyDown,s.KeyLeft,s.KeyRight,s.KeyEnter,s.KeyBack,s.KeyContext})
				end
				ypos = ypos + 18 + 5
				
				self:CreateNewLabel(8,ypos,0,0,"Select","ARCPhone",self.Phone.Settings.Personalization.CL_03_MainText,self.Phone.Settings.Personalization.CL_01_MainColour)
				ypos = ypos + 16 
				i = i + 1
				self.Tiles[i] = ARCPhone.NewAppKeyInputTile(self,self.Phone.Settings.System.KeyEnter)
				self.Tiles[i].ID = i
				self.Tiles[i].y = ypos
				self.Tiles[i].w = 122
				self.Tiles[i].x = 8
				self.Tiles[i].h = 18
				self.Tiles[i].color = self.Phone.Settings.Personalization.CL_11_QuaternaryText
				self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_09_QuaternaryColour
				self.Tiles[i].OnDeselect = function(tile)
					local s = tile.App.Phone.Settings.System
					local val = tile:GetValue()
					if s.KeyEnter == val then return end
					if table.HasValue( tile.App.Phone.ValidKeys, val ) then
						tile.App.Phone:AddMsgBox("I just saved your ass","Your actions would have made your phone unusable","report-symbol")
						tile:SetValue(s.KeyEnter)
						return
					end
					s.KeyEnter = val
					tile.App.Phone:SetValidKeys({s.KeyUp,s.KeyDown,s.KeyLeft,s.KeyRight,s.KeyEnter,s.KeyBack,s.KeyContext})
				end
				ypos = ypos + 18 + 5
				
				self:CreateNewLabel(8,ypos,0,0,"Back","ARCPhone",self.Phone.Settings.Personalization.CL_03_MainText,self.Phone.Settings.Personalization.CL_01_MainColour)
				ypos = ypos + 16 
				i = i + 1
				self.Tiles[i] = ARCPhone.NewAppKeyInputTile(self,self.Phone.Settings.System.KeyBack)
				self.Tiles[i].ID = i
				self.Tiles[i].y = ypos
				self.Tiles[i].w = 122
				self.Tiles[i].x = 8
				self.Tiles[i].h = 18
				self.Tiles[i].color = self.Phone.Settings.Personalization.CL_11_QuaternaryText
				self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_09_QuaternaryColour
				self.Tiles[i].OnDeselect = function(tile)
					local s = tile.App.Phone.Settings.System
					local val = tile:GetValue()
					if s.KeyBack == val then return end
					if table.HasValue( tile.App.Phone.ValidKeys, val ) then
						tile.App.Phone:AddMsgBox("I just saved your ass","Your actions would have made your phone unusable","report-symbol")
						tile:SetValue(s.KeyBack)
						return
					end
					s.KeyBack = val
					tile.App.Phone:SetValidKeys({s.KeyUp,s.KeyDown,s.KeyLeft,s.KeyRight,s.KeyEnter,s.KeyBack,s.KeyContext})
				end
				ypos = ypos + 18 + 5
				
				self:CreateNewLabel(8,ypos,0,0,"Context Menu","ARCPhone",self.Phone.Settings.Personalization.CL_03_MainText,self.Phone.Settings.Personalization.CL_01_MainColour)
				ypos = ypos + 16 
				i = i + 1
				self.Tiles[i] = ARCPhone.NewAppKeyInputTile(self,self.Phone.Settings.System.KeyContext)
				self.Tiles[i].ID = i
				self.Tiles[i].y = ypos
				self.Tiles[i].w = 122
				self.Tiles[i].x = 8
				self.Tiles[i].h = 18
				self.Tiles[i].color = self.Phone.Settings.Personalization.CL_11_QuaternaryText
				self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_09_QuaternaryColour
				self.Tiles[i].OnDeselect = function(tile)
					local s = tile.App.Phone.Settings.System
					local val = tile:GetValue()
					if s.KeyContext == val then return end
					if table.HasValue( tile.App.Phone.ValidKeys, val ) then
						tile.App.Phone:AddMsgBox("I just saved your ass","Your actions would have made your phone unusable","report-symbol")
						tile:SetValue(s.KeyContext)
						return
					end
					s.KeyContext = val
					tile.App.Phone:SetValidKeys({s.KeyUp,s.KeyDown,s.KeyLeft,s.KeyRight,s.KeyEnter,s.KeyBack,s.KeyContext})
				end
				ypos = ypos + 18 + 5
				
				i = i + 1
				self.Tiles[i] = ARCPhone.NewAppTile(self)
				self.Tiles[i].ID = i
				self.Tiles[i].x = 8
				self.Tiles[i].y = ypos
				self.Tiles[i].w = 122
				self.Tiles[i].h = 18
				self.Tiles[i].color = self.Phone.Settings.Personalization.CL_03_MainText
				self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_01_MainColour
				self.Tiles[i].text = "Advanced settings"
				
				self.Tiles[i].OnPressed = function(tile)
					tile.bgcolor = self.Phone.Settings.Personalization.CL_02_MainPressed
				end
				self.Tiles[i].OnUnPressed = function(tile)
					tile.App:SelectCategory(k)
				end
				
			elseif k == "Personalization" then
				self.FriendlyScreen = true
				self:ClearScreen()
				local i = 1
				local ypos = 32
				
				self.Tiles[i] = ARCPhone.NewAppColorInputTile(self,self.Phone.Settings.Personalization.CL_01_MainColour,"Phone Theme")
				self.Tiles[i].ID = i
				self.Tiles[i].x = 8
				self.Tiles[i].y = ypos
				self.Tiles[i].w = 122
				self.Tiles[i].h = 48
				ypos = ypos + 50 + 5
				self.Tiles[i].OnChosen = function(tile,val)
					print(self.Phone)
					
					
					self.Phone.Settings.Personalization.CL_00_CursorColour = Color(255,255,255,255)

					self.Phone.Settings.Personalization.CL_01_MainColour = Color(val.r*1,val.g*1,val.b*1,val.a*1)
					self.Phone.Settings.Personalization.CL_02_MainPressed = Color(val.r*1,val.g*1,val.b*1,val.a*0.5)
					self.Phone.Settings.Personalization.CL_03_MainText = ARCPhone.TextOnColor(self.Phone.Settings.Personalization.CL_01_MainColour)

					self.Phone.Settings.Personalization.CL_03_SecondaryColour = Color(val.r*0.5,val.g*0.5,val.b*0.5,val.a*1)
					self.Phone.Settings.Personalization.CL_04_SecondaryPressed = Color(val.r*0.5,val.g*0.5,val.b*0.5,val.a*0.5)
					self.Phone.Settings.Personalization.CL_05_SecondaryText = ARCPhone.TextOnColor(self.Phone.Settings.Personalization.CL_03_SecondaryColour)

					self.Phone.Settings.Personalization.CL_06_TertiaryColour = Color(val.r*0.25,val.g*0.25,val.b*0.25,val.a*1)
					self.Phone.Settings.Personalization.CL_07_TertiaryPressed = Color(val.r*0.25,val.g*0.25,val.b*0.25,val.a*0.5)
					self.Phone.Settings.Personalization.CL_08_TertiaryText = ARCPhone.TextOnColor(self.Phone.Settings.Personalization.CL_06_TertiaryColour)
					
					self.Phone.Settings.Personalization.CL_09_QuaternaryColour = Color(128,128,128,255)
					self.Phone.Settings.Personalization.CL_10_QuaternaryPressed = Color(128,128,128,128)
					self.Phone.Settings.Personalization.CL_11_QuaternaryText = Color(255,255,255,255)

					self.Phone.Settings.Personalization.CL_12_HotbarColour = Color(val.r*0.7,val.g*0.7,val.b*0.7,val.a*1)
					self.Phone.Settings.Personalization.CL_12_HotbarBorder = ARCPhone.TextOnColor(self.Phone.Settings.Personalization.CL_12_HotbarColour)
					self.Phone.Settings.Personalization.CL_13_BackgroundColour = Color(0,0,0,255)

					self.Phone.Settings.Personalization.CL_14_ContextMenuMain = Color(val.r*0.5,val.g*0.5,val.b*0.5,val.a*1)
					self.Phone.Settings.Personalization.CL_15_ContextMenuSelect = Color(val.r*1,val.g*1,val.b*1,val.a*1)
					self.Phone.Settings.Personalization.CL_16_ContextMenuBorder = Color(math.Clamp(val.r*2,0,255),math.Clamp(val.g*2,0,255),math.Clamp(val.b*2,0,255),val.a*1)
					self.Phone.Settings.Personalization.CL_17_ContextMenuText = ARCPhone.TextOnColor(self.Phone.Settings.Personalization.CL_14_ContextMenuMain)
					self.Phone.Settings.Personalization.CL_17_ContextMenuTextSelect = ARCPhone.TextOnColor(self.Phone.Settings.Personalization.CL_15_ContextMenuSelect)

					self.Phone.Settings.Personalization.CL_18_FadeColour = Color(0,0,0,150)
					self.Phone.Settings.Personalization.CL_19_MegaFadeColour = Color(0,0,0,225)

					self.Phone.Settings.Personalization.CL_20_PopupBoxMain = Color(100,100,100,255)
					self.Phone.Settings.Personalization.CL_21_PopupBoxText = Color(255,255,255,255)
					self.Phone.Settings.Personalization.CL_22_PopupAccept = Color(75,255,75,255)
					self.Phone.Settings.Personalization.CL_23_PopupAcceptText = Color(255,255,255,255)
					self.Phone.Settings.Personalization.CL_24_PopupDeny = Color(255,75,75,255 )
					self.Phone.Settings.Personalization.CL_25_PopupDenyText = Color(255,255,255,255)
					self.Phone.Settings.Personalization.CL_26_PopupDefer = Color(255,255,75,255)
					self.Phone.Settings.Personalization.CL_27_PopupDeferText = Color(0,0,0,255)
					
				end
				
				self:CreateNewLabel(8,ypos,0,0,"Phone Case","ARCPhone",self.Phone.Settings.Personalization.CL_03_MainText,self.Phone.Settings.Personalization.CL_01_MainColour)
				ypos = ypos + 16
				i = i + 1
				self.Tiles[i] = ARCPhone.NewAppChoiceInputTile(self)
				self.Tiles[i].ID = i
				self.Tiles[i].x = 8
				self.Tiles[i].y = ypos
				self.Tiles[i].w = 122
				self.Tiles[i].h = 20
				self.Tiles[i].color = self.Phone.Settings.Personalization.CL_03_MainText
				self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_01_MainColour
				local customChoice = true
				for ii=0,13 do
					self.Tiles[i]:AddChoice(ARCPhone.Msgs.PhoneCases[ii],ii)
				end
				self.Tiles[i].SelectedChoice = self.Phone.Settings.Personalization.PhoneCase + 1
				self.Tiles[i].OnChosen = function(tile,val)
					self.Phone.Settings.Personalization.PhoneCase = val
					net.Start("arcphone_phone_settings")
					net.WriteUInt(val,4)
					net.WriteUInt(tile.App.Phone.Settings.System.KeyUp,8)
					net.SendToServer()
				end
				
				ypos = ypos + 22 + 5
				i = i + 1
				self.Tiles[i] = ARCPhone.NewAppTile(self)
				self.Tiles[i].ID = i
				self.Tiles[i].x = 8
				self.Tiles[i].y = ypos
				self.Tiles[i].w = 122
				self.Tiles[i].h = 18
				self.Tiles[i].color = self.Phone.Settings.Personalization.CL_03_MainText
				self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_01_MainColour
				self.Tiles[i].text = "Advanced settings"
				
				self.Tiles[i].OnPressed = function(tile)
					tile.bgcolor = self.Phone.Settings.Personalization.CL_02_MainPressed
				end
				self.Tiles[i].OnUnPressed = function(tile)
					tile.App:SelectCategory(k)
				end
			else
				tile.App:SelectCategory(k)
			end
		end
	end
	

	--[[
	self.Tiles[3] = ARCPhone.NewAppChoiceInputTile(self)
	self.Tiles[3].x = 8
	self.Tiles[3].y = 255
	self.Tiles[3].w = 122
	self.Tiles[3].h = 20
	self.Tiles[3].color = self.Phone.Settings.Personalization.CL_01_MainColour
	self.Tiles[3]:AddChoice("Wan",1)
	self.Tiles[3]:AddChoice("Too",2)
	self.Tiles[3]:AddChoice("Fwee",3)
	]]
end

function APP:OnBack()
	
	if self.FriendlyScreen then
		self:Init()
	elseif self.Section and #self.Section > 0 then
		for i=1,#self.Tiles-1 do
			if self.Tiles[i].Setting then
				self.Phone.Settings[self.Section][self.Tiles[i].Setting] = self.Tiles[i]:GetValue()
			end
		end
		local s = self.Phone.Settings.System
		net.Start("arcphone_phone_settings")
		net.WriteUInt(self.Phone.Settings.Personalization.PhoneCase,4)
		net.WriteUInt(s.KeyUp,8)
		net.SendToServer()
		self.Phone:SetValidKeys({s.KeyUp,s.KeyDown,s.KeyLeft,s.KeyRight,s.KeyEnter,s.KeyBack,s.KeyContext})
		self:Init()
	else
		self:Close()
	end
end


function APP:OnClose()
	local s = self.Phone.Settings.System
	net.Start("arcphone_phone_settings")
	net.WriteUInt(self.Phone.Settings.Personalization.PhoneCase,4)
	net.WriteUInt(s.KeyUp,8)
	net.SendToServer()
	self.Phone:SetValidKeys({s.KeyUp,s.KeyDown,s.KeyLeft,s.KeyRight,s.KeyEnter,s.KeyBack,s.KeyContext})
	self:SaveData()
end

ARCPhone.RegisterApp(APP,"settings")
