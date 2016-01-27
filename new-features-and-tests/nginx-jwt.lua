-- USAGE:
--
--  local t     = {}
--  t['roles']  = 'u.meta'
--  match_roles(t, pattern)  -- pattern can be one of these two values
--    u.meta
--    u.domain

-- function u_meta(v) return string.match(v, '^u%.meta%f[%z.]') end
-- function u_domain(v) return string.match(v, '^u%.domain%f[%z.]') end


-- SOLUTION 1
--------------
--
-- function match_roles(table, pattern)
--   for _, value in pairs(table) do
--     if pattern == "u.meta" then
--       if pattern == u_meta(value) then return true end
--     elseif pattern == "u.domain" then
--       if pattern == u_domain(value) then return true end
--     end
--     return false
--   end
-- end

-- SOLUTION 2
---------------
--
-- function pattern_matcher(v, p) return string.match(v, p) end
-- function match_roles(table, role, pattern)
--   for _, value in pairs(table) do
--     if role == pattern_matcher(value, pattern) then return true end
--     return false
--   end
-- end

-- SOLUTIN - 3
--------------

function escape (s) return string.gsub(s, '[.*+?^$()[%%-]', "%%%0") end
function pattern_matcher(v, pattern) return string.match(v, pattern) end
function match_roles(table, pattern)
  for _, value in pairs(table) do
    if pattern == pattern_matcher(value, '^' .. escape(pattern) .. '%f[%z.]') then return true end
    return false
  end
end


-- UNIT TEST
-- ---------
--
-- Below section covers unit test in lua.
-- we are using `luaunit` unit-testing framework that works for lua.
-- NOTE: LuaUnit works with Lua 5.1, 5.2, 5.3 and luajit (v1 and v2.1),
-- http://luaunit.readthedocs.org/en/latest/
--
package.path = './lib/?.lua;' .. package.path
luaunit = require('luaunit')
local t = {}

function test_meta_user_should_be_true()
  t["roles"] = 'u.meta.admin.system'
  luaunit.assertEquals( match_roles(t, 'u.meta'), true )
end

function test_meta_admin_should_be_true()
  t["roles"] = 'u.meta.admin'
  luaunit.assertEquals( match_roles(t, 'u.meta'), true )
end

function test_system_admin_should_be_true()
  t["roles"] = 'u.meta.admin.system'
  luaunit.assertEquals( match_roles(t, 'u.meta'), true )
end

function test_invalid_meta_admin_should_be_false()
  t["roles"] = 'u.meta_admin'
  luaunit.assertEquals( match_roles(t, 'u.meta'), false )
end

function test_invalid_meta_admin_system_should_be_false()
  t["roles"] = 'u.meta_admin_system'
  luaunit.assertEquals( match_roles(t, 'u.meta'), false )
end

function test_invalid_role_should_be_false()
  t["roles"] = 'u.meta-admin'
  luaunit.assertEquals( match_roles(t, 'u.meta'), false )
end

function test_domain_should_not_allow_in_meta()
  t['roles'] = 'u.domain'
  luaunit.assertEquals( match_roles(t, 'u.meta'), false )
end

function test_domain_user_should_be_true()
  t["roles"] = 'u.domain'
  luaunit.assertEquals( match_roles(t, 'u.domain'), true )
end

function test_domain_admin_should_be_true()
  t["roles"] = 'u.domain.admin'
  luaunit.assertEquals( match_roles(t, 'u.domain'), true )
end

function test_fake_domain_admin_should_be_falsy()
  t["roles"] = 'u.domain_admin'
  luaunit.assertEquals( match_roles(t, 'u.domain'), false )
end

function test_fake_role_should_be_falsy()
  t["roles"] = 'u.domain-admin'
  luaunit.assertEquals( match_roles(t, 'u.domain'), false )
end

function test_user_should_either_domain_or_meta ()
  t["roles"] = 'u'
  luaunit.assertEquals( match_roles(t, 'u.domain'), false )
end

function test_meta_user_in_domain_should_be_false ()
  t["roles"] = 'u.meta'
  luaunit.assertEquals( match_roles(t, 'u.domain'), false )
end

function test_meta_admin_in_domain_should_be_false ()
  t["roles"] = 'u.meta.admin'
  luaunit.assertEquals( match_roles(t, 'u.domain'), false )
end

function test_system_admin_in_domain_should_be_false ()
  t["roles"] = 'u.meta.admin.system'
  luaunit.assertEquals( match_roles(t, 'u.domain'), false )
end

function test_fake_meta_admin_in_domain_should_be_true ()
  t["roles"] = 'u.meta_admin'
  luaunit.assertEquals( match_roles(t, 'u.domain'), false )
end

function test_fake_system_admin_in_domain_should_be_true ()
  t["roles"] = 'u.meta_admin_system'
  luaunit.assertEquals( match_roles(t, 'u.domain'), false )
end

function test_fake_meta_role_in_domain_should_be_true ()
  t["roles"] = 'u.meta-admin'
  luaunit.assertEquals( match_roles(t, 'u.domain'), false )
end

function test_anything_should_match_correct_pattern()
  t['roles'] = 'a.b.c.z'
  luaunit.assertEquals( match_roles(t, 'a.b'), true )
end

function test_anything_should_fail_incorrect_pattern()
  t['roles'] = 'a.b_c'
  luaunit.assertEquals( match_roles(t, 'a.b'), false )
end

-- Exit after testcases finished
os.exit( luaunit.LuaUnit.run() )
