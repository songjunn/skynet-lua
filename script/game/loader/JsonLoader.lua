local rapidjson = require "rapidjson"
local skynet = require "skynet"

local JsonLoader = {}

local data = {}

local function loader(file)
	local str = ""
	local f = io.open(file, "r")
	for line in f:lines() do
		str = str .. line
	end
	f:close()
	skynet.logNotice("[game]load json: %s", file)

	local t = rapidjson.decode(str)
	return t
end

function JsonLoader.getData(name)
	return data[name]
end

function JsonLoader.loadAll()
	data["shop"] = loader("./data/shop.json")

	skynet.logNotice("[game]load json data over.")
end

return JsonLoader
