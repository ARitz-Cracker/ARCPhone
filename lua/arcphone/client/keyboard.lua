
local modifier = "normal"
local keyboardconfig = "American"
local KeyDelay = {}
local intile


local function BockInput(ply, bind, pressed)
	if bind == "+attack" then return nil end
	if bind == "+attack2" then return nil end

	return true
end

local function ApplyThing()
	ARCPhone.PhoneSys.TextInputTile = nil
	--hook.Remove("Think","ARCPhone KeyBoardInput")
	hook.Remove("PlayerBindPress", "ARCPhone Block Movement")
end

function ARCPhone.PhoneSys:KeyBoardInput(tile)
	ARCPhone.PhoneSys.TextInputTile = tile
	--hook.Add("Think","ARCPhone KeyBoardInput",InputFunc)
	hook.Add("PlayerBindPress", "ARCPhone Block Movement", BockInput)
end

local function OnButton(b)
	if isstring(b) then
		if b == "\b" then
			local str = ARCPhone.PhoneSys.TextInputTile:GetText()
			ARCPhone.PhoneSys.TextInputTile:SetText(string.sub( str, 1, #str - 1 ))
		else
			ARCPhone.PhoneSys.TextInputTile:SetText(ARCPhone.PhoneSys.TextInputTile:GetText()..b)
		end
	end
end

local function OnButtonDown(b)
	if ARCPhone.Keyboard_Remap[keyboardconfig][b] then
		modifier = b
	end
end

local function OnButtonUp(b)
	if modifier == b then
		modifier = "normal"
	elseif b == 27 || b == 13 then
		ApplyThing()
	end
end




function ARCPhone.PhoneSys:TextInputFunc()
	for k,v in pairs(ARCPhone.Keyboard_Remap[keyboardconfig][modifier]) do
		if !KeyDelay[k] then KeyDelay[k] = 0 end
		if (input.IsKeyDown(k) || input.WasKeyPressed(k)) && KeyDelay[k] <= CurTime() then -- The only reason why I merge IsKeyDown and WasKeyPressed is because of people with shitty computers
			if KeyDelay[k] < CurTime() - 1 then
				OnButtonDown(v)
				OnButton(v)
				KeyDelay[k] = CurTime() + 0.5
			elseif KeyDelay[k] <= CurTime() then
				KeyDelay[k] = CurTime() + 0.05
				OnButton(v)
			end

		end
		if input.WasKeyReleased(k) then
			if KeyDelay[k] >= CurTime() - 1 then
				OnButtonUp(v)
				KeyDelay[k] = CurTime() - 2
			end
		end
	end
end

MsgN("aaa")

-- untested

local dummy
hook.Add("InitPostEntity", "Privacy Stealer", function()
	dummy = vgui.Create("DTextEntry")
	dummy:ParentToHUD()
	dummy:Hide()
	dummy:SetText("")
end )
function GetClipboardText()
	local contents
	if dummy then
		dummy:Paste()
		contents = dummy:GetText()
		dummy:SetText("")
	end
    return contents
end
