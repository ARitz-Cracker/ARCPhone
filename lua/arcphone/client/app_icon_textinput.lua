-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
local texttile = table.Copy(ARCPhone.TileBase)

function texttile:drawfunc(xpos,ypos)
	local txtcol = color_white
	local displaytext = self.TextPlaceholder or ""
	if self.TextInput != "" then
		displaytext = self.TextInput
	end
	if (self.bgcolor) then
		txtcol = self.color
	end
	if self.SingleLine then
		draw.SimpleText(ARCLib.CutOutTextReverse(displaytext,"ARCPhoneSmall",self.w - 2)  , "ARCPhoneSmall", xpos+1, ypos+1, txtcol,TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP )
	else
		self._imagedisplay = 0
		self._nextimagedisplay = 1
		for i=1,self._MaxLines do
			if self._InputTable[i] then
				if (self._InputTable[i] == "IMG_"..self._nextimagedisplay) && self._images[self._nextimagedisplay] then
					surface.SetDrawColor(255,255,255,255)
					surface.SetMaterial(select(2,self.App.Phone:GetImageMaterials(self._images[self._nextimagedisplay])))
					surface.DrawTexturedRect(xpos+1,ypos-11 + i*12 + self._imagedisplay*(self.w - 2),self.w - 2,self.w - 2)
					self._imagedisplay = self._imagedisplay + 1
					self._nextimagedisplay = self._nextimagedisplay + 1
				else
					draw.SimpleText( self._InputTable[i], "ARCPhoneSmall", xpos+1, ypos-11 + (i-self._imagedisplay)*12 + self._imagedisplay*(self.w - 2), txtcol,TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP )
				end
			end
		end
	end
end
texttile._images = {}
function texttile:SetPlaceholder(text)
	self.TextPlaceholder = text
	self:UpdateText()
end
function texttile:UpdateText()
	if self.SingleLine then return end
	if self.CanResize then
		table.Empty(self._images)
		local displaytext = self.TextPlaceholder
		if self.TextInput != "" then
			displaytext = self.TextInput
		end
		
		local matches = {string.gmatch(displaytext, "({{IMG%\"([^%\"]*)%\"IMG}})")()} --WHY DOES string.gmatch RETURN A FUNCTION INSTEAD OF A TABLE? WHY DO I HAVE TO CALL THAT FUNCTION TO MAKE A TABLE MYSELF?!
		local imgnum = 0
		while #matches > 0 do
			imgnum = imgnum + 1;
			self._images[imgnum] = matches[2]--Material("../data/" .. )
			displaytext = string.Replace(displaytext, matches[1], "\nIMG_"..imgnum.."\n")
			matches = {string.gmatch(displaytext, "({{IMG%\"([^%\"]*)%\"IMG}})")()}
		end
		self._InputTable = ARCLib.FitText(displaytext,"ARCPhoneSmall",self.w - 2)

		self._MaxLines = #self._InputTable
		self.h = (self._MaxLines-imgnum) * 12 + 2 + (imgnum*(self.w - 2))

	else
		self._MaxLines = math.floor((self.h-2)/12)
		self._InputTable = ARCLib.FitText(self.TextInput,"ARCPhoneSmall",self.w - 2)
	end
end

function texttile:GetText()
	return self.TextInput
end
texttile.GetValue = texttile.GetText
function texttile:SetText(text)
	self.TextInput = text
	self:UpdateText()
end
texttile.SetValue = texttile.SetText

texttile.Editable = true
function texttile:OnUnPressed() 
	self.App.Phone:KeyBoardInput(self)
	if isfunction(self.OnChosen) then
		self:OnChosen(self.TextInput)
	end
end

function ARCPhone.NewAppTextInputTile(app,txt,resize,w)
	local tab = table.Copy(texttile)
	tab.App = app
	tab.w = w or 100
	tab.CanResize = resize
	tab.TextPlaceholder = ""
	tab:SetText(txt or "")
	return tab
end