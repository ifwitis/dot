local M = {}

local ignored_dirs = {
    [".git"] = true,
    [".cache"] = true,
    ["node_modules"] = true,
    [".venv"] = true,
    ["venv"] = true,
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

M.config = {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
    },
    root_markers = {
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

        params.initializationOptions =
            params.initializationOptions or {}

        params.initializationOptions.fallbackFlags =
            recursive_include_flags(config.root_dir)
    end,
}

return M
