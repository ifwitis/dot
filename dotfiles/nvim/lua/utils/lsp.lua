local M = {}

M.on_attach = function(event)
  local bufnr = event.buf
  local lsp = vim.lsp.buf

  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      buffer = bufnr,
      silent = true,
      desc = "LSP: " .. desc,
    })
  end

  -- Navigation
  map("n", "gd", "<cmd>Lspsaga goto_definition<CR>", "Go to definition")
  map("n", "gD", lsp.declaration, "Go to declaration")
  map("n", "gi", "<cmd>Lspsaga finder imp<CR>", "Find implementations")
  map("n", "go", "<cmd>Lspsaga goto_type_definition<CR>", "Go to type definition")
  map("n", "grr", "<cmd>Lspsaga finder ref<CR>", "Find references")
  map("n", "gf", "<cmd>Lspsaga finder<CR>", "Find symbol")
  map("n", "gv", function()
    vim.cmd("vsplit")
    vim.cmd("Lspsaga goto_definition")
  end, "Definition in vertical split")

  -- Previews
  map("n", "gp", "<cmd>Lspsaga peek_definition<CR>", "Peek definition")
  map("n", "gP", "<cmd>Lspsaga peek_type_definition<CR>", "Peek type definition")

  -- Documentation
  map("n", "gk", "<cmd>Lspsaga hover_doc<CR>", "Hover documentation")
  map("n", "gs", lsp.signature_help, "Signature help")
  map("i", "<C-s>", lsp.signature_help, "Signature help")

  -- Refactoring
  map("n", "<leader>rn", "<cmd>Lspsaga lsp_rename<CR>", "Rename symbol")
  map({ "n", "x" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", "Code actions")

  -- Symbols and call hierarchy
  map("n", "<leader>lo", "<cmd>Lspsaga outline<CR>", "Symbol outline")
  map("n", "<leader>li", "<cmd>Lspsaga incoming_calls<CR>", "Incoming calls")
  map("n", "<leader>lc", "<cmd>Lspsaga outgoing_calls<CR>", "Outgoing calls")

  -- Organize imports
  map("n", "<leader>oi", function()
    lsp.code_action({
      context = {
        only = { "source.organizeImports" },
        diagnostics = {},
      },
      apply = true,
    })
  end, "Organize imports")

  -- Inlay hints
  map("n", "<leader>dh", function()
    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
  end, "Toggle inlay hints")
end

return M
