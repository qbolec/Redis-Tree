local treeName = KEYS[1];

local all = redis.call('keys',treeName .. '/*');
table.foreach(all, function (i,key)
  redis.call('del',key)
end)

return treeName;