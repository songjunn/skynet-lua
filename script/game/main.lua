package.path = "script/common/?.lua;script/game/?.lua;script/game/server/?.lua;script/game/handler/?.lua;script/game/manager/?.lua;script/game/loader/?.lua;script/game/schema/?.lua;script/game/module/?.lua"
package.cpath = "lualib/?.dll"

local skynet = require "skynet"
local utils = require "utils"
local co = require "co"
local jsonLoader = require "JsonLoader"
local messageLoader = require "MessageLoader"
local GameServer = require "GameServer"
local AdminServer = require "AdminServer"
local GlobalMgr = require "GlobalMgr"

local function dispatch_text(source, fd, msg)
    local args = utils.split(msg, '|')
    local cmd = args[1]
    local size = args[2]
    local data = args[3]
    
    if (cmd == "forward") then
        GameServer.recvClientMsg(fd, data)
    elseif (cmd == "connect") then
        GameServer.connectClient(fd, data)
    elseif (cmd == "disconnect") then
        GameServer.disconnectClient(fd)
    elseif (cmd == "http") then
        AdminServer.response(source, fd, data)
    else
        skynet.logError("[game]handle error message. cmd=%s source=%d", cmd, source)
    end
end

local function dispatch_response(source, session, msg)
    skynet.logDebug('[game]handle response msg: source=%d session=%d msg=%s', source, session, msg)
    co.resume(session, msg)
end

local function tick()
    local nowtime = os.time()
end

local function tickSec(nowtime)
    GameServer.tickClient(nowtime)
end

local function tickMin(nowtime)
    
end

local function tickHour(nowtime)
    
end

local function tickDay(nowtime)
    
end

function create(harbor, hid, args)
    skynet.setHandle(hid)
    skynet.setTimer(1000)
    jsonLoader.loadAll()
    messageLoader.loadAll()
    GameServer.startup(harbor)
    GlobalMgr.loadData()
    skynet.logNotice("[game]Game create.")
    return 0
end

function release()
	GameServer.shutdown()
    skynet.logNotice("[game]Game release.")
end

function handle(hid, source, session, type, msg)
    if (type == skynet.SERVICE_TEXT) then
    	dispatch_text(source, session, msg)
    elseif (type == skynet.SERVICE_TIMER) then
    	tick()
    	skynet.setTimer(1000)
    elseif (type == skynet.SERVICE_RESPONSE) then
    	dispatch_response(source, session, msg)
    else
    	skynet.logError("[game]handle error message. type=%d source=%d", type, source)
    end
end
