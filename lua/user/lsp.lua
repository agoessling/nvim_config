local M = {
  "neovim/nvim-lspconfig",
  lazy = true,
  dependencies = {
    {
      "hrsh7th/cmp-nvim-lsp",
    },
  },
}

local cmp_nvim_lsp = require "cmp_nvim_lsp"
local lsp_keymaps = require "user.lsp_config.keymaps"
local lsp_diagnostics = require "user.lsp_config.diagnostics"
local lsp_servers = require "user.lsp_config.servers"

function M.config()
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

    lsp_keymaps.set(bufnr)
  end

  lsp_servers.setup(capabilities, on_attach)
  lsp_diagnostics.setup()
end

return M
