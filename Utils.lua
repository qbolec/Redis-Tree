local function toJSON(e)
  local t = type (e);
  if t == "boolean" then
    if e then 
      return "true" 
    else 
      return "false" 
    end
  elseif t == "string" then
    return '"' .. e .. '"'; --[[escaping e]]
  elseif t == "number" then
    return '' .. e;
  elseif t == "table" then
    local justNum = true;
    local expected = 1;
    table.foreach(e, function(k,v)
      if k==expected then
        expected = expected+1;
      else
        justNum = false;
      end
    end)
    if justNum then
      local text = '[';
      local sep = '';
      table.foreach(e, function(k,v)
        text = text  .. sep .. toJSON(v);
        sep = ',';
      end)        
      return text .. ']';
    else
      local text = '{';
      local sep = '';
      table.foreach(e, function(k,v)
        text = text  .. sep .. '"'..  k .. '":' .. toJSON(v);--[[escaping k]]
        sep = ',';
      end)        
      return text .. '}';
    end
  end
end

local function slice(arr,from)
  local part = {};
  table.foreach(arr,function (k,v)
    if from <= k then
      table.insert(part,v);
    end
  end)
  return part;
end

local function map(foo,arr) 
  local mapped = {};
  table.foreach(arr, function(k,v)
    table.insert(mapped,foo(v));
  end)
  return mapped;
end
