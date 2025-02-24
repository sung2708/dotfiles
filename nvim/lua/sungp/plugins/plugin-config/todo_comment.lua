return {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local comment_todo = require("todo-comments")
        
        -- Keymap for jumping to the next TODO comment
        vim.keymap.set("n", "<leader>]t", function()
            comment_todo.jump_next()
        end, { desc = "Next TODO comment" })

        -- Keymap for jumping to the previous TODO comment
        vim.keymap.set("n", "<leader>[t", function()
            comment_todo.jump_prev()
        end, { desc = "Previous TODO comment" })

        -- Setup todo-comments
        comment_todo.setup({
            signs = true, -- Show icons in the sign column
            keywords = {
                FIX = {
                    icon = "", -- Bug icon
                    color = "error",
                    alt = { "FIXME", "BUG", "FIXIT" },
                },
                TODO = { icon = "", color = "info" }, -- Checkmark icon
                HACK = { icon = "", color = "warning" }, -- Wrench icon
                WARN = { 
                    icon = "", -- Warning icon
                    color = "warning", 
                    alt = { "WARNING", "XXX" } 
                },
            },
            colors = {
                error = { "LspDiagnosticsDefaultError", "ErrorMsg" },
                warning = { "LspDiagnosticsDefaultWarning", "WarningMsg" },
                info = { "LspDiagnosticsDefaultInformation", "MoreMsg" },
            },
            search = {
                command = "rg", -- Use ripgrep for searching
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                pattern = [[\b(KEYWORDS):]], -- Search pattern for keywords
            },
        })
    end,
}
