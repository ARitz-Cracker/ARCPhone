-- GUI for ARitz Cracker Bank (Clientside)
-- This shit is under a Creative Commons Attribution 4.0 International Licence
-- http://creativecommons.org/licenses/by/4.0/
-- You can mess around with it, mod it to your liking, and even redistribute it.
-- However, you must credit me.
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
			
			for i=1,#tab do 
				LogList:AddChoice(tab[i])
			end
			function LogList:OnSelect(index,value,data)
				ARCPhone.AdminLog(value,false,function(data,per)
					if isnumber(data) then
						if data == ARCBANK_ERROR_DOWNLOADING then
							Text:SetText(ARCPhone.Msgs.ATMMsgs.Loading.."(%"..math.Round(per*100)..")")
						else
							Text:SetText(ARCBANK_ERRORSTRINGS[data])
						end
					else
						Text:SetText(data)
					end
				end)
			end
			
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
			LogButton:SetText( "// DO NOTHING //" )
			LogButton:SetPos( 10, 30 )
			LogButton:SetSize( 180, 20 )
			LogButton.DoClick = function()
				--RunConsoleCommand( "arcphone","admin_gui","logs")
			end
			local AccountsButton = vgui.Create( "DButton", MainMenu )
			AccountsButton:SetText( "// DO NOTHING //" )
			AccountsButton:SetPos( 10, 60 )
			AccountsButton:SetSize( 180, 20 )
			AccountsButton.DoClick = function()	

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


