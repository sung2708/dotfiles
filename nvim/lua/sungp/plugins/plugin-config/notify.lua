return {
	"rcarriga/nvim-notify", -- Plugin for displaying notifications
	opts = {
		background_colour = "#ffffff", -- Background color (match Dracula theme or custom color)
		stages = "fade_in_slide_out", -- Animation style for notifications
		render = "default", -- Display style for notifications
		timeout = 200, -- Duration for which notifications are shown
		max_width = 50, -- Maximum width of notifications
		max_height = 10, -- Maximum height of notifications
		icons = {
			DEBUG = "", -- Icon for debug messages
			ERROR = "", -- Icon for error messages
			INFO = "󰋼", -- Icon for info messages
			TRACE = "", -- Icon for trace messages
			WARN = "", -- Icon for warning messages
		},
		time_formats = {
			notification = "%T", -- Time format for notifications
			notification_history = "%FT%T", -- Time format for notification history
		},
	},

	config = function()
		local notify = require("notify")

		-- Setup the notify plugin with the provided options
		notify.setup({
			background_colour = "#ffffff",
			stages = "fade_in_slide_out",
			render = "default",
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
				notification_history = "%FT%T",
			},
		})

		-- Override vim.notify to use the nvim-notify plugin
		vim.notify = notify

		-- Function to display notifications with customizable options
		local function notify_user(message, level, opts)
			vim.notify(message, level or "INFO", opts or {})
		end

		-- Automatically show a welcome message when Neovim starts
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				notify_user("Welcome Sungp to Neovim! Happy coding", "INFO")
			end,
		})
	end,
}
