"global search and replace
"(use %s/pattern/replacement/ for current file)
command! -nargs=1 Find call Find(<f-args>)
command! -nargs=* FindReplace call FindReplace(<f-args>)
function! Find(pattern)
	execute ':Rg ' . a:pattern
endfunction
function! FindReplace(pattern, replacement)
	execute ':w'
	call Find(a:pattern)
	execute ':!(find . -name ''*.cpp'' -o -name ''*.h'' -o -name ''*.py'' -o -name ''*.js'' | xargs sed -i ''s/' . a:pattern . '/'. a:replacement . '/g'')'
	execute 'normal /<C-l><CR>'
	execute ':e'
	call Find(a:replacement)
endfunction
