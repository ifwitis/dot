M = {}

M.config = {
    settings = {
        basedpyright = {
            disableOrganizeImports = false,
            analysis = {
                useLibraryCodeForTypes = true,
                autoSearchPaths = true,
                autoImportCompletions = true,
                typeCheckingMode = "standard",
                diagnosticMode = "workspace",
            },
        },
    },
}

return M
