GLOBAL_OBJECTS = setmetatable({}, { __tostring = function(self) return self.DESC or "GLOBAL_OBJECTS" end })
LOCAL_GLOBALS = setmetatable({}, { __tostring = function(self) return self.DESC or "LOCAL_GLOBALS" end })
ROOMS = setmetatable({}, { __tostring = function(self) return self.DESC or "ROOMS" end })
INTNUM = setmetatable({}, { __tostring = function(self) return self.DESC or "INTNUM" end })
PSEUDO_OBJECT = setmetatable({}, { __tostring = function(self) return self.DESC or "PSEUDO_OBJECT" end })
IT = setmetatable({}, { __tostring = function(self) return self.DESC or "IT" end })
NOT_HERE_OBJECT = setmetatable({}, { __tostring = function(self) return self.DESC or "NOT_HERE_OBJECT" end })
NOT_HERE_OBJECT_F = nil
NOT_HERE_PRINT = nil
NULL_F = nil
BLESSINGS = setmetatable({}, { __tostring = function(self) return self.DESC or "BLESSINGS" end })
STAIRS = setmetatable({}, { __tostring = function(self) return self.DESC or "STAIRS" end })
STAIRS_F = nil
SAILOR = setmetatable({}, { __tostring = function(self) return self.DESC or "SAILOR" end })
SAILOR_FCN = nil
GROUND = setmetatable({}, { __tostring = function(self) return self.DESC or "GROUND" end })
GROUND_FUNCTION = nil
GRUE = setmetatable({}, { __tostring = function(self) return self.DESC or "GRUE" end })
GRUE_FUNCTION = nil
LUNGS = setmetatable({}, { __tostring = function(self) return self.DESC or "LUNGS" end })
ME = setmetatable({}, { __tostring = function(self) return self.DESC or "ME" end })
CRETIN_FCN = nil
ADVENTURER = setmetatable({}, { __tostring = function(self) return self.DESC or "ADVENTURER" end })
PATHOBJ = setmetatable({}, { __tostring = function(self) return self.DESC or "PATHOBJ" end })
PATH_OBJECT = nil
ZORKMID = setmetatable({}, { __tostring = function(self) return self.DESC or "ZORKMID" end })
ZORKMID_FUNCTION = nil
HANDS = setmetatable({}, { __tostring = function(self) return self.DESC or "HANDS" end })

OBJECT {
	NAME = "GLOBAL_OBJECTS",
	FLAGS = (1<<RMUNGBIT)|(1<<INVISIBLE)|(1<<TOUCHBIT)|(1<<SURFACEBIT)|(1<<TRYTAKEBIT)|(1<<OPENBIT)|(1<<SEARCHBIT)|(1<<TRANSBIT)|(1<<ONBIT)|(1<<RLANDBIT)|(1<<FIGHTBIT)|(1<<STAGGERED)|(1<<WEARBIT),
}
OBJECT {
	NAME = "LOCAL_GLOBALS",
	LOC = GLOBAL_OBJECTS,
	SYNONYM = {"ZZMGCK"},
	DESCFCN = PATH_OBJECT,
	GLOBAL = GLOBAL_OBJECTS,
	ADVFCN = 0,
	FDESC = "F",
	LDESC = "F",
	PSEUDO = "FOOBAR",
	CONTFCN = 0,
	VTYPE = 1,
	SIZE = 0,
	CAPACITY = 0,
}
OBJECT {
	NAME = "ROOMS",
	IN = ROOMS,
}
OBJECT {
	NAME = "INTNUM",
	LOC = GLOBAL_OBJECTS,
	SYNONYM = {"INTNUM"},
	FLAGS = (1<<TOOLBIT),
	DESC = "number",
}
OBJECT {
	NAME = "PSEUDO_OBJECT",
	LOC = LOCAL_GLOBALS,
	DESC = "pseudo",
	ACTION = CRETIN_FCN,
}
OBJECT {
	NAME = "IT",
	LOC = GLOBAL_OBJECTS,
	SYNONYM = {"IT","THEM","HER","HIM"},
	DESC = "random object",
	FLAGS = (1<<NDESCBIT)|(1<<TOUCHBIT),
}
OBJECT {
	NAME = "NOT_HERE_OBJECT",
	DESC = "such thing",
	ACTION = NOT_HERE_OBJECT_F,
}
NOT_HERE_OBJECT_F = function()
	local TBL
  local PRSOQ = T
	local OBJ
	local __ok, __res = pcall(function()

  if PASS(EQUALQ(PRSO, NOT_HERE_OBJECT) and EQUALQ(PRSI, NOT_HERE_OBJECT)) then 
    TELL("Those things aren't here!", CR)
    	error(true)
  elseif EQUALQ(PRSO, NOT_HERE_OBJECT) then 
    APPLY(function() TBL = P_PRSO return TBL end)
  elseif T then 
    APPLY(function() TBL = P_PRSI return TBL end)
    APPLY(function() PRSOQ = nil return PRSOQ end)
  end

APPLY(function() P_CONT = nil return P_CONT end)
APPLY(function() QUOTE_FLAG = nil return QUOTE_FLAG end)

  if EQUALQ(WINNER, PLAYER) then 
    TELL("You can't see any ")
    NOT_HERE_PRINT(PRSOQ)
    TELL(" here!", CR)
  elseif T then 
    TELL("The ", WINNER, " seems confused. \"I don't see any ")
    NOT_HERE_PRINT(PRSOQ)
    TELL(" here!\"", CR)
  end

	error(true)
	end)
	if __ok or type(__res) == 'boolean' then return __res
	else error('NOT_HERE_OBJECT_F\n'..__res) end
