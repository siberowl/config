"Author: siberowl
"// {{{ Plugins
"====================================================================================
"Plugins
"
"Concept:
"Using vim/plugged for installation.
"====================================================================================

call plug#begin('~/.vim/plugged')
"visuals
Plug 'arzg/vim-corvine'
Plug 'sickill/vim-monokai'
Plug 'dracula/vim'
Plug 'itchyny/lightline.vim'
Plug 'bling/vim-bufferline'
Plug 'HerringtonDarkholme/yats.vim'

"formatters
Plug 'rhysd/vim-clang-format' "C family formatter
Plug 'psf/black' "python formatter
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

"Language server protocol
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

"Auto-complete
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

"Fuzzy search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

"others
Plug 'easymotion/vim-easymotion'
Plug 'mbbill/undotree'
Plug 'siberowl/vim-tiny-surround'
Plug 'wting/gitsessions.vim'
call plug#end()

"====================================================================================
"// }}}

"// {{{ Settings
"====================================================================================
"Settings
"
"Concept:
"'set' commands and some 'let's
"====================================================================================

"// {{{ Colors

"colorscheme cycler
let g:schemes = [['corvine_light', 'selenized_light'],['corvine', 'selenized_black'],['dracula', 'dracula']]
let s:color_index = 2
function! s:cyclecolor()
  let s:color_index = (s:color_index + 1) % len(g:schemes)
  execute "colo " . g:schemes[s:color_index][0]
  let g:lightline = { 'colorscheme': g:schemes[s:color_index][1] }
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

"colorscheme
set termguicolors
execute "colo " . g:schemes[s:color_index][0]

syntax enable

let g:lsp_diagnostics_signs_error = {'text': '>>'}
let g:lsp_diagnostics_signs_warning = {'text': '--'}

"// }}}

"// {{{ lightline

let g:lightline = {
      \ 'colorscheme': g:schemes[s:color_index][1],
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ]
      \ },
      \ }

let g:lightline.enable = {
        \ 'statusline': 1,
        \ 'tabline': 1
        \ }

"// }}}

"// {{{ fzf

" Match fzf color scheme to theme
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

" Set fzf window dimensions.
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }

" Set preview window colorscheme.
let $BAT_THEME="Dracula"

" Set default preview window layout.
let $FZF_DEFAULT_OPTS="--preview-window 'right:60%' --layout reverse"

" Blines with preview
command! -bang -nargs=* CustomBLines
    \ call fzf#vim#grep(
    \   'rg --with-filename --column --line-number --no-heading --color=always --smart-case . '.fnameescape(expand('%')), 1,
    \   fzf#vim#with_preview({'options': '--keep-right --delimiter : --nth 4..'}),
    \   1)

" Set ripgrep preview window
command! -bang -nargs=* Rg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, 
  \ fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)


"// }}}

"// {{{ Formatters and linters
"====================================================================================
"Formatting
"
"Concept:
"Formatters for c, js, and py and linters.
"====================================================================================

autocmd BufWrite *.js,*.jsx,*.ts,*.tsx execute ":PrettierAsync"
autocmd BufWrite *.py,*.go execute ":LspDocumentFormat"
let g:lsp_diagnostics_echo_delay = 100
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_highlights_enabled = 0

"// }}}

"// {{{ Visuals

"show line numbers
set number

"show cursor line
augroup BgHighlight
  autocmd!
  autocmd WinEnter * call OnWindowEnter()
  autocmd WinLeave * call OnWindowLeave()
augroup END
"// {{{ Window enter/leave functions
function! OnWindowEnter()
  "hi CursorLine gui=underline cterm=underline
  set cuc
  set cul
endfunction

function! OnWindowLeave()
  set nocuc
  set nocul
endfunction
"// }}}

"show status line
set laststatus=2

set shortmess+=I

"highlight searched word
set hlsearch!
set nohlsearch

"Always show tab titles
set showtabline=2

"display full path in title
set title

"netrw explorer settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3

"Disable save warning
set hidden

"// }}}

"// {{{ Command options

"show autocomplete options on tab
set wildmenu

"Set backspace behavior
set backspace=indent,eol,start

"window splitting
set splitbelow
set splitright

"set fold
set foldmethod=marker

"// }}}

"// {{{ File management

"allow undotree to access changes after exiting buffer
if has('persistent_undo')
    set undodir=~/.vim/undo
    set undofile

endif

"turn off swap
set noswapfile

