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

## Bazel projects

Projects own their build metadata and formatter commands. This configuration uses
`rust-project.json` for Rust navigation and disables Cargo-based save checks when
that file is present. Run the project's documented metadata refresh after build
changes. Starpls supplies Starlark navigation; basedpyright uses generated Python
import roots. Assembly strings and linker symbols still require source search.

Optional `.tools/project.json` metadata uses version 1 with `python_search_paths`
and a `format_command` argv array. Save formatting appends the absolute source
path and passes the buffer on stdin, with the project root as the working
directory. The command must return only formatted source on stdout; failure
aborts the save. Projects without this metadata retain their LSP formatters.
Only open trusted projects: their declared formatter commands execute on save.
Language servers and Neovim stay workstation dependencies managed here, while
formatters used by project CI remain project dependencies.

For the Direct Line integration check, first refresh its metadata, then run:

```sh
DIRECT_LINE_ROOT=/path/to/direct_line nvim --headless -c 'luafile ~/.config/nvim/tests/bazel.lua'
```

The test uses this real configuration, requests definitions through language
servers, and checks save formatting. It creates and removes ignored scratch
files under the project's `.tools` directory. It does not download an editor or
change project source files.
