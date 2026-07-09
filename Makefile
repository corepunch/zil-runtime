# Targets
.PHONY: test test-all test-unit test-integration test-zork1 test-zork2 test-parser test-containers test-directions test-light test-pronouns test-take test-turnbit test-clock test-clock-direct test-assertions test-check-commands test-horror-helpers test-horror-partial test-horror test-horror-failures test-horror-all test-pure-zil test-simple-new test-insert-file test-let test-save test-llm help llm-new llm-look

help:
	@echo "Available targets:"
	@echo "  run-text          - Run the game in text mode"
	@echo "  llm-new           - Start a new LLM game session"
	@echo "  llm-look          - Look around in LLM mode"
	@echo ""
	@echo "Test targets:"
	@echo "  test              - Run all tests (unit + integration)"
	@echo "  test-all          - Alias for 'test'"
	@echo "  test-unit         - Run unit tests only"
	@echo "  test-integration  - Run all integration tests"
	@echo "  test-zork1        - Run Zork1 integration tests"
	@echo "  test-zork2        - Run Zork2 integration tests"
	@echo "  test-parser       - Run all parser/runtime tests"
	@echo "  test-pure-zil     - Run pure ZIL tests (using ASSERT functions)"
	@echo ""
	@echo "Individual parser/runtime tests:"
	@echo "  test-containers   - Run container interaction tests"
	@echo "  test-directions   - Run direction/movement tests"
	@echo "  test-light        - Run light source tests"
	@echo "  test-pronouns     - Run pronoun tests"
	@echo "  test-take         - Run TAKE command tests"
	@echo "  test-turnbit      - Run TURNBIT flag tests"
	@echo "  test-clock        - Run clock system tests"
	@echo "  test-clock-direct - Run clock system direct tests"
	@echo "  test-assertions   - Run assertion tests"
	@echo "  test-check-commands - Run check commands tests"
	@echo "  test-simple-new   - Run simple assertion tests"
	@echo "  test-insert-file  - Run INSERT-FILE tests"
	@echo "  test-let          - Run LET form tests"
	@echo "  test-save         - Run save/restore tests"
	@echo "  test-llm          - Run LLM persistence tests"
	@echo ""
	@echo "Horror game tests:"
	@echo "  test-horror-helpers - Run horror test helpers"
	@echo "  test-horror-partial - Run horror partial walkthrough"
	@echo "  test-horror-failures - Run horror failing conditions tests"
	@echo "  test-horror       - Run horror complete walkthrough"
	@echo "  test-horror-all   - Run all horror tests"

run-text:
	lua main.lua

# LLM mode targets
llm-new:
	@lua5.4 llm.lua --new-game --save savefile.sav

llm-look:
	@lua5.4 llm.lua --action "look" --save savefile.sav

# Test targets
test: test-unit test-integration
	@echo "All tests completed successfully!"

test-all: test
	@echo "All tests completed successfully!"

test-unit:
	@echo "Running unit tests..."
	lua tests/run_all.lua

test-integration: test-zork1 test-zork2 test-parser test-horror-all
	@echo "All integration tests completed!"

test-zork1:
	@echo "Running Zork1 integration tests..."
	@lua5.4 run-zil-test.lua infocom/zork1/test/zork1-walkthrough

test-zork2:
	@echo "Running Zork2 integration tests..."
	@lua5.4 run-zil-test.lua infocom/zork2/test/test-auto-generated

test-parser: test-containers test-directions test-light test-pronouns test-take test-turnbit test-clock test-clock-direct test-assertions test-check-commands test-simple-new test-insert-file test-let test-save
	@echo "All parser/runtime tests completed!"

test-containers:
	@echo "Running container tests..."
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-containers

test-directions:
	@echo "Running direction tests..."
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-directions

test-light:
	@echo "Running light tests..."
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-light

test-pronouns:
	@echo "Running pronoun tests..."
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-pronouns

test-take:
	@echo "Running take command tests..."
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-take

test-turnbit:
	@echo "Running TURNBIT flag tests..."
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-turnbit

test-clock:
	@echo "Running clock system tests..."
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-clock

test-clock-direct:
	@echo "Running clock system direct tests..."
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-clock-direct

test-assertions:
	@echo "Running assertion tests..."
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-assertions

test-check-commands:
	@echo "Running check commands tests..."
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-check-commands

test-simple-new:
	@echo "Running simple assertion tests..."
	@lua5.4 run-zil-test.lua zil/test-simple-new

test-insert-file:
	@echo "Running INSERT-FILE tests..."
	@lua5.4 run-zil-test.lua zil/test-insert-file

test-let:
	@echo "Running LET form tests..."
	@lua5.4 run-zil-test.lua zil/test-let

test-save:
	@echo "Running save/restore tests..."
	@lua5.4 run-zil-test.lua zil/test-save

test-llm:
	@echo "Running LLM persistence tests..."
	@lua tests/test_llm.lua

test-horror-helpers:
	@echo "Running horror test helpers..."
	@lua5.4 run-zil-test.lua books/blackwood-horror/test/test-helpers

test-horror:
	@echo "Running horror complete walkthrough tests..."
	lua5.4 run-zil-test.lua books/blackwood-horror/test/test-walkthrough

test-horror-failures:
	@echo "Running horror failing conditions tests..."
	@lua5.4 run-zil-test.lua books/blackwood-horror/test/test-failures

test-horror-all: test-horror-helpers test-horror-partial test-horror-failures test-horror
	@echo "All horror tests completed!"

test-pure-zil:
	@echo "Running pure ZIL tests..."
	@lua5.4 run-zil-test.lua zil/test-simple-new
	@lua5.4 run-zil-test.lua zil/test-insert-file
	@lua5.4 run-zil-test.lua zil/test-let
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-containers
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-directions
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-light
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-pronouns
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-take
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-turnbit
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-clock
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-clock-direct
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-assertions
	@lua5.4 run-zil-test.lua infocom/zork1/test/test-check-commands
	@lua5.4 run-zil-test.lua books/blackwood-horror/test/test-helpers
	@lua5.4 run-zil-test.lua books/blackwood-horror/test/test-failures
	@lua5.4 run-zil-test.lua infocom/zork1/test/zork1-walkthrough
	@lua5.4 run-zil-test.lua infocom/zork2/test/test-auto-generated
	@echo "All pure ZIL tests completed!"
