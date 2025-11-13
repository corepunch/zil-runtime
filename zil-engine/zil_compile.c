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

#define ZIL_FOR(IT, NODE) for (zil_Node *IT = NODE->children; IT; IT = IT->next)
#define ZIL_FOR_AFTER(IT, NODE) for (zil_Node *IT = NODE->children?NODE->children->next:NULL; IT; IT = IT->next)

typedef enum {
  FIELD_UNKNOWN=0,
  FIELD_VALUE=1,
  FIELD_FLAGS=2,
  FIELD_LIST=4,
  FIELD_STRING=8,
  FIELD_FUNCTION=16,
  FIELD_NAVIGATION=32,
} FieldType;

typedef struct {
  const char *name;
  FieldType type;
} ObjectField;

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

ObjectField object_fields[] = {
  {"FLAGS", FIELD_FLAGS},
  {"SYNONYM", FIELD_LIST|FIELD_STRING},
  {"ADJECTIVE", FIELD_LIST|FIELD_STRING},
  {"DESC", FIELD_STRING},
  {"LDESC", FIELD_STRING},
  {"FDESC", FIELD_STRING},
  {"ACTION", FIELD_FUNCTION},
  {"IN", FIELD_VALUE}, // could be routine reference

  {"NORTH", FIELD_NAVIGATION },
  {"EAST", FIELD_NAVIGATION },
  {"WEST", FIELD_NAVIGATION },
  {"SOUTH", FIELD_NAVIGATION },
  {"NE", FIELD_NAVIGATION },
  {"NW", FIELD_NAVIGATION },
  {"SE", FIELD_NAVIGATION },
  {"SW", FIELD_NAVIGATION },
  {"UP", FIELD_NAVIGATION },
  {"DOWN", FIELD_NAVIGATION },
  {"IN", FIELD_NAVIGATION },
  {"OUT", FIELD_NAVIGATION },
  {"LAND", FIELD_NAVIGATION },

  {NULL, FIELD_UNKNOWN}     // sentinel
};

static FieldType get_field_type(const char *name) {
  for (int i = 0; object_fields[i].name; ++i) {
    if (!strcmp(object_fields[i].name, name))
      return object_fields[i].type;
  }
  return FIELD_UNKNOWN;
}


enum Directions { D_NORTH,D_EAST,D_WEST,D_SOUTH,D_NE,D_NW,D_SE,D_SW,D_UP,D_DOWN,D_IN,D_OUT,D_LAND,NUM_DIRECTIONS };

typedef void (*zil_func)(FILE *decl, FILE *body, zil_Node *node);

struct zil_Func {
  char* name;
  zil_func func;
};

const char* value(zil_Node *node) {
  static char m[1024];
  memset(m, 0, sizeof(m));
  if (!node->val) return "nil";
  if (node->type == N_STRING) {
    snprintf(m, sizeof(m), "[[%s]]", node->val);
    for (char *a = m; *a; a++) if (*a == '\\') *a = '/';
    return m;
  }
  if (node->type == N_EXPR) {
    if (!strcmp(node->val, "+")) return "ADD";
    if (!strcmp(node->val, "-")) return "SUB";
    if (!strcmp(node->val, "/")) return "DIV";
    if (!strcmp(node->val, "*")) return "MULL";
    if (!strcmp(node->val, "==?")) return "EQUALQ";
    if (!strcmp(node->val, "0?")) return "ZEROQ";
    if (!strcmp(node->val, "1?")) return "ONEQ";
  }
  int isstr = 0;
  for (char*p = m, *n = node->val; *n; p++, n++) {
    if (isalpha(*n)) isstr=1;
    *p = *n;
    if (*p == '-' && (!isdigit(*(n+1))||isstr)) *p = '_';
    if (*p == '?') *p = 'Q';
//    if (*p == '.') *p = '_';
  }
  for (char *a = m; *a; a++) if (*a == '\\') *a = '/';
  char*p = m;
  while (*p && (*p == ',' || *p == '.')) p++;
  return p;
}

