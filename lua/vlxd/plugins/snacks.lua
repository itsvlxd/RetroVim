local retro = require("vlxd.lib.retro")

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		root = {
			enabled = true,
			patterns = { ".git", "lua", "package.json", "mvnw", "gradlew" },
		},
		dashboard = {
			enabled = true,
			preset = {
				header = retro.header({ show_stats = true }),
				pick = nil,
				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "g",
						desc = "Find Text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles', {filter = {cwd = true}})",
					},
					{ icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.dashboard.pick('projects')" },
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{ icon = "󰑓 ", key = "s", desc = "Restore Session", section = "session" },
					{
						icon = "󰒲 ",
						key = "L",
						desc = "Lazy",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
					},
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				retro.startup(),
				retro.update_status(),
			},
		},
		git = { enabled = true },
		picker = {
			enabled = true,
			ui_select = true,
			show_delay = 0,
			matcher = {
				fuzzy = true,
				smartcase = true,
				cwd_bonus = true,
				frecency = true,
				history_bonus = true,
			},
			jump = {
				jumplist = true,
				reuse_win = true,
				close = true,
			},
			formatters = {
				file = { filename_first = true, truncate = "center" },
			},
			win = {
				input = {
					keys = {
						["<C-k>"] = { "history_prev", mode = { "i", "n" } },
						["<C-j>"] = { "history_next", mode = { "i", "n" } },
						["<C-t>"] = { "trouble_open", mode = { "i", "n" } },
						["<C-q>"] = { "qflist_open", mode = { "i", "n" } },
					},
				},
			},
			layout = {
				layout = {
					-- TODO: Add backdrop setting in the menu
					backdrop = 60,
					wo = { conceallevel = 2, winblend = 0 },
				},
			},
			sources = {
				explorer = {
					finder = "explorer",
					sort = { fields = { "sort" } },
					supports_live = true,
					tree = true,
					watch = true,
					diagnostics = true,
					diagnostics_open = false,
					git_status = true,
					git_status_open = true,
					git_untracked = true,
					follow_file = true,
					focus = "main",
					auto_close = false,
					jump = { close = false },
					layout = {
						preset = "main",
						preview = false,
						layout = {
							box = "vertical",
							width = 30,
							min_width = 30,
							height = 0,
							position = "left",
							border = "none",
							{
								win = "input",
								height = 1,
								border = "rounded",
								title = "{title} {live} {flags}",
								title_pos = "center",
							},
							{ win = "list", border = "none" },
							{
								win = "preview",
								title = "{preview}",
								height = 0.4,
								border = "top",
							},
						},
					},
					formatters = {
						file = { filename_only = true },
						severity = { pos = "right" },
					},
					matcher = { sort_empty = false, fuzzy = false },
					config = function(opts)
						return require("snacks.picker.source.explorer").setup(opts)
					end,
					win = {
						list = {
							keys = {
								["<BS>"] = "explorer_up",
								["l"] = "confirm",
								["h"] = "explorer_close",
								["a"] = "explorer_add",
								["d"] = "explorer_del",
								["r"] = "explorer_rename",
								["c"] = "explorer_copy",
								["m"] = "explorer_move",
								["o"] = "explorer_open",
								["P"] = "toggle_preview",
								["y"] = { "explorer_yank", mode = { "n", "x" } },
								["p"] = "explorer_paste",
								["u"] = "explorer_update",
								["<c-c>"] = "tcd",
								["<leader>/"] = "picker_grep",
								["<c-t>"] = "terminal",
								["."] = "explorer_focus",
								["I"] = "toggle_ignored",
								["H"] = "toggle_hidden",
								["Z"] = "explorer_close_all",
								["]g"] = "explorer_git_next",
								["[g"] = "explorer_git_prev",
								["]d"] = "explorer_diagnostic_next",
								["[d"] = "explorer_diagnostic_prev",
								["]w"] = "explorer_warn_next",
								["[w"] = "explorer_warn_prev",
								["]e"] = "explorer_error_next",
								["[e"] = "explorer_error_prev",
							},
						},
					},
				},
			},
			icons = {
				files = {
					enabled = true,
					dir = "󰉋 ",
					dir_open = "󰝰 ",
					file = "󰈔 ",
				},
				keymaps = {
					nowait = "󰓅 ",
				},
				tree = {
					vertical = "│ ",
					middle = "├╴",
					last = "└╴",
				},
				undo = {
					saved = " ",
				},
				ui = {
					live = "󰐰 ",
					hidden = "h",
					ignored = "i",
					follow = "f",
					--selected = "● ",
					unselected = "○ ",
					selected = " ",
				},
				git = {
					enabled = true,
					commit = "󰜘 ",
					staged = "●",
					added = "",
					deleted = "",
					ignored = " ",
					modified = "󰏫",
					renamed = "",
					unmerged = " ",
					untracked = "?",
				},
				diagnostics = {
					Error = " ",
					Warn = " ",
					Hint = " ",
					Info = " ",
				},
				lsp = {
					unavailable = "",
					enabled = " ",
					disabled = " ",
					attached = "󰖩 ",
				},
				kinds = {
					Array = " ",
					Boolean = "󰨙 ",
					Class = " ",
					Color = " ",
					Control = " ",
					Collapsed = " ",
					Constant = "󰏿 ",
					Constructor = " ",
					Copilot = " ",
					Enum = " ",
					EnumMember = " ",
					Event = " ",
					Field = " ",
					File = " ",
					Folder = " ",
					Function = "󰊕 ",
					Interface = " ",
					Key = " ",
					Keyword = " ",
					Method = "󰊕 ",
					Module = " ",
					Namespace = "󰦮 ",
					Null = " ",
					Number = "󰎠 ",
					Object = " ",
					Operator = " ",
					Package = " ",
					Property = " ",
					Reference = " ",
					Snippet = "󱄽 ",
					String = " ",
					Struct = "󰆼 ",
					Text = " ",
					TypeParameter = " ",
					Unit = " ",
					Unknown = " ",
					Value = " ",
					Variable = "󰀫 ",
				},
			},
			exclude = { "nvim", ".git", ".github", "node_modules", ".cache" },
		},
		notifier = {
			timeout = 8000,
			width = { min = 40, max = 0.4 },
			height = { min = 1, max = 0.6 },
			margin = { top = 0, right = 1, bottom = 0 },
			padding = true,
			gap = 0,
			sort = { "level", "added" },
			level = vim.log.levels.TRACE,
			icons = {
				error = " ",
				warn = " ",
				info = " ",
				debug = " ",
				trace = " ",
			},
			keep = function(notif)
				return vim.fn.getcmdpos() > 0
			end,
			filter = function(notif)
				if _G.lazy_notify and notif.msg:find("Reloading") then
					return false
				end

				return true
			end,
			style = "compact",
			top_down = true,
			date_format = "%R",
			more_format = " ↓ %d lines ",
			refresh = 50,
		},
		statuscolumn = {
			enabled = true,
			left = { "mark", "sign" },
			right = { "fold", "git" },
			folds = {
				open = true,
				git_hl = false,
			},
		},
		indent = {
			enabled = true,
			priority = 1,
			char = "│",
			only_scope = false,
			only_current = false,
			scope = {
				enabled = true,
				underline = false,
			},
		},
		scope = {
			enabled = true,
			cursor = true,
			edge = true,
			treesitter = {
				enabled = true,
				blocks = {
					enabled = true,
				},
			},
		},
		scroll = {
			enabled = true,
			animate = {
				duration = { step = 20, total = 200 },
				easing = "linear",
			},
			animate_repeat = {
				delay = 10,
				duration = { step = 15, total = 50 },
				easing = "linear",
			},
			filter = function(buf)
				return vim.g.snacks_scroll ~= false
					and vim.b[buf].snacks_scroll ~= false
					and vim.bo[buf].buftype ~= "terminal"
					and vim.api.nvim_buf_line_count(buf) < 10000
			end,
		},
		scratch = {
			enabled = true,
			name = "SCRATCH",
			ft = function()
				if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
					return vim.bo.filetype
				end
				return "markdown"
			end,
			autowrite = true,
			filekey = {
				cwd = true,
				branch = true,
			},
			win = {
				style = "scratch",
			},
		},
		quickfile = {
			enabled = true,
			exclude = { "latex" },
		},
		terminal = {
			enabled = true,
			auto_close = true,
			win = { style = "terminal" },
		},
		lazygit = {
			enabled = true,
			configure = true,
			config = {
				os = { editPreset = "nvim-remote" },
				gui = {
					nerdFontsVersion = "3",
				},
			},
			win = {
				style = "lazygit",
			},
		},
		input = {
			enabled = true,
			icon = "󰏫 ",
			icon_hl = "SnacksInputIcon",
			icon_pos = "left",
			prompt_pos = "title",
			win = { style = "input" },
			expand = true,
		},
		profiler = {
			enabled = true,
			thresholds = {
				time = { 2, 10 },
			},
		},
		image = {
			enabled = true,
			doc = {
				inline = true,
				float = true,
				max_width = 60,
				max_height = 30,
			},
		},
		gitbrowse = {
			enabled = true,
			what = "file",
			notify = true,
		},
		bigfile = {
			enabled = true,
			notify = true,
			size = 1.5 * 1024 * 1024,
			line_length = 1000,

			setup = function(ctx)
				if vim.fn.exists(":NoMatchParen") ~= 0 then
					vim.cmd([[NoMatchParen]])
				end

				Snacks.util.wo(0, {
					foldmethod = "manual",
					statuscolumn = "",
					conceallevel = 0,
				})

				vim.b.completion = false
				vim.b.minianimate_disable = true

				vim.schedule(function()
					if vim.api.nvim_buf_is_valid(ctx.buf) then
						vim.bo[ctx.buf].syntax = ctx.ft
					end
				end)
			end,
		},
		styles = {
			notification = {
				border = true,
				width = 0.4,
				zindex = 100,
				ft = "markdown",
				wo = {
					winblend = 0,
					wrap = true,
					conceallevel = 2,
					spell = false,
					number = false,
					statuscolumn = "",
					cursorline = false,
					winhighlight = "Normal:SnacksNotifierNormal,FloatBorder:SnacksNotifierBorder",
				},
				bo = {
					filetype = "snacks_notif",
				},
			},
			notification_history = {
				border = true,
				zindex = 100,
				width = 0.6,
				height = 0.6,
				minimal = false,
				title = " Notification History ",
				title_pos = "center",
				ft = "markdown",
				bo = { filetype = "snacks_notif_history", modifiable = false },
				wo = { winhighlight = "Normal:SnacksNotifierHistory" },
				keys = { q = "close" },
			},
			scratch = {
				width = 0.6,
				height = 0.4,
				border = "rounded",
				backdrop = 60,
				zindex = 60,
				row = 2,
				wo = {
					winblend = 0,
					winhighlight = "NormalFloat:SnacksScratchNormal,FloatBorder:SnacksScratchBorder",
					cursorline = false,
				},
				bo = {
					buftype = "",
					buflisted = false,
					bufhidden = "hide",
					swapfile = false,
				},
			},
			lazygit = {
				width = 0.9,
				height = 0.9,
				border = "rounded",
				backdrop = 60,
				zindex = 100,
				wo = {
					winhighlight = "NormalFloat:Normal,FloatBorder:FloatBorder",
				},
			},
			input = {
				backdrop = 60,
				position = "float",
				border = true,
				title_pos = "center",
				height = 1,
				width = 60,
				relative = "editor",
				noautocmd = true,
				row = 2,
				wo = {
					winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
					cursorline = false,
				},
				bo = {
					filetype = "snacks_input",
					buftype = "prompt",
				},
				b = {
					completion = true,
				},
				keys = {
					n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
					i_esc = { "<esc>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
					i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = { "i", "n" }, expr = true },
					i_tab = { "<tab>", { "cmp_select_next", "cmp" }, mode = "i", expr = true },
					i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
					i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
					i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
					q = "cancel",
				},
			},
			terminal = {
				position = "bottom",
				height = 0.2,
				keys = {
					q = "hide",
					term_normal = { "<esc>", [[<C-\><C-n>]], mode = "t", desc = "Normal Mode" },
				},
			},
		},
		words = {
			enabled = true,
			debounce = 150,
			notify_jump = false,
			notify_end = true,
		},
	},
	keys = {
		{
			"<leader><space>",
			function()
				Snacks.picker.smart({ filter = { cwd = true } })
			end,
			desc = "Smart Find Files",
		},
		{
			"<leader>cn",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Rename File",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>cc",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader>fn",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notification History",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.git_files()
			end,
			desc = "Find Git Files",
		},
		{
			"<leader>fp",
			function()
				Snacks.picker.projects()
			end,
			desc = "Projects",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.recent({ filter = { cwd = true } })
			end,
			desc = "Recent",
		},
		{
			"<leader>gb",
			function()
				Snacks.git.blame_line()
			end,
			desc = "Git Blame",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},
		{
			"<leader>gL",
			function()
				Snacks.picker.git_log_line()
			end,
			desc = "Git Log Line",
		},
		{
			"<leader>gS",
			function()
				Snacks.picker.git_stash()
			end,
			desc = "Git Stash",
		},
		{
			"<leader>gf",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "Git Log File",
		},
		{
			"<leader>gi",
			function()
				Snacks.picker.gh_issue()
			end,
			desc = "GitHub Issues (open)",
		},
		{
			"<leader>gI",
			function()
				Snacks.picker.gh_issue({ state = "all" })
			end,
			desc = "GitHub Issues (all)",
		},
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "GitHub Browse",
		},
		{
			"<leader>gp",
			function()
				Snacks.picker.gh_pr()
			end,
			desc = "GitHub Pull Requests (open)",
		},
		{
			"<leader>gP",
			function()
				Snacks.picker.gh_pr({ state = "all" })
			end,
			desc = "GitHub Pull Requests (all)",
		},
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>lf",
			function()
				Snacks.lazygit.log_file()
			end,
			desc = "Lazygit Current File History",
		},
		{
			"<leader>nt",
			function()
				Snacks.terminal.open()
			end,
			desc = "Toggle Terminal",
		},
		{
			"<leader>pt",
			function()
				Snacks.terminal.toggle(nil, { cwd = vim.fn.expand("%:p:h") })
			end,
			desc = "Terminal (cwd)",
		},
		{
			"<leader>sb",
			function()
				Snacks.picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>sB",
			function()
				Snacks.picker.grep_buffers()
			end,
			desc = "Grep Open Buffers",
		},
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>sw",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Visual selection or word",
			mode = { "n", "x" },
		},
		{
			'<leader>s"',
			function()
				Snacks.picker.registers()
			end,
			desc = "Registers",
		},
		{
			"<leader>s/",
			function()
				Snacks.picker.search_history()
			end,
			desc = "Search History",
		},
		{
			"<leader>sa",
			function()
				Snacks.picker.autocmds()
			end,
			desc = "Autocmds",
		},
		{
			"<leader>sb",
			function()
				Snacks.picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>sc",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader>sC",
			function()
				Snacks.picker.commands()
			end,
			desc = "Commands",
		},
		{
			"<leader>sd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>sD",
			function()
				Snacks.picker.diagnostics_buffer()
			end,
			desc = "Buffer Diagnostics",
		},
		{
			"<leader>sh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Pages",
		},
		{
			"<leader>sH",
			function()
				Snacks.picker.highlights()
			end,
			desc = "Highlights",
		},
		{
			"<leader>fi",
			function()
				Snacks.picker.icons()
			end,
			desc = "Icons",
		},
		{
			"<leader>fj",
			function()
				Snacks.picker.jumps()
			end,
			desc = "Jumps",
		},
		{
			"<leader>fk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>sl",
			function()
				Snacks.picker.loclist()
			end,
			desc = "Location List",
		},
		{
			"<leader>fm",
			function()
				Snacks.picker.marks()
			end,
			desc = "Marks",
		},
		{
			"<leader>fM",
			function()
				Snacks.picker.man()
			end,
			desc = "Man Pages",
		},
		{
			"<leader>sq",
			function()
				Snacks.picker.qflist()
			end,
			desc = "Quickfix List",
		},
		{
			"<leader>sR",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume",
		},
		{
			"<leader>fu",
			function()
				Snacks.picker.undo()
			end,
			desc = "Undo History",
		},
		{
			"<space>qs",
			function()
				retro.control_panel()
			end,
			desc = "Settings Panel",
		},
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch",
		},
		{
			"<leader>ih",
			function()
				Snacks.image.hover()
			end,
			desc = "Image Hover",
		},
		{
			"<leader>pp",
			function()
				Snacks.profiler.toggle()
			end,
			desc = "Profiler Toggle",
		},
		{
			"<leader>ps",
			function()
				Snacks.profiler.scratch()
			end,
			desc = "Profiler Scratch Buffer",
		},
	},
}
