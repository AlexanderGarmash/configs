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
vim.opt.smartindent = true
vim.opt.expandtab = true    -- tab to spaces
vim.o.softtabstop = 4       -- How many columns cursors moves right, when <Tab> pressed
vim.o.shiftwidth = 4        -- the width for indent

-- Appearance
vim.wo.number = true                -- Show current line number
vim.wo.relativenumber = true        -- use relative numbers for other lines
vim.opt.wrap = false     -- disable wraps
vim.api.nvim_command('colorscheme gruvbox8_soft')
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 20      -- The minimal number of columns to scroll horizontally.
vim.opt.cursorline = true       -- highlight the line of the cursor

--Set statusbar
vim.g.lightline = {
  colorscheme = 'solarized',
  active = { left = { { 'mode', 'paste' }, { 'readonly', 'filename', 'modified' } } },
}
