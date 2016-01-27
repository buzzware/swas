-- local M = {}

-- -- USAGE:
-- --
-- --     local jwt      = require("nginx-jwt")
-- --     local table    = {}
-- --     table["roles"] = 'u.meta.admin.system'
-- --     local role     = 'u.meta'
-- --     print(table["roles"], role)
-- --     jwt.role_exists(table, 'u.meta')
-- --     true
-- --     table["roles"] = 'u.meta_admin'
-- --     role_exists(table, role)
-- --     false
-- --
-- function M.role_exists(table, role)
--   for _, value in pairs(table) do
--     if role == "u.meta" then
--       meta   = string.match(value, '^u%.meta%f[\0.]')
--       if item ==  meta then return true end
--     elseif role == "u.domain" then
--       domain = string.match(value, '^u%.domain%f[\0.]')
--       if role == domain then return true end
--     end
--   end
--   return false
-- end



a = {}
a['x'] = 'u.meta_admin'
for _, value in pairs(a) do
  print(_, value)
  print('u.meta' == string.match(value, '^u%.meta%f[%z.]'))
end

function match_roles(table, item)
  for _, value in pairs(table) do
    if item == "u.meta" then
      local meta = string.match(value, '^u%.meta%f[%z.]')
      if item == meta then return true end
    elseif item == "u.domain" then
      local domain = string.match(value, '^u%.domain%f[%z.]')
      if item == domain then return true end
    end
    return false
  end
end


-- local tbl = {}
-- tbl["roles"] = 'u.meta.admin.system'
-- print(role_exists(tbl, 'u.meta'))

-- tbl["roles"] = 'u.meta.admin'
-- print(role_exists(tbl, 'u.meta'))

-- tbl["roles"] = 'u.meta'
-- print(role_exists(tbl, 'u.meta'))

-- tbl["roles"] = 'u.meta_admin'
-- print(role_exists(tbl, 'u.meta'))

-- tbl["roles"] = 'u.domain.admin'
-- print(role_exists(tbl, 'u.domain'))

-- tbl["roles"] = 'u.domain_admin'
-- print(role_exists(tbl, 'u.domain'))

