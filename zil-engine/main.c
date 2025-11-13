#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "zil.h"

const char *files[] = {
  "/Users/igor/Developer/zork1-main/globals.zil",
  "/Users/igor/Developer/zork1-main/syntax.zil",
  "/Users/igor/Developer/zork1-main/verbs.zil",
  "/Users/igor/Developer/zork1-main/actions.zil",
  "/Users/igor/Developer/zork1-main/dungeon.zil",
  NULL
};

int main(void) {
  char *decl, *body;
  size_t dsize=0, bsize=0;
  FILE *dmem = open_memstream(&decl, &dsize);
  FILE *bmem = open_memstream(&body, &bsize);
  
  lua_State *L = zil_newstate();
  
  for (int i = 0; files[i]; i++) {
    zil_Node *node = zil_parse(files[i]);
    if (node) {
      zil_compile(node, dmem, bmem);
      zil_del(node);
    }
  }
  
  fclose(dmem);
  fclose(bmem);
  
  puts(body);
  
  if (zil_load(L, decl) || zil_load(L, body)) {
    goto cleanup;
  }
  
  zil_start(L);
  
  //  luaL_dostring(L, "print(SLIDE_ROOM.LDESC)");
  
cleanup:
  zil_close(L);
  
  free(decl);
  free(body);

  return 0;
}
