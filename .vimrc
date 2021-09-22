"Author: siberowl
"// {{{ Plugins: using plugged
"====================================================================================
"Plugins
"
"Concept:
"Using vim/plugged for installation.
"====================================================================================

call plug#begin('~/.vim/plugged')
"typescript syntax highlighting
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'octol/vim-cpp-enhanced-highlight'

"formatters
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'rhysd/vim-clang-format'
Plug 'psf/black'

"linters
Plug 'funorpain/vim-cpplint'
Plug 'nvie/vim-flake8'
Plug 'dense-analysis/ale'

"others
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'easymotion/vim-easymotion'
Plug 'mbbill/undotree'
call plug#end()

"to use vim pathogen
execute pathogen#infect()
"====================================================================================
"// }}}

"// {{{ Formatters and linters
"====================================================================================
"Formatting
"
"Concept:
"Formatters for c, js, and py and linters.
"====================================================================================

"formatters
autocmd FileType c, cpp,h nnoremap <CR> :ClangFormat<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact nnoremap <CR> :Prettier<CR>
autocmd FileType json nnoremap <CR> :%!jq .<CR>
autocmd FileType python nnoremap <CR> :Black<CR>

let g:clang_format#style_options = {
\ "AllowShortIfStatementsOnASingleLine" : "false",
\ "BreakBeforeBraces" : "Stroustrup",
\ "ColumnLimit" : 0,
            \ "IndentWidth" : 2}

let g:ale_python_flake8_options = '--ignore=E501'
let g:black_linelength = 120
let b:ale_linters = ['flake8', 'cc', 'standard', 'tslint', 'tsserver', 'typecheck']
let g:ale_cpp_gcc_options = '-Wall -std=c++17'
let g:ale_cpp_clang_options = '-Wall -std=c++17'
let g:ale_cpp_cc_options = '-Wall -std=c++17'
"call ale#Set('cpp_cpplint_executable', 'cpplint')
"call ale#Set('cpp_cpplint_options', '')
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

"set tab settings
set expandtab
set tabstop=2
set shiftwidth=2

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

"update file automatically on change
set autoread

"set fold
set foldmethod=marker

"set project directory
autocmd VimEnter * call OnEnter()
function! OnEnter()
	let curr_dir = getcwd()
	let g:session_name = substitute(curr_dir, '\/', '-', 'g')
	let g:branch_name = system('git rev-parse --abbrev-ref HEAD')
	if v:shell_error !=0
	else
		let g:session_name = g:session_name . '-' . substitute(g:branch_name, '\/', '-', 'g')
	endif
endfunction

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
noremap <F5> :source ~/.vimrc<CR>:noh<CR>:e!<CR>:echom "Reloaded"<CR>

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
nnoremap <Leader>=l :echo system('ls ~/.vim/sessions')<CR>

command! SaveSession execute ':mks! ~/.vim/sessions/default' . g:session_name . ' | echom ''Saved session as default'. g:session_name .''''
command! QuitSession execute ':mks! ~/.vim/sessions/default' . g:session_name . ' | :qa'
command! RestoreSession execute ':source ~/.vim/sessions/default' . g:session_name . ' | noh | echom ''Restored session default'. g:session_name .''''

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

"multi-cursor macros
"nnoremap <CR> :call AddCursor()<CR>
"nnoremap <Delete> :call ResetCursors()<CR>:echo "Reset cursors."<CR>
"// {{{ Cursor functions
function! ResetCursors()
	let s:custom_cursors = []
	let s:initial_changenr = 0
	let s:cursor_group_match = ''
	highlight clear CursorsGroup
	augroup CursorGroup
		autocmd!
	augroup END
endfunction

call ResetCursors()

"Insert cursor into the correct array index.
"Ordered from largest to smallest column number
"to keep correct position when macro is applied.
function! InsertCursor2Array(curpos)
	if len(s:custom_cursors) == 0
		call add(s:custom_cursors, a:curpos)
	else	
		for i in range(len(s:custom_cursors))
			if s:custom_cursors[i][2] < a:curpos[2]
				call insert(s:custom_cursors, a:curpos, i)
				return
			endif
		endfor
		call add(s:custom_cursors, a:curpos)
	endif
endfunction

function! ApplyCursorChanges()
	let l:currpos = getcurpos()
	if len(s:custom_cursors) == 0
		echo "No cursors found."
		return
	endif
	let l:napply = len(s:custom_cursors)
	if changenr() - s:initial_changenr > 0
		execute "normal! u"
	endif
	for i in range(l:napply)
		let l:groupnr = i
		let l:cursor = s:custom_cursors[i]
		call setpos('.', l:cursor)
		execute "normal! ."
	endfor
	call setpos('.', l:currpos)
endfunction

"Add new cursor to cursor list
function! AddCursor()
	let l:ncursors = len(s:custom_cursors)
	let l:curpos = getcurpos()
	let s:cursor_group_match = s:cursor_group_match . '\|\%'.l:curpos[1].'l\%'.l:curpos[2].'c'
	execute ':match CursorsGroup /'.s:cursor_group_match[2:].'/'
	highlight CursorsGroup ctermbg=Cyan guibg=Cyan

	let s:initial_changenr = changenr()
	augroup CursorGroup
		autocmd!
		autocmd TextChangedI * call ApplyCursorChanges()
		autocmd TextYankPost * call ApplyCursorChanges()
	augroup END

	call InsertCursor2Array(l:curpos)
endfunction
"// }}}

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
	let l:temp_x = @x
	let l:temp_z = @z
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
	let @x = l:temp_x
	let @z = l:temp_z
	echo ''
endfunction
function! DeleteSurround()
	echo ''
	let comchar = nr2char(getchar())
	if comchar == 'w'
		execute ':normal! mXlbdhwdl`Xh'
	else
		let char = comchar
		execute ':normal! mXF' . char . 'dl`Xhf' . SurroundGetPair(char) . 'dl`Xh'
	endif
	echo ''
endfunction
"// }}}

"-----------------------------------------------------
"// }}}


"====================================================================================
"// }}}
