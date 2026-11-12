-- GitHub Copilot through Neovim 0.12's native inline completion and the
-- official copilot-language-server (installed by Mason). Replaces the
-- copilot.vim plugin: no Vimscript, and no `npx` registry lookup on start.
--
-- Starts on the first Insert. Sign-in is shared with copilot.vim/VS Code
-- (~/.config/github-copilot); otherwise run :LspCopilotSignIn once.
--   Tab        accept suggestion (after completion menu / snippet jumps)
--   Alt-] / [  next / previous suggestion
--   Space uA   toggle suggestions
-- Disable entirely with vim.g.sungp_copilot = false in config/local.lua.
if vim.g.sungp_copilot == false or vim.fn.has("nvim-0.12") == 0 then
    return
end

local group = vim.api.nvim_create_augroup("SungpCopilot", { clear = true })
local warned = false

local function start()
    if vim.fn.executable("copilot-language-server") == 0 then
        if not warned then
            warned = true
            vim.notify(
                "Copilot: copilot-language-server is not installed yet (Mason installs it, or :MasonInstall copilot-language-server)",
                vim.log.levels.WARN
            )
        end
        return false
    end

    -- lsp/copilot.lua (cmd, sign-in commands) ships with nvim-lspconfig.
    pcall(require("lazy").load, { plugins = { "nvim-lspconfig" } })
    vim.lsp.config("copilot", {
        root_dir = function(bufnr, on_dir)
            if vim.b[bufnr].bigfile or vim.bo[bufnr].filetype == "bigfile" or vim.bo[bufnr].buftype ~= "" then
                return
            end
            on_dir(vim.fs.root(bufnr, { ".git" }))
        end,
        handlers = {
            didChangeStatus = function(err, result)
                if not err and result and result.status == "Error" and not warned then
                    warned = true
                    vim.notify(
                        "Copilot: " .. (result.message or "error") .. " — run :LspCopilotSignIn",
                        vim.log.levels.WARN
                    )
                end
            end,
        },
    })
    vim.lsp.enable("copilot")
    vim.lsp.inline_completion.enable(vim.g.sungp_copilot_enabled ~= false)
    return true
end

vim.api.nvim_create_autocmd("InsertEnter", {
    group = group,
    callback = function()
        vim.schedule(function()
            if start() then
                pcall(vim.api.nvim_del_augroup_by_id, group)
            end
        end)
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("SungpCopilotAttach", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client.name ~= "copilot" then
            return
        end
        for lhs, count in pairs({ ["<M-]>"] = 1, ["<M-[>"] = -1 }) do
            vim.keymap.set(
                "i",
                lhs,
                function()
                    vim.lsp.inline_completion.select({ count = count })
                end,
                { buffer = args.buf, desc = count > 0 and "Copilot: Next Suggestion" or "Copilot: Previous Suggestion" }
            )
        end
    end,
})

vim.keymap.set("n", "<leader>uA", function()
    local enabled = not vim.lsp.inline_completion.is_enabled()
    vim.g.sungp_copilot_enabled = enabled
    vim.lsp.inline_completion.enable(enabled)
    vim.notify("Copilot suggestions: " .. (enabled and "on" or "off"))
end, { desc = "UI: Toggle Copilot Suggestions" })
