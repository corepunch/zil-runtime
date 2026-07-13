#!/usr/bin/env lua5.4

local test = require 'tests.test_framework'

local function shell_quote(value)
	return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function run_command(command)
	local pipe = assert(io.popen("zsh -lc " .. shell_quote(command) .. " 2>&1", "r"))
	local output = pipe:read("*a")
	local ok, _, code = pipe:close()
	return ok == true and 0 or code or 1, output
end

local function cleanup(savefile)
	os.remove(savefile)
	os.remove(savefile .. ".actions")
end

test.describe("Limehouse Killings walkthrough", function(t)
	t.it("should complete the documented golden path across LLM processes", function(assert)
		local savefile = "/tmp/test-limehouse-golden-path.sav"
		cleanup(savefile)
		local suffix = " --save " .. shell_quote(savefile) .. " --game limehouse-killings"
		local code = run_command("lua5.4 llm.lua --new-game" .. suffix)
		assert.assert_equal(code, 0)

		local actions = {
			"go north", "go east", "examine reading-desk", "take torn-page", "read torn-page",
			"examine colored-markers", "push red book", "push blue book", "push green book",
			"push yellow book", "go south", "go east", "examine desk", "take dead-letter",
			"read dead-letter", "take poison-bottle", "examine poison-bottle", "go north", "go west",
			"examine table", "take wax-seal", "go north", "examine shelves", "take foxglove",
			"take charcoal", "go south", "go east", "go down", "examine drawer", "open drawer",
			"take lockpick-set", "go west", "examine hedges", "take blood-stained-knife",
			"take footprint-cast", "go north", "examine plants", "examine labels", "go south",
			"go south", "examine trunk", "ask hudson about master", "ask hudson about alibi",
			"ask hudson about key", "take keyring", "ask hudson about moriarty", "go north", "go east",
			"go up", "go west", "ask lady about marriage", "ask lady about alibi", "go east", "go east",
			"ask moriarty about experiments", "ask moriarty about poison", "take secret-ledger",
			"read secret-ledger", "go west", "go south", "examine locked-box", "open locked-box",
			"take bank-statement", "read bank-statement", "go north", "ask inspector about case",
		}

		for _, action in ipairs(actions) do
			local action_code, output = run_command(
				"lua5.4 llm.lua --action " .. shell_quote(action) .. suffix)
			assert.assert_equal(action_code, 0, "Command failed: " .. action)
			assert.assert_false(output:find("used the word", 1, true) ~= nil, "Parser rejected: " .. action)
			assert.assert_false(output:find("can't see", 1, true) ~= nil, "Object missing: " .. action)
			assert.assert_false(output:find("can't go", 1, true) ~= nil, "Route failed: " .. action)
		end

		local score_code, score = run_command("lua5.4 llm.lua --action score" .. suffix)
		assert.assert_equal(score_code, 0)
		assert.assert_match(score, "Evidence found: 5 of 5")
		assert.assert_match(score, "Suspects interviewed: 3 of 3")

		local accuse_code, ending = run_command(
			"lua5.4 llm.lua --action " .. shell_quote("accuse dr-moriarty") .. suffix)
		assert.assert_equal(accuse_code, 0)
		assert.assert_match(ending, "Congratulations! You have solved the murder")

		cleanup(savefile)
	end)
end)

local success = test.summary()
os.exit(success and 0 or 1)
