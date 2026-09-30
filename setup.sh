#!/usr/bin/env bash
# Run after installing Neovim, Node/npm, Python/venv, unzip, and tree-sitter.
set -euo pipefail
config_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
expected_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
if [[ "$(realpath "$expected_dir")" != "$config_dir" ]]; then
  echo "Install this checkout at $expected_dir before running setup.sh." >&2
  exit 1
fi
export DEFAULTS_NVIM_SETUP=1
# Lua reports failed plugin/package restoration with a nonzero exit status.
exec nvim --headless -c 'lua dofile(vim.fn.stdpath("config") .. "/setup.lua")'
