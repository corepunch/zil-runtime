; === CUSTOM SYNTAX ===

<SYNTAX WIND OBJECT = V-WIND>
<SYNTAX WIND OBJECT WITH OBJECT = V-WIND>
<SYNTAX LUBRICATE OBJECT = V-OIL>
<SYNTAX LUBRICATE OBJECT WITH OBJECT = V-OIL>
<SYNTAX HINT = V-HINTS>
<SYNONYM HINT HINTS>

<ROUTINE V-SCORE ()
    <TELL "You have no score in this game. The magic is what matters." CR>
    <RTRUE>>

; === ENTRY POINT ===

<ROUTINE GO ()
    <SETG HERE ,WORKSHOP-FLOOR>
    <THIS-IS-IT ,KEY-HOOK>
    <SETG LIT T>
    <SETG WINNER ,ADVENTURER>
    <SETG PLAYER ,WINNER>
    <MOVE ,WINNER ,HERE>
    <ENABLE <QUEUE I-TICK 1>>
    <ENABLE <QUEUE I-DAWN-WARNING 25>>
    <ENABLE <QUEUE I-NUTMEG-AUTONOMY 8>>
    <V-LOOK>
    <MAIN-LOOP>
    <AGAIN>>

; === CLOCK DAEMONS ===

<ROUTINE I-TICK ()
    <QUEUE I-TICK 1>
    <COND (,GAME-WON <RTRUE>)>
    <COND (<L? ,TICK-COUNT 1>
           <TELL "The sun rises over Wrenfold. The last tick fades into silence. The magic is gone. The workshop is still. You are alone -- but you tried, Pip. You tried." CR>
           <SETG TICK-COUNT 0>
           <JIGS-UP "The dawn has come, and the toys have fallen silent forever.">)
          (T
           <SETG TICK-COUNT <- ,TICK-COUNT 1>>)>
    <RTRUE>>

<ROUTINE I-DAWN-WARNING ()
    <QUEUE I-DAWN-WARNING 25>
    <COND (,GAME-WON <RTRUE>)>
    <COND (<L? ,TICK-COUNT 6>
           <TELL "Sunlight touches the rooftops through the window. You have minutes, not hours. Hurry!" CR>)
          (<L? ,TICK-COUNT 11>
           <TELL "The toys around the workshop are growing still -- their magic waning. Hurry!" CR>)
          (<L? ,TICK-COUNT 21>
           <TELL "Golden light creeps at the eastern horizon through the shop window. Dawn is close now." CR>)
          (<L? ,TICK-COUNT 31>
           <TELL "The sky outside the window shows the first grey hint of approaching dawn." CR>)
          (<L? ,TICK-COUNT 51>
           <TELL "The cuckoo clock chimes, more urgently. Half the night is gone." CR>)
          (<L? ,TICK-COUNT 101>
           <TELL "The cuckoo clock chimes softly. Plenty of night left -- but the hours pass." CR>)>
    <RTRUE>>

<ROUTINE I-NUTMEG-AUTONOMY ()
    <QUEUE I-NUTMEG-AUTONOMY 8>
    <COND (,GAME-WON <RTRUE>)
          (<AND <IN? ,NUTMEG ,FOX-DEN>
                <EQUAL? ,NUTMEG-TRUST 0>>
           <COND (<EQUAL? ,HERE ,FOX-DEN>
                  <TELL "The fox toy shifts in her nest, watching you warily." CR>)>)
          (<AND <IN? ,NUTMEG ,FOX-DEN>
                <EQUAL? ,NUTMEG-TRUST 1>>
           <COND (<EQUAL? ,HERE ,FOX-DEN>
                  <TELL "Nutmeg's ears twitch. She seems to be waiting for you to say something." CR>)>)
          (<AND <IN? ,NUTMEG ,FOX-DEN>
                <EQUAL? ,NUTMEG-TRUST 2>>
           <COND (<EQUAL? ,HERE ,FOX-DEN>
                  <TELL "Nutmeg looks at you with something almost like hope in her button eyes." CR>)>)
          (<AND <EQUAL? ,NUTMEG-TRUST -1>
                <L? ,NUTMEG-KEY-METHOD 2>>
           <COND (<EQUAL? ,HERE ,FOX-DEN>
                  <TELL "In the corner, Nutmeg's breathing has slowed. She is falling asleep." CR>)>)>
    <RTRUE>>

; === ROOM ACTION ROUTINES ===

<ROUTINE TOOL-BENCH-FCN (RARG)
    <COND (<EQUAL? .RARG ,M-LOOK>
           <TELL "The tool bench stretches away, a landscape of enormous chisels and planes. A staircase made of giant wooden spools leads toward the countertop.">
           <COND (,LADDER-OILED
                  <TELL " Its lifting mechanism moves freely now.">)
                 (T
                  <TELL " Its lifting mechanism is frozen with rust.">)>
           <COND (<NOT ,BERTRAND-WOUND>
                  <TELL " The way upward is blocked.">)>
           <TELL CR>)>>

<ROUTINE COUNTERTOP-FCN (RARG)
    <COND (<EQUAL? .RARG ,M-LOOK>
           <TELL "You are on the countertop -- the toy display. Through the frosted shop window you can see the snowy street outside, the clock tower visible in the distance.">
           <TELL " Stairs lead back down to the tool bench." CR>)>>

<ROUTINE STORAGE-LOFT-FCN (RARG)
    <COND (<EQUAL? .RARG ,M-LOOK>
           <TELL "The storage loft is dusty and dim, cobwebs draping the rafters like grey curtains.">
           <TELL " Stairs lead back down." CR>)>>

<ROUTINE SCRAP-YARD-FCN (RARG)
    <COND (<EQUAL? .RARG ,M-LOOK>
           <TELL "The scrap-yard is a sad place. Broken toys are piled everywhere.">
           <COND (,CART-MOVED
                  <TELL " The iron gate to the east stands open now.">)
                 (T
                  <TELL " The way east is blocked.">)>
           <TELL " Snow covers the piles of discarded playthings." CR>)>>

<ROUTINE FOX-DEN-FCN (RARG)
    <COND (<EQUAL? .RARG ,M-LOOK>
           <TELL "A cosy den made of rags and twigs, tucked between old crates. A tiny toy candle burns inside, casting warm shadows.">
           <TELL " The exit leads west to the scrap-yard." CR>)>>

; === DYNAMIC OBJECT DESCRIPTIONS ===

<ROUTINE BERTRAND-DESC-F (RARG)
    <COND (<EQUAL? .RARG ,M-OBJDESC>
           <COND (,BERTRAND-WOUND
                  <TELL "Captain Bertrand stands proudly beside the now-clear way upward, his jaw fully operational." CR>)
                 (<NOT <IN? ,BERTRAND-KEY ,TOOL-BENCH>>
                  <TELL "A painted wooden nutcracker stands frozen mid-stride beside the spool staircase, the winding socket in his back empty." CR>)
                 (T
                  <TELL "A painted wooden nutcracker stands frozen mid-stride beside the spool staircase. A tiny brass winding key protrudes from his back." CR>)>
           <RTRUE>)>>

<ROUTINE MARZIPAN-DESC-F (RARG)
    <COND (<EQUAL? .RARG ,M-OBJDESC>
           <COND (,MARZIPAN-BUTTON
                  <TELL "Marzipan sits against the window with two mismatched button eyes, humming warmly." CR>)
                 (T
                  <TELL "A rag doll with one button eye sits against the window, humming a soft, meandering tune." CR>)>
           <RTRUE>)>>

<ROUTINE OLD-TICK-DESC-F (RARG)
    <COND (<EQUAL? .RARG ,M-OBJDESC>
           <COND (,OLD-TICK-HEARD
                  <TELL "The old cuckoo clock ticks steadily among the shadows, its wooden bird alert behind its little door." CR>)
                 (T
                  <TELL "An old cuckoo clock sits silent among the shadows, its hands frozen at five to midnight." CR>)>
           <RTRUE>)>>

