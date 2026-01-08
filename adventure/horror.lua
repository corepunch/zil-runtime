<DIRECTIONS NORTH EAST WEST SOUTH NE NW SE SW UP DOWN IN OUT LAND>
<VERSION ZIP>
<CONSTANT RELEASEID 1>

<ROOM SANITARIUM-GATE
      (IN ROOMS)
      (DESC "Sanitarium Gate")
      (LDESC "You stand before the rusted iron gates of an abandoned sanitarium. The structure looms against the darkening sky, its windows like hollow eye sockets. Weeds choke the gravel path leading north to the entrance. A corroded brass plaque hangs askew on the gate.")
      (NORTH TO SANITARIUM-ENTRANCE)
      (FLAGS LIGHTBIT)>

<ROUTINE PLAQUE-F ()
         <COND (<VERB? READ EXAMINE>
                <TELL "The plaque reads: 'Blackwood Sanitarium - Est. 1898 - Closed by Order 1952'" CR>
                <RTRUE>)>>

<OBJECT BRASS-PLAQUE
        (IN SANITARIUM-GATE)
        (SYNONYM PLAQUE BRASS SIGN)
        (ADJECTIVE BRASS CORRODED)
        (DESC "brass plaque")
        (LDESC "The plaque reads: 'Blackwood Sanitarium - Est. 1898 - Closed by Order 1952'")
        (FLAGS READBIT TAKEBIT)
        (TEXT "Blackwood Sanitarium - Est. 1898 - Closed by Order 1952")
        (SIZE 5)
        (ACTION PLAQUE-F)>

<ROOM SANITARIUM-ENTRANCE
      (IN ROOMS)
      (DESC "Sanitarium Entrance Hall")
      (LDESC "The entrance hall reeks of mildew and decay. Peeling wallpaper reveals water-stained plaster beneath. A grand staircase ascends to darkness in the east. To the west, a doorway leads to what might have been a reception area. North, you can make out an operating theater through a half-open door.")
      (SOUTH TO SANITARIUM-GATE)
      (WEST TO RECEPTION-ROOM)
      (NORTH TO OPERATING-THEATER)
      (EAST TO PATIENT-WARD)
      (FLAGS LIGHTBIT)>

<OBJECT WALLPAPER
        (IN SANITARIUM-ENTRANCE)
        (SYNONYM WALLPAPER PAPER PLASTER)
        (ADJECTIVE PEELING)
        (DESC "peeling wallpaper")
        (LDESC "Victorian-era wallpaper depicting pastoral scenes, now grotesquely warped by moisture.")
        (FLAGS NDESCBIT)
        (ACTION WALLPAPER-F)>

<ROUTINE WALLPAPER-F ()
         <COND (<VERB? EXAMINE LOOK-INSIDE>
                <TELL "Victorian-era wallpaper depicting pastoral scenes, now grotesquely warped by moisture and black mold." CR>
                <RTRUE>)>>

<ROOM RECEPTION-ROOM
      (IN ROOMS)
      (DESC "Reception Room")
      (LDESC "This cramped room once served as the sanitarium's reception. A heavy oak desk sits against one wall, its surface thick with dust. Filing cabinets line the opposite wall, their drawers hanging open like gaping mouths. Something glints among the papers scattered on the floor.")
      (EAST TO SANITARIUM-ENTRANCE)
      (FLAGS LIGHTBIT)>

<OBJECT OAK-DESK
        (IN RECEPTION-ROOM)
        (SYNONYM DESK)
        (ADJECTIVE HEAVY OAK)
        (DESC "oak desk")
        (LDESC "The desk has three drawers. Only the bottom drawer appears intact.")
        (FLAGS NDESCBIT CONTBIT OPENBIT SURFACEBIT)
        (ACTION DESK-F)>

<ROUTINE DESK-F ()
         <COND (<VERB? EXAMINE LOOK-INSIDE>
                <TELL "The desk has three drawers. The top two are broken and empty. The bottom drawer appears intact but is locked tight." CR>
                <RTRUE>)>>

