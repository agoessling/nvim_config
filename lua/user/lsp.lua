local M = {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{
			"hrsh7th/cmp-nvim-lsp",
		},
	},
}

function M.config()
	local cmp_nvim_lsp = require("cmp_nvim_lsp")
	local lsp_keymaps = require("user.lsp_config.keymaps")
	local lsp_diagnostics = require("user.lsp_config.diagnostics")
	local lsp_servers = require("user.lsp_config.servers")

	local function prewarm_python_checker(client, bufnr)
		vim.defer_fn(function()
			if not vim.api.nvim_buf_is_valid(bufnr) or (client.is_stopped and client:is_stopped()) then
				return
			end

			local text_document = vim.lsp.util.make_text_document_params(bufnr)
			local hover_params = {
				textDocument = text_document,
				position = { line = 0, character = 0 },
			}

			local winid = vim.fn.bufwinid(bufnr)
			if winid ~= -1 then
				vim.api.nvim_win_call(winid, function()
					hover_params = vim.lsp.util.make_position_params(winid, client.offset_encoding or "utf-16")
				end)
			end

			-- Pyright-family servers often pay a multi-second parse/type-analysis cost on the
			-- first interactive request. Do that work quietly after attach.
			client:request("textDocument/documentSymbol", { textDocument = text_document }, function() end, bufnr)
			client:request("textDocument/hover", hover_params, function() end, bufnr)
		end, 1000)
	end

	local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
	if not vim.env.PATH:find(mason_bin, 1, true) then
		vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
	end

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

	local on_attach = function(client, bufnr)
		if client.name == "ts_ls" then
			client.server_capabilities.documentFormattingProvider = false
		end

		if client.name == "lua_ls" then
			client.server_capabilities.documentFormattingProvider = false
		end

		if client.name == "ruff" then
			client.server_capabilities.hoverProvider = false
			client.server_capabilities.definitionProvider = false
			client.server_capabilities.declarationProvider = false
			client.server_capabilities.typeDefinitionProvider = false
			client.server_capabilities.implementationProvider = false
			client.server_capabilities.referencesProvider = false
			client.server_capabilities.renameProvider = false
		end

		if client.name == "basedpyright" then
			prewarm_python_checker(client, bufnr)
		end

		lsp_keymaps.set(bufnr)
	end

	lsp_servers.setup(capabilities, on_attach)
	lsp_diagnostics.setup()
end

return M
