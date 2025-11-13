#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "zil.h"

zil_Node *zil_mk(zil_Type t, char *v) {
  zil_Node *n = malloc(sizeof(zil_Node));
  memset(n, 0, sizeof(zil_Node));
  n->type = t;
  n->val = v ? strdup(v) : NULL;
  n->tail = &n->children;
  return n;
}

zil_Node *zil_del_ignore(zil_Node *p, zil_Node *ig) {
  if (!p) return NULL;
  if (p->children) {
    if (p->children == ig) {
      zil_del_ignore(p->children->next, ig);
    } else {
      zil_del_ignore(p->children, ig);
    }
  }
  if (p->next) {
    if (p->next == ig) {
      zil_del_ignore(p->next->next, ig);
    } else {
      zil_del_ignore(p->next, ig);
    }
  }
  if (p->val) free(p->val);
  free(p);
  return ig;
}

void zil_del(zil_Node *p) {
  zil_del_ignore(p, NULL);
}

void zil_add(zil_Node *p, zil_Node *c) {
  if (c->type == N_COMMENT) {
    zil_del(c);
  } else {
    *p->tail = c;
    p->tail = &c->next;
  }
}

int ws(int c) { return isspace(c); }

#define ZORK_NUMBER 1

int get_number(zil_Node *n) {
  if (!n->val) return -1;
  if (!strcmp(",ZORK-NUMBER", n->val)) return ZORK_NUMBER;
  return atoi(n->val);
}

int num_children(zil_Node *n) {
  int i = 0;
  for (zil_Node *m = n->children; m; m = m->next, i++);
  return i;
}

zil_Node *evaluate(zil_Node *n, zil_Node *val) {
  switch ((int)n->type) {
    case N_EXPR:
      if (num_children(n) == 2 && !strcmp(n->val, "==?")) {
        if (get_number(n->children) ==
            get_number(n->children->next)) {
          return val;
        }
      }
      if (!strcmp(n->val, "OR")) {
        for (zil_Node *m = n->children, *p; m; m = m->next) {
          if ((p = evaluate(m->children, val))) {
            return val;
          }
        }
      }
      return NULL;
    case N_IDENT:
      return val;
    default:
      return NULL;
  }
}

zil_Node *parse(FILE *f) {
  int c;
  while ((c = fgetc(f)) != EOF && ws(c));
  if (c == EOF) return NULL;
  
  if (c == ';') {
    zil_Node *p = zil_mk(N_COMMENT, NULL);
    zil_add(p, parse(f));
    return p;
  }
  
  if (c == '%') {
    zil_Node *n = parse(f);
    assert(n->val && !strcmp(n->val, "COND"));
    for (zil_Node *m = n->children, *val; m; m = m->next) {
      assert(m->type == N_LIST && m->children);
      if ((val = evaluate(m->children, m->children->next))) {
        if (val->type == N_PLACEHOLDER) {
          return zil_del_ignore(n, val->children);
        } else {
          zil_del(n);
          return NULL;
        }
      }
    }
    zil_del(n);
    return NULL;
  }

  if (c == '\'') {
    zil_Node *p = zil_mk(N_PLACEHOLDER, NULL);
    zil_add(p, parse(f));
    return p;
  }

  if (c == '\f' || c == '\\') {
    int next = fgetc(f);
    if (c == '\\' && next == '\f') {
      // Skip \^L sequence
      return parse(f);
    }
    if (c == '\f') {
      return parse(f);
    }
    if (next == '.' || next == ',' || next == '"' || next == '#') {
      return parse(f);
    }
    ungetc(next, f);
    if (c == '\\') {
      // Not a form feed escape, continue parsing
    } else {
      return parse(f);
    }
  }
  
  if (c == '<') {
    zil_Node *n = NULL; //zil_mk(N_EXPR, NULL);
    while (1) {
      while ((c = fgetc(f)) != EOF && ws(c));
      if (c == EOF || c == '>') break;
      ungetc(c, f);
      zil_Node *ch = parse(f);
      if (ch) {
        if (n) {
          zil_add(n, ch);
        } else {
          n = ch;
          n->type = N_EXPR;
        }
      }
    }
    return n?n:zil_mk(N_EXPR, NULL);
  }
  
  if (c == '(') {
    zil_Node *n = zil_mk(N_LIST, NULL);
    while (1) {
      while ((c = fgetc(f)) != EOF && ws(c));
      if (c == EOF || c == ')' || c == '>') break;
      ungetc(c, f);
      zil_Node *ch = parse(f);
      if (ch) zil_add(n, ch);
    }
    if (c != ')') ungetc(c, f);
    return n;
  }
  
  if (c == '>' || c == ')') return NULL;
  
  if (c == '"') {
    char buf[4096], *p = buf;
    while ((c = fgetc(f)) != EOF && c != '"') {
      *p++ = c;
      if (c == '\\') { c = fgetc(f); if (c != EOF) *p++ = c; }
    }
    *p = 0;
    return zil_mk(N_STRING, buf);
  }

  char buf[256], *p = buf;
  *p++ = c;
  while ((c = fgetc(f)) != EOF && !ws(c) && c != '<' && c != '>' && c != '"' && c != '(' && c != ')' && c != ';')
    *p++ = c;
  *p = 0;
  if (c != EOF) ungetc(c, f);
  
  // Determine type
  zil_Type t = N_IDENT;
  if (buf[0] == ',' || buf[0] == '?' || buf[0] == '.')
    t = N_SYMBOL;
  else if (isdigit(buf[0]) || (buf[0] == '-' && isdigit(buf[1])))
    t = N_NUMBER;
  return zil_mk(t, buf);
}

const char *type_str(zil_Type t) {
  switch(t) {
    case N_EXPR: return "EXPR";
    case N_LIST: return "LIST";
    case N_STRING: return "STR";
    case N_IDENT: return "ID";
    case N_NUMBER: return "NUM";
    case N_SYMBOL: return "SYM";
    default: return "?";
  }
}

void print(zil_Node *n, int d) {
  if (!n) return;
  for (int i = 0; i < d; i++) printf("  ");
  
  if (n->type == N_EXPR) {
    printf("<%s\n", n->val);
    for (zil_Node *p = n->children; p; p = p->next) print(p, d + 1);
    for (int i = 0; i < d; i++) printf("  ");
    printf(">\n");
  } else if (n->type == N_LIST) {
    printf("(\n");
    for (zil_Node *p = n->children; p; p = p->next) print(p, d + 1);
    for (int i = 0; i < d; i++) printf("  ");
    printf(")\n");
  } else {
    printf("[%s] %s\n", type_str(n->type), n->val);
  }
}

zil_Node *zil_parse(const char *filename) {
  FILE *fp = fopen(filename, "r");
  if (!fp) return 0;
  zil_Node *root = zil_mk(N_LIST, NULL);  // Changed to LIST to avoid wrapper <
  zil_Node *n;
  while ((n = parse(fp))) zil_add(root, n);
  fclose(fp);
  return root;
}
