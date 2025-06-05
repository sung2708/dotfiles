return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},

	config = function()
		require("noice").setup({
			cmdline = {
				enabled = true,
				view = "cmdline_popup",
				opts = {
					position = { row = 10, col = 0.5 },
				},
				format = {
					cmdline = { pattern = "^:", icon = ">", lang = "vim" },
					search_down = { kind = "search", pattern = "^/", icon = "↓", lang = "regex" },
					search_up = { kind = "search", pattern = "^%?", icon = "↑", lang = "regex" },
					filter = { pattern = "^:%s*!", icon = "!", lang = "bash" },
					lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
					help = { pattern = "^:%s*he?l?p?%s+", icon = "?", lang = "help" },
					input = { view = "cmdline_input", icon = "" },
				},
			},

			messages = {
				enabled = true,
				view = "notify",
				view_error = "notify",
				view_warn = "notify",
				view_history = "messages",
				view_search = "virtualtext",
			},

			popupmenu = {
				enabled = true,
				backend = "nui",
				kind_icons = {
					Text = "󱩼 ",
					Method = " ",
					Function = "",
					Constructor = "󰡢",
					Field = "󰌪",
					Variable = "",
					Class = "󱉟 ",
					Interface = " ",
					Module = "󰕳",
					Property = "󰧰",
					Unit = "⚙️",
					Value = "󰼜",
					Enum = "",
					Keyword = "",
					Snippet = "✂️",
					Color = "",
					File = "",
					Reference = "",
					Folder = "",
					EnumMember = "",
					Constant = "󰌾",
					Struct = "",
					Event = "󰸰",
					Operator = "",
					TypeParameter = "󰉺",
				},
			},

			redirect = {
				view = "popup",
				filter = { event = "msg_show" },
			},

			notify = {
				enabled = true,
				view = "notify",
			},

			commands = {
				history = {
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {
						any = {
							{ event = "notify" },
							{ error = true },
							{ warning = true },
							{ event = "msg_show", kind = { "" } },
							{ event = "lsp", kind = "message" },
						},
					},
				},
				last = {
					view = "popup",
					opts = { enter = true, format = "details" },
					filter = {
						any = {
							{ event = "notify" },
							{ error = true },
							{ warning = true },
							{ event = "msg_show", kind = { "" } },
							{ event = "lsp", kind = "message" },
						},
					},
					filter_opts = { count = 1 },
				},
				errors = {
					view = "popup",
					opts = { enter = true, format = "details" },
					filter = { error = true },
					filter_opts = { reverse = true },
				},
				all = {
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			},

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
					},
				},
				hover = {
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
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
	end,
}
