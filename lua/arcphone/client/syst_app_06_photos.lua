local APP = ARCPhone.NewAppObject()
APP.Name = "Photos"
APP.Author = "ARitz Cracker"
APP.Purpose = "Photo viewer for ARCPhone!"
APP.FlatIconName = "images"

--[[
function APP:PhoneStart()
	self.Tiles[1] = ARCPhone.NewAppTile(self)
	self.Tiles[1].x = 8
	self.Tiles[1].y = 32
	self.Tiles[1].w = 122
	self.Tiles[1].h = 18
	self.Tiles[1].color = Color(0,0,255,255)
	self.Tiles[1].drawfunc = function(tile,x,y)
		draw.SimpleText("Enable Camera", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[1].OnPressed = function(tile)
		tile.color = Color(0,0,255,128)
	end
	self.Tiles[1].OnUnPressed = function(tile)
		tile.color = Color(0,0,255,255)
		if (tile.App.CameraOn) then
			if (tile.App.CameraStage == 0) then
				tile.App:TakePicture()
			end
		else
			tile.App.CameraOn = true
			tile.App.DisableTileSwitching = true
			tile.App.DisableViewModel = true
			--tile.App.Phone.Ent.ViewModelFOV = 1
		end
	end
	
	self.Tiles[2] = ARCPhone.NewAppTile(self)
	self.Tiles[2].x = 8
	self.Tiles[2].y = 52
	self.Tiles[2].w = 122
	self.Tiles[2].h = 18
	self.Tiles[2].color = Color(0,0,255,255)
	self.Tiles[2].drawfunc = function(tile,x,y)
		draw.SimpleText("Selfie Camera", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[2].OnPressed = function(tile)
		tile.color = Color(0,0,255,128)
	end
	self.Tiles[2].OnUnPressed = function(tile)
		tile.color = Color(0,0,255,255)
		tile.App.Phone:AddMsgBox("Coming soon!","This feature has not been implemented yet, it will be available in a later version of ARCPhone","info")
	end
	
end
]]
--tile.App
APP.Photos = {}
function APP:Init()
	self.CurrentDir = ""
	self:ClearScreen()
	self.Tiles[1] = ARCPhone.NewAppTile(self)
	self.Tiles[1].x = 8
	self.Tiles[1].y = 32
	self.Tiles[1].w = 122
	self.Tiles[1].h = 18
	self.Tiles[1].color = self.Phone.Settings.Personalization.CL_01_MainColour
	self.Tiles[1].drawfunc = function(tile,x,y)
		draw.SimpleText("Camera Roll", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_03_MainText, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[1].OnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_02_MainPressed
	end
	self.Tiles[1].OnUnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_01_MainColour
		tile.App:ListPhotos("camera")
	end
	
	self.Tiles[2] = ARCPhone.NewAppTile(self)
	self.Tiles[2].x = 8
	self.Tiles[2].y = 54
	self.Tiles[2].w = 122
	self.Tiles[2].h = 18
	self.Tiles[2].color = self.Phone.Settings.Personalization.CL_01_MainColour
	self.Tiles[2].drawfunc = function(tile,x,y)
		draw.SimpleText("Received Photos", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_03_MainText, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[2].OnPressed = function(tile)
		tile.color = Color(0,0,255,128)
	end
	self.Tiles[2].OnUnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_01_MainColour
		tile.App:ListPhotos("texts")
	end
	
	self.Tiles[3] = ARCPhone.NewAppTile(self)
	self.Tiles[3].x = 8
	self.Tiles[3].y = 76
	self.Tiles[3].w = 122
	self.Tiles[3].h = 18
	self.Tiles[3].color = self.Phone.Settings.Personalization.CL_01_MainColour
	self.Tiles[3].drawfunc = function(tile,x,y)
		draw.SimpleText("Saved Photos", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_03_MainText, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[3].OnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_02_MainPressed
	end
	self.Tiles[3].OnUnPressed = function(tile)
		tile.color = self.Phone.Settings.Personalization.CL_01_MainColour
		tile.App:ListPhotos("saved")
	end
	
end

local function photoTileDrawFunc(tile,x,y)
	surface.SetMaterial(select(2,tile.App.Phone:GetImageMaterials(tile.Photo)))
	surface.DrawTexturedRect(x,y,tile.w,tile.h)
	
end
function APP:ListPhotos(dir)
	
	local files, directories = file.Find( ARCPhone.ROOTDIR.."/photos/"..dir.."/*.photo.jpg", "DATA" )
	if #files == 0 then
		self.Phone:AddMsgBox("Empty","There aren't any photos here!","warning")
		return
	end
	self:ClearScreen()
	for i=1,#files do
		self.Tiles[i] = ARCPhone.NewAppTile(self)
		self.Tiles[i].x = 4 + (43*((i-1)%3))
		--MsgN(i.." "..self.Tiles[i].x)
		self.Tiles[i].y = 28 + 43*(math.floor((i-1)/3))
		self.Tiles[i].w = 40
		self.Tiles[i].h = 40
		self.Tiles[i].bgcolor = Color(0,0,0,255)
		self.Tiles[i].color = Color(255,255,255,255)
		self.Tiles[i].TextureNoresize = true
		--[[
		self.Tiles[i].drawfunc = function(tile,x,y)
			draw.SimpleTextOutlined(i, "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, color_white, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,color_black) 
		end
		]]
		self.Tiles[i].OnPressed = function(tile)
			tile.color = Color(255,255,255,128)
		end
		self.Tiles[i].OnUnPressed = function(tile)
			tile.color = Color(255,255,255,255)
			tile.App:SelectPhoto(i)
		end
		self.Tiles[i].drawfunc = photoTileDrawFunc
		self.Tiles[i].Photo = dir.."/"..files[i]
	end
	self.Photos = files
	self.CurrentDir = dir
	self:SetCurPos(#files)
end

function APP:OnBack()
	if self.ViewImage then
		self.ViewImage = nil
		self.DisableTileSwitching = false
	elseif #self.CurrentDir > 0 then
		self:Init()
	else
		if self.AttachFunc then
			self.Phone:OpenApp(self.AttachFuncApp,true,false)
		else
			self.Phone:OpenApp("home")
		end
	end
end

function APP:AttachPhoto(app,func,...)
	self.AttachFunc = func
	self.AttachFuncArgs = {...}
	for i=1,#self.AttachFuncArgs do
		MsgN("i => "..tostring(self.AttachFuncArgs[i]))
	end
	self.AttachFuncApp = app
end

function APP:OnClose()
	self.AttachFunc = nil
	self.AttachFuncArgs = nil
	self.AttachFuncApp = nil
end

function APP:ForegroundDraw(movex,movey)
	if self.ViewImage then
		surface.SetDrawColor(0,0,0,255)
		surface.DrawRect(0,0,self.Phone.ScreenResX,self.Phone.ScreenResY)
	
		local mat = self.ViewImage
		local w = mat:Width()
		local h = mat:Height()
		if w > h then
			h = self.Phone.ScreenResX*(h/w)
			w = self.Phone.ScreenResX
		else
			w = self.Phone.ScreenResY*(w/h)
			h = self.Phone.ScreenResY
		end
		
		local x = self.Phone.HalfScreenResX - w/2
		local y = self.Phone.HalfScreenResY - h/2
		
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(x,y,w,h)
	end
end

function APP:SelectPhoto(i)
	assert(self.CurrentDir && #self.CurrentDir > 0,"Attempted to select photo when CurrentDir isn't set!")
	assert(isnumber(i),"Bad photo selected! Wanted number got nil!")
	assert(self.Photos[i],"Photos[i] is nil!")
	local imgpath = --[[ARCPhone.ROOTDIR.."/photos/"..]]self.CurrentDir.."/"..self.Photos[i]
	if self.AttachFunc then
		self.AttachFunc(unpack(self.AttachFuncArgs),imgpath)
		self.Phone:OpenApp(self.AttachFuncApp,true,false)
	else
		self.ViewImage = self.Phone:GetImageMaterials(imgpath)
		self.DisableTileSwitching = true
	end
end

ARCPhone.RegisterApp(APP,"photos")
