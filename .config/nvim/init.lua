require'plugins'
require'init'
require'keybindings'
require'vim_config'
require'completion'
require'treesitter'
require'init_telescope'

-- LSP configuration doesn't work from separate file
local lsp = require 'lspconfig'
local on_attach = function(client, bufnr)
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

vim.lsp.set_log_level("debug")

-- by some reason it doesn't work if initialized in after/ftplugin/python.lua
require'lspconfig'.pylsp.setup{
    on_attach = on_attach,
    settings={
        pylsp = {
            configurationSources = {"pyflakes"},
            plugins = { pydocstyle = {enabled = true}},
            type = "string",
            flake8 = {
                enabled = true,
                maxLineLength = 120
            },
            pycodestyle = {
                maxLineLength = 120,
                enabled = false
            }
        }
    }
}
