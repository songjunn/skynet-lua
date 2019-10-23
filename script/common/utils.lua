local Utils = {}

function Utils.split(str, reps)
	local a = {}
	string.gsub(str, '[^'..reps..']+', function(w)
		table.insert(a, w)
	end)
	return a
end

function Utils.clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function Utils.schemaTable(object, schema)
	local lookup_table = {}
	local function _copy(object, schema)
		if type(schema) ~= "table" then
			return schema
		elseif lookup_table[schema] then
			return lookup_table[schema]
		end
		local new_table = {}
		lookup_table[schema] = new_table
		for key, value in pairs(schema) do
			new_table[key] = _copy(object[key] or {}, value)
		end
		return setmetatable(new_table, getmetatable(schema))
	end
	return _copy(object, schema)
end

return Utils