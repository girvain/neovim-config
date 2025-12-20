-- ~/.config/nvim/lua/settings.lua

-- Basic editor settings
vim.o.number = true
vim.o.relativenumber = false
vim.o.cursorline = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = false
vim.o.clipboard = "unnamed"
vim.o.termguicolors = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.hlsearch = true
vim.o.background = "dark"
vim.opt.clipboard = "unnamedplus"
vim.cmd("syntax on")

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Fonts and airline
vim.g.airline_powerline_fonts = 1
vim.opt.guifont = "DroidSansMono Nerd Font:h11"


-- Disable all notify messages for startup
vim.notify = function(msg, log_level, opts)
    if msg:match("lspconfig") then return end  -- ignore messages containing "lspconfig"
    vim.api.nvim_echo({{msg}}, true, {})
end
