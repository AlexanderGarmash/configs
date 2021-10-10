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

vim.g.mapleader = ','
-- Mappings
map('n', '<Space>',   '<NOP>')      -- Unmap space key
map('n', '<Up>', '<NOP>')
map('n', '<Down>', '<NOP>')
map('n', '<Left>', '<NOP>')
map('n', '<Right>', '<NOP>')
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
map('n', '<C-w>o', ':only')
-- for better Movement between Buffers
map('n', '<Tab>',   ':bnext<CR>')
map('n', '<S-Tab>', ':bprevious<CR>')
