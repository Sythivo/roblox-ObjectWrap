local basic = require(script.Parent:WaitForChild("basic"));
local include = script.Parent:WaitForChild("@include");

local create = function(InstanceName : string, wrapper : (Instance) -> (any))
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
	
	if (wrapper) then
		Class = wrapper(Class)
	end
	
	return function(Properties)
		for i, v in pairs(Properties) do
			if (typeof(v) == "Instance" and type(i) == "number") then
				v.Parent = (Class);
				continue;
			end
			if (type(v) == "function" and type(i) == "string") then
				Class[i]:Connect(v);
				continue;
			end
			Class[i] = v;
		end
		
		if (Class and type(Class["OnInitialized"]) == "table" and type(Class["OnInitialized"]["Fire"]) == "function") then
			Class.OnInitialized:Fire();
		end
		
		return Class;
	end
end

return function(class)
	local op_string = (function(class)
		return (function(paramaters)
			return create(class, basic.echo)(paramaters);
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
