return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local lint = require("lint")

		-- Force mason bin path (important)
		vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"

		-- Override eslint_d config
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

		-- Define linters to use for specific filetypes
		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			python = { "pylint" },
			golang = { "golangci-lint" },
			cpp = { "cpplint" },
		}

		-- Create an autocmd group for linting events
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		-- Trigger linting after file enters, after saving, or after leaving insert mode
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		-- Create a manual trigger for linting using <leader>l
		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
