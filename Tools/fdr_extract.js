// Evaluates ForeverDungeonRoutes data files and dumps the parts TMF uses as JSON.
const {lua,lauxlib,lualib,to_luastring}=require('fengari');
const fs=require('fs');
const base=process.argv[2];
const L=lauxlib.luaL_newstate(); lualib.luaL_openlibs(L);
const lib=`
local DR = { Rooms = {}, Floors = {} }
local function run(path)
  local src = SRC[path]
  local chunk = assert(load(src, "@"..path))
  chunk("ForeverDungeonRoutes", DR)
end
run(BASE.."/Data/Dungeons.lua")
run(BASE.."/Data/Floors.lua")
run(BASE.."/Data/Pictures.lua")
run(BASE.."/Data/DefaultRoutes.lua")
local function esc(s) return (s:gsub('\\\\','\\\\\\\\'):gsub('"','\\\\"'):gsub('\\n','\\\\n')) end
local function enc(v)
  local t = type(v)
  if t == "table" then
    local n = #v
    local isArr = n > 0
    local cnt = 0; for k in pairs(v) do cnt = cnt + 1 end
    if isArr and cnt == n then
      local parts = {} for i=1,n do parts[i] = enc(v[i]) end
      return "["..table.concat(parts,",").."]"
    end
    local parts = {}
    for k, x in pairs(v) do parts[#parts+1] = '"'..esc(tostring(k))..'":'..enc(x) end
    return "{"..table.concat(parts,",").."}"
  elseif t == "string" then return '"'..esc(v)..'"'
  elseif t == "number" or t == "boolean" then return tostring(v)
  else return "null" end
end
OUT = enc({ dungeons = DR.Dungeons, floors = DR.Floors, routes = DR.DefaultRoutes })
`;
lua.lua_pushstring(L,to_luastring(base)); lua.lua_setglobal(L,to_luastring("BASE"));
lua.lua_newtable(L);
for (const f of ["Dungeons","Floors","Pictures","DefaultRoutes"]) {
  const path = base + "/Data/" + f + ".lua";
  lua.lua_pushstring(L, to_luastring(fs.readFileSync(path, "utf8")));
  lua.lua_setfield(L, -2, to_luastring(path));
}
lua.lua_setglobal(L, to_luastring("SRC"));
if (lauxlib.luaL_dostring(L,to_luastring(lib))!==0){console.error(lua.lua_tojsstring(L,-1));process.exit(1);}
lua.lua_getglobal(L,to_luastring("OUT"));
fs.writeFileSync(process.argv[3], lua.lua_tojsstring(L,-1));
console.log("ok");
