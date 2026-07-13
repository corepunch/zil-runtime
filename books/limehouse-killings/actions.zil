; === ACTION ROUTINES ===

; --- Evidence Object Actions ---

<ROUTINE DEAD-LETTER-F ()
    <COND (<VERB? EXAMINE READ>
           <TELL "The letter reads: 'My dear Dr. Moriarty, I know what you did. If you do not confess by Friday, I will expose you to Scotland Yard. - Lord Ashworth'" CR>
           <COND (<NOT ,DEAD-LETTER-FOUND>
                  <SETG DEAD-LETTER-FOUND T>
                  <SETG EVIDENCE-FOUND <+ ,EVIDENCE-FOUND 1>>)>
           <RTRUE>)>>

<ROUTINE BLOOD-STAINED-KNIFE-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The knife is stained with dried blood. It matches the surgical tools in Dr. Moriarty's office." CR>
           <COND (<NOT ,KNIFE-FOUND>
                  <SETG KNIFE-FOUND T>
                  <SETG EVIDENCE-FOUND <+ ,EVIDENCE-FOUND 1>>)>
           <RTRUE>)
          (<VERB? TAKE>
           <TELL "You take the knife carefully. This could be important." CR>
           <MOVE ,BLOOD-STAINED-KNIFE ,WINNER>
           <COND (<NOT ,KNIFE-FOUND>
                  <SETG KNIFE-FOUND T>
                  <SETG EVIDENCE-FOUND <+ ,EVIDENCE-FOUND 1>>)>
           <RTRUE>)>>

<ROUTINE LOCKED-BOX-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The locked box is small and ornate. It has a keyhole." CR>
           <RTRUE>)
          (<VERB? OPEN UNLOCK>
           <COND (<IN? ,KEYRING ,WINNER>
                  <TELL "You insert the key into the lock. It turns smoothly. The box slides open, revealing a bank statement inside." CR>
                  <SETG LOCKED-BOX-OPENED T>
                  <FSET ,LOCKED-BOX ,OPENBIT>
                  <MOVE ,BANK-STATEMENT ,LOCKED-BOX>
                  <RTRUE>)
                 (<IN? ,LOCKPICK-SET ,WINNER>
                  <TELL "You use the lockpick set on the locked box. It clicks open." CR>
                  <SETG LOCKED-BOX-OPENED T>
                  <FSET ,LOCKED-BOX ,OPENBIT>
                  <MOVE ,BANK-STATEMENT ,LOCKED-BOX>
                  <RTRUE>)
                 (T
                  <TELL "The box is locked. You need a key or lockpick." CR>
                  <RTRUE>)>)>>

<ROUTINE POISON-BOTTLE-F ()
    <COND (<VERB? EXAMINE READ>
           <TELL "The bottle is labeled: 'Aconitum - Wolfsbane. Highly poisonous.'" CR>
           <COND (<NOT ,POISON-BOTTLE-FOUND>
                  <SETG POISON-BOTTLE-FOUND T>
                  <SETG EVIDENCE-FOUND <+ ,EVIDENCE-FOUND 1>>)>
           <RTRUE>)
          (<VERB? TASTE>
           <TELL "You feel dizzy. Perhaps that wasn't wise." CR>
           <SETG PLAYER-HEALTH <- ,PLAYER-HEALTH 1>>
           <COND (<==? ,PLAYER-HEALTH 0>
                  <TELL "You collapse. Everything goes dark." CR>
                  <SETG GAME-LOST T>
                  <SETG GAME-ENDED T>
                  <QUIT>)>
           <RTRUE>)>>

<ROUTINE SECRET-LEDGER-F ()
    <COND (<VERB? EXAMINE READ>
           <TELL "The ledger shows Dr. Moriarty owed Lord Ashworth £500. The debt was due this week." CR>
           <COND (<NOT ,SECRET-LEDGER-FOUND>
                  <SETG SECRET-LEDGER-FOUND T>
                  <SETG EVIDENCE-FOUND <+ ,EVIDENCE-FOUND 1>>)>
           <RTRUE>)>>

; --- Tool Object Actions ---

<ROUTINE MAGNIFYING-GLASS-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A brass magnifying glass, its lens clear and strong." CR>
           <RTRUE>)
          (<VERB? TAKE>
           <TELL "You take the magnifying glass." CR>
           <MOVE ,MAGNIFYING-GLASS ,WINNER>
           <RTRUE>)
          (<VERB? USE>
           <TELL "You peer through the magnifying glass. It reveals fine details." CR>
           <RTRUE>)>>

<ROUTINE LOCKPICK-SET-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A set of metal picks, their tips worn from use." CR>
           <RTRUE>)
          (<VERB? TAKE>
           <TELL "You take the lockpick set." CR>
           <MOVE ,LOCKPICK-SET ,WINNER>
           <RTRUE>)
          (<VERB? USE>
           <TELL "You can use the lockpick set on locked objects." CR>
           <RTRUE>)>>

<ROUTINE LANTERN-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A brass lantern, its glass clouded with age." CR>
           <RTRUE>)
          (<VERB? TAKE>
           <TELL "You take the lantern." CR>
           <MOVE ,LANTERN ,WINNER>
           <RTRUE>)
          (<VERB? USE>
           <TELL "You light the lantern. It casts a warm glow." CR>
           <FSET ,LANTERN ,ONBIT>
           <RTRUE>)>>

<ROUTINE KEYRING-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A ring of keys, each one opening a different lock." CR>
           <RTRUE>)
          (<VERB? TAKE>
           <TELL "You take the keyring." CR>
           <MOVE ,KEYRING ,WINNER>
           <RTRUE>)>>

