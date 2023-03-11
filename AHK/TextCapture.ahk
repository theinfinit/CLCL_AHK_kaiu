#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
CoordMode Mouse
CoordMode Cursor
#NoTrayIcon

;========== Настройки =============
sound:=1 ; звук при захвате буфера
trim:=1 ; обрезка начальных и конечных пробелов по умолчанию
delete_dup:=1 ; удаление дупликатов
noclose:=1 ; не закрывть окно при копировании заметок из графического интерфейса
sep_list:="\r\n|\r\n\r\n|\r\n\r\n\r\n|\r\n=======================\r\n|\r\n\r\n\t\t\t--- \i ---\r\n|\r\n\r\n### [\h](\u)\r\n| <...> " ; разделители (смотри ReadMe)
max_empty:=2 ; - максимальное число пустых строк в скопированном тексте
header_path:=0 ; преобразовывать заголовки, содержащие полные пути к имени файла с расширением (1) или без (2)
header_app:=0 ; удалять имя приложения из заголовка, прописанное в конце через тире
logs:="Logs" ; папка логирования захватов (пусто - без логирования)

;=======================================================
title_add:="буфера обмена"
Loop 2
{
	If (A_Args[A_Index]~="-\d+")
		sep_n:=RegExReplace(A_Args[A_Index],"^-")
	Else If A_Args[A_Index]="-k"
		k_copy:=1, title_add:="по горячей клавише (-k)"
	Else If A_Args[A_Index]="-m"
		m_copy:=1, title_add:="многстраничный (-m)"
	Else If A_Args[A_Index]="-s"
		s_copy:=1, title_add:="выделенного текста (-s)"
}
If !sep_n
	sep_n:=1
clip:=[], title:=[], url:=[]
OnClipboardChange("ClipChanged")
goto GUI

#If s_copy
~LButton::
	Sleep 50
	MouseGetPos x0, y0
	cx0:=A_CaretX, cy0:=A_CaretY, t0:=A_TickCount
	If (A_ThisHotkey=A_PriorHotkey && A_TimeSincePriorHotkey<400) {
		Hotkey If, s_copy
		Hotkey ~LButton, Off
		KeyWait LButton
		KeyWait LButton, T0.4 D
		Hotkey ~LButton, On
		Sleep 100
		Clipboard:=""
		Send ^{vk43}
		ClipWait 0.5
		Return
	}
	KeyWait LButton
	MouseGetPos x1, y1
	If (A_TickCount-t0>400) || (Sqrt((x1-x0)**2+(y1-y0)**2)>50) || (Sqrt((A_CaretX-cx0)**2+(A_CaretY-cy0)**2)>50) {
		Sleep 100
		Clipboard:=""
		Send ^{vk43}
		Clipwait 0.5
	}	
     Return

~^vk41 up::
	KeyWait Ctrl
	Sleep 100
	Clipboard:=""
	Send ^{vk43}
	ClipWait 0.5
	Return
	
~+Left::
~+Right::
~+Up::
~+Down::
~+PgDN::
~+PgUp::
~+Home::
~+End::
	cx0:=A_CaretX, cy0:=A_CaretY, t0:=A_TickCount
	KeyWait Shift
	If (A_TickCount-t0>300) || (Sqrt((A_CaretX-cx0)**2+(A_CaretY-cx0)**2)>50) {
		Sleep 100
		Clipboard:=""
		Send ^{vk43}
		ClipWait 0.5
	}
	Return
	
#If m_copy
~RCtrl::
	If !GetKeyState("LButton")
		Return
	KeyWait RCtrl, T2
	If ErrorLevel
		Return
	MouseMove 150, 0, 10, R
	Send ^{End}
	MouseMove % A_ScreenWidth//2, % A_ScreenHeight//2
	KeyWait LButton, T15
	If GetKeyState("RButton","P") {
		ToolTip Отменено!, % A_ScreenWidth//2, % A_ScreenHeight//2
		Sleep 700
		ToolTip
		Return
	}
	Clipboard:=""
	Send ^{vk43}
	ClipWait 0.5
	Return

#If k_copy
^Ins::
^NumpadIns::
>^vk43::
	KeyWait Ctrl, T1
	Clipboard:="", key_sel:=1
	Send ^{vk43}
	ClipWait 0.5
	SetTimer KeySel, -600
	Return
#If

KeySel:
	key_sel:=0
	Return

ClipChanged() {
	Global
	Sleep 200
	cl:=Clipboard
	If (k_copy && !key_sel) || (s_copy && (StrLen(cl)<20))
		Return
	If cl && !stop
	{		
		If delete_dup {
			Loop % clip.Length()
				If (cl=clip[A_Index]) {
					ToolTip Дубликат!, % A_ScreenWidth//2, $ A_ScreenHeight//2
					Sleep 600
					ToolTip
					Return
				}
		}
		n++
		clip[n]:=cl
		WinGetActiveTitle t
		If header_path && RegExMatch(t,"[a-zA-Z]:\\.+\.\w{2,8}",t_path)
		{
			SplitPath t_path, ttt,,, tt
			t:=(header_path=2) ? tt : ttt
		}
		Else If header_app
			t:=RegExReplace(t," - [^-\.]+$")		
		title[n]:=t
		add:=CopyAddress()
		If !(add~="^https?://")
			add:=""
		url[n]:=add
		LV_Add("Check",n,cl)
		If sound
			SoundBeep 400, 300
	}
	Return
}

