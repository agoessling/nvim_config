local M = {
  "nvim-lualine/lualine.nvim",
  event = { "VimEnter", "InsertEnter", "BufReadPre", "BufAdd", "BufNew", "BufReadPost" },
}

function M.config()
  local status_ok, lualine = pcall(require, "lualine")
  if not status_ok then
    return
  end
  lualine.setup {
    options = {
      theme = 'gruvbox-material'
    },
    sections = {
      lualine_c = {
        {
          'filename',
          file_status = true,
          path = 1,
        },
      },
    },
    inactive_sections = {
      lualine_c = {
        {
          'filename',
          path = 1,
        },
      },
    },
  }
end

return M
