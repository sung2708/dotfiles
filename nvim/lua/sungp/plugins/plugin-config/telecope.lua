return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
        local trouble = require("trouble.sources.telescope")

        require("telescope").setup({
            defaults = {
                layout_config = {
                    horizontal = {
                        preview_width = 0.7, -- Set the width of the preview window
                        width = 0.8,         -- Set the total width of the Telescope window
                        height = 0.7,        -- Set the total height of the Telescope window
                        prompt_position = "bottom", -- Place the prompt at the bottom
                    },
                },
                mappings = {
                    i = {
                        ["<c-t>"] = trouble.open, -- Map <Ctrl-t> to open Trouble in insert mode
                    },
                    n = {
                        ["<c-t>"] = trouble.open, -- Map <Ctrl-t> to open Trouble in normal mode
                    },
                },
            },
        })

        -- Key mappings for Telescope functionality
        local map = vim.keymap.set
        local opts = { silent = true, noremap = true }

        map("n", "<leader>ff", ":Telescope find_files<CR>", vim.tbl_extend("force", opts, { desc = "Telescope: Find Files" }))
        map("n", "<leader>fg", ":Telescope live_grep<CR>", vim.tbl_extend("force", opts, { desc = "Telescope: Live Grep" }))
        map("n", "<leader>fb", ":Telescope buffers<CR>", vim.tbl_extend("force", opts, { desc = "Telescope: Buffers" }))
        map("n", "<leader>fh", ":Telescope help_tags<CR>", vim.tbl_extend("force", opts, { desc = "Telescope: Help Tags" }))
        map("n", "<leader>ft", ":TodoTelescope<CR>", vim.tbl_extend("force", opts, { desc = "Telescope: Find Todos" }))
    end,
}
