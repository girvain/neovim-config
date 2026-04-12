-- =================== Treesitter ===================

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "c", "lua", "vim", "help", "query",
    "typescript", "javascript", "html", "css",
    "clojure", "haskell", "rust"
  },
  sync_install = false,
  auto_install = false,
  highlight = { enable = true, additional_vim_regex_highlighting = false }
}

-- =================== Telescope ===================

require('telescope').setup({
  defaults = {
    layout_strategy = "horizontal",
    layout_config = {
      anchor = "S",
      prompt_position = "bottom",
      height = 15,
      width = 0.99,
      preview_width = 0.6,
      preview_cutoff = 1,
    },
    sorting_strategy = "ascending",
    file_ignore_patterns = {"node_modules", ".git/", "target"},
  }
})

-- =================== FZF ===================

vim.cmd [[ set rtp+=/usr/local/opt/fzf ]]
vim.g.fzf_layout = { down = '30%' }

-- =================== Colorscheme ===================

require("gruvbox").setup({
  contrast = "medium",
  dim_inactive = false,
  styles = {
    comments = { italic = true },
    strings  = { italic = false },
    keywords = { italic = true },
    functions = { bold = true },
  },
  transparent_mode = false,
})

vim.cmd("colorscheme gruvbox")

-- =================== LSP & Completion ===================

local lspconfig = require("lspconfig")

-- Capabilities (for nvim-cmp)
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

-- ONE on_attach for all servers
local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr, silent = true, noremap = true }

  -- Navigation
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

  -- Actions
  vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>lc", vim.lsp.buf.code_action, opts)

  -- Diagnostics
  vim.keymap.set("n", "<leader>ldl", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "<leader>ld", vim.diagnostic.setloclist, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
end

-- Diagnostics popup on hover
vim.o.updatetime = 300

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    pcall(vim.diagnostic.open_float, nil, {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "always",
      prefix = " ",
    })
  end
})

-- =================== Mason ===================

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = { "gopls", "rust_analyzer" },
  automatic_installation = false,
  automatic_setup = false,
  automatic_enable = false,
  handlers = nil,
})

-- =================== LSP Servers ===================

-- Go
lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
    },
  },
})

-- Rust
lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Enable inlay hints (replaces rust-tools)
vim.lsp.inlay_hint.enable(true)

-- =================== Completion ===================

local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
})
