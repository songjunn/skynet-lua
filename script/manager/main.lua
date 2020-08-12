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

function create(harbor, hid, args)
    skynet.setHandle(hid)
    skynet.logNotice("[manager]Manager create.")
    return 0
end

function release()
    skynet.logNotice("[manager]Manager release.")
end

function handle(hid, source, session, type, msg)
    if (type == skynet.SERVICE_TEXT) then
    	dispatch_text(source, session, msg)
    else
    	skynet.logError("[manager]handle error message. type=%d source=%d", type, source)
    end
end
