local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
	'tsserver',
	'eslint',
	'lua_ls',
	'rust_analyzer',
	'cssls',
	'html',
	'jsonls',
	'elmls',
});

require'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
    },
  },
}

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
})

cmp.setup({
    mapping = cmp_mappings
})

lsp.on_attach(function (client, bufnr)
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set('n', '<leader>vr', function () vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
end)

-- lsp.setup_nvim_cmp({
--     mapping = cmp_mappings
-- })

lsp.setup()