; --- Clue Object Actions ---

<ROUTINE TORN-PAGE-F ()
    <COND (<VERB? EXAMINE READ>
           <TELL "The page reads: 'Follow the rainbow order. Red, orange, yellow, green, blue, violet. Only then will the way open.'" CR>
           <RTRUE>)
          (<VERB? TAKE>
           <TELL "You take the torn page." CR>
           <MOVE ,TORN-PAGE ,WINNER>
           <RTRUE>)>>

<ROUTINE COLORED-MARKERS-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The markers are: RED on shelf 1, BLUE on shelf 3, GREEN on shelf 4, YELLOW on shelf 2." CR>
           <RTRUE>)>>

<ROUTINE CIPHER-BOOK-F ()
    <COND (<VERB? PUSH>
           <COND (,CIPHER-SOLVED
                  <TELL "The secret passage is already open." CR>)
                 (<AND <EQUAL? ,PRSO ,RED-BOOK> <==? ,CIPHER-STAGE 0>>
                  <SETG CIPHER-STAGE 1>
                  <TELL "The red-marked book clicks into place." CR>)
                 (<AND <EQUAL? ,PRSO ,BLUE-BOOK> <==? ,CIPHER-STAGE 1>>
                  <SETG CIPHER-STAGE 2>
                  <TELL "The blue-marked book clicks into place." CR>)
                 (<AND <EQUAL? ,PRSO ,GREEN-BOOK> <==? ,CIPHER-STAGE 2>>
                  <SETG CIPHER-STAGE 3>
                  <TELL "The green-marked book clicks into place." CR>)
                 (<AND <EQUAL? ,PRSO ,YELLOW-BOOK> <==? ,CIPHER-STAGE 3>>
                  <SOLVE-CIPHER>)
                 (T
                  <SETG CIPHER-STAGE 0>
                  <TELL "The book springs back. The sequence resets." CR>)>
           <RTRUE>)>>

<ROUTINE FOOTPRINT-CAST-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The cast shows a boot print size 10 - too large for Lady Ashworth." CR>
           <RTRUE>)
          (<VERB? TAKE>
           <TELL "You take the footprint cast." CR>
           <MOVE ,FOOTPRINT-CAST ,WINNER>
           <RTRUE>)>>

<ROUTINE WAX-SEAL-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The wax seal bears the initial 'M' - Moriarty." CR>
           <RTRUE>)
          (<VERB? TAKE>
           <TELL "You take the wax seal." CR>
           <MOVE ,WAX-SEAL ,WINNER>
           <RTRUE>)>>

<ROUTINE BANK-STATEMENT-F ()
    <COND (<VERB? EXAMINE READ>
           <TELL "The statement shows Dr. Moriarty's account is overdrawn. He recently withdrew a large sum for 'experimental supplies.'" CR>
           <COND (<NOT ,BANK-STATEMENT-FOUND>
                  <SETG BANK-STATEMENT-FOUND T>
                  <SETG EVIDENCE-FOUND <+ ,EVIDENCE-FOUND 1>>)>
           <RTRUE>)
          (<VERB? TAKE>
           <TELL "You take the bank statement." CR>
           <MOVE ,BANK-STATEMENT ,WINNER>
           <RTRUE>)>>

; --- Furniture/Scenery Actions ---

<ROUTINE DESK-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The mahogany desk has three drawers. The top two are broken and empty. The bottom drawer is intact but locked." CR>
           <RTRUE>)>>

<ROUTINE FIREPLACE-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The fireplace contains cold ashes and a locked box." CR>
           <RTRUE>)>>

<ROUTINE WINDOW-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The window is old, with a rusty latch. It looks out to the garden." CR>
           <RTRUE>)
          (<VERB? OPEN UNLOCK>
           <COND (<IN? ,LOCKPICK-SET ,WINNER>
                  <TELL "You use the lockpick set on the window latch. It clicks open." CR>
                  <SETG STUDY-UNLOCKED T>
                  <RTRUE>)
                 (T
                  <TELL "The window latch is rusted. You need a tool to open it." CR>
                  <RTRUE>)>)>>

<ROUTINE BOOKSHELF-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The bookshelf is arranged by color. Red, blue, green, and yellow markers are visible on different shelves." CR>
           <RTRUE>)
          (<VERB? PUSH>
           <COND (,CIPHER-SOLVED
                  <TELL "The bookshelf is already solved." CR>
                  <RTRUE>)
                 (T
                  <TELL "You push a book. Nothing happens. Perhaps there's an order to follow." CR>
                  <RTRUE>)>)>>

<ROUTINE READING-DESK-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A reading desk with a torn page lying on it." CR>
           <RTRUE>)>>

<ROUTINE TABLE-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The dining table is set for two, but only one place was used. A wax seal lies near the empty plate." CR>
           <RTRUE>)>>

<ROUTINE WINE-CABINET-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The wine cabinet is locked. It contains fine wines and spirits." CR>
           <RTRUE>)
          (<VERB? OPEN UNLOCK>
           <TELL "The wine cabinet is locked. You don't have the key." CR>
           <RTRUE>)>>

<ROUTINE POTS-F ()
    <COND (<VERB? EXAMINE>
           <TELL "Copper pots hang from the ceiling, tarnished with age." CR>
           <RTRUE>)>>

<ROUTINE HEARTH-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The hearth is cold, with ashes from yesterday's fire." CR>
           <RTRUE>)>>

