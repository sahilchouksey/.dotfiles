-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

local plugins = {
    -- Packer can manage itself (optional)
    "wbthomason/packer.nvim",


    -- Markdown preview plugin
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },

    {
        "vhyrro/luarocks.nvim",
        priority = 1000, -- Must run first.
        config = true,
    },

    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.2",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- { 'rose-pine/neovim', name = 'rose-pine', config = function() vim.cmd('colorscheme rose-pine') end },
    {
        "banjo/contextfiles.nvim",
    },


    {
        "catppuccin/nvim",
        name = "catppuccin",
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
    },

    "nvim-treesitter/playground",
    "ThePrimeagen/harpoon",
    "mbbill/undotree",
    "tpope/vim-fugitive",
    "theprimeagen/refactoring.nvim",
    "nvim-treesitter/nvim-treesitter-context",
    --"jose-elias-alvarez/null-ls.nvim",
    "MunifTanjim/prettier.nvim",

    { 'wakatime/vim-wakatime', lazy = false },

    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },

    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            local lspconfig = require('lspconfig')
            local util = require('lspconfig/util')

            lsp_zero.on_attach(function(client, bufnr)
                local opts = { buffer = bufnr }
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            end)

            require('mason-lspconfig').setup({
                ensure_installed = {
                    'gopls',
                    'ts_ls',
                    'eslint',
                    'rust_analyzer',
                    'biome',
                    'pyright'
                },
                automatic_installation = false,
                automatic_enable = false,
                handlers = {
                    lsp_zero.default_setup,

                    gopls = function()
                        lspconfig.gopls.setup({
                            settings = {
                                gopls = {
                                    analyses = { unusedparams = true, shadow = true },
                                    staticcheck = true,
                                    completeUnimported = true,
                                    usePlaceholders = true,
                                },
                            },
                            flags = { debounce_text_changes = 150 },
                        })
                    end,

                    ts_ls = function()
                        lspconfig.ts_ls.setup({
                            on_attach = function(client, bufnr)
                                client.server_capabilities.document_formatting = false
                                client.server_capabilities.documentRangeFormattingProvider = false

                                local ok, ts_utils = pcall(require, "nvim-lsp-ts-utils")
                                if ok then
                                    ts_utils.setup({
                                        eslint_enable_code_actions = true,
                                        eslint_enable_disable_comments = true,
                                        eslint_bin = "eslint",
                                        eslint_config_fallback = nil,
                                        eslint_enable_diagnostics = true,
                                    })
                                    ts_utils.setup_client(client)
                                end
                            end
                        })
                    end,

                    biome = function()
                        lspconfig.biome.setup({
                            on_attach = function(client, bufnr)
                                if client.name == "biome" then
                                    client.server_capabilities.document_formatting = false
                                end
                            end,
                            root_dir = util.root_pattern('biome.json', 'package.json'),
                        })
                    end,

                    pyright = function() end,
                },
            })
        end,
    },


    "folke/zen-mode.nvim",
    "github/copilot.vim",
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end
    },
    {
        "ravitemer/mcphub.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
        },
        -- uncomment the following line to load hub lazily
        --cmd = "MCPHub",  -- lazy load
        build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
        -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
        -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
        config = function()
            require("mcphub").setup({
                -- port, auto_approve, etc. all optional
                extensions = {
                    copilotchat = {
                        make_slash_commands = true, -- transforms MCP prompts into /prompt commands
                    },
                },
            })
        end,
    },
    ----  {
    ----    "yetone/avante.nvim",
    ----    event = "VeryLazy",
    ----    version = false, -- Never set this value to "*"! Never!
    ----    opts = {
    ----		system_prompt = function()
    ----			local hub = require("mcphub").get_hub_instance()
    ----			return hub:get_active_servers_prompt()
    ----		end,
    ----		-- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
    ----		-- This function defines custom tools available to the Avante plugin.
    ----		-- It integrates with MCPHub to provide additional functionalities by returning a list of tool definitions.
    ----		custom_tools = function()
    ----			return {
    ----				require("mcphub.extensions.avante").mcp_tool(), -- Provides the mcp_tool for Avante
    ----			}
    ----		end,
    ----		-- add any opts here
    ----		-- for example
    ----		provider = "gemini-2.5-pro",
    ----		cursor_applying_provider = 'gemini-2.0-flash',
    ----		mode = "agentic",
    ----		auto_suggestion_providor = "gemini-2.5-pro",
    ----		-- gemini = {
    ----		-- 	-- endpoint = "https://api.openai.com/v1",
    ----		-- 	model = "gemini-2.5-flash-preview-04-17", -- your desired model (or use gpt-4o, etc.)
    ----		-- 	-- timeout = 30000,        -- Timeout in milliseconds, increase this for reasoning models
    ----		-- 	-- temperature = 0,
    ----		-- 	-- max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
    ----		-- 	--reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
    ----		-- },
    ----		-- copilot = {
    ----		-- endpoint = "https://api.githubcopilot.com",
    ----		-- model = "gpt-4o-2024-11-20",
    ----		-- proxy = nil,    -- [protocol://]host[:port] Use this proxy
    ----		-- allow_insecure = false, -- Allow insecure server connections
    ----		-- timeout = 30000, -- Timeout in milliseconds
    ----		-- temperature = 0,
    ----		-- max_tokens = 20480,
    ----		-- },
    ----		vendors = {
    ----			["claude-3.7"] = {
    ----				__inherited_from = "copilot",
    ----				display_name = "copilot/claude-3.7",
    ----				model = "claude-3.7-sonnet",
    ----			},
    ----			["gemini-2.5-pro"] = {
    ----				__inherited_from = "copilot",
    ----				display_name = "copilot/gemini-2.5-pro",
    ----				model = "gemini-2.5-pro",
    ----				disabled_tools = true,
    ----			},
    ----			["gemini-2.0-flash"] = {
    ----				__inherited_from = "copilot",
    ----				display_name = "copilot/gemini-2.0-flash",
    ----				model = "gemini-2.0-flash",
    ----				disabled_tools = true,
    ----			},
    ----		},
    ----		behaviour = {
    ----			enable_cursor_planning_mode = true,
    ----			auto_focus_sidebar = true,
    ----			auto_suggestions = true, -- Experimental stage
    ----			auto_suggestions_respect_ignore = false,
    ----			auto_set_highlight_group = true,
    ----			auto_set_keymaps = true,
    ----			auto_apply_diff_after_generation = true,
    ----			jump_result_buffer_on_finish = false,
    ----			support_paste_from_clipboard = false,
    ----			minimize_diff = true,
    ----			enable_token_counting = true,
    ----			use_cwd_as_project_root = false,
    ----			auto_focus_on_diff_view = false,
    ----		},
    ----		windows = {
    ----			edit = {
    ----				border = "rounded",
    ----				start_insert = false, -- Start insert mode when opening the edit window
    ----			},
    ----			ask = {
    ----				floating = false, -- Open the 'AvanteAsk' prompt in a floating window
    ----				start_insert = false, -- Start insert mode when opening the ask window
    ----				border = "rounded",
    ----				---@type "ours" | "theirs"
    ----				focus_on_apply = "ours", -- which diff to focus after applying
    ----			},
    ----		},
    ----      web_search_engine = {
    ----    provider = "tavily",
    ----    -- Pass Tavily-specific options:
    ----    tavily = {
    ----      timeout = 60000,      -- 60 s instead of 10 s :contentReference[oaicite:3]{index=3}
    ----      extract_depth = "basic",
    ----      include_domains = {},
    ----      exclude_domains = {},
    ----    },
    ----  },
    ----
    ----	},
    ----    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    ----    build = "make",
    ----    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    ----    dependencies = {
    ----      "nvim-treesitter/nvim-treesitter",
    ----      "stevearc/dressing.nvim",
    ----      "nvim-lua/plenary.nvim",
    ----      "MunifTanjim/nui.nvim",
    ----      --- The below dependencies are optional,
    ----      "echasnovski/mini.pick", -- for file_selector provider mini.pick
    ----      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    ----      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    ----      "ibhagwan/fzf-lua", -- for file_selector provider fzf
    ----      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    ----      "zbirenbaum/copilot.lua", -- for providers='copilot'
    ----      {
    ----        -- support for image pasting
    ----        "HakonHarnes/img-clip.nvim",
    ----        event = "VeryLazy",
    ----        opts = {
    ----          -- recommended settings
    ----          default = {
    ----            embed_image_as_base64 = false,
    ----            prompt_for_file_name = false,
    ----            drag_and_drop = {
    ----              insert_mode = true,
    ----            },
    ----            -- required for Windows users
    ----            use_absolute_path = true,
    ----          },
    ----        },
    ----      },
    ----      {
    ----        -- Make sure to set this up properly if you have lazy=true
    ----        'MeanderingProgrammer/render-markdown.nvim',
    ----        opts = {
    ----          file_types = { "markdown", "Avante" },
    ----        },
    ----        ft = { "markdown", "Avante" },
    ----      },
    ----    },
    ----  },
    "eandrju/cellular-automaton.nvim",
    "laytan/cloak.nvim",

    -- From devaslife nvim config
    "nvim-lualine/lualine.nvim",    -- Statusline
    "nvim-lua/plenary.nvim",        -- Common utilities
    "onsails/lspkind-nvim",         -- vscode-like pictograms
    "nvimdev/lspsaga.nvim",         -- LSP UIs
    "kyazdani42/nvim-web-devicons", -- File icons
    "nvim-telescope/telescope-file-browser.nvim",
    "windwp/nvim-autopairs",
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require('nvim-ts-autotag').setup()
        end,
    },
    "norcalli/nvim-colorizer.lua",
    "DaikyXendo/nvim-material-icon",
    "rafamadriz/friendly-snippets",
    "fatih/vim-go",

    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "main",
        dependencies = {
            "zbirenbaum/copilot.lua", -- or github/copilot.vim
            "nvim-lua/plenary.nvim",  -- for curl, log wrapper
        },
        opts = {
            debug = true, -- Enable debugging; adjust as needed.
        },
    },

    "jose-elias-alvarez/nvim-lsp-ts-utils",
    "Mofiqul/dracula.nvim",

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },


    {
        "lewis6991/gitsigns.nvim",
    },

    "MunifTanjim/nui.nvim",

    {
        "rcarriga/nvim-notify",
        lazy = false,
    },

    "mfussenegger/nvim-dap",
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    },

    {
        "folke/trouble.nvim",
        opts = {},
        cmd = "Trouble",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)" },
            { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location List (Trouble)" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix List (Trouble)" },
        },
    },

    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",        -- optional - Diff integration
            "nvim-telescope/telescope.nvim", -- optional
            "ibhagwan/fzf-lua",              -- optional
        },
        config = true,
    },

    {
        "barrett-ruth/import-cost.nvim",
        build = "sh install.sh yarn",
        -- For Windows, you might use: build = "pwsh install.ps1 yarn",
        config = true,
    },

    {
        "allaman/emoji.nvim",
        version = "1.0.0",                   -- Optionally pin to a tag.
        ft = "markdown",                     -- Adjust filetype as needed.
        dependencies = {
            "hrsh7th/nvim-cmp",              -- Optional for nvim-cmp integration
            "nvim-telescope/telescope.nvim", -- Optional for telescope integration
        },
        opts = {
            enable_cmp_integration = true,
            plugin_path = vim.fn.expand("$HOME/plugins/"),
        },
        config = function(_, opts)
            require("emoji").setup(opts)
            local ts = require("telescope").load_extension("emoji")
            vim.keymap.set("n", "<leader>em", ts.emoji, { desc = "[S]earch [E]moji" })
        end,
    },

    {
        "kdheepak/lazygit.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    {
        "nvim-orgmode/orgmode",
        config = function()
            require("orgmode").setup {}
        end,
    },

    {
        "danymat/neogen",
        config = function()
            require("neogen").setup {}
        end,
        -- Uncomment the next line to follow only stable versions:
        -- tag = "*",
    },
    {
        "quentingruber/pomodoro.nvim",
        lazy = false, -- needed so the pomodoro can start at launch
        opts = {
            start_at_launch = true,
            work_duration = 25,
            break_duration = 5,
            delay_duration = 1, -- The additionnal work time you get when you delay a break
            long_break_duration = 15,
            breaks_before_long = 4,
        },
    },

    -- Python Development Enhancement Plugins
    {
        "mfussenegger/nvim-dap-python",
        dependencies = { "mfussenegger/nvim-dap" },
        ft = "python",
        config = function()
            require("dap-python").setup("python")
        end,
    },

    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                python = { "black", "isort" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        },
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                python = { "flake8" },
            }
            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                        },
                    },
                },
            })
        end,
    },

    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                        runner = "pytest",
                    }),
                },
            })
        end,
    },

    -- Add LuaSnip for snippets
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },

    -- nvim-cmp configuration
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                }),
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
            })
        end,
    },


}

require("lazy").setup(plugins)
