local utils = require "translator.utils"
local load = {}

local function split(self, sep)
  return self:match("^(.-)" .. sep .. "(.*)$")
end

local function extract_phrase(input)
  local result = { phrase = true }
  for word in input:gmatch("([%a ][0-9]*[\127-\255]+)") do
    table.insert(result, word)
  end
  return result
end

local function extract_pronoun(input)
  local result = { pronoun = true }
  for word in input:gmatch("([%a][0-9]*[\127-\255]+)") do
    table.insert(result, word)
  end
  return result
end

local function extract_variants(input)
  local result = { variants = true }
  for pre, word in input:gmatch("([%a])%.([\127-\255]+)") do
    table.insert(result, pre..word)
  end
  return result
end

function load.lingua(entries, line)
  -- local types = {
  --   N="noun", V="verb", A="adjective", D="adverb", E="past participle", 
  --   W="phrase", I="idiom", P="preposition", n="noun plural"
  -- }
  -- Skip "LTech DIC File 2.00\x1aERS\x00"

  local function add(tbl, key, value)
		-- if value:sub(1,1) == 'U' then print(key, utils.decode(value)) end
    local verb, particle = split(key, ' ')
    if particle then
      tbl[verb] = tbl[verb] or {}
      add(tbl[verb], particle, value)
    else
      tbl[key] = tbl[key] or {}
      if value:sub(1,1) == 'W' then
        tbl[key].__lex = extract_phrase(value)
      elseif value:sub(1,1) == 'R' or value:sub(1,1) == 'Z' then
        tbl[key].__lex = extract_pronoun(value)
      elseif value:sub(1,3) == 'ZV.' then
        tbl[key].__lex = extract_variants(value)
      else
        tbl[key].__lex = {value}
      end
    end
  end
  local key, value = split(line, '\x2a')
  if value then
    -- local _, count = line:gsub(" ", "")  -- replaces spaces with nothing, returns count
    -- if count > 2 then print(utils.decode(line)) end

    -- if utils.decode(value):find("уступать") then print(key, utils.decode(value)) end
    -- if value:find("turns") then print(key, utils.decode(value)) end
    -- if value:sub(1,1) == 'R' then print(key, utils.decode(value)) end
    -- if value:find('0', 1, true) then print(key, utils.decode(value)) end
    add(entries, key, value)
  end
end

return load