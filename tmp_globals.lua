GLOBAL_OBJECTS = setmetatable({}, { __tostring = function(self) return self.DESC or "GLOBAL_OBJECTS" end })
OBJECTS["GLOBAL_OBJECTS"] = GLOBAL_OBJECTS
LOCAL_GLOBALS = setmetatable({}, { __tostring = function(self) return self.DESC or "LOCAL_GLOBALS" end })
OBJECTS["LOCAL_GLOBALS"] = LOCAL_GLOBALS
ROOMS = setmetatable({}, { __tostring = function(self) return self.DESC or "ROOMS" end })
OBJECTS["ROOMS"] = ROOMS
INTNUM = setmetatable({}, { __tostring = function(self) return self.DESC or "INTNUM" end })
OBJECTS["INTNUM"] = INTNUM
PSEUDO_OBJECT = setmetatable({}, { __tostring = function(self) return self.DESC or "PSEUDO_OBJECT" end })
OBJECTS["PSEUDO_OBJECT"] = PSEUDO_OBJECT
IT = setmetatable({}, { __tostring = function(self) return self.DESC or "IT" end })
OBJECTS["IT"] = IT
NOT_HERE_OBJECT = setmetatable({}, { __tostring = function(self) return self.DESC or "NOT_HERE_OBJECT" end })
OBJECTS["NOT_HERE_OBJECT"] = NOT_HERE_OBJECT
NOT_HERE_OBJECT_F = nil
NOT_HERE_PRINT = nil
NULL_F = nil
BLESSINGS = setmetatable({}, { __tostring = function(self) return self.DESC or "BLESSINGS" end })
OBJECTS["BLESSINGS"] = BLESSINGS
STAIRS = setmetatable({}, { __tostring = function(self) return self.DESC or "STAIRS" end })
OBJECTS["STAIRS"] = STAIRS
STAIRS_F = nil
SAILOR = setmetatable({}, { __tostring = function(self) return self.DESC or "SAILOR" end })
OBJECTS["SAILOR"] = SAILOR
SAILOR_FCN = nil
GROUND = setmetatable({}, { __tostring = function(self) return self.DESC or "GROUND" end })
OBJECTS["GROUND"] = GROUND
GROUND_FUNCTION = nil
GRUE = setmetatable({}, { __tostring = function(self) return self.DESC or "GRUE" end })
OBJECTS["GRUE"] = GRUE
GRUE_FUNCTION = nil
LUNGS = setmetatable({}, { __tostring = function(self) return self.DESC or "LUNGS" end })
OBJECTS["LUNGS"] = LUNGS
ME = setmetatable({}, { __tostring = function(self) return self.DESC or "ME" end })
OBJECTS["ME"] = ME
CRETIN_FCN = nil
ADVENTURER = setmetatable({}, { __tostring = function(self) return self.DESC or "ADVENTURER" end })
OBJECTS["ADVENTURER"] = ADVENTURER
PATHOBJ = setmetatable({}, { __tostring = function(self) return self.DESC or "PATHOBJ" end })
OBJECTS["PATHOBJ"] = PATHOBJ
PATH_OBJECT = nil
ZORKMID = setmetatable({}, { __tostring = function(self) return self.DESC or "ZORKMID" end })
OBJECTS["ZORKMID"] = ZORKMID
ZORKMID_FUNCTION = nil
HANDS = setmetatable({}, { __tostring = function(self) return self.DESC or "HANDS" end })
OBJECTS["HANDS"] = HANDS

