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

        -- Autocommands for LSP key mappings
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local opts = { noremap = true, silent = true, buffer = ev.buf }
                vim.keymap.set("n", "gR", ":Telescope lsp_references<CR>", { desc = "Show LSP references", unpack(opts) })
                vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>", { desc = "Show LSP definition", unpack(opts) })
                vim.keymap.set("n", "gi", ":Telescope lsp_implementations<CR>", { desc = "Show LSP implementations", unpack(opts) })
                vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Show LSP hover", unpack(opts) })
                vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbol", unpack(opts) })
                vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code action", unpack(opts) })
            end,
        })

        -- Set up LSP capabilities
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Diagnostic signs
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

        -- Mason LSP handlers
        mason_lspconfig.setup_handlers({
            -- Default handler for servers with no specific configuration
            function(server)
                lspconfig[server].setup({
                    capabilities = capabilities,
                })
            end,

            -- clangd specific configuration
            ["clangd"] = function()
                lspconfig.clangd.setup({
                    capabilities = capabilities,
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--header-insertion=never",
                    },
                    format = {
                        enable = true,
                    },
                })
            end,

            -- lua_ls specific configuration
            ["lua_ls"] = function()
                lspconfig.lua_ls.setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            runtime = {
                                version = "LuaJIT",
                            },
                            diagnostics = {
                                globals = { "vim" },
                            },
                            workspace = {
                                library = vim.api.nvim_get_runtime_file("", true),
                                checkThirdParty = false,
                            },
                            telemetry = {
                                enable = false,
                            },
                        },
                    },
                })
            end,

            -- pyright specific configuration
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

            -- typescript-language-server (ts_ls) specific configuration
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

            -- jsonls specific configuration
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
        })
    end,
}