<OBJECT BOTTOM-DRAWER
        (IN OAK-DESK)
        (SYNONYM DRAWER)
        (ADJECTIVE BOTTOM)
        (DESC "bottom drawer")
        (LDESC "A sturdy drawer that seems to be locked.")
        (FLAGS CONTBIT NDESCBIT)
        (CAPACITY 10)
        (ACTION DRAWER-F)>

<ROUTINE DRAWER-F ()
         <COND (<AND <VERB? OPEN>
                     <FSET? ,BOTTOM-DRAWER ,OPENBIT>>
                <TELL "The drawer is already open." CR>
                <RTRUE>)
               (<AND <VERB? OPEN UNLOCK>
                     <NOT <FSET? ,BOTTOM-DRAWER ,OPENBIT>>
                     <NOT <IN? ,BRASS-KEY ,WINNER>>>
                <TELL "The drawer is locked. You need a key." CR>
                <RTRUE>)
               (<AND <VERB? OPEN UNLOCK>
                     <NOT <FSET? ,BOTTOM-DRAWER ,OPENBIT>>
                     <IN? ,BRASS-KEY ,WINNER>>
                <TELL "You unlock the bottom drawer with the brass key. It slides open with a groan, revealing a leather-bound ledger inside." CR>
                <FCLEAR ,BOTTOM-DRAWER ,NDESCBIT>
                <FSET ,BOTTOM-DRAWER ,OPENBIT>
                <RTRUE>)>>

<OBJECT BRASS-KEY
        (IN RECEPTION-ROOM)
        (SYNONYM KEY)
        (ADJECTIVE BRASS SMALL)
        (DESC "brass key")
        (LDESC "A small brass key, cold to the touch.")
        (FLAGS TAKEBIT)
        (SIZE 2)
        (ACTION BRASSKEY-F)>

<ROUTINE BRASSKEY-F ()
         <COND (<VERB? EXAMINE>
                <TELL "A small brass key with the number '3' engraved on its head. It's ice cold despite being indoors." CR>
                <RTRUE>)>>

<OBJECT PATIENT-LEDGER
        (IN BOTTOM-DRAWER)
        (SYNONYM LEDGER BOOK JOURNAL)
        (ADJECTIVE PATIENT LEATHER)
        (DESC "patient ledger")
        (LDESC "A leather-bound ledger with names and dates. The final entry reads: 'Patient 237 - Treatment discontinued. Subject expired during procedure. Dr. Mordecai.'")
        (FLAGS READBIT TAKEBIT)
        (TEXT "Patient 237 - Treatment discontinued. Subject expired during procedure. Dr. Mordecai.")
        (SIZE 8)
        (ACTION LEDGER-F)>

<ROUTINE LEDGER-F ()
         <COND (<VERB? READ EXAMINE>
                <TELL "The ledger contains patient records spanning decades. The entries become more disturbing toward the end. The final entry reads: 'Patient 237 - Treatment discontinued. Subject expired during procedure. Dr. Mordecai. May God have mercy on us all.'" CR>
                <RTRUE>)>>

<ROOM OPERATING-THEATER
      (IN ROOMS)
      (DESC "Operating Theater")
      (LDESC "The circular theater is dominated by a stained operating table in the center. Rusty surgical instruments lie scattered about. Rising tiers of benches circle the table, where students once observed procedures. A metal cabinet stands in the shadows, its door slightly ajar. The air here is thick with an oppressive dread.")
      (SOUTH TO SANITARIUM-ENTRANCE)
      (FLAGS LIGHTBIT)>

<OBJECT OPERATING-TABLE
        (IN OPERATING-THEATER)
        (SYNONYM TABLE)
        (ADJECTIVE OPERATING STAINED)
        (DESC "operating table")
        (LDESC "The table is covered in dark stains. Leather restraints dangle from its edges.")
        (FLAGS NDESCBIT SURFACEBIT)
        (ACTION OPTABLE-F)>

