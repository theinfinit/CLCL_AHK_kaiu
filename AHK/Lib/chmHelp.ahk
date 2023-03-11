;~ zoom - число шагов масштабирования колесиком

chmHelp(file, text,zoom=0) {
	Run "%file%"
	WinWaitActive ahk_exe hh.exe
	WinMaximize
	Sleep 200
	If zoom
		SendInput % "^{WheelUp" zoom "}"
	Send {Alt}
	Send !{vk4E}
	Sleep 200
	Send ^{vk56}{Enter}
	return
}