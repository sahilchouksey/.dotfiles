-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.2',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

-- use({
	-- 'rose-pine/neovim', as = 'rose-pine', config = function()
	-- 	vim.cmd('colorscheme rose-pine')
	-- end
-- })
use { "catppuccin/nvim", as = "catppuccin" }
  -- use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }
  use('nvim-treesitter/playground')
  use('ThePrimeagen/harpoon')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')


  use("theprimeagen/refactoring.nvim")
  use("nvim-treesitter/nvim-treesitter-context");

  use('jose-elias-alvarez/null-ls.nvim')
  use('MunifTanjim/prettier.nvim')


  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v2.x',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},             -- Required
		  {'williamboman/mason.nvim'},           -- Optional
		  {'williamboman/mason-lspconfig.nvim'}, -- Optional

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},     -- Required
		  {'hrsh7th/cmp-nvim-lsp'}, -- Required
		  {'L3MON4D3/LuaSnip'},     -- Required

          		  -- Autocompletion
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
      }
  }

  use("folke/zen-mode.nvim")
  use("github/copilot.vim")
  use("eandrju/cellular-automaton.nvim")
  use("laytan/cloak.nvim")

  -- From devaslife nvim config
  use('nvim-lualine/lualine.nvim') -- Statusline
  use('nvim-lua/plenary.nvim') -- Common utilities
  use('onsails/lspkind-nvim') -- vscode-like pictograms
  use('nvimdev/lspsaga.nvim') -- LSP UIs
  use('kyazdani42/nvim-web-devicons') -- File icons
  use('nvim-telescope/telescope-file-browser.nvim')
  use('windwp/nvim-autopairs')
  use('windwp/nvim-ts-autotag')
  use('norcalli/nvim-colorizer.lua')
  use 'DaikyXendo/nvim-material-icon'
  use "rafamadriz/friendly-snippets"
  use "fatih/vim-go"

  use {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  }

  use "jose-elias-alvarez/nvim-lsp-ts-utils"

  -- Using Packer:
  use 'Mofiqul/dracula.nvim'

  use {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
  }

  use {
  	"folke/tokyonight.nvim",
  	lazy = false,
  	priority = 1000,
  	opts = {},
  }

  use {
    "williamboman/mason.nvim",
    enable = true,
  }


  use {
    "lewis6991/gitsigns.nvim",
  }

  use "MunifTanjim/nui.nvim"

  use 'rcarriga/nvim-notify'

  use 'mfussenegger/nvim-dap'
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} }


  use {
      "ravibrock/spellwarn.nvim",
      event = "VeryLazy",
      config = true,
  }

  use {
	  "folke/trouble.nvim",
	  opts = {}, -- for default options, refer to the configuration section for custom setup.
	  cmd = "Trouble",
	  keys = {
	    {
	      "<leader>xx",
	      "<cmd>Trouble diagnostics toggle<cr>",
	      desc = "Diagnostics (Trouble)",
	    },
	    {
	      "<leader>xX",
	      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	      desc = "Buffer Diagnostics (Trouble)",
	    },
	    {
	      "<leader>cs",
	      "<cmd>Trouble symbols toggle focus=false<cr>",
	      desc = "Symbols (Trouble)",
	    },
	    {
	      "<leader>cl",
	      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	      desc = "LSP Definitions / references / ... (Trouble)",
	    },
	    {
	      "<leader>xL",
	      "<cmd>Trouble loclist toggle<cr>",
	      desc = "Location List (Trouble)",
	    },
	    {
	      "<leader>xQ",
	      "<cmd>Trouble qflist toggle<cr>",
	      desc = "Quickfix List (Trouble)",
	    },
	  },
	}

    use {
	  "NeogitOrg/neogit",
	  dependencies = {
	    "nvim-lua/plenary.nvim",         -- required
	    "sindrets/diffview.nvim",        -- optional - Diff integration

	    -- Only one of these is needed, not both.
	    "nvim-telescope/telescope.nvim", -- optional
	    "ibhagwan/fzf-lua",              -- optional
	  },
	  config = true
	}

    use {
        'barrett-ruth/import-cost.nvim',
        build = 'sh install.sh yarn',
        -- if on windows
        -- build = 'pwsh install.ps1 yarn',
        config = true
    }

end)
