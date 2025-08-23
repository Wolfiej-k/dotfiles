-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Display
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.cmdheight = 0
vim.opt.wrap = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 15

-- Editing
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Files
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hidden = true
vim.opt.autoread = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Splits
vim.o.splitright = true
vim.o.splitbelow = true

-- Miscellaneous
vim.encoding = "utf-8"
vim.opt.updatetime = 50
