#!/usr/bin/env lua
-- Unit tests for zil/runtime.lua

local test = require 'tests.test_framework'
local runtime = require 'zilscript.runtime'
local parser = require 'zilscript.parser'
local compiler = require 'zilscript.compiler'

test.describe("Runtime - Environment Creation", function(t)
	t.it("should create game environment", function(assert)
		local env = runtime.create_game_env()
		
		assert.assert_not_nil(env)
		assert.assert_type(env, "table")
	end)
	
	t.it("should include standard Lua functions", function(assert)
		local env = runtime.create_game_env()
		
		assert.assert_not_nil(env.print)
		assert.assert_not_nil(env.io)
		assert.assert_not_nil(env.table)
		assert.assert_not_nil(env.string)
		assert.assert_not_nil(env.math)
	end)
	
	t.it("should include type checking functions", function(assert)
		local env = runtime.create_game_env()
		
		assert.assert_not_nil(env.type)
		assert.assert_not_nil(env.tostring)
		assert.assert_not_nil(env.tonumber)
	end)
end)

test.describe("Runtime - Code Execution", function(t)
	t.it("should execute simple Lua code", function(assert)
		local env = runtime.create_game_env()
		local code = "x = 42"
		
		local success = runtime.execute(code, "test", env, true)
		
		assert.assert_true(success)
		assert.assert_equal(env.x, 42)
	end)
	
	t.it("should return false on syntax error", function(assert)
		local env = runtime.create_game_env()
		local code = "this is not valid lua @@#$"
		
		local success = runtime.execute(code, "test", env, true)
		
		assert.assert_false(success)
	end)
	
	t.it("should return false on runtime error", function(assert)
		local env = runtime.create_game_env()
		local code = "error('test error')"
		
		local success = runtime.execute(code, "test", env, true)
		
		assert.assert_false(success)
	end)
	
	t.it("should execute functions in environment", function(assert)
		local env = runtime.create_game_env()
		local code = [[
			function add(a, b)
				return a + b
			end
			result = add(10, 20)
		]]
		
		local success = runtime.execute(code, "test", env, true)
		
		assert.assert_true(success)
		assert.assert_equal(env.result, 30)
	end)
	
	t.it("should set _G to environment", function(assert)
		local env = runtime.create_game_env()
		local code = "_G.test_val = 123"
		
		runtime.execute(code, "test", env, true)
		
		assert.assert_equal(env.test_val, 123)
	end)
end)

test.describe("Runtime - Bootstrap Loading", function(t)
	t.it("should load bootstrap file", function(assert)
		local env = runtime.create_game_env()
		
		local success = runtime.init(env, true)
		
		assert.assert_true(success)
		-- Bootstrap should define some ZIL runtime functions
		assert.assert_type(env, "table")
	end)

	t.it("should expose control opcodes", function(assert)
		local env = runtime.create_game_env()
		runtime.init(env, true)

		assert.assert_type(env.QUIT, "function")
		assert.assert_type(env.RESTART, "function")
		assert.assert_type(env.VERIFY, "function")
	end)

	t.it("should link routine-valued properties defined later", function(assert)
		local env = runtime.create_game_env()
		assert.assert_true(runtime.init(env, true))

		local object_code = compiler.compile(parser.parse([[
			<DIRECTIONS NORTH>
			<OBJECT HOUSE
				(DESC "house")
				(ACTION HOUSE-F)
				(DESCFCN HOUSE-D)
				(NORTH PER HOUSE-EXIT)>
		]])).combined
		assert.assert_true(runtime.execute(object_code, "forward-object", env, true))
		assert.assert_nil(env.GETP(env.HOUSE, env.PQACTION))

		local routine_code = compiler.compile(parser.parse([[
			<ROUTINE HOUSE-F (VALUE) <RETURN <+ .VALUE 1>>>
			<ROUTINE HOUSE-D () <RETURN 22>>
			<ROUTINE HOUSE-EXIT () <RETURN 33>>
		]])).combined
		assert.assert_true(runtime.execute(routine_code, "forward-routines", env, true))

		local action = env.GETP(env.HOUSE, env.PQACTION)
		local desc = env.GETP(env.HOUSE, env.PQDESCFCN)
		local exit_ptr = env.GETPT(env.HOUSE, env.PQNORTH)
		assert.assert_equal(action, env.ROUTINE_NUM(env.HOUSE_F))
		assert.assert_equal(desc, env.ROUTINE_NUM(env.HOUSE_D))
		assert.assert_equal(env.APPLY(action, 41), 42)
		assert.assert_equal(env.APPLY(desc), 22)
		assert.assert_equal(env.APPLY(env.GET(exit_ptr, 0)), 33)
	end)

	t.it("should restore captured scalar state on restart", function(assert)
		local env = runtime.create_game_env()
		runtime.init(env, true)

		env.TEST_COUNTER = 1
		env.TEST_FLAG = true
		env.TEST_NAME = "start"
		env.CAPTURE_RESTART_STATE()

		env.TEST_COUNTER = 99
		env.TEST_FLAG = false
		env.TEST_NAME = "changed"
		env.TEST_NEW_COUNTER = 123

		local ok, signal = pcall(env.RESTART)
		assert.assert_false(ok)
		assert.assert_true(env.IS_ZIL_CONTROL_SIGNAL(signal, "restart"))
		assert.assert_equal(env.TEST_COUNTER, 1)
		assert.assert_equal(env.TEST_FLAG, true)
		assert.assert_equal(env.TEST_NAME, "start")
		assert.assert_nil(env.TEST_NEW_COUNTER)
	end)

	t.it("should persist string globals across save and restore", function(assert)
		local env = runtime.create_game_env()
		runtime.init(env, true)

		local filename = "test-runtime-save.tmp"
		env.TEST_STRING = "alpha"
		assert.assert_true(env.SAVE(filename))

		env.TEST_STRING = "beta"
		env.TEST_STALE = "stale"
		assert.assert_true(env.RESTORE(filename))

		assert.assert_equal(env.TEST_STRING, "alpha")
		assert.assert_nil(env.TEST_STALE)
		os.remove(filename)
	end)
end)

