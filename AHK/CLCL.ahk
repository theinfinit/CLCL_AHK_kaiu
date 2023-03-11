#NoEnv
SetWorkingDir %A_ScriptDir%
#SingleInstance, force
#NoTrayIcon

;=============================================
insert_hotkey:="^+F11" ; горячая клавиша вставки текста; должна совпадать с выставленной в программе в Сервис - Настройка - Клавиши - Вставить.
template_hotkey:="!vk51" ; Alt+Q - горячая клавиша вызова шаблонов

;========= Индикация изменения буфера ========
show:=1 ; отображать изменившийся буфер в виде всплывющего окна
bitmap:=1 ; отображать и изменения нетекстового буфера
empty:=0 ; отображать очистку буфера
exclude:="JPEGView.exe,AutoHotkey.exe" ; исполняемые файлы приложений, в которых не показывается текстовый буфер, через запятую
font:=12 ; размер шрифта
font_color:="FEFEFE" ; цвет шрифта
color:="56819E" ; цвет фона
lines:=2 ; число показываемых первых непустых строк
shift:=0 ; вертикальное смещение
time:=1500 ; время показа, мс

;============ Настройки автоматического бэкапа ============
count:=30 ; общее число бэкапов (0 - выключение)
history:=0 ; сохранять и историю буфера (файл history.dat)
interval:=6 ; интервал, часов (всегда производится при запуске)
history_del:=0 ; удалять историю при запуске (-1 - при выходе)

;==========================================
; Кодировки виртуального скрипта, соответствующие его расширению (по умолчанию ANSI (1251))
ahk:="UTF-8"
au3:="UTF-8"
bat:=cmd:=866
py:="UTF-8-RAW"

;==========================================
; Испоняемые файлы (полный или относительный путь) для соответствующих расширений (не нужны, если имеется ассоциация или не интересует портативность)
_ahk:="AutoHotkey.exe"
_au3:="AutoIt3.exe"
_bat:=_cmd:=A_ComSpec " /c"


;===========================================
SysGet, D, Monitor
SysGet, M, MonitorWorkArea
root_folder:=RegExReplace(A_ScriptDir,"\\AHK$")
gosub Backup
Run % root_folder "\CLCL\CLCL.exe"
If history_del>0
	FileDelete % root_folder "\CLCL\history.dat"	
SetTimer Backup, % interval * 3600000
SetTimer Exit, 200
Hotkey % "~" insert_hotkey, Insert
Hotkey % "~" template_hotkey, Template
RegExMatch(template_hotkey,"^[\^!+#]+",hpr)
t_hotkey:=hpr "{" SubStr(template_hotkey, StrLen(hpr)+1) "}"
OnClipboardChange("ClipChanged")
return

Insert:
	KeyWait LButton, T1
	KeyWait Enter, T1
	KeyWait NumpadEnter, T1
	Sleep 200
	clip:=Clipboard, ext:=script:=text_script:=launch:=""
	If RegExMatch(clip,"^\s*#+\K[^#\r\n]+?(?=#)",header) {
		script:=RegExReplace(clip,"^\s*#[^\r\n]+#")
		RegExMatch(header,"^(\+|-)",prefix)
		RegExMatch(header,"(-|=)$",suffix)
		If (suffix="-")
			launch:="Min"
		If (suffix="=")
			launch:="Hide"
		RegExMatch(header,"^(\+|-)?\K.+?(?=(-|=)?$)",ext)
		If RegExMatch(ext,".+\.\K\w{1,5}$",end) {
			text_script:=Trim(ext), ext:=end
			RegExMatch(clip,"^\s*#+[^#\r\n]+#+\K.+",cmdline)
			cmdline:=RegExReplace(cmdline,"#+\s*$")
		}
		else {
			StringLower ext, ext
			enc:=%ext% ? %ext% : 1251
			enc:=(enc~="^\d+$") ? "CP" enc : enc
		}
		exe:="_" ext, runfile=%exe%
		runfile:=(runfile && !(ext~="^(bat|cmd)$")) ? """" runfile """ " : runfile " "
	}
	If ext {
		If (A_PriorHotkey="~!vk43") || WinActive("ahk_class CLCLViewer")
			return
		If !prefix && !menu 
			Clipboard:=clip_all
		If menu
			prefix:="", Clipboard:=clip_old
		If prefix {
			Clipboard:=""
			Send ^{vk43}
			ClipWait 0.5
			If !Clipboard {
				MsgBox, 32, , Ничего не выделено!, 1.5
				return
			}
			If (prefix="-")
				Send {Del}
		}
		If text_script {
			If !FileExist(text_script) {
				MsgBox, 16, , % "Отсутствует скрипт`n" text_script, 1.5
				return
			}
			Run % runfile """" text_script """" (cmdline ? " " cmdline : ""),, % launch, pid 
		}
		else {
			FileDelete % "temp.*"
			FileAppend % script, % "temp." ext,% enc	
			Run % runfile "temp." ext,, % launch, pid
		}
		menu:=""
		Loop 300 {			
			Process Exist, % pid
			If !Errorlevel
				break
			Sleep 10
		}
	}
	else If !menu
		Send ^{vk56}
	Sleep 500
