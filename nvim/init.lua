local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.cmd([[
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
]])

local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", { command = "PackerCompile", group = "Packer", pattern = "init.lua"})

local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'numToStr/Comment.nvim'
  use 'tpope/vim-repeat'
  use 'tpope/vim-sleuth'
  use 'justinmk/vim-dirvish'
  use 'christoomey/vim-tmux-navigator'
  -- UI to select things (files, grep results, open buffers...)
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'nvim-lualine/lualine.nvim'
  -- use 'arkav/lualine-lsp-progress'
  use 'j-hui/fidget.nvim'
  -- Add indentation guides even on blank lines
  use 'lukas-reineke/indent-blankline.nvim'
  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use 'neovim/nvim-lspconfig'
  use 'bfredl/nvim-luadev'
  use 'mhartington/formatter.nvim'
  use 'ziglang/zig.vim'
  use 'windwp/nvim-autopairs'
  use 'ggandor/lightspeed.nvim'
  use {'neoclide/coc.nvim', branch = 'release'}
  use 'nvim-treesitter/nvim-treesitter'
  use 'ful1e5/onedark.nvim'
end)

require('onedark').setup()

local o = vim.o

o.expandtab = true
o.smartindent = true
o.tabstop = 2
o.shiftwidth = 2

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "lua", "css", "javascript", "html", "typescript", "json"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- Better escape using jk in insert and terminal mode
keymap("i", "jk", "<ESC>", default_opts)
keymap("t", "jk", "<C-\\><C-n>", default_opts)

require('nvim-autopairs').setup{} -- Add this line

--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
vim.wo.number = true

--Enable mouse mode
vim.o.mouse = 'a'

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

--Set colorscheme
vim.o.termguicolors = true

-- Set completeopt
vim.o.completeopt = 'menuone,noinsert'

--Add spellchecking
local spell_group = vim.api.nvim_create_augroup("Spellcheck", { clear = true })
vim.api.nvim_create_autocmd("FileType", { command = "setlocal spell", group = "Spellcheck", pattern = {"gitcommit", "markdown"}})

--Set statusbar
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'onedark-nvim',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'filename' },
    -- lualine_c = { 'lsp_progress' },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },

  },
}

-- Enable commentary.nvim
require('Comment').setup()

--Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

--Add move line shortcuts
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==')
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==')
vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<CR>==gi')
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi')
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv")

--Remap escape to leave terminal mode
vim.keymap.set('t', '<Esc>', [[<c-\><c-n>]])

--Disable numbers in terminal mode
local terminal_group = vim.api.nvim_create_augroup("Terminal", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", { command = "set nonu", group = "Terminal", pattern = "*"})

require('indent_blankline').setup {
  char = '┊',
  filetype_exclude = { 'help', 'packer' },
  buftype_exclude = { 'terminal', 'nofile' },
  show_trailing_blankline_indent = false,
}

-- Toggle to disable mouse mode and indentlines for easier paste
ToggleMouse = function()
  if vim.o.mouse == 'a' then
    require("indent_blankline.commands").disable()
    vim.wo.signcolumn = 'no'
    vim.o.mouse = 'v'
    vim.wo.number = false
    print 'Mouse disabled'
  else
    require("indent_blankline.commands").enable()
    vim.wo.signcolumn = 'yes'
    vim.o.mouse = 'a'
    vim.wo.number = true
    print 'Mouse enabled'
  end
end

vim.keymap.set('n', '<leader>bm', ToggleMouse)

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    vim.keymap.set('n', '[c', require"gitsigns".prev_hunk, {buffer=bufnr})
    vim.keymap.set('n', ']c', require"gitsigns".next_hunk, {buffer=bufnr})
  end
}