test.describe("Runtime - ZIL File Loading", function(t)
	t.it("should handle empty file list", function(assert)
		local env = runtime.create_game_env()
		runtime.init(env, true)
		
		local success = runtime.load_zil_files({}, env, {silent = true})
		
		assert.assert_true(success)
	end)
	
	t.it("should return false for non-existent file", function(assert)
		local env = runtime.create_game_env()
		runtime.init(env, true)
		
		local success = runtime.load_zil_files(
			{"non_existent_file.zil"},
			env,
			{silent = true}
		)
		
		assert.assert_false(success)
	end)
end)

test.describe("Runtime - Game Startup", function(t)
	t.it("should handle game creation when GO not defined", function(assert)
		local env = runtime.create_game_env()
		
		-- Don't load bootstrap, so GO() is not defined
		local game = runtime.create_game(env, true)
		
		-- Try to start - should fail because GO is not defined
		local success = pcall(function() game:start() end)
		assert.assert_false(success)
	end)
	
	t.it("should call GO function if defined", function(assert)
		local env = runtime.create_game_env()
		
		-- Define a simple GO function that yields
		env.GO = function() 
			env.game_started = true
			coroutine.yield("Game started")
		end
		
		local game = runtime.create_game(env, true)
		game:start()
		
		assert.assert_equal(env.game_started, true)
	end)

	t.it("should restart the game loop when RESTART is raised", function(assert)
		local env = runtime.create_game_env()
		runtime.init(env, true)

		local attempts = 0
		env.CAPTURE_RESTART_STATE()
		env.GO = function()
			attempts = attempts + 1
			if attempts == 1 then
				env.RESTART()
			end
			coroutine.yield("after restart")
		end

		local game = runtime.create_game(env, true)
		local response = game:start()

		assert.assert_equal(response, "after restart")
		assert.assert_equal(attempts, 2)
	end)

	t.it("should stop cleanly when QUIT is raised", function(assert)
		local env = runtime.create_game_env()
		runtime.init(env, true)
		env.GO = function()
			env.QUIT()
		end

		local game = runtime.create_game(env, true)
		local response = game:start()

		assert.assert_nil(response)
		assert.assert_false(game:is_running())
	end)
end)

test.describe("Runtime - Options Handling", function(t)
	t.it("should respect silent option in execute", function(assert)
		local env = runtime.create_game_env()
		
		-- Should not print errors when silent = true
		local success = runtime.execute("error('test')", "test", env, true)
		assert.assert_false(success)
		
		-- Silent = false would print, but we can't easily test that
	end)
	
	t.it("should handle options in load_zil_files", function(assert)
		local env = runtime.create_game_env()
		runtime.init(env, true)
		
		-- Test with silent option
		local success = runtime.load_zil_files(
			{}, 
			env, 
			{silent = true}
		)
		
		assert.assert_true(success)
	end)
end)

-- Run tests and exit with appropriate code
local success = test.summary()
os.exit(success and 0 or 1)
