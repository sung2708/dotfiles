return {
	"onsails/lspkind.nvim",
	event = "InsertEnter",
	config = function()
		require("lspkind").init({
			mode = "symbol", -- show only symbol annotations
			maxwidth = {
				menu = 50, -- leading text (labelDetails)
				abbr = 50, -- actual suggestion item
			},
			ellipsis_char = "...", -- when popup menu exceed maxwidth
			show_labelDetails = true, -- show labelDetails in menu
			before = function(entry, vim_item)
				-- Customize the display before lspkind does any modification
				return vim_item
			end,
		})

		local lspkind = require("lspkind")
		require("cmp").setup({
			formatting = {
				format = lspkind.cmp_format(),
			},
		})
	end,
}
