local choicetile = table.Copy(ARCPhone.TileBase)
choicetile._choiceinput = true
choicetile.ChoiceKeys = {}
choicetile.ChoiceVals = {}
choicetile.SelectedChoice = 1
choicetile.AnimStart = 0
choicetile.AnimEnd = 0
function choicetile:drawfunc(xpos,ypos)
	local txtcol
	if (!self.bgcolor) then
		txtcol = color_white
	else
		txtcol = self.color
	end
	
	self.multiplier = ARCLib.BetweenNumberScaleReverse(self.AnimStart,CurTime(),self.AnimEnd)^2
	if self.App.Phone.ChoiceInputTile == self then
		self.multiplier = (self.multiplier - 1)*-1
	end
	if self.multiplier <= 0 then
		draw.SimpleText( ARCLib.CutOutText(self.ChoiceKeys[self.SelectedChoice],"ARCPhone",self.w-4), "ARCPhone", xpos+2, ypos+self.h*0.5, txtcol, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) 
	end
end

function choicetile:drawfunc2(xpos,ypos)

	if self.multiplier > 0 then
		multiplierrev = (self.multiplier - 1)*-1
		
		local size = #self.ChoiceKeys * 14
		local ystartpos = (self.App.Phone.ScreenResY/2 - size/2) * self.multiplier + ypos*multiplierrev
		
		local textypos = {}
		for i = 1,#self.ChoiceKeys do
			textypos[i] = ( ystartpos + ((i-1)*16) ) * self.multiplier + (ypos+(self.h/2 - 6))*multiplierrev
		end
		
		surface.SetDrawColor(ARCLib.ConvertColor(self.App.Phone.Settings.Personalization.CL_14_ContextMenuMain))
		surface.DrawRect( xpos, textypos[1], self.w, textypos[#textypos] - textypos[1] + 16 )

		for i = 1,#self.ChoiceKeys do
			if self.SelectedChoice != i then
				draw.SimpleText( ARCLib.CutOutText(self.ChoiceKeys[i],"ARCPhone",self.w-4), "ARCPhone", xpos + 2, textypos[i], Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
			end
			
		end
		--local textypos = ( ystartpos + ((self.SelectedChoice-1)*14) ) * multiplier + (ypos+(self.h/2 - 6))*multiplierrev
		surface.SetDrawColor(ARCLib.ConvertColor(self.App.Phone.Settings.Personalization.CL_15_ContextMenuSelect))
		surface.DrawRect( xpos, ( ystartpos + ((self.SelectedChoice-1)*16) ) * self.multiplier + (ypos)*multiplierrev, self.w, 16*self.multiplier + self.h*multiplierrev)
		draw.SimpleText( ARCLib.CutOutText(self.ChoiceKeys[self.SelectedChoice],"ARCPhone",self.w-2), "ARCPhone", xpos + 2, textypos[self.SelectedChoice], Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
		
		surface.SetDrawColor(ARCLib.ConvertColor(self.App.Phone.Settings.Personalization.CL_16_ContextMenuBorder))
		surface.DrawOutlinedRect( xpos, textypos[1], self.w, textypos[#textypos] - textypos[1] + 16  )
	end
end

function choicetile:AddChoice(key,val)
	local i = #self.ChoiceKeys + 1 
	self.ChoiceKeys[i] = tostring(key)
	self.ChoiceVals[i] = val
end

function choicetile:RemoveChoice(key)
	if isstring(key) then
		for i=1,#self.ChoiceKeys do
			if self.ChoiceKeys[i] == key then
				key = i
				break
			end
		end
	elseif !isnumber(key) then
		key = #self.ChoiceKeys
	end
	table.remove( self.ChoiceKeys, key) 
	table.remove( self.ChoiceVals, key) 
end

function choicetile:GetChoiceName()
	return self.ChoiceKeys[self.SelectedChoice]
end

function choicetile:GetChoice()
	return self.ChoiceVals[self.SelectedChoice]
end

choicetile.GetValue = choicetile.GetChoice

function choicetile:OnUnPressed() 
	self.App.Phone:ChoiceInput(self)
end

function ARCPhone.NewAppChoiceInputTile(app)
	local tab = table.Copy(choicetile)
	tab.App = app
	return tab
end
