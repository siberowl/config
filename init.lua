local Plug = vim.fn['plug#']
local map = vim.keymap.set
local cmd = vim.cmd
local g = vim.g
local o = vim.o
local wo = vim.wo
local bo = vim.bo

vim.call('plug#begin', '~/.local/share/nvim/site/plugged')

Plug 'mbbill/undotree'
Plug('phaazon/hop.nvim')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', { tag = '0.1.0' })
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug('lewis6991/gitsigns.nvim')
Plug 'Mofiqul/dracula.nvim'
Plug 'junnplus/lsp-setup.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug('ms-jpq/coq_nvim', {branch ='coq'})
Plug('ms-jpq/coq.artifacts', {branch = 'artifacts'})
Plug('ms-jpq/coq.thirdparty', {branch = '3p'})
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug 'm-demare/hlargs.nvim'
Plug('akinsho/bufferline.nvim', { tag = 'v2.*' })
Plug 'petertriho/nvim-scrollbar'
Plug 'romainl/vim-cool/'
Plug 'siberowl/vim-tiny-surround'
Plug 'bling/vim-bufferline'

vim.call('plug#end')


local options = { noremap = true }

g.mapleader = ' '
g.netrw_banner = 0
g.netrw_liststyle = 3
g.laststatus = 2
g.coq_settings = {auto_start = 'shut-up'}
g.hlsearch = false
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.autoindent = true
o.mouse = ""
o.scrolloff=999
o.termguicolors = true
o.showtabline=2
o.title = true
wo.number = true
wo.wrap = true
wo.cul = true
cmd('colo dracula')

require('hop').setup()
require('mason').setup()
require('lsp-setup').setup({default_mappings = true})
require('coq')
require('dracula').setup()
require('lualine').setup()
require('nvim-treesitter.configs').setup({auto_install = true, highlight = { enable = true }})
require("telescope").setup()
require("telescope").load_extension("file_browser")
require("bufferline").setup({})
require('gitsigns').setup()
require("scrollbar").setup()
require('hlargs').setup()

-- Essential mappings
map('n', ';', ':', options) -- Map semicolon
map('i', 'jj', '<Esc>', options) -- Map escape
map('', '<F5>', ':source ~/.config/nvim/init.lua<cr>:noh<cr>:e!<cr>:echom "Reloaded"<cr>', options) -- Reload config
map('', '<F6>', ':e ~/.config/nvim/init.lua<cr>', options) -- Load config
map('', '<Leader><Leader>', ':w<cr>', options) -- Save
map('n', '<Leader>u', ':UndotreeToggle<cr>', options) -- Toggle undo tree

-- Navigation mappings
map('', '<Leader>.', '$', {}) -- End
map('', '<Leader>,', '^', {}) -- Start
map('n', '<Leader>k', '<C-u>', options) -- Scroll up
map('n', '<Leader>j', '<C-d>', options) -- Scroll down
map('n', 'Q', '@q', options) -- Recording shortcut
map('n', '<C-h>', ':bprevious<cr>', options) -- Previous buffer
map('n', '<C-l>', ':bnext<cr>', options) -- Next buffer
map('n', 'J', '<C-W><C-J>', options) -- Move to down window
map('n', 'K', '<C-W><C-K>', options) -- Move to up window
map('n', 'L', '<C-W><C-L>', options) -- Move to right window
map('n', 'H', '<C-W><C-H>', options) -- Move to left window
map('n', '<Leader>w', ':bd<cr>', options) -- Close buffer

-- Telescope mappings
local builtin = require('telescope.builtin')
map('n', '<Leader>F', function()
	builtin.live_grep({ cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1] })
end, options) -- Search in file
map('n', '<Leader>f', function()
	builtin.live_grep({search_dirs={vim.fn.expand("%:p")}})
end, options) -- Search in repo
map('n', '<Leader>p', builtin.git_files, options) -- Search for a file
map('n', '<Leader>b', builtin.buffers, options) -- Search for buffer
map('n', '<Leader>e', ':Telescope file_browser hidden=true<cr>', options) -- File explorer
map('n', '<Leader>m', builtin.marks, options) -- Search for buffer


-- Hop mappings
local hop = require('hop')
local directions = require('hop.hint').HintDirection
map('n', '/', ':HopChar2<cr>', options) -- Hop with slash
map('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, {remap=true})
map('', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, {remap=true})

-- LSP mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
local dg = vim.diagnostic
map('n', '<leader>d', dg.open_float, opts)
map('n', '[d', dg.goto_prev, opts)
map('n', ']d', dg.goto_next, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Mappings.
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  local buf = vim.lsp.buf
  map('n', 'gD', buf.declaration, bufopts)
  map('n', 'gd', buf.definition, bufopts)
  map('n', 'gi', buf.implementation, bufopts)
  map('n', 'gr', buf.references, bufopts)
  map('n', 'K', buf.hover, bufopts)
  map('n', '<leader>D', buf.type_definition, bufopts)
  map('n', '<leader>r', buf.rename, bufopts)
  map('n', '<leader>a', buf.code_action, bufopts)
  map('n', '<F1>', function() vim.lsp.buf.format { async = true } end, bufopts)
end
