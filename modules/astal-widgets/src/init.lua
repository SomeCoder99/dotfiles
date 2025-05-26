astal = require("astal")
bind = astal.bind
var = astal.Variable
App = require("astal.gtk3.app")
Widget = require("astal.gtk3.widget")
Anchor = require("astal.gtk3").Astal.WindowAnchor

stylesheet = require("stylesheet")
require("StatusBar.init")

App:start {
  css = stylesheet("style", require("color")),
  name = "scaw",
  main = function()
    StatusBar(0)
  end,
}
