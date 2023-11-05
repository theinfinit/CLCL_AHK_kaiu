#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
CoordMode Mouse
CoordMode Cursor
#NoTrayIcon

;========== Configuration =============
sound:=1 ; enable sound when capturing the buffer
trim:=1 ; by default trim leading and ending spaces
delete_dup:=1 ; delete duplicates
noclose:=1 ; do not close the window when copying notes from the graphic interface
sep_list:="\r\n|\r\n\r\n|\r\n\r\n\r\n|\r\n=======================\r\n|\r\n\r\n\t\t\t--- \i ---\r\n|\r\n\r\n### [\h](\u)\r\n| <...> " ; separators (see ReadMe)
max_empty:=2 ; - maximum number of empty lines in copied text
header_path:=0 ; convert headers containing full paths to filename with extension (1) or without (2)
header_app:=0 ; remove application name from header, written at the end through a dash
logs:="Logs" ; logging folder for captures (empty - no logging)

;=======================================================
title_add:="clipboard"
Loop 2
{
	If (A_Args[A_Index]~="-\d+")
		sep_n:=RegExReplace(A_Args[A_Index],"^-")
	Else If A_Args[A_Index]="-k"
		k_copy:=1, title_add:="triggered by hotkey (-k)"
	Else If A_Args[A_Index]="-m"
		m_copy:=1, title_add:="multi-page capture (-m)"
	Else If A_Args[A_Index]="-s"
		s_copy:=1, title_add:="of selected text (-s)"
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
Gui Add, Button, x55 y+10 w350 h28 gMoveDown, Move Down
Gui Add, Button, x+20 yp wp hp gMoveUp, Move Up
Gui Add, Text, x65 y+10 +0x200, Separator:
Gui Add, ComboBox, x200 yp w575 vsep, % sep_list
Gui Add, CheckBox, x65 y+10 vtrim, Exclude Duplicates
Gui Add, CheckBox, x360 yp vdelete_dup, Trim Spaces at Both Ends
Gui Add, Button, x55 y+10 w350 h28 gCopyFIFO, Copy in 'First In First Out' Order ▼
Gui Add, Button, x+20 yp wp hp gCopyFILO, Copy in 'First In Last Out' Order ▲
GuiControl,, Button3, % delete_dup
GuiControl,, Button4, % trim
GuiControl, Choose, Edit1, % sep_n
Gui Show, Minimize, % "Capture " title_add
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

>^vk56::  ; RCtrl+V - trigger paste operation in the original order and exit
	hkey:=1
	gosub CopyFIFO
	Send ^{vk56}
	ExitApp
	
>^>+vk56:: ; RCtrl+RShift+V - trigger paste operation in reverse order and exit
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
	
