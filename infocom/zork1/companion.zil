;"State-aware intent cards for Zork I.

  This file is intentionally separate from the imported adventure source.
  Labels describe narrative intentions; commands are ordinary Zork parser input.
  The runtime evaluates SUGGEST-ACTIONS only while the game is waiting at READ."


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
  <CHOICE-DETAILS "group" "move">

  <CHOICE "west-house.go-south"
          "Walk around the south side of the house"
          "south"
          ,CHOICE-RETURN
          65>
  <CHOICE-DETAILS "group" "move">

  <CHOICE "west-house.enter-forest"
          "Follow the field west into the forest"
          "west"
          ,CHOICE-EXPERIMENT
          45>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-NORTH-OF-HOUSE ()
  <CHOICE "north-house.go-behind"
          "Walk around to the back of the house"
          "east"
          ,CHOICE-PROGRESS
          100>
  <CHOICE-DETAILS "group" "move">

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
  <CHOICE-DETAILS "group" "move">

  <CHOICE "north-house.return-front"
          "Return to the front of the house"
          "west"
          ,CHOICE-RETURN
          55>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-SOUTH-OF-HOUSE ()
  <CHOICE "south-house.go-behind"
          "Walk around to the back of the house"
          "east"
          ,CHOICE-PROGRESS
          100>
  <CHOICE-DETAILS "group" "move">

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
  <CHOICE-DETAILS "group" "move">

  <CHOICE "south-house.return-front"
          "Return to the front of the house"
          "west"
          ,CHOICE-RETURN
          55>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-EAST-OF-HOUSE ()
  <COND
    (<FSET? ,KITCHEN-WINDOW ,OPENBIT>
     <CHOICE "east-house.enter-window"
             "Climb through the open kitchen window"
             "enter window"
             ,CHOICE-PROGRESS
             115>
     <CHOICE-DETAILS "group" "move">)
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
  <CHOICE-DETAILS "group" "move">

  <CHOICE "east-house.go-north"
          "Walk around the north side of the house"
          "north"
          ,CHOICE-RETURN
          50>
  <CHOICE-DETAILS "group" "move">

  <CHOICE "east-house.go-south"
          "Walk around the south side of the house"
          "south"
          ,CHOICE-RETURN
          45>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-KITCHEN ()
  <CHOICE "kitchen.enter-living-room"
          "Go into the living room"
          "west"
          ,CHOICE-PROGRESS
          105>
  <CHOICE-DETAILS "group" "move">

  <CHOICE "kitchen.climb-stairs"
          "Climb the dark stairs to the attic"
          "up"
          ,CHOICE-EXPERIMENT
          65>
  <CHOICE-DETAILS "group" "move">

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
             45>
     <CHOICE-DETAILS "group" "move">)>>

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
             110>
     <CHOICE-DETAILS "group" "move">)>

  <CHOICE "living-room.return-kitchen"
          "Return to the kitchen"
          "east"
          ,CHOICE-RETURN
          50>
  <CHOICE-DETAILS "group" "move">>

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
          85>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-CELLAR ()
  <CHOICE "cellar.go-troll-room"
          "Go north toward the troll room"
          "north"
          ,CHOICE-PROGRESS
          105>
  <CHOICE-DETAILS "group" "move">

  <CHOICE "cellar.go-east-chasm"
          "Go south toward the east of the chasm"
          "south"
          ,CHOICE-EXPERIMENT
          45>
  <CHOICE-DETAILS "group" "move">

  <CHOICE "cellar.go-upstairs"
          "Climb back up to the living room"
          "up"
          ,CHOICE-RETURN
          55>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-TROLL-ROOM ()
  <COND
    (<AND <FSET? ,TROLL ,ONBIT> <NOT <EQUAL? ,HERE ,TROLL-ROOM>>>
     <CHOICE "troll-room.fight-troll"
             "Deal with the fierce troll"
             "attack troll"
             ,CHOICE-PROGRESS
             115>)
    (<IN? ,AXE ,TROLL-ROOM>
     <CHOICE "troll-room.take-axe"
             "Take the axe"
             "take axe"
             ,CHOICE-INVESTIGATE
             100>)>

  <CHOICE "troll-room.go-cellars"
          "Return south to the cellar"
          "south"
          ,CHOICE-RETURN
          60>
  <CHOICE-DETAILS "group" "move">

  <CHOICE "troll-room.go-west"
          "Go west into the maze"
          "west"
          ,CHOICE-PROGRESS
          95>
  <CHOICE-DETAILS "group" "move">

  <CHOICE "troll-room.go-east"
          "Go east toward the east-west passage"
          "east"
          ,CHOICE-EXPERIMENT
          50>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-MAZE-5 ()
  <COND
    (<IN? ,BAG-OF-COINS ,MAZE-5>
     <CHOICE "maze5.take-bag"
             "Take the bag of coins"
             "take bag"
             ,CHOICE-INVESTIGATE
             100>)>
  <COND
    (<IN? ,KEYS ,MAZE-5>
     <CHOICE "maze5.take-keys"
             "Take the skeleton keys"
             "take keys"
             ,CHOICE-PROGRESS
             100>)>
  <COND
    (<IN? ,BURNED-OUT-LANTERN ,MAZE-5>
     <CHOICE "maze5.take-lantern"
             "Take the burned-out lantern"
             "take lantern"
             ,CHOICE-INVESTIGATE
              60>)>
  <COND
    (<IN? ,RUSTY-KNIFE ,MAZE-5>
     <CHOICE "maze5.take-knife"
             "Take the rusty knife"
             "take knife"
             ,CHOICE-INVESTIGATE
              70>)>
  <COND
    (<IN? ,BONES ,MAZE-5>
     <CHOICE "maze5.examine-bones"
             "Examine the skeleton"
             "examine skeleton"
             ,CHOICE-INVESTIGATE
              75>)>>