-- Telescope
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  extensions = {
    fzf = {
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
}
require('telescope').load_extension 'fzf'

--Add leader shortcuts
function TelescopeFiles()
  local telescope_opts = { previewer = false }
  local ok = pcall(require('telescope.builtin').git_files, telescope_opts)
  if not ok then
    require('telescope.builtin').find_files(telescope_opts)
  end
end

vim.keymap.set('n', '<leader>f', TelescopeFiles)
vim.keymap.set('n', '<leader><space>', function()
  require('telescope.builtin').buffers { sort_lastused = true }
end)

vim.keymap.set(
  'n',
  '<leader>sb',
  function()
  require('telescope.builtin').current_buffer_fuzzy_find()
  end
)
vim.keymap.set('n', '<leader>h', function() require('telescope.builtin').help_tags() end)
vim.keymap.set('n', '<leader>st', function() require('telescope.builtin').tags() end)
vim.keymap.set('n', '<leader>?', function() require('telescope.builtin').oldfiles() end)
vim.keymap.set('n', '<leader>sd', function() require('telescope.builtin').grep_string() end)
vim.keymap.set('n', '<leader>sp', function() require('telescope.builtin').live_grep() end)

vim.keymap.set('n', '<leader>so', function() require('telescope.builtin').tags { only_current_buffer = true } end)

vim.keymap.set('n', '<leader>gc', function() require('telescope.builtin').git_commits() end)
vim.keymap.set('n', '<leader>gb', function() require('telescope.builtin').git_branches() end)
vim.keymap.set('n', '<leader>gs', function() require('telescope.builtin').git_status() end)
vim.keymap.set('n', '<leader>gp', function() require('telescope.builtin').git_bcommits() end)
vim.keymap.set('n', '<leader>wo', function() require('telescope.builtin').lsp_document_symbols() end)

-- Fugitive shortcuts
vim.keymap.set('n', '<leader>ga', ':Git add %:p<CR><CR>', { silent = true })
vim.keymap.set('n', '<leader>gg', ':GBrowse<CR>', { silent = true })
vim.keymap.set('n', '<leader>gd', ':Gdiff<CR>', { silent = true })
vim.keymap.set('n', '<leader>ge', ':Gedit<CR>', { silent = true })
vim.keymap.set('n', '<leader>gr', ':Gread<CR>', { silent = true })
vim.keymap.set('n', '<leader>gw', ':Gwrite<CR><CR>', { silent = true })
vim.keymap.set('n', '<leader>gl', ':silent! Glog<CR>:bot copen<CR>', { silent = true })
vim.keymap.set('n', '<leader>gm', ':Gmove<Space>', { silent = true })
vim.keymap.set('n', '<leader>go', ':Git checkout<Space>', { silent = true })

-- alternative shorcuts without fzf
vim.keymap.set('n', '<leader>,', ':buffer *')
vim.keymap.set('n', '<leader>.', ':e<space>**/')
vim.keymap.set('n', '<leader>sT', ':tjump *')

-- Managing quickfix list
vim.keymap.set('n', '<leader>qo', ':copen<CR>', { silent = true })
vim.keymap.set('n', '<leader>qq', ':cclose<CR>', { silent = true })
vim.keymap.set('n', '<leader>Qo', ':lopen<CR>', { silent = true })
vim.keymap.set('n', '<leader>Qq', ':lclose<CR>', { silent = true })

-- Set keybind for closing qflist
local quickfix_group = vim.api.nvim_create_augroup("Quickfix", { clear = true })
vim.api.nvim_create_autocmd("FileType", { command = "nnoremap <buffer> q :lclose <bar> cclose <CR>", group = "Quickfix", pattern = "qf"})

-- Get rid of annoying ex keybind
vim.keymap.set('', 'Q', '<Nop>', { silent = true })

-- Managing buffers
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { silent = true })

-- Random
vim.keymap.set('n', '<leader>;', ':')

-- LSP management
vim.keymap.set('n', '<leader>lr', ':LspRestart<CR>', { silent = true })
vim.keymap.set('n', '<leader>li', ':LspInfo<CR>', { silent = true })
vim.keymap.set('n', '<leader>ls', ':LspStart<CR>', { silent = true })
vim.keymap.set('n', '<leader>lt', ':LspStop<CR>', { silent = true })

-- remove conceal on markdown files
vim.g.markdown_syntax_conceal = 0

-- Change preview window location
vim.g.splitbelow = true

-- Remap number increment to alt
vim.keymap.set('n', '<A-a>', '<C-a>')
vim.keymap.set('v', '<A-a>', '<C-a>')
vim.keymap.set('n', '<A-x>', '<C-x>')
vim.keymap.set('v', '<A-x>', '<C-x>')

