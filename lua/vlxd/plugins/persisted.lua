return {
	"olimorris/persisted.nvim",
	lazy = false,
	opts = {
		use_git_branch = true,
		options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" },
		should_save = function()
			local ft = vim.bo.filetype
			if
				ft == "snacks_picker_list"
				or ft == "snacks_picker_input"
				or ft == "snacks_explorer"
				or ft == "NvimTree"
			then
				return false
			end
			return true
		end,
		on_autoload_no_session = function()
			vim.notify("No session found for this directory", vim.log.levels.INFO)
		end,
	},
}
