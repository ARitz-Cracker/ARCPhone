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

function APP:SelectCategory(a)
	self.Section = a
	table.Empty(self.Tiles)
	self:ResetCurPos()
	local i = 0
	local ypos = 32
	for k,v in SortedPairs(self.Phone.Settings[a]) do
		--PrintTable(self.Phone.SettingChoices[a][v])
		if self.Phone.SettingChoices[a] && self.Phone.SettingChoices[a][k] then
			i = i + 1
			self.Tiles[i] = ARCPhone.NewAppChoiceInputTile(self)
			self.Tiles[i].x = 8
			self.Tiles[i].y = ypos
			self.Tiles[i].w = 122
			self.Tiles[i].h = 20
			self.Tiles[i].color = self.Phone.Settings.Personalization.CL_03_MainText
			self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_01_MainColour
			for i=1,#self.Phone.SettingChoices[a][k] do
				self.Tiles[i]:AddChoice(self.Phone.SettingChoices[a][k][i][1],self.Phone.SettingChoices[a][k][i][2])
			end
			ypos = ypos + 22
			self.Tiles[i].Setting = k
		elseif IsColor(v) then
			i = i + 1
			self.Tiles[i] = ARCPhone.NewAppColorInputTile(self,v,k)
			self.Tiles[i].x = 8
			self.Tiles[i].y = ypos
			self.Tiles[i].w = 122
			self.Tiles[i].h = 48
			self.Tiles[i].Setting = k
			ypos = ypos + 50
		elseif isnumber(v) then
			i = i + 1
			self.Tiles[i] = ARCPhone.NewAppNumberInputTile(self,v)
			self.Tiles[i].x = 8
			self.Tiles[i].y = ypos
			self.Tiles[i].w = 24
			self.Tiles[i].h = 30
			self.Tiles[i].Setting = k
			self.Tiles[i].color = self.Phone.Settings.Personalization.CL_03_MainText
			self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_01_MainColour
			ypos = ypos + 32
		elseif isstring(v) then
			i = i + 1
			self.Tiles[i] = ARCPhone.NewAppTextInputTile(self,v,false,122)
			self.Tiles[i].y = ypos
			self.Tiles[i].w = 122
			self.Tiles[i].x = 8
			self.Tiles[i].color = self.Phone.Settings.Personalization.CL_11_QuaternaryText
			self.Tiles[i].bgcolor = self.Phone.Settings.Personalization.CL_09_QuaternaryColour
			self.Tiles[i].SingleLine = true
			self.Tiles[i].Setting = k
			ypos = ypos + 18
		end
	end
end

function APP:Init()
	self.Section = ""
	table.Empty(self.Tiles)
	self:ResetCurPos()
	local i = 0
	for k in SortedPairs(self.Phone.Settings) do
		i = i + 1
		self.Tiles[i] = ARCPhone.NewAppTile(self)
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
			tile.App:SelectCategory(k)
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
	if #self.Section > 0 then
		for i=1,#self.Tiles-1 do
			self.Phone.Settings[self.Section][self.Tiles[i].Setting] = self.Tiles[i]:GetValue()
		end
		self:Init()
	else
		self.Phone:OpenApp("home")
	end
end


function APP:OnClose()

end

ARCPhone.RegisterApp(APP,"settings")
