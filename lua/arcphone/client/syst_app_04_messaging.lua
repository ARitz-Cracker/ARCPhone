
local APP = ARCPhone.NewAppObject()
APP.Name = "Messaging"
APP.Author = "ARitz Cracker"
APP.Purpose = "Messaging app for ARCPhone"

function APP:PhoneStart()
	ARCPhone.Apps["contacts"]:AddContactOption("Text",function(num)
		ARCPhone.PhoneSys:OpenApp("messaging")
		ARCPhone.Apps["messaging"]:OpenConvo(num)
	end)
end


function APP:AttachPhoto(thumb,photo)
	MsgN("APP:AttachPhoto APP="..tostring(self))
	self.Tiles[self.TextInputIcon]:SetText(self.Tiles[self.TextInputIcon]:GetText().."{{IMG:"..thumb..":"..photo..":IMG}}")
end

function APP:OpenConvo(num)
	MsgN("APP:OpenConvo APP="..tostring(self))
	self:AddMenuOption("Attach Photo",self.Phone.ChoosePhoto,self.Phone,self.AttachPhoto,self)
	self:ResetCurPos()
	self.Home = false
	local numdir = ARCPhone.ROOTDIR.."/messaging/"..num..".txt"
	local len = 0
	if file.Exists(numdir,"DATA") then
		local msgs = string.Explode( "\f", file.Read(numdir))
		len = #msgs
		for i=1,len do
			self.Tiles[i] = ARCPhone.NewAppTextInputTile(self,string.sub( msgs[i], 2),true,118)
			self.Tiles[i].Editable = false
			if i > 1 then
				self.Tiles[i].y = self.Tiles[i-1].y + self.Tiles[i-1].h + 4
			else
				self.Tiles[i].y = 24
			end
			if msgs[i][1] == "s" then
				self.Tiles[i].x = 12
				self.Tiles[i].color = Color(0,0,255,255)
			else
				self.Tiles[i].x = 4
				self.Tiles[i].color = Color(0,0,128,255)
			end
		end
	end
	len = len + 1
	self.TextInputIcon = len
	self.Tiles[len] = ARCPhone.NewAppTextInputTile(self,"Enter your message",true,118)
	if len > 1 then
		self.Tiles[len].y = self.Tiles[len-1].y + self.Tiles[len-1].h + 4
	else
		self.Tiles[len].y = 24
	end
	self.Tiles[len].w = 118
	self.Tiles[len].x = 12
	self.Tiles[len].color = Color(72,72,72,255)
	len = len + 1
	
	self.InConvo = true
	self.SendIcon = len
	self.Tiles[len] = ARCPhone.NewAppTile(self)
	self.Tiles[len].x = 12
	self.Tiles[len].y = self.Tiles[len-1].y + self.Tiles[len-1].h + 2
	self.Tiles[len].w = 118
	self.Tiles[len].h = 18
	self.Tiles[len].color = Color(75, 255, 75,255)
	self.Tiles[len].drawfunc = function(tile,x,y)
		draw.SimpleText("SEND", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[len].OnPressed = function(tile)
		tile.color = Color(75, 255, 75,128)
	end
	self.Tiles[len].OnUnPressed = function(tile)
		tile.color = Color(75, 255, 75,255)
		
		tile.App.Phone:SendText(num,tile.App.Tiles[tile.App.SendIcon-1].TextInput)
		tile.App:OpenConvo(num)
	end
end

function APP:ForegroundThink()
	if self.InConvo then
		self.Tiles[self.SendIcon].y = self.Tiles[self.SendIcon-1].y + self.Tiles[self.SendIcon-1].h + 2
	end
end

function APP:NewConvo()
	Derma_StringRequest("ARCPhone","Enter the phone number of the person you want to text","",function( text ) 
		if ARCPhone.IsValidPhoneNumber(text) then
			self:OpenConvo(text)
		else
			ARCPhone.PhoneSys:AddMsgBox("Invalid phone number","The phone number you entered was invalid","warning")
		end
	end)
end
function APP:Init()
	self:ResetCurPos()
	self.Home = true
	self.Tiles = {}
	self.InConvo = false
	self:RemoveMenuOption("Attach Photo")
	
	
	local files,_ = file.Find(ARCPhone.ROOTDIR.."/messaging/*", "DATA", "datedesc")
	--ARCPhone.Apps["contacts"].Disk
	local len = #files
	for i=1,len do
		local num = string.sub( files[i], 1, #files[i]-4 )
		local disp = ARCPhone.Apps["contacts"]:GetNameFromNumber(num)
		if disp == "Unknown" then
			disp = num
		end
		self.Tiles[i] = ARCPhone.NewAppTile(self)
		self.Tiles[i].x = 8
		self.Tiles[i].y = 10 + i*22
		self.Tiles[i].w = 122
		self.Tiles[i].h = 18
		self.Tiles[i].color = Color(0,0,255,255)
		self.Tiles[i].drawfunc = function(tile,x,y)
			draw.SimpleText(disp, "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
		end
		self.Tiles[i].OnPressed = function(tile)
			tile.color = Color(0,0,255,128)
		end
		self.Tiles[i].OnUnPressed = function(tile)
			tile.color = Color(0,0,255,255)
			tile.App:OpenConvo(num)
		end
	end
	len = len + 1
	self.Tiles[len] = ARCPhone.NewAppTile(self)
	self.Tiles[len].x = 8
	self.Tiles[len].y = 10 + len*22
	self.Tiles[len].w = 122
	self.Tiles[len].h = 18
	self.Tiles[len].color = Color(0,0,64,255)
	self.Tiles[len].drawfunc = function(tile,x,y)
		draw.SimpleText("**New Conversation**", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[len].OnPressed = function(tile)
		tile.color = Color(0,0,64,128)
	end
	self.Tiles[len].OnUnPressed = function(tile)
		tile.color = Color(0,0,64,255)
		tile.App:NewConvo()
	end
	--[[
	self.Tiles[1] = ARCPhone.NewAppTextInputTile("This is a text input tile, but it isn't editable because the Editable variable has been set to false")
	self.Tiles[1].x = 8
	self.Tiles[1].y = 154
	self.Tiles[1].w = 122
	self.Tiles[1].h = 40
	self.Tiles[1].color = Color(0,0,255,255)
	self.Tiles[1].Editable = false

	self.Tiles[2] = ARCPhone.NewAppTextInputTile("This is resizeable tile. This one is editable",true)
	self.Tiles[2].x = 8
	self.Tiles[2].y = 204
	self.Tiles[2].w = 122
	self.Tiles[2].h = 40
	self.Tiles[2].color = Color(0,0,255,255)
	]]
	
	
	
end
//APP:Init()
function APP:OnBack()
	if self.Home then
		self.Phone:OpenApp("home")
	else
		self:Init();
	end
end
ARCPhone.RegisterApp(APP,"messaging")
