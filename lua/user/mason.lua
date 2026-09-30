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
    ensure_installed = vim.env.DEFAULTS_NVIM_SETUP == "1" and {} or { "basedpyright", "biome", "clangd", "ruff", "rust_analyzer", "ts_ls" },
    automatic_enable = false,
  }
end

return M
