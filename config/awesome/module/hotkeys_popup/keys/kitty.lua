---------------------------------------------------------------------------
--- kitty hotkeys for awful.hotkeys_widget
--
-- @author timothy.r.aldrich
-- @copyright 2020 tra
-- @submodule  awful.hotkeys_popup
---------------------------------------------------------------------------

local hotkeys_popup = require("awful.hotkeys_popup.widget")

local kitty = {}

--- Add rules to match kitty terminal session.
--
-- For example:
--
--     kitty.add_rules_for_terminal({ rule = { name = { "kitty" }}})
--
-- will show kitty hotkeys for any window that has 'kitty' in its title.
-- If no rules are provided then kitty hotkeys will be shown always!
-- @function add_rules_for_terminal
-- @see awful.rules.rules
-- @tparam table rule Rules to match a window containing a kitty session.
function kitty.add_rules_for_terminal(rule)
    for group_name, group_data in pairs({
        ["kitty: scroll"]   = rule,
        ["kitty: windows"]  = rule,
        ["kitty: tabs"]     = rule,
        ["kitty: misc"]     = rule,
    }) do
        hotkeys_popup.add_group_rules(group_name, group_data)
    end
end

local kitty_keys = {
    ["kitty: scroll"] = {{
        modifiers = {"Ctrl" , "Shift"},
        keys = {
            ['Up']    = "Scroll line up",
            ['Down']  = "Scroll line down",
            ['PgUp']  = "Scroll page up",
            ['PgDn']  = "Scroll page down",
            ['Home']  = "Scroll to top",
            ['End']   = "Scroll to bottom"
        }
    }},

    ["kitty: windows"] = {{
        modifiers = {"Ctrl" , "Shift"},
        keys = {
            ['Return']  = "Create window",
            n         = "Create new OS window",
            w         = "Close window",
            [']']    = "Next window",
            ['[']    = "Previous window",
            f         = "Move window forward",
            b         = "Move window backward",
            ['0...9'] = "select window by number"
        }
    }},

    ["kitty: tabs"] = {{
        modifiers = {"Ctrl" , "Shift"},
        keys = {
            t         = "New tab",
            q         = "Close tab",
            ['Right'] = "Next tab",
            ['Left']  = "Previous tab",
            l         = "Next layout",
            ['.']     = "Move forward",
            [',']     = "Move backward"
        }
                       },
      {
        modifiers = {"Ctrl" , "Alt", "Shift"},
        keys = {
          t           = "Set tab title"
        }
      }},

    ["kitty: misc"] = {{
        modifiers = {"Ctrl" , "Shift"},
        keys = {
          c      = "Copy to clipboard",
          v      = "Paste from clipboard",
          s      = "Paste from selection",
          ['=']  = "Increase font size",
          ['-']  = "Decrease font size",
          ['Backspace'] = "Restore font size",
          ['F11']       = "Toggle fullscreen",
          ['F10']       = "Toggle maximized",
          u             = "Input unicode character",
          e             = "Click URL using keyboard",
          ['Delete']    = "Reset terminal",
          o             = "Pass current selection to program",
          ['F2']        = "Edit kitty config file",
          ['Esc']       = "Open a kitty shell",
          am           = "Increase background opacity",
          al           = "Decrease background opacity",
          a1           = "Full background opacity",
          ad           = "Reset background opacity"
        }
    }}
}

hotkeys_popup.add_hotkeys(kitty_keys)

return kitty