GUI:
Gui Default
Gui +hWndGuiHwnd -DPIScale +LastFound
Gui Margin, 15, 15
Gui Font, s10
Gui Color, 72A0C1
Gui Add, ListView, vlistvar x15 w800 h500 Grid -Multi NoSortHdr Checked 0x2000, N|Text
LV_ModifyCol(1,"50 Center")
Gui Add, Button, x55 y+10 w350 h28 gMoveDown, Смещение вниз
Gui Add, Button, x+20 yp wp hp gMoveUp, Смещение вверх
Gui Add, Text, x65 y+10 +0x200, Разделитель:
Gui Add, ComboBox, x200 yp w575 vsep, % sep_list
Gui Add, CheckBox, x65 y+10 vtrim, Исключение дубликатов
Gui Add, CheckBox, x360 yp vdelete_dup, Обрезка начальных и конечных пробелов
Gui Add, Button, x55 y+10 w350 h28 gCopyFIFO, Копирование FIFO
Gui Add, Button, x+20 yp wp hp gCopyFILO, Копирование FILO
GuiControl,, Button3, % delete_dup
GuiControl,, Button4, % trim
GuiControl, Choose, Edit1, % sep_n
Gui Show, Minimize, % "Захват " title_add
Return

GuiClose:
	ExitApp

#If WinActive("ahk_id " GuiHwnd)
Escape::WinMinimize A
#If

+Space::
	If WinActive("ahk_id " GuiHwnd)
		WinMinimize
	Else
		WinActivate % "ahk_id " GuiHwnd
	Return
	
CopyFILO:
	rev:=1
CopyFIFO:
	KeyWait LButton
	Gui Submit, Nohide	
	rn:=0, Clipboard:=out:=clip_list:=rev_list:="", stop:=1
	SetTimer StartCapture, -1500
	Loop {
		rn:=LV_GetNext(rn,"C")
		If !rn
			break
		LV_GetText(clipn,rn,1)
		clip_list.=clipn ","
	}
	If rev {
		Loop Parse, clip_list, CSV
			rev_list:=A_LoopField "," rev_list
		clip_list:=rev_list
	}
	clip_list:=RegExReplace(clip_list,",$")
	clip_list:=RegExReplace(clip_list,"^,")
	sep:=StrReplace(sep,"\r","`r")
	sep:=StrReplace(sep,"\n","`n")
	sep:=StrReplace(sep,"\t","`t")
	Loop Parse, clip_list, CSV
	{
		If sep contains % "\i,\h,\u"
		{
			header:=StrReplace(sep,"\i",A_Index)
			header:=StrReplace(header,"\h",title[A_LoopField])
			header:=StrReplace(header,"\u",url[A_LoopField])
		}
		Else If (A_Index=1)
			header:=""
		Else
			header:=sep
		txt:=clip[A_LoopField]
		txt:=MaxEmptyString(txt,max_empty)
		If trim
			txt:=Trim(txt)
		out.= header . txt
	}
	out:=RegExReplace(out,"^\R+")
	If logs {
		FileCreateDir % logs
		FileAppend % out, % logs "\" A_YYYY "." A_MM "." A_DD "_" A_Hour "." A_Min "." A_Sec ".txt", UTF-8
	}
	Clipboard:=out, rev:=0
	If (Clipboard  && !hkey) {
		ToolTip Скопировано!
		Sleep 600
		ToolTip
	}	
	If !noclose && !hkey
		ExitApp
	Return
	
StartCapture:
	stop:=0
	Return

>^vk56::  ; RCtrl+V - вставка в прямом порядке и выход
	hkey:=1
	gosub CopyFIFO
	Send ^{vk56}
	ExitApp
	
>^>+vk56:: ; RCtrl+RShift+V - вставка в обратном порядке и выход
	hkey:=1
	gosub CopyFILO
	Send ^{vk56}
	ExitApp

MoveUp:
	LVMoveRow()
return

MoveDown:
	LVMoveRow(false)
return

LVMoveRow(Up := True) {
    CO := [], TO := [], F := LV_GetNext("F"), N := F + (Up ? -1 : 1)

    If (!N) || (N > LV_GetCount()) || (!F) {
        return
    }

    Loop, % LV_GetCount("Col") {
        LV_GetText(CT, F, A_Index), LV_GetText(TT, N, A_Index), CO.Push(CT), TO.Push(TT)
    }

    Loop, % CO.MaxIndex() {
        LV_Modify(F, "Col" A_Index, TO[A_Index]), LV_Modify(N, "Col" A_Index, CO[A_Index])
    }

    LV_Modify(F, "-Select"), LV_Modify(N, "Select")
}
	
