local retro = require("vlxd.lib.retro")

return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local settings = retro.get_settings()
		local hl_colors = retro.get_hlchunk_colors()
		local is_hlchunk = settings.indent_mode == "hlchunk"

		require("hlchunk").setup({
			chunk = {
				enable = is_hlchunk,
				priority = 15,
				style = hl_colors.chunk,
				use_treesitter = true,
				chars = {
					horizontal_line = "─",
					vertical_line = "│",
					left_top = "╭",
					left_bottom = "╰",
					right_arrow = ">",
				},
				textobject = "",
				max_file_size = 1024 * 1024,
				error_sign = true,
				straight = false,
				duration = 200,
				delay = 300,
			},
			indent = {
				enable = settings.indent_mode == "hlchunk",
				style = hl_colors.indent,
			},
			line_num = {
				enable = false,
			},
			blank = {
				enable = false,
			},
		})
	end,
}
