return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		preset = "modern",
		spec = {
			{ "<leader>f", group = "  Find" },
			{ "<leader>s", group = " 󰛔 Search & Replace" },
			{ "<leader>d", group = " 󱌢 Diagnostics" },
			{ "<leader>t", group = " 󱖫 Trouble" },
			{ "<leader>b", group = " 󰓩 Buffers" },
			{ "<leader>g", group = " 󰊢 Git" },
			{ "<leader>p", group = " 󱗼 PlatformIO" },
			{ "g", group = "  LSP" },
		},
		icons = {
			breadcrumb = "»",
			separator = "",
			group = "+",
		},
		win = {
			border = "rounded",
			padding = { 1, 1 },
			title = true,
			title_pos = "center",
		},
		layout = {
			width = { max = 20 },
			spacing = 3,
			align = "center",
		},
	},
}
