-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration
local config = wezterm.config_builder()

-- Font setup
config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font_size = 11

-- Appearance settings
config.window_background_image = '/home/sungp/.config/wezterm/bg.jpg'  -- Set background image
config.window_background_image_hsb = {
  brightness = 0.3,  -- Adjust brightness of the background
  hue = 1.0,        -- Adjust the hue of the background
  saturation = 1.0,  -- Adjust the saturation of the background
}

config.initial_cols = 240  -- Initial number of columns (width of terminal)
config.initial_rows = 67   -- Initial number of rows (height of terminal)

config.enable_tab_bar = false  -- Disable the tab bar
config.window_decorations = 'RESIZE'  -- Set window decorations to allow resizing

-- Set color scheme (make sure 'Catppuccin Frappé (Gogh)' is installed)
config.color_scheme = 'Catppuccin Frappé (Gogh)'

-- Key bindings for copy and paste
config.keys = {
  -- Copy with Ctrl + Shift + C
  { key = 'C', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo('Clipboard') },

  -- Paste with Ctrl + Shift + V
  { key = 'V', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom('Clipboard') },
}

-- Return the final configuration to wezterm
return config
