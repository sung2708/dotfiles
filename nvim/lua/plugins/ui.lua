local defer_after_vimenter = require("helper.utils").defer_plugin_after_vimenter

return {
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        opts = {
            default = true,
        },
    },
    {
        "Bekaboo/dropbar.nvim",
        lazy = true,
        init = not vim.g.sungp_low_spec and defer_after_vimenter("dropbar.nvim", 240) or nil,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            {
                "<leader>ub",
                function()
                    require("integrations.dropbar").toggle()
                end,
                desc = "UI: Toggle Breadcrumbs",
            },
            {
                "<leader>;",
                function()
                    require("dropbar.api").pick()
                end,
                desc = "Breadcrumb: Pick Symbol",
            },
            {
                "[;",
                function()
                    require("dropbar.api").goto_context_start()
                end,
                desc = "Breadcrumb: Context Start",
            },
            {
                "];",
                function()
                    require("dropbar.api").select_next_context()
                end,
                desc = "Breadcrumb: Next Context",
            },
        },
        config = function()
            require("integrations.dropbar")
        end,
    },
    {
        "folke/snacks.nvim",
        -- Load after the first frame; its dashboard/UI is optional on a
        -- low-spec machine and key mappings still load it on demand.
        lazy = vim.g.sungp_low_spec,
        event = vim.g.sungp_low_spec and "VeryLazy" or nil,
        priority = vim.g.sungp_low_spec and nil or 1000,
        keys = {
            {
                "<leader>ut",
                function()
                    require("config.theme").pick()
                end,
                desc = "UI: Select Theme (saved as default)",
            },
            {
                "<leader>uT",
                function()
                    require("config.theme").toggle_transparent()
                end,
                desc = "UI: Toggle Transparent Background",
            },
            {
                "<leader>gG",
                function()
                    if vim.fn.executable("lazygit") == 1 then
                        Snacks.lazygit({ cwd = require("helper.project").root() })
                    else
                        vim.notify("lazygit is not installed (brew install lazygit)", vim.log.levels.WARN)
                    end
                end,
                desc = "Git: Lazygit",
            },
            {
                "<leader>go",
                function()
                    Snacks.gitbrowse()
                end,
                mode = { "n", "x" },
                desc = "Git: Open in Browser",
            },
            {
                "<leader>cR",
                function()
                    Snacks.rename.rename_file()
                end,
                desc = "Code: Rename File (LSP-aware)",
            },
            {
                "<leader>uz",
                function()
                    Snacks.zen({ toggles = { dim = false, git_signs = false, mini_diff_signs = false } })
                end,
                desc = "UI: Zen Mode",
            },
            {
                "<leader>uZ",
                function()
                    Snacks.zen.zoom()
                end,
                desc = "UI: Zoom Window",
            },
            {
                "<leader>u.",
                function()
                    Snacks.scratch({ ft = "markdown" })
                end,
                desc = "UI: Scratch Notes",
            },
            {
                "<leader>uS",
                function()
                    Snacks.scratch.select()
                end,
                desc = "UI: Select Scratch",
            },
            {
                "<leader>uw",
                function()
                    Snacks.toggle.option("wrap"):toggle()
                end,
                desc = "UI: Toggle Wrap (Window)",
            },
            {
                "<leader>ud",
                function()
                    Snacks.toggle.diagnostics():toggle()
                end,
                desc = "UI: Toggle Diagnostics",
            },
            {
                "<leader>uf",
                function()
                    vim.g.disable_autoformat = not vim.g.disable_autoformat
                    vim.notify("Autoformat globally: " .. (vim.g.disable_autoformat and "off" or "on"))
                end,
                desc = "UI: Toggle Autoformat (Global)",
            },
            {
                "<leader>uF",
                function()
                    vim.b.disable_autoformat = not vim.b.disable_autoformat
                    vim.notify(
                        "Autoformat for buffer: "
                            .. (vim.b.disable_autoformat and "off" or "on")
                            .. (vim.g.disable_autoformat and " (globally disabled)" or "")
                    )
                end,
                desc = "UI: Toggle Autoformat (Buffer)",
            },
            {
                "<leader>uP",
                function()
                    Snacks.profiler.toggle()
                end,
                desc = "UI: Toggle Lua Profiler",
            },
            { "<leader>up", "<cmd>Lazy profile<cr>", desc = "UI: Plugin Load Profile" },
            {
                "<leader>uh",
                function()
                    Snacks.notifier.show_history()
                end,
                desc = "UI: Notification History",
            },
            {
                "<leader>un",
                function()
                    Snacks.notifier.hide()
                end,
                desc = "UI: Dismiss Notifications",
            },
        },
        config = function()
            require("integrations.snacks")
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("integrations.lualine")
        end,
    },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Buffer: Next" },
            { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Buffer: Previous" },
            { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Buffer: Pin" },
            { "<leader>be", "<cmd>BufferLineMoveNext<cr>", desc = "Buffer: Move Right" },
            { "<leader>bq", "<cmd>BufferLineMovePrev<cr>", desc = "Buffer: Move Left" },
        },
        config = function()
            require("integrations.bufferline")
        end,
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("integrations.noice")
        end,
    },
    {
        "shellRaining/hlchunk.nvim",
        lazy = true,
        init = not vim.g.sungp_low_spec and defer_after_vimenter("hlchunk.nvim", 360) or nil,
        keys = {
            { "iH", mode = { "x", "o" }, desc = "Inside Highlighted Chunk" },
            {
                "<leader>ui",
                function()
                    local group = "hlchunk_indent"
                    local ok, events = pcall(vim.api.nvim_get_autocmds, { group = group })
                    local enabled = ok and #events > 0
                    vim.cmd(enabled and "DisableHLIndent" or "EnableHLIndent")
                end,
                desc = "UI: Toggle Indent Guides",
            },
            {
                "<leader>uc",
                function()
                    local group = "hlchunk_chunk"
                    local ok, events = pcall(vim.api.nvim_get_autocmds, { group = group })
                    local enabled = ok and #events > 0
                    vim.cmd(enabled and "DisableHLChunk" or "EnableHLChunk")
                end,
                desc = "UI: Toggle Chunk Highlight",
            },
        },
        config = function()
            require("integrations.hlchunk")
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("integrations.whichkey")
        end,
    },
}
