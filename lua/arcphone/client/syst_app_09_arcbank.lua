local APP = ARCPhone.NewAppObject()
APP.Name = "ARCBank"
APP.Author = "ARitz Cracker"
APP.Purpose = "Access your ARCBank account!"
local icons_rank = {}
icons_rank[0] = "hand_fuck"
icons_rank[1] = "user"
icons_rank[2] = "medal_bronze_red"
icons_rank[3] = "medal_silver_blue"
icons_rank[4] = "medal_gold_green"
icons_rank[5] = "hand_fuck"
icons_rank[6] = "group"
icons_rank[7] = "group_add"
	
local TitleTileDraw = function(tile,x,y)
	if not tile.App.CurAccount then return end
	surface.SetDrawColor(255,255,255,255)
	surface.SetMaterial( ARCLib.GetWebIcon32(icons_rank[tile.App.CurAccount.rank]) )
	surface.DrawTexturedRect( x+2, y+4, 24, 24 )
	draw.SimpleText(tile.App.CurAccount.name, "ARCPhone", x+28,y+2, tile.App.Phone.Settings.Personalization.CL_03_MainText, TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP) 
	draw.SimpleText(tile.MoneyStr, "ARCPhone", x+28,y+16, tile.App.Phone.Settings.Personalization.CL_03_MainText, TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP) 
end

