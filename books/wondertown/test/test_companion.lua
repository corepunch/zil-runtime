#!/usr/bin/env lua

local test = require 'tests.test_framework'
local runtime = require 'zilscript.runtime'

test.describe("Wondertown companion integration", function(t)
	t.it("should load companion and query initial choices", function(assert)
		local env = runtime.create_game_env()
		assert.assert_true(runtime.init(env, true))
		env.require("zilscript")
		assert.assert_true(runtime.load_modules(
			env,
			{"books.wondertown.wondertown"},
			{silent = true}
		))

		local loaded, load_error = pcall(
			env.require,
			"books.wondertown.companion"
		)
		assert.assert_true(loaded, tostring(load_error))

		local game = runtime.create_game(env, true)
		game:start()

		-- Verify starting room
		assert.assert_equal(env.HERE, env.WORKSHOP_FLOOR)

		-- Query child choices
		local child_result = env.COMPANION_QUERY("child", 3)
		assert.assert_true(child_result.ok, tostring(child_result.error))
		local child_choices = child_result.choices
		assert.assert_equal(#child_choices, 3)

		-- Count scene vs move groups
		local scene_count = 0
		local move_count = 0
		for _, choice in ipairs(child_choices) do
			if choice.group == "scene" then scene_count = scene_count + 1 end
			if choice.group == "move" then move_count = move_count + 1 end
		end
		assert.assert_equal(scene_count, 2)
		assert.assert_equal(move_count, 1)

		-- Query story choices
		local story_result = env.COMPANION_QUERY("story", 5)
		assert.assert_true(story_result.ok, tostring(story_result.error))
		local story_choices = story_result.choices
		assert.assert_true(#story_choices >= 3 and #story_choices <= 5)

		-- Verify required IDs are present in child choices
		local child_ids = {}
		for _, choice in ipairs(child_choices) do
			child_ids[choice.id] = true
		end
		-- Should have at least one workshop-floor.* choice
		local has_workshop = false
		for id, _ in pairs(child_ids) do
			if id:match("^workshop%-floor%.") then has_workshop = true end
		end
		assert.assert_true(has_workshop, "Expected workshop-floor.* choice in child set")
	end)

	t.it("should play through Act 1 golden path via companion choices", function(assert)
		local env = runtime.create_game_env()
		assert.assert_true(runtime.init(env, true))
		env.require("zilscript")
		assert.assert_true(runtime.load_modules(
			env,
			{"books.wondertown.wondertown"},
			{silent = true}
		))

		local loaded, load_error = pcall(
			env.require,
			"books.wondertown.companion"
		)
		assert.assert_true(loaded, tostring(load_error))

		local game = runtime.create_game(env, true)
		game:start()

		local function choose(id)
			local selected = env.COMPANION_SELECT(id, "casual", 5)
			assert.assert_true(selected.ok, id .. ": " .. tostring(selected.error))
			if selected.ok then game:resume(selected.command) end
		end

		-- Act 1: Workshop
		choose("workshop-floor.examine-workbench")
		choose("workshop-floor.go-toolbench")

		-- Tool bench: take key, wind Bertrand
		choose("tool-bench.take-key")
		choose("tool-bench.wind-bertrand")

		-- Climb to countertop
		choose("tool-bench.climb-countertop")

		-- Countertop: open case, take items
		choose("countertop.open-case")
		choose("countertop.take-soldier")
		choose("countertop.take-music-box")
		choose("countertop.take-button")
		choose("countertop.give-button")

		-- Return to workshop, oil ladder
		choose("countertop.go-down")
		choose("tool-bench.go-workshop")
		choose("workshop-floor.oil-ladder")

		-- Climb to loft
		choose("workshop-floor.climb-loft")
		choose("loft.open-box")
		choose("loft.take-doll-arm")
		choose("loft.wind-old-tick")

		-- Go outside
		choose("loft.go-down")
		choose("workshop-floor.go-outside")

		-- Verify we're in snowy alley
		assert.assert_equal(env.HERE, env.SNOWY_ALLEY)

		-- Continue through Act 2
		choose("alley.go-clock-square")
		choose("square.go-mailbox")
		choose("mailbox.take-scarf")
		choose("mailbox.go-square")
		choose("square.go-scrap-yard")

		-- Scrap yard: take head, give to cart
		choose("yard.take-head")
		choose("yard.give-head")

		-- Enter fox den
		choose("yard.go-fox-den")
		choose("den.give-scarf")
		choose("den.tell-tolliver")
		choose("den.take-key")

		-- Return to workshop
		choose("den.go-scrap-yard")
		choose("yard.go-square")
		choose("square.go-alley")
		choose("alley.go-workshop")

		-- Access study
		choose("workshop-floor.wind-clock")
		choose("workshop-floor.wind-clock")
		choose("workshop-floor.climb-loft")
		choose("loft.wind-old-tick")
		choose("loft.go-down")

		-- Enter study
		choose("workshop-floor.enter-study")
		assert.assert_equal(env.HERE, env.TOLLIVER_STUDY)

		-- Read diagram, go to heart
		choose("study.read-diagram")
		choose("study.go-heart")
		assert.assert_equal(env.HERE, env.WORKSHOP_HEART)

		-- Wind heart
		choose("heart.wind-heart")
		assert.assert_true(env.KEY_WOUND)

		-- Place companions
		choose("heart.place-soldier")
		choose("heart.place-music-box")

		-- Verify game won
		assert.assert_true(env.GAME_WON)
	end)

	t.it("should have consistent IDs across child and story modes", function(assert)
		local env = runtime.create_game_env()
		assert.assert_true(runtime.init(env, true))
		env.require("zilscript")
		assert.assert_true(runtime.load_modules(
			env,
			{"books.wondertown.wondertown"},
			{silent = true}
		))

		local loaded, load_error = pcall(
			env.require,
			"books.wondertown.companion"
		)
		assert.assert_true(loaded, tostring(load_error))

		local game = runtime.create_game(env, true)
		game:start()

		local child_result = env.COMPANION_QUERY("child", 3)
		local story_result = env.COMPANION_QUERY("story", 5)

		-- Every child choice should also appear in story
		local story_ids = {}
		for _, choice in ipairs(story_result.choices) do
			story_ids[choice.id] = true
		end
		for _, choice in ipairs(child_result.choices) do
			assert.assert_true(story_ids[choice.id],
				"Child choice " .. choice.id .. " not in story set")
		end
	end)
end)

local success = test.summary()
os.exit(success and 0 or 1)
