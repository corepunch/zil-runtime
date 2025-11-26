-- parser.lua
-- Syntax parser for multi-language text adventure games

local parser = {}

local tables = {
  N = { 'N', 'n', 'R', 'r' },
  A = { 'A' },
  V = { 'V', 'Z' },
  U = { 'U' },
}

local function match(w, p)
  if w == nil then return end
  for _, t in ipairs(tables[p]) do
    for _, u in ipairs(w) do 
      -- print(t, u)
      if u:sub(1,1) == t then return u end
    end
  end
end

-- Collect noun phrase: [adjectives...] noun
local function collect_noun_phrase(words, start_idx)
  local phrase = {}
  local i = start_idx
  -- Collect adjectives
  while i <= #words do
    local w = words[i]
    local next_w = words[i + 1]    
    -- If it's an adjective AND (not also a noun OR next word is a noun)
    if match(w, 'A') and (not match(w, 'N') or (next_w and match(next_w, 'N'))) then
      table.insert(phrase, match(w, 'A'))
      i = i + 1
    else
      break
    end
  end
  -- Collect noun (including pronouns marked with R)
  if i <= #words and (match(words[i], 'N')) then
    phrase.noun = match(words[i], 'N')
    return phrase, i + 1
  end
  
  -- No noun found - invalid phrase
  return nil, start_idx
end

-- Role handlers
local role_handlers = {
  subject = function(words, i)
    return collect_noun_phrase(words, i)
  end,
  
  object = function(words, i)
    return collect_noun_phrase(words, i)
  end,
  
  direction = function(words, i)
    return collect_noun_phrase(words, i)
  end,
  
  location = function(words, i)
    return collect_noun_phrase(words, i)
  end,
  
  instrument = function(words, i)
    return collect_noun_phrase(words, i)
  end,
  
  verb = function(words, i)
    local w = words[i]
    if w and match(w, 'U') then
      if w and match(words[i+1], 'V') then
        return {verb = match(w, 'U'), secondary = match(words[i+1], 'V')}, i + 2
      else
        return {verb = match(w, 'U')}, i + 1
      end
    else
      if w and match(w, 'V') then return {verb = match(w, 'V')}, i + 1 end
    end
    return nil, i
  end
}

-- Parse template to extract roles and their properties
local function parse_template(template)
  local roles = {}  
  for role_spec in template:gmatch("{([^}]+)}") do
    local role, optional = role_spec:match("([^?]+)(%??)")    
    table.insert(roles, { name = role, optional = optional == "?" })
  end
  return roles
end

-- Main collection function
function parser.collect(template, words)
  local roles = parse_template(template)
  local struct = {}
  local i = 1
  
  for _, role_info in ipairs(roles) do
    local role_name = role_info.name
    local handler = role_handlers[role_name]
    
    if not handler then
      return nil, "Unknown role: " .. role_name
    end
    
    local result, next_i = handler(words, i)
    
    if result then
      struct[role_name] = result
      i = next_i
    elseif not role_info.optional then
      -- Required role not found
      return nil, "Expected " .. role_name .. " at position " .. i
    end
  end
  
  -- Check for leftover words
  if i <= #words then
    return nil, "Unexpected words starting at position " .. i
  end
  
  return struct
end

-- Helper to extract actual text from tagged words
function parser.extract_text(tagged)
  if not tagged then return "" end
  return tagged:match("^[A-Z]+(.*)")
end

-- Pretty print structure for debugging
function parser.print_structure(struct)
  if not struct then
    print("(nil structure)")
    return
  end
  
  for role, data in pairs(struct) do
    if type(data) == "table" then
      if data.verb then
        print(role .. ": " .. parser.extract_text(data.verb))
      elseif data.noun then
        local parts = {}
        for _, adj in ipairs(data.adjectives) do
          table.insert(parts, parser.extract_text(adj))
        end
        table.insert(parts, parser.extract_text(data.noun))
        print(role .. ": " .. table.concat(parts, " "))
      end
    end
  end
end

-- Case mapping for Russian (and other inflected languages)
parser.case_map = {
  subject = "nominative",     -- кто? что?
  object = "accusative",      -- кого? что?
  direction = "dative",       -- кому? чему?
  location = "prepositional", -- о ком? о чём? (with preposition)
  instrument = "instrumental" -- кем? чем?
}

-- Register a custom role handler
function parser.register_role(role_name, handler_fn)
  role_handlers[role_name] = handler_fn
end

return parser