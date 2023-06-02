local M = {
  "sainnhe/gruvbox-material",
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
}

M.name = "gruvbox-material"

function M.config()
  vim.g.gruvbox_material_foreground = 'material'
  vim.g.gruvbox_material_background = 'soft'
  vim.g.gruvbox_material_enable_italic = 1
  vim.g.gruvbox_material_better_performance = 1

  local status_ok, _ = pcall(vim.cmd.colorscheme, M.name)
  if not status_ok then
    return
  end
end

return M
