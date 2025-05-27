local original_notify = vim.notify

vim.notify = function(msg, log_level, opts)
	if msg:match("nvim%-ts%-autotag: Using the legacy setup opts!") then
		return
	end
	original_notify(msg, log_level, opts)
end

require("sungp.config.settings")
require("sungp.config.autocmds")
require("sungp.config.keymaps")
require("sungp.config.lazy")