static void write_field(FILE *body, zil_Node *it, int type) {
  switch (type) {
    case FIELD_LIST|FIELD_STRING:
    case FIELD_LIST:
      fprintf(body, "{");
      ZIL_FOR_AFTER(n, it) {
        fprintf(body, type&FIELD_STRING?"\"%s\"":"%s", value(n));
        if (n->next) fprintf(body, ",");
      }
      fprintf(body, "}");
      break;
    case FIELD_FLAGS:
      ZIL_FOR_AFTER(n, it) {
        fprintf(body, "%s", value(n));
        if (n->next) fprintf(body, "|");
      }
      break;
    case FIELD_STRING:
      ZIL_FOR_AFTER(n, it) {
        if (n->type!=N_STRING) fprintf(body, "\"%s\"", n->val);
        else fprintf(body, "%s", value(n));
        break;
      }
      break;
    case FIELD_FUNCTION:
    case FIELD_VALUE:
    case FIELD_UNKNOWN:
      ZIL_FOR_AFTER(n, it) {fprintf(body, "%s", value(n));break;}
      break;
    case FIELD_NAVIGATION: {
        enum {_to, _room, _if, _cond, _else, _fallback, _total};
        zil_Node *nodes[_total]={0};
        int i = 0;
        fprintf(body, "function() ");
        ZIL_FOR_AFTER(n, it) {
          if(i>_total) {
            fprintf(stderr,"wrong format\n"); i=0; break;
          } else {
            nodes[i]=n;
            if(i==_cond && n->next && !strcmp(n->next->val, "IS")) {
              n = n->next->next;
            }
            i++;
          }
        }
        if (nodes[_if]) {
          fprintf(body, "if %s", value(nodes[_cond]));
          if (nodes[_cond]->next && !strcmp(nodes[_cond]->next->val, "IS")) {
            fprintf(body, ".FLAGS&%sBIT", value(nodes[_cond]->next->next));
          }
          fprintf(body, " then return %s ", value(nodes[_room]));
          if (nodes[_fallback]) {
            fprintf(body, "else return %s ", value(nodes[_fallback]));
          }
          fprintf(body, "end ");
        } else if (nodes[_room]) {
          fprintf(body, "return %s ", value(nodes[_room]));
        } else if (nodes[_to] && nodes[_to]->type == N_STRING) {
          fprintf(body, "return %s ", value(nodes[_to]));
        }
        fprintf(body, "end");
      }
      break;
    default:
      fprintf(body, "nil");
      break;
  }
}

void print_node(FILE *body, zil_Node *n, int r, int loop);

#define max_locals 64
static void Write_Function_Header(FILE *body, zil_Node *node) {
  zil_Node* locals[max_locals]={0};
  zil_Node* opts[max_locals]={0};
  int nlocals = 0;
  int nopts = 0;
  int mode = 0;
  if (node->children->next->type != N_LIST) {
    fprintf(stderr, "Expected arguments in ROUTINE\n");
    fprintf(body, ")\n");
    return;
  }
  int comma = 0;
  ZIL_FOR(it, node->children->next) {
    switch (it->type) {
      case N_LIST:
        assert(mode);
        if (mode==1) locals[nlocals++] = it;
        else {
          fprintf(body, comma?", %s":"%s", value(it->children));
          comma = 1;
          opts[nopts++] = it;
        }
        break;
      case N_IDENT:
        assert(mode!=2);
        if (mode==1) locals[nlocals++] = it;
        else {
          fprintf(body, comma?", %s":"%s", value(it));
          comma = 1;
        }
        break;
      case N_STRING:
        if (!strcmp("AUX", it->val)) mode = 1;
        else if (!strcmp("OPTIONAL", it->val)) mode = 2;
        else assert(0);
        break;
      default:
        continue;
    }
  }
  fprintf(body, ")\n");
  for (int i = 0; i < nlocals; i++) {
    if (locals[i]->type == N_LIST) {
      fprintf(body, "\t%s = %s or ", value(locals[i]->children), value(locals[i]->children));
      print_node(body, locals[i]->children->next, 2, 0);
      fprintf(body, "\n");
    } else {
      fprintf(body, "\tlocal %s\n", value(locals[i]));
    }
  }
  for (int i = 0; i < nopts; i++) {
    fprintf(body, "\t%s = %s or ", value(opts[i]->children), value(opts[i]->children));
    print_node(body, opts[i]->children->next, 2, 0);
    fprintf(body, "\n");
  }
}

