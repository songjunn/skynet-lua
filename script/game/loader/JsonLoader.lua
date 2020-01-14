local json = require "cjson"
local skynet = require "skynet"

local JsonLoader = {}

local data = {}

local function loadJson(file)
	local lns = {}
	local f = io.open(file, "r")
	for line in f:lines() do
		table.insert(lns, line)
	end
	local str = table.concat(lns)

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
	--data["item"] = loadJson("./data/item.json")
	--data["shop"] = loadJson("./data/shop.json")
	--data["equip"] = loadJson("./data/equip.json")
	skynet.logNotice("[game]load start")
	data["stage"] = loadJson("./data/honorwar_stage.json")
	--data["wave"] = loadJson("./data/honorwar_stage_wave.json")
	--data["unit"] = loadJson("./data/honorwar_unit.json")
	
	skynet.logNotice("[game]load json data over.")
	collectgarbage("collect")
end

return JsonLoader
