return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},

	config = function()
		require("noice").setup({
			lsp = {
				progress = {
					enabled = true,
					format = "lsp_progress",
					format_done = "lsp_progress_done",
					throttle = 1000 / 30,
					view = "mini",
				},
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = false,
					["vim.lsp.util.stylize_markdown"] = false,
					["cmp.entry.get_documentation"] = false,
				},
				hover = {
					enabled = true,
					silent = false,
				},
				signature = {
					enabled = true,
					auto_open = {
						enabled = true,
						trigger = true,
						luasnip = true,
						throttle = 50,
					},
				},
				message = {
					enabled = true,
					view = "notify",
				},
				documentation = {
					view = "hover",
					opts = {
						lang = "markdown",
						replace = true,
						render = "plain",
						format = { "{message}" },
						win_options = {
							concealcursor = "n",
							conceallevel = 3,
							winblend = 10, -- Transparent hover documentation
						},
					},
				},
				code_action = {
					enabled = true,
					view = "popup",
					opts = {
						position = { row = 15, col = 0.5 },
						max_width = 50,
						max_height = 20,
					},
					format = {
						action = { pattern = "^:%s*CodeAction%s+", icon = "󰌾", lang = "vim" },
					},
				},
			},

			markdown = {
				hover = {
					["|(%S-)|"] = vim.cmd.help,
					["%[.-%]%((%S-)%)"] = require("noice.util").open,
				},
				highlights = {
					["|%S-|"] = "@text.reference",
					["@%S+"] = "@parameter",
					["^%s*(Parameters:)"] = "@text.title",
					["^%s*(Return:)"] = "@text.title",
					["^%s*(See also:)"] = "@text.title",
					["{%S-}"] = "@parameter",
				},
			},

			views = {
				popup = {
					border = {
						style = "rounded",
						padding = { 1, 2 },
					},
					win_options = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
						winblend = 10,
					},
				},
				cmdline_popup = {
					position = {
						row = 10,
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
					},
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
						winblend = 10,
					},
				},
				popupmenu = {
					relative = "editor",
					position = {
						row = 15,
						col = "50%",
					},
					size = {
						width = 60,
						height = 10,
					},
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
						winblend = 10,
					},
				},
				hover = {
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
						winblend = 10,
					},
				},
			},

			presets = {
				bottom_search = false,
				command_palette = false,
				long_message_to_split = false,
				inc_rename = false,
				lsp_doc_border = true,
			},

			health = { checker = true },
			throttle = 1000 / 30,
			routes = {},
			status = {},
			format = {},
		})

		-- Keymaps
		local map = vim.keymap.set
		local opts = { silent = true, noremap = true }

		map(
			"n",
			"<leader>nh",
			"<cmd>NoiceHistory<CR>",
			vim.tbl_extend("force", opts, { desc = "View message history" })
		)
		map("n", "<leader>nl", "<cmd>NoiceLast<CR>", vim.tbl_extend("force", opts, { desc = "View last message" }))
		map("n", "<leader>ne", "<cmd>NoiceErrors<CR>", vim.tbl_extend("force", opts, { desc = "View error messages" }))
		map("n", "<leader>na", "<cmd>NoiceAll<CR>", vim.tbl_extend("force", opts, { desc = "View all messages" }))

		-- Transparent background for floating windows
		vim.cmd([[
      highlight NormalFloat guibg=NONE
      highlight FloatBorder guibg=NONE
    ]])
	end,
}
