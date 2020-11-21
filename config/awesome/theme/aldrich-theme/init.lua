local filesystem = require('gears.filesystem')
local mat_colors = require('theme.mat-colors')
local theme_dir = filesystem.get_configuration_dir() .. '/theme'
local dpi = require('beautiful').xresources.apply_dpi

local theme = {}
theme.icons = theme_dir .. '/icons/'
theme.font = 'Roboto medium 10'

-- Colors Pallets

-- Primary
theme.primary = mat_colors.hue_green
theme.primary.hue_500 = '#90A4AE'
-- Accent
theme.accent = mat_colors.green

-- Background
theme.background = mat_colors.green

theme.background.hue_800 = '#404040'
theme.background.hue_900 = '#202020'

local awesome_overrides = function(theme)
  --
end
return {
  theme = theme,
  awesome_overrides = awesome_overrides
}