<ROUTINE SCRAP-CART-DESC-F (RARG)
    <COND (<EQUAL? .RARG ,M-OBJDESC>
           <COND (,CART-MOVED
                  <TELL "The scrap cart rests beside the track, its bed still full of carefully rescued toys." CR>)
                 (T
                  <TELL "A scrap-metal cart creaks along a rusted track, gathering broken toys into its bed rather than destroying them." CR>)>
           <RTRUE>)>>

<ROUTINE NUTMEG-DESC-F (RARG)
    <COND (<EQUAL? .RARG ,M-OBJDESC>
           <COND (<G? ,NUTMEG-TRUST 2>
                  <TELL "Nutmeg watches you with soft button eyes, the place around her neck where the workshop key hung now empty." CR>)
                 (<EQUAL? ,NUTMEG-TRUST -1>
                  <TELL "Nutmeg curls in the farthest corner with her back to you, clutching the workshop key close." CR>)
                 (T
                  <TELL "A patchy fox toy curls in a nest of rags, watching you warily. The workshop key ticks faintly around her neck." CR>)>
           <RTRUE>)>>

; === V-WIND HANDLER ===

<ROUTINE V-WIND ()
    <COND (<EQUAL? ,PRSO ,BERTRAND>
           <COND (,BERTRAND-WOUND
                  <TELL "Bertrand is already wound -- and rather full of himself because of it." CR>)
                 (<IN? ,BERTRAND-KEY ,WINNER>
                  <TELL "You insert the tiny brass key into the nutcracker's back and wind. His jaw snaps shut with a sharp CLACK, then opens wide. 'At last! A proper winding! I have been stuck in this ridiculous pose for hours. Captain Bertrand of the Nutcracker Brigade, at your service!' He clicks his heels and steps aside with a smart salute. The way upstairs is clear." CR>
                  <SETG BERTRAND-WOUND T>
                  <MOVE ,BERTRAND-KEY ,WINNER>)
                 (T
                  <TELL "Bertrand needs his winding key first. There should be one in his back -- try examining him." CR>)>
           <RTRUE>)
          (<EQUAL? ,PRSO ,CLOCK-WINDING>
           <COND (,TOWER-WOUND
                  <TELL "The clock tower is already wound. Time is flowing as slowly as it can." CR>)
                 (<IN? ,TIN-SOLDIER ,WINNER>
                  <TELL "You stand on the tin soldier's shoulders and reach the winding mechanism. With all your strength, you turn the brass wheel. The clock tower's ticking slows to a deep, ponderous beat. Time itself stretches, buying you precious extra hours." CR>
                  <SETG CLOCK-SLOWED T>
                  <SETG TOWER-WOUND T>)
                 (T
                  <TELL "The winding mechanism is just out of reach. You need something to stand on -- something tall and sturdy. Perhaps one of the larger toys could help." CR>)>
           <RTRUE>)
          (<EQUAL? ,PRSO ,OLD-TICK>
           <COND (<NOT ,OLD-TICK-HEARD>
                  <TELL "You reach up and wind the old cuckoo clock. Its hands shudder and begin to move. A tiny wooden bird emerges from its door and chimes: 'The hour of reckoning comes. Behind me lies the way, but only the fox knows how to open it.'" CR>
                  <SETG OLD-TICK-HEARD T>
                  <SETG OLD-TICK-RIDDLES <+ ,OLD-TICK-RIDDLES 1>>)
                 (T
                  <TELL "Old Tick chimes again, its wooden bird peering at you. 'You have wound me twice, small one. Few show such patience. The latch behind me -- it needs a small paw to reach it. Have you made a fox-friend?'" CR>
                  <SETG OLD-TICK-RIDDLES <+ ,OLD-TICK-RIDDLES 1>>)>
           <COND (<AND <G? ,NUTMEG-TRUST 0>
                       <NOT ,STUDY-ACCESS>>
                  <TELL " Suddenly, Nutmeg pads forward from the shadows. 'I can reach it,' she says quietly. 'I know the way. I followed him once -- the old man -- when he went upstairs.' She slips behind the clock. There is a soft click, and the clock swings outward, revealing a narrow staircase. 'The toymaker's study is up there. That is where he went.'" CR>
                  <SETG STUDY-ACCESS T>)
                 (<AND <EQUAL? ,NUTMEG-TRUST -1>
                       <IN? ,TIN-SOLDIER ,WINNER>
                       <NOT ,STUDY-ACCESS>>
                  <TELL " You hear a click behind the clock. Without Nutmeg's help, you have to improvise. Using the tin soldier's bayonet, you manage to hook the hidden latch. The clock swings open, revealing stairs." CR>
                  <SETG STUDY-ACCESS T>)>
           <RTRUE>)
          (<EQUAL? ,PRSO ,MUSIC-BOX>
           <TELL "You turn the tiny crank on the music box. A soft melody fills the air -- a lullaby that Grandfather Tolliver used to hum while he worked. The sound is both sweet and sad. You feel, very briefly, as if he were standing right beside you." CR>
           <FSET ,MUSIC-BOX ,TOUCHBIT>
           <RTRUE>)
          (<EQUAL? ,PRSO ,HEART-MECH>
           <COND (<NOT ,KEY-FOUND>
                  <TELL "The heart mechanism is silent. Its keyhole is dark and empty. You need the workshop key to bring it back to life." CR>)
                 (<NOT <IN? ,WORKSHOP-KEY ,WINNER>>
                  <TELL "You need to be holding the workshop key to wind the heart." CR>)
                 (,KEY-WOUND
                  <TELL "The heart is already turning. Its gears are moving -- but too slowly. It needs companions now, not more winding." CR>)
                 (T
                  <TELL "You insert the workshop key into the brass keyhole. It fits perfectly -- a click, then a deep shudder runs through the entire chamber. Gears begin to turn, slowly at first, then faster. The heart is beating." CR>
                  <TELL " But something is still missing. The heart is turning, but it needs more than mechanical power to truly beat. It needs the love the toys carry -- the companions you have made along your journey. Each friend you have helped can lend their strength." CR>
                  <SETG KEY-WOUND T>
                  <THIS-IS-IT ,HEART-MECH>)>
           <RTRUE>)
           (T
            <TELL "There is nothing to wind there." CR>)>>

; === V-OIL HANDLER ===

<ROUTINE V-OIL ()
    <COND (<EQUAL? ,PRSO ,LADDER-MECH>
           <COND (,LADDER-OILED
                  <TELL "The mechanism is already well-oiled and working smoothly." CR>)
                 (<IN? ,OIL-CAN ,WINNER>
                  <TELL "You work oil from the tiny copper can into the rusty joints. With a satisfying creak, the mechanism loosens. The spool staircase is climbable now." CR>
                  <SETG LADDER-OILED T>)
                 (T
                  <TELL "You need oil to lubricate the mechanism. There might be an oil can somewhere in the workshop." CR>)>
           <RTRUE>)
          (<EQUAL? ,PRSO ,SPOOL-STAIRS>
           <COND (,LADDER-OILED
                  <TELL "The spool staircase is already working smoothly." CR>)
                 (<IN? ,OIL-CAN ,WINNER>
                  <TELL "You oil the spool staircase's lifting mechanism. It loosens with a satisfying creak." CR>
                  <SETG LADDER-OILED T>)
                 (T
                  <TELL "You need oil. Try looking under the workbench." CR>)>
           <RTRUE>)
           (T
            <TELL "That does not need oiling." CR>)>>

; === V-HINTS HANDLER ===

