
function ARCPhone.PhoneSys:ColourInput(tile)
	self.ColourInputTile = tile
	tile.SelectedColour = 1
	--hook.Add("PlayerBindPress", "ARCPhone Block Movement", BockInput)
end
--Let's try something different: (where self is the PhoneSys)



local funcs = {}
funcs[KEY_LEFT]=function(self)
	if self.ColourInputTile.SelectedColour > 1 then
		self.ColourInputTile.SelectedColour = self.ColourInputTile.SelectedColour - 1
	end
end
funcs[KEY_RIGHT]=function(self)
	if self.ColourInputTile.SelectedColour < 4 then
		self.ColourInputTile.SelectedColour = self.ColourInputTile.SelectedColour + 1
	end
end
funcs[KEY_UP]=function(self)
	self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] = self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] + 0.1
	if self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] > 0.9 then --Gotta love floats!
		self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] = 1
	end
	self.ColourInputTile.color[self.ColourInputTile._colortab[self.ColourInputTile.SelectedColour]] = self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] * 255
end
funcs[KEY_DOWN]=function(self)
	self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] = self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] - 0.1
	if self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] < 0.1 then --Gotta love floats!
		self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] = 0
	end
	self.ColourInputTile.color[self.ColourInputTile._colortab[self.ColourInputTile.SelectedColour]] = self.ColourInputTile._colortabvals[self.ColourInputTile.SelectedColour] * 255
end

function ARCPhone.PhoneSys:ColourInputFunc(key)
	if funcs[key] then
		funcs[key](self)
	end
end