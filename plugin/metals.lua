return {
	{
		"scalameta/nvim-metals",
		ft = { "scala", "sbt", "java" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap", -- optional but recommended
		},
		config = function()
			local metals = require("metals")
			local lspconfig = require("lspconfig")

			local metals_config = metals.bare_config()

			metals_config.settings = {
				showImplicitArguments = true,
				showInferredType = true,
				excludedPackages = {},
			}

			metals_config.init_options.statusBarProvider = "on"

			metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

			metals_config.on_attach = function(client, bufnr)
				-- Setup LSP keymaps (optional)
				local nmap = function(keys, func, desc)
					if desc then
						desc = "LSP: " .. desc
					end
					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
				end
				nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				nmap("K", vim.lsp.buf.hover, "Hover Documentation")
				nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

				-- optionally start DAP here if using
				metals.setup_dap()
			end

			-- Autocmd to start Metals when entering Scala/sbt/java files
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "scala", "sbt", "java" },
				callback = function()
					metals.initialize_or_attach(metals_config)
				end,
			})
		end,
	},
}