#define INDENT(body, r) { \
fprintf(body, "\n"); \
for (int i = 0; i < r; i++) fprintf(body, "\t"); \
}

int is_cond(zil_Node *n) {
  return n->type == N_EXPR && n->val && !strcmp(n->val, "COND");
}

int is_loop(zil_Node *n) {
  return n->type == N_EXPR && n->val && !strcmp(n->val, "REPEAT");
}

int is_return(zil_Node *n) {
  return n->type == N_EXPR && n->val && !strcmp(n->val, "RETURN");
}

void print_node(FILE *body, zil_Node *n, int r, int loop) {
  switch (n->type) {
    case N_EXPR:
      if (!n->val) {
        fprintf(body, "nil");
        return;
      }
      if (!strcmp(n->val, "COND")) {
        ZIL_FOR(it, n) {
          INDENT(body, r);
          if (it->children->val&&!strcmp(it->children->val,"ELSE")) {
            fprintf(body, "else ");
          } else {
            fprintf(body, it == n->children ? "if " : "elseif ");
            print_node(body, it->children, r+1, loop);
            fprintf(body, " then ");
          }
          ZIL_FOR_AFTER(then_clause, it) {
            INDENT(body, r+1);
            if (!then_clause->next && !is_cond(then_clause) && !is_loop(then_clause) && !is_return(then_clause)/* && !loop*/)
              fprintf(body, "return ");
            print_node(body, then_clause, r+1, loop);
          }
        }
        INDENT(body, r);
        fprintf(body, "end\n");
      } else if (!strcmp(n->val, "SET")) {
        fprintf(body, "(function() %s = ", value(n->children));
        ZIL_FOR_AFTER(it, n) {
//          print_node(body, it, r+1, loop);
          if (is_cond(it)) {
            fprintf(body, "(function()");
            print_node(body, it, r+1, loop);
            fprintf(body, " end)()");
          } else {
            print_node(body, it, r+1, loop);
          }
        }
        fprintf(body, " return %s end)()", value(n->children));
      } else if (!strcmp(n->val, "RETURN")) {
        if (loop && !n->children) fprintf(body, "break ");
        else {
          fprintf(body, "return ");
          print_node(body, n->children, r+1, 0);
        }
      } else if (!strcmp(n->val, "RTRUE")) {
        if (r == 1) fprintf(body, "\treturn ");
        fprintf(body, "true");
      } else if (!strcmp(n->val, "RFALSE")) {
        if (r == 1) fprintf(body, "\treturn ");
        fprintf(body, "false ");
      } else if (!strcmp(n->val, "PROG")) {
        INDENT(body, r);
        fprintf(body, "do\n");
        ZIL_FOR_AFTER(it, n) {
          INDENT(body, r+1);
          print_node(body, it, r+1, 1);
        }
        INDENT(body, r);
        fprintf(body, "end\n");
      } else if (!strcmp(n->val, "REPEAT")) {
        INDENT(body, r);
        fprintf(body, "while true do\n");
        ZIL_FOR_AFTER(it, n) {
          INDENT(body, r+1);
          print_node(body, it, r+1, 1);
        }
        INDENT(body, r);
        fprintf(body, "end\n");
      } else {
        if (r==1) for (int i = 0; i < r; i++) fprintf(body, "\t");
        fprintf(body, "%s(", value(n));
        ZIL_FOR(it, n) {
          if (is_cond(it)) {
            fprintf(body, "(function()");
            print_node(body, it, r+1, loop);
            fprintf(body, " end)()");
          } else {
            print_node(body, it, r+1, loop);
          }
          if (it->next) fprintf(body, ", ");
        }
        fprintf(body, ")");
      }
      break;
    case N_IDENT:
    case N_STRING:
    case N_NUMBER:
    case N_SYMBOL:
      if (!strcmp(n->val, "#DECL")) {
        return;
      }
      if (r == 1) fprintf(body, "\treturn ");
      fprintf(body, "%s", value(n));
      break;
    default:
      fprintf(body, "-");
      break;
  }
}

