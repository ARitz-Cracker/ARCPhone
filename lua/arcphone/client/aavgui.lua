-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.


ARCPhone.FlatIcons64 = {}
for k, v in pairs(file.Find( "materials/icon_google_material_design/*.vmt", "GAME" )) do
	ARCPhone.FlatIcons64[string.sub(v,1,-5)] = surface.GetTextureID("icon_google_material_design/"..string.Replace(v,".vmt",""))
end


function ARCPhone.GetIcon(name)
	return ARCPhone.FlatIcons64[name] or ARCPhone.FlatIcons64["user-account-box-1"] or 1337 -- ¯\_(ツ)_/¯
end

surface.CreateFont( "ARCPhoneSBig", {
	font = "Arial",
	size = 28,
	weight = 200,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "ARCPhoneBig", {
	font = "Arial",
	size = 24,
	weight = 200,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "ARCPhoneBigish", {
	font = "Arial",
	size = 18,
	weight = 200,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "ARCPhone", {
	font = "Arial",
	size = 14,
	weight = 200,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "ARCPhoneSmall", {
	font = "Arial",
	size = 12,
	weight = 200,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )
surface.CreateFont( "ARCPhoneSSmall", {
	font = "Arial",
	size = 10,
	weight = 200,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

surface.CreateFont( "ARCPhoneHudText", {
	font = "Arial",
	size = 30,
	weight = 120,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true
} )