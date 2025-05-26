local function into_css_key(key)
  return string.gsub(key, "_", "-")
end

local function expand(rule)
  if rule.__x_selector then
    return
  end
  if rule.__parent then
    expand(rule.__parent)
    if string.find(rule.__selector, "&") then
      local left, right = string.match(rule.__parent.__x_selector, "(.*)([^%s>]+)%s*$")
      rule.__x_selector = (left or rule.__parent.__x_selector) .. string.gsub(rule.__selector, "&", right or "")
    else
      rule.__x_selector = rule.__parent.__x_selector .. " " .. rule.__selector
    end
  else
    rule.__x_selector = rule.__selector
  end
end

local function parse(style, children, pair_list)
  local styles = { style }
  for _, s in ipairs(styles) do
    for k, v in pairs(s) do
      if type(k) == "number" then
        if type(v) ~= "table" then
          error("must be a table")
        end

        if v.__selector then
          expand(v)
          children[#children + 1] = v
        else
          styles[#styles + 1] = v
        end
      else
        local value = type(v)
        if value == "string" then
          value = v
        elseif value == "number" then
          value = v .. "px"
        else
          error("must be a string or number")
        end
        pair_list[#pair_list + 1] = { into_css_key(k), value }
      end
    end
  end
end

return function(mod, ...)
  local stylize
  if type(mod) == "function" then
    stylize = mod
  else
    stylize = require(mod)
  end
  local context = { stack = {} }
  local result = ""

  local function rule(selector)
    local root
    local self
    if not context.stack[1] then
      context.stack[1] = { __selector = selector }
      root = true
    else
      self = {
        __selector = selector,
        __parent = context.stack[#context.stack],
      }
      context.stack[#context.stack + 1] = self
    end

    local children = {}
    local pair_list = {}
    return function(style)
      parse(style, children, pair_list)
      local text = ""
      local exists = {}
      local empty = true
      for i = #pair_list, 1, -1 do
        empty = false
        local k, v = pair_list[i][1], pair_list[i][2]
        if not exists[k] then
          exists[k] = true
          text = "  " .. k .. ": " .. v .. ";\n" .. text
        end
      end
      if not empty then
        text = "{\n" .. text .. "}\n"
      end

      for _, c in ipairs(children) do
        text = text .. c.__x_selector .. " " .. c.__style
      end

      if root then
        if not empty then
          result = result .. selector .. " "
        end
        result = result .. text
        context.stack[1] = nil
      else
        self.__style = text
        context.stack[#context.stack] = nil
        return self
      end
    end
  end

  stylize(rule, ...)

  return result
end
