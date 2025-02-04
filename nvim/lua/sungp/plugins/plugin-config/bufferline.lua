return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',

    config = function()
        require("bufferline").setup({
            options = {
                -- Mode and behavior
                mode = "buffers", -- Display buffers instead of tabs
                themable = true, -- Allow theme customization
                numbers = function(opts)
                    return string.format("%d", opts.ordinal) -- Display buffer ordinal numbers
                end,
                close_command = "bdelete! %d", -- Command to close a buffer
                
                -- Indicator and icons
                indicator = { icon = '▎', style = 'icon' },
                buffer_close_icon = '󰅖',
                modified_icon = '●',
                close_icon = '',
                left_trunc_marker = '',
                right_trunc_marker = '',

                -- Diagnostics (Coc.nvim integration)
                diagnostics = "coc", -- Use Coc.nvim for diagnostics
                diagnostics_update_in_insert = false, -- Update diagnostics outside insert mode
                diagnostics_indicator = function(_, _, diagnostics_dict)
                    local result = ""
                    for severity, count in pairs(diagnostics_dict) do
                        local icon = severity == "error" and " " or severity == "warning" and " " or " "
                        result = result .. count .. icon
                    end
                    return result
                end,

                -- File explorer offset
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        highlight = "Directory",
                        separator = true,
                        text_align = "center",
                    },
                },

                -- Bufferline appearance and behavior
                max_name_length = 18,
                truncate_names = true,
                tab_size = 18,
                color_icons = true,
                show_buffer_icons = true,
                show_buffer_close_icons = true,
                show_tab_indicators = true,
                separator_style = "thick",
                always_show_bufferline = true,

                -- Hover behavior
                hover = {
                    enabled = true,
                    delay = 200,
                    reveal = { 'close' },
                },

                -- Sorting behavior
                sort_by = 'insert_after_current',
            },
        })

        -- Key mappings for bufferline
        vim.keymap.set("n", "<leader>bn", ":BufferLineCycleNext<CR>", { silent = true, noremap = true, desc = "Next buffer" })
        vim.keymap.set("n", "<leader>bp", ":BufferLineCyclePrev<CR>", { silent = true, noremap = true, desc = "Previous buffer" })
        vim.keymap.set("n", "<leader>bd", ":BufferLineCloseRight<CR>", { silent = true, noremap = true, desc = "Close buffers to the right" })
        vim.keymap.set("n", "<leader>bl", ":BufferLineCloseLeft<CR>", { silent = true, noremap = true, desc = "Close buffers to the left" })
        vim.keymap.set("n", "<leader>bb", ":BufferLinePick<CR>", { silent = true, noremap = true, desc = "Pick buffer by number" })
    end,
}
