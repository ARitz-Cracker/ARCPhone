-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
local textbox

--[[
local function BockInput(ply, bind, pressed)
	if bind == "+attack" then return nil end
	if bind == "+attack2" then return nil end

	return true
end
]]
local function ApplyThing()
		local t = ARCPhone.PhoneSys.TextInputTile
		
		if t then
			t._Selected = true
			if isfunction(t.OnDeselect) then
				t:OnDeselect()
			end
		end
		--timer.Simple(0.1,function()
		ARCPhone.PhoneSys.TextInputTile = nil
		--end)
		textbox:Remove()
		
	--hook.Remove("PlayerBindPress", "ARCPhone Block Movement")
end

local function KeyPressed(panel,key)
	local s = ARCPhone.PhoneSys.Settings.System
	if !textbox:HasFocus() then
		textbox:RequestFocus()
	end
	if ARCPhone.PhoneSys.TextInputTile._KeyInput then
		ARCPhone.PhoneSys.TextInputTile:SetValue(key)
		ApplyThing()
		return true
	end
	if (ARCLib.IsCTRLDown()) then
		if key == KEY_A then return true end
		if key == KEY_C then
			SetClipboardText(ARCPhone.PhoneSys.TextInputTile:GetText())
			chat.AddText( "Text copied!" ) 
			return true
		end
		if key == KEY_X then
			SetClipboardText(ARCPhone.PhoneSys.TextInputTile:GetText())
			if ARCPhone.PhoneSys.TextInputTile.Editable then
				ARCPhone.PhoneSys.TextInputTile:SetText("")
			end
			chat.AddText( "Text copied!" )
			return true
		end
	end
	if key == s.KeyUp then
		if ARCPhone.PhoneSys.TextInputTile._NumberInput then
			ARCPhone.PhoneSys.TextInputTile.TextInput = tostring(math.Clamp(math.Round(tonumber(ARCPhone.PhoneSys.TextInputTile.TextInput) + ARCPhone.PhoneSys.TextInputTile.Increment, ARCPhone.PhoneSys.TextInputTile.Decimals),ARCPhone.PhoneSys.TextInputTile.Min,ARCPhone.PhoneSys.TextInputTile.Max))
		else
			return true
		end
	elseif key == s.KeyDown then
		if ARCPhone.PhoneSys.TextInputTile._NumberInput then
			ARCPhone.PhoneSys.TextInputTile.TextInput = tostring(math.Clamp(math.Round(tonumber(ARCPhone.PhoneSys.TextInputTile.TextInput) - ARCPhone.PhoneSys.TextInputTile.Increment, ARCPhone.PhoneSys.TextInputTile.Decimals),ARCPhone.PhoneSys.TextInputTile.Min,ARCPhone.PhoneSys.TextInputTile.Max))
		else
			return true
		end
	elseif key == s.KeyLeft || key == s.KeyRight then 
		return true
	elseif key == KEY_ENTER  then
		if ((key != s.KeyEnter or input.IsKeyDown( KEY_LSHIFT) or input.IsKeyDown( KEY_RSHIFT) ) and ARCPhone.PhoneSys.TextInputTile.Editable ) then
			ARCPhone.PhoneSys.TextInputTile:SetText(ARCPhone.PhoneSys.TextInputTile:GetText().."\n")
		elseif key == s.KeyEnter then
			ApplyThing()
		end
	elseif key == s.KeyEnter then
		ApplyThing()
	end
end

local basestr = "LOL:"
local basestrlen = #basestr

local function OnTextChanged(panel)
	--MsgN("OnTextChanged")
	if !ARCPhone.PhoneSys.TextInputTile.Editable  then return end
	local txt = textbox:GetText()
	--textbox:SelectAllText()
	local str = ARCPhone.PhoneSys.TextInputTile:GetText()
	if #txt > basestrlen then
		ARCPhone.PhoneSys.TextInputTile:SetText(str..string.sub(txt,5))
		textbox:SetText(basestr)
		textbox:SetCaretPos(basestrlen) 
	elseif #txt < basestrlen then
		ARCPhone.PhoneSys.TextInputTile:SetText(string.sub( str, 1, #str - (4 - #txt) ))
		textbox:SetText(basestr)
		textbox:SetCaretPos(4) 
	end
end

function ARCPhone.PhoneSys:KeyBoardInput(tile)
	self.TextInputTile = tile
	if !tile.Editable then
		chat.AddText( "This is a read-only text box. This means that you can only copy text from here" )
	end
	textbox = vgui.Create("DTextEntry")
	textbox:SetText(basestr)
	textbox:MakePopup()
	textbox:SetCaretPos(basestrlen) 
	textbox:SetSize(1,1)
	textbox.OnKeyCodeTyped = KeyPressed
	textbox.OnChange = OnTextChanged
	--hook.Add("PlayerBindPress", "ARCPhone Block Movement", BockInput)
end
