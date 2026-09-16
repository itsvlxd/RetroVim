local function darken(hex, amount)
	hex = hex:gsub("#", "")
	if #hex == 3 then
		hex = hex:gsub("(.)", "%1%1")
	end
	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)
	return string.format(
		"#%02x%02x%02x",
		math.floor(r * (1 - amount)),
		math.floor(g * (1 - amount)),
		math.floor(b * (1 - amount))
	)
end

local KITTY_PATH = vim.fn.expand("~/.config/retro/themes/kitty-colors.conf")

local KITTY_MAP = {
	background = "bg",
	foreground = "fg",
	color0 = "black",
	color1 = "red",
	color2 = "green",
	color3 = "yellow",
	color4 = "blue",
	color5 = "purple",
	color6 = "cyan",
	color7 = "white",
	color8 = "comment",
	color9 = "orange",
	color13 = "highlight",
}

local function parse_kitty_line(line)
	local key, hex = line:match("^%s*(%w+)%s+(#[0-9a-fA-F]+)")
	if key and hex then
		return key, hex:lower()
	end
	return nil, nil
end

local function build_from_kitty()
	local f = io.open(KITTY_PATH, "r")
	if not f then
		return nil
	end

	local content = f:read("*a")
	f:close()

	if not content or content == "" then
		return nil
	end

	local raw = {}
	for line in content:gmatch("[^\r\n]+") do
		local key, hex = parse_kitty_line(line)
		if key and hex and KITTY_MAP[key] then
			raw[key] = hex
		end
	end

	local bg = raw.background
	local fg = raw.foreground
	if not bg or not fg then
		return nil
	end

	return {
		bg = bg,
		fg = fg,
		cursor_line = darken(bg, 0.1),
		black = raw.color0 or bg,
		red = raw.color1 or "#ff2a6d",
		green = raw.color2 or "#05ffa1",
		yellow = raw.color3 or "#ffcc33",
		blue = raw.color4 or "#6b70ff",
		purple = raw.color5 or "#b24bf3",
		cyan = raw.color6 or "#00d9ff",
		white = raw.color7 or fg,
		comment = raw.color8 or darken(fg, 0.4),
		gray = darken(fg, 0.65),
		dark_gray = darken(bg, 0.2),
		dark_blue = darken(raw.color4 or "#6b70ff", 0.5),
		orange = raw.color9 or raw.color1 or "#ff9e64",
		highlight = raw.color13 or raw.color5 or "#ff00ff",
		none = "NONE",
	}
end

local function tc(index)
	local ok, color = pcall(function()
		return vim.g["terminal_color_" .. index]
	end)
	return ok and color or nil
end

local function build_from_terminal()
	local bg = tc(0)
	local fg = tc(7)

	if not bg or not fg then
		return nil
	end

	return {
		bg = bg,
		fg = fg,
		cursor_line = darken(bg, 0.1),
		black = tc(0) or bg,
		red = tc(1) or "#ff2a6d",
		green = tc(2) or "#05ffa1",
		yellow = tc(3) or "#ffcc33",
		blue = tc(4) or "#6b70ff",
		purple = tc(5) or "#b24bf3",
		cyan = tc(6) or "#00d9ff",
		white = tc(7) or fg,
		comment = tc(8) or darken(fg, 0.4),
		gray = darken(fg, 0.65),
		dark_gray = darken(bg, 0.2),
		dark_blue = darken(tc(4) or "#6b70ff", 0.5),
		orange = tc(9) or tc(1) or "#ff9e64",
		highlight = tc(13) or tc(5) or "#ff00ff",
		none = "NONE",
	}
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

local colors = build_from_kitty() or build_from_terminal() or FALLBACK_COLORS

return {
	title = "System",
	description = "Syncs to your kitty terminal palette — changes take effect live.",
	kitty_path = KITTY_PATH,

	syntax = {
		["@variable"] = { fg = "${green}" },
		["@variable.builtin"] = { fg = "${red}", italic = true },
		["@variable.parameter"] = { fg = "${cyan}", italic = true },
		["@variable.member"] = { fg = "${yellow}" },
		["@property"] = { fg = "${yellow}" },
		["@field"] = { fg = "${yellow}" },
		["@function"] = { fg = "${blue}", bold = true },
		["@function.builtin"] = { fg = "${orange}" },
		["@method"] = { fg = "${blue}", bold = true },
		["@method.call"] = { fg = "${blue}" },
		["@keyword"] = { fg = "${purple}", bold = true },
		["@keyword.function"] = { fg = "${purple}", bold = true },
		["@keyword.return"] = { fg = "${highlight}", bold = true },
		["@operator"] = { fg = "${highlight}" },
		["@punctuation"] = { fg = "${white}" },
		["@type"] = { fg = "${orange}" },
		["@type.builtin"] = { fg = "${orange}", italic = true },
		["@constant"] = { fg = "${purple}" },
		["@constant.builtin"] = { fg = "${orange}", bold = true },
		["@constant.macro"] = { fg = "${highlight}" },
		["@string"] = { fg = "${fg}" },
		["@string.escape"] = { fg = "${highlight}" },
		["@number"] = { fg = "${orange}" },
		["@boolean"] = { fg = "${highlight}" },
		["@comment"] = { fg = "${comment}", italic = true },
		["@label"] = { fg = "${highlight}" },
		["@markup.heading"] = { fg = "${purple}", bold = true },
		["@markup.link"] = { fg = "${cyan}" },
		["@markup.list"] = { fg = "${highlight}" },
	},
	lightMode = colors,
	darkMode = colors,
}
