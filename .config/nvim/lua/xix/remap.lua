vim.g.mapleader = " "
-- My Keybindings
-- Used to make Code Prettier
vim.keymap.set("v", "esm", ":s/const \\(.*\\) = require(\\(.*\\))/import \\1 from \\2")
vim.keymap.set("n", "<leader>'", vim.cmd.Prettier)
-- Ctrl + s to save file (fast save without extra formatting)
vim.keymap.set("n", "<C-s>", function()
    vim.cmd("write")
end)

--vim.keymap.set("n", "<C-s>", [[:write<Bar>Prettier<CR>]])
-- vim.keymap.set("i", "<C-s>", [[<C-c>:write<Bar>Prettier<CR>]])


vim.keymap.set("v", "cmt", ':s/\\(.*\\)/\\/\\/\\1/')
-- End


-- Tab indentation
vim.keymap.set("n", "<Tab>", ">>_")

vim.keymap.set("n", "<leader>pv", vim.cmd.Vex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- vim.keymap.set("n", "<leader>vwm", function()
--     require("vim-with-me").StartVimWithMe()
-- end)
-- vim.keymap.set("n", "<leader>svwm", function()
--     require("vim-with-me").StopVimWithMe()
-- end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/xix/lazy.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.go',
    callback = function()
        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
    end
})

vim.keymap.set("n", "<Esc>", function()
    require("notify").dismiss()
end, { desc = "dismiss notify popup and clear hlsearch" })

-- Python-specific global keybindings
-- Enhanced LSP navigation for Python
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })

-- Enhanced diagnostic keybindings
vim.keymap.set("n", "gl", function()
    vim.diagnostic.open_float({
        focusable = true,
        border = "rounded",
        source = "always",
        width = 80,
    })
end, { desc = "Open focusable diagnostic float" })

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix" })

-- Additional diagnostic navigation
vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

-- Close floating windows (diagnostic floats, LSP hover, etc.)
vim.keymap.set("n", "<leader>x", function()
    -- Close all floating windows
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then
            vim.api.nvim_win_close(win, false)
        end
    end
end, { desc = "Close all floating windows" })

-- Quick testing shortcuts
vim.keymap.set("n", "<leader>tt", function()
    vim.cmd("terminal python -m pytest " .. vim.fn.expand("%"))
end, { desc = "Run pytest on current file" })

vim.keymap.set("n", "<leader>ta", function()
    vim.cmd("terminal python -m pytest")
end, { desc = "Run all tests" })

-- Python REPL shortcuts
vim.keymap.set("n", "<leader>pr", function()
    vim.cmd("terminal python")
end, { desc = "Open Python REPL" })

vim.keymap.set("n", "<leader>pe", function()
    local file = vim.fn.expand("%")
    vim.cmd("terminal python " .. file)
end, { desc = "Execute current Python file" })

-- Virtual environment management
vim.keymap.set("n", "<leader>va", function()
    vim.cmd("terminal source venv/bin/activate && exec $SHELL")
end, { desc = "Activate virtual environment" })

-- Documentation shortcuts
vim.keymap.set("n", "<leader>pd", function()
    require("neogen").generate()
end, { desc = "Generate Python docstring" })

-- Code navigation enhancements
vim.keymap.set("n", "<leader>cf", function()
    require("telescope.builtin").find_files({
        find_command = { "find", ".", "-name", "*.py", "-type", "f" }
    })
end, { desc = "Find Python files" })

vim.keymap.set("n", "<leader>cs", function()
    require("telescope.builtin").live_grep({
        type_filter = "python"
    })
end, { desc = "Search in Python files" })
