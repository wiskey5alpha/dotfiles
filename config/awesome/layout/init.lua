local awful = require('awful')
local left_panel = require('layout.left-panel')
local top_panel = require('layout.top-panel')

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(
  function(s)
    -- TRA TODO : This if statement right here is what keeps the left-panel only on screen 1
    if s.index == 1 then
      -- Create the left_panel
      s.left_panel = left_panel(s)
      -- Create the Top bar, offset for left-panel
      s.top_panel = top_panel(s, true)
    else
      -- Create the Top bar, no offset
      s.top_panel = top_panel(s, false)
    end
  end
)

-- Hide bars when app go fullscreen
function updateBarsVisibility()
  for s in screen do
    if s.selected_tag then
      local fullscreen = s.selected_tag.fullscreenMode
      -- Order matter here for shadow
      s.top_panel.visible = not fullscreen
      if s.left_panel then
        s.left_panel.visible = not fullscreen
      end
    end
  end
end

_G.tag.connect_signal(
  'property::selected',
  function(t)
    updateBarsVisibility()
  end
)

_G.client.connect_signal(
  'property::fullscreen',
  function(c)
    c.screen.selected_tag.fullscreenMode = c.fullscreen
    updateBarsVisibility()
  end
)

_G.client.connect_signal(
  'unmanage',
  function(c)
    if c.fullscreen then
      c.screen.selected_tag.fullscreenMode = false
      updateBarsVisibility()
    end
  end
)
