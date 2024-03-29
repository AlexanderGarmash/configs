require'compe'.setup {
    autocomplete  = false;
    debug = false;
    enabled    = true;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    min_length = 1;
    preselect  = 'enable';
    source_timeout = 200;
    throttle_time = 80;
    documentation = {
        border = { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }, -- the border option is the same as `|help nvim_open_win|`
        winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
        max_width = 120,
        min_width = 60,
        max_height = math.floor(vim.o.lines * 0.3),
        min_height = 1,
    };
    source = {
        buffer = true;
        calc = true;
        nvim_lsp = true;
        nvim_lua = true;
        path = true;
        spell  = true;
        tags = true;
        vsnip  = false;
    };
}
