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
	if (not istable(ARCBank)) then
		self.Phone:AddMsgBox("ARCBank","ARCBank is not available on this server!","report-symbol")
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
local function onSendMoneyUnpressed(tile)
	tile.color = tile.App.Phone.Settings.Personalization.CL_03_SecondaryColour
	ARCBank.Transfer(tile.App.Phone.Ent, tile.App.Recipient, tile.App.CurAccount.account, tile.account, 100, "ARCPhone Transfer", function(errorcode)
		if errorcode == ARCBANK_ERROR_NONE then
			tile.App.Phone:AddMsgBox("ARCBank",ARCBANK_ERRORSTRINGS[errorcode],"round-info-button")
		else
			tile.App.Phone:AddMsgBox("ARCBank Error",ARCBANK_ERRORSTRINGS[errorcode],"cancel-button")
		end
		tile.App:Init()
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
	self.Loading = true
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
				local tile = self:CreateNewTile(10,i * 20,120,16)
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
				end
				
				local tile = self:CreateNewTile(10,100,120,16)
				tile.text = "Remove Group Member"
				tile.color = self.Phone.Settings.Personalization.CL_01_MainColour
				tile.OnPressed = function(tile)
					tile.color = tile.App.Phone.Settings.Personalization.CL_02_MainPressed
				end
				tile.OnUnPressed = function(tile)
					tile.color = tile.App.Phone.Settings.Personalization.CL_01_MainColour
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
