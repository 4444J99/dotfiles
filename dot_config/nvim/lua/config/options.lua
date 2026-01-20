-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Line numbers
vim.opt.relativenumber = true

-- Tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Clipboard (use system clipboard)
vim.opt.clipboard = "unnamedplus"

-- Scrolloff (keep context when scrolling)
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true
