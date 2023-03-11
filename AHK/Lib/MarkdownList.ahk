;~ m=1 - простой лист
;~ m=2 - нумерованный
;~ m=3 - task list
;~ m=0 - списки в простой текст




MarkdownList(text,m) {
	text:=RegExReplace(text,"m)^\s+$")
	text:=RegExReplace(text,"\R+","`r`n")
	Loop Parse, text, `r, `n
	{
		If m=1
			out.="- " RegExReplace(A_LoopField,"^\s+") "`r`n`r`n"
		If m=2
			out.=A_Index ". " RegExReplace(A_LoopField,"^\s+") "`r`n`r`n"
		If m=3
			out.="- [ ] " RegExReplace(A_LoopField,"^\s+") "`r`n`r`n"
		If m=0
			out.=RegExReplace(A_LoopField,"^(- +\[( |x)]|-|\d+.) ") "`r`n"
	}
	return out
}
			
		
	
	
