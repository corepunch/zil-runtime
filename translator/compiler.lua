local codes = {}

codes.noun_gender = function(code) return code:byte(3)&3 end



return codes