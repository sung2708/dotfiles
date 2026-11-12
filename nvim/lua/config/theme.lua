local M = {}

-- Theme mặc định khi chưa chọn theme nào. Theme chọn bằng `Space ut` hoặc
-- `:colorscheme <tên>` được lưu lại và tự dùng cho lần mở sau.
-- `:ThemeReset` quay về theme này.
M.name = "kanagawa-wave"

M.state_file = vim.fs.joinpath(vim.fn.stdpath("state"), "sungp-colorscheme")
M.transparent_file = vim.fs.joinpath(vim.fn.stdpath("state"), "sungp-transparent")

-- Theme plugin name -> function(transparent), filled by plugins/themes.lua.
M.setups = {}

-- Variants that need `background=light`. Switching from one of these back to
-- a dark theme would otherwise leave 'background' light for themes that do
-- not set it themselves.
local light_variants = { "latte", "day", "dawn", "lotus", "light" }

local function is_light(name)
    for _, part in ipairs(light_variants) do
        if name:find(part, 1, true) then
            return true
        end
    end
    return false
end

-- Transparent background: `Space uT` toggles it and the choice is saved.
-- Before the first toggle, vim.g.sungp_transparent (config.local) decides;
-- the default is transparent.
do
    local file = io.open(M.transparent_file, "r")
    local value = file and vim.trim(file:read("*l") or "")
    if file then
        file:close()
    end
    if value == "1" or value == "0" then
        M.transparent = value == "1"
    else
        M.transparent = vim.g.sungp_transparent ~= false
    end
end

-- Light variants keep their own background: on a dark (or translucent)
-- terminal a transparent light theme is unreadable.
function M.transparent_for(name)
    return M.transparent and not is_light(name or "")
end

local function read_saved()
    local file = io.open(M.state_file, "r")
    if not file then
        return nil
    end
    local name = vim.trim(file:read("*l") or "")
    file:close()
    return name ~= "" and name or nil
end

local function write_saved(name)
    if not name or name == "" or name == M.saved then
        return
    end
    vim.fn.mkdir(vim.fs.dirname(M.state_file), "p")
    local file = io.open(M.state_file, "w")
    if file then
        file:write(name, "\n")
        file:close()
        M.saved = name
    end
end

local function get_hl(name)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    return ok and hl or {}
end

local function blend(a, b, t)
    if not a then
        return b
    end
    if not b then
        return a
    end
    local out = 0
    for shift = 16, 0, -8 do
        local ca, cb = bit.band(bit.rshift(a, shift), 0xff), bit.band(bit.rshift(b, shift), 0xff)
        out = out + bit.lshift(math.floor(ca + (cb - ca) * t + 0.5), shift)
    end
    return out
end

local function is_transparent()
    return get_hl("Normal").bg == nil
end

-- Colour for indent guides. Themes draw Whitespace just off their own
-- background; with a transparent editor the terminal shows through (e.g. a
-- translucent WezTerm) and the guides disappear. Move the colour towards
-- Comment in that case so guides stay visible but quieter than code.
-- vim.g.sungp_indent_guide_hl = "Comment" or "#585b70" overrides it.
function M.guide_color()
    local custom = vim.g.sungp_indent_guide_hl
    if type(custom) == "string" and custom ~= "" then
        if custom:sub(1, 1) == "#" then
            return tonumber(custom:sub(2), 16)
        end
        return get_hl(custom).fg
    end
    local whitespace = get_hl("Whitespace").fg or get_hl("NonText").fg
    if not is_transparent() then
        return whitespace
    end
    return blend(whitespace, get_hl("Comment").fg, 0.6)
end

