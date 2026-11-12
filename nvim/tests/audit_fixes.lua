-- nvim --headless -u NONE -i NONE -l tests/audit_fixes.lua
vim.opt.rtp:prepend(vim.fn.getcwd())
vim.g.mapleader = " "
vim.lsp.log.set_level(vim.log.levels.OFF)
local fixture = vim.fn.tempname() .. "-audit-fixes"
vim.env.XDG_STATE_HOME = fixture .. "/state"
vim.fn.mkdir(fixture .. "/.venv/bin", "p")
vim.fn.mkdir(fixture .. "/.venv/Scripts", "p")
vim.fn.writefile({}, fixture .. "/.venv/bin/python")
vim.fn.writefile({}, fixture .. "/.venv/Scripts/python.exe")

local ok, err = xpcall(function()
    local configs = { ts_ls = { root_dir = function() end } }
    vim.lsp.config = setmetatable(configs, {
        __call = function(_, name, value)
            configs[name] = value
        end,
    })
    vim.lsp.enable = function() end
    package.loaded["blink.cmp"] = {
        get_lsp_capabilities = function()
            return {}
        end,
    }
    package.loaded["mason-lspconfig"] = { setup = function() end }
    for _, enabled in ipairs({ false, true }) do
        vim.g.sungp_diagnostic_lines = enabled
        package.loaded["integrations.lsp"] = nil
        require("integrations.lsp")
        for _ = 1, 3 do
            local cfg = vim.diagnostic.config()
            if cfg.virtual_lines then
                assert(cfg.virtual_text.current_line == false)
            else
                assert(cfg.virtual_text.current_line == nil)
            end
            vim.fn.maparg(" uv", "n", false, true).callback()
        end
    end
    print("PASS diagnostics startup preferences and repeated toggles")

    local selected = fixture .. "/alternative/python"
    local notified = 0
    local client = {
        config = { root_dir = fixture, settings = { python = { pythonPath = selected } } },
        settings = { python = { pythonPath = selected } },
        notify = function()
            notified = notified + 1
        end,
    }
    configs.basedpyright.on_init(client)
    assert(client.settings.python.pythonPath == selected and notified == 0)
    client.settings, client.config.settings = {}, {}
    configs.basedpyright.on_init(client)
    assert(client.settings.python.pythonPath:find("/.venv/", 1, true) and notified == 1)
    print("PASS explicit Python interpreter wins; project .venv remains the fallback")

    vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/nvim-dap")
    package.loaded["dapui"] =
        { setup = function() end, open = function() end, close = function() end, toggle = function() end }
    package.loaded["nvim-dap-virtual-text"] = { setup = function() end }
    package.loaded["dap-go"] = { setup = function() end }
    local launch = {}
    local configured = false
    package.loaded["mason-nvim-dap"] = {
        setup = function(opts)
            opts.handlers[1]({ name = "python", configurations = { launch } })
        end,
        default_setup = function()
            configured = true
        end,
    }
    require("integrations.dap")
    assert(configured and type(launch.pythonPath) == "function")
    package.loaded["venv-selector"] = {
        python = function()
            return selected
        end,
    }
    assert(launch.pythonPath() == selected)
    selected = fixture .. "/environment-B/python"
    assert(launch.pythonPath() == selected)
    package.loaded["venv-selector"] = nil
    vim.env.VIRTUAL_ENV, vim.env.CONDA_PREFIX = fixture .. "/environment-C", nil
    assert(launch.pythonPath():find("environment-C", 1, true))
    vim.env.VIRTUAL_ENV, vim.env.CONDA_PREFIX = nil, fixture .. "/environment-D"
    assert(launch.pythonPath():find("environment-D", 1, true))
    local has = vim.fn.has
    vim.fn.has = function(name)
        return name == "win32" and 1 or has(name)
    end
    assert(launch.pythonPath() == fixture .. "/environment-D/python.exe")
    vim.env.VIRTUAL_ENV = fixture .. "/environment-C"
    assert(launch.pythonPath() == fixture .. "/environment-C/Scripts/python.exe")
    vim.fn.has = has
    vim.env.VIRTUAL_ENV = nil
    vim.env.CONDA_PREFIX = nil
    assert(
        launch.pythonPath()
            == (vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or vim.fn.exepath("python"))
    )
    print("PASS Python debugger resolves the interpreter on each launch")

    local theme = require("config.theme")
    for _, bg in ipairs({ 0xeeeeee, 0x222222, false }) do
        vim.api.nvim_set_hl(0, "Normal", { fg = 0x888888, bg = bg or nil })
        theme.apply_ui_highlights()
        for _, name in ipairs({ "NoiceMini", "NoicePopup", "NoiceCmdlinePopup", "NoiceCmdlinePopupBorderSearch" }) do
            assert(vim.api.nvim_get_hl(0, { name = name, link = false }).bg == (bg or nil), name)
        end
    end
    print("PASS Noice follows light, dark and transparent backgrounds")
end, debug.traceback)

vim.fn.delete(fixture, "rf")
if not ok then
    io.stderr:write(err .. "\n")
    vim.cmd.cquit(1)
end
