V_VERBOSE = nil
V_BRIEF = nil
V_SUPER_BRIEF = nil
V_INVENTORY = nil
FINISH = nil
V_QUIT = nil
V_RESTART = nil
V_RESTORE = nil
V_SAVE = nil
V_SCRIPT = nil
V_UNSCRIPT = nil
V_VERSION = nil
V_VERIFY = nil
V_COMMAND_FILE = nil
V_RANDOM = nil
V_RECORD = nil
V_UNRECORD = nil
V_ADVENT = nil
V_ALARM = nil
V_ANSWER = nil
V_ATTACK = nil
V_BACK = nil
V_BLAST = nil
PRE_BOARD = nil
V_BOARD = nil
V_BREATHE = nil
V_BRUSH = nil
V_BUG = nil
TELL_NO_PRSI = nil
PRE_BURN = nil
V_BURN = nil
V_CHOMP = nil
V_CLIMB_DOWN = nil
V_CLIMB_FOO = nil
V_CLIMB_ON = nil
V_CLIMB_UP = nil
V_CLOSE = nil
V_COMMAND = nil
V_COUNT = nil
V_CROSS = nil
V_CURSES = nil
V_CUT = nil
V_DEFLATE = nil
V_DIG = nil
V_DISEMBARK = nil
V_DISENCHANT = nil
V_DRINK = nil
V_DRINK_FROM = nil
PRE_DROP = nil
V_DROP = nil
V_EAT = nil
HIT_SPOT = nil
V_ECHO = nil
V_ENCHANT = nil
REMOVE_CAREFULLY = nil
V_ENTER = nil
V_EXAMINE = nil
V_EXIT = nil
V_EXORCISE = nil
PRE_FILL = nil
V_FILL = nil
V_FIND = nil
V_FOLLOW = nil
V_FROBOZZ = nil
PRE_GIVE = nil
V_GIVE = nil
V_HATCH = nil
V_HELLO = nil
V_INCANT = nil
V_INFLATE = nil
V_KICK = nil
V_KISS = nil
V_KNOCK = nil
V_LAMP_OFF = nil
V_LAMP_ON = nil
V_LAUNCH = nil
V_LEAN_ON = nil
V_LEAP = nil
V_LEAVE = nil
V_LISTEN = nil
V_LOCK = nil
V_LOOK = nil
V_LOOK_BEHIND = nil
V_LOOK_INSIDE = nil
V_LOOK_ON = nil
V_LOOK_UNDER = nil
V_LOWER = nil
V_MAKE = nil
V_MELT = nil
PRE_MOVE = nil
V_MOVE = nil
V_MUMBLE = nil
PRE_MUNG = nil
V_MUNG = nil
V_ODYSSEUS = nil
V_OIL = nil
V_OPEN = nil
V_OVERBOARD = nil
V_PICK = nil
V_PLAY = nil
V_PLUG = nil
V_POUR_ON = nil
V_PRAY = nil
V_PUMP = nil
V_PUSH = nil
V_PUSH_TO = nil
PRE_PUT = nil
V_PUT = nil
V_PUT_BEHIND = nil
V_PUT_ON = nil
V_PUT_UNDER = nil
V_RAISE = nil
V_RAPE = nil
PRE_READ = nil
V_READ = nil
V_READ_PAGE = nil
V_REPENT = nil
V_REPLY = nil
V_RING = nil
V_RUB = nil
V_SAY = nil
V_SEARCH = nil
V_SEND = nil
PRE_SGIVE = nil
V_SGIVE = nil
V_SHAKE = nil
SHAKE_LOOP = nil
V_SKIP = nil
V_SMELL = nil
V_SPIN = nil
V_SPRAY = nil
V_SQUEEZE = nil
V_SSPRAY = nil
V_STAB = nil
V_STAND = nil
V_STAY = nil
V_STRIKE = nil
V_SWIM = nil
V_SWING = nil
PRE_TAKE = nil
V_TAKE = nil
V_TELL = nil
V_THROUGH = nil
V_THROW = nil
V_THROW_OFF = nil
V_TIE = nil
V_TIE_UP = nil
V_TREASURE = nil
PRE_TURN = nil
V_TURN = nil
V_UNLOCK = nil
V_UNTIE = nil
V_WAIT = nil
V_WALK = nil
V_WALK_AROUND = nil
V_WALK_TO = nil
V_WAVE = nil
V_WEAR = nil
V_WIN = nil
V_WIND = nil
V_WISH = nil
V_YELL = nil
V_ZORK = nil
V_FIRST_LOOK = nil
DESCRIBE_ROOM = nil
DESCRIBE_OBJECTS = nil
DESCRIBE_OBJECT = nil
PRINT_CONTENTS = nil
PRINT_CONT = nil
FIRSTER = nil
SEE_INSIDEQ = nil
SCORE_UPD = nil
SCORE_OBJ = nil
YESQ = nil
ITAKE = nil
IDROP = nil
CCOUNT = nil
WEIGHT = nil
HACK_HACK = nil
NO_GO_TELL = nil
GOTO = nil
LKP = nil
DO_WALK = nil
GLOBAL_INQ = nil
FIND_IN = nil
HELDQ = nil
OTHER_SIDE = nil
MUNG_ROOM = nil
THIS_IS_IT = nil

VERBOSE = nil
SUPER_BRIEF = nil
V_VERBOSE = function()
APPLY(function() VERBOSE = T return VERBOSE end)
APPLY(function() SUPER_BRIEF = nil return SUPER_BRIEF end)
	return   TELL([[Maximum verbosity.]], CR)
end
V_BRIEF = function()
APPLY(function() VERBOSE = nil return VERBOSE end)
APPLY(function() SUPER_BRIEF = nil return SUPER_BRIEF end)
	return   TELL([[Brief descriptions.]], CR)
end
V_SUPER_BRIEF = function()
APPLY(function() SUPER_BRIEF = T return SUPER_BRIEF end)
	return   TELL([[Superbrief descriptions.]], CR)
end
V_INVENTORY = function()

  if FIRSTQ(WINNER) then 
    	return PRINT_CONT(WINNER)
  elseif T then 
    	return TELL([[You are empty-handed.]], CR)
  end

end
FINISH = function()
	local WRD
  V_SCORE()

  while true do
    CRLF()    TELL([[Would you like to restart the game from the beginning, restore a saved
game position, or end this session of the game?|
(Type RESTART, RESTORE, or QUIT):|
>]])    READ(P_INBUF, P_LEXV)    APPLY(function() WRD = GET(P_LEXV, 1) return WRD end)    
    if EQUALQ(WRD, WQRESTART) then 
      RESTART()
      	return TELL([[Failed.]], CR)
    elseif EQUALQ(WRD, WQRESTORE) then 
      
      if RESTORE() then 
        	return TELL([[Ok.]], CR)
      elseif T then 
        	return TELL([[Failed.]], CR)
      end

    elseif EQUALQ(WRD, WQQUIT, WQQ) then 
      	return QUIT()
    end

  end

end
V_QUIT = function()
	local SCOR
  V_SCORE()
  TELL([[Do you wish to leave the game? (Y is affirmative): ]])

  if YESQ() then 
    	return QUIT()
  else 
    	return TELL([[Ok.]], CR)
  end

end
V_RESTART = function()
  V_SCORE(T)
  TELL([[Do you wish to restart? (Y is affirmative): ]])

  if YESQ() then 
    TELL([[Restarting.]], CR)
    RESTART()
    	return TELL([[Failed.]], CR)
  end

end
V_RESTORE = function()

  if RESTORE() then 
    TELL([[Ok.]], CR)
    	return V_FIRST_LOOK()
  elseif T then 
    	return TELL([[Failed.]], CR)
  end

end
V_SAVE = function()

  if SAVE() then 
    	return TELL([[Ok.]], CR)
  elseif T then 
    	return TELL([[Failed.]], CR)
  end

end
V_SCRIPT = function()
  PUT(0, 8, BOR(GET(0, 8), 1))
  TELL([[Here begins a transcript of interaction with]], CR)
  V_VERSION()
	return true
end
V_UNSCRIPT = function()
  TELL([[Here ends a transcript of interaction with]], CR)
  V_VERSION()
  PUT(0, 8, BAND(GET(0, 8), -2))
	return true
end
V_VERSION = function()
  local CNT = 17
  TELL([[ZORK I: The Great Underground Empire|
Infocom interactive fiction - a fantasy story|
Copyright (c) 1981, 1982, 1983, 1984, 1985, 1986]])
  TELL([[ Infocom, Inc. All rights reserved.]], CR)
  TELL([[ZORK is a registered trademark of Infocom, Inc.|
Release ]])
  PRINTN(BAND(GET(0, 1), 2047))
  TELL([[ / Serial number ]])

  while true do
    
    if GQ(APPLY(function() CNT = ADD(CNT, 1) return CNT end), 23) then 
      break 
    elseif T then 
      PRINTC(GETB(0, CNT))
    end

  end

	return   CRLF()
end
V_VERIFY = function()
  TELL([[Verifying disk...]], CR)

  if VERIFY() then 
    	return TELL([[The disk is correct.]], CR)
  elseif T then 
    	return TELL(CR, [[** Disk Failure **]], CR)
  end

end
V_COMMAND_FILE = function()
  DIRIN(1)
	return true
