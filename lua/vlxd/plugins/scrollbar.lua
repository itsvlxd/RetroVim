return {
	"petertriho/nvim-scrollbar",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local retro = require("vlxd.lib.retro")
		local colors = retro.get_theme_colors()

		require("scrollbar").setup({
			show = true,
			show_in_active_only = true,
			set_highlights = true,
			hide_if_all_visible = true,
			handle = {
				text = " ",
				blend = 25,
				color = colors.dark_gray,
				highlight = "CursorColumn",
			},
			marks = {
				Error = { text = { " ", " " }, priority = 2, color = colors.red },
				Warn = { text = { " ", " " }, priority = 3, color = colors.yellow },
				GitAdd = { text = "┆", priority = 7, highlight = "GitSignsAdd" },
				GitChange = { text = "┆", priority = 7, highlight = "GitSignsChange" },
				GitDelete = { text = " ", priority = 7, highlight = "GitSignsDelete" },
			},
			excluded_filetypes = {
				"snacks_dashboard",
				"snacks_picker",
				"snacks_terminal",
				"neo-tree",
				"noice",
			},
			handlers = {
				cursor = false,
				diagnostic = true,
				gitsigns = true,
				handle = true,
				search = false,
			},
		})
	end,
}
