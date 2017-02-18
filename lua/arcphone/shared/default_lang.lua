--default_lang.lua - default language

-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016 Aritz Beobide-Cardinal All rights reserved.

ARCPhone.Msgs = ARCPhone.Msgs or {}
ARCPhone.Msgs.Time = ARCPhone.Msgs.Time or {}
ARCPhone.Msgs.AdminMenu = ARCPhone.Msgs.AdminMenu or {}
ARCPhone.Msgs.Commands = ARCPhone.Msgs.Commands or {}
ARCPhone.Msgs.CommandOutput = ARCPhone.Msgs.CommandOutput or {}
ARCPhone.Msgs.Items = ARCPhone.Msgs.Items or {}
ARCPhone.Msgs.LogMsgs = ARCPhone.Msgs.LogMsgs or {}

ARCPHONE_ERRORSTRINGS = ARCPHONE_ERRORSTRINGS or {}
ARCPhone.SettingsDesc = ARCPhone.SettingsDesc or {}

--[[
 ____   ___    _   _  ___ _____   _____ ____ ___ _____   _____ _   _ _____   _    _   _   _      _____ ___ _     _____ _ 
|  _ \ / _ \  | \ | |/ _ \_   _| | ____|  _ \_ _|_   _| |_   _| | | | ____| | |  | | | | / \    |  ___|_ _| |   | ____| |
| | | | | | | |  \| | | | || |   |  _| | | | | |  | |     | | | |_| |  _|   | |  | | | |/ _ \   | |_   | || |   |  _| | |
| |_| | |_| | | |\  | |_| || |   | |___| |_| | |  | |     | | |  _  | |___  | |__| |_| / ___ \  |  _|  | || |___| |___|_|
|____/ \___/  |_| \_|\___/ |_|   |_____|____/___| |_|     |_| |_| |_|_____| |_____\___/_/   \_\ |_|   |___|_____|_____(_)

 ____   ___    _   _  ___ _____   _____ ____ ___ _____   _____ _   _ _____   _    _   _   _      _____ ___ _     _____ _ 
|  _ \ / _ \  | \ | |/ _ \_   _| | ____|  _ \_ _|_   _| |_   _| | | | ____| | |  | | | | / \    |  ___|_ _| |   | ____| |
| | | | | | | |  \| | | | || |   |  _| | | | | |  | |     | | | |_| |  _|   | |  | | | |/ _ \   | |_   | || |   |  _| | |
| |_| | |_| | | |\  | |_| || |   | |___| |_| | |  | |     | | |  _  | |___  | |__| |_| / ___ \  |  _|  | || |___| |___|_|
|____/ \___/  |_| \_|\___/ |_|   |_____|____/___| |_|     |_| |_| |_|_____| |_____\___/_/   \_\ |_|   |___|_____|_____(_)
                                                                                                                         

 ____   ___    _   _  ___ _____   _____ ____ ___ _____   _____ _   _ _____   _    _   _   _      _____ ___ _     _____ _ 
|  _ \ / _ \  | \ | |/ _ \_   _| | ____|  _ \_ _|_   _| |_   _| | | | ____| | |  | | | | / \    |  ___|_ _| |   | ____| |
| | | | | | | |  \| | | | || |   |  _| | | | | |  | |     | | | |_| |  _|   | |  | | | |/ _ \   | |_   | || |   |  _| | |
| |_| | |_| | | |\  | |_| || |   | |___| |_| | |  | |     | | |  _  | |___  | |__| |_| / ___ \  |  _|  | || |___| |___|_|
|____/ \___/  |_| \_|\___/ |_|   |_____|____/___| |_|     |_| |_| |_|_____| |_____\___/_/   \_\ |_|   |___|_____|_____(_)
                                                                                                                         
																														 
These are the default values in order to prevent you from screwing it up!

For a tutorial on how to create your own custom language, READ THE README!

There's even a command that lets you select from a range of pre-loaded languages!

type "arcslots settings language (lang)" in console
(lang) can be the following:
en -- English
fr -- French
ger -- German
pt_br -- Brazilian Portuguese
sp -- Spanish
]]

