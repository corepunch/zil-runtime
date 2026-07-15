<INSERT-FILE "books/blackwood-horror/blackwood-horror">

<GLOBAL CO <CO-CREATE GO>>

<ROUTINE RUN-TEST ()
    ;"Observed command: GIVE RELIC TO PATIENT printed 'the relic lies on the floor'."
    ;"Observed state: ANCIENT-RELIC remained in WINNER's inventory instead of the Chapel."
    ;"Expected: the mercy ending moves the relic onto the Chapel floor."
    <SETG HERE ,CHAPEL>
    <MOVE ,WINNER ,CHAPEL>
    <MOVE ,PATIENT-189 ,CHAPEL>
    <MOVE ,ANCIENT-RELIC ,WINNER>
    <SETG GAME-WON <>>

    <ASSERT-TEXT "Something has been set right"
                 <CO-RESUME ,CO "give relic to patient">>
    <ASSERT "GIVE RELIC sets the win flag" ,GAME-WON>
    <ASSERT "GIVE RELIC removes Patient 189"
            <NOT <IN? ,PATIENT-189 ,CHAPEL>>>
    <ASSERT "The relic described as lying on the floor is in the Chapel"
            <==? <LOC ,ANCIENT-RELIC> ,CHAPEL>>
    <ASSERT "GIVE RELIC leaves the player in the post-ending Chapel"
            <==? ,HERE ,CHAPEL>>>
