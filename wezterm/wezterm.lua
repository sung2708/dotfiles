-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration
local config = wezterm.config_builder()

-- Font setup
config.font = wezterm.font("CaskaydiaCove Nerd Font") 

config.font_size = 14

-- Appearance
config.window_background_image= '/home/sungp/.config/wezterm/bg.jpg'

config.initial_cols = 240 

config.initial_rows = 67

config.window_background_image_hsb = {
  brightness = 0.3,

  hue = 1.0,

  saturation = 1.0,
}

config.enable_tab_bar = false

config.window_decorations = 'RESIZE'

-- config.window_background_opacity = 0.95

-- Set font size (optional, you can change the size)
config.font_size = 12

-- Set the color scheme
config.color_scheme = 'Catppuccin Frappé (Gogh)'

-- Finally, return the configuration to wezterm
return config
