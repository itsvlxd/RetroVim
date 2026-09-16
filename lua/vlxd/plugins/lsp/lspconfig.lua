return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
		"folke/snacks.nvim",
		"nvim-lua/plenary.nvim",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		local retro = require("vlxd.lib.retro")
		local mason_lspconfig = require("mason-lspconfig")
		local blink = require("blink.cmp")

		local capabilities = blink.get_lsp_capabilities()

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
				end

				local pick = function(name, opts)
					return function()
						local ok, snacks = pcall(require, "snacks")
						if ok and snacks.picker and snacks.picker[name] then
							snacks.picker[name](opts or { layout = { preset = "vscode" } })
						else
							retro.notify("Picker '" .. name .. "' not found", "error")
						end
					end
				end

				map("gd", pick("lsp_definitions"), "Definitions")
				map("gr", pick("lsp_references"), "References")
				map("gi", pick("lsp_implementations"), "Implementations")
				map("gt", pick("lsp_type_definitions"), "Type Definitions")
				map("gD", vim.lsp.buf.declaration, "Declaration")
				map("K", vim.lsp.buf.hover, "Hover")

				map("<leader>rn", vim.lsp.buf.rename, "Rename")
				map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
				map("<leader>rs", ":LspRestart<CR>", "Restart Server")

				map("<leader>d", vim.diagnostic.open_float, "Line Diagnostics")
				map("[d", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, "Prev Diagnostic")
				map("]d", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, "Next Diagnostic")

				map("<leader>dx", pick("diagnostics"), "Workspace Diagnostics")
				map("<leader>D", pick("diagnostics", { filter = { bufnr = 0 } }), "Buffer Diagnostics")
			end,
		})

		vim.diagnostic.config({
			signs = {
				{ name = "DiagnosticSignError", text = " ", numhl = "DiagnosticSignError" },
				{ name = "DiagnosticSignWarn", text = " ", numhl = "DiagnosticSignWarn" },
				{ name = "DiagnosticSignHint", text = "󰠠 ", numhl = "DiagnosticSignHint" },
				{ name = "DiagnosticSignInfo", text = " ", numhl = "DiagnosticSignInfo" },
			},
			virtual_text = false,
			update_in_insert = true,
			underline = true,
			severity_sort = true,
		})

		for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
			vim.lsp.config(server_name, {
				capabilities = capabilities,
			})

			vim.lsp.enable(server_name)
		end

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					workspace = {
						checkThirdParty = false,
						library = {},
						ignoreDir = {},
						pathStrict = false,
					},
					diagnostics = {
						globals = { "vim", "Snacks" },
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})

		vim.lsp.config("yamlls", {
			capabilities = capabilities,
			settings = {
				yaml = {
					format = {
						enable = true,
						singleQuote = false,
						bracketSpacing = true,
						proseWrap = "preserve",
						printWidth = 80,
					},
					validate = true,
					hover = true,
					completion = true,
					keyOrdering = false,
					schemaStore = {
						enable = true,
						url = "https://www.schemastore.org/api/json/catalog.json",
					},
					schemas = {
						["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
						["https://json.schemastore.org/github-action.json"] = "/.github/action*.yml",
						["https://json.schemastore.org/kubernetes.json"] = "k8s/**/*.yaml",
						["https://json.schemastore.org/prettierrc.json"] = ".prettierrc.yaml",
					},
					customTags = {
						"!Ref scalar",
						"!Sub scalar",
						"!GetAtt scalar",
						"!Join sequence",
						"!If sequence",
						"!Equals sequence",
						"!And sequence",
						"!Or sequence",
						"!Not sequence",
						"!FindInMap sequence",
						"!ImportValue scalar",
						"!Base64 scalar",
						"!Cidr sequence",
						"!Select sequence",
						"!Split sequence",
					},
				},
			},
		})

		vim.lsp.config("jsonls", {
			capabilities = capabilities,
			settings = {
				cmd = { "vscode-json-language-server", "--stdio" },
				filetypes = { "json", "jsonc" },
				init_options = { provideFormatter = true },
				root_markers = { ".git" },
			},
		})

		vim.lsp.config("tailwindcss", {
			capabilities = capabilities,
			filetypes = {
				"html",
				"css",
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
				"vue",
				"svelte",
			},
			settings = {
				tailwindCSS = {
					experimental = {
						classRegex = {
							"class(?:Name)?\\s*=\\s*[\"'`]([^\"'`]*)[\"'`]",
							"twMerge\\(([^)]*)%)",
							"cva\\((['\"])([^'\"]*)\\1",
						},
					},
				},
			},
		})

		vim.lsp.config("emmet_ls", {
			capabilities = capabilities,
			filetypes = {
				"html",
				"css",
				"scss",
				"sass",
				"less",
				"svelte",
			},
		})

		vim.lsp.config("clangd", {
			capabilities = capabilities,
			keys = {
				{ "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
			},
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
				"--function-arg-placeholders",
				"--fallback-style=llvm",
			},
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
			init_options = {
				usePlaceholders = true,
				completeUnimported = true,
				clangdFileStatus = true,
			},
			root_markers = {
				"compile_commands.json",
				"compile_flags.txt",
				"configure.ac",
				"Makefile",
				"configure.ac",
				"configure.in",
				"config.h.in",
				"meson.build",
				"meson_options.txt",
				"build.ninja",
				".git",
			},
		})

		vim.lsp.config("hyprls", {
			root_dir = function(fname)
				if type(fname) ~= "string" then
					return nil
				end

				local root_file = vim.fs.find("hyprland.conf", {
					upward = true,
					path = vim.fs.dirname(fname),
				})[1]

				if root_file then
					return vim.fs.dirname(root_file)
				end

				return nil
			end,
			filetypes = { "hyprlang" },
		})

		vim.lsp.config("gopls", {
			capabilities = capabilities,
			settings = {
				gopls = {
					completeUnimported = true,
					usePlaceholders = true,
					gofumpt = true,
					codelenses = {
						generate = true,
						tidy = true,
						vendor = true,
						upgrade_dependency = true,
						run_govulncheck = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			},
		})
	end,
}
