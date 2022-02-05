local override = script.Parent:WaitForChild("@override");
local t = require(script.Parent.types);

local basic = ({
	access_point = ("@object");
	override_point = ("@override");
	
	meta = ({});
});

local get_mapping = ({
	["@type"] = (function(self)
		local type = (self["@type"]);
		if (type) then
			if (type == ("property")) then
				return (self.get());
			elseif (type == ("signal")) then
				return (self);
			end;
		else
			return (self);
		end;
	end);
});
local set_mapping = ({
	["@type"] = (function(self, index, ...)
		local type = (self["@type"]);
		if (type) then
			if (type == ("property")) then
				return (self.set(...));
			elseif (type == ("signal")) then
				error(("cannot set <%s>%s"):format(type, index))
			end;
		else
			error(("%s is not a valid member of %s \"%s\""):format(index, self, self:GetFullName()))
		end;
	end);
});

basic.meta.__index = (function(self, access)
	local proto = rawget(self, basic.override_point);
	
	local proto_type = type(proto[access]);
	
	if (not proto[access]) then
		local retrive = rawget(self, basic.access_point)[access];
		if (typeof(retrive) == "Instance") then
			retrive = basic.echo(retrive);
		elseif (type(retrive) == "function") then
			local calling = retrive;
			retrive = (function(...)
				local params = ({...});
				for i, param in t.pairs_extract { t.is_wrapped } (params) do
					params[i] = (basic.get(param));
				end
				
				local returned = table.pack(calling(unpack(params)));
				for i, v in t.pairs_extract { t.IsInstance }(returned) do
					returned[i] = (basic.echo(v));
				end

				return unpack(returned);
			end);
		end
		return (retrive);
	else
		if (proto_type == "function") then
			return proto[access];
		else
			return get_mapping["@type"](proto[access]);
		end
	end
end);
basic.meta.__newindex = (function(self, access, value)
	local proto = rawget(self, basic.override_point);
	if (not proto[access]) then
		local actual = (value);
		if (t.IsWrapped(actual)) then
			actual = rawget(actual, basic.access_point);
		end
		rawget(self, basic.access_point)[access] = (actual);
	else
		set_mapping["@type"](proto[access], access, value)
	end
end);


function merge_memory(...)
	local params = ({...});
	local merged = (params[1]);

	table.remove(params, 1);

	for _, table in pairs(params) do
		for i, v in pairs(table) do
			merged[i] = v;
		end
	end
	return (merged);
end

function merge(...)
	local merged = ({});
	for _, table in pairs({...}) do
		for i, v in pairs(table) do
			merged[i] = v;
		end
	end
	return (merged);
end

function merge_extract(value, skip_till, ...)
	local merged = ({});
	local extracted = ({});
	for c, proto in pairs({...}) do
		for i, v in pairs(proto) do
			if (i == value) then
				if (c >= skip_till) then
					table.insert(extracted, v)
				end
			else
				merged[i] = v;
			end
		end
	end
	return merged, extracted;
end

local cache_saves = ({});

function basic.echo(...)
	local parameters = ({...});
	local compiled = ({});
	for i, v in next, parameters do
		if (typeof(v) == "Instance") then
			if (cache_saves[v]) then
				table.insert(compiled, cache_saves[v]);
			else
				local activators = ({});
				local c_proto = ({});
				local extracted = nil;
				local inheritted = ({});

				c_proto = merge_memory(c_proto, require(override:WaitForChild(".default")));
				
				local add_proto = function(cmake)
					c_proto, extracted = merge_extract("start", 2, c_proto, cmake);
					table.insert(activators, extracted[1])
				end
				
				local function Inherit(proto)
					if (proto and proto.inherit and type(proto.inherit) == "table") then
						for _, mod in pairs(proto.inherit) do
							if (inheritted[mod]) then
								continue;
							end
							if (typeof(mod) == "Instance" and mod:IsA("ModuleScript")) then
								local cmake = require(mod);
								if (cmake) then
									inheritted[mod] = true;
									Inherit(cmake);
									add_proto(cmake);
								end
							end
						end
					end
				end

				local mod = override:FindFirstChild(v.ClassName);
				if (typeof(mod) == "Instance" and mod:IsA("ModuleScript")) then
					local cmake = require(mod);
					if (cmake) then
						inheritted[mod] = true;
						Inherit(cmake);
						add_proto(cmake);
					end
				end
				
				local self, o_meta, object = newproxy(true), ({}), ({
					["@case"] = ("wrapped");
				});
				
				local meta = getmetatable(self);
				setmetatable(object, merge_memory(o_meta, basic.meta, {
					__tostring = function()
						return tostring(v);
					end;
					__metatable = v.ClassName;
				}));
				
				meta.__index = (object);
				meta.__newindex = (object);
				meta.__tostring = (o_meta.__tostring);

				rawset(object, basic.override_point, (merge(c_proto)))
				rawset(object, basic.access_point, v);

				cache_saves[v] = (self);
				table.insert(compiled, self);

				for _, start in pairs(activators) do
					start(object);
				end
			end
		else
			table.insert(compiled, v);
		end
	end
	return unpack(compiled);
end

function basic.get(class)
	return class[basic.access_point];
end

return (basic);
