return {
    "kylechui/nvim-surround",
    event = { "BufReadPre", "BufNewFile" },
    version = "*",
    config = true,

    setup = function()
        vim.keymap.set("n", "ys", "<Plug>(textobj-sentence)", { noremap = true })
    end,
}
