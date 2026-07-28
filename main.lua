local runtime = require 'zilscript.runtime'
local test_format = require 'zilscript.test_format'

local options = {
  interface = "companion",
  companion_mode = "casual",
  choice_limit = 5,
  allow_typed_commands = true,
  story_module = nil,
}

local function usage()
  io.write([[
Usage: lua5.4 main.lua [options] [story-module]

Interfaces:
  --companion       Show numbered, state-aware action cards (default)
  --text            Use the classic free-text parser interface

Companion modes:
  --child           Show 3 choices and accept numeric selections only
  --story           Show up to 5 grouped choices and allow typed commands
  --casual          Show up to 5 choices (default)
  --choices N       Override the number of choices, from 1 to 5

Other:
  --help, -h        Show this help

Examples:
  lua5.4 main.lua
  lua5.4 main.lua --child
  lua5.4 main.lua --text
  lua5.4 main.lua --companion infocom.zork1.zork1
]])
end

local i = 1
while i <= #arg do
  local value = arg[i]
  if value == "--companion" then
    options.interface = "companion"
  elseif value == "--text" then
    options.interface = "text"
  elseif value == "--child" then
    options.companion_mode = "child"
    options.choice_limit = 3
    options.allow_typed_commands = false
  elseif value == "--story" then
    options.companion_mode = "story"
    options.choice_limit = 5
    options.allow_typed_commands = true
  elseif value == "--casual" then
    options.companion_mode = "casual"
    options.choice_limit = 5
    options.allow_typed_commands = true
  elseif value == "--choices" then
    i = i + 1
    local limit = tonumber(arg[i])
    if not limit or limit < 1 or limit > 5 then
      io.stderr:write("--choices must be a number from 1 to 5\n")
      os.exit(2)
    end
    options.choice_limit = math.floor(limit)
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
      local fmt = esc .. "1;32m%s" .. esc .. "0m"
      local cap = dir:sub(1,1):upper() .. dir:sub(2)
      text = text:gsub("(%f[%a]" .. dir .. "%f[%A])", function(m) return fmt:format(m) end)
      text = text:gsub("(%f[%a]" .. cap .. "%f[%A])", function(m) return fmt:format(m) end)
    end
  end
  if type(env.DIRS) == "table" then
    for _, dir in ipairs(env.DIRS) do
      local fmt = esc .. "1;36m%s" .. esc .. "0m"
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

local function print_choices(query, allow_typed_commands)
  local displayed = {}
  local function print_group(title, group)
    local group_choices = {}
    for _, choice in ipairs(query.choices) do
      if (choice.group or "scene") == group then
        group_choices[#group_choices + 1] = choice
      end
    end
    if #group_choices == 0 then return end
    io.write("\n" .. title .. "\n")
    for _, choice in ipairs(group_choices) do
      displayed[#displayed + 1] = choice
      io.write(string.format("  %d. %s\n", #displayed, choice.label))
    end
  end

  if query.scene and query.scene.alt then
    io.write("\n" .. query.scene.alt .. "\n")
  end
  io.write("\nWhat will you do?\n")
  print_group("In this scene", "scene")
  print_group("Go somewhere", "move")
  if allow_typed_commands then
    io.write("\nChoose a number, or type any command: ")
  else
    io.write("\nChoose a number: ")
  end
  return displayed
end

if options.interface == "companion" and not companion_loaded then
  io.write("\n(No authored companion file was found; using safe automatic suggestions.)\n")
end

while game:is_running() do
  local input
  local command

  if options.interface == "companion" then
    local query = env.COMPANION_QUERY(options.companion_mode, options.choice_limit)
    if query.ok and #query.choices > 0 then
      local displayed_choices =
        print_choices(query, options.allow_typed_commands)
      input = io.read()
      if not input then break end
      local trimmed = input:match("^%s*(.-)%s*$")
      if trimmed == "" then
        io.write("\nPlease enter a number")
        if options.allow_typed_commands then io.write(" or a command") end
        io.write(".\n")
      else
        local selected_index = tonumber(trimmed)
        if selected_index and selected_index == math.floor(selected_index)
            and displayed_choices[selected_index] then
          local selected = env.COMPANION_SELECT(
            displayed_choices[selected_index].id,
            options.companion_mode,
            options.choice_limit
          )
          if selected.ok then
            command = selected.command
            io.write("\n> " .. command .. "\n\n")
          else
            io.write("\nThat choice is no longer available. Refreshing the scene.\n")
          end
        elseif selected_index then
          io.write("\nPlease choose one of the displayed numbers.\n")
        elseif not options.allow_typed_commands then
          io.write("\nChild mode accepts only one of the displayed numbers.\n")
        else
          command = trimmed
          io.write("\n")
        end
      end
    else
      if query.error then
        io.stderr:write("\nCompanion error: " .. tostring(query.error) .. "\n")
      end
      if not options.allow_typed_commands then
        io.stderr:write("\nNo selectable child-mode actions are available.\n")
        break
      else
        io.write("\n> ")
        input = io.read()
        if not input then break end
        command = input
        io.write("\n")
      end
    end
  else
    input = io.read()
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
