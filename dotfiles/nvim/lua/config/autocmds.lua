-----------------------------------------------------------
-- Autocommand functions
-----------------------------------------------------------

-- Define autocommands with Lua APIs
-- See: :h api-autocmd, :h augroup
-- https://neovim.io/doc/user/autocmd.html

local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

-----------------------------------------------------------
-- General settings
-----------------------------------------------------------

-- Highlights text when yanked 
autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 200,
        })
    end,
})

-- Restore cursor to file position in previous editing session
autocmd("BufReadPost", {
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.cmd('normal! g`"zz')
        end
    end,
})

-- Show cursorline only on active windows
autocmd({ "InsertLeave", "WinEnter" }, {
    callback = function()
        if vim.w.auto_cursorline then
            vim.wo.cursorline = true
            vim.w.auto_cursorline = false
        end
    end,
})

autocmd({ "InsertEnter", "WinLeave" }, {
    callback = function()
        if vim.wo.cursorline then
            vim.w.auto_cursorline = true
            vim.wo.cursorline = false
        end
    end,
})


-----------------------------------------------------------
-- LSP 
-----------------------------------------------------------

local lsp_on_attach_group = augroup("LspMappings", {})
local on_attach = require("utils.lsp-keybinds").on_attach
autocmd("LspAttach", {
    group = lsp_on_attach_group,
    callback = on_attach,
})


-----------------------------------------------------------
-- Neovim Treesitter
-----------------------------------------------------------

autocmd('FileType', {
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    local available_langs = require('nvim-treesitter').get_available()
    local is_available = vim.tbl_contains(available_langs, lang)
    if is_available then
      local installed_langs = require('nvim-treesitter').get_installed()
      local installed = vim.tbl_contains(installed_langs, lang)
      if not installed then
        require('nvim-treesitter').install(lang):wait()
      end
      vim.treesitter.start()
      require('nvim-treesitter').indentexpr()
    end
  end,
})


-----------------------------------------------------------
-- Colorscheme
-----------------------------------------------------------

autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        if vim.o.background == "light" then
            -- Dark cursor for high visibility on light backgrounds
            vim.api.nvim_set_hl(0, "Cursor", { fg = "#FFFFFF", bg = "#005FDB" })
            vim.api.nvim_set_hl(0, "lCursor", { fg = "#FFFFFF", bg = "#000000" })
        else
            -- Light cursor for high visibility on dark backgrounds
            vim.api.nvim_set_hl(0, "Cursor", { reverse = true, })
            vim.api.nvim_set_hl(0, "lCursor", { reverse = true, })
        end
    end,
})
