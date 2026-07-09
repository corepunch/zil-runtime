"TEST-ZORK3.ZIL - Test routine for Zork III transcript"

<INSERT-FILE "infocom/zork3/globals">
<INSERT-FILE "infocom/zork3/parser">
<INSERT-FILE "infocom/zork3/verbs">
<INSERT-FILE "infocom/zork3/syntax">
<INSERT-FILE "infocom/zork3/main">

<CONSTANT RELEASEID 1>

<GLOBAL CO <CO-CREATE GO>>

<ROUTINE RUN-ZORK3-TEST ()
	<TELL "Testing Zork III transcript..." CR>
	
	;"Test 1: Start at Endless Stairs"
	<ASSERT "Start at Endless Stairs" 
		<CO-RESUME ,CO "look" T> 
		<==? ,HERE ,ENDLESS-STAIRS>>
	
	;"Test 2: Take lamp"
	<ASSERT "Take lamp" 
		<CO-RESUME ,CO "take lamp" T> 
		<==? <LOC ,LAMP> ,ADVENTURER>>
	
	;"Test 3: Go south"
	<ASSERT "Go south to Junction" 
		<CO-RESUME ,CO "south" T> 
		<==? ,HERE ,JUNCTION>>
	
	;"Test 4: Turn on lamp"
	<ASSERT "Turn on lamp" 
		<CO-RESUME ,CO "turn on lamp" T> 
		<FSET? ,LAMP ,ONBIT>>
	
	;"Test 5: Go west"
	<ASSERT "Go west" 
		<CO-RESUME ,CO "west" T> 
		T>
	
	;"Test 6: Go west again"
	<ASSERT "Go west again" 
		<CO-RESUME ,CO "west" T> 
		T>
	
	;"Test 7: Get bread"
	<ASSERT "Get bread" 
		<CO-RESUME ,CO "get bread" T> 
		<==? <LOC ,BREAD> ,ADVENTURER>>
	
	<TELL CR "Zork III transcript test completed!" CR>
>>
