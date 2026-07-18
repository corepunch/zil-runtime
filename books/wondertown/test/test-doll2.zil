<INSERT-FILE "books/wondertown/wondertown">
<GLOBAL CO <CO-CREATE GO>>
<ROUTINE RUN-TEST ()
    <CO-RESUME ,CO "look" T>
    <CO-RESUME ,CO "walk east" T>
    <CO-RESUME ,CO "take key" T>
    <ASSERT "Wind nutcracker" <CO-RESUME ,CO "wind nutcracker"> ,BERTRAND-WOUND>
    <ASSERT "Climb to countertop" <CO-RESUME ,CO "walk up" T> <==? ,HERE ,COUNTERTOP>>
    <ASSERT "Doll is in countertop" <IN? ,MARZIPAN ,COUNTERTOP>>
    ; try examining using ragdoll
    <ASSERT-TEXT "stitched" <CO-RESUME ,CO "examine ragdoll">>
>