<ROUTINE SUGGEST-GRATING-CLEARING ()
  <COND
    (<NOT <FSET? ,GRATE ,OPENBIT>>
     <CHOICE "clearing.open-grate"
             "Open the heavy iron grate"
             "open grate"
             ,CHOICE-PROGRESS
             110>)
    (T
     <CHOICE "clearing.descend-grate"
             "Descend through the open grate"
             "down"
             ,CHOICE-PROGRESS
             105>
     <CHOICE-DETAILS "group" "move">)>

  <CHOICE "clearing.go-west"
          "Return west toward the house"
          "west"
          ,CHOICE-RETURN
          50>
  <CHOICE-DETAILS "group" "move">

  <CHOICE "clearing.go-east"
          "Go east into the forest"
          "east"
          ,CHOICE-EXPERIMENT
          45>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-GRATING-ROOM ()
  <COND
    (<NOT <FSET? ,GRATE ,OPENBIT>>
     <CHOICE "grating-room.open-grate"
             "Open the grate above"
             "open grate"
             ,CHOICE-PROGRESS
             105>)
    (T
     <CHOICE "grating-room.climb-grate"
             "Climb up through the grate"
             "up"
             ,CHOICE-PROGRESS
             100>
     <CHOICE-DETAILS "group" "move">)>

  <CHOICE "grating-room.explore-maze"
          "Explore deeper into the maze"
          "east"
          ,CHOICE-EXPERIMENT
          60>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-CYCLOPS-ROOM ()
  <COND
    (<AND <FSET? ,CYCLOPS ,ONBIT> <IN? ,CYCLOPS ,CYCLOPS-ROOM>>
     <CHOICE "cyclops-room.confront-cyclops"
             "Confront the giant cyclops"
             "attack cyclops"
             ,CHOICE-PROGRESS
             110>)>

  <CHOICE "cyclops-room.go-strange-passage"
          "Go through the strange passage"
          "east"
          ,CHOICE-EXPERIMENT
          70>
  <CHOICE-DETAILS "group" "move">

  <CHOICE "cyclops-room.go-treasure-room"
          "Climb up to the treasure room"
          "up"
          ,CHOICE-PROGRESS
          95>
  <CHOICE-DETAILS "group" "move">

  <CHOICE "cyclops-room.return-maze"
          "Return west into the maze"
          "west"
          ,CHOICE-RETURN
          50>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-TREASURE-ROOM ()
  <COND
    (<IN? ,CHALICE ,TREASURE-ROOM>
     <CHOICE "treasure-room.take-chalice"
             "Take the silver chalice"
             "take chalice"
             ,CHOICE-PROGRESS
             105>)>

  <CHOICE "treasure-room.return-cyclops"
          "Go back down to the cyclops room"
          "down"
          ,CHOICE-RETURN
          50>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-RESERVOIR ()
  <COND
    (<IN? ,TRUNK ,RESERVOIR>
     <COND
       (<NOT <FSET? ,TRUNK ,OPENBIT>>
        <CHOICE "reservoir.open-trunk"
                "Open the trunk"
                "open trunk"
                ,CHOICE-INVESTIGATE
                95>)
       (T
        <CHOICE "reservoir.take-treasures"
                "Take the jewels from the trunk"
                "take jewels"
                ,CHOICE-PROGRESS
                100>)>)>
  <COND
    (<IN? ,PUMP ,RESERVOIR-NORTH>
     <CHOICE "reservoir.take-pump"
             "Take the air pump"
             "take pump"
             ,CHOICE-PROGRESS
             105>)>

  <CHOICE "reservoir.go-stream-view"
          "Go toward the stream view"
          "north"
          ,CHOICE-EXPERIMENT
          60>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-DAM-LOBBY ()
  <COND
    (<IN? ,MATCH ,DAM-LOBBY>
     <CHOICE "dam-lobby.take-matches"
             "Take the matchbook"
             "take matchbook"
             ,CHOICE-INVESTIGATE
             105>)>
  <COND
    (<IN? ,GUIDE ,DAM-LOBBY>
     <CHOICE "dam-lobby.take-guide"
             "Take the tour guidebook"
             "take guide"
             ,CHOICE-INVESTIGATE
              80>)>

  <CHOICE "dam-lobby.go-dam"
          "Go into the main dam room"
          "north"
          ,CHOICE-PROGRESS
          95>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-MAINTENANCE-ROOM ()
  <COND
    (<IN? ,SCREWDRIVER ,MAINTENANCE-ROOM>
     <CHOICE "maint.take-screwdriver"
             "Take the screwdriver"
             "take screwdriver"
             ,CHOICE-INVESTIGATE
             105>)>
  <COND
    (<IN? ,WRENCH ,MAINTENANCE-ROOM>
     <CHOICE "maint.take-wrench"
             "Take the wrench"
             "take wrench"
             ,CHOICE-INVESTIGATE
             100>)>
  <COND
    (<IN? ,TUBE ,MAINTENANCE-ROOM>
     <CHOICE "maint.take-putty"
             "Take the tube of putty"
             "take tube"
             ,CHOICE-INVESTIGATE
              90>)>
  <COND
    (<IN? ,YELLOW-BUTTON ,MAINTENANCE-ROOM>
     <CHOICE "maint.push-button"
             "Push the yellow button"
             "push yellow button"
             ,CHOICE-EXPERIMENT
              85>)>>

