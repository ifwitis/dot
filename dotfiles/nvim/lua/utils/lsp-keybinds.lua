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
        silent = true, -- don't print the command to the cli
        buffer = bufnr, -- restrict the keymap to the local buffer number
    }
    local function map(mode, lhs, rhs, desc)
        local opts = vim.tbl_extend("force", def_opts, { desc = desc })
        vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Navigation
    map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", "LSP: Peek definition")
    map("n", "gD", "<cmd>vsplit | Lspsaga go_to_definition<CR>", "LSP: Go to definition in split window")
    map("n", "gi", vim.lsp.buf.declaration, "LSP: Go to implementation")
    map("n", "go", vim.lsp.buf.type_definition, "LSP: Go to type definition")
    map("n", "gR", vim.lsp.buf.references, "LSP: Go to references")
    map("n", "gs", vim.lsp.buf.signature_help, "LSP: Signature help")

    -- Docs / info
    map("n", "<leader>D", "<cmd>Lspsaga hover_doc<CR>", "LSP: Hover docs")

    -- Rename
    map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", "LSP: Rename symbol")

    -- Diagnostics
    map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", "LSP: Code actions")

    map("n", "<leader>dd", "<cmd>Lspsaga show_line_diagnostics<CR>", "LSP: Show line diagnostics")
    map("n", "<leader>de", "<cmd>Lspsaga show_cursor_diagnostics<CR>", "LSP: Show cursor diagnostics")
    map("n", "<leader>dp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "LSP: Prev diagnostic")
    map("n", "<leader>dn", "<cmd>Lspsaga diagnostic_jump_next<CR>", "LSP: Next diagnostic")

    map("n", "<leader>dl", vim.diagnostic.setloclist, "LSP: Diagnostics to loclist")

    -- Order Imports (if supported by the client LSP)
    if client:supports_method("textDocument/codeAction", bufnr) then
        map("n", "<leader>oi", function()
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
        end, "LSP: Organize imports")
    end

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
