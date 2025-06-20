return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer",           -- buffer source
        "hrsh7th/cmp-path",             -- filesystem paths
        "saadparwaiz1/cmp_luasnip",     -- LuaSnip completion source
        "rafamadriz/friendly-snippets", -- ready-to-use snippets
        "onsails/lspkind.nvim",         -- vscode-like pictograms
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            build = "make install_jsregexp",
        },
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")
        local tailwindcss = require("tailwind-tools.cmp")

        -- Load friendly snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            completion = { completeopt = "menu,menuone,preview,noselect" },

            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
            }),

            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
            }),

            formatting = {
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                    ellipsis_char = "...",
                    before = tailwindcss.lspkind_format, -- Inject tailwindcss style before lspkind formatting
                    menu = {
                        buffer = "[Buffer]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[LuaSnip]",
                        path = "[Path]",
                    },
                }),
            },
            window = {
                documentation = {
                    border = "rounded", -- Use rounded borders for documentation window
                },
                completion = {
                    border = "rounded", -- Use rounded borders for completion window
                },
            },
        })
    end,
}
