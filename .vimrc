"=============================================================
"Plugins
"
"Concept:
"Using vim/plugged for installation.
"=============================================================

call plug#begin('~/.vim/plugged')
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'rhysd/vim-clang-format'
Plug 'psf/black'
Plug 'funorpain/vim-cpplint'
Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'dense-analysis/ale'
Plug 'Chiel92/vim-autoformat'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'jonhoo/proximity-sort'
call plug#end()


"=============================================================
"Settings
"
"Concept:
"Solarized theme and line centering.
"=============================================================

"colorscheme
set termguicolors
colo corvine_light
let g:lightline = {
      \ 'colorscheme': 'selenized_light',
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

"show vertical cursor line
set cursorcolumn

"show horizontal cursor line
set cursorline

"show status line
set laststatus=2

"highlight searched word
set hlsearch

"show autocomplete options on tab
set wildmenu

"display full path in title
set title

"scrolling
set scrolloff=999

"window splitting
set splitbelow
set splitright


"=============================================================
"Mappings
"
"Concept:
"For one time actions, Leader then key in succcession is mapped.
"For actions likely to be repeated, Shift+key is mapped.
"=============================================================

"Set leader
let mapleader = (' ')

"reload configuration
noremap <F1> :source ~/.vimrc<CR>:echom "Updated configuration!"<CR>

"Esc mapping
inoremap jj <Esc>

"yanking file without disturbing
noremap <Leader>y maggVGy`a

"jump to last edit
noremap <Leader>; `.

"clear line(delete but keep the empty line)
noremap <Leader>d ddO<Esc>

"turn off highlighting in normal mode
noremap <Leader>h :nohlsearch<CR>:echo<CR>

"Two spacebars to save
noremap <Leader><Leader> :w<CR>

"copyright message
inoremap copyright // Copyright 2020 <CoLab Co., Ltd.>

"mapping start and end
noremap <Leader>. $
noremap <Leader>, ^

"Disable arrow keys in normal mode
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Right> <Nop>
noremap <Left> <Nop>

"Mapping arrow keys in insert mode
inoremap <C-h> <left>
inoremap <C-j> <down>
inoremap <C-k> <up>
inoremap <C-l> <right>

"Bracket auto-completes
inoremap <F2> <Esc>yypa/<Esc>O
inoremap {<CR>  {<CR>}<Esc>O
inoremap [<CR>  [<CR>]<Esc>O
inoremap (<CR>  (<CR>)<Esc>O

"split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"Bracket auto-enclose
noremap <Leader>e{ bi{<Esc>wwi}<Esc> 
noremap <Leader>e( bi(<Esc>wwi)<Esc> 
noremap <Leader>e[ bi[<Esc>wwi]<Esc> 
noremap <Leader>e< bi<<Esc>wwi><Esc> 
noremap <Leader>e" bi"<Esc>wwi"<Esc> 
noremap <Leader>e' bi'<Esc>wwi'<Esc> 

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

"scrolling
noremap <Leader>c :call SwitchScroll()<CR> 
let s:freeze = "on"
function! SwitchScroll()
	if s:freeze == "on"
		echom "turning off centering"
		set scrolloff=0
		let s:freeze = "off"
	else
		echom "turning on centering"
		set scrolloff=99
		let s:freeze = "on"
	endif
endfunction
noremap <s-j> jjj
noremap <s-k> kkk
noremap <s-h> hhh
noremap <s-l> lll

"vim tab switcher
noremap <s-t> :tabe <C-d>
noremap <s-w> :q<Bar>:echo<CR>
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
noremap } :tabn<CR>
noremap { :tabp<CR>
noremap ) :call TabRight()<CR>
noremap ( :call TabLeft()<CR>


"====================================================================================
"Formatting
"
"Concept:
"Formatters for c, js, and py and syntastic linters.
"====================================================================================

augroup filetype_c
  autocmd!
  :autocmd FileType c,cpp,h setlocal tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab
  :autocmd FileType c,cpp,h ClangFormatAutoEnable
  :autocmd FileType c,cpp,h  noremap <C-/> // <Esc>
augroup end
let g:syntastic_cpp_cpplint_exec = 'cpplint'
let g:syntastic_cpp_checkers = ['cpplint']

augroup filetype_js
  autocmd!
  :autocmd BufWritePost *.js execute ':PrettierAsync'
  :autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  :autocmd FileType javascript noremap <C-/> // <Esc>
augroup end
"let g:prettier#config#parser = 'babylon'

augroup filetype_py
  autocmd!
  :autocmd BufWritePost *.py execute ':Black' 
  :autocmd FileType python,py setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  :autocmd FileType python,py noremap <C-/> A# <Esc>
augroup end

augroup filetype_xml
	autocmd!
"	autocmd BufWritePost *.html execute ':Autoformat'
augroup end
let g:syntastic_python_flake8_exec = 'flake8'
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args = '--ignore="E203, E501"'
