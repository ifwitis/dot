local ignored_dirs = {
  [".git"] = true,
  [".cache"] = true,
  ["node_modules"] = true,
  [".venv"] = true,
  ["venv"] = true,
  ["build"] = true,
}

-- Approximate VS Code's recursive include directory behavior
local function recursive_include_flags(root)
  local flags = {}

  local function walk(dir)
    table.insert(flags, "-I" .. dir)

    for name, kind in vim.fs.dir(dir) do
      if kind == "directory" and not ignored_dirs[name] then
        walk(vim.fs.joinpath(dir, name))
      end
    end
  end

  walk(root)
  return flags
end

-- Recursively locate a compilation database
local function find_compile_commands(root)
  local function walk(dir)
    for name, kind in vim.fs.dir(dir) do
      local path = vim.fs.joinpath(dir, name)

      if kind == "file" and name == "compile_commands.json" then
        return path
      end

      if kind == "directory" and (name == "build" or not ignored_dirs[name]) then
        local result = walk(path)
        if result then
          return result
        end
      end
    end
  end

  return walk(root)
end

return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--fallback-style=Webkit",
  },

  root_markers = {
    ".clangd",
    "compile_commands.json",
    "compile_flags.txt",
    "CMakeLists.txt",
    ".git",
  },

  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
    "cuda",
  },

  before_init = function(params, config)
    if not config.root_dir then
      return
    end

    params.initializationOptions = params.initializationOptions or {}
    local opts = params.initializationOptions

    local compile_commands = find_compile_commands(config.root_dir)
    if compile_commands then
      opts.compilationDatabasePath = vim.fs.dirname(compile_commands)
    end

    opts.fallbackFlags = recursive_include_flags(config.root_dir)
  end,
}
