function! MaximizeToggle()
	if exists("g:full_screened")
		echo "returning to normal"
		execute "normal! \<C-W>\="
		call delete(g:full_screened)
		unlet g:full_screened
	else
		echo "full screening"
		execute "normal! \<C-W>\_"
		execute "normal! \<C-W>\|"
		let g:full_screened=tempname()
	endif
endfunction
