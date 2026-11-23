return {
    { "nvim-mini/mini.ai",        version = "*", opts = {} },
    {
        "nvim-mini/mini.move",
        version = "*",
        opts = {},
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
    { "nvim-mini/mini.surround",  version = "*", opts = {} },
    {
        "nvim-mini/mini.pairs",
        version = "*",
        opts =
        {
            mappings = {
                ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\][%s,;%)%]%}]' },
                ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\][%s,;%)%]%}]' },
                ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\][%s,;%)%]%}]' },

                [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
                [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
                ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },
                ['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].' },

                [';'] = { action = 'close', pair = '.;', neigh_pattern = '.;' },
                [','] = { action = 'close', pair = '.,', neigh_pattern = '.,' },

                ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\][%s,;)]', register = { cr = false } },
                ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^\\][%s,;)]', register = { cr = false } },
                ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\][%s,;)]', register = { cr = false } },
            },
        },
        -- Custom closeopen to ignore unclosed ' " ` in line
        config = function(_, opts)
            local MiniPairs = require("mini.pairs")
            MiniPairs.setup(opts)

            local orig_closeopen = MiniPairs.closeopen

            MiniPairs.closeopen = function(pair, neigh_pattern)
                local open_char = pair:sub(1, 1)

                if open_char == '"' or open_char == "'" or open_char == "`" then
                    local line = vim.api.nvim_get_current_line()
                    local col = vim.api.nvim_win_get_cursor(0)[2]
                    local before_cursor = line:sub(1, col)
                    local next_char = line:sub(col + 1, col + 1)

                    -- Skip existing closing quotes
                    if next_char == open_char then
                        return orig_closeopen(pair, neigh_pattern)
                    end

                    -- Count unescaped quotes before cursor
                    local count = 0
                    local escaped = false

                    for i = 1, #before_cursor do
                        local char = before_cursor:sub(i, i)
                        if char == "\\" then
                            escaped = not escaped
                        else
                            if char == open_char and not escaped then
                                count = count + 1
                            end
                            escaped = false
                        end
                    end

                    -- Close unclosed quotes without inserting another pair
                    if count % 2 == 1 then
                        return open_char
                    end
                end

                return orig_closeopen(pair, neigh_pattern)
            end
        end,
    },
    { "windwp/nvim-ts-autotag",     opts = {} },
    { "nvim-mini/mini.indentscope", version = "*", opts = {} },
    -- { "nvim-mini/mini.trailspace", version = "*", opts = {} },
    -- { "nvim-mini/mini.notify", version = "*", opts = {} },
}