<ROUTINE SERVANT-BELL-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A servant bell hangs from the wall. A rope leads up to the servant's quarters." CR>
           <RTRUE>)
          (<VERB? PULL USE>
           <TELL "You pull the bell rope. A distant bell rings upstairs." CR>
           <RTRUE>)>>

<ROUTINE DRAWER-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The drawer is slightly open. You can see something inside." CR>
           <RTRUE>)
          (<VERB? OPEN>
           <TELL "You open the drawer. Inside is a lockpick set." CR>
           <FSET ,DRAWER ,OPENBIT>
           <MOVE ,LOCKPICK-SET ,DRAWER>
           <RTRUE>)>>

<ROUTINE FOUNTAIN-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The fountain is dry, with coins at the bottom. A footprint cast lies nearby." CR>
           <RTRUE>)>>

<ROUTINE HEDGES-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The hedge is thick and overgrown. Something glints in the branches." CR>
           <RTRUE>)>>

<ROUTINE PLANTS-F ()
    <COND (<VERB? EXAMINE>
           <TELL "Exotic plants fill the greenhouse. One plant has distinctive purple flowers - wolfsbane." CR>
           <RTRUE>)>>

<ROUTINE LABELS-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The labels read: 'Aconitum - Wolfsbane' on the purple plant. 'Digitalis - Foxglove' on another." CR>
           <RTRUE>)>>

<ROUTINE BENCH-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A wooden potting bench, its surface covered in soil and tools." CR>
           <RTRUE>)>>

<ROUTINE BEDS-F ()
    <COND (<VERB? EXAMINE>
           <TELL "Simple beds for the household staff. They are empty." CR>
           <RTRUE>)>>

<ROUTINE TRUNK-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A large trunk contains servant uniforms and a letter." CR>
           <RTRUE>)>>

<ROUTINE UNIFORMS-F ()
    <COND (<VERB? EXAMINE>
           <TELL "Servant uniforms, their fabric worn from use." CR>
           <RTRUE>)>>

<ROUTINE SHELVES-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The shelves hold canned goods, spices, and a bottle of antidote ingredients." CR>
           <RTRUE>)>>

<ROUTINE FOXGLOVE-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A bottle of foxglove, its label faded but legible. An antidote ingredient." CR>
           <RTRUE>)
          (<VERB? TAKE>
           <TELL "You take the foxglove." CR>
           <MOVE ,FOXGLOVE ,WINNER>
           <RTRUE>)>>

<ROUTINE CHARCOAL-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A container of charcoal, used for filtering poisons. An antidote ingredient." CR>
           <RTRUE>)
          (<VERB? TAKE>
           <TELL "You take the charcoal." CR>
           <MOVE ,CHARCOAL ,WINNER>
           <RTRUE>)>>

; --- Room Action Routines (Dynamic Descriptions) ---

<ROUTINE STUDY-FCN (RARG)
    <COND (<EQUAL? .RARG ,M-LOOK>
           <TELL "The study is a crime scene. A chalk outline marks where the body lay, the victim struck down in this very room. The air hangs heavy with the memory of violence.">
           <COND (,LOCKED-BOX-OPENED
                  <TELL " The locked box in the fireplace lies open, its contents revealed.">)
                 (T
                  <TELL " A small locked box sits among the cold ashes in the fireplace.">)>
           <COND (<FSET? ,WINDOW ,OPENBIT>
                  <TELL " The window stands open, letting in the chill night air.">)
                 (T
                  <TELL " A window looks out to the garden, its latch rusted but intact.">)>
           <TELL CR "A doorway leads north back to the entrance hall." CR>)>>

<ROUTINE LIBRARY-FCN (RARG)
    <COND (<EQUAL? .RARG ,M-LOOK>
           <TELL "Floor-to-ceiling bookshelves line the walls, their contents ranging from leather-bound classics to modern scientific texts. The fire is cold, but the room retains a scholarly warmth.">
           <COND (,CIPHER-SOLVED
                  <TELL " A secret passage lies open to the east, its dark mouth beckoning.">)
                 (T
                  <TELL " A doorway leads west back to the entrance hall.">)>
           <CRLF>)>>

<ROUTINE KITCHEN-FCN (RARG)
    <COND (<EQUAL? .RARG ,M-LOOK>
           <TELL "A kitchen that has seen better days. The hearth is cold, its last fire long extinguished.">
           <COND (<FSET? ,DRAWER ,OPENBIT>
                  <TELL " The drawer in the counter stands open.">)
                 (T
                  <TELL " A drawer in the counter is slightly ajar.">)>
           <TELL CR "A staircase leads up to the entrance hall, and a doorway west leads to the garden." CR>)>>

<ROUTINE GARDEN-FCN (RARG)
    <COND (<EQUAL? .RARG ,M-LOOK>
           <TELL "An overgrown garden sprawls before you, its paths choked with weeds. A fountain stands at the center, dry and silent. Hedge mazes line the paths, their shadows hiding secrets.">
           <COND (<IN? ,BLOOD-STAINED-KNIFE ,GARDEN>
                  <TELL " Something glints in the branches near the fountain.">)>
           <TELL CR "A doorway east leads to the kitchen, paths lead north to the greenhouse and south to the servants' quarters." CR>)>>

<ROUTINE ENTRANCE-HALL-FCN (RARG)
    <COND (<EQUAL? .RARG ,M-LOOK>
           <TELL "You step into a grand foyer that has seen better days. The air is thick with the scent of old wood and regret. Doorways lead in every direction -- north to the gate, east to the library, west to the dining room, and a staircase down to the kitchen.">
           <COND (,STUDY-UNLOCKED
                  <TELL " The door to the south stands open, revealing the study beyond.">)
                 (T
                  <TELL " A door to the south stands locked.">)>
           <CRLF>)>>

