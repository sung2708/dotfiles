return {
  "folke/noice.nvim",  -- Plugin to improve UI for notifications, messages, and commands
  event = "VeryLazy",
  opts = {
    -- General options can be added here
  },
  dependencies = {
    "MunifTanjim/nui.nvim",  -- Core library for UI components
    "rcarriga/nvim-notify",  -- Plugin for displaying notifications
  },

  config = function()
    -- Set up Noice.nvim with custom configurations
    require("noice").setup({
      cmdline = {
        enabled = true,  -- Enable the cmdline UI
        view = "cmdline_popup",  -- Use popup view for cmdline
        opts = {
          position = { row = 10, col = 0.5 },  -- Center cmdline in the screen
        },
        format = {
          cmdline = { pattern = "^:", icon = ">", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = "↓", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = "↑", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = "!", lang = "bash" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "?", lang = "help" },
          input = { view = "cmdline_input", icon = "" },
        },
      },

      messages = {
        enabled = true,
        view = "notify",           -- Use Notify view for messages
        view_error = "notify",     -- Use Notify for error messages
        view_warn = "notify",      -- Use Notify for warning messages
        view_history = "messages", -- Use messages view for history
        view_search = "virtualtext", -- Use virtualtext view for search
      },

      popupmenu = {
        enabled = true,
        backend = "nui",  -- Use NUI for popup menu
        kind_icons = {
          Text = "󱩼 ", Method = " ", Function = "", Constructor = "󰡢",
          Field = "󰌪", Variable = "", Class = "󱉟 ", Interface = " ",
          Module = "󰕳", Property = "󰧰", Unit = "⚙️", Value = "󰼜",
          Enum = "", Keyword = "", Snippet = "✂️", Color = "",
          File = "", Reference = "", Folder = "", EnumMember = "",
          Constant = "󰌾", Struct = "", Event = "󰸰", Operator = "",
          TypeParameter = "󰉺",
        },
      },

      redirect = {
        view = "popup",    -- Redirect output to popup view
        filter = { event = "msg_show" }, -- Filter messages to display
      },

      commands = {
        history = {
          view = "split", opts = { enter = true, format = "details" },
          filter = {
            any = { { event = "notify" }, { error = true }, { warning = true },
                    { event = "msg_show", kind = { "" } }, { event = "lsp", kind = "message" } },
          },
        },
        last = {
          view = "popup", opts = { enter = true, format = "details" },
          filter = { any = { { event = "notify" }, { error = true }, { warning = true },
                             { event = "msg_show", kind = { "" } }, { event = "lsp", kind = "message" } } },
          filter_opts = { count = 1 },
        },
        errors = {
          view = "popup", opts = { enter = true, format = "details" },
          filter = { error = true }, filter_opts = { reverse = true },
        },
        all = {
          view = "split", opts = { enter = true, format = "details" },
          filter = {},
        },
      },

      notify = {
        enabled = true,
        view = "notify",  -- Use Notify for displaying notifications
      },

      lsp = {
        progress = {
          enabled = true,
          format = "lsp_progress", format_done = "lsp_progress_done",
          throttle = 1000 / 30, view = "mini",
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
          ["vim.lsp.util.stylize_markdown"] = false,
          ["cmp.entry.get_documentation"] = false,
        },
        hover = {
          enabled = true, silent = false, view = nil, opts = {},
        },
        signature = {
          enabled = true, auto_open = { enabled = true, trigger = true, luasnip = true, throttle = 50 },
          view = nil, opts = {},
        },
        message = { enabled = true, view = "notify", opts = {} },
        documentation = {
          view = "hover", opts = {
            lang = "markdown", replace = true, render = "plain",
            format = { "{message}" }, win_options = { concealcursor = "n", conceallevel = 3 },
          },
        },

        -- Code actions UI customization
        code_action = {
          enabled = true,
          view = "popup",    -- Display code action UI in a popup view
          opts = {
            position = { row = 15, col = 0.5 },  -- Adjust code action popup position
            max_width = 50,    -- Limit width of the popup window
            max_height = 20,   -- Limit height of the popup window
          },
          format = {
            action = { pattern = "^:%s*CodeAction%s+", icon = "󰌾", lang = "vim" },
          },
        },
      },

      markdown = {
        hover = {
          ["|(%S-)|"] = vim.cmd.help,
          ["%[.-%]%((%S-)%)"] = require("noice.util").open,
        },
        highlights = {
          ["|%S-|"] = "@text.reference", ["@%S+"] = "@parameter", 
          ["^%s*(Parameters:)"] = "@text.title", ["^%s*(Return:)"] = "@text.title",
          ["^%s*(See also:)"] = "@text.title", ["{%S-}"] = "@parameter",
        },
      },

      health = {
        checker = true,  -- Enable health checks for Noice
      },

      presets = {
        bottom_search = false, command_palette = false, long_message_to_split = false,
        inc_rename = false, lsp_doc_border = false,
      },

      throttle = 1000 / 30,
      views = {},
      routes = {},
      status = {},
      format = {},
    })

    -- Key mappings for Noice commands
    vim.keymap.set("n", "<leader>nh", ":NoiceHistory<CR>", { silent = true, noremap = true, desc = "View message history" })
    vim.keymap.set("n", "<leader>nl", ":NoiceLast<CR>", { silent = true, noremap = true, desc = "View last message" })
    vim.keymap.set("n", "<leader>ne", ":NoiceErrors<CR>", { silent = true, noremap = true, desc = "View error messages" })
    vim.keymap.set("n", "<leader>na", ":NoiceAll<CR>", { silent = true, noremap = true, desc = "View all messages" })
  end
}

