local parser = require "translator.parser"
local compiler = require "translator.compiler"
local utils = require "translator.utils"
local load = require "translator.load"
local paradigms = require "translator.paradigms"

local file = assert(io.open("translator/LTGOLD/BASE.DIC", "r"))
local file2 = assert(io.open("translator/LTGOLD/BASE.RUS", "r"))
local en_ru = {}
local base = {}

compiler.base = base

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
  -- if code and code:find('Z', 1, true) and code:find('N', 1, true) then
  --   print(word.." "..utils.decode(code, false))
  -- end
  load.lingua(en_ru, line)
end
for line in file2:lines() do 
  -- parse_lingua(base, line
  local word, code = line:match("^(.-)\x2a(.*)$")
  -- if code and code:byte(3) and (code:byte(3)&0x01)>0 and code:sub(1,1)=='N' then
  -- if code and utils.decode(word) == 'человек' then --and code:sub(1,1) == 'N' and code:byte(4)==0x81 then
  -- if code and code:sub(1,1)=='N' and (code:byte(4) or 0)==0x80+23 then
  -- if code and code:sub(1,1)=='N' and (code:byte(3) or 0)&0x4==04 then
  --   print(tohex(code:sub(2)), utils.decode(word), code:sub(1,1))
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

-- print(utils.debug(en_ru.transfer.speed))
-- print(utils.debug(en_ru.restore))

print("Input: You turn off bright light")
local s, e = parser.collect(--"{subject} {verb} {object}", 
-- utils.tokenize("You restore my bright light", en_ru))
  utils.tokenize("You turn off bright light", en_ru))

if e then print(e) end

if s then
  compiler.compile(s)
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