<ROUTINE V-HINTS ()
    <COND (<AND <EQUAL? ,HERE ,FOX-DEN>
                <NOT ,KEY-FOUND>
                <NOT <EQUAL? ,NUTMEG-TRUST -1>>>
           <COND (<L? ,HINT-LEVEL 4>
                  <SETG HINT-LEVEL <+ ,HINT-LEVEL 1>>)>
           <COND (<EQUAL? ,HINT-LEVEL 1> <TELL "The fox has been alone a very long time. She needs kindness, not demands." CR>)
                 (<EQUAL? ,HINT-LEVEL 2> <TELL "Try giving her something -- the red scarf from the mailbox corner, or tell her about Tolliver." CR>)
                 (<EQUAL? ,HINT-LEVEL 3> <TELL "Gifts and kind words build trust. She needs to know someone cares." CR>)
                 (T <TELL "GIVE SCARF TO FOX. TELL FOX ABOUT TOLLIVER. Then ask her for the key." CR>)>
           <RTRUE>)
          (<AND <EQUAL? ,HERE ,SCRAP-YARD>
                <NOT ,CART-MOVED>>
           <COND (<L? ,HINT-LEVEL 4>
                  <SETG HINT-LEVEL <+ ,HINT-LEVEL 1>>)>
           <COND (<EQUAL? ,HINT-LEVEL 1> <TELL "The cart is not hostile. Look at it more carefully." CR>)
                 (<EQUAL? ,HINT-LEVEL 2> <TELL "The cart carries broken toys. One doll is missing its head. Search the piles." CR>)
                 (<EQUAL? ,HINT-LEVEL 3> <TELL "Give the doll head to the cart. Show compassion, not force." CR>)
                 (T <TELL "TAKE DOLL HEAD. GIVE HEAD TO CART." CR>)>
           <RTRUE>)
          (<AND ,KEY-FOUND
                <NOT ,STUDY-ACCESS>>
           <COND (<L? ,HINT-LEVEL 4>
                  <SETG HINT-LEVEL <+ ,HINT-LEVEL 1>>)>
           <COND (<EQUAL? ,HINT-LEVEL 1> <TELL "Now that you have the key, the cuckoo clock seems different. Try interacting with it." CR>)
                 (<EQUAL? ,HINT-LEVEL 2> <TELL "Old Tick on the wall spoke of something behind him." CR>)
                 (<EQUAL? ,HINT-LEVEL 3> <TELL "Wind Old Tick in the workshop. Nutmeg or the tin soldier can reach the hidden latch." CR>)
                 (T <TELL "WIND CLOCK in the workshop. A small paw or the tin soldier's bayonet can reach the latch behind it." CR>)>
           <RTRUE>)
          (,KEY-WOUND
           <COND (<L? ,HINT-LEVEL 4>
                  <SETG HINT-LEVEL <+ ,HINT-LEVEL 1>>)>
           <COND (<EQUAL? ,HINT-LEVEL 1> <TELL "The heart is turning, but it needs more than mechanical power." CR>)
                 (<EQUAL? ,HINT-LEVEL 2> <TELL "The toys you have helped can lend their strength." CR>)
                 (<EQUAL? ,HINT-LEVEL 3> <TELL "Place your companions around the heart. Each one adds their love to the magic." CR>)
                 (T <TELL "POSITION SOLDIER. POSITION MUSIC BOX. Nutmeg and Bertrand will help if you were kind to them." CR>)>
           <RTRUE>)
          (<NOT ,BERTRAND-WOUND>
           <COND (<L? ,HINT-LEVEL 4>
                  <SETG HINT-LEVEL <+ ,HINT-LEVEL 1>>)>
           <COND (<EQUAL? ,HINT-LEVEL 1> <TELL "That nutcracker is blocking the way. He looks... stuck." CR>)
                 (<EQUAL? ,HINT-LEVEL 2> <TELL "Examine the nutcracker closely. He has something in his back." CR>)
                 (<EQUAL? ,HINT-LEVEL 3> <TELL "Take the winding key from his back, then wind him up." CR>)
                 (T <TELL "TAKE KEY. WIND NUTCRACKER." CR>)>
           <RTRUE>)
          (<NOT ,LADDER-OILED>
           <COND (<L? ,HINT-LEVEL 4>
                  <SETG HINT-LEVEL <+ ,HINT-LEVEL 1>>)>
           <COND (<EQUAL? ,HINT-LEVEL 1> <TELL "Those spool stairs will not move. Something is rusted." CR>)
                 (<EQUAL? ,HINT-LEVEL 2> <TELL "The lifting mechanism needs oil. Search under the workbench." CR>)
                 (<EQUAL? ,HINT-LEVEL 3> <TELL "Take the oil can from under the workbench, then oil the mechanism." CR>)
                 (T <TELL "LOOK UNDER WORKBENCH. TAKE OIL CAN. OIL MECHANISM." CR>)>
           <RTRUE>)
           (T
            <TELL "The workshop feels different tonight. The key hook on the wall is empty -- its magic gone. Something is wrong. You should investigate." CR>)>>

; === WORKSHOP-FLOOR OBJECT HANDLERS ===

<ROUTINE KEY-HOOK-F ()
    <COND (<VERB? EXAMINE>
           <TELL "The brass key hook on the wall is empty. Only a frayed string dangles from it. The hook itself is cold -- no magic left in it at all." CR>)
           (<VERB? TAKE>
            <TELL "The hook is fixed firmly to the wall. But the string dangling from it looks like it might come free." CR>)>>

<ROUTINE WORKBENCH-F ()
    <COND (<VERB? EXAMINE LOOK-INSIDE>
           <TELL "The enormous workbench towers above you. Its surface is cluttered with tools and half-finished toys. Underneath, something small and copper catches the light." CR>)
          (<VERB? LOOK-UNDER>
           <COND (<IN? ,OIL-CAN ,WORKBENCH>
                  <TELL "You peer under the workbench. A tiny copper oil can sits in the shadows." CR>)
                 (T
                  <TELL "There is nothing under the workbench now." CR>)>
           <RTRUE>)
          (<VERB? CLIMB CLIMB-FOO CLIMB-UP>
           <TELL "You scramble up the workbench leg. From up here, you can see the whole workshop -- the key hook on the wall, the pet door, the cuckoo clock. You climb back down, the view fresh in your mind." CR>
           <RTRUE>)>>

<ROUTINE OIL-CAN-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A tiny copper oil can, no bigger than your thumb. It is about half full. The label reads: 'Tolliver's Finest -- For Squeaks and Stiff Joints.'" CR>)
          (<VERB? SHAKE>
           <TELL "You shake the can gently. Oil sloshes inside -- enough for a few uses." CR>)>>

<ROUTINE SAWDUST-F ()
    <COND (<VERB? EXAMINE>
           <TELL "Soft golden sawdust covers the floorboards. It smells of cedar and old wood. If you had time, you might sweep it up. But tonight, there are more important things." CR>)
          (<VERB? TAKE>
           <TELL "The sawdust slips through your fingers. You cannot carry enough to be useful." CR>)>>

<ROUTINE PET-DOOR-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A small pet door is cut into the bottom of the workshop's main door. It is just the right size for a wind-up apprentice -- or a fox toy. Moonlight and cold air seep through the flap." CR>)
          (<VERB? OPEN>
           <TELL "The pet door flap swings freely. You can go through it to the north, into the snowy night." CR>)>>

<ROUTINE SWEEP-BROOM-F ()
    <COND (<VERB? EXAMINE>
           <TELL "Your tiny broom. The bristles are worn from many nights of sweeping, and the handle is smooth from use. It was one of the first things Tolliver ever made for you." CR>)>>

<ROUTINE CLOCK-FACE-F ()
    <COND (<VERB? EXAMINE>
           <TELL "An old cuckoo clock hangs on the workshop wall. It ticks softly -- a steady, reassuring sound. The hands show it is nearly midnight.">
           <COND (,KEY-FOUND
                  <TELL " Now that you have the key, the clock seems to tick with more urgency.">)>
           <COND (,STUDY-ACCESS
                  <TELL " The clock has swung open, revealing a narrow staircase leading upward.">)>
           <TELL CR>)
          (<VERB? LISTEN>
           <TELL "You press your ear to the clock. Tick, tick, tick -- steady as a heartbeat. Behind the ticking, you almost hear something else: a deeper rhythm, like another heart beating somewhere far below." CR>)>>

