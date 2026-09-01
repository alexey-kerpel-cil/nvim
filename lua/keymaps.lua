-- my keymaps
-- vim.keymap.set("n", "<leader>tl", "<cmd>tabnext<CR>", { desc = "Switch to next tab" })
vim.keymap.set("n", "<leader>th", "<cmd>tabprevious<CR>", { desc = "[T]ab previous" })
vim.keymap.set("n", "<leader>tq", "<cmd>tabclose<CR>", { desc = "[T]ab [q]uit" })

vim.keymap.set({ "n", "v" }, "op", '"0p', { desc = "Paste from clipboard" })
-- vim.keymap.set({ "x", "n", "s" }, ":W", "<cmd>w<cr><esc>", { desc = "Save file" })

-- theme switching keymaps
vim.keymap.set("n", "<leader>td", "<cmd>set bg=dark<CR>", { desc = "[T]heme [D]ark" })
vim.keymap.set("n", "<leader>tl", "<cmd>set bg=light<CR>", { desc = "[T]heme [L]ight" })

-- move selected lines up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "which_key_ignore" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "which_key_ignore" })

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "which_key_ignore" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
