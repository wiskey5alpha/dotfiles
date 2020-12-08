local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local TaskList = require('widget.task-list')
local gears = require('gears')
local clickable_container = require('widget.material.clickable-container')
local mat_icon_button = require('widget.material.icon-button')
local mat_icon = require('widget.material.icon')

local dpi = require('beautiful').xresources.apply_dpi

local icons = require('theme.icons')

-- Clock / Calendar 24h format
local textclock = wibox.widget.textclock('<span font="Roboto Mono bold 8">%d.%m.%Y - %H:%M</span>')

-- Clock / Calendar 12AM/PM fornat
-- local textclock = wibox.widget.textclock('<span font="Roboto Mono bold 9">%d.%m.%Y\n  %I:%M %p</span>\n<span font="Roboto Mono bold 9">%p</span>')
-- textclock.forced_height = 56

-- Add a calendar (credits to kylekewley for the original code)
local month_calendar = awful.widget.calendar_popup.month({
  screen = s,
  start_sunday = false,
  week_numbers = true
})
month_calendar:attach(textclock)

local clock_widget = wibox.container.margin(textclock, dpi(13), dpi(13), dpi(8), dpi(8))

local add_button = mat_icon_button(mat_icon(icons.plus, dpi(24)))
add_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn(
          awful.screen.focused().selected_tag.defaultApp,
          {
            tag = _G.mouse.screen.selected_tag,
            placement = awful.placement.bottom_right
          }
        )
      end
    )
  )
)

-- Create an imagebox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
local LayoutBox = function(s)
  local layoutBox = clickable_container(awful.widget.layoutbox(s))
  layoutBox:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          awful.layout.inc(1)
        end
      ),
      awful.button(
        {},
        3,
        function()
          awful.layout.inc(-1)
        end
      ),
      awful.button(
        {},
        4,
        function()
          awful.layout.inc(1)
        end
      ),
      awful.button(
        {},
        5,
        function()
          awful.layout.inc(-1)
        end
      )
    )
  )
  return layoutBox
end

local TagListBox = function(s)
  local taglistBox = awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.all,
    layout = {
      spacing = -12,
      spacing_widget = {
        color = beautiful.fg_normal,
        widget = wibox.widget.separator,
      },
      layout = wibox.layout.fixed.horizontal
    },
    widget_template = {
        {
            {
                {
                    {
                        {
                            id     = 'index_role',
                            widget = wibox.widget.textbox,
                        },
                        margins = 4,
                        widget  = wibox.container.margin,
                    },
                    bg     = beautiful.background.hue_800,
                    shape  = gears.shape.circle,
                    widget = wibox.container.background,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            left  = 4,
            right = 4,
            widget = wibox.container.margin
        },
        id     = 'background_role',
        widget = wibox.container.background,
        create_callback = function(self, c3, index, objects) --luacheck: no unused args
            self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
        end,
        update_callback = function(self, c3, index, objects) --luacheck: no unused args
            self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
        end,
    },
    buttons = taglist_buttons
  }

  return taglistBox
end

local TopPanel = function(s, offset)
  local offsetx = 0
  if offset == true then
    offsetx = dpi(40)
  end
  local panel =
    wibox(
    {
      ontop = true,
      screen = s,
      height = dpi(32),
      width = s.geometry.width - offsetx,
      x = s.geometry.x + offsetx,
      y = s.geometry.y,
      stretch = false,
      bg = beautiful.background.hue_800,
      fg = beautiful.fg_normal,
      struts = {
        top = dpi(32)
      }
    }
  )


  panel:struts(
    {
      top = dpi(32)
    }
  )
  -- We only need the extra taglist on the top if we don't have the side panel
  if s.index == 1 then
    panel:setup {
      layout = wibox.layout.align.horizontal,
      {
        layout = wibox.layout.fixed.horizontal,
        TaskList(s),
        add_button
      },
      nil,
      {
        layout = wibox.layout.fixed.horizontal,
        -- Clock
        clock_widget,
        -- Layout box
        LayoutBox(s)
      }
    }
  else
    panel:setup {
      layout = wibox.layout.align.horizontal,
      {
        layout = wibox.layout.fixed.horizontal,
        TaskList(s),
        add_button
      },
      nil,
      {
        layout = wibox.layout.fixed.horizontal,
        TagListBox(s),
        -- Clock
        clock_widget,
        -- Layout box
        LayoutBox(s)
      }
    }
  end

  return panel
end

return TopPanel
