
local APP = ARCPhone.NewAppObject()
APP.Name = "Phone Dialer"
APP.Author = "ARitz Cracker"
APP.Purpose = "Calling screen for ARCPhone"
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
function APP:Init()
	if ARCPhone.PhoneSys.Status == ARCPHONE_ERROR_CALL_RUNNING || ARCPhone.PhoneSys.Status == ARCPHONE_ERROR_DIALING then
		ARCPhone.PhoneSys:OpenApp("callscreen")
		return
	end
	self.Tiles = {}
	self.Dialnum = ""
	for i = 0,14 do
		self.Tiles[i] = ARCPhone.NewAppTile(self)
		self.Tiles[i].x = ((i%3)*42) + 8
		self.Tiles[i].y = math.floor(i/3)*28 + 64
		self.Tiles[i].w = 38
		self.Tiles[i].h = 24
		self.Tiles[i].color = Color(0,0,128,255)
		self.Tiles[i].OnPressed = function(tile)
			tile.color = Color(0,0,128,128)
		end
		self.Tiles[i].OnUnPressed = function(tile)
			tile.color = Color(0,0,128,255)
			tile.App:AddNumber(i-2)
		end
		if i > 1 && i < 12 then

			self.Tiles[i].drawfunc = function(tile,x,y)
				draw.SimpleText( i-2, "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
			end
		end
	end
	self.Tiles[2].drawfunc = function(tile,x,y)
		draw.SimpleText( "<[x]", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[1].drawfunc = function(tile,x,y)
		draw.SimpleText( "$", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[0].drawfunc = function(tile,x,y)
		draw.SimpleText( "$", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[12].drawfunc = function(tile,x,y)
		draw.SimpleText( "*", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[13].drawfunc = function(tile,x,y)
		draw.SimpleText( "0", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[14].drawfunc = function(tile,x,y)
		draw.SimpleText( "#", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	
	self.Tiles[16] = ARCPhone.NewAppTile(self)
	self.Tiles[16].x = 8
	self.Tiles[16].y = 30
	self.Tiles[16].w = 122
	self.Tiles[16].h = 30
	self.Tiles[16].color = Color(0,0,64,255)
	self.Tiles[16].OnPressed = function(tile)
		tile.color = Color(0,0,64,128)
	end
	self.Tiles[16].OnUnPressed = function(tile)
		tile.color = Color(0,0,64,255)
	end
	self.Tiles[16].drawfunc = function(tile,x,y)
		draw.SimpleText( tile.App.Dialnum, "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	
	self.Tiles[15] = ARCPhone.NewAppTile(self)
	self.Tiles[15].x = 8
	self.Tiles[15].y = 204
	self.Tiles[15].w = 122
	self.Tiles[15].h = 30
	self.Tiles[15].color = Color(0,0,255,255)
	self.Tiles[15].OnPressed = function(tile)
		tile.color = Color(0,0,255,128)
	end
	self.Tiles[15].OnUnPressed = function(tile)
		tile.color = Color(0,0,255,255)
		tile.App.Phone:Call(tile.App.Dialnum)
	end
	self.Tiles[15].drawfunc = function(tile,x,y)
		draw.SimpleText( "Call", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
end
function APP:OnBack()
	self.Phone:OpenApp("home")
end
ARCPhone.RegisterApp(APP,"dialer")



APP = ARCPhone.NewAppObject()
APP.Name = "Call Progress"
APP.Author = "ARitz Cracker"
APP.Purpose = "Calling screen for ARCPhone"
APP.NextCheck = 0;
function APP:Init()
	self.Tiles[1] = ARCPhone.NewAppTile(self)
	self.Tiles[1].x = 8
	self.Tiles[1].y = 224
	self.Tiles[1].w = 122
	self.Tiles[1].h = 20
	self.Tiles[1].color = Color(0,0,255,255)
	self.Tiles[1].OnPressed = function(tile)
		tile.color = Color(0,0,255,128)
	end
	self.Tiles[1].OnUnPressed = function(tile)
		tile.color = Color(0,0,255,255)
		tile.App.Phone:HangUp()
		tile.App.Phone:OpenApp("dialer")
	end
	self.Tiles[1].drawfunc = function(tile,x,y)
		draw.SimpleText("End Call", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self:UpdateCallList()
end


function APP:UpdateCallList()
	for i=2,#self.Tiles do
		self.Tiles[i] = nil
	end
	
	local len = #ARCPhone.PhoneSys.CurrentCall.on
	local total = len + #ARCPhone.PhoneSys.CurrentCall.pending
	for i=2,len+1 do
		self.Tiles[i] = ARCPhone.NewAppTile(self)
		self.Tiles[i].x = 8
		self.Tiles[i].y = 10 + (i-1)*32
		self.Tiles[i].w = 122
		self.Tiles[i].h = 28
		self.Tiles[i].color = Color(0,0,255,255)
		self.Tiles[i].ContactEditable = true
		local diski = ARCPhone.Apps["contacts"]:GetDiskIDFromNumber(ARCPhone.PhoneSys.CurrentCall.on[i-1])
		--
		self.Tiles[i].drawfunc = function(tile,x,y)
			surface.SetDrawColor(255,255,255,255)
			if (ARCPhone.Apps["contacts"].ProfilePics[diski]) then
				surface.SetMaterial(ARCPhone.Apps["contacts"].ProfilePics[diski])
			else
				surface.SetMaterial(ARCPhone.Apps["contacts"].ProfilePics[0])
			end
			surface.DrawTexturedRect( x + 2, y + 2, 24, 24 )
			draw.SimpleText(ARCPhone.Apps["contacts"]:GetNameFromNumber(ARCPhone.PhoneSys.CurrentCall.on[i-1]), "ARCPhone", x + 28, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP) 
			draw.SimpleText(ARCPhone.PhoneSys.CurrentCall.on[i-1], "ARCPhone", x + 28, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM) 
		end
		--[[
		self.Tiles[i].OnPressed = function(app)
			self.Tiles[i].color = Color(0,0,255,128)
		end
		self.Tiles[i].OnUnPressed = function(app)
			self.Tiles[i].color = Color(0,0,255,255)
			ARCPhone.PhoneSys:AddMsgBox("Coming soon!","Todo: contact options screen","info")
		end
		]]
	end
	
	
	for i=len+2,total+1 do
		self.Tiles[i] = ARCPhone.NewAppTile(self)
		self.Tiles[i].x = 8
		self.Tiles[i].y = 10 + (i-1)*32
		self.Tiles[i].w = 122
		self.Tiles[i].h = 28
		self.Tiles[i].color = Color(0,0,128,255)
		self.Tiles[i].ContactEditable = true
		local diski = ARCPhone.Apps["contacts"]:GetDiskIDFromNumber(ARCPhone.PhoneSys.CurrentCall.pending[i-1-len])
		--
		self.Tiles[i].drawfunc = function(tile,x,y)
			surface.SetDrawColor(255,255,255,255)
			if (ARCPhone.Apps["contacts"].ProfilePics[diski]) then
				surface.SetMaterial(ARCPhone.Apps["contacts"].ProfilePics[diski])
			else
				surface.SetMaterial(ARCPhone.Apps["contacts"].ProfilePics[0])
			end
			surface.DrawTexturedRect( x + 2, y + 2, 24, 24 )
			draw.SimpleText(ARCPhone.Apps["contacts"]:GetNameFromNumber(ARCPhone.PhoneSys.CurrentCall.pending[i-1-len]), "ARCPhone", x + 28, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP) 
			draw.SimpleText(ARCPhone.PhoneSys.CurrentCall.pending[i-1-len], "ARCPhone", x + 28, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM) 
		end
		--[[
		self.Tiles[i].OnPressed = function(app)
			self.Tiles[i].color = Color(0,0,255,128)
		end
		self.Tiles[i].OnUnPressed = function(app)
			self.Tiles[i].color = Color(0,0,255,255)
			ARCPhone.PhoneSys:AddMsgBox("Coming soon!","Todo: contact options screen","info")
		end
		]]
	end
	--
	total = total + 1
	self.Tiles[1].y = 10 + total*32
	if (self.Tiles[1].y < 224) then
		self.Tiles[1].y = 224
	end
	if self.Tiles[self.Phone.SelectedAppTile] == nil then
		self:ResetCurPos()
	end
end
--[[
function APP:ForegroundThink()
	if self.NextCheck <= CurTime() then
		
		self.NextCheck = CurTime() + 1
	end
end
]]
function APP:OnBack()
	self.Phone:OpenApp("home")
end
ARCPhone.RegisterApp(APP,"callscreen")
