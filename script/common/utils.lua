local Utils = {}

function Utils.split(str, reps)
	local a = {}
	string.gsub(str, '[^'..reps..']+', function(w)
		table.insert(a, w)
	end)
	return a
end

return Utils