-- Linting Configuration with nvim-lint
return {
	"mfussenegger/nvim-lint", -- Plugin for linting files
	opts = {
		-- other config
		linters = {
			eslint_d = {
				args = {
					"--no-warn-ignored", -- <-- this is the key argument
					"--format",
					"json",
					"--stdin",
					"--stdin-filename",
					function()
						return vim.api.nvim_buf_get_name(0)
					end,
				},
			},
		},
	},

	-- Specify when to trigger the linting process (on file read and new file)
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local lint = require("lint")

		-- Define linters to use for specific filetypes
		-- Associating linters with filetypes
		lint.linters_by_ft = {
			javascript = { "eslint_d" }, -- ESLint for JavaScript
			typescript = { "eslint_d" }, -- ESLint for TypeScript
			javascriptreact = { "eslint_d" }, -- ESLint for JavaScript React
			typescriptreact = { "eslint_d" }, -- ESLint for TypeScript React
			svelte = { "eslint_d" }, -- ESLint for Svelte
			python = { "pylint" }, -- Pylint for Python
			golang = { "golangci-lint" }, -- GolangCI-Lint for Go
			cpp = { "cpplint" }, -- cpplint for C++
		}

		-- Create an autocmd group for linting events
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		-- Trigger linting after file enters, after saving, or after leaving insert mode
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				-- Trigger linting action
				lint.try_lint()
			end,
		})

		-- Create a manual trigger for linting using <leader>l
		vim.keymap.set("n", "<leader>l", function()
			-- Manually trigger linting for the current file
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
