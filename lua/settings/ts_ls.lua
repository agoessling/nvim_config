local M = {}

M.root_dir = function(bufnr, on_dir)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local root = vim.fs.root(name, { "tsconfig.json", "MODULE.bazel", ".git" })

  if root then
    on_dir(root)
  end
end

return M
