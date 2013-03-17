local function checkNode(treeName,nodeId)
  local keys =  {
    treeName .. '/' .. nodeId .. '/children',
    treeName .. '/' .. nodeId .. '/values'
  };
  local kill = true;
  table.foreach(keys, function(i,key)
    if 1 == redis.call('exists',key) then
      kill = false;
    end
  end);
  return kill;
end


local function getChild(treeName,parentId,childLabel)
  local key = treeName .. '/' .. parentId .. '/children';
  local childId = redis.call('hget',key,childLabel);
  if childId ~= false then
    childId = tonumber(childId);
  end
  return childId;
end

local function removeChild(treeName,parentId,childLabel)
  local key = treeName .. '/' .. parentId .. '/children';
  return redis.call('hdel',key,childLabel);
end


local function removeValue(treeName,nodeId,value)
  local key = treeName .. '/' .. nodeId .. '/values';
  return redis.call('srem',key,value);
end

local function dfsRemove(treeName,rootId,path,value)
  if 0 == # path then
    removeValue(treeName,rootId,value);
  else
    local label = table.remove(path,1);
    local childId = getChild(treeName,rootId,label);
    if false ~= childId then
      if dfsRemove(treeName,childId,path,value) then
        removeChild(treeName,rootId,label)
      end
    end
  end
  return checkNode(treeName,rootId);  
end

local treeName = KEYS[1];
local rootId = ARGV[1];
local value = ARGV[2];
local path = slice(ARGV,3);

return dfsRemove(treeName,rootId,path,value);
