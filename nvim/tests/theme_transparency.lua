-- Exercise the installed theme's mutable setup state, not mocked highlight tables.
vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/vscode.nvim")
local fixture = vim.fn.tempname() .. "-theme"
vim.env.XDG_STATE_HOME = fixture
local theme = require("config.theme")
require("plugins.themes")
theme.loading = true
local ok, err = xpcall(function()
    for _, transparent in ipairs({ true, false, true, false }) do
        theme.setups["vscode.nvim"](transparent)
        require("vscode").load()
        theme.apply_ui_highlights()
        local bg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
        assert((bg == nil) == transparent, "VS Code transparency did not follow the toggle")
        assert(vim.api.nvim_get_hl(0, { name = "NoicePopup", link = false }).bg == bg)
    end
end, debug.traceback)
vim.fn.delete(fixture, "rf")
assert(ok, err)
print("PASS installed VS Code theme toggles transparency repeatedly with matching Noice background")
