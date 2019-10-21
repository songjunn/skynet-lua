local skynet = require "skynet"
local hotfix = require "hotfix"
local utils = require "utils"

local Server = {}

local function build_response(data)
	local res = string.format("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length:%d\r\nConnection: keep-alive\r\n\r\n%s", string.len(data), data)
	return res
end

function Server.response(source, fd, url)
	skynet.logDebug('[game]recv http data: %s', url)

	local args = utils.split(url, '?')
	local route = args[1]
	local arglist = args[2]

	if (route == "/gm/reload") then
		hotfix.reloadAll()
		hotfix.reloadAll() --为什么2次才能成功?
	end

	local data = build_response("success")
	skynet.responseHttp(source, fd, data)
end

return Server