function M.apply_ui_highlights()
    local normal = get_hl("Normal")
    local normal_float = get_hl("NormalFloat")
    local float_border = get_hl("FloatBorder")
    local float_title = get_hl("FloatTitle")
    local non_text = get_hl("NonText")

    -- Give every floating UI the editor's surface. NUI is used by Noice,
    -- Neo-tree and CodeCompanion, and some consumers use NormalFloat while
    -- others use Normal directly. Keeping NormalFloat on Normal's background
    -- removes a second, plugin-specific surface across all colorschemes.
    normal_float.fg = normal_float.fg or normal.fg
    normal_float.bg = normal.bg
    vim.api.nvim_set_hl(0, "NormalFloat", normal_float)

    float_border.fg = float_border.fg or non_text.fg or normal.fg
    float_border.bg = normal_float.bg
    vim.api.nvim_set_hl(0, "FloatBorder", float_border)

    float_title.fg = float_title.fg or get_hl("Title").fg or float_border.fg
    float_title.bg = normal_float.bg
    float_title.bold = true
    vim.api.nvim_set_hl(0, "FloatTitle", float_title)

    -- Split boundaries should be visible, but quieter than the active float
    -- outline. This is especially important between sidebars and the editor.
    vim.api.nvim_set_hl(0, "WinSeparator", {
        fg = non_text.fg or float_border.fg,
        bg = normal.bg,
    })

    local links = {
        -- Noice/NUI floats inherit the active colorscheme.
        NoiceCmdlinePopup = "NormalFloat",
        NoiceCmdlinePopupBorder = "FloatBorder",
        NoiceCmdlinePopupTitle = "FloatTitle",
        NoiceCmdlinePrompt = "Title",
        NoiceCmdlineIcon = "Special",
        NoiceConfirm = "NormalFloat",
        NoiceConfirmBorder = "FloatBorder",
        NoicePopup = "NormalFloat",
        NoicePopupBorder = "FloatBorder",
        -- Noice's popup menus are NUI windows too. Keep their normal rows on
        -- the editor surface while retaining PmenuSel for the active row.
        NoicePopupmenu = "Normal",
        NoicePopupmenuBorder = "WinSeparator",
        NoicePopupmenuMatch = "Special",
        NoicePopupmenuSelected = "PmenuSel",
        NoiceSplitBorder = "WinSeparator",
        NeoTreeNormal = "Normal",
        NeoTreeNormalNC = "NormalNC",
        NeoTreeFloatNormal = "NormalFloat",
        NeoTreeDirectoryName = "Directory",
        NeoTreeDirectoryIcon = "Directory",
        NeoTreeCursorLine = "CursorLine",
        NeoTreeEndOfBuffer = "EndOfBuffer",
        NeoTreeIndentMarker = "NonText",
        NeoTreeFloatBorder = "FloatBorder",
        NeoTreeFloatTitle = "FloatTitle",
        NeoTreeWinSeparator = "WinSeparator",
        NeoTreeVertSplit = "WinSeparator",

        -- FzfLua uses these groups for its main window, preview and border.
        FzfLuaNormal = "NormalFloat",
        FzfLuaBorder = "FloatBorder",
        FzfLuaTitle = "FloatTitle",
        FzfLuaPreviewNormal = "NormalFloat",
        FzfLuaPreviewBorder = "FloatBorder",
        FzfLuaPreviewTitle = "FloatTitle",
        FzfLuaCursorLine = "PmenuSel",
        FzfLuaSearch = "Search",
        FzfLuaFzfNormal = "NormalFloat",
        FzfLuaFzfCursorLine = "PmenuSel",
        FzfLuaFzfMatch = "Special",
        FzfLuaFzfBorder = "FloatBorder",
        FzfLuaFzfSeparator = "FloatBorder",
        FzfLuaFzfGutter = "NormalFloat",
        FzfLuaFzfPrompt = "Special",
        FzfLuaFzfPointer = "Special",

        -- Breadcrumb bar and its symbol menus.
        DropBarCurrentContext = "PmenuSel",
        DropBarCurrentContextIcon = "PmenuSel",
        DropBarCurrentContextName = "PmenuSel",
        DropBarHover = "Visual",
        DropBarIconKindDefault = "Special",
        DropBarIconKindDefaultNC = "WinBarNC",
        DropBarIconUIIndicator = "SpecialChar",
        DropBarIconUIPickPivot = "DiagnosticError",
        DropBarIconUISeparator = "NonText",
        DropBarIconUISeparatorMenu = "NonText",
        DropBarMenuCurrentContext = "PmenuSel",
        DropBarMenuFloatBorder = "FloatBorder",
        DropBarMenuNormalFloat = "NormalFloat",
        DropBarMenuSbar = "PmenuSbar",
        DropBarMenuThumb = "PmenuThumb",
        DropBarPreview = "Visual",

        -- Completion, documentation and signature-help windows.
        BlinkCmpMenu = "Pmenu",
        BlinkCmpMenuBorder = "FloatBorder",
        BlinkCmpMenuSelection = "PmenuSel",
        BlinkCmpDoc = "NormalFloat",
        BlinkCmpDocBorder = "FloatBorder",
        BlinkCmpDocSeparator = "FloatBorder",
        BlinkCmpDocCursorLine = "PmenuSel",
        BlinkCmpSignatureHelp = "NormalFloat",
        BlinkCmpSignatureHelpBorder = "FloatBorder",
        BlinkCmpLabelMatch = "Special",
        BlinkCmpScrollBarGutter = "PmenuSbar",
        BlinkCmpScrollBarThumb = "PmenuThumb",

        -- WhichKey and Snacks pickers use the same surface hierarchy.
        WhichKeyNormal = "NormalFloat",
        WhichKeyBorder = "FloatBorder",
        WhichKeyTitle = "FloatTitle",
        WhichKeySeparator = "NonText",
        SnacksPicker = "NormalFloat",
        SnacksPickerBorder = "FloatBorder",
        SnacksPickerTitle = "FloatTitle",
        SnacksPickerBox = "NormalFloat",
        SnacksPickerBoxBorder = "FloatBorder",
        SnacksPickerInput = "NormalFloat",
        SnacksPickerInputBorder = "FloatBorder",
        SnacksPickerList = "NormalFloat",
        SnacksPickerListBorder = "FloatBorder",
        SnacksPickerListCursorLine = "PmenuSel",
        SnacksPickerPreview = "NormalFloat",
        SnacksPickerPreviewBorder = "FloatBorder",
        SnacksPickerPreviewCursorLine = "CursorLine",

        -- Remaining floating and split-based plugin surfaces.
        LazyNormal = "NormalFloat",
        MasonNormal = "NormalFloat",
        DapUIFloatNormal = "NormalFloat",
        DapUIFloatBorder = "FloatBorder",
        NeotestBorder = "FloatBorder",
        NeotestFocused = "PmenuSel",
        NeotestFile = "Directory",
        NeotestDir = "Directory",
        NeotestIndent = "NonText",
        NeotestPassed = "DiagnosticOk",
        NeotestFailed = "DiagnosticError",
        NeotestRunning = "DiagnosticWarn",
        NeotestSkipped = "DiagnosticInfo",
        TroubleNormal = "NormalFloat",
        TroubleNormalNC = "NormalFloat",

        -- CodeCompanion uses semantic groups for chat, tools, and diffs.
        CodeCompanionChatError = "DiagnosticError",
        CodeCompanionChatFold = "Comment",
        CodeCompanionChatHeader = "Title",
        CodeCompanionChatInfo = "DiagnosticInfo",
        CodeCompanionChatSeparator = "WinSeparator",
        CodeCompanionChatSubtext = "Comment",
        CodeCompanionChatTokens = "Comment",
        CodeCompanionChatTool = "Special",
        CodeCompanionChatToolFailure = "DiagnosticError",
        CodeCompanionChatToolFailureIcon = "DiagnosticError",
        CodeCompanionChatToolGroup = "Constant",
        CodeCompanionChatToolInProgress = "DiagnosticInfo",
        CodeCompanionChatToolInProgressIcon = "DiagnosticInfo",
        CodeCompanionChatToolPending = "DiagnosticWarn",
        CodeCompanionChatToolPendingIcon = "DiagnosticWarn",
        CodeCompanionChatToolSuccess = "DiagnosticOk",
        CodeCompanionChatToolSuccessIcon = "DiagnosticOk",
        CodeCompanionChatToolText = "Comment",
        CodeCompanionChatEditorContext = "Identifier",
        CodeCompanionChatWarn = "DiagnosticWarn",
        CodeCompanionDiffAdd = "DiffAdd",
        CodeCompanionDiffDelete = "DiffDelete",
        CodeCompanionDiffText = "DiffText",
        CodeCompanionDiffTextDelete = "DiffDelete",
        CodeCompanionDiffBanner = "DiagnosticHint",
        CodeCompanionDiffBannerInline = "Comment",
        CodeCompanionCLIPath = "Include",
        CodeCompanionCodeReviewComment = "DiagnosticHint",
        CodeCompanionVirtualText = "Comment",
    }

    for group, link in pairs(links) do
        vim.api.nvim_set_hl(0, group, { link = link })
    end

    local pmenu = get_hl("Pmenu")
    local pmenu_sel = get_hl("PmenuSel")

    pmenu.fg = pmenu.fg or normal_float.fg
    pmenu.bg = pmenu.bg or normal_float.bg
    pmenu.blend = 0
    vim.api.nvim_set_hl(0, "Pmenu", pmenu)

    if not pmenu_sel.bg then
        local selection = get_hl("CursorLine")
        if not selection.bg then
            selection = get_hl("Visual")
        end
        pmenu_sel.bg = selection.bg
    end
    pmenu_sel.fg = pmenu_sel.fg or normal.fg or pmenu.fg
    pmenu_sel.blend = 0
    vim.api.nvim_set_hl(0, "PmenuSel", pmenu_sel)

    -- Notifications come from snacks.notifier, whose default links already
    -- follow Diagnostic* colours on a transparent float.

    -- Relative line numbers use the same faint colour as Whitespace in many
    -- themes; lift them when the terminal background shows through.
    -- Once per applied scheme: this function also runs again for the same
    -- scheme (Noice setup, toggles), and blending twice would drift.
    if is_transparent() and M.linenr_generation ~= M.generation then
        M.linenr_generation = M.generation
        local line_nr = get_hl("LineNr")
        line_nr.fg = blend(line_nr.fg, get_hl("Comment").fg, 0.5)
        vim.api.nvim_set_hl(0, "LineNr", line_nr)
        for _, group in ipairs({ "LineNrAbove", "LineNrBelow" }) do
            local hl = get_hl(group)
            if hl.fg then
                hl.fg = line_nr.fg
                vim.api.nvim_set_hl(0, group, hl)
            end
        end
    end

    local search_accent = get_hl("DiagnosticWarn").fg or float_border.fg
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderSearch", {
        fg = search_accent,
    })

    for _, group in ipairs({
        "NoiceMini",
        "NoiceCmdlinePopup",
        "NoiceCmdlinePopupBorder",
        "NoiceCmdlinePopupTitle",
        "NoiceCmdlinePopupBorderSearch",
        "NoiceConfirm",
        "NoiceConfirmBorder",
        "NoicePopup",
        "NoicePopupBorder",
        "NoicePopupmenu",
        "NoicePopupmenuBorder",
        "NoiceSplit",
        "NoiceSplitBorder",
    }) do
        local hl = get_hl(group)
        hl.bg, hl.ctermbg = normal.bg, normal.ctermbg
        vim.api.nvim_set_hl(0, group, hl)
    end
