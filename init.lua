local Plug = vim.fn['plug#']
local map = vim.keymap.set
local remap = vim.api.nvim_set_keymap
local cmd = vim.cmd
local g = vim.g
local o = vim.o
local wo = vim.wo
local bo = vim.bo
local lsp = vim.lsp

lsp.set_log_level("OFF")
g.mapleader = ' '
g.netrw_banner = 0
g.netrw_liststyle = 3
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.laststatus = 2
g.hlsearch = false
g.noeol = true
g.nofixendofline = true
g.coq_settings = {
    keymap = { jump_to_mark = '' },
    auto_start = "shut-up"
}
g.noswapfile = true
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.autoindent = true
o.mouse = "a"
o.termguicolors = true
o.showtabline=2
o.title = true
o.swapfile = false
o.foldenable = true
o.foldmethod = 'indent'
o.updatetime = 2000
wo.number = true
wo.wrap = true
wo.cul = true

local options = { noremap = true }

-- Essential mappings
map('', ';', ':', options) -- Map semicolon
map('i', 'jj', '<Esc>', options) -- Map escape
map('', '<F5>', ':source ~/.config/nvim/init.lua<cr>:noh<cr>:e!<cr>:echom "Reloaded"<cr>', options) -- Reload config
map('', '<F6>', ':e ~/.config/nvim/init.lua<cr>', options) -- Load config
map('', '<Leader><Leader>', ':w<cr>', options) -- Save

-- Navigation mappings
map('', '<Leader>.', '$', {}) -- End
map('', '<Leader>,', '^', {}) -- Start
map('n', '<C-k>', '2<C-y>', options) -- Scroll up
map('n', '<C-j>', '2<C-e>', options) -- Scroll down
map('n', '<Leader>k', '<C-u>', options) -- Scroll up
map('n', '<Leader>j', '<C-d>', options) -- Scroll down
map('n', 'Q', '@q', options) -- Recording shortcut
map('n', '<Leader>w', ':bd<cr>', options) -- Close buffer
map('n', '<backspace>', '<c-6>', {}) -- Tab to switch between recent buffers
map('n', 'J', '<C-W><C-J>', options) -- Move to down window
map('n', 'K', '<C-W><C-K>', options) -- Move to up window
map('n', 'L', '<C-W><C-L>', options) -- Move to right window
map('n', 'H', '<C-W><C-H>', options) -- Move to left window

