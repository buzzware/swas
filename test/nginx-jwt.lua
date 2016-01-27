function u_meta(v) return string.match(v, '^u%.meta%f[%z.]') end
function u_domain(v) return string.match(v, '^u%.domain%f[%z.]') end
function match_roles(table, item)
  for _, value in pairs(table) do
    if item == "u.meta" then
      if item == u_meta(value) then return true end
    elseif item == "u.domain" then
      if item == u_domain(value) then return true end
    end
    return false
  end
end

local t = {}

-- META
t["roles"] = 'u.meta.admin.system'
print(match_roles(t, 'u.meta'))   -- true

t["roles"] = 'u.meta.admin'
print(match_roles(t, 'u.meta'))   -- true

t["roles"] = 'u.meta'
print(match_roles(t, 'u.meta'))   -- true

t["roles"] = 'u.meta_admin'
print(match_roles(t, 'u.meta'))   -- false

-- DOMAIN
t['roles'] = 'u.domain'
print(match_roles(t, 'u.domain')) -- true

t["roles"] = 'u.domain.admin'
print(match_roles(t, 'u.domain')) -- true

t["roles"] = 'u.domain_admin'
print(match_roles(t, 'u.domain')) -- false

-- META try to access DOMAIN
t["roles"] = 'u.meta'
print(match_roles(t, 'u.domain')) -- true

t["roles"] = 'u.meta.admin'
print(match_roles(t, 'u.domain')) -- true

t["roles"] = 'u.meta.admin.system'
print(match_roles(t, 'u.domain')) -- true

t["roles"] = 'u.meta_admin'
print(match_roles(t, 'u.domain')) -- false

