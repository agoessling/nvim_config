local M = {}

function M.setup(capabilities, on_attach)
  for _, server in pairs(require("utils").servers) do
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    server = vim.split(server, "@")[1]

    local require_ok, conf_opts = pcall(require, "settings." .. server)
    if require_ok then
      opts = vim.tbl_deep_extend("force", conf_opts, opts)
    end

    vim.lsp.config(server, opts)
    vim.lsp.enable(server)
  end
end

return M
