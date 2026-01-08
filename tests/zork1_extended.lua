-- Extended tests for Zork1
-- This test file demonstrates more complex command sequences
-- Based on the commented-out tests from the original bootstrap.lua

return {
	name = "Zork1 Extended Tests",
	files = {
		"zork1/globals.zil",
		"zork1/parser.zil",
		"zork1/verbs.zil",
		"zork1/syntax.zil",
		"adventure/horror.zil",
		"zork1/main.zil",
	},
	commands = {
		-- These are the commands that were commented out in bootstrap.lua
		-- Uncomment them as the game functionality is implemented
		
		{
			input = "examine plaque",
			description = "Examine the brass plaque at the starting location"
		},
		
		-- Object interaction tests
		-- {
		-- 	input = "open mailbox",
		-- 	description = "Open the mailbox"
		-- },
		-- {
		-- 	input = "take leaflet",
		-- 	description = "Take the leaflet from the mailbox"
		-- },
		-- {
		-- 	input = "read leaflet",
		-- 	description = "Read the leaflet to get game information"
		-- },
		
		-- Navigation tests
		-- {
		-- 	input = "walk north",
		-- 	description = "Walk north from the starting location"
		-- },
		-- {
		-- 	input = "walk north",
		-- 	description = "Continue walking north"
		-- },
		-- {
		-- 	input = "walk up",
		-- 	description = "Climb up to reach higher ground"
		-- },
		-- {
		-- 	input = "examine nest",
		-- 	description = "Examine the bird's nest"
		-- },
	}
}
