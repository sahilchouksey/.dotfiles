local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local tmx = require("harpoon.tmux")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
vim.keymap.set("n", "<leader>1", function()  ui.nav_file(1) end)
vim.keymap.set("n", "<leader>2", function()  ui.nav_file(2) end)
vim.keymap.set("n", "<leader>3", function()  ui.nav_file(3) end)
vim.keymap.set("n", "<leader>4", function()  ui.nav_file(4) end)



vim.keymap.set("n", ";.", [[:lua require("harpoon.tmux").gotoTerminal(1)<CR>]])
vim.keymap.set("n", ";>", [[:lua require("harpoon.tmux").sendCommand(1, "]])
