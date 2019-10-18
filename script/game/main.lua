package.path = "script/common/?.lua;script/game/server/?.lua;script/game/handler/?.lua"
package.cpath = "lualib/?.dll"

dofile("script/game/loader.lua")

local skynet = require "skynet"
local utils = require "utils"
local GameServer = require "GameServer"
local co = require "co"

local function handleTextMsg(source, fd, msg)
    local args = utils.split(msg, '|')
    local cmd = args[1]
    local size = args[2]
    local data = args[3]
    
    if (cmd == "forward") then
        GameServer.recvClientMsg(fd, data, size)
    elseif (cmd == "connect") then
        skynet.logDebug("[game]connected fd=%d addr=%s", fd, data)
    elseif (cmd == "disconnect") then
        skynet.logDebug("[game]disconnected fd=%d", fd)
    elseif (cmd == "http") then

    else
        skynet.logError("[game]handle error message. cmd=%s source=%d", cmd, source)
    end
end

local function handleResponseMsg(source, session, msg)
    skynet.logDebug('[game]handle response msg: source=%d session=%d msg=%s', source, session, message)
    co.resume(session, msg)
end

function create(harbor, hid, args)
    skynet.setHandle(hid)
    skynet.setTimer(1000)
    GameServer.startup(harbor)
    skynet.logNotice("[game]Game create.")
    return 0
end

function release()
	GameServer.shutdown()
    skynet.logNotice("[game]Game release.")
end

function handle(hid, source, session, type, msg)
    if (type == skynet.SERVICE_TEXT) then
    	handleTextMsg(source, session, msg)
    elseif (type == skynet.SERVICE_TIMER) then
    	GameServer.tick()
    	skynet.setTimer(1000)
    elseif (type == skynet.SERVICE_RESPONSE) then
    	handleResponseMsg(source, session, msg)
    else
    	skynet.logError("[game]handle error message. type=%d source=%d", type, source)
    end
end