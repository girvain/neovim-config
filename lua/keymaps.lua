
-- ~/.config/nvim/lua/keymaps.lua
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Basic window management
vim.keymap.set('n', '<leader>w', '<C-w>w', opts)
vim.keymap.set('n', '<leader>wo', ':only<CR>', opts)
vim.keymap.set('n', '<leader>wc', ':hide<CR>', opts)

-- Buffer navigation
vim.keymap.set('n', '<leader>bn', ':bn<CR>', opts)
vim.keymap.set('n', '<leader>bp', ':bp<CR>', opts)
vim.keymap.set('n', '<leader>bd', ':bd<CR>', opts)

-- File explorer
vim.keymap.set('n', '<leader>e', ':Explore<CR>', opts)
vim.keymap.set('n', '<leader>t', ':NERDTreeToggle<CR>', opts)

-- FZF / Telescope
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts)
vim.keymap.set('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers({ sort_mru = true })<CR>", opts)
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)
vim.keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<CR>', opts)
vim.api.nvim_create_user_command('Notes', "lua require('telescope.builtin').find_files({ cwd='~/Dropbox' })", {})

-- Insert mode shortcut
vim.keymap.set('i', 'jk', '<ESC>', opts)

-- Terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)

