local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()


vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use {
        "ThePrimeagen/refactoring.nvim",
        requires = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-treesitter/nvim-treesitter"}
        }
    }

    use {
      "loctvl842/monokai-pro.nvim",
      config = function()
        require("monokai-pro").setup()
      end
    }

    use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use({
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        requires = "nvim-treesitter/nvim-treesitter",
    })
    use ('ThePrimeagen/harpoon')
    use ('mbbill/undotree')
    use ('tpope/vim-fugitive')
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {
            disable_filetype = { "markdown" },
            enable_check_bracket_line = false,
        } end
    }

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {                                      -- Optional
            'williamboman/mason.nvim',
            run = function()
                pcall(vim.cmd, 'MasonUpdate')
            end,
        },
        {'williamboman/mason-lspconfig.nvim'}, -- Optional

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},     -- Required
        {'hrsh7th/cmp-nvim-lsp'}, -- Required
        {'L3MON4D3/LuaSnip'},     -- Required
    }
}

-- use 'ThePrimeagen/vim-be-good'

use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
}

use({
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    requires = {
        "nvim-lua/plenary.nvim",
    },
})

use({
  "epwalsh/obsidian.nvim",
  tag = "*",  -- recommended, use latest release instead of latest commit
  requires = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
})

use({
  "epwalsh/pomo.nvim",
  tag = "*",  -- Recommended, use latest release instead of latest commit
  requires = {
    -- Optional, but highly recommended if you want to use the "Default" timer
    "rcarriga/nvim-notify",
  },
  config = function()
    require("pomo").setup({
      -- See below for full list of options 👇
    })
  end,
})

-- use {
--     'folke/flash.nvim',
--     opts = {},
-- }

if packer_bootstrap then
    require('packer').sync()
  end

end)
