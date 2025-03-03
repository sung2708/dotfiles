return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require('lualine').setup({
            options = {
                icons_enabled = true,                 -- Enable icons
                theme = auto,            -- Use the current colorscheme as the theme
                component_separators = { left = '', right = '' },  -- Separators for components
                section_separators = { left = '', right = '' },    -- Separators for sections
                disabled_filetypes = { statusline = {}, winbar = {} },  -- Disable for specific filetypes
                always_divide_middle = true,          -- Ensure middle section is always divided
                globalstatus = false,                 -- Disable global statusline
                refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },  -- Refresh intervals
            },
            sections = {
                lualine_a = { 'mode' },               -- Mode
                lualine_b = { 'branch', 'diff', 'diagnostics' },  -- Branch, Diff, Diagnostics
                lualine_c = { 'filename' },           -- Filename
                lualine_x = { 'encoding', 'fileformat', 'filetype' },  -- Encoding, File format, File type
                lualine_y = { 'progress' },           -- Progress
                lualine_z = { 'location' },           -- Location
            },
            inactive_sections = {
                lualine_c = { 'filename' },           -- Inactive filename
                lualine_x = { 'location' },           -- Inactive location
            },
            tabline = {},                           -- No tabline configuration
            winbar = {},                            -- No winbar configuration
            inactive_winbar = {},                   -- No inactive winbar configuration
            extensions = {},                        -- No additional extensions
        })
    end,
}
