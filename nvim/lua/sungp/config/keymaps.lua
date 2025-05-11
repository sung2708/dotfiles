-- Keymaps for closing buffers
vim.keymap.set('n', '<leader>bd', ':bp | sp | bn | bd<CR>', { silent = true, desc = 'Close buffer without exiting Vim' })

-- Keymaps for clearing search highlight
vim.keymap.set('n', '<leader>h', ':noh<CR>', { silent = true, desc = 'Delete highlight' })

-- Keymaps for window splits
vim.keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>sh', '<C-w>s', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make splits equal size' })
vim.keymap.set('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close current split' })

-- Keymaps for moving between window splits
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to the left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to the bottom window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to the top window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to the right window' })

-- Keymaps for moving window splits
vim.keymap.set('n', '<A-h>', '<C-w>H', { desc = 'Move split to the far left' })
vim.keymap.set('n', '<A-j>', '<C-w>J', { desc = 'Move split to the bottom' })
vim.keymap.set('n', '<A-k>', '<C-w>K', { desc = 'Move split to the top' })
vim.keymap.set('n', '<A-l>', '<C-w>L', { desc = 'Move split to the far right' })

-- Keymaps for resizing window splits
vim.keymap.set('n', '<M-Right>', ':vertical resize +1<CR>', { desc = 'Resize split wider' })
vim.keymap.set('n', '<M-Left>', ':vertical resize -1<CR>', { desc = 'Resize split narrower' })
vim.keymap.set('n', '<M-Down>', ':resize +1<CR>', { desc = 'Resize split taller' })
vim.keymap.set('n', '<M-Up>', ':resize -1<CR>', { desc = 'Resize split shorter' })

-- Move line or selected block up/down
vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { desc = 'Move current line down' })
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { desc = 'Move current line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selected lines up' })

-- Open file under cursor in vertical split
vim.keymap.set('n', 'gf', ':vert winc f<CR>', { desc = 'Open file under cursor vertically' })

-- Copy file path or working directory
vim.keymap.set('n', 'yf', ':let @+=expand("%:p")<CR>', { silent = true, desc = 'Copy file path to clipboard' })
vim.keymap.set('n', 'yd', ':let @+=expand("%:p:h")<CR>', { silent = true, desc = 'Copy directory path to clipboard' })

-- Quickly exit insert/visual mode
vim.keymap.set('i', 'ii', '<Esc>', { desc = 'Exit insert mode' })
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })
vim.keymap.set('i', 'kj', '<Esc>', { desc = 'Exit insert mode' })
vim.keymap.set('v', 'jk', '<Esc>', { desc = 'Exit visual mode' })
vim.keymap.set('v', 'kj', '<Esc>', { desc = 'Exit visual mode' })

