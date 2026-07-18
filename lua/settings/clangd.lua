local M = {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"--query-driver=**/aarch64-linux-gnu*",
		"--query-driver=**/arm-none-eabi*",
	},
}

return M
