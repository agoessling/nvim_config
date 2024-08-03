local M = {
  "jose-elias-alvarez/null-ls.nvim",
  event = "BufReadPre",
  dependencies = {
    {
      "jay-babu/mason-null-ls.nvim",
      "nvim-lua/plenary.nvim",
      lazy = true,
    },
  },
}

function M.config()
  local null_ls = require("null-ls")
  local formatting = null_ls.builtins.formatting

  null_ls.setup({
    debug = false,
    sources = {
      formatting.prettier.with({
        extra_filetypes = { "toml" },
        extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
      }),
      formatting.stylua,
    },
  })

  require("mason-null-ls").setup({
    ensure_installed = nil,
    automatic_installation = true,
  })
end

return M