end
V_RANDOM = function()

  if NOT(EQUALQ(PRSO, INTNUM)) then 
    	return TELL([[Illegal call to #RND.]], CR)
  elseif T then 
    RANDOM(SUB(0, P_NUMBER))
    	return true
  end

end
V_RECORD = function()
  DIROUT(4)
	return true
end
V_UNRECORD = function()
  DIROUT(-4)
	return true
end
V_ADVENT = function()
	return   TELL([[A hollow voice says "Fool."]], CR)
end
V_ALARM = function()

  if FSETQ(PRSO, ACTORBIT) then 
    
    if LQ(GETP(PRSO, "STRENGTH"), 0) then 
      TELL([[The ]], PRSO, [[ is rudely awakened.]], CR)
      	return AWAKEN(PRSO)
    elseif T then 
      	return TELL([[He's wide awake, or haven't you noticed...]], CR)
    end

  elseif T then 
    	return TELL([[The ]], PRSO, [[ isn't sleeping.]], CR)
  end

end
V_ANSWER = function()
  TELL([[Nobody seems to be awaiting your answer.]], CR)
APPLY(function() P_CONT = nil return P_CONT end)
APPLY(function() QUOTE_FLAG = nil return QUOTE_FLAG end)
	return true
end
V_ATTACK = function()

  if NOT(FSETQ(PRSO, ACTORBIT)) then 
    	return TELL([[I've known strange people, but fighting a ]], PRSO, [[?]], CR)
  elseif PASS(NOT(PRSI) or EQUALQ(PRSI, HANDS)) then 
    	return TELL([[Trying to attack a ]], PRSO, [[ with your bare hands is suicidal.]], CR)
  elseif NOT(INQ(PRSI, WINNER)) then 
    	return TELL([[You aren't even holding the ]], PRSI, [[.]], CR)
  elseif NOT(FSETQ(PRSI, WEAPONBIT)) then 
    	return TELL([[Trying to attack the ]], PRSO, [[ with a ]], PRSI, [[ is suicidal.]], CR)
  elseif T then 
    	return HERO_BLOW()
  end

end
V_BACK = function()
	return   TELL([[Sorry, my memory is poor. Please give a direction.]], CR)
end
V_BLAST = function()
	return   TELL([[You can't blast anything by using words.]], CR)
end
PRE_BOARD = function()
	local AV
APPLY(function() AV = LOC(WINNER) return AV end)

  if NULL_F() then 
    	return true
  elseif FSETQ(PRSO, VEHBIT) then 
    
    if NOT(INQ(PRSO, HERE)) then 
      TELL([[The ]], PRSO, [[ must be on the ground to be boarded.]], CR)
    elseif FSETQ(AV, VEHBIT) then 
      TELL([[You are already in the ]], AV, [[!]], CR)
    elseif T then 
      	return false 
    end

  elseif EQUALQ(PRSO, WATER, GLOBAL_WATER) then 
    PERFORM(VQSWIM, PRSO)
    	return true
  elseif T then 
    TELL([[You have a theory on how to board a ]], PRSO, [[, perhaps?]], CR)
  end

	return   RFATAL()
end
V_BOARD = function()
	local AV
  TELL([[You are now in the ]], PRSO, [[.]], CR)
  MOVE(WINNER, PRSO)
  APPLY(GETP(PRSO, "ACTION"), M_ENTER)
	return true
end
V_BREATHE = function()
	return   PERFORM(VQINFLATE, PRSO, LUNGS)
end
V_BRUSH = function()
	return   TELL([[If you wish, but heaven only knows why.]], CR)
end
V_BUG = function()
	return   TELL([[Bug? Not in a flawless program like this! (Cough, cough).]], CR)
end
TELL_NO_PRSI = function()
	return   TELL([[You didn't say with what!]], CR)
end
PRE_BURN = function()

  if NOT(PRSI) then 
    	return TELL_NO_PRSI()
  elseif FLAMINGQ(PRSI) then 
    	return false 
  elseif T then 
    	return TELL([[With a ]], PRSI, [[??!?]], CR)
  end

end
V_BURN = function()

  if NULL_F() then 
    	return false 
  elseif FSETQ(PRSO, BURNBIT) then 
    
    if PASS(INQ(PRSO, WINNER) or INQ(WINNER, PRSO)) then 
      REMOVE_CAREFULLY(PRSO)
      TELL([[The ]], PRSO)
      TELL([[ catches fire. Unfortunately, you were ]])
      
      if INQ(WINNER, PRSO) then 
        TELL([[in]])
      elseif T then 
        TELL([[holding]])
      end

      	return JIGS_UP([[ it at the time.]])
    elseif T then 
      REMOVE_CAREFULLY(PRSO)
      	return TELL([[The ]], PRSO, [[ catches fire and is consumed.]], CR)
    end

  elseif T then 
    	return TELL([[You can't burn a ]], PRSO, [[.]], CR)
  end

end
V_CHOMP = function()
	return   TELL([[Preposterous!]], CR)
end
V_CLIMB_DOWN = function()
	return   V_CLIMB_UP("DOWN", PRSO)
end
V_CLIMB_FOO = function()
	return   V_CLIMB_UP("UP", PRSO)
end
V_CLIMB_ON = function()

  if FSETQ(PRSO, VEHBIT) then 
    PERFORM(VQBOARD, PRSO)
    	return true
  elseif T then 
    	return TELL([[You can't climb onto the ]], PRSO, [[.]], CR)
  end

end
V_CLIMB_UP = function(DIR, OBJ)
	local X
	local TX
  DIR = DIR or "UP"
  OBJ = OBJ or nil

  if PASS(OBJ and NOT(EQUALQ(PRSO, ROOMS))) then 
    APPLY(function() OBJ = PRSO return OBJ end)
  end


  if APPLY(function() TX = GETPT(HERE, DIR) return TX end) then 
    
    if OBJ then 
      APPLY(function() X = PTSIZE(TX) return X end)
      
      if PASS(EQUALQ(X, NEXIT) or PASS(EQUALQ(X, CEXIT, DEXIT, UEXIT) and NOT(GLOBAL_INQ(PRSO, GETB(TX, 0))))) then 
        TELL([[The ]], OBJ, [[ do]])
        
        if NOT(EQUALQ(OBJ, STAIRS)) then 
          TELL([[es]])
        end

        TELL([[n't lead ]])
        
        if EQUALQ(DIR, "UP") then 
          TELL([[up]])
        elseif T then 
          TELL([[down]])
        end

        TELL([[ward.]], CR)
        	return true
      end

    end

    DO_WALK(DIR)
    	return true
  elseif PASS(OBJ and ZMEMQ(WQWALL, APPLY(function() X = GETPT(PRSO, "SYNONYM") return X end), PTSIZE(X))) then 
    	return TELL([[Climbing the walls is to no avail.]], CR)
  elseif PASS(NOT(EQUALQ(HERE, PATH)) and EQUALQ(OBJ, nil, TREE) and GLOBAL_INQ(TREE, HERE)) then 
    TELL([[There are no climbable trees here.]], CR)
    	return true
  elseif EQUALQ(OBJ, nil, ROOMS) then 
    	return TELL([[You can't go that way.]], CR)
  elseif T then 
    	return TELL([[You can't do that!]], CR)
  end

end
V_CLOSE = function()

  if PASS(NOT(FSETQ(PRSO, CONTBIT)) and NOT(FSETQ(PRSO, DOORBIT))) then 
    	return TELL([[You must tell me how to do that to a ]], PRSO, [[.]], CR)
  elseif PASS(NOT(FSETQ(PRSO, SURFACEBIT)) and NOT(EQUALQ(GETP(PRSO, "CAPACITY"), 0))) then 
    
    if FSETQ(PRSO, OPENBIT) then 
      FCLEAR(PRSO, OPENBIT)
      TELL([[Closed.]], CR)
      
      if PASS(LIT and NOT(APPLY(function() LIT = LITQ(HERE) return LIT end))) then 
        TELL([[It is now pitch black.]], CR)
      end

      	return true
    elseif T then 
      	return TELL([[It is already closed.]], CR)
    end

  elseif FSETQ(PRSO, DOORBIT) then 
    
    if FSETQ(PRSO, OPENBIT) then 
      FCLEAR(PRSO, OPENBIT)
      	return TELL([[The ]], PRSO, [[ is now closed.]], CR)
    elseif T then 
      	return TELL([[It is already closed.]], CR)
    end

  elseif T then 
    	return TELL([[You cannot close that.]], CR)
  end

end
V_COMMAND = function()

  if FSETQ(PRSO, ACTORBIT) then 
    	return TELL([[The ]], PRSO, [[ pays no attention.]], CR)
  elseif T then 
    	return TELL([[You cannot talk to that!]], CR)
  end

end
V_COUNT = function()

  if EQUALQ(PRSO, BLESSINGS) then 
    	return TELL([[Well, for one, you are playing Zork...]], CR)
  elseif T then 
    	return TELL([[You have lost your mind.]], CR)
  end

end
V_CROSS = function()
	return   TELL([[You can't cross that!]], CR)
end
V_CURSES = function()

  if PRSO then 
    
    if FSETQ(PRSO, ACTORBIT) then 
      	return TELL([[Insults of this nature won't help you.]], CR)
    elseif T then 
      	return TELL([[What a loony!]], CR)
    end

  elseif T then 
    	return TELL([[Such language in a high-class establishment like this!]], CR)
  end

end
V_CUT = function()

  if FSETQ(PRSO, ACTORBIT) then 
    	return PERFORM(VQATTACK, PRSO, PRSI)
  elseif PASS(FSETQ(PRSO, BURNBIT) and FSETQ(PRSI, WEAPONBIT)) then 
    
    if INQ(WINNER, PRSO) then 
      TELL([[Not a bright idea, especially since you're in it.]], CR)
      	return true
    end

    REMOVE_CAREFULLY(PRSO)
    	return TELL([[Your skillful ]], PRSI, [[smanship slices the ]], PRSO, [[ into innumerable slivers which blow away.]], CR)
  elseif NOT(FSETQ(PRSI, WEAPONBIT)) then 
    	return TELL([[The "cutting edge" of a ]], PRSI, [[ is hardly adequate.]], CR)
  elseif T then 
    	return TELL([[Strange concept, cutting the ]], PRSO, [[....]], CR)
  end

end
V_DEFLATE = function()
	return   TELL([[Come on, now!]], CR)
end
V_DIG = function()

  if NOT(PRSI) then 
    APPLY(function() PRSI = HANDS return PRSI end)
  end


  if EQUALQ(PRSI, SHOVEL) then 
    TELL([[There's no reason to be digging here.]], CR)
    	return true
  end


  if FSETQ(PRSI, TOOLBIT) then 
    	return TELL([[Digging with the ]], PRSI, [[ is slow and tedious.]], CR)
  elseif T then 
    	return TELL([[Digging with a ]], PRSI, [[ is silly.]], CR)
  end

end
V_DISEMBARK = function()

  if PASS(EQUALQ(PRSO, ROOMS) and FSETQ(LOC(WINNER), VEHBIT)) then 
    PERFORM(VQDISEMBARK, LOC(WINNER))
    	return true
  elseif NOT(EQUALQ(LOC(WINNER), PRSO)) then 
    TELL([[You're not in that!]], CR)
    	return RFATAL()
  elseif FSETQ(HERE, RLANDBIT) then 
    TELL([[You are on your own feet again.]], CR)
    	return MOVE(WINNER, HERE)
  elseif T then 
    TELL([[You realize that getting out here would be fatal.]], CR)
    	return RFATAL()
  end

end
V_DISENCHANT = function()
	return   TELL([[Nothing happens.]], CR)
end
V_DRINK = function()
	return   V_EAT()
end
V_DRINK_FROM = function()
	return   TELL([[How peculiar!]], CR)
end
PRE_DROP = function()

  if EQUALQ(PRSO, LOC(WINNER)) then 
    PERFORM(VQDISEMBARK, PRSO)
    	return true
  end

end
V_DROP = function()

  if IDROP() then 
    	return TELL([[Dropped.]], CR)
  end

end
V_EAT = function()
  local EATQ = nil
  local DRINKQ = nil
  local NOBJ = nil

  if APPLY(function() EATQ = FSETQ(PRSO, FOODBIT) return EATQ end) then 
    
    if PASS(NOT(INQ(PRSO, WINNER)) and NOT(INQ(LOC(PRSO), WINNER))) then 
      TELL([[You're not holding that.]], CR)
    elseif VERBQ(DRINK) then 
      TELL([[How can you drink that?]])
    elseif T then 
      TELL([[Thank you very much. It really hit the spot.]])
      REMOVE_CAREFULLY(PRSO)
    end

    	return CRLF()
  elseif FSETQ(PRSO, DRINKBIT) then 
    APPLY(function() DRINKQ = T return DRINKQ end)
    APPLY(function() NOBJ = LOC(PRSO) return NOBJ end)
    
    if PASS(INQ(PRSO, GLOBAL_OBJECTS) or GLOBAL_INQ(GLOBAL_WATER, HERE) or EQUALQ(PRSO, PSEUDO_OBJECT)) then 
      	return HIT_SPOT()
    elseif PASS(NOT(NOBJ) or NOT(ACCESSIBLEQ(NOBJ))) then 
      	return TELL([[There isn't any water here.]], CR)
    elseif PASS(ACCESSIBLEQ(NOBJ) and NOT(INQ(NOBJ, WINNER))) then 
      	return TELL([[You have to be holding the ]], NOBJ, [[ first.]], CR)
    elseif NOT(FSETQ(NOBJ, OPENBIT)) then 
      	return TELL([[You'll have to open the ]], NOBJ, [[ first.]], CR)
    elseif T then 
      	return HIT_SPOT()
    end

  elseif NOT(PASS(EATQ or DRINKQ)) then 
    	return TELL([[I don't think that the ]], PRSO, [[ would agree with you.]], CR)
  end

end
HIT_SPOT = function()

  if PASS(EQUALQ(PRSO, WATER) and NOT(GLOBAL_INQ(GLOBAL_WATER, HERE))) then 
    REMOVE_CAREFULLY(PRSO)
  end

	return   TELL([[Thank you very much. I was rather thirsty (from all this talking,
probably).]], CR)
end
V_ECHO = function()
	local LST
	local MAX
  local ECH = 0
	local CNT

  if GQ(GETB(P_LEXV, P_LEXWORDS), 0) then 
    APPLY(function() LST = REST(P_LEXV, MULL(GETB(P_LEXV, P_LEXWORDS), P_WORDLEN)) return LST end)
    APPLY(function() MAX = SUB(ADD(GETB(LST, 0), GETB(LST, 1)), 1) return MAX end)
    
    while true do
      
      if GQ(APPLY(function() ECH = ADD(ECH, 1) return ECH end), 2) then 
        TELL([[...]], CR)
        break 
      elseif T then 
        APPLY(function() CNT = SUB(GETB(LST, 1), 1) return CNT end)
        
        while true do
          
          if GQ(APPLY(function() CNT = ADD(CNT, 1) return CNT end), MAX) then 
            break 
          elseif T then 
            PRINTC(GETB(P_INBUF, CNT))
          end

        end

        	return TELL([[ ]])
      end

    end

  elseif T then 
    	return TELL([[echo echo ...]], CR)
  end

end
V_ENCHANT = function()
  NULL_F()
	return   V_DISENCHANT()
end
REMOVE_CAREFULLY = function(OBJ)
	local OLIT

  if EQUALQ(OBJ, P_IT_OBJECT) then 
    APPLY(function() P_IT_OBJECT = nil return P_IT_OBJECT end)
  end

APPLY(function() OLIT = LIT return OLIT end)
  REMOVE(OBJ)
APPLY(function() LIT = LITQ(HERE) return LIT end)

  if PASS(OLIT and NOT(EQUALQ(OLIT, LIT))) then 
    TELL([[You are left in the dark...]], CR)
  end

	return T
end
V_ENTER = function()
	return   DO_WALK("IN")
end
V_EXAMINE = function()

  if GETP(PRSO, "TEXT") then 
    	return TELL(GETP(PRSO, "TEXT"), CR)
  elseif PASS(FSETQ(PRSO, CONTBIT) or FSETQ(PRSO, DOORBIT)) then 
    	return V_LOOK_INSIDE()
  elseif T then 
    	return TELL([[There's nothing special about the ]], PRSO, [[.]], CR)
  end

end
V_EXIT = function()

  if PASS(EQUALQ(PRSO, nil, ROOMS) and FSETQ(LOC(WINNER), VEHBIT)) then 
    PERFORM(VQDISEMBARK, LOC(WINNER))
    	return true
  elseif PASS(PRSO and INQ(WINNER, PRSO)) then 
    PERFORM(VQDISEMBARK, PRSO)
    	return true
  else 
    	return DO_WALK("OUT")
  end

end
V_EXORCISE = function()
	return   TELL([[What a bizarre concept!]], CR)
end
PRE_FILL = function()
	local TX

  if NOT(PRSI) then 
    APPLY(function() TX = GETPT(HERE, "GLOBAL") return TX end)
    
    if PASS(TX and ZMEMQB(GLOBAL_WATER, TX, SUB(PTSIZE(TX), 1))) then 
      PERFORM(VQFILL, PRSO, GLOBAL_WATER)
      	return true
    elseif INQ(WATER, LOC(WINNER)) then 
      PERFORM(VQFILL, PRSO, WATER)
      	return true
    elseif T then 
      TELL([[There is nothing to fill it with.]], CR)
      	return true
    end

  end


  if EQUALQ(PRSI, WATER) then 
    	return false 
  elseif NOT(EQUALQ(PRSI, GLOBAL_WATER)) then 
    PERFORM(VQPUT, PRSI, PRSO)
    	return true
  end

end
V_FILL = function()

  if NOT(PRSI) then 
    
    if GLOBAL_INQ(GLOBAL_WATER, HERE) then 
      PERFORM(VQFILL, PRSO, GLOBAL_WATER)
      	return true
    elseif INQ(WATER, LOC(WINNER)) then 
      PERFORM(VQFILL, PRSO, WATER)
      	return true
    elseif T then 
      	return TELL([[There's nothing to fill it with.]], CR)
    end

  elseif T then 
    	return TELL([[You may know how to do that, but I don't.]], CR)
  end

end
V_FIND = function()
  local L = LOC(PRSO)

  if EQUALQ(PRSO, HANDS, LUNGS) then 
    	return TELL([[Within six feet of your head, assuming you haven't left that
somewhere.]], CR)
  elseif EQUALQ(PRSO, ME) then 
    	return TELL([[You're around here somewhere...]], CR)
  elseif EQUALQ(L, GLOBAL_OBJECTS) then 
    	return TELL([[You find it.]], CR)
  elseif INQ(PRSO, WINNER) then 
    	return TELL([[You have it.]], CR)
  elseif PASS(INQ(PRSO, HERE) or GLOBAL_INQ(PRSO, HERE) or EQUALQ(PRSO, PSEUDO_OBJECT)) then 
    	return TELL([[It's right here.]], CR)
  elseif FSETQ(L, ACTORBIT) then 
    	return TELL([[The ]], L, [[ has it.]], CR)
  elseif FSETQ(L, SURFACEBIT) then 
    	return TELL([[It's on the ]], L, [[.]], CR)
  elseif FSETQ(L, CONTBIT) then 
    	return TELL([[It's in the ]], L, [[.]], CR)
  elseif T then 
    	return TELL([[Beats me.]], CR)
  end

end
V_FOLLOW = function()
	return   TELL([[You're nuts!]], CR)
end
V_FROBOZZ = function()
	return   TELL([[The FROBOZZ Corporation created, owns, and operates this dungeon.]], CR)
end
PRE_GIVE = function()

  if NOT(HELDQ(PRSO)) then 
    	return TELL([[That's easy for you to say since you don't even have the ]], PRSO, [[.]], CR)
  end

end
V_GIVE = function()

  if NOT(FSETQ(PRSI, ACTORBIT)) then 
    	return TELL([[You can't give a ]], PRSO, [[ to a ]], PRSI, [[!]], CR)
  elseif T then 
    	return TELL([[The ]], PRSI, [[ refuses it politely.]], CR)
  end

end
V_HATCH = function()
	return   TELL([[Bizarre!]], CR)
end
HS = 0
V_HELLO = function()

  if PRSO then 
    
    if FSETQ(PRSO, ACTORBIT) then 
      	return TELL([[The ]], PRSO, [[ bows his head to you in greeting.]], CR)
    elseif T then 
      	return TELL([[It's a well known fact that only schizophrenics say "Hello" to a ]], PRSO, [[.]], CR)
    end

  elseif T then 
    	return TELL(PICK_ONE(HELLOS), CR)
  end

end
V_INCANT = function()
  TELL([[The incantation echoes back faintly, but nothing else happens.]], CR)
APPLY(function() QUOTE_FLAG = nil return QUOTE_FLAG end)
APPLY(function() P_CONT = nil return P_CONT end)
	return true
end
V_INFLATE = function()
	return   TELL([[How can you inflate that?]], CR)
end
V_KICK = function()
	return   HACK_HACK([[Kicking the ]])
end
V_KISS = function()
	return   TELL([[I'd sooner kiss a pig.]], CR)
end
V_KNOCK = function()

  if FSETQ(PRSO, DOORBIT) then 
    	return TELL([[Nobody's home.]], CR)
  elseif T then 
    	return TELL([[Why knock on a ]], PRSO, [[?]], CR)
  end

end
V_LAMP_OFF = function()

  if FSETQ(PRSO, LIGHTBIT) then 
    
    if NOT(FSETQ(PRSO, ONBIT)) then 
      TELL([[It is already off.]], CR)
    elseif T then 
      FCLEAR(PRSO, ONBIT)
      
      if LIT then 
        APPLY(function() LIT = LITQ(HERE) return LIT end)
      end

      TELL([[The ]], PRSO, [[ is now off.]], CR)
      
      if NOT(LIT) then 
        TELL([[It is now pitch black.]], CR)
      end

    end

  elseif T then 
    TELL([[You can't turn that off.]], CR)
  end

	return true
end
V_LAMP_ON = function()

  if FSETQ(PRSO, LIGHTBIT) then 
    
    if FSETQ(PRSO, ONBIT) then 
      TELL([[It is already on.]], CR)
    elseif T then 
      FSET(PRSO, ONBIT)
      TELL([[The ]], PRSO, [[ is now on.]], CR)
      
      if NOT(LIT) then 
        APPLY(function() LIT = LITQ(HERE) return LIT end)
        CRLF()
        V_LOOK()
      end

    end

  elseif FSETQ(PRSO, BURNBIT) then 
    TELL([[If you wish to burn the ]], PRSO, [[, you should say so.]], CR)
  elseif T then 
    TELL([[You can't turn that on.]], CR)
  end

	return true
end
V_LAUNCH = function()

  if FSETQ(PRSO, VEHBIT) then 
    	return TELL([[You can't launch that by saying "launch"!]], CR)
  elseif T then 
    	return TELL([[That's pretty weird.]], CR)
  end

end
V_LEAN_ON = function()
	return   TELL([[Getting tired?]], CR)
end
V_LEAP = function()
	local TX
	local S

  if PRSO then 
    
    if INQ(PRSO, HERE) then 
      
      if FSETQ(PRSO, ACTORBIT) then 
        	return TELL([[The ]], PRSO, [[ is too big to jump over.]], CR)
      elseif T then 
        	return V_SKIP()
      end

    elseif T then 
      	return TELL([[That would be a good trick.]], CR)
    end

  elseif APPLY(function() TX = GETPT(HERE, "DOWN") return TX end) then 
    APPLY(function() S = PTSIZE(TX) return S end)
    
    if PASS(EQUALQ(S, 2) or PASS(EQUALQ(S, 4) and NOT(VALUE(GETB(TX, 1))))) then 
      TELL([[This was not a very safe place to try jumping.]], CR)
      	return JIGS_UP(PICK_ONE(JUMPLOSS))
    elseif EQUALQ(HERE, UP_A_TREE) then 
      TELL([[In a feat of unaccustomed daring, you manage to land on your feet without
killing yourself.]], CR, CR)
      DO_WALK("DOWN")
      	return true
    elseif T then 
      	return V_SKIP()
    end

  elseif T then 
    	return V_SKIP()
  end

end
JUMPLOSS = {0,[[You should have looked before you leaped.]],[[In the movies, your life would be passing before your eyes.]],[[Geronimo...]]}

V_LEAVE = function()
	return   DO_WALK("OUT")
end
V_LISTEN = function()
	return   TELL([[The ]], PRSO, [[ makes no sound.]], CR)
end
V_LOCK = function()
	return   TELL([[It doesn't seem to work.]], CR)
end
V_LOOK = function()

  if DESCRIBE_ROOM(T) then 
    	return DESCRIBE_OBJECTS(T)
  end

end
V_LOOK_BEHIND = function()
	return   TELL([[There is nothing behind the ]], PRSO, [[.]], CR)
end
V_LOOK_INSIDE = function()

  if FSETQ(PRSO, DOORBIT) then 
    
    if FSETQ(PRSO, OPENBIT) then 
      TELL([[The ]], PRSO, [[ is open, but I can't tell what's beyond it.]])
    elseif T then 
      TELL([[The ]], PRSO, [[ is closed.]])
    end

    	return CRLF()
  elseif FSETQ(PRSO, CONTBIT) then 
    
    if FSETQ(PRSO, ACTORBIT) then 
      	return TELL([[There is nothing special to be seen.]], CR)
    elseif SEE_INSIDEQ(PRSO) then 
      
      if PASS(FIRSTQ(PRSO) and PRINT_CONT(PRSO)) then 
        	return true
      elseif NULL_F() then 
        	return true
      elseif T then 
        	return TELL([[The ]], PRSO, [[ is empty.]], CR)
      end

    elseif T then 
      	return TELL([[The ]], PRSO, [[ is closed.]], CR)
    end

  elseif T then 
    	return TELL([[You can't look inside a ]], PRSO, [[.]], CR)
  end

end
V_LOOK_ON = function()

  if FSETQ(PRSO, SURFACEBIT) then 
    PERFORM(VQLOOK_INSIDE, PRSO)
    	return true
  elseif T then 
    	return TELL([[Look on a ]], PRSO, [[???]], CR)
  end

end
V_LOOK_UNDER = function()
	return   TELL([[There is nothing but dust there.]], CR)
end
V_LOWER = function()
	return   HACK_HACK([[Playing in this way with the ]])
end
V_MAKE = function()
	return   TELL([[You can't do that.]], CR)
end
V_MELT = function()
	return   TELL([[It's not clear that a ]], PRSO, [[ can be melted.]], CR)
end
PRE_MOVE = function()

  if HELDQ(PRSO) then 
    	return TELL([[You aren't an accomplished enough juggler.]], CR)
  end

end
V_MOVE = function()

  if FSETQ(PRSO, TAKEBIT) then 
    	return TELL([[Moving the ]], PRSO, [[ reveals nothing.]], CR)
  elseif T then 
    	return TELL([[You can't move the ]], PRSO, [[.]], CR)
  end

end
V_MUMBLE = function()
	return   TELL([[You'll have to speak up if you expect me to hear you!]], CR)
end
PRE_MUNG = function()

  if NULL_F() then 
    	return true
  elseif PASS(NOT(PRSI) or NOT(FSETQ(PRSI, WEAPONBIT))) then 
    TELL([[Trying to destroy the ]], PRSO, [[ with ]])
    
    if NOT(PRSI) then 
      TELL([[your bare hands]])
    elseif T then 
      TELL([[a ]], PRSI)
    end

    	return TELL([[ is futile.]], CR)
  end

end
V_MUNG = function()

  if FSETQ(PRSO, ACTORBIT) then 
    PERFORM(VQATTACK, PRSO, PRSI)
    	return true
  elseif T then 
    	return TELL([[Nice try.]], CR)
  end

end
V_ODYSSEUS = function()

  if PASS(EQUALQ(HERE, CYCLOPS_ROOM) and INQ(CYCLOPS, HERE) and NOT(CYCLOPS_FLAG)) then 
    DISABLE(INT(I_CYCLOPS))
    APPLY(function() CYCLOPS_FLAG = T return CYCLOPS_FLAG end)
    TELL([[The cyclops, hearing the name of his father's deadly nemesis, flees the room
by knocking down the wall on the east of the room.]], CR)
    APPLY(function() MAGIC_FLAG = T return MAGIC_FLAG end)
    FCLEAR(CYCLOPS, FIGHTBIT)
    	return REMOVE_CAREFULLY(CYCLOPS)
  elseif T then 
    	return TELL([[Wasn't he a sailor?]], CR)
  end

end
V_OIL = function()
	return   TELL([[You probably put spinach in your gas tank, too.]], CR)
end
V_OPEN = function()
	local F
	local STR

  if PASS(FSETQ(PRSO, CONTBIT) and NOT(EQUALQ(GETP(PRSO, "CAPACITY"), 0))) then 
    
    if FSETQ(PRSO, OPENBIT) then 
      	return TELL([[It is already open.]], CR)
    elseif T then 
      FSET(PRSO, OPENBIT)
      FSET(PRSO, TOUCHBIT)
      
      if PASS(NOT(FIRSTQ(PRSO)) or FSETQ(PRSO, TRANSBIT)) then 
        	return TELL([[Opened.]], CR)
      elseif PASS(APPLY(function() F = FIRSTQ(PRSO) return F end) and NOT(NEXTQ(F)) and NOT(FSETQ(F, TOUCHBIT)) and APPLY(function() STR = GETP(F, "FDESC") return STR end)) then 
        TELL([[The ]], PRSO, [[ opens.]], CR)
        	return TELL(STR, CR)
      elseif T then 
        TELL([[Opening the ]], PRSO, [[ reveals ]])
        PRINT_CONTENTS(PRSO)
        	return TELL([[.]], CR)
      end

    end

  elseif FSETQ(PRSO, DOORBIT) then 
    
    if FSETQ(PRSO, OPENBIT) then 
      	return TELL([[It is already open.]], CR)
    elseif T then 
      TELL([[The ]], PRSO, [[ opens.]], CR)
      	return FSET(PRSO, OPENBIT)
    end

  elseif T then 
    	return TELL([[You must tell me how to do that to a ]], PRSO, [[.]], CR)
  end

end
V_OVERBOARD = function()
	local LOCN

  if EQUALQ(PRSI, TEETH) then 
    
    if FSETQ(APPLY(function() LOCN = LOC(WINNER) return LOCN end), VEHBIT) then 
      MOVE(PRSO, LOC(LOCN))
      	return TELL([[Ahoy -- ]], PRSO, [[ overboard!]], CR)
    elseif T then 
      	return TELL([[You're not in anything!]], CR)
    end

  elseif FSETQ(LOC(WINNER), VEHBIT) then 
    PERFORM(VQTHROW, PRSO)
    	return true
  elseif T then 
    	return TELL([[Huh?]], CR)
  end

end
V_PICK = function()
	return   TELL([[You can't pick that.]], CR)
end
V_PLAY = function()

  if FSETQ(PRSO, ACTORBIT) then 
    TELL([[You become so engrossed in the role of the ]], PRSO, [[ that
you kill yourself, just as he might have done!]], CR)
    	return JIGS_UP([[]])
  else 
    	return TELL([[That's silly!]], CR)
  end

end
V_PLUG = function()
	return   TELL([[This has no effect.]], CR)
end
V_POUR_ON = function()

  if EQUALQ(PRSO, WATER) then 
    REMOVE_CAREFULLY(PRSO)
    
    if FLAMINGQ(PRSI) then 
      TELL([[The ]], PRSI, [[ is extinguished.]], CR)
      NULL_F()
      FCLEAR(PRSI, ONBIT)
      	return FCLEAR(PRSI, FLAMEBIT)
    elseif T then 
      	return TELL([[The water spills over the ]], PRSI, [[, to the floor, and evaporates.]], CR)
    end

  elseif EQUALQ(PRSO, PUTTY) then 
    	return PERFORM(VQPUT, PUTTY, PRSI)
  elseif T then 
    	return TELL([[You can't pour that.]], CR)
  end

end
V_PRAY = function()

  if EQUALQ(HERE, SOUTH_TEMPLE) then 
    	return GOTO(FOREST_1)
  elseif T then 
    	return TELL([[If you pray enough, your prayers may be answered.]], CR)
  end

end
V_PUMP = function()

  if PASS(PRSI and NOT(EQUALQ(PRSI, PUMP))) then 
    	return TELL([[Pump it up with a ]], PRSI, [[?]], CR)
  elseif INQ(PUMP, WINNER) then 
    	return PERFORM(VQINFLATE, PRSO, PUMP)
  elseif T then 
    	return TELL([[It's really not clear how.]], CR)
  end

end
V_PUSH = function()
	return   HACK_HACK([[Pushing the ]])
end
V_PUSH_TO = function()
	return   TELL([[You can't push things to that.]], CR)
end
PRE_PUT = function()

  if NULL_F() then 
    	return false 
  elseif T then 
    	return PRE_GIVE()
  end

end
V_PUT = function()

  if PASS(FSETQ(PRSI, OPENBIT) or OPENABLEQ(PRSI) or FSETQ(PRSI, VEHBIT)) then 
  elseif T then 
    TELL([[You can't do that.]], CR)
    	return true
  end


  if NOT(FSETQ(PRSI, OPENBIT)) then 
    TELL([[The ]], PRSI, [[ isn't open.]], CR)
    	return THIS_IS_IT(PRSI)
  elseif EQUALQ(PRSI, PRSO) then 
    	return TELL([[How can you do that?]], CR)
  elseif INQ(PRSO, PRSI) then 
    	return TELL([[The ]], PRSO, [[ is already in the ]], PRSI, [[.]], CR)
  elseif GQ(SUB(ADD(WEIGHT(PRSI), WEIGHT(PRSO)), GETP(PRSI, "SIZE")), GETP(PRSI, "CAPACITY")) then 
    	return TELL([[There's no room.]], CR)
  elseif PASS(NOT(HELDQ(PRSO)) and FSETQ(PRSO, TRYTAKEBIT)) then 
    TELL([[You don't have the ]], PRSO, [[.]], CR)
    	return true
  elseif PASS(NOT(HELDQ(PRSO)) and NOT(ITAKE())) then 
    	return true
  elseif T then 
    MOVE(PRSO, PRSI)
    FSET(PRSO, TOUCHBIT)
    SCORE_OBJ(PRSO)
    	return TELL([[Done.]], CR)
  end

end
V_PUT_BEHIND = function()
	return   TELL([[That hiding place is too obvious.]], CR)
end
V_PUT_ON = function()

  if EQUALQ(PRSI, GROUND) then 
    PERFORM(VQDROP, PRSO)
    	return true
  elseif FSETQ(PRSI, SURFACEBIT) then 
    	return V_PUT()
  elseif T then 
    	return TELL([[There's no good surface on the ]], PRSI, [[.]], CR)
  end

end
V_PUT_UNDER = function()
	return   TELL([[You can't do that.]], CR)
end
V_RAISE = function()
	return   V_LOWER()
end
V_RAPE = function()
	return   TELL([[What a (ahem!) strange idea.]], CR)
end
PRE_READ = function()

  if NOT(LIT) then 
    	return TELL([[It is impossible to read in the dark.]], CR)
  elseif PASS(PRSI and NOT(FSETQ(PRSI, TRANSBIT))) then 
    	return TELL([[How does one look through a ]], PRSI, [[?]], CR)
  end

end
V_READ = function()

  if NOT(FSETQ(PRSO, READBIT)) then 
    	return TELL([[How does one read a ]], PRSO, [[?]], CR)
  elseif T then 
    	return TELL(GETP(PRSO, "TEXT"), CR)
  end

end
V_READ_PAGE = function()
  PERFORM(VQREAD, PRSO)
	return true
end
V_REPENT = function()
	return   TELL([[It could very well be too late!]], CR)
end
V_REPLY = function()
  TELL([[It is hardly likely that the ]], PRSO, [[ is interested.]], CR)
APPLY(function() P_CONT = nil return P_CONT end)
APPLY(function() QUOTE_FLAG = nil return QUOTE_FLAG end)
	return true
end
V_RING = function()
	return   TELL([[How, exactly, can you ring that?]], CR)
end
V_RUB = function()
	return   HACK_HACK([[Fiddling with the ]])
end
V_SAY = function()
	local V

  if NOT(P_CONT) then 
    TELL([[Say what?]], CR)
    	return true
  end

APPLY(function() QUOTE_FLAG = nil return QUOTE_FLAG end)

  if APPLY(function() V = FIND_IN(HERE, ACTORBIT) return V end) then 
    TELL([[You must address the ]], V, [[ directly.]], CR)
    APPLY(function() P_CONT = nil return P_CONT end)
  elseif NOT(EQUALQ(GET(P_LEXV, P_CONT), WQHELLO)) then 
    APPLY(function() P_CONT = nil return P_CONT end)
    TELL([[Talking to yourself is a sign of impending mental collapse.]], CR)
  end

	return true
end
V_SEARCH = function()
	return   TELL([[You find nothing unusual.]], CR)
end
V_SEND = function()

  if FSETQ(PRSO, ACTORBIT) then 
    	return TELL([[Why would you send for the ]], PRSO, [[?]], CR)
  elseif T then 
    	return TELL([[That doesn't make sends.]], CR)
  end

end
PRE_SGIVE = function()
  PERFORM(VQGIVE, PRSI, PRSO)
	return true
end
V_SGIVE = function()
	return   TELL([[Foo!]], CR)
end
V_SHAKE = function()

  if FSETQ(PRSO, ACTORBIT) then 
    	return TELL([[This seems to have no effect.]], CR)
  elseif NOT(FSETQ(PRSO, TAKEBIT)) then 
    	return TELL([[You can't take it; thus, you can't shake it!]], CR)
  elseif FSETQ(PRSO, CONTBIT) then 
    
    if FSETQ(PRSO, OPENBIT) then 
      
      if FIRSTQ(PRSO) then 
        SHAKE_LOOP()
        TELL([[The contents of the ]], D, PRSO, [[ spill ]])
        
        if NOT(FSETQ(HERE, RLANDBIT)) then 
          TELL([[out and disappear]])
        elseif T then 
          TELL([[to the ground]])
        end

        	return TELL([[.]], CR)
      elseif T then 
        	return TELL([[Shaken.]], CR)
      end

    elseif T then 
      
      if FIRSTQ(PRSO) then 
        	return TELL([[It sounds like there is something inside the ]], PRSO, [[.]], CR)
      elseif T then 
        	return TELL([[The ]], D, PRSO, [[ sounds empty.]], CR)
      end

    end

  elseif T then 
    	return TELL([[Shaken.]], CR)
  end

end
SHAKE_LOOP = function()
	local X

  while true do
    
    if APPLY(function() X = FIRSTQ(PRSO) return X end) then 
      FSET(X, TOUCHBIT)
      	return MOVE(X, APPLY(function()
        if EQUALQ(HERE, UP_A_TREE) then 
          -- 	return PATH
        elseif NOT(FSETQ(HERE, RLANDBIT)) then 
          -- 	return PSEUDO_OBJECT
        elseif T then 
          -- 	return HERE
        end
 end))
    elseif T then 
      break 
    end

  end

end
V_SKIP = function()
	return   TELL(PICK_ONE(WHEEEEE), CR)
end
WHEEEEE = {0,[[Very good. Now you can go to the second grade.]],[[Are you enjoying yourself?]],[[Wheeeeeeeeee!!!!!]],[[Do you expect me to applaud?]]}

V_SMELL = function()
	return   TELL([[It smells like a ]], PRSO, [[.]], CR)
end
V_SPIN = function()
	return   TELL([[You can't spin that!]], CR)
end
V_SPRAY = function()
	return   V_SQUEEZE()
end
V_SQUEEZE = function()

  if FSETQ(PRSO, ACTORBIT) then 
    TELL([[The ]], PRSO, [[ does not understand this.]])
  elseif T then 
    TELL([[How singularly useless.]])
  end

	return   CRLF()
end
V_SSPRAY = function()
	return   PERFORM(VQSPRAY, PRSI, PRSO)
end
V_STAB = function()
	local W

  if APPLY(function() W = FIND_WEAPON(WINNER) return W end) then 
    PERFORM(VQATTACK, PRSO, W)
    	return true
  elseif T then 
    	return TELL([[No doubt you propose to stab the ]], PRSO, [[ with your pinky?]], CR)
  end

end
V_STAND = function()

  if FSETQ(LOC(WINNER), VEHBIT) then 
    PERFORM(VQDISEMBARK, LOC(WINNER))
    	return true
  elseif T then 
    	return TELL([[You are already standing, I think.]], CR)
  end

end
V_STAY = function()
	return   TELL([[You will be lost without me!]], CR)
end
V_STRIKE = function()

  if FSETQ(PRSO, ACTORBIT) then 
    	return TELL([[Since you aren't versed in hand-to-hand combat, you'd better attack the ]], PRSO, [[ with a weapon.]], CR)
  elseif T then 
    PERFORM(VQLAMP_ON, PRSO)
    	return true
  end

end
V_SWIM = function()

  if EQUALQ(HERE, ON_LAKE, IN_LAKE) then 
    	return TELL([[What do you think you're doing?]], CR)
  elseif NULL_F() then 
    	return false 
  elseif T then 
    	return TELL([[Go jump in a lake!]], CR)
  end

end
V_SWING = function()

  if NOT(PRSI) then 
    	return TELL([[Whoosh!]], CR)
  elseif T then 
    	return PERFORM(VQATTACK, PRSI, PRSO)
  end

end
PRE_TAKE = function()

  if INQ(PRSO, WINNER) then 
    
    if FSETQ(PRSO, WEARBIT) then 
      	return TELL([[You are already wearing it.]], CR)
    elseif T then 
      	return TELL([[You already have that!]], CR)
    end

  elseif PASS(FSETQ(LOC(PRSO), CONTBIT) and NOT(FSETQ(LOC(PRSO), OPENBIT))) then 
    TELL([[You can't reach something that's inside a closed container.]], CR)
    	return true
  elseif PRSI then 
    
    if EQUALQ(PRSI, GROUND) then 
      APPLY(function() PRSI = nil return PRSI end)
      	return false 
    end

    NULL_F()
    
    if NOT(EQUALQ(PRSI, LOC(PRSO))) then 
      	return TELL([[The ]], PRSO, [[ isn't in the ]], PRSI, [[.]], CR)
    elseif T then 
      APPLY(function() PRSI = nil return PRSI end)
      	return false 
    end

  elseif EQUALQ(PRSO, LOC(WINNER)) then 
    	return TELL([[You're inside of it!]], CR)
  end

end
V_TAKE = function()

  if EQUALQ(ITAKE(), T) then 
    
    if FSETQ(PRSO, WEARBIT) then 
      	return TELL([[You are now wearing the ]], PRSO, [[.]], CR)
    elseif T then 
      	return TELL([[Taken.]], CR)
    end

  end

end
V_TELL = function()

  if FSETQ(PRSO, ACTORBIT) then 
    
    if P_CONT then 
      APPLY(function() WINNER = PRSO return WINNER end)
      	return APPLY(function() HERE = LOC(WINNER) return HERE end)
    elseif T then 
      	return TELL([[The ]], PRSO, [[ pauses for a moment, perhaps thinking that you should reread
the manual.]], CR)
    end

  elseif T then 
    TELL([[You can't talk to the ]], PRSO, [[!]], CR)
    APPLY(function() QUOTE_FLAG = nil return QUOTE_FLAG end)
    APPLY(function() P_CONT = nil return P_CONT end)
    	return RFATAL()
  end

end
V_THROUGH = function(OBJ)
	local M
  OBJ = OBJ or nil

  if PASS(FSETQ(PRSO, DOORBIT) and APPLY(function() M = OTHER_SIDE(PRSO) return M end)) then 
    DO_WALK(M)
    	return true
  elseif PASS(NOT(OBJ) and FSETQ(PRSO, VEHBIT)) then 
    PERFORM(VQBOARD, PRSO)
    	return true
  elseif PASS(OBJ or NOT(FSETQ(PRSO, TAKEBIT))) then 
    NULL_F()
    	return TELL([[You hit your head against the ]], PRSO, [[ as you attempt this feat.]], CR)
  elseif INQ(PRSO, WINNER) then 
    	return TELL([[That would involve quite a contortion!]], CR)
  elseif T then 
    	return TELL(PICK_ONE(YUKS), CR)
  end

end
V_THROW = function()

  if IDROP() then 
    
    if EQUALQ(PRSI, ME) then 
      TELL([[A terrific throw! The ]], PRSO)
      APPLY(function() WINNER = PLAYER return WINNER end)
      	return JIGS_UP([[ hits you squarely in the head. Normally,
this wouldn't do much damage, but by incredible mischance, you fall over
backwards trying to duck, and break your neck, justice being swift and
merciful in the Great Underground Empire.]])
    elseif PASS(PRSI and FSETQ(PRSI, ACTORBIT)) then 
      	return TELL([[The ]], PRSI, [[ ducks as the ]], PRSO, [[ flies by and crashes to the ground.]], CR)
    elseif T then 
      	return TELL([[Thrown.]], CR)
    end

  else 
    	return TELL([[Huh?]], CR)
  end

end
V_THROW_OFF = function()
	return   TELL([[You can't throw anything off of that!]], CR)
end
V_TIE = function()

  if EQUALQ(PRSI, WINNER) then 
    	return TELL([[You can't tie anything to yourself.]], CR)
  elseif T then 
    	return TELL([[You can't tie the ]], PRSO, [[ to that.]], CR)
  end

end
V_TIE_UP = function()
	return   TELL([[You could certainly never tie it with that!]], CR)
end
V_TREASURE = function()

  if EQUALQ(HERE, NORTH_TEMPLE) then 
    	return GOTO(TREASURE_ROOM)
  elseif EQUALQ(HERE, TREASURE_ROOM) then 
    	return GOTO(NORTH_TEMPLE)
  elseif T then 
    	return TELL([[Nothing happens.]], CR)
  end

end
PRE_TURN = function()


  if PASS(EQUALQ(PRSI, nil, ROOMS) and NOT(EQUALQ(PRSO, BOOK))) then 
    	return TELL([[Your bare hands don't appear to be enough.]], CR)
  elseif NOT(FSETQ(PRSO, TURNBIT)) then 
    	return TELL([[You can't turn that!]], CR)
  end

end
V_TURN = function()
	return   TELL([[This has no effect.]], CR)
end
V_UNLOCK = function()
	return   V_LOCK()
end
V_UNTIE = function()
	return   TELL([[This cannot be tied, so it cannot be untied!]], CR)
end
V_WAIT = function(NUM)
  NUM = NUM or 3
  TELL([[Time passes...]], CR)

  while true do
    
    if LQ(APPLY(function() NUM = SUB(NUM, 1) return NUM end), 0) then 
      break 
    elseif CLOCKER() then 
      break 
    end

  end

	return APPLY(function() CLOCK_WAIT = T return CLOCK_WAIT end)
end
V_WALK = function()
	local PT
	local PTS
	local STR
	local OBJ
	local RM

  if NOT(P_WALK_DIR) then 
    PERFORM(VQWALK_TO, PRSO)
    	return true
  elseif APPLY(function() PT = GETPT(HERE, PRSO) return PT end) then 
    
    if EQUALQ(APPLY(function() PTS = PTSIZE(PT) return PTS end), UEXIT) then 
      	return GOTO(GETB(PT, REXIT))
    elseif EQUALQ(PTS, NEXIT) then 
      TELL(GET(PT, NEXITSTR), CR)
      	return RFATAL()
    elseif EQUALQ(PTS, FEXIT) then 
      
      if APPLY(function() RM = APPLY(GET(PT, FEXITFCN)) return RM end) then 
        	return GOTO(RM)
      elseif NULL_F() then 
        	return false 
      elseif T then 
        	return RFATAL()
      end

    elseif EQUALQ(PTS, CEXIT) then 
      
      if VALUE(GETB(PT, CEXITFLAG)) then 
        	return GOTO(GETB(PT, REXIT))
      elseif APPLY(function() STR = GET(PT, CEXITSTR) return STR end) then 
        TELL(STR, CR)
        	return RFATAL()
      elseif T then 
        TELL([[You can't go that way.]], CR)
        	return RFATAL()
      end

    elseif EQUALQ(PTS, DEXIT) then 
      
      if FSETQ(APPLY(function() OBJ = GETB(PT, DEXITOBJ) return OBJ end), OPENBIT) then 
        	return GOTO(GETB(PT, REXIT))
      elseif APPLY(function() STR = GET(PT, DEXITSTR) return STR end) then 
        TELL(STR, CR)
        	return RFATAL()
      elseif T then 
        TELL([[The ]], OBJ, [[ is closed.]], CR)
        THIS_IS_IT(OBJ)
        	return RFATAL()
      end

    end

  elseif PASS(NOT(LIT) and PROB(80) and EQUALQ(WINNER, ADVENTURER) and NOT(FSETQ(HERE, NONLANDBIT))) then 
    
    if SPRAYEDQ then 
      TELL([[There are odd noises in the darkness, and there is no exit in that
direction.]], CR)
      	return RFATAL()
    elseif NULL_F() then 
      	return false 
    elseif T then 
      	return JIGS_UP([[Oh, no! You have walked into the slavering fangs of a lurking grue!]])
    end

  elseif T then 
    TELL([[You can't go that way.]], CR)
    	return RFATAL()
  end

end
V_WALK_AROUND = function()
	return   TELL([[Use compass directions for movement.]], CR)
end
V_WALK_TO = function()

  if PASS(PRSO and PASS(INQ(PRSO, HERE) or GLOBAL_INQ(PRSO, HERE))) then 
    	return TELL([[It's here!]], CR)
  elseif T then 
    	return TELL([[You should supply a direction!]], CR)
  end

end
V_WAVE = function()
	return   HACK_HACK([[Waving the ]])
end
V_WEAR = function()

  if NOT(FSETQ(PRSO, WEARBIT)) then 
    	return TELL([[You can't wear the ]], PRSO, [[.]], CR)
  elseif T then 
    PERFORM(VQTAKE, PRSO)
    	return true
  end

end
V_WIN = function()
	return   TELL([[Naturally!]], CR)
end
V_WIND = function()
	return   TELL([[You cannot wind up a ]], PRSO, [[.]], CR)
end
V_WISH = function()
	return   TELL([[With luck, your wish will come true.]], CR)
end
V_YELL = function()
	return   TELL([[Aaaarrrrgggghhhh!]], CR)
end
V_ZORK = function()
	return   TELL([[At your service!]], CR)
end
LIT = nil
SPRAYEDQ = nil
V_FIRST_LOOK = function()

  if DESCRIBE_ROOM() then 
    
    if NOT(SUPER_BRIEF) then 
      	return DESCRIBE_OBJECTS()
    end

  end

end
DESCRIBE_ROOM = function(LOOKQ)
	local VQ
	local STR
	local AV
  LOOKQ = LOOKQ or nil
APPLY(function() VQ = PASS(LOOKQ or VERBOSE) return VQ end)

  if NOT(LIT) then 
    TELL([[It is pitch black.]])
    
    if NOT(SPRAYEDQ) then 
      TELL([[ You are likely to be eaten by a grue.]])
    end

    CRLF()
    NULL_F()
    	return false 
  end


  if NOT(FSETQ(HERE, TOUCHBIT)) then 
    FSET(HERE, TOUCHBIT)
    APPLY(function() VQ = T return VQ end)
  end


  if FSETQ(HERE, MAZEBIT) then 
    FCLEAR(HERE, TOUCHBIT)
  end


  if INQ(HERE, ROOMS) then 
    TELL(HERE)
    
    if FSETQ(APPLY(function() AV = LOC(WINNER) return AV end), VEHBIT) then 
      TELL([[, in the ]], AV)
    end

    CRLF()
  end


  if PASS(LOOKQ or NOT(SUPER_BRIEF)) then 
    APPLY(function() AV = LOC(WINNER) return AV end)
    
    if PASS(VQ and APPLY(GETP(HERE, "ACTION"), M_LOOK)) then 
      	return true
    elseif PASS(VQ and APPLY(function() STR = GETP(HERE, "LDESC") return STR end)) then 
      TELL(STR, CR)
    elseif T then 
      APPLY(GETP(HERE, "ACTION"), M_FLASH)
    end

    
    if PASS(NOT(EQUALQ(HERE, AV)) and FSETQ(AV, VEHBIT)) then 
      APPLY(GETP(AV, "ACTION"), M_LOOK)
    end

  end

	return T
end
DESCRIBE_OBJECTS = function(VQ)
  VQ = VQ or nil

  if LIT then 
    
    if FIRSTQ(HERE) then 
      	return PRINT_CONT(HERE, APPLY(function() VQ = PASS(VQ or VERBOSE) return VQ end), -1)
    end

  elseif T then 
    	return TELL([[Only bats can see in the dark. And you're not one.]], CR)
  end

end
DESC_OBJECT = nil
DESCRIBE_OBJECT = function(OBJ, VQ, LEVEL)
  local STR = nil
	local AV
APPLY(function() DESC_OBJECT = OBJ return DESC_OBJECT end)

  if PASS(ZEROQ(LEVEL) and APPLY(GETP(OBJ, "DESCFCN"), M_OBJDESC)) then 
    	return true
  elseif PASS(ZEROQ(LEVEL) and PASS(PASS(NOT(FSETQ(OBJ, TOUCHBIT)) and APPLY(function() STR = GETP(OBJ, "FDESC") return STR end)) or APPLY(function() STR = GETP(OBJ, "LDESC") return STR end))) then 
    TELL(STR)
  elseif ZEROQ(LEVEL) then 
    TELL([[There is a ]], OBJ, [[ here]])
    
    if FSETQ(OBJ, ONBIT) then 
      TELL([[ (providing light)]])
    end

    TELL([[.]])
  elseif T then 
    TELL(GET(INDENTS, LEVEL))
    TELL([[A ]], OBJ)
    
    if FSETQ(OBJ, ONBIT) then 
      TELL([[ (providing light)]])
    elseif PASS(FSETQ(OBJ, WEARBIT) and INQ(OBJ, WINNER)) then 
      TELL([[ (being worn)]])
    end

  end

  NULL_F()

  if PASS(ZEROQ(LEVEL) and APPLY(function() AV = LOC(WINNER) return AV end) and FSETQ(AV, VEHBIT)) then 
    TELL([[ (outside the ]], AV, [[)]])
  end

  CRLF()

  if PASS(SEE_INSIDEQ(OBJ) and FIRSTQ(OBJ)) then 
    	return PRINT_CONT(OBJ, VQ, LEVEL)
  end

end
PRINT_CONTENTS = function(OBJ)
	local F
	local N
  local bSTQ = T
  local ITQ = nil
  local TWOQ = nil

  if APPLY(function() F = FIRSTQ(OBJ) return F end) then 
    
    while true do
      APPLY(function() N = NEXTQ(F) return N end)      
      if bSTQ then 
        APPLY(function() bSTQ = nil return bSTQ end)
      else 
        TELL([[, ]])
        
        if NOT(N) then 
          TELL([[and ]])
        end

      end
      TELL([[a ]], F)      
      if PASS(NOT(ITQ) and NOT(TWOQ)) then 
        APPLY(function() ITQ = F return ITQ end)
      else 
        APPLY(function() TWOQ = T return TWOQ end)
        APPLY(function() ITQ = nil return ITQ end)
      end
      APPLY(function() F = N return F end)      
      if NOT(F) then 
        
        if PASS(ITQ and NOT(TWOQ)) then 
          THIS_IS_IT(ITQ)
        end

        	return true
      end

    end

  end

end
PRINT_CONT = function(OBJ, VQ, LEVEL)
	local Y
	local bSTQ
	local SHIT
	local AV
	local STR
  local PVQ = nil
  local INVQ = nil
  VQ = VQ or nil
  LEVEL = LEVEL or 0

  if NOT(APPLY(function() Y = FIRSTQ(OBJ) return Y end)) then 
    	return true
  end


  if PASS(APPLY(function() AV = LOC(WINNER) return AV end) and FSETQ(AV, VEHBIT)) then 
    -- T
  else 
    APPLY(function() AV = nil return AV end)
  end

APPLY(function() bSTQ = T return bSTQ end)
APPLY(function() SHIT = T return SHIT end)

  if EQUALQ(WINNER, OBJ, LOC(OBJ)) then 
    APPLY(function() INVQ = T return INVQ end)
  else 
    
    while true do
      
      if NOT(Y) then 
        break 
      elseif EQUALQ(Y, AV) then 
        APPLY(function() PVQ = T return PVQ end)
      elseif EQUALQ(Y, WINNER) then 
      elseif PASS(NOT(FSETQ(Y, INVISIBLE)) and NOT(FSETQ(Y, TOUCHBIT)) and APPLY(function() STR = GETP(Y, "FDESC") return STR end)) then 
        
        if NOT(FSETQ(Y, NDESCBIT)) then 
          TELL(STR, CR)
          APPLY(function() SHIT = nil return SHIT end)
        end

        
        if PASS(SEE_INSIDEQ(Y) and NOT(GETP(LOC(Y), "DESCFCN")) and FIRSTQ(Y)) then 
          
          if PRINT_CONT(Y, VQ, 0) then 
            APPLY(function() bSTQ = nil return bSTQ end)
          end

        end

      end
      APPLY(function() Y = NEXTQ(Y) return Y end)
    end

  end

APPLY(function() Y = FIRSTQ(OBJ) return Y end)

  while true do
    
    if NOT(Y) then 
      
      if PASS(PVQ and AV and FIRSTQ(AV)) then 
        APPLY(function() LEVEL = ADD(LEVEL, 1) return LEVEL end)
        PRINT_CONT(AV, VQ, LEVEL)
      end

      break 
    elseif EQUALQ(Y, AV, ADVENTURER) then 
    elseif PASS(NOT(FSETQ(Y, INVISIBLE)) and PASS(INVQ or FSETQ(Y, TOUCHBIT) or NOT(GETP(Y, "FDESC")))) then 
      
      if NOT(FSETQ(Y, NDESCBIT)) then 
        
        if bSTQ then 
          
          if FIRSTER(OBJ, LEVEL) then 
            
            if LQ(LEVEL, 0) then 
              APPLY(function() LEVEL = 0 return LEVEL end)
            end

          end

          APPLY(function() LEVEL = ADD(1, LEVEL) return LEVEL end)
          APPLY(function() bSTQ = nil return bSTQ end)
        end

        
        if LQ(LEVEL, 0) then 
          APPLY(function() LEVEL = 0 return LEVEL end)
        end

        DESCRIBE_OBJECT(Y, VQ, LEVEL)
      elseif PASS(FIRSTQ(Y) and SEE_INSIDEQ(Y)) then 
        APPLY(function() LEVEL = ADD(LEVEL, 1) return LEVEL end)
        PRINT_CONT(Y, VQ, LEVEL)
        APPLY(function() LEVEL = SUB(LEVEL, 1) return LEVEL end)
      end

    end
    APPLY(function() Y = NEXTQ(Y) return Y end)
  end


  if PASS(bSTQ and SHIT) then 
    	return false 
  elseif T then 
    	return true
  end

end
FIRSTER = function(OBJ, LEVEL)

  if EQUALQ(OBJ, TROPHY_CASE) then 
    	return TELL([[Your collection of treasures consists of:]], CR)
  elseif EQUALQ(OBJ, WINNER) then 
    	return TELL([[You are carrying:]], CR)
  elseif NOT(INQ(OBJ, ROOMS)) then 
    
    if GQ(LEVEL, 0) then 
      TELL(GET(INDENTS, LEVEL))
    end

    
    if FSETQ(OBJ, SURFACEBIT) then 
      	return TELL([[Sitting on the ]], OBJ, [[ is: ]], CR)
    elseif FSETQ(OBJ, ACTORBIT) then 
      	return TELL([[The ]], OBJ, [[ is holding: ]], CR)
    elseif T then 
      	return TELL([[The ]], OBJ, [[ contains:]], CR)
    end

  end

end
SEE_INSIDEQ = function(OBJ)
	return   PASS(NOT(FSETQ(OBJ, INVISIBLE)) and PASS(FSETQ(OBJ, TRANSBIT) or FSETQ(OBJ, OPENBIT)))
end
MOVES = 0
SCORE = 0
BASE_SCORE = 0
WON_FLAG = nil
SCORE_UPD = function(NUM)
APPLY(function() BASE_SCORE = ADD(BASE_SCORE, NUM) return BASE_SCORE end)
APPLY(function() SCORE = ADD(SCORE, NUM) return SCORE end)

  if PASS(EQUALQ(SCORE, 350) and NOT(WON_FLAG)) then 
    APPLY(function() WON_FLAG = T return WON_FLAG end)
    FCLEAR(MAP, INVISIBLE)
    FCLEAR(WEST_OF_HOUSE, TOUCHBIT)
    TELL([[An almost inaudible voice whispers in your ear, "Look to your treasures
for the final secret."]], CR)
  end

	return T
end
SCORE_OBJ = function(OBJ)
	local TEMP

  if GQ(APPLY(function() TEMP = GETP(OBJ, "VALUE") return TEMP end), 0) then 
    SCORE_UPD(TEMP)
    	return PUTP(OBJ, "VALUE", 0)
  end

end
YESQ = function()
  PRINTI([[>]])
  READ(P_INBUF, P_LEXV)

  if EQUALQ(GET(P_LEXV, 1), WQYES, WQY) then 
    	return true
  elseif T then 
    	return false 
  end

end
DEAD = nil
DEATHS = 0
LUCKY = 1
FUMBLE_NUMBER = 7
FUMBLE_PROB = 8
ITAKE = function(VB)
	local CNT
	local OBJ
  VB = VB or T

  if DEAD then 
    
    if VB then 
      TELL([[Your hand passes through its object.]], CR)
    end

    	return false 
  elseif NOT(FSETQ(PRSO, TAKEBIT)) then 
    
    if VB then 
      TELL(PICK_ONE(YUKS), CR)
    end

    	return false 
  elseif NULL_F() then 
    	return false 
  elseif PASS(FSETQ(LOC(PRSO), CONTBIT) and NOT(FSETQ(LOC(PRSO), OPENBIT))) then 
    	return false 
  elseif PASS(NOT(INQ(LOC(PRSO), WINNER)) and GQ(ADD(WEIGHT(PRSO), WEIGHT(WINNER)), LOAD_ALLOWED)) then 
    
    if VB then 
      TELL([[Your load is too heavy]])
      
      if LQ(LOAD_ALLOWED, LOAD_MAX) then 
        TELL([[, especially in light of your condition.]])
      elseif T then 
        TELL([[.]])
      end

      CRLF()
    end

    	return RFATAL()
  elseif PASS(VERBQ(TAKE) and GQ(APPLY(function() CNT = CCOUNT(WINNER) return CNT end), FUMBLE_NUMBER) and PROB(MULL(CNT, FUMBLE_PROB))) then 
    TELL([[You're holding too many things already!]], CR)
    	return false 
  elseif T then 
    MOVE(PRSO, WINNER)
    FCLEAR(PRSO, NDESCBIT)
    FSET(PRSO, TOUCHBIT)
    NULL_F()
    NULL_F()
    	return true
  end

end
IDROP = function()

  if PASS(NOT(INQ(PRSO, WINNER)) and NOT(INQ(LOC(PRSO), WINNER))) then 
    TELL([[You're not carrying the ]], PRSO, [[.]], CR)
    	return false 
  elseif PASS(NOT(INQ(PRSO, WINNER)) and NOT(FSETQ(LOC(PRSO), OPENBIT))) then 
    TELL([[The ]], PRSO, [[ is closed.]], CR)
    	return false 
  elseif T then 
    MOVE(PRSO, LOC(WINNER))
    	return true
  end

end
CCOUNT = function(OBJ)
  local CNT = 0
	local X

  if APPLY(function() X = FIRSTQ(OBJ) return X end) then 
    
    while true do
      
      if NOT(FSETQ(X, WEARBIT)) then 
        APPLY(function() CNT = ADD(CNT, 1) return CNT end)
      end
      
      if NOT(APPLY(function() X = NEXTQ(X) return X end)) then 
        break 
      end

    end

  end

	return CNT
end
WEIGHT = function(OBJ)
	local CONT
  local WT = 0

  if APPLY(function() CONT = FIRSTQ(OBJ) return CONT end) then 
    
    while true do
      
      if PASS(EQUALQ(OBJ, PLAYER) and FSETQ(CONT, WEARBIT)) then 
        APPLY(function() WT = ADD(WT, 1) return WT end)
      elseif T then 
        APPLY(function() WT = ADD(WT, WEIGHT(CONT)) return WT end)
      end
      
      if NOT(APPLY(function() CONT = NEXTQ(CONT) return CONT end)) then 
        break 
      end

    end

  end

	return   ADD(WT, GETP(OBJ, "SIZE"))
end
REXIT = 0
UEXIT = 1
NEXIT = 2
FEXIT = 3
CEXIT = 4
DEXIT = 5
NEXITSTR = 0
FEXITFCN = 0
CEXITFLAG = 1
CEXITSTR = 1
DEXITOBJ = 1
DEXITSTR = 1
INDENTS = {[[]],[[  ]],[[    ]],[[      ]],[[        ]],[[          ]]}

HACK_HACK = function(STR)

  if PASS(INQ(PRSO, GLOBAL_OBJECTS) and VERBQ(WAVE, RAISE, LOWER)) then 
    	return TELL([[The ]], PRSO, [[ isn't here!]], CR)
  elseif T then 
    	return TELL(STR, PRSO, PICK_ONE(HO_HUM), CR)
  end

end
HO_HUM = {0,[[ doesn't seem to work.]],[[ isn't notably helpful.]],[[ has no effect.]]}

NO_GO_TELL = function(AV, WLOC)

  if AV then 
    TELL([[You can't go there in a ]], WLOC, [[.]])
  elseif T then 
    TELL([[You can't go there without a vehicle.]])
  end

	return   CRLF()
end
GOTO = function(RM, VQ)
  local LB = FSETQ(RM, RLANDBIT)
  local WLOC = LOC(WINNER)
  local AV = nil
	local OLIT
	local OHERE
  VQ = VQ or T
APPLY(function() OLIT = LIT return OLIT end)
APPLY(function() OHERE = HERE return OHERE end)

  if FSETQ(WLOC, VEHBIT) then 
    APPLY(function() AV = GETP(WLOC, "VTYPE") return AV end)
  end


  if PASS(NOT(LB) and NOT(AV)) then 
    NO_GO_TELL(AV, WLOC)
    	return false 
  elseif PASS(NOT(LB) and NOT(FSETQ(RM, AV))) then 
    NO_GO_TELL(AV, WLOC)
    	return false 
  elseif PASS(FSETQ(HERE, RLANDBIT) and LB and AV and NOT(EQUALQ(AV, RLANDBIT)) and NOT(FSETQ(RM, AV))) then 
    NO_GO_TELL(AV, WLOC)
    	return false 
  elseif FSETQ(RM, RMUNGBIT) then 
    TELL(GETP(RM, "LDESC"), CR)
    	return false 
  elseif T then 
    
    if PASS(LB and NOT(FSETQ(HERE, RLANDBIT)) and NOT(DEAD) and FSETQ(WLOC, VEHBIT)) then 
      TELL([[The ]], WLOC, [[ comes to a rest on the shore.]], CR, CR)
    end

    
    if AV then 
      MOVE(WLOC, RM)
    elseif T then 
      MOVE(WINNER, RM)
    end

    APPLY(function() HERE = RM return HERE end)
    APPLY(function() LIT = LITQ(HERE) return LIT end)
    
    if PASS(NOT(OLIT) and NOT(LIT) and PROB(80)) then 
      
      if SPRAYEDQ then 
        TELL([[There are sinister gurgling noises in the darkness all around you!]], CR)
      elseif NULL_F() then 
        	return false 
      elseif T then 
        TELL([[Oh, no! A lurking grue slithered into the ]])
        
        if FSETQ(LOC(WINNER), VEHBIT) then 
          TELL(LOC(WINNER))
        elseif T then 
          TELL([[room]])
        end

        JIGS_UP([[ and devoured you!]])
        	return true
      end

    end

    
    if PASS(NOT(LIT) and EQUALQ(WINNER, ADVENTURER)) then 
      TELL([[You have moved into a dark place.]], CR)
      APPLY(function() P_CONT = nil return P_CONT end)
    end

    APPLY(GETP(HERE, "ACTION"), M_ENTER)
    SCORE_OBJ(RM)
    
    if NOT(EQUALQ(HERE, RM)) then 
      	return true
    elseif PASS(NOT(EQUALQ(ADVENTURER, WINNER)) and INQ(ADVENTURER, OHERE)) then 
      TELL([[The ]], WINNER, [[ leaves the room.]], CR)
    elseif PASS(EQUALQ(HERE, OHERE) and EQUALQ(HERE, ENTRANCE_TO_HADES)) then 
      	return true
    elseif PASS(VQ and EQUALQ(WINNER, ADVENTURER)) then 
      V_FIRST_LOOK()
    end

    	return true
  end

end
LKP = function(ITM, TBL)
  local CNT = 0
  local LEN = GET(TBL, 0)

  while true do
    
    if GQ(APPLY(function() CNT = ADD(CNT, 1) return CNT end), LEN) then 
      	return false 
    elseif EQUALQ(GET(TBL, CNT), ITM) then 
      
      if EQUALQ(CNT, LEN) then 
        	return false 
      elseif T then 
        return GET(TBL, ADD(CNT, 1))
      end

    end

  end

end
DO_WALK = function(DIR)
APPLY(function() P_WALK_DIR = DIR return P_WALK_DIR end)
	return   PERFORM(VQWALK, DIR)
end
GLOBAL_INQ = function(OBJ1, OBJ2)
	local TX

  if APPLY(function() TX = GETPT(OBJ2, "GLOBAL") return TX end) then 
    	return ZMEMQB(OBJ1, TX, SUB(PTSIZE(TX), 1))
  end

end
FIND_IN = function(WHERE, WHAT)
	local W
APPLY(function() W = FIRSTQ(WHERE) return W end)

  if NOT(W) then 
    	return false 
  end


  while true do
    
    if PASS(FSETQ(W, WHAT) and NOT(EQUALQ(W, ADVENTURER))) then 
      return W
    elseif NOT(APPLY(function() W = NEXTQ(W) return W end)) then 
      return nil
    end

  end

end
HELDQ = function(CAN)

  while true do
    APPLY(function() CAN = LOC(CAN) return CAN end)    
    if NOT(CAN) then 
      	return false 
    elseif EQUALQ(CAN, WINNER) then 
      	return true
    end

  end

end
OTHER_SIDE = function(DOBJ)
  local P = 0
	local TX

  while true do
    
    if LQ(APPLY(function() P = NEXTP(HERE, P) return P end), LOW_DIRECTION) then 
      return nil
    else 
      APPLY(function() TX = GETPT(HERE, P) return TX end)
      
      if PASS(EQUALQ(PTSIZE(TX), DEXIT) and EQUALQ(GETB(TX, DEXITOBJ), DOBJ)) then 
        return P
      end

    end

  end

end
MUNG_ROOM = function(RM, STR)

  FSET(RM, RMUNGBIT)
	return   PUTP(RM, "LDESC", STR)
end
THIS_IS_IT = function(OBJ)
	return APPLY(function() P_IT_OBJECT = OBJ return P_IT_OBJECT end)
end

if   NEQUALQ(ZORK_NUMBER, 3) then 
  SWIMYUKS = {0,[[You can't swim in the dungeon.]]}


end
HELLOS = {0,[[Hello.]],[[Good day.]],[[Nice weather we've been having lately.]],[[Goodbye.]]}

YUKS = {0,[[A valiant attempt.]],[[You can't be serious.]],[[An interesting idea...]],[[What a concept!]]}

DUMMY = {0,[[Look around.]],[[Too late for that.]],[[Have your eyes checked.]]}