; --- Global Object Actions ---

<ROUTINE FOG-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The fog swirls around your feet, cold and damp." CR>
           <RTRUE>)>>

<ROUTINE GATES-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The iron gates are rusted but still sturdy. They stand open." CR>
           <RTRUE>)>>

<ROUTINE PATH-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The gravel path leads north to the manor house." CR>
           <RTRUE>)>>

<ROUTINE CHANDELIER-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The chandelier hangs from the ceiling, its crystals dull with dust." CR>
           <RTRUE>)>>

<ROUTINE PORTRAITS-F ()
    <COND (<VERB? EXAMINE>
           <TELL "Portraits of the Ashworth family line the walls. Their expressions are disapproving." CR>
           <RTRUE>)>>

<ROUTINE RUG-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A Persian rug covers the floor, its patterns faded but still elegant." CR>
           <RTRUE>)>>

<ROUTINE CHALK-OUTLINE-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A chalk outline marks where the body was found. The victim was struck from behind, then poisoned." CR>
           <RTRUE>)>>

; === NPC ACTIONS ===

<ROUTINE MR-HUDSON-F ()
    <COND (<VERB? EXAMINE>
           <TELL "Mr. Hudson, the butler, stands nervously. His expression is troubled." CR>
           <RTRUE>)
          (<VERB? ASK TELL>
           <COND (<EQUAL? ,PRSI ,MASTER-TOPIC>
                  <TELL "Lord Ashworth had enemies, sir. Dr. Moriarty visited often, and their arguments grew worse." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSI ,ALIBI-TOPIC>
                  <TELL "I was in the servants' quarters all evening. The other staff can confirm it." CR>
                  <COND (<NOT ,HUDSON-INTERVIEWED>
                         <SETG HUDSON-INTERVIEWED T>
                         <SETG SUSPECTS-INTERVIEWED <+ ,SUSPECTS-INTERVIEWED 1>>)>
                  <RTRUE>)
                 (<EQUAL? ,PRSI ,KEY-TOPIC>
                  <TELL "You'll need the study key. He hands you the keyring." CR>
                  <COND (<NOT ,HUDSON-KEY-GIVEN>
                         <SETG HUDSON-KEY-GIVEN T>
                         <MOVE ,KEYRING ,WINNER>)>
                  <SETG STUDY-UNLOCKED T>
                  <RTRUE>)
                 (<EQUAL? ,PRSI ,MORIARTY-TOPIC>
                  <TELL "Dr. Moriarty visited often. He and the master had serious disagreements." CR>
                  <RTRUE>)
                 (<OR <IN? ,PRSO ,INTQUOTE> <IN? ,PRSO ,QUOTE>>
                  <TELL "I'm not sure what you mean." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,ROOMS>
                  <TELL "I'm in the servants' quarters." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,MR-HUDSON>
                  <TELL "Yes? What is it?" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,LADY-ASHWORTH>
                  <TELL "Lady Ashworth? She was in the drawing room, I believe." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,DR-MORIARTY>
                  <TELL "Dr. Moriarty? He visited often. He and the master had... disagreements." CR>
                   <SETG MORIARTY-INTERVIEWED T>
                   <SETG SUSPECTS-INTERVIEWED <+ ,SUSPECTS-INTERVIEWED 1>>
                   <RTRUE>)
                 (<EQUAL? ,PRSO ,DEAD-LETTER>
                  <TELL "A letter? I know nothing of such things." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,BLOOD-STAINED-KNIFE>
                  <TELL "A knife? I don't recognize it." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,POISON-BOTTLE>
                  <TELL "Poison? I would never touch such things." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,KEYRING>
                  <TELL "The keyring? I suppose you'll need this." <COND (,HUDSON-KEY-GIVEN
                                                                          " You already have it.")
                                                                         (T
                                                                          <SETG HUDSON-KEY-GIVEN T>
                                                                          <MOVE ,KEYRING ,WINNER>
                                                                          " He hands you the keyring.")> CR>
                  <RTRUE>)
                 (T
                  <TELL "I don't know anything about that." CR>
                  <RTRUE>)>)
          (<VERB? TELL>
           <COND (<EQUAL? ,PRSO ,MR-HUDSON>
                  <TELL "Yes? What is it?" CR>
                  <RTRUE>)
                 (T
                  <TELL "I'm not sure I understand." CR>
                  <RTRUE>)>)
          (<VERB? SHOW>
           <COND (<EQUAL? ,PRSO ,DEAD-LETTER>
                  <TELL "Mr. Hudson reads the letter. 'Where did you get that?' he asks, his face pale." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,BLOOD-STAINED-KNIFE>
                  <TELL "Mr. Hudson recoils. 'I've never seen that before.'" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,POISON-BOTTLE>
                  <TELL "Mr. Hudson's eyes widen. 'Poison? I know nothing of poison.'" CR>
                  <RTRUE>)
                 (T
                  <TELL "Mr. Hudson examines the item. 'I don't see how that's relevant.'" CR>
                  <RTRUE>)>)>>

