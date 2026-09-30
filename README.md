# Neovim configuration

Clone this repository to `~/.config/nvim`, then run `./setup.sh` there after
installing Neovim 0.12+, tree-sitter 0.26.1+, a C compiler, Git, Node/npm,
Python with venv support, curl, and unzip (provided by `defaults/setup_linux.sh`).

Setup restores plugin revisions from `lazy-lock.json` and installs the language
servers and formatters recorded in `mason-packages.txt`; installation failures
stop setup. Tree-sitter parsers are installed on startup by the pinned plugin.
The lockfile also pins lazy.nvim on a fresh bootstrap.

TypeScript and TSX use ts_ls for language support and Biome for formatting on
save; Prettier excludes those filetypes. Other configured formatters include
Prettier and StyLua, which are also explicitly installed through mason-null-ls.

To intentionally upgrade, update the plugin lockfile and Mason version list
and commit them together after testing the editor.
