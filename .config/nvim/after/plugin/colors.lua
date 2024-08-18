-- require('rose-pine').setup({
--     disable_background = true
-- })

-- colorscheme catppuccin -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
function ColorMyPencil(color)
	color = "tokyonight-night"-- color or "catppuccin"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})
end

ColorMyPencil()

