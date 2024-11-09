
setmetatable(_G, {
  __newindex = function(t, k, v) -- 3-12
    local L3_2 = string.format(
      "WARNING: implicitly setting _G['%s'] = %s:(%s:%d)",
      tostring(k), tostring(v), debug.getinfo(2, "S").source, debug.getinfo(2, "l").currentline
    )
    if tostring(k) ~= "_" then
      syslog(L3_2)
    end
    rawset(t, k, v)
  end,
  __index = function(t, k) -- 13-27
    if k:sub(1, 3) == "|#|" then









      return function() end -- 24-24
    end
    return nil
  end
})
local function export(k, v, A2_2) -- 29-37
  if _G[k] and not A2_2 then
    (klb_assert or assert)(false, string.format(
      "ERROR: already exported %s = %s, re-assigning to %s:(%s:%d)",
      tostring(k), tostring(_G[k]), tostring(v), debug.getinfo(2, "S").source, debug.getinfo(2, "l").currentline
    ))
  end
  rawset(_G, k, v)
end

rawset(_G, "export", export)
rawset(_G, "GLOBAL", {})
rawset(GLOBAL, "params", {})
rawset(GLOBAL, "persistent", {})




local function define(k, v) -- 47-54
  if GLOBAL[k] then syslog(string.format(
    "WARNING: already defined GLOBAL['%s'] = '%s':(%s:%d)",
    tostring(k), tostring(v),
    debug.getinfo(2, "S").source, debug.getinfo(2, "l").currentline
  )) end
  GLOBAL[k] = v
end

export("define", define)

local function is_defined(k) -- 58-63
  if GLOBAL[k] then
    return true
  end
  return false
end

export("is_defined", is_defined)

local function import(k) -- 67-75
  (klb_assert or assert)(GLOBAL[k], string.format(
    "ERROR: import undefined library '%s':(%s:%d)",
    tostring(k),
    debug.getinfo(2, "S").source, debug.getinfo(2, "l").currentline
  ))

  return GLOBAL[k]
end

export("import", import)

local L4_1 = {}
local function include_once(k) -- 80-85
  if not L4_1[k] then
    include(k)
    L4_1[k] = true
  end
end

export("include_once", include_once)
export("_", function() end) -- 88-88
export("setup", 0)
export("execute", 0)
export("leave", 0)
