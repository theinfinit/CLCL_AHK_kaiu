/*
Скрипт для быстрого обрамления текста. Скрипту посылаются "начало" и "конец" (кавычки обязательны) как параметры командной строки. Выделенный текст ставится в промежутке, если его нет производится вставка с перемещением на позицию ввода. Если текст уже содержит обрамление, оно удаляется. Не работает из меню истории.
*/

If !A_Args[1] || !A_Args[2] {
	MsgBox, 32, , Ошибка параметров командной строки!, 1.5
	ExitApp
}

Clipboard:=""
Send ^{vk43}
ClipWait 0.5
If (text:=Trim(Clipboard)) {
	Send {Del}
	If (A_Args[1]=SubStr(text,1,StrLen(A_Args[1]))) && (A_Args[2]=SubStr(text,StrLen(text)-StrLen(A_Args[2])+1,StrLen(A_Args[2])))
		
		SendInput % "{Raw}" SubStr(text,StrLen(A_Args[1])+1,StrLen(text)-StrLen(A_Args[2])-StrLen(A_Args[1]))
	else
		SendInput % "{Raw}" A_Args[1] . text . A_Args[2]
}
else {
	SendInput % "{Raw}" A_Args[1] . text . A_Args[2]
	SendInput % "{Left " StrLen(A_Args[2]) "}"
}
ExitApp
	