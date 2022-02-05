local override = script.Parent;
local make = require(script.Parent.Parent);
local basic = require(make.basic);

local prototype = ({});

--//////////////////////////////////////////
-- PROTO : BEGIN
--//////////////////////////////////////////

--// <signal>OnInitialized
--// [ Works only within 'new' ]
--// Fired when instance is fully created
prototype.OnInitialized = make.new_event();

function prototype.start(self)
	--	NONE
end

--//////////////////////////////////////////
-- PROTO : END
--//////////////////////////////////////////

return (prototype)