static void ROUTINE(FILE *decl, FILE *body, zil_Node *node) {
  fprintf(decl, "%s = nil\n", value(node->children));
  fprintf(body, "%s = function(", value(node->children));
  Write_Function_Header(body, node);
  for (zil_Node *n = node->children->next->next; n; n = n->next) {
    if (!n->val) continue;
    print_node(body, n, 1, 0);
    fprintf(body, "\n");
  }
  fprintf(body, "end\n");
}

static void GLOBAL(FILE *decl, FILE *body, zil_Node *node) {
}

static void GDECL(FILE *decl, FILE *body, zil_Node *node) {
}

static void OBJECT(FILE *decl, FILE *body, zil_Node *node) {
  fprintf(decl, "%s = nil\n", value(node->children));
  fprintf(body, "%s = {\n", value(node->children));
  ZIL_FOR_AFTER(it, node) {
    if (it->type != N_LIST) {
      fprintf(stderr, "Unsupported type %d in %s\n", it->type, node->val);
      continue;
    }
    if (it->children && it->children->type == N_IDENT && it->children->next) {
      fprintf(body, "\t%s = ", value(it->children));
      write_field(body, it, get_field_type(it->children->val));
      fprintf(body, ",\n");
    }
  }
  fprintf(body, "}\n\n");
}

static void DIRECTIONS(FILE *decl, FILE *body, zil_Node *node) {
}

static void CONSTANT(FILE *decl, FILE *body, zil_Node *node) {
}

const char *ZIL_ObjectFlags[] = {
  "SACREDBIT", // 0
  "FIGHTBIT", // 1
  "TOUCHBIT", // 2
  "WEARBIT", // 3
  "SEARCHBIT", // 4
  "NWALLBIT", // 5
  "NONLANDBIT", // 6
  "TRANSBIT", // 7
  "SURFACEBIT", // 8
  "INVISIBLE", // 9
  "STAGGERED", // 10
  "OPENBIT", // 11
  "RLANDBIT", // 12
  "TRYTAKEBIT", // 13
  "NDESCBIT", // 14
  "TURNBIT", // 15
  "READBIT", // 16
  "TAKEBIT", // 17
  "CONTBIT", // 18
  "ONBIT", // 19
  "FOODBIT", // 20
  "DRINKBIT", // 21
  "DOORBIT", // 22
  "CLIMBBIT", // 23
  "RMUNGBIT", // 24
  "FLAMEBIT", // 25
  "BURNBIT", // 26
  "VEHBIT", // 27
  "TOOLBIT", // 28
  "WEAPONBIT", // 29
  "ACTORBIT", // 30
  "LIGHTBIT", // 31
  NULL
};

struct zil_Func funcs[] = {
  { "ROOM", OBJECT },
  { "OBJECT", OBJECT },
  { "ROUTINE", ROUTINE },
  { "GLOBAL", GLOBAL },
  { "GDECL", GDECL },
  { "CONSTANT", CONSTANT },
  { "DIRECTIONS", DIRECTIONS },
  { 0 }
};

zil_func zil_findfunc(char *name) {
  for (struct zil_Func *f = funcs; f->name; f++) {
    if (!strcmp(name, f->name)) {
      return f->func;
    }
  }
  return NULL;
}

