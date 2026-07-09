#!/usr/bin/env lua

local test = require 'tests.test_framework'
local runtime = require 'zilscript.runtime'

local function run_command(command)
	local quoted = "'" .. command:gsub("'", "'\\''") .. "'"
	local pipe = assert(io.popen("zsh -lc " .. quoted .. " 2>&1", "r"))
	local output = pipe:read("*a")
	local ok, why, code = pipe:close()
	local exit_code
	if type(ok) == "number" then
		exit_code = ok
	elseif ok == true then
		exit_code = 0
	else
		exit_code = code or 1
	end
	return exit_code, output
end

local function extract_json_line(output)
	local json_line = nil
	for line in output:gmatch("[^\r\n]+") do
		if line:match("^%b{}$") then
			json_line = line
		end
	end
	return json_line
end

local function json_string_field(json, key)
	return json:match('"' .. key .. '":"(.-)"')
end

local function json_bool_field(json, key)
	return json:match('"' .. key .. '":([%a]+)')
end

local function read_file(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()
	return content
end

local function remove_file(path)
	os.remove(path)
end

local function cleanup(savefile)
	remove_file(savefile)
	remove_file(savefile .. ".actions")
end

local function shell_quote(value)
	return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function boot_zork1_env()
	local env = runtime.create_game_env()
	assert(runtime.init(env, true))
	env.require('zilscript')
	assert(runtime.load_modules(env, {
		'infocom.zork1.globals',
		'infocom.zork1.clock',
		'infocom.zork1.parser',
		'infocom.zork1.verbs',
		'infocom.zork1.actions',
		'infocom.zork1.syntax',
		'infocom.zork1.dungeon',
		'infocom.zork1.main',
	}, {silent = true}))
	return env
end

test.describe("LLM Mode", function(t)
	t.it("should create an empty history file on new game", function(assert)
		local savefile = "/tmp/test-llm-new.sav"
		cleanup(savefile)

		local exit_code, output = run_command("lua5.4 llm.lua --new-game --save " .. shell_quote(savefile))
		local json = extract_json_line(output)

		assert.assert_equal(exit_code, 0)
		assert.assert_not_nil(json)
		if not json then
			cleanup(savefile)
			return
		end
		assert.assert_equal(json_string_field(json, "savefile"), savefile)
		assert.assert_equal(json_string_field(json, "historyfile"), savefile .. ".actions")
		assert.assert_equal(json_bool_field(json, "new_game"), "true")
		assert.assert_equal(read_file(savefile .. ".actions"), "")

		cleanup(savefile)
	end)

	t.it("should append structured action history entries", function(assert)
		local savefile = "/tmp/test-llm-history.sav"
		cleanup(savefile)
		run_command("lua5.4 llm.lua --new-game --save " .. shell_quote(savefile))

		local exit_code, output = run_command("lua5.4 llm.lua --action \"open mailbox\" --save " .. shell_quote(savefile))
		local json = extract_json_line(output)
		local history = read_file(savefile .. ".actions") or ""

		assert.assert_equal(exit_code, 0)
		assert.assert_not_nil(json)
		if not json then
			cleanup(savefile)
			return
		end
		assert.assert_equal(json_string_field(json, "historyfile"), savefile .. ".actions")
		assert.assert_match(history, '"game":"zork1"')
		assert.assert_match(history, '"action":"open mailbox"')

		cleanup(savefile)
	end)

	t.it("should replay structured history when snapshot is missing", function(assert)
		local savefile = "/tmp/test-llm-replay.sav"
		cleanup(savefile)
		local exit_code, output = run_command(
			"rm -f " .. shell_quote(savefile) .. " " .. shell_quote(savefile .. ".actions") ..
			" && lua5.4 llm.lua --new-game --save " .. shell_quote(savefile) ..
			" && lua5.4 llm.lua --action \"open mailbox\" --save " .. shell_quote(savefile) ..
			" && rm -f " .. shell_quote(savefile) ..
			" && lua5.4 llm.lua --action \"take leaflet\" --save " .. shell_quote(savefile)
		)
		local json = extract_json_line(output)

		assert.assert_equal(exit_code, 0)
		assert.assert_not_nil(json)
		if not json then
			cleanup(savefile)
			return
		end
		assert.assert_equal(json_string_field(json, "historyfile"), savefile .. ".actions")
		assert.assert_match(json_string_field(json, "output") or "", "Taken")

		cleanup(savefile)
	end)

	t.it("should resume across processes using the memory dump when snapshot exists", function(assert)
		local savefile = "/tmp/test-llm-cross-process.sav"
		cleanup(savefile)

		local env1 = boot_zork1_env()
		local game1 = runtime.create_game(env1, true)
		game1:start()
		local open_output = game1:resume("open mailbox")
		assert.assert_match(open_output, "leaflet")
		assert.assert_true(env1.SAVE(savefile))

		local env2 = boot_zork1_env()
		assert.assert_true(env2.RESTORE(savefile))
		_G._LLM_RESTORED = true
		local game2 = runtime.create_game(env2, true)
		game2:start()
		local take_output = game2:resume("take leaflet")
		_G._LLM_RESTORED = nil

		assert.assert_match(take_output, "Taken")
		cleanup(savefile)
	end)

	t.it("should resume across processes from the initial memory dump without history", function(assert)
		local savefile = "/tmp/test-llm-dump-only.sav"
		cleanup(savefile)

		local env1 = boot_zork1_env()
		local game1 = runtime.create_game(env1, true)
		game1:start()
		assert.assert_true(env1.SAVE(savefile))

		local env2 = boot_zork1_env()
		assert.assert_true(env2.RESTORE(savefile))
		_G._LLM_RESTORED = true
		local game2 = runtime.create_game(env2, true)
		game2:start()
		local open_output = game2:resume("open mailbox")
		assert.assert_match(open_output, "leaflet")
		assert.assert_true(env2.SAVE(savefile))

		local env3 = boot_zork1_env()
		assert.assert_true(env3.RESTORE(savefile))
		_G._LLM_RESTORED = true
		local game3 = runtime.create_game(env3, true)
		game3:start()
		local take_output = game3:resume("take leaflet")
		_G._LLM_RESTORED = nil

		assert.assert_match(take_output, "Taken")
		cleanup(savefile)
	end)

	t.it("should replay legacy raw-line history", function(assert)
		local savefile = "/tmp/test-llm-legacy.sav"
		cleanup(savefile)
		local file = _G.assert(io.open(savefile .. ".actions", "w"))
		file:write("open mailbox\n")
		file:close()

		local exit_code, output = run_command("lua5.4 llm.lua --action \"take leaflet\" --save " .. shell_quote(savefile))
		local json = extract_json_line(output)

		assert.assert_equal(exit_code, 0)
		assert.assert_not_nil(json)
		if not json then
			cleanup(savefile)
			return
		end
		assert.assert_match(json_string_field(json, "output") or "", "Taken")

		cleanup(savefile)
	end)

	t.it("should reject history from a different game", function(assert)
		local savefile = "/tmp/test-llm-mismatch.sav"
		cleanup(savefile)
		local file = _G.assert(io.open(savefile .. ".actions", "w"))
		file:write('{"time":1,"game":"other-game","action":"look"}\n')
		file:close()

		local exit_code, output = run_command("lua5.4 llm.lua --action \"look\" --save " .. shell_quote(savefile))
		local json = extract_json_line(output)

		assert.assert_not_equal(exit_code, 0)
		assert.assert_not_nil(json)
		if not json then
			cleanup(savefile)
			return
		end
		assert.assert_equal(json_bool_field(json, "ok"), "false")
		assert.assert_match(json_string_field(json, "error") or "", "History file belongs to game")

		cleanup(savefile)
	end)
end)

local success = test.summary()
os.exit(success and 0 or 1)
