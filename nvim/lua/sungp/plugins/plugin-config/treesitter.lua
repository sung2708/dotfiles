return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"python",
					"javascript",
					"typescript",
					"tsx",
					"html",
					"css",
					"json",
					"yaml",
					"lua",
					"bash",
					"c",
					"cpp",
					"java",
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
					disable = { "python" },
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>",
						node_incremental = "<TAB>",
						node_decremental = "<S-TAB>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							-- Function / Class
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							-- Custom: Select If / For / While
							["ai"] = "@conditional.outer",
							["ii"] = "@conditional.inner",
							["al"] = "@loop.outer",
							["il"] = "@loop.inner",
							["acm"] = "@comment.outer",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
							["]i"] = "@conditional.outer",
							["]l"] = "@loop.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
							["[i"] = "@conditional.outer",
							["[l"] = "@loop.outer",
						},
					},
				},
			})
		end,
	},
}
