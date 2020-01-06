local json = require "dkjson"
local skynet = require "skynet"

local JsonLoader = {}

local data = {}

local function loadJson(file)
	local str = ""
	local f = io.open(file, "r")
	for line in f:lines() do
		str = str .. line
	end
	f:close()
	skynet.logNotice("[game]load json: %s", file)

	local t = json.decode(str)
	return t
end

function JsonLoader.getData(type, id)
	local key = tostring(id)
	return data[type][key]
end

function JsonLoader.loadAll()
	data["item"] = loadJson("./data/item.json")
	data["shop"] = loadJson("./data/shop.json")
	data["equip"] = loadJson("./data/equip.json")
	
	skynet.logNotice("[game]load json data over.")
end

return JsonLoader