end
NOT_HERE_PRINT = function(PRSOQ)
	local __ok, __res = pcall(function()

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

	end)
	if __ok or type(__res) == 'boolean' then return __res
	else error('NOT_HERE_PRINT\n'..__res) end
end
NULL_F = function(A1, A2)
	local __ok, __res = pcall(function()
	error(false)
	end)
	if __ok or type(__res) == 'boolean' then return __res
	else error('NULL_F\n'..__res) end
end
LOAD_MAX = 100
LOAD_ALLOWED = 100
OBJECT {
	NAME = "BLESSINGS",
	LOC = GLOBAL_OBJECTS,
	SYNONYM = {"BLESSINGS","GRACES"},
	DESC = "blessings",
	FLAGS = (1<<NDESCBIT),
}
OBJECT {
	NAME = "STAIRS",
	LOC = LOCAL_GLOBALS,
	SYNONYM = {"STAIRS","STEPS","STAIRCASE","STAIRWAY"},
	ADJECTIVE = {"STONE","DARK","MARBLE","FORBIDDING","STEEP"},
	DESC = "stairs",
	FLAGS = (1<<NDESCBIT)|(1<<CLIMBBIT),
	ACTION = STAIRS_F,
}
STAIRS_F = function()
	local __ok, __res = pcall(function()

  if VERBQ(THROUGH) then 
    	return TELL("You should say whether you want to go up or down.", CR)
  end

	end)
	if __ok or type(__res) == 'boolean' then return __res
	else error('STAIRS_F\n'..__res) end
end
OBJECT {
	NAME = "SAILOR",
	LOC = GLOBAL_OBJECTS,
	SYNONYM = {"SAILOR","FOOTPAD","AVIATOR"},
	DESC = "sailor",
	FLAGS = (1<<NDESCBIT),
	ACTION = SAILOR_FCN,
}
SAILOR_FCN = function()
	local __ok, __res = pcall(function()

  if VERBQ(TELL) then 
    APPLY(function() P_CONT = nil return P_CONT end)
    APPLY(function() QUOTE_FLAG = nil return QUOTE_FLAG end)
    	return TELL("You can't talk to the sailor that way.", CR)
  elseif VERBQ(EXAMINE) then 
    -- 
    	return TELL("There is no sailor to be seen.", CR)
  elseif VERBQ(HELLO) then 
    APPLY(function() HS = ADD(HS, 1) return HS end)
    
    if ZEROQ(MOD(HS, 20)) then 
      	return TELL("You seem to be repeating yourself.", CR)
    elseif ZEROQ(MOD(HS, 10)) then 
      	return TELL("I think that phrase is getting a bit worn out.", CR)
    elseif T then 
      	return TELL("Nothing happens here.", CR)
    end

  end

	end)
	if __ok or type(__res) == 'boolean' then return __res
	else error('SAILOR_FCN\n'..__res) end
end
OBJECT {
	NAME = "GROUND",
	LOC = GLOBAL_OBJECTS,
	SYNONYM = {"GROUND","SAND","DIRT","FLOOR"},
	DESC = "ground",
	ACTION = GROUND_FUNCTION,
}
GROUND_FUNCTION = function()
	local __ok, __res = pcall(function()

  if PASS(VERBQ(PUT, PUT_ON) and EQUALQ(PRSI, GROUND)) then 
    PERFORM(VQDROP, PRSO)
    	error(true)
  elseif EQUALQ(HERE, SANDY_CAVE) then 
    	return SAND_FUNCTION()
  elseif VERBQ(DIG) then 
    	return TELL("The ground is too hard for digging here.", CR)
  end

	end)
	if __ok or type(__res) == 'boolean' then return __res
	else error('GROUND_FUNCTION\n'..__res) end
end
OBJECT {
	NAME = "GRUE",
	LOC = GLOBAL_OBJECTS,
	SYNONYM = {"GRUE"},
	ADJECTIVE = {"LURKING","SINISTER","HUNGRY","SILENT"},
	DESC = "lurking grue",
	ACTION = GRUE_FUNCTION,
}
GRUE_FUNCTION = function()
	local __ok, __res = pcall(function()

  if VERBQ(EXAMINE) then 
    	return TELL("The grue is a sinister, lurking presence in the dark places of the\nearth. Its favorite diet is adventurers, but its insatiable\nappetite is tempered by its fear of light. No grue has ever been\nseen by the light of day, and few have survived its fearsome jaws\nto tell the tale.", CR)
  elseif VERBQ(FIND) then 
    	return TELL("There is no grue here, but I'm sure there is at least one lurking\nin the darkness nearby. I wouldn't let my light go out if I were\nyou!", CR)
  elseif VERBQ(LISTEN) then 
    	return TELL("It makes no sound but is always lurking in the darkness nearby.", CR)
  end

	end)
	if __ok or type(__res) == 'boolean' then return __res
	else error('GRUE_FUNCTION\n'..__res) end
