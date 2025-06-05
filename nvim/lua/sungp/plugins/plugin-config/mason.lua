return {
	-- Mason core UI configuration
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "",
						package_uninstalled = "✗",
					},
					border = "rounded", -- Use rounded borders for the Mason UI
				},
			})
		end,
	},

	-- Mason-LSPConfig for automatic installation of LSP servers
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local mason_lspconfig = require("mason-lspconfig")

			mason_lspconfig.setup({
				ensure_installed = { "lua_ls", "clangd", "gopls", "pyright", "ts_ls", "golangci-lint" },
				automatic_installation = false,
			})
		end,
	},

	-- Mason Tool Installer for managing formatters and linters
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"prettier",
					"stylua",
					"eslint_d",
					"black",
					"isort",
					"golangci-lint",
				},
			})
		end,
	},

	-- Native LSP configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
	},
}
