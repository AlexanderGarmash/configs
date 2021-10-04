----[[ Helpers ]]----

local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn['compe#complete']()
    end
end

_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    else
        return t "<S-Tab>"
    end
end

-- Fundamental settings
vim.bo.fileencoding = 'utf-8'
vim.o.fileencodings = 'ucs-bom,utf-8,gbk,cp936,latin-1'
vim.o.fileformat = 'unix'
vim.o.fileformats = 'unix,dos,mac'
vim.o.filetype = 'on'
vim.cmd('filetype plugin on')
vim.o.syntax = 'on'
vim.opt.undofile = true     --Save undo history
--Do not save when switching buffers (note: this is now a default on master)
vim.o.hidden = true

-- General indentation settings
vim.cmd('filetype plugin indent on')
vim.api.nvim_command('set smartindent')
vim.api.nvim_command('set smartindent')
vim.api.nvim_command('set expandtab') -- tab to spaces
vim.o.softtabstop = 4       -- How many columns cursors moves right, when <Tab> pressed
vim.o.shiftwidth = 4        -- the width for indent

-- Appearance
vim.wo.number = true                -- Show current line number
vim.wo.relativenumber = true        -- use relative numbers for other lines
vim.api.nvim_command('set nowrap')  -- disable wraps
vim.api.nvim_command('colorscheme gruvbox8_soft')
vim.api.nvim_command('set scrolloff=5')
vim.api.nvim_command('set sidescrolloff=20')    -- The minimal number of columns to scroll horizontally.
vim.api.nvim_command('set cursorline')  -- highlight the line of the cursor

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.api.nvim_exec(
  [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]],
  false
)

local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim'                          -- Package manager
  use({"lifepillar/vim-gruvbox8", event = 'VimEnter'})  -- Cool theme
  use 'itchyny/lightline.vim'                           -- Fancier statusline
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use 'ray-x/lsp_signature.nvim'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/nvim-compe'
end)

vim.g.mapleader = ','
-- Mappings
map('n', '<Space>',   '<NOP>')      -- Unmap space key
-- Tab Completion
map('i', '<Tab>',   'v:lua.tab_complete()',   {expr = true})
map('s', '<Tab>',   'v:lua.tab_complete()',   {expr = true})
map('i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
map('s', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
-- for better Movement between Windows
map('n', '<C-h>', '<C-w>h')
map('n', '<C-l>', '<C-w>l')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
-- for better Movement between Buffers
map('n', '<Tab>',   ':bnext<CR>')
map('n', '<S-Tab>', ':bprevious<CR>')

--Set statusbar
vim.g.lightline = {
  colorscheme = 'solarized',
  active = { left = { { 'mode', 'paste' }, { 'readonly', 'filename', 'modified' } } },
}

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
}

-- LSP
local lsp = require 'lspconfig'
function _G.on_attach(client, bufnr)
    require "lsp_signature".on_attach({
      bind = true,
      handler_opts = {
        border = "single"
      },
      hi_parameter = "LspSignatureActiveParameter",
      extra_trigger_chars = {"(", ","},
      toggle_key = '<Leader>P'
    }, bufnr)
    local function buf_map(mode, lhs, rhs, opts)
        local options = {noremap = true, silent = true}
        if opts then options = vim.tbl_extend('force', options, opts) end
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
    end
    buf_map('n', 'gD',         ':lua vim.lsp.buf.declaration()<CR>')
    buf_map('n', 'gd',         ':lua vim.lsp.buf.definition()<CR>')
    buf_map('n', 'gi',         ':lua vim.lsp.buf.implementation()<CR>')  -- Go to implementation
    buf_map('n', 'gr',         ':lua vim.lsp.buf.references()<CR>')      -- Go to references
    buf_map('n', '[d',         ':lua vim.lsp.diagnostic.goto_prev()<CR>') -- Go to prev diagnostic problem
    buf_map('n', ']d',         ':lua vim.lsp.diagnostic.goto_next()<CR>') -- Go to next diagnostic problem
    buf_map('n', '<Leader>er',  ':lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
    buf_map('n', '<Leader>q',  ':lua vim.lsp.diagnostic.set_loclist()<CR>')
    buf_map('n', '<Leader>k',  ':lua vim.lsp.buf.hover()<CR>')
    buf_map('n', '<C-k>',      ':lua vim.lsp.buf.signature_help()<CR>')
    buf_map('n', '<Leader>rn', ':lua vim.lsp.buf.rename()<CR>')
    buf_map('n', '<Leader>ca', ':lua vim.lsp.buf.code_action()<CR>')
    -- Formatting
    if client.resolved_capabilities.document_formatting then
        buf_map('n', '<Leader>f', ':lua vim.lsp.buf.formatting()<CR>')
    end
    if client.resolved_capabilities.document_range_formatting then
        buf_map('v', '<Leader>f', ':lua vim.lsp.buf.range_formatting()<CR>')
    end
    -- autocmds highlighting
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
        hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
        augroup lsp_doc_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end
end

--- LSP-config
vim.g["lsp#capabilities"] = vim.lsp.protocol.make_client_capabilities()
local capabilities = vim.g["lsp#capabilities"]
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}

local servers = { "pylsp" }
for _, ls in ipairs(servers) do
    lsp[ls].setup {
        on_attach = _G.on_attach,
        capabilities = capabilities,
    }
end

--Compe-config
require'compe'.setup {
    autocomplete  = true;
    debug = false;
    documentation = true;
    enabled    = true;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    min_length = 1;
    preselect  = 'enable';
    source_timeout = 200;
    throttle_time = 80;
    source = {
        buffer = true;
        calc = true;
        nvim_lsp = true;
        nvim_lua = true;
        path = true;
        spell  = true;
        tags = true;
        vsnip  = true;
    };
}
