return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local trouble = require("trouble.sources.telescope")
		local actions = require("telescope.actions")
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				layout_config = {
					horizontal = {
						preview_width = 0.7,
						width = 0.8,
						height = 0.7,
						prompt_position = "bottom",
					},
				},
				mappings = {
					i = {
						["<C-t>"] = trouble.open,
						["<C-k>"] = actions.move_selection_previous, -- ✅ fixed typo
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
					n = {
						["<C-t>"] = trouble.open,
					},
				},
			},
		})

		-- Key mappings for Telescope functionality
		local map = vim.keymap.set
		local opts = { silent = true, noremap = true }

		map(
			"n",
			"<leader>ff",
			":Telescope find_files<CR>",
			vim.tbl_extend("force", opts, { desc = "Telescope: Find Files" })
		)
		map(
			"n",
			"<leader>fg",
			":Telescope live_grep<CR>",
			vim.tbl_extend("force", opts, { desc = "Telescope: Live Grep" })
		)
		map(
			"n",
			"<leader>fc",
			":Telescope grep_string<CR>",
			vim.tbl_extend("force", opts, { desc = "Telescope: Find string in cwd" })
		) -- ✅ fixed
		map("n", "<leader>fb", ":Telescope buffers<CR>", vim.tbl_extend("force", opts, { desc = "Telescope: Buffers" }))
		map(
			"n",
			"<leader>fh",
			":Telescope help_tags<CR>",
			vim.tbl_extend("force", opts, { desc = "Telescope: Help Tags" })
		)
		map("n", "<leader>ft", ":TodoTelescope<CR>", vim.tbl_extend("force", opts, { desc = "Telescope: Find Todos" }))

		telescope.load_extension("fzf")
	end,
}
