return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		local servers = {
			"ts_ls",
			"html",
			"buf_ls",
			"css_variables",
			"cssmodules_ls",
			"tailwindcss",
			"svelte",
			"lua_ls",
			"gopls",
			"taplo",
			"bashls",
			"rust_analyzer",
			"clangd",
			"graphql",
			"emmet_ls",
			"eslint",
			"prismals",
			"pyright",
			"yamlls",
			"jsonls",
			"markdown_oxide",
			"arduino_language_server",
			"hyprls",
		}

		local tools = {
			"biome",
			"prettierd",
			"jsonlint",
			"jq",
			"shfmt",
			"shellcheck",
			"stylua",
			"eslint_d",
			"codelldb",
			"clang-format",
			"oxlint",
			"golangci-lint",
			"goimports",
			"gofumpt",
		}

		mason_lspconfig.setup({
			ensure_installed = servers,
			automatic_installation = false,
		})

		mason_tool_installer.setup({
			ensure_installed = tools,
		})
	end,
}