ARCPHONE_ERRORSTRINGS[-4] = "Incomming call"
ARCPHONE_ERRORSTRINGS[-3] = "Call ended"
ARCPHONE_ERRORSTRINGS[-2] = "Operation Aborted"
ARCPHONE_ERRORSTRINGS[-1] = "Dialing..."
ARCPHONE_ERRORSTRINGS[0] = "Call in progress"
ARCPHONE_ERRORSTRINGS[1] = "The person who you're trying to call is out of range"
ARCPHONE_ERRORSTRINGS[2] = "Invalid call code"
ARCPHONE_ERRORSTRINGS[3] = "All lines busy. Try again later."
ARCPHONE_ERRORSTRINGS[4] = "Number blocked/disconnected"
ARCPHONE_ERRORSTRINGS[5] = "The person who you're trying to call is not in this area"
ARCPHONE_ERRORSTRINGS[6] = "The person who you're trying to call is already in one"
ARCPHONE_ERRORSTRINGS[7] = "Invalid phone number"

ARCPHONE_ERRORSTRINGS[16] = "Not enough reception"
ARCPHONE_ERRORSTRINGS[17] = "Call dropped"
ARCPHONE_ERRORSTRINGS[18] = "Your phone plan doesn't support this"

ARCPHONE_ERRORSTRINGS[-127] = "The ARCPhone system failed to load."
ARCPHONE_ERRORSTRINGS[-128] = "Unknown Error. Try again later."

ARCPhone.Msgs.CommandOutput.SysReset = "System reset required!"
ARCPhone.Msgs.CommandOutput.SysSetting = "%SETTING% has been changed to %VALUE%"
ARCPhone.Msgs.CommandOutput.admin = "You must be an admin to use this command!"
ARCPhone.Msgs.CommandOutput.superadmin = "You must be an superadmin to use this command!"
ARCPhone.Msgs.CommandOutput.SettingsSaved = "Settings have been saved!"
ARCPhone.Msgs.CommandOutput.SettingsError = "Error saving settings."

ARCPhone.Msgs.CommandOutput.ResetYes = "System reset!"
ARCPhone.Msgs.CommandOutput.ResetNo = "Error. Check server console for details. Or look at the latest system log located in garrysmod/data/_arcslots on the server."

ARCPhone.Msgs.Items.Phone = "Phone"

ARCPhone.Msgs.Time.nd = "and"
ARCPhone.Msgs.Time.second = "second"
ARCPhone.Msgs.Time.seconds = "seconds"
ARCPhone.Msgs.Time.minute = "minute"
ARCPhone.Msgs.Time.minutes = "minutes"
ARCPhone.Msgs.Time.hour = "hour"
ARCPhone.Msgs.Time.hours = "hours"
ARCPhone.Msgs.Time.day = "day"
ARCPhone.Msgs.Time.days = "days"
ARCPhone.Msgs.Time.forever = "forever"
ARCPhone.Msgs.Time.now = "now"

ARCPhone.Msgs.AdminMenu.Remove = "Remove"
ARCPhone.Msgs.AdminMenu.Add = "Add"
ARCPhone.Msgs.AdminMenu.Description = "Description:"
ARCPhone.Msgs.AdminMenu.Enable = "Enable"
ARCPhone.Msgs.AdminMenu.Settings = "Settings"
ARCPhone.Msgs.AdminMenu.ChooseSetting = "Choose setting"
ARCPhone.Msgs.AdminMenu.SaveSettings = "Save settings"

ARCPhone.Msgs.Commands["antenna_save"] = "Save and freeze all antennas"
ARCPhone.Msgs.Commands["antenna_unsave"] = "Unsave and unfreeze all antennas"
ARCPhone.Msgs.Commands["antenna_respawn"] = "Respawn frozen antennas"
ARCPhone.Msgs.Commands["antenna_spawn"] = "Spawn an antenna where you're looking"

ARCPhone.SettingsDesc["name"] = "The displayed \"short\" name of the addon."
ARCPhone.SettingsDesc["name_long"] = "The displayed \"long\" name of the addon."
