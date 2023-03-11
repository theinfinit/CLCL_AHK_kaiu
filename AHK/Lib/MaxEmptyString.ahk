MaxEmptyString(text,max)
{
	text:=RegExReplace(text,"m)^[ \t]+$")
	Loop % max+1
		n.="`r`n"
	return RegExReplace(text,"\R{" max+2 ",}",n)
}