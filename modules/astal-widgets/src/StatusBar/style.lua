-- stylua: ignore
return function(r, c)
  r ".status-bar" {
    background = "transparent",

    r ".container" {
      margin = "10px 10px 0 10px",
      background = "transparent",

      r "& > box" {
        border_radius = 20,
        background = c.dark1,
        color = c.dark12,
        padding = "5px 10px",
      },
    },
  }

  r ".status-bar .separator" {
    color = c.dark8,
    padding = 0,
    margin = 0,
    background = "transparent",
    font_size = "1.1em",
    font_weight = "bold",
  }

  r ".status-bar .info-label" {
    r ".button" {
      { padding = 0 },
      { padding_right = 5 },
      background = "transparent",
    },

    r ".revealer .text" {
      margin_left = 5,
    },
  }

  for k, v in pairs {
    clock = c.green0,
    date = c.orange0,
    ["used-ram"] = c.orange0,
    brightness = c.yellow0,
    audio = c.cyan0,
    ["battery.normal"] = c.blue0,
    ["battery.warning"] = c.yellow0,
    ["battery.danger"] = c.red0,
    ["battery.charging"] = c.green0,
  } do
    r (".status-bar .info-label." .. k .. " *") {
      color = v,
    }
  end

  r ".status-bar .info-label.used-ram.danger *" {
    color = c.red0,
  }

  r ".status-bar .network *" {
    color = c.purple0,
  }

  r ".status-bar .network .not-connected" {
    padding = "0 10px",
  }

  r ".status-bar .info-label.audio.mute *" {
    color = c.red0,
  }

  local function slider(color)
    return {
      min_width = 100,
      margin = "0 10px",

      r "slider" {
        { all = "unset" },
        {
          background = c[color .. "1"],
          border_radius = 10,
          margin = -6,
        },
      },

      r "trough" {
        border_radius = 5,
        min_height = 4,
        background = c.dark0,
      },

      r "highlight" {
        { all = "unset" },
        {
          border_radius = 5,
          min_height = 4,
          background = c[color .. "0"],
        },
      },
    }
  end

  r ".status-bar .info-label.brightness .slider" {
    slider "yellow",
  }

  r ".status-bar .info-label.audio .slider" {
    slider "cyan",
  }

  r ".status-bar .os-logo" {
    font_size = "1.4em",
    color = c.blue0,
    padding = 0,
    margin = 0,
  }

  r ".status-bar .workspaces > .workspace" {
    padding = 0,

    r "&:not(.special)" {
      background = "transparent",
    },

    r "&.active > label" {
      color = c.cyan0,
    },

    r "&.special" {
      background = c.dark5,
      border_radius = 15,

      r "&.active" {
        background = c.cyan2,
        r "label" {
          color = c.dark0,
        }
      },
    },
  }

  r ".status-bar .sys-tray button" {
    padding = 0,
    border_radius = 20,
  }
end
