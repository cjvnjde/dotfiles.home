local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.use_fancy_tab_bar = true

config.font = wezterm.font("FiraCode Nerd Font")

config.keys = {
	{
		key = "H",
		mods = "CTRL|SHIFT",
		action = act.ActivateCopyMode,
	},
}

return config
