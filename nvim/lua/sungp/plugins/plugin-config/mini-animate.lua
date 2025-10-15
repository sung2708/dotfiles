return {
	"echasnovski/mini.animate",
	event = "VeryLazy",
	cond = vim.g.neovide == nil,
	opts = function(_, opts)
		-- không chạy animation khi scroll bằng chuột
		local mouse_scrolled = false
		for _, scroll in ipairs({ "Up", "Down" }) do
			local key = "<ScrollWheel" .. scroll .. ">"
			vim.keymap.set({ "", "i" }, key, function()
				mouse_scrolled = true
				return key
			end, { expr = true })
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "grug-far",
			callback = function()
				vim.b.minianimate_disable = true
			end,
		})

		vim.g.minianimate_disable = false

		vim.api.nvim_create_user_command("ToggleMiniAnimate", function()
			vim.g.minianimate_disable = not vim.g.minianimate_disable
			print("Mini Animate is now " .. (vim.g.minianimate_disable and "disabled" or "enabled"))
		end, {})

		-- Keymap để toggle nhanh
		vim.keymap.set("n", "<leader>ua", "<cmd>ToggleMiniAnimate<cr>", { desc = "Toggle Mini Animate" })

		local animate = require("mini.animate")
		return vim.tbl_deep_extend("force", opts, {
			resize = {
				timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
			},
			scroll = {
				timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
				subscroll = animate.gen_subscroll.equal({
					predicate = function(total_scroll)
						if mouse_scrolled then
							mouse_scrolled = false
							return false
						end
						return total_scroll > 1
					end,
				}),
			},
		})
	end,
}
