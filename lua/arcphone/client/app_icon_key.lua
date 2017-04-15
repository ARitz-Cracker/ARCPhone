-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
local texttile = table.Copy(ARCPhone.TileBase)

texttile._KeyInput = true
texttile.KeyStr = "KEY_NONE"
texttile.Key = KEY_NONE
function texttile:drawfunc(xpos,ypos)
	local txtcol = color_white
	if (self.bgcolor) then
		txtcol = self.color
	end
	draw.SimpleText(ARCLib.CutOutText(self.KeyStr,"ARCPhoneSmall",self.w - 2), "ARCPhoneSmall", xpos+self.w*0.5, ypos+self.h*0.5, txtcol,TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
end

function texttile:GetNumber()
	return tonumber(self.Key)
end
texttile.GetValue = texttile.GetNumber
function texttile:SetNumber(text)
	self.Key = text
	self.KeyStr = "KEY_"..ARCLib.HumanReadableKey(text)
end
texttile.SetValue = texttile.SetNumber

texttile.Editable = true
function texttile:OnUnPressed() 
	if self._Selected then
		self._Selected = false
		return
	end
	self.App.Phone:KeyBoardInput(self)
end

function ARCPhone.NewAppKeyInputTile(app,txt)
	local tab = table.Copy(texttile)
	tab.App = app
	tab:SetValue(tonumber(txt) or 0)
	return tab
end