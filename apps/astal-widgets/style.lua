return function(r, c)
  r "*" {
    font_family = '"JetBrainsMono Nerd Font"',
    font_size = 14,
    color = c.dark12,
  }

  require("StatusBar.style")(r, c)
end
