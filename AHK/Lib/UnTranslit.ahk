UnTranslit(x)
{
	StringCaseSense, On

	StringReplace, x, x, Shch, Щ, All
	StringReplace, x, x, Sch, Щ, All
	StringReplace, x, x, sch, щ, All
	StringReplace, x, x, SCH, Щ, All
	StringReplace, x, x, ch, ч, All
	StringReplace, x, x, CH, Ч, All
	StringReplace, x, x, Ch, Ч, All
	StringReplace, x, x, ja, я, All
	StringReplace, x, x, JA, Я, All
	StringReplace, x, x, Ja, Я, All
	StringReplace, x, x, jo, ё, All
	StringReplace, x, x, JO, Ё, All
	StringReplace, x, x, Jo, Ё, All
	StringReplace, x, x, ju, ю, All
	StringReplace, x, x, JU, Ю, All
	StringReplace, x, x, Ju, Ю, All
	StringReplace, x, x, sh, ш, All
	StringReplace, x, x, SH, Ш, All
	StringReplace, x, x, Sh, Ш, All
	StringReplace, x, x, ts, ц, All
	StringReplace, x, x, TS, Ц, All
	StringReplace, x, x, Ts, Ц, All
	StringReplace, x, x, ya, я, All
	StringReplace, x, x, YA, Я, All
	StringReplace, x, x, Ya, Я, All
	StringReplace, x, x, yu, ю, All
	StringReplace, x, x, YU, Ю, All
	StringReplace, x, x, Yu, Ю, All
	StringReplace, x, x, zh, ж, All
	StringReplace, x, x, Zh, Ж, All
	StringReplace, x, x, Zh, Ж, All
	StringReplace, x, x, " , ъ, All
	StringReplace, x, x, ' , ь, All
	StringReplace, x, x, a, а, All
	StringReplace, x, x, A, А, All
	StringReplace, x, x, b, б, All
	StringReplace, x, x, B, Б, All
	StringReplace, x, x, c, ц, All
	StringReplace, x, x, C, Ц, All
	StringReplace, x, x, d, д, All
	StringReplace, x, x, D, Д, All
	StringReplace, x, x, e, е, All
	StringReplace, x, x, E, Е, All
	StringReplace, x, x, f, ф, All
	StringReplace, x, x, F, Ф, All
	StringReplace, x, x, g, г, All
	StringReplace, x, x, G, Г, All
	StringReplace, x, x, h, х, All
	StringReplace, x, x, H, Х, All
	StringReplace, x, x, i, и, All
	StringReplace, x, x, I, И, All
	StringReplace, x, x, j, й, All
	StringReplace, x, x, J, Й, All
	StringReplace, x, x, k, к, All
	StringReplace, x, x, K, К, All
	StringReplace, x, x, l, л, All
	StringReplace, x, x, L, Л, All
	StringReplace, x, x, m, м, All
	StringReplace, x, x, M, М, All
	StringReplace, x, x, n, н, All
	StringReplace, x, x, N, Н, All
	StringReplace, x, x, o, о, All
	StringReplace, x, x, O, О, All
	StringReplace, x, x, p, п, All
	StringReplace, x, x, P, П, All
	StringReplace, x, x, r, р, All
	StringReplace, x, x, R, Р, All
	StringReplace, x, x, s, с, All
	StringReplace, x, x, S, С, All
	StringReplace, x, x, t, т, All
	StringReplace, x, x, T, Т, All
	StringReplace, x, x, u, у, All
	StringReplace, x, x, U, У, All
	StringReplace, x, x, v, в, All
	StringReplace, x, x, V, В, All
	StringReplace, x, x, w, в, All
	StringReplace, x, x, W, В, All
	StringReplace, x, x, x, х, All
	StringReplace, x, x, X, Х, All
	StringReplace, x, x, y, ы, All
	StringReplace, x, x, Y, Ы, All
	StringReplace, x, x, z, з, All
	StringReplace, x, x, Z, З, All

	return x
}
