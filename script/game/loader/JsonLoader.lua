local json = require "cjson"
local skynet = require "skynet"
local Utils = require "Utils"

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

local function loadJsonTo(file, t)
	local d = loadJson(file)
	Utils.mergeTable(t, d)
end

function JsonLoader.getData(type, id)
	local key = tostring(id)
	return data[type][key]
end

function JsonLoader.loadAll()
	local allItems = {}
	loadJsonTo("./data/item.json", allItems)
	loadJsonTo("./data/equip.json", allItems)

	data["item"] = allItems
	data["shop"] = loadJson("./data/shop.json")
	
	skynet.logNotice("[game]load json data over.")
end

return JsonLoader
