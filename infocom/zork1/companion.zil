;"State-aware intent cards for Zork I.

  This file is intentionally separate from the imported adventure source.
  Labels describe narrative intentions; commands are ordinary Zork parser input.
  The runtime evaluates SUGGEST-ACTIONS only while the game is waiting at READ."

<ROUTINE SUGGEST-ACTIONS ()
  <COND
    (<EQUAL? ,HERE ,WEST-OF-HOUSE>
     <SUGGEST-WEST-OF-HOUSE>)
    (<EQUAL? ,HERE ,NORTH-OF-HOUSE>
     <SUGGEST-NORTH-OF-HOUSE>)
    (<EQUAL? ,HERE ,SOUTH-OF-HOUSE>
     <SUGGEST-SOUTH-OF-HOUSE>)
    (<EQUAL? ,HERE ,EAST-OF-HOUSE>
     <SUGGEST-EAST-OF-HOUSE>)
    (<EQUAL? ,HERE ,KITCHEN>
     <SUGGEST-KITCHEN>)
    (<EQUAL? ,HERE ,LIVING-ROOM>
     <SUGGEST-LIVING-ROOM>)
    (<EQUAL? ,HERE ,ATTIC>
     <SUGGEST-ATTIC>)>>

<ROUTINE SUGGEST-WEST-OF-HOUSE ()
  <COND
    (<NOT <FSET? ,MAILBOX ,OPENBIT>>
     <CHOICE "west-house.open-mailbox"
             "Open the little mailbox"
             "open mailbox"
             ,CHOICE-INVESTIGATE
             100>)
    (<IN? ,ADVERTISEMENT ,MAILBOX>
     <CHOICE "west-house.take-leaflet"
             "Take the leaflet from the mailbox"
             "take leaflet"
             ,CHOICE-INVESTIGATE
             100>)
    (<IN? ,ADVERTISEMENT ,WINNER>
     <CHOICE "west-house.read-leaflet"
             "Read the leaflet"
             "read leaflet"
             ,CHOICE-INVESTIGATE
             85>)>

  <CHOICE "west-house.try-front-door"
          "Try the boarded front door"
          "open front door"
          ,CHOICE-INVESTIGATE
          75>
  <CHOICE-DETAILS "once" T>

  <CHOICE "west-house.go-north"
          "Walk around the north side of the house"
          "north"
          ,CHOICE-PROGRESS
          90>

  <CHOICE "west-house.go-south"
          "Walk around the south side of the house"
          "south"
          ,CHOICE-RETURN
          65>

  <CHOICE "west-house.enter-forest"
          "Follow the field west into the forest"
          "west"
          ,CHOICE-EXPERIMENT
          45>>

<ROUTINE SUGGEST-NORTH-OF-HOUSE ()
  <CHOICE "north-house.go-behind"
          "Walk around to the back of the house"
          "east"
          ,CHOICE-PROGRESS
          100>

  <CHOICE "north-house.examine-window"
          "Examine the boarded windows"
          "examine boarded window"
          ,CHOICE-INVESTIGATE
          75>
  <CHOICE-DETAILS "once" T>

  <CHOICE "north-house.follow-path"
          "Follow the narrow path into the trees"
          "north"
          ,CHOICE-EXPERIMENT
          60>

  <CHOICE "north-house.return-front"
          "Return to the front of the house"
          "west"
          ,CHOICE-RETURN
          55>>

<ROUTINE SUGGEST-SOUTH-OF-HOUSE ()
  <CHOICE "south-house.go-behind"
          "Walk around to the back of the house"
          "east"
          ,CHOICE-PROGRESS
          100>

  <CHOICE "south-house.examine-window"
          "Examine the boarded windows"
          "examine boarded window"
          ,CHOICE-INVESTIGATE
          75>
  <CHOICE-DETAILS "once" T>

  <CHOICE "south-house.enter-forest"
          "Follow the trees south into the forest"
          "south"
          ,CHOICE-EXPERIMENT
          60>

  <CHOICE "south-house.return-front"
          "Return to the front of the house"
          "west"
          ,CHOICE-RETURN
          55>>

<ROUTINE SUGGEST-EAST-OF-HOUSE ()
  <COND
    (<FSET? ,KITCHEN-WINDOW ,OPENBIT>
     <CHOICE "east-house.enter-window"
             "Climb through the open kitchen window"
             "enter window"
             ,CHOICE-PROGRESS
             115>)
    (T
     <CHOICE "east-house.open-window"
             "Open the slightly ajar kitchen window"
             "open kitchen window"
             ,CHOICE-PROGRESS
             110>)>

  <CHOICE "east-house.examine-window"
          "Look through the small kitchen window"
          "examine kitchen window"
          ,CHOICE-INVESTIGATE
          80>

  <CHOICE "east-house.enter-clearing"
          "Follow the path into the forest clearing"
          "east"
          ,CHOICE-EXPERIMENT
          55>

  <CHOICE "east-house.go-north"
          "Walk around the north side of the house"
          "north"
          ,CHOICE-RETURN
          50>

  <CHOICE "east-house.go-south"
          "Walk around the south side of the house"
          "south"
          ,CHOICE-RETURN
          45>>