end
OBJECT {
	NAME = "LUNGS",
	LOC = GLOBAL_OBJECTS,
	SYNONYM = {"LUNGS","AIR","MOUTH","BREATH"},
	DESC = "blast of air",
	FLAGS = (1<<NDESCBIT),
}
OBJECT {
	NAME = "ME",
	LOC = GLOBAL_OBJECTS,
	SYNONYM = {"ME","MYSELF","SELF","CRETIN"},
	DESC = "cretin",
	FLAGS = (1<<ACTORBIT),
	ACTION = CRETIN_FCN,
}
CRETIN_FCN = function()
	local __ok, __res = pcall(function()

  if VERBQ(TELL) then 
    APPLY(function() P_CONT = nil return P_CONT end)
    APPLY(function() QUOTE_FLAG = nil return QUOTE_FLAG end)
    	return TELL("Talking to yourself is said to be a sign of impending mental collapse.", CR)
  elseif PASS(VERBQ(GIVE) and EQUALQ(PRSI, ME)) then 
    PERFORM(VQTAKE, PRSO)
    	error(true)
  elseif VERBQ(MAKE) then 
    	return TELL("Only you can do that.", CR)
  elseif VERBQ(DISEMBARK) then 
    	return TELL("You'll have to do that on your own.", CR)
  elseif VERBQ(EAT) then 
    	return TELL("Auto-cannibalism is not the answer.", CR)
  elseif VERBQ(ATTACK, MUNG) then 
    
    if PASS(PRSI and FSETQ(PRSI, WEAPONBIT)) then 
      	return JIGS_UP("If you insist.... Poof, you're dead!")
    elseif T then 
      	return TELL("Suicide is not the answer.", CR)
    end

  elseif VERBQ(THROW) then 
    
    if EQUALQ(PRSO, ME) then 
      	return TELL("Why don't you just walk like normal people?", CR)
    end

  elseif VERBQ(TAKE) then 
    	return TELL("How romantic!", CR)
  elseif VERBQ(EXAMINE) then 
    
    if EQUALQ(HERE, LOC(MIRROR_1), LOC(MIRROR_2)) then 
      	return TELL("Your image in the mirror looks tired.", CR)
    elseif T then 
      	return TELL("That's difficult unless your eyes are prehensile.", CR)
    end

  end

	end)
	if __ok or type(__res) == 'boolean' then return __res
	else error('CRETIN_FCN\n'..__res) end
end
OBJECT {
	NAME = "ADVENTURER",
	SYNONYM = {"ADVENTURER"},
	DESC = "cretin",
	FLAGS = (1<<NDESCBIT)|(1<<INVISIBLE)|(1<<SACREDBIT)|(1<<ACTORBIT),
	STRENGTH = 0,
	ACTION = 0,
}
OBJECT {
	NAME = "PATHOBJ",
	LOC = GLOBAL_OBJECTS,
	SYNONYM = {"TRAIL","PATH"},
	ADJECTIVE = {"FOREST","NARROW","LONG","WINDING"},
	DESC = "passage",
	FLAGS = (1<<NDESCBIT),
	ACTION = PATH_OBJECT,
}
PATH_OBJECT = function()
	local __ok, __res = pcall(function()

  if VERBQ(TAKE, FOLLOW) then 
    	return TELL("You must specify a direction to go.", CR)
  elseif VERBQ(FIND) then 
    	return TELL("I can't help you there....", CR)
  elseif VERBQ(DIG) then 
    	return TELL("Not a chance.", CR)
  end

	end)
	if __ok or type(__res) == 'boolean' then return __res
	else error('PATH_OBJECT\n'..__res) end
end
OBJECT {
	NAME = "ZORKMID",
	LOC = GLOBAL_OBJECTS,
	SYNONYM = {"ZORKMID"},
	DESC = "zorkmid",
	ACTION = ZORKMID_FUNCTION,
}
ZORKMID_FUNCTION = function()
	local __ok, __res = pcall(function()

  if VERBQ(EXAMINE) then 
    	return TELL("The zorkmid is the unit of currency of the Great Underground Empire.", CR)
  elseif VERBQ(FIND) then 
    	return TELL("The best way to find zorkmids is to go out and look for them.", CR)
  end

	end)
	if __ok or type(__res) == 'boolean' then return __res
	else error('ZORKMID_FUNCTION\n'..__res) end
end
OBJECT {
	NAME = "HANDS",
	LOC = GLOBAL_OBJECTS,
	SYNONYM = {"PAIR","HANDS","HAND"},
	ADJECTIVE = {"BARE"},
	DESC = "pair of hands",
	FLAGS = (1<<NDESCBIT)|(1<<TOOLBIT),
}
