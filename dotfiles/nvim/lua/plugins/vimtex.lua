return {
    "lervag/vimtex",
    lazy = false,
    init = function()
        vim.g.vimtex_view_method = "sioyek"
        vim.g.vimtex_view_sioyek_exe = "/Applications/sioyek.app/Contents/MacOS/sioyek"
        vim.g.vimtex_compiler_method = "latexmk"

        -- Turn off warnings
        vim.g.vimtex_quickfix_open_on_warning = 0

        -- Set compilation directories
        vim.g.vimtex_compiler_latexmk = {
            out_dir = "pdf",
            aux_dir = ".build",
        }

        -- (Tmp) Turn off treesitter warning
        vim.g.vimtex_syntax_enabled = 0
        vim.g.vimtex_syntax_conceal_disable = 1
    end
}