<ROUTINE SUGGEST-KITCHEN ()
  <CHOICE "kitchen.enter-living-room"
          "Go into the living room"
          "west"
          ,CHOICE-PROGRESS
          105>

  <CHOICE "kitchen.climb-stairs"
          "Climb the dark stairs to the attic"
          "up"
          ,CHOICE-EXPERIMENT
          65>

  <COND
    (<IN? ,SANDWICH-BAG ,KITCHEN-TABLE>
     <CHOICE "kitchen.take-sack"
             "Take the brown sack from the table"
             "take brown sack"
             ,CHOICE-INVESTIGATE
             80>)>

  <COND
    (<IN? ,BOTTLE ,KITCHEN-TABLE>
     <CHOICE "kitchen.take-bottle"
             "Take the glass bottle"
             "take bottle"
             ,CHOICE-INVESTIGATE
             70>)>

  <COND
    (<FSET? ,KITCHEN-WINDOW ,OPENBIT>
     <CHOICE "kitchen.return-yard"
             "Climb back through the kitchen window"
             "east"
             ,CHOICE-RETURN
             45>)>>

<ROUTINE SUGGEST-LIVING-ROOM ()
  <COND
    (<IN? ,LAMP ,LIVING-ROOM>
     <CHOICE "living-room.take-lamp"
             "Take the brass lantern"
             "take lamp"
             ,CHOICE-PROGRESS
             115>)>

  <COND
    (<IN? ,SWORD ,LIVING-ROOM>
     <CHOICE "living-room.take-sword"
             "Take the elvish sword"
             "take sword"
             ,CHOICE-PROGRESS
             105>)>

  <COND
    (<AND <IN? ,LAMP ,WINNER>
          <NOT <FSET? ,LAMP ,ONBIT>>>
     <CHOICE "living-room.light-lamp"
             "Turn on the brass lantern"
             "turn on lamp"
             ,CHOICE-PROGRESS
             100>)>

  <CHOICE "living-room.examine-case"
          "Examine the trophy case"
          "examine trophy case"
          ,CHOICE-INVESTIGATE
          85>

  <COND
    (<FSET? ,TRAP-DOOR ,INVISIBLE>
     <CHOICE "living-room.move-rug"
             "Move the large rug aside"
             "move rug"
             ,CHOICE-PROGRESS
             100>)
    (<NOT <FSET? ,TRAP-DOOR ,OPENBIT>>
     <CHOICE "living-room.open-trap-door"
             "Open the trap door"
             "open trap door"
             ,CHOICE-PROGRESS
             100>)
    (<FSET? ,LAMP ,ONBIT>
     <CHOICE "living-room.descend"
             "Descend the stairs beneath the trap door"
             "down"
             ,CHOICE-PROGRESS
             110>)>

  <CHOICE "living-room.return-kitchen"
          "Return to the kitchen"
          "east"
          ,CHOICE-RETURN
          50>>

<ROUTINE SUGGEST-ATTIC ()
  <COND
    (<IN? ,ROPE ,ATTIC>
     <CHOICE "attic.take-rope"
             "Take the coil of rope"
             "take rope"
             ,CHOICE-PROGRESS
             100>)>

  <COND
    (<FIRST? ,ATTIC-TABLE>
     <CHOICE "attic.examine-table"
             "Examine what is on the table"
             "examine table"
             ,CHOICE-INVESTIGATE
             70>)>

  <CHOICE "attic.return-kitchen"
          "Go back down to the kitchen"
          "down"
          ,CHOICE-RETURN
          85>>

<ROUTINE SUGGEST-SCENE ()
  <COND
    (<EQUAL? ,HERE ,WEST-OF-HOUSE>
     <SCENE "zork1.west-of-house"
            "An open field west of a white house with a boarded front door and a small mailbox.">)
    (<EQUAL? ,HERE ,NORTH-OF-HOUSE>
     <SCENE "zork1.north-of-house"
            "The boarded north side of a white house beside a narrow forest path.">)
    (<EQUAL? ,HERE ,SOUTH-OF-HOUSE>
     <SCENE "zork1.south-of-house"
            "The boarded south side of a white house at the edge of the forest.">)
    (<EQUAL? ,HERE ,EAST-OF-HOUSE>
     <COND
       (<FSET? ,KITCHEN-WINDOW ,OPENBIT>
        <SCENE "zork1.behind-house.window-open"
               "Behind the white house, the kitchen window stands open beside a forest path.">)
       (T
        <SCENE "zork1.behind-house"
               "Behind the white house, a small kitchen window sits slightly ajar.">)>)
    (<EQUAL? ,HERE ,KITCHEN>
     <SCENE "zork1.kitchen"
            "The white house kitchen, with a food-laden table, dark stairs, and a small window.">)
    (<EQUAL? ,HERE ,LIVING-ROOM>
     <SCENE "zork1.living-room"
            "A living room containing a trophy case, a brass lantern, and an elvish sword.">)
    (<EQUAL? ,HERE ,ATTIC>
     <SCENE "zork1.attic"
            "A dim attic with a table and a stairway leading back down.">)>>
