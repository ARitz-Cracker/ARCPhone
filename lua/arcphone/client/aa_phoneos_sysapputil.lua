-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
function ARCPhone.PhoneSys:ChoosePhoto(func,...)
	local curapp = ARCPhone.Apps[self.ActiveApp]
	local newapp = self:OpenApp("photos")
	if (newapp) then
		newapp:AttachPhoto(curapp.sysname,func,...)
	end
end
function ARCPhone.PhoneSys:ChooseContact(func,...)
	local curapp = ARCPhone.Apps[self.ActiveApp]
	local newapp = self:OpenApp("contacts")
	if (newapp) then
		newapp:ChooseContact(curapp.sysname,func,...)
	end
end

function ARCPhone.PhoneSys:GetActiveApp()
	return ARCPhone.Apps[self.ActiveApp]
end
function ARCPhone.PhoneSys:GetApp(id)
	return ARCPhone.Apps[id]
end

function ARCPhone.PhoneSys:SetLoading(percent)
	percent = percent or -0.01
	if percent > 0 then
		self.LoadingPer = math.floor(percent*100)
	else
		self.LoadingPer = -1
	end
	self.Loading = tobool(percent > -2)
end

function ARCPhone.PhoneSys:AddMsgBox(title,txt,icon,typ,gfunc,rfunc,yfunc)
	if (!istable(self.MsgBoxs)) then return end
	self.ShowOptions = false
	local i = #self.MsgBoxs + 1
	self.MsgBoxOption = 1
	self.MsgBoxs[i] = {}
	self.MsgBoxs[i].Title = title or ""
	self.MsgBoxs[i].Text = txt or "Message Box"
	self.MsgBoxs[i].Icon = icon or "round-info-button"
	self.MsgBoxs[i].Type = typ or 1
	self.MsgBoxs[i].GreenFunc = gfunc or NULLFUNC
	self.MsgBoxs[i].RedFunc = rfunc or NULLFUNC
	self.MsgBoxs[i].YellowFunc = yfunc or NULLFUNC
end
function ARCPhone.PhoneSys:DrawHud(wep)
	local app = ARCPhone.Apps[self.ActiveApp]
	if (app && self.Booted) then
		app:DrawHUD()
	end
end

function ARCPhone.PhoneSys:TranslateFOV(wep)
	local app = ARCPhone.Apps[self.ActiveApp]
	if (app && self.Booted) then
		return app:TranslateFOV()
	end
end
function ARCPhone.PhoneSys:CloseApp(appname)
	local phonecol = self.Settings.Personalization.CL_01_MainColour
	local iconcol = self.Settings.Personalization.CL_03_MainText
	local resx = self.ScreenResX
	local resy = self.ScreenResY
	
	local app = ARCPhone.Apps[appname]
	if not app then return end
	
	local drawFunc = function()
		cam.Start2D()
			app:Draw()
		cam.End2D()
	end
	local tex 
	if app.FlatIconName then
		tex = ARCPhone.GetIcon(app.FlatIconName)
	else
		tex = surface.GetTextureID("arcphone/appicons/"..appname)
	end
	if !app._RTScreen then
		app._RTScreen = ARCLib.CreateRenderTarget(app.sysname.."_screencam",self.ScreenResX,self.ScreenResY)
	end
	app._RTScreen:SetFunc(function()
		cam.Start2D()
			surface.SetDrawColor(ARCLib.ConvertColor(phonecol))
			surface.DrawRect( 0, 0, resx, resy )
			surface.SetDrawColor(ARCLib.ConvertColor(iconcol))
			surface.SetTexture(tex)
			surface.DrawTexturedRect( resx/2 - 32, resy/2 - 32, 64, 64 )
		cam.End2D()
		app._RTScreen:Disable()
		app._RTScreen:SetFunc(drawFunc)
	end)
	app._RTScreen:Enable()
	app:OnClose()
	app:ClearOptions()
	app:ClearScreen()
	app:ResetCurPos()
	app.Open = false
	app.MoveX = 0
	app.MoveY = 0
	app.BigTileX = 0
	app.BigTileY = 0
	
	local openApps = ARCPhone.Apps["home"].OpenApps
	table.remove( openApps, 1 )
	if self.ActiveApp == appname then
		self:OpenApp(openApps[1] or "home")
	end
end

function ARCPhone.PhoneSys:AppExists(app)
	return ARCPhone.Apps[app] != nil
end
function ARCPhone.PhoneSys:AppList()
	local homeIsActiveApp = self.ActiveApp == "home"
	self:OpenApp("home"):OpenAppsScreen(homeIsActiveApp)
end
function ARCPhone.PhoneSys:OpenApp(app,foceInit)
	if !isstring(app) || !istable(ARCPhone.Apps[app]) then
		app = tostring(app)
		self:AddMsgBox("Cannot open "..app,"App '"..app.."' is invalid or not available in this area.\n("..type(ARCPhone.Apps[app])..")","report-symbol")
	else
		--self:CloseApp(self.ActiveApp)
		local oldApp = ARCPhone.Apps[self.ActiveApp]
		self.ActiveApp = app
		local currentApp = ARCPhone.Apps[app]
		if (!currentApp.Open or foceInit) then
			currentApp.Open = true
			currentApp:Init()
		end
		oldApp:OnMinimize()
		oldApp.Foreground = false
		currentApp:OnRestore()
		currentApp.Foreground = true
		if ARCPhone.Apps["home"] and app != "home" then
			table.RemoveByValue( ARCPhone.Apps["home"].OpenApps, app)
			table.insert(ARCPhone.Apps["home"].OpenApps,1,app)
		end
		return ARCPhone.Apps[app]
	end
end