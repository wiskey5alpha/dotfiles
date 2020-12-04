---------------------------------------------------------------------------
--- Additional hotkeys for awful.hotkeys_widget
--
-- My custom key bindings
---------------------------------------------------------------------------


local keys = {
  firefox = require("module.hotkeys_popup.keys.firefox"),
  tmux = require("module.hotkeys_popup.keys.tmux"),
  kitty = require("module.hotkeys_popup.keys.kitty")
}
return keys
