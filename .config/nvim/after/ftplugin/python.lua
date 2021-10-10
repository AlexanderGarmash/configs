vim.opt.colorcolumn = '121'

vim.api.nvim_command('autocmd BufWritePre *.py normal m`:%s/\\s\\+$//e ``')    -- Before save - strip
-- Enable smart indents after key words
-- vim.api.nvim_command('autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class')