<ROUTINE LADY-ASHWORTH-F ()
    <COND (<VERB? EXAMINE>
           <TELL "Lady Ashworth sits at the dining table, her expression cold and calculating." CR>
           <RTRUE>)
          (<VERB? ASK TELL>
           <COND (<EQUAL? ,PRSI ,MARRIAGE-TOPIC>
                  <TELL "Our marriage was difficult, but I did not kill my husband." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSI ,ALIBI-TOPIC>
                  <TELL "I was in the drawing room all evening. The servants saw me there." CR>
                  <SETG LADY-ALIBI-CLAIMED T>
                  <COND (<NOT ,LADY-INTERVIEWED>
                         <SETG LADY-INTERVIEWED T>
                         <SETG SUSPECTS-INTERVIEWED <+ ,SUSPECTS-INTERVIEWED 1>>)>
                  <RTRUE>)
                 (<OR <IN? ,PRSO ,INTQUOTE> <IN? ,PRSO ,QUOTE>>
                  <TELL "I'm not sure what you mean." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,ROOMS>
                  <TELL "I was in the drawing room all evening." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,LADY-ASHWORTH>
                  <TELL "Yes? What is it?" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,DR-MORIARTY>
                  <TELL "Dr. Moriarty was a frequent guest. My husband owed him money." CR>
                   <SETG MORIARTY-INTERVIEWED T>
                   <SETG SUSPECTS-INTERVIEWED <+ ,SUSPECTS-INTERVIEWED 1>>
                   <RTRUE>)
                 (<EQUAL? ,PRSO ,MR-HUDSON>
                  <TELL "Mr. Hudson? He's been with the household for years. Loyal, but nervous." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,DEAD-LETTER>
                  <TELL "A letter? Where did you get that?" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,BLOOD-STAINED-KNIFE>
                  <TELL "A knife? I don't know anything about it." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,POISON-BOTTLE>
                  <TELL "Poison? I know nothing of such things." CR>
                  <RTRUE>)
                 (T
                  <TELL "I don't know anything about that." CR>
                  <RTRUE>)>)
          (<VERB? TELL>
           <COND (<EQUAL? ,PRSO ,LADY-ASHWORTH>
                  <TELL "Yes? What is it?" CR>
                  <RTRUE>)
                 (T
                  <TELL "I'm not sure I understand." CR>
                  <RTRUE>)>)
          (<VERB? SHOW>
           <COND (<EQUAL? ,PRSO ,DEAD-LETTER>
                  <TELL "Lady Ashworth reads the letter. 'Where did you get that?' she asks, her composure cracking." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,BLOOD-STAINED-KNIFE>
                  <TELL "Lady Ashworth recoils. 'I've never seen that before.'" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,POISON-BOTTLE>
                  <TELL "Lady Ashworth's eyes widen. 'Poison? I know nothing of poison.'" CR>
                  <RTRUE>)
                 (T
                  <TELL "Lady Ashworth examines the item. 'I don't see how that's relevant.'" CR>
                  <RTRUE>)>)>>

<ROUTINE DR-MORIARTY-F ()
    <COND (<VERB? EXAMINE>
           <TELL "Dr. Moriarty stands by the bookshelf, his expression arrogant and dismissive." CR>
           <RTRUE>)
          (<VERB? ASK TELL>
           <COND (<EQUAL? ,PRSI ,EXPERIMENTS-TOPIC>
                  <TELL "My experiments concern medicinal plants. Lord Ashworth financed some of the work." CR>
                  <RTRUE>)
                 (<OR <EQUAL? ,PRSI ,POISON-TOPIC>
                      <EQUAL? ,PRSI ,POISON-BOTTLE>>
                  <TELL "Wolfsbane? Aconitum? I keep some for research. That proves nothing." CR>
                  <SETG MORIARTY-POISON-KNOWN T>
                  <COND (<NOT ,MORIARTY-INTERVIEWED>
                         <SETG MORIARTY-INTERVIEWED T>
                         <SETG SUSPECTS-INTERVIEWED <+ ,SUSPECTS-INTERVIEWED 1>>)>
                  <MOVE ,DR-MORIARTY ,ASHWORTH-ENTRANCE-HALL>
                  <RTRUE>)
                 (<OR <IN? ,PRSO ,INTQUOTE> <IN? ,PRSO ,QUOTE>>
                  <TELL "I'm not sure what you mean." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,ROOMS>
                  <TELL "I was at my laboratory all evening. Ask my assistant." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,DR-MORIARTY>
                  <TELL "Yes? What is it?" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,LADY-ASHWORTH>
                  <TELL "Lady Ashworth? She's a fine woman, trapped in a difficult marriage." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,MR-HUDSON>
                  <TELL "Mr. Hudson? He's a servant. What about him?" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,DEAD-LETTER>
                  <TELL "A letter? I don't know anything about it." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,BLOOD-STAINED-KNIFE>
                  <TELL "A knife? I use surgical tools in my work. That's not one of them." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,POISON-BOTTLE>
                  <TELL "Wolfsbane? Aconitum? I have some in my greenhouse. For research." CR>
                   <SETG MORIARTY-POISON-KNOWN T>
                   <RTRUE>)
                 (<EQUAL? ,PRSO ,SECRET-LEDGER>
                  <TELL "A ledger? I don't know what you're talking about." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,BANK-STATEMENT>
                  <TELL "A bank statement? That's private information." CR>
                  <RTRUE>)
                 (T
                  <TELL "I don't know anything about that." CR>
                  <RTRUE>)>)
          (<VERB? TELL>
           <COND (<EQUAL? ,PRSO ,DR-MORIARTY>
                  <TELL "Yes? What is it?" CR>
                  <RTRUE>)
                 (T
                  <TELL "I'm not sure I understand." CR>
                  <RTRUE>)>)
          (<VERB? SHOW>
           <COND (<EQUAL? ,PRSO ,DEAD-LETTER>
                  <TELL "Dr. Moriarty reads the letter. 'Where did you get that?' he asks, his composure cracking." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,BLOOD-STAINED-KNIFE>
                  <TELL "Dr. Moriarty recoils. 'I've never seen that before.'" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,POISON-BOTTLE>
                  <TELL "Dr. Moriarty's eyes widen. 'That's my research. How did you get it?'" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,SECRET-LEDGER>
                  <TELL "Dr. Moriarty reads the ledger. 'Where did you find that?'" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,BANK-STATEMENT>
                  <TELL "Dr. Moriarty reads the statement. 'That's private information!'" CR>
                  <RTRUE>)
                 (T
                  <TELL "Dr. Moriarty examines the item. 'I don't see how that's relevant.'" CR>
                  <RTRUE>)>)>>

