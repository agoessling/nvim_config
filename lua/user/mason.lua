local M = {
  "williamboman/mason.nvim",
  cmd = "Mason",
  event = "BufReadPre",
  dependencies = {
    {
      "williamboman/mason-lspconfig.nvim",
      lazy = true,
    },
  },
}

function M.config()
  require("mason").setup()
  require("mason-lspconfig").setup {
    ensure_installed = { "basedpyright", "clangd", "ruff", "rust_analyzer" },
    automatic_enable = false,
  }
end

return M
