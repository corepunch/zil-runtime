#!/usr/bin/env lua
-- LLM Play Mode
-- Allows LLMs to interact with the game programmatically
--
-- Usage:
--   lua llm.lua --action "look" [--save savefile.sav] [--game zork1]
--   lua llm.lua --action "take sword" --save game.sav
--   lua llm.lua --new-game --save game.sav  (start new game and save initial state)
--
-- Output: JSON with game response and state info

local runtime = require 'zilscript.runtime'

-- Parse command line arguments
local args = {}
local i = 1
while i <= #arg do
    local a = arg[i]
    if a == "--action" or a == "-a" then
        i = i + 1
        args.action = arg[i]
    elseif a == "--save" or a == "-s" then
        i = i + 1
        args.savefile = arg[i]
    elseif a == "--game" or a == "-g" then
        i = i + 1
        args.game = arg[i]
    elseif a == "--new-game" then
        args.new_game = true
    elseif a == "--help" or a == "-h" then
        args.help = true
    end
    i = i + 1
end

if args.help then
    io.write([[
LLM Play Mode - Interact with ZIL games programmatically

Usage:
  lua llm.lua --action "command" [options]
  lua llm.lua --new-game [options]

Options:
  --action, -a "cmd"   Execute this command and exit
  --save, -s file      Save/restore game state from this file
  --game, -g name      Game to play (default: zork1)
  --new-game           Start a new game (even if save file exists)
  --help, -h           Show this help

Output: JSON with fields:
  - ok: boolean (success)
  - output: string (game response text)
  - room: string (current room name, if available)
  - savefile: string (path to saved state)
  - error: string (error message, if failed)

Examples:
  lua llm.lua --new-game --save zork1.sav
  lua llm.lua --action "look" --save zork1.sav
  lua llm.lua --action "take lamp" --save zork1.sav
  lua llm.lua --action "go north" --save zork1.sav
]])
    os.exit(0)
end

-- Game configurations
local GAMES = {
    zork1 = {
        modules = {
            "infocom.zork1.globals",
            "infocom.zork1.clock",
            "infocom.zork1.parser",
            "infocom.zork1.verbs",
            "infocom.zork1.actions",
            "infocom.zork1.syntax",
            "infocom.zork1.dungeon",
            "infocom.zork1.main",
        }
    }
}

local game_name = args.game or "zork1"
local game_config = GAMES[game_name]
if not game_config then
    io.write(string.format('{"ok":false,"error":"Unknown game: %s. Available: %s"}\n',
        game_name, table.concat(table.keys(GAMES or {}), ", ")))
    os.exit(1)
end

-- Capture output function
local captured_output = {}
local function capture_print(...)
    local parts = {}
    for i = 1, select("#", ...) do
        parts[i] = tostring(select(i, ...))
    end
    table.insert(captured_output, table.concat(parts, "\t"))
end

local function capture_io_write(...)
    for i = 1, select("#", ...) do
        local s = tostring(select(i, ...))
        table.insert(captured_output, s)
    end
end

local function flush_capture()
    local result = table.concat(captured_output)
    captured_output = {}
    return result
end

-- Override io_write and io_flush in the game environment
-- to capture output instead of printing to terminal
local function setup_capture(env)
    -- Store original functions
    local original_io_write = _G.io_write
    local original_io_flush = _G.io_flush
    
    -- Override globally for the game environment
    _G.io_write = function(...)
        capture_io_write(...)
    end
    
    _G.io_flush = function()
        return flush_capture()
    end
    
    return function()
        -- Restore function
        _G.io_write = original_io_write
        _G.io_flush = original_io_flush
    end
end

-- Create game environment
local env = runtime.create_game_env()

-- Load bootstrap
if not runtime.init(env) then
    io.write('{"ok":false,"error":"Failed to initialize ZIL runtime"}\n')
    os.exit(1)
end

-- Install ZIL support
env.require('zilscript')

-- Load game modules
if not runtime.load_modules(env, game_config.modules, {silent = true}) then
    io.write('{"ok":false,"error":"Failed to load game modules"}\n')
    os.exit(1)
end

-- Create game coroutine
local game = runtime.create_game(env, true)

-- Helper to escape strings for JSON
local function json_escape(s)
    if not s then return "null" end
    s = s:gsub('\\', '\\\\')
    s = s:gsub('"', '\\"')
    s = s:gsub('\n', '\\n')
    s = s:gsub('\r', '\\r')
    s = s:gsub('\t', '\\t')
    -- Remove ANSI escape codes
    s = s:gsub('\27%[[0-9;]*m', '')
    return '"' .. s .. '"'
end

