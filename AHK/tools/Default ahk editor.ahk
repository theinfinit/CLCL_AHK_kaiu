; http://ahkscript.org/docs/commands/Edit.htm#Editors

; If your editor's command-line usage is something like the following,
; this script can be used to set it as the default editor for ahk files:
;
;   Editor.exe "Full path of script.ahk"
;
; When you run the script, it will prompt you to select the executable
; file of your editor.
;
FileSelectFile Editor, 2,, Select your editor, Programs (*.exe)
if ErrorLevel
    ExitApp
RegWrite REG_SZ, HKCR, AutoHotkeyScript\Shell\Edit\Command,, "%Editor%" "`%1"
