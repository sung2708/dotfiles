return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
	},

	config = function()
		-- Load Telescope
		local telescope_ok, telescope = pcall(require, "telescope")
		if not telescope_ok then
			return
		end

		-- Load actions for Telescope
		local actions = require("telescope.actions")

		-- Check if Trouble plugin is available
		local trouble_ok, trouble = pcall(require, "trouble.sources.telescope")

		-- Setup Telescope with your configuration
		telescope.setup({
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				path_display = { "smart" },

				layout_config = {
					horizontal = {
						preview_width = 0.7,
						width = 0.8,
						height = 0.7,
						prompt_position = "bottom",
					},
				},

				-- Keymaps for telescope actions
				mappings = {
					i = {
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-c>"] = actions.close,
						["<C-t>"] = trouble_ok and trouble.open or nil, -- Only bind trouble if available
						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,
						["<Tab>"] = actions.toggle_selection, -- Fixed invalid combination
						["<S-Tab>"] = actions.move_selection_previous, -- No need for `toggle_selection`
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-_>"] = actions.which_key,
					},
					n = {
						["<esc>"] = actions.close,
						["<C-t>"] = trouble_ok and trouble.open or nil, -- Only bind trouble if available
						["<Tab>"] = actions.toggle_selection, -- Fixed invalid combination
						["<S-Tab>"] = actions.move_selection_previous, -- No need for `toggle_selection`
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["?"] = actions.which_key,
					},
				},
			},

			-- Extensions
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				file_browser = {
					hijack_netrw = true,
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		-- Load extensions explicitly
		telescope.load_extension("fzf")
		telescope.load_extension("file_browser")
		telescope.load_extension("ui-select")

		-- Define Keymaps
		local map = vim.keymap.set
		local opts = { silent = true, noremap = true }

		-- Telescope Keybindings
		map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
		map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
		map("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", opts)
		map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
		map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
		map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", opts)
		map("n", "<leader>fe", "<cmd>Telescope file_browser<cr>", opts)
	end,
}
