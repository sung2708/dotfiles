-- Formatter and Linter Configuration with null-ls
return {
	"jose-elias-alvarez/null-ls.nvim",

	event = "VeryLazy",

	config = function()
		local null_ls = require("null-ls")

		-- Autocmd group for formatting on save
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		null_ls.setup({
			sources = {
				-- Formatters
				null_ls.builtins.formatting.prettier, -- JavaScript/TypeScript/HTML/CSS
				null_ls.builtins.formatting.eslint_d, -- ESLint as formatter
				null_ls.builtins.formatting.clang_format, -- C/C++
				null_ls.builtins.formatting.golines, -- Go
				null_ls.builtins.formatting.stylua, -- Lua
				null_ls.builtins.formatting.black, -- Python
				null_ls.builtins.formatting.isort, -- Python import sorter

				-- Linters / Diagnostics
				null_ls.builtins.diagnostics.eslint_d.with({
					diagnostics_format = "[eslint] #{m} (#{c})",
					condition = function(utils)
						return utils.root_has_file({ ".eslintrc.js", "eslint.config.js", ".eslintrc.json" })
					end,
				}),
			},

			-- Format on save
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
}
