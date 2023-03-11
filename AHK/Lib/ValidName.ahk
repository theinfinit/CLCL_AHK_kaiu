ValidName(n,r="") ; r - замена пробелов
{
	n:=RegExReplace(n,"(:|;|,|\.|\*|\?|\\|/|<|>|"")"," ")
	n:=RegExReplace(n,"\R+","_")
	n:=RegExReplace(n,"\s+"," ")
	StringReplace n, n, |, -, All
	If r
		StringReplace n, n, % " ", % r, All
	return Trim(n)
}