<ROUTINE OPTABLE-F ()
         <COND (<VERB? EXAMINE LOOK-INSIDE>
                <TELL "The operating table is covered in dark brown stains that you hope are just rust. Leather restraints dangle from all four corners. Deep gouges mar the metal surface, as if someone struggled violently against the bindings." CR>
                <RTRUE>)>>

<OBJECT METAL-CABINET
        (IN OPERATING-THEATER)
        (SYNONYM CABINET)
        (ADJECTIVE METAL MEDICAL)
        (DESC "metal cabinet")
        (LDESC "A tall cabinet with glass doors, now cracked and clouded.")
        (FLAGS NDESCBIT CONTBIT OPENBIT TRANSBIT)
        (ACTION CABINET-F)>

<ROUTINE CABINET-F ()
         <COND (<VERB? EXAMINE LOOK-INSIDE>
                <TELL "The cabinet's glass doors are cracked but still intact. Inside, you can see various medical instruments, including a scalpel and a bottle." CR>
                <RTRUE>)>>

<OBJECT SCALPEL
        (IN METAL-CABINET)
        (SYNONYM SCALPEL KNIFE BLADE)
        (ADJECTIVE SURGICAL RUSTY)
        (DESC "rusty scalpel")
        (LDESC "A surgical scalpel, its blade dulled by rust but still sharp enough to cut.")
        (FLAGS TAKEBIT WEAPONBIT TOOLBIT)
        (SIZE 3)
        (ACTION SCALPEL-F)>

<ROUTINE SCALPEL-F ()
         <COND (<VERB? EXAMINE>
                <TELL "The scalpel's blade is rusty but still razor-sharp along one edge. The handle is stained with something dark." CR>
                <RTRUE>)>>

<OBJECT ETHER-BOTTLE
        (IN METAL-CABINET)
        (SYNONYM BOTTLE ETHER CHLOROFORM)
        (ADJECTIVE GLASS)
        (DESC "bottle of ether")
        (LDESC "A glass bottle labeled 'Ether - Handle with Care'. Some liquid remains inside.")
        (FLAGS TAKEBIT)
        (SIZE 5)
        (ACTION ETHER-F)>

<ROUTINE ETHER-F ()
         <COND (<VERB? EXAMINE>
                <TELL "A glass bottle with a faded label reading 'Ether - Handle with Care'. About a quarter of the liquid remains." CR>
                <RTRUE>)
               (<VERB? DRINK>
                <TELL "That would be an extremely bad idea." CR>
                <RTRUE>)>>

<ROOM PATIENT-WARD
      (IN ROOMS)
      (DESC "Patient Ward")
      (LDESC "A long corridor lined with rusted bed frames. Tattered curtains hang between them, offering the ghost of privacy. At the far end, a heavy door sealed with chains blocks further passage. Scratches cover the door's surface, as if made by desperate fingers. The floor is littered with patient records and broken glass.")
      (WEST TO SANITARIUM-ENTRANCE)
      (NORTH TO MORGUE IF CHAINS-CUT-FLAG)
      (FLAGS LIGHTBIT)>

<OBJECT BED-FRAMES
        (IN PATIENT-WARD)
        (SYNONYM BEDS FRAMES BED FRAME)
        (ADJECTIVE RUSTED)
        (DESC "bed frames")
        (LDESC "Skeletal remains of hospital beds, springs poking through rotted mattresses.")
        (FLAGS NDESCBIT)
        (ACTION BEDS-F)>

<ROUTINE BEDS-F ()
         <COND (<VERB? EXAMINE LOOK-INSIDE>
                <TELL "Dozens of bed frames line the walls. The mattresses have rotted away, leaving only rusted springs and metal frames. Some still have restraint straps attached." CR>
                <RTRUE>)>>

<OBJECT HEAVY-DOOR
        (IN PATIENT-WARD)
        (SYNONYM DOOR)
        (ADJECTIVE HEAVY SEALED LOCKED MORGUE)
        (DESC "heavy door")
        (LDESC "The door is secured with thick chains and a padlock. Deep scratches mar its surface.")
        (FLAGS NDESCBIT)
        (ACTION HEAVYDOOR-F)>

