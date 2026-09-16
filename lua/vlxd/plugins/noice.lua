return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	opts = {
		cmdline = {
			view = "cmdline_popup",
			format = {
				cmdline = { icon = "  ", lang = "vim" },
				search_down = { icon = "  ", lang = "regex" },
				filter = { icon = "  ", lang = "bash" },
				lua = { icon = "  ", lang = "lua" },
			},
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					any = { { find = "%d+L, %d+B" }, { find = "written" } },
				},
				opts = { skip = true },
			},
			{
				filter = { min_height = 20 },
				view = "split",
				opts = { enter = true },
			},
		},
		lsp = {
			progress = { enabled = false },
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},
		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
			lsp_doc_border = true,
		},
	},
}
