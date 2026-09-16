return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		config = function()
			local treesitter = require("nvim-treesitter")
			local autotag = require("nvim-ts-autotag")

			autotag.setup({
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = false,
				},
			})

			treesitter.setup({
				auto_install = true,
				ensure_installed = { "bash", "lua", "vim", "vimdoc", "query", "regex", "markdown", "markdown_inline" },
				highlight = {
					enable = true,
				},
				indent = { enable = true },
				textobjects = {
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]a"] = "@tag.outer",
						},
						goto_previous_start = {
							["[a"] = "@tag.outer",
						},
					},
				},
			})
		end,
	},
	{
		"MeanderingProgrammer/treesitter-modules.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-a>",
					node_incremental = "<C-a>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		},
	},
}
