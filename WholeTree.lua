local function dfsFind(treeName,nodeId)
  local info = {};
  info.values = {};
  local values = redis.call('smembers',treeName .. '/' .. nodeId .. '/values');  

  table.foreach(values, function (i,value)
    table.insert(info.values,tonumber(value));
  end)
  info.children = {};
  local children = redis.call('hgetall',treeName .. '/' .. nodeId .. '/children');
  for i = 1,#children,2 do
    local label = children[i];
    local childId = tonumber(children[i+1]);
    info.children[label] = dfsFind(treeName,childId);
  end
  return info;
end

local treeName = KEYS[1];
local rootId = ARGV[1];
return toJSON(dfsFind(treeName,rootId));