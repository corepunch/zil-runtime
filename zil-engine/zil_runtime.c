#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <assert.h>

#include "zil.h"

#if __has_include(<lua5.4/lua.h>)
#include <lua5.4/lauxlib.h>
#include <lua5.4/lua.h>
#include <lua5.4/lualib.h>
#elif __has_include(<lua5.3/lua.h>)
#include <lua5.3/lauxlib.h>
#include <lua5.3/lua.h>
#include <lua5.3/lualib.h>
#else
#include <lua/lauxlib.h>
#include <lua/lua.h>
#include <lua/lualib.h>
#endif

const char *ZIL_ObjectFlags[] = {
  "SACREDBIT",
  "FIGHTBIT",
  "TOUCHBIT",
  "WEARBIT",
  "SEARCHBIT",
  "NWALLBIT",
  "NONLANDBIT",
  "TRANSBIT",
  "SURFACEBIT",
  "INVISIBLE",
  "STAGGERED",
  "OPENBIT",
  "RLANDBIT",
  "TRYTAKEBIT",
  "NDESCBIT",
  "TURNBIT",
  "READBIT",
  "TAKEBIT",
  "CONTBIT",
  "ONBIT",
  "FOODBIT",
  "DRINKBIT",
  "DOORBIT",
  "CLIMBBIT",
  "RMUNGBIT",
  "FLAMEBIT",
  "BURNBIT",
  "VEHBIT",
  "TOOLBIT",
  "WEAPONBIT",
  "ACTORBIT",
  "LIGHTBIT",
  "MAZEBIT",
  NULL
};

const char* ZIL_Verbs[] = {
  "WALK",
  "BRIEF", "VERBOSE", "SUPER_BRIEF", "VERSION",
  "SAVE", "RESTORE", "QUIT", "RESTART",
  "ATTACK", "MUNG", "ALARM", "SWING",
  "OPEN", "CLOSE", "EAT", "DRINK",
  "INFLATE", "DEFLATE", "TURN", "BURN",
  "TIE", "UNTIE", "RUB",
  "WAIT",
  "LAMP_ON",
  "SCORE",
  "TAKE",
  "DROP", "THROW", "INVENTORY",
  "DIAGNOSE",
  "LOOK",
  "PRAY",
  NULL
};

