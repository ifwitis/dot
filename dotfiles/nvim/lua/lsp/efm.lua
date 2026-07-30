M = {}

-- efmls-configs-supported Linters and Formatters from The Rad Lectures (YouTube)
local selene = require("efmls-configs.linters.selene")               -- lua linter
local stylua = require("efmls-configs.formatters.stylua")            -- lua formatter
local flake8 = require("efmls-configs.linters.flake8")               -- python linter
local black = require("efmls-configs.formatters.black")              -- python formatter
local golint = require("efmls-configs.linters.golangci_lint")        -- go linter
local gofumpt = require("efmls-configs.formatters.gofumpt")          -- go formatter
local eslint_d = require("efmls-configs.linters.eslint_d")           -- ts/js/solidity/json/react/svelte/vue linter
local prettier_d = require("efmls-configs.formatters.prettier_d")    -- ts/js/solidity/json/markdown/docker/html/css/react/svelte/vue formatter
local cpplint = require("efmls-configs.linters.cpplint")             -- c/cpp linter
local clangformat = require("efmls-configs.formatters.clang_format") -- c/cpp formatter
local fixjson = require("efmls-configs.formatters.fixjson")          -- json formatter
local shellcheck = require("efmls-configs.linters.shellcheck")       -- bash linter
local shfmt = require("efmls-configs.formatters.shfmt")              -- bash formatter
local hadolint = require("efmls-configs.linters.hadolint")           -- docker linter
local cmakelint = require("efmls-configs.linters.cmake_lint")        -- cmake linter
local yamllint = require("efmls-configs.linters.yamllint")           -- yaml linter

-- Non-supported Linters and Formatters configurations
local csharpier = {
    formatCommand = 'csharpier --write-stdout',
    formatStdin = true,
}

M.tools = {
    -- efmls-config supported
    'selene',
    'stylua',
    'flake8',
    'black',
    'golangci-lint',
    'gofumpt',
    'prettierd',
    'eslint_d',
    'cpplint',
    'fixjson',
    'shellcheck',
    'shfmt',
    'hadolint',
    'clang-format',
    'cmakelint',
    'yamllint',
    -- efmls-config non-supported
    'csharpier',
}

-- Language Configurations for EFM Language Server
-- local languages = require('efmls-configs.defaults').languages()
local languages = {
    c = { clangformat, cpplint },
    cpp = { clangformat, cpplint },
    cs = { csharpier },
    css = { prettier_d },
    docker = { hadolint, prettier_d },
    cmake = { cmakelint, },
    yaml = { yamllint, },
    go = { golint, gofumpt },
    html = { prettier_d },
    javascript = { eslint_d, prettier_d },
    javascriptreact = { eslint_d, prettier_d },
    json = { eslint_d, fixjson },
    jsonc = { eslint_d, fixjson },
    lua = { selene, stylua },
    markdown = { prettier_d },
    python = { flake8, black },
    sh = { shellcheck, shfmt },
    svelte = { eslint_d, prettier_d },
    typescript = { eslint_d, prettier_d },
    typescriptreact = { eslint_d, prettier_d },
    vue = { eslint_d, prettier_d },
}

local filetypes = vim.tbl_keys(languages)

M.config = {
    cmd = 'efm-langserver',
    filetypes = filetypes,
    root_markers = { '.git' },
    settings = {
        languages = languages,
    },
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
        hover = true,
        documentSymbol = true,
        codeAction = true,
        completion = true,
    },
}

return M
