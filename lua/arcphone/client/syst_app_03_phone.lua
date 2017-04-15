-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.

-- TODO: STOP MESSING WITH APP.Tiles and do the stuff properly!!
local APP = ARCPhone.NewAppObject()
APP.Name = "Call"
APP.Author = "ARitz Cracker"
APP.Purpose = "Call menu"
APP.FlatIconName = "phone-call-button"

function APP:AddNumber(num)
	if num < 10 && num > 0 then
		self.Dialnum = self.Dialnum..num
	elseif num == 10 then
		self.Dialnum = self.Dialnum.."*"
	elseif num == 11 then
		self.Dialnum = self.Dialnum.."0"
	elseif num == 12 then
		self.Dialnum = self.Dialnum.."#"
	elseif num == 0 then
		self.Dialnum = string.Left( self.Dialnum, #self.Dialnum -1 )
	end
end
function APP:PhoneStart()
	ARCPhone.Apps["contacts"]:AddContactOption("Call",self.Phone.Call,self.Phone)
	ARCPhone.Apps["contacts"]:AddContactOption("Add to call",self.Phone.AddToCall,self.Phone)
end

function APP:UpdateCallList()
	if not self.Phone.CallPending and self.Phone.Status == ARCPHONE_ERROR_CALL_ENDED then
		self:Init()
		return
	end
	for i=2,#self.Tiles do
		self.Tiles[i] = nil
	end
	if self.Phone.CallPending then
		-- "Connecting please wait"??
		--print("Phone app - call is connecting")
		return
	end
	--print("listing calls...")
	local len = #self.Phone.CurrentCall.on
	local total = len + #self.Phone.CurrentCall.pending
	for i=2,len+1 do
		self.Tiles[i] = ARCPhone.NewAppTile(self)
		self.Tiles[i].ID = i
		self.Tiles[i].x = 8
		
		self.Tiles[i].y = 10 + (i-1)*32
		--print("Incall "..i.." "..self.Tiles[i].y)
		self.Tiles[i].w = 122
		self.Tiles[i].h = 28
		self.Tiles[i].color = self.Phone.Settings.Personalization.CL_01_MainColour 
		self.Tiles[i].ContactEditable = true
		local diski = ARCPhone.Apps["contacts"]:GetDiskIDFromNumber(self.Phone.CurrentCall.on[i-1])
		--
		self.Tiles[i].drawfunc = function(tile,x,y)
			surface.SetDrawColor(255,255,255,255)
			if (ARCPhone.Apps["contacts"].ProfilePics[diski]) then
				surface.SetMaterial(ARCPhone.Apps["contacts"].ProfilePics[diski])
			else
				surface.SetMaterial(ARCPhone.Apps["contacts"].ProfilePics[0])
			end
			surface.DrawTexturedRect( x + 2, y + 2, 24, 24 )
			draw.SimpleText(ARCPhone.Apps["contacts"]:GetNameFromNumber(self.Phone.CurrentCall.on[i-1]), "ARCPhone", x + 28, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_03_MainText, TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM) 
			draw.SimpleText(self.Phone.CurrentCall.on[i-1], "ARCPhone", x + 28, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_03_MainText, TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP) 
		end
		--[[
		self.Tiles[i].OnPressed = function(app)
			self.Tiles[i].color = Color(0,0,255,128)
		end
		self.Tiles[i].OnUnPressed = function(app)
			self.Tiles[i].color = Color(0,0,255,255)
			self.Phone:AddMsgBox("Coming soon!","Todo: contact options screen","info")
		end
		]]
	end
	
	
	for i=len+2,total+1 do
		self.Tiles[i] = ARCPhone.NewAppTile(self)
		self.Tiles[i].ID = i
		self.Tiles[i].x = 8
		self.Tiles[i].y = 10 + (i-1)*32
		--print("Pending "..i.." "..self.Tiles[i].y)
		self.Tiles[i].w = 122
		self.Tiles[i].h = 28
		self.Tiles[i].color = self.Phone.Settings.Personalization.CL_03_SecondaryColour
		self.Tiles[i].ContactEditable = true
		local diski = ARCPhone.Apps["contacts"]:GetDiskIDFromNumber(self.Phone.CurrentCall.pending[i-1-len])
		--
		self.Tiles[i].drawfunc = function(tile,x,y)
			surface.SetDrawColor(255,255,255,255)
			if (ARCPhone.Apps["contacts"].ProfilePics[diski]) then
				surface.SetMaterial(ARCPhone.Apps["contacts"].ProfilePics[diski])
			else
				surface.SetMaterial(ARCPhone.Apps["contacts"].ProfilePics[0])
			end
			surface.DrawTexturedRect( x + 2, y + 2, 24, 24 )
			draw.SimpleText(ARCPhone.Apps["contacts"]:GetNameFromNumber(self.Phone.CurrentCall.pending[i-1-len]), "ARCPhone", x + 28, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_05_SecondaryText, TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM) 
			draw.SimpleText(self.Phone.CurrentCall.pending[i-1-len], "ARCPhone", x + 28, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_05_SecondaryText, TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP) 
		end
		--[[
		self.Tiles[i].OnPressed = function(app)
			self.Tiles[i].color = Color(0,0,255,128)
		end
		self.Tiles[i].OnUnPressed = function(app)
			self.Tiles[i].color = Color(0,0,255,255)
			self.Phone:AddMsgBox("Coming soon!","Todo: contact options screen","info")
		end
		]]
	end
	--
	total = total + 1
	self.Tiles[1].y = 10 + total*32
	if (self.Tiles[1].y < 224) then
		self.Tiles[1].y = 224
	end
	if self:GetSelectedTile() == nil then
		self:ResetCurPos()
	end
end
function APP:CallScreen()
	table.Empty(self.Tiles)
	self.InCallScreen = true
	self.Tiles[1] = ARCPhone.NewAppTile(self)
	self.Tiles[1].ID = 1
	self.Tiles[1].x = 8
	self.Tiles[1].y = 224
	self.Tiles[1].w = 122
	self.Tiles[1].h = 20
	self.Tiles[1].color = self.Phone.Settings.Personalization.CL_01_MainColour 
	self.Tiles[1].OnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_02_MainPressed 
	end
	self.Tiles[1].OnUnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_01_MainColour 
		tile.App.Phone:HangUp()
	end
	self.Tiles[1].drawfunc = function(tile,x,y)
		draw.SimpleText("End Call", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_03_MainText , TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self:UpdateCallList()
end
function APP:ForegroundThink()
	if not self.InCallScreen and (self.Phone.Status == ARCPHONE_ERROR_CALL_RUNNING or self.Phone.Status == ARCPHONE_ERROR_DIALING) then
		self:CallScreen()
	end
end
function APP:Init()
	self.InCallScreen = false
	self.Tiles = {}
	self.Dialnum = ""
	for i = 0,14 do
		self.Tiles[i] = ARCPhone.NewAppTile(self)
		self.Tiles[i].ID = i
		self.Tiles[i].x = ((i%3)*42) + 8
		self.Tiles[i].y = math.floor(i/3)*28 + 64
		self.Tiles[i].w = 38
		self.Tiles[i].h = 24
		self.Tiles[i].color = self.Phone.Settings.Personalization.CL_03_SecondaryColour
		self.Tiles[i].OnPressed = function(tile)
			tile.color = self.Phone.Settings.Personalization.CL_03_SecondaryColour
		end
		self.Tiles[i].OnUnPressed = function(tile)
			tile.color = self.Phone.Settings.Personalization.CL_03_SecondaryColour
			tile.App:AddNumber(i-2)
		end
		if i > 1 && i < 12 then

			self.Tiles[i].drawfunc = function(tile,x,y)
				draw.SimpleText( i-2, "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_05_SecondaryText, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
			end
		end
	end
	self.Tiles[2].drawfunc = function(tile,x,y)
		draw.SimpleText( "<[x]", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_05_SecondaryText, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[1].drawfunc = function(tile,x,y)
		draw.SimpleText( "$", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_05_SecondaryText, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[0].drawfunc = function(tile,x,y)
		draw.SimpleText( "$", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_05_SecondaryText, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[12].drawfunc = function(tile,x,y)
		draw.SimpleText( "*", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_05_SecondaryText, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[13].drawfunc = function(tile,x,y)
		draw.SimpleText( "0", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_05_SecondaryText, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[14].drawfunc = function(tile,x,y)
		draw.SimpleText( "#", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_05_SecondaryText, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	
	self.Tiles[16] = ARCPhone.NewAppTile(self)
	self.Tiles[16].ID = 16
	self.Tiles[16].x = 8
	self.Tiles[16].y = 30
	self.Tiles[16].w = 122
	self.Tiles[16].h = 30
	self.Tiles[16].color = self.Phone.Settings.Personalization.CL_06_TertiaryColour
	self.Tiles[16].OnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_07_TertiaryPressed
	end
	self.Tiles[16].OnUnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_06_TertiaryColour
	end
	self.Tiles[16].drawfunc = function(tile,x,y)
		draw.SimpleText( tile.App.Dialnum, "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_08_TertiaryText, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	
	self.Tiles[15] = ARCPhone.NewAppTile(self)
	self.Tiles[15].ID = 15
	self.Tiles[15].x = 8
	self.Tiles[15].y = 204
	self.Tiles[15].w = 122
	self.Tiles[15].h = 30
	self.Tiles[15].color = self.Phone.Settings.Personalization.CL_01_MainColour 
	self.Tiles[15].OnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_02_MainPressed 
	end
	self.Tiles[15].OnUnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_01_MainColour 
		tile.App.Phone:Call(tile.App.Dialnum)
	end
	self.Tiles[15].drawfunc = function(tile,x,y)
		draw.SimpleText( "Call", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_03_MainText , TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
end
function APP:OnBack()
	self:Close()
end
ARCPhone.RegisterApp(APP,"dialer")