map('n', '<Left>', '<C-O>', options)
map('n', '<Right>', '<C-i>', options)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
    {
        {
            "zbirenbaum/copilot.lua",
            cmd = "Copilot",
            event = "InsertEnter"
        },
        -- LSP
        {
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup()
            end
        },
        {
            "williamboman/mason-lspconfig.nvim",
            config = function()
                require("mason-lspconfig").setup()
            end
        },
        {
            "neovim/nvim-lspconfig",
            config = function()
                local lsp_flags = {
                  -- This is the default in Nvim 0.7+
                  debounce_text_changes = 150,
                }
                require('lspconfig')['ts_ls'].setup{
                    on_attach = on_attach,
                    flags = lsp_flags,
                }
                -- require('lspconfig')['ember'].setup{
                    -- on_attach = on_attach,
                    -- flags = lsp_flags,
                -- }
                require('lspconfig')['stylelint_lsp'].setup{
                    on_attach = on_attach,
                    flags = lsp_flags,
                }
                require('lspconfig')['glint'].setup{
                    on_attach = on_attach,
                    flags = lsp_flags,
                }
            end,
        },
        {
            "junnplus/lsp-setup.nvim",
            dependencies = {
                'neovim/nvim-lspconfig',
                'williamboman/mason.nvim', -- optional
                'williamboman/mason-lspconfig.nvim', -- optional
            },
            config = function()
                require('lsp-setup').setup({default_mappings = false})
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter",
            config = function()
                require('nvim-treesitter.configs').setup({auto_install = true, highlight = { enable = true }})
            end,
        },
        -- Auto-complete
        {
            "ms-jpq/coq_nvim",
            branch="coq",
        },
        {
            "ms-jpq/coq.artifacts",
            branch="artifacts",
        },
        {
            "ms-jpq/coq.thirdparty",
            branch="3p",
            config = function()
                require("coq_3p")({
                    src = "copilot",
                    short_name = "COP",
                    accept_key = "<c-f>" })
            end
        },
        -- Utils
        {
            "lewis6991/gitsigns.nvim",
            config = function()
                require('gitsigns').setup({ current_line_blame = true })
            end
        },
        {
            "kyazdani42/nvim-web-devicons"
        },
        {
            "nvim-lualine/lualine.nvim",
            config = function()
                require('lualine').setup({
                    options = {
                        icons_enabled = true,
                        file_status = true, -- displays file status (readonly status, modified status)
                        path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
                    },
                    sections = {
                        lualine_a = {'mode'},
                        lualine_b = {
                            'branch',
                            'diff',
                            'diagnostics'
                        },
                        lualine_c = {
                            {
                                'filename'
                            }
                        }
                    }
                })
            end
        },
        {
            "nvim-lua/plenary.nvim"
        },
        {
            "m-demare/hlargs.nvim",
            config = function()
                require('hlargs').setup()
            end
        },
        {
            "itchyny/vim-cursorword"
        },
        {
            "petertriho/nvim-scrollbar",
            dependencies = {
                {
                    "lewis6991/gitsigns.nvim"
                }
            },
            config = function()
                require("scrollbar").setup()
                require("scrollbar.handlers.gitsigns").setup()
            end
        },
        {
            "siberowl/vim-tiny-surround"
        },
        {
            "lukas-reineke/indent-blankline.nvim",
            main = "ibl",
            opts = {},
            config = function()
                -- Indent setup
                vim.opt.termguicolors = true
                vim.cmd [[highlight IndentBlanklineIndent1 guibg=#232133 gui=nocombine]]
                vim.cmd [[highlight IndentBlanklineIndent2 guibg=#191724 gui=nocombine]]
                require("ibl").setup()
            end
        },
        {
            "windwp/nvim-autopairs",
            config = function()
                -- Autopairs setup
                local remap = vim.api.nvim_set_keymap
                local npairs = require('nvim-autopairs')
                npairs.setup({ map_bs = false, map_cr = false })
                -- skip it, if you use another global object
                _G.MUtils= {}

                MUtils.CR = function()
                  if vim.fn.pumvisible() ~= 0 then
                    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
                      return npairs.esc('<c-y>')
                    else
                      return npairs.esc('<c-e>') .. npairs.autopairs_cr()
                    end
                  else
                    return npairs.autopairs_cr()
                  end
                end
                remap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })

                MUtils.BS = function()
                  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
                    return npairs.esc('<c-e>') .. npairs.autopairs_bs()
                  else
                    return npairs.autopairs_bs()
                  end
                end
                remap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })
            end
        },
        {
            "NvChad/nvterm",
            config = function()
                -- NvTerm Setuj
                local nvterm_options = {
                    terminals = {
                        type_opts = {
                            float = {
                                relative = 'editor',
                                row = 0.05,
                                column = 1,
                                width = 0.5,
                                height = 0.8
                            },
                            horizontal = { location = "rightbelow", split_ratio = .5, },
                            vertical = { location = "rightbelow", split_ratio = .5 }
                        }
                    }
                }
                require("nvterm").setup(nvterm_options)

                -- NvTerm mappings
                map('', '<C-t>', function()
                    require("nvterm.terminal").toggle "float"
                end, options)
                map('t', '<C-t>', '<C-\\><C-n>:lua require("nvterm.terminal").toggle "float"<CR>', options)
            end
        },
        {
            "Einenlum/yaml-revealer"
        },
        {
            "toppair/peek.nvim",
            event = { "VeryLazy" },
            build = "deno task --quiet build:fast",
            config = function()
                require("peek").setup()
                -- refer to `configuration to change defaults`
                vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
                vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
            end,
        },
        {
            "sbdchd/neoformat",
            config = function()
                g.neoformat_try_node_exe = 1
                map('n', '<C-f>', ':Neoformat<cr>', options)
            end
        },
        {
            'reedes/vim-pencil',
            config = function()
                vim.cmd('Pencil')
            end
        },
        'kshenoy/vim-signature',
        -- Navigation
        {
            "toppair/reach.nvim",
            config = function()
                require('reach').setup({
                  notifications = true
                })
                local reach_options = {
                    show_current = true,
                    handle = 'dynamic',
                    modified_icon = '±',
                    previous = {
                        depth = 3,
                        groups = {
                            'Label',
                            'String',
                            'Error',
                        }
                    },
                    actions = {
                        split = '-',
                        vertsplit = '|',
                        priority = '=',
                    },
                }
                map('n', '<Tab>', function() require('reach').buffers(reach_options) end, {}) -- Tab to switch between recent buffers
            end
        },
        {
            "mbbill/undotree",
            config = function()
                map('n', '<Leader>u', ':UndotreeToggle<cr>', options) -- Toggle undo tree
            end
        },
        {
            "nvim-telescope/telescope-file-browser.nvim",
            dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
        },
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        {
            "nvim-telescope/telescope.nvim",
            dependencies = {
                {
                    "nvim-telescope/telescope-live-grep-args.nvim",
                    version = "^1.0.0"
                },
            },
            config = function()
                local telescope_options = {
                  defaults = {
                    prompt_prefix = "   ",
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    layout_config = {
                      horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8,
                      },
                      vertical = {
                        mirror = false,
                      },
                      width = 0.87,
                      height = 0.80,
                      preview_cutoff = 120,
                    },
                    path_display = { "truncate" },
                    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                    color_devicons = true,
                    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
                  },

                  extensions_list = { "themes", "terms" },
                  extensions = {
                    fzf = {
                      fuzzy = false,                    -- false will only do exact matching
                      override_generic_sorter = true,  -- override the generic sorter
                      override_file_sorter = true,     -- override the file sorter
                      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                                       -- the default case_mode is "smart_case"
                    }
                  }
                }

                -- default config
                require("telescope").setup(telescope_options)
                require("telescope").load_extension("file_browser")
                require("telescope").load_extension("live_grep_args")
                require("telescope").load_extension("fzf")

            end,
        },
        {
            "nvim-tree/nvim-tree.lua",
            config = function()
                require("nvim-tree").setup({
                    update_focused_file = { enable = true },
                    git = { enable = false},
                    view = {
                        width = 50,
                        centralize_selection = true,
                        side = "right"
                    },
                    actions = {
                        open_file = {
                            quit_on_open = true
                        }
                    }
                })

                g.nvim_tree_auto_close = 1

                -- Nvim Tree mappings
                map('n', '<leader>e', ':NvimTreeToggle<cr>', opts)
            end
        },
        {
            "ggandor/leap.nvim",
            config = function()
                require('leap').add_default_mappings()
                map('', '/', function ()
                  local current_window = vim.fn.win_getid()
                  require('leap').leap { target_windows = { current_window } }
                end)
            end
        },
        -- Colorschemes
        {
            "Mofiqul/dracula.nvim",
        },
        {
            "EdenEast/nightfox.nvim",
        },
        {
            "rose-pine/neovim",
        },
        {
            "cocopon/iceberg.vim"
        },
        {
            "AmberLehmann/candyland.nvim",
        },
        {
            "catppuccin/nvim",
            config = function()
                vim.cmd([[colorscheme catppuccin-mocha]])
            end
        }
    }
)

