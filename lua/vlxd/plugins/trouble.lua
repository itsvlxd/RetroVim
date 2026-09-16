return {
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		dependencies = { "itsvlxd/material-icons.nvim", "folke/todo-comments.nvim" },
		opts = {
			auto_close = true,
			restore = true,
			focus = true,
			modes = {
				diagnostics = {
					groups = {
						{ "filename", format = "{fileicon} {filename} {count}" },
					},
				},
			},
		},
		keys = {
			{ "<leader>tx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>tX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
			{
				"<leader>tl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions/References (Trouble)",
			},
			{ "<leader>tL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
			{ "<leader>tQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
		},
	},

	{
		"folke/snacks.nvim",
		opts = {
			picker = {
				win = {
					input = {
						keys = {
							["<c-t>"] = { "trouble_open", mode = { "n", "i" } },
						},
					},
				},
			},
		},
	},
}
