package.path = "script/common/?.lua"
package.cpath = "lualib/?.dll"

local utils = require "utils"
local skynet = require "skynet"

local function build_response(data)
    local str = {"HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length:", #data, "\r\nConnection: keep-alive\r\n\r\n", data}
    return table.concat(str)
end

local function dispatch_httprequest(source, fd, url)
    skynet.logDebug('[manager]recv http data: %s', url)

    local args = utils.split(url, '?')
    local route = args[1]
    local arglist = args[2]

    if (route == "/gm/serviceclose") then
        local name = arglist
        skynet.closeServiceByName(name)
    elseif (route == "/gm/servicecreate") then
        local a = utils.split(arglist, ',')
        skynet.createService(a[1], a[2], a[3])
    elseif (route == "/gm/printmemory") then
        skynet_print_memory()
    end

    local data = build_response("success")
    skynet.responseHttp(source, fd, data)
end

local function dispatch_text(source, fd, msg)
    local args = utils.split(msg, '|')
    local cmd = args[1]
    local size = args[2]
    local data = string.sub(msg, -size)
    
    if (cmd == "http") then
        dispatch_httprequest(source, fd, data)
    else
        skynet.logError("[manager]handle error message. cmd=%s source=%d", cmd, source)
    end
end

function run(n)
    if n<2 then
        return n
    else
    return run(n-1)+run(n-2)
    end
end

function tick()
    local t1 = os.time()
    run(40)
    local t2 = os.time()
    skynet.logError('cost time: %d', (t2-t1))
end

function create(harbor, hid, args)
    skynet.setHandle(hid)
    skynet.logNotice("[manager]Manager create.")
    skynet.setTimer(1000)
    return 0
end

function release()
    skynet.logNotice("[manager]Manager release.")
end

function handle(hid, source, session, type, msg)
    if (type == skynet.SERVICE_TEXT) then
    	dispatch_text(source, session, msg)
    elseif (type == skynet.SERVICE_TIMER) then
        tick()
        skynet.setTimer(1000)
    else
    	skynet.logError("[manager]handle error message. type=%d source=%d", type, source)
    end
end