<ROUTINE SUGGEST-MACHINE-ROOM ()
  <COND
    (<NOT <FSET? ,MACHINE ,ONBIT>>
     <CHOICE "machine.turn-on"
             "Turn on the machine"
             "turn on machine"
             ,CHOICE-EXPERIMENT
             95>)
    (T
     <CHOICE "machine.turn-off"
             "Turn off the machine"
             "turn off machine"
             ,CHOICE-EXPERIMENT
              50>)>

  <CHOICE "machine.return-mine"
          "Go back into the coal mine"
          "west"
          ,CHOICE-RETURN
          60>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-ROUND-ROOM ()
  <CHOICE "round-room.go-ew-passage"
          "Go east into the east-west passage"
          "east"
          ,CHOICE-EXPERIMENT
          55>
  <CHOICE-DETAILS "group" "move">

  <CHOICE "round-room.go-damp-cave"
          "Go west toward the damp cave"
          "west"
          ,CHOICE-EXPERIMENT
          60>
  <CHOICE-DETAILS "group" "move">

  <CHOICE "round-room.go-loud-room"
          "Go north to the loud room"
          "north"
          ,CHOICE-PROGRESS
          95>
  <CHOICE-DETAILS "group" "move">

  <CHOICE "round-room.go-chasm"
          "Go south toward the chasm room"
          "south"
          ,CHOICE-EXPERIMENT
          50>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-LOUD-ROOM ()
  <COND
    (<IN? ,BAR ,LOUD-ROOM>
     <CHOICE "loud-room.take-bar"
             "Take the platinum bar"
             "take bar"
             ,CHOICE-PROGRESS
             100>)>

  <CHOICE "loud-room.return-round"
          "Return to the round room"
          "south"
          ,CHOICE-RETURN
          55>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-NORTH-TEMPLE ()
  <COND
    (<IN? ,BELL ,NORTH-TEMPLE>
     <CHOICE "temple.take-bell"
             "Take the brass bell"
             "take bell"
             ,CHOICE-PROGRESS
             100>)>
  <COND
    (<NOT <IN? ,BELL ,WINNER>>
     <CHOICE "temple.read-prayer"
             "Read the prayer inscription"
             "read prayer"
             ,CHOICE-INVESTIGATE
              85>)>

  <CHOICE "temple.go-altar"
          "Go south to the altar"
          "south"
          ,CHOICE-EXPERIMENT
          60>
  <CHOICE-DETAILS "group" "move">

  <CHOICE "temple.go-dome"
          "Go east to the dome room"
          "east"
          ,CHOICE-EXPERIMENT
          50>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-SOUTH-TEMPLE ()
  <COND
    (<AND <IN? ,CANDLES ,SOUTH-TEMPLE> <FSET? ,CANDLES ,ONBIT>>
     <CHOICE "altar.take-candles"
             "Take the candles"
             "take candles"
             ,CHOICE-INVESTIGATE
              85>)>
  <COND
    (<IN? ,BOOK ,ALTAR>
     <CHOICE "altar.take-book"
             "Take the book from the altar"
             "take book"
             ,CHOICE-INVESTIGATE
             100>)>

  <CHOICE "altar.return-temple"
          "Return north to the temple"
          "north"
          ,CHOICE-RETURN
          55>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-EGYPT-ROOM ()
  <COND
    (<IN? ,COFFIN ,EGYPT-ROOM>
     <COND
       (<NOT <FSET? ,COFFIN ,OPENBIT>>
        <CHOICE "egypt.open-coffin"
                "Open the gold coffin"
                "open coffin"
                ,CHOICE-PROGRESS
                105>)
       (T
        <CHOICE "egypt.take-sceptre"
                "Take the sceptre from the coffin"
                "take sceptre"
                ,CHOICE-PROGRESS
                100>)>)>

  <CHOICE "egypt.go-temple"
          "Go to the temple entrance"
          "west"
          ,CHOICE-EXPERIMENT
          55>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-BAT-ROOM ()
  <COND
    (<IN? ,JADE ,BAT-ROOM>
     <COND
       (<NOT <FSET? ,BAT ,MOVED>>
        <CHOICE "bat-room.get-jade"
                "Find a way past the bat to reach the jade figurine"
                "get jade"
                ,CHOICE-PROGRESS
                100>)
       (T
        <CHOICE "bat-room.take-jade"
                "Take the jade figurine"
                "take jade"
                ,CHOICE-INVESTIGATE
                100>)>)>

  <CHOICE "bat-room.go-mine"
          "Return to the mine entrance"
          "west"
          ,CHOICE-RETURN
          55>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-HADES ()
  <COND
    (<IN? ,SKULL ,LAND-OF-LIVING-DEAD>
     <CHOICE "hades.take-skull"
             "Take the crystal skull"
             "take skull"
             ,CHOICE-PROGRESS
             105>)>

  <CHOICE "hades.go-temple"
          "Return through the temple passage"
          "west"
          ,CHOICE-RETURN
          50>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-ATLANTIS-ROOM ()
  <COND
    (<IN? ,TRIDENT ,ATLANTIS-ROOM>
     <CHOICE "atlantis.take-trident"
             "Take the crystal trident"
             "take trident"
             ,CHOICE-PROGRESS
             105>)>

  <CHOICE "atlantis.go-mirror"
          "Return through the mirror rooms"
          "west"
          ,CHOICE-RETURN
          50>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-TORCH-ROOM ()
  <COND
    (<AND <IN? ,PEDESTAL ,TORCH-ROOM> <FIRST? ,PEDESTAL>>
     <CHOICE "torch-room.take-torch"
             "Take the torch from the pedestal"
             "take torch"
             ,CHOICE-PROGRESS
             100>)>

  <CHOICE "torch-room.go-dome"
          "Go to the dome room"
          "south"
          ,CHOICE-EXPERIMENT
          55>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-GALLERY ()
  <COND
    (<IN? ,PAINTING ,GALLERY>
     <CHOICE "gallery.take-painting"
             "Take the painting"
             "take painting"
             ,CHOICE-PROGRESS
             100>)>

  <CHOICE "gallery.go-studio"
          "Go north to the studio"
          "north"
          ,CHOICE-EXPERIMENT
          60>
  <CHOICE-DETAILS "group" "move">

  <CHOICE "gallery.return-chasm"
          "Return south to the chasm"
          "south"
          ,CHOICE-RETURN
          50>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-STUDIO ()
  <COND
    (<IN? ,OWNERS-MANUAL ,STUDIO>
     <CHOICE "studio.read-manual"
             "Read the owner's manual"
             "read manual"
             ,CHOICE-INVESTIGATE
             100>)>

  <CHOICE "studio.return-gallery"
          "Return to the gallery"
          "south"
          ,CHOICE-RETURN
          50>
  <CHOICE-DETAILS "group" "move">>

