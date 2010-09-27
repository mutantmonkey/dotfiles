-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- {{{ Variable definitions

-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir('config') .. "/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "roxterm"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

local commands = {}
commands.terminal = terminal
commands.browser = "chromium-dev"
commands.filemanager = "nautilus --browser"

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
	awful.layout.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.right,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.max,
}

-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
	-- Each screen has its own tag table.
	tags[s] = awful.tag({ 'main', 'web', 'im', 4, 5, 6, 7, 8, 9 }, s,
						{ layouts[2], layouts[2], layouts[7], layouts[2],
						  layouts[2], layouts[2], layouts[5], layouts[2],
						  layouts[2] })
end
--- }}}

-- {{{ Menu

-- Create a launcher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymenu = {
	{ "awesome", myawesomemenu, beautiful.awesome_icon },
	{ "open terminal", terminal },
	{ "lock", "gnome-screensaver-command -l" },
}

mymainmenu = awful.menu({ items = mymenu })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
									 menu = mymainmenu })
-- }}}

require("widgets")

-- {{{ Mouse bindings

root.buttons(awful.util.table.join(
	awful.button({ }, 3, function () mymainmenu:toggle() end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
))

-- }}}

-- {{{ Key bindings

globalkeys = awful.util.table.join(
	awful.key({ modkey,           }, "Left",   awful.tag.viewprev	   ),
	awful.key({ modkey,           }, "Right",  awful.tag.viewnext	   ),
	awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

	awful.key({ modkey,           }, "j",
		function ()
			awful.client.focus.byidx( 1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey,           }, "k",
		function ()
			awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

	-- Layout manipulation
	awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)	end),
	awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)	end),
	awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
	awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
	awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
	awful.key({ modkey,           }, "Tab",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end),

	-- Standard program
	awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
	awful.key({ modkey, "Control" }, "r", awesome.restart),
	awful.key({ modkey, "Shift"   }, "q", awesome.quit),

	awful.key({ modkey,           }, "l",	 function () awful.tag.incmwfact( 0.05)	end),
	awful.key({ modkey,           }, "h",	 function () awful.tag.incmwfact(-0.05)	end),
	awful.key({ modkey, "Shift"   }, "h",	 function () awful.tag.incnmaster( 1)	  end),
	awful.key({ modkey, "Shift"   }, "l",	 function () awful.tag.incnmaster(-1)	  end),
	awful.key({ modkey, "Control" }, "h",	 function () awful.tag.incncol( 1)		 end),
	awful.key({ modkey, "Control" }, "l",	 function () awful.tag.incncol(-1)		 end),
	awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
	awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

	-- Prompt
	awful.key({ modkey },			"r",	 function () mypromptbox[mouse.screen]:run() end),

	awful.key({ modkey }, "x",
			  function ()
				  awful.prompt.run({ prompt = "Run Lua code: " },
				  mypromptbox[mouse.screen].widget,
				  awful.util.eval, nil,
				  awful.util.getdir("cache") .. "/history_eval")
			  end),

	-- Dmenu
	awful.key({ modkey }, ";", function () awful.util.spawn("dmenu_run -i" ..
		" -nb '" .. beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal ..
		"' -sb '" .. beautiful.bg_focus .. "' -sf '" .. beautiful.fg_focus ..
		"' -fn '-*-dejavu sans mono-medium-r-normal--12-*-*-*-*-*-*-*'")
		end),

	-- Lock screen
	awful.key({ }, "Pause", function () awful.util.spawn("gnome-screensaver-command -l") end),

	-- Print screen
	awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'") end)
)

clientkeys = awful.util.table.join(
	awful.key({ modkey,           }, "f",	  function (c) c.fullscreen = not c.fullscreen  end),
	awful.key({ modkey, "Shift"   }, "c",	  function (c) c:kill()						 end),
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle					 ),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey,           }, "o",	  awful.client.movetoscreen						),
	awful.key({ modkey,           }, "t",	  function (c) c.ontop = not c.ontop			end),
	awful.key({ modkey,           }, "n",	  function (c) c.minimized = not c.minimized	end),
	awful.key({ modkey,           }, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c.maximized_vertical   = not c.maximized_vertical
		end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
	globalkeys = awful.util.table.join(globalkeys,
		awful.key({ modkey }, "#" .. i + 9,
				  function ()
						local screen = mouse.screen
						if tags[screen][i] then
							awful.tag.viewonly(tags[screen][i])
						end
				  end),
		awful.key({ modkey, "Control" }, "#" .. i + 9,
				  function ()
					  local screen = mouse.screen
					  if tags[screen][i] then
						  awful.tag.viewtoggle(tags[screen][i])
					  end
				  end),
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
				  function ()
					  if client.focus and tags[client.focus.screen][i] then
						  awful.client.movetotag(tags[client.focus.screen][i])
					  end
				  end),
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
				  function ()
					  if client.focus and tags[client.focus.screen][i] then
						  awful.client.toggletag(tags[client.focus.screen][i])
					  end
				  end))
