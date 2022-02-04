local override = script.Parent;
local make = require(script.Parent.Parent);
local basic = require(make.basic);

local prototype = ({});

prototype.inherit = ({
	override.Part;
})

--//////////////////////////////////////////
-- PROTO : BEGIN
--//////////////////////////////////////////

-- Templete override [inheirt]

function prototype:Talk()
	print("Foo Bar")
end

-- Created Object
-- @param self proto_class
function prototype.start(self)
	self:HelloCall() -- inherited from 'Part'
end

--//////////////////////////////////////////
-- PROTO : END
--//////////////////////////////////////////

return (prototype)