-- LSP mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
local dg = vim.diagnostic
map('n', '<leader>d', dg.open_float, opts)
dg.config({
  virtual_text = true,  -- Show inline errors as virtual text
  signs = true,         -- Show signs in the gutter
  float = true,         -- Enable floating windows for diagnostics
  underline = true,     -- Underline problematic code
  update_in_insert = false,  -- Prevent updates while in insert mode (optional)
})

-- Telescope mappings
local builtin = require('telescope.builtin')
map('n', '<Leader>F', function()
    require("telescope").extensions.live_grep_args.live_grep_args({ cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1] })
end, options) -- Search in file
map('n', '<Leader>f', function()
    builtin.live_grep({search_dirs={vim.fn.expand("%:p")}})
end, options) -- Search in repo
map('n', '<Leader>p', builtin.git_files, options) -- Search for a file
map('n', '<Leader>p', function()
    require("telescope.builtin").find_files({ cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1] })
end, options)
map('n', '<Leader>b', builtin.buffers, options) -- Search for buffer
-- map('n', '<Leader>e', ':Telescope file_browser path=%:p:h select_buffer=true hidden=true<cr>', options) -- File explorer
map('n', '<Leader>m', builtin.marks, options) -- Search for buffer

map('n', 'gr', builtin.lsp_references, options) --  
map('n', 'gd', builtin.lsp_definitions, options) --  
map('n', 'gi', builtin.lsp_implementations, options) --  
map('n', '<leader>D', builtin.lsp_type_definitions, options)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    local buf = vim.lsp.buf

    map('n', '<leader>h', buf.hover, bufopts)
    map('n', '<leader>r', buf.rename, bufopts)
    map('n', '<leader>a', buf.code_action, bufopts)
    map('n', '<F1>', function() vim.lsp.buf.format { async = true } end, bufopts)
  end,
})

