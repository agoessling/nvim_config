local M = {}

function M.set(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local keymap = vim.keymap.set

  keymap("n", "gD", vim.lsp.buf.declaration, opts)
  keymap("n", "gd", vim.lsp.buf.definition, opts)
  keymap("n", "K", vim.lsp.buf.hover, opts)
  keymap("n", "gI", vim.lsp.buf.implementation, opts)
  keymap("n", "gr", vim.lsp.buf.references, opts)
  keymap("n", "gl", vim.diagnostic.open_float, opts)
  keymap("n", "<leader>li", "<cmd>LspInfo<cr>", opts)
  keymap("n", "<leader>lI", "<cmd>Mason<cr>", opts)
  keymap("n", "<leader>la", vim.lsp.buf.code_action, opts)
  keymap("n", "<leader>lj", function()
    vim.diagnostic.goto_next { buffer = 0 }
  end, opts)
  keymap("n", "<leader>lk", function()
    vim.diagnostic.goto_prev { buffer = 0 }
  end, opts)
  keymap("n", "<leader>lr", vim.lsp.buf.rename, opts)
  keymap("n", "<leader>ls", vim.lsp.buf.signature_help, opts)
  keymap("n", "<leader>lq", vim.diagnostic.setloclist, opts)
end

return M
