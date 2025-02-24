return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
        -- Enable or disable indent-blankline
        enabled = true,

        -- Debounce time for refreshes in milliseconds
        debounce = 100,

        -- Configure viewport to determine indentation guides
        viewport_buffer = { min = 50 },

        -- Whitespace configuration
        whitespace = {
            highlight = "Whitespace",
            remove_blankline_trail = true,
        },

        -- Scope configuration
        scope = {
            enabled = true,
            char = "|",
            show_start = true,
            show_end = false,
            injected_languages = true,
            highlight = { "Function", "Label" },
            priority = 500,
        },

        -- Exclusion configuration for filetypes and buftypes
        exclude = {
            filetypes = { "lspinfo", "packer", "help", "man", "dashboard" },
            buftypes = { "terminal", "nofile" },
        },

        -- Indentation configuration
        indent = {
            char = "|",
            tab_char = "|",
            highlight = "IndentBlanklineChar",
            smart_indent_cap = true,
            priority = 1,
        },
    },
    config = function(_, opts)
        local current_ft = vim.bo.filetype
        if vim.tbl_contains(opts.exclude.filetypes, current_ft) or vim.tbl_contains(opts.exclude.buftypes, vim.bo.buftype) then
            return
        end

        -- Highlighting configuration for indentation guides and blank lines
        vim.cmd([[
            highlight default IndentBlanklineChar guifg=#2a2e36 gui=nocombine
            highlight default IndentBlanklineSpaceChar guifg=#2a2e36 gui=nocombine
            highlight default IndentBlanklineSpaceCharBlankline guifg=#2a2e36 gui=nocombine
            highlight default IndentBlanklineContextChar guifg=#3e4452 gui=nocombine
            highlight default IndentBlanklineContextStart guibg=#3e4452 gui=underline
            highlight default IndentBlanklineContextEnd guibg=#3e4452 gui=underline
        ]])

        require("ibl").setup(opts)
    end,
}
