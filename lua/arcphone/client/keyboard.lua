
local textbox

--[[
local function BockInput(ply, bind, pressed)
	if bind == "+attack" then return nil end
	if bind == "+attack2" then return nil end

	return true
end
]]
local function ApplyThing()
		timer.Simple(0.1,function()
			ARCPhone.PhoneSys.TextInputTile = nil
		end)
		textbox:Remove()
	--hook.Remove("PlayerBindPress", "ARCPhone Block Movement")
end

local function KeyPressed(tile,key)
	MsgN("KeyPressed")
	if (input.IsKeyDown( KEY_LCONTROL ) || input.IsKeyDown( KEY_RCONTROL ) ) then
		if key == KEY_A then return true end
		if key == KEY_C then
			SetClipboardText(ARCPhone.PhoneSys.TextInputTile:GetText())
			chat.AddText( "Text copied!" ) 
			return true
		end
		if key == KEY_X then
			ARCPhone.PhoneSys.TextInputTile:SetText("")
			SetClipboardText(ARCPhone.PhoneSys.TextInputTile:GetText())
			chat.AddText( "Text copied!" )
			return true
		end
	end
	if key == KEY_LEFT || key == KEY_UP || key == KEY_DOWN || key == KEY_RIGHT then return true end
	if key == KEY_ENTER then
		if (input.IsKeyDown( KEY_LSHIFT) || input.IsKeyDown( KEY_RSHIFT) ) then
			ARCPhone.PhoneSys.TextInputTile:SetText(ARCPhone.PhoneSys.TextInputTile:GetText().."\n")
		else
			ApplyThing()
		end
	end
end

local function OnTextChanged(tile)
	MsgN("OnTextChanged")
	local txt = textbox:GetText()
	--textbox:SelectAllText()
	if !textbox:HasFocus() then
		textbox:RequestFocus()
	end
	local str = ARCPhone.PhoneSys.TextInputTile:GetText()
	if #txt > 4 then
		ARCPhone.PhoneSys.TextInputTile:SetText(str..string.sub(txt,5))
		textbox:SetText("LOL:")
		textbox:SetCaretPos(4) 
	elseif #txt < 4 then
		ARCPhone.PhoneSys.TextInputTile:SetText(string.sub( str, 1, #str - (4 - #txt) ))
		textbox:SetText("LOL:")
		textbox:SetCaretPos(4) 
	end
	
end

function ARCPhone.PhoneSys:KeyBoardInput(tile)
	self.TextInputTile = tile
	textbox = vgui.Create("DTextEntry")
	textbox:SetText("LOL:")
	textbox:MakePopup()
	textbox:SetCaretPos(4) 
	textbox:SetSize(1,1)
	textbox.OnKeyCodeTyped = KeyPressed
	textbox.OnChange = OnTextChanged
	--hook.Add("PlayerBindPress", "ARCPhone Block Movement", BockInput)
end




function ARCPhone.PhoneSys:TextInputFunc()
	if !IsValid(textbox) then return end

	
end
