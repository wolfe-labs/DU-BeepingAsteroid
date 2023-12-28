--[[
    Lua Set implementation v0.1
    by Matt @ Wolfe Labs
    github.com/wolfe-labs
]]
return function (values)
  local data = {}
  local self = {}
  
  function self.add(value)
    data[value] = true
  end

  function self.remove(value)
    data[value] = nil
  end

  function self.has(value)
    return data[value] == true
  end

  function self.values()
    local values = {}
    for value in pairs(data) do
      table.insert(values, value)
    end
    return values
  end

  function self.size()
    return #self.values()
  end
  
  for _, value in pairs(values or {}) do
    self.add(value)
  end

  return self
end