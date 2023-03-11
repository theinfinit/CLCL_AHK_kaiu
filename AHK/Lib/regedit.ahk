regedit(r) {
	r:=RegExReplace(r,"^ *\[?-?")
	r:=RegExReplace(r,"]? *$")
	r:=StrReplace(r,"HKCR","HKEY_CLASSES_ROOT")
	r:=StrReplace(r,"HKCU","HKEY_CURRENT_USER")
	r:=StrReplace(r,"HKLM","HKEY_LOCAL_MACHINE")
	r:=StrReplace(r,"HKU","HKEY_USERS")
	r:=StrReplace(r,"HKCC","HKEY_CURRENT_CONFIG")
	r:=RegExReplace(r," {2,}"," ")
	r:=RegExReplace(r,"\\{2,}","\\")
	r:=RegExReplace(r," +(?=\\)")
	r:=RegExReplace(r,"(?<=\\) +")
	RegWrite, REG_SZ, HKCU, Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, % r
	Run regedit
	return
}