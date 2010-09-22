-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Bashets widgets
require("bashets")
-- Vicious widgets
require("vicious")

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
	tags[s] = awful.tag({ 'main', 'web', 'dev', 'im', 'gimp', 'work', 7, 'music', 9 }, s,
						{ layouts[5], layouts[5], layouts[5], layouts[5],
						  layouts[2], layouts[2], layouts[2], layouts[5],
						  layouts[5] })
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
	--{ "places", myplacesmenu },
	{ "open terminal", terminal },
	{ "lock", "gnome-screensaver-command -l" },
}

mymainmenu = awful.menu({ items = mymenu })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
									 menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
wiboxtop = {}
wiboxbottom = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
					awful.button({ }, 1, awful.tag.viewonly),
					awful.button({ modkey }, 1, awful.client.movetotag),
					awful.button({ }, 3, awful.tag.viewtoggle),
					awful.button({ modkey }, 3, awful.client.toggletag),
					awful.button({ }, 4, awful.tag.viewnext),
					awful.button({ }, 5, awful.tag.viewprev)
					)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
					 awful.button({ }, 1, function (c)
											  if not c:isvisible() then
												  awful.tag.viewonly(c:tags()[1])
											  end
											  client.focus = c
											  c:raise()
										  end),
					 awful.button({ }, 3, function ()
											  if instance then
												  instance:hide()
												  instance = nil
											  else
												  instance = awful.menu.clients({ width=250 })
											  end
										  end),
					 awful.button({ }, 4, function ()
											  awful.client.focus.byidx(1)
											  if client.focus then client.focus:raise() end
										  end),
					 awful.button({ }, 5, function ()
											  awful.client.focus.byidx(-1)
											  if client.focus then client.focus:raise() end
										  end))


-- {{{ Widget spacer

spacer = widget({ type = 'textbox' })
spacer.text = " "

-- }}}

-- {{{ Weather widget

weathericon = widget({ type = 'imagebox' })
weathericon.image  = image(beautiful.widget_weather)

weatherwidget = widget({ type = 'textbox' })
vicious.register(weatherwidget, vicious.widgets.weather,
	function (widget, args)
		if args["{tempc}"] == "N/A" then
			return ""
		else
			--weatherwidget:connect_signal('mouse::enter', function () weather_n = { naughty.notify({ title = "Weather", text = "" .. args['{sky}'] .. "\nTemperature: " .. args['{tempf}'] .. "°F", timeout = 0, hover_timeout = 0.5 }) } end)
			--weatherwidget:connect_signal('mouse::leave', function () naughty.destroy(weather_n[1]) end)

			return "" .. args['{sky}'] .. " " .. args['{tempf}'] .. "°F"
		end
	end, 1200, "KBCB")
--weatherwidget:buttons(awful.util.table.join(awful.button({}, 3, function () awful.util.spawn ( browser .. "http://forecast.weather.gov/zipcity.php?inputstring=KBCB") end)))

-- }}}

-- {{{ Battery widget

batticon = widget({ type = 'imagebox' })
batticon.image  = image(beautiful.widget_battery)

battwidget = widget({ type = 'textbox' })
vicious.register(battwidget, vicious.widgets.bat, "$2%", 61, "CMB1")

-- }}}

-- {{{ Wifi widget

wifiicon = widget({ type = 'imagebox' })
wifiicon.image  = image(beautiful.widget_wifi)

wifiwidget = widget({ type = 'textbox' })
vicious.register(wifiwidget, vicious.widgets.wifi, "${ssid}", 5, "wlan0")

-- }}}

-- {{{ Mail widget

mailicon = widget({ type = 'imagebox' })
mailicon.image  = image(beautiful.widget_mail)

mailwidget = widget({ type = 'textbox' })
mailwidget.text = '0'
bashets.register('/home/mutantmonkey/bin/check_gmail.py', { widget = mailwidget, format = '$1', file_update_time = 300, async = true })

-- }}}

-- {{{ Google Reader widget

greadericon = widget({ type = 'imagebox' })
greadericon.image = image(beautiful.widget_greader)

greaderwidget = widget({ type = 'textbox' })
greaderwidget.text = '0'
bashets.register('/home/mutantmonkey/bin/check_greader.py', { widget = greaderwidget, format = '$1', file_update_time = 900, async = true })

-- }}}

-- {{{ Date/time widget

dateicon = widget({ type = 'imagebox' })
dateicon.image  = image(beautiful.widget_date)

datewidget = widget({ type = 'textbox' })
vicious.register(datewidget, vicious.widgets.date, "%a %b %d, %R")

-- }}}

for s = 1, screen.count() do
	-- Create a promptbox for each screen
	mylayoutbox[s] = awful.widget.layoutbox(s)
	mylayoutbox[s]:buttons(awful.util.table.join(
						   awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
						   awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
						   awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
						   awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

	-- Create a tasklist widget
	mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

	-- Create a table with widgets that go to the right
	right_aligned = {
		layout = awful.widget.layout.horizontal.rightleft
	}
	if s == 1 then table.insert(right_aligned, mysystray) end
	table.insert(right_aligned,	spacer)
	table.insert(right_aligned, greadericon)
	table.insert(right_aligned, greaderwidget)
	table.insert(right_aligned, spacer)
	table.insert(right_aligned, mailicon)
	table.insert(right_aligned, mailwidget)
	table.insert(right_aligned, spacer)
	table.insert(right_aligned, wifiicon)
	table.insert(right_aligned, wifiwidget)
	table.insert(right_aligned, spacer)
	table.insert(right_aligned, batticon)
	table.insert(right_aligned, battwidget)
	table.insert(right_aligned, spacer)
	table.insert(right_aligned, weathericon)
	table.insert(right_aligned, weatherwidget)
	table.insert(right_aligned, spacer)
	table.insert(right_aligned, dateicon)
	table.insert(right_aligned, datewidget)
	table.insert(right_aligned, spacer)
 
	-- Create the wibox
	wiboxtop[s] = awful.wibox({ position = "top", screen = s, height = 22 })
	wiboxbottom[s] = awful.wibox({ position = "bottom", screen = s })
	-- Add widgets to the wibox - order matters
	wiboxtop[s].widgets = {
		mylauncher,
		mytaglist[s],
		right_aligned,
		layout = awful.widget.layout.horizontal.leftright,
		height = wiboxtop[s].height
	}
	wiboxbottom[s].widgets = {
		mylayoutbox[s],
		mytasklist[s],
		layout = awful.widget.layout.horizontal.leftright,
		height = wiboxbottom[s].height
	}
end
-- }}}

-- {{{ Start updates for bashets
bashets.start()
-- }}}

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
			floating = true,
			tag = tags[screen.count()][4],
		},
		--callback = awful.titlebar.add
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
			floating = true,
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

