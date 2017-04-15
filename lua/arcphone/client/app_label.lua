-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
ARCPhone.LabelBase = {}
ARCPhone.LabelBase.label = true
ARCPhone.LabelBase.Texts = {--[[{ text, font, x, y, color, xAlign, yAlign}]]}
ARCPhone.LabelBase.x = 48
ARCPhone.LabelBase.y = 48
ARCPhone.LabelBase.w = 16
ARCPhone.LabelBase.h = 16
ARCPhone.LabelBase.color = color_white
ARCPhone.LabelBase.bgcolor = color_black
ARCPhone.LabelBase.text = ""
function ARCPhone.NewAppLabel(app,x,y,w,h,tex,font,color,bgcolor,xAlign,yAlign)
	color = ARCLib.ValidVariable(color,ARCLib.IsColor(color),color_white)
	bgcolor = ARCLib.ValidVariable(bgcolor,ARCLib.IsColor(bgcolor),color_white)
	font = ARCLib.ValidVariable(font,isstring(font),"ARCPhone")
	xAlign = ARCLib.ValidVariable(xAlign,isnumber(xAlign),TEXT_ALIGN_LEFT)
	yAlign = ARCLib.ValidVariable(yAlign,isnumber(yAlign),TEXT_ALIGN_BOTTOM)
	assert(isstring(tex),"ARCPhone.NewAppLabel: Bad argument #6 string expected, got "..type(tex))
	assert(isnumber(h),"ARCPhone.NewAppLabel: Bad argument #5 number expected, got "..type(h))
	assert(isnumber(w),"ARCPhone.NewAppLabel: Bad argument #4 number expected, got "..type(w))
	assert(isnumber(y),"ARCPhone.NewAppLabel: Bad argument #3 number expected, got "..type(y))
	assert(isnumber(x),"ARCPhone.NewAppLabel: Bad argument #2 number expected, got "..type(x))
	local tab = table.Copy(ARCPhone.LabelBase)
	tab.App = app
	tab.color = color
	tab.bgcolor = bgcolor
	surface.SetFont(font)
	local tw, th = surface.GetTextSize( tex )
	if w <= 0 then
		tab.h = ARCLib.ValidVariable(h,h>0,th)
		tab.w = tw
		tab.Texts[1] = {x=x,y=y,args={tex,font,x,y,tab.color,xAlign,yAlign}}
	else
		tab.w = w
		local texttab = ARCLib.FitText(text,font,w)
		tab.h = ARCLib.ValidVariable(h,h>0,#texttab*th)
		local len = math.floor(tab.h/th)
		if len > #texttab then
			len = #texttab
		end
		for i=1,len do
			tab.Texts[i] = {x=x,y=0,args={tex,font,x,0,tab.color,xAlign,yAlign}}
			if yAlign == TEXT_ALIGN_BOTTOM then
				tab.Texts[i].y = y
			elseif yAlign == TEXT_ALIGN_TOP then
				tab.Texts[i].y = y - (i-1)*th
			elseif yAlign == TEXT_ALIGN_CENTER then
				tab.Texts[i].y = y - th/2 + (i-1)*th
			end
		end
	end
	
	if xAlign == TEXT_ALIGN_LEFT then
		tab.x = x
	elseif xAlign == TEXT_ALIGN_RIGHT then
		tab.x = x - tab.w
	elseif xAlign == TEXT_ALIGN_CENTER then
		tab.x = x - tab.w/2
	end
	if yAlign == TEXT_ALIGN_BOTTOM then
		tab.y = y
	elseif yAlign == TEXT_ALIGN_TOP then
		tab.y = y - tab.h
	elseif yAlign == TEXT_ALIGN_CENTER then
		tab.y = y - tab.h/2
	end
	return tab
end
function ARCPhone.LabelBase:Remove()
	self.App.Labels[self.ID] = nil
end