<ROUTINE HEAVYDOOR-F ()
         <COND (<AND <VERB? EXAMINE>
                     <NOT ,CHAINS-CUT-FLAG>>
                <TELL "The heavy door is secured with thick chains and a rusted padlock. Deep scratches cover its surface, made by fingernails. A tarnished plaque reads 'MORGUE'." CR>
                <RTRUE>)
               (<AND <VERB? EXAMINE>
                     ,CHAINS-CUT-FLAG>
                <TELL "The door stands open, chains lying in a heap on the floor. Beyond lies darkness." CR>
                <RTRUE>)
               (<AND <VERB? OPEN>
                     <NOT ,CHAINS-CUT-FLAG>>
                <TELL "The door is secured with heavy chains. You need to cut through them." CR>
                <RTRUE>)>>

<OBJECT CHAINS
        (IN PATIENT-WARD)
        (SYNONYM CHAINS CHAIN PADLOCK)
        (ADJECTIVE THICK)
        (DESC "chains")
        (LDESC "Heavy chains secured with a rusted padlock.")
        (FLAGS NDESCBIT)
        (ACTION CHAINS-F)>

<ROUTINE CHAINS-F ()
         <COND (<AND <VERB? EXAMINE>
                     <NOT ,CHAINS-CUT-FLAG>>
                <TELL "Thick iron chains wrap around the door handles, secured with a massive rusted padlock. The chains look old but still strong." CR>
                <RTRUE>)
               (<AND <VERB? ATTACK>
                     <NOT ,CHAINS-CUT-FLAG>
                     <NOT <IN? ,SCALPEL ,WINNER>>>
                <TELL "The chains are too strong to break with your bare hands. You need a sharp tool." CR>
                <RTRUE>)
               (<AND <VERB? ATTACK>
                     <NOT ,CHAINS-CUT-FLAG>
                     <IN? ,SCALPEL ,WINNER>>
                <TELL "You saw through the rusty chains with the scalpel. It takes several minutes of effort, but finally they fall away with a crash. The heavy door creaks open, revealing a passage north into darkness." CR>
                <SETG CHAINS-CUT-FLAG T>
                <REMOVE ,CHAINS>
                <RTRUE>)>>

<ROOM MORGUE
      (IN ROOMS)
      (DESC "Morgue")
      (LDESC "The temperature drops as you enter the morgue. Refrigerated drawers line both walls. In the center, a dissection table holds what appears to be a canvas-wrapped bundle. Medical instruments hang on the wall. A journal rests on a small desk in the corner. This place feels wrong, as though something lingers here still.")
      (SOUTH TO PATIENT-WARD)
      (FLAGS LIGHTBIT)>

<OBJECT REFRIGERATED-DRAWERS
        (IN MORGUE)
        (SYNONYM DRAWERS DRAWER REFRIGERATOR)
        (ADJECTIVE REFRIGERATED METAL)
        (DESC "refrigerated drawers")
        (LDESC "Most drawers are empty, but one is slightly open.")
        (FLAGS NDESCBIT CONTBIT OPENBIT)
        (ACTION DRAWERS-F)>

<ROUTINE DRAWERS-F ()
         <COND (<VERB? EXAMINE LOOK-INSIDE>
                <TELL "The refrigeration units line both walls. Most drawers are empty or contain only bones. One drawer is slightly ajar, a faint luminescent glow emanating from within." CR>
                <RTRUE>)>>

<OBJECT DISSECTION-TABLE
        (IN MORGUE)
        (SYNONYM TABLE)
        (ADJECTIVE DISSECTION AUTOPSY)
        (DESC "dissection table")
        (LDESC "A metal table with drainage channels carved into its surface.")
        (FLAGS NDESCBIT SURFACEBIT)
        (ACTION DISTABLE-F)>

