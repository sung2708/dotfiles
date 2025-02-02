return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate', -- Run :TSUpdate after installation
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        -- Configure nvim-treesitter
        require('nvim-treesitter.configs').setup({
            -- Parsers to install
            ensure_installed = {
                "python", "javascript", "typescript", "html", "css",
                "java", "go", "c", "cpp"
            },

            -- Enable syntax highlighting
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },

            -- Configure indentation
            indent = {
                enable = true,
                disable = { "python" },
            },

            -- Text objects for better navigation and selection
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer", -- Select around the function
                        ["if"] = "@function.inner", -- Select inside the function
                        ["ac"] = "@class.outer",    -- Select around the class
                        ["ic"] = "@class.inner",    -- Select inside the class
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]f"] = "@function.outer", -- Go to next function start
                        ["]c"] = "@class.outer",    -- Go to next class start
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer", -- Go to previous function start
                        ["[c"] = "@class.outer",    -- Go to previous class start
                    },
                },
            },

            -- Configure incremental selection
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",      -- Start selection
                    node_incremental = "<TAB>",   -- Expand selection
                    node_decremental = "<S-TAB>", -- Shrink selection
                },
            },
            
            -- Configure autotag plugin
            autotag = {
                enable = true,
            },
        })
    end,
}
