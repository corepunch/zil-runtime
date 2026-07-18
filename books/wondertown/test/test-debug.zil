<INSERT-FILE "books/wondertown/wondertown">
<GLOBAL CO <CO-CREATE GO>>
<ROUTINE RUN-TEST ()
    <ASSERT "Start" <CO-RESUME ,CO "look" T> <==? ,HERE ,,WORKSHOP-FLOOR>>
    <ASSERT "Key-string exists" <==? <LOC ,KEY-STRING> ,WORKSHOP-FLOOR>>
    <ASSERT "Oil-can exists" <==? <LOC ,OIL-CAN> ,WORKBENCH>>
    <ASSERT "Can take oil can" <CO-RESUME ,CO "take oil can" T> <==? <LOC ,OIL-CAN> ,ADVENTURER>>
>