<ROUTINE KEY-STRING-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A frayed piece of string, once used to hang the workshop key. The ends are chewed -- by small sharp teeth, from the look of it." CR>)>>

<ROUTINE SPOOL-STAIRS-F ()
    <COND (<VERB? EXAMINE>
           <COND (,LADDER-OILED
                  <TELL "A staircase made of giant wooden thread spools. With the lifting mechanism oiled, the stairs move smoothly. You can climb up to the storage loft." CR>)
                  (T
                   <TELL "A staircase made of giant wooden thread spools leads upward. The lifting mechanism is rusted solid -- it will not budge without oil." CR>)>)>>

<ROUTINE LADDER-MECH-F ()
    <COND (<VERB? EXAMINE>
           <COND (,LADDER-OILED
                  <TELL "The iron lifting mechanism is well-oiled now. It moves freely, allowing the spool stairs to rise." CR>)
                 (T
                  <TELL "The rusty iron lifting mechanism is frozen with rust. It needs oil -- badly." CR>)>
           <RTRUE>)
          (<VERB? TURN>
           <COND (,LADDER-OILED
                  <TELL "The mechanism turns smoothly under your hands. The spool stairs shift upward." CR>)
                 (T
                  <TELL "You strain against the mechanism, but it is rusted solid. You need to oil it first." CR>)>
           <RTRUE>)>>

; === TOOL-BENCH OBJECT HANDLERS ===

<ROUTINE BERTRAND-F ()
    <COND (<VERB? EXAMINE>
           <COND (,BERTRAND-WOUND
                  <TELL "Captain Bertrand of the Nutcracker Brigade stands at attention, positively radiating self-importance. His jaw, now fully operational, is clamped in what he probably considers a dignified expression. The way to the countertop is clear." CR>)
                 (T
                  <TELL "A painted wooden nutcracker stands frozen mid-stride, one foot raised. His jaw is clamped tight -- whether in a grimace or a smile, it is hard to say. There is a tiny brass winding key in his back." CR>)>)
          (<VERB? PUSH>
           <COND (,BERTRAND-WOUND
                  <TELL "Captain Bertrand does not appreciate being pushed. He glares at you but steps aside anyway." CR>)
                 (T
                  <TELL "He is far too heavy to push. Besides, you would never want to be rude to a nutcracker." CR>)>)
          (<VERB? TALK-TO ASK TELL>
           <COND (,BERTRAND-WOUND
                  <COND (<EQUAL? ,PRSI ,WORKSHOP-KEY>
                         <TELL "'The master's key? Gone from its hook, I noticed. Most irregular. I would have investigated myself, but...' He gestures at his wooden legs. 'Limited mobility, I am afraid.'" CR>)
                        (<EQUAL? ,PRSI ,TOLLIVER-COAT>
                         <TELL "'The Grandfather? Finest toymaker in three counties. He wound me himself, every evening at six.' His voice softens. 'He has not come down tonight. I am... concerned.'" CR>)
                        (T
                         <TELL "'I am Captain Bertrand of the Nutcracker Brigade. State your business, small apprentice.' He seems to be waiting for you to address him properly." CR>)>)
                  (T
                   <TELL "His painted mouth stays clamped shut. He looks like he has plenty to say, if only someone would wind him up." CR>)>)>>

<ROUTINE BERTRAND-KEY-F ()
    <COND (<VERB? EXAMINE>
           <COND (<IN? ,BERTRAND-KEY ,TOOL-BENCH>
                  <TELL "A tiny brass winding key protrudes from the nutcracker's back. It looks like it would fit perfectly." CR>)
                  (T
                   <TELL "A tiny brass winding key. It is the exact size for winding a nutcracker -- or any other clockwork toy." CR>)>)>>

<ROUTINE VARNISH-POT-F ()
    <COND (<VERB? EXAMINE LOOK-INSIDE>
           <TELL "A pot of varnish, left open. The contents have gone thick and tacky -- useless for fine work now. The smell is faintly sweet and chemical." CR>)>>

<ROUTINE TOOL-RACK-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A wooden rack of tools hangs on the wall: tiny chisels, needle-files, a jeweller's hammer. Everything a toymaker needs. Everything except what you are looking for." CR>)>>

; === COUNTERTOP OBJECT HANDLERS ===

<ROUTINE MARZIPAN-F ()
    <COND (<VERB? EXAMINE>
           <COND (,MARZIPAN-BUTTON
                  <TELL "The rag doll -- Marzipan -- now has both button eyes. They are mismatched, but somehow that makes her expression warmer. She hums softly, a tune full of secrets." CR>)
                 (T
                  <TELL "A rag doll with one button eye and a stitched smile. Her fabric is patched in places, but she is carefully mended -- Tolliver's handiwork. She hums a soft, meandering tune." CR>)>)
          (<VERB? ASK TELL>
           <COND (,MARZIPAN-BUTTON
                  <COND (<EQUAL? ,PRSI ,NUTMEG>
                         <TELL "Marzipan sings: 'Foxy, foxy, all alone / Colder than a stepping stone / Give her something warm and red / And she might trust a word you have said.'" CR>)
                        (<EQUAL? ,PRSI ,WORKSHOP-KEY>
                         <TELL "She tilts her head and sings: 'The key that ticks, the key that tocks / Gone with fox through snowy blocks / Through the door where cold winds blow / That is where you need to go.'" CR>)
                        (T
                         <TELL "Marzipan looks at you with both eyes now. She sings: 'Behind the ticking, ticking clock / A door that needs no key or lock / But small paws only fit the crack / To push the hidden latch way back.'" CR>)>)
                  (T
                   <TELL "Marzipan tilts her head and sings: 'Fox feet, fox feet, left the shop / Through the door with a hop and a hop / Key round neck and heart so sore / Find her where the broken toys snore.'" CR>)>)>>

<ROUTINE DISPLAY-CASE-F ()
    <COND (<VERB? EXAMINE>
           <COND (<FSET? ,DISPLAY-CASE ,OPENBIT>
                  <TELL "The glass display case is open. Inside, you can see a brave tin soldier and a silver music box." CR>)
                 (T
                  <TELL "A dusty glass display case. Through the glass, you can see a tin soldier and a silver music box. The case has a small brass latch." CR>)>)
          (<AND <VERB? OPEN>
                <NOT <FSET? ,DISPLAY-CASE ,OPENBIT>>>
           <TELL "You flip the brass latch and open the display case. The glass lid lifts smoothly, releasing the faint scent of old polish." CR>
           <FSET ,DISPLAY-CASE ,OPENBIT>
           <RTRUE>)
           (<AND <VERB? OPEN>
                 <FSET? ,DISPLAY-CASE ,OPENBIT>>
           <TELL "The display case is already open." CR>
           <RTRUE>)>>

<ROUTINE TIN-SOLDIER-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A brave tin soldier, painted in bright red and blue. There is a spot of rust on his bayonet, but his painted eyes are steady. He stands at attention, as if waiting for orders." CR>)>>

<ROUTINE MUSIC-BOX-F ()
    <COND (<VERB? EXAMINE>
           <COND (<FSET? ,MUSIC-BOX ,TOUCHBIT>
                  <TELL "A silver music box. Its crank has been turned recently, and you can almost still hear the echo of its melody." CR>)
                  (T
                   <TELL "A small silver music box with a tiny crank on its side. It looks like it would play a tune if wound." CR>)>)>>

<ROUTINE SHOP-WINDOW-F ()
    <COND (<VERB? EXAMINE LOOK-THROUGH>
           <TELL "Through the frosted shop window, you can see the snowy street outside. The clock tower is visible in the distance, its face pale in the moonlight. The snow is deep -- deeper than you are tall.">
           <COND (<L? ,TICK-COUNT 31>
                  <TELL " The sky is noticeably lighter now. Dawn is approaching.">)>
           <TELL CR>)>>

<ROUTINE TOY-BUTTON-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A spare black button, just the right size for a doll's missing eye. It is smooth and slightly warm, as if someone has been holding it." CR>)>>

