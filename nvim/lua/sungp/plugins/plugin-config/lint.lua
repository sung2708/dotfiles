return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			-- Add mason bin path to environment PATH
			vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"

			-- Custom linter: golangci-lint
			lint.linters.golangci_lint = {
				cmd = "golangci-lint",
				stdin = false,
				args = { "run", "--out-format", "json" },
				stream = "stdout",
				ignore_exitcode = true,
				parser = function(output, bufnr)
					local results = {}
					local ok, decoded = pcall(vim.json.decode, output)
					if not ok or not decoded or not decoded.Issues then
						return results
					end

					for _, issue in ipairs(decoded.Issues) do
						table.insert(results, {
							lnum = issue.Pos.Line - 1,
							col = issue.Pos.Column - 1,
							end_lnum = issue.Pos.EndLine and issue.Pos.EndLine - 1 or nil,
							end_col = issue.Pos.EndColumn and issue.Pos.EndColumn - 1 or nil,
							message = issue.Text,
							source = "golangci-lint",
							severity = vim.diagnostic.severity.WARN,
						})
					end

					return results
				end,
			}

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

			-- Ruff config
			lint.linters.ruff = {
				cmd = vim.fn.stdpath("data") .. "/mason/bin/ruff",
				args = {
					"--quiet",
					"--stdin-filename",
					function()
						return vim.api.nvim_buf_get_name(0)
					end,
					"-",
				},
				stdin = true,
				ignore_exitcode = true,
				stream = "stderr",
				parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
					source = "ruff",
				}),
			}

			-- Register linters by filetype
			lint.linters_by_ft = {
				cpp = { "cpplint" },
				html = { "djlint" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				svelte = { "eslint_d" },
				go = { "golangci_lint" },
				python = { "ruff" },
				yaml = { "yamllint" },
			}

			-- Auto lint on key events
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})

			-- Manual trigger keymap
			vim.keymap.set("n", "<leader>l", function()
				lint.try_lint()
			end, { desc = "Trigger linting for current file" })
		end,
	},
}
