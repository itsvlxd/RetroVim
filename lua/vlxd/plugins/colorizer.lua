return {
	"catgoose/nvim-colorizer.lua",
	event = "BufReadPre",
	opts = {
		filetypes = { "*" },
		user_default_options = {
			RGB = true,
			RGBA = true,
			RRGGBB = true,
			names = false,
			rgb_fn = true,
			hsl_fn = true,
			css = true,
			css_fn = true,
			tailwind = true,
			sass = { enable = true, parsers = { "css" } },
			mode = "background",
			virtualtext = "■",
			virtualtext_inline = true,
			always_update = true,
		},
		buftypes = {
			"*",
			"!prompt",
			"!popup",
		},
	},
}
