local M = {
  "nvim-telescope/telescope.nvim",
  event = "Bufenter",
  cmd = { "Telescope" },
}

M.project_files = function()
  local cwd = vim.fn.expand('%:p:h')
  vim.fn.system('git -C ' .. cwd .. ' rev-parse --is-inside-work-tree')
  if vim.v.shell_error == 0 then
    require('telescope.builtin').git_files {
      cwd = cwd,
      show_untracked = true,
    }
  else
    require('telescope.builtin').find_files({ hidden = true })
  end
end

M.config = function()
  local actions = require('telescope.actions')
  require('telescope').setup {
    defaults = {
      mappings = {
        i = {
          ['<C-j>'] = actions.move_selection_next,
          ['<C-k>'] = actions.move_selection_previous,
        }
      }
    }
  }
end

return M
