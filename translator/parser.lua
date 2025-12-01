local utils = require "translator.utils"
local parser = {}

local function is(word, class)
	if not word then return false end
  for i = 1, #class do
		if word:sub(1,1) == 'W' then
			if word:upper():find(class:sub(i,i)) then return true end
		else
			if word:sub(1,1):upper() == class:sub(i,i) then return true end
		end
	end
end

local function find(t, s) 
	if not t then return false end
	for i = 1, #s do if t[s:sub(i,i)] then return t[s:sub(i,i)] end end
end

local choose

-- предлог
local function preposition(t, p, i)
  return find(t[i], "P") or t[i][1]
end

-- существительное
local function conjunction(t, p, i)
  return find(t[i], "C") or preposition(t, p, i)
end

-- существительное
local function noun(t, p, i)
  return find(t[i], "N") or conjunction(t, p, i)
end

-- прилагательное перед существительным
local function adverb(t, p, i)
  return is(choose(t, p, i+1), "ANP") and find(t[i], "DI") or noun(t, p, i)
end

-- прилагательное перед существительным
local function adj(t, p, i)
  return is(choose(t, p, i+1), "AN") and find(t[i], "AO") or adverb(t, p, i)
end

-- глагол после местоимения
local function verb(t, p, i)
	return is(p, "XRN~") and find(t[i], "VZGXF") or adj(t, p, i)
end

-- местоимение
choose = function(t, p, i)
	if not t[i] then return nil end
  if #t[i] == 1 then return t[i][1] end
	return find(t[i], "RS") or verb(t, p, i)
end

function parser.collect(ts)
  local out, prev = {}, nil
  for i = 1, #ts do
		local sym = choose(ts, prev, i)
		if sym and sym ~= "" then
			if sym:sub(1,1) == 'W' then
				for word in sym:gmatch("([%a ][0-9]*[\127-\255]+)") do
					table.insert(out, word)
					prev = word
				end
			else
				table.insert(out, sym)
				prev = sym
			end
			-- print(utils.decode(sym))
		else
			print('skip', utils.debug(ts[i], nil, 1))
		end
  end
  return out
end

return parser