-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
function ARCPhone.PhoneSys:ColourInput(tile)
	self.ColourInputTile = tile
	tile.SelectedColour = 1
	--hook.Add("PlayerBindPress", "ARCPhone Block Movement", BockInput)
end
--Let's try something different: (where self is the PhoneSys)

function ARCPhone.PhoneSys:ColourInputFunc(key)
	local s = self.Settings.System
	if key == s.KeyUp then
		self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] = self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] + 0.1
		if self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] > 0.9 then --Gotta love floats!
			self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] = 1
		end
		self.ColourInputTile.color[self.ColourInputTile._colortab[self.ColourInputTile.SelectedColour]] = self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] * 255
	elseif key == s.KeyDown then
		self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] = self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] - 0.1
		if self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] < 0.1 then --Gotta love floats!
			self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] = 0
		end
		self.ColourInputTile.color[self.ColourInputTile._colortab[self.ColourInputTile.SelectedColour]] = self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] * 255
	elseif key == s.KeyLeft then
		if self.ColourInputTile.SelectedColour > 1 then
			self.ColourInputTile.SelectedColour = self.ColourInputTile.SelectedColour - 1
		end
	elseif key == s.KeyRight then
		if self.ColourInputTile.SelectedColour < 4 then
			self.ColourInputTile.SelectedColour = self.ColourInputTile.SelectedColour + 1
		end
	end
end