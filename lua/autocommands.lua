vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]]
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Automatically close tab/vim when nvim-tree is the last window in the tab
vim.cmd "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif"

vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

local python_format_on_save = vim.api.nvim_create_augroup("PythonFormatOnSave", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = python_format_on_save,
  pattern = "*.py",
  callback = function(args)
    vim.lsp.buf.format({
      bufnr = args.buf,
      timeout_ms = 3000,
      filter = function(client)
        return client.name == "ruff"
      end,
    })
  end,
})

local cpp_format_on_save = vim.api.nvim_create_augroup("CppFormatOnSave", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = cpp_format_on_save,
  pattern = {
    "*.c",
    "*.cc",
    "*.cpp",
    "*.cxx",
    "*.h",
    "*.hh",
    "*.hpp",
    "*.hxx",
    "*.inc",
  },
  callback = function(args)
    vim.lsp.buf.format({
      bufnr = args.buf,
      timeout_ms = 3000,
      filter = function(client)
        return client.name == "clangd"
      end,
    })
  end,
})

local rust_format_on_save = vim.api.nvim_create_augroup("RustFormatOnSave", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = rust_format_on_save,
  pattern = "*.rs",
  callback = function(args)
    vim.lsp.buf.format({
      bufnr = args.buf,
      timeout_ms = 3000,
      filter = function(client)
        return client.name == "rust_analyzer"
      end,
    })
  end,
})
