vim.notify = function(msg, log_level, _)
	if msg:match("nvim%-ts%-autotag: Using the legacy setup opts!") then
		return
	end
	vim.notify(msg, log_level)
end

require("sungp.config.settings")
require("sungp.config.autocmds")
require("sungp.config.keymaps")
require("sungp.config.lazy")
