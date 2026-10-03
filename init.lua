-- ~/.config/nvim/init.lua  (Neovim 0.12+)

-- =================== Settings ===================
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local o = vim.o
o.number = true
o.cursorline = true
o.smartindent = true
o.shiftwidth = 2
o.tabstop = 2
o.expandtab = false
o.termguicolors = true
o.background = "dark"
o.ignorecase = true
o.smartcase = true
o.clipboard = "unnamedplus"
o.updatetime = 300
o.completeopt = "menu,menuone,noselect,popup"

vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

-- C gets 4 spaces, like the Emacs setup
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.expandtab = true
  end,
})

-- =================== Plugins ===================
vim.pack.add({
  "https://github.com/ellisonleao/gruvbox.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",   -- default branch, no 0.1.x pin
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/christoomey/vim-tmux-navigator",
  "https://github.com/jiangmiao/auto-pairs",
})

-- Colorscheme
require("gruvbox").setup({
  contrast = "medium",
  styles = {
    comments = { italic = true },
    keywords = { italic = false },
    functions = { bold = false },
  },
})
vim.cmd.colorscheme("gruvbox")

-- Telescope (needs: brew install ripgrep fd)
require("telescope").setup({
  defaults = {
    layout_strategy = "horizontal",
    layout_config = { prompt_position = "bottom", height = 15, width = 0.99, preview_width = 0.6 },
    sorting_strategy = "ascending",
    file_ignore_patterns = { "node_modules", "%.git/" },
    preview = { treesitter = false },   -- avoids the treesitter previewer entirely
  },
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!.git" },
    },
  },
})

-- =================== Keymaps ===================
local map = vim.keymap.set
map("i", "jk", "<Esc>")
map("t", "<Esc>", "<C-\\><C-n>")

map("n", "<leader>ww", "<C-w>w")
map("n", "<leader>wo", "<cmd>only<CR>")
map("n", "<leader>wc", "<cmd>hide<CR>")
map("n", "<leader>bn", "<cmd>bn<CR>")
map("n", "<leader>bp", "<cmd>bp<CR>")
map("n", "<leader>bd", "<cmd>bd<CR>")
map("n", "<leader>e", "<cmd>Explore<CR>")
map("n", "<leader>m", "<cmd>make<CR>")   -- like M-x compile; :cn / :cp step through errors

map("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
map("n", "<leader>fb", function() require("telescope.builtin").buffers({ sort_mru = true }) end)
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>")

-- =================== LSP (built-in) ===================
-- Install the servers yourself: brew install llvm go rust-analyzer
vim.lsp.config("clangd", {
  cmd = { "clangd" },
  filetypes = { "c", "cpp" },
  root_markers = { "compile_commands.json", "compile_flags.txt", "Makefile", ".git" },
})
vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod" },
  root_markers = { "go.mod", ".git" },
  settings = { gopls = { gofumpt = true, staticcheck = true } },
})
vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
})
vim.lsp.enable({ "clangd", "gopls", "rust_analyzer" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local opts = { buffer = args.buf, silent = true }

    -- completion popup as you type: make every letter a trigger character
    if client and client:supports_method("textDocument/completion") then
      local chars = {}
      for c in ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_.>:"):gmatch(".") do
        table.insert(chars, c)
      end
      client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gD", vim.lsp.buf.declaration, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
    map("n", "gi", vim.lsp.buf.implementation, opts)
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "<leader>lr", vim.lsp.buf.rename, opts)
    map("n", "<leader>lc", vim.lsp.buf.code_action, opts)
    map("n", "<leader>ld", vim.diagnostic.setloclist, opts)
    map("n", "<leader>ldl", vim.diagnostic.open_float, opts)
  end,
})

-- Tab / Shift-Tab cycle the completion menu, Enter accepts the highlighted item
map("i", "<Tab>", function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>" end, { expr = true })
map("i", "<S-Tab>", function() return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>" end, { expr = true })

vim.diagnostic.config({ virtual_text = true, float = { border = "rounded", source = true } })
vim.lsp.inlay_hint.enable(true)
