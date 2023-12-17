vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move blocks in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keeps the cursor in same position when I go J
vim.keymap.set("n", "J", "mzJ`z")

-- better page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- improve cursor behaviour at searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- sends the delete in copy to void
vim.keymap.set("x", "<leader>p", "\"_dP")

-- save current file
vim.keymap.set("n", "<leader><leader>", ":w<CR>")

-- copy to clipboard
vim.keymap.set("x", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>P", "\"+p")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww ~/.local/bin/tmux-sessionizer<CR>")

-- lsp format
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format);

-- esc with jj stroke 
vim.keymap.set("i", "jj", "<Esc>");

-- keep in visual mode when I do > or < (this is amazing)
vim.keymap.set("v", ">", ">gv");
vim.keymap.set("v", "<", "<gv");

-- enter to insert 
vim.keymap.set("n", "<CR>", "ciw");

vim.keymap.set("n", "<C-i>", "<C-a>");


-- diagnostics
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float);

vim.keymap.set("n", "gd", vim.lsp.buf.definition)

-- brackets motions
-- move between buffers
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", {
    desc = "Prev buffer",
})

vim.keymap.set("n", "]b", "<cmd>bnext<cr>", {
    desc = "Next buffer",
})
-- end move between buffers
