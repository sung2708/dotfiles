return {
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "folke/todo-comments.nvim",
    },
    opts = {
      auto_preview = false, -- Disable auto preview
      auto_fold = true, -- Automatically fold entries
      icons = {
        folder_closed = " ", -- Icon for closed folders
        folder_open = " ", -- Icon for open folders
        kinds = {
          Error = " ", -- Icon for errors
          Warning = " ", -- Icon for warnings
          Information = " ", -- Icon for information
          Hint = " ", -- Icon for hints
        },
      },
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble quickfix toggle<cr>",
        desc = "Diagnostics (Trouble - Quickfix)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Buffer Diagnostics (Trouble - Location List)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
      {
        "<leader>cd",
        "<cmd>CocDiagnostics<cr>",
        desc = "Show diagnostics (Coc)",
      },
    },
  },
}
