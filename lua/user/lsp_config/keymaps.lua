local M = {}

function M.set(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local keymap = vim.keymap.set

  local function map(mode, lhs, rhs, desc)
    keymap(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
  end

  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "K", vim.lsp.buf.hover, "Show hover documentation")
  map("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
  map("n", "gr", vim.lsp.buf.references, "Find references")
  map("n", "gl", vim.diagnostic.open_float, "Show line diagnostics")
  map("n", "<leader>li", "<cmd>LspInfo<cr>", "Show LSP info")
  map("n", "<leader>lI", "<cmd>Mason<cr>", "Open Mason")
  map("n", "<leader>la", vim.lsp.buf.code_action, "Code action")
  map("n", "<leader>lj", function()
    vim.diagnostic.goto_next { buffer = 0 }
  end, "Next diagnostic")
  map("n", "<leader>lk", function()
    vim.diagnostic.goto_prev { buffer = 0 }
  end, "Previous diagnostic")
  map("n", "<leader>lr", vim.lsp.buf.rename, "Rename symbol")
  map("n", "<leader>ls", vim.lsp.buf.signature_help, "Show signature help")
  map("n", "<leader>lq", vim.diagnostic.setloclist, "Diagnostics to location list")
end

return M