<ROUTINE INSPECTOR-F ()
    <COND (<VERB? EXAMINE>
           <TELL "Inspector Lestrade of Scotland Yard stands in the entrance hall, his expression professional and skeptical." CR>
           <RTRUE>)
          (<VERB? ASK TELL>
           <COND (<EQUAL? ,PRSI ,CASE-TOPIC>
                  <TELL "Bring me five solid pieces of evidence and interview all three suspects. Then make your accusation." CR>
                  <RTRUE>)
                 (<OR <IN? ,PRSO ,INTQUOTE> <IN? ,PRSO ,QUOTE>>
                  <TELL "I'm not sure what you mean." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,ROOMS>
                  <TELL "What have you found, detective?" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,INSPECTOR>
                  <TELL "Yes? What is it?" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,DR-MORIARTY>
                  <TELL "Dr. Moriarty? A respected scientist. You'll need strong evidence." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,LADY-ASHWORTH>
                  <TELL "Lady Ashworth? She has an alibi. What evidence do you have?" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,MR-HUDSON>
                  <TELL "Mr. Hudson? He was in the servants' quarters. What evidence do you have?" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,DEAD-LETTER>
                  <TELL "A letter? Let me see it." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,BLOOD-STAINED-KNIFE>
                  <TELL "A knife? Let me see it." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,POISON-BOTTLE>
                  <TELL "Poison? Let me see it." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,SECRET-LEDGER>
                  <TELL "A ledger? Let me see it." CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,BANK-STATEMENT>
                  <TELL "A bank statement? Let me see it." CR>
                  <RTRUE>)
                 (T
                  <TELL "I don't know anything about that." CR>
                  <RTRUE>)>)
          (<VERB? TELL>
           <COND (<EQUAL? ,PRSO ,INSPECTOR>
                  <TELL "Yes? What is it?" CR>
                  <RTRUE>)
                 (T
                  <TELL "I'm not sure I understand." CR>
                  <RTRUE>)>)
          (<VERB? SHOW>
           <COND (<EQUAL? ,PRSO ,DEAD-LETTER>
                  <TELL "The inspector reads the letter. 'This is damning evidence.'" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,BLOOD-STAINED-KNIFE>
                  <TELL "The inspector examines the knife. 'The knife matches the wound. And it's from Moriarty's collection.'" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,POISON-BOTTLE>
                  <TELL "The inspector reads the label. 'Wolfsbane. Rare poison. Only Moriarty had access.'" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,SECRET-LEDGER>
                  <TELL "The inspector reads the ledger. 'And the ledger shows he was being blackmailed. Case closed.'" CR>
                  <RTRUE>)
                 (<EQUAL? ,PRSO ,BANK-STATEMENT>
                  <TELL "The inspector reads the statement. 'Moriarty owed the victim money. Motive established.'" CR>
                  <RTRUE>)
                 (T
                  <TELL "The inspector examines the item. 'I don't see how that's relevant.'" CR>
                  <RTRUE>)>)>>

; === VERB ACTIONS ===

<ROUTINE V-EXAMINE ()
    <COND (<FSET? ,PRSO ,SCENERY>
           <PERFORM ,V?EXAMINE ,PRSO>
           <RTRUE>)
          (<FSET? ,PRSO ,NPC>
           <PERFORM ,V?EXAMINE ,PRSO>
           <RTRUE>)
          (T
           <TELL "You examine the " D ,PRSO ". " <GETP ,PRSO ,P?LDESC> CR>
           <RTRUE>)>>

<ROUTINE V-READ ()
    <COND (<FSET? ,PRSO ,READBIT>
           <PERFORM ,V?READ ,PRSO>
           <RTRUE>)
          (T
           <TELL "You can't read that." CR>
           <RTRUE>)>>

<ROUTINE V-TAKE ()
    <COND (<FSET? ,PRSO ,TAKEBIT>
           <MOVE ,PRSO ,WINNER>
           <TELL "You take the " D ,PRSO "." CR>
           <RTRUE>)
          (T
           <TELL "You can't take that." CR>
           <RTRUE>)>>

<ROUTINE V-DROP ()
    <COND (<IN? ,PRSO ,WINNER>
           <MOVE ,PRSO ,HERE>
           <TELL "You drop the " D ,PRSO "." CR>
           <RTRUE>)
          (T
           <TELL "You don't have that." CR>
           <RTRUE>)>>

<ROUTINE V-USE ()
    <TELL "You can't use that here." CR>
    <RTRUE>>

<ROUTINE V-USE-ON ()
    <TELL "You can't use that on that." CR>
    <RTRUE>>

