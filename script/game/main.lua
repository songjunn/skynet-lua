package.path = "script/common/?.lua;script/game/?.lua;script/game/loader/?.lua;script/game/manager/?.lua;script/game/schema/?.lua;script/game/module/?.lua;script/game/handler/?.lua"
package.cpath = "lualib/?.dll"

local co = require "co"
local utils = require "utils"
local skynet = require "skynet"
local Server = require "server"
local jsonLoader = require "JsonLoader"
local messageLoader = require "MessageLoader"
local GlobalMgr = require "GlobalMgr"
local ClientMgr = require "ClientMgr"
local CmdKit = require "CmdKit"

local lastTickSec_ = -1
local lastTickMin_ = -1

local function tickSec(nowtime)
    skynet.logDebug("Test lua memory leak, nowtime=%d, name=%s", nowtime, "11111111")
    skynet.logDebug("Test lua memory leak, nowtime=%d, name=%s", nowtime, "22222222")
    skynet.logDebug("Test lua memory leak, nowtime=%d, name=%s", nowtime, "33333333")
    skynet.logDebug("Test lua memory leak, nowtime=%d, name=%s", nowtime, "44444444")
    skynet.logDebug("Test lua memory leak, nowtime=%d, name=%s", nowtime, "55555555")
    skynet.logDebug("Test lua memory leak, nowtime=%d, name=%s", nowtime, "66666666")
    skynet.logDebug("Test lua memory leak, nowtime=%d, name=%s", nowtime, "77777777")
    skynet.logDebug("Test lua memory leak, nowtime=%d, name=%s", nowtime, "88888888")
    skynet.logDebug("Test lua memory leak, nowtime=%d, name=%s", nowtime, "99999999")
    skynet.logDebug("Test lua memory leak, nowtime=%d, name=%s", nowtime, "00000000")
    
end

local function tickMin(nowtime)
    ClientMgr.tickClient(nowtime)
end

local function tickDay(nowtime)

end

local function tickWeek(nowtime)

end

local function tick()
    local nowtime = os.time()
    local nowsec = os.date("%S", nowtime)
    local nowmin = os.date("%M", nowtime)
    local nowwday = os.date("%w", nowtime)
    
    if (nowsec ~= lastTickSec_) then
        tickSec(nowtime)
        lastTickSec_ = nowsec
    end
    if (nowmin ~= lastTickMin_) then
        tickMin(nowtime)
        lastTickMin_ = nowmin
    end
    if (nowwday ~= GlobalMgr.getTickDay()) then
        tickDay(nowtime)
        GlobalMgr.setTickDay(nowwday)

        if (nowwday == 1) then --星期一
            tickWeek(nowtime)
        end
    end
end

local function dispatch_text(source, fd, msg)
    local args = utils.split(msg, '|')
    local cmd = args[1]
    local size = args[2]
    local data = string.sub(msg, -size)
    
    if (cmd == "forward") then
        Server.recvClientMsg(fd, data, size)
    elseif (cmd == "connect") then
        ClientMgr.connectClient(fd, data)
    elseif (cmd == "disconnect") then
        ClientMgr.disconnectClient(fd)
    elseif (cmd == "http") then
        CmdKit.response(source, fd, data)
    else
        skynet.logError("[game]handle error message. cmd=%s source=%d", cmd, source)
    end
end

local function dispatch_response(source, session, msg)
    skynet.logDebug('[game]handle response msg: source=%d session=%d msg=%s', source, session, msg)
    co.resume(session, msg)
end

function create(harbor, hid, args)
    skynet.setHandle(hid)
    skynet.setTimer(1000)
    jsonLoader.loadAll()
    messageLoader.loadAll()
    Server.startup(harbor)
    GlobalMgr.loadData()
    skynet.logNotice("[game]Game create.")
    return 0
end

function release()
    Server.shutdown()
    skynet.logNotice("[game]Game release.")
end

function handle(hid, source, session, type, msg)
    if (type == skynet.SERVICE_TEXT) then
    	dispatch_text(source, session, msg)
    elseif (type == skynet.SERVICE_TIMER) then
    	tick()
    	skynet.setTimer(10)
    elseif (type == skynet.SERVICE_RESPONSE) then
    	dispatch_response(source, session, msg)
    else
    	skynet.logError("[game]handle error message. type=%d source=%d", type, source)
    end
end
