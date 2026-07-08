<INSERT-FILE "zork1/globals">
<INSERT-FILE "zork1/clock">
<INSERT-FILE "adventure/dungeon">
<INSERT-FILE "adventure/actions">
<INSERT-FILE "zork1/parser">
<INSERT-FILE "zork1/verbs">
<INSERT-FILE "zork1/syntax">
<INSERT-FILE "zork1/main">

<CONSTANT RELEASEID 1>

<GLOBAL CO <CO-CREATE GO>>

<ROUTINE RUN-TEST ()
    <TELL "Testing test helpers..." CR CR>
    
    ;"Start at Sanitarium Gate"
    <ASSERT "Start at Sanitarium Gate" <CO-RESUME ,CO "look" T> <==? ,HERE ,SANITARIUM-GATE>>
    
    ;"Learn about Blackwood Sanitarium"
    <CO-RESUME ,CO "examine plaque">
    
    ;"Take the brass plaque"
    <ASSERT "Take the brass plaque" <CO-RESUME ,CO "take plaque" T> <==? <LOC ,BRASS-PLAQUE> ,ADVENTURER>>
    
    ;"Enter Sanitarium Entrance Hall"
    <ASSERT "Enter Sanitarium Entrance Hall" <CO-RESUME ,CO "north" T> <==? ,HERE ,SANITARIUM-ENTRANCE>>
    
    <TELL CR "All test helper tests completed!" CR>>
