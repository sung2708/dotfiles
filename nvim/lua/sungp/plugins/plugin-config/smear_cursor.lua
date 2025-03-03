return {
  "sphamba/smear-cursor.nvim",

  opts = {
    -- Smear cursor when switching buffers or windows.
    smear_between_buffers = true,

    -- Smear cursor when moving within the line or to neighboring lines.
    -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control.
    smear_between_neighbor_lines = true,

    -- Draw the smear in buffer space instead of screen space when scrolling.
    scroll_buffer_space = true,

    -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
    -- Smears will blend better on all backgrounds.
    legacy_computing_symbols_support = true,

    -- Smear cursor in insert mode.
    smear_insert_mode = true,

    -- Set the cursor color.
    cursor_color = "#8839ef",

    -- Smear animation stiffness settings.
    stiffness = 0.3,
    trailing_stiffness = 0.1,
    trailing_exponent = 5,

    -- Hide the target position while animating the smear.
    hide_target_hack = true,

    -- Adjust the gamma for the smear effect.
    gamma = 1,
  },
}

