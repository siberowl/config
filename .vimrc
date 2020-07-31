"Author: siberowl
"// {{{ Plugins: using plugged
"====================================================================================
"Plugins
"
"Concept:
"Using vim/plugged for installation.
"====================================================================================

call plug#begin('~/.vim/plugged')
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'rhysd/vim-clang-format'
Plug 'funorpain/vim-cpplint'
Plug 'nvie/vim-flake8'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'easymotion/vim-easymotion'
Plug 'mbbill/undotree'
call plug#end()
"====================================================================================
"// }}}

"// {{{ Settings: theme and default settings
"====================================================================================
"Settings
"
"Concept:
"Solarized theme and line centering.
"====================================================================================

"colorscheme
set termguicolors
colo corvine_light
let g:lightline = {
      \ 'colorscheme': 'selenized_light',
      \ }
let g:lightline.enable = {
            \ 'statusline': 1,
            \ 'tabline': 1 
            \ }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

"allow undo previous to closing
if has('persistent_undo')
    set undodir=~/.vim/undo
    set undofile

endif

"show line numbers
set number

"show cursor line
augroup BgHighlight
	autocmd!
	autocmd WinEnter * call OnWindowEnter()
	autocmd WinLeave * call OnWindowLeave()
augroup END

function! OnWindowEnter()
	hi CursorLine gui=underline cterm=underline
	set cuc
	set cul
endfunction

function! OnWindowLeave()
	set nocuc
	set nocul
endfunction

function! Pulse() "// {{{ Pulse function
	let current_window = winnr()
	let start = 0
	let end = winwidth(current_window)
	let step  = end/30
	hi ColorColumn guibg=#FFFFFF
	for i in range(start, end, step)
		redraw
		execute "set colorcolumn=" . i
		sleep 1m
	endfor
	set colorcolumn=0
endfunction
"// }}}

"show status line
set laststatus=2

"show tabline
set showtabline=2

"highlight searched word
set hlsearch!
set nohlsearch

"show autocomplete options on tab
set wildmenu

"display full path in title
set title

"scrolling
set scrolloff=999

"turn off swap
set noswapfile

"Set backspace behavior
set backspace=indent,eol,start

"netrw settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3

"Disable save warning
set hidden

"Automatically set directory to current file
autocmd BufEnter * silent! lcd %:p:h

"Do not store globals and lobal values in a session
set ssop-=options    
set ssop-=globals

"Use tabs for buffer switching
set switchbuf=usetab

"window splitting
set splitbelow
set splitright

"marker folding
set foldmethod=marker

set nobackup
set nowritebackup

"====================================================================================
"//}}}

"// {{{ Key mappings
"====================================================================================
"Mappings
"
"Concept:
"For one time actions, Leader then key in succcession is mapped.
"For actions likely to be repeated, Shift+key is mapped.
"
"Maps that use marker 'X' to keep current position have a *.
"====================================================================================


"// {{{ Essentials
"-----------------------------------------------------

"Set leader
let mapleader = (' ')

"Map semiclon
nnoremap ; :

"Esc mapping
inoremap jj <Esc>

"reload config
noremap <F5> :source ~/.vimrc<CR>:noh<CR>:echom "Updated configuration!"<CR>

"Open vimrc
noremap <F6> :tabe ~/.vimrc<CR>

"Save
noremap <Leader><Leader> :w<CR>

"Quit
noremap <Leader>w :q<CR>

"session handling
nnoremap <Leader>=s :SaveSession<CR>
nnoremap <Leader>=q :QuitSession<CR>
nnoremap <Leader>=r :RestoreSession<CR>

command! SaveSession execute ':mks! ~/.vim/sessions/default | echom ''Saved session!'''
command! QuitSession execute ':mks! ~/.vim/sessions/default | :qa'
command! RestoreSession execute ':source ~/.vim/sessions/default | noh | echom ''Restored session!'''

"Disable arrow keys in non-insert mode
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Right> <Nop>
noremap <Left> <Nop>


"-----------------------------------------------------
"// }}}


"// {{{ Miscellaneous
"-----------------------------------------------------

"print registers
nnoremap <Leader>r :registers<CR>:normal! "

"Folding
nnoremap <Leader>f za

"cd
nnoremap <Leader>c :cd <C-d>

"Toggle undo tree
nnoremap <Leader>u :UndotreeToggle<CR>

"-----------------------------------------------------
"// }}}


