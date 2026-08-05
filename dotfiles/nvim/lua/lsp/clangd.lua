local M = {}

M.config = {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--fallback-style=LLVM",
	},
}

return M
