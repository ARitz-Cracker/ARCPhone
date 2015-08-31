local APP = ARCPhone.NewAppObject()
APP.Name = "Photos"
APP.Author = "ARitz Cracker"
APP.Purpose = "Photo viewer for ARCPhone!"
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
	table.Empty(self.Tiles)
	
	self.Tiles[1] = ARCPhone.NewAppTile(self)
	self.Tiles[1].x = 8
	self.Tiles[1].y = 32
	self.Tiles[1].w = 122
	self.Tiles[1].h = 18
	self.Tiles[1].color = Color(0,0,255,255)
	self.Tiles[1].drawfunc = function(tile,x,y)
		draw.SimpleText("Camera Roll", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[1].OnPressed = function(tile)
		tile.color = Color(0,0,255,128)
	end
	self.Tiles[1].OnUnPressed = function(tile)
		tile.color = Color(0,0,255,255)
		tile.App:ListPhotos("camera")
	end
	
	self.Tiles[2] = ARCPhone.NewAppTile(self)
	self.Tiles[2].x = 8
	self.Tiles[2].y = 54
	self.Tiles[2].w = 122
	self.Tiles[2].h = 18
	self.Tiles[2].color = Color(0,0,255,255)
	self.Tiles[2].drawfunc = function(tile,x,y)
		draw.SimpleText("Received Photos", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[2].OnPressed = function(tile)
		tile.color = Color(0,0,255,128)
	end
	self.Tiles[2].OnUnPressed = function(tile)
		tile.color = Color(0,0,255,255)
		tile.App:ListPhotos("texts")
	end
	
	self.Tiles[3] = ARCPhone.NewAppTile(self)
	self.Tiles[3].x = 8
	self.Tiles[3].y = 76
	self.Tiles[3].w = 122
	self.Tiles[3].h = 18
	self.Tiles[3].color = Color(0,0,255,255)
	self.Tiles[3].drawfunc = function(tile,x,y)
		draw.SimpleText("Saved Photos", "ARCPhone", x+tile.w*0.5, y+tile.h*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
	end
	self.Tiles[3].OnPressed = function(tile)
		tile.color = Color(0,0,255,128)
	end
	self.Tiles[3].OnUnPressed = function(tile)
		tile.color = Color(0,0,255,255)
		tile.App:ListPhotos("saved")
	end
	
end

function APP:ListPhotos(dir)
	
	local files, directories = file.Find( ARCPhone.ROOTDIR.."/photos/"..dir.."/*.photo.dat", "DATA" )
	if #files == 0 then
		self.Phone:AddMsgBox("Empty","There aren't any photos here!","warning")
		return
	end
	table.Empty(self.Tiles)
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
		local thumbimg = ARCPhone.ROOTDIR.."/photos/"..dir.."/"..string.sub( files[i], 1, #files[i]-10 )..".thumb.dat"
		if file.Exists(thumbimg,"DATA") then
			self.Tiles[i].mat = ARCLib.MaterialFromTxt(thumbimg,"jpg")
		else
			MsgN("ARCPhone: Warning! "..thumbimg.." doesn't exist! This may cause FPS drop because reasons.")
			self.Tiles[i].mat = ARCLib.MaterialFromTxt(ARCPhone.ROOTDIR.."/photos/"..dir.."/"..files[i],"jpg")
		end
	end
	self.Photos = files
	self.CurrentDir = dir
end

function APP:OnBack()
	if #self.CurrentDir > 0 then
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

function APP:SelectPhoto(i)
	assert(self.CurrentDir && #self.CurrentDir > 0,"Attempted to select photo when CurrentDir isn't set!")
	assert(isnumber(i),"Bad photo selected! Wanted number got nil!")
	assert(self.Photos[i],"Photos[i] is nil!")
	if self.AttachFunc then
		local thumbimg = ARCPhone.ROOTDIR.."/photos/"..self.CurrentDir.."/"..string.sub( self.Photos[i], 1, #self.Photos[i]-10 )..".thumb.dat"
		if file.Exists(thumbimg,"DATA") then
			self.AttachFunc(unpack(self.AttachFuncArgs),thumbimg,ARCPhone.ROOTDIR.."/photos/"..self.CurrentDir.."/"..self.Photos[i])
		else
			MsgN("ARCPhone: Warning! "..thumbimg.." doesn't exist! This may cause FPS drop because reasons.")
			thumbimg = ARCPhone.ROOTDIR.."/photos/"..self.CurrentDir.."/"..self.Photos[i]
			self.AttachFunc(unpack(self.AttachFuncArgs),thumbimg,thumbimg)
		end
		self.Phone:OpenApp(self.AttachFuncApp,true,false)
	end
end

ARCPhone.RegisterApp(APP,"photos")
