return {
	"b0o/incline.nvim",
	event = "VeryLazy",
	config = function()
		local devicons = require("nvim-web-devicons")
		require("incline").setup({
			render = function(props)
				local buf = props.buf
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
				filename = filename ~= "" and filename or "[No Name]"
				local ft_icon, ft_color = devicons.get_icon_color(filename)

				local function get_git_diff()
					local signs = vim.b[buf].gitsigns_status_dict
					if not signs then
						return {}
					end
					local icons = { added = "  ", changed = "  ", removed = "  " }
					local labels = {}
					for name, icon in pairs(icons) do
						if signs[name] and signs[name] > 0 then
							table.insert(labels, { icon .. signs[name] .. " ", group = "Diff" .. name })
						end
					end
					return labels
				end

				local function get_diagnostics()
					local icons = { error = "  ", warn = "  ", info = "   ", hint = "  " }
					local labels = {}
					for severity, icon in pairs(icons) do
						local count =
							#vim.diagnostic.get(buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
						if count > 0 then
							table.insert(labels, { icon .. count .. " ", group = "DiagnosticSign" .. severity })
						end
					end
					return labels
				end

				return {
					{ get_diagnostics() },
					{ get_git_diff() },
					{ (ft_icon or "") .. " ", guifg = ft_color },
					{ filename .. " ", gui = vim.bo[buf].modified and "bold,italic" or "bold" },
					{ "   " .. vim.api.nvim_win_get_number(props.win), group = "DevIconWindows" },
				}
			end,
		})
	end,
	event = "VeryLazy",
}
