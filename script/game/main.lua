package.path = "script/common/?.lua;script/game/server/?.lua"
package.cpath = ""

local skynet = require "skynet"
local GameServer = require "GameServer"

function create(harbor, handle, args)
    skynet.setHandle(handle)
    skynet.setTimer(1000)
    GameServer.startup(harbor)
    skynet.logNotice("[game]Game create.")
    return 0
end

function release()
	GameServer.shutdown()
    skynet.logNotice("[game]Game release.")
end

function handle(handle, source, session, type, msg)
    if (type == skynet.SERVICE_TEXT) then
    	handleTextMsg(source, session, msg)
    elseif (type == skynet.SERVICE_TIMER) then
    	GameServer.tick()
    	skynet.setTimer(1000)
    elseif (type == skynet.SERVICE_RESPONSE) then
    	handleResponseMsg(source, session, msg)
    else
    	skynet.logError("[game]handle error message. type=" + type + " source=" + source)
    end
end

local function handleTextMsg(source, fd, msg)
	--print(source, fd, msg)
end

local function handleResponseMsg(source, session, msg)

end