return {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets' },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        keymap = {
            preset = "none",

            -- CTRL+E to toggle
            ["<C-e>"] = { "show", "hide", 'show_documentation', 'hide_documentation'  },
            ["<M-e>"] = { "show", "hide", 'show_documentation', 'hide_documentation'  },
            ["<D-e>"] = { "show", "hide", 'show_documentation', 'hide_documentation'  },

            -- Enter to accept
            ["<CR>"] = { "select_and_accept", "fallback" },

            -- Tab to accept 
            ["<Tab>"] = {
                "select_and_accept",
                "snippet_forward",
                "fallback",
            },
            ["<Down>"] = {
                "select_next",
                "snippet_forward",
                "fallback",
            },

            -- Shift Tab to scroll
            ["<S-Tab>"] = {
                "select_next",
                "snippet_backward",
                "fallback",
            },
            ["<Up>"] = {
                "select_prev",
                "snippet_backward",
                "fallback",
            },

            -- Escape to cancel
            ["<Esc>"] = {
                "cancel",
                "fallback"
            }
        },

        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'normal',
            use_nvim_cmp_as_default = true,
            kind_icons = {
                Text = '󰉿',
                Method = '󰊕',
                Function = '󰊕',
                Constructor = '󰒓',

                Field = '󰜢',
                Variable = '󰆦',
                Property = '󰖷',

                Class = '󱡠',
                Interface = '󱡠',
                Struct = '󱡠',
                Module = '󰅩',

                Unit = '󰪚',
                Value = '󰦨',
                Enum = '󰦨',
                EnumMember = '󰦨',

                Keyword = '󰻾',
                Constant = '󰏿',

                Snippet = '󱄽',
                Color = '󰏘',
                File = '󰈔',
                Reference = '󰬲',
                Folder = '󰉋',
                Event = '󱐋',
                Operator = '󰪚',
                TypeParameter = '󰬛',
            },
        },

        completion = {
            keyword = { range = "full" },
            accept = { auto_brackets = { enabled = true } },

            documentation = {
                auto_show = false,
                auto_show_delay_ms = 50,
                treesitter_highlighting = true,
                window = { border = "rounded" },
            },

            list = {
                selection = {
                    auto_insert = true,
                    preselect = false,
                }
            },

            menu = {
                enabled = true,
                min_width = 10,
                max_height = 10,
                border = "rounded",
                auto_show = true,
                auto_show_delay_ms = 0,
                scrollbar = false,

                cmdline_position = function()
                    if vim.g.ui_cmdline_pos ~= nil then
                        local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
                        return { pos[1] - 1, pos[2] }
                    end
                    local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
                    return { vim.o.lines - height, 0 }
                end,

                draw = {
                    -- Aligns the keyword you've typed to a component in the menu
                    align_to = 'label', -- 'label', none', or 'cursor' 
                    -- Left and right padding, optionally { left, right } for different padding on each side
                    padding = 1,
                    -- Gap between columns
                    gap = 2,
                    -- Priority of the cursorline highlight, setting this to 0 will render it below other highlights
                    cursorline_priority = 10000,
                    -- Appends an indicator to snippets label
                    snippet_indicator = '~',
                    -- Use treesitter to highlight the label text for the given list of sources
                    treesitter = { 'lsp' },
                    -- treesitter = { 'lsp' }
                    columns = {
                        { 'kind_icon' }, { 'label', 'label_description', gap = 1 }
                    },
                    components = {}
                },
            },

            ghost_text = {
                enabled = true,
            }
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" },

        cmdline = {
            -- keymap = {
            --     preset = 'inherit',
            --     ['<Tab>'] = { 'show', 'accept', 'fallback' },
            -- },
            -- completion = {
            --     menu = { auto_show = true },
            --     ghost_text = { enabled = false },
            -- },
        },
    },
    opts_extend = { "sources.default" }
}