end

clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

-- }}}

-- {{{ Rules

awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
	  properties = { border_width = beautiful.border_width,
					 border_color = beautiful.border_normal,
					 focus = true,
					 keys = clientkeys,
					 buttons = clientbuttons } },

	{ rule = { class = "MPlayer" },
	  properties = { floating = true } },
	{ rule = { class = "pinentry" },
	  properties = { floating = true } },

	-- tag: web {{{
	
	-- Chromium
	{
		rule = { class = "Chromium" },
		properties = {
			tag = tags[1][2],
		}
	},

	-- Firefox
	{
		rule = { class = "Minefield" },
		properties = {
			tag = tags[1][2],
		}
	},

	-- }}}

	-- tag: im {{{

	{
		rule = { class = "Pidgin" },
		properties = {
			tag = tags[screen.count()][3],
		},
	},

	-- }}}
	
	-- tag: dev {{{

	{
		rule = { class = "Glade-3" },
		properties = {
			tag = tags[1][3],
			switchtotag = true,
		}
	},

	{
		rule = { class = "Eclipse" },
		properties = {
			tag = tags[1][3],
			switchtotag = true,
		}
	},

	-- }}}
	
	-- tag: gimp {{{

	{
		rule = { class = "Gimp" },
		properties = {
			tag = tags[1][5],
			switchtotag = true,
		}
	},

	-- }}}
	
	-- tag: vm {{{

	{
		rule = { name = ".*VirtualBox" },
		properties = {
			tag = tags[1][7],
			switchtotag = true,
		}
	},

	{
		rule = { class = "wine" },
		properties = {
			floating = true,
		}
	},

	{
		rule = { name = ".*Wine.*" },
		properties = {
			floating = true,
		}
	},

	{
		rule = { name = ".*Steam.*" },
		properties = {
			floating = true,
			tag = tags[1][7],
			switchtotag = tags[1][7],
		}
	},

	-- }}}

	-- tag: music {{{
	
	{
		rule = { class = "banshee-1" },
		properties = {
			tag = tags[1][8],
		}
	},

	-- }}}
}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
	-- Add a titlebar
	--awful.titlebar.add(c, { modkey = modkey })
	
	-- Enable sloppy focus
	c:connect_signal("mouse::enter", function(c)
		if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
			and awful.client.focus.filter(c) then
			client.focus = c
		end
	end)

	if not startup then
		-- Set the windows at the slave,
		-- i.e. put it at the end of others instead of setting it master.
		-- awful.client.setslave(c)

		-- Put windows in a smart way, only if they does not set an initial position.
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Startup applications
-- Only start applications if gnome-settings-daemon is not running
awful.util.spawn_with_shell('pgrep -f gnome-settings-daemon || (dex -a)')
-- }}}

