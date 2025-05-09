return {
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"folke/todo-comments.nvim",
		},
		opts = {
			auto_preview = false, -- Disable auto preview
			auto_fold = true, -- Automatically fold entries
			icons = {
				folder_closed = " ", -- Icon for closed folders
				folder_open = " ", -- Icon for open folders
				kinds = {
					Error = " ", -- Icon for errors
					Warning = " ", -- Icon for warnings
					Information = " ", -- Icon for information
					Hint = " ", -- Icon for hints
				},
			},
		},
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / References (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
}
