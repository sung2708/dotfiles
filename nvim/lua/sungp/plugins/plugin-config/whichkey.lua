return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "e",
      "<C-U>CocList extensions",
      desc = "CocList extensions",
    },
    {
      "j",
      "<C-U>CocNext",
      desc = "CocNext",
    },
    {
      "k",
      "<C-U>CocPrev",
      desc = "CocPrev",
    },
    {
      "o",
      "<C-U>CocList outline",
      desc = "CocList outline",
    },
    {
      "p",
      "<C-U>CocListResume",
      desc = "CocListResume",
    },
    {
      "s",
      "<C-U>CocList -I symbols",
      desc = "CocList symbols",
    },
    {
      "?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
    {
      "a",
      "+1 keymap",
      desc = "+1 keymap",
    },
    {
      "b",
      "+1 keymap",
      desc = "+1 keymap",
    },
    {
      "c",
      "<C-U>CocList commands",
      desc = "CocList commands",
    },
    {
      "E",
      "+Explore",
      desc = "Explore",
    },
    {
      "f",
      "+coc-format-selected",
      desc = "Format Selected (coc)",
    },
    {
      "l",
      "<cmd>LazyGit<CR>",
      desc = "LazyGit",
    },
    {
      "q",
      "<cmd>CocFix<CR>",
      desc = "Coc Fix",
    },
    {
      "r",
      "+coc-codeaction-refactor-selected",
      desc = "Code Action Refactor",
    },
    {
      "t",
      "<cmd>ToggleTerm<CR>",
      desc = "Terminal",
    },
    {
      "x",
      "<cmd>Trouble diagnostics<CR>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "X",
      "<cmd>Trouble loclist<CR>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "L",
      "<cmd>Trouble loclist<CR>",
      desc = "Location List (Trouble)",
    },
    {
      "Q",
      "<cmd>Trouble qflist<CR>",
      desc = "Quickfix List (Trouble)",
    },
    {
      "b",
      "<cmd>BufferLinePick<CR>",
      desc = "Pick a buffer (BufferLine)"
    }
  },
}

