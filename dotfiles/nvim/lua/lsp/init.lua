-- ---------------------------------------------------------------------
-- Capabilities: advertise extra client capabilities (e.g. from
-- nvim-cmp/blink.cmp) to every server, if a completion plugin is present.
-- ---------------------------------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
	capabilities = cmp_lsp.default_capabilities(capabilities)
end

local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
	capabilities = blink.get_lsp_capabilities(capabilities)
end

-- Apply capabilities to every server config, globally, before we enable anything else.
vim.lsp.config("*", {
	capabilities = capabilities,
})

-- LSP Servers
local servers = {
	"efm", -- Technically linter and formatter handler
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

-- EFM Linter and Formatter Tools
local has_efm, efm_config_module = pcall(require, "lsp.efm")
local mason_tools = vim.list_extend(vim.deepcopy(servers), has_efm and efm_config_module.tools or {})
-- vim.print(has_efm, efm_config_module)
-- vim.print(mason_tools)

-- Automatically install LSPs, Linters, and Formatters
require("mason-tool-installer").setup({
	ensure_installed = mason_tools,
	auto_update = true,
	run_on_start = true,
    start_delay = 3000,
})
-- Automatically clean up tools 
vim.cmd("MasonToolsClean")

-- ---------------------------------------------------------------------
-- Server-specific configs that lspconfig's bundled defaults don't cover,
-- or that you want to override. `vim.lsp.config(name, {...})` MERGES
-- with whatever nvim-lspconfig ships in its lsp/<name>.lua, so you only
-- need to specify the parts you want to change.
-- If no config file exists, defaults are enabled by nvim-lspconfig
-- ---------------------------------------------------------------------

for _, server in ipairs(servers) do
	local has_config_file, config_module = pcall(require, "lsp." .. server)
	if has_config_file then
		vim.lsp.config(server, config_module.config)
		-- vim.notify("Configured " .. server)
	end
end

-- ---------------------------------------------------------------------
-- Enable every server mason-tool-installer ensures is installed.
-- Keep this list in sync with the `ensure_installed` table in lsp.lua,
-- MINUS the entries that aren't LSP servers (stylua is a formatter,
-- htmlhint is a linter — neither speaks LSP).
-- ---------------------------------------------------------------------
vim.lsp.enable(servers)
