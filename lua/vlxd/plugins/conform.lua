return {
	"stevearc/conform.nvim",

	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local conform = require("conform")

		local formatters = { "biome", "prettier", stop_after_first = true }

		conform.setup({
			formatters_by_ft = {
				javascript = formatters,
				typescript = formatters,
				javascriptreact = formatters,
				typescriptreact = formatters,
				svelte = formatters,
				css = formatters,
				html = formatters,
				json = formatters,
				yaml = formatters,
				markdown = formatters,
				graphql = formatters,
				liquid = formatters,
				lua = { "stylua" },
				go = { "gofumpt", "goimports" },
				sh = { "shfmt" },
				bash = { "shfmt" },
			},
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2", "-ci", "-s" },
				},
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 3000,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 3000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
