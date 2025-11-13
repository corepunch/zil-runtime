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
} FieldType;

typedef struct {
  const char *name;
  FieldType type;
} ObjectField;

ObjectField object_fields[] = {
  {"FLAGS", FIELD_FLAGS},
  {"SYNONYM", FIELD_LIST|FIELD_STRING},
  {"ADJECTIVE", FIELD_LIST|FIELD_STRING},
  {"DESC", FIELD_STRING},
  {"LDESC", FIELD_STRING},
  {"FDESC", FIELD_STRING},
  {"ACTION", FIELD_FUNCTION},
  {"IN", FIELD_VALUE}, // could be routine reference

//  {"NORTH", FIELD_NAVIGATION },
//  {"EAST", FIELD_NAVIGATION },
//  {"WEST", FIELD_NAVIGATION },
//  {"SOUTH", FIELD_NAVIGATION },
//  {"NE", FIELD_NAVIGATION },
//  {"NW", FIELD_NAVIGATION },
//  {"SE", FIELD_NAVIGATION },
//  {"SW", FIELD_NAVIGATION },
//  {"UP", FIELD_NAVIGATION },
//  {"DOWN", FIELD_NAVIGATION },
//  {"IN", FIELD_NAVIGATION },
//  {"OUT", FIELD_NAVIGATION },
//  {"LAND", FIELD_NAVIGATION },

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
  static char m[4096];
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
    if (!strcmp(node->val, "=?")) return "EQUALQ";
    if (!strcmp(node->val, "==?")) return "EQUALQ";
    if (!strcmp(node->val, "N==?")) return "NEQUALQ";
    if (!strcmp(node->val, "0?")) return "ZEROQ";
    if (!strcmp(node->val, "1?")) return "ONEQ";
  }
  if (*node->val == '*') {
    sprintf(m, "%d", (int)strtol(node->val+1, NULL, 8));
    return m;
  }
  if (!strncmp(node->val, ",P?", 3)) {
    snprintf(m, sizeof(m), "\"%s\"", node->val+3);
    return m;
  }
  int isstr = 0;
  for (char*p = m, *n = node->val; *n; p++, n++) {
    if (isalpha(*n)) isstr=1;
    *p = *n;
    if (*p == '-' && (!isdigit(*(n+1))||isstr)) *p = '_';
    if (*p == '?') *p = 'Q';
//    if (*p == '.') *p = '_';
  }
  for (char*p = m; *p; p++) {
    if (isstr && isdigit(*p)) {
      *p = *p - '0' + 'a';
//    } else {
//      break;
    }
  }
  for (char *a = m; *a; a++) if (*a == '\\') *a = '/';
  char*p = m;
  while (*p && (*p == ',' || *p == '.')) p++;
  for (char*p = m; *p; p++) if (*p == ',' || *p == '.') *p = 0;
  return p;
}

static void write_nav(FILE *body, zil_Node *it) {
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
    default:
      fprintf(body, "nil");
      break;
  }
}

