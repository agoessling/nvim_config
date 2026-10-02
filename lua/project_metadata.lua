-- Build-derived metadata belongs to projects; editor behavior belongs here.
local M = {}

function M.root(path)
	return vim.fs.root(path, { "MODULE.bazel", "WORKSPACE.bazel", "WORKSPACE" })
end

function M.read(root)
	if not root then
		return nil
	end
	local path = root .. "/.tools/project.json"
	if vim.fn.filereadable(path) ~= 1 then
		return nil
	end
	local metadata = vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
	assert(metadata.version == 1, "Unsupported project metadata version: " .. path)
	return metadata
end

-- Return false so ordinary projects retain their existing LSP formatter.
function M.format(buffer)
	if not vim.tbl_contains({ "rust", "python", "bzl", "starlark", "c", "cpp" }, vim.bo[buffer].filetype) then
		return false
	end
	local path = vim.api.nvim_buf_get_name(buffer)
	local root = M.root(path)
	local metadata = M.read(root)
	if not metadata or not metadata.format_command then
		return false
	end
	local command = vim.deepcopy(metadata.format_command)
	table.insert(command, path)
	local input = table.concat(vim.api.nvim_buf_get_lines(buffer, 0, -1, false), "\n") .. "\n"
	local result = vim.system(command, { cwd = root, stdin = input, text = true }):wait(30000)
	if result.code ~= 0 then
		error("Project formatting failed; buffer was not saved:\n" .. (result.stderr or ""))
	end
	if result.stdout ~= input then
		local output = vim.split(result.stdout, "\n", { plain = true })
		if output[#output] == "" then
			table.remove(output)
		end
		local view = vim.fn.winsaveview()
		vim.api.nvim_buf_set_lines(buffer, 0, -1, false, output)
		vim.fn.winrestview(view)
	end
	return true
end

return M
