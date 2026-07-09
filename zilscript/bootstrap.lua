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

D = 0xBAADF00D

OQANY=1

PSQOBJECT=128
PSQVERB=64
PSQADJECTIVE=32
PSQDIRECTION=16
PSQPREPOSITION=8
PSQBUZZ_WORD=4

P1QNONE=0
P1QOBJECT=0
P1QVERB=1
P1QADJECTIVE=2
P1QDIRECTION=3

SH=128
SC=64
SIR=32
SOG=16
STAKE=8
SMANY=4
SHAVE=2

-- === Register globals ===
for i, flag in ipairs(ZIL_ObjectFlags) do
  _G[flag] = i
end

-- === Core globals ===
VERBS   = nil
QUEUES  = {}
ROOMS   = {}
PROPERTIES = {}
-- PREPOSITIONS: Pre-allocated array format [0]=count, [1]=word_ptr1, [2]=index1, ...
-- Maximum 128 prepositions, format: index_count, then pairs of (word_ptr, original_index)
PREPOSITIONS = {[0] = 0}  -- Initialize with count = 0
PREPOSITIONS._hash = {}   -- Helper hash for quick lookup during population
ADJECTIVES = {}
-- ACTIONS/PREACTIONS: mem-allocated 256×2-byte dispatch tables, lazily initialized on first SYNTAX call.
-- They are populated during loading (by SYNTAX) AND read at runtime on every command dispatch:
-- the game's PERFORM routine calls <GET ,ACTIONS .A> and <GET ,PREACTIONS .A> to find and
-- invoke the handler for the current verb. Keeping them in mem is therefore correct -- they
-- are not loading-only data.
ACTIONS = 0   -- mem address of action dispatch table (action_id → fn_idx)
PREACTIONS = 0  -- mem address of pre-action dispatch table (action_id → fn_idx)
FLAGS = {}
FUNCTIONS = {}
_DIRECTIONS = {}

DESCS = {}
DIRS = {}

_VTBL = {}
_OTBL = 0  -- mem address of 256×2-byte object pointer table; set on first DECL_OBJECT

T = true
CR = "\n"
PRSA = nil
PRSO = nil
PRSI = nil

local ZIL_CONTROL_SIGNALS = {
	quit = {},
	restart = {},
}

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

local mem
local _obj_count = 0  -- number of declared objects; object IDs are 1.._obj_count
local _act_count = 0  -- number of registered actions; action IDs are 1.._act_count
local _act_fn_to_id = {}  -- build-time reverse-lookup: fn_idx -> action_id
local restart_snapshot
local suggestions = {
	READBIT = "READ",
	TAKEBIT = "TAKE",
	CONTBIT = "OPEN",
	DOORBIT = "OPEN",
}

local function objects_in_room(room)
	local room_globals = {}
	local pqglobal = rawget(_G, "PQGLOBAL")
	if pqglobal and GETPT(room, pqglobal) then
		local ptr = GETPT(room, pqglobal)
		local size = PTSIZE(ptr)
		for i = 0, size - 1 do
			room_globals[mem:byte(ptr + i)] = true
		end
	end

	local i = 0
	return function()
		while true do
			i = i + 1
			if i > _obj_count then return nil end
			if i ~= ADVENTURER and GETP(i, PQLOC) == room then return i end
			if i ~= ADVENTURER and room_globals[i] then return i end
		end
	end
end

