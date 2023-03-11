; ==============================================================================
; CLCL_AHK
; ==============================================================================
; FileDescription: clipboard manager plus advanced text processing with Autohotkey and AutoIt =ru= менеджер буфера обмена плюс расширенная обработка текста средствами Autohotkey и AutoIt
; FileVersion: 1.0.3.0 2023-03-06 \\ (Major version).(Minor version).(Revision number).(Build number) (year)-(month)-(day)
; Author: kaiu@mail.ru \\ author of code changes 
; ProductName: CLCL_AHK \\ included in the product
; OriginalFilename: CLCL_AHK.ahk \\ What file is this code from
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Idea and author of the original code: http://forum.ru-board.com/topic.cgi?forum=5&topic=50494&start=0
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
#NoEnv ; skip undefined variables =ru= не заданные переменные пропускать 
SetWorkingDir %A_ScriptDir% ; working directory like a script =ru= рабочий каталог как у скрипта
#SingleInstance, force ; running only one copy () =ru= запуск только одной копии (с перезагрузкой)
#NoTrayIcon ; disables the display of the tray icon =ru= отключает отображение значка в трее
DetectHiddenWindows, On ; Determines whether invisible windows are "seen" by the script =ru= определять скрытые окна
SetBatchlines, -1 ; Determines the script execution speed (affects CPU usage) and by default 10ms, and now max. speed =ru= Определяет скорость выполнения скрипта (влияет на загрузку ЦП) и по умолчанию 10ms, а сейчас макс. скорость
Process, Priority, , High ; high priority for the script =ru= приоритет высокий для скрипта
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Program language (EN or RU or JP) =ru= язык программы (EN или RU или JP)
ProgramLanguage:="RU" ; !!! if not Russian, then download the files CLCL https://github.com/AndreyKaiu/CLCL-EN-RU-JP-Plugins/blob/main/To-the-website/EN/clcl_all_plugins_Ver_2_1_3_3_EN.zip 
; FOR JP https://github.com/AndreyKaiu/CLCL-EN-RU-JP-Plugins/blob/main/To-the-website/JP/clcl_all_plugins_Ver_2_1_3_3_JP.zip
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; backup settings =ru= настройки резервного копирования 
BackupСountDay:=10 ; Backup counter per day (0 - disable) =ru= Счетчик резервных копий в день (0 - выключение)
BackupСountMaxMonth:=50 ; Backup counter maximum per month =ru= Счетчик резервных копий максимально в месяц
BackupHistory:=0 ; save buffer history (file "history.dat") =ru= сохранять историю буфера (файл "history.dat")
BackupHours:=6 ; interval, hours (always done at startup) =ru= интервал, часы (всегда производится при запуске)
DeleteHistory:=0 ; delete history on startup (-1 on exit) =ru= удалять историю при запуске (-1 при выходе)
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Ctrl+Shift+F11 - text insert hotkey =ru= горячая клавиша вставки текста
insert_hotkey:="^+F11" 
insert_hotkey_send:="{Ctrl down}{Shift down}{F11}{Shift up}{Ctrl up}"
; LAlt+Q - hot key for calling the context menu with script templates =ru= горячая клавиша вызова контекстного меню с шаблонами скриптов
template_hotkey:="<!vk51" 
template_hotkey_send:="{LAlt Down}{vk51}{LAlt Up}" 
run_last_script:="<+<!vk51" ; Shift+LAlt+Q - hotkey for executing the last script =ru= горячая клавиша выполнения последнего скрипта
IF_ExLastScript:=1 ; execute last script on hotkey =ru= выполнять последний скрипт по горячей клавише
; LAlt+C - hot key for calling the context menu with items 1..9 pasting the clipboard =ru= горячая клавиша вызова контекстного меню с пунктами 1..9 вставки буфера обмена 
selection_hotkey:="<!vk43"
selection_hotkey_send:="{LAlt Down}{vk43}{LAlt Up}"
IF_LAlt1_9:=1 ; pasting the last nine buffer versions (LAlt+1..9) =ru= вставка последних девяти версий буфера (LAlt+1..9)
BuffShow:=1 ; display popup buffer =ru= отображать всплывающий буфер 
; CLCL opens a template with a menu for editing while holding down Ctrl + Shift, if the file is registered in 1 line, it will also open it for editing
; =ru= CLCL открывает на редактирование шаблон с меню при удержании Ctrl+Shift, если же прописан файл в 1 строке, то откроет и его на редактирование
IF_CtrlShiftEdit:=1 
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; display popup buffer =ru= отображать всплывающий буфер 
BuffBitmap:=1 ; and display non-text buffer changes =ru= и отображать изменения не текстового буфера
BuffEmpty:=0 ; and display buffer clearing =ru= и отображать очистку буфера
; executable application files that do not display a text buffer, separated by commas
; =ru= исполняемые файлы приложений, в которых не показывается текстовый буфер, через запятую
BuffExclude:="JPEGView.exe,AutoHotkey.exe,AutoHotkeyU32.exe" 
; if not empty, then show text buffer only in these applications
; =ru= если не пусто, то показывать текстовый буфер только в этих приложениях
;BuffIncludeOnlyIn:="notepad++.exe,WINWORD.EXE"
BuffFont:=16 ; font size =ru= размер шрифта
BuffFontColor:="f7f7a1" ; font color =ru= цвет шрифта
BuffColor:="000000" ; background color =ru= цвет фона
BuffLines:=2 ; the number of first non-blank lines to show =ru= число показываемых первых непустых строк
BuffShift:=0 ; vertical offset =ru= вертикальное смещение
BuffTime:=1500 ; display time, ms =ru= время показа, мс
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; virtual script encodings corresponding to its extension (default ANSI (1251))
; =ru= кодировки виртуального скрипта, соответствующие его расширению (по умолчанию ANSI (1251))
ahk:="UTF-8"
au3:="UTF-8"
bat:=cmd:=866
py:="UTF-8-RAW"
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Executables (full or relative path) for appropriate extensions (not needed if there is an association or not interested in portability)
; =ru= Испоняемые файлы (полный или относительный путь) для соответствующих расширений (не нужны, если имеется ассоциация или не интересует портативность)
_ahk:="AutoHotkeyU32.exe"
_au3:="AutoIt3.exe"
_bat:=_cmd:=A_ComSpec " /c"
; script editor location (the first one found)
; =ru= расположение редактора скриптов (первый который будет найден)
NotepadFullName:="C:\Program Files\Notepad++\notepad++.exe"
NotepadFullNameAlt:="C:\Program Files (x86)\Notepad++\notepad++.exe"
NotepadSys:="C:\Windows\System32\notepad.exe"
NameFileTMP := "" ; last file with executable script =ru= последний файл с выполняемым скриптом
LastRunCMD:="" ; last executed commands =ru= последние выполняемые команды
LastRunCMDLaunch:="" ; startup type =ru= тип запуска

; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; variables dependent on the language of the program =ru= переменные зависящие от языка программы
if(ProgramLanguage=="EN") {
  MSG1 := "Nothing selected!"
  MSG2 := "Missing script`n"
}
; Add your languages or replace this block with your language =ru= добавьте ваши языки или замените этот блок под свой язык
else if(ProgramLanguage=="RU") { 
  MSG1 := "Ничего не выделено!"
  MSG2 := "Отсутствует скрипт`n"  
}
else if(ProgramLanguage=="JP") { 
  MSG1 := "何も選択されていません!"
  MSG2 := "スクリプトがありません`n"  
}

; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; important actions when running the script =ru= важные действия при запуске скрипта
clcl_clwt := -1 ; is the clipboard observed in CLCLViewer =ru= наблюдается ли буфер обмена в CLCLViewer  
SysGet, D, Monitor
SysGet, M, MonitorWorkArea
root_folder:=RegExReplace(A_ScriptDir,"\\AHK$")
gosub TimerBackup ; backup on startup =ru= при запуске резервная копия 
Run % root_folder "\CLCL\CLCL.exe"
If DeleteHistory > 0
    FileDelete % root_folder "\CLCL\history.dat"   
; backup timer =ru= таймер резервных копий 
SetTimer TimerBackup, % BackupHours * 3600000
SetTimer TimerExit, 200 ; terminate the script if the CLCL.exe process is terminated =ru= завершить скрипт если процесс CLCL.exe завершен 
Hotkey % insert_hotkey, InsertHK
Hotkey % "~" template_hotkey, TemplateHK
Hotkey % "~" selection_hotkey, SelectionHK
if(IF_ExLastScript==1)
    Hotkey % run_last_script, RunLastHK
if(IF_CtrlShiftEdit==1) {
    Hotkey % "~<^<+vk0D", CtrlShiftEdit
    Hotkey % "~<^<+LButton", CtrlShiftEdit2
}
OnClipboardChange("ClipChanged") ; buffer change handler function =ru= функция обработчик изменения буфера
; what editor exists =ru= какой редактор существует
if !FileExist(NotepadFullName) 
    NotepadFullName := NotepadFullNameAlt
