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

function Utils.mergeTable(...)
    local tabs = {...}
    if not tabs then
        return {}
    end
    local origin = tabs[1]
    for i = 2,#tabs do
        if origin then
            if tabs[i] then
                for k,v in pairs(tabs[i]) do
                	origin[k] = v
                end
            end
        else
            origin = tabs[i]
        end
    end
    return origin
end

function Utils.schemaTable(object, schema)
	local lookup_table = {}
	local function _copy(object, schema)
		if type(schema) ~= "table" then
			return object or schema
		elseif lookup_table[schema] then
			return lookup_table[schema]
		end
		local new_table = {}
		lookup_table[schema] = new_table
		for key, value in pairs(schema) do
			if object == nil then
				new_table[key] = _copy(nil, value)
			else
				new_table[key] = _copy(object[key], value)
			end
		end
		return setmetatable(new_table, getmetatable(schema))
	end
	return _copy(object, schema)
end

return Utils