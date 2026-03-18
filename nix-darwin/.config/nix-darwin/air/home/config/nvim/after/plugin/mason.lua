require("mason").setup();
require("mason-lspconfig").setup({
    ensure_installed = { "ts_ls", "eslint", "rust_analyzer", "html", "cssls", "lua_ls" },
    -- handlers = {
    --     function(server_name)
    --       vim.lsp.config[server_name].setup({});
    --       -- require('lspconfig')[server_name].setup({})
    --     end,
    --   }
});