local function connected_exits(room)
    local i, keys = 0, {}
    for d in pairs(_DIRECTIONS) do keys[#keys+1]=d end
    return function()
        while i<#keys do
            i=i+1; local d=_DIRECTIONS[keys[i]]; local pp=GETPT(room,d)
            if pp then return keys[i], pp end
        end
    end
end

local function add_items(room)
	local items = {}
	for obj in objects_in_room(room) do
		local verbs = {}
		local action = GETP(obj, PQACTION)
		local text = GETP(obj, PQTEXT) and not FSETQ(obj, READBIT)
		local item = GETP(obj, PQDESC) or ""
		if action then
			local func = FUNCTIONS[tonumber(action)]
			for k, v in pairs(_G) do if v == func then verbs = _G['_'..k] break end end
		end
		if text then table.insert(verbs, "EXAMINE") end
		local fnd = function(name, array) 
			for _, n in ipairs(array) do if n == name then return true end end
		end
		for k, v in pairs(suggestions) do
			if FSETQ(obj, _G[k]) and not fnd(v, verbs) then
				table.insert(verbs, v)
			end
		end
		local marks, unique_verbs = {}, {}
		for _, verb in ipairs(verbs) do
			if not marks[verb] then table.insert(unique_verbs, verb) marks[verb] = true end
		end
		local words = {}
		for word in item:gmatch("%S+") do
			table.insert(words, word:lower())
		end
		if words[1] then words[1] = words[1]:sub(1,1):upper() .. words[1]:sub(2) end
		table.insert(items, {table.concat(words, " "), unique_verbs, add_items(obj)})
	end
	return items
end

local function add_exits(room)
	local exits = {}
	for d, pp in connected_exits(room) do
		if PTSIZE(pp) == 1 then
			local desc = GETP(GETB(pp, 0), PQDESC)
			if not FSETQ(GETB(pp, 0), ONBIT) then
				desc = desc .. " (pitch black)"
			end
			table.insert(exits, {d, desc})
		elseif PTSIZE(pp) == 2 then
			table.insert(exits, {d, string.format("\"%s\"", mem:string(GET(pp, 0)))})
		end
	end
	return exits
end

local function is_room_name(text)
	if not text then return false end
	text = tostring(text):gsub("^%s+", ""):gsub("%s+$", "")
	for room = 1, _obj_count do
		if GETP(room, PQLOC) == ROOMS and GETP(room, PQDESC) == text then
			return true
		end
	end
	return false
end

local function encode_fptr(n)
  return string.format("<@F:%X>", n)
end

local function decode_fptr(s)
    local hex = s:match("<@F:([A-Fa-f0-9]+)>")
    return hex and tonumber(hex, 16)
end

local function makebyte(val)
	return string.char(math.min(math.max(0,val), 0xff))
end

local function makeword(val)
	return string.char(val&0xff, (val>>8)&0xff)
end

local function makedword(val)
	return string.char(val&0xff, (val>>8)&0xff, (val>>16)&0xff, (val>>24)&0xff)
end

local function makeqword(val)
	return string.char(val&0xff, (val>>8)&0xff, (val>>16)&0xff, (val>>24)&0xff,
	                   (val>>32)&0xff, (val>>40)&0xff, (val>>48)&0xff, (val>>56)&0xff)
end

mem = setmetatable({size=0},{__index={
	write = function(self, buffer, pos)
		if not pos then pos = self.size + 1 end  -- Append if no pos
		local buf_len = #buffer
		assert(pos+buf_len-1 <= 0xffff, "Memory overflow: can't write beyond 65535")
		for i = 1, buf_len do
			local byte = buffer:byte(i)
			if pos + i - 1 > self.size then self.size = pos + i - 1 end
			self[pos + i] = byte
		end
		return pos
	end,

	stringprop = function (self, s)
		if type(s) == 'number' then s = encode_fptr(s) end
		return makeword(self:write(makeword(#s)..s))
	end,

	write_word = function(mem, k) return mem:write(makeword(k)) end,
	writestring2 = function(mem, s) return mem:write(makeword(#s)..s) end,

	table_to_str = function(self, start, end_pos)
		local bytes = {}
		local len = end_pos - start + 1
		for i = 1, len do bytes[i] = self:byte(start + i - 1) or 0 end
		return string.char(table.unpack(bytes))
	end,

	byte = function(self, idx) return self[idx+1] or 0 end,
	word = function(self, ptr) return self:byte(ptr)|(self:byte(ptr+1)<<8) end,
	dword = function(self, ptr) return self:byte(ptr)|(self:byte(ptr+1)<<8)|(self:byte(ptr+2)<<16)|(self:byte(ptr+3)<<24) end,
	qword = function(self, ptr) return self:byte(ptr)|(self:byte(ptr+1)<<8)|(self:byte(ptr+2)<<16)|(self:byte(ptr+3)<<24)|(self:byte(ptr+4)<<32)|(self:byte(ptr+5)<<40)|(self:byte(ptr+6)<<48)|(self:byte(ptr+7)<<56) end,
	string = function(self, ptr)
		local str = self:table_to_str(ptr + 2, ptr + self:word(ptr) + 1)
		return decode_fptr(str) or str
	end,

	read = function(self, size, pos)
		if size <= 0 then return "" end
		return self:table_to_str(pos, pos + size - 1)
	end
}})

local cache = {
	verbs = {},
	words = {},
	synonyms = {},
}

local function fn(f) 
	for n, ff in ipairs(FUNCTIONS) do if f == ff then return n end end
	table.insert(FUNCTIONS, f)
	return #FUNCTIONS
end

-- Expose fn as a global function for use in ZIL code
-- Converts a function reference to its index in the FUNCTIONS table
-- This is needed for clock system INT/QUEUE functions which expect routine numbers
function ROUTINE_NUM(f)
	if type(f) == 'number' then return f end  -- Already a number (routine index)
	if type(f) == 'function' then return fn(f) end  -- Convert function to index
	-- Invalid type - error with helpful message
	error("ROUTINE_NUM: expected function or number, got " .. type(f))
end

local function register(tbl, value)
	local n = 0
	if type(value) == "string" then value = value:lower() end
	
	-- Special handling for PREPOSITIONS to maintain array format
	if tbl == PREPOSITIONS then
		if tbl._hash[value] then
			return tbl._hash[value]
		end
		-- Count existing entries in the hash
		for k, v in pairs(tbl._hash) do n = n + 1 end
		local index = n + 1
		tbl._hash[value] = index
		-- Will be filled in learn() when word_ptr is available
		return index
	end
	
	-- Original logic for other tables
	for k, v in pairs(tbl) do n = n + 1 end
	if not tbl[value] then tbl[value] = n + 1 end
	return tbl[value]
end

-- === Utility functions ===

function VERBQ(...)
	return EQUALQ(PRSA, ...)
end

function RANDOM(base)
	local value = math.random(1, base)
	-- print(value)
	return value
end

function PICK_ONE(table)
	local num = mem:word(table)
	-- local sel = math.random(2, num)
	local sel = RANDOM(num-1)+1
	return mem:word(table+sel*2)
	-- local table_size = mem:byte(table)
	-- return mem:word(table + RANDOM(table_size) * 2)
end

function RANDOM_ELEMENT(frob)
	return GET(frob, RANDOM(GET(frob, 0)))
end

function PROB(base)
	return RANDOM(100) <= base
end

ZPROB = PROB

-- At the top of bootstrap, add output buffer
local output_buffer = {}
local zil_nil_return = {}

function ZIL_RETURN(value)
	if value == nil then
		error(zil_nil_return)
	end

	error(value)
end

function ZIL_UNWRAP_RETURN(value)
	if value == zil_nil_return then
		return nil
	end

	return value
end

local function io_write(...)
	-- Check if io_write was overridden globally (for tests)
	if _G.io_write then
		return _G.io_write(...)
	end
	-- Default: buffered mode for coroutine-based games
	for i = 1, select("#", ...) do
		table.insert(output_buffer, tostring(select(i, ...)))
	end
end

local function io_flush()
	-- Check if io_flush was overridden globally (for tests)
	if _G.io_flush then
		return _G.io_flush()
	end
	-- Default: return buffered content
	local text = table.concat(output_buffer)
	output_buffer = {}
	return text
end

local function is_control_signal(signal, kind)
	if kind then
		return signal == ZIL_CONTROL_SIGNALS[kind]
	end
	return signal == ZIL_CONTROL_SIGNALS.quit or signal == ZIL_CONTROL_SIGNALS.restart
end

function IS_ZIL_CONTROL_SIGNAL(signal, kind)
	return is_control_signal(signal, kind)
end

local function is_state_global(value)
	local value_type = type(value)
	return value_type == "number"
		or value_type == "boolean"
		or value_type == "string"
end

local function capture_game_state()
	local state = {
		mem_size = mem.size,
		mem_bytes = {},
		globals = {},
	}

	for i = 1, mem.size do
		state.mem_bytes[i] = mem[i]
	end
	for name, value in pairs(_G) do
		if is_state_global(value) then
			state.globals[name] = value
		end
	end

	return state
end

local function restore_game_state(state)
	for name, value in pairs(_G) do
		if is_state_global(value) and state.globals[name] == nil then
			_G[name] = nil
		end
	end
	for name, value in pairs(state.globals) do
		_G[name] = value
	end

	for i = state.mem_size + 1, mem.size do
		mem[i] = nil
	end
	for i = 1, state.mem_size do
		mem[i] = state.mem_bytes[i]
	end
	mem.size = state.mem_size
	output_buffer = {}
end

function CAPTURE_RESTART_STATE()
	restart_snapshot = capture_game_state()
	return true
end

function VERIFY()
	return true
end

function QUIT()
	error(ZIL_CONTROL_SIGNALS.quit, 0)
end

function RESTART()
	if not restart_snapshot then
		return false
	end

	restore_game_state(restart_snapshot)
	error(ZIL_CONTROL_SIGNALS.restart, 0)
end

function TELL(...)
	local object = false
	for i = 1, select("#", ...) do
		local v = select(i, ...)
		if v == D then object = true
		elseif object then object = false io_write(GETP(v, _G["PQDESC"]))
		elseif type(v) == "number" then io_write(mem:string(v))
		elseif v == '>' then -- skip
		else io_write(tostring(v)) end
	end
	return true
end

function PRINT(n) io_write(mem:string(n)) return true end
function PRINTD(ptr) io_write(GETP(ptr, _G["PQDESC"])) return true end
function PRINTR(ptr) io_write(GETP(ptr, _G["PQLDESC"])) return true end
function PRINTB(ptr)
	for word, index in pairs(cache.words) do
		if index == ptr then 
			io_write(word)
			return true
		end
	end
	return false
end
function PRINTI(n) io_write(tostring(n)) return true end
function PRINTN(n) io_write(tostring(n)) return true end
function PRINTC(ch) io_write(string.char(ch)) return true end
function PRINC(n) io_write(tostring(n)) return true end
function CRLF() io_write("\n") return true end

function JIGS_UP(msg)
	TELL(msg, CR)
	MOVE(WINNER, HERE)
	-- os.exit(1)
end

local routes = {
	['room-items'] = add_items,
	['room-exits'] = add_exits,
	['room-name?'] = is_room_name,
}

local function route_response(input)
	local route = routes[input]
	if route then
		return true, route(HERE)
	end

	if type(input) ~= "string" then
		return false
	end

	local route_name, arg = input:match("^([^:]+):(.*)$")
	route = routes[route_name]
	if route then
		return true, route(arg)
	end

	return false
end

-- Modified READ to yield with output
function READ(inbuf, parse)
	-- for k, v in pairs(_G) do
	-- 	if type(v) == 'boolean' then print(k, type(v)) end
	-- end

	-- Yield with accumulated output, get input back
	local s = coroutine.yield(io_flush())
	::restart_read::
	local handled, response = route_response(s)
	if handled then
		s = coroutine.yield(response)
		goto restart_read
	end
	-- Handle nil input (e.g., EOF)
	if not s then
		os.exit(0)
	end
	
	local p = {}
	for pos, word in s:gmatch("()(%S+)") do
		-- Z-machine truncates dictionary words to 6 characters
		local truncated = word:lower():sub(1, 6)
		local index = cache.words[truncated] or 0
		table.insert(p, makeword(index).. string.char(#word, pos&0xff))
	end
	mem:write(s: lower()..'\0', inbuf+1)
	mem:write(string.char(#p)..table.concat(p), parse+1)
end

-- Logic / bitwise
function NOT(a) return not a or a == 0 end
function PASS(a) return a end
function BAND(a, b) return a & b end
function BOR(a, b) return a | b end
function BTST(a, b) return (a & b) == b end

-- Arithmetic / comparison
function EQUALQ(a, ...)
	for i = 1, select("#", ...) do
		local b = select(i, ...)
		if (a or 0) == (b or 0) then return true end
		if type(a) == 'number' and type(b) == 'function' then
			for n, ff in ipairs(FUNCTIONS) do if b == ff then if a == n then return true end; break end end
		elseif type(a) == 'function' and type(b) == 'number' then
			for n, ff in ipairs(FUNCTIONS) do if a == ff then if b == n then return true end; break end end
		end
	end
	return false
end
function GASSIGNEDQ(name) return rawget(_G, tostring(name)) ~= nil end
function NEQUALQ(a, b) return not EQUALQ(a, b) end
function GQ(a, b) return (a or 0) > (b or 0) end
function LQ(a, b) return (a or 0) < (b or 0) end
function GEQ(a, b) return (a or 0) >= (b or 0) end
function LEQ(a, b) return (a or 0) <= (b or 0) end
function ZEROQ(a) return (a or 0) == 0 end
function ONEQ(a) return a == 1 end
function ADD(a, b) return (a or 0) + (b or 0) end
function SUB(a, b) return (a or 0) - (b or 0) end
function DIV(a, b) return (a or 0) // (b or 0) end
function MUL(a, b) return (a or 0) * (b or 0) end

-- function GQ(a, b) return a > b end
-- IGRTRQ = GQ
LESSQ = LQ
MULL = MUL

-- Object / room ops
-- Returns the mem address of object num's property table block.
-- _OTBL is the base of a 256×2-byte array allocated in mem by the first DECL_OBJECT call.
local function getobj(num) return mem:word(_OTBL + (num-1)*2) end

-- VALUE function: identity function for ZIL's <VALUE var> form
-- In ZIL, <VALUE var> gets the runtime value of a variable
function VALUE(x) return x end

function LOC(obj) return GETP(obj, PQLOC) end
function INQ(obj, room) return GETP(obj, PQLOC) == room end
function MOVE(obj, dest) PUTP(obj, PQLOC, dest) end
function REMOVE(obj) PUTP(obj, PQLOC, 0) end

function FIRSTQ(obj)
	for n = 1, _obj_count do
		if GETP(n, PQLOC) == obj then return n end
	end
end

function NEXTQ(obj)
	local parent = GETP(obj, PQLOC)
	local found = false
	for n = 1, _obj_count do
		if GETP(n, PQLOC) == parent then
			if found then return n end
			if n == obj then found = true end
		end
	end
end

local function learn(word, atom, value)
	local function upper2(word)
		local specials = {
			["."] = "PERIOD",
			[","] = "COMMA",
			["\""] = "QUOTE",
		}
		return specials[word] or word:upper()
	end
	local prim = {
		[PSQOBJECT]=P1QOBJECT,
		[PSQVERB]=P1QVERB,
		[PSQADJECTIVE]=P1QADJECTIVE,
		[PSQDIRECTION]=P1QDIRECTION,
		[PSQPREPOSITION]=P1QOBJECT,
		[PSQBUZZ_WORD]=P1QNONE,
	}
	if not word then return 0 end
	word = word:lower()
	-- Z-machine truncates dictionary words to 6 characters
	local word_key = word:sub(1, 6)
	if type(value) == 'table' then value = register(value, word) end
	if cache.words[word_key] then
		local index = cache.words[word_key]
		local ent = mem:read(7, cache.words[word_key])
		local new = string.char(0,0,0,0,ent:byte(5)|atom,ent:byte(6),value or OQANY)
		mem:write(new, index)
	else
		local enc = string.char(0,0,0,0,atom|prim[atom],value or OQANY,0)
		local pos = mem:write(enc)
		cache.words[word_key] = pos
		_G['WQ'..upper2(word)] = pos
	end
	for _, syn in ipairs(cache.synonyms[word_key] or {}) do
		local syn_key = syn:lower():sub(1, 6)
		if cache.words[syn_key] then
			mem:write(mem:read(8, cache.words[word_key]), cache.words[syn_key])
		end
	end
	
	-- Special handling for PREPOSITIONS: populate array format immediately
	if atom == PSQPREPOSITION and value and type(value) == 'number' then
		local word_ptr = cache.words[word_key]
		if word_ptr and PREPOSITIONS._hash[word_key] then
			-- Add to array format: [0]=count, [1]=word_ptr1, [2]=index1, [3]=word_ptr2, [4]=index2, ...
			local count = PREPOSITIONS[0]
			PREPOSITIONS[count * 2 + 1] = word_ptr
			PREPOSITIONS[count * 2 + 2] = value
			PREPOSITIONS[0] = count + 1
		end
	end
	
	return value or cache.words[word_key]
end


function FSET(obj, flag)
	PUTP(obj, PQFLAGS, GETP(obj, PQFLAGS) | (1 << flag))
	assert(FSETQ(obj, flag), string.format("Failed to set flag %d on object %d", flag, obj))
end
function FCLEAR(obj, flag)
	PUTP(obj, PQFLAGS, GETP(obj, PQFLAGS) & ~(1 << flag))
	assert(not FSETQ(obj, flag), string.format("Failed to clear flag %d on object %d", flag, obj))
end
function FSETQ(obj, flag)
	return (GETP(obj, PQFLAGS) & (1 << flag)) ~= 0
end
function GETPT(obj, prop)
	local tbl = getobj(obj)
	local l = mem:byte(tbl)+tbl+1
	local pname, psize = mem:byte(l), mem:byte(l+1)
	local header = 2
	while psize > 0 do
		if pname==prop then return l+header end
		l = l+psize+header
		pname, psize = mem:byte(l), mem:byte(l+1)
	end
end
function PTSIZE(ptr)
	return mem:byte(ptr-1)
end
function PUTP(obj, prop, val)
	local ptr = GETPT(obj, prop)
	if type(val) == 'string' then
		assert(PTSIZE(ptr) == 2, "String property "..prop.." size must be 2")
		mem:write(mem:stringprop(val), ptr)
		return
	elseif type(val) == 'function' then
		assert(PTSIZE(ptr) == 2, "Function property "..prop.." size must be 2")
		mem:write(mem:stringprop(fn(val)), ptr)
	end
	assert(type(val) == 'number', "Only numbers are supported in PUTP, not "..type(val))
	if PTSIZE(ptr) == 1 then mem:write(makebyte(val), ptr)
	elseif PTSIZE(ptr) == 2 then mem:write(makeword(val), ptr)
	elseif PTSIZE(ptr) == 4 then mem:write(makedword(val), ptr)
	elseif PTSIZE(ptr) == 8 then mem:write(makeqword(val), ptr)
	else
		error("Unsupported property size for number: "..PTSIZE(ptr))
	end
end
function GETP(obj, prop)
	if not GETPT(obj, prop) then return nil end
	local ptr = GETPT(obj, prop)
	local ptsize = PTSIZE(ptr)
	if ptsize == 1 then return mem:byte(ptr) end
	if ptsize == 2 then return mem:word(ptr) ~= 0 and mem:string(mem:word(ptr)) or nil end
	if ptsize == 4 then return mem:dword(ptr) end
	if ptsize == 8 then return mem:qword(ptr) end
	assert(false, "Unsupported property to get")
end
function NEXTP(obj, prop)
	-- Returns the next property number after prop
	-- If prop is 0, returns the first property
	-- If no more properties, returns 0
	local tbl = getobj(obj)
	local l = mem:byte(tbl)+tbl+1
	local pname, psize = mem:byte(l), mem:byte(l+1)
	local header = 2
	local found = (prop == 0)  -- If prop is 0, return first property
	while psize > 0 do
		if found then
			-- Return this property (the next one after prop)
			return pname
		end
		if pname == prop then
			-- Found the requested property, next iteration will return the next one
			found = true
		end
		l = l+psize+header
		pname, psize = mem:byte(l), mem:byte(l+1)
	end
	return 0  -- No more properties
end

table.concat2 = function(t, fn)
	local tmp = {}
	for i, s in ipairs(t) do tmp[i] = fn(s) end
	return table.concat(tmp)
end

function DECL_OBJECT()
	if not _OTBL or _OTBL == 0 then
		-- Allocate the 256×2-byte object pointer table on first use
		_OTBL = mem:write(string.rep('\0\0', 256))
	end
	_obj_count = _obj_count + 1
	assert(_obj_count <= 255, "Too many objects (max 255)")
	return _obj_count
end

function OBJECT(object)
	local function resolve_global(value)
		if type(value) == "string" then
			return rawget(_G, value) or value
		end
		return value
	end
	local function function_prop(value)
		value = resolve_global(value)
		return type(value) == 'function' and mem:stringprop(fn(value)) or '\0\0'
	end
	local function makeprop(body, name)
		local num = register(PROPERTIES, name)
		if not _G["PQ"..name] then _G["PQ"..name] = num end
		return string.char(num,#body)..body
	end
	if object.DESC then
		table.insert(DESCS, object.DESC)
		table.insert(DESCS, object.DESC:lower())
	end
	local n = _G[object.NAME]
	local t = {string.char(#object.NAME), object.NAME}
	assert(n, "DECL_OBJECT not called for "..object.NAME)
	for k, v in pairs(object) do
		if k == "NAME" then 
		elseif k == "SYNONYM" then
			local body = table.concat2(v, function(syn)
				return makeword(learn(syn, PSQOBJECT, nil))
			end)
			table.insert(t, makeprop(body, k))
		elseif k == "ADJECTIVE" then
			table.insert(t, makeprop(table.concat2(v, function(adj)
				return string.char(learn(adj, PSQADJECTIVE, ADJECTIVES))
			end), k))
		elseif k == "FLAGS" then
			local flags = 0
			for _, f in ipairs(v) do
				if not _G[f] then _G[f] = register(FLAGS, f) end
				flags = flags | (1 << _G[f])
			end
			table.insert(t, makeprop(makeqword(flags), k))
		elseif k == "GLOBAL" then 	
			table.insert(t, makeprop(table.concat2(v, string.char), k))
		elseif k == "LOC" then 
			-- LOC property: stores the object's location as a numeric object ID
			-- In proper ZIL games, containers like ROOMS are defined as objects with numeric IDs
			-- If LOC is a table (e.g., bootstrap's default ROOMS = {}), we use 0 to indicate "no valid location"
			-- This is acceptable because well-formed ZIL will redefine ROOMS as an actual object
			-- Once ROOMS is defined as an object, its numeric ID will be used correctly
			local loc_value = type(v) == 'number' and v or 0
			table.insert(t, makeprop(makebyte(loc_value), k))
		-- using PQACTION for ACTION property, commented out original function support
		elseif k == "ACTION" or k == "DESCFCN" then 
			table.insert(t, makeprop(function_prop(v), k))
		elseif type(v) == 'string' then table.insert(t, makeprop(mem:stringprop(v), k))
		elseif type(v) == 'number' then table.insert(t, makeprop(makebyte(v), k))
		elseif type(v) == 'function' then table.insert(t, makeprop(mem:stringprop(fn(v)), k))
		elseif _DIRECTIONS[k] or (type(v) == "table" and (v.per or v[1] ~= nil)) then
			if not _DIRECTIONS[k] then DIRECTIONS(k) end
			local str
			if type(v) == 'number' then
				-- UEXIT: bare number from compiler (e.g., SOUTH = ROOM_ID)
				str = string.char(v)
			elseif type(v) == 'string' then
				-- NEXIT: bare string from compiler (e.g., OUT = "message")
				str = mem:write(v.."\0")
			elseif v.per then
				local per = resolve_global(v.per)
				str = makeword(fn(per))..string.char(0) -- FEXIT = 3
			elseif type(v[1]) == 'string' then
				str = mem:write(v[1].."\0") -- NEXIT = 2
			else
				if v[1] == nil then
					error(string.format("Unresolved exit target for %s.%s", tostring(object.NAME), tostring(k)))
				end
				str = string.char(v[1]) -- UEXIT = 1
				local say = v.say and mem:write(v.say.."\0") or 0
				if v.door ~= nil then
					local door = type(v.door) == "boolean" and (v.door and 1 or 0) or v.door
					str = str..string.char(door)..makeword(say)..string.char(0) -- DEXIT = 5
				elseif v.flag ~= nil then
					local flag = type(v.flag) == "boolean" and (v.flag and 1 or 0) or v.flag
					str = str..string.char(flag)..makeword(say) -- CEXIT = 4
				end
			end
			table.insert(t, makeprop(str, k))
		else 
			assert(false, "Unsupported property "..k.." of type "..type(v))
		end
	end
	-- Ensure LOC property always exists (default to 0 if not specified)
	if not object.LOC then
		local loc_value = 0
		table.insert(t, makeprop(makebyte(loc_value), "LOC"))
	end
	-- Ensure FLAGS property always exists (default to 0 if not specified)
	if not object.FLAGS then
		table.insert(t, makeprop(makeqword(0), "FLAGS"))
	end
	local tbl_addr = mem:write(table.concat(t) .. "\0\0")
	mem:write(makeword(tbl_addr), _OTBL + (n-1)*2)
end

function REST(s, i)
	if type(s) == 'number' then
		return s+(i or 1)
	end
	if type(s) == 'table' then s = string.char(#s)..table.concat(s) end
	return s:sub((i or 1) + 1)
end

function APPLY(func, ...)
	if type(func) == 'number' then
		if func == 0 then return end
		return FUNCTIONS[func](...)
	else
		return func and func(...)
	end
end

function PUT(obj, i, val)
	assert(type(obj) == 'number', "PUT: Only number types, not "..type(obj))
	mem:write(makeword(type(val) == 'function' and fn(val) or val or 0), obj+i*2)
end

function PUTB(s, i, val) 
	assert(type(s) == 'number', "PUTB: Only number types, not "..type(s))
	mem:write(makebyte(val), s+i)
end
-- function GET(t, i) return type(t) == 'table' and t[i * 2] or 0 end
-- function GETB(t, i) return type(t) == 'table' and t[i] or 0 end

function GETB(s, i)
	assert(type(s) == 'number', "GETB: Only number types")
	if s == 0 then return GET(s) end
	return mem:byte(s+i)
	-- if s == 0 then return GET(s)
	-- elseif type(s) == 'string' then return i==0 and #i or s:byte(i)
	-- elseif type(s) == 'table' then return i==0 and #s or table.concat(s):byte(i)
	-- elseif type(s) == 'number' then return mem:byte(s+i)
	-- else 
	-- 	error("GETB: Unsupported type "..type(s))
	-- end
end

function GET(s, i)
	if s == 0 then
		-- Z-machine header mockup
		s = {
			[0] = 3,       -- version (not actually used)
			[1] = 15,      -- release number (Release 15)
			[8] = 0,       -- Flags 2 (transcript bit is bit 0)
		}
	end
	if not i then return 0 end
	if type(s) == 'number' then
		return (GETB(s,i*2) or 0)|((GETB(s,i*2+1) or 0)<<8)
	end
	assert(type(s) == 'table', "GET requires a table")
	return i == 0 and #s or s[i]
	-- if type(s) == 'table' then return s.index and s:index(i) or s[i] end
	-- return GETB(s, i * 2) | (GETB(s, i * 2 + 1) << 8)
end

function DIRECTIONS(...)
	for _, dir in ipairs {...} do
		_DIRECTIONS[dir] = learn(dir, PSQDIRECTION, PROPERTIES)
		if type(DIRS) == "table" and dir ~= "IN" and dir ~= "OUT" then
			table.insert(DIRS, dir:lower())
		end
	end
end

local function action_id(fn_idx)
	if _act_fn_to_id[fn_idx] then return _act_fn_to_id[fn_idx] end
	_act_count = _act_count + 1
	assert(_act_count <= 255, "Too many actions (max 255)")
	_act_fn_to_id[fn_idx] = _act_count
	-- Write fn_idx at offset _act_count*2 so that GET(ACTIONS, _act_count) = mem:word(ACTIONS + _act_count*2) reads it back.
	-- Action IDs are 1-based; offset 0 is unused (same convention as VERBS).
	mem:write(makeword(fn_idx), ACTIONS + _act_count * 2)
	return _act_count
end

function TRACEBACK()
	print(debug.traceback())
end

function PTABLE(tbl, size)
	local out = {}
	for i = 0, size do table.insert(out, GET(tbl, i)) end
	print(table.concat(out, " "))
end

function SYNTAX(syn)
	VERBS = VERBS or mem:write(string.rep('\0\0', 256))
	if ACTIONS == 0 then
		ACTIONS = mem:write(string.rep('\0\0', 256))
		PREACTIONS = mem:write(string.rep('\0\0', 256))
	end
	local name = syn.VERB:lower()
	if not syn.ACTION then
		error(string.format("SYNTAX for verb '%s' is missing ACTION", syn.VERB))
	end
	local action = action_id(fn(_G[syn.ACTION]))
	local function encode(s)
		return string.char(
			s.OBJECT and (s.SUBJECT and 2 or 1) or 0,
			learn(s.PREFIX, PSQPREPOSITION, PREPOSITIONS),
			learn(s.JOIN, PSQPREPOSITION, PREPOSITIONS),
			s.OBJECT and s.OBJECT.FIND or 0,
			s.SUBJECT and s.SUBJECT.FIND or 0,
			s.OBJECT and s.OBJECT.WHERE or 0,
			s.SUBJECT and s.SUBJECT.WHERE or 0,
			action
		)
	end
	if cache.verbs[name] then
		local ptr = GET(VERBS, cache.verbs[name])
		local num = GETB(ptr, 0)
		local bytecode = encode(syn)
		mem:write(string.char(num + 1), ptr)
		mem:write(bytecode, ptr + 1 + num * #bytecode)
	else
		local num = register(cache.verbs, name)
		local bytecode = string.rep(encode(syn), _G["NUM_"..syn.VERB] or 1)
		PUT(VERBS, num, mem:write(string.char(1)..bytecode))
		_G['ACTQ'..syn.VERB] = learn(name, PSQVERB, 255-num)
	end
	_G[syn.ACTION:gsub("_", "Q", 1)] = action
	if syn.PREACTION then 
		mem:write(makeword(fn(_G[syn.PREACTION])), PREACTIONS + action * 2)
	end
end

function BUZZ(...)
	for _, buzz in ipairs {...} do
		learn(buzz, PSQBUZZ_WORD, nil)
		_G['WQ'..buzz:upper()] = cache.words[buzz:lower():sub(1, 6)]
	end
end

function SYNONYM(verb, ...)
	verb = verb:lower():sub(1, 6)
	cache.synonyms[verb] = {...}
  for _, syn in ipairs {...} do
		-- Truncate to 6 chars (Z-machine dictionary convention)
		local syn_key = syn:lower():sub(1, 6)
		if cache.words[verb] then
			cache.words[syn_key] = mem:write(mem:read(8, cache.words[verb]))
		else
			cache.words[syn_key] = mem:write(string.rep('\0', 8))
		end
		_G['WQ'..syn:upper()] = cache.words[syn_key]
  end
end

ROOM = OBJECT

function ITABLE(size, maybe_size)
	if size == nil and type(maybe_size) == "number" then
		size = maybe_size
	end
	local address = mem:write_word(size)
	mem:write(string.rep("\0", size))
	return address
end

function TABLE(...)
	local tbl = {}
	for i = 1, select("#", ...) do
    local v = select(i, ...)
		if type(v) == 'string' then table.insert(tbl, makeword(mem:writestring2(v)))
		elseif type(v) == 'number' then table.insert(tbl, makeword(v))
		elseif type(v) == 'nil' then table.insert(tbl, makeword(0))
		else error("LTABLE: Unsupported type "..type(v))
		end
	end
	return mem:write(table.concat(tbl))
end

function LTABLE(...)
	local n = select("#", ...)
	local tbl = {}
	for i = 1, n do
    local v = select(i, ...)
		if type(v) == 'string' then table.insert(tbl, makeword(mem:writestring2(v)))
		elseif type(v) == 'number' then table.insert(tbl, makeword(v))
		elseif type(v) == 'nil' then table.insert(tbl, makeword(0))
		else error("LTABLE: Unsupported type "..type(v))
		end
	end
	local address = mem:write_word(n)
	mem:write(table.concat(tbl))
	return address
end

BUZZ(".", ",", "\"")


-- ENABLE/DISABLE helpers for clock interrupts
-- These are defined as macros in ZIL (macros.zil) but we implement them as functions
-- ENABLE: <DEFMAC ENABLE ('INT) <FORM PUT .INT ,C-ENABLED? 1>>
-- DISABLE: <DEFMAC DISABLE ('INT) <FORM PUT .INT ,C-ENABLED? 0>>
function ENABLE(i)
    PUT(i, C_ENABLEDQ, 1)
    return i
end

function DISABLE(i)
    PUT(i, C_ENABLEDQ, 0)
    return i
end

function FLAMINGQ(OBJ)
	return FSETQ(OBJ, FLAMEBIT) and FSETQ(OBJ, ONBIT)
end

function OPENABLEQ(OBJ)
		return FSETQ(OBJ, DOORBIT) or FSETQ(OBJ, CONTBIT)
end

function CO_CREATE(func)
	local co = coroutine.create(function(...)
		while true do
			local ok, result = pcall(func, ...)
			if ok then
				return result
			end
			if is_control_signal(result, "restart") then
				-- Restart reruns the entry routine from the captured initial state.
			elseif is_control_signal(result, "quit") then
				return
			else
				error(result, 0)
			end
		end
	end)
	coroutine.resume(co)  -- Start the coroutine
	return co
end

 -- if only_flag is true, return only success flag, for chaining of arguments
function CO_RESUME(co, param, only_flag)
	_G.TEST_BREADCRUMB_STEP = (_G.TEST_BREADCRUMB_STEP or 0) + 1
	_G.TEST_BREADCRUMB_COMMAND = param
	local ok, err = coroutine.resume(co, param)
	if only_flag then
		return ok
	else
		return ok, err
	end
end

local function dirname(path)
	return path and path:match("^(.*)[/\\][^/\\]*$") or nil
end

local function try_open(path)
	local file = io.open(path, "r")
	if file then return file, path end
	local lower = path:lower()
	if lower ~= path then
		file = io.open(lower, "r")
		if file then return file, lower end
	end
	return nil, nil
end

-- INSERT_FILE loads and executes a ZIL file
-- This is used by INSERT-FILE directive to include other files
function INSERT_FILE(filename, source_filename)
	-- Convert module-style filename (e.g., "zork1.globals") to file path
	local name_path = filename:gsub("%.", "/")
	local file, filepath

	local function try_candidate(path)
		if not path or path == "" then return nil end
		file, filepath = try_open(path)
		if file then return true end
		if not path:match("%.zil$") then
			file, filepath = try_open(path .. ".zil")
			if file then return true end
		end
		return false
	end

	local base_dir = dirname(source_filename)
	if base_dir and not name_path:match("^/") and try_candidate(base_dir .. "/" .. name_path) then
		-- Found relative to including file.
	end
	
	-- Search for the file using package.zilpath if available
	if not file and package and package.zilpath then
		for path_pattern in package.zilpath:gmatch("[^;]+") do
			if try_candidate(path_pattern:gsub("?", name_path):gsub("%.zil$", "")) then
				break
			end
		end
	end
	
	-- If not found, try direct path with .zil extension
	if not file then try_candidate(name_path) end
	
	-- If still not found, try the filename as-is
	if not file then try_candidate(filename) end
	
	-- Final fallback: try infocom/zork1/ as substrate
	if not file and not name_path:match("infocom/zork[123][/\\]") then
		try_candidate("infocom/zork1/" .. name_path)
	end
	
	if not file then
		error(string.format("INSERT_FILE: Cannot open '%s' (resolved to '%s', tried package.zilpath and direct paths)", filename, name_path))
	end
	
	local content = file:read("*all")
	file:close()
	
	-- Parse and compile the ZIL content
	local parser = require 'zilscript.parser'
	local compiler = require 'zilscript.compiler'
	local sourcemap = require 'zilscript.sourcemap'
	
	local ok, ast = pcall(parser.parse, content, filepath)
	if not ok then
		error(string.format("%s: Failed to parse: %s", filepath, ast))
	end
	
	local result = compiler.compile(ast, filepath .. ".lua")
	
	-- Execute the compiled code in the current environment
	local chunk, load_err = load(result.combined, "@" .. filepath, "t", _G)
	if not chunk then
		error(string.format("%s: Failed to load: %s", filepath, sourcemap.translate(load_err)))
	end
	
	local exec_ok, exec_err = pcall(chunk)
	if not exec_ok then
		error(string.format("%s: Failed to execute: %s", filepath, sourcemap.translate(exec_err)))
	end
end

-- === Save / Restore game state ===
-- The save file contains: mem (which holds object properties, locations, and FLAGS),

local SAVE_MAGIC = "ZILSAVE\1"
local SAVE_CHUNK_SIZE = 4096  -- Write mem to file in chunks to avoid table.unpack limits

-- Write a 4-byte little-endian integer into file
local function write_int32(file, val)
	file:write(string.char(val & 0xff, (val >> 8) & 0xff, (val >> 16) & 0xff, (val >> 24) & 0xff))
end

-- Write an 8-byte little-endian integer into file
local function write_int64(file, val)
	write_int32(file, val & 0xffffffff)
	write_int32(file, (val >> 32) & 0xffffffff)
end

-- Read a 4-byte little-endian integer from a 4-byte string
local function read_int32(s)
	return s:byte(1) | (s:byte(2) << 8) | (s:byte(3) << 16) | (s:byte(4) << 24)
end

-- Read an 8-byte little-endian integer from a string at byte offset 1..8
local function read_int64(s)
	local val = 0
	for i = 1, 8 do val = val | (s:byte(i) << ((i - 1) * 8)) end
	return val
end

function SAVE(filename)
	filename = filename or "savefile.sav"
	local file = io.open(filename, "wb")
	if not file then
		TELL("Cannot open save file.", CR)
		return false
	end

	-- Header
	file:write(SAVE_MAGIC)

	-- mem: size (4 bytes LE) + raw bytes written in chunks
	local size = mem.size
	write_int32(file, size)
	local pos = 1
	while pos <= size do
		local chunk_end = math.min(pos + SAVE_CHUNK_SIZE - 1, size)
		local bytes = {}
		for i = pos, chunk_end do bytes[#bytes + 1] = mem[i] or 0 end
		file:write(string.char(table.unpack(bytes)))
		pos = chunk_end + 1
	end

	-- ZIL globals: count (2 bytes LE) + name-length-prefixed name + typed value
	local to_save = {}
	for name, val in pairs(_G) do
		if type(val) == 'number' or type(val) == 'boolean' then
			table.insert(to_save, {name, val})
		end
	end
	file:write(makeword(#to_save))
	for _, entry in ipairs(to_save) do
		local name, val = entry[1], entry[2]
		local namelen = math.min(#name, 255)
		file:write(string.char(namelen) .. name:sub(1, namelen))
		if type(val) == 'number' then
			file:write(string.char(1))  -- type 1 = number
			write_int64(file, val)
		else
			file:write(string.char(2))  -- type 2 = boolean
			file:write(string.char(val and 1 or 0))
		end
	end

	file:close()
	return true
end

function RESTORE(filename)
	filename = filename or "savefile.sav"
	local file = io.open(filename, "rb")
	if not file then
		TELL("Cannot open save file.", CR)
		return false
	end

	-- Verify header
	local magic = file:read(#SAVE_MAGIC)
	if magic ~= SAVE_MAGIC then
		TELL("Invalid save file.", CR)
		file:close()
		return false
	end

	-- Restore mem
	local sb = file:read(4)
	if not sb or #sb < 4 then file:close(); return false end
	local size = read_int32(sb)
	local data = file:read(size)
	if not data or #data < size then file:close(); return false end
	for i = 1, size do mem[i] = data:byte(i) end
	mem.size = size

	-- Restore ZIL globals
	local gc = file:read(2)
	if gc and #gc >= 2 then
		local num_globals = gc:byte(1) | (gc:byte(2) << 8)
		for _ = 1, num_globals do
			local nl = file:read(1)
			if not nl then break end
			local name = file:read(nl:byte())
			if not name then break end
			local gtype = file:read(1)
			if not gtype then break end
			if gtype:byte() == 1 then
				local vb = file:read(8)
				if vb and #vb >= 8 then _G[name] = read_int64(vb) end
			elseif gtype:byte() == 2 then
				local vb = file:read(1)
				if vb then _G[name] = vb:byte() ~= 0 end
			end
		end
	end

	file:close()
	return true
end

-- === Done ===
print("ZIL runtime initialized.")
