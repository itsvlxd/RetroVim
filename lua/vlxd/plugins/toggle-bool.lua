return {
	"gerazov/toggle-bool.nvim",

	config = function()
		local toggle_bool = require("toggle-bool")
		local keymap = vim.keymap

		toggle_bool.setup({})

		keymap.set("n", "<leader>tb", function()
			toggle_bool.toggle_bool()
		end, { desc = "Toggles the boolean under the cursor" })
	end,
}