function APP:Init()
	if (not ARCLib.IsVersion("1.4.2","ARCBank")) then
		self.Phone:AddMsgBox("ARCBank","This application requires ARCBank 1.4.2 or later to be installed on the server.","report-symbol")
		self:Close()
	end
	self.CurAccount = nil
	self:ClearScreen()
	local titleTile = self:CreateNewTile(4,20,130,32)
	titleTile.text = "ARCBank app!"
	titleTile.color = self.Phone.Settings.Personalization.CL_01_MainColour
	
	local titleTile = self:CreateNewTile(10,60,120,16)
	titleTile.text = "Personal Account"
	titleTile.color = self.Phone.Settings.Personalization.CL_01_MainColour
	titleTile.OnPressed = function(tile)
		tile.color = tile.App.Phone.Settings.Personalization.CL_02_MainPressed
	end
	titleTile.OnUnPressed = function(tile)
		self:AccountProperties("")
		tile.color = tile.App.Phone.Settings.Personalization.CL_01_MainColour
	end
	
	local titleTile = self:CreateNewTile(10,80,120,16)
	titleTile.text = "Group Accounts"
	titleTile.color = self.Phone.Settings.Personalization.CL_01_MainColour
	titleTile.OnPressed = function(tile)
		tile.color = tile.App.Phone.Settings.Personalization.CL_02_MainPressed
	end
	titleTile.OnUnPressed = function(tile)
		tile.color = tile.App.Phone.Settings.Personalization.CL_01_MainColour
		tile.App.Phone.Loading = true
		ARCBank.GetAccessableAccounts(LocalPlayer(), function(errorcode, account_list)
			tile.App.Phone.Loading = false
			if errorcode ~= ARCBANK_ERROR_NONE then
				self.Phone:AddMsgBox("ARCBank Error",ARCBANK_ERRORSTRINGS[errorcode],"cancel-button")
				return
			end
			self:ClearScreen()
			local i = 0
			for _,account1 in ipairs(account_list) do
				if string.sub(account1,1,1) ~= "_" then
					i = i + 1
					local name = ARCLib.basexx.from_base32(string.upper(string.sub(account1,1,#account1-1)))
					local tile = self:CreateNewTile(10,0 + i * 20,120,16)
					tile.text = name
					tile.color = self.Phone.Settings.Personalization.CL_03_SecondaryColour
					tile.OnPressed = function(tile)
						tile.color = tile.App.Phone.Settings.Personalization.CL_04_SecondaryPressed
					end
					tile.OnUnPressed = function(tile)
						tile.color = tile.App.Phone.Settings.Personalization.CL_03_SecondaryColour
						tile.App:AccountProperties(account1)
					end
				end
			end
		end)
	end
end
function APP:ActuallySendMoney(account)
	self:ClearScreen()
	local tile = self:CreateNewTile(10,20,120,16)
	tile.text = "How much?"
	tile.color = self.Phone.Settings.Personalization.CL_01_MainColour
	
	
	local input = self:CreateNewTileNumberInput(20,40,100,30,500)
	input.color = self.Phone.Settings.Personalization.CL_05_SecondaryText
	input.bgcolor = self.Phone.Settings.Personalization.CL_03_SecondaryColour
	input:SetMax((2^32)-1)
	input:SetMin(0)
	input:SetValue(500)


	
	local tile = self:CreateNewTile(20,74,100,16)
	tile.text = "Send"
	tile.color = self.Phone.Settings.Personalization.CL_22_PopupAccept
	tile.OnUnPressed = function(tile)
		tile.App.Phone.Loading = true
		ARCBank.Transfer(tile.App.Phone.Ent, tile.App.Recipient, tile.App.CurAccount.account, account, 100, "ARCPhone Transfer", function(errorcode)
			tile.App.Phone.Loading = false
			if errorcode == ARCBANK_ERROR_NONE then
				tile.App.Phone:AddMsgBox("ARCBank",ARCBANK_ERRORSTRINGS[errorcode],"round-info-button")
			else
				tile.App.Phone:AddMsgBox("ARCBank Error",ARCBANK_ERRORSTRINGS[errorcode],"cancel-button")
			end
			tile.App:Init()
		end)
	end

end


local function onSendMoneyUnpressed(tile)
	tile.color = tile.App.Phone.Settings.Personalization.CL_03_SecondaryColour
	tile.App:ActuallySendMoney(tile.account)
end

function APP:AddPlayerToGroup(contact)
	if not self.CurAccount then return end
	local ply = ARCPhone.GetPlayerFromPhoneNumber(contact.number)
	
	local otherply
	if IsValid(ply) then
		otherply = ARCBank.GetPlayerID(ply)
		self.Disk[contact.number] = otherply
	else
		otherply = self.Disk[contact.number]
		if not otherply then
			self.Phone:AddMsgBox("Player is offline.","This player is currently offline. In order to add this person, you must have sent money to them before.","warning-sign")
			return
		end
	end
	self.Phone.Loading = true
	ARCBank.GroupAddPlayer(self.Phone.Ent, self.CurAccount.account, otherply, "ARCPhone ARCBank App", function(errorcode)
		self.Phone.Loading = false
		if errorcode == ARCBANK_ERROR_NONE then
			self.Phone:AddMsgBox("ARCBank",ARCBANK_ERRORSTRINGS[errorcode],"round-info-button")
		else
			self.Phone:AddMsgBox("ARCBank Error",ARCBANK_ERRORSTRINGS[errorcode],"cancel-button")
		end
		self:Init()
	end)
end

function APP:RemovePlayerFromGroup()
	self:ClearScreen()
	ARCBank.GroupGetPlayers(self.Phone.Ent, self.CurAccount.account, function(errorcode, group_members)
		for i=1,#group_members do
			local id = group_members[i]
			local name = ARCBank.GetPlayerByID(id):Nick()
			
			local tile = self:CreateNewTile(10,30*i,120,28)
			tile.color = self.Phone.Settings.Personalization.CL_01_MainColour
			tile.drawfunc = function(tile,x,y)
				draw.SimpleText(name, "ARCPhone", x + 2, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_03_MainText, TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM) 
				draw.SimpleText(id, "ARCPhone", x + 2, y+tile.h*0.5, self.Phone.Settings.Personalization.CL_03_MainText, TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP) 
			end
			tile.OnUnPressed = function(tile)
				ARCBank.GroupRemovePlayer(tile.App.Phone.Ent, tile.App.CurAccount.account, id, "ARCPhone ARCBank App", function(errorcode)
					self.Phone.Loading = false
					if errorcode == ARCBANK_ERROR_NONE then
						self.Phone:AddMsgBox("ARCBank",ARCBANK_ERRORSTRINGS[errorcode],"round-info-button")
					else
						self.Phone:AddMsgBox("ARCBank Error",ARCBANK_ERRORSTRINGS[errorcode],"cancel-button")
					end
					self:Init()
				end)
			end
		end

	end)
end

function APP:SendMoney(contact)
	if not self.CurAccount then return end
	local ply = ARCPhone.GetPlayerFromPhoneNumber(contact.number)
	
	if IsValid(ply) then
		self.Recipient = ARCBank.GetPlayerID(ply)
		self.Disk[contact.number] = self.Recipient
	else
		self.Recipient = self.Disk[contact.number]
		if not self.Recipient then
			self.Phone:AddMsgBox("Player is offline.","This player is currently offline. In order to send money to this person, you must have sent money to them before.","warning-sign")
			return
		end
	end
	self.Phone.Loading = true
	self:ClearScreen()
	local tile = self:CreateNewTile(10,20,120,16)
	tile.account = ""
	tile.text = "Personal Account"
	tile.color = self.Phone.Settings.Personalization.CL_03_SecondaryColour
	tile.OnPressed = function(tile)
		tile.color = tile.App.Phone.Settings.Personalization.CL_04_SecondaryPressed
	end
	tile.OnUnPressed = onSendMoneyUnpressed
	
	ARCBank.GetAccessableAccounts(self.Recipient, function(errorcode, account_list)
		tile.App.Phone.Loading = false
		if errorcode ~= ARCBANK_ERROR_NONE then
			self.Phone:AddMsgBox("ARCBank Error",ARCBANK_ERRORSTRINGS[errorcode],"cancel-button")
			return
		end
		
		local i = 0
		for _,account1 in ipairs(account_list) do
			if string.sub(account1,1,1) ~= "_" then
				i = i + 1
				local name = ARCLib.basexx.from_base32(string.upper(string.sub(account1,1,#account1-1)))
				local tile = self:CreateNewTile(10,20 + i * 20,120,16)
				tile.account = account1
				tile.text = name
				tile.color = self.Phone.Settings.Personalization.CL_03_SecondaryColour
				tile.OnPressed = function(tile)
					tile.color = tile.App.Phone.Settings.Personalization.CL_04_SecondaryPressed
				end
				tile.OnUnPressed = onSendMoneyUnpressed
			end
		end
	end)
end



function APP:AccountProperties(name)
	if self.Phone.Reception < 15 then
		self.Phone:AddMsgBox("No signal","You do not have enough reception to perform this operation","warning-sign")
		return
	end
	self.Phone.Loading = true
	ARCBank.GetAccountProperties(self.Phone.Ent, name, function(errorcode, account) 
		if errorcode ~= ARCBANK_ERROR_NONE then
			self.Phone:AddMsgBox("ARCBank Error",ARCBANK_ERRORSTRINGS[errorcode],"cancel-button")
			self.Phone.Loading = false
			return
		end
		ARCBank.GetBalance(self.Phone.Ent, name, function(errorcode, money) 
			if errorcode ~= ARCBANK_ERROR_NONE then
				self.Phone:AddMsgBox("ARCBank Error",ARCBANK_ERRORSTRINGS[errorcode],"cancel-button")
				self.Phone.Loading = false
				return
			end
			account.money = money
			self:ClearScreen()
			self.CurAccount = account
			
			local titleTile = self:CreateNewTile(4,20,130,32)
			titleTile.color = self.Phone.Settings.Personalization.CL_01_MainColour
			titleTile.drawfunc = TitleTileDraw
			titleTile.MoneyStr = string.Replace( string.Replace( ARCBank.Settings["money_format"], "$", ARCBank.Settings.money_symbol ) , "0", tostring(money))
			self.Phone.Loading = false
			
			local tile = self:CreateNewTile(10,60,120,16)
			tile.text = "Send Money"
			tile.color = self.Phone.Settings.Personalization.CL_01_MainColour
			tile.OnPressed = function(tile)
				tile.color = tile.App.Phone.Settings.Personalization.CL_02_MainPressed
			end
			tile.OnUnPressed = function(tile)
				tile.color = tile.App.Phone.Settings.Personalization.CL_01_MainColour
				tile.App.Phone:ChooseContact(tile.App.SendMoney,tile.App)
			end
			
			
			if (account.rank > ARCBANK_GROUPACCOUNTS_) then
				local tile = self:CreateNewTile(10,80,120,16)
				tile.text = "Add Group Member"
				tile.color = self.Phone.Settings.Personalization.CL_01_MainColour
				tile.OnPressed = function(tile)
					tile.color = tile.App.Phone.Settings.Personalization.CL_02_MainPressed
				end
				tile.OnUnPressed = function(tile)
					tile.color = tile.App.Phone.Settings.Personalization.CL_01_MainColour
					tile.App.Phone:ChooseContact(tile.App.AddPlayerToGroup,tile.App)
				end
				
				local tile = self:CreateNewTile(10,100,120,16)
				tile.text = "Remove Group Member"
				tile.color = self.Phone.Settings.Personalization.CL_01_MainColour
				tile.OnPressed = function(tile)
					tile.color = tile.App.Phone.Settings.Personalization.CL_02_MainPressed
				end
				tile.OnUnPressed = function(tile)
					tile.color = tile.App.Phone.Settings.Personalization.CL_01_MainColour
					tile.App:RemovePlayerFromGroup()
				end
			end
		end)
	end)
end



function APP:OnBack()
	if self.CurAccount then
		self:Init()
	else
		self:Close()
	end
end


function APP:OnClose()
	self:SaveData()
end

ARCPhone.RegisterApp(APP,"arcbank")
