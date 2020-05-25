local awful = require("awful")

function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x "
			      .. findme ..
			      " > /dev/null || ("
			      .. cmd .. ")")
end

run_once("nm-applet &")
run_once("udiskie -2 -t&")
run_once("xscreensaver &")
run_once("alarm-clock-applet &")
run_once("compton")
