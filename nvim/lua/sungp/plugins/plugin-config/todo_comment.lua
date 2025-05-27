return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy", -- Lazy load for performance
	config = function()
		local todo_comments = require("todo-comments")

		todo_comments.setup({
			signs = true, -- Show icons in the sign column
			sign_priority = 8,
			keywords = {
				FIX = {
					icon = " ",
					color = "error",
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
				},
				TODO = { icon = " ", color = "info" },
				HACK = { icon = " ", color = "warning" },
				WARN = {
					icon = " ",
					color = "warning",
					alt = { "WARNING", "XXX" },
				},
				PERF = {
					icon = " ",
					color = "default",
					alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
				},
				NOTE = {
					icon = " ",
					color = "hint",
					alt = { "INFO" },
				},
				TEST = {
					icon = "⏲ ",
					color = "test",
					alt = { "TESTING", "PASSED", "FAILED" },
				},
			},
			merge_keywords = true, -- Combine alt keywords into main ones
			gui_style = {
				fg = "NONE", -- No special fg style
				bg = "BOLD", -- Bold background
			},
			highlight = {
				multiline = true,
				multiline_pattern = "^.",
				multiline_context = 10,
				before = "", -- Text before keyword
				keyword = "wide", -- Keyword highlighting
				after = "fg", -- Highlight text after keyword
				pattern = [[.*<(KEYWORDS)\s*:]], -- Regex pattern to match keywords
				comments_only = true, -- Match only in comments
				max_line_len = 400,
				exclude = {}, -- Exclude filetypes
			},
			colors = {
				error = { "DiagnosticError", "#DC2626" },
				warning = { "DiagnosticWarn", "#FBBF24" },
				info = { "DiagnosticInfo", "#2563EB" },
				hint = { "DiagnosticHint", "#10B981" },
				default = { "Identifier", "#7C3AED" },
				test = { "Identifier", "#FF00FF" },
			},
			search = {
				command = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
				},
				pattern = [[\b(KEYWORDS):]], -- Match "KEYWORD:"
			},
		})

		-- Keymaps for navigation
		local map = vim.keymap.set
		map("n", "]t", todo_comments.jump_next, { desc = "Next todo comment" })
		map("n", "[t", todo_comments.jump_prev, { desc = "Previous todo comment" })

		-- Jump to next/prev WARNING or ERROR only
		map("n", "]e", function()
			todo_comments.jump_next({ keywords = { "ERROR", "WARNING" } })
		end, { desc = "Next error/warning todo comment" })

		map("n", "[e", function()
			todo_comments.jump_prev({ keywords = { "ERROR", "WARNING" } })
		end, { desc = "Previous error/warning todo comment" })
	end,
}
