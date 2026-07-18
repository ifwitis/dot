return {
    { "nvim-mini/mini.ai", version = "*", opts = {} },
    {
        "nvim-mini/mini.move", version = "*", opts = {},
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
            -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
            left = '<M-Left>',
            right = '<M-Right>',
            down = '<M-Down>',
            up = '<M-Up>',

            -- Move current line in Normal mode
            line_left = '<M-h>',
            line_right = '<M-l>',
            line_down = '<M-j>',
            line_up = '<M-k>',
        },

        -- Options which control moving behavior
        options = {
            -- Automatically reindent selection during linewise vertical move
            reindent_linewise = true,
        },
    },
    { "nvim-mini/mini.bufremove", version = "*", opts = {} },
    { "nvim-mini/mini.surround", version = "*", opts = {} },
    { "nvim-mini/mini.pairs", version = "*", opts = {} },
    { "nvim-mini/mini.indentscope", version = "*", opts = {} },
    -- { "nvim-mini/mini.trailspace", version = "*", opts = {} },
    { "nvim-mini/mini.notify", version = "*", opts = {} },
}