<ROUTINE SUGGEST-ARAGAIN-FALLS ()
  <COND
    (<NOT <IN? ,POT-OF-GOLD ,WINNER>>
     <COND
       (<IN? ,POT-OF-GOLD ,END-OF-RAINBOW>
        <CHOICE "rainbow.climb-rainbow"
                "Climb the rainbow to the pot of gold"
                "climb rainbow"
                ,CHOICE-PROGRESS
                115>)>)>
  <CHOICE "falls.go-beach"
          "Go to the sandy beach"
          "south"
          ,CHOICE-EXPERIMENT
          55>
  <CHOICE-DETAILS "group" "move">

  <CHOICE "falls.go-canyon"
          "Go toward the canyon bottom"
          "north"
          ,CHOICE-EXPERIMENT
          50>
  <CHOICE-DETAILS "group" "move">>

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
     <SUGGEST-ATTIC>)
    (<EQUAL? ,HERE ,CELLAR>
     <SUGGEST-CELLAR>)
    (<EQUAL? ,HERE ,TROLL-ROOM>
     <SUGGEST-TROLL-ROOM>)
    (<EQUAL? ,HERE ,MAZE-5>
     <SUGGEST-MAZE-5>)
    (<EQUAL? ,HERE ,GRATING-CLEARING>
     <SUGGEST-GRATING-CLEARING>)
    (<EQUAL? ,HERE ,GRATING-ROOM>
     <SUGGEST-GRATING-ROOM>)
    (<EQUAL? ,HERE ,CYCLOPS-ROOM>
     <SUGGEST-CYCLOPS-ROOM>)
    (<EQUAL? ,HERE ,TREASURE-ROOM>
     <SUGGEST-TREASURE-ROOM>)
    (<EQUAL? ,HERE ,RESERVOIR>
     <SUGGEST-RESERVOIR>)
    (<EQUAL? ,HERE ,RESERVOIR-NORTH>
     <SUGGEST-RESERVOIR>)
    (<EQUAL? ,HERE ,DAM-LOBBY>
     <SUGGEST-DAM-LOBBY>)
    (<EQUAL? ,HERE ,MAINTENANCE-ROOM>
     <SUGGEST-MAINTENANCE-ROOM>)
    (<EQUAL? ,HERE ,MACHINE-ROOM>
     <SUGGEST-MACHINE-ROOM>)
    (<EQUAL? ,HERE ,ROUND-ROOM>
     <SUGGEST-ROUND-ROOM>)
    (<EQUAL? ,HERE ,LOUD-ROOM>
     <SUGGEST-LOUD-ROOM>)
    (<EQUAL? ,HERE ,NORTH-TEMPLE>
     <SUGGEST-NORTH-TEMPLE>)
    (<EQUAL? ,HERE ,SOUTH-TEMPLE>
     <SUGGEST-SOUTH-TEMPLE>)
    (<EQUAL? ,HERE ,EGYPT-ROOM>
     <SUGGEST-EGYPT-ROOM>)
    (<EQUAL? ,HERE ,BAT-ROOM>
     <SUGGEST-BAT-ROOM>)
    (<EQUAL? ,HERE ,ENTRANCE-TO-HADES>
     <SUGGEST-HADES>)
    (<EQUAL? ,HERE ,LAND-OF-LIVING-DEAD>
     <SUGGEST-HADES>)
    (<EQUAL? ,HERE ,ATLANTIS-ROOM>
     <SUGGEST-ATLANTIS-ROOM>)
    (<EQUAL? ,HERE ,TORCH-ROOM>
     <SUGGEST-TORCH-ROOM>)
    (<EQUAL? ,HERE ,GALLERY>
     <SUGGEST-GALLERY>)
    (<EQUAL? ,HERE ,STUDIO>
     <SUGGEST-STUDIO>)
    (<EQUAL? ,HERE ,ARAGAIN-FALLS>
     <SUGGEST-ARAGAIN-FALLS>)>>

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
            "A dim attic with a table and a stairway leading back down.">)
    (<EQUAL? ,HERE ,CELLAR>
     <SCENE "zork1.cellar"
            "A damp cellar beneath the living room, with passages leading north and south.">)
    (<EQUAL? ,HERE ,TROLL-ROOM>
     <SCENE "zork1.troll-room"
            "A foul room occupied by a dangerous troll. Passages lead west, east, and south.">)
    (<EQUAL? ,HERE ,MAZE-5>
     <SCENE "zork1.maze5"
            "A maze chamber littered with the remains of a previous explorer.">)
    (<EQUAL? ,HERE ,GRATING-CLEARING>
     <SCENE "zork1.grating-clearing"
            "A clearing in the forest with a heavy iron grate set into the ground.">)
    (<EQUAL? ,HERE ,GRATING-ROOM>
     <SCENE "zork1.grating-room"
            "A stone chamber below the grate, at the edge of a twisting maze.">)
    (<EQUAL? ,HERE ,CYCLOPS-ROOM>
     <SCENE "zork1.cyclops-room"
            "A cavern occupied by a fearsome one-eyed cyclops.">)
    (<EQUAL? ,HERE ,TREASURE-ROOM>
     <SCENE "zork1.treasure-room"
            "A small vaulted chamber containing a silver chalice on a pedestal.">)
    (<EQUAL? ,HERE ,RESERVOIR>
     <SCENE "zork1.reservoir"
            "An underground reservoir with a trunk of jewels at the bottom.">)
    (<EQUAL? ,HERE ,LOUD-ROOM>
     <SCENE "zork1.loud-room"
            "A thunderously loud cavern with a platinum bar on the floor.">)
    (<EQUAL? ,HERE ,DAM-LOBBY>
     <SCENE "zork1.dam-lobby"
            "The entrance lobby to Flood Control Dam #3, with a tour guidebook.">)
    (<EQUAL? ,HERE ,MAINTENANCE-ROOM>
     <SCENE "zork1.maintenance-room"
            "A well-stocked maintenance room behind the dam.">)
    (<EQUAL? ,HERE ,MACHINE-ROOM>
     <SCENE "zork1.machine-room"
            "A strange room housing an unknown machine with a large switch.">)
    (<EQUAL? ,HERE ,NORTH-TEMPLE>
     <SCENE "zork1.north-temple"
            "The antechamber of an ancient temple, with a brass bell and a prayer inscription.">)
    (<EQUAL? ,HERE ,SOUTH-TEMPLE>
     <SCENE "zork1.south-temple"
            "A solemn altar room with candles and a mysterious book.">)
    (<EQUAL? ,HERE ,EGYPT-ROOM>
     <SCENE "zork1.egypt-room"
            "An Egyptian-themed burial chamber with a gold coffin.">)
    (<EQUAL? ,HERE ,BAT-ROOM>
     <SCENE "zork1.bat-room"
            "A dark cavern filled with the squeaking of a vampire bat.">)
    (<EQUAL? ,HERE ,ENTRANCE-TO-HADES>
     <SCENE "zork1.entrance-hades"
            "The eerie entrance to the land of the dead, shrouded in mist.">)
    (<EQUAL? ,HERE ,LAND-OF-LIVING-DEAD>
     <SCENE "zork1.land-dead"
            "A desolate realm where the dead wander, a crystal skull glimmers nearby.">)
    (<EQUAL? ,HERE ,ATLANTIS-ROOM>
     <SCENE "zork1.atlantis-room"
            "A cavern that seems to have risen from the sea, with a crystal trident.">)
    (<EQUAL? ,HERE ,TORCH-ROOM>
     <SCENE "zork1.torch-room"
            "A small chamber with a pedestal holding a torch.">)
    (<EQUAL? ,HERE ,GALLERY>
     <SCENE "zork1.gallery"
            "An underground art gallery with a painting on the wall.">)
    (<EQUAL? ,HERE ,STUDIO>
     <SCENE "zork1.studio"
            "A dusty studio with an owner's manual on the floor.">)
    (<EQUAL? ,HERE ,ARAGAIN-FALLS>
     <SCENE "zork1.aragain-falls"
            "The base of Aragain Falls, where a rainbow sometimes appears.">)>>
