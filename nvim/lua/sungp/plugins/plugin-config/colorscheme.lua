return {
    {
        "folke/tokyonight.nvim",
        name = "tokyonight",
        priority = 1000,
        opts = {
           transparent = true, 
        },
    },
    { 
        "olivercederborg/poimandres.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            transparent_background = true, 
        },
    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            --transparent = true
        }
    },
    {
        "shaunsingh/moonlight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.moonlight_disable_background = true
        end
    },
    {
	    "rose-pine/neovim",
	    lazy = false,
        priority = 1000,
        name = "rose-pine",
    },
    { 
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require('nightfox').setup({
                options = {
                     transparent = true;
                }
                           
            })     
        end
    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
        
        config = function()
            require('cyberdream').setup({
                transparent = true;
            })     
        end
    }
}
