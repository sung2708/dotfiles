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
        -- Ensure `opts` is available and valid
        opts = opts or {}

        local current_ft = vim.bo.filetype
        local current_buftype = vim.bo.buftype

        -- Exclude the filetypes and buftypes as per configuration
        if vim.tbl_contains(opts.exclude.filetypes or {}, current_ft) or
           vim.tbl_contains(opts.exclude.buftypes or {}, current_buftype) then
            return
        end

        -- Initialize the plugin with the options
        local ibl = require("ibl")
        if ibl then
            -- Only after loading the plugin, we can setup the highlight groups
            vim.cmd([[
                highlight default link IndentBlanklineChar Whitespace
                highlight default link IndentBlanklineSpaceChar Whitespace
                highlight default link IndentBlanklineSpaceCharBlankline Whitespace
                highlight default link IndentBlanklineContextChar Function
                highlight default link IndentBlanklineContextStart Function
                highlight default link IndentBlanklineContextEnd Function
            ]])

            ibl.setup(opts)
        else
            print("Error: Failed to load 'ibl'.")
        end
    end,
}