lua_State *zil_newstate(void) {
  lua_State *L = luaL_newstate();
  luaL_openlibs(L);
  
  for (int i = 0; ZIL_ObjectFlags[i]; ++i) {
    lua_pushinteger(L, (lua_Integer)1 << i);
    lua_setglobal(L, ZIL_ObjectFlags[i]);
  }
  
  for (int i = 0; ZIL_Verbs[i]; ++i) {
    lua_pushstring(L, ZIL_Verbs[i]);
    lua_setglobal(L, ZIL_Verbs[i]);
  }
  
  luaL_dostring(L, "function BUZZ(...) end");
  luaL_dostring(L, "function SYNTAX(args) VERBS[args.VERB] = args end");
  luaL_dostring(L, "function SYNONYM(verb, ...) for _, syn in ipairs {...} do VERBS[syn] = verb end end");

  luaL_dostring(L, "function VERBQ(...) for _, v in ipairs {...} do if VERB == v then return true end end return false end");
  luaL_dostring(L, "function TELL(...) io.write(table.concat({ ... }, "")) end");
//  luaL_dostring(L, "function AND(...) for _, v in ipairs{...} do if not v then return false end end local args = {...} return args[#args] end");
//  luaL_dostring(L, "function OR(...) for _, v in ipairs{...} do if v then return v end end return false end");
  luaL_dostring(L, "function NOT(a) return not a end");
  luaL_dostring(L, "function PASS(a) return a end");
  luaL_dostring(L, "function BAND(a, b) return a & b end");
  luaL_dostring(L, "function BOR(a, b) return a | b end");

  // Basic arithmetic and comparison
  luaL_dostring(L, "function EQUALQ(a, b) return a == b end");
  luaL_dostring(L, "function NEQUALQ(a, b) return a ~= b end");
  luaL_dostring(L, "function GQ(a, b) return a > b end");
  luaL_dostring(L, "function LQ(a, b) return a < b end");
  luaL_dostring(L, "function GEQ(a, b) return a >= b end");
  luaL_dostring(L, "function LEQ(a, b) return a <= b end");
  luaL_dostring(L, "function ZEROQ(a) return a == 0 end");
  luaL_dostring(L, "function ONEQ(a) return a == 1 end");

  // Set operations
  luaL_dostring(L, "function SETG(var, val) _G[var] = val return val end");
  luaL_dostring(L, "function ADD(a, b) return a + b end");
  luaL_dostring(L, "function SUB(a, b) return a - b end");
  luaL_dostring(L, "function DIV(a, b) return a / b end");
  luaL_dostring(L, "function MUL(a, b) return a * b end");
  
  // Object/room operations
  luaL_dostring(L, "function LOC(obj) return obj.IN end");
  luaL_dostring(L, "function INQ(obj, room) return obj.IN == room end");
  luaL_dostring(L, "function MOVE(obj, dest) obj.IN = dest end");
  luaL_dostring(L, "function REMOVE(obj) obj.IN = nil end");
  luaL_dostring(L,
                "function FIRSTQ(obj)\n"
                "  for _, o in pairs(OBJECTS) do\n"
                "    if type(o) == 'table' and o.IN == obj then\n"
                "      return o\n"
                "    end\n"
                "  end\n"
                "end\n");
  luaL_dostring(L,
                "function NEXTQ(obj)\n"
                "  local parent = obj.IN\n"
                "  local found = false\n"
                "  for _, o in pairs(OBJECTS) do\n"
                "    if type(o) == 'table' and o.IN == parent then\n"
                "      if found then return o end\n"
                "      if o == obj then found = true end\n"
                "    end\n"
                "  end\n"
                "end\n");
  luaL_dostring(L, "function FSET(obj, flag) obj.FLAGS = (obj.FLAGS or 0) | flag end");
  luaL_dostring(L, "function FCLEAR(obj, flag) obj.FLAGS = (obj.FLAGS or 0) & ~flag end");
  luaL_dostring(L, "function FSET(obj, flag) obj.FLAGS = (obj.FLAGS or 0) | flag end");
  luaL_dostring(L, "function FSETQ(obj, flag) return obj.FLAGS and (obj.FLAGS & flag) ~= 0 end");
  luaL_dostring(L, "function FCLEAR(obj, flag) obj.FLAGS = (obj.FLAGS or 0) & ~flag end");
  luaL_dostring(L, "function PUTP(obj, prop, val) obj[prop] = val end");
  luaL_dostring(L, "function GETP(obj, prop) return obj[prop] end");
  luaL_dostring(L, "function REST(t, i) obj[prop] = val end");
  luaL_dostring(L, "function REST(l, i) local r={} for j=i+1,#l do r[#r+1]=l[j] end return r end");
  luaL_dostring(L, "function PUT(obj, i, val) obj[i] = val end");
  luaL_dostring(L, "function APPLY(func, ...) return func and func(...) end");
  luaL_dostring(L, "function GET(o, i) return type(o) == 'table' and o[i] or 0 end");
  luaL_dostring(L, "GETB = GET");

  // I/O operations
  luaL_dostring(L, "function TELL(...) for _, v in ipairs{...} do io.write(tostring(v)) end end");
  luaL_dostring(L, "function PRINT(str) print(str) end");
  luaL_dostring(L, "PRINTI = PRINT");
  luaL_dostring(L, "PRINTB = PRINT");
  luaL_dostring(L, "PRINTN = PRINT");
  luaL_dostring(L, "function PRINTC(ch) io.write(string.char(ch)) end");
  luaL_dostring(L, "function CRLF() print() end");
  
  // queue
  luaL_dostring(L, "function QUEUE(i, turns) local t={FUNC=i,TURNS=turns} table.insert(QUEUES, t) return t end");
  luaL_dostring(L, "function ENABLE(i) i.ENABLED = true end");
  luaL_dostring(L, "function DISABLE(i) i.ENABLED = false end");

  lua_newtable(L); lua_setglobal(L, "VERBS");
  lua_newtable(L); lua_setglobal(L, "QUEUES");
  lua_newtable(L); lua_setglobal(L, "ROOMS");
  lua_newtable(L); lua_setglobal(L, "OBJECTS");

  lua_pushboolean(L, 1); lua_setglobal(L, "T");
  
  lua_pushstring(L, "\n"); lua_setglobal(L, "CR");  
  lua_pushstring(L, ""); lua_setglobal(L, "VERB");
  lua_pushnil(L); lua_setglobal(L, "PRSO");
  lua_pushnil(L); lua_setglobal(L, "PRSI");
  
  lua_pushinteger(L, 2); lua_setglobal(L, "M_FATAL");
  lua_pushinteger(L, 1); lua_setglobal(L, "M_HANDLED");
  lua_pushnil(L); lua_setglobal(L, "M_NOT_HANDLED");
  lua_pushnil(L); lua_setglobal(L, "M_OBJECT");
  lua_pushinteger(L, 1); lua_setglobal(L, "M_BEG");
  lua_pushinteger(L, 6); lua_setglobal(L, "M_END");
  lua_pushinteger(L, 2); lua_setglobal(L, "M_ENTER");
  lua_pushinteger(L, 3); lua_setglobal(L, "M_LOOK");
  lua_pushinteger(L, 4); lua_setglobal(L, "M_FLASH");
  lua_pushinteger(L, 5); lua_setglobal(L, "M_OBJDESC");

  return L;
}

int zil_load(lua_State *L, const char *decl) {
  if (luaL_dostring(L, decl)) {
    fprintf(stderr, "%s\n", lua_tostring(L, -1));
    lua_pop(L, 1);
    return 1;
  } else {
    return 0;
  }
}

void zil_start(lua_State *L) {
//  if (luaL_dostring(L, "WEST_HOUSE(M_LOOK)")) {
  if (luaL_dostring(L, "GO()")) {
    fprintf(stderr, "%s\n", lua_tostring(L, -1));
    lua_pop(L, 1);
  }
}

void zil_close(lua_State *L) {
  lua_close(L);
}
