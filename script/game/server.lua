local skynet = require "skynet"
local struct = require "struct"
local serpent = require "serpent"
local co = require "co"
local pb = require "pb"

local Server = {}

local harbor = 0
local handlers = {}
local protocols = {}

function Server.startup(id)
	harbor = id
end

function Server.shutdown()

end

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

return Server