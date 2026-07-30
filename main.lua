local runtime = require 'zilscript.runtime'
local test_format = require 'zilscript.test_format'

local options = {
  interface = "companion",
  story_module = nil,
}

local function usage()
  io.write([[
Usage: lua5.4 main.lua [options] [story-module]

Interfaces:
  --companion       Show all state-aware choices (default)
  --text            Use the classic free-text parser interface

Other:
  --help, -h        Show this help

Examples:
  lua5.4 main.lua
  lua5.4 main.lua --companion
  lua5.4 main.lua --text
  lua5.4 main.lua --companion infocom.zork1.zork1
]])
end

local i = 1
while i <= #arg do
  local value = arg[i]
  if value == "--text" then
    options.interface = "text"
  elseif value == "--companion" then
    options.interface = "companion"
  elseif value == "--help" or value == "-h" then
    usage()
    os.exit(0)
  elseif value:sub(1, 1) == "-" then
    io.stderr:write("Unknown option: " .. value .. "\n")
    usage()
    os.exit(2)
  elseif not options.story_module then
    options.story_module = value
  else
    io.stderr:write("Unexpected argument: " .. value .. "\n")
    usage()
    os.exit(2)
  end
  i = i + 1
end

local story_module = options.story_module or "infocom.zork1.zork1"

-- Create game environment
local env = runtime.create_game_env()

-- Load bootstrap
if not runtime.init(env) then
	os.exit(1)
end

-- Install ZIL support and load modules
env.require('zilscript')
if not runtime.load_modules(env, { story_module }, {save_lua = true}) then
	os.exit(1)
end

local story_prefix = story_module:match("^(.*)%.")
local companion_module = (story_prefix or story_module) .. ".companion"
local companion_loaded = false
if options.interface == "companion" then
  local ok, result = pcall(env.require, companion_module)
  if ok then
    companion_loaded = result ~= nil
  elseif not tostring(result):match("not found in environment") then
    io.stderr:write("Failed to load companion module " .. companion_module
      .. ": " .. tostring(result) .. "\n")
    os.exit(1)
  end
  -- load_modules captured restart state before the optional companion was
  -- loaded. Capture it again so companion globals reset with the adventure.
  if type(env.CAPTURE_RESTART_STATE) == "function" then
    env.CAPTURE_RESTART_STATE()
  end
end

local esc = "\27["

local function highlight(text)
  if type(env.DESCS) == "table" then
    for _, dir in ipairs(env.DESCS) do
      local fmt = esc .. "1m%s" .. esc .. "0m"
      local cap = dir:sub(1,1):upper() .. dir:sub(2)
      text = text:gsub("(%f[%a]" .. dir .. "%f[%A])", function(m) return fmt:format(m) end)
      text = text:gsub("(%f[%a]" .. cap .. "%f[%A])", function(m) return fmt:format(m) end)
    end
  end
  if type(env.DIRS) == "table" then
    for _, dir in ipairs(env.DIRS) do
      local fmt = esc .. "1m%s" .. esc .. "0m"
      local cap = dir:sub(1,1):upper() .. dir:sub(2)
      text = text:gsub("(%f[%a]" .. dir .. "%f[%A])", function(m) return fmt:format(m) end)
      text = text:gsub("(%f[%a]" .. cap .. "%f[%A])", function(m) return fmt:format(m) end)
    end
  end
  return text
end

-- Create env as a coroutine
local game = runtime.create_game(env)
-- Start the game and get initial output
local res = game:start()
if type(res) == "string" then io.write(highlight(res)) end

local function write_response(response)
  if type(response) == "table" and response.status then
    io.write(test_format.format_test_result(response) .. "\n")
  elseif type(response) == "string" then
    io.write(highlight(response))
  end
end

local function raw_terminal()
  os.execute("stty -icanon -echo min 0 time 1 2>/dev/null")
end

local function cooked_terminal()
  os.execute("stty icanon echo 2>/dev/null")
end

local function term_width()
  local f = io.popen("tput cols 2>/dev/null || echo 80")
  local w = f and f:read("*n") or 80
  if f then f:close() end
  return w or 80
end

local function companion_selector(query)
  local choices = query.choices
  local selected = 0
  local typed = ""
  local dirty = true
  local width = term_width()
  local saved_lines = 0

  local function draw()
    if not dirty then return end
    dirty = false
    if saved_lines > 0 then
      -- Cursor-up preserves the column, so return to column zero before
      -- clearing each rendered row. The prompt is the current row and must
      -- not be included in the number of rows to move up.
      io.write(string.rep("\27[A\r\27[2K", saved_lines))
    end
    local lines = 0
    for i, choice in ipairs(choices) do
      local line = (i == selected and "> " or "  ") .. choice.label .. " (" .. choice.command .. ")"
      io.write(line .. "\n")
      lines = lines + math.ceil(#line / width)
    end
    io.write("\n")
    io.write("\27[2K> ")
    io.write(selected > 0 and choices[selected].command or typed)
    saved_lines = lines + 1
    io.flush()
  end

  raw_terminal()
  draw()

  while true do
    local ch = io.stdin:read(1)
    if ch then
      if ch == "\27" then
        local a = io.stdin:read(1)
        if a == "[" then
          local b = io.stdin:read(1)
          if b == "A" then
            selected = selected > 1 and selected - 1 or #choices
            typed = ""
            dirty = true
          elseif b == "B" then
            selected = selected < #choices and selected + 1 or 1
            typed = ""
            dirty = true
          end
        else
          selected = 0
          typed = ""
          dirty = true
        end
      elseif ch == "\r" or ch == "\n" then
        cooked_terminal()
        io.write("\n\n")
        if selected > 0 then
          return {kind = "choice", id = choices[selected].id, command = choices[selected].command}
        elseif #typed > 0 then
          return {kind = "typed", command = typed}
        end
      elseif ch == "\127" or ch == "\8" then
        if #typed > 0 then
          typed = typed:sub(1, -2)
          selected = 0
          dirty = true
        end
      elseif ch == "\3" then
        cooked_terminal()
        io.write("\n")
        os.exit(0)
      elseif ch:match("^[%w%p%s]$") then
        typed = typed .. ch
        selected = 0
        dirty = true
      end
      draw()
    end
  end
end

while game:is_running() do
  local command

  if options.interface == "companion" then
    local query = env.COMPANION_QUERY()
    if query.ok and #query.choices > 0 then
      local result = companion_selector(query)
      if result.kind == "choice" then
        local selected = env.COMPANION_SELECT(result.id)
        if selected.ok then
          command = selected.command
        end
      elseif result.kind == "typed" then
        command = result.command
      end
    else
      if query.error then
        io.stderr:write("\nCompanion error: " .. tostring(query.error) .. "\n")
      end
      io.write("\n> ")
      local input = io.read()
      if not input then break end
      command = input
      io.write("\n")
    end
  else
    local input = io.read()
    if not input then break end
    command = input
    io.write("\n")
  end

  if command then
    res = game:resume(command)
    write_response(res)
  end
end

-- local ast = parser.parse_file "infocom/zork1/actions.zil"
-- local res = compiler.compile(ast)

-- print(parser.view(ast, 0))
-- print(res.body)
