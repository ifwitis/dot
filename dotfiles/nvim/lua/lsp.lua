local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
    capabilities = blink.get_lsp_capabilities(capabilities)
else
    local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
    end
end

-- Apply capabilities to every server config, globally, before we enable anything else.
vim.lsp.config("*", {
    capabilities = capabilities,
})

-- LSP Servers
local servers = {
    "bashls",
    "clangd",
    "gopls",
    "html",
    "cssls",
    "ts_ls",
    "basedpyright",
    "rust_analyzer",
    "lua_ls",
    "roslyn_ls",
    "dockerls",
    "cmake",
    "jsonls",
    "yamlls",
}

require("utils.diagnostics").setup();
require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_enable = servers,
})