end

local group = vim.api.nvim_create_augroup("SungpThemeUI", { clear = true })

-- Neovim 0.12 ships its own `catppuccin`. lazy.nvim loads a theme plugin
-- only when the name is not already on 'runtimepath', so the built-in copy
-- would win. Find the plugin that provides the name so installed theme
-- plugins always take precedence over built-in schemes.
local providers = {}
local function find_provider(name)
    if providers[name] ~= nil then
        return providers[name] or nil
    end
    local ok, config = pcall(require, "lazy.core.config")
    providers[name] = false
    if ok then
        for _, plugin in pairs(config.plugins) do
            for _, ext in ipairs({ "lua", "vim" }) do
                if vim.uv.fs_stat(("%s/colors/%s.%s"):format(plugin.dir, name, ext)) then
                    providers[name] = plugin
                    return plugin
                end
            end
        end
    end
end

vim.api.nvim_create_autocmd("ColorSchemePre", {
    group = group,
    callback = function(args)
        local name = args.match or ""
        local background = is_light(name) and "light" or "dark"
        if vim.o.background ~= background then
            -- Setting 'background' re-sources the current scheme; the new one
            -- is about to load anyway, so skip that extra work.
            vim.g.colors_name = nil
            vim.o.background = background
        end

        M.pending = name
        local plugin = name ~= "" and find_provider(name)
        if not plugin then
            return
        end
        if plugin._.loaded then
            -- Re-run setup so transparency follows the toggle and the
            -- light/dark variant being applied.
            local setup = M.setups[plugin.name]
            if setup then
                pcall(setup, M.transparent_for(name))
            end
        else
            require("lazy").load({ plugins = { plugin.name } })
        end
    end,
})

