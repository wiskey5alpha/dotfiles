local filesystem = require('gears.filesystem')

-- Thanks to jo148 on github for making rofi dpi aware!
local with_dpi = require('beautiful').xresources.apply_dpi
local get_dpi = require('beautiful').xresources.get_dpi
local rofi_command = 'env /usr/bin/rofi -dpi ' .. get_dpi() .. ' -width ' .. with_dpi(400) .. ' -show drun -theme ' .. filesystem.get_configuration_dir() .. '/configuration/rofi.rasi -run-command "/bin/bash -c -i \'shopt -s expand_aliases; {cmd}\'"'

return {
  -- List of apps to start by default on some actions
  default = {
    terminal = 'kitty',
    rofi = rofi_command,
    lock = 'i3lock-fancy',
    quake = 'kitty',
    screenshot = '~/.config/awesome/configuration/utils/screenshot --window root',
    region_screenshot = '~/.config/awesome/configuration/utils/screenshot',
    delayed_screenshot = '~/.config/awesome/configuration/utils/screenshot --delayed',

    -- Editing these also edits the default program
    -- associated with each tag/workspace
    browser = 'firefox',
    editor = '/home/aldrichtr/.dotfiles/bin/edit', -- gui text editor
    social = 'slack',
    game = rofi_command,
    files = 'nautilus',
    music = 'spotify'
  },
  -- List of apps to start once on start-up
  run_on_start_up = {
    'compton --config ' .. filesystem.get_configuration_dir() .. '/configuration/compton.conf',
    'nm-applet --indicator', -- wifi
    --'blueberry-tray', -- Bluetooth tray icon
    --'xfce4-power-manager', -- Power manager
    'ibus-daemon --xim --daemonize', -- Ibus daemon for keyboard
    'numlockx on', -- enable numlock
    '/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)', -- credential manager
    -- Add applications that need to be killed between reloads
    -- to avoid multipled instances, inside the awspawn script
    '~/.config/awesome/configuration/awspawn' -- Spawn "dirty" apps that can linger between sessions
  }
}
