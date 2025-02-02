return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      on_attach = "default",
      hijack_cursor = false,
      auto_reload_on_write = true,
      disable_netrw = false,
      hijack_netrw = true,
      root_dirs = {},
      sync_root_with_cwd = false,
      view = {
        side = "left",
        width = 30,
        signcolumn = "yes",
        float = { enable = false },
      },
      renderer = {
        indent_width = 2,
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
        icons = {
          glyphs = {
            default = "",
            symlink = "",
            folder = { default = "", open = "" },
            git = {
              unstaged = "✗", staged = "✓", untracked = "★", deleted = ""
            },
          },
        },
      },
      git = { enable = true, show_on_dirs = true, show_on_open_dirs = true },
      diagnostics = { enable = false },
      filters = { git_ignored = true },
      filesystem_watchers = { enable = true },
      actions = {
        open_file = { quit_on_open = false, window_picker = { enable = true } },
        remove_file = { close_window = true },
      },
      trash = { cmd = "gio trash" },
    })

    -- Key mappings for NvimTree
    vim.keymap.set("n", "<leader>ee", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle NvimTree" })
    vim.keymap.set("n", "<leader>er", ":NvimTreeRefresh<CR>", { silent = true, desc = "Refresh NvimTree" })
    vim.keymap.set("n", "<leader>es", ":NvimTreeFindFile<CR>", { silent = true, desc = "Find file in NvimTree" })
    vim.keymap.set("n", "<leader>ec", ":NvimTreeCollapse<CR>", { silent = true, desc = "Collapse NvimTree" })
    vim.keymap.set("n", "<leader>ef", ":NvimTreeFocus<CR>", { silent = true, desc = "Focus Explore" })
  end,
}
