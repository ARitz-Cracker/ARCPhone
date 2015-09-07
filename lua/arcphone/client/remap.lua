-- Special thanks to the wiremod team for doing all of this for me (taken from the wiremod keyboard)

ARCPhone.Keyboard_Remap = {}

----------------------------------------------------------------------
-- Default - Keys that all layouts use
----------------------------------------------------------------------

local ARCPhone_Keyboard_Remap_default = {}
ARCPhone_Keyboard_Remap_default.normal = {}
ARCPhone_Keyboard_Remap_default[KEY_LSHIFT] = {}
ARCPhone_Keyboard_Remap_default[KEY_RSHIFT] = ARCPhone_Keyboard_Remap_default[KEY_LSHIFT]
local remap = ARCPhone_Keyboard_Remap_default.normal
remap[KEY_NONE] = ""
remap[KEY_0] = "0"
remap[KEY_1] = "1"
remap[KEY_2] = "2"
remap[KEY_3] = "3"
remap[KEY_4] = "4"
remap[KEY_5] = "5"
remap[KEY_6] = "6"
remap[KEY_7] = "7"
remap[KEY_8] = "8"
remap[KEY_9] = "9"
remap[KEY_A] = "a"
remap[KEY_B] = "b"
remap[KEY_C] = "c"
remap[KEY_D] = "d"
remap[KEY_E] = "e"
remap[KEY_F] = "f"
remap[KEY_G] = "g"
remap[KEY_H] = "h"
remap[KEY_I] = "i"
remap[KEY_J] = "j"
remap[KEY_K] = "k"
remap[KEY_L] = "l"
remap[KEY_M] = "m"
remap[KEY_N] = "n"
remap[KEY_O] = "o"
remap[KEY_P] = "p"
remap[KEY_Q] = "q"
remap[KEY_R] = "r"
remap[KEY_S] = "s"
remap[KEY_T] = "t"
remap[KEY_U] = "u"
remap[KEY_V] = "v"
remap[KEY_W] = "w"
remap[KEY_X] = "x"
remap[KEY_Y] = "y"
remap[KEY_Z] = "z"
remap[KEY_ENTER] 		= 13 --"\r"
remap[KEY_SPACE] 		= " "
remap[KEY_BACKSPACE] 	= "\b"
remap[KEY_TAB] 			= "\t"
remap[KEY_ESCAPE] 		= 27
remap[KEY_DELETE] 		= 127

remap[KEY_LSHIFT] 		= KEY_LSHIFT
remap[KEY_RSHIFT] 		= KEY_RSHIFT
remap[KEY_LALT] 		= 83
remap[KEY_RALT] 		= 83
remap[KEY_LCONTROL] 	= 26
remap[KEY_RCONTROL] 	= 26

remap[KEY_UP] 			= 17
remap[KEY_LEFT] 		= 19
remap[KEY_DOWN] 		= 18
remap[KEY_RIGHT] 		= 20

remap = ARCPhone_Keyboard_Remap_default[KEY_LSHIFT]
remap[KEY_A] = "A"
remap[KEY_B] = "B"
remap[KEY_C] = "C"
remap[KEY_D] = "D"
remap[KEY_E] = "E"
remap[KEY_F] = "F"
remap[KEY_G] = "G"
remap[KEY_H] = "H"
remap[KEY_I] = "I"
remap[KEY_J] = "J"
remap[KEY_K] = "K"
remap[KEY_L] = "L"
remap[KEY_M] = "M"
remap[KEY_N] = "N"
remap[KEY_O] = "O"
remap[KEY_P] = "P"
remap[KEY_Q] = "Q"
remap[KEY_R] = "R"
remap[KEY_S] = "S"
remap[KEY_T] = "T"
remap[KEY_U] = "U"
remap[KEY_V] = "V"
remap[KEY_W] = "W"
remap[KEY_X] = "X"
remap[KEY_Y] = "Y"
remap[KEY_Z] = "Z"
remap[KEY_ENTER] = "\n"

-- Just because... yeah
remap[KEY_SPACE] 		= " "
remap[KEY_BACKSPACE] 	= "\b"
remap[KEY_TAB] 			= "\t"
remap[KEY_ESCAPE] 		= 27
remap[KEY_DELETE] 		= 127

remap[KEY_LSHIFT] 		= KEY_LSHIFT
remap[KEY_RSHIFT] 		= KEY_RSHIFT
remap[KEY_LALT] 		= 83
remap[KEY_RALT] 		= 83
remap[KEY_LCONTROL] 	= 26
remap[KEY_RCONTROL] 	= 26

remap[KEY_UP] 			= 17
remap[KEY_LEFT] 		= 19
remap[KEY_DOWN] 		= 18
remap[KEY_RIGHT] 		= 20


----------------------------------------------------------------------
-- American
----------------------------------------------------------------------

