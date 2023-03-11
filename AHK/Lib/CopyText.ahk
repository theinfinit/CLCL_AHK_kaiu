CopyText(mclick=0) ; таймер/выделение по клику
{
	IfWinActive ahk_class VirtualConsoleClass
		Send {Esc}
	ClipBoard:=""
	start:
	Loop 3
	{
		Send ^{vk43}
		ClipWait 0.1
		If Clipboard
			break
	}
	If !Clipboard && mclick
	{
		WinGetClass cl, A
		If cl not contains MS_WINDOC
			MouseClick Left, , , 2, 50
		mclick:=0
		goto start
	}
	return Trim(ClipBoard)
}
