local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ── Shell: open or attach to the tmux session "sungp" ──────────────────────
-- Keep the same search and fallback as Ghostty.
config.default_prog = {
	"/bin/zsh",
	"-lc",
	[[export PATH="$PATH:/opt/local/bin:/opt/homebrew/bin:/usr/local/bin:/home/linuxbrew/.linuxbrew/bin"; tmux new-session -A -s sungp || exec /bin/zsh -l]],
}

-- ── Rendering ───────────────────────────────────────────────────────────────
-- WebGpu draws through Metal on macOS; LowPower keeps it on the integrated
-- GPU (cooler, better battery). Use "HighPerformance" if it ever stutters.
config.front_end = "WebGpu"
config.webgpu_power_preference = "LowPower"
config.max_fps = 120 -- capped by the display anyway
config.animation_fps = 60

-- ── Font ────────────────────────────────────────────────────────────────────
-- Regular-weight upright text keeps Bold and Italic meaningful in Neovim
-- (keywords, comments). Nerd Font icons come from WezTerm's built-in
-- symbols fallback. For the previous look use:
--   wezterm.font("JetBrains Mono", { weight = "Bold", italic = true })
config.font = wezterm.font_with_fallback({
	{ family = "JetBrains Mono", weight = "Medium" },
	"Apple Color Emoji",
})
config.font_size = 13
-- Keep line_height at 1.0: taller rows leave gaps around the powerline
-- separators of tmux, Lualine and Bufferline (the "clipped corners" look).
config.line_height = 1.0
-- Thicker, slightly lower underlines so LSP undercurls are easy to see.
config.underline_thickness = 2
config.underline_position = -2

-- ── Window ──────────────────────────────────────────────────────────────────
-- 0.80 let the wallpaper wash out dark themes (indent guides and line
-- numbers disappeared in Neovim). 0.90 keeps the glass look but stays legible.
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.window_padding = { left = 6, right = 6, top = 4, bottom = 0 }
config.enable_tab_bar = false -- tmux provides windows and panes
config.initial_cols = 120
config.initial_rows = 30
config.adjust_window_size_when_changing_font_size = false
config.window_close_confirmation = "NeverPrompt" -- the tmux session survives
config.audible_bell = "Disabled"

-- ── Cursor ──────────────────────────────────────────────────────────────────
config.default_cursor_style = "SteadyBar"

-- ── Colours: match the Neovim theme (Catppuccin Mocha) ─────────────────────
-- Built-in scheme instead of the Gogh port; the overrides below already use
-- the Mocha palette.
config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = "Tokyo Night"
-- config.color_scheme = "Kanagawa (Gogh)"
config.colors = {
	selection_fg = "#1e1e2e",
	selection_bg = "#f9e2af",

	copy_mode_active_highlight_fg = { Color = "#1e1e2e" },
	copy_mode_active_highlight_bg = { Color = "#fab387" },

	copy_mode_inactive_highlight_fg = { Color = "#cdd6f4" },
	copy_mode_inactive_highlight_bg = { Color = "#585b70" },

	quick_select_label_fg = { Color = "#1e1e2e" },
	quick_select_label_bg = { Color = "#cba6f7" },
	quick_select_match_fg = { Color = "#1e1e2e" },
	quick_select_match_bg = { Color = "#a6e3a1" },
}

-- ── Keyboard ────────────────────────────────────────────────────────────────
-- Left Option sends Alt/Meta (Neovim uses Alt+h/j/k/l, Alt+n, Alt+]...);
-- right Option still types accented characters.
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

-- Ctrl+Shift+C/V and Cmd+C/V are WezTerm defaults already.
config.keys = {
	{ key = "F", mods = "CTRL|ALT", action = wezterm.action.Search({ Regex = "" }) },
}

-- ── Start maximized ─────────────────────────────────────────────────────────
wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

wezterm.on("gui-attached", function()
	local workspace = wezterm.mux.get_active_workspace()
	for _, window in ipairs(wezterm.mux.all_windows()) do
		if window:get_workspace() == workspace then
			window:gui_window():maximize()
		end
	end
end)

return config
