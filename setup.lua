-- Invoked by setup.sh, separately from ordinary editor startup.
local ok, err = pcall(function()
  local config = vim.fn.stdpath("config")
  local data = vim.fn.stdpath("data")
  local lock = vim.json.decode(table.concat(vim.fn.readfile(config .. "/lazy-lock.json"), "\n"))
  vim.cmd("Lazy! restore")
  for name, revision in pairs(lock) do
    local result = vim.system({ "git", "-C", data .. "/lazy/" .. name, "rev-parse", "HEAD" }, { text = true }):wait()
    assert(result.code == 0 and vim.trim(result.stdout) == revision.commit, "Plugin restore failed: " .. name)
  end

  require("lazy").load({ plugins = { "mason.nvim" } })
  local packages = vim.fn.readfile(config .. "/mason-packages.txt")
  vim.cmd("MasonInstall " .. table.concat(packages, " "))
  for _, package in ipairs(packages) do
    local name, version = package:match("^([^@]+)@(.+)$")
    assert(name and version, "Invalid Mason package: " .. package)
    local receipt = vim.json.decode(table.concat(vim.fn.readfile(data .. "/mason/packages/" .. name .. "/mason-receipt.json"), "\n"))
    assert(receipt.source.id:match("@([^@]+)$") == version, "Package restore failed: " .. package)
  end
end)

if not ok then
  vim.api.nvim_err_writeln(tostring(err))
  vim.cmd("cquit 1")
else
  vim.cmd("qa")
end
