local parser = require "translator.parser"
local utils = require "translator.utils"
local load = require "translator.load"
local paradigms = require "translator.paradigms"

local file = assert(io.open("translator/LTGOLD/BASE.DIC", "r"))
local file2 = assert(io.open("translator/LTGOLD/BASE.RUS", "r"))
local en_ru = {}
local base = {}

local function tohex(s)
    local t = {}
    for i = 1, #s do t[#t+1] = string.format("%02X", s:byte(i)) end
    return table.concat(t, " ")
end

local function tobin(s)
    local t = {}
    for i = 1, #s do
        local b = s:byte(i)
        local bin = ""
        for bit = 7, 0, -1 do
            local bitval = ((b >> bit) & 1)
            bin = bin .. (bitval == 1 and "X" or ".")
        end
        t[#t+1] = bin
    end
    return table.concat(t, " ")
end

for line in file:lines() do 
  local word, code = line:match("^(.-)\x2a(.*)$")
  if code and code:sub(1,1) == 'U' then
    print(utils.decode(code, false))
  end
  load.lingua(en_ru, line) 
end
for line in file2:lines() do 
  -- parse_lingua(base, line
  local word, code = line:match("^(.-)\x2a(.*)$")
  -- if code and code:byte(3) and (code:byte(3)&0x01)>0 and code:sub(1,1)=='N' then
  -- if code and code:sub(1,1) == 'A' then-- and code:byte(4) == 0x80+19 then
    -- print(tohex(code:sub(2)), utils.decode(word), code:sub(1,1))
    -- print(tohex(code:sub(2,5)), utils.decode(code:sub(2)))
  -- end
  if code then
    base[utils.decode(word)] = code
  end
end

file:close()
file2:close()

-- local function find_actor(words)
--   for _, w in ipairs(words) do
--     if utils.decode(w):match("^R([^%s%.]+)") then return w end
--   end
--   return nil
-- end

print(utils.debug(en_ru.restore))

local s, e = parser.collect("{subject} {verb} {object}", 
-- utils.tokenize("You restore my bright light", en_ru))
  utils.tokenize("You restore my tiny hope", en_ru))

if e then print(e) end

local u_endings = {
  ["011"] = "ен",    -- I do
  ["012"] = "ен",    -- you do (sg)
  ["03"]  = "но",    -- he/she/it does
  ["031"] = "ен",    -- he/she/it does
  ["032"] = "на",    -- he/she/it does
  ["11"]  = "ны",    -- we do
  ["12"]  = "ны",    -- you do (pl)
  ["13"]  = "ны",    -- they do
}

local function verb(primary, transform, secondary)
  local d = utils.decode(primary, true)
  if (primary:sub(1,1) == 'V' or primary:sub(1,1) == 'Z') and base[d] then
    local conf = base[d]
    local index = conf:byte(4)&~0x80
    d = paradigms.verb(primary, index, transform or 3)
  end
  -- if primary:sub(1,1) == 'U' then d = suffix(d, "ен", u_endings[transform or "031"]) end
  if secondary then
    local conf = base[utils.decode(secondary, true)]
    secondary = utils.decode(conf and conf:sub(6) or secondary)
    return d.." "..secondary
  else return d end
end

local function noun(s, ...)
  local t = {}
  local gender = 3
  print('м', tohex(base['м']))
  print('ярк', tohex(base['ярк']))
  if base[utils.decode(s, true)] then 
    gender = base[utils.decode(s, true)]:byte(3)&3 
  end
  for _, a in ipairs {...} do 
    local _a = utils.extract(a)
    local d = utils.decode(_a:sub(1, #_a-2), true)
    if base[d] then
      local code = (base[d]:byte(2)==0x80 and base[d]:byte(3) or base[d]:byte(4))&~0x80
      print(utils.decode(s, true), gender, code)
      table.insert(t, paradigms.adjective(a, code, gender, 1))
    else
      table.insert(t, utils.decode(a, true)..'*')
    end
  end
  table.insert(t, utils.decode(s, true))
  return table.concat(t, " ")
end

local function read_transform(noun)
  local num1, num2 = noun:match("R(%d)(%d)")
  local a, b = num1 or 0, num2 or 3
  return a * 3 + b
end

if s then
  print(
    table.concat({
      noun(s.subject.noun, table.unpack(s.subject)),
      verb(s.verb.verb, read_transform(s.subject.noun), s.verb.secondary),
      noun(s.object.noun, table.unpack(s.object))}, 
    " "))
end

-- io.write = function(...)
--     local out = {}
--     for i = 1, select("#", ...) do
--         local s = tostring(select(i, ...))
--         out[#out+1] = translate(s)
--     end
--     return old_write(table.concat(out))
-- end

os.exit()
