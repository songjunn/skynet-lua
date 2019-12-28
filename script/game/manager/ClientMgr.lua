local skynet = require "skynet"
local UserMgr = require "UserMgr"
local UserKit = require "UserKit"

local ClientMgr = {}

local clients = {}

function ClientMgr.tickClient(nowtime)
	for k, v in pairs(clients) do      
		if (nowtime - v.heartbeat > 30) then
			ClientMgr.disconnectClient(k)
			skynet.logDebug("[game]Kick client fd=%d", k)
		end
	end
end

function ClientMgr.connectClient(fd, addr)
	clients[fd] = {addr = addr, heartbeat = 0}
	skynet.logDebug("[game]Connect client fd=%d addr=%s", fd, addr)
end

function ClientMgr.disconnectClient(fd)
	local user = UserMgr.getUserByFd(fd)
	if (user ~= nil) then
		UserKit.logout(user)
		UserMgr.removeUser(fd)
	end
	clients[fd] = nil
	skynet.logDebug("[game]Disconnect client fd=%d", fd)
end

function ClientMgr.getClient(fd)
	return clients[fd]
end

function ClientMgr.setClientHeart(fd)
	local c = clients[fd]
	if (c ~= nil) then
		c.heartbeat = os.time()
	end
end

return ClientMgr
