-- Bashets widgets
require("bashets")
-- Vicious widgets
require("vicious")

bashets.set_script_path(awful.util.getdir('config') .. '/bashets/')

wiboxtop = {}
wiboxbottom = {}

mylayoutbox = {}

-- {{{ Tag list

mytaglist = {}
mytaglist.buttons = awful.util.table.join(
					awful.button({ }, 1, awful.tag.viewonly),
					awful.button({ modkey }, 1, awful.client.movetotag),
					awful.button({ }, 3, awful.tag.viewtoggle),
					awful.button({ modkey }, 3, awful.client.toggletag),
					awful.button({ }, 4, awful.tag.viewnext),
					awful.button({ }, 5, awful.tag.viewprev)
					)

-- }}}

-- {{{ Task list

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

-- }}}

-- {{{ System tray

systraywidget = widget({ type = 'systray' })

-- }}}

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
			return "N/A"
		else
			--weatherwidget:connect_signal('mouse::enter', function () weather_n = { naughty.notify({ title = "Weather", text = "" .. args['{sky}'] .. "\nTemperature: " .. args['{tempf}'] .. "°F", timeout = 0, hover_timeout = 0.5 }) } end)
			--weatherwidget:connect_signal('mouse::leave', function () naughty.destroy(weather_n[1]) end)

			return "" .. args['{sky}'] .. " " .. args['{tempf}'] .. "°F"
		end
	end, 1200, "KBCB")
--weatherwidget:buttons(awful.util.table.join(awful.button({}, 3, function () awful.util.spawn ( browser .. "http://forecast.weather.gov/zipcity.php?inputstring=KBCB") end)))
--bashets.register('forecast.sh', { widget = weatherwidget, format = "<span face='ConkyWeather' color='" .. beautiful.fg_focus .."' weight='bold' rise='-1400'>$1</span> $2", file_update_time = 1200, async = true })

-- }}}

-- {{{ Battery widget

batticon = widget({ type = 'imagebox' })
batticon.image  = image(beautiful.widget_battery)

battwidget = widget({ type = 'textbox' })
--vicious.register(battwidget, vicious.widgets.bat, "$2%", 61, "CMB1")
bashets.register('battery.sh', { widget = battwidget, format = "$2%", update_time = 61 })

-- }}}

-- {{{ Wifi widget

wifiicon = widget({ type = 'imagebox' })
wifiicon.image  = image(beautiful.widget_wifi)

wifiwidget = widget({ type = 'textbox' })
vicious.register(wifiwidget, vicious.widgets.wifi, "${ssid}", 61, "wlan0")

-- }}}

-- {{{ Mail widget

ctitle = ""
function mail_callback(data)
	if data[1] ~= ctitle then
		ctitle = data[1]

		--naughty.notify({ text = "You have mail" })
	end
end

mailicon = widget({ type = 'imagebox' })
mailicon.image  = image(beautiful.widget_mail)

mailwidget = widget({ type = 'textbox' })
mailwidget.text = '-'
bashets.register('check_gmail.py', { widget = mailwidget, format = '$1', file_update_time = 300, async = true })

-- }}}

-- {{{ Google Reader widget

greadericon = widget({ type = 'imagebox' })
greadericon.image = image(beautiful.widget_greader)

greaderwidget = widget({ type = 'textbox' })
greaderwidget.text = '-'
bashets.register('check_greader.py', { widget = greaderwidget, format = '$1', file_update_time = 900, async = true })

-- }}}

-- {{{ Date/time widget

dateicon = widget({ type = 'imagebox' })
dateicon.image  = image(beautiful.widget_date)

datewidget = widget({ type = 'textbox' })
vicious.register(datewidget, vicious.widgets.date, "%a %b %d, %R")

-- }}}

for s = 1, screen.count() do
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
	if s == 1 then table.insert(right_aligned, systraywidget) end
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
 
 	-- Create wiboxes
	wiboxtop[s] = awful.wibox({ position = "top", screen = s })
	wiboxbottom[s] = awful.wibox({ position = "bottom", screen = s })
	
	-- Top wibox
	wiboxtop[s].widgets = {
		mylauncher,
		mytaglist[s],
		right_aligned,
		layout = awful.widget.layout.horizontal.leftright,
		height = wiboxtop[s].height
	}

	-- Bottom wibox
	wiboxbottom[s].widgets = {
		mylayoutbox[s],
		mytasklist[s],
		layout = awful.widget.layout.horizontal.leftright,
		height = wiboxbottom[s].height
	}
end

--- {{{ Start updating bashets
bashets.start()
-- }}}

