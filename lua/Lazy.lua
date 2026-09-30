local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    error("Failed to clone lazy.nvim")
  end
  local lock = vim.json.decode(table.concat(vim.fn.readfile(vim.fn.stdpath("config") .. "/lazy-lock.json"), "\n"))
  vim.fn.system { "git", "-C", lazypath, "checkout", "--detach", lock["lazy.nvim"].commit }
  if vim.v.shell_error ~= 0 then
    error("Failed to restore lazy.nvim from lazy-lock.json")
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- make sure to set `mapleader` before lazy so mappings are correct

-- load lazy
require("lazy").setup("user", {
  install = { colorscheme = { require("user.colorscheme").name } },
  defaults = { lazy = true },
  ui = { wrap = true },
  change_detection = { enabled = true },
})
