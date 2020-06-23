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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
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

"turn off swap
set noswapfile

"window splitting
set splitbelow
set splitright

"Set backspace behavior
set backspace=indent,eol,start


"=============================================================
"Mappings
"
"Concept:
"For one time actions, Leader then key in succcession is mapped.
"For actions likely to be repeated, Shift+key is mapped.
"
"Maps that use marker 'X' to keep current position have a *.
"=============================================================

"Set leader
let mapleader = (' ')

"reload configuration
noremap <F5> :se all& <CR>:source ~/.vimrc<CR>:noh<CR>:echom "Updated configuration!"<CR>

"Esc mapping
inoremap jj <Esc>

"Open vimrc
noremap <Leader>v :tabe ~/.vimrc<CR>

"yanking file *
noremap <Leader>y mXggVGy`X

"turn off highlighting in normal mode
nnoremap <Leader>h :nohlsearch<CR>:echo<CR>

"Two spacebars to save
noremap <Leader><Leader> :w<CR>

"copyright message
inoremap copyright // Copyright 2020 <CoLab Co., Ltd.>

"mapping start and end
noremap <Leader>. $
noremap <Leader>, ^

"allow up and down for wrapped line
nnoremap j gj
nnoremap k gk

"Disable arrow keys in non-insert mode
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Right> <Nop>
noremap <Left> <Nop>

"Bracket auto-completes
inoremap <F2> <Esc>yypa/<Esc>O
inoremap {<CR>  {<CR>}<Esc>O
inoremap [<CR>  [<CR>]<Esc>O
inoremap (<CR>  (<CR>)<Esc>O

"split navigation
nnoremap <C-h> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>
nnoremap + <C-W>>
nnoremap _ <C-W><

"surround commands
nnoremap csw{ mXbi{<esc>wea}<esc>`X
nnoremap csw[ mXbi[<esc>wea]<esc>`X
nnoremap csw( mXbi(<esc>wea)<esc>`X
nnoremap csw< mXbi<<esc>wea><esc>`X
nnoremap csw" mXbi"<esc>wea"<esc>`X
nnoremap csw' mXbi'<esc>wea'<esc>`X
nnoremap dsw mXbdheldl`Xh
nnoremap ds{ mXF{dlf}dl`Xh
nnoremap ds[ mXF[dlf]dl`Xh
nnoremap ds( mXF(dlf)dl`Xh
nnoremap ds< mXF<dlf>dl`Xh
nnoremap ds" mXF"dlf"dl`Xh
nnoremap ds' mXF'dlf'dl`Xh

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
nnoremap <Leader>c :call SwitchScroll()<CR> 
let s:freeze = "on"
function! SwitchScroll()
	if s:freeze == "on"
		echom "turning off centering"
		set scrolloff=0
		let s:freeze = "off"
	else
		echom "turning on centering"
		set scrolloff=999
		let s:freeze = "on"
	endif
endfunction
nnoremap <s-j> jjj
nnoremap <s-k> kkk

"vim tab switcher
nnoremap <Leader>t :tabe <C-d>
nnoremap <Leader>w :q<Bar>:echo<CR>
nnoremap <Leader>l :tabs<CR>
nnoremap <Leader>d :cd <C-d>
nnoremap <Leader>s :vs <C-d>
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
nnoremap L :tabn<CR>
nnoremap H :tabp<CR>
nnoremap ) :call TabRight()<CR>
nnoremap ( :call TabLeft()<CR>
nnoremap <Leader>ma 1gt
nnoremap <Leader>ms 2gt
nnoremap <Leader>md 3gt
nnoremap <Leader>mf 4gt
nnoremap <Leader>mg 5gt
nnoremap <Leader>mh 6gt
nnoremap <Leader>mj 7gt
nnoremap <Leader>mk 8gt
nnoremap <Leader>ml 9gt


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
  :autocmd BufWritePost *.js execute ':Prettier'
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
