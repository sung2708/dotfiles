return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			-- Add mason bin path to environment PATH
			vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"

			-- Override eslint_d linter config
			lint.linters.eslint_d = {
				cmd = vim.fn.stdpath("data") .. "/mason/bin/eslint_d",
				args = {
					"--stdin",
					"--stdin-filename",
					function()
						return vim.api.nvim_buf_get_name(0)
					end,
					"-f",
					"json",
				},
				stdin = true,
				stream = "stdout",
				ignore_exitcode = true,
				parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
					source = "eslint_d",
				}),
			}

			lint.linters_by_ft = {
				cpp = { "cpplint" },
				html = { "djlint" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				svelte = { "eslint_d" },
				go = { "golangci-lint" },
				python = { "pylint" },
				yaml = { "yamllint" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>l", function()
				lint.try_lint()
			end, { desc = "Trigger linting for current file" })
		end,
	},
}
