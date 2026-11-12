-- Colorschemes. Every theme is lazy: lazy.nvim sources a theme only when
-- `:colorscheme <name>` asks for it, so installing many costs no startup
-- time. config.theme restores the last theme you picked on the next start.
--
-- Each theme is set up through a function that takes `transparent`, so
-- config.theme can re-run it whenever a scheme is applied: `Space uT`
-- toggles transparency for every theme, and light variants (latte, day,
-- dawn, lotus, light) always get their own background so they stay readable
-- on a dark terminal.
local theme = require("config.theme")

local themes = {
    {
        "rebelot/kanagawa.nvim", -- kanagawa-wave / -dragon / -lotus
        setup = function(transparent)
            require("kanagawa").setup({ transparent = transparent })
        end,
    },
    {
        "catppuccin/nvim", -- catppuccin-mocha / -macchiato / -frappe / -latte
        name = "catppuccin",
        setup = function(transparent)
            require("catppuccin").setup({
                transparent_background = transparent,
                float = { transparent = transparent },
                -- Avoid invoking vim.pack.get() on Neovim 0.12. This repository
                -- uses lazy.nvim exclusively, and the probe creates an empty
                -- site/pack/core tree that both health checks report as a conflict.
                auto_integrations = false,
            })
        end,
    },
    {
        "folke/tokyonight.nvim", -- tokyonight-night / -storm / -moon / -day
        setup = function(transparent)
            local surface = transparent and "transparent" or "dark"
            require("tokyonight").setup({
                style = "night",
                transparent = transparent,
                styles = { sidebars = surface, floats = surface },
            })
        end,
    },
    {
        "rose-pine/neovim", -- rose-pine / rose-pine-moon / rose-pine-dawn
        name = "rose-pine",
        setup = function(transparent)
            require("rose-pine").setup({ styles = { transparency = transparent } })
        end,
    },
    {
        "EdenEast/nightfox.nvim", -- nightfox / carbonfox / duskfox / nordfox / terafox / dawnfox / dayfox
        setup = function(transparent)
            require("nightfox").setup({ options = { transparent = transparent } })
        end,
    },
    {
        "navarasu/onedark.nvim", -- onedark
        setup = function(transparent)
            require("onedark").setup({ style = "dark", transparent = transparent })
        end,
    },
    {
        "sainnhe/gruvbox-material", -- gruvbox-material
        setup = function(transparent)
            vim.g.gruvbox_material_background = "medium"
            vim.g.gruvbox_material_transparent_background = transparent and 1 or 0
            vim.g.gruvbox_material_enable_italic = 1
            vim.g.gruvbox_material_better_performance = 1
        end,
    },
    {
        "sainnhe/everforest", -- everforest
        setup = function(transparent)
            vim.g.everforest_background = "medium"
            vim.g.everforest_transparent_background = transparent and 1 or 0
            vim.g.everforest_enable_italic = 1
            vim.g.everforest_better_performance = 1
        end,
    },
    {
        "scottmckendry/cyberdream.nvim", -- cyberdream / cyberdream-light
        setup = function(transparent)
            require("cyberdream").setup({ transparent = transparent })
        end,
    },
    {
        "vague-theme/vague.nvim", -- vague
        setup = function(transparent)
            require("vague").setup({ transparent = transparent })
            -- vague's highlight modules keep the config from their first
            -- require; drop them so a changed setting is picked up.
            for module in pairs(package.loaded) do
                if module == "vague.highlights" or module:find("^vague%.groups") then
                    package.loaded[module] = nil
                end
            end
        end,
    },
    {
        "AlexvZyl/nordic.nvim", -- nordic
        setup = function(transparent)
            require("nordic").setup({ transparent = { bg = transparent, float = transparent } })
        end,
    },
    {
        "Mofiqul/vscode.nvim", -- vscode
        setup = function(transparent)
            require("vscode").setup({ transparent = transparent, color_overrides = {} })
        end,
    },
    {
        "Mofiqul/dracula.nvim", -- dracula / dracula-soft
        setup = function(transparent)
            require("dracula").setup({ transparent_bg = transparent })
        end,
    },
    {
        "craftzdog/solarized-osaka.nvim", -- solarized-osaka
        setup = function(transparent)
            require("solarized-osaka").setup({ transparent = transparent })
        end,
    },
}

local specs = {}
for _, entry in ipairs(themes) do
    local name = entry.name or entry[1]:match("[^/]+$")
    theme.setups[name] = entry.setup
    table.insert(specs, {
        entry[1],
        name = entry.name,
        lazy = true,
        config = function()
            entry.setup(theme.transparent_for(theme.pending))
        end,
    })
end

return specs
