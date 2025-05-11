return {
	"akinsho/toggleterm.nvim",
	version = "*",
	event = "VeryLazy",
	opts = {
		size = function(term)
			-- Adjust size based on terminal direction
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
			return 20 -- Default size for other directions
		end,
		open_mapping = [[<c-\>]], -- Main toggle key
		start_in_insert = true, -- Start in insert mode
		persist_size = true, -- Persist terminal size across sessions
		direction = "horizontal", -- Default direction ('vertical', 'horizontal', 'tab', 'float')
		close_on_exit = true, -- Close terminal when the process exits
		shell = vim.o.shell, -- Use the default shell
		float_opts = {
			border = "curved", -- Curved border for floating terminals
			width = 80, -- Width for floating terminal
			height = 20, -- Height for floating terminal
			winblend = 3, -- Transparency for floating terminal
		},
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)

		-- Key mappings for ToggleTerm
		vim.keymap.set(
			"n",
			"<leader>ta",
			":ToggleTermToggleAll<CR>",
			{ noremap = true, silent = true, desc = "Toggle all terminals" }
		)
		vim.keymap.set(
			"n",
			"<leader>th",
			":ToggleTerm direction=horizontal<CR>",
			{ noremap = true, silent = true, desc = "Open horizontal terminal" }
		)
		vim.keymap.set(
			"n",
			"<leader>tv",
			":ToggleTerm direction=vertical<CR>",
			{ noremap = true, silent = true, desc = "Open vertical terminal" }
		)
		vim.keymap.set(
			"n",
			"<leader>tf",
			":ToggleTerm direction=float<CR>",
			{ noremap = true, silent = true, desc = "Open floating terminal" }
		)
		vim.keymap.set(
			"n",
			"<leader>tt",
			":ToggleTerm direction=tab<CR>",
			{ noremap = true, silent = true, desc = "Open terminal in a new tab" }
		)
		vim.keymap.set(
			"n",
			"<leader>lg",
			":lua require('toggleterm.terminal').Terminal:new({ cmd = 'lazygit', hidden = true }):toggle()<CR>",
			{ noremap = true, silent = true, desc = "Open lazygit in a terminal" }
		)
		vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>c", { noremap = true, silent = true, desc = "Close terminal" })
	end,
}