; === STORAGE-LOFT OBJECT HANDLERS ===

<ROUTINE OLD-TICK-F ()
    <COND (<VERB? EXAMINE>
           <COND (,OLD-TICK-HEARD
                  <TELL "The old cuckoo clock is awake now. Its hands move steadily, and the little wooden bird peers out from its door with bright painted eyes. It has the air of something very old and very patient." CR>)
                 (T
                  <TELL "An old cuckoo clock, the twin of the one downstairs. It is dusty and still, its hands frozen at five to midnight. Odd -- it feels like it is waiting for you to do something." CR>)>)
          (<VERB? ASK TELL>
           <COND (,OLD-TICK-HEARD
                  <TELL "Old Tick's wooden bird emerges. 'The answers you seek are already in your pockets, small one. The key, the friends, the heart -- you have everything you need. Now use it.'" CR>)
                 (T
                  <TELL "The clock remains silent. It seems to be waiting for a more... mechanical form of attention." CR>)>)
          (<VERB? LISTEN>
           <COND (,OLD-TICK-HEARD
                  <TELL "You listen. The clock ticks with a deep, resonant tone -- almost like a heartbeat. Beneath it, you hear something else: the distant echo of another mechanism, somewhere below." CR>)
                 (T
                  <TELL "You press your ear to the old clock. Silence. But then -- was that a faint tick? It is hard to tell. The clock seems to need winding before it will speak." CR>)>)>>

<ROUTINE TOY-BOX-F ()
    <COND (<VERB? EXAMINE>
           <COND (<FSET? ,TOY-BOX ,OPENBIT>
                  <TELL "A dusty cardboard box labelled 'Broken -- For Repair'. It is open.">
                  <COND (<IN? ,DOLL-ARM ,TOY-BOX>
                         <TELL " Inside, a porcelain doll arm lies among other broken pieces.">)>
                  <TELL CR>)
                 (T
                  <TELL "A dusty cardboard box labelled 'Broken -- For Repair'. The flaps are tucked shut." CR>)>)
          (<AND <VERB? OPEN>
                <NOT <FSET? ,TOY-BOX ,OPENBIT>>>
           <TELL "You open the cardboard box. Inside are broken toy parts: a porcelain doll arm, a wooden wheel, some springs. Tolliver always meant to fix these." CR>
           <FSET ,TOY-BOX ,OPENBIT>
           <RTRUE>)>>

<ROUTINE DOLL-ARM-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A delicate porcelain doll arm, separated from its owner. The fingers are curled gently, as if reaching for something. There is a matching doll somewhere -- perhaps in need of this arm." CR>)>>

<ROUTINE TOLLIVER-JOURNAL-F ()
    <COND (<VERB? READ EXAMINE>
           <COND (<NOT ,JOURNAL-READ>
                  <SETG JOURNAL-READ T>)>
           <TELL "You open the leather journal. Tolliver's handwriting is neat but growing shakier with each entry. October 14th -- 'The workshop key grows weaker. I must wind it more often now. The magic in this town depends on it.' October 20th -- 'Old Tick tells me the heart needs attention. I will see to it tonight.' October 21st -- 'I could not reach the heart alone. Something blocks the way. I must find another path. The toys need me. Pip needs me.' The rest of the pages are blank." CR>)>>

<ROUTINE COBWEBS-F ()
    <COND (<VERB? EXAMINE>
           <TELL "Dusty cobwebs drape the rafters like grey curtains. They have been here a long time -- nothing disturbs the dust up here. Or almost nothing." CR>)>>

; === SNOWY-ALLEY OBJECT HANDLERS ===

<ROUTINE FOOTPRINTS-F ()
    <COND (<VERB? EXAMINE>
           <TELL "Tiny fox footprints in the snow -- unmistakably toy-sized. They lead east through the alley, toward the clock square. Someone small and fast came this way, and not long ago." CR>)>>

<ROUTINE STREETLAMP-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A streetlamp -- really a toy lantern mounted on a pole. Its flame flickers weakly, but it still casts a warm circle of light on the snow. Someone cared enough to keep it lit." CR>)
          (<VERB? LAMP-ON>
           <TELL "The streetlamp is already lit. Its flame has been burning a long time." CR>)>>

<ROUTINE SNOW-F ()
    <COND (<VERB? EXAMINE>
           <TELL "Fresh snow blankets the cobblestones. It sparkles in the moonlight, untouched except for the fox footprints. It is cold -- you can feel it even through your wind-up body." CR>)
          (<VERB? TAKE>
           <TELL "The snow melts in your tiny hands. You cannot carry it anywhere useful." CR>)>>

; === CLOCK-SQUARE OBJECT HANDLERS ===

<ROUTINE CLOCK-TOWER-F ()
    <COND (<VERB? EXAMINE>
           <COND (,TOWER-WOUND
                  <TELL "The clock tower stands over the square, its great face now ticking with a slow, steady beat. Time feels stretched -- you have bought yourself precious extra hours." CR>)
                  (T
                   <TELL "The giant clock tower dominates the square. Its face shows the hours until dawn -- each tick of its great hand a reminder that time is running out. A brass winding mechanism sits at the base, but it is too high for you to reach alone." CR>)>)>>

<ROUTINE CLOCK-WINDING-F ()
    <COND (<VERB? EXAMINE>
           <COND (,TOWER-WOUND
                  <TELL "The brass winding mechanism has been turned. The gears inside move with a slow, deliberate rhythm." CR>)
                  (T
                   <TELL "A brass winding mechanism at the tower's base. It is just out of reach -- if only you had something to stand on." CR>)>)>>

<ROUTINE BAKER-TOY-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A wooden baker toy stands in the bakery window, frozen in the act of kneading dough. His painted smile is cheerful, but his eyes are still -- no magic left in him." CR>)>>

<ROUTINE TOY-LAMPS-F ()
    <COND (<VERB? EXAMINE>
           <TELL "Tin toy lamps dot the cobblestones, their light weak and flickering. Like everything else in Wrenfold, they are running out of magic. Soon they will go dark too." CR>)>>

; === MAILBOX-CORNER OBJECT HANDLERS ===

<ROUTINE MAILBOX-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A red tin mailbox, painted with fading flowers. Its flap hangs open like a mouth, and every now and then it shivers -- not from the cold, but as if it is trying to speak." CR>)
          (<VERB? LOOK-INSIDE>
           <TELL "Inside the mailbox, a bundle of unsent letters sits waiting. They are addressed to toys -- invitations to tea parties, thank-you notes, a crayon drawing from a child." CR>)
          (<VERB? OPEN>
           <TELL "The mailbox flap is already open. It hangs loose, like a mouth ready to speak." CR>
           <RTRUE>)
          (<VERB? CLOSE>
           <TELL "You try to close the flap, but it swings open again immediately -- as if the mailbox has something to say." CR>
           <RTRUE>)
          (<VERB? ASK TELL>
           <COND (<EQUAL? ,PRSI ,NUTMEG>
                  <TELL "The mailbox shivers. Its flap moves: 'F-f-fox? Yes. Passed this way. Heading to the scrap-yard, east of the square. She looked... cold. Cold and lonely.'" CR>)
                 (<EQUAL? ,PRSI ,FOOTPRINTS>
                  <TELL "The mailbox trembles. 'Tracks in the snow. Fox tracks. She went east. Poor dear. Nobody writes her letters.'" CR>)
                 (T
                  <TELL "The mailbox shivers but cannot form words. It seems to only know about the things it has seen from its corner." CR>)>)>>

<ROUTINE LETTER-F ()
    <COND (<VERB? READ EXAMINE>
           <COND (<NOT ,LETTER-READ>
                  <SETG LETTER-READ T>)>
           <TELL "A crumpled envelope. Inside is a letter in Tolliver's handwriting: 'My dear Pip -- The heart is failing. I must go and mend it myself. Do not worry. Take care of the toys while I am gone. Wind the key at midnight if I do not return. I am proud of you, little apprentice. -- Grandfather Tolliver.' The letter is dated three days ago." CR>)>>