if !FileExist(NotepadFullName) 
    NotepadFullName := NotepadSys
if !FileExist(NotepadFullName)
    NotepadFullName := ""    

SetTimer, TimerON_clcl_clwt, Off ; timer enable clipboard monitoring in CLCLViewer =ru= таймер включения наблюдения буфера обмена в CLCLViewer  
SetTimer, TimerClosePopUp, Off ; close check timer "PopUp" =ru= таймер проверки закрытия PopUp 

return


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; timer enable clipboard monitoring in CLCLViewer
; =ru= по таймеру включаем наблюдение буфера обмена в CLCLViewer
TimerON_clcl_clwt:
  SetTimer, TimerON_clcl_clwt, Off
  if (clcl_clwt == 1)
  {
    ; enable clipboard monitoring in CLCLViewer =ru= включаем наблюдение буфера обмена в CLCLViewer 
    SendMessage,0x8067,1,0,,ahk_class CLCLMain,,,,100 
  }
  clcl_clwt := -1
return


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; close check timer "PopUp" =ru= таймер проверки закрытия PopUp 
TimerClosePopUp:
    If( !WinExist("ahk_class #32768") )
  {    
    SetTimer, TimerClosePopUp, Off
    SetTimer, TimerON_clcl_clwt, 200        
  }  
return


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−  
; call context menu with script templates =ru= вызов контекстного меню с шаблонами скриптов
TemplateHK:  
  menu:=""        
  SetTimer, TimerON_clcl_clwt, Off ; timer enable clipboard monitoring in CLCLViewer =ru= таймер включения наблюдения буфера обмена в CLCLViewer  
  SetTimer, TimerClosePopUp, Off ; close check timer "PopUp" =ru= таймер проверки закрытия PopUp 
  
  if (clcl_clwt == -1)
  {    
    ; get clipboard monitoring status in CLCLViewer =ru= получим статус наблюдение буфера обмена в CLCLViewer
    SendMessage,0x8066,0,0,,ahk_class CLCLMain,,,,100 
    clcl_clwt := ErrorLevel  
    if (clcl_clwt == "FAIL")
        clcl_clwt := -1  
  }     
  
  ; disable clipboard monitoring in CLCLViewer
  ; =ru= отключаем наблюдение буфера обмена в CLCLViewer
  SendMessage,0x8067,0,0,,ahk_class CLCLMain,,,,100    
  SetTimer, TimerClosePopUp, 200 ; close check timer "PopUp" =ru= таймер проверки закрытия PopUp 
return


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; LAlt + C and you need to remove the call label from the menu =ru= LAlt+C и надо убрать метку вызова с меню
SelectionHK:
  menu:=""
  return 

; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; received command to insert text =ru= получена команда на вставку текста
InsertHK:  
  SetTimer, TimerON_clcl_clwt, Off ; timer enable clipboard monitoring in CLCLViewer =ru= таймер включения наблюдения буфера обмена в CLCLViewer  
  SetTimer, TimerClosePopUp, Off ; close check timer "PopUp" =ru= таймер проверки закрытия PopUp   
  SetTimer, TimerON_clcl_clwt, 5000 ; timer enable clipboard monitoring in CLCLViewer =ru= таймер включения наблюдения буфера обмена в CLCLViewer  
  
    KeyWait LButton, T1
    KeyWait Enter, T1
    KeyWait NumpadEnter, T1
    Sleep 20
    clipLastScript:=""
    clip:=Clipboard, ext:=script:=text_script:=launch:=""  
    SetTimer ClipShow, Off    
    
    If RegExMatch(clip,"^\s*#+\K[^#\r\n]+?(?=#)",header) {
        script:=RegExReplace(clip,"^\s*#[^\r\n]+#")
        RegExMatch(header,"^[\+\-\*]",prefix)
        RegExMatch(header,"(-|=)$",suffix)
        If (suffix="-")
            launch:="Min"
        If (suffix="=")
            launch:="Hide"
        RegExMatch(header,"^[\+\-\*]?\K.+?(?=(-|=)?$)",ext)
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
  
      
    If ext { ; if before that there was a menu call LAlt + C, then do not execute =ru= если до этого был вызов меню LAlt+C, то не исполнять
        If (A_PriorHotkey="~<!vk43")
            return
      
        If !prefix && !menu 
            Clipboard:=clip_all            
        If menu
            prefix:="", Clipboard:=clip_old            
        SetTimer ClipShow, Off        
        If prefix {
            Clipboard:=""
            SetTimer ClipShow, Off
            SetKeyDelay -1
            If (prefix="*") {            
                ; if it is important to cut (the document gives access to change) =ru= если важно именно вырезать (документ дает доступ на изменение)
                SendEvent {LCtrl down}{vk58}{LCtrl up}                                               
                ClipWait 0.5   
                SetTimer ClipShow, Off
                If !Clipboard {
                    MsgBox, 32, , %MSG1%, 1.5
                    goto InsertHKReturn
                }
            }     
            else {                                
                SendEvent {LCtrl Down}{vk43}{LCtrl Up} ; LCtrl+C  (prefix="-" OR prefix="+")
                ClipWait 0.5
                SetTimer ClipShow, Off
                If !Clipboard {
                    MsgBox, 32, , %MSG1%, 1.5
                    goto InsertHKReturn
                }
                If (prefix="-") { 
                    SendEvent {Del} ; if it is important to send Del =ru= если важно послать Del
                    Sleep 50                            
                }
            }
        }
        
        If text_script {
            NameFileTMP := ""
            If !FileExist(text_script) {
                MsgBox, 16, , % MSG2 text_script, 1.5
                goto InsertHKReturn
            }
            NameFileTMP := text_script 
            LastRunCMD = % runfile """" text_script """" (cmdline ? " " cmdline : "")
            LastRunCMDLaunch = launch
            clipLastScript:=Clip
            SetTimer ClipShow, Off
            Run % runfile """" text_script """" (cmdline ? " " cmdline : ""),, % launch, pid 
        }
        else {
            NameFileTMP := "temp."+ext            
            fileTEMP := FileOpen(NameFileTMP,"w-wd",enc) 
            if !IsObject(fileTEMP)
            {
                MsgBox,,, % "Error creating """ NameFileTMP """ file"
                NameFileTMP := ""
            }
            else {
                fileTEMP.Length := 0
                fileTEMP.Write(script)
                fileTEMP.Close()                           
                clipLastScript:=Clip
                SetTimer ClipShow, Off
                Run % runfile "temp." ext,, % launch, pid
            }            
        }
        menu:=""
        Loop 300 {            
            Process Exist, % pid
            If !Errorlevel
                break
            Sleep 10
        }                
        ClipWait 0.5 
        SetTimer ClipShow, Off
    }
    else If !menu
    {    
        SetKeyDelay -1
        SendEvent {LCtrl Down}{vk56}{LCtrl Up} ; LCtrl+V          
        ClipWait 0.5 
        SetTimer ClipShow, Off    
    }
    
  SetTimer, TimerON_clcl_clwt, Off ; отключим таймер включения наблюдения буфера обмена в CLCLViewer    
  SetTimer, TimerON_clcl_clwt, 500    
  
  ; display popup buffer =ru= отображать всплывающий буфер 
  ClipChanged(1)     
  
return

  
InsertHKReturn:
  SetTimer, TimerON_clcl_clwt, Off ; отключим таймер включения наблюдения буфера обмена в CLCLViewer    
  SetTimer, TimerON_clcl_clwt, 200  
return  

; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; execute last script on hotkey =ru= выполнять последний скрипт по горячей клавише
#IF (IF_ExLastScript=1)
RunLastHK:    
    if( clipLastScript != "" ){
        gosub TemplateHK
        Clipboard := clipLastScript
        SetTimer ClipShow, Off
        goto InsertHK
    }     
return
#IF


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; =ru= after Alt + C, you can apply Alt + Q to them, for which press the middle mouse button or Ctrl and release it
; после Alt+C можно применить к ним Alt+Q для чего нажать среднюю кнопку мыши или Ctrl и отпустить его
#IF WinExist("ahk_class #32768 ahk_exe CLCL.exe")
MButton::
Ctrl::  
    KeyWait MButton, T1
    KeyWait Ctrl, T1    
    
    Hotkey % "~" insert_hotkey, InsertHK, Off
            
    menu:=1
    Clipboard:=""
    SetKeyDelay -1
    SendEvent {LShift down}{Enter down}{Enter up}
    ClipWait 1, 1    
    clip_old:=ClipboardAll
    SendEvent {LShift up}
    Sleep 150 
    SendEvent %template_hotkey_send%            
    Sleep 150
    
    Hotkey % "~" insert_hotkey, InsertHK, On    
    
    return    
#IF
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
  
  
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−  
; backup the main files of the CLCL program
; =ru= резервное копирование основных файлов программы CLCL    
TimerBackup:
    If !BackupСountDay
        return   
        
    folder:=root_folder "\Backup\" A_YYYY "-" A_MM "-" A_DD " " A_Hour "-" A_Min "-" A_Sec
    FileCreateDir % folder
    FileCopy % root_folder "\CLCL\regist.dat", % folder
    FileCopy % root_folder "\CLCL\clcl.ini", % folder
    FileCopy % root_folder "\CLCL\tool_dll\*.ini", % folder
    FileCopy % A_ScriptName, % folder  
  
    If BackupHistory 
        FileCopy % root_folder "\CLCL\history.dat", % folder
    
    ; delete unnecessary files, after sorting the list
    ; =ru= удалим лишние файлы, перед этим отсортировав список
    FileList := ""  ; Initialize to be blank.
    Loop, Files, % root_folder "\Backup\" A_YYYY "-" A_MM "-" A_DD "*.*", D
    {
        FileList .= A_LoopFileFullPath "`n"            
    }
    Sort, FileList, R  ; The R option sorts in reverse order. See Sort for other options.
    Loop, Parse, FileList, `n
    {        
        if (A_LoopField = "")  ; Ignore the blank item at the end of the list.
            continue 
        If (A_Index > BackupСountDay)
            FileRemoveDir, %A_LoopField%, 1
    }    
        
    FileList := ""  ; Initialize to be blank.
    Loop, Files, % root_folder "\Backup\" A_YYYY "-" A_MM "*.*", D
    {
        FileList .= A_LoopFileFullPath "`n"            
    }
    Sort, FileList, R  ; The R option sorts in reverse order. See Sort for other options.
    Loop, Parse, FileList, `n
    {        
        if (A_LoopField = "")  ; Ignore the blank item at the end of the list.
            continue
        If (A_Index > BackupСountMaxMonth)
            FileRemoveDir, %A_LoopField%, 1
    }                   
            
    return
    
  
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−  
; terminate the script if we determine 4 times that the CLCL.exe process does not exist
; =ru= завершить скрипт если 4 раза определим, что процесс CLCL.exe не существует   
TimerExit:
    Process Exist, CLCL.exe
    If !Errorlevel
        nexit++
    
    If (nexit > 4) {
        If (DeleteHistory < 0) ; delete history on startup (-1 on exit) =ru= удалять историю при запуске (-1 при выходе)
            FileDelete % root_folder "\CLCL\history.dat"        
        ExitApp
    }
  
return



; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−  
; pasting the last nine buffer versions (LAlt+1..9) =ru= вставка последних  девяти версий буфера (LAlt+1..9)
#IF (IF_LAlt1_9 = 1)
<!1::
<!2::
<!3::
<!4::
<!5::
<!6::
<!7::
<!8::
<!9::
KeyWait LAlt ; waiting to let go <! =ru= ожидание отпускания <!

; get clipboard monitoring status in CLCLViewer =ru= получим статус наблюдение буфера обмена в CLCLViewer
Gosub TemplateHK

keyn:=RegExReplace(A_ThisHotkey,"<!") ; leave only the number =ru= оставим только цифру
SetKeyDelay -1
SendEvent %selection_hotkey_send% ; call of choice =ru= вызов выбора
WinWait ahk_class #32768 ahk_exe CLCL.exe,,2 ; wait no more than 2 seconds =ru= ожидаем не более 2 секунд
if !ErrorLevel ; if you waited and there is no error =ru= если дождались и нет ошибки
{
    ; since the menu is possible for anything and 1 and 11 and A from above, we move down to the required amount
    ; =ru= так как меню возможно всякое и 1 и 11 и A сверху, то перемещаемся вниз на нужное количество
    Sleep 20
    Loop %keyn%  
        SendEvent {Down} ; send DOWN =ru= пошлем ВНИЗ
    ; Sleep 20    
    SendEvent {Enter} ; send ENTER =ru= пошлем ENTER 
    Sleep 100    
}

SetTimer, TimerON_clcl_clwt, Off ; timer enable clipboard monitoring in CLCLViewer =ru= таймер включения наблюдения буфера обмена в CLCLViewer   
SetTimer, TimerClosePopUp, Off ; close check timer "PopUp" =ru= таймер проверки закрытия PopUp  
SetTimer, TimerON_clcl_clwt, 100

Return
#IF
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−− 


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; display popup buffer =ru= отображать всплывающий буфер 
ClipChanged(e) {
    global   
    ClipChangedE := e
    if(BuffShow=1) {                
        SetTimer ClipShow, Off
        gosub ClipDestroyShow
        SetTimer ClipShow, 500 ; buffer display delay =ru= задержка показа буфера    
    }
    else {
        SetTimer ClipShow, Off
        gosub ClipDestroyShow      
    }      
    return
}


ClipShow:    
    SetTimer ClipShow, Off
    gosub ClipDestroyShow
    Gui Destroy
    
    old:=new, new:=Clipboard, text:=""
    If !(new~="^\s*#+\K[^#\r\n]+?(?=#)")
        clip_all:=ClipboardAll
    WinGet exe_file, ProcessName, A
    
    if(BuffIncludeOnlyIn != "") {
        If exe_file not in % BuffIncludeOnlyIn
            return        
    }
    else {            
        ; executable application files that do not display a text buffer, separated by commas
        If exe_file in % BuffExclude
            return
    }
            
    WinGetPos, , , width, height, A
    
    If (width >= DRight && height >= DBottom) || !BuffShow
        return
        
    If (ClipChangedE=0 && BuffEmpty) ; and display buffer clearing =ru= и отображать очистку буфера
        text:="### Empty! ###"
    If (ClipChangedE=2 && BuffBitmap) ; and display non-text buffer changes =ru= и отображать изменения не текстового буфера
        text:="### Bitmap? ###"
    If (ClipChangedE=1)
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
            If (n=BuffLines)
                break
        }
    }    
    If text {
        Sleep 20
        Gui font, s%BuffFont% Tahoma
        Gui Margin , 6, 2
        Gui Color, % BuffColor
        Gui, +AlwaysOnTop -Caption +ToolWindow -DPIScale +HwndGuiHwnd +LastFound
        Gui, Add, Text, c%BuffFontColor% gClipDestroyShow,% RegExReplace(text,"\R$")
        Gui Show, NA y%MBottom% xCenter
        WinGetPos,,,, height
        WinMove,,,, % MBottom-height-BuffShift
        SetTimer ClipDestroyShow, % BuffTime
    }
    return
    
    

ClipDestroyShow:
    SetTimer ClipDestroyShow, Off
    Gui Destroy
    return
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; show script in editor =ru= показ скрипта в редакторе
#If (IF_CtrlShiftEdit=1) and WinExist("ahk_class #32768")
CtrlShiftEdit:
CtrlShiftEdit2:    
    Sleep 250
    perClip := Clipboard
    clip:=Clipboard, ext:=script:=text_script:=launch:="" 
    If RegExMatch(clip,"^\s*#+\K[^#\r\n]+?(?=#)",header) {
        script:=RegExReplace(clip,"^\s*#[^\r\n]+#")
        RegExMatch(header,"^[\+\-\*]",prefix)
        RegExMatch(header,"(-|=)$",suffix)
        launch := ""
        RegExMatch(header,"^[\+\-\*]?\K.+?(?=(-|=)?$)",ext)
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
        If text_script {            
            If !FileExist(text_script) {
                MsgBox, 16, , % MSG2 text_script, 1.5
                goto InsertHKReturn
            }
            SetTimer ClipShow, Off
            if (NotepadFullName!="")
                Run % """" NotepadFullName """" " """ A_WorkingDir "\" text_script """",, % launch, pid           
        }
        else {
            NameFileTMP := "temp."+ext            
            fileTEMP := FileOpen(NameFileTMP,"w-wd",enc) 
            if !IsObject(fileTEMP)
            {
                MsgBox,,, % "Error creating """ NameFileTMP """ file"
                NameFileTMP := ""
            }
            else {
                fileTEMP.Length := 0
                fileTEMP.Write(script)
                fileTEMP.Close()                           
                SetTimer ClipShow, Off                
                Sleep 100                 
                if (NotepadFullName!="")
                    Run % """" NotepadFullName """" " """ A_WorkingDir "\" "temp." ext """",, % launch, pid                 
            }            
        }
        menu:=""
    }
    
    SetTimer, TimerON_clcl_clwt, Off ; отключим таймер включения наблюдения буфера обмена в CLCLViewer    
    SetTimer, TimerON_clcl_clwt, 500    
  
    ; display popup buffer =ru= отображать всплывающий буфер 
    ClipChanged(1) 
    return
#If 
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−



; ==============================================================================