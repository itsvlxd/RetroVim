local M = {}

local git = require("vlxd.lib.git")

M.icon = "󱁕 "
M.retrovim = M.icon .. "RetroVim"

local function get_visual_width(str)
	local _, count = string.gsub(str, "[^\128-\193]", "")

	local _, icons = string.gsub(str, "[\239\240]", "")
	return count + (icons * 1)
end

function M.header(opts)
	opts = opts or {}

	local logo_lines = {
		[[██████╗ ███████╗████████╗██████╗  ██████╗ ██╗   ██╗██╗███╗   ███╗]],
		[[██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗██║   ██║██║████╗ ████║]],
		[[██████╔╝█████╗     ██║   ██████╔╝██║   ██║██║   ██║██║██╔████╔██║]],
		[[██╔══██╗██╔══╝     ██║   ██╔══██╗██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
		[[██║  ██║███████╗   ██║   ██║  ██║╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
		[[╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
	}

	local logo_width = 62 / 2
	local sub_segments = {}

	if opts.title then
		table.insert(sub_segments, "󱁕 " .. opts.title)
	end

	if opts.show_stats then
		local retro_v = git.get_version()
		--local branch = git.get_branch()
		table.insert(sub_segments, string.format("%s", retro_v))
		--table.insert(sub_segments, string.format(" %s", branch))
	end

	if opts.custom_info then
		table.insert(sub_segments, opts.custom_info)
	end

	local subtext = table.concat(sub_segments, " │ ")
	local logo_string = table.concat(logo_lines, "\n")

	if #subtext > 0 then
		local visual_len = get_visual_width(subtext)

		local padding_size = math.floor((logo_width - visual_len) / 2)

		padding_size = math.max(0, padding_size)

		return logo_string .. "\n" .. string.rep(" ", padding_size) .. subtext
	end

	return logo_string
end

---@param path string
---@return boolean
function M.file_exists(path)
	local stat = vim.uv.fs_stat(path)
	return stat ~= nil and stat.type == "file"
end

--- @param msg string
--- @param level "info"|"warn"|"error"?
--- @param title string?
function M.notify(msg, level, title)
	local levels = {
		info = vim.log.levels.INFO,
		warn = vim.log.levels.WARN,
		error = vim.log.levels.ERROR,
	}

	vim.notify(msg, levels[level] or levels.info, {
		title = title or M.retrovim,
		render = "compact",
		timeout = (level == "info") and 8000 or 10000,
	})
end

function M.switch(bool)
	if bool then
		return " "
	else
		return " "
	end
end

local FALLBACK_COLORS = {
	bg = "#0d0b21",
	fg = "#e5e9f0",
	red = "#ff2a6d",
	orange = "#ff9e64",
	yellow = "#ffcc33",
	green = "#05ffa1",
	cyan = "#00d9ff",
	blue = "#6b70ff",
	dark_blue = "#1a1b41",
	purple = "#b24bf3",
	white = "#d1d1e0",
	black = "#050512",
	gray = "#323c58",
	dark_gray = "#16162e",
	highlight = "#ff00ff",
	cursor_line = "#1a1b41",
	comment = "#565f89",
	none = "NONE",
}

local default_state = {
	theme = "retrowave",
	dark = true,
	transparent = false,
	lualine_trans = false,
	bufferline_sep = "thick",
	system_sync_interval = 5,
	bg_override = nil,
}

local state_path = vim.fn.stdpath("state") .. "/retrovim/theme_config.json"

local _has_update = nil
local _notified_update = false
local _current_colors = nil
local _system_watcher = nil
local _system_timer = nil
local _system_last_mtime = nil

local CUSTOM_THEME_DIR = vim.fn.expand("~/.config/retrovim/themes")

function M.get_theme_syntax()
	local state = M.get_settings()
	local module_path = "vlxd.themes." .. state.theme

	package.loaded[module_path] = nil
	local ok, theme_config = pcall(require, module_path)

	if not ok then
		print("Theme file missing at: " .. module_path)
		return
	end

	local syntax = theme_config["syntax"]

	if ok and type(syntax) == "table" then
		return syntax
	end
end

function M.get_theme_colors()
	local state = M.get_settings()

	if _current_colors and state.theme ~= "system" then
		return _current_colors
	end

	local module_path = "vlxd.themes." .. state.theme

	package.loaded[module_path] = nil
	local ok, theme_config = pcall(require, module_path)

	if not ok then
		local custom_path = CUSTOM_THEME_DIR .. "/" .. state.theme .. ".lua"
		local custom_fn = loadfile(custom_path)
		if custom_fn then
			ok, theme_config = pcall(custom_fn)
		end
	end

	if not ok then
		print("Theme file missing at: " .. module_path)
		return FALLBACK_COLORS
	end

	local colors = (state.dark == true) and theme_config["darkMode"] or theme_config["lightMode"]

	if state.bg_override then
		colors = vim.tbl_extend("force", colors, { bg = state.bg_override })
	end

	if ok and type(colors) == "table" then
		_current_colors = colors
		return colors
	end

	return FALLBACK_COLORS
end

---@return {theme: string, dark: boolean, transparent: boolean, lualine_trans: boolean, bufferline_sep: "slant" | "slope" | "thick" | "thin", neotree_expander: boolean, system_sync_interval: number, bg_override: string?}
function M.get_settings()
	local f = io.open(state_path, "r")

	if not f then
		local dir = vim.fn.fnamemodify(state_path, ":h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end

		local success, encoded = pcall(vim.fn.json_encode, default_state)
		if success then
			local wf = io.open(state_path, "w")
			if wf then
				wf:write(encoded)
				wf:close()
			end
		end
		return default_state
	end

	local content = f:read("*a")
	f:close()

	if not content or content == "" then
		return default_state
	end

	local ok, decoded = pcall(vim.fn.json_decode, content)
	if ok and type(decoded) == "table" then
		return vim.tbl_deep_extend("force", default_state, decoded)
	end

	return default_state
end

---@param opts {theme: string, dark: boolean, transparent: boolean, lualine_trans: boolean, bufferline_sep: "slant" | "slope" | "thick" | "thin", neotree_expander: boolean, system_sync_interval: number, bg_override: string?}
function M.save_settings(opts)
	local f = io.open(state_path, "w")

	if f then
		f:write(vim.fn.json_encode(opts))
		f:close()
	end
end

function M.stop_system_watcher()
	if _system_timer then
		_system_timer:stop()
		_system_timer:close()
		_system_timer = nil
	end
	if _system_watcher then
		_system_watcher:stop()
		_system_watcher:close()
		_system_watcher = nil
	end
	_system_last_mtime = nil
end

function M.start_system_watcher()
	M.stop_system_watcher()

	local settings = M.get_settings()
	local interval = settings.system_sync_interval or 5
	local kitty_path = vim.fn.expand("~/.config/retro/themes/kitty-colors.conf")

	local stat = vim.uv.fs_stat(kitty_path)
	if not stat then
		return
	end

	_system_last_mtime = stat.mtime.sec

	local timer = vim.uv.new_timer()
	if not timer then
		return
	end

	_system_timer = timer
	timer:start(
		0,
		interval * 1000,
		vim.schedule_wrap(function()
			local s = vim.uv.fs_stat(kitty_path)
			if not s then
				return
			end

			if s.mtime.sec ~= _system_last_mtime then
				_system_last_mtime = s.mtime.sec
				_current_colors = nil
				M.apply({ theme = "system" })
			end
		end)
	)
end

function M.check_update()
	if _has_update ~= nil then
		return
	end

	git.run_async({ "git", "fetch", "origin" }, function()
		git.run_async({ "git", "rev-parse", "HEAD" }, function(local_hash)
			git.run_async({ "git", "rev-parse", "@{u}" }, function(remote_hash)
				if local_hash and remote_hash then
					_has_update = (local_hash ~= remote_hash)

					if _has_update and not _notified_update then
						M.notify("A new version of RetroVim is available!", "info")
						_notified_update = true
					end
				end
			end)
		end)
	end)
end

function M.update()
	M.notify("Fetching remote data...", "info")

	git.run_async({ "git", "fetch", "--all", "--tags" }, function()
		M.notify("Synchronizing main branch...", "info")
		git.run_async({ "git", "checkout", "-B", "main", "origin/main" }, function()
			git.run_async({ "git", "describe", "--tags", "--abbrev=0" }, function(latest_tag)
				git.run_async({ "git", "describe", "--tags", "--always" }, function(current_state)
					if latest_tag and latest_tag ~= current_state then
						M.notify("New tag detected: " .. latest_tag, "info")

						git.run_async({ "git", "checkout", latest_tag }, function()
							M.notify("RetroVim updated to " .. latest_tag, "info")
							_has_update = false
							Snacks.dashboard.update()
						end)
					else
						M.notify("RetroVim updated to latest commit on main.", "info")
						_has_update = false
						Snacks.dashboard.update()
					end
				end)
			end)
		end)
	end)
end

function M.reload_plugins()
	_G.lazy_notify = true

	local plugins_to_reload = { "onedarkpro.nvim", "lualine.nvim" }

	local lazy_ok, lazy = pcall(require, "lazy.core.loader")

	if lazy_ok then
		for _, plugin in ipairs(plugins_to_reload) do
			lazy.load({ plugin }, { f = "colorscheme" })

			pcall(function()
				vim.cmd("Lazy reload " .. plugin)
			end)
		end
	end

	vim.defer_fn(function()
		_G.lazy_notify = false
	end, 100)
end

---@param opts {theme: string, dark: boolean, transparent: boolean, lualine_trans: boolean, bufferline_sep: "slant" | "slope" | "thick" | "thin", neotree_expander: boolean, system_sync_interval: number, bg_override: string?}
function M.apply(opts)
	local state = M.get_settings()
	local theme_name = opts.theme or state.theme
	local dark = (opts.dark == nil) and state.dark or opts.dark
	local bufferline_sep = opts.bufferline_sep or state.bufferline_sep
	local transparent = (opts.transparent == nil) and state.transparent or opts.transparent
	local lualine_trans = (opts.lualine_trans == nil) and state.lualine_trans or opts.lualine_trans
	local neotree_expander = (opts.neotree_expander == nil) and state.neotree_expander or opts.neotree_expander
	local system_sync_interval = opts.system_sync_interval or state.system_sync_interval
	local bg_override = opts.bg_override or state.bg_override

	if vim.v.dying > 0 or vim.v.exiting ~= vim.NIL then
		return
	end

	local clean_name = vim.fn.fnamemodify(theme_name, ":t:r")
	local module_path = "vlxd.themes." .. clean_name

	package.loaded[module_path] = nil
	local ok, theme_config = pcall(require, module_path)

	if not ok then
		local custom_path = CUSTOM_THEME_DIR .. "/" .. clean_name .. ".lua"
		local custom_fn = loadfile(custom_path)
		if custom_fn then
			ok, theme_config = pcall(custom_fn)
		end
	end

	if not ok then
		print("Theme file missing at: " .. module_path)
		return
	end

	local colors = (dark == true) and theme_config["darkMode"] or theme_config["lightMode"]

	if bg_override then
		colors = vim.tbl_extend("force", colors, { bg = bg_override })
	end

	_current_colors = colors

	M.save_settings({
		dark = dark,
		theme = theme_name,
		transparent = transparent,
		lualine_trans = lualine_trans,
		bufferline_sep = bufferline_sep,
		neotree_expander = neotree_expander,
		system_sync_interval = system_sync_interval,
		bg_override = bg_override,
	})

	M.reload_plugins()

	M.stop_system_watcher()
	if clean_name == "system" then
		M.start_system_watcher()
	end

	if theme_name ~= state.theme then
		M.notify("Theme Applied: " .. clean_name:gsub("^%l", string.upper))
	end
end

function M.refresh_control_panel()
	local old_win = vim.api.nvim_get_current_win()
	M.control_panel()

	if vim.api.nvim_win_is_valid(old_win) then
		pcall(vim.api.nvim_win_close, old_win, true)
	end
end

function M.open_theme_picker()
	local themes = {}
	local theme_dir = vim.fn.stdpath("config") .. "/lua/vlxd/themes"

	local files = vim.fn.readdir(theme_dir)
	for _, file in ipairs(files) do
		if file:match("%.lua$") then
			local mod_name = file:gsub("%.lua$", "")
			local ok, data = pcall(require, "vlxd.themes." .. mod_name)
			if ok then
				table.insert(themes, {
					text = data.title or mod_name,
					file = mod_name,
					description = data.description or "RetroVim Theme",
					colors = data.darkMode or data.lightMode or {},
					is_custom = false,
				})
			end
		end
	end

	if vim.fn.isdirectory(CUSTOM_THEME_DIR) == 0 then
		vim.fn.mkdir(CUSTOM_THEME_DIR, "p")
	end

	local custom_files = vim.fn.readdir(CUSTOM_THEME_DIR)
	for _, file in ipairs(custom_files) do
		if file:match("%.lua$") then
			local mod_name = file:gsub("%.lua$", "")
			local custom_path = CUSTOM_THEME_DIR .. "/" .. file
			local ok, data = pcall(function()
				local fn = loadfile(custom_path)
				return fn and fn()
			end)
			if ok and data then
				table.insert(themes, {
					text = data.title or mod_name,
					file = mod_name,
					description = (data.description or "Custom Theme") .. " (Custom)",
					colors = data.darkMode or data.lightMode or {},
					is_custom = true,
				})
			end
		end
	end

	Snacks.picker.pick({
		title = M.retrovim .. " Themes ",
		items = themes,
		format = function(item)
			return {
				{ item.text, "SnacksDashboardIcon" },
				{ " — " .. item.description, "comment" },
			}
		end,
		preview = function(ctx)
			local item = ctx.item
			local ns = vim.api.nvim_create_namespace("theme_preview")
			local buf = ctx.buf
			local win = ctx.win

			vim.wo[win].number = false
			vim.wo[win].relativenumber = false
			vim.wo[win].cursorline = false
			vim.wo[win].signcolumn = "no"

			vim.bo[buf].modifiable = true
			vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

			local state = M.get_settings()
			local mode_key = state.dark and "darkMode" or "lightMode"

			local ok, data
			if item.is_custom then
				local custom_path = CUSTOM_THEME_DIR .. "/" .. item.file .. ".lua"
				ok, data = pcall(function()
					local fn = loadfile(custom_path)
					return fn and fn()
				end)
			else
				ok, data = pcall(require, "vlxd.themes." .. item.file)
			end
			if not ok or not data then
				return
			end

			local palette = data[mode_key]
			local accent = palette.highlight or palette.purple or "#ffffff"
			local foreground = palette.fg or "#ffffff"

			vim.api.nvim_set_hl(0, "ThemePrevNormal", { fg = foreground, bg = palette.bg })
			vim.api.nvim_set_hl(0, "ThemePrevAccent", { fg = accent, bg = palette.bg, bold = true })
			vim.api.nvim_set_hl(0, "ThemePrevComment", { fg = palette.comment, bg = palette.bg, italic = true })

			vim.wo[win].winhighlight = "Normal:ThemePrevNormal"

			local lines = {
				"  " .. item.text:upper(),
				"  " .. string.rep("─", #item.text),
				"  " .. item.description,
				" ",
			}
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

			vim.api.nvim_buf_set_extmark(
				buf,
				ns,
				0,
				0,
				{ hl_group = "ThemePrevAccent", end_col = #lines[1], priority = 100 }
			)
			vim.api.nvim_buf_set_extmark(
				buf,
				ns,
				2,
				0,
				{ hl_group = "ThemePrevComment", end_col = #lines[3], priority = 100 }
			)

			local order = {
				"bg",
				"fg",
				"highlight",
				"comment",
				"red",
				"orange",
				"yellow",
				"green",
				"cyan",
				"blue",
				"purple",
				"gray",
			}

			for _, name in ipairs(order) do
				local hex = palette[name]
				if hex then
					local current_line = vim.api.nvim_buf_line_count(buf)
					local line_text = string.format("  ██ %-12s : %s", name, hex)

					vim.api.nvim_buf_set_lines(buf, current_line, current_line, false, { line_text })

					local hl_swatch = "ThemeSwatch" .. name
					vim.api.nvim_set_hl(0, hl_swatch, { fg = hex, bg = palette.bg })
					vim.api.nvim_buf_set_extmark(buf, ns, current_line, 2, {
						end_col = 8,
						hl_group = hl_swatch,
						priority = 110,
					})

					vim.api.nvim_buf_set_extmark(buf, ns, current_line, 8, {
						hl_group = "ThemePrevNormal",
						end_col = #line_text,
						priority = 100,
					})
				end
			end

			vim.bo[buf].modifiable = false
		end,
		confirm = function(picker, item)
			picker:close()
			M.apply({ theme = item.file })
			M.control_panel()
		end,
	})
end

function M.reload_bufferline()
	local bufferline_spec = require("vlxd.plugins.bufferline")
	local opts = bufferline_spec.opts
	local settings = M.get_settings()

	opts.options.separator_style = settings.bufferline_sep
	opts.options.indicator.style = (settings.bufferline_sep == "thick" or settings.bufferline_sep == "thin") and "icon"
		or "underline"

	opts.options.offsets[1].text = M.retrovim

	package.loaded["bufferline"] = nil
	require("bufferline").setup(opts)

	vim.cmd("redrawtabline")
	vim.cmd("redraw!")

	M.notify("Bufferline changes detected.\nHot reloading might be unstable; restarting Neovim is recommended.", "warn")
end

function M.open_bufferline_sep_picker()
	local lookup = {
		["Slant"] = "slant",
		["Slope"] = "slope",
		["Thick"] = "thick",
		["Thin"] = "thin",
	}

	local items = { "Slant", "Slope", "Thick", "Thin" }

	Snacks.picker.select(items, {
		prompt = "󰇝 Bufferline Style",
	}, function(choice)
		if choice and lookup[choice] then
			M.apply({ bufferline_sep = lookup[choice] })
			M.reload_bufferline()
			M.refresh_control_panel()
		else
			M.refresh_control_panel()
		end
	end)
end

function M.open_interval_picker()
	local items = { "5s", "15s", "30s", "60s" }
	local lookup = { ["5s"] = 5, ["15s"] = 15, ["30s"] = 30, ["60s"] = 60 }

	Snacks.picker.select(items, {
		prompt = "󰅐 Kitty Sync Interval",
	}, function(choice)
		if choice and lookup[choice] then
			M.apply({ system_sync_interval = lookup[choice] })
			M.refresh_control_panel()
		else
			M.refresh_control_panel()
		end
	end)
end

function M.open_branch_picker()
	local git = require("vlxd.lib.git")
	local current = git.get_branch()
	local items = { "main", "develop" }

	Snacks.picker.select(items, {
		prompt = "󰊢 Switch Branch",
		default = current,
	}, function(choice)
		if not choice or choice == current then
			M.refresh_control_panel()
			return
		end

		local result = git.run({ "git", "checkout", choice })
		if result ~= nil or vim.v.shell_error == 0 then
			M.notify("Switched to branch: " .. choice, "info")

			vim.defer_fn(function()
				M.refresh_control_panel()
			end, 100)
		else
			M.notify("Failed to switch branch", "error")
			M.refresh_control_panel()
		end
	end)
end

function M.open_bg_picker()
	local presets = {
		{ text = "#0a0a0a (System)", hex = "#0a0a0a" },
		{ text = "#070514 (V2)", hex = "#070514" },
		{ text = "#0d0b21 (V1)", hex = "#0d0b21" },
		{ text = "#121212 (V3)", hex = "#121212" },
		{ text = "#050512", hex = "#050512" },
		{ text = "#000000 (Pure Black)", hex = "#000000" },
		{ text = "#1a1a1a (Charcoal)", hex = "#1a1a1a" },
		{ text = "#1e1e1e (Dark Slate)", hex = "#1e1e1e" },
		{ text = "#161616", hex = "#161616" },
		{ text = "Custom...", hex = "custom" },
		{ text = "Reset to default", hex = nil },
	}

	local items = {}
	for _, p in ipairs(presets) do
		table.insert(items, p.text)
	end

	Snacks.picker.select(items, {
		prompt = "󰏘 Background Color",
	}, function(choice)
		if not choice then
			M.refresh_control_panel()
			return
		end

		for _, p in ipairs(presets) do
			if p.text == choice then
				if p.hex == "custom" then
					vim.ui.input({ prompt = "Hex color: ", default = "#121212" }, function(input)
						if input and input:match("^#[0-9a-fA-F]{6}$") then
							M.apply({ bg_override = input:lower() })
						end
						M.refresh_control_panel()
					end)
				else
					M.apply({ bg_override = p.hex })
					M.refresh_control_panel()
				end
				return
			end
		end
		M.refresh_control_panel()
	end)
end

function M.startup()
	return function()
		local v = vim.version()
		local stats = require("lazy").stats()
		local ms = string.format("%.2f", stats.startuptime)
		local nvim_ver = string.format("v%s.%s.%s", v.major, v.minor, v.patch)

		return {
			align = "center",
			text = {
				{ " " .. nvim_ver, hl = "RetroStartupNvim" },
				{ "  󱐋 " .. stats.count .. " plugins", hl = "SnacksDashboardIcon" },
				{
					" loaded in " .. ms .. "ms",
					hl = "comment",
				},
				{ "   " .. git.get_branch(), hl = "SnacksDashboardKey" },
			},
		}
	end
end

function M.update_status()
	if _has_update == nil then
		M.check_update()
	end

	local icon = _has_update and "󱓄 " or " "
	local label = _has_update and "Update Available" or "RetroVim is up to date"
	local hl = _has_update and "SnacksDashboardDir" or "comment"

	local text = {
		{ icon, hl = "SnacksDashboardIcon" },
		{ label, hl = hl },
	}

	if _has_update then
		table.insert(text, { "  [Press u to update]", hl = "SnacksDashboardKey" })
	end

	return {
		align = "center",
		padding = { 1, 0 },
		text = text,
		key = "u",
		action = function()
			if _has_update then
				M.update()

				_has_update = true

				Snacks.dashboard.update()
			else
				M.notify("Already on the latest version!")
			end
		end,
	}
end

function M.control_panel()
	local settings = M.get_settings()
	local neotree = require("neo-tree.command")

	neotree.execute({ action = "close" })

	local settingsMenuOpts = {
		width = 60,
		row = nil,
		col = nil,
		pane_gap = 4,
		autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
		preset = {
			pick = nil,
			header = M.header({
				title = "Settings Menu",
				show_stats = true,
			}),
			keys = {
				{
					icon = "󰏘 ",
					key = "t",
					desc = "Theme: " .. settings.theme,
					action = function()
						M.open_theme_picker()
					end,
				},
				{
					icon = settings.transparent and "󰈈 " or "󰈉 ",
					key = "b",
					desc = "Transparency: " .. M.switch(settings.transparent),
					action = function()
						M.apply({ transparent = not settings.transparent })

						M.refresh_control_panel()
					end,
				},
				function()
					if settings.transparent then
						return {
							icon = (settings.lualine_trans and "󰲝 " or "󰲟 "),
							key = "l",
							desc = "Lualine Transparency: " .. M.switch(settings.lualine_trans),
							action = function()
								M.apply({ lualine_trans = not settings.lualine_trans })

								M.refresh_control_panel()
							end,
						}
					end
				end,
				{
					icon = settings.dark and "󰖔 " or "󰖨 ",
					key = "d",
					desc = "Dark Mode: " .. M.switch(settings.dark),
					action = function()
						M.apply({ dark = not settings.dark })

						M.refresh_control_panel()
					end,
				},
				{
					icon = "󰏘 ",
					key = "g",
					desc = "Background: " .. (settings.bg_override or "theme default"),
					action = function()
						M.open_bg_picker()
					end,
				},
				{
					icon = "󰇝 ",
					key = "s",
					desc = "Bufferline Style: " .. (settings.bufferline_sep or "thick"),
					action = function()
						M.open_bufferline_sep_picker()
					end,
				},
				{
					icon = "󰙅 ",
					key = "e",
					desc = "Tree Style: " .. M.switch(settings.neotree_expander),
					action = function()
						M.apply({ neotree_expander = not settings.neotree_expander })

						M.refresh_control_panel()

						vim.cmd("Neotree close")
					end,
				},
				function()
					if settings.theme == "system" then
						return {
							icon = "󰅐 ",
							key = "i",
							desc = "Sync Interval: " .. (settings.system_sync_interval or 5) .. "s",
							action = function()
								M.open_interval_picker()
							end,
						}
					end
				end,
				{
					icon = "󰊢 ",
					key = "w",
					desc = "Branch: " .. git.get_branch(),
					action = function()
						M.open_branch_picker()
					end,
				},
				{
					icon = "󰦛 ",
					key = "r",
					desc = "Reset to Defaults",
					action = function()
						M.apply(default_state)
						M.control_panel()
					end,
				},
				{
					icon = " ",
					key = "c",
					desc = "Back to coding",
					action = function()
						neotree.execute({ action = "show" })
					end,
				},
				{
					key = "q",
					action = function()
						neotree.execute({ action = "show" })
					end,
					hidden = true,
				},
				{
					key = "<ESC>",
					action = function()
						neotree.execute({ action = "show" })
					end,
					hidden = true,
				},
			},
		},
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
			M.startup(),
			M.update_status(),
		},
	}

	return Snacks.dashboard.open(settingsMenuOpts)
end

return M
