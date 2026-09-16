local M = {}

local config_path = vim.fn.stdpath("config")

function M.run(args)
	local obj = vim.system(args, { text = true, cwd = config_path }):wait()

	if obj.code == 0 then
		return vim.trim(obj.stdout or "")
	end

	return nil
end

function M.run_async(args, callback)
	vim.system(args, { text = true, cwd = config_path }, function(obj)
		if not callback then
			return
		end

		local result = nil
		if obj.code == 0 then
			result = vim.trim(obj.stdout or "")
		end

		vim.schedule(function()
			callback(result)
		end)
	end)
end

function M.get_branch()
	return M.run({ "git", "rev-parse", "--abbrev-ref", "HEAD" }) or "N/A"
end

function M.get_commit()
	return M.run({ "git", "rev-parse", "--short", "HEAD" }) or "N/A"
end

function M.get_version()
	return M.run({ "git", "describe", "--tags", "--abbrev=0" })
		or M.run({ "git", "rev-parse", "--short", "HEAD" })
		or "Latest"
end

return M