"// {{{ Navigation
"-----------------------------------------------------

"Jump to fuzzy searched buffer (fzf)
nnoremap <Leader>b :Buffers<CR>

"Open previous buffer
nnoremap <Leader><tab> :b#<CR>

"List and jump to marker
nnoremap <Leader>m :<C-u>marks<CR>:normal! `

"Jump to fuzzy searched line (fzf)
nnoremap <Leader>l :BLines<CR>
nnoremap <Leader>L :Lines<CR>

"Page up/down
nnoremap <Leader>j <C-d>
nnoremap <Leader>k <C-u>

"Window navigation
nnoremap J <C-W><C-J>
nnoremap K <C-W><C-K>
nnoremap L <C-W><C-L>
nnoremap H <C-W><C-H>

"EasyMotion setup
map , <Plug>(easymotion-prefix)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

"allow up and down for wrapped line
nnoremap j gj
nnoremap k gk

"mapping start and end
noremap <Leader>. $
noremap <Leader>, ^
 
"vim tab switcher
nnoremap <C-l> :tabn<CR>
nnoremap <C-h> :tabp<CR>
nnoremap ) :call TabRight()<CR>
nnoremap ( :call TabLeft()<CR>
"// {{{ Tab functions
function! TabLeft()
   if tabpagenr() == 1
      execute "tabm"
   else
      execute "tabm -1"
   endif
endfunction
function! TabRight()
   if tabpagenr() == tabpagenr('$')
      execute "tabm" 0
   else
      execute "tabm +1"
   endif
endfunction
"// }}}

"-----------------------------------------------------
"// }}}


"// {{{ Exploration
"-----------------------------------------------------

"Explorer
nnoremap <Leader>e :Explore<CR>

"New tab
nnoremap <Leader>t :tabe<CR>:Explore<CR>

"New splits
nnoremap <Leader>vo :call MaximizeToggle()<CR>
nnoremap <Leader>vv :vs<CR><C-w>=:Explore<CR>
nnoremap <Leader>vV :vert botright split<CR><C-w>=:Explore<CR>
nnoremap <Leader>vh :sp<CR><C-w>=:Explore<CR>
nnoremap <Leader>vH :botright split<CR><C-w>=:Explore<CR>
"// {{{ MaximizeToggle()
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
"// }}}

"-----------------------------------------------------
"// }}}


"// {{{ Edits
"-----------------------------------------------------

"macro shortcut
nnoremap Q @q
vnoremap Q :norm @q<CR>

"autocomplete with tab
inoremap <tab> <C-n>

"Bracket auto-completes
inoremap <F2> <Esc>yypa/<Esc>O
inoremap {<CR>  {<CR>}<Esc>O
inoremap [<CR>  [<CR>]<Esc>O
inoremap (<CR>  (<CR>)<Esc>O


"surround commands
nnoremap cs :call ChangeSurround()<CR>
nnoremap ds :call DeleteSurround()<CR>
"// {{{ Surround functions
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
		execute ':normal! mXlbh"xpe"zp`X'
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
"// }}}

"yanking file *
noremap <Leader>y mXggVGy`X

"global search and replace
"(use %s/pattern/replacement/ for current file)
nnoremap <Leader>F :call Find<space>
nnoremap <Leader>R :call FindReplace<space>
"// {{{ search and replace functions
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
"// }}}

"-----------------------------------------------------
"// }}}


"====================================================================================
"// }}}

"// {{{ Formatters and linters
"====================================================================================
"Formatting
"
"Concept:
"Formatters for c, js, and py and syntastic linters.
"====================================================================================

augroup filetype_c
	autocmd!
	:autocmd FileType c,cpp,h setlocal tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab
	:autocmd BufWritePost *.c,*.cpp,*.h execute ':ClangFormat'
augroup end
let g:syntastic_cpp_cpplint_exec = 'cpplint'
let g:syntastic_cpp_checkers = ['cpplint']

augroup filetype_js
	autocmd!
	:autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
	:autocmd BufWritePost *.js execute ':PrettierAsync'
augroup end

augroup filetype_py
	autocmd!
	:autocmd BufWritePost *.py execute ':Black' 
	:autocmd FileType python,py setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
augroup end

augroup filetype_json
	autocmd!
	:autocmd BufWritePost *.json execute ':%!jq .'
augroup end
let g:syntastic_python_flake8_exec = 'flake8'
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args = '--ignore="E203, E501"'
"// }}}
