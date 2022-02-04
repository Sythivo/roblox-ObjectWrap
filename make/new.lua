local basic = require(script.Parent:WaitForChild("basic"));
local include = script.Parent:WaitForChild("@include");

local create = function(InstanceName)
	local Class;
	if (include:FindFirstChild(InstanceName)) then
		Class = require(include:FindFirstChild(InstanceName));
		if (Class.new) then
			Class = Class.new();
			if (type(Class) ~= "table") then
				error("Class Invalid 'new' value")
			end
		else
			error("Class 'new' not found")
		end
	else
		Class = Instance.new(InstanceName);
	end

	return function(Properties)
		for i, v in pairs(Properties) do
			if (typeof(v) == "Instance" and type(i) == "number") then
				v.Parent = (Class);
				continue;
			end
			Class[i] = v;
		end
		return Class;
	end
end

return function(class)
	local op_string = (function(class)
		return (function(paramaters)
			local object = create(class)(paramaters);
			
			return basic.echo(object);
		end);
	end);
	local class = class;
	if (type(class) == "string") then
		return (op_string(class));
	elseif (type(class) == "table") then
		local class = unpack(class);
		if (type(class) == "string") then
			return (op_string(class));
		else
			if (class.new) then
				return (function(paramaters)
					return class.new(unpack(paramaters));
				end);
			else
				warn("Failed to index 'new' on class module")
			end
		end
	end
end