-- n always goes forward
vim.keymap.set('n', 'n', "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set('n', 'N', "'nN'[v:searchforward]", { expr = true })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true })

-- map :W to :w
vim.api.nvim_create_user_command("W", ":w", {})

-- Neovim python support
vim.g.loaded_python_provider = 0

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", { callback = function() vim.highlight.on_yank() end, group = "YankHighlight", pattern = "*"})

-- Clear white space on empty lines and end of line
vim.keymap.set(
  'n',
  '<F6>',
  [[:let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>]],
  { silent = true }
)

-- Nerdtree like sidepanel
-- absolute width of netrw window
vim.g.netrw_winsize = -28

-- do not display info on the top of window
vim.g.netrw_banner = 0

-- sort is affecting only: directories on the top, files below
-- vim.g.netrw_sort_sequence = '[\/]$,*'

-- variable for use by ToggleNetrw function
vim.g.NetrwIsOpen = 0

-- Lexplore toggle function
ToggleNetrw = function()
  if vim.g.NetrwIsOpen == 1 then
    for _, i in pairs(vim.api.nvim_list_bufs()) do
      if vim.bo[i].filetype == 'netrw' then
        vim.api.nvim_buf_delete(i)
        break
      end
    end
    vim.g.NetrwIsOpen = 0
    vim.g.netrw_liststyle = 0
    vim.g.netrw_chgwin = -1
  else
    vim.g.NetrwIsOpen = 1
    vim.g.netrw_liststyle = 3
    vim.cmd [[silent Lexplore]]
  end
end

-- Toggle Nerd Tree SideBar
vim.keymap.set('n', '<C-n>', ToggleNetrw)

-- Function to open preview of file under netrw
local netrw_group = vim.api.nvim_create_augroup("Netrw", { clear = true })
vim.api.nvim_create_autocmd("FileType", { command = "nmap <leader>; <cr>:wincmd W<cr>", group = "Netrw", pattern = "netrw"})

local luadev_group = vim.api.nvim_create_augroup("luadev", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", { callback = function()
  vim.cmd [[
    nmap <buffer> <C-c><C-c> <Plug>(Luadev-RunLine)
    vmap <buffer> <C-c><C-c> <Plug>(Luadev-Run)
    nmap <buffer> <C-c><C-k> <Plug>(Luadev-RunWord)
    map  <buffer> <C-x><C-p> <Plug>(Luadev-Complete)
    set filetype=lua
  ]]
end, group = "luadev", pattern = "\\[nvim-lua\\]"})

-- Diagnostic settings
vim.diagnostic.config {
  virtual_text = true,
  signs = true,
  update_in_insert = true,
}

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setqflist)

-- LSP settings

-- Enable fidget for lsp progress
require('fidget').setup()

-- log file location: $HOME/.cache/nvim/lsp.log
-- vim.lsp.set_log_level 'debug'
require('vim.lsp.log').set_format_func(vim.inspect)

-- Add nvim-lspconfig plugin
local lspconfig = require 'lspconfig'
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local attach_opts = { silent = true, buffer = bufnr }
  -- Mappings.
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, attach_opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition , attach_opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, attach_opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, attach_opts)
  vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, attach_opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, attach_opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, attach_opts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, attach_opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, attach_opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, attach_opts)
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, attach_opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, attach_opts)

end

local handlers = {
  ['textDocument/hover'] = function(...)
    local bufnr, _ = vim.lsp.handlers.hover(...)
    if bufnr then
      vim.keymap.set('n', 'K', '<Cmd>wincmd p<CR>', { silent = true, buffer = bufnr })
    end
  end,
}

local servers = {
  'pyright',
  'yamlls',
  'jsonls',
}

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end

require('formatter').setup {
  filetype = {
    python = {
      -- Configuration for psf/black
      function()
        return {
          exe = 'black', -- this should be available on your $PATH
          args = { '-' },
          stdin = true,
        }
      end,
    },
    lua = {
      function()
        return {
          exe = 'stylua',
          args = {
            -- "--config-path "
            --   .. os.getenv("XDG_CONFIG_HOME")
            --   .. "/stylua/stylua.toml",
            '-',
          },
          stdin = true,
        }
      end,
    },
  },
}

vim.keymap.set('n', '<leader>os', function()
  require('telescope.builtin').live_grep { search_dirs = { '$HOME/Nextcloud/org' } }
end)

vim.keymap.set('n', '<leader>of', function()
  require('telescope.builtin').find_files { search_dirs = { '$HOME/Nextcloud/org' } }
end)
