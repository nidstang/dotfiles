vim.api.nvim_set_keymap(
    "v",
    "<leader>rr",
    ":lua require('refactoring').select_refactor()<CR>",
    { noremap = true, silent = true, expr = false }
)

vim.api.nvim_set_keymap("n", "<leader>lv", ":lua require('refactoring').debug.print_var({ normal = true })<CR>", { noremap = true })
