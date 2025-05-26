local hyprland = require("Hyprland")
local Tray = require("lgi").require("AstalTray")
local Network = require("lgi").require("AstalNetwork")
local Wp = require("lgi").require("AstalWp")
local Bat = astal.require("AstalBattery")
local GLib = astal.require("GLib")

local function SysTray()
  local tray = Tray.get_default()

  return Widget.Box {
    class_name = "sys-tray",
    visible = bind(tray, "items"):as(function(items)
      return #items > 0
    end),
    bind(tray, "items"):as(function(items)
      local widgets = {}
      for _, item in ipairs(items) do
        widgets[#widgets + 1] = Widget.MenuButton {
          tooltip_markup = bind(item, "tooltip_markup"),
          use_popover = false,
          menu_model = bind(item, "menu-model"),
          action_group = bind(item, "action-group"):as(function(ag)
            return { "dbusmenu", ag }
          end),
          Widget.Icon {
            gicon = bind(item, "gicon"),
          },
        }
      end
      return widgets
    end),
  }
end

local function InfoLabel(opt)
  opt = opt or {}
  local reveal = var(opt.reveal or false)
  local icon, text = opt.icon, opt.text
  opt.reveal, opt.icon, opt.text = nil, nil, nil
  opt.spacing = 0

  if type(opt.class_name) == "table" then
    opt.class_name = opt.class_name:as(function(v)
      return "info-label " .. v
    end)
  else
    opt.class_name = (opt.class_name or "") .. " info-label"
  end

  opt[1] = {
    Widget.Revealer {
      class_name = "revealer",
      reveal_child = reveal(),
      transition_duration = 500,
      transition_type = "SLIDE_RIGHT",
      opt[1] or Widget.Label {
        class_name = "text",
        label = text,
      },
    },
    Widget.Button {
      class_name = "button",
      cursor = "pointer",
      on_clicked = function()
        reveal:set(not reveal:get())
      end,
      Widget.Label {
        label = icon,
        class_name = "icon",
      },
    },
  }

  return Widget.Box(opt)
end

local function Time()
  local time = var("00:00:00"):poll(1000, function(v)
    return GLib.DateTime.new_now_local():format("%H:%M:%S")
  end)

  return InfoLabel {
    class_name = "clock",
    reveal = true,
    icon = "",
    text = time(tostring),
    on_destroy = function()
      time:drop()
    end,
  }
end

local function Date()
  return InfoLabel {
    class_name = "date",
    reveal = false,
    icon = "",
    text = GLib.DateTime.new_now_local():format("%A - %d %B %Y"),
  }
end

local function UsedRam()
  local ram = var({ free = 0, used = 0, total = 0 }):poll(1000, function()
    local p = io.popen("cat /proc/meminfo", "r")
    if not p then
      return "???"
    end
    local total = tonumber(string.match(p:read("*l"), "^[^:]*:%s*(%d+)")) or 0
    local free = tonumber(string.match(p:read("*l"), "^[^:]*:%s*(%d+)")) or 0
    p:close()
    return { free = free, used = total - free, total = total }
  end)

  return InfoLabel {
    class_name = ram(function(r)
      return "used-ram" .. (r.free / r.total <= 0.15 and " danger" or "")
    end),
    icon = "",
    text = ram(function(r)
      return string.format("%.1f/%.1f GB", r.used / 1000000, r.total / 1000000)
    end),
    on_destroy = function()
      ram:drop()
    end,
  }
end

