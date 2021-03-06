-- MODULE AUTO-START
-- Run all the apps listed in configuration/apps.lua as run_on_start_up only once when awesome start

local awful = require('awful')
local apps = require('configuration.apps')

local function run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(' ')
  if firstspace then
    findme = cmd:sub(0, firstspace - 1)
  end
  -- TRA 2020.12.01: the shell was changed to fish from bash, which changed the syntax a bit
  awful.spawn.with_shell(string.format('command pgrep -u $USER -x %s > /dev/null; or %s', findme, cmd))
end

for _, app in ipairs(apps.run_on_start_up) do
  run_once(app)
end
