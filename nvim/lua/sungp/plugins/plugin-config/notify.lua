return {
    "rcarriga/nvim-notify",  -- Plugin for displaying notifications
    opts = {
        -- General configuration
        background_colour = "#1c1c1c",  -- Background color for notifications
        stages = "fade_in_slide_out",    -- Animation style for notifications
        timeout = 200,                    -- Duration to show notifications
        max_width = 50,                   -- Maximum width of notifications
        max_height = 10,                  -- Maximum height of notifications

        -- Icons for different notification levels
        icons = {
            DEBUG = "",
            ERROR = "",
            INFO = "󰋼",
            TRACE = "",
            WARN = "",
        },

        -- Time format for notifications
        time_formats = {
            notification = "%T",                -- Time format for notifications
            notification_history = "%FT%T"      -- Time format for notification history
        }
    },

    config = function()
        -- Set up Notify with the defined configuration
        require("notify").setup({
            background_colour = "#1c1c1c",
            stages = "fade_in_slide_out",
            timeout = 200,
            max_width = 50,
            max_height = 10,
            icons = {
                DEBUG = "",
                ERROR = "",
                INFO = "󰋼",
                TRACE = "",
                WARN = "",
            },
            time_formats = {
                notification = "%T",
                notification_history = "%FT%T"
            }
        })

        -- Redirect vim.notify to Notify for displaying notifications
        vim.notify = require("notify")

        -- Function to display notification with customizable options
        local function notify_user(message, level, opts)
            vim.notify(message, level or "INFO", opts or {})
        end

        -- Automatically display a greeting message when Neovim starts
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                notify_user("Welcome Sungp to Neovim! Happy coding", "INFO")
            end,
        })
    end
}
