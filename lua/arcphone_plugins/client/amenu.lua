-- GUI for ARitz Cracker Bank (Clientside)
-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
if ARCPhone then
	local ARCPhoneGUI = ARCPhoneGUI or {}
	ARCPhoneGUI.SelectedAccountRank = 0
	ARCPhoneGUI.SelectedAccount = ""
	ARCPhoneGUI.Log = ""
	ARCPhoneGUI.LogDownloaded = false
	ARCPhoneGUI.AccountListTab = {}
	net.Receive( "ARCPhone_Admin_SendAccounts", function(length)

	end)
	net.Receive( "ARCPhone_Admin_Send", function(length)

	end)
	net.Receive( "ARCPhone_Admin_GUI", function(length)
		local thing = net.ReadString()
		local tab = net.ReadTable()
		if thing == "settings" then
			error("Tell aritz that this shouldn't happen, be sure to attach the FULL error reporst")
			
		elseif thing == "adv_EmergencyNumbers" then
			PrintTable(tab)
			local numberList = {}
			local numberListLen = 0
			local selectedNumber = ""
			
			local MainPanel = vgui.Create( "DFrame" )
			MainPanel:SetSize( 200, 245 )
			MainPanel:Center()
			MainPanel:SetTitle( "Emergency Numbers" )
			MainPanel:SetVisible( true )
			MainPanel:SetDraggable( true )
			MainPanel:ShowCloseButton( true )
			MainPanel:MakePopup()
			MainPanel:SetDeleteOnClose( false )
			
			local TeamList = vgui.Create( "DListView",MainPanel )
			TeamList:SetPos( 10, 60 ) -- Set the position of the label
			TeamList:SetSize( 180, 120  )
			
			TeamList:SetMultiSelect( false )
			TeamList:AddColumn("Team")
			
			local TeamDown = vgui.Create( "DButton", MainPanel )
			TeamDown:SetText( "" )
			TeamDown:SetImage( "icon16/arrow_down.png" )
			TeamDown:SetPos( 10, 60+120+5)
			TeamDown:SetSize( 24, 20+25 )
			TeamDown.DoClick=function()
				local i = TeamList:GetSelectedLine()
				if i == nil then
					Derma_Message( "No team selected.", "TeamList:GetSelectedLine() == nil", "OK" )
					return
				end
				local teams = tab[selectedNumber]
				if not teams then
					Derma_Message( "No number selected.", "tab[selectedNumber] == nil", "OK" )
					return
				end
				if i >= #teams then
					return
				end
				local t = table.remove(teams,i)
				i = i + 1
				table.insert( teams, i, t )
				TeamList:Clear()
				for i=1,#teams do
					TeamList:AddLine(teams[i])
				end
				TeamList:SelectItem(TeamList:GetLine( i ))
			end
			
			local TeamUp = vgui.Create( "DButton", MainPanel )
			TeamUp:SetText( "" )
			TeamUp:SetImage( "icon16/arrow_up.png" )
			TeamUp:SetPos( 166, 60+120+5)
			TeamUp:SetSize( 24, 20+25 )
			TeamUp.DoClick=function()
				local i = TeamList:GetSelectedLine()
				if i == nil then
					Derma_Message( "No team selected.", "TeamList:GetSelectedLine() == nil", "OK" )
					return
				end
				local teams = tab[selectedNumber]
				if not teams then
					Derma_Message( "No number selected.", "tab[selectedNumber] == nil", "OK" )
					return
				end
				if i <= 1 then
					return
				end
				local t = table.remove(teams,i)
				i = i - 1
				table.insert( teams, i, t )
				TeamList:Clear()
				for i=1,#teams do
					TeamList:AddLine(teams[i])
				end
				TeamList:SelectItem(TeamList:GetLine( i ))
			end
			
			
			local TeamAdd = vgui.Create( "DButton", MainPanel )
			TeamAdd:SetText( "Add new team..." )
			TeamAdd:SetPos( 35, 60+120+5)
			TeamAdd:SetSize( 130, 20 )
			TeamAdd.DoClick = function()			
			local teams = tab[selectedNumber]
			if not teams then
				Derma_Message( "No number selected.", "tab[selectedNumber] == nil", "OK" )
				return
			end			
				Derma_StringRequest("Add new team...","Enter the new team to add.","",function( text ) 
					text = text:Trim()
					if text == "" then return end
					teams[#teams + 1] = text
					TeamList:AddLine(text)
				end)
			end
			
			local TeamRm = vgui.Create( "DButton", MainPanel )
			TeamRm:SetText( "Remove selected team" )
			TeamRm:SetPos( 35, 60+120+30)
			TeamRm:SetSize( 130, 20 )
			TeamRm.DoClick = function()
				local i = TeamList:GetSelectedLine()
				if i == nil then
					Derma_Message( "No team selected.", "TeamList:GetSelectedLine() == nil", "OK" )
					return
				end
				local teams = tab[selectedNumber]
				if not teams then
					Derma_Message( "No number selected.", "tab[selectedNumber] == nil", "OK" )
					return
				end
				table.remove( teams, TeamList:GetSelectedLine() )
				TeamList:Clear()
				for i=1,#teams do
					TeamList:AddLine(teams[i])
				end
			end
			
			
			local NumSelector = vgui.Create( "DComboBox", MainPanel )
			NumSelector:SetText( "Select Emergency Number" )
			NumSelector:SetPos( 10, 30 )
			NumSelector:SetSize( 180-25, 20 )
			for k,v in pairs(tab) do
				numberListLen = numberListLen + 1
				numberList[numberListLen] = k
				NumSelector:AddChoice(k)
			end
			NumSelector:AddChoice("Add new number...")
			function NumSelector:OnSelect(index,value,data)
				if index > numberListLen then
					self:SetText( "Select Emergency Number" )
					Derma_StringRequest("Add new number...","Enter the new emergency number to add.","",function( text ) 
						if ARCPhone.ValidPhoneNumberChars(text) then
							if tab[text] then
								Derma_Message( "The emergency number already exists!", "Invalid emergency number", "OK" )
								return
							end
							selectedNumber = ""
							tab[text] = {}
							numberListLen = numberListLen + 1
							numberList[numberListLen] = text
							NumSelector:Clear()
							for i=1,numberListLen do
								NumSelector:AddChoice(numberList[i])
							end
							TeamList:Clear()
							NumSelector:AddChoice("Add new number...")
							NumSelector:SetText( "Select Emergency Number" )
						else
							Derma_Message( "An emergency number can only contain the following characters:\n0123456789#*", "Invalid emergency number", "OK" )
						end
					end)
				else
					selectedNumber = numberList[index]
					local teams = tab[selectedNumber]
					if not teams then
						Derma_Message( "No number selected.", "tab[selectedNumber] == nil", "OK" )
						return
					end
					TeamList:Clear()
					for i=1,#teams do
						TeamList:AddLine(teams[i])
					end
					
				end
			end
			
			local Hint = vgui.Create( "DButton", MainPanel )
			Hint:SetText( "?" )
			Hint:SetPos( 10+180-20, 30 )
			Hint:SetSize( 20, 20 )
			Hint.DoClick = function()
				Derma_Message( "When someone dials an emergency number, it will start a group chat between the caller and everyone on the first team of the list. If there's nobody on the first team, it will attempt to do the same with the second team, and so on.\nIf someone sends a text message to an emergency number, it will use the same process described above to decide who to forward the text to.	", "Emergency Numbers Description", "I got it!" )
			end
			MainPanel.OnClose = function()
				MainPanel:SetVisible(true)
				Derma_Query( "Save changes?", "Emergency Numbers", "Yes", function()
					if table.Count( tab ) > 255 then
						Derma_Message( "There cannot be more than 255 emergency numbers.", "Invalid user input", "OK" )
						return
					end
					net.Start("ARCPhone_Admin_GUI")
					net.WriteString("EmergencyNumbers")
					net.WriteTable(tab)
					net.SendToServer()
					MainPanel:Remove()
				end, "No", function()
					MainPanel:Remove()
				end, "Cancel")
			end
		elseif thing == "logs" then
			local MainPanel = vgui.Create( "DFrame" )
			MainPanel:SetSize( 600,575 )
			MainPanel:Center()
			MainPanel:SetTitle( ARCPhone.Msgs.AdminMenu.ServerLogs )
			MainPanel:SetVisible( true )
			MainPanel:SetDraggable( true )
			MainPanel:ShowCloseButton( true )
			MainPanel:MakePopup()
			
			Text = vgui.Create("DTextEntry", MainPanel) // The info text.
			Text:SetPos( 5, 30 ) -- Set the position of the label
			Text:SetSize( 590, 515 )
			Text:SetText("") --  Set the text of the label
			Text:SetMultiline(true)
			Text:SetEnterAllowed(false)
			Text:SetVerticalScrollbarEnabled(true)
			
			LogList= vgui.Create( "DComboBox",MainPanel)
			LogList:SetPos(5,550)
			LogList:SetSize( 590, 20 )
			LogList:SetText( "UNAVAILABLE" )
		
		else
			local MainMenu = vgui.Create( "DFrame" )
			MainMenu:SetSize( 200, 150 )
			MainMenu:Center()
			MainMenu:SetTitle( ARCPhone.Settings.name_long )
			MainMenu:SetVisible( true )
			MainMenu:SetDraggable( true )
			MainMenu:ShowCloseButton( true )
			MainMenu:MakePopup()
			local LogButton = vgui.Create( "DButton", MainMenu )
			LogButton:SetText( "System Logs" )
			LogButton:SetPos( 10, 30 )
			LogButton:SetSize( 180, 20 )
			LogButton.DoClick = function()
				Derma_Message( "This feature is coming in a future update.", "Uh oh...", "OK" )
			end

			local AccountsButton = vgui.Create( "DComboBox", MainMenu )
			AccountsButton:SetText( "Advanced settings" )
			AccountsButton:SetPos( 10, 60 )
			AccountsButton:SetSize( 180, 20 )
			for i=1,#tab do 
				AccountsButton:AddChoice(tab[i])
			end
			function AccountsButton:OnSelect(index,value,data)
				RunConsoleCommand( "arcphone","admin_gui","adv",value)
				AccountsButton:SetText( "Advanced settings" )
			end
			
			local SettingsButton = vgui.Create( "DButton", MainMenu )
			SettingsButton:SetText( "Settings" )
			SettingsButton:SetPos( 10, 90 )
			SettingsButton:SetSize( 180, 20 )
			SettingsButton.DoClick = function()	
				ARCLib.AddonConfigMenu("ARCPhone","arcphone")
			end
			local CommandButton = vgui.Create( "DButton", MainMenu )
			CommandButton:SetText( "Commands" )
			CommandButton:SetPos( 10, 120 )
			CommandButton:SetSize( 180, 20 )
			CommandButton.DoClick = function()		
				local cmdlist = {"antenna_save","antenna_unsave","antenna_respawn"}
				local CommandFrame = vgui.Create( "DFrame" )
				CommandFrame:SetSize( 200*math.ceil(#cmdlist/8), 30+(30*math.Clamp(#cmdlist,0,8)) )
				CommandFrame:Center()
				CommandFrame:SetTitle(ARCPhone.Msgs.AdminMenu.Commands)
				CommandFrame:SetVisible( true )
				CommandFrame:SetDraggable( true )
				CommandFrame:ShowCloseButton( true )
				CommandFrame:MakePopup()
				for i = 0,(#cmdlist-1) do
				
					local LogButton = vgui.Create( "DButton", CommandFrame )
					LogButton:SetText(tostring(ARCPhone.Msgs.Commands[cmdlist[i+1]]))
					LogButton:SetPos( 10+(200*math.floor(i/8)), 30+(30*(i%8)) )
					LogButton:SetSize( 180, 20 )
					LogButton.DoClick = function()
						RunConsoleCommand( "arcphone",cmdlist[i+1])
					end
				end
			end
		
		end
	end)
end


