vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.autoread = true
opt.cmdheight = 0

opt.mouse = "a"
opt.mousescroll = "ver:1,hor:1"
opt.mousemoveevent = true

opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

opt.backspace = "indent,eol,start"

opt.splitright = true
opt.splitbelow = true

opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"

opt.hlsearch = false
opt.incsearch = true
opt.scrolloff = 10
opt.sidescrolloff = 8

opt.undofile = true
opt.swapfile = false
opt.backup = false

opt.fillchars = { eob = " " }
opt.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds"
