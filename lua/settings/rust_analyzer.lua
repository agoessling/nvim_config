local M = {
	cmd = function(dispatchers, config)
		local metadata = require("project_metadata").read(config.root_dir)
		local env = vim.deepcopy(config.cmd_env or {})
		if metadata and metadata.rustc then
			env.RUSTC = metadata.rustc
			env.PATH = vim.fs.dirname(metadata.rustc) .. ":" .. vim.env.PATH
		end
		return vim.lsp.rpc.start({ "rust-analyzer" }, dispatchers, {
			cwd = config.cmd_cwd,
			env = env,
			detached = config.detached,
		})
	end,
	root_dir = function(bufnr, on_dir)
		local name = vim.api.nvim_buf_get_name(bufnr)
		local root = vim.fs.root(name, { "Cargo.toml", "rust-project.json", ".git" })

		if root then
			on_dir(root)
		end
	end,
	before_init = function(_, config)
		if config.root_dir and vim.fn.filereadable(config.root_dir .. "/rust-project.json") == 1 then
			config.settings["rust-analyzer"] = {
				linkedProjects = { config.root_dir .. "/rust-project.json" },
				checkOnSave = false,
				cargo = { buildScripts = { enable = false } },
			}
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
