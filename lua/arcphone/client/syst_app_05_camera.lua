local APP = ARCPhone.NewAppObject()
APP.Name = "Camera"
APP.Author = "ARitz Cracker"
APP.Purpose = "Camera ARCPhone"
APP.FlatIconName = "camera"
--APP.FoneWidth = 903 -- 1.996677740863787

--APP.FoneHight = 1803 -- 0.5008319467554077


APP.FoneXPos = (ScrW()/2) - ScrH()*0.135 -- Positions that align with the phone's "Camera" animation
APP.FoneYPos = (ScrH()/2) - ScrH()*0.326 -- Positions that align with the phone's "Camera" animation
APP.FoneHight = ScrH()*0.659 -- Positions that align with the phone's "Camera" animation
APP.FoneWidth = APP.FoneHight * 0.5008319467554077

APP.CameraOn = false
APP.CameraStage = 0
function APP:PhoneStart()
	self.CameraStage = 0
	self.Mat = ARCLib.MaterialFromTxt(ARCPhone.ROOTDIR.."/camera/phone_0.dat","png")
	self.Tiles[1] = ARCPhone.NewAppTile(self)
	self.Tiles[1].x = 8
	self.Tiles[1].y = 32
	self.Tiles[1].w = 122
	self.Tiles[1].h = 18
	self.Tiles[1].color = self.Phone.Settings.Personalization.CL_01_MainColour
	self.Tiles[1].drawfunc = function(tile,x,y)
		draw.SimpleText("Enable Camera", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_03_MainText, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[1].OnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_02_MainPressed
	end
	self.Tiles[1].OnUnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_01_MainColour
		if (tile.App.CameraOn) then
			tile.App:TakePicture()
		else
			tile.App:EnableCamera()
			--tile.App.Phone.Ent.ViewModelFOV = 1
		end
	end
	
	self.Tiles[2] = ARCPhone.NewAppTile(self)
	self.Tiles[2].x = 8
	self.Tiles[2].y = 52
	self.Tiles[2].w = 122
	self.Tiles[2].h = 18
	self.Tiles[2].color = self.Phone.Settings.Personalization.CL_01_MainColour
	self.Tiles[2].drawfunc = function(tile,x,y)
		draw.SimpleText("Selfie Camera", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_03_MainText, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[2].OnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_02_MainPressed
	end
	self.Tiles[2].OnUnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_01_MainColour
		tile.App.Phone:AddMsgBox("Coming soon!","This feature has not been implemented yet, it will be available in a later version of ARCPhone","info")
	end
	
end

function APP:EnableCamera()
	self.CameraOn = true
	self.DisableTileSwitching = true
	self.DisableViewModel = true
	self.CameraStage = -1
end

function APP:TakePicture()
	if self.CameraOn && self.CameraStage == 0 then
		self.CameraStage = 1
		self.PicFileName = "arcphone_"..os.date("%Y-%m-%d_%H-%M-%S", os.time())
		self.Phone:EmitSound("arcphone/camera.wav")
	end

end

function APP:ForegroundThink()
	if self.CameraStage == -1 then
		self.CameraStage = 0 -- TODO: Replace with transition animation
	
	elseif self.CameraStage == 2 then
		file.Write(ARCPhone.ROOTDIR.."/photos/camera/"..self.PicFileName..".thumb.dat", render.Capture {
			x = self.FoneXPos - 129,
			y = self.ScreenYPos+1,
			h = 128,
			w = 128,
			quality = 90,
			format = "jpeg"
		})
		self.CameraStage = 0
		self.ThumbMat = nil
	elseif self.CameraStage == 1 then
		file.Write(ARCPhone.ROOTDIR.."/photos/camera/"..self.PicFileName..".photo.dat", render.Capture {
			x = self.ScreenXPos+1,
			y = self.ScreenYPos+1,
			h = self.ScreenHight-2,
			w = self.ScreenWidth-2,
			quality = 90,
			format = "jpeg"
			
		})
		self.ThumbMat = ARCLib.MaterialFromTxt(ARCPhone.ROOTDIR.."/photos/camera/"..self.PicFileName..".photo.dat","jpg")
		self.CameraStage = self.CameraStage + 1
	end
end

--tile.App
function APP:Init()
	self.Zoom = 90
	self.FoneHight = ScrH()
	self.FoneWidth = self.FoneHight * 0.5008319467554077
	
	self.FoneXPos = ScrW()/2 - self.FoneWidth/2
	self.FoneYPos = 0
	
	
	self.ScreenXPos = math.ceil(self.FoneXPos + self.FoneWidth*0.05)
	self.ScreenYPos = math.ceil(self.FoneYPos + self.FoneHight*0.05)
	self.ScreenHight = math.floor(self.FoneHight - self.FoneHight*0.184)
	self.ScreenWidth = math.floor(self.FoneWidth - self.FoneWidth*0.104)
	
	--  2
	--1   4
	--  3
	self.BoxX = {0,self.ScreenXPos,self.ScreenXPos,self.ScreenXPos+self.ScreenWidth}
	self.BoxY = {0,0,self.ScreenHight+self.ScreenYPos,0}
	self.BoxH = {ScrH(),self.ScreenYPos,ScrH()-self.ScreenHight-self.ScreenYPos,ScrH()}
	self.BoxW = {self.ScreenXPos,self.ScreenWidth,self.ScreenWidth,ScrW()-self.ScreenXPos-self.ScreenWidth}
	
	

	
end
function APP:DrawHUD()
	if self.CameraOn && self.Mat && self.CameraStage >= 0 then
		surface.SetDrawColor(0,0,0,255)
		for i=1,4 do
			surface.DrawRect(self.BoxX[i],self.BoxY[i],math.ceil(self.BoxW[i]),math.ceil(self.BoxH[i]))
		end
		surface.SetDrawColor(255,255,255,255)
		surface.DrawOutlinedRect(self.ScreenXPos,self.ScreenYPos,self.ScreenWidth,self.ScreenHight)
		
		surface.SetMaterial(self.Mat)
		surface.DrawTexturedRect(self.FoneXPos,self.FoneYPos,self.FoneWidth,self.FoneHight)
		draw.SimpleText("ENTER = Take Photo" , "ARCPhoneHudText", self.ScreenXPos + self.FoneWidth,self.ScreenYPos, color_white, TEXT_ALIGN_LEFT  , TEXT_ALIGN_TOP)
		draw.SimpleText("BACKSPACE = Exit" , "ARCPhoneHudText", self.ScreenXPos + self.FoneWidth,self.ScreenYPos + 32, color_white, TEXT_ALIGN_LEFT  , TEXT_ALIGN_TOP)
		draw.SimpleText("UP/DOWN = Zoom" , "ARCPhoneHudText", self.ScreenXPos + self.FoneWidth,self.ScreenYPos + 64, color_white, TEXT_ALIGN_LEFT  , TEXT_ALIGN_TOP)
		
		
		if self.ThumbMat then
			surface.DrawOutlinedRect(self.FoneXPos - 130,self.ScreenYPos,130,130)
		
			surface.SetMaterial(self.ThumbMat)
			surface.DrawTexturedRect(self.FoneXPos - 97,self.ScreenYPos+1,64,128)
		end
	end
end

function APP:OnClose()
	--self.Phone.Ent.ViewModelFOV = 56
end
function APP:OnBack()
	if self.CameraOn then
		self.CameraOn = false
		self.DisableTileSwitching = false
		self.DisableViewModel = false
	else
		self.Phone:OpenApp("home")
	end
end

function APP:TranslateFOV()
	if self.CameraOn then
		return self.Zoom
	end
end

function APP:OnUp()
	if self.CameraOn then
		self.Zoom = self.Zoom - 2
		if self.Zoom < 2 then
			self.Zoom = 2
		end
	end
end
function APP:OnDown()
	if self.CameraOn then
		self.Zoom = self.Zoom + 2
		-- default: 70
		if self.Zoom > 90 then
			self.Zoom = 90
		end
	end
end

ARCPhone.RegisterApp(APP,"camera")