<ROUTINE SCARF-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A red wool scarf, dropped in the snow. It is well-made and still warm -- whoever lost it cannot have gone far. It looks like it would fit a small toy perfectly." CR>)>>

<ROUTINE MAILBOX-LETTERS-F ()
    <COND (<VERB? EXAMINE READ>
           <TELL "A bundle of unsent letters inside the mailbox. They are addressed to toys -- invitations to tea parties, thank-you notes, a crayon drawing from a child. One envelope simply says 'For Nutmeg' in wobbly letters. It has never been opened." CR>)>>

; === SCRAP-YARD OBJECT HANDLERS ===

<ROUTINE SCRAP-CART-F ()
    <COND (<VERB? EXAMINE>
           <COND (,CART-MOVED
                  <TELL "The scrap cart has rolled aside, its bed still full of rescued toys. It rests peacefully now, its work done for the night." CR>)
                 (T
                  <TELL "A scrap-metal cart on rusted wheels. It creaks along a track, collecting broken toys into its bed -- a headless doll, a three-legged horse. But look closer: someone has carefully repaired the cart's wheels, oiled its axles. This cart is not destroying toys. It is rescuing them." CR>)>)
          (<VERB? PUSH>
           <COND (,CART-MOVED
                  <TELL "The cart is already out of the way." CR>)
                 (T
                  <TELL "The cart is far too heavy for you to push. It rumbles softly, almost like a growl -- but it does not move." CR>)>)
          (<VERB? ATTACK>
           <COND (,CART-MOVED
                  <TELL "The cart has done nothing to you. Leave it be." CR>)
                  (T
                   <TELL "The cart does not fight back. It simply continues its work, creaking along its track, ignoring you entirely." CR>)>)>>

<ROUTINE HEADLESS-DOLL-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A headless porcelain doll in a torn dress. Despite her state, someone has folded her hands neatly in her lap. She looks peaceful, somehow -- as if waiting to be made whole again." CR>)>>

<ROUTINE DOLL-HEAD-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A porcelain doll head with painted blue eyes and rosebud lips. It matches the headless doll in the cart. They were clearly once part of the same toy." CR>)>>

<ROUTINE TOY-HORSE-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A wooden toy horse, its paint chipped and one leg missing. It rocks gently when you touch it, as if dreaming of galloping." CR>)>>

<ROUTINE YARD-GATE-F ()
    <COND (<VERB? EXAMINE>
           <COND (,CART-MOVED
                  <TELL "The iron gate leads east. Now that the cart has moved aside, the way is clear." CR>)
                  (T
                   <TELL "An iron gate leads east, but the scrap cart is blocking the way. You cannot squeeze past it." CR>)>)>>

; === FOX-DEN OBJECT HANDLERS ===

<ROUTINE NUTMEG-F ()
    <COND (<VERB? EXAMINE>
           <COND (<NOT <IN? ,NUTMEG ,FOX-DEN>>
                  <TELL "Nutmeg is not here. Her den feels empty -- just rags and a dying candle." CR>)
                 (<G? ,NUTMEG-TRUST 2>
                  <TELL "Nutmeg, the fox toy. Her patchy orange fur and mismatched button eyes give her a lopsided, vulnerable look. She watches you with something close to trust now. The workshop key is no longer around her neck." CR>)
                 (<EQUAL? ,NUTMEG-TRUST -1>
                  <TELL "Nutmeg is curled in the furthest corner of her den, her back to you. Her shoulders tremble slightly. The key is still around her neck, but she will not let you near it." CR>)
                 (T
                  <TELL "A fox-shaped toy with patchy orange fur. Her button eyes watch you warily. The workshop key -- the one from the empty hook -- hangs from a string around her neck. It ticks faintly, its magic growing weaker." CR>)>)
          (<VERB? ATTACK>
           <COND (<EQUAL? ,NUTMEG-TRUST -1>
                  <TELL "You have already hurt her enough. She flinches at your movement but does not fight back." CR>)
                 (T
                  <TELL "Nutmeg flinches. 'I knew it,' she whispers. 'You are just like the others.' She retreats to the deepest corner of the den, key clutched tight to her chest. She will not look at you anymore." CR>
                  <SETG NUTMEG-TRUST -1>)>
           <RTRUE>)
          (<VERB? ASK TELL>
           <COND (<EQUAL? ,NUTMEG-TRUST -1>
                  <TELL "Nutmeg does not answer. She refuses to even look at you." CR>)
                 (<OR <EQUAL? ,PRSI ,WORKSHOP-KEY>
                      <EQUAL? ,PRSI ,TOPIC-KEY>>
                  <COND (<G? ,NUTMEG-TRUST 2>
                         <TELL "Nutmeg looks at the empty hook where the key used to hang. 'It belongs back there, does it not? With the others. I... I was wrong to take it.' She seems lighter now, having said it." CR>)
                        (<G? ,NUTMEG-TRUST 0>
                         <TELL "Nutmeg hugs the key closer. 'I know it is not mine. But it is the only thing that has ever ticked for me. Do you know what that is like? Being a toy nobody wanted?'" CR>)
                        (T
                         <TELL "'Why should I give it back?' Her voice is sharp. 'Nobody ever gave me anything. Why should I give up the only thing that is ever been mine?'" CR>)>)
                  (<OR <EQUAL? ,PRSI ,TOLLIVER-COAT>
                       <EQUAL? ,PRSI ,TOPIC-TOLLIVER>>
                   <COND (<G? ,NUTMEG-TRUST 1>
                          <TELL "Nutmeg's ears droop. 'The old man... he fixed me once. When my stitching came loose. He did not have to -- nobody asked him. He just did it. And then he stopped coming. I thought he had forgotten about me. Like everyone else.' A tear -- a tiny bead of condensation -- rolls down her fabric cheek." CR>)
                         (T
                          <TELL "'The toymaker?' She looks away. 'He was kind. Too kind. He tried to fix everything. And look what happened.' She will not say more -- not yet." CR>)>)>)>>

<ROUTINE WORKSHOP-KEY-F ()
    <COND (<VERB? EXAMINE>
           <COND (,KEY-FOUND
                  <TELL "The workshop key. Brass, warm to the touch, with an intricate winding pattern on its head. It ticks faintly -- a tiny heartbeat. This is what keeps Wrenfold's toys alive." CR>)
                 (T
                  <TELL "The workshop key hangs from a string around the fox's neck. It is brass, intricately carved, and it ticks -- weakly, but steadily. It is the source of all the magic in Wrenfold." CR>)>)
          (<AND <VERB? TAKE>
                <NOT ,KEY-FOUND>
                <EQUAL? ,NUTMEG-TRUST -1>>
           <TELL "Nutmeg growls softly. The key is around her neck, and she will not let you near it. Not after what you did." CR>)
          (<AND <VERB? TAKE>
                <NOT ,KEY-FOUND>
                <EQUAL? ,NUTMEG-TRUST -1>>
           <TELL "Nutmeg growls softly. The key is around her neck, and she will not let you near it. Not after what you did." CR>)
          (<AND <VERB? TAKE>
                <NOT ,KEY-FOUND>
                <L? ,NUTMEG-TRUST 1>>
           <TELL "Nutmeg snatches the key back. 'No!' Her voice is sharp, but there is something else underneath -- fear, maybe. 'I cannot... I cannot lose it too.'" CR>)
          (<AND <VERB? TAKE>
                <NOT ,KEY-FOUND>
                <G? ,NUTMEG-TRUST 0>>
           <TELL "Nutmeg is quiet for a long moment. Then, slowly, she paws the key off her neck and places it before you. 'Take it,' she says. Her voice cracks. 'I am sorry I took it. I just... I did not want to be alone when the ticking stopped. But you came all this way. You really care, do you not?' She looks up at you with her mismatched button eyes. 'Promise you will come back. Please.'" CR>
           <SETG KEY-FOUND T>
           <SETG NUTMEG-KEY-METHOD 1>
           <MOVE ,WORKSHOP-KEY ,WINNER>
           <FCLEAR ,WORKSHOP-KEY ,NDESCBIT>
            <THIS-IS-IT ,WORKSHOP-KEY>
            <RTRUE>)>>

