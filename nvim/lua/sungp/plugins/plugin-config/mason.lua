return {
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
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
            if not status_ok then
                vim.notify("Failed to load mason-lspconfig", vim.log.levels.ERROR)
                return
            end

            mason_lspconfig.setup({
                ensure_installed = { "lua_ls", "clangd", "gopls", "pyright" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason-lspconfig.nvim" },
    },
}

