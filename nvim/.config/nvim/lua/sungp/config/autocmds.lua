-- Disable auto-commenting for all file types
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" } -- Remove auto-comment continuation
    end,
})

-- Automatically check for external changes and reload files
vim.api.nvim_create_autocmd("FocusGained", { pattern = "*", command = "checktime" }) -- Reload files on gaining focus
vim.api.nvim_create_autocmd("FileChangedShellPost", {
    pattern = "*",
    callback = function()
        local choice = vim.fn.confirm("File changed on disk. Reload buffer? (Yes/No)", "&Yes\n&No")
        if choice == 1 then
            vim.cmd("checktime")
        end
    end
})

-- Configure clipboard support based on OS
if vim.fn.has('win32') == 1 then
  vim.opt.clipboard = 'unnamed' -- System clipboard on Windows
else
  vim.opt.clipboard = 'unnamedplus' -- Enhanced clipboard on other systems
end
