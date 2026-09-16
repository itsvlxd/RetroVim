return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	keys = {
		{ "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
		{ "<leader>df", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History" },
		{ "<leader>dx", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
	},
	opts = {
		enhanced_diff_hl = true,
		view = {
			merge_tool = {
				layout = "diff3_mixed",
			},
		},
	},
}
