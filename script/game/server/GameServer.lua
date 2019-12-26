local skynet = require "skynet"
local struct = require "struct"
local serpent = require "serpent"
local co = require "co"
local pb = require "pb"
local UserMgr = require "UserMgr"

local Server = {}

local harbor = 0
local handlers = {}
local protocols = {}
local clients = {}

function Server.startup(id)
	harbor = id
end

function Server.shutdown()

end

function Server.tickClient(nowtime)
	for k, v in pairs(clients) do      
	    if (nowtime - v.heartbeat > 30) then
	    	Server.disconnectClient(k)
	    	skynet.logDebug("[game]Kick client fd=%d", k)
	    end
	end  
end

function Server.connectClient(fd, addr)
	clients[fd] = {addr = addr, heartbeat = 0}
	skynet.logDebug("[game]Connect client fd=%d addr=%s", fd, addr)
end

function Server.disconnectClient(fd)
	clients[fd] = nil
	skynet.logDebug("[game]Disconnect client fd=%d", fd)
end

function Server.kick

function Server.sendClientMsg(fd, data, proto, proto_type)
	local t = pb.enum("Message.MsgDefine", proto_type)
	local msg = assert(pb.encode(proto, data))
	local message = struct.pack('<is', t, msg)
	skynet.sendClient(fd, message)
	skynet.logDebug("[game]Send Message %d from %d: %s", t, fd, serpent.line(data))
end

function Server.recvClientMsg(fd, message)
	local t, data = struct.unpack('>is', message)
	local func = handlers[t]
	local proto = protocols[t]

	if (func == nil or proto == nil) then
		skynet.logError("[game]recv unregist message, type=%d fd=%d", t, fd)
		return
	end

	local msg = assert(pb.decode(proto, data))
	skynet.logDebug("[game]Recv Message %d from %d: %s", t, fd, serpent.line(msg))

	co.create(func, fd, msg)
end

function Server.registMessage(t, proto, func)
	handlers[t] = func
	protocols[t] = proto
end

function Server.getServerId()
	return harbor
end

function Server.getClient(fd)
	return clients[fd]
end

function Server.setClientHeart(fd)
	local c = clients[fd]
	if (c ~= nil) then
		c.heartbeat = os.time()
	end
end

return Server
