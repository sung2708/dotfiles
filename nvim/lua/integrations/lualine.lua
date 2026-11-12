local function lsp_clients()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        return ""
    end

    local names = {}
    local seen = {}
    for _, client in ipairs(clients) do
        if not seen[client.name] then
            seen[client.name] = true
            table.insert(names, client.name)
        end
    end
    table.sort(names)
    return "󰒋 " .. table.concat(names, ",")
end

-- LSP progress ("Indexing 42%", "Loading workspace") while servers work;
-- Noice's own progress view is off, so this is the only place it shows.
local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local function lsp_progress()
    local status = vim.lsp.status()
    if status == "" then
        return ""
    end
    local frame = spinner[math.floor(vim.uv.hrtime() / 1e8) % #spinner + 1]
    status = status:gsub("%%", "%%%%")
    if vim.fn.strchars(status) > 40 then
        status = vim.fn.strcharpart(status, 0, 39) .. "…"
    end
    return frame .. " " .. status
end

vim.api.nvim_create_autocmd("LspProgress", {
    group = vim.api.nvim_create_augroup("SungpLualineLspProgress", { clear = true }),
    callback = function()
        require("lualine").refresh({ place = { "statusline" } })
    end,
})

local function python_venv()
    if vim.bo.filetype ~= "python" then
        return ""
    end

    local selector = package.loaded["venv-selector"]
    if not selector then
        return ""
    end

    local path = selector.venv()
    if not path or path == "" then
        return ""
    end

    return "󰌠 " .. vim.fn.fnamemodify(path, ":t")
end

-- Branch and diff come from gitsigns' buffer cache. Lualine's own "branch"
-- and "diff" components walk the filesystem and spawn `git diff` on every
-- BufEnter (~3 ms per buffer switch); gitsigns already has the data.
local function git_branch()
    local head = vim.b.gitsigns_head or vim.g.gitsigns_head
    return head and head ~= "" and (" " .. head) or ""
end

local function git_diff()
    local status = vim.b.gitsigns_status_dict
    if status then
        return { added = status.added, modified = status.changed, removed = status.removed }
    end
end

require("lualine").setup({
    options = {
        globalstatus = true,
        refresh = {
            refresh_time = 100,
        },
        theme = "auto",
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
    },
    sections = {
        lualine_b = { git_branch, { "diff", source = git_diff } },
        lualine_c = {
            { "filename", path = 0 },
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
            },
        },
        lualine_x = {
            lsp_progress,
            python_venv,
            lsp_clients,
            "encoding",
            "fileformat",
            "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    extensions = {
        "fugitive",
        "neo-tree",
        "quickfix",
        "toggleterm",
        "trouble",
    },
    inactive_sections = {
        lualine_c = { { "filename", path = 0 } },
        lualine_x = { "location" },
    },
})
