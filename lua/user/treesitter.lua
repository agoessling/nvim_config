local languages = {
	"lua",
	"markdown",
	"markdown_inline",
	"bash",
	"python",
	"cpp",
	"c",
	"vim",
	"json",
	"rust",
}

local M = {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false,
}

function M.config()
	local treesitter = require("nvim-treesitter")

	treesitter.setup()
	treesitter.install(languages):wait(300000)

	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local language = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
			if not language or not vim.list_contains(languages, language) then
				return
			end

			local started = pcall(vim.treesitter.start, args.buf, language)
			if started then
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end,
	})
end

return M
