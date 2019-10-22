local skynet = require "skynet"
local hotfix = require "hotfix"
local utils = require "utils"
local jsonLoader = require "JsonLoader"
local messageLoader = require "MessageLoader"

local Server = {}

local function build_response(data)
	return string.format("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length:%d\r\nConnection: keep-alive\r\n\r\n%s", string.len(data), data)
end

function Server.response(source, fd, url)
	skynet.logDebug('[game]recv http data: %s', url)

	local args = utils.split(url, '?')
	local route = args[1]
	local arglist = args[2]

	if (route == "/gm/reloadall") then
		hotfix.reloadAll()
		jsonLoader.loadAll()
		messageLoader.loadAll()
	elseif (route == "/gm/reloadlua") then
		hotfix.reloadAll()
	elseif (route == "/gm/reloadjson") then
		jsonLoader.loadAll()
	elseif (route == "/gm/reloadmessage") then
		messageLoader.loadAll()
	end

	local data = build_response("success")
	skynet.responseHttp(source, fd, data)
end

return Server