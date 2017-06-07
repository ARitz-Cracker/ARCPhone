-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.

-- TODO: STOP MESSING WITH APP.Tiles and do the stuff properly!!
local APP = ARCPhone.NewAppObject()
APP.Name = "Camera"
APP.Author = "ARitz Cracker"
APP.Purpose = "Camera ARCPhone"
APP.FlatIconName = "camera"
APP.Selfie = false

function APP:PhoneStart()

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
		local dist = 20
		local leeway =  ply:GetAimVector() * 5
		if self.Selfie then
			dist = 30
			local ang = ply:EyeAngles()
			ang:RotateAroundAxis( ang:Up(), 180 )
			self.RT:SetAngles(ang)
		else
			self.RT:SetAngles(ply:EyeAngles())
		end
		local tr = util.QuickTrace( ply:EyePos(), ply:GetAimVector() * dist, ply )
		self.RT:SetPos(tr.HitPos-leeway)
	end
end

function APP:SwitchCamera()
	self.Selfie = !self.Selfie
end
--tile.App
function APP:OnRestore()
	self.RT:Enable()
	--[[
	self.RT:SetFunc2D(function()
		GAMEMODE:HUDPaint()
	end)
]]
	self.Zoom = 64
end
function APP:OnMinimize()
	self.RT:Disable()
end

function APP:ScanQRCode()
	self.Phone:SetLoading(-1)
	local DHTML = vgui.Create( "DHTML", frame )
	DHTML:SetSize( 1, 1 )
	DHTML:OpenURL( "asset://garrysmod/data/qr_decode/index.html" )
	DHTML:AddFunction( "console", "luadecode", function( err, str )
		DHTML:Remove()
		self.Phone:SetLoading(-2)
		if (err) then
			self.Phone:AddMsgBox("QRCode",err,"warning-sign")
		else
			if (string.StartWith( str, "https://" ) or string.StartWith( str, "http://" ) ) then
				self.Phone:AddMsgBox("URL QR Code","Would you like to go to the following URL?\n"..str,"help-round-button",ARCPHONE_MSGBOX_YESNO,function()
					gui.OpenURL( str )
				end,rfunc)
			elseif string.StartWith( string.lower(str), "tel:" ) then
				local num = string.sub(str,5)
				self.Phone:AddMsgBox("Call QR Code","Would you like to call the following phone number?\n"..num,"help-round-button",ARCPHONE_MSGBOX_YESNO,function()
					self.Phone:Call(num)
				end,rfunc)
			elseif string.StartWith( string.lower(str), "smsto:" ) then
				local seperator = string.find( str, ":", 7, true )
				local num = string.sub(str,7,seperator-1)
				local msg = string.sub(str,seperator+1)
				self.Phone:AddMsgBox("SMS QR Code","Would you like to open a text message conversation with the following phone number?\n"..num,"help-round-button",ARCPHONE_MSGBOX_YESNO,function()
					ARCPhone.PhoneSys:OpenApp("messaging"):OpenConvo(num,msg)
				end,rfunc)
			else
				self.Phone:AddMsgBox("QRCode",str)
			end
		end
	end )

	DHTML:AddFunction( "console", "luaready", function()
		self.RT:Capture("png",nil,function(data)
			file.Write("qr_decode/qrimg.png",data)
			--DHTML:RunJavascript( "dec(\"data:image/png;base64,"..ARCLib.basexx.to_base64(data).."\")")
			DHTML:RunJavascript( "dec(\"asset://garrysmod/data/qr_decode/qrimg.png\")")
		end)

	end )


end

function APP:Init()
	local ply = LocalPlayer()
	self.Tiles[1] = ARCPhone.NewAppTile(self)
	self.Tiles[1].ID = 1
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
	if !IsValid(self.RT) then
		self.RT = ARCLib.CreateRenderTarget("arcphone_camera",ScrH()*(self.Phone.ScreenResX/self.Phone.ScreenResY),ScrH(),EyePos(),EyeAngles(),64)
	end
	self:AddMenuOption("Scan QR Code",self.ScanQRCode,self)
	self:AddMenuOption("Switch Camera",self.SwitchCamera,self)
end

function APP:OnClose()
	if IsValid(self.RT) then
		self.RT:Destroy()
		self.RT = nil
	end
	--net.Start("arcphone_switchholdtype")
	--net.WriteString("normal")
	--net.SendToServer()
end
function APP:OnBack()
	self.Phone:OpenApp("home")
	self:Close()
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
