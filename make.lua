local signal = require(script.signal)

return {
	new = script.new,
	wrap = script.wrap,
	types = script.types,
	basic = script.basic,
	
	new_property = function<T>(default_value : T)
		local self = ({
			value = default_value;
			["@type"] = "property";
		});

		function self.get() : T
			return self.value;
		end

		function self.set(value : T) : ()
			assert(not self.value or typeof(self.value) == typeof(value), 
				("invalid argument #3 (%s expected, got %s)"):format(typeof(self.value), typeof(value))
			);
			self.value = value;
		end

		return (self);
	end,
	new_event = function()
		return signal.new();
	end,
};