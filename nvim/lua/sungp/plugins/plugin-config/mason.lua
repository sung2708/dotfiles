-- Mason core UI configuration
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

			-- Ensure required LSP servers are installed
			mason_lspconfig.setup({
				ensure_installed = { "lua_ls", "clangd", "gopls", "pyright", "ts_ls" },
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
					"pylint",
					"eslint_d",
					"golangci-lint",
					"black",
					"isort",
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
