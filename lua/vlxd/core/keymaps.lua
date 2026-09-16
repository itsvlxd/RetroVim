local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<leader>rb", ":e!<CR>", { desc = "Reload buffer" })

keymap.set({ "n", "v" }, "d", '"_d', { desc = "Delete (No Yank)" })
keymap.set({ "n", "v" }, "D", '"_D', { desc = "Delete Line (No Yank)" })
keymap.set("n", "c", '"_c', { desc = "Change (No Yank)" })
keymap.set({ "n", "v" }, "x", '"_x', { desc = "Delete Char (No Yank)" })

keymap.set("x", "p", [["_dP]], { desc = "Paste over selection" })

keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment Number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement Number" })

keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
keymap.set("n", "<leader>xx", "<cmd>bp|bd #<cr>", { desc = "Close Buffer" })
keymap.set("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New Empty File" })
keymap.set("n", "<leader>bl", "<cmd>BufferLineMoveNext<cr>", { desc = "Move Tab Right" })
keymap.set("n", "<leader>bh", "<cmd>BufferLineMovePrev<cr>", { desc = "Move Tab Left" })

keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
keymap.set({ "n", "x" }, "<leader>Y", '"+Y', { desc = "Copy line to system clipboard" })

keymap.set("n", "<leader>md", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Markdown Preview" })

keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
