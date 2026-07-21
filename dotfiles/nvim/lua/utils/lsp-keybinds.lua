local M = {}

M.on_attach = function(event)
    if not event.data then
        return
    end

    local ok, client = pcall(vim.lsp.get_client_by_id, event.data.client_id)

    if not ok or not client then
        return
    end
    local bufnr = event.buf
    local def_opts = {
        noremap = true, -- prevent recursive mapping
        silent = true,  -- don't print the command to the cli
        buffer = bufnr, -- restrict the keymap to the local buffer number
    }
    local function map(mode, lhs, rhs, desc)
        local opts = vim.tbl_extend("force", def_opts, { desc = desc })
        vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Navigation
    map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "LSP: Go to declaration")
    map("n", "gi", vim.lsp.buf.implementation, "LSP: Go to implementation")
    map("n", "go", vim.lsp.buf.type_definition, "LSP: Go to type definition")
    map("n", "gR", vim.lsp.buf.references, "LSP: Go to references")
    map("n", "gs", vim.lsp.buf.signature_help, "LSP: Signature help")

    -- Docs / info
    map("n", "<leader>dd", vim.lsp.buf.hover, "LSP: Hover docs")

    -- Refactor
    map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename symbol")

    -- Order Imports (if supported by the client LSP)
    if client:supports_method("textDocument/codeAction", bufnr) then
        map("n", "<leader>ca", function()
            vim.lsp.buf.code_action({
                context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                },
                apply = true,
                bufnr = bufnr,
            })
            -- format after changing import order
            vim.defer_fn(function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end, 50) -- slight delay to allow for the import order to go first
        end, "LSP: Code action")
    end

    -- Diagnostics
    map("n", "<leader>de", vim.diagnostic.open_float, "LSP: Show line diagnostics")
    map("n", "<leader>dp", function()
        vim.diagnostic.jump({ count = -1, float = true })
    end, "LSP: Previous diagnostic")
    map("n", "<leader>dn", function()
        vim.diagnostic.jump({ count = 1, float = true })
    end, "LSP: Next diagnostic")
    map("n", "<leader>dl", vim.diagnostic.setloclist, "LSP: Diagnostics to loclist")

    -- Formatting (guard: only map if the client actually supports it,
    -- so e.g. ruff and basedpyright don't both fight over the buffer)
    if client and client:supports_method("textDocument/formatting") then
        map({ "n", "x" }, "<leader>df", function()
            vim.lsp.buf.format({ async = true, bufnr = bufnr })
        end, "LSP: Format buffer")
    end

    -- Inlay hints toggle, if the server + Neovim support it
    if client and client:supports_method("textDocument/inlayHint") then
        map("n", "<leader>dh", function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
        end, "LSP: Toggle inlay hints")
    end
end

return M