-- Helper to get current room name
local function get_room_name(env)
    local ok, result = pcall(function()
        local here = rawget(_G, "HERE") or rawget(env, "HERE")
        if here and type(here) == "number" then
            -- Try to get the DESC property
            local pqdesc = rawget(_G, "PQDESC") or rawget(env, "PQDESC")
            if pqdesc then
                local desc = env.GETP and env.GETP(here, pqdesc)
                if desc and type(desc) == "number" then
                    return env.mem and env.mem:string(desc)
                end
            end
        end
        return nil
    end)
    return ok and result or nil
end

-- Main logic
local restore = setup_capture(env)

-- Try to restore from savefile if it exists and we're not starting a new game
local savefile = args.savefile or "savefile.sav"
local restored = false

if not args.new_game then
    local file = io.open(savefile, "rb")
    if file then
        file:close()
        -- Restore game state
        local ok, err = pcall(function()
            env.RESTORE(savefile)
        end)
        if ok then
            restored = true
            _G._LLM_RESTORED = true  -- Tell GO() to skip initialization
        end
    end
end

-- Helper to execute an action and get output
local function execute_action(action)
    -- For restored games, we need two resumes:
    -- 1. First resume(nil) to start MAIN_LOOP and reach READ()
    -- 2. Second resume(action) to pass the action
    if restored then
        -- Start MAIN_LOOP (will yield at READ with empty output)
        local ok, result = pcall(function()
            return game:resume(nil)
        end)
        if not ok then
            error("Failed to start MAIN_LOOP: " .. tostring(result))
        end
        restored = false  -- Only need to do this once
    end
    
    -- Execute the action
    local ok, result = pcall(function()
        return game:resume(action)
    end)
    
    if not ok then
        error(tostring(result))
    end
    
    -- Get the output
    local output = ""
    if type(result) == "string" then
        output = result
    elseif type(result) == "table" and result.status then
        -- Test result format
        output = string.format("[%s] %s", result.status, result.message or "")
    end
    
    return output
end

-- If we have an action, execute it
if args.action then
    local ok, output = pcall(execute_action, args.action)
    
    if not ok then
        restore()
        local error_msg = tostring(output)
        -- Clean up error message
        error_msg = error_msg:gsub('\27%[[0-9;]*m', '')
        io.write(string.format('{"ok":false,"error":%s}\n', json_escape(error_msg)))
        os.exit(1)
    end
    
    -- Get room name
    local room = get_room_name(env)
    
    -- Save game state
    local save_ok = false
    local save_err = nil
    local ok, err = pcall(function()
        env.SAVE(savefile)
        save_ok = true
    end)
    if not ok then
        save_err = tostring(err)
    end
    
    restore()
    
    -- Output JSON
    local response = {
        ok = true,
        output = output,
        room = room,
        savefile = savefile,
        restored = restored,
    }
    if save_err then
        response.save_error = save_err
    end
    
    -- Simple JSON serialization
    io.write("{")
    io.write('"ok":' .. tostring(response.ok) .. ',')
    io.write('"output":' .. json_escape(response.output) .. ',')
    io.write('"room":' .. json_escape(response.room) .. ',')
    io.write('"savefile":' .. json_escape(response.savefile) .. ',')
    io.write('"restored":' .. tostring(response.restored))
    if response.save_error then
        io.write(',"save_error":' .. json_escape(response.save_error))
    end
    io.write("}\n")
    
elseif args.new_game then
    -- Start a new game and get initial output
    local ok, result = pcall(function()
        return game:resume(nil)
    end)
    
    if not ok then
        restore()
        local error_msg = tostring(result)
        error_msg = error_msg:gsub('\27%[[0-9;]*m', '')
        io.write(string.format('{"ok":false,"error":%s}\n', json_escape(error_msg)))
        os.exit(1)
    end
    
    local output = ""
    if type(result) == "string" then
        output = result
    end
    
    local room = get_room_name(env)
    
    -- Save initial state
    _G._LLM_RESTORED = false
    local save_ok = false
    local save_err = nil
    local ok, err = pcall(function()
        env.SAVE(savefile)
        save_ok = true
    end)
    if not ok then
        save_err = tostring(err)
    end
    
    restore()
    
    io.write("{")
    io.write('"ok":true,')
    io.write('"output":' .. json_escape(output) .. ',')
    io.write('"room":' .. json_escape(room) .. ',')
    io.write('"savefile":' .. json_escape(savefile) .. ',')
    io.write('"new_game":true')
    if save_err then
        io.write(',"save_error":' .. json_escape(save_err))
    end
    io.write("}\n")
    
else
    restore()
    io.write('{"ok":false,"error":"No action specified. Use --action or --new-game"}\n')
    os.exit(1)
end
