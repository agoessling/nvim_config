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
      local conf_on_attach = conf_opts.on_attach
      opts = vim.tbl_deep_extend("force", conf_opts, opts)
      if conf_on_attach and on_attach then
        opts.on_attach = function(client, bufnr)
          conf_on_attach(client, bufnr)
          on_attach(client, bufnr)
        end
      end
    end

    vim.lsp.config(server, opts)

    local cmd = vim.lsp.config[server].cmd
    if type(cmd) == "function" or (type(cmd) == "table" and vim.fn.executable(cmd[1]) == 1) then
      vim.lsp.enable(server)
    end
  end
end

return M
