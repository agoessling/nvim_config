local M = {
  cmd = {
    "clangd",
    "--query-driver=**/aarch64-linux-gnu*",
    "--query-driver=**/arm-none-eabi*"
  }
}

return M
