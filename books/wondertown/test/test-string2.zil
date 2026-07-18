<INSERT-FILE "books/wondertown/wondertown">
<GLOBAL CO <CO-CREATE GO>>
<ROUTINE RUN-TEST ()
    <ASSERT-EQUAL "take string output" <CO-RESUME ,CO "take string" T> "Taken.">
>
