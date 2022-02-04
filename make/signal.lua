export type connection = {
	Disconnect : () -> ()
}

export type class<T> = {
	Connect : (T) -> (SignalConnection)
}

local Signal = ({});

Signal.__index = Signal

function Signal.new<T>() : class<T>
	local self = {
		_listeners = {};
		["@type"] = "signal";
	}

	function self:Connect(callback) : SignalConnection
		local listener = {
			callback = callback,
			isConnected = true,
		}

		table.insert(self._listeners, listener)

		return ({
			Disconnect = (function()
				listener.isConnected = (false);
				for i, listen in pairs(self._listeners) do
					if (listen == listener) then
						self._listeners[i] = (nil);
					end;
				end;
			end);
		});
	end
	
	function self:Fire(...) : ()
		for _, listener in ipairs(self._listeners) do
			if listener.isConnected then
				coroutine.wrap(listener.callback)(...)
			end
		end
	end

	return (self);
end

return Signal;
