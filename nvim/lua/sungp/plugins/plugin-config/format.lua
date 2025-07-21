return {
    {
        "nvimtools/none-ls.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvimtools/none-ls-extras.nvim",
        },
        config = function()
            local null_ls = require("null-ls")
            local helpers = require("null-ls.helpers")

            local eslint_d_fmt = require("none-ls.formatting.eslint_d")

            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            -- Custom XML formatter
            local xml_formatter = {
                method = null_ls.methods.FORMATTING,
                filetypes = { "xml" },
                generator = helpers.formatter_factory({
                    command = "xmlstarlet",
                    args = { "fo" },
                    to_stdin = true,
                }),
            }

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettier,
                    eslint_d_fmt,
                    null_ls.builtins.formatting.clang_format,
                    null_ls.builtins.formatting.golines,
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.isort,
                    xml_formatter,
                },
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({
                                    bufnr = bufnr,
                                    filter = function(c)
                                        return c.name == "null-ls"
                                    end,
                                })
                            end,
                        })
                    end
                end,
            })
        end,
    },
}
