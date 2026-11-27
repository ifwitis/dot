return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = { vim.env.VIMRUNTIME },
        checkThirdParty = false,
      },
      completion = {
        callSnippet = "Replace",
      },
      format = {
        enable = true,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
