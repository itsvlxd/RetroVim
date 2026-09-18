--[[ local function add_to_git()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" or file:match("snippets") then
		return
	end

	vim.system({ "git", "rev-parse", "--is-inside-work-tree" }, { text = true }, function(obj)
		if obj.code == 0 then
			vim.system({ "git", "add", file })
		end
	end)
end

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	callback = add_to_git,
}) ]]

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	command = "checktime",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("vlxd-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({
			hvgroup = "IncSearch",
			timeout = 150,
		})
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "neo-tree",
	callback = function()
		vim.opt_local.wrap = false
		vim.opt_local.sidescrolloff = 0
		vim.opt_local.scrollbind = false
	end,
})

local group = vim.api.nvim_create_augroup("vlxd_session_cleaner", { clear = true })

vim.api.nvim_create_autocmd("User", {
	pattern = "PersistedSavePre",
	group = group,
	callback = function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_is_valid(win) then
				local buf = vim.api.nvim_win_get_buf(win)
				local ft = vim.bo[buf].filetype
				if ft == "snacks_picker_list" or ft == "snacks_picker_input" or ft == "snacks_explorer" then
					pcall(vim.api.nvim_win_close, win, true)
				end
			end
		end
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "PersistedLoadPost",
	group = group,
	callback = function()
		vim.schedule(function()
			require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
			--require("snacks").explorer.open()
			--require("nvim-tree.api").tree.open()

			if vim.bo.filetype == "neo-tree" then
				vim.cmd("wincmd l")
			end
		end)
	end,
})

local progress = vim.defaulttable()

vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local value = ev.data.params.value
		if not client or type(value) ~= "table" then
			return
		end
		local p = progress[client.id]

		for i = 1, #p + 1 do
			if i == #p + 1 or p[i].token == ev.data.params.token then
				p[i] = {
					token = ev.data.params.token,
					msg = ("%3d%% %s%s"):format(
						value.kind == "end" and 100 or value.percentage or 100,
						value.title or "",
						value.message and (" %s"):format(value.message) or ""
					),
					done = value.kind == "end",
				}
				break
			end
		end

		local msg = {}
		progress[client.id] = vim.tbl_filter(function(v)
			return table.insert(msg, v.msg) or not v.done
		end, p)

		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		vim.notify(table.concat(msg, "\n"), "info", {
			id = "lsp_progress",
			title = client.name,
			opts = function(notif)
				notif.icon = #progress[client.id] == 0 and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.conf",
	callback = function(ev)
		local file_path = ev.file
		if not file_path or file_path == "" then
			return
		end

		local dir = vim.fs.dirname(file_path)

		local has_hypr = vim.fs.find("hyprland.conf", {
			path = dir,
			upward = true,
		})[1]

		if has_hypr then
			vim.bo[ev.buf].filetype = "hyprlang"
		end
	end,
})
