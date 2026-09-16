local M = {}

local retro = require("vlxd.lib.retro")

--- Delete function using Snacks.input and vim.notify
--- @param state table The Neo-tree state object
M.smart_delete = function(state)
	local node = state.tree:get_node()
	if node.type == "message" then
		return
	end

	require("snacks").input({
		prompt = ' Delete "' .. node.name .. '"? [y/N] ',
	}, function(input)
		if input and input:lower() == "y" then
			local success = vim.fn.delete(node.path, "rf")

			if success == 0 then
				retro.notify('File "' .. node.name .. '" has been delete successfully.')
			else
				retro.notify("Could not delete " .. node.name, "error")
			end
		end
	end)
end

return M