"Automatically set directory to current file
autocmd BufEnter * silent! lcd %:p:h

"update file automatically on change
set autoread

"// }}}

"// {{{ Others

set completeopt=longest,menuone

"set tab settings
set expandtab
set tabstop=2
set shiftwidth=2

"scrolling
set scrolloff=999

"Do not store globals and local values in a session
set ssop-=options    
set ssop-=globals

"// }}}

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
noremap <F6> :e ~/.vimrc<CR>

"Save
noremap <Leader><Leader> :w<CR>

"session handling
nnoremap <Leader>S :GitSessionSave<CR>
nnoremap <Leader>L :GitSessionLoad<CR>
nnoremap <Leader>D :GitSessionDelete<CR>

"Profiling
command! ProfileStart execute ':profile start ~/.vim/profile.log | profile func * | profile file *'
command! ProfileEnd execute ':profile pause | qa!'

"-----------------------------------------------------
"// }}}


"// {{{ Miscellaneous
"-----------------------------------------------------

"Toggle undo tree
nnoremap <Leader>u :UndotreeToggle<CR>

nnoremap <Leader>c :call <SID>cyclecolor()<CR>

"-----------------------------------------------------
"// }}}


"// {{{ Navigation
"-----------------------------------------------------

"Jump to fuzzy searched line in current file(fzf)
nnoremap <Leader>f :CustomBLines<CR>

"Jump to fuzzy searched pattern in project (fzf)
command! ProjectRg execute 'lcd ' . system('git rev-parse --show-cdup') . 'Rg'
nnoremap <Leader>F :ProjectRg<CR>

"Jump to fuzzy searched project file (fzf)
command! ProjectFiles execute 'GFiles ' . system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
nnoremap <Leader>p :ProjectFiles<CR>

nnoremap <Leader>b :Buffers<CR>

nnoremap <left> :LspPreviousDiagnostic<CR>
nnoremap <right> :LspNextDiagnostic<CR>
nnoremap <up> :LspPreviousError<CR>
nnoremap <down> :LspNextError<CR>

nnoremap gd :LspDefinition<CR>
nnoremap gD :LspDeclaration<CR>

"Window navigation
nnoremap J <C-W><C-J>
nnoremap K <C-W><C-K>
nnoremap L <C-W><C-L>
nnoremap H <C-W><C-H>

"EasyMotion setup
let g:EasyMotion_smartcase = 1 "v will match both v and V, but V will match V only
map , <Plug>(easymotion-prefix)
map  / <Plug>(easymotion-s)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

"allow up and down for wrapped line
nnoremap j gj
nnoremap k gk

"mapping start and end
noremap <Leader>. $
noremap <Leader>, ^

"Page up/down
nnoremap <Leader>j <C-d>
nnoremap <Leader>k <C-u>

"Backspace to go back to previous marker
nnoremap <Backspace> ``

"Explorer
nnoremap <Leader>e :Explore<CR>

nnoremap <Leader>t :tabnew<CR>

"New splits
nnoremap <Leader>V :call MaximizeToggle()<CR>
nnoremap <Leader>vv :vs<CR><C-w>=:Explore<CR>
nnoremap <Leader>vh :sp<CR><C-w>=:Explore<CR>
"// {{{ MaximizeToggle()
"
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

"Quit
noremap <Leader>w :bd<CR>

"tab to swap between buffers
nnoremap <Tab> <C-^>

"vim tab switching
nnoremap <C-l> :bn<CR>
nnoremap <C-h> :bp<CR>

"-----------------------------------------------------
"// }}}


"// {{{ Edits
"-----------------------------------------------------

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() . "\<cr>" : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)

"macro shortcut (qq to record, q to stop, Q to apply)
nnoremap Q @q
vnoremap Q :norm @q<CR>

"Bracket auto-completes
inoremap <F2> <Esc>yypa/<Esc>O
inoremap {<CR>  {<CR>}<Esc>O
inoremap [<CR>  [<CR>]<Esc>O
inoremap (<CR>  (<CR>)<Esc>O

"Search and replace
nnoremap <Leader>r :call <SID>searchandreplace()<CR>
function! s:searchandreplace()
  let l:searched = input('Search: ')
  let l:replacement = input('Replacement: ')
  execute '%s/' . l:searched . '/' . l:replacement . '/gc'
endfunction

"-----------------------------------------------------
"// }}}


"====================================================================================
"// }}}
