local ARCPHONE_SERVERAPP = {}
ARCPHONE_SERVERAPP.Name = "Stuffs"
ARCPHONE_SERVERAPP.Number = "0000000000"
ARCPHONE_SERVERAPP.OnText = NULLFUNC --(number,data)
function ARCPHONE_SERVERAPP:SendText(number,data)
	assert(ARCPhone.IsValidPhoneNumber(self.Number),"ARCPHONE_SERVERAPP.SendText: ARCPHONE_SERVERAPP.Number is invalid")
	assert(string.sub( self.Number, 1, 3 ) == "000" or string.sub( self.Number, 1, 3 ) == "001","ARCPHONE_SERVERAPP.SendText: ARCPHONE_SERVERAPP.Number must start with 000 or 001")
	assert(ARCPhone.IsValidPhoneNumber(number),"ARCPHONE_SERVERAPP.SendText: Bad argument #1: Invalid phone number")
	ARCPhone.SendTextMsg(number,self.Number,data)
end
function ARCPhone.NewServerAppObject()
	local tab = table.FullCopy(ARCPHONE_SERVERAPP)
	return tab
end
function ARCPhone.RegisterServerApp(tab)
	assert(ARCPhone.IsValidPhoneNumber(tab.Number),"ARCPHONE_SERVERAPP.NewServerAppObject: ARCPHONE_SERVERAPP.Number is invalid")
	assert(string.sub( tab.Number, 1, 3 ) == "000" or string.sub( tab.Number, 1, 3 ) == "001","ARCPHONE_SERVERAPP.NewServerAppObject: ARCPHONE_SERVERAPP.Number must start with 000 or 001")
	ARCPhone.TextApps[tab.Number] = tab
end