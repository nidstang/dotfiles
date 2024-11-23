-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Mocha'

config.font = wezterm.font ('JetBrainsMono Nerd Font Mono', { weight = 'Medium' })
config.font_size = 18.0
config.enable_tab_bar = false
config.window_decorations = 'RESIZE'
config.window_padding = { left = 5, right = 0, top = 5, bottom = 0 }

-- and finally, return the configuration to wezterm
return config