-- Function to take a note
local function take_note()
    -- Get the current line number and content
    local lnum = vim.fn.line('.')
    local lcontent = vim.fn.getline(lnum)

    -- Get the current file path relative to the project root
    local file_relative_path = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
    local file_path = vim.fn.expand('%:p')

    -- Get the current branch name
    local branch_name = vim.fn.system('git rev-parse --abbrev-ref HEAD')
    branch_name = branch_name:gsub('%s+', '')

    -- Create or open the note file in the local directory
    local note_dir = vim.fn.stdpath('config') .. '/notes'
    if vim.fn.isdirectory(note_dir) == 0 then
        vim.fn.mkdir(note_dir, 'p')
    end
    local note_file = note_dir .. '/' .. branch_name .. '.txt'

    -- Check if the file is empty and add a title if it is
    local is_new_file = vim.fn.filereadable(note_file) == 0
    vim.cmd('edit ' .. note_file)
    if is_new_file then
        vim.fn.append(0, string.format('Notes for branch: %s', branch_name))
        vim.fn.append(1, '')
    end

    -- Append the reference to the note file with the desired format
    vim.fn.append('$', '')
    vim.fn.append('$', '========================================')
    vim.fn.append('$', string.format('Line %d: %s', lnum, lcontent))
    vim.fn.append('$', string.format('File: %s', file_relative_path))
    vim.fn.append('$', '========================================')
    vim.fn.append('$', 'Note: ')

    -- Move the cursor to the note-taking position
    vim.cmd('normal! G2jA')
    vim.cmd('normal! A')
end

-- Function to open the note file for viewing
local function open_note()
    -- Get the current branch name
    local branch_name = vim.fn.system('git rev-parse --abbrev-ref HEAD')
    branch_name = branch_name:gsub('%s+', '')

    -- Determine the note file path
    local note_dir = vim.fn.stdpath('config') .. '/notes'
    local note_file = note_dir .. '/' .. branch_name .. '.txt'

    -- Open the note file if it exists
    if vim.fn.filereadable(note_file) == 1 then
        vim.cmd('edit ' .. note_file)
    else
        print("Note file does not exist for the current branch.")
    end
end

-- Create a global command for the function
vim.api.nvim_create_user_command('TakeNote', take_note, {})

-- Create a global command to open the note file for viewing
vim.api.nvim_create_user_command('OpenNote', open_note, {})

-- Create a function to jump to the file and line from within the block
local function jump_to_from_block()
    -- Find the boundaries of the current block
    local start_line = vim.fn.search('^========================================', 'bnW')
    local end_line = vim.fn.search('^========================================', 'nW')
    if start_line == 0 or end_line == 0 or start_line >= end_line then
        print("No valid block found")
        return
    end

    -- Extract the file path and line number from the block
    local line_content = vim.fn.getline(start_line + 1)
    local file_content = vim.fn.getline(start_line + 2)
    local lnum = line_content:match("Line (%d+):")
    local file_path = file_content:match("File: (.+)")

    if file_path and lnum then
        vim.cmd('edit ' .. file_path)
        vim.cmd('call cursor(' .. lnum .. ', 1)')
    else
        print("Invalid file or line number")
    end
end

-- Create a global command for jumping from the block
vim.api.nvim_create_user_command('JumpFromBlock', jump_to_from_block, {})

-- Map the function to a key combination
vim.api.nvim_set_keymap('n', 'nj', ':JumpFromBlock<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'nt', ':TakeNote<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'no', ':OpenNote<CR>', { noremap = true, silent = true })

local function to_camel_case(str)
  -- Convert CONSTANT_CASE to CamelCase
  return str:lower()  -- Step 1: Convert to lowercase
           :gsub("_(%w)", function(s) return s:upper() end)  -- Step 2: Uppercase first letter of each part after '_'
           :gsub("^%l", string.upper)  -- Step 3: Capitalize the very first letter
end

vim.api.nvim_create_user_command(
  'RenameCamelCase',
  function(args)
    -- Gets the current word
    local current_word = vim.fn.expand('<cword>')
    -- Convert the word to CamelCase
    local camel_case_word = to_camel_case(current_word)
    -- Trigger LSP rename with the new word
    vim.lsp.buf.rename(camel_case_word)
  end,
  {}
)

vim.keymap.set('n', '<leader>Rc', ':RenameCamelCase<CR>', { silent = true })

-- Go to next LSP diagnostic error
vim.keymap.set('n', '<leader>E', function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true, desc = "Go to next LSP diagnostic error" })

-- Go to next LSP diagnostic warning
vim.keymap.set('n', '<leader>W', function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
end, { silent = true, desc = "Go to next LSP diagnostic warning" })
