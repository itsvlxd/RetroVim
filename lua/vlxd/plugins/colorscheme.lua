return {
	"olimorris/onedarkpro.nvim",
	priority = 1000,
	config = function()
		local onedark = require("onedarkpro")
		local retro = require("vlxd.lib.retro")
		local retro_settings = retro.get_settings()

		local colors = retro.get_theme_colors()
		local syntax = retro.get_theme_syntax()

		local opts = {
			colors = colors,
			highlights = {
				RetroStartupNvim = { fg = "${green}" },

				Directory = { fg = "${blue}", bold = true },

				IblIndent = { fg = "${gray}" },
				IblScope = { fg = "${blue}" },

				SignColumn = { bg = "NONE" },
				CursorLine = { bg = "${cursor_line}" },
				CursorLineNr = { fg = "${yellow}" },

				NeoTreeCursorLine = { bold = true },
				NeoTreeGitAdded = { fg = "${green}" },
				NeoTreeGitModified = { fg = "${orange}" },
				NeoTreeDirectoryName = { fg = "${white}" },
				NeoTreeDirectoryIcon = { fg = "${yellow}" },

				NeoTreeSymbolicLinkTarget = { fg = "${cyan}" },
				NeoTreeGitConflict = { fg = "${red}", bold = true },
				NeoTreeRootName = { fg = "${purple}", bold = true },
				NeoTreeGitUntracked = { fg = "${cyan}", italic = true },

				NeoTreeFloatingWinBorder = { fg = "${blue}", bg = "NONE" },
				NeoTreeFloatTitle = { fg = "${blue}", bg = "NONE", bold = true },

				SnacksIndent = { fg = "${gray}" },
				SnacksPickerDir = { fg = "${gray}" },
				SnacksPickerInput = { fg = "${white}" },
				SnacksPickerBorder = { fg = "${gray}" },
				SnacksPickerIconDirectory = { fg = "${yellow}" },
				SnacksPickerTitle = { fg = "${blue}", style = "bold" },
				SnacksPickerTotals = { fg = "${blue}", style = "bold" },

				SnacksDashboardHeader = { fg = "${purple}" },
				SnacksDashboardStartup = { fg = "${yellow}" },

				CmpDocumentation = { bg = "${gray}" },
				CmpDocumentationBorder = { bg = "${gray}" },

				BlinkCmpKindFunction = { fg = "${purple}" },
				BlinkCmpKindMethod = { fg = "${blue}" },
				BlinkCmpKindModule = { fg = "${yellow}" },
				BlinkCmpKindVariable = { fg = "${green}" },
				BlinkCmpKindKeyword = { fg = "${purple}" },
				BlinkCmpKindClass = { fg = "${yellow}" },
				BlinkCmpKindInterface = { fg = "${yellow}" },
				BlinkCmpKindStruct = { fg = "${yellow}" },
				BlinkCmpKindEnum = { fg = "${purple}" },
				BlinkCmpKindProperty = { fg = "${cyan}" },
				BlinkCmpKindField = { fg = "${cyan}" },
				BlinkCmpKindTypeParameter = { fg = "${cyan}" },
				BlinkCmpKindConstant = { fg = "${orange}" },
				BlinkCmpKindSnippet = { fg = "${red}" },
				BlinkCmpKindText = { fg = "${yellow}" },
				BlinkCmpKindFile = { fg = "${cyan}" },
				BlinkCmpKindFolder = { fg = "${yellow}" },

				BlinkCmpLabel = { fg = "${white}" },
				BlinkCmpLabelMatch = { fg = "${blue}", bold = true },
				BlinkCmpLabelDetail = { fg = "${gray}" },
				BlinkCmpLabelDescription = { fg = "${gray}" },
				BlinkCmpDocBorder = { fg = "${gray}", bg = "NONE" },
				BlinkCmpMenuBorder = { fg = "${gray}", bg = "NONE" },

				GitSignsAdd = { fg = "${green}", bg = "NONE" },
				GitSignsChange = { fg = "${orange}", bg = "NONE" },
				GitSignsDelete = { fg = "${red}", bg = "NONE" },

				GitSignsAddLn = { fg = "${green}" },
				GitSignsChangeLn = { fg = "${orange}" },

				ScrollbarGitAdd = { fg = "${green}" },
				ScrollbarGitChange = { fg = "${orange}" },
				ScrollbarGitDelete = { fg = "${red}" },

				FloatTitle = { fg = "${blue}", bg = "NONE", bold = true },
				FloatBorder = { fg = "${gray}", bg = "NONE" },
				NormalFloat = { bg = "NONE" },

				NuiInputNormal = { bg = "NONE", fg = "${fg}" },
				NuiInputBorder = { fg = "${blue}", bg = "NONE" },
			},
			styles = {
				types = "italic,bold",
				methods = "bold",
				numbers = "NONE",
				strings = "italic",
				comments = "bold,italic",
				keywords = "bold",
				constants = "bold",
				functions = "bold",
				operators = "NONE",
				variables = "NONE",
				parameters = "italic",
				conditionals = "bold",
				virtual_text = "NONE",
			},
			filetypes = {
				c = true,
				comment = true,
				go = true,
				html = true,
				java = true,
				javascript = true,
				json = true,
				lua = true,
				markdown = true,
				php = true,
				python = true,
				ruby = true,
				rust = true,
				scss = true,
				toml = true,
				typescript = true,
				typescriptreact = true,
				vue = true,
				xml = true,
				yaml = true,
			},
			plugins = {
				all = false,
				gitsigns = true,
				neo_tree = true,
				nvim_lsp = true,
				snacks = true,
				treesitter = true,
				trouble = true,
				which_key = true,
			},
			options = {
				cursorline = true,
				transparency = retro_settings.transparent,
				terminal_colors = false,
				lualine_transparency = true,
				highlight_inactive_windows = false,
			},
		}

		if retro_settings.transparent then
			opts.highlights.CursorLine = { bg = "none" }
			opts.highlights.BufferLineSeparator = { fg = "${bg}" }
		end

		if syntax ~= nil then
			for group, opt in pairs(syntax) do
				opts.highlights[group] = opt
			end
		end

		onedark.setup(opts)
		vim.cmd("colorscheme onedark")
	end,
}
