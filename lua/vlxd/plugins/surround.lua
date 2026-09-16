return {
	"kylechui/nvim-surround",
	version = "*",
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup()

		local map = vim.keymap.set
		local opts = { remap = true, silent = true }

		map("x", "(", "S(", opts)
		map("x", "{", "S{", opts)
		map("x", "[", "S[", opts)
		map("x", '"', 'S"', opts)
		map("x", "'", "S'", opts)
	end,
}
