-- General settings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.autoformat = true -- LazyVim auto format

local opt = vim.opt

-- Enable line numbers and relative line numbers
opt.number = true
opt.relativenumber = true

-- Display current mode in the statusline
opt.showmode = false -- Disabled since the statusline generally handles this

-- Highlight current line
opt.cursorline = true

-- Enable 24-bit RGB color in the terminal
opt.termguicolors = true

-- Set encoding to UTF-8
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Indentation settings
opt.shiftwidth = 4 -- Size of an indent
opt.tabstop = 4 -- Number of spaces tabs count for
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = true -- Insert indents automatically

-- Clipboard
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

-- Scrolling context
opt.scrolloff = 4
opt.sidescrolloff = 8

-- Status line
opt.laststatus = 3 -- Use a global status line

-- Wrapping
opt.wrap = false -- Disable line wrap
opt.linebreak = true -- Wrap at convenient points if wrap is enabled

-- Search
opt.ignorecase = true -- Ignore case in searches
opt.smartcase = true -- Override ignorecase if search contains capitals
opt.incsearch = true -- Incremental search
opt.hlsearch = true -- Highlight search results

-- Backup and undo
opt.backup = false -- Disable backup
opt.undofile = true -- Persistent undo
opt.undolevels = 10000

-- Command line and popup
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.completeopt = "menu,menuone,noselect" -- Completion options

-- Mouse
opt.mouse = "a" -- Enable mouse mode

-- Splits
opt.splitright = true -- Put new windows to the right
opt.splitbelow = true -- Put new windows below

-- Folding
opt.foldlevel = 99 -- Open all folds by default
opt.foldmethod = "indent" -- Use indentation for folding
if vim.fn.has("nvim-0.10") == 1 then
  opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
end

-- Other
opt.confirm = true -- Confirm before quitting unsaved changes
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Timeout for key sequences
opt.updatetime = 200 -- Faster swap file writes
opt.virtualedit = "block" -- Allow cursor beyond the end of lines in visual block mode
opt.fillchars = { fold = " ", eob = " ", diff = "╱" } -- Customize UI elements

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Syntax and filetype
vim.cmd("syntax on")
vim.cmd("filetype indent on")
vim.cmd("filetype plugin on")
vim.cmd("filetype on")

-- Enable cursor column (highlighting the column where the cursor is)
opt.cursorcolumn = true
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