<ROUTINE V-OPEN ()
    <COND (<FSET? ,PRSO ,CONTAINERBIT>
           <PERFORM ,V?OPEN ,PRSO>
           <RTRUE>)
          (T
           <TELL "You can't open that." CR>
           <RTRUE>)>>

<ROUTINE V-CLOSE ()
    <COND (<FSET? ,PRSO ,CONTAINERBIT>
           <PERFORM ,V?CLOSE ,PRSO>
           <RTRUE>)
          (T
           <TELL "You can't close that." CR>
           <RTRUE>)>>

<ROUTINE V-PUSH ()
    <COND (<EQUAL? ,PRSO ,BOOKSHELF>
           <PERFORM ,V?PUSH ,BOOKSHELF>
           <RTRUE>)
          (T
           <TELL "You can't push that." CR>
           <RTRUE>)>>

<ROUTINE V-ASK ()
    <PERFORM ,V?ASK ,PRSO ,PRSI>
    <RTRUE>>

<ROUTINE V-TELL ()
    <PERFORM ,V?TELL ,PRSO ,PRSI>
    <RTRUE>>

<ROUTINE V-SHOW-TO ()
    <PERFORM ,V?SHOW ,PRSI ,PRSO>
    <RTRUE>>

<ROUTINE V-ACCUSE ()
    <COND (<EQUAL? ,PRSO ,DR-MORIARTY>
           <COND (<AND <==? ,EVIDENCE-FOUND 5>
                       <==? ,SUSPECTS-INTERVIEWED 3>>
                  <TELL "Dr. Moriarty, you are under arrest for the murder of Lord Ashworth." CR>
                  <SETG KILLER-ACCUSED T>
                  <SETG CORRECT-ACCUSATION T>
                  <SETG GAME-WON T>
                  <SETG GAME-ENDED T>
                  <TELL CR "Congratulations! You have solved the murder of Lord Ashworth." CR>
                  <TELL "Dr. Moriarty has been arrested for the crime." CR>
                  <TELL "Your reputation as a detective is secured." CR>
                  <QUIT>)
                 (T
                  <TELL "You don't have enough evidence to make that accusation." CR>
                  <RTRUE>)>)
          (<EQUAL? ,PRSO ,LADY-ASHWORTH>
           <TELL "Lady Ashworth has an alibi. The evidence doesn't match." CR>
           <SETG WRONG-ATTEMPTS <+ ,WRONG-ATTEMPTS 1>>
           <RTRUE>)
          (<EQUAL? ,PRSO ,MR-HUDSON>
           <TELL "Mr. Hudson was in servants' quarters. The knife isn't his." CR>
           <SETG WRONG-ATTEMPTS <+ ,WRONG-ATTEMPTS 1>>
           <RTRUE>)
          (T
           <TELL "You must name a specific suspect." CR>
           <RTRUE>)>>

<ROUTINE V-GO-NORTH ()
    <COND (<==? ,HERE ,ASHWORTH-MANOR-GATE>
           <SETG HERE ,ASHWORTH-ENTRANCE-HALL>
           <TELL "You enter the manor." CR>
           <RTRUE>)
          (<==? ,HERE ,ASHWORTH-ENTRANCE-HALL>
           <SETG HERE ,ASHWORTH-MANOR-GATE>
           <TELL "You leave the manor." CR>
           <RTRUE>)
          (<==? ,HERE ,GARDEN>
           <SETG HERE ,GREENHOUSE>
           <TELL "You enter the greenhouse." CR>
           <RTRUE>)
          (<==? ,HERE ,SERVANTS-QUARTERS>
           <SETG HERE ,GARDEN>
           <TELL "You return to the garden." CR>
           <RTRUE>)
          (T
           <TELL "You can't go that way." CR>
           <RTRUE>)>>

<ROUTINE V-GO-SOUTH ()
    <COND (<==? ,HERE ,ASHWORTH-ENTRANCE-HALL>
           <COND (,STUDY-UNLOCKED
                  <SETG HERE ,STUDY>
                  <TELL "You enter the study." CR>
                  <RTRUE>)
                 (T
                  <TELL "The study door is locked." CR>
                  <RTRUE>)>)
          (<==? ,HERE ,GARDEN>
           <SETG HERE ,SERVANTS-QUARTERS>
           <TELL "You enter the servants' quarters." CR>
           <RTRUE>)
          (<==? ,HERE ,GREENHOUSE>
           <SETG HERE ,GARDEN>
           <TELL "You return to the garden." CR>
           <RTRUE>)
          (<==? ,HERE ,LIBRARY>
           <SETG HERE ,SECRET-PASSAGE>
           <TELL "You enter the secret passage." CR>
           <RTRUE>)
          (T
           <TELL "You can't go that way." CR>
           <RTRUE>)>>

<ROUTINE V-GO-EAST ()
    <COND (<==? ,HERE ,ASHWORTH-ENTRANCE-HALL>
           <SETG HERE ,LIBRARY>
           <TELL "You enter the library." CR>
           <RTRUE>)
          (<==? ,HERE ,DINING-ROOM>
           <SETG HERE ,ASHWORTH-ENTRANCE-HALL>
           <TELL "You return to the entrance hall." CR>
           <RTRUE>)
          (<==? ,HERE ,KITCHEN>
           <SETG HERE ,GARDEN>
           <TELL "You enter the garden." CR>
           <RTRUE>)
          (<==? ,HERE ,SECRET-PASSAGE>
           <SETG HERE ,STUDY>
           <TELL "You enter the study." CR>
           <RTRUE>)
          (T
           <TELL "You can't go that way." CR>
           <RTRUE>)>>

