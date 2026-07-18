local M = {
	root_dir = function(bufnr, on_dir)
		local name = vim.api.nvim_buf_get_name(bufnr)
		local root = vim.fs.root(name, { "Cargo.toml", "rust-project.json", ".git" })

		if root then
			on_dir(root)
		end
	end,
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
			},
			check = {
				command = "clippy",
			},
		},
	},
}

return M
