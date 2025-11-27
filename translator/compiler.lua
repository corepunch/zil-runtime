local utils = require "translator.utils"
local paradigms = require "translator.paradigms"
local compiler = {}

local adj_index = {
  nom_sg   = 1,   -- именительный ед.
  gen_sg   = 2,   -- родительный ед.
  dat_sg   = 3,   -- дательный ед.
  acc_sg   = 4,   -- винительный ед.
  ins_sg   = 5,   -- творительный ед.
  pre_sg   = 6,   -- предложный ед.
}

-- local u_endings = {
--   ["011"] = "ен",    -- I do
--   ["012"] = "ен",    -- you do (sg)
--   ["03"]  = "но",    -- he/she/it does
--   ["031"] = "ен",    -- he/she/it does
--   ["032"] = "на",    -- he/she/it does
--   ["11"]  = "ны",    -- we do
--   ["12"]  = "ны",    -- you do (pl)
--   ["13"]  = "ны",    -- they do
-- }

local function get_gender(s)
  local conf = compiler.base[utils.decode(s, true)]
  return conf and conf:byte(3)&3
end

local function find(s, n, t)
  for i = n, #s do
    if s[i]:sub(1,1) == t then return s[i] end
  end
end

local printers = {
  A = function(a, e, s, i)
    local _a = utils.extract(a)
    local d = utils.decode(_a:sub(1, #_a-2), true)
    local b = compiler.base[d]
    local code = (b:byte(2)==0x80 and b:byte(3) or b:byte(4))&~0x80
    e.gender = get_gender(find(s, i, 'N'))
    return paradigms.adjective(a, code, e)
  end,
  R = function(t, e)
    local num1, num2 = t:match("R(%d)(%d)")
    local a, b = num1 or 0, num2 or 3
    e.plural, e.person = a ~= '0', tonumber(b)
    return utils.decode(t, true)
  end,
  N = function(t, e) 
    local d = utils.decode(t, true)
    local b = compiler.base[d]
    e.gender = get_gender(t)
    e.plural = e.plural and (b:byte(3)&0x4) == 0
    return paradigms.noun(t, b:byte(4)&~0x80, e)
  end,
  Z = function(t, e)
    local d = utils.decode(t, true)
    local index = compiler.base[d]:byte(4)&~0x80
    e.form = adj_index.acc_sg
    return paradigms.verb(t, index, e)
  end,
}

printers.V = printers.Z

function compiler.compile(s)
  local e = { plural = false, gender = 1, person = 3, form = adj_index.nom_sg }
  local c = {}
  for i, w in ipairs(s) do
    local func = printers[w:sub(1,1)]
    local ok, res = pcall(func, w, e, s, i)
    table.insert(c, ok and res or utils.decode(w, true)..'*')
    if not ok then print(res) end
  end
  print("")
  print(table.concat(c, " "))
  print("")
end

-- print(
  --   table.concat({
  --     noun(s.subject.noun, table.unpack(s.subject)),
  --     verb(s.verb.verb, read_transform(s.subject.noun), s.verb.secondary),
  --     noun(s.object.noun, table.unpack(s.object))}, 
  --   " "))

return compiler