local brightness_icons = { "󰃞", "󰃝", "󰃟", "󰃠" }
local function Brightness()
  local brightness = var(0)
    :poll(1000, function(prev)
      local p = io.popen("brightnessctl info -m", "r")
      if not p then
        return prev or 0
      end
      local perc = (tonumber(string.match(p:read("*l"), "(%d+)%%")) or 0) / 100
      p:close()
      return perc
    end)

  return InfoLabel {
    class_name = "brightness",
    icon = brightness(function(v)
      return brightness_icons[math.ceil(v * #brightness_icons)] or brightness_icons[1]
    end),
    on_destroy = function()
      brightness:drop()
    end,
    Widget.Slider {
      class_name = "slider",
      hexpand = true,
      on_dragged = function(self)
        local p = io.popen("brightnessctl set " .. (self.value * 100) .. "%", "r")
        if p then
          p:close()
        end
        brightness:set(self.value)
      end,
      value = brightness(),
    },
  }
end

local function Audio()
  local speaker = Wp.get_default().audio.default_speaker
  local volume_mute = var.derive({
    bind(speaker, "volume"),
    bind(speaker, "mute"),
  }, function(volume, mute)
    return { volume = volume, mute = mute }
  end)

  return InfoLabel {
    class_name = bind(speaker, "mute"):as(function(mute)
      return "audio" .. (mute and " mute" or "")
    end),
    icon = volume_mute(function(s)
      if s.volume <= 0 or s.mute then
        return ""
      elseif s.volume <= 0.5 then
        return ""
      else
        return ""
      end
    end),
    on_destroy = function()
      volume_mute:drop()
    end,
    Widget.Slider {
      class_name = "slider",
      hexpand = true,
      on_dragged = function(self)
        speaker.volume = self.value
      end,
      value = bind(speaker, "volume"),
    },
  }
end

local function Networks()
  local network = Network.get_default()
  local wifi = bind(network, "wifi")
  local wired = bind(network, "wired")

  return Widget.Box {
    class_name = "network",
    bind(network, "primary"):as(function(primary)
      if primary == "WIFI" then
        return InfoLabel {
          icon = "",
          wifi:as(function(w)
            return Widget.Label {
              class_name = "text",
              label = bind(w, "ssid"),
            }
          end),
        }
      elseif primary == "WIRED" then
        return InfoLabel {
          icon = "",
          wired:as(function(w)
            return Widget.Label {
              class_name = "text",
              label = bind(w, "speed"),
            }
          end),
        }
      else
        return Widget.Label {
          class_name = "not-connected",
          label = "",
        }
      end
    end),
  }
end

local battery_icons = { "", "", "", "", "" }
local function Battery()
  local battery = Bat.get_default()
  local perc = bind(battery, "percentage")
  local state = bind(battery, "state")
  local bat = var.derive({ perc, state }, function(p, s)
    return { perc = p, state = s }
  end)

  return InfoLabel {
    class_name = bat(function(s)
      local class = "battery"
      if s.state == "CHARGING" then
        class = class .. " charging"
      elseif s.perc < 0.15 then
        class = class .. " danger"
      elseif s.perc < 0.3 then
        class = class .. " warning"
      else
        class = class .. " normal"
      end
      return class
    end),
    visible = bind(bat, "is-present"),
    icon = bat(function(s)
      if s.state == "CHARGING" then
        return ""
      else
        return battery_icons[math.ceil(s.perc * #battery_icons)] or battery_icons[#battery_icons]
      end
    end),
    text = perc:as(function(p)
      return tostring(math.floor(p * 100)) .. "%"
    end),
  }
end

local function Separator(text)
  return Widget.Label { class_name = "separator", label = text or "|" }
end

local function Left()
  return Widget.Box {
    class_name = "left",
    halign = "START",
    spacing = 10,

    Widget.Label {
      class_name = "os-logo",
      label = "󱄅",
    },
    hyprland.StatusBarWorkspaces(),
    SysTray(),
  }
end

local function Center()
  return Widget.Box {
    class_name = "center",
    halign = "CENTER",

    Time(),
    Separator(),
    Date(),
  }
end

local function Right()
  return Widget.Box {
    class_name = "right",
    halign = "END",

    UsedRam(),
    Brightness(),
    Audio(),
    Networks(),
    Battery(),
  }
end

function StatusBar(monitor)
  return Widget.Window {
    name = "status-bar",
    class_name = "status-bar",
    monitor = monitor,
    anchor = Anchor.TOP + Anchor.LEFT + Anchor.RIGHT,
    exclusivity = "EXCLUSIVE",
    layer = "TOP",
    application = App,

    Widget.CenterBox {
      class_name = "container",

      Left(),
      Center(),
      Right(),
    },
  }
end
