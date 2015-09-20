local coltile = table.Copy(ARCPhone.TileBase)
coltile._colorinput = true
coltile._colortab = {"r","g","b","a"}
coltile._colortabvals = {0,0,0,1}
coltile._colormtab = {Color(255,0,0,255),Color(0,255,0,255),Color(0,0,255,255),Color(128,128,128,255)}
coltile.SelectedColour = 1
local polytab = {}
local polytab2 = {}
polytab[1] = {}
polytab[2] = {}
polytab[3] = {}
polytab2[1] = {}
polytab2[2] = {}
polytab2[3] = {}
function coltile:drawfunc(xpos,ypos)
	local x,y,w,h
	draw.SimpleText( self.title, "ARCPhoneSmall", xpos+1, ypos+ 1, self.txtcol,TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM )
	for i=1,4 do
		h = self.h - 14
		w = self.w/4
		x = xpos + w*(i-1)
		y = ypos + 14
		draw.SimpleText( self._colortabvals[i], "ARCPhoneSmall", x + w/2, y + h/2, self.txtcol,TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
		surface.SetDrawColor(ARCLib.ConvertColor(self._colormtab[i]))
		draw.NoTexture()
		polytab[1].x = x + w/2
		polytab[1].y = y + h - 2
		polytab[2].x = x + 2
		polytab[2].y = y + h/2 + 7
		polytab[3].x = x + w - 2
		polytab[3].y = y + h/2 + 7
		surface.DrawPoly(polytab)
		draw.NoTexture()
		polytab2[1].x = x + w/2
		polytab2[1].y = y + 2
		polytab2[2].x = x + w - 2
		polytab2[2].y = y + h/2 - 7
		polytab2[3].x = x + 2
		polytab2[3].y = y + h/2 - 7
		surface.DrawPoly(polytab2)
		
		if self.App.Phone.ColourInputTile == self && self.SelectedColour == i then
			if math.sin(CurTime()*math.pi*2) > 0 then
				surface.SetDrawColor(ARCLib.ConvertColor(color_white))
			else
				surface.SetDrawColor(ARCLib.ConvertColor(color_black))
			end
		else
			surface.SetDrawColor(ARCLib.ConvertColor(self.txtcol))
		end
		surface.DrawLine(polytab[1].x,polytab[1].y,polytab[2].x,polytab[2].y)
		surface.DrawLine(polytab[2].x,polytab[2].y,polytab[3].x,polytab[3].y)
		surface.DrawLine(polytab[3].x,polytab[3].y,polytab[1].x,polytab[1].y)
		

		surface.DrawLine(polytab2[1].x,polytab2[1].y,polytab2[2].x,polytab2[2].y)
		surface.DrawLine(polytab2[2].x,polytab2[2].y,polytab2[3].x,polytab2[3].y)
		surface.DrawLine(polytab2[3].x,polytab2[3].y,polytab2[1].x,polytab2[1].y)
		
	end
	if self.color.r + self.color.g + self.color.b > 450 then
		self.txtcol = color_black
	else
		self.txtcol = color_white
	end
end

function coltile:OnUnPressed() 
	self.App.Phone:ColourInput(self)
end
function coltile:SetColor(col) 
	if (istable(col) || IsColor(col)) then
		self.color = Color(col.r or 0,col.g or 0,col.b or 0,col.a or 255)
	end
end
function coltile:GetColor() 
	return self.color
end
coltile.GetValue = coltile.GetColor

function ARCPhone.NewAppColorInputTile(app,col,txt)
	local tab = table.Copy(coltile)
	tab.title = txt or "Select Colour"
	tab.App = app
	if (istable(col) || IsColor(col)) then
		tab.color = Color(col.r or 0,col.g or 0,col.b or 0,col.a or 255)
	else
		tab.color = Color(0,0,0,255)
	end
	for i=1,#tab._colortab do
		tab._colortabvals[i] = math.Round( tab.color[coltile._colortab[i]]/255,1)
	end
	tab.txtcol = color_white
	return tab
end
