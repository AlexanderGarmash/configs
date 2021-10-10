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
  use 'ludovicchabant/vim-gutentags' -- Automatic tags management
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
end)
