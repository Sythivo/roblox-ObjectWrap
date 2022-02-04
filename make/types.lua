local r = require(script.raw_type)

type l_signal<T> = ({
	Connect : (T) -> RBXScriptConnection;
});
type l_void = () -> ();

--///////////////////////////////
--//@include typed class object
export type TemplateClass = {
	Hello: () -> ();
};

--///////////////////////////////
--//@override typed class object
--// view this.raw_type for using roblox types
export type Part = r.lPart & {
	HelloCall: () -> ();
};

local types = ({});

function types.IsWrapped(proto)
	return typeof(proto) == "userdata" and proto["@case"] == ("wrapped") or false;
end
function types.IsInstance(proto)
	return typeof(proto) == "Instance" or false;
end

function types.pairs_extract(fixtures : {() -> boolean}) : (array, ...any) -> (() -> (...any))
	local balance = ({});
	for i, v in next, fixtures do
		if (type(v) == "function") then
			table.insert(balance, v);
		end
	end
	
	return (function(array, ...)
		local access = ({...});
		
		local thread = (coroutine.create(function()
			local values = ({});
			for index, v in next, array do
				local flag = false;
				for _, validater in next, balance do
					if (not validater(v)) then
						flag = true;
						break;
					end
				end
				if (flag) then
					continue;
				end
				
				table.clear(values);
				
				for _, action in next, access do
					table.insert(values, action(v) or ("nil"));
				end

				coroutine.yield(index, v, unpack(values))
			end
			
			table.clear(balance); balance = nil;
			table.clear(values); values = nil;
		end));

		local function iterator()
			if (coroutine.status(thread) ~= "dead") then
				return coroutine.resume(thread);
			else
				return;
			end
		end
		return iterator;
	end);
end

return types;