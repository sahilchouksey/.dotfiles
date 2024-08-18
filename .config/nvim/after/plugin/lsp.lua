local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  'gopls',
  'tsserver',
  'eslint',
  'rust_analyzer',
})
-- Fix Undefined global 'vim'
lsp.nvim_workspace()


-- LSP Config
local lspconfig = require('lspconfig')
local util = require('lspconfig/util')
local capabilities = vim.lsp.protocol.make_client_capabilities()
local on_attach = function(client, bufnr)
  client.resolved_capabilities.document_formatting = false
end

lspconfig.gopls.setup({
  cmd = {"gopls", "serve"},
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,

      },
      staticcheck = true,
      completeUnimported = true,
      usePlaceholders = true,
    },
  },
  filetypes = {"go", "gomod", "gowork"},
  root_dir = util.root_pattern("go.mod", "go.work", ".git"),
    on_attach = on_attach,
    capabilities = capabilities,

})


lspconfig.tsserver.setup {
  on_attach = function(client)
    -- disable tsserver formatting if you plan on using eslint
    client.resolved_capabilities.document_formatting = false

    local ts_utils = require("nvim-lsp-ts-utils")

    -- defaults
    ts_utils.setup {
      eslint_enable_code_actions = true,
      eslint_enable_disable_comments = true,
      eslint_bin = "eslint",
      eslint_config_fallback = nil,
      eslint_enable_diagnostics = true,
    }

    -- Adding javascript and typescript to the filetypes
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false


    -- required to fix code action ranges
    ts_utils.setup_client(client)
  end
}


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})