<ROUTINE RAG-BED-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A cosy nest of rags and twigs. It smells faintly of cedar shavings -- the same scent as Tolliver's workshop. Someone has made this place into a home." CR>)>>

<ROUTINE TOY-CANDLE-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A tiny toy candle, no bigger than your finger. Its flame is steady and warm -- real fire, real light. It must have been burning for a long time." CR>)
          (<VERB? LAMP-OFF BLOW>
           <TELL "You consider blowing it out, but something stops you. It is the only warmth in this cold little den." CR>)>>

<ROUTINE STRING-BALL-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A ball of red yarn string. It is slightly frayed, as if someone has been playing with it. A fox, perhaps." CR>)>>

; === TOLLIVER-STUDY OBJECT HANDLERS ===

<ROUTINE TOLLIVER-COAT-F ()
    <COND (<VERB? EXAMINE>
           <TELL "Grandfather Tolliver's worn tweed coat. It still smells like him -- wood shavings, lamp oil, and something faintly like peppermint. The pockets are empty." CR>)
          (<VERB? WEAR>
           <TELL "The coat is far too large for you. It would swallow you whole. But you wrap a corner of it around your shoulders for a moment. It is warm. It still feels like him." CR>)>>

<ROUTINE TEA-CUP-F ()
    <COND (<VERB? EXAMINE>
           <TELL "A cup of tea, long gone cold. A skin of dust floats on the surface. Tolliver never got to finish it." CR>)
          (<VERB? DRINK>
           <TELL "You dip your finger in the cold tea. It is bitter with age. You leave the rest." CR>)>>

<ROUTINE STUDY-DESK-F ()
    <COND (<VERB? EXAMINE LOOK-INSIDE>
           <TELL "A cluttered wooden desk. Papers are spread across its surface -- diagrams, notes, a half-finished sketch of the workshop heart. An open journal lies among them, alongside a hand-drawn winding diagram." CR>)>>

<ROUTINE DIAGRAM-F ()
    <COND (<VERB? READ EXAMINE>
           <COND (<NOT ,DIAGRAM-READ>
                  <SETG DIAGRAM-READ T>)>
           <TELL "A hand-drawn diagram of the workshop's inner workings. Tolliver mapped the heart chamber carefully. The instructions read: 'Insert key. Turn clockwise. For full rewinding, surround the heart with companions -- the more love present, the stronger the magic. Each toy carries memories of the children who loved them. Those memories are power.'" CR>)>>

<ROUTINE STUDY-JOURNAL-F ()
    <COND (<VERB? READ EXAMINE>
           <COND (<NOT ,STUDY-JOURNAL-READ>
                  <SETG STUDY-JOURNAL-READ T>)>
           <TELL "Tolliver's journal, open to the final entry. The handwriting is shaky but determined: 'I cannot wind the heart alone. The magic has grown weak, and I am old. But Pip -- dear Pip -- is still small enough to reach the heart chamber. If the key is found, and if Pip has made friends along the way, then perhaps the heart can beat again. I have left the key in the workshop. I only hope it is enough. Pip, if you are reading this -- I am proud of you. You were always more than just an apprentice. -- G.T.'" CR>)>>

<ROUTINE STUDY-CHR-F ()
    <COND (<VERB? EXAMINE>
           <TELL "An old wooden chair, pushed back from the desk. Tolliver's coat hangs on its back, as if he just stepped away for a moment. As if he might return at any time." CR>)>>

; === WORKSHOP-HEART OBJECT HANDLERS ===

<ROUTINE HEART-MECH-F ()
    <COND (<VERB? EXAMINE>
           <COND (,KEY-WOUND
                  <TELL "The workshop heart is turning now -- slowly, but steadily. Its brass gears catch the candlelight. A deep, resonant ticking fills the chamber. It sounds like hope.">
                  <COND (<G? ,COMPANION-COUNT 0>
                         <TELL " The presence of your companions has made the light brighter, the ticking stronger.">)>
                  <TELL " A brass keyhole gleams at its centre -- the workshop key is in place." CR>)
                 (T
                  <TELL "The workshop's heart -- a vast brass mechanism of interlocking gears -- stands silent and still. At its centre, a keyhole waits, dark and empty. Around the walls, dozens of toys stand frozen in the shadows, as if they came here hoping to be rewound." CR>)>)
          (<VERB? LISTEN>
           <COND (,KEY-WOUND
                  <TELL "You press your hand to the mechanism. Tick, tick, tick -- a heartbeat. Growing stronger." CR>)
                  (T
                   <TELL "Silence. The heart is completely still. Not even an echo." CR>)>)>>

<ROUTINE KEY-SLOT-F ()
    <COND (<VERB? EXAMINE>
           <COND (,KEY-WOUND
                  <TELL "The workshop key is in the keyhole, turning steadily. The brass gleams with renewed warmth." CR>)
                  (T
                   <TELL "A brass keyhole at the heart's centre. It is exactly the right size and shape for the workshop key. This is where the magic begins." CR>)>)>>

<ROUTINE SILENT-TOYS-F ()
    <COND (<VERB? EXAMINE>
           <COND (,KEY-WOUND
                  <COND (,GAME-WON
                         <TELL "The toys around the heart are stirring. Paint is brightening. Joints are loosening. They are waking up." CR>)
                        (T
                         <TELL "The silent toys around the chamber walls. Their painted eyes seem to follow you. They are waiting -- hoping -- that you can bring the magic back." CR>)>)
                  (T
                   <TELL "Dozens of toy figures stand around the heart chamber. Soldiers, dolls, wooden animals -- all of them motionless. Their paint is dull. Their joints are stiff. They are waiting for the heart to beat again." CR>)>)>>

; === LOCAL-GLOBALS ACTION HANDLERS ===

<ROUTINE WORKSHOP-BUILDING-F ()
    <COND (<VERB? EXAMINE>
           <COND (,GAME-WON
                  <TELL "The workshop looks different now. Warm light glows in every window. The magic has returned, and you can feel it -- a steady, gentle hum from deep within the building." CR>)
                  (T
                   <TELL "Grandfather Tolliver's workshop -- a cosy old building with frosted windows and a crooked chimney. From outside, you would never guess the magic it holds within." CR>)>)>>

<ROUTINE MOON-F ()
    <COND (<VERB? EXAMINE>
           <COND (<L? ,TICK-COUNT 31>
                  <TELL "The winter moon is fading now, pale against the brightening sky. Dawn is near." CR>)
                  (T
                   <TELL "A bright winter moon hangs overhead, casting long blue shadows across the snow. It is a beautiful night -- but a cold one." CR>)>)>>

<ROUTINE BAKERY-F ()
    <COND (<VERB? EXAMINE>
           <TELL "An abandoned bakery storefront. Through the dusty window, a wooden baker toy stands frozen mid-knead. The glass is frosted with age, and the door hangs slightly ajar." CR>)>>

; === GIVE HANDLER OVERRIDES ===

<SYNTAX GIVE OBJECT TO OBJECT = V-GIVE-TO>