OnEndTask:
	SetTimer OnEndTask, Off
	ClipChanged(1)
	return
	
!1::
!2::
!3::
!4::
!5::
!6::
!7::
!8::
!9::
KeyWait Alt, T0.8
If erl:=ErrorLevel
	Hotkey % "~" insert_hotkey, Insert, Off
KeyWait Alt
keyn:=RegExReplace(A_ThisHotkey,"!")
;Sleep 100
Send !{vk43}
WinWait ahk_class #32768 ahk_exe CLCL.exe
Send % "{" keyn "}"
If (keyn=1) && WinExist("ahk_class #32768 ahk_exe CLCL.exe")
	Send {Enter}
Sleep 300
If erl
	Hotkey % "~" insert_hotkey, Insert, On
Return


#If WinExist("ahk_class #32768 ahk_exe CLCL.exe")
MButton::
Ctrl::
LAlt::
RAlt::
	KeyWait MButton, T1
	KeyWait Ctrl, T1
	KeyWait LAlt, T1
	KeyWait RAlt, T1
	Hotkey % "~" insert_hotkey, Insert, Off
	menu:=1
	Clipboard:=""
	Send {Enter}
	ClipWait 1, 1
	clip_old:=ClipboardAll
	Sleep 200
	Send % t_hotkey	
	Sleep 200
	Hotkey % "~" insert_hotkey, Insert, On
	return	
#If

~!vk43::
Template:
	menu:=""
	return
	
ClipChanged(e) {
	global	
	SetTimer ClipbShow, Off
	Gui Destroy
	Sleep 150
	old:=new, new:=Clipboard, text:=""
	If !(new~="^\s*#+\K[^#\r\n]+?(?=#)")
		clip_all:=ClipboardAll
	WinGet exe_file, ProcessName, A
	If exe_file in % exclude
		return
	WinGetPos, , , width, height, A
	If (width>=DRight && height>=DBottom) || !show
		return
	If (e=0 && empty)
		text:="### Empty! ###"
	If (e=2 && bitmap)
		text:="### Bitmap? ###"
	If (e=1)
	{
		n:=0, text:=""
		Loop Parse, new, `r, `n
		{
			If A_LoopField~="^\s*$"
				continue
			n+=1, string:=Trim(A_LoopField)
			If (StrLen(string)>80)
				string:=SubStr(string,1,80) " (...)"
			text.=string "`r`n"
			If (n=lines)
				break
		}
	}	
	If text {
		Sleep 100
		Gui font, s%font% Tahoma
		Gui Margin , 6, 2
		Gui Color, % color
		Gui, +AlwaysOnTop -Caption +ToolWindow -DPIScale +HwndGuiHwnd +LastFound
		Gui, Add, Text, c%font_color% gClipbShow,% RegExReplace(text,"\R$")
		Gui Show, NA y%MBottom% xCenter
		WinGetPos,,,, height
		WinMove,,,, % MBottom-height-shift
		SetTimer ClipbShow, % time
	}
	return
}

ClipbShow:
	SetTimer ClipbShow, Off
	Gui Destroy
	return
	
Backup:
	If !count
		return
	folder:=root_folder "\Backup\" A_YYYY "." A_MM "." A_DD "_" A_Hour "." A_Min "." A_Sec
	FileCreateDir % folder
	FileCopy % root_folder "\CLCL\regist.dat", % folder
	FileCopy % root_folder "\CLCL\clcl.ini", % folder
	FileCopy % A_ScriptName, % folder
	If history
		FileCopy % root_folder "\CLCL\history.dat", % folder
	Loop Files, % root_folder "\backup\20*.*", D
		number:=A_Index
	Loop Files, % root_folder "\backup\20*.*", D
		If (A_Index<number-count+1)
			FileRemoveDir % A_LoopFileFullPath, 1
	return
	
Exit:
	Process Exist, CLCL.exe
	If !Errorlevel
		exit++
	If (exit>4) {
		If history_del<0
			FileDelete % root_folder "\CLCL\history.dat"
		ExitApp
	}
	return

