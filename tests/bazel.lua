-- Run against an already-refreshed trusted project with the normal user config.
local root = vim.env.DIRECT_LINE_ROOT
local function definition(path, needle, symbol, expected, server)
	vim.cmd.edit(vim.fn.fnameescape(root .. "/" .. path))
	local buffer = vim.api.nvim_get_current_buf()
	local line, column
	for index, text in ipairs(vim.api.nvim_buf_get_lines(buffer, 0, -1, false)) do
		if text:find(needle, 1, true) then
			line = index - 1
			column = assert(text:find(symbol, 1, true)) - 1
			break
		end
	end
	assert(line, "Missing smoke-test reference: " .. path .. " / " .. needle)
	local found = false
	local next_request = 0
	local last = "no initialized client"
	assert(
		vim.wait(45000, function()
			if vim.uv.now() < next_request then
				return false
			end
			next_request = vim.uv.now() + 1000
			for _, client in ipairs(vim.lsp.get_clients({ bufnr = buffer, name = server })) do
				if client.initialized then
					local result, err = client:request_sync("textDocument/definition", {
						textDocument = { uri = vim.uri_from_bufnr(buffer) },
						position = { line = line, character = column },
					}, 3000, buffer)
					last = vim.inspect(result or err)
					if result and result.result then
						local locations = result.result.uri and { result.result } or result.result
						for _, location in ipairs(locations) do
							local uri = location.uri or location.targetUri
							if uri and uri:find(expected, 1, true) then
								print("PASS definition " .. path .. " -> " .. uri)
								found = true
								return true
							end
						end
					end
				end
			end
			return false
		end, 500),
		"Definition failed: " .. path .. " / " .. symbol .. " / " .. last
	)
	assert(found)
end

local function formatting(extension, source, expected)
	local path = root .. "/.tools/format-smoke." .. extension
	vim.cmd.enew()
	vim.cmd.file(vim.fn.fnameescape(path))
	vim.cmd("filetype detect")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { source })
	vim.cmd.write()
	local actual = table.concat(vim.fn.readfile(path), "\n")
	assert(actual:find(expected, 1, true), "Save formatting failed: " .. extension .. " / " .. actual)
	vim.cmd.bdelete()
	vim.fn.delete(path)
	print("PASS format-on-save " .. extension)
end

local ok, err = pcall(function()
	definition(
		"foundation/lib.rs",
		"assert!(deadline_reached(2",
		"deadline_reached",
		"foundation/lib.rs",
		"rust_analyzer"
	)
	definition("foundation/lib.rs", "now.wrapping_sub", "wrapping_sub", "/library/core/src/", "rust_analyzer")
	definition(
		"firmware/gpio.rs",
		"let mut red = r::ioc::iocfg6::Value::from_bits(0)",
		"iocfg6",
		"generated_registers.rs",
		"rust_analyzer"
	)
	definition("tools/quality/quality.py", "result = run(", "run", "quality.py", "basedpyright")
	definition(
		"tools/metadata/refresh.py",
		"python_search_paths",
		"runfiles",
		"/python/runfiles/runfiles.py",
		"basedpyright"
	)
	definition("foundation/BUILD", "rust_library(", "rust_library", "/rust/", "starpls")
	definition("tools/debug/dslite_exit_compat.c", "fflush(NULL)", "fflush", "stdio.h", "clangd")
	formatting("rs", "fn main(){let _x=1;}", "let _x = 1;")
	formatting("py", "value=1", "value = 1")
	formatting("bzl", "value=1", "value = 1")
	formatting("c", "int main(){return 0;}", "return 0;")
end)
for _, client in ipairs(vim.lsp.get_clients()) do
	client:stop()
end
vim.wait(3000, function()
	return #vim.lsp.get_clients() == 0
end, 100)
if not ok then
	io.stderr:write(tostring(err) .. "\n")
	vim.cmd("cquit 1")
end
print("PASS user Neovim navigation and project save formatting")
vim.cmd.qa({ bang = true })
