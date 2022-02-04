local override = script.Parent;
local make = require(script.Parent.Parent);
local basic = require(make.basic);

local prototype = ({});

--//////////////////////////////////////////
-- PROTO : BEGIN
--//////////////////////////////////////////

prototype.OnPlayerTouched = make.new_event();

function prototype.start(self)
	local Players = basic.echo(game:GetService("Players"));
	
	self.Touched:Connect(function(Hit : BasePart)
		local Player : Player? = nil;
		
		for i, player : Player in Players:GetPlayers() do
			if (player.Character and Hit:IsDescendantOf(player.Character)) then
				Player = player;
				break;
			end
		end
		
		if (Player) then
			self.OnPlayerTouched:Fire(Player);
		end
	end);
end

--//////////////////////////////////////////
-- PROTO : END
--//////////////////////////////////////////

return (prototype)