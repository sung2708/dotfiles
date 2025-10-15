-- TODO:
-- HACK:
-- WARN:

return {
	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		priority = 1000,
		opts = {
			transparent = true,
		},
	},
	{
		"olivercederborg/poimandres.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			transparent_background = true,
		},
	},
	{
		"shaunsingh/moonlight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.moonlight_disable_background = true
		end,
	},
	{
		"rose-pine/neovim",
		lazy = false,
		priority = 1000,
		name = "rose-pine",
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nightfox").setup({
				options = {
					transparent = true,
				},
			})
		end,
	},
	{
		"navarasu/onedark.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("onedark").setup({
				style = "darker",
				transparent = true,
			})
			-- Enable theme
			require("onedark").load()
		end,
	},
}