ARCPhone.Keyboard_Remap.American = {}
ARCPhone.Keyboard_Remap.American = table.Copy(ARCPhone_Keyboard_Remap_default)
ARCPhone.Keyboard_Remap.American[KEY_RSHIFT] = ARCPhone.Keyboard_Remap.American[KEY_LSHIFT]

remap = ARCPhone.Keyboard_Remap.American.normal
remap[KEY_LBRACKET] 	= "["
remap[KEY_RBRACKET] 	= "]"
remap[KEY_SEMICOLON] 	= ";"
remap[KEY_APOSTROPHE] 	= "'"
remap[KEY_BACKQUOTE] 	= "`"
remap[KEY_COMMA] 		= ","
remap[KEY_PERIOD] 		= "."
remap[KEY_SLASH] 		= "/"
remap[KEY_BACKSLASH] 	= "\\"
remap[KEY_MINUS] 		= "-"
remap[KEY_EQUAL] 		= "="

remap = ARCPhone.Keyboard_Remap.American[KEY_LSHIFT]
remap[KEY_0] = ")"
remap[KEY_1] = "!"
remap[KEY_2] = "@"
remap[KEY_3] = "#"
remap[KEY_4] = "$"
remap[KEY_5] = "%"
remap[KEY_6] = "^"
remap[KEY_7] = "&"
remap[KEY_8] = "*"
remap[KEY_9] = "("
remap[KEY_LBRACKET] 	= "{"
remap[KEY_RBRACKET] 	= "}"
remap[KEY_SEMICOLON] 	= ":"
remap[KEY_APOSTROPHE] 	= '"'
remap[KEY_COMMA] 		= "<"
remap[KEY_PERIOD] 		= ">"
remap[KEY_SLASH] 		= "?"
remap[KEY_BACKSLASH] 	= "|"
remap[KEY_MINUS] 		= "_"
remap[KEY_EQUAL] 		= "+"

----------------------------------------------------------------------
-- British
----------------------------------------------------------------------

ARCPhone.Keyboard_Remap.British = {}
ARCPhone.Keyboard_Remap.British = table.Copy(ARCPhone.Keyboard_Remap.American)
ARCPhone.Keyboard_Remap.British[83] = {}
ARCPhone.Keyboard_Remap.British[KEY_RSHIFT] = ARCPhone.Keyboard_Remap.British[KEY_LSHIFT]

remap = ARCPhone.Keyboard_Remap.British.normal
remap[KEY_BACKQUOTE] = "'"
remap[KEY_APOSTROPHE] = "#"

remap = ARCPhone.Keyboard_Remap.British[KEY_LSHIFT]
remap[KEY_2] = '"'
remap[KEY_3] = "£"
remap[KEY_APOSTROPHE] = "~"
remap[KEY_BACKQUOTE] = "@"

remap = ARCPhone.Keyboard_Remap.British[83]
remap[KEY_4] = "€"
remap[KEY_A] = "á"
remap[KEY_E] = "é"
remap[KEY_I] = "í"
remap[KEY_O] = "ó"
remap[KEY_U] = "ú"

----------------------------------------------------------------------
-- Swedish
----------------------------------------------------------------------

ARCPhone.Keyboard_Remap.Swedish = {}
ARCPhone.Keyboard_Remap.Swedish = table.Copy(ARCPhone_Keyboard_Remap_default)
ARCPhone.Keyboard_Remap.Swedish[83] = {} -- KEY_RALT = 82, but didn't work correctly
ARCPhone.Keyboard_Remap.Swedish[KEY_RSHIFT] = ARCPhone.Keyboard_Remap.Swedish[KEY_LSHIFT]

remap = ARCPhone.Keyboard_Remap.Swedish.normal
remap[KEY_LBRACKET] 	= "´"
remap[KEY_RBRACKET] 	= "å"
remap[KEY_SEMICOLON] 	= "¨"
remap[KEY_APOSTROPHE] 	= "ä"
remap[KEY_BACKQUOTE] 	= "ö"
remap[KEY_COMMA] 		= ","
remap[KEY_PERIOD] 		= "."
remap[KEY_SLASH] 		= "'"
remap[KEY_BACKSLASH] 	= "§"
remap[KEY_MINUS] 		= "-"
remap[KEY_EQUAL] 		= "+"

remap = ARCPhone.Keyboard_Remap.Swedish[KEY_LSHIFT]
remap[KEY_0] = "="
remap[KEY_1] = "!"
remap[KEY_2] = '"'
remap[KEY_3] = "#"
remap[KEY_4] = "¤"
remap[KEY_5] = "%"
remap[KEY_6] = "&"
remap[KEY_7] = "/"
remap[KEY_8] = "("
remap[KEY_9] = ")"
remap[KEY_LBRACKET] 	= "`"
remap[KEY_RBRACKET] 	= "Å"
remap[KEY_BACKQUOTE] 	= "Ö"
remap[KEY_SEMICOLON] 	= "^"
remap[KEY_APOSTROPHE] 	= "Ä"
remap[KEY_COMMA] 		= ";"
remap[KEY_PERIOD] 		= ":"
remap[KEY_SLASH] 		= "*"
remap[KEY_BACKSLASH] 	= "½"
remap[KEY_MINUS] 		= "_"
remap[KEY_EQUAL] 		= "?"

