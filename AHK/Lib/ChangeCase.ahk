ChangeCase(t,n)
{
	StringCaseSense, Locale
	If n=1
		StringUpper t, t
	If n=2
		StringLower t, t
	If n<3
		return t
	Loop % StrLen(t)
	{
		r:=SubStr(t,A_Index,1)
		If r is upper
			StringLower o, r
		else
			StringUpper o, r
		out.=o
	}
	return out
}