-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration
local config = wezterm.config_builder()

-- Font setup
config.font = wezterm.font("JetBrains Mono", { weight = "Bold", italic = true })
config.font_size = 11

-- Appearance settings
-- config.window_background_opacity = 0.95
-- config.text_background_opacity = 0.1
--config.window_background_image = "/home/sungp/.config/wezterm/bg1.jpeg" -- Set background image
--config.window_background_image_hsb = {
--	brightness = 0.1, -- Adjust brightness of the background
--	hue = 1.0, -- Adjust the hue of the background
--	saturation = 1.0, -- Adjust the saturation of the background
--}

config.default_cursor_style = "SteadyBar"
config.initial_cols = 240 -- Initial number of columns (width of terminal)
config.initial_rows = 67 -- Initial number of rows (height of terminal)

config.enable_tab_bar = false -- Disable the tab bar
config.window_decorations = "RESIZE" -- Set window decorations to allow resizing

config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- Set color scheme (make sure 'Catppuccin Frappé (Gogh)' is installed)
config.color_scheme = "Catppuccin Mocha"
--config.color_scheme = "One Dark (Gogh)"
-- Key bindings for copy and paste
config.keys = {
	-- Copy with Ctrl + Shift + C
	{ key = "C", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },

	-- Paste with Ctrl + Shift + V
	{ key = "V", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
}

-- Return the final configuration to wezterm
return config
