-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.

ARCPhone.PhoneSys.Settings = {}
ARCPhone.PhoneSys.SettingChoices = {}

ARCPhone.PhoneSys.Settings.Ringtones = {}
ARCPhone.PhoneSys.SettingChoices.Ringtones = {}
ARCPhone.PhoneSys.Settings.Ringtones.PhoneCall = "https://www.aritzcracker.ca/arcphone/ringtones/generic1.mp3"
ARCPhone.PhoneSys.SettingChoices.Ringtones.PhoneCall = {
	{"Durr Plant","https://www.aritzcracker.ca/arcphone/ringtones/durr_plant.ogg"},
	{"Default","https://www.aritzcracker.ca/arcphone/ringtones/generic1.mp3"},
	{"You're free to do whatever","http://www.billwurtz.com/youre-free-to-do-whatever-you-want-to.mp3"},
	{"I'm Crazy / It's raining","http://www.billwurtz.com/im-crazy-its-raining.mp3"},
	{"8bit Nokia tune","https://www.aritzcracker.ca/arcphone/ringtones/8-bit%20Nokia.mp3"},
	{"SECRET","https://www.aritzcracker.ca/random_shit/BattleBlock%20Theater%20Music%20-%20Secret%20Area.mp3"},
	{"BANANA PHONE","http://www.lee.org/blog/wp-content/uploads/2008/03/raffi-bananaphone.mp3"},
	{"POMF =3","http://www.aritzcracker.ca/texttospeech/63118d6268cbf68ef21cd4625db785b5.mp3"},
	{"Dragonborn Comes","http://ndlee.com/thedragonborncomes.mp3"},
}
ARCPhone.PhoneSys.Settings.Ringtones.TextMsg = "http://www.aritzcracker.ca/arcphone/notifications/162464__kastenfrosch__message.mp3"
ARCPhone.PhoneSys.Settings.Ringtones.Popup = "http://www.aritzcracker.ca/arcphone/notifications/162464__kastenfrosch__message.mp3"

ARCPhone.PhoneSys.Settings.Personalization = {}
ARCPhone.PhoneSys.SettingChoices.Personalization = {}
ARCPhone.PhoneSys.Settings.Personalization.PhoneCase = 0
ARCPhone.PhoneSys.Settings.Personalization.CL_00_CursorColour = Color(255,255,255,255)

ARCPhone.PhoneSys.Settings.Personalization.CL_01_MainColour = Color(25,25,255,255)
ARCPhone.PhoneSys.Settings.Personalization.CL_02_MainPressed = Color(25,25,255,128)
ARCPhone.PhoneSys.Settings.Personalization.CL_03_MainText = Color(255,255,255,255)

ARCPhone.PhoneSys.Settings.Personalization.CL_03_SecondaryColour = Color(0,0,128,255)
ARCPhone.PhoneSys.Settings.Personalization.CL_04_SecondaryPressed = Color(0,0,128,128)
ARCPhone.PhoneSys.Settings.Personalization.CL_05_SecondaryText = Color(255,255,255,255)

ARCPhone.PhoneSys.Settings.Personalization.CL_06_TertiaryColour = Color(0,0,64,255)
ARCPhone.PhoneSys.Settings.Personalization.CL_07_TertiaryPressed = Color(0,0,64,128)
ARCPhone.PhoneSys.Settings.Personalization.CL_08_TertiaryText = Color(255,255,255,255)

ARCPhone.PhoneSys.Settings.Personalization.CL_09_QuaternaryColour = Color(128,128,128,255)
ARCPhone.PhoneSys.Settings.Personalization.CL_10_QuaternaryPressed = Color(128,128,128,128)
ARCPhone.PhoneSys.Settings.Personalization.CL_11_QuaternaryText = Color(255,255,255,255)

ARCPhone.PhoneSys.Settings.Personalization.CL_12_HotbarColour = Color(18,18,180,255)
ARCPhone.PhoneSys.Settings.Personalization.CL_12_HotbarBorder = Color(255,255,255,255)
ARCPhone.PhoneSys.Settings.Personalization.CL_13_BackgroundColour = Color(0,0,0,255)

ARCPhone.PhoneSys.Settings.Personalization.CL_14_ContextMenuMain = Color(0,0,128,255)
ARCPhone.PhoneSys.Settings.Personalization.CL_15_ContextMenuSelect = Color(0,0,255,255)
ARCPhone.PhoneSys.Settings.Personalization.CL_16_ContextMenuBorder = Color(50,50,255,255)
ARCPhone.PhoneSys.Settings.Personalization.CL_17_ContextMenuText = Color(255,255,255,255)
ARCPhone.PhoneSys.Settings.Personalization.CL_17_ContextMenuTextSelect = Color(255,255,255,255)

ARCPhone.PhoneSys.Settings.Personalization.CL_18_FadeColour = Color(0,0,0,150)
ARCPhone.PhoneSys.Settings.Personalization.CL_19_MegaFadeColour = Color(0,0,0,225)

ARCPhone.PhoneSys.Settings.Personalization.CL_20_PopupBoxMain = Color(100,100,100,255)
ARCPhone.PhoneSys.Settings.Personalization.CL_21_PopupBoxText = Color(255,255,255,255)
ARCPhone.PhoneSys.Settings.Personalization.CL_22_PopupAccept = Color(75,255,75,255)
ARCPhone.PhoneSys.Settings.Personalization.CL_23_PopupAcceptText = Color(255,255,255,255)
ARCPhone.PhoneSys.Settings.Personalization.CL_24_PopupDeny = Color(255,75,75,255 )
ARCPhone.PhoneSys.Settings.Personalization.CL_25_PopupDenyText = Color(255,255,255,255)
ARCPhone.PhoneSys.Settings.Personalization.CL_26_PopupDefer = Color(255,255,75,255)
ARCPhone.PhoneSys.Settings.Personalization.CL_27_PopupDeferText = Color(0,0,0,255)



ARCPhone.PhoneSys.Settings.Privacy = {}
ARCPhone.PhoneSys.SettingChoices.Privacy = {}

ARCPhone.PhoneSys.Settings.System = {}
ARCPhone.PhoneSys.SettingChoices.System = {}

ARCPhone.PhoneSys.Settings.System.KeyUp = KEY_UP
ARCPhone.PhoneSys.Settings.System.KeyDown = KEY_DOWN
ARCPhone.PhoneSys.Settings.System.KeyLeft = KEY_LEFT
ARCPhone.PhoneSys.Settings.System.KeyRight = KEY_RIGHT
ARCPhone.PhoneSys.Settings.System.KeyEnter = KEY_ENTER
ARCPhone.PhoneSys.Settings.System.KeyBack = KEY_BACKSPACE
ARCPhone.PhoneSys.Settings.System.KeyContext = KEY_LCONTROL
