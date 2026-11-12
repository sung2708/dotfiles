-- Fake LSP transport: verifies document delivery without starting Copilot or using the network.
vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig")
package.loaded["lazy"] = { load = function() end }
local executable = vim.fn.executable
vim.fn.executable = function(name)
    return name == "copilot-language-server" and 1 or executable(name)
end
local opened = {}
vim.lsp.config("copilot", {
    cmd = function(dispatchers)
        local closing = false
        return {
            request = function(method, _, callback)
                callback(nil, method == "initialize" and { capabilities = { textDocumentSync = 1 } } or {})
                return true, 1
            end,
            notify = function(method, params)
                if method == "textDocument/didOpen" then
                    opened[params.textDocument.uri] = true
                end
                return true
            end,
            is_closing = function()
                return closing
            end,
            terminate = function()
                closing = true
                dispatchers.on_exit(0, 0)
            end,
        }
    end,
})
require("config.copilot")
local function buffer(big)
    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_buf_set_name(buf, vim.fn.tempname() .. ".txt")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { big and string.rep("x", 1024 * 1024 + 1) or "small" })
    vim.b[buf].bigfile = big
    vim.bo[buf].filetype = big and "bigfile" or "text"
    return buf
end
local first = buffer(true)
vim.api.nvim_exec_autocmds("InsertEnter", { buffer = first })
vim.wait(100)
assert(not opened[vim.uri_from_bufnr(first)], "initial bigfile was sent to Copilot")
local small = buffer(false)
assert(
    vim.wait(1000, function()
        return opened[vim.uri_from_bufnr(small)]
    end),
    "ordinary file did not attach"
)
local later = buffer(true)
vim.wait(100)
assert(not opened[vim.uri_from_bufnr(later)], "later bigfile was sent to Copilot")
assert(#vim.lsp.get_clients({ bufnr = small, name = "copilot" }) == 1)
vim.lsp.enable("copilot", false)
vim.wait(100)
print("PASS Copilot rejects initial and later bigfiles before didOpen; ordinary files still attach")
