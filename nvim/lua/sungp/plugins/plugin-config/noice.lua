return {
    "folke/noice.nvim",  -- Plugin for improving the UI of notifications, messages, and commands
    event = "VeryLazy",
    opts = {
        -- Add any options you may need here
    },
    dependencies = {
        "MunifTanjim/nui.nvim",  -- Core library for various UI components
        "rcarriga/nvim-notify",  -- Plugin for displaying notifications
    }, 
    config = function()
        -- Setup for Noice.nvim
        require("noice").setup({
            cmdline = {
                enabled = true,  -- Enable the UI for command-line
                view = "cmdline_popup",  -- Popup view for command-line
                opts = {
                    position = { row = 10, col = 0.5 },  -- Center the cmdline
                },
                format = {
                    cmdline = { pattern = "^:", icon = ">", lang = "vim" },  -- Command-line mode
                    search_down = { kind = "search", pattern = "^/", icon = "↓", lang = "regex" },  -- Search down using '/'
                    search_up = { kind = "search", pattern = "^%?", icon = "↑", lang = "regex" },  -- Search up using '?'
                    filter = { pattern = "^:%s*!", icon = "!", lang = "bash" },  -- Shell commands with '!'
                    lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },  -- Lua commands
                    help = { pattern = "^:%s*he?l?p?%s+", icon = "?", lang = "help" },  -- Help commands
                    input = { view = "cmdline_input", icon = "" },  -- Input commands
                },
            },

            messages = {
                enabled = true,
                view = "notify",
                view_error = "notify",
                view_warn = "notify",
                view_history = "messages",
                view_search = "virtualtext",
            },

            popupmenu = {
                enabled = true,
                backend = "nui",
                kind_icons = {
                    Text = "󱩼 ",
                    Method = " ",
                    Function = "",
                    Constructor = "󰡢",
                    Field = "󰌪",
                    Variable = "",
                    Class = "󱉟",
                    Interface = "",
                    Module = "󰕳",
                    Property = "󰧰",
                    Unit = "⚙️",
                    Value = "󰼜",
                    Enum = "",
                    Keyword = "",
                    Snippet = "✂️",
                    Color = "",
                    File = "",
                    Reference = "",
                    Folder = "",
                    EnumMember = "",
                    Constant = "󰌾",
                    Struct = "",
                    Event = "󰸰",
                    Operator = "",
                    TypeParameter = "󰉺",
                },
            },

            redirect = {
                view = "popup",  -- Redirect command output to a popup view
                filter = { event = "msg_show" },  -- Filter messages to show
            },

            commands = {
                history = {
                    view = "split",
                    opts = { enter = true, format = "details" },
                    filter = {
                        any = {
                            { event = "notify" }, 
                            { error = true }, 
                            { warning = true }, 
                            { event = "msg_show", kind = { "" } }, 
                            { event = "lsp", kind = "message" }
                        },
                    },
                },
                last = {
                    view = "popup",
                    opts = { enter = true, format = "details" },
                    filter = { any = { { event = "notify" }, { error = true }, { warning = true }, { event = "msg_show", kind = { "" } }, { event = "lsp", kind = "message" } } },
                    filter_opts = { count = 1 },
                },
                errors = {
                    view = "popup",
                    opts = { enter = true, format = "details" },
                    filter = { error = true },
                    filter_opts = { reverse = true },
                },
                all = {
                    view = "split",
                    opts = { enter = true, format = "details" },
                    filter = {},
                },
            },

            notify = {
                enabled = true,
                view = "notify",
            },

            lsp = {
                progress = {
                    enabled = true,
                    format = "lsp_progress",
                    format_done = "lsp_progress_done",
                    throttle = 1000 / 30,
                    view = "mini",
                },
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
                    ["vim.lsp.util.stylize_markdown"] = false,
                    ["cmp.entry.get_documentation"] = false,
                },
                hover = {
                    enabled = true,
                    silent = false,
                    view = nil,
                    opts = {},
                },
                signature = {
                    enabled = true,
                    auto_open = {
                        enabled = true,
                        trigger = true,
                        luasnip = true,
                        throttle = 50,
                    },
                    view = nil,
                    opts = {},
                },
                message = {
                    enabled = true,
                    view = "notify",
                    opts = {},
                },
                documentation = {
                    view = "hover",
                    opts = {
                        lang = "markdown",
                        replace = true,
                        render = "plain",
                        format = { "{message}" },
                        win_options = { concealcursor = "n", conceallevel = 3 },
                    },
                },
            },

            markdown = {
                hover = {
                    ["|(%S-)|"] = vim.cmd.help,
                    ["%[.-%]%((%S-)%)"] = require("noice.util").open,
                },
                highlights = {
                    ["|%S-|"] = "@text.reference",
                    ["@%S+"] = "@parameter",
                    ["^%s*(Parameters:)"] = "@text.title",
                    ["^%s*(Return:)"] = "@text.title",
                    ["^%s*(See also:)"] = "@text.title",
                    ["{%S-}"] = "@parameter",
                },
            },

            health = {
                checker = true,
            },

            presets = {
                bottom_search = false,
                command_palette = false,
                long_message_to_split = false,
                inc_rename = false,
                lsp_doc_border = false,
            },

            throttle = 1000 / 30,
            views = {},
            routes = {},
            status = {},
            format = {},
        })

        -- Key mappings for Noice
        vim.keymap.set("n", "<leader>nh", ":NoiceHistory<CR>", { silent = true, noremap = true, desc = "View message history" })
        vim.keymap.set("n", "<leader>nl", ":NoiceLast<CR>", { silent = true, noremap = true, desc = "View last message" })
        vim.keymap.set("n", "<leader>ne", ":NoiceErrors<CR>", { silent = true, noremap = true, desc = "View error messages" })
        vim.keymap.set("n", "<leader>na", ":NoiceAll<CR>", { silent = true, noremap = true, desc = "View all messages" })
    end
}
