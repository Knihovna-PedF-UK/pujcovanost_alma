local xml_parser = require "luaxml-mod-xml"

-- example mapping between child elements and names
local mapping = {
  C2 = "callno",
  C16 = "sysno",
  C17 = "author",
  C18 = "title", 
  C19 = "year"
}


local function process(text, mapping, fn) 
  local text = text
  local records = {}
  local current = {}
  local current_name 
  local handler = function()
    local obj = {}
    obj.starttag = function(self, name, attr)
      local mapped_name = mapping[name]
      if mapped_name then
        current_name = mapped_name
      else
        current_name = nil
      end
    end
    obj.endtag = function(self, name)
      if name == "R" then
        local id = current.sysno
        if id and not records[id] then
          -- print(id, current.callno, current.author, current.title, current.year)
          records[id] = current
        end
        if fn then
          fn(current)
        end
        current = {}
      end
    end
    obj.text = function(self, text)
      if current_name then
        current[current_name] = text
      end
    end
    return obj
  end
  local parser = xml_parser.xmlParser(handler())
  parser:parse(text)
  return records
end

local function load(filename)
  local f, msg = io.open(filename, "r")
  if not f then return nil, msg end
  local text =f:read("*all")
  f:close()
  return text
end

return {
  load = load,
  process = process
}
