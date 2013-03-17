local function ensureFreeCounter(treeName,freeId)
  local key = treeName .. '/free_id' ;
  local val = redis.call('get', key );
  if val == false or tonumber(val) < freeId then
    redis.call('set',key, freeId);
  else
    freeId = tonumber(val);
  end
  return freeId;
end

local function ensureNode(treeName,freeId)
  
end

local function createNode(treeName,freeId)
  local id = ensureFreeCounter(treeName,0);
  ensureNode(treeName,id);
  ensureFreeCounter(treeName,id+1);
  return id;
end


local function ensureChild(treeName,parentId,childLabel)
  local key = treeName .. '/' .. parentId .. '/children';
  local childId = redis.call('hget',key,childLabel);
  if childId == false then
    childId = createNode(treeName);
    redis.call('hset',key,childLabel,childId);
  else
    childId = tonumber(childId);
  end
  return childId;
end

local function ensureValue(treeName,nodeId,value)
  local key = treeName .. '/' .. nodeId .. '/values';
  return redis.call('sadd',key,value);
end

local function dfsAdd(treeName,rootId,path,value)
  ensureNode(treeName,rootId);
  if 0 == # path then
    ensureValue(treeName,rootId,value);
  else
    local label = table.remove(path,1);
    local childId = ensureChild(treeName,rootId,label);    
    return dfsAdd(treeName,childId,path,value);    
  end
end

local treeName = KEYS[1];
local rootId = ARGV[1];
local value = ARGV[2];
local path = slice(ARGV,3);

ensureFreeCounter(treeName,rootId+1);
dfsAdd(treeName,rootId,path,value);

return treeName;