void print_node(FILE *body, zil_Node *n, int r, int loop, int add_return);

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
      fprintf(body, "\tlocal %s = ", value(locals[i]->children));
      print_node(body, locals[i]->children->next, 2, 0, 0);
      fprintf(body, "\n");
    } else {
      fprintf(body, "\tlocal %s\n", value(locals[i]));
    }
  }
  for (int i = 0; i < nopts; i++) {
    fprintf(body, "\t%s = %s or ", value(opts[i]->children), value(opts[i]->children));
    print_node(body, opts[i]->children->next, 2, 0, 0);
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

int is_prog(zil_Node *n) {
  return n->type == N_EXPR && n->val && !strcmp(n->val, "PROG");
}

int is_loop(zil_Node *n) {
  return n->type == N_EXPR && n->val && !strcmp(n->val, "REPEAT");
}

int is_return(zil_Node *n) {
  return n->type == N_EXPR && n->val &&
  (!strcmp(n->val, "RETURN") ||
   !strcmp(n->val, "RTRUE") ||
   !strcmp(n->val, "RFALSE"));
}

zil_Node *print_syntax_object(FILE *body, zil_Node *it, const char *field) {
  fprintf(body, "\t%s = {\n", field);
  it = it->next;
  while (it->type == N_LIST) {
    if (!strcmp(it->children->val, "FIND")) {
      fprintf(body, "\t\tFIND = %s,\n", value(it->children->next));
    } else {
      fprintf(body, "\t\tWHERE = {");
      ZIL_FOR(j, it) fprintf(body, "\"%s\",", value(j));
      fprintf(body, "},\n");
    }
    it = it->next;
  }
  fprintf(body, "\t},\n");
  return it;
}

int need_return(zil_Node *then_clause, int add_return) {
  return
    add_return &&
    !then_clause->next &&
    !is_cond(then_clause) &&
    !is_loop(then_clause) &&
    !is_prog(then_clause) &&
    !is_return(then_clause);
}

void print_node(FILE *body, zil_Node *n, int r, int loop, int add_return) {
  if (r != 0 && need_return(n, add_return)) {
    fprintf(body, "\treturn ");
    add_return = 0;
  }
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
            print_node(body, it->children, r+1, loop, 0);
            fprintf(body, " then ");
          }
          ZIL_FOR_AFTER(then_clause, it) {
            INDENT(body, r+1);
            if (r != 0 && need_return(then_clause, add_return) /* && !loop*/) {
//              fprintf(body, "return ");
            } else if (then_clause->type != N_EXPR) {
              fprintf(body, "-- ");
            }
            print_node(body, then_clause, r+1, loop, add_return && !then_clause->next);
          }
        }
        INDENT(body, r);
        fprintf(body, "end\n");
      } else if (!strcmp(n->val, "SET") || !strcmp(n->val, "SETG")) {
        fprintf(body, "APPLY(function() %s = ", value(n->children));
        ZIL_FOR_AFTER(it, n) {
          if (is_cond(it)) {
            fprintf(body, "APPLY(function()");
            print_node(body, it, r+1, loop, 1);
            fprintf(body, " end)");
          } else {
            print_node(body, it, r+1, loop, 0);
          }
        }
        fprintf(body, " return %s end)", value(n->children));
      } else if (!strcmp(n->val, "RETURN")) {
        if (loop && !n->children) fprintf(body, "break ");
        else {
          fprintf(body, "return ");
          print_node(body, n->children, r+1, 0, 0);
        }
      } else if (!strcmp(n->val, "RTRUE")) {
        /*if (r == 1) */fprintf(body, "\treturn ");
        fprintf(body, "true");
      } else if (!strcmp(n->val, "RFALSE")) {
        /*if (r == 1) */fprintf(body, "\treturn ");
        fprintf(body, "false ");
      } else if (!strcmp(n->val, "PROG")) {
        INDENT(body, r);
        fprintf(body, "do\n");
        ZIL_FOR_AFTER(it, n) {
          INDENT(body, r+1);
          print_node(body, it, r+1, 1, add_return && !it->next);
        }
        INDENT(body, r);
        fprintf(body, "end\n");
      } else if (!strcmp(n->val, "REPEAT")) {
        INDENT(body, r);
        fprintf(body, "while true do\n");
        ZIL_FOR_AFTER(it, n) {
          INDENT(body, r+1);
          print_node(body, it, r+1, 1, add_return && !it->next);
        }
        INDENT(body, r);
        fprintf(body, "end\n");
      } else if (!strcmp(n->val, "BUZZ") || !strcmp(n->val, "SYNONYM")) {
        fprintf(body, "BUZZ(");
        ZIL_FOR(it, n) {
          if (it != n->children) fprintf(body, ", ");
          fprintf(body, "\"%s\"", it->val);
        }
        fprintf(body, ")\n");
      } else if (!strcmp(n->val, "GLOBAL")) {
        fprintf(body, "%s = ", value(n->children));
        ZIL_FOR_AFTER(it, n) {
          print_node(body, it, 0, 0, add_return && !it->next);
          fprintf(body, "\n");
        }
      } else if (!strcmp(n->val, "SYNTAX")) {
        fprintf(body, "SYNTAX {\n\tVERB = \"%s", n->children->val);
        zil_Node *it = n->children->next;
        while (strcmp(it->val, "OBJECT") && strcmp(it->val, "=")) {
          fprintf(body, " %s", it->val);
          it = it->next;
        }
        fprintf(body, "\",\n");
        if (!strcmp(it->val, "OBJECT")) {
          it = print_syntax_object(body, it, "OBJECT");
        }
        if (strcmp(it->val, "OBJECT") && strcmp(it->val, "=")) {
          fprintf(body, "\tJOIN = \"%s\",\n", it->val);
          it = it->next;
        }
        if (!strcmp(it->val, "OBJECT")) {
          it = print_syntax_object(body, it, "SUBJECT");
        }
        if (!strcmp(it->val, "=")) {
          fprintf(body, "\tACTION = %s,\n", value(it->next));
        }
        fprintf(body, "}\n");
      } else if (!strcmp(n->val, "TABLE") || !strcmp(n->val, "LTABLE")) {
        zil_Node *it = n->children;
        if (it->type == N_LIST) {
          it = it->next;
        }
        fprintf(body, "{");
        for (; it; it = it->next) {
          print_node(body, it, 0, loop, add_return && !it->next);
          if (it->next) fprintf(body, ",");
        }
        fprintf(body, "}\n");
      } else {
        if (r==1) for (int i = 0; i < r; i++) fprintf(body, "\t");
        char *sep = ", ";
        if (!strcmp(n->val, "AND")) {
          sep = " and ";
          fprintf(body, "PASS(");
        } else if (!strcmp(n->val, "OR")) {
          sep = " or ";
          fprintf(body, "PASS(");
        } else {
          fprintf(body, "%s(", value(n));
        }
        ZIL_FOR(it, n) {
          if (it->val && !strcmp(it->val, "D")) {
            continue;
          }
          if (is_cond(it)) {
            fprintf(body, "APPLY(function()");
            print_node(body, it, r+1, loop, 1);
            fprintf(body, " end)");
          } else {
            print_node(body, it, r+1, loop, 0);
          }
          if (it->next) fprintf(body, "%s", sep);
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
    print_node(body, n, 1, 0, !n->next);
    fprintf(body, "\n");
  }
  fprintf(body, "end\n");
}

