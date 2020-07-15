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
Plug 'easymotion/vim-easymotion'
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

"show vertical cursor line
set cursorcolumn

"show horizontal cursor line
set cursorline

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

"window splitting
set splitbelow
set splitright

"set autoindent
set autoindent
set smartindent

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

"Map semiclon
nnoremap ; :

"Esc mapping
inoremap jj <Esc>

"Open vimrc
noremap <F6> :tabe ~/.vimrc<CR>

"yanking file *
noremap <Leader>y mXggVGy`X

"turn off highlighting in normal mode
nnoremap <Leader>h :nohlsearch<CR>:echo<CR>

"Save
noremap <Leader><Leader> :w<CR>

"copyright message
inoremap copyright // Copyright 2020 <CoLab Co., Ltd.>

"Quit
noremap <Leader>w :q<CR>

"mapping start and end
noremap <Leader>. $
noremap <Leader>, ^

"allow up and down for wrapped line
nnoremap j gj
nnoremap k gk

"ls
nnoremap <Leader>l :tabs<CR>

"explore
nnoremap <Leader>e :Explore<CR>

"JSDoc mapping
noremap <Leader>/ i/**<CR><CR>/<Up>

"print registers
nnoremap <Leader>r :registers<CR>

"macro shortcut
nnoremap Q @q
vnoremap Q :norm @q<CR>

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

"surround commands
nnoremap csw{ mXlbi{<esc>ea}<esc>`X
nnoremap csw[ mXlbi[<esc>ea]<esc>`X
nnoremap csw( mXlbi(<esc>ea)<esc>`X
nnoremap csw< mXlbi<<esc>ea><esc>`X
nnoremap csw" mXlbi"<esc>ea"<esc>`X
nnoremap csw' mXlbi'<esc>ea'<esc>`X
nnoremap csw` mXlbi`<esc>ea`<esc>`X
nnoremap dsw mXlbdheldl`Xh
nnoremap ds{ mXF{dlf}dl`Xh
nnoremap ds[ mXF[dlf]dl`Xh
nnoremap ds( mXF(dlf)dl`Xh
nnoremap ds< mXF<dlf>dl`Xh
nnoremap ds" mXF"dlf"dl`Xh
nnoremap ds' mXF'dlf'dl`Xh
nnoremap ds` mXF`dlf`dl`Xh

"reload configuration
noremap <F5> :source ~/.vimrc<CR>:noh<CR>:echom "Updated configuration!"<CR>
nnoremap <Leader>=q :QuitSession<CR>
nnoremap <Leader>=r :RestoreSession<CR>
command! QuitSession execute ':mks! ~/.vim/sessions/default | :wqa'
command! RestoreSession execute ':source ~/.vim/sessions/default | noh | echom ''Restored session!'''

"EasyMotion setup
map , <Plug>(easymotion-prefix)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

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
nnoremap <s-j> :+3<CR>
nnoremap <s-k> :-3<CR>

"Split view
nnoremap <Leader>v; mX :tabe %<CR> `X :vs<CR><C-f> :vs<CR><C-f> :vs<CR><C-f> :vs<CR><C-f> :vs<CR><C-f> :vs<CR><C-f> :vs<CR><C-f> :vs<CR><C-f> :vs<CR><C-f> :vs<CR><C-f>
nnoremap <Leader>vo :only<CR>
nnoremap <Leader>vv :vs %<CR>
nnoremap <Leader>vs :vs <C-d>

"window splitting
set splitbelow
set splitright

nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>
nnoremap + <C-W>>
nnoremap _ <C-W><

"vim tab switcher
nnoremap <Leader>t :tabe <C-d>
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

augroup filetype_json
	autocmd!
	:autocmd BufWritePost *.json execute ':%!jq .'
augroup end
let g:syntastic_python_flake8_exec = 'flake8'
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args = '--ignore="E203, E501"'
