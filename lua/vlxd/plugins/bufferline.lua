local retro = require("vlxd.lib.retro")
local retro_settings = retro.get_settings()

return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "itsvlxd/material-icons.nvim" },
	opts = {
		options = {
			mode = "buffers",
			themable = true,
			separator_style = retro_settings.bufferline_sep,
			show_tab_indicators = false,
			show_buffer_close_icons = true,
			sort_by = "insert_after_current",
			show_close_icon = false,
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				if type(diagnostics_dict) ~= "table" then
					return "(" .. count .. ")"
				end

				local s = " "
				for e, n in pairs(diagnostics_dict) do
					local sym = e == "error" and " " or (e == "warning" and " " or " ")
					s = s .. n .. sym
				end
				return s
			end,
			offsets = {
				{
					filetype = "neo-tree",
					text = retro.retrovim,
					text_align = "center",
					separator = true,
					highlight = "Directory",
				},
			},
			buffer_close_icon = "",
			modified_icon = "● ",
			close_icon = " ",
			left_trunc_marker = " ",
			right_trunc_marker = " ",
			color_icons = true,
			hover = {
				enabled = true,
				delay = 0,
				reveal = { "close" },
			},
			indicator = {
				icon = "▎",
				style = (retro_settings.bufferline_sep == "thick" or retro_settings.bufferline_sep == "thin")
						and "icon"
					or "underline",
			},
			numbers = "ordinal",
		},
		highlights = {
			buffer_selected = {
				fg = { attribute = "fg", highlight = "Normal" },
				bold = true,
				italic = true,
			},
		},
	},
}
