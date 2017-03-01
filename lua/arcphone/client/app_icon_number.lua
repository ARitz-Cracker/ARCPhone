-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
local texttile = table.Copy(ARCPhone.TileBase)

texttile._NumberInput = true
texttile.Increment = 1
texttile.Decimals = 0
texttile.Min = 0
texttile.Max = 10

function texttile:SetMax(num)
	self.Max = tonumber(num) or 0
end

function texttile:SetMin(num)
	self.Min = tonumber(num) or 0
end

function texttile:SetDecimals(num)
	texttile.Decimals = tonumber(num) or 0
end

function texttile:SetIncrement(num)
	texttile.Increment = tonumber(num) or 0
end

local polytab = {}
polytab[1] = {}
polytab[2] = {}
polytab[3] = {}
local polytab2 = {}
polytab2[1] = {}
polytab2[2] = {}
polytab2[3] = {}

function texttile:drawfunc(xpos,ypos)
	local txtcol = color_white
	if (self.bgcolor) then
		txtcol = self.color
	end
	draw.SimpleText(ARCLib.CutOutText(self.TextInput,"ARCPhoneSmall",self.w - 2), "ARCPhoneSmall", xpos+self.w*0.5, ypos+self.h*0.5, txtcol,TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
	
	if self.App.Phone.TextInputTile == self then
		if math.sin(CurTime()*math.pi*2) > 0 then
			surface.SetDrawColor(ARCLib.ConvertColor(ARCLib.ColorNegative(txtcol)))
		else
			surface.SetDrawColor(ARCLib.ConvertColor(txtcol))
		end
	else
		surface.SetDrawColor(ARCLib.ConvertColor(txtcol))
	end
	draw.NoTexture()
	polytab[1].x = self.x + self.w/2
	polytab[1].y = self.y + self.h - 6
	polytab[2].x = self.x + 2
	polytab[2].y = self.y + self.h/2 + 3
	polytab[3].x = self.x + self.w - 2
	polytab[3].y = self.y + self.h/2 + 3
	surface.DrawPoly(polytab)
	draw.NoTexture()
	polytab2[1].x = self.x + self.w/2
	polytab2[1].y = self.y + 0
	polytab2[2].x = self.x + self.w - 2
	polytab2[2].y = self.y + self.h/2 - 9
	polytab2[3].x = self.x + 2
	polytab2[3].y = self.y + self.h/2 - 9
	surface.DrawPoly(polytab2)
	
	surface.SetDrawColor(ARCLib.ConvertColor(txtcol))
	surface.DrawLine(polytab[1].x,polytab[1].y,polytab[2].x,polytab[2].y)
	surface.DrawLine(polytab[2].x,polytab[2].y,polytab[3].x,polytab[3].y)
	surface.DrawLine(polytab[3].x,polytab[3].y,polytab[1].x,polytab[1].y)
	surface.DrawLine(polytab2[1].x,polytab2[1].y,polytab2[2].x,polytab2[2].y)
	surface.DrawLine(polytab2[2].x,polytab2[2].y,polytab2[3].x,polytab2[3].y)
	surface.DrawLine(polytab2[3].x,polytab2[3].y,polytab2[1].x,polytab2[1].y)
	
end

function texttile:GetText()
	return self.TextInput
end
function texttile:GetNumber()
	return tonumber(self.TextInput)
end
texttile.GetValue = texttile.GetNumber
function texttile:SetText(text)
	self.TextInput = tostring(math.Clamp(math.Round(tonumber(text) or self.Min,self.Decimals),self.Min,self.Max))
end
texttile.SetNumber = texttile.SetText
texttile.SetValue = texttile.SetText

texttile.Editable = true
function texttile:OnUnPressed() 
	self.App.Phone:KeyBoardInput(self)
end

function ARCPhone.NewAppNumberInputTile(app,txt)
	local tab = table.Copy(texttile)
	tab.App = app
	tab:SetText(txt or "0")
	return tab
end