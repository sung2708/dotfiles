-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration
local config = wezterm.config_builder()

-- Font setup
config.font = wezterm.font("JetBrains Mono", { weight = "Bold", italic = true })
config.font_size = 13

-- Appearance settings
-- config.window_background_opacity = 0.95
-- config.text_background_opacity = 0.1
--config.window_background_image = "/home/sungphan/.config/wezterm/bg.jpg"-- Set background image
-- No background image is set above, so this has no effect until one is enabled
-- config.window_background_image_hsb = {
-- 	brightness = 0.1, -- Adjust brightness of the background
-- 	hue = 1.0, -- Adjust the hue of the background
-- 	saturation = 1.0, -- Adjust the saturation of the background
-- }

-- Use PowerShell 7 (pwsh) as the default shell
config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe", "-NoLogo" }

config.default_cursor_style = "SteadyBar"
-- Fallback size only (used if gui-startup/gui-attached maximize below doesn't fire,
-- e.g. reconnecting to a domain). The window is auto-maximized on real startup,
-- so it always fits the actual screen's work area (excludes the taskbar) on any
-- resolution/aspect ratio instead of being fixed to one monitor's size.
config.initial_cols = 120
config.initial_rows = 30

config.enable_tab_bar = false -- Disable the tab bar
config.window_decorations = "RESIZE" -- Set window decorations to allow resizing

config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- Set color scheme (make sure 'Catppuccin Frappé (Gogh)' is installed)
config.color_scheme = "Catppuccin Mocha"
--config.color_scheme = "One Dark (Gogh)"

-- Search / Copy Mode / Quick Select highlight colors (matched to Catppuccin Mocha)
config.colors = {
	-- Current active search match (also used for normal text selection)
	selection_fg = "#1e1e2e", -- Mocha Base
	selection_bg = "#f9e2af", -- Mocha Yellow

	-- Extra highlight when adding to the selection with the mouse in Copy Mode
	copy_mode_active_highlight_fg = { Color = "#1e1e2e" }, -- Mocha Base
	copy_mode_active_highlight_bg = { Color = "#fab387" }, -- Mocha Peach

	-- Other (non-active) search matches
	copy_mode_inactive_highlight_fg = { Color = "#cdd6f4" }, -- Mocha Text
	copy_mode_inactive_highlight_bg = { Color = "#585b70" }, -- Mocha Surface2

	-- Quick Select overlay (Ctrl+Shift+Space) labels/matches
	quick_select_label_fg = { Color = "#1e1e2e" }, -- Mocha Base
	quick_select_label_bg = { Color = "#cba6f7" }, -- Mocha Mauve
	quick_select_match_fg = { Color = "#1e1e2e" }, -- Mocha Base
	quick_select_match_bg = { Color = "#a6e3a1" }, -- Mocha Green
}

-- Key bindings for copy and paste
config.keys = {
	-- Copy with Ctrl + Shift + C
	{ key = "C", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },

	-- Paste with Ctrl + Shift + V
	{ key = "V", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },

	-- Search: Ctrl+Shift+F opens the built-in search overlay by default,
	-- this just adds an explicit regex-search shortcut for convenience.
	{ key = "F", mods = "CTRL|ALT", action = wezterm.action.Search({ Regex = "" }) },
}

-- Tmux
-- config.default_prog = { 'tmux', 'new-session', '-A', '-s', 'sungp' }

-- Auto-maximize the window to the screen's work area (excludes the Windows
-- taskbar) so the layout — and the search bar at the bottom — always fits,
-- no matter the monitor's resolution or aspect ratio.
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- Also maximize when reattaching to a running mux domain (gui-startup does
-- not fire in that case).
wezterm.on("gui-attached", function(domain)
	local workspace = wezterm.mux.get_active_workspace()
	for _, window in ipairs(wezterm.mux.all_windows()) do
		if window:get_workspace() == workspace then
			window:gui_window():maximize()
		end
	end
end)

-- Return the final configuration to wezterm
return config
