-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "help", "query", "typescript", "javascript", "html", "css", "clojure", "haskell", "rust" },
  sync_install = false,
  auto_install = false,
  highlight = { enable = true, additional_vim_regex_highlighting = false }
}

-- NERDTree
vim.g.NERDTreeWinSize = 50

-- Telescope
--require('telescope').setup{
--  defaults = {
--    file_ignore_patterns = {"node_modules", ".git/"}
--  }
--}

require('telescope').setup({
  defaults = {
    layout_strategy = "horizontal",
    layout_config = {
      -- Position the results at the bottom
      anchor = "S",          -- 'S' = south / bottom
      prompt_position = "bottom",
      height = 15,           -- fixed height in lines
      width = 0.99,           -- 90% of screen width
      preview_width = 0.6,
      -- optional: cutoff preview for small screens
      preview_cutoff = 1,
    },
    sorting_strategy = "ascending", -- newest at the bottom
		file_ignore_patterns = {"node_modules", ".git/", "target"},
  }
})

-- FZF
vim.cmd [[ set rtp+=/usr/local/opt/fzf ]]
vim.g.fzf_layout = { down = '30%' }

-- Colorscheme
require("gruvbox").setup({
  contrast = "medium",
  dim_inactive = false,
  styles = {
    comments = { italic = true },
    strings  = { italic = false },
    keywords = { italic = true },
    functions = { bold = true },
    variables = {},
  },
  transparent_mode = false,
})
vim.cmd("colorscheme gruvbox")

-- =================== LSP & Completion ===================

local lspconfig = require("lspconfig")


local on_attach = function(_, bufnr)
  local wk = require("which-key")

  -- Normal mappings (still needed!)
local opts = { buffer = bufnr, silent = true, noremap = true }

vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "<leader>lc", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<leader>ldl", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "<leader>ld", vim.diagnostic.setloclist, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

  -- Which-key descriptions
  --wk.register({
  --  g = {
  --    d = "Go to definition",
  --    D = "Go to declaration",
  --    r = "References",
  --    i = "Implementation",
  --  },
  --  ["K"] = "Hover documentation",
  --  ["[d"] = "Previous diagnostic",
  --  ["]d"] = "Next diagnostic",
  --}, opts)

  --wk.register({
  --  r = {
  --    n = "Rename symbol",
  --  },
  --  c = {
  --    a = "Code action",
  --  },
  --  e = "Line diagnostics",
  --}, {
  --  prefix = "<leader>",
  --  buffer = bufnr,
  --})

end

vim.o.updatetime = 300 -- cursor hold delay

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    -- protected call prevents other plugin errors from breaking diagnostics
    pcall(vim.diagnostic.open_float, nil, {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "always",
      prefix = " ",
    })
  end
})

-- Mason + LSP setup
require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = { "gopls" },
})

-- gopls setup
lspconfig.gopls.setup({
    on_attach = on_attach,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    settings = {
        gopls = {
            gofumpt = true,
            staticcheck = true,
        },
    },
})

-- Completion
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})


local cmp_nvim_lsp = require("cmp_nvim_lsp")
cmp_nvim_lsp.default_capabilities()

-- ========== Rust: rust-tools ==========
require("rust-tools").setup({
    tools = {
        inlay_hints = { auto = true }, -- optional
    },
    server = {
        on_attach = on_attach,
        capabilities = capabilities, },
})