<ROUTINE V-GO-WEST ()
    <COND (<==? ,HERE ,ASHWORTH-ENTRANCE-HALL>
           <SETG HERE ,DINING-ROOM>
           <TELL "You enter the dining room." CR>
           <RTRUE>)
          (<==? ,HERE ,LIBRARY>
           <SETG HERE ,ASHWORTH-ENTRANCE-HALL>
           <TELL "You return to the entrance hall." CR>
           <RTRUE>)
          (<==? ,HERE ,KITCHEN>
           <SETG HERE ,GARDEN>
           <TELL "You enter the garden." CR>
           <RTRUE>)
          (<==? ,HERE ,SECRET-PASSAGE>
           <SETG HERE ,LIBRARY>
           <TELL "You enter the library." CR>
           <RTRUE>)
          (T
           <TELL "You can't go that way." CR>
           <RTRUE>)>>

<ROUTINE V-GO-UP ()
    <COND (<==? ,HERE ,KITCHEN>
           <SETG HERE ,ASHWORTH-ENTRANCE-HALL>
           <TELL "You return to the entrance hall." CR>
           <RTRUE>)
          (T
           <TELL "You can't go that way." CR>
           <RTRUE>)>>

<ROUTINE V-GO-DOWN ()
    <COND (<==? ,HERE ,ASHWORTH-ENTRANCE-HALL>
           <SETG HERE ,KITCHEN>
           <TELL "You enter the kitchen." CR>
           <RTRUE>)
          (T
           <TELL "You can't go that way." CR>
           <RTRUE>)>>

<ROUTINE V-INVENTORY ()
    <TELL "You are carrying:" CR>
    <COND (<FIRST? ,WINNER>
           <PRINT-CONTENTS ,WINNER>
           <RTRUE>)
          (T
           <TELL "  nothing." CR>
           <RTRUE>)>>

<ROUTINE V-SCORE ()
    <TELL "Evidence found: " N ,EVIDENCE-FOUND " of 5." CR>
    <TELL "Suspects interviewed: " N ,SUSPECTS-INTERVIEWED " of 3." CR>
    <RTRUE>>

<ROUTINE V-HINTS ()
    <TELL "Hints are available. Type HINTS for help." CR>
    <RTRUE>>

; === HELPER ROUTINES ===

<ROUTINE PRINT-CONTENTS (OBJ)
    <COND (<FIRST? OBJ>
           <PRINT-ITEMS OBJ>
           <RTRUE>)
          (T
           <TELL "  nothing." CR>
           <RTRUE>)>>

<ROUTINE PRINT-ITEMS (OBJ)
    <COND (<FIRST? OBJ>
           <TELL "  " D <FIRST? OBJ> CR>
           <PRINT-ITEMS <NEXT? <FIRST? OBJ>>>
           <RTRUE>)>>

; === GLOBAL OBJECT ACTIONS ===

<OBJECT INTQUOTE
      (IN GLOBAL-OBJECTS)
      (DESC "quotation")
      (SYNONYM QUOTE QUOTATION)
      (FLAGS ARTICLEBIT)>

<OBJECT QUOTE
      (IN GLOBAL-OBJECTS)
      (DESC "quotation")
      (SYNONYM QUOTATION)
      (FLAGS ARTICLEBIT)>

<OBJECT GLOBAL-OBJECTS
      (IN GLOBAL-OBJECTS)
      (DESC "global objects")
      (FLAGS INVISIBLE)>

; === PUZZLE LOGIC ===

<ROUTINE SOLVE-CIPHER ()
    <COND (<AND <IN? ,TORN-PAGE ,WINNER>
                <==? ,HERE ,LIBRARY>>
           <TELL "You arrange the books in rainbow order. The wall slides open, revealing a secret passage." CR>
           <SETG CIPHER-SOLVED T>
           <SETG SECRET-PASSAGE-FOUND T>
           <SETG SECRET-PASSAGE-OPEN T>
           <RTRUE>)
          (T
           <TELL "You need the torn page and colored markers to solve the cipher." CR>
           <RTRUE>)>>

<ROUTINE IDENTIFY-POISON ()
    <COND (<AND <IN? ,POISON-BOTTLE ,WINNER>
                <IN? ,PLANTS ,HERE>>
           <TELL "You match the poison bottle label to the wolfsbane plant. The poison came from this greenhouse." CR>
           <SETG POISON-IDENTIFIED T>
           <RTRUE>)
          (T
           <TELL "You need the poison bottle and access to the greenhouse to identify the poison." CR>
           <RTRUE>)>>

; === END GAME ===

<ROUTINE END-GAME ()
    <COND (,GAME-WON
           <TELL CR "Congratulations! You have solved the murder of Lord Ashworth." CR>
           <TELL "Dr. Moriarty has been arrested for the crime." CR>
           <TELL "Your reputation as a detective is secured." CR>
           <QUIT>)
          (,GAME-LOST
           <TELL CR "The case remains unsolved. Better luck next time." CR>
           <QUIT>)
           (T
            <RTRUE>)>>

; === GAME ENTRY ===

<SYNTAX ACCUSE OBJECT (FIND ACTORBIT) (IN-ROOM) = V-ACCUSE>

<ROUTINE GO ()
	<SETG HERE ,ASHWORTH-MANOR-GATE>
	<SETG LIT T>
	<SETG WINNER ,ADVENTURER>
	<SETG PLAYER ,WINNER>
	<MOVE ,WINNER ,HERE>
	<V-LOOK>
	<MAIN-LOOP>>
