local APP = ARCPhone.NewAppObject()
APP.Name = "Settings"
APP.Author = "ARitz Cracker"
APP.Purpose = "Something I put off until the last minute"
APP.FlatIconName = "settings"

--[[
function APP:PhoneStart()

end
]]
--tile.App
APP.Photos = {}
function APP:Init()
	self.Section = ""
	table.Empty(self.Tiles)
	
	self.Tiles[1] = ARCPhone.NewAppColorInputTile(self,Color(0,25,100,255),"Testing 123")
	self.Tiles[1].x = 8
	self.Tiles[1].y = 32
	self.Tiles[1].w = 122
	self.Tiles[1].h = 48
	self.Tiles[1].color = self.Phone.Settings.Personalization.CL_01_MainColour
	
	self.Tiles[2] = ARCPhone.NewAppColorInputTile(self,Color(0,25,100,255),"Testing 123")
	self.Tiles[2].x = 8
	self.Tiles[2].y = 82
	self.Tiles[2].w = 122
	self.Tiles[2].h = 48
	self.Tiles[2].color = self.Phone.Settings.Personalization.CL_01_MainColour
	
end

function APP:OnBack()
	if #self.Section > 0 then
		self:Init()
	else
		self.Phone:OpenApp("home")
	end
end


function APP:OnClose()

end

ARCPhone.RegisterApp(APP,"settings")
