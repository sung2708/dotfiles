return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		"b0o/schemastore.nvim",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Diagnostic signs with new API (avoid deprecated warning)
		local signs = {
			Error = "",
			Warning = "",
			Hint = "󰌵",
			Information = "",
		}
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- LSP keymaps on attach
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
				keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover", unpack(opts) })
				keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename", unpack(opts) })
				keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", unpack(opts) })
			end,
		})

		-- Setup servers
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

		lspconfig.clangd.setup({
			capabilities = capabilities,
			cmd = { "clangd", "--background-index", "--header-insertion=never" },
		})

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

		lspconfig.ts_ls.setup({
			capabilities = capabilities,
			settings = {
				completions = {
					completeFunctionCalls = true,
				},
			},
		})

		lspconfig.jsonls.setup({
			capabilities = capabilities,
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		})

		lspconfig.tailwindcss.setup({
			capabilities = capabilities,
			filetypes = {
				"html",
				"css",
				"scss",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"ejs",
				"hbs",
			},
			settings = {
				tailwindCSS = {
					includeLanguages = {
						elixir = "html-eex",
						eelixir = "html-eex",
						heex = "html-eex",
					},
					experimental = {
						classRegex = {
							{ "tw`([^`]*)", "tw\\(([^)]*)", "cn\\(([^)]*)" }, -- support tailwind macro
						},
					},
				},
			},
		})
	end,
}