GLOBAL_OBJECTS.FLAGS = RMUNGBIT|INVISIBLE|TOUCHBIT|SURFACEBIT|TRYTAKEBIT|OPENBIT|SEARCHBIT|TRANSBIT|ONBIT|RLANDBIT|FIGHTBIT|STAGGERED|WEARBIT
LOCAL_GLOBALS.IN = GLOBAL_OBJECTS
LOCAL_GLOBALS.SYNONYM = {"ZZMGCK"}
LOCAL_GLOBALS.DESCFCN = PATH_OBJECT
LOCAL_GLOBALS.GLOBAL = GLOBAL_OBJECTS
LOCAL_GLOBALS.ADVFCN = 0
LOCAL_GLOBALS.FDESC = [[F]]
LOCAL_GLOBALS.LDESC = [[F]]
LOCAL_GLOBALS.PSEUDO = [[FOOBAR]]
LOCAL_GLOBALS.CONTFCN = 0
LOCAL_GLOBALS.VTYPE = 1
LOCAL_GLOBALS.SIZE = 0
LOCAL_GLOBALS.CAPACITY = 0
ROOMS.NAV_IN = function() return ROOMS end
INTNUM.IN = GLOBAL_OBJECTS
INTNUM.SYNONYM = {"INTNUM"}
INTNUM.FLAGS = TOOLBIT
INTNUM.DESC = [[number]]
PSEUDO_OBJECT.IN = LOCAL_GLOBALS
PSEUDO_OBJECT.DESC = [[pseudo]]
PSEUDO_OBJECT.ACTION = CRETIN_FCN
IT.IN = GLOBAL_OBJECTS
IT.SYNONYM = {"IT","THEM","HER","HIM"}
IT.DESC = [[random object]]
IT.FLAGS = NDESCBIT|TOUCHBIT
NOT_HERE_OBJECT.DESC = [[such thing]]
NOT_HERE_OBJECT.ACTION = NOT_HERE_OBJECT_F
NOT_HERE_OBJECT_F = function()
	local TBL
  local PRSOQ = T
	local OBJ

  if PASS(EQUALQ(PRSO, NOT_HERE_OBJECT) and EQUALQ(PRSI, NOT_HERE_OBJECT)) then 
    TELL([[Those things aren't here!]], CR)
    	return true
  elseif EQUALQ(PRSO, NOT_HERE_OBJECT) then 
    APPLY(function() TBL = P_PRSO return TBL end)
  elseif T then 
    APPLY(function() TBL = P_PRSI return TBL end)
    APPLY(function() PRSOQ = nil return PRSOQ end)
  end

APPLY(function() P_CONT = nil return P_CONT end)
APPLY(function() QUOTE_FLAG = nil return QUOTE_FLAG end)

  if EQUALQ(WINNER, PLAYER) then 
    TELL([[You can't see any ]])
    NOT_HERE_PRINT(PRSOQ)
    TELL([[ here!]], CR)
  elseif T then 
    TELL([[The ]], WINNER, [[ seems confused. "I don't see any ]])
    NOT_HERE_PRINT(PRSOQ)
    TELL([[ here!"]], CR)
  end

	return true
end
NOT_HERE_PRINT = function(PRSOQ)

  if P_OFLAG then 
    
    if P_XADJ then 
      PRINTB(P_XADJN)
    end

    
    if P_XNAM then 
      	return PRINTB(P_XNAM)
    end

  elseif PRSOQ then 
    	return BUFFER_PRINT(GET(P_ITBL, P_NC1), GET(P_ITBL, P_NC1L), nil)
  elseif T then 
    	return BUFFER_PRINT(GET(P_ITBL, P_NC2), GET(P_ITBL, P_NC2L), nil)
  end

end
NULL_F = function(A1, A2)
	return false 
end
LOAD_MAX = 100
LOAD_ALLOWED = 100
BLESSINGS.IN = GLOBAL_OBJECTS
BLESSINGS.SYNONYM = {"BLESSINGS","GRACES"}
BLESSINGS.DESC = [[blessings]]
BLESSINGS.FLAGS = NDESCBIT
STAIRS.IN = LOCAL_GLOBALS
STAIRS.SYNONYM = {"STAIRS","STEPS","STAIRCASE","STAIRWAY"}
STAIRS.ADJECTIVE = {"STONE","DARK","MARBLE","FORBIDDING","STEEP"}
STAIRS.DESC = [[stairs]]
STAIRS.FLAGS = NDESCBIT|CLIMBBIT
STAIRS.ACTION = STAIRS_F
STAIRS_F = function()

  if VERBQ(THROUGH) then 
    	return TELL([[You should say whether you want to go up or down.]], CR)
  end

end
SAILOR.IN = GLOBAL_OBJECTS
SAILOR.SYNONYM = {"SAILOR","FOOTPAD","AVIATOR"}
SAILOR.DESC = [[sailor]]
SAILOR.FLAGS = NDESCBIT
SAILOR.ACTION = SAILOR_FCN
SAILOR_FCN = function()

  if VERBQ(TELL) then 
    APPLY(function() P_CONT = nil return P_CONT end)
    APPLY(function() QUOTE_FLAG = nil return QUOTE_FLAG end)
    	return TELL([[You can't talk to the sailor that way.]], CR)
  elseif VERBQ(EXAMINE) then 
    -- 
    	return TELL([[There is no sailor to be seen.]], CR)
  elseif VERBQ(HELLO) then 
    APPLY(function() HS = ADD(HS, 1) return HS end)
    
    if ZEROQ(MOD(HS, 20)) then 
      	return TELL([[You seem to be repeating yourself.]], CR)
    elseif ZEROQ(MOD(HS, 10)) then 
      	return TELL([[I think that phrase is getting a bit worn out.]], CR)
    elseif T then 
      	return TELL([[Nothing happens here.]], CR)
    end

  end

end
GROUND.IN = GLOBAL_OBJECTS
GROUND.SYNONYM = {"GROUND","SAND","DIRT","FLOOR"}
GROUND.DESC = [[ground]]
GROUND.ACTION = GROUND_FUNCTION
GROUND_FUNCTION = function()

  if PASS(VERBQ(PUT, PUT_ON) and EQUALQ(PRSI, GROUND)) then 
    PERFORM(VQDROP, PRSO)
    	return true
  elseif EQUALQ(HERE, SANDY_CAVE) then 
    	return SAND_FUNCTION()
  elseif VERBQ(DIG) then 
    	return TELL([[The ground is too hard for digging here.]], CR)
  end

end
GRUE.IN = GLOBAL_OBJECTS
GRUE.SYNONYM = {"GRUE"}
GRUE.ADJECTIVE = {"LURKING","SINISTER","HUNGRY","SILENT"}
GRUE.DESC = [[lurking grue]]
GRUE.ACTION = GRUE_FUNCTION
GRUE_FUNCTION = function()

  if VERBQ(EXAMINE) then 
    	return TELL([[The grue is a sinister, lurking presence in the dark places of the
earth. Its favorite diet is adventurers, but its insatiable
appetite is tempered by its fear of light. No grue has ever been
seen by the light of day, and few have survived its fearsome jaws
to tell the tale.]], CR)
  elseif VERBQ(FIND) then 
    	return TELL([[There is no grue here, but I'm sure there is at least one lurking
in the darkness nearby. I wouldn't let my light go out if I were
you!]], CR)
  elseif VERBQ(LISTEN) then 
    	return TELL([[It makes no sound but is always lurking in the darkness nearby.]], CR)
  end

end
LUNGS.IN = GLOBAL_OBJECTS
LUNGS.SYNONYM = {"LUNGS","AIR","MOUTH","BREATH"}
LUNGS.DESC = [[blast of air]]
LUNGS.FLAGS = NDESCBIT
ME.IN = GLOBAL_OBJECTS
ME.SYNONYM = {"ME","MYSELF","SELF","CRETIN"}
ME.DESC = [[cretin]]
ME.FLAGS = ACTORBIT
ME.ACTION = CRETIN_FCN
CRETIN_FCN = function()

  if VERBQ(TELL) then 
    APPLY(function() P_CONT = nil return P_CONT end)
    APPLY(function() QUOTE_FLAG = nil return QUOTE_FLAG end)
    	return TELL([[Talking to yourself is said to be a sign of impending mental collapse.]], CR)
  elseif PASS(VERBQ(GIVE) and EQUALQ(PRSI, ME)) then 
    PERFORM(VQTAKE, PRSO)
    	return true
  elseif VERBQ(MAKE) then 
    	return TELL([[Only you can do that.]], CR)
  elseif VERBQ(DISEMBARK) then 
    	return TELL([[You'll have to do that on your own.]], CR)
  elseif VERBQ(EAT) then 
    	return TELL([[Auto-cannibalism is not the answer.]], CR)
  elseif VERBQ(ATTACK, MUNG) then 
    
    if PASS(PRSI and FSETQ(PRSI, WEAPONBIT)) then 
      	return JIGS_UP([[If you insist.... Poof, you're dead!]])
    elseif T then 
      	return TELL([[Suicide is not the answer.]], CR)
    end

  elseif VERBQ(THROW) then 
    
    if EQUALQ(PRSO, ME) then 
      	return TELL([[Why don't you just walk like normal people?]], CR)
    end

  elseif VERBQ(TAKE) then 
    	return TELL([[How romantic!]], CR)
  elseif VERBQ(EXAMINE) then 
    
    if EQUALQ(HERE, LOC(MIRROR_1), LOC(MIRROR_2)) then 
      	return TELL([[Your image in the mirror looks tired.]], CR)
    elseif T then 
      	return TELL([[That's difficult unless your eyes are prehensile.]], CR)
    end

  end

end
ADVENTURER.SYNONYM = {"ADVENTURER"}
ADVENTURER.DESC = [[cretin]]
ADVENTURER.FLAGS = NDESCBIT|INVISIBLE|SACREDBIT|ACTORBIT
ADVENTURER.STRENGTH = 0
ADVENTURER.ACTION = 0
PATHOBJ.IN = GLOBAL_OBJECTS
PATHOBJ.SYNONYM = {"TRAIL","PATH"}
PATHOBJ.ADJECTIVE = {"FOREST","NARROW","LONG","WINDING"}
PATHOBJ.DESC = [[passage]]
PATHOBJ.FLAGS = NDESCBIT
PATHOBJ.ACTION = PATH_OBJECT
PATH_OBJECT = function()

  if VERBQ(TAKE, FOLLOW) then 
    	return TELL([[You must specify a direction to go.]], CR)
  elseif VERBQ(FIND) then 
    	return TELL([[I can't help you there....]], CR)
  elseif VERBQ(DIG) then 
    	return TELL([[Not a chance.]], CR)
  end

end
ZORKMID.IN = GLOBAL_OBJECTS
ZORKMID.SYNONYM = {"ZORKMID"}
ZORKMID.DESC = [[zorkmid]]
ZORKMID.ACTION = ZORKMID_FUNCTION
ZORKMID_FUNCTION = function()

  if VERBQ(EXAMINE) then 
    	return TELL([[The zorkmid is the unit of currency of the Great Underground Empire.]], CR)
  elseif VERBQ(FIND) then 
    	return TELL([[The best way to find zorkmids is to go out and look for them.]], CR)
  end

end
HANDS.IN = GLOBAL_OBJECTS
HANDS.SYNONYM = {"PAIR","HANDS","HAND"}
HANDS.ADJECTIVE = {"BARE"}
HANDS.DESC = [[pair of hands]]
HANDS.FLAGS = NDESCBIT|TOOLBIT