<ROUTINE DISTABLE-F ()
         <COND (<VERB? EXAMINE LOOK-INSIDE>
                <TELL "The dissection table is made of stainless steel with drainage channels carved into its surface. Dark stains pool in the grooves. A canvas-wrapped bundle lies upon it." CR>
                <RTRUE>)>>

<OBJECT CANVAS-BUNDLE
        (IN DISSECTION-TABLE)
        (SYNONYM BUNDLE CANVAS BODY CORPSE)
        (ADJECTIVE WRAPPED)
        (DESC "canvas bundle")
        (LDESC "A human-shaped bundle wrapped in stained canvas. You'd rather not investigate further.")
        (FLAGS TAKEBIT)
        (SIZE 50)
        (ACTION BUNDLE-F)>

<ROUTINE BUNDLE-F ()
         <COND (<VERB? EXAMINE>
                <TELL "A human-shaped bundle wrapped in stained canvas. The fabric is rotted and discolored. You'd rather not investigate further, though part of you wonders if this is Patient 237." CR>
                <RTRUE>)
               (<VERB? OPEN UNWRAP>
                <TELL "You have no desire to see what lies within. Some mysteries are better left undisturbed." CR>
                <RTRUE>)
               (<VERB? TAKE>
                <TELL "You can't bring yourself to touch it." CR>
                <RTRUE>)>>

<OBJECT MORDECAI-JOURNAL
        (IN MORGUE)
        (SYNONYM JOURNAL DIARY NOTEBOOK BOOK)
        (ADJECTIVE DOCTOR MORDECAI)
        (DESC "doctor's journal")
        (LDESC "Dr. Mordecai's personal journal. The final entry describes an experimental procedure that went terribly wrong. The handwriting becomes increasingly erratic.")
        (FLAGS READBIT TAKEBIT)
        (TEXT "The subject showed remarkable resilience. But the serum... it changed something fundamental. Patient 237 died on the table, yet I swear I saw movement hours later. I have made a terrible mistake. God forgive me, I must seal this place.")
        (SIZE 6)
        (ACTION JOURNAL-F)>

<ROUTINE JOURNAL-F ()
         <COND (<VERB? READ EXAMINE>
                <TELL "Dr. Mordecai's personal journal. The final entry is dated October 31, 1952. The handwriting becomes increasingly erratic: 'The subject showed remarkable resilience. But the serum... it changed something fundamental. Patient 237 died on the table, yet I swear I saw movement hours later. The eyes... the eyes opened. I have made a terrible mistake. God forgive me, I must seal this place.'" CR>
                <RTRUE>)>>

<OBJECT STRANGE-SERUM
        (IN REFRIGERATED-DRAWERS)
        (SYNONYM SERUM VIAL BOTTLE)
        (ADJECTIVE STRANGE GLOWING)
        (DESC "vial of serum")
        (LDESC "A glass vial containing luminescent liquid. The label reads 'Compound 237 - DO NOT USE'")
        (FLAGS TAKEBIT)
        (SIZE 4)
        (ACTION SERUM-F)>

<ROUTINE SERUM-F ()
         <COND (<VERB? EXAMINE>
                <TELL "A glass vial containing a faintly glowing liquid. The label reads 'Compound 237 - DO NOT USE'. The serum pulses with an unnatural light." CR>
                <RTRUE>)
               (<VERB? DRINK>
                <TELL "You bring the vial to your lips but your survival instinct stops you. This substance killed Patient 237. You lower the vial, hands trembling." CR>
                <RTRUE>)>>

<GLOBAL CHAINS-CUT-FLAG <>>
<ROUTINE GO ()
	<SETG HERE ,SANITARIUM-GATE>
	<THIS-IS-IT ,BRASS-PLAQUE>
	<COND (<NOT <FSET? ,HERE ,TOUCHBIT>>
	       <V-VERSION>
	       <CRLF>)>
	<SETG LIT T>
	<SETG WINNER ,ADVENTURER>
	<SETG PLAYER ,WINNER>
	<MOVE ,WINNER ,HERE>
      <V-LOOK>
      <MAIN-LOOP>
	<AGAIN>>