return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Diagnostic signs
		for type, icon in pairs({
			Error = "",
			Warning = "",
			Hint = "󰌵",
			Information = "",
		}) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- LSP keymaps
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { noremap = true, silent = true, buffer = ev.buf }
				local keymap = vim.keymap.set
				keymap("n", "gR", "<cmd>Telescope lsp_references<CR>", { desc = "LSP references", unpack(opts) })
				keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "LSP definitions", unpack(opts) })
				keymap(
					"n",
					"gi",
					"<cmd>Telescope lsp_implementations<CR>",
					{ desc = "LSP implementations", unpack(opts) }
				)
				keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Hover", unpack(opts) })
				keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename", unpack(opts) })
				keymap(
					"n",
					"<leader>ca",
					"<cmd>lua vim.lsp.buf.code_action()<CR>",
					{ desc = "Code Action", unpack(opts) }
				)
			end,
		})

		-- LSP setup
		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,

			["clangd"] = function()
				lspconfig.clangd.setup({
					capabilities = capabilities,
					cmd = { "clangd", "--background-index", "--header-insertion=never" },
				})
			end,

			["lua_ls"] = function()
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							telemetry = { enable = false },
						},
					},
				})
			end,

			["pyright"] = function()
				lspconfig.pyright.setup({
					capabilities = capabilities,
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "strict",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
							},
						},
					},
				})
			end,

			["ts_ls"] = function()
				lspconfig.ts_ls.setup({
					capabilities = capabilities,
					settings = {
						completions = {
							completeFunctionCalls = true,
						},
					},
				})
			end,

			["jsonls"] = function()
				lspconfig.jsonls.setup({
					capabilities = capabilities,
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
				})
			end,

			["tailwindcss"] = function()
				local default_config = require("lspconfig.server_configurations.tailwindcss").default_config

				local filetypes = vim.tbl_filter(function(ft)
					return ft ~= "markdown" -- exclude markdown
				end, default_config.filetypes)

				-- Add additional filetypes if needed
				vim.list_extend(filetypes, { "ejs", "hbs" })

				lspconfig.tailwindcss.setup({
					capabilities = capabilities,
					filetypes = filetypes,
					settings = {
						tailwindCSS = {
							includeLanguages = {
								elixir = "html-eex",
								eelixir = "html-eex",
								heex = "html-eex",
							},
						},
					},
				})
			end,
		})
	end,
}
