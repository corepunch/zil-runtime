"TEST-zork2.ZIL - Auto-generated test from transcript"

<INSERT-FILE "infocom/zork2/gglobals">
<INSERT-FILE "infocom/zork2/gclock">
<INSERT-FILE "infocom/zork2/gparser">
<INSERT-FILE "infocom/zork2/gverbs">
<INSERT-FILE "infocom/zork2/2actions">
<INSERT-FILE "infocom/zork2/gsyntax">
<INSERT-FILE "infocom/zork2/2dungeon">
<INSERT-FILE "infocom/zork2/gmain">
<CONSTANT RELEASEID 1>

<GLOBAL CO <CO-CREATE GO>>

<ROUTINE RUN-TEST ()
	<TELL "Testing zork2 transcript..." CR>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE SWORD">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE LAMP">>
	<ASSERT-TEXT "Forest" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "Forest" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "Forest" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "Shallow Ford" <CO-RESUME ,CO " SOUTHWEST">>
	<ASSERT-TEXT "The lamp is now on." <CO-RESUME ,CO " TURN ON LAMP">>
	<ASSERT-TEXT "Forest" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "North End of Garden" <CO-RESUME ,CO " SOUTHEAST">>
	<ASSERT-TEXT "Inside Gazebo" <CO-RESUME ,CO " ENTER">>
	<ASSERT-TEXT "On the table is a letter opener, a newspaper, a place mat, and a matchbook." <CO-RESUME ,CO " TAKE ALL">>
	<ASSERT-TEXT "North End of Garden" <CO-RESUME ,CO " LEAVE">>
	<ASSERT-TEXT "Forest" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Shallow Ford" <CO-RESUME ,CO " NORTHEAST">>
	<ASSERT-TEXT "With what? Water? The teapot is now full of water." <CO-RESUME ,CO " FILL TEAPOT">>
	<ASSERT-TEXT "Forest" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "Forest" <CO-RESUME ,CO " SOUTHWEST">>
	<ASSERT-TEXT "Carousel Room" <CO-RESUME ,CO " SOUTHWEST">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP LETTER OPENER">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP NEWSPAPER">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP PLACE MAT">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP MATCHBOOK">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP SWORD">>
	<ASSERT-TEXT "Northwest Passage" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Maze" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Maze" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "Riddle Room" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "\"A WELL\"" <CO-RESUME ,CO " SAY "A WELL"">>
	<ASSERT-TEXT "Circular Room" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "Circular Room" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "You are now in the bucket." <CO-RESUME ,CO " GET IN BUCKET">>
	<ASSERT-TEXT "The bucket rises to the top of the well." <CO-RESUME ,CO " POUR WATER">>
	<ASSERT-TEXT "You are no longer in the bucket." <CO-RESUME ,CO " GET OUT">>
	<ASSERT-TEXT "Tea Room" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "You take the green cake and the blue cake." <CO-RESUME ,CO " TAKE ALL EXCEPT ORANGE">>
	<ASSERT-TEXT "You shrink to about one-third of your normal size." <CO-RESUME ,CO " EAT GREEN CAKE">>
	<ASSERT-TEXT "Pool Room" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "You throw the red cake into the pool of tears." <CO-RESUME ,CO " THROW RED CAKE IN POOL">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE CANDIES">>
	<ASSERT-TEXT "Tea Room" <CO-RESUME ,CO " WEST">>
	<ASSERT-TEXT "You return to your normal size." <CO-RESUME ,CO " EAT BLUE CAKE">>
	<ASSERT-TEXT "Low Room" <CO-RESUME ,CO " NORTHWEST">>
	<ASSERT-TEXT "The robot goes east." <CO-RESUME ,CO " TELL ROBOT TO GO EAST">>
	<ASSERT-TEXT "Machine Room" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "The robot pushes the triangular button." <CO-RESUME ,CO " TELL ROBOT TO PUSH TRIANGULAR BUTTON">>
	<ASSERT-TEXT "The robot goes south." <CO-RESUME ,CO " TELL ROBOT TO GO SOUTH">>
	<ASSERT-TEXT "Low Room" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "As you take the sphere, a cage drops down on you." <CO-RESUME ,CO " TAKE SPHERE">>
	<ASSERT-TEXT "The robot lifts the cage." <CO-RESUME ,CO " TELL ROBOT TO LIFT CAGE">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE SPHERE">>
	<ASSERT-TEXT "Machine Room" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Low Room" <CO-RESUME ,CO " WEST">>
	<ASSERT-TEXT "Circular Room" <CO-RESUME ,CO " WEST">>
	<ASSERT-TEXT "You are now in the bucket." <CO-RESUME ,CO " GET IN BUCKET">>
	<ASSERT-TEXT "The bucket descends to the bottom of the well." <CO-RESUME ,CO " GET WATER">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP TEAPOT">>
	<ASSERT-TEXT "You are no longer in the bucket." <CO-RESUME ,CO " GET OUT">>
	<ASSERT-TEXT "Carousel Room" <CO-RESUME ,CO " WEST">>
	<ASSERT-TEXT "You pick up the necklace." <CO-RESUME ,CO " TAKE NECKLACE">>
	<ASSERT-TEXT "Riddle Room" <CO-RESUME ,CO " WEST">>
	<ASSERT-TEXT "Carousel Room" <CO-RESUME ,CO " NORTHWEST">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP SPHERE">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP NECKLACE">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP CANDY">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE SWORD">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE PLACE MAT">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE LETTER OPENER">>
	<ASSERT-TEXT "Marble Hall" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE BRICK">>
	<ASSERT-TEXT "North-South Passage" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "North-South Passage" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Tiny Room" <CO-RESUME ,CO " UP">>
	<ASSERT-TEXT "You slide the place mat under the locked door." <CO-RESUME ,CO " SLIDE MAT UNDER DOOR">>
	<ASSERT-TEXT "The lid moves." <CO-RESUME ,CO " MOVE LID">>
	<ASSERT-TEXT "You insert the letter opener in the keyhole." <CO-RESUME ,CO " INSERT OPENER IN KEYHOLE">>
	<ASSERT-TEXT "You remove the letter opener." <CO-RESUME ,CO " REMOVE OPENER">>
	<ASSERT-TEXT "You pull the place mat." <CO-RESUME ,CO " PULL MAT">>
	<ASSERT-TEXT "You take the key from the place mat." <CO-RESUME ,CO " TAKE KEY">>
	<ASSERT-TEXT "The door is now unlocked." <CO-RESUME ,CO " UNLOCK DOOR">>
	<ASSERT-TEXT "The door is now open." <CO-RESUME ,CO " OPEN DOOR">>
	<ASSERT-TEXT "Dreary Room" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP KEY">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP LETTER OPENER">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE BLUE SPHERE">>
	<ASSERT-TEXT "North-South Passage" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "North-South Passage" <CO-RESUME ,CO " DOWN">>
	<ASSERT-TEXT "Northwest Passage" <CO-RESUME ,CO " WEST">>
	<ASSERT-TEXT "Dragon Room" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "You attack the dragon. He runs away." <CO-RESUME ,CO " ATTACK DRAGON WITH SWORD">>
	<ASSERT-TEXT "Dragon Room" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "You attack the dragon. He runs away." <CO-RESUME ,CO " ATTACK DRAGON WITH SWORD">>
	<ASSERT-TEXT "Ice Room" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "The dragon drowns." <CO-RESUME ,CO " ATTACK DRAGON WITH SWORD">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP SWORD">>
	<ASSERT-TEXT "Dragon Room" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "Carousel Room" <CO-RESUME ,CO " SOUTHEAST">>
	<ASSERT-TEXT "Cobwebby Room" <CO-RESUME ,CO " SOUTHWEST">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE STRING">>
	<ASSERT-TEXT "Carousel Room" <CO-RESUME ,CO " NORTHEAST">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE NEWSPAPER">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE MATCHES">>
	<ASSERT-TEXT "Volcano" <CO-RESUME ,CO " NORTHWEST">>
	<ASSERT-TEXT "Volcano" <CO-RESUME ,CO " WEST">>
	<ASSERT-TEXT "Volcano" <CO-RESUME ,CO " WEST">>
	<ASSERT-TEXT "Volcano Bottom" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "You are now in the basket." <CO-RESUME ,CO " GET IN BASKET">>
	<ASSERT-TEXT "The receptacle is now open." <CO-RESUME ,CO " OPEN RECEPTACLE">>
	<ASSERT-TEXT "You put the newspaper in the receptacle." <CO-RESUME ,CO " PUT NEWSPAPER IN RECEPTACLE">>
	<ASSERT-TEXT "You light a match." <CO-RESUME ,CO " LIGHT MATCH">>
	<ASSERT-TEXT "You light the newspaper." <CO-RESUME ,CO " LIGHT NEWSPAPER WITH MATCH">>
	<ASSERT-TEXT "The balloon rises to the Narrow Ledge." <CO-RESUME ,CO " WAIT">>
	<ASSERT-TEXT "The balloon lands." <CO-RESUME ,CO " LAND">>
	<ASSERT-TEXT "You tie the wire to the hook." <CO-RESUME ,CO " TIE WIRE TO HOOK">>
	<ASSERT-TEXT "You are no longer in the basket." <CO-RESUME ,CO " GET OUT">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE ZORKMID">>
	<ASSERT-TEXT "Library" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "The purple book is now open." <CO-RESUME ,CO " OPEN PURPLE BOOK">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE STAMP">>
	<ASSERT-TEXT "Volcano" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "You are now in the basket." <CO-RESUME ,CO " GET IN BASKET">>
	<ASSERT-TEXT "You untie the wire." <CO-RESUME ,CO " UNTIE WIRE">>
	<ASSERT-TEXT "The balloon rises to the Wide Ledge." <CO-RESUME ,CO " WAIT">>
	<ASSERT-TEXT "The balloon lands." <CO-RESUME ,CO " LAND">>
	<ASSERT-TEXT "You tie the wire to the hook." <CO-RESUME ,CO " TIE WIRE TO HOOK">>
	<ASSERT-TEXT "You are no longer in the basket." <CO-RESUME ,CO " GET OUT">>
	<ASSERT-TEXT "Dusty Room" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "You put the string in the brick." <CO-RESUME ,CO " PUT STRING IN BRICK">>
	<ASSERT-TEXT "You put the brick in the hole in the box." <CO-RESUME ,CO " PUT BRICK IN HOLE">>
	<ASSERT-TEXT "You light a match." <CO-RESUME ,CO " LIGHT MATCH">>
	<ASSERT-TEXT "You light the string." <CO-RESUME ,CO " LIGHT STRING WITH MATCH">>
	<ASSERT-TEXT "Volcano" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Dusty Room" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE CROWN">>
	<ASSERT-TEXT "Volcano" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "You are now in the basket." <CO-RESUME ,CO " GET IN BASKET">>
	<ASSERT-TEXT "You untie the wire." <CO-RESUME ,CO " UNTIE WIRE">>
	<ASSERT-TEXT "The receptacle is now closed." <CO-RESUME ,CO " CLOSE RECEPTACLE">>
	<ASSERT-TEXT "The balloon rises and then descends to the Volcano Bottom." <CO-RESUME ,CO " WAIT">>
	<ASSERT-TEXT "You are no longer in the basket." <CO-RESUME ,CO " GET OUT">>
	<ASSERT-TEXT "Library" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE RUBY">>
	<ASSERT-TEXT "Volcano" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "Volcano" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "Carousel Room" <CO-RESUME ,CO " SOUTHEAST">>
	<ASSERT-TEXT "Done." <CO-RESUME ,CO " DROP ALL EXCEPT LAMP">>
	<ASSERT-TEXT "Northwest Passage" <CO-RESUME ,CO " NORTHWEST">>
	<ASSERT-TEXT "North-South Passage" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "North-South Passage" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Tiny Room" <CO-RESUME ,CO " WEST">>
	<ASSERT-TEXT "Maze" <CO-RESUME ,CO " WEST">>
	<ASSERT-TEXT "Bank Entrance" <CO-RESUME ,CO " WEST">>
	<ASSERT-TEXT "Depository" <CO-RESUME ,CO " NORTHEAST">>
	<ASSERT-TEXT "Small Room" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "Small Room" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "You enter the south wall." <CO-RESUME ,CO " ENTER SOUTH WALL">>
	<ASSERT-TEXT "You enter the Vault." <CO-RESUME ,CO " ENTER LIGHT">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE BILLS">>
	<ASSERT-TEXT "You enter the north wall. You are back in the Depository." <CO-RESUME ,CO " ENTER NORTH WALL">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP BILLS">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP PORTRAIT">>
	<ASSERT-TEXT "Small Room" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "Depository" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE BILLS">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE PORTRAIT">>
	<ASSERT-TEXT "You enter the Vault." <CO-RESUME ,CO " ENTER LIGHT">>
	<ASSERT-TEXT "South Entrance" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "Dragon's Lair" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "Dragon's Lair" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "Dragon's Lair" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "She waits." <CO-RESUME ,CO " TALK TO PRINCESS">>
	<ASSERT-TEXT "The princess leaves." <CO-RESUME ,CO " WAIT">>
	<ASSERT-TEXT "You follow the princess to the North End of Garden. She enters the gazebo. A uni..." <CO-RESUME ,CO " FOLLOW PRINCESS">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP ROSE">>
	<ASSERT-TEXT "North End of Garden" <CO-RESUME ,CO " LEAVE GAZEBO">>
	<ASSERT-TEXT "Forest" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "Forest" <CO-RESUME ,CO " WEST">>
	<ASSERT-TEXT "Shallow Ford" <CO-RESUME ,CO " SOUTHWEST">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP PORTRAIT">>
	<ASSERT-TEXT "Dropped." <CO-RESUME ,CO " DROP BILLS">>
	<ASSERT-TEXT "Forest" <CO-RESUME ,CO " NORTHWEST">>
	<ASSERT-TEXT "Forest" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Forest" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Dragon's Lair" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "The chest is now open." <CO-RESUME ,CO " OPEN CHEST">>
	<ASSERT-TEXT "The chest is now open." <CO-RESUME ,CO " OPEN CHEST">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE STATUETTE">>
	<ASSERT-TEXT "Forest" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "Forest" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "Forest" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "Carousel Room" <CO-RESUME ,CO " SOUTHEAST">>
	<ASSERT-TEXT "Carousel Room" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "Stairway" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "Oddly-Angled Room" <CO-RESUME ,CO " DOWN">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE CLUB">>
	<ASSERT-TEXT "Oddly-Angled Room" <CO-RESUME ,CO " SOUTHEAST">>
	<ASSERT-TEXT "Oddly-Angled Room" <CO-RESUME ,CO " NORTHEAST">>
	<ASSERT-TEXT "Oddly-Angled Room" <CO-RESUME ,CO " NORTHWEST">>
	<ASSERT-TEXT "Oddly-Angled Room" <CO-RESUME ,CO " SOUTHWEST">>
	<ASSERT-TEXT "Stairway" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Carousel Room" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE BLUE SPHERE">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE RED SPHERE">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE CANDY">>
	<ASSERT-TEXT "Guarded Room" <CO-RESUME ,CO " SOUTHWEST">>
	<ASSERT-TEXT "Guarded Room" <CO-RESUME ,CO " SOUTHWEST">>
	<ASSERT-TEXT "The lizard takes the candy." <CO-RESUME ,CO " GIVE CANDY TO LIZARD">>
	<ASSERT-TEXT "The door is now unlocked." <CO-RESUME ,CO " UNLOCK DOOR WITH GOLD KEY">>
	<ASSERT-TEXT "The door is now open." <CO-RESUME ,CO " OPEN DOOR">>
	<ASSERT-TEXT "South-West of Aquarium" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "Aquarium Room" <CO-RESUME ,CO " WEST">>
	<ASSERT-TEXT "Aquarium Room" <CO-RESUME ,CO " WEST">>
	<ASSERT-TEXT "You throw the club at the aquarium. It shatters. You take the clear sphere." <CO-RESUME ,CO " THROW CLUB AT AQUARIUM">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE CLEAR SPHERE">>
	<ASSERT-TEXT "South-West of Aquarium" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "Done." <CO-RESUME ,CO " PUT BLUE SPHERE ON BLUE STAND">>
	<ASSERT-TEXT "Done." <CO-RESUME ,CO " PUT RED SPHERE ON RED STAND">>
	<ASSERT-TEXT "Done." <CO-RESUME ,CO " PUT CLEAR SPHERE ON CLEAR STAND">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE BLACK SPHERE">>
	<ASSERT-TEXT "Pentagram Room" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "A demon appears." <CO-RESUME ,CO " PUT SPHERE ON CIRCLE">>
	<ASSERT-TEXT "The demon takes the treasures." <CO-RESUME ,CO " GIVE ALL TO DEMON">>
	<ASSERT-TEXT "The demon gives you the wand." <CO-RESUME ,CO " TELL DEMON TO GIVE ME THE WAND">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE WAND">>
	<ASSERT-TEXT "Pentagram Room" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Pentagram Room" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "North Corridor" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Menhir Room" <CO-RESUME ,CO " NORTH">>
	<ASSERT-TEXT "Menhir Room" <CO-RESUME ,CO " NORTHEAST">>
	<ASSERT-TEXT "Menhir Room" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "Say \"Float\" to make the menhir float." <CO-RESUME ,CO " WAVE WAND AT MENHIR">>
	<ASSERT-TEXT "The menhir floats." <CO-RESUME ,CO " SAY "FLOAT"">>
	<ASSERT-TEXT "Kennel" <CO-RESUME ,CO " SOUTHWEST">>
	<ASSERT-TEXT "Taken." <CO-RESUME ,CO " TAKE COLLAR">>
	<ASSERT-TEXT "Menhir Room" <CO-RESUME ,CO " NORTHEAST">>
	<ASSERT-TEXT "South Corridor" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "Cerberus Room" <CO-RESUME ,CO " DOWN">>
	<ASSERT-TEXT "Cerberus Room" <CO-RESUME ,CO " DOWN">>
	<ASSERT-TEXT "Cerberus falls asleep." <CO-RESUME ,CO " PUT COLLAR ON CERBERUS">>
	<ASSERT-TEXT "Crypt Anteroom" <CO-RESUME ,CO " EAST">>
	<ASSERT-TEXT "The crypt door is now open." <CO-RESUME ,CO " OPEN CRYPT DOOR">>
	<ASSERT-TEXT "Crypt" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "The lamp is now off. You find a secret door in the south wall." <CO-RESUME ,CO " TURN OFF LAMP">>
	<ASSERT-TEXT "The door is now open." <CO-RESUME ,CO " OPEN DOOR">>
	<ASSERT-TEXT "Landing" <CO-RESUME ,CO " SOUTH">>
	<ASSERT-TEXT "Are you sure you want to quit?" <CO-RESUME ,CO " QUIT">>
	<ASSERT-TEXT "" <CO-RESUME ,CO " YES">>
	<TELL CR "zork2 transcript test completed!" CR>>
