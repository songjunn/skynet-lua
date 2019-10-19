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

function Server.tick()
	--skynet.logDebug("game server tick")
end

function Server.sendClientMsg(fd, t, mesasge)
	--local msg = struct.pack('<iis', )
	--skynet.sendClient(fd, msg)
	--skynet.logDebug("[game]Send Message %d from %d size %d: %s", t, fd, sz, serpent.line(msg))
end

function Server.recvClientMsg(fd, message, sz)
	local t, data = struct.unpack('>is', message)
	local func = handlers[t]
	local proto = protocols[t]

	if (type(func) ~= "function" or proto == nil) then
		skynet.logError("[game]recv unregist message, type=%d fd=%d", t, fd)
	end

	local msg = assert(pb.decode(proto, data))
	skynet.logDebug("[game]Recv Message %d from %d size %d: %s", t, fd, sz, serpent.line(msg))

	co.create(func, fd, msg)
end

function Server.registMessage(t, proto, func)
	handlers[t] = func
	protocols[t] = proto
end

return Server
