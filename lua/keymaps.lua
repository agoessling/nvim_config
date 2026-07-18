-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

local function map(mode, lhs, rhs, desc)
	keymap(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
end

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>", "Decrease window height")
map("n", "<C-Down>", ":resize +2<CR>", "Increase window height")
map("n", "<C-Left>", ":vertical resize -2<CR>", "Decrease window width")
map("n", "<C-Right>", ":vertical resize +2<CR>", "Increase window width")

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>", "Next buffer")
map("n", "<S-h>", ":bprevious<CR>", "Previous buffer")

-- Clear highlights
map("n", "<leader>h", "<cmd>nohlsearch<CR>", "Clear search highlight")

-- Close buffers
map("n", "<S-q>", "<cmd>Bdelete!<CR>", "Close buffer")

-- Better paste
map("v", "p", "P", "Paste without replacing register")

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv", "Indent left")
map("v", ">", ">gv", "Indent right")

-- Plugins --

-- NvimTree
map("n", "<leader>e", ":NvimTreeToggle<CR>", "Toggle file tree")

-- Telescope
map("n", "<C-p>", function()
	require("user.telescope").project_files()
end, "Find project files")
map("n", "<leader>ff", ":Telescope find_files<CR>", "Find files")
map("n", "<leader>ft", ":Telescope live_grep<CR>", "Search text")
map("n", "<leader>fb", ":Telescope buffers<CR>", "Find buffers")
map("v", "<leader>fs", "y<ESC>:Telescope live_grep default_text=<c-r>0<CR>", "Search selection")

-- Comment
map("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", "Toggle line comment")
map("x", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", "Toggle selection comment")

-- Lsp
map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", "Format buffer")

-- dev_util
map("n", "<leader>dc", ':TermExec cmd="python3 -B ~/dev_util/gen_compile_commands.py && exit" <CR>', "Generate compile commands")