static void GDECL(FILE *decl, FILE *body, zil_Node *node) {
}

static void OBJECT(FILE *decl, FILE *body, zil_Node *node) {
  fprintf(decl, "%s = setmetatable({}, { __tostring = function(self) return self.DESC or \"%s\" end })\n", value(node->children), value(node->children));
  ZIL_FOR_AFTER(it, node) {
    if (it->type != N_LIST) {
      fprintf(stderr, "Unsupported type %d in %s\n", it->type, node->val);
      continue;
    }
    if (it->children && it->children->type == N_IDENT && it->children->next) {
      fprintf(body, "%s.", value(node->children));
      if (!strcmp(value(it->children->next), "TO")) {
        fprintf(body, "NAV_%s = ", value(it->children));
        write_nav(body, it);
      } else {
        fprintf(body, "%s = ", value(it->children));
        write_field(body, it, get_field_type(it->children->val));
      }
      fprintf(body, "\n");
    }
  }
  fprintf(body, "OBJECTS[\"%s\"] = %s\n", value(node->children), value(node->children));
}

static void DIRECTIONS(FILE *decl, FILE *body, zil_Node *node) {
}

static void CONSTANT(FILE *decl, FILE *body, zil_Node *node) {
  fprintf(body, "%s = ", value(node->children));
  fprintf(body, "%s\n", value(node->children->next));
}

struct zil_Func funcs[] = {
  { "ROOM", OBJECT },
  { "OBJECT", OBJECT },
  { "ROUTINE", ROUTINE },
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
      if (!strcmp(n->val, "COND") ||
          !strcmp(n->val, "BUZZ") ||
          !strcmp(n->val, "SYNONYM") ||
          !strcmp(n->val, "SYNTAX") ||
          !strcmp(n->val, "GLOBAL")) {
        print_node(bmem, n, 0, 0, 0);
        continue;
      }
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
}
