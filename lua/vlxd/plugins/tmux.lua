return {
	"christoomey/vim-tmux-navigator",
	keys = {
		{ "<c-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Window Left" },
		{ "<c-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Window Down" },
		{ "<c-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Window Up" },
		{ "<c-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Window Right" },
		{ "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Window Previous" },
	},
	init = function()
		vim.g.tmux_navigator_no_mappings = 1
		vim.g.tmux_navigator_save_on_switch = 1
	end,
}
