return{
  'windwp/nvim-autopairs',
  event = "InsertEnter",
  config = true,
  -- use opts = {} for passing setup options
  -- this is equivalent to setup({}) function

  -- nvim-autopairs setup
  config = function()
    local npairs = require("nvim-autopairs")
    npairs.setup({
      check_ts = true,  -- Use Treesitter for better context-aware pairing
      fast_wrap = {     -- Enable fast wrapping functionality
        map = '<M-e>',   -- Default key mapping for wrapping
        chars = { '{', '[', '(', '"', "'", '`', '<' },  -- Characters to wrap
        pattern = string.gsub([[ [%'%)%>%]%)%}%,] ]], '%s+', ''),
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'PmenuSel',
        highlight_grey = 'LineNr',
      },
    })

    -- nvim-autopairs integration with nvim-cmp
    -- Ensures that completing a suggestion also closes the corresponding pair if applicable
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end
}
