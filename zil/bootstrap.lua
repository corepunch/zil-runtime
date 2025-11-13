-- zil_init.lua
-- Equivalent of zil_newstate() in plain Lua

-- === Object Flags ===
ZIL_ObjectFlags = {
  "SACREDBIT", "FIGHTBIT", "TOUCHBIT", "WEARBIT", "SEARCHBIT",
  "NWALLBIT", "NONLANDBIT", "TRANSBIT", "SURFACEBIT", "INVISIBLE",
  "STAGGERED", "OPENBIT", "RLANDBIT", "TRYTAKEBIT", "NDESCBIT",
  "TURNBIT", "READBIT", "TAKEBIT", "CONTBIT", "ONBIT", "FOODBIT",
  "DRINKBIT", "DOORBIT", "CLIMBBIT", "RMUNGBIT", "FLAMEBIT",
  "BURNBIT", "VEHBIT", "TOOLBIT", "WEAPONBIT", "ACTORBIT",
  "LIGHTBIT", "MAZEBIT"
}

-- === Register globals ===
for i, flag in ipairs(ZIL_ObjectFlags) do
  _G[flag] = 1 << (i - 1)
end

-- === Core globals ===
VERBS   = {}
QUEUES  = {}
ROOMS   = {}
OBJECTS = {}

T = true
CR = "\n"
VERB = ""
PRSO = nil
PRSI = nil

M_FATAL = 2
M_HANDLED = 1
M_NOT_HANDLED = nil
M_OBJECT = nil
M_BEG = 1
M_END = 6
M_ENTER = 2
M_LOOK = 3
M_FLASH = 4
M_OBJDESC = 5

-- === Utility functions ===

function BUZZ(...) end

function SYNTAX(args)
  VERBS[args.VERB] = args
end

function SYNONYM(verb, ...)
  for _, syn in ipairs {...} do
    VERBS[syn] = verb
  end
end

function VERBQ(...)
  for _, v in ipairs {...} do
    if VERB == v then return true end
  end
  return false
end

function TELL(...)
  for _, v in ipairs {...} do
    io.write(tostring(v))
  end
end

function PRINT(str) print(str) end
PRINTI = PRINT
PRINTB = PRINT
PRINTN = PRINT
function PRINTC(ch) io.write(string.char(ch)) end
function CRLF() print() end

-- Logic / bitwise
function NOT(a) return not a end
function PASS(a) return a end
function BAND(a, b) return a & b end
function BOR(a, b) return a | b end

-- Arithmetic / comparison
function EQUALQ(a, b) return a == b end
function NEQUALQ(a, b) return a ~= b end
function GQ(a, b) return a > b end
function LQ(a, b) return a < b end
function GEQ(a, b) return a >= b end
function LEQ(a, b) return a <= b end
function ZEROQ(a) return a == 0 end
function ONEQ(a) return a == 1 end

function SETG(var, val) _G[var] = val return val end
function ADD(a, b) return a + b end
function SUB(a, b) return a - b end
function DIV(a, b) return a / b end
function MUL(a, b) return a * b end

-- Object / room ops
function LOC(obj) return obj.IN end
function INQ(obj, room) return obj.IN == room end
function MOVE(obj, dest) obj.IN = dest end
function REMOVE(obj) obj.IN = nil end

function FIRSTQ(obj)
  for _, o in pairs(OBJECTS) do
    if type(o) == 'table' and o.IN == obj then
      return o
    end
  end
end

function NEXTQ(obj)
  local parent = obj.IN
  local found = false
  for _, o in pairs(OBJECTS) do
    if type(o) == 'table' and o.IN == parent then
      if found then return o end
      if o == obj then found = true end
    end
  end
end

function FSET(obj, flag) obj.FLAGS = (obj.FLAGS or 0) | flag end
function FCLEAR(obj, flag) obj.FLAGS = (obj.FLAGS or 0) & ~flag end
function FSETQ(obj, flag) return obj.FLAGS and (obj.FLAGS & flag) ~= 0 end
function PUTP(obj, prop, val) obj[prop] = val end
function GETP(obj, prop) return obj[prop] end

function REST(l, i)
  local r = {}
  for j = i + 1, #l do
    r[#r + 1] = l[j]
  end
  return r
end

function PUT(obj, i, val)
  obj[i] = val
end

function APPLY(func, ...)
  return func and func(...)
end

function GET(o, i)
  return type(o) == 'table' and o[i] or 0
end
GETB = GET

-- Queue / control
function QUEUE(i, turns)
  local t = {FUNC = i, TURNS = turns}
  table.insert(QUEUES, t)
  return t
end

function ENABLE(i) i.ENABLED = true end
function DISABLE(i) i.ENABLED = false end

-- === Done ===
print("ZIL runtime initialized.")