-- The picker previews themes by applying them, so only the theme that is
-- still active a moment later (the confirmed one, or the original after
-- cancelling) is written.
local save_timer = assert(vim.uv.new_timer())
vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function(args)
        M.generation = (M.generation or 0) + 1
        M.current = args.match
        if M.loading then
            return
        end
        vim.schedule(M.apply_ui_highlights)
        save_timer:stop()
        save_timer:start(
            1000,
            0,
            vim.schedule_wrap(function()
                write_saved(M.current)
            end)
        )
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
        if save_timer:is_active() then
            save_timer:stop()
            write_saved(M.current)
        end
    end,
})

local function apply(name)
    return name and pcall(vim.cmd.colorscheme, name)
end

function M.load()
    M.saved = read_saved()
    M.loading = true
    if not apply(M.saved) and not apply(M.name) then
        vim.cmd.colorscheme("habamax")
    end
    M.loading = false
    M.apply_ui_highlights()
end

-- Colorscheme picker limited to installed theme plugins (Neovim's built-in
-- and mini.nvim demo schemes are hidden; `:colorscheme` still reaches them).
function M.pick()
    local runtime = vim.fs.normalize(vim.env.VIMRUNTIME)
    local seen = {}
    Snacks.picker.colorschemes({
        transform = function(item)
            local file = vim.fs.normalize(item.file)
            -- mini.nvim bundles demo schemes (minischeme, randomhue, ...).
            if seen[item.text] or file:find(runtime, 1, true) == 1 or file:find("/mini.nvim/", 1, true) then
                return false
            end
            seen[item.text] = true
        end,
    })
end

function M.toggle_transparent()
    M.transparent = not M.transparent
    vim.fn.mkdir(vim.fs.dirname(M.transparent_file), "p")
    local file = io.open(M.transparent_file, "w")
    if file then
        file:write(M.transparent and "1" or "0", "\n")
        file:close()
    end
    local current = M.current or vim.g.colors_name
    if current then
        M.loading = true
        vim.cmd.colorscheme(current)
        M.loading = false
        M.apply_ui_highlights()
    end
    vim.notify("Transparent background: " .. (M.transparent and "on" or "off"))
end

vim.api.nvim_create_user_command("ThemeTransparentToggle", M.toggle_transparent, {
    desc = "Toggle the transparent background for every theme",
})

vim.api.nvim_create_user_command("ThemeReset", function()
    save_timer:stop()
    os.remove(M.state_file)
    M.saved = nil
    M.loading = true
    vim.cmd.colorscheme(M.name)
    M.loading = false
    M.apply_ui_highlights()
    vim.notify("Theme reset to " .. M.name)
end, { desc = "Forget the saved theme and use the default" })

return M
