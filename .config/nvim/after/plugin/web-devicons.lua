-- local status, icons = pcall(require, "nvim-web-devicons")
-- if (not status) then return end
--
-- icons.setup {
--   -- your personnal icons can go here (to override)
--   -- DevIcon will be appended to `name`
--   override = {
--   },
--   -- globally enable default icons (default to false)
--   -- will get overriden by `get_icons` option
--   default = true
-- }


local web_devicons_ok, web_devicons = pcall(require, "nvim-web-devicons")
if not web_devicons_ok then
	return
end

local material_icon_ok, material_icon = pcall(require, "nvim-material-icon")
if not material_icon_ok then
	return
end

web_devicons.setup({
	override = material_icon.get_icons(),
})
