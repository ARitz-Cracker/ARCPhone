local APP = ARCPhone.NewAppObject()
APP.Name = "Camera"
APP.Author = "ARitz Cracker"
APP.Purpose = "Camera ARCPhone"
APP.FlatIconName = "camera"
APP.Selfie = false

function APP:PhoneStart()
	local ply = LocalPlayer()
	self.Tiles[1] = ARCPhone.NewAppTile(self)
	self.Tiles[1].x = 8
	self.Tiles[1].y = self.Phone.ScreenResY - 24
	self.Tiles[1].w = 122
	self.Tiles[1].h = 18
	self.Tiles[1].color = self.Phone.Settings.Personalization.CL_01_MainColour
	self.Tiles[1].drawfunc = function(tile,x,y)
		draw.SimpleText("Take Photo", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_03_MainText, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[1].OnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_02_MainPressed
	end
	self.Tiles[1].OnUnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_01_MainColour
		tile.App:TakePicture()
	end
end


function APP:TakePicture()
	local FileName = "arcphone_"..os.date("%Y-%m-%d_%H-%M-%S", os.time())
	self.Phone:EmitSound("arcphone/camera.wav")
	self.RT:Capture("jpeg",90,function(data)
		file.Write(ARCPhone.ROOTDIR.."/photos/camera/"..FileName..".photo.jpg",data)
	end)
end
function APP:ForegroundThink()
	if IsValid(self.RT) then
		local ply = LocalPlayer()
		if self.Selfie then
			local ang = ply:EyeAngles()
			ang:RotateAroundAxis( ang:Up(), 180 ) 
			self.RT:SetPos(ply:EyePos()+ply:GetAimVector() * 25)
			self.RT:SetAngles(ang)
		else
			self.RT:SetPos(ply:EyePos()+ply:GetAimVector() * 15)
			self.RT:SetAngles(ply:EyeAngles())
		end
	end
end

function APP:SwitchCamera()
	self.Selfie = !self.Selfie
end
--tile.App
function APP:Init()
	self:AddMenuOption("Swich Camera",self.SwitchCamera,self)
	if !IsValid(self.RT) then
		self.RT = ARCLib.CreateRenderTarget("arcphone_camera",ScrH()*(self.Phone.ScreenResX/self.Phone.ScreenResY),ScrH(),EyePos(),EyeAngles(),64)
	end
	self.RT:Enable()
	self.RT:SetFunc2D(function()
		--hook.Call("HUDPaint",GM)
	end)
	self.Zoom = 64
end

function APP:OnClose()
	if IsValid(self.RT) then
		self.RT:Destroy()
		self.RT = nil
	end
end
function APP:OnBack()
	self.Phone:OpenApp("home")
end

function APP:BackgroundDraw(movex,movey)
	if IsValid(self.RT) then
		local mat = self.RT:GetMaterial()
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(0,0,self.Phone.ScreenResX,self.Phone.ScreenResY) -- TODO: Do this by aspect ratio instead of stretching the image
	end
end


function APP:OnUp()
	self.Zoom = self.Zoom - 2
	if self.Zoom < 2 then
		self.Zoom = 2
	end
	if IsValid(self.RT) then
		self.RT:SetFov(self.Zoom)
	end
end
function APP:OnDown()
	self.Zoom = self.Zoom + 2
	-- default: 70
	if self.Zoom > 64 then
		self.Zoom = 64
	end
	if IsValid(self.RT) then
		self.RT:SetFov(self.Zoom)
	end
end

ARCPhone.RegisterApp(APP,"camera")
