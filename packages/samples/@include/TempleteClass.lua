local template_class = ({});

function template_class.new()
	local self = ({}); -- new object

	function self:Hello() : () -- define method
		print("Hello")
	end
	
	return (self); -- return 'new' object
end

return (template_class);