<ROUTINE V-GIVE-TO ()
    <COND (<AND <EQUAL? ,PRSO ,BUTTON>
                <EQUAL? ,PRSI ,MARZIPAN>>
           <COND (,MARZIPAN-BUTTON
                  <TELL "Marzipan already has her second eye. She touches it with a stitched finger and smiles." CR>)
                 (T
                  <TELL "Marzipan takes the button in her fabric hand. 'For me?' She looks at it -- then at you. Her stitched smile somehow seems wider. She sews the button into place beside her other eye. Now both eyes watch you with warmth. 'Thank you, little wind-up one. Now I can see twice as much. Let me sing you a secret.' She leans close and whispers: 'Behind the ticking, ticking clock, a door that needs no key or lock. But small paws only fit the crack -- the fox can push the hidden latch way back.'" CR>
                  <SETG MARZIPAN-BUTTON T>
                  <MOVE ,BUTTON ,MARZIPAN>)>
           <RTRUE>)
          (<AND <EQUAL? ,PRSO ,SCARF>
                <EQUAL? ,PRSI ,NUTMEG>>
           <COND (<NOT <IN? ,NUTMEG ,HERE>>
                  <TELL "Nutmeg is not here." CR>)
                 (<EQUAL? ,NUTMEG-TRUST -1>
                  <TELL "Nutmeg flinches away from your outstretched hand. She does not want anything from you now." CR>)
                 (T
                  <TELL "Nutmeg stares at the red scarf in your hand. 'For... for me?' She reaches out with a trembling paw and touches the wool. 'It is warm. Nobody ever gave me anything warm before.' Her voice cracks on the last word. She wraps the scarf around her neck, where the key used to hang. 'Thank you,' she whispers." CR>
                  <COND (<EQUAL? ,NUTMEG-TRUST 0>
                         <SETG NUTMEG-TRUST 1>)
                        (T
                         <SETG NUTMEG-TRUST 2>)>
                  <SETG NUTMEG-GIFTS <+ ,NUTMEG-GIFTS 1>>
                  <MOVE ,SCARF ,NUTMEG>)>
           <RTRUE>)
          (<AND <EQUAL? ,PRSO ,STRING-BALL>
                <EQUAL? ,PRSI ,NUTMEG>>
           <COND (<NOT <IN? ,NUTMEG ,HERE>>
                  <TELL "Nutmeg is not here." CR>)
                 (<EQUAL? ,NUTMEG-TRUST -1>
                  <TELL "Nutmeg ignores the ball. She does not want to play anymore." CR>)
                 (T
                  <TELL "Nutmeg looks at the ball of yarn. Despite herself, her paw twitches. She bats it once -- twice -- and then catches herself, embarrassed. 'I used to do this,' she says quietly. 'In the shop window. Before I knew nobody was coming for me.' She curls up with the yarn tucked under her chin." CR>
                  <SETG NUTMEG-TRUST 2>
                  <SETG NUTMEG-GIFTS <+ ,NUTMEG-GIFTS 1>>
                  <MOVE ,STRING-BALL ,NUTMEG>)>
           <RTRUE>)
          (<AND <EQUAL? ,PRSO ,DOLL-HEAD>
                <EQUAL? ,PRSI ,SCRAP-CART>>
           <COND (<NOT <EQUAL? ,HERE ,SCRAP-YARD>>
                  <TELL "The scrap cart is not here." CR>)
                 (,CART-MOVED
                  <TELL "The cart has already moved aside. Its work here is done." CR>)
                 (T
                  <TELL "You hold up the porcelain doll head. The cart pauses. A mechanical arm -- surprisingly gentle -- extends and takes the head from your hands. It places the head beside the headless doll in its bed. For a moment, the cart is perfectly still. Then it rumbles -- a low, soft sound, like a purr -- and rolls slowly aside, revealing the iron gate to the east." CR>
                  <SETG CART-MOVED T>
                  <SETG CART-HELPED T>)>
           <RTRUE>)
          (<AND <EQUAL? ,PRSI ,NUTMEG>
                <NOT <IN? ,NUTMEG ,HERE>>>
           <TELL "Nutmeg is not here." CR>)
          (T
           <TELL "That does not seem interested in your gift." CR>)>>

; === PLACE HANDLER FOR FINAL REWIND ===

<SYNTAX POSITION OBJECT = V-PLACE-HEART>

<ROUTINE V-PLACE-HEART ()
    <COND (<NOT <EQUAL? ,HERE ,WORKSHOP-HEART>>
           <TELL "There is no reason to place that here." CR>)
          (<NOT ,KEY-WOUND>
           <TELL "The heart is not yet wound. You need to wind it with the key first." CR>)
          (<EQUAL? ,PRSO ,TIN-SOLDIER>
           <TELL "You place the tin soldier beside the heart mechanism. He snaps to attention -- and the heart ticks louder, stronger. His painted eyes seem to brighten. 'Standing guard,' he seems to say, though his tin mouth never moves." CR>
           <SETG COMPANION-COUNT <+ ,COMPANION-COUNT 1>>
           <MOVE ,TIN-SOLDIER ,WORKSHOP-HEART>
           <CHECK-ENDING>)
          (<EQUAL? ,PRSO ,MUSIC-BOX>
           <TELL "You place the silver music box near the heart. Its crank turns by itself, and the lullaby fills the chamber. The gears respond -- their rhythm shifts to match the melody." CR>
           <SETG COMPANION-COUNT <+ ,COMPANION-COUNT 1>>
           <MOVE ,MUSIC-BOX ,WORKSHOP-HEART>
           <CHECK-ENDING>)
          (<EQUAL? ,PRSO ,DOLL-ARM>
           <TELL "You place the doll arm gently beside the heart. It is a small gesture, but the heart knows -- every mended toy, every kind act, feeds the magic." CR>
           <SETG COMPANION-COUNT <+ ,COMPANION-COUNT 1>>
           <MOVE ,DOLL-ARM ,WORKSHOP-HEART>
           <CHECK-ENDING>)
          (<EQUAL? ,PRSO ,BUTTON>
           <TELL "You place the spare button at the heart's base. A tiny offering -- but the heart remembers everything." CR>
           <SETG COMPANION-COUNT <+ ,COMPANION-COUNT 1>>
           <MOVE ,BUTTON ,WORKSHOP-HEART>
           <CHECK-ENDING>)
          (,GAME-WON
           <TELL "The heart is already beating strongly. There is nothing more to do." CR>)
          (T
           <TELL "Placing that here would not help the heart." CR>)>>

<ROUTINE CHECK-ENDING ()
     <COND (<AND <G? ,NUTMEG-TRUST 0>
                <NOT ,NUTMEG-SAVED>
                <NOT <EQUAL? ,NUTMEG-TRUST -1>>>
           <TELL " Nutmeg pads forward from the shadows. 'Let me help,' she says quietly. 'I have been alone long enough. I would like to be part of something.' She curls up at the base of the heart mechanism, her patchy fur glowing faintly in its light." CR>
           <SETG NUTMEG-SAVED T>
           <SETG COMPANION-COUNT <+ ,COMPANION-COUNT 1>>)>
    <COND (<AND ,BERTRAND-WOUND
                ,BERTRAND-POLITE
                <NOT ,NUTMEG-TRUST -1>>
           <TELL " Captain Bertrand marches into the chamber. 'The Nutcracker Brigade never abandons its post,' he declares. He takes up position beside the heart, ramrod straight." CR>
           <SETG COMPANION-COUNT <+ ,COMPANION-COUNT 1>>)>
    <COND (<G? ,COMPANION-COUNT 2>
           <REWIND-ENDING>)>
    <RTRUE>>

<ROUTINE REWIND-ENDING ()
    <COND (,GAME-WON <RTRUE>)>
    <SETG GAME-WON T>
    <SETG ENDING-TIER 3>
    <TELL CR>
    <TELL "The workshop heart beats -- a deep, steady rhythm that echoes through every corner of Wrenfold. The clock tower chimes. Toys stir in shop windows all across the square. Streetlamps flicker to full brightness. The magic is back." CR CR>
    <TELL "Grandfather Tolliver's voice, somehow, whispers through the gears: 'Well done, apprentice. Well done.'" CR CR>
    <COND (,NUTMEG-SAVED
           <TELL "Nutmeg curls at your feet, her patchy fur warm and her new red scarf bright in the candlelight. 'You kept your promise,' she says. 'Nobody ever kept their promise before.'" CR CR>)>
    <TELL "The sun rises over Wrenfold, and every toy in town is awake to see it." CR>
    <TELL "The last of the night's cold fades from your gears. You are home." CR CR>
    <TELL "*** You have restored the heart of Wrenfold ***" CR>
    <FINISH>>
