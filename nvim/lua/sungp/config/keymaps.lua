-- Close buffer without exiting Vim
vim.keymap.set('n', '<leader>bd', ':bp | sp | bn | bd<CR>', { silent = true })

-- Delete hightlight
vim.keymap.set("n", "<leader>h", ":noh<CR>", { silent = true })

-- Key mappings for window resizing
vim.keymap.set('n', '<M-Right>', ':vertical resize +1<CR>')
vim.keymap.set('n', '<M-Left>', ':vertical resize -1<CR>')
vim.keymap.set('n', '<M-Down>', ':resize +1<CR>')
vim.keymap.set('n', '<M-Up>', ':resize -1<CR>')

-- Move line or visually selected block - Alt+j/k
vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<CR>==gi')
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi')
vim.keymap.set('v', '<A-j>', ':m \'>+1<CR>gv=gv')
vim.keymap.set('v', '<A-k>', ':m \'<-2<CR>gv=gv')

-- Move split panes to left/bottom/top/right
vim.keymap.set('n', '<A-h>', '<C-W>H')
vim.keymap.set('n', '<A-j>', '<C-W>J')
vim.keymap.set('n', '<A-k>', '<C-W>K')
vim.keymap.set('n', '<A-l>', '<C-W>L')

-- Move between panes to left/bottom/top/right
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Open file in a text by placing text and gf
vim.keymap.set('n', 'gf', ':vert winc f<CR>')

-- Copies file path to clipboard by pressing yf
vim.keymap.set('n', 'yf', ':let @+=expand("%:p")<CR>', { silent = true })

-- Copies current working directory to clipboard
vim.keymap.set('n', 'yd', ':let @+=expand("%:p:h")<CR>', { silent = true })

-- Press 'ii' to exit Insert mode
vim.keymap.set('i', 'ii', '<Esc>')
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('i', 'kj', '<Esc>')

-- Use 'jk' or 'kj' in Visual mode to exit
vim.keymap.set('v', 'jk', '<Esc>')
vim.keymap.set('v', 'kj', '<Esc>')
