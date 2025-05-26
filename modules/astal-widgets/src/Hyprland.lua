local Hyprland = require("lgi").require("AstalHyprland")
local hypr = Hyprland.get_default()
local M = {}

function M.StatusBarWorkspaces()
  return Widget.Box {
    class_name = "hyprland workspaces",

    bind(hypr, "workspaces"):as(function(workspaces)
      table.sort(workspaces, function(a, b)
        return a.id < b.id
      end)
      local widgets = {}


      for _, ws in ipairs(workspaces) do
        if ws.id < 0 then
          widgets[#widgets + 1] = Widget.Button {
            cursor = "pointer",
            class_name = bind(ws.monitor, "special-workspace"):as(function(special)
              local class = "workspace special"
              if special then
                if ws == special then
                  class = class .. " active"
                end
              end
              return class
            end),
            on_clicked = function()
              hypr:dispatch("togglespecialworkspace", "magic")
            end,
            Widget.Label { label = "#" },
          }
        else
          local class_name = var.derive({
              bind(hypr, "focused-workspace"),
              bind(ws.monitor, "special-workspace"),
            }, function(active, special)
              local class = "workspace"
              if ws == active and not special then
                class = class .. " active"
              end
              return class
            end)
          widgets[#widgets + 1] = Widget.Button {
            cursor = "pointer",
            class_name = bind(class_name),
            on_clicked = function()
              ws:focus()
            end,
            on_destroy = function()
              class_name:drop()
            end,
            Widget.Label { label = bind(ws, "id"):as(tostring) },
          }
        end
      end

      return widgets
    end),
  }
end

return M
