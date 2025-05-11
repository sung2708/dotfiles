return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- Helper to count loaded plugins and total plugins
		local function generate_footer()
			local loaded_plugins = 0
			local total_plugins = 0
			local ok, lazy = pcall(require, "lazy")
			if ok and lazy.plugins then
				local plugins = lazy.plugins()
				total_plugins = #vim.tbl_keys(plugins)
				for _, plugin in pairs(plugins) do
					if plugin._.loaded then
						loaded_plugins = loaded_plugins + 1
					end
				end
			else
				vim.notify("Unable to count plugins: Lazy.nvim not found", vim.log.levels.WARN)
			end

			local system_info = string.format(
				"Neovim v%s | %s | Plugins loaded: %d/%d",
				vim.version().major .. "." .. vim.version().minor,
				os.date("%Y-%m-%d"),
				loaded_plugins,
				total_plugins
			)

			local quotes = {
				"The only way to do great work is to love what you do. - Steve Jobs",
				"The best time to plant a tree was 20 years ago. The second best time is now. - Chinese Proverb",
				"Your limitation—it's only your imagination.",
			}
			math.randomseed(os.time())
			local random_quote = "No motivational quote available."
			if #quotes > 0 then
				random_quote = quotes[math.random(1, #quotes)]
			end

			return { system_info, random_quote }
		end

		-- Dashboard setup
		require("dashboard").setup({
			theme = "doom",
			config = {
				header = {
					"                                             ",
					"                                             ",
					"                                             ",
					"                                             ",
					"                                             ",
					"                                             ",
					"                                             ",
					"                                             ",
					"███████╗██╗   ██╗███╗   ██╗ ██████╗ ██████╗ ",
					"██╔════╝██║   ██║████╗  ██║██╔════╝ ██╔══██╗",
					"███████╗██║   ██║██╔██╗ ██║██║  ███╗██████╔╝",
					"╚════██║██║   ██║██║╚██╗██║██║   ██║██╔═══╝ ",
					"███████║╚██████╔╝██║ ╚████║╚██████╔╝██║     ",
					"╚══════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ",
					"                                             ",
					"         Welcome to SUNGP!                  ",
					"                                             ",
				},
				center = {
					{ icon = "  ", desc = "Find File        ", key = "f", action = "Telescope find_files" },
					{ icon = "󱦺  ", desc = "Recent Files     ", key = "r", action = "Telescope oldfiles" },
					{ icon = "󰩉  ", desc = "Find Word        ", key = "w", action = "Telescope live_grep" },
					{ icon = "  ", desc = "Find in Files    ", key = "s", action = "Telescope grep_string" },
					{ icon = "󰒲  ", desc = "Lazy             ", key = "l", action = "Lazy" },
					{ icon = "󰈙  ", desc = "Show Docs        ", key = "d", action = "Telescope help_tags" },
				},
				footer = generate_footer(),
			},
		})

		-- Autocmd to load dashboard on VimEnter when no file is specified
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				if #vim.fn.argv() == 0 then
					vim.cmd("Dashboard")
				end
			end,
		})
	end,
}
