return {
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signs_staged = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signs_staged_enable = true,
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = false,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
				use_focus = true,
			},
			current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, lhs, rhs, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, lhs, rhs, opts)
				end

				-- Di chuyển giữa các hunks
				map("n", "]c", function()
					gs.nav_hunk("next")
				end, { desc = "Next Hunk" })
				map("n", "[c", function()
					gs.nav_hunk("prev")
				end, { desc = "Previous Hunk" })

				-- Thao tác với hunks
				map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
				map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
				map("v", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage Hunk (Visual)" })
				map("v", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset Hunk (Visual)" })
				map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage Buffer" })
				map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
				map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset Buffer" })

				map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Hunk" })

				map("n", "<leader>hb", function()
					gs.blame_line({ full = true })
				end, { desc = "Blame Line" })
				map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle Blame Line" })

				map("n", "<leader>hd", gs.diffthis, { desc = "Diff This" })
				map("n", "<leader>hD", function()
					gs.diffthis("~")
				end, { desc = "Diff This ~" })

				map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle Deleted" })
			end,
		})
	end,
}
