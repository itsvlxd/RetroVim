return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "itsvlxd/material-icons.nvim" },
	config = function()
		local retro = require("vlxd.lib.retro")

		local colors = retro.get_theme_colors()
		local retro_settings = retro.get_settings()

		local bg_color = retro_settings.lualine_trans and "NONE" or colors.bg

		local retrovim = {
			normal = {
				a = { fg = colors.black, bg = colors.blue, gui = "bold" },
				b = { fg = colors.fg, bg = colors.gray },
				c = { fg = colors.fg, bg = bg_color },
			},
			insert = { a = { fg = colors.black, bg = colors.green, gui = "bold" } },
			visual = { a = { fg = colors.black, bg = colors.purple, gui = "bold" } },
			replace = { a = { fg = colors.black, bg = colors.red, gui = "bold" } },
			command = { a = { fg = colors.black, bg = colors.orange, gui = "bold" } },
			inactive = {
				a = { fg = colors.fg, bg = colors.bg },
				b = { fg = colors.fg, bg = colors.bg },
				c = { fg = colors.fg, bg = colors.bg },
			},
			component = {
				separators = { fg = colors.dark_gray },
			},
		}

		local pipe = {
			function()
				return "|"
			end,
			color = { fg = colors.gray },
			padding = { left = 0, right = 0 },
		}

		local lsp_progress = {
			"lsp_progress",
			colors = {
				percentage = colors.green,
				title = colors.fg,
				message = colors.yellow,
				spinner = colors.fg,
				lsp_client_name = colors.blue,
				use = true,
			},
			separators = {
				component = " ",
				progress = " | ",
				percentage = { pre = "", post = "%% " },
				title = { pre = "", post = ": " },
				lsp_client_name = { pre = " [" },
				spinner = { pre = "", post = "" },
				message = { pre = "(", post = ")", commenced = "In Progress", completed = "Completed" },
			},
			display_components = { "lsp_client_name", { "title", "percentage", "message" } },
			timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
		}

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = retrovim,
				section_separators = "",
				component_separators = "",
				disabled_filetypes = {
					statusline = {
						"snacks_dashboard",
						"alpha",
						"dashboard",
						"lazy",
						"mason",
						"neo-tree",
						"NvimTree",
					},
					winbar = {
						"snacks_dashboard",
					},
				},
				ignore_focus = {},
				always_divide_middle = true,
				always_show_tabline = true,
				globalstatus = true,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
					refresh_time = 16,
					events = {
						"WinEnter",
						"BufEnter",
						"BufWritePost",
						"SessionLoadPost",
						"FileChangedShellPost",
						"VimResized",
						"Filetype",
						"CursorMoved",
						"CursorMovedI",
						"ModeChanged",
					},
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{ "branch", icon = "󰘬", color = { gui = "bold" } },
					"diff",
					{ "diagnostics", symbols = { error = " ", warn = " ", info = " " } },
				},
				lualine_c = {
					{ "filename", file_status = true },
					lsp_progress,
				},
				lualine_x = { "encoding", pipe, "fileformat", pipe, "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = { "neo-tree", "lazy" },
		})
	end,
}
