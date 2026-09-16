return {
	"MagicDuck/grug-far.nvim",
	opts = {
		headerMaxWidth = 30,
		keymaps = {
			close = { n = "q" },
		},
	},
	keys = {
		{
			"<leader>sp",
			function()
				require("grug-far").open()
			end,
			desc = "Open Grug-far",
		},
	},
}