void zil_compile(zil_Node *node, FILE *dmem, FILE *bmem) {
  ZIL_FOR(n, node) {
    if (n->type == N_EXPR) {
      if (!strcmp(n->val, "GDECL")) continue;
      if (!n->children || !n->children->val) {
        fprintf(stderr, "Expected <%s {type}\n", n->val);
        return;
      }
      if (zil_findfunc(n->val)) {
        zil_findfunc(n->val)(dmem, bmem, n);
      } else {
        fprintf(stderr, "Can't find function %s\n", n->val);
      }
    }
  }
  
  fclose(dmem);
  fclose(bmem);

  puts(body);
  
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
  
  lua_pushstring(L, "\n");
  lua_setglobal(L, "CR");
  
  luaL_dostring(L, "function VERBQ(...) for _, v in ipairs {...} do if VERB == v then return true end end return false end");
  luaL_dostring(L, "function TELL(...) io.write(table.concat({ ... }, "")) end");
  luaL_dostring(L, "function AND(...) for _, v in ipairs{...} do if not v then return false end end local args = {...} return args[#args] end");
  luaL_dostring(L, "function OR(...) for _, v in ipairs{...} do if v then return v end end return false end");
  luaL_dostring(L, "function NOT(a) return not a end");
  
  // Basic arithmetic and comparison
  luaL_dostring(L, "function EQUALQ(a, b) return a == b end");
  luaL_dostring(L, "function GQ(a, b) return a > b end");
  luaL_dostring(L, "function LQ(a, b) return a < b end");
  luaL_dostring(L, "function GEQ(a, b) return a >= b end");
  luaL_dostring(L, "function LEQ(a, b) return a <= b end");
  
  // Set operations
  luaL_dostring(L, "function SETG(var, val) _G[var] = val; return val end");
  luaL_dostring(L, "function ADD(var, amt) return var + amt) end");
  luaL_dostring(L, "function SUB(var, amt) return var - amt end");
  luaL_dostring(L, "function DIV(var, amt) return var / amt end");
  luaL_dostring(L, "function MUL(var, amt) return var * amt end");

  // Object/room operations
  luaL_dostring(L, "function LOC(obj) return obj and obj.IN or nil end");
  luaL_dostring(L, "function MOVE(obj, dest) if obj then obj.IN = dest end return true end");
  luaL_dostring(L, "function REMOVE(obj) if obj then obj.IN = nil end return true end");
  luaL_dostring(L, "function FSET(obj, flag) if obj then obj.FLAGS = (obj.FLAGS or 0) | flag end return true end");
  luaL_dostring(L, "function FCLEAR(obj, flag) if obj then obj.FLAGS = (obj.FLAGS or 0) & ~flag end return true end");
  luaL_dostring(L, "function FSETP(obj, flag) return obj and obj.FLAGS and (obj.FLAGS & flag) ~= 0 end");
  
  // I/O operations
  luaL_dostring(L, "function TELL(...) print(...) end");
  luaL_dostring(L, "function PRINT(str) io.write(tostring(str)) end");
  luaL_dostring(L, "function PRINTI(obj) if obj and obj.DESC then io.write(obj.DESC) end end");
  luaL_dostring(L, "function PRINTB(str) io.write(tostring(str)) end");
  luaL_dostring(L, "function PRINTC(ch) io.write(string.char(ch)) end");
  luaL_dostring(L, "function CRLF() print() end");
  
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

  if (luaL_dostring(L, decl) || luaL_dostring(L, body)) {
    fprintf(stderr, "%s", lua_tostring(L, -1));
    lua_pop(L, 1);
  }
  
  if (luaL_dostring(L, "WEST_HOUSE(M_LOOK)")) {
    fprintf(stderr, "%s", lua_tostring(L, -1));
    lua_pop(L, 1);
  }

//  luaL_dostring(L, "print(SLIDE_ROOM.LDESC)");
  
  lua_close(L);

  free(decl);
  free(body);
}
