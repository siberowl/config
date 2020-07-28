function! SurroundGetPair(char)
	if a:char == '{'
		return '}'
	elseif a:char == '['
		return ']'
	elseif a:char == '('
		return ')'
	elseif a:char == '<'
		return '>'
	else
		return a:char
	endif
endfunction
function! ChangeSurround()
	echo ''
	let comchar = nr2char(getchar())
	if comchar == 'w'
		let char = nr2char(getchar())
		let @x = char 
		let @z = SurroundGetPair(char)
		execute ':normal! mXI '
		execute ':normal! `Xlbh"xpe"zp^dh`X'
	else
		let char = nr2char(getchar())
		let @x = char 
		let @z = SurroundGetPair(char)
		execute ':normal! mXF' . comchar . 'r' . char . '`Xf' . SurroundGetPair(comchar) . 'r' . SurroundGetPair(char) . '`Xh'
	endif
	echo ''
endfunction
function! DeleteSurround()
	echo ''
	let comchar = nr2char(getchar())
	if comchar == 'w'
		execute ':normal! mXlbdheldl`Xh'
	else
		let char = nr2char(getchar())
		execute ':normal! mXF' . char . 'dl`Xf' . SurroundGetPair(char) . 'dl`Xh'
	endif
	echo ''
endfunction
