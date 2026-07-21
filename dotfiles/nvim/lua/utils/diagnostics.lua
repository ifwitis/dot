local M = {}

local diagnostic_signs = {
    Error = " ",
    Warn = " ",
    Hint = "",
    Info = "",
}

M.setup = function()
    vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = "●" },
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = true },
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
                [vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
                [vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
                [vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
            },
        },
    })
end

return M
