local M = {}

local severity = vim.diagnostic.severity
local important = { min = severity.WARN }

M.setup = function()
  vim.diagnostic.config({
    update_in_insert = false,
    severity_sort = true,

    virtual_text = {
      spacing = 4,
      prefix = "●",
      source = "if_many",
      current_line = true,
      severity = important,
    },

    virtual_lines = false,

    underline = {
      severity = important,
    },

    signs = {
      severity = important,
      text = {
        [severity.ERROR] = " ",
        [severity.WARN] = " ",
        [severity.HINT] = " ",
        [severity.INFO] = " ",
      },
    },

    float = {
      border = "rounded",
      source = true,
      severity_sort = true,
      focusable = true,
    },
  })

  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, {
      silent = true,
      desc = "Diagnostics: " .. desc,
    })
  end

  -- Navigation
  map("[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, "Previous diagnostic")

  map("]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, "Next diagnostic")

  map("[e", function()
    vim.diagnostic.jump({
      count = -1,
      severity = severity.ERROR,
      float = true,
    })
  end, "Previous error")

  map("]e", function()
    vim.diagnostic.jump({
      count = 1,
      severity = severity.ERROR,
      float = true,
    })
  end, "Next error")

  -- Diagnostic information
  map("<leader>dd", function()
    vim.diagnostic.open_float({ scope = "line" })
  end, "Show line diagnostics")

  map("<leader>dl", vim.diagnostic.setloclist, "Document diagnostics")
  map("<leader>dw", vim.diagnostic.setqflist, "Workspace diagnostics")

  -- Toggle diagnostics for current buffer
  map("<leader>dt", function()
    local filter = { bufnr = 0 }
    local enabled = not vim.diagnostic.is_enabled(filter)

    vim.diagnostic.enable(enabled, filter)
    vim.notify("Diagnostics " .. (enabled and "enabled" or "disabled"))
  end, "Toggle diagnostics")
end

return M