remap = ARCPhone.Keyboard_Remap.Swedish[83]
remap[KEY_2] = "@"
remap[KEY_3] = "£"
remap[KEY_4] = "$"
remap[KEY_7] = "{"
remap[KEY_8] = "["
remap[KEY_9] = "]"
remap[KEY_0] = "}"
remap[KEY_EQUAL] = "\\"
remap[KEY_SEMICOLON] = "~"
remap[KEY_E] = "€"

----------------------------------------------------------------------
-- Norwegian
----------------------------------------------------------------------

ARCPhone.Keyboard_Remap.Norwegian = {}
ARCPhone.Keyboard_Remap.Norwegian = table.Copy(ARCPhone.Keyboard_Remap.Swedish)
ARCPhone.Keyboard_Remap.Norwegian[KEY_RSHIFT] = ARCPhone.Keyboard_Remap.Norwegian[KEY_LSHIFT]

remap = ARCPhone.Keyboard_Remap.Norwegian.normal
remap[KEY_BACKQUOTE] 	= "ø"
remap[KEY_APOSTROPHE] 	= "æ"
remap[KEY_BACKSLASH] 	= "|"
remap[KEY_LBRACKET] 	= "\\"

remap = ARCPhone.Keyboard_Remap.Norwegian[KEY_LSHIFT]
remap[KEY_BACKQUOTE] 	= "Ø"
remap[KEY_APOSTROPHE] 	= "Æ"
remap[KEY_BACKSLASH] 	= "§"

remap = ARCPhone.Keyboard_Remap.Norwegian[83]
remap[KEY_EQUAL] = nil
remap[KEY_M] = "µ"
remap[KEY_LBRACKET] 		= "´"

----------------------------------------------------------------------
-- German
----------------------------------------------------------------------

ARCPhone.Keyboard_Remap.German				= {}
ARCPhone.Keyboard_Remap.German				= table.Copy(ARCPhone_Keyboard_Remap_default)
ARCPhone.Keyboard_Remap.German[83]			= {} -- KEY_RALT	= 82, but didn't work correctly
ARCPhone.Keyboard_Remap.German[KEY_RSHIFT]	= ARCPhone.Keyboard_Remap.German[KEY_LSHIFT]

remap = ARCPhone.Keyboard_Remap.German.normal
remap[KEY_LBRACKET]		= "ß"
remap[KEY_RBRACKET]		= "´"
remap[KEY_SEMICOLON]	= "ü"
remap[KEY_APOSTROPHE]	= "ä"
remap[KEY_BACKQUOTE]	= "ö"
remap[KEY_COMMA]		= ","
remap[KEY_PERIOD]		= "."
remap[KEY_SLASH]		= "#"
remap[KEY_BACKSLASH]	= "^"
remap[KEY_MINUS]		= "-"
remap[KEY_EQUAL]		= "+"

remap = ARCPhone.Keyboard_Remap.German[KEY_LSHIFT]
remap[KEY_0]	= "="
remap[KEY_1]	= "!"
remap[KEY_2]	= '"'
remap[KEY_3]	= "§"
remap[KEY_4]	= "$"
remap[KEY_5]	= "%"
remap[KEY_6]	= "&"
remap[KEY_7]	= "/"
remap[KEY_8]	= "("
remap[KEY_9]	= ")"
remap[KEY_LBRACKET]		= "?"
remap[KEY_RBRACKET]		= "`"
remap[KEY_SEMICOLON]	= "Ü"
remap[KEY_APOSTROPHE]	= 'Ä'
remap[KEY_BACKQUOTE]	= "Ö"
remap[KEY_COMMA]		= ";"
remap[KEY_PERIOD]		= ":"
remap[KEY_SLASH]		= "'"
remap[KEY_BACKSLASH]	= "°"
remap[KEY_MINUS]		= "_"
remap[KEY_EQUAL]		= "*"

remap = ARCPhone.Keyboard_Remap.German[83]
remap[KEY_0]	= "}"
remap[KEY_2]	= '²'
remap[KEY_3]	= "³"
remap[KEY_7]	= "{"
remap[KEY_8]	= "["
remap[KEY_9]	= "]"
remap[KEY_E]	= "€"
remap[KEY_M]	= "µ"
remap[KEY_Q]	= "@"
remap[KEY_LBRACKET]		= '\\'
remap[KEY_EQUAL]		= "~"
remap[KEY_COMMA]		= "<"
remap[KEY_PERIOD]		= ">"
remap[KEY_MINUS]		= "|"
