return {
	{
		"nvimtools/none-ls.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			local null_ls = require("null-ls")

			local eslint_d_fmt = require("none-ls.formatting.eslint_d")
			local eslint_diag = require("none-ls.diagnostics.eslint")

			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			null_ls.setup({
				sources = {
					-- Formatters
					null_ls.builtins.formatting.prettier, -- JS, TS, HTML, CSS
					eslint_d_fmt, -- ESLint_d
					null_ls.builtins.formatting.clang_format, -- C/C++
					null_ls.builtins.formatting.golines, -- Go
					null_ls.builtins.formatting.stylua, -- Lua
					null_ls.builtins.formatting.black, -- Python
					null_ls.builtins.formatting.isort, -- Python import sorter

					-- Linters
					eslint_diag.with({
						diagnostics_format = "[eslint] #{m} (#{c})",
						condition = function(utils)
							return utils.root_has_file({
								".eslintrc.js",
								"eslint.config.js",
								".eslintrc.json",
							})
						end,
					}),
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end,
			})
		end,
	},
}
