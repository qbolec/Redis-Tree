local function dfsSuperSetQuery(treeName,nodeId,isInSuperSet)
  local found = map(tonumber,redis.call('smembers',treeName .. '/' .. nodeId .. '/values'));  

  local children = redis.call('hgetall',treeName .. '/' .. nodeId .. '/children');
  for i = 1,#children,2 do
    local label = children[i];
    if isInSuperSet[label] then
      local childId = tonumber(children[i+1]);
      table.foreach(dfsSuperSetQuery(treeName,childId,isInSuperSet), function(k,v)
        table.insert(found,v);
      end);
    end
  end
  return found;
end

local treeName = KEYS[1];
local rootId = ARGV[1];
local labelsSuperSet = slice(ARGV,2);
local isInSuperSet = {};
table.foreach(labelsSuperSet,function(k,v)
  isInSuperSet[v] = true;
end);
return toJSON(dfsSuperSetQuery(treeName,rootId,isInSuperSet));