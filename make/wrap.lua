local basic = require(script.Parent:WaitForChild("basic"));

return function(object : Instance | {Instance})
	local object = object;
	if (typeof(object) == "Instance") then
		return basic.echo(object);
	elseif (type(object) == "table") then
		local object = unpack(object);
		if (typeof(object) == "Instance") then
			return basic.echo(object);
		end
	end
end
