local utils = require("helper.utils")
local defer_after_vimenter = utils.defer_plugin_after_vimenter
local defer_on_filetype = utils.defer_plugin_on_filetype

return {
    {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename",
        opts = {},
    },
    {
        "monaqa/dial.nvim",
        keys = {
            {
                "<C-a>",
                function()
                    return require("dial.map").inc_normal()
                end,
                expr = true,
                desc = "Edit: Increment",
            },
            {
                "<C-x>",
                function()
                    return require("dial.map").dec_normal()
                end,
                expr = true,
                desc = "Edit: Decrement",
            },
            {
                "g<C-a>",
                function()
                    return require("dial.map").inc_gnormal()
                end,
                expr = true,
                desc = "Edit: Increment Sequence",
            },
            {
                "g<C-x>",
                function()
                    return require("dial.map").dec_gnormal()
                end,
                expr = true,
                desc = "Edit: Decrement Sequence",
            },
            {
                "<C-a>",
                function()
                    return require("dial.map").inc_visual()
                end,
                mode = "x",
                expr = true,
                desc = "Edit: Increment Selection",
            },
            {
                "<C-x>",
                function()
                    return require("dial.map").dec_visual()
                end,
                mode = "x",
                expr = true,
                desc = "Edit: Decrement Selection",
            },
            {
                "g<C-a>",
                function()
                    return require("dial.map").inc_gvisual()
                end,
                mode = "x",
                expr = true,
                desc = "Edit: Increment Selection Sequence",
            },
            {
                "g<C-x>",
                function()
                    return require("dial.map").dec_gvisual()
                end,
                mode = "x",
                expr = true,
                desc = "Edit: Decrement Selection Sequence",
            },
        },
        config = function()
            local augend = require("dial.augend")

            require("dial.config").augends:register_group({
                default = {
                    augend.integer.alias.decimal_int,
                    augend.integer.alias.hex,
                    augend.date.alias["%Y/%m/%d"],
                    augend.date.alias["%Y-%m-%d"],
                    augend.constant.alias.bool,
                    augend.constant.alias.Bool,
                    augend.constant.new({
                        elements = { "and", "or" },
                        word = true,
                        cyclic = true,
                    }),
                    augend.constant.new({
                        elements = { "&&", "||" },
                        word = false,
                        cyclic = true,
                    }),
                    augend.constant.new({
                        elements = { "[ ]", "[x]" },
                        word = false,
                        cyclic = true,
                    }),
                    augend.semver.alias.semver,
                },
            })
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        keys = {
            -- <C-t> (tag/LSP jump back) and <C-f> (page down) stay built-in.
            { "<C-n>", "<cmd>Neotree filesystem reveal left<cr>", desc = "Explorer: Reveal File" },
            { "<leader>E", "<cmd>Neotree toggle<cr>", desc = "Explorer: Toggle" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("integrations.neotree")
        end,
    },
    {
        "stevearc/oil.nvim",
        cmd = "Oil",
        keys = {
            { "-", "<cmd>Oil<cr>", desc = "Files: Open Parent Directory" },
            { "<leader>fo", "<cmd>Oil --float<cr>", desc = "Find: Oil File Browser" },
        },
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            default_file_explorer = false,
            delete_to_trash = true,
            float = {
                border = "rounded",
                max_width = 0.9,
                max_height = 0.9,
            },
            view_options = {
                show_hidden = true,
            },
        },
    },
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: Workspace Diagnostics" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble: Buffer Diagnostics" },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Trouble: Symbols" },
            { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "Trouble: LSP" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble: Location List" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble: Quickfix List" },
        },
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("integrations.trouble")
        end,
    },
    {
        "stevearc/quicker.nvim",
        -- Quickfix lists are uncommon during startup. Loading on their
        -- filetype keeps the normal editor path unchanged.
        ft = "qf",
        keys = {
            {
                "<leader>qf",
                function()
                    require("quicker").toggle({ focus = false })
                end,
                desc = "Quickfix: Toggle",
            },
            {
                "<leader>qF",
                function()
                    require("quicker").toggle({ focus = true })
                end,
                desc = "Quickfix: Focus",
            },
        },
        opts = {
            edit = {
                enabled = true,
                -- Write only source buffers that were already unmodified;
                -- quickfix edits never silently overwrite user changes.
                autosave = "unmodified",
            },
            constrain_cursor = true,
            follow = { enabled = false },
            highlight = {
                treesitter = true,
                lsp = true,
                -- Avoid loading every referenced file just to paint the list.
                load_buffers = false,
            },
            keys = {
                {
                    ">",
                    function()
                        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
                    end,
                    desc = "Quickfix: Expand Context",
                },
                {
                    "<",
                    function()
                        require("quicker").collapse()
                    end,
                    desc = "Quickfix: Collapse Context",
                },
            },
        },
    },
    {
        "folke/flash.nvim",
        keys = {
            {
                "s",
                function()
                    require("flash").jump()
                end,
                mode = { "n", "x", "o" },
                desc = "Flash: Jump",
            },
            {
                "S",
                function()
                    require("flash").treesitter()
                end,
                mode = { "n", "o" },
                desc = "Flash: Treesitter",
            },
            {
                "<leader>mS",
                function()
                    require("flash").treesitter()
                end,
                mode = "x",
                desc = "Flash: Treesitter",
            },
        },
        config = function()
            require("integrations.flash")
        end,
    },
    {
        "folke/todo-comments.nvim",
        lazy = true,
        init = not vim.g.sungp_low_spec and defer_after_vimenter("todo-comments.nvim", 420) or nil,
        cmd = { "TodoTrouble", "TodoFzfLua", "TodoQuickFix", "TodoLocList" },
        keys = {
            { "]t", desc = "Todo: Next" },
            { "[t", desc = "Todo: Previous" },
            { "<leader>xt", desc = "Todo: Trouble" },
            { "<leader>xf", desc = "Todo: FzfLua" },
            { "<leader>xq", desc = "Todo: Quickfix" },
            { "<leader>xl", desc = "Todo: Location List" },
            { "<leader>xF", desc = "Todo/Fix: FzfLua" },
            { "<leader>xR", desc = "Todo/Fix: Trouble" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("integrations.todo")
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true,
            disable_filetype = { "snacks_picker_input" },
            fast_wrap = {},
        },
    },
    {
        "gbprod/yanky.nvim",
        keys = {
            { "<leader>fy", "<cmd>YankyRingHistory<cr>", mode = { "n", "x" }, desc = "Find: Yank History" },
            { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank: Text" },
            { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Yank: Put After" },
            { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Yank: Put Before" },
            { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Yank: Put After and Move" },
            { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Yank: Put Before and Move" },
            { "[y", "<Plug>(YankyPreviousEntry)", desc = "Yank: Previous History Entry" },
            { "]y", "<Plug>(YankyNextEntry)", desc = "Yank: Next History Entry" },
        },
        opts = {
            ring = {
                history_length = 100,
                storage = "shada",
            },
            highlight = {
                on_put = true,
                on_yank = true,
                timer = 300,
            },
            preserve_cursor_position = {
                enabled = true,
            },
        },
    },
    {
        "kevinhwang91/nvim-ufo",
        lazy = true,
        keys = {
            {
                "zR",
                function()
                    require("ufo").openAllFolds()
                end,
                desc = "Folds: Open All",
            },
            {
                "zM",
                function()
                    require("ufo").closeAllFolds()
                end,
                desc = "Folds: Close All",
            },
            {
                "zr",
                function()
                    require("ufo").openFoldsExceptKinds()
                end,
                desc = "Folds: Open Except Kinds",
            },
            {
                "zm",
                function()
                    require("ufo").closeFoldsWith()
                end,
                desc = "Folds: Close One Level",
            },
            {
                "zK",
                function()
                    local winid = require("ufo").peekFoldedLinesUnderCursor()
                    if not winid then
                        vim.lsp.buf.hover()
                    end
                end,
                desc = "Folds: Peek or Hover",
            },
        },
        dependencies = {
            "kevinhwang91/promise-async",
        },
        init = function()
            if not vim.g.sungp_low_spec then
                defer_after_vimenter("nvim-ufo", 280)()
            end
            vim.opt.foldcolumn = "1"
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
            vim.opt.foldenable = true
        end,
        opts = {
            provider_selector = function(bufnr, _, buftype)
                if buftype ~= "" or vim.b[bufnr].bigfile or vim.api.nvim_buf_line_count(bufnr) > 10000 then
                    return ""
                end
                return { "treesitter", "indent" }
            end,
        },
    },
    {
        "nvim-mini/mini.nvim",
        event = "VeryLazy",
        config = function()
            require("mini.ai").setup({
                n_lines = 100,
                mappings = {
                    -- Preserve Neovim 0.12's built-in `an`/`in` syntax-node
                    -- selections instead of shadowing them.
                    around_next = "aN",
                    inside_next = "iN",
                },
            })
            require("mini.splitjoin").setup()
            -- Single owner for moving lines/selections (was duplicated by
            -- :move mappings in config.keymaps).
            require("mini.move").setup({
                mappings = {
                    left = "<leader>mh",
                    right = "<leader>ml",
                    down = "<leader>j",
                    up = "<leader>k",
                    line_left = "<leader>mh",
                    line_right = "<leader>ml",
                    line_down = "<leader>j",
                    line_up = "<leader>k",
                },
            })
            require("mini.bracketed").setup({
                buffer = { suffix = "" },
                comment = { suffix = "" },
                diagnostic = { suffix = "" },
                -- ]o/[o belong to Treesitter loop motions.
                oldfile = { suffix = "" },
                quickfix = { suffix = "" },
                treesitter = { suffix = "" },
                undo = { suffix = "" },
                yank = { suffix = "" },
            })
        end,
    },
    {
        -- Lua rewrite of vim-surround: same ys/ds/cs/S keys, plus
        -- dot-repeat, function (f) and tag (t) surrounds.
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        -- Load after mini.splitjoin so Visual gS stays "surround line"
        -- (Normal gS remains split/join).
        dependencies = { "nvim-mini/mini.nvim" },
        opts = {},
    },
    {
        -- Replaces vim-visual-multi (Vimscript, loaded on every start).
        -- Same Alt keys; loads only when one is pressed.
        "jake-stewart/multicursor.nvim",
        branch = "1.0",
        keys = {
            {
                "<M-n>",
                function()
                    require("multicursor-nvim").matchAddCursor(1)
                end,
                mode = { "n", "x" },
                desc = "Multicursor: Add Next Match",
            },
            {
                "<M-p>",
                function()
                    require("multicursor-nvim").matchAddCursor(-1)
                end,
                mode = { "n", "x" },
                desc = "Multicursor: Add Previous Match",
            },
            {
                "<M-x>",
                function()
                    require("multicursor-nvim").matchSkipCursor(1)
                end,
                mode = { "n", "x" },
                desc = "Multicursor: Skip Match",
            },
            {
                "<M-a>",
                function()
                    require("multicursor-nvim").matchAllAddCursors()
                end,
                mode = { "n", "x" },
                desc = "Multicursor: Add All Matches",
            },
            {
                "<M-Down>",
                function()
                    require("multicursor-nvim").lineAddCursor(1)
                end,
                mode = { "n", "x" },
                desc = "Multicursor: Add Below",
            },
            {
                "<M-Up>",
                function()
                    require("multicursor-nvim").lineAddCursor(-1)
                end,
                mode = { "n", "x" },
                desc = "Multicursor: Add Above",
            },
        },
        config = function()
            local mc = require("multicursor-nvim")
            mc.setup()
            -- Active only while several cursors exist.
            mc.addKeymapLayer(function(layer)
                layer({ "n", "x" }, "<Left>", mc.prevCursor)
                layer({ "n", "x" }, "<Right>", mc.nextCursor)
                layer({ "n", "x" }, "<M-d>", mc.deleteCursor)
                layer("n", "<Esc>", function()
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    else
                        mc.clearCursors()
                    end
                end)
            end)
            local hl = vim.api.nvim_set_hl
            hl(0, "MultiCursorCursor", { reverse = true, default = true })
            hl(0, "MultiCursorVisual", { link = "Visual", default = true })
            hl(0, "MultiCursorMatchPreview", { link = "Search", default = true })
            hl(0, "MultiCursorDisabledCursor", { reverse = true, default = true })
            hl(0, "MultiCursorDisabledVisual", { link = "Visual", default = true })
        end,
    },
    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "windwp/nvim-ts-autotag",
        ft = { "html", "xml", "javascriptreact", "typescriptreact", "vue", "svelte", "astro", "php" },
        config = function()
            require("integrations.autotag")
        end,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        lazy = true,
        init = defer_on_filetype("render-markdown.nvim", { "markdown", "markdown.mdx", "codecompanion" }, 30),
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("integrations.render-markdown")
        end,
    },
}
