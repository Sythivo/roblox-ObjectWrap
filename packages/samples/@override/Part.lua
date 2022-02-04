local override = script.Parent;
local make = require(script.Parent.Parent);
local basic = require(make.basic);

local prototype = ({});

--//////////////////////////////////////////
-- PROTO : BEGIN
--//////////////////////////////////////////

-- Templete override

function prototype:HelloCall()
	print("Hello from", self)
end

-- Created Object
-- @param self proto_class
function prototype.start(self)
	
end

--//////////////////////////////////////////
-- PROTO : END
--//////////////////////////////////////////

return (prototype)