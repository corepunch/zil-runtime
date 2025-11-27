-- local utils = require "translator.utils"
local parser = {}

local function is(word, class) if not word then return false end
  for i = 1, #class do
		if word:sub(1,1):upper() == class:sub(i,i) then return true end
	end
end

local function find(t, s) if not t then return false end
	for i = 1, #s do for j = 1, #t do
		if is(t[j], s:sub(i,i)) then return t[j] end
	end end
end

local choose

-- существительное
local function noun(t, p, i)
  return find(t[i], "N") or t[i][1]
end

-- прилагательное перед существительным
local function adj(t, p, i)
  return is(choose(t, p, i+1), "AN") and find(t[i], "A") or noun(t, p, i)
end

-- глагол после местоимения
local function verb(t, p, i)
	return is(p, "RN") and find(t[i], "VZ") or adj(t, p, i)
end

-- местоимение
choose = function(t, p, i)
	if not t[i] then return nil end
  if #t[i] == 1 then return t[i][1] end
	return find(t[i], "R") or verb(t, p, i)
end

function parser.collect(ts)
  local out, prev = {}, nil
  for i = 1, #ts do
		prev = choose(ts, prev, i)
		table.insert(out, prev)
  end
  return out
end

return parser