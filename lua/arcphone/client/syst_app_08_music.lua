-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2017 Aritz Beobide-Cardinal All rights reserved.

-- TODO: STOP MESSING WITH APP.Tiles and do the stuff properly!!
local APP = ARCPhone.NewAppObject()
APP.Name = "Music"
APP.Author = "ARitz Cracker"
APP.Purpose = "Play MP3 URLs"
APP.Hidden = true
APP.FlatIconName = "play-button-inside-a-circle"
APP.VisualizeTab = {}
local VisTileDraw = function(tile,x,y)
	if not IsValid(tile.App.PlayingSong) then return end
	surface.SetDrawColor(ARCLib.ConvertColor(tile.App.Phone.Settings.Personalization.CL_03_MainText))
	local len = tile.App.PlayingSong:FFT( tile.App.VisualizeTab, FFT_256 )
	for i=1,len do
		local h = (tile.h-2)*tile.App.VisualizeTab[i]
		surface.DrawRect( x+i, y-h+tile.h, 1, h ) 
	end
end

local PlayTileDraw = function(tile,x,y)
	draw.SimpleText("Play URL", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, tile.App.Phone.Settings.Personalization.CL_03_MainText, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
end

	

function APP:Init()
	self.VisTile = self:CreateNewTile(5,20,130,32)
	self.VisTile.drawfunc = VisTileDraw
	self.VisTile.color = self.Phone.Settings.Personalization.CL_01_MainColour
	
	self.URLTile = self:CreateNewTileTextInput(5,54,130,14,"",false)
	self.URLTile:SetPlaceholder("Enter MP3 URL")
	self.URLTile:SetValue("https://www.aritzcracker.ca/random_shit/music/Drunk%20Girl/Drunk%20Girl%20-%20Don't%20Stop%20The%20Party%20(Feat.%20Deanna).mp3")
	self.URLTile.SingleLine = true
	self.URLTile.color = self.Phone.Settings.Personalization.CL_09_QuaternaryColour
	
	self.OpenTile = self:CreateNewTile(8+10,200,122-20,24)
	self.OpenTile.color = self.Phone.Settings.Personalization.CL_01_MainColour
	self.OpenTile.drawfunc = PlayTileDraw
	self.OpenTile.OnPressed = function(tile)
		tile.color = tile.App.Phone.Settings.Personalization.CL_02_MainPressed
	end
	self.OpenTile.OnUnPressed = function(tile)
		tile.color = tile.App.Phone.Settings.Personalization.CL_01_MainColour
		tile.App:PlayURL(tile.App.URLTile:GetValue())
	end
	
end

function APP:PlayURL(url)
	self.URLTile:SetValue(url)
	self.Phone:SetLoading(-1)
	ARCLib.PlayCachedURL( url , "noblock", function( station,errid,errstr )
		if not self.Open then return end
		self.Phone:SetLoading(-2)
		if IsValid(self.PlayingSong) then
			self.PlayingSong:Stop()
		end
		if ( IsValid( station ) ) then
			self.PlayingSong = station
			self.PlayingSong:SetPos(LocalPlayer():GetPos() )
			self.PlayingSong:Play()
			self.PlayingSong:SetVolume(0.25)
		else
			ARCPhone.PhoneSys:AddMsgBox("Music","Failed to play music\n("..tostring(errid)..") "..tostring(errstr),"round-error-symbol")
		end
	end)
end

function APP:OnBack()
	self:Close()
end


function APP:OnClose()
	if IsValid(self.PlayingSong) then
		self.PlayingSong:Stop()
	end
end

ARCPhone.RegisterApp(APP,"music")
