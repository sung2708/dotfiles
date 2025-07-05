return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim",                   opts = {} },
        "b0o/schemastore.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        -- LSP capabilities for completion
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Enable border for all LSP floating windows
        local border = "rounded"
        local lsp_handlers = vim.lsp.handlers
        lsp_handlers["textDocument/hover"] = vim.lsp.with(lsp_handlers.hover, { border = border })
        lsp_handlers["textDocument/signatureHelp"] = vim.lsp.with(lsp_handlers.signature_help, { border = border })
        vim.diagnostic.config({
            float = { border = border },
        })
        require("lspconfig.ui.windows").default_options.border = border

        -- Diagnostic signs (gutter icons)
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

        -- LSP keybindings
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
                vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover", noremap = true, silent = true })
                vim.keymap.set(
                    "n",
                    "<leader>rn",
                    vim.lsp.buf.rename,
                    { desc = "Rename", noremap = true, silent = true }
                )
                vim.keymap.set({ "n", "x" }, "<leader>ca", function()
                    require("tiny-code-action").code_action()
                end, { desc = "Code Action", noremap = true, silent = true })
            end,
        })

        -- Lua (Neovim config)
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

        -- C/C++
        lspconfig.clangd.setup({
            capabilities = capabilities,
            cmd = { "clangd", "--background-index", "--header-insertion=never" },
        })

        -- Python
        lspconfig.pyright.setup({
            capabilities = capabilities,
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "openFilesOnly",
                        extraPaths = { "./apps", "./src" },
                    },
                },
            },
        })

        -- TypeScript / JavaScript
        lspconfig.ts_ls.setup({
            capabilities = capabilities,
            settings = {
                completions = {
                    completeFunctionCalls = true,
                },
            },
        })

        -- JSON
        lspconfig.jsonls.setup({
            capabilities = capabilities,
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                },
            },
        })

        -- Tailwind CSS
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
                            { "tw`([^`]*)", "tw\\(([^)]*)", "cn\\(([^)]*)" },
                        },
                    },
                },
            },
        })
    end,
}
