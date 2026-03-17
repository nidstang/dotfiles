local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
        "nvim-telescope/telescope.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
    },

    {
        "kdheepak/lazygit.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
    },
    {
      "datsfilipe/vesper.nvim"
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
          local configs = require("nvim-treesitter.configs")

          configs.setup({
              ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
              sync_install = false,
              highlight = { enable = true },
              indent = { enable = true },
            })
        end
    },

    {"ThePrimeagen/harpoon"},

    {"mbbill/undotree"},

    {"tpope/vim-fugitive"},

    {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {
            disable_filetype = { "markdown" },
            enable_check_bracket_line = false,
        } end
    },
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim"},
    {"neovim/nvim-lspconfig"},
    {"hrsh7th/cmp-nvim-lsp"},
    {"hrsh7th/nvim-cmp"},
    {"greggh/claude-code.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim", -- Required for git operations
      },
      config = function()
        require("claude-code").setup()
      end
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        delay = 500,
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    },   
    {
      "NickvanDyke/opencode.nvim",
      dependencies = {
        -- Recommended for `ask()` and `select()`.
        -- Required for `snacks` provider.
        ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
        { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
      },
      config = function()
        ---@type opencode.Opts
        vim.g.opencode_opts = {
          -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
        }

        -- Required for `opts.events.reload`.
        vim.o.autoread = true

        -- Recommended/example keymaps.
        local function is_opencode_buffer()
          return vim.bo.filetype == "opencode" or vim.bo.buftype == "terminal"
        end

        vim.keymap.set({ "n", "x" }, "<leader>oa", function()
          if not is_opencode_buffer() then
            require("opencode").ask("@this: ", { submit = true })
          end
        end, { desc = "Ask opencode…" })
        vim.keymap.set({ "n", "x" }, "<leader>os", function()
          if not is_opencode_buffer() then
            require("opencode").select()
          end
        end, { desc = "Execute opencode action…" })
        vim.keymap.set({ "n", "t" }, "<leader>ot", function()
          if not is_opencode_buffer() then
            require("opencode").toggle()
          end
        end, { desc = "Toggle opencode" })

        vim.keymap.set({ "n", "x" }, "go",  function()
          if not is_opencode_buffer() then
            return require("opencode").operator("@this ")
          end
        end, { desc = "Add range to opencode", expr = true })
        vim.keymap.set("n",          "goo", function()
          if not is_opencode_buffer() then
            return require("opencode").operator("@this ") .. "_"
          end
        end, { desc = "Add line to opencode", expr = true })

        vim.keymap.set("n", "<leader>ok", function()
          if not is_opencode_buffer() then
            require("opencode").command("session.half.page.up")
          end
        end, { desc = "Scroll opencode up" })
        vim.keymap.set("n", "<leader>oj", function()
          if not is_opencode_buffer() then
            require("opencode").command("session.half.page.down")
          end
        end, { desc = "Scroll opencode down" })

        vim.keymap.set("n", "<leader>of", function()
          if not is_opencode_buffer() then
            vim.cmd("wincmd w")
          end
        end, { desc = "Focus opencode window" })
      end,
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true, notify = false },
}, {
